Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB1B0CD484E
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 20:30:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DED76B0092; Mon, 11 May 2026 16:30:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B65E6B00CA; Mon, 11 May 2026 16:30:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F3386B00CB; Mon, 11 May 2026 16:30:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E1286B0092
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:30:29 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C1E811402AE
	for <linux-mm@kvack.org>; Mon, 11 May 2026 20:30:28 +0000 (UTC)
X-FDA: 84756281736.07.13CDE42
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
	by imf11.hostedemail.com (Postfix) with ESMTP id C15A740009
	for <linux-mm@kvack.org>; Mon, 11 May 2026 20:30:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.198 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778531427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5PJXHDNJFy7lWB46ZPv47nvFsQK8oFjhVWJg6vwWu4E=;
	b=xMZyc3L8r5YoHfDwMILQPidpu5KaTAq+8GTWBDGyiysM44BoSIdkml5UKcZLH40zOZXYlo
	IQ4nQ/A/1uOo7RNOYXs37LmmWm4RdWBd6pEj79rDHnWGzMxVlx6Z5pmSMDDSvyNRxZYSHp
	Aeb5MRpbcaQLJsPCI8htCWKt/tNoAFI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778531427; a=rsa-sha256;
	cv=none;
	b=VhFQGXjMJJMrBJUnxlBFj7ibR1XgPPl72oU1Wn7TiTGfru7Hr9UrRLH2uiUv0Nzt1gB9s1
	RjNjdlEiqRyU6kR2CQxodCWHwBiqmLedZoF9XPeRKZwjYp1Wk/aikqjQOBC4hY5lnaZGdk
	5OhejSfGO+yH+bxHryWxyEUu5+vhhGM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.198 as permitted sender) smtp.mailfrom=alex@ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 5FD5D3ED2B;
	Mon, 11 May 2026 20:30:21 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH 8/8] mm: zswap: per-node kmem accounting for zswap/zsmalloc
Date: Mon, 11 May 2026 22:20:43 +0200
Message-ID: <20260511202136.330358-9-alex@ghiti.fr>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260511202136.330358-1-alex@ghiti.fr>
References: <20260511202136.330358-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTEy/cPNEbIyKrA/MitPZ5mKJRYC7nugubgDZQLwxnW3NtraSF5cXcbucibxUEBAotu/5jA1kLeArlpAogW+GpNJjlA4w7QhN/lDeSHlX/Qt+YqfWaw9ykhvJM8lt9hdo+KGSa3ccimd6/Kvq+tL15sdDHSfkmskxsDwrEYKu+l9AqGPE3dpM+cbmvO2vqWtd1u1ufLrqqOjN3r9L31WsWPWcBrGNG6kL/c40kf4ChjHAF+7vC+CNmupNLCagakrkdFm8c03q2Lybo5Oyu0FDYAsKvV8ZK0sd5GzHXto28BE6BHQl6FYyXYyPmqkM8PtnN68vFHb7/uWt4sG+sfew8sak61TG91ooJfwp+9kVzzzE1D31WVUhLhGPRo6QOVJVrlCpXv2pHKs2yyy6GN+kNsfhxtCRVL665NQ0h9pLundbYcUhgU9xzoVJMhum8zT21UPCCP/TfS7hyvToiO9t+aL8imvrWvoSM2cW7lw3NZUEHkr8J1aSjh6s3UWlmOYJ9hkfnUDWDcoUErgPenJTFm4HBgaT/POn0dieHepR38LlKGATsS125feE/hpxAto0XbuMddREBxfHBF0eh/kh4nJqo+ELjeWVJKdJzPoMw4BslmEavYds3WpGJNNEERFki37eDLy5C/qvqz+DhKKWW96iO7kOR9yDTRLz7ULnmvehA
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C15A740009
X-Rspam-User: 
X-Stat-Signature: j9ojjzaysehb54ds4tzobcqznzm64jyu
X-HE-Tag: 1778531426-695080
X-HE-Meta: U2FsdGVkX19wMwkkBDnRRGvHAr0x7wtTUJkuPUbwykWtDe6vXvU1zYZFrJGNqTS6RgJQq+Stuq1Z8GmVFU9RAbIJvFzvolmEJvq3H5OaEv0nx2Dr2tAeg+8+Rqaf1caMwlf1hsgZ1cSFI1UIVx93NXT1pcQYwLlmb9ZdEjOhE9T+MJbWSML2Yje1FMPKR4R9JZ1VZrMG/Bra/bVJEF99GfQYmcwsMfy4hpDRaIRXeBmXwhqrcsYmISaftJ/rL7WEyuZLCAcYO+XwraH0XO+ZkhL5dsPeb7N5xBnJ0fEhIBj736TTt0KXyaY0qmz4DySemK5stlueGK+FVEHI5iHABIWzWLpd3zl9WzVfvCevNPIDD/3btH6EEPvG22fg5ZF+e8Wzllg4mjKPzwJe8Nrf/AZ5Qo+rghqs6TReoAskO4TS1f69nDj7k0FvwbzkUQtYvMwnd2T1576dSTjeeVxBljWAji/EfIxt6L7Mt5t8Yk4vQQ//FoZMMd81GdV0CdeLLdV3q7hp4VPGJFECb42CgAD5ElCWneY7/ZfMw8Ni/wpdUqR1fKNRDKczVr+ky9t1uYvRk5EFzhgIlm16TnbfWNealoeg51XbMYdL9dmqhmjU/ERGiZXngjNenIw5On5H2QM5+cCxigqaT2QkDNSsanaq7ReAF+/3M7ZnGUnyFeG/F6u34quuzRqUR27Vz5rffNXBVmGUrLGJWitzjZwc3cReOxBY0E0md3BBfV2uo4iHnJNZzNUdFiynXAbIxXPaG0KJnLwpNpiHaZ8v3/Ox1Kmk4PEkNC52mJDYdH/sscsVdTBo32vrvvEiLpbOSti1PhLehQECDQbmIE39u56uNLGBLNd+pjgiGqsVysHrODyYeNjNe/btvAeBT+DAYPQbMcN0RmQ5VhuT02mfykZOF9tdwdRlYuRAiUy3RjEVAF2WgIzPN5UhXzPFopRcVuXUYz1oy+HsgUuBxQzgwNa
 LIC3AYT8
 PK6777deNMBflsF2Rq79CkaSsDL+qEc4iVsRAkhNM9brl1flGkUFcT5pQxxFTfwA+J99S2P51sYIBpGyNDs8DiJptD7QNnnKHjvGmbTB6quJHQjfG0BZyfTTBejDJliBEPnua
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update zswap and zsmalloc to use per-node obj_cgroup for kmem
accounting, attributing compressed page charges to the correct
NUMA node.

