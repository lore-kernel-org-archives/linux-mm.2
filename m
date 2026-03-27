Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F1D710BA422
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 03:33:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04D086B00A5; Thu, 26 Mar 2026 23:33:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF0E06B00A6; Thu, 26 Mar 2026 23:33:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6CEA6B00A8; Thu, 26 Mar 2026 23:33:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C096D6B00A5
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:33:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 938191B9349
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:33:45 +0000 (UTC)
X-FDA: 84590423610.20.7931455
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf28.hostedemail.com (Postfix) with ESMTP id EF4E3C0005
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:33:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=a9jFN3mV;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774582424; a=rsa-sha256;
	cv=none;
	b=UcOOwWVcCf4JsA7YKPymWldAG4mSsOr5golS0ENuVQrM184xIvA5AvP23qnENen+mpdzhQ
	0aY6R5kmVWOzId6DWwVeKts3t1aAJyOuOoNVl1FGu3VTlRPxn9df9AxSLgSErSPDDbJ7i/
	s05Bd0C41xRgZRyqV+6ujegFoYj5Tj0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774582424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mszalggt3dPTMibHtCmbJKEiDYjehfwuxFzG9yJXx/o=;
	b=LtM+jiPGZEp3U2oYvzeKqQko5R8ivMFmQt1fTfgALBhHFBImnm3m6Q8yy2v/g9lXvaI8+U
	N+YFvC7JMqfNDMkreMfJKSnHmLQIs74DRSGkYzTKgOi5jyJI/VNvCugmVrBBlsnyeFdxu6
	XJGVTgck1q/JvKIzmwoVUBz5++iAYbg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=a9jFN3mV;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-899a5db525cso13227416d6.3
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774582423; x=1775187223; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mszalggt3dPTMibHtCmbJKEiDYjehfwuxFzG9yJXx/o=;
        b=a9jFN3mVSR7BBDAGjDnZSxwF6cv0Nw4SCrb3c9zJTBMTKff3jyB3/ZqaSoXZyYtX23
         3AXLdqo2oIaaj0IaaQg6eSD8TDb1n9kAOxFw1fzXe/dhqehbUm5FuTm/s+EAKQUy8aFZ
         e5EY1I/EWcEzxOFF816Coycgg4ayVP5PD0Cp4MOgnzFOG1ZiynYJTsgwRJ1YM9mqqdUL
         maQpkBm4qc1znCQ5R1/Qh8JD+RtL5fRjLqTdxGec5JOoNcMhuPTQkc+zLEbKbPj0eCYo
         tl3nvU73M+KIbi6mnKcKfn4xbs/F9PTA2kQLe4i5j+/8GrGEr9VXUKQOJ1rvVMkqi1MQ
         lF5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774582423; x=1775187223;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Mszalggt3dPTMibHtCmbJKEiDYjehfwuxFzG9yJXx/o=;
        b=EqA1g/M+TQwDIN7VGAXHIwGXQypA7oad3wxg2Rywo35LK0W8jGrNkqQyHzXjvp2Anw
         UjfXBIIHUoymGdZD9NOZOHD/kN+rUh6nJ5U/L09U9J3+E9FZoHqx+GkOOR917fi821rt
         ddSwp/xH/CB/gEzf9uj1vVdJnGV8NDX91tzGywt0n+rdqrb6XcaN0fiOseLsOwaSzZFB
         FFtZn/OOtL8bsNEEkAEMqX6D5M18TrpYqMhKF3tRYPRNKa/slWviZDz46pRyrDCXkj06
         TusMxyqhzbautUWrAg3MOg3nj3YbEZ1RiXuDrBXG6TnAVxaUgMVkIrBAr+nJ6zNmUMZ/
         Fd9w==
X-Forwarded-Encrypted: i=1; AJvYcCUd7y2whqyaDRgXGnQuRuWBzryd0MOZacUnLI7vOwEoLGowrWXIYftis+OhbDzBkscSjrzyg5kQwg==@kvack.org
X-Gm-Message-State: AOJu0YxlFdH1R1gDfil9Yd7YT62CrimOKcQvZtGynOo8JHp+vhazefRe
	UHhJzIjVOfaU8r5aSjM/Xn4yyh9W/+IoPxb+18LNK1tNp5xBU46N16sk6PxneqoD4a1RBN2KLau
	NyZbC
