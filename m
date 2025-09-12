Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEE24CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 15:09:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46D1B6B0023; Fri, 12 Sep 2025 11:09:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 444616B0024; Fri, 12 Sep 2025 11:09:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35B0D6B0026; Fri, 12 Sep 2025 11:09:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2491E6B0023
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:09:57 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C420F86304
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:09:56 +0000 (UTC)
X-FDA: 83880933192.09.DF24B18
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf03.hostedemail.com (Postfix) with ESMTP id E000A2000B
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:09:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=VifhawB0;
	spf=pass (imf03.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.176 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757689794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gzHigyy7wb6B4Qf5Kb9gVs2tyhtkzh8ngJUDwiJtOEQ=;
	b=Stfwey+wGwzBpvmRLwAZRYmzhtttKvwkl5X9jYqoMhnUMbPavWer1E0upvztFC4zRzFxNQ
	FAMPRnDnwfd9lCQG8L8tr8nqi65upby9b9FW26iP3F0wrcpHQYHsowKH80/Tre5RKxN05/
	QaXc7XelagYwfuQLDz7WI2IlyliF7KE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=VifhawB0;
	spf=pass (imf03.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.176 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757689794; a=rsa-sha256;
	cv=none;
	b=hUK4mbrBKdhRuYw3aYydYoZ43XUohhC16BcOncI1REniTi6VcyKOL7k3s1YhsYlCIhiJ7a
	L73EXGYEHRs30oWdoE+kidht3KEtcr9BvUhSiPxTGx2a9zIU3ogtxgDgPpUar8rmw/lzDB
	v1yStHiHvukuQjOuXS3N6Fp6rH/CwDQ=
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-723bc91d7bbso15933317b3.3
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757689794; x=1758294594; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gzHigyy7wb6B4Qf5Kb9gVs2tyhtkzh8ngJUDwiJtOEQ=;
        b=VifhawB069L+Hq364InVxrXzP0ibiefF3NZyp1kvvnwOi0KcTD7KNuqELjU+m5crPH
         Y5sIjQImBWb0xorDYBfaBc71mP42G1bKqUBNKHYdeWBTR61g48yeGOWoZzyBRYjLgX8o
         87SrZG5LtKSR2fUZ9KEd85umlkoSaleQ9U06Y7Mpv4IAY2214FnUpAq+Z9U6gf0LOeJd
         iA/jw0aUWrZ01OS0oBeWxpxODEdwdO+Q7uCmH24jvPZuy64AnHn4UPkn2gg08Y23BtXU
         EaMRYD51XfqZnpwJNkzhVY7kGgDvceqM1xH6GTI6mbearof56PsOAaNs7GygMkva0b/e
         NyTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757689794; x=1758294594;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gzHigyy7wb6B4Qf5Kb9gVs2tyhtkzh8ngJUDwiJtOEQ=;
        b=cbX6SfCNPiQ7ToD2JJLU1G6PEmD8OGIgVlSEjY6nLCEJEFrMqwCxV1DLGc0qhswlLf
         lDK0dH0sDSetIlDae/PZLXuTsfYS+OupcXt1G8vsoms3be/No6CmejTk2sU7oIpQMMxy
         ThJIqEbLyG5w8yCosu/clvvQzEs5C8fjMOGEG+XnQihAZ0WYoDH9rkOga6ZLdgaZyTYu
         9KwStXHnpl/aFi/FhXnSCHD7QWZ/Olfg36Vl6Vfv9l8UKLNFC5urialnB1tNAfPnRh9K
         DN/mhIsS8TbaGvgbkvGr22vG3rgjjGf4QV0YJV+C7kdpIYAOTAZzs2MDFktJYob0Tr4l
         GgWA==
X-Forwarded-Encrypted: i=1; AJvYcCUCaN0KdVKuKfr3nDP7f9yBWhmAqZVSFzoh3iJG0fqkP5ynW2O7n7UNDrQU7bh6dIzwD+Mm3j4XAA==@kvack.org
X-Gm-Message-State: AOJu0YwSGLkCivUwf8z0rjXlzWPCRSQ30m0ZYQi7qbjcJiMI1QSuqwDQ
	x3ACcxmZQ3ocZxGjMepvX1oyK0t2FM+J3/JX61lH++CTjaXKzFAGVJSBbY9ri7138MU=
X-Gm-Gg: ASbGncuDXrXIoQRLJ7AqtKr8bIMigUUEqBMIfF8PN3kSxkz/dHZ8sojuldX/sNm+w7T
	497SuUJVF7uFcK1WjozaP8fNBmc+NVwjlNHGnozJqcT4ECPrhwcMAGYM03htwaGBERUrVc14G8h
	fkBcYMAnJ4K24Xgq7vT1FKBHxRtRIMQDfu+BgDoBPy+PyF9aym3QN8WwVpBgRj3FDhENoD+V9Ib
	PYsb7DfVLcs6sQUjXBMzn1OyUPEIFWsZctaZVt5U73zs2KijU6a4zeqQG10haYdUSqqhftV7X2Y
	HqgNKKd4kKtEm7r4J6LxYkkROnVuGa8lPeCXY599yP8/gpqK15PZ7ZXIG566CFexsghE0DWyiJq
	o+iRKKxciVBnD1V51hR7DiX4iSHGhr9qWX7n6gOobUOnN
X-Google-Smtp-Source: AGHT+IE5YJnan3mhmVKTpnc/qVabMAWHQ4V7v9w5sLmYvHsMlgVVw6mvPzm8RfO76m/SQuXkiV/5wA==
X-Received: by 2002:a05:690c:c16:b0:729:f78b:4205 with SMTP id 00721157ae682-730652dc116mr32595427b3.36.1757689793641;
        Fri, 12 Sep 2025 08:09:53 -0700 (PDT)
Received: from eugen-station.. ([145.224.119.89])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-624841586c1sm1302244d50.6.2025.09.12.08.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 08:09:53 -0700 (PDT)
From: Eugen Hristev <eugen.hristev@linaro.org>
To: linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	tglx@linutronix.de,
	andersson@kernel.org,
	pmladek@suse.com,
	rdunlap@infradead.org,
	corbet@lwn.net,
	david@redhat.com,
	mhocko@suse.com
Cc: tudor.ambarus@linaro.org,
	mukesh.ojha@oss.qualcomm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	jonechou@google.com,
	rostedt@goodmis.org,
	linux-doc@vger.kernel.org,
	devicetree@vger.kernel.org,
	Eugen Hristev <eugen.hristev@linaro.org>
Subject: [RFC][PATCH v3 01/16] kmemdump: Introduce kmemdump
Date: Fri, 12 Sep 2025 18:08:40 +0300
Message-ID: <20250912150855.2901211-2-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912150855.2901211-1-eugen.hristev@linaro.org>
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E000A2000B
X-Stat-Signature: of7p4eib1n6e7757xu9jwaq461i9t7t5
X-HE-Tag: 1757689794-507009
X-HE-Meta: U2FsdGVkX19n9foi1izdabsLM9TB+eOraN6PJuFpAbNM+NIS7xwsj5neBZ9RIzUSLwyL55hB8j8p/eJcApSt/J9uGNE6GOeQlVBsU2LwDTID7kPc8cjw6KAdjLfvB3IR9jgZ8PrlJ/96TYiCZ5JnDo8qnQEc/b8u3V/cShb8UnKa3cq2i9o5HEiB6Rsl3m8m8T91Ks2Strw8vJuPSMS03YCjgZUE9oZMA/B8wOF+fHnFZNrQVn0p8SBv3H8OX6LxMSo1ShU8tCYoO+5jr807OKSJ51XCzRscT1heCMz/AOBhgtcBRXe/eqUrkeG/7wENzdS5O4SqYQudDXMzYJXB3DvsBbmfnTsZj/a6ZUCjVGh59yRVxiIkrYA8aPecVLNmMShSV1da7N7IVm2deldrpVrrfLXvFufRaoW71oAjV0Th0HpKDYBSMM3Zs9CNGghenD4ntRUkIWu3Iwyl1NWffYJUh6vaj0LIrliv9SSIMGossg+rwQxwiN4vO4gQ98V1SZS9GbR2HUwzU39BAe0glorMu74Tj3nPdoKTs+15D5IyDtnnp7002kKNBKU2fjYVkbUzCGIGsbz090SwPubcPdelotJdF4hRMhg4q0a0tmDMqagIlj8VSRXUX5H1WOYLg3e+lh3MDfH6qarZjO01Z3GcgG1SAemZBuCnsnbCuUlVHYVcj1+77qoHBSQpnajsyTOaSd5yiUE6YP+ktY8GK1bP0UgRQjnV0wi+7a2yMJt/dTULFMVmfVAGTRN0Okf6DrcPVmfddbf4AkItQfRCds/IZMgL6RO+0KqQeVgS1YwgdTUkeL7MxkFKsT4VfInvC9IrCKSHsYxHX9JCXpYoKuJz9UnuswwhjcCwRDZKFbcuxiWw2rTtKwq2aOJSsjXmcRYTQ7YkdxtP3dBtENXrYtijp1gUMHO0XCmjXxW0woDIdRpvlFuPKdI/BT9K8EGOMPP482jx+UAll+4bLsC
 U5NpVoFw
 tqnH0oMyegmNDQJ3yyzMYlof4eH4unZLceE3YVdOGjOWc6jz6Z4ikMuP9TmpDycLIQOiX40s64na99XHtqAWhB2vk/UaZRVwxYqt+MTfWi/PM17XZwISBJT2nWi1YLBtRPhXQIpr3XrIevD3UHXJb92vk0NCPQYNQQPaMrDDC/rUL/aT/PjCxkj7wRVAS9ERf+SzXRYTdEPe03xQE5LeHRLHMUPvlPauK4wFnmRKjGauv1LxxOhPXtpdPi4eoRnzACLx4y13C1qfNakThKeng0bDED20PtI6xGVfMCa+aESI5+5NGDja7IwBa6aEmc6n8WlIFY3RLD5VYEhqYaxjoTz1OxtTwAGhynOeGcfMoXYm7cZZhJe1CV/fFDXj0AJ0DtGq5VV7TffK+D59wnarOPbpYaL4MPqexDwN1XMLLaTFYhNJELBhCu0gg6xcxUaFn5rgy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kmemdump mechanism allows any driver to mark a specific memory area
for later dumping/debugging purpose, depending on the functionality
of the attached backend.
The backend would interface any hardware mechanism that will allow
dumping to complete regardless of the state of the kernel
(running, frozen, crashed, or any particular state).

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 MAINTAINERS               |   6 ++
 include/linux/kmemdump.h  |  63 ++++++++++++
 mm/Kconfig.debug          |   2 +
 mm/Makefile               |   1 +
 mm/kmemdump/Kconfig.debug |  14 +++
 mm/kmemdump/Makefile      |   3 +
 mm/kmemdump/kmemdump.c    | 202 ++++++++++++++++++++++++++++++++++++++
 7 files changed, 291 insertions(+)
 create mode 100644 include/linux/kmemdump.h
 create mode 100644 mm/kmemdump/Kconfig.debug
 create mode 100644 mm/kmemdump/Makefile
 create mode 100644 mm/kmemdump/kmemdump.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 8cf4990a8ff6..1713cccefc91 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13810,6 +13810,12 @@ L:	linux-iio@vger.kernel.org
 S:	Supported
 F:	drivers/iio/accel/kionix-kx022a*
 
+KMEMDUMP
+M:	Eugen Hristev <eugen.hristev@linaro.org>
+S:	Maintained
+F:	include/linux/kmemdump.h
+F:	mm/kmemdump/kmemdump.c
+
 KMEMLEAK
 M:	Catalin Marinas <catalin.marinas@arm.com>
 S:	Maintained
diff --git a/include/linux/kmemdump.h b/include/linux/kmemdump.h
new file mode 100644
index 000000000000..8e764bb2d8ac
--- /dev/null
+++ b/include/linux/kmemdump.h
@@ -0,0 +1,63 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _KMEMDUMP_H
+#define _KMEMDUMP_H
+
+enum kmemdump_uid {
+	KMEMDUMP_ID_START = 0,
+	KMEMDUMP_ID_USER_START,
+	KMEMDUMP_ID_USER_END,
+	KMEMDUMP_ID_NO_ID,
+};
+
+#ifdef CONFIG_KMEMDUMP
+/**
+ * struct kmemdump_zone - region mark zone information
+ * @id: unique id for this zone
+ * @zone: pointer to the memory area for this zone
+ * @size: size of the memory area of this zone
+ */
+struct kmemdump_zone {
+	enum kmemdump_uid	id;
+	void			*zone;
+	size_t			size;
+};
+
+#define KMEMDUMP_BACKEND_MAX_NAME 128
+/**
+ * struct kmemdump_backend - region mark backend information
+ * @name: the name of the backend
+ * @register_region: callback to register region in the backend
+ * @unregister_region: callback to unregister region in the backend
+ */
+struct kmemdump_backend {
+	char name[KMEMDUMP_BACKEND_MAX_NAME];
+	int (*register_region)(const struct kmemdump_backend *be,
+			       enum kmemdump_uid uid, void *vaddr, size_t size);
+	int (*unregister_region)(const struct kmemdump_backend *be,
+				 enum kmemdump_uid uid);
+};
+
+int kmemdump_register_backend(const struct kmemdump_backend *backend);
+void kmemdump_unregister_backend(const struct kmemdump_backend *backend);
+
+int kmemdump_register_id(enum kmemdump_uid id, void *zone, size_t size);
+
+#define kmemdump_register(...)						\
+	kmemdump_register_id(KMEMDUMP_ID_NO_ID, __VA_ARGS__)		\
+
+void kmemdump_unregister(enum kmemdump_uid id);
+#else
+static inline int kmemdump_register_id(enum kmemdump_uid uid, void *area,
+				       size_t size)
+{
+	return 0;
+}
+
+#define kmemdump_register(...)
+
+static inline void kmemdump_unregister(enum kmemdump_uid id)
+{
+}
+#endif
+
+#endif
diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index 32b65073d0cc..b6aad5cb09c1 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -309,3 +309,5 @@ config PER_VMA_LOCK_STATS
 	  overhead in the page fault path.
 
 	  If in doubt, say N.
+
+source "mm/kmemdump/Kconfig.debug"
diff --git a/mm/Makefile b/mm/Makefile
index 21abb3353550..ca1691dd8924 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -90,6 +90,7 @@ obj-$(CONFIG_MMU_NOTIFIER) += mmu_notifier.o
 obj-$(CONFIG_KSM) += ksm.o
 obj-$(CONFIG_PAGE_POISONING) += page_poison.o
 obj-$(CONFIG_KASAN)	+= kasan/
+obj-$(CONFIG_KMEMDUMP)	+= kmemdump/
 obj-$(CONFIG_KFENCE) += kfence/
 obj-$(CONFIG_KMSAN)	+= kmsan/
 obj-$(CONFIG_FAILSLAB) += failslab.o
diff --git a/mm/kmemdump/Kconfig.debug b/mm/kmemdump/Kconfig.debug
new file mode 100644
index 000000000000..5654180141c0
--- /dev/null
+++ b/mm/kmemdump/Kconfig.debug
@@ -0,0 +1,14 @@
+# SPDX-License-Identifier: GPL-2.0
+
+config KMEMDUMP
+	bool "KMEMDUMP: Allow the kernel to register memory regions for dumping purpose"
+	help
+	  Kmemdump mechanism allows any driver to mark a specific memory area
+	  for later dumping/debugging purpose, depending on the functionality
+	  of the attached backend.
+	  The backend would interface any hardware mechanism that will allow
+	  dumping to complete regardless of the state of the kernel
+	  (running, frozen, crashed, or any particular state).
+
+	  Note that modules using this feature must be rebuilt if option
+	  changes.
diff --git a/mm/kmemdump/Makefile b/mm/kmemdump/Makefile
new file mode 100644
index 000000000000..f5b917a6ef5e
--- /dev/null
+++ b/mm/kmemdump/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-y += kmemdump.o
diff --git a/mm/kmemdump/kmemdump.c b/mm/kmemdump/kmemdump.c
new file mode 100644
index 000000000000..c016457620a4
--- /dev/null
+++ b/mm/kmemdump/kmemdump.c
@@ -0,0 +1,202 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/kmemdump.h>
+
+#define MAX_ZONES 201
+
+static int default_register_region(const struct kmemdump_backend *be,
+				   enum kmemdump_uid id, void *area, size_t sz)
+{
+	return 0;
+}
+
+static int default_unregister_region(const struct kmemdump_backend *be,
+				     enum kmemdump_uid id)
+{
+	return 0;
+}
+
+static const struct kmemdump_backend kmemdump_default_backend = {
+	.name = "default",
+	.register_region = default_register_region,
+	.unregister_region = default_unregister_region,
+};
+
+static const struct kmemdump_backend *backend = &kmemdump_default_backend;
+static DEFINE_MUTEX(kmemdump_lock);
+static struct kmemdump_zone kmemdump_zones[MAX_ZONES];
+
+/**
+ * kmemdump_register_id() - Register region into kmemdump with given ID.
+ * @req_id: Requested unique kmemdump_uid that identifies the region
+ *	This can be KMEMDUMP_ID_NO_ID, in which case the function will
+ *	find an unused ID and return it.
+ * @zone: pointer to the zone of memory
+ * @size: region size
+ *
+ * Return: On success, it returns the unique id for the region.
+ *	 On failure, it returns negative error value.
+ */
+int kmemdump_register_id(enum kmemdump_uid req_id, void *zone, size_t size)
+{
+	struct kmemdump_zone *z;
+	enum kmemdump_uid uid = req_id;
+	int ret;
+
+	if (uid < KMEMDUMP_ID_START)
+		return -EINVAL;
+
+	if (uid >= MAX_ZONES)
+		return -ENOSPC;
+
+	mutex_lock(&kmemdump_lock);
+
+	if (uid == KMEMDUMP_ID_NO_ID)
+		while (uid < MAX_ZONES) {
+			if (!kmemdump_zones[uid].id)
+				break;
+			uid++;
+		}
+
+	if (uid == MAX_ZONES) {
+		mutex_unlock(&kmemdump_lock);
+		return -ENOSPC;
+	}
+
+	z = &kmemdump_zones[uid];
+
+	if (z->id) {
+		mutex_unlock(&kmemdump_lock);
+		return -EALREADY;
+	}
+
+	ret = backend->register_region(backend, uid, zone, size);
+	if (ret) {
+		mutex_unlock(&kmemdump_lock);
+		return ret;
+	}
+
+	z->zone = zone;
+	z->size = size;
+	z->id = uid;
+
+	mutex_unlock(&kmemdump_lock);
+
+	return uid;
+}
+EXPORT_SYMBOL_GPL(kmemdump_register_id);
+
+/**
+ * kmemdump_unregister() - Unregister region from kmemdump.
+ * @id: unique id that was returned when this region was successfully
+ *	registered initially.
+ *
+ * Return: None
+ */
+void kmemdump_unregister(enum kmemdump_uid id)
+{
+	struct kmemdump_zone *z = NULL;
+
+	mutex_lock(&kmemdump_lock);
+
+	z = &kmemdump_zones[id];
+	if (!z->id) {
+		mutex_unlock(&kmemdump_lock);
+		return;
+	}
+
+	backend->unregister_region(backend, z->id);
+
+	memset(z, 0, sizeof(*z));
+
+	mutex_unlock(&kmemdump_lock);
+}
+EXPORT_SYMBOL_GPL(kmemdump_unregister);
+
+/**
+ * kmemdump_register_backend() - Register a backend into kmemdump.
+ * @be: Pointer to a driver allocated backend. This backend must have
+ *	two callbacks for registering and deregistering a zone from the
+ *	backend.
+ *
+ * Only one backend is supported at a time.
+ *
+ * Return: On success, it returns 0, negative error value otherwise.
+ */
+int kmemdump_register_backend(const struct kmemdump_backend *be)
+{
+	enum kmemdump_uid uid;
+	int ret;
+
+	if (!be || !be->register_region || !be->unregister_region)
+		return -EINVAL;
+
+	mutex_lock(&kmemdump_lock);
+
+	/* Try to call the old backend for all existing regions */
+	for (uid = KMEMDUMP_ID_START; uid < MAX_ZONES; uid++)
+		if (kmemdump_zones[uid].id)
+			backend->unregister_region(backend,
+						   kmemdump_zones[uid].id);
+
+	backend = be;
+	pr_debug("kmemdump backend %s registered successfully.\n",
+		 backend->name);
+
+	/* Call the new backend for all existing regions */
+	for (uid = KMEMDUMP_ID_START; uid < MAX_ZONES; uid++) {
+		if (!kmemdump_zones[uid].id)
+			continue;
+		ret = backend->register_region(backend,
+					       kmemdump_zones[uid].id,
+					       kmemdump_zones[uid].zone,
+					       kmemdump_zones[uid].size);
+		if (ret)
+			pr_debug("register region failed with %d\n", ret);
+	}
+
+	mutex_unlock(&kmemdump_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kmemdump_register_backend);
+
+/**
+ * kmemdump_unregister_backend() - Unregister the backend from kmemdump.
+ * @be: Pointer to a driver allocated backend. This backend must match
+ *	the initially registered backend.
+ *
+ * Only one backend is supported at a time.
+ * Before deregistering, this will call the backend to unregister all the
+ * previously registered zones.
+ *
+ * Return: None
+ */
+void kmemdump_unregister_backend(const struct kmemdump_backend *be)
+{
+	enum kmemdump_uid uid;
+
+	mutex_lock(&kmemdump_lock);
+
+	if (backend != be) {
+		mutex_unlock(&kmemdump_lock);
+		return;
+	}
+
+	/* Try to call the old backend for all existing regions */
+	for (uid = KMEMDUMP_ID_START; uid < MAX_ZONES; uid++)
+		if (kmemdump_zones[uid].id)
+			backend->unregister_region(backend,
+						   kmemdump_zones[uid].id);
+
+	pr_debug("kmemdump backend %s removed successfully.\n", be->name);
+
+	backend = &kmemdump_default_backend;
+
+	mutex_unlock(&kmemdump_lock);
+}
+EXPORT_SYMBOL_GPL(kmemdump_unregister_backend);
+
-- 
2.43.0


