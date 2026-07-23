Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85E36C531F7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 20:29:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25E5A6B0095; Thu, 23 Jul 2026 16:29:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E83D6B0096; Thu, 23 Jul 2026 16:29:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 124E76B0098; Thu, 23 Jul 2026 16:29:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D9C7A6B0095
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 16:29:30 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6F07E1601A1
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 20:29:30 +0000 (UTC)
X-FDA: 85021181700.14.841197F
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf03.hostedemail.com (Postfix) with ESMTP id B259920006
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 20:29:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hLte5DoA;
	spf=pass (imf03.hostedemail.com: domain of 3p3liaggKCH4umjcyclciqqing.eqonkpwz-oomxcem.qti@flex--skhawaja.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3p3liaggKCH4umjcyclciqqing.eqonkpwz-oomxcem.qti@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784838568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jKy1+xh3t540cHOpDayVgEdD7bHubSTIw9MAGeaiEnQ=;
	b=DA1nw0dFw9kp57Bl/mjxoVKQPuVZi+o49Llt8HQKe80RkvaP+512p9Fgs5lHyuefBI2u6y
	21pqsxb2GpvxlH6v7vsOK68GS46dw+CjIPpEaom/ZqQ9JnCzF09zLIE+CDGayXVrBE1LYJ
	j2xkMjuPWsi6RJ0DytzimU9DbFErlp4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784838568;
	b=omnU/4lhwsAULj7se+zVEZyf/jBn0m9Kf8yA/BFcBV9Xfs4wpTSPP6L2/XhRxNegwkQtke
	BExasrXLRbUK4lo0tEL7VsjLzuUjdLiSL5QrFCE7vwawszcCm2i8OJX9ASNarOQwHKIcL7
	abG5dslZhyFGy2qxNHON154CcYYE1HE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hLte5DoA;
	spf=pass (imf03.hostedemail.com: domain of 3p3liaggKCH4umjcyclciqqing.eqonkpwz-oomxcem.qti@flex--skhawaja.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3p3liaggKCH4umjcyclciqqing.eqonkpwz-oomxcem.qti@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cf1c86963bso8705345ad.0
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784838568; x=1785443368; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jKy1+xh3t540cHOpDayVgEdD7bHubSTIw9MAGeaiEnQ=;
        b=hLte5DoA87mlsAAMDY0011hB/+F/YLM1WWfV59bQi5/IL+fWkyJrQcXyZ9BzD4oM3j
         UuiiDgYoJzgE5lIXwKkFTk+JTv45iszBrATBgnaw8rI6shN34l45/l9mwlNgL6UfI6mE
         6ANuQkiR4wFEhEpbp7F+X+4c2QKdcaqNiP43jy1Xw7Hi7be7Fdz3pY+vGaF7NMCnAO3/
         nLLD1AvWGAtcYZsCRWktTTEOFsjEU86oYEY5eH4CjcKgTZNoyFMLcaaQ9OCDJqVovzj1
         r5CsRQJuf7im5QCVv2OIOqWDys0DEpRdYNlveOws59v1/TCiJbxpNMOMGsxACwm7faRC
         rYoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784838568; x=1785443368;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jKy1+xh3t540cHOpDayVgEdD7bHubSTIw9MAGeaiEnQ=;
        b=sZxfrPRSEZ15I0dWCrryRgBxvA53t+WevfM0iK794IbguOxqV2lMhfJN8ZisCGvlE3
         7uqsQ794LVsfR9bOWe7FYqiUrM94Whel0U+6rBMml0/UP3eCCd1myKYHI+/8u8U7P/kp
         6ocqnRkeWdkvQzIXsHJE/8Wm5IGCrH2otntfixgZquqstT1FRsP2ETaRFLdKi+f8MA1A
         9vBbeMGnGl8YFU7oUUEYSwOFb3e0BIkq5WGLVZkAKAtE9pRsQvjhmqMREnlIf5KjcQr3
         lj3YkAIyef3AEobJ2oVqzPoEM24tDvx5woCBiakj3z2OP79jWuDg+oZ9bQh6OS/dgfMa
         MWjg==
X-Forwarded-Encrypted: i=1; AHgh+RqX1xv3cLFJ7CAXF2hM0Xh4K5DVTUuuHirncvAYmyo7np6GpLDzBJa7F3UuegYm1nJj4ywouxPeDA==@kvack.org
X-Gm-Message-State: AOJu0YzWJ0mbiR7P2FqdZAmZZpNo6A424mf62PiZq3ohdsRaM2JJuDBV
	MNhjx+g/MZmvE2farNWRUM/cq4W0gX/zekEMT51NbZFEm8/bKksqxcXWnFuoiq9sWe9Mnfnj02E
	iVVrI9f/v+mmOBg==
X-Received: from plbka16.prod.google.com ([2002:a17:903:3350:b0:2cb:ea2b:5286])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e84f:b0:2ca:c847:8e41 with SMTP id d9443c01a7336-2cfa94b7aadmr48476855ad.11.1784838567356;
 Thu, 23 Jul 2026 13:29:27 -0700 (PDT)
Date: Thu, 23 Jul 2026 20:29:12 +0000
In-Reply-To: <20260723202912.1467112-1-skhawaja@google.com>
Mime-Version: 1.0
References: <20260723202912.1467112-1-skhawaja@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260723202912.1467112-2-skhawaja@google.com>
Subject: [PATCH v2 1/1] liveupdate: luo_file: Add internal APIs for file preservation
From: Samiullah Khawaja <skhawaja@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: Pranjal Shrivastava <praan@google.com>, Samiullah Khawaja <skhawaja@google.com>, 
	David Matlack <dmatlack@google.com>, tarunsahu@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, 
	"open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: B259920006
X-Stat-Signature: yfjxwinb7gpugiopcqpcxsfhd4w6bqwm
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784838568-576430
X-HE-Meta: U2FsdGVkX18u3arABWDlcgL31UoPRRDjDEtXoCorfxq4u1DLfpaS8A+ORL0HIFbNcokhsAZAcaSk4td1Rgna+b9DcK491IpPL5XYHpnCEb5EyoQhPZAYf0pUrXmUyNZsmVQmNmgqDxzu0zQXjUrMNbkN/VxlRndMrYxsupEFgSzJGdW977prwnf2WJW3yQDLK4YhvfiX/BoZBc6760CGgbElwQBfPDAKxGFsR9O8qzt0vcYEqkoIDpKVtFCGyXSjKr8RgPdtcTyLJli3Je3IRuplGg8lMQdh1wE959jOqhwhiWUozciokLPEBFZ6UOiepJUZzgsaf8038P5vXgkps+N1bqs8Qz1UFjkdkbgVOa1Xiw38uqvD/WRJbmzfA7nYYr2vMAXR8LPQNx9asSCWFK1XmXh46y3QaMrilcX07LdWajWKcd5bCDmUoQ8y5Vg1aye1NCHcSIO+CICMTy+2Wkxaq0rvwlt/u7o7TxGKBADSqCljHqPagP2vEhyjEIvKrHkfPWEBtv/j3PFdqawUirfdexkK1/J6mkaqZIyf8YVl99fF29Ucd4hOsk+0xMtoOI5HOb4Gesu0DdKPjZldMpX2Ep4FLITP+BuxX34FbnWmZ/OkXHlwzaMcm2UgH7Ws6AI8dT8xb1D8xwLgYG8MO1eIjHFXgIfxrxbDaUBNe5qzkRodzKWbis9cS+3y2ZJkENBHNynIo061PHPYAs6SqbxVnUdEabGu8YV/yBs7UGpB30vihCIaG1rJAPAFs1stJVYs0m2NRRx+apaMfISpwLK46R2bprNxB0wuFb4ulYVoreHsYRRVjlxNZXhDncG1o2vyTc4rl0HLraVgocx0Sanl+bO0jT1/mb2tG54LMvRD0dPhwj7Jir0gh69hJRO36X6l+VcxBMH9Lk0F5nFiadgTs7rSbGgKctVGnxbleWlPbRCSMULvVkGIcMxVjpASnpSfiiuK1KA1piA3Il7
 7TBDfT2/
 xcQdsUMctT42lgVuZKsNW+QdW8QAhJ4tozjjHw/XMVzWk+GwxWFJf+tVyBQ4Wo4q+tUAq2Z4cRiTKR/yJ0paWi76QM0K7hhLtMWJM3BJo8c9aNExx8Un4wETdFCoCwpNGqwzFYywDjPT+lD7dqQcEt/Lqi6F8gYg7zeEygy+L4SN6Tblya7q8dqDuK69eb3E2fob/+0fls72NHvXLOF7JI9mnT0AMHzxxGiNSrspeUnJj9c9N5I1l32js2Yda/2jng1If1QdcHy1cKaP7tkW+2pZG65rDWioEnaINB6daR5q/kto+TEGrA5x8mSiKUT81yjICOjfRhXP4dW2VApKhIDuSgM8dx6AHkzCAB6rwhfwLgH7fvzsPTzXRHEpGIQOIBOaiwNYN6uSbXXW0Cd2imWsWR1oU6a99vFTTlsd1GSpoFxUycn4oNm9nFkqEdqZ+tL1Giou3vdyQBiJvaZUEDeHljM9G+tzakLnKlQnZOOzDYSzlrxTYzhMVbiG+LoBY0YIqYsGNxeBDcO9ReoHvkEycPbqSnDKZZ9clrDQxHGQ2hRrHFwRqjeOLu6kwMsEsJrdP+JOC+5HodL6qmDn2cWeL67cXHll1mgo0eEVwNzJTyYRUwr/WsFW+Gr9JkagsSRZp+W4oNwMmGAYLgJvBNu7pFgvGVK3bmgallUqqv7bZmNtDhRl2QeH9tRFYybs3hzLg
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
 include/linux/liveupdate.h       | 22 ++++++++++
 kernel/liveupdate/luo_file.c     | 69 ++++++++++++++++++++++++++++++++
 kernel/liveupdate/luo_internal.h | 17 ++++++++
 3 files changed, 108 insertions(+)

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
index 72f8bb90b66c..542707e8d8c1 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -293,6 +293,7 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	mutex_init(&luo_file->mutex);
 
 	args.handler = fh;
+	args.session = luo_session_from_file_set(file_set);
 	args.file = file;
 	err = fh->ops->preserve(&args);
 	if (err)
@@ -350,6 +351,7 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
 					   struct luo_file, list);
 
 		args.handler = luo_file->fh;
+		args.session = luo_session_from_file_set(file_set);
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
 		args.private_data = luo_file->private_data;
@@ -383,6 +385,7 @@ static int luo_file_freeze_one(struct luo_file_set *file_set,
 		struct liveupdate_file_op_args args = {0};
 
 		args.handler = luo_file->fh;
+		args.session = luo_session_from_file_set(file_set);
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
 		args.private_data = luo_file->private_data;
@@ -404,6 +407,7 @@ static void luo_file_unfreeze_one(struct luo_file_set *file_set,
 		struct liveupdate_file_op_args args = {0};
 
 		args.handler = luo_file->fh;
+		args.session = luo_session_from_file_set(file_set);
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
 		args.private_data = luo_file->private_data;
@@ -596,6 +600,7 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 	}
 
 	args.handler = luo_file->fh;
+	args.session = luo_session_from_file_set(file_set);
 	args.serialized_data = luo_file->serialized_data;
 	err = luo_file->fh->ops->retrieve(&args);
 	if (err) {
@@ -629,6 +634,7 @@ static int luo_file_can_finish_one(struct luo_file_set *file_set,
 		struct liveupdate_file_op_args args = {0};
 
 		args.handler = luo_file->fh;
+		args.session = luo_session_from_file_set(file_set);
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
 		args.retrieve_status = luo_file->retrieve_status;
@@ -646,6 +652,7 @@ static void luo_file_finish_one(struct luo_file_set *file_set,
 	guard(mutex)(&luo_file->mutex);
 
 	args.handler = luo_file->fh;
+	args.session = luo_session_from_file_set(file_set);
 	args.file = luo_file->file;
 	args.serialized_data = luo_file->serialized_data;
 	args.retrieve_status = luo_file->retrieve_status;
@@ -935,3 +942,65 @@ void liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
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
2.55.0.229.g6434b31f56-goog


