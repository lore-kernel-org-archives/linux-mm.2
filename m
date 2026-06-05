Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A00F4CD8C81
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 23:37:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA7596B008A; Fri,  5 Jun 2026 19:36:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C57416B008C; Fri,  5 Jun 2026 19:36:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B23386B0092; Fri,  5 Jun 2026 19:36:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B7FE6B008A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 19:36:59 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5A4081A02EB
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 23:36:59 +0000 (UTC)
X-FDA: 84847471758.17.12B903D
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf05.hostedemail.com (Postfix) with ESMTP id 92849100015
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 23:36:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BFZN1nTE;
	spf=pass (imf05.hostedemail.com: domain of 3mF0jag0KCDkVWcdncZfWVkVobjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--abhishekbapat.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3mF0jag0KCDkVWcdncZfWVkVobjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780702617;
	b=5SpXc3X8Y/WwBrkaIlA3v8RiWtpXcPOwB6nIFkgc3PCLek3ub+8V9Z0iIjkbkw57cAGYHN
	WapYkahO6vd3Wekzx4f8jqRLBDwAM0+9cm47NlwUMfo+OCSCLIFRYCXC4XhLpGk3yeW4jC
	2NXA2dBai2fnXt8hlcj/Xekf5vAVxQo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BFZN1nTE;
	spf=pass (imf05.hostedemail.com: domain of 3mF0jag0KCDkVWcdncZfWVkVobjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--abhishekbapat.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3mF0jag0KCDkVWcdncZfWVkVobjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780702617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DkqVffYh6nrcGAjKl2Ew9k2LxbC2nGZuNzPcyrtCv9k=;
	b=PzW1+YfX3EdAkrJBa60QnFhQIZL/N4PrLwUw3Q8B0V/Vi1927Ji7QGsOoRCZlxfshX+9RO
	3tT9qU4vH2MPToGovSFT+7hrQ63SeL1CokNT8a8ZL2tcUFI8pE72VT3MBAtRW/9fJqlZNV
	71V/TyO7BgHvAL2FKnBMP+FMq6uwy6w=
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-304b8d0ee63so3293362eec.0
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 16:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780702616; x=1781307416; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DkqVffYh6nrcGAjKl2Ew9k2LxbC2nGZuNzPcyrtCv9k=;
        b=BFZN1nTETR4AYkiSVencPbS8IEa/T19HxC7DvycFpVzVWb+gbF/nBAXIeNjTVHUAF6
         w10rS2FocmJSih2Z3dPq3aEGTNm7uKJUkP17/L8ulj6yq8Q4xI2Bgk2a6+NRnEcj4orI
         lZkAtNEQpqWhdNCWJ+XPGoRn+CLHtCaB/5CLSD0iJ36GwKUyhMzUp08VfYVUIGywk/Sy
         cjCrGy39bmenLSaBfe7mAvEjiqKvQzbyU+AyNGP1tRjf7j9MsTi+nqIBRzNyJdfNwZlc
         iK6e3SvfqYkWw37PGLlq6RCP/VoWgvwpuPxVI1dS9+hs0CSI61/1Q3Lk/Oc7c4Q3+vHR
         jTBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780702616; x=1781307416;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DkqVffYh6nrcGAjKl2Ew9k2LxbC2nGZuNzPcyrtCv9k=;
        b=h01rl9MTEu0LnuBv9cqJN2QruvoeS+9TShq/dfTXCTiZ8KOkifogtArrtL5lAgNlLL
         Ll/dXLQ14vAafq0VBgjVkYyRn39qBJtcVaHzsuhdfOblyHoRN3Q1NfrHYMOPzsEKSYgS
         +KWclr4p2f6EgEquKwq/oPXV/yPpxFaeGxtSl6LK2jgohaWwyt7/2suIvp3J6C2b5p+A
         YE7gSBtNA3zOrrobMKMM7blaA4EN3ZU0gyJJbqm7IokKyF1vx2xCLhV/hzCtJAaOMBLn
         07t0hp9QqYd7dPdVm7WlPVEPbpySuuPRvu8IOjyWoSIMs2Y3OPcritlvW6f8ENdk81Ii
         2pjA==
X-Forwarded-Encrypted: i=1; AFNElJ8nRB0nFmagyIvhT93oGCUv/EPsSroDMOvPVtCCXuiwj0SRgevmSWxwqvgcEZU3nKMepbhFGBlTJQ==@kvack.org
X-Gm-Message-State: AOJu0YzIyvgrHYwedDDeEXrAExWXmkIqSVKWblh8qWuw1O1rB6YA1HvW
	1ApeIFQBo/jviAYTiSoIJ+ylaCNib36/PK0y1lPYcZqjlZtkKCLMyRFkbxn6Eo0BNNcVGis30tu
	oYjvpHmKxZaY3EmF/NeTtdR/lrSJN+I2KHA==
X-Received: from dyah11-n1.prod.google.com ([2002:a05:693c:83cb:10b0:304:e502:fe2d])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:230b:b0:304:dd1c:737e with SMTP id 5a478bee46e88-3077b22a7abmr3337554eec.16.1780702616096;
 Fri, 05 Jun 2026 16:36:56 -0700 (PDT)
Date: Fri,  5 Jun 2026 23:36:46 +0000
In-Reply-To: <cover.1780701922.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1780701922.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
Message-ID: <0e91fdd3a88dbe5220d15c4c8ff7b8f66e86af7c.1780701922.git.abhishekbapat@google.com>
Subject: [PATCH v3 1/6] alloc_tag: add ioctl to /proc/allocinfo
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 92849100015
X-Stat-Signature: tw54ien1so3mf8ai8hswh3aqu7so4eh7
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780702617-291388
X-HE-Meta: U2FsdGVkX1/3QrKmblmsT0X7l88iH23jQ2Ax+k0tUSkn7GDqyHu9KsCluI46J4VEsidPK5zo3o1H7dIfCOfn54VHj6pESgaQkwG6I2WhVhEvP8Vc7J1OkvJ7nbYRryotI8lSivYedjwk9+jumI+mY9m0udK/rk5OGtI9ys6DzCKyMLrAkKMpRki/hvVZ9k9u7UUG4YEEspygIycJHQpEM4YQ8yufXazN0Dko2shk6DlfGdTCGVODICFtBAFh66bg10cZLnlXTES+S1Ut7KOfRBlBXTM+0sPvsUaYoScpAa7LCkgxnlKP/4mb9rurn9W2QIg1FPRSesdAlbQWNzj+peRkh9iJVyvLQXPeuE3JbgScNXWehkXI9qJZDDCiLV4FEp6yD20L37aSMaX6ZUVuYXJBFQnuEH9PL3HyBMO1BkOpkePMp5nw/qWjk/OGgGIkmVgA8D01VYEmpJK9gwK45jTro5dtEcH/gwu2c8dTHvTStbfW+Sn/GpLblIVjdAq+u1JjL5BYyLpD1zKAT3nR+5+7q7ok0qsEe7okmV9PKzi8q/aNQslw8Pr/K56aUB9acPYQAPyVBhS0sYBRKHgmH59NmaKQgyYNK1UGSZoc9zOIceOw/zHwMaumBg2vbYGZrhfALAiI54jIP/9DgSbnRGTyLIsYln/5PWLiK9W5kXXn1n4z8YyaviYZm6vH44GbJqpjRf+tTg7aofOlpjf/rUpUjObDDhnqJ9tsWOhwhG0LAPLhUCWshXaAcq5g05rNpmJ4p53YFuGy6ejjWnOiy7MQJDmp3JldkrgT8jQSdGYUZK2L9VoUVp12a5cfdYUKNqmVj6sEM1ldwIoDCyrEz8QUrLCNYb0+PyT63AONYSUEtsKSszDTLrk1f/OPuVka3zAOqN5sdJK64ZMmeX9pcnw9OObLBFa8ztJnsUqf/xX9m0sgsWbfuDbPRcvn2G8sCT42u4qCooNwlz/tSug
 bDtQO6BV
 XPlIAex/tyjN2sUHKop/des55TJFgS6+zm3aC9FtJUaaT6EnQ+B3Qte8AAfGeoy+A1PJxD330lL3PdWeJ7I2CamRDOnpmoMnyfcrP+2dR2rFhRIsj8kCxxczdxrcuqBe+oTpLwUlKao6PS43NtlLO/3KCnmzHmnII5a5yZ6a8TeoSz0w9ePnj6SspGEcumItVzwroHZT3E9dDtrlW9BTGW3RMopdcoREtC4vA2vcdqJfg5UoVl6jCLqFzY1+2Ciy0TN/S64O2VLkMN39uhOSo99sYvLl2I1t9VFGkGTUGBuhIaI8xzMMYS1wwIxPrsKSe/eGxnRNM0svNjPtIITWEM53W3SnwKam8bgUP/SHAO3rCEvSagr5YxTG0zsUfIcbTDqeZCNJQVEasyqNIcmCEZpjPblWWr1Sml9rJLPRUm5nCAuHZEX1ZqC30fM4Gw4n+Oe6uP2Ud+Myvu2HX6Sn8wVBgJu/LF8OjK+fLKcqat4zUHFl7NKPJfiR2VhFSfmRdYEwd1T9IR1ljZN735fO5TDDFy/LAQq97Pig0Sn+hy4QJpW/toBoXO10AoCfYcKkzPBMOMKPGN6bzAsZYjwaygEaZigPBNFbWd+8sH5ACTCJAuYnel8GkuljE4JEBPFwKsHbHUndE0qjR2dmn1oFonXS+TNg9KsrC0PUe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Suren Baghdasaryan <surenb@google.com>

Add the following ioctl commands for /proc/allocinfo file:

ALLOCINFO_IOC_CONTENT_ID - gets content identifier which can be used
to check whether the file content has changed specifically due to module
load/unload. Every time a module is loaded / unloaded, the returned
value will be different. By comparing the identifier value at the
beginning and at the end of the content retrieval operation, users can
validate retrieved information for consistency.

ALLOCINFO_IOC_GET_AT - gets the record at the specified position. This
is the position of a record in /proc/allocinfo.

ALLOCINFO_IOC_GET_NEXT - gets the record next to the last retrieved
one. If no records were previously retrieved, returns the first
record.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
---
 Documentation/mm/allocation-profiling.rst     |   5 +
 .../userspace-api/ioctl/ioctl-number.rst      |   2 +
 MAINTAINERS                                   |   1 +
 include/linux/codetag.h                       |   2 +
 include/uapi/linux/alloc_tag.h                |  54 ++++
 lib/alloc_tag.c                               | 232 +++++++++++++++++-
 lib/codetag.c                                 |  18 ++
 7 files changed, 312 insertions(+), 2 deletions(-)
 create mode 100644 include/uapi/linux/alloc_tag.h

diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/mm/allocation-profiling.rst
index 5389d241176a..c3a28467955f 100644
--- a/Documentation/mm/allocation-profiling.rst
+++ b/Documentation/mm/allocation-profiling.rst
@@ -46,6 +46,11 @@ sysctl:
 Runtime info:
   /proc/allocinfo
 
+  Profiling data can be retrieved either by reading `/proc/allocinfo` directly as
+  text or programmatically via `ioctl()` calls defined in `<uapi/linux/alloc_tag.h>`.
+  The ioctl interface supports structured binary data extraction as well as filtering
+  by module name, function, file, line number, accuracy, or allocation size limits.
+
 Example output::
 
   root@moria-kvm:~# sort -g /proc/allocinfo|tail|numfmt --to=iec
diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
index 331223761fff..84f6808a8578 100644
--- a/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -349,6 +349,8 @@ Code  Seq#    Include File                                             Comments
                                                                        <mailto:luzmaximilian@gmail.com>
 0xA5  20-2F  linux/surface_aggregator/dtx.h                            Microsoft Surface DTX driver
                                                                        <mailto:luzmaximilian@gmail.com>
+0xA6  00-0F  uapi/linux/alloc_tag.h                                    Memory allocation profiling
+                                                                       <mailto:surenb@google.com>
 0xAA  00-3F  linux/uapi/linux/userfaultfd.h
 0xAB  00-1F  linux/nbd.h
 0xAC  00-1F  linux/raw.h
diff --git a/MAINTAINERS b/MAINTAINERS
index a31f6f207afd..77f3fc487691 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16711,6 +16711,7 @@ S:	Maintained
 F:	Documentation/mm/allocation-profiling.rst
 F:	include/linux/alloc_tag.h
 F:	include/linux/pgalloc_tag.h
+F:	include/uapi/linux/alloc_tag.h
 F:	lib/alloc_tag.c
 
 MEMORY CONTROLLER DRIVERS
diff --git a/include/linux/codetag.h b/include/linux/codetag.h
index ddae7484ca45..a25a085c2df1 100644
--- a/include/linux/codetag.h
+++ b/include/linux/codetag.h
@@ -77,6 +77,8 @@ struct codetag_iterator {
 void codetag_lock_module_list(struct codetag_type *cttype);
 bool codetag_trylock_module_list(struct codetag_type *cttype);
 void codetag_unlock_module_list(struct codetag_type *cttype);
+unsigned long codetag_get_content_id(struct codetag_type *cttype);
+unsigned int codetag_get_count(struct codetag_type *cttype);
 struct codetag_iterator codetag_get_ct_iter(struct codetag_type *cttype);
 struct codetag *codetag_next_ct(struct codetag_iterator *iter);
 
diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
new file mode 100644
index 000000000000..901199bad514
--- /dev/null
+++ b/include/uapi/linux/alloc_tag.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ *  include/linux/alloc_tag.h
+ */
+
+#ifndef _UAPI_ALLOC_TAG_H
+#define _UAPI_ALLOC_TAG_H
+
+#include <linux/types.h>
+
+#define ALLOCINFO_STR_SIZE	64
+
+struct allocinfo_content_id {
+	__u64 id;
+};
+
+struct allocinfo_tag {
+	/* Longer names are trimmed */
+	char modname[ALLOCINFO_STR_SIZE];
+	char function[ALLOCINFO_STR_SIZE];
+	char filename[ALLOCINFO_STR_SIZE];
+	__u64 lineno;
+};
+
+/* The alignment ensures 32-bit compatible interfaces are not broken */
+struct allocinfo_counter {
+	__u64 bytes;
+	__u64 calls;
+	__u8 accurate;
+} __attribute__((aligned(8)));
+
+struct allocinfo_tag_data {
+	struct allocinfo_tag tag;
+	struct allocinfo_counter counter;
+};
+
+struct allocinfo_get_at {
+	__u64 pos;	/* input */
+	struct allocinfo_tag_data data;
+};
+
+#define _ALLOCINFO_IOC_CONTENT_ID	0
+#define _ALLOCINFO_IOC_GET_AT		1
+#define _ALLOCINFO_IOC_GET_NEXT		2
+
+#define ALLOCINFO_IOC_BASE		0xA6
+#define ALLOCINFO_IOC_CONTENT_ID	_IOR(ALLOCINFO_IOC_BASE, _ALLOCINFO_IOC_CONTENT_ID,	\
+					     struct allocinfo_content_id)
+#define ALLOCINFO_IOC_GET_AT		_IOWR(ALLOCINFO_IOC_BASE, _ALLOCINFO_IOC_GET_AT,	\
+					      struct allocinfo_get_at)
+#define ALLOCINFO_IOC_GET_NEXT		_IOR(ALLOCINFO_IOC_BASE, _ALLOCINFO_IOC_GET_NEXT,	\
+					     struct allocinfo_tag_data)
+
+#endif /* _UAPI_ALLOC_TAG_H */
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index d9be1cf5187d..a0577215eb3d 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -5,6 +5,7 @@
 #include <linux/gfp.h>
 #include <linux/kallsyms.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/page_ext.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/proc_fs.h>
