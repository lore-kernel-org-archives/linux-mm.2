Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F291CFD30D
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 22:24:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CF426B002C; Sat, 22 Nov 2025 17:24:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97FB46B002D; Sat, 22 Nov 2025 17:24:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 821EC6B002E; Sat, 22 Nov 2025 17:24:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B6D26B002C
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 17:24:09 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3B554130A6B
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:24:09 +0000 (UTC)
X-FDA: 84139672218.01.D50F7DE
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf23.hostedemail.com (Postfix) with ESMTP id 65F46140002
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:24:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Tk5TO1cJ;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763850247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g/BoEmiu9zsrdP23VvEElLAx2sbpX8ex9ZCQjmSfNmg=;
	b=yvRCcIkMdvzQnlSw14+CwJkKpz+pLWQ86DhS9l2ZtdcBF5qJ8AgweMsTptiNyzekRFsKSF
	pzapeNh7ELaCVh5l3R+fNdwSx5TAdk1oC7CbF7Tfg8dF6Bqx3iQG5MiflrUnyx3lUqzsn0
	QS6Rjnu3uzey1/DQ1ULV8xHNnGtB/zE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763850247; a=rsa-sha256;
	cv=none;
	b=SMU8eeGZc7EGtBbwDb0JPJEYqrAz6B7dxX8qzE23AHR5LRwqrgq5B9sDGDp2ThpTTCWvxT
	0pA6jxP8GQoyoXbniXHkgUnvEOJvsa9eMRGrfuNcQjhOYQl0voA5lTg9OZ9mJTj8ylRnKx
	JvvDidCv3qZnCVEImRJwDzHTO5ofKPY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Tk5TO1cJ;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-641e942242cso2515503d50.1
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 14:24:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763850246; x=1764455046; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g/BoEmiu9zsrdP23VvEElLAx2sbpX8ex9ZCQjmSfNmg=;
        b=Tk5TO1cJQsBqLbzkIvR6BFa+wB3G6qyw/fB66ktL+5LVujbL77jLff51R4jHBt65mE
         eKcdL10BfEtlxgI1SNyiDuHHyAgh39RmKiG4PvYZ9mLr32DprtcaDkpfjXIhJdaXLE6r
         zuBVbQdRRHTE2EZpnDUtDfAt/ytPUS3WFfSUTf0ul6U1Ro060jsS1bS6lD/7iycEhI6B
         M7kVyg0FzMpuAoaFMd++yAUmWHfuLurFh6ecVcWWVpQZhsi0x+xpWQYRyIphqdIXUnNN
         sjfINXjd/8kl9NMs6VIsV8LxVZtWlu8o8lGa3RsNCGpo5ZAz2vk/XSrzqcRM060BpZya
         EGpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763850246; x=1764455046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=g/BoEmiu9zsrdP23VvEElLAx2sbpX8ex9ZCQjmSfNmg=;
        b=AmVbye4n1nrS82Sp6bsCdIh/2yuy743/UfQRh03F1yJk+GexsDUTb4DfFL/UDJ5WoK
         W6NmcPQ9aXdWJbx7Vt6ZVBS2OWPdjNEImJB6cGazUIeh9tP6N0HU/Erc97y+jUIaRdnh
         kEMLMXlG5S7UNLUnTK+sH9tWEE0eUX9mzlpUL1GIjMuK6qi7oqKpkc0rIi340ZgX+nA2
         QFV2KNqE8x5FLF4ZE1EX5yS2Z0KTjWehPlwE1UGNowRzxjV8YqWe/50VXCZuZc6kbyYN
         J7zfwc7CGn2wH2tfycbetBfAu2I0n3qb5fDpEWZGZXdVeXngo1dDuzWa1yKVT6n3hmrG
         o6JA==
X-Forwarded-Encrypted: i=1; AJvYcCWknDaR4Qpzwl82cxB/EDjNMVFIGMcBOBxPaPNWKjrFguWbFAYtnFCVC3heTKVr5AatjaQSFSpinQ==@kvack.org
X-Gm-Message-State: AOJu0YwzEA5jNM5vXHLrG3BpAMLfwgkRQbhLHfvzrknV/VyvtZCD6aT7
	Itzbt2P/aT3ZPIy2yVMqR81izQU/OlqAoRq1OdzpNHk3aACSVlrY6YeC+yzwcJL1MlM=
