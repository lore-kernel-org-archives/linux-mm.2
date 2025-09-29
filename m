Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 370ABCAC5BC
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 01:04:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E6688E0016; Sun, 28 Sep 2025 21:04:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 697128E0006; Sun, 28 Sep 2025 21:04:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C3F88E0016; Sun, 28 Sep 2025 21:04:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 301E08E0006
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 21:04:36 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F0CB9118DBF
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:04:35 +0000 (UTC)
X-FDA: 83940492510.04.8FF4771
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2DF8D16000D
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:04:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Xy1JWpqY;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759107874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eKSQxJd378SNA6x6L2UHx48FuJQFa6/qcFSRD3fSLhE=;
	b=wq1LF5Q1GcOw8ATcV//CA8IU4hEbo9B34eD83lLE2PRADEqE1hMAfc289HTrTJJi/gG1D9
	0qogm6RIVAwsPbb+tbj41onPq8GGDxGEcKv4F6vqawAOoYIXlBEsF/vYV0D3+ZDEtCiuG4
	WkZkm3+bqLIyBfm3AudtybUTb3io/lM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759107874; a=rsa-sha256;
	cv=none;
	b=qbgOTjlgmIURF+V0etnoBtb7muwdZdD5UF6R4QO2cPjJWzx1it1lRN7iylcAs4EGh2Q0OU
	xUhZSsB5m3tlw3UujGpbqjQU3IUQowrNNSZUfnGjANNo+GjW/yCAkLBByDKXD1HRD+dk0b
	JntWuk+3pctvkUNjSbGi19kKSYtIye4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Xy1JWpqY;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-858183680b4so548701585a.2
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 18:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759107873; x=1759712673; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eKSQxJd378SNA6x6L2UHx48FuJQFa6/qcFSRD3fSLhE=;
        b=Xy1JWpqYF8Aw0m1hbyj4kCi3sxO+3eqOU21fH43X30b8eryNxf02MdFPUKQ5stmpss
         GqGrVAM5g97MtNs/TAIYdFVe6EusVCPqYIXmIpMsJYqK+6gv+JjysHoiYCqGeI93XE+1
         lCE5BTRnLBy62tc5HeEd33BjrCienbl2IBM5M6P1FkIqLghvkDNJPda3XGbBnyh0XwlS
         g5fsdRXATmTr4AVCWwW0oNbeQaXx+XFSoLWe7ugqHeP6gKyY+fUHAC14MgjcyXAZVlQL
         0gVejDlWVXFC3cM20hnLBvMrjdUNuMKpK/3Ugwrk+6X7TLG3duhBiK9/lWy+gfLBHWzZ
         0ikw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759107873; x=1759712673;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eKSQxJd378SNA6x6L2UHx48FuJQFa6/qcFSRD3fSLhE=;
        b=fMB/Zshd51rG6/COzp/sILxEczzPyG0Ol0A/VUTqZXf6FECKL+hnBlgmEqlgLRSQB7
         Kf62QEYORhSF7sh5hX4zo61svXTnLTqwpHMVL17RcFIRoMVeF5lY2YITHRwgF2IqQ8UD
         teJV97iihT6Qbzk5qnU0cfU4LL/lWYbdaP41gtmZuPrGJwDMhqNovqf+RtLW5qP6xlD7
         ba3NarL/CnlU2QL8HSKMK8dPyOTjMnlPd9WfpZeVZIX8us2xz6XoYZxNo1/akhRc1l/o
         jRtbg0TUMo8OIa0FCGLH8VLdFEb6hmZ0Cmc/UPOHawDJXq3PzB/hrUxIURSwk/0yQB/t
         JjBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWc0BhW/3vF2IiQTTC8tNKpRF6voXIoiYe7Tk5P0L9gSJ4PxVh8PHqnQ34p1Y2xdaY1GqMMsE+1Jg==@kvack.org
X-Gm-Message-State: AOJu0YwlCPTUuS67A8yk/23lr+YEvkyctLwBIqJKOIzuOhz8xd/lm2Vu
	lX4TTD/H10BosS8HinXzgZNk7sEwGqJ7K0s+1Zekcm6MFmzeWaP9iaMIKlnjbjyJBdQ=
