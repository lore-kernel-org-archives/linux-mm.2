Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95BE7C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 00:43:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D9F96B0096; Thu, 27 Aug 2026 20:43:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78A976B0098; Thu, 27 Aug 2026 20:43:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 655116B0099; Thu, 27 Aug 2026 20:43:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 31F4B6B0096
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 20:43:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9C95BC0238
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 00:43:08 +0000 (UTC)
X-FDA: 85148828856.08.4B70A5B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0028240003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 00:43:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c847cadk;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787877787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T87Xp/BR5t2O3uUoAmc/qvDQWvI26lbsg+l1hA9mgNw=;
	b=Gacox/27o+oDJewJSa6KXykOqj7Jt/FmcbOV1laCB0+puiXQ8RaYrixEoRDvzC3q07/r4z
	T6dYGjm1q7ESmqGiw4S52JcMDQW2cPoEkb/+l7TPLP8U5YbOXZVRr3ngfO/PSjcxrPDgVw
	3rnRny0fUpxAzhEK2DJKN77qo5MAbHs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787877787;
	b=pjtmJdyO70lToyxsblffioLxW6Vs70gayGX5QieolhKChCce4cI8ErAgcoQEkxuQ6tLqox
	KSPAmTiRbRB8Uh/0LTdh1keghtcPK7L/2xf5qrFOhjYCRCIE3r21t2EACsKP5sAdfYzEYx
	GVVhPfPtElYLukOrvzftEkr40NvvTP0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c847cadk;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2ACDC409A3;
	Fri, 28 Aug 2026 00:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816F91F000E9;
	Fri, 28 Aug 2026 00:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787877786;
	bh=T87Xp/BR5t2O3uUoAmc/qvDQWvI26lbsg+l1hA9mgNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c847cadkHTV4MMsUMsYvKJ1Q3pvvHqq8bxvLQL6ZBlWldtiC8iar510tDnnTPy27o
	 eMmsok90bzuluPAW9KlCUqSPQd7AWzOl6hU0UtHWRRoXhiX4xi+W94K46SOZfOSAdu
	 4nXdJv+qJPNS5hpvDTUEC7Lvmq+GSuBmfMs3YUl7Dqe4B2+x+zR437zpCCTC3x/VP4
	 z1mrNV26IE5KDnyKyzMEJ46CsBpzeT7cwlQNsOMnyZSR/pBm6uX4/VPfSku2zSuFyK
	 SzSkuzNkRGEcaG0416o6P+KQZNDydxm8bc/EWjUf9+D6GmLLgp63Zofq07xe45V7It
	 CzZZoJxHJKwCQ==
From: SJ Park <sj@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add myself as a THP reviewer
Date: Thu, 27 Aug 2026 17:42:57 -0700
Message-ID: <20260828004258.62906-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260827103435.1371882-1-kas@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0028240003
X-Stat-Signature: f5nj1my5jskehxdz945613pnyyu4zdue
X-HE-Tag: 1787877786-425871
X-HE-Meta: U2FsdGVkX1/F9n7fMfedonVTu3JVu7mYAlGV/y00GQDxQNuw1OJYlci/N7JB4p3+utj8JjmU/4WtXmklsn7JrZUqTzDkoX5/utjzeS/2j2rbCIMaJG7oe/ufFsUyV2WZJPq15Kiplv6m9/17IatmCOQTDA57EH7uz1eBXQbnDTsjgL9H1niMGdEaOFuZ3Q+WgiWoqnFgyFsbIo3k3s9T6dS+1FPPMa8+SU9NUJIzLBrZKnPjiIIcMZRQbg88/d8GpRhzLcOfHY1Chuqq1MZXCaplNkAI+zk/FrEHkYiK7627oqmrq58BC/MA4wl2q3MvlvaFZwyGVixDJPNWCsF+x3K+4aJeCVuyhHMvvRuRUrGDp5zqhZkc/9xAN08LgzdlFgIWjryTzjTj/FOpW1C/yQL/ymEZyMIkGMyIU3ptF9dLA4oFTLm0z+bUqRSyJrhp5IUzyeJH1PebHzmGxww4aqHtyrx4aZ6Wd0iVffRPnn43NApx/S0Se2imxyY0oUEyQvvyTN5Qw4tvoziwpkDW7/pwJUGY9dSrySbeVuT8ob4djhgD5b0kEFuG8OW2XCbi4ZT57NIfKD36GQ40qc7BncZkdd+ElQdndflP1B82MbpO5re4aQ5HNgxXJ6pBcPAsU7KiQiDtKwB0SuVhz9lDPvILoQGt6kNNQk9n5VGuzjY5sHnLlO37rpUMQqItbFiD3Feh3j8YO8qmcP+wIJ/wUrg3/+ySnXR2w/brZqyflfVIHY1Fadvs/5oz/BgqZe93K6urMUjiAlNeRWxjNw6kFGZf7VIUasvNv4i2w7Mmbd6zJyno8cxKUeaG8YAKkV1HyFKfqUmjA7jri7b4+8+ZRJRJS/s2QEwc3Ja7sSDhfw2hlx5PzOcMB+BnrY5f0CJyoXzOd9QFIR88cdGq5NjfFKs4FCyAFTLCtjkhkKF6fIpFGvbEfLSRk69i35u89QgGSoplrG7dd89yaAROmRx
 GkMsMPTQ
 kebC5gs8OAZ8Lc2i07anqxsnaBhqJ+zWslZ9w1dJU/5wT/ft327FlydYHUvZlWlqHiKktW32oDrcTNrYwD4p8D6WCqn/N3pVNtH99aM+8GTo+354PYce0PZ3Az02yeFEH9cK+FVTLXYoReplkq+N4aCt+Q1wSWsg8LBZScOC3dH9IgXL5/qtaBRyl01t4x50KL5yNNPe847Yv63soHaQxaMmDxqQA/Lv2cw56gt/P/KHNQ6k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 27 Aug 2026 11:34:35 +0100 "Kiryl Shutsemau (Meta)" <kas@kernel.org> wrote:

> I have been working on transparent hugepages since 2012, starting with
> the huge zero page and file-backed THP.  A lot of the code that causes
> pain now traces back to me.  It is only fair if I share the review load
> for THP.
> 
> Add myself to the reviewer list so get_maintainer.pl puts me on Cc: as
> well.  It is also my commitment to be more active in reviewing this
> code.

Thank you for stepping up, Kiryl!

> 
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Acked-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

