Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B8B91094478
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 14:41:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2CAE6B00BF; Sat, 21 Mar 2026 10:41:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDE676B00C1; Sat, 21 Mar 2026 10:41:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1B166B00C2; Sat, 21 Mar 2026 10:41:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A243B6B00BF
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 10:41:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 41C76B9B73
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:41:27 +0000 (UTC)
X-FDA: 84570333414.20.D81A49B
Received: from hillsboro-edge.smtp.mymangomail.com (hillsboro-edge.smtp.mymangomail.com [5.78.130.219])
	by imf28.hostedemail.com (Postfix) with ESMTP id 18CE7C000C
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:41:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gerlicz.space header.s=mango-1 header.b=jSGI9QEH;
	spf=pass (imf28.hostedemail.com: domain of oskar@gerlicz.space designates 5.78.130.219 as permitted sender) smtp.mailfrom=oskar@gerlicz.space;
	dmarc=pass (policy=quarantine) header.from=gerlicz.space
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774104085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WnfwNOCz2xGiyg8OXyoF1gapwg8Az9cm20wVsA2MxxQ=;
	b=bNmUfUEwqXO9WOIn+D0NM6I8oB3mq5X8S8qxhnSv834AerKQ1hrdtVzHhtSqWsFA36nmZ3
	OfKizkydkhiVkqfb93/hjUy4upnd+RF2RFerrW+ixvkY3Rpim66txIa9O1GFgSBIZNRtPY
	0aBjJcEF9tMO2b1aDIfflvSN+MLWArc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gerlicz.space header.s=mango-1 header.b=jSGI9QEH;
	spf=pass (imf28.hostedemail.com: domain of oskar@gerlicz.space designates 5.78.130.219 as permitted sender) smtp.mailfrom=oskar@gerlicz.space;
	dmarc=pass (policy=quarantine) header.from=gerlicz.space
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774104085; a=rsa-sha256;
	cv=none;
	b=p3hmhwCYoPu13Fc+pa2XLrkOtBKSKBQsNoYEtkjVZQjFmEDPoOp55AsuOIJoYMXpQbHAc7
	RDxfsi283di0TsoS9npC4YkpR/wA5oIEqHkhaTT5AYUxLTPuHnWqV2AfLOgcI7tk5LS3As
	Sh+J7yuCxjuecyb2pTa9CJ6ObxqMX0Q=
Received: from smtp.mymangomail.com (localhost [127.0.0.1])
	by smtp.mymangomail.com (Mango Mail) with ESMTP id 163664162F;
	Sat, 21 Mar 2026 10:40:53 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gerlicz.space;
	s=mango-1; t=1774104053;
	bh=hQW88e3e2eG32gSgZk8S8tu/3o5jt6LYekAYe9l4YJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jSGI9QEHFG39qTc6r35LIgv31M/sfbMoYXB719FkKiHNjHEifwcRqGe0J/Fa9S8gZ
	 ENgB24HxlouDQOitRh89jJ7tB7s1gwA1BZY4iRbSj3ji3U8lU0DnoPSRnF/kkzyqNk
	 OAj1YLBUyziHtkHM2Vu22T46YlqaeWJBwOCpIdqk=
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
Received: from authenticated-user (smtp.mymangomail.com [205.185.121.143])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits)
 server-digest SHA256)
	(No client certificate requested)
	by smtp.mymangomail.com (Mango Mail) with ESMTPSA id CC86641627;
	Sat, 21 Mar 2026 10:39:39 -0400 (EDT)
From: Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Baoquan He <bhe@redhat.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
Subject: [PATCH v3 3/5] liveupdate: fail session restore on file
 deserialization errors
Date: Sat, 21 Mar 2026 15:36:40 +0100
Message-ID: <20260321143642.166313-3-oskar@gerlicz.space>
In-Reply-To: <20260321143642.166313-2-oskar@gerlicz.space>
References: <20260321143642.166313-1-oskar@gerlicz.space>
 <20260321143642.166313-2-oskar@gerlicz.space>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 18CE7C000C
