Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3B2AF531C4
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 18:51:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CF576B0095; Mon, 13 Apr 2026 14:51:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 231B16B00A1; Mon, 13 Apr 2026 14:51:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDBB16B00A2; Mon, 13 Apr 2026 14:51:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DC9246B0095
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:51:40 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 848771B6C81
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:51:40 +0000 (UTC)
X-FDA: 84654426360.21.24E6543
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf14.hostedemail.com (Postfix) with ESMTP id B64B6100010
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:51:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Aidiyzmd;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776106298; a=rsa-sha256;
	cv=none;
	b=EoREMq3K93AH/2Eif9ZImt9/vNVwCNnL8Td4FZkGrLjalmCvmWP5elWJoOW1el822ZSSrJ
	EjTxBeYS6scHDXF4NwuSgFksYlRflEEyjUAwVgxphLiMOc5LNqLtgT+oDxGQ5vYLrf4aHy
	YZmTIri/MRyfZlyXGq4Es4ugRJW2SEs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776106298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lyOXH7squnkI7rGYP2+HAwesaXX15Xy0bHRGyfpZyGU=;
	b=3RbAM4do3y49wPD63fEGxBRHdAWVrZ6I4df4G8Y0gWCNm66xvOm4UwVAHl5s7GUG9yJxeX
	zJ8NGXyhIxeajwxF48OGQjEFZRTiRrteKkKsndAqm89EjJej0ordSidqpTTInK/hAF5ksh
	w51bzQvu0A0X0Gqljw3r0kH4VJ+miYg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Aidiyzmd;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8c70b5594f4so467316585a.1
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776106298; x=1776711098; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lyOXH7squnkI7rGYP2+HAwesaXX15Xy0bHRGyfpZyGU=;
        b=AidiyzmdB/ouWeg+XmFcAXHlipFS0/bysSWgIKnjMy4aRJAzDmCtb5xWrRWwMM1W6P
         ZP1X6T7DRdCK+kmQg0icmSqjcbgQPUYT66J3R3U+XHOumLBId4ant/MrXDNKV0YrP3PE
         kFEApqlrU4K5xzv9xczXoY+hfK8PlXv+R/+dpzhR3dKI1xSyd1fVmTdZR/PbRV4xXpUM
         QizXoLl0eUt+xmhe0ZXKiBB5Lv5ECc5aLIs5zeuZOi6SdYZA+0ExIcXvMd5HYbzbgekV
         hqXpqTtlbcfPyss+E9rQIeRU4oulod0HEXIkCKYtrc0McWUDh5Q4u6jKzRLlES7M4XNG
         uZSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776106298; x=1776711098;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lyOXH7squnkI7rGYP2+HAwesaXX15Xy0bHRGyfpZyGU=;
        b=W/a79Be+HpRx720XV7goSBdW0D3oVtS4LHB1L9iXPNUTUaO4swl5SQWKjBkmI7smN7
         NOqQY94d+Kf4QjJHuRPNjWgTCdFaFJtIagbdSLvlTs1qumnvj0t/+YWBi7KrHyXWTwc5
         IjHio5LjLBHMyVaV5FHcJwrB+e/ixTNU5Rmfr2p/+MiPL7DZiUcxLF8KBarwAbtrAML9
         rCCOPm/eEzWPWgFBo2ww8XUA8G+eDFeeUrweMZGR7QLYueVjL916xM+hRe9Sw85BtYDg
         N0l9cg9st0EwxaSye38BI8L04Ju5dJyjC78deX5A5nm3QQ7Gc53SQXp3cD8yLkwjbqCq
         bBXg==
X-Forwarded-Encrypted: i=1; AFNElJ9dPzINRbtP1xb96pFZ10pU/1ioV++wWZofDX2V9Us+8cq9/Fmh6K/yVH+FndSWvHTDdIHdy1N4Zg==@kvack.org
X-Gm-Message-State: AOJu0YzckH+nn3Qyl762UW7RuCttqhPggOgyXuuom4O7s9drRMEErQSg
	c3N3SnpE3kWEAnkrx1vtOIPT33bQVAx1pv5Kggc6mp4mQyOQGNTOFjh6AsIHtURmCTd/Kvhsu9l
	maQFs
X-Gm-Gg: AeBDievibeb8tfQb42sEGVBj12RbrfZFyLrwDzPORrHxYL+6X7i/s3E+cchkI0HLaqm
	NIDju/fPCoEYlLpZmq1g9RwsVgIGmQlBZlLkL+rCX6bliu+Si8w39++YEUMvMwe8ywRwgknzkXq
	K/uoGjWiYxzLph0F0T68zneF7BxRC4BIo52W3VuzgQzW/sh6Owu7rXTzeEFSS69s77kd8MnnTQf
	kjoEby/U8RwDn1S9LBn5mFFxyrZTs8c47MXtsCEiC6LWq0MX2PU6bJBI0cDKqNTqmkqKaONQp0v
	axIxC7iKq88YsWxME01W5BGjdI0bmsu1SjCk8bachfp7X0AcHeZ1N8r14gOINC4tqzjCi4MEVMo
	uOUBYfOgQdHF2keSQTSadTj2q/JDJoTZ+Zc0cHJtP/oNQeYotWm+UbbBhWBKML3Z1R0iSXsXGGA
	SdiK3hmUTtauqhVoc/cFSSM5Gyp82HTTrDfRBPsO3tV9YQ6C+QJrAX+2R9VEfkpV2Xxw==
X-Received: by 2002:a05:620a:2547:b0:8d8:697:1cf2 with SMTP id af79cd13be357-8dc467daa79mr2353546685a.30.1776106297609;
        Mon, 13 Apr 2026 11:51:37 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ddb6372790sm943206285a.12.2026.04.13.11.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 11:51:37 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org,
	skhawaja@google.com
