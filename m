Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58109C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 18:07:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9251B6B0098; Tue,  1 Sep 2026 14:07:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D5726B0099; Tue,  1 Sep 2026 14:07:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B28B6B009B; Tue,  1 Sep 2026 14:07:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 402306B0098
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:07:29 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D4BCA140502
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:07:28 +0000 (UTC)
X-FDA: 85165975776.02.B89567B
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0F8EEC0012
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:07:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=efbmdEZM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3XRSXaggKCD4irfyqfhplttlqj.htrqnsz2-rrp0fhp.twl@flex--dmatlack.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3XRSXaggKCD4irfyqfhplttlqj.htrqnsz2-rrp0fhp.twl@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788286047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=falXxVt1CqmyncILPaUG22UQuDMsfEGdQdvwDGt8XFI=;
	b=hz4QudDfeGUPsivCJ+JMJR2Rjn0IGMkPRrk1pk+zNtQh3ExRjzyLb2bzhD+Ve5UQvaoUxC
	O5hh2ftll+HeYQwgsf9y4kPYDZGArbHGPKsr1zxSQ8Wby5EOrlX4PmcvJOGYN80zw8dmP8
	Ma09edGtEt7HpXoArK20OAjtZNsm9MI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=efbmdEZM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3XRSXaggKCD4irfyqfhplttlqj.htrqnsz2-rrp0fhp.twl@flex--dmatlack.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3XRSXaggKCD4irfyqfhplttlqj.htrqnsz2-rrp0fhp.twl@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788286047;
	b=6r4wrk9EkJqRvZhl6w7K5SZlbiy1phQ5Ew3KCHM91Pa+u04aZgU2G5sIjAg0HKFfL7s0Vo
	3GMQX3zuiN1QS7m2KgcuCVFVLCUOQiJWWlJ+PfsU/amSfSaYovV4nhFAr/XsZiBO1Brmf2
	oD4OM7bnz1/LfwBA9QlsGcQ1/il/LsI=
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d55d8cd938so1291575ad.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 11:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788286046; x=1788890846; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=falXxVt1CqmyncILPaUG22UQuDMsfEGdQdvwDGt8XFI=;
        b=efbmdEZMRXYkWxH/0UMbVZmR3A/wCz8n7d+I9jo0I/9tb8FEo6bcm9DFxNlPjALUzP
         7LP/YW4jVYYNUkbeZ1T8UOTeIyXWkPt9YJ285dxulA6RtWWQSdY+tQJHxMJML3qav18t
         6Leme4u33HgCP7UlFkSwvPUxRcgQqaGxrzGWd9blRInlO2QX/1IklQ91d6NBgCacOr5B
         uwDtei0crBgtvyoPl2R+wFiha4QwC4z5o5G7bh/GJbfwrpXX5F0mEeN4jQt57Pe8pfeD
         XRWJRjVG8Y+xEx9fm1fph1nIbqP6xEjTLlSW9K5uTjRqydWnulg+19ByWZWC2+V1JQIx
         lAsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788286046; x=1788890846;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=falXxVt1CqmyncILPaUG22UQuDMsfEGdQdvwDGt8XFI=;
        b=gksnMxBqPuSGpJtJ8hR60ic3864UYfV4DHXITjIqPYy0fct+7yHOMo4PYIBPh5xZhL
         Tem9N2XTaX0UBuL66M/PlEr5/yQOQ956iDM248V2NhwKvxvU87yHTvZHAWcpo6FwMPXQ
         eYrsf0I3hJ5XEaHDV+AJ4TOPIl3LEnmXGXoADybJOHTwUE6x/WPRO2buJhzBS6XMyapg
         ZrWATfREddNvciPFa4O3+GEZLVFtkbEnxHomRBsAEMn4U9iWRvF/hRAes+9nXO9Zv0x4
         a32yXQnJo8ob0gZ61hfRWlIKJsAyi/GS5HQKWpoIAAwFl8tFJYTCgu8/y9B6d2ThqVfy
         5jUQ==
