Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E9E0C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:32:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A4536B00A6; Mon, 20 Jul 2026 05:32:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8552F6B00AD; Mon, 20 Jul 2026 05:32:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 791B36B00AE; Mon, 20 Jul 2026 05:32:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 481336B00A6
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:32:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DB5241A07AE
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:32:34 +0000 (UTC)
X-FDA: 85008639828.16.548B16A
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2565B180004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:32:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=TthQVAPv;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf16.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784539953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Xc+9wTjB/ZbPSuhtSmXNsjcgy94ONeB8wn4Fc53kDI=;
	b=IeLaOQE/fD4TQ5L7lkR1/eKbnG3YQTJhWp0ME1HoJUw4yu2oN1PIeZzMtB+b7WIYBxD+2C
	olqQny9nxbrWATOv3IkVwmW63idZ61RDF1g2snZJYq7iE2DkXnxP8iHdL3JMizokV99X+L
	p46uj7ZDEdGZhtdGMA8+vb61CJ2kX4g=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=TthQVAPv;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf16.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784539953;
	b=Ds7iiLCG1Oa2wZdANrvGlkm1LNxQBxksJrmSyeL1T3ZUkaqLkq5dmAWnB5O8aaMg0TvnRB
	GOF1TPKF6TAWPon7JtiVCtd9QHfc8/0Yyg+qCWktoRIPXeqkR9pRv7EhLr7SCtMV5c486q
	1mK2QoaGHE0h2MYdVsH4NUvbRD0GR3Y=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2cce6a0c9c3so88839955ad.1
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784539952; x=1785144752; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5Xc+9wTjB/ZbPSuhtSmXNsjcgy94ONeB8wn4Fc53kDI=;
        b=TthQVAPvXscDha7LT9AcXDT7NMUygHIaoA2oUH/WFaNM3sxyoQ5dpkxXnIuwFyLaBx
         U/PogGw1OrsLH5/vqNe8oQiNDVw2RobW8Ga8fYuDx9Yi6RGncUqaxIROemFHCg5xeryM
         eVC1Dg10R2BNmgiMKV14czoULYt2xtgS17LG74hsacBpWScdRPslxW7yATrXAt/F/qPi
         XDoI/FbFuu6Sifb1HGt3oSWx1bFs8ygYStxkuAV3w8opa4/q5SHDnPfdx23ptS2Yn3NE
         HFCK05UEnlqvVkRCS+I0dbWImdk/cRlx24oq057kf5OliGSglmP+CuPaKEs2NRkAqflb
         9rjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784539952; x=1785144752;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5Xc+9wTjB/ZbPSuhtSmXNsjcgy94ONeB8wn4Fc53kDI=;
        b=Dgv13xO4oeeQ692gRxXdPLoryHOawXZyzWSg8gvYg3e+RIdXQgif7KqNhI4XEzE9Ts
         AFMkhVNGzcDIvIjyAHo8a3OXsD8eLENRieUC57flqxQnt/+uvNg4BNybU1hxoAuK+xJd
         PVdIG9FW4ft0e1zZ2gltWpeoyVZqFi5PTSZ87KGEA/yiQeXfJxInKaaiMOoZppx7BQgJ
         eP+qg3ZA76PCNun4QE4K6MrdHP+P79et9owvI0Ltn8suHdJFbrSR77Hbxk8bxLdLroro
         Vn2gg6ye7PgEUwV7GywpN7JJ9OqO5Oy1oJg/QNsFwL8ODupbxKKyfHPl4f480EKK6b4c
         2Y3A==
X-Forwarded-Encrypted: i=1; AHgh+RoOlVPjrXOK8j3h/2niSFR3vq2zJjZJSA3at46OF9VxBZVqC2Aamh47NTF81BlxwY5tPvR+EDoBNQ==@kvack.org
X-Gm-Message-State: AOJu0YzIqEuIDs034STrHovKqgnPFKjGkGDUKSL4zYOXBe1HX93oHFpS
	bRLa844hXERpYWixTA9jINU/I4jBITycwW3DDM1B5cAEuk/xbZnpQ+Mp/qd2/IU9btA=
