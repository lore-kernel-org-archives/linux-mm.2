Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BCE2C624A6
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 08:50:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E77736B00B4; Sun, 22 Feb 2026 03:50:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5F9A6B00B6; Sun, 22 Feb 2026 03:50:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0D196B00B7; Sun, 22 Feb 2026 03:50:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE0956B00B4
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 03:50:05 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 87899160662
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:50:05 +0000 (UTC)
X-FDA: 84471470370.09.3D7EE27
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id D763840012
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:50:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="AK1UQp/l";
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771750203; a=rsa-sha256;
	cv=none;
	b=2hCxzUY4PWMuvLBViwoN1JwDYlsLZpvuMI6XUQiYOZY09gU7cFJivLGtI7ogKkUhl3YQkT
	4Y8pIRsWaXQxZzMTm7FU/+Tf/WKNd5p1m1VyM7zC8VY+bZuoVK7BpEyrOhPQCfSY58Izor
	PLZmPJp8A1YDK0xo8lmRQhijhHkMUA0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="AK1UQp/l";
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771750203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1vF7vDru1wu4C4IPdmOP0dgYFxJxyuUKkceiB3IYEd0=;
	b=q4HNmQLMnoramipMY3fsrs0bhy4dFNIee+5lpY7Hp+T0DBgIbF5LQpdO3Zb3ov4YCIEhej
	uuuOBPRvYVDTlluiJ382e+paiz6/l3ufy8xxMqQmlLhuiAA0gjaJ5wHjrjt+/GJPzf7zTM
	8v95JSC7V/M+vjUJDAXUyu0tERfhfpc=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-506a7bbe9d0so29136021cf.0
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 00:50:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1771750203; x=1772355003; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1vF7vDru1wu4C4IPdmOP0dgYFxJxyuUKkceiB3IYEd0=;
        b=AK1UQp/llbTdIRxVSVk2BCy2RiNkZBwmwscw0eMvFC3IVPoxHTgcIlAeeGeVYTaYY9
         wMZ1aYHwaSRa0E8Za7zcxLR1AcLF18eHBShXGsYNmSRhgj1XaDGnQnCUrBZ4g+fjhwNX
         VzN6busB59fK6QyrqmaloZcUvYTlPyV6cT+kjrLm6aftf7yv+MQxnMz49tjJ3fuGQbBx
         okwYTD9BuJkMwYP7FCxdQylO2mhf9Ll1SeASmAyL9q79XeEY7xQQ3nLEl8hbj6ayES9f
         i+52os+DAgjz2wSnQU/n0vYCixhri6JtalhLZ+jvXlMjarV0GlrmoA7Vy81OXJoC0HiW
         ViZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771750203; x=1772355003;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1vF7vDru1wu4C4IPdmOP0dgYFxJxyuUKkceiB3IYEd0=;
        b=SRuKeVlChx9qd2kllFlaGU3CCjzSg6nBu4Lc8UYbXyiT75ydWbOmoUGFIWDglmXTBI
         L8sdVrdKMAfAiXRbsWXhZFcBrk8STYHTU+R/mmKGSY20m2OJBco80QF9US+/C8YYyLWp
         QBJhQH84l9YkZNbML5VxQXpqIGw8b8G9NmQMWDlrtMtaU42SUskwRae1nIxEScBPbJhs
         deAUtY3sTRNPoedJH/LQ0jFq3HGPwPe33Kgd/2dA5ezN9nueagCzSiKZB5qdSU7YMPTW
         ThsXZXPmIBZq7i81q5jyhpvLmGsl/wsm8yrjdsI92+SHAO9oczQIzdfLu3+CH0VAPJ8+
         6oaw==
X-Forwarded-Encrypted: i=1; AJvYcCUpZTf7MyHufb4dsg4FfUxIeU01iPveQmTAOg8KIqKsV61ot7OGUmk1pEMif4G9wYIDYxPwzsxwTA==@kvack.org
X-Gm-Message-State: AOJu0YyaA3ZBMVDPnh/LRQL0Fb4nNYVV9H1f2IrSZEqmPZ5h3TLC/lie
	UkBWbL5NOPYioXuSEqfhRzNZuBKTueI3919y3mtuOpcsXQAmn5b3Ke33Ta2XVdKugBE=