X-Gm-Gg: ASbGnctkPt67eN2tb2fBPSf2195rjqoHMdSqrV85s57nCiQcuN3Xgc+N+x/g4VC5gLY
	HDaDMAQdkzPOCurqS4azidmkXjLVD3moh3s18GHn6dQEMq1jCO4cfGrhnY140xrCOCG/onZRGbY
	dCkg/u60SMOFkYa+SRx4CkypF3/CL+1qlX8/QozsHDH1f1dGvty5IAzuVtUkvvfRj+G71ilPGYr
	Q4EwWNxU5oMuqbuxZV2m/dMB1RlsL+Aob1brOlNV6qT+LhzEDfBOX4/LPgQrxOXnewq1TKFgoUl
	7xaEkMuudo2EPy7bVFf6hQmYnV9pJOPUGynzdcUUnqnNBPNxXkrk2M4K1auOnT231ETIfVVLqA5
	CCE6oRpyMc0LYxRdMkQ5nXS+j33nmuhiqjugQilgk39FDtkVNQSlALyusbRdo74c1x2tZ3LzgCf
	bKqwi5qOM2UsggfyVpY6TQWpOjvF/3VNofCc15XgKvxbzmPGLdbyYXx5g/HqRiOo8mj/kPvAQJJ
	6oShrI=
X-Google-Smtp-Source: AGHT+IGsBnZ08fwT+U7ONzjkXoJcTJprClMLwp+I60RQ2LQQg/g7R6+ZP/xtQp7fP65yvXwFKSrR1g==
X-Received: by 2002:a05:690e:848:b0:63f:b590:2e5 with SMTP id 956f58d0204a3-64302a7cb9emr3717590d50.22.1763850246138;
        Sat, 22 Nov 2025 14:24:06 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a79779a4esm28858937b3.0.2025.11.22.14.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 14:24:05 -0800 (PST)
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
Subject: [PATCH v7 05/22] liveupdate: luo_core: add user interface
Date: Sat, 22 Nov 2025 17:23:32 -0500
Message-ID: <20251122222351.1059049-6-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
In-Reply-To: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 65F46140002
X-Stat-Signature: y3jgoar44yk8n36msny5eaa4x79xpkge
X-Rspam-User: 
X-HE-Tag: 1763850247-956317
X-HE-Meta: U2FsdGVkX18GHJp/Y1xlPc6KOOc3UWhH3g18PXeSzQFS3kejTlxLsqk72kDUMEZ8ixQgdunQkrwtQ0id4kh+5jXXFCN/JXQymPctYMPmIreSYnVt7uQCQ1MsQojBXdxLBjMrH+pnYZSk77nNvZJTtYz1IeFwSGUqcWLOeU/OgRNw6tWAISoJJcS/6eXmyjxpYaC+SfqGMzltsPS1wb3XrLEG9GbzGnOkY/C24rgBPdQssEz089g6MPNtWcpPhRhf7dbXylHg1NuUQWwXpaaprKQhn4k/fanWnP22U0KCA9hglRuY5+TP9rcDoPhhh5AGQzolTHdrpjVXjy2WH2X+LkwRFx5/UjZMQKw0A14LA7OG7kZnh73et6u8odIf9aVN+QAdBRJEIgM20tNKnRBQo8L9abFOoyM31/SpZTtnxRity3pBE4fl3XcNiuTS1D2gpB3FerJ2fO22neHF4tazF23g1SjUFks9jE9ZTlzGa9yyXb1nn/rCtxJFJaxybt3pU9ofogQZ/KDVLGFrIOa8hGAT91mTnlBZeQHJ+kBQll0hZ09E+dr2wAzKyIZ3i3jwNcFrvzd6UZgfKgQcm2lwQ/TOTNfp36IWjYd2CP2zIY15qZp/op8ZHfuJ86aP/3hj0UxaAFWXGu4k3io5fcp71mZeSugslfl6odBX2sY0Q8HAnjPazdd8J9ybaUkKjH8exsyIg9KhlTZ+P0ag3E95CZRIqWfdZ6ZHRUfxYIKlM6iBdpR5IlFzRLmASn+MFnPS4J3UjAdVcFjfSNWBcNhro4cbpDgEzp7DJYDI/u9h93chmFsjifEcKJREFy8mYPWU38ILdu0aVYou2rYbBFOZbtfoK7XSpShPVT3WGA5fmEGA598d6bYOY2beAER8eNVpPeUr9YLmkCNRnSjyzMkWly5DUWIBzuuPnAYw/bTz9Iia5Zd47ncdFpxcfK831uKVuhiiTPoktqThyNp4qLE
 6NbA56jK
 rqK4QV1lvaWmpUX2lZKCUD3Y7zwOrh8qa1EWwpG575XzwHJ3H+DhfDCUrBCq0IRq8jk5C8XX9TtkfaoqWNGEUvPTznK54NhGl8TDTnGSN2mnJ/nOfXMN7Lx2OYUkfr9E4uSWcVzc8xircROVh+yf4xz+9IAkezDjellC2ibALE1w7Pgl3P6AVGglHhv4vxUZH57DcLFHLA4IcIslnKYyk+zNOdcQYQkwIJzr95vzHq7E0fpxdntkf3V636S+cuFuDOce6ozRWdyUmuXLH0PE9B9yhyl6BLxiyZ/H9H/9gtv1UTwWe+j+6TPlUfI3EAho7upfJevQMcx7mizVO3WozZIpcKcQyCmjm5rWhdzsA8jBxqVrjQE/8ugHclw6tbS7R9FTpOC/KYxDdtyDSEhaEa/aqNqJ9NQIGOVuvA4Yb7WygH6k5/oF2NWRiuqNFFmHaFNjB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce the user-space interface for the Live Update Orchestrator
