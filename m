Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF381F9D0F7
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 20:02:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51A116B0092; Tue, 14 Apr 2026 16:02:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42EBC6B0093; Tue, 14 Apr 2026 16:02:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31D4E6B0095; Tue, 14 Apr 2026 16:02:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1EBE06B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 16:02:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CEAFBC1442
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 20:02:45 +0000 (UTC)
X-FDA: 84658234290.01.76055E0
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	by imf25.hostedemail.com (Postfix) with ESMTP id DFA82A0018
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 20:02:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ONiRCwDA;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776196963; a=rsa-sha256;
	cv=none;
	b=JvQgVAR7fSksXmbM3gMKFLkpqyziOhrRG4a4219DVJcL80tFkQtgI7iDzQfSEQBe/7iX2W
	0SGisIxtBDeDUwd6vIzI8gS5vHsQvi3YLKi9RR4exFuM3naNJDJ1YOCYReMlqDSMdN8mHN
	uD17yqvGqDud0BBCvi+cFDliOMtZm9Y=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ONiRCwDA;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776196963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gGBPIgM/WV5ZDiKpyCtZbuV6OrCUIPCWn13n/Yh3SQE=;
	b=i3F3bn0HPwC3igDP8SskDPt75zrYGw40NYwpt3W8TdJsWckh3FvkVt/Ls5KEjWzLFm2/lR
	D/G7GwYXGgL0n+TBF9OVtMfeuPnxnp2eJrcHES7X9gB9zEvlOTSl2dz08JlC4wjgEcRMML
	wwh6hYRCFiRQg9IVrRFF5RzdjBCUWxc=
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-9568159ee07so1647653241.1
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776196963; x=1776801763; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gGBPIgM/WV5ZDiKpyCtZbuV6OrCUIPCWn13n/Yh3SQE=;
        b=ONiRCwDA5ngmmlHcez+45k09QfrUxGRu6BeF3BccuJ01SAQmMF0VCy8XdPopi5V+Vw
         nf04jn6YBBcDzZHmM5TCwb42KOmEGVmqvkghUMq99ICiKyLaoIAW+Z1sTkjolr5jnNb2
         IAF83PDJM1/WcMVIH3Di4hyZ7HxQ/uy/luzPq2ez4if77L32UBCepFsPvEiprVok1eak
         x4Ahk9W0TA+0o1tETiFplNVUJdeEvAF1PLAirrvBK8xpngwouxV57I90anqgOEko3H2q
         YKaYSwJuQSvl6o1eh7p+Ll/rdb8JWVxHvtY6U9PYGDArR6PR1sDrUDrqLsvAM1oaxoQz
         jdJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776196963; x=1776801763;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gGBPIgM/WV5ZDiKpyCtZbuV6OrCUIPCWn13n/Yh3SQE=;
        b=RlJeUpm45NV68CUFASoNCkxwvKzQpdPk1rC0zj3iPeCy7DZgDfwW1r/pFlSPpVuCB+
         JrYbmito31Aor/+sLxBOgLNY65KWDY5Gtk3d8Y9dxq13HSMDXVS+F7wpcPG0lB0xW06N
         rAWPB1WAWHOnDDL0SCNdp8rRXo6zLFSeAhfp2NDyNwPWEKQV0baVtmg7hh3t2xylUYIx
         hDGZVukjUPr2ZJlghaR993OjF3pq2F9zeT4mJs0Te7eKOx8GTmEsWqcQQsiASeKtrFy1
         7hrabqmEcl5VzZWEBDXuX+zHO1nQyOFCajFmjLGwwn86CJ5tsM8yvWoQJgN2y+Q4PdVw
         bZJA==
X-Forwarded-Encrypted: i=1; AFNElJ+aDo9abQSO6fMB/e5d8UpMdMra2K9mvWEWRQnSQGKzfc+3eumNw71u8r3/dr7tMMtPBZSsAYf6tA==@kvack.org
X-Gm-Message-State: AOJu0Ywbuo1gPq/WkXBaepYEahZW3XBDUNxZVmzhArm3KLA+4pnKUiwY
	yfxmzfPlgBiFnybQ9tISKOnU5o3OUvgokoejwSjLIQVPNce93oY8FaycyAs7QbX1aqw=
