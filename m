Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB63ECD4F41
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 22:26:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD9696B0099; Thu, 14 May 2026 18:26:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD81F6B009B; Thu, 14 May 2026 18:26:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B66A36B009D; Thu, 14 May 2026 18:26:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A30DE6B0099
	for <linux-mm@kvack.org>; Thu, 14 May 2026 18:26:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6668C1A0723
	for <linux-mm@kvack.org>; Thu, 14 May 2026 22:26:47 +0000 (UTC)
X-FDA: 84767461254.30.3C68CD9
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9BE9780005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 22:26:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Rp1+FEWb;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778797605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aQqqDxa74bXnO1ngkkwE1THWbm/MOk0NCF6+LcpRWdU=;
	b=T7EfecC+5ijh1sajmFwOzDmhokyVqaGewluKapArGhnBoMvyVXjVetJ/SWNaZQrWGt4BPU
	1qjVg1e7KJiSAdOifeFjbpemkhV2A5pubUTyY05RuGWqsXpbtNySy2w+UZ5el0/O8Igqhv
	o5DhvzzUDn7evi6Di2UKMo82SHB+pdQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Rp1+FEWb;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778797605; a=rsa-sha256;
	cv=none;
	b=cK1vFgtTR4HJMR1oatwDy52AE2y0NGFJcIV5AW8nD+SRfYu04dY6EBaqcMncPi8NJ47IaM
	uNuvrNGkKMBgT+6lH5gNdS8oiiQzdUoNlqcKrWYNnikilKJU7p8VJ9Ulds8eohW3QX/W7b
	HNdLL4C/WJiK0zy54XQd7EdNjJcRbq4=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-50fb1ad3734so3480151cf.1
        for <linux-mm@kvack.org>; Thu, 14 May 2026 15:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1778797605; x=1779402405; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aQqqDxa74bXnO1ngkkwE1THWbm/MOk0NCF6+LcpRWdU=;
        b=Rp1+FEWbsR/R3usWqDBXPFcTKl1p6Zus6Qgs07veoi7uQx+SfhiP6+sb53ndhDaSrR
         Ci8aMknRbiXV/RYYtwxrKSfPikq9IYwaFp8TEsbXUtl8MHh6skHz+u0Sh9GI4qPub8Ik
         LymuCcD9qAy/xiS+n2LfYY7LAmUcmodTaCawM67W7puPGNWCYABeTTmAL1Gu8EVne3Je
         8EA8VtX2ZFOMSmh3QjTGRbwh9Wro4h2xH+AP07SZu3ho0GDNIGO8KMGVAJJiTqfbpEwg
         3o8GMV0fspTJjCSPlvRyY4A2lU0pPGHt2sZdeWgHtHDbZ2fTsOjfthsrU1dRRE2XJ8V3
         7qlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778797605; x=1779402405;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=aQqqDxa74bXnO1ngkkwE1THWbm/MOk0NCF6+LcpRWdU=;
        b=emV0teJ+90cXFZQjYCny5H7Uk1s2xWBIANssoaftLDGJ/HMCxFndScYbU9IiaZPG7E
         2GVKPOWHCp1WDLld/zrHeELjKmmKnA0IFILhUpQZXW1VGw8GWhgI9lv4/lCSY+7G8efX
         vrsUBpchpcb5xCS5fd3lMLoMu+bxjvAdOeMG6DverPMY1KN6DT/MxaXwfuZUMU0QEx/d
         KjFOLpu6RjFvM8uKxxwm9XD4EjhidYWA/2AYRvZxWBCyUJMVP6/dAz4CTXf5aoZO3hPG
         N+lcRvYXpUiDbVtwiXUjYm1TgdW+BYCoYzEJyThTbBAqTYaHQe38tMZNuFf7KowKIcYt
         TCYQ==
X-Forwarded-Encrypted: i=1; AFNElJ/kLBSWCU6EN45vwzNIzu+lOF16OzIGgOrpz43sYEtoSgANot55+xmrZRf082A++xNG9LWKM5FTfg==@kvack.org
X-Gm-Message-State: AOJu0YwEisqIqaI88/iXmcvlB/6+y41o0g5BEveS/3HoefI1A6Yo0o/R
	I1PusS1kFWAUcsXOWR4yu1LLUlWjVkrLSRBjg+SSh3jelml8jN2m59WgGagAlk8w0KM=
