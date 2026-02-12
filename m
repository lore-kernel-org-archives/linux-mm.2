Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2DCFECD6FE
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 00:37:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 106276B0092; Wed, 11 Feb 2026 19:37:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 011B16B0093; Wed, 11 Feb 2026 19:37:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E017C6B0095; Wed, 11 Feb 2026 19:37:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C39F46B0092
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 19:37:35 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8516AD6DFF
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 00:37:35 +0000 (UTC)
X-FDA: 84433941270.13.21ABB3F
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf30.hostedemail.com (Postfix) with ESMTP id C2E878000E
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 00:37:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bjs1xeZV;
	spf=pass (imf30.hostedemail.com: domain of 3zCCNaQsKCJUz193GA3NIC55DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3zCCNaQsKCJUz193GA3NIC55DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770856653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ertUY3NkBRFTSuB1WAHz0tc6nOs7Jytmk4LTXJXAt1E=;
	b=C79mwBgpUm8OwAC1glsbDasJBJg4fJCoa3VyLRAjUq04ambe/wKRaFHbS642qN5ab/Fp2R
	CYNJIKCgyNHfCnRF0txQsh63bXnOH5OXuIvkM/eCoSWy0hku8z2M6iRY5SOrrFe9LTj2hW
	on/PB+vnAe959/+jFvqjPRTvRrhgmv0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bjs1xeZV;
	spf=pass (imf30.hostedemail.com: domain of 3zCCNaQsKCJUz193GA3NIC55DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3zCCNaQsKCJUz193GA3NIC55DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770856653; a=rsa-sha256;
	cv=none;
	b=iaYgiVG+hyJgt+CgkambF8DZkwOL94RN2Ou/LRE7fVxpVdoOkUvS6xOZbirqzrYeWAK2e7
	Rf59jU/SvDjrjATVv9WehDCbRA5BqXPlKQq4r1E5A91uze5d6FOXYWSS9L27BbnGoyM8Ts
	D9R1n0JOlcvZyehUdq6k3OqZ/M3xQeA=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3562171b56dso5248037a91.2
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:37:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770856653; x=1771461453; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ertUY3NkBRFTSuB1WAHz0tc6nOs7Jytmk4LTXJXAt1E=;
        b=bjs1xeZVS4IpT8HeayEytovktg8BKx/51ioLQtmN+5Ulf3GftrX5ZB2Ta2mQmGQCZS
         pZ1JPqwkej5njybKpdcNzK26zDaBD4mdAa4HSzurqehwETZ2VxcTeen4U2MCXuMzC3pY
         0I/bxNquQpKHd9uYrsZTGpkmyQJQVs8oud25ASnRAXTthtCuLwLqFh+cI1blCfME+VDd
         wA+63Yrefiv9ppGQEDANucfg2DPiZfiWRKW7hlrWNPkvrJTPnOZ0yYVDT1RVAjWZr/B2
         /EKJ1mY/2KLiZIkd4xqNjXWcwR1DdO4A4MpIxQWPzAzkQsbmNn6AKgeB1RCu/oX/eR7p
         +KtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770856653; x=1771461453;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ertUY3NkBRFTSuB1WAHz0tc6nOs7Jytmk4LTXJXAt1E=;
        b=Zn+zfgUh/f/FVU2/qof+a2l6AhZEicpKnsr82CQqYtows7xn+ALpkNiWnyi/KsxSoZ
         ovg6n+NQDAcXGmA5R9TBMuLrJVqNfI0rWdkZZVbx1et2o6akuIfUcUBnUXYYKr5O+PhP
         ASpWSXfNdHI9UBa35sKjili38w4C4ttbNFW9mh5YgxWbbzJ5oa0BnAnH7FlZDC3d/jJI
         IAnepvyOcbdxvC11+BEWy0KzoPw+Pb7vQ67wqq0KKazbhtM/Nz3Naxma1WZQuEoulR+u
         ubAbw23GSaBSkxWs9az5O4EbqLKxJ3l2f+C4pABWVDLbATeOUbvlixbkVyMVfkvjq6DE
         eZGg==
X-Forwarded-Encrypted: i=1; AJvYcCUPTlhH2Yq43AFHl7NfzCwQuYgMf+QL+djbu58OM0Lj18CZyFls+J+vMcwT3VlQU3TKLHreM3ef1g==@kvack.org
X-Gm-Message-State: AOJu0Yz2L/FD6qwhQM7SmvHdhmwZLGJYssNYlYX8Duk+k0xKjSN/zxeg
	UXMS8vZPqRQi32z//LAm31dZ9/8FiJ0BXEXY/7VMaPDY00pcugXdFUhhIQudaNTwJ4uhSwC8LGM
	6FiX9F3NjaezE+tRhYvJ7xcBoeg==
X-Received: from pgax34.prod.google.com ([2002:a05:6a02:2e62:b0:c65:c5fc:1707])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:c702:b0:38e:9e77:c9e5 with SMTP id adf61e73a8af0-3944886d6f3mr806864637.72.1770856652565;
 Wed, 11 Feb 2026 16:37:32 -0800 (PST)
Date: Wed, 11 Feb 2026 16:37:15 -0800
In-Reply-To: <cover.1770854662.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1770854662.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.310.g728cabbaf7-goog
Message-ID: <24f2962dcbd369a2e01590aca0a365e5118778fe.1770854662.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 4/7] Revert "memcg/hugetlb: remove memcg hugetlb
 try-commit-cancel protocol"
From: Ackerley Tng <ackerleytng@google.com>
To: akpm@linux-foundation.org, dan.j.williams@intel.com, david@kernel.org, 
	fvdl@google.com, hannes@cmpxchg.org, jgg@nvidia.com, jiaqiyan@google.com, 
	jthoughton@google.com, kalyazin@amazon.com, mhocko@kernel.org, 
	michael.roth@amd.com, muchun.song@linux.dev, osalvador@suse.de, 
	pasha.tatashin@soleen.com, pbonzini@redhat.com, peterx@redhat.com, 
	pratyush@kernel.org, rick.p.edgecombe@intel.com, rientjes@google.com, 
	roman.gushchin@linux.dev, seanjc@google.com, shakeel.butt@linux.dev, 
	shivankg@amd.com, vannapurve@google.com, yan.y.zhao@intel.com
Cc: ackerleytng@google.com, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C2E878000E
X-Stat-Signature: i6a7e5p94ht4smq9qxhhfffx7cfbamwd
X-Rspam-User: 
X-HE-Tag: 1770856653-263147
X-HE-Meta: U2FsdGVkX185xgRDD1bmdtIRJCRDiUmPzeZfPr9PhNenqpbXjtLclhWnltGbN/wt/d2P8sX2vid+dhDeieOL+uUsp2EqKhq5aJJvuWzLkK1La5Baj/eybyvp20UluDoUIV3r+9r1K+MhyT78cCsbqdszqKYE5c/CTAbuaYPPKi8mJDU0+R4zTZmu/5GfhzHZGKjt/BPXhtLrQbg6Wn57DX+5MwIKAaHBVz/lELcFk2ktWbB+O/db9KX6yp0Pkv+lpf8AvNvp66M/8NMv+bRX660XBW/5qI8DtorAVEXyf+RDzXSKThF8bW5r9UY8blbJR2MpTV+lJJOnpZGCfYKNjA/lGmOYGw2RbkbOpaVb7LnlUmE/CcKP9GjhUiOVIwUP1WHdcLfpRiRsx5V7r+GLeLylwJ2QH6ZbzxWb4JK4hiVz/fv8Uzcypv1tr6h9kd+VYwDGCbXleBu3IhlYa3C419NtOYZ3pokzLyRRFEF0wOA60IhJJ6TrSLpPGLFg0K24GNdTEB4u+27yCWrTtTDh2+k/Om8NFSGTAvecJFBRAm7mdUpPaAcWs7Db1uvX+CFfF0NFeYTwRKpVTie244TkyvspdKMtxJjtF2hsJ94lw1lfsY0zGPgJnfyZty+xwEazZYu497iCVuHskYTuBqzv/ZQY/KeD8YE4gMKkpKM0mpyCgsJp3SpN487E8wePPloGf4apI72XGtPpw9/kx3Ki936mEZl7tmKDB72+WZMdH7k9Klw4sxS0vcToLAp6Z70At7ERYNywf7kG+YG45dCgczeavJ9gTf1h3E+RmBsLM6o9KoqCw/8gyH8dXEacoFY3VPXTp2YBQNx55H8E2t7N/B21MBIEiat3F3yoRmKA+fym44i4APgkBWXxV+9QP9OQ8yOuRqm4OztkWlJHj8SAv15cNPcKWWljUUZqmcitWonImdzZksr64sYbpFPaQ+UhwOPRKFd4YuyEiJMDYab
 WQcvdlrf
 dLuqkVsooENWjmJNmLpj2p6OOKkxIaoXoMrGdaTb3vQtufkC6JPM4+W4dIvxukdAgoZ/VF7ctsJoAy/2ErRB56B3zO7DS6HR+Oy2SM01EgHqO+m1xhRLZiSyKsbDCPZXOtKa0rHDi+ls2lLYHunw+pPuNwQ6YfLqK5PoGFmxKW3taFSsXuUmIq1a6Wx/Ey47hQUPOc6mTgELqbT7xCAY/h2UF+gKErJetjB/sdknhnTzJG/A8gXKs/86YEURKZfhwOswtrRlDILXie7+vPWTZPopX1kAsNikCHt0CJHXKygAKAzpQa1qzs/g+Q6UDhYwnqMGE1/KPyTICOMrjHuatoAd6Ga/pR+dPvAyEG1aqz3astHodDI+qIR5y6ag5mzt3sV1PdlwGsjrmsVW13CTM66Iy+BeWAjlVdf61JdOlbk4RxaN0NxUY2E0fV87GkuqIzpRnwvrpVUhj6vWdCW16GcRu+zdIqtw0A/m2+PyGNVc8aPtNyjwoH5kB8cGHRZMiG+xVwBt9Le44Y6IYd4WQ8lalC2Ggwt59OO0jCCFBt/Y8hs1GkV0et1wttWTXRrbJKFcXlsPKhWVFjnMSSFKvjjEw1mJ3Ja/fuvUsYrqsuSIzblUW8TCict4WTXKk/LlJRe/S0wls+lAckrN1K1QzywZoEyfHPZj5g8un
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This reverts commit 1d8f136a421f26747e58c01281cba5bffae8d289.

Restore try-commit-cancel protocol for memory charging for HugeTLB, to be
used in later patches.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/memcontrol.h | 22 +++++++++++++
 mm/memcontrol.c            | 65 ++++++++++++++++++++++++++++++++++++--
 2 files changed, 84 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index f29d4969c0c36..59eab4caa01fa 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -639,6 +639,8 @@ static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
 		page_counter_read(&memcg->memory);
 }
 
