Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4574F103E18D
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 14:17:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EC586B024A; Wed, 18 Mar 2026 10:17:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 227F66B024D; Wed, 18 Mar 2026 10:17:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 050796B024A; Wed, 18 Mar 2026 10:17:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CF2686B024A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:17:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 87D8A1D898
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:17:04 +0000 (UTC)
X-FDA: 84559385568.04.C1A223B
Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9B9491C0005
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:17:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Jr2pX82O;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773843422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9grmrBps2hK+s63PftzZmwOuMlZ/QyGcOsJY971KUOk=;
	b=8iIFy5KMTNdSxQ3hsaNmwUd4P8kOx7JcicO7GztX/JHnvxstpTHkSYznODiZL+lUbQ8adH
	kJXpNNprGkn8SQJNjlDq+Y7N1XecbTioM6/Z7nHNiQvBOBdhl5G1WQT737qi02ZukaeljV
	Lfg6IHjmuuir11nNRc0JPvASEOK9VUQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Jr2pX82O;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773843422; a=rsa-sha256;
	cv=none;
	b=6haOhpjO1ltuudoxjywdAJh+APKngslfsxNjd0tvnY6ksNJJ9RzxiLDJ1ml9gPA9YO90mi
	+N6PGgiQsdrN9zEDrwFFNeC+Tuvelp/nVsN/8hNqecnse1jGlNh8/dCKuEjGpHJ/M6IlJT
	n+QVtuJR1wq/GbZ/GBsW4W644T2RmR4=
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-64ae2ce2fe1so6776753d50.1
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1773843422; x=1774448222; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9grmrBps2hK+s63PftzZmwOuMlZ/QyGcOsJY971KUOk=;
        b=Jr2pX82Oq/zhoenQfs3ZiSaEYU2zn9ALgaDrxU2Gl5AnaFtfpU5wJ6mRQwWgckhV2D
         qNxB7Uu0fL9jK3dHQMSIant/vMoUjRBuhilswXP50GyKkppUlqfgIiJNot7BN+7IfRdH
         jWRqDuPzKMvPQ8Am+cX2ldV2c2ZgvBoQHiuih5sck5udRhezhGcLGUNGYFMo7vrgBZZP
         uPqowzggpwB1YkMuCLvRVzomUOqZit6iWeLqy0k8Qkq1SSapvqZ6hXtbcfC/jDXZYy/X
         E247/3D1KPg6lyQ3x2EenQrzimM05CCBjVcZZSbNy4e4NmDQh+wkyIb62TLjSLaHy5LZ
         vbkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773843422; x=1774448222;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9grmrBps2hK+s63PftzZmwOuMlZ/QyGcOsJY971KUOk=;
        b=eQKe90lz3pa7skAwlZ+Tn4vMKpbG5TbrrH9OEZKvhzSxsTLfN6nYi640Qh+PEX34e/
         AXqIFPYEWfAafXIzHwqMfhyYXlq+/mTHK3wWHnr06+fFHZx7mnBWxtNE+gNG+Afr/KAy
         wFntKgd+anDwJJc8r7w4q+SI9Rzcd1d2EcXj6nHHseAGxp7hcnA4Mn5bSxmGMdtKbQ9m
         1GLBU/vdDnD14MP3bCmS1UevQtGEr2Do7u87ZgKXz2M8c73xckWMe2rUKP60LdguA2l6
         Q9A9nE41ZIL4QoM9MwP4gIlO+ubGYkdbZKjBvyf7gPfMJbxR3WjPyBuN9ySbiHDCB54/
         zDgA==
X-Forwarded-Encrypted: i=1; AJvYcCWnGeCSQ503057uSBCqTGRrSIATT16J7LLzfg9FSUIqkIN3sD0pXGk6lWIgPGWnKez/rm7xkw/PKg==@kvack.org
X-Gm-Message-State: AOJu0YwjvF2JuCqz3g8ovgryoP3ygaWix8a4a+dcpoeQ7Mq4wOJfwvNa
	pbmhrlhxiViOm7Yjic1zUBjtfWv/LRg07KUPRc2rNZ/lqRAGNm0LMVlq1K0NgF2uk4M=
