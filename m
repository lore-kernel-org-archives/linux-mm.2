Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30057606A326
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 06:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=GrSmFFMN
Received: by kanga.kvack.org (Postfix)
	id EACDD6B05B3; Thu, 19 Nov 2026 01:40:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0EFE6B05B4; Thu, 19 Nov 2026 01:40:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB02D6B05B5; Thu, 19 Nov 2026 01:40:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9A6386B05B3
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 01:40:59 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 297AC1A0965
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:40:59 +0000 (UTC)
X-FDA: 85450921038.01.B15F5C0
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf19.hostedemail.com (Postfix) with ESMTP id C23FD1A000A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:40:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=GrSmFFMN;
	spf=pass (imf19.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=longwei27@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795070457;
	b=xwL0TeNgzJNVx1EalyvN/0IpSMmc6RyyVID7Qa3nC6aeQnu0FppTBCmHH6aX7SS1wUIwoC
	dSGvHc7jHnATvjupl/JbHZKYC4LGWTVhOEoHBND0cocPlMl4umGrSYeTCYpZoMKw+Bh244
	sqFLoJnoVryWLs/UHIYsf9v0kcYJDgI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795070457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P6tm7LnDa5d5V2BsH/GMpXWLmcsqjeCKsjklUdm51D0=;
	b=jMAbEnwhlkIfmJJKsq7YMhbHu7jyUQ7PZHimDgQbPx4LSN9kYK2sAoRiykbjDkBevKQhDc
	laUJZjRf1tUhkw+LLvWC+8oUlIPDdWcIJdv8zD8NS5zjCCAyOg4yra0+kTZSugcR4BZJAq
	cM/Qgf19i0ntqi9zyZFl6knXIYVYSbY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=GrSmFFMN;
	spf=pass (imf19.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=longwei27@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=P6tm7LnDa5d5V2BsH/GMpXWLmcsqjeCKsjklUdm51D0=;
	b=GrSmFFMN3PMyGzQB42WLWdiPokP3GC7aB/JDex7tzaXzJ7+LujTSMa5iTXIMbhgrCmy0da8I1
	Rfqj9ZXXGlhq0rurZGTvm/1hBIe6BXZ8Ecem+RKe7F24AT/5yd/zn+wqMlEG0YJua4aKE7oo7FM
	WFAiXhx95fHvEQA3MYMihno=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4jVTNZ1MN9z12LCr;
	Thu, 19 Nov 2026 14:39:58 +0800 (CST)
Received: from kwepemo200009.china.huawei.com (unknown [7.202.195.26])
	by mail.maildlp.com (Postfix) with ESMTPS id E103140685;
	Thu, 19 Nov 2026 14:40:49 +0800 (CST)
Received: from localhost.localdomain (10.50.159.234) by
 kwepemo200009.china.huawei.com (7.202.195.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 19 Nov 2026 14:40:49 +0800
From: Long Wei <longwei27@huawei.com>
To: <rppt@kernel.org>, <pasha.tatashin@soleen.com>, <pratyush@kernel.org>,
	<akpm@linux-foundation.org>
CC: <graf@amazon.com>, <leitao@debian.org>, <corbet@lwn.net>,
	<rdunlap@infradead.org>, <linux-mm@kvack.org>, <kexec@lists.infradead.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<hewenliang4@huawei.com>, Long Wei <longwei27@huawei.com>
Subject: [PATCH v2 1/2] kho: do not expose incoming sub-blob contents in debugfs
Date: Thu, 19 Nov 2026 14:37:59 +0800
Message-ID: <20261119063800.698863-2-longwei27@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261119063800.698863-1-longwei27@huawei.com>
References: <20261117092951.4017931-1-longwei27@huawei.com>
 <20261119063800.698863-1-longwei27@huawei.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemo200009.china.huawei.com (7.202.195.26)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C23FD1A000A
X-Rspam-User:
X-Stat-Signature: 1hwfw7ssdsbpjxuxftfiqqi4pwawy7qb
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795070456-823657
X-HE-Meta: U2FsdGVkX1/4HJ2sJ3SdVD1qqQJtcBPZ9mvM3JKekWcdq/DgQhLRlXGeGF+XDw9P4bTcJyZZEHw0nCk7++QGZD75UWyzH9/5Vd41Ylo78RWxpDm8lBwuta8HhtGKoKpKhd/XpvZHhSo2JFSNssFkR5bcXMjjFpmF+251QbpARe8GMqEee95foE4uhenz4KMPLQ9MCq9n7Imm3520BLhy+szDQun3IldFVlmuvgVyufPWTrUGY9PTmaCeKrv8n0yychqGu5/wr99UBk3Ppt4nIdtn1xLmvYf7YuHwKJLdSDEgrQhf/+CQfpjlIR/tXAJOOaokN5fu/lDn6wwcdWRl32v1UMU2Dhe6Ati74wgy5HTpIOO5oAnyHUfmg/MGGLqWbzcvO/JKD6jwcttZhxlt2NBmus8S3CdHXWGFwlFla6IglXdCNK3xW/W6CGAk/nrkyiEArd39Y+YpHLdhRMqNX4MSCs6/qFJNAQu8tqn6lmBmv190F/w2YpystWYMMWaKSpbEQW9g9//tvtP13mhxqA8fqEn2BMPbWtxAipYcu7q9QwELz7pZcNelvsD23O+VBfP1iQmtNFdusU6Em8o/lgC2K4AmaG7V/iY53dIb1TcwwQbeZEuohRuZuaHn5y8CAgat/yo7Q7mCMk43jO9Lx7q3cPxnUgkufdyKs4XWxMZFazwWolMg4uHjiy5XSjraXAk6TLuPWALgckNOga+eE6CWPAIur5AXztFmdyE/yjOpeTrCyl1CkBzUa0kAuMMG4IbqJXEgPWPWmixZ7AYI8cPh/KWN11maxJ5wkId9SlTrc7kEpRVeajKl2SwstFM/gBuJbs1wK1t1v9o51Z6mUmpcGl7IylxWKvKD4oTGmkfELpPkusNQttVSBaEe4oD+kctT3mWsVgfX07hS+5zF3XOBwMWR99PKJzyxpZ4QZbhQ2mTd6XUSejCuf4WFEPjFqv3YziM83foBy5Giqiv
 Hoqc3lNO
 0C6jRCAfL+ch4R0gMv0grjT3DV3KIWeMAlv/7yeAn6lY4qm5h5LPPlC2gfFXtMXOqV3vHtix1/I6G2cpXQ5zIREPC+IS0GK/B1VSWb/XallsywdKD9Dwz5ZnkwCMXSoFhgTCtsiSkWoxbszysb0AzhxGKkzPY9DRcB2wchficdzbtrBrN3QO1Bnj3Bl+CR7+nki6et2FOQDSQM6UBl4habZlXwdnAgILnnPO6InK8BQQKUik7Z2gN4OrjgSPGMnazxq99dHazjdjBYtZCJFWY+Qkk+dojodXQFk/g/DaNouhc56HITPw7P7MjQhVR3Fs9APrczSF23QW+XcenWdqj9g5kg5Jbd6c8NQJOZWPOCuch0FkjHasURT4SzeGYDA9MdN/2pTVdSziCtgIIqjqGoE4qI+p+jh7YOkMTGnzYjAa0QnlE6VFhZJfo3I7IshbKUUC8TCJyVum5S6VfDmFk/5n+S8V6g9LxBt8T
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

Fixes: c609c144b0e8 ("kexec: add KHO parsing support")
Signed-off-by: Long Wei <longwei27@huawei.com>
---
 kernel/liveupdate/kexec_handover_debugfs.c | 47 +---------------------
 1 file changed, 2 insertions(+), 45 deletions(-)

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


