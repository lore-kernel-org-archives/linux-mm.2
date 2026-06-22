Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5841ECDB470
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 11:12:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FD9D6B008C; Mon, 22 Jun 2026 07:12:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AF576B0092; Mon, 22 Jun 2026 07:12:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14FBA6B0093; Mon, 22 Jun 2026 07:12:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C97C96B008C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 07:12:23 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4194612010E
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 11:12:23 +0000 (UTC)
X-FDA: 84907284966.29.9F879FE
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7036F20003
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 11:12:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=m6zf0WV3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3kxg5agkKCAIvctwpucjwiqqing.eqonkpwz-oomxcem.qti@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3kxg5agkKCAIvctwpucjwiqqing.eqonkpwz-oomxcem.qti@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782126741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YXbPmQmazgkFdDbtyTXXxgi0W9OrSOLs1ojwaV9lxRY=;
	b=iolU74UOnV2owVb0nm5CXWhSGYiovtE297HiOack4CkNYuwNn05cJ5+k+Zv1HMZlYekgIt
	/SNphKRm6rocNo67YBptgnvi/XadLKkZS+Y0/hxH4N4B67qepJHZMnpuXewaAtfkyDV3Lg
	/9/zAtwkRz7GOcNBmVBpZaHAJsI7nRo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=m6zf0WV3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3kxg5agkKCAIvctwpucjwiqqing.eqonkpwz-oomxcem.qti@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3kxg5agkKCAIvctwpucjwiqqing.eqonkpwz-oomxcem.qti@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782126741;
	b=YngydmTtEoj9wtRFrd4gukE7ScFcIkrs1X5X9EmoRxZ+ysu6LE/UYFvz3Sas6zWc/iiv/H
	XUKS7zc5IK9Srlp4aLEyklYr0znpXBhh2sMk0EztJ0NThsskiZbMmwhb12O225M3X2vO2n
	IzpymZHTVWKa44CWDvEImN+u7NNuS+E=
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-695837464bcso4315123a12.3
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 04:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782126740; x=1782731540; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YXbPmQmazgkFdDbtyTXXxgi0W9OrSOLs1ojwaV9lxRY=;
        b=m6zf0WV3a009iaQSnMgTtQdcZv2WLfT8guUX2UWBnKk6XaBNp8M/o7BSVOZ1e1xNjv
         pg17Z1WsTWvFsNavgJNDGIE2zzwUhpJ2GPdb+BC4V3gXNY7mmrw+j2hNLq5WMywrvaRy
         yFIpaDXoI8q2HFzuqS8jTOXi0i2aftH70s+HwqvMN4O6fj7bElDpP0Kh2c6GYnwzPjCk
         dWWkTplulgx+tnwMFHSnvz14zIW8E9/2NqaKYirOXSNv7nnDFxVmxph2S32ZT4iixZ+q
         8qHnvHSYwkPPHXuPxTQ7GuUuQxUEoCA0insUrjHMZnyTIw7NHBa7dpRVcCKUto/fg5Z9
         nJPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782126740; x=1782731540;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YXbPmQmazgkFdDbtyTXXxgi0W9OrSOLs1ojwaV9lxRY=;
        b=q0MghqTQ15H9gxGfNg5BBWPIRn9sUtQS7y7WgjCfY0ufgbLJqfbdOtBO7/HFB8+qwi
         dwfor68NMZMe2/s5BsVUbUy8ZYSPsw8HXBj7PRdWSeWHK4zPmMe77GD8xXPtiqqvojsO
         /sLiICqWukzqkqEGeaZlrW1jaCSYKECz05Eon6HLVI0zixsSfBZL6mh8vXUugPsGvel7
         F9xlvXcovUVvuHt8XmnfEP8oXnYQ/FaLu2dP2FXwlATJqBy6YdK22oYbVfu6X99c21Pz
         MBlGO9IG9cMJgEQsPn0v2fBG6tModoHXF4KuyzC0qnhCwsWP/cKEn7ldDvhnSw+b3cyA
         HFcw==
