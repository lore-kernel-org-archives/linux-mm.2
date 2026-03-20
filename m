Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 760A010987B2
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 16:42:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC5C36B012F; Fri, 20 Mar 2026 12:42:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9D466B0131; Fri, 20 Mar 2026 12:42:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDAF36B0132; Fri, 20 Mar 2026 12:42:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BCE9E6B012F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:42:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7522B8937C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:42:18 +0000 (UTC)
X-FDA: 84567009156.18.1844C30
Received: from toronto-edge.smtp.mymangomail.com (toronto-edge.smtp.mymangomail.com [209.38.81.170])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9BBC020015
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:42:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gerlicz.space header.s=mango-1 header.b=dVAnV60L;
	spf=pass (imf03.hostedemail.com: domain of oskar@gerlicz.space designates 209.38.81.170 as permitted sender) smtp.mailfrom=oskar@gerlicz.space;
	dmarc=pass (policy=quarantine) header.from=gerlicz.space
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774024936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=12eV5O9XU1QG2j4V22rptbcLrLlRG2N4Np2JBHQuFzY=;
	b=IJBNE9MLQpFurtCz1Ka3Afnl/Tai3cK0Jzj3dQG1ffBg1AopS5Kxv/hrLHME7BjzreZjPJ
	1JFAvI365gaVAFuj0a2TQSPvoEUZluua8S+/9/qyFj464+rpayhASM5QCEyvgB895QpbW1
	fWEyCvte3Jhmo1a0wswj3unYJWiaTq0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gerlicz.space header.s=mango-1 header.b=dVAnV60L;
	spf=pass (imf03.hostedemail.com: domain of oskar@gerlicz.space designates 209.38.81.170 as permitted sender) smtp.mailfrom=oskar@gerlicz.space;
	dmarc=pass (policy=quarantine) header.from=gerlicz.space
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774024936; a=rsa-sha256;
	cv=none;
	b=XvZe0JIGZevNvezk2JZKeXydyrP8XmBD6gHREdYSnOB2skFz1rpPQQzS+brjNNFxkkSksA
	DyD5cA6p5HXqs4L5GLV0MmgIGMAudIG9zbIUEijRuc6RxKA77blgEePrX8A5SZGRUVktNh
	Uxb/k0O39eA16f0gSq7MNcheIsZEa7g=
Received: from [127.0.1.1] (localhost [127.0.0.1])
	by hillsboro.smtp.mymangomail.com (Mango Mail) with ESMTP id C36FA5D9D7;
	Fri, 20 Mar 2026 12:41:58 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gerlicz.space;
	s=mango-1; t=1774024918;
	bh=J/1BiQbwlvxBt7cWoacVDZkl2V/E1R2YIIE3+5yf7DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVAnV60LpMdbV2dsHvLTbSJOu0JGMLqhSycUN9zBO960h4lvQ7WRi15lZSHl6gbsW
	 7D1IEeCJCiitk/0LoHCgi415L2LrwOvDMholQ8nJsRIj75Y7WPEZa6WScOmsYbCFU8
	 Bv2ID5wYc9JHzMqvNOof7QjR8p6OFsZ7P+1SAtTY=
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
	by hillsboro.smtp.mymangomail.com (Mango Mail) with ESMTPSA id 8CBD65D9B1;
	Fri, 20 Mar 2026 12:40:52 -0400 (EDT)
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
Subject: [PATCH 3/5] liveupdate: fail session restore on file deserialization
 errors
