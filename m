Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 060E7FEC11B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 21:42:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 443996B0005; Tue, 24 Mar 2026 17:42:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F42E6B0088; Tue, 24 Mar 2026 17:42:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 309F46B008A; Tue, 24 Mar 2026 17:42:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E7436B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 17:42:10 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B74E71604D9
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 21:42:09 +0000 (UTC)
X-FDA: 84582279978.19.FA35DA2
Received: from las-vegas.smtp.mymangomail.com (las-vegas.smtp.mymangomail.com [205.185.121.143])
	by imf08.hostedemail.com (Postfix) with ESMTP id 86342160008
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 21:42:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gerlicz.space header.s=mango-1 header.b=tzEXMRpI;
	spf=pass (imf08.hostedemail.com: domain of oskar@gerlicz.space designates 205.185.121.143 as permitted sender) smtp.mailfrom=oskar@gerlicz.space;
	dmarc=pass (policy=quarantine) header.from=gerlicz.space
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774388527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RTMaIrRqLu8L0FhRDqEWgLI0rZ0DegpkXW5wh7DrQrQ=;
	b=O83rYtzofMrBQYZlufspZuTAdCjLVoZU2Ax75o1BezXGjRnRiS5f4IjvIqfSlPCO6Um4cJ
	oW0z1acM6HW4WGh8AK1BVCIISKnO/QdtvFMfYgDMUjD5Koi7swxYjmp6Cmg+HkPmMiJwmN
	4ltC2ZzZj+wLRvGmRULv9GV58ThqGLQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774388527; a=rsa-sha256;
	cv=none;
	b=RyHs0WGCxTX2+gAYpEqbtRAaUEwA2/KnvdBXC71tkMcWzLpC/cujlniIFbmgFwe3MfI8Em
	Cy/HmSoCtHaB+07qYmOpE9Qksx8RFL73XQY9tJoz1ydJxAnDGjKcWVxrYh5WKd1Ux6JOgj
	0Zt81HvGjjlHxoUuNZMGgwCFJwhZLDQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gerlicz.space header.s=mango-1 header.b=tzEXMRpI;
	spf=pass (imf08.hostedemail.com: domain of oskar@gerlicz.space designates 205.185.121.143 as permitted sender) smtp.mailfrom=oskar@gerlicz.space;
	dmarc=pass (policy=quarantine) header.from=gerlicz.space
Received: from [127.0.1.1] (localhost [127.0.0.1])
	by kansas-city.smtp.mymangomail.com (Mango Mail) with ESMTP id EC0A5FC9CD;
	Tue, 24 Mar 2026 17:42:05 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gerlicz.space;
	s=mango-1; t=1774388525;
	bh=vneEljyTo4RfVpBuDDMQHJFLWqwFifI7m9i1f2KAT1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tzEXMRpIjNoHlA10iJZl6V18XGnNt6mCkpws5WfRMgpUbWj1/5accpboq3FOhZXr9
	 aIOQcn3s8Z+SF94GlprbCJIgJH1h8yrMp4yd3Rvs+/FcsOMbhm1fdmtwEXbjl+JdFX
	 QsQsfuT5skhsAKL/eIKAhthrPpKHB3NYf9pa4v4A=
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
	by kansas-city.smtp.mymangomail.com (Mango Mail) with ESMTPSA id 0B633FC989;
	Tue, 24 Mar 2026 17:39:13 -0400 (EDT)
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
Subject: [PATCH v4 3/5] liveupdate: fail session restore on file
 deserialization errors
