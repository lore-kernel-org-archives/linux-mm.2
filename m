Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDDEECDB46B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 22:57:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA5926B008C; Mon, 22 Jun 2026 18:57:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C04986B0092; Mon, 22 Jun 2026 18:57:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF4396B0093; Mon, 22 Jun 2026 18:57:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F2706B008C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:57:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 830F51C53DD
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 22:57:44 +0000 (UTC)
X-FDA: 84909062448.13.B35257D
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf31.hostedemail.com (Postfix) with ESMTP id AB85F20003
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 22:57:42 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gRolvCHz;
	spf=pass (imf31.hostedemail.com: domain of 35L05agkKCJ8S9QTMR9GTFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=35L05agkKCJ8S9QTMR9GTFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782169062;
	b=6JZODh2/75z95vYRFn3z1D4PuPTYMNFcq/1fup3p7YKoK+Cs4+VTOPgYBquLPRibyGg93l
	JfPrMr7YogC3+mp/UFLb8qUy431B4oR6t4nFw31zEClJYSqPnfDSFjtEtCMNWXLb3WCgHM
	xwRryDsSrkWyco509bjDH+sQl3FZVDI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782169062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sRZrLthkTJ+oSLlciaViXq2bIONqNfchJosHekKaVpU=;
	b=WqyctN1PNGsOJtNRLI1asALyE6NagIsL0RclU4kH92kJrhuaYnE1LndL2vjY12cHTlATa0
	idoM8LkUmpTdnCCbJMOmraPIiBq71vjubF3EVTqGKe+tVXtQPUs4MvKOOSxVB3ee/BMsrg
	/C/W8N1BQOYvwmdbEXJQd5Z5MhGvY/Q=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gRolvCHz;
	spf=pass (imf31.hostedemail.com: domain of 35L05agkKCJ8S9QTMR9GTFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=35L05agkKCJ8S9QTMR9GTFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-697498c701eso3645243a12.3
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 15:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782169061; x=1782773861; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sRZrLthkTJ+oSLlciaViXq2bIONqNfchJosHekKaVpU=;
        b=gRolvCHzANZU1vj5iBK0eEeY4GARl8XpjUqwEZ3W2GeYqcjIEW1GZgxU00Qh8BE/Rr
         5Ixa181hJRl+t3n2Dwcr33wupcWmTgCTZ+BBevxk1QCFTYvCjdokIiQv6jFNLWhyuC1I
         Nlv9N0zHsq9HwZvBQH2p4Gdwh8bkxecG+qucMHSZEbvyXo/7fEs2hFovfCi5ADL1tECa
         lkiZh/cj+T2X+4ra9w/R6YEu376Zjz9+1eD3rFV4xLAV+vCHkh4dW0CnehBVMhxd0xmU
         Pd7I9pCv3drzg2gxKVwOynI2VzFFiOLQ/MRrX8PhNXjw4Dggtg8dUIzBDuLjb4czXYNv
         ec2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782169061; x=1782773861;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sRZrLthkTJ+oSLlciaViXq2bIONqNfchJosHekKaVpU=;
        b=UTfBEiGonmaKO5W4JCg+4oatnViLNQxALrZ+ixJOCCTl3Rh5Ld3WlWwgUVIhOHVRNN
         Z1WTXUaKXTAEYxHR/m4VNbyJIhkrZVOun/vZQxHUo0p9TvCsLEL3vQK9NkKn0TB2wDKd
         Ma89z5mv44UwT9dSbjZRK0e+NxCIA4fXOl5hdFgsHUfpXkRblVeWrdk3b98lZupEoK6a
         2rv09oVFhV3BIEHuDXePxjgTQ4vjIWZf5ftINyPEa2G6cEOpVR2i3E62tFP/Zing/wtZ
         hZXMAIwMDK5nlI64p8G+Lc91jxup5pFY5CJSor9R+7ey/iMCTBSnoPubUpERdaYlbS30
         De3A==
X-Gm-Message-State: AOJu0Yz7oIkaBo9GgemHUJffRUGPHfCa2OuGeMPO9JH5yVpsbOhCqicT
	pCEiHPlWQjm9OiGWexKLeGQs1eizHqQvs6k6DHCW7RacQo4q340pCQiT12BenEEBU5jGbI1pwI0
	SuIy6Y8rDrNsP7tQGXQ==
X-Received: from edgi19-n1.prod.google.com ([2002:a05:6402:a593:10b0:697:53cb:736d])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:4312:b0:697:80bb:c28d with SMTP id 4fb4d7f45d1cf-697dbad2379mr69495a12.6.1782169060935;
 Mon, 22 Jun 2026 15:57:40 -0700 (PDT)
Date: Mon, 22 Jun 2026 22:57:36 +0000
In-Reply-To: <20260622225736.2961438-1-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260622225736.2961438-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.rc0.786.g65d90a0328-goog
Message-ID: <20260622225736.2961438-3-tarunsahu@google.com>
Subject: [PATCH v4 2/2] luo: Update serialized data to use KHOSER_PTR
From: Tarun Sahu <tarunsahu@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: rdjjramt51o7fsyf9pt1g1w13udyou4n
X-Rspamd-Queue-Id: AB85F20003
X-Rspamd-Server: rspam06
X-HE-Tag: 1782169062-187125
X-HE-Meta: U2FsdGVkX1/v56XBU8QD+QNLPz+w8WpgWOBO3zmI7Irb6yfWwFoZ55ECZUut0PqG5Bq+npNjoXAikIVXawaAVNKE5wZCjyeDo9VvXv8i9AlL6AKdelYAVixz99MkCrHDYwoQk8KCnRiJy7FAyZZaPziT1gLE3daHIHcskIPTl96EewmoNyhqn5OBIDoLob2tUuZygdG5oU7St82Ysod+WwLN/b3faI6ZgzLshWDvBG5I1bGHEIoNRRHMfTmYRB2Ge6zpsES870uCTrNK5PgChCeX3xkwLj4e02xvU+Q284sU/JXUqt68oskGbOu3rqndOka0ZMLUWnoq8bgvR1+SGmps9gWFPHiGESMZQs4KmJGsr9bgfzFb0/ZpU6krWAORBl0jBttSXFIOrWWb4Rx1F4pfKOcXNoRRI2BDViiwHCfkA2JO7aBGVADIYo+fONlwv24/DzuJ7Z20NGkKZ9PpslSP3SCpoOZOYEHZMbjcfZlsj1tMAwEKSwg4/mwIlfDdKjr7yeUZzbgQFQ6jMUAHvezcJJ+kS0AX3GkFu8O2wNgVlOEknNwQIWcjtjPs9ZLt8DdOQ0GWSFeH2Jdi0S9EV4k++nZ7sDq/7mKdP4GugYMAX6Rfjt0ccsCRm4HzgmsWW9fawCHnerj9ZUeSO1xR0z/B9y734qxmXH5Lu33j2MsnmOG53wMlRXkp0Or2Jagf31PjIsOM3jcxWZFB3FiYJuj7M+0NrBTPZf7Jcf8Un4uxb++O2gMlPxbELxtmejFIgLO8Zb4liQSAUyHBGoHrzkbYrQ3wgzxwqZWhiGZGK/bIc2XXzZNr6IGbzgCIDHQorR/4srym2P+vzjQTcv3VmWUOOX8Yq8hI4OYKgU95Ws2XwLaqtXLy9n3Cxa0NCSxI8iTwIwrQvyAi6iYYvrQRfLJMjMtErh4A97ekRv9Zt8KQWccH3zNDG+boG2LKHXNd0fEqvCCxac8TlcDpyVH
 tBz9V+Gb
 i5TQAVMhMZviFzZh3MGMN4yl3iSQ7jATS1U1RdqErnST49rQme19EiPes7v+hfrQ+Rxk+1V1MQt9j6PxSQl8K7qxPnF0XpCPaU/rsSDiDq/Vuno/zwCaWzoLvJvLtmC9Rd9qZ9tPVyBX6ry63V/fkFnbcQd3y9J8AGKhWZSD7i7GijuPUf1CxoEFS1HuPFvUr4pk68I5+Ek0w51zFMq4gTtsOqbKp9xP+DiexbvxhsQS8xNcSzGD+97mt0ThVvSAhe8R5H15urvlVGF5sH/we2Qcy9HzgrmsUSrhkQ0j8ub1HcffGpQSeqiLRI16KohC2B8pk3L+5TQ2UVk+cEOInuza68cJAnTTfDgH6WVQIgBJjgY6ooOVpwXMRVExXZsCU1tdlp3On/BzRK19Nwl08sVET2K2WznjxiOhRZCljXW17O8P0nIpybv2BdKXlfl578BIoF9oUpd1JszslLZBEFlmh+bzN7kYF2e8Yji3jNzajinEvnDdDP4LhMypjQ7T46DIyWq1sgHx4J5gLVrZ0KBN906ZxNzhJWErqyvRGYlLHfADyY8cVnsRYU8xZyOMh6G9xp6qK7h/MF6kWSN2ibXt14zP5OPT+mPKl2B9HLf0ELDM=
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
index 59de210bee5f..0bb6b882a155 100644
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
2.55.0.rc0.786.g65d90a0328-goog