X-Gm-Gg: ASbGnctQBaYAW8pznBNRxEisUKMIap5p7Tt+OZFb7RgA4NdpFgq3IkN/JjO51331d6j
	2Ox8zLirqNafFDS3RZIfNptClr73VbLsvlHv2Ik2HCHDFi2pf4e32j6janQwaz7aJSZYXG6oW1S
	bDPeL/Ibao65O3DF+kJdIuAxyt7sxbIrZD2BcRtKUr7wAJL+fZVwXCl+WG2MSKTOlx/GtIN5zMa
	R8tgJAxZ9cJPsC6DAZy0UkWBuZl8X2Mk1lYGCnbW6yw7Yv8VSkMImqdPjHHZrJDbPjop+oYHtLE
	ZpAm7Rbl3YNf2rtOwnA6knrmnFAH0sS3UbgLQoHu47ASKK6Vk7nnwt6BSKbR314vWzl3P1PxOYP
	3ku2eN6BAChU4WjzfphZe11hbHF+vvAZ4l1PBJFoM2XY829T51YqgXm+5dm6JnwehaVzJdTs3MP
	hJQPdNQVljAQmFl7zFQg==
X-Google-Smtp-Source: AGHT+IGVEo5UaPwVVHkZnI4b3W4Xx5HgtH7j7YrypJxN5nCk7Gsj9C4puufgqUDBeLEBZKkEb1nMwQ==
X-Received: by 2002:a05:620a:4722:b0:826:ef9:3346 with SMTP id af79cd13be357-85ae033d193mr1866752785a.18.1759107873040;
        Sun, 28 Sep 2025 18:04:33 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4db0c0fbe63sm64561521cf.23.2025.09.28.18.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Sep 2025 18:04:32 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	changyuanl@google.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com,
	ojeda@kernel.org,
	aliceryhl@google.com,
	masahiroy@kernel.org,
	akpm@linux-foundation.org,
	tj@kernel.org,
	yoann.congal@smile.fr,
	mmaurer@google.com,
	roman.gushchin@linux.dev,
	chenridong@huawei.com,
	axboe@kernel.dk,
	mark.rutland@arm.com,
	jannh@google.com,
	vincent.guittot@linaro.org,
	hannes@cmpxchg.org,
	dan.j.williams@intel.com,
	david@redhat.com,
	joel.granados@kernel.org,
	rostedt@goodmis.org,
	anna.schumaker@oracle.com,
	song@kernel.org,
	zhangguopeng@kylinos.cn,
	linux@weissschuh.net,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	gregkh@linuxfoundation.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rafael@kernel.org,
	dakr@kernel.org,
	bartosz.golaszewski@linaro.org,
	cw00.choi@samsung.com,
	myungjoo.ham@samsung.com,
	yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com,
	quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com,
	ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com,
	leon@kernel.org,
	lukas@wunner.de,
	bhelgaas@google.com,
	wagi@kernel.org,
	djeffery@redhat.com,
	stuart.w.hayes@gmail.com,
	ptyadav@amazon.de,
	lennart@poettering.net,
	brauner@kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	saeedm@nvidia.com,
	ajayachandra@nvidia.com,
	jgg@nvidia.com,
	parav@nvidia.com,
	leonro@nvidia.com,
	witu@nvidia.com,
	hughd@google.com,
	skhawaja@google.com,
	chrisl@kernel.org,
	steven.sistare@oracle.com
