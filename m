Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B670CC88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 09:04:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A70C36B008A; Fri, 11 Sep 2026 05:04:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A12676B008C; Fri, 11 Sep 2026 05:04:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90EEE6B0092; Fri, 11 Sep 2026 05:04:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6948D6B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:04:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CBB45A020C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:04:33 +0000 (UTC)
X-FDA: 85200895626.11.B5A5803
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3A27280003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:04:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X6UT1K3T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789117472;
	b=QoEkeS54/I7oMiZNhggh9S2YECfUqLdKkPUz2bSexl/0fqGl/u/p1rmhyFawmik91k7kKs
	Te96Kzalokh1djnJs0H1mLBsYEZBk8j8X0fJVczfvBhLvBemH2xw7XQCJ6hAs45I+1A/Yw
	gWHuloJQWNXhrMmY6vd3bfWsgPnTCgU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X6UT1K3T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789117472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zOh6HJdMwOyTwZPThgM3pF9JLFydCnhX2MD4wVhVW0I=;
	b=X/4yr5aTtLlIEUrjdtTXagZqvASZzSBeHf9WJ7q6bBecf5sx447eEw/r0cedIFn0obTRpY
	FAdscygwOxiam2Vt22H2SD7w0XIE4Ij+/FyUWBZYHeoVNXpWha0SnRLdN9BkKlCBQ6zjYA
	c2Xw4xrN3P5Lgw4sLDf7EoOgwf+SgQU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D658403BD;
	Fri, 11 Sep 2026 09:04:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50151F000FF;
	Fri, 11 Sep 2026 09:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789117471;
	bh=zOh6HJdMwOyTwZPThgM3pF9JLFydCnhX2MD4wVhVW0I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=X6UT1K3T5SbYG/rLj0gMA02IPCU01iBO1JHmb8RCBy7pJLmK61AytsictaaG3n1LB
	 VjvNx+RpILLQJ9mKHcX2XRgQaJLizY1IjRgDA4Aty3ZnmGzvyg7RHCFHKcz+3Hd6Vb
	 u44I15tPMRaNThU0IKhW8Ue+fsELZd0tfvDBV/ER5eEdk9k83kOf5apVGz+d4fTANe
	 Xqj6KHCW/wSd0D4D/JSdkBX4ZQOYr8QJX/elKMvIqQ1i02p9xmXaJCfqntN8MgQhi0
	 0lTau+Ue99Jz4BUOPSaPAaXX17VHKl4mTnIJTHVllSNuj6aoQrJiqRNdMsiYwKm3H9
	 tNNDrXkSYP0jw==
Date: Fri, 11 Sep 2026 10:04:26 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: xu.xin16@zte.com.cn
Cc: akpm@linux-foundation.org, david@kernel.org, surenb@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, chengming.zhou@linux.dev
Subject: Re: [PATCH 3/4] mm/ksm: make break_ksm() more scalable
Message-ID: <aqPCapAzJPqDUh-f@gremlin>
References: <20260911160421076_KNXun8Mpp9Xj7fxHG0i7@zte.com.cn>
 <20260911161210082WKOqK1dumByDY7jeEOdPF@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911161210082WKOqK1dumByDY7jeEOdPF@zte.com.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3A27280003
