Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AE25CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 15:46:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C42A06B00B2; Wed,  3 Jun 2026 11:46:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1B1B6B00B4; Wed,  3 Jun 2026 11:46:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B304A6B00B5; Wed,  3 Jun 2026 11:46:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F9286B00B2
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:46:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5BFF54044C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:46:05 +0000 (UTC)
X-FDA: 84839027490.08.21170A0
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf15.hostedemail.com (Postfix) with ESMTP id 912D4A0002
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:46:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ZYkJAFTL;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780501563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I7RY0aQRmzwpMQlV2C0KvIb/sAJhNYK+jOGgyIc3BtM=;
	b=fM7+Sgv0Nq7mkDMm0m1H8ho81X2/MPUPpuydmsFPrYa3rUBzPFfmE0Wi+3MYYu8y/+nJWt
	qy3Tn/8hkDmVPjZ4nmBDis/4u4tyJ0yNpufGWKT0PON7B7pVTDRR/GptLFMBN6l7L28WlF
	ov6YSy32UOS9n20+riHaFC2872lQ1sw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780501563;
	b=4HWU9ZAMmRgAzowad5hO1/8uqgH9FiDhN3ENcze3BhGveoyJa8dYRLFQMu35AreifIxLJg
	iv1usd7dfAAOAFwcjV5LBiHWY3ET1cNxv+BNQoiCMiy6RBlV2wRYnGcfgLWecK4FYzEgxu
	gOBhLYn10C9rQjzX/5V3jLy799FTXPE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ZYkJAFTL;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8ce9df4732cso37076386d6.1
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 08:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780501563; x=1781106363; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I7RY0aQRmzwpMQlV2C0KvIb/sAJhNYK+jOGgyIc3BtM=;
        b=ZYkJAFTLfTlnTGzILMjRiigBwRsCYW72Er1VwPryjevr98e0hZVt1y9SyVUXG1lUc8
         EKEjcLmA2F8aXYjcolD9QHnzyPwZK3sKDlGZVGez3pLNGhoFYOoZ/HBSqG/0nMahHCTp
         THi26i7xqE+Q18+ogZO8X/nDATJlkO6+t+6cJN8dFakdvKv/eQxO80nLoSsPxiCz83jR
         PrB0jhMRKQazDzOhrXqAxXgiUAg86w5nPA0IaII4jdgy8mr1o3ry0+Vujrs3Lc9Zchh9
         j3bpfClOIbSanXcRz8x8yTkFvzvMAZha5Yygoko4o8HmFB8VbH3sgnlpRTg3abtLD/To
         S57A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780501563; x=1781106363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=I7RY0aQRmzwpMQlV2C0KvIb/sAJhNYK+jOGgyIc3BtM=;
        b=amnUTZnceufjdNwUlpqseH5Nvas9mjmLba7NSef+CCGdTpYYzRutUh4kQHWJxVCq3u
         4uxKLbLCRnBQ7gtQGI2RX6QQ1CMQK66u1X0jUMP7WdARmKFyBDXxC6upOc1ZFXGilosI
         Dcys7OJ0ld0cBMqhaMDGsdX3TYX2pOE3bmAQkNXwYy7QsxKjHU0glKfRTjdVc6kveMan
         0uNcy7CgDQUJH9u1OVnTvuBi2vxxmoQjfK0q8A+f+zTR9vR+VdpSl9eB7eJkKtn32AMb
         /pJrWbiPyo3NSknzjOYbLfUngTOt+j5gQnfjbhn96Kvx3K2hXSanmKTuXzwkBUBL1OHP
         +lsQ==
X-Forwarded-Encrypted: i=1; AFNElJ8lN+Ydv5wGW6QPdKUsW7C8LO3JWWJ+E4RrSnRnmnOV+qyFKLbyZuqKSLqk5+HwscsqIGtEQw2vdQ==@kvack.org
X-Gm-Message-State: AOJu0Yy2CrIK4pgtlk91Eneo7+X6WOIzvklkbDpNZ19KTuFn+GWiJlxJ
	XTIJzDZ/Uh3IQYph9PYlTajL6/w2LDJXokjlrPq0Tjse7kG7caTABp7Zud1M9/3/BfI=
