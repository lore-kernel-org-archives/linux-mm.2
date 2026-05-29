Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64EA7CD5BD1
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 03:21:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75A526B009F; Thu, 28 May 2026 23:21:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6811A6B009E; Thu, 28 May 2026 23:21:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E6D96B009E; Thu, 28 May 2026 23:21:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 326096B009E
	for <linux-mm@kvack.org>; Thu, 28 May 2026 23:21:22 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE8F5140F7C
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:21:21 +0000 (UTC)
X-FDA: 84819006762.24.5159C88
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf13.hostedemail.com (Postfix) with ESMTP id 375CF20002
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:21:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=D0meV+jq;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780024880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oZd8mWvo7gp73ILBBgVaF/bc9fDtru0D8V/2+ZV2cFk=;
	b=OcchDMkwE6NF10AJuWeghkXLtootLvTN14isHB0eOVbTKmhThLyHWhBsrA/cnqJLzqXysf
	zzZlqd2xPiVn3C3ggKSI6Hx8E7dni9pF3uFXLBaAkjlBGZwmwL/CpATkVgxdHBrrMXUpec
	+mfldJYGFiHxslrCZzio44V/aLcZSj8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780024880; a=rsa-sha256;
	cv=none;
	b=s6vOqHS8EJvb8/AxUCLMM3TX4zxBziCtMi/1jOlXyP785pUeCpmcWwU5VWV9Qn+mQJHK5f
	R3EX6BKhdDvoiKRPNqn+qsmrRWTAUS4N5xPTz7lo5nuMPUfdJGoIPAbChoCG4eLCmAkDLk
	OrUq86akgjk2SSNDbBkFC4Fne5nNcLQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=D0meV+jq;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8b98482b253so217224056d6.1
        for <linux-mm@kvack.org>; Thu, 28 May 2026 20:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780024879; x=1780629679; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oZd8mWvo7gp73ILBBgVaF/bc9fDtru0D8V/2+ZV2cFk=;
        b=D0meV+jqKquyWlaufB36gagNUyd8+KyHR2yQ+aIyDUA4KEci68Ifo1phLF65DeGd6b
         JOtRH6Zs1Ggq/vQUbxHa8EzMjpZ0nWvmJLRSPbNGgwMODo94xhTWop6pK6znj8ONlLR1
         ZjFUttn1fantP5orBZ7DRDIyCkK0F5s9DPu04Eoh7wFW8Iw9hDYch5JCk6IPMdyLrApr
         MGL9sYD37RduEap+7jqJ73EtZnpMN3Nt1GH/R9OB7DE5V5Wr0hW5CTWUjZiAqCQd+x+o
         Uab0lRrb5cSDMw1vqd47pJnWrGZdE7CeIsJbvtpI6AHmUvgCbS62hU0EbaAGjU6Sm7vZ
         Xf7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780024879; x=1780629679;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oZd8mWvo7gp73ILBBgVaF/bc9fDtru0D8V/2+ZV2cFk=;
        b=F3bbS6kFVRVbb22XCg6Np8Lg6kddTbnn2+4GwbSyMFoYl38M3HeliUQpCBw581MeVN
         9uqSD6tcCTFfeeppD8pUtf6eg62lxJmnW2mGHC/PejgcwoTfaOQYtpcvDwMfR82Owu/G
         +zhGccaQtigzUDmg8hMtt/58Fcsk6OODIdbP6SCL0mHMOd2vNKw7mR6b1DNzrtkA0Fr4
         Dex9kiq9iTX4xF9hqQOY+/g7Ulm4qAZtsnthA/A7JoHlXImrAPrG3f+E8g33gYkX/Fc0
         Q3VPfZcuXoxtOsDolPtoBKqg5fYQ5rjcgdpJun5VEjwDGNGF5L3N/P5QgYe9VmbAbet3
         QIZw==
X-Forwarded-Encrypted: i=1; AFNElJ+gb3wkLEFNcVapwLQaC/0p09qK5NXZteigsI9UthmTla9DID4wMeGy57yaPQ3sdjC1t0c1pPtSJQ==@kvack.org
X-Gm-Message-State: AOJu0Yx7PChOtOMGNsNiaR8RU69D1+3GClPkW/HZ8FvJqv6XVOcE6vfV
	3bmO1N0527pLEfLN1VNSojXE0f72uPlhuZZE4R827RvhqB2kI1ejRWy2FzilsRUu8Yk=
