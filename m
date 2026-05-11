Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33F04CD37B9
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 11:18:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8967F6B00B5; Mon, 11 May 2026 07:18:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 854796B00B6; Mon, 11 May 2026 07:18:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70E236B00B8; Mon, 11 May 2026 07:18:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 60FF36B00B5
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:18:48 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D3FAA1C05CC
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:18:47 +0000 (UTC)
X-FDA: 84754891494.05.93C844D
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf10.hostedemail.com (Postfix) with ESMTP id 57474C0002
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:18:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XYKJ6fKQ;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778498326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4nZ855QhOS6+DUu6cu1Pi5l2CbbOQ+24Qk9Hlm6rENI=;
	b=2uKYzr99grj1EXs1Jvklnj4f3HeDTFomlML+L6fPGdLwk5xaS+4qrdAhuYQa64HLd5ropW
	D+68/vtMYJyGkDkSj0ysw3hhscFNKx5+25OrAVsKofcyntrcva3DF0Z5eYIurtMAwv/zOA
	f3YLzNBGA6clSOVpGh0Q9Rjymgw7ePg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XYKJ6fKQ;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778498326; a=rsa-sha256;
	cv=none;
	b=alBepw3OWTcIQU488bqZoN9UWLOc65vJ8nfn9cF0za0cunQBMe0kCOrGQuWrZUV6cbx6RL
	sbA6ktDMWd6xiQVnAixCB0ttcdRXHlc8VHta/6Cf9GVfnmeNvKgUMdMQeJ8Zk/OLrmmxMQ
	a3KCIi3d7d0H+AzBYaPBNgod7UWsu/E=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2b9fcf7c91bso40871655ad.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 04:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778498324; x=1779103124; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4nZ855QhOS6+DUu6cu1Pi5l2CbbOQ+24Qk9Hlm6rENI=;
        b=XYKJ6fKQQWrDY6Tan9k5vbS9X1EomrPYO3X4UD/NfMls6m/WM30cu3N5fGVet+Ba4J
         7fsNoZf86n6yjNobPXVtSHtUzTLnAP8L9dlbDIbCD2K5AXm6ZpmLWAS/JkPRUGmIhZT7
         Ezy3Vqo1/Yc1BVvP0R19O1hCwd/HACZBCerFE8xdreAXUUZvP6TFTA3iyXiUp+4VLc6O
         fqVT/Gc1uLqyi4wCTS4BfpwvVrjCTRcWXSMvsjN9yiHkTSumLQIPN4ayE7L8auVvqe/U
         AKdZaYJMgRbSPSTwcO6+z8s0XOXy1KdSczQMak3MyIKjwSYJyjz2WRbAbOUGq9V+v1zW
         mtXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778498324; x=1779103124;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4nZ855QhOS6+DUu6cu1Pi5l2CbbOQ+24Qk9Hlm6rENI=;
        b=CEvbpGkQx5ttSYh+LpalBKHrnQYOyqX0UAIuH4lChvAIHqxRT3TZa7rOMhoufmWlJc
         6KHzbfNzxyy7RDyMmcpDuFGMY2R6smWoVez+XNSPlrz4kXwEDxNAJBYK7JYH2RJ650St
         A0lF9P2VyelVqK9VXqrR0/wNZV2puTGUJlZ3l9S4BaQ33ZuUtRqJfNef16Sy0toCtcJc
         WyG9wyoUVydrT52T+j9+VQktawlRu8TukWi5h5RmWLz3c4093pBTViV5oFxR0b6vlAOC
         3b6GzwxWFzanK5SnH7s5y6DXyB3FKx3eq0ojxlS+Wy8nKBz4cxS3QEFZzXuiMFjEhs2f
         ul+g==
X-Forwarded-Encrypted: i=1; AFNElJ/xkOvOI5NgVXkxzo1vg5ecqJtXO5IPfM5W9XvmruBpF2kPIKr6to2BNnXNSNf6vua1E1PjEB/+Yg==@kvack.org
X-Gm-Message-State: AOJu0YxZE/PLSLzhtOwlp7sZBCQ0Sdgk2CekQohRmaHWu9vCMBDCj936
	8wJYfpTjLP44K1LUwf1DUKv20Xelk8/zTpzY/+t01u4iVetrdvAgTgZlYZQ71oxYXTw=
