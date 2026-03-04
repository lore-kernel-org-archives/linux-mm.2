Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EA48EB7EB2
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 08:53:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70CC46B0088; Wed,  4 Mar 2026 03:53:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BAD36B008C; Wed,  4 Mar 2026 03:53:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B9336B0092; Wed,  4 Mar 2026 03:53:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 452936B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 03:53:12 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D20AE58F9C
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:53:11 +0000 (UTC)
X-FDA: 84507766182.25.AD39F30
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 360471C0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:53:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q+bToVKt;
	spf=pass (imf20.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772614390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B+66wSXz/9KLmuQpespPML/K60CzBNJY07z8y0t/IFE=;
	b=uR7C5eIOAfCgIFyTnhT7bBYRV2gHud0pMX9adMfAsT+L9tzg+1Q/dWU6yvpeyyV0+wrfpF
	N5ouWXS8NowQheNgavfBth+mcoDSopUGg8stniD7ZqNpBq29t6Z4KB05llYl4LsIqsYT4D
	TGsaq3xXD2nqAgdwoiLaN2/+r3swHWg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q+bToVKt;
	spf=pass (imf20.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772614390; a=rsa-sha256;
	cv=none;
	b=MIlQ3FUnAsxxSlMFNuTN10EjL+iKRc/f1ILaekMZjsj1VnXKjIUPwpAF/ACkQHXdcNCthl
	ZHQ3W4sAMolsI4AXZXH6wpw4Sg3WkFhxsSsl6zrp3vDdCwGFPAOD9e74fzz9671G50PIig
	GItx0grbKV7podo13F4sjW2lCCnYNuM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 72C3060097;
	Wed,  4 Mar 2026 08:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6172BC19423;
	Wed,  4 Mar 2026 08:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772614389;
	bh=StrbMlm959BwZ1b5TDceBEL1IlRGm/TfDepBkeRT8uw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Q+bToVKtQ2sUUyFzW+MxYpCg3+2ivPfzpfkh6tCpuQA+fUBho85lQp0PgSq+teUTe
	 i6/A2APPoeK4WgG9y2lhic2AZf/QYU9E/fSvBfDYkJkupYpNAQ94SZaseL4R9ERdwR
	 QWaS0H0aC2vCR3BZgQUr1CYr+YAS1AFuunQDCS2Fn+Q0xH2/aNXHPHNJe1KZC/+NPd
	 SRhNFHFqR03qBPTUGX2WeGOEBvRcFYiPr5D5g0T8nyvuXHcS13XrdMcEfRludkG2/5
	 K5QzQDQSzbRfjjZvn4dX9Syj8KgM0K8XoaBy5m8qI3pCG4ulaLW4+dSXxfQsh49VoT
	 VNL8NpDdK7fug==
Message-ID: <e10b3f59-603b-4d7f-a4bf-91f4e9f51ae7@kernel.org>
Date: Wed, 4 Mar 2026 09:53:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1 01/10] powerpc/pgtable-frag: Fix bad page state in
 pte_frag_destroy
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <cover.1772013273.git.ritesh.list@gmail.com>
 <62dfff55a7f4f465ac1f8077cee93e6e87ebddd0.1772013273.git.ritesh.list@gmail.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <62dfff55a7f4f465ac1f8077cee93e6e87ebddd0.1772013273.git.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 360471C0005
X-Rspamd-Server: rspam07
X-Stat-Signature: ihuat54y8y5k1teu3d4f7jbww19adpbu
X-Rspam-User: 
X-HE-Tag: 1772614389-972807
X-HE-Meta: U2FsdGVkX18+8fl/1GZi5UQFDcGoMDISfbKxSJOLJRekRu/5ZEdYMta7KiuJ/yHYwdnM9d/i4PlVcAgJfILZ1dUdMhLaFUKVgmQNLAs0e5dLSH9XbsTFC4JQga5MbtBDyhs+66N8EZsDf0Ch40WrT8hNkyow4ijwHOsJYblvEUFr3Vn4775/NeaTmFLAldnF+SkYLc+sgnJNaG0NCtyry3mxkIvTI6d2qcNM+iXsqCjj1FMUPfLL2IeSUK3KSgq53C/Xofhykk38FSoSwA8QvIlvWOgRtz+DBG1ochWqL2NcFtRRPptlcnYS2OE44IwSj4op/7kdtidaH/2/7/QAzSDe+Z5M5BfZyOQiuvU2F0kYn10ypzGhtI2yPTiYQEb9EMM850bTagodG/NoABnSzM1Lpq8eR9WoUNpcqMs9ZiyfFRoaQJYKFDL60qwpYmBaqqMWZt5Q47g13S3kV0EAiikgbCOCeB7S4H0te7TRzdDoaQticcls2ufbUQZaYDKIAkkrAO7C3b87dlR9JuVMMyM7fNU315QEGkT+IffZWoIj025Q8MFKyJ7N8FMXPmMZWWmSrAYTqNKG4tIF70KXlj89lGYOXs599TaK1/zXfOOjjULQAqA/OFkzwf+we6/QNGVtjLyHEx4x0edPeDheux8R/5g2mek1WI/slmW5v8/ZakXNMOEy5W2mbRpkyLM/o0fZbE30Bk1ceeEpgj4Huug24EbEpdxebAm31GyzjdCtb+57Y2CEpgbPYIgYB+kT2O01bcxtr4NGnWnu3zU44P0h9pF5VEw3Lxj4qPZXptIWTSqBHflNj16CHqTcLlemo0Ds5MSQfddtmwvIhselTCHq1JLQRs3nU6wRrHQLT4OE+XDb61+fYD/SvoyNfHzaolTYZodxhsMDxzujUcxe1Xr5Obj0M/YUvHN5/0dJwc636z0439n2GOhxb4+CeL+1/e1wyENKqW/K3tuTpg2
 vzKfneEf
 UVVzZDbZ/gJj5PFSnJqHIco5NqxiDUd/Rgozkzf2c0YtqVSx8I60RopMFDU0KFSlQ1716lYmA9lZBn12ZPIhRqkMdvtyZi5X8ts3ku6WapAA3rgie/qrel03uz6PrN5bopY3IG5hCHHAh6MLgxkzKWx1E6jBdOM6+5iX6Ltd1S4XA3bccuuqfKe8PHgT8Gd9THfoT3GA5gzSyZLJnvIyX99uq/H/Ds+0RAxzZUoEFM3n/JcP/50ZOgqVAkvjJI97lwslsmujOoL5CMobSHydI/aW9BO/HyKi6nHVyKijXnIXpLYkjaFxYcHFYsm03OGvOOh/PnN9nys08IF1T88n7D2jYwwILlxCgpAiOB7AzPfo9K1xv6PDwYZfqu/jjWtoZWLc6FdF1yClz5D4rgwmp8Xc4sBWSZCJaxFLoZ82vliS/xAeWrV8zjNlTRxr6wAU1l3yYQNNtCI88Hvuw8bFHMkiVwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 25/02/2026 à 12:04, Ritesh Harjani (IBM) a écrit :
> powerpc uses pt_frag_refcount as a reference counter for tracking it's
> pte and pmd page table fragments. For PTE table, in case of Hash with
> 64K pagesize, we have 16 fragments of 4K size in one 64K page.
> 
> Patch series [1] "mm: free retracted page table by RCU"
> added pte_free_defer() to defer the freeing of PTE tables when
> retract_page_tables() is called for madvise MADV_COLLAPSE on shmem
> range.
> [1]: https://lore.kernel.org/all/7cd843a9-aa80-14f-5eb2-33427363c20@google.com/
> 
> pte_free_defer() sets the active flag on the corresponding fragment's
> folio & calls pte_fragment_free(), which reduces the pt_frag_refcount.
> When pt_frag_refcount reaches 0 (no active fragment using the folio), it
> checks if the folio active flag is set, if set, it calls call_rcu to
> free the folio, it the active flag is unset then it calls pte_free_now().
> 
> Now, this can lead to following problem in a corner case...
> 
> [  265.351553][  T183] BUG: Bad page state in process a.out  pfn:20d62
> [  265.353555][  T183] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x20d62
> [  265.355457][  T183] flags: 0x3ffff800000100(active|node=0|zone=0|lastcpupid=0x7ffff)
> [  265.358719][  T183] raw: 003ffff800000100 0000000000000000 5deadbeef0000122 0000000000000000
> [  265.360177][  T183] raw: 0000000000000000 c0000000119caf58 00000000ffffffff 0000000000000000
> [  265.361438][  T183] page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
> [  265.362572][  T183] Modules linked in:
> [  265.364622][  T183] CPU: 0 UID: 0 PID: 183 Comm: a.out Not tainted 6.18.0-rc3-00141-g1ddeaaace7ff-dirty #53 VOLUNTARY
> [  265.364785][  T183] Hardware name: IBM pSeries (emulated by qemu) POWER10 (architected) 0x801200 0xf000006 of:SLOF,git-ee03ae pSeries
> [  265.364908][  T183] Call Trace:
> [  265.364955][  T183] [c000000011e6f7c0] [c000000001cfaa18] dump_stack_lvl+0x130/0x148 (unreliable)
> [  265.365202][  T183] [c000000011e6f7f0] [c000000000794758] bad_page+0xb4/0x1c8
> [  265.365384][  T183] [c000000011e6f890] [c00000000079c020] __free_frozen_pages+0x838/0xd08
> [  265.365554][  T183] [c000000011e6f980] [c0000000000a70ac] pte_frag_destroy+0x298/0x310
> [  265.365729][  T183] [c000000011e6fa30] [c0000000000aa764] arch_exit_mmap+0x34/0x218
> [  265.365912][  T183] [c000000011e6fa80] [c000000000751698] exit_mmap+0xb8/0x820
> [  265.366080][  T183] [c000000011e6fc30] [c0000000001b1258] __mmput+0x98/0x300
> [  265.366244][  T183] [c000000011e6fc80] [c0000000001c81f8] do_exit+0x470/0x1508
> [  265.366421][  T183] [c000000011e6fd70] [c0000000001c95e4] do_group_exit+0x88/0x148
> [  265.366602][  T183] [c000000011e6fdc0] [c0000000001c96ec] pid_child_should_wake+0x0/0x178
> [  265.366780][  T183] [c000000011e6fdf0] [c00000000003a270] system_call_exception+0x1b0/0x4e0
> [  265.366958][  T183] [c000000011e6fe50] [c00000000000d05c] system_call_vectored_common+0x15c/0x2ec
> 
> The bad page state error occurs when such a folio gets freed (with
> active flag set), from do_exit() path in parallel.
> 
> ... this can happen when the pte fragment was allocated from this folio,
> but when all the fragments get freed, the pte_frag_refcount still had some
> unused fragments. Now, if this process exits, with such folio as it's cached
> pte_frag in mm->context, then during pte_frag_destroy(), we simply call
> pagetable_dtor() and pagetable_free(), meaning it doesn't clear the
> active flag. This, can lead to the above bug. Since we are anyway in
> do_exit() path, then if the refcount is 0, then I guess it should be
> ok to simply clear the folio active flag before calling pagetable_dtor()
> & pagetable_free().
> 
> Fixes: 32cc0b7c9d50 ("powerpc: add pte_free_defer() for pgtables sharing page")
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

> ---
>   arch/powerpc/mm/pgtable-frag.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/powerpc/mm/pgtable-frag.c b/arch/powerpc/mm/pgtable-frag.c
> index 77e55eac16e4..ae742564a3d5 100644
> --- a/arch/powerpc/mm/pgtable-frag.c
> +++ b/arch/powerpc/mm/pgtable-frag.c
> @@ -25,6 +25,7 @@ void pte_frag_destroy(void *pte_frag)
>   	count = ((unsigned long)pte_frag & ~PAGE_MASK) >> PTE_FRAG_SIZE_SHIFT;
>   	/* We allow PTE_FRAG_NR fragments from a PTE page */
>   	if (atomic_sub_and_test(PTE_FRAG_NR - count, &ptdesc->pt_frag_refcount)) {
> +		folio_clear_active(ptdesc_folio(ptdesc));
>   		pagetable_dtor(ptdesc);
>   		pagetable_free(ptdesc);
>   	}


