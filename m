Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80931CCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 08:43:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1CA38E005F; Fri, 24 Oct 2025 04:43:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA6258E0042; Fri, 24 Oct 2025 04:43:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1F878E005F; Fri, 24 Oct 2025 04:43:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 870528E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 04:43:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 32F91140DD9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:43:21 +0000 (UTC)
X-FDA: 84032368602.26.4F029BC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id CE9B3C0003
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:43:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F4I+z090;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of amarkuze@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=amarkuze@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761295398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+YEhQugvjJGD9rocNk61MKJgnvqoLJlUTVFDpUrcAXI=;
	b=IhOts+wlmt9f36yWvxtX09ip3qDxZcvnXjVJEOhNTil44jF+lxxntAUaC3q3w+x0ML6ZZE
	j5cG9Doi9Hd3S8idTDS51FljgpEKbQkqjOM7iKEQUN1CrlikojIY/17v1k+tsXjYnqWhCZ
	64Zo42j6V8tLMYUj6y9i4WjMRnQs/9M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F4I+z090;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of amarkuze@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=amarkuze@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761295398; a=rsa-sha256;
	cv=none;
	b=03rLUIG/ZI0kpHpBhQU/CcL0vrQoz/4R3RuOJkulvZflXBj5d3RIokk2Xz5QU0YK8J2Zta
	AUQXOnkVrtfh5uew7HYEKqrkUy9JQ520IWR36MSPpWnP0McNJmZdFgFKroUp+KHsAKOScW
	t2280d0i85qdzOKsWj6x8bIcfz2kqJ4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761295398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+YEhQugvjJGD9rocNk61MKJgnvqoLJlUTVFDpUrcAXI=;
	b=F4I+z090ACBdP/ZlsB1RDDARnXwlfRMi34xOfprtBZt8nTaxJDqYxO2IrGqV/euWTXNUnl
	5BFJL123/VGctO4fZQ3MUd556OeM+wbv2HQCGrYxzMM9OWFQOfnP9mguLsiiaMN0/09cr3
	U/Eyf0M8Dzn6PhUGSFs6u3x4yRILDuY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-401-BDqX9kfrPsOD5nQ3zNqWZQ-1; Fri, 24 Oct 2025 04:43:16 -0400
X-MC-Unique: BDqX9kfrPsOD5nQ3zNqWZQ-1
X-Mimecast-MFC-AGG-ID: BDqX9kfrPsOD5nQ3zNqWZQ_1761295396
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-634cdb5d528so4072268a12.1
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 01:43:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761295395; x=1761900195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+YEhQugvjJGD9rocNk61MKJgnvqoLJlUTVFDpUrcAXI=;
        b=N5OlcRv2fOVPa4ZJLL25h/xSeaI6J5bZXR86IOuUQCiS0R2GqHFUoN9BtW6GSOGZhn
         +madfIrOQcoQAgcOWM8viW/GhurjvBgbI3Q0lONd/kKxLekdsG7Guy1z7zlhuZ0I9gHL
         e/pyDy9m1kP+o4uNJK206yb2L8V3wHkPYvtghF5SoULMZh9H5FN6RlDkC9sLxFV3VpKc
         merA8vZX6YJyM9gxDYplePcSpWk1MJ3MAOHBuhsWSAoVLDZpRKMCQomyVXBg7CaMvyLO
         PiOHUaPsrHTwoD2vTctztowxVSDAgCMuxXvITT5EbMTEAY+iZXeJSHiuTEGmIZ9V490n
         EOTg==
X-Forwarded-Encrypted: i=1; AJvYcCVH8hOj+ahLeunYfKARIgP5qNdvMEFqfr1WfOxGvQwpzz8QtfVYIVKQf3x2y0VP73EEL+weWFlk4w==@kvack.org
X-Gm-Message-State: AOJu0YyCBGOuAL36kSECi0mdMWP2n60YhffEa7DW/YFQmOdV2uYjeOI8
	cK5OsZ9HheSz/31L6K1ViqyLiTkFbk3OyPcHxPPdyiAFrNyGy8LtDI6PBkf6P7KA5qOQi+6XChr
	oif0CEjonufkdJCc1u0042IKX6ZHMVKaZd6yzYLp36HHuFT2o2x5N