Subject: [PATCH v4 14/30] liveupdate: luo_session: Add ioctls for file preservation and state management
Date: Mon, 29 Sep 2025 01:03:05 +0000
Message-ID: <20250929010321.3462457-15-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
In-Reply-To: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2DF8D16000D
X-Stat-Signature: z5qoby14kj8abazwsq74tub5rj96578k
X-Rspam-User: 
X-HE-Tag: 1759107874-804137
X-HE-Meta: U2FsdGVkX1/egx7C09eu4bbz441ZGbDo5uqjG3KAOydMLYMtqIeutFn9umxLrh5YNnpdctGnsE+XGLsUk2D50WDixGe/pCYgkqPOfZwcJBsxe14L4q/jxI5+rNfVI1sniCGT2AJckXtRCtMhYV9/BNg3Tk0JZuAPh8lxXF/T6x/yNPMu5JYI/NKS6xtFM56rGuMdU4dIAcWrHJMLzTvK3zC5ttz39hy3ShQGW8i/vX2BNISqeAnGJuudmpVofOcKXnbEp7Ivr78Qj8IN5ObS5eVIncsRKEq8L7i3/b77BzwX4dwd/dadzMYU1w5mwpCt5k71s6/WXjrVqU6tT67poH0ilHFpiWEsePSCSPLgSROzIlAa0H1gTa8y4TVkxPmNhA1OZ7pl1O+4qS4NTMkPfVujya69bqnwr43pdc/nlQa65K+7fdKMx7k1kXuegDMzYEv7okKAEiV+4W6S0GTX9SSIJgKKSzw8mkKtWk+28ywURHhybYNmJIMIRUZdGFmHY66n4Usj3qdevE7QRVqZswUbo25N5IwBzHyk5edXcm4qGJt4fIEVAh5eid6H1MhwnbJi2NPLq6Q56SAzgnsk/a3QdUkdVwXbK80/kB9Vbp4vISvhYapfEMtx/TqQfRol5XjhxCrT+pvz2ehYs+cXOK/Pj6KE11aqvzgXFu8ucFoJXuOmuQmPUd7vUF7jQh+wI8Ga+BktLkqKaCU8M8/a9h0NHyo2xUJTx+nqzsSW4FTyT7NqbxZ8wAzuNLrjF+0epWIalTDtGu4gGn3xkxoT8XQ4Epol46TghcvU40eRR64EkddADOCnI5jppqus6YY/pk1VH5gNW5qNLMmf5NcokphlCsZsylJfgdUbUKwS/meCDzJ0zKQYmSuSgw/Tk9q/TY4JgEkCvgZMLgVPXpfoZfiWfI5SB2H3WNj0GiiR9xJlzkMfLMLl56N4n+Z2FPDZsI6AhcXptJcweAS7tMH
 KApbVGVq
 JTpODAmQ++HGyqOh4XOXDwYlAAxdpDXJKqlDKlCmFCWaNvzpA6nP/OgBxt3MR/7K849XNNLsGOA61qp/5bPZ9W0X29jV3jcHkCOFnXxCDuVlbZGa+uxgzc4rzzUVXirsaHnuuwtm4MbiiPJ3/HPJ/iYMXr7KYmv0sTse1/c+n9j8xofy8GFuH4hu9yGR0E/HrFBL1SR+9ngxpVmgaFl3pvD4JMctO1ZqJb2K2S6uae2EGrFGoXv1HbxhnBYtHTACAx+ea+90PEoqeniK1D8sAc6vOxtBJNINbR6rKzGIWibO2oQo7lMo9h6rRGGN9khxWPf/OOfBV8+p16r90tmWnoFOg0c0DojxK/7KLI4UgtKdXi1rrBwrHorafiCNKXUf9sCzH4i3L0W3lC0fWmelgOkC6yxHPuCZG6G8GipkTQZTt+lfb94LcUFnMO49td04v9emm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introducing the userspace interface and internal logic required to
manage the lifecycle of file descriptors within a session. Previously, a
session was merely a container; this change makes it a functional
management unit.

The following capabilities are added:

A new set of ioctl commands are added, which operate on the file
descriptor returned by CREATE_SESSION. This allows userspace to:
- LIVEUPDATE_SESSION_PRESERVE_FD: Add a file descriptor to a session
  to be preserved across the live update.
- LIVEUPDATE_SESSION_UNPRESERVE_FD: Remove a previously added file
  descriptor from the session.
- LIVEUPDATE_SESSION_RESTORE_FD: Retrieve a preserved file in the
  new kernel using its unique token.

A state machine for each individual session, distinct from the global
LUO state. This enables more granular control, allowing userspace to
prepare or freeze specific sessions independently. This is managed via:
- LIVEUPDATE_SESSION_SET_EVENT: An ioctl to send PREPARE, FREEZE,
  CANCEL, or FINISH events to a single session.
