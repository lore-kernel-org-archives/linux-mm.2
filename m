Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FB88FB5EA5
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 02:50:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 745C26B0088; Mon, 16 Mar 2026 22:50:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 653D16B0089; Mon, 16 Mar 2026 22:50:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 569C66B008A; Mon, 16 Mar 2026 22:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 42E8F6B0088
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 22:50:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C25EC13ACCC
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 02:50:57 +0000 (UTC)
X-FDA: 84554027754.04.C7A0197
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	by imf08.hostedemail.com (Postfix) with ESMTP id 00544160004
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 02:50:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=crX0f3Et;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773715856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lSH13KJcmbIwWK3JLHjAk43mNZH52hkh+lGVSi7g5tY=;
	b=CjoDoaNIwb1baPwSnBqeWa1N21AinuisDLSTaRcZ4cHB2GwoEDg5znmDwn4E5F/2QCGDb6
	DcWNuv3sGtSDo2r/VNel3bpK1niJS6AGPYa8SuAh18i3Hi1Wjxk0gazU77bopPoDTNSeTh
	VxWIkyTqq7r3xdEGkldWD3f+G/yeIdQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773715856; a=rsa-sha256;
	cv=none;
	b=XS1OPeDYTRdoM7UT4l2tRWsD3aeozCLl6ljxjTlG6d2LVo0SCgsdgsiRHtjkd15GlmuEw1
	lewwGadRLMgpUGzzd+cyho8epa3rMcr0LgeEfqxkxVES0XEar3PWJWkTtfF55Nr0EM2+p/
	CxJHNsjFqop4FU/8S/qDVNlVUFSiotY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=crX0f3Et;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-64ad9238d8fso5943688d50.3
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1773715855; x=1774320655; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lSH13KJcmbIwWK3JLHjAk43mNZH52hkh+lGVSi7g5tY=;
        b=crX0f3EtQWoOuvaHl8cBgbfyl4YlkI4a3iuD6xI8Oq1QjofQ4rSu4/OO9ySvYAsVjs
         vmUIJqxVH0GP4lSdt+ezPWHln1lKRuZMa+B2JmFFuEkYrVZ+5l6d02AamImZ6wCmJwLi
         S6+tJ7dUotGwQiQnBXQzK6/E5B/XP1Gko90qmqh6MHVwSNsWs2C9fxHTD201UkPRsh2j
         30HCgGNsBfbp9Nz+y3qX1cXiU42fNfyDh5dRClYKbxkGOycwz0GihCuTPyUAr7vazLJb
         YAkIbb3yMK15EwJNEGEgHZ45Kx5+IAWhN8q5CIIam2HWcoDv5KhgImK1jEUk55E8KDzR
         U1pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773715855; x=1774320655;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lSH13KJcmbIwWK3JLHjAk43mNZH52hkh+lGVSi7g5tY=;
        b=b+9fcivYLutF4odMPzfRYndywR79W3ZhhdKo9AD3Y4KQoHoJddU2TfKAtBmPTM2F6t
         LTV1BZL9NTbR5CwF9KFefgCMR9vfBS4+htOl8qqVehztvTY++2s9rv7kQq/Q6dewh7An
         FFPNX3bBmFD4Z2e87GE1varvb3peXn2zw7OIdEwOehL7RJYalRQhp54EkUJHqEvPYO+1
         EIqhmNXuSsWkPyrWW1wZ5r9nMKSZ/1DscO9s237i7WoaCqvb8Baf/jVN+tfclOtJngyv
         xZ0FlSt9nT+IDeggVeYyHTUq35x24tyOtpbFtuSGNGh5yV/VpB7bc2quVeT8OvsH42QQ
         ApSA==
X-Forwarded-Encrypted: i=1; AJvYcCX6KtfqRJg+gNjHZysxMY6cny78zW7AZHrbJvgNbPdkRgaKPnPN5YOXdpP70rftadsW8NFa6Ozs3w==@kvack.org
X-Gm-Message-State: AOJu0Yx5utU6RTvrTjHb4yNYZ2OWNGxwtjtBH+E5HGoE5fUtetW8YQP2
	qO0zt7eFKKnjHXHzN2wnib6Z4FGDZ7kHDzdWXJTj4DN2iw2nJUKq/XYN46veULL6yb8=
