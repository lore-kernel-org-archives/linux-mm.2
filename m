Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 356DCC5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 09:04:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11BDB6B0913; Mon, 17 Aug 2026 05:04:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CD876B0915; Mon, 17 Aug 2026 05:04:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFE456B0917; Mon, 17 Aug 2026 05:04:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C504D6B0913
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:04:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 555BE806CD
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:04:07 +0000 (UTC)
X-FDA: 85110174534.18.FEC4D29
Received: from mta1.migadu.com (out-70.mta1.migadu.com [95.215.58.70])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4C130180009
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:04:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bOylzFai;
	spf=pass (imf24.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.70 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786957445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YF+aXbbifBBBWQpu83+RxuL0q0WY7z7REe77O+Gj1Hs=;
	b=RR536wNw9imO4RxXFbwXVHvdQKnDf//Bx3sxxQFrLp9jOh4/7ofPsO4NRw3iXiopsCql9h
	1YAvoDHRGEshNAZH/zlkDbsyxlDaLuE+LEvbHBGd4uES03JS1UifGkdAyaqG/fpsB8qTYq
	xVanNiybMck8gtbX/Kj3Rs8U4Wat/XE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bOylzFai;
	spf=pass (imf24.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.70 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786957445;
	b=EmDhFVEurWlwVwXeoNAPCEmOgiFzBS3KU+NFL2qWpP51hFwfUNpkv4ATp0+uMWWiTaXyJH
	bjzXQ+YzByyNSJDlaAQOwZgK4C0MKM35r7rE4KDSCazTyIS7dt6MrIwyVR3LhA4k/QqYku
	B47+8Xgwck/MBxcDRqXP0WrNboWRMXM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=dkMQJ2rsBFy4+vU+FROiwJWs1Nekl7LDcV2tZun3MeY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786957444; v=1; x=1787562244;
 b=bOylzFaiOMQLrMBNpTJ9i/2BSB3NDz/2pXSaNOLrW2dLpo+6MDJWjEZtGahLShe66Hr6IFZI
 DXJcQ6R7ie50M6xqgVRZ6ij0Qn9XAg3PPtSn2LDVFTg4EyVdDjwVOD29khBI4S2VDCNATWn2Xu+
 qUmLeKOaPDildP9x4BcMUHaA=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (221.194.171.228)
	by smtp.migadu.com with ESMTPS id 0154517dd3bf7b59;
	Mon, 17 Aug 2026 09:04:03 +0000
X-Migadu-Flow: FLOW_OUT
From: Qi Zheng <qi.zheng@linux.dev>
To: hughd@google.com,
	baolin.wang@linux.alibaba.com,
	usama.arif@linux.dev,
	brauner@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v4 2/4] mm: memcontrol: make obj_cgroup_memcg() handle NULL objcg
Date: Mon, 17 Aug 2026 17:03:26 +0800
Message-ID: <09bcf74312246a6e4146be8a0cb9787f8beddb28.1786955972.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1786955972.git.zhengqi.arch@bytedance.com>
References: <cover.1786955972.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4C130180009
X-Stat-Signature: qkjhey189rree4sjkagphex86s3qaanc
X-Rspam-User: 
X-HE-Tag: 1786957445-976092
X-HE-Meta: U2FsdGVkX182IHXnlDbMMq2Zu4EAC4h70vDXy+jDHJMJ2lb4lXNHa6RJ8/bKzAFU4Z4w3clmPkHYjI5SaCzGxaG+pSl0dIPp2kumvgguPI33IaEavKGOF82rPnEeCTcNgjzm/p4hseWHK49sqw5B0dJ4H4dlWSeLJgGZmSQxP42rF6X2lgCP2ewBv7ksAsEk4kdzWasjUWC3kY6F4f0RH1pXvGvge4wk3s0ie8tc5MsrRVONkfEcubEz8lGJ2tvu9i4KZ5Fv8D8EGD4GJ0OMe5LT+u05PrA/JA1uLnxwRc22N0OzHLFPGDppsSImqRiIk5hO/O1/5wA6uz0Ut1kKo+Fufn8tijkSteUzCsnqOTldZnu6VLGQkfla4lFGqJ9s9Cdh99qdC8AYUr6fMS3sRpzOcktUb2TNo3r09ZZOXI4j3xozaov0znJse+51VrB8kW1Gh3wPnRK7sH3l9xF+lZk6UAP44Lfa5P4YX4Bq+irDUA+EFkfgNmEluUIneLrH8nDKAdL9iXh0Vsd3BvHiQ9vwi+TqKrHrGTU9XUBKCaA54zlePbsgMMOqkeJhT0zN+GTJWVcka+2cX5EOWwtJfHT7K/BY3gyYeaUKP2DH53qBnEL9IuT2AT7HR2U+IGXSpt5cjl1Hkcq1zu0fNQ8Uuus1bUVipG3OF3VdGKY50d3aEZIlu0EsdfrHGSnpaDWU8iYQmCPqYLADGd+cPG3mIuamrMV1JSjc7ZEK6Hk1xxWJccQkBhugwe2N7qUMFeRlmENJng4gqHZNf7b61DZ+93y/AoQPFqf+VYyBmBDEFPL6dCcpT6b+QR4L61/YqSvBwbJOOD8Ar1uPaGTTkZFCJkTTf5rOxa1ri5Gpkzfr2qyMV6jOhd6ntYRq/8kDf9GWDhEQDFhhq0x2WGsy1xpqWPdjxVUZVVeRPjp1bzARCqDbDEvG9GvPUoSRAJmSVl1r3q7MKU66O/Qco1+NVw9
 9JbncPbl
 TdqYU7QDl+iBSg9xB+DkfsXbFdjEap2WRD0jys/VzY70BaRz6AwwgEUBQqEiBd89vmC1lqYcudVmqOX3bSrWUvEdPNlv8HN8W5SzRvoeygz2j2oruJpG4ZLebMY73sLXihV1IqE//GrC8iY2S/ZLsMsa1I9uvkwS72ROnL28J+Mkqmc9xyCenyYR5EKljt71BehD0xm5H8CDrgk/Mjah0BVN2F3+kxXHJ48UYCkvSQgUDuZIsYH49Wpfg2DiYER7YXWfa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

obj_cgroup_memcg() currently requires a non-NULL objcg, so callers that
may hold a NULL objcg must guard the call with an explicit NULL check.
This pattern is duplicated in folio_memcg(), folio_memcg_check(),
mm/page_owner.c, and mm/zswap.c.

Teach obj_cgroup_memcg() to accept NULL and return NULL in that case, then
remove the redundant NULL checks at the call sites.  Also remove the
mem_cgroup_from_entry() wrapper in zswap, which existed solely to provide
this NULL-safe behaviour, and replace its two callers with direct
obj_cgroup_memcg() calls.

No functional change intended.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 include/linux/memcontrol.h | 11 ++++++++---
 mm/page_owner.c            |  2 +-
 mm/zswap.c                 | 17 ++---------------
 3 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index cba35690c21aa..5107c227ae9b8 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -375,7 +375,7 @@ enum objext_flags {
 static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
 {
 	lockdep_assert_once(rcu_read_lock_held() || lockdep_is_held(&cgroup_mutex));
-	return READ_ONCE(objcg->memcg);
+	return objcg ? READ_ONCE(objcg->memcg) : NULL;
 }
 
 /*
@@ -428,7 +428,7 @@ static inline struct mem_cgroup *folio_memcg(struct folio *folio)
 {
 	struct obj_cgroup *objcg = folio_objcg(folio);
 
-	return objcg ? obj_cgroup_memcg(objcg) : NULL;
+	return obj_cgroup_memcg(objcg);
 }
 
 /*
@@ -471,7 +471,7 @@ static inline struct mem_cgroup *folio_memcg_check(struct folio *folio)
 
 	objcg = (void *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
 
-	return objcg ? obj_cgroup_memcg(objcg) : NULL;
+	return obj_cgroup_memcg(objcg);
 }
 
 static inline struct mem_cgroup *page_memcg_check(struct page *page)
@@ -1045,6 +1045,11 @@ void mem_cgroup_flush_workqueue(void);
 extern int mem_cgroup_init(void);
 #else /* CONFIG_MEMCG */
 
+static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
+{
+	return NULL;
+}
+
 #define MEM_CGROUP_ID_SHIFT	0
 
 #define root_mem_cgroup		(NULL)
diff --git a/mm/page_owner.c b/mm/page_owner.c
index fbbda7ba914ba..3fc37d9b908ef 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -575,7 +575,7 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
 	}
 
 	objcg = (void *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
-	memcg = objcg ? obj_cgroup_memcg(objcg) : NULL;
+	memcg = obj_cgroup_memcg(objcg);
 	if (!memcg)
 		goto out_unlock;
 
diff --git a/mm/zswap.c b/mm/zswap.c
index 37f34e406c8e3..c1dc60926bad9 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -647,19 +647,6 @@ static int zswap_enabled_param_set(const char *val,
 * lru functions
 **********************************/
 
-/* should be called under RCU */
-#ifdef CONFIG_MEMCG
-static inline struct mem_cgroup *mem_cgroup_from_entry(struct zswap_entry *entry)
-{
-	return entry->objcg ? obj_cgroup_memcg(entry->objcg) : NULL;
-}
-#else
-static inline struct mem_cgroup *mem_cgroup_from_entry(struct zswap_entry *entry)
-{
-	return NULL;
-}
-#endif
-
 static inline int entry_to_nid(struct zswap_entry *entry)
 {
 	return page_to_nid(virt_to_page(entry));
@@ -682,7 +669,7 @@ static void zswap_lru_add(struct zswap_entry *entry)
 	 * Similar reasoning holds for list_lru_del().
 	 */
 	rcu_read_lock();
-	memcg = mem_cgroup_from_entry(entry);
+	memcg = obj_cgroup_memcg(entry->objcg);
 	/* will always succeed */
 	list_lru_add(&zswap_list_lru, &entry->lru, nid, memcg);
 	rcu_read_unlock();
@@ -694,7 +681,7 @@ static void zswap_lru_del(struct zswap_entry *entry)
 	struct mem_cgroup *memcg;
 
 	rcu_read_lock();
-	memcg = mem_cgroup_from_entry(entry);
+	memcg = obj_cgroup_memcg(entry->objcg);
 	/* will always succeed */
 	list_lru_del(&zswap_list_lru, &entry->lru, nid, memcg);
 	rcu_read_unlock();
-- 
2.54.0