X-Gm-Gg: AeBDiesGOSlEG08nfGEe8F+JrINcR2UPBjzPF6VuzXU0NOzW23ZpGwOE6BUzOW8WVUh
	ZHA89KciB10LHSXMdVywTx7iYuJxBxpV3Zhj7hTjgNuLS/unwahFGLmJ09o/ZPGEE2bafPn0cu9
	JWpkXjBJGSBa5QmSPrTPYxDDVpgWSmmuScpl4xUkMq1LSOA3K5Lcw9bxtZk2NJh6J6PvLkJKsl+
	F2Gs6bbGJwMzqsX2tKz9CnyB/mndOPE0qIfZSux1RTCBy0fIaqxQAe8bbFDq9XzEgjG3u/ZY0+O
	35OkVi7XqqxDPgkuprg/gQpygRXWv/KQ27J7zW076fi2TtkdIFJBBF0O+1nCcKGshUvoCXtUbVh
	wSGAeqKoiNwvghXIU2Kb1bsfLVPdfgi8kPSSGt4r+Gs6S5lajLBjUsG6ow6OvFUu86AVCcOkY2k
	4ndMRe2tRxikBqmSWuWidyIV14FbGezoD3XVMSjr08pFLG1luDT+eAiwpXK3n1/cS0cKMQI/j3q
	hSL
X-Received: by 2002:a05:6102:5043:b0:604:ee6f:17d with SMTP id ada2fe7eead31-609feaaaca6mr8735682137.8.1776196962686;
        Tue, 14 Apr 2026 13:02:42 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ac84a180a2sm132213656d6.15.2026.04.14.13.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 13:02:42 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	skhawaja@google.com,
	graf@amazon.com
Subject: [PATCH 2/5] liveupdate: Remove limit on the number of files per session
Date: Tue, 14 Apr 2026 20:02:34 +0000
Message-ID: <20260414200237.444170-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260414200237.444170-1-pasha.tatashin@soleen.com>
References: <20260414200237.444170-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DFA82A0018
X-Stat-Signature: jsy3inhfup81iyaiz1m3ruwoha98g7x9
X-HE-Tag: 1776196963-605059
X-HE-Meta: U2FsdGVkX1+9F8OD60+p0x3oiSmziM9Xgijh0F8pxuXFMUpM+GhRlH8/N3iha2H+ZoPnNm0siYBfCfZkk4rg3u0vxlz/1VwN9KpNond2h4DSOJSFwLsPzTgsgckgFO0sd4k94XSMNf+noMdZ8tqq0mOOEMgxT3hVmKg5fXcu1OvRGfHek1+zLEsMyD8NbF75BUWNoYM7KRgpecjDofzX5NcAycHiMSjl2W3hR0brbtIjJLV0xeDECsrFVsAci19il8wGJWeK7Ts8qVONfh1Y70g2Xi0c+kfTapj2WkMHnyJz+tmLgoNWWHp3xxWx/8RI9Qpa+j62padAm5hef68bknuuRRgfnqtETGE7SehuVHi8W98gapopgkso6bA7zVIXEy29pQNGM9uX0Ua1KUSgGhSOWsG9asskO8nakYjv9zNdMIAxHqMoj+UuDpDOU+eize1MmiFvJzCaAboPk7LgSMEGlz4hygQGu1sHGYqE2CJkrzshbWA5ntinB3DA4fbZFUzMsp5Cx901lpp2XeJZp4amnyj576CVuYGs0Q/kcWWfBi8gsTPqqQmnRmZmlFwtFY/nVDFht5kqsc10Je7zNKTYoLUk0wJrIUVhCFw9rXT35RmxZfwJe0hi7BaVzr8HgOEIAy1SngT0JJRL97A6hxrmzko+MyBhuwRgqMiNyUTfBri4Lzdh0nFLmAeC5hByj0vU4ZOj2LuI8IqdEnOcLgWLCEY2YOtKc7Aw90tX5g/jXSu79QeT2aGzL2Fi4m5Onsqnvv/xLDt8Neet9JoAFsQAYw5dz8Ze5FxqzXT9OBj798v5e9ULXSQMBdTTu1/W9WXh7W8/xm6CG9N0zmA03mq6wgE81+qF1ec0FQJxnNIGhdNrYF8GuemJ/nCsJ9O1/zC8wEqURE67s4WkubzvjyD2bOpgkeiPISPgxSYLT7PTKx/w8fu5ada6b6DMN9iFUKsAhR7S26LryVQeTB+
 cxPMcYHZ
 NQiH1lOHikYKrP2zcbrATZCopAL+q8yURsP3iHONiuY5XW25Yqh9wbvavmVYBHCIfT5PrO4vJOUDPWmVX8DXS1toOZzGoP0rdbSRPrUfKMcuKwVP8Vex8pRA+Aupbx0auaJGLJj+EqFabNnvVkXkqN2iB/Ti5fVoyH7gBM75ybNWYgXy0YTBlgha5F4dyK2YP32isAu4BA5Jj1dyaMB1DSfrhQwP8qAuYDsa+26KYS763fxSP7Z+GTDUb74lmCGI4ShfPLExUC+xOLlo9Ow+Ozj82w4z7nJNkvx16
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To remove the fixed limit on the number of preserved files per session,
transition the file metadata serialization from a single contiguous memory
block to a chain of linked blocks.

