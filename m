Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8370CC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 13:57:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D6AA8E0087; Thu, 24 Jul 2025 09:56:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 388C38E007C; Thu, 24 Jul 2025 09:56:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2275D8E0087; Thu, 24 Jul 2025 09:56:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0C1288E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:56:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CDEAD160334
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:51 +0000 (UTC)
X-FDA: 83699309022.24.6B6FE0B
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf25.hostedemail.com (Postfix) with ESMTP id DDDA5A0003
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=Jh2IBlER;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf25.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.51 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753365410; a=rsa-sha256;
	cv=none;
	b=qp5nzh/k8787qnm8UzIddVAafu7oR0WaI5yXahL49BNUQIOT20dMdiu5CoywCocDhWD49Z
	+pfUK0cyb8l7RJlLB7TVQIUE082VSfeQAcq4x2lJuQge1mpf7RhoUmlabEgXytlah5LSfr
	z6qZKsi6uRly03QOUBpWcoJ2X2A+bTo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=Jh2IBlER;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf25.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.51 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753365410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fWG6liyAx+OC/k6NlOqOAiqfCofkENyDgSwiIXNmCrk=;
	b=tzN4ymozGTFHD6CG4au9SD1rpEP7q3njJj3n/QNgi7XsTLlLISx07rBp7252YkZ7j9rcPv
	hq0qz4bVDgjJzOVkvp2l4qbnzfUY6q9uYGJhpHdUNf6DnUZLDk+R6e/mR52JT6uCLP7qrH
	0IJU53nqYNeWqtvjuajQ9wRxnLFc9Rs=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4561a4a8bf2so11786385e9.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753365408; x=1753970208; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fWG6liyAx+OC/k6NlOqOAiqfCofkENyDgSwiIXNmCrk=;
        b=Jh2IBlERipKAwdRjeIlGNUVJp+L4KtAXEFuMTPX1HW35+7eo8QSeOsVlXqRTWOUe4L
         vdD4c8KXHIfc+92AT9qQRMl97ZuYZ/UbDpfvL0/GAXyoGfTO4qgxixAG6yecjEAMVRvM
         4lKuWUlO+JkC0zaYOd2wO169vw9xLRBeXG5Wd4VLot+xLMflvTK1iIc532JEMlCi/8Pa
         rMTXRMwFmFHzybRHXv+TdcVVD3cwXkZhchu04ctX1PRocw7RXLqcX49/8RF9Ta8Y8LU+
         ExI0qtvXrm9R+jC8B9bDVKPvuMfKGciE92v+R4ljIutm2oaRL4b62BRg/XVKUEOua0yM
         jFdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753365408; x=1753970208;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fWG6liyAx+OC/k6NlOqOAiqfCofkENyDgSwiIXNmCrk=;
        b=ixYsfKRRh61fYz+NCcWK1CTCZ4/PN/8T2tZFjiK45aKLVzJeLBUq2+Br+RslPwlmeN
         jn5IcyNJejgACuGAmHrD75RYMpp59uTBmYlJsXFlm2FMZcC+JJZr38d5R0tH6CsSr3X4
         E2b1ZRrAkUDVKgsa2N5hmdIzkjDGD7pa5fS/Eda7UUrTfo00tDQ44i1yOcsvCP/UZRpj
         3G/Ji7OoOscqx8miehvQRqsS/LPSHzr0F+ajGBDJCNsUdrz7rnTve0H4IS0IJElUOMxR
         dhFQIf3u06njQLdUb+QAczDvPH1k3aYt1bD04AvsUAJC/EeThDx+YkscvCkSTaeM+5+X
         D8qQ==
X-Forwarded-Encrypted: i=1; AJvYcCWaJPpnhnfoE1Y+TFbSNJdMpKcLfJvQ4x6C0Uxy9Idx0kTgM9KOaqU/J/72Bu4POj0ZmuZA9mEyhg==@kvack.org
X-Gm-Message-State: AOJu0YyNcQ3fny0uyFcuYMR8Jg8LreurHI8fBHXrO1QvRBKp1/22UiTB
	9SEzdImRvlhcNlPT3zDUFzOV287mE5vr8bhTEZ4N8PNN+I0UkPUxNeG2OxBJlYkdNjY=