X-Gm-Gg: Acq92OFuZ+00L4OMrdScklinKtDJxaJrLRsAcBjqw12JVtjEPgn/xyc3MPO2c3YDIMx
	wVqkLgumcU86xhWlwRK5aFcFZYnjqgBXwgCzYYKznOonzefWpC2mpi/P0Yw0SJ1JISWeeUN/zrw
	GTTTy03/zkVn8lIXrgliC8GmZKrIcskDhGq5AmWLPTMqd2xSwNKd7pXiLT875ppANCPytYhJX3a
	4taNUXNIBvg/VZ96WTNBPJIfhLPWM1exETJr2EVKjmrZMyDFVitXzCxvUQTmKFd8yEmKGrYuM1z
	8Si6PI/2ETx2rs0L7S0up3iu8L1rN9OunE8U+/KwNaeCXhvWcJocgKFQsgT9OQJSMp1rEnp/EyQ
	GxQw9yeQMK3SjORUdMlEbqtQHo7IVmAS2PtLQMYDstd2SpUGt6VVfi7vr3cXpCpLyRFysbWjFtF
	iPBbJnQ2Lnx9a8HvatDoNHWaXOctbzaSGVZtO0oLQh1gttkVguBLSdhvV6BO4t4Q==
X-Received: by 2002:a05:6214:c68:b0:8ce:ba04:7bfe with SMTP id 6a1803df08f44-8cece1668a1mr51109436d6.46.1780501562561;
        Wed, 03 Jun 2026 08:46:02 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ceccd9dfc1sm23450476d6.4.2026.06.03.08.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 08:46:02 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	skhawaja@google.com,
	graf@amazon.com
Subject: [PATCH v7 10/13] liveupdate: Remove limit on the number of files per session
Date: Wed,  3 Jun 2026 15:43:59 +0000
Message-ID: <20260603154402.468928-11-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260603154402.468928-1-pasha.tatashin@soleen.com>
References: <20260603154402.468928-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 912D4A0002
X-Stat-Signature: d6kyx5z4sh76ysk6ago3onoeka9hoqix
X-HE-Tag: 1780501563-543649
X-HE-Meta: U2FsdGVkX1+dhjBYnSU0Zfmb5NB8BX5t77KJmT8kZvGylj7/nYbhpqc2KmmoeTfPYwdSHhCTlZFA3rioifYztLOj6zmSSCtEardLHcm4xU7u0qDtEleUX8gXJ+ufSRA6CYmxaUIAEeaVwKTZLN6C2fvehA8cdV+gi1alpUniFlql8yv3zUtH2WDmTZc/Gvo1we5F+AoapJnet0AaNMmy4FfvzoBvO6S395CzEQn2Je5JRU608b+uLwrCy6TJXiSQDOjBOLuxUOArPhI4ZRMW41jY6q15XwYvbsokOi1i1Y8WF4h89X8o1xH/2fPx3iQ27+3wdabwyNapp1LOSrwgl8mjxnSfyuarNecfzqTxHPJCkJALkf6PpeisZBn6ISMCv/6jXAbyuTAslUxhakT/p1qKTV9MX3mUgP3u47Dg+QJxM1C+WeTdWCJVqkdQPi6vgUZWbAZEEU0BM63S0LiqxqFi5AeRHCz4mDsUMFxnv3TfmmRL4iw+gsYHLoQg49hP2UJy2Zooxzq3e2dgBLhCHXTdC/gMw20Y89dFSV19C5Ulr+KfpEXffPKimSEJmvr5Zv7xFPw4W1cPKaca/15hkMajSiy2RJjOSW9IpCetyb6u3Qm1536z/G6WlYtZXHNIfmnatr1luAsclAZ60okuHAfCDJ4cNaxsIQT/tchnc2koNZy2gGIMLj9G/ohG0gRjcUXM3BKaM7kSPPXcLLi75P4xh3fs2pz4HOSBzk5Z9TlMPWADCNm5KhZTX3RfOfNmaRCo1vXPehFnbM+5zvq8QVWmUPmxfghWKjAKdgKLBLWQaXXlqGVG8zIsaGQKmLszp0aOhCeVbrWCcvOEdI37Zs2+ypEnPKqvgixKTxHe4afkDPhcTY5fZCi2eoPiLyMsJLFLJzksqK3c7rHzWGDahKT4dtAvWcmKpoJi+1VcXEtgS4lvm4YrBtlRgbP7bRa4IqU/Gy5b3/OtOLXoQoj
 HUNCgiU0
 MdS7EAgCy5qc+A78rJsqtPakUDiS8Fkw4Pfwq0DNMJXh7b7CgZE4IBGUY1annipNQK4qxs6TeJgGA/sXtgPyscHu+U78fp/yCYfp8UTtZMF5Dv0ucTJZ9b5fiX+cpk7xCSFK9X6I+vE6bSPp4Bu/qK/wL7uwkoff9in6mGFvFO1Kqb2PHXOuMFl39NeGWHejPoLkZWfA3winkvibDbNxWw/p0aLCJdviufpmp1yG+HOFcExZguW6GQBaKxsl8Yss0Z1QeG4K9ceZ4gtK7zqi0yHVI5bRF9/pXDEIoKFVwepC/Y5oSwrfS3n+R8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To remove the fixed limit on the number of preserved files per session,
