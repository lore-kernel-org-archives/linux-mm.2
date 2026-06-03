Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7720CD6E56
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 03:29:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7BE16B009F; Tue,  2 Jun 2026 23:29:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDE7C6B00A0; Tue,  2 Jun 2026 23:29:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA56B6B00A1; Tue,  2 Jun 2026 23:29:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B69D16B009F
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 23:29:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7F2DC1612D8
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:29:24 +0000 (UTC)
X-FDA: 84837171048.19.EC266A1
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf19.hostedemail.com (Postfix) with ESMTP id B8C2C1A0005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:29:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KtgvV7JB;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780457362;
	b=JpAezOPj6EqfwTtQ6O9x1CvA/FO9uxihpebrlk00b5G/wZWXuHPbaNM+19+xKJwpt3HWdx
	+kp/iSizMQka1WRvK42sG8st3EgT22WAKhPa9a4fkj3aqbKbtDWm0sCJxSdg3AtQXntShG
	Y9xIOJuvjb4fyHTe4eMsqBxHcYMPv8c=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KtgvV7JB;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780457362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aDk1luXhEbMZPjSCi9wsbdWPEY1V0MeSCJTY8TocvIA=;
	b=QqLXo6EPBtEEIakbiw6IT8D0+wNg12FbNpQMqzGlKQjwVRicSi6qF1ExsIDCpq2b0orTKk
	7udS1LpMifUdcyyerAaY4UEmYYcpGgiLFMy/sbwLP/Ao6u5+7BR7Oa2f4w6Dx5jNXcEl+x
	maPi5/E1m1U90BbnRqqcrRCD3H+UcdE=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8ccf887de87so44618816d6.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 20:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780457362; x=1781062162; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aDk1luXhEbMZPjSCi9wsbdWPEY1V0MeSCJTY8TocvIA=;
        b=KtgvV7JBMTkyFhqkFgLnWZAu7XiRq1pnjcQZrDg0b3pXcQrLN9qpg6X2B43jJ05KkY
         FFrvt0xXLR3UCSJ9Ag5Bb8iaSj7P4h5QqVYT/gkZPdB1Q4gzan/7nzQGTZN/ZelotAu5
         WYe7RA1kRorP2+oy8vnSQ08Owj9Qe0JvZoOLkDd7tFQumftvWpi5MScsMh+0gfWyFKWB
         NlsikDVvibkbNYTYw6/eTn4ruw26C/o0Mlzq6uw7QUDAp25VpvfNx+ug+5qaNfuW9kV6
         63vf30OBrHiiwr58ES83/EMPaI7PLvilOiofjpoQ0PrmgoOofnUCAcpyO4MUHn4n7Srk
         NF/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780457362; x=1781062162;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=aDk1luXhEbMZPjSCi9wsbdWPEY1V0MeSCJTY8TocvIA=;
        b=iKi0oqlQkYoCzkIpBx9Lv3yFSF07FQtFO/D1ihDkYqlbVzEavMDh2Y7XXIlHlZNXnY
         z7d9zuNaW0TIpDBDh5FiozpOm1G/LEZG+38TaBxAt6e8XlgfaxQ0IdECvtBIa6fDk4dE
         e7ntcSHizEWXsqt8s0t+tqohH2zslmURpdAOtQ58LyKPVgRT1zdStAqWbPHx02so2r5G
         8qOnl0Zh5hfW6noz01dsYW7E7QdXBG63kPCVceJSnJUUCk5C5RNrQV8bTVld6q50wBAw
         DMi7NfIHxSjBnfw1v7xn0cmwvlofScuRJo46tGyDKIfWZ3WxhtA1IbCrc/8tSM+wHATy
         TVUA==
X-Forwarded-Encrypted: i=1; AFNElJ+hqMcTE6yQst7Wqm6G/AgDYJFMzTYYUTGCAFVPz8KxfGL5f6d3td3sI4j56aJfvNEW4GqAwloAJw==@kvack.org
X-Gm-Message-State: AOJu0Yw1J6cBq6ES7dHViiQ8A+CzZM5JQ1WjdST3zNqXaHjGLiBzt5RU
	JWoLtJfMzvJfULdmJxHLj0mry8jkBpNT6SmSzPqBe/aJagK7LwF4moYpTS7LyQ7eKjw=
X-Gm-Gg: Acq92OGa2tTLDLUQ/iillYjbNFkgE/tMcv2iUOL5tRGbn0+wpp88M3WbVmphNA6pORN
	byyJM1rzsTUUef82MFi/z14RCJBZcRqaE6iybG7FD3rQunJroApM7sgY5Sbr1YKih9uCPPNbIPW
	a4Ol0JRBiOUc0tJnvSIk48JKemxnPccqywAfpvHhjoZv8S1JLqXeVkXC77HfmF7miOZdYJg2tA9
	jDZV0p97bU4t1k8zNdRUbnCwAbNxjB77dh9eSSipqu/a484QD+lMZD3+L/H90jyPt4R3OnWdxZB
	R5yg6/JgfI/IinM0qcvKH2BfKEs4edln+DYg3HYj6XfYkFqjQSLmJSDpXs48Uyr16cfalqD9M63
	1tUVrJRI+wlLKA6NztuCXiFeoq443MU5wH9Ow5yBocxIGdb53P3fsTgFKQ8kbEaOXh5oKFwzAw6
	olBGFEz1FbiThqdL0UN8kPDRCb5xRSv2fuqfHMiYAMjYgg6+OBxSo8etkQbITLoQ==