X-Gm-Gg: Acq92OGNauMBs0ir3LaRBmqzWC+yZNjt2Mnmu/tlZWKwkqiyA+mpMk3wEmMUEpLKnGB
	MNMOMenljEVlEVmz5tzWT0pFaLV/X6Lj6HFLyOwWo0ctLdsD3hUttSPP67hU8sRJ9y/4ToPoFQF
	SY7Gdj4m0hpLnrZjyai0pn6TOgsTTFtFZIZ6smNTcQKyCFnjrkT3QPz2AleZ/b183iEZ5EforBx
	zos7uQWStQ6FC6aJ1W/dCOeVpLva3ePr8LATf1WbWtBWiwSBYaXibRCqk4AVPouRDRxkkS+Urlm
	wZhgRph3olDGpH2TkOhzUVGL0iTXezZ5v7jbbQ6Ji8W6FwOyxbgM0yCm411G2wiICr5LUBRCuU/
	PZ4eBYYdPZ1lc3F2KhJZ6hNmPY1dB9vqa20sV0S9sZdCeAIu0S5+2dCfcUd+6TjMD2t58E+7YX7
	c275j+UBOa4plM/QswORnwGJa2HaLRyYqcVaUqx724mfA8
X-Received: by 2002:a17:903:13cf:b0:2b2:501c:bc0 with SMTP id d9443c01a7336-2ba79290f29mr226590505ad.7.1778498323836;
        Mon, 11 May 2026 04:18:43 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.101])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e75fffsm96826495ad.59.2026.05.11.04.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 04:18:43 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	linux-mm@kvack.org,
	driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH] drivers/base/memory: make memory block get/put explicit
Date: Mon, 11 May 2026 19:18:00 +0800
Message-ID: <20260511111800.2181785-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 66hsm8cd8p1sgfj51ocaxxbwueihd8jr
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 57474C0002
X-Rspam-User: 
X-HE-Tag: 1778498325-904770
X-HE-Meta: U2FsdGVkX18YvFz+NTDGgavjiMfZK75hs6uSS2x7hBPbUZH0Q2dCTKZUKUrmKe0gqKh47QSH6CHXVRBXgtYcanbyM7kfN2FkqU1/b5fmIzSfwPO+jZqX0/KtnGVJeTPNAM/bsNJkk7YsIIeRm5RaV9nRymDWQ9ualo+RIo8r+eT1B3fDxVicxpQ7DB/LA/ArpJr8hswKxTOYtMOC94Vw9XvY9So/Sue8ZTsXuzOEX7ws92G6xiBxCquyfL2kAxxK6y2UP2Zmxk+PTeTgzSCHQ7GuUqraN8Zg6lSObiQxPxKA5/h+/CsoYMemwdsbUWqsCuUEmdN3kkFdf3ovesz/B/5W0jxSQDzln1hx+eGTmnYK1I2fmY/wYkwIhh1D88WV5HenpEht+iWWDjfG92GHiWWFub908om9cw/f9ekFMOEzkVRKkRg5uP2vHYL68RUzl0li8ZwEtc2aw6ra6IsaVmNWw+E+CjjHyn4v3YwFTr+jcs3lGe/lko8Qsg7oSwtGdZTNXUuJ9yZ3PkP3ouetdTos0RN4VX9Ca4yEqRk1xakr2Ct8k1CsID37WNxO9+4IvPpAznSSfvcdAILO8pHnHOImyrr8G2tpWdfgWmchrI0Af7e+m+ih1VmBDG77ROeCtg6UeqrPgDH+Vi5C/lFbulOBPqJzbhS5fi2VSext4QUEmZhGHsPFKvGTxHMFbWMvSgfm8/zFR2v+9ll7gzEwls1+cg05XTOcXmAmEKlWMiOWNFtTK0tSkZA2h7D6jNCEd+ItlIUxUFtBMwqmwH/GLeYChGi6WykNsDz6sK1HyMx83piJtaFnEoj0kPnnxKqkrb50RiLmDa9hDpue8LCSnHD3yzyUkw5FiFbVTFSkY+gVFVnIy4LSUeDFsqb2Wft9+/DclKOH51wiYRKF9MrjE1IKV+5i+ldUSGzzMqb0X1+Fd5bhZ3kyAaMwO8U10/SfXnVwccH8LsDUbYdlzMX
 jTy8/V45
 5HhmkMu8rM/4S1+8xeifEMirue2G5flT3yFCbEh07Ei/04TyRliGT4ydKciRMGM0K8wu/cTt+EFwb0rhXkzuWjT/st/PL39c6ah1a5Ofl9UUzTNVr2i8O5gnYKFuJcbpSB/LgT4R9bRzuTyo0fzDR+2KhQ91l+R2N2tdedmGlBgNHC6mbpLubiCyixu/F40BH4FuNY9YdDH36k/5qMn1iQKA555n/bYucVAKHtY3f6hshJCvKEhHkkoaq5KyQWCR3eLAptpbhqzGuf0U26W5PFUhC9BQIj+MZ8kCBTZzB4e6GRiROy1PXCI7Yack9qzfw4CLsYJttNDimKUQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rename the memory block lookup helper to make the acquired reference
