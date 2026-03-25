Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E906109C02F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 15:14:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89CD16B008A; Wed, 25 Mar 2026 11:14:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 874BE6B008C; Wed, 25 Mar 2026 11:14:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78A6B6B0092; Wed, 25 Mar 2026 11:14:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6C2236B008A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:14:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2AD7D1B8E0D
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:14:57 +0000 (UTC)
X-FDA: 84584933034.26.4D84480
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 83F5A1C0010
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:14:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jVNYUWsk;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jVNYUWsk;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774451695; a=rsa-sha256;
	cv=none;
	b=NUDOMUgJahjcetLSCvEl2QiaxaMhLIzvHsqO0x+fHzQfDVoz5GXTMFRN4KbAGt3+Czc3I+
	HaYzZ1T9NYHoMvlzCKg5q/mMnQvJH/ut3tGDlRdqh+gQaFLd9a3Gk8+NkBH0hgQS6GvXHu
	wfIViIABae13+dmsGnhZwiUV0lVwxOg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774451695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mCuq/BfXsO+UxkqMXxR1KEryLOyGUIZPs7M4CmYgH5U=;
	b=JBfDG+e6WqlvHGXFTDpzg4OdW3yR/YWky8pAhfX/26gqp1Qh2D079F7QWTGBYHidkfMt8X
	uE/etO4RQoMhn2gB5WWx6g7kClOI5259AvzNtYPHcJXBCqvpVcCFLwRL/Fgort0tHQ3V5n
	Jw9M9WcUP4IQpqrQvmU7O7S/K9Sbcb4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C5DA96012A;
	Wed, 25 Mar 2026 15:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C76C116C6;
	Wed, 25 Mar 2026 15:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774451694;
	bh=7MnbjeWtsH0JvaYpZpR7lXnkxJmkUg7sLS611uhlmAM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jVNYUWskpSXx7XlaVxDiUSu6HaYLYfHqaeFSIdOumJl/ERR8k9IwD1vPAvamEdGVM
	 o0DyrHmHQfJhELVqkFxzUjKzLWeEtThITrHuiLl8rWEn6EK1Px9AkCej7hc7c4N1YZ
	 qWUT/6cezQ3EL8ZqTXlDY8ilrZkRG0ENkS1YqLzj2lNiw+cngXbIu61vfui+X62uvc
	 btWBlVMC3FFTOHr1fk3xxdS1ln7PU+Gv22zU6XVdX9Sg/7Max+dp2qA3ixhlxbmfJ6
	 LvgIuu35q9ij90FP6+GAhjJRPB4MVmwwFm5HOw/XI6WP5QNjVyFYxYgJDKtzL77tlZ
	 kDXLV0d5aGyXA==
Date: Wed, 25 Mar 2026 15:14:49 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: mboone@akamai.com
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/pagewalk: fix race between concurrent split and
 refault
