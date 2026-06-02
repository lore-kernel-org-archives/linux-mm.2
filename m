Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5184BCD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 10:12:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B51C76B00DC; Tue,  2 Jun 2026 06:12:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADB356B00DF; Tue,  2 Jun 2026 06:12:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CA576B00E1; Tue,  2 Jun 2026 06:12:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 883256B00DC
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:12:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 505E28D018
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:12:35 +0000 (UTC)
X-FDA: 84834558270.05.00535B9
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4E5E220004
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:12:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=hyVlCN7z;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780395153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1RCwi6UfDOd+MCdFxykpsofvVeescXETLa8L+kiLjU4=;
	b=qIIgBtgFPmypS5Wzl3zg30Zb7Gs1ouhwz5vQjFGsryJAZo+Nt6plzrH6Cf8/fGkt1I/OwS
	1yLuWdv+5QhInsooh8m1fxcxLH1bKeR1NsfdV6qDQFsgMShgT0MFtz65QNP+1JOtGEbZbj
	gfv+9nyJGm0y23yrB9ej6fPtZx/R/YI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=hyVlCN7z;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780395153;
	b=lC6Vbm0kOEf84ab+HPKRlMZwYtzd+1WfLrsIBoLrshJoHkwf0YcSyo8zflx9ia8mKcbTyi
	1hkyaofO7Kd97WraIGQLyhEMy/+/4ChVGXWXcZWFcJtg1rcHD23z/jg9TQPnRFUIIECItb
	Cthv//znlyKw7uAyT1jNXiTwAKFPw0I=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8424b00710aso1244516b3a.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 03:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1780395152; x=1780999952; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1RCwi6UfDOd+MCdFxykpsofvVeescXETLa8L+kiLjU4=;
        b=hyVlCN7zKPiAbfK3maOJPF6ccSPFhPdCJJPPbTgyEyydNfTgvs5MJAXanRCVas5i4U
         foHtzi4qAYXmUyEjmHKjcMliELzAKY6kf0ZGecv1MzAozxuaJD+aLkbCeFK7LMBmj3eo
         n80KtLEVAXf54f2VGKmUFwuzSLapGzcto0Qvy7d+WeR9CgdV5huIcR1uQmcfDn6YWdYI
         XVtfCoS/WsEnaqHWyguFiuO9e0KHAGv1cnUf8jrH378KMZ279Fruzj99mA2IWJ4J4UVK
         L8ced2yO6+izl5e2Kiai9qhHxli44C4XdMVPuJOMwVH/U5IuBj4ROu+PilxDTE0EaIeH
         OlfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780395152; x=1780999952;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1RCwi6UfDOd+MCdFxykpsofvVeescXETLa8L+kiLjU4=;
        b=IYqBg69zDURKgixHTPUadpsLTfqPe2X7jkGBpWHTXsL8oFEiZ8GsJz1W3lasw3K451
         kpXyTKHIRM6F0M/XHDQ08+9992eWlkN7JyPhYNAV3dVPR6BONf1kCnrDAYrfMcg2O0dg
         qAWJ63vf2uZPPNJhdA4NjxAOCB8xNwto6QonEcYf3W7xQkCBiesD+Nd2lghi9MF10L2S
         z5BVTlj/xV6+Xryb2COs2Cw6yJGhVy50ztJOWVRNSqZlF/NqQMa6wKXsm2QjtgWQIOXz
         z4tsKB622qtFsC8CcUkAjHGY0AnB3HX3gXLi6NJ174A+eyNLZ8qj4Zw9aWwoOIP0Ou+r
         DiJg==
X-Forwarded-Encrypted: i=1; AFNElJ8Df4aBNqFddgGlrRd8EEn+UG2RrbhQm4PvBAb7tJACi7JtYUf+XvMTPhBDz56RBZyfMoNRJ+WzLg==@kvack.org
X-Gm-Message-State: AOJu0YxuO/Bc/oHMn3yNhhI9n7VnxhystzAIryyNr7U0RYB5UTvYKpDz
	QobJ3j7ExjpoNizsuntXr/NnhqinFKAMbvTxQtggbKDgyLiN7ID93h2wwkJ1SlmA76Q=
