Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96C5C606A32F
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 02:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=PDPynmAo
Received: by kanga.kvack.org (Postfix)
	id 398C76B05B2; Tue,  3 Nov 2026 21:35:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 349A16B05B3; Tue,  3 Nov 2026 21:35:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C3016B05B4; Tue,  3 Nov 2026 21:35:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D6F7C6B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:35:47 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BFA1580479
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:35:45 +0000 (UTC)
X-FDA: 85395871050.23.DD20929
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf24.hostedemail.com (Postfix) with ESMTP id 06000180005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:35:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=PDPynmAo;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793759744;
	b=uFhW83aEtA95F5gEBn3uJa1zKxd0DI6BVbAjY/jk/Fk5hdjsSVvZNSXSgsgGYqYt9GGKmX
	mjyb9nOBxOqYu4mGUH/jynIVfQwmM2vs8a8AObhLwJuafkRzygAu6tf5x0YG4qnkA1r29p
	QRIYLkTm/8FKD29Qh5tXeXEeWBMfPUE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=PDPynmAo;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793759744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P9sYomC2CtW1Vmqgl7O90RyRwoR5j8Lupuz/vx9ZYAY=;
	b=BY7mJVuh4CrJU4IAy4ZorMA6cyKJ4OvwjfE1XYs9I6LdFT0hGs0nuwtN/raTjC6apl7SE3
	+c1XinIhgtOdCq40Wdb0rHFpQ6T7X2p/4OMA2tr1tYVN89owR4RsygoEBMBJMMKCibJzUI
	odKZsLjp4vi1dfKg5vDSBi7P4WVEAtw=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8a052aff9e9so212296b3a.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 18:35:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793759742; x=1794364542; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P9sYomC2CtW1Vmqgl7O90RyRwoR5j8Lupuz/vx9ZYAY=;
        b=PDPynmAorPKT7lwRhIHBNI10BOre6h+IzfLOljUiU2D1S0XGrJYAVslHqWieon/LC5
         rVbgPuTZGLN2cCqHaf5DKJR/bI+DEd7+t4N6n5sAGAdOy8RShFzMbMTcR0WyYd9wxaLB
         XgRGtk9K9wWj5RAEDQ77SRQBNU8YG+ZZwMQRXJgbYjWYmfnGUoAvRKKkSHaeLZFZwuoF
         nz8prB5IVQZN7s8zY6/e/rOaiDvVAYsvq2eWo2TP/L9LRD93gfSFmva+aYDtLgs6qFyN
         Y56Ez7oIvleWxNBCEBRdS6dasgbdMAawKflY/j4sFLO5DQxbCNxG5PKvIiG15f7v2JTN
         fXYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793759742; x=1794364542;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=P9sYomC2CtW1Vmqgl7O90RyRwoR5j8Lupuz/vx9ZYAY=;
        b=lyLezMIndPCHwtGe+HPyYjrr4IrtXz3aOmluihNkg50kEalq0C+F6QPr3liP1F49lc
         CyIMDRmoW4Ui3mMTAY2TI2IXhhPtDs5u5Yk9xRRxHflmZ524kw/jtyjJn3YdkOEtkAGJ
         DG1X1Mu3ifhUbmI/0oEwQK8o1Nj338nDTN0ozSiKFZs0m8idmZH0koqY0oW75EhyikUH
         G/evygvcYCsfAOMi/931wsNP7LVt6f3nkQk+NZtlcO0nAwrEMTz205btdWjyrkeeP0Y6
         bibw2ddNZgE/dPAsJn5aAys+Te6kHiyCc+ekDli9+H7riqYBTSojGx7Fp49AhIDABlFh
         7XjQ==
X-Forwarded-Encrypted: i=1; AKwUvBxLghccBMqVNYemSkw+W6xVBinR8sdbOl9nh9uZjA5XanjOH7LxrLIOVaJLvrQhAO+KdynGw3WfNQ==@kvack.org
X-Gm-Message-State: APuU4Z9HWzDz/9ULvyC45JZLU/CnXpOBnOFB8MuPogZrJFpmZz8N6fgN
	SRjI/kJD5n2r1Gbnj3nv6KjrxuSt8ypg+CWh0UtiAvy42yqNDgjpHK235VQ4Z79x/Yo=