X-Gm-Gg: ATEYQzxwqTvMYZafkpvliXL4JZieLAaXLPEmTQN1bA7BUlA24HN5AY+J7G5TtzWrOip
	b5kUF0cn8TwuF5Tvn1rJXtEnGIJoo+jR5M/+DMA/ZpOSZ2D6GeoAmFjwla03BnjeM4SuQKKSnAN
	zng5qaGqoNK+NA/8rMv6W7ZvEBCAPdGTUYhsPFErLxh8TciA3WUPsvVkSPxi9ZgM0/jMi7aZJXX
	kM0Uxh6kP0xwYjpc4qfBi6tx7pePcWjlXZPcTpOjT3zijjF1DqwqVYWNRVUDBNEUbEatkoJC7/0
	sIMWqCsMmBriZbM0j08PtmNT9NYpg8c8ExsL2UB6duYTJgr+REKH0hlHo4LKDrhQfL7VLlQWTJ1
	AWTMUOC5gf6ITI9oLGSS5Laymu+G/O3K7C48CGlJTPlARoGLyt4VPBp2WfLiIB9fwPmEsfiqeHx
	BKI8xre811IrEBP3r0NyoQBrZr9Aza4CkzdQmcX0ZksWI/Zv3QuK926d4/2U/t+dN/2kGAfHsrx
	CdqXMy+pcZQdQBGGSocDkajqhzUi0RKcmPJ5no2dzHg2tvD8g==
X-Received: by 2002:a05:690c:288:b0:797:4722:f8a7 with SMTP id 00721157ae682-79a1c26723bmr151441587b3.61.1773715854973;
        Mon, 16 Mar 2026 19:50:54 -0700 (PDT)
Received: from soleen.c.googlers.com.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79a5a866c85sm14951757b3.35.2026.03.16.19.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 19:50:54 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pasha.tatashin@soleen.com,
	rppt@kernel.org,
	pratyush@kernel.org,
	linux-kernel@vger.kernel.org,
	dmatlack@google.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Subject: [PATCH 1/6] liveupdate: Protect file handler list with rwsem
Date: Mon, 16 Mar 2026 22:50:44 -0400
Message-ID: <20260317025049.494931-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
In-Reply-To: <20260317025049.494931-1-pasha.tatashin@soleen.com>
References: <20260317025049.494931-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 00544160004
X-Stat-Signature: 69xad3f9h6tad7y7sygkne8y9omoddto
X-Rspam-User: 
X-HE-Tag: 1773715855-746108
X-HE-Meta: U2FsdGVkX18DW9XMf7xXFbq/L9l5sKeOgtE+vCA5s9hSrbvt2firzi3qVv4CNfINyZceYyO9TF+awgnP6sw1MqXNI5XNh7aIAq9QAgvV4LxjpdWNJSIywP9pd8cGJwCYrWnjWIJtVJyoziwGt6WRy9NyOOSPkMFIhdbWeLkSWFl/JDQWaWEKAt3gT386MQXw9Wjsox/sICFbHRuN1IrqbIuZ4wq2LNGuL3CpSqbpr01yiel0gLLSFV3XeRRMDMS7uWmgxIh0pANpX9mIBSk7T+i1iSYtLdwvUjr1CRQQEN4T1y9VYoLqVgCVF/saFckbngqOBhbLRPnmc5+SE54blTmDxgc5bH2FYGgFYU7wd0m0nEOJVWOjbbYQcCjf/l5tn7x1yH50E/+rHo1RS2Iso4SA8ZJMd3134zjLbA8fm0LepKjLFRZKQQ+bSat3uBSoFLfF22XPVN5rIAbsfu+JGvVF9AFOz4FzOwsKzT2daG1tDu/N9Ozz20XX5Z7W82Q0idTRTbIk0e/94AWObPR5g8oYbKvFZWdwgR+goqPfj1widOUXQkiBkTu5KX3WRbqYZgK1aEwR51XzR5P270EsM2TmHQQx7tQXeDn3CQbcH31LhSz4Hxl3faXVAX9phiw82po/c42gYTzRTry1KiQ2aDwNCIhVR2RFQ0EiibG99U064cOzRvSHvhXwBxwdmiv4rO5B7HVkyPShRr2CFLMBBhkZmTiSRKk/XlttAIp8jyvMfq1inNHs8Ys7QqtHYMZ8Y/875R57YNrOiSLqIAxiPlH2reG5jv0R6aidNWdxHDggyi39qnNfVS9rU/vmLQn7S4RJcDPfDNfPtTQrahVNGQO/MtT+qKrA/drENMFc41rnAY2ZpZVgAICE9BlseOmUJD8d8ZDGg/NUOXuklMj3yvScbB+zFi76+LP22+OcFVzuwSuCK03GhDRPaCorlB0C6j1+Tpl5EO4TFhnXB4I
 eIN06q4f
 13PU0/rnL8BbdT47USp0mu2cPgsesdUOdnGBXDK+eH81zBr4aEclhoj92Q5CIUm2ewjbwGjTJaOAyHOMhfeCEWj8bnp0/gBLYc0bNVQM/ZuUJr4d7XH2D77Ba9rni5LwDH1VWlwTZ7GdenZU+clUBFWdMyDugBBxtN1NksyhLBudiJngS/52qKEhBkIXZZhYxrX9qBRveV/+wjWsxXWvB8PiG2PTMNZrfriBhpFTyCpJA5EmjChssdKlqFTSof9lJB1HXDSmjUpnLpANhUWroyOXby9MJdbVgbj0OkrdFCHWfIXS9X+ncqhaNLtyzg/dEgEkB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Because liveupdate file handlers will eventually no longer hold a