X-Stat-Signature: d5ta8wqfaq5g4nbdj79worhu6wcqx8k8
X-Rspam-User: 
X-HE-Tag: 1774104084-106144
X-HE-Meta: U2FsdGVkX19ZH70OtYlSqS+D28hvWAOf3MPR+QMAxvsXnDEcl+15sqV7P5tcD4llxA2QTv5tjaWqZAE7USDrwNtOFyUOoaYE6WCVqREeeqAh8LFmL0r1JHPOqSqjI35FBDlkMI8nVEiuFYSHy+7knSYT1fJdd0SdtufCxMKcnB1Z7MU7q5uOSu7FJshukCUm8tIWvo1xFMZ+epHpdvjV9Hy1d4UvVu0FaWbE7NC/lnM0Byx360F5OQjMYzCjbJFlLQJkepNqGR5azkeF/e4wteYlfkuhfQieCTGu4yqbZHNRG7gNFcaGqEpPd2ftgghGoS4Y6IhgZwRte9udaEGWS49Yg0SwGVYsTs3PTYP0e5xogXm9ciLaX6xQGbNd9nPCcSP21blFPgs3ZBka0Q8rpRbuImcTfb/2eP08b8za2hPruWAT0PluaoWceXEQDpVrbMBOyjfdlAU6WOOZYPhkFbSfnYTzbDuxoxfAbjHeVQpMFCT8w++VDSWT2YWaZZn2w9zwirBH6IqnTCFmJ3SpksZPbhXdnZ00icGwArHsr7ZnnVy2UYUbg1LddahQYtb164kw7neHeMiHu4IL8Vs0hfL5EFcEHbbTq0jeJh83XtiX8KO/AqI/GcMjZang5WE+z5V8RQQzliKUGunon3J42KkPeZs41eJRs7WVu2fNhXCmfv0qKGehlnvgO8VFlt67dLeZUt7ty7VcFiO7vntybe1rIyLAWwNJifaWge41v49Ce0NyxKAQ3Rti07djiDFmqHpJHyhi/xJWKjMSmyx/X8SfvVbEtaySSfIiovqf3Ahw9xx0rx7vQavfs8DOGFSmDTVLymPxS8tQYhPEWNOp4FwupkWcgOPojLXI6fHMhmQVPEMOdDDHUWkQy9jAxni3JNajVvbQmDCu1yc6Xk5unaBwfbXF0sqyDHnWiiZboxrjwlCfOKX4Se3DVPyyV9Q0KhRXxnUJSaG7aH/Wn/g
 9aI/jJyn
 u7aBD1NcWdfcG7NAt1Ilp4qVDQQXEwzAIxjRtjhMpWG8q3bzymGaPfuZjOLLuUfFWnF0c+yCsJzBtd23asv6OJIGTRXMnwL88IwdD+uIPonBNMTbciLNluN8KvO33l4V0Oz2B98jqNpaoORdW7yFiRPWgtRdKDS8vfgKIGHHSqXgdS3T4Vfyfu/YxtsFTePOstg41lyzdO5nYGBBtgmUnECZ/FmkVLVaqeMY385dvYJxSwdUhnhfDtxSYxPjD9XzaYtzJewAWPOQdI5H0Lzq7qhBr8VbUJvpnDMEhnsMCaelr2OkORbqOapn5YKet0FoQx/Rlqz9cU3ZhDkxho7ijljHtbIVB6YwQPUekWPUm/VjKuH9LEwobfXPRxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Session restore can fail after inserting a partially constructed session
into the incoming list. The v2 cleanup also reused finish-style teardown
for that rollback path even though finish is the normal completion path
for a fully restored session.

That can leave stale incoming sessions behind after a deserialize error
and can run completion callbacks against state that was never fully
rebuilt.

Require an explicit abort callback for file handlers, use it to unwind
partially restored files, and route every deserialize failure through a
single cleanup path that drops restored sessions, frees serialized file
metadata and records the cached error code.

