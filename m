Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 896691094478
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 14:38:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76F036B00BC; Sat, 21 Mar 2026 10:38:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 745D66B00BD; Sat, 21 Mar 2026 10:38:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65C3B6B00BE; Sat, 21 Mar 2026 10:38:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 529C86B00BC
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 10:38:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CC1C91A0592
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:38:46 +0000 (UTC)
X-FDA: 84570326652.13.3BBCA59
Received: from hillsboro-edge.smtp.mymangomail.com (hillsboro-edge.smtp.mymangomail.com [5.78.130.219])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4C349140002
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:38:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gerlicz.space header.s=mango-1 header.b=tf6FHtXC;
	spf=pass (imf26.hostedemail.com: domain of oskar@gerlicz.space designates 5.78.130.219 as permitted sender) smtp.mailfrom=oskar@gerlicz.space;
	dmarc=pass (policy=quarantine) header.from=gerlicz.space
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774103924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=HTcUM5/5vTlxqDZ0IDfSrSlcUXg6dnvK2vq84Nv3L18=;
	b=zYhik/1x6APAx+16bqyP5MG07kaJ7i7A10jsSQSxAYY7DLbzTyuLsiAnMguDlnXqaLCc9A
	//WKxgLFxDVO5Itun4CZMUfKIRm0f14pOxpoa93enjEi6J2ECR9oaSJItsVB3rBV1Y1OFE
	qcaGyxU6B3d5l8oLg5TAX7U1VUIwdGs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774103924; a=rsa-sha256;
	cv=none;
	b=ybmSCvJk9S7XVYVV22EyIIqvi+ROOfk9+R8c3RjxuTym6jrJEqoAD3jpqnuWM9nTO0xe4x
	C23OUR0bFQDB09/4+3Gs1jgR9jRacwzokAjkZnSDi/EvTPf1mG8d5QlgwgZgUp8TLCcrCe
	n/Z9P0GNP8ZPIJ+kEx5TBXR6DsIswKI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gerlicz.space header.s=mango-1 header.b=tf6FHtXC;
	spf=pass (imf26.hostedemail.com: domain of oskar@gerlicz.space designates 5.78.130.219 as permitted sender) smtp.mailfrom=oskar@gerlicz.space;
	dmarc=pass (policy=quarantine) header.from=gerlicz.space
Received: from smtp.mymangomail.com (localhost [127.0.0.1])
	by smtp.mymangomail.com (Mango Mail) with ESMTP id 7432B4162F;
	Sat, 21 Mar 2026 10:38:13 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gerlicz.space;
	s=mango-1; t=1774103893;
	bh=RXmr7HObhK4yLbUfOBHniLrvNTlKJGpTMMr7zufLkKQ=;
	h=From:To:Cc:Subject:Date:From;
	b=tf6FHtXC7WcgkVaXgx3C1OPqRiGDqCEMicu9wTyplsDVT2jXSiMhdB9sq9+Lo5zc7
	 Bfs0xA2gQXcbifHE+Pmcuwag8DFQvLAMUc3Jpi1dumZolGefCRks2lFWQ47MOieGA7
	 YUvY2r54QT4kGumut/TZhguuE/R2SVlq/bbsOjEY=
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
	by smtp.mymangomail.com (Mango Mail) with ESMTPSA id F3460408C6;
	Sat, 21 Mar 2026 10:36:48 -0400 (EDT)
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
Subject: [PATCH v3 1/5] liveupdate: block outgoing session updates during
 reboot
