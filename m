Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80EDECD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 10:12:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E85A56B00D8; Tue,  2 Jun 2026 06:12:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E36656B00D9; Tue,  2 Jun 2026 06:12:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D26176B00DB; Tue,  2 Jun 2026 06:12:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE0016B00D8
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:12:29 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 80F031408B5
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:12:29 +0000 (UTC)
X-FDA: 84834558018.14.AC37CD5
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf10.hostedemail.com (Postfix) with ESMTP id A817FC000F
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:12:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=juuNZRTi;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780395147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=26MXCqLFrwb2c3VcF20KKUb5g0TkMABKfAG/bHmkXiE=;
	b=seZXUlJXDfx9/Ub4c6Bn0t6lRKWD3JnMPdTDVfRvcDqe/bwm+ex0ws0scin6G5V+Rzghk4
	Fh6Urnmk9XXiUhcp7HX+xylCMcK5U+lPJld5gy1Ga1df7oP4nDi+TcR+XV5ds3hqscs5ht
	DZTwq3hKTV4bFaRORt1rLTjJRsdewcw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=juuNZRTi;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780395147;
	b=kyHSIYsU7Mw+zWVfcVWu6hXAZLKOdoOjJS8D+H1jS+sn0nqL71SPZ7xlgxV+myX0MpqjQw
	opgyrMJeUoLSW0UyoLHWa1Ekk3SEgAb7MwSyYO5DZPN99uYFkJOlLHFwVuiUb2lbbopsKf
	Iw51MEusFx3p85WPuIGRehCk3P+1L38=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8419ab3a297so3540202b3a.2
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 03:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1780395146; x=1780999946; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=26MXCqLFrwb2c3VcF20KKUb5g0TkMABKfAG/bHmkXiE=;
        b=juuNZRTiE36J8rmyUWR1nlW5iJXvxXTbEwGy5vxrWEeUzHPRQwbUzLnaUI7TN5zXX1
         vXs+i5lPGd+G7ROPQ2fQBD4txS4ojpFLWq1D3j0jnBdAktz9kde1xb+gWblcAnBkKblS
         700mcsH8WbIO8RHqKAUOdpQXATYtJ8BZ1aca80qYo9NJmKFQZlD7uKUGmO+QJrfkWWEK
         24lQLfB+t8d0DrOL1tEqJOiRBLL0ZaIaD3FfOvMZemQNPbS7vgSqbQF6te/41wm8VUFA
         Y6Lc73YQUKCxoer013kxifl2qnexvwOgKkprVr4Iyk4zAWgEhmRtVYjKgKeg+6Cqwk2I
         FL3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780395146; x=1780999946;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=26MXCqLFrwb2c3VcF20KKUb5g0TkMABKfAG/bHmkXiE=;
        b=rebc1SDQ81UT9Ec6RvVA2eYotANfZ5SygJ1g6U4wQ5E5sPJjSsfiwslc4eyhNU2Z5l
         8z+KEF7uFakEWyg8VV9Hghs8a+Sk2WPVEk1ahF7K2eRJDcGfetW7gcSRl03tEtmUmIT8
         GTzjH3Ec4Y9hnzH1nJMS7m+jvtBUHG39Nz/EsHJTleegN/jd4fPGTy2VytfP+lNawdwh
         I/ZOgidGKAm/Ct0NFtfjDCGa2UFJbFZOp5Z2Co9Fj2qjsMu+biSctuFXLoDZz3RGrEcR
         wXcq0/N+hby54zyfX0mbA79oAN/J28C3s2VjK4mQa0b8xtvg+OC/+pMf2hdR9mEMaXO1
         +lbg==
X-Forwarded-Encrypted: i=1; AFNElJ8tfseMmKlBlYva8VMmi+/iecqG8iLu6rTK+4UOWkjo+7a1MLWtyOGDF1R3ejAZzbpmX3lhJHBzLg==@kvack.org
X-Gm-Message-State: AOJu0Yz7syw6Ii5jCO7KtInjslm+c0M75VTDnELvGr1ToSWrYWxyH10O
	ESdzmrl9At6wXc2ZQ5JY0Aiso6BXgNaYb/OgRTxWHaqRlqiK5Rd4ZxD94WRPUgSdRGQ=