X-Gm-Gg: Acq92OGxK+RqHlSrxgKFWUwBB3v5pnZm4MbFBdR6oM8mBxfEOTijwc71d8+WiAVG2tp
	dn8Vg3a9tVSDb8BhyL0GrNq+WaK0MbpbqC+urwfFCtFW+RseDJf25u9D34+RQEg492n9aU9+7Cw
	q+MpGiOnCYXAm84u+p/UhwRrCkJ9z7tSJoIgWfa8J99Hn+Sat4maJqNcLMrQXF6mbF9Z67029r0
	yjTn2dI/G9vkSNGFJxEJPpXcKhsvMeTKISuxlJIuQeGYCeaO50pd0fI0Y1dkI9X9/rwhC4yEZlh
	Le7xXn9OvPmJIeVRNReHcXdQ5GPwwfJvRbGo8dKmE93vjEClWd+a7kKuV5wdjkAUNlOVPeXgnRt
	XOihlSH17RdU36jdmDEdO9FscNtic+oKSD0rNIiNyvxf+E81xynZ5Y0xiZaMuleNqfqKXSPGTcw
	LZgj4RA5jlF0x/+UzxX7MqTaPUT3tXn/gYrhT6ccbDYDTJ3CR5Td5ji/cjOfE6lg==
X-Received: by 2002:a05:622a:254:b0:50f:39f4:3a2b with SMTP id d75a77b69052e-51641967867mr73061401cf.41.1778797604725;
        Thu, 14 May 2026 15:26:44 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516456ba92fsm28671901cf.9.2026.05.14.15.26.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 15:26:43 -0700 (PDT)
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
Subject: [PATCH v2 07/10] liveupdate: Remove limit on the number of files per session
Date: Thu, 14 May 2026 22:26:25 +0000
Message-ID: <20260514222628.931312-8-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260514222628.931312-1-pasha.tatashin@soleen.com>
References: <20260514222628.931312-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9BE9780005
X-Rspamd-Server: rspam06
X-Stat-Signature: etz1q5uyjmew7ct3sry7irgk71mr4h7z
X-HE-Tag: 1778797605-399135
X-HE-Meta: U2FsdGVkX19o0UVS182A6cSGSr/n5BP1elx7NVcRh9g5Lwh9v1sC1xur46UBOW2ZhXJ1lDf3zIOQmcNZFha5QxOnZzy0pW8spF/pqzdmzC+k5lffBv/j6FUsmeShDK9iGMbXwY9QSvMhioCn+5kbMkihC8Jlr0NKVT1KZxlzF8YZzO2RdxTE0b4Fle/DUAUtjg1dsl5eloKP5DwPEdGMR5V08On/eheHBYfx6FMDU6w0FVPVKFTWAhLc/s3KLDkYZ8BZ69q/OVunMeKIHIXkf5JLsHhuIK5gX/+AjV4SSPUu2pA2r96kyD3bN+xV7jclyeC9AKVQh0pDTZq2aq5WkYzRIwvZ215tQ/pEJNft9kQJgLcYFaHi2eUmI76G/Ums6fkJ8zAnwdowU0b4Wjl/7UHUvujliIfbjd6dLfSy7PuwjFClSmVBbRZoRR1RUgXVS7hv3MTfgWJTNFLzNN53s3RztPQJggCBVaxb8nEQbTaaVpSwPPFUs0vl/xnZGP8RHazl2MhU/KTCX7gWBOSpzNeXh//SQQXr8B0/hQBG9epO9tABiCEc4Ph/dkDWsKy3okgvPLzR1wz/DkN3nY8vzK+YsSPncRhCMoopRJM9+oJ2wzmCMMVQOWz9tuDZw3XSsXl6VNTN4LbB3rsdnsqCLLNsXTY6ZlYjU5sK4deC+H18I647EcewVM6MTHQ8CECeq2E4yEGKnNY7/R9WbAOaeKOx0DvjH3fIr70fmtiBct7HPvob5x2LtCJ4a+YlFd+5YsKhIcieV2t3JX5nNwa15J2ycns6ktcDrwR4wyCi4Xiek/MTd0Yx5zAc8qnwUNpD7CrOFZHkCoNw1vH0UqlKW6FLvKreX0wQjeqHR10HYg35ss+fDDR6la5pqO32kZ6lq0/HsaKT4ZtmD/W2qu1SMDHeCEBiwwZxA25g5RZRVa6UWh+H3wI1sjtxjBG5r1EqrKTad05Cm9rDLWzRpcb
 va66qfLL
 iUnctq+cdHAM0Bm5/ZBYQldUkz/SMDnrSZqiN/g9hf4MnG4ajWn+UyqqQ5TMObKvqJxHbbBns42lXlb7Hq9hdM32nhvQKWZwvphHVIGmSTzo+IPo/cLoU9BCU2vDAyR/iRGq0s8qv+/BVqNoRXGjr5/tO8mzl7sVqe4t97lgnrORYF8IHO1K67yShvK7YchH6PO6DaeDMt7/DYMsrrGY4qtC7vlJXKH73vbl5iyvFKSRGtwD8kSpqVvia69ZqgvAeSXiEXWdDoEQhangkJMgg7yJPOSIBDTwQGnPyHKkug6c7W+SNGht/Q3S08UAwnfLokf3UJdz+2IiSFxQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To remove the fixed limit on the number of preserved files per session,
