Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4605ACCA464
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 18:25:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66B756B0092; Thu, 15 Oct 2026 14:25:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 643AC6B00B4; Thu, 15 Oct 2026 14:25:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55B1D6B00C1; Thu, 15 Oct 2026 14:25:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2F5C86B0092
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:25:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BCDD31A018B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:25:38 +0000 (UTC)
X-FDA: 85325688756.09.1CC289A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id BED8E16000B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:25:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eMg02pV0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792088736;
	b=2lSLPO7kieLag1+WXvXNqzxYe7xfQkqvSbTeOyVf4+K8iU4bA6fBVnmABMqFdRLHNQC/lE
	dgUPNOLfyeYJ3wnNchZo/lbxnp5loIOYvxKDuK+8V+X6loYeyvslrx2NEGMQhSusTMeglm
	dsKd8+K2WlnFNvHXLbVWoy+8Cp/ozCg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eMg02pV0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792088736;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NN/t3NPtCPIlMkq9teF5APhaxlBKOvS1hDeMY40hhzQ=;
	b=gVNJrV1sEi61gcsDoEBXIOAE/pgIU8KzgxH/f78eQNBmvButnK1A4r2jbl9n7FYJUmpHlR
	3vd8kPSC45mQLKU/wQvz0i/5XCtTITziO2GCJCYinM8ilBFVdsSws6asNmrsB+Z1fDrAFq
	6iJYG89eFqTXLqmrwbRgy4s1uzvKhCw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BA18E447C9;
	Thu, 15 Oct 2026 18:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 545AAC2BD04;
	Thu, 15 Oct 2026 18:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792088155;
	bh=Tgv6BaPO00+S97jAlKTn6xh90zKsXielMTf93zwSMVo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=eMg02pV0j2JCWPb5cuVkzKt2xEl4QphaZGbfI/lXaJw8KGG5JF9kkE4cie2WNKuB2
	 ofMM9t9xZVswRKoTmAlE5gSYjt/feGOAMlzk4KWDxJm3/LFKPMlF0qrNNB4RIGpdGy
	 +lrd35d8Yp9f03o1mV4dfGhXNBNHkC3wwkVlYJfzL1TWuU2PipcDsrI20lzokMVou1
	 OcvvHleFUSgFEjXRvr5kLNcPYQAp9RRUmxfkEe7dEPBxsiwZhIh3VzvrbL+9uN7nYH
	 oPMQlItj9qAkIBXzJpvArrW+JkSsIQ440+7kvd+N8beNa4W0v/MgHAftlWM5C+6/bM
	 t1Q5JjM/s9WpA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36382CCA467;
	Thu, 15 Oct 2026 18:15:55 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 16 Oct 2026 02:15:52 +0800
