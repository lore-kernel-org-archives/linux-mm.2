Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5059EF46139
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 15:25:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4A676B0005; Mon, 23 Mar 2026 11:25:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFB566B0088; Mon, 23 Mar 2026 11:25:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C11B66B00A1; Mon, 23 Mar 2026 11:25:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF4B66B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:25:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 302D413C11E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:25:00 +0000 (UTC)
X-FDA: 84577700760.12.4D7F912
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6122C40015
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:24:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pYTC+H9h;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774279498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y0cRoKPzQWvzL8rZ0nDLymK28GipspOdtdBw/jsbx3I=;
	b=28upAnlgFLaEEXwY8eXQImsg+XW+AR1IZK16TDh1IRlM1vhY5nUc4rM5cVOZjZS50CBqHX
	AR1QpweuW1QQ+Yhy0E3nHcIWNjY16TH6yrFpWgHCtvC8YLSbyw0O4E44iPS0CkmNHm83A1
	U84QtbiawlSSGc/6gxPZgM/UCsTiw/g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774279498; a=rsa-sha256;
	cv=none;
	b=4IliUBqSnwYJnf9U2+X1pxW/FRS/0cJURORMrqn6yeNcR+fubTGQ6TyzT3REvYZQ5W1/VB
	1NLFDRRNImcCaf5khusaYg26Yps55Bx9m/wC9K0Z9l5gvOo35eDcq6oC0zNMfBVhDl8HZc
	HlVOp4GpBbYy8X7oO5VhbDqpRNXGj0c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pYTC+H9h;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 567B842A4D;
	Mon, 23 Mar 2026 15:24:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0760DC2BC9E;
	Mon, 23 Mar 2026 15:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774279497;
	bh=NA2N81AT5PzD0cDhFaHpfI6i7VObtWBhojAn3TCi0S4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pYTC+H9hmRezcuCZ1HcC9go9YWwxE7ee9S/lVdYZvW8px4CyM7Gm/nHDJ45wAO8vm
	 kmYWyCOBhYLomKgevMNM8jcRiULkOlLzykvuLNKG4PYR3YM2nn5ZE9GzQMQe7hm5Si
	 u91OSV68C082COP1aNdEZUmcfVnYzXzQFDwh/qyDFSVDjRnwbsbU8pC2U7MjhTxQ22
	 rqzQsxO2ldnTvi5zMU+L9zTW35RpgSA+qwN5GDmFEkJKD77oMDi9cS5WmNg4NFY10/
	 IBr56DYoIcrBdWvfQAlSjevhmXKMblQPzKJx34gyrHFbmEa1mVRQCEq8QH+rSYLxyc
	 AkfPvE1wctMhg==
From: SeongJae Park <sj@kernel.org>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: SeongJae Park <sj@kernel.org>,
	Josh Law <objecting@objecting.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [v3 1/3] mm/damon/sysfs: fix param_ctx leak on damon_sysfs_new_test_ctx() failure
Date: Mon, 23 Mar 2026 08:24:52 -0700
Message-ID: <20260323152453.81603-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <0bf54287-b6c1-4359-823c-e47db6f7830b@web.de>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 5kygnsgczxwcsnmd6bybhe343gfg8dau
X-Rspamd-Queue-Id: 6122C40015
X-Rspam-User: 
X-HE-Tag: 1774279498-329018
X-HE-Meta: U2FsdGVkX18eAAhS34cZXLMb4E8fxmEpe3GEXwv9GZH3rFj2lqwF2fmCpp9QC8KC2R05NCBAV3CA26q79UyE3TjHeM3lApsF8UgbVDP+o68ZL/IUQkFqqixokQzxJ1w3rmg5B1EHoRDG1jaDSzzQVHsCnzQpMdWVZb1MK2JhLALFLq4JWy8anlcET9D5/5Eon8FOchP6KvhdlkuHxeTwE/eZBGY1vcDMu41TZV8tn/dAu1NrAauJTMRIglJLm/9aFvi3AKF+uxT79wSUIXzICZMAqGtqhG+Ra/YV3K1Rr2C+mu1BQ3vW6Lrem3KZ6V23RBkM/vfWSl9NP/D9/wnvIl5yHemWesriPYzCrGVpVqp10LVuj8tYTBq16iya91TCFGaB1k8RlKm4BVkMPiD1b6xEoBSWEPYdAUa3vIsxcJ4XnWZBpDW3NANPCx/2Nt/TgBw6j9Y3SB03LHY6drMPi4HqxscUALzc4RJfxUDtNgRR8Xp+EyjOfMJ5hHzDY3K6uGoYVziHf0mpK6Kx9x2sxSyY2V/osXaXWutUuXzrb3juUTAhiHcdxPaQt1svonE2ny7o0fUREv0xhojj7Cufl3rXVj5b18ITEdvQcMKw18SUvOXmU6V3vLPEFcy4Cvt3hGivPxoSmvQLW6kJefVoxbDeqqa//yqqYnuFJLX/ZUhqg7riBYfXvcuvFthLXpNcb+zbUSPRT9OKT5cVFq7tx7E69uU+LP+WELXXJGWc98fHYj8nHoWI1/n5VES/TyWnKqPqI/qNoxnnZHI2xUet9P/LETyU5db4NlTnAsRRQHXwRizwnWAjmiIcXSBzG+5dXfRNzi/nJJFMq+EeK2gtPRQZ2VpgBwha+omfU8Avu2Bl49i6DIrPzj3jKXHjv4w7M1wt9ETuTu69uWIeMCs24bRLh9DdWUJA9+t6msiCikWXOTQSG8ho02LbIaZtquKjYx57swYlsDPrm+Fsz/u
 qWUAoChH
 tuQ2PNsrRrTbWBhYKhe0XWMQdZJrSMXk1rxZ8SjXOQitxi1EmEzOIrW1WW0UXZG14oma6Zkpq8EVpAIccVs21ndGCFUeZ4M8yI6tUC583ZxitnK8IskD7ZQISq8o9jnKYT+jIqbNxlPd87IXqKKVA3myO+AXkECAhIdy28+oJJo8u9DXs1qNCR5dc7FZy8tLz9z5Y7DChqQLhjbvYZiixd2TjjvRRtlCYjVQJlaBTVSd3GDlhNnjG8t0MkyWKm7eudDA4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Mar 2026 09:25:52 +0100 Markus Elfring <Markus.Elfring@web.de> wrote:

> > Markus these patches are already merged

It's still in mm-hotfixes-unstable.  We can still make changes if needed.

I understand what Markus is suggesting is adding another goto label to make
the flow cleaner.  Because this is a hotfix that aims to be also applied to
stable kernels, I think the change is better to be as simple as possible.
Adding another goto label could make it better, but I'm concerned if it will
make porting difficult.

IMHO, it is better to do that as a followup cleanup, rather than make change
into the hotfix.  Let me know if this change is somewhat critical and I'm
missing that.

> 
> Are there still development interests for the application of a better goto chain?

Sure, if it makes it better, why not? :)


Thanks,
SJ

[...]

