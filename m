Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14B27CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 21:05:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 087A18E0015; Fri,  7 Nov 2025 16:05:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0102E8E000D; Fri,  7 Nov 2025 16:05:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCCFE8E0015; Fri,  7 Nov 2025 16:05:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C6EE58E000D
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:05:52 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6E6BDBA391
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:05:52 +0000 (UTC)
X-FDA: 84085042944.01.51452BD
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id BF5B0C0003
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:05:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=b7RYHCAj;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762549550; a=rsa-sha256;
	cv=none;
	b=tC3Qv0fYPPKZOkoC5xxDHjDabYefezHzpwEL/EzRiBetbUgk6WomKzOmWE3uEBD7ClTpI3
	93DSlSCzFgcb9+Bu7Sx/6gHtdz4ue/FNKN4+H322cFU83Px52HAQIYqBhsNcHrfaTCTUBY
	l9/8dU+X9TyF8hQ8vvseQt/WGLf+Bs4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=b7RYHCAj;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762549550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0H1a2b10/az7J4jiEg4FN+EzMD5QNU4qG1nwYSONnc0=;
	b=ceEflbMLGu8QCy1bPGQd+WRE5gB5AF5JjK0qw5yOr9c2mzOYEKnW5OeQ1I6jf2tmsU7vVC
	VNd5h/VMBXhtI5GsHB37XEfa4zqhLUIvNVjr0z9nh/J49R1hPTr9waiVLuldbTOKYMo7Xs
	jMwlg6N0cVp5ZWzeReIewj/zYUtMnsE=
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-787be077127so14124257b3.2
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 13:05:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762549550; x=1763154350; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0H1a2b10/az7J4jiEg4FN+EzMD5QNU4qG1nwYSONnc0=;
        b=b7RYHCAj9QL/MljUugTrUQm4b61YVRgCDnyW9FQ8JaB0uG6KZOAA3GU7fuT1o09e9t
         BIyQdDfUryFa32vLcKxMC7jjVuNCYfPDO4pLh4RqjaXlxlgu2KsF0XcVu9FG2dpJFnHs
         r3g5tCqXVNU4H01OJcfDiZF0+qEdZA3lrW+vR+ZSUCJhgN6eUrFhsdSgBukpR4Hhvocr
         UqLT2WDQG38+FdgdQ7WGSsVb8ekOWBeXU2qHV7QiJyJHG05zuejb2E9laq4RNeAVzq8D
         6W5CRI+adlKQw51gHer2G7Yutinrzym6eQXvk3xytrqecCYyv9cD23+tTH+42KB3az3+
         17lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762549550; x=1763154350;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0H1a2b10/az7J4jiEg4FN+EzMD5QNU4qG1nwYSONnc0=;
        b=DzR7HRCrKZFw058gahLCRHqpFXQlXAwnlzkkv8ulD2YVq6PXB0O7tXj5Tg0LFX2PUp
         8wD8eiVvXfu+ihkBUtsldvM3BPV9OS/KYbgIP/R4y+Q7MxNqWSIB3TYLk7ykZlXdzaxp
         FWUZwLhWYwGnHb3F/WYq5av4kveG+4D97zjVnmh2JlAqafNETQ0j0d4vYOPVvrN7NhL5
         VUtcnaA3517wWb+K70txdikM5e/HUc/0pUKq+Nkd4xIRN4aUQrzWqZyTMNutn8lpX4B4
         jeTATYYfoWTL1mYrdHZQ0sjgDD5YqaQuNXiRhz4qng9X3+mWuMk9NiAAJlUD5eJde/Ys
         oZXw==
X-Forwarded-Encrypted: i=1; AJvYcCVRb6wKJ5vM13OXm0BbBPOKUGTFCTztFzK1idQeeRaISJa+EQomc7KJ9v2f3kccPHWCypvrXHJ7MA==@kvack.org
X-Gm-Message-State: AOJu0YzxSWteUQkp6LQsFPrBlFw2plsFyFe9QgcQgjJlxZ5lPkL7VC15
	Qq6/tDqmMM48igegtmpkOLgCt8fWazknr+rl3GOpPVQi15deMHyO3WfKT8YL4O5QGOZAWlvOeSn
	BXIaM