Date: Sat, 21 Mar 2026 15:36:38 +0100
Message-ID: <20260321143642.166313-1-oskar@gerlicz.space>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: o6c67zii5344fbpth99hikskhnwyae4f
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C349140002
X-Rspamd-Server: rspam12
X-HE-Tag: 1774103924-894804
X-HE-Meta: U2FsdGVkX1+lvNLyInbUqtZT552cXtr1gsX98e6xXi2xdDeIkeNXSB/AeUXuCAQPNWg+5qfbPm1lBInw5+QzEwT1R3bLanMntT6514R4PkwTvEjt0IRxqyNgm39OWUhZvfy7vFedYjX5ryRdNXAdz9AH2nUJm36ZiBZ8Z1SSmBxQizwjZvV+R9CUUbXVJFvqtbv1I/yeCB5VQIrEjuMg5x4K2T/9VLH2hVyRiRZTsBJhVdcJXGr+xjEtPL0wtWD7BgN5I5rM+E/Lsy/VshSJTMkx1OJ/KC84obpiWgWAXH1SD8DBh20UikoPnCoUlmjv1EZ1H59XOEXXVUNgX2RVA7gZyD9NGg2No4ngHZv88a1U7xIneJyx0H3WpwyrnFvSNfuATKdawTHnEC/WRbMexXK9q1yfnL1rpfeauQtRXcm/dr4R7SzvMp/wQ9cNdmH+PFgpwvdGZULtuWBGMJGni2dnbik6QdpoM2eWrXTCPpVpFWqsMZnpuGs1pkWir/gI9EVwkloBDs7KysFdsE3f5mnYiPFfy4oXpF4cJaA4+8I6Sp1sdSC+SIlWiOsgOpy8zfunLSVVbOKW1cchbTfLWU2t44+SwuRdwrcxozaFDBPpgtpAXDe8ebB3qmunibGSw4ddSFu8C16YvuvK2kkEaUnWyESfthTfA9bYRuZR1AmHZFA9C5BeHjmYb71VOMQOyksh2wuv03an3NoxGZlglrujhihvIzaI2Wh1hGYqmU01x5zpdA8cdHsawJyJGtdSHYw1r7Fvfyx9eBpHH/SOEsOhBJsiX+wzQHn4YdxGPDsq8BJZMG686S40uIv9tSczka0A2gTrvUmpKIlkf0vCg6o1Is9zDfedhkl5EUs50CfhWw7gvCX4ZfOlJV02+/7iuOBZeBlTSCnHhe3cWPCKfHnc1eNIHqcFv3AIzdePeCJLYZn7EZOUbE4VghwqUXxDWROmqvD+QxLsIzWZtaF
 kbuT5Nqm
 xkeze/Ed3JZ1G9lbE0Sdb8iDWYAER0ZFDSdYm4x341N1mZcj+zuuo50X6Ds9ZM6Kayuy6bxLLSCr4t4a9ivPWPk8s4xdIS+kcGy4GJAk9wvOQfHO+6IkZOsNo5u3aA+oMQ7OGcL9MzM8v6sGUIzLWMHZqlb2y69u3zJpblFNr+vdIC1F+UjDOYPhSdJYArEQC5DTYPbwrvASODdyFFeEA8FMuxremzhdgaFX3gdKahOAzEUqGZpiDQOAEncVM2qEVyVOj4CIPwvijg/Fhy6DDn+hIl0BOo801KsQXeFyp8hCd3DNj4Aa1KUBlVAKOvE2G7860SAPPNKKrgjxzitwSRkaz3tXIsqPneHOR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kernel_kexec() serializes outgoing sessions before the reboot path
freezes tasks, so close() and session ioctls can still mutate a
session while handover state is being prepared. The original v2 code
also let incoming lookups keep a bare session pointer after dropping
the list lock.

That leaves two correctness problems in the reboot path: outgoing state
can change after serialization starts, and incoming sessions can be
freed while another thread still holds a pointer to them.

Add refcounted session lifetime management, track in-flight outgoing
close() paths with an atomic closing counter, and make serialization
wait for closing to drain before setting rebooting. Reject phase-invalid
ioctls, keep incoming release on a common cleanup path, and make the
release wait freezable without spinning.

Fixes: fc5acd5c89fe ("liveupdate: block outgoing session updates during reboot")
Signed-off-by: Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
---
 kernel/liveupdate/luo_internal.h |  12 +-
 kernel/liveupdate/luo_session.c  | 236 +++++++++++++++++++++++++++----
 2 files changed, 221 insertions(+), 27 deletions(-)

diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 8083d8739b09..0cfc0269d746 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -9,6 +9,7 @@
 #define _LINUX_LUO_INTERNAL_H
 
 #include <linux/liveupdate.h>
