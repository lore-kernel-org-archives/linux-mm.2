Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06500C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 11:27:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3860E6B0168; Mon, 11 Aug 2025 07:26:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 336648E0043; Mon, 11 Aug 2025 07:26:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D7CD8E0042; Mon, 11 Aug 2025 07:26:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 073256B0168
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 07:26:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CA0AD16012E
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:26:57 +0000 (UTC)
X-FDA: 83764249674.06.E4C9D0D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9E8341C000D
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:26:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cnTBegtj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754911615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P87rLpAYrvMbmMGGuIRrtBN562miOXHo6Y54j1JPV6I=;
	b=fPW+3ffBZQGfKCCEtjKYEGUJPpNs0w0QewNu+pKdbrMiJ2pPoIzm57GyKdnTUc9aVVHzR1
	VEGFjOaMZzZr2Fr4uEI49HT5KyhDUiPkeSA20UNRQ6NUp+yTwEM0F/qE68RwsM8k1U28H6
	C6AqqfuPlaGrgt6RFWFcTGnx7cWmqC0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754911615; a=rsa-sha256;
	cv=none;
	b=iy8xR/jrh5TRaa6rrTWa7ZfIAUkPcXM2LDgHzNyhxKSfQi8nGqIOwShmPPMHj4Ruwv/fRO
	8sPBTuVrGRneVEkRlo++SSp5+oEKkhUgcsSuUCShTPiiD2P/MwzNBZP8TKcj/geIa5KREk
	0ltCJDs6VorzncQmBediumd9bVxzEsE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cnTBegtj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754911615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P87rLpAYrvMbmMGGuIRrtBN562miOXHo6Y54j1JPV6I=;
	b=cnTBegtjCtwdi9jmHMhftrWMtKrvTFxEJIIR9jl9DLgOVzIVcHkkbDVNMBfYJPKKjs8sUu
	V1IeVqYZ2VOVe/PJOxRXg+r7qNZb8Udh9euA0hckBfXfAZCDUEX6dVVLgfAKo7yuFSY4go
	XxtOmX4zdWbAYFQtizayN6rYxrA5+YU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-MrIB99tfNo2Wr980vESwwg-1; Mon, 11 Aug 2025 07:26:54 -0400
X-MC-Unique: MrIB99tfNo2Wr980vESwwg-1
X-Mimecast-MFC-AGG-ID: MrIB99tfNo2Wr980vESwwg_1754911613
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-459de0d5fb1so33830865e9.0
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:26:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754911613; x=1755516413;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P87rLpAYrvMbmMGGuIRrtBN562miOXHo6Y54j1JPV6I=;
        b=sjFFolSLPu7rOk74SC+xlNm9TxyItYP73HQbYU1S4IK9cDVWBx5suCh/Ts6xCRNMec
         3jp1pGnKzYUw+NuFuxKl3HGsTqAXLvHRhGVk0PueoDe/p4KN5iVeHqjdPc4vU/T+K/ag
         VIsz181gbYOrPCHTfP0Cru9T6+s05y3+vHC2ckkuqrbw22/tQ3B+OgNFUzz/Zjcmew1q
         aJEL/JhSt/l9cLF+UqJXyufnz142Gvqwlb3YltpJ3xh9U/HKUlkSqwpZLRdw77QIHh7F
         ZBJ7vtDgfYH2TQoth3qgjrPln4iKAm4cD+WkgDfkY3468J4ELujYf+pY6RuZVF64aXRB
         HoZA==
X-Gm-Message-State: AOJu0YzHSEkDrg0oKT3i1I9ybnE9xNRKbDxyWkMktt7aYuSbr6EetfJh
	hpW4jjerX8hNcdlv2ttkBY0Kww/GNYHSgGjjreU+T6LlMDZ/KaI9QNPXl+IejEbY3ZoUNTScdwJ
	q/aqq9pQiuEj7PEccLJvmS2q2neWPkccubhHfJ/miruwqSbckiqux
