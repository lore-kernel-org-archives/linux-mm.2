Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF6F1CD6E49
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 22:20:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B55296B00BE; Sat, 30 May 2026 18:20:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2BED6B00C0; Sat, 30 May 2026 18:20:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CC606B00C1; Sat, 30 May 2026 18:20:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 885A26B00BE
	for <linux-mm@kvack.org>; Sat, 30 May 2026 18:20:03 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4CD161C1772
	for <linux-mm@kvack.org>; Sat, 30 May 2026 22:20:03 +0000 (UTC)
X-FDA: 84825505086.03.2E4AD5A
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8E1C0A0013
	for <linux-mm@kvack.org>; Sat, 30 May 2026 22:20:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=anq0AHtc;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780179601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tnOZ578sANpIwoJ8k/GY/+cuz8LX/+y1E1AZj+iRbjA=;
	b=pSw6Jf80/WFdy/NwiWmFThAMTUgJBxoeuaozF/gknS9RDaGYK1602VZSn0uTMrTtUFbXk9
	1QMvAPbc+5CJj/8vleO+FcrxjMDVirWMy/xEOM+814g1khS9f2z65nmkkT3WkuX5cZrI0Z
	Hd95cX7BeBfqj+1hE6LYz5LfLa8fUEo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=anq0AHtc;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780179601; a=rsa-sha256;
	cv=none;
	b=a/7/kSXvrXnEpAPkUoxI1H834YgElNGUxWaWFsXqADVXInggBcQRWvja8lmkqGpsvX4UAZ
	dfMMKaTZaxUe41XlMAYd6T82k1ioXYvRpG6uAXoEfHNqUMpsIUCNetrLhnCEERJh1IazL/
	HcM1UMrvzFGDhLxxwklv1n5RNgpnHMI=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-914db83362aso716868185a.1
        for <linux-mm@kvack.org>; Sat, 30 May 2026 15:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780179601; x=1780784401; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tnOZ578sANpIwoJ8k/GY/+cuz8LX/+y1E1AZj+iRbjA=;
        b=anq0AHtcCyS/hojTIhpm5+3fTuyGIliGZJKaPjbUqJgseTZJKY+8zMYMbWwriWiyui
         /h9ReLPYVeCjMZvq1xKEVKLYcraFRAuxvTRAfhNdKZp07pAm7nSNIq5BcH9voWDWxGjY
         i0JW9NdcGaKVlj1kcmwJMjII6baS9USlKXA457o4Eqkdidpl3z7/PFbhWP+EbEqob6ug
         QeVr+QoPDSAYnysyjhOzD/KFMUyTdXHA5xD4uBNEnaNyVShpdSmIl6O5KzVymVx1+1bg
         l2P4Nd78gsDwFub2uCA0UmaVEO7+vFwPAZp6JI5gj/r1R+tAuChrGd7f6+IuyzRUFqZ5
         M5xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780179601; x=1780784401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tnOZ578sANpIwoJ8k/GY/+cuz8LX/+y1E1AZj+iRbjA=;
        b=QBJo31VHmVbq/HYPJWvemT8Hzi8yLSB/EiF2oxHjKQXZmIwcY2keLbWh8d2JiFqyNv
         YGH3yxiwY+c+0GYmcvDr8ZcjtzpQFrFyRLjtfnGM6AIgke6ZgC8lT9z+LBewJl/crJC8
         RvHz7L1uFV6vLbAXNa+cUQ6033E2CDANfpCHJI8KE2uv0HL2K7phN/HqTl6X+Ixtv+fk
         kR3MpQTnSV2rzmxYF1CLmb62oSysd9B/eEYB1eJTqI38ZvJk55f6tagBdXVTHVXobExl
         /AYG8+TaGUR7vJsnrqsd4r6aSbDYMWGBwL1/g+q1MjsNaQN7ClDULMnyQYm7tg9HnUV6
         su3Q==
X-Forwarded-Encrypted: i=1; AFNElJ8I2dBXHkJEC49JJv6e7Gae/Zk23/8Tk/2KU2nqRY0aj9gY06TUdVHJibpHYJyKjAzCVnyWu5KC0w==@kvack.org
X-Gm-Message-State: AOJu0YysEBCaYN58+7lZoiC6rsPdn0S25TnF5wQtSSpC1yHjqigTGrKu
	96uluKXAaZBnGmfPdOZHkcL13+mQewYE6V/GrMsfrOZQ6kc0CslpsMvuZTMcVv7FhDM=
