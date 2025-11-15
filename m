Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B211CEB2D2
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 23:34:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84AF98E0014; Sat, 15 Nov 2025 18:34:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FABD8E0007; Sat, 15 Nov 2025 18:34:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69B3E8E0014; Sat, 15 Nov 2025 18:34:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4CCC38E0007
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 18:34:31 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1527612EE4C
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:34:31 +0000 (UTC)
X-FDA: 84114447942.16.BA96C8F
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2D4134000B
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:34:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=GJ5QRayk;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763249669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uhpBAGvtCaN4/zg4Hr4ieTycke69MZ3f5SdTyIeLbQM=;
	b=rD1sjKsRGdNpqzi6qEs6raBclgZny3uzK0990sij5+2uvz9sw07fET9PJKluAwqdaV9li4
	qEsl8b+pAwdy3bF7l0u0Dj83hIroUv+qARByS7cI9MaL4AXv6fkm10qpnroKENFLA5ion6
	YOIfX20wjLkqEv6DEBGW9R3Lgu4fa0Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763249669; a=rsa-sha256;
	cv=none;
	b=xg02jnuBCje3jIAhwOLf7qRk2HLTfs78nWtBAOH1s3Q2mFRh5dQ5aq1loyvptUs2ltjcej
	gUztalwmMemmIPawWyvKhwr4VMFAut+igGvI+QRIKfp1N1Pwzsnh05Wvd8+mUFGg4b2Wzg
	bmHDL1aFecdyZecd4dE0v17+W+XQOzg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=GJ5QRayk;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-64107188baeso2858441d50.3
        for <linux-mm@kvack.org>; Sat, 15 Nov 2025 15:34:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763249668; x=1763854468; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uhpBAGvtCaN4/zg4Hr4ieTycke69MZ3f5SdTyIeLbQM=;
        b=GJ5QRaykO6C9krjoxm3uNs/YDck5R3P3ctIZmA1o7wRs4pU0tUeVhNsjTjGAP3RsyK
         8wIUF0YGG5ps0M/hjjqwG0AIyhTvZHSkwKGuebg3J2F05Y/wNrvj6sKcz4oNeSgeYAOw
         M4KeglWL7r+4xp6hDWyqEAtWVIeJG1MdizIY6Rj3MHi+OAwFpnxkzEa58RLM8STGIp5I
         Mv9/c47sL5kOwr+bLyRPZUGVPWsoZICT/+P8xR4lQqjqWEdJdzpd5OyVNvp0EnKRrpSO
         tXeNlfUhj0W2gkiX8Gh35w0jh8k7+g5B1IxBGaEdMvuxewmI7bP6Lj7K89rP2Bu9nvL6
         KoSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763249668; x=1763854468;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uhpBAGvtCaN4/zg4Hr4ieTycke69MZ3f5SdTyIeLbQM=;
        b=Q/UzjLYkHxL1aZ0zTJmaqyPIkmN6pfY4HroDCClNbuycrnA9fpTm9pNYll6K9tCA/5
         g2aHtPJrOvTur82osybpENCTdWY5x06F+GbStnUW1xn2wh3iHnUlegyDs3Xoa8TLUqWP
         jplG64JD6Xgwr0kwbTq0HKMsE/spY8mA2jruCHI2WGq37LuVxQKDjM+G+vQoNDz6iOCo
         jk6IZl/oDWLoju8amn7w6sea1jxOKHdk8YLh28sEmsFZOxU1bAHZPSOqrNs/n6iPeeZw
         XGkmQ/AFVyFjk+sdjLQAoggjBiVYf45zSp7zQGfdDMmzHFJFDagSNgzYql+x8ntIuItC
         sG3Q==
X-Forwarded-Encrypted: i=1; AJvYcCWMPq28QXJlohKCekjrV26a3I5tRTWKzDCCnylV4Eiut8VHB6KaX2lNKjPiZDRVS+oVeXI4PH6W5Q==@kvack.org
X-Gm-Message-State: AOJu0YyLm/xuuMGUXMVkRmmduUD3fMnLm5/OYCaIiFXqehBDnN4OMxFp
	ED8jM2F7uoxTYtOIkwvVBbErJgdy4TQBGTzxNyHMZYSMe2rZi+8A7T8K8DYWmskISLM=