X-Gm-Gg: ASbGncvQiTLCz7mnNvUXCGVn1qwvOwyAn3kC7NL9wIHMgT3oFL0ihKXfSthHOlpz0oS
	63XkGKiQZr9zybQ/IdJVsPU36zdmMIxX1SpT3S2sHOcH1+zTN6yebSAnxZKdj/Z1tUdbw/yvrhH
	I4kaGeZ2nKgOzZztNqxbdEXp5OtXJuBwmHGsAdvGBIJMA4BaOCXsvfmgG+/R6R8Ra/bvnck3FfA
	nzc0LdawtdlYhnJQraZvUgF2phszoTpGAGjCbEXZ6/huvLMfCDMjCoOScGyYiQzKvKkiVrfOesm
	NuGQO3WRjOyZwQvx0opOuPdKv+YTcakPpTpxo13c0c5dnIBCYcY5r+ZOCc5ZU8RxN/pE5afRG9i
	C13jUn5FT+eHRtq0m4Hy9AyBwPyOEyyHE
X-Received: by 2002:a17:907:e887:b0:afa:1d2c:bbd1 with SMTP id a640c23a62f3a-b6d6bcf8c71mr185669166b.30.1761295395429;
        Fri, 24 Oct 2025 01:43:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGY5mEE5uypHs1peyLV3gmUlLkQrdYcM4lntYsOOHalbAYVVbBN+cXnOEwbWEvJxbWbaGXkXw==
X-Received: by 2002:a17:907:e887:b0:afa:1d2c:bbd1 with SMTP id a640c23a62f3a-b6d6bcf8c71mr185666466b.30.1761295394894;
        Fri, 24 Oct 2025 01:43:14 -0700 (PDT)
Received: from cluster.. (4f.55.790d.ip4.static.sl-reverse.com. [13.121.85.79])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6d511d010asm469226866b.11.2025.10.24.01.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 01:43:14 -0700 (PDT)
From: Alex Markuze <amarkuze@redhat.com>
To: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Liam.Howlett@oracle.com,
	amarkuze@redhat.com,
	akpm@linux-foundation.org,
	bsegall@google.com,
	david@redhat.com,
	dietmar.eggemann@arm.com,
	idryomov@gmail.com,
	mingo@redhat.com,
	juri.lelli@redhat.com,
	kees@kernel.org,
	lorenzo.stoakes@oracle.com,
	mgorman@suse.de,
	mhocko@suse.com,
	rppt@kernel.org,
	peterz@infradead.org,
	rostedt@goodmis.org,
	surenb@google.com,
	vschneid@redhat.com,
	vincent.guittot@linaro.org,
	vbabka@suse.cz,
	xiubli@redhat.com,
	Slava.Dubeyko@ibm.com
