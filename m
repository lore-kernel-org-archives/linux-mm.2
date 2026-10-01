Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49638CA5FCE
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 20:22:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 183D16B0088; Thu,  1 Oct 2026 16:22:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1359A6B008A; Thu,  1 Oct 2026 16:22:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3E546B008C; Thu,  1 Oct 2026 16:22:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE0186B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 16:22:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B20E01C3370
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 20:22:40 +0000 (UTC)
X-FDA: 85275180480.20.0F84043
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id D11294000A
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 20:22:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Or+Lqa0G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790886159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eLMTu7UZoGmcYCCx72DM7dpOF37u2MNDQkrS/Ch8RZI=;
	b=HLKWnVLh4GPunHzT0T0PMkL6xwFpJkscGbjU+oE2ZddwRkIeG5yR2avT9Yi8ZXzUqu39dI
	9gwZhk3FB91814Xc3ioh2IMY9lhx1RooqIzdx+/Iwz1rEBchHdcn5urE95gNOTdCMHEYCb
	SPi/xNnszf7TJ2F/jcRxizaSjT+sSw4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Or+Lqa0G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790886159;
	b=7nEQ4zBlOWrRa7eYC2JLA9dDmf4RvF2ZMi1r0TKPDQV4t4rMtjP3D0cr2IUBIgM6HJUX+o
	YiqSMsIN46HW0RFLfIPGitkwZR6lbWGgm0dI57JyCtlbwXQtp6mG7TB2IxT1hM6FNlmTfD
	eJLvqfrlMNVFBChwj0fKNyGF1zST73I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4DF6143B6B;
	Thu,  1 Oct 2026 20:22:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB581F00893;
	Thu,  1 Oct 2026 20:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790886157;
	bh=eLMTu7UZoGmcYCCx72DM7dpOF37u2MNDQkrS/Ch8RZI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Or+Lqa0GPXuwhvc+Harb5abpmSPoTuUf2HI0IyojIXiPH0jLGYTjqp8a8DHkhelsu
	 8biX6EZ8sp5UVaio8Sh2Sb+uvejPipX0B1Gy2MjaTB354kSWur8rWWXMasrT0j+NDW
	 KshrSVaBse17Aj1tg24RVAjkzQBBdp2Jw2mSLz0hhFHwh50wBIHb90Qc1SBlIhr1tI
	 ilusTfU/q2Je9wQFaLubIR6ARnBym+9ASXkQYxu8LcDeK/fN7VRaDyfwMERbnBYyj3
	 dXz4AIEROKIH1e6oo35hXvAJanCX0GG5Y2TVSus53vwgcmL53qgKdX1lzTYQxSQSeT
	 mpjLdKzJKLL0A==
Message-ID: <32fe40e2-854a-47ec-9d95-93e23f9a7af4@kernel.org>
Date: Thu, 1 Oct 2026 22:22:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: don't ioremap COWed anon pages in
 generic_access_phys()
To: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
 akpm@linux-foundation.org
Cc: ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, peterx@redhat.com,
 dave.hansen@linux.intel.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 syzbot+49b1021becba70c1f3f6@syzkaller.appspotmail.com