X-Forwarded-Encrypted: i=1; AFNElJ820j5QKcQEZNZ5ajYlRC27D5P7GSqmz8z6hrhIFAX8WD0LlBYOgWq/BdXtrGJo0H+MQHYVi1zbmw==@kvack.org
X-Gm-Message-State: AOJu0Yw0p3Pb287PBvK4eS+SMQyclBRBZxM93J8MXkQv0H5zO4VF7F9a
	sbCgdEF4ic1Cu86cSUDXXLxnIXOw5PLjPlictBlGYvQPYO9p4PibZ+e/7C3W1w8uNl95FQU7L1t
	xMKUOA4XcwzUiVcNcGA==
X-Received: from edai33.prod.google.com ([2002:a05:6402:f21:b0:697:ade6:f966])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:5215:b0:696:8f45:4ae7 with SMTP id 4fb4d7f45d1cf-696e5211777mr6088859a12.13.1782126739883;
 Mon, 22 Jun 2026 04:12:19 -0700 (PDT)
Date: Mon, 22 Jun 2026 11:12:15 +0000
In-Reply-To: <20260622111215.4157974-1-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260622111215.4157974-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.rc0.738.g0c8ab3ebcc-goog
Message-ID: <20260622111215.4157974-3-tarunsahu@google.com>
Subject: [REESND PATCH v3 2/2] luo: Update serialized data to use KHOSER_PTR
From: Tarun Sahu <tarunsahu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Alexander Graf <graf@amazon.com>, Pratyush Yadav <pratyush@kernel.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org, Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: xka6n1bmi5bz39uj7ban15w3d3ad7mnm
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7036F20003
X-Rspam-User: 
X-HE-Tag: 1782126741-446845
X-HE-Meta: U2FsdGVkX19hcY9lyrHmc16FHfRFCEfB/42WxhQIhTc8FEML1mrPQcuMe3Be05xCImr3drQ8EgE7Hq7Fj5Y2HlYdHm5Uz/+sNBUURMHtWbMcXQutXNjVB2niE2rPWMGd/OcYsT4JKEKw/QuQI9O69ZWml8L2oGkw2ium90WIpbzdxzonNIXcoYbio4c6i4m6bfsiN3jjx+rTqpcIU3vkooqszh4A9mDAgFDGersYomJg4lxYjxbSWGNTzPTaqerJn53mrR/HJXLkJaDfvCnjUTYz5pRl+ThGXqA1PsQA/BIss2/J/7+8pB2yV/3rE5xRFb6Z56LGOapnmnxj+A6eC/OqvqqVP95Bh8C8oJ/KJ3XVyznPM7b/r8bbfPqKYsSKa2Bo6g+8KGpsFf22+0AhWJP0ZVdnFT3SC4lo71vcynSdqP04nV08kg0Xgl35F6QyL37qrDl6jBsZ9KkoKvV55Nx9+HTlN+KzGGpo+czS4k/GTQfaMyaftSFPnpP7x4HmCJsnHAd1VXNNQh3iwoES1Brz5eF9hEzXKKnwEBpTRVwS8NZiCTtt+XEdfmKEp9iTtmHPoza4M+H7Lc/Vod3MFdn9zX+k7n6zJJheJ2HCYSgKD1pGjitRHw0bqnALPNai8qXXPajLn2LpsBPSgbTUcV7tb0UZM0GDFl39LHGpuiueld+GXUxZIKRNshbrcyzb0oHDCXtQ+q8tJDJs1AVmLEfKlbGD27fYi6egRHQFJhS8i1NZxLGheEh48AMEBVfHYOu3YLLP+XVXBth3HuCWeciV2zhLfdv+2aLOsb+N2lWdSuzzHknVUzAvFxUQj3e8pw/FWg0nH5vXuDKjYdVvv4t2yuz6PqZVsB0LMq7h1g8KLgFXiuYRt0ntlkYjZa3zqVdGSKOQ1aVPfH7v3Qr+FLaVKCkrWjILrky2NEZXJ2lMGJMswl+7tjOKkf1wShloh8mLyVVYO75J6HI7IGW
 FXxOrYm0
 oylmEXOX5nHzdVWtoiy5qVwLT2vTqDplshOdSZrOcLHhT0zeG3xpzxihvHNO/6CzYFPBXIW3xvf+vYnJA0uTod0lwEK/YJw+kKby+tiWb2MJISL8cpn59b1kspJpUlHjOdx3IY/8PllNVpAVlYfXPpCtB4weH0o4eHjKb0hkOZpldwMLGUKB79vmDzVVDurhl/yEVYoa/Y8e9JTg/ieiHLcu/E2ofOtABkQB3Z2+nh50bkbXuH25bYMcjt340AWWkS0bBSulYb877TKAtjRSB6kKC6fxBK2lbh0OKG7Y6NQRyfH+K88iFRl2CUci1rLCX4YBAcErMlhOwmrmf30FrtVZqmIWHzi/FI3LMF8FcrMLWCRaL0EFXou2JgCL24LkxVmwP15oLq3jfsNINdO65HAYBgEFlZeKujX2i/5Qsyo3l5etKPOrGBiBChxUUuhqy7F72F+Egqyy1bJkVLAK/2e+MYnosdcX1pAULH7aA50NJNUv9L7r88K1HcQM/KgBhWXYFXlOe7T5mUrk4+pEjmnMw764hV6ozjRSGP6bt0V08UgniRUwauTtyg7VqrZJ0Kd31GDGe/0I5ZZvxt9HAWhltjXB7MzNj7l/E5D4r/iLjOfs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert raw serialized_data to KHO serializeable pointer (KHOSER_PTR).
