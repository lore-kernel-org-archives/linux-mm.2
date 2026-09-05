Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82AC9C79F8C
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 03:05:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0C6B6B008A; Fri,  4 Sep 2026 23:05:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABD376B008C; Fri,  4 Sep 2026 23:05:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D3B26B0092; Fri,  4 Sep 2026 23:05:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7677C6B008A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 23:05:42 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B72DB12023B
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 03:05:41 +0000 (UTC)
X-FDA: 85178218482.29.6DE251F
Received: from mta0.migadu.com (out-141.mta0.migadu.com [91.218.175.141])
	by imf25.hostedemail.com (Postfix) with ESMTP id 95102A0006
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 03:05:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M+GhIc21;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.141 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788577540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UCkFJl1V7po7jEQMqcDFWIxwWJ7AzOt6F8QpFPscd3c=;
	b=XYxtogcHXRz6mWAYlHgqOTwRNschSIKk9DdoBYjgitw98+J7CulLn0j/3/f4+jADvn+mwN
	+Cv9agWivhVXXToKuChzsjx03HzBiP/lHJz3MMiKOhu8/Y7UmJrMNQKlOZoym0wUsmWjJ8
	4cr/rchN9u4eWB0JDrQOjYAbdT+z0Ns=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M+GhIc21;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.141 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788577540;
	b=8AeO0QUBocyL8w+oScAkw/4REYyDO0eL8oolPB2n2nUeVXICw3AgQEjRiAvPC2KJuu6faT
	LEgHwmZuCJsXIS2a4F5C7NMJk5P54RM+1qvBVLVmo6ZSLw4o8ueP7R7xxweH0kiszSq+td
	fjDMiFmC/hrqRRKUKBe7NY/U3wPsYTY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1J3PUA095spFjhU5SX/VP0Vy7DB3E7cHPPmCEK6BDk8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788577536; v=1; x=1789182336;
 b=M+GhIc215tZSbUe72sTTT6oxkN2KRhTDUPngcGvnFRG7FrHdA3alBMY+lGRpA0BTiDKedvBQ
 uZ1h3wULe9ab2O1Db4v6y2z9aQ2WfuHHjGmnbAakjk0AFoqTcfq/pUqe0kaSRixLTFCqLf1UNAz
 xMq2sA2WNOa2/U1BjJm98lk8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6cd579c380cbde10;
	Sat, 05 Sep 2026 03:05:36 +0000
X-Mizu-Trace-ID: 6cd579c380cbde10
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] memcg: split mem_cgroup_private_id into two fields
Date: Fri,  4 Sep 2026 20:05:18 -0700
Message-ID: <20260905030522.1887837-3-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260905030522.1887837-1-shakeel.butt@linux.dev>
References: <20260905030522.1887837-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jqeuuqxfma1ghgcr5136qhwr5hwj74xz
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 95102A0006
X-Rspam-User: 
X-HE-Tag: 1788577539-599262
X-HE-Meta: U2FsdGVkX1/nAPgnCEk1v+Cv2GhWOEotscMOmezdmjiXzvzd9hKRj77uS4gy0FU/u2CXHvhKr8zWQpSAQXKdbnT0NRqeUqMClBq0b/E0BF1Gt3jEBdjPzf64qu+IXnfEkE/16KHy+HaVKJnkv5MgRyGAcdsuD3SzHrkNRN1OMrOyqEMo/lugHtmtZfibslkLQs7wsYuMRZlcZXAri9z3kZGRrAClvlc4wHM0YUKDlX3C4lJkLG31v7GTUw3HV9whwWtt9lfMVPGukWFYgEEqZTzxcBqOrA0PQ1yxGX6pXc7BXV/6imhfK4g4n6df1if+o30dVzvDRXG0keklrpHs2pDsBaL5xXaaAeMDRnusNssHbqiacEeL2BYbyrGHGQ0JGD0fsacxVQ/jfDAMc4RBUkLnmM2YAnnJKqjcQzXH6OsaFNouJzPmo3IjE7KwR6gaptwLE5KW0UHh456lZglQRyL67DyTsgCL4qDjk+RGaOUdZgd8YvdwTduKWUw/WpQf0ebLvCjBjQuAhIMzG2IT1FBsobKBtw0fiKL2Sg4HFUqgcOsKhz9iM0Rd0zuXnXCpUiNJncz6KRtMyCUAOowzzy7OibEDaBfrvTpUx/PHn8Noy+0BcrUAh0oJ8hcZLEMN5sJZ555y+6INPAPMrt6D/zrQJ6YtDY9KhtKpl7g3d5uDjvgerA1rEhxZRXZwm+3GfTrQBUKWrEhtq56PmE62yZ//GlxML77CMboPXoME52v9baRLSVo1ES/abhypt/rnfSDSFQtxbHxOvH00HrU/RjCKjkAuYCRLawZfzQ1kBUzVn2vbwbT0ywSJHed+PZ+S6nytErEra5K/QBrC/PrTPMiskC8wJrrI8uw95FaIcEm5wJ7h68+PXeaz6eBIyVDEQZIXeIOUlaLHQP3lo1w9yb1xUcbQkRv0fcpqHZVeAQwrUPxhRWZBH6lBkzWtCS6s680OFMUNBhHJtyuSckC
 KqJAsEhF
 K3jEPl0LfqJJiji05UupnWeGFPt34HRi2xJYgXfQTgsJmlNPsUZUeBrL7oF1C2qLzGhh7NlrTEY3QZU55D10ZIwxnSBHRlggXlP3rEbxxdTkRtlydPrIet9toCarAxzhfV4pGj5/GlinFKPOMLqoh0v+BCpI9yufti3QM2IkzRElENxwsOzYzlof7BDX2mrLKDDidZfumxgd8JF9Na7bE251LBVlNkMDfKfGeDmRjcyGy6Hcjk3im747wjas8ZoH2eAEbrsg6holLcdCHQtxvMYsw1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The two members of struct mem_cgroup_private_id have different access
