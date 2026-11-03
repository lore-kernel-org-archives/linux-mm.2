Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46F67606D80C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=iR9N13vp
Received: by kanga.kvack.org (Postfix)
	id 278B06B05C2; Mon,  2 Nov 2026 20:02:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2283F6B05C3; Mon,  2 Nov 2026 20:02:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07CC76B05C5; Mon,  2 Nov 2026 20:02:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C165A6B05C2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:02:28 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 588EFA7C6F
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:02:28 +0000 (UTC)
X-FDA: 85392007176.17.167AB34
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9822F80005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:02:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=iR9N13vp;
	spf=pass (imf30.hostedemail.com: domain of 3oTLpaggKCAonwk3vkmuqyyqvo.mywvsx47-wwu5kmu.y1q@flex--dmatlack.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3oTLpaggKCAonwk3vkmuqyyqvo.mywvsx47-wwu5kmu.y1q@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793667746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CXmcsr03beTQ8xlBqjCRm81CrLxSN7H4gKDXk/k8RWw=;
	b=WqSPsmppZamqi41P9MzfZZNg9b+IWPVTrIbSnmb3bzDgIXBY7AVUq7sB0YY+Di5reoXioN
	4vBDFnAZsXS0JcSV529XNOYtE0FxKJGdnLTMhytq7MPuvKJOizPOV1KH7+F5kW20hUQbdd
	XXHHUj0LPoYetyduS2ZxXcGHlckHIOc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=iR9N13vp;
	spf=pass (imf30.hostedemail.com: domain of 3oTLpaggKCAonwk3vkmuqyyqvo.mywvsx47-wwu5kmu.y1q@flex--dmatlack.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3oTLpaggKCAonwk3vkmuqyyqvo.mywvsx47-wwu5kmu.y1q@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793667746;
	b=kf+nD/ebBuBpR5DyHxzExwx6QhUEPqy0XwNLmasvz2K4dhH5ujZ63JwL8GvUMxQyTmISKh
	OedHbtQfYk8LIx1BIBn6w2SbeA8B6Rie/ayz9av09PddxQ0H/5G+/2Cve2+rpDdmGD6OmQ
	HQIUuxV/JjJJC0d3wXgcR86W2uUO9L0=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2eaae62796dso41186385ad.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 17:02:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793667745; x=1794272545; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CXmcsr03beTQ8xlBqjCRm81CrLxSN7H4gKDXk/k8RWw=;
        b=iR9N13vpnTF5HSnGoHQouL4Irwvx/87X0UzmxhZvvW9H+6pFDwoPHY4OQegmrCrgvU
         TVWtYBaceTwGzswNKd65s4SqMSylUD+YwnEVmdy5jYiur0Zomh2ie7e5b1jCKMr12neI
         mN77iyFFdCKjo8RmV4ESy5cHhYymQ5TexZPoUmMlsaXrqhia6/yb9fcuIyX8rfHMyf5K
         G2akGsbJ7j1do5zlLus9NWb4PpKIJEH0eYaXYYl+05AERer5iejTUi9PTgOAba77zFWM
         7vQQcVI6ucOXBCS2n/n+/1tbbMXAmOHlUCu9foG8Trec+kcjLwqiR9fD5wjuyVQ4m4+9
         qKrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793667745; x=1794272545;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CXmcsr03beTQ8xlBqjCRm81CrLxSN7H4gKDXk/k8RWw=;
        b=B25E3cKYZYeB7ypzVYRCvqfJeQqFCwecAYJ1Fvmao0RY904lyLTpe7JYZdb+0Zz1Ir
         hURE6KIj63YpvEMCQKSkQPY6j3v2u2evdxAyqTuc0eMoG2pEpcQySylMITEd/OPHqZX+
         XrEaliXLCgavpBtj7YzSCVTcW0UMqCk8IlqyKCHKLaVKpPJC+oP6P0rQC5Y9AI9ugSvY
         WYhMAjrDE4DdEsC9BsBNKrCHOFzFDNvDj0PEWTmo7MemDgRVfDURThht37YjX8pDvpp8
         8TbSJL3btRNoz2B6As7iH1uVcl5B2LifUSFTL5AthFCpPmexBxdw1morWJIC/XerZZ8p
         1L4A==
X-Forwarded-Encrypted: i=1; AKwUvBzld2qWVQe9dCWyojJFn9ZNQNhZolmAKCvMEkntSKRBEI/62nQL4UEWybSPXE4pLKzmzPS6rAECTA==@kvack.org
X-Gm-Message-State: APuU4Z8/CY4loXHFx/rLT5BgYHneUxi7In08XT2Ze9BhI5WSlsTQtRbN
	mgl4MdgN0W3z6STmLGEps+W8y3hORdc/ZBKofrTmeD4mVc3aEvN51tBoEkhum1G5qG0Ocqs8UBs
	owUPhXNhAuDXwng==
X-Received: from plgb16.prod.google.com ([2002:a17:902:d510:b0:2ea:33e2:bb1e])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:cf4c:b0:2dd:c100:7cc8 with SMTP id d9443c01a7336-2eb3651f559mr98259395ad.68.1793667745042;
 Mon, 02 Nov 2026 17:02:25 -0800 (PST)
Date: Tue,  3 Nov 2026 01:02:07 +0000
In-Reply-To: <20261103010216.3447716-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261103010216.3447716-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
Message-ID: <20261103010216.3447716-2-dmatlack@google.com>
Subject: [PATCH v3 01/10] liveupdate: Pass user argument to file preserve and retrieve
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org
Cc: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: mgwiceogutnccw73rgtkix1o7ytnc1rx
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9822F80005
X-HE-Tag: 1793667746-695636
X-HE-Meta: U2FsdGVkX19LwVneCfVK9b8fTVpBrl4vk7rfRVlkrYxuhNBY7UdzKkKyE9OZC4D9Z+CbGqF2pcAyowiITg5yR1MJAV8Ui43pip9hWNe3itoGeiIkF9nvZjiNr6zZKzNVmn8tUDpR5gHuu6TI0KBbHafB2NKbZd2dggpvM7FZPMHMmooaPruC9tF/CdBVCZoNu7VtYCpKcV7P0vopJMh1uTvplL2FrdfG5NY3nOUHRGLN0imWeMlHtN3QRKajbwujKGMZC35wc/Y7+LJmifIGN7Ii8jjdcYVtkroc2nNVn/cFMaQv+vCIEyoMXciivMAcTItUGoq9s/IOzLkhbw2f8VlZoqqfS+pPz0McYvzZlbNGwqR6MLw2JiikFcvfi9Dmoo7RcO3raUVP3JhIqcJ9PRSm0H9BvpVUMYUpjuq3UhuZGozXGAmF5kLSMOjRXLFkspvCs1yARKYI3WOfXLMpUvXej7H2W1KokljlG3hNrwIQO3R8YdF7hMUNjrH7VLviAHzx2G0T44nz1oXmrhjKPnNZeGkD5h9T+cmP81TCbiYg+8qorjp25ym5WoxGNCyWe+xgJfh6LU7RksG17cM470kDQ7nChLGoC59OqNdAFMHz3GLrsZdo78pKIo5Ao6hk7E6VH38qZcPKoSx+7J7tvGJ+Q63UikCJm2QwbK/CyB+Z3iJT76hgxGpEavTnwZNWRE+RnHjBijczJxtIg6D8sxYsmBWJ+gXo7LgI1D/BbLRYMnqrT5tAKRqIIstDwZRarLwvvnLnZXycs1mXWjwKjsOGUI10HyCVs63X0hpfE+R8w+gWf/yF4fe1e/Jg2uIFthKnVgMdh8wNYXhsDK434eSTRGy07p4dBxDYe+XAktNAjxZUIiMgab6a/aVlxNs0xwwB2ebm5UlGfgOiKdJEI6Sk3ybvsgzzvivUOl/kHn2U09T5gFxilirvWzg9wUZQfJGrJLU8BtRTerr4vKc
 Au55/twT
 ngoHM3HXFSVMbH3pUHJE2O3QZTv+9XN1oZZ7dEUQy0h1woCYwvuNeljnxBPnXlJrwqY6akHhdfOVOoJzqcDRZhZpgCcjF8SLD8CB6SueZurxWogLsK7B7rHmlCru3iUMr3DiF4Cc+DsgxALH25gNY2udYbtlq4vi/h3tedEzS+N+JKI1/PH2sudmmfGBusKYUjdkPTCFy2KpllpcPKTiu7Hl4sAClJYTJNM3rRZXJz0MBCIuEJOYdX1Uam9ZFFC+vWTMTYtLlRWLpWeLn19tE7n6jbXUFYpHWRaVb7tm2n5taujXPCoYQ2fF+3oP4Oqo7pooaLOgrqMwe5n7yepXlI+8q4u7mn6C/osj4lPaF8cJzGy+q89il+/l2HhnZ9pS5sbLhZg7U6U7aQTHeOtqdh6hPKHPWsz4Eqj85iX+MdfbKzbs0W6JKG+NXTUS2KzyB/LoNUb3hj/nivvykPDk4V+c4hIYvfEz2EhxTMz16/oJZfO9ia0yMWRFe/HwQWxA3U+DNNWYm0lLwCbD0KE1rzwZ0ZtjksO7pExdcoPX0DVTOid1DxNWdSesPDSQoP5p9/+XNc5FUdW6k/DlX8TLu1FEkk5jQnOGljl0esIdVxdgfegVxL9VgKuE00tL1mdp9EmmLDX/7YpLAXeHZFpkb4z74MQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Pasha Tatashin <pasha.tatashin@soleen.com>

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

The argument only applies to the retrieve that restores the file.
Retrieving a token that was already retrieved returns the existing file,
so fail with -EBUSY if a non-zero argument is passed then, instead of
silently ignoring it.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 include/linux/liveupdate.h       | 44 +++++++++++++++++++
 include/uapi/linux/liveupdate.h  | 10 +++++
 kernel/liveupdate/luo_file.c     | 73 +++++++++++++++++++++++++++++---
 kernel/liveupdate/luo_internal.h |  5 ++-
 kernel/liveupdate/luo_session.c  |  6 ++-
 5 files changed, 128 insertions(+), 10 deletions(-)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index 6051abc0612c..7543f5d648d3 100644
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
@@ -40,6 +70,11 @@ struct file;
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
@@ -51,6 +86,7 @@ struct liveupdate_file_op_args {
 	struct file *file;
 	u64 serialized_data;
 	void *private_data;
+	const void *arg;
 };
 
 /**
@@ -68,6 +104,12 @@ struct liveupdate_file_op_args {
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
@@ -84,6 +126,8 @@ struct liveupdate_file_ops {
 	bool (*can_finish)(struct liveupdate_file_op_args *args);
 	void (*finish)(struct liveupdate_file_op_args *args);
 	unsigned long (*get_id)(struct file *file);
+	struct liveupdate_arg_spec parg;
+	struct liveupdate_arg_spec rarg;
 	struct module *owner;
 };
 
diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
index 4043d4038712..e806752c2fc6 100644
--- a/include/uapi/linux/liveupdate.h
+++ b/include/uapi/linux/liveupdate.h
@@ -126,6 +126,8 @@ struct liveupdate_ioctl_retrieve_session {
  * @size:  Input; sizeof(struct liveupdate_session_preserve_fd)
  * @fd:    Input; The user-space file descriptor to be preserved.
  * @token: Input; An opaque, unique token for preserved resource.
+ * @arg:   Input; User-space pointer to a file-handler-specific argument
+ *         structure starting with a 32-bit size field, or 0 if unused.
  *
  * Holds parameters for preserving a file descriptor.
  *
@@ -149,6 +151,7 @@ struct liveupdate_session_preserve_fd {
 	__u32		size;
 	__s32		fd;
 	__aligned_u64	token;
+	__aligned_u64	arg;
 };
 
 #define LIVEUPDATE_SESSION_PRESERVE_FD					\
@@ -160,6 +163,8 @@ struct liveupdate_session_preserve_fd {
  * @fd:    Output; The new file descriptor representing the fully restored
  *         kernel resource.
  * @token: Input; An opaque, token that was used to preserve the resource.
+ * @arg:   Input; User-space pointer to a file-handler-specific argument
+ *         structure starting with a 32-bit size field, or 0 if unused.
  *
  * Retrieve a previously preserved file descriptor.
  *
@@ -173,12 +178,17 @@ struct liveupdate_session_preserve_fd {
  * attempts to retrieve the token fail with the same error code. Failed
  * retrieves are not retried.
  *
+ * Retrieving a token that was already retrieved successfully returns a new file
+ * descriptor for the same file. The @arg only applies to the retrieve that
+ * restores the file, so passing a non-zero @arg then fails with -EBUSY.
+ *
  * Return: 0 on success, negative error code on failure (e.g., invalid token).
  */
 struct liveupdate_session_retrieve_fd {
 	__u32		size;
 	__s32		fd;
 	__aligned_u64	token;
+	__aligned_u64	arg;
 };
 
 #define LIVEUPDATE_SESSION_RETRIEVE_FD					\
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index a39992da504f..eeeb3b5ff2fa 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -126,6 +126,7 @@
 #include <linux/xarray.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/uaccess.h>
 #include "luo_internal.h"
 
 static LIST_HEAD(luo_file_handler_list);
@@ -202,11 +203,45 @@ static bool luo_token_is_used(struct luo_file_set *file_set, u64 token)
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
@@ -222,9 +257,11 @@ static bool luo_token_is_used(struct luo_file_set *file_set, u64 token)
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
@@ -239,10 +276,12 @@ static bool luo_token_is_used(struct luo_file_set *file_set, u64 token)
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
@@ -278,10 +317,14 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
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
@@ -305,6 +348,7 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	if (err)
 		goto err_kfree;
 
+	kfree(args.arg);
 	luo_file->serialized_data = args.serialized_data;
 	luo_file->private_data = args.private_data;
 	list_add_tail(&luo_file->list, &file_set->files_list);
@@ -318,6 +362,8 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	luo_flb_file_unpreserve(fh);
 err_erase_xa:
 	xa_erase(&luo_preserved_files, luo_get_id(fh, file));
+err_free_arg:
+	kfree(args.arg);
 err_module_put:
 	module_put(fh->ops->owner);
 err_fput:
@@ -547,6 +593,7 @@ void luo_file_unfreeze(struct luo_file_set *file_set,
  * luo_retrieve_file - Restores a preserved file from a file_set by its token.
  * @file_set: The file_set from which to retrieve the file.
  * @token:    The unique token identifying the file to be restored.
+ * @arg:      User-space pointer to the handler argument structure, or 0.
  * @filep:    Output parameter; on success, this is populated with a pointer
  *            to the newly retrieved 'struct file'.
  *
@@ -566,9 +613,11 @@ void luo_file_unfreeze(struct luo_file_set *file_set,
  *          kernel.
  * Return: 0 on success. Returns a negative errno on failure:
  *         -ENOENT if no file with the matching token is found.
+ *         -EOPNOTSUPP if @arg is non-zero and the handler does not accept an arg.
+ *         -EBUSY if @arg is non-zero and the file was already retrieved.
  *         Any error code returned by the handler's .retrieve() op.
  */
-int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
+int luo_retrieve_file(struct luo_file_set *file_set, u64 token, u64 arg,
 		      struct file **filep)
 {
 	struct liveupdate_file_op_args args = {0};
@@ -596,6 +645,13 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 	}
 
 	if (luo_file->retrieve_status > 0) {
+		/*
+		 * The argument only applies to the retrieve that restores the
+		 * file. Don't silently ignore it.
+		 */
+		if (arg)
+			return -EBUSY;
+
 		/*
 		 * Someone is asking for this file again, so get a reference
 		 * for them.
@@ -605,10 +661,15 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 		return 0;
 	}
 
+	err = luo_copy_user_arg(arg, &args.arg, &luo_file->fh->ops->rarg);
+	if (err)
+		return err;
+
 	args.handler = luo_file->fh;
 	args.session = luo_session_from_file_set(file_set);
 	args.serialized_data = luo_file->serialized_data;
 	err = luo_file->fh->ops->retrieve(&args);
+	kfree(args.arg);
 	if (err) {
 		/* Keep the error code for later use. */
 		luo_file->retrieve_status = err;
@@ -1007,6 +1068,6 @@ int liveupdate_get_file_incoming(struct liveupdate_session *s, u64 token,
 				 struct file **filep)
 {
 	return luo_retrieve_file(luo_file_set_from_session_locked(s),
-				 token, filep);
+				 token, 0, filep);
 }
 EXPORT_SYMBOL_GPL(liveupdate_get_file_incoming);
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index dac6644bfb18..4126b71e9a2e 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -101,13 +101,14 @@ int __init luo_session_setup_incoming(u64 sessions_pa);
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
index f48e9a4185f9..ed9d53c7db77 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -267,7 +267,8 @@ static int luo_session_preserve_fd(struct luo_session *session,
 	int err;
 
 	guard(mutex)(&session->mutex);
-	err = luo_preserve_file(&session->file_set, argp->token, argp->fd);
+	err = luo_preserve_file(&session->file_set, argp->token, argp->fd,
+				argp->arg);
 	if (err)
 		return err;
 
@@ -290,7 +291,8 @@ static int luo_session_retrieve_fd(struct luo_session *session,
 		return argp->fd;
 
 	mutex_lock(&session->mutex);
-	err = luo_retrieve_file(&session->file_set, argp->token, &file);
+	err = luo_retrieve_file(&session->file_set, argp->token, argp->arg,
+				&file);
 	mutex_unlock(&session->mutex);
 	if (err < 0)
 		goto err_put_fd;
-- 
2.56.0.385.gac671c819a-goog