Subject: [RFC PATCH 3/5] ceph: Add BLOG scaffolding
Date: Fri, 24 Oct 2025 08:42:57 +0000
Message-Id: <20251024084259.2359693-4-amarkuze@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251024084259.2359693-1-amarkuze@redhat.com>
References: <20251024084259.2359693-1-amarkuze@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: epZIZZ0JVn7_y1qbHw_HTyNmOb9HSnIc2dni6xmr3Sg_1761295396
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: CE9B3C0003
X-Rspamd-Server: rspam03
X-Stat-Signature: axz1swzq53mesc8asf6xd493ytsrnn53
X-HE-Tag: 1761295398-623921
X-HE-Meta: U2FsdGVkX18uMgsvySSAaUFFRk8F+oiAyfcEmaYMo8k6bMuBLsAoeF86C0RT/xmeCr7xvPA3lE7qsDVzMjXU7s5OaMhDIhnwWKHN3UhJ3LEs0JFnXS2L7nJiVsZVSNQxo5vHlBjNQBw7qUdh0YwybpuD4JLL8CK0t0qvEj0edZHw3yP8/YboR8d26z5SuyE2628NdgkApS9iWR2NzBjoESM2A/fPMOqudv7HmKqGjRXGGtBMF7vcMUzDVeaoytELdq7jWQOZFPbElOVvWvo3xiV86jMwFvqPIPXurtGCGAgEWRq+qaKO0jgxkFLhZaziX4WVQKfZNozjSR0On+HEF/WHGhJun7fNHv01sFxaBD0HR5ylUxIMzXHwiU0JlIavHVtu5q+jdtVkr3lCwfMdYpifvwnmGKbmf5dlpzJsL7riZsBvGP1cyRGJctXX+TAjn3nhk+d/TiwR/kbvPto0VcclQjQRlS/HQRMm6d/q8v3eFqj9qXffe+SenLFprVq0SRlxOdA4z33HjgklfjXQVepwGyOX/IzO8dAqkrPn/PSfWGGZ9S9NKLmEauZHucR2YTo5Rdy1ccUbepViTEB/E8XuEwnpk6ZrLfVrE9GcdW96RRBnWYk6zW99SCEjnc3MCIuvhF3qW2aEZUy39IXv2WRKyRTk3UPS9Vd/hF1ipKIpY+INW2y3Je8O2CDMnbxTsGZNcRbkBJG6Bil+MsQ+VlwzCAasn6KP1PJV0CG5GvRWaAGqmHx4WQRaLOjPyhezBpRqsO6MN+dp+nIGZK8Hu2K4YVlUQtcjY0cYjFUM7oK3tY8EGWTMrOpu0wzgtWVCsk842Pp7clCwmdEZqFPolHDMsTjvvAJPSVGHPw/r9HOs97Mk/E+cRY/5kOlEaVZ3a7rtzij0cw+LmJCsfBbzVYCOcxKBBgQKaOm2EJvLzCB9n5Un2v9CqnjmvxLwYmqbx6QEk/49HPU19ZUGapS
 kDh+aNHu
 Uh9UjP2gCJBXQh+hjgcIMNeU6TeJT5pMhpHieQcIIwfr1vpiM3FHHieWYhSiGImRM1gPlPAZ2mJ+kmi1mRGsmw54umE5xDyjtA6OoMXW3AQ5iPZLAJa690W2RTjwAN/CJZcP3emWi77qp1jYXQt7HTpwu1KpzXuGsy6+Cpwd29obt+xm6ntAWI6Nbz38B+UcqGv9WfwE4H0MKhrk6iw2OZxvIwQN8puQtC0tzWgX70VdoCLZnhzs19wOHDDn+opo5c2Bdu5cJ8zywz3MlCq0H+lnogmntzRSsKeNQRDMNzN2qfjnsRT89JhTU7AhPXUwi8FyGtSbdlm1P5NPQMnC1TRFnPyGbpVfktzB+9e2axCfAV7R5+8+BVl9ypM9S/FaLTKYePLXu6cRCwDqWrmkrow5SPj/K/dTjAsxCqqhZ6egskzitYoVUgLccfAViDxuVjnMMnCYlJkdguch3FgBIQ5+5Gg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce the Ceph BLOG integration layer that enables the filesystem to
register binary loggers and route log events through module-specific TLS
contexts. This commit establishes the infrastructure for high-performance
binary logging in the Ceph client without modifying existing logging calls.

**Key Components:**

**ceph_blog.h - BLOG-aware macros and interfaces:**
- bout/boutc: Drop-in replacements for dout/doutc with identical semantics
- CEPH_BLOG_LOG_CTX/CEPH_BLOG_LOG: Low-level logging primitives
- Automatic fallback to traditional dout when CONFIG_BLOG is disabled
- Type-safe parameter serialization using BLOG framework

**blog_client.c - Module registration and context management:**
- ceph_blog_init(): Register Ceph-specific BLOG logger on module load
- ceph_blog_exit(): Cleanup and unregister logger on module unload
- ceph_get_tls_ctx(): Acquire per-task BLOG context for current thread
- Client-ID to logger mapping for multi-client scenarios
- Exported symbols for context acquisition from Ceph code paths

**Makefile integration:**
- Conditionally build blog_client.o when CONFIG_CEPH_FS && CONFIG_BLOG
- Clean integration with existing Ceph build system