explicit, add memory_block_put() to wrap put_device(), and collapse the
redundant section-number wrapper into a single block-id based lookup
interface.

This makes it clearer to callers that a successful lookup holds a
reference that must be dropped, reducing the chance of forgetting the
matching put and leaking the memory block device reference.

Link: https://lore.kernel.org/linux-mm/7887915D-E598-42B3-9AFE-BFFBACE8DE2D@linux.dev/#t
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 .../platforms/pseries/hotplug-memory.c        | 14 ++-----
 drivers/base/memory.c                         | 38 +++++++------------
 drivers/base/node.c                           |  4 +-
 drivers/s390/char/sclp_mem.c                  | 17 ++++-----
 include/linux/memory.h                        |  7 +++-
 mm/memory_hotplug.c                           |  5 +--
 6 files changed, 35 insertions(+), 50 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/hotplug-memory.c b/arch/powerpc/platforms/pseries/hotplug-memory.c
index 75f85a5da981..94f3b57054b6 100644
--- a/arch/powerpc/platforms/pseries/hotplug-memory.c
+++ b/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -164,13 +164,7 @@ static int update_lmb_associativity_index(struct drmem_lmb *lmb)
 
 static struct memory_block *lmb_to_memblock(struct drmem_lmb *lmb)
 {
-	unsigned long section_nr;
-	struct memory_block *mem_block;
-
-	section_nr = pfn_to_section_nr(PFN_DOWN(lmb->base_addr));
-
-	mem_block = find_memory_block(section_nr);
-	return mem_block;
+	return memory_block_get(phys_to_block_id(lmb->base_addr));
 }
 
 static int get_lmb_range(u32 drc_index, int n_lmbs,
@@ -220,7 +214,7 @@ static int dlpar_change_lmb_state(struct drmem_lmb *lmb, bool online)
 	else
 		rc = 0;
 
-	put_device(&mem_block->dev);
+	memory_block_put(mem_block);
 
 	return rc;
 }
@@ -319,12 +313,12 @@ static int dlpar_remove_lmb(struct drmem_lmb *lmb)
 
 	rc = dlpar_offline_lmb(lmb);
 	if (rc) {
-		put_device(&mem_block->dev);
+		memory_block_put(mem_block);
 		return rc;
 	}
 
 	__remove_memory(lmb->base_addr, memory_block_size);
-	put_device(&mem_block->dev);
+	memory_block_put(mem_block);
 
 	/* Update memory regions for memory remove */
 	memblock_remove(lmb->base_addr, memory_block_size);
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 11d57cfa8d72..5b5d41089e81 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -649,7 +649,7 @@ int __weak arch_get_memory_phys_device(unsigned long start_pfn)
  *
  * Called under device_hotplug_lock.
  */
-struct memory_block *find_memory_block_by_id(unsigned long block_id)
+struct memory_block *memory_block_get(unsigned long block_id)
 {
 	struct memory_block *mem;
 
@@ -659,16 +659,6 @@ struct memory_block *find_memory_block_by_id(unsigned long block_id)
 	return mem;
 }
 