@@ -14,6 +15,7 @@
 #include <linux/string_choices.h>
 #include <linux/vmalloc.h>
 #include <linux/kmemleak.h>
+#include <uapi/linux/alloc_tag.h>
 
 #define ALLOCINFO_FILE_NAME		"allocinfo"
 #define MODULE_ALLOC_TAG_VMAP_SIZE	(100000UL * sizeof(struct alloc_tag))
@@ -47,6 +49,10 @@ struct allocinfo_private {
 	struct codetag_iterator iter;
 	struct codetag_iterator reported_iter;
 	bool print_header;
+	/* ioctl uses a separate iterator not to interfere with reads */
+	struct codetag_iterator ioctl_iter;
+	bool positioned; /* seq_open_private() sets to 0 */
+	struct mutex ioctl_lock;
 };
 
 static void *allocinfo_start(struct seq_file *m, loff_t *pos)
@@ -130,6 +136,229 @@ static const struct seq_operations allocinfo_seq_op = {
 	.show	= allocinfo_show,
 };
 
+/*
+ * Initializes seq_file operations and allocates private state when opening
+ * the /proc/allocinfo procfs entry.
+ */
+static int allocinfo_open(struct inode *inode, struct file *file)
+{
+	int ret;
+
+	ret = seq_open_private(file, &allocinfo_seq_op,
+			       sizeof(struct allocinfo_private));
+	if (!ret) {
+		struct seq_file *m = file->private_data;
+		struct allocinfo_private *priv = m->private;
+
+		mutex_init(&priv->ioctl_lock);
+	}
+	return ret;
+}
+
+/*
+ * Cleans up the seq_file state and frees up the private state allocated in
+ * allocinfo_open() when closing the /proc/allocinfo file descriptor.
+ */
+static int allocinfo_release(struct inode *inode, struct file *file)
+{
+	return seq_release_private(inode, file);
+}
+
+/*
+ * Returns a pointer to the suffix of a string so that its length fits within
+ * ALLOCINFO_STR_SIZE, preserving the trailing characters.
+ */
+static const char *allocinfo_str(const char *str)
+{
+	size_t len = strlen(str);
+
+	/* Keep an extra space for the trailing NULL. */
+	if (len >= ALLOCINFO_STR_SIZE)
+		str += (len - ALLOCINFO_STR_SIZE) + 1;
+	return str;
+}
+
+/* Copy a string and trim from the beginning if it's too long */
+static void allocinfo_copy_str(char *dest, const char *src)
+{
+	strscpy_pad(dest, allocinfo_str(src), ALLOCINFO_STR_SIZE);
+}
+
+/*
+ * Populates the UAPI allocinfo_tag_data structure with active runtime
+ * profiling counters extracted from the given kernel codetag.
+ */
+static void allocinfo_to_params(struct codetag *ct,
+				struct allocinfo_tag_data *data)
+{
+	struct alloc_tag *tag = ct_to_alloc_tag(ct);
+	struct alloc_tag_counters counter = alloc_tag_read(tag);
+
+	if (ct->modname)
+		allocinfo_copy_str(data->tag.modname, ct->modname);
+	else
+		data->tag.modname[0] = '\0';
+	allocinfo_copy_str(data->tag.function, ct->function);
+	allocinfo_copy_str(data->tag.filename, ct->filename);
+	data->tag.lineno = ct->lineno;
+	data->counter.bytes = counter.bytes;
+	data->counter.calls = counter.calls;
+	data->counter.accurate = !alloc_tag_is_inaccurate(tag);
+}
+
+/*
+ * Retrieves the unique content ID representing the current allocation tag module
+ * layout, allowing userspace to detect if modules were loaded / unloaded.
+ */
+static int allocinfo_ioctl_get_content_id(struct seq_file *m, void __user *arg)
+{
+	struct allocinfo_content_id params;
+
+	codetag_lock_module_list(alloc_tag_cttype);
+	params.id = codetag_get_content_id(alloc_tag_cttype);
+	codetag_unlock_module_list(alloc_tag_cttype);
+	if (copy_to_user(arg, &params, sizeof(params)))
+		return -EFAULT;
+
+	return 0;
+}
+
+/*
+ * Seeks the ioctl iterator to the specified 0-indexed tag position, reads its
+ * profiling data and returns it to userspace.
+ */
+static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
+{
+	struct allocinfo_private *priv;
+	struct codetag *ct;
+	__u64 pos;
+	struct allocinfo_get_at params = {0};
+
+	if (copy_from_user(&params, arg, sizeof(params)))
+		return -EFAULT;
+
+	priv = m->private;
+	pos = params.pos;
+
+	mutex_lock(&priv->ioctl_lock);
+	codetag_lock_module_list(alloc_tag_cttype);
+
+	if (pos >= codetag_get_count(alloc_tag_cttype)) {
+		codetag_unlock_module_list(alloc_tag_cttype);
+		mutex_unlock(&priv->ioctl_lock);
+		return -ENOENT;
+	}
+
+	/* Find the codetag */
+	priv->ioctl_iter = codetag_get_ct_iter(alloc_tag_cttype);
+	ct = codetag_next_ct(&priv->ioctl_iter);
+	while (ct && pos--)
+		ct = codetag_next_ct(&priv->ioctl_iter);
+	if (ct) {
+		allocinfo_to_params(ct, &params.data);
+		priv->positioned = true;
+	}
+
+	codetag_unlock_module_list(alloc_tag_cttype);
+	mutex_unlock(&priv->ioctl_lock);
+
+	if (!ct)
+		return -ENOENT;
+
+	if (copy_to_user(arg, &params, sizeof(params)))
+		return -EFAULT;
+
+	return 0;
+}
+
+/*
+ * Advances the ioctl iterator to the next allocation tag in the sequence and
+ * returns its profiling data to userspace.
+ */
+static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
+{
+	struct allocinfo_private *priv;
+	struct codetag *ct;
+	struct allocinfo_tag_data params;
+	int ret = 0;
+
+	memset(&params, 0, sizeof(params));
+	priv = m->private;
+
+	mutex_lock(&priv->ioctl_lock);
+	codetag_lock_module_list(alloc_tag_cttype);
+
+	if (!priv->positioned) {
+		priv->ioctl_iter = codetag_get_ct_iter(alloc_tag_cttype);
+		priv->positioned = true;
+	}
+
+	ct = codetag_next_ct(&priv->ioctl_iter);
+	if (ct)
+		allocinfo_to_params(ct, &params);
+
+	if (!ct) {
+		priv->positioned = false;
+		ret = -ENOENT;
+	}
+	codetag_unlock_module_list(alloc_tag_cttype);
+	mutex_unlock(&priv->ioctl_lock);
+
+	if (ret == 0) {
+		if (copy_to_user(arg, &params, sizeof(params)))
+			return -EFAULT;
+	}
+	return ret;
+}
+
+/*
+ * Entry point ioctl function for /proc/allocinfo routing requests to fetch the
+ * layout content ID, seek to a specific tag, or read sequential tags.
+ */
+static long allocinfo_ioctl(struct file *file, unsigned int cmd,
+			    unsigned long __arg)
+{
+	void __user *arg = (void __user *)__arg;
+	int ret;
+
+	switch (cmd) {
+	case ALLOCINFO_IOC_CONTENT_ID:
+		ret = allocinfo_ioctl_get_content_id(file->private_data, arg);
+		break;
+	case ALLOCINFO_IOC_GET_AT:
+		ret = allocinfo_ioctl_get_at(file->private_data, arg);
+		break;
+	case ALLOCINFO_IOC_GET_NEXT:
+		ret = allocinfo_ioctl_get_next(file->private_data, arg);
+		break;
+	default:
+		ret = -ENOIOCTLCMD;
+		break;
+	}
+
+	return ret;
+}
+
+#ifdef CONFIG_COMPAT
+static long allocinfo_compat_ioctl(struct file *file, unsigned int cmd,
+				   unsigned long arg)
+{
+	return allocinfo_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
+}
+#endif
+
+static const struct proc_ops allocinfo_proc_ops = {
+	.proc_open		= allocinfo_open,
+	.proc_read_iter		= seq_read_iter,
+	.proc_lseek		= seq_lseek,
+	.proc_release		= allocinfo_release,
+	.proc_ioctl		= allocinfo_ioctl,
+#ifdef CONFIG_COMPAT
+	.proc_compat_ioctl	= allocinfo_compat_ioctl,
+#endif
+
+};
+
 size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t count, bool can_sleep)
 {
 	struct codetag_iterator iter;
@@ -993,8 +1222,7 @@ static int __init alloc_tag_init(void)
 		return 0;
 	}
 
