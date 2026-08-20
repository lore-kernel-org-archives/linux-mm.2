Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACAE5C5DF86
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 19:19:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CAEA6B009D; Thu, 20 Aug 2026 15:19:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77BFA6B009F; Thu, 20 Aug 2026 15:19:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F6C96B00A1; Thu, 20 Aug 2026 15:19:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 34DC06B009D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 15:19:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8E114801E8
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:19:08 +0000 (UTC)
X-FDA: 85122610776.11.D6B6BBC
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf14.hostedemail.com (Postfix) with ESMTP id C3E56100004
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:19:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YsYMGmRE;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3KVOHaggKCEg2urk6ktkqyyqvo.mywvsx47-wwu5kmu.y1q@flex--skhawaja.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3KVOHaggKCEg2urk6ktkqyyqvo.mywvsx47-wwu5kmu.y1q@flex--skhawaja.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787253546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fQ+SSW2xYaWYPCjZNKHlYzGG7Cn/26PBkUG+IbsFEFI=;
	b=BZ5vUdEr8N7UyCfLmVzjLA9IFaPMhB87rR5ZWkf194fu1eYb3X9hifebUWqGMkg7bq4hbY
	Q8DJaZACXipirYAoCfdJGUjkgPVDW0MurOw4Kx7qjQSKqcK6bxwW7asZKqeTTx15mbF1bD
	vwqzE3yKbktSQnoRVR0UcJjiveV0T4c=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YsYMGmRE;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3KVOHaggKCEg2urk6ktkqyyqvo.mywvsx47-wwu5kmu.y1q@flex--skhawaja.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3KVOHaggKCEg2urk6ktkqyyqvo.mywvsx47-wwu5kmu.y1q@flex--skhawaja.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787253546;
	b=IwLtPtMKnLK3/IwNqc0oWIrJoLY+52bXTQuW+SLMht3BJUkj8Vi5sw5sK1qbBWAudT60aI
	xdgZ85/y4sVoo779sSkQogKxM/Kxb//JBHmtyDzb4EgqOhpBxsUzVzh1P01VlX72oiiqRh
	mZo+alwhjiL7RI/DLx1yuM9W7Q62SPI=
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cbe77d6864dso338909a12.2
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 12:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787253545; x=1787858345; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fQ+SSW2xYaWYPCjZNKHlYzGG7Cn/26PBkUG+IbsFEFI=;
        b=YsYMGmREXYpa47hclSZvpC5S3ebxTSBixHuOIA+YmS9nJ2kSZLlAv/k7QCQ7IMw5wo
         usXjf7qVHMhfBea20GuS8V0nkKsqBesRIAYRT7cQ/XU73D+6QiJBVCE/kl1IbaHSpUCy
         NnMZCPWYT2LmGlXFLD1DYOjLitCzxTf12D6dOfWs1TrMGGDkCad1Hknb0iSvnv5gb8xu
         /HETIpTtyGBFG4kOTQrSZbYcd3M3a3+qZKw3JJhFzmCCvAsSUl9Hjw42iV/t1X+3MB/B
         nwdlLDgw7o+hlgd7rkL9CvJXZLc7xHmrVaEY323hPJPiuiJHwTxiQjG8fZJP8ZT9N0hR
         D9Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787253545; x=1787858345;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fQ+SSW2xYaWYPCjZNKHlYzGG7Cn/26PBkUG+IbsFEFI=;
        b=lzw23j/zLHL9UUVZhdrcZ2mt9Ya3LFBI7Hyloj0//z/aeZR/f4LeMgVWRuu8g+bgui
         DKji/8uN/OTdKzlgneY/d1mwfnpaGqc3aUuothns3u9avXSmM3Wz1AHjmyQoLH9d4lcM
         XCBII+WSr7QGg4xpr/pjYyZnbPP7WG/be6sLR7seH/U8sMwTQa2+zTjiqDsk4KdKVmrm
         6EgQQnPY0TxTRfcK8xWN5smUgDRxVdtORXb4doAofEL1jvwdj4G7iSd5+t+3GFuGHLmB
         dhR6vtwNOlkpnpKeCsi2f/3zEaf0aUcyNnmDxUgM76f4pc2spLSSRPEpaQieHCJsrvKL
         NZ1w==
