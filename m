Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43C10C5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 09:53:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46CC96B00AB; Wed, 19 Aug 2026 05:53:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41DD76B00AC; Wed, 19 Aug 2026 05:53:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3330F6B00AD; Wed, 19 Aug 2026 05:53:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B3566B00AB
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:53:38 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8E9431604D6
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:53:37 +0000 (UTC)
X-FDA: 85117556874.09.46FE308
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf04.hostedemail.com (Postfix) with ESMTP id C281240005
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:53:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=N7DCcZZR;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787133215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K7eU7XEPiihNsb4nEfOM3x1W8CVVTfFcc0o6L0WYHdw=;
	b=P8EGOnYdUpzejevlaDmxGzuTfjpMSMpyWFzD5FjUyELVkTj0ub5B3XVcAMwFTl/UGhY6uc
	GZ6BHIIt0Cm7r5tMjq3firNRzwQUETEiwUz++z8P3PaW2TQgVL54KsTv9MSzP+iV+lqPkX
	3XhHTSBs9UMo/11DbHQyAYwQXGm0Jd8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=N7DCcZZR;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787133215;
	b=JVAhMlvd95rwPmLkAmxLDlJ7/x3jwrWNcp/IUQTgQqIXxTKiejmC5+lZnWFnciMfin9jJh
	ivrRb/gJ0h2TEXV1T1gP4OTIttRqM3LjzrNvpm5OSe/h9ByaWYAEk3zm8EzcXeGHe9Po2W
	fBrvGtpvqc3kOxFmms1FEUcwBdVOEzo=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2d5335cf904so6450135ad.2
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787133215; x=1787738015; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K7eU7XEPiihNsb4nEfOM3x1W8CVVTfFcc0o6L0WYHdw=;
        b=N7DCcZZRCN2owvb87y6OKAJBMxfjTVStm5TmITDz2FxYXW2XFYU74zE+D4SDPlNNcJ
         h6Lo/WIKfZ5M6AGn/wYRMbpp3KFIl4QUi79hQ1eRmcAPy6lh3YWt5O0DzjXgN2Qjn3Dl
         bkHHaiUWnVM0vE2ar5LHBs0XWdjDy8Ve10aHuninK8yZdZuml7pXFCt+4eHVqh5It4Oz
         ha3A4YZuux9ZbS/YzeDgiczK+SkE8vdfD32kbP1XKHLAjtBuSFIGLJLEfUUY/bVFUJrx
         g1D6e1bKEPwaPT8c4ksE+BCDG8HGXCZiKXQ+IMXFgDNSiDWU2ld8P2PHih9/kFx+HgFy
         5eMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787133215; x=1787738015;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=K7eU7XEPiihNsb4nEfOM3x1W8CVVTfFcc0o6L0WYHdw=;
        b=m1E5UmJf4RwoAI5fScmShlYUIeiHqsq1eFywwoSGWgQ4K5AOpRjsmgfDhvItAogDXG
         74QacIUtkq5rE8vboPopEvQYOTxm+XKmpOVrkJmSV6qpVclW0kvRUJAMHa46YURFSiza
         66wy/3FX3ZyFjm8b8eDoriKawk2Cp8J0GrxLKBr6GCIp6IstVrmHkiprk3Dhh5IjgzwU
         +k6wovVX+Aure0Gbz2bKGo9ijHNirT/b/o5DJme0XcwfYfqzYiJLYCRZJ3DsuS+6ZVSc
         eMEoVHj+HmJqK8Si1XUeGCx98aopElu1QU4InsThtJA/sX8H1eXLIpD9NgcS0okrEdH5
         1TzA==
X-Forwarded-Encrypted: i=1; AHgh+Rr4hflCTs12aVpKMfbriu/po9caOnnXo5kGufKuoS2NbE5mxss5dEeghVrJUn0kyIpa4YW/rfrJiA==@kvack.org
X-Gm-Message-State: AFuF++mmjr4JtHC7I7xW6uhn2uKFSHdCNrvUE0gTeipeoxE03a+rIymb
	ZZGdlAl1kpRwRbS9aKT6fdvRpQGwgd1JP4dfUKzmuDSoWYb5qgZva7SCACCyzJZXi2I=
X-Gm-Gg: AR+sD12d257bOQhEdKihf/Rv9OzhQh4uu3VATJAkl6k3QBlKCBln+sxApsCl3iq6qlw
	6y0p3VgzkxLqeY0eGRr0VFcBtgUurIfGRXwuh2dBzp3vNIi/XgOs6/ZHHIwSZGNrs3ac82ClFxX
	e4lc57h+gezHkwQcO6HDOS1k5grHGaTNhK1jVMVvfoSK+oLCHo/T5jXQdlq2zj3zsreVhAR8v6W
	Lf7CKmqRDztDdwbWwtFLSdumpknPrMBROLGY8wKJynnPesUH0dhLoGqI0liiio7toZvccbFSMSa
	QYue93Q8Jmuu9fTD1fFeWzQsudzJXaHArpgwcPHjEJGWTvRuvI0Ijt116/gFS9ZiOGW8P/s64HD
	gUpSLmogGJgpovGJg6b3+BpKxhNyfCu9IlvxzeNjNmkjVZBY95OAee+32gd9nuYQAhjxSpgn3Bf
	a4dZO+fsz3deJnSx2Qe9HPNnV4tebsjvBA4O85/l0pYz/+W572c3IbCgKnuP0dYJPSBS4g6QvZU
	35FMk2+5/LkUnv9diKuTlis/rAHpTdrtFRD
