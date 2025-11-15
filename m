Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87C57CEB2D2
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 23:34:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC8498E0018; Sat, 15 Nov 2025 18:34:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2AD28E0007; Sat, 15 Nov 2025 18:34:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA4008E0018; Sat, 15 Nov 2025 18:34:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9C1BC8E0007
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 18:34:36 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7595F14088E
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:34:36 +0000 (UTC)
X-FDA: 84114448152.12.566C800
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8A502180004
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:34:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="YlgLL7v/";
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763249674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WkjwaQDLlS9Yr5+HyVNaGiCitPd127gM/CMqs5Sb1tM=;
	b=eXcyVTrbVxGMDtH3gzylUs2WgbiXPP+QTqcrwfhHCmNT6mU8kox0vnH4n25OqSXnv6cvps
	WS3kmyD5RBhOooQcNOOpPEjZYSkPboQASDrrR9aa45NhaX09tBiqgFmVehEjYHy6kaUTpV
	aPnsR9t5GtBiuC0y+LJv0b9gC/vJGmg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="YlgLL7v/";
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763249674; a=rsa-sha256;
	cv=none;
	b=nB8+/QoCocY5zGm2dNKpVLj+kOevGbREGzB3TI1lZ0fQH82DHUlIsE+rzRKHFInrXZgCnX
	h8s4lmE4Nl9WPlTQ13Odvwen5hA08PwXRy8n+hmI5t5BU8cguHr8+gbNZGLRN7ITSctZMa
	fSb7lUtNzU1STLKxBSDpsR3mVt2C/s8=
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-780fe76f457so28580367b3.0
        for <linux-mm@kvack.org>; Sat, 15 Nov 2025 15:34:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763249673; x=1763854473; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WkjwaQDLlS9Yr5+HyVNaGiCitPd127gM/CMqs5Sb1tM=;
        b=YlgLL7v/LGS+Eyy/6b7Sx6hbmt/7LnsoOkv6z0P2PEl6moWJ9+i36RLMMcFXzvtCem
         jTJaqdr6M9n2l/kRD6bSCPs/jnsOx7CVWvbG3mQHnt26Rf46urRyPOWcF9otsb0a7n3I
         4B2d1p8Hy10cGmLz0VhGOLNlW5ZI8/973zbXzGzh50PNyxvMLjDPGUyp5vA8ZV+9iZ23
         XBgUQyiWTT37+/q0ppMQpIJ3bawXVCC8Mlh9XdP+F+5xeaHYJrDBM+T6j0wqSq74Unv5
         O8wf0ZfheK3ewjf+yDhCYKIM1pkRcAA8FsEwHBAOFoj5OZoyfBQrmH5+jgtSLuzb7xPt
         S7fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763249673; x=1763854473;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WkjwaQDLlS9Yr5+HyVNaGiCitPd127gM/CMqs5Sb1tM=;
        b=ZZBUrtv63A3D58c1sdfN4U6LPb7C2yNNtUEHaJwHy3YdjKU24jnYAGN8y2dOg6BIxf
         DpzCRnXSaJuxdCUxzL1k3g+nuv0fD7iIMl6LqsAJOO1S2K3FxPdqZXUDQ6PtWAylACnR
         Hn8NwUt4WQT1KWkz5S42z4UIZvX/+4wieHhYdtr7Shmu8W8QiHPrgTwuiqvIINjLaG9A
         cYBT8eZi50BmslfGedHndMRC3/4pVc1NuZe2/v8wzQx65rIYdncJ5KdNDoEiXSpdOCkb
         uvXDiycmFjPKIM4/CWJsdRV++zBUBl5XID6Efgh44/dbSJBjoKaOyucdR2diiL7utnHr
         m5qw==
X-Forwarded-Encrypted: i=1; AJvYcCUBZ12UFxPZP20AB8Y6KKromrxOXzqO7T7B1rRH/YW4ciM+g2TKy+qtQmhqnVsxx3+bOTiUdGVSJA==@kvack.org
X-Gm-Message-State: AOJu0YysK876u6c0UP7eIK+wiT38RwUEqLWrbeUyi0FZgoAVlPunnu0I
	HlOcpVALfWgvrpUpquHGYiDCtg7Y+qFoFjzcIqjYKetwPAXMlwUYSMtMOAIOD2hJPY4=