X-Forwarded-Encrypted: i=1; AHgh+RpScgPTb8oiekm/G5cOVFNqL3p33nAiDa2bE/lN58UpBrpJx9tsVGAsx3p8rLae8mOGhcD5kywUuw==@kvack.org
X-Gm-Message-State: AOJu0Yyuhwv/ofTBGNBZpyHnV3yevAhm9zm3qPiDAP9gLtp4h+Sc3DIa
	9dOTgdA2WRUbt/TrLohGJT91pzFT3LYWLWZUKfWB4rDIZVVzjFKAfKycLMSbP+Jpdyh+LBRLVfE
	Vk2mlmMvSenBrvg==
X-Received: from pgsb12.prod.google.com ([2002:a65:67cc:0:b0:cc1:4df5:5acb])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:4516:b0:3b2:a809:ffe with SMTP id adf61e73a8af0-3cd300901e1mr1395552637.14.1787253545341;
 Thu, 20 Aug 2026 12:19:05 -0700 (PDT)
Date: Thu, 20 Aug 2026 19:18:54 +0000
In-Reply-To: <20260820191854.1642931-1-skhawaja@google.com>
Mime-Version: 1.0
References: <20260820191854.1642931-1-skhawaja@google.com>
X-Mailer: git-send-email 2.55.0.766.g2966f0265a-goog
Message-ID: <20260820191854.1642931-2-skhawaja@google.com>
Subject: [PATCH v3 1/1] liveupdate: luo_file: Add internal APIs for file preservation
From: Samiullah Khawaja <skhawaja@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: Pranjal Shrivastava <praan@google.com>, Samiullah Khawaja <skhawaja@google.com>, 
	David Matlack <dmatlack@google.com>, tarunsahu@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, 
	"open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: C3E56100004