X-Stat-Signature: ypzca839es7b4sngbodno66yrjuf4bsz
X-HE-Tag: 1789117472-466101
X-HE-Meta: U2FsdGVkX180NOmt3uydk0hjAAzr6gtji9iDMB8qJkWT4QtKKYtQNyPgzGpGEXSagGpoJ/N4evF8ZX/fEYmw0zlT4WFPZuEunKoUueyFmxXXA+3TSfwJ70s1XcZsebTL15h0U6hUC+Zs//vZ/WhO3Y2DEaH9pwEKc7tkp/E3cXjC9FR3RuCPj+OoD6ROMjXWrklJqnXNNC46y82lp2un36JC0TiJrdmAkW6eXXwUrEHQH2PkQjTLzh/dOj8A9mdtKPwA8V1ZO6ctJ6gXBDiu6Pwh+YNjAP4ciLk4AdfMrW6T3WBQ4KuUJqT3QcrmDhCR7fKs5+uYIKgQaev5YdQBUsZjhCwWSp0g0DUr2K1iHMtAVOdZ+nifD2dKRklLUeQnniW7oa7vbSoNKcJcvZ5Y+cvinmKk/zPZIiHJKND8pPhTVbkQYx7T/a2mLMi1LOhm8kXcs2qDNcpHL4BK6rlaNiAhkdbxJG9hKWzABDLnOywnNFsJkHnz6kRBR0ZFRTgGhsdHEReGTTIdQb5LC0uxUtBCdmNumyHPbcfRKpZ1d3inga6xImTJb/IGzW7vZUWAuAeQCm7ePDMNXVz9J9InjIpCDtVmdMVauR8uvVMeH2/ZvTr7UkXcnLfa+Ocau+WohOiCkLJU6OmXBg7ZHzCn/b0mtjZn1vQBRiXCLlSH7WXYtPjHYEAwxPX8Nrt+m8q3lakVSQjq6P3/GyT0QBXNS+qMPH9Cad45gF1Rj54ILY7eghSo9gAH0hn+ZO1Q7ARUoGJmd0guNXbg5HCM9RfnhNLcaAyJCzNxWzMD1Zxr/Ic45AFZSDuMzo6Nw0DH1PiYMcWLwmbhuVrWNqXPCQGRzU2OsjwTKUbP8przoXApa4cWiTY1L6Wyz1B8TioizyeneatPllFvNc53rxiQ7eB/UjNYVhK7iVDcMdNj98dPATV+AjY2KZyVsFksjUSStilg7loFG/8SKOnoe/2jE5b
 1cHZ27JV
 IHew1H28Tj1wh3sqqlgWR+VEB9a1gT5eFn1q5gV1kHjV29ENIOPyRCSLptPrC/9m+7seDPnTvqXpA9mQTdCoUtRVj6wPjw7HlgbLprlUUMuhE/neQkjaFJCqiPmgKYg0JsHc6MUH6+8T+T2xKHzo8Gj/zO7GfMFsANn3/LhWVPH8j8xadjTqEsJE+FxHF94S3MphBvKD79FnCMQ6aEhj6PuMi81dACC9f3tJ4OzGAnZqOw1dJAczRiJTZF5E2J+yx6BKoLBbsBqXeAH/nlI7+PtlrrnLUvPcZAh1l/VO7bdKAEW4j2KkRDKhSrT1qIsghHfU5bFYiqA5IPrD9MjFV8BZXK/Ah7GfveFJQdyQb/XCvVAw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 04:12:10PM +0800, xu.xin16@zte.com.cn wrote:
> From: Xu Xin (ZTE) <xu.xin@linux.dev>
>
> Currently the last argument 'walk_lock' of break_ksm() is used to
> indicate whether the page_walk is protected by mmap_read_lock or
> mmap_write_lock. If 'walk_lock' is true, we suppose its context to
> be under mmap_write_lock() protection, then mark it PGWALK_WRLOCK and
> make its vma be write-locked during the walk; If 'walk_lock' is
> false, we suppose its context to be mmap_read_lock(), then mark it
> PGWALK_RDLOCK.

I thnk this whole block is unnecessary. You're basically writing what the code
does in English

>
> This change is prepared for the latter patch to enable VMA

Latter -> later.

And it's the patch I'm not cc'd on so I don't see unless I go do a bunch of
stuff to try to download it... great :)

> read-locking where break_ksm() might be under the third new proctecion
> way: VMA read-locking, so we have to replace the boolean variable to
> the enum 'page_walk_lock', but without any function changed.

You don't, this is just horrible.