X-Gm-Gg: ASbGncuhBBODNZs8aKFv9cChz4kfxyM/Gqarj4z4Dg+8xmovWMSnRfhE16VT0H10Wv+
	oZQOtVqarKhocJ+uO7BEPPXxP3MRhsqCUvilz2zY2atukrDLZG4NkBJIf2pvCzRUa2WYbo44bLu
	LwTNFpNNPKLXlDGfOb70P5jHJ7hd3nkD0X5RN7/VYSthTRwGn3OXTJKz2UvbYi/itPR6DJjwAGZ
	7OVbypROnyyvLIqVuTPlTBWfsO/cnOANy9kN/OZ568DvABFtvedFJJ7aVIqnz08wuYawkVm+sPp
	QPLc4qMYzYIY7H6nYCpA921ZPKAS9Ma7s1IPRdUMD39TElJSlxY92eBWfYxelI56CYVffG+9rOT
	neC1b7Wz46cJs5hvM+UVJGSoaNqNOCH1SZKp1qs62Pjg4GWILgOAVHbO+2ek9Xs6CA3iPZ87jWZ
	BQ8oc78ArwzOs69OyQ+kbBPmbhexZJpXLbingOWNb08xmJtG3OWybYhVbOGBrQDlIcRFhz
X-Google-Smtp-Source: AGHT+IGIvzvWx+seWY3lDwubxMit7pfqszZynxJfb+7BhQKgt/q2GPlXgRc870pYq2BGK02AYhbTJA==
X-Received: by 2002:a05:690c:868a:10b0:788:161c:7117 with SMTP id 00721157ae682-78929dff2b5mr118300507b3.8.1763249673543;
        Sat, 15 Nov 2025 15:34:33 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7882218774esm28462007b3.57.2025.11.15.15.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Nov 2025 15:34:32 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
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
	chrisl@kernel.org
