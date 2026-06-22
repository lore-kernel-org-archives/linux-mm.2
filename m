Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEDD6CDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 10:33:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90E416B0098; Mon, 22 Jun 2026 06:33:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 898536B0099; Mon, 22 Jun 2026 06:33:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7120B6B009B; Mon, 22 Jun 2026 06:33:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 33E296B0098
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 06:33:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6F6C2167011
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:33:53 +0000 (UTC)
X-FDA: 84907187946.20.538BF6A
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9B6722000D
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:33:51 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=I3AXK1QE;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 3jQ85agkKCOgdKbeXcKReQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3jQ85agkKCOgdKbeXcKReQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782124431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YXbPmQmazgkFdDbtyTXXxgi0W9OrSOLs1ojwaV9lxRY=;
	b=5Hs00CsIhUZbru0b3CCgvyrU0lNHJkXUtTnCry8MOp4i/ahCT/EKT7MN+JDiWsVMR+MzUa
	vpD0lVmqiqQs6nACYjwOwtqEb0OMIs9XVzy5pxABXH64nPM3jF38Do9wSg9LNQjYK6cjZD
	ke9Wepehjr8tGT/t66jaI0Wns0DfrJU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782124431;
	b=tCHT3nfyKJAlY9pNaUnjq+AuubM/4Ilhr9I8w1PAUAHHDC9akjoMJX1FYK9wHfNDvuvh2b
	sYPLxTvMVMk7YhH5KDgm79g+luNHDoeR4qhXWQx2lcEaVIILbYgAOKHzqtA0r5GKJN0xx0
	js1iGnpW3BbKbw3aiVfepwiwd5U+o2U=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=I3AXK1QE;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 3jQ85agkKCOgdKbeXcKReQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3jQ85agkKCOgdKbeXcKReQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--tarunsahu.bounces.google.com
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-69564c1df1aso4315848a12.3
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 03:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782124430; x=1782729230; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YXbPmQmazgkFdDbtyTXXxgi0W9OrSOLs1ojwaV9lxRY=;
        b=I3AXK1QEUJu1FzDFq7ZoVkL+ZBLLUZn08gu4mrkrBmzq9EOxoK2sJlfoUbfumChvaj
         l2Y2KUQubtdtDteF5I0UhIRq5VaErnb/AhDd0QMHsBXjNlTEv/I8gmof786wOWHUnlLc
         os/Bt3l8rQ7wH+McrA+2OBfrTGHKIBYC6h2hpA/NF7eckZiIHR1ai096E3z4JB2JKa51
         G/MO/MjqW2G/Hv/fDlceU7YYNfs//lEGqkH8g2E5H22niYUxgnlFrwLjkYaiCweYPfj4
         vjo7HK2lPPMOGao5aL/hRFNa8sgNq0Gu46AjTX/YDfX/pOG/s6yYwmSc4ulXhJABFaYw
         Achg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782124430; x=1782729230;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YXbPmQmazgkFdDbtyTXXxgi0W9OrSOLs1ojwaV9lxRY=;
        b=BqxRrme1PNeovh3Z10dXgOPITHbkP2N/dZrAqKWZTAPbRMtsxpCfD6Pf/DsfjupTbd
         zqg5g9kHLpsIc58V7XM8aIiAGAx4opM/gQtBeCmypfpx7WWdATNdaqeCg6Uotw942ZKG
         pIdIC2PhWUqsWQvPxOyI6p8jwvLBz2Vk51kO0e51wqcSt4N6k/n5OuBiue7dcf0pUulH
         4f7UJCDLDKMpe5dNDEhI1rS5QKO30zxCJ7vXYEKOaRg6w6t2s30lzMP9FjcdCKsxqFmq
         qz9XEbE0rMkKkCFsCET25zHJWQg5e/wY2IPK9a74bqOjjSvRx/C2D85qdl/T/p9//kvL
         GDew==
X-Gm-Message-State: AOJu0YxQTxQsrswbWpThDGci27E5cQKt4vpMwGWBjoxoar8FzNzKl3N8
	mshoJMPc4N/GO0edDgZGdyWXGIgJ8eK71JHYAYk7h7hfO/V0DAtI6xMh7ow+Qr14ZaYzxCOfui2
	uHb7KzaWh2hdkGA0HPQ==
X-Received: from edgi14-n2.prod.google.com ([2002:a05:6402:a58e:20b0:697:7954:5e61])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:5386:b0:691:b158:b416 with SMTP id 4fb4d7f45d1cf-696dde5eb11mr6235016a12.6.1782124429706;
 Mon, 22 Jun 2026 03:33:49 -0700 (PDT)
