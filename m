Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 903B8C83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 06:46:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 707D96B008A; Tue, 29 Jul 2025 02:46:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B8C96B0092; Tue, 29 Jul 2025 02:46:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A85B6B0093; Tue, 29 Jul 2025 02:46:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C05E6B008A
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 02:46:49 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A2F70113A71
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 06:46:48 +0000 (UTC)
X-FDA: 83716369296.07.5E7D6BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id D44B11C0007
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 06:46:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dm8bncky;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of hare@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=hare@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753771607; a=rsa-sha256;
	cv=none;
	b=BprCB3sc/GSt6nKRShjVffiT5QzWrkTIeAAyvHygPPoVqOzTy/mQ3O/RxJNjrrzyG1vebo
	fSybHRIpVcvderaQoNwAt5KLhiDVmuToM/bNEnScO1DWDQD/h5gd09lHLBvDVYhdoJQBvf
	2vLJzwWW/pI6IaC66Vtzcnq5AeTW324=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dm8bncky;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of hare@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=hare@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753771607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G9U+Ekkinyc0L6yvrjJausFAJdfCHa5YZP9PIw+E5Tw=;
	b=AKaVeg+Q4tHrAK8wYGAbZTN73FUbED2Nj8w45A22aIWP4lrQih84oR8l10xkIYK85fjYXb
	xwbwHTSKHG4DQRaxCDPpVfD2//sNIHy3N4OO0PWVSLx6NQ9/PZV7iaeGE5jNZFRyql807P
	Sy6DXFZgzJvzELxIo1nR8oOqP+hAAOM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A883B44C3D;
	Tue, 29 Jul 2025 06:46:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24342C4CEF8;
	Tue, 29 Jul 2025 06:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753771605;
	bh=fkVU/PaDe0uUg8Y/ATbDEjMGjlyliNtfZWEmBsWcKVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dm8bnckyHtvU3N09jvHFsVT1RLH4Sz2M6rRlZDa9urX5T+bzswmZzqAYoP12+HkBx
	 3eiTlu5xrUZK+xJLpyVNmE28pSUMYEv2nRvxzyR2KJWN8ga753YmMQyKuVnpufXBRM
	 WsP9bgd9F+YLr+o1fWlJjrq8x+DV+diMa0X7UNuyC/9rfLTMcKJkpQUgaCTbbJ4qaO
	 duc0bIaAdPS7IBjUwjzr7hlLc82NNiugYgzPvuiKpsNkkt+ALANE7r7mfYeeK0SoB+
	 Ny2wL8plIpAHTDC0BMupHKqukTGN/kO8hYaagIrwtuwCpspoSr1R+b01nbat83lj6A
	 U2vgAQSQmGXpg==
From: Hannes Reinecke <hare@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	linux-mm@kvack.org,
	Hannes Reinecke <hare@kernel.org>,
	Donet Tom <donettom@linux.ibm.com>
Subject: [PATCH 2/3] mm/memory_hotplug: activate node before adding new memory blocks
Date: Tue, 29 Jul 2025 08:46:35 +0200
Message-ID: <20250729064637.51662-3-hare@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250729064637.51662-1-hare@kernel.org>
References: <20250729064637.51662-1-hare@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D44B11C0007
X-Stat-Signature: x8j4n8h3m6crx3qpzdpmbtmbysem1wb5
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753771606-391199
X-HE-Meta: U2FsdGVkX19h0MPZrSLhZPfHciNWONOOuABCNn5FRw9A8fN0nV96iH1L58v9np4UDeFOc2cBFKLKNTgTy6X9RLNva7TxMhrO+rj4p5CYlSKUOMNBHGjVaWUWlPsotk5A9rK1Sf2n1enPmSegx6RCZ4aHxYSEB1sczHvQfH/aHJQ+xRUy0isW3sRt9C/Ruw1EPz9nKOfoZL1qp7521DozEegCu3oTg+MU56vYWPJYP+/tqMWZ+yLJTrJ5ImA3RBUgiwAoLlJ9XhhdLsdMoB9yPtvgVGEFoqFpSzBIVTrXH+t3tCBnZ6mk1zpIg9j81hdBWySbtCOsgcIwAFRR/SKtbFNV9VE0dJ2caSVYD83TSKn6440FOykVGwSghIAYBeOGTtPaYCGzpcxlL2LI3zr1sWvcYcXKpAGF7WlWE0eX7nzlk6+RiBTQoLUZhoLP756MIC6g+ZG82F9nyZN/z/f/0fcC4Hh6hGCDg/krCBnuUvVWKO1Cc5I5SYNIxglrBzbPBcn7MVsSgwuJy6pSWhvM8X6b90qETVKdKx5x2HzLQrq23Sa32kyuILv0IVeiPKjDsk7IQTcok2gmLimyHOgpNatxOAXG8eyxH84oQGDFqXRP80uRA2yrgYYTYtCahb6fvwUiHpUUKugf/BTvmv7VEcflx7V+GvrEMCtLhP2b7WfaF1PhMKWkafmZtl03Z/8IQIswzkXSAFphKt2K32ZYpIs4+/YxurYH3PG0MHa7WweZj5kJln93Xka+Bkz6z27dEB+exjlQB4rwzYh7/s8uBd7N82vtAYdZ893Ofd5Zg9FbbUnZ+oROALC8ViNwf5MHik2gt5H++mlfVfhn4W1fpjcWBGqv3tWcQrqQuRz5FKWm/1pRI1lQtrkXE63IuGnDUm2QmDpkK2UGHb6tcPf+UBZaJX+p44fzxkl+WFxPOKsRbFc0Lb34R40BApZixHiGJVn3pOfX1LSQ6A+Ae4a
 v0Bps7BB
 P49wKufOfwJ2EyCtGp6PErsXwJTJPenMrZgXfj/HuWopttA0LXoLrX20XUouRL3MJeiyuhOdXiODuvvmZG8FAxUl0I1g2UBxzHT4aEqfbaH/ZbBugd5E39CzQ7MelqTXuMvzURkiCB/U92Va+zocZYl4dHtJ1CO+IiXpY1EJzAsffsmbujnwQMVpjTUaBRhIEfF3UKNAVTTGh66CoUZXrYqZnochCAD9Yu4SeLYHWiCA/+UbaqgpSMn8OQMVTMqLmjvJyB0wVVfA1imoe6kVjnPSSHP/qoY8TkWYEWiD7WJaXd6AGn32yOvgP8D19QuHHKDQw1BaIYUPntp0PvOsy5ecMOzZKf+/ABkW7x6oHFiY12eM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The sysfs attributes for memory blocks require the node ID to be