X-Gm-Gg: ASbGncu6/qUH4pkdEBfNMtjQIWfXhF+n2S/nLFTYt5O5OyoKwTe210/VuoZUrU60nz7
	MLYq8ck1mu8eGERjV/fDH7wWh+3qwGtb4PDive0rhxMEMDxQMJyKZo+AgmmI7Z9Cq2InnAdzTYq
	6RDBwQcdl9y+I+s4TEYGIClmVGBjh1/tTCWFE0wpJKjZUnpQESSRCe48s8ADLwD2b2oiGMSaYMj
	BP9J61CkpE0cJFDqVc2Wv0fqqqaznOkdf7rJ0EhyrfrTIr5sbklVFER9H4rUO605gMMXWe1XCOl
	8QPmoa0Pi/pn6UCW68lkjpMhCLGRKfnhkyUVFWkQQjSnWTawMh1Ta215LV4LSpN8RKE6h1jSvGh
	oC/Y8U2Op2+P2j3CHkCPiUuJRuByA7p3cfHjszaDW6BQIXPHTiDj31nQ8r93oCzMs/H646BamFr
	DgK5DBMW+7IhZo
X-Google-Smtp-Source: AGHT+IGPJc7unar/DDQTk3kiLLtY/cjrcVJ4F2sYy/xaKu3cmlZTqIIza2uFiyGLrfIi1KWSYZcG+g==
X-Received: by 2002:a05:600c:1554:b0:456:1c4a:82b2 with SMTP id 5b1f17b1804b1-4586d84cfb5mr49962935e9.10.1753365408340;
        Thu, 24 Jul 2025 06:56:48 -0700 (PDT)
