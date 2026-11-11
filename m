Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D463260A3834
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 00:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=TDyY6jHs
Received: by kanga.kvack.org (Postfix)
	id 2C86E6B05B3; Tue, 10 Nov 2026 19:24:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 279496B05B5; Tue, 10 Nov 2026 19:24:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16ECD6B05B3; Tue, 10 Nov 2026 19:24:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DDA996B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:24:12 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 67378401AE
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:12 +0000 (UTC)
X-FDA: 85420941144.24.639A6F8
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com [209.85.160.71])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9798510000B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=TDyY6jHs;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3qbXzaggKCEIhqexpegoksskpi.gsqpmry1-qqozego.svk@flex--dmatlack.bounces.google.com designates 209.85.160.71 as permitted sender) smtp.mailfrom=3qbXzaggKCEIhqexpegoksskpi.gsqpmry1-qqozego.svk@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794356650;
	b=TM4dsFWI5TtVtRhZ25g+CL46suKMRuw1YblrpHp2TcqUhojDLQ6DVcH6GPJIiJ1hx/Rkcl
	ywKCjxYAogJHFyFJqQyiTdr8y82cFvubbmHOnEAzBB8eEW794mmNF9P0GCIWfl2aAAzwJe
	DSs64sL4WK06akhxErxhrk78IfKh3Ds=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794356650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dZjUvSl6GBGHQXZVz9tTXU3E7O3MILwPWQjO+iuJXZc=;
	b=BvyIKwjzxb0m2x/1xK9Ky0r87/BiR9KL5/wPxGAwrw8YzWAXAQhSZpubSwyCvMOvohvB1q
	DpakdYUbVMTSRl/4Sl7juvmk6JFGswiRyczO552pWNualAAgNNtHgjtslCrsuHl6a0tXIM
	M3SFmPMtLBnHiN6xY4c0eh6yQiP7pyM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=TDyY6jHs;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3qbXzaggKCEIhqexpegoksskpi.gsqpmry1-qqozego.svk@flex--dmatlack.bounces.google.com designates 209.85.160.71 as permitted sender) smtp.mailfrom=3qbXzaggKCEIhqexpegoksskpi.gsqpmry1-qqozego.svk@flex--dmatlack.bounces.google.com
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-45e6091d8a1so1511199fac.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:24:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794356650; x=1794961450; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dZjUvSl6GBGHQXZVz9tTXU3E7O3MILwPWQjO+iuJXZc=;
        b=TDyY6jHs1zhfpm1VXukeAfnpy8Dt19lYeXLhsys9fN4jANQZ44MknHfqtRkfI2C6/q
         F1Yo7UEflSedqdNuAp67T8LweP2R1M8AY6DCEL2NDAKynTQjQ21rau0l+l+u0oyllGMI
         Paw9xVeZY7ax+7BtKZHI6VgV+sK8bjQ/MlrZT4iK+b2zhvhmDqusKQiU3LQANgBFqhWu
         hPt0IqYAvyqQ+UtNP/xTrMAkYiznmApnPJljQn7VNK2zQvV9M1MiH1vlAVMUOo8hvzjM
         q7xz4B4Pn2zBhFtQxiM9pbVYVfaWnv3V+Xy30XWL/VQS8Yli0DGGQvAZqWuaE0GthPP7
         twgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794356650; x=1794961450;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dZjUvSl6GBGHQXZVz9tTXU3E7O3MILwPWQjO+iuJXZc=;
        b=xDnL1IkkXvRzZUHOqjdjSbGWf6BawkIR8wMzK6E4HUYHuI5XOmdao8/AquJESjeFuy
         bzN7Vyf2bVSTCUvYDqu86M35yDlp7UU+kL+/Ce1fnEwR1+r8tpgmi2EegssWbx4mpL9Q
         Dypf/DyrxWjVgqbWiqOFs3fnGcfbAgp0XAQtt2BvYdd7/tCAirvs/tiZr+mT6u3uOy9k
         Dg2kkxa185VpkT9OiwCcEgdxoYQD49S5NltDHxaspEJpj4MF4Rv62wQ+3QT7ZW2cLHsA
         /f2kH8HGbje7YmzaRK4o7IJ6Wd3FINlh3ieMakzukjsYZvGc+NUGRMfoTsfOVNNCtbSp
         fRJw==