X-Gm-Gg: Acq92OEhE54A02tXPfcXOpdmfCddr9RDRjRR84qQGu+u2mfJ6MaBqkaO2eq/GqZIK+q
	YGUhZ/byFDM3zF24+tKD4jEio9nfkPAa+bnTYu/5ePO7eYu/BnZ9EIFFuWA5wAz06hY0YXdkl0L
	fZNhFczHsjeUcNbaOc/pos09Bn4r3z28iRh8PDpaalvRRC9pOg82+lQYQd92yW1C8PwiIXTs53X
	R+EWQcr9w3WNY5akGSCaGPuUT+kx/AIMAw5E222Jeaw/dPH0Z5bel6xAo2Brwe+p9FutW0huHIn
	AiqqieaUwiOcPBbWk9+fX5/15qDkpPRZ9dMmwtyoqF3ahh+KmVuVV4sVFuQ/MTMqsoBc9i9ooaM
	i21bV9FuY6AyqmXIWJqv4cQBGbdNkNv0i1udXJrZlxXLDZjiid6s1eD7AN7sDGUtdGGfnWDclxL
	chctraTSEefPMZPiF2x5oeqBHnmYHS2EQsGtHxmPrGiWmW/VUm9Wpbpc0iaDh6rQ==
X-Received: by 2002:a05:6214:1d0e:b0:8ca:2a4f:7364 with SMTP id 6a1803df08f44-8cce801ecd8mr12833796d6.29.1780024879286;
        Thu, 28 May 2026 20:21:19 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ccea26d286sm1179476d6.48.2026.05.28.20.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 20:21:18 -0700 (PDT)
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
Subject: [PATCH v3 08/11] liveupdate: Remove limit on the number of files per session
Date: Fri, 29 May 2026 03:21:03 +0000
Message-ID: <20260529032106.1505796-9-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260529032106.1505796-1-pasha.tatashin@soleen.com>
References: <20260529032106.1505796-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 375CF20002
X-Stat-Signature: 3a1if3qtythw6aw75suiigcxyq3kqpgp
X-Rspamd-Server: rspam06
X-HE-Tag: 1780024880-890853
X-HE-Meta: U2FsdGVkX1/1gKPbMIabBta7ZhIBR7fwkSx0dwezkiDPogYpZOwCQulMVnBQzsQ0sxujHdTqjX9bSylFxZt4jy+5u/kRJq1KqJ512vAGRzImYwEAwsdCuYgjxgkdb8L1yNIFdjNfoOoolX48dgzzJJFq8H1k7LPXYkGF1e3sWbIEp6EoKHe14Dk23Aqmo13gpaTa7fKj0iB2oPEvKH3xwVLGechm2pQBp5uLunsebiuWFm3dAyJfY4nYyULrGgp27bfxNp9K1kp1NepgkzaxG4WwXCtf/BLYGszfifh0FMq7olbp1ZwWJr7FwyX80ZNXzE4uooZq9iq1s6Xc6G2twSwXqrlDfi/a2TSMwlpeffLq/0x3dQ48cI8d7+psW+1cO4a9LL6G9bR3nYY2TXCfwqsOkbonedbWDaAi23rhyXwZyfbVJCQeUX0KjjPMot/+z0zcjEHBpvxC44ECemuKP6awJOlWA3H8BvsFcO9bPOgxGsTRDi13bUTmp7lUOqvhfVdMCIjaB2mHdoa9b7caopqeVeWlDx4VICoQF6Z4flXxuaWHhFXGSM7NpNO1xeUKxI1XustpeR8P+lOfCc5QEp/7SuDXXt29GJwfGY0nzKxTVaNkvWGxrBHyz4a99qDcoLB8aOse999ldQ2qbjTUZ1d8O7sxZewVXR3qmMLLZYGYyRp2hCftM1fGD/FrcOD0MhIehlgYQ+qHrjRWDMjKhUZEUEnQ6F27iI1D2V/9tfz+9dw2QfJdBKh7d4lsETGHwqVMVOlHFo/k42ILL0wJaO0ONTwGOfOYeMg7J5LrzJeHyaY2UsHuD/q4aErsg+GxcDaxRF1wmm5Fp99pD6qPPxHJgRx3NxP91tJE/5Os7p8cULfwiqogIBa+HMl6TlOuRF0fpvDUQmxJbdMvNodCDw/5SfJOdBja9dactem6zssbJGhLb8cZ6TZHYRU+hjBII0dKSwKj4ivTrz5UE6K
 66crhNt6
 SDaSiuimQv7sIjyQ5zMf0oyKJAMgOYAwA6E7yTIrgm86W0vI+/6I10YMPTlIkeRw0V1mhVS9BEAONNrRR5xMlNTkAJ475OypcF40r35QEKE5Sktky8Pvjr3LrY/j8KuX06miL4/pnGr4a1AQy9Yso+vlyz1yScGew+/cT4UlGwBAiqfgCtPBTmR3YdWTL7MV447SJJCrX4yAe5VMh+Lo7BoIxa2oJj94jxVASS9nXkYQV2+jKWcih/kwA7mROD8uv8f+WsjAQxuWQqCoGM150lnMtttLi72guJb78A1MWp12XLl3hFW4h/GkZLg==
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
 kernel/liveupdate/luo_file.c     | 142 +++++++++++++++----------------
 kernel/liveupdate/luo_internal.h |   6 +-
 3 files changed, 78 insertions(+), 83 deletions(-)

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
index 9eec07a9e9fc..06eb083cc759 100644
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
+	err = kho_block_grow(&file_set->block_set, file_set->count);
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
+	kho_block_shrink(&file_set->block_set, file_set->count);
 
 	return err;
 }