X-Gm-Gg: ASbGncuZ8MjXWk2HBlMusHe+fU+ARRBSjlAYy8yVLH1CoiDwKOeNoe9B445xE24lasJ
	n9H4tLfHQOUp4IpOge2PL5bfQzQPUQIWdBhc9w7YtbBWDo+OlRRZD7pNfnUwi+hHmiSbmXT6VHf
	3U2QiKKS0b6zbPcR2G/Hf3yDPJcxDfJBSD01D7pyIwwXhORONhyDNx1rI5bCqTDDFKHCP+Vz8Lc
	KxRzbQ4SMAG3Jhv/xeQZXWX58iTyZAyhifZbS+yPD7Pmu1sWAM/KsV//b8E5bItIG+DUVFMxEIw
	yHMFb6ou2Nt+qGd9y4kiZtaHGKZG3JA4csVflL4N3cRXRSMYN1UHpx6zoaZqB/4BaiQg3E9MXkE
	KOeDqLGmsQWymYvxQFXs6JbWz
X-Received: by 2002:a05:600c:3589:b0:459:dfa8:b881 with SMTP id 5b1f17b1804b1-459f4f3cfd9mr103523435e9.7.1754911612595;
        Mon, 11 Aug 2025 04:26:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEiy2Q6M1gIlNBDGe4u7ez53xLkuOFeUzXf29NvQrYJzqDFFp1B3pMcW/PtvRUdMabZHM2Urw==
X-Received: by 2002:a05:600c:3589:b0:459:dfa8:b881 with SMTP id 5b1f17b1804b1-459f4f3cfd9mr103523005e9.7.1754911612074;
        Mon, 11 Aug 2025 04:26:52 -0700 (PDT)
