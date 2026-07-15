Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 111CBC44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:26:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98CF56B00A6; Wed, 15 Jul 2026 09:26:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93D586B00A9; Wed, 15 Jul 2026 09:26:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87B596B00AA; Wed, 15 Jul 2026 09:26:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6416C6B00A6
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:26:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 00BB0A0130
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:26:43 +0000 (UTC)
X-FDA: 84991085886.30.C050C3A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6B4B3A000B
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:26:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UL1oh0Eq;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784122002;
	b=HGiBt/tEqgq3lmHU+Qm/KHGWkxtTjF4O0n9BTDBDSu4y0sZzfgsvhJfJor/GhDVYogEoDJ
	jCvDM5gGwhotllzIgBf47bcAd1vobTzVQobMhftHJgIjK09N8P1ztcDkXjAShSy+R+CCAs
	HvDn+/MGXvd72V0zyLIkDwDbhyDtEcE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UL1oh0Eq;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784122002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tmYHqq0/128SCrxfsjngrNQmfX+jHP8UqCkkUU5HEDY=;
	b=2lrhulKxHHCXpodK5Xu9I0PuqqOO1VElX4ZGfzXpqWvT6MEKB7hVZqdUO1AUfSN0P8cSKs
	sTJDkHi+nhST7iUi1NtTC5xOyRZzMmZ/7cDe+BFzrCHDfRtZdj+S0R7pAQ8q33WCjqhxIa
	H5joK7DlvOfRAJw5Nq5xhWuq1k+pAew=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DE0D761383;
	Wed, 15 Jul 2026 13:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A5C1F000E9;
	Wed, 15 Jul 2026 13:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784122001;
	bh=tmYHqq0/128SCrxfsjngrNQmfX+jHP8UqCkkUU5HEDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UL1oh0EqJ+8kpvTbuQ0OyYXKDMTRlMW2BhHcEKRAqhLn/A30MdpJca7awDnQtdJKm
	 eH7liGconcDiy6RyMcLyDvW9uoU86VTA2lZOsh1yEasDWDPpD7N8s3qYskStzdwLqD
	 4SWXiIBW0RMjK2EnIHBV364zBTEvVSSvVDp12vH/56QywovkyRBj0wc9xzFjOn4bsn
	 gLxSQajgj+bG9/w2IHFK9L63NrNB0KOl6gyVsI/tlg8KrgubxQRQYSv+TjSJ0d12si
	 Zfay2rGl7MbF5EDY1jWwOX/+VV1iqTzk48M7rplC8Y1hyZKJNar+jpd8OqULiM6ZY5
	 qpRpobpRFnoCA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Fernand Sieber <sieberf@amazon.com>,
	Leonard Foerster <foersleo@amazon.de>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	SeongJae Park <sjpark@amazon.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v1.1 0/6] mm/damon: unurgent fixes for infinite loop, NULL de-ref and races
Date: Wed, 15 Jul 2026 06:26:32 -0700
Message-ID: <20260715132633.32217-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714214604.10fc4c786277eaed523d0724@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6B4B3A000B
X-Stat-Signature: tomt7rzjei6x9ou4sbpkjs3bq79usgdx
X-HE-Tag: 1784122002-581979
X-HE-Meta: U2FsdGVkX19YgfvMZxQzGQ0HvtoUONFqOXOIvngueZk7M8GAM5damXyUlSIoY1itMlB+V1UXFYPsidjeln95GkMYPQ+ZwWiiGFzNirZqF/6LOsUhXPd2urFf4rZp4H4tiyzdK1XLXbw4O/a/rNLKo/xHARwirTupRjcxLK7uHEAwRvjy4E6b//LFkdITeOqyeuTN38n5ZAZaN1R7ZRgsAt3EM9YnMF4NJCkPe5Am/HRvUMdCv+Ntw6aMDxqd66fWyS85/+Zwn3WJARQxuzaKTbmuSFhplF4ZOP2NXs8SGQrOdBemikRFeqKR2gZaoLioZaNVpaR/4X7vFiqpjEuQR+qBewewB1NYvA9O7BUIEz60h3FEf4Kxa1sencl2+QjAudGtpiTxIHOTag/6u5j+m4T4GYeQjyvuPnm8NPKu0AttYWqx/lQOYdo7NDpgzXG03Guw7THwKW0Ki2wS6WokFFQZdJKEQpQnvU3jJZHdNDRKpEIG9buAR1sg99KSJ7Ip8xnmDszN3hbVXyBNBZkyAFOTD0xp2FDpNpjo272fZTY0Cg+VZNj6akqlpS4c88BIyNZRnV819dt6b//8mccqax3ZtYeAj20zM4KqNcQcz555UB5Ly+QpFzzj1qRB2A/Q1tW5fqMp0uO/NJNFdJ7ruv27qdU84GH6Th52bqnA/jVKMXX5le2w9QHdevOCoi0BgeuouqdxuTzfn6RapexpIlXxDWzpH0V7b+4M7qh8olQtIzegjxiKin5Z5b/z4Xf8EiDFuBYt0W0yFjI37jddZRzd7we7wIbB8ZMXxtbOzDLHL86QJw4lXlwwggabRfJpDUfDBdwKL0Zg3ixkh2JRLQP5lPDEvOqie6eh/lCKmWxEKatHtHwJ+EEOuY7anq3T1V//W+kBxHSkaubY4xfmGt6mZxhDfl3z4QlBkadYOddQlAU8jkQE0TZBaTp9NSq5t8Z/c8YcAi3mJSZnrY9
 YMaB9BV4
 7JVuR7mWsodGmNHh22iemyLoAAF3rora/5S5hl7Y0n56lz87g/gq7j9XKHqNJbzPlF56bZePAuVdobQ+ED+LULHx5gooyb0JUCyXwsRBG/Ry74UNgTlgEinreHwQWqGOFFYHEXs9WYhQYcESlpxBQgRqIqQh+15YPoZIdLMj2RL6dkqva6SGqLYH4+PLWSLvq5GEBXYFg2MpX6qmNP3YtMU3UO2fPeVPM1Yk0D15REMSADLAfsZd622hFGG5/gBeCRvF2N66B6s51zwLcz3svRWAaV7FzRmRC2z8U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Jul 2026 21:46:04 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 14 Jul 2026 20:09:55 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > Sashiko found a few issues in DAMON that could cause infinite loop, NULL
> > dereference and monitoring results degradation.  The first two sounds
> > scary but the infinite loop happens only under unreasonable user setup.
> > The NULL dereference is only in a unit test.  Monitoring results
> > degradation is trivial since it is only best-effort, and those happens
> > from only unlikely races.  Still those are bugs that better to fix if
> > possible. Fix those.
> 
> > Subject: [PATCH v1.1 0/6] ...
> 
> So... what is the significance of "1.1" here?

As the changelog says, one more unurgent fix (patch 5 of this sereis) has added
on top of the v1.

Maybe my versioning scheme is confusing you.  I increase minor version when it
is purely for findings from Sashiko and if the change seems not really big.  I
do so because I realized it is easy to get version number large in short term
when I respect Sashiko, and it may look confusing for some people.  Maybe a
better approach is running Sashiko in my local, but I don't have AI setup in my
development environment...  Let me know if this only confuses and bothers you
and you have a suggestion.


Thanks,
SJ