This series also takes care of resolving the bug with memfd of using
phys_to_virt before checking the args->serialized_data value.

Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kho/abi/luo.h  |  5 +++--
 include/linux/liveupdate.h   |  4 ++--
 kernel/liveupdate/luo_file.c | 24 ++++++++++++------------
 mm/memfd_luo.c               | 18 +++++++++---------
 4 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index 288076de6d4a..d5b3b1c0fec1 100644
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
+ * @serialized_data:  The serialized pointer union for this file
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
index 88722e5caf02..480d638b7d18 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -33,7 +33,7 @@ struct file;
  * @file:             The file object. For retrieve: [OUT] The callback sets
  *                    this to the new file. For other ops: [IN] The caller sets
  *                    this to the file being operated on.
- * @serialized_data:  The opaque u64 handle, preserve/prepare/freeze may update
+ * @serialized_data:  The serialized pointer union, preserve/prepare/freeze may update
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
index c39f96961a85..79cfa5201899 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -125,7 +125,7 @@ static DEFINE_XARRAY(luo_preserved_files);
  * @file:          Pointer to the kernel's &struct file that is being preserved.
  *                 This is NULL in the new kernel until the file is successfully
  *                 retrieved.
- * @serialized_data: The opaque u64 handle to the serialized state of the file.
+ * @serialized_data: The serialized pointer union to the serialized state of the file.
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
+	KHOSER_COPY_TYPESAFE(luo_file->serialized_data, args.serialized_data);
 	luo_file->private_data = args.private_data;
 	list_add_tail(&luo_file->list, &file_set->files_list);
 	file_set->count++;
@@ -342,7 +342,7 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
 
 		args.handler = luo_file->fh;
 		args.file = luo_file->file;
-		args.serialized_data = luo_file->serialized_data;
+		KHOSER_COPY_TYPESAFE(args.serialized_data, luo_file->serialized_data);
 		args.private_data = luo_file->private_data;
 		luo_file->fh->ops->unpreserve(&args);
 		luo_flb_file_unpreserve(luo_file->fh);
@@ -375,12 +375,12 @@ static int luo_file_freeze_one(struct luo_file_set *file_set,
 
 		args.handler = luo_file->fh;
 		args.file = luo_file->file;
-		args.serialized_data = luo_file->serialized_data;
+		KHOSER_COPY_TYPESAFE(args.serialized_data, luo_file->serialized_data);
 		args.private_data = luo_file->private_data;
 
 		err = luo_file->fh->ops->freeze(&args);
 		if (!err)
-			luo_file->serialized_data = args.serialized_data;
+			KHOSER_COPY_TYPESAFE(luo_file->serialized_data, args.serialized_data);
 	}
 
 	return err;