-	if (!proc_create_seq_private(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_seq_op,
-				     sizeof(struct allocinfo_private), NULL)) {
+	if (!proc_create(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_proc_ops)) {
 		pr_err("Failed to create %s file\n", ALLOCINFO_FILE_NAME);
 		shutdown_mem_profiling(false);
 		return -ENOMEM;
diff --git a/lib/codetag.c b/lib/codetag.c
index 4001a7ea6675..a9cda4c962a3 100644
--- a/lib/codetag.c
+++ b/lib/codetag.c
@@ -19,6 +19,8 @@ struct codetag_type {
 	struct codetag_type_desc desc;
 	/* generates unique sequence number for module load */
 	unsigned long next_mod_seq;
+	/* bumped on every module load and unload */
+	unsigned long content_id;
 };
 
 struct codetag_range {
@@ -50,6 +52,20 @@ void codetag_unlock_module_list(struct codetag_type *cttype)
 	up_read(&cttype->mod_lock);
 }
 
+unsigned long codetag_get_content_id(struct codetag_type *cttype)
+{
+	lockdep_assert_held(&cttype->mod_lock);
+
+	return cttype->content_id;
+}
+
+unsigned int codetag_get_count(struct codetag_type *cttype)
+{
+	lockdep_assert_held(&cttype->mod_lock);
+
+	return cttype->count;
+}
+
 struct codetag_iterator codetag_get_ct_iter(struct codetag_type *cttype)
 {
 	struct codetag_iterator iter = {
@@ -204,6 +220,7 @@ static int codetag_module_init(struct codetag_type *cttype, struct module *mod)
 
 	down_write(&cttype->mod_lock);
 	cmod->mod_seq = ++cttype->next_mod_seq;
+	++cttype->content_id;
 	mod_id = idr_alloc(&cttype->mod_idr, cmod, 0, 0, GFP_KERNEL);
 	if (mod_id >= 0) {
 		if (cttype->desc.module_load) {
@@ -368,6 +385,7 @@ void codetag_unload_module(struct module *mod)
 			cttype->count -= range_size(cttype, &cmod->range);
 			idr_remove(&cttype->mod_idr, mod_id);
 			kfree(cmod);
+			++cttype->content_id;
 		}
 		up_write(&cttype->mod_lock);
 		if (found && cttype->desc.free_section_mem)
-- 
2.54.0.1032.g2f8565e1d1-goog