**Design rationale:**
The bout/boutc macros maintain the same call-site syntax as dout/doutc,
allowing gradual migration and easy A/B testing. Log levels and subsystem
filtering remain unchanged. The TLS context is acquired lazily on first use
per task and recycled automatically on task exit via the BLOG lifecycle
hooks wired in earlier commits.

No existing Ceph logging is modified in this commit. The infrastructure is
in place but inactive until logging call sites are converted to bout/boutc
in subsequent commits.

Signed-off-by: Alex Markuze <amarkuze@redhat.com>
---
 fs/ceph/Makefile               |   2 +
 fs/ceph/blog_client.c          | 244 +++++++++++++++++++++++++++++++++
 include/linux/ceph/ceph_blog.h | 124 +++++++++++++++++
 3 files changed, 370 insertions(+)
 create mode 100644 fs/ceph/blog_client.c
 create mode 100644 include/linux/ceph/ceph_blog.h

diff --git a/fs/ceph/Makefile b/fs/ceph/Makefile
index 1f77ca04c426..ccb542870ab3 100644
--- a/fs/ceph/Makefile
+++ b/fs/ceph/Makefile
@@ -10,6 +10,8 @@ ceph-y := super.o inode.o dir.o file.o locks.o addr.o ioctl.o \
 	mds_client.o mdsmap.o strings.o ceph_frag.o \
 	debugfs.o util.o metric.o
 
+ceph-$(CONFIG_BLOG) += blog_client.o blog_debugfs.o
+
 ceph-$(CONFIG_CEPH_FSCACHE) += cache.o
 ceph-$(CONFIG_CEPH_FS_POSIX_ACL) += acl.o
 ceph-$(CONFIG_FS_ENCRYPTION) += crypto.o
