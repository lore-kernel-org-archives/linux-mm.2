Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72CB810987AB
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 16:40:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B52276B012C; Fri, 20 Mar 2026 12:40:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B292D6B012D; Fri, 20 Mar 2026 12:40:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A66476B012E; Fri, 20 Mar 2026 12:40:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 94DF86B012C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:40:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5AEAF139A4F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:40:17 +0000 (UTC)
X-FDA: 84567004074.25.72F7ED1
Received: from smtp.mymangomail.com (unknown [205.185.121.143])
	by imf02.hostedemail.com (Postfix) with ESMTP id 015BD80010
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:40:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gerlicz.space header.s=mango-1 header.b=DSL9oMa3;
	dmarc=pass (policy=quarantine) header.from=gerlicz.space;
	spf=pass (imf02.hostedemail.com: domain of oskar@gerlicz.space designates 205.185.121.143 as permitted sender) smtp.mailfrom=oskar@gerlicz.space
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774024815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OFWl7Ej0DLfHR3zQ1Wnf1cKYYmYa0BNVU+VFNYEBse8=;
	b=gpmOvBa2vJr1H16uRW2rVr96hMAf1f/nH0uW9YYvMan73/JYevjelTfyuLrVhNotzmkNBr
	R6yr4aJpaUoJgIszpy4Rgodyz7wIsUsfXk8RJyI/vu9mjTwZXPKPBd6fAAWF/1Lqd9t/fn
	w3096ELaEjRxp0YHPHlYqUq/DifxgPI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gerlicz.space header.s=mango-1 header.b=DSL9oMa3;
	dmarc=pass (policy=quarantine) header.from=gerlicz.space;
	spf=pass (imf02.hostedemail.com: domain of oskar@gerlicz.space designates 205.185.121.143 as permitted sender) smtp.mailfrom=oskar@gerlicz.space
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774024815; a=rsa-sha256;
	cv=none;
	b=q7CCXjQp+ICf+hHRR9dDClmnek2MMJchWZQKmq3gmebLpX6zysRQniEbQ4qfIwARJZ0kPy
	fllgs4cUNLojj6AO+tV84VWg8xCMgpA9gUm4VBo8dao1Mdk4qfKeeTZr60IYr9SZUHrvLY
	9iqu099z86nIZKkzQh0qzGtaz2F25zA=
