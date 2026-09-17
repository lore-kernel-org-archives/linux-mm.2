Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32403C982D3
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 09:10:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37FC06B0093; Thu, 17 Sep 2026 05:10:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3307D6B0095; Thu, 17 Sep 2026 05:10:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2217E6B0096; Thu, 17 Sep 2026 05:10:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EA1DE6B0093
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:09:59 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5895DA02C4
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:09:59 +0000 (UTC)
X-FDA: 85222682118.17.C3580CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id A441FC0005
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:09:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H+c+T6So;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789636197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MyfKyJ2IFpUV90Fd+O/PB8hPgrmFQXEYPQE9FH2U5+0=;
	b=dNefFHNCe3uLEEL8vcDkOyyt5MmOq3Z2kqrVH6NQL8tXzPPwZ/Ne232OjifBsdvmWe5G1R
	Qg+MYflpctBhsXGPOctZ1SieFUW7OFs7qIDX65I6ZxcfLh4N++Iz8RdXMc+AlGoSza4VAo
	Xl2GTEyul4t+1N5IRgkoth6xWZr3XTM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789636197;
	b=TMqyjNTW3uogOekzhQ1JwDmlgM1dOQwuuDXmEd53phvHO5MwFUZjNg4H+yFhBtYbwmGdAT
	qo/fliZtYjGEjnXNzqX8j6Th+9ZbgKdEf3WaqLzzOsdGNBN/5DVjb4DrSBDTHNLW5egnmv
	oDCxAFhVWMKIt6DzgmwHVFnoNRHY81M=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H+c+T6So;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4B24B60210;
	Thu, 17 Sep 2026 09:09:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9651F00893;
	Thu, 17 Sep 2026 09:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789636197;
	bh=MyfKyJ2IFpUV90Fd+O/PB8hPgrmFQXEYPQE9FH2U5+0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=H+c+T6SoQ7bi7KDrdywXGdkUQno8IYfgoOVzvBXc3Nel3/0tmU8DEF2bj0ddSxyTA
	 O5Ud3r8id3oPVDTbslazb9ysVE9ON6gawxat9WFfRF4Q+PLx3tYIdqDQvqfm0jTC6m
	 /cgGcLDIbqt+VgC97EYTKWndcVJt15N6YxfgDmj5eu1UG9nTF1RZQgHnsvksdXMQ4J
	 HeZT6FODg0Zu/NjiC+NyOdMvy6958db56K9fLSUbAfl+qnuWWJfqq2A6efvvaTYfVC
	 yB/nZ71w6QgCB7D8AkTClKTn3kksvqPNqAXrGppLTexMhqcBqNHdlHzRY3+U9l7UwV
	 l3kws5Udp65xA==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 17 Sep 2026 11:09:42 +0200
Subject: [PATCH 1/4] file: simplify FD_PREPARE()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-work-file-fd_prepare-v1-1-b87534ca49f3@kernel.org>
References: <20260917-work-file-fd_prepare-v1-0-b87534ca49f3@kernel.org>
In-Reply-To: <20260917-work-file-fd_prepare-v1-0-b87534ca49f3@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linuxppc-dev@lists.ozlabs.org, linux-gpio@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 freedreno@lists.freedesktop.org, linux-media@vger.kernel.org, 
 wine-devel@list.winehq.org, linux-xfs@vger.kernel.org, 
 io-uring@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=5584; i=brauner@kernel.org;
 h=from:subject:message-id; bh=DV2T4c+4xkA8K7vcmtRlGodHYsmKM293QENU4hzkJCg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWStXhep3M4ftMm/0tX7f+TWpDfvNhuyLq2zqitf971kY
 uliTU+TjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIm43Wf4Z6Buav4mVHvnrLJ/
 F/qWul+VYpPL7NnUl7Jl6qoAjkVXrzD803sVsfDCxzW/N0zhWlmzN8d3Q+NUxk1xjkFhk3MLuXJ
 D+QE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: exodrw8p8977kb48iehk55e6j7ix1p88
X-Rspam-User: 
X-Rspamd-Queue-Id: A441FC0005
X-Rspamd-Server: rspam03
X-HE-Tag: 1789636197-17566
X-HE-Meta: U2FsdGVkX18l62/SuFZx4+SOT3wmFSdON3PC7pbVYmTZHk0l4Y1Ad7f1mNfte9GgK6R8ZxYIC4+2LsVYtEeDVjbKiRHbB8Vog0GkBEsqubiTQ9+ntlcjXu97LUNithGRCX7F11B+DjEZNBKAJmpaRp8L7BTmW2pQklEYobE0Umykq3CT4ElkUPgevOAzTjbDxY6GE3yZwwI5oFMpssh3I0OPJW0m5oi67ISs7w08CcR2arrJNANtemTkJUdhrkEIMNm+blYaoFZBQeh2PCE8TjZLDlR9ZxTR9y0WKNa9T9RCCuA1PPmW7Xs/fTwP1R3388/Jg6MesS8LmQoTaAtCG11rV1WuS8tqQk54ScMFodP+l86OPbxH6ewr4k13jmEJEj+iI0/6hXVkYd7U2pTq/yWJeCPuBHBk7/ryC8ubounRyBjRB8EyKaZr6NPJVKqqtTPT0j4jZmXtaPjEI7r0I1np9NxvQaevd2EVjdV4YfRL1jKXml69HEo8BdOsLqZwJebqwy6ugnj6JfkkeHShuFaleYZZL8FVhqHDGbvROnWFtvZAWo2ZHpJoHga39NuAVAYN0MOliSyG64ICVJtxUNROqAczMjIVzTox1DW4qjxHy8N09mOYocD57dLiTdjkqcqwA8fHWMZUtaAIJ/ZsTHr3yoKm27E9w13yD0R4/Er22zx1BKUTGgIa68vFKKrY/eYmVLOn3NSD4G9n7xwgkYEkpKOH16zAPC9q4OjE/g2mbuxTwadqsZANEU2UeHvKEqFfzCPA9NZCaLkUJm0NBlAw6uA/HG7/76WWpxsZGnOf/xjJWbsCL6IBF/yx2lCciLG3Rt3jNgRus+IVv2SV4OI7y2IPFxalN5h6uaMO+BFo0JZD9cKIAdKUM4H6XLZbGAorURN64c+kzaggj99NMPoL45jKVkOMQV/hzqm/FtlLruVZcJCvx2BH7nAfhyGwGZO6anAwwA7CFW/8adG
 0Uw1lPfZ
 flc2lJNck/2X6o+xmd5WM4TA8NHAzX4RBZWisWFSKtGwJ5TOOPijWeKTbmALMFKS5LGcU79/rcfFA5MbFMsEbmpuC/bDXthAOjedX4YlrxWBmOlM7jQ6azz9WbP3NYJr9XYWjE9GkUCccRy724iG520XrBUnZYHSRSc+iHQEP+xZ78BvflM5HNwsC56AWyCl6/H2PAB1H8ozrzCPS6xuDgDW3G6Mup/VRHGiQTVLKP9xJH1yEgj+3RXcdbOVb1IUsQmqn0xtIMZpmVr/tYqU1zB0dLjCkoT3mpkbe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It was originally built as an ACQUIRE-style guard but most of the
infrastructure was never needed and introduced complexity that we really
didn't need. Drop the ACQUIRE machinery and compute the error where the
fd and file are set.

No functional changes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/linux/file.h | 99 ++++++++++++++++++++++------------------------------
 1 file changed, 41 insertions(+), 58 deletions(-)

diff --git a/include/linux/file.h b/include/linux/file.h
index 27484b444d31..2b864f457211 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -12,6 +12,7 @@
 #include <linux/errno.h>
 #include <linux/cleanup.h>
 #include <linux/err.h>
+#include <linux/vfsdebug.h>
 
 struct file;
 
@@ -159,87 +160,69 @@ typedef struct fd_prepare class_fd_prepare_t;
 	(_Generic((_fdf), struct fd_prepare: (_fdf).__file))
 
 /* Do not use directly. */
-static inline void class_fd_prepare_destructor(const struct fd_prepare *fdf)
+static __always_inline void class_fd_prepare_destructor(const struct fd_prepare *fdf)
 {
-	if (unlikely(fdf->__fd >= 0))
+	if (unlikely(fdf->__fd >= 0)) {
 		put_unused_fd(fdf->__fd);
-	if (unlikely(!IS_ERR_OR_NULL(fdf->__file)))
 		fput(fdf->__file);
+	}
 }
 
 /* Do not use directly. */
-static inline int class_fd_prepare_lock_err(const struct fd_prepare *fdf)
+static __always_inline struct fd_prepare __fd_prepare(int fd, struct file *file)
 {
-	if (unlikely(fdf->err))
-		return fdf->err;
-	if (unlikely(fdf->__fd < 0))
-		return fdf->__fd;
-	if (unlikely(IS_ERR(fdf->__file)))
-		return PTR_ERR(fdf->__file);
-	if (unlikely(!fdf->__file))
-		return -ENOMEM;
-	return 0;
-}
+	if (fd >= 0 && IS_ERR_OR_NULL(file)) {
+		int err = file ? PTR_ERR(file) : -ENOMEM;
 
-/*
- * __FD_PREPARE_INIT - Helper to initialize fd_prepare class.
- * @_fd_flags: flags for get_unused_fd_flags()
- * @_file_owned: expression that returns struct file *
- *
- * Returns a struct fd_prepare with fd, file, and err set.
- * If fd allocation fails, fd will be negative and err will be set. If
- * fd succeeds but file_init_expr fails, file will be ERR_PTR and err
- * will be set. The err field is the single source of truth for error
- * checking.
- */
-#define __FD_PREPARE_INIT(_fd_flags, _file_owned)                 \
-	({                                                        \
-		struct fd_prepare fdf = {                         \
-			.__fd = get_unused_fd_flags((_fd_flags)), \
-		};                                                \
-		if (likely(fdf.__fd >= 0))                        \
-			fdf.__file = (_file_owned);               \
-		fdf.err = ACQUIRE_ERR(fd_prepare, &fdf);          \
-		fdf;                                              \
-	})
+		put_unused_fd(fd);
+		fd = err;
+		file = NULL;
+	}
+	return (struct fd_prepare){
+		.err = fd < 0 ? fd : 0,
+		.__fd = fd,
+		.__file = file,
+	};
+}
 
 /*
- * FD_PREPARE - Macro to declare and initialize an fd_prepare variable.
+ * FD_PREPARE - Declare and initialize an fd_prepare instance.
  *
- * Declares and initializes an fd_prepare variable with automatic
- * cleanup. No separate scope required - cleanup happens when variable
- * goes out of scope.
+ * This allocates a new fd and only evaluates @_file_owned if the
+ * allocation succeeded. Cleanup happens when the variable goes out of
+ * scope and the guard releases whichever of the descriptor and the file
+ * was allocated. If fd_publish() was called the fd and file are
+ * published and cleanup becomes a nop.
  *
  * @_fdf: name of struct fd_prepare variable to define
  * @_fd_flags: flags for get_unused_fd_flags()
  * @_file_owned: struct file to take ownership of (can be expression)
  */
-#define FD_PREPARE(_fdf, _fd_flags, _file_owned) \
-	CLASS_INIT(fd_prepare, _fdf, __FD_PREPARE_INIT(_fd_flags, _file_owned))
+#define FD_PREPARE(_fdf, _fd_flags, _file_owned)			\
+	CLASS_INIT(fd_prepare, _fdf, ({					\
+		int __fd = get_unused_fd_flags(_fd_flags);		\
+		__fd_prepare(__fd, __fd < 0 ? NULL : (_file_owned));	\
+	}))
+
+/* Do not use directly. */
+static __always_inline int __fd_publish(struct fd_prepare *fdf)
+{
+	VFS_WARN_ON_ONCE(fdf->__fd < 0);
+	fd_install(fdf->__fd, fdf->__file);
+	return take_fd(fdf->__fd);
+}
 
 /*
  * fd_publish - Publish prepared fd and file to the fd table.
  * @_fdf: struct fd_prepare variable
  */
-#define fd_publish(_fdf)                                       \
-	({                                                     \
-		struct fd_prepare *fdp = &(_fdf);              \
-		VFS_WARN_ON_ONCE(fdp->err);                    \
-		VFS_WARN_ON_ONCE(fdp->__fd < 0);               \
-		VFS_WARN_ON_ONCE(IS_ERR_OR_NULL(fdp->__file)); \
-		fd_install(fdp->__fd, fdp->__file);            \
-		retain_and_null_ptr(fdp->__file);              \
-		take_fd(fdp->__fd);                            \
-	})
+#define fd_publish(_fdf) __fd_publish(&(_fdf))
 
 /* Do not use directly. */
-#define __FD_ADD(_fdf, _fd_flags, _file_owned)            \
-	({                                                \
-		FD_PREPARE(_fdf, _fd_flags, _file_owned); \
-		s32 ret = _fdf.err;                       \
-		if (likely(!ret))                         \
-			ret = fd_publish(_fdf);           \
-		ret;                                      \
+#define __FD_ADD(_fdf, _fd_flags, _file_owned)			\
+	({							\
+		FD_PREPARE(_fdf, _fd_flags, _file_owned);	\
+		_fdf.err ?: fd_publish(_fdf);			\
 	})
 
 /*

-- 
2.53.0


