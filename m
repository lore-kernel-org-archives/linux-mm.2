Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45B9ACD8C81
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 17:08:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB0DF6B0095; Fri,  5 Jun 2026 13:08:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 952DA6B0096; Fri,  5 Jun 2026 13:08:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CCFA6B0098; Fri,  5 Jun 2026 13:08:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 667386B0095
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:08:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0399012020F
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:08:45 +0000 (UTC)
X-FDA: 84846493452.16.B073B85
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf02.hostedemail.com (Postfix) with ESMTP id 17B1F80008
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:08:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uhgo97OU;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 3mgIjagkKCIM0hy1uzho1nvvnsl.jvtspu14-ttr2hjr.vyn@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3mgIjagkKCIM0hy1uzho1nvvnsl.jvtspu14-ttr2hjr.vyn@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780679324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sEhWX52WJkWVDfmrghr6xBIC6ipJnjUdorl4P8GP66o=;
	b=UWWbJHd9DdkmDjuRVy3Npz1wdZSYXzMfoxe39NO9KZMt+yOmzFylepSg2XPR31uaU0l4Yj
	uJvwbaZ7039TwzQBFclR7KbSxqOEXi4SlQ9Obx8trLaFFQ02zTCdK7jcd4lSUUPO45dKRK
	j/1lk3xiuyH0MnA5vzcV3N2H36LP88s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uhgo97OU;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 3mgIjagkKCIM0hy1uzho1nvvnsl.jvtspu14-ttr2hjr.vyn@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3mgIjagkKCIM0hy1uzho1nvvnsl.jvtspu14-ttr2hjr.vyn@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780679324;
	b=KhRZnBT2E6oyS0v+mY7FH6uQ8Z5j0nymFVC7hqKk+ikerWVLWcg5N9I7wmkUmPapZQfgZY
	nB9X7++QPrxqCZ6bHNZLPTr/5CWp8a3uii/kSVQNr8gDN5JzAqC7JHrj3jdOWG2EhxXVg8
	c+M71j5M2aJrF2dNGDAwP9pYqM3PImQ=
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-68b5941a81bso3371374a12.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 10:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780679322; x=1781284122; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sEhWX52WJkWVDfmrghr6xBIC6ipJnjUdorl4P8GP66o=;
        b=uhgo97OU+Evj5VbIomI9/P2pbH0xsNhyAamuiIrAfI8dqpYV1IsscFbBPdHPl0TMcH
         +ys8uHLLkC7fBzQ7CaH9yjyz7RBgrrOy0GVxkBR0ShW20mKNXH53LOyvcaroYsqEmFJA
         y9BzRcsMEz9QUT/ETEKWea+NiRnjlTNm5qBElwp46BMnm7iDezKVqv84FdiqFYeAnE2f
         rALnQUpw9w+P3W85ewcIG20ZRrgwZNBTplXXOOMG/hWSSvsU0YpLxuusL+it59aem2Rr
         7P68lWv89f4ErIYTAAl/Drrzz8WFlUazq8n6iG1gqnmOcNmq7mMNQ4KMyeNCEF69ShUV
         NhLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780679322; x=1781284122;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sEhWX52WJkWVDfmrghr6xBIC6ipJnjUdorl4P8GP66o=;
        b=ggiUEDgbUhLzlYMgf3PHlpXbqz5c8k0cx5cVAoy+sy5ejtZQJby7gXmigsljXj+Pre
         fy7td98P8monXl/ox/yjt8Y1oNFh85I3DkH0J3F2tWJcMW8iGFqUr4cy8zqwj9X31Y4P
         nEIlKWF39DcIetqGqq0unmqzoG15DIYg3UV+y9PnMDSb5kWOwLex8pZScSuTs97QyZqL
         wv3cU0/LoahvUpHvvzG5M4+U1FDXxdFJTZ9rj3zPW40YXVD9r1/XaUCA86/KXmPyqZLN
         X8vemFWr+EyNjxiIfILhZc6qJlc6kC8hncA2ugr9RDNq1A8/acDXDG7ou7FTcHD5gciF
         KNQg==
X-Forwarded-Encrypted: i=1; AFNElJ9eddwARanmWeVbrgCR65fBgX6cmAfnGyX/z1vaBf1GTioNeKr46soqN2l7NYgIj0ZHeM5FXrYCMw==@kvack.org
X-Gm-Message-State: AOJu0YxihNcBx0s5uqg4z67fYyhDU9xrAaZXa4Ls1Pd36akYmZoDVZ6+
	+Neuny+YzR28IUcvDzrsT5uvHy+wxuOKKgw/5oqkDnio9y4zbB91JNb9tn9WfyC5jGbOvhL/07v
	exIhbwmL5XcTosJMm5A==
X-Received: from edt19.prod.google.com ([2002:a05:6402:4553:b0:68c:e5b:594d])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:2713:b0:68f:cd4c:7297 with SMTP id 4fb4d7f45d1cf-68ff24931b8mr1539369a12.14.1780679322099;
 Fri, 05 Jun 2026 10:08:42 -0700 (PDT)