X-Gm-Gg: AR+sD10z16IlvDO276ReMyEbzXRPDaw4wYmfweVlIMaKOKewSnzJHTXWXLrcVeiy8pu
	3cAAuwLmMNY2g5yhh05jnpjm4J/mez9Tktg8Xvz43vzTy4SrWfr/CLCiOM5bOqLlBEbcUqG4kwu
	BwVPw2YM3GVd2Q1EaZFB22H7KqfWzgukQblew7/JDOWicGB5ZzQgHg+PSJOTT/6m/lGuM/UkgBR
	9R2JtvWwGbYHrwaccqlJuaaNE1hYcOBdKUSpK33auQ3qYJz/+MtkoElyPijjxE+gMK5S4mUMlfu
	BBDi832ZqA+H21O/HXpq/bcPuijMKYov7XBvXtw2x2IrU+4EUsMBI0mY1AN6hgnB89+LWzi0A1K
	p/BthM45+6eiHIG8OYtUlyY2E01nW+H9Ru1rLPW/y4LHEXmRNvMNEplV2rxmeGVoK19aFDYdNOE
	LEXbWpF4WcdFGSAxhfugNJ8rVNJdsEu9jfsw==
X-Received: by 2002:a17:903:2449:b0:2cf:477f:57c5 with SMTP id d9443c01a7336-2cf477f5bacmr91609105ad.1.1784539951960;
        Mon, 20 Jul 2026 02:32:31 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.101])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf347a7c9fsm53136455ad.84.2026.07.20.02.32.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 02:32:31 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v2 09/17] mm/sparse: initialize memory sections earlier
Date: Mon, 20 Jul 2026 17:31:19 +0800
Message-ID: <20260720093127.540540-10-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260720093127.540540-1-songmuchun@bytedance.com>
References: <20260720093127.540540-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4inmz3phspmqetapwqmnnkjk7wfho7xn
X-Rspamd-Queue-Id: 2565B180004
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784539953-961997
X-HE-Meta: U2FsdGVkX1+AFkBu6MnAnCqDO5EgAS5WgDr1uKVZKJs1whx1bhWPXCntP6EZ7X1j/mhMX9oj2CeEHioEDOTDo5XocScVCsUOEJFpptmn9zoqV2WS7nC894YjSmUIYr/7omprwm8Y4govRA3zUm2pUDhED0RXDaPIpN1SdaVgO/6f65w/tTPUhd0ssI2oJjMJHMb/Nnr4rEYBu8AVuc3XOQj1t8zaebj2SKe6YceZlEIgAJnY5caYTGvdKJ/oKNn5kH/zQrqZDUiQan9M/emKaIFj4AwPsCJPpwvSwZCRBvUMsdDziWoJisrQY9WrO0WfDwACpzwbfHXZ/OaDNiJcfSNvPEdd7Ih+L8dPmyQ51vhWYIfeuTf0vxn/7D9k5AtJMZ2NeElcaQ+kLwhlOeoSIkbC28czeArv1Vg0y6plH3hwoUd8dX2xcMxo+Tcz+FsBwHbHPZKKl68Ohc4120NkPmGX96Q5MflFT64CUweb5D+NNB1kv2TXfM+pnpYgmr2M71pROhKvfach5aNtVbBwqmtvnfPpd7u5idHURy5eyiyc/Wv0YlgIJxO8aOrmD9t0M988IJCovtRcAbLuyxxhEXQ/YkREhSPGP7Yd7gLr0gHbo7xolGW1qBOCgEI848HGLApozKztG7byRkNc32y7MmrzmJ21UyYoRaH2B8NvK9eEgEEtyOH+KdGMR5vQn07qEGaZRKbk7i4UGZ05K1h/olkjfAqyMTiBpJVzdp99o6+AD9XNsn/K/oae/syRbEcdLm8ahwp9rczx1TkiPz26v9ieZK2NJZ5DnWZnvRdA8B+O4kCaan3y/Y6vkfaeRPuMsi3iZK1h8cR2pqm9K6FFrxAWQBZSrE2lUvuCnrSS4OJEbp8gJeXJafhiB7HqthdVUwwTqrhgXwi/hL4gHeyQkk946LOEjcUX6UF5Jiqu2+PgZXnzWJEiyskRJtlojrCDY7KFReTtcDyFmtCwZXY
 aSZcvtRb
 2qKestN08K4S0xckgNOTNeQTRj7zkJcBl9J+S6K3XKT8Qc06+/m8KX5dlglnvjMe59vhKemj0RTrBFMmdvJhbaet/5mkA89BLV5OEVXxNimzj8l0h3VBNURQC2EST9V/v3BvAiTbXgUCBHEl1aMAXRPFlx5Nl94HQxCNsomAIwrC5P/+yBZTavCSj9l/zwqm9fpPrE6LncnZFvFklI0SpxuF3iJ7gJtMPT499lGsNipGaBSMWOjssMlbsYRubqMA8lbpORi+qdfDhmg2KXOuvKWJ2jsMaLoCosiXncLZJKcan9g2hFSS+g5rMnI2xjKly80T8G7cXJEwROFeg3TffxR+f8IXPQYAv6kogbekVXW1mBbmicnRlDOLoLbB/8eEBpYMcQwNbJrBkLzw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Upcoming HugeTLB bootmem changes need sparsemem section metadata before