Subject: [PATCH v4 06/11] liveupdate: Remove luo_session_quiesce()
Date: Mon, 13 Apr 2026 18:51:22 +0000
Message-ID: <20260413185127.128180-7-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260413185127.128180-1-pasha.tatashin@soleen.com>
References: <20260413185127.128180-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B64B6100010
X-Stat-Signature: eiebziwhx5zm1dxrou8dpqgrukpqfkw1
X-HE-Tag: 1776106298-521295
X-HE-Meta: U2FsdGVkX19OwSiFkKILSrYTtTjxx3FmXx5RTbVww9jDc3wQTQY1PR5pQiwf1EodpTYBbJVT2fZdkIqA7Y72WBeswq4hlpmbRUlMbYxakBBlpniNGuUEek5pXLYyugYSwTzQsHJ9fFL6vYZKqm+kbg9dYElVM4Y7hUdi57BUJCGcTQUB5G2+0q1IJZa3J9YyF/dAyocccRMct0K3vG+JA4UTxjGbQP6zuQ+9zOLkF7jBymi9l8ttlq2LTeaQk7zSCDHDUXNDAve99OFE33Uq0RXBHqnrACqK28PdtUcIq3IualmhlJKHlN2k4hWAaD5VE8SBCBJamOv8Z9qpiWVex8bC+nTgwslweEbT0qbvzCPQYC/69pFocHUsaY0IJdfszXXidGLBLo3zRHux7gxqeB1GxBRSsDv9cv1fzglMzfQTCZ+ecpwiDrYXqoCuvngRBijuAtlBnqJTBD6GOBcEsa7DAoXFAu3UAaWGm0QevgGFpADKCQl4h9amhJ9lvbSF2wie107vt6eRPb31bpXz2iLXigU1rX0uwtDC8YOq55WCxxDQuppX4C3B7Fwoy/M5iR58Yf382r2ov38bbDfH3+QTfEquVbkLdVc8HwL71Sa9ON+JfAa+1gGkO097Orl2pmId5ZGeCX0L60fxlpLfk5efsJw9+WsRpPBM5vqhP3zV8EHjTjPlRJYrqJkVl/SHy5FCa4R8KbGOWw+wHMDr7sV876+yys1qpIcb3u2UQT0P5MCIVt9bMSbu2jCBKizZAGqU9xFlOGx7oKhufEam2sC57SuROYeoj3Cb6QUHI49JaCXD6eR2+qOETkE9pKjKlKHxpNabyqTerZlKjNCsEUoGJfjtPrfWN/MOawsbTxvudy8sOHcNqn6sayTx3Jo9FbXiUOS4L6wEO1UtVH/yZM3wlVUOoB87ql0yb8fzgArdVbccOOVo7zCkTIB7y/laUDVNWbBxIEs2D1E5I+4
 I3xzBLO8
 kTirXPXzimszP5D6mcX1PhxqMEDXlNd1sSJsbIgPcE73niaeNGztzsQDM6W1MKNhmg5PQ3N1eype3ipQaKs8w6Qfqbdb16s/9jMB6R19tgSbDx/b94qi9/0tAQurfjw+aOMH0OkIlPz8IYIOVU9Jn/T+OvEqYSvPhh5AHmAVayl7l56nVJSIODXz9J6RK8hl7yFD7kVwJ3Mutcsb8jW54wyH3ZCDzPCIdrHu5nYWHXDAEK0N8hQMT+TClsRvnlTbRzi8Z6rWlTxJa0j5DpAsBVJOBkU60A/eAzVKGwS+x6Bwebv/gmPlq7v+XuiCQ8aFM0UVyPEXrAVtLlLSytdTM+kvROMQk4i7nfcZHPMGxh4dvwaqqKSwTBXVOkt0TvFGlMO0NqZNZaLFiQnc=
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
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/luo_file.c     | 21 +-----------
 kernel/liveupdate/luo_flb.c      | 59 ++++++--------------------------
 kernel/liveupdate/luo_internal.h |  2 --
 kernel/liveupdate/luo_session.c  | 43 -----------------------
 4 files changed, 11 insertions(+), 114 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index ecf780d74d80..63ddcf6dcddb 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -878,14 +878,6 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
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
@@ -908,15 +900,12 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
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
 
@@ -928,14 +917,12 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
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
@@ -946,9 +933,6 @@ int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 
 	liveupdate_test_unregister(fh);
 
-	if (!luo_session_quiesce())
-		goto err_register;
-
 	down_write(&luo_register_rwlock);
 	if (!list_empty(&ACCESS_PRIVATE(fh, flb_list)))
 		goto err_unlock;
@@ -957,14 +941,11 @@ int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
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
index 3d439d1c8ff1..13f96d11ecc9 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -348,7 +348,6 @@ int liveupdate_register_flb(struct liveupdate_file_handler *fh,
 	struct luo_flb_link *link __free(kfree) = NULL;
 	struct liveupdate_flb *gflb;
 	struct luo_flb_link *iter;
-	int err;
 
 	if (!liveupdate_enabled())
 		return -EOPNOTSUPP;
@@ -369,21 +368,12 @@ int liveupdate_register_flb(struct liveupdate_file_handler *fh,
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
@@ -391,20 +381,16 @@ int liveupdate_register_flb(struct liveupdate_file_handler *fh,
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
@@ -415,15 +401,8 @@ int liveupdate_register_flb(struct liveupdate_file_handler *fh,
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
@@ -439,12 +418,9 @@ int liveupdate_register_flb(struct liveupdate_file_handler *fh,
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
@@ -458,14 +434,7 @@ int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
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
@@ -478,7 +447,7 @@ int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
 	}
 
 	if (err)
-		goto err_resume;
+		return err;
 
 	private->users--;
 	/*
@@ -490,15 +459,7 @@ int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
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


