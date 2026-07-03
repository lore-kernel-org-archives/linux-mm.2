Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F208FC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 06:24:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C5F86B00B5; Fri,  3 Jul 2026 02:24:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9758C6B00B6; Fri,  3 Jul 2026 02:24:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88B6B6B00B7; Fri,  3 Jul 2026 02:24:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 568F86B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 02:24:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AE1E51682E8
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 06:24:25 +0000 (UTC)
X-FDA: 84946476090.21.8E6DC89
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0EA2180003
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 06:24:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SJGw1s2I;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783059864;
	b=ivnP7VV8FKOm+5e0JFmRGBp9ZhI/8bpfbviwQFZJAnm+LWo0hMXB2dbExWrEzPKFh01Er8
	0wLNly+g6mllM2rvYUTcz0urK5Vnfw+mVGKfkpySYtAsYaZjgQcDf4jl9xdscQlz2dA58s
	o3Evmgy7BjLCsbsyKIKObwPREGEkALc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783059864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VSCI+9VMFGhzZ4DHrpiIFSYVmzhFlldpQab5ARttNrE=;
	b=JruMT74GesTBeFqgaFRhkNyatnpzF1yr4ar+Wfo8Zb1SAbryK2nvXwpenv8d27gW2RgbKC
	JYRGDwTY9IOoimOYIETxp/IbN5sNJdF5B95Z0UwvL56EuufZ00EWh/iyGO7MHXxDHxredO
	lkIn9DUdMkwIN05OtaQ0bpVUj8MxMVA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SJGw1s2I;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A7A94349D;
	Fri,  3 Jul 2026 06:24:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0031F000E9;
	Fri,  3 Jul 2026 06:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783059863;
	bh=VSCI+9VMFGhzZ4DHrpiIFSYVmzhFlldpQab5ARttNrE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SJGw1s2I3fN0rhA453Szz+Q90oqWuePSgwQLW0OiR0tHPsGk2ShFtqQLeGlQe0ylE
	 UEmr+1XISkkD2hI+MuqB/fvupdy+jzj4H/Usx18ttHKGI6nwBUbijJ/gL8ocLk34ni
	 W48nEvXVVv6YEYS+y10oe2abN6tD3ze2D0Stu4mWrsboocGIr9kAo8WuTurJ9YVh+h
	 rdSczdSkFnFEXqT7ukJn4YrSUsd4QNRxMzPrYY8i2wQ6o4QrW98Z2SOI/n4nFd7w/A
	 PXFWSqOmZ8Vrz81/Pz96SeDwZ99lqvbXWOZICtd88TvEWHEhbb7c2TKfWt8eF5CQiW
	 e4S3CSmPvRuCA==
Date: Fri, 3 Jul 2026 09:24:17 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Jianhui Zhou <jianhuizzzzz@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, peterx@redhat.com,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
	syzbot+18d274a59b87cf80e86d@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/userfaultfd: clear uffd-wp PTE state when
 re-registering without WP