References: <699ae98c.050a0220.340abe.0d31.GAE@google.com>
 <20261001152524.171115-1-ngocthang2710.1999@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261001152524.171115-1-ngocthang2710.1999@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qpgn6naao9d1dfmyqyj9to9pfsxx4bd6
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D11294000A
X-HE-Tag: 1790886158-415153
X-HE-Meta: U2FsdGVkX1+LHgrHmpYoC6l1zem0ZpJu1NSnIUZBD2hW08+VoQFA7QLK1ERuaolVBd0d49DTWq9QP1MtMSuoILBrppBGdnX+bAjC1x1XFyQqdLiGD+AiumvZ9RqFnA7HPDUdwtETgCMrmHEB6j3XPZ2gKldsgZE9FaPQieqPQl7qvSfoHVgfRDsAgufGEzja78bIHYrsaEu8ievtRGTEumZDEzPOGj0n3idZdjSJT8tjklr/5HwgbtpxsQgsxxqX4Kc762CI6Ha0dvMwEbMc4R0AsOIGrNcDojzVlVcQBkHGBVjBCbIyciis/cElyxiOmhtFjEXP7EQzwBCpOz8+uetDYCyPujfATqQ3rfOSRx5fjx+U0AIsuRVdmdwIgWuuMoIIvsdZQMsqKItRgZ8tRjZzXxJOMhHb4EicgwT/fC1iHHgRZ+WA1txE9saOBRLXEzE+5UU1z7vKHkX2U3nLjJ07dz/2P9Iki9Vcivi+kkEn4Agq16kywP4FPkLXFDYuEK/K7T4pxoW3sG87DD/lbc8K+fxSMjDCrPhcr4nJUJRW5v0x9e8zo/NH45raQeawKtMJvcBGYjPYz+O51t6awxWs9TZG7wRd8lKsnzdTwOzmxAnWmweP+PKAPUtA1VUP14ODATAG6aStQYSFjhiVDgGy0T81nkvKV/Bqa1bpM8ySbhaDxOC7oNiQ93xLCzqVPQicSmbPgavzWIWwgG7i2DtzmaKnkqiSsU/AYamt/YqUmUu0a8ZcroJ4LsmYcNz/5lSP3VHtFXG97/80QsV+5sHis0zOJA/3+6PNdS1hMT6niAz5H6Bi/keAEgqkHFDi5hYShDwIbh57tgNaxsonuy4nt1zxBn/0iSaSLxyZ0d0qncJ3TimyW8MCGDWt3KXCfPTG9wXK0CNunlaBJYuFaHg3SgcX2EYSggoPllutyEZ9wuXE3tk8MQayTOygcqJjwEAe7wh+17P7uWbSkYQ
 PIGJftW5
 m48onw0rAaRNzWN0h1JVTVPmHsUfm6ATx28zXLWykuy9TD4lOOBI3OAHZWPTaLGdTxeTQ5rzHUJEBbjTwR4zUJAOKSlvX/jbo/QpGcnOao51ftdGUJ4emhJ026HwlXzDXeTonRxtJ1CGEL88p6jKKH7lltlF6a7c8LkvDMfRloUBMpJwqxSK0NvMw3l00B9nLrf+Pm1esBFiHgLkVbpPnEYrkl/OAU00WX99eERKMnTXpdnsqppdwizLWgTl3Myxyk4avPEU3UWlTYFPl6A1OVcrqX09Kh5IcckjbsuPmZaOq5WMV26x42drEqdyRMTjPxLgvLvLoE5OPuRKdKmeScaPJP3SUTF+C4Bctt2l64gNFgdvzpUWQlpamsDjF3z9W5L08kzw32hCDUBa7l1rHf434HKS5MzKcGXRS3JaV3wFL2LYv+6UsA0q+7OW4T5s7xEV73qxRtvhnLySxFPUBNWla2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/1/26 17:25, Nguyen Ngoc Thang wrote:
> A MAP_PRIVATE mapping of iomem (e.g. a PCI sysfs resourceN file) is a
> COW pfnmap: a write fault replaces the pfn with an anonymous page, which
> remap_pfn_range() allows by keeping vm_pgoff equal to the base pfn.
> 
> generic_access_phys() does not tell those COWed pages apart from the
> original pfns and ioremaps whatever the PTE points to. Reading such an
> address via /proc/pid/mem or ptrace then ioremaps RAM:
> 
>   ioremap on RAM at 0x0000000045623000 - 0x0000000045623fff
>   WARNING: arch/x86/mm/ioremap.c:216 at __ioremap_caller.isra.0+0x4c2/0x5f0
>   Call Trace:
>    generic_access_phys+0x130/0x4d0 mm/memory.c:7178
>    kernfs_vma_access+0x1ce/0x280 fs/kernfs/file.c:437
>    __access_remote_vm+0x58f/0x890 mm/memory.c:7256
>    mem_rw+0x2a1/0x670 fs/proc/base.c:912
> 

Ack, apart from that, nothing bad should happen.

> Reject COWed pages using the same linearity rule vm_normal_page() uses.

Hm I don't enjoy that.

What about letting follow_pfnmap_start() just perform a vm_normal_page()
etc and indicate that information to the caller in the
follow_pfnmap_args() ?

We kind-of have that information in the form of follow_pfnmap_args.special
... but it's not available on all architectures. And it shouldn't exist.

I was thinking a while ago about disallowing follow_pfnmap_start() entirely
on anon folios, but the VM_IO thingy made me assume that there are some
odd users (kvm/vfio) that actually need CoWed folios.

Anyhow, this is what I think we should do for now:


From 0b75f30b137612f18cdee28c8c0dfa96870868c2 Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 1 Oct 2026 22:19:57 +0200
Subject: [PATCH] tmp

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/mm.h |  4 +++-
 mm/memory.c        | 48 ++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 45 insertions(+), 7 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index c49ef99b4413..b90e547797a9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3193,6 +3193,8 @@ struct folio *vm_normal_folio_pmd(struct vm_area_struct *vma,
 				  unsigned long addr, pmd_t pmd);
 struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
 				pmd_t pmd);
+struct folio *vm_normal_folio_pud(struct vm_area_struct *vma,
+		unsigned long addr, pud_t pud);
 struct page *vm_normal_page_pud(struct vm_area_struct *vma, unsigned long addr,
 		pud_t pud);
 
@@ -3245,7 +3247,7 @@ struct follow_pfnmap_args {
 	unsigned long addr_mask;
 	pgprot_t pgprot;
 	bool writable;
-	bool special;
+	bool cow;
 };
 int follow_pfnmap_start(struct follow_pfnmap_args *args);
 void follow_pfnmap_end(struct follow_pfnmap_args *args);