Date: Fri,  5 Jun 2026 17:08:26 +0000
In-Reply-To: <cover.1780676742.git.tarunsahu@google.com>
Mime-Version: 1.0
References: <cover.1780676742.git.tarunsahu@google.com>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
Message-ID: <c054ba0fb2639932bbe354420d3f4f84cce84905.1780676742.git.tarunsahu@google.com>
Subject: [RFC PATCH v2 01/10] liveupdate: luo_file: Add internal APIs for file preservation
From: Tarun Sahu <tarunsahu@google.com>
To: Jonathan Corbet <corbet@lwn.net>, vannapurve@google.com, 
	Tarun Sahu <tarunsahu@google.com>, fvdl@google.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Shuah Khan <skhan@linuxfoundation.org>, sagis@google.com, 
	aneesh.kumar@kernel.org, skhawaja@google.com, vipinsh@google.com, 
	ackerleytng@google.com, Pratyush Yadav <pratyush@kernel.org>, david@redhat.com, 
	dmatlack@google.com, mark.rutland@arm.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	seanjc@google.com, axelrasmussen@google.com
Cc: linux-kselftest@vger.kernel.org, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kvm@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 17B1F80008
X-Rspam-User: 
X-Stat-Signature: 3my7fpirwcotw1kfacbc4teca5ownpcd
X-Rspamd-Server: rspam09
X-HE-Tag: 1780679323-385623
X-HE-Meta: U2FsdGVkX19FQ6EhMeex9vJCcMmdPAJJhdPIpYTCHC2BriRheugMOclb49XUxER+1DsS2/gAhwWrsrTpQM0Hm56kn9nLyiBLx/1SQK3drkX6R8nHT9cWat4uKy6rmtsqMFl1MZY9fwGVTA4F1UKDXnTCnr63BjhBRWwy6ppjuWSJePPEN/Uz+5iuvFruVhpmqDNCvwNmTyl0hwMipRV2kB/TVrbLaMXctdYwuwOWLmI2oBqmmoOPqKXJ61GY4qAGuIrEJ/q/nmairq9bU9UByWfQmGIfr71CfO9njZ5V3oHYpMMOLbU679rNGhWp4ewKoSyXj/ZlxGL2cSf8000a61hiPnzUU+xZ0Q94MdL1GT4l/ClvhdE+11NFXsdAJS6CwBSO7CncXOX47IPV8Y8sPnLoS+dgL51r1k9yFZc/AjAXN40zqa2XVB1wLV4GZDLHOG0KRdhqpMa3JG2e2liVYxO0Qfb6K2ia1h2a7lOS12R+IwN02hxZ+PsTNNu1YUhgA31AFbrk2pdSo+kgWyU4e3VF+86EDNXCYmfPYKBUiwvZABrZodL91k189OW0IGuPheokvnLtdY9zSnqU6RRpn/EiS1teOlXG4Fe/HW0JYysY+QH6AQgyKodNSM307xI+EQpEOUypmhwzbUzKoiX6hqfioCXR1CGCgckZa8jD2+tYt0Bz3d7lNkrhazdpxfkrrYaEcOI1jlXwuzcRrZNLA3GJ/mCtSB/LePgOxpk1EzcNhbOxFFO+dBku0TCezuzWsxVHJJp83JZtHMWgC5GXVUpktMY4H+n3eX7JPMW/hWwFX76fOHFIyrIuDwNbwgOEtQehP0Uv7h0UQ37Kmiw0ZXVSwwkF+zNnhl5zuKzbfLCZB4K3dcJHKVEn8kj9p92c8DmvR/mm5Q7DdFqmUXxdn18eMdez0B4tD8TlXowkxuzDjf/qeHlyJRXjULVrcEd8K0yeqEhwn4c8Z1jnuzf
 i4V6hMvx
 NelFXzj3ANbkhhEHYvFRQFCMxfeS2s7CAQyMXbBWFH7K4uiP8xC2lLIpmJ8jiUeLRpnG1Lta1Lg9YkrS057kTMeDxxZbch0fh+GvxthGNgMl4CW394Hh5UfwO8CdhKyUN2r2ppU/LiO2OMzornMH/aTnH3qCbVuwdKynY41ZetHU+eTgJMGB04DHqwlI3vr5lPg0Me72pE+qQ4y4z2+O5TxN4Zj9hRQNAb52u+CmsynU3IkVMXtSudXicc6VhGIHggnAhybshyNJXf3Iiyb+om3VO3tRIJKXf3HbojoGdr6r6t7q/XdnGsA2+8qfMmlXSF7HGxVfj/EPGEwDE1/z+2kCHiHcspr1nxQVA+hLMuEI1AG/XDHrcaHSHi/rnBiAu9IZz0nG2JUkYrzCZ2VLyCk5x0DTOFzx22hlcEENqz579p5NOxJN7pO8tA8+GClmj2m5lTunClEhE6TAdIKQs5ZQC/EyiTzryHUUBVk9BFwXq5jeYu4mGG+Bi/HGlKEkq/OwgNOYe56uqkojKOXuvKJE0sjiZMdNcLnKbJyjRjOnJE3ESk5McJ9TX5GXm8jh1x2n/JjPlOPIgCA0oQL8OjrXcyUvIdXL/mTTcjR+X7lz2PXMA1fKS4FVZuCHpqzvIgfQzT45NIeKPLzJ7JkWxsaDJ+kI+aeI8iplQS5ysSBKyulaVJLV4WHAZpDzmn9uqaLFSukqVDedsNXGo0DtitLxYFoFxDqEZuoOyXx/4umBdUJLb0XDr8STZSYFtkpFWuJuy
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
2.54.0.1032.g2f8565e1d1-goog