via ioctl commands, enabling external control over the live update
process and management of preserved resources.

The idea is that there is going to be a single userspace agent driving
the live update, therefore, only a single process can ever hold this
device opened at a time.

The following ioctl commands are introduced:

LIVEUPDATE_IOCTL_CREATE_SESSION
Provides a way for userspace to create a named session for grouping file
descriptors that need to be preserved. It returns a new file descriptor
representing the session.

LIVEUPDATE_IOCTL_RETRIEVE_SESSION
Allows the userspace agent in the new kernel to reclaim a preserved
session by its name, receiving a new file descriptor to manage the
restored resources.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/uapi/linux/liveupdate.h  |  64 +++++++++++
 kernel/liveupdate/luo_core.c     | 179 ++++++++++++++++++++++++++++++-
 kernel/liveupdate/luo_internal.h |  21 ++++
 3 files changed, 263 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
index 40578ae19668..1183cf984b5f 100644
--- a/include/uapi/linux/liveupdate.h
+++ b/include/uapi/linux/liveupdate.h
@@ -46,4 +46,68 @@
 /* The maximum length of session name including null termination */
 #define LIVEUPDATE_SESSION_NAME_LENGTH 64
 
+/* The /dev/liveupdate ioctl commands */
+enum {
+	LIVEUPDATE_CMD_BASE = 0x00,
+	LIVEUPDATE_CMD_CREATE_SESSION = LIVEUPDATE_CMD_BASE,
+	LIVEUPDATE_CMD_RETRIEVE_SESSION = 0x01,
+};
+
+/**
+ * struct liveupdate_ioctl_create_session - ioctl(LIVEUPDATE_IOCTL_CREATE_SESSION)
+ * @size:	Input; sizeof(struct liveupdate_ioctl_create_session)
+ * @fd:		Output; The new file descriptor for the created session.
+ * @name:	Input; A null-terminated string for the session name, max
+ *		length %LIVEUPDATE_SESSION_NAME_LENGTH including termination
+ *		character.
+ *
+ * Creates a new live update session for managing preserved resources.
+ * This ioctl can only be called on the main /dev/liveupdate device.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+struct liveupdate_ioctl_create_session {
+	__u32		size;
+	__s32		fd;
+	__u8		name[LIVEUPDATE_SESSION_NAME_LENGTH];
+};
+
+#define LIVEUPDATE_IOCTL_CREATE_SESSION					\
+	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_CREATE_SESSION)
+
+/**
+ * struct liveupdate_ioctl_retrieve_session - ioctl(LIVEUPDATE_IOCTL_RETRIEVE_SESSION)
+ * @size:    Input; sizeof(struct liveupdate_ioctl_retrieve_session)
+ * @fd:      Output; The new file descriptor for the retrieved session.
+ * @name:    Input; A null-terminated string identifying the session to retrieve.
+ *           The name must exactly match the name used when the session was
+ *           created in the previous kernel.
+ *
+ * Retrieves a handle (a new file descriptor) for a preserved session by its
+ * name. This is the primary mechanism for a userspace agent to regain control
+ * of its preserved resources after a live update.
+ *
+ * The userspace application provides the null-terminated `name` of a session
+ * it created before the live update. If a preserved session with a matching
+ * name is found, the kernel instantiates it and returns a new file descriptor
+ * in the `fd` field. This new session FD can then be used for all file-specific
+ * operations, such as restoring individual file descriptors with
+ * LIVEUPDATE_SESSION_RETRIEVE_FD.
+ *
+ * It is the responsibility of the userspace application to know the names of
+ * the sessions it needs to retrieve. If no session with the given name is
+ * found, the ioctl will fail with -ENOENT.
+ *
+ * This ioctl can only be called on the main /dev/liveupdate device when the
+ * system is in the LIVEUPDATE_STATE_UPDATED state.
+ */
+struct liveupdate_ioctl_retrieve_session {
+	__u32		size;
+	__s32		fd;
+	__u8		name[LIVEUPDATE_SESSION_NAME_LENGTH];
+};
+
+#define LIVEUPDATE_IOCTL_RETRIEVE_SESSION \
+	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_RETRIEVE_SESSION)
+
 #endif /* _UAPI_LIVEUPDATE_H */
diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index a0f7788cd003..bc90954252a3 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -41,7 +41,13 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/atomic.h>
+#include <linux/errno.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/init.h>
 #include <linux/io.h>
+#include <linux/kernel.h>
 #include <linux/kexec_handover.h>
 #include <linux/kho/abi/luo.h>
 #include <linux/kobject.h>
@@ -52,7 +58,6 @@
 #include <linux/sizes.h>
 #include <linux/string.h>
 #include <linux/unaligned.h>
-
 #include "kexec_handover_internal.h"
 #include "luo_internal.h"
 
@@ -246,12 +251,183 @@ bool liveupdate_enabled(void)
 	return luo_global.enabled;
 }
 
+/**
+ * DOC: LUO ioctl Interface
+ *
+ * The IOCTL user-space control interface for the LUO subsystem.
+ * It registers a character device, typically found at ``/dev/liveupdate``,
+ * which allows a userspace agent to manage the LUO state machine and its
+ * associated resources, such as preservable file descriptors.
+ *
+ * To ensure that the state machine is controlled by a single entity, access
+ * to this device is exclusive: only one process is permitted to have
+ * ``/dev/liveupdate`` open at any given time. Subsequent open attempts will
+ * fail with -EBUSY until the first process closes its file descriptor.
+ * This singleton model simplifies state management by preventing conflicting
+ * commands from multiple userspace agents.
+ */
+
 struct luo_device_state {
 	struct miscdevice miscdev;
+	atomic_t in_use;
+};
+
+static int luo_ioctl_create_session(struct luo_ucmd *ucmd)
+{
+	struct liveupdate_ioctl_create_session *argp = ucmd->cmd;
+	struct file *file;
+	int err;
+
+	argp->fd = get_unused_fd_flags(O_CLOEXEC);
+	if (argp->fd < 0)
+		return argp->fd;
+
+	err = luo_session_create(argp->name, &file);
+	if (err)
+		goto err_put_fd;
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
+static int luo_ioctl_retrieve_session(struct luo_ucmd *ucmd)
+{
+	struct liveupdate_ioctl_retrieve_session *argp = ucmd->cmd;
+	struct file *file;
+	int err;
+
+	argp->fd = get_unused_fd_flags(O_CLOEXEC);
+	if (argp->fd < 0)
+		return argp->fd;
+
+	err = luo_session_retrieve(argp->name, &file);
+	if (err < 0)
+		goto err_put_fd;
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
+static int luo_open(struct inode *inodep, struct file *filep)
+{
+	struct luo_device_state *ldev = container_of(filep->private_data,
+						     struct luo_device_state,
+						     miscdev);
+
+	if (atomic_cmpxchg(&ldev->in_use, 0, 1))
+		return -EBUSY;
+
+	/* Always return -EIO to user if deserialization fail */
+	if (luo_session_deserialize()) {
+		atomic_set(&ldev->in_use, 0);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int luo_release(struct inode *inodep, struct file *filep)
+{
+	struct luo_device_state *ldev = container_of(filep->private_data,
+						     struct luo_device_state,
+						     miscdev);
+	atomic_set(&ldev->in_use, 0);
+
+	return 0;
+}
+
+union ucmd_buffer {
+	struct liveupdate_ioctl_create_session create;
+	struct liveupdate_ioctl_retrieve_session retrieve;
+};
+
+struct luo_ioctl_op {
+	unsigned int size;
+	unsigned int min_size;
+	unsigned int ioctl_num;
+	int (*execute)(struct luo_ucmd *ucmd);
+};
+
+#define IOCTL_OP(_ioctl, _fn, _struct, _last)                                  \
+	[_IOC_NR(_ioctl) - LIVEUPDATE_CMD_BASE] = {                            \
+		.size = sizeof(_struct) +                                      \
+			BUILD_BUG_ON_ZERO(sizeof(union ucmd_buffer) <          \
+					  sizeof(_struct)),                    \
+		.min_size = offsetofend(_struct, _last),                       \
+		.ioctl_num = _ioctl,                                           \
+		.execute = _fn,                                                \
+	}
+
+static const struct luo_ioctl_op luo_ioctl_ops[] = {
+	IOCTL_OP(LIVEUPDATE_IOCTL_CREATE_SESSION, luo_ioctl_create_session,
+		 struct liveupdate_ioctl_create_session, name),
+	IOCTL_OP(LIVEUPDATE_IOCTL_RETRIEVE_SESSION, luo_ioctl_retrieve_session,
+		 struct liveupdate_ioctl_retrieve_session, name),
 };
 
+static long luo_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
+{
+	const struct luo_ioctl_op *op;
+	struct luo_ucmd ucmd = {};
+	union ucmd_buffer buf;
+	unsigned int nr;
+	int err;
+
+	nr = _IOC_NR(cmd);
+	if (nr < LIVEUPDATE_CMD_BASE ||
+	    (nr - LIVEUPDATE_CMD_BASE) >= ARRAY_SIZE(luo_ioctl_ops)) {
+		return -EINVAL;
+	}
+
+	ucmd.ubuffer = (void __user *)arg;
+	err = get_user(ucmd.user_size, (u32 __user *)ucmd.ubuffer);
+	if (err)
+		return err;
+
+	op = &luo_ioctl_ops[nr - LIVEUPDATE_CMD_BASE];
+	if (op->ioctl_num != cmd)
+		return -ENOIOCTLCMD;
+	if (ucmd.user_size < op->min_size)
+		return -EINVAL;
+
+	ucmd.cmd = &buf;
+	err = copy_struct_from_user(ucmd.cmd, op->size, ucmd.ubuffer,
+				    ucmd.user_size);
+	if (err)
+		return err;
+
+	return op->execute(&ucmd);
+}
+
 static const struct file_operations luo_fops = {
 	.owner		= THIS_MODULE,
+	.open		= luo_open,
+	.release	= luo_release,
+	.unlocked_ioctl	= luo_ioctl,
 };
 
 static struct luo_device_state luo_dev = {
@@ -260,6 +436,7 @@ static struct luo_device_state luo_dev = {
 		.name  = "liveupdate",
 		.fops  = &luo_fops,
 	},
+	.in_use = ATOMIC_INIT(0),
 };
 
 static int __init liveupdate_ioctl_init(void)
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 05ae91695ec6..1292ac47eef8 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -9,6 +9,27 @@
 #define _LINUX_LUO_INTERNAL_H
 
 #include <linux/liveupdate.h>
+#include <linux/uaccess.h>
+
+struct luo_ucmd {
+	void __user *ubuffer;
+	u32 user_size;
+	void *cmd;
+};
+
+static inline int luo_ucmd_respond(struct luo_ucmd *ucmd,
+				   size_t kernel_cmd_size)
+{
+	/*
+	 * Copy the minimum of what the user provided and what we actually
+	 * have.
+	 */
+	if (copy_to_user(ucmd->ubuffer, ucmd->cmd,
+			 min_t(size_t, ucmd->user_size, kernel_cmd_size))) {
+		return -EFAULT;
+	}
+	return 0;
+}
 
 /*
  * Handles a deserialization failure: devices and memory is in unpredictable
-- 
2.52.0.rc2.455.g230fcf2819-goog