X-Forwarded-Encrypted: i=1; AKwUvByfsKFJn3g4tEIGu/A1iOW1Ltr8pxJc8ugrCXX4u3/JsHQYjuY6hR+owl/eFObsAoygNxLPE78LRQ==@kvack.org
X-Gm-Message-State: AFuF++ntoE8l/B1vjmjgs76BH/tO8TJ8jnAXW+IJHnE83gepqNH043r4
	h7SGmcXa29OSRj05PbnU9Ge1ZCvyV04FKjaE5VoPrI5aZ6FKfgV7+ybDxkFsJaQQcbbaMXsEQm3
	cnLL/XDVlWbm7fQ==
X-Received: from pjyv9.prod.google.com ([2002:a17:90a:e989:b0:396:5ba1:a6dc])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3c44:b0:398:dcef:c040 with SMTP id 98e67ed59e1d1-398dcefc24amr26801689a91.19.1788286045592;
 Tue, 01 Sep 2026 11:07:25 -0700 (PDT)
Date: Tue,  1 Sep 2026 18:07:10 +0000
In-Reply-To: <20260901180713.4185641-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260901180713.4185641-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.966.g6673acef38-goog
Message-ID: <20260901180713.4185641-3-dmatlack@google.com>
Subject: [RFC PATCH 2/5] liveupdate: Introduce SESSION_RETRIEVE_INTO_FD API
 and core support
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <shuah@kernel.org>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0F8EEC0012
X-Stat-Signature: cdogc8tnmedzzf141c1irk9xodhiprgp
X-Rspam-User: 
X-HE-Tag: 1788286046-753449
X-HE-Meta: U2FsdGVkX19d+gQ9O4KQa4uvDy32Nc3b7oSTeVwO9T7XqFyVhhnUf84AQtXOIeRu9kvknEV4Jx30tfkgwQ2SkpeK5hBch1bgyxgicbAw0iYMOjrnD7dRNYXJ4dgYV25tdpE1dzlrqE6g6athDbPzE2d2ppGeSMTitqqfYyc+Ex9KFLLKB62hyTuz1r9Tm3iTlvG9vD9LYdKrWsdMZRKqj0DvQKjNOalAv2/0dMI2QQ85dI1BPUAOMQVCu9gHWZ6NXsguth3vyiqouUHX83BIitJw0Cbr8wH6wI7ln5XeFKD+OLRvPzeE4K5hr39t7VCH8ENvnR1X+nu3vV35W9JwakAOppi1S1XyXRe1BC5fvOO3rc/nhXXduxikY7yyBcyx74nRkvuYJZEvDNO4bp72ww+L/sdZksCdm4oq+l0vTOVLWsjpCcDn9Rrel6cfAU464UDmg6OUlcVKMciIevfTKEaqCqv+uUdnx7H9zuv5AtMpV5oOJNZNUhmVsiB4kokkST/Zs5KPnEFI8TrdVkvjbRGroRaiPexAPARtQGr8sCF2+rB5O77P3wfAAUGKDKTb1Mw+zVCMNEYGdUVHhWaByLzYMRqhSmMx9ERW3peZyE7gQM1in4dXAa4updFiun9Ej/T/j28jM6QdVfaNcGQSV6+IV/6SmWzBGQeTEqNuOxFzeK8KFCKi0VLBWaCgIexSCPPe2mnlGR90jFQ/hmPca51bIGTjiwWxCljxolDBYeAkaFEyOvcDGtEE43ySeCvw6KglauyI4pBGfDXEVF0iNTmHwfS9CpwOkqR/dXseFqEMRhG5IIBpSXUyXfIhXX55YCw6SgxAvVhkMuHwgmtUT4ly0qnIUNyu9Z8J/x0HfthY3eLOAA5GoEKspfHK4/cgTG2dp6NNjQUeQA8zFOU9hMhaHVqrBvJgiWTypv8yCo1X8NrTbxzIdaK+poJx3WWjVC2cvt586SbRbL8H6QN
 meHdm9Ol
 3zJDm6NTYPr4P6mdODctci/tWx37sodVCZA2y6jevtHOHsV34aRSuND/eVasjzXtVnrUqtesiootHK4G4HvPoZ9bf1I+x3Om57vAaocs9dJB1GvdNMq+fJatkOy/erR3LPalENyPGyljUgKiryPeJKlaBmqOxPTbEJJwxYl/zSzUY93Ioa1hAf3k06gz3fIeH9/SCos3DoYEE9prXEv2aS7KrhnW5E1ShmlOrliPr2p0p1al3710BP1LsYWCVPAUYTALgcUROfvlRFMk1lwvUBp1ykhKfKYwwlEtkAXyLgLbq+GTfwu5SeXULBJ+if6SoB5cZzrGhXw4cGkDAw/pe7RbwPQtLArB5fS7YgGna7ISzeysgLzayiYDnw98bJrk1TnY72lg3maFEMJug/5QD9C2dmnh3l8MgG/x+bkykrxF82xBl1Va88jaHtEhJHAw4x1mLMIX8nRdQXCQK9n5g7hAamJNTioU6Fs91zt4pjed/gLNRGrlQM1sxKIMSgfrS25lSg300TmxR3/IQQfuwbBCLyfLu0QVP9XPBoVDTpQe6t9pFMKsitRsRfawSJuSqrr2ChH0YnVjKg9jcTWhn3y5N91LqvqsWYjWs4r8PpaCYtSDGklV5IZiMv6ZCwYyQbdqwHQa7MOfynXw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Define the LIVEUPDATE_CMD_SESSION_RETRIEVE_INTO_FD ioctl in the UAPI and