ABI Changes:
- Define 'struct luo_file_header_ser' to manage linked blocks in preserved
  memory.
- Update 'struct luo_file_set_ser' to point to the head of the block chain.
- Bump the session ABI version to 'luo-session-v4' to reflect these breaking
  changes.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/kho/abi/luo.h      |  35 ++++-
 kernel/liveupdate/luo_file.c     | 226 ++++++++++++++++++++-----------
 kernel/liveupdate/luo_internal.h |  17 ++-
 3 files changed, 189 insertions(+), 89 deletions(-)

diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index f5732958545e..a15f6a0f3d93 100644
--- a/include/linux/kho/abi/luo.h
+++ b/include/linux/kho/abi/luo.h
@@ -84,8 +84,13 @@
  *
  *   - struct luo_session_ser:
  *     Metadata for a single session, including its name and a physical pointer
- *     to another preserved memory block containing an array of
- *     `struct luo_file_ser` for all files in that session.
+ *     to the first `struct luo_file_header_ser` for all files in that session.
+ *     Multiple blocks are linked via the `next` field in the header.
+ *
+ *   - struct luo_file_header_ser:
+ *     Header for the file data block. Contains the physical address of the
+ *     next file data block and the number of `struct luo_file_ser` entries
+ *     that follow this header in the current block.
  *
  *   - struct luo_file_ser:
  *     Metadata for a single preserved file. Contains the `compatible` string to
@@ -134,11 +139,29 @@ struct luo_file_ser {
 	u64 token;
 } __packed;
 
+/**
+ * struct luo_file_header_ser - Header for the serialized file data block.
+ * @next:  Physical address of the next struct luo_file_header_ser.
+ * @count: The number of `struct luo_file_ser` entries that immediately
+ *         follow this header in the memory block.
+ *
+ * This structure is located at the beginning of a block of
+ * physical memory preserved across the kexec. It provides the necessary
+ * metadata to interpret the array of file entries that follow.
+ *
+ * If this structure is modified, `LUO_FDT_SESSION_COMPATIBLE` must be updated.
+ */
+struct luo_file_header_ser {
+	u64 next;
+	u64 count;
+} __packed;
+
 /**
  * struct luo_file_set_ser - Represents the serialized metadata for file set
- * @files:   The physical address of a contiguous memory block that holds
- *           the serialized state of files (array of luo_file_ser) in this file
- *           set.
+ * @files:   The physical address of the first `struct luo_file_header_ser`.
+ *           This structure is the header for a block of memory containing
+ *           an array of `struct luo_file_ser` entries. Multiple blocks are
+ *           linked via the `next` field in the header.
  * @count:   The total number of files that were part of this session during
  *           serialization. Used for iteration and validation during
  *           restoration.
@@ -154,7 +177,7 @@ struct luo_file_set_ser {
  *                          luo_session_header_ser
  */
 #define LUO_FDT_SESSION_NODE_NAME	"luo-session"
