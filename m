Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA2A6D1951B
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 23:03:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED28C6B0092; Mon, 26 Jan 2026 18:03:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E52876B008C; Mon, 26 Jan 2026 18:03:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D13976B0092; Mon, 26 Jan 2026 18:03:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C1F366B008A
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 18:03:20 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 88E75BBFD9
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 23:03:20 +0000 (UTC)
X-FDA: 84375642960.19.1A84515
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id D2E66A0016
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 23:03:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KfjKV6Tw;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769468599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KILleqMqR7YEI0QmJcScarkcVA1DeIi7Ekw1JqlPjiw=;
	b=pHV99wD+HZnU6dN1oGli5f6LH72MH8UtWUHZFg556r7NlTLhh8SfQD4B08566Ws3qu0ZLh
	MwXwrhLT/A9BnJOnP7Ksfo55i7I+HqgX4dCg/ZsQVtxYxJcEvZiTrpjorpVwQRm9BHg5dz
	Rs2N3C+3YHC3lrMLvqTVVfd+qq18NzY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KfjKV6Tw;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769468599; a=rsa-sha256;
	cv=none;
	b=65gLPQu4CEG6gKBC7zW5XC57Q+BehoH53khKoRqshJ2V+yVMzhpy2on/hqm3wpCam9KTfU
	ZQONqd492+ukF81KFRy628ofmrNmDwUi5+RG+7mAECNjfWJeM5M7HakoX54jgc1r/F8wso
	371AU7mlj6gguwJcFGE0W83DEfAtydc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E6874444B0;
	Mon, 26 Jan 2026 23:03:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC43C116C6;
	Mon, 26 Jan 2026 23:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769468597;
	bh=90DvFCi3zMuXdUi5plIxqndw6Xsg6xyFIhBnu4feXwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KfjKV6Twh01q8uGSY9sQx98QO+lL29jXatucMnVHcz80uw7Lq4btEHGodgOivS6Li
	 P1n90vvA2MwJLRbyslE/KZMGsqzUVGuT7xMPuXb7R8c95UcIR1sAotbgaICiT1QuvF
	 eVyKuszZLSN+gnaw+O1tNwH9jFLoXiv4YezklZLEbGHmrsgh7N7Xq1V+TT7km2dtk3
	 ybAyrLSHmtOwstf8g4ao143cEiMWL4GN9dyyKQ7Xdd6+IKtmPnwjfMVX0wA63iioBx
	 wWFIQQycJNDEzLQctgmyJDe5/aSlB4Ue8j+YKLIua24jo4tBMzth1+dJB6S/T5dnCa
	 Cx0ZTfqsYLrMQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/2] liveupdate: luo_file: remember retrieve() status
Date: Tue, 27 Jan 2026 00:02:53 +0100
Message-ID: <20260126230302.2936817-3-pratyush@kernel.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
In-Reply-To: <20260126230302.2936817-1-pratyush@kernel.org>
References: <20260126230302.2936817-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D2E66A0016
X-Stat-Signature: 1m3x49qxcxj43jk7aponu4o6ok4bs567
X-Rspam-User: 
X-HE-Tag: 1769468598-155589
X-HE-Meta: U2FsdGVkX1+ysNmv6Qigmwyc3W1V8bbQ21AUaKcUxXIOXsuzniATRgskrED+0fYPmm7GrysbX3rUlLX9SM1aeRE0wAUG7ViQeYiLjJM03sBEknB3QKA3eQaMdY4Y/yCs9DISFy4lA0GzVr2tbwANd9EHqIcj8u7IpPcVtouzEUzt+1+r2gX1DKsg4tSJxVNaJqyaBoKmFvartPgDGnk6t7/ahpt8RcjoDhhkXcSsb/dXJQfTqQWvQoNzmtWoVTxyS1gIi7Qn7oB7of4BFl2+M41O3sGSqdwaGuE61Bq5c0W5bCxqp8iW6hJhe11jPB/jm9CQFsbiIMOhN56N7z7IyQZD9XE40qo1ewR5CM1hHF8PIXWF2dJBJ4dJtTGLaJShID0nES8XLf1liHDY7/T0p/lgyu3Bwb9e7Xfb4DFWeFjL9tV6L6W+25laBS0vYTJgprJFbrs+doQa+LMtZHIRo9CU7tgXCU70LoJi7mv5JzAVn4xzrZJ+EcF5OZ4OZYWC2Wk13hTL7UGmjDfhftAZ2oR2rYS0BAbyZk6qIrFE5Fczz2IKog1wZOQvacEToZ7sn+F/qobFHIqY7uXaDqzA+u/IzVOFR4uyMti1PJXgRSn0G9v23UIdUr64J191soFVF/eQ3/Zyhe034ubr9rJJuHFuHhAbvIlmmD+nGOmtN8EXDr0Tw5sAIpOQvi3o+cmgDXaXEzEklm7tKkm2c0qKKoo92VvH8gXjXk6LAH4kY1o5/VxB0pFDeX72+h/3uhTD1Ypa9vQYVibVC+8rCUCK/7REOGscr995ERCKJDpSnHVZjg/HPkWvpEiJIdDPeABd1mDbF3uYoR0cnHHTLl8+PVK8aeZSDTlsqO9g/LtrX3RyZXvv7+0kIX8v3yv09TP70IbiCiEo1A4Vq5Iks7Ko5stl4JTclOn+VjAl8Qs71XOX20xXF3XnnOTRjsQLuXDeAidsqLvaUYeUm95QGS5
 8YHumiOx
 1eT6Kh6/3GkWLiRp89dji2VLgc2LYkj16ffAQgeiICoQ5yeOi+czpTBJDs1/AnRVzBWvPbrbLvWwLlylv1kNE3wVK1jRVZvviDM5BWzE0e7kWgUfLCeHczbS4bbKlmZbnE3y8NKf/RdU2a6qcc182lijNMBvRM+XiuyRjVF5xlRROodk5usi6SynuJI7gP3jtCgGn3HwFnXQEYL11FvIWfYmYhRDjFvPsdTmv3B7wCTkYAIkdgWN2hpPpDA/VKhSX5gUYP2uqlqNyju+2Kww6aNNW0A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