Received: from smtp.mymangomail.com (localhost [127.0.0.1])
	by smtp.mymangomail.com (Mango Mail) with ESMTP id C45144089D;
	Fri, 20 Mar 2026 12:39:33 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gerlicz.space;
	s=mango-1; t=1774024773;
	bh=d0ek7AVQMvweJcV8KF6oPuPSOtLVpNAVzgGT5RI8EcU=;
	h=From:To:Cc:Subject:Date:From;
	b=DSL9oMa38kQD7wIQawTgMO0RV9QMPigjVMbhXOFBzgog5IuDWtY7Rv57NTZRuVbuI
	 4HCJSWwK1CfT/nDEoJ/owhoqupk13oUBSh5z69FSSxfm0FnQl+Nl7BdviOJYPGZaQw
	 OoTDqrIbtyEIF2Xsxz7zDvL7WluNYc2EWKrjIf04=
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
	by smtp.mymangomail.com (Mango Mail) with ESMTPSA id 7038A40440;
	Fri, 20 Mar 2026 12:38:30 -0400 (EDT)
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
Subject: [PATCH 1/5] liveupdate: block outgoing session updates during reboot
Date: Fri, 20 Mar 2026 17:37:16 +0100
Message-ID: <20260320163720.100456-1-oskar@gerlicz.space>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 015BD80010
X-Stat-Signature: 4yifsg4ousfn94fwiioxkiqdncito6ft
X-Rspam-User: 
X-HE-Tag: 1774024814-231934
X-HE-Meta: U2FsdGVkX1/gshjNd/kayfspwNm6h20PBSvysAWAFt3MobA6ivyAUR78GUdQl5v0A2RS8//pKYtdEp4imngUSrSmb1bn2mpLwLOuq9BmeQ1POiICcCwIT0+3+6DDWT9vpVU1IPqxp0mT0u1as1hC8m4JV43EJ82kU6KuQ1rcEtsFv9M4LOA++EwRSIDfyy8DilZQhQBBWS3Z/Ss/g0GAgBjIK+8j3Xi3K8y5oj5j+r8a7vyW/7d6eKpflLxbSYH8TdLBUncSDpNGEi+w8d5ZWxmuGHoZ+2SOL38MXFBjNoK3a/XofEnevXecD792OsqXh4bH6ClHa1WoPRejafpNUW/6LDUW8zZ0zqY7Dtr+wsD9QMgZT/0WkkDsFmQihhlRGB+9EmS7ReAnKpM9Kd4vzAauGQuciZKtb6IPn2zvqWwvgb6ekQ9dgkBojT3gDCbYLqZxKWsiq8mXZ4k9mePSuBKWLDwptAIURuYPWTIInaVmfmJqlZfnYhUzP9RAG8Kk0CfJR/0hyait9lIHCViSCFhKgAWy7au475uw3RqFK+RHNJPBnNiuqqqnXgnoWEKiZpGstJdIXvfmtg1MQSu4B1XwsxPt1A+GFYQkTSoMQGH+Ri+zpicLNWtDTCxReM9O5TNhbcX1E9hdgXZ0zu/jzyMVkjfQRBoFjxB8jF8HGRjhMH9YJPLiLkq1QLY66PqM9q207fCdFhD4Z4t3bF1j5Qng1OKaz/bj0JwSRIS4VSAOWx9YTx/iqqZhedZ5PMz6i+vp6l6CjwmzRggZ6Uq2SXGUk0YgKKqWqKCuyNDLkyR9BvDKasRyvuubCIGdlYdwx22wdfLwonFIe2N8PhBTS6+a64SzD9GPbEU3ToIc37oQogHVG0/IiQu6AgOctvmi9QGNm4FrP8PQnZV80NLBGEON3upTP8mmzya3MsK744QiAHcvj/yEWhY6IFCqCki+odi/5aQwWmf8q5lMbYL
 Yy0hv67K
 CltNPz2Pwpi6k5KHZXxaV+g5141PDlgxj15ZTMb1uGYz2sI63j9DvpNms0LJXXvg+Vn08KChyN+cr1AVO4nZVGqnGq0XecdnOtK33mQp2NkdD6/LJgzvVG9yquEwNjPLbNBzzr1j5hQ+9Zmr7muyHSlo/FsO7X9zECoEOOw+tDhKpgr9y4sBcqMjH84olJyb5M9VmpFNa1KV5MqnDwHQ+8Gabl4JVmQkl7RmmS3c1lxe5g5wWvTAF6XrfnGurTeDxBZybcEQSm0nThdWXdQHopn5866leEGJVpFxfcfEiQ4o1yupG9dfsxwlKe9W08Ib3q6bQP/7YvVe2R04tZKOkVXIcJ8TYssPTfeZ/VnNWQNb9II731NvN2rGNKhNd37adcHOZb3xdSq/LPZvRbxC4ZWPcdEHxmCio1gx6e/SOOYByBCJtYI7XsMPj6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When kernel_kexec() starts a live update handover, LUO serializes
outgoing sessions before the reboot path freezes tasks or shuts
devices down. That leaves a window where close() and
LIVEUPDATE_SESSION_PRESERVE_FD can still mutate an existing outgoing
session after luo_session_serialize() has already captured it.

The race is dangerous because the next kernel may inherit stale file
metadata or references to memory that userspace has already
unpreserved. That breaks handover consistency and can later trigger
restore failures on already torn down state.

Mark the outgoing session set as rebooting while serialization is in
progress, reject new mutations with -EBUSY, and make release wait
until rebooting finishes before unpreserving files. Reset the flag and
wake waiters when serialization rolls back, and use READ_ONCE() and
WRITE_ONCE() so the state is visible across CPUs.

Signed-off-by: Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
---
 kernel/liveupdate/luo_session.c | 58 ++++++++++++++++++++++++++++++---
 1 file changed, 53 insertions(+), 5 deletions(-)

diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 783677295640..ee5ea2a8ed3f 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -66,6 +66,7 @@
 #include <linux/rwsem.h>
 #include <linux/slab.h>
 #include <linux/unaligned.h>
+#include <linux/wait.h>
 #include <uapi/linux/liveupdate.h>
 #include "luo_internal.h"
 
@@ -91,8 +92,10 @@ struct luo_session_header {
 	long count;
 	struct list_head list;
 	struct rw_semaphore rwsem;
+	wait_queue_head_t reboot_waitq;
 	struct luo_session_header_ser *header_ser;
 	struct luo_session_ser *ser;
+	bool rebooting;
 	bool active;
 };
 