-#define LUO_FDT_SESSION_COMPATIBLE	"luo-session-v3"
+#define LUO_FDT_SESSION_COMPATIBLE	"luo-session-v4"
 #define LUO_FDT_SESSION_HEADER		"luo-session-header"
 
 /**
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index dedbb8d02e6a..20a2d776cff4 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -119,10 +119,12 @@ static LIST_HEAD(luo_file_handler_list);
 /* Keep track of files being preserved by LUO */
 static DEFINE_XARRAY(luo_preserved_files);
 
-/* 2 4K pages, give space for 128 files per file_set */
+/* 2 4K pages, give space for 127 files per block */
 #define LUO_FILE_PGCNT		2ul
-#define LUO_FILE_MAX							\
-	((LUO_FILE_PGCNT << PAGE_SHIFT) / sizeof(struct luo_file_ser))
+#define LUO_FILE_BLOCK_MAX					\
+	(((LUO_FILE_PGCNT << PAGE_SHIFT) -			\
+	  sizeof(struct luo_file_header_ser)) /			\
+	 sizeof(struct luo_file_ser))
 
 /**
  * struct luo_file - Represents a single preserved file instance.
@@ -158,7 +160,7 @@ static DEFINE_XARRAY(luo_preserved_files);
  * and the serialized state handle returned by the handler's .preserve()
  * operation.
  *
- * These instances are tracked in a per-file_set list. The @serialized_data
+ * These structures are tracked in a per-file_set list. The @serialized_data
  * field, which holds a handle to the file's serialized state, may be updated
  * during the .freeze() callback before being serialized for the next kernel.
  * After reboot, these structures are recreated by luo_file_deserialize() and
@@ -175,37 +177,68 @@ struct luo_file {
 	u64 token;
 };
 
-static int luo_alloc_files_mem(struct luo_file_set *file_set)
+static int luo_file_add_block(struct luo_file_set *file_set,
+			      struct luo_file_header_ser *ser)
 {
-	size_t size;
-	void *mem;
+	struct luo_file_block *block;
 
-	if (file_set->files)
-		return 0;
-
-	WARN_ON_ONCE(file_set->count);
+	if (file_set->nblocks >= LUO_MAX_BLOCKS)
+		return -ENOSPC;
 
-	size = LUO_FILE_PGCNT << PAGE_SHIFT;
-	mem = kho_alloc_preserve(size);
-	if (IS_ERR(mem))
-		return PTR_ERR(mem);
+	block = kzalloc_obj(*block);
+	if (!block)
+		return -ENOMEM;
 
-	file_set->files = mem;
+	block->ser = ser;
+	list_add_tail(&block->list, &file_set->blocks);
+	file_set->nblocks++;
 
 	return 0;
 }
 
-static void luo_free_files_mem(struct luo_file_set *file_set)
+static int luo_file_create_ser_block(struct luo_file_set *file_set)
 {
-	/* If file_set has files, no need to free preservation memory */
-	if (file_set->count)
-		return;
+	struct luo_file_block *last = NULL;
+	struct luo_file_header_ser *ser;
+	int err;
 
-	if (!file_set->files)
-		return;
+	ser = kho_alloc_preserve(LUO_FILE_PGCNT << PAGE_SHIFT);
+	if (IS_ERR(ser))
+		return PTR_ERR(ser);
+
+	if (!list_empty(&file_set->blocks))
+		last = list_last_entry(&file_set->blocks, struct luo_file_block, list);
+
+	err = luo_file_add_block(file_set, ser);
+	if (err)
+		goto err_unpreserve;
+
+	if (last)
+		last->ser->next = virt_to_phys(ser);
+
+	return 0;
 
