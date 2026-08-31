Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1D0AC624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 16:38:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0463E6B0092; Mon, 31 Aug 2026 12:38:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F12906B0095; Mon, 31 Aug 2026 12:38:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8BB46B0096; Mon, 31 Aug 2026 12:38:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AAC156B0092
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 12:38:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9FB63A01B8
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:37:59 +0000 (UTC)
X-FDA: 85162121478.09.05CB173
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	by imf24.hostedemail.com (Postfix) with ESMTP id CCE8F180013
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:37:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sqcrGgpA;
	spf=pass (imf24.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788194277;
	b=wiygu8T6IFlrcMjJQI7r1mpI/GqCZPAIEd2FxOiHoJY53dipwInGBTWU8DOnX0H0KWnn/v
	Cpndz4Qpes/1PkT+gksMRsuDtBMvKBS6w+qiQOn0G+7r2Ib6wBo70TSjih4prVspFIlS+W
	fmpVadmrzZbJl5o3iORkmIQU6HYrwAw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sqcrGgpA;
	spf=pass (imf24.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788194277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x77j6vdZ8LqsWXipiJe0J8DOL7X4B8I6QMSB+YfLeSc=;
	b=L2S7JRyBOdVLvn39eI/HWZ1OckMkulnyAWRb5h3aBSR2nLLEKidHj4YTuumdF/KiGzVKsI
	wEp7dZEhjSUM3hXDXzf12RJn9RzRyifrE2VyyH+9w3Qia0KVOBJL4r0F4WWYkjp5cdTiJf
	vchLc3eo//5CJtlQUd/+Y5EBnHwjWtQ=
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-459281bc13bso2939441fac.2
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788194277; x=1788799077; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x77j6vdZ8LqsWXipiJe0J8DOL7X4B8I6QMSB+YfLeSc=;
        b=sqcrGgpA8lM4RwkIWAmJZlmbBlbS51lpRBxFu4oKJj+38bqY9rTh/GGyqP5Kr6gp6i
         fHE0WtNTVAnsMIt8+CuZsxYNsaVIj+B7OFdyj7z0bYw8VQTlBvut0I51CNtSx92pjkcY
         KfTKc+/xvtCrlHIb+EifsBVhJebZAiKTa5wEBJRFrVczvvG1sifLWCmnettphNsg8S1W
         Czq1rmaKTXGcucBPkhnXWpuv4UoQqWGfBd2XPQ1MScLv4DluZKtNUnhA6L6kCe3jWN2X
         BY5RZK+SxAbmkRjF+fmiqKcqGbL9A73tzuaeb/c0skZVefiGrSuABZ58JgEGwU7SQtLX
         H9VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788194277; x=1788799077;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=x77j6vdZ8LqsWXipiJe0J8DOL7X4B8I6QMSB+YfLeSc=;
        b=EezeCixNySfuT1xVpDW3Ie2OVXOn+QZOgHyr+lbgUewbDHrBCh2HJU2UboZC+ez3FB
         6TOxp6ObQ3SBkCgLrWWxJ5zGMpFP349FExmW4EvrQ8HzcjfWRNEguItxMWDpRfStvBij
         OUg+pfu8CSGTaV+IFkgGVbUAHZmlQ9gH7jDGX1dLNtorRCzQYODO28oP4TR+edmJPlNn
         +4ZYw1OAXeToonxuAyCzPFodg7AGb3kHAyRatDmf0FQ/Pbsv9+EfR2uBHAHdMb5rZQ5I
         jQ/m0nex9Yy3mGQF/Qh81Ki6U5HOquMf+lZG0XXF8qswIbf0gprXQqtzgy4+zZMryAVA
         7w6Q==
X-Forwarded-Encrypted: i=1; AHgh+RpRRtll9feu07MjAuAy1XjdtBGjZ/jJrG2FljtBr6fbiC0IuhyRLfGg81wWgAUxnWa2e5HFz1qgsw==@kvack.org
X-Gm-Message-State: AFuF++mIp0npK2hSXRupg+QoznH8396h3c9Ke+k47jpTEqGcMvyQTNu7
	MsAUS/4eZMOMCqwyNT+Zo0/vEp/g/SApZba2im2SqRorFxULI9nW645P
X-Gm-Gg: AYBFou1OKHvfnkXeRHc+omtDa20/mGD/r4ikLTUdcMqUT7VKCkJ483pic++7xgsSVvL
	PQk1fnWC0Kjk2nkM+dw+83qfO69L03/AMuo1hwgb6d75oZoz3ZzgMtFFjhcPVveTeo4G1xWQnHb
	Uyrbxno3+UzOxcjkxS+Gkl2z7ovsKhpA9VOU/F2q6aNOF8qnrQudnh6fmr3O8hLDm6pOVQpiE1r
	WurXqSlIWC15J9LHoB8nfTgE3rX9vDn13SODB65OYVOPWWrS2j1JJ3XQqvadcG+qp/ib5SEelij
	fizzbd8uGDu82i+l4+L9JOGnAs72uDByT3stJhIm4v8gbJ/eBOpUHMm1kpH/2ZyDYicPiZwHm8L
	jULmvWaRNEwG3ylhQPLLwbptxTibgb6zmWZ6n2wHvHO2nWeRFYAlLyu1t6s7fSW4xwq+mEk/lb7
	3PnrjGdNySXueovWSpx7Qq+IuI4QnOwnWJpl00IslTWa8sweLhdlogRGFy2WsgHBclzenkiJkg7
	4K0gRpJ64ByTHvSfVw5
X-Received: by 2002:a05:6870:3313:b0:448:3eb2:8c8c with SMTP id 586e51a60fabf-46835d7d79fmr26983191fac.6.1788194276047;
        Mon, 31 Aug 2026 09:37:56 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:2c::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-468a545dfe6sm11149786fac.14.2026.08.31.09.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 09:37:55 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org
Cc: roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	dev@lankhorst.se,
	mripard@kernel.org,
	nat@pixelcluster.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	osalvador@suse.de,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	kernel-team@meta.com
Subject: [PATCH v5 2/7] mm/page_counter: report the number of pages charged
Date: Mon, 31 Aug 2026 09:37:46 -0700
Message-ID: <20260831163752.2193337-3-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
References: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CCE8F180013
X-Stat-Signature: aocxp7j7kyqm3wyxeozn71c9q9uep3n4
X-Rspam-User: 
X-HE-Tag: 1788194277-350690
X-HE-Meta: U2FsdGVkX18yqdvAPJu2Tdx3jcG6lRYjNmWKnw7s3CoHOfooHKLa4Mf+3JSClT6S7uzebuMj0trdWG4Ya1/7AHpJXYrjZ/7RIkNKn9k7JUMwjIOFS8vfMy7eqm0lAgG/brkdA4umMRt+XuQqSw156egXXxci9vsH8k5y+T1TeObyPbYrwpcwZ6el24sGtErN4grN79A42bbo/n9+UMcQN+dRK003Ti7L1KHG4d7EcZSwVEDkfRu2Fy6+/it31KuhOPITlHsynKt4ll3Ga84bjamzsoIkOUjJOF4+r2Ui1PCTYpysfNuGJFyc9ixl+hTwN/J1DSkomI+Ca+FIrz3K0qIRYSnUp5RFB6sNuasCuExGInWEBuhU/7LLeWhBlgvNiLUkxRBJ6iXM3/vw3xS0OwT97P2qCQzSsXucWcTUxXUppjKTih39OC/qmdQQX05gjyROzGIDcfQEUBTUGnDa+6NScgu3lN/8G005Ckm4kC+BJVSjvXESN41pqmaKgcxdgSf4o9A6D6M8CoCDWbqTBy5nCYLPoSiHuiE3E5dJX4hZulaqRd5Ka2O/b6jCzqPwZ83OXRTJOnjmyrekqxxykyDssSZorPUMFjuwDpIgYxZ0bNs0gSDA0nsCPdruZPRetVSX6iIZgp/tZSdoaGKJguc8qqDZSpCTtsjRoCeKXYy7CchwSOHKSt7Kdd+f5zmrZCesB9F8D/baaHsFl08+BxDIQ8Hk2mB+NSsV2GKuhoYy0fgREufkOG1eZG/MyAhlAuldq6UWvzMwMTU0dNw0XT9+gZnXhpyxTISnCuwaBZ2qlkTBdkLpi7WHiGWNyVuAOosjDDMiK+Eo6f6AbPb579e+wZshT2Yhdh366rLJ56yrgcQ8u4n+RypbF83btFY4YunW/JcF85hZGjQ1zlAZ0LKz5MyNpVOD1/eM82WTYeUtX9NCxIKit1XwVmm1pxN6AL/mvcBb9nvjbnWPCzl
 si/9t25f
 nEYGPMwi/GhOxHmjYQH3cuapW4OUtSQx7RVaxfnFvnTqyaHduDqpK79uDIAsJCplDioFbpPAicPwbaDJhb5A4yOTuc1yw5arf11s46pMhJ21TE2Jq83QtWc81+3XIeNZvuwCpOMfis2BI6ItdmOO4rAvqPAcHzQtqBqmp7BEsdbbnEmvgxwaNBrG/oZdeOKT3BMSwuw0ajHbl8Az6Cb+vM/3n7ewju2BFc/OyQrKg7CI2gMJ5JJ10Bu96+RQgjuupcMfWe2nmFFJhCRjNG5PY6z2OYf2zzjVwBSftgBehPbPgdAc3rvKrTsqiGVFRkjUPV7/QJ+TsKfzGh1K+XHVX+b6hXP70yDFG3XAcBGmmTsjCAyqWTzSrrOTnRlnqoUvcaQrhHwcLf1TLIt7Io2gsnfdb9qzJSvwj0wl5NsYDNoep0vJT2oG2I4KbvwmaDIt3Zkc83hFUysl5d/+NyMpQBLvuV+YnJ2f4B3P+DNnsha5xrUVygYKDcIZ+XjlLD6h+0tPQ3OgB4NDpJtSMb8r4mH7zq/y6Fg7LPGQnnQPTHz3x5xw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an optional @nr_charged parameter to page_counter_try_charge.
On success, it will be set to the number of pages actually charged to
the hierarchy. Today this number is always @nr_pages, so there is no
functional change.

Of the 6 callsites, only one user (try_charge_memcg) uses that
information. The number of charged pages is added to
current->memcg_nr_pages_over_high to indicate how many pages it charged
to the hierarchy while over high.

Today, try_charge_memcg requests "batch" from page_counter_try_charge
and adds that same amount to memcg_nr_pages_over_high on success, since
page_counter_try_charge's only source of charges is the hierarchy.
However, this invariant changes later in the series when stock is pushed
down from the memcg level to the page_counter level, and a page_counter
charge can be successful without growing the hierarchy size.

Plumb the new parameter to all callsites, passing NULL where the source
of charge does not matter to the caller, and passing &nr_charged in
try_charge_memcg to account the hierarchy size growth.

No functional change intended.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/page_counter.h |  4 ++--
 kernel/cgroup/dmem.c         |  2 +-
 mm/hugetlb_cgroup.c          |  2 +-
 mm/memcontrol-v1.c           |  2 +-
 mm/memcontrol.c              | 10 ++++++----
 mm/page_counter.c            | 10 ++++++++--
 6 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index d649b6bbbc871..89a083f16fbf7 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -71,8 +71,8 @@ static inline unsigned long page_counter_read(struct page_counter *counter)
 void page_counter_cancel(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_charge(struct page_counter *counter, unsigned long nr_pages);
 bool page_counter_try_charge(struct page_counter *counter,
-			     unsigned long nr_pages,
-			     struct page_counter **fail);
+			     unsigned long nr_pages, struct page_counter **fail,
+			     unsigned long *nr_charged);
 void page_counter_uncharge(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_set_min(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_set_low(struct page_counter *counter, unsigned long nr_pages);
diff --git a/kernel/cgroup/dmem.c b/kernel/cgroup/dmem.c
index 4683f3d680226..fbbbd0b09d290 100644
--- a/kernel/cgroup/dmem.c
+++ b/kernel/cgroup/dmem.c
@@ -736,7 +736,7 @@ int dmem_cgroup_try_charge(struct dmem_cgroup_region *region, u64 size,
 		goto err;
 	}
 
-	if (!page_counter_try_charge(&pool->cnt, size, &fail)) {
+	if (!page_counter_try_charge(&pool->cnt, size, &fail, NULL)) {
 		if (ret_limit_pool) {
 			*ret_limit_pool = container_of(fail, struct dmem_cgroup_pool_state, cnt);
 			css_get(&(*ret_limit_pool)->cs->css);
diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index ecb6e0b7819a0..6df4a69b0d529 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -274,7 +274,7 @@ static int __hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
 
 	if (!page_counter_try_charge(
 		    __hugetlb_cgroup_counter_from_cgroup(h_cg, idx, rsvd),
-		    nr_pages, &counter)) {
+		    nr_pages, &counter, NULL)) {
 		ret = -ENOMEM;
 		hugetlb_event(h_cg, idx, HUGETLB_MAX);
 		css_put(&h_cg->css);
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index bf2c7d53b01b1..cf514d1bd7c38 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -2194,7 +2194,7 @@ bool memcg1_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
 {
 	struct page_counter *fail;
 
-	if (page_counter_try_charge(&memcg->tcpmem, nr_pages, &fail)) {
+	if (page_counter_try_charge(&memcg->tcpmem, nr_pages, &fail, NULL)) {
 		memcg->tcpmem_pressure = 0;
 		return true;
 	}
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 93c2fa04da4fd..71410084fa7fc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2663,6 +2663,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	struct mem_cgroup *mem_over_limit;
 	struct page_counter *counter;
 	unsigned long nr_reclaimed;
+	unsigned long nr_charged = 0;
 	bool passed_oom = false;
 	unsigned int reclaim_options;
 	bool drained = false;
@@ -2680,13 +2681,14 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
 	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
 	if (do_memsw_account() &&
-	    !page_counter_try_charge(&memcg->memsw, batch, &counter)) {
+	    !page_counter_try_charge(&memcg->memsw, batch, &counter, NULL)) {
 		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
 		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
 		goto reclaim;
 	}
 
-	if (page_counter_try_charge(&memcg->memory, batch, &counter))
+	if (page_counter_try_charge(&memcg->memory, batch, &counter,
+				    &nr_charged))
 		goto done_restock;
 
 	if (do_memsw_account())
@@ -2847,7 +2849,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			 * and distribute reclaim work and delay penalties
 			 * based on how much each task is actually allocating.
 			 */
-			current->memcg_nr_pages_over_high += batch;
+			current->memcg_nr_pages_over_high += nr_charged;
 			set_notify_resume(current);
 			break;
 		}
@@ -5771,7 +5773,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 	rcu_read_unlock();
 
 	if (!mem_cgroup_is_root(memcg) &&
-	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
+	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter, NULL)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
 		mem_cgroup_private_id_put(memcg, nr_pages);
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 661e0f2a5127a..a934619cc7bf7 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -111,13 +111,15 @@ void page_counter_charge(struct page_counter *counter, unsigned long nr_pages)
  * @counter: counter
  * @nr_pages: number of pages to charge
  * @fail: points first counter to hit its limit, if any
+ * @nr_charged: optional; on success, set to the number of pages actually
+ *		charged to the hierarchy
  *
  * Returns %true on success, or %false and @fail if the counter or one
  * of its ancestors has hit its configured limit.
  */
 bool page_counter_try_charge(struct page_counter *counter,
-			     unsigned long nr_pages,
-			     struct page_counter **fail)
+			     unsigned long nr_pages, struct page_counter **fail,
+			     unsigned long *nr_charged)
 {
 	struct page_counter *c;
 	bool protection = track_protection(counter);
@@ -162,6 +164,10 @@ bool page_counter_try_charge(struct page_counter *counter,
 				WRITE_ONCE(c->watermark, new);
 		}
 	}
+
+	if (nr_charged)
+		*nr_charged = nr_pages;
+
 	return true;
 
 failed:
-- 
2.53.0-Meta