But actually, this is incomplete because it does not correctly account
for entries that straddle pages, those pages being possibly on 2 different
nodes.

This will be correctly handled by Joshua in a different series [1].

Link: https://lore.kernel.org/linux-mm/20260311195153.4013476-1-joshua.hahnjy@gmail.com/ [1]
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 include/linux/zsmalloc.h |  2 ++
 mm/zsmalloc.c            | 11 +++++++++++
 mm/zswap.c               |  9 +++++++--
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
index 478410c880b1..30427f3fe232 100644
--- a/include/linux/zsmalloc.h
+++ b/include/linux/zsmalloc.h
@@ -50,6 +50,8 @@ void zs_obj_read_sg_end(struct zs_pool *pool, unsigned long handle);
 void zs_obj_write(struct zs_pool *pool, unsigned long handle,
 		  void *handle_mem, size_t mem_len);
 
+int zs_handle_to_nid(struct zs_pool *pool, unsigned long handle);
+
 extern const struct movable_operations zsmalloc_mops;
 
 #endif
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 63128ddb7959..7b45c67e51f1 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1381,6 +1381,17 @@ static void obj_free(int class_size, unsigned long obj)
 	mod_zspage_inuse(zspage, -1);
 }
 
+int zs_handle_to_nid(struct zs_pool *pool, unsigned long handle)
+{
+	unsigned long obj;
+	struct zpdesc *zpdesc;
+
+	obj = handle_to_obj(handle);
+	obj_to_zpdesc(obj, &zpdesc);
+	return page_to_nid(zpdesc_page(zpdesc));
+}
+EXPORT_SYMBOL(zs_handle_to_nid);
+
 void zs_free(struct zs_pool *pool, unsigned long handle)
 {
 	struct zspage *zspage;
diff --git a/mm/zswap.c b/mm/zswap.c
index 4b5149173b0e..e3a9a294f14b 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1443,8 +1443,13 @@ static bool zswap_store_page(struct page *page,
 	 */
 	zswap_pool_get(pool);
 	if (objcg) {
-		obj_cgroup_get(objcg);
-		obj_cgroup_charge_zswap(objcg, entry->length);
+		struct obj_cgroup *nid_objcg;
+		int nid = zs_handle_to_nid(pool->zs_pool, entry->handle);
+
+		nid_objcg = obj_cgroup_get_nid(objcg, nid);
+		obj_cgroup_charge_zswap(nid_objcg, entry->length);
+		obj_cgroup_get(nid_objcg);
+		objcg = nid_objcg;
 	}
 	atomic_long_inc(&zswap_stored_pages);
 	if (entry->length == PAGE_SIZE)
-- 
2.54.0