@@ -396,7 +396,7 @@ static void luo_file_unfreeze_one(struct luo_file_set *file_set,
 
 		args.handler = luo_file->fh;
 		args.file = luo_file->file;
-		args.serialized_data = luo_file->serialized_data;
+		KHOSER_COPY_TYPESAFE(args.serialized_data, luo_file->serialized_data);
 		args.private_data = luo_file->private_data;
 
 		luo_file->fh->ops->unfreeze(&args);
@@ -483,7 +483,7 @@ int luo_file_freeze(struct luo_file_set *file_set,
 
 		strscpy(file_ser->compatible, luo_file->fh->compatible,
 			sizeof(file_ser->compatible));
-		file_ser->data = luo_file->serialized_data;
+		KHOSER_COPY_TYPESAFE(file_ser->serialized_data, luo_file->serialized_data);
 		file_ser->token = luo_file->token;
 	}
 
@@ -587,7 +587,7 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 	}
 
 	args.handler = luo_file->fh;
-	args.serialized_data = luo_file->serialized_data;
+	KHOSER_COPY_TYPESAFE(args.serialized_data, luo_file->serialized_data);
 	err = luo_file->fh->ops->retrieve(&args);
 	if (err) {
 		/* Keep the error code for later use. */
@@ -621,7 +621,7 @@ static int luo_file_can_finish_one(struct luo_file_set *file_set,
 
 		args.handler = luo_file->fh;
 		args.file = luo_file->file;
-		args.serialized_data = luo_file->serialized_data;
+		KHOSER_COPY_TYPESAFE(args.serialized_data, luo_file->serialized_data);
 		args.retrieve_status = luo_file->retrieve_status;
 		can_finish = luo_file->fh->ops->can_finish(&args);
 	}
@@ -638,7 +638,7 @@ static void luo_file_finish_one(struct luo_file_set *file_set,
 
 	args.handler = luo_file->fh;
 	args.file = luo_file->file;
-	args.serialized_data = luo_file->serialized_data;
+	KHOSER_COPY_TYPESAFE(args.serialized_data, luo_file->serialized_data);
 	args.retrieve_status = luo_file->retrieve_status;
 
 	luo_file->fh->ops->finish(&args);
@@ -748,7 +748,7 @@ static int luo_file_deserialize_one(struct luo_file_set *file_set,
 
 	luo_file->fh = fh;
 	luo_file->file = NULL;
-	luo_file->serialized_data = ser->data;
+	KHOSER_COPY_TYPESAFE(luo_file->serialized_data, ser->serialized_data);
 	luo_file->token = ser->token;
 	mutex_init(&luo_file->mutex);
 	list_add_tail(&luo_file->list, &file_set->files_list);
diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 59de210bee5f..daf2c4c3da35 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -257,6 +257,7 @@ static void memfd_luo_unpreserve_folios(struct kho_vmalloc *kho_vmalloc,
 
 static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
 {
+	DECLARE_KHOSER_PTR(sd, struct memfd_luo_ser *);
 	struct inode *inode = file_inode(args->file);
 	struct memfd_luo_folio_ser *folios_ser;
 	struct memfd_luo_ser *ser;
@@ -309,7 +310,8 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
 	inode_unlock(inode);
 
 	args->private_data = folios_ser;
-	args->serialized_data = virt_to_phys(ser);
+	KHOSER_STORE_PTR(sd, ser);
+	KHOSER_COPY_TYPEUNSAFE(args->serialized_data, sd);
 
 	return 0;
 
@@ -325,11 +327,10 @@ static int memfd_luo_freeze(struct liveupdate_file_op_args *args)
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
@@ -344,14 +345,13 @@ static void memfd_luo_unpreserve(struct liveupdate_file_op_args *args)
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
 
@@ -397,7 +397,7 @@ static void memfd_luo_finish(struct liveupdate_file_op_args *args)
 	if (args->retrieve_status)
 		return;
 
-	ser = phys_to_virt(args->serialized_data);
+	ser = KHOSER_LOAD_PTR(args->serialized_data);
 	if (!ser)
 		return;
 
@@ -522,7 +522,7 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 	struct file *file;
 	int err;
 
-	ser = phys_to_virt(args->serialized_data);
+	ser = KHOSER_LOAD_PTR(args->serialized_data);
 	if (!ser)
 		return -EINVAL;
 
-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog


