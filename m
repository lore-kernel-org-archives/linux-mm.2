Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6906CC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 09:38:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37C4F6B0096; Thu, 15 Oct 2026 05:38:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32F006B0098; Thu, 15 Oct 2026 05:38:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21B9B6B0099; Thu, 15 Oct 2026 05:38:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E06D56B0096
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 05:38:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 74D1D1A0981
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:38:33 +0000 (UTC)
X-FDA: 85324360506.05.216F65E
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	by imf15.hostedemail.com (Postfix) with ESMTP id B6484A000B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:38:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=L6UolQ7V;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792057111;
	b=S+i5D1foNH4bcE2pkW7jHOSV/Kt4dYY4zZF7bmdtk/mnDsc8+v2o4d0yuGjkvImu6szdn5
	YQEBjJ9zVccBhIOYoS30LeT9vUJUi3wDkxjRLGWPD7RPVdcN61hMsptKIRx0pXmBbxV1GO
	OlDHTTg0d5iBV/Mfy4B/cCzAAjU9caM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=L6UolQ7V;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792057111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D1ap1lTo09xjVAq/k8OVq3JGg6tCyLxeFjdIIFwfh58=;
	b=U+e9W0bhe2b9NZlcWdg6kuqehWBtXvHUOqRxw2X8XJ43k6xpmjGA4PDMLM2x5AeZg2eby8
	DSMY0bViPz8cTvug1K0n820uI+HEzT1oNliZ4RkYuO1TQ+vIC+e7eAIerv09a/Iki1A4/0
	+GH42WXDG75z/qNuiPBD404MzRD9AtE=
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-5e9528732b4so2790026e0c.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 02:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792057111; x=1792661911; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=D1ap1lTo09xjVAq/k8OVq3JGg6tCyLxeFjdIIFwfh58=;
        b=L6UolQ7VCScXO2+jg1xeIc13IQgky/bqBFv8GdTKMMkJbYG5hzBujsaNEV8oxtR8LK
         3suuaSoVH5jjnhAM642NqHWuDGqMVy4ZdKKO2bc0+a7OfYAdbdHlGmgkPk0mjks69l+O
         DcPzUYQX3imVf2L7uLCUYlDZzl5yY3HpXGwThnxDmNHmS7uIaCiyNJjftwkN9/vxnwY9
         5CVerjY7veTEKxr/34FWNquQ0aHoENGo8cx0X8024bZZsVqERA2DpEcUIxp7VzxF8Ghw
         SyLXtM43mrlENj/LTyyNqP4nAyF9j+PdNOMtE52b5GRLB6KNmBhF5GfYWWuygs0gnadr
         v4Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792057111; x=1792661911;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=D1ap1lTo09xjVAq/k8OVq3JGg6tCyLxeFjdIIFwfh58=;
        b=YfxAoW22qdQCdA37kwTw2VX9kSXwJVICIOzOX9knTjP3iBYTKk/s34+f/ZGr3qWMwa
         wUWKK41sNimmFCRDCZqejQmCr+xfxTkRp1Ko+uhbDycJ7KHlCqkb30Y26UJa0uxaL425
         praXBFjZlreg5s1Hd/Sd+E56je4B4hxkH8oVsJIBYCS2TQeh9L3JnSSRxuILaaTeOxu3
         +AfyZr7wJC/u0pD0Sg+0jq9xaAcUk5BO+D0m0i8q5Fox3YlYphl0UVIKgIiyzZyRyj8u
         e0BvdxZmICQgOTqiUHVcwcBQTeO4vaM7Btk9AGsxojw2Y+pAl2M1JcUO/ihef8B4samR
         dRsA==
X-Forwarded-Encrypted: i=1; AKwUvBwyAWBIaDbJ0b9j3prSek/JtRPgbIeSq7z784aUJr06tzFazzv9Q6kR/qdGonEPrHHuW/zc6WcELg==@kvack.org
X-Gm-Message-State: AFq9FYImQZCLcLpxOcD7DNksHUH5gU8VltMVxwEtO+mWujslv452WHKE
	P0Jaw2lSkYEpTz4Y55SXBBjYvXXMnRssjguUnIf2+Iv+WKatF46OADKe/A8QqW8TDew=
X-Gm-Gg: AYBFou2pQXFDF55OhHuIT6zLNxC+MBjzOVwulzAqqLq0fCQhcveCq7OeeFciJQ4n17Q
	CYPFuVU5eCUq36+bNTwzpo0X1rPAGPw/cKIkgg4ZykhkAyr4Hanirl11/Ip1T8HGHGm1zVtLm3+
	hwyoG6HEj/KJZE8XmZmyoJE+p1ET0WPm/685vJnDY3TLwxfjF1912aHy9WCIgq9gyUMJiHuaVcr
	e2sz0JD3DDGqjuRlAc2+B8pn1uA1aN40oh7Ul3cUhxAHVPj3iHuhvUlH7q+zBJFfmf1i4tjp9AH
	jl+XZf4t2clGH58pMjuRuC8NCXAlnhNgSE6VSqwMhYOqevE6KDclZXAEZpypMzCn9i/d7hJ4aEh
	bBmhbUkY5cy7XKGJFl80jsL5BvAOG8bnzXLmXaWCapWj6EVFsse8KD5q+gRIOpFNqOyUZw0oaER
	e3a3yhiZ1JBHglU0YRZLVx9vtUF4DG8NMQ/04xZF3ShnRzCvPHkmngNEuRCtMWxFgR/UHRMd4Hs
	KbRWPXFXbtXEGQeS894+SGM/uyXzbRWtzES9mHLYzCk/nCeieveiuJht2nG/e144lev+a/5Mid8
	MMJwhiCNNTqokKN0zyQ=
X-Received: by 2002:a05:6123:10f:b0:5c9:a7af:8178 with SMTP id 71dfb90a1353d-5e91f26da41mr6464626e0c.2.1792057110812;
        Thu, 15 Oct 2026 02:38:30 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-99003d37009sm12275672241.2.2026.10.15.02.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 02:38:25 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	vipinsh@google.com,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	graf@amazon.com