Date: Fri, 20 Mar 2026 17:37:18 +0100
Message-ID: <20260320163720.100456-3-oskar@gerlicz.space>
In-Reply-To: <20260320163720.100456-1-oskar@gerlicz.space>
References: <20260320163720.100456-1-oskar@gerlicz.space>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9borhbspup4rfgc9jf8t8iac3b93f31k
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 9BBC020015
X-HE-Tag: 1774024935-729288
X-HE-Meta: U2FsdGVkX199SZhJiZSxTsUQBkbKZcIutzfCUBRTH46lTAOlbegC79d/zjn6I3/4IBOHL1kB0SvFZIeVEM+WjV7UM1v/lStrS6gBQ9bgLJj3L6GFf7r1VqOlriX/zcz7QQB5dOerKXBL+6a+n/SeoFj4HUdi7NDFfBFqkBwJ7szLBcm51MNdv3kseG6p9H86VIwZXLxSyCxMcKYvM8Cl2DTI5sPb9jRR2UKcLnIHMMIw6rGTQ8n9rtotjaKOidFkZs660XbyOTPP+N8qvKRpHjkC6jw03RhWP/VgR7PytfHQCR7xGOdF1gef/UUCovent8P8iwPJsAMMvPj7982A7CcUxeC4JuJ7nrqkMNEkOZhgOqIEtcaDinCBepEA5UZll/x/M2a2/7811rGME1sLMHI+AoUIeTFG1vsZHaFzCesF43oaSFNygZS8SEBtgp61NGzlGYjLk68b6o9zCQ5Zu804HVVk2cIh3lMOFaj2I9NXvGM06qBmbUNLFXzJyyVTSdrLMJrQV5NiDT/c2w+UazzgRn1wFzbtS5ee/og4tc/lZhGydvhlYLOwGAXmzgafEo8XEwRExfiCy0Hqr/eEIhRkdR0DqaUJdnZgRWQ4C/1tQdI5q6nVNASJqRwO67jVbTxIOxuQDyfZ/cQZTngrHee2zpEqbTFolmTZAawJ4Jh19DSLxokO3xxpeETpok8dPZKKC1aGkDM+Xz8zmzknPRJLV3ECtNwKlVbq2p84hVa0XoSqK7Rb0QRgqniyApb+wcM3ivJGBu164XHa7t6vtps7gZi9nYUIEjEfjQ+kIMApIfHZTi+iUJp+jArH1uo1Yte6k2C7zkXc4D1QawPUCbuZsg0ugqv4VnX5L4R0pu/sCNEqxJXPje9PnBt9imJbaqBdLja7W33bG5NHlSkdvzla6KKZnk0i6N65Uo3xl2iMiLYUP7VjPMw8y1CxGNP29qTtV6M16XTTPlUID+7
 urDefZJH
 mJJ7ah3mFnwnDd6F/gryQuFGDOdEe5Rl2vRDZmDEw72NyMxrTUxhecqQMAA1OpPIno+95JdQtVz/Z3K0ymfCOOg3Txu5yYX1D6TzajQIsTbg2sgsLQZ6yFbPHfrsOmsSn/GwWlF/zyXN1H7HA/k0LPB/r0YoQUx3b/bam7vW5KUgRSY0GWs1BfigThKJUFzXNwp2KpDCD2wHdE9hLP0xHGtja0ar9Ee8F76wNU+C8USm0p9wM2jwF6wm/tY0NKS+wHItuhRYQSP/tKxitCL/PY6HTV+HAZmT0P8RswaqkPEXdIsjBqDEcvSrHF1AxEiG48kZahagfnM6+gxqoFfJFMmTGXB9FDfrzv/1eCKZBdD/xyvxflVsOa2mmjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

luo_session_deserialize() calls luo_file_deserialize() but ignores its
return value. If file restore fails part-way through, the incoming
session still gets inserted and the caller still sees success.

Leaving a partially restored session on the incoming list is dangerous
because later retrieve or finish operations can walk half-built file
state and operate on uninitialized or stale entries.

Propagate file deserialization failures back to session restore,
remove the partially restored session, and free any struct luo_file
objects that were already allocated before returning the error.

Signed-off-by: Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
---
 kernel/liveupdate/luo_file.c    | 45 ++++++++++++++++++++-------------
 kernel/liveupdate/luo_session.c | 27 +++++++-------------
 2 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 5acee4174bf0..cc0fd7e9c332 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -717,6 +717,22 @@ int luo_file_finish(struct luo_file_set *file_set)
 	return 0;
 }
 
+static void luo_file_discard_deserialized(struct luo_file_set *file_set)
+{
+	struct luo_file *luo_file;
+
+	while (!list_empty(&file_set->files_list)) {
+		luo_file = list_last_entry(&file_set->files_list,
+					   struct luo_file, list);
+		list_del(&luo_file->list);
+		mutex_destroy(&luo_file->mutex);
+		kfree(luo_file);
+	}
+
+	file_set->count = 0;
+	file_set->files = NULL;
+}
+
 /**
  * luo_file_deserialize - Reconstructs the list of preserved files in the new kernel.
  * @file_set:     The incoming file_set to fill with deserialized data.
@@ -747,6 +763,7 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 {
 	struct luo_file_ser *file_ser;
 	u64 i;
+	int err;
 
 	if (!file_set_ser->files) {
 		WARN_ON(file_set_ser->count);
@@ -756,21 +773,6 @@ int luo_file_deserialize(struct luo_file_set *file_set,
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
@@ -787,12 +789,15 @@ int luo_file_deserialize(struct luo_file_set *file_set,
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
@@ -803,6 +808,10 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 	}
 
 	return 0;
+
+err_discard:
+	luo_file_discard_deserialized(file_set);
+	return err;
 }
 
 void luo_file_set_init(struct luo_file_set *file_set)
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 39215e5eda7a..77afa913d6c7 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -565,21 +565,6 @@ int luo_session_deserialize(void)
 	if (!sh->active)
 		return 0;
 
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
 
@@ -598,9 +583,15 @@ int luo_session_deserialize(void)
 			return err;
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
+			luo_session_remove(sh, session);
+			luo_session_free(session);
+			return err;
 		}
 	}
 
-- 
2.53.0