X-Forwarded-Encrypted: i=1; AL+hErFpIHm77GyHBFzIV86FXTvj9qrX9NE7oRATMGDn9lPsIWzYIDEUqoi7pdecM87aaVMbiGJzv2aGEw==@kvack.org
X-Gm-Message-State: APuU4Z+V1iStflZ1euCV6Odok9hykt8BDCf3SNaX2gqzKJ7vPrUwuxoO
	jhqMc6iX2hGv/0BAhcg+mKH7WLvNt1nM3O8HxON7xDIR8uLU6G0bicghXtqAFPxrsMBVWVxqEg4
	C4/czqNGVoSZA2w==
X-Received: from oacjm11.prod.google.com ([2002:a05:687c:2f8b:b0:4ad:864c:9c16])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6870:1b12:b0:4ad:5c5e:5e78 with SMTP id 586e51a60fabf-4ae46c19d98mr779351fac.36.1794356649468;
 Tue, 10 Nov 2026 16:24:09 -0800 (PST)
Date: Wed, 11 Nov 2026 00:23:40 +0000
In-Reply-To: <20261111002358.1842967-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261111002358.1842967-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261111002358.1842967-3-dmatlack@google.com>
Subject: [PATCH v4 02/19] liveupdate: Pass user argument to file preserve and retrieve
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
X-Rspamd-Queue-Id: 9798510000B
X-Rspamd-Server: rspam12
X-Stat-Signature: oi9r8h7b7ws7y8inxb1uzamiy7fcf6br
X-Rspam-User:
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794356650-355727
X-HE-Meta: U2FsdGVkX1/RS1pt111xVCp+cGgfNCaR0S4UPIG0GrQgPGwHfxxW6c5pnr4TSFSQLFBDFFGjGrXbpep3IaUbZomIS0CKaQLIRilhuf0QEn67h0LfaiK5FsNR1YFn2c2qKvC89VEe1m5u8kYeI0JrjohN9TNTdox+wM0x0D1+Ku1qrK/fpo6MTzJLWdfyYwCf6Qk1y6GieyMwCRGCNiCjYrxE2WilSnms7CVOSuaF86PVR3u2g3Jnj1L63hePXuQisxOo6WrwZLy0qP1dp0Yd4F7EKmLnyDb5r/ZdvKkgdfYOtGGwtz4WAo7Xj8IEUavNyTxVMPNjGhouHpnGvgi5QGDHNCHRwZAeFc3v0SZ6mPAdSpR9qzASzbNSoDh/1jHdT9ch/MYpbqzzR8NkPJ6bK8eX1S699hQEa+xNskajT5xiEVrnG+sAj0Ar/FLR2FLu7CR6MTc56bDU5cG4NJFpRztLmZ3QJSOTJdvemZ3WpG59cgiDcCBzAo8ZMDCwUdSmv24GqZByVJuqPRzlcOnNVkEQYVjug3NdhXErDtOnY2nr530ieyebN0jG/crb3LFXQR2ZfD0VGecgGPqR4e1Wy0Pgq/uJbzM77j20v+6LZmMtPmLyD0g34+drpUj2VPl688StQ3LFMjLpg+VRz0P+vs69TDRwNQUZiW0rDnFbgQfVNg0gxJqSfzmDwoyYf3nl4Kto6JPRH4ZFD0/jMPUx/U3znNxo6n4B4vSJbL1gwdPUd/N+6iqAJpS7sbtZWE2kxSIApdW7WdNWMIOUpJg7V1TDmyyRct/p8ozg25dMf/yp4UCK8NG+5jZkrTUJsd3mqq+Odb18HNVL/cLOYZ2hAVZgzaz4mpWOZ5Sn62zcqaBP8a4rgseThRujmARwjw9Bd8YkEYV1i151zHvkSCb3tB2NkK/ZhZ06fe3UTib8ysDvDtAijvm04To7U5EdqCVSgXzKP+NLyReYvJJbGHs
 rDJvnHvz
 f9r7VyNe7wmQXdMwQBiVpUhV44Up3TkC/0wquhDMA/yNqOPDe80vD7p60/xGJTm4wExLdaQJRINrof1QdMjQxVEjcyaYg1LkyLt7V3sMnwD+kq16++3eMu7YrLPOknPwrF+ffURtbFb/vC6qmsH7ydTQJtwPINYbS+tEqVIucK1H1z17FH0Q5IbxO+7nVwRfJ8v8F1RaK+LYfShCLvcvduYXEJUfrdsoLsYDk3w/amhjBS4Z2QA2OaCvbB9Kub1lXE5yH8GAph0h7Q3pWrsW76/jd6XpHbyhMoIrzT+2szyEgqsdgy8vQyf+pXPnD2SbKfZs/mpSKQbad1mdL/LFQuXXW81vobaTDJUbOo471Ox+CtzQJjfwaSdu+Q3D1M39rNJOUJiC8PNvegZeqetVTxEAloGgRr4+apIUFQ2FxHaB86DUfzbAw6nr0xz1TygXUKmVBUHXYZdhZ+w9F6WOuiXqgO+MkI6RN4DYVurutVBjehMWGD/kJIjEIXBlrieel4KSd8t/i0ovqKExaRFzYE9Yn6MVNj+Typpwg6Cgb0YKmC1J0kJ5AqTlVEMyjgUDvyl6Mdoy2b/nB0V4eewbt6ZBDWkvgevfx3I8Vss+fOhEALmVrYc/e8SY5NtYg1ik2hDJW5jbxM7tvK+fbUPZp9cJ/GuXWTXtCpqo7XujjUWNr/DLd8ReTu4asVxxJBZYyCTZWbq7kYXPfDKs/nfxeIhdm3x1E/aCzx9I/nG5c8N1kBXkMBM0sGy46bIvutaVG62lS40eADBGqbf0=
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
additional context during preservation or retrieval, such as the file
to restore into on retrieve, or other handler-specific parameters,
without introducing separate ioctls for each file type.
Whether the argument is required, optional, or unused is defined by the
file handler.

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
 include/linux/liveupdate.h       | 44 +++++++++++++++++++++
 include/uapi/linux/liveupdate.h  | 10 +++++
 kernel/liveupdate/luo_file.c     | 65 ++++++++++++++++++++++++++++++--
 kernel/liveupdate/luo_internal.h |  5 ++-
 kernel/liveupdate/luo_session.c  |  6 ++-
 5 files changed, 122 insertions(+), 8 deletions(-)

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
index 4043d4038712..87e77c3bfd82 100644
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
+ * descriptor for the same file. Passing a non-zero @arg in that case fails
+ * with -EBUSY, since @arg only applies to the retrieve that restores the file.
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
index a42b60356d52..1437630d435e 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -126,6 +126,7 @@
 #include <linux/xarray.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/uaccess.h>
 #include "luo_internal.h"
 
 static LIST_HEAD(luo_file_handler_list);