Fixes: 077fc48b59fc ("liveupdate: fail session restore on file deserialization errors")
Signed-off-by: Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
---
 include/linux/liveupdate.h       |  3 ++
 kernel/liveupdate/luo_file.c     | 67 +++++++++++++++++++++++---------
 kernel/liveupdate/luo_internal.h |  1 +
 kernel/liveupdate/luo_session.c  | 42 +++++++++-----------
 mm/memfd_luo.c                   | 24 +++++++-----
 5 files changed, 86 insertions(+), 51 deletions(-)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index d93b043a0421..611907f57127 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -63,6 +63,8 @@ struct liveupdate_file_op_args {
  *                finish, in order to do successful finish calls for all
  *                resources in the session.
  * @finish:       Required. Final cleanup in the new kernel.
+ * @abort:        Required. Discard preserved state in the new kernel without
+ *                completing finish().
  * @owner:        Module reference
  *
  * All operations (except can_preserve) receive a pointer to a
@@ -78,6 +80,7 @@ struct liveupdate_file_ops {
 	int (*retrieve)(struct liveupdate_file_op_args *args);
 	bool (*can_finish)(struct liveupdate_file_op_args *args);
 	void (*finish)(struct liveupdate_file_op_args *args);
+	void (*abort)(struct liveupdate_file_op_args *args);
 	struct module *owner;
 };
 
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 5acee4174bf0..939ef8d762ce 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -648,6 +648,20 @@ static void luo_file_finish_one(struct luo_file_set *file_set,
 	luo_flb_file_finish(luo_file->fh);
 }
 
+static void luo_file_abort_one(struct luo_file *luo_file)
+{
+	struct liveupdate_file_op_args args = {0};
+
+	guard(mutex)(&luo_file->mutex);
+
+	args.handler = luo_file->fh;
+	args.file = luo_file->file;
+	args.serialized_data = luo_file->serialized_data;
+	args.retrieve_status = luo_file->retrieve_status;
+
+	luo_file->fh->ops->abort(&args);
+}
+
 /**
  * luo_file_finish - Completes the lifecycle for all files in a file_set.
  * @file_set: The file_set to be finalized.
@@ -717,6 +731,28 @@ int luo_file_finish(struct luo_file_set *file_set)
 	return 0;
 }
 
+void luo_file_abort_deserialized(struct luo_file_set *file_set)
+{
+	struct luo_file *luo_file;
+
+	while (!list_empty(&file_set->files_list)) {
+		luo_file = list_last_entry(&file_set->files_list,
+					   struct luo_file, list);
+		luo_file_abort_one(luo_file);
+		if (luo_file->file)
+			fput(luo_file->file);
+		list_del(&luo_file->list);
+		file_set->count--;
+		mutex_destroy(&luo_file->mutex);
+		kfree(luo_file);
+	}
+
+	file_set->count = 0;
+	if (file_set->files)
+		kho_restore_free(file_set->files);
+	file_set->files = NULL;
+}
+
 /**
  * luo_file_deserialize - Reconstructs the list of preserved files in the new kernel.
  * @file_set:     The incoming file_set to fill with deserialized data.
@@ -747,6 +783,7 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 {
 	struct luo_file_ser *file_ser;
 	u64 i;
+	int err;
 
 	if (!file_set_ser->files) {
 		WARN_ON(file_set_ser->count);
@@ -756,21 +793,6 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 	file_set->count = file_set_ser->count;
 	file_set->files = phys_to_virt(file_set_ser->files);
 
-	/*
-	 * Note on error handling:
-	 *
-	 * If deserialization fails (e.g., allocation failure or corrupt data),
-	 * we intentionally skip cleanup of files that were already restored.
-	 *
-	 * A partial failure leaves the preserved state inconsistent.
-	 * Implementing a safe "undo" to unwind complex dependencies (sessions,
-	 * files, hardware state) is error-prone and provides little value, as
-	 * the system is effectively in a broken state.
-	 *
-	 * We treat these resources as leaked. The expected recovery path is for
-	 * userspace to detect the failure and trigger a reboot, which will
-	 * reliably reset devices and reclaim memory.
-	 */
 	file_ser = file_set->files;
 	for (i = 0; i < file_set->count; i++) {
 		struct liveupdate_file_handler *fh;
@@ -787,12 +809,15 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 		if (!handler_found) {
 			pr_warn("No registered handler for compatible '%s'\n",
 				file_ser[i].compatible);
-			return -ENOENT;
+			err = -ENOENT;
+			goto err_discard;
 		}
 
 		luo_file = kzalloc_obj(*luo_file);
-		if (!luo_file)
-			return -ENOMEM;
+		if (!luo_file) {
+			err = -ENOMEM;
+			goto err_discard;
+		}
 
 		luo_file->fh = fh;
 		luo_file->file = NULL;
@@ -803,6 +828,10 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 	}
 
 	return 0;
+
+err_discard:
+	luo_file_abort_deserialized(file_set);
+	return err;
 }
 
 void luo_file_set_init(struct luo_file_set *file_set)
@@ -838,7 +867,7 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
 
 	/* Sanity check that all required callbacks are set */
 	if (!fh->ops->preserve || !fh->ops->unpreserve || !fh->ops->retrieve ||
-	    !fh->ops->finish || !fh->ops->can_preserve) {
+	    !fh->ops->finish || !fh->ops->abort || !fh->ops->can_preserve) {
 		return -EINVAL;
 	}
 
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 8a6b1f6c9b4f..4842c7dbeb63 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -102,6 +102,7 @@ void luo_file_unfreeze(struct luo_file_set *file_set,
 int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 		      struct file **filep);
 int luo_file_finish(struct luo_file_set *file_set);
+void luo_file_abort_deserialized(struct luo_file_set *file_set);
 int luo_file_deserialize(struct luo_file_set *file_set,
 			 struct luo_file_set_ser *file_set_ser);
 void luo_file_set_init(struct luo_file_set *file_set);
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 200dd3b8229c..602001327f58 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -693,24 +693,10 @@ int luo_session_deserialize(void)
 		return err;
 
 	is_deserialized = true;