X-Gm-Gg: AZuq6aJ2dwCpxXPrJdjWtFjULgvTRzRtaVRGsjErnYU8ugLErQApiiSkASX1KxsZiV4
	ikZQHF6SXDSTsw7MuO/pNW6auYjLjkZkseuJzZOkYYdoj4Q4/vg3LIGPwXC1k/68K8u4Za3jevH
	yLUT27d4neHYf+7gX5Y0d0EfZ8YBxZDb3GYWQT2KD8b93kvJaE8bjadSPPMynaR2mFk3Q04JL4N
	gXvx73Wzvutl8S2fAEWRK8o7RWcMeWHsZ57G40Uolet4Unsg5e0kFko+wCGrrl/HKS5w3FG/bSQ
	rcsebMHBgLFY6ASl81ZqQK8avfmBgVcuGHDjjOsguFBgFo98YgsgFMGaIUDjgz7lka6nuZcaOEr
	qQTokv5ixXKG80KkHTOuBKXx/YOb3ADBJF7JTQhT/W3alxQooLpByIonB2wNlWKjzxWsVMta/Bm
	RR1313epQF9S381Nh8blqiRc4W27EckBWUBjK447gqf0/fve/b2q28jRjpBxPQ3nAlY2xq3wNnV
	8P2JTRPbZi0LIM=
X-Received: by 2002:a05:622a:14c9:b0:4ee:1fbe:80de with SMTP id d75a77b69052e-5070bca9b78mr73724161cf.63.1771750202674;
        Sun, 22 Feb 2026 00:50:02 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d53f0fcsm38640631cf.9.2026.02.22.00.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 00:50:02 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: lsf-pc@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	longman@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	jackmanb@google.com,
	sj@kernel.org,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	muchun.song@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	jannh@google.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	pfalcato@suse.de,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	harry.yoo@oracle.com,
	cl@gentwo.org,
	roman.gushchin@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	zhengqi.arch@bytedance.com,
	terry.bowman@amd.com
Subject: [RFC PATCH v4 18/27] mm/memory: NP_OPS_NUMA_BALANCING - private node NUMA balancing
Date: Sun, 22 Feb 2026 03:48:33 -0500
Message-ID: <20260222084842.1824063-19-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260222084842.1824063-1-gourry@gourry.net>
References: <20260222084842.1824063-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D763840012
X-Stat-Signature: ts8f8cmzdhhm5wpo9sb1o6mweg6zbkks
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771750203-129636
X-HE-Meta: U2FsdGVkX1+9n3e3lucJpzimAMfR5soXFzaXL3Fisraw2Dd6ZgUNn0RpePOzcpiLrGVzpuzR3wPYVkAbdAcdHdJ/0mo4hSQsnhNEquzySwqr7Pm0S2aghJipbsGDkTgxACzYhtSGZM8vI+mw7ljZV0EIblfiRdECMC4kzxm4ePSeAmwSDNSBk6sAetWJAZNUCMMsO62EdBRqZpLuIPnGTe9EOL3m6q4S2Wnm5FBG4Y5zqiKRINY3Ywtx7LrLV0sgwUJtzw8cBgodgq4OjDwY5hFXtmaDlnhgg7s+fk35NAq5mARN+VHcISUTRgBR/vs2MfRMPkfKh3aGlRF16+BDn7wU51qyRXPsbVinRcCSwSqiwe7Igbgr8DyG0oSCatW5BD9KNiJVJTRLgceAKr6gT7iNfQrgImytJYuFRuR82D8ohC8u4zVpNJhUh4/bOrS0qqf4A9FHtbpIgTg4gZzY+Svm7SBr3TQwqquX4pk9NlpJFjQqwUqnIx25vhWoJ+7oDHuvhdlEIIfQ3J7bbKnFSR9fs7GngOkTPTyuX45qcDg6xTHpfYd5kAk3naquEELlqVl7UO+Xid6aTwBiS1H5ytjNNfdaCB74RxnMNAqYqQhywjBvX38njfsoWWMk48Qnx2RysPuMVyVHtOVLl9T02udzYMc4kWvtMnPZZyzo4IFHjdAUU6DNRjr2YK/WEfiJU5nC2q0scPuacscOLV88Z8sk1BMqJrsIhgBjdQiKo+8ZQgZD5tOejuGEAcOdlL/AICHaoZ9iFAK4a5jcs/GaWSzaPW2DS4JIEGQwHUEsUBJn3J6WOfcaVs/Pq34GfLDuC53Hjb5LpkXrRp3YJCpJ5IgASG8cUrasTGFFS9CGqQkxffRK6whduhtU8uWshEm5o/8KPZjBZptnPBEVEOzaZb4fb9ll9urg/XUD2/yg/JWGQkjQF9lVAI/Q75Q3Nf6qy1yBT18Uaml3mBorYSE
 n8C8yoNJ
 ltECTfLiDI8HINfvci3y5n3VFW0moXfkL9pt0p4txI4UZRSnL/prOGGqVRfqRzr3S7qgIXOHv9CNRTm5GELUt2F5ZiuH+1ftKtL3XgRynmdmqBN1xuCSOH5HwOIRn1qSW9mQbKQf8vhSy6Dv9Jzc0Brkl3g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Not all private nodes may wish to engage in NUMA balancing faults.