X-Gm-Gg: ASbGncspV5jR3qAjqf5w+wnDNx6cHUrH1EKXGqops77PI0cwCtT8Imq6TQq3SQCeAM1
	9PBG3D9IGlC9SppIf0f4rhb6PShF/VPEA5lyz32+ryfU7ICPsyITuvCSDEiPzhuG7QDD2YQk4BF
	3Xg66Sws9tfFrYqBqVLyHpOMxowQtKCkmL3mGPG/kntVtKdglu93Kvwc3auBncd+ZvrO5rPT/Mo
	TjNPyLUmUIpjwzh+ioWR7cMkSgzVDaGwXX21W8kOtyzRY6Wn/CtXlF4/TNK5HZhP3IZ7+9Rm+Z5
	8xORNgsqd5FNqSBu4ubxdfU+vv7yZJaEo2bIMhuCv+Ch2cYJWVzVdO91zqF0aUl4w4VXoroIst/
	Eq/7Y6G5YMPSv71AjKs6BXjle2FTgDBy/f4NUbXQjDPXvSwhx09K9nogiRDb4Z2AFa9ae5U8w2J
	gNaMaB+0FjpH6pfXa3QfuMJdCTBcdoZkNuEsKcZHYw0ek6FIAOy5EXbspxhXrfmT7VnfINNy9OU
	ib2Xq8=
X-Google-Smtp-Source: AGHT+IFJMBrnhF+4OSns1bp7GpeFjnjXMcyVeEY2io2SABiWcTnwBJHtxWD+Dg9xZPdnxm6Uu5PmeA==
X-Received: by 2002:a53:b428:0:b0:63f:bc75:6ee0 with SMTP id 956f58d0204a3-641e74a3600mr4321309d50.10.1763249668108;
        Sat, 15 Nov 2025 15:34:28 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7882218774esm28462007b3.57.2025.11.15.15.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Nov 2025 15:34:26 -0800 (PST)
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
Subject: [PATCH v6 05/20] liveupdate: luo_ioctl: add user interface
Date: Sat, 15 Nov 2025 18:33:51 -0500
Message-ID: <20251115233409.768044-6-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251115233409.768044-1-pasha.tatashin@soleen.com>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qzgpbthehfkmp8x6zzbwsgmb3tkrrrg9
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D4134000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1763249669-978908
X-HE-Meta: U2FsdGVkX1/SxMhC/5VmP75SArpOxSSRcXmYTT2b9FZlcjV8dRLno7JJZ5EL1U5E5rVdJr3+9f75He4fmLROp55An11Z/jpdIV8gF0NWtTQcDTj1lB2woufzyJ0MXCkhiVk6DUc/zPAcRt4ial13IHJiQ4IR32ZbG1A6CVkR0+m4ue2EpsC2GDz3OIsJY1f/KXHnaec9es8ABLlNTDAIxWt5rmTn2On9tIupZljdoJn0caUNvCFqZ0l7mhcvG1NZ2d/0bXeINPzpkAA1YR4pUv6+yGgq/JHnmoVzdzTFquu/PbO40fpoP0jZLRfehmqiyfz2Sb7PIXbXpJhnqtlgz2hS0uKslz90alFuUhIRcY0UFFOBBk6/kgnHldo1EJR/6hnb6e038r/HnC3mIThId2bCvD8gpEws7FfPKHXsNHXfozaOrsUyhxbDiQCMsKwE1R8tmK4+RlM+/RoJ07qSdZHl7kWjYc8gOYonA7xfQ87xijvi0PnSTMtzymZOZjA8UsG413EqdKTBK0nNO/MybzxmGJlBKuOLUB6olqoO7wQStypsHJa0cRP7NnV77xuoCM4B/sE5YIvmIuyeMDfrK+YDcSaWVAoh/qjm2/lZXuWRKAuRU83W4t33l6PKxB7joviM34lcwbn3NyoJyiP0gyIqHxJQQzOFNivo+HSUcF2RS4C+NsQyHlrbdJ30rrHucxc2QaYw40W0JAy642WBV4iRO3COxHneQVXXcmxrihdcTbf8eRfU6ewxH/bVimfb9Gik495PQ1Xwr5q8xPhJA6Q3dzHayIEgL0wLR/kHokdGl/7XZl3uz0f8F8dVtF/1dY8QL6xRn+gyETV3Zjg5XbkXe73EXdnswj0V0fuZjbucEzYwPC98CksPXSgGUQ3EUkRbCede/R7e6M6JbSSi0dk502zcpfKVyYFMQ89sHjmdzBn4JrilnRPNF+x1TsYgzRYaBLZPP8W64J5n7X7
 wwlJJhF4
 pasVprcTVKGLx1JV5bijMNFNHleqV5k1E3xE5CKcnmf9k1bDj6PXaWP+YxB1r00aXOGuhwJxxrOhJXUFgUYMHfFd5LscJh32QUN9v8zIVejzSiohtxWLWtlhmKMBVkGhHRxYv7IdNHLn+sfF+TQLPhiD0uN6eT1MWkXzPQkAnm2neYxMTTfjuLvucrpfp6fyA+BSmAUS6aMZcix+fheh/Io8wd4iPheSZnEuqvTZNhcyJuUDEhmKmrI+SkFiws96IDFUa+gKZXMFM/7RlI0RJnbz4m/KXN/IJgtbwcuw8X/VHcNgFKKHPJbChH7twPkUXKPep8peTfcfZiaAvRAacp29X+WOsR54DnZqImFgBsO3bmBaHsZgPJwDJeBHKaqE2aJOjX4P2Ga3p/1CfkO4DeR4KUw1sQxrp567+riqZFN5YR7Jq49imj0TiqSCzm4HphAAv
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
 include/uapi/linux/liveupdate.h  |  66 +++++++++++-
 kernel/liveupdate/luo_internal.h |  21 ++++
 kernel/liveupdate/luo_ioctl.c    | 178 +++++++++++++++++++++++++++++++
 3 files changed, 264 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
