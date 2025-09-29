Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CDD7CAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 01:04:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 671808E000F; Sun, 28 Sep 2025 21:04:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 623818E0006; Sun, 28 Sep 2025 21:04:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49BBC8E000F; Sun, 28 Sep 2025 21:04:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 308388E0006
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 21:04:31 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EA105572BC
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:04:30 +0000 (UTC)
X-FDA: 83940492300.03.1380956
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf09.hostedemail.com (Postfix) with ESMTP id 26D30140009
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:04:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cvEz0BPj;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759107869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0YV/C30kHxyQuWB9Hp3Rra2QjX9aAIcMuuehexAQLV8=;
	b=VoFsQo3N0SoI5eXrDmDL5ITiF6YPejhZOLUSb4cR64GshTzfM43aABxIykMKhQZaQltoAT
	Dgt149DiYkoaa7yWj6orE5KbAY+w0zT3BKhOBuw/yxrEhH8dG0yJiutYq4sHOrIOPaUQ9y
	GUgSbND/N10xl7EQwYo0u/+bl5Ha+HA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759107869; a=rsa-sha256;
	cv=none;
	b=pEt/rKfcbPjIAunp/6UxFm1KgUzK5jCMboDkYhr1CKIRUCpRSUwuj27CEXE/FEQHKtaibr
	7Sae+khUYPdTRBrxuertIIvL8qSWvdo4bXambzf4dpBqxbcoo/xC2k2V+8igv5fLIoNTcz
	exP6TN03u7k6aiAV+YfdB/KJXHFEWeQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cvEz0BPj;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-85780d76b48so433932585a.1
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 18:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759107868; x=1759712668; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0YV/C30kHxyQuWB9Hp3Rra2QjX9aAIcMuuehexAQLV8=;
        b=cvEz0BPjL9A8CKE+UaR5vP5c8yTyhc9VpkRpxn0aVZbTVOiAAhQR7aStwyfvBH/q3U
         qv0Kgku3qdBzDEiX8116SqlF1LTnj0N0GR5qzpvFwLFiNaKpImKKZ49CHa7YsBn4GbJ9
         5fF4S9ghh4oWDFRcVYpzNgffLY/sPTEoNzlinBf3QdXvH0MgMNECtE+u20zlP5cvXqqW
         vOtJAJiw0QONxua88urW+rnTRGmiyUtASf9mzmgI0UpB1TKCCcepVojNa+dLmnjr75eN
         21CIt21pB3yDPAJHyt69AAH4oy4nKiplGltX1m1mPvH/dNsa4j6IzBL6fqIa0kWgBSgF
         seiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759107868; x=1759712668;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0YV/C30kHxyQuWB9Hp3Rra2QjX9aAIcMuuehexAQLV8=;
        b=wrGdKhhzCj2PsrG+z9S8CqqahMn+JxlvGe8K9LLLUwETV3wQ0Hbtg3m4/CvjBXJuSW
         CJ0kvjHir4VfL8Ur2Jv+igKJbiExlS3IJYt9JN74Q2kppZfQNs/0Lup2sKLHvj7HAJ4H
         MR6ov4yNvf0Mp2wM+g3+DHiqGajGPpfOZk1PNYYJqcI5bNF189OR4ws86ZyuHC2CizIh
         Pbtrz1s7gLt7glTXZfag1923FZEc/r11VBFveiierUPSgVSa3barFgx4QrnDD+5J/c7f
         FmXfgKVncivSJfnLH/O8YcvqBR2gRumSNYCaWR4dUXnspKNikg3pCMlcfs7sIG04ikdA
         iqxw==
X-Forwarded-Encrypted: i=1; AJvYcCW19dDM9SUlfIUPl9AcmPZhYnIW9Lc4VO4t1FPCLj1loD7gKAKEjwYPUdRVTu9fUByDJ0atHBCaKw==@kvack.org
X-Gm-Message-State: AOJu0YxtzC3sdor1G3Ky0aJywnXnzhwcaKr9csgQ/TqAv52UbQQTAGed
	dKrftrhNu1nuAJqPvjNQ80GcK4G19TArToyupuHrI5J9tgyoFEjpsw4titti9Z0zbNQ=