Add the NP_OPS_NUMA_BALANCING flag (BIT(5)) as an opt-in method.

Introduce folio_managed_allows_numa() helper:
   ZONE_DEVICE folios always return false (never NUMA-scanned)
   NP_OPS_NUMA_BALANCING filters for private nodes

In do_numa_page(), if a private-node folio with NP_OPS_PROTECT_WRITE
is still on its node after a failed/skipped migration, enforce
write-protection so the next write triggers handle_fault.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/base/node.c          |  4 ++++
 include/linux/node_private.h | 16 ++++++++++++++++
 mm/memory.c                  | 11 +++++++++++
 mm/mempolicy.c               |  5 ++++-
 4 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index a4955b9b5b93..88aaac45e814 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -961,6 +961,10 @@ int node_private_set_ops(int nid, const struct node_private_ops *ops)
 	    (ops->flags & NP_OPS_PROTECT_WRITE))
 		return -EINVAL;
 
+	if ((ops->flags & NP_OPS_NUMA_BALANCING) &&
+	    !(ops->flags & NP_OPS_MIGRATION))
+		return -EINVAL;
+
 	mutex_lock(&node_private_lock);
 	np = rcu_dereference_protected(NODE_DATA(nid)->node_private,
 				       lockdep_is_held(&node_private_lock));
diff --git a/include/linux/node_private.h b/include/linux/node_private.h
index 34d862f09e24..5ac60db1f044 100644
--- a/include/linux/node_private.h
+++ b/include/linux/node_private.h
@@ -140,6 +140,8 @@ struct node_private_ops {
 #define NP_OPS_PROTECT_WRITE		BIT(3)
 /* Kernel reclaim (kswapd, direct reclaim, OOM) operates on this node */
 #define NP_OPS_RECLAIM			BIT(4)
+/* Allow NUMA balancing to scan and migrate folios on this node */
+#define NP_OPS_NUMA_BALANCING		BIT(5)
 
 /* Private node is OOM-eligible: reclaim can run and pages can be demoted here */
 #define NP_OPS_OOM_ELIGIBLE		(NP_OPS_RECLAIM | NP_OPS_DEMOTION)
@@ -263,6 +265,15 @@ static inline void folio_managed_split_cb(struct folio *original_folio,
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
+static inline bool folio_managed_allows_numa(struct folio *folio)
+{
+	if (!folio_is_private_managed(folio))
+		return true;
+	if (folio_is_zone_device(folio))
+		return false;
+	return folio_private_flags(folio, NP_OPS_NUMA_BALANCING);
+}
+
 static inline int folio_managed_allows_user_migrate(struct folio *folio)
 {
 	if (folio_is_zone_device(folio))
@@ -443,6 +454,11 @@ int node_private_clear_ops(int nid, const struct node_private_ops *ops);
 
 #else /* !CONFIG_NUMA || !CONFIG_MEMORY_HOTPLUG */
 
+static inline bool folio_managed_allows_numa(struct folio *folio)
+{
+	return !folio_is_zone_device(folio);
+}
+
 static inline int folio_managed_allows_user_migrate(struct folio *folio)
 {
 	return -ENOENT;
diff --git a/mm/memory.c b/mm/memory.c
index 0f78988befef..88a581baae40 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -78,6 +78,7 @@
 #include <linux/sched/sysctl.h>
 #include <linux/pgalloc.h>
 #include <linux/uaccess.h>
+#include <linux/node_private.h>
 
 #include <trace/events/kmem.h>
 
@@ -6041,6 +6042,12 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
 	if (!folio || folio_is_zone_device(folio))
 		goto out_map;
 
+	/*
+	 * We do not need to check private-node folios here because the private
+	 * memory service either never opted in to NUMA balancing, or it did
+	 * and we need to restore private PTE controls on the failure path.
+	 */
+
 	nid = folio_nid(folio);
 	nr_pages = folio_nr_pages(folio);
 
@@ -6078,6 +6085,10 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
 	/*
 	 * Make it present again, depending on how arch implements
 	 * non-accessible ptes, some can allow access by kernel mode.
+	 *
+	 * If the folio is still on a private node with NP_OPS_PROTECT_WRITE,
+	 * enforce write-protection so the next write triggers handle_fault.
+	 * This covers migration-failed and migration-skipped paths.
 	 */
 	if (unlikely(folio && folio_managed_wrprotect(folio))) {
 		writable = false;
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 8ac014950e88..8a3a9916ab59 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -861,7 +861,10 @@ bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
 {
 	int nid;
 
-	if (!folio || folio_is_zone_device(folio) || folio_test_ksm(folio))
+	if (!folio || folio_test_ksm(folio))
+		return false;
+
+	if (unlikely(!folio_managed_allows_numa(folio)))
 		return false;
 
 	/* Also skip shared copy-on-write folios */
-- 
2.53.0


