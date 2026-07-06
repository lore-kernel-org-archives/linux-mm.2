Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EC5AC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 11:28:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A9CB6B00C7; Mon,  6 Jul 2026 07:28:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45AE76B00C8; Mon,  6 Jul 2026 07:28:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 370DF6B00C9; Mon,  6 Jul 2026 07:28:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0990A6B00C7
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 07:28:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6FFEA8DA4F
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:28:18 +0000 (UTC)
X-FDA: 84958128276.15.3704510
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1D96D140003
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:28:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=HhCr3efL;
	spf=pass (imf23.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783337296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oKA2kC81pp4bhP84zmTGl4f9HCE5dXysfBVI/j2hjMs=;
	b=ugnFnOlGBo5Ksx9F8Bc58ZuRRo05HIVDXkVgKMYnBFaf5n2/daZvB5G0HtRKVzSABSsxJs
	BSjW84rIjp0y6XRmTldmKFRli83sUGRGWA7SjD/SdXWY42jumCrJvKWXwowVW4p9abcAHo
	AVb/QItN4WKOJmNLISM9DOB5pjhtrTA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=HhCr3efL;
	spf=pass (imf23.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783337296;
	b=LWNLDDvTOZVc5FFtQA9KXZ/rlV6OVtWgY6H/opAYB73TzHPvP1+NDY1Z9LPTQ70SgYACRu
	FQw3IRaXlupUqUHq80UXg1132fB6LyvjM0dRimFaa+aENblbOdw6d+HsjBoxJn+2XprG/b
	7NlERcKuEtsIcLWHi9YNDCiwLrM3ICw=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783337292; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=oKA2kC81pp4bhP84zmTGl4f9HCE5dXysfBVI/j2hjMs=;
	b=HhCr3efLPWWCAzDurfEZc7dEC9KsLhN7avi4npx1esjy2c3WmvIX6k4uSHuzEiSjfvXfzPXDEGPmq96+oeDzWyDpr6wwU/YTyp+QDsreRFYm5jnAfStQ9S8iWdYFo5wQRN7hO2xIq3t762z5Ho2hZDjIsB38xBIP8BNGmtP1qbw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R481e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0X6V0sRD_1783337279;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X6V0sRD_1783337279 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 06 Jul 2026 19:28:10 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Gregory Price <gourry@gourry.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  David Hildenbrand <david@kernel.org>,  Zi
 Yan <ziy@nvidia.com>,  Matthew Brost <matthew.brost@intel.com>,  Joshua
 Hahn <joshua.hahnjy@gmail.com>,  Rakie Kim <rakie.kim@sk.com>,  Byungchul
 Park <byungchul@sk.com>,  Alistair Popple <apopple@nvidia.com>,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,  Neha Gholkar
 <nehagholkar@gmail.com>
Subject: Re: [PATCH] mm: mempolicy: fix automatic numa balancing for shmem
In-Reply-To: <akUzUqQG185XHqgL@gourry-fedora-PF4VCD3F> (Gregory Price's
	message of "Wed, 1 Jul 2026 11:33:38 -0400")
References: <20260629163337.1264881-1-hannes@cmpxchg.org>
	<akKyjUbFg6ETqUao@gourry-fedora-PF4VCD3F>
	<87h5mkz33h.fsf@DESKTOP-5N7EMDA>
	<akPg4ANRetbjSP_b@gourry-fedora-PF4VCD3F>
	<877bnfynsr.fsf@DESKTOP-5N7EMDA>
	<akUzUqQG185XHqgL@gourry-fedora-PF4VCD3F>
Date: Mon, 06 Jul 2026 19:27:57 +0800
Message-ID: <87y0fonyrm.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Stat-Signature: jzg3h6k1w5zg4ao6hruu7wqx8apxdxqt
X-Rspamd-Queue-Id: 1D96D140003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783337294-92376
X-HE-Meta: U2FsdGVkX1/goMi/fSwZjPpzW/vad4qqoD+Ey2jbWfmbYGnR5e1io0AavpnqhnNv9Goo7yyYsra8ZI5BfgGldK9UR6YWRs/i1KwGK5BLT81SzNlD3QjNaRN0lUEA0k6qCV2XJeV2IwN41ldwT7aalogA7ThOZaP/4KOcSqvYVKktE9vW5Sp6hK3otJS/O4PwH8Glbq8alZaUutEVeCXcK6s4ixKaiKme+PFZhM4L3OoXBmS2RHDILI3bav3mKtmeYHbismsEdiNCuMXLk6HebgB/Y/gMGRqKJm7lQoXL+JFhVZZXlrsreI21MQm4hmsNpS76pDQ8r0NA0/JNY47gNjcBgfzQ0oTeHNOYHu1xp93djgGPZoTHAwXmh1aVqQSg24D1XqazxKakKWDn0S9OxsTCipWK5ZVBRPj12sUIfwMqZtyKKuPZrEvosusEjBzBYU85Pd56djHcxcP5RkSOnLVrpGX+eu2Mz31g0K626tAUZtqan6vlY4GlGJy86KBXP9/wHpyvJEV5NDCjP9+up3DnOoxoC4KUIc3ec8BWvoPCDq0sQrxlo+saRd4g9AUX8q4Iq5z3XTpO9bP7ZGXNU2bw0p85gbSmmt1OMNLjdGFB6ZCxfh2rtvL+mwIxEKUllb1RDwDNDE45WyJlm5DKJYpl6wb4/Rhnl3nyX0Nk8TMUNo5ws/M0HeqUJTx+HODnAn4XdiFJNnk9gSku8OSz0K8Cx2k6zK4IY5zm15NmQAhdK0WXcAXK4fYJGJXAkX0zLa5mwd0uVdqRvQUIQSerJMFpHwzJgEk64adfJX+nA2AfpV7tLMGHvG7xOFKFp+JVpZsHONXBoyTZKomgm7AzcP05B6wy2bA4BVK6cLL1N9JZAz6Hix/BUBdJB0dMrFhbwCDqF4QB5vtovtIaGsG4SXm/9q4s2ss80zjAkQFaU+5nMZ8zZCYJ3xL6uSMQfG5jGgivzpSHkaRmgGQRw3F
 Ib7URM3I
 ie49JuGHOTk6nlUY211Ko930TSHlAI7hBHEvf03pOgZ8wEB+rvZlEyxlkHZUJde2sN+q6ny5tvzdvUI6rsP8yf0F1T+O1iojX3Za9Aagdqfd2N+YsjZD9YQCB9bO+Jk5tGlSJCijyKYiVhx1TL/sHT0ycEBOgkC2O91fpI+/9vNgq3nGJaQ5ToXeSJVRk529MmO28kDGkP7Du8+dOkbEHivAd+OHt/JmJU9lyaVKTMUOjq0N1J2jBrG+Ogpxclz4GFT5cNMZUJPa+cPGvYbzgACus+7x6kLfLqB7GaiGcvttQOnnaY0AAyNoF4jwuF5bwwcmpT9rWZK8b5nzJ9GFeJ1gZwx7yOkexUsmh+NPa5+QHg7MHlOmiyGZB+L5jLmAJnWLyuiIc2LanULegynRroZtTgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gregory Price <gourry@gourry.net> writes:

> On Wed, Jul 01, 2026 at 07:03:32PM +0800, Huang, Ying wrote:
>> Gregory Price <gourry@gourry.net> writes:
>> 
>> > On Tue, Jun 30, 2026 at 07:20:50PM +0800, Huang, Ying wrote:
>> >> Gregory Price <gourry@gourry.net> writes:
>> >>

[snip]

>> 
>> Anyway, it's convenient to use numactl to manage mempolicy.
>>
>
> It can be, but there's also many footguns with task-wide policy.
>
> Something i found while seeing if i could make ZONE_NORMAL nodes more
> reliably hotpluggable:
>
> diff --git a/lib/stackdepot.c b/lib/stackdepot.c
> index dd2717ff94bf..9ceeb56574ef 100644
> --- a/lib/stackdepot.c
> +++ b/lib/stackdepot.c
> @@ -682,7 +682,15 @@ depot_stack_handle_t stack_depot_save_flags(unsigned long *entries,
>  	 * we won't be able to do that under the lock.
>  	 */
>  	if (unlikely(can_alloc && !READ_ONCE(new_pool))) {
> -		page = alloc_pages(gfp_nested_mask(alloc_flags),
> +		/*
> +		 * The stack depot pool is a global, never-freed allocation.
> +		 * Use alloc_pages_node() on the CPU-local node instead of
> +		 * alloc_pages() so the pool does not inherit a transient task's
> +		 * NUMA mempolicy (e.g. MPOL_BIND to a CPU-less/bound node), which
> +		 * would strand this long-lived page on that node forever.
> +		 */
> +		page = alloc_pages_node(numa_node_id(),
> +				   gfp_nested_mask(alloc_flags),
>  				   DEPOT_POOL_ORDER);
>  		if (page)
>  			prealloc = page_address(page);
>
> This is a global, permanently allocated, resource that inherits a task
> mempolicy's placement because that task *happened* to be the first one
> to touch it.
>
> There are many alloc_pages() calls (155 instances kernel-wide) that
> inherit a task mempolicy when that's probably not what we want.
>
> alloc_pages() is called in: net/, lib/, kexec_core/, drivers/, arch/
>
> you can imagine a task setting `set_mempolicy(INTERLEAVE, ALL)` and the
> result is a bunch of random driver memory gets spread all over the place
> along with the task's heap.  Is that really what the caller wanted, or
> did they just want userland data spread about?
>
> But at this point it's a 20 year old interface, not much we can do about
> it without making *someone* sad :[
>
> I considered proposing MPOL_F_MOVABLE_ONLY to mean (roughly) "userland
> memory only" - and then slowly trying to migrate numactl to make this
> the default.

What is the right mempolicy for these random kernel allocations?  If the
pages are used privately by the task (not the case in your example, but
is it possible?), is it OK to use the mempolicy of the task?  If the
pages are shared, what is the correct mempolicy?  Will it be fixed?  Or
can we find a way to change the policy?

[snip]

---
Best Regards,
Huang, Ying

