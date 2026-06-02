Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D578CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 10:12:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 893186B00E1; Tue,  2 Jun 2026 06:12:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 843E66B00E2; Tue,  2 Jun 2026 06:12:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 732126B00E4; Tue,  2 Jun 2026 06:12:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5F9326B00E1
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:12:41 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2AB26C2B21
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:12:41 +0000 (UTC)
X-FDA: 84834558522.29.4337C79
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3655D4000D
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:12:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=BN3e7P+0;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf12.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780395159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J5Q2gGk4UZAL2GpP2RnQJwNvQrGN9WYj/IZDEx+Kuy0=;
	b=j8fmetnOprfpsFm/9JEF3XIEmk7XYxQx4MQ4OBGA1EiPB0erYISQW2QYkuV4Xi+uIjyadD
	vzjVMK7cc6Vhb4TgL7NPuJR4zkvg6mTYSJA092MWIuviFVld74C7lZq9ZGKFrjr2DpyhE3
	yxFmnNTLgD9a5Hn8cA2urxy88Rr3xJE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=BN3e7P+0;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf12.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780395159;
	b=CJfeLQhcDLAwyyn3DXumE/8K44mzpBMZYHVCsVOC+mj+hpgUbntvgypENTih3ZA5gsUZss
	cvRC8Fdb8zRalaeubL89+tKeIPmNBueeilxzme3JuCp9N8vAYUGuOCYnvqlSLy5+J+AI1r
	dHk/HlDscx5kXrbt1+Wsifrtx+K9Wb4=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-842307472d4so668629b3a.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 03:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1780395158; x=1780999958; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J5Q2gGk4UZAL2GpP2RnQJwNvQrGN9WYj/IZDEx+Kuy0=;
        b=BN3e7P+0Xk2tfUKGYO2qyYn2ZsiEfIpCBkxWRf4uiiPq6fb8Y/M5bT/gkzgn6hLaul
         RD6xibF+TcepETnXwObXmZSzpiFunq7kzHbD+pWjmVLsht6aHvChyPuhyBIoYNjw7gKz
         8f6dBLA0WzKRrXWS5rP5cKNoVFKasGx7inJc2X6zNxC5PSN97vSlFgSCEp9zY7kJaXBq
         owCy73+0IQn90Ru6EEQYPTGINtpwgJpNQDLYHehtIeWPXXKzGBv1KJ9tGMasZo6L9Wr7
         SHXntqAQMKTIIbyC0rHBP/ibQG1uC3yQ+sipYSjt0vZzpN0kBqMDrv92I1XB0OLH2ijx
         8jzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780395158; x=1780999958;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=J5Q2gGk4UZAL2GpP2RnQJwNvQrGN9WYj/IZDEx+Kuy0=;
        b=kZ66S/LeIUCv/kPrbt5BowbMezUPtVXtu9U5anNlO6xKb9x1ir8wzGm0hwnc6UPRw1
         XV7U4uoZDNRS+IsAn22gPLr9Yi+xcNXmn4Cn3OlnpZkwRL08xg3IB4CMxc59l/TZ4Ltc
         KV5bqVHsleE8HpDKwOPriynIfZWFqshOuEOQ2aew7NucmcFDBicgM10ZLhi8nQzo7Rf3
         wScEU2Q60BBd8uRdDn9IzfwURc3HwYNvU2Rbt99UD/FYRJMXf+63und1i1nreP0NMrLD
         FIf4uTtXr0Odjyt9pOm/vfuT6qs5oXUWN35t6oNZvNJ0Hfp+SAH2QhLCtMBSGrCKN5SJ
         YVLg==
X-Forwarded-Encrypted: i=1; AFNElJ+/Hs2lqWl/zpRHDBmSQ9Vb7mo+LdfJdMun8hHViG6OUS+xRkltDZmay/S4rFJs0rsUEfNDN8PuOQ==@kvack.org
X-Gm-Message-State: AOJu0YwR9qdUeCrCMdCRQbmIAYKvDvYPFGmY6x6ohbwH7GuB1FLmx/DQ
	eO2reA6cUX5L+Qs++l9BgQXPdquQvRacixuFXq2fuxk8M7LRTynbdQw1oc/ptnlHaDE=
