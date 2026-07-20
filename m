Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53524C4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:32:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 570B66B00B5; Mon, 20 Jul 2026 05:32:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 521396B00B7; Mon, 20 Jul 2026 05:32:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 438136B00B8; Mon, 20 Jul 2026 05:32:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 20B8F6B00B5
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:32:57 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 929D1807E9
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:32:56 +0000 (UTC)
X-FDA: 85008640752.21.0A9FBFD
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id CE7FCC0003
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:32:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=RrTWtjgN;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784539974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O6r6YRMeV0eXgcqg3s9gtqIKBRl0ecB5VwywLRj0fuw=;
	b=EdHR2oL9Valn638HwFRU4l1boSmRejCVdjeLDMdtnKCC2RakyaYivAG5xgt6pY7ywoUbqs
	n+8ndvOHRKGk+DJOjb2321ByEOTbvhH2kVsfgF6mohdf7nYlFWujylqmu2kq7rObtcZILa
	7dTGfEpb/Atb0vbaq8LA18kB2Mgsfuw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=RrTWtjgN;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784539974;
	b=HSPgW1J+kqsGJ7X7w2Z7RnnhN5qhTCJT/DrCU/is6bv0U1DKvz4jlCUZQBEXKAuYnFGG7m
	/qsDVXJ6i9KClHklplQCHcWHu9sRNHsSGcWcc7xz5E3nspHa9d3wy5OXLi3YKmUUp79c98
	xMZaPH9htuPPdNPgJN4LzMwy1yJV9Lg=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2caed617615so109060495ad.3
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784539974; x=1785144774; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O6r6YRMeV0eXgcqg3s9gtqIKBRl0ecB5VwywLRj0fuw=;
        b=RrTWtjgNWRvSqgtFCQ9DJLItYz8l/JTSuohFuOznTo7152fbL98zsKg//i7SKRAHc3
         mB4DkWdM+D3zDoZFVND+mN//Do+GjLDjrtQomIUn7K2HSy+d6ZB/BzOZKr0AVLYxTP/W
         S897tV7BkCj3sxd6l0feSyQNF0/xI1G49++Ht7z1N3hh5Tzc1sjdOo9h9vrMhKPAwSMO
         Gz0e2Ama/vjqXkmg4I6k3rTN45JrSreiDoSf2Yx9vlc45+Z5R9M6FoHPA79LRthsD1vw
         Rz+5VFn4riklJulSVo8fSvF438d4bHdA0zMgPmYd9zlBpSJIJRIFK4WHj1QCkBf9+gIb
         Gx/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784539974; x=1785144774;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=O6r6YRMeV0eXgcqg3s9gtqIKBRl0ecB5VwywLRj0fuw=;
        b=Hlsulc6EBbQjCB2zAQ12Viiz43HLYO4G/vO2RqRiwRB5rS42w/8njJeytlFpH05yBf
         sYqjTIU4ZfRO+naMh8vKwxqETcD5PbIMzy6Uxo35u/X64jTHU6stuz3IThNOlCeFUXuc
         87Kn0g3aU1r6YKHCCYnfXt+MuWxp9HMxqo+Q4qT7154mAlnjeqhSj4Eeqnn5Gz3bFrsX
         w1wGvit3flTy2Q5qinwJj9bMexm+doZdHfG38y+5ncNgDF/xQHIRXxXNGUo12ssP2AZX
         0ILm5wRUY4PnnhGlOjwOiq7TME2R4lEJnwAHsQLRJlNAS13Jj65pDmSxkjcFu8Snt8R/
         NAlA==
X-Forwarded-Encrypted: i=1; AHgh+RpEZNgobH4cUGAV/O+Yp/W4oNAr2f2nVU3lFwI/8xjauWq+1ZRs2Ga0kUV662rfAfNJoONvPcky2g==@kvack.org
X-Gm-Message-State: AOJu0YyssEyLPYIQ9KO+ygHsAPL2SDQk/j61OKxKHjaLCQvIoDVG86CY
	HphRHmVI5UQvbSYJR6xPpVKpUjOtH7d+80G+X3q0HiAuifdu5Ywog3V2dGHirspQgVk=