@@ -392,13 +353,14 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
 
 		list_del(&luo_file->list);
 		file_set->count--;
+		kho_block_shrink(&file_set->block_set, file_set->count);
 
 		fput(luo_file->file);
 		mutex_destroy(&luo_file->mutex);
 		kfree(luo_file);
 	}
 
-	luo_free_files_mem(file_set);
+	kho_block_destroy(&file_set->block_set);
 }
 
 static int luo_file_freeze_one(struct luo_file_set *file_set,
@@ -454,7 +416,7 @@ static void __luo_file_unfreeze(struct luo_file_set *file_set,
 		luo_file_unfreeze_one(file_set, luo_file);
 	}
 
-	memset(file_set->files, 0, LUO_FILE_PGCNT << PAGE_SHIFT);
+	kho_block_set_clear(&file_set->block_set);
 }
 
 /**
@@ -493,19 +455,23 @@ static void __luo_file_unfreeze(struct luo_file_set *file_set,
 int luo_file_freeze(struct luo_file_set *file_set,
 		    struct luo_file_set_ser *file_set_ser)
 {
-	struct luo_file_ser *file_ser = file_set->files;
 	struct luo_file *luo_file;
+	struct kho_block_it it;
 	int err;
-	int i;
 
 	if (!file_set->count)
 		return 0;
 
-	if (WARN_ON(!file_ser))
-		return -EINVAL;
+	kho_block_it_init(&it, &file_set->block_set);
 
-	i = 0;
 	list_for_each_entry(luo_file, &file_set->files_list, list) {
+		struct luo_file_ser *file_ser = kho_block_it_next(&it);
+
+		if (!file_ser) {
+			err = -ENOSPC;
+			goto err_unfreeze;
+		}
+
 		err = luo_file_freeze_one(file_set, luo_file);
 		if (err < 0) {
 			pr_warn("Freeze failed for token[%#0llx] handler[%s] err[%pe]\n",
@@ -514,16 +480,21 @@ int luo_file_freeze(struct luo_file_set *file_set,
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
+	kho_block_it_finalize(&it);
 
 	file_set_ser->count = file_set->count;
-	if (file_set->files)
-		file_set_ser->files = virt_to_phys(file_set->files);
+	if (!list_empty(&file_set->block_set.blocks)) {
+		struct kho_block *block;
+
+		block = list_first_entry(&file_set->block_set.blocks,
+					 struct kho_block, list);
+		file_set_ser->files = virt_to_phys(block->ser);
+	}
 
 	return 0;
 
@@ -741,14 +712,12 @@ int luo_file_finish(struct luo_file_set *file_set)
 		module_put(luo_file->fh->ops->owner);
 		list_del(&luo_file->list);
 		file_set->count--;
+		kho_block_shrink(&file_set->block_set, file_set->count);
 		mutex_destroy(&luo_file->mutex);
 		kfree(luo_file);
 	}
 
-	if (file_set->files) {
-		kho_restore_free(file_set->files);
-		file_set->files = NULL;
-	}
+	kho_block_destroy(&file_set->block_set);
 
 	return 0;
 }
@@ -822,16 +791,18 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 			 struct luo_file_set_ser *file_set_ser)
 {
 	struct luo_file_ser *file_ser;
+	struct kho_block_it it;
 	int err;
-	u64 i;
 
 	if (!file_set_ser->files) {
 		WARN_ON(file_set_ser->count);
 		return 0;
 	}
 
-	file_set->count = file_set_ser->count;
-	file_set->files = phys_to_virt(file_set_ser->files);
+	file_set->count = 0;
+	err = kho_block_restore(&file_set->block_set, file_set_ser->files);
+	if (err)
+		return err;
 
 	/*
 	 * Note on error handling:
@@ -848,25 +819,48 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 	 * userspace to detect the failure and trigger a reboot, which will
 	 * reliably reset devices and reclaim memory.
 	 */
-	file_ser = file_set->files;
-	for (i = 0; i < file_set->count; i++) {
-		err = luo_file_deserialize_one(file_set, &file_ser[i]);
+	kho_block_it_init(&it, &file_set->block_set);
+	while ((file_ser = kho_block_it_read(&it))) {
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
+	kho_block_destroy(&file_set->block_set);
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
+	WARN_ON(!list_empty(&file_set->block_set.blocks));
 }
 
 /**
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 28ebb4f3000b..2c5e8bcb219c 100644
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
 	long count;
 };
 
-- 
2.53.0


