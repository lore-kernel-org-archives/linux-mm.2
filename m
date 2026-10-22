Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B435606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 17:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=DUdAaHRB
Received: by kanga.kvack.org (Postfix)
	id ADED36B029F; Thu, 22 Oct 2026 13:28:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB6F46B02A5; Thu, 22 Oct 2026 13:28:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CC6A6B02A6; Thu, 22 Oct 2026 13:28:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 728A26B029F
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 13:28:34 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B608E80208
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 17:28:31 +0000 (UTC)
X-FDA: 85350946422.19.1732178
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf01.hostedemail.com (Postfix) with ESMTP id B9E3E40008
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 17:28:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DUdAaHRB;
	spf=pass (imf01.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792690109;
	b=XelxRpsSG0tjP4GNmGG2CXQSqQRe3FidokCFSf+VQ47KENW5bpIlKPDjz0u9sjUTocu38q
	Qq5cUtSOypI92g4NqUbaQiUWeAzR7N0MtZrSf+IZ6P1ByoncL+otDpWhXPU8hlHWVUGKOs
	mLKKaYm2bd2kgddOoFnoGXI1vUUQjAI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DUdAaHRB;
	spf=pass (imf01.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792690109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cLrnGhTI6RKzB8rOxMsMpPnclKeIkJqIQd4I4ioIEaw=;
	b=74Oy930V/lJIax7AD3jSxCkl+W0zk/J001Xk9A2NXzgN/4AWohcgu1ezQIoDND6HyDNsqZ
	ur4Xsui4V+yZdSoH9k42a93xl6BVry9iPZLPo0s0VLtTNQY7cFUR8M300xMSiDmTp31QXl
	0q/g7QZhA9CkW0FO4eIbFqb5b7hdkSs=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c263415982eso8201666b.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792690108; x=1793294908; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cLrnGhTI6RKzB8rOxMsMpPnclKeIkJqIQd4I4ioIEaw=;
        b=DUdAaHRBPNSoVvy0Ze0ov7H1Jq6XWHfl8to7qWkR1Xtpr70F1bPNXcCquQO1AIjW0q
         KNd9pDb+XbNlRMgp4biMxHqkXtbfh1RxmiW2gMAiLog1GAK5Xy8/bE/xjE/gCsaM8Da/
         tqD4EbWv1ZRrPbwG4a131r3y4M3emdOxx7ZXjzzgaOtXO6tK1ejFYp0aYVA+0GjfU8FP
         INHKcrBIR31/cwp/TFPQqERLfdz6H4tOJs8r8dQspdpVLnxS+8QiJ6qjF2It3O2iTCPi
         KR/DVeq7K/7jIKHjUhUcF7/twF/hd38WWG++om2opPM2GB8n7MszpsASgCeIlGF5GCxH
         Y2yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792690108; x=1793294908;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=cLrnGhTI6RKzB8rOxMsMpPnclKeIkJqIQd4I4ioIEaw=;
        b=fyZGNed47HkUcTAAQsaUjJbAHAv+6fvyFCUvD4nfhNQ36DqV5xrIFB31TGPWBjJpoa
         pB/RNSgqvBgibqX7A1VtNkh2xuwTLepzsMqUFp2oW8X/tyEA8yqfnrT2AEeCpcMvL/qE
         gPeIrgLLsrS26u1GR/7Wpb38upl4Dg4eKCnxhgR4VGtQtgKy4wZ/h/mjJDXSul1mpUxK
         5wToBhTm8fLuZV1xhupKha/RktiP9CrBGtc4wa5UPVE964iMF7a6pM5L6vFG4E1tgJDe
         EG6fkcJ1jtQgkv7pcEJ/9QyakuKiqJmmEffdWheu7aO1q+xHuW+wmKhZCzHkihsePlkc
         8swQ==
X-Forwarded-Encrypted: i=1; AKwUvByYyVlRCeP1HLupdm2qAsmEeERtcfifjKuKhPVC3/YFKSM4aPrYTLYbsT3SIEDjIKR1rSd52OF9/A==@kvack.org
X-Gm-Message-State: AFq9FYK3ymeq42oBHexSm433lCXGP/A+hTduF/nXVwLlA3z0e8TBvLfQ
	YEaJRjYxVWxM3TnhDjB6VSX56p936/pELHKACvwDTUQ0y5wlJpXjsX9v
X-Gm-Gg: AYBFou0PBJxUvX1iq3MTpfnq//8YhRn13ibMl4WJrJCxpjbc+9MyTlo3oOtNQq7//kL
	t7cdkni0S4KSuTzZK+WhD0+ywSP3zhgXLwzVhbKCV5VkUxVmdT802msJtl16b6WmIwaBpbBI8T7
	E2qc4NuOf32TZda1f9f7VSdig0RvY8PXc5bGle6jB7lZRGAqUs4O/lyO/gj23b0y0leHzKkw05X
	e33iHeiwctwwdkwc232VuksjfvqNjy0cicfTw7YLuTb65+cYfpiIx2o/fbtO98X4yVPpq0IapSx
	ORTy31yJ275yY1lkScT1239c6ZqU2baBsL+pjTKZY0iblDbCDjCa+/BeA8KfVNWEnEoP2kHD90P
	esmuFfpXIsA4VAZVEpAfjhkmCv2X4CWPd6Xh1lVkR0kGLCsw2MWWNF/4zSVLOZfkNQK/inWmJDE
	K8ZdrI5wzdy7K7uLLz5xkAnKrdp1LklR4BZApHXc7bFVF8b8BcEhUebB/AgG6CSaFX6s2WLiQBr
	+1gv1Jn3xHpJxjjVgonDbpvEU4a2R8VP59RRsjElg==
X-Received: by 2002:a17:906:dc93:b0:c46:645f:cedc with SMTP id a640c23a62f3a-c46799d0f16mr618756166b.46.1792690107814;
        Thu, 22 Oct 2026 10:28:27 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46a5cfa594sm10149166b.80.2026.10.22.10.28.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 10:28:27 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 22 Oct 2026 19:28:25 +0200
To: Hao Ge <hao.ge@linux.dev>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>, kasan-dev@googlegroups.com,
	linux-mm@kvack.org, sashiko-reviews@lists.linux.dev,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Subject: Re: [PATCH v2 3/5] mm/vmalloc: undo partial mappings inside the
 mapping functions
Message-ID: <atpHuSch1sbl9Cz3@milan>
References: <20261019054531.87652-1-hao.ge@linux.dev>
 <20261019054531.87652-4-hao.ge@linux.dev>
 <sashiko-outbox-178439@kernel.org>
 <2b83dfaa-424b-4464-830e-a7714a816d5c@linux.dev>
 <d1ed2d7f-3999-4e8a-a290-1f812a0439af@linux.dev>
 <ateD6VVhyiUAtsER@milan>
 <e58f1712-cfd1-4757-a47f-f8df53b8baf9@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e58f1712-cfd1-4757-a47f-f8df53b8baf9@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: B9E3E40008
X-Stat-Signature: 5tofhtcy9tyfpakuc5kwq8nrxhpwaane
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792690109-788525
X-HE-Meta: U2FsdGVkX19+YANwi43/8K2DjXVPRlnHQFmAtiDeJntujk4yHG73befoiau3wxns+eCrTPWfJ7CFv8M8S32WQKvqLig4eLBywI/nr23u5LsTYLauHKugfIUx1ofaUssndJLiZB+IMsABgPnoD+rVzda82twLsD+iJeCxt4cDmpDHLBEcqGPBllLA6kun0ZtoxzL8OuJnljyyz341IgtsqH4wm5EPD0nh4gohX3pzPOobBwc94JkbCfk5sSeSQkX1RZMQcZyOtFr+cy2zNp4PDIKOPMuSJcyEdAAud+pKGgj0M15PDBFcCm460Re1/wvnRuJjHbJD1k+qY8iaZ4XZVPSV0oJZ4f/08b6uOwux0sJtWbFyxo5HNeU7VYeWK/B66YRJ02dgmqVeJ1/fxeohjcCiq6tyRm7tVNz/nCOL5ygEVg0zc8pqla2H8aC5zve1ez7Mgq+lhN2AxUHJhW/QEu/Be0jvK4iswGMBZqS+yKfSK+YlIf6nOjqf6eF3ehS9RM1pqLG0NLRmkSjFWzhQlp4b7D8RmR70Ou4IZYrJ+1VFP3jQlsHvnAlU3TcBnumkDTBAO0vU1S25sA5TV8gdeboetf/lRtaez8UE1agvcLSejDry8PwvPGCCdvqafeWXxfNdEHcr7NgwaC4fF//4OACtr4JkSzZj9FJDBgVgDE85qKIRKnI+ZBunK9rfxOYU2XJ/c+tvFsseHOanfhqdhgsrrrCSBuGnOIb1GDdn9agRIu9LDML56OBkRDReNQlprcjYzJ1cdW9bt4GeE67/jrgNAL06SUYMzOgas2FWCQdsaf6YHDMW4OivZ57gdd7NsPlrKnfq9IGenc+WFpXqAFL/F/OId6Kui88WgkoJQE+CI0iNHpLqSLZWMtORUkwiGuIH0l4WeCnTHIwIUE8U1BFjNaKH/6JD3J2KsXrZPKSBKiOVwynoi7j/guL9DY0+8xd1ujH900mm7G6lGxp
 BUuynS9f
 Ha0gsJB8qnW94DWadeDmID3xAaFzz8I0gdBHInlTHKCKuU20qYkO6OptLfWcJh6EZ3CY+0ScaPmP91Wq1DaBgznNU7yEX8P5aCSU6ptP7m6vl+s1b7QT+aPuaTFb579fK19W6p4w9ZcFAtEXA4RE4SUDbWP1i+DjeoMy/mkIjfopIdqMn/Key2WkpmX1HeEvnm2kvF2NKpOfZMA+BIQgqU7htYNQstnX8qVT0Y8DhXcPN08G38HfR6etqd1ITwQrwy38SvZavO7M2uKqCxFoCoIVZm78sngsYK+qwVwv56EBqBnx6iiDg6COHDqAoTU0r3vwh083uy630itWiww1ivPx3IsOW7KiXiLuH/yIaKgpz3DleH62/9TYezI9nZmjuOB/JERCgxz4B1habuUzpSa9UNGpMslXg4ylCch9D3kTr0UbiLGrd/HwI7MbXfXu/g2LlmbCYRw07lkeGrk8IVKpngAAUkyj71zTW6CgkmilnkIUKbrBBYqMDej6y44PnJ6g/axmqZclHiYCFmOcPVA9QX7eItFxdYWpW8CJTTBG6jDaNmwNRwxHVbQ91oO6DWtqNFFfZ8XF3Whs3iCzWvCuU/93cCpZmCulg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 09:33:19PM +0800, Hao Ge wrote:
> Hi Uladzislau and Suren
> 
> On 2026/10/20 23:08, Uladzislau Rezki wrote:
> > On Tue, Oct 20, 2026 at 09:27:14PM +0800, Hao Ge wrote:
> >>
> >> On 10/20/26 18:03, Hao Ge wrote:
> >>> Hi Suren and Ulad
> >>>
> >>> Sashiko reported several issues, and they all look real.
> >>> I have some ideas for fixing the first few;
> >>> of course, please correct me if I get anything wrong.
> >>>
> >>> I'd like to discuss the last issue with you all.
> >>>
> >>>
> >>> On 2026/10/20 13:45, sashiko-bot@kernel.org wrote:
> >>>> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> >>>> - [High] mm/vmalloc: infinite loop in vunmap_pte_range() on unaligned error rollback
> >>>> - [High] mm/vmalloc: __vmap_pages_range_noflush() calls cond_resched() in atomic context
> >>>> - [Medium] mm/vmalloc: vmap_page_range() calls flush_cache_vmap() before error rollback
> >>>> --
> >>>>
> >>>> commit 043026437ba63b051df5d14470fe69ce8fa8825c
> >>>> Author: Hao Ge <hao.ge@linux.dev>
> >>>>
> >>>> mm/vmalloc: undo partial mappings inside the mapping functions
> >>>>
> >>>> This commit adds rollback logic using __vunmap_range_noflush() and
> >>>> kmsan_vunmap_range_noflush() into vmap_page_range(),
> >>>> __vmap_pages_range_noflush(), and vmap_pages_range_noflush() when page
> >>>> table installation or KMSAN metadata setup fails. It also adds range and
> >>>> page_shift validation in __vmap_pages_range_noflush().
> >>>>
> >>>>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> >>>>> index 44e0eb32708f1..75aa5acf55660 100644
> >>>>> --- a/mm/vmalloc.c
> >>>>> +++ b/mm/vmalloc.c
> >>>>> @@ -363,6 +363,9 @@ int vmap_page_range(unsigned long addr, unsigned long end,
> >>>>>   	if (!err)
> >>>>>   		err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
> >>>>>   					       ioremap_max_page_shift);
> >>>>> +	if (err)
> >>>>> +		__vunmap_range_noflush(addr, end);
> >>>>> +
> >>>>>   	return err;
> >>>>>   }
> >>>> [Severity: High]
> >>>> What happens here when vmap_range_noflush() returns -EINVAL for a range
> >>>> where end - addr is not PAGE_SIZE-aligned?
> >>>>
> >>>> In vmap_pte_range(), commit a739e6b557af09 added a check to bail out on
> >>>> unaligned ranges specifically to avoid an infinite loop:
> >>>>
> >>>> mm/vmalloc.c:vmap_pte_range() {
> >>>> 	...
> >>>> 	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
> >>>> 		return -EINVAL;
> >>>> }
> >>>>
> >>>> This can be reached on 64KB page kernels via pci_remap_iospace() ->
> >>>> vmap_page_range() with 16KB/32KB/48KB PCI I/O ranges (for example via
> >>>> loongson_pci_probe() or acpi_pci_root_remap_iospace()).
> >>>>
> >>>> When vmap_pte_range() returns -EINVAL, vmap_page_range() now calls
> >>>> __vunmap_range_noflush(addr, end) with the unaligned range. Whenever a PMD
> >>>> in [addr, end) is already populated with a PTE table (such as the
> >>>> PCI_IOBASE PMD populated during early boot by reserve_pio_range(), or an
> >>>> earlier PMD mapped in the same call), __vunmap_range_noflush() descends
> >>>> into vunmap_pte_range(), which has no alignment check:
> >>>>
> >>>> mm/vmalloc.c:vunmap_pte_range() {
> >>>> 	...
> >>>> 	do {
> >>>> 		...
> >>>> 			ptent = ptep_get_and_clear(&init_mm, addr, pte);
> >>>> 		WARN_ON(!pte_none(ptent) && !pte_present(ptent));
> >>>> 	} while (pte += (size >> PAGE_SHIFT), addr += size, addr != end);
> >>>> }
> >>>>
> >>>> Because end - addr is not a multiple of PAGE_SIZE, won't addr step past end
> >>>> and loop infinitely, clearing unrelated kernel PTEs and corrupting memory
> >>>> past the PTE table?
> >>>>
> >>> That sounds reasonable. I will add a separate patch in the next version to fix
> >>> this problem.
> >>>
> >>>> [Severity: Medium]
> >>>> Also in vmap_page_range(), flush_cache_vmap(addr, end) is called
> >>>> unconditionally before checking err and before rolling back with
> >>>> __vunmap_range_noflush(addr, end):
> >>>>
> >>>> mm/vmalloc.c:vmap_page_range() {
> >>>> 	err = vmap_range_noflush(addr, end, phys_addr, pgprot_nx(prot),
> >>>> 				 ioremap_max_page_shift);
> >>>> 	flush_cache_vmap(addr, end);
> >>>> 	if (!err)
> >>>> 		err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
> >>>> 					       ioremap_max_page_shift);
> >>>> 	if (err)
> >>>> 		__vunmap_range_noflush(addr, end);
> >>>>
> >>>> 	return err;
> >>>> }
> >>>>
> >>>> On UML, flush_cache_vmap is defined as flush_tlb_kernel_range:
> >>>>
> >>>> arch/um/include/asm/cacheflush.h:
> >>>> #define flush_cache_vmap flush_tlb_kernel_range
> >>>>
> >>>> When vmap_range_noflush() fails partway through or
> >>>> kmsan_ioremap_page_range() fails, flush_cache_vmap() runs while the
> >>>> partially installed PTEs are still pte_present(), causing
> >>>> update_pte_range() in arch/um/kernel/tlb.c to map them into the host OS via
> >>>> ops->mmap() and clear _PAGE_NEEDSYNC:
> >>>>
> >>>> arch/um/kernel/tlb.c:update_pte_range() {
> >>>> 	...
> >>>> 		if (pte_present(*pte)) {
> >>>> 			...
> >>>> 			ret = ops->mmap(ops->mm_idp, addr, PAGE_SIZE,
> >>>> 					prot, fd, offset);
> >>>> 		} else
> >>>> 			ret = ops->unmap(ops->mm_idp, addr, PAGE_SIZE);
> >>>>
> >>>> 		*pte = pte_mkuptodate(*pte);
> >>>> }
> >>>>
> >>>> When __vunmap_range_noflush(addr, end) then clears the software PTEs
> >>>> without a subsequent TLB flush or unmap notification, won't those host OS
> >>>> mmap mappings be left behind? Should flush_cache_vmap(addr, end) only be
> >>>> called after both vmap_range_noflush() and kmsan_ioremap_page_range()
> >>>> succeed?
> >>>>
> >>> That sounds reasonable. I will add this logic in the next version.
> >>>
> >>>>> @@ -683,27 +686,35 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
> >>>>>   		pgprot_t prot, struct page **pages, unsigned int page_shift)
> >>>>>   {
> >>>>>   	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
> >>>>> +	unsigned long start = addr;
> >>>>> +	int err = 0;
> >>>>> +
> >>>>> +	if (WARN_ON_ONCE(addr >= end))
> >>>>> +		return -EINVAL;
> >>>>>   	if (WARN_ON_ONCE(page_shift < PAGE_SHIFT))
> >>>>>   		return -EINVAL;
> >>>>>   	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
> >>>>> -			page_shift == PAGE_SHIFT)
> >>>>> -		return vmap_small_pages_range_noflush(addr, end, prot, pages);
> >>>>> -
> >>>>> -	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
> >>>>> -		int err;
> >>>>> -
> >>>>> -		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
> >>>>> +			page_shift == PAGE_SHIFT) {
> >>>>> +		err = vmap_small_pages_range_noflush(addr, end, prot, pages);
> >>>>> +	} else {
> >>>>> +		for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
> >>>>> +			err = vmap_range_noflush(addr, addr + (1UL << page_shift),
> >>>>>   					page_to_phys(pages[i]), prot,
> >>>>>   					page_shift);
> >>>>> -		if (err)
> >>>>> -			return err;
> >>>>> +			if (err)
> >>>>> +				break;
> >>>>> -		addr += 1UL << page_shift;
> >>>>> +			addr += 1UL << page_shift;
> >>>>> +		}
> >>>>>   	}
> >>>>> -	return 0;
> >>>>> +	/* Undo the PTEs installed before the failure. */
> >>>>> +	if (err)
> >>>>> +		__vunmap_range_noflush(start, end);
> >>>>> +
> >>>>> +	return err;
> >>>>>   }
> >>>> [Severity: High]
> >>>> Similarly here, __vmap_pages_range_noflush() checks addr >= end, but does
> >>>> not check PAGE_ALIGNED(addr) or PAGE_ALIGNED(end).
> >>>>
> >>>> If a caller passes a sub-page or unaligned range (for example, 0 < end -
> >>>> addr < PAGE_SIZE), nr = (end - addr) >> PAGE_SHIFT evaluates to 0, so the
> >>>> huge-page path still maps nothing and returns 0, while the small-page path
> >>>> loops infinitely in vmap_pages_pte_range(). And if the huge-page path fails
> >>>> on an unaligned range, __vunmap_range_noflush(start, end) will hit the same
> >>>> infinite loop in vunmap_pte_range().
> >>>>
> >>>> Should both vmap_page_range() and __vmap_pages_range_noflush() validate
> >>>> PAGE_ALIGNED(addr) && PAGE_ALIGNED(end) upfront before attempting to map or
> >>>> unmap?
> >>>>
> >>> I think We need to check both PAGE_ALIGNED(addr) and PAGE_ALIGNED(end).
> >>> As an example: if addr is PAGE-aligned, end is not, and end - addr < PAGE_SIZE,
> >>> then nr becomes zero. On the huge page path, we simply return 0 with no work performed.
> >>>
> >>> At the same time, vmap_pages_pte_range() needs the same guard as commit
> >>> a739e6b557af ("mm: vmalloc: WARN_ON if mapping size is not PAGE_SIZE aligned"),
> >>> to protect against unaligned ranges.
> >>>
> >>> So will do next version.
> >>>
> >>>>>   int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
> >>>>> @@ -715,7 +726,16 @@ int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
> >>>>>   	if (ret)
> >>>>>   		return ret;
> >>>>> -	return __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
> >>>>> +
> >>>>> +	ret = __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
> >>>>> +	/*
> >>>>> +	 * The page tables undo themselves on failure. Tear down the
> >>>>> +	 * metadata that was fully set up before the mapping failed.
> >>>>> +	 */
> >>>>> +	if (ret)
> >>>>> +		kmsan_vunmap_range_noflush(addr, end);
> >>>>> +
> >>>>> +	return ret;
> >>>>>   }
> >>>> [Severity: High]
> >>>> Can calling __vunmap_range_noflush() and kmsan_vunmap_range_noflush() here
> >>>> trigger a sleeping-in-atomic-context bug when __vmalloc() or kvmalloc() is
> >>>> called with GFP_ATOMIC or GFP_NOWAIT?
> >>>>
> >>>> __vmalloc_area_node() supports non-blocking allocations by wrapping
> >>>> __vmap_pages_range() in memalloc_apply_gfp_scope(gfp_mask):
> >>>>
> >>>> mm/vmalloc.c:__vmalloc_area_node() {
> >>>> 	...
> >>>> 	flags = memalloc_apply_gfp_scope(gfp_mask);
> >>>> 	do {
> >>>> 		ret = __vmap_pages_range(addr, addr + size, prot, area->pages,
> >>>> 				page_shift, nested_gfp);
> >>>> 	} while ((gfp_mask & __GFP_NOFAIL) && (ret < 0));
> >>>> 	memalloc_restore_gfp_scope(flags);
> >>>> }
> >>>>
> >>>> When a GFP_ATOMIC or GFP_NOWAIT allocation runs in atomic context (such as
> >>>> under a spinlock, preempt_disable(), or rcu_read_lock()) and page table
> >>>> allocation fails in vmap_small_pages_range_noflush() after at least one PMD
> >>>> in [start, end) is populated (or after kmsan_vmap_pages_range_noflush()
> >>>> populated the KMSAN shadow/origin ranges), __vmap_pages_range_noflush() and
> >>>> kmsan_vunmap_range_noflush() synchronously call __vunmap_range_noflush().
> >>>>
> >>>> __vunmap_range_noflush() walks the populated PMDs via vunmap_pmd_range(),
> >>>> which unconditionally calls cond_resched():
> >>>>
> >>>> mm/vmalloc.c:vunmap_pmd_range() {
> >>>> 	...
> >>>> 	do {
> >>>> 		next = pmd_addr_end(addr, end);
> >>>> 		if (pmd_none_or_clear_bad(pmd))
> >>>> 			continue;
> >>>> 		vunmap_pte_range(pmd, addr, next, mask);
> >>>>
> >>>> 		cond_resched();
> >>>> 	} while (pmd++, addr = next, addr != end);
> >>>> }
> >>>>
> >>>> Commit 9c47753167a6 ("mm/vmalloc: defer freeing partly initialized
> >>>> vm_struct") deferred error-path cleanup in __vmalloc_area_node() to a
> >>>> workqueue specifically because unmapping on failure can sleep. Doesn't
> >>>> calling __vunmap_range_noflush() synchronously inside
> >>>> __vmap_pages_range_noflush() and vmap_pages_range_noflush() reintroduce
> >>>> cond_resched() in atomic context?
> >>>>
> >>> This issue also appears real. One possible approach is to plumb the caller's gfp_mask into vunmap_pmd_range()
> >>> to conditionally skip cond_resched().
> >>> Suren, Ulad, do you have any preferred or cleaner way to handle this?
> >>
> >>
> >> Alternatively, we can follow the approach from commit 9c47753167a6
> >> ("mm/vmalloc: defer freeing partly initialized vm_struct"):
> >>
> >> defer the cleanup to a workqueue when |gfp_mask| has GFP_ATOMIC or
> >> GFP_NOWAIT，and perform cleanup synchronously
> >>
> >> if we are already in process context. Anyway, I will look into this further
> >> tomorrow.
> >>
> > I will check the AI concern.
> > 
> 
> Thank you very much for the quick reply and for offering to check
> the AI concern. Much appreciated!
> 
> Here is a summary of what I have found over the last few days.
> I went through the history first. The cond_resched() in vunmap_pmd_range()
> was added by commit e47110e90584 ("mm/vunmap: add cond_resched() in vunmap_pmd_range"),
> modeled after zap_pte_range(). It fixed a real soft lockup: on a non-preemptible
> kernel, unmapping a large persistent-memory namespace (hence a large I/O map region)
> kept a CPU busy for 23 seconds inside the walk:
> 
> 	watchdog: BUG: soft lockup - CPU#49 stuck for 23s! [ndctl:50777]
> 
> Then I looked at how vfree() handles atomic contexts: it defers the
> whole free to a workqueue from interrupt context (vfree_atomic()),
> and 9c47753167a6 does the same for a partly initialized vm_struct.
> 
> Unfortunately I do not think deferral works for this rollback case.
> A deferred rollback returns with the PTEs still installed, and if
> that range is mapped again before the workqueue runs, the mapping
> hits the leftovers: a warning and -EBUSY on the small-page path, a
> BUG() on the huge path.
> 
> So I kept it simple: plumb the caller's gfp_mask down to the unmap
> walk and call cond_resched() conditionally, like
> commit 660654f90e7f ("mm/vmalloc.c: add a schedule point to vmalloc()")
> did:
> 	if (gfp_mask & __GFP_WAIT)
> 		cond_resched();
> 
Sounds good to me. But we have the helper: gfpflags_allow_blocking(gfp_mask))
Another option is probably we can remove cond_resched(); from unmap path?

--
Uladzsislau Rezki