- LIVEUPDATE_SESSION_GET_STATE: An ioctl to query the current state
  of a single session.

The global subsystem callbacks (luo_session_prepare, luo_session_freeze)
are updated to iterate through all existing sessions. They now trigger
the appropriate per-session state transitions for any sessions that
haven't already been transitioned individually by userspace.

The session's .release handler is enhanced to be state-aware. When a
session's file descriptor is closed, it now correctly cancels or
finishes the session based on its current state before freeing all
associated file resources, preventing resource leaks.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/uapi/linux/liveupdate.h | 164 ++++++++++++++++++
 kernel/liveupdate/luo_session.c | 284 +++++++++++++++++++++++++++++++-
 2 files changed, 446 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
index 2e38ef3094aa..59a0f561d148 100644
--- a/include/uapi/linux/liveupdate.h
+++ b/include/uapi/linux/liveupdate.h
@@ -132,6 +132,16 @@ enum {
 	LIVEUPDATE_CMD_RETRIEVE_SESSION = 0x03,
 };
 
+/* ioctl commands for session file descriptors */
+enum {
+	LIVEUPDATE_CMD_SESSION_BASE = 0x40,
+	LIVEUPDATE_CMD_SESSION_PRESERVE_FD = LIVEUPDATE_CMD_SESSION_BASE,
+	LIVEUPDATE_CMD_SESSION_UNPRESERVE_FD = 0x41,
+	LIVEUPDATE_CMD_SESSION_RESTORE_FD = 0x42,
+	LIVEUPDATE_CMD_SESSION_GET_STATE = 0x43,
+	LIVEUPDATE_CMD_SESSION_SET_EVENT = 0x44,
+};
+
 /**
  * struct liveupdate_ioctl_get_state - ioctl(LIVEUPDATE_IOCTL_GET_STATE)
  * @size:  Input; sizeof(struct liveupdate_ioctl_get_state)
@@ -293,4 +303,158 @@ struct liveupdate_ioctl_retrieve_session {
 
 #define LIVEUPDATE_IOCTL_RETRIEVE_SESSION \
 	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_RETRIEVE_SESSION)
+
+/* Session specific IOCTLs */
+
+/**
+ * struct liveupdate_session_preserve_fd - ioctl(LIVEUPDATE_SESSION_PRESERVE_FD)
+ * @size:  Input; sizeof(struct liveupdate_session_preserve_fd)
+ * @fd:    Input; The user-space file descriptor to be preserved.
+ * @token: Input; An opaque, unique token for preserved resource.
+ *
+ * Holds parameters for preserving Validate and initiate preservation for a file
+ * descriptor.
+ *
+ * User sets the @fd field identifying the file descriptor to preserve
+ * (e.g., memfd, kvm, iommufd, VFIO). The kernel validates if this FD type
+ * and its dependencies are supported for preservation. If validation passes,
+ * the kernel marks the FD internally and *initiates the process* of preparing
+ * its state for saving. The actual snapshotting of the state typically occurs
+ * during the subsequent %LIVEUPDATE_IOCTL_PREPARE execution phase, though
+ * some finalization might occur during freeze.
+ * On successful validation and initiation, the kernel uses the @token
+ * field with an opaque identifier representing the resource being preserved.
+ * This token confirms the FD is targeted for preservation and is required for
+ * the subsequent %LIVEUPDATE_SESSION_RESTORE_FD call after the live update.
+ *
+ * Return: 0 on success (validation passed, preservation initiated), negative
+ * error code on failure (e.g., unsupported FD type, dependency issue,
+ * validation failed).
+ */
+struct liveupdate_session_preserve_fd {
+	__u32		size;
+	__s32		fd;
+	__aligned_u64	token;
+};
+
+#define LIVEUPDATE_SESSION_PRESERVE_FD					\
+	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_PRESERVE_FD)
+
+/**
+ * struct liveupdate_session_unpreserve_FD - ioctl(LIVEUPDATE_SESSION_UNPRESERVE_FD)
+ * @size:     Input; sizeof(struct liveupdate_session_unpreserve_fd)
+ * @reserved: Must be zero.
+ * @token:    Input; A token for resource to be unpreserved.
+ *
+ * Remove a file descriptor from the preservation list.
+ *
+ * Allows user space to explicitly remove a file descriptor from the set of
+ * items marked as potentially preservable. User space provides a @token that
+ * was previously used by a successful %LIVEUPDATE_SESSION_PRESERVE_FD call
+ * (potentially from a prior, possibly canceled, live update attempt). The
+ * kernel reads the token value from the provided user-space address.
+ *
+ * On success, the kernel removes the corresponding entry (identified by the
+ * token value read from the user pointer) from its internal preservation list.
+ * The provided @token (representing the now-removed entry) becomes invalid
+ * after this call.
+ *
+ * Return: 0 on success, negative error code on failure (e.g., -EBUSY or -EINVAL
+ * if bad address provided, invalid token value read, token not found).
+ */
+struct liveupdate_session_unpreserve_fd {
+	__u32		size;
+	__u32		reserved;
+	__aligned_u64	token;
+};
+
+#define LIVEUPDATE_SESSION_UNPRESERVE_FD				\
+	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_UNPRESERVE_FD)
+
+/**
+ * struct liveupdate_session_restore_fd - ioctl(LIVEUPDATE_SESSION_RESTORE_FD)
+ * @size:  Input; sizeof(struct liveupdate_session_restore_fd)
+ * @fd:    Output; The new file descriptor representing the fully restored
+ *         kernel resource.
+ * @token: Input; An opaque, token that was used to preserve the resource.
+ *
+ * Restore a previously preserved file descriptor.
+ *
+ * User sets the @token field to the value obtained from a successful
+ * %LIVEUPDATE_IOCTL_FD_PRESERVE call before the live update. On success,
+ * the kernel restores the state (saved during the PREPARE/FREEZE phases)
+ * associated with the token and populates the @fd field with a new file
+ * descriptor referencing the restored resource in the current (new) kernel.
+ * This operation must be performed *before* signaling completion via
+ * %LIVEUPDATE_IOCTL_FINISH.
+ *
+ * Return: 0 on success, negative error code on failure (e.g., invalid token).
+ */
+struct liveupdate_session_restore_fd {
+	__u32		size;
+	__s32		fd;
+	__aligned_u64	token;
+};
+
+#define LIVEUPDATE_SESSION_RESTORE_FD					\
+	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_RESTORE_FD)
+
+/**
+ * struct liveupdate_session_get_state - ioctl(LIVEUPDATE_SESSION_GET_STATE)
+ * @size:     Input; sizeof(struct liveupdate_session_get_state)
+ * @incoming: Input; If 1, query the state of a restored file from the incoming
+ *            (previous kernel's) set. If 0, query a file being prepared for
+ *            preservation in the current set.
+ * @reserved: Must be zero.
+ * @state:    Output; The live update state of this FD.
+ *
+ * Query the current live update state of a specific preserved file descriptor.
+ *
+ * - %LIVEUPDATE_STATE_NORMAL:   Default state
+ * - %LIVEUPDATE_STATE_PREPARED: Prepare callback has been performed on this FD.
+ * - %LIVEUPDATE_STATE_FROZEN:   Freeze callback ahs been performed on this FD.
+ * - %LIVEUPDATE_STATE_UPDATED:  The system has successfully rebooted into the
+ *                               new kernel.
+ *
+ * See the definition of &enum liveupdate_state for more details on each state.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+struct liveupdate_session_get_state {
+	__u32		size;
+	__u8		incoming;
+	__u8		reserved[3];
+	__u32		state;
+};
+
+#define LIVEUPDATE_SESSION_GET_STATE					\
+	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_GET_STATE)
+
+/**
+ * struct liveupdate_session_set_event - ioctl(LIVEUPDATE_SESSION_SET_EVENT)
+ * @size:  Input; sizeof(struct liveupdate_session_set_event)
+ * @event: Input; The live update event.
+ *
+ * Notify a specific preserved file descriptor of an event, that causes a state
+ * transition for that file descriptor.
+ *
+ * Event, can be one of the following:
+ *
+ * - %LIVEUPDATE_PREPARE: Initiates the FD live update preparation phase.
+ * - %LIVEUPDATE_FREEZE:  Initiates the FD live update freeze phase.
+ * - %LIVEUPDATE_CANCEL:  Cancel the FD preparation or freeze phase.
+ * - %LIVEUPDATE_FINISH:  FD Restoration completion and trigger cleanup.
+ *
+ * See the definition of &enum liveupdate_event for more details on each state.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+struct liveupdate_session_set_event {
+	__u32		size;
+	__u32		event;
+};
+
+#define LIVEUPDATE_SESSION_SET_EVENT					\
+	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_SET_EVENT)
+
 #endif /* _UAPI_LIVEUPDATE_H */
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 74dee42e24b7..966b68532d79 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -188,17 +188,66 @@ static void luo_session_remove(struct luo_session *session)
 /* One session switches from the updated state to  normal state */
 static void luo_session_finish_one(struct luo_session *session)
 {
+	scoped_guard(mutex, &session->mutex) {
+		if (session->state != LIVEUPDATE_STATE_UPDATED)
+			return;
+		luo_file_finish(session);
+		session->files = 0;
+		luo_file_unpreserve_unreclaimed_files(session);
+		session->state = LIVEUPDATE_STATE_NORMAL;
+	}
 }
 
 /* Cancel one session from frozen or prepared state, back to normal */
 static void luo_session_cancel_one(struct luo_session *session)
 {
+	guard(mutex)(&session->mutex);
+	if (session->state == LIVEUPDATE_STATE_FROZEN ||
+	    session->state == LIVEUPDATE_STATE_PREPARED) {
+		luo_file_cancel(session);
+		session->state = LIVEUPDATE_STATE_NORMAL;
+		session->files = 0;
+		session->ser = NULL;
+	}
 }
 
 /* One session is changed from normal to prepare state */
 static int luo_session_prepare_one(struct luo_session *session)
 {
-	return 0;
+	int ret;
+
+	guard(mutex)(&session->mutex);
+	if (session->state != LIVEUPDATE_STATE_NORMAL)
+		return -EBUSY;
+
+	ret = luo_file_prepare(session);
+	if (!ret)
+		session->state = LIVEUPDATE_STATE_PREPARED;
+
+	return ret;
+}
+
+/* One session is changed from prepared to frozen state */
+static int luo_session_freeze_one(struct luo_session *session)
+{
+	int ret;
+
+	guard(mutex)(&session->mutex);
+	if (session->state != LIVEUPDATE_STATE_PREPARED)
+		return -EBUSY;
+
+	ret = luo_file_freeze(session);
+
+	/*
+	 * If fail, freeze is cancel, and as a side effect, we go back to normal
+	 * state
+	 */
+	if (!ret)
+		session->state = LIVEUPDATE_STATE_FROZEN;
+	else
+		session->state = LIVEUPDATE_STATE_NORMAL;
+
+	return ret;
 }
 
 static int luo_session_release(struct inode *inodep, struct file *filep)