X-Received: by 2002:a05:6214:2f13:b0:8ce:aace:eaf8 with SMTP id 6a1803df08f44-8cece152728mr22557086d6.43.1780457361705;
        Tue, 02 Jun 2026 20:29:21 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd26b3b9sm9244566d6.45.2026.06.02.20.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 20:29:21 -0700 (PDT)
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
Subject: [PATCH v6 10/13] liveupdate: Remove limit on the number of files per session
Date: Wed,  3 Jun 2026 03:29:01 +0000
Message-ID: <20260603032905.344462-11-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260603032905.344462-1-pasha.tatashin@soleen.com>
References: <20260603032905.344462-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B8C2C1A0005
X-Stat-Signature: s7gwcpeqb1x7scqp1c4sg7m1a5y9hijk
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780457362-316604
X-HE-Meta: U2FsdGVkX18cVKYwb4qMkM8oPGbQCSb2oUAn3NDP1nZRfBk8eMaAbCl68Riyhup9rPhrFJZrt+P8XtGSHrwt1aZivSw6y1FzBAG7eufarxZGmpH0wZfFUJkbZQRi6RVveKN5s1iYO8Zv35uwEXMIqh88xJfr5i4ERXL3W8hAZAkI99ZoIioIZJN7eDlhjr0SrA/SxCcqJhDwJjTaq1Lz3vLUAv9PAWeoTwmJcGjyW+B52kYnHzMa3BtaU3S0cITak0kwSD8HovxBxm1jP4dwMpnebZoIh/+OIQCj6j3sj94kpR5VR84mhWEMwjFFoM+ONVGlP7vChDq2qQ+l4ihmxRmj+Cv+zHMujoDUb8wmteKEaW/fYPwOsUeBDDSgXHPVSKp390kmD1BqXiENWjBN7pRtnrpR3h3xFs+YdT6pUG8WrHrXQ7GtgBzuqpaeyrPRKP3N8WsFNtXgr5LkgUrEJDgT/7xzt7qqSXz8OuNKd4BChnSh1crIgYGQt7q4BHL8u0zsOQ1JcWtZ85ZQDYhoDRH+3UfqlDXxBK5rgZAoN4sYuQ8RBETOf1ivTCArUjh6dNPJNSYV66dLLJXc9Yl6Nf7l0+EdPjWtioT4yrC3xMb3WA0iOjobH3/jz97Sa4m7TXdJno2ze/Ma0ulgxDDTIU/MBOy9y6hNrm5hr8o/kgVjn6Ukd40CRQFVO96/VC4gUKWIMOEADLXOBFAk4NwH3i3EeQNsKgf2G3SK3DeHbuOx+U6mGj7UEx09sZhjchYSG5GHZZvCIexl33/y8VZn4GlbUtQM6I1lWL3ngc5UsN43H75Daujuzh7XToVc+YfxYPFNQZPlmRT7L6gCfXWbmHHSthlUoZJkD8GgUFsZnDzUVxYkrtfzRJScdDBdusu+aKdFPYnLXyyZ+Rbv87aHGRJjSj6Cgeyqt1O5oF3tLYlI/PvnN3cpkOukHdAK4HHNTdeMfOq8gNEiAxuHch7
 wzsqZeS1
 2SDDXVqhuDM9jtajRXsvM9DeSNS0txGlj4VNcMoEU6RbQ1RoPBDo05FHxW2B3zv0/SSSNApWp6YLp9XQWLYAhQSptwy0AV9IPMq1O9gijqFrl4yAVHAixV+gp0lKLlRMRmzYeH5HhYscHWWTg1ezK6SUZ+jTBX+LlV6rD6zCtpIR3QxrmuVTVqsIoeFpygLpE0JNaiwOgL0YOQN498LpYTBMfFDcJwUf8KcBKfNqcbGVfFrkNs8kKs0azSfRiYIfZ/wSOw/aey3+qJUuJEDXy5rE52KRhRSpPcFrLhTlUw4Eby1BbCRsi4xkJcg==
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
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/kho/abi/luo.h      |  13 +--
 kernel/liveupdate/luo_file.c     | 138 ++++++++++++++-----------------
 kernel/liveupdate/luo_internal.h |   6 +-
 3 files changed, 74 insertions(+), 83 deletions(-)

diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index 79758d92ed5f..16df550ef143 100644
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
-#define LUO_COMPAT_BASE		"luo-v3"
+#define LUO_COMPAT_BASE		"luo-v4"
 #define LUO_ABI_COMPATIBLE	LUO_COMPAT_BASE "-" KHO_BLOCK_ABI_COMPATIBLE
 #define LUO_ABI_COMPAT_LEN	ALIGN(sizeof(LUO_ABI_COMPATIBLE), 8)
 
@@ -103,9 +103,10 @@ struct luo_file_ser {
 
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