set and initialized, so move the node activation before adding
new memory blocks. This also has the nice side effect that the
BUG_ON() can be converted into a WARN_ON() as we now can handle
registration errors.

Fixes: b9ff036082cd ("mm/memory_hotplug.c: make add_memory_resource use __try_online_node")
Signed-off-by: Hannes Reinecke <hare@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Donet Tom <donettom@linux.ibm.com>
---
 drivers/base/memory.c  |  4 ++--
 include/linux/memory.h |  2 +-
 mm/memory_hotplug.c    | 32 +++++++++++++++++---------------
 3 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 894d3891292b..fb212a889e65 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -879,7 +879,7 @@ static void remove_memory_block(struct memory_block *memory)
  * Called under device_hotplug_lock.
  */
 int create_memory_block_devices(unsigned long start, unsigned long size,
-				struct vmem_altmap *altmap,
+				int nid, struct vmem_altmap *altmap,
 				struct memory_group *group)
 {
 	const unsigned long start_block_id = pfn_to_block_id(PFN_DOWN(start));
@@ -893,7 +893,7 @@ int create_memory_block_devices(unsigned long start, unsigned long size,
 		return -EINVAL;
 
 	for (block_id = start_block_id; block_id != end_block_id; block_id++) {
-		ret = add_memory_block(block_id, NUMA_NO_NODE, MEM_OFFLINE, altmap, group);
+		ret = add_memory_block(block_id, nid, MEM_OFFLINE, altmap, group);
 		if (ret)
 			break;
 	}
diff --git a/include/linux/memory.h b/include/linux/memory.h
index 40eb70ccb09d..4a29153e372e 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -159,7 +159,7 @@ static inline unsigned long memory_block_advised_max_size(void)
 extern int register_memory_notifier(struct notifier_block *nb);
 extern void unregister_memory_notifier(struct notifier_block *nb);
 int create_memory_block_devices(unsigned long start, unsigned long size,
-				struct vmem_altmap *altmap,
+				int nid, struct vmem_altmap *altmap,
 				struct memory_group *group);
 void remove_memory_block_devices(unsigned long start, unsigned long size);
 extern void memory_dev_init(void);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 69a636e20f7b..fa052001deab 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1477,7 +1477,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
 		}
 
 		/* create memory block devices after memory was added */
-		ret = create_memory_block_devices(cur_start, memblock_size,
+		ret = create_memory_block_devices(cur_start, memblock_size, nid,
 						  params.altmap, group);
 		if (ret) {
 			arch_remove_memory(cur_start, memblock_size, NULL);
@@ -1539,8 +1539,16 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 
 	ret = __try_online_node(nid, false);
 	if (ret < 0)
-		goto error;
-	new_node = ret;
+		goto error_memblock_remove;
+	if (ret) {
+		node_set_online(nid);
+		ret = register_one_node(nid);
+		if (WARN_ON(ret)) {
+			node_set_offline(nid);
+			goto error_memblock_remove;
+		}
+		new_node = true;
+	}
 
 	/*
 	 * Self hosted memmap array
@@ -1556,24 +1564,13 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 			goto error;
 
 		/* create memory block devices after memory was added */
-		ret = create_memory_block_devices(start, size, NULL, group);
+		ret = create_memory_block_devices(start, size, nid, NULL, group);
 		if (ret) {
 			arch_remove_memory(start, size, params.altmap);
 			goto error;
 		}
 	}
 
-	if (new_node) {
-		/* If sysfs file of new node can't be created, cpu on the node
-		 * can't be hot-added. There is no rollback way now.
-		 * So, check by BUG_ON() to catch it reluctantly..
-		 * We online node here. We can't roll back from here.
-		 */
-		node_set_online(nid);
-		ret = register_one_node(nid);
-		BUG_ON(ret);
-	}
-
 	register_memory_blocks_under_node_hotplug(nid, PFN_DOWN(start),
 					  PFN_UP(start + size - 1));
 
@@ -1597,6 +1594,11 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 
 	return ret;
 error:
+	if (new_node) {
+		node_set_offline(nid);
+		unregister_one_node(nid);
+	}
+error_memblock_remove:
 	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK))
 		memblock_remove(start, size);
 error_mem_hotplug_end:
-- 
2.43.0