X-Stat-Signature: aqfq9hfoby4gjhhst9xrfq7n89f47as3
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787253546-357877
X-HE-Meta: U2FsdGVkX1+fetrO7aM9vby0KdopIT38dIIq43kffXtCyb18WgMOdStpyOtgTcQ56B6CSNvjXVMzkhb8Z6ykzKlUNWoxWCSBtqXQI54zRLvm+gjdWe0TziP0ciZaB0KUitj3aoJNbZaRRKm/cxnr4XbFYguwJsfTDlC7AYfivUXI8ptbiQl5REm0Cs9Scj13JgVxpSYHaMbsF42TNzcDpUqWKF3CphUrCTMg8S3WQQU3UOwgLBVtTvk8XFD4NDYH0OG7JYaX+14XiamGL9WjQ3t2HmmHoOrPubHZSnoBp/AAXFID/DVsiml9veWupPacMvu6L31QKlwVH/5Ss9HASgBt37rrMjdG34GPmcCf7rb2yAbTkJi/tglH248FvSYgVpG99QHBIsjrpPtE3Q3CyX3+6Lnz/HqHHUTPjHgrgXm+wkZku9gQ2BJZNb5LAQzjDMUewsZQ7X0Kr7taWUW9jOdSu+Qfl1UMFdn7RTQFIxrA8tH1CTNy0jLtRcmcqUbrhepn9Dc6TXgfKSBM5MAB+mGpgIavoSqSBtZtyMekvYpLxzaTSF0qZBjNspFmuHBkoLFzAFwLkqq8vjvfDsRk6jb0sOJ2D4RdGyPiyhhJQ9VtFUjl67U5s8eamztEQRg1qHrGJIUaNBRD+fsrW3N4DY14xswFPRrnpdM6GaGEEI3hAeYJzovPwehttZrC2d3RMqY5ENheMh5bBLpp+W2FvbIjJJi2w0M8m+dOp4DhdH7FBWJAhRIdXUI6KFrDFEVcP8zEQpHp9tr/x4fN4IKnPZOyjb6APb0M1rE4FxkEoppnSbTqFly/5DxP4Vh6l+FLok2Loh8I88K0qLrjDI97n8duTRMgJoplh7NCPoZnMmeVwf73JpG0KErqcMmQMBTQ7umCN+3EmhFWZbpyCKW5ehGYOneETySz1VAIkM98uNQw6DX64f+22Rc4JE7WjdGLL4aDobaBk9bI2ktnU/P
 MdwFQNZX
 bt42b/6KXMRlWVr4YJUg/to+tFmUjB+h+k2AvkqvwZoJz7woQjb3KHem36oturLOPBBK/dkA2oH8+70S0JqVlwt02GhuLSZhU3m+NS4a+U7JVuNgOmd9OgcL7SdQlBWSfuvGHnKmpHPyKXSstdX7I/JlnIzCgLRjWmSqt7oTENh3ouUWqAAa2WAHF4Ji2ojAZu/t/qjD5ni9HaHuTHl3pqqpsyoQQ6mUrURohPBucvmoJtu1ShKUuG/7dXJXTrYThIm2Sr8j2UHz2WWciO6PPnTbVwcU+M9CK2jygijDw6yUTJ/2fo4y618q72DQSKAe3Q6irrAxsapJ7oy1OhvTBgnxoQ4bXbHAP8tbnv7P1TTmp4V3cENmwdnL3TqpUeZUoGBSRE+2d0vdOYNLCbmRdBsWfpzDMsJO5aVaU+mSz4K46r5qC9jKxhMQcG4HHRGCaHGL0PT1LAY22jN40wNjpMQlAqrhTG//yCx/tBLgSCGslUY0cwJiAcXoyWedNKCe8LIHN/3ipr2R/Avxjcgn2n4FPyH/Uf6dbMG88lPw/0IrrEMphdUDX0RhgrJ9LBVpYLNAZOZoc+RWUyzzubGRRaAWj72OVm31Igd56SfsUA1OpwlJmrMm2Moh5mXTLsvZ6Uw8JMRjlUnc0BSg/TQ3RwRLIT8wCSFpnqw8YHA6G7fgFITxhFgpOTQvR2eimI7cpej2y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pasha Tatashin <pasha.tatashin@soleen.com>

Live update orchestrator file handlers depend on the preservation of
other files. To make sure that the dependency is preserved, the file
handlers needs to fetch the preservation token of the preserved
dependency. Similarly during restore, a file handler wants to fetch the
restored file of the dependency.

Add APIs that allows fetching token of dependency during preservation,
and fetching the restored file dependency during restore.