X-Gm-Gg: AYBFou17tmct/6aupGkrneRaDZLWrzNuGyp3VUfLvLX1Qv7A4E2c1EaM/PAr6WCOOMH
	tJH1m1NDohG44wbtnAXziWtneAEiVfSI5VrQXPqHsWc+UOdQR1aEMHp2v/sNMg4LzGntYZjiIU0
	Ltf/tVhiUfNGuplCs800x9/+BBfZtSJq2x8mCy/F2/QLUf5OFOaQjAQ6xKjko1R1j74d1rsAt6Q
	ZC8uUSagxh3a1se8yhyylQGNEST8CAvlXVZ8CrwSdhUiVHIBpCsYMRlRO1X068iFNCHDxDHI/MF
	q20TfpGTuPWfWoTL/VS8GopU2CQSqAZ39tmXMhRmZdPzcESqnC0+r15J/CSNKfWvqYtKsqIwKtY
	0THBHtBo+c6C9YkFS8ESM2gQP0ZIngmTARyrBQjAx4yopSsMtNUlRR/3AhRXgngjFrGgB82dbD5
	YOJNM9Umr8ix68xlK2A6UwiR5nfhtGe6+4iST2OkPLHc6Huy+u7qxxU1z04thOVEQXqsfEwK+AI
	8XW1oe4WaF23zSTtW+T3idyheWGRt+lEWUovYrzwM6D44NovpaBVYt+yBr1M6Lrckc/SM8kf+BZ
	7vcnXCz6+r6XP+d6+KpHkM3iQQUPikngBG66Zuq5KgMnajCzvw==
X-Received: by 2002:a05:6a00:7490:b0:8b1:1410:ac5a with SMTP id d2e1a72fcca58-8b11410ad8amr2336b3a.13.1793759741578;
        Tue, 03 Nov 2026 18:35:41 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8b09bc3d1f2sm240815b3a.50.2026.11.03.18.35.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 18:35:40 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 01/12] mm: hugetlb_vmemmap: remove HugeTLB-specific vmemmap optimization macros
Date: Wed,  4 Nov 2026 10:34:59 +0800
Message-ID: <20261104023510.260766-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104023510.260766-1-songmuchun@bytedance.com>
References: <20261104023510.260766-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 06000180005
X-Stat-Signature: 3gzkdpcp91fgxh1qoz3e66caezcqewyr
X-Rspam-User: 
X-HE-Tag: 1793759742-521833
X-HE-Meta: U2FsdGVkX18KhNtDWByK3IH3R9Tn8/8HIQECLUkn4DFRgBxThtunxzEnyfA4m5O3NxWAaljAsgDNhgU6pvAkBEn2qitjd4L0OXt96/m4xLfqLyVkzJGr8OTAaBwntkyc20jQ/lP6E7f3G4wPCQqCHmhT3dgfmT25BqXjrAGDd2/QWZDL6uUoYtVwWvC5EfOTAwDQRofgyyhuP4az0IYB5V76MzMLh2iDLX0IhPLuhh3yia3SoV0teuU5WRTX0x3JlMAYaYJapECbRdCUDHFcn/jBxBDVWRxQYT6E3gY8hGSioQO4Gda7rnanT/ppaF1ehxZhqj9x9X8qqg7RpWUc1eaXwZ4ChOwhDZob6zFeAKtNQjwZZ3FpA2FWJU7ZAG19bvRoCUGMzHcuBCuH7rMurGkfCs9F0u7I2A5UR1k0zm8nwjpCDZLjnI7Q8n3RXlQYC6qMveS7wJsDjzuO7qXic4M+vAPQneQVjwbMFvS6dHZqNNEElmdeNwf0VmSPIKtIVO/k20j5F01SFqiQLLH2HG1UugsNtljdJJGHUu3yLe0eK9TTmBqR2w8zrJ9gnJM6z09YGP1BTYrr6clXRzhJaFuLYkVZyNTBYtfnZbSnTOrOwtR5F6dMW7BPIjXYZsTFcydvRPA8ayyD7OsnY+xtjrK/99Wg9xQAXQFfQMTSoP233c6Mhj3FEC2ReiFXxpJ2ZNMnvdjKAV/jL6wiV0OYmunnYCXPYdDRT/J8UJW3E7py3QVbKG61WYd1CHV+V03mPlmK91GCVwzcHgSXPCKkGDFesB+keotbEfp+gmCqmEMlZ9rgMvTUo2HYwH9anRT0Dl6SBvTwFTfi5uze78CfsTX7Oe2qBUTA6LXIFSvJK0P29Z30QaJbiIuWgjCK7Y0zN6XR9/YlP+dTvg6z37zo5me/jS4wSY4qtAJZbp70ZGOi7RckErnA8oGuX2oPET5gaic7ix/byI4Py6mVvGL
 5uFg9xQ9
 G/lVlCInXcIXndJaRan95dIN1YuRiA6K3QTMu9K23n3oZT+o22P+Hd+tXq9xF+08peTnxg42lmbr02vXpcT4d41RHWCBMVbOYKMXDMfN5I9bfyFXWIY5Iwr5wi81DN62i2ua3OAMtf0zmHZaG4+JVzofQM6ydiRkW787cSvtNAgBqbcZws9sEdBs9jwBqBQmytnofzyejljGW+WTFqvVQJscLhUFUy4Mq86qmLLRQcoeEHRBxz/snySHjPwanSpByBRgEJNMu7f/gFN3/qjlCZElcz2IbVebSEC+DakzeBdA7ClLwZ8ZfgfNLflT2//aciNM9AxA5Qf1TVh+CqchYEEEAm3tVgeanGjkAFmPq62pIODjJiPHOphbBEwswRmjdw9fi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Vmemmap optimization is no longer HugeTLB-specific, so the remaining
