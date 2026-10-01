Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 628F0CA5FD2
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 00:57:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF4F06B008A; Wed, 30 Sep 2026 20:57:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECE136B0092; Wed, 30 Sep 2026 20:57:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE1B56B0093; Wed, 30 Sep 2026 20:57:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AACC96B008A
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 20:57:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8B5691A0278
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 00:57:44 +0000 (UTC)
X-FDA: 85272244848.04.F678CD0
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf19.hostedemail.com (Postfix) with ESMTP id CE11F1A0003
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 00:57:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rU+Z0fnk;
	spf=pass (imf19.hostedemail.com: domain of 3BbC9aggKCLgqifYuYhYemmejc.amkjglsv-kkitYai.mpe@flex--skhawaja.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3BbC9aggKCLgqifYuYhYemmejc.amkjglsv-kkitYai.mpe@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790816262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qLwvrgkVHwD9cSzdNNIyYeC13QNhFX+M1wDcpZNZ38A=;
	b=GfLfwkFNKXjfOS9Np9Pmyk1pZwi6xNLJGYYPrKe6aufHmky5aQbKciHCSqXrJaVwbwdTKU
	phKddEXNJKhf7BektCrkmePraZ2Lqughe+5f2YwQ4YyC9yoV73ELRwGia2bljP81+Te4H4
	waWkAbm4SrO6hhv5XKxaFSJVWmrRMkM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790816262;
	b=DzvlYbLJPyz4Zdlc+QUfPjnL+Gav4dGIwOT14SepmflhPlOlXnwxc48Bs2p1dxJWiB3AIi
	bMvgNZph6FkxByXSEmnOrm1sjzAT8VVX6+8o3dHhRvOvvlm1VaV6oJeKYwH/IErU5/B6cp
	Ir3klMNukT1dy1iiCQ/igsczfgoTPik=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rU+Z0fnk;
	spf=pass (imf19.hostedemail.com: domain of 3BbC9aggKCLgqifYuYhYemmejc.amkjglsv-kkitYai.mpe@flex--skhawaja.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3BbC9aggKCLgqifYuYhYemmejc.amkjglsv-kkitYai.mpe@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2e2d83bb68cso13971575ad.0
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 17:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790816262; x=1791421062; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qLwvrgkVHwD9cSzdNNIyYeC13QNhFX+M1wDcpZNZ38A=;
        b=rU+Z0fnknztzdaZWiwk1yNz8tNyhjRtQnt3S/CIq/M3NCIDyQmKW9H1lOxci1d4RJ3
         FCvRgs4l0b62z1TRQbkdlOI7F/RzDtzxDC6xtkeKyjQh0F0B0bQIRhlV2Sd+WH5Tz+Zz
         Fwx34IKGmdyQjleMod72lPBEUB1QpOTup287iMmDQ0d7gXZZuscU16eF+21bbKzJHSua
         87qCUBTxf9goFR+s8eAFb5x5FvfiFj2tHMmD3Or/4sVIN/n4I3wdl69R7j1Ll0k1WBRm
         Mmcsc6Pckjev6I4GDUwFSN3RcnmZfD3+ftQgwU3bi3KFYFXs7ozNMARncXULIY/3Uf/8
         MrBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790816262; x=1791421062;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qLwvrgkVHwD9cSzdNNIyYeC13QNhFX+M1wDcpZNZ38A=;
        b=c4JchpMDJnj2PsBsqU/Nbs4gkLxTSdAnyGAOmENKWKxycrMVojuXKdUeTV66LtFKA7
         AjqopXqBwkyesCWPwN21r9pUPv8gVi6y4VjESsb+dd7xsor14E3HO8dRtc9cX9reKJRL
         qK0WVfoyHv4thIMShQ9tKVB5XdB8t8nANsjZbG4dghUO4Ue49cMsy7XCSynfwvzO/rYt
         Q2P0bDCHDMXGWFiZwLaq8Af1UrYCCldt8GGz2LgLVJzRdwjbgp7jGQbj4Ww9cwLc/rrG
         1NYyP2hHEhjOjOcqt6z7QOV+DdmoHNX5Nxlmw0ghtuPcWnVi6WJYZVCKeMqTxBmj0Y1W
         7MEA==
X-Forwarded-Encrypted: i=1; AKwUvBw2wODhxMf+CKN9OEtu1jfJP/il6st2chHpZCJ6bJ0ECsnaMUhFl7gUkA/jfd2tl7bHflhHXCtusQ==@kvack.org
X-Gm-Message-State: AFq9FYIcD0c2NPGLR9WF4hZRPalPuqNouhlN6XD3CLKfaC4jeTSCVafF
	+ilCJlb04nTpqnmG0swpBfAUyDTMxie2FJD/sA0fOAuPBAcH9RWdVqWStoZdvOmTngqHAugjVGG
	QBW0niG+uCBEALg==
X-Received: from pleq1.prod.google.com ([2002:a17:902:f341:b0:2df:aef3:9a37])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e542:b0:2d0:cc92:f7a3 with SMTP id d9443c01a7336-2e2e48b321fmr26966585ad.2.1790816261304;
 Wed, 30 Sep 2026 17:57:41 -0700 (PDT)
Date: Thu,  1 Oct 2026 00:57:29 +0000
In-Reply-To: <20261001005734.1033516-1-skhawaja@google.com>
Mime-Version: 1.0
References: <20261001005734.1033516-1-skhawaja@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001005734.1033516-2-skhawaja@google.com>
Subject: [RFC PATCH 1/6] liveupdate: Introduce file handler dependency level
From: Samiullah Khawaja <skhawaja@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, David Matlack <dmatlack@google.com>, tarunsahu@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, 
	"open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: r18qy68nohs5x4uiseat15rfz4t1drux
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CE11F1A0003
X-HE-Tag: 1790816262-131538
X-HE-Meta: U2FsdGVkX18ddV44BpK2CzC1MQcLLyYOmUxWG3j9io8gy1sklR8P5enxcB4xMQCtFxNvG9m3Z/hA4XIBQd5Kf+69sIRxWs1R2NRGnioCEFsh+1qrqcsLm7pHOHXonEelxErBe3DAPMcT5xIxDXlGFqPYo8RmJuHnobi2p02w/FNJzqke+9Q+jgUR9LnP+orWO4DU1q/8wrrZiYr0y/vx9wLrrGAIRM3+TJWtH/y8VQL+NX3FJGl8TzuvuJgnJvRXpun2o9V0uE707IWgn3V4WpL+UO+2xQ9a3z8b4QLTiXb8/4K3c+2LNZ4ogtqfVqPWbRUOm3Tn1ngNphxRKb6iG6sfWNvWjyB18nJjfiaK6gOmHj5mNnVmmI4XdaG0Z6rr5f7dAQ8gzYGAdZiweBeagxFZpuCMn7k/h+7i8lTpu0a3b6zrLtG22s/Gqm5S1bg0IWKFDNc3CBLs+oqo/rAaQEZDfbH5MrfS8Lh/decLIXUspycyvKocwlNeRmIZsWcgcuaVPChwbj1YCPcxuOxx1o6TLGsIAz6zCvZLMbYpUhi8bdSZsDUcMKKjkExBvnO/5Txl5xR/B0JnyJ1zuDQH6G6z51OEdtUsXlBDKI546GPFP1sTKyn5teAKC5IvxVdD+dwdgFZUtcmgWS+SDYYzESM6yQK7BsQcO5BsoRVvQXmiThdpCG8ohHQ0lnyeui9aCCb0dzbEnAeocE69PwBy29ERDpNzpBiaafUfvoFW1/fTj312i7o4Cq8gakKS1ZnSeTcHs5ABMB19AoxoqyN4myYpaMm9IDuh0iALheHYYNYQu/IMAVWJLgy2hgtoBDzn2GSQVnqhooL1od3CBjpcUqS26dUPFo83wRwmgjk8rm9YMFm0op60ETJsnrflyPQnwiXrSzcUHT3E6ISLOrj+yzwc1yfl9eAQpSZqOp+Hk7x/cGrfP2FdWiClyb6/b2Wh6pp+n3pJM8kj/86+vwe
 QimDZuRd
 RaegWeTIyx1yjaHR+TKLEiaYv5tup5A3Z/12dr/mcC/9Qi7G39Zi7sZQoGDRtA0vV+nROaBQ3nO7cOB4DAQ/xO81+W6S6wzopZwB2SG6i7Yzr0zq5cZdKb31RQXA0bXiojJX4dIPijyBueFx+sg8UsWjelXQQaBS3bW+AfqgwwNlKj/xwXsa5+Cx/Co5bXfOf/pRdylhPniSpQgZ/H0NsLxKIt0wdlsVtN+/oavxvto+XNKXUv64OwnDF1zSvcy4Jvu6BEBRFzhzolwjCNy+phbx51Va779xzV3HrPaG1yMSsgXIh9pqnFmHfRh3mI8tLkXyklDfFNzP04rZGDOxg+rUNWxYFqIQXIgScXwH56aSm+WSHe8pzhWRiJqanOePQs+dW0p9LdCvDVM33J9hP4pA2wCr0usFexNSqbyQWJLNQQ4+FqXWzpnU0yiCiQ/rTQfuaizVsv6G8Sq7H2Z7DUpE9LWThetGcIVuDF699YlTgWm1XwlfoymmhJ+1Wf3hoYZBPMmHSMXxdDUKt3e/uNUTI7mdwMos/At1eVDo0TOL59XXMQ16RFFFmT9j9xVdtcTyIY4jBbeaB8wuxAENWH6UbZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dependency level is an optional level in the file handler that can be
used to indicate the order in which FDs are preserved. The level define
the type of state an FD preserved and how it relates to other type of
FDs. For example a memory provider FD might be a dependency of an FD
that uses that memory.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 include/linux/liveupdate.h       |  24 +++
 include/uapi/linux/liveupdate.h  |  39 ++++
 kernel/liveupdate/luo_file.c     | 316 +++++++++++++++++++++----------
 kernel/liveupdate/luo_internal.h |   2 +
 kernel/liveupdate/luo_session.c  |  45 +++++
 5 files changed, 330 insertions(+), 96 deletions(-)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index 6051abc0612c..ba0af91126e1 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -87,6 +87,27 @@ struct liveupdate_file_ops {
 	struct module *owner;
 };
 
+/**
+ * enum liveupdate_level - Preservation order of a file handler.
+ * @LIVEUPDATE_LEVEL_NONE:   Level not set. The handler does not depend on
+ *                           any other preserved file. Preserved first.
+ * @LIVEUPDATE_LEVEL_MEM:    Files that provide memory.
+ * @LIVEUPDATE_LEVEL_MAPPER: Files that map memory provided by a lower level.
+ * @LIVEUPDATE_LEVEL_DEVICE: Files that represent devices.
+ *
+ * When a batch of files is preserved with LIVEUPDATE_SESSION_PRESERVE_FDS,
+ * LUO calls the handlers' .preserve() in ascending level order.
+ *
+ * The values are spaced so that new levels can be inserted without
+ * renumbering. The level is kernel internal and not part of any ABI.
+ */
+enum liveupdate_level {
+	LIVEUPDATE_LEVEL_NONE	= 0x0,
+	LIVEUPDATE_LEVEL_MEM	= 0x10,
+	LIVEUPDATE_LEVEL_MAPPER	= 0x20,
+	LIVEUPDATE_LEVEL_DEVICE	= 0x30,
+};
+
 /**
  * struct liveupdate_file_handler - Represents a handler for a live-updatable file type.
  * @ops:                Callback functions
@@ -94,6 +115,8 @@ struct liveupdate_file_ops {
  *                      that uniquely identifies the file type this handler
  *                      supports. This is matched against the compatible string
  *                      associated with individual &struct file instances.
+ * @level:              Optional. Preservation order of this handler. See &enum
+ *                      liveupdate_level.
  *
  * Modules that want to support live update for specific file types should
  * register an instance of this structure. LUO uses this registration to
@@ -103,6 +126,7 @@ struct liveupdate_file_ops {
 struct liveupdate_file_handler {
 	const struct liveupdate_file_ops *ops;
 	const char compatible[LIVEUPDATE_HNDL_COMPAT_LENGTH];
+	enum liveupdate_level level;
 
 	/* private: */
 
diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
index 4043d4038712..122275ab7ca2 100644
--- a/include/uapi/linux/liveupdate.h
+++ b/include/uapi/linux/liveupdate.h
@@ -60,6 +60,7 @@ enum {
 	LIVEUPDATE_CMD_SESSION_RETRIEVE_FD = 0x41,
 	LIVEUPDATE_CMD_SESSION_FINISH = 0x42,
 	LIVEUPDATE_CMD_SESSION_GET_NAME = 0x43,
+	LIVEUPDATE_CMD_SESSION_PRESERVE_FDS = 0x44,
 };
 
 /**
@@ -236,4 +237,42 @@ struct liveupdate_session_get_name {
 #define LIVEUPDATE_SESSION_GET_NAME					\
 	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_GET_NAME)
 
+/**
+ * struct liveupdate_session_preserve_fds - ioctl(LIVEUPDATE_SESSION_PRESERVE_FDS)
+ * @size:             Input; sizeof(struct liveupdate_session_preserve_fds)
+ * @nr:               Input; Number of entries in @fds and @tokens. Must not be
+ *                    zero.
+ * @fds:              Input; User pointer to an array of @nr __s32 file
+ *                    descriptors to be preserved.
+ * @tokens:           Input; User pointer to an array of @nr __u64 opaque,
+ *                    unique tokens, one for each entry in @fds.
+ * @out_failed_index: Output; On failure, the index of the entry in @fds that
+ *                    caused the failure, or @nr if the failure is not
+ *                    specific to an entry.
+ * @__reserved:       Input; Must be zero.
+ *
+ * Preserve a batch of file descriptors, some of which may depend on others in
+ * the same batch. The entries may be given in any order; the kernel preserves
+ * them in dependency order.
+ *
+ * All dependencies of a file must either be part of the same batch or have
+ * been preserved earlier in this session.
+ *
+ * The operation is atomic: either all file descriptors in the batch are
+ * preserved, or none are and the session is unchanged.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+struct liveupdate_session_preserve_fds {
+	__u32		size;
+	__u32		nr;
+	__aligned_u64	fds;
+	__aligned_u64	tokens;
+	__u32		out_failed_index;
+	__u32		__reserved;
+};
+
+#define LIVEUPDATE_SESSION_PRESERVE_FDS					\
+	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_PRESERVE_FDS)
+
 #endif /* _UAPI_LIVEUPDATE_H */
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 9c10cf3748a4..d83dc7966a81 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -43,10 +43,13 @@
  *
  * File Preservation Lifecycle happy path:
  *
- * 1. Preserve (Normal Operation): A userspace agent preserves files one by one
- *    via an ioctl. For each file, luo_preserve_file() finds a compatible
- *    handler, calls its .preserve() operation, and creates an internal &struct
- *    luo_file to track the live state.
+ * 1. Preserve (Normal Operation): A userspace agent preserves files via an
+ *    ioctl, either one by one or in batches. For each batch,
+ *    luo_preserve_files() finds a compatible handler for every file, then
+ *    calls the handlers' .preserve() operations in ascending handler level
+ *    order (see &enum liveupdate_level) so that dependencies are preserved
+ *    before their users, and creates an internal &struct luo_file to track
+ *    the live state of each file.
  *
  * 2. Freeze (Pre-Reboot): Just before the kexec, luo_file_freeze() is called.
  *    It iterates through all preserved files, calls their respective .freeze()
@@ -105,6 +108,7 @@
 #include <linux/kexec_handover.h>
 #include <linux/kho/abi/luo.h>
 #include <linux/list_private.h>
+#include <linux/list_sort.h>
 #include <linux/liveupdate.h>
 #include <linux/module.h>
 #include <linux/sizes.h>
@@ -175,7 +179,8 @@ static unsigned long luo_get_id(struct liveupdate_file_handler *fh,
 	return fh->ops->get_id ? fh->ops->get_id(file) : (unsigned long)file;
 }
 
-static bool luo_token_is_used(struct luo_file_set *file_set, u64 token)
+static bool luo_token_is_used(struct luo_file_set *file_set,
+			      struct list_head *pending, u64 token)
 {
 	struct luo_file *iter;
 
@@ -184,69 +189,36 @@ static bool luo_token_is_used(struct luo_file_set *file_set, u64 token)
 			return true;
 	}
 
+	list_for_each_entry(iter, pending, list) {
+		if (iter->token == token)
+			return true;
+	}
+
 	return false;
 }
 
-/**
- * luo_preserve_file - Initiate the preservation of a file descriptor.
- * @file_set: The file_set to which the preserved file will be added.
- * @token:    A unique, user-provided identifier for the file.
- * @fd:       The file descriptor to be preserved.
- *
- * This function orchestrates the first phase of preserving a file. Upon entry,
- * it takes a reference to the 'struct file' via fget(), effectively making LUO
- * a co-owner of the file. This reference is held until the file is either
- * unpreserved or successfully finished in the next kernel, preventing the file
- * from being prematurely destroyed.
- *
- * This function orchestrates the first phase of preserving a file. It performs
- * the following steps:
- *
- * 1. Validates that the @token is not already in use within the file_set.
- * 2. Ensures the file_set's memory for files serialization is allocated
- *    (allocates if needed).
- * 3. Iterates through registered handlers, calling can_preserve() to find one
- *    compatible with the given @fd.
- * 4. Calls the handler's .preserve() operation, which saves the file's state
- *    and returns an opaque private data handle.
- * 5. Adds the new instance to the file_set's internal list.
- *
- * On success, LUO takes a reference to the 'struct file' and considers it
- * under its management until it is unpreserved or finished.
+/*
+ * luo_file_alloc - Allocate a luo_file for one file of a batch.
  *
- * In case of any failure, all intermediate allocations (file reference, memory
- * for the 'luo_file' struct, etc.) are cleaned up before returning an error.
+ * Checks the token, takes a reference on the file, finds the handler and claims
+ * the file globally.
  *
- * Context: Can be called from an ioctl handler during normal system operation.
- * Return: 0 on success. Returns a negative errno on failure:
- *         -EEXIST if the token is already used.
- *         -EBUSY if the file descriptor is already preserved by another session.
- *         -EBADF if the file descriptor is invalid.
- *         -ENOSPC if the file_set is full.
- *         -ENOENT if no compatible handler is found.
- *         -ENOMEM on memory allocation failure.
- *         Other erros might be returned by .preserve().
+ * On success the new luo_file is added to @pending.
  */
-int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
+static int luo_file_alloc(struct luo_file_set *file_set,
+			  struct list_head *pending, u64 token, int fd)
 {
-	struct liveupdate_file_op_args args = {0};
 	struct liveupdate_file_handler *fh;
 	struct luo_file *luo_file;
 	struct file *file;
 	int err;
 
-	if (luo_token_is_used(file_set, token))
+	if (luo_token_is_used(file_set, pending, token))
 		return -EEXIST;
 
-	err = kho_block_set_grow(&file_set->block_set, file_set->count + 1);
-	if (err)
-		return err;
-
 	file = fget(fd);
-	if (!file) {
-		err = -EBADF;
-		goto err_shrink;
-	}
+	if (!file)
+		return -EBADF;
 
 	err = -ENOENT;
 	down_read(&luo_register_rwlock);
@@ -282,23 +254,10 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	luo_file->fh = fh;
 	luo_file->token = token;
 	mutex_init(&luo_file->mutex);
-
-	args.handler = fh;
-	args.session = luo_session_from_file_set(file_set);
-	args.file = file;
-	err = fh->ops->preserve(&args);
-	if (err)
-		goto err_kfree;
-
-	luo_file->serialized_data = args.serialized_data;
-	luo_file->private_data = args.private_data;
-	list_add_tail(&luo_file->list, &file_set->files_list);
-	file_set->count++;
+	list_add_tail(&luo_file->list, pending);
 
 	return 0;
 
-err_kfree:
-	kfree(luo_file);
 err_flb_unpreserve:
 	luo_flb_file_unpreserve(fh);
 err_erase_xa:
@@ -307,12 +266,199 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	module_put(fh->ops->owner);
 err_fput:
 	fput(file);
-err_shrink:
+
+	return err;
+}
+
+static void luo_file_free(struct luo_file *luo_file)
+{
+	struct liveupdate_file_handler *fh = luo_file->fh;
+
+	list_del(&luo_file->list);
+	luo_flb_file_unpreserve(fh);
+	xa_erase(&luo_preserved_files, luo_get_id(fh, luo_file->file));
+	module_put(fh->ops->owner);
+	fput(luo_file->file);
+	mutex_destroy(&luo_file->mutex);
+	kfree(luo_file);
+}
+
+/*
+ * luo_file_preserve_internal - Preserve one file of a batch.
+ *
+ * Calls the handler's .preserve() and, on success, moves the file from the
+ * batch's pending list to the tail of @file_set->files_list, after which it
+ * is visible to liveupdate_get_token_outgoing().
+ */
+static int luo_file_preserve_internal(struct luo_file_set *file_set,
+				      struct luo_file *luo_file)
+{
+	struct liveupdate_file_op_args args = {0};
+	int err;
+
+	args.handler = luo_file->fh;
+	args.session = luo_session_from_file_set(file_set);
+	args.file = luo_file->file;
+	err = luo_file->fh->ops->preserve(&args);
+	if (err)
+		return err;
+
+	luo_file->serialized_data = args.serialized_data;
+	luo_file->private_data = args.private_data;
+	list_move_tail(&luo_file->list, &file_set->files_list);
+	file_set->count++;
+
+	return 0;
+}
+
+static void luo_file_unpreserve_one(struct luo_file_set *file_set,
+				    struct luo_file *luo_file)
+{
+	struct liveupdate_file_op_args args = {0};
+
+	args.handler = luo_file->fh;
+	args.session = luo_session_from_file_set(file_set);
+	args.file = luo_file->file;
+	args.serialized_data = luo_file->serialized_data;
+	args.private_data = luo_file->private_data;
+	luo_file->fh->ops->unpreserve(&args);
+	luo_flb_file_unpreserve(luo_file->fh);
+
+	xa_erase(&luo_preserved_files,
+		 luo_get_id(luo_file->fh, luo_file->file));
+	module_put(luo_file->fh->ops->owner);
+
+	list_del(&luo_file->list);
+	file_set->count--;
+	kho_block_set_shrink(&file_set->block_set, file_set->count);
+
+	fput(luo_file->file);
+	mutex_destroy(&luo_file->mutex);
+	kfree(luo_file);
+}
+
+static int luo_file_level_cmp(void *priv, const struct list_head *a,
+			      const struct list_head *b)
+{
+	const struct luo_file *fa = list_entry(a, struct luo_file, list);
+	const struct luo_file *fb = list_entry(b, struct luo_file, list);
+
+	return fa->fh->level > fb->fh->level;
+}
+
+/**
+ * luo_preserve_files - Preserve a batch of file descriptors.
+ * @file_set:   The file_set to which the preserved files will be added.
+ * @tokens:     Array of @nr unique, user-provided identifiers.
+ * @fds:        Array of @nr file descriptors to be preserved.
+ * @nr:         Number of entries in @tokens and @fds.
+ * @failed_idx: Output; on failure, the index into @tokens/@fds of the entry
+ *              that failed, or @nr if the failure is not specific to an entry.
+ *
+ * The file handler's .preserve() is called in the level ascending order, so a
+ * dependency in the same batch is preserved before the file that needs it,
+ * regardless of the order userspace passed the fds in.
+ *
+ * The operation is atomic: on any failure, the files of this batch that were
+ * already preserved are unpreserved in reverse order, and the file_set is left
+ * as it was before the call.
+ *
+ * On success, LUO takes a reference to each 'struct file' and considers it
+ * under its management until it is unpreserved or finished.
+ *
+ * Context: Called from an ioctl handler with the session mutex held.
+ * Return: 0 on success. Returns a negative errno on failure:
+ *         -EEXIST if a token is already used.
+ *         -EBUSY if a file descriptor is already preserved (in this batch or
+ *                by another session).
+ *         -EBADF if a file descriptor is invalid.
+ *         -ENOSPC if the file_set is full.
+ *         -ENOENT if no compatible handler is found, or a dependency of a
+ *                 file is not preserved.
+ *         -ENOMEM on memory allocation failure.
+ *         Other errors might be returned by .preserve().
+ */
+int luo_preserve_files(struct luo_file_set *file_set, const u64 *tokens,
+		       const int *fds, u32 nr, u32 *failed_idx)
+{
+	struct luo_file *luo_file, *tmp;
+	struct list_head *mark;
+	LIST_HEAD(pending);
+	u32 i;
+	int err;
+
+	*failed_idx = nr;
+
+	err = kho_block_set_grow(&file_set->block_set, file_set->count + nr);
+	if (err)
+		return err;
+
+	for (i = 0; i < nr; i++) {
+		err = luo_file_alloc(file_set, &pending, tokens[i], fds[i]);
+		if (err) {
+			*failed_idx = i;
+			goto err_abort;
+		}
+	}
+
+	list_sort(NULL, &pending, luo_file_level_cmp);
+
+	/* Everything after @mark on files_list belongs to this batch */
+	mark = file_set->files_list.prev;
+	while (!list_empty(&pending)) {
+		luo_file = list_first_entry(&pending, struct luo_file, list);
+		err = luo_file_preserve_internal(file_set, luo_file);
+		if (err) {
+			for (i = 0; i < nr; i++) {
+				if (tokens[i] == luo_file->token) {
+					*failed_idx = i;
+					break;
+				}
+			}
+			goto err_unpreserve;
+		}
+	}
+
+	return 0;
+
+err_unpreserve:
+	/*
+	 * files_list is in dependency order, so nothing before @mark can
+	 * depend on anything after it. Unpreserving the tail in reverse order
+	 * is the same as session teardown, stopped at @mark.
+	 */
+	while (file_set->files_list.prev != mark) {
+		luo_file = list_last_entry(&file_set->files_list,
+					   struct luo_file, list);
+		luo_file_unpreserve_one(file_set, luo_file);
+	}
+err_abort:
+	list_for_each_entry_safe(luo_file, tmp, &pending, list)
+		luo_file_free(luo_file);
 	kho_block_set_shrink(&file_set->block_set, file_set->count);
 
 	return err;
 }
 
+/**
+ * luo_preserve_file - Preserve a single file descriptor.
+ * @file_set: The file_set to which the preserved file will be added.
+ * @token:    A unique, user-provided identifier for the file.
+ * @fd:       The file descriptor to be preserved.
+ *
+ * Equivalent to luo_preserve_files() with a batch of one. Any dependency of
+ * @fd must have been preserved by an earlier call.
+ *
+ * Context: Called from an ioctl handler with the session mutex held.
+ * Return: See luo_preserve_files().
+ */
+int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
+{
+	u32 failed_idx;
+
+	return luo_preserve_files(file_set, &token, &fd, 1, &failed_idx);
+}
+
 /**
  * luo_file_unpreserve_files - Unpreserves all files from a file_set.
  * @file_set: The files to be cleaned up.
@@ -320,12 +466,13 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
  * This function serves as the primary cleanup path for a file_set. It is
  * invoked when the userspace agent closes the file_set's file descriptor.
  *
- * For each file, it performs the following cleanup actions:
+ * Files are unpreserved in reverse order of preservation, i.e. in reverse
+ * dependency order. For each file, it performs the following cleanup actions:
  *   1. Calls the handler's .unpreserve() callback to allow the handler to
  *      release any resources it allocated.
  *   2. Removes the file from the file_set's internal tracking list.
  *   3. Releases the reference to the 'struct file' that was taken by
- *      luo_preserve_file() via fput(), returning ownership.
+ *      luo_preserve_files() via fput(), returning ownership.
  *   4. Frees the memory associated with the internal 'struct luo_file'.
  *
  * After all individual files are unpreserved, it frees the contiguous memory
@@ -336,30 +483,9 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
 	struct luo_file *luo_file;
 
 	while (!list_empty(&file_set->files_list)) {
-		struct liveupdate_file_op_args args = {0};
-
 		luo_file = list_last_entry(&file_set->files_list,
 					   struct luo_file, list);
-
-		args.handler = luo_file->fh;
-		args.session = luo_session_from_file_set(file_set);
-		args.file = luo_file->file;
-		args.serialized_data = luo_file->serialized_data;
-		args.private_data = luo_file->private_data;
-		luo_file->fh->ops->unpreserve(&args);
-		luo_flb_file_unpreserve(luo_file->fh);
-
-		xa_erase(&luo_preserved_files,
-			 luo_get_id(luo_file->fh, luo_file->file));
-		module_put(luo_file->fh->ops->owner);
-
-		list_del(&luo_file->list);
-		file_set->count--;
-		kho_block_set_shrink(&file_set->block_set, file_set->count);
-
-		fput(luo_file->file);
-		mutex_destroy(&luo_file->mutex);
-		kfree(luo_file);
+		luo_file_unpreserve_one(file_set, luo_file);
 	}
 
 	kho_block_set_destroy(&file_set->block_set);
@@ -956,18 +1082,16 @@ int liveupdate_get_token_outgoing(struct liveupdate_session *s,
 {
 	struct luo_file_set *file_set = luo_file_set_from_session_locked(s);
 	struct luo_file *luo_file;
-	int err = -ENOENT;
 
 	list_for_each_entry(luo_file, &file_set->files_list, list) {
 		if (luo_file->file == file) {
 			if (tokenp)
 				*tokenp = luo_file->token;
-			err = 0;
-			break;
+			return 0;
 		}
 	}
 
-	return err;
+	return -ENOENT;
 }
 EXPORT_SYMBOL_GPL(liveupdate_get_token_outgoing);
 
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index dac6644bfb18..98ff5c629ac0 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -102,6 +102,8 @@ int luo_session_serialize(void);
 int luo_session_deserialize(void);
 
 int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd);
+int luo_preserve_files(struct luo_file_set *file_set, const u64 *tokens,
+		       const int *fds, u32 nr, u32 *failed_idx);
 void luo_file_unpreserve_files(struct luo_file_set *file_set);
 int luo_file_freeze(struct luo_file_set *file_set,
 		    struct luo_file_set_ser *file_set_ser);
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index f48e9a4185f9..7fa389f73f2a 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -278,6 +278,47 @@ static int luo_session_preserve_fd(struct luo_session *session,
 	return err;
 }
 
+static int luo_session_preserve_fds(struct luo_session *session,
+				    struct luo_ucmd *ucmd)
+{
+	struct liveupdate_session_preserve_fds *argp = ucmd->cmd;
+	u64 *tokens __free(kfree) = NULL;
+	int *fds __free(kfree) = NULL;
+	int err;
+
+	if (argp->__reserved)
+		return -EINVAL;
+
+	if (!argp->nr)
+		return -EINVAL;
+
+	fds = memdup_array_user(u64_to_user_ptr(argp->fds), argp->nr,
+				sizeof(*fds));
+	if (IS_ERR(fds))
+		return PTR_ERR(fds);
+
+	tokens = memdup_array_user(u64_to_user_ptr(argp->tokens), argp->nr,
+				   sizeof(*tokens));
+	if (IS_ERR(tokens))
+		return PTR_ERR(tokens);
+
+	mutex_lock(&session->mutex);
+	err = luo_preserve_files(&session->file_set, tokens, fds, argp->nr,
+				 &argp->out_failed_index);
+	mutex_unlock(&session->mutex);
+	if (err) {
+		/* Best effort, the preserve error takes precedence */
+		luo_ucmd_respond(ucmd, sizeof(*argp));
+		return err;
+	}
+
+	err = luo_ucmd_respond(ucmd, sizeof(*argp));
+	if (err)
+		pr_warn("The files were successfully preserved, but response to user failed\n");
+
+	return err;
+}
+
 static int luo_session_retrieve_fd(struct luo_session *session,
 				   struct luo_ucmd *ucmd)
 {
@@ -345,6 +386,7 @@ union ucmd_buffer {
 	struct liveupdate_session_preserve_fd preserve;
 	struct liveupdate_session_retrieve_fd retrieve;
 	struct liveupdate_session_get_name get_name;
+	struct liveupdate_session_preserve_fds preserve_fds;
 };
 
 /* Type of sessions the ioctl applies to. */
@@ -382,6 +424,9 @@ static const struct luo_ioctl_op luo_session_ioctl_ops[] = {
 		 struct liveupdate_session_retrieve_fd, token, LUO_IOCTL_INCOMING),
 	IOCTL_OP(LIVEUPDATE_SESSION_GET_NAME, luo_session_get_name,
 		 struct liveupdate_session_get_name, name, LUO_IOCTL_ALL),
+	IOCTL_OP(LIVEUPDATE_SESSION_PRESERVE_FDS, luo_session_preserve_fds,
+		 struct liveupdate_session_preserve_fds, __reserved,
+		 LUO_IOCTL_OUTGOING),
 };
 
 static bool luo_ioctl_type_valid(struct luo_session *session,
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