X-Gm-Gg: ASbGncuI66W30GTEqqaCaBiqFGQH9x/CH6lTs+ZlPmglAdL7cW0zHSYcfpskeXYVegt
	gURjAIrhblgX5kRjHstENhmsuZIk/5K3GEG1OQmnduKQG5W77NtVFAF0+YkEnKWC9NoHUH9Qzjt
	x+nJIaVA891RV91muZRX2ChIe/u0hdDRvwBp5zqKWD5Q2HJMXbJvaf8KdMTdwTdgJZcwIemPVSo
	57r7uYd6/5qS6WCwdJAWu7PLJg29ZuTc421B4Y2QTY2QIx36AIqvpsgXZWH3qGFhGeGJn3I4Pk0
	dLgUU/enmtLk4pHR0jHVbkptu4u8xagifc/6/WmRQvIv/ixGHeD9p4PZRtcevIV9pEG2ESHw1Uh
	KQZ1RigS68LUoe/XgnNPAExAlDUxqExfW4CFsg6vckYRB5WSsjuQ+WMUXCT8BDdS2yEhZghqn/K
	ulWOQzVjGWZV0e159z/Q==
X-Google-Smtp-Source: AGHT+IE/2gkO6BHU1Wstnbl9JT+BQr3NoLV1YqF2Ma44UH3Fg76MALcfhQNt/9B9O7w+tSiqkpudoA==
X-Received: by 2002:a05:620a:2805:b0:849:8fcc:69e4 with SMTP id af79cd13be357-85ae8c269e3mr1755065285a.68.1759107827446;
        Sun, 28 Sep 2025 18:03:47 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4db0c0fbe63sm64561521cf.23.2025.09.28.18.03.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Sep 2025 18:03:46 -0700 (PDT)
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
Subject: [PATCH v4 11/30] liveupdate: luo_session: Add sessions support
Date: Mon, 29 Sep 2025 01:03:02 +0000
Message-ID: <20250929010321.3462457-12-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
In-Reply-To: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 26D30140009
X-Stat-Signature: 1n5yrsp5soougimcqpehtkpxp56mxmsd
X-Rspam-User: 
X-HE-Tag: 1759107868-502793
X-HE-Meta: U2FsdGVkX1/GVK1awCkcUkNsfcFuU3MEAwvgq78wo5ysZlXfD7IpdrEgKYzuC5+meiZ4OHc+WAvw20NQmb7WXMYO/wrJENK1v83HY1dZ+rdRt0VLyOt9UDB2mc+oaqNRpNuiLzU2zIBzxmyZNV/Nt0nmRhf7lNiZEoqCWCmL8KC/xPljwlUFetdJUtlFoSWKIurjBAcm822mfsK9TBeHCsWC+dBKXAMKGL+Gctuu7Y1bZeuCCt4rZ2EDpAk6xgtZtwI2FHDOtvX2BcMFvcq+Ea0zYYu2WuGgyFY20ygCwoanrhirSKoHAWDxU/3vvsHsMvsYrX3U5DN5iW4u3lP0EPjJ7TGB93PzEWb5f66hkMhqcQDAHJUKpqg79isKWwLaS6syaWK+WxSrIBFQKgwfhS4+KJdDLONKaxnp7qqw8Ht2bWDUp78k7JKJ4TECfOBEqmAuq9de2W+X5tIB3hWT/mnA3Y16MKfR3k4qP95p3uN5IaPliWePjcG00YwCoAhrsPYUyEXXDT2GvFhsDML4Wqkvnn4d/8QvWh4x/9sXAjA68Y7dtL144FGJBLfNX8otD/YJ3zXjgOTaZkQpFc1G2heb30tuYk8/ifTAuBja7na07TwAE30M7BspskUS4FyqR3/snOU8mKakFRHDl4xusH1KFkWiwTje1lmeahjwfYKPT0+JBGZjtEgoooL3QCNcpKMGPYmVHbR5GjoSSB7SQBYZNOIlGs096r+34GT1LrcWSXb1SSWyxZeYXfX1VGSNR6o9Khy1/l4Mm6S9teBvDczn8la6kZHkzEoa8fbx7b8sGma8KaAc0wyFkC8lEsdGQrJpO6qLHsiM9lRCHxx6jSoHj0XO9pTUvt1H0KTtxlZmFE3/qoeWGQzpdta0c3WtqFPRpLMmACBr5m3eKf03u2+f85cN6yE2rinKvtp7j279wBixj3AHS1hgYliHUZ7ZQ5uVLXu7iG8D6HLJYVJ
 OnWLuolC
 b7OFvVEi3NA8j0GjHPvrUuukDNoAalqNZ2qD4zKutzGpt1MmWYDR5DDXEDick2SMGmFQyYC02FBa7OlFRKN/6JLsP6lILp3MKojX5LM7AlvpfcIp12wwlmP/tMLJz6lltfdXswQA/T6bSc8jSuHihsxjrQuA5rlEiBP+E5YIH4WyYBPS091P1v4a9cEErY4mxQa1g/G5z1jri5+HW6H0nd+v+HgInLXRz0bteRE0YU0JwqU2FEG9zFmtIZPCQhyoRgIl7H5rxYsdVHI8VWR4kwC+3GbH9KoL7PnEsuXgfbI1ZLHRVxupAltvSYoo04DDD18h5YrjmVbtPL1GCU2a11/cqi9olE3mQ1MaZsaB+n/I9OuaMYPAg/CAM17nDBvw91wt55AigOd2KjhsHflZkCqVfowyiHrpscdn6KasLeepO5VUTS/fvZlQnyfQaF7VfxfQo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce concept of "Live Update Sessions" within the LUO framework.