Subject: [PATCH v1 3/7] liveupdate: Pass user argument to file preserve and retrieve
Date: Thu, 15 Oct 2026 05:38:12 -0400
Message-ID: <20261015093816.2438942-4-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261015093816.2438942-1-pasha.tatashin@soleen.com>
References: <20261015093816.2438942-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6w7q7k6mwu9553rygan97ib1hek6q6ei
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B6484A000B
X-HE-Tag: 1792057111-293646
X-HE-Meta: U2FsdGVkX192JQRogMA5INFD1ZrsUplPd8r0bRmtdidGQSCrai0s122lB9kAiFDsL4hC6ukI34Le8eGc83ejy27UKyLlxeaZ/SFyT6TG+7TtkR3EOg+9nt2z0iNyzDgZgOv7GzGDslN+I+r+6vhNFuSMrT2SETS6fho3y9bhADA6axmm6nk0klIBqTRjZ8L7Gn9YqSNUXk7SvYsYf/JSCCZ7bTij2Xdff4wU7Kac1317B6haIFGoWeiZSDZm8/OX+keWlHoycBojp4IJ4iAlGUplkEWVJz869FxSMJhM5nV52z8KPJcFxcDk1EuLAXaGMssJ2kEOGICpRSwXFCYsiQABDMwFLXxJqiuc9vhn67WF+P8jMzbnJ4+7PhJl18of9WUkyokqwgcpJPpteaZNvbFDrys5uaGqW/lirg/pOFVSS4GeIT2ktAGoXMRkmD0ngX3SHxDH8DRK77AdeOIhYbiTvooVUEFv0+4BryJcy8QOyNIU7q++0WVUOY+eu2SYrQmp6wzjle75P6BoDp6OMARPgswRUeBP5tc+Z3lgQwCD7KMBc0TYbp/GV7ohItkUd6yie1BQ3JYJcRGkpq4Cxro3ReoeXXvwGpIp8oteiXZYOt1jI/eBJf6H+DeyC0HwK23vAbFKENQRPpQAbPicZK1X2jb/rnZ2b56LKM3/oS3HcqYSrRf1l2B0a8xGiXHlf8EXlMAa6LtZ/gnJD3sMOHRNngd86ANGzrTF9CG/gnvF8BD5RKU8CFjvyPSky6QLZ6YULK4nhXblnb975c7HknFUB9OxaFDevtD5yL7AnwuH1dCt/Ecj6wA1pvi5q5BzLKtMMoAl6gVII/S6NS6W9ZB0PbcEO/pO3WuqU3m52qRliNzOZ64wxqSBge01xsML1FrayMPzvDXWyn1fVAOmBODiBju7LnQqtRIqDk5hZ5H+heNuGvyHzulWMqBgTiyF8EXnxr2KnzxqsHFcDly
 QtuAqWF8
 XbeaudN+/Z57TclH0YStubWlGiyc9PB12KhYvsbXXrsk/ygkt+w9AcgOUbiIawlUZp37QXEA9E55IPai5qbacctSSDdjODWMo+M5l8LjFLzFKN5FUDZLnatfzr99E1zrqfzPO92WbAnzIngTSS8fNAuU/TxqeucRoiksL1OTnq6RftFtNUo0xID3Lw4UlbFV/EXcQZmj0I98RM4xuCxaWcqyHKoUKmqJlg6CCgYtcTxVQ7wXk1IIm9rcaewky6OI7MOc7B6g0Fm83gw67JXcZAQ7IGNctf7zqiol+x1CQBf+6FPTuBEGkp7SmdznDpZKPrQqFrWOiIjk05YQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow userspace to pass a file-handler-specific argument structure when
preserving or retrieving an FD via LUO. File handlers may need
additional context during preservation or retrieval, such as a target
FD, device location, or handler-specific parameters, without introducing
separate ioctls for each file type. Whether the argument is required,
optional, or unused is defined by the file handler.

Extend struct liveupdate_session_preserve_fd and
struct liveupdate_session_retrieve_fd with a 64-bit arg field pointing
to a handler-defined argument structure that begins with a 32-bit size
field. Because IOCTL_OP validates a minimum size up to the token field,
existing callers passing the 16-byte struct remain compatible and have
arg zero-filled by copy_struct_from_user().

Add parg and rarg (struct liveupdate_arg_spec) to
struct liveupdate_file_ops, initialized via LIVEUPDATE_ARG(_struct,
_min_last), which records the full struct size and minimum required size
while enforcing at compile time that handler argument structures begin
with a 32-bit size field. When arg is non-zero, LUO validates the
minimum size and copies the user argument via copy_struct_from_user() up
to the handler's expected size and passes the kernel copy in
struct liveupdate_file_op_args, or returns -EOPNOTSUPP if the handler
does not accept an argument.

Also provide liveupdate_claim_file() and liveupdate_unclaim_file() so
handlers whose .retrieve() callback restores state into an existing
user-supplied file descriptor can claim it in luo_preserved_files before
modifying the file.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/liveupdate.h       | 60 +++++++++++++++++++
 include/uapi/linux/liveupdate.h  |  6 ++
 kernel/liveupdate/luo_file.c     | 99 +++++++++++++++++++++++++++++---
 kernel/liveupdate/luo_internal.h |  5 +-
 kernel/liveupdate/luo_session.c  |  6 +-
 5 files changed, 164 insertions(+), 12 deletions(-)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index 885ec0bbc4b8c..52d3f453ae011 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -22,6 +22,36 @@ struct liveupdate_flb;
 struct liveupdate_session;
 struct file;
 