X-Gm-Gg: Acq92OHxp8gFmhrVHQuOU1zFdyBadFVdtV/VQ5V2vnPUlNCok3uCQ/IlrCYBrvRIts9
	BeWuCkt3c3dk/kaZ/LjT3Q/Y0JWig7Zsg4wsl8fih1p9lCz5njc7bZ8QeqB+e0h9DrXybYJNdYl
	83be/cBFqvyMd4Xx9j96RFO5idrE5PzbAp6oHnpNdsAgGtUTLT/Zs36z6CMXe/i4ajVXMztawC+
	ma1781ZDDUBy7x+g6aj/PUYrSHvo/IHnegRdDvvPrZ/Vtwmh+1m9/cMqzA8PlexShvpgDBK0H75
	AFS6fMmpo2UKOUKW/gcRZOowN3NofQciQeJbO5aKnz1sU0cutaJtpynHpprTFB3Nt9bJ3ckCvfv
	G28g67JoBZ2gZjOCmEELymHnxgmaOteleW1vDmCdKwahql8CdJhxWKWNpp96ERvr5ZuX7PbA5Za
	7WrLM8YbNULFLy8w1ojIy7djCuYiFoEXXCt7cyUBqpUH01tSysDarHelXogmxKTQ==
X-Received: by 2002:a05:620a:3181:b0:915:351b:3ad5 with SMTP id af79cd13be357-9153e16e848mr609702785a.29.1780179600683;
        Sat, 30 May 2026 15:20:00 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-915324868a0sm651790085a.18.2026.05.30.15.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2026 15:20:00 -0700 (PDT)
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
Subject: [PATCH v4 10/13] liveupdate: Remove limit on the number of files per session
Date: Sat, 30 May 2026 22:19:35 +0000
Message-ID: <20260530221938.115978-11-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530221938.115978-1-pasha.tatashin@soleen.com>
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8E1C0A0013
X-Stat-Signature: bnk5pfpqtfdcfnzqtoxo9bfh71r9seyk
X-HE-Tag: 1780179601-626988
X-HE-Meta: U2FsdGVkX1+1OxWmXmNIx17wEBr+CQ14CM/FZlNcKWVT6WZJciXZUU/2402Bv7Uzxmb4MvGE9f33IwGmu3aut3Vrgww/mOnpo2IMH7r/K9AmBLF0YhTDJh6hYfpzxlHH/yj5bvzOlbTof6XKoBUxJXAlIksDisZvv9r/GS3rkGhosB4zvmdeQJfxdSihea8pk7TXp9zJcXd5AEW09mUJkevYW2Xr1daC+/QarwKP6DFt3OxW+jCFtfzcJf0TAt+KW9616FBaxdKIkz5NBLb2ysZnhN2slyh78aWOTNUxKyWrhFx2voO+efnL3/uNEcuTzm40v4wkkaWoHoJYaEeDfmCngf6Iob7FIWDPXiYohbOu42PS2LbiCpUtqVgW0CR+q29o3IpxoO/hHEt3fN5QIroxxBq8mqPn0D6qpQtT/S2E0vwfDRh66FB3cVkN5lqNGeEGbeQwqk4Ly6/UMpKl08jCxDqOH9KvqihhFs1xuxzQs9m2sEwCNo+TsTXz6lacKhzbLB7DVCtQ5M5TGCXhaQjxok3JX2rwVWB3eJElqCo+1qoWOS2HEIVDB1gGU6dIn1GVCxLqD2rKwIfkz+D6vWpvuxsQfh8QC6DmrceCbWEtMgVe+NdiDcEmjxO5sJUlbKH+MwrBB1bEJZsR+l0TSNA+bFg571dsw4Bk5WojsiyswXmVdeoopR1Ja71lWiJq1cQH/SRwben4Evvplt+qOR3OlpK7d8MeG5dWqQQ6P4DJqnOCFEIBynwu55zyAurjNlBbt/zF5IOEv8pjmpOmd9W/ElSKnaTU8Z/Ah0K88df82fYdFxFMMhXmX6jDKgQEd3ORM7GzUL945WAMWk/njgYBS/DEQzbKN7UW64909qRd4iaWlv3jmm/jyOsPmBtjFAYhSog2gDBR4u1FS8Uxa9meskHUNGbZzLWZ/snrOroB5geIgsmSYCxXXOCXsShjPR9jAs4ZoLGd6XbArdA
 IVwYd0b8
 1ctEmLI53ZG1ICvetQaIka/Se/btRm3/nC1/TQdArHh5/453IfWv9IaxH4Qc4rHw0LD1X3yCkugSZ7ncKfEL6bwLYlNkUIlXUSPT9faZL8i3w6qX8ndyAG147QscQ8e50rvFtv8oG3ZIQOcSdCAHE7YAFzx9Nela78kLoe7BqtP6XGoSOrjEKelKt4ekeRRhWAuiiNSTnKcJvxMFVtPatgCm1fxBqwtdt2kESE80Hr4tusvx65PNKZa0LZeEobZeeUpkCszWFs8RjaEYAL2CoUcQEmn/9Ge9GGhEz8c8r576AkMicvPcDBvoXuiFu2cdba4oE
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
 kernel/liveupdate/luo_file.c     | 144 +++++++++++++++----------------
 kernel/liveupdate/luo_internal.h |   6 +-
 3 files changed, 80 insertions(+), 83 deletions(-)

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
index 9eec07a9e9fc..a445b1950ca7 100644
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
@@ -848,25 +819,50 @@ int luo_file_deserialize(struct luo_file_set *file_set,
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