+	err = 0;
 	if (!sh->active)
-		return 0;
+		return err;
 
-	/*
-	 * Note on error handling:
-	 *
-	 * If deserialization fails (e.g., allocation failure or corrupt data),
-	 * we intentionally skip cleanup of sessions that were already restored.
-	 *
-	 * A partial failure leaves the preserved state inconsistent.
-	 * Implementing a safe "undo" to unwind complex dependencies (sessions,
-	 * files, hardware state) is error-prone and provides little value, as
-	 * the system is effectively in a broken state.
-	 *
-	 * We treat these resources as leaked. The expected recovery path is for
-	 * userspace to detect the failure and trigger a reboot, which will
-	 * reliably reset devices and reclaim memory.
-	 */
 	for (int i = 0; i < sh->header_ser->count; i++) {
 		struct luo_session *session;
 
@@ -718,7 +704,8 @@ int luo_session_deserialize(void)
 		if (IS_ERR(session)) {
 			pr_warn("Failed to allocate session [%s] during deserialization %pe\n",
 				sh->ser[i].name, session);
-			return PTR_ERR(session);
+			err = PTR_ERR(session);
+			goto out_discard;
 		}
 		session->state = LUO_SESSION_INCOMING;
 
@@ -726,21 +713,30 @@ int luo_session_deserialize(void)
 		if (err) {
 			pr_warn("Failed to insert session [%s] %pe\n",
 				session->name, ERR_PTR(err));
-			luo_session_free(session);
-			return err;
+			luo_session_put(session);
+			goto out_discard;
 		}
 
-		scoped_guard(mutex, &session->mutex) {
-			luo_file_deserialize(&session->file_set,
-					     &sh->ser[i].file_set_ser);
+		scoped_guard(mutex, &session->mutex)
+			err = luo_file_deserialize(&session->file_set,
+						   &sh->ser[i].file_set_ser);
+		if (err) {
+			pr_warn("Failed to deserialize session [%s] files %pe\n",
+				session->name, ERR_PTR(err));
+			goto out_discard;
 		}
 	}
 
+out_free_header:
 	kho_restore_free(sh->header_ser);
 	sh->header_ser = NULL;
 	sh->ser = NULL;
 
-	return 0;
+	return err;
+
+out_discard:
+	luo_session_discard_deserialized(sh);
+	goto out_free_header;
 }
 
 int luo_session_serialize(void)
diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index b8edb9f981d7..8a453c8bfdf5 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -358,19 +358,11 @@ static void memfd_luo_discard_folios(const struct memfd_luo_folio_ser *folios_se
 	}
 }
 
-static void memfd_luo_finish(struct liveupdate_file_op_args *args)
+static void memfd_luo_abort(struct liveupdate_file_op_args *args)
 {
 	struct memfd_luo_folio_ser *folios_ser;
 	struct memfd_luo_ser *ser;
 
-	/*
-	 * If retrieve was successful, nothing to do. If it failed, retrieve()
-	 * already cleaned up everything it could. So nothing to do there
-	 * either. Only need to clean up when retrieve was not called.
-	 */
-	if (args->retrieve_status)
-		return;
-
 	ser = phys_to_virt(args->serialized_data);
 	if (!ser)
 		return;
@@ -388,6 +380,19 @@ static void memfd_luo_finish(struct liveupdate_file_op_args *args)
 	kho_restore_free(ser);
 }
 
+static void memfd_luo_finish(struct liveupdate_file_op_args *args)
+{
+	/*
+	 * If retrieve was successful, nothing to do. If it failed, retrieve()
+	 * already cleaned up everything it could. So nothing to do there
+	 * either. Only need to clean up when retrieve was not called.
+	 */
+	if (args->retrieve_status)
+		return;
+
+	memfd_luo_abort(args);
+}
+
 static int memfd_luo_retrieve_folios(struct file *file,
 				     struct memfd_luo_folio_ser *folios_ser,
 				     u64 nr_folios)
@@ -532,6 +537,7 @@ static bool memfd_luo_can_preserve(struct liveupdate_file_handler *handler,
 static const struct liveupdate_file_ops memfd_luo_file_ops = {
 	.freeze = memfd_luo_freeze,
 	.finish = memfd_luo_finish,
+	.abort = memfd_luo_abort,
 	.retrieve = memfd_luo_retrieve,
 	.preserve = memfd_luo_preserve,
 	.unpreserve = memfd_luo_unpreserve,
-- 
2.53.0


