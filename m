Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3944C103E173
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 12:55:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99E0B6B01F1; Wed, 18 Mar 2026 08:55:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94F3A6B01F3; Wed, 18 Mar 2026 08:55:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8646B6B01F4; Wed, 18 Mar 2026 08:55:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 746E56B01F1
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:55:42 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 12842BB046
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:55:42 +0000 (UTC)
X-FDA: 84559180524.08.C0FF374
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 58844C000C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:55:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bqkm3fOL;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773838540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B/PHddxNwca2K+Ew4mFOoiAAUBLKiuNMH3RHqXC0L2c=;
	b=LnRrqAA8TjFVF/sBjnMiiUbpAX/3YC4DyrHTjhb1Umy+RdkuYa17fFriF/VPdwzakOKhYP
	B0tMKcqDDjouOySEul/sDMtKdo6LIbeWdPM0CrPU1UUiqzX8pHYbV/L8Wdv6LRW3M3pA2h
	38yHfWTRZX3Nm70gmvI45Z//EqjLbvs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773838540; a=rsa-sha256;
	cv=none;
	b=2OIwNV0qXTAMRwZ0r2KGDMhN6uCKXVxRd1Azgm09krji0ybr+77ksXSZ6xyXB6pNrHO53j
	ZPmmDXQcmsSALvbTJI3faUeN+N1txQX2TTgzz53i/I9Pjqyv8L/Zc/RchqGCvPr95w9dfC
	lAbn3zi0JLElw0Og82PAEaEbMEujPoY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bqkm3fOL;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 58FDE406E8;
	Wed, 18 Mar 2026 12:55:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73747C19421;
	Wed, 18 Mar 2026 12:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773838539;
	bh=sDIDsqJ3eFVM7qqeJp3W+MpwzFRTxygdOnQHhQnvPOA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bqkm3fOL9EWdZD6ReasTxze7QbXM+wy4+Qr9g0Aj3EAt2ZFHcM1/1knI4ha73coaH
	 z9w/zpJxLcRkihlNBInHtjD898Bgsq9+XUCiNdFgvexSH7FuJm3SyOPl2JUEI0Zl/R
	 sNH/ncL2EclkWmKkfzTEmWeyIwRsRVqr+JFiZsGS95SaOngLCgQ+ZtDZ0+vZqSCZW3
	 GszKMej59qmnvao6fBY4viUINIXynTvaLsMBloLxYbE5kf+BikQem9g0thkLPABi4P
	 LJeLdt72C+B7iyMBZJdkEg0DI+gUvYkdtoaeikhKPLlWCFirx32VveXQJVeGrFtVQz
	 cRiUBJYPaETNg==
Date: Wed, 18 Mar 2026 12:55:33 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: mboone@akamai.com
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/pagewalk: fix race between concurrent split and
 refault
Message-ID: <7ded426a-0cb5-437b-9634-8d806b704db6@lucifer.local>
References: <20260317-pagewalk-check-pmd-refault-v1-1-f699a010f2b3@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317-pagewalk-check-pmd-refault-v1-1-f699a010f2b3@akamai.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 58844C000C
X-Stat-Signature: 4o95yitn8on7o6qf4xgxps678n1az5kb
X-HE-Tag: 1773838540-316985
X-HE-Meta: U2FsdGVkX19oGmu/y4tXDl3OFy/fMNVyvbPMPogRuXDI47ytlkw5F51ujlKEKy5546jzBnMdzAE5mp6VeV3eVuf+b3yiGrvOxz7kRuu5wFoxM0maxeNuqS572fzqfxZh9hJ99elr7i+eGJaR+gGufQSzryclCX3H+qXdqHXeaf0hEpeU1hhpjawpGa3vwNu4IoF6C1NmHNkvok+bxiqLKtofCdJqYOUqap5rddqWJGeh0vs0BV4bUAQDSSPyOvSdLZfuQPwuySkjVXDdfIPr9hXf+GaP4wlcsuyj5YAzn7Pw9WkgoI9NSUQAOLvhcrvv3pES7iXMpvXEtHTiJmdqQLfWZp8py9p2zOnkHR80AdfQNf0CIEclNvmJ93A8AJisD5jMlfqiCrjrCbUjyTc6TOZLpbCEQekmsFoSHA7JLIIOs69f24iLM4vm+j8ethXnflXQN2x9pmV6k+S4dikidbq6kcx6gWv1+WPN1/eQH6bFqrTrcDKgsAfdy0yd8Kx+d82MRdgl1sibL2T0xyodTWRU1+3xANB2VVUhXbwrCzGW8wvTDam/tUVVkX9pFp6V1pxa7o5jVKmGFI9U2dEHapmqJz1psy0b0Ntv8ZAdyMwI70tkEVovOpULrsr1jhVAPgeb5zZ9W4lMxYcOMMNtSX08hdH3gusEWKecokG8spbjaOtFLEet93n66kb02pIT+M/CiDzCUZDSsluUmCuCXrbxSWi89gUqzj3Ds2k6fl0FUfQejcvuG6tA6rHXerS3LZFXchIhwzYHBynVZB9OVZW8fmip4fT0UU8LyP36zS8esgFgGKN5n4t/5+VXobnQPAjem3t45Cqkh7qa4Iq9X4rWhEJSKdq14UDhcEp0u1Y5slwHPYKIw7LauAnNwfNl0DO6ghqwzKwkO04MoMI5joxARJSHeelQnO3s5cJOpWCf6lJxBbwBmOu73VFhCo2XkLGI9nt5WJk/e/h7cpr
 Ml9t4NRi
 ephUd7PRGMBJrXEKUtRe0lPVns0wGVZFP02O3FYxo4JjQxuXwJM/MLDXt28aHRVPdr/po6Jpm/nUEMnH32lNfxMTEOOMGDFp+XcjEq96nIX0/tfFeXnG9AAwTEedFo4m69MjasCaqcCgsY6f3P0tdcxdwG46Y+9zCT3W0sTn6K0zTE2Z6Dv5zCrDMHpKnoB3jmH4Xi0pIicc4sba3jUa+/SLv/Sqfi/b4L++Jr2J2vJW41IyabDt1h/8BUcQ/ljlliTmJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 03:03:04PM +0100, Max Boone via B4 Relay wrote:
> From: Max Boone <mboone@akamai.com>
>
> The splitting of a PUD entry in walk_pud_range() can race with
> a concurrent thread refaulting the PUD leaf entry causing it to
> try walking a PMD range that has disappeared.

So IOW, the PUD entry is split, then refaulted back to a PUD leaf entry
again?

>
> An example and reproduction of this is to try reading numa_maps of
> a process while VFIO-PCI is setting up DMA (specifically the
> vfio_pin_pages_remote call) on a large BAR for that process.
>
> This will trigger a kernel BUG:
> vfio-pci 0000:03:00.0: enabling device (0000 -> 0002)
> BUG: unable to handle page fault for address: ffffa23980000000
> PGD 0 P4D 0
> Oops: Oops: 0000 [#1] SMP NOPTI
> ...
> RIP: 0010:walk_pgd_range+0x3b5/0x7a0
> Code: 8d 43 ff 48 89 44 24 28 4d 89 ce 4d 8d a7 00 00 20 00 48 8b 4c 24
> 28 49 81 e4 00 00 e0 ff 49 8d 44 24 ff 48 39 c8 4c 0f 43 e3 <49> f7 06
>    9f ff ff ff 75 3b 48 8b 44 24 20 48 8b 40 28 48 85 c0 74
> RSP: 0018:ffffac23e1ecf808 EFLAGS: 00010287
> RAX: 00007f44c01fffff RBX: 00007f4500000000 RCX: 00007f44ffffffff
> RDX: 0000000000000000 RSI: 000ffffffffff000 RDI: ffffffff93378fe0
> RBP: ffffac23e1ecf918 R08: 0000000000000004 R09: ffffa23980000000
> R10: 0000000000000020 R11: 0000000000000004 R12: 00007f44c0200000
> R13: 00007f44c0000000 R14: ffffa23980000000 R15: 00007f44c0000000
> FS:  00007fe884739580(0000) GS:ffff9b7d7a9c0000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffa23980000000 CR3: 000000c0650e2005 CR4: 0000000000770ef0
> PKRU: 55555554
> Call Trace:
>  <TASK>
>  __walk_page_range+0x195/0x1b0
>  walk_page_vma+0x62/0xc0
>  show_numa_map+0x12b/0x3b0
>  seq_read_iter+0x297/0x440
>  seq_read+0x11d/0x140
>  vfs_read+0xc2/0x340
>  ksys_read+0x5f/0xe0
>  do_syscall_64+0x68/0x130
>  ? get_page_from_freelist+0x5c2/0x17e0
>  ? mas_store_prealloc+0x17e/0x360
>  ? vma_set_page_prot+0x4c/0xa0
>  ? __alloc_pages_noprof+0x14e/0x2d0
>  ? __mod_memcg_lruvec_state+0x8d/0x140
>  ? __lruvec_stat_mod_folio+0x76/0xb0
>  ? __folio_mod_stat+0x26/0x80
>  ? do_anonymous_page+0x705/0x900
>  ? __handle_mm_fault+0xa8d/0x1000
>  ? __count_memcg_events+0x53/0xf0
>  ? handle_mm_fault+0xa5/0x360
>  ? do_user_addr_fault+0x342/0x640
>  ? arch_exit_to_user_mode_prepare.constprop.0+0x16/0xa0
>  ? irqentry_exit_to_user_mode+0x24/0x100
>  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> RIP: 0033:0x7fe88464f47e
> Code: c0 e9 b6 fe ff ff 50 48 8d 3d be 07 0b 00 e8 69 01 02 00 66 0f 1f
> 84 00 00 00 00 00 64 8b 04 25 18 00 00 00 85 c0 75 14 0f 05 <48> 3d 00
>    f0 ff ff 77 5a c3 66 0f 1f 84 00 00 00 00 00 48 83 ec 28
> RSP: 002b:00007ffe6cd9a9b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> RAX: ffffffffffffffda RBX: 0000000000020000 RCX: 00007fe88464f47e
> RDX: 0000000000020000 RSI: 00007fe884543000 RDI: 0000000000000003
> RBP: 00007fe884543000 R08: 00007fe884542010 R09: 0000000000000000
> R10: fffffffffffffbc5 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000000003 R14: 0000000000020000 R15: 0000000000020000
>  </TASK>
>
> Fix this by validating the PUD entry in walk_pmd_range() using a stable
> snapshot (pudp_get()). If the PUD is not present or is a leaf, retry the
> walk via ACTION_AGAIN instead of descending further. This mirrors the
> retry logic in walk_pmd_range().

I think it mirrors the retry logic in walk_pte_range() more closely right?
Because there it's:

	if (!pte)
		walk->action = ACTION_AGAIN;
	return err;

I.e. let the parent handle the PTE not being got by pte_offset_map_lock(),
and you draw a comparison to this in the comment in walk_pmd_range().

>
> Fixes: a00cc7d9dd93 ("mm, x86: add support for PUD-sized transparent hugepages")

Yikes, really? :) This is from 2017, I'm a little surprised we didn't hit
this bug until now.

