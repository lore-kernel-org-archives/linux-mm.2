Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7708CC43327
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 00:11:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3D956B0092; Sat, 27 Jun 2026 20:11:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA7C06B0093; Sat, 27 Jun 2026 20:11:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B62A6B0093; Sat, 27 Jun 2026 20:11:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 673396B008A
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 20:11:24 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 925961A02C3
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 00:11:23 +0000 (UTC)
X-FDA: 84927392046.03.4940C4F
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf20.hostedemail.com (Postfix) with ESMTP id E3FE11C000B
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 00:11:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aLqnITxJ;
	spf=pass (imf20.hostedemail.com: domain of 3p2ZAagkKCM4DuBE7Cu1E08805y.w86527EH-664Fuw4.8B0@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3p2ZAagkKCM4DuBE7Cu1E08805y.w86527EH-664Fuw4.8B0@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782605481;
	b=n7XYXRwecJkM4eC+GW4nxQ9nXhOfA+nb848JyWqIwZagzEKYtypAiCMWj934o9jWS6dvBg
	c71TNkBeSPXx0nH76U3hNvxXBkRwbWbmgaxax495T3nRPKXqdbWSfHD1oVt65oFkDtKYcQ
	HMGzL1O9C9hRbekAYlZ3nPTbN7qfCOY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782605481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3M9J9XOVcczJl+Z2kGqS39ArQMOVpPdk3Lu1iqM0IEA=;
	b=Kz4Zeg++4xdj03bI/6+kbHmd/IIB/EiShvb9DEyfWzqy5hLgfKdWZISJqwkxXlrgCFCZxS
	vjItRPOFVxLGtCwpMLhmf+kbZU+B1wTctkm/w3nwB1tvGI1v34+tGhQyMlQIcGpsbCYK0S
	tPbkL5fRAmIHCGqjHzH5QX9BfmBWodk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aLqnITxJ;
	spf=pass (imf20.hostedemail.com: domain of 3p2ZAagkKCM4DuBE7Cu1E08805y.w86527EH-664Fuw4.8B0@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3p2ZAagkKCM4DuBE7Cu1E08805y.w86527EH-664Fuw4.8B0@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-c0deb2b9dceso145116966b.1
        for <linux-mm@kvack.org>; Sat, 27 Jun 2026 17:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782605480; x=1783210280; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3M9J9XOVcczJl+Z2kGqS39ArQMOVpPdk3Lu1iqM0IEA=;
        b=aLqnITxJ0q9P9OPM54CPZ+tDaDtMd48MhKAxeDm9xtCcxdCnoYUoJmKzsJYkx/VMBb
         DfhJAiIVQKCpdKKB//j7MER+NZWdj0X//VXlUIMc4A6MmcsDglR2SDGYqsscmhAn8SQO
         FNdzQgjJZtkt4FGH6uX8URZiw5US7wnPefCiKuRdljltu5YF8eC1/+Q1RkcsAuk87zHb
         vNQEAl7WDa13M+3vdFwXUbPYR+fSnzAe3l+eLNVtfyKNzHylV2jfSLXHzm9seT9pkAR7
         Xase/E8mfjCXTtE/t3DztKBSQPp9NqzX80PzaAMsHrn+qBnqNllhzUeb5SR6fQ2oE7Df
         5cvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782605480; x=1783210280;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3M9J9XOVcczJl+Z2kGqS39ArQMOVpPdk3Lu1iqM0IEA=;
        b=AMNCjkfc/Mk8Ua8VrERNWjMytlev+9+0dBpH3JtO7G7Xvs4qM+ldKHlnBxbbPwD43T
         krBSnTf0WFp36/ApgefhIwY5J8pQL6PRfEu+Tfzfigs88nLOVlHVrez0ma/dnxkhqMH7
         7AotJMkUo/xJqCZ2iyQqopex2TRc8wHr340Eefqn8qPiTPC1zvr1r/pgh8s/oH1nvNZO
         hmkdWO1fZY0rwMYOeII+HSYT/X81ktrgiLK4RDmDjZx3JVgynWbeL+7IJp5gJlySRnXi
         78cQi0XwOFgqhw+jnAHe+1J8UYPQLtlJ2/niXzaG8QlIgsElNsu4BVT7oizgwaWvWn9T
         PA8g==
X-Forwarded-Encrypted: i=1; AHgh+Rph8K7bUyJJU5krgikt/AMexF7F691gDAdYgZUAROddgJCZFP+lhPy5zUYwXWeE4Hq0k/pxL9/6KA==@kvack.org
X-Gm-Message-State: AOJu0Yw3xptBiDdI/rFPX8qSwxfWFy/IX6VyQieTvKuIhLbw/Ndgcsbe
	OQTGqP4jh75NkGJcvV0Wlxu9PpcQeSDz6uaiEeTNg1MrwettA/eBfV8Ta7xEQip/+7T2FiSbwTU
	keC5J0nfzqON6QgCnwA==
X-Received: from ejsh21.prod.google.com ([2002:a17:906:5855:b0:c01:db91:5d49])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:fd83:b0:c12:30dd:de2 with SMTP id a640c23a62f3a-c1230dd138bmr301464866b.16.1782605479913;
 Sat, 27 Jun 2026 17:11:19 -0700 (PDT)
Date: Sun, 28 Jun 2026 00:11:14 +0000
In-Reply-To: <20260628001114.1869564-1-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260628001114.1869564-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260628001114.1869564-4-tarunsahu@google.com>
Subject: [PATCH v6 3/3] luo: Update serialized data to use KHOSER_PTR
From: Tarun Sahu <tarunsahu@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, skhawaja@google.com
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E3FE11C000B
X-Stat-Signature: yw8s3t66caihpo4f31eejd9yitauq7w7
X-HE-Tag: 1782605481-60237
X-HE-Meta: U2FsdGVkX19k0t1YBFyjoVjyTbdZuxFrcvPTs0/Qm440ouIOHHIYm8xjd0wAaZs8aAUngnBX4NTUdv25FqTd2+XWRLCXvTIf2z0FXX4GQpY7ffNxxecdvsOr6ls7LAS7j+jYDgJMLkaN3+nrtSvFx7EbCWPDGwvw1sP3Sow7n/WKXHUGloqBNfyIzLSeHydiVoa/5w8Ba7V9U/H8nGs5eQvnP3Hl0Rbz0kXqRcW/u4Z0f2pJ5zWg114EhE0ZLXWU+CrlCVx1OWlznvbEjbdJtxkHqaOJqWfsqkDa4HK8YnJwLVNBnmg8B5FF4N7NW1sLg+Bs1XPl9elcabOBx/dqG5Myw7fc7NBVUBlf5ZieEUwqa1/DBm49fxIXGNCeOKgfpR3rEQHxHtcF914qWAkFXv7sVIs6n43xQu5e3IV9lO8ONNKP+VYCcQtlCI+LVg8GAu3wn0Y0EpnkJWDfu0HIRhEfdd7Po553i1YMpAkpNlSrzQJBSlWUj/LhDdVGgdHsn6B+xxanSkYutXid8CTirQYCxJELzskFvwY/VJCIUt8FfQKlbGN+jMd1W4lH0oMv+Bfxo4qLbXz1qgk9JeebFt0WPL0BTydH+LbbApyEleMrR+/s4O0I3JEw2gOm4wAQ5OJp8r0GdOWU5riOVy+Y8DWsbeM75TiC+Uzx24ZyeT8/mIsdUfAmBMJAA2wmvf84kDkM5DOo4fUMZtC/eUPk0JQnlD5cPS8GPbYnG0m1FPkgW3v8W9X6WewDz/5CtyLcglCmlKwls/mlXOQyTvBc3gaXbgVuMUVH3qeNX50Ny13VwHZKEyI46r919uU3oKgXZj2hZBViF1K7tGf45D7VV3UwawkhnBJ60JCjyfTiEXsxBMaMx2PFgvaLHevW1MABH0cq4Y9xPfpQUFUCQlL8RNO5H3A68DfUPopmpJl10jNS1v9OYzg+EM3uahc1VFQizu/oO7J3x4EsEzkz24w
 vr2ED7ST
 UNbyh8rPa3pf6RB3YaMg0ASy4OiFmr4l3M7Od9yKfj9exiGNiuBuVTr4uUvZgmX7HtKz2t3x8O2Q8EWwRfq2/ZS+mlqnTNWlS/Gd1F4MIsOEHDh1H3jCQTk686F+sImJDF0UD7jRUy/i5aBXQ0C1MiIO7oIEhzRt7+Gz1yJY5/hw0Efd44gEGT4mvEt78rJ6EX+1ejNWeEtzPThEZoMRKWYVd8GFF7saLh7n0IBxe600OGULPYIbJQL34KQNv8WOkA4TBo4k2xjMvWsdEOMfkRWvmixBNhk3UKlrvlYiajfSQfgFgxIk5HRH6OU/VcNene0zTXPJPyDzArYCeU2gussXLBERSECKllrER3h+RKs9vkdMW1gSBbmlEKmYYN36wDSjUWqjLrGA8zWmlbhxOcHTx7omJld8QXnr3dieqKHXLYLqMz9SkwDDXorJgzrkrGN+wqhzlCXMokGbNUYudVMrjppko8wuf2C/FkBZ9wlViIUP9H+lIS33mMI33rioYph0ml7NC1euX1S3bofJEm7PDRY6CRXFM7arob6HUtBJUxi7XmJSISOGG6ahfWRrSsuKSfTM2UEDGtajJd165WSw+Aeg1ImkkOWE+HwGQ1NaksmsDGAIVAzvoCbglfMrNKWpm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert raw serialized_data to KHO serializeable pointer (KHOSER_PTR).

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/kho/abi/luo.h  |  5 +++--
 include/linux/liveupdate.h   |  4 ++--
 kernel/liveupdate/luo_file.c | 24 ++++++++++++------------
 mm/memfd_luo.c               | 22 +++++++++-------------
 4 files changed, 26 insertions(+), 29 deletions(-)

diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index 288076de6d4a..9e78625cfdc1 100644
--- a/include/linux/kho/abi/luo.h
+++ b/include/linux/kho/abi/luo.h
@@ -59,6 +59,7 @@
 
 #include <linux/align.h>
 #include <linux/kho/abi/block.h>
+#include <linux/kho/abi/kexec_handover.h>
 #include <uapi/linux/liveupdate.h>
 
 /*
@@ -89,14 +90,14 @@ struct luo_ser {
 /**
  * struct luo_file_ser - Represents the serialized preserves files.
  * @compatible:  File handler compatible string.
- * @data:        Private data
+ * @serialized_data:  The serialized KHO pointer for this file
  * @token:       User provided token for this file
  *
  * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
  */
 struct luo_file_ser {
 	char compatible[LIVEUPDATE_HNDL_COMPAT_LENGTH];
-	u64 data;
+	DECLARE_KHOSER_PTR(serialized_data, void *);
 	u64 token;
 } __packed;
 
diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index 88722e5caf02..3bcb6890548d 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -33,7 +33,7 @@ struct file;
  * @file:             The file object. For retrieve: [OUT] The callback sets
  *                    this to the new file. For other ops: [IN] The caller sets
  *                    this to the file being operated on.
- * @serialized_data:  The opaque u64 handle, preserve/prepare/freeze may update
+ * @serialized_data:  The serialized KHO pointer, preserve/prepare/freeze may update
  *                    this field.
  * @private_data:     Private data for the file used to hold runtime state that
  *                    is not preserved. Set by the handler's .preserve()
@@ -47,7 +47,7 @@ struct liveupdate_file_op_args {
 	struct liveupdate_file_handler *handler;
 	int retrieve_status;
 	struct file *file;
-	u64 serialized_data;
+	DECLARE_KHOSER_PTR(serialized_data, void *);
 	void *private_data;
 };
 
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index c39f96961a85..5c62d5c32935 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -125,7 +125,7 @@ static DEFINE_XARRAY(luo_preserved_files);
  * @file:          Pointer to the kernel's &struct file that is being preserved.
  *                 This is NULL in the new kernel until the file is successfully
  *                 retrieved.
- * @serialized_data: The opaque u64 handle to the serialized state of the file.
+ * @serialized_data: The serialized KHO pointer to the serialized state of the file.
  *                 This handle is passed back to the handler's .freeze(),
  *                 .retrieve(), and .finish() callbacks, allowing it to track
  *                 and update its serialized state across phases.
@@ -161,7 +161,7 @@ static DEFINE_XARRAY(luo_preserved_files);
 struct luo_file {
 	struct liveupdate_file_handler *fh;
 	struct file *file;
-	u64 serialized_data;
+	DECLARE_KHOSER_PTR(serialized_data, void *);
 	void *private_data;
 	int retrieve_status;
 	struct mutex mutex;
@@ -289,7 +289,7 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	if (err)
 		goto err_kfree;
 
-	luo_file->serialized_data = args.serialized_data;
+	KHOSER_COPY_PTR(luo_file->serialized_data, args.serialized_data);
 	luo_file->private_data = args.private_data;
 	list_add_tail(&luo_file->list, &file_set->files_list);
 	file_set->count++;
@@ -342,7 +342,7 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
 
 		args.handler = luo_file->fh;
 		args.file = luo_file->file;
-		args.serialized_data = luo_file->serialized_data;
+		KHOSER_COPY_PTR(args.serialized_data, luo_file->serialized_data);
 		args.private_data = luo_file->private_data;
 		luo_file->fh->ops->unpreserve(&args);
 		luo_flb_file_unpreserve(luo_file->fh);
@@ -375,12 +375,12 @@ static int luo_file_freeze_one(struct luo_file_set *file_set,
 
 		args.handler = luo_file->fh;
 		args.file = luo_file->file;
-		args.serialized_data = luo_file->serialized_data;
+		KHOSER_COPY_PTR(args.serialized_data, luo_file->serialized_data);
 		args.private_data = luo_file->private_data;
 
 		err = luo_file->fh->ops->freeze(&args);
 		if (!err)
-			luo_file->serialized_data = args.serialized_data;
+			KHOSER_COPY_PTR(luo_file->serialized_data, args.serialized_data);
 	}
 
 	return err;
@@ -396,7 +396,7 @@ static void luo_file_unfreeze_one(struct luo_file_set *file_set,
 
 		args.handler = luo_file->fh;
 		args.file = luo_file->file;
-		args.serialized_data = luo_file->serialized_data;
+		KHOSER_COPY_PTR(args.serialized_data, luo_file->serialized_data);
 		args.private_data = luo_file->private_data;
 
 		luo_file->fh->ops->unfreeze(&args);
@@ -483,7 +483,7 @@ int luo_file_freeze(struct luo_file_set *file_set,
 
 		strscpy(file_ser->compatible, luo_file->fh->compatible,
 			sizeof(file_ser->compatible));
-		file_ser->data = luo_file->serialized_data;
+		KHOSER_COPY_PTR(file_ser->serialized_data, luo_file->serialized_data);
 		file_ser->token = luo_file->token;
 	}
 
@@ -587,7 +587,7 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 	}
 
 	args.handler = luo_file->fh;
-	args.serialized_data = luo_file->serialized_data;
+	KHOSER_COPY_PTR(args.serialized_data, luo_file->serialized_data);
 	err = luo_file->fh->ops->retrieve(&args);
 	if (err) {
 		/* Keep the error code for later use. */
@@ -621,7 +621,7 @@ static int luo_file_can_finish_one(struct luo_file_set *file_set,
 
 		args.handler = luo_file->fh;
 		args.file = luo_file->file;
-		args.serialized_data = luo_file->serialized_data;
+		KHOSER_COPY_PTR(args.serialized_data, luo_file->serialized_data);
 		args.retrieve_status = luo_file->retrieve_status;
 		can_finish = luo_file->fh->ops->can_finish(&args);
 	}
@@ -638,7 +638,7 @@ static void luo_file_finish_one(struct luo_file_set *file_set,
 
 	args.handler = luo_file->fh;
 	args.file = luo_file->file;
-	args.serialized_data = luo_file->serialized_data;
+	KHOSER_COPY_PTR(args.serialized_data, luo_file->serialized_data);
 	args.retrieve_status = luo_file->retrieve_status;
 
 	luo_file->fh->ops->finish(&args);
@@ -748,7 +748,7 @@ static int luo_file_deserialize_one(struct luo_file_set *file_set,
 
 	luo_file->fh = fh;
 	luo_file->file = NULL;
-	luo_file->serialized_data = ser->data;
+	KHOSER_COPY_PTR(luo_file->serialized_data, ser->serialized_data);
 	luo_file->token = ser->token;
 	mutex_init(&luo_file->mutex);
 	list_add_tail(&luo_file->list, &file_set->files_list);
diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 10f3983b0060..a83360551cc5 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -309,7 +309,7 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
 	inode_unlock(inode);
 
 	args->private_data = folios_ser;
-	args->serialized_data = virt_to_phys(ser);
+	KHOSER_STORE_PTR(args->serialized_data, ser);
 
 	return 0;
 
@@ -325,11 +325,10 @@ static int memfd_luo_freeze(struct liveupdate_file_op_args *args)
 {
 	struct memfd_luo_ser *ser;
 
-	if (WARN_ON_ONCE(!args->serialized_data))
+	ser = KHOSER_LOAD_PTR(args->serialized_data);
+	if (WARN_ON_ONCE(!ser))
 		return -EINVAL;
 
-	ser = phys_to_virt(args->serialized_data);
-
 	/*
 	 * The pos might have changed since prepare. Everything else stays the
 	 * same.
@@ -344,14 +343,13 @@ static void memfd_luo_unpreserve(struct liveupdate_file_op_args *args)
 	struct inode *inode = file_inode(args->file);
 	struct memfd_luo_ser *ser;
 
-	if (WARN_ON_ONCE(!args->serialized_data))
+	ser = KHOSER_LOAD_PTR(args->serialized_data);
+	if (WARN_ON_ONCE(!ser))
 		return;
 
 	inode_lock(inode);
 	shmem_freeze(inode, false);
 
-	ser = phys_to_virt(args->serialized_data);
-
 	memfd_luo_unpreserve_folios(&ser->folios, args->private_data,
 				    ser->nr_folios);
 
@@ -397,11 +395,10 @@ static void memfd_luo_finish(struct liveupdate_file_op_args *args)
 	if (args->retrieve_status)
 		return;
 
-	if (!args->serialized_data)
+	ser = KHOSER_LOAD_PTR(args->serialized_data);
+	if (!ser)
 		return;
 
-	ser = phys_to_virt(args->serialized_data);
-
 	if (ser->nr_folios) {
 		folios_ser = kho_restore_vmalloc(&ser->folios);
 		if (!folios_ser)
@@ -523,11 +520,10 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 	struct file *file;
 	int err;
 
-	if (!args->serialized_data)
+	ser = KHOSER_LOAD_PTR(args->serialized_data);
+	if (!ser)
 		return -EINVAL;
 
-	ser = phys_to_virt(args->serialized_data);
-
 	/* Make sure the file only has seals supported by this version. */
 	if (ser->seals & ~MEMFD_LUO_ALL_SEALS) {
 		err = -EOPNOTSUPP;
-- 
2.55.0.rc0.799.gd6f94ed593-goog