Received: from eugen-station.. (cpc148880-bexl9-2-0-cust354.2-3.cable.virginm.net. [82.11.253.99])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587054e37dsm20889375e9.14.2025.07.24.06.56.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 06:56:48 -0700 (PDT)
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
Subject: [RFC][PATCH v2 29/29] kmemdump: Add Kinfo backend driver
Date: Thu, 24 Jul 2025 16:55:12 +0300
Message-ID: <20250724135512.518487-30-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250724135512.518487-1-eugen.hristev@linaro.org>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DDDA5A0003
X-Stat-Signature: 3ifeuw6ygj5dh8hhnhnk8iitq18f9twu
X-Rspam-User: 
X-HE-Tag: 1753365409-799372
X-HE-Meta: U2FsdGVkX18VAyHkkfwO79UAvrlNUEZpbWYClUMSSA2+UP6JXezpzOKTUCpodHF6xqegbnVNuACYPp9bQk6GaqSBbmU0ww8TUdFzhB74gPxwRVATVmX5W3OUneyrbH2u3SDeBz8jEKYLGgunaqu7b1jFbYZqBaFgwEUsZ2k9v5VmEgIFYCd2qAihqw3gQRhl6cuHqwgBxX1E9rI9gTr+ndGD3dli4MzCxbUFj9a6z4k7i660+J7MOfTAaxowyMkMfem2nWfRz8jwTbrpsbElW70tFSjjUWw3JAaF7dcoEt3klr6d7TcYJOJ8ZPrvosOigMQzMuupJQFIQc/EgiNy02B4w3B02R432GfBF4taXgeO9zaWhlGxQ9XXpLnYFEH+6zYIS150apbz6GNONOSNmMp89QXh1QJfeEHtWR2Lu2jZXGBZAMg/kTts8YNZ9uKeZ4MnlnQZrLdfOFgvD6s2FTmf+Lu7xK4qy6Oq7zaqfLWI7QXGAIy6dhJ+OhWSJxNLkLLZhmjY2dxgHx6jUDOOehAbt1edpIAUeAPlj4cRRiz5ljzinnp/2+RPUiPQmbK+cgEroe5rKwJzX7xBGDrOeNLcwkTfvmrbpxv0J20YUfFe2WKranyzT2TR+l0yifSnMPLR5IMwzZ0q0UXmzlfTGMtR4MOFb+LNnCSF9iZj/hsMwRNAOwXj5k4Og9w1LtbqMfdegThWnv/81xx+JJodRrEN1K+AWU4Sz9/DWaWhjcvAn2O9lkG+/KDZqs5m+7ekDtATEW2+ekWlEevejdUrgBdDIZjPm7H7P2ldiGalxcn3v/8w1d1lV7d8ZsW/oJPXjH9q6aOkz0okmy0uclBg+GXXn+on7SY72Hu48bQp3DBVCdQosBlgm/aPVKP9coGSNgHB7EENEyFbaug/m55CPEyBIG0r0G76XLEyJLwQ5GBIF8ziGd+2VkyFA8WIypZ3mLN3Tccrn/dWxL3r+rc
 ng8aQ5d/
 esxLBJZaVTEtSlxfwghu2NkygQt9IhAUx0Bd+w1ME+iOPdxNaAneryuDXaz8J+AsUQ4sulCPWYSSUPROlvfd5AEMSF2UbpN+qYxCBwz2aItHytPGJkIWisxhbTLfr4eRf4UOwkSfQuZd9Q1nd8SDYdfVNxV05QzCOrCv9mxE5PlkSEj93mHWiHYuLg0AFnddyFGB3F59lpQb2UHgOjbwga+7HHN5jJaVzVfXhT1K+zvQBTZyKRdKjQRk8SnJtkxaTfNKdHkb3R5YWzvKrUI/FWrK2g3AZGz9tZBvDU3I9uOsHpmoyRsJG5yD0u5ddoNXUDqRhTyDVdqeRTwn44dXodd80T0+xltGFcHJmQwMIINc5di5KYKQM9MUu8YdP0aF34+0j
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add Kinfo backend driver.
This backend driver will select only regions of interest for the firmware,
and it copy those into a shared memory area that is supplied via OF.
The firmware is only interested in addresses for some symbols.
The list format is kinfo-compatible, with devices like Google Pixel phone.
Based on original work from Jone Chou <jonechou@google.com>

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
As stated in the cover letter I did not test this on a device as I do not
have one. Testing is appreciated and feedback welcome !
This kinfo backend is how we envision it to look like, while preserving
compatibility with existing devices and firmware.
Yes I also know the compatible is not documented. But if we want to have
this driver in the kernel, I can easily add one


 MAINTAINERS            |   5 +
 drivers/debug/Kconfig  |  13 ++
 drivers/debug/Makefile |   1 +
 drivers/debug/kinfo.c  | 304 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 323 insertions(+)
 create mode 100644 drivers/debug/kinfo.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 68797717175c..bc605480d6e8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13625,6 +13625,11 @@ F:	drivers/debug/kmemdump.c
 F:	drivers/debug/kmemdump_coreimage.c
 F:	include/linux/kmemdump.h
 
+KMEMDUMP KINFO BACKEND DRIVER
+M:	Eugen Hristev <eugen.hristev@linaro.org>
+S:	Maintained
+F:	drivers/debug/kinfo.c
+
 KMEMDUMP QCOM MINIDUMP BACKEND DRIVER
 M:	Eugen Hristev <eugen.hristev@linaro.org>
 S:	Maintained
diff --git a/drivers/debug/Kconfig b/drivers/debug/Kconfig
index d34ceaf99bd8..1a44990c2824 100644
--- a/drivers/debug/Kconfig
+++ b/drivers/debug/Kconfig
@@ -39,4 +39,17 @@ config KMEMDUMP_QCOM_MINIDUMP_BACKEND
 	  into the minidump table of contents. Further on, the firmware
 	  will be able to read the table of contents and extract the
 	  memory regions on case-by-case basis.
+
+config KMEMDUMP_KINFO_BACKEND
+	tristate "Shared memory KInfo compatible backend"
+	depends on KMEMDUMP
+	help
+	  Say y here to enable the Shared memory KInfo compatible backend
+	  driver.
+	  With this backend, the registered regions are copied to a shared
+	  memory zone at register time.
+	  The shared memory zone is supplied via OF.
+	  This backend will select only regions that are of interest,
+	  and keep only addresses. The format of the list is Kinfo compatible.
+
 endmenu
