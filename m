Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2EB3C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 11:26:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 867C08E003D; Mon, 11 Aug 2025 07:26:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 840A76B0159; Mon, 11 Aug 2025 07:26:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 754D88E003D; Mon, 11 Aug 2025 07:26:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5E7DD6B0158
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 07:26:47 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3637F55D16
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:26:47 +0000 (UTC)
X-FDA: 83764249254.04.934AB4D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id F0F404000D
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:26:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CmyEKPnW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754911605; a=rsa-sha256;
	cv=none;
	b=cGNQ8nl867pfj6+h+lxNOOhbM0MYQJRL12jDn2Am3pC3/HiyMqwLtP4435yZ6y6g6zTftm
	U4hraFC80BxoTG7/5Qe0b0en0F6ve2Arsch3PBZYhO2yG+Q3iYYM90T+j0sFqxhV3FY251
	8ROrq56uVRTB2Ik1TNx6OmqGYJ8RRqg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CmyEKPnW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754911605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1yyyzSa9KFCInkfs6rUjYFvQXjYygLyaHB4l27+lC7g=;
	b=zza/C7lX/0iP2Ne+OC2JuRj4oaxUPn4lGsqDwg/kReUySIAo2JX2W0k+0X/tRb7TOVloiE
	YaskBNJ8Ib83YcPJj0QbOraI+b5frlbpkQ6Tl652zZgJhHsNHQhJuuXDOLLXyP1CqILed8
	+HLIU35T/XLtIfGw0U1rUZegpNqey8o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754911604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1yyyzSa9KFCInkfs6rUjYFvQXjYygLyaHB4l27+lC7g=;
	b=CmyEKPnWAknMMDkoHMu8tcrJcCb+WuI+dRrgIA3BlIZ9SFHLLt8mv8NF3yXbx6moLyyvgA
	7rJzMld+9gOBwZfYOJiGjBQgHgCHHpXZCrp2Qw4JZD4huuqEYnhGn1DuDr+hmkYCVtq65S
	C+E7fl4V5AVb4+lUEF8+suvntfgOmI8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-452-m7NJ-7hdMRSv1byMWB3T4Q-1; Mon, 11 Aug 2025 07:26:41 -0400
X-MC-Unique: m7NJ-7hdMRSv1byMWB3T4Q-1
X-Mimecast-MFC-AGG-ID: m7NJ-7hdMRSv1byMWB3T4Q_1754911600
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-459d7da3647so36282955e9.0
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:26:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754911600; x=1755516400;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1yyyzSa9KFCInkfs6rUjYFvQXjYygLyaHB4l27+lC7g=;
        b=oHmLmRa64x+MVp3s2azAbNJOhFJtFZiFUDMK3dH87ucsOHMsA7yf5epsFtOfRS6e4v
         lxmeaPSthjXwJglrpNzrERytvM6EvR7jjICxjZ/BE6dpG7TJeF8bWVWsy3rKaX2N79g+
         qgBI4S4xUevdIniIVhqqw/U8nFImBpmCgsxzWp4UGbGBiDuYnL7bNMNPqXsefpYtqS0K
         qLB9oqDi7utHpVR5eSbRSHmuRf3n3PVrixr0uUHPExt3iGiNJEta0iYdMoKfaMdx+u5M
         To8R+UaQLb9De/Y9P0FAl9+/XmVo+4hTH5F/KwOqmDo/lVmzrVsL15hg6uDb9fDFxpCC
         Uwug==
X-Gm-Message-State: AOJu0YwxCS7NVn+HDQpIGHZyzxeXBb01JY8GzDoTNRT2RlquhqId5LLU
	SeiDrP2ETaoskwTQq6r8d20V8xkfa8MgPYw7GRdVO9VAG6mkQWir3r+YjeBymrzyaekA8A8nv7C
	ShIfRiyf5cvHKalHxFvg7wTgfZRM+3FWirgSuSLljSYNM1cDT77Ne
X-Gm-Gg: ASbGnct3/nGG6Gc1oRMHEGE09ROCb4XjY4BQ/8olJs1qCFUmYhGcMQssv/SX7BJ3AeV
	r0s6oVa5EEPTg4sJCMNtN0ru2Bfsr+rbOPnc+hY+YZbiU8GPX71wGUXn6gZuA5M1LaUa4o6iuSi
	6Was3mXIGOHr2dcYsEBs8wOlkkPDW8VPui76XoZqVugp8Rbzgvyla247LAhqjSIh0LTS1UJTcQd
	xisqrHqi6xjXcYvJ5WSjFBF2537Y+Z4gij3c8t/a/3YdVyD4lJfvvWqC3rD5ggb55pVk8mNGnN0
	bMYcwDfcgo59gwxOYhncGXrIDD/fvQ8Mw83jYJRtTS8Y7fptXZMnbAbaUHPfZGFDp4yviuHzIbF
	2VHq/+UOrGlVeqRta6c2P79gw