+/**
+ * struct liveupdate_arg_spec - Specification of a file handler user argument.
+ * @size:     Full size of the argument structure in the current kernel.
+ * @min_size: Minimum valid user-supplied size (offsetofend of the last
+ *            required field).
+ */
+struct liveupdate_arg_spec {
+	size_t size;
+	size_t min_size;
+};
+
+/**
+ * LIVEUPDATE_ARG - Validated specification of a file handler argument struct.
+ * @_struct:   The argument structure type.
+ * @_min_last: The last required member in @_struct.
+ *
+ * All file handler argument structures passed via
+ * &liveupdate_session_preserve_fd.arg or &liveupdate_session_retrieve_fd.arg
+ * must begin with a 32-bit @size field so they can be extended compatibly.
+ * Use this macro to initialize &liveupdate_file_ops.parg and
+ * &liveupdate_file_ops.rarg.
+ */
+#define LIVEUPDATE_ARG(_struct, _min_last)				\
+	{								\
+		.size = sizeof(_struct) +				\
+			BUILD_BUG_ON_ZERO(offsetof(_struct, size) != 0) + \
+			BUILD_BUG_ON_ZERO(sizeof_field(_struct, size) != sizeof(u32)), \
+		.min_size = offsetofend(_struct, _min_last),		\
+	}
+
 /**
  * struct liveupdate_file_op_args - Arguments for file operation callbacks.
  * @handler:          The file handler being called.
@@ -39,6 +69,11 @@ struct file;
  *                    is not preserved. Set by the handler's .preserve()
  *                    callback, and must be freed in the handler's
  *                    .unpreserve() callback.
+ * @arg:              Kernel copy of the user-provided argument for .preserve()
+ *                    and .retrieve(), or %NULL if none was provided. Allocated
+ *                    to the handler's expected argument size with any trailing
+ *                    bytes beyond the user-supplied size zero-filled. Valid
+ *                    only for the duration of the callback.
  *
  * This structure bundles all parameters for the file operation callbacks.
  * The 'data' and 'file' fields are used for both input and output.
@@ -49,6 +84,7 @@ struct liveupdate_file_op_args {
 	struct file *file;
 	u64 serialized_data;
 	void *private_data;
+	const void *arg;
 };
 
 /**
@@ -67,6 +103,12 @@ struct liveupdate_file_op_args {
  *                resources in the session.
  * @finish:       Required. Final cleanup in the new kernel.
  * @get_id:       Optional. Returns a unique identifier for the file.
+ * @parg:         Optional. Specification of the user argument structure
+ *                accepted by @preserve, initialized via LIVEUPDATE_ARG(). If
+ *                unset, non-zero user arguments are rejected with -EOPNOTSUPP.
+ * @rarg:         Optional. Specification of the user argument structure
+ *                accepted by @retrieve, initialized via LIVEUPDATE_ARG(). If
+ *                unset, non-zero user arguments are rejected with -EOPNOTSUPP.
  * @owner:        Module reference
  *
  * All operations (except can_preserve) receive a pointer to a
@@ -83,6 +125,8 @@ struct liveupdate_file_ops {
 	bool (*can_finish)(struct liveupdate_file_op_args *args);
 	void (*finish)(struct liveupdate_file_op_args *args);
 	unsigned long (*get_id)(struct file *file);
+	struct liveupdate_arg_spec parg;
+	struct liveupdate_arg_spec rarg;
 	struct module *owner;
 };
 
@@ -237,6 +281,11 @@ int liveupdate_reboot(void);
 int liveupdate_register_file_handler(struct liveupdate_file_handler *fh);
 void liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh);
 
+int liveupdate_claim_file(struct liveupdate_file_handler *fh,
+			  struct file *file);
+void liveupdate_unclaim_file(struct liveupdate_file_handler *fh,
+			     struct file *file);
+
 int liveupdate_register_flb(struct liveupdate_file_handler *fh,
 			    struct liveupdate_flb *flb);
 void liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
@@ -269,6 +318,17 @@ static inline void liveupdate_unregister_file_handler(struct liveupdate_file_han
 {
 }
 
+static inline int liveupdate_claim_file(struct liveupdate_file_handler *fh,
+					struct file *file)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void liveupdate_unclaim_file(struct liveupdate_file_handler *fh,
+					   struct file *file)
+{
+}
+
 static inline int liveupdate_register_flb(struct liveupdate_file_handler *fh,
 					  struct liveupdate_flb *flb)
 {
diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
index 1644c502521e0..57a3c129d5a9d 100644
--- a/include/uapi/linux/liveupdate.h
+++ b/include/uapi/linux/liveupdate.h
@@ -127,6 +127,8 @@ struct liveupdate_ioctl_retrieve_session {
  * @size:  Input; sizeof(struct liveupdate_session_preserve_fd)
  * @fd:    Input; The user-space file descriptor to be preserved.
  * @token: Input; An opaque, unique token for preserved resource.
+ * @arg:   Input; User-space pointer to a file-handler-specific argument
+ *         structure starting with a 32-bit size field, or 0 if unused.
  *
  * Holds parameters for preserving a file descriptor.
  *
@@ -150,6 +152,7 @@ struct liveupdate_session_preserve_fd {
 	__u32		size;
 	__s32		fd;
 	__aligned_u64	token;
+	__aligned_u64	arg;
 };
 
 #define LIVEUPDATE_SESSION_PRESERVE_FD					\
@@ -161,6 +164,8 @@ struct liveupdate_session_preserve_fd {
  * @fd:    Output; The new file descriptor representing the fully restored
  *         kernel resource.
  * @token: Input; An opaque, token that was used to preserve the resource.
+ * @arg:   Input; User-space pointer to a file-handler-specific argument
+ *         structure starting with a 32-bit size field, or 0 if unused.
  *
  * Retrieve a previously preserved file descriptor.
  *
@@ -180,6 +185,7 @@ struct liveupdate_session_retrieve_fd {
 	__u32		size;
 	__s32		fd;
 	__aligned_u64	token;
+	__aligned_u64	arg;
 };
 
 #define LIVEUPDATE_SESSION_RETRIEVE_FD					\
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 3c1c86ff14d69..e3bfdbc6baedc 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -112,6 +112,7 @@
 #include <linux/xarray.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/uaccess.h>
 #include "luo_internal.h"
 
 static LIST_HEAD(luo_file_handler_list);
@@ -176,6 +177,36 @@ static unsigned long luo_get_id(struct liveupdate_file_handler *fh,
 	return fh->ops->get_id ? fh->ops->get_id(file) : (unsigned long)file;
 }
 
+/**
+ * liveupdate_claim_file - Claim a file in the LUO preserved files table.
+ * @fh:   The file handler claiming @file.
+ * @file: The file to claim.
+ *
+ * File handlers whose .retrieve() callback restores state into an existing
+ * user-supplied &struct file (rather than allocating a new one) should call
+ * this before modifying @file to ensure @file is not already managed by LUO.
+ *
+ * Return: 0 on success, -EBUSY if @file is already managed by LUO, or a
+ *         negative errno on allocation failure.
+ */
+int liveupdate_claim_file(struct liveupdate_file_handler *fh,
+			  struct file *file)
+{
+	return xa_insert(&luo_preserved_files, luo_get_id(fh, file),
+			 file, GFP_KERNEL);
+}
+
+/**
+ * liveupdate_unclaim_file - Release a claimed file from the LUO preserved files table.
+ * @fh:   The file handler that claimed @file.
+ * @file: The file to release.
+ */
+void liveupdate_unclaim_file(struct liveupdate_file_handler *fh,
+			     struct file *file)
+{
+	xa_erase(&luo_preserved_files, luo_get_id(fh, file));
+}
+
 static bool luo_token_is_used(struct luo_file_set *file_set, u64 token)
 {
 	struct luo_file *iter;
@@ -188,11 +219,45 @@ static bool luo_token_is_used(struct luo_file_set *file_set, u64 token)
 	return false;
 }
 