LUO keeps track of successful retrieve attempts on a LUO file. It does
so to avoid multiple retrievals of the same file. Doing so will cause
problems because once the file is retrieved, the serialized data
structures are likely freed and the file is likely in a very different
state from what the code expects.

This is kept track of by the retrieved boolean in struct luo_file, and
is passed to the finish callback so it knows what work was already done
and what it has left to do.

All this works well when retrieve succeeds. When it fails,
luo_retrieve_file() returns the error immediately, without ever storing
anywhere that a retrieve was attempted or what its error code was. This
results in an errored LIVEUPDATE_SESSION_RETRIEVE_FD ioctl to userspace,
but nothing prevents it from trying this again.

The retry is problematic for much of the same reasons listed above. The
file is likely in a very different state than what the retrieve logic
normally expects, and it might even have freed some serialization data
structures. Attempting to access them or free them again is going to
break things.

For example, if memfd managed to restore 8 of its 10 folios, but fails
on the 9th, a subsequent retrieve attempt will try to call
kho_restore_folio() on the first folio again, and that will fail with a
warning since it is an invalid operation.

Apart from the retry, finish() also breaks. Since on failure the
retrieved bool in luo_file is never touched, the finish() call on
session close will tell the file handler that retrieve was never
attempted, and it will try to access or free the data structures that
might not exist, much in the same way as the retry attempt.

There is no sane way of attempting the retrieve again. Remember the
error retrieve returned and directly return it on a retry. Also pass
this status code to finish() so it can make the right decision on the
work it needs to do.

This is done by changing the bool to an integer. A value of 0 means
retrieve was never attempted, a positive value means it succeeded, and a
negative value means it failed and the error code is the value.

Fixes: 7c722a7f44e0 ("liveupdate: luo_file: implement file systems callbacks")
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/liveupdate.h   |  7 ++++--
 kernel/liveupdate/luo_file.c | 41 ++++++++++++++++++++++--------------
 mm/memfd_luo.c               |  7 +++++-
 3 files changed, 36 insertions(+), 19 deletions(-)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index a7f6ee5b6771..a543a3a8e837 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -21,7 +21,10 @@ struct file;
  * struct liveupdate_file_op_args - Arguments for file operation callbacks.
  * @handler:          The file handler being called.
  * @retrieved:        The retrieve status for the 'can_finish / finish'
- *                    operation.
+ *                    operation. A value of 0 means the retrieve has not been
+ *                    attempted, a positive value means the retrieve was
+ *                    successful, and a negative value means the retrieve failed,
+ *                    and the value is the error code of the call.
  * @file:             The file object. For retrieve: [OUT] The callback sets
  *                    this to the new file. For other ops: [IN] The caller sets
  *                    this to the file being operated on.