X-Gm-Gg: ATEYQzympHol3zRTpkJbluP3Plz2VweLdakOKCOctUurGVt/9IoMeU39fm2fhLT+UWc
	gB/80F9B7qzu1WdCkpr3BXqcE8XLTWSxyT4KAuDKYar6zg7iDKxnvuzGkvf4YhJwdPBksXzt2KX
	RETluvjwEaiRSPl15oSw/L7hVRTlx7F4hM6CKhePO+IxQXuiS4rCFwfdlJXSkEz2/1/M+XT+TQQ
	aTfu8IkkKfwS3/+yanuWEfKXa8kj7WXPx8ssj4WFj24bs+4Vz8RUu8HTIo16dFMLqbiM+MDv5wX
	LvGuS5B2hsT2+09uzpY4scH2JtuTCGso0mfBHACtl+5ETxiSRGwaZILQIuWJttDEUx9hexG3Lke
	m/nYvXiKY9lb5QL/k6tlw9JdqnUZP+3BAbIexDqyaoav+5NKjuv5zs/9epUOqfJM3fgf+l4BAGh
	6fRIpZ1ef79+gn98qy5eNfC0w8frfiDNINgZd1rpo93ZRyX2a9xGMCwkbEnqQeL2wciVP8EuNd8
	Ht2GrQwgq38IliPx8EssRiuTGttIUFLpMOZcIe5yp98b9P6GpQPXjinLO6Q
X-Received: by 2002:a53:b6c4:0:b0:64a:d444:48f5 with SMTP id 956f58d0204a3-64e915f5a33mr2644882d50.65.1773843421452;
        Wed, 18 Mar 2026 07:17:01 -0700 (PDT)
Received: from soleen.c.googlers.com.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64e91be0e91sm1672028d50.15.2026.03.18.07.17.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 07:17:00 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org
Subject: [PATCH v2 5/8] liveupdate: Remove luo_session_quiesce()
Date: Wed, 18 Mar 2026 10:16:43 -0400
Message-ID: <20260318141637.1870220-15-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
In-Reply-To: <20260318141637.1870220-10-pasha.tatashin@soleen.com>
References: <20260318141637.1870220-10-pasha.tatashin@soleen.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8396; i=pasha.tatashin@soleen.com;
 h=from:subject; bh=k1U60ogGlFKqcQ2VNpd3YPvxEKZ2keFaPByWtDwKlOE=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBpurPMnXDInX88G54UAYQw0L/MaWlYrn9GAm0fu
 o0ri6gq5VyJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCabqzzAAKCRC7dyhM23N6
 3gmbD/99nCQV/oK6edHYLGsZT66H9puZFs6qMQEpgTm6zlLogKeyxMRCqK6A7YRthVSDghj74Rh
 RICG130O8omn6beue1D1lsRqw/DOru4IBblYemY58l3GXqKeSomGocmVRpqWbFfX29GI1JAgHci
 hsMce4Y0eDpQ3dna8egsI/n2CIsRyxRqpyQrWq3HMoNfh1568mJJySo2QRH27woXqp4wvuR1lqZ
 9UWFUFor+y52QT0kSisHxtiPmFrJniJTvMczuurWKHGpLPoEpmFXPtvAWYmRuJNXuAY1f5bU4vN
 FR86KxDLO62Gsqb4HpU3ZkFF/6oRL1smCrOHSbLfMhc/FP3UetnR5MB8x4iETa64Su0HihhyRPW
 +H0Xdz60BnYpqdVsWEUcJH0PY7nKgRO26NtwGflBwSfPbUYvlsrVWUNezFluRFeriIwizGwo0Dz
 qBC3+i/YYbd3Sk0GZbHVBmjrUOKeiQ6pdMN5K/KThiz2+lqZHT0If2i+2PYP4pozzC5tr1ZeSkX
 4/iUzzh6EG4THuQLswajM8XwVH/NIHfXheTVqQ1680u6BaFwF0rm+j1tSAghM+Y/YPQxS1OaDrt
 zk7MUgdHyThGi3mdCJ1/krI2gycuujBF92BxIMNbEkT7qm6H/sjaakPLUY5CN2BDOBsHP65c2Ly exBOBsfe3n4paXw==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp; fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hr45hiqx64ng8sjachfysj3gb356ts8e
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B9491C0005
X-HE-Tag: 1773843422-95945
X-HE-Meta: U2FsdGVkX1/vyzuFDeTLO+N7Pf0N1j2k9indEZeLJ57N63aDcEvLc7kDB9iRIX+P1NhSwTBSc7w+NwQGzH1d48oUTUEYO8L5pTQFpNzKFKgedsMFgwpxuEr6NXf4dfIT4z0RZ69Cf0jJ2d9FcCV38MhUX5SjxHrtqM/ifbeubpTiLTFipDMrFwJP3IDE12ORw513BSrYFICh1j3Rueo6PE17w7VuYVnMlWWDnH4GdQH13z90QfKhXK+R4Jwm6g0jFWi8UKb9yWDUKmUgA4VwGI++9O5LVTHUf9LIJbqgbufTYNAW4JlppCDAbJFmQOb54GEBqHLuEMMoTHw9l6S6pLYxP8vUauMXiXND6kGm6IW5lRMYL4aL/PINqLdk7LetPp+1OXW17DReQT+w+T+rJ9DdH1GXv3IHkvaDbowJxfhtUEVPjSYpWjyv9Y+39RHh/+BiTn9C27qpaqbUGUQ7o4h3yrWBBq2Zl7/9rjrfvKwAi0LNY9XMwtDAYjz77Esw9q9eci5aaT6TRUmJLLHYzPCz/KUxyVcIAsvym4cV+D3Xr90rLjf0oKIc9BNAK1cWZ7CFfhuGa/rE7dn1wuwa97EuZdTFe9Y5CyqvukmUfLBSM5x/53Kogz1TkGg44HwizIHCnJ9aa1WN0vphxm8bVDqsQ5NJvYYmNi1sI4fPi827gs7bHgBwaw7oghSGxoJALy0MUAYw8t9TCfh7UaAcQUp5kUNxxfk4Ic024BO/xMdMMJIn3makPafrKcUaaGJGUVriEJ9EoAzaiLy8lhHt+MbH/+vacg/XGoAardKx7asGxZIGH22fvG4rKGo1NynbuINtFgX/OmknJdzhDZlzX+nTYq2uNWMCpNjRe4r4y9XiYegSJl6aE+NZqf6aPlTyPo3SK63IR7D12iUysa5yFIXdnKuGaMoD5w0jIHVyvlHm3pCW2D7R97T7B880fVdZ7qTf3jHHYUVcTZ/DSLe
 T/9/CX3P
 zM6gxs57C7YwU5cTo+D03BWAqQRFoHeX8Ql8rXbDmKHw6ovsDTBASuIKFdMfKezldsUaINY7JUoiq9s/0nIB8YMBOexbSZXQkEhp72INCmWGpEMs74V6zZTM6UTZ/uAcFhyY4GSZqQnL8CDdb/7sSRjQVoHzlwah1WIsNslKreuX7cwXcPYBgjQ5KM8pNzWWfZZU9FKWZ+DBwQ+40LPf51TvpIO5SeROEQXxM6pjmW+tgBEW0k7DZLBNJZpKEF3Yj3QjUN81QsDxKWIKtLU0itkoux3VcNsS3LTkXqyfck0PlyYIpaG+cq+7ZW7mMrTREYSN/5XZeGEUb6e5OWS+JN7yBdtH6oUjB0lmr9pfdj37npxJav/iokF1etQ==
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
 kernel/liveupdate/luo_file.c     | 21 ++-------------
 kernel/liveupdate/luo_flb.c      | 46 +++++---------------------------
 kernel/liveupdate/luo_internal.h |  2 --
 kernel/liveupdate/luo_session.c  | 44 ------------------------------
 4 files changed, 9 insertions(+), 104 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index b124fd747841..c0ce08d55747 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -846,21 +846,12 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
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
-				luo_session_resume();
 				return -EEXIST;
 			}
 		}
