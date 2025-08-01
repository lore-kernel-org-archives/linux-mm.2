Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD8FDC87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 20:50:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A5F56B007B; Fri,  1 Aug 2025 16:50:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 557016B0089; Fri,  1 Aug 2025 16:50:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46CC36B008A; Fri,  1 Aug 2025 16:50:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 381466B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 16:50:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D5B46140336
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 20:50:53 +0000 (UTC)
X-FDA: 83729382786.29.BD4BF9C
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2364514000C
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 20:50:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=I8c4BFeU;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754081452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sTSm7w1g3ZDevmH6EO/kq95dcX3h6qnzHHCPW/e1xmk=;
	b=Pn3kFvAprqQGRD53ZJ6/J4j9dT4SUhGm9gEcbejABt7h8uu3FeIq++xLcRS12/JeQNZDqA
	hEhlSvM4z8Fmc2drsbdD1+0pVrGy+bOerZiwmdcFshdT3cqR/XBPRL1wPbunEGwUFEn0uJ
	0gMGdjJzs60pvGAPaozgiCrKe5+H+Ec=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754081452; a=rsa-sha256;
	cv=none;
	b=o6Fd6ybdpqtTsjZBEMbUgonwulyr55RTx0iwwNC73TUUEoD9jI1FqZuB9x9heh7WUlw0WQ
	peL3HElpx3koQPSzR5ZXh8UJDNU3DOP8Yd3oRD6xnIwSVpz+DGSIMApwWmb4SGwp9I26bw
	atb0Pm+PEQw6OGxkjgZYAso2ztvNMbg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=I8c4BFeU;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 650D7A4FC88;
	Fri,  1 Aug 2025 20:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C97C4CEE7;
	Fri,  1 Aug 2025 20:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754081451;
	bh=pUhYM1Dbglzu+g4J5sGreNTXk+5Sy9kj4Rqd2CLT05M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=I8c4BFeUVtSdY/ZJvgnsXjo0/m9pVkvMHZj5MCfMuTapNpYyZ8xBB050XT2WcW2FX
	 8pg5pdp9yjFV28YtoH7zu4DWMjGbFBVFo6DwS28yqefTOXD4IlDAy6DDGFRFYhA+hp
	 eNU3lBsc0RiGlAv5Dk9DkiHhvwWrZVpM1zoJtI0s=
Date: Fri, 1 Aug 2025 13:50:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Herton R. Krzesinski" <herton@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 anshuman.khandual@arm.com, Christophe Leroy <christophe.leroy@csgroup.eu>,
 Gavin Shan <gshan@redhat.com>, Gerald Schaefer
 <gerald.schaefer@linux.ibm.com>
Subject: Re: [PATCH] mm/debug_vm_pgtable: clear page table entries at
 destroy_args()
Message-Id: <20250801135050.c9cc7226938f9f0f4fa3b83d@linux-foundation.org>
In-Reply-To: <20250731214051.4115182-1-herton@redhat.com>
References: <20250731214051.4115182-1-herton@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2364514000C
X-Stat-Signature: kodqfcdhbte88jzbp7y9cqrybjsniukt
X-Rspam-User: 
X-HE-Tag: 1754081451-92608
X-HE-Meta: U2FsdGVkX1+ckVr5HDwUxygzlklOjp5dHKYePghAygX3y2CAb0THsc4RW/7DvS+mNyfAiYuUPBNfrqn23VfUeSghmK8Kh1EgeCq6vD7gYNIlZl30JpIgZS6LmKnCcQ5U2oS9H1/mxNyQxjB6hMc7yOD7+X/lMHPrv3625J/gf32UYoXdz8BJEa1gad8yI9BQ30XBqAiqx0WEW4UMkRC5+jYwQkgiVnn9mC1hkQcugNPXUPnzS6ukV+JZJrueRJjrh1QSJxCHZxCLjhobp8gXD430EGNS2Pqa2jcsiigVEC4GPLi+3qWyV9Y+xDKuG2pr8O3cpbRYFcXRx1pI2Xr7pEJAJQQH0BZk/qRY3uFP9W6KfHEdmTK95eyPsXkebiymKbsPFTQ/uxnlEdbotm4zXXiP7tix3SrcznGIX933FKHfppPChdzLeVy/NFpSTLaEoPnXBpKhBpeXwSdpJULOYLGMtk95OpPbj+IZC38jALLtSdxUFN/85BfGx2u2aiS/LRDEgbKHB8ahuO7kHGrQ3+xowmsA7h6l0at/yn6tMjOTz432yKLdfyiJTR+ynkzfpj8ne2+HwViTxsYQgqulUHjHg1cQr1fTxuCPMyt5tk/HQ2VpQsRs3pXol2YkA2F6Qkd+2rz9/+Cye9AMC5I7CWfrLAF0CgsFgMze9AvDWP4kTaI+SiT/biw/IEXqjoUVJWQccvakuuCqxI40tbA15mYganrlsqWuxd8OQ0LciKEF9WtxCfaycF+tB2JLcITgoHCxqa0UAts34Wj9KcZQCu5U11H/mFo7qe9+cAshL69jWS20MmFBoFHua7Y0W8o0Znfu3NxU5IPj8Kwb05C0jwQj2b56ArNvre7tg1OUeKDNNY6mLtVFtAvs2Kq/7nUMhUekyZEChQum1Jb0w/VI3Fl7Wpx5WHUZR9aqY/9G6xyefyvu1qNA1Yte+KrCVf5gC3YADeyd84nFPjvTO65
 eOnoXMW+
 hi/+JonBsx5I+9tWeq1DqY4HFG0lJmwUVSpbCBQhFlPGybrd2ziogjNXAS5zuhAyrAt0OohONGHe1x1geVGqOBge0qsWcNq9yEEnfcbZPmfSehiEmwHWNEpp67Iwh9JM23NTY5di1wIedc0SERsj/fsDmSNyFsGlCsKivQMK0hapGIbQnwDIkFBMBS6NIl5ffzEMAO1kLlD3SimwXEukdYgAba1gqNRYUNMWvRUFGp67D9V/7jGm7+BA6DuNOJV2g+7iakYzDnjrLeSRBzLYxio2nNNGSArhO4/LnHV99VCPNrNpZ/Qf9M9Bnjj6b7U35W1JCl6N+bpnfUTON7/5r73+ljA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 31 Jul 2025 18:40:51 -0300 "Herton R. Krzesinski" <herton@redhat.com> wrote:

> The mm/debug_vm_pagetable test allocates manually page table entries for the
> tests it runs, using also its manually allocated mm_struct. That in itself is
> ok, but when it exits, at destroy_args() it fails to clear those entries with
> the *_clear functions.
> 
> The problem is that leaves stale entries. If another process allocates
> an mm_struct with a pgd at the same address, it may end up running into
> the stale entry. This is happening in practice on a debug kernel with
> CONFIG_DEBUG_VM_PGTABLE=y, for example this is the output with some
> extra debugging I added (it prints a warning trace if pgtables_bytes goes
> negative, in addition to the warning at check_mm() function):

A quick shot with git-blame led me to include

Fixes: 3c9b84f044a9e ("mm/debug_vm_pgtable: introduce struct pgtable_debug_args")
Cc: <stable@vger.kernel.org>

And `git show 3c9b84f044a9e' tell me this email didn't have enough cc's
(added).

Thanks, I'll include this in mm.git's mm-hotfixes branch and I shall
await further review activity.


> [    2.539353] debug_vm_pgtable: [get_random_vaddr         ]: random_vaddr is 0x7ea247140000
> [    2.539366] kmem_cache info
> [    2.539374] kmem_cachep 0x000000002ce82385 - freelist 0x0000000000000000 - offset 0x508
> [    2.539447] debug_vm_pgtable: [init_args                ]: args->mm is 0x000000002267cc9e
> (...)
> [    2.552800] WARNING: CPU: 5 PID: 116 at include/linux/mm.h:2841 free_pud_range+0x8bc/0x8d0
> [    2.552816] Modules linked in:
> [    2.552843] CPU: 5 UID: 0 PID: 116 Comm: modprobe Not tainted 6.12.0-105.debug_vm2.el10.ppc64le+debug #1 VOLUNTARY
> [    2.552859] Hardware name: IBM,9009-41A POWER9 (architected) 0x4e0202 0xf000005 of:IBM,FW910.00 (VL910_062) hv:phyp pSeries
> [    2.552872] NIP:  c0000000007eef3c LR: c0000000007eef30 CTR: c0000000003d8c90
> [    2.552885] REGS: c0000000622e73b0 TRAP: 0700   Not tainted  (6.12.0-105.debug_vm2.el10.ppc64le+debug)
> [    2.552899] MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 24002822  XER: 0000000a
> [    2.552954] CFAR: c0000000008f03f0 IRQMASK: 0
> [    2.552954] GPR00: c0000000007eef30 c0000000622e7650 c000000002b1ac00 0000000000000001
> [    2.552954] GPR04: 0000000000000008 0000000000000000 c0000000007eef30 ffffffffffffffff
> [    2.552954] GPR08: 00000000ffff00f5 0000000000000001 0000000000000048 0000000000004000
> [    2.552954] GPR12: 00000003fa440000 c000000017ffa300 c0000000051d9f80 ffffffffffffffdb
> [    2.552954] GPR16: 0000000000000000 0000000000000008 000000000000000a 60000000000000e0
> [    2.552954] GPR20: 4080000000000000 c0000000113af038 00007fffcf130000 0000700000000000
> [    2.552954] GPR24: c000000062a6a000 0000000000000001 8000000062a68000 0000000000000001
> [    2.552954] GPR28: 000000000000000a c000000062ebc600 0000000000002000 c000000062ebc760
> [    2.553170] NIP [c0000000007eef3c] free_pud_range+0x8bc/0x8d0
> [    2.553185] LR [c0000000007eef30] free_pud_range+0x8b0/0x8d0
> [    2.553199] Call Trace:
> [    2.553207] [c0000000622e7650] [c0000000007eef30] free_pud_range+0x8b0/0x8d0 (unreliable)
> [    2.553229] [c0000000622e7750] [c0000000007f40b4] free_pgd_range+0x284/0x3b0
> [    2.553248] [c0000000622e7800] [c0000000007f4630] free_pgtables+0x450/0x570
> [    2.553274] [c0000000622e78e0] [c0000000008161c0] exit_mmap+0x250/0x650
> [    2.553292] [c0000000622e7a30] [c0000000001b95b8] __mmput+0x98/0x290
> [    2.558344] [c0000000622e7a80] [c0000000001d1018] exit_mm+0x118/0x1b0
> [    2.558361] [c0000000622e7ac0] [c0000000001d141c] do_exit+0x2ec/0x870
> [    2.558376] [c0000000622e7b60] [c0000000001d1ca8] do_group_exit+0x88/0x150
> [    2.558391] [c0000000622e7bb0] [c0000000001d1db8] sys_exit_group+0x48/0x50
> [    2.558407] [c0000000622e7be0] [c00000000003d810] system_call_exception+0x1e0/0x4c0
> [    2.558423] [c0000000622e7e50] [c00000000000d05c] system_call_vectored_common+0x15c/0x2ec
> (...)
> [    2.558892] ---[ end trace 0000000000000000 ]---
> [    2.559022] BUG: Bad rss-counter state mm:000000002267cc9e type:MM_ANONPAGES val:1
> [    2.559037] BUG: non-zero pgtables_bytes on freeing mm: -6144
> 
> Here the modprobe process ended up with an allocated mm_struct from the
> mm_struct slab that was used before by the debug_vm_pgtable test. That is not a
> problem, since the mm_struct is initialized again etc., however, if it ends up
> using the same pgd table, it bumps into the old stale entry when clearing/freeing
> the page table entries, so it tries to free an entry already gone (that one
> which was allocated by the debug_vm_pgtable test), which also explains the
> negative pgtables_bytes since it's accounting for not allocated entries in the
> current process. As far as I looked pgd_{alloc,free} etc. does not clear entries,
> and clearing of the entries is explicitly done in the free_pgtables->
> free_pgd_range->free_p4d_range->free_pud_range->free_pmd_range->
> free_pte_range path. However, the debug_vm_pgtable test does not call
> free_pgtables, since it allocates mm_struct and entries manually for its test
> and eg. not goes through page faults. So it also should clear manually the
> entries before exit at destroy_args().
> 
> This problem was noticed on a reboot X number of times test being done
> on a powerpc host, with a debug kernel with CONFIG_DEBUG_VM_PGTABLE
> enabled. Depends on the system, but on a 100 times reboot loop the
> problem could manifest once or twice, if a process ends up getting the
> right mm->pgd entry with the stale entries used by mm/debug_vm_pagetable.
> After using this patch, I couldn't reproduce/experience the problems
> anymore. I was able to reproduce the problem as well on latest upstream
> kernel (6.16).
> 
> I also modified destroy_args() to use mmput() instead of mmdrop(), there
> is no reason to hold mm_users reference and not release the mm_struct
> entirely, and in the output above with my debugging prints I already
> had patched it to use mmput, it did not fix the problem, but helped
> in the debugging as well.
> 
> Signed-off-by: Herton R. Krzesinski <herton@redhat.com>
> ---
>  mm/debug_vm_pgtable.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
> index 7731b238b534..0f5ddefd128a 100644
> --- a/mm/debug_vm_pgtable.c
> +++ b/mm/debug_vm_pgtable.c
> @@ -1041,29 +1041,34 @@ static void __init destroy_args(struct pgtable_debug_args *args)
>  
>  	/* Free page table entries */
>  	if (args->start_ptep) {
> +		pmd_clear(args->pmdp);
>  		pte_free(args->mm, args->start_ptep);
>  		mm_dec_nr_ptes(args->mm);
>  	}
>  
>  	if (args->start_pmdp) {
> +		pud_clear(args->pudp);
>  		pmd_free(args->mm, args->start_pmdp);
>  		mm_dec_nr_pmds(args->mm);
>  	}
>  
>  	if (args->start_pudp) {
> +		p4d_clear(args->p4dp);
>  		pud_free(args->mm, args->start_pudp);
>  		mm_dec_nr_puds(args->mm);
>  	}
>  
> -	if (args->start_p4dp)
> +	if (args->start_p4dp) {
> +		pgd_clear(args->pgdp);
>  		p4d_free(args->mm, args->start_p4dp);
> +	}
>  
>  	/* Free vma and mm struct */
>  	if (args->vma)
>  		vm_area_free(args->vma);
>  
>  	if (args->mm)
> -		mmdrop(args->mm);
> +		mmput(args->mm);
>  }
>  
>  static struct page * __init
> -- 
> 2.47.1

