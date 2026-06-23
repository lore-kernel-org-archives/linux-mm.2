Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37EB0CDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 10:52:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DA656B0093; Tue, 23 Jun 2026 06:52:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8638C6B0096; Tue, 23 Jun 2026 06:52:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72C406B0095; Tue, 23 Jun 2026 06:52:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 42EBC6B0092
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:52:11 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B854C1C27B8
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:52:10 +0000 (UTC)
X-FDA: 84910862820.25.6495226
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf24.hostedemail.com (Postfix) with ESMTP id D4CF018000E
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:52:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fwX+tk+U;
	spf=pass (imf24.hostedemail.com: domain of 3VmU6agkKCGMUBSVOTBIVHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3VmU6agkKCGMUBSVOTBIVHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782211929;
	b=wdwuyI9T6jw1fZtBuZp0OO6FYbw4kQEeZj8gbkSuEkFORQF69jql2Y6S0OfoLOVl3+NoXr
	3ScVeW/e0TtwM+wOynww96Cnr16HhFr5ClobIg09ioHlSF5cN7xqu8+0X8JyP+rCvx/9MO
	Et7qG69XzWiHBRuIDnHUcONVURO/WkA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782211929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SMLGHTfZnEaHrHkry5MnHfUQ+INjPp4I0JJX2E/+AAw=;
	b=21NIsJC8h+cqXZ/uJhAucFBOIVBOIEag152UzCjlNhWuqjUTl7/sHMKpIsS3FF2wqwJf4e
	gZ7r7AdC4htxCcv4T/QJsmghsFpH8uqclvMENuFlBinBXsq43uKs4rreLaC2zeg59NadFO
	lsGSB+7eKfcSDkptxIhYAw54rl/cOKY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fwX+tk+U;
	spf=pass (imf24.hostedemail.com: domain of 3VmU6agkKCGMUBSVOTBIVHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3VmU6agkKCGMUBSVOTBIVHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-68f9ee927fcso4679294a12.3
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 03:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782211927; x=1782816727; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SMLGHTfZnEaHrHkry5MnHfUQ+INjPp4I0JJX2E/+AAw=;
        b=fwX+tk+U8naWyfnx2gUTFqjYwCKuB1AKnGdeLsX25u51fDKL7EtB/upazCSolTqqBX
         GH1O8FHNxDhSn/pSvo/Lksc66gmeOfVo987l1cCDkOIZ6jZ9+7ucdDXmla+61Hh64+Bm
         O+ybQwm1jGuf0HhEe0uFX/G7ACbWyANf70Ur5xV2N5TXQzrI8S0QRAD6BhQCwgNshpRp
         ZjFTsl9oKPqESgYQ/FgDhxkpjIM68lldMaOueCuSS3al+26Ym9dmVHTg9AEja2cUpaf7
         /lqLrYq2oC6VIu0wjFfIQHli2VeGvzISpD4+AAixXtHukYYJ6zq2qT57QPfBKUCLKFhH
         Eq+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782211927; x=1782816727;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SMLGHTfZnEaHrHkry5MnHfUQ+INjPp4I0JJX2E/+AAw=;
        b=Bz/Kz17nYDBId9JpVC2N4pLSsyfE1A/Cv7kV9ECFhVdcXiLrY2bLRgP4swYk6bvXMz
         BRFu7qL9PdBOWSE29UyFzoBqPePmYnoFvDfXWIB8B1NMPs8IzuzXUl/21WuBh7k7Y3/V
         9FVuBOob/FWT26zxZgf9BCRy560N7yNItiT52euYUUVkgep6fO2JBJ9Ydu03XBmOCCpY
         +jnLBLvxq42fUBbPTmFugoxiiOxxc4Z3dd64YzpROFL8g2lblefxCyr8Rz45Iibn2sWR
         U/rsMGDCQxXk3yOIXY6pMQfrboTc73gbfAj//K29O6BmFwhU16avj+xq69N/yT3WaUSq
         WTGA==
X-Forwarded-Encrypted: i=1; AFNElJ8vpUdjY8gRnxxdBO3DHKyiFqjN7mKZ6oyB/SNZFrr5BuFsddef5tsgxgan88Le1fl77SpQ9gKruA==@kvack.org
X-Gm-Message-State: AOJu0YzpAWyhevGxjWIpAujUdSG8oMCxwIthP+HyY5+I6UoIxo6R66ub
	6MXcp/5iWVTGF2rVZ0rq52yu4CH+/eC7AjkZKK+m4kU9p633DZRBQJwN8k57AR4b7rbDHuQmA0O
	JXQqzS+2rV/D2m5v36A==
X-Received: from edxb16.prod.google.com ([2002:a05:6402:2d0:b0:695:a1ca:4c01])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:3488:b0:68f:c62d:b36d with SMTP id 4fb4d7f45d1cf-697dbafa348mr1069828a12.27.1782211926922;
 Tue, 23 Jun 2026 03:52:06 -0700 (PDT)
Date: Tue, 23 Jun 2026 10:52:01 +0000
In-Reply-To: <20260623105201.3724592-1-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260623105201.3724592-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.rc0.786.g65d90a0328-goog
Message-ID: <20260623105201.3724592-4-tarunsahu@google.com>
Subject: [PATCH v5 3/3] luo: Update serialized data to use KHOSER_PTR
From: Tarun Sahu <tarunsahu@google.com>
To: Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Alexander Graf <graf@amazon.com>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D4CF018000E
X-Rspam-User: 
X-Stat-Signature: s4hwtxh85writjhjdkoir5p6kiysm1aa
X-HE-Tag: 1782211928-906630
X-HE-Meta: U2FsdGVkX1/1VC+uz7CsEBD9XFh7T6NWMQJIV6a3ur8u7h2zon1eFnd8gxd2Ul4eG/xO7n0GUxSPg/QZs6UTd/Ig8uNw6PaowUSakXl3onuMJdHpzuB5lVC7RMRJoruJ2FV4almy3FSCqIRWYXAwsbvGEh5rHrFfLkDe9zpNIWpfbGGEemC5PA46R6DZEBE6UzjQyTWf5RbBx3Ki3LZlD030UEPGPRPctjSLPtIZEvqV9SfVA2Z8u8flt1oG4s3neqtbWrr6n6CZHb0FUllaUsYjLZOujXP5auxNlUjhBOXro8JtIwhkg5FLXb+PSuiJNEkXtea9WaD1HmFHFGpZUZb3mUDj5ElpsX6FALZg7m7Omwt8za82ne+as2b3J425zQKGIBp0IMsd9Tj1TeRdBYCRLrnopHrLaqx5c7m/C+U2q5i4wvYzsf6/qHrGEfQ3ifS4yMU4F3RzjXgRQFHcrweUQfM5SNal5OCYjs64flOjIABgAI28RNJQnA18i+w2qbFdw1jJQiKJPWD369IYvjoTMBEk3udfPFnzqYN2DTbOZFZSIqJ/QxDgOHMzB7X6voXx920RSL5Jnml32kavntx/RB7BjYFC/HkQlSkYbLK/zvBfZ0KCzVE6JYTu4Kuat4Zt0iUZ7GQUgOguo+xOYZGsBaMSAsumULfiCw1NvHhh/z1/UDM1DmDAQGgJOjlkB1oH4d0wklpmXp2MkoT4BRfVVq+orW8DYFEYjGFAaNJwReVM28BiDFMuyqt5Eg+b3lCGXkt/lpsnP6e080XIqIBi3KS/T+fZp6404qNqSwWmESOai6VLPGzeVlIAocoSTmLVKoSVPVucD1M8IUaW5X7OazVYIDKCP7fy+7MxmkbUFy094h5MmJAzwbwOzKrGI1GPTguyNdwYbGy4GwTH34eKe21+7zAVVMH/dveZlrNtKxh2Ud8+WWJT4jwWzoJic+inQ7Tp+Z1xmGS0QQ/
 CPJWhxaq
 oYoCzKk9uPmOMz/wTLZHfq+N/XjleEXSefyCerQ6geQH/0D70iYetBmOlusmkzdG6JzCoMX5BQQf96GCSCT/c8aVTtrShg8Spd1eP01DVBIo+DxaKeodytKGAuJa5OGSi6dUXrjGvutsdT6xb3goKStOs1qrBJhvXs9oOLnNyWyI41RrfmKaEH0XfDU98ZnyHFdH+DDZugAGUDgJFkpu1oKdcTzMLFifRnxzaawvlQv7UdK2VjVtKk9P8y23gVCqLctchipztwYe57SfO1WGFFvTMg6xAbuRrA1D9FgbPUIoV8TMcWhouvSMOyAUY/lMKf3DEkoA+makrvIlVKby2NSzHSbOVSesr0mhtaW81+8SRUGJZq5fhezcMyluTgH2PSnhJtjIq3wtM3COsWbHaWALZy+OV606AOrhc65Il7pNQIJJNaSuJoK56nzrtlAug1jPM5Xu1hYoIvV1cqwpwzINxeCuAJkLNA+VMnLi5WHJWJmIVqhTZwu6SWzSRlmrwezFth6poluNbm0nzYqRUOoucWBt1THlt33rpYxEoKQ5rxEJAo6S7QHAwIlDdEGnWhZh5mOWhB6wLOrMhIH/sUlqX/s5X64cINUQBLZT5+cXkzuxKS440X4zEQRrTG/dH75yY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert raw serialized_data to KHO serializeable pointer (KHOSER_PTR).
This series also takes care of resolving the bug with memfd of using
phys_to_virt before checking the args->serialized_data value.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/kho/abi/luo.h  |  5 +++--
 include/linux/liveupdate.h   |  4 ++--
 kernel/liveupdate/luo_file.c | 24 ++++++++++++------------
 mm/memfd_luo.c               | 20 +++++++++++---------
 4 files changed, 28 insertions(+), 25 deletions(-)

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
index c39f96961a85..aecf19033f95 100644
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
index 10f3983b0060..852b61678229 100644
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
+	KHOSER_COPY_PTR(args->serialized_data, sd);
 
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
 
@@ -397,7 +397,8 @@ static void memfd_luo_finish(struct liveupdate_file_op_args *args)
 	if (args->retrieve_status)
 		return;
 
-	if (!args->serialized_data)
+	ser = KHOSER_LOAD_PTR(args->serialized_data);
+	if (!ser)
 		return;
 
 	ser = phys_to_virt(args->serialized_data);
@@ -523,7 +524,8 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 	struct file *file;
 	int err;
 
-	if (!args->serialized_data)
+	ser = KHOSER_LOAD_PTR(args->serialized_data);
+	if (!ser)
 		return -EINVAL;
 
 	ser = phys_to_virt(args->serialized_data);
-- 
2.55.0.rc0.786.g65d90a0328-goog