X-Gm-Gg: AfdE7cmveWLQYuuEBvZemKwmfLkHZen7/O5pBXeXlD04hyDr1uJ256CPdqMSzAtl2nN
	2izkmPIuL3M8GMeJ9xPOdupjg/TpZiCq84KtxgLVNDohW/ZmnEgsUDivoNlI0UP19SbVtaAEQ5l
	7kHTRdAsDHPlfKpEkb9BH2VrRQrfv3179xYaA/ybs8edGcpwi4GrGWdB7FSp5FBJzUMq0slu8h/
	vIWrwAPULNC1zJryYYQr0f9WnOrZgedU0U3Gh6I+0mV/rYu/sphoOACWDG9ZrbNK0jMQB7t39Vx
	E8BanCWJLVJ/IU1r+THjqk2wuYbAmdf17VQHOSiHFyU6W5+eNxUetwZFN7cBk5wVYhpm5D/t0Ga
	fx6cmYWhq+SaSwewHDTzlyiwsEMMw8UeSoso4uUjkqOgBNtwHFMulDmyfeQE5F1FtZYc+HS2l5V
	Tx5LwuSLwLW2/K1fGScWIdlCU=
X-Received: by 2002:a17:903:3c44:b0:2ca:ed41:d331 with SMTP id d9443c01a7336-2cf34a3f5c3mr145432835ad.45.1784539973596;
        Mon, 20 Jul 2026 02:32:53 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.101])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf347a7c9fsm53136455ad.84.2026.07.20.02.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 02:32:52 -0700 (PDT)
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
Subject: [PATCH v2 14/17] mm/hugetlb: remove HUGE_BOOTMEM_HVO
Date: Mon, 20 Jul 2026 17:31:24 +0800
Message-ID: <20260720093127.540540-15-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260720093127.540540-1-songmuchun@bytedance.com>
References: <20260720093127.540540-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CE7FCC0003
X-Stat-Signature: ckgoa9fz8cuihe756znoiredxh4654a8
X-Rspam-User: 
X-HE-Tag: 1784539974-315373
X-HE-Meta: U2FsdGVkX1/H0W5ifrC+NcKkhQRtIpzTC4rPbsYwUPp3RscQuMTuprpzgkSMvR+zzCmx8+hfIaL9vZ0q3FBPRPd6Q4VudpVRqf2cGc7rOUjceq08qKBmYHD6GlH/I2qXCBBAj+a5jt+mbNJ6cG2SB8N0uaQMA3wShLIyYdUSduuJwH73havaOZdrFQYb2KDdDLeyUp724jR9FuuXxkt/LvEKQL36DvPRebQrSmW8k+KACxBcFcNqek/YxBJpOiNvUYWzgmGrLpqBoc6zcLUBhzw4Law4N4GKEtTQ3lU15ir/cme4AK1A8N8ViYUxTJ5b7aRHKu4pNeZqrX9SXwMOETBh2jBg06xmgbOwJPUNVKT8OhXhG6nJU/XZv0ppOg0xrbGzGvGHwun3mi/7fmkfOP2wnGBReLEpdxnICNkmetkFq0tDWHrToAOEk8JmzU5Uhm7UsjAUVPUeDAoqrm8qSakj5CBi3eKHJZZVq4MD4QvGTyJrOwdSQJvmRNBpYPb2ctRAK/r6s3RXgMARQtsIX7H6X4mjHVKzySQMbZkKapHPCznmKyv1pkfGpwqvyqiZzuLjn0qURVzifxqLrNdbqkEeu/FKTh5xx0qNxOjqzIpgn+SZqVdDCYkSP+XvZiEb5LDKyLLpYcnWbAZ7NTSfQXv4G2uqGpWTVQVqoaIGRC9RcQKMIa2s10r7UjVkKxPoFV3lOqFToSttxdiCoxZ5si17JlHMobWpYYbOIyyq8AcOEHbYbjzmUXvm/gfm130SCbQqrME7/waYWFjKAPuM8P3M8T7y6yV5AAxoa2tc2Fgb6aPqSDy/vKgIOjMo4wg7CwIMfiR/K2OmIuM5LsgzX5zGuC+tZyjEYFvRH8r4KdlqFbMSLONrKPqqLe8Nz9ZbW3IY822/Corljw3NFkGoPtSqs9LJF9C8Yndhn6XrjOxmM2Nql58Lm1yqO353m2sv8IdZ6d3M4cCITrR5DBn
 8MKqaCnE
 8LGjrmu3Ys2gCwJFV2lwppjqbJjBonZzSQZma7nC6CB8c2hBGyE/9uO6L1k1tSb9cySTNa1Z96uCrJGI6+HMjiTWo/Yyp760XRFlnaMEPzTrOV35wWI5dtz0rXSy+2CPkLh+yyvnXQtlJGBky8oD4PJGBJt+DgVbDy0YFV//QmBuM5Toc8NNpgZsog3XYqcALBFtrmjquLMlY7c0u+HZTCMUY6v89r/wCma1mAPM9NiNqb5I45IbZELNJv6294d3stYhSLDGArIQ+bNicskghXdfrQv493C90m9UkFBp3UquE7t9SCWqvF55Xhj3rhxY0n9MpQXQDtN/Iz+D/4ZjAHshqtOSolyLfGD8aDRiA7DE4kcfP9CuLiWom0TRZryigWqQh7KhRdz5Xsv5rUwFhxTNFCoYpb+wvYprIzPw+MPIYykaXjamRHd2rWDNoWCExRn6X73zZ09vTe2E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The HUGE_BOOTMEM_HVO flag tracked whether a bootmem huge page had