Has something changed more recently that made it more likely to hit? Or is
it one of those 'needed people to have more RAM first' or bigger PCI BAR's?

> Cc: stable@vger.kernel.org
> Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Max Boone <mboone@akamai.com>

Only nits here, the logic LGTM, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/pagewalk.c | 20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)
>
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index a94c401ab..c74b4d800 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -97,6 +97,7 @@ static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
>  			  struct mm_walk *walk)
>  {
> +	pud_t pudval = pudp_get(pud);
>  	pmd_t *pmd;
>  	unsigned long next;
>  	const struct mm_walk_ops *ops = walk->ops;
> @@ -105,6 +106,18 @@ static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
>  	int err = 0;
>  	int depth = real_depth(3);
>
> +	/*
> +	 * For PTE handling, pte_offset_map_lock() takes care of checking
> +	 * whether there actually is a page table. But it also has to be
> +	 * very careful about concurrent page table reclaim. If we spot a PMD
> +	 * table, it cannot go away, so we can just walk it. However, if we find
> +	 * something else, we have to retry.

Nitty but I think we can be clearer here something like:

	/*
	 * For PTE handling, pte_offset_map_lock() takes care of checking
	 * whether there actually is a page table. But it also has to be
	 * very careful about concurrent page table reclaim.
	 *
	 * Similarly, we have to be careful here - a PUD entry that points
         * to a PMD table cannot go away, so we can just walk it. But if
         * it's something else, we need to ensure we didn't race something,
         * so need to retry.
	 *
	 * A pertinent example of this is a PUD refault after PUD split -
         * we will need to split again or risk accessing invalid memory.
	 */

> +	 */
> +	if (!pud_present(pudval) || pud_leaf(pudval)) {
> +		walk->action = ACTION_AGAIN;
> +		return 0;
> +	}
> +
>  	pmd = pmd_offset(pud, addr);
>  	do {
>  again:
> @@ -218,12 +231,13 @@ static int walk_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
>  		else if (pud_leaf(*pud) || !pud_present(*pud))
>  			continue; /* Nothing to do. */
>
> -		if (pud_none(*pud))
> -			goto again;
> -
>  		err = walk_pmd_range(pud, addr, next, walk);
>  		if (err)
>  			break;
> +
> +		if (walk->action == ACTION_AGAIN)
> +			goto again;
> +

NIT: trailing newline.

>  	} while (pud++, addr = next, addr != end);
>
>  	return err;
>
> ---
> base-commit: b4f0dd314b39ea154f62f3bd3115ed0470f9f71e
> change-id: 20260317-pagewalk-check-pmd-refault-de8f14fbe6a5
>
> Best regards,
> --
> Max Boone <mboone@akamai.com>
>
>

Cheers, Lorenzo

