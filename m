Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1220AFB5EA4
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 02:51:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AFEE6B0092; Mon, 16 Mar 2026 22:51:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 061E06B0093; Mon, 16 Mar 2026 22:51:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE09D6B0095; Mon, 16 Mar 2026 22:51:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DC8076B0092
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 22:51:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 96DFEB92E2
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 02:51:02 +0000 (UTC)
X-FDA: 84554027964.20.6D9927A
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf09.hostedemail.com (Postfix) with ESMTP id ADF3A140002
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 02:51:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=X7TcYgwm;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773715860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DDyewP1AZHpe5wDxr4egwn4qSBkMsagV6JEmGWYwO1o=;
	b=OxbcD2P/0OOi2GLZdK9JcNGyQIksAUKAYjB5iNuoBY5QDTAPWV0ZoYzeYQwLKJbUI9wqBc
	YzupFPzDCBK5DmYfsXxl+GsNG75+/qNozQPbUvE77dfACu60UUuFFZPpNTnAR6qeJENTtp
	y6eL1WkHYhnRO1RA43AdHc8qX+TJYTU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773715860; a=rsa-sha256;
	cv=none;
	b=fMqPEcgw/qrc/cuWUchFlsmjQhrn7ll2LbDr2dFsRXUslUnQaSJk5FIUO9BEmmOJr5Y0Gd
	mfnGwVb4fN7XRAO3HHT5eIpnz5XS6L5V6wJ2Whi19LhVNi7C5vxwxH/nRFNEAdZ8Uq2SJs
	xO/xzy/5PkKAxSeCObkIqffXxDoLybo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=X7TcYgwm;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-79a5ad7cc52so12466577b3.2
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1773715860; x=1774320660; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DDyewP1AZHpe5wDxr4egwn4qSBkMsagV6JEmGWYwO1o=;
        b=X7TcYgwm9wmRieJWrqFT9dORSOwOQKcL202Bx52f1sFvSv3qN0/Yy2giQzBsaR35dM
         Qn/3NDpTVG3LKJHYEbFMe5uSCsGM+C3ISi1fTvM5+dgdZzoDflRnd8yhirmqgOOYEvrQ
         NDS5qU8YnRUpEzx5YaOrxXYDQCxh9BSGptEPw3LZGdQxsGV4xk/322aJHQySjwFVvR3b
         xtTdi2hBK9tssjPn03GysRiv4ZEnMiuW9HgHjkJSQ9LP98yznZZM8hbNSWG59IO86+Mn
         WHduMlTjJ5xlHYH7O8M9aI70jr5jmlPZinEr2dsQZJwONj2aYneXS5cs281GuaBUvkYH
         iGFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773715860; x=1774320660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DDyewP1AZHpe5wDxr4egwn4qSBkMsagV6JEmGWYwO1o=;
        b=e1CXdXZ+SL3s5AYKCaVQ1yKhEw527MRTzh3qsU2QWdMDSq5iOXBUB71oKq3QyzGwFz
         y6IfEKxUnl0ekQgXhQRelaSz0tsIAwT5Ou1VeNAI3zvAG/vcQdmRZOF/wrXKbsgK9yl6
         bKKnBRoXV1V+iBujroTL1Ho+ohEeG0wweCprQgyDudJmKDruvc189IwDJvCcGXeDYPNI
         TbFvUCOCbli/+7YWfjonAVqEbPWM0JdbNph5l3ujryHdW6F2wWxTaPQ8QrPnjBpWDu/L
         6XApiHpOBJJp4HjHdQjiY/pVwRw6KsvwT1wlVXA2zf/iYCzJ+1tdTqb5A88RwAUF31KU
         M4cQ==
X-Forwarded-Encrypted: i=1; AJvYcCXISgedG440MD6wMgakU/53xUlNRQ3IhXrDtqBMtN0XlmaFM5HcHarwpElp2xIUTt58f/kY92AvMQ==@kvack.org
X-Gm-Message-State: AOJu0Yx/K5H1wKkDZesG9yd8mLJvnEcpvGK942NanwWuWP8aZ3DR+u1a
	elRPHHlTZ7KY1LvC4rTCZpwE8HyHiEBfWfY34LgOLmCawixmCwbmUU6u41L3f3pPOgA=
X-Gm-Gg: ATEYQzylTPd+QXcyI6kizxXJr+/KPWBxJbxH/sRcn4x/wW7nXKo2AiVqbhjZQujGAJx
	y6emPu4U5oC6iovdw/THFD+CtVQE69E9H59I5/nc3W0vykk5lR5kU4ywj98gpmune6tz5JQ4MG+
	GEuJmYA8U03/gPu+JStzUOptTFKnC5V1X2t9A+OXAuDkem3T3Fu9Pnq1bcve8ATaSvsHtzKQVhR
	5O+jJ5Wk1qigz3/3FujUZbaTZyv7nsiRs7+gageCEPmMY2fzFC2yv2rXMwuCKhehpBbX1oTmy2O
	FTzTV1gd9iYo4xYi9bn2ovmcOu0sbhAMjFzu3TCBpWCVE2ZNMYa1OwYqkeHG8J7iE605BczWi4h
	R5w6qRTACW7Q5OKlC4SjS4sW3b7dZw4gEJR6mNoylDHWC6fePdBpP0OXFQq7fMH4iZT9DNBLK5b
	JJRvWEfVhSSUOR9jlPsls2e0ibtoLaGr7r8hgg/tZO8DerBvFWghi+B6t6SrzD8qs0iSbfkjilN
	OKBNQj4naujNWeTD7aVA/x03QrgWkEf3wNFfoYQO5NdraRaIQ==
X-Received: by 2002:a05:690c:6d10:b0:797:d386:44c9 with SMTP id 00721157ae682-79a1c17b181mr153296457b3.32.1773715859783;
        Mon, 16 Mar 2026 19:50:59 -0700 (PDT)
Received: from soleen.c.googlers.com.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79a5a866c85sm14951757b3.35.2026.03.16.19.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 19:50:58 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pasha.tatashin@soleen.com,
	rppt@kernel.org,
	pratyush@kernel.org,
	linux-kernel@vger.kernel.org,
	dmatlack@google.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Subject: [PATCH 5/6] liveupdate: Make unregister functions return void
Date: Mon, 16 Mar 2026 22:50:48 -0400
Message-ID: <20260317025049.494931-6-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
In-Reply-To: <20260317025049.494931-1-pasha.tatashin@soleen.com>
References: <20260317025049.494931-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 785t177pgdu7q6bzmg3r7h9oxxauk9rn
X-Rspamd-Queue-Id: ADF3A140002
X-Rspamd-Server: rspam03
X-HE-Tag: 1773715860-793921
X-HE-Meta: U2FsdGVkX1/3NHJeA9Saq8vS3EUykeJdUGwzM/sqn/JsQEdEeUkc3NsVYBTbmQkfI27ZwtYNJFnln1nFaRWjEV+L+xdPZBg8m0ebVgsPcAsl95Z5sc7UZGfJ04inmy3KIOTHnJcggonsT3v+GxVsFWNFlzjKPnAHXfD1tB8FrwxYM7B8e3Upm3NJXqWFoCclHY4a+T+QVS4myKir2G0b41/qeoAPHWLghU0TYBg0RGBqVng1jlE9g13qMYyOg/WdVdcE0YlrG04GrvnOALr8UGxfhJeEPnxVQJBtF2lQ/X+ku8PMdvSz8N/e8FLseGbzSrgdCc+lZPTRG/jzJHPeWKfC6IM/NdPvHVY8XlVUmnYwXSRCW2Y9lsHeTjnBen1oF7EaNxhghFvKEOYafCQtCIH1dUU/G0p8cbJEjGTjhYBPM8tqABtEMsBydx0S51GJOFKid+pbiVWrQ2IoDUulOEy88Kksp78oGGd4YjknQGva/4kLuwRcHIjwp0kDJ3UWwbOMBc5VZrugfDq52wRLpNp9nRWRcdoE6Ef937rhVPhiI5x/MnAlOpgyq3Ureq5Zb1Yn6F3U6O1unZQpFlfrIZosxNjMaayMiAwMZTxtYegIXJcprx1FS5XwNX/MVb0fo8mwWQ85PU6EjCPt6uxW2Odekps1WXt2brMKUNqT4F5/qT0VaYJUKdu49IIfY7hKgxKY8brVEikMXlonW5i8ycVa693RJu9rGynUa/fUcPOUjlQWkYf0+yYS7LZX52M6SqmtC0p2+1qrojfXDJZqkE23N9AZ2p6AkHxXMNBx/EGtiEINId512sS4VUMOVP+n6bZV/zGPOE9DCgD/odlzX8KwOSrVSxnEqqr9DVU2piDBryAVzq2GKmcPBl7w0VQkQNSxMUMuiYalDXZHiLke926I8Ti1PU5Auhs3p2qcOQGnkXx3pFUiah37j8lTq/J2Ebj5XwEcMVuQ8de80ea
 C65vty1F
 3YqW+bLLW93iLqYoPIejHfetflSlY5Tn47RHivdq2cMp4J2bL8/NeOij6nUsh9I4n43GUReV60ncK66YFqRy/YRijnQQnabv++ascSyGbYJGY+9kAZPLTIIsTZ4TosXCObKdfXJX5bYp6Q6+m5O+/hoRJ/Sc6KsV6lo8R1IWN5d0lApTWEbg/hj+FUZ4AXOPD6fcdeOBjNvKznLT3eKkvvY9vb6UAxbV/zXIAd6hVU7guTAM/ZWHl5W1KhLZFUOniodBS1roiz/rN/VeJeJoswiCe0i7YjXVqHyhRsW9ztVZPZ9yrMNHNTIUd4lwUeYgEFR21W3A4cbP/OaQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Change liveupdate_unregister_file_handler and liveupdate_unregister_flb
