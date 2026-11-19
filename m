Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B90DC606A337
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 10:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=2VP9dmAA
Received: by kanga.kvack.org (Postfix)
	id C50A36B05F9; Thu, 19 Nov 2026 05:02:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C00F76B05DD; Thu, 19 Nov 2026 05:02:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF0356B05FF; Thu, 19 Nov 2026 05:02:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 78CE46B05DD
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:02:24 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E0260120A2A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:02:23 +0000 (UTC)
X-FDA: 85451428566.20.F65B8E4
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5AAD91A0008
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:02:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=2VP9dmAA;
	spf=pass (imf19.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=longwei27@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795082541;
	b=Xz6NPU906wAK5vIvDs4P0II4IWPrCJ59NBTQFn41ft0xoD1j/nP6zAHNvAuhFVjSnK6oEO
	3M/F1VeFUuOUT6Ibx9ly+TrRuBMA6KW9KmEmx3rhKJ150/t+GvIi/VQitYps/2ulrTQsnG
	NnZhL2Dqxs+6a8rXs2A5Wy9JKOpVw4c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795082541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=J1xrO2Y7n8BOFe6QC7CesVydiqyoOrVKZU9JIFCW6gc=;
	b=XMaj8DC4ymIwjEs5ALPfJo38WnYQCNjnZDH+9x/RkYDBrJLXlH2dPtDw/lxiRo4uRNmIbS
	6Nu/cYuzkz+HJO77ogPUJ1/rEvqTjPG1kkqcxMt28crFOaZcmSKbvVFw/mPq7CKBFMRVEK
	k15I7/0iIuql5iZj2gvLClL4cJPDZcw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=2VP9dmAA;
	spf=pass (imf19.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=longwei27@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=J1xrO2Y7n8BOFe6QC7CesVydiqyoOrVKZU9JIFCW6gc=;
	b=2VP9dmAANqSdFteXZIsBtMHxXgy3OCelrSi9r7RWeTV7SOEMBPKTGUoKrRxKXqaoIXu3LyLeO
	b8VVekInQ4nT3Ag8LPC/ugpx+E1fiIenhdwfEuJmkQLW64hixhf+oeiszAi1+nxylfdzQa0EaIF
	x9dI5GddupCRViCP9xMMLyo=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4jVYsd0Xf1z1prM1;
	Thu, 19 Nov 2026 18:01:57 +0800 (CST)
Received: from kwepemo200009.china.huawei.com (unknown [7.202.195.26])
	by mail.maildlp.com (Postfix) with ESMTPS id 930A140561;
	Thu, 19 Nov 2026 18:02:10 +0800 (CST)
Received: from localhost.localdomain (10.50.159.234) by
 kwepemo200009.china.huawei.com (7.202.195.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 19 Nov 2026 18:02:09 +0800
From: Long Wei <longwei27@huawei.com>
To: <rppt@kernel.org>, <pasha.tatashin@soleen.com>, <pratyush@kernel.org>,
	<akpm@linux-foundation.org>
CC: <graf@amazon.com>, <leitao@debian.org>, <corbet@lwn.net>,
	<rdunlap@infradead.org>, <linux-mm@kvack.org>, <kexec@lists.infradead.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<hewenliang4@huawei.com>, Long Wei <longwei27@huawei.com>
Subject: [PATCH v3] kho: do not expose incoming sub-blob contents in debugfs
Date: Thu, 19 Nov 2026 17:59:37 +0800
Message-ID: <20261119095937.826980-1-longwei27@huawei.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemo200009.china.huawei.com (7.202.195.26)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5AAD91A0008
X-Rspam-User:
X-Stat-Signature: az4wcq83qgmxfbq9onygp5ah3h991w5e
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795082539-854510
X-HE-Meta: U2FsdGVkX18sgRYGmR5n4qGy8WiBa7R/3X+7i+yTQTVnhj0WMiHz+ycm8BlzCQApkU0CXsL6BSEEDv8kRBMRnmDh+MY4hAdQzHT10II4PoOFMHXR/HE2X6Ke6cwGshi8TlFmVFdqaAZ39Mv63KJuPicgGBSViE/wNB2YXfUgUXeQVe6xHPjWqllfzTUGpMmDyoFXBWWlGESYwPN7F6/m0rOiVZxpPqxxkin8ZmRYU8zWlk0wHBMzTrx/hbvGBuNdzmyaeXSJkqytd14CMZZyUGItyaICV0XgxNaxmRA3yAjmWqlpKIIce8aosKMM8prJQNUYeYL6tqpnTUpRDN9g/dc3FjSnTwj67VGn+mDN8r3GFkryQvG+pbseG7pPCQ7SLxjlZPTf8sng91sEiFvExpKlgKMEtf9a7JoovI4dscR1hLQhvqQSPh9+Q+PBHeEcrupbKcprMS7imoY5WPBgVlSoRkr98DqQHgSNMGUueM0vaGJFuWL5TbJXVVBdBOSjD+1OeI+11LoSvlWfl7/+l6Gveboj6de4YSLGsrVYkEOwJ0Sgt8TkT9f5h1Wcdr909YLb1/rEnxuHajl3CxtKEw8p8076FVtk/uLcnaIAHUqkce+o3nxPDFde0Wt1A9vyDWBcFd+M7CF8BwkKUy/3UdbVLT5nXy9FdpjVq0TaRPQITOv/KaFX/zELKPkVnGi6KIzz5cQR7+jpW2fkjlRBK1sSaMG5ltYYUx7btKUeY7G9rX9qcN/yhs2VuLwAJ9/U2s8P2rr8Aa4o2goe1JV+Ft2CgVev7fGzd+ZxDw167q5OrzuEd7FNLVTNFUNa2p/AxxWNr7TPFOYjm5yKNT3dctv56pz4Wk65WdpiSthVMpwQzBpEkff2HIkXdnD2Od1jJ30qz+KzPPpuBGZws1pnRhkaZtAL6/0wBUS66dZIuCvXAW+2toHkcuQSgTkK85xy94lEEjRXi/PtLHKMY3z
 971OQha1
 TulmgY0JLbFfDcWebuaZugo9O66dvSfWiNcOlve5rti5JlD8QY2kkZqGChqvD6ect3Vuah45nT3RqxjQhf7MEhTXBlY2XQtzAJPNIvYtGcQEe7ExjcX+/0affUqzLvBjvZgSOuuMvzYiknc9s90QtXYsGinl8u5VqfLunMEw7QuxzLRlRJhpIieexlV+Zt8Z8a3LzGiJJYebcSWwc1k5cc/Nm3t8jxjfiTPRk4mEVEZjLy6I2KwJoeBq1sfQal2naoBySJmP/1j0Dw4KdkqvnRdvv/yDB3kHELUXV2uSsgPBRM3jq0/PRDfjAWxeEbm3CFxp6Q7DC/zRu1HjhEaRK5bDKvE8MNPH0ygn9Q0YSSblWZSIw1CKJ+wOUEQzXP3E4o8HLayfWLQqTVfG647/3e64Ijazr6ZM9W0Sc8HnzaFfQ2h0woNHFBwboIYbkkYnSiDNbWlY2hZDpqgTX8pyqVYBDmzYniJvEMlA7Fhri1/btxYPnNdFQQisLdw==
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
all.  Drop the in/sub_fdts directory.  The incoming FDT is reserved by KHO
and remains exposed as in/fdt, where the same metadata is available.

The incoming sub-blob debugfs directory is gone, so remove its description
from the KHO admin guide as well.

Note that in/sub_fdts has exposed memory KHO does not own since
commit c609c144b0e8 ("kexec: add KHO parsing support"), but the
use-after-free only became reachable after commit d376e4b55c9a0
("liveupdate: centralize state management into struct luo_ser") which
added kho_restore_free()

Fixes: d376e4b55c9a0 ("liveupdate: centralize state management into struct luo_ser")
Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Long Wei <longwei27@huawei.com>
---
Changes in v3:
- Fold documentation removal into this patch (per Mike Rapoport)
- Update Fixes tag to d376e4b55c9a0 (per Mike Rapoport)

Changes in v2:
- Drop the in/blobs metadata file entirely (per Pasha Tatashin)
- Remove unused sub_fdt_dir member and #include <linux/io.h>

 Documentation/admin-guide/mm/kho.rst       |  4 --
 kernel/liveupdate/kexec_handover_debugfs.c | 47 +---------------------
 2 files changed, 2 insertions(+), 49 deletions(-)

diff --git a/Documentation/admin-guide/mm/kho.rst b/Documentation/admin-guide/mm/kho.rst
index 902d171a780a..4281da6be5fa 100644
--- a/Documentation/admin-guide/mm/kho.rst
+++ b/Documentation/admin-guide/mm/kho.rst
@@ -117,7 +117,3 @@ stabilized.
     kernel's state is in this file in the format of flattened
     device tree. This file may disappear when all consumers of
     it finished to interpret their metadata.
-
-``/sys/kernel/debug/kho/in/sub_fdts/``
-    Similar to ``kho/out/sub_fdts/``, but contains sub blobs
-    of KHO producers passed from the old kernel.
diff --git a/kernel/liveupdate/kexec_handover_debugfs.c b/kernel/liveupdate/kexec_handover_debugfs.c
index 7d74477da0b7..3a91c47ad7a6 100644
--- a/kernel/liveupdate/kexec_handover_debugfs.c
+++ b/kernel/liveupdate/kexec_handover_debugfs.c
@@ -10,7 +10,6 @@
 #define pr_fmt(fmt) "KHO: " fmt
 
 #include <linux/init.h>
-#include <linux/io.h>
 #include <linux/libfdt.h>
 #include <linux/mm.h>
 #include <linux/kho/abi/kexec_handover.h>
@@ -97,8 +96,8 @@ DEFINE_SHOW_ATTRIBUTE(bootmem_len);
 
 __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 {
-	struct dentry *dir, *sub_fdt_dir;
-	int err, child;
+	struct dentry *dir;
+	int err;
 
 	INIT_LIST_HEAD(&dbg->fdt_list);
 
@@ -108,54 +107,12 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 		goto err_out;
 	}
 
-	sub_fdt_dir = debugfs_create_dir("sub_fdts", dir);
-	if (IS_ERR(sub_fdt_dir)) {
-		err = PTR_ERR(sub_fdt_dir);
-		goto err_rmdir;
-	}
-
 	err = __kho_debugfs_blob_add(&dbg->fdt_list, dir, "fdt", fdt,
 				     fdt_totalsize(fdt));
 	if (err)
 		goto err_rmdir;
 
-	fdt_for_each_subnode(child, fdt, 0) {
-		int len = 0;
-		const char *name = fdt_get_name(fdt, child, NULL);
-		const u64 *blob_phys;
-		const u64 *blob_size;
-		void *blob;
-
-		blob_phys = fdt_getprop(fdt, child,
-					KHO_SUB_TREE_PROP_NAME, &len);
-		if (!blob_phys)
-			continue;
-		if (len != sizeof(*blob_phys)) {
-			pr_warn("node %s prop %s has invalid length: %d\n",
-				name, KHO_SUB_TREE_PROP_NAME, len);
-			continue;
-		}
-
-		blob_size = fdt_getprop(fdt, child,
-					KHO_SUB_TREE_SIZE_PROP_NAME, &len);
-		if (!blob_size || len != sizeof(*blob_size)) {
-			pr_warn("node %s missing or invalid %s property\n",
-				name, KHO_SUB_TREE_SIZE_PROP_NAME);
-			continue;
-		}
-
-		blob = phys_to_virt(*blob_phys);
-		err = __kho_debugfs_blob_add(&dbg->fdt_list, sub_fdt_dir, name,
-					     blob, *blob_size);
-		if (err) {
-			pr_warn("failed to add blob %s to debugfs: %pe\n",
-				name, ERR_PTR(err));
-			continue;
-		}
-	}
-
 	dbg->dir = dir;
-	dbg->sub_fdt_dir = sub_fdt_dir;
 
 	return;
 err_rmdir:
-- 
2.43.0