@@ -202,11 +203,43 @@ static bool luo_token_is_used(struct luo_file_set *file_set, u64 token)
 	return false;
 }
 
+static int luo_copy_user_arg(const void __user *uptr, const void **argp,
+			     const struct liveupdate_arg_spec *spec)
+{
+	void *karg __free(kfree) = NULL;
+	u32 user_size;
+	int err;
+
+	if (!uptr)
+		return 0;
+	if (!spec->size)
+		return -EOPNOTSUPP;
+
+	if (get_user(user_size, (const u32 __user *)uptr))
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
+ * @arg:      User-space pointer to the handler argument structure, or NULL.
  *
  * This function orchestrates the first phase of preserving a file. Upon entry,
  * it takes a reference to the 'struct file' via fget(), effectively making LUO
@@ -227,10 +260,12 @@ static bool luo_token_is_used(struct luo_file_set *file_set, u64 token)
  *         -EBADF if the file descriptor is invalid.
  *         -ENOSPC if the file_set is full.
  *         -ENOENT if no compatible handler is found.
+ *         -EOPNOTSUPP if @arg is non-NULL and the handler takes no arg.
  *         -ENOMEM on memory allocation failure.
  *         Other erros might be returned by .preserve().
  */
-int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
+int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd,
+		      const void __user *arg)
 {
 	struct liveupdate_file_op_args args = {0};
 	struct liveupdate_file_handler *fh;
@@ -266,10 +301,14 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
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
@@ -293,6 +332,7 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	if (err)
 		goto err_kfree;
 
+	kfree(args.arg);
 	luo_file->serialized_data = args.serialized_data;
 	luo_file->private_data = args.private_data;
 	list_add_tail(&luo_file->list, &file_set->files_list);
@@ -306,6 +346,8 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	luo_flb_file_unpreserve(fh);
 err_erase_xa:
 	xa_erase(&luo_preserved_files, luo_get_id(fh, file));
+err_free_arg:
+	kfree(args.arg);
 err_module_put:
 	module_put(fh->ops->owner);
 err_fput:
@@ -535,6 +577,7 @@ void luo_file_unfreeze(struct luo_file_set *file_set,
  * luo_retrieve_file - Restores a preserved file from a file_set by its token.
  * @file_set: The file_set from which to retrieve the file.
  * @token:    The unique token identifying the file to be restored.
+ * @arg:      User-space pointer to the handler argument structure, or NULL.
  * @filep:    Output parameter; on success, this is populated with a pointer
  *            to the newly retrieved 'struct file'.
  *
@@ -554,10 +597,12 @@ void luo_file_unfreeze(struct luo_file_set *file_set,
  *          kernel.
  * Return: 0 on success. Returns a negative errno on failure:
  *         -ENOENT if no file with the matching token is found.
+ *         -EOPNOTSUPP if @arg is non-NULL and the handler takes no arg.
+ *         -EBUSY if @arg is non-NULL and the file was already retrieved.
  *         Any error code returned by the handler's .retrieve() op.
  */
 int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
-		      struct file **filep)
+		      const void __user *arg, struct file **filep)
 {
 	struct liveupdate_file_op_args args = {0};
 	struct luo_file *luo_file;
@@ -584,6 +629,13 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
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
@@ -593,10 +645,15 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
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
@@ -995,6 +1052,6 @@ int liveupdate_get_file_incoming(struct liveupdate_session *s, u64 token,
 				 struct file **filep)
 {
 	return luo_retrieve_file(luo_file_set_from_session_locked(s),
-				 token, filep);
+				 token, 0, filep);
 }
 EXPORT_SYMBOL_GPL(liveupdate_get_file_incoming);
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index dac6644bfb18..e0be84acb33b 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -101,14 +101,15 @@ int __init luo_session_setup_incoming(u64 sessions_pa);
 int luo_session_serialize(void);
 int luo_session_deserialize(void);
 
-int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd);
+int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd,
+		      const void __user *arg);
 void luo_file_unpreserve_files(struct luo_file_set *file_set);
 int luo_file_freeze(struct luo_file_set *file_set,
 		    struct luo_file_set_ser *file_set_ser);
 void luo_file_unfreeze(struct luo_file_set *file_set,
 		       struct luo_file_set_ser *file_set_ser);
 int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
-		      struct file **filep);
+		      const void __user *arg, struct file **filep);
 int luo_file_finish(struct luo_file_set *file_set);
 int luo_file_deserialize(struct luo_file_set *file_set,
 			 struct luo_file_set_ser *file_set_ser);
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 74bc66929f4b..0d7533f0bde6 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -268,7 +268,8 @@ static int luo_session_preserve_fd(struct luo_session *session,
 	int err;
 
 	guard(mutex)(&session->mutex);
-	err = luo_preserve_file(&session->file_set, argp->token, argp->fd);
+	err = luo_preserve_file(&session->file_set, argp->token, argp->fd,
+				u64_to_user_ptr(argp->arg));
 	if (err)
 		return err;
 
@@ -291,7 +292,8 @@ static int luo_session_retrieve_fd(struct luo_session *session,
 		return argp->fd;
 
 	mutex_lock(&session->mutex);
-	err = luo_retrieve_file(&session->file_set, argp->token, &file);
+	err = luo_retrieve_file(&session->file_set, argp->token,
+				u64_to_user_ptr(argp->arg), &file);
 	mutex_unlock(&session->mutex);
 	if (err < 0)
 		goto err_put_fd;
-- 
2.56.0.542.g3ef89b7020-goog


