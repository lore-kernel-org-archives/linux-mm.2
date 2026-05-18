Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D248ECD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 09:36:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ED926B0092; Mon, 18 May 2026 05:36:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44FD16B0093; Mon, 18 May 2026 05:36:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38CC16B0095; Mon, 18 May 2026 05:36:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2C0186B0092
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:36:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EC98E92661
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:36:46 +0000 (UTC)
X-FDA: 84780036012.24.8E0A3D9
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1507BA000C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:36:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=glyNgupC;
	spf=pass (imf25.hostedemail.com: domain of 3q90KagkKCOgdKbeXcKReQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--tarunsahu.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3q90KagkKCOgdKbeXcKReQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779097005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=as26CSLWhv9riXhwc0+6uzjiz4k1n6M2f5huVsJsy4s=;
	b=Id6VyDXbZKSodfe6IqKdDbuBFWWKQQqpRtnrPp0S6JUwn8Z51RPlvmc03fyPULOg9Aq8Od
	ZE/X1g4gFYohOxSG5EWj/rlcesn/dAgvIOJ1yVSr1hggKXY2ToB8SqgkdeBkOzNRshCLvA
	ntvGYW8F2+nCPADsNYn5hxgizjrROdI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=glyNgupC;
	spf=pass (imf25.hostedemail.com: domain of 3q90KagkKCOgdKbeXcKReQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--tarunsahu.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3q90KagkKCOgdKbeXcKReQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779097005; a=rsa-sha256;
	cv=none;
	b=ql6VktFDhx2fOAcmxEr7T91Iu8XBFPWCOx1oidAVgsYon2X6z2w4kzBFrarvIP+elQk9Ip
	EzFzdDdxurLDGpFEqskbUC2SjY4bXgmb21iIFv701BXNbxNXZdbjgpq7aVwQeRAJI4OgOJ
	kd7eboglyk9wFFAsIUizess1nkpsZ3s=
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-67fd8b662ecso2126259a12.2
        for <linux-mm@kvack.org>; Mon, 18 May 2026 02:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779097003; x=1779701803; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=as26CSLWhv9riXhwc0+6uzjiz4k1n6M2f5huVsJsy4s=;
        b=glyNgupChxzNxKtPAK8fndSwcZPkWWerxFhx3zN3UntLgR4JL52qrIxvuGMqUlWqlG
         tfR2UR0HCtuk+iVilqZ32YX9CA0MaK/0I6E0b3Id3resc/gwvvJ4t+WOJKUlUF1qNecq
         3GWpZopo23CzGoP1ORLUjkr89THT2T8WqMSbM8WOkhtUAkEQaX8tTJ049d1c6xvs4bR3
         J15z6sfgVtGSCxHtaI4BXGc8YCwdjn6tG54POOcaU8J6XUsAKnyLqOaNxSKUc4jIWaTh
         baxRHmBMf0xY3al8VMiTFMWQE+ygNSZ/zNyQqeM3bih3M2gVznx3yx9xm1vjc5yiOp2L
         eBMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779097003; x=1779701803;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=as26CSLWhv9riXhwc0+6uzjiz4k1n6M2f5huVsJsy4s=;
        b=jA7k3v3ZnJJDWb9fmg2oz2iH6lLH/ECFM9h9CtutoNOfJXBqVZlWmStF/l9jOnUq4u
         VVWgRGNuMUVL+ZFoPGlil/TDofjjRDzt8U0XDouwxl0jT/qMJpuJBfPGtEWyJ6I3rLpJ
         XNDR3lqZFcLoFdZMG6oQ8xp+xeJccbcEBEn1O5YolIXZ6a8L80S47Wv1pNvOa7pUPwdQ
         Drlkkc4wlk82SAIEmwbskvjblrbSc2MvMGbZC86utRC7GmZ5gIcX7OBBe4epn1piSkrw
         tZFSQBfCiY3xBnur/zKevqIsoOFkt6rAFcrZrA2TVUV7/CtHiHb+bx0BS4nu1EXzBJCr
         JPHg==
X-Forwarded-Encrypted: i=1; AFNElJ83jcoq2dEOjmkhQjYTx+jn2Xh4CzPoOhvK0JGeM01oMTmsBMRj8MILjI/l2CBDNR/Zwd1v+9HvMg==@kvack.org
X-Gm-Message-State: AOJu0YzG0RiIO/1J/lrqhDefHOc4kD26eBhcUBeO6cvkYN0ZRD1l6JAg
	JOiv89QuDZIeAZuEYv2qB6qGXIpYFfYUKCtZsPOox0gKNpG+XWAOsAydZqifCSUAML5j1A22Hbg
	Y0IWRt1bkX4KaDFkRhw==
X-Received: from edxa5.prod.google.com ([2002:a05:6402:13c5:b0:683:d667:6d6c])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:24ce:b0:683:5306:d41b with SMTP id 4fb4d7f45d1cf-683bc5ba630mr6644571a12.7.1779097003267;
 Mon, 18 May 2026 02:36:43 -0700 (PDT)
Date: Mon, 18 May 2026 09:36:31 +0000
In-Reply-To: <cover.1779080766.git.tarunsahu@google.com>
Mime-Version: 1.0
References: <cover.1779080766.git.tarunsahu@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <9ff4237649ace8b7eb78f3c3ec9ffaf5ae49ae6a.1779080766.git.tarunsahu@google.com>
Subject: [RFC PATCH v1 1/9] liveupdate: luo_file: Add internal APIs for file preservation
From: Tarun Sahu <tarunsahu@google.com>
To: axelrasmussen@google.com, mark.rutland@arm.com, skhawaja@google.com, 
	Mike Rapoport <rppt@kernel.org>, sagis@google.com, Jason Gunthorpe <jgg@ziepe.ca>, 
	Shuah Khan <shuah@kernel.org>, ackerleytng@google.com, corbet@lwn.net, 
	dmatlack@google.com, Paolo Bonzini <pbonzini@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, vannapurve@google.com, 
	Pratyush Yadav <pratyush@kernel.org>, david@redhat.com, aneesh.kumar@kernel.org, 
	vipinsh@google.com, Alexander Graf <graf@amazon.com>, David Hildenbrand <david@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kexec@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	kvm@vger.kernel.org, Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1507BA000C
X-Stat-Signature: exj5ckfkjk1116ak88fchui778depxmi
X-HE-Tag: 1779097004-509392
X-HE-Meta: U2FsdGVkX18iclmqM88TH5S4dFb9TayHh+4IT/yWog4Z9w3fQpHRPleevHDUPelsejAdFzU/oKywV2EOiDKlgljreO13hzcW3MfMFKBMxKUFsa8CTT76PJYpd0TnloYkrG3Mbh7fnlA0k4W9rGfq0WKFExQLg9JnwwpriOTsU0iPOCPB9nKNzrOE5iHro40cXZpo4DZide57j13lqiXIq0ppGUJC3JFNa7MdPowD4C9k4/oFiSEW5ahv8iFD5oj/lQOY2X3jnKah13XaiLQSocm8M6edDKl4qwqSWQPG6AT5rgXJWg9r9veKte/JH053EyKA8Cfu4kc03vZ/lfyrq02f6cB6qNoBLbmv9YlSB9rpb/X+kh8FQQlcmvJOq67lm+sBKmoYN0DN+nK1d2WQ3IgtBv6P5ZjtIp1WFMCpWXmN7Z1A5iUu5cYRmp/NPbTERe40WEJ4OzpXNE1P5TIvQkUqBCIXPxRdXFBjb5sU96owT+W1+BRmWbZ/gEOF4wzAuuXMn8XaI+G8yPeRRtI9e5UHKAnp2KA+sh2rKBaSVf3G2fv3FpSeAxcoeK1EFSNrFhcp/vgIljY3Ck9y8KJdlStnmX/fwKEXi/B8ST0ZIXV/62hCvRCCkfYGiEQSeAcZlKvxrmP3J1XUZD8M0Bg4UoNDenBp3tMIbNa+zONGG/6WoW5hER4dms798Z5aw5E5xBDYr2sKC9o1gAE1qwvNzjpsB0PoXzPYwvT4DZCg5eLY8Pm8DbLcIIUarnZBF7dMVgvnvINLdPBiZQWTcQfwX/7tXoWq7BwZGsfSRRsDo3tXcQlARMz3T7Vdw/WvMy5efJcOoviw8UA6R0W14Q3YTntVgP1TvJFxUCHLAebqJ7bwy7uKjgy+C43zxGogMwnsbzVTqwOUurMXZ0z9aQXSj6NCXxMHasOwN/kWRwx8jqSwU4vf/SUAzyjiVVVG8ttcBeiUdl3q2dLyXHlZpeR
 7eXpl2xU
 w9JhKW3TWB3OIHX8K4jnv/lAjDshPZSgvuf5dAlb6WV634NP48GT1+7JuB6qMrd5a2iejIurU9U2zip76AwX2xXBCGFv1c+Ow7B3AEdcSY2gkoG4ivESx56WT1lBT+2lDOmfNd9qdvIChjvjQ52newxlzbyH0yZ52aike4IThyXOYDUNM3Uiq3s5rHI2yB2RrBru8NUJS3gbj9sWwf3sdTbOh6/I2b/XuXQXRtFFy2aHDQAgdgqMr4pFyYg3q41oQkwZvYzC8paqDnHlwT/Bz2SnwsaYoTyKYp/9H80DrXb9b1zB/k1TVP2C6LYX0Wd15c52b9rw+R0V5rxvz8FyxqoRjAXeaND1S0GIpHjI3u7D78AMm+7SSGcnbnwjVGFUNTo1BsQzFY8C8BC3KViYOMQ5tsNT8yCFSkkir+TrB3gwAJdXQoHq3D7P7b10SwVxQGSOO0WVQI2zyQJxAbqqBsuZT5ja47UWND3PAbcuVqT5UFyC5IemhLalyaSsEpBIKw82hQzSBKEUhLlma05hq9aHNBdXG3zGnkHEY4kOJ0ugt+SKGo8bRpKCJs9FrtLLUd/aiBp+xF/RWUEmSEpxXOy621D+HcztBiECRYGgQLzXfbCUE2Ce3sFPim153awRvaF0aa8aOQuwo7Xy0MBl3NTyJ9SdjmJng81ZWnFbhWGbL8+c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pasha Tatashin <pasha.tatashin@soleen.com>

The core liveupdate mechanism allows userspace to preserve file
descriptors. However, kernel subsystems often manage struct file
objects directly and need to participate in the preservation process
programmatically without relying solely on userspace interaction.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/liveupdate.h       | 21 ++++++++++
 kernel/liveupdate/luo_file.c     | 69 ++++++++++++++++++++++++++++++++
 kernel/liveupdate/luo_internal.h | 17 ++++++++
 3 files changed, 107 insertions(+)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index 30c5a39ff9e9..de052438eaac 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -24,6 +24,7 @@ struct file;
 /**
  * struct liveupdate_file_op_args - Arguments for file operation callbacks.
  * @handler:          The file handler being called.
+ * @session:          The session this file belongs to.
  * @retrieve_status:  The retrieve status for the 'can_finish / finish'
  *                    operation. A value of 0 means the retrieve has not been
  *                    attempted, a positive value means the retrieve was
@@ -44,6 +45,7 @@ struct file;
  */
 struct liveupdate_file_op_args {
 	struct liveupdate_file_handler *handler;
+	struct liveupdate_session *session;
 	int retrieve_status;
 	struct file *file;
 	u64 serialized_data;
@@ -240,6 +242,13 @@ void liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
 
 int liveupdate_flb_get_incoming(struct liveupdate_flb *flb, void **objp);
 int liveupdate_flb_get_outgoing(struct liveupdate_flb *flb, void **objp);
+/* kernel can internally retrieve files */
+int liveupdate_get_file_incoming(struct liveupdate_session *s, u64 token,
+				 struct file **filep);
+
+/* Get a token for an outgoing file, or -ENOENT if file is not preserved */
+int liveupdate_get_token_outgoing(struct liveupdate_session *s,
+				  struct file *file, u64 *tokenp);
 
 #else /* CONFIG_LIVEUPDATE */
 
@@ -285,5 +294,17 @@ static inline int liveupdate_flb_get_outgoing(struct liveupdate_flb *flb,
 	return -EOPNOTSUPP;
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
index a0a419085e28..0aa0b4e5339f 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -323,6 +323,7 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	mutex_init(&luo_file->mutex);
 
 	args.handler = fh;
+	args.session = luo_session_from_file_set(file_set);
 	args.file = file;
 	err = fh->ops->preserve(&args);
 	if (err)
@@ -380,6 +381,7 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
 					   struct luo_file, list);
 
 		args.handler = luo_file->fh;
+		args.session = luo_session_from_file_set(file_set);
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
 		args.private_data = luo_file->private_data;
@@ -411,6 +413,7 @@ static int luo_file_freeze_one(struct luo_file_set *file_set,
 		struct liveupdate_file_op_args args = {0};
 
 		args.handler = luo_file->fh;
+		args.session = luo_session_from_file_set(file_set);
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
 		args.private_data = luo_file->private_data;
@@ -432,6 +435,7 @@ static void luo_file_unfreeze_one(struct luo_file_set *file_set,
 		struct liveupdate_file_op_args args = {0};
 
 		args.handler = luo_file->fh;
+		args.session = luo_session_from_file_set(file_set);
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
 		args.private_data = luo_file->private_data;
@@ -621,6 +625,7 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 	}
 
 	args.handler = luo_file->fh;
+	args.session = luo_session_from_file_set(file_set);
 	args.serialized_data = luo_file->serialized_data;
 	err = luo_file->fh->ops->retrieve(&args);
 	if (err) {
@@ -654,6 +659,7 @@ static int luo_file_can_finish_one(struct luo_file_set *file_set,
 		struct liveupdate_file_op_args args = {0};
 
 		args.handler = luo_file->fh;
+		args.session = luo_session_from_file_set(file_set);
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
 		args.retrieve_status = luo_file->retrieve_status;
@@ -671,6 +677,7 @@ static void luo_file_finish_one(struct luo_file_set *file_set,
 	guard(mutex)(&luo_file->mutex);
 
 	args.handler = luo_file->fh;
+	args.session = luo_session_from_file_set(file_set);
 	args.file = luo_file->file;
 	args.serialized_data = luo_file->serialized_data;
 	args.retrieve_status = luo_file->retrieve_status;
@@ -924,3 +931,65 @@ void liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 	luo_flb_unregister_all(fh);
 	list_del(&ACCESS_PRIVATE(fh, list));
 }
+EXPORT_SYMBOL_GPL(liveupdate_unregister_file_handler);
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
+ * file descriptors. If the caller needs to hold a reference to the file beyond
+ * the immediate scope, it must call get_file() itself.
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
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 875844d7a41d..08b198802e7f 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -79,6 +79,23 @@ struct luo_session {
 
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
 int __init luo_session_setup_outgoing(void *fdt);
-- 
2.54.0.563.g4f69b47b94-goog