index d2ef2f7e0dbd..6e04254ee535 100644
--- a/include/uapi/linux/liveupdate.h
+++ b/include/uapi/linux/liveupdate.h
@@ -44,6 +44,70 @@
 #define LIVEUPDATE_IOCTL_TYPE		0xBA
 
 /* The maximum length of session name including null termination */
-#define LIVEUPDATE_SESSION_NAME_LENGTH 56
+#define LIVEUPDATE_SESSION_NAME_LENGTH 64
+
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
+ *		char.
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
 
 #endif /* _UAPI_LIVEUPDATE_H */
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 245373edfa6f..5185ad37a8c1 100644
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
 
 /**
  * struct luo_session - Represents an active or incoming Live Update session.
diff --git a/kernel/liveupdate/luo_ioctl.c b/kernel/liveupdate/luo_ioctl.c
index 44d365185f7c..367385efa962 100644
--- a/kernel/liveupdate/luo_ioctl.c
+++ b/kernel/liveupdate/luo_ioctl.c
@@ -5,15 +5,192 @@
  * Pasha Tatashin <pasha.tatashin@soleen.com>
  */
 
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
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/atomic.h>
+#include <linux/errno.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
 #include <linux/liveupdate.h>
 #include <linux/miscdevice.h>
+#include <uapi/linux/liveupdate.h>
+#include "luo_internal.h"
 
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
+	luo_session_deserialize();
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
@@ -22,6 +199,7 @@ static struct luo_device_state luo_dev = {
 		.name  = "liveupdate",
 		.fops  = &luo_fops,
 	},
+	.in_use = ATOMIC_INIT(0),
 };
 
 static int __init liveupdate_ioctl_init(void)
-- 
2.52.0.rc1.455.g30608eb744-goog


