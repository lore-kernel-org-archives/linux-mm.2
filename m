Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3A0E606A32F
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 10:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UXOfp9RY
Received: by kanga.kvack.org (Postfix)
	id E33DF6B05B2; Thu, 29 Oct 2026 06:34:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0B876B05B3; Thu, 29 Oct 2026 06:34:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFB566B05B4; Thu, 29 Oct 2026 06:34:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD7456B05B2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:34:33 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 35769A0381
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:34:33 +0000 (UTC)
X-FDA: 85375304826.21.52BF574
Received: from mta1.migadu.com (out-91.mta1.migadu.com [95.215.58.91])
	by imf26.hostedemail.com (Postfix) with ESMTP id E89A1140007
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:34:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UXOfp9RY;
	spf=pass (imf26.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.91 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793270071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=AOkwsWmwjY7T0BagmEwjwy19sbGkrNkf9+nM9gVRFeA=;
	b=Z9G58932XrxCk9JuBRBXgcvMng0DipfzEt3rcnYI7IlCxrFYerLRiy/hdU4khdmv+6DUvg
	EjFvTKQd5kRz9jlPma3inxjjmKYs5PeUo/9qwOWVqMJXo7Bm1chD8Uwm9L8XHgKq96mHu4
	3c0US6D00D2b9daVKuMpFmagHBnXG24=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793270071;
	b=1IF6IwSkYaABsoSbT7bpB+Ezsit58drb7jewSmxu7BT648z8oe55BviDh40zmvZ6t+a58q
	rxtvvopmAnmXTtXCyhPwPhavhWCwPmQSDzU3scDWg18s5ZZ7o0oUHQqsjKeTfHVnKyy11Z
	dUF1t/IQidWqc4bzkF2XxeoZTErc4W8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UXOfp9RY;
	spf=pass (imf26.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.91 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=V9eKCFzwICKE4rFO7Nmsc0WCMFzPWjs4u+0Fk0qiHkg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793270069; v=1; x=1793874869;
 b=UXOfp9RYEVzG9pxkQUlobs6A4jb1xYE3cZWLzCOHQGck1nZV/9xfA585SJTqLRsuzC5Wd36Q
 lj4xBsZMIOrGWoGZb2gahqDlSCr3eNASR11V9aCanvfVTk8onkRsgfuJQ5v8PN8sabF8JzeIo+U
 24AXxMU3ShTpP0llLmIiyVxQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id dd12de82c714536d;
	Thu, 29 Oct 2026 10:34:29 +0000
X-Mizu-Trace-ID: dd12de82c714536d
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org
Cc: graf@amazon.com,
	changyuanl@google.com,
	akpm@linux-foundation.org,
	chenhuacai@kernel.org,
	sourabhjain@linux.ibm.com,
	liukexin@kylinos.cn,
	guodongtai@kylinos.cn,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] liveupdate: kho: calculate per-node bootmem sizes before allocating any
Date: Thu, 29 Oct 2026 19:34:25 +0900
Message-ID: <20261029103425.14689-1-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E89A1140007
X-Stat-Signature: 54mb8p6afg445ukmxfj9g3gkmhqdq619
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793270070-458963
X-HE-Meta: U2FsdGVkX18gX1WwbPXm5MbdHvz0LucTNOwGFfzqqAgZTNIztn+O0atopDNZIg8QgPyesB8YQzTTTX0lZ2cmJ7BhybuF6eMncuZM/qxy0SwphhCtrObsuru3rdp57XbK83GusVVNhWG/9Pov07c/XjdhBSe/B4niEPUMmDwQAm5cXVX1wUg000t++NKYMqNm3jdX0b6YT42wBZoAvMpH14F/Mnr3YCLNPRO1y3bmMWt2w9iPjRc4ZaNcoKEAlfTcZn4cqQnWfI4/vxhN/YpCl47YcuMTTTK9Dzj1f0bGRcGWmTUezTJHbwHuk4fDc2+nGFN59oFoHzVAGXGUnTpEb0ynn9RsHREomy9AhTMWa8RUxKRAuvEfjSTLnGU0SiJIlRR92mUpp1bnfEPYtd1ozMXie9Biz5aBsvnsBmX818DKoOG+TnJPeFPaRM6sdLQTcsQA+aL2g7lO33sbrvjUg7FaaOArry90ll1EBPC09t/CIQtb9pNsVTpc7/50PF9AEC8t0CiEuCq560kWywnpRiShb02X8N+D/+m7jV8u1g8Bdca7bo/sjmRuRbklcC/HVWOLh+eubNuThUO4hpKfsV4npGu8TAAQjLOjghRHt46j3/hURu9Lfx1ClLhDwcrItmHZ1CiXWOWfP28SXwo4GKT+b+y1S4/Mi6NgKUxpur+Jcb4U0CEW0x8MKkgXb02urSG01k8wV9TUtzpvgLfq0ezw05tKm0AmL8o+zfvx51Lkv/0x2J7mOZdcK20SGt7fKQKAsWVWBDuayno01KB3qEOVdOZ6r2ok6/HjH/8gZnl1zHUjnVcHWsobSyFqmdt0yi+KJCdwrFc7XZSBHA6NPLRp0MLlIHC4KaALEjf4aDslygGtPA0VKhZUr5od6icKeFwvWQgaz644pgx9xGi5P9GzOXVAFTLG5z9GJXGlUplZXl77KWCOFlvyg3i59FVxTihsR4l/4IjHG1rBQBG
 ZYatkqDl
 QB9XHc0v0XGXqiSyuT6CydypLd4aZU3f8czDhuEP5aPs4loQCf6Dji1bfGmQ1jXTCsn0M1TI15CLqfmhuHV41EzZDQManwtB2V9y16YNTjZOveWlXwU76i5MnkxGqxvZNHz65oZuUa3FZgO51b7i8gJqume4rQ3X2jYEdwWqyYs4LigTdMVTfhsXZFWgR+SndgqFwhY2X+axCDpSJmwOBJBMp4VZDT8qNj2xqiK9jbCSCkhfeJQ+NMtHQrLhyBJqQ9snSYJjGCLx3aVP0jbvZOchyXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: George Guo <guodongtai@kylinos.cn>

kho_reserve_bootmem() calculated the per-node bootmem sizes inside the
allocation loop, after the lowmem and global areas had been allocated.

Without CONFIG_NUMA, memblock_get_region_node() returns 0 for every
region, and memblock_reserved_kern_size() attributes a region to a node
by memblock_get_region_node(). Since allocations are marked
MEMBLOCK_RSRV_KERN, the newly allocated lowmem and global areas enter
node 0's baseline and are scaled again by bootmem_size_node().

In the original 1 GiB QEMU reproducer, the default 200% scale made
node 0 request 672 MiB: twice the sum of the 98.45 MiB baseline and
224 MiB lowmem area, rounded up to 32 MiB alignment. The reservation
failed and KHO disabled itself.

With CONFIG_NUMA=y, node-specific accounting excludes the NUMA_NO_NODE
reservations.

The lowmem and global sizes are already calculated by
bootmem_size_update() before any allocation. Calculate the per-node
sizes into the kho_bootmem descriptors before reserving any bootmem
area as well, and allocate the per-node areas from the stored sizes.
Use separate read and write indices to preserve the saved sizes when
zero-sized per-node areas are skipped.

Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
Reported-by: Kexin Liu <liukexin@kylinos.cn>
Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
Changes in v2:
- Calculate every size before any allocation (Mike). The lowmem and
  global sizes are already calculated by bootmem_size_update(), so only
  the per-node sizes move out of the allocation loop.
- Rebase onto liveupdate-7.4: follow the "scratch" to "bootmem" rename,
  and keep the zero-size node skip added by "kho: do not reserve empty
  per-node bootmem areas" by reading the saved sizes with a separate
  index.
- Explain why only CONFIG_NUMA=n kernels are affected (Pratyush, Sourabh).
- The global size over-allocation on NUMA systems, which I planned to
  look at as a follow-up, is handled by Sourabh's "kho: fix global
  scratch size calculation" [1]. Mike asked there for a broader rework
  of the sizing; this patch only fixes the CONFIG_NUMA=n double
  counting.
- No Assisted-by tag, although I said on v1 that I would add one: the
  Assisted-by references have since been removed from the documentation
  in mainline.

Tested with the KHO vmtest on a 1 GiB LoongArch QEMU guest, with the
LoongArch KHO series on top: it passes with both CONFIG_NUMA=n and
CONFIG_NUMA=y. Without this patch, KHO disables itself in the
CONFIG_NUMA=n run.

v1: https://lore.kernel.org/all/20260904025101.9959-1-dongtai.guo@linux.dev/
[1] https://lore.kernel.org/all/20260922131217.698809-1-sourabhjain@linux.ibm.com/

 kernel/liveupdate/kexec_handover.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 6f1f55fe3181..9a53d7750367 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -831,7 +831,7 @@ bool kho_bootmem_overlap(phys_addr_t phys, size_t size)
  */
 static void __init kho_reserve_bootmem(void)
 {
-	int nid, i = 0, max_nr_bootmem;
+	int nid, i, j, max_nr_bootmem;
 	phys_addr_t addr, size;
 
 	if (!kho_enable)
@@ -848,6 +848,15 @@ static void __init kho_reserve_bootmem(void)
 		goto err_disable_kho;
 	}
 
+	/*
+	 * Save the per-node sizes before allocating bootmem areas. Without
+	 * CONFIG_NUMA, new lowmem and global allocations would otherwise be
+	 * counted as node 0 kernel reservations and scaled again.
+	 */
+	j = 2;
+	for_each_node_state(nid, N_MEMORY)
+		kho_bootmem[j++].size = bootmem_size_node(nid);
+
 	/*
 	 * reserve bootmem area in low memory for lowmem allocations in the
 	 * next kernel
@@ -860,6 +869,7 @@ static void __init kho_reserve_bootmem(void)
 		goto err_free_bootmem_desc;
 	}
 
+	i = 0;
 	kho_bootmem[i].addr = addr;
 	kho_bootmem[i].size = size;
 	i++;
@@ -879,9 +889,12 @@ static void __init kho_reserve_bootmem(void)
 	/*
 	 * Loop over nodes that have both memory and are online. Skip
 	 * memoryless nodes, as we can not allocate bootmem areas there.
+	 * Skipping zero-sized areas leaves i behind j, so writes to
+	 * kho_bootmem[i] cannot overwrite unread sizes.
 	 */
+	j = i;
 	for_each_node_state(nid, N_MEMORY) {
-		size = bootmem_size_node(nid);
+		size = kho_bootmem[j++].size;
 		if (!size)
 			continue;
 

base-commit: 9a6a70aefe77f6fb9ff2b3037dcf87f6dff65c8c
-- 
2.53.0