transition the file metadata serialization from a single contiguous
memory block to a chain of linked blocks.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/kho/abi/luo.h      |  13 +--
 kernel/liveupdate/luo_file.c     | 138 ++++++++++++++-----------------
 kernel/liveupdate/luo_internal.h |   6 +-
 3 files changed, 74 insertions(+), 83 deletions(-)

diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index 03d940d0f9bb..288076de6d4a 100644
--- a/include/linux/kho/abi/luo.h
+++ b/include/linux/kho/abi/luo.h
@@ -35,8 +35,8 @@
  *
  *   - struct luo_session_ser:
  *     Metadata for a single session, including its name and a physical pointer
- *     to another preserved memory block containing an array of
- *     `struct luo_file_ser` for all files in that session.
+ *     to the first `struct kho_block_header_ser` for all files in that session.
+ *     Multiple blocks are linked via the `next` field in the header.
  *
  *   - struct luo_file_ser:
  *     Metadata for a single preserved file. Contains the `compatible` string to
@@ -65,7 +65,7 @@
  * The LUO state is registered under this KHO entry name.
  */
 #define LUO_KHO_ENTRY_NAME	"LUO"
-#define LUO_ABI_COMPATIBLE	"luo-v4"
+#define LUO_ABI_COMPATIBLE	"luo-v5"
 #define LUO_ABI_COMPAT_LEN	ALIGN(sizeof(LUO_ABI_COMPATIBLE), 8)
 
 /**
@@ -102,9 +102,10 @@ struct luo_file_ser {
 
 /**
  * struct luo_file_set_ser - Represents the serialized metadata for file set
- * @files:   The physical address of a contiguous memory block that holds
- *           the serialized state of files (array of luo_file_ser) in this file
- *           set.
+ * @files:   The physical address of the first `struct kho_block_header_ser`.
+ *           This structure is the header for a block of memory containing
+ *           an array of `struct luo_file_ser` entries. Multiple blocks are
+ *           linked via the `next` field in the header.
  * @count:   The total number of files that were part of this session during
  *           serialization. Used for iteration and validation during
  *           restoration.
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 9eec07a9e9fc..c39f96961a85 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -118,11 +118,6 @@ static LIST_HEAD(luo_file_handler_list);
 /* Keep track of files being preserved by LUO */
 static DEFINE_XARRAY(luo_preserved_files);
 
