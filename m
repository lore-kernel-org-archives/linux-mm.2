Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 142ABCF3941
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 15:46:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 360806B00A1; Wed, 19 Nov 2025 10:46:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E95D6B00A2; Wed, 19 Nov 2025 10:46:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18A286B00D4; Wed, 19 Nov 2025 10:46:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 015E26B00A1
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:46:05 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C876E12FA3E
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:46:05 +0000 (UTC)
X-FDA: 84127782690.09.A2B69C8
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf13.hostedemail.com (Postfix) with ESMTP id C3B8C20017
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:46:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=Yvo0K5lG;
	spf=pass (imf13.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.41 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763567163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vjdG1/a5AFb8CurP464/OyK+i/niRA2OFjF7IXQ6EqU=;
	b=yw7XRutWuxhDhDgTOIZVL8zz/HtHk6sYQSOLFW0hFDCM9k+ebTdJLuV2ig9i4nUS1dfmrD
	Ttaw2alIiNb5MfbH8A5SVvwet1VYXOzRAEmt6vHcW4EvV0MxyfsbIH1AVyNYbKYivsHk10
	oNFbkeB8CnUbGukq2lpDgmWAyMiyXG4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763567163; a=rsa-sha256;
	cv=none;
	b=qQ8LoXLLg7dw7FfojtmWN5CgELY8lXCNKyhIcD7HtLdPFU1cvwVyuRfrIa4oBOT/IYhBt0
	1RTCNjXxaTvcOzRygWWaIMgjUwg9Cyo7DPBa/L1gP0Xc5jTbEp/SDRAK+R+3WEhVLZM9As
	77l8tAvePEPs6sFTQo7HyXNuJbstivw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=Yvo0K5lG;
	spf=pass (imf13.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.41 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-42bb288c219so3583434f8f.1
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:46:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763567162; x=1764171962; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vjdG1/a5AFb8CurP464/OyK+i/niRA2OFjF7IXQ6EqU=;
        b=Yvo0K5lGDY5Ba6/wnoBVltZkiJoEn/jKFFT3tBcFxOKrKjd8kjAEBRyapEeQwKPZE0
         tkoMJzELtdu9eXxbd0NWEwTYgI4UVkxLDuw/65ovsBieiVMOREpIuEapmQUNuD8kHpwI
         GLOd/fqsGj1Hc4VK7D/QXGr7zN5uB3q1prcv7zTadMxydlJT2pQLAfEQS4zjQgGfVwAn
         Tytgvbuugh1UBTYXvIeC/3tXYZFM/qo5S8pLnIdyct6D78rBXyN0N7kvryeRKgLbJiqN
         b5ga8p1ylGBYaBtiXZJ8Th9vG8iZt9CRMqwoKn2q/Dgw4o0DL2xFARf2BUhey2MyfG5E
         J1DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763567162; x=1764171962;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vjdG1/a5AFb8CurP464/OyK+i/niRA2OFjF7IXQ6EqU=;
        b=tbjHKZLCnvHZMpAaG+55GCuIjnOxpJWMRsJVmGI7cDoF8Rkq4aD8kGb8398KfU1iVs
         fpzcoQqEsrYnBdlUkXrUIMigEoYgtWQYftA0FC5aw3EUXpsONb8C2W8peBoJxAWEOKMS
         Wzq3AF08ZQbXKWtana7Secj2UIxPByqH5V7uThNmlCzl1AMZxScI0DgFMHxGWfFymFcJ
         rNwRwsmJSNxa5lBxpVDQDMOD2+c1gxa5TdFBXfyk25A9hdM1gPOwQ07ZQZbVMdqTmQIS
         VZjgV2y7A/XcSUwjHWVj1tGik7Y6OehMT2AcWr/RzPzk/pLLwTVVQGCu+5Jtc7LuMPAz
         uiBA==
X-Forwarded-Encrypted: i=1; AJvYcCXfeGkA+KRdcGjW+AVnajs8d7pBlHdAABy1r5Nsk7RR8bxsWnwVZoD5uS4o77GCMaIHAgjls5nYOA==@kvack.org
X-Gm-Message-State: AOJu0YxUXXARr9FyVQ9hN0kupDXKs8amF7ve5GZUtrjVu6rwKOB1DeOJ
	Wj0d2RvqfKCW3JS0JmI7gbomExDvrgq+K0DuOJgZhrTHjpMpfORNEt1otMYcnhKM9zE=
X-Gm-Gg: ASbGncttkxaGbrbULBlRkcbvaSHv+FVeQwaw4cVR7cKihsCXj7eLcXfaif47OAmyby6
	/nKjVgBgsdomxVNR1W5kOxJxqvWJDSgODv+F7Z7uiIbHB1xuFF0b2Qgy3bI8W16I9QI/mw3f+op
	4JNnw0sSkdoCSF8bTf8WqfcWB6/UgvARzCQslgGopYYPppKf8/fYCLH8Q2VylhTQXCSbUbvdJ1G
	aV/YsvYMcY1OprT3E+k/RqfFpa+jRQEOF7DPNwVTKhKYbzk4WNXwiw0V5LbP4aRNSkHoxyMEAN5
	ENxZwIT6KwPcMV5yxsdl65snrU7sR7MZ3GPXemlQ3ya5nsAy7Xlstr0Zs5lz1I0nh5J53vUoW3n
	qI0tCAusaaOio1TQ5EebMaEw6VbZmCTMBxy2VtJdZFnnAMX8O8Q+u7VllBKilmC5PTwLMrlUudN
	Jeg/bjRDqPzv5G8z7ahLNowtJb94E8Wg==
X-Google-Smtp-Source: AGHT+IEYehjZzwQP4QY9mT+/5fGr+NBXUC5zHCL5MMz466EKwRwnbbkUf34pwbvo8KJX34cdlYI+Ug==
X-Received: by 2002:a05:6000:657:b0:400:7e60:7ee0 with SMTP id ffacd0b85a97d-42b592d8549mr20248098f8f.0.1763567162304;
        Wed, 19 Nov 2025 07:46:02 -0800 (PST)
Received: from eugen-station.. ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53dea1c9sm38765632f8f.0.2025.11.19.07.46.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 07:46:01 -0800 (PST)
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
	linux-remoteproc@vger.kernel.org,
	linux-arch@vger.kernel.org,
	tony.luck@intel.com,
	kees@kernel.org,
	Eugen Hristev <eugen.hristev@linaro.org>
Subject: [PATCH 26/26] meminspect: Add Kinfo compatible driver
Date: Wed, 19 Nov 2025 17:44:27 +0200
Message-ID: <20251119154427.1033475-27-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251119154427.1033475-1-eugen.hristev@linaro.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C3B8C20017
X-Stat-Signature: nczhqa3hcyodfbemy1hszbdw9rh96bzd
X-Rspam-User: 
X-HE-Tag: 1763567163-651790
X-HE-Meta: U2FsdGVkX1/BlKTYSGMIX3g1IQGImJS0k2j51lzfpkIH3ecsbMxdcMhgHqaRB/URs3v/31+b9SQd5pPACxm2AExtYFYi/NiNNYC0vc+r25RA7FYScjWZmp2dQmYBL8kmWFuok0aKsLPytl9HED3b21pFjJXhvRg0iioJo77k5nmOmJAHjvC6M7tGBgfJTC+RqvSQapU7HPsmpby2mSYy8RGuvwqKr4yCcg8ulauB4g1k9pqNg1j6gzazffIbQbZ3TGbz2P8Xq4AxnTbIn1utVVFPxsxDWBLhIlT/f8/N6AeCcmqdwx25pADFlzLV7Jp9RAZIFzThtM5S9ltIiVz2WVZuRx56Rhd72YJ+rUFYCM/uCK5rqFniJCm1KMxhHnBtevwNLo9wki9N3K19JjEDmLyvaJ2H5hUOXvBNoOrs1eKwSgbkz71/N2UPUSg6pOrD6ri6Sj6tUPUBEJN9qHbWLz3FvIYnUyeT7akVv+pm5sZgd1rYp/8aKv80j52UD3S+iYVcim3vwlcllKRhVhfz3gDKZJyChsFtmru4ikfeRysszk66ZF5InAkd2saxQR6P9q+4mOP/LmOaFc0ptAnNhR/k+6Tmag4kXm952IQDfxFeuHkL1Aydl3LlCgwBYdZxWbifbtYjORAQzU56W1T22xRqdGPEh/Bn1NMUmJ7MPcnRH7fp4267/OjOYQHoPjiseqs12LzNam2XPWKc2GQzkzn7d2tI5Rpl2iyzC69CA+n8Jnjpi6dVxKghbhAs5zUkRAEXHMrSJh6QWwCfPyWJSSThCNs7EHZmyBp2tju7QIodum/mP6EIY8KTPTWZ4Qe17rSgfjK6wMtH08AOD1BDkzab24RIlYkAh+1S9j5ktBD+DaceeJMja/AcwUiJFc9aR54X3FhUykBfxxn6qhlJqliohlile4iApeT8j3EfDAsbtFzp2Mpc1/2rMPh+X7FYU2A7k4nCORo445OByLr
 vNNow8pF
 mJ234wDCI4YsWHwRZvRM9m+Y19UqghzNIW2pfWunZPPF0QtZw2usR7ZHzWovuwNfg9L4q3C/UL4jJOZVizonbyS6DhO4fFBIRO71OxdE0zAWqVykOb5xUiK/VH2dkT5g1Imzhw+B3eCtnmfjz8Azs/DvLnX316t7tzwTS/RKlY98Y8ORBF/ZGda7E6hqlV5AsfYt1+ybj6HA8yP+4MJfLYX8zYZyYwZQD57bBnFkAdr3Rv1/m8YcreJSK7Y9TtamHi8sSut3VpDk7gP3gp7ViQloXpEg/io5EXfRlPal9RbGJ8LBdWWDuSpJdojah+SxQZsjraVxKHmSXa5DpP9VXMvupOAYGaG3PmtAxZr5Ua1unQESqzN1BfXQPgpai6ygdPtk5lz207ZfhOXFffgkjYhiVhDAz4GNXxorfGfTusTmF7h1AXB4i5D38/iALJ5gKm4leUL95xzmdXdovKYBQs9lfDYxd5eamaXvTRi+J3lY86F7cSQpcw2j7OeX6q8zf6GXmijPtxijhnnQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With this driver, the registered regions are copied to a shared
memory zone at register time.
The shared memory zone is supplied via OF.
This driver will select only regions that are of interest,
and keep only addresses. The format of the list is Kinfo compatible,
with devices like Google Pixel phone.
The firmware is only interested in some symbols' addresses.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 MAINTAINERS                |   1 +
 kernel/meminspect/Kconfig  |  10 ++
 kernel/meminspect/Makefile |   1 +
 kernel/meminspect/kinfo.c  | 289 +++++++++++++++++++++++++++++++++++++
 4 files changed, 301 insertions(+)
 create mode 100644 kernel/meminspect/kinfo.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 8034940d0b1e..9cba0e472e01 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16168,6 +16168,7 @@ MEMINSPECT KINFO DRIVER
 M:	Eugen Hristev <eugen.hristev@linaro.org>
 S:	Maintained
 F:	Documentation/devicetree/bindings/misc/google,kinfo.yaml
+F:	kernel/meminspect/kinfo.c
 
 MEMBLOCK AND MEMORY MANAGEMENT INITIALIZATION
 M:	Mike Rapoport <rppt@kernel.org>
diff --git a/kernel/meminspect/Kconfig b/kernel/meminspect/Kconfig
index 8680fbf0e285..396510908e47 100644
--- a/kernel/meminspect/Kconfig
+++ b/kernel/meminspect/Kconfig
@@ -18,3 +18,13 @@ config MEMINSPECT
 	  Note that modules using this feature must be rebuilt if option
 	  changes.
 
+config MEMINSPECT_KINFO
+	tristate "Shared memory KInfo compatible driver"
+	depends on MEMINSPECT
+	help
+	  Say y here to enable the Shared memory KInfo compatible driver
+	  With this driver, the registered regions are copied to a shared
+	  memory zone at register time.
+	  The shared memory zone is supplied via OF.
+	  This driver will select only regions that are of interest,
+	  and keep only addresses. The format of the list is Kinfo compatible.
diff --git a/kernel/meminspect/Makefile b/kernel/meminspect/Makefile
index 09fd55e6d9cf..283604d892e5 100644
--- a/kernel/meminspect/Makefile
+++ b/kernel/meminspect/Makefile
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 
 obj-$(CONFIG_MEMINSPECT) += meminspect.o
+obj-$(CONFIG_MEMINSPECT_KINFO) += kinfo.o
diff --git a/kernel/meminspect/kinfo.c b/kernel/meminspect/kinfo.c
new file mode 100644
index 000000000000..62f8ee7a66a9
--- /dev/null
+++ b/kernel/meminspect/kinfo.c
@@ -0,0 +1,289 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ *
+ * Copyright 2002 Rusty Russell <rusty@rustcorp.com.au> IBM Corporation
+ * Copyright 2021 Google LLC
+ * Copyright 2025 Linaro Ltd. Eugen Hristev <eugen.hristev@linaro.org>
+ */
+#include <linux/container_of.h>
+#include <linux/kallsyms.h>
+#include <linux/meminspect.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_reserved_mem.h>
+#include <linux/platform_device.h>
+#include <linux/utsname.h>
+
+#define BUILD_INFO_LEN		256
+#define DEBUG_KINFO_MAGIC	0xcceeddff
+
+/*
+ * Header structure must be byte-packed, since the table is provided to
+ * bootloader.
+ */
+struct kernel_info {
+	/* For kallsyms */
+	u8 enabled_all;
+	u8 enabled_base_relative;
+	u8 enabled_absolute_percpu;
+	u8 enabled_cfi_clang;
+	u32 num_syms;
+	u16 name_len;
+	u16 bit_per_long;
+	u16 module_name_len;
+	u16 symbol_len;
+	u64 _relative_pa;
+	u64 _text_pa;
+	u64 _stext_pa;
+	u64 _etext_pa;
+	u64 _sinittext_pa;
+	u64 _einittext_pa;
+	u64 _end_pa;
+	u64 _offsets_pa;
+	u64 _names_pa;
+	u64 _token_table_pa;
+	u64 _token_index_pa;
+	u64 _markers_pa;
+	u64 _seqs_of_names_pa;
+
+	/* For frame pointer */
+	u32 thread_size;
+
+	/* For virt_to_phys */
+	u64 swapper_pg_dir_pa;
+
+	/* For linux banner */
+	u8 last_uts_release[__NEW_UTS_LEN];
+
+	/* Info of running build */
+	u8 build_info[BUILD_INFO_LEN];
+
+	/* For module kallsyms */
+	u32 enabled_modules_tree_lookup;
+	u32 mod_mem_offset;
+	u32 mod_kallsyms_offset;
+} __packed;
+
+struct kernel_all_info {
+	u32 magic_number;
+	u32 combined_checksum;
+	struct kernel_info info;
+} __packed;
+
+struct debug_kinfo {
+	struct device *dev;
+	void *all_info_addr;
+	size_t all_info_size;
+	struct notifier_block nb;
+};
+
+static void update_kernel_all_info(struct kernel_all_info *all_info)
+{
+	struct kernel_info *info;
+	u32 *checksum_info;
+	int index;
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
+static u8 global_build_info[BUILD_INFO_LEN];
+
+static int build_info_set(const char *str, const struct kernel_param *kp)
+{
+	size_t build_info_size = sizeof(global_build_info);
+
+	if (strlen(str) > build_info_size)
+		return -ENOMEM;
+	memcpy(global_build_info, str, min(build_info_size - 1, strlen(str)));
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
+static void __maybe_unused register_kinfo_region(void *priv,
+						 const struct inspect_entry *e)
+{
+	struct debug_kinfo *kinfo = priv;
+	struct kernel_all_info *all_info = kinfo->all_info_addr;
+	struct kernel_info *info = &all_info->info;
+	struct uts_namespace *uts;
+	u64 paddr;
+
+	if (e->pa)
+		paddr = e->pa;
+	else
+		paddr = __pa(e->va);
+
+	switch (e->id) {
+	case MEMINSPECT_ID__sinittext:
+		info->_sinittext_pa = paddr;
+		break;
+	case MEMINSPECT_ID__einittext:
+		info->_einittext_pa = paddr;
+		break;
+	case MEMINSPECT_ID__end:
+		info->_end_pa = paddr;
+		break;
+	case MEMINSPECT_ID__text:
+		info->_text_pa = paddr;
+		break;
+	case MEMINSPECT_ID__stext:
+		info->_stext_pa = paddr;
+		break;
+	case MEMINSPECT_ID__etext:
+		info->_etext_pa = paddr;
+		break;
+	case MEMINSPECT_ID_kallsyms_num_syms:
+		info->num_syms = *(__u32 *)e->va;
+		break;
+	case MEMINSPECT_ID_kallsyms_relative_base:
+		info->_relative_pa = (u64)__pa(*(u64 *)e->va);
+		break;
+	case MEMINSPECT_ID_kallsyms_offsets:
+		info->_offsets_pa = paddr;
+		break;
+	case MEMINSPECT_ID_kallsyms_names:
+		info->_names_pa = paddr;
+		break;
+	case MEMINSPECT_ID_kallsyms_token_table:
+		info->_token_table_pa = paddr;
+		break;
+	case MEMINSPECT_ID_kallsyms_token_index:
+		info->_token_index_pa = paddr;
+		break;
+	case MEMINSPECT_ID_kallsyms_markers:
+		info->_markers_pa = paddr;
+		break;
+	case MEMINSPECT_ID_kallsyms_seqs_of_names:
+		info->_seqs_of_names_pa = paddr;
+		break;
+	case MEMINSPECT_ID_swapper_pg_dir:
+		info->swapper_pg_dir_pa = paddr;
+		break;
+	case MEMINSPECT_ID_init_uts_ns:
+		if (!e->va)
+			return;
+		uts = e->va;
+		strscpy(info->last_uts_release, uts->name.release, __NEW_UTS_LEN);
+		break;
+	default:
+		break;
+	};
+
+	update_kernel_all_info(all_info);
+}
+
+static int kinfo_notifier_cb(struct notifier_block *nb,
+			     unsigned long code, void *entry)
+{
+	struct debug_kinfo *kinfo = container_of(nb, struct debug_kinfo, nb);
+
+	if (code == MEMINSPECT_NOTIFIER_ADD)
+		register_kinfo_region(kinfo, entry);
+
+	return NOTIFY_DONE;
+}
+
+static int debug_kinfo_probe(struct platform_device *pdev)
+{
+	struct kernel_all_info *all_info;
+	struct device *dev = &pdev->dev;
+	struct device_node *mem_region;
+	struct reserved_mem *rmem;
+	struct debug_kinfo *kinfo;
+	struct kernel_info *info;
+
+	mem_region = of_parse_phandle(dev->of_node, "memory-region", 0);
+	if (!mem_region)
+		return dev_err_probe(dev, -ENODEV, "no such memory-region\n");
+
+	rmem = of_reserved_mem_lookup(mem_region);
+	if (!rmem)
+		return dev_err_probe(dev, -ENODEV, "no such reserved mem of node name %s\n",
+			      dev->of_node->name);
+
+	/* Need to wait for reserved memory to be mapped */
+	if (!rmem->priv)
+		return -EPROBE_DEFER;
+
+	if (!rmem->base || !rmem->size)
+		dev_err_probe(dev, -EINVAL, "unexpected reserved memory\n");
+
+	if (rmem->size < sizeof(struct kernel_all_info))
+		dev_err_probe(dev, -EINVAL, "reserved memory size too small\n");
+
+	kinfo = devm_kzalloc(dev, sizeof(*kinfo), GFP_KERNEL);
+	if (!kinfo)
+		return -ENOMEM;
+	platform_set_drvdata(pdev, kinfo);
+
+	kinfo->dev = dev;
+
+	kinfo->all_info_addr = rmem->priv;
+	kinfo->all_info_size = rmem->size;
+
+	all_info = kinfo->all_info_addr;
+
+	memset(all_info, 0, sizeof(struct kernel_all_info));
+	info = &all_info->info;
+	info->enabled_all = IS_ENABLED(CONFIG_KALLSYMS_ALL);
+	info->enabled_absolute_percpu = IS_ENABLED(CONFIG_KALLSYMS_ABSOLUTE_PERCPU);
+	info->enabled_base_relative = IS_ENABLED(CONFIG_KALLSYMS_BASE_RELATIVE);
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
+	memcpy(info->build_info, global_build_info, strlen(global_build_info));
+
+	kinfo->nb.notifier_call = kinfo_notifier_cb;
+
+	meminspect_notifier_register(&kinfo->nb);
+	meminspect_lock_traverse(kinfo, register_kinfo_region);
+
+	return 0;
+}
+
+static void debug_kinfo_remove(struct platform_device *pdev)
+{
+	struct debug_kinfo *kinfo = platform_get_drvdata(pdev);
+
+	meminspect_notifier_unregister(&kinfo->nb);
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
+MODULE_DESCRIPTION("meminspect Kinfo Driver");
+MODULE_LICENSE("GPL");
-- 
2.43.0