@@ -110,13 +113,23 @@ static struct luo_session_global luo_session_global = {
 	.incoming = {
 		.list = LIST_HEAD_INIT(luo_session_global.incoming.list),
 		.rwsem = __RWSEM_INITIALIZER(luo_session_global.incoming.rwsem),
+		.reboot_waitq =
+			__WAIT_QUEUE_HEAD_INITIALIZER(luo_session_global.incoming.reboot_waitq),
 	},
 	.outgoing = {
 		.list = LIST_HEAD_INIT(luo_session_global.outgoing.list),
 		.rwsem = __RWSEM_INITIALIZER(luo_session_global.outgoing.rwsem),
+		.reboot_waitq =
+			__WAIT_QUEUE_HEAD_INITIALIZER(luo_session_global.outgoing.reboot_waitq),
 	},
 };
 
+static void luo_session_reboot_done(struct luo_session_header *sh)
+{
+	WRITE_ONCE(sh->rebooting, false);
+	wake_up_all(&sh->reboot_waitq);
+}
+
 static struct luo_session *luo_session_alloc(const char *name)
 {
 	struct luo_session *session = kzalloc_obj(*session);
@@ -152,6 +165,9 @@ static int luo_session_insert(struct luo_session_header *sh,
 	 * for new session.
 	 */
 	if (sh == &luo_session_global.outgoing) {
+		if (READ_ONCE(sh->rebooting))
+			return -EBUSY;
+
 		if (sh->count == LUO_SESSION_MAX)
 			return -ENOMEM;
 	}
@@ -216,9 +232,22 @@ static int luo_session_release(struct inode *inodep, struct file *filep)
 		}
 		sh = &luo_session_global.incoming;
 	} else {
-		scoped_guard(mutex, &session->mutex)
-			luo_file_unpreserve_files(&session->file_set);
 		sh = &luo_session_global.outgoing;
+
+		for (;;) {
+			down_read(&sh->rwsem);
+			if (READ_ONCE(sh->rebooting)) {
+				up_read(&sh->rwsem);
+				wait_event(sh->reboot_waitq,
+					   !READ_ONCE(sh->rebooting));
+				continue;
+			}
+
+			scoped_guard(mutex, &session->mutex)
+				luo_file_unpreserve_files(&session->file_set);
+			up_read(&sh->rwsem);
+			break;
+		}
 	}
 
 	luo_session_remove(sh, session);
@@ -231,10 +260,22 @@ static int luo_session_preserve_fd(struct luo_session *session,
 				   struct luo_ucmd *ucmd)
 {
 	struct liveupdate_session_preserve_fd *argp = ucmd->cmd;
+	struct luo_session_header *sh = NULL;
 	int err;
 
-	guard(mutex)(&session->mutex);
-	err = luo_preserve_file(&session->file_set, argp->token, argp->fd);
+	if (!session->retrieved) {
+		sh = &luo_session_global.outgoing;
+		down_read(&sh->rwsem);
+		if (READ_ONCE(sh->rebooting)) {
+			up_read(&sh->rwsem);
+			return -EBUSY;
+		}
+	}
+
+	scoped_guard(mutex, &session->mutex)
+		err = luo_preserve_file(&session->file_set, argp->token, argp->fd);
+	if (sh)
+		up_read(&sh->rwsem);
 	if (err)
 		return err;
 
@@ -578,6 +619,10 @@ int luo_session_serialize(void)
 	int err;
 
 	guard(rwsem_write)(&sh->rwsem);
+	if (READ_ONCE(sh->rebooting))
+		return -EBUSY;
+
+	WRITE_ONCE(sh->rebooting, true);
 	list_for_each_entry(session, &sh->list, list) {
 		err = luo_session_freeze_one(session, &sh->ser[i]);
 		if (err)
@@ -595,8 +640,11 @@ int luo_session_serialize(void)
 	list_for_each_entry_continue_reverse(session, &sh->list, list) {
 		i--;
 		luo_session_unfreeze_one(session, &sh->ser[i]);
-		memset(sh->ser[i].name, 0, sizeof(sh->ser[i].name));
+		memset(&sh->ser[i], 0, sizeof(sh->ser[i]));
 	}
+	sh->header_ser->count = 0;
+	/* Reset rebooting flag on serialization failure. */
+	luo_session_reboot_done(sh);
 
 	return err;
 }
-- 
2.53.0