X-Gm-Gg: Acq92OFIxswlVujODHhSpGvqxeB6Ql2mQ9rZRGMYVpof+DRvTMLxQDyb2GaPikW1gGb
	dXUxs6QOLxIQcGYWjujH6kcFsxXrn4npo1d13F57lksK21mjQ3N6DHSA7w5Qg2W3k4tkcRyoEcK
	QDAasf3dIohBa3q51YuH6gF+9EztBqVdpZ75/RqxndQqLWp4GPiSyGwJu/sKsedmszOyWASc6kI
	3O3zEn6q42Iu2ZIcGWzNS44Xyfm/PIBFsDtHF8AKbwElJiGecBM/FgnWANh1vsysqrcue5mSzE4
	Vd+tfv3SSOkDshS4umeQqCCdwoUm1/5WVD7Vj25Gm9ZumS4oku/PDIH7aC9sJsALRPn0eaED1xR
	V8wlu7v1/ZZIrcDdPz/vHQcdpSWei/J/oOO9fQRStQ5xMfbh5BtpvPWcBm8pILPQ/uTsxZNcTDd
	cHK1tD57oVNF8w1x2MmP4uzk8cbt0HQqpIQD4jsajtojPFKk8n9+TgXPw=
X-Received: by 2002:a05:6a00:4c8b:b0:842:43d1:4b41 with SMTP id d2e1a72fcca58-84243d15007mr9808067b3a.47.1780395146453;
        Tue, 02 Jun 2026 03:12:26 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84214d018fcsm12015507b3a.60.2026.06.02.03.12.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 03:12:25 -0700 (PDT)
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
Subject: [PATCH v3 17/19] mm/sparse-vmemmap: Remove sparse_vmemmap_init_nid_late()
Date: Tue,  2 Jun 2026 18:10:37 +0800
Message-ID: <20260602101039.1867613-18-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260602101039.1867613-1-songmuchun@bytedance.com>
References: <20260602101039.1867613-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A817FC000F
X-Stat-Signature: h1q3juro1111xrw3xs6cpz4aeed6phs8
X-HE-Tag: 1780395147-266033
X-HE-Meta: U2FsdGVkX1/ZKQdw5P+W4I3rS3nrcVhMjc2znpcagIbeDoARoam04oDhjNS8a00ILJolBnDxtAFpvXJyoCij9uIw1IhnhphzJzE1fC4CIdFNNgsjwnmuEdmUQSOCRe6flpjsLqTVyhTnNw+UW7OHlM+K3ragAmmml0Y5iqzR8ePqv+edkN0JGoCXnetlffS9UOtVAqjwR8tMhpV8UILK/ZmdPryD3dT43pIamixk2M3S0rXwhpeBg7E6DqvMLNf8ld9JaBsnHK8oQv+ZGWc3gy45cPPfKrfsQA/OYJ953Lw6U+4PWf1eiDwFuGEskC9hQ8LDCNY9ADVTkpkdxm/dUF8t/8L6OQhSUmDoEr9cE+si9YNWAVDz+wBAXg4Drq0Tmg3ZTCCi8sLP/L9ONAkVX2MYGhILl3943UVOCvAHT5FB+qIHx99sFnxkfT2tZUDsO6ojKYjkeQdlCb75fjPL9ywP6IJsPJ6FtFYkkYKHrK52s02PoxpHC20WJDukh/Q5MgIOU2vmAbeuiN7/IyyH8VmkAxvs869QI6ilT+q8ST7KfQmpvZEOh5yqxwPtUJTvgy9do3Uhf5ocX8AUknaodM9xvCOr1geAbmD/Sn/PN82gPCjnsd8YGsdXOvTUnGV5t+dd7Qbnl1iKrz52EjzzmA8GIpADwtNDprc+k2ayEfVjZAgcdh8d6j3so61AUTtrsGPxhqRvVNuM5+U0XmS7+Y7oa26C3//nZvw931DrJF+WOZLcZRW+YUuqpVo3BxJpidBMtC//DoJLpbZevp6IVVwNW/UqEg9uK6JAP/W/I1ZNM3PykpMGSVEyO9FQs9KS6REfmNC8DsNbY1Eff45SiB+YaxYdEYXNeDWZ7DVQHwrVmqzu7BwkmWLuGTd64UhflIhiVZV7YyNO6mHlPxeBJY5nkrMQLULH6t1InY/uty5GdoqQsyBEj7ZFex5wHfF8s1s5i38sp/6GyiKqhP8
 LsDz/KEV
 j8kR1b33fh849BY3wHti7dEow/7YKyw7Mdr6B9RswL1oILGH37RBZzSLAt0CQO2a4Q4ctmCGd60w9Yb2w4JmS402bEhlRdx2+wIZtMVLi1du3nB+fo+0eUr0o9wg+RLC9I5chMxVXrSCm+PZ840bmfyup1mdWSgx48LbdezzyCQFyCt7dG3wGEtK8bb+gmEt5ysM4vz+Jjxxc4fM6a31E4Dl0ZFelRiUleWUHy7r6dQ8zZmZFuAViMBg+wKQSePkWIhiZbOKvyZfOq0YFmSPPIsElSq4xW4oTO2lHAbdGx3PKHbeOfEdTaogtikasYGpT0Jds+qSOH+u1hkapx0EyanNWr9f6lRzOBkv75g7hiAEumueP94dbIdiLiRcOY/sC9hYTo2sVOZNermzA7xDQ3M8I74FhPOS9r7KJuuEpvxPsuiPRY89sYnLG3mlW+cJput+CKlpgbDqohdhMnHMKG/CNH53pO/jcaCBfmKDJtkmopa4jLa8TbK4woFkGWEbIWa+sM67ElKZgUu0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hugetlb_vmemmap_init_late() no longer has any users, so the remaining