Date: Tue, 24 Mar 2026 22:39:07 +0100
Message-ID: <20260324213909.75643-1-oskar@gerlicz.space>
In-Reply-To: <20260324212730.65290-3-oskar@gerlicz.space>
References: <20260324212730.65290-3-oskar@gerlicz.space>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: ynqo3kkamwp6cc4ejh9cfu4tqe9tgip8
X-Rspamd-Queue-Id: 86342160008
X-Rspam-User: 
X-HE-Tag: 1774388527-634806
X-HE-Meta: U2FsdGVkX188uzJdUHTAH2WYQ/N2HzwbfFDRvyU1S8vuKOU2x36xTAhCtdtRwLv/uXdBHZz0eOK14p/R9z887zeuTvdQ1TQfu2G4lvcld9DCARMoCE5G0phe1yL1yxy8fXic9eeEWkkYzdBQl22NT5ooUMiaNt/OgQc4SMdy/KF7MRaqSStK2bklQFLLiZDFTzJ1+EO/mwp8049tkWnajQua9kUyq3Ar7n9ubP2qaiwkHnfB4GO84knuFOdpjpFUK2DjlxrRNfuNjqo0Q7h8ZlK6cVi31KavtZt7WgeDsOXgQ9WL+hXvUjZHYrf7Q7u+7/oVLjg7og8VFL/kYLzol1+lWnPq7NABCbBG/ux925EJg0SaGjhD9r89YdNldTveuWQq3aOvp93H0A53FHF/VMMswwvTDCHL7MF7XR5DVDdWNQcA7jQX6hSWLWMTtKe4GeDj+CAYX8J62jdlbNV56a0Y9/h+Pcg2xAM11RyfZ+75thjkjODuLucg1tF2xsFa/GZKlEIJTOaummi9EcSGS6Yxmpi8Oh+A7jwTliPd+Ik+2qgqPHQHBaxhdoVpwd2ZbARZjoIWpiioOXtH8nCxPlVOtL/WTFdXx711MeIj8X+33pnKIHZvEbp/fMy3YxRVgRRvgMWnuDSDyi3TNdHObzYWqhKF0xu3OZBMJEBJLd55NZis465nZUQIwnmLXy9MRxiRnXMDTXltQwyOlHp6lbYq4fthJAGqlE44uWgCB72voMsn7AjF7je1CH3ZsmTrrv6GiBlz8a23ErIm3FV+/AFH28J/raMY9QgILzOeWcb7Yg02QYq4iqXCCC/6zFVvZnN9sKJhsjrbPCL5wIYIbYEIhcfHfeH+urZpti7vchn1tfzYR05w+oEkBA82mDEiw9Vo7qdxFZTRmvvq1RM+oi26niwDrgXVN3ZIVIsHIAc7F4Guc6jbl31LBbU9XDmPsLc4em2AZUIQEgrA7eg
 7HfZva1x
 oR19urRW9XjexXtczWlGv0SboJIsOqKBxfWpFpPva4x9A2ylt/6RkZiqrvZ7c1F2rjXyl3DrcPMM02Lalb/QWjh+iw3385nCIFmKZuSXdwubRqAFV7eWZoiBRXf4ialmWmdxlvngimd35VsRAzfpvbJ/roOF3E7ov8u0eObwBZpy6Zx38yRRLfqeKOGW4m1kRod1B7wdGQaQmdu9fuTJCmu/7dTeqGivxKUIgss7WXvfbkjYjo/ORKKjeqTe+yjuvkytHkXIowqGDjN+Ur4Ty6Kf8Dd4Y1DDBXHr4iKtpk1qDZ+h/+ciktgP5Lfud4cQ0B/7nzW9efWPsdQFz1Y1FkKVPgPkW8sCFQMeuElXNZvKfiEwn4JaBCbrzhQ==
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
 kernel/liveupdate/luo_session.c  | 56 +++++++++++++++-----------
 mm/memfd_luo.c                   | 24 +++++++-----
 5 files changed, 100 insertions(+), 51 deletions(-)

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
index d6e9e85004b0..94ca236cde21 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -101,6 +101,7 @@ void luo_file_unfreeze(struct luo_file_set *file_set,
 int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 		      struct file **filep);
 int luo_file_finish(struct luo_file_set *file_set);
+void luo_file_abort_deserialized(struct luo_file_set *file_set);
 int luo_file_deserialize(struct luo_file_set *file_set,
 			 struct luo_file_set_ser *file_set_ser);
 void luo_file_set_init(struct luo_file_set *file_set);
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index cc03fc2bef97..e35e53efb355 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -301,6 +301,20 @@ static void luo_session_unfreeze_one(struct luo_session *session,
 	luo_file_unfreeze(&session->file_set, &ser->file_set_ser);
 }
 
+static void luo_session_discard_deserialized(struct luo_session_header *sh)
+{
+	struct luo_session *session;
+
+	down_write(&sh->rwsem);
+	while (!list_empty(&sh->list)) {
+		session = list_last_entry(&sh->list, struct luo_session, list);
+		__luo_session_remove(sh, session);
+		luo_file_abort_deserialized(&session->file_set);
+		luo_session_put(session);
+	}
+	up_write(&sh->rwsem);
+}
+
 static int luo_session_release(struct inode *inodep, struct file *filep)
 {
 	struct luo_session *session = filep->private_data;
@@ -694,24 +708,10 @@ int luo_session_deserialize(void)
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
 
@@ -719,7 +719,8 @@ int luo_session_deserialize(void)
 		if (IS_ERR(session)) {
 			pr_warn("Failed to allocate session [%s] during deserialization %pe\n",
 				sh->ser[i].name, session);
-			return PTR_ERR(session);
+			err = PTR_ERR(session);
+			goto out_discard;
 		}
 		session->incoming = true;
 
@@ -727,21 +728,30 @@ int luo_session_deserialize(void)
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