@@ -870,7 +861,6 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
 		INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, list));
 		list_add_tail(&ACCESS_PRIVATE(fh, list), &luo_file_handler_list);
 	}
-	luo_session_resume();
 
 	liveupdate_test_register(fh);
 
@@ -885,13 +875,12 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
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
+ * update is in progress, FLB is registred with
  * this file handler.
  */
 int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
@@ -901,18 +890,12 @@ int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 
 	liveupdate_test_unregister(fh);
 
-	if (!luo_session_quiesce())
-		goto err_register;
-
 	scoped_guard(rwsem_write, &luo_file_handler_lock) {
-		if (!list_empty(&ACCESS_PRIVATE(fh, flb_list))) {
-			luo_session_resume();
+		if (!list_empty(&ACCESS_PRIVATE(fh, flb_list)))
 			goto err_register;
-		}
 
 		list_del(&ACCESS_PRIVATE(fh, list));
 	}
-	luo_session_resume();
 
 	return 0;
 
diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index 98336cd23aa5..8bbe11a7286b 100644
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
@@ -455,13 +436,6 @@ int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
 	if (!liveupdate_enabled())
 		return -EOPNOTSUPP;
 
-	/*
-	 * Ensure the system is quiescent (no active sessions).
-	 * This acts as a global lock for unregistration.
-	 */
-	if (!luo_session_quiesce())
-		return -EBUSY;
-
 	guard(rwsem_write)(&luo_flb_lock);
 	guard(rwsem_write)(&ACCESS_PRIVATE(fh, flb_lock));
 
@@ -476,7 +450,7 @@ int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
 	}
 
 	if (err)
-		goto err_resume;
+		return err;
 
 	private->users--;
 	/*
@@ -488,13 +462,7 @@ int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
 		luo_flb_global.count--;
 	}
 
-	luo_session_resume();
-
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