diff --git a/drivers/debug/Makefile b/drivers/debug/Makefile
index 7f70b84049cb..861f2e2c4fe2 100644
--- a/drivers/debug/Makefile
+++ b/drivers/debug/Makefile
@@ -3,3 +3,4 @@
 obj-$(CONFIG_KMEMDUMP) += kmemdump.o
 obj-$(CONFIG_KMEMDUMP_COREIMAGE) += kmemdump_coreimage.o
 obj-$(CONFIG_KMEMDUMP_QCOM_MINIDUMP_BACKEND) += qcom_minidump.o
+obj-$(CONFIG_KMEMDUMP_KINFO_BACKEND) += kinfo.o
diff --git a/drivers/debug/kinfo.c b/drivers/debug/kinfo.c
new file mode 100644
index 000000000000..bdf50254fa92
--- /dev/null
+++ b/drivers/debug/kinfo.c
@@ -0,0 +1,304 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/platform_device.h>
+#include <linux/kallsyms.h>
+#include <linux/vmalloc.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_reserved_mem.h>
+#include <linux/platform_device.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+#include <linux/kmemdump.h>
+#include <linux/module.h>
+#include <linux/utsname.h>
+
+#define BUILD_INFO_LEN		256
+#define DEBUG_KINFO_MAGIC	0xCCEEDDFF
+
+/*
+ * Header structure must be byte-packed, since the table is provided to
+ * bootloader.
+ */
+struct kernel_info {
+	/* For kallsyms */
+	__u8 enabled_all;
+	__u8 enabled_base_relative;
+	__u8 enabled_absolute_percpu;
+	__u8 enabled_cfi_clang;
+	__u32 num_syms;
+	__u16 name_len;
+	__u16 bit_per_long;
+	__u16 module_name_len;
+	__u16 symbol_len;
+	__u64 _relative_pa;
+	__u64 _text_pa;
+	__u64 _stext_pa;
+	__u64 _etext_pa;
+	__u64 _sinittext_pa;
+	__u64 _einittext_pa;
+	__u64 _end_pa;
+	__u64 _offsets_pa;
+	__u64 _names_pa;
+	__u64 _token_table_pa;
+	__u64 _token_index_pa;
+	__u64 _markers_pa;
+	__u64 _seqs_of_names_pa;
+
+	/* For frame pointer */
+	__u32 thread_size;
+
+	/* For virt_to_phys */
+	__u64 swapper_pg_dir_pa;
+
+	/* For linux banner */
+	__u8 last_uts_release[__NEW_UTS_LEN];
+
+	/* Info of running build */
+	__u8 build_info[BUILD_INFO_LEN];
+
+	/* For module kallsyms */
+	__u32 enabled_modules_tree_lookup;
+	__u32 mod_mem_offset;
+	__u32 mod_kallsyms_offset;
+} __packed;
+
+struct kernel_all_info {
+	__u32 magic_number;
+	__u32 combined_checksum;
+	struct kernel_info info;
+} __packed;
+
+struct debug_kinfo {
+	struct device *dev;
+	void *all_info_addr;
+	u32 all_info_size;
+	struct kmemdump_backend kinfo_be;
+};
+
+static struct debug_kinfo *kinfo;
+
+#define be_to_kinfo(be) container_of(be, struct debug_kinfo, kinfo_be)
+
+static void update_kernel_all_info(struct kernel_all_info *all_info)
+{
+	int index;
+	struct kernel_info *info;
+	u32 *checksum_info;
+
+	all_info->magic_number = DEBUG_KINFO_MAGIC;
+	all_info->combined_checksum = 0;
+
+	info = &all_info->info;
+	checksum_info = (u32 *)info;
+	for (index = 0; index < sizeof(*info) / sizeof(u32); index++)
+		all_info->combined_checksum ^= checksum_info[index];
+}
+
+static int build_info_set(const char *str, const struct kernel_param *kp)
+{
+	struct kernel_all_info *all_info = kinfo->all_info_addr;
+	size_t build_info_size;
+
+	if (kinfo->all_info_addr == 0 || kinfo->all_info_size == 0)
+		return -ENAVAIL;
+
+	all_info = (struct kernel_all_info *)kinfo->all_info_addr;
+	build_info_size = sizeof(all_info->info.build_info);
+
+	memcpy(&all_info->info.build_info, str, min(build_info_size - 1,
+						    strlen(str)));
+	update_kernel_all_info(all_info);
+
+	if (strlen(str) > build_info_size) {
+		pr_warn("%s: Build info buffer (len: %zd) can't hold entire string '%s'\n",
+			__func__, build_info_size, str);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static const struct kernel_param_ops build_info_op = {
+	.set = build_info_set,
+};
+
+module_param_cb(build_info, &build_info_op, NULL, 0200);
+MODULE_PARM_DESC(build_info, "Write build info to field 'build_info' of debug kinfo.");
+
+/**
+ * register_kinfo_region() - Register a new kinfo region
+ * @be: pointer to backend
+ * @id: unique id to identify the region
+ * @vaddr: virtual memory address of the region start
+ * @size: size of the region
+ *
+ * Return: On success, it returns 0 and negative error value on failure.
+ */
+static int register_kinfo_region(const struct kmemdump_backend *be,
+				 enum kmemdump_uid id, void *vaddr, size_t size)
+{
+	struct debug_kinfo *kinfo = be_to_kinfo(be);
+	struct kernel_all_info *all_info = kinfo->all_info_addr;
+	struct kernel_info *info = &all_info->info;
+
+	switch (id) {
+	case KMEMDUMP_ID_COREIMAGE__sinittext:
+		info->_sinittext_pa = (u64)__pa(vaddr);
+		break;
+	case KMEMDUMP_ID_COREIMAGE__einittext:
+		info->_einittext_pa = (u64)__pa(vaddr);
+		break;
+	case KMEMDUMP_ID_COREIMAGE__end:
+		info->_end_pa = (u64)__pa(vaddr);
+		break;
+	case KMEMDUMP_ID_COREIMAGE__text:
+		info->_text_pa = (u64)__pa(vaddr);
+		break;
+	case KMEMDUMP_ID_COREIMAGE__stext:
+		info->_stext_pa = (u64)__pa(vaddr);
+		break;
+	case KMEMDUMP_ID_COREIMAGE__etext:
+		info->_etext_pa = (u64)__pa(vaddr);
+		break;
+	case KMEMDUMP_ID_COREIMAGE_kallsyms_num_syms:
+		info->num_syms = *(__u32 *)vaddr;
+		break;
+	case KMEMDUMP_ID_COREIMAGE_kallsyms_relative_base:
+		info->_relative_pa = (u64)__pa(vaddr);
+		break;
+	case KMEMDUMP_ID_COREIMAGE_kallsyms_offsets:
+		info->_offsets_pa = (u64)__pa(vaddr);
+		break;
+	case KMEMDUMP_ID_COREIMAGE_kallsyms_names:
+		info->_names_pa = (u64)__pa(vaddr);
+		break;
+	case KMEMDUMP_ID_COREIMAGE_kallsyms_token_table:
+		info->_token_table_pa = (u64)__pa(vaddr);
+		break;
+	case KMEMDUMP_ID_COREIMAGE_kallsyms_token_index:
+		info->_token_index_pa = (u64)__pa(vaddr);
+		break;
+	case KMEMDUMP_ID_COREIMAGE_kallsyms_markers:
+		info->_markers_pa = (u64)__pa(vaddr);
+		break;
+	case KMEMDUMP_ID_COREIMAGE_kallsyms_seqs_of_names:
+		info->_seqs_of_names_pa = (u64)__pa(vaddr);
+		break;
+	case KMEMDUMP_ID_COREIMAGE_swapper_pg_dir:
+		info->swapper_pg_dir_pa = (u64)__pa(vaddr);
+		break;
+	case KMEMDUMP_ID_COREIMAGE_init_uts_ns_name:
+		strscpy(info->last_uts_release, vaddr, __NEW_UTS_LEN);
+		break;
+	default:
+	};
+
+	update_kernel_all_info(all_info);
+	return 0;
+}
+
+/**
+ * unregister_md_region() - Unregister a previously registered kinfo region
+ * @id: unique id to identify the region
+ *
+ * Return: On success, it returns 0 and negative error value on failure.
+ */
+static int unregister_kinfo_region(const struct kmemdump_backend *be,
+				   enum kmemdump_uid id)
+{
+	return 0;
+}
+
+static int debug_kinfo_probe(struct platform_device *pdev)
+{
+	struct device_node *mem_region;
+	struct reserved_mem *rmem;
+	struct kernel_info *info;
+	struct kernel_all_info *all_info;
+
+	mem_region = of_parse_phandle(pdev->dev.of_node, "memory-region", 0);
+	if (!mem_region) {
+		dev_warn(&pdev->dev, "no such memory-region\n");
+		return -ENODEV;
+	}
+
+	rmem = of_reserved_mem_lookup(mem_region);
+	if (!rmem) {
+		dev_warn(&pdev->dev, "no such reserved mem of node name %s\n",
+			 pdev->dev.of_node->name);
+		return -ENODEV;
+	}
+
+	/* Need to wait for reserved memory to be mapped */
+	if (!rmem->priv)
+		return -EPROBE_DEFER;
+
+	if (!rmem->base || !rmem->size) {
+		dev_warn(&pdev->dev, "unexpected reserved memory\n");
+		return -EINVAL;
+	}
+
+	if (rmem->size < sizeof(struct kernel_all_info)) {
+		dev_warn(&pdev->dev, "unexpected reserved memory size\n");
+		return -EINVAL;
+	}
+
+	kinfo = kzalloc(sizeof(*kinfo), GFP_KERNEL);
+	if (!kinfo)
+		return -ENOMEM;
+
+	kinfo->dev = &pdev->dev;
+
+	strscpy(kinfo->kinfo_be.name, "debug_kinfo");
+	kinfo->kinfo_be.register_region = register_kinfo_region;
+	kinfo->kinfo_be.unregister_region = unregister_kinfo_region;
+	kinfo->all_info_addr = rmem->priv;
+	kinfo->all_info_size = rmem->size;
+
+	all_info = kinfo->all_info_addr;
+
+	memset(all_info, 0, sizeof(struct kernel_all_info));
+	info = &all_info->info;
+	info->enabled_all = IS_ENABLED(CONFIG_KALLSYMS_ALL);
+	info->enabled_absolute_percpu = IS_ENABLED(CONFIG_KALLSYMS_ABSOLUTE_PERCPU);
+	info->enabled_cfi_clang = IS_ENABLED(CONFIG_CFI_CLANG);
+	info->name_len = KSYM_NAME_LEN;
+	info->bit_per_long = BITS_PER_LONG;
+	info->module_name_len = MODULE_NAME_LEN;
+	info->symbol_len = KSYM_SYMBOL_LEN;
+	info->thread_size = THREAD_SIZE;
+	info->enabled_modules_tree_lookup = IS_ENABLED(CONFIG_MODULES_TREE_LOOKUP);
+	info->mod_mem_offset = offsetof(struct module, mem);
+	info->mod_kallsyms_offset = offsetof(struct module, kallsyms);
+
+	return kmemdump_register_backend(&kinfo->kinfo_be);
+}
+
+static void debug_kinfo_remove(struct platform_device *pdev)
+{
+	kfree(kinfo);
+	kmemdump_unregister_backend(&kinfo->kinfo_be);
+}
+
+static const struct of_device_id debug_kinfo_of_match[] = {
+	{ .compatible	= "google,debug-kinfo" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, debug_kinfo_of_match);
+
+static struct platform_driver debug_kinfo_driver = {
+	.probe = debug_kinfo_probe,
+	.remove = debug_kinfo_remove,
+	.driver = {
+		.name = "debug-kinfo",
+		.of_match_table = of_match_ptr(debug_kinfo_of_match),
+	},
+};
+module_platform_driver(debug_kinfo_driver);
+
+MODULE_AUTHOR("Eugen Hristev <eugen.hristev@linaro.org>");
+MODULE_AUTHOR("Jone Chou <jonechou@google.com>");
+MODULE_DESCRIPTION("Debug Kinfo Driver");
+MODULE_LICENSE("GPL");
-- 
2.43.0