Received: from localhost (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b79c3bf93dsm40409120f8f.27.2025.08.11.04.26.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 04:26:51 -0700 (PDT)
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
Subject: [PATCH v3 07/11] mm/rmap: convert "enum rmap_level" to "enum pgtable_level"
Date: Mon, 11 Aug 2025 13:26:27 +0200
Message-ID: <20250811112631.759341-8-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250811112631.759341-1-david@redhat.com>
References: <20250811112631.759341-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vInbLgkFOrb4t2z_mXOOzUvmhzdhe6wFotFt9k3p0ZY_1754911613
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: ujskz5ybd3t718h6hmoe1iypidhaz3f3
X-Rspamd-Queue-Id: 9E8341C000D
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754911615-983847
X-HE-Meta: U2FsdGVkX19OtNsBbBn00u8bg1FTWcn14vHngAW8cd/kgTgfqy5IPHTIlmUcFOtyjI8JrDDRDLmWA4ltKqGMdN4VUVgi/aZccRF+UJJhITLv9HyoRA+8aV2gVYHpuR9RKnj2JhqhnDeCH1NZG4nQYw2hs5+G4NpkJWhZKHEuQzS/fVq9ofef7UpAeNADxY47OIzvDW4WbYm/hq1GCyekgCMojuVCfP3PXEsncQJ+tr/1J5JkVQZdyjjC6zUfOyB3MyCttXi7nyIl2kSZrcGJXkQfiA/hpTPkgj5U+3Dz6JJ90tJLsJNX5TTk/6UixmD0ejYcJg3NDOR2BEaNl+IsPiefZm0OYKN7PoXBeWAMx9hADtCizXi7AMMDjcpTAHmU/Ly3DYJ/lu0OFSbwQ3t48SAE3z5ISRLWC9YCQ/LnQVjV7N1TeE5uAoEu7M6RUTHg1UjA1zrKqCUuV1bkqZDrKZKWAFYHX1F2yqya7uQ1E1YTk5dRS9f2M72ykXQBOlH3SBjG8aUh0FSswxGAL9FuZRuf8xyOaizGXCFDztNDlHKLw5Hp8avUcqQVASJBRJay1DFPQs44t/80vDxPMM8tqL0bq0R0kvE0uqbSTM+p67q6GFVuRgQ1S+aHQVNL+bt/iyK7fBK/gwXncGhRrbBynWehGN/Yz3ROToQXXXMh6edPcskZXhiIr3xqGxO5P5mRH5KExVXeNkxcxs7SSOz6yHYmf0kgNXk5XmU3aRQCFrWcL6q7SPdnDs4GNcpIx2jbGTRdZDCIoscHMJ/54FaTjdf9Ifonm2TnqIPp+su6EotXU85O1/vJFUW2KL9S9kGyu0QKdZovKwZFWwV57uJiwnfKGe0aHLueOkIZWW9/2nQmyZMY8sydBImUk7kGhJnpbc8ibe+9Sl0jlvjdzsJyCH6hgphVLNseKxXoInE0a2igcP2gaxouY/5ZOmh7tx7CHhPCsBA5fJ4ccDS2+52
 nvr4fVXL
 pC5eU8Vymx+ydfhyV8CclQsVyLCfnEf4Cq3ZptahbuRomljqLApYQ8zsYNpDdECcHDVbEDzavLXtSNwrXIqYU6t2GIEXsyskpJbQELoEN1d8ZTfGIzBNOVWBmwUjeaeOOay11oHEVUGR+AHzLtZV7N8ESC289GrPykEv7J1xefv1agsrQ9csPxRplH7ZhH1fZJ/fMLvT8OMXZv7PrtfE6LN6bB/pKUCoDC+V29AF5K8Ik0Gxivcxkn9BRHASXFKKhQUMFZo1b5YK8tzKTTUpP42SmlreqMmVylc+0CKChQeTeM5PU7hbdbYL1K83zQtZrfNa6GtXWOWm6OyUaVM+6MXHNIKb04F7W1tiqNi33EGtVk82Np7URKzQhoYGJvFoVyBfBz9TqFZ39uNSqt4FXJomf/gG6qjeiMHKNTU0X2BTCni6K2aqMUN8fhm50KDeNHBBn4EQLgYPzEgiXmUx2FxZAXjkhZenBfwWkiYzuBeixKnj0KqNcRihII6yIQBJohMm891d4unoMchZknusA2cC/ktwEyM/VD89l4xvrS+ZKN2ozBApZbTtx9QYxXGDv5lit44I8SwFlW/dfHcP1Y1viKQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's factor it out, and convert all checks for unsupported levels to
BUILD_BUG(). The code is written in a way such that force-inlining will
optimize out the levels.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/pgtable.h |  8 ++++++
 include/linux/rmap.h    | 60 +++++++++++++++++++----------------------
 mm/rmap.c               | 56 +++++++++++++++++++++-----------------
 3 files changed, 66 insertions(+), 58 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 4c035637eeb77..bff5c4241bf2e 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1958,6 +1958,14 @@ static inline bool arch_has_pfn_modify_check(void)
 /* Page-Table Modification Mask */
 typedef unsigned int pgtbl_mod_mask;
 
+enum pgtable_level {
+	PGTABLE_LEVEL_PTE = 0,
+	PGTABLE_LEVEL_PMD,
+	PGTABLE_LEVEL_PUD,
+	PGTABLE_LEVEL_P4D,
+	PGTABLE_LEVEL_PGD,
+};
+
 #endif /* !__ASSEMBLY__ */
 
 #if !defined(MAX_POSSIBLE_PHYSMEM_BITS) && !defined(CONFIG_64BIT)
diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 6cd020eea37a2..9d40d127bdb78 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -394,18 +394,8 @@ typedef int __bitwise rmap_t;
 /* The anonymous (sub)page is exclusive to a single process. */
 #define RMAP_EXCLUSIVE		((__force rmap_t)BIT(0))
 
-/*
- * Internally, we're using an enum to specify the granularity. We make the
- * compiler emit specialized code for each granularity.
- */
-enum rmap_level {
-	RMAP_LEVEL_PTE = 0,
-	RMAP_LEVEL_PMD,
-	RMAP_LEVEL_PUD,
-};
-
 static inline void __folio_rmap_sanity_checks(const struct folio *folio,
-		const struct page *page, int nr_pages, enum rmap_level level)
+		const struct page *page, int nr_pages, enum pgtable_level level)
 {
 	/* hugetlb folios are handled separately. */
 	VM_WARN_ON_FOLIO(folio_test_hugetlb(folio), folio);
@@ -427,18 +417,18 @@ static inline void __folio_rmap_sanity_checks(const struct folio *folio,
 	VM_WARN_ON_FOLIO(page_folio(page + nr_pages - 1) != folio, folio);
 
 	switch (level) {
-	case RMAP_LEVEL_PTE:
+	case PGTABLE_LEVEL_PTE:
 		break;
-	case RMAP_LEVEL_PMD:
+	case PGTABLE_LEVEL_PMD:
 		/*
 		 * We don't support folios larger than a single PMD yet. So
-		 * when RMAP_LEVEL_PMD is set, we assume that we are creating
+		 * when PGTABLE_LEVEL_PMD is set, we assume that we are creating
 		 * a single "entire" mapping of the folio.
 		 */
 		VM_WARN_ON_FOLIO(folio_nr_pages(folio) != HPAGE_PMD_NR, folio);
 		VM_WARN_ON_FOLIO(nr_pages != HPAGE_PMD_NR, folio);
 		break;
-	case RMAP_LEVEL_PUD:
+	case PGTABLE_LEVEL_PUD:
 		/*
 		 * Assume that we are creating a single "entire" mapping of the
 		 * folio.
@@ -447,7 +437,7 @@ static inline void __folio_rmap_sanity_checks(const struct folio *folio,
 		VM_WARN_ON_FOLIO(nr_pages != HPAGE_PUD_NR, folio);
 		break;
 	default:
-		VM_WARN_ON_ONCE(true);
+		BUILD_BUG();
 	}
 
 	/*
@@ -567,14 +557,14 @@ static inline void hugetlb_remove_rmap(struct folio *folio)
 
 static __always_inline void __folio_dup_file_rmap(struct folio *folio,
 		struct page *page, int nr_pages, struct vm_area_struct *dst_vma,
-		enum rmap_level level)
+		enum pgtable_level level)
 {
 	const int orig_nr_pages = nr_pages;
 
 	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
 
 	switch (level) {
-	case RMAP_LEVEL_PTE:
+	case PGTABLE_LEVEL_PTE:
 		if (!folio_test_large(folio)) {
 			atomic_inc(&folio->_mapcount);
 			break;
@@ -587,11 +577,13 @@ static __always_inline void __folio_dup_file_rmap(struct folio *folio,
 		}
 		folio_add_large_mapcount(folio, orig_nr_pages, dst_vma);
 		break;
-	case RMAP_LEVEL_PMD:
-	case RMAP_LEVEL_PUD:
+	case PGTABLE_LEVEL_PMD:
+	case PGTABLE_LEVEL_PUD:
 		atomic_inc(&folio->_entire_mapcount);
 		folio_inc_large_mapcount(folio, dst_vma);
 		break;
+	default:
+		BUILD_BUG();
 	}
 }
 
@@ -609,13 +601,13 @@ static __always_inline void __folio_dup_file_rmap(struct folio *folio,
 static inline void folio_dup_file_rmap_ptes(struct folio *folio,
 		struct page *page, int nr_pages, struct vm_area_struct *dst_vma)
 {
-	__folio_dup_file_rmap(folio, page, nr_pages, dst_vma, RMAP_LEVEL_PTE);
+	__folio_dup_file_rmap(folio, page, nr_pages, dst_vma, PGTABLE_LEVEL_PTE);
 }
 
 static __always_inline void folio_dup_file_rmap_pte(struct folio *folio,
 		struct page *page, struct vm_area_struct *dst_vma)
 {
-	__folio_dup_file_rmap(folio, page, 1, dst_vma, RMAP_LEVEL_PTE);
+	__folio_dup_file_rmap(folio, page, 1, dst_vma, PGTABLE_LEVEL_PTE);
 }
 
 /**
@@ -632,7 +624,7 @@ static inline void folio_dup_file_rmap_pmd(struct folio *folio,
 		struct page *page, struct vm_area_struct *dst_vma)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	__folio_dup_file_rmap(folio, page, HPAGE_PMD_NR, dst_vma, RMAP_LEVEL_PTE);
+	__folio_dup_file_rmap(folio, page, HPAGE_PMD_NR, dst_vma, PGTABLE_LEVEL_PTE);
 #else
 	WARN_ON_ONCE(true);
 #endif
@@ -640,7 +632,7 @@ static inline void folio_dup_file_rmap_pmd(struct folio *folio,
 
 static __always_inline int __folio_try_dup_anon_rmap(struct folio *folio,
 		struct page *page, int nr_pages, struct vm_area_struct *dst_vma,
-		struct vm_area_struct *src_vma, enum rmap_level level)
+		struct vm_area_struct *src_vma, enum pgtable_level level)
 {
 	const int orig_nr_pages = nr_pages;
 	bool maybe_pinned;
@@ -665,7 +657,7 @@ static __always_inline int __folio_try_dup_anon_rmap(struct folio *folio,
 	 * copying if the folio maybe pinned.
 	 */
 	switch (level) {
-	case RMAP_LEVEL_PTE:
+	case PGTABLE_LEVEL_PTE:
 		if (unlikely(maybe_pinned)) {
 			for (i = 0; i < nr_pages; i++)
 				if (PageAnonExclusive(page + i))
@@ -687,8 +679,8 @@ static __always_inline int __folio_try_dup_anon_rmap(struct folio *folio,
 		} while (page++, --nr_pages > 0);
 		folio_add_large_mapcount(folio, orig_nr_pages, dst_vma);
 		break;
-	case RMAP_LEVEL_PMD:
-	case RMAP_LEVEL_PUD:
+	case PGTABLE_LEVEL_PMD:
+	case PGTABLE_LEVEL_PUD:
 		if (PageAnonExclusive(page)) {
 			if (unlikely(maybe_pinned))
 				return -EBUSY;
@@ -697,6 +689,8 @@ static __always_inline int __folio_try_dup_anon_rmap(struct folio *folio,
 		atomic_inc(&folio->_entire_mapcount);
 		folio_inc_large_mapcount(folio, dst_vma);
 		break;
+	default:
+		BUILD_BUG();
 	}
 	return 0;
 }
@@ -730,7 +724,7 @@ static inline int folio_try_dup_anon_rmap_ptes(struct folio *folio,
 		struct vm_area_struct *src_vma)
 {
 	return __folio_try_dup_anon_rmap(folio, page, nr_pages, dst_vma,
-					 src_vma, RMAP_LEVEL_PTE);
+					 src_vma, PGTABLE_LEVEL_PTE);
 }
 
 static __always_inline int folio_try_dup_anon_rmap_pte(struct folio *folio,
@@ -738,7 +732,7 @@ static __always_inline int folio_try_dup_anon_rmap_pte(struct folio *folio,
 		struct vm_area_struct *src_vma)
 {
 	return __folio_try_dup_anon_rmap(folio, page, 1, dst_vma, src_vma,
-					 RMAP_LEVEL_PTE);
+					 PGTABLE_LEVEL_PTE);
 }
 
 /**
@@ -770,7 +764,7 @@ static inline int folio_try_dup_anon_rmap_pmd(struct folio *folio,
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	return __folio_try_dup_anon_rmap(folio, page, HPAGE_PMD_NR, dst_vma,
-					 src_vma, RMAP_LEVEL_PMD);
+					 src_vma, PGTABLE_LEVEL_PMD);
 #else
 	WARN_ON_ONCE(true);
 	return -EBUSY;
@@ -778,7 +772,7 @@ static inline int folio_try_dup_anon_rmap_pmd(struct folio *folio,
 }
 
 static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
-		struct page *page, int nr_pages, enum rmap_level level)
+		struct page *page, int nr_pages, enum pgtable_level level)
 {
 	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
 	VM_WARN_ON_FOLIO(!PageAnonExclusive(page), folio);
@@ -873,7 +867,7 @@ static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
 static inline int folio_try_share_anon_rmap_pte(struct folio *folio,
 		struct page *page)
 {
-	return __folio_try_share_anon_rmap(folio, page, 1, RMAP_LEVEL_PTE);
+	return __folio_try_share_anon_rmap(folio, page, 1, PGTABLE_LEVEL_PTE);
 }
 
 /**
@@ -904,7 +898,7 @@ static inline int folio_try_share_anon_rmap_pmd(struct folio *folio,
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	return __folio_try_share_anon_rmap(folio, page, HPAGE_PMD_NR,
-					   RMAP_LEVEL_PMD);
+					   PGTABLE_LEVEL_PMD);
 #else
 	WARN_ON_ONCE(true);
 	return -EBUSY;
diff --git a/mm/rmap.c b/mm/rmap.c
index 84a8d8b02ef77..0e9c4041f8687 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1265,7 +1265,7 @@ static void __folio_mod_stat(struct folio *folio, int nr, int nr_pmdmapped)
 
 static __always_inline void __folio_add_rmap(struct folio *folio,
 		struct page *page, int nr_pages, struct vm_area_struct *vma,
-		enum rmap_level level)
+		enum pgtable_level level)
 {
 	atomic_t *mapped = &folio->_nr_pages_mapped;
 	const int orig_nr_pages = nr_pages;
@@ -1274,7 +1274,7 @@ static __always_inline void __folio_add_rmap(struct folio *folio,
 	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
 
 	switch (level) {
-	case RMAP_LEVEL_PTE:
+	case PGTABLE_LEVEL_PTE:
 		if (!folio_test_large(folio)) {
 			nr = atomic_inc_and_test(&folio->_mapcount);
 			break;
@@ -1300,11 +1300,11 @@ static __always_inline void __folio_add_rmap(struct folio *folio,
 
 		folio_add_large_mapcount(folio, orig_nr_pages, vma);
 		break;
-	case RMAP_LEVEL_PMD:
-	case RMAP_LEVEL_PUD:
+	case PGTABLE_LEVEL_PMD:
+	case PGTABLE_LEVEL_PUD:
 		first = atomic_inc_and_test(&folio->_entire_mapcount);
 		if (IS_ENABLED(CONFIG_NO_PAGE_MAPCOUNT)) {
-			if (level == RMAP_LEVEL_PMD && first)
+			if (level == PGTABLE_LEVEL_PMD && first)
 				nr_pmdmapped = folio_large_nr_pages(folio);
 			nr = folio_inc_return_large_mapcount(folio, vma);
 			if (nr == 1)
@@ -1323,7 +1323,7 @@ static __always_inline void __folio_add_rmap(struct folio *folio,
 				 * We only track PMD mappings of PMD-sized
 				 * folios separately.
 				 */
-				if (level == RMAP_LEVEL_PMD)
+				if (level == PGTABLE_LEVEL_PMD)
 					nr_pmdmapped = nr_pages;
 				nr = nr_pages - (nr & FOLIO_PAGES_MAPPED);
 				/* Raced ahead of a remove and another add? */
@@ -1336,6 +1336,8 @@ static __always_inline void __folio_add_rmap(struct folio *folio,
 		}
 		folio_inc_large_mapcount(folio, vma);
 		break;
+	default:
+		BUILD_BUG();
 	}
 	__folio_mod_stat(folio, nr, nr_pmdmapped);
 }
@@ -1427,7 +1429,7 @@ static void __page_check_anon_rmap(const struct folio *folio,
 
 static __always_inline void __folio_add_anon_rmap(struct folio *folio,
 		struct page *page, int nr_pages, struct vm_area_struct *vma,
-		unsigned long address, rmap_t flags, enum rmap_level level)
+		unsigned long address, rmap_t flags, enum pgtable_level level)
 {
 	int i;
 
@@ -1440,20 +1442,22 @@ static __always_inline void __folio_add_anon_rmap(struct folio *folio,
 
 	if (flags & RMAP_EXCLUSIVE) {
 		switch (level) {
-		case RMAP_LEVEL_PTE:
+		case PGTABLE_LEVEL_PTE:
 			for (i = 0; i < nr_pages; i++)
 				SetPageAnonExclusive(page + i);
 			break;
-		case RMAP_LEVEL_PMD:
+		case PGTABLE_LEVEL_PMD:
 			SetPageAnonExclusive(page);
 			break;
-		case RMAP_LEVEL_PUD:
+		case PGTABLE_LEVEL_PUD:
 			/*
 			 * Keep the compiler happy, we don't support anonymous
 			 * PUD mappings.
 			 */
 			WARN_ON_ONCE(1);
 			break;
+		default:
+			BUILD_BUG();
 		}
 	}
 
@@ -1507,7 +1511,7 @@ void folio_add_anon_rmap_ptes(struct folio *folio, struct page *page,
 		rmap_t flags)
 {
 	__folio_add_anon_rmap(folio, page, nr_pages, vma, address, flags,
-			      RMAP_LEVEL_PTE);
+			      PGTABLE_LEVEL_PTE);
 }
 
 /**
@@ -1528,7 +1532,7 @@ void folio_add_anon_rmap_pmd(struct folio *folio, struct page *page,
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	__folio_add_anon_rmap(folio, page, HPAGE_PMD_NR, vma, address, flags,
-			      RMAP_LEVEL_PMD);
+			      PGTABLE_LEVEL_PMD);
 #else
 	WARN_ON_ONCE(true);
 #endif
@@ -1609,7 +1613,7 @@ void folio_add_new_anon_rmap(struct folio *folio, struct vm_area_struct *vma,
 
 static __always_inline void __folio_add_file_rmap(struct folio *folio,
 		struct page *page, int nr_pages, struct vm_area_struct *vma,
-		enum rmap_level level)
+		enum pgtable_level level)
 {
 	VM_WARN_ON_FOLIO(folio_test_anon(folio), folio);
 
@@ -1634,7 +1638,7 @@ static __always_inline void __folio_add_file_rmap(struct folio *folio,
 void folio_add_file_rmap_ptes(struct folio *folio, struct page *page,
 		int nr_pages, struct vm_area_struct *vma)
 {
-	__folio_add_file_rmap(folio, page, nr_pages, vma, RMAP_LEVEL_PTE);
+	__folio_add_file_rmap(folio, page, nr_pages, vma, PGTABLE_LEVEL_PTE);
 }
 
 /**
@@ -1651,7 +1655,7 @@ void folio_add_file_rmap_pmd(struct folio *folio, struct page *page,
 		struct vm_area_struct *vma)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	__folio_add_file_rmap(folio, page, HPAGE_PMD_NR, vma, RMAP_LEVEL_PMD);
+	__folio_add_file_rmap(folio, page, HPAGE_PMD_NR, vma, PGTABLE_LEVEL_PMD);
 #else
 	WARN_ON_ONCE(true);
 #endif
@@ -1672,7 +1676,7 @@ void folio_add_file_rmap_pud(struct folio *folio, struct page *page,
 {
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
 	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
-	__folio_add_file_rmap(folio, page, HPAGE_PUD_NR, vma, RMAP_LEVEL_PUD);
+	__folio_add_file_rmap(folio, page, HPAGE_PUD_NR, vma, PGTABLE_LEVEL_PUD);
 #else
 	WARN_ON_ONCE(true);
 #endif
@@ -1680,7 +1684,7 @@ void folio_add_file_rmap_pud(struct folio *folio, struct page *page,
 
 static __always_inline void __folio_remove_rmap(struct folio *folio,
 		struct page *page, int nr_pages, struct vm_area_struct *vma,
-		enum rmap_level level)
+		enum pgtable_level level)
 {
 	atomic_t *mapped = &folio->_nr_pages_mapped;
 	int last = 0, nr = 0, nr_pmdmapped = 0;
@@ -1689,7 +1693,7 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
 	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
 
 	switch (level) {
-	case RMAP_LEVEL_PTE:
+	case PGTABLE_LEVEL_PTE:
 		if (!folio_test_large(folio)) {
 			nr = atomic_add_negative(-1, &folio->_mapcount);
 			break;
@@ -1719,11 +1723,11 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
 
 		partially_mapped = nr && atomic_read(mapped);
 		break;
-	case RMAP_LEVEL_PMD:
-	case RMAP_LEVEL_PUD:
+	case PGTABLE_LEVEL_PMD:
+	case PGTABLE_LEVEL_PUD:
 		if (IS_ENABLED(CONFIG_NO_PAGE_MAPCOUNT)) {
 			last = atomic_add_negative(-1, &folio->_entire_mapcount);
-			if (level == RMAP_LEVEL_PMD && last)
+			if (level == PGTABLE_LEVEL_PMD && last)
 				nr_pmdmapped = folio_large_nr_pages(folio);
 			nr = folio_dec_return_large_mapcount(folio, vma);
 			if (!nr) {
@@ -1743,7 +1747,7 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
 			nr = atomic_sub_return_relaxed(ENTIRELY_MAPPED, mapped);
 			if (likely(nr < ENTIRELY_MAPPED)) {
 				nr_pages = folio_large_nr_pages(folio);
-				if (level == RMAP_LEVEL_PMD)
+				if (level == PGTABLE_LEVEL_PMD)
 					nr_pmdmapped = nr_pages;
 				nr = nr_pages - (nr & FOLIO_PAGES_MAPPED);
 				/* Raced ahead of another remove and an add? */
@@ -1757,6 +1761,8 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
 
 		partially_mapped = nr && nr < nr_pmdmapped;
 		break;
+	default:
+		BUILD_BUG();
 	}
 
 	/*
@@ -1796,7 +1802,7 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
 void folio_remove_rmap_ptes(struct folio *folio, struct page *page,
 		int nr_pages, struct vm_area_struct *vma)
 {
-	__folio_remove_rmap(folio, page, nr_pages, vma, RMAP_LEVEL_PTE);
+	__folio_remove_rmap(folio, page, nr_pages, vma, PGTABLE_LEVEL_PTE);
 }
 
 /**
@@ -1813,7 +1819,7 @@ void folio_remove_rmap_pmd(struct folio *folio, struct page *page,
 		struct vm_area_struct *vma)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	__folio_remove_rmap(folio, page, HPAGE_PMD_NR, vma, RMAP_LEVEL_PMD);
+	__folio_remove_rmap(folio, page, HPAGE_PMD_NR, vma, PGTABLE_LEVEL_PMD);
 #else
 	WARN_ON_ONCE(true);
 #endif
@@ -1834,7 +1840,7 @@ void folio_remove_rmap_pud(struct folio *folio, struct page *page,
 {
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
 	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
-	__folio_remove_rmap(folio, page, HPAGE_PUD_NR, vma, RMAP_LEVEL_PUD);
+	__folio_remove_rmap(folio, page, HPAGE_PUD_NR, vma, PGTABLE_LEVEL_PUD);
 #else
 	WARN_ON_ONCE(true);
 #endif
-- 
2.50.1


