Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72BE4C55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 11:01:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FB6C6B007B; Wed,  5 Aug 2026 07:01:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D0406B0088; Wed,  5 Aug 2026 07:01:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BFB76B008A; Wed,  5 Aug 2026 07:01:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5A24C6B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:01:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DC3451A0454
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:01:05 +0000 (UTC)
X-FDA: 85066923690.14.2DCF337
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id DE8C8A0017
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:01:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KSGDHbe/";
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785927664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qDsAuiAwi/V/y/EO85Gmfy8jVW1Pmelx7+mpYdcm6Zw=;
	b=oigFBu8rfQTaO1L8dAJE5EtdSdVKxA82Kv3jsMRU4dsYWZw3GZpG9t9GUMM7ccMQVTaMRj
	fggstB1nM3/8N+q873zRAQ//zHym/jKen1wQw5xPUnKh6sgbOUDnZlnrdvDO/UNWNTTPfi
	DEJOwy1PASxMeYU3Wssq/ab9rfh8xc4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KSGDHbe/";
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785927664;
	b=qD86TAHZY9+RCCcgbPfBTrAcDK6cVWchmHdihnOjmblrdtjoz9PvcVIpXagklK379lIZyn
	Kmh5fw/3U8MwJkLVFRoH4k+CbbLjQUjEjqWgM6A8FcHgPpQFTEtsJAcOiIZzXNxio8aiFS
	RD8dfpECkbTXnSdloY7hBuPfGdEhjzA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A2024552D;
	Wed,  5 Aug 2026 11:00:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E58A1F000E9;
	Wed,  5 Aug 2026 11:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785927655;
	bh=qDsAuiAwi/V/y/EO85Gmfy8jVW1Pmelx7+mpYdcm6Zw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KSGDHbe/7YJtFj0m6LTmJpBaFhVs4pI+dlDOkzJJneOzSG/8GNA3lzF5zTblku03H
	 Dc8YqSOTy6EhJRhp68QHmNeFaP+VeFaX0Ayp4VwHgcphj2jokMinhNCLpHuT6vQFmb
	 r0CP0o00IkvU2vGB1d55NZbokuqhC29gaDmC0Xmu+4BMeDR5d6VodStxZfD4+eaLfj
	 8IQGlJH+BQ1FQ5p8Vj/vZOjthOW/4KgTYjMXi784ImfMxxitGx7sqvVsSA0lrEVmNW
	 f6d1jt9PLXumf8BQLJaKSHMj5q+Ynd1+8t9hJ5WWIQjdDRRgLjmu58OS/Icodq/OEz
	 MCt4hEYwpDQZA==
Date: Wed, 5 Aug 2026 12:00:37 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Barry Song <baohua@kernel.org>
Cc: Hongru Zhang <zhanghongru06@gmail.com>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, david@kernel.org, liam@infradead.org, 
	linux-kernel@vger.kernel.org, mhocko@suse.com, rppt@kernel.org, shakeel.butt@linux.dev, 
	surenb@google.com, vbabka@kernel.org, willy@infradead.org, zhanghongru@xiaomi.com
Subject: Re: [RFC PATCH v4 1/3] mm: allow page faults to request VMA-lock
 retry
Message-ID: <anMV_Kf6nqS1oKBA@lucifer>
References: <20260804095219.46213-1-zhanghongru@xiaomi.com>
 <anHMe4jFT9EIQe5q@lucifer>
 <CAGsJ_4x_ed4m57-8rZ53PBoGy-aa-z1thOvGOp7RAb2qP28dKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4x_ed4m57-8rZ53PBoGy-aa-z1thOvGOp7RAb2qP28dKw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DE8C8A0017
X-Stat-Signature: p6kfia65pqjtbbdjoppjqfmzyyzfxyzk
X-HE-Tag: 1785927663-176948
X-HE-Meta: U2FsdGVkX1+pZSm4wZ3X6bVwLDjHIPHLUmbHOY+RpUodPbq/MWw1ZCXrSiGlFz/M8fWw2EQXrqOInSH2028uBpHlRxeMnzHGxVZ2rpzRJEXhbrfjeGGQvHPrPVP8jcLAY2hITUY5+LmJ2iEgviKu1mVMtrfTm7fjUVZxwKHFJTiCeFb3W7WkPbB3mCnbqLEZlNoxHFVZZCIyqxbbkvZ8pFQt+KOF9OUOuTkMIOqKM1R0R9R0BhPPlTMhwSEeWRMNXppK6pjXVcKZYcZdGDrPoiSZQIef8thIriVLGRzSg5SaHJnhod2oHCu/A47hHhiAigKtCv4ynDCgQ3JsrPFFbozGJENGql722XPdwIebQjIEwH6NX/WeNFT8R7jXSYTbP4vd2eRHxIzLxM5Pj7mTic25MK+3lrRzlPpdM86h+17E4Hg2OImKjD7EpyyXIhBPtcRXI3G5KC5uSZzsrRcYug6TuQbDhSJFXnDhliqow+KcGKxai5rhl7zfAHq2LsM7uruqm5otTtro7cwMJZCEog/tEB2+0oyoGpFrCqC59uSs0ekNpqYE4aXfzmV8jlKUvXFhuHDgq3iTdahTAffkSrH8+NdROOY+dUKfPzwNrVX7oKNJjnbgTyMCaSLu6YjnxtbbBtnWTpq+z9/w/5sgXzX59LHurgv6Su4INEOkXoNcpjs43xTMCLyClR6kyycFbNvSx4+oNegcsH5ktcxc3ER1mB30xgaEHe/ihPBXgpTMV7HXcsZc2wlGxhfAnlAKvi/inQwaA7a6prOVHhaPhodKgXeQjipMgG/oi8JnWG+/lOLtifrfeNVikxljVwlPUm3kT4gBBhq97QCXixpiDx8FmGhwQycKrevro9Tu+1zjAGcwMqrsh1ittDp4bERlj4kfccioEh/abA9T1bX2SZV3GoH+E2f1S9WC6X4tAnwj7lO4ooU95HQAx3OQwjUTTJPaYFAiXX9vIV8L/wc
 ybJaG6FS
 UvrC1HNSyNRLfmPYB+kc0wbrqJchxQbpVvi/9Nx2EfWEp8/2m07UIl02CbhNB5F09kaZB1WZBLUtLUP+mgQjNAemPkc4+IqTpBfxR6rYKal29wZMzB+LIIRDbFKxwwbykUVpkbvooDDrjiC7v7OqGx/u6lrsz7DRZh+FLx9/lvtGXMQ05yRujV+cgGXpKB4+BwB6y+HUmzD26cWCwMG+UF0AGS/fm14Ze5TAMyMpR/tSsM5CnWsa2fu5Mh/Xxz1iEpjr9z7SqETHYlgovOL4o6A/gVi//kxo7IyZIh9cfS3YAiOHXa5GyYY7WPyQy0gytiikSOLGE8kjjY3Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 05:13:49AM +0800, Barry Song wrote:
> On Tue, Aug 4, 2026 at 8:32 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > On Tue, Aug 04, 2026 at 05:52:19PM +0800, Hongru Zhang wrote:
> > > From: Hongru Zhang <zhanghongru@xiaomi.com>
> > >
> > > Page faults handled under the per-VMA lock currently fall back to the
> > > mmap_lock path whenever handle_mm_fault() returns VM_FAULT_RETRY. This
> > > means that lower-level fault handlers have no way to tell the
> > > architecture fault handler that the retry can safely continue under the
> > > per-VMA lock.
> > >
> > > Add VM_FAULT_MAY_USE_VMA_LOCK as an advisory bit that can be returned
> >
> > I don't love that name or that faulting retry behaviour is _modified_ by a
> > value that indicates fault resolution state... ugh.
> >
> > It's kinda confusing things 'VM_FAULT_RETRY' is 'you have to retry this
> > fault'.
> >
> > 'VM_FAULT_MAY_...' is starting to bring in effectively configuration
> > options into it and that's kinda horrible.
> >
> > I mean is there any reason we shouldn't ALWAYS do this if a VMA lock was
> > used?
> >
> > It's not too expensive to do a single retry with the VMA lock before
> > falling back to the mmap lock.
> >
> > So maybe simplify like that?
> >
> > And like that this series becomes a single patch right?
>
> This is a brilliant idea. That's a genius insight, Lorenzo.

Haha thanks! :)

>
> I guess the conceptual model could simply be:
>
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 45b99c3b1442..3592bcc9bbd7 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -1222,6 +1222,7 @@ void do_user_addr_fault(struct pt_regs *regs,
>         struct mm_struct *mm;
>         vm_fault_t fault;
>         unsigned int flags = FAULT_FLAG_DEFAULT;
> +       bool vma_lock_retried = false;
>
>         tsk = current;
>         mm = tsk->mm;
> @@ -1331,6 +1332,7 @@ void do_user_addr_fault(struct pt_regs *regs,
>         if (!(flags & FAULT_FLAG_USER))
>                 goto lock_mmap;
>
> +vma_lock:
>         vma = lock_vma_under_rcu(mm, address);
>         if (!vma)
>                 goto lock_mmap;
> @@ -1352,6 +1354,11 @@ void do_user_addr_fault(struct pt_regs *regs,
>         if (fault & VM_FAULT_MAJOR)
>                 flags |= FAULT_FLAG_TRIED;
>
> +       if (!vma_lock_retried) {
> +               vma_lock_retried = true;
> +               goto vma_lock;
> +       }
> +
>         /* Quick path to respond to signals */
>         if (fault_signal_pending(fault, regs)) {
>                 if (!user_mode(regs))
>

I seem to remember Willy didn't love the idea of '1 more try with the VMA lock'
but this isn't _quite_ doing that.

If we spuriously can't get the VMA lock then this gives up immediately and goes
to the mmap logic without a retry, so we're not doing that on lock contention at
least.

(We could fix that with vma_start_read_unlocked() though which would handle
write lock contention by sleeping on mmap read lock until the VMA lock can be
obtained - though we have to be careful about possible lock inversion vs. a
writer maybe?).

So it only retries quickly if a retry is requested by the fault logic.

I guess it does end up working nicely then - because if the retry can
immediately succeed with a VMA lock again then it does that, but if it can't
then it falls through to the mmap lock quickly.

(And use of vma_start_read_unlocked() would make that more reliable vs. lock
contention.)

I think there were cases where we thought that might be the case (though it then
makes you wonder why exactly the fault needs a retry?)

(This is assuming nothing in the fault path would sleep holding the VMA lock,
which I don't think can happen?).

> Nothing else needs to change then. I wonder if there is a cleaner
> way to implement the idea, but it is really stunning.

Thanks again :>) I'm not quite sure this is really all that clever, but that's
nice of you :)

>
> Best Regards
> Barry

--
Cheers, Lorenzo