+void mem_cgroup_commit_charge(struct folio *folio, struct mem_cgroup *memcg);
+
 int __mem_cgroup_charge(struct folio *folio, struct mm_struct *mm, gfp_t gfp);
 
 /**
@@ -663,6 +665,9 @@ static inline int mem_cgroup_charge(struct folio *folio, struct mm_struct *mm,
 	return __mem_cgroup_charge(folio, mm, gfp);
 }
 
+int mem_cgroup_hugetlb_try_charge(struct mem_cgroup *memcg, gfp_t gfp,
+		long nr_pages);
+
 int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp);
 
 int mem_cgroup_swapin_charge_folio(struct folio *folio, struct mm_struct *mm,
@@ -691,6 +696,7 @@ static inline void mem_cgroup_uncharge_folios(struct folio_batch *folios)
 	__mem_cgroup_uncharge_folios(folios);
 }
 
+void mem_cgroup_cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages);
 void mem_cgroup_replace_folio(struct folio *old, struct folio *new);
 void mem_cgroup_migrate(struct folio *old, struct folio *new);
 
@@ -1135,12 +1141,23 @@ static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
 	return false;
 }
 
+static inline void mem_cgroup_commit_charge(struct folio *folio,
+		struct mem_cgroup *memcg)
+{
+}
+
 static inline int mem_cgroup_charge(struct folio *folio,
 		struct mm_struct *mm, gfp_t gfp)
 {
 	return 0;
 }
 
+static inline int mem_cgroup_hugetlb_try_charge(struct mem_cgroup *memcg,
+		gfp_t gfp, long nr_pages)
+{
+	return 0;
+}
+
 static inline int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp)
 {
         return 0;
@@ -1160,6 +1177,11 @@ static inline void mem_cgroup_uncharge_folios(struct folio_batch *folios)
 {
 }
 
+static inline void mem_cgroup_cancel_charge(struct mem_cgroup *memcg,
+		unsigned int nr_pages)
+{
+}
+
 static inline void mem_cgroup_replace_folio(struct folio *old,
 		struct folio *new)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 36ab9897b61b2..70d762ba465b1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2561,6 +2561,21 @@ static inline int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	return try_charge_memcg(memcg, gfp_mask, nr_pages);
 }
 
+/**
+ * mem_cgroup_cancel_charge() - cancel an uncommitted try_charge() call.
+ * @memcg: memcg previously charged.
+ * @nr_pages: number of pages previously charged.
+ */
+void mem_cgroup_cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages)
+{
+	if (mem_cgroup_is_root(memcg))
+		return;
+
+	page_counter_uncharge(&memcg->memory, nr_pages);
+	if (do_memsw_account())
+		page_counter_uncharge(&memcg->memsw, nr_pages);
+}
+
 static void commit_charge(struct folio *folio, struct mem_cgroup *memcg)
 {
 	VM_BUG_ON_FOLIO(folio_memcg_charged(folio), folio);
@@ -2574,6 +2589,18 @@ static void commit_charge(struct folio *folio, struct mem_cgroup *memcg)
 	folio->memcg_data = (unsigned long)memcg;
 }
 