+static int luo_copy_user_arg(u64 user_arg, const void **argp,
+			     const struct liveupdate_arg_spec *spec)
+{
+	void *karg __free(kfree) = NULL;
+	void __user *uptr;
+	u32 user_size;
+	int err;
+
+	if (!user_arg)
+		return 0;
+	if (!spec->size)
+		return -EOPNOTSUPP;
+
+	uptr = u64_to_user_ptr(user_arg);
+	if (get_user(user_size, (u32 __user *)uptr))
+		return -EFAULT;
+	if (user_size < spec->min_size)
+		return -EINVAL;
+	if (user_size > PAGE_SIZE)
+		return -E2BIG;
+
+	karg = kmalloc(spec->size, GFP_KERNEL);
+	if (!karg)
+		return -ENOMEM;
+
+	err = copy_struct_from_user(karg, spec->size, uptr, user_size);
+	if (err)
+		return err;
+
+	*argp = no_free_ptr(karg);
+	return 0;
+}
+
 /**
  * luo_preserve_file - Initiate the preservation of a file descriptor.
  * @file_set: The file_set to which the preserved file will be added.
  * @token:    A unique, user-provided identifier for the file.
  * @fd:       The file descriptor to be preserved.
+ * @arg:      User-space pointer to the handler argument structure, or 0.
  *
  * This function orchestrates the first phase of preserving a file. Upon entry,
  * it takes a reference to the 'struct file' via fget(), effectively making LUO
@@ -208,9 +273,11 @@ static bool luo_token_is_used(struct luo_file_set *file_set, u64 token)
  *    (allocates if needed).
  * 3. Iterates through registered handlers, calling can_preserve() to find one
  *    compatible with the given @fd.
- * 4. Calls the handler's .preserve() operation, which saves the file's state
+ * 4. Copies the user argument structure (if @arg is non-zero) according to the
+ *    handler's parg specification.
+ * 5. Calls the handler's .preserve() operation, which saves the file's state
  *    and returns an opaque private data handle.
- * 5. Adds the new instance to the file_set's internal list.
+ * 6. Adds the new instance to the file_set's internal list.
  *
  * On success, LUO takes a reference to the 'struct file' and considers it
  * under its management until it is unpreserved or finished.
@@ -225,10 +292,12 @@ static bool luo_token_is_used(struct luo_file_set *file_set, u64 token)
  *         -EBADF if the file descriptor is invalid.
  *         -ENOSPC if the file_set is full.
  *         -ENOENT if no compatible handler is found.
+ *         -EOPNOTSUPP if @arg is non-zero and the handler does not accept an arg.
  *         -ENOMEM on memory allocation failure.
  *         Other erros might be returned by .preserve().
  */