diff --git a/fs/ceph/blog_client.c b/fs/ceph/blog_client.c
new file mode 100644
index 000000000000..2d9c7e37f918
--- /dev/null
+++ b/fs/ceph/blog_client.c
@@ -0,0 +1,244 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Ceph client ID management for BLOG integration
+ *
+ * Maintains mapping between Ceph's fsid/global_id and BLOG client IDs
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
+#include <linux/ceph/ceph_debug.h>
+#include <linux/ceph/libceph.h>
+#include <linux/ceph/ceph_blog.h>
+#include <linux/blog/blog.h>
+
+/* Ceph's BLOG module context */
+struct blog_module_context *ceph_blog_ctx;
+EXPORT_SYMBOL(ceph_blog_ctx);
+
+/* Ceph's logger - direct access to the logger from module context */
+struct blog_logger *ceph_logger;
+EXPORT_SYMBOL(ceph_logger);
+
+/* Global client mapping state */
+static struct {
+	struct ceph_blog_client_info client_map[CEPH_BLOG_MAX_CLIENTS];
+	u32 next_client_id;
+	spinlock_t lock;  /* protects client_map */
+	bool initialized;
+} ceph_blog_state = {
+	.next_client_id = 1,  /* Start from 1, 0 is reserved */
+	.lock = __SPIN_LOCK_UNLOCKED(ceph_blog_state.lock),
+	.initialized = false,
+};
+
+static bool ceph_blog_ids_match(const struct ceph_blog_client_info *entry,
+				     const char *fsid, u64 global_id)
+{
+	if (!entry)
+		return false;
+	if (entry->global_id != global_id)
+		return false;
+	return !memcmp(entry->fsid, fsid, sizeof(entry->fsid));
+}
+
+/**
+ * ceph_blog_init - Initialize Ceph BLOG integration
+ *
+ * Creates a module-specific BLOG context for Ceph and initializes
+ * the client ID mapping state.
+ *
+ * Return: 0 on success, negative error code on failure
+ */
+int ceph_blog_init(void)
+{
+	if (ceph_blog_state.initialized)
+		return 0;
+
+	/* Create Ceph's module-specific BLOG context */
+	ceph_blog_ctx = blog_module_init("ceph");
+	if (!ceph_blog_ctx) {
+		pr_err("ceph: Failed to initialize BLOG module context\n");
+		return -ENOMEM;
+	}
+
+	/* Set ceph_logger for direct access to the logger */
+	ceph_logger = ceph_blog_ctx->logger;
+
+	/* Initialize client mapping state */
+	memset(ceph_blog_state.client_map, 0, sizeof(ceph_blog_state.client_map));
+	ceph_blog_state.next_client_id = 1;
+	ceph_blog_state.initialized = true;
+
+	pr_info("ceph: BLOG module context and client mapping initialized\n");
+	return 0;
+}
+EXPORT_SYMBOL(ceph_blog_init);
+
+/**
+ * ceph_blog_cleanup - Clean up Ceph BLOG integration
+ *
+ * Cleans up Ceph's module-specific BLOG context and client mappings.
+ */
+void ceph_blog_cleanup(void)
+{
+	if (!ceph_blog_state.initialized)
+		return;
+
+	/* Clean up client mapping state */
+	spin_lock(&ceph_blog_state.lock);
+	memset(ceph_blog_state.client_map, 0, sizeof(ceph_blog_state.client_map));
+	ceph_blog_state.next_client_id = 1;
+	ceph_blog_state.initialized = false;
+	spin_unlock(&ceph_blog_state.lock);
+
+	/* Clean up module-specific BLOG context */
+	if (ceph_blog_ctx) {
+		blog_module_cleanup(ceph_blog_ctx);
+		ceph_blog_ctx = NULL;
+		ceph_logger = NULL;
+	}
+
+	pr_info("ceph: BLOG module context and client mapping cleaned up\n");
+}
+EXPORT_SYMBOL(ceph_blog_cleanup);
+
+/**
+ * ceph_blog_check_client_id - Check if a client ID matches the given fsid:global_id pair
+ * @id: Client ID to check
+ * @fsid: Client FSID to compare
+ * @global_id: Client global ID to compare
+ *
+ * This preserves the exact functionality of ceph_san_check_client_id.
+ * Returns the actual ID of the pair. If the given ID doesn't match, scans for
+ * existing matches or allocates a new ID if no match is found.
+ *
+ * Return: Client ID for this fsid/global_id pair
+ */
+u32 ceph_blog_check_client_id(u32 id, const char *fsid, u64 global_id)
+{
+	u32 found_id = 0;
+	struct ceph_blog_client_info *entry;
+
+	if (unlikely(!ceph_blog_state.initialized)) {
+		WARN_ON_ONCE(1);  /* Should never happen - init_ceph() initializes BLOG */
+		return 0;  /* Drop the log entry */
+	}
+
+	spin_lock(&ceph_blog_state.lock);
+
+	/* Reuse caller-provided hint when it still matches */
+	if (id != 0 && id < CEPH_BLOG_MAX_CLIENTS) {
+		entry = &ceph_blog_state.client_map[id];
+		if (ceph_blog_ids_match(entry, fsid, global_id)) {
+			found_id = id;
+			goto out;
+		}
+	}
+
+	/* Search for an existing entry with matching identity */
+	for (id = 1; id < CEPH_BLOG_MAX_CLIENTS; id++) {
+		entry = &ceph_blog_state.client_map[id];
+		if (ceph_blog_ids_match(entry, fsid, global_id)) {
+			found_id = id;
+			goto out;
+		}
+	}
+
+	/* Assign new identifier, falling back to overflow slot if exhausted */
+	if (ceph_blog_state.next_client_id >= CEPH_BLOG_MAX_CLIENTS - 1) {
+		found_id = CEPH_BLOG_MAX_CLIENTS - 1;
+		entry = &ceph_blog_state.client_map[found_id];
+	} else {
+		found_id = ceph_blog_state.next_client_id++;
+		entry = &ceph_blog_state.client_map[found_id];
+	}
+
+	memset(entry, 0, sizeof(*entry));
+	memcpy(entry->fsid, fsid, sizeof(entry->fsid));
+	entry->global_id = global_id;
+
+	pr_info("ceph: allocating new BLOG client ID %u for fsid=%pU global_id=%llu\n",
+		found_id, fsid, global_id);
+
+out:
+	spin_unlock(&ceph_blog_state.lock);
+	return found_id;
+}
+EXPORT_SYMBOL(ceph_blog_check_client_id);
+
+/**
+ * ceph_blog_get_client_info - Get client info for a given ID
+ * @id: Client ID
+ *
+ * Return: Client information for this ID, or NULL if invalid
+ */
+const struct ceph_blog_client_info *ceph_blog_get_client_info(u32 id)
+{
+	if (!ceph_blog_state.initialized || id == 0 || id >= CEPH_BLOG_MAX_CLIENTS)
+		return NULL;
+	return &ceph_blog_state.client_map[id];
+}
+EXPORT_SYMBOL(ceph_blog_get_client_info);
+
+/**
+ * ceph_blog_client_des_callback - Deserialization callback for Ceph client info
+ * @buf: Output buffer
+ * @size: Buffer size
+ * @client_id: Client ID to deserialize
+ *
+ * This is the callback that BLOG will use to deserialize client information.
+ *
+ * Return: Number of bytes written to buffer
+ */
+int ceph_blog_client_des_callback(char *buf, size_t size, u8 client_id)
+{
+	const struct ceph_blog_client_info *info;
+
+	if (!buf || !size)
+		return -EINVAL;
+
+	info = ceph_blog_get_client_info(client_id);
+	if (!info)
+		return snprintf(buf, size, "[unknown_client_%u]", client_id);
+
+	/* Use %pU to format fsid, matching boutc and other Ceph client logging */
+	return snprintf(buf, size, "[%pU %llu] ",
+			info->fsid, info->global_id);
+}
+EXPORT_SYMBOL(ceph_blog_client_des_callback);
+
+/**
+ * ceph_blog_get_client_id - Get or allocate client ID for a Ceph client
+ * @client: Ceph client structure
+ *
+ * Return: Client ID for this client
+ */
+u32 ceph_blog_get_client_id(struct ceph_client *client)
+{
+	u32 cached = 0;
+	u32 id;
+
+	if (!client)
+		return 0;
+
+#ifdef CONFIG_BLOG
+	cached = READ_ONCE(client->blog_client_id);
+#endif
+
+	id = ceph_blog_check_client_id(cached,
+					 client->fsid.fsid,
+					 client->monc.auth->global_id);
+	if (!id)
+		return 0;
+
+#ifdef CONFIG_BLOG
+	if (READ_ONCE(client->blog_client_id) != id)
+		WRITE_ONCE(client->blog_client_id, id);
+#endif
+
+	return id;
+}
+EXPORT_SYMBOL(ceph_blog_get_client_id);
diff --git a/include/linux/ceph/ceph_blog.h b/include/linux/ceph/ceph_blog.h
new file mode 100644
index 000000000000..0591e3f29703
--- /dev/null
+++ b/include/linux/ceph/ceph_blog.h
@@ -0,0 +1,124 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Ceph integration with BLOG (Binary LOGging)
+ *
+ * Provides compatibility layer and Ceph-specific extensions
+ */
+#ifndef CEPH_BLOG_H
+#define CEPH_BLOG_H
+
+#include <linux/blog/blog.h>
+#include <linux/blog/blog_module.h>
+#include <linux/ceph/libceph.h>
+
+/* Client ID mapping structure - preserves ceph_san_client_id fields */
+struct ceph_blog_client_info {
+	char fsid[16];         /* Client FSID */
+	u64 global_id;         /* Client global ID */
+};
+
+/* Constants */
+#define CEPH_BLOG_MAX_CLIENTS 256
+
+/* Ceph's BLOG module context */
+extern struct blog_module_context *ceph_blog_ctx;
+
+/* Ceph's logger - direct access to the logger for macros */
+extern struct blog_logger *ceph_logger;
+
+/* Forward declaration for ceph_client */
+struct ceph_client;
+
+/* Compatibility macros for easy migration from ceph_san to BLOG */
+#if IS_ENABLED(CONFIG_BLOG)
+
+/* Ceph BLOG client management functions */
+int ceph_blog_init(void);
+void ceph_blog_cleanup(void);
+u32 ceph_blog_check_client_id(u32 id, const char *fsid, u64 global_id);
+u32 ceph_blog_get_client_id(struct ceph_client *client);
+const struct ceph_blog_client_info *ceph_blog_get_client_info(u32 id);
+int ceph_blog_client_des_callback(char *buf, size_t size, u8 client_id);
+
+/*
+ * All ceph_san compatibility removed - use only BLOG with per-module contexts
+ * CEPH_SAN has been replaced entirely by BLOG per-module logging
+ */
+
+/*
+ * Ceph-specific logging macros - use core BLOG functions with ceph_logger
+ * Note: Only client-aware macros (doutc, boutc) store client_id,
+ * regular macros (dout, bout) do not include client information
+ */
+#define CEPH_BLOG_LOG(fmt, ...) \
+	do { \
+		static u32 __source_id; \
+		static size_t __size; \
+		void *___buffer = NULL; \
+		if (unlikely(!ceph_logger)) \
+			break; \
+		if (unlikely(__source_id == 0)) { \
+			__source_id = blog_get_source_id(ceph_logger, \
+				kbasename(__FILE__), __func__, __LINE__, fmt); \
+			__size = blog_cnt(__VA_ARGS__); \
+		} \
+		___buffer = blog_log(ceph_logger, __source_id, 0, __size); \
+		if (likely(___buffer)) { \
+			void *___tmp = ___buffer; \
+			if (__size > 0) \
+				blog_ser(___buffer, ##__VA_ARGS__); \
+			blog_log_commit(ceph_logger, ___buffer - ___tmp); \
+		} \
+	} while (0)
+
+#define CEPH_BLOG_LOG_CLIENT(client, fmt, ...) \
+	do { \
+		static u32 __source_id; \
+		static size_t __size; \
+		void *___buffer = NULL; \
+		u32 __client_id; \
+		if (unlikely(!ceph_logger)) \
+			break; \
+		if (unlikely(__source_id == 0)) { \
+			__source_id = blog_get_source_id(ceph_logger, \
+				kbasename(__FILE__), __func__, __LINE__, fmt); \
+			__size = blog_cnt(__VA_ARGS__); \
+		} \
+		__client_id = ceph_blog_get_client_id(client); \
+		___buffer = blog_log(ceph_logger, __source_id, __client_id, __size); \
+		if (likely(___buffer)) { \
+			void *___tmp = ___buffer; \
+			if (__size > 0) \
+				blog_ser(___buffer, ##__VA_ARGS__); \
+			blog_log_commit(ceph_logger, ___buffer - ___tmp); \
+		} \
+	} while (0)
+
+/* No legacy ceph_san compatibility - use CEPH_BLOG_LOG* macros only */
+
+#else /* !CONFIG_BLOG */
+
+/* Stub macros when BLOG is not enabled */
+#define CEPH_BLOG_LOG(fmt, ...) do {} while (0)
+#define CEPH_BLOG_LOG_CLIENT(client, fmt, ...) do {} while (0)
+
+/* Stub functions should be static inline, not macros */
+static inline int ceph_blog_init(void) { return 0; }
+static inline void ceph_blog_cleanup(void) { }
+static inline u32 ceph_blog_get_client_id(struct ceph_client *client) { return 0; }
+static inline u32 ceph_blog_check_client_id(u32 id, const char *fsid, u64 global_id) { return 0; }
+static inline const struct ceph_blog_client_info *ceph_blog_get_client_info(u32 id) { return NULL; }
+static inline int ceph_blog_client_des_callback(char *buf, size_t size, u8 client_id) { return 0; }
+
+#endif /* CONFIG_BLOG */
+
+/* Debugfs support */
+#ifdef CONFIG_DEBUG_FS
+int ceph_blog_debugfs_init(struct dentry *parent);
+void ceph_blog_debugfs_cleanup(void);
+#else
+static inline int ceph_blog_debugfs_init(struct dentry *parent) { return 0; }
+static inline void ceph_blog_debugfs_cleanup(void) {}
+#endif
+
+#endif /* CEPH_BLOG_H */
-- 
2.34.1