+/**
+ * mem_cgroup_commit_charge - commit a previously successful try_charge().
+ * @folio: folio to commit the charge to.
+ * @memcg: memcg previously charged.
+ */
+void mem_cgroup_commit_charge(struct folio *folio, struct mem_cgroup *memcg)
+{
+	css_get(&memcg->css);
+	commit_charge(folio, memcg);
+	memcg1_commit_charge(folio, memcg);
+}
+
 #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
 static inline void account_slab_nmi_safe(struct mem_cgroup *memcg,
 					 struct pglist_data *pgdat,
@@ -4777,9 +4804,7 @@ static int charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
 	if (ret)
 		goto out;
 
-	css_get(&memcg->css);
-	commit_charge(folio, memcg);
-	memcg1_commit_charge(folio, memcg);
+	mem_cgroup_commit_charge(folio, memcg);
 out:
 	return ret;
 }
@@ -4796,6 +4821,40 @@ int __mem_cgroup_charge(struct folio *folio, struct mm_struct *mm, gfp_t gfp)
 	return ret;
 }
 
+/**
+ * mem_cgroup_hugetlb_try_charge - try to charge the memcg for a hugetlb folio
+ * @memcg: memcg to charge.
+ * @gfp: reclaim mode.
+ * @nr_pages: number of pages to charge.
+ *
+ * This function is called when allocating a huge page folio to determine if
+ * the memcg has the capacity for it. It does not commit the charge yet,
+ * as the hugetlb folio itself has not been obtained from the hugetlb pool.
+ *
+ * Once we have obtained the hugetlb folio, we can call
+ * mem_cgroup_commit_charge() to commit the charge. If we fail to obtain the
+ * folio, we should instead call mem_cgroup_cancel_charge() to undo the effect
+ * of try_charge().
+ *
+ * Returns 0 on success. Otherwise, an error code is returned.
+ */
+int mem_cgroup_hugetlb_try_charge(struct mem_cgroup *memcg, gfp_t gfp,
+			long nr_pages)
+{
+	/*
+	 * If hugetlb memcg charging is not enabled, do not fail hugetlb allocation,
+	 * but do not attempt to commit charge later (or cancel on error) either.
+	 */
+	if (mem_cgroup_disabled() || !memcg ||
+		!cgroup_subsys_on_dfl(memory_cgrp_subsys) || !memcg_accounts_hugetlb())
+		return -EOPNOTSUPP;
+
+	if (try_charge(memcg, gfp, nr_pages))
+		return -ENOMEM;
+
+	return 0;
+}
+
 /**
  * mem_cgroup_charge_hugetlb - charge the memcg for a hugetlb folio
  * @folio: folio being charged
-- 
2.53.0.310.g728cabbaf7-goog


