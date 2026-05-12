Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 918ABCD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:27:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06C1A6B0092; Tue, 12 May 2026 03:27:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01C396B0095; Tue, 12 May 2026 03:27:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4D7E6B0096; Tue, 12 May 2026 03:27:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CE4A96B0092
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:27:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 654FDC1A97
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:27:08 +0000 (UTC)
X-FDA: 84757936536.10.F0B7B05
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf26.hostedemail.com (Postfix) with ESMTP id C021014000E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:27:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="hN9grx7/";
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778570826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fx4e8OAen0NF75+J/YmhI593eekBwMCjX/uv6e51cmw=;
	b=VlprE9k0dCZotAzXjDMSu1w2AokmtAUvWcdcdzkuwU1Mm3lNSJLgVCtRcrKGx46nt2B/Lw
	CfZa7itxAf/5a/2jmXuqBI0wKLw53hvm4Y01qFK48Nlb8ra8TJqYYnvN4js5cJMnfixHzn
	M/84+VLI9trzig6Rg1J+WboBa2EFlfY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="hN9grx7/";
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778570826; a=rsa-sha256;
	cv=none;
	b=1niYLJnSUtvoYbhofDffjnUx7mIYqymIfPMLe5lNmSiegT0pML+RuzNte4iOIvIhfe6arn
	EAhOv698Ui9oEdHGaxEIkAqPdC/eBpVtALqDE7NCIVEGEW/ADr+U10QVIs1lJjMQbnr4Yh
	l9CGgkkth/iE1PTRoA5S95MnUKSz0oc=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2adff872068so27728945ad.1
        for <linux-mm@kvack.org>; Tue, 12 May 2026 00:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778570823; x=1779175623; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fx4e8OAen0NF75+J/YmhI593eekBwMCjX/uv6e51cmw=;
        b=hN9grx7/cgRNnZBV1Hi53gcg1xvd8H3k7pbUvdUfEiQJ8UqWxPpBDBgiSIFBiuAJUc
         wzsw5RfeOFaJSNfImKsrYeUq3qh9J9wLBKCji5MGrGRhewrzfT8tcoKLu4jbahwCcmx6
         CoSUDuvqjFN/TncT7Vc+R1LrfnxPBSs0gNgWVTZGB6hloHohgpUlAlfkp7KPD53NnMsk
         OIdQkRkWTQO4eJtGFcF05oUUhm6pRXVcPy8+Va9R7UvVdX0Zj1xTbRDlv/PsPUxXdwRj
         jwyejBjDiDM+AtLKh2pGhYycZcboZFs5soAzsW2zV+OD5tc9AdGK70ZF1GnXWf9dGV8E
         EZMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778570823; x=1779175623;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fx4e8OAen0NF75+J/YmhI593eekBwMCjX/uv6e51cmw=;
        b=W+JfrRatoxgrfgg4JGpWn3hm8iT2mss97Zr8QWg55JF0t7kHZJytahTAB63yFpV8tM
         g/dlhgcC5YgcL/QBTql3vwTyUKtm7iyXsMOI3k3iZckSgGnA3qQxgPalxuLpABYWrJCN
         wdz3XeOA/HVlCy9A+pWe+4wjrIfvyRv8vIyKRbPju7H67kVIgHC1vxJtnWgGupl0vBCI
         Rb7vcRprGt34xaH21xe9f2XnRgdvg0Y3Eweyf6SJxmXUc0djzefxZX0Jp/2JBwWKcfjS
         BI4rFu/S0XW6cn7DmjFuxRvjzhHozWjrnsKRON63eTjsMT2OCLbqYHVeowzKSKP2yXrj
         nmuA==
X-Forwarded-Encrypted: i=1; AFNElJ9E3wGILRc8wXE5EaT/YMmHDrmb071qFTNKMl4hc64z38+V17a4fhXkLpLBQEcBj+OmAIpxxzC7cQ==@kvack.org
X-Gm-Message-State: AOJu0Yw1oVF1DgkyK/sbiC4HsuJgMJFuTdC8LC9T3S4JdUqs6K8Ubsm6
	LInWtEosop5MdyqRaMxpoN85B5Fy7n/KintwamFZlCFzUlZ/77zD8jXZiTH04Gp9RUk=
X-Gm-Gg: Acq92OEmir0y0sOvnMoMnEPw/3Gqm4Rl3qdt32B4i3JZSMP3+p9cpU4+nN0w/pRhv3E
	oheHbiLJUQmdIfZe+PtK7irez/sIiAWkiz8IKInc+WrnjsowHfpJBl6lMmk6mQTyYhSFQn6R8TB
	b7lVxmepI/nnY1sjT+qI9xN2fBP9yCGMODXxknV+WRB7G1eOFAAnYdoo2s5aUz33QCsVEzOCV6S
	STiy68LXvl7zulKegBZDcC3xZZyLHTKkOj+X3aI//UZD+LhVxueu9mQGmoq7JdQIfQT7ocIYHkA
	Bq6HDoNsAoYlAO20/DVETCcrSNo3X0UY1+JzoFtHhmHB05Oz0guyf4+isHWNLVsgDmwLp40ImQw
	F6XC72UV/D7MTJfw7HUU4JaDGzn036CWbR5wrjGx7atcVUEAx53qZmdRenOwgJpQwb1XzmFZrHX
	oQ+Jd2G/rnJiXJDMynIA==