-/*
- * Called under device_hotplug_lock.
- */
-struct memory_block *find_memory_block(unsigned long section_nr)
-{
-	unsigned long block_id = memory_block_id(section_nr);
-
-	return find_memory_block_by_id(block_id);
-}
-
 static struct attribute *memory_memblk_attrs[] = {
 	&dev_attr_phys_index.attr,
 	&dev_attr_state.attr,
@@ -701,7 +691,7 @@ static int __add_memory_block(struct memory_block *memory)
 
 	ret = device_register(&memory->dev);
 	if (ret) {
-		put_device(&memory->dev);
+		memory_block_put(memory);
 		return ret;
 	}
 	ret = xa_err(xa_store(&memory_blocks, memory->dev.id, memory,
@@ -795,9 +785,9 @@ static int add_memory_block(unsigned long block_id, int nid, unsigned long state
 	struct memory_block *mem;
 	int ret = 0;
 
-	mem = find_memory_block_by_id(block_id);
+	mem = memory_block_get(block_id);
 	if (mem) {
-		put_device(&mem->dev);
+		memory_block_put(mem);
 		return -EEXIST;
 	}
 	mem = kzalloc_obj(*mem);
@@ -845,8 +835,8 @@ static void remove_memory_block(struct memory_block *memory)
 		memory->group = NULL;
 	}
 
-	/* drop the ref. we got via find_memory_block() */
-	put_device(&memory->dev);
+	/* drop the ref. we got via memory_block_get() */
+	memory_block_put(memory);
 	device_unregister(&memory->dev);
 }
 
@@ -880,7 +870,7 @@ int create_memory_block_devices(unsigned long start, unsigned long size,
 		end_block_id = block_id;
 		for (block_id = start_block_id; block_id != end_block_id;
 		     block_id++) {
-			mem = find_memory_block_by_id(block_id);
+			mem = memory_block_get(block_id);
 			if (WARN_ON_ONCE(!mem))
 				continue;
 			remove_memory_block(mem);
@@ -908,7 +898,7 @@ void remove_memory_block_devices(unsigned long start, unsigned long size)
 		return;
 
 	for (block_id = start_block_id; block_id != end_block_id; block_id++) {
-		mem = find_memory_block_by_id(block_id);
+		mem = memory_block_get(block_id);
 		if (WARN_ON_ONCE(!mem))
 			continue;
 		num_poisoned_pages_sub(-1UL, memblk_nr_poison(mem));
@@ -1015,12 +1005,12 @@ int walk_memory_blocks(unsigned long start, unsigned long size,
 		return 0;
 
 	for (block_id = start_block_id; block_id <= end_block_id; block_id++) {
-		mem = find_memory_block_by_id(block_id);
+		mem = memory_block_get(block_id);
 		if (!mem)
 			continue;
 
 		ret = func(mem, arg);
-		put_device(&mem->dev);
+		memory_block_put(mem);
 		if (ret)
 			break;
 	}
@@ -1228,22 +1218,22 @@ int walk_dynamic_memory_groups(int nid, walk_memory_groups_func_t func,
 void memblk_nr_poison_inc(unsigned long pfn)
 {
 	const unsigned long block_id = pfn_to_block_id(pfn);
-	struct memory_block *mem = find_memory_block_by_id(block_id);
+	struct memory_block *mem = memory_block_get(block_id);
 
 	if (mem) {
 		atomic_long_inc(&mem->nr_hwpoison);
-		put_device(&mem->dev);
+		memory_block_put(mem);
 	}
 }
 
 void memblk_nr_poison_sub(unsigned long pfn, long i)
 {
 	const unsigned long block_id = pfn_to_block_id(pfn);
-	struct memory_block *mem = find_memory_block_by_id(block_id);
+	struct memory_block *mem = memory_block_get(block_id);
 
 	if (mem) {
 		atomic_long_sub(i, &mem->nr_hwpoison);
-		put_device(&mem->dev);
+		memory_block_put(mem);
 	}
 }
 
diff --git a/drivers/base/node.c b/drivers/base/node.c
index 126f66aa2c3e..b3333ca92090 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -847,13 +847,13 @@ static void register_memory_blocks_under_nodes(void)
 		for (block_id = start_block_id; block_id <= end_block_id; block_id++) {
 			struct memory_block *mem;
 
-			mem = find_memory_block_by_id(block_id);
+			mem = memory_block_get(block_id);
 			if (!mem)
 				continue;
 
 			memory_block_add_nid_early(mem, nid);
 			do_register_memory_block_under_node(nid, mem);
-			put_device(&mem->dev);
+			memory_block_put(mem);
 		}
 
 	}
diff --git a/drivers/s390/char/sclp_mem.c b/drivers/s390/char/sclp_mem.c
index 78c054e26d17..6df1926d4c62 100644
--- a/drivers/s390/char/sclp_mem.c
+++ b/drivers/s390/char/sclp_mem.c
@@ -204,7 +204,7 @@ static ssize_t sclp_config_mem_store(struct kobject *kobj, struct kobj_attribute
 	addr = sclp_mem->id * block_size;
 	/*
 	 * Hold device_hotplug_lock when adding/removing memory blocks.
-	 * Additionally, also protect calls to find_memory_block() and
+	 * Additionally, also protect calls to memory_block_get() and
 	 * sclp_attach_storage().
 	 */
 	rc = lock_device_hotplug_sysfs();
@@ -231,20 +231,19 @@ static ssize_t sclp_config_mem_store(struct kobject *kobj, struct kobj_attribute
 			sclp_mem_change_state(addr, block_size, 0);
 			goto out_unlock;
 		}
-		mem = find_memory_block(pfn_to_section_nr(PFN_DOWN(addr)));
-		put_device(&mem->dev);
+		mem = memory_block_get(phys_to_block_id(addr));
+		memory_block_put(mem);
 		WRITE_ONCE(sclp_mem->config, 1);
 	} else {
 		if (!sclp_mem->config)
 			goto out_unlock;
-		mem = find_memory_block(pfn_to_section_nr(PFN_DOWN(addr)));
+		mem = memory_block_get(phys_to_block_id(addr));
 		if (mem->state != MEM_OFFLINE) {
-			put_device(&mem->dev);
+			memory_block_put(mem);
 			rc = -EBUSY;
 			goto out_unlock;
 		}
-		/* drop the ref just got via find_memory_block() */
-		put_device(&mem->dev);
+		memory_block_put(mem);
 		sclp_mem_change_state(addr, block_size, 0);
 		__remove_memory(addr, block_size);
 #ifdef CONFIG_KASAN
@@ -294,11 +293,11 @@ static ssize_t sclp_memmap_on_memory_store(struct kobject *kobj, struct kobj_att
 		return rc;
 	block_size = memory_block_size_bytes();
 	sclp_mem = container_of(kobj, struct sclp_mem, kobj);
-	mem = find_memory_block(pfn_to_section_nr(PFN_DOWN(sclp_mem->id * block_size)));
+	mem = memory_block_get(phys_to_block_id(sclp_mem->id * block_size));
 	if (!mem) {
 		WRITE_ONCE(sclp_mem->memmap_on_memory, value);
 	} else {
-		put_device(&mem->dev);
+		memory_block_put(mem);
 		rc = -EBUSY;
 	}
 	unlock_device_hotplug();
diff --git a/include/linux/memory.h b/include/linux/memory.h
index 5bb5599c6b2b..29edef1f975c 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -158,7 +158,11 @@ int create_memory_block_devices(unsigned long start, unsigned long size,
 void remove_memory_block_devices(unsigned long start, unsigned long size);
 extern void memory_dev_init(void);
 extern int memory_notify(enum memory_block_state state, void *v);
-extern struct memory_block *find_memory_block(unsigned long section_nr);
+extern struct memory_block *memory_block_get(unsigned long block_id);
+static inline void memory_block_put(struct memory_block *mem)
+{
+	put_device(&mem->dev);
+}
 typedef int (*walk_memory_blocks_func_t)(struct memory_block *, void *);
 extern int walk_memory_blocks(unsigned long start, unsigned long size,
 			      void *arg, walk_memory_blocks_func_t func);
@@ -171,7 +175,6 @@ struct memory_group *memory_group_find_by_id(int mgid);
 typedef int (*walk_memory_groups_func_t)(struct memory_group *, void *);
 int walk_dynamic_memory_groups(int nid, walk_memory_groups_func_t func,
 			       struct memory_group *excluded, void *arg);
-struct memory_block *find_memory_block_by_id(unsigned long block_id);
 #define hotplug_memory_notifier(fn, pri) ({		\
 	static __meminitdata struct notifier_block fn##_mem_nb =\
 		{ .notifier_call = fn, .priority = pri };\
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 462d8dcd636d..890c6453e887 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1417,14 +1417,13 @@ static void remove_memory_blocks_and_altmaps(u64 start, u64 size)
 		struct vmem_altmap *altmap = NULL;
 		struct memory_block *mem;
 
-		mem = find_memory_block(pfn_to_section_nr(PFN_DOWN(cur_start)));
+		mem = memory_block_get(phys_to_block_id(cur_start));
 		if (WARN_ON_ONCE(!mem))
 			continue;
 
 		altmap = mem->altmap;
 		mem->altmap = NULL;
-		/* drop the ref. we got via find_memory_block() */
-		put_device(&mem->dev);
+		memory_block_put(mem);
 
 		remove_memory_block_devices(cur_start, memblock_size);
 

base-commit: e98d21c170b01ddef366f023bbfcf6b31509fa83
-- 
2.54.0