Subject: [PATCH v6 07/20] liveupdate: luo_session: Add ioctls for file preservation
Date: Sat, 15 Nov 2025 18:33:53 -0500
Message-ID: <20251115233409.768044-8-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251115233409.768044-1-pasha.tatashin@soleen.com>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8A502180004
X-Stat-Signature: tmpou5ga5tmdgo4ts8mzfu7h3k54ji9i
X-Rspam-User: 
X-HE-Tag: 1763249674-958165
X-HE-Meta: U2FsdGVkX1/piVdBlD7JsbjfXnBNyn6zkJjB8aAfg/AfpaGu4g6O8IgQpnP6mUDcZrl8nTMgTTHreYQbJVVClUuEwcjaQCG6TlTRldZRJjOWLTs8h7tIsWqcMAXhxZqxkUahAe3lbj2BWj1PtJsC0Vubbbq257uGGpFp/tTLaqWFJqG8vcO4dKXjhrt0I9bOCFg9Kp2gRyQsFVHv+OVRvQnW5gZm4Q9pqVAx11b6V9YxusyHY6CzBcucW+ogrO/R+1ARoxGFTUnzxMTc8ekHbxqeXecBPhRVZV2KWJaNC60/2QVBwHRMu65LYxu214ozZkWIOTC2epiOXBoq+u075XNoC5Sy26dZlIiGPoaY81OUGoP5Cv1Gcf2YEdaZJsV9bqu/7+Rh/XOQ6qtDW53m1QM04cq03vaSOBRGp57pjd2aAhumUdMALsU/b4KeUnUn8hKyJtoe8ySNo8XabBh7TMyUcODKuQ8ZpcZtpEMETEG6/IRRzDOisKHrNWMw9e9OV99SZ5FdrmRkrqJB5481GCp3X9Cxrfeyz0liL+1HHegR+nzuJEwzN+PNm9ZTLl1yTz9F4eV5vfdlwiR8XBBVHMIhQ5BDiHqpmugo2vAlqjYD9+ZJFRdCSliykfjHSIT/yctJQnkVTuqUEBajsYG1SQ8Xg7ECGDgKw1tzN1tc+cSq6cZ+wuRi5Y42UUlaKDsJBYttiCQqYeqQQ4a9u//wYhhFlLOOqva0NAAJqYV5RItuD/8GmgMtUYhglCQPWVBxujxo2rOg5F8gQkTQiiohX/GeToAJxYPTzc0Iy/yukY9oHo+93AJOU7JBg7qyN5bYPtr3xgDnsPWdeFOmpqzS6A1fPKjBXDOP0Pw9A46VBq3OYyjktvOFC8ya4flPnzH76O4g9og/ui84Y2406TOWvZhxF3PsMGvLo7QpyFxZrOdDqiHvTI6W0m3aJ+wVdbaEWnj4UoXi1+L8a7zV+08
 9i+Lb1ot
 NfJHa3VUbEFGyqmV26kC4nISl2V4aLFFrc1v42EOYo0+jNISkLCna5njmOKFyiVjNZxDmWPcF5LwN09ZpnIN7/jlDsHcXZDm8S9e+40WC/0++ZWyXfulRFsAXC1R0PmwtMdyBBO12e/EeqhvQNYQs6fH9hz6Xb8idc653aKKMTHwT+JHlPQOKP6f8GtN6Ct+Zd/bnNFOm11eB3uRJG8FYUhBSIVrXncYeCgO4RZiq/09TJ9OkGn3/82uziV4BDHDlUqFX2HETzEcWfjrqdebf2WBlazizvd4ZAkfTm1nxjkNA89BEQXau0g/ifXyOSgKsQ1Xqvzg4+76K8a1U1GWpbLO8Fxm7hwJjeUWUCxB45Jo01LVRoUjWbyoBSxgtJw82xR+TszoOyxOaS5pXz/n0Syr9aktWP0dDXxfX7fvM2DhpXwq5VCl9kDss2SyKmV0+EujT
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
- LIVEUPDATE_SESSION_RETRIEVE_FD: Retrieve a preserved file in the
  new kernel using its unique token.
- LIVEUPDATE_SESSION_FINISH: finish session

The session's .release handler is enhanced to be state-aware. When a
session's file descriptor is closed, it correctly unpreserves
the session based on its current state before freeing all
associated file resources.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/uapi/linux/liveupdate.h | 103 ++++++++++++++++++
 kernel/liveupdate/luo_session.c | 187 +++++++++++++++++++++++++++++++-
 2 files changed, 286 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
index 6e04254ee535..3902ffab4c53 100644
--- a/include/uapi/linux/liveupdate.h
+++ b/include/uapi/linux/liveupdate.h
@@ -53,6 +53,14 @@ enum {
 	LIVEUPDATE_CMD_RETRIEVE_SESSION = 0x01,
 };
 
