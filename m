Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74E88C87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 06:46:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DE416B0092; Tue, 29 Jul 2025 02:46:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 867306B0095; Tue, 29 Jul 2025 02:46:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 756246B0096; Tue, 29 Jul 2025 02:46:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 655546B0092
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 02:46:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3053C1D9568
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 06:46:50 +0000 (UTC)
X-FDA: 83716369380.30.2A9F54A
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8515A180009
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 06:46:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sR80yrFl;
	spf=pass (imf16.hostedemail.com: domain of hare@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=hare@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753771608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uoQxbo2LCrUKH9wC9M4ya5Z7a+Vjhk2VDrWV0RZaecY=;
	b=xovvjy7GLgcHU/+PKIXIezyNd5WUs+vlaRfGG+SfmzOCbBFL/lul9HBofgFJWXOVs1kQUE
	IYxMHZ0QGNyHfulz82K0BU+ijBRNAiTluDZMHI+gWlSpcE3QeUH8JNltmJA0tyxZenw7uO
	jZsWpxrykKiyePIJZ0VnXkY50PlYIkY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753771608; a=rsa-sha256;
	cv=none;
	b=0GyVQdDk83f8MGNofqWs01wP+hmvZFoKnEUVyVyptVO/vFnJoyAIWzrBwrAY+mJNQNMYZe
	zbYnxCkSNgwOz4rfosuRA7oRktTbOkYBJm5CkdiNoKlD/X14ss5wV7vDw2O9y9+6hxwsQi
	+mbe/cpWusZHp5GocxobdswaPt2fz+8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sR80yrFl;
	spf=pass (imf16.hostedemail.com: domain of hare@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=hare@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id C84375C5889;
	Tue, 29 Jul 2025 06:46:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 030DCC4CEF5;
	Tue, 29 Jul 2025 06:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753771607;
	bh=T/9FsTNDYrAIuQ9lYyd17Dbz1Pfj/Umjgv4Bba/ULCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sR80yrFlExz/HwDjmaL2c3OpCwhUmY7frWgj6uZhdeA7vJVYuTVMPW5YxQoa9Fi/Y
	 QOtYpylw6blNBKkSduV3b8TSAbcHZRqClfkAZzLo/0zcqrNbZhnTYeZ/0COI3X7FDN
	 +0a3t/B4lfm1F9sT6ANxI7IHX1l5cPqnbgvZP0m7a8+tt+gymNlG8uZnLQV3CVe7dd
	 tz+UA7yWp5gZmCy7hfZ+L6clOKIcQDvq7de5psY5UTmOctX0vE2qv6sgJlTelHMmdK
	 3Onk2Qu/sYszZjGq8H1BOcZtdYiQ4RlkGZDKAlJn4yk5MgwG8Kbml/U1XMIhRooa3i
	 N9D9fAQSE0bdA==
From: Hannes Reinecke <hare@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	linux-mm@kvack.org,
	Hannes Reinecke <hare@kernel.org>,
	Donet Tom <donettom@linux.ibm.com>
Subject: [PATCH 3/3] drivers/base: move memory_block_add_nid() into the caller
Date: Tue, 29 Jul 2025 08:46:36 +0200
Message-ID: <20250729064637.51662-4-hare@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250729064637.51662-1-hare@kernel.org>
References: <20250729064637.51662-1-hare@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8515A180009
X-Stat-Signature: 8shcesyosd5kyra1ccrj4ocnsf5q8i9x
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753771608-976583
X-HE-Meta: U2FsdGVkX18tW6JZeW+nu25vJRa69aNZ9O4GV5NiBIUir1alu3Y5gtOUGW8x1MniK4FRn69orJHkadL3iZ2LQFe56nRVP6DQdfMaBI3rD8OY9KJbLPV+7y3SuyOtGtRC5QiBffGLsJKsCEJ71lReFs0X03+pF2almkhF4W4gLWP7jdduyTW64oXwRitRDBEssF2Qv58c4M2+MpaTpbly/L1lPdcOwRx8eP6rzN7ub+YO5N8jo2UgSdWHiRV2pVOo9SnPVc1u8GAH8UniO0q1o/JWdfgGcZnEt9ZIY1MMjZXmOsZwGtoUcUB8xQtNMZnCk/RpMTIYZ9qE/RVLr7DbHBRVpUuhmiep2ePF3057uvlY9GocahQS2SZl335y3Fuo8Hy/NpNxad+qsB5PcVx58vjAMROqkmxD/fyoTjRoUFoROUJuTxV4glau5jjgBZmSKV4g0lOL39lluK2+U3WSbEoUx1G9oQKG0H5T7U+V+OygmtDmV8/o50yPCKlWnigiwIXQNkescfvLk7tjJPoRUfJk+KmzhpVJJIUWNoG7NC4dSabefPYYnzHxnqtWCq9EV54cZbKXuGicocZvEPeJMLLUhHItgmObTwpo6hmT6utM+ZwY0yF3so3813SWxOtpTN/x3vOkXgbLzkh3Fit1dKsP0s+LmMXWJads0nf2TJ/mPjNrBC4QCzFhgnYusjvpTzipxBVM5YSvR5SpNtEU6MMvONGLmc+9Awm70c5ha/NDsNqQVQ0TKeX0Htx573DkV8PBKhx1l6IP1kO3w0M9A5Dq32b8V6eSo+qmXH83K1aai9Adk/G0OR0DcIt1K8YW/CjeVk8Ep3m4I6tpVWe7G64f3901TsTMCP5188wedlf5LhQrgxPt1959UC1P5Num/a1KGeyGmGg/E/6zPLAFak542fFWvmAKXE3ZObT84VtaG71dIFuFtlPuT6QM70G2SFwi7miaVKJ57j2szQG
 p0/0AylM
 4O59k0eEsakId9oD2FPaUCOw3Sj4NO2QbKlF7xhMASNKIBRojP8YKRGtpiuUVQ25rwtp3wVTif5caTOhnkPTGDpdJEyLZ0XM6jlcEEDDjEzjVTcvxYm6GEXBjRcabhqa9S1gHXNRKIAM9npNLY+eCCuAxWrAL043H0JCrKydyM5x+dfwTuLQ83omKU1eCttFGqzZ5VBm63TruLuQN6dKylDVrIPWgqr6ITSYC0QpasTSpRGYJajYqUr6LYRHaH2kfQcFEQOZqpFvPUpZse3r6LUce0wpU3G740DALOd/cRLNGFnMNIMHWJ49tD/DUIdm2PWiCt+3fY5CL/w7TE0TGXhM1RlMi0zDAhAwTAPvb3Py9Auc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now the node id only needs to be set for early memory, so move
memory_block_add_nid() into the caller and rename it into
memory_block_add_nid_early(). This allows us to further simplify
the code by dropping the 'context' argument to
do_register_memory_block_under_node().

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Hannes Reinecke <hare@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Donet Tom <donettom@linux.ibm.com>
---
 drivers/base/memory.c  | 36 ++++++++++++++++++------------------
 drivers/base/node.c    | 10 ++++------
 include/linux/memory.h |  3 +--
 3 files changed, 23 insertions(+), 26 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index fb212a889e65..6d84a02cfa5d 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -769,21 +769,22 @@ static struct zone *early_node_zone_for_memory_block(struct memory_block *mem,
 
 #ifdef CONFIG_NUMA
 /**
- * memory_block_add_nid() - Indicate that system RAM falling into this memory
- *			    block device (partially) belongs to the given node.
+ * memory_block_add_nid_early() - Indicate that early system RAM falling into
+ *				  this memory block device (partially) belongs
+ *				  to the given node.
  * @mem: The memory block device.
  * @nid: The node id.
- * @context: The memory initialization context.
  *
- * Indicate that system RAM falling into this memory block (partially) belongs
- * to the given node. If the context indicates ("early") that we are adding the
- * node during node device subsystem initialization, this will also properly
- * set/adjust mem->zone based on the zone ranges of the given node.
+ * Indicate that early system RAM falling into this memory block (partially)
+ * belongs to the given node. This will also properly set/adjust mem->zone based
+ * on the zone ranges of the given node.
+ *
+ * Memory hotplug handles this on memory block creation, where we can only have
+ * a single nid span a memory block.
  */
-void memory_block_add_nid(struct memory_block *mem, int nid,
-			  enum meminit_context context)
+void memory_block_add_nid_early(struct memory_block *mem, int nid)
 {
-	if (context == MEMINIT_EARLY && mem->nid != nid) {
+	if (mem->nid != nid) {
 		/*
 		 * For early memory we have to determine the zone when setting
 		 * the node id and handle multiple nodes spanning a single
@@ -797,15 +798,14 @@ void memory_block_add_nid(struct memory_block *mem, int nid,
 			mem->zone = early_node_zone_for_memory_block(mem, nid);
 		else
 			mem->zone = NULL;
+		/*
+		 * If this memory block spans multiple nodes, we only indicate
+		 * the last processed node. If we span multiple nodes (not applicable
+		 * to hotplugged memory), zone == NULL will prohibit memory offlining
+		 * and consequently unplug.
+		 */
+		mem->nid = nid;
 	}
-
-	/*
-	 * If this memory block spans multiple nodes, we only indicate
-	 * the last processed node. If we span multiple nodes (not applicable
-	 * to hotplugged memory), zone == NULL will prohibit memory offlining
-	 * and consequently unplug.
-	 */
-	mem->nid = nid;
 }
 #endif
 
diff --git a/drivers/base/node.c b/drivers/base/node.c
index bef84f01712f..412bba07befd 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -781,13 +781,10 @@ int unregister_cpu_under_node(unsigned int cpu, unsigned int nid)
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 static void do_register_memory_block_under_node(int nid,
-						struct memory_block *mem_blk,
-						enum meminit_context context)
+						struct memory_block *mem_blk)
 {
 	int ret;
 
-	memory_block_add_nid(mem_blk, nid, context);
-
 	ret = sysfs_create_link_nowarn(&node_devices[nid]->dev.kobj,
 				       &mem_blk->dev.kobj,
 				       kobject_name(&mem_blk->dev.kobj));
@@ -815,7 +812,7 @@ static int register_mem_block_under_node_hotplug(struct memory_block *mem_blk,
 {
 	int nid = *(int *)arg;
 
-	do_register_memory_block_under_node(nid, mem_blk, MEMINIT_HOTPLUG);
+	do_register_memory_block_under_node(nid, mem_blk);
 	return 0;
 }
 
@@ -855,7 +852,8 @@ static void register_memory_blocks_under_nodes(void)
 			if (!mem)
 				continue;
 
-			do_register_memory_block_under_node(nid, mem, MEMINIT_EARLY);
+			memory_block_add_nid_early(mem, nid);
+			do_register_memory_block_under_node(nid, mem);
 			put_device(&mem->dev);
 		}
 
diff --git a/include/linux/memory.h b/include/linux/memory.h
index 4a29153e372e..43d378038ce2 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -202,8 +202,7 @@ static inline unsigned long phys_to_block_id(unsigned long phys)
 }
 
 #ifdef CONFIG_NUMA
-void memory_block_add_nid(struct memory_block *mem, int nid,
-			  enum meminit_context context);
+void memory_block_add_nid_early(struct memory_block *mem, int nid);
 #endif /* CONFIG_NUMA */
 int memory_block_advise_max_size(unsigned long size);
 unsigned long memory_block_advised_max_size(void);
-- 
2.43.0


