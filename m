Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D57DD0EE0D
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 16:59:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 647246B002B; Tue, 25 Nov 2025 11:59:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F6C16B002D; Tue, 25 Nov 2025 11:59:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46B4C6B002B; Tue, 25 Nov 2025 11:59:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 22C466B002B
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:59:14 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DAD191402F7
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:59:13 +0000 (UTC)
X-FDA: 84149739786.23.2C7C85A
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf15.hostedemail.com (Postfix) with ESMTP id EBDC8A0017
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:59:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OqiND2JL;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764089952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KpceFFbzwkhlrhy2Jm5dMG8T2+lFVQ4MvwlS6QKhInw=;
	b=2xYogFiBjdWSIl5sGyLIdUK42X1EX2v9ia1m4SrOi1jVyoOOL1RH3ZIhotOFGe462aRlT8
	BFJdpIjiepN1aW4YbK8UBHwnmDT5irJm8yndOiquXm/M7qsBBj88+Ex6GtItKZ0ilYEQaP
	z/eGTAEm+lPW6OP6DdvjUf8lsLgO91Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764089952; a=rsa-sha256;
	cv=none;
	b=3mrktVV9hAOw11+vMbFJPXP0uobvOo4A0E5nG6NvI1geFt0swFSjxjZKkBg+k1gTJ/ryig
	A0I4FHQ9Qr19SXN7dzUB+ySjnHqlcANIU2H+KpfDLWUUHzP0yFmigSRhmdE0ftLkGu4654
	2NT3WNf0iZKce3kTBXRAGMOYnLd8w08=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OqiND2JL;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-787e84ceaf7so58959217b3.2
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:59:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764089951; x=1764694751; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KpceFFbzwkhlrhy2Jm5dMG8T2+lFVQ4MvwlS6QKhInw=;
        b=OqiND2JLZxqDdaG2zFJyGfQbEd6giTsdg+6F4ika+sNnGLD8zp98nOYpfis/Cy19qo
         /xkc/J52EGJvaG+zEsvzsZoMP8ihxjzbBgBzxPSlxjsdn8AYZKwKk+GxcBFGft9k4aNK
         vK4aGEhfAXLdD0ef8vPOzni3/4yljtStLu0VUeZqAULtDh6tlqj9Dbu1QaV8sPVg7Ocv
         vsaPnAyO4MyZOgjQSDYOjDfMgc1EimB6EdNzpf2pAk5WnD4WNG662NHwH59Hl7054wzq
         jaAWi9iz7XhfUyvhNye0QLa8TNMWhkkBQqt5Cyq/5s2oBwr4tqD+l80nc6sT99NV9g/m
         YPoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764089951; x=1764694751;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KpceFFbzwkhlrhy2Jm5dMG8T2+lFVQ4MvwlS6QKhInw=;
        b=v24EivsrFjsDoz9cRoVN/NbxCF9sZKFbw4uDEmgtyL+cmRTS/1nDK6Y7S1L6NzZPe8
         6URc2c9qOk1hbt1bixRxEVuHS6p8Gaf7H2iF/eeSVQZ649LshdsVCke/1rx4tdfUinAT
         Rnatl4kt62d1vCDZiK/pbif8dZtuVH+w863ocPLJhuMo/atyxN5VJ5I/4g8Or/O/57Az
         ftmpT2FvM3SRxcmNkDrFLGU+aXBAJ6xrt1q77aDUsReftOqued+bTqJgg/wigSUdzZ/f
         QuEtvw/3pkJYMjd49klFK0faGRVPmqsYRP3AsSfKkXQ2reVRuN87ZXwid5fYw82tsjzs
         VH3g==
X-Forwarded-Encrypted: i=1; AJvYcCV/G2vzDBBYXSdN3R6JYGJxksXUfaUp7ailcaqZ5qhVHwmYxj+2og05vRM5XMZmk1U9ejy4EPBCYw==@kvack.org
X-Gm-Message-State: AOJu0YzoSvu91VFngweq5WkCRHQrBe9gwpB4DgvrqcDy4jBis6bCMRIG
	bZ5Xe+RUTCDqv14hlA8zOgN6KgQ/4VWaoKUy04dMM5cv3theRFaxv7Y3K/23SlP8KIQ=
X-Gm-Gg: ASbGncvsWGUOt8J48OMMDSEnPijMiRk6suEUYXtK1IOUNDV5xRqd6lcS+5j6HBAR4dU
	QErrkFvBl8349JgpEHu2J2d1GTe2qjVZDpTOAhfJpe/rVCdhnCsAnkDJCR3WX2GcG3UhMHLP7fJ
	z+6VpRlK3AsJnsncnobZ2yLyPHVuVTd3ji3b72nz80SNNlII2cmq/fAe4TMEXjLkqzvkHbapi/w
	m19KmoK9C7AxDucqAiS2YfJMkmJNxKySIpPb/TX199Q4jlTLpMDDwkcYnhhpT/fIjD4tNkr/L/t
	jM67I3WjzGvDabMPHki4DFKo/xPQ8qfdqqbiDp9fNJlRglw5wq+G1qM13CB5T5oVWQc92olk/bo
	Y/yo3HKnbQWT4nDeaa1YrDc4qYlrQqJogSgLPOCqqH8HGFfPnWKObgbNWxesPv32xIHcoqrkgEz
	1Lu00LCQx7+FwZG9Sd6lPhHBvbZd3A6H6vskOh7YJFCkqlIvIWmfS2T8Od2wi+9LRLwbc2uyt1p
	P4=