>
> No functional change intended.
>
> Signed-off-by: Xu Xin (ZTE) <xu.xin@linux.dev>
> ---
>  mm/ksm.c | 21 ++++++++-------------
>  1 file changed, 8 insertions(+), 13 deletions(-)
>
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 8df66b4e5de0..dda105681d7f 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -660,16 +660,11 @@ static int break_ksm_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned long en
>  	return found;
>  }
>
> -static const struct mm_walk_ops break_ksm_ops = {
> +static struct mm_walk_ops break_ksm_ops = {
>  	.pmd_entry = break_ksm_pmd_entry,
>  	.walk_lock = PGWALK_RDLOCK,
>  };
>
> -static const struct mm_walk_ops break_ksm_lock_vma_ops = {
> -	.pmd_entry = break_ksm_pmd_entry,
> -	.walk_lock = PGWALK_WRLOCK,
> -};
> -
>  /*
>   * Though it's very tempting to unmerge rmap_items from stable tree rather
>   * than check every pte of a given vma, the locking doesn't quite work for
> @@ -696,11 +691,11 @@ static const struct mm_walk_ops break_ksm_lock_vma_ops = {
>   * protection keys here anyway.
>   */
>  static int break_ksm(struct vm_area_struct *vma, unsigned long addr,
> -		unsigned long end, bool lock_vma)
> +		unsigned long end, enum page_walk_lock walk_lock)

Ugh yuck this is horrible, you're exposing internal page walker state here as a
parameter...?

And then this commit makes it possible for any walk_lock to be passed but then
you change none of the code to handle it?

>  {
>  	vm_fault_t ret = 0;
> -	const struct mm_walk_ops *ops = lock_vma ?
> -				&break_ksm_lock_vma_ops : &break_ksm_ops;
> +	struct mm_walk_ops *ops = &break_ksm_ops;
> +	ops->walk_lock = walk_lock;

Are you sure this can't be run concurrently by two walkers?

I didn't see any arguments about that in the commit message. Having a single,
static, struct where you change the walk_lock is gross.

What would be better is to have your own enum that lists ksm lock state or
express it some other way, then if possible have it on the stack otherwise
ensure that state can't be corrupted.

Again, if you'd sent me 4/4 too I could see the overall structure and give
advice but...

>
>  	do {
>  		int ksm_page;
> @@ -807,7 +802,7 @@ static void break_cow(struct ksm_rmap_item *rmap_item)
>  	mmap_read_lock(mm);
>  	vma = find_mergeable_vma(mm, addr);
>  	if (vma)
> -		break_ksm(vma, addr, addr + PAGE_SIZE, false);
> +		break_ksm(vma, addr, addr + PAGE_SIZE, PGWALK_RDLOCK);
>  	mmap_read_unlock(mm);
>  }
>
> @@ -1245,7 +1240,7 @@ static int unmerge_and_remove_all_rmap_items(void)
>  		for_each_vma(vmi, vma) {
>  			if (!(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
>  				continue;
> -			err = break_ksm(vma, vma->vm_start, vma->vm_end, false);
> +			err = break_ksm(vma, vma->vm_start, vma->vm_end, PGWALK_RDLOCK);
>  			if (err)
>  				goto error;
>  		}
> @@ -2885,7 +2880,7 @@ static int __ksm_del_vma(struct vm_area_struct *vma)
>  		return 0;
>
>  	if (vma->anon_vma) {
> -		err = break_ksm(vma, vma->vm_start, vma->vm_end, true);
> +		err = break_ksm(vma, vma->vm_start, vma->vm_end, PGWALK_WRLOCK);
>  		if (err)
>  			return err;
>  	}
> @@ -3037,7 +3032,7 @@ int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
>  			return 0;		/* just ignore the advice */
>
>  		if (vma->anon_vma) {
> -			err = break_ksm(vma, start, end, true);
> +			err = break_ksm(vma, start, end, PGWALK_WRLOCK);
>  			if (err)
>  				return err;
>  		}
> --
> 2.25.1

--
Cheers, Lorenzo