LUO sessions provide a mechanism to group and manage `struct file *`
instances (representing file descriptors) that need to be preserved
across a kexec-based live update.

Each session is identified by a unique name and acts as a container
for file objects whose state is critical to a userspace workload, such
as a virtual machine or a high-performance database, aiming to maintain
their functionality across a kernel transition.

This groundwork establishes the framework for preserving file-backed
state across kernel updates, with the actual file data preservation
mechanisms to be implemented in subsequent patches.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/uapi/linux/liveupdate.h  |   3 +
 kernel/liveupdate/Makefile       |   1 +
 kernel/liveupdate/luo_internal.h |  34 ++
 kernel/liveupdate/luo_session.c  | 607 +++++++++++++++++++++++++++++++
 4 files changed, 645 insertions(+)
 create mode 100644 kernel/liveupdate/luo_session.c

diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
index 3cb09b2c4353..e8c0c210a790 100644
--- a/include/uapi/linux/liveupdate.h
+++ b/include/uapi/linux/liveupdate.h
@@ -91,4 +91,7 @@ enum liveupdate_event {
 	LIVEUPDATE_CANCEL = 3,
 };
 
+/* The maximum length of session name including null termination */
+#define LIVEUPDATE_SESSION_NAME_LENGTH 56
+
 #endif /* _UAPI_LIVEUPDATE_H */
diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
index 2881bab0c6df..f64cfc92cbf0 100644
--- a/kernel/liveupdate/Makefile
+++ b/kernel/liveupdate/Makefile
@@ -3,6 +3,7 @@
 luo-y :=								\
 		luo_core.o						\
 		luo_ioctl.o						\
+		luo_session.o						\
 		luo_subsystems.o
 
 obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index c62fbbb0790c..9223f71844ca 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -32,6 +32,40 @@ void *luo_contig_alloc_preserve(size_t size);
 void luo_contig_free_unpreserve(void *mem, size_t size);
 void luo_contig_free_restore(void *mem, size_t size);
 