Date: Mon, 22 Jun 2026 10:33:45 +0000
In-Reply-To: <cover.1781866575.git.tarunsahu@google.com>
Mime-Version: 1.0
References: <cover.1781866575.git.tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.rc0.738.g0c8ab3ebcc-goog
Message-ID: <a2fb71c8bff5f9eda0616a96da52c2bc892f2760.1781866575.git.tarunsahu@google.com>
Subject: [PATCH v3 2/2] luo: Update serialized data to use KHOSER_PTR
From: Tarun Sahu <tarunsahu@google.com>
To: Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Stat-Signature: 5nfryfrmsuc3pt6bw88fzgq683p8b1g4
X-Rspamd-Queue-Id: 9B6722000D
X-Rspam-User: 
X-HE-Tag: 1782124431-644024
X-HE-Meta: U2FsdGVkX18oMM8aTgwDCZxBYGem38XFZHoTJjNGM69oibA1fXt6FVLiOwFKnBaYkhg6T1a5O2HaKkMtGI/1PIQIjtmo2iUwEXYb+if1twvoIJhrupKE4Sn2yXgP7QmI/bX98tb6e3aCJcri5/Hp5fync955OHhwK+tQIMEmyM6UpThWhNAEuhjwysVeuz1s9qCpbTiD25yX5BtXfqws3Xgx51knKb0+k4jcxp4YW4PMawFdsIm0uvQsRet6BJDRuVUTH8ofQDsXb92jPFrbsR8xOrMCJLATp0TlnK1LZvTcqkbGxlLIMGZ4L47e72r5YMu7lMjEg1V+Nqs+rg86+C2fHok4T8buvEVE4UyVjPIpf76RtZr3GQdtQxmO44pCWfMOLaUOg8+2miglAuKWD7GjnwqStkQ7ZE9Xpyp9RlzlskiI8zXe3K68M38kBqLgvEtzjkNPx4PY6oc0MZVqoXzAAsiBSfTu4Fz1CBx3ydvS6i+N1rGamA1NWB2Ykd9hSBsMkOKUseIHmfu1GwxXfXVDfWNRKdyZhUUxhIoEduSq48ZqvIr9u4jxSwnyap4X5yz+rHG9sFIoc9ooGtPnO4dgaNX6iPCWl14lPVZOzsH1c8L4DYBPwNWCec8gbhqiWsEVSLK9cMMuj2SA38gnK2C6zStqomsfKMlm9QpG3RJjqQxQWnzigxVmAQ4sf112/KrfFPxyrG5kszpn2pPKa5Xvn4NToSWyzcJ3CxJ6o9afftq2oEbuikOvrFLi9O98uLPIdGyzW7nJs1UmiOBWXSHeZUDgv8yZ8d5YW/5OVhEATQb0UCjIhcwe3h4nHSbRKoqi+ubEimK9jZFMbbuXtQpo4ir5HtSxv/S5VnP6HqEu1SnUT6vwNpedcGxqjR+gRLAmKq0B7UkY47IPHRHUu8F5LYfkAn3+JOIk1FXyU+ueMkbU76E8c4Y+IF8gIjiv5FAzqnQirUk+3Wj3pxY
 BcJE55+H
 yJQa8I4IpvxRoLSqx7mmNZIQtpcfgHsjoesGNVa5sP6mjZLk5ThT0yv76vVtK8iwC7fWA8KjLUX8m1lx1QF+wdpJflMUaS65MujslfSF6UAbtZoY06Or0uzfikQy9GMRgkKXBzWOOvL2r9/l5Zhx7NUaMJD8WVWUhGf+WwdyrXQ5iuAADwo7mtJqSEIdK8R8EwMPndAKUqB4fiO2rFT5evHoFh8lMYBR78sAd7f8pDwOPGQeP2qLmeYP6CHsT+WzYC2e2HUpl6ZgjFVAyifhvt8e64PMPSZ7Vc2ad5u2NQ+Rs+xMSLmowXpfJd/ECKhy0pXC5DC4TX4BDEb6VEemraleLEqp7+uui/NEmP7S5uZCKC1J8kFB5SB79GYTpqBxSG8bPY4u7y0AnyQbDksLY6vcsEkJ96ZVKNbl0BOxxyFbynBgHYytlI6gImi1E1qnpv38OZO+u9Of2vnb94zpw38mYd0sZWouYTwYPGj+ey6xgzUjNrr4ju+qfOezQzka1nn4OJBswIHJZlwA3qKgt6eWlWnZ4LxZZXeT2ft/gWN4AcD6GN1SPmU/uqSQGLxLaVXD0CDQCYw8WMQZASZ5vVXw/aYHH3lNVNhwD6lWWhnc1ZVw=
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


