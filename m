Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D07FFB5EA7
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 02:51:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E937C6B0093; Mon, 16 Mar 2026 22:51:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6B446B0095; Mon, 16 Mar 2026 22:51:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D59876B0096; Mon, 16 Mar 2026 22:51:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C0E356B0093
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 22:51:03 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7FD3913ACCB
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 02:51:03 +0000 (UTC)
X-FDA: 84554028006.03.8C4557E
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf05.hostedemail.com (Postfix) with ESMTP id AA5B1100012
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 02:51:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=al3hP99U;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773715861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sd93Vtcs6nWwoXw9KS21SuDl6vnDZo9LwpKtI+MCpyM=;
	b=nIg0b1DcV1XQ8FQMK+DWca//+M7G2YnV8oHcvGbPLgOFsYVhJYsMAOu/j7+OgBPiQVvV2S
	E7w6LZTgBM+z6yp4VeH2BLDeWmZAiuH2TupqNVUErA89L3y5OJMmSXpO/LU7Ib9A1XkpZb
	Zc4G2TEg7rAAHYhVxqvBThg62e3JdYg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773715861; a=rsa-sha256;
	cv=none;
	b=0S2DzVeA+VjP/nUkidhFcGO1Q/G2BmwSxoAC1rf9+PR0V3ahA9A0LkoFuHemvMqtnkJpw+
	3lwKtTgaiROH0DK/irT/ZGh0bsQIyLYOZ95QQkdI4xXNUlgoi6lQNPir6VHPBomCj7DuGj
	PoDltK1RTP6nfTKo/5jim7J8T8v+Cww=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=al3hP99U;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-64ca2b32f46so4041710d50.3
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1773715861; x=1774320661; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sd93Vtcs6nWwoXw9KS21SuDl6vnDZo9LwpKtI+MCpyM=;
        b=al3hP99U/P+nKONhrXA7LYBo5uYsfNO7sjuWwe1Zj8nwzJi2qpoCyfcT99Us5ASfpL
         B/CQpK5/Ut32YySzbTvD7m8mV/oHgMYob0NmZJllXe/b5QUU81m1YQIbnWNUozkgCBRK
         wN8JA2Ob0X6x2EDH4c4kqzawoskV7BXmdl1ava7pQ4spcxVAc7SbbKwA6wjrp2gq+Hyg
         KReS1Ylq+tSyowqphgk11uZJxhbyJXr+Slt2Rcd9Jyfj5m6CsruYljoUNliM1stS+VGx
         JnQNkZfE0Rfp09oFkHYzcBlBtkVkHV1yk0DkNGIpIL6+Y2ZXwAhCB3qPzJdkynzS9VWV
         Lbow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773715861; x=1774320661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sd93Vtcs6nWwoXw9KS21SuDl6vnDZo9LwpKtI+MCpyM=;
        b=UH4HyUVt0rQodhwsuKkSnj4Tlrbpaw+H17G+gAU3kaUpgOhldovueMAhJ6Pr3Vs97o
         0TKLlM12U9cwkbIAaiGWMqrHckrVFjwrI5bhh/5N1EdH5H5/ZH5JlIgXuKujcayLPglb
         CUJ97khrXO2Dv2GOwjzZHcwC8LUIUL5w98ax5b+Va6p+IBA9NFQSLL6Wux6qlFDri2pa
         ZKWKtNsoQHgKz5MfUOLj6/fSZQ32H8hw+D3f/eRZtycD3IQ5dTIJ2CX1JlbpC3X9M2TP
         Cp/gQftufH/l+z4wA32s1W2jpzCzGMPKRntTgBCG9yRKwMMC0C5tgdC/+iLdr5v3FRfq
         Tc6A==
X-Forwarded-Encrypted: i=1; AJvYcCW9TLYg7os6hVLxp25GEwLuWdK1VNlWOvk9Ei7ISuhU0QFT/S7bUGCi15y4PxU8EZ+wdzq6odSsWg==@kvack.org
X-Gm-Message-State: AOJu0YwApoHYw2rTsT5ge7FVfZMQsmiWRR6mwnfnvdWZyfGQMU5HO+wN
	6zzsJ94n38LPy617+KhBYFTdAm43u8nqkzZF85PdISs0z7Ur8uGN3lre73jwdEuP+/U=