X-Received: by 2002:a05:6000:420f:b0:3b7:8c98:2f4c with SMTP id ffacd0b85a97d-3b900b750bfmr10920285f8f.33.1754911599870;
        Mon, 11 Aug 2025 04:26:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG6Mu1XA5qq3G00OwHlXO/yqxgcBzsacx06Jz+W5A1O+vqwNvOeLKy9GaCA2AZU3zaKT01H6g==
X-Received: by 2002:a05:6000:420f:b0:3b7:8c98:2f4c with SMTP id ffacd0b85a97d-3b900b750bfmr10920251f8f.33.1754911599405;
        Mon, 11 Aug 2025 04:26:39 -0700 (PDT)
Received: from localhost (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b79c3ac158sm41049329f8f.4.2025.08.11.04.26.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 04:26:38 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	xen-devel@lists.xenproject.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Hugh Dickins <hughd@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lance Yang <lance.yang@linux.dev>,
	Alistair Popple <apopple@nvidia.com>,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH v3 02/11] mm/huge_memory: move more common code into insert_pud()
Date: Mon, 11 Aug 2025 13:26:22 +0200
Message-ID: <20250811112631.759341-3-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250811112631.759341-1-david@redhat.com>
References: <20250811112631.759341-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9dk4SM10mISlhWKlegW19gK7NHjlI8EVQ7SWefHZkGA_1754911600
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: kqe1qspud5u65tms5hg5nm1thacbifk9
X-Rspam-User: 
X-Rspamd-Queue-Id: F0F404000D
X-Rspamd-Server: rspam02
X-HE-Tag: 1754911604-196919
X-HE-Meta: U2FsdGVkX1/MQLkaBCDzmKsWCypbU0km7GOzo4cetI4CUYXuQmZFNobG+JGO3KrieyDFCftKO/pRHjdnFlTuN0OQgJJxgFmJep/PXt4nc22+PR37L3l6xz9MOEHZPiPTbleOaOPeAuMgPz4eiAmlq4UQWLAWMubSzPeSUzbTvPyEpI0FXM41GZdzgwlUbPVVAYSZbzcXcdET1PrsmijvGlFmNsXUCoVYNrZaV/B53H38Vtbz50+zoO+35Yeg7fOnjF8h13JIKmTthwpU0/tPt6kRplB7xz7vaP3gLnIhkuysECreqr1VFZ6h1EIbJDefZ+XYa9l37fesDc/ihoD1YYlmGuFOGIuoC4yktapDbVr7wYAKVmDKWt5lDGfvQFgb21XPv3aDIROnWeyKSn4nux/HzzKkMk2tkHZm+sbIUla/bm394NEwjYdG2Xh2SThfnOnhY8puMcbBOseH6L5ikd4UdP/gwr1IH8R/NrBU8ZpV1HiXb9WOju9E9pX6uDZtOOXLbdF/g3shOAKzrqVJ7DNg5ZXX1EgzddPr9iDEqOV/jobTGlXG2+l4QCAqQNrJyFo4oWkPMJKjm1YdfvEyyfeLfWPft6ZBe2EOLXBF2fm1oxWs9BWl8LogtK80uH9ImZ6GfCkm6JNSBoXKX/3/AU8xN8RzJW/lwX4J4v1qFcnzYC8Q8Z0k9JGyz0lP2JclhpCOE6Wb75XvQ+YXxtKYKT4gLb2ECEwRG1BrUsg6MUNhaAKATjCRv2bDMWd4i/Juw6LhMljJv9mAym7rbZbRI7Lycfn5HPUPChfhpN4pRnLm+VXwoom/fuY/k1Pu0srtGYTgYRFUrDYjazcEu1HIWp/9fcyK5el7dVHra+1emBCf2rSVZWg56vOV0Gz14Lt7fKXFbDLgT0zFJoRj6BhIfBfi4wO/hH+137duP5v3oxU0tElbkd0Pc8dHDne8lJNcdYXSyvTJQeaVbKGF228
 /IVVrIKa
 EOGlcSOVlgy2PHoWlxL+OD+Rp9KBmFOY3ID73kUmm06KXMDqxScjsvZ7Yf8PgQlkgzDVWvOow69z1MZlPfeB2j5Z6WV+sARkgxr1DjhYFiMm2Y/80GGfeuHusR9egzfMt/3+7C2LcoRL0Hkr8Q6aUxCHX2D0lh1l2Vbjg2Co4ZHYpfTQY8MBDlSm6U/ucswEaXL1g5EWtHytlcIthXTmhH8kvixS5my3xh9H3Ovmnk/R9ejS5bOot+0SlHg53p55VzAWslEok0Do/eO/F2YqaVBtgEAvV5lmEWeSD429ZCSELR4tJAeqU1a2De9SFOZ8h1YjGWhsAtsI4oohx/yOjDacvf9bUy1rt8kAPywFsVnV1txlac/ihCGBI6zS0bCGB0nrNnOc0Hvg7BgDU2VsVfx0kLXzTtmehWfXDlWWegpWK0eWRrXHW9DBpd95HXnzkWTFqF3dG0uP0xT+BIqo8Ro81hYIH5fw8rUi+Ar73oALfR2tdOg8ViiMMSJgykERkUKSdFTTIegous2zIAdAHVGzq2Q1cPMAKh/jV5H5OYbFhsda+83Aafa2vBONGpJkiNIjIIHiFhEdMW2W1DjNtqn0rUjjzhLR8yKa1qZBXlTza77OfnOQ2OUHam22CisfKAAYq98B/rsnXYKRDSm4oAnLodCp2nkyieZRdOvGeKiewAYCH6lXtbL1YVQ+nOxaCmTPWBI4udiBc7XhtEiqK7Nn5wAp9LBpEjt9/qf55zDbIleI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's clean it all further up.