the HugeTLB bootmem allocation path runs. The memory sections are
initialized from sparse_init(), which is called too late for that setup.

Move the code that initializes sparsemem section metadata for memblock
ranges into mm_core_init_early(), before free_area_init() and the HugeTLB
bootmem setup. Rename the helper to sparse_sections_init() so the new
caller describes the sparsemem-specific initialization step.

This is a preparatory change.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v2:
- Rename the helper to sparse_sections_init() to describe the section
  metadata initialization (suggested by Mike Rapoport)
- Fix the !SPARSEMEM stub name so SPARSEMEM=n builds compile
  (reported by Sashiko)
---
 mm/mm_init.c |  1 +
 mm/sparse.c  | 10 ++--------
 mm/sparse.h  |  2 ++
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 191d4ebe9314..b3ebecf077a0 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2636,6 +2636,7 @@ void __init __weak mem_init(void)
 
 void __init mm_core_init_early(void)
 {
+	sparse_sections_init();
 	free_area_init();
 
 	hugetlb_cma_reserve();
diff --git a/mm/sparse.c b/mm/sparse.c
index 24555a32a5d9..d4641aa70497 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -191,12 +191,8 @@ static void __init memory_present(int nid, unsigned long start, unsigned long en
 	}
 }
 
-/*
- * Mark all memblocks as present using memory_present().
- * This is a convenience function that is useful to mark all of the systems
- * memory as present during initialization.
- */
-static void __init memblocks_present(void)
+/* Initialize memory section metadata for all system memory. */
+void __init sparse_sections_init(void)
 {
 	unsigned long start, end;
 	int i, nid;
@@ -332,8 +328,6 @@ void __init sparse_init(void)
 	unsigned long pnum_end, pnum_begin, map_count = 1;
 	int nid_begin;
 
-	memblocks_present();
-
 	if (compound_info_has_mask()) {
 		VM_WARN_ON_ONCE(!IS_ALIGNED((unsigned long) pfn_to_page(0),
 				    MAX_FOLIO_VMEMMAP_ALIGN));
diff --git a/mm/sparse.h b/mm/sparse.h
index 4377b097dc8d..b2dc7362af4f 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -14,6 +14,7 @@
  * mm/sparse.c
  */
 #ifdef CONFIG_SPARSEMEM
+void sparse_sections_init(void);
 void sparse_init(void);
 int sparse_index_init(unsigned long section_nr, int nid);
 
@@ -48,6 +49,7 @@ static inline void __section_mark_present(struct mem_section *ms,
 	ms->section_mem_map |= SECTION_MARKED_PRESENT;
 }
 #else
+static inline void sparse_sections_init(void) {}
 static inline void sparse_init(void) {}
 #endif /* CONFIG_SPARSEMEM */
 
-- 
2.54.0