Reviewed-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 include/linux/liveupdate.h       | 22 +++++++++
 kernel/liveupdate/luo_file.c     | 84 ++++++++++++++++++++++++++++++++
 kernel/liveupdate/luo_internal.h | 17 +++++++
 3 files changed, 123 insertions(+)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index 63ea5417de84..6051abc0612c 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -25,6 +25,7 @@ struct file;
 /**
  * struct liveupdate_file_op_args - Arguments for file operation callbacks.
  * @handler:          The file handler being called.
+ * @session:          The session this file belongs to.
  * @retrieve_status:  The retrieve status for the 'can_finish / finish'
  *                    operation. A value of 0 means the retrieve has not been
  *                    attempted, a positive value means the retrieve was
@@ -45,6 +46,7 @@ struct file;
  */
 struct liveupdate_file_op_args {
 	struct liveupdate_file_handler *handler;
+	struct liveupdate_session *session;
 	int retrieve_status;
 	struct file *file;
 	u64 serialized_data;
@@ -247,6 +249,14 @@ void liveupdate_flb_put_incoming(struct liveupdate_flb *flb);
 int liveupdate_flb_get_outgoing(struct liveupdate_flb *flb, void **objp);
 void liveupdate_flb_put_outgoing(struct liveupdate_flb *flb);
 
+/* kernel can internally retrieve files */
+int liveupdate_get_file_incoming(struct liveupdate_session *s, u64 token,
+				 struct file **filep);
+
+/* Get a token for an outgoing file, or -ENOENT if file is not preserved */
+int liveupdate_get_token_outgoing(struct liveupdate_session *s,
+				  struct file *file, u64 *tokenp);
+
 #else /* CONFIG_LIVEUPDATE */
 
 static inline bool liveupdate_enabled(void)
@@ -299,5 +309,17 @@ static inline void liveupdate_flb_put_outgoing(struct liveupdate_flb *flb)
 {
 }
 
+static inline int liveupdate_get_file_incoming(struct liveupdate_session *s,
+					       u64 token, struct file **filep)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int liveupdate_get_token_outgoing(struct liveupdate_session *s,
+						struct file *file, u64 *tokenp)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif /* CONFIG_LIVEUPDATE */
 #endif /* _LINUX_LIVEUPDATE_H */
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index c39f96961a85..0a4994377c98 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -91,6 +91,21 @@
  *    again later. If the issue cannot be resolved, these resources will be held
  *    by LUO until the next live update cycle, at which point they will be
  *    discarded.
+ *
+ * Dependencies:
+ *
+ * Preserved files may have dependencies on other files that also need to be
+ * preserved during a live update. A file handler can resolve these dependencies
+ * by querying the token of the dependency. That token can then be serialized
+ * and used to fetch the dependency during the retrieve() callback in the next
+ * kernel.
+ *
+ * Some of these dependencies can be resolved late during File Handler freeze()
+ * callback, but some of these might need resolution during File Handler
+ * preserve() callback based on the constraints such as immutability and
+ * performance. This introduces an order of preservation. Note that the order of
+ * preservation of dependencies can be safely relaxed later, but it cannot be
+ * enforced later.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -284,6 +299,7 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	mutex_init(&luo_file->mutex);
 
 	args.handler = fh;
+	args.session = luo_session_from_file_set(file_set);
 	args.file = file;
 	err = fh->ops->preserve(&args);
 	if (err)
@@ -341,6 +357,7 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
 					   struct luo_file, list);
 
 		args.handler = luo_file->fh;
+		args.session = luo_session_from_file_set(file_set);
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
 		args.private_data = luo_file->private_data;