patterns. The id is read on every eviction and refault through
mem_cgroup_private_id(), and is only written when the memcg is created
and destroyed. The ref is written on every swap charge and uncharge.

Split them into private_id and private_id_ref so a later patch can put
them into different cache line groups. A struct member cannot be split
across two groups.

No functional change.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 10 +++-------
 mm/memcontrol.c            | 18 +++++++++---------
 2 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index ac575fcc5f1e..46fc99786ebd 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -66,11 +66,6 @@ struct mem_cgroup_reclaim_cookie {
 
 #define MEM_CGROUP_ID_SHIFT	16
 
-struct mem_cgroup_private_id {
-	int id;
-	refcount_t ref;
-};
-
 struct memcg_vmstats_percpu;
 struct memcg1_events_percpu;
 struct memcg_vmstats;
@@ -189,7 +184,8 @@ struct mem_cgroup {
 	struct cgroup_subsys_state css;
 
 	/* Private memcg ID. Used to ID objects that outlive the cgroup */
-	struct mem_cgroup_private_id id;
+	int private_id;
+	refcount_t private_id_ref;
 
 	/* Accounted resources */
 	struct page_counter memory;		/* Both v1 & v2 */
@@ -811,7 +807,7 @@ static inline unsigned short mem_cgroup_private_id(struct mem_cgroup *memcg)
 	if (mem_cgroup_disabled())
 		return 0;
 
-	return memcg->id.id;
+	return memcg->private_id;
 }
 struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id);
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9a65d7148c22..c42297ae3b0e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3797,7 +3797,7 @@ static void memcg_online_kmem(struct mem_cgroup *memcg)
 
 	static_branch_enable(&memcg_kmem_online_key);
 
-	memcg->kmemcg_id = memcg->id.id;
+	memcg->kmemcg_id = memcg->private_id;
 }
 
 static void memcg_offline_kmem(struct mem_cgroup *memcg)
@@ -4056,15 +4056,15 @@ static DEFINE_XARRAY_ALLOC1(mem_cgroup_private_ids);
 
 static void mem_cgroup_private_id_remove(struct mem_cgroup *memcg)
 {
-	if (memcg->id.id > 0) {
-		xa_erase(&mem_cgroup_private_ids, memcg->id.id);
-		memcg->id.id = 0;
+	if (memcg->private_id > 0) {
+		xa_erase(&mem_cgroup_private_ids, memcg->private_id);
+		memcg->private_id = 0;
 	}
 }
 
 static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
 {
-	if (refcount_sub_and_test(n, &memcg->id.ref)) {
+	if (refcount_sub_and_test(n, &memcg->private_id_ref)) {
 		mem_cgroup_private_id_remove(memcg);
 
 		/* Memcg ID pins CSS */
@@ -4074,7 +4074,7 @@ static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned
 
 struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, unsigned int n)
 {
-	while (!refcount_add_not_zero(n, &memcg->id.ref)) {
+	while (!refcount_add_not_zero(n, &memcg->private_id_ref)) {
 		/*
 		 * The root cgroup cannot be destroyed, so it's refcount must
 		 * always be >= 1.
@@ -4198,7 +4198,7 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	if (!memcg)
 		return ERR_PTR(-ENOMEM);
 
-	error = xa_alloc(&mem_cgroup_private_ids, &memcg->id.id, NULL,
+	error = xa_alloc(&mem_cgroup_private_ids, &memcg->private_id, NULL,
 			 XA_LIMIT(1, MEM_CGROUP_ID_MAX), GFP_KERNEL);
 	if (error)
 		goto fail;
@@ -4345,7 +4345,7 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	lru_gen_online_memcg(memcg);
 
 	/* Online state pins memcg ID, memcg ID pins CSS */
-	refcount_set(&memcg->id.ref, 1);
+	refcount_set(&memcg->private_id_ref, 1);
 	css_get(css);
 
 	/*
@@ -4358,7 +4358,7 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	 * publish it here at the end of onlining. This matches the
 	 * regular ID destruction during offlining.
 	 */
-	xa_store(&mem_cgroup_private_ids, memcg->id.id, memcg, GFP_KERNEL);
+	xa_store(&mem_cgroup_private_ids, memcg->private_id, memcg, GFP_KERNEL);
 
 	return 0;
 free_objcg:
-- 
2.53.0-Meta