X-Received: by 2002:a17:902:d483:b0:2cc:f5aa:9513 with SMTP id d9443c01a7336-2d5fd6fb665mr56244815ad.10.1787133214623;
        Wed, 19 Aug 2026 02:53:34 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d5c1e5434esm22504235ad.51.2026.08.19.02.53.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 19 Aug 2026 02:53:34 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v4 09/17] mm/sparse: initialize memory sections earlier
Date: Wed, 19 Aug 2026 17:51:31 +0800
Message-ID: <20260819095140.17252-10-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260819095140.17252-1-songmuchun@bytedance.com>
References: <20260819095140.17252-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pnsbn14wf6e4mk7onrbxw5qpsghbxppx
X-Rspamd-Queue-Id: C281240005
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787133215-587098
X-HE-Meta: U2FsdGVkX1+gDpnFVd8fiE037CRyehsZeaeuij5tkfdf5idKUkVrRidMubtM7+W3GVFqDHfdd3QcQkhv2WwKgRAqlXb3AwoR55PSHTe88eT6+gzmJ64mFksX6Di7XTREELeRhNhrZGJz1Ij3XtoX4je/ZOXw5YBFiMMEjD226J3whSYeNYKp20PprM+byBnl120CzCFA/9F8H85Fr2o45dyQdA1BOjUzVL79wXWFV88Jp3om6u5FUM5B8szT+GMKON+dfz1NDYT2t1iJ9jDEGOwL3fktb1DJlPzKUc/T4m/j+9v116823HEKN0FnA/mTWs+yuCSuX3QrT3oLFnzKHmaNw3onJEt0lwaNqEqLuFBAmM7DsFXLs+Lxl6wDDLPeiCv3BTfOjePSd2XLnzcfbTNNXP8oNE4lUCADh/j9p10QwlOVhpxkyuK+Z3uIr52h+8TvIqKFx+cx3EvTeEDHnHjdsK9BaAdxPHJXTJSx7Z2PKQx9W0DS1A5GuhkdMjqNmll3Cii8fw/n90k5edHTzJgX3mOn2qtbmyzd6k0W+8caeutyvW0myn65H8JBCNuBYZri04Bsc2/uKGm2Mt7ZuHW/sJV6HvrXUyamhLLUxQHe5MRynsb4Nwx3EUKAIH9kK6Fqerd8VKBoSajhIfjsbI/7KWvYw+4yPvhthEVFskYVPFK1E4TKD4EFzlzx6gbH4f5ALINs71v+/LFYw89+z7Y3qPl89VdvnaBjLNUd+NpucgPOdOZy/un8wFDAud+Za4Q3TqO0MMqMlP14ilqp5F579vtDX79LVhas8f0/KknFfCrbzIksPIiH2lE8bFCC5dtpItSxMDOXKXyDLXvmw3yhVPRMUzWKYMyFRIiTPuwWhrNFJZzIOkPmE/f1yhmj/Hb3ffqNE9QTutkSdbd1o4sxjZKCisriPGoV+mhlcMRc1RPFv1RXMhzbxYx1hiu4LQAyAvUmObg81piRvsa
 QF5l7C7X
 AUtoo9wIkoOOwgAye02gUzWAKoUYE3LKhliwAy1bSSfAyd2DEWKVSTkW65xVn1ZrtzGC+qbv7nXEur9hj7obDSdYGNecuAJH39rzHFe64Nfk8ueJzc67SFt/k0G0vp329wAqlE87ZPbpV68x4Q6CK01FcuwfjsC9IrEFRoIVHZGu9b9shHJWez6ZED9NJW5+s279StYvUO2tCnM6/9xXXB7oS+tMo/pFFLQ/kTlJsuNPAaYBoVgRoaQTxE70phDXbhuquO9uXxY57LzP8lJw7jrgy1jr95dPyDxMPsmmGlKgLNuF6Ffu967wDb+k4PP5UhNC5uPPmDEbqhknsux/4HxGl8cZ1MaWCEnCy319UHMU1wqzr+6Bkfr9btQ1EkP51UMEG
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
index 3625de86d1d9..c37b15a3c69b 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2636,6 +2636,7 @@ void __init mm_core_init_early(void)
 {
 	kho_memory_init_early();
 
+	sparse_sections_init();
 	free_area_init();
 
 	hugetlb_cma_reserve();
diff --git a/mm/sparse.c b/mm/sparse.c
index e6cb67ca9c8d..439802e6a6ad 100644
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
@@ -322,8 +318,6 @@ void __init sparse_init(void)
 	unsigned long pnum_end, pnum_begin, map_count = 1;
 	int nid_begin;
 
-	memblocks_present();
-
 	if (compound_info_has_mask()) {
 		VM_WARN_ON_ONCE(!IS_ALIGNED((unsigned long) pfn_to_page(0),
 				    MAX_FOLIO_VMEMMAP_ALIGN));
diff --git a/mm/sparse.h b/mm/sparse.h
index 1569774270fb..89d7ef91c041 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -59,6 +59,7 @@ static inline bool vmemmap_optimizable_order(unsigned int order)
  */
 #ifdef CONFIG_SPARSEMEM
 void sparse_init(void);
+void sparse_sections_init(void);
 int sparse_index_init(unsigned long section_nr, int nid);
 
 static inline void sparse_init_one_section(struct mem_section *ms,
@@ -104,6 +105,7 @@ static inline bool section_vmemmap_optimizable(const struct mem_section *ms)
 }
 #else
 static inline void sparse_init(void) {}
+static inline void sparse_sections_init(void) {}
 #endif /* CONFIG_SPARSEMEM */
 
 /*
-- 
2.54.0