X-Gm-Gg: ATEYQzwCwZ4vGL2futEmtMoOuJY/H61IDFiujq6pP7zWKczgioiaysdxgAnw6IGkUAS
	aQGU3hvSRbqjHQ+TbCiaufAbNFYPZCcg2YjHtFP46CNuG4qNIMKnYNFWnHLkcDJtwI3iELvchbD
	4NLbJh5q+LUv9GgYoADYJnZy4pCAy7Aqk+JjT+rCqqLzRt/zIkpwYGdGH9qrNR8bGUWXlk45p3F
	QDFdW5X4uxExH3uL9755ij0aqIW1uOsNX75M/9ext6rTTeZXYPF5kjajHKl2NzX+Zk64UNY1qmb
	drt3q63o85x9Ov6XcE+AF/m471mKpydrp5QCDe1oWAJ+ttgHCvgnrNejJ3wqYCzGIqfM5bUFrGQ
	SOQWDT3IGJPDShEuk+pIAp4QHv+5qpA/xgY0rVHhyK7urvXZSPej87a1V72AukYHmKeCeuhwPNu
	WrmekkKE327+f3FD0oC/CROn8Ys4KiUjUHBQNKfP8c3ON4zQFNnvLOtZGtdUc4McQHsp3NrBPoq
	ByT02UuWgtJNgfBAN4osmTX24hR1fGHpGvTwQHDQH8F3zwlEkmtBVjKNjHW
X-Received: by 2002:a05:690c:84:b0:799:3e:8239 with SMTP id 00721157ae682-79a1c071df6mr154381937b3.6.1773715860747;
        Mon, 16 Mar 2026 19:51:00 -0700 (PDT)
Received: from soleen.c.googlers.com.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79a5a866c85sm14951757b3.35.2026.03.16.19.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 19:51:00 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pasha.tatashin@soleen.com,
	rppt@kernel.org,
	pratyush@kernel.org,
	linux-kernel@vger.kernel.org,
	dmatlack@google.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Subject: [PATCH 6/6] liveupdate: Remove luo_session_quiesce()
Date: Mon, 16 Mar 2026 22:50:49 -0400
Message-ID: <20260317025049.494931-7-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
In-Reply-To: <20260317025049.494931-1-pasha.tatashin@soleen.com>
References: <20260317025049.494931-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AA5B1100012
X-Stat-Signature: p5tpiqmd8zwwqr59kqx1jwofdto337fb
X-HE-Tag: 1773715861-834502
X-HE-Meta: U2FsdGVkX1+W3R5zCshDvMbFYVCb7kFefnqQxROHV/N56F1X0O3qqSYugpmn+RTzwtFP8KF3Pwwki703IyKMobv4lDpdysBVWuNyGGnWfy0u0KtoH9A/UNjCLKjLgPPSSo3ixEQ62H88MNGo1jt0SBJhNysvW0Tf07itFjGtSa6pV+FcuamK7xC17BfZCO2FPDPcRzQI/rrHg05Egwer2FcFKcmRmEAuiOsw1czsckcvTY62TvmEDHMSRUKiw81xwyJ+a1m1EIRvjO6atwcAqTTyoVnBmgUa6x3c1DTUxpjNt2SoriWagkAMyfrE+qCQp46Pqql16PthIQT1Cypnk7DEbZZuXd/ajlxEDxj0NvcSBAkzse7f3iun0lc3ma8pTYWdq/fTIW3f28DigAL6oMEq1LJt3OUsadu4UOGmML6DvkMPsmFnRe4T5IeR2pYOn2zLXjkSgNj8/7H62/jL7Kq2S1ReK0onX9aql5/sGk6dy2Qpt4E51He5iQknKbpbkeO97wJRQADd5lFRjGpNp+BwZ+fMGdtRC2wZKMDEqXLjRkrgNXzPdjfQt/Xwk91BfOY3og0uLpQWkqcTPO6fGEvfJaFEirCF9OS0piQBKCabzezv17IcZWVR6c8qC0Q1angBs00MovxGx4yIX1mv8DhiwJH/PTG5JeuE06EXdkcn6VfoH6hPRsQDg2FYHgFCw1JSt4/tG1mrLM88UcFzbGazxK2a5zte0Cet8vSjVeAR6n5JTbVDcaG5IXNsv7PPVaJyx4T9JUqewPaeZXshlhmNnNKjCliPpQ4GJ8RomLsJcnqOBaSEmDUuRJRKusSq6tXt+ZI5x/dJfGytDgbz2F5cPtNr3nsHWyU1h1yyOl8tDHLspOw5jJGfbS/GRhAiapVzQDcfCZpR9cQrzGJlXBz/kFZbVIL6zfRduGWOx08KxJwGeQYoFp63zChMbIWSlNfG7kQQxTIMFnwTQz6
 xg6ztvkf
 GJxVspneLRt2HGD24LD7jWWwz3L1DQ4TqC2a1M3EDHrYG1AkWLozXkcca9N9gVHkskjklo/swIgx+gYfy3Z2ymEV8IWbkVl9elq1jkaZ+Q6AHs0BxTuUN/AON/NOWBKKQhuePwgwoI6DWgcWfOuvjEDj3lj5dMlM5k3EDWZUz5KOgZJJFq9QWyo/rGEoWrNoKT+q0TjujGGCULvn4Ow3+KzL50j+LGBOqXUAIAESrmFzUrVvcu2ukz3djSa6TsKU235COP0XM7E497fhdA1Hy59IMVgYTOG6fDBohQdA04YgWjAQvAxnQLBL7vzGIOJ3oMj7W3ZZrBYq+Tzxsn2AvHqd5fFiWEGJOC8fUx8fGJ+4MQoYdgrZOBjE8eQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that module references properly handle the usage of file handlers