@@ -220,6 +269,8 @@ static int luo_session_release(struct inode *inodep, struct file *filep)
 	    session->state == LIVEUPDATE_STATE_FROZEN) {
 		luo_session_cancel_one(session);
 	}
+	scoped_guard(mutex, &session->mutex)
+		luo_file_unpreserve_all_files(session);
 
 	scoped_guard(rwsem_write, &luo_session_global.rwsem)
 		luo_session_remove(session);
@@ -228,9 +279,219 @@ static int luo_session_release(struct inode *inodep, struct file *filep)
 	return 0;
 }
 
+static int luo_session_preserve_fd(struct luo_session *session,
+				   struct luo_ucmd *ucmd)
+{
+	struct liveupdate_session_preserve_fd *argp = ucmd->cmd;
+	int ret;
+
+	guard(rwsem_read)(&luo_state_rwsem);
+	if (!liveupdate_state_normal() && !liveupdate_state_updated()) {
+		pr_warn("File can be preserved only in normal or updated state\n");
+		return -EBUSY;
+	}
+
+	guard(mutex)(&session->mutex);
+
+	if (session->state != LIVEUPDATE_STATE_NORMAL)
+		return -EBUSY;
+
+	ret = luo_preserve_file(session, argp->token, argp->fd);
+	if (ret)
+		return ret;
+
+	ret = luo_ucmd_respond(ucmd, sizeof(*argp));
+	if (ret)
+		pr_warn("The file was successfully preserved, but response to user failed\n");
+
+	return ret;
+}
+
+static int luo_session_unpreserve_fd(struct luo_session *session,
+				     struct luo_ucmd *ucmd)
+{
+	struct liveupdate_session_unpreserve_fd *argp = ucmd->cmd;
+	int ret;
+
+	if (argp->reserved)
+		return -EOPNOTSUPP;
+
+	guard(rwsem_read)(&luo_state_rwsem);
+	if (!liveupdate_state_normal() && !liveupdate_state_updated()) {
+		pr_warn("File can be preserved only in normal or updated state\n");
+		return -EBUSY;
+	}
+
+	guard(mutex)(&session->mutex);
+
+	if (session->state != LIVEUPDATE_STATE_NORMAL)
+		return -EBUSY;
+
+	ret = luo_unpreserve_file(session, argp->token);
+	if (ret)
+		return ret;
+
+	ret = luo_ucmd_respond(ucmd, sizeof(*argp));
+	if (ret)
+		pr_warn("The file was successfully unpreserved, but response to user failed\n");
+
+	return ret;
+}
+
+static int luo_session_restore_fd(struct luo_session *session,
+				  struct luo_ucmd *ucmd)
+{
+	struct liveupdate_session_restore_fd *argp = ucmd->cmd;
+	struct file *file;
+	int ret;
+
+	guard(rwsem_read)(&luo_state_rwsem);
+	if (!liveupdate_state_updated())
+		return -EBUSY;
+
+	argp->fd = get_unused_fd_flags(O_CLOEXEC);
+	if (argp->fd < 0)
+		return argp->fd;
+
+	guard(mutex)(&session->mutex);
+
+	/* Session might have already finished independatly from global state */
+	if (session->state != LIVEUPDATE_STATE_UPDATED)
+		return -EBUSY;
+
+	ret = luo_retrieve_file(session, argp->token, &file);
+	if (ret < 0) {
+		put_unused_fd(argp->fd);
+
+		return ret;
+	}
+
+	ret = luo_ucmd_respond(ucmd, sizeof(*argp));
+	if (ret)
+		return ret;
+
+	fd_install(argp->fd, file);
+
+	return 0;
+}
+
+static int luo_session_get_state(struct luo_session *session,
+				 struct luo_ucmd *ucmd)
+{
+	struct liveupdate_session_get_state *argp = ucmd->cmd;
+
+	if (argp->reserved[0] | argp->reserved[1] | argp->reserved[2])
+		return -EOPNOTSUPP;
+
+	argp->state = READ_ONCE(session->state);
+
+	return luo_ucmd_respond(ucmd, sizeof(*argp));
+}
+
+static int luo_session_set_event(struct luo_session *session,
+				 struct luo_ucmd *ucmd)
+{
+	struct liveupdate_session_set_event *argp = ucmd->cmd;
+	int ret = 0;
+
+	switch (argp->event) {
+	case LIVEUPDATE_PREPARE:
+		ret = luo_session_prepare_one(session);
+		break;
+	case LIVEUPDATE_FREEZE:
+		ret = luo_session_freeze_one(session);
+		break;
+	case LIVEUPDATE_FINISH:
+		luo_session_finish_one(session);
+		break;
+	case LIVEUPDATE_CANCEL:
+		luo_session_cancel_one(session);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+union ucmd_buffer {
+	struct liveupdate_session_get_state state;
+	struct liveupdate_session_preserve_fd preserve;
+	struct liveupdate_session_restore_fd restore;
+	struct liveupdate_session_set_event event;
+	struct liveupdate_session_unpreserve_fd unpreserve;
+};
+
+struct luo_ioctl_op {
+	unsigned int size;
+	unsigned int min_size;
+	unsigned int ioctl_num;
+	int (*execute)(struct luo_session *session, struct luo_ucmd *ucmd);
+};
+
+#define IOCTL_OP(_ioctl, _fn, _struct, _last)                                  \
+	[_IOC_NR(_ioctl) - LIVEUPDATE_CMD_SESSION_BASE] = {                    \
+		.size = sizeof(_struct) +                                      \
+			BUILD_BUG_ON_ZERO(sizeof(union ucmd_buffer) <          \
+					  sizeof(_struct)),                    \
+		.min_size = offsetofend(_struct, _last),                       \
+		.ioctl_num = _ioctl,                                           \
+		.execute = _fn,                                                \
+	}
+
+static const struct luo_ioctl_op luo_session_ioctl_ops[] = {
+	IOCTL_OP(LIVEUPDATE_SESSION_GET_STATE, luo_session_get_state,
+		 struct liveupdate_session_get_state, state),
+	IOCTL_OP(LIVEUPDATE_SESSION_PRESERVE_FD, luo_session_preserve_fd,
+		 struct liveupdate_session_preserve_fd, token),
+	IOCTL_OP(LIVEUPDATE_SESSION_RESTORE_FD, luo_session_restore_fd,
+		 struct liveupdate_session_restore_fd, token),
+	IOCTL_OP(LIVEUPDATE_SESSION_SET_EVENT, luo_session_set_event,
+		 struct liveupdate_session_set_event, event),
+	IOCTL_OP(LIVEUPDATE_SESSION_UNPRESERVE_FD, luo_session_unpreserve_fd,
+		 struct liveupdate_session_unpreserve_fd, token),
+};
+
+static long luo_session_ioctl(struct file *filep, unsigned int cmd,
+			      unsigned long arg)
+{
+	struct luo_session *session = filep->private_data;
+	const struct luo_ioctl_op *op;
+	struct luo_ucmd ucmd = {};
+	union ucmd_buffer buf;
+	unsigned int nr;
+	int ret;
+
+	nr = _IOC_NR(cmd);
+	if (nr < LIVEUPDATE_CMD_SESSION_BASE || (nr - LIVEUPDATE_CMD_SESSION_BASE) >=
+	    ARRAY_SIZE(luo_session_ioctl_ops)) {
+		return -EINVAL;
+	}
+
+	ucmd.ubuffer = (void __user *)arg;
+	ret = get_user(ucmd.user_size, (u32 __user *)ucmd.ubuffer);
+	if (ret)
+		return ret;
+
+	op = &luo_session_ioctl_ops[nr - LIVEUPDATE_CMD_SESSION_BASE];
+	if (op->ioctl_num != cmd)
+		return -ENOIOCTLCMD;
+	if (ucmd.user_size < op->min_size)
+		return -EINVAL;
+
+	ucmd.cmd = &buf;
+	ret = copy_struct_from_user(ucmd.cmd, op->size, ucmd.ubuffer,
+				    ucmd.user_size);
+	if (ret)
+		return ret;
+
+	return op->execute(session, &ucmd);
+}
+
 static const struct file_operations luo_session_fops = {
 	.owner = THIS_MODULE,
 	.release = luo_session_release,
+	.unlocked_ioctl = luo_session_ioctl,
 };
 
 static void luo_session_deserialize(void)
@@ -267,6 +528,7 @@ static void luo_session_deserialize(void)
 		session->state = LIVEUPDATE_STATE_UPDATED;
 		session->count = luo_session_global.ser[i].count;
 		session->files = luo_session_global.ser[i].files;
+		luo_file_deserialize(session);
 	}
 }
 
@@ -501,7 +763,25 @@ static int luo_session_prepare(struct liveupdate_subsystem *h, u64 *data)
 
 static int luo_session_freeze(struct liveupdate_subsystem *h, u64 *data)
 {
-	return 0;
+	struct luo_session *it;
+	int ret;
+
+	WARN_ON(!luo_session_global.fdt);
+
+	scoped_guard(rwsem_read, &luo_session_global.rwsem) {
+		list_for_each_entry(it, &luo_session_global.list, list) {
+			if (it->state == LIVEUPDATE_STATE_PREPARED) {
+				ret = luo_session_freeze_one(it);
+				if (ret)
+					break;
+			}
+		}
+	}
+
+	if (ret)
+		luo_session_cancel(h, 0);
+
+	return ret;
 }
 
 /*
-- 
2.51.0.536.g15c5d4f767-goog