diff --git a/mm/memory.c b/mm/memory.c
index 926276d41920..764b79204ab7 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -843,7 +843,7 @@ struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
  * @addr: The address where the @pmd is mapped.
  * @pmd: The PMD.
  *
- * Get the "struct folio" associated with a PTE. See __vm_normal_page()
+ * Get the "struct folio" associated with a PMD. See __vm_normal_page()
  * for details on "normal" and "special" mappings.
  *
  * Return: Returns the "struct folio" if this is a "normal" mapping. Returns
@@ -879,6 +879,28 @@ struct page *vm_normal_page_pud(struct vm_area_struct *vma,
 	return __vm_normal_page(vma, addr, pud_pfn(pud), pud_special(pud),
 				&entry, sizeof(entry), PGTABLE_LEVEL_PUD);
 }
+
+/**
+ * vm_normal_folio_pud() - Get the "struct folio" associated with a PUD
+ * @vma: The VMA mapping the @pud.
+ * @addr: The address where the @pud is mapped.
+ * @pud: The PUD.
+ *
+ * Get the "struct folio" associated with a PUD. See __vm_normal_page()
+ * for details on "normal" and "special" mappings.
+ *
+ * Return: Returns the "struct folio" if this is a "normal" mapping. Returns
+ *	   NULL if this is a "special" mapping.
+ */
+struct folio *vm_normal_folio_pud(struct vm_area_struct *vma,
+				  unsigned long addr, pud_t pud)
+{
+	struct page *page = vm_normal_page_pud(vma, addr, pud);
+
+	if (page)
+		return page_folio(page);
+	return NULL;
+}
 #endif
 
 /**
@@ -6947,7 +6969,7 @@ static inline void pfnmap_args_setup(struct follow_pfnmap_args *args,
 				     spinlock_t *lock, pte_t *ptep,
 				     pgprot_t pgprot, unsigned long pfn_base,
 				     unsigned long addr_mask, bool writable,
-				     bool special)
+				     struct folio *folio)
 {
 	args->lock = lock;
 	args->ptep = ptep;
@@ -6955,7 +6977,7 @@ static inline void pfnmap_args_setup(struct follow_pfnmap_args *args,
 	args->addr_mask = addr_mask;
 	args->pgprot = pgprot;
 	args->writable = writable;
-	args->special = special;
+	args->cow = folio && folio_test_anon(folio);
 }
 
 static inline void pfnmap_lockdep_assert(struct vm_area_struct *vma)
@@ -7008,6 +7030,7 @@ int follow_pfnmap_start(struct follow_pfnmap_args *args)
 	struct vm_area_struct *vma = args->vma;
 	unsigned long address = args->address;
 	struct mm_struct *mm = vma->vm_mm;
+	struct folio *folio = NULL;
 	spinlock_t *lock;
 	pgd_t *pgdp;
 	p4d_t *p4dp, p4d;
@@ -7047,9 +7070,12 @@ int follow_pfnmap_start(struct follow_pfnmap_args *args)
 			spin_unlock(lock);
 			goto retry;
 		}
+
+		if (vma_is_cow_mapping(vma))
+			folio = vm_normal_folio_pud(vma, address, pud);
 		pfnmap_args_setup(args, lock, NULL, pud_pgprot(pud),
 				  pud_pfn(pud), PUD_MASK, pud_write(pud),
-				  pud_special(pud));
+				  folio);
 		return 0;
 	}
 
@@ -7068,9 +7094,12 @@ int follow_pfnmap_start(struct follow_pfnmap_args *args)
 			spin_unlock(lock);
 			goto retry;
 		}
+
+		if (vma_is_cow_mapping(vma))
+			folio = vm_normal_folio_pmd(vma, address, pmd);
 		pfnmap_args_setup(args, lock, NULL, pmd_pgprot(pmd),
 				  pmd_pfn(pmd), PMD_MASK, pmd_write(pmd),
-				  pmd_special(pmd));
+				  folio);
 		return 0;
 	}
 
@@ -7080,9 +7109,12 @@ int follow_pfnmap_start(struct follow_pfnmap_args *args)
 	pte = ptep_get(ptep);
 	if (!pte_present(pte))
 		goto unlock;
+
+	if (vma_is_cow_mapping(vma))
+		folio = vm_normal_folio(vma, address, pte);
 	pfnmap_args_setup(args, lock, ptep, pte_pgprot(pte),
 			  pte_pfn(pte), PAGE_MASK, pte_write(pte),
-			  pte_special(pte));
+			  folio);
 	return 0;
 unlock:
 	pte_unmap_unlock(ptep, lock);
@@ -7145,6 +7177,10 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 	writable = args.writable;
 	follow_pfnmap_end(&args);
 
+	/* Reject CoW'ed anonymous folios. */
+	if (args.cow)
+		return -EINVAL;
+
 	if ((write & FOLL_WRITE) && !writable)
 		return -EINVAL;
 
-- 
2.43.0


-- 
Cheers,

David