module reference when registered, we must ensure that the access to
the handler list is protected against concurrent module unloading.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_file.c | 61 +++++++++++++++++++++---------------
 1 file changed, 35 insertions(+), 26 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 5acee4174bf0..6a0ae29c6a24 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -112,6 +112,7 @@
 #include <linux/string.h>
 #include "luo_internal.h"
 
+static DECLARE_RWSEM(luo_file_handler_lock);
 static LIST_HEAD(luo_file_handler_list);
 
 /* 2 4K pages, give space for 128 files per file_set */
@@ -277,10 +278,12 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 		goto  err_fput;
 
 	err = -ENOENT;
-	list_private_for_each_entry(fh, &luo_file_handler_list, list) {
-		if (fh->ops->can_preserve(fh, file)) {
-			err = 0;
-			break;
+	scoped_guard(rwsem_read, &luo_file_handler_lock) {
+		list_private_for_each_entry(fh, &luo_file_handler_list, list) {
+			if (fh->ops->can_preserve(fh, file)) {
+				err = 0;
+				break;
+			}
 		}
 	}
 
@@ -777,10 +780,12 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 		bool handler_found = false;
 		struct luo_file *luo_file;
 
-		list_private_for_each_entry(fh, &luo_file_handler_list, list) {
-			if (!strcmp(fh->compatible, file_ser[i].compatible)) {
-				handler_found = true;
-				break;
+		scoped_guard(rwsem_read, &luo_file_handler_lock) {
+			list_private_for_each_entry(fh, &luo_file_handler_list, list) {
+				if (!strcmp(fh->compatible, file_ser[i].compatible)) {
+					handler_found = true;
+					break;
+				}
 			}
 		}
 
@@ -850,25 +855,27 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
 	if (!luo_session_quiesce())
 		return -EBUSY;
 
-	/* Check for duplicate compatible strings */
-	list_private_for_each_entry(fh_iter, &luo_file_handler_list, list) {
-		if (!strcmp(fh_iter->compatible, fh->compatible)) {
-			pr_err("File handler registration failed: Compatible string '%s' already registered.\n",
-			       fh->compatible);
-			err = -EEXIST;
+	scoped_guard(rwsem_write, &luo_file_handler_lock) {
+		/* Check for duplicate compatible strings */
+		list_private_for_each_entry(fh_iter, &luo_file_handler_list, list) {
+			if (!strcmp(fh_iter->compatible, fh->compatible)) {
+				pr_err("File handler registration failed: Compatible string '%s' already registered.\n",
+				       fh->compatible);
+				err = -EEXIST;
+				goto err_resume;
+			}
+		}
+
+		/* Pin the module implementing the handler */
+		if (!try_module_get(fh->ops->owner)) {
+			err = -EAGAIN;
 			goto err_resume;
 		}
-	}
 
-	/* Pin the module implementing the handler */
-	if (!try_module_get(fh->ops->owner)) {
-		err = -EAGAIN;
-		goto err_resume;
+		INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, flb_list));
+		INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, list));
+		list_add_tail(&ACCESS_PRIVATE(fh, list), &luo_file_handler_list);
 	}
-
-	INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, flb_list));
-	INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, list));
-	list_add_tail(&ACCESS_PRIVATE(fh, list), &luo_file_handler_list);
 	luo_session_resume();
 
 	liveupdate_test_register(fh);
@@ -909,10 +916,12 @@ int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 	if (!luo_session_quiesce())
 		goto err_register;
 
-	if (!list_empty(&ACCESS_PRIVATE(fh, flb_list)))
-		goto err_resume;
+	scoped_guard(rwsem_write, &luo_file_handler_lock) {
+		if (!list_empty(&ACCESS_PRIVATE(fh, flb_list)))
+			goto err_resume;
 
-	list_del(&ACCESS_PRIVATE(fh, list));
+		list_del(&ACCESS_PRIVATE(fh, list));
+	}
 	module_put(fh->ops->owner);
 	luo_session_resume();
 
-- 
2.53.0.851.ga537e3e6e9-goog