X-Gm-Gg: ATEYQzykFExTEY1uueuhYS2NacHQYoZrbChJhRoJnjLXAzznkaBzZ3vdvG3UKBJCvrg
	o2OkuoX1hiDMomi4CeY/z+d0edVG281ZmLIRftseRAE9wP9h36EqvVUb62U3Ip1/X5fYl5V1sDw
	yESuyeGlwFuwCYgdiKISKxxYmE4J+FlBAdM+z1vEpeTE16QsLvYNj+YzSGauJLHEfgt0r3DDBE3
	OFEMAxaFvcWg1UyTcxRcsVVn2g2rCcgFgnEKYIujUaPxJhVwOst9VUxGK9Cm98aTUgWaRSHhQ71
	I/AxHXVbD2k0RFuXc7iAW+KQpluR5UnVgUFdkq4QOvylFxqeVudSm9OrW6TclrV3JFgBNNcDvpK
	JdeZ0uu5+IFPkuKeG2HuBhVXcIwMgUPojOlChsAUc2/Jno3a4gJbSh8h1iuSAP3A1T/TtxyQSsr
	oDzViTGS1uDqWRMkDjKG30SoUeKvsaY4FwG2vIO8G/4sWhyFREPccLqKZnNmPqV9TCBw==
X-Received: by 2002:ad4:5c8b:0:b0:89c:55b1:c8dc with SMTP id 6a1803df08f44-89ce8d8a990mr11018426d6.21.1774582423081;
        Thu, 26 Mar 2026 20:33:43 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89cd5a22711sm46519186d6.27.2026.03.26.20.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 20:33:42 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org,
	skhawaja@google.com
Subject: [PATCH v3 06/10] liveupdate: Remove luo_session_quiesce()
Date: Fri, 27 Mar 2026 03:33:30 +0000
Message-ID: <20260327033335.696621-7-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260327033335.696621-1-pasha.tatashin@soleen.com>
References: <20260327033335.696621-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EF4E3C0005
X-Stat-Signature: w6zbrm1e6rwbo4jftja343fnuwkpdm1d
X-HE-Tag: 1774582423-759435
X-HE-Meta: U2FsdGVkX19XnEBkJ/cd/bWE51G8EQGHH6KygQlH6CS6guUMH5sPXVsZs9ELtpG/t9p3DaTth+27TGsDU8wyE+/hAl18aFy6EnHdIthiHCKl6j7G687Js6zg/WB9mizp/g7URj0ma0V5IZ8brybDHSbo7UpUH1mpHzvx+l4xBN3hVG8QRPhHtLXyqjq0SWseyG+V1Pxz4Og+ZcJjyAu3yEt8u1JPnXFl9xlc4wD5oAsYbFgYOzr5pacmFaEvjmwC1FxtBSrJVeNaMUC7DqaLD5FmnbYt6OiUTOhzqCNLUu0v6Wfyp5D6tUIIvudD3QtJFWhu4aWJKQsPt2CDpBijod1q4SAw1jspA9bzWcrS3wOlYsn3Lzw+/iVY7k8jm08z5xPtaXQPFbjyYqC9dHFBw2GWY3BIHBFQnsewCi9a1v5BydQf8jGPUeCYlqCENgIzDcrG2Pkfdsv4otS7vKke8E/UGISiQifiT4M2mXNUpkiHDby3ryu8N1ZfhRw8KB48BgK5gy6rxIm92CaMo7YGbL0Lq/dayMnOSaDSBzWhQ8ZfsRurwleOVAcq/TfzsQm2mlS2ts+NQmkhM98YZ4LarNM6ZPUmVwHuG5uUYzXIPVuN4SJ+tOabNnVlBebTvcjMvKGw+uN6nooMYrQsdUVAXqHq5u4RDQorOJ/h0v970LMyQCXIxvRPwk9XGdNqPe8yfpCeC3x51NjyZT++9xnPW4iBUT/hbLS187m/udx7PopkaeJn5scWPpNB0y33zGoVJ1nj30TrxycJRAEUxUdxnTnPpOJ25rMrZtBBu7sAs4NGNM7rMiwlYFirVJsdKFUUyoxRuM0dwtN7CMYDXeq4HrIzaa8NqfBqgAKBraP/Y782oFH3f6ZP+y8Q5G/gWX8aSMCM6tob2KpdV2jw609mkPoY40P+zhK54/OpTLAPK4HBxo+UEYCZVI+2QpcE9hHtxW+SanXf4fIpqInNIOX
 bzEzZpPI
 HeA+792sNsu+KnTxycR2ejjxmOX+ZZyFjY+859+Zj6Wwjc9GelcjX3ffiJ6DFc/4xYu38
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that FLB module references are handled dynamically during active
sessions, we can safely remove the luo_session_quiesce() and
luo_session_resume() mechanism.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_file.c     | 21 +-----------
 kernel/liveupdate/luo_flb.c      | 59 ++++++--------------------------
 kernel/liveupdate/luo_internal.h |  2 --
 kernel/liveupdate/luo_session.c  | 43 -----------------------
 4 files changed, 11 insertions(+), 114 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 4aea17a94b4f..439177c10723 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -847,14 +847,6 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
 		return -EINVAL;
 	}
 
-	/*
-	 * Ensure the system is quiescent (no active sessions).
-	 * This prevents registering new handlers while sessions are active or
-	 * while deserialization is in progress.
-	 */
-	if (!luo_session_quiesce())
-		return -EBUSY;
-
 	down_write(&luo_register_rwlock);
 	/* Check for duplicate compatible strings */
 	list_private_for_each_entry(fh_iter, &luo_file_handler_list, list) {
@@ -877,15 +869,12 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
 	list_add_tail(&ACCESS_PRIVATE(fh, list), &luo_file_handler_list);
 	up_write(&luo_register_rwlock);
 
-	luo_session_resume();
-
 	liveupdate_test_register(fh);
 
 	return 0;
 
 err_unlock:
 	up_write(&luo_register_rwlock);
-	luo_session_resume();
 	return err;
 }
 
@@ -897,14 +886,12 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
  * reverses the operations of liveupdate_register_file_handler().
  *
  * It ensures safe removal by checking that:
- * No live update session is currently in progress.
  * No FLB registered with this file handler.
  *
  * If the unregistration fails, the internal test state is reverted.
  *
  * Return: 0 Success. -EOPNOTSUPP when live update is not enabled. -EBUSY A live
- * update is in progress, can't quiesce live update or FLB is registred with
- * this file handler.
+ * update is in progress, FLB is registred with this file handler.
  */
 int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 {
@@ -915,9 +902,6 @@ int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 
 	liveupdate_test_unregister(fh);
 
-	if (!luo_session_quiesce())
-		goto err_register;
-
 	down_write(&luo_register_rwlock);
 	if (!list_empty(&ACCESS_PRIVATE(fh, flb_list)))
 		goto err_unlock;
@@ -926,14 +910,11 @@ int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 	up_write(&luo_register_rwlock);
 
 	module_put(fh->ops->owner);
-	luo_session_resume();
 
 	return 0;
 
 err_unlock:
 	up_write(&luo_register_rwlock);
-	luo_session_resume();
-err_register:
 	liveupdate_test_register(fh);
 	return err;
 }
diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index ce28ce9b113e..ac6fa5b34b43 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -365,7 +365,6 @@ int liveupdate_register_flb(struct liveupdate_file_handler *fh,
 	struct luo_flb_link *link __free(kfree) = NULL;
 	struct liveupdate_flb *gflb;
 	struct luo_flb_link *iter;
-	int err;
 
 	if (!liveupdate_enabled())
 		return -EOPNOTSUPP;
@@ -386,21 +385,12 @@ int liveupdate_register_flb(struct liveupdate_file_handler *fh,
 	if (!link)
 		return -ENOMEM;
 
-	/*
-	 * Ensure the system is quiescent (no active sessions).
-	 * This acts as a global lock for registration: no other thread can
-	 * be in this section, and no sessions can be creating/using FDs.
-	 */
-	if (!luo_session_quiesce())
-		return -EBUSY;
-
-	down_write(&luo_register_rwlock);
+	guard(rwsem_write)(&luo_register_rwlock);
 
 	/* Check that this FLB is not already linked to this file handler */
-	err = -EEXIST;
 	list_for_each_entry(iter, flb_list, list) {
 		if (iter->flb == flb)
-			goto err_resume;
+			return -EEXIST;
 	}
 
 	/*
@@ -408,20 +398,16 @@ int liveupdate_register_flb(struct liveupdate_file_handler *fh,
 	 * is registered
 	 */
 	if (!private->users) {
-		if (WARN_ON(!list_empty(&private->list))) {
-			err = -EINVAL;
-			goto err_resume;
-		}
+		if (WARN_ON(!list_empty(&private->list)))
+			return -EINVAL;
 
-		if (luo_flb_global.count == LUO_FLB_MAX) {
-			err = -ENOSPC;
-			goto err_resume;
-		}
+		if (luo_flb_global.count == LUO_FLB_MAX)
+			return -ENOSPC;
 
 		/* Check that compatible string is unique in global list */
 		list_private_for_each_entry(gflb, &luo_flb_global.list, private.list) {
 			if (!strcmp(gflb->compatible, flb->compatible))
-				goto err_resume;
+				return -EEXIST;
 		}
 
 		list_add_tail(&private->list, &luo_flb_global.list);
@@ -432,15 +418,8 @@ int liveupdate_register_flb(struct liveupdate_file_handler *fh,
 	private->users++;
 	link->flb = flb;
 	list_add_tail(&no_free_ptr(link)->list, flb_list);
-	up_write(&luo_register_rwlock);
-	luo_session_resume();
 
 	return 0;
-
-err_resume:
-	up_write(&luo_register_rwlock);
-	luo_session_resume();
-	return err;
 }
 
 /**
@@ -456,12 +435,9 @@ int liveupdate_register_flb(struct liveupdate_file_handler *fh,
  * the FLB is removed from the global registry and the reference to its
  * owner module (acquired during registration) is released.
  *
- * Context: This function ensures the session is quiesced (no active FDs
- *          being created) during the update. It is typically called from a
- *          subsystem's module exit function.
+ * Context: It is typically called from a subsystem's module exit function.
  * Return: 0 on success.
  *         -EOPNOTSUPP if live update is disabled.
- *         -EBUSY if the live update session is active and cannot be quiesced.
  *         -ENOENT if the FLB was not found in the file handler's list.
  */
 int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
@@ -475,14 +451,7 @@ int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
 	if (!liveupdate_enabled())
 		return -EOPNOTSUPP;
 
-	/*
-	 * Ensure the system is quiescent (no active sessions).
-	 * This acts as a global lock for unregistration.
-	 */
-	if (!luo_session_quiesce())
-		return -EBUSY;
-
-	down_write(&luo_register_rwlock);
+	guard(rwsem_write)(&luo_register_rwlock);
 
 	/* Find and remove the link from the file handler's list */
 	list_for_each_entry(iter, flb_list, list) {
@@ -495,7 +464,7 @@ int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
 	}
 
 	if (err)
-		goto err_resume;
+		return err;
 
 	private->users--;
 	/*
@@ -507,15 +476,7 @@ int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
 		luo_flb_global.count--;
 	}
 
-	up_write(&luo_register_rwlock);
-	luo_session_resume();
-
 	return 0;
-
-err_resume:
-	up_write(&luo_register_rwlock);
-	luo_session_resume();
-	return err;
 }
 
 /**
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 4bfe00ac8866..40a011bdfa55 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -85,8 +85,6 @@ int __init luo_session_setup_outgoing(void *fdt);
 int __init luo_session_setup_incoming(void *fdt);
 int luo_session_serialize(void);
 int luo_session_deserialize(void);
-bool luo_session_quiesce(void);
-void luo_session_resume(void);
 
 int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd);
 void luo_file_unpreserve_files(struct luo_file_set *file_set);
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 8c76dece679b..a3327a28fc1f 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -607,46 +607,3 @@ int luo_session_serialize(void)
 	return err;
 }
 
-/**
- * luo_session_quiesce - Ensure no active sessions exist and lock session lists.
- *
- * Acquires exclusive write locks on both incoming and outgoing session lists.
- * It then validates no sessions exist in either list.
- *
- * This mechanism is used during file handler un/registration to ensure that no
- * sessions are currently using the handler, and no new sessions can be created
- * while un/registration is in progress.
- *
- * This prevents registering new handlers while sessions are active or
- * while deserialization is in progress.
- *
- * Return:
- * true  - System is quiescent (0 sessions) and locked.
- * false - Active sessions exist. The locks are released internally.
- */
-bool luo_session_quiesce(void)
-{
-	down_write(&luo_session_global.incoming.rwsem);
-	down_write(&luo_session_global.outgoing.rwsem);
-
-	if (luo_session_global.incoming.count ||
-	    luo_session_global.outgoing.count) {
-		up_write(&luo_session_global.outgoing.rwsem);
-		up_write(&luo_session_global.incoming.rwsem);
-		return false;
-	}
-
-	return true;
-}
-
-/**
- * luo_session_resume - Unlock session lists and resume normal activity.
- *
- * Releases the exclusive locks acquired by a successful call to
- * luo_session_quiesce().
- */
-void luo_session_resume(void)
-{
-	up_write(&luo_session_global.outgoing.rwsem);
-	up_write(&luo_session_global.incoming.rwsem);
-}
-- 
2.43.0