X-Google-Smtp-Source: AGHT+IFu8J5gRTX3GIgwTSli4sL6rf21GHMjG3PjVUXauq1tChQ7CPdMv6IXpi0oqNufVhgEK9FyzA==
X-Received: by 2002:a05:690c:6707:b0:789:6c45:5df with SMTP id 00721157ae682-78a8b472270mr127798697b3.23.1764089949946;
        Tue, 25 Nov 2025 08:59:09 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a798a5518sm57284357b3.14.2025.11.25.08.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 08:59:09 -0800 (PST)
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
Subject: [PATCH v8 07/18] liveupdate: luo_session: Add ioctls for file preservation
Date: Tue, 25 Nov 2025 11:58:37 -0500
Message-ID: <20251125165850.3389713-8-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.460.gd25c4c69ec-goog
In-Reply-To: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
References: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: EBDC8A0017
X-Stat-Signature: nagw73eeumubaytoemfio8obej66j1rp
X-HE-Tag: 1764089951-149350
X-HE-Meta: U2FsdGVkX1/VGyH3BwHoZM5w3a9DcAz/J5Jc+kvz7S3Y/zPQ2SXG5gUEKCIdmQdGnA3x1284GSyzbljxF9yqwJc6MMYRliPG3eEUYzG0u/7oTOfrJIRGhLgMBljdRII6QHgvwwKHusaTY5tVMFJWnsbvUuLwVe4esl/CFvdKJJG644r3NlNR0xyDbG3UpglwNxXMn7ivnhviN0e9st0ZDiJDWHyvYBqxBsWpXyjoTWgfMf+0fmLCr+fklVkMkvZ3coGgEm4SPdInxbPXjlcojkmclimu405NxfqYv+QnrgraU8hwwLwIWBLCLPT1Cb+9vNLgY6kXTrRY5ztxlnJ64Tnf852SDamW8r95Bglquo12WDOH8lDZWbbGWagt6ru2btr71L8MDCMG6B6FpH0E64cNIPDvb2OWVNdO28P/6vIxlDQqGnd0sHN5MmhR21XSxAau+mLidLjfWKJ58oTwCPuvT1lK3hkzxNmWAE2si9Ad1Ju4SZVjlUce/cY5eazWkATnuTTksAkJQoUYTPwcowhSuVtL7K/zHYwu3VAYvb5dZtGQ1dl7r9eX63UqyIdF0PyvYSNr5S4X2y8OA9vAz1tChULU4dgCwJe8JvS4t+QbbmcsgPWBcU+GeQ6B1PPTAuplSMKvMXpz81EipH6Y2UcYgeJzvqzqATHkn5S/dYphFK+ewybhWM6Hn3ZCV2EX4wmXm54cvAZT1zXpZfrhI1m6YKi/8R7egSfBe8nCgJLQXkJn8iMCf883DQ95JdlpGNs5VJCjZcdthvso+5ls/QtzASHnCMzYrNUp90CN8/q5Gl4D/2NTZP1C2u9ZnYk2dvit4TYiS6xorHZE+ExIFRFAgvUBNSFrirEi9f7qkOr4NHG77zIH3kjpZFRNuqsE1NG+qrgJ58M5lbVEjG0G9Um9oPc/2N7FzgxvqXwNj1+i1qbhdfC7ipjNbx8T9DvvWQE2b2DtIut9/Hc3itl
 c25ULQWX
 X71ExiotNl/o5iL3o94nGgxojyUiP8dPQA2nt3PNUcJfG6a6DNHgAcT93gqW5hU2hHgUHnUxm4wjWp2Xj4cnn/hd0keLcSzSnjvJhQwRF8UbRLs29mD6pMgVySRkLQrXwDiYgsosj1i/qF+p8IcKYFNNhBYWNYNv6KrFlt2pDpKaIEKte1Al/kOwklhwDeMwDsqcqqUtnOIMbEkbbUSIvHJPxsRCGmC72upbO6X2gxiewh4EOvBdvwyClqcos91cyHqJLWtBFtEDdmugNrHLdGA4Ss5g7nALRRng6NdiHu0Pncyi1DoM1ufM67syujDIrk2hA4ovoph6g3eDpQYDs48YHaBtt9OIG0z0h8dcWoYZDCBFD5ig2f2BabE3ksNgoORvrt0h4YEsm2RbI8ZQ6A1i3mzq+ojmvAG7ogQhZyflZXAWyZZbKw+vj3XLt6s+vwuMrDi17s4TYXPd5o21KFqfVLg==
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
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/uapi/linux/liveupdate.h | 103 ++++++++++++++++++
 kernel/liveupdate/luo_session.c | 187 +++++++++++++++++++++++++++++++-
 2 files changed, 288 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
