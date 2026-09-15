Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11934C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 15:39:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C544A6B0098; Tue, 15 Sep 2026 11:39:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C05646B0099; Tue, 15 Sep 2026 11:39:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1B2F6B009D; Tue, 15 Sep 2026 11:39:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8CDFC6B0098
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:39:16 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 895F41603DF
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:39:13 +0000 (UTC)
X-FDA: 85216405386.06.5981E33
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id C1CEB1C000D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:39:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JxPFFrXi;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789486751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O/8MfQYi9uN0d23Dv7BLSS+gv3tKa7FgzwTFgJSGcVg=;
	b=SfKz8SyzZlCihlYiIm2x0ByGN5gY2GiUQ65GOMxJ1rpkY/P1aO7ZxCo6SlXsVU1kPW1f4h
	jSQTRxXQFNhE5gepAHPdwAB6gjor76EN0Sbn5umMchocCc62fVnmg9dJfMoA3MYC7+Fodi
	xbs8KGmhEpldCYbl/tDbTq1T7a9gqTI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789486751;
	b=0GTtujyM5yZI1WE3tNts9MRRyf5u5ccZLVP61xSIlN9vdUsC3UoXYw1oU1tiPza5hLNBqa
	QDV4EdRNn6iqE3vng3t4rnRE9pTzPlwPqjBxX0W3SeDaGr7CGBo+scHKHo18gdzjhsPExs
	K7ygYQ3Ql6VQmfM/cL8NBadKDvtkrok=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JxPFFrXi;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B607143E3B;
	Tue, 15 Sep 2026 15:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2521F000FF;
	Tue, 15 Sep 2026 15:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789486750;
	bh=O/8MfQYi9uN0d23Dv7BLSS+gv3tKa7FgzwTFgJSGcVg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JxPFFrXiqbIVZ1tnCWsx8Wp3Qe8Gg9cedEMClbUFxe5zxOtadVN6bsBCdOPD2hYiW
	 qSjzx0o4vGguXISm52sHSBMdIuxrTAl1X0ieuyA8TxAnEHMnasJM8ERBqmUwCgoUTy
	 Z+Nf9LPbbeEjeD3Fh4dwk/G/DfWoRSlx4k7mlkk+SgWG2pEsk1r+pK7Dj5qlGHFBv7
	 7Wfj6vIubR1JYr8aWRQgA0hWYesKB+28UKaX8po9Xk2w9mNx5eJ/XXstL2FDtZocKN
	 TOQlZeviA4xjRaGMxnYXfrM4z4ocgMQWX6EHCtZI8IFeAkY58oaD76ORranzr2m2H2
	 0hyJQzCMJF/zQ==
Date: Tue, 15 Sep 2026 16:39:05 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH mm-new RESEND] mm: mincore: use per-vma lock during page
 table walk
Message-ID: <aqllzrP5DpYHfOZx@gremlin>
References: <20260915143138.2595767-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915143138.2595767-1-wangkefeng.wang@huawei.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C1CEB1C000D
X-Stat-Signature: 7skk5tfmgpd5u733m3hoguysthrjdepo
X-Rspam-User: 
X-HE-Tag: 1789486751-181879
X-HE-Meta: U2FsdGVkX18E8Y/eY/ZLKoOfJpC0oxhM809qzMsRwzL/X30V9rdcyYkdNxjpUhSPpqRpXHWFF9SS6OQjDNQWAw4InR2yuFi7tHa8vyuFZgeuNWAT8P0Uu/OzZ3zDKshvONHLfcoALQ40mch95sZwoxAz7mtu3dVtAM8qLabKo3Hfru9gbxrNg04W7PhRVVs0QPRC1JLjbXUglY8zz0WvgA25TTaflW4DpLoEZdJzsdwtJko61ioNQ2yqaqOT/rRrBLoLrRyhh6/gtxXOwGIZ1Fp6pEtaWHUsxDHCGueBWnj5WaUC/NkKpwOJdtVivn6rUFsqPbGhd3rJa5g1cLAc5mfwvFsZILY/BhTUfaypItNnHnxxPeTfoSKkUS/SV3LULSo4VtmFIE7HxjI/qnXU116j8zXX5Hcn2DxLqT/7dPPBruZA/g5hZf9/6qTuSc/RXZD709EfAfb30np+YKJYehNYLfLVxwXdztnrpm5kLAo51FWVHFDVj/6i968s1xtxy2hSB30ui/zf78xoZT1VcfNZhfmKxe6u/32TIhezbLB0AoIjRD5FPUlJrZ9uhNQoZRbRqm3H4Dn3cLOgHwIvCj+bXQhCuQzD0OIuXY+i7c7UXWsJoETCdtseVMRV+CGkUWwupjvro8g0LD476eZPODyurjLPlSgt0gn/yxufmr1EbPsYsu8tgjZFv1Hx1k9CYxYbQQP+bqGK2tnjx5zhFJfFWOx6wgDYDu/Bz+TcDXg2JaqnXh0V5ji3M8bWhSZAyEAPdyN+cd2Zx9NxI2kBax/MjM63gNDnKSw7YxE4QGY5GHDTw6vfDyulZ8v0WGKf8EetdGo6GukuY4ZMuk4aoupDi9jANxEOfoStXxRr1qkiyEJazpe/TrBeMNRCvQxY+OB0TtTVzUEJT6aB3FB86j68Dxpu+4XV2OQqmn+0CSkkKo1HBBu35a/DBBrIA7b4NLJZP+RzPfD02xVmlu8
 Yylr/2mA
 eHSIx2wjMHmO+4dmtMEKt96pPiI3OpriUAlYtxKfI8ganZFqdPaL/KbjQM1HT+sUUL/3ZxPatfjl2Y0So9mP2WpPWbIjtfzQm9L2vyF5IzbrCvjECwAuG/hEXD277wEyRtmz+f2bApmDILo5hnsXCfGofJN+L3EJRH8YTxvXtMRMfP1z3ZBbPzyjsJrpDXmdhge3lf8QG21S2+/WDbSFSsFqAkM0rMvwa5+a2KgAuOLrpdWHwlitgLfTlW4iWKC2dz6SWjqlROw3GhOu+CLaltTjvzKq/f72iNLgju+238V/aBdg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 10:31:38PM +0800, Kefeng Wang wrote:
> do_mincore() performs a read-only, per-VMA residency query,
> making it a good candidate for per-VMA locking. Convert it
> to acquire the per-VMA lock, thereby reducing contention on
> the global mmap_lock.

NIT: The mmap_lock is not global, it's per-mm.

>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>
> RESEND:
> - using new vma_start_read_unlocked() API, suggestted by Pedro Falcato

That's not how resends work :)

If there's a change, then it's a v2. A 'resend' is identical to its original (or
at most - rebased).

This should be labelled a v2.

>
> v1: https://lore.kernel.org/linux-mm/20260701144047.3786939-2-wangkefeng.wang@huawei.com/

>
>  mm/mincore.c | 28 +++++++++++++++-------------
>  1 file changed, 15 insertions(+), 13 deletions(-)
>
> diff --git a/mm/mincore.c b/mm/mincore.c
> index c086836bc4bc..f989e6d1ec18 100644
> --- a/mm/mincore.c
> +++ b/mm/mincore.c
> @@ -235,24 +235,19 @@ static const struct mm_walk_ops mincore_walk_ops = {
>  	.pmd_entry		= mincore_pte_range,
>  	.pte_hole		= mincore_unmapped_range,
>  	.hugetlb_entry		= mincore_hugetlb,
> -	.walk_lock		= PGWALK_RDLOCK,
> +	.walk_lock		= PGWALK_VMA_RDLOCK_VERIFY,
>  };
>
>  /*
>   * Do a chunk of "sys_mincore()". We've already checked
> - * all the arguments, we hold the mmap semaphore: we should
> - * just return the amount of info we're asked for.
> + * all the arguments, just return the amount of info we're asked for.

The VMA read lock needs to be held here so you should say so in the comment.

>   */
> -static long do_mincore(unsigned long addr, unsigned long pages, unsigned char *vec)
> +static long do_mincore(struct vm_area_struct *vma, unsigned long addr,
> +		unsigned long pages, unsigned char *vec)
>  {
> -	struct vm_area_struct *vma;
> -	unsigned long end;
> +	unsigned long end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
>  	int err;
>

Maybe worth a:

	vma_assert_locked(vma);

?

> -	vma = vma_lookup(current->mm, addr);
> -	if (!vma)
> -		return -ENOMEM;
> -	end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
>  	if (!can_do_mincore(vma)) {
>  		unsigned long pages = DIV_ROUND_UP(end - addr, PAGE_SIZE);
>  		memset(vec, 1, pages);
> @@ -319,13 +314,20 @@ SYSCALL_DEFINE3(mincore, unsigned long, start, size_t, len,
>
>  	retval = 0;
>  	while (pages) {
> +		struct vm_area_struct *vma;
> +
> +		vma = vma_start_read_unlocked(current->mm, start);
> +		if (!vma) {
> +			retval = -ENOMEM;
> +			break;
> +		}
> +
>  		/*
>  		 * Do at most PAGE_SIZE entries per iteration, due to
>  		 * the temporary buffer size.
>  		 */
> -		mmap_read_lock(current->mm);
> -		retval = do_mincore(start, min(pages, PAGE_SIZE), tmp);
> -		mmap_read_unlock(current->mm);
> +		retval = do_mincore(vma, start, min(pages, PAGE_SIZE), tmp);
> +		vma_end_read(vma);

The logic looks generally right, just need to address the various bits +
pieces I raised :)

>
>  		if (retval <= 0)
>  			break;
> --
> 2.55.0
>

--
Cheers, Lorenzo