X-Gm-Gg: Acq92OFPVB9hJBrlnpUHEObdRXD/9STh06rPMMrad8YAZgGvNLNT+w9Tm+uM2OXvciC
	vudGg7qzaDDzVAvEbci5ERWMIHF8kKpm1pIODdz7gLS9Mj61yZPvcXAPzqfCAw7QjUnLEIlcH0B
	Jzcc233ow9kg9wETdPKHezOHZlYnLzB/F1v28z8EJEH1pL+JUsXZV451oAi/Dde72pX1CmCOaNO
	6KKaXzdGdEhSu1wOODlP9ajaXh6cna9ogFtUIXy7cKhq6Ofu27WpVuR9Zrg/kJZ0BCcHqSA8aDc
	AKjb9jiRwGW7qX1pCZUmNev2jpLlYMHdG4eyhCXUKBxEgcEIa0ARc3jFYtIKC0gQT0jocrzmuF6
	qyVn+CJd1WRh7sb9DlUK8UuVCGcKxoxtf6wVyJgKeaaz/lCsJbQsJS3APSqeQ+OtLrywIVMb/Ic
	etUsUez4MqScUVct+pZXVkJvlZS8cO/bzreHkXCA2pljkcvnCC35rB9hA=
X-Received: by 2002:a05:6a00:3c91:b0:841:58b0:82c7 with SMTP id d2e1a72fcca58-84225327e9amr13634126b3a.8.1780395152058;
        Tue, 02 Jun 2026 03:12:32 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84214d018fcsm12015507b3a.60.2026.06.02.03.12.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 03:12:31 -0700 (PDT)
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
Subject: [PATCH v3 18/19] mm/hugetlb: Remove unused bootmem cma field
Date: Tue,  2 Jun 2026 18:10:38 +0800
Message-ID: <20260602101039.1867613-19-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260602101039.1867613-1-songmuchun@bytedance.com>
References: <20260602101039.1867613-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4E5E220004
X-Stat-Signature: o5zof5cgemj3g549pz889bjzeickrohm
X-HE-Tag: 1780395153-11092
X-HE-Meta: U2FsdGVkX1/L6l2OSt80RfJsUE3bAEWLnxcYJk3DH1sl9vjB95xNQQudguvPUO7NBEd3zoOizwIq1uPJOmlm06UHeFHMybizch6mMNVteT7kSvAJ3R4GbQfDTtOG/vnNJcl5McCUP34KHTMv5zCFCO8dFwGCeipZljwDjnL1MSbG3veQjPsy4oBS8GBIPwDP+0CRVStgcZOkXvvNg0Oy3QXaIp5T1YQLy8tnzqgsncNRNKefqQ7Ui+UfuEZyMMixNJj2vyZHKPYW0n4re0uMLR8RKDqZBqd5b2ld9FrmDkyYyjnRA75YJz4JLPIZHRB7xMUiEcYT8iHuBy7QhjPmB69mnWF1kI33JyrH8gF4SySTejw6kavRqxK4S2FZbc0AOcrCt+KuguxO6aLN7DwihREKF0UHvEIJ4vlDvaRVMHF1mVGUVNzxb9kT8kig+0mBmK7qYyMGYGypQf4et/jdpMUsxw1T/A1nNUhxIub25tAL8mv8a0djZQHZkqWTdwG0CmHuIuG6Z8vTcTRqwLMlsMnU1JI6N+pZK0+c/UFbqymFLCnF/OmRn9hsnKRbBOiHKUDx+btw7HvA50BcOYvRct09zhuwsdcXjrw30JDctonTA7BjMSGYX9Wt+73b77C6rHgkDCu3zM6GnfwYS6rgvZc7WZDx0creqgFn/DGPLCSPvhgS91he64+DS9TwofY7ZFYqMOsxQmkF/oZv+hmKnToCd5mW726nY3fHmVr7MMtQy90PALqJq+rlgHasi36A8DfRzZ3Au3nqk6we5gLAuSP4NN78jDcnnoLBBLQXgsRPtPYKvZ+hPCf+XsK5BKoIsGJTuY9bca9eoFC/gC7Lj6JXlGQZcAg4l9QD7XJF1ez6oCN9wM64XzAwBE7x+sh0r5IAoWMgX6QcZ4wkaJBz+2TXDorF9KU5sRD5pwQdL7+eqWTENnj0i4P5uJ4IrijSNc0jUrDQ6xaarbdzcjQ
 jwvYOlGA
 m186bo7lIm21Golkx3xYDaFwt1juq5P7RgTvT3XRsr4OP5X3mSz+NKtbaWjfssMhG5EvgS8VqY7o2INZmEebd0Y3R4iZ+cQD4tKE/hY5cBsG6nM+6AKDI9R/TTAEaJd9yBQh3TRL+4IsQ5wRngwAqL/pHQgFwBJ7YG5xxJ2B1lCK9hNkV5rldUfao8Czt1vgwB3ueKMh/s9NpuCew1q/uUPH9FTPZwIoSXa9pb9CPxwPdEMJcN5Z7ct34iB9ACyI0pcvzcgRYLGpmP9aOTH5ljz1aEcBGBkKgpHDw+77gQ1w6U7gFI7GzU9LPk4v6m5N4B/yTsCMuWQjgNQgDMTjCmrbKXv8SAiYpA04bg9YkGMmmZMKgIsjK/49nWPyquo4q2esSF4wjStL82L0pi/B9QQCZtW1Xapr5+22R4IYittENICsTpXeV1egj73Cv+Rh3/vBeNbDQPh5udRnGwY3KQRk/EGWCGFTRGtBj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