-int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
+int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd,
+		      u64 arg)
 {
 	struct liveupdate_file_op_args args = {0};
 	struct liveupdate_file_handler *fh;
@@ -264,10 +333,14 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	if (err)
 		goto err_fput;
 
+	err = luo_copy_user_arg(arg, &args.arg, &fh->ops->parg);
+	if (err)
+		goto err_module_put;
+
 	err = xa_insert(&luo_preserved_files, luo_get_id(fh, file),
 			file, GFP_KERNEL);
 	if (err)
-		goto err_module_put;
+		goto err_free_arg;
 
 	err = luo_flb_file_preserve(fh);
 	if (err)
@@ -290,6 +363,7 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	if (err)
 		goto err_kfree;
 
+	kfree(args.arg);
 	luo_file->serialized_data = args.serialized_data;
 	luo_file->private_data = args.private_data;
 	list_add_tail(&luo_file->list, &file_set->files_list);
@@ -303,6 +377,8 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	luo_flb_file_unpreserve(fh);
 err_erase_xa:
 	xa_erase(&luo_preserved_files, luo_get_id(fh, file));
+err_free_arg:
+	kfree(args.arg);
 err_module_put:
 	module_put(fh->ops->owner);
 err_fput:
@@ -533,6 +609,7 @@ void luo_file_unfreeze(struct luo_file_set *file_set,
  * luo_retrieve_file - Restores a preserved file from a file_set by its token.
  * @file_set: The file_set from which to retrieve the file.
  * @token:    The unique token identifying the file to be restored.
+ * @arg:      User-space pointer to the handler argument structure, or 0.
  * @filep:    Output parameter; on success, this is populated with a pointer
  *            to the newly retrieved 'struct file'.
  *
@@ -552,9 +629,10 @@ void luo_file_unfreeze(struct luo_file_set *file_set,
  *          kernel.
  * Return: 0 on success. Returns a negative errno on failure:
  *         -ENOENT if no file with the matching token is found.
+ *         -EOPNOTSUPP if @arg is non-zero and the handler does not accept an arg.
  *         Any error code returned by the handler's .retrieve() op.
  */
-int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
+int luo_retrieve_file(struct luo_file_set *file_set, u64 token, u64 arg,
 		      struct file **filep)
 {
 	struct liveupdate_file_op_args args = {0};
@@ -591,9 +669,14 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 		return 0;
 	}
 
+	err = luo_copy_user_arg(arg, &args.arg, &luo_file->fh->ops->rarg);
+	if (err)
+		return err;
+
 	args.handler = luo_file->fh;
 	args.serialized_data = luo_file->serialized_data;
 	err = luo_file->fh->ops->retrieve(&args);
+	kfree(args.arg);
 	if (err) {
 		/* Keep the error code for later use. */
 		luo_file->retrieve_status = err;
@@ -604,9 +687,9 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 	/* Get reference so we can keep this file in LUO until finish */
 	get_file(luo_file->file);
 
-	WARN_ON(xa_insert(&luo_preserved_files,
-			  luo_get_id(luo_file->fh, luo_file->file),
-			  luo_file->file, GFP_KERNEL));
+	if (xa_load(&luo_preserved_files,
+		    luo_get_id(luo_file->fh, luo_file->file)) != luo_file->file)
+		WARN_ON(liveupdate_claim_file(luo_file->fh, luo_file->file));
 
 	*filep = luo_file->file;
 	luo_file->retrieve_status = 1;
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index b42369c3b1f30..3bd9ef442934e 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -87,13 +87,14 @@ int __init luo_session_setup_incoming(u64 sessions_pa);
 int luo_session_serialize(void);
 int luo_session_deserialize(void);
 
-int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd);
+int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd,
+		      u64 arg);
 void luo_file_unpreserve_files(struct luo_file_set *file_set);
 int luo_file_freeze(struct luo_file_set *file_set,
 		    struct luo_file_set_ser *file_set_ser);
 void luo_file_unfreeze(struct luo_file_set *file_set,
 		       struct luo_file_set_ser *file_set_ser);
-int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
+int luo_retrieve_file(struct luo_file_set *file_set, u64 token, u64 arg,
 		      struct file **filep);
 int luo_file_finish(struct luo_file_set *file_set);
 int luo_file_deserialize(struct luo_file_set *file_set,
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 403906937bc0f..74f8a1bf1da8c 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -284,7 +284,8 @@ static int luo_session_preserve_fd(struct luo_session *session,
 	if (session->frozen)
 		return -EBUSY;
 
-	err = luo_preserve_file(&session->file_set, argp->token, argp->fd);
+	err = luo_preserve_file(&session->file_set, argp->token, argp->fd,
+				argp->arg);
 	if (err)
 		return err;
 
@@ -307,7 +308,8 @@ static int luo_session_retrieve_fd(struct luo_session *session,
 		return argp->fd;
 
 	mutex_lock(&session->mutex);
-	err = luo_retrieve_file(&session->file_set, argp->token, &file);
+	err = luo_retrieve_file(&session->file_set, argp->token, argp->arg,
+				&file);
 	mutex_unlock(&session->mutex);
 	if (err < 0)
 		goto err_put_fd;
-- 
2.56.0.385.gd3acb90ef8-goog


