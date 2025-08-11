Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1564C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 11:27:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D96D8E0042; Mon, 11 Aug 2025 07:27:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1893A6B0172; Mon, 11 Aug 2025 07:27:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0511E8E0042; Mon, 11 Aug 2025 07:27:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E0E896B0171
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 07:27:03 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7060B134EAB
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:27:03 +0000 (UTC)
X-FDA: 83764249926.10.978CCA2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 373D7140008
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:27:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hVVP4aue;
	spf=pass (imf09.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754911621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+EOzLE+RTai94Qoe+vHWeyxEes26RRi+ewlRPXeNOJQ=;
	b=Y/V8Ek6lwruvdUNxpr3IooWzkAsXEteMWWGWltLrsy9Xcq0GtjBRqFh9R1DViFfux3cKH6
	XKg5XJhTeS78l57awBnVWdRmxdUlXFIpBsJ12RtZIUJISADQG/imHiv65wFLmMRS5/gOwf
	12owtYMml72ty7hats5vZTf+FhfsAM4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hVVP4aue;
	spf=pass (imf09.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754911621; a=rsa-sha256;
	cv=none;
	b=JU5DY89BBu3ra4ktCydeysKZhVWCeDLBMndi3dBHYjHUK05yisLS9dyBrFNOTPaKqu7lTJ
	Pz0BqA8ZDtciMEdPo+7+ZCMDW86BJ0iL5WJDf/XzS7zS8nN1SOQiCvwt+KbQuqaDjCXo6c
	Wjhw7gPYQAzgoQOmdIWkh/kF73MGXz4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754911620;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+EOzLE+RTai94Qoe+vHWeyxEes26RRi+ewlRPXeNOJQ=;
	b=hVVP4aueCoOS7lXCo5xbS+v7oP0xgL8ED/uuvs96r2r+XPEQFC+n58IffKorap5T7fHJrL
	yT7LMfceSSk69jDWhWbdXbLbhvjy37KEvsHbOpt9Rf07tU/+ZjPVpgjxc4Jzbn3oJs0EP/
	IeZOU8sHJGj5IluQtLXwWiamM+NW5UA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-180-ZZlWGrRvM8eG15xr8tZjrw-1; Mon, 11 Aug 2025 07:26:59 -0400
X-MC-Unique: ZZlWGrRvM8eG15xr8tZjrw-1
X-Mimecast-MFC-AGG-ID: ZZlWGrRvM8eG15xr8tZjrw_1754911618
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b90ab438b9so469399f8f.2
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:26:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754911618; x=1755516418;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+EOzLE+RTai94Qoe+vHWeyxEes26RRi+ewlRPXeNOJQ=;
        b=ZcmLCimIAtbYqkJyHfp1jAtIGmjwVvmwFPeCMdjiE85gfxEBMiS85Ag/j1mjYJJHrL
         pa3zgTWISy8nWu7mGUtKcfLzvBxTnmV/eWISi/HDjE38Hhhu5a7SXAVMGYVx2VjPaLVx
         zdeXUElgBXiQHwvKIjsVyckqqnw1VxxBq0weP+bcITAHf4/c2Iqw9TgmfJiKlcxkLPm3
         lvbuWtXXtuaFhOc/qkJZTgeMoWrLbvMf6oS2NiJRC5lh3ii5hyFa5273BJvryg3Agkng
         2r4a/4UchkUj+4R0QlCNGVhFEE/PyDCgYafUhApTVytcdJQDM+Yu1z+bglHhZJ0wCUUf
         uPYw==
X-Gm-Message-State: AOJu0YxLoEypqMcA18EzdISVK079IKiOkjfiVWDVRK9FY3sJ1TGh7XgC
	u3PpTyywD2Qc+NgNBbziRP7+P7I7fQcm3tXb1Byg2IC9P7fUyriDpChIMdWN1n3+2TNQztoXfj0
	W6taO8OH2ce6IAr40zAuMZkubhozGbfOffU4El47LDeCy6gl2Qu6I
X-Gm-Gg: ASbGncscQunU+lUVM/dpo0pbiBg1m3CcpY8FGTlcoxS6p9KaLS1uuc6ljYXHcMAoZlk
	ZzKxthU4+6fkCQEGlbrL4er4YR/BBTgENQLmrxJpZd3LFZAa0BC9nOWEh9LSiilun2TcDJ4uaRz
	RSWV3mgNPoPXShqY6JNnEz4oNyrLBXRcgAs1gtfGrX+BOym3ABeVPFHvvNuqIKHITMwEmAIOhdZ
	VdMQyA70aSe1YWUomArinw8z6SBMwsScePHCBcletWgT1UrHEKMYkMyZyVjHk6aCPeGEHbJ2Dmu
	Pcd3Y5I4OzO+ft3PsoFGZ+auwEGixPhMa6xKWfsswnScRhfvhpxauvyVkTYq4GJUyXl+6TwN6KH
	EiYoflsLfStBvn/p2pWEc+jBi
X-Received: by 2002:a05:6000:40da:b0:3b7:9d87:97c6 with SMTP id ffacd0b85a97d-3b900b552ccmr11182473f8f.44.1754911617647;
        Mon, 11 Aug 2025 04:26:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHgzaZVe/bWq5ilsSm3I+nGmnBoU4tOWHlsDn35ubDMQPCamCfdsJ8Ebz2VnZDz+OwT7Da1fQ==
X-Received: by 2002:a05:6000:40da:b0:3b7:9d87:97c6 with SMTP id ffacd0b85a97d-3b900b552ccmr11182439f8f.44.1754911617130;
        Mon, 11 Aug 2025 04:26:57 -0700 (PDT)
Received: from localhost (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b79c453d6esm40173200f8f.37.2025.08.11.04.26.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 04:26:56 -0700 (PDT)
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
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v3 09/11] mm/memory: factor out common code from vm_normal_page_*()
Date: Mon, 11 Aug 2025 13:26:29 +0200
Message-ID: <20250811112631.759341-10-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250811112631.759341-1-david@redhat.com>
References: <20250811112631.759341-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MTJYkOXgmrilzgUfN6BqMCrZKgc3JARxq-uSn5vUlvA_1754911618
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: 9phkxwiey8wirtfy18w3df8gnua5wrzc
X-Rspam-User: 
X-Rspamd-Queue-Id: 373D7140008
X-Rspamd-Server: rspam05
X-HE-Tag: 1754911621-39414
X-HE-Meta: U2FsdGVkX19a25w0rFCrFi7/0/sJ6QseVWjKNUjtAMRzstT8iipmMVrnrg7aFL2xrmwN/TEGoDhwPoF0kmKpvLvRIdwbEM0I4PTP8sjeS2blO1KTZ0IX5j24SaJ2da/MQ5NlgL7UNtMhMtBdhhN4hIXU2Hi/pp9lX81jvh0K7gS5+j/pFKw1M8AP0JToDZFkSsggMK0vSjMZa5mO6EQyCpAcVtRQbf2wEpSH60CFyOBdr+bkeEDKdCYgdg8ELpLmeNTed/99L3qgU5BxXAOssWgKKdmhG6DuRCftC+QrBw7vEkegyP+W2ei8vl5Q0kH2MyvwocK1ZsSRo7kHktzDzutdrLby/m0w+nF/X7NeLuZqcrKPcTz/DqlmTGHzvjR+sGGHM+TdULdR+S1oSbS/yDF4gcN3ZuG57pDG7I19+CPoLYsr/8qWEw2ibJBdS50tBrFYgOXqHVvm89pFs9wuU9VtptoEe1x6Up9og83uKk6O7X9VFqavPNt71pQjW11EzWa4x8qw5flKA8wz2mXl2D5xh4l5jNqysoYs0KTfIbS/FNjpxgog4I6ei6EQqjZQ6xQrjdvLnVLg9OjiP/2VyfNnEmZjUv1oHnBx7ajyFxaqon/LQhU5rE3wTJsY+gblnWMijTHYznCpk+qFHQQL23JxZ86CwSfA4A6rUyJzO1qhu2ffLfy/981L4vUyDuWfe4gphSpBAoyIfPCUZBiSw71yKM/CGwg38lGtGnZSD6xLBAqeV2RFpr8MOSU4/RQSC1lm0MrgyVf4dH4LY/KyvIDNqp9Rr3V02a1wDk9v3F4G++u1llvWhp0T4JEAKoD67OC5LLF37DL8Bx8mieNj1T4Jzgdid9dN551RM61MaU4GQ+0ty4P+EVxGxDtJeYNDiEERlYuHqyNPqD1WHfoXb9VtdOj9yNnwGjpHIGropXzCvzwwfH2xnh3mGAEq9znN27zyHO+mZSqyzW2kiRw
 3ZU6g57n
 kB37V6/OjVkiaQDckrNplCqte0HczV7F6uopILfNOX6LqXhHXWj3XiMaaUuw2SjKrcm5sTwQciTHN0hp4Rr9Ph5m4+X3M9fkTp+lg3wi+vJuruAp5hNClXGO0EB3+Q68pGm4w5hWcg9l6h48DMI7IJpWZQ3huMOlQZAIOiYxOw2G+jKYvl1s9UJFM3BE99PvbjWkEh2lQ/HQRkiSStGAerb1YXHQ5KZaIUUtLuJXPSV32wq8fDqr9J0UHs4RZQJ3sBEPBcQtBeTPedDQGJMVdKPi6qlO7h8lroYynJtOYBuRqKMu/SVX/ru+ZwoVgvnPTU2BDiWuvTiO/BEZzWT36/74kWq9OD3B4Jt11XAUmpsytbd8So/IBoByLAmc2JDcJu0+jXWLLqC1tYMhMtZWz8y4iE5VzJaksidwKywCcUevi5CN6+LS9ZdNAGaNwCxiZo6hQXpiUW1vyiy/7h1CiDCfB88hmQVpRCQj3F5SNMXXPlLY5puUj7Bd3Q0A7P1xf81VIZk4oFJjuJdCOTtlbqA2IFFYEgVVCwQPWM19PrA0uAQeafap4A3AQPA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's reduce the code duplication and factor out the non-pte/pmd related
magic into __vm_normal_page().

To keep it simpler, check the pfn against both zero folios, which
shouldn't really make a difference.

It's a good question if we can even hit the !CONFIG_ARCH_HAS_PTE_SPECIAL
scenario in the PMD case in practice: but doesn't really matter, as
it's now all unified in vm_normal_page_pfn().

Add kerneldoc for all involved functions.

Note that, as a side product, we now:
* Support the find_special_page special thingy also for PMD
* Don't check for is_huge_zero_pfn() anymore if we have
  CONFIG_ARCH_HAS_PTE_SPECIAL and the PMD is not special. The
  VM_WARN_ON_ONCE would catch any abuse

No functional change intended.

Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/memory.c | 186 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 109 insertions(+), 77 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index dc0107354d37b..78af3f243cee7 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -614,8 +614,14 @@ static void print_bad_page_map(struct vm_area_struct *vma,
 #define print_bad_pte(vma, addr, pte, page) \
 	print_bad_page_map(vma, addr, pte_val(pte), page, PGTABLE_LEVEL_PTE)
 
-/*
- * vm_normal_page -- This function gets the "struct page" associated with a pte.
+/**
+ * __vm_normal_page() - Get the "struct page" associated with a page table entry.
+ * @vma: The VMA mapping the page table entry.
+ * @addr: The address where the page table entry is mapped.
+ * @pfn: The PFN stored in the page table entry.
+ * @special: Whether the page table entry is marked "special".
+ * @level: The page table level for error reporting purposes only.
+ * @entry: The page table entry value for error reporting purposes only.
  *
  * "Special" mappings do not wish to be associated with a "struct page" (either
  * it doesn't exist, or it exists but they don't want to touch it). In this
@@ -628,10 +634,10 @@ static void print_bad_page_map(struct vm_area_struct *vma,
  * Selected page table walkers (such as GUP) can still identify mappings of the
  * shared zero folios and work with the underlying "struct page".
  *
- * There are 2 broad cases. Firstly, an architecture may define a pte_special()
- * pte bit, in which case this function is trivial. Secondly, an architecture
- * may not have a spare pte bit, which requires a more complicated scheme,
- * described below.
+ * There are 2 broad cases. Firstly, an architecture may define a "special"
+ * page table entry bit, such as pte_special(), in which case this function is
+ * trivial. Secondly, an architecture may not have a spare page table
+ * entry bit, which requires a more complicated scheme, described below.
  *
  * A raw VM_PFNMAP mapping (ie. one that is not COWed) is always considered a
  * special mapping (even if there are underlying and valid "struct pages").
@@ -664,63 +670,94 @@ static void print_bad_page_map(struct vm_area_struct *vma,
  * don't have to follow the strict linearity rule of PFNMAP mappings in
  * order to support COWable mappings.
  *
+ * Return: Returns the "struct page" if this is a "normal" mapping. Returns
+ *	   NULL if this is a "special" mapping.
  */
-struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
-			    pte_t pte)
+static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
+		unsigned long addr, unsigned long pfn, bool special,
+		unsigned long long entry, enum pgtable_level level)
 {
-	unsigned long pfn = pte_pfn(pte);
-
 	if (IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL)) {
-		if (likely(!pte_special(pte)))
-			goto check_pfn;
-		if (vma->vm_ops && vma->vm_ops->find_special_page)
-			return vma->vm_ops->find_special_page(vma, addr);
-		if (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))
-			return NULL;
-		if (is_zero_pfn(pfn))
-			return NULL;
-
-		print_bad_pte(vma, addr, pte, NULL);
-		return NULL;
-	}
-
-	/* !CONFIG_ARCH_HAS_PTE_SPECIAL case follows: */
-
-	if (unlikely(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP))) {
-		if (vma->vm_flags & VM_MIXEDMAP) {
-			if (!pfn_valid(pfn))
+		if (unlikely(special)) {
+			if (vma->vm_ops && vma->vm_ops->find_special_page)
+				return vma->vm_ops->find_special_page(vma, addr);
+			if (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))
 				return NULL;
-			if (is_zero_pfn(pfn))
-				return NULL;
-			goto out;
-		} else {
-			unsigned long off;
-			off = (addr - vma->vm_start) >> PAGE_SHIFT;
-			if (pfn == vma->vm_pgoff + off)
-				return NULL;
-			if (!is_cow_mapping(vma->vm_flags))
+			if (is_zero_pfn(pfn) || is_huge_zero_pfn(pfn))
 				return NULL;
+
+			print_bad_page_map(vma, addr, entry, NULL, level);
+			return NULL;
 		}
-	}
+		/*
+		 * With CONFIG_ARCH_HAS_PTE_SPECIAL, any special page table
+		 * mappings (incl. shared zero folios) are marked accordingly.
+		 */
+	} else {
+		if (unlikely(vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))) {
+			if (vma->vm_flags & VM_MIXEDMAP) {
+				/* If it has a "struct page", it's "normal". */
+				if (!pfn_valid(pfn))
+					return NULL;
+			} else {
+				unsigned long off = (addr - vma->vm_start) >> PAGE_SHIFT;
 
-	if (is_zero_pfn(pfn))
-		return NULL;
+				/* Only CoW'ed anon folios are "normal". */
+				if (pfn == vma->vm_pgoff + off)
+					return NULL;
+				if (!is_cow_mapping(vma->vm_flags))
+					return NULL;
+			}
+		}
+
+		if (is_zero_pfn(pfn) || is_huge_zero_pfn(pfn))
+			return NULL;
+	}
 
