Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F746C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 13:56:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B296F6B02C1; Thu, 24 Jul 2025 09:56:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD9366B02C4; Thu, 24 Jul 2025 09:56:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 954626B02C5; Thu, 24 Jul 2025 09:56:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 80BF86B02C1
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:56:25 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 503C31A03CC
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:25 +0000 (UTC)
X-FDA: 83699307930.25.B33BACF
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4BE4A1C0015
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=nB8ok7cf;
	spf=pass (imf18.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.43 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753365383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GN2zEFDyKGDBFhODZpN5vP0Lq5DSvoJDRdz0YaUUvGk=;
	b=fGJPJQi+TIHUU+RjcJiCGbVFRDXV/icehlwKkBrxg3WU3bE8HcmsiSv40+5h9siJUr+CGM
	TDKpzqGpKcQeyqZak5BYKw1O+Euc8beFq9qClW9+4j00dsybwjJ3YPfhmLaw37njBNjrIK
	JpMZSDGTzEE+f43CA00fhVg3a9JUiFQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=nB8ok7cf;
	spf=pass (imf18.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.43 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753365383; a=rsa-sha256;
	cv=none;
	b=u46oKM8fdR0vsHCr/8ax0oQ+BfxVh7j0CMbNIr2uZTgaH0aeNEz8icWjmCOvwSrXP9XqIL
	j892AhZLF8u7T6sdpTeVh16R6+mKs2oxVVFAfw4Be0OXbcRsGeZq/9i2JzFaIvzYuxxg+K
	tzdCLciSzwADOsDCqouC65nv4ID8qKo=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3b77377858bso230706f8f.3
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753365381; x=1753970181; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GN2zEFDyKGDBFhODZpN5vP0Lq5DSvoJDRdz0YaUUvGk=;
        b=nB8ok7cfWTSdgmLyfNm4Q/ymIc4tvkCgj+8iG1lMao8z0RGZK0TXSyP3Medb+jW2kr
         TuH2qubQSTuly6gBkrTMtHwBK/Xc1BiGOcHjUQjteSJ56tIuKCUDGw53f6ArGFZiw7a0
         wDEAln8Tu1kgUv51IR/Y6mHltW7HR/fPeuaLcPW1Bx7m8bFfm/iST7LO4Wtw0YTzDwbj
         d8C4kDxtGvgzMvxvLkdVv+4Y4BDFWxe7cND/KFo1C75S/vMyo2lwppDkufwWXvhLHcgV
         BUkLggRUruHCkNnwTkxSvzYeyPNNzbnhNfEG3fkqUJhrprc/uJmBJnk7DIOlXg2m0Wi7
         w1RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753365381; x=1753970181;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GN2zEFDyKGDBFhODZpN5vP0Lq5DSvoJDRdz0YaUUvGk=;
        b=reAQbbberWUU8pDvRPOW7cyM2nhtzGPCx1z7eUhAn4pMjAR5q6AqADsxh8/LdVL1/D
         LpJ21tFKu7O3inTBpEG3lVH6EtwBCb8ffSNJgFsSK97vlqf5feEoR4csC64DQjYvhJzW
         HZyHW7P1J/3JJDIWkNc1wIYlFWkH/BB+o2pPtKUlLPRmhulXV+pzdyOPklzeLIOzqP9H
         pA3hJZ4owyANkSibHGsTzdMjH2D2Ah/m+DScq0Ge6cQ0z93qpJ+aXgFZB+XaZPvEHi8L
         RDL6AJGVCuQS29nZEXpp+GanI4pfjNnrhBxmpfXGrqvUoAFUhB7jlMpJWvhNX7jMknmb
         VlvA==
X-Forwarded-Encrypted: i=1; AJvYcCW1RsGRYjEWGFc7kObYrnoyj3ljvf7Jmt0fga4E7cyEplMoIET259IVaEu8nlzKwMWWu+SIgxh5Rw==@kvack.org
X-Gm-Message-State: AOJu0YwdiI1e9+ezKEsOOQ9qnktbE1ETMjLim+hfJ0y8yCqei5TjiQzI
	q16WS4kZvRdLSHwacE+Xpvje+9YBGp6H8Jt+U3px5bTHSJvXSNafLzSjwD3ufgYbJes=
X-Gm-Gg: ASbGncuADja6enAokZMyPUT81FK6mNN7snYqJ5pMWPj3WGiXDUQaDJJtGA2vEIt6ZbA
	zgN5BuGBHRUtOBFa3f34EidPMO35FmQAfiwKBE9nd4yN9+z77ajCm/dr6rlV1TrZtEkNd1bhTj/
	jTItSQ4/E0fGw3wh+Mk3BOfTj+mbYzA5R6GrKhByUaXlhwxgPvwO5yefs0g3uVDFEvEOgzKcYpC
	S5a/v0W6qhePRbiZyS9tQ1zbi57dAe3htkGX16T+2UlGqf7S2pvQ9J/j99j6nXHCyK+ItK1FF4y
	dmW7uvGnrRBCdIpEpGjmKj6oZKZ8hnHXZD6gHXN9Bw97CzR5n4kc1ayQvokWOtdEZknqOItIWey
	X4NpP/2vcSE4crZ1sAbQQH8FNv1mqbPCgbcjspeqTvcSrtWVAhL4h1Xe5wQwdhCiKMe1PvFL+gK
	gILh7QD+mg2o3qGtnsmdq7gQY=
X-Google-Smtp-Source: AGHT+IHTmHRuZDTBifWGKFIc3eVCp5M+8i6pzB5UkemP/rWgYq+QJTPTzxAD1akVwZJswOYtPp8y1A==
X-Received: by 2002:a05:6000:144c:b0:3b5:dc2a:ee74 with SMTP id ffacd0b85a97d-3b768eb427amr6529079f8f.24.1753365381251;
        Thu, 24 Jul 2025 06:56:21 -0700 (PDT)
Received: from eugen-station.. (cpc148880-bexl9-2-0-cust354.2-3.cable.virginm.net. [82.11.253.99])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587054e37dsm20889375e9.14.2025.07.24.06.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 06:56:20 -0700 (PDT)
From: Eugen Hristev <eugen.hristev@linaro.org>
To: linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	tglx@linutronix.de,
	andersson@kernel.org,
	pmladek@suse.com
Cc: linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	eugen.hristev@linaro.org,
	corbet@lwn.net,
	mojha@qti.qualcomm.com,
	rostedt@goodmis.org,
	jonechou@google.com,
	tudor.ambarus@linaro.org
Subject: [RFC][PATCH v2 01/29] kmemdump: introduce kmemdump
Date: Thu, 24 Jul 2025 16:54:44 +0300
Message-ID: <20250724135512.518487-2-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250724135512.518487-1-eugen.hristev@linaro.org>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4BE4A1C0015
X-Rspamd-Server: rspam06
X-Stat-Signature: 5ssn5fxszfj9x7x6dz4bdiagqq8381jt
X-HE-Tag: 1753365382-832977
X-HE-Meta: U2FsdGVkX1925ux2obL/NwnwMcnhk7mH5OYoVUEuc1O4dit1fa5Si1sGdWkphyWOhLfDJJNGjsSPPC2J58FMGEmbOu79hfR1w966BShxWO7ANjIqpxYf18FcRF2NYIINyoYl3eIJ+3whvaP8r7/VCZ//S5yLnqaJcgS1IisY7UslPzmbB682XE3J0BFPz8ylOt26NdSolDew7WX9Qt0Q+1j58gQPIPeA7TqrEptwQQqx745TAh70f/A7Gog2JE51rm7tEgisFmTtBN4OG28x2pGMT2Wqj5e8gYq6yOtjKWzV+UWjhgOwPK6P7uWx7ChjO5Hrs/upGvFdvAdPOYohfu1l+w3oHw9IukBoQ6iMWvEP4hO5EFGKdJYQDDONTVulywe9l9WJvIr8DSgwXu/w8gmsmRtBHTlrHCv30+fh6nMX6HdPTpKGXdP9J3YO23//2Qco1dACoBJgb9rLxvp9KW6zjsEDbB+bBNClbqy/6vRF0Tj7TNuMeJihCO3j9ABzoJ+SZ9Lvc/Eh6jVbk8Iar8EDqpL3JT87nU9idzxDOpLyatoNOXQQiDNZnv+Aet4XvFDLne3T2KvH/7baEgAoUFxRA0ZPYWgjPHHbHe3z5EvbnhOELqSmBhWndeWVA4qUoI8vfFCfpwg+mI1jSO5rloS+Yt3is2Y7RYh0nxTJcTBktLiZ5rNgKt/nTcyLLl3xwBZEcoCWOZOIetV3FmQeVsu+R1kjNjrk5dUwH8kuKVFXKOZ6fs2hMCkY7B8ppNwXox5uqnHtI258HlFrfNQcgbUHprmm49WC5mycW7+f9Zy1+nFdHX3hJexa4YeyHiIsw0yamiKvF/3C2D3N9lCpccsOJL4YAk+TivVT0db0hmTS80beVUSh7CNF1xRzHDIt1G9Qfru6gMnIhpgAeQRkCeFs4tWW7dOTkPO3ueWG+Rqlfzx5HwLwCPYKIg/vJ5jXW9iBz4wKeD9A7PHbrfc
 RDbO+w5T
 zkI/D7XS5vZ3cLA29Oh8pG4kpuaUHCUtFJEQVtplQUxcD4eiVWrrzkHmzFxkYdt2rK6b/jNLdjGO98BqGu/xZUVIZE4hcbkfe42fQw2AlI25X6fYrg3XSBrWR9D5GB3tiRGBgZC+tr6MyqNrx6FizvcGNDwsbIoCqbmL24sMrW2ubA4Hd01LlVJ4yjy6GAasAgJiOuJ9hILI7YyEUnFlTgBfjSJu3VoQTw5IOeGLLIf+myBRql7fJZFx7dMHU/m1XaRPyto43Y3sdUgvUz08j8w35EnS//dmyNo+KcBzYnJdOdBifntHfR93av7phPOOZozpu+UHFoFT+NfC6V5Pg5uiNWFsogfSYYRM+h/zoWVIKVAlsWTaI5uB6iocwoFaIvtCyVkaqqyV45EOI38Mq6Qnj0Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kmemdump mechanism allows any driver to mark a specific memory area
for later dumping purpose, depending on the functionality
of the attached backend. The backend would interface any hardware
mechanism that will allow dumping to complete regardless of the
state of the kernel (running, frozen, crashed, or any particular
state).

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 MAINTAINERS                       |   6 +
 drivers/Kconfig                   |   4 +
 drivers/Makefile                  |   2 +
 drivers/debug/Kconfig             |  16 +++
 drivers/debug/Makefile            |   3 +
 drivers/debug/kmemdump.c          | 214 ++++++++++++++++++++++++++++++
 include/asm-generic/vmlinux.lds.h |  13 ++
 include/linux/kmemdump.h          | 135 +++++++++++++++++++
 8 files changed, 393 insertions(+)
 create mode 100644 drivers/debug/Kconfig
 create mode 100644 drivers/debug/Makefile
 create mode 100644 drivers/debug/kmemdump.c
 create mode 100644 include/linux/kmemdump.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 70d1a0a62a8e..7e8da575025c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13617,6 +13617,12 @@ L:	linux-iio@vger.kernel.org
 S:	Supported
 F:	drivers/iio/accel/kionix-kx022a*
 
+KMEMDUMP
+M:	Eugen Hristev <eugen.hristev@linaro.org>
+S:	Maintained
+F:	drivers/debug/kmemdump.c
+F:	include/linux/kmemdump.h
+
 KMEMLEAK
 M:	Catalin Marinas <catalin.marinas@arm.com>
 S:	Maintained
diff --git a/drivers/Kconfig b/drivers/Kconfig
index e0777f5ed543..412ef182d5c2 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -245,4 +245,8 @@ source "drivers/hte/Kconfig"
 
 source "drivers/cdx/Kconfig"
 
+source "drivers/dpll/Kconfig"
+
+source "drivers/debug/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index b5749cf67044..e4cc23f4aba2 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -196,3 +196,5 @@ obj-$(CONFIG_CDX_BUS)		+= cdx/
 obj-$(CONFIG_DPLL)		+= dpll/
 
 obj-$(CONFIG_S390)		+= s390/
+
+obj-y				+= debug/
diff --git a/drivers/debug/Kconfig b/drivers/debug/Kconfig
new file mode 100644
index 000000000000..b86585c5d621
--- /dev/null
+++ b/drivers/debug/Kconfig
@@ -0,0 +1,16 @@
+# SPDX-License-Identifier: GPL-2.0
+menu "Generic Debug Options"
+
+config KMEMDUMP
+	bool "Allow the kernel to register memory regions for dumping purpose"
+	help
+	  Kmemdump mechanism allows any driver to register a specific memory
+	  area for later dumping purpose, depending on the functionality
+	  of the attached backend. The backend would interface any hardware
+	  mechanism that will allow dumping to happen regardless of the
+	  state of the kernel (running, frozen, crashed, or any particular
+	  state).
+
+	  Note that modules using this feature must be rebuilt if option
+	  changes.
+endmenu
diff --git a/drivers/debug/Makefile b/drivers/debug/Makefile
new file mode 100644
index 000000000000..8ed6ec2d8a0d
--- /dev/null
+++ b/drivers/debug/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_KMEMDUMP) += kmemdump.o
diff --git a/drivers/debug/kmemdump.c b/drivers/debug/kmemdump.c
new file mode 100644
index 000000000000..b6d418aafbef
--- /dev/null
+++ b/drivers/debug/kmemdump.c
@@ -0,0 +1,214 @@
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
+static int __init init_kmemdump(void)
+{
+	const struct kmemdump_zone *e;
+
+	/* Walk the kmemdump section for static variables and register them */
+	for_each_kmemdump_entry(e)
+		kmemdump_register_id(e->id, e->zone, e->size);
+
+	return 0;
+}
+late_initcall(init_kmemdump);
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
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index fa5f19b8d53a..433719442a5e 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -488,6 +488,8 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
 	FW_LOADER_BUILT_IN_DATA						\
 	TRACEDATA							\
 									\
+	KMEMDUMP_TABLE							\
+									\
 	PRINTK_INDEX							\
 									\
 	/* Kernel symbol table: Normal symbols */			\
@@ -891,6 +893,17 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
 #define TRACEDATA
 #endif
 
+#ifdef CONFIG_KMEMDUMP
+#define KMEMDUMP_TABLE							\
+	. = ALIGN(8);							\
+	.kmemdump : AT(ADDR(.kmemdump) - LOAD_OFFSET) {			\
+		BOUNDED_SECTION_POST_LABEL(.kmemdump, __kmemdump_table,	\
+					   , _end)			\
+	}
+#else
+#define KMEMDUMP_TABLE
+#endif
+
 #ifdef CONFIG_PRINTK_INDEX
 #define PRINTK_INDEX							\
 	.printk_index : AT(ADDR(.printk_index) - LOAD_OFFSET) {		\
diff --git a/include/linux/kmemdump.h b/include/linux/kmemdump.h
new file mode 100644
index 000000000000..c3690423a347
--- /dev/null
+++ b/include/linux/kmemdump.h
@@ -0,0 +1,135 @@
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
+/* kmemdump section table markers*/
+extern const struct kmemdump_zone __kmemdump_table[];
+extern const struct kmemdump_zone __kmemdump_table_end[];
+
+/* Annotate a variable into the given kmemdump UID */
+#define KMEMDUMP_VAR_ID(idx, sym, sz)						\
+	static const struct kmemdump_zone __UNIQUE_ID(__kmemdump_entry_##sym)	\
+	__used __section(".kmemdump") = { .id = idx,				\
+					  .zone = (void *)&(sym),		\
+					  .size = (sz),				\
+					}
+
+/* Iterate through kmemdump section entries */
+#define for_each_kmemdump_entry(__entry)		\
+	for (__entry = __kmemdump_table;		\
+	     __entry < __kmemdump_table_end;		\
+	     __entry++)
+
+#else
+#define KMEMDUMP_VAR_ID(...)
+#endif
+/*
+ * Wrapper over an existing fn allocator
+ * It will :
+ *	- unregister the memory already registered into kmemdump at the given UID
+ *	- register the memory into kmemdump at the given UID
+ *	- take an argument for the ID and the wanted size
+ */
+#define kmemdump_alloc_id_size_replace(id, sz, fn, ...)			\
+	({								\
+		void *__p = fn(__VA_ARGS__);				\
+									\
+		if (__p) {						\
+			kmemdump_unregister(id);			\
+			kmemdump_register_id(id, __p, sz);		\
+		}							\
+		__p;							\
+	})
+/*
+ * Wrapper over an existing fn allocator
+ * It will :
+ *	- fail if the given UID is already registered
+ *	- register the memory into kmemdump at the given UID
+ *	- take an argument for the ID and the wanted size
+ */
+
+#define kmemdump_alloc_id_size(id, sz, fn, ...)				\
+	({								\
+	void *__p = fn(__VA_ARGS__);				\
+									\
+		if (__p)						\
+			kmemdump_register_id(id, __p, sz);		\
+		__p;							\
+	})
+
+#define kmemdump_alloc_size(...)					\
+	kmemdump_alloc_id_size(KMEMDUMP_ID_NO_ID, __VA_ARGS__)
+
+#define kmemdump_phys_alloc_id_size(id, sz, fn, ...)			\
+	({								\
+		phys_addr_t __p = fn(__VA_ARGS__);			\
+									\
+		if (__p)						\
+			kmemdump_register_id(id, __va(__p), sz);	\
+		__p;							\
+	})
+
+#define kmemdump_phys_alloc_size(...)					\
+	kmemdump_phys_alloc_id_size(KMEMDUMP_ID_NO_ID, __VA_ARGS__)
+
+#define kmemdump_free_id(id, fn, ...)					\
+	({								\
+		kmemdump_unregister(id);				\
+		fn(__VA_ARGS__);					\
+	})
+
+#ifdef CONFIG_KMEMDUMP
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
+void kmemdump_unregister(enum kmemdump_uid id);
+#else
+static inline int kmemdump_register_id(enum kmemdump_uid uid, void *area,
+				       size_t size)
+{
+	return 0;
+}
+
+static inline void kmemdump_unregister(enum kmemdump_uid id)
+{
+}
+#endif
+
+#endif
-- 
2.43.0