X-Gm-Gg: ASbGncufmupFcH7jwQRMwEFReNm9obO6AA/xKTg0dd7BPVAHQIWFQQzInpJ/XwnBNy8
	m7mBdZAv1Y78Niyx7CvYoP3IzFQgWtoE2zDrwCiyKm1jQRnbkh9RHrla/MhnzQ1o7wVXsnC3G+H
	80OJKbBKh4/0cxfewdZ8WCHhCCzYhRRoShyeID2WyKmsaZP2Mq16AglsbUGJtx3/OLbwgw7e8+g
	zM8jO8GNFSWGgCFoaRjvpIuPN+hRQy99iPYxSyQFYizAIn07XI28MpMw0En5Ara9OJLKZaBydLc
	/VWHPRm5E/aoFZVyHuMcuYeG+RoYNpj3Y5lApMpbcsOlDorV3/cDcKbcqzQUTV2aSBTx4JJCJAy
	jtBkJ63bRDek9Cy1jeXGdx7v4HSAP8fCN0BDXxNilm4K8Rmjp0A/F9dwS+89I5uO0M1MASiBS0O
	O5klG9QsK/qzfnn5DqeAeDC3y4K0CJPF0z64Qo8qJ16enXsyEBprAtFKJ3kqjVId8=
X-Google-Smtp-Source: AGHT+IFQwHqNI6dZv0OYvv/A/7mWGgOnDHLBKzgUSO31hY47HAU5moGRNVmS+T0lEJI58NPUXQlkuQ==
X-Received: by 2002:a05:690c:8d10:b0:784:8b82:98d8 with SMTP id 00721157ae682-787d5369a5emr6209347b3.16.1762549549650;
        Fri, 07 Nov 2025 13:05:49 -0800 (PST)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-787d68754d3sm990817b3.26.2025.11.07.13.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 13:05:49 -0800 (PST)
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
	chrisl@kernel.org
