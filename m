Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39D66C982D6
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:03:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CFCB6B008C; Thu, 17 Sep 2026 12:03:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A8B26B0092; Thu, 17 Sep 2026 12:03:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E5E16B0093; Thu, 17 Sep 2026 12:03:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0CF6A6B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:03:48 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 58E201603F4
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:03:47 +0000 (UTC)
X-FDA: 85223724894.14.C8E00BE
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf03.hostedemail.com (Postfix) with ESMTP id AAB1120004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:03:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b="Dc/UafXL";
	spf=pass (imf03.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789661025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oJfQJG5iT9cSY6fKM1qSSeZ2RGZpeZorLQrHQDxjtWs=;
	b=zq30DIP+G0EKknKqZU7h1X6X6He3mswmIQGdX8i3dYu2N4InT9Qw8ZdbgqsXcQKu5EPynb
	1poRMPO0Bo9JfWJQTKU9DJpueOcwBYU8d3wpxIOFmqGRcy10hPJTaROA17IKg5j2RJhurc
	ow2QdqKow/HTjQoKtlwXHju3gQvTllc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b="Dc/UafXL";
	spf=pass (imf03.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789661025;
	b=k8+/Oi9vTb2MbCDy5pKmjPAq6VVRMIhitxvqX7FAVDvG+1HIROlR6kt8qipT5Oztz2RgTP
	0Rn3NPzsqL9rFTcXZETWYCC1gGpTKsb68PEiq5iUQkaHBCbwH3K4cIxNnxL4w06VgOR3dv
	WnsQkt0unR8ezPUHXbwNT8eChT6ytD0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oJfQJG5iT9cSY6fKM1qSSeZ2RGZpeZorLQrHQDxjtWs=; b=Dc/UafXLFe6Lpm2iB9pKZSfnKm
	70AhP14R7laKdBUH0QblXc8jkv6ORqi4r6KW07dyY0V2dGkxYL+9hymJ47S+D/fSXgUG3dzX4YEuu
	EnDfRCSLkHpKQB5WSz2BQUNdN7sIzbNug4+Osu/F9Ire3k9CZMwcxWe+PtqdsvebSm7grTDvBmbYp
	LvTdHwszMqEclOIhxseR4UEIHwIHuLwk1kQLLtvMsiceDHoTheY+jDoyzewioM8hp/qIK8fqn8w8W
	KNDdiVEYn4DS7rg/BgrwE16nCTmpJh5ZIkkviDpZNnUYbKABCCqLrwjp/I3B+YKpMqIvzFtDdqhqI
	Boll4onw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1x7EaA-00000009135-2mPg;
	Thu, 17 Sep 2026 16:03:33 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 94F49301BD5; Thu, 17 Sep 2026 18:03:28 +0200 (CEST)
Date: Thu, 17 Sep 2026 18:03:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, mingo@redhat.com,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, nico.pache@linux.dev,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	jannh@google.com, pfalcato@suse.de, osalvador@suse.de,
	hannes@cmpxchg.org, raghavendra.kt@amd.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mm: support promotion-only NUMA hinting scans
Message-ID: <20260917160328.GM4121339@noisy.programming.kicks-ass.net>
References: <20260911001826.2109390-1-gourry@gourry.net>
 <20260911001826.2109390-2-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911001826.2109390-2-gourry@gourry.net>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AAB1120004
X-Stat-Signature: ui6d9ew4xi7fqrhn38x3uzwihxts3u9p
X-Rspam-User: 
X-HE-Tag: 1789661024-571747
X-HE-Meta: U2FsdGVkX18IeZ97huKj1cLXDc6RbIwtiz0l0pRt9SQ9vZ4iqyi78iQdsn56d2HQ9LfTQ8FOPmGbqAD3tUfT0XOgypg2/BY4f0j8tuAfn/Rw5HZATopUQjYH4OL9oBtqExBDvFO7pnRUC7sMeZtXuMOjeAl+8Uq81b823LxSI9F47WC/ufz6YW0JGziGI03S7d6BDidC6XdhIrWQ0vnOdJYym/qVSK+1SpwGvo54UV4XflelSoba5nxEjl8/f7f0MNqupoNrlGw5Bf6qYU+ALV7UaFFBEsGUQ9eZSsvhVqEaEVIj4GJe20JirxTfpXER6oI+gcirkRW7aLCPkUSpiTU81dzaQO5A8fUjbgjgdp0hPhVDeiwiaQ5/mypCTHBpwmYVk0hzKPq9FceNuaj4ZG2kgKq4UmH9ZLAPiG+dT0nLCySVFUoEW+IneKc+3pmp6wYApJJbcihO1cqe5OGMTn+kXzQRQKIZFWcxZ8RPUWa3BlqVLvBeLXOWF5OoJS1pwWPsJbW2GOPDfwSGJHDHgoVknKLrQbVkke34/GPhaNHRtUm1avAlL5qqG340d2jri8GMT0Z1SbUA0tSYpE/PJqf3ASZqC6rUyyI82ZfEu7Ol4+AORmyjRmBK7VDRTHGv9Zhkbfxuy8QrKTkwl1oOKmuhWn3+fher3OQhy9twGANfQYx83PiMlM0b8P7QI5RclDzA9wH5hkC9djAzrEG2Jk+IoM2SwvrVy6HZpco5/jaGyGTEcNxf1boAH8Zraoqktn9tx1kqVX59maLxsBPCsACA6NOAmhFW7NmTvg6tHY4xfLoAmAvbvOhSB1LAlYjBICgmTdCNDgA5Gd121C6zcSpEOZtAkjEnDRPnD9q9uFYFyl8VIoOQ0Bk5bf8y2DakOy+F/CmdY9gQxTpPHt528LxtsJV1mYVRItm4PShbgBnAeoVGnjpfNrurAp2cbhOGwut6SNSt/3C1wvnrtLG
 dRlwiVVo
 Pu4hIFsvwRaZaPvFxXmyba/1tZc0vng4RQxAabY8MKHD5sNkT8mgxkIQ8jXSrOSGJbBFlKfOi7PZIFd1XtpCPOl8beb6dtsx9cdEF7naf0l51lBsRHVIiUMjOkL1dKKFhYu78UgRi/j6P7f4yadKYMIFRDw7KBeAjS2iAlhjDDpIyCG/fBa+Sv67c4x2w3/qJ/vSoHwvlCbS0rndn02pvYcX7IK50f+/vqGHrxNWwUqs64kAUrlnnJjezKTbNZf6wTWsaGfX186VT28KzsnHqxaHAzUCaxIkW2fXl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 08:18:23PM -0400, Gregory Price wrote:

> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 8dff37059faf..81359b414947 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4129,8 +4129,10 @@ static void task_numa_work(struct callback_head *work)
>  	unsigned long nr_pte_updates = 0;
>  	long pages, virtpages;
>  	struct vma_iterator vmi;
> +	unsigned int numab_mode = READ_ONCE(sysctl_numa_balancing_mode);

This thing sticks out like a sort thumb, does that want to be on top?
Typically reverse xmas is preferred and all that.

>  	bool vma_pids_skipped;
>  	bool vma_pids_forced = false;
> +	bool promo_only;
>  
>  	WARN_ON_ONCE(p != container_of(work, struct task_struct, numa_work));
>  

> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1237,11 +1237,12 @@ static inline bool vma_is_single_threaded_private(struct vm_area_struct *vma)
>  
>  #ifdef CONFIG_NUMA_BALANCING
>  bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
> -		bool is_private_single_threaded);
> +		bool is_private_single_threaded, bool promo_only);

Two bools rather than updating the existing bool to a flags?