Subject: [PATCH v4 03/17] mm/memcg: add folio-based lruvec live helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mglru-fg-v4-3-2106750c0bfa@tencent.com>
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
In-Reply-To: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
To: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, 
 SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
 Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
 Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
 Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 damon@lists.linux.dev, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792088152; l=2034;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=bqSj6GEUFE1ch4tTEQEPZOkssBWYsWV/WhQc/GCJ0Bs=;
 b=ade8dgVk/QLtMdvzfHEj3EebA82ilil4wqag8aQYk8TBs2jVnr7PYCpkRECMbBvrjTfV5YSLN
 PEO3hnbVTjMAeyNrCoshcrvmZa1ho7dU4F2NiVCiQv+mbLQ0DEfSQ5d
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: ckkhmcmap951a1tw1ppbxfraky4mqtnd
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BED8E16000B
X-HE-Tag: 1792088736-636850
X-HE-Meta: U2FsdGVkX1+S2lgnMOJySKK2W7VWPzG4qREO/txXL5oZM9IkmZlAjbV/kBPHtyKxlyOe04DAH5AwcgNc86DIFp3Dy+JYvPVg5DyPrZMUszrw6agkDkgpsZXBpfVm8Cv7RD82t34Ydn4ttkwr/RNRZb7/4cBaRG84l2zbB8Sgi1FdsqwJ0MyM1rBP4OT/7v9scS2BmbvVRMeC6AB2sc0SsX84MejB8h1E9HSxm9qBLq4JPhDCcnU5dLQoeFqMGkkkGiOM3NNP0c4jYPYxfvTMxp5yt3baYS5e+uPPTt8Mjj6f7XBs0HqSFw+xUFZMbAjrm7jBlwVMDyy0LY9zQg6xYQTsJojZY2e8CXQeAPc6VB7wnlA6lZN+Bc4tJOS+BZgO/Z9e2lyZPpiQ/N2Zh8guUUbsodYqfqe3uABZ6h2PNEwSUPV/QC7yB0fkp8AIFQNSk0yhLVWgWCuGPnRCqx9+F+H0cJTXiFZaaTRPbCotZ6LLcpwEyY0CGZhzABmfZ6+znJNWaehyQqUg7O7KRGQPv7dUVV+IcJvuQFKeXuuXw7lV//+XZlcThlXR1o0m5Uxb2Hfu84gehrHRUaTghP12x9y3kW0AKmeniyQIMhZxH39Fdszgjw3iCawPTQXP4gKT9Rgbg0nLuyto5ie4/0TjDukkl832l8PmIJEPY5cF73vheVv9yXGalPqetGDpVzgXVWFr9EPpLFqA+gWfcNQpERL17vAlrjgsI2ocFzJO8q+RZMj2tWJADgluICZbMaabkJ/UXl5GgFTBmy6B6KqbRrf3iDNBa47DxbwrFyl4dXnhF2KQjOxa1wlkoyaG8MzRAjKWQzWQBzvBIjlfuA8/LDLVOk833bpyKV6ZpD+mnD8I7qz2iDuXPukYEPAwDnsFMikmXuvFlh9vAgyEeRKV9Rh4kUfG7qeagNL6iL1J3Ykzrtkx31DPytViiGmWEdqBIuwVBPKqHsM7AzHpFMn
 jB0HthqZ
 er+JC2AHFpvyJbVb/WRHWoD3Z9FbhOYn00H1Ro1waSwUAxL8kQ9WpCxNTjCN1gBMZYNJ/zUPv3QdhPy+GaV/q1t9aB47oAQga3TrXcNsp+E7pN+k/2omYMqJR89v0OI0yKUDZfa0NmmNfVx/p19p2hMPJV8dt3xzxQjGr2GKADNdtpBNvJNCm/dOemypOtKTrf0qu74+uFW2Ey5FlTeGH0HsGOidpG4drmOqWvn+x13r3/o7nbWpUBFRFEYCAiFH8BOJH12zE1Oa/hW/6L7N5ApYttb47oeNplhGEMlPYHCFLzCXhdwZ9Hmx0vG5mJVRePCfgq/2bSis8zOGF4HAjXOra/pXhoF6R/W9QJkC/702ZDqwqJ6pFm7fu3gEtNsz3PP0T9GPm18skKsD7/p8MarTlp22OePxcRyxLHJGagvQsVCApktnZJsksimTZOi00AJNxc/6piOJeuK/sqrHZSnAOfeWv3r/gcGVzFligF26h+PBXSBL5WcuCzcgyAvNwmnr4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Add a helper that resolves a stable lruvec for a folio under RCU
without taking the lruvec lock.  It takes a folio directly so the
lruvec lookup happens inside the RCU read-side critical section,
which a lruvec-based interface cannot guarantee.

No functional change.

Tested-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/memcontrol.h | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 74110a324f9e..829ab776ab44 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1535,6 +1535,45 @@ static inline void lruvec_lock_irq(struct lruvec *lruvec)
 	spin_lock_irq(&lruvec->lru_lock);
 }
 
+/**
+ * folio_lruvec_live_get - get a live lruvec for a folio under RCU
+ * @folio: the folio
+ *
+ * Computes @folio's lruvec and walks up to the nearest live ancestor
+ * if the folio's memcg is dying.  Paired with folio_lruvec_live_put().
+ * The result may be stale: RCU keeps it alive but does not pin @folio
+ * to it.  That is fine as the counters are fixed up on reparenting.
+ *
+ * Return: the live lruvec, with rcu_read_lock held.
+ */
+static inline struct lruvec *folio_lruvec_live_get(struct folio *folio)
+{
+#ifdef CONFIG_MEMCG
+	struct lruvec *lruvec;
+	struct pglist_data *pgdat;
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	lruvec = folio_lruvec(folio);
+	pgdat = lruvec_pgdat(lruvec);
+	memcg = lruvec_memcg(lruvec);
+	while (unlikely(memcg && css_is_dying(&memcg->css))) {
+		memcg = parent_mem_cgroup(memcg);
+		lruvec = mem_cgroup_lruvec(memcg, pgdat);
+	}
+	return lruvec;
+#else
+	return folio_lruvec(folio);
+#endif
+}
+
+static inline void folio_lruvec_live_put(struct lruvec *lruvec)
+{
+#ifdef CONFIG_MEMCG
+	rcu_read_unlock();
+#endif
+}
+
 static inline struct lruvec *lruvec_live_lock_irq(struct lruvec *lruvec)
 {
 #ifdef CONFIG_MEMCG

-- 
2.56.0