implement the core support into LUO sessions. Add a new .retrieve_into()
callback definition to struct liveupdate_file_handler but do not yet
implement it for any file types.

Delegating VFS topology recreation to userspace across Live Updates
requires an interface where userspace can provide an empty target file
descriptor, and the kernel can inject preserved memory into it. This API
supplies that missing routing. It uses the new luo_retrieve_into_file()
helper to safely look up tracking structures without duplicating backend
locks.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 include/linux/liveupdate.h       |  1 +
 include/uapi/linux/liveupdate.h  | 21 +++++++++++++++++++
 kernel/liveupdate/luo_file.c     | 36 ++++++++++++++++++++++++++++++++
 kernel/liveupdate/luo_internal.h |  2 ++
 kernel/liveupdate/luo_session.c  | 30 ++++++++++++++++++++++++++
 5 files changed, 90 insertions(+)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index 63ea5417de84..7b595e0f53bc 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -79,6 +79,7 @@ struct liveupdate_file_ops {
 	int (*freeze)(struct liveupdate_file_op_args *args);
 	void (*unfreeze)(struct liveupdate_file_op_args *args);
 	int (*retrieve)(struct liveupdate_file_op_args *args);
+	int (*retrieve_into)(struct liveupdate_file_op_args *args, struct file *target_file);
 	bool (*can_finish)(struct liveupdate_file_op_args *args);
 	void (*finish)(struct liveupdate_file_op_args *args);
 	unsigned long (*get_id)(struct file *file);
diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
index 4043d4038712..ed2049529cc0 100644
--- a/include/uapi/linux/liveupdate.h
+++ b/include/uapi/linux/liveupdate.h
@@ -59,7 +59,11 @@ enum {
 	LIVEUPDATE_CMD_SESSION_PRESERVE_FD = LIVEUPDATE_CMD_SESSION_BASE,
 	LIVEUPDATE_CMD_SESSION_RETRIEVE_FD = 0x41,
 	LIVEUPDATE_CMD_SESSION_FINISH = 0x42,
+
 	LIVEUPDATE_CMD_SESSION_GET_NAME = 0x43,
+
+	LIVEUPDATE_CMD_SESSION_RETRIEVE_INTO_FD = 0x44,
+
 };
 
 /**
@@ -184,6 +188,23 @@ struct liveupdate_session_retrieve_fd {
 #define LIVEUPDATE_SESSION_RETRIEVE_FD					\
 	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_RETRIEVE_FD)
 
+/**
+ * struct liveupdate_session_retrieve_into_fd - ioctl(LIVEUPDATE_SESSION_RETRIEVE_INTO_FD)
+ * @size:  Input; sizeof(struct liveupdate_session_retrieve_into_fd)
+ * @fd:    Input; The open file descriptor (e.g. empty tmpfs file) to inject the resource into.
+ * @token: Input; An opaque, token that was used to preserve the resource.
+ *
+ * Retrieve a previously preserved file descriptor into an existing file descriptor.
+ */
+struct liveupdate_session_retrieve_into_fd {
+	__u32		size;
+	__s32		fd;
+	__aligned_u64	token;
+};
+
+#define LIVEUPDATE_SESSION_RETRIEVE_INTO_FD					\
+	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_RETRIEVE_INTO_FD)
+
 /**
  * struct liveupdate_session_finish - ioctl(LIVEUPDATE_SESSION_FINISH)
  * @size:     Input; sizeof(struct liveupdate_session_finish)
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 5e160836a165..c4abfd25e149 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -932,3 +932,39 @@ void liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 	luo_flb_unregister_all(fh);
 	list_del(&ACCESS_PRIVATE(fh, list));
 }
+
+int luo_retrieve_into_file(struct luo_file_set *file_set, u64 token,
+			   struct file *target_file)
+{
+	struct liveupdate_file_op_args args = {0};
+	struct luo_file *luo_file;
+	int err;
+
+	luo_file = luo_find_file_by_token(file_set, token);
+	if (IS_ERR(luo_file))
+		return PTR_ERR(luo_file);
+
+	guard(mutex)(&luo_file->mutex);
+	if (luo_file->retrieve_status < 0)
+		return luo_file->retrieve_status;
+
+	if (luo_file->retrieve_status > 0)
+		return -EBUSY; /* Already retrieved */
+
+	if (!luo_file->fh->ops->retrieve_into)
+		return -EOPNOTSUPP;
+
+	args.handler = luo_file->fh;
+	args.serialized_data = luo_file->serialized_data;
+	err = luo_file->fh->ops->retrieve_into(&args, target_file);
+	if (err) {
+		luo_file->retrieve_status = err;
+		return err;
+	}
+
+	luo_file->file = target_file;
+	get_file(luo_file->file);
+	luo_file->retrieve_status = 1;
+
+	return 0;
+}
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 64879ffe7378..1af9aebe6623 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -92,6 +92,8 @@ void luo_file_unfreeze(struct luo_file_set *file_set,
 		       struct luo_file_set_ser *file_set_ser);
 int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 		      struct file **filep);