+/* ioctl commands for session file descriptors */
+enum {
+	LIVEUPDATE_CMD_SESSION_BASE = 0x40,
+	LIVEUPDATE_CMD_SESSION_PRESERVE_FD = LIVEUPDATE_CMD_SESSION_BASE,
+	LIVEUPDATE_CMD_SESSION_RETRIEVE_FD = 0x41,
+	LIVEUPDATE_CMD_SESSION_FINISH = 0x42,
+};
+
 /**
  * struct liveupdate_ioctl_create_session - ioctl(LIVEUPDATE_IOCTL_CREATE_SESSION)
  * @size:	Input; sizeof(struct liveupdate_ioctl_create_session)
@@ -110,4 +118,99 @@ struct liveupdate_ioctl_retrieve_session {
 #define LIVEUPDATE_IOCTL_RETRIEVE_SESSION \
 	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_RETRIEVE_SESSION)
 
+/* Session specific IOCTLs */
+
+/**
+ * struct liveupdate_session_preserve_fd - ioctl(LIVEUPDATE_SESSION_PRESERVE_FD)
+ * @size:  Input; sizeof(struct liveupdate_session_preserve_fd)
+ * @fd:    Input; The user-space file descriptor to be preserved.
+ * @token: Input; An opaque, unique token for preserved resource.
+ *
+ * Holds parameters for preserving a file descriptor.
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
+ * the subsequent %LIVEUPDATE_SESSION_RETRIEVE_FD call after the live update.
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
+ * struct liveupdate_session_retrieve_fd - ioctl(LIVEUPDATE_SESSION_RETRIEVE_FD)
+ * @size:  Input; sizeof(struct liveupdate_session_RETRIEVE_fd)
+ * @fd:    Output; The new file descriptor representing the fully restored
+ *         kernel resource.
+ * @token: Input; An opaque, token that was used to preserve the resource.
+ *
+ * Retrieve a previously preserved file descriptor.
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
+struct liveupdate_session_retrieve_fd {
+	__u32		size;
+	__s32		fd;
+	__aligned_u64	token;
+};
+
+#define LIVEUPDATE_SESSION_RETRIEVE_FD					\
+	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_RETRIEVE_FD)
+
+/**
+ * struct liveupdate_session_finish - ioctl(LIVEUPDATE_SESSION_FINISH)
+ * @size:     Input; sizeof(struct liveupdate_session_finish)
+ * @reserved: Input; Must be zero. Reserved for future use.
+ *
+ * Signals the completion of the restoration process for a retrieved session.
+ * This is the final operation that should be performed on a session file
+ * descriptor after a live update.
+ *
+ * This ioctl must be called once all required file descriptors for the session
+ * have been successfully retrieved (using %LIVEUPDATE_SESSION_RETRIEVE_FD) and
+ * are fully restored from the userspace and kernel perspective.
+ *
+ * Upon success, the kernel releases its ownership of the preserved resources
+ * associated with this session. This allows internal resources to be freed,
+ * typically by decrementing reference counts on the underlying preserved
+ * objects.
+ *
+ * If this operation fails, the resources remain preserved in memory. Userspace
+ * may attempt to call finish again. The resources will otherwise be reset
+ * during the next live update cycle.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+struct liveupdate_session_finish {
+	__u32		size;
+	__u32		reserved;
+};
+
+#define LIVEUPDATE_SESSION_FINISH					\
+	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_FINISH)
+
 #endif /* _UAPI_LIVEUPDATE_H */
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index cb74bfaba479..82ba6e3578f5 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -174,26 +174,189 @@ static void luo_session_remove(struct luo_session_header *sh,
 	sh->count--;
 }
 