+#include <linux/refcount.h>
 #include <linux/uaccess.h>
 
 struct luo_ucmd {
@@ -63,8 +64,7 @@ struct luo_file_set {
  * @list:       A list_head member used to link this session into a global list
  *              of either outgoing (to be preserved) or incoming (restored from
  *              previous kernel) sessions.
- * @retrieved:  A boolean flag indicating whether this session has been
- *              retrieved by a consumer in the new kernel.
+ * @state:      Current lifecycle phase of the session.
  * @file_set:   A set of files that belong to this session.
  * @mutex:      protects fields in the luo_session.
  */
@@ -72,8 +72,14 @@ struct luo_session {
 	char name[LIVEUPDATE_SESSION_NAME_LENGTH];
 	struct luo_session_ser *ser;
 	struct list_head list;
-	bool retrieved;
+	enum {
+		LUO_SESSION_OUTGOING,
+		LUO_SESSION_INCOMING,
+		LUO_SESSION_RETRIEVED,
+		LUO_SESSION_CLOSED,
+	} state;
 	struct luo_file_set file_set;
+	refcount_t refs;
 	struct mutex mutex;
 };
 
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 783677295640..d97ec91e1118 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -51,6 +51,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/anon_inodes.h>
+#include <linux/atomic.h>
 #include <linux/cleanup.h>
 #include <linux/err.h>
 #include <linux/errno.h>
@@ -66,6 +67,7 @@
 #include <linux/rwsem.h>
 #include <linux/slab.h>
 #include <linux/unaligned.h>
+#include <linux/wait.h>
 #include <uapi/linux/liveupdate.h>
 #include "luo_internal.h"
 
@@ -89,10 +91,13 @@
  */
 struct luo_session_header {
 	long count;
+	atomic_t closing;
 	struct list_head list;
 	struct rw_semaphore rwsem;
+	wait_queue_head_t reboot_waitq;
 	struct luo_session_header_ser *header_ser;
 	struct luo_session_ser *ser;
+	bool rebooting;
 	bool active;
 };
 
@@ -110,13 +115,24 @@ static struct luo_session_global luo_session_global = {
 	.incoming = {
 		.list = LIST_HEAD_INIT(luo_session_global.incoming.list),
 		.rwsem = __RWSEM_INITIALIZER(luo_session_global.incoming.rwsem),
+		.reboot_waitq =
+			__WAIT_QUEUE_HEAD_INITIALIZER(luo_session_global.incoming.reboot_waitq),
 	},
 	.outgoing = {
+		.closing = ATOMIC_INIT(0),
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
@@ -128,6 +144,8 @@ static struct luo_session *luo_session_alloc(const char *name)
 	INIT_LIST_HEAD(&session->file_set.files_list);
 	luo_file_set_init(&session->file_set);
 	INIT_LIST_HEAD(&session->list);
+	session->state = LUO_SESSION_OUTGOING;
+	refcount_set(&session->refs, 1);
 	mutex_init(&session->mutex);
 
 	return session;
@@ -140,6 +158,17 @@ static void luo_session_free(struct luo_session *session)
 	kfree(session);
 }
 
+static void luo_session_get(struct luo_session *session)
+{
+	refcount_inc(&session->refs);
+}
+
+static void luo_session_put(struct luo_session *session)
+{
+	if (refcount_dec_and_test(&session->refs))
+		luo_session_free(session);
+}
+
 static int luo_session_insert(struct luo_session_header *sh,
 			      struct luo_session *session)
 {
@@ -152,6 +181,9 @@ static int luo_session_insert(struct luo_session_header *sh,
 	 * for new session.
 	 */
 	if (sh == &luo_session_global.outgoing) {
+		if (READ_ONCE(sh->rebooting))
+			return -EBUSY;
+
 		if (sh->count == LUO_SESSION_MAX)
 			return -ENOMEM;
 	}
@@ -172,17 +204,98 @@ static int luo_session_insert(struct luo_session_header *sh,
 	return 0;
 }
 
+static void __luo_session_remove(struct luo_session_header *sh,
+				 struct luo_session *session)
+{
+	list_del(&session->list);
+	sh->count--;
+}
+
 static void luo_session_remove(struct luo_session_header *sh,
 			       struct luo_session *session)
 {
 	guard(rwsem_write)(&sh->rwsem);
-	list_del(&session->list);
-	sh->count--;
+	__luo_session_remove(sh, session);
+}
+
+static int luo_session_outgoing_begin(struct luo_session *session,
+				      struct luo_session_header **shp)
+{
+	struct luo_session_header *sh;
+
+	if (READ_ONCE(session->state) != LUO_SESSION_OUTGOING)
+		return -EINVAL;
+
+	sh = &luo_session_global.outgoing;
+	down_read(&sh->rwsem);
+	if (READ_ONCE(sh->rebooting)) {
+		up_read(&sh->rwsem);
+		return -EBUSY;
+	}
+
+	*shp = sh;
+	return 0;
+}
+
+static void luo_session_outgoing_end(struct luo_session_header *sh)
+{
+	if (sh)
+		up_read(&sh->rwsem);
+}
+
+static void luo_session_wait_reboot(struct luo_session_header *sh)
+{
+	DEFINE_WAIT(wait);
+
+	for (;;) {
+		prepare_to_wait(&sh->reboot_waitq, &wait,
+				TASK_UNINTERRUPTIBLE | TASK_FREEZABLE);
+		if (!READ_ONCE(sh->rebooting))
+			break;
+		schedule();
+	}
+
+	finish_wait(&sh->reboot_waitq, &wait);
+}
+
+static int luo_session_finish_retrieved(struct luo_session *session)
+{
+	int err;
+
+	guard(mutex)(&session->mutex);
+	if (session->state != LUO_SESSION_RETRIEVED)
+		return -EINVAL;
+
+	err = luo_file_finish(&session->file_set);
+	if (err)
+		session->state = LUO_SESSION_INCOMING;
+
+	return err;
+}
+
+static void luo_session_discard_deserialized(struct luo_session_header *sh)
+{
+	struct luo_session *session;
+
+	down_write(&sh->rwsem);
+	while (!list_empty(&sh->list)) {
+		session = list_last_entry(&sh->list, struct luo_session, list);
+		__luo_session_remove(sh, session);
+		session->state = LUO_SESSION_CLOSED;
+		luo_file_abort_deserialized(&session->file_set);
+		luo_session_put(session);
+	}
+	up_write(&sh->rwsem);
+
+	luo_flb_discard_incoming();
 }
 
 static int luo_session_finish_one(struct luo_session *session)
 {
 	guard(mutex)(&session->mutex);
+	if (session->state != LUO_SESSION_RETRIEVED)
+		return -EINVAL;
+
 	return luo_file_finish(&session->file_set);
 }
 
@@ -204,26 +317,67 @@ static int luo_session_release(struct inode *inodep, struct file *filep)
 {
 	struct luo_session *session = filep->private_data;
 	struct luo_session_header *sh;
+	int state = READ_ONCE(session->state);
+	int ret = 0;
+	bool discard_flb = false;
 
-	/* If retrieved is set, it means this session is from incoming list */
-	if (session->retrieved) {
-		int err = luo_session_finish_one(session);
+	if (state == LUO_SESSION_RETRIEVED) {
+		ret = luo_session_finish_retrieved(session);
 
-		if (err) {
+		if (ret) {
 			pr_warn("Unable to finish session [%s] on release\n",
 				session->name);
-			return err;
+			luo_session_put(session);
+			return ret;
 		}
-		sh = &luo_session_global.incoming;
-	} else {
 		scoped_guard(mutex, &session->mutex)
-			luo_file_unpreserve_files(&session->file_set);
-		sh = &luo_session_global.outgoing;
+			session->state = LUO_SESSION_CLOSED;
+		sh = &luo_session_global.incoming;
+		down_write(&sh->rwsem);
+		__luo_session_remove(sh, session);
+		discard_flb = !sh->count;
+		up_write(&sh->rwsem);
+		luo_session_put(session);
+		luo_session_put(session);
+		if (discard_flb)
+			luo_flb_discard_incoming();
+		return 0;
 	}
 
-	luo_session_remove(sh, session);
-	luo_session_free(session);
+	if (state != LUO_SESSION_OUTGOING) {
+		WARN_ON_ONCE(1);
+		luo_session_put(session);
+		return 0;
+	}
 
+	sh = &luo_session_global.outgoing;
+
+	for (;;) {
+		down_write(&sh->rwsem);
+		if (READ_ONCE(sh->rebooting)) {
+			up_write(&sh->rwsem);
+			luo_session_wait_reboot(sh);
+			continue;
+		}
+
+		atomic_inc(&sh->closing);
+		__luo_session_remove(sh, session);
+		up_write(&sh->rwsem);
+		break;
+	}
+
+	scoped_guard(mutex, &session->mutex) {
+		session->state = LUO_SESSION_CLOSED;
+		luo_file_unpreserve_files(&session->file_set);
+	}
+
+	down_write(&sh->rwsem);
+	if (atomic_dec_and_test(&sh->closing))
+		wake_up_all(&sh->reboot_waitq);
+	up_write(&sh->rwsem);
+
+	luo_session_put(session);
+	luo_session_put(session);
 	return 0;
 }
 
@@ -231,10 +385,16 @@ static int luo_session_preserve_fd(struct luo_session *session,
 				   struct luo_ucmd *ucmd)
 {
 	struct liveupdate_session_preserve_fd *argp = ucmd->cmd;
+	struct luo_session_header *sh = NULL;
 	int err;
 
-	guard(mutex)(&session->mutex);
-	err = luo_preserve_file(&session->file_set, argp->token, argp->fd);
+	err = luo_session_outgoing_begin(session, &sh);
+	if (err)
+		return err;
+
+	scoped_guard(mutex, &session->mutex)
+		err = luo_preserve_file(&session->file_set, argp->token, argp->fd);
+	luo_session_outgoing_end(sh);
 	if (err)
 		return err;
 
@@ -252,6 +412,11 @@ static int luo_session_retrieve_fd(struct luo_session *session,
 	struct file *file;
 	int err;
 
+	scoped_guard(mutex, &session->mutex) {
+		if (session->state != LUO_SESSION_RETRIEVED)
+			return -EINVAL;
+	}
+
 	argp->fd = get_unused_fd_flags(O_CLOEXEC);
 	if (argp->fd < 0)
 		return argp->fd;
@@ -281,8 +446,9 @@ static int luo_session_finish(struct luo_session *session,
 			      struct luo_ucmd *ucmd)
 {
 	struct liveupdate_session_finish *argp = ucmd->cmd;
-	int err = luo_session_finish_one(session);
+	int err;
 
+	err = luo_session_finish_one(session);
 	if (err)
 		return err;
 
@@ -371,9 +537,12 @@ static int luo_session_getfile(struct luo_session *session, struct file **filep)
 
 	lockdep_assert_held(&session->mutex);
 	snprintf(name_buf, sizeof(name_buf), "[luo_session] %s", session->name);
+	luo_session_get(session);
 	file = anon_inode_getfile(name_buf, &luo_session_fops, session, O_RDWR);
-	if (IS_ERR(file))
+	if (IS_ERR(file)) {
+		luo_session_put(session);
 		return PTR_ERR(file);
+	}
 
 	*filep = file;
 
@@ -403,7 +572,7 @@ int luo_session_create(const char *name, struct file **filep)
 err_remove:
 	luo_session_remove(&luo_session_global.outgoing, session);
 err_free:
-	luo_session_free(session);
+	luo_session_put(session);
 
 	return err;
 }
@@ -418,6 +587,7 @@ int luo_session_retrieve(const char *name, struct file **filep)
 	scoped_guard(rwsem_read, &sh->rwsem) {
 		list_for_each_entry(it, &sh->list, list) {
 			if (!strncmp(it->name, name, sizeof(it->name))) {
+				luo_session_get(it);
 				session = it;
 				break;
 			}
@@ -428,12 +598,14 @@ int luo_session_retrieve(const char *name, struct file **filep)
 		return -ENOENT;
 
 	guard(mutex)(&session->mutex);
-	if (session->retrieved)
-		return -EINVAL;
+	if (session->state != LUO_SESSION_INCOMING)
+		err = -EINVAL;
+	else
+		err = luo_session_getfile(session, filep);
 
-	err = luo_session_getfile(session, filep);
 	if (!err)
-		session->retrieved = true;
+		session->state = LUO_SESSION_RETRIEVED;
+	luo_session_put(session);
 
 	return err;
 }
@@ -548,6 +720,7 @@ int luo_session_deserialize(void)
 				sh->ser[i].name, session);
 			return PTR_ERR(session);
 		}
+		session->state = LUO_SESSION_INCOMING;
 
 		err = luo_session_insert(sh, session);
 		if (err) {
@@ -578,6 +751,17 @@ int luo_session_serialize(void)
 	int err;
 
 	guard(rwsem_write)(&sh->rwsem);
+	if (READ_ONCE(sh->rebooting))
+		return -EBUSY;
+
+	while (atomic_read(&sh->closing)) {
+		up_write(&sh->rwsem);
+		wait_event(sh->reboot_waitq, !atomic_read(&sh->closing));
+		down_write(&sh->rwsem);
+		if (READ_ONCE(sh->rebooting))
+			return -EBUSY;
+	}
+	WRITE_ONCE(sh->rebooting, true);
 	list_for_each_entry(session, &sh->list, list) {
 		err = luo_session_freeze_one(session, &sh->ser[i]);
 		if (err)
@@ -595,8 +779,11 @@ int luo_session_serialize(void)
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
@@ -624,7 +811,8 @@ bool luo_session_quiesce(void)
 	down_write(&luo_session_global.outgoing.rwsem);
 
 	if (luo_session_global.incoming.count ||
-	    luo_session_global.outgoing.count) {
+	    luo_session_global.outgoing.count ||
+	    atomic_read(&luo_session_global.outgoing.closing)) {
 		up_write(&luo_session_global.outgoing.rwsem);
 		up_write(&luo_session_global.incoming.rwsem);
 		return false;
-- 
2.53.0