and FLBs during active sessions, we can safely remove the
luo_session_quiesce() and luo_session_resume() mechanism.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_file.c     | 31 +++-------------------
 kernel/liveupdate/luo_flb.c      | 31 +++++-----------------
 kernel/liveupdate/luo_internal.h |  2 --
 kernel/liveupdate/luo_session.c  | 44 --------------------------------
 4 files changed, 9 insertions(+), 99 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 0fe2f8be8bd1..bfa0b4868746 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -847,7 +847,6 @@ void luo_file_set_destroy(struct luo_file_set *file_set)
 int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
 {
 	struct liveupdate_file_handler *fh_iter;
-	int err;
 
 	if (!liveupdate_enabled())
 		return -EOPNOTSUPP;
@@ -858,45 +857,29 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
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
 	scoped_guard(rwsem_write, &luo_file_handler_lock) {
 		/* Check for duplicate compatible strings */
 		list_private_for_each_entry(fh_iter, &luo_file_handler_list, list) {
 			if (!strcmp(fh_iter->compatible, fh->compatible)) {
 				pr_err("File handler registration failed: Compatible string '%s' already registered.\n",
 				       fh->compatible);
-				err = -EEXIST;
-				goto err_resume;
+				return -EEXIST;
 			}
 		}
 
 		/* Pin the module implementing the handler */
-		if (!try_module_get(fh->ops->owner)) {
-			err = -EAGAIN;
-			goto err_resume;
-		}
+		if (!try_module_get(fh->ops->owner))
+			return -EAGAIN;
 
 		INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, flb_list));
 		init_rwsem(&ACCESS_PRIVATE(fh, flb_lock));
 		INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, list));
 		list_add_tail(&ACCESS_PRIVATE(fh, list), &luo_file_handler_list);
 	}
-	luo_session_resume();
 
 	liveupdate_test_register(fh);
 
 	return 0;
-
-err_resume:
-	luo_session_resume();
-	return err;
 }
 
 /**
@@ -921,23 +904,15 @@ void liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 
 	liveupdate_test_unregister(fh);
 
-	if (!luo_session_quiesce())
-		goto err_register;
-
 	scoped_guard(rwsem_write, &luo_file_handler_lock) {
 		is_empty = list_empty(&ACCESS_PRIVATE(fh, flb_list));
 		if (is_empty)
 			list_del(&ACCESS_PRIVATE(fh, list));
 	}
-	luo_session_resume();
 
 	if (!is_empty) {
 		pr_warn("Failed to unregister file handler '%s': FLB list not empty\n",
 			fh->compatible);
 		liveupdate_test_register(fh);
 	}
-	return;
-
-err_register:
-	liveupdate_test_register(fh);
 }
diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index 23fa6e0c6083..8810595c672d 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -346,7 +346,6 @@ int liveupdate_register_flb(struct liveupdate_file_handler *fh,
 	struct luo_flb_link *link __free(kfree) = NULL;
 	struct liveupdate_flb *gflb;
 	struct luo_flb_link *iter;
-	int err;
 
 	if (!liveupdate_enabled())
 		return -EOPNOTSUPP;
@@ -367,22 +366,13 @@ int liveupdate_register_flb(struct liveupdate_file_handler *fh,
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
 	guard(rwsem_write)(&luo_flb_lock);
 	guard(rwsem_write)(&ACCESS_PRIVATE(fh, flb_lock));
 
 	/* Check that this FLB is not already linked to this file handler */
-	err = -EEXIST;
 	list_for_each_entry(iter, flb_list, list) {
 		if (iter->flb == flb)
-			goto err_resume;
+			return -EEXIST;
 	}
 
 	/*
@@ -390,20 +380,16 @@ int liveupdate_register_flb(struct liveupdate_file_handler *fh,
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
@@ -414,13 +400,8 @@ int liveupdate_register_flb(struct liveupdate_file_handler *fh,
 	private->users++;
 	link->flb = flb;
 	list_add_tail(&no_free_ptr(link)->list, flb_list);
-	luo_session_resume();
 
 	return 0;
-
-err_resume:
-	luo_session_resume();
-	return err;
 }
 
 /**
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 8083d8739b09..ec949f91c8c1 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -83,8 +83,6 @@ int __init luo_session_setup_outgoing(void *fdt);
 int __init luo_session_setup_incoming(void *fdt);
 int luo_session_serialize(void);
 int luo_session_deserialize(void);
-bool luo_session_quiesce(void);
-void luo_session_resume(void);
 
 int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd);
 void luo_file_unpreserve_files(struct luo_file_set *file_set);
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 783677295640..067ffb54c36a 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -600,47 +600,3 @@ int luo_session_serialize(void)
 
 	return err;
 }
-
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
2.53.0.851.ga537e3e6e9-goog