transition the file metadata serialization from a single contiguous
memory block to a chain of linked blocks.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/kho/abi/luo.h      |  13 +--
 kernel/liveupdate/luo_file.c     | 142 +++++++++++++++----------------
 kernel/liveupdate/luo_internal.h |   5 +-
 3 files changed, 77 insertions(+), 83 deletions(-)

diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index a643193a379c..59677dc9cdd1 100644
--- a/include/linux/kho/abi/luo.h
+++ b/include/linux/kho/abi/luo.h
@@ -56,8 +56,8 @@
  *
  *   - struct luo_session_ser:
  *     Metadata for a single session, including its name and a physical pointer
- *     to another preserved memory block containing an array of
- *     `struct luo_file_ser` for all files in that session.
+ *     to the first `struct luo_block_header_ser` for all files in that session.
+ *     Multiple blocks are linked via the `next` field in the header.
  *
  *   - struct luo_file_ser:
  *     Metadata for a single preserved file. Contains the `compatible` string to
@@ -85,7 +85,7 @@
  */
 #define LUO_FDT_SIZE		PAGE_SIZE
 #define LUO_FDT_KHO_ENTRY_NAME	"LUO"
-#define LUO_FDT_COMPATIBLE	"luo-v3"
+#define LUO_FDT_COMPATIBLE	"luo-v4"
 #define LUO_FDT_ABI_HEADER	"luo-abi-header"
 
 /**
@@ -138,9 +138,10 @@ struct luo_file_ser {
 
 /**
  * struct luo_file_set_ser - Represents the serialized metadata for file set
- * @files:   The physical address of a contiguous memory block that holds
- *           the serialized state of files (array of luo_file_ser) in this file
- *           set.
+ * @files:   The physical address of the first `struct luo_block_header_ser`.
+ *           This structure is the header for a block of memory containing
+ *           an array of `struct luo_file_ser` entries. Multiple blocks are
+ *           linked via the `next` field in the header.
  * @count:   The total number of files that were part of this session during
  *           serialization. Used for iteration and validation during
  *           restoration.
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index a2510563469a..e2ab7834963d 100644
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
+	err = luo_block_grow(&file_set->block_set, file_set->count);
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
+	luo_block_shrink(&file_set->block_set, file_set->count);
 
 	return err;
 }
@@ -391,13 +352,14 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
 			 luo_get_id(luo_file->fh, luo_file->file));
 		list_del(&luo_file->list);
 		file_set->count--;
+		luo_block_shrink(&file_set->block_set, file_set->count);
 
 		fput(luo_file->file);
 		mutex_destroy(&luo_file->mutex);
 		kfree(luo_file);
 	}
 
-	luo_free_files_mem(file_set);
+	luo_block_destroy(&file_set->block_set);
 }
 
 static int luo_file_freeze_one(struct luo_file_set *file_set,
@@ -453,7 +415,7 @@ static void __luo_file_unfreeze(struct luo_file_set *file_set,
 		luo_file_unfreeze_one(file_set, luo_file);
 	}
 
-	memset(file_set->files, 0, LUO_FILE_PGCNT << PAGE_SHIFT);
+	luo_block_set_clear(&file_set->block_set);
 }
 
 /**
@@ -492,19 +454,23 @@ static void __luo_file_unfreeze(struct luo_file_set *file_set,
 int luo_file_freeze(struct luo_file_set *file_set,
 		    struct luo_file_set_ser *file_set_ser)
 {
-	struct luo_file_ser *file_ser = file_set->files;
 	struct luo_file *luo_file;
+	struct luo_block_it it;
 	int err;
-	int i;
 
 	if (!file_set->count)
 		return 0;
 
-	if (WARN_ON(!file_ser))
-		return -EINVAL;
+	luo_block_it_init(&it, &file_set->block_set);
 
-	i = 0;
 	list_for_each_entry(luo_file, &file_set->files_list, list) {
+		struct luo_file_ser *file_ser = luo_block_it_next(&it);
+
+		if (!file_ser) {
+			err = -ENOSPC;
+			goto err_unfreeze;
+		}
+
 		err = luo_file_freeze_one(file_set, luo_file);
 		if (err < 0) {
 			pr_warn("Freeze failed for token[%#0llx] handler[%s] err[%pe]\n",
@@ -513,16 +479,21 @@ int luo_file_freeze(struct luo_file_set *file_set,
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
+	luo_block_it_finalize(&it);
 
 	file_set_ser->count = file_set->count;
-	if (file_set->files)
-		file_set_ser->files = virt_to_phys(file_set->files);
+	if (!list_empty(&file_set->block_set.blocks)) {
+		struct luo_block *block;
+
+		block = list_first_entry(&file_set->block_set.blocks,
+					 struct luo_block, list);
+		file_set_ser->files = virt_to_phys(block->ser);
+	}
 
 	return 0;
 
@@ -740,14 +711,12 @@ int luo_file_finish(struct luo_file_set *file_set)
 		}
 		list_del(&luo_file->list);
 		file_set->count--;
+		luo_block_shrink(&file_set->block_set, file_set->count);
 		mutex_destroy(&luo_file->mutex);
 		kfree(luo_file);
 	}
 
-	if (file_set->files) {
-		kho_restore_free(file_set->files);
-		file_set->files = NULL;
-	}
+	luo_block_destroy(&file_set->block_set);
 
 	return 0;
 }
@@ -821,16 +790,18 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 			 struct luo_file_set_ser *file_set_ser)
 {
 	struct luo_file_ser *file_ser;
+	struct luo_block_it it;
 	int err;
-	u64 i;
 
 	if (!file_set_ser->files) {
 		WARN_ON(file_set_ser->count);
 		return 0;
 	}
 
-	file_set->count = file_set_ser->count;
-	file_set->files = phys_to_virt(file_set_ser->files);
+	file_set->count = 0;
+	err = luo_block_restore(&file_set->block_set, file_set_ser->files);
+	if (err)
+		return err;
 
 	/*
 	 * Note on error handling:
@@ -847,25 +818,48 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 	 * userspace to detect the failure and trigger a reboot, which will
 	 * reliably reset devices and reclaim memory.
 	 */