+static int luo_session_finish_one(struct luo_session *session)
+{
+	guard(mutex)(&session->mutex);
+	return luo_file_finish(session);
+}
+
+static void luo_session_unfreeze_one(struct luo_session *session)
+{
+	guard(mutex)(&session->mutex);
+	luo_file_unfreeze(session);
+}
+
+static int luo_session_freeze_one(struct luo_session *session)
+{
+	guard(mutex)(&session->mutex);
+	return luo_file_freeze(session);
+}
+
 static int luo_session_release(struct inode *inodep, struct file *filep)
 {
 	struct luo_session *session = filep->private_data;
 	struct luo_session_header *sh;
+	int err = 0;
 
 	/* If retrieved is set, it means this session is from incoming list */
-	if (session->retrieved)
+	if (session->retrieved) {
 		sh = &luo_session_global.incoming;
-	else
+
+		err = luo_session_finish_one(session);
+		if (err) {
+			pr_warn("Unable to finish session [%s] on release\n",
+				session->name);
+		} else {
+			luo_session_remove(sh, session);
+			luo_session_free(session);
+		}
+
+	} else {
 		sh = &luo_session_global.outgoing;
 
-	luo_session_remove(sh, session);
-	luo_session_free(session);
+		scoped_guard(mutex, &session->mutex)
+			luo_file_unpreserve_files(session);
+		luo_session_remove(sh, session);
+		luo_session_free(session);
+	}
+
+	return err;
+}
+
+static int luo_session_preserve_fd(struct luo_session *session,
+				   struct luo_ucmd *ucmd)
+{
+	struct liveupdate_session_preserve_fd *argp = ucmd->cmd;
+	int err;
+
+	guard(mutex)(&session->mutex);
+	err = luo_preserve_file(session, argp->token, argp->fd);
+	if (err)
+		return err;
+
+	err = luo_ucmd_respond(ucmd, sizeof(*argp));
+	if (err)
+		pr_warn("The file was successfully preserved, but response to user failed\n");
+
+	return err;
+}
+
+static int luo_session_retrieve_fd(struct luo_session *session,
+				   struct luo_ucmd *ucmd)
+{
+	struct liveupdate_session_retrieve_fd *argp = ucmd->cmd;
+	struct file *file;
+	int err;
+
+	argp->fd = get_unused_fd_flags(O_CLOEXEC);
+	if (argp->fd < 0)
+		return argp->fd;
+
+	guard(mutex)(&session->mutex);
+	err = luo_retrieve_file(session, argp->token, &file);
+	if (err < 0)
+		goto  err_put_fd;
+
+	err = luo_ucmd_respond(ucmd, sizeof(*argp));
+	if (err)
+		goto err_put_file;
+
+	fd_install(argp->fd, file);
 
 	return 0;
+
+err_put_file:
+	fput(file);
+err_put_fd:
+	put_unused_fd(argp->fd);
+
+	return err;
+}
+
+static int luo_session_finish(struct luo_session *session,
+			      struct luo_ucmd *ucmd)
+{
+	struct liveupdate_session_finish *argp = ucmd->cmd;
+	int err = luo_session_finish_one(session);
+
+	if (err)
+		return err;
+
+	return luo_ucmd_respond(ucmd, sizeof(*argp));
+}
+
+union ucmd_buffer {
+	struct liveupdate_session_finish finish;
+	struct liveupdate_session_preserve_fd preserve;
+	struct liveupdate_session_retrieve_fd retrieve;
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
+	IOCTL_OP(LIVEUPDATE_SESSION_FINISH, luo_session_finish,
+		 struct liveupdate_session_finish, reserved),
+	IOCTL_OP(LIVEUPDATE_SESSION_PRESERVE_FD, luo_session_preserve_fd,
+		 struct liveupdate_session_preserve_fd, token),
+	IOCTL_OP(LIVEUPDATE_SESSION_RETRIEVE_FD, luo_session_retrieve_fd,
+		 struct liveupdate_session_retrieve_fd, token),
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
 }
 
 static const struct file_operations luo_session_fops = {
 	.owner = THIS_MODULE,
 	.release = luo_session_release,
+	.unlocked_ioctl = luo_session_ioctl,
 };
 
 /* Create a "struct file" for session */
@@ -391,6 +554,8 @@ int luo_session_deserialize(void)
 		session->count = sh->ser[i].count;
 		session->files = sh->ser[i].files ? phys_to_virt(sh->ser[i].files) : 0;
 		session->pgcnt = sh->ser[i].pgcnt;
+		scoped_guard(mutex, &session->mutex)
+			luo_file_deserialize(session);
 	}
 
 	kho_restore_free(sh->header_ser);
@@ -405,9 +570,14 @@ int luo_session_serialize(void)
 	struct luo_session_header *sh = &luo_session_global.outgoing;
 	struct luo_session *session;
 	int i = 0;
+	int err;
 
 	guard(rwsem_write)(&sh->rwsem);
 	list_for_each_entry(session, &sh->list, list) {
+		err = luo_session_freeze_one(session);
+		if (err)
+			goto err_undo;
+
 		strscpy(sh->ser[i].name, session->name,
 			sizeof(sh->ser[i].name));
 		sh->ser[i].count = session->count;
@@ -418,4 +588,13 @@ int luo_session_serialize(void)
 	sh->header_ser->count = sh->count;
 
 	return 0;
+
+err_undo:
+	list_for_each_entry_continue_reverse(session, &sh->list, list) {
+		luo_session_unfreeze_one(session);
+		i--;
+		memset(&sh->ser[i], 0, sizeof(sh->ser[i]));
+	}
+
+	return err;
 }
-- 
2.52.0.rc1.455.g30608eb744-goog