Message-ID: <6c413f17-01c8-43fa-b5d5-45fe32dd14a8@lucifer.local>
References: <20260325-pagewalk-check-pmd-refault-v2-1-707bff33bc60@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325-pagewalk-check-pmd-refault-v2-1-707bff33bc60@akamai.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 83F5A1C0010
X-Stat-Signature: m3px1abgx6byy4by78mgaja7nybqqryh
X-Rspam-User: 
X-HE-Tag: 1774451695-732667
X-HE-Meta: U2FsdGVkX1+ajDJgoeUgnUrC1a0+3HdzsvQmhdv2oR1jgA8VAANtQnil67zBj2G7gOw7viEkvnHMJhYswk3/Ej8f9gncmwBn01rvT7UWov6WmxuIUzL37Num0LmrFe/wuYfUo79Q0zqiFjqIq8lNI0J41fPmWvHyiO9/cF/FSaBed1L1xBEUJk3XxFqBMtO0y/qXK36MU/Db1el5+0jMjirZ/CfHz+bn7sziBGC1DK6YNfxumOOXS8KxA2KxQ1gHjXip4giFiuNyVYoujW3D8ANqP1mEJOVS/1grzKw/mJa2341G3DRlaSO34SpnOKzKSx9TrefXSSV83ywQiiV7u1KpDPa/jKBo5klZ3EXK+SPF4PrNmbb7bRK195WcT7X2sirIPgWtcS854AxS4ZazwO2Rs1toz/1cdVRx/BEGRGXGoiBswI1qDdgFkAGkyAAhtVGkmyHo18AdbGaBiENzk/L5rqVkWzcHVXsKG4qSgi1mmrj9TGbewfZ2dPxkGTclmv/G2G61pUutS3HNS75Sk8RwDbfYQL01NqKkF7ivCK8swTXCQcvNrZ3nF6gFLzE1x3KnPm6QTQMrt4vmn4ayPqWWUf1MnHJ4QnF/qwEb5gUsY4dVdSE+XCJ/qMQn/I1bU7yaFf9oWMiEH/CzOi2PaIuvVziSIb1OWAaPh8H+349Cajgc4vUwlb/GsAoDDcr0XAHay4E+fuG1F8MrZcPmRUcVMp7ADUCpktSMjax1seIucabHGpkgNdy4cHNAgh0NUjmfgqWeLLe/0OHXCNm8wGL5Vo/LE2IHf9d5/W9voeC4F58ixtD43q5VZXrV8NE2Ouc+9wzK+CUlcEWaQ4k6ncGoc0UaljJfQJY/V0iZFxgPuxRIDjuh8VQ/6Y0VdVzbwBWkRKsaGp6J8JS1L+mgmoz/fuHmwH4OJL0e9dTPX2VFzORPWM7ecin82z8BRedoVpDBPn6V8UydO+JcXK7
 TsiA7MZy
 FmZ110NLwW865DflP9IOa7wt3UikkBQhp2WXvwAMgzNyjrFcFMSwMu11nDTAnoeLaJeQMDZqaEwgmQzzX1BXe1nyyZbsX/ltZi8ko/q/ChQonQ1IGIBizRw4yVm5naduWKpYqeKpD2W1gVKBZM2qgAND284rzVhFF5BAZKRBrqkmEitrYQPPwNyk5CUMGhs4LrD66tDJrzS7QfLQQaY7kmNF3IrBgM2cbIiZzCwUo4XyYDpmEioopD7+GAAb/CMuDnS2H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 10:59:16AM +0100, Max Boone via B4 Relay wrote:
> From: Max Boone <mboone@akamai.com>
>
> The splitting of a PUD entry in walk_pud_range() can race with
> a concurrent thread refaulting the PUD leaf entry causing it to
> try walking a PMD range that has disappeared.
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
> retry logic in walk_pte_range(), which lets walk_pmd_range() retry if
> the PTE is not being got by pte_offset_map_lock().
>
> Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
> Cc: stable@vger.kernel.org
> Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Max Boone <mboone@akamai.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

(I reviewed before but maybe you didn't see that I was fine with you
applying tag after nits addressed :)

> ---
> Changes in v2:
> - extended the comment in walk_pmd_range with split/refault example.
> - changed fixes, race not introduced by hugepage splitting but rather
>   with huge pfnmaps of BARs.
> - clarified that the retry logic mirrors walk_pte_range instead of
>   walk_pmd_range.
> - style changes (removed trailing newline)
> - Link to v1: https://lore.kernel.org/r/20260317-pagewalk-check-pmd-refault-v1-1-f699a010f2b3@akamai.com

Thanks, Lorenzo

> ---
>  mm/pagewalk.c | 25 ++++++++++++++++++++++---
>  1 file changed, 22 insertions(+), 3 deletions(-)
>
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index a94c401ab..4e7bcd975 100644
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
> @@ -105,6 +106,24 @@ static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
>  	int err = 0;
>  	int depth = real_depth(3);
>
> +	/*
> +	 * For PTE handling, pte_offset_map_lock() takes care of checking
> +	 * whether there actually is a page table. But it also has to be
> +	 * very careful about concurrent page table reclaim.
> +	 *
> +	 * Similarly, we have to be careful here - a PUD entry that points
> +	 * to a PMD table cannot go away, so we can just walk it. But if
> +	 * it's something else, we need to ensure we didn't race something,
> +	 * so need to retry.
> +	 *
> +	 * A pertinent example of this is a PUD refault after PUD split -
> +	 * we will need to split again or risk accessing invalid memory.
> +	 */
> +	if (!pud_present(pudval) || pud_leaf(pudval)) {
> +		walk->action = ACTION_AGAIN;
> +		return 0;
> +	}
> +
>  	pmd = pmd_offset(pud, addr);
>  	do {
>  again:
> @@ -218,12 +237,12 @@ static int walk_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
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