@@ -37,7 +40,7 @@ struct file;
  */
 struct liveupdate_file_op_args {
 	struct liveupdate_file_handler *handler;
-	bool retrieved;
+	bool retrieve_sts;
 	struct file *file;
 	u64 serialized_data;
 	void *private_data;
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 9f7283379ebc..82577b4cca2b 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -133,9 +133,12 @@ static LIST_HEAD(luo_file_handler_list);
  *                 state that is not preserved. Set by the handler's .preserve()
  *                 callback, and must be freed in the handler's .unpreserve()
  *                 callback.
- * @retrieved:     A flag indicating whether a user/kernel in the new kernel has
+ * @retrieve_sts:  Status code indicating whether a user/kernel in the new kernel has
  *                 successfully called retrieve() on this file. This prevents
- *                 multiple retrieval attempts.
+ *                 multiple retrieval attempts. A value of 0 means a retrieve()
+ *                 has not been attempted, a positive value means the retrieve()
+ *                 was successful, and a negative value means the retrieve()
+ *                 failed, and the value is the error code of the call.
  * @mutex:         A mutex that protects the fields of this specific instance
  *                 (e.g., @retrieved, @file), ensuring that operations like
  *                 retrieving or finishing a file are atomic.
@@ -160,7 +163,7 @@ struct luo_file {
 	struct file *file;
 	u64 serialized_data;
 	void *private_data;
-	bool retrieved;
+	int retrieve_sts;
 	struct mutex mutex;
 	struct list_head list;
 	u64 token;
@@ -293,7 +296,7 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	luo_file->file = file;
 	luo_file->fh = fh;
 	luo_file->token = token;
-	luo_file->retrieved = false;
+	luo_file->retrieve_sts = 0;
 	mutex_init(&luo_file->mutex);
 
 	args.handler = fh;
@@ -569,7 +572,7 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 		return -ENOENT;
 
 	guard(mutex)(&luo_file->mutex);
-	if (luo_file->retrieved) {
+	if (luo_file->retrieve_sts > 0) {
 		/*
 		 * Someone is asking for this file again, so get a reference
 		 * for them.
@@ -577,21 +580,27 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 		get_file(luo_file->file);
 		*filep = luo_file->file;
 		return 0;
+	} else if (luo_file->retrieve_sts < 0) {
+		/* Retrieve was attempted and it failed. Return the error code. */
+		return luo_file->retrieve_sts;
 	}
 
 	args.handler = luo_file->fh;
 	args.serialized_data = luo_file->serialized_data;
 	err = luo_file->fh->ops->retrieve(&args);
-	if (!err) {
-		luo_file->file = args.file;
-
-		/* Get reference so we can keep this file in LUO until finish */
-		get_file(luo_file->file);
-		*filep = luo_file->file;
-		luo_file->retrieved = true;
+	if (err) {
+		/* Keep the error code for later use. */
+		luo_file->retrieve_sts = err;
+		return err;
 	}
 
-	return err;
+	luo_file->file = args.file;
+	/* Get reference so we can keep this file in LUO until finish */
+	get_file(luo_file->file);
+	*filep = luo_file->file;
+	luo_file->retrieve_sts = 1;
+
+	return 0;
 }
 
 static int luo_file_can_finish_one(struct luo_file_set *file_set,
@@ -607,7 +616,7 @@ static int luo_file_can_finish_one(struct luo_file_set *file_set,
 		args.handler = luo_file->fh;
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
-		args.retrieved = luo_file->retrieved;
+		args.retrieve_sts = luo_file->retrieve_sts;
 		can_finish = luo_file->fh->ops->can_finish(&args);
 	}
 
@@ -624,7 +633,7 @@ static void luo_file_finish_one(struct luo_file_set *file_set,
 	args.handler = luo_file->fh;
 	args.file = luo_file->file;
 	args.serialized_data = luo_file->serialized_data;
-	args.retrieved = luo_file->retrieved;
+	args.retrieve_sts = luo_file->retrieve_sts;
 
 	luo_file->fh->ops->finish(&args);
 }
@@ -779,7 +788,7 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 		luo_file->file = NULL;
 		luo_file->serialized_data = file_ser[i].data;
 		luo_file->token = file_ser[i].token;
-		luo_file->retrieved = false;
+		luo_file->retrieve_sts = 0;
 		mutex_init(&luo_file->mutex);
 		list_add_tail(&luo_file->list, &file_set->files_list);
 	}
diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index a34fccc23b6a..ffc9f879833b 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -326,7 +326,12 @@ static void memfd_luo_finish(struct liveupdate_file_op_args *args)
 	struct memfd_luo_folio_ser *folios_ser;
 	struct memfd_luo_ser *ser;
 
-	if (args->retrieved)
+	/*
+	 * If retrieve was successful, nothing to do. If it failed, retrieve()
+	 * already cleaned up everything it could. So nothing to do there
+	 * either. Only need to clean up when retrieve was not called.
+	 */
+	if (args->retrieve_sts)
 		return;
 
 	ser = phys_to_virt(args->serialized_data);
-- 
2.52.0.457.g6b5491de43-goog


