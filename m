Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94475CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:09:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C55F6B00B5; Wed, 13 May 2026 09:09:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0757A6B00B7; Wed, 13 May 2026 09:09:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA7D46B00B8; Wed, 13 May 2026 09:09:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D68756B00B5
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:09:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A3A56A06D6
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:09:09 +0000 (UTC)
X-FDA: 84762427218.23.CBB69DB
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf05.hostedemail.com (Postfix) with ESMTP id B4D5410000A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:09:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=e4g48peu;
	spf=pass (imf05.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dkeVw3HOR7cCG2HPcJochpzFU9bdzNUhNCW0ub/Qsyw=;
	b=1rIibSSO8cg+ciZjnC2SsAymzHxiy6bwn0lV/71y0wR5n0FPUNtfisTOP2LqGAEenn+1Ck
	thXlVviR5vuvhGc0WjE1m1JtmJUsXokBqKsVKN87sH+sqeFJOJjvpU2SSjjnca5aN27ucz
	TMDPkH5MffJFUdrwti0MyqwzZ1mHgCg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677747; a=rsa-sha256;
	cv=none;
	b=KlE0h5Rw04MRw60fuDg/5Dm+a07f6FysiLBI5dYtHagSrVMzwarDE7PB9EAU+LwDsq09Ny
	FgCjiEbdyFmg/b0I63PFXhjiUXUnyGX+NP2p7DU/QZn1SDB0ahp/nAz8J373/on2epL6EJ
	VqSAzW6PuOIfB4ELnh0dlAv2rxPP/Lo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=e4g48peu;
	spf=pass (imf05.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2b941cd869cso42539065ad.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677747; x=1779282547; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dkeVw3HOR7cCG2HPcJochpzFU9bdzNUhNCW0ub/Qsyw=;
        b=e4g48peuY9l4SUx0wLz8wY8PN0NV1QNJ4bzPN1glsnJR+sVmLcirAMCjITMDPnAo7R
         MMKD5WVJGMqh91EoLFHG/ti3F+3/W10eikKwa/D0jWiRXlvHXXjHrcHrPvjITfYjL9Oz
         l3OAEpCzAGEabEdMs+IPhGkF3trMHvIDyuFrMz9Fbq9+UiZQW0Av9KszVAqIe7dgnCuj
         zk9W6RenuLpLr5iDz60Q0ZSXI99QGxEWlxGLniULRm9eNKNOiKt53fiWN1EcVFhptRHV
         RdJC+Dc1GbhD4mOjjNQgm1i0Ee9GQSpUFx/v1lPXJlva3uiqyX/1VYpgw+5ujkS2fISf
         i1/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677747; x=1779282547;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dkeVw3HOR7cCG2HPcJochpzFU9bdzNUhNCW0ub/Qsyw=;
        b=R4p1jgTqc3M8IWFlLMcNLHHivgCohn1nxM9CXMABN9ptZ0BAuw6TZoZPpE91w1KHOX
         E1OTcn5vSw2aOWAVe7de6Jz08nhLeVrui45OlbJUr1pfbUvggZW6bsTkkYCGFlogAJww
         I36CX+hinvbTctHhc+oOQskQK4mw6DGCkDgvnVcCRmYsCMnEMasAv4XabwyMyzwr1IiD
         UPAXdqsASHZ5d9RXj4kNz6dfpuTRdvW8aGhHrDJnItQV3Q7mQT31iqW8wtBb8TYkbk92
         Ef4eNeD5YSccI+RGtb9ytgWOgId5W3Jnl1pSb7N49IbP5Hu3qmyQBSNBPqImE5tCljhc
         xHgA==
X-Forwarded-Encrypted: i=1; AFNElJ91luYLOQnPxfbWpgBI4Ylvdu/DS4i7Pz39vzRSf0ouA8ptchxbRTuNGRXaOaAZ6FjEET8Y58RGLg==@kvack.org
X-Gm-Message-State: AOJu0YwU79dpoTNyqQQXV3OUYPE1YHAp1aWHTh+HED+kpq4QWw3Omvyz
	S2HvzpRThUttxJL5FciMlqsZqLaEr/Jic5Hsyah5RlENCs8GHgbam11qU0tWOt7cPfc=
X-Gm-Gg: Acq92OElj859DBVgpMM2WBA8KBRb1OOb7q2uBpZige/Xl/kdtzBLBtnfnZesGGmsEuo
	2OIW6LtLxO4tf8wYlf9tmOGo9kNfExBcs1zNHy77wwg3VsZ2mlExyHQmNHFMYGRJLrPgNFd+kqW
	0jejBhicmj3ATPk/E54xKCTk3PYDtU0LvXbgmcgkS0oyAwyhWhDP9JfmSTlIVIfNxfXlrWtnFdZ
	VKMcuULOiAXt+Quw5foM/oIUGa9zKxTbFVyZ0bzCiiQ8hjLuRDjYOObhmJj60yBxQ5sIKISi3Wp
	LoNSyOUx9Q97DKmrHYcuYDjYbvi6lT7DGbew2w9itGfqtRYrC+UybfVNYNhHbbGvHQ8pU1aNFKg
	HZC+MAfQf1dX53rFr+G1fNtmg7V4LMsmowP3hp/qAsAhJPVXkE2aLJeNwXPo3FFsUxkaj4+uLat
	F3KlnEi7e/Gam5zYff6tcQwu8WquJ63oggk74o/OyUYzUpFByisGgrlEhDytk=
X-Received: by 2002:a17:903:1b4f:b0:2b0:9c2b:641d with SMTP id d9443c01a7336-2bd2f4dbc06mr31387055ad.2.1778677746427;
        Wed, 13 May 2026 06:09:06 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.09.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:09:06 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 17/69] mm/sparse-vmemmap: Remove sparse_vmemmap_init_nid_late()
Date: Wed, 13 May 2026 21:04:45 +0800
Message-ID: <20260513130542.35604-18-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B4D5410000A
X-Stat-Signature: 8r599sjt4sikyrmk5z8m9johofdgtx6m
X-Rspam-User: 
X-HE-Tag: 1778677747-394217
X-HE-Meta: U2FsdGVkX1+UPvArGC6Js2PH02+qLm9TEU6EFQsrLwWY34TJCPSXq0YbEwI1sKrpKfvUQaqj918zYPiEcITGRtLUxJZg0n6N8ShYlQjbzw5ZAg0s63/1zrqXdQthuKKp+sLVQf7JTvVud+OHnLg+hXJntQct42O0GIs8IfeVw9b/kX65hMW4ZiSFu7+/vcEIedReUbexfoMSMNGho1NYhIhJb+H0fHcB5+GTUc9TmY6JduQkDksJXVY84SiGI5AgbF1ViVBcqk+tCGqX+mG1ApBJwD3z2sNXP9gyuM8ptzVODYcnhvg/TYQ9t0N1E9CHgmaG1kEeSy1a4ewIiF/hKufSWMOt4UzdlDUJd2AFsUY3s6Nj3O7FHJoTzeMx/rC8faxajoK4EBFm4jBbdhabFnJwaEMO8spRx8YrH5RbHFqM5WyqK3ONRTlHZf/DFmsDEJrtbeHujOPBM3vFofEmfNxidt7eGCjhfhOp0tQS6Ohh8iLD1uMdbskIMJ0t3bhvEjKuR82vyhc/HRxKsZESAxDifJEus0qEBCAOHR6RymMc18vGP3NupHxgp+4pVrXeZL/d1MWCAYN4jv4sFdeLEBQkYrUQD1LcIP2yCSnCwGs8XaYpN5ffeVJDEIcfghQLYF+/1tyM0RzStMUlxvvlmMbTWvO0K1eObdGrxnJDFpxVqFcF6oVnyP/NoJLnRJivt96Sm7Zr3yJvYu26TKbxsodiUMVdttcLR3T6frMAfpn4oEVGX4csQMNKGpqhP0bvF3m+9znhV2eiILk7SJvWRXpjVLbwAHAbB8OdcuSncVPbCytOexJOOONmI5V4dzd5szUifQHrUD8pZrP6/zg0mBLMJt7eKdqubG9yLSM2dGIUPq7+97PzQBNomd5F66x2mGg35mAVYKYpeP5pZSJvpj2/gSvm9p+A4u7ly0laZ0/ixN8wczklKYhgAUHb2Hx9uJBdqvZAifXvHZd4N5y
 CRg+tBmL
 SStp8TpuQ/EMSxpu7oPCcqXgaDNNuGOkZ3wTLeAsB3RYgms8VctFscRdOvGIpnikUW1uiVnrs5xhaJ4xSPpLP74oiu4mJSq0Slt+o5Y9bwYO62r5gfm9Cstk6k+5nBiqO98idEzuNbg767ZjUeM1MuubX7+9WyoCf2BI9C+TJ7zJdKaopRm4soemnfpsVkQMjDbMY9LyoCQMWrlb7iYrqzQg/qrAJ4GxYdqShZ+pku9icZ2IrUAMH2FlrY2jUu3aoSscL/kqttOeHqJ1gjdWzgLyMAhsc5w4CnzMXKa2anaerlaUX42ZbhY9n/VNHZkb2Kxsgw4lN89KNJow3eqLWoB+ArJ8wGIBzADkXg0jaEKeLTUMVXfexYxpBZGTxO2f0o9dmuK91/yjV5Pz4YnybMd5m8SuXwko8UOewTzPdMZgnMPteR8PRqkK3FCzdRKt3bjuY
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
index 9adb2ad21da5..362e16497533 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2167,8 +2167,6 @@ static inline int preinited_vmemmap_section(const struct mem_section *section)
 }
 
 void sparse_vmemmap_init_nid_early(int nid);
-void sparse_vmemmap_init_nid_late(int nid);
-
 #else
 static inline int preinited_vmemmap_section(const struct mem_section *section)
 {
@@ -2177,10 +2175,6 @@ static inline int preinited_vmemmap_section(const struct mem_section *section)
 static inline void sparse_vmemmap_init_nid_early(int nid)
 {
 }
-
-static inline void sparse_vmemmap_init_nid_late(int nid)
-{
-}
 #endif
 
 static inline int online_section_nr(unsigned long nr)
@@ -2385,7 +2379,6 @@ static inline unsigned long next_present_section_nr(unsigned long section_nr)
 
 #else
 #define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
-#define sparse_vmemmap_init_nid_late(_nid) do {} while (0)
 #define pfn_in_present_section pfn_valid
 #endif /* CONFIG_SPARSEMEM */
 
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index e2251bc47444..952216a49bcb 100644
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
index fcf0ce5212f1..17d45dac4324 100644
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


