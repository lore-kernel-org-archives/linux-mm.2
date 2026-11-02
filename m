Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35747606A334
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 03:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=hk52m/y+
Received: by kanga.kvack.org (Postfix)
	id 77B3D6B05B9; Sun,  1 Nov 2026 22:26:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72C316B05BA; Sun,  1 Nov 2026 22:26:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61BD56B05BB; Sun,  1 Nov 2026 22:26:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 38DD76B05B9
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:26:48 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A8E791A0BBA
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:26:47 +0000 (UTC)
X-FDA: 85388742054.03.A0C4B01
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf27.hostedemail.com (Postfix) with ESMTP id DE50840005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:26:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="hk52m/y+";
	spf=pass (imf27.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793590005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GPOIR7ihnEWi5dQHoLquvqe1BdctrHDrgH+hOV6uyaw=;
	b=B8QgkzSrEz4Kjkq4RmHX0clIpUCWaYl1GQ7MgYfmgrTCkQ4gjy6QT7LjjnMBVAfZ44a3E8
	rVUhGYGFvFrPbdWrroWBHJwx7NEBYjbZhIw5YvAG/sb2S6bz+lYTgytxYbet1VndfEMIkt
	AgqIwNqpBO+fYzdRj3M72fv9Sqm5t00=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="hk52m/y+";
	spf=pass (imf27.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793590005;
	b=NnsAlXaxR4v9xndHbBcvxUzsqCanuAQogB9xY0Wz9X03LApAr4VyAab57XBumQKpx3mxSw
	zxVkeOLe32ERV/2+cWdt2rgefZR453wnBA1+nS6bs+0JHQrrA1LPKFsxSXW9jru4Taf/+a
	Ckegt+UkBELPJRgOwn/UODczrbWc9zE=
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cc1bc88a20eso1709020a12.3
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 19:26:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793590005; x=1794194805; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GPOIR7ihnEWi5dQHoLquvqe1BdctrHDrgH+hOV6uyaw=;
        b=hk52m/y+6Y8QXYfynezggzzLmHY6/17Gfd3RZEgS+eziGouQV7UOKJ0ZMQ12+ijKA0
         TaEFjp+2kb0tue9aWbU/xJaC/fNBL2CzZLqf/YJMB8iACcJntcDmVHaDvIwB4vPxXwiU
         J6dKrwa5ZJBAl51eocCzkcYwjd8shXSiopAS9j4WBVPsyYnOL7n1etGGt7GB0+ny87Yn
         QJRqbWIo4t0rfgDF15zK0qAxx9+SpJhzQYGdz7FudnQ/rshQFYpC41Z480244hz42piS
         G62uWhaP+wfzFm0gln+9BuD0zBh2RGLzhJrmt3aWAIUXtAHl2li1c2ZbuKoXZxmEoDGX
         JZLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793590005; x=1794194805;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GPOIR7ihnEWi5dQHoLquvqe1BdctrHDrgH+hOV6uyaw=;
        b=tgutmsVhH9y2uNIKd4qZbeA1NUJrlQCu9myEBb99EEhJTzajuzAIPzF5uEGi1LBGRb
         nQp1q1tMdxvVfAXoG//fXWnD9M5gc+xj5sdRQVBF2m5MuRE8W7bsFEzkGes8O3sxv2VL
         KIK2K7ty1xGB7BB+vtbhkenO81nGzWhft89a4BhRDifggCd75JlcyHWRU0OkECFcrMZg
         MEgGk6QQehjzxo9b9iuK30JJYh+juVYa92Z1VjIHeI6YcuqeYK2rPcLoXR7gkz7nTn2C
         0T4o8S6xZwzX666IKQTOpEFHsAXk2wwj4q9pvPsmaqU+/k+HRF3TfLTv8t9lR9Vxewsp
         K0HA==
X-Forwarded-Encrypted: i=1; AKwUvBziZAQkPaAidhC38LVpL4QU9AIvNWHrs+Sh9828Fcq3cysxNnePevE5DvnX//lSKAFzUed15w4zpg==@kvack.org
X-Gm-Message-State: APuU4Z+lIN3Yz7BNrjHU+dxHFAQ69MbuvhYemklhYhI2CJu4ziA2lB76
	4j6V/8k4uF+vkH9SsVseyzu74Pk51HxE6H2azl/g6q7bnEw/LORi3+qje3yyGi8p9EE=
X-Gm-Gg: AYBFou3SL0moR310QicOgudWHzuzq64y+g1ch8ODghKdMplxsJvlCLAbiyPEtPn1P2q
	KilSpCyWg7WQAl4efTZX4fwyRzg4iEBYQ2oxA0A98vd39mfwCyw889qyTpXefcZH4kAlw4Oay54
	SDP9FGfZYUPR5yoK6kOl9DuwyIIKJ2XXoQ42AHjyLHBpulChkP+jfiPf3+Xq/tsY2fKbOgKIJnr
	3Ht6a1ZFFKyp/bN8LGhPltpikI3F0NeLBDCbkxDw6RC4Y0CqjV6eEj2Oj1AGe3G4i5Qhe+/YY95
	V+t2rliB8tFB9ySzdHjfzYYo9gA/iDE23p4xlnMlQWyi7nGXGngmJIM1VM2xVi2OEFPRM8a919Z
	axR/ipYWdmEjnMk28NpvCoIUMcsS7DUSbxzhaOPeCK71V1CmqAoSAKfiMZqYLVyn9xo3Rv9hx4Q
	kOyo5jDthaLxUCqozLoyExf6KpiGyxJJEUuHMVRoMZRby9FQhxYbwGEDB+R3Udn5+LlybZN612y
	D5gcrdG0mKuOC35JHw6hq6c4JmovLy/62guW0/pa49ottCyRRYA7c3WA2tfSHX0lPwGdkHucSOj
	ir5CBOu/4BtT2taOUYl13tQzW2Tja1giwBjAUlDm8l64MhY/Jw==
X-Received: by 2002:a17:90a:ec88:b0:3ac:7556:8eec with SMTP id 98e67ed59e1d1-3ae89817e67mr7564625a91.39.1793590004538;
        Sun, 01 Nov 2026 19:26:44 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae845984absm12303317a91.10.2026.11.01.19.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 19:26:43 -0800 (PST)
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
Subject: [PATCH v2 06/12] mm: hugetlb_vmemmap: rename vmemmap_remap_pte() to vmemmap_optimize_pte()
Date: Mon,  2 Nov 2026 11:25:19 +0800
Message-ID: <20261102032525.3597743-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261102032525.3597743-1-songmuchun@bytedance.com>
References: <20261102032525.3597743-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DE50840005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: xfgqqdoeafk53x4kbgq8opg41a8zqnon
X-HE-Tag: 1793590005-646168
X-HE-Meta: U2FsdGVkX19OoJvi+VPmdertlgjMrpRG5Ob8zDgbORNR4VJES8Ycz7aDBgq/hbOJkFeQyA8+it2tLqyQ4FpB9P5kBTnEOGXCQuOHokolG6MqP1gGKPY9SU5fcaQjRwjtWMm5VlSRnZIkBjSakXDfW7ymbuuYJTwcNyWzkit2cb7/aso7aVYlbdsyDW+/WVQSL/LCFt2xwUuQhZxxlv7rjdB5Pf5i07l9c6p5AfV9axJ3KFKvmzU/9N/sOCdLj37hxjD0beqVq8mSDDcSwQq6tFJih4f6NafBS61at7Cu+phlz2mH6CezZx76A3ehjb8FiOyw96rqvC/c0/FdyplndsMKpeq1+pUQ4ZY7rsapAUCPgMnloHxRXYlYDTMkGy+2JAUqjcDfg2StgBLTXqjI8i1zy8x0xyP2ecpuBfvBX4TRUWi1HpP9yNPCNEPmGqF4qt2zD93Qq4Wl0Yd0Tl5W/ATiFR+GMqeAmf4RFtV0JaugznxDaf4H3yxTlfHIkaiFm1ZIYaBO0u2zb4X3BqexB6q3G9AxrkmxDda8AGp1Bo2W8sxiTDmPmkfeBwmpshJ2E6U77HrNlz/h0RdzxznHuoQVNsIOg7a0tRi3urcfgAxV3/bSXi+MU/NiBCwOqNMT9tqe/06E6MGiIud+BCkUfr0dq/O3JYv3k/Ksm03rTFliKbQ5DPg75h5s1FbuEOBkj6gGJ5BKcweJYb0r0KlOEpO7qo+tcx01gOAQCVx0NnGG3vXRm4BE86tQs9nDxxl5gScDkkTqZ7QYfkYiptKz+zEfHPAFckybjWu9jr4u0VHahKHV5T4hJsHdlvBN3YxM820PlEVNOvBKyaezkSN04gnAsZRLwH4f7IofAVDohEkE+rLUJVcvWoQFpagMDKyJaTmCurqmbEf/5lIaCkCLh3C122AW3Af/cT7chBqAkzoPeS1Xj327gBw7IWU38/vEaNGYDOc2oKCVCljJE79
 0yQVfhYf
 k53mayWbaKMMg8hsyV53Cr5RVg5QiIDK4tTVg5s2Uai3tOMgDHrV06ELEp7UlSed33Q7E83XhDBU14YJIzfdeWXlReFymEN/MLBn3ieLxCE/nJ7M2f1Qnwrt4Tc0T9AGY/jagVgeLHLMVdWkNHzJ8EXEwqNGbAx0O/fGRUQFjEEfl23uHAobH0LCqthKXSykAXQsgBh0fqaRVlWkl61yi7MVB0fYQZxFS7zMIE7Z2ldgH3X+r9x9Id3MVDuLI3lZvybFgpkYaEGnMHf43nuKtR6FT8DpyZdWPBs6H+xY+eBB/AkFqlQ+m9m6Hi7YKGLrlpLE9sfKH4CCm/K31ze3uCWZLlFdkPB6KDcjgKZjES6nrOVo9tLQeah6gUPQ4fLaATftEJUScAptM1O5kMtyyEbVqq8u5jELPp12QJ/FNtp/gzhCcXV5mUfJs25pN1BgFfuhd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Both optimization and restoration update vmemmap PTEs by remapping them,
so "remap" does not identify the callback's role.  Use "optimize" for the
optimization callback to match "restore" and make the two directions
explicit and consistent.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
---
v2:
- Collect Reviewed-by from Lance Yang and Qi Zheng
---
 mm/hugetlb_vmemmap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index c9635679a36d..5e84004db4b8 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -213,8 +213,8 @@ static struct page *vmemmap_dup_page_from_list(const struct page *src,
 	return dst;
 }
 
-static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
-			      struct vmemmap_remap_walk *walk)
+static void vmemmap_optimize_pte(pte_t *pte, unsigned long addr,
+				 struct vmemmap_remap_walk *walk)
 {
 	struct page *page = pte_page(ptep_get(pte));
 	pte_t entry;
@@ -302,7 +302,7 @@ static int vmemmap_remap_free(unsigned long start, unsigned long end,
 {
 	int ret;
 	struct vmemmap_remap_walk walk = {
-		.remap_pte	= vmemmap_remap_pte,
+		.remap_pte	= vmemmap_optimize_pte,
 		.vmemmap_tail	= vmemmap_tail,
 		.vmemmap_pages	= vmemmap_pages,
 		.flags		= flags,
-- 
2.54.0


