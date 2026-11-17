Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAFE9606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 09:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=f3ZdQ60x
Received: by kanga.kvack.org (Postfix)
	id C1A8C6B05B9; Tue, 17 Nov 2026 04:32:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA4196B05BA; Tue, 17 Nov 2026 04:32:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADFC96B05BB; Tue, 17 Nov 2026 04:32:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 757476B05BA
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:32:39 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0292D8036A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:32:38 +0000 (UTC)
X-FDA: 85444096038.28.DF077A5
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf09.hostedemail.com (Postfix) with ESMTP id ACCEE140006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:32:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=f3ZdQ60x;
	spf=pass (imf09.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=longwei27@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794907957;
	b=nVAUNo8rMCpY9QlTkFSvTHrr/ZiLqHm14eULgucTfwolw+/GL+TJZ6iE9U1NTKR9gNtTC9
	etF+G8R0bznIXa7jX/IgHxyO9ZNV1gR5gMKOUUiB25cnfopKgp7+lDQnWPbtfJLv1Gxqma
	52aPd36kwhj5ALtPchQJl+7lgHArnAs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=f3ZdQ60x;
	spf=pass (imf09.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=longwei27@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794907957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zHwBqsQb9hP55ypvUI19hlmY7GweiNLDeIgyOcU9CWw=;
	b=G3IuLgS/EtadeeG31OimQsUXzMFofMqSaK8bz3i9cAXKfFsZMK96oC8gkVdkr6P35FYMky
	XCoaOpxzOXlChSBPOzdZhloXBzIMdeI2/6nQzUCfphmXJVx9GXvlYqZSBNrMCNL+62xXNY
	NjMsz3Dfnmm6maK8McJYYBax5jZq9f4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=zHwBqsQb9hP55ypvUI19hlmY7GweiNLDeIgyOcU9CWw=;
	b=f3ZdQ60x7H6wkqChDThls46W0Cj8FBQAHmiIa2fPUjDGijQ4dOv7D+oAtVagCiJ6Y96aOrW8F
	5Nc5Wc/8DtGot3qg+pz3zAiXQQhbTHWiVF/Pwl+NCdzsQSvh8YdiDFDzlzGqx7vrBzCorEkL3Vn
	xMCAL4zk+rj9c2qSoUi9jkg=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4jTKJC17c9zLlTR;
	Tue, 17 Nov 2026 17:32:11 +0800 (CST)
Received: from kwepemo200009.china.huawei.com (unknown [7.202.195.26])
	by mail.maildlp.com (Postfix) with ESMTPS id 1C1CB4055B;
	Tue, 17 Nov 2026 17:32:30 +0800 (CST)
Received: from localhost.localdomain (10.50.159.234) by
 kwepemo200009.china.huawei.com (7.202.195.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 17 Nov 2026 17:32:29 +0800
From: Long Wei <longwei27@huawei.com>
To: <rppt@kernel.org>, <pasha.tatashin@soleen.com>, <pratyush@kernel.org>,
	<akpm@linux-foundation.org>
CC: <graf@amazon.com>, <leitao@debian.org>, <corbet@lwn.net>,
	<rdunlap@infradead.org>, <linux-mm@kvack.org>, <kexec@lists.infradead.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<hewenliang4@huawei.com>, Long Wei <longwei27@huawei.com>
Subject: [PATCH 1/2] kho: expose incoming sub-blob metadata instead of contents
Date: Tue, 17 Nov 2026 17:29:50 +0800
Message-ID: <20261117092951.4017931-2-longwei27@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117092951.4017931-1-longwei27@huawei.com>
References: <20261117092951.4017931-1-longwei27@huawei.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemo200009.china.huawei.com (7.202.195.26)
X-Stat-Signature: o4ow1z353sjxnxg7a4xe8wmyzxxhk5wa
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: ACCEE140006
X-HE-Tag: 1794907955-723646
X-HE-Meta: U2FsdGVkX1/wyIzjdn0uY0YRCyOfUGpNk9xfPZAQik5tGiEWLHlAZOxc8XAo68BnPt8OhoWsk4LB9XrW1mlgmNNeZ2VOgqtw6WHF9k7m8/iLkCkmZRhg4jjCuSCR63p/rdeDYASqikfpVF+4qCBFmuDaA4gCVOGlWFIlOhPhdKaNsEKrFSTEAy/rMw7eVW9VC7/aUDVjf9MLucu/e8toaBprIQ5+dgormz+76CppcndaUWe78lExbRg+5J2dB/O7j0KoHxhmOF53sa4TeHmxXnbbVP9yfrCBoFbeoGQUzvZK99P/QIivpN0pazMfBwWtrRVF2nHv7MArQ1O5s3oMwDoqsLbzq82b6F+EMHpQqKF+CutidBwuEMFdHTVFV7VyHuX/tNUGv71/PbKFq5QPl1JT+agfzQxos5jrXCeZ07gmJDr3kdH1gfhKom8w4dhrMIopJR66/xi63RXtMTyrrQcsn441fhWcuFLyaMlhR2+Mi+gxwTbk9Vs9P930J/ViqB1cN2KRf2Van45KCxZcrQatZgv1Uhr7Cos+xXRFfuvqXJQoVaSVcuJun24jEgjQKD5CRyGoYUIsxBWrxir1203m//WRVv1kYYQxELq8dmVl4xojT0oARszuggd3y4bguQDfp0/XvSN65C0JPg5O7Eb7Naj+3v0BckxEcgr1pYUU01qneZ6ceIEr7NTncEb7ffMwUKtFLBaAMM5AWIS4bDKzWj9AWjU4aHl/wwuzfsaYc8aIOLxBz2sHcwDk0tWAVN0/AAT+8bL6xGCd1zaoeIEMNqQVj8yc+EGSlzSB0870p60uwltCEIspXKBdpspM3hOUpv+/ocMKNrfnFz3yZUPmdC6SfTx2ns/Dn22YrEmEL+gfif2maVx/e213Rdwz6WnucIim3ojxjqi8v+jf2UVJ27M7Pr0WaSeL6ywtkpdUYeKi+DExsBMT9Ah2cJJ9u8NGW7rnw6D/uMF8wRX
 6Jkvj6ue
 VPd6Y491ae5kWz6vxtUaSi1eM9gHropopiT7GHgm8JpqACs72W9gynvm3vxPy3pnbAbwSy2Sg7g7YkbPXIr/ESvIvHKa8IyncsNTOY8tudtyEdEvXAnfvjNTOsGCqkdeGraK2qKrePZ7LiiE1+bFmoWtp5tU92ugeUm8V/4nvr+f/rX4jN3cYR4ABvo3ffYuxd8cNwJW82NQ/mJPSgpzYLt70NN96aD6pUEMOucOz/eNXwiNcBr2mJWjSWuXnFsk2AEz9qCExe1v+cVee+1/nWO7lHlEfyzhMI5eC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Incoming sub-blob pages are owned by their consumers and have independent
lifetimes.  Some consumers, such as LUO, restore and free their state in
early_initcall, i.e. before kho_init() (fs_initcall) builds the debugfs
view:

  early_initcall: luo_early_startup()
                    -> kho_retrieve_subtree("LUO")
                    -> kho_restore_free(luo_ser)   /* page is freed */

  fs_initcall:    kho_init()
                    -> kho_in_debugfs_init()
                         -> phys_to_virt(luo_ser_phys)
                         -> debugfs_create_blob("LUO", ...)

debugfs therefore ends up pointing at a page that was already handed back
to the page allocator, and reading the file triggers a use-after-free:

  # cat /sys/kernel/debug/kho/in/sub_fdts/LUO
  ==================================================================
  BUG: KASAN: use-after-free in _copy_to_user+0x37/0x60
  Read of size 32 at addr ffff88810309c000 by task cat/27436

  Call Trace:
   <TASK>
   kasan_report+0xb9/0xf0
   kasan_check_range+0x100/0x1b0
   _copy_to_user+0x37/0x60
   simple_read_from_buffer+0x77/0xd0
   read_file_blob+0x75/0xa0
   vfs_read+0x12d/0x520
   ksys_read+0xc3/0x160
   do_syscall_64+0x97/0x4b0
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
   </TASK>

  The buggy address belongs to the physical page:
  page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x1fd
  pfn:0x10309c
  flags: 0x17ffffc0000000(node=0|zone=2|lastcpupid=0x1fffff)
  page_type: f0(buddy)
  ==================================================================

The page is already in the buddy allocator (page_type: f0(buddy),
refcount 0), which confirms it was freed before the debugfs view was
created.

KHO does not own these pages, so it cannot safely expose their contents at
all.  Drop the in/sub_fdts raw blob nodes and replace them with a
read-only in/blobs metadata file that lists the name, physical address and
size of every incoming sub-blob.  The FDT itself is reserved by KHO and is
still exposed as in/fdt.

Fixes: 062dd306d99c ("kho: fix kho_in_debugfs_init() to handle non-FDT blobs")
Signed-off-by: Long Wei <longwei27@huawei.com>
---
 kernel/liveupdate/kexec_handover_debugfs.c | 83 +++++++++++-----------
 1 file changed, 42 insertions(+), 41 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover_debugfs.c b/kernel/liveupdate/kexec_handover_debugfs.c
index 7d74477da0b7..3624d4bf44b2 100644
--- a/kernel/liveupdate/kexec_handover_debugfs.c
+++ b/kernel/liveupdate/kexec_handover_debugfs.c
@@ -95,67 +95,68 @@ static int bootmem_len_show(struct seq_file *m, void *v)
 }
 DEFINE_SHOW_ATTRIBUTE(bootmem_len);
 
-__init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
+static int kho_in_blobs_show(struct seq_file *m, void *v)
 {
-	struct dentry *dir, *sub_fdt_dir;
-	int err, child;
-
-	INIT_LIST_HEAD(&dbg->fdt_list);
-
-	dir = debugfs_create_dir("in", debugfs_root);
-	if (IS_ERR(dir)) {
-		err = PTR_ERR(dir);
-		goto err_out;
-	}
+	const void *fdt = m->private;
+	int child, len;
 
-	sub_fdt_dir = debugfs_create_dir("sub_fdts", dir);
-	if (IS_ERR(sub_fdt_dir)) {
-		err = PTR_ERR(sub_fdt_dir);
-		goto err_rmdir;
+	if (fdt_check_header(fdt)) {
+		seq_puts(m, "invalid incoming FDT\n");
+		return 0;
 	}
 
-	err = __kho_debugfs_blob_add(&dbg->fdt_list, dir, "fdt", fdt,
-				     fdt_totalsize(fdt));
-	if (err)
-		goto err_rmdir;
-
+	seq_puts(m, "# name pa size\n");
 	fdt_for_each_subnode(child, fdt, 0) {
-		int len = 0;
 		const char *name = fdt_get_name(fdt, child, NULL);
 		const u64 *blob_phys;
 		const u64 *blob_size;
-		void *blob;
 
 		blob_phys = fdt_getprop(fdt, child,
 					KHO_SUB_TREE_PROP_NAME, &len);
-		if (!blob_phys)
-			continue;
-		if (len != sizeof(*blob_phys)) {
-			pr_warn("node %s prop %s has invalid length: %d\n",
-				name, KHO_SUB_TREE_PROP_NAME, len);
+		if (!blob_phys || len != sizeof(*blob_phys))
 			continue;
-		}
 
 		blob_size = fdt_getprop(fdt, child,
 					KHO_SUB_TREE_SIZE_PROP_NAME, &len);
-		if (!blob_size || len != sizeof(*blob_size)) {
-			pr_warn("node %s missing or invalid %s property\n",
-				name, KHO_SUB_TREE_SIZE_PROP_NAME);
+		if (!blob_size || len != sizeof(*blob_size))
 			continue;
-		}
 
-		blob = phys_to_virt(*blob_phys);
-		err = __kho_debugfs_blob_add(&dbg->fdt_list, sub_fdt_dir, name,
-					     blob, *blob_size);
-		if (err) {
-			pr_warn("failed to add blob %s to debugfs: %pe\n",
-				name, ERR_PTR(err));
-			continue;
-		}
+		seq_printf(m, "%s 0x%016llx %llu\n", name,
+			   (u64)*blob_phys, (u64)*blob_size);
 	}
 
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(kho_in_blobs);
+
+/*
+ * Show the metadata of the sub-blobs referenced by the incoming FDT.  Each
+ * line contains the name, physical address and size of a sub-blob.  The raw
+ * contents of the sub-blobs are not exposed.
+ */
+__init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
+{
+	struct dentry *dir;
+	int err;
+
+	INIT_LIST_HEAD(&dbg->fdt_list);
+
+	dir = debugfs_create_dir("in", debugfs_root);
+	if (IS_ERR(dir)) {
+		err = PTR_ERR(dir);
+		goto err_out;
+	}
+
+	err = __kho_debugfs_blob_add(&dbg->fdt_list, dir, "fdt", fdt,
+				     fdt_totalsize(fdt));
+	if (err)
+		goto err_rmdir;
+
+	debugfs_create_file("blobs", 0400, dir, (void *)fdt,
+			    &kho_in_blobs_fops);
+
 	dbg->dir = dir;
-	dbg->sub_fdt_dir = sub_fdt_dir;
+	dbg->sub_fdt_dir = NULL;
 
 	return;
 err_rmdir:
-- 
2.43.0