Message-ID: <akdVkekOyiE2rtnl@kernel.org>
References: <20260601082609.170076-1-jianhuizzzzz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601082609.170076-1-jianhuizzzzz@gmail.com>
X-Rspamd-Queue-Id: 0EA2180003
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: ocg16q9o5rfp74bt5dj91qtfkdf6kx98
X-HE-Tag: 1783059863-400317
X-HE-Meta: U2FsdGVkX1/PphuLaYpExr6QKFCiPY47VZLGQJR5w7iXWBJ/UC0rjuGWtaLbtQI+0reUYXCVmCqhUmQJlJcINUXR6XjRKjYBzaBjx6hWyxD7RSLrLr5Ut63L2EOPd6BQYf06ieFR6B15PiK3kCCxhUGuFtkEFE16YJFdjakGKg5IK2qcjfMhcJL2+BbOa4vtb5VWaRe5ETBv0pwWwaLdwal1nUReMiTAFZCVjeah6Im+mzQsiPG9MdovP5e5/Q2vmV1FC46+vkLLSaIRCKAK6u4FZ7zx1BJBIY/RY0zCdthnbvNTUaCxbC+pe9kex6LD4+PpnDaSzieBzHbBBi0uJkb92xxDIOWlBhqdoyaMX0dJTFc7zpMjAEQMvkkE4BDBHXrb8ed66gQFJNSlLJea1BN6lKvkQfZoVbQVZ6zDwESDAuTq9ur3C0mMH+0DBxdIABb/uIfbG0txQDaFHY367TJ+dg7eKRolvhvD6gDWpo0um5DA3f/gosltjbdqeKYZC+ZsomL/SqJpXbGWeWu3ubFiBNTERRFUmM9c4Y1UBmwAftTT+/2Lm8/MxmVXFvC1btiTvv7Yf7zBE0DER2LrGNkfGXsSGdF1SZKgoggdLi0FioGCuPXZH9EZH6O8L+vOA25TS+gpl0W7VY/wcVDM0zTvaOf3u77YOoyh0PY4x4AXhHDhzqcIKhIJ81TlJdiWsHWo+d+Ci3mPh+saKh3fKtIItLmvglR/JPeYpgZDyTawB3zzr6Y0E6NhRbmD4e5RmXftwS0r9mMf5JXqKRNRWWaTgqjnQJmkI3nWQ/Y7aZ9USPtymKM5tLTvsqWDJ6UZEmP14biWFCQUdxiBi9U7Eu2wV6fGw8wikH/PppvSeqyG91/kcO/q+aFuCimbiioO/Ai4mHnaAyDK8iAuuPs8bCFnkB4lVyjKEFljJlsUGObyKWGhWSKcT02pbW5qpagv1GHvxoJUBof0o6GCQpL
 IDem+xq4
 XEIBWPn4axkl5+1Ve1NgR5s+6yB8UcGw7iCt1h0FhpdVoVQgntxNv1E77XhJgJiCJoUO3syOQ/RFVxB6aMV0NavV7pQ3cJpqpOp/ZLqG6CDyLZPmDw/cWwJ9bxbZE5SwSLf7T3QSTO9CXFWEFOS8mbuDwgxA14Faz2wdV10uEQcnSU5/qi3Ji+XC0SEj7Ue5OnW65gSiGJUes5gq2E7pZwIiFbpqZVin1PxSKRGBMSXf1IzYovotgcGLgKyIBmE/B5/eqQ5Cm0OPQU0hRhN3dRO/qb+0nZaEMkTdHUW5xFgdzcttaE5+l6QjE/N7OLPt3BpXxJQgFGp8jYIMlazHg1QBDfWM3ZPg9zov2SPrEM6QtJnYvjLx8sw0RWGc9pMRtiMb59cPgjtSV8/BQrDo3p6sRpHWmGJJJqbEqchg2d7ukHpff05idJAdG7FQIoDc+QwRcAhfu9XyLtamjKdB2bAwCFNdHZCEJ9bi3x2ZvX+QDc/U71BguQD5ZTMmACY6Cxmeri7+3M+VS2adAQL715SSw4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 04:26:09PM +0800, Jianhui Zhou wrote:
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

Please explain where the check is triggered and what are the effects.
 
> Handle removal of WP mode through UFFDIO_REGISTER the same way as
> UFFDIO_UNREGISTER: resolve the per-PTE uffd-wp state before dropping
> VM_UFFD_WP from the VMA.
> 
> Also make the same-context fast path require an exact UFFD mode match.
> The old subset check treats MISSING|WP -> MISSING as a no-op, even though
> WP mode is being removed.
> 
> Fixes: f45ec5ff16a7 ("userfaultfd: wp: support swap and page migration")
> Reported-by: syzbot+18d274a59b87cf80e86d@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=18d274a59b87cf80e86d
> Signed-off-by: Jianhui Zhou <jianhuizzzzz@gmail.com>
> ---
>  mm/userfaultfd.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 180bad42fc79..dc0b3eba768b 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -2153,13 +2153,21 @@ int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
>  		 * userfaultfd and with the right tracking mode too.
>  		 */
>  		if (vma->vm_userfaultfd_ctx.ctx == ctx &&
> -		    vma_test_all_mask(vma, vma_flags))
> +		    (vma->vm_flags & __VM_UFFD_FLAGS) == vm_flags)

Please use new VMA flag APIs.

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
> 
> base-commit: e43ffb69e0438cddd72aaa30898b4dc446f664f8
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