-/* 2 4K pages, give space for 128 files per file_set */
-#define LUO_FILE_PGCNT		2ul
-#define LUO_FILE_MAX							\
-	((LUO_FILE_PGCNT << PAGE_SHIFT) / sizeof(struct luo_file_ser))
-
 /**
  * struct luo_file - Represents a single preserved file instance.
  * @fh:            Pointer to the &struct liveupdate_file_handler that manages
@@ -174,39 +169,6 @@ struct luo_file {
 	u64 token;
 };
 
-static int luo_alloc_files_mem(struct luo_file_set *file_set)
-{
-	size_t size;
-	void *mem;
-
-	if (file_set->files)
-		return 0;
-
-	WARN_ON_ONCE(file_set->count);
-
-	size = LUO_FILE_PGCNT << PAGE_SHIFT;
-	mem = kho_alloc_preserve(size);
-	if (IS_ERR(mem))
-		return PTR_ERR(mem);
-
-	file_set->files = mem;
-
-	return 0;
-}
-
-static void luo_free_files_mem(struct luo_file_set *file_set)
-{
-	/* If file_set has files, no need to free preservation memory */
-	if (file_set->count)
-		return;
-
-	if (!file_set->files)
-		return;
-
-	kho_unpreserve_free(file_set->files);
-	file_set->files = NULL;
-}
-
 static unsigned long luo_get_id(struct liveupdate_file_handler *fh,
 				struct file *file)
 {
@@ -276,16 +238,15 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	if (luo_token_is_used(file_set, token))
 		return -EEXIST;
 
-	if (file_set->count == LUO_FILE_MAX)
-		return -ENOSPC;
+	err = kho_block_set_grow(&file_set->block_set, file_set->count + 1);
+	if (err)
+		return err;
 
 	file = fget(fd);
-	if (!file)
-		return -EBADF;
-
-	err = luo_alloc_files_mem(file_set);
-	if (err)
-		goto  err_fput;
+	if (!file) {
+		err = -EBADF;
+		goto err_shrink;
+	}
 
 	err = -ENOENT;
 	down_read(&luo_register_rwlock);
@@ -300,7 +261,7 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 
 	/* err is still -ENOENT if no handler was found */
 	if (err)
-		goto err_free_files_mem;
+		goto err_fput;
 
 	err = xa_insert(&luo_preserved_files, luo_get_id(fh, file),
 			file, GFP_KERNEL);
@@ -343,10 +304,10 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	xa_erase(&luo_preserved_files, luo_get_id(fh, file));
 err_module_put:
 	module_put(fh->ops->owner);
-err_free_files_mem:
-	luo_free_files_mem(file_set);
 err_fput:
 	fput(file);
+err_shrink:
+	kho_block_set_shrink(&file_set->block_set, file_set->count);
 
 	return err;
 }
@@ -392,13 +353,14 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
 
 		list_del(&luo_file->list);
 		file_set->count--;
+		kho_block_set_shrink(&file_set->block_set, file_set->count);
 
 		fput(luo_file->file);
 		mutex_destroy(&luo_file->mutex);
 		kfree(luo_file);
 	}
 
-	luo_free_files_mem(file_set);
+	kho_block_set_destroy(&file_set->block_set);
 }
 
 static int luo_file_freeze_one(struct luo_file_set *file_set,
@@ -454,7 +416,7 @@ static void __luo_file_unfreeze(struct luo_file_set *file_set,
 		luo_file_unfreeze_one(file_set, luo_file);
 	}
 
-	memset(file_set->files, 0, LUO_FILE_PGCNT << PAGE_SHIFT);
+	kho_block_set_clear(&file_set->block_set);
 }
 
 /**
@@ -493,19 +455,24 @@ static void __luo_file_unfreeze(struct luo_file_set *file_set,
 int luo_file_freeze(struct luo_file_set *file_set,
 		    struct luo_file_set_ser *file_set_ser)
 {
-	struct luo_file_ser *file_ser = file_set->files;
 	struct luo_file *luo_file;
+	struct kho_block_set_it it;
 	int err;
-	int i;
 
 	if (!file_set->count)
 		return 0;
 
-	if (WARN_ON(!file_ser))
-		return -EINVAL;
+	kho_block_set_it_init(&it, &file_set->block_set);
 
-	i = 0;
 	list_for_each_entry(luo_file, &file_set->files_list, list) {
+		struct luo_file_ser *file_ser = kho_block_set_it_reserve_entry(&it);
+
+		/* This should not fail normally as blocks were pre-allocated */
+		if (WARN_ON_ONCE(!file_ser)) {
+			err = -ENOSPC;
+			goto err_unfreeze;
+		}
+
 		err = luo_file_freeze_one(file_set, luo_file);
 		if (err < 0) {
 			pr_warn("Freeze failed for token[%#0llx] handler[%s] err[%pe]\n",
@@ -514,16 +481,14 @@ int luo_file_freeze(struct luo_file_set *file_set,
 			goto err_unfreeze;
 		}
 
-		strscpy(file_ser[i].compatible, luo_file->fh->compatible,
-			sizeof(file_ser[i].compatible));
-		file_ser[i].data = luo_file->serialized_data;
-		file_ser[i].token = luo_file->token;
-		i++;
+		strscpy(file_ser->compatible, luo_file->fh->compatible,
+			sizeof(file_ser->compatible));
+		file_ser->data = luo_file->serialized_data;
+		file_ser->token = luo_file->token;
 	}
 
 	file_set_ser->count = file_set->count;
-	if (file_set->files)
-		file_set_ser->files = virt_to_phys(file_set->files);
+	file_set_ser->files = kho_block_set_head_pa(&file_set->block_set);
 
 	return 0;
 
@@ -741,14 +706,12 @@ int luo_file_finish(struct luo_file_set *file_set)
 		module_put(luo_file->fh->ops->owner);
 		list_del(&luo_file->list);
 		file_set->count--;
+		kho_block_set_shrink(&file_set->block_set, file_set->count);
 		mutex_destroy(&luo_file->mutex);
 		kfree(luo_file);
 	}
 