HugeTLB-local reserve macros are redundant.

Replace them with the generic definitions to remove duplication and keep
the HugeTLB vmemmap code aligned with the common optimization macros.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v3:
- Collect Reviewed-by from Mike Rapoport

v2:
- Collect Reviewed-by from Lance Yang and Qi Zheng
---
 include/linux/vmemmap-optimization.h |  4 ++--
 mm/hugetlb.c                         |  4 ++--
 mm/hugetlb_vmemmap.c                 |  6 +++---
 mm/hugetlb_vmemmap.h                 | 10 ++--------
 4 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/include/linux/vmemmap-optimization.h b/include/linux/vmemmap-optimization.h
index fa9e9abd6656..065840f3c241 100644
--- a/include/linux/vmemmap-optimization.h
+++ b/include/linux/vmemmap-optimization.h
@@ -27,8 +27,8 @@
 
 /* The number of retained vmemmap pages with HVO enabled. */
 #define VMEMMAP_OPTIMIZATION_PAGES		1
-#define VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES	\
-	(VMEMMAP_OPTIMIZATION_PAGES * PAGE_SIZE / sizeof(struct page))
+#define VMEMMAP_OPTIMIZATION_SIZE		(VMEMMAP_OPTIMIZATION_PAGES * PAGE_SIZE)
+#define VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES	(VMEMMAP_OPTIMIZATION_SIZE / sizeof(struct page))
 #define VMEMMAP_OPTIMIZATION_MIN_ORDER		(ilog2(VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) + 1)
 
 #ifdef CONFIG_VMEMMAP_OPTIMIZATION
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 779b1de33c78..c8c5a996e20a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3317,7 +3317,7 @@ static void __init prep_and_add_bootmem_folios(struct hstate *h,
 			 * be no contention.
 			 */
 			hugetlb_folio_init_tail_vmemmap(folio, h,
-					HUGETLB_VMEMMAP_RESERVE_PAGES,
+					VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES,
 					pages_per_huge_page(h));
 		}
 		hugetlb_bootmem_init_migratetype(folio, h);
@@ -3357,7 +3357,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		WARN_ON(folio_ref_count(folio) != 1);
 
 		hugetlb_folio_init_vmemmap(folio, h,
-					   HUGETLB_VMEMMAP_RESERVE_PAGES);
+					   VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES);
 		init_new_hugetlb_folio(folio);
 
 		if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index b8ce014ba6e6..4b73d6ec8dce 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -408,7 +408,7 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 	vmemmap_start	= (unsigned long)&folio->page;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
 
-	vmemmap_start	+= HUGETLB_VMEMMAP_RESERVE_SIZE;
+	vmemmap_start	+= VMEMMAP_OPTIMIZATION_SIZE;
 
 	/*
 	 * The pages which the vmemmap virtual address range [@vmemmap_start,
@@ -676,8 +676,8 @@ static int __init hugetlb_vmemmap_init(void)
 {
 	const struct hstate *h;
 
-	/* HUGETLB_VMEMMAP_RESERVE_SIZE should cover all used struct pages */
-	BUILD_BUG_ON(__NR_USED_SUBPAGE > HUGETLB_VMEMMAP_RESERVE_PAGES);
+	/* VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES should cover all used struct pages */
+	BUILD_BUG_ON(__NR_USED_SUBPAGE > VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES);
 
 	for_each_hstate(h) {
 		if (hugetlb_vmemmap_optimizable(h)) {
diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
index d717d0d10960..d057e8b12bf1 100644
--- a/mm/hugetlb_vmemmap.h
+++ b/mm/hugetlb_vmemmap.h
@@ -9,13 +9,7 @@
 #ifndef _LINUX_HUGETLB_VMEMMAP_H
 #define _LINUX_HUGETLB_VMEMMAP_H
 #include <linux/hugetlb.h>
-
-/*
- * Reserve one vmemmap page, all vmemmap addresses are mapped to it. See
- * Documentation/mm/vmemmap_dedup.rst.
- */
-#define HUGETLB_VMEMMAP_RESERVE_SIZE	PAGE_SIZE
-#define HUGETLB_VMEMMAP_RESERVE_PAGES	(HUGETLB_VMEMMAP_RESERVE_SIZE / sizeof(struct page))
+#include <linux/vmemmap-optimization.h>
 
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio);
@@ -37,7 +31,7 @@ static inline unsigned int hugetlb_vmemmap_size(const struct hstate *h)
  */
 static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
 {
-	int size = hugetlb_vmemmap_size(h) - HUGETLB_VMEMMAP_RESERVE_SIZE;
+	int size = hugetlb_vmemmap_size(h) - VMEMMAP_OPTIMIZATION_SIZE;
 
 	if (!is_power_of_2(sizeof(struct page)))
 		return 0;
-- 
2.54.0