X-Gm-Gg: Acq92OHePk5k3cua0qJHEGY3jhfTYf4f7SZqytWKinIEA+3cvUy967WfwliWSNHebOC
	O7siSl1LMQG9Bd+WiZ0YvmuJFdSqc8u4od4wJ4me+M+vAhPevK5MimHe9s48kB6ZF3gXV25fOA6
	erB6xBMQIPuZgp4/ihZeFDFrxJXCId2OFh9TiuNChmhsvj5Qu02vR+1641v0DGcgItI5LJhP8Jz
	TgjoN6iUW7ixQDfF4WI+K9hbq2LwNSh9ZtIZaQyRrwVHG0ZoFWW8r/ZUQOcnOr8OZmKhAHyj4W5
	3P9JDlDEMZM7cDvK6xa9pcS6wVrf2DfJxBDYlTzamZonKwqlztdbVlVVjEYfhOJYaQ1TP8zbJ0/
	w6lJ+TdHZG00C9pAL0EjtEYgd+2mXPzQg7D6HiRRswjKvuEqrG35Q01buUaJSAJvba0bNCSJ/je
	n7vRLP9/NV5EcBfyHWkgBjktKNRR+D9yjLQZ+qOu7Rm3QVwRZMApHQEOU=
X-Received: by 2002:a05:6a00:8d96:b0:835:366f:5da2 with SMTP id d2e1a72fcca58-842254980a1mr14651687b3a.37.1780395158008;
        Tue, 02 Jun 2026 03:12:38 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84214d018fcsm12015507b3a.60.2026.06.02.03.12.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 03:12:37 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 19/19] mm/mm_init: Fold __init_page_from_nid() into __init_deferred_page()
Date: Tue,  2 Jun 2026 18:10:39 +0800
Message-ID: <20260602101039.1867613-20-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260602101039.1867613-1-songmuchun@bytedance.com>
References: <20260602101039.1867613-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3655D4000D
X-Stat-Signature: qw9mdzxdbt3xe5stbi1tuz3q58ftoca7
X-HE-Tag: 1780395159-331067
X-HE-Meta: U2FsdGVkX1+6Cne4IPVsA+0+ZXDaWxCP3F5a0qrVcdK5Kj0zPU4gLbetnpb4+XdWdcxZ9KB9kn+0j2nbWIjkXiEgVHgFa8xC8APVQb7+eObHG0apEHO1oMfDRgn22XU5v2aIM0th5E+osUALUWnYeMN+/oD1ZE9ufcZiIAhPsZWHZtjtjTYdD5flDOCSI6tsDe/bxshJtqym/wA5Qx79dwfAEpBdiZwYdHaEBSC9kUOLqgEG63L0YRcBcij4EgJbgT3wAr3EDh1da0ZEQd5ODePDaQbNiG8s737lJ8G3W0nXFOttdvaNqYHExTuzHNbeol7u5BVsKrdm9pGXzEqbM/HnE7mg0u8p0rqa66hZ3EdR32zhPhib8sBoSJnPvJtMAtPPXMjDw3PyBUL/Y/J87dwXWlqIhOMR772/rnCHwZooSwUdtqCu+qKM9M47dAfqNgGb8NDFLE237QvuY8Javz9UndAWgrMy0gCy2Ac1h8Hlvdfzlki/rugKgRMB0uQmQpk4z9mNPx8E59e1CdYZR3OyISKbD5sZWnt/63/ZIXw0Rp0rsXB9Pa9o07cecOJFo1Kt1RyaCdeIPhzyhP5IwXMYhcPvcPPi6eGyXG3KI6b/Zt5l6ibeU32ScpcwwxwJHeVWAwLhGBXhIqCWhV+yGfD1CE9JIV+yncrOTNzdQHDL6fK1VPf+FwIicHSpRiokgAjz/k58f8owKpnYX+9brwXlc+n7FPMuWYJEiW/nRciZf/rHRk0dg0UhECfLpMubTWE+oiv2HBpbvjQ/0c3gxHoypuaQVOdMLnomVZKJRFR+hEdvBMlp1x1USEkqmAztHMKStnA9S5eWEXnVfdhoc2rHUgtJLGWnHTywso2WMHn9tDzjeQ5AlwX0cGrIe9w5IYJSH0cLj2gDYRnHWPXfL+kMhOE59Ky2NEYe5LUFIgQ9dIstFRMtee6vhXh43l/R2bHHUSOfM5Gmx3W42xD
 kh3pvygo
 H1E7QhxTKXJq0l+s/iUUYXp5bd3rIqGlRjM8XHpQMrcj9Ugo07H9sEV4z1l4oAZFw9KKaAbvCQBk3sG9PWWucW/9hroU4rhFYOKfr2l7efIIadaFCh7K9kee+KNfoy87pYnUcE04sf5ZSXkDhFzVeg/jU2eYFLhqD2cRXTs/feaJhfSVzOV07ey0fiDxJaOUgJvQp6+goF0OHqNmFg55QH9YWpiEWCAzwcyuXSWnBV6u4M3JyuadQWVtP4cPc4qR3/ZeMMpQFx3U32wQKzpqGh4019r9LFT6RWaMDgKqJAbsCXPu4jJWBOOEjSmZ0Hqma1KuVl3iQSFFzCRVEBM/RZwVcwjWsUBBSfjq4bz7lAhBiqFzSYCTPLtsgSU3mojAACM18Ea/Z86G9kyD3xxjbrNmudOuFKjMGUOD9dIwo+AHRW+iqQTAV21MRjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__init_page_from_nid() no longer has external users and is only used