@@ -374,6 +391,7 @@ static int luo_file_freeze_one(struct luo_file_set *file_set,
 		struct liveupdate_file_op_args args = {0};
 
 		args.handler = luo_file->fh;
+		args.session = luo_session_from_file_set(file_set);
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
 		args.private_data = luo_file->private_data;
@@ -395,6 +413,7 @@ static void luo_file_unfreeze_one(struct luo_file_set *file_set,
 		struct liveupdate_file_op_args args = {0};
 
 		args.handler = luo_file->fh;
+		args.session = luo_session_from_file_set(file_set);
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
 		args.private_data = luo_file->private_data;
@@ -587,6 +606,7 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 	}
 
 	args.handler = luo_file->fh;
+	args.session = luo_session_from_file_set(file_set);
 	args.serialized_data = luo_file->serialized_data;
 	err = luo_file->fh->ops->retrieve(&args);
 	if (err) {
@@ -620,6 +640,7 @@ static int luo_file_can_finish_one(struct luo_file_set *file_set,
 		struct liveupdate_file_op_args args = {0};
 
 		args.handler = luo_file->fh;
+		args.session = luo_session_from_file_set(file_set);
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
 		args.retrieve_status = luo_file->retrieve_status;
@@ -637,6 +658,7 @@ static void luo_file_finish_one(struct luo_file_set *file_set,
 	guard(mutex)(&luo_file->mutex);
 
 	args.handler = luo_file->fh;
+	args.session = luo_session_from_file_set(file_set);
 	args.file = luo_file->file;
 	args.serialized_data = luo_file->serialized_data;
 	args.retrieve_status = luo_file->retrieve_status;
@@ -926,3 +948,65 @@ void liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 	luo_flb_unregister_all(fh);
 	list_del(&ACCESS_PRIVATE(fh, list));
 }
+
+/**
+ * liveupdate_get_token_outgoing - Get the token for a preserved file.
+ * @s:      The outgoing liveupdate session.
+ * @file:   The file object to search for.
+ * @tokenp: Output parameter for the found token.
+ *
+ * Searches the list of preserved files in an outgoing session for a matching
+ * file object. If found, the corresponding user-provided token is returned.
+ *
+ * This function is intended for in-kernel callers that need to correlate a
+ * file with its liveupdate token.
+ *
+ * Context: It must be called with session mutex acquired.
+ * Return: 0 on success, -ENOENT if the file is not preserved in this session.
+ */
+int liveupdate_get_token_outgoing(struct liveupdate_session *s,
+				  struct file *file, u64 *tokenp)
+{
+	struct luo_file_set *file_set = luo_file_set_from_session_locked(s);
+	struct luo_file *luo_file;
+	int err = -ENOENT;
+
+	list_for_each_entry(luo_file, &file_set->files_list, list) {
+		if (luo_file->file == file) {
+			if (tokenp)
+				*tokenp = luo_file->token;
+			err = 0;
+			break;
+		}
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(liveupdate_get_token_outgoing);
+
+/**
+ * liveupdate_get_file_incoming - Retrieves a preserved file for in-kernel use.
+ * @s:      The incoming liveupdate session (restored from the previous kernel).
+ * @token:  The unique token identifying the file to retrieve.
+ * @filep:  On success, this will be populated with a pointer to the retrieved
+ *          'struct file'.
+ *
+ * Provides a kernel-internal API for other subsystems to retrieve their
+ * preserved files after a live update. This function is a simple wrapper
+ * around luo_retrieve_file(), allowing callers to find a file by its token.
+ *
+ * The caller receives a new reference to the file and must call fput() when it
+ * is no longer needed. The file's lifetime is managed by LUO and any userspace
+ * file descriptors.
+ *
+ * Context: It must be called with session mutex acquired of a restored session.
+ * Return: 0 on success. Returns -ENOENT if no file with the matching token is
+ *         found, or any other negative errno on failure.
+ */
+int liveupdate_get_file_incoming(struct liveupdate_session *s, u64 token,
+				 struct file **filep)
+{
+	return luo_retrieve_file(luo_file_set_from_session_locked(s),
+				 token, filep);
+}
+EXPORT_SYMBOL_GPL(liveupdate_get_file_incoming);
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 64879ffe7378..dac6644bfb18 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -77,6 +77,23 @@ struct luo_session {
 
 extern struct rw_semaphore luo_register_rwlock;
 
+static inline struct liveupdate_session *luo_session_from_file_set(struct luo_file_set *file_set)
+{
+	struct luo_session *session;
+
+	session = container_of(file_set, struct luo_session, file_set);
+
+	return (struct liveupdate_session *)session;
+}
+
+static inline struct luo_file_set *luo_file_set_from_session_locked(struct liveupdate_session *s)
+{
+	struct luo_session *session = (struct luo_session *)s;
+
+	lockdep_assert_held(&session->mutex);
+	return &session->file_set;
+}
+
 int luo_session_create(const char *name, struct file **filep);
 int luo_session_retrieve(const char *name, struct file **filep);
 void __init luo_session_setup_outgoing(u64 *sessions_pa);
-- 
2.55.0.766.g2966f0265a-goog