already gone through the old early vmemmap optimization path.

Now that HugeTLB uses section-based vmemmap optimization, that state is
already reflected in the section order.

Remove HUGE_BOOTMEM_HVO and its helper, and use the section state
directly when deciding whether to mark a folio as vmemmap-optimized.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v2:
- Collect Acked-by from Mike Rapoport
---
 include/linux/hugetlb.h |  5 ++---
 mm/hugetlb.c            | 12 +-----------
 mm/hugetlb_vmemmap.c    |  2 --
 3 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index fe28f98e1b22..3559041a5a57 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -675,9 +675,8 @@ struct hstate {
 	char name[HSTATE_NAME_LEN];
 };
 
-#define HUGE_BOOTMEM_HVO		0x0001
-#define HUGE_BOOTMEM_ZONES_VALID	0x0002
-#define HUGE_BOOTMEM_CMA		0x0004
+#define HUGE_BOOTMEM_ZONES_VALID	BIT(0)
+#define HUGE_BOOTMEM_CMA		BIT(1)
 
 int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index efe0d639933e..c03c5c805cd7 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3210,11 +3210,6 @@ static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
 	prep_compound_head(&folio->page, huge_page_order(h));
 }
 
-static bool __init hugetlb_bootmem_page_prehvo(struct huge_bootmem_page *m)
-{
-	return m->flags & HUGE_BOOTMEM_HVO;
-}
-
 static bool __init hugetlb_bootmem_page_earlycma(struct huge_bootmem_page *m)
 {
 	return m->flags & HUGE_BOOTMEM_CMA;
@@ -3306,12 +3301,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 					   HUGETLB_VMEMMAP_RESERVE_PAGES);
 		init_new_hugetlb_folio(folio);
 
-		if (hugetlb_bootmem_page_prehvo(m))
-			/*
-			 * If pre-HVO was done, just set the
-			 * flag, the HVO code will then skip
-			 * this folio.
-			 */
+		if (section_vmemmap_optimizable(__pfn_to_section(folio_pfn(folio))))
 			folio_set_hugetlb_vmemmap_optimized(folio);
 		section_set_order_range(folio_pfn(folio), folio_nr_pages(folio), 0);
 
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index e37ac4745add..a25adc474351 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -714,8 +714,6 @@ void __init hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m)
 		return;
 
 	section_set_order_range(pfn, pages_per_huge_page(h), huge_page_order(h));
-	if (section_vmemmap_optimizable(__pfn_to_section(pfn)))
-		m->flags |= HUGE_BOOTMEM_HVO;
 }
 
 static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
-- 
2.54.0