+int luo_retrieve_into_file(struct luo_file_set *file_set, u64 token,
+			   struct file *target_file);
 int luo_file_finish(struct luo_file_set *file_set);
 int luo_file_deserialize(struct luo_file_set *file_set,
 			 struct luo_file_set_ser *file_set_ser);
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index f48e9a4185f9..2b967f720ef5 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -278,6 +278,34 @@ static int luo_session_preserve_fd(struct luo_session *session,
 	return err;
 }
 
+static int luo_session_retrieve_into_fd(struct luo_session *session,
+					 struct luo_ucmd *ucmd)
+{
+	struct liveupdate_session_retrieve_into_fd *argp = ucmd->cmd;
+	struct fd target_fd;
+	int err;
+
+	target_fd = fdget(argp->fd);
+	if (fd_empty(target_fd))
+		return -EBADF;
+
+	guard(mutex)(&session->mutex);
+	err = luo_retrieve_into_file(&session->file_set, argp->token, fd_file(target_fd));
+	if (err < 0)
+		goto err_put_fd;
+
+	err = luo_ucmd_respond(ucmd, sizeof(*argp));
+	/*
+	 * If we fail to respond, we cannot easily undo the retrieval. Let the
+	 * normal session cleanup logic handle the file reference eventually.
+	 */
+
+err_put_fd:
+	fdput(target_fd);
+
+	return err;
+}
+
 static int luo_session_retrieve_fd(struct luo_session *session,
 				   struct luo_ucmd *ucmd)
 {
@@ -382,6 +410,8 @@ static const struct luo_ioctl_op luo_session_ioctl_ops[] = {
 		 struct liveupdate_session_retrieve_fd, token, LUO_IOCTL_INCOMING),
 	IOCTL_OP(LIVEUPDATE_SESSION_GET_NAME, luo_session_get_name,
 		 struct liveupdate_session_get_name, name, LUO_IOCTL_ALL),
+	IOCTL_OP(LIVEUPDATE_SESSION_RETRIEVE_INTO_FD, luo_session_retrieve_into_fd,
+		 struct liveupdate_session_retrieve_into_fd, token, LUO_IOCTL_INCOMING),
 };
 
 static bool luo_ioctl_type_valid(struct luo_session *session,
-- 
2.55.0.966.g6673acef38-goog