-	file_ser = file_set->files;
-	for (i = 0; i < file_set->count; i++) {
-		err = luo_file_deserialize_one(file_set, &file_ser[i]);
+	luo_block_it_init(&it, &file_set->block_set);
+	while ((file_ser = luo_block_it_read(&it))) {
+		err = luo_file_deserialize_one(file_set, file_ser);
 		if (err)
-			return err;
+			goto err_destroy_blocks;
+		file_set->count++;
+	}
+
+	if (file_set->count != file_set_ser->count) {
+		pr_warn("File count mismatch: expected %llu, found %ld\n",
+			file_set_ser->count, file_set->count);
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
+	luo_block_destroy(&file_set->block_set);
+	return err;
 }
 
 void luo_file_set_init(struct luo_file_set *file_set)
 {
 	INIT_LIST_HEAD(&file_set->files_list);
+	luo_block_set_init(&file_set->block_set, sizeof(struct luo_file_ser));
 }
 
 void luo_file_set_destroy(struct luo_file_set *file_set)
 {
 	WARN_ON(file_set->count);
 	WARN_ON(!list_empty(&file_set->files_list));
+	WARN_ON(!list_empty(&file_set->block_set.blocks));
 }
 
 /**
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 090078ad771c..901483e6e4ad 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -89,14 +89,13 @@ struct luo_block_it {
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
+	struct luo_block_set block_set;
 	long count;
 };
 
-- 
2.53.0