-	if (file_set->files) {
-		kho_restore_free(file_set->files);
-		file_set->files = NULL;
-	}
+	kho_block_set_destroy(&file_set->block_set);
 
 	return 0;
 }
@@ -822,16 +785,18 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 			 struct luo_file_set_ser *file_set_ser)
 {
 	struct luo_file_ser *file_ser;
+	struct kho_block_set_it it;
 	int err;
-	u64 i;
 
 	if (!file_set_ser->files) {
 		WARN_ON(file_set_ser->count);
 		return 0;
 	}
 
-	file_set->count = file_set_ser->count;
-	file_set->files = phys_to_virt(file_set_ser->files);
+	file_set->count = 0;
+	err = kho_block_set_restore(&file_set->block_set, file_set_ser->files);
+	if (err)
+		return err;
 
 	/*
 	 * Note on error handling:
@@ -848,25 +813,50 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 	 * userspace to detect the failure and trigger a reboot, which will
 	 * reliably reset devices and reclaim memory.
 	 */
-	file_ser = file_set->files;
-	for (i = 0; i < file_set->count; i++) {
-		err = luo_file_deserialize_one(file_set, &file_ser[i]);
+	kho_block_set_it_init(&it, &file_set->block_set);
+	while ((file_ser = kho_block_set_it_read_entry(&it))) {
+		err = luo_file_deserialize_one(file_set, file_ser);
 		if (err)
-			return err;
+			goto err_destroy_blocks;
+		file_set->count++;
+	}
+
+	if (file_set->count != file_set_ser->count) {
+		pr_warn("File count mismatch: expected %llu, found %llu\n",
+			file_set_ser->count, file_set->count);
+		err = -EINVAL;
+		goto err_destroy_blocks;
 	}
 
 	return 0;
+
+err_destroy_blocks:
+	while (!list_empty(&file_set->files_list)) {
+		struct luo_file *luo_file;
+
+		luo_file = list_first_entry(&file_set->files_list,
+					    struct luo_file, list);
+		list_del(&luo_file->list);
+		module_put(luo_file->fh->ops->owner);
+		mutex_destroy(&luo_file->mutex);
+		kfree(luo_file);
+	}
+	file_set->count = 0;
+	kho_block_set_destroy(&file_set->block_set);
+	return err;
 }
 
 void luo_file_set_init(struct luo_file_set *file_set)
 {
 	INIT_LIST_HEAD(&file_set->files_list);
+	kho_block_set_init(&file_set->block_set, sizeof(struct luo_file_ser));
 }
 
 void luo_file_set_destroy(struct luo_file_set *file_set)
 {
 	WARN_ON(file_set->count);
 	WARN_ON(!list_empty(&file_set->files_list));
+	WARN_ON(!kho_block_set_is_empty(&file_set->block_set));
 }
 
 /**
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index ee18f9a11b91..64879ffe7378 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -10,6 +10,7 @@
 
 #include <linux/liveupdate.h>
 #include <linux/uaccess.h>
+#include <linux/kho_block.h>
 
 struct luo_ucmd {
 	void __user *ubuffer;
@@ -44,14 +45,13 @@ static inline int luo_ucmd_respond(struct luo_ucmd *ucmd,
  * struct luo_file_set - A set of files that belong to the same sessions.
  * @files_list: An ordered list of files associated with this session, it is
  *              ordered by preservation time.
- * @files:      The physically contiguous memory block that holds the serialized
- *              state of files.
+ * @block_set:  The set of serialization blocks.
  * @count:      A counter tracking the number of files currently stored in the
  *              @files_list for this session.
  */
 struct luo_file_set {
 	struct list_head files_list;
-	struct luo_file_ser *files;
+	struct kho_block_set block_set;
 	u64 count;
 };
 
-- 
2.53.0