-	kho_unpreserve_free(file_set->files);
-	file_set->files = NULL;
+err_unpreserve:
+	kho_unpreserve_free(ser);
+	return err;
+}
+
+static void luo_file_destroy_ser_blocks(struct luo_file_set *file_set,
+					bool unpreserve)
+{
+	struct luo_file_block *block, *tmp;
+
+	list_for_each_entry_safe(block, tmp, &file_set->blocks, list) {
+		if (block->ser) {
+			if (unpreserve)
+				kho_unpreserve_free(block->ser);
+			else
+				kho_restore_free(block->ser);
+		}
+		list_del(&block->list);
+		kfree(block);
+		file_set->nblocks--;
+	}
 }
 
 static unsigned long luo_get_id(struct liveupdate_file_handler *fh,
@@ -247,7 +280,9 @@ static bool luo_token_is_used(struct luo_file_set *file_set, u64 token)
  * 3. Iterates through registered handlers, calling can_preserve() to find one
  *    compatible with the given @fd.
  * 4. Calls the handler's .preserve() operation, which saves the file's state
- *    and returns an opaque private data handle.
+ *    and returns an opaque u64 handle. This is typically performed while the
+ *    workload is still active to minimize the downtime during the
+ *    actual reboot transition.
  * 5. Adds the new instance to the file_set's internal list.
  *
  * On success, LUO takes a reference to the 'struct file' and considers it
@@ -277,17 +312,16 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	if (luo_token_is_used(file_set, token))
 		return -EEXIST;
 
-	if (file_set->count == LUO_FILE_MAX)
-		return -ENOSPC;
+	if (file_set->count == file_set->nblocks * LUO_FILE_BLOCK_MAX) {
+		err = luo_file_create_ser_block(file_set);
+		if (err)
+			return err;
+	}
 
 	file = fget(fd);
 	if (!file)
 		return -EBADF;
 
-	err = luo_alloc_files_mem(file_set);
-	if (err)
-		goto  err_fput;
-
 	err = -ENOENT;
 	down_read(&luo_register_rwlock);
 	list_private_for_each_entry(fh, &luo_file_handler_list, list) {
@@ -301,7 +335,7 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 
 	/* err is still -ENOENT if no handler was found */
 	if (err)
-		goto err_free_files_mem;
+		goto err_fput;
 
 	/* safe to use fh because its module is pinned */
 	err = xa_insert(&luo_preserved_files, luo_get_id(fh, file),
@@ -345,8 +379,6 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	xa_erase(&luo_preserved_files, luo_get_id(fh, file));
 err_module_put:
 	module_put(fh->ops->owner);
-err_free_files_mem:
-	luo_free_files_mem(file_set);
 err_fput:
 	fput(file);
 
@@ -399,7 +431,7 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
 		kfree(luo_file);
 	}
 
-	luo_free_files_mem(file_set);
+	luo_file_destroy_ser_blocks(file_set, true);
 }
 
 static int luo_file_freeze_one(struct luo_file_set *file_set,
@@ -446,6 +478,7 @@ static void __luo_file_unfreeze(struct luo_file_set *file_set,
 				struct luo_file *failed_entry)
 {
 	struct list_head *files_list = &file_set->files_list;
+	struct luo_file_block *block;
 	struct luo_file *luo_file;
 
 	list_for_each_entry(luo_file, files_list, list) {
@@ -455,7 +488,11 @@ static void __luo_file_unfreeze(struct luo_file_set *file_set,
 		luo_file_unfreeze_one(file_set, luo_file);
 	}
 
-	memset(file_set->files, 0, LUO_FILE_PGCNT << PAGE_SHIFT);
+	list_for_each_entry(block, &file_set->blocks, list) {
+		block->ser->count = 0;
+		memset(block->ser + 1, 0,
+		       (LUO_FILE_PGCNT << PAGE_SHIFT) - sizeof(*block->ser));
+	}
 }
 
 /**
@@ -494,7 +531,8 @@ static void __luo_file_unfreeze(struct luo_file_set *file_set,
 int luo_file_freeze(struct luo_file_set *file_set,
 		    struct luo_file_set_ser *file_set_ser)
 {
-	struct luo_file_ser *file_ser = file_set->files;
+	struct luo_file_block *block;
+	struct luo_file_ser *file_ser;
 	struct luo_file *luo_file;
 	int err;
 	int i;
@@ -502,11 +540,18 @@ int luo_file_freeze(struct luo_file_set *file_set,
 	if (!file_set->count)
 		return 0;
 
-	if (WARN_ON(!file_ser))
-		return -EINVAL;
+	block = list_first_entry(&file_set->blocks, struct luo_file_block, list);
+	file_ser = (void *)(block->ser + 1);
 
 	i = 0;
 	list_for_each_entry(luo_file, &file_set->files_list, list) {
+		if (i == LUO_FILE_BLOCK_MAX) {
+			block->ser->count = i;
+			block = list_next_entry(block, list);
+			file_ser = (void *)(block->ser + 1);
+			i = 0;
+		}
+
 		err = luo_file_freeze_one(file_set, luo_file);
 		if (err < 0) {
 			pr_warn("Freeze failed for token[%#0llx] handler[%s] err[%pe]\n",
@@ -521,10 +566,13 @@ int luo_file_freeze(struct luo_file_set *file_set,
 		file_ser[i].token = luo_file->token;
 		i++;
 	}
+	block->ser->count = i;
 
 	file_set_ser->count = file_set->count;
-	if (file_set->files)
-		file_set_ser->files = virt_to_phys(file_set->files);
+	if (!list_empty(&file_set->blocks)) {
+		block = list_first_entry(&file_set->blocks, struct luo_file_block, list);
+		file_set_ser->files = virt_to_phys(block->ser);
+	}
 
 	return 0;
 
@@ -746,10 +794,7 @@ int luo_file_finish(struct luo_file_set *file_set)
 		kfree(luo_file);
 	}
 
-	if (file_set->files) {
-		kho_restore_free(file_set->files);
-		file_set->files = NULL;
-	}
+	luo_file_destroy_ser_blocks(file_set, false);
 
 	return 0;
 }
@@ -782,8 +827,10 @@ int luo_file_finish(struct luo_file_set *file_set)
 int luo_file_deserialize(struct luo_file_set *file_set,
 			 struct luo_file_set_ser *file_set_ser)
 {
-	struct luo_file_ser *file_ser;
-	u64 i;
+	struct luo_file_header_ser *header_ser;
+	struct luo_file_block *block;
+	u64 header_ser_pa;
+	int err;
 
 	if (!file_set_ser->files) {
 		WARN_ON(file_set_ser->count);
@@ -791,7 +838,15 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 	}
 
 	file_set->count = file_set_ser->count;
-	file_set->files = phys_to_virt(file_set_ser->files);
+	header_ser_pa = file_set_ser->files;
+
+	while (header_ser_pa) {
+		header_ser = phys_to_virt(header_ser_pa);
+		err = luo_file_add_block(file_set, header_ser);
+		if (err)
+			return err;
+		header_ser_pa = header_ser->next;
+	}
 
 	/*
 	 * Note on error handling:
@@ -808,42 +863,51 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 	 * userspace to detect the failure and trigger a reboot, which will
 	 * reliably reset devices and reclaim memory.
 	 */
-	file_ser = file_set->files;
-	for (i = 0; i < file_set->count; i++) {
-		struct liveupdate_file_handler *fh;
-		bool handler_found = false;
-		struct luo_file *luo_file;
-
-		down_read(&luo_register_rwlock);
-		list_private_for_each_entry(fh, &luo_file_handler_list, list) {
-			if (!strcmp(fh->compatible, file_ser[i].compatible)) {
-				if (try_module_get(fh->ops->owner))
-					handler_found = true;
-				break;
-			}
-		}
-		up_read(&luo_register_rwlock);
+	list_for_each_entry(block, &file_set->blocks, list) {
+		struct luo_file_ser *file_ser = (void *)(block->ser + 1);
 
-		if (!handler_found) {
-			pr_warn("No registered handler for compatible '%.*s'\n",
-				(int)sizeof(file_ser[i].compatible),
-				file_ser[i].compatible);
-			return -ENOENT;
+		if (block->ser->count > LUO_FILE_BLOCK_MAX) {
+			pr_warn("File block contains too many entries: %llu\n",
+				block->ser->count);
+			return -EINVAL;
 		}
 
-		luo_file = kzalloc_obj(*luo_file);
-		if (!luo_file) {
-			module_put(fh->ops->owner);
-			return -ENOMEM;
-		}
+		for (int i = 0; i < block->ser->count; i++) {
+			struct liveupdate_file_handler *fh;
+			bool handler_found = false;
+			struct luo_file *luo_file;
+
+			down_read(&luo_register_rwlock);
+			list_private_for_each_entry(fh, &luo_file_handler_list, list) {
+				if (!strcmp(fh->compatible, file_ser[i].compatible)) {
+					if (try_module_get(fh->ops->owner))
+						handler_found = true;
+					break;
+				}
+			}
+			up_read(&luo_register_rwlock);
 
-		/* safe to use fh because its module is pinned */
-		luo_file->fh = fh;
-		luo_file->file = NULL;
-		luo_file->serialized_data = file_ser[i].data;
-		luo_file->token = file_ser[i].token;
-		mutex_init(&luo_file->mutex);
-		list_add_tail(&luo_file->list, &file_set->files_list);
+			if (!handler_found) {
+				pr_warn("No registered handler for compatible '%.*s'\n",
+					(int)sizeof(file_ser[i].compatible),
+					file_ser[i].compatible);
+				return -ENOENT;
+			}
+
+			luo_file = kzalloc_obj(*luo_file);
+			if (!luo_file) {
+				module_put(fh->ops->owner);
+				return -ENOMEM;
+			}
+
+			/* safe to use fh because its module is pinned */
+			luo_file->fh = fh;
+			luo_file->file = NULL;
+			luo_file->serialized_data = file_ser[i].data;
+			luo_file->token = file_ser[i].token;
+			mutex_init(&luo_file->mutex);
+			list_add_tail(&luo_file->list, &file_set->files_list);
+		}
 	}
 
 	return 0;
@@ -852,12 +916,14 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 void luo_file_set_init(struct luo_file_set *file_set)
 {
 	INIT_LIST_HEAD(&file_set->files_list);
+	INIT_LIST_HEAD(&file_set->blocks);
 }
 
 void luo_file_set_destroy(struct luo_file_set *file_set)
 {
 	WARN_ON(file_set->count);
 	WARN_ON(!list_empty(&file_set->files_list));
+	WARN_ON(!list_empty(&file_set->blocks));
 }
 
 /**
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index a73f42069301..a92aaa9c073d 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -50,19 +50,30 @@ static inline int luo_ucmd_respond(struct luo_ucmd *ucmd,
  */
 #define luo_restore_fail(__fmt, ...) panic(__fmt, ##__VA_ARGS__)
 
+/**
+ * struct luo_file_block - Internal representation of a file serialization block.
+ * @list: List head for linking blocks in memory.
+ * @ser:  Pointer to the serialized header in preserved memory.
+ */
+struct luo_file_block {
+	struct list_head list;
+	struct luo_file_header_ser *ser;
+};
+
 /**
  * struct luo_file_set - A set of files that belong to the same sessions.
  * @files_list: An ordered list of files associated with this session, it is
  *              ordered by preservation time.
- * @files:      The physically contiguous memory block that holds the serialized
- *              state of files.
+ * @blocks:     The list of serialization blocks (struct luo_file_block).
  * @count:      A counter tracking the number of files currently stored in the
  *              @files_list for this session.
+ * @nblocks:    The number of allocated serialization blocks.
  */
 struct luo_file_set {
 	struct list_head files_list;
-	struct luo_file_ser *files;
+	struct list_head blocks;
 	long count;
+	long nblocks;
 };
 
 /**
-- 
2.43.0


