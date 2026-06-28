Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84CA0C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 20:53:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E4676B0005; Sun, 28 Jun 2026 16:53:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 393C56B0088; Sun, 28 Jun 2026 16:53:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 284496B008A; Sun, 28 Jun 2026 16:53:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F24096B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 16:53:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 75C22167D37
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 20:53:45 +0000 (UTC)
X-FDA: 84930522810.30.E67F569
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id A968FA0008
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 20:53:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aUloFBqh;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782680023;
	b=xzZT4737/+8eJlKbeE+t5ZwKauvXLDJBRMZHTaSXWmwVsqyuVSmnQ5oX5ttbOT4Xub9vwk
	5ht4xRXGsQWW4oDie6+mFxvFvHU9dq/Jj1djAsYFy311klDnkNoJ+ElwtKDc7jbGcmen2X
	8j8kgJHdoap8QhtU7a87ncAoMBNvFfE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782680023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=43Qp/DZkFZa4pSVmpAAZCxaCea3bWSVMtuT4gbAZk+M=;
	b=oz/UeFrv9+LZAFsmxjTYalC2Zwi+cqYlJlNBlPjvmtUQ1gFTUmimG4v/eNxVbAqwBHZtlU
	Hi7uIyD2zLHxSHeuyJR7WxTjUKSglxpDQ9Lw6rkRPbv9I1g1LVYdoJu8kmydOaH9SnpnzE
	S1JxrKncMXGe5cX8jxvJg1XFQg0CwQc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aUloFBqh;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1F58F60054;
	Sun, 28 Jun 2026 20:53:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D98B1F000E9;
	Sun, 28 Jun 2026 20:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782680022;
	bh=43Qp/DZkFZa4pSVmpAAZCxaCea3bWSVMtuT4gbAZk+M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=aUloFBqhNDK4cnV6TVf93MMmYU7EzVvmfAA0r7uGl13Cv//sukiUTm9edFpINIiWn
	 +GHeqFIWXdpff++K7SP6GuDOEJwo4BLORaVMgrUoArCUCb0ELZGnYOlAxJytLHnbDg
	 apMSmgEtEEFKVSK/dOv1TSLQ0rbP3BB6op5EGJeQ=
Date: Sun, 28 Jun 2026 13:53:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jianhui Zhou <jianhuizzzzz@gmail.com>
Cc: rppt@kernel.org, linux-mm@kvack.org, peterx@redhat.com,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
 syzbot+18d274a59b87cf80e86d@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/userfaultfd: clear uffd-wp PTE state when
 re-registering without WP
Message-Id: <20260628135342.21cb90a7a559d36bb629802c@linux-foundation.org>
In-Reply-To: <20260601082609.170076-1-jianhuizzzzz@gmail.com>
References: <20260601082609.170076-1-jianhuizzzzz@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A968FA0008
X-Stat-Signature: n7gyqzn63eaxt7h7jfj15gjjkudf767y
X-HE-Tag: 1782680023-29006
X-HE-Meta: U2FsdGVkX180u4pVcxgEvwt9/DBCyDhqJ9tz2LnkPQ+iP57XVBKoHIUs1Da6ewkkW0Kol1+FpP2wEmycPmJ4x6cv9ynuKTeYptMnR37aozPtkScNIkpwNei2qhCV8YD9ZqnaDUzoTK9+XrNvDbZYGZOKs8C1dsKg40rH6lQrBzNNwFACcnkmWe1CkiBowQfwPZJnmnzkWo0JuxV+hNIZvZoHE8UYTM1l7fyyaj5ex9B5ffEWkpioVUoOVpaJgE3JbErvkfXTZ2rdqZaWLkLD4HuzBiQs6lBaJyhanJ+e2EDQNOYYMgQMnsXRYOCRg7byM0sVmSVc0IpQqMcgN5W/lxHiaGYW3T4cz2pHSe+3FZeonqLhI9RfyXBpgdDq1Ct9jIgCC606pvgeCpa0WQKZXCd0nyWjVhcnAua9JVVGbussJr6/srq2jFfLw2JUPcO6Fl2MjMk8+O3aj9zud/1ChIBxRGrGtA6DssGFrqUmRtTReVV1E1587XEMlFUwAKX4M8+aE434inmSY5yOsijywZbldgYqnud6j0tjp3xvUneIdYlmxiWm4VtFG5Ktvlmnwp1ypkMO2knxP8A77+PYTiaOXqrwz5t3R+hRZak+7gGi5jeFMV+Sqs9YXhvYUDAUp8iMi4Qit2bke+zdxy2FBZEDhPQeuseUABsMF//TYbZWgHiBBAHEILM/8M3hcwyXfmUA1BcNmneXOdBXT80pUOjrSIuPyP90+sp9jnVJJnbziMEQZhuwh+TXJt4Sa36fhH/Yz05klGSIUBE8O11g8kjWqdfVP0lwIL+1pt5x+RvNeOzHFXCejRziCZIIyHwr3i7JCKQdcLte54+Dsq/WgqFYOhRcgbXjeTe6AOONx3ZBr853xMfbAIUUIduPu8C3UTsDoApD2DKHVo40pDrrE/NhaK2yDqXO85MSHbx7StA9fXvBJYz5G/+VmCkRdOXiguy/Q7aIkMk/594lTKX
 9AX8GaFN
 jgtf1U22AiFfVCLGElQREw37tiVJXDa8CAZGMzw+sF2LSnSi0k4m3fA8lRNY2VGac0RR/Iuc2Cq6DIfE/4ooafvNiwkTZH5CEIGmwCq1lufeaRJRff58OsqLL5ZL0S1edrrtCE3aUXY+uf8oYBfodNGYGnTBJRw7OHDrn9jWtxTaLy3fE/MVbLvbB2aAATZiWHPvF1wvPbXgoxTIfqcV37ZyV8zdNLbAIAFOjKJ9n7erBMR89UhNtQO+7c0IIIwWplLSHrXaMoe494qv7Ah4n0y7bE2LEGJIzQ6ZU5ZteleNexpJwfJuaKO4O0u+hOpQy/KUQDkq5rfzhvfh/VP9LQf5jii987xZbAof3W76EI+d0OGb+0+v7ULpV9dfv0QTVzo+keeXwFOPt9lWdz7k4ToNkpZewT94u0OaPXdTqsDWVdnuAVno5868iEsixVFg5pF6sULWoN+7p6Bm/11I7Aexc6oN7D5C06WJB+0i3ciWn539qwid9caec5pdxRgaFUaeo3lhJaG1IusI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  1 Jun 2026 16:26:09 +0800 Jianhui Zhou <jianhuizzzzz@gmail.com> wrote:

> UFFDIO_REGISTER can be issued on a range that is already registered in
> the same userfaultfd context, replacing the VMA's userfaultfd tracking
> mode.  For example, a range can be registered with
> UFFDIO_REGISTER_MODE_WP and later re-registered with
> UFFDIO_REGISTER_MODE_MISSING.
> 
> When the second registration removes VM_UFFD_WP, the VMA flags are
> updated but existing uffd-wp state in page-table entries is left behind.
> That stale state can survive in swap PTEs.  On swapin, do_swap_page()
> restores _PAGE_UFFD_WP from the swap PTE and can then install a writable
> PTE, triggering page_table_check:
> 
>   pte_uffd_wp(pte) && pte_write(pte)
> 
> Handle removal of WP mode through UFFDIO_REGISTER the same way as
> UFFDIO_UNREGISTER: resolve the per-PTE uffd-wp state before dropping
> VM_UFFD_WP from the VMA.
> 
> Also make the same-context fast path require an exact UFFD mode match.
> The old subset check treats MISSING|WP -> MISSING as a no-op, even though
> WP mode is being removed.

Thanks.

> Fixes: f45ec5ff16a7 ("userfaultfd: wp: support swap and page migration")
> Reported-by: syzbot+18d274a59b87cf80e86d@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=18d274a59b87cf80e86d

So we have a WARN which can be triggered by unprivileged userspace.

The patch arrived during -rc6 when people were reviewing and testing
material for the next merge window, rather than looking at new changes.

> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -2153,13 +2153,21 @@ int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
>  		 * userfaultfd and with the right tracking mode too.
>  		 */
>  		if (vma->vm_userfaultfd_ctx.ctx == ctx &&
> -		    vma_test_all_mask(vma, vma_flags))
> +		    (vma->vm_flags & __VM_UFFD_FLAGS) == vm_flags)
>  			goto skip;
>  
>  		if (vma->vm_start > start)
>  			start = vma->vm_start;
>  		vma_end = min(end, vma->vm_end);
>  
> +		/*
> +		 * Re-registering into the same userfaultfd can remove WP mode.
> +		 * Clear any per-PTE uffd-wp state before dropping VM_UFFD_WP,
> +		 * matching the UFFDIO_UNREGISTER cleanup semantics.
> +		 */
> +		if (userfaultfd_wp(vma) && !(vm_flags & VM_UFFD_WP))
> +			uffd_wp_range(vma, start, vma_end - start, false);
> +
>  		new_vma_flags = vma->flags;
>  		vma_flags_clear_mask(&new_vma_flags, __VMA_UFFD_FLAGS);
>  		vma_flags_set_mask(&new_vma_flags, vma_flags);

I'll queue this for 7.3-rc1, with a cc:stable.  f45ec5ff16a7 was 6
years ago, so there's no rush here.

I don't know if this is the best fix, so I'll await reviewer input
before taking it any further.