+/**
+ * struct luo_session - Represents an active or incoming Live Update session.
+ * @name:      A unique name for this session, used for identification and
+ *             retrieval.
+ * @files_xa:  An xarray used to store the files associated with this session.
+ * @ser:       Pointer to the serialized data for this session.
+ * @count:     A counter tracking the number of files currently stored in the
+ *             @files_xa for this session.
+ * @list:      A list_head member used to link this session into a global list
+ *             of either outgoing (to be preserved) or incoming (restored from
+ *             previous kernel) sessions.
+ * @retrieved: A boolean flag indicating whether this session has been retrieved
+ *             by a consumer in the new kernel. Valid only during the
+ *             LIVEUPDATE_STATE_UPDATED state.
+ * @mutex:     Session lock, protects files_xa, and count.
+ * @state:     State of this session: prepared/frozen/updated/normal.
+ * @files:     The physical address of a contiguous memory block that holds
+ *             the serialized state of files.
+ */
+struct luo_session {
+	char name[LIVEUPDATE_SESSION_NAME_LENGTH];
+	struct xarray files_xa;
+	struct luo_session_ser *ser;
+	long count;
+	struct list_head list;
+	bool retrieved;
+	struct mutex mutex;
+	enum liveupdate_state state;
+	u64 files;
+};
+
+int luo_session_create(const char *name, struct file **filep);
+int luo_session_retrieve(const char *name, struct file **filep);
+
 void luo_subsystems_startup(void *fdt);
 int luo_subsystems_fdt_setup(void *fdt);
 int luo_do_subsystems_prepare_calls(void);
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
new file mode 100644
index 000000000000..74dee42e24b7
--- /dev/null
+++ b/kernel/liveupdate/luo_session.c
@@ -0,0 +1,607 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+/**
+ * DOC: LUO Sessions
+ *
+ * LUO Sessions provide the core mechanism for grouping and managing file
+ * descriptors that need to be preserved across a kexec-based live update.
+ * Each session acts as a named container for a set of file objects, allowing
+ * a userspace agent (e.g., a Live Update Orchestration Daemon) to manage the
+ * lifecycle of resources critical to a workload.
+ *
+ * Core Concepts:
+ *
+ * - Named Containers: Sessions are identified by a unique, user-provided name,
+ *   which is used for both creation and retrieval.
+ *
+ * - Userspace Interface: Session management is driven from userspace via
+ *   ioctls on /dev/liveupdate (e.g., CREATE_SESSION, RETRIEVE_SESSION).
+ *
+ * - Serialization: Session metadata is preserved using the KHO framework.
+ *   During the 'prepare' phase, an array of `struct luo_session_ser` is
+ *   allocated and preserved. An FDT node is also created, containing the
+ *   count of sessions and the physical address of this array.
+ *
+ * Session Lifecycle and State Management:
+ *
+ * 1.  Creation: A userspace agent calls `luo_session_create()` to create a new,
+ *     empty session, receiving a file descriptor handle. This can be done in
+ *     the NORMAL or UPDATED states.
+ *
+ * 2.  Name Collision: In the UPDATED state, `luo_session_create()` checks for
+ *     name conflicts against sessions preserved from the previous kernel to
+ *     prevent ambiguity.
+ *
+ * 3.  Preparation (`prepare` callback): When the global LUO PREPARE event is
+ *     triggered, the list of all created sessions is serialized. The main
+ *     `ser` array is allocated, and each active `struct luo_session` is given
+ *     a direct pointer to its corresponding entry in this array.
+ *
+ * 4.  Release After Prepare: When a session FD is closed *after* the PREPARE
+ *     event, the `.release` handler uses the session's direct pointer to
+ *     `memset(0)` its entry in the `ser` array. This effectively marks the
+ *     session as defunct without needing to resize the already-preserved
+ *     memory.
+ *
+ * 5.  Boot (`boot` callback): In the new kernel, the FDT is read to locate
+ *     the preserved `ser` array. The metadata (count, physical address) is
+ *     stored in the `luo_session` global.
+ *
+ * 6.  Lazy Deserialization: The actual `luo_session` list is populated on
+ *     first use (e.g., by `retrieve`, `finish`, or `create`). During this
+ *     process, any zeroed-out entries from step 4 are skipped.
+ *
+ * 7.  Retrieval: The userspace agent calls `luo_session_retrieve()` in the new
+ *     kernel to get a new FD handle for a preserved session by its name.
+ *
+ * 8.  Finalization (`finish` callback): When the global LUO FINISH event is
+ *     sent, any preserved sessions that were successfully retrieved are moved
+ *     to the `luo_session_global` list, making them available for a subsequent
+ *     live update. Any sessions that were not retrieved are considered stale
+ *     and are cleaned up.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/anon_inodes.h>
+#include <linux/errno.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/libfdt.h>
+#include <linux/liveupdate.h>
+#include <uapi/linux/liveupdate.h>
+#include "luo_internal.h"
+
+#define LUO_SESSION_NODE_NAME	"luo-session"
+#define LUO_SESSION_COMPATIBLE	"luo-session-v1"
+
+/**
+ * struct luo_session_ser - Represents the serialized metadata for a LUO session.
+ * @name:    The unique name of the session, copied from the `luo_session`
+ *           structure.
+ * @files:   The physical address of a contiguous memory block that holds
+ *           the serialized state of files.
+ * @pgcnt:   The number of pages occupied by the `files` memory block.
+ * @count:   The total number of files that were part of this session during
+ *           serialization. Used for iteration and validation during
+ *           restoration.
+ *
+ * This structure is used to package session-specific metadata for transfer
+ * between kernels via Kexec Handover. An array of these structures (one per
+ * session) is created and passed to the new kernel, allowing it to reconstruct
+ * the session context.
+ *
+ * If this structure is modified, LUO_SESSION_COMPATIBLE must be updated.
+ */
+struct luo_session_ser {
+	char name[LIVEUPDATE_SESSION_NAME_LENGTH];
+	u64 files;
+	u64 pgcnt;
+	u64 count;
+} __packed;
+
+/**
+ * struct luo_session_global - Global container for managing LUO sessions.
+ * @count: The number of sessions currently tracked in the @list.
+ * @list:  The head of the linked list of `struct luo_session` instances.
+ * @rwsem: A read-write semaphore providing synchronized access to the session
+ *         list and other fields in this structure.
+ * @ser:   A pointer to the contiguous block of memory holding the serialized
+ *         session data (an array of `struct luo_session_ser`). For `_out`, this
+ *         is allocated and populated during `prepare`. For `_in`, this points
+ *         to the data restored from the previous kernel.
+ * @pgcnt: The size, in pages, of the memory block pointed to by @ser.
+ * @fdt:   A pointer to the FDT blob that contains the metadata for this group
+ *         of sessions. This FDT is what is ultimately passed to the parent LUO
+ *         subsystem for preservation.
+ */
+struct luo_session_global {
+	long count;
+	struct list_head list;
+	struct rw_semaphore rwsem;
+	struct luo_session_ser *ser;
+	u64 pgcnt;
+	void *fdt;
+	long ser_count;
+};
+
+static struct luo_session_global luo_session_global;
+
+static struct luo_session *luo_session_alloc(const char *name)
+{
+	struct luo_session *session = kzalloc(sizeof(*session), GFP_KERNEL);
+
+	if (!session)
+		return NULL;
+
+	strscpy(session->name, name, sizeof(session->name));
+	xa_init(&session->files_xa);
+	session->count = 0;
+	INIT_LIST_HEAD(&session->list);
+	mutex_init(&session->mutex);
+	session->state = LIVEUPDATE_STATE_NORMAL;
+
+	return session;
+}
+
+static void luo_session_free(struct luo_session *session)
+{
+	WARN_ON(session->count);
+	xa_destroy(&session->files_xa);
+	mutex_destroy(&session->mutex);
+	kfree(session);
+}
+
+static int luo_session_insert(struct luo_session *session)
+{
+	struct luo_session *it;
+
+	lockdep_assert_held_write(&luo_session_global.rwsem);
+	/*
+	 * For small number of sessions this loop won't hurt performance
+	 * but if we ever start using a lot of sessions, this might
+	 * become a bottle neck during deserialization time, as it would
+	 * cause O(n*n) complexity.
+	 */
+	list_for_each_entry(it, &luo_session_global.list, list) {
+		if (!strncmp(it->name, session->name, sizeof(it->name)))
+			return -EEXIST;
+	}
+	list_add_tail(&session->list, &luo_session_global.list);
+	luo_session_global.count++;
+
+	return 0;
+}
+
+static void luo_session_remove(struct luo_session *session)
+{
+	lockdep_assert_held_write(&luo_session_global.rwsem);
+	list_del(&session->list);
+	luo_session_global.count--;
+}
+
+/* One session switches from the updated state to  normal state */
+static void luo_session_finish_one(struct luo_session *session)
+{
+}
+
+/* Cancel one session from frozen or prepared state, back to normal */
+static void luo_session_cancel_one(struct luo_session *session)
+{
+}
+
+/* One session is changed from normal to prepare state */
+static int luo_session_prepare_one(struct luo_session *session)
+{
+	return 0;
+}
+
+static int luo_session_release(struct inode *inodep, struct file *filep)
+{
+	struct luo_session *session = filep->private_data;
+
+	scoped_guard(rwsem_read, &luo_session_global.rwsem) {
+		scoped_guard(mutex, &session->mutex) {
+			if (session->ser) {
+				memset(session->ser, 0,
+				       sizeof(struct luo_session_ser));
+			}
+		}
+	}
+
+	if (session->state == LIVEUPDATE_STATE_UPDATED)
+		luo_session_finish_one(session);
+	if (session->state == LIVEUPDATE_STATE_PREPARED ||
+	    session->state == LIVEUPDATE_STATE_FROZEN) {
+		luo_session_cancel_one(session);
+	}
+
+	scoped_guard(rwsem_write, &luo_session_global.rwsem)
+		luo_session_remove(session);
+	luo_session_free(session);
+
+	return 0;
+}
+
+static const struct file_operations luo_session_fops = {
+	.owner = THIS_MODULE,
+	.release = luo_session_release,
+};
+
+static void luo_session_deserialize(void)
+{
+	static int visited;
+	int i;
+
+	if (visited)
+		return;
+
+	guard(rwsem_write)(&luo_session_global.rwsem);
+	if (visited)
+		return;
+	visited++;
+	for (i = 0; i < luo_session_global.ser_count; i++) {
+		struct luo_session *session;
+
+		/*
+		 * If there is no name, this session was remove from
+		 * preservation after prepare. So, skip it.
+		 */
+		if (!luo_session_global.ser[i].name[0])
+			continue;
+
+		session = luo_session_alloc(luo_session_global.ser[i].name);
+		if (!session)
+			luo_restore_fail("Failed to allocate session on boot\n");
+
+		if (luo_session_insert(session)) {
+			luo_restore_fail("Failed to insert session due to name conflict [%s]\n",
+					 session->name);
+		}
+
+		session->state = LIVEUPDATE_STATE_UPDATED;
+		session->count = luo_session_global.ser[i].count;
+		session->files = luo_session_global.ser[i].files;
+	}
+}
+
+/* Create a "struct file" for session, and delete it on case of failure */
+static int luo_session_getfile(struct luo_session *session, struct file **filep)
+{
+	char name_buf[128];
+	struct file *file;
+
+	scoped_guard(mutex, &session->mutex) {
+		lockdep_assert_held(&session->mutex);
+		snprintf(name_buf, sizeof(name_buf), "[luo_session] %s",
+			 session->name);
+		file = anon_inode_getfile(name_buf, &luo_session_fops, session,
+					  O_RDWR);
+	}
+	if (IS_ERR(file)) {
+		scoped_guard(rwsem_write, &luo_session_global.rwsem)
+			luo_session_remove(session);
+		luo_session_free(session);
+		return PTR_ERR(file);
+	}
+
+	*filep = file;
+	return 0;
+}
+
+int luo_session_create(const char *name, struct file **filep)
+{
+	struct luo_session *session;
+	int ret;
+
+	guard(rwsem_read)(&luo_state_rwsem);
+
+	/* New sessions cannot be added after prepared state */
+	if (!liveupdate_state_normal() && !liveupdate_state_updated())
+		return -EAGAIN;
+
+	session = luo_session_alloc(name);
+	if (!session)
+		return -ENOMEM;
+
+	scoped_guard(rwsem_write, &luo_session_global.rwsem)
+		ret = luo_session_insert(session);
+	if (ret) {
+		luo_session_free(session);
+		return ret;
+	}
+
+	return luo_session_getfile(session, filep);
+}
+
+int luo_session_retrieve(const char *name, struct file **filep)
+{
+	struct luo_session *session = NULL;
+	struct luo_session *it;
+
+	guard(rwsem_read)(&luo_state_rwsem);
+
+	/* Can only retrieve in the updated state */
+	if (!liveupdate_state_updated())
+		return -EAGAIN;
+
+	luo_session_deserialize();
+	scoped_guard(rwsem_read, &luo_session_global.rwsem) {
+		list_for_each_entry(it, &luo_session_global.list, list) {
+			if (!strncmp(it->name, name, sizeof(it->name))) {
+				session = it;
+				break;
+			}
+		}
+	}
+
+	if (!session)
+		return -ENOENT;
+
+	scoped_guard(mutex, &session->mutex) {
+		/*
+		 * Session already retrieved or a session with the same name was
+		 * created during updated state
+		 */
+		if (session->retrieved || session->state != LIVEUPDATE_STATE_UPDATED)
+			return -EADDRINUSE;
+
+		session->retrieved = true;
+	}
+
+	return luo_session_getfile(session, filep);
+}
+
+static void luo_session_global_preserved_cleanup(void)
+{
+	lockdep_assert_held_write(&luo_session_global.rwsem);
+	if (luo_session_global.ser && !IS_ERR(luo_session_global.ser)) {
+		luo_contig_free_unpreserve(luo_session_global.ser,
+					   luo_session_global.pgcnt << PAGE_SHIFT);
+	}
+	if (luo_session_global.fdt && !IS_ERR(luo_session_global.fdt))
+		luo_contig_free_unpreserve(luo_session_global.fdt, PAGE_SIZE);
+
+	luo_session_global.fdt = NULL;
+	luo_session_global.ser = NULL;
+	luo_session_global.ser_count = 0;
+	luo_session_global.pgcnt = 0;
+}
+
+static int luo_session_fdt_setup(void)
+{
+	u64 ser_pa;
+	int ret;
+
+	lockdep_assert_held_write(&luo_session_global.rwsem);
+	luo_session_global.pgcnt = DIV_ROUND_UP(luo_session_global.count *
+				sizeof(struct luo_session_ser), PAGE_SIZE);
+
+	if (luo_session_global.pgcnt > 0) {
+		size_t ser_size = luo_session_global.pgcnt << PAGE_SHIFT;
+
+		luo_session_global.ser = luo_contig_alloc_preserve(ser_size);
+		if (IS_ERR(luo_session_global.ser)) {
+			ret = PTR_ERR(luo_session_global.ser);
+			goto exit_cleanup;
+		}
+	}
+
+	luo_session_global.fdt = luo_contig_alloc_preserve(PAGE_SIZE);
+	if (IS_ERR(luo_session_global.fdt)) {
+		ret = PTR_ERR(luo_session_global.fdt);
+		goto exit_cleanup;
+	}
+
+	ret = fdt_create(luo_session_global.fdt, PAGE_SIZE);
+	if (ret < 0)
+		goto exit_cleanup;
+
+	ret = fdt_finish_reservemap(luo_session_global.fdt);
+	if (ret < 0)
+		goto exit_finish;
+
+	ret = fdt_begin_node(luo_session_global.fdt, LUO_SESSION_NODE_NAME);
+	if (ret < 0)
+		goto exit_finish;
+
+	ret = fdt_property_string(luo_session_global.fdt, "compatible",
+				  LUO_SESSION_COMPATIBLE);
+	if (ret < 0)
+		goto exit_end_node;
+
+	ret = fdt_property_u64(luo_session_global.fdt, "count",
+			       luo_session_global.count);
+	if (ret < 0)
+		goto exit_end_node;
+
+	ser_pa = luo_session_global.ser ? __pa(luo_session_global.ser) : 0;
+	ret = fdt_property_u64(luo_session_global.fdt, "data", ser_pa);
+	if (ret < 0)
+		goto exit_end_node;
+
+	ret = fdt_property_u64(luo_session_global.fdt, "pgcnt",
+			       luo_session_global.pgcnt);
+	if (ret < 0)
+		goto exit_end_node;
+
+	ret = fdt_end_node(luo_session_global.fdt);
+	if (ret < 0)
+		goto exit_finish;
+
+	ret = fdt_finish(luo_session_global.fdt);
+	if (ret < 0)
+		goto exit_cleanup;
+
+	return 0;
+
+exit_end_node:
+	fdt_end_node(luo_session_global.fdt);
+exit_finish:
+	fdt_finish(luo_session_global.fdt);
+exit_cleanup:
+	luo_session_global_preserved_cleanup();
+
+	return ret;
+}
+
+/*
+ * Change all sessions to normal state: make every file within each session
+ * to be in the normal state.
+ */
+static void luo_session_cancel(struct liveupdate_subsystem *h, u64 data)
+{
+	struct luo_session *it;
+
+	guard(rwsem_write)(&luo_session_global.rwsem);
+	list_for_each_entry(it, &luo_session_global.list, list)
+		luo_session_cancel_one(it);
+	luo_session_global_preserved_cleanup();
+}
+
+static int luo_session_prepare(struct liveupdate_subsystem *h, u64 *data)
+{
+	struct luo_session_ser *ser;
+	struct luo_session *it;
+	int ret;
+
+	scoped_guard(rwsem_write, &luo_session_global.rwsem) {
+		ret = luo_session_fdt_setup();
+		if (ret)
+			return ret;
+
+		ser = luo_session_global.ser;
+		list_for_each_entry(it, &luo_session_global.list, list) {
+			if (it->state == LIVEUPDATE_STATE_NORMAL) {
+				ret = luo_session_prepare_one(it);
+				if (ret)
+					break;
+			}
+			strscpy(ser->name, it->name, sizeof(ser->name));
+			ser->count = it->count;
+			ser->files = it->files;
+			it->ser = ser;
+			ser++;
+		}
+
+		if (!ret)
+			*data = __pa(luo_session_global.fdt);
+	}
+
+	if (ret)
+		luo_session_cancel(h, 0);
+
+	return ret;
+}
+
+static int luo_session_freeze(struct liveupdate_subsystem *h, u64 *data)
+{
+	return 0;
+}
+
+/*
+ * Finish every file within each session. If session has not been reclaimed
+ * remove it, otherwise keep this session, so it can participate in the
+ * next live update.
+ */
+static void luo_session_finish(struct liveupdate_subsystem *h, u64 data)
+{
+	struct luo_session *session, *tmp;
+
+	luo_session_deserialize();
+
+	list_for_each_entry_safe(session, tmp, &luo_session_global.list, list) {
+		/*
+		 * Skip sessions that were created in new kernel or have been
+		 * finished already.
+		 */
+		if (session->state != LIVEUPDATE_STATE_UPDATED)
+			continue;
+		luo_session_finish_one(session);
+		if (!session->retrieved) {
+			pr_warn("Removing unreclaimed session[%s]\n",
+				session->name);
+			scoped_guard(rwsem_write, &luo_session_global.rwsem)
+				luo_session_remove(session);
+			luo_session_free(session);
+		}
+	}
+
+	scoped_guard(rwsem_write, &luo_session_global.rwsem)
+		luo_session_global_preserved_cleanup();
+}
+
+static void luo_session_boot(struct liveupdate_subsystem *h, u64 data)
+{
+	u64 count, data_pa, pgcnt;
+	const void *prop;
+	int prop_len;
+	void *fdt;
+
+	fdt = __va(data);
+	if (fdt_node_check_compatible(fdt, 0, LUO_SESSION_COMPATIBLE))
+		luo_restore_fail("luo-session FDT incompatible\n");
+
+	prop = fdt_getprop(fdt, 0, "count", &prop_len);
+	if (!prop || prop_len != sizeof(u64))
+		luo_restore_fail("luo-session FDT missing or invalid 'count'\n");
+	count = be64_to_cpup(prop);
+
+	prop = fdt_getprop(fdt, 0, "data", &prop_len);
+	if (!prop || prop_len != sizeof(u64))
+		luo_restore_fail("luo-session FDT missing or invalid 'data'\n");
+	data_pa = be64_to_cpup(prop);
+
+	prop = fdt_getprop(fdt, 0, "pgcnt", &prop_len);
+	if (!prop || prop_len != sizeof(u64))
+		luo_restore_fail("luo-session FDT missing or invalid 'pgcnt'\n");
+	pgcnt = be64_to_cpup(prop);
+
+	if (!count)
+		return;
+
+	guard(rwsem_write)(&luo_session_global.rwsem);
+	luo_session_global.fdt = fdt;
+	luo_session_global.ser = __va(data_pa);
+	luo_session_global.ser_count = count;
+	luo_session_global.pgcnt = pgcnt;
+}
+
+static const struct liveupdate_subsystem_ops luo_session_subsys_ops = {
+	.prepare = luo_session_prepare,
+	.freeze = luo_session_freeze,
+	.cancel = luo_session_cancel,
+	.boot = luo_session_boot,
+	.finish = luo_session_finish,
+	.owner = THIS_MODULE,
+};
+
+static struct liveupdate_subsystem luo_session_subsys = {
+	.ops = &luo_session_subsys_ops,
+	.name = LUO_SESSION_COMPATIBLE,
+};
+
+static int __init luo_session_startup(void)
+{
+	int ret;
+
+	if (!liveupdate_enabled())
+		return 0;
+
+	init_rwsem(&luo_session_global.rwsem);
+	INIT_LIST_HEAD(&luo_session_global.list);
+
+	ret = liveupdate_register_subsystem(&luo_session_subsys);
+	if (ret) {
+		pr_warn("Failed to register luo_session subsystem [%d]\n", ret);
+		return ret;
+	}
+
+	return ret;
+}
+late_initcall(luo_session_startup);
-- 
2.51.0.536.g15c5d4f767-goog