locally in mm/mm_init.c under CONFIG_DEFERRED_STRUCT_PAGE_INIT.

Fold it into its sole caller __init_deferred_page() and remove the
separate helper declaration.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v2->v3:
- fold __init_page_from_nid() into __init_deferred_page() since it
  only has a single caller (suggested by Mike Rapoport)
---
 mm/internal.h |  1 -
 mm/mm_init.c  | 44 ++++++++++++++++++--------------------------
 2 files changed, 18 insertions(+), 27 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 8497673d0ac3..b33fc87e4555 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1760,7 +1760,6 @@ static inline bool pte_needs_soft_dirty_wp(struct vm_area_struct *vma, pte_t pte
 
 void __meminit __init_single_page(struct page *page, unsigned long pfn,
 				unsigned long zone, int nid);
-void __meminit __init_page_from_nid(unsigned long pfn, int nid);
 
 /* shrinker related functions */
 unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 41b83dd18c01..f1bbf3b9a321 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -688,31 +688,6 @@ static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
 }
 #endif
 
-/*
- * Initialize a reserved page unconditionally, finding its zone first.
- */
-void __meminit __init_page_from_nid(unsigned long pfn, int nid)
-{
-	pg_data_t *pgdat;
-	int zid;
-
-	pgdat = NODE_DATA(nid);
-
-	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
-		struct zone *zone = &pgdat->node_zones[zid];
-
-		if (zone_spans_pfn(zone, pfn))
-			break;
-	}
-	__init_single_page(pfn_to_page(pfn), pfn, zid, nid);
-
-	if (pageblock_aligned(pfn)) {
-		enum migratetype mt =
-			kho_scratch_migratetype(pfn, MIGRATE_MOVABLE);
-		init_pageblock_migratetype(pfn_to_page(pfn), mt, false);
-	}
-}
-
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 static inline void pgdat_set_deferred_range(pg_data_t *pgdat)
 {
@@ -771,10 +746,27 @@ defer_init(int nid, unsigned long pfn, unsigned long end_pfn)
 
 static void __meminit __init_deferred_page(unsigned long pfn, int nid)
 {
+	pg_data_t *pgdat;
+	int zid;
+
 	if (early_page_initialised(pfn, nid))
 		return;
 
-	__init_page_from_nid(pfn, nid);
+	pgdat = NODE_DATA(nid);
+
+	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
+		struct zone *zone = &pgdat->node_zones[zid];
+
+		if (zone_spans_pfn(zone, pfn))
+			break;
+	}
+	__init_single_page(pfn_to_page(pfn), pfn, zid, nid);
+
+	if (pageblock_aligned(pfn)) {
+		enum migratetype mt =
+			kho_scratch_migratetype(pfn, MIGRATE_MOVABLE);
+		init_pageblock_migratetype(pfn_to_page(pfn), mt, false);
+	}
 }
 #else
 static inline void pgdat_set_deferred_range(pg_data_t *pgdat) {}
-- 
2.54.0