-check_pfn:
 	if (unlikely(pfn > highest_memmap_pfn)) {
-		print_bad_pte(vma, addr, pte, NULL);
+		/* Corrupted page table entry. */
+		print_bad_page_map(vma, addr, entry, NULL, level);
 		return NULL;
 	}
-
 	/*
 	 * NOTE! We still have PageReserved() pages in the page tables.
-	 * eg. VDSO mappings can cause them to exist.
+	 * For example, VDSO mappings can cause them to exist.
 	 */
-out:
-	VM_WARN_ON_ONCE(is_zero_pfn(pfn));
+	VM_WARN_ON_ONCE(is_zero_pfn(pfn) || is_huge_zero_pfn(pfn));
 	return pfn_to_page(pfn);
 }
 
+/**
+ * vm_normal_page() - Get the "struct page" associated with a PTE
+ * @vma: The VMA mapping the @pte.
+ * @addr: The address where the @pte is mapped.
+ * @pte: The PTE.
+ *
+ * Get the "struct page" associated with a PTE. See __vm_normal_page()
+ * for details on "normal" and "special" mappings.
+ *
+ * Return: Returns the "struct page" if this is a "normal" mapping. Returns
+ *	   NULL if this is a "special" mapping.
+ */
+struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
+			    pte_t pte)
+{
+	return __vm_normal_page(vma, addr, pte_pfn(pte), pte_special(pte),
+				pte_val(pte), PGTABLE_LEVEL_PTE);
+}
+
+/**
+ * vm_normal_folio() - Get the "struct folio" associated with a PTE
+ * @vma: The VMA mapping the @pte.
+ * @addr: The address where the @pte is mapped.
+ * @pte: The PTE.
+ *
+ * Get the "struct folio" associated with a PTE. See __vm_normal_page()
+ * for details on "normal" and "special" mappings.
+ *
+ * Return: Returns the "struct folio" if this is a "normal" mapping. Returns
+ *	   NULL if this is a "special" mapping.
+ */
 struct folio *vm_normal_folio(struct vm_area_struct *vma, unsigned long addr,
 			    pte_t pte)
 {
@@ -732,42 +769,37 @@ struct folio *vm_normal_folio(struct vm_area_struct *vma, unsigned long addr,
 }
 
 #ifdef CONFIG_PGTABLE_HAS_HUGE_LEAVES
+/**
+ * vm_normal_page_pmd() - Get the "struct page" associated with a PMD
+ * @vma: The VMA mapping the @pmd.
+ * @addr: The address where the @pmd is mapped.
+ * @pmd: The PMD.
+ *
+ * Get the "struct page" associated with a PTE. See __vm_normal_page()
+ * for details on "normal" and "special" mappings.
+ *
+ * Return: Returns the "struct page" if this is a "normal" mapping. Returns
+ *	   NULL if this is a "special" mapping.
+ */
 struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
 				pmd_t pmd)
 {
-	unsigned long pfn = pmd_pfn(pmd);
-
-	if (unlikely(pmd_special(pmd)))
-		return NULL;
-
-	if (unlikely(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP))) {
-		if (vma->vm_flags & VM_MIXEDMAP) {
-			if (!pfn_valid(pfn))
-				return NULL;
-			goto out;
-		} else {
-			unsigned long off;
-			off = (addr - vma->vm_start) >> PAGE_SHIFT;
-			if (pfn == vma->vm_pgoff + off)
-				return NULL;
-			if (!is_cow_mapping(vma->vm_flags))
-				return NULL;
-		}
-	}
-
-	if (is_huge_zero_pfn(pfn))
-		return NULL;
-	if (unlikely(pfn > highest_memmap_pfn))
-		return NULL;
-
-	/*
-	 * NOTE! We still have PageReserved() pages in the page tables.
-	 * eg. VDSO mappings can cause them to exist.
-	 */
-out:
-	return pfn_to_page(pfn);
+	return __vm_normal_page(vma, addr, pmd_pfn(pmd), pmd_special(pmd),
+				pmd_val(pmd), PGTABLE_LEVEL_PMD);
 }
 
+/**
+ * vm_normal_folio_pmd() - Get the "struct folio" associated with a PMD
+ * @vma: The VMA mapping the @pmd.
+ * @addr: The address where the @pmd is mapped.
+ * @pmd: The PMD.
+ *
+ * Get the "struct folio" associated with a PTE. See __vm_normal_page()
+ * for details on "normal" and "special" mappings.
+ *
+ * Return: Returns the "struct folio" if this is a "normal" mapping. Returns
+ *	   NULL if this is a "special" mapping.
+ */
 struct folio *vm_normal_folio_pmd(struct vm_area_struct *vma,
 				  unsigned long addr, pmd_t pmd)
 {
-- 
2.50.1