struct huge_bootmem_page no longer needs to keep the CMA pointer. The
bootmem path only needs to remember whether a huge page came from CMA,
which is already encoded in the flags field.

Set HUGE_BOOTMEM_CMA when the page is allocated and drop the unused cma
field together with the redundant assignments.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb.c     |  5 +----
 mm/hugetlb_cma.c | 29 +++++++++++------------------
 mm/internal.h    |  2 --
 3 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 47c3d6d11c58..fb7ad2a4a26b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3076,10 +3076,7 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
 	 */
 	INIT_LIST_HEAD(&m->list);
 	m->hstate = h;
-	if (!hugetlb_early_cma(h)) {
-		m->cma = NULL;
-		m->flags = 0;
-	}
+	m->flags = hugetlb_early_cma(h) ? HUGE_BOOTMEM_CMA : 0;
 
 	/* CMA pages: zone-crossing is validated in hugetlb_cma_reserve(). */
 	if (!hugetlb_early_cma(h) &&
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index e487d0ffffc0..4dfce68b354a 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -59,31 +59,24 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
 void * __init hugetlb_cma_alloc_bootmem(struct hstate *h, int nid, bool node_exact)
 {
 	struct cma *cma;
-	struct huge_bootmem_page *m;
+	void *m;
 	int node;
 
 	cma = hugetlb_cma[nid];
 	m = cma_reserve_early(cma, huge_page_size(h));
-	if (!m) {
-		if (node_exact)
-			return NULL;
+	if (m || node_exact)
+		return m;
 
-		for_each_node_mask(node, hugetlb_bootmem_nodes) {
-			cma = hugetlb_cma[node];
-			if (!cma || node == nid)
-				continue;
-			m = cma_reserve_early(cma, huge_page_size(h));
-			if (m)
-				break;
-		}
-	}
-
-	if (m) {
-		m->flags = HUGE_BOOTMEM_CMA;
-		m->cma = cma;
+	for_each_node_mask(node, hugetlb_bootmem_nodes) {
+		cma = hugetlb_cma[node];
+		if (!cma || node == nid)
+			continue;
+		m = cma_reserve_early(cma, huge_page_size(h));
+		if (m)
+			return m;
 	}
 
-	return m;
+	return NULL;
 }
 
 static int __init cmdline_parse_hugetlb_cma(char *p)
diff --git a/mm/internal.h b/mm/internal.h
index 6b9802460a7c..8497673d0ac3 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -24,13 +24,11 @@
 
 struct folio_batch;
 struct hstate;
-struct cma;
 
 struct huge_bootmem_page {
 	struct list_head list;
 	struct hstate *hstate;
 	unsigned long flags;
-	struct cma *cma;
 };
 
 /*
-- 
2.54.0