X-Received: by 2002:a17:902:c401:b0:2bc:ebb1:e3a7 with SMTP id d9443c01a7336-2bd012b3330mr24218975ad.32.1778570822529;
        Tue, 12 May 2026 00:27:02 -0700 (PDT)
Received: from n232-176-004.byted.org ([240e:83:200::343])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d2700dsm129200635ad.2.2026.05.12.00.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 00:27:02 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-mm@kvack.org,
	driver-core@lists.linux.dev
Cc: Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Kees Cook <kees@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Donet Tom <donettom@linux.ibm.com>,
	muchun.song@linux.dev
Subject: [PATCH v2] drivers/base/memory: make memory block get/put explicit
Date: Tue, 12 May 2026 15:26:35 +0800
Message-ID: <20260512072635.3969576-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gcmmiji59ygrtf3sooocpnhtkq83yktx
X-Rspamd-Queue-Id: C021014000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778570825-861629
X-HE-Meta: U2FsdGVkX18a70VdlL4APFTnoDcvwesI4ZQ6CBO/Dl2GgssHedkWvTnnbP6uyT9S4hqfJPfNy7LKYPdg3qMXGtNZ1nmvyLRN13FTI9IKqKljDVBTVD71Gqx9Y9BIwrnzd0eFRDIWYt6XaXJjcHQ9uJ3bse0CoOng0m2IXlsFHvqAXqUwKtcnTo666vh3LddsWiiq2IThY0jtZn4voF/bkVZf1+ntngzu67pF40UEmtXn7x9BMTJLmwNCdMmthmvXSzjWGZfhPXAn6/kd3f26+45CgwpCWVJVXI7KG+w9MZfXQthF5E2g5pbx5lIdfvKac2O8cknbZtMT6YiHy1E/soTuHB1PQfg8gcyE38A+Adk4pjqpv8HSIZqU0lxn4f3AhikSroCS8Y79HQsyIIAzYchaygbZ6fKJcv6B+RgIdOoQD4QHUt8pVW2Wg/m0KoKv0I9s5oN1PgfLRN/08pu4XjW2KCcNTpVwa+JeCbVDLofkPRHoDfW+b5uFm/nVq+HPcxjEtlWBGKHPmHQHm6neRShVArr+cXGS4iPxkgKJT+lv6c+QE3Z/2eGGaXxln6Lhvamzh0IPK/Y+7G079NjHCmRGUwo0Wiu43kRM1u2nsWTuWzrUac8VtpcmONJ+NKPrznK2zkC3645NMa/yEI54iiiZlo7O2Osg5o3bznduJ52r7bmhcKvhNyeSuEPg4PBld/KpESwSrJNMMGN/bBl9Ot1q3LfFhyQTAWviTybZiLrE5HKvKeS4lWk3LPllUWoQyJ5nZiy7g6RCqfPP34KM1opgKLsLqEX//2p8PUgSQbkYhgXH+m2ALbf9IueJ8JuHpYvw7mHu5TSJLp/md8BKEFyDDPM26CRRsy4ULDbG9clNYeBDL0/NR0w4zBE6j0GoIU+0Vh9R9Gl+JS9mQrxYg3Eyq+isPGsHQMYwi7r3TKM3r8isuPDBCY5WREw2gkw5JQ+EY+M1pf9RSl6RDqq
 doWkJmm/
 Ez57ObjtzMwTJfRLdQ51+WFo0GEM3xqkUY7YZ3m+T/cZS7cxEdcefBSmKsa/b2qZmchikQxBrvcdvxh9xik4fAKG/OGLZucb6LINnPXgFJaSntP4opCwWNZBDUCg9QXFyAF99y/j1LqG+4PK85XYBhiGCPAjptzpsfr5HlMup5lvQx8SG3PpyHBaZXrGv1H0ehMJAxTc6uyX1iuiwhefj/cxfprNNnpIemXIm+P9dcOuIKLjFf5VSWdD53C/J7R+2ilk5DrEWlk0/HZPMXveJ4xyGQe02XbvZdvx2DVlV5O2K8ca7CH7TKA84W7G8JXaJp5Q+hPuOsVojBzxucjqJb4Oc2suZi0MEmqtWaAknKk65Qzhx2lfUIESFJgJ1+O3ZIwSvvfFNSIJo+JWk+nkGHSV4ThVr++fjehpdkVSVTZIWYiw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rename the memory block lookup helper to make the acquired reference
explicit, add memory_block_put() to wrap put_device(), remove
find_memory_block(), and use memory_block_get() as the single block-id
based lookup interface.

This makes it clearer to callers that a successful lookup holds a
reference that must be dropped, reducing the chance of forgetting the
matching put and leaking the memory block device reference.

Link: https://lore.kernel.org/linux-mm/7887915D-E598-42B3-9AFE-BFFBACE8DE2D@linux.dev/#t
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Tested-by: Donet Tom <donettom@linux.ibm.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
---
Changes in v2:
- mention the removal of find_memory_block() in the commit message
- drop the redundant extern from the memory_block_get() declaration
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
index 5bb5599c6b2b..463dc02f6cff 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -158,7 +158,11 @@ int create_memory_block_devices(unsigned long start, unsigned long size,
 void remove_memory_block_devices(unsigned long start, unsigned long size);
 extern void memory_dev_init(void);
 extern int memory_notify(enum memory_block_state state, void *v);
-extern struct memory_block *find_memory_block(unsigned long section_nr);
+struct memory_block *memory_block_get(unsigned long block_id);
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