late-init path in sparse_vmemmap_init_nid_late() is dead code.

Remove sparse_vmemmap_init_nid_late() and its declarations.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/mmzone.h |  7 -------
 mm/hugetlb_vmemmap.c   |  4 ----
 mm/hugetlb_vmemmap.h   |  5 -----
 mm/sparse-vmemmap.c    | 11 -----------
 mm/sparse.c            |  1 -
 5 files changed, 28 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 1331a7b93f33..72883df17c72 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2170,8 +2170,6 @@ static inline int preinited_vmemmap_section(const struct mem_section *section)
 }
 
 void sparse_vmemmap_init_nid_early(int nid);
-void sparse_vmemmap_init_nid_late(int nid);
-
 #else
 static inline int preinited_vmemmap_section(const struct mem_section *section)
 {
@@ -2180,10 +2178,6 @@ static inline int preinited_vmemmap_section(const struct mem_section *section)
 static inline void sparse_vmemmap_init_nid_early(int nid)
 {
 }
-
-static inline void sparse_vmemmap_init_nid_late(int nid)
-{
-}
 #endif
 
 static inline int online_section_nr(unsigned long nr)
@@ -2388,7 +2382,6 @@ static inline unsigned long next_present_section_nr(unsigned long section_nr)
 
 #else
 #define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
-#define sparse_vmemmap_init_nid_late(_nid) do {} while (0)
 #define pfn_in_present_section pfn_valid
 #endif /* CONFIG_SPARSEMEM */
 
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 464578ee246e..cde6f3aba87b 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -810,10 +810,6 @@ static struct zone *pfn_to_zone(unsigned nid, unsigned long pfn)
 
 	return NULL;
 }
-
-void __init hugetlb_vmemmap_init_late(int nid)
-{
-}
 #endif
 
 static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
index 18b490825215..7ac49c52457d 100644
--- a/mm/hugetlb_vmemmap.h
+++ b/mm/hugetlb_vmemmap.h
@@ -29,7 +29,6 @@ void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_l
 void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head *folio_list);
 #ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
 void hugetlb_vmemmap_init_early(int nid);
-void hugetlb_vmemmap_init_late(int nid);
 #endif
 
 
@@ -81,10 +80,6 @@ static inline void hugetlb_vmemmap_init_early(int nid)
 {
 }
 
-static inline void hugetlb_vmemmap_init_late(int nid)
-{
-}
-
 static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
 {
 	return 0;
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 3b036251a2f4..077686af394b 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -574,17 +574,6 @@ void __init sparse_vmemmap_init_nid_early(int nid)
 {
 	hugetlb_vmemmap_init_early(nid);
 }
-
-/*
- * This is called just before the initialization of page structures
- * through memmap_init. Zones are now initialized, so any work that
- * needs to be done that needs zone information can be done from
- * here.
- */
-void __init sparse_vmemmap_init_nid_late(int nid)
-{
-	hugetlb_vmemmap_init_late(nid);
-}
 #endif
 
 static void subsection_mask_set(unsigned long *map, unsigned long pfn,
diff --git a/mm/sparse.c b/mm/sparse.c
index 3917a47153d8..324213d8bdcb 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -320,7 +320,6 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 		}
 	}
 	sparse_usage_fini();
-	sparse_vmemmap_init_nid_late(nid);
 }
 
 /*
-- 
2.54.0