to return void instead of an error code. If they fail to unregister
due to dangling references, print a warning instead of aborting.

As pointed out by Jason Gunthorpe and Alex Williamson, returning an error
from a "destroy" or unregister function during a module unload is a poor
API choice since the unload cannot be stopped at that point.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/liveupdate.h   | 13 ++++++------
 kernel/liveupdate/luo_file.c | 27 +++++++++++-------------
 kernel/liveupdate/luo_flb.c  | 40 ++++++++++--------------------------
 lib/tests/liveupdate.c       |  8 ++------
 4 files changed, 31 insertions(+), 57 deletions(-)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index 8394fb2d8774..293df26b9e7f 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -231,12 +231,12 @@ bool liveupdate_enabled(void);
 int liveupdate_reboot(void);
 
 int liveupdate_register_file_handler(struct liveupdate_file_handler *fh);
-int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh);
+void liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh);
 
 int liveupdate_register_flb(struct liveupdate_file_handler *fh,
 			    struct liveupdate_flb *flb);
-int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
-			      struct liveupdate_flb *flb);
+void liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
+			       struct liveupdate_flb *flb);
 
 int liveupdate_flb_get_incoming(struct liveupdate_flb *flb, void **objp);
 int liveupdate_flb_get_outgoing(struct liveupdate_flb *flb, void **objp);
@@ -258,9 +258,8 @@ static inline int liveupdate_register_file_handler(struct liveupdate_file_handle
 	return -EOPNOTSUPP;
 }
 
-static inline int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
+static inline void liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 {
-	return -EOPNOTSUPP;
 }
 
 static inline int liveupdate_register_flb(struct liveupdate_file_handler *fh,
@@ -269,8 +268,8 @@ static inline int liveupdate_register_flb(struct liveupdate_file_handler *fh,
 	return -EOPNOTSUPP;
 }
 
-static inline int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
-					    struct liveupdate_flb *flb)
+static inline void liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
+					     struct liveupdate_flb *flb)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 6b2b49cb375e..0fe2f8be8bd1 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -907,21 +907,17 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
  * reverses the operations of liveupdate_register_file_handler().
  *
  * It ensures safe removal by checking that:
- * No live update session is currently in progress.
  * No FLB registered with this file handler.
  *
  * If the unregistration fails, the internal test state is reverted.
  *
- * Return: 0 Success. -EOPNOTSUPP when live update is not enabled. -EBUSY A live
- * update is in progress, can't quiesce live update or FLB is registred with
- * this file handler.
  */