No functional change intended.

Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/huge_memory.c | 36 +++++++++++++-----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5314a89d676f1..7933791b75f4d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1507,25 +1507,30 @@ static pud_t maybe_pud_mkwrite(pud_t pud, struct vm_area_struct *vma)
 	return pud;
 }
 
-static void insert_pud(struct vm_area_struct *vma, unsigned long addr,
+static vm_fault_t insert_pud(struct vm_area_struct *vma, unsigned long addr,
 		pud_t *pud, struct folio_or_pfn fop, pgprot_t prot, bool write)
 {
 	struct mm_struct *mm = vma->vm_mm;
+	spinlock_t *ptl;
 	pud_t entry;
 
+	if (addr < vma->vm_start || addr >= vma->vm_end)
+		return VM_FAULT_SIGBUS;
+
+	ptl = pud_lock(mm, pud);
 	if (!pud_none(*pud)) {
 		const unsigned long pfn = fop.is_folio ? folio_pfn(fop.folio) :
 					  fop.pfn;
 
 		if (write) {
 			if (WARN_ON_ONCE(pud_pfn(*pud) != pfn))
-				return;
+				goto out_unlock;
 			entry = pud_mkyoung(*pud);
 			entry = maybe_pud_mkwrite(pud_mkdirty(entry), vma);
 			if (pudp_set_access_flags(vma, addr, pud, entry, 1))
 				update_mmu_cache_pud(vma, addr, pud);
 		}
-		return;
+		goto out_unlock;
 	}
 
 	if (fop.is_folio) {
@@ -1544,6 +1549,9 @@ static void insert_pud(struct vm_area_struct *vma, unsigned long addr,
 	}
 	set_pud_at(mm, addr, pud, entry);
 	update_mmu_cache_pud(vma, addr, pud);
+out_unlock:
+	spin_unlock(ptl);
+	return VM_FAULT_NOPAGE;
 }
 
 /**
@@ -1565,7 +1573,6 @@ vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, unsigned long pfn,
 	struct folio_or_pfn fop = {
 		.pfn = pfn,
 	};
-	spinlock_t *ptl;
 
 	/*
 	 * If we had pud_special, we could avoid all these restrictions,
@@ -1577,16 +1584,9 @@ vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, unsigned long pfn,
 						(VM_PFNMAP|VM_MIXEDMAP));
 	BUG_ON((vma->vm_flags & VM_PFNMAP) && is_cow_mapping(vma->vm_flags));
 
-	if (addr < vma->vm_start || addr >= vma->vm_end)
-		return VM_FAULT_SIGBUS;
-
 	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
 
-	ptl = pud_lock(vma->vm_mm, vmf->pud);
-	insert_pud(vma, addr, vmf->pud, fop, pgprot, write);
-	spin_unlock(ptl);
-
-	return VM_FAULT_NOPAGE;
+	return insert_pud(vma, addr, vmf->pud, fop, pgprot, write);
 }
 EXPORT_SYMBOL_GPL(vmf_insert_pfn_pud);
 
@@ -1603,25 +1603,15 @@ vm_fault_t vmf_insert_folio_pud(struct vm_fault *vmf, struct folio *folio,
 {
 	struct vm_area_struct *vma = vmf->vma;
 	unsigned long addr = vmf->address & PUD_MASK;
-	pud_t *pud = vmf->pud;
-	struct mm_struct *mm = vma->vm_mm;
 	struct folio_or_pfn fop = {
 		.folio = folio,
 		.is_folio = true,
 	};
-	spinlock_t *ptl;
-
-	if (addr < vma->vm_start || addr >= vma->vm_end)
-		return VM_FAULT_SIGBUS;
 
 	if (WARN_ON_ONCE(folio_order(folio) != PUD_ORDER))
 		return VM_FAULT_SIGBUS;
 
-	ptl = pud_lock(mm, pud);
-	insert_pud(vma, addr, vmf->pud, fop, vma->vm_page_prot, write);
-	spin_unlock(ptl);
-
-	return VM_FAULT_NOPAGE;
+	return insert_pud(vma, addr, vmf->pud, fop, vma->vm_page_prot, write);
 }
 EXPORT_SYMBOL_GPL(vmf_insert_folio_pud);
 #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
-- 
2.50.1