index 1183cf984b5f..30bc66ee9436 100644
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
+ * @size:  Input; sizeof(struct liveupdate_session_retrieve_fd)
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
index 5829fe79896a..b08f5f329cee 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -125,6 +125,8 @@ static struct luo_session *luo_session_alloc(const char *name)
 		return ERR_PTR(-ENOMEM);
 
 	strscpy(session->name, name, sizeof(session->name));
+	INIT_LIST_HEAD(&session->file_set.files_list);
+	luo_file_set_init(&session->file_set);
 	INIT_LIST_HEAD(&session->list);
 	mutex_init(&session->mutex);
 
@@ -133,6 +135,7 @@ static struct luo_session *luo_session_alloc(const char *name)
 
 static void luo_session_free(struct luo_session *session)
 {
+	luo_file_set_destroy(&session->file_set);
 	mutex_destroy(&session->mutex);
 	kfree(session);
 }
@@ -177,16 +180,46 @@ static void luo_session_remove(struct luo_session_header *sh,
 	sh->count--;
 }
 
+static int luo_session_finish_one(struct luo_session *session)
+{
+	guard(mutex)(&session->mutex);
+	return luo_file_finish(&session->file_set);
+}
+
+static void luo_session_unfreeze_one(struct luo_session *session,
+				     struct luo_session_ser *ser)
+{
+	guard(mutex)(&session->mutex);
+	luo_file_unfreeze(&session->file_set, &ser->file_set_ser);
+}
+
+static int luo_session_freeze_one(struct luo_session *session,
+				  struct luo_session_ser *ser)
+{
+	guard(mutex)(&session->mutex);
+	return luo_file_freeze(&session->file_set, &ser->file_set_ser);
+}
+
 static int luo_session_release(struct inode *inodep, struct file *filep)
 {
 	struct luo_session *session = filep->private_data;
 	struct luo_session_header *sh;
 
 	/* If retrieved is set, it means this session is from incoming list */
-	if (session->retrieved)
+	if (session->retrieved) {
+		int err = luo_session_finish_one(session);
+
+		if (err) {
+			pr_warn("Unable to finish session [%s] on release\n",
+				session->name);
+			return err;
+		}
 		sh = &luo_session_global.incoming;
-	else
+	} else {
+		scoped_guard(mutex, &session->mutex)
+			luo_file_unpreserve_files(&session->file_set);
 		sh = &luo_session_global.outgoing;
+	}
 
 	luo_session_remove(sh, session);
 	luo_session_free(session);
@@ -194,9 +227,140 @@ static int luo_session_release(struct inode *inodep, struct file *filep)
 	return 0;
 }
 
+static int luo_session_preserve_fd(struct luo_session *session,
+				   struct luo_ucmd *ucmd)
+{
+	struct liveupdate_session_preserve_fd *argp = ucmd->cmd;
+	int err;
+
+	guard(mutex)(&session->mutex);
+	err = luo_preserve_file(&session->file_set, argp->token, argp->fd);
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
+	err = luo_retrieve_file(&session->file_set, argp->token, &file);
+	if (err < 0)
+		goto  err_put_fd;
+
+	err = luo_ucmd_respond(ucmd, sizeof(*argp));
+	if (err)
+		goto err_put_file;
+
+	fd_install(argp->fd, file);
+
+	return 0;
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
+}
+
 static const struct file_operations luo_session_fops = {
 	.owner = THIS_MODULE,
 	.release = luo_session_release,
+	.unlocked_ioctl = luo_session_ioctl,
 };
 
 /* Create a "struct file" for session */
@@ -392,6 +556,11 @@ int luo_session_deserialize(void)
 				session->name, ERR_PTR(err));
 			return err;
 		}
+
+		scoped_guard(mutex, &session->mutex) {
+			luo_file_deserialize(&session->file_set,
+					     &sh->ser[i].file_set_ser);
+		}
 	}
 
 	kho_restore_free(sh->header_ser);
@@ -406,9 +575,14 @@ int luo_session_serialize(void)
 	struct luo_session_header *sh = &luo_session_global.outgoing;
 	struct luo_session *session;
 	int i = 0;
+	int err;
 
 	guard(rwsem_write)(&sh->rwsem);
 	list_for_each_entry(session, &sh->list, list) {
+		err = luo_session_freeze_one(session, &sh->ser[i]);
+		if (err)
+			goto err_undo;
+
 		strscpy(sh->ser[i].name, session->name,
 			sizeof(sh->ser[i].name));
 		i++;
@@ -416,6 +590,15 @@ int luo_session_serialize(void)
 	sh->header_ser->count = sh->count;
 
 	return 0;
+
+err_undo:
+	list_for_each_entry_continue_reverse(session, &sh->list, list) {
+		i--;
+		luo_session_unfreeze_one(session, &sh->ser[i]);
+		memset(sh->ser[i].name, 0, sizeof(sh->ser[i].name));
+	}
+
+	return err;
 }
 
 /**
-- 
2.52.0.460.gd25c4c69ec-goog