-int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
+void liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 {
-	int err = -EBUSY;
+	bool is_empty;
 
 	if (!liveupdate_enabled())
-		return -EOPNOTSUPP;
+		return;
 
 	liveupdate_test_unregister(fh);
 
@@ -929,18 +925,19 @@ int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 		goto err_register;
 
 	scoped_guard(rwsem_write, &luo_file_handler_lock) {
-		if (!list_empty(&ACCESS_PRIVATE(fh, flb_list)))
-			goto err_resume;
-
-		list_del(&ACCESS_PRIVATE(fh, list));
+		is_empty = list_empty(&ACCESS_PRIVATE(fh, flb_list));
+		if (is_empty)
+			list_del(&ACCESS_PRIVATE(fh, list));
 	}
 	luo_session_resume();
 
-	return 0;
+	if (!is_empty) {
+		pr_warn("Failed to unregister file handler '%s': FLB list not empty\n",
+			fh->compatible);
+		liveupdate_test_register(fh);
+	}
+	return;
 
-err_resume:
-	luo_session_resume();
 err_register:
 	liveupdate_test_register(fh);
-	return err;
 }
diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index daa852abdedd..23fa6e0c6083 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -436,31 +436,17 @@ int liveupdate_register_flb(struct liveupdate_file_handler *fh,
  * the FLB is removed from the global registry and the reference to its
  * owner module (acquired during registration) is released.
  *
- * Context: This function ensures the session is quiesced (no active FDs
- *          being created) during the update. It is typically called from a
- *          subsystem's module exit function.
- * Return: 0 on success.
- *         -EOPNOTSUPP if live update is disabled.
- *         -EBUSY if the live update session is active and cannot be quiesced.
- *         -ENOENT if the FLB was not found in the file handler's list.
  */
-int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
-			      struct liveupdate_flb *flb)
+void liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
+			       struct liveupdate_flb *flb)
 {
 	struct luo_flb_private *private = luo_flb_get_private(flb);
 	struct list_head *flb_list = &ACCESS_PRIVATE(fh, flb_list);
 	struct luo_flb_link *iter;
-	int err = -ENOENT;
+	bool found = false;
 
 	if (!liveupdate_enabled())
-		return -EOPNOTSUPP;
-
-	/*
-	 * Ensure the system is quiescent (no active sessions).
-	 * This acts as a global lock for unregistration.
-	 */
-	if (!luo_session_quiesce())
-		return -EBUSY;
+		return;
 
 	guard(rwsem_write)(&luo_flb_lock);
 	guard(rwsem_write)(&ACCESS_PRIVATE(fh, flb_lock));
@@ -470,15 +456,19 @@ int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
 		if (iter->flb == flb) {
 			list_del(&iter->list);
 			kfree(iter);
-			err = 0;
+			found = true;
 			break;
 		}
 	}
 
-	if (err)
-		goto err_resume;
+	if (!found) {
+		pr_warn("Failed to unregister FLB '%s': not found in file handler '%s'\n",
+			flb->compatible, fh->compatible);
+		return;
+	}
 
 	private->users--;
+
 	/*
 	 * If this is the last file-handler with which we are registred, remove
 	 * from the global list, and relese module reference.
@@ -487,14 +477,6 @@ int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
 		list_del_init(&private->list);
 		luo_flb_global.count--;
 	}
-
-	luo_session_resume();
-
-	return 0;
-
-err_resume:
-	luo_session_resume();
-	return err;
 }
 
 /**
diff --git a/lib/tests/liveupdate.c b/lib/tests/liveupdate.c
index 496d6ef91a30..5b6abf779f87 100644
--- a/lib/tests/liveupdate.c
+++ b/lib/tests/liveupdate.c
@@ -137,16 +137,12 @@ void liveupdate_test_register(struct liveupdate_file_handler *fh)
 
 void liveupdate_test_unregister(struct liveupdate_file_handler *fh)
 {
-	int err, i;
+	int i;
 
 	for (i = 0; i < TEST_NFLBS; i++) {
 		struct liveupdate_flb *flb = &test_flbs[i];
 
-		err = liveupdate_unregister_flb(fh, flb);
-		if (err) {
-			pr_err("Failed to unregister %s %pe\n",
-			       flb->compatible, ERR_PTR(err));
-		}
+		liveupdate_unregister_flb(fh, flb);
 	}
 
 	pr_info("Unregistered %d FLBs from file handler: [%s]\n",
-- 
2.53.0.851.ga537e3e6e9-goog