Subject: [PATCH v5 09/22] liveupdate: luo_session: Add ioctls for file preservation and state management
Date: Fri,  7 Nov 2025 16:03:07 -0500
Message-ID: <20251107210526.257742-10-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
In-Reply-To: <20251107210526.257742-1-pasha.tatashin@soleen.com>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BF5B0C0003
X-Stat-Signature: a1xkeg6gqe66d9ip14p87o63n8f45mhc
X-Rspam-User: 
X-HE-Tag: 1762549550-344154
X-HE-Meta: U2FsdGVkX19Nhir44rHnvae6yyD0tQyShXMltH78KeZjnm0ULkMn6LuEsQVXQtR7DcytZkyq0Y8c2oSmXR/erEmRJ2QscGKUeZBh25kRLZuY2bz0OpmfX2lN7C5Uonh+6L3mmUDXqA8+Tk3khYjqd3u6dyJxlwIoYtWih5f9AUhTVS8pd1/FXmtZ5wnJjBLcojtnKARXCBEsFuliz++hjkVKhxNX3v4RcpMafe3dQmE0Ld0J8rZDF1GarWKsqQYQWWAu5zOxVoQBPXO5ImsnGxQOPFo8Gv0SArxX++4YI1Qn+/i0BdMAz3D87PLmtK62XlwJIHcqN1zJU5DAV5sp5AfKK8TEPHJX4/82b2sCXg7Os+TLBkofA0UMD/FlqHBCk7SyKYrNIHiBuVnQpwheIkKNeNej9vSELtf2IjcyiJhfz4E6xc16199R+7fXtLJphLI6BQoJcEkFtUXBHue2Quc4teo++CmUdgtDjLBxox76a5/byzF9LSjrLFqw4Z2pokJwUFrk97zj4HDw9J3Ua87D3zDXZeCrhfSXSRWD4HQoFUAuPLqKMtEyn8nbUwjODI1SxxG0+HYtzfhgUcWFH8i3yrET/mDbaXmhmSgLuniDgUd9WVyu51ZNJrnsBAv+qALL3qmBzN4ZK3fNp06DOcOyu//P6DufVo9ng/gWMtNNASQ20+51f1gKuQ1n39kuwy98dQdIg4X50ZbOSPsRhUT32QVG6Idd+eojRkGTxcFxjCSzEGW3BzbfUHX+yLvWV30HVPZq7aBz8qy1f+SxZXWpHwqQDSgQ4B8XnZOD25TE+xXunLwgzFOJLMZp5DCwwQSrtnKmco/c1kPEXfduHUerxHU5wGgA+Yx4p4Ei7WN5vKbvJeKQDakPbcH9sgfR23exrDSKjYwFseK2pL4Xim1W411+7JX/J7iHaCSMM3bsuqVdfIRM284JajaeoIRZRN6x9QGQsLGS+IqQ490
 sqOHIfFu
 HTbRMGB7osaH2k8JOdkmkI31BaFOU7q9udqnHQglYepcthauC+G7c3wdA+DJRaWs9s1s11eoDmXMKJgJxb97fJEF2q02LRowEGc+pYkq9HyIl1ZvCl/WBGNYY0PW6tDWF2Bp4TkGpIT+XC6U=
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
 include/uapi/linux/liveupdate.h | 104 ++++++++++++++++++
 kernel/liveupdate/luo_session.c | 183 +++++++++++++++++++++++++++++++-
 2 files changed, 283 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
index 3ce60e976ecc..c55b3c7a1a39 100644
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
@@ -110,4 +118,100 @@ struct liveupdate_ioctl_retrieve_session {
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
+	__u8		reserved[2];
+};
+
+#define LIVEUPDATE_SESSION_FINISH					\
+	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_FINISH)
+
 #endif /* _UAPI_LIVEUPDATE_H */
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index a3513118aa74..ec526de83987 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -164,26 +164,185 @@ static void luo_session_remove(struct luo_session_head *sh,
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
 	struct luo_session_head *sh;
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
+	if (err < 0) {
+		put_unused_fd(argp->fd);
+
+		return err;
+	}
+
+	err = luo_ucmd_respond(ucmd, sizeof(*argp));
+	if (err)
+		return err;
+
+	fd_install(argp->fd, file);
 
 	return 0;
 }
 
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
+}
+
 static const struct file_operations luo_session_fops = {
 	.owner = THIS_MODULE,
 	.release = luo_session_release,
+	.unlocked_ioctl = luo_session_ioctl,
 };
 
 /* Create a "struct file" for session */
@@ -375,6 +534,8 @@ int luo_session_deserialize(void)
 		session->count = sh->ser[i].count;
 		session->files = __va(sh->ser[i].files);
 		session->pgcnt = sh->ser[i].pgcnt;
+		scoped_guard(mutex, &session->mutex)
+			luo_file_deserialize(session);
 	}
 
 	luo_free_restore(sh->head_ser, sh->head_ser->pgcnt << PAGE_SHIFT);
@@ -389,9 +550,14 @@ int luo_session_serialize(void)
 	struct luo_session_head *sh = &luo_session_global.outgoing;
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
@@ -402,4 +568,13 @@ int luo_session_serialize(void)
 	sh->head_ser->count = sh->count;
 
 	return 0;
+
+err_undo:
+	list_for_each_entry_continue_reverse(session, &sh->list, list) {
+		luo_session_unfreeze_one(session);
+		memset(&sh->ser[i], 0, sizeof(sh->ser[i]));
+		i--;
+	}
+
+	return err;
 }
-- 
2.51.2.1041.gc1ab5b90ca-goog


