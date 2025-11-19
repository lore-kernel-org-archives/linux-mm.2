Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98F8DCF34D9
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 15:46:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EB5C6B00CF; Wed, 19 Nov 2025 10:46:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24D546B00D0; Wed, 19 Nov 2025 10:46:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A0A76B00D1; Wed, 19 Nov 2025 10:46:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E1D6D6B00CF
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:46:00 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A9CBE12FA44
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:46:00 +0000 (UTC)
X-FDA: 84127782480.23.D98543B
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf23.hostedemail.com (Postfix) with ESMTP id 923EE140018
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=C5ZI5kYp;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf23.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.45 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763567158; a=rsa-sha256;
	cv=none;
	b=sS/U0k9hffMbB5HF+bA6OccLCuYPjGybJ8jZTAatSbYmUH5MgDqmG0WWloMfQiT4nlnWaf
	xxailj0sPrNcfniuBfcpduCncplnBTzBpKWOMvG5e1d4jTks7f/gmSShcNr3CZcs1dLExa
	ZmmGUyQ/mUQLj7HLbYve9RCYYrvj7II=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=C5ZI5kYp;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf23.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.45 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763567158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aBNrwlYX8KQq53Dd2Ff7QORfdDzZbYxDqKu/vrV5PaM=;
	b=5Sf+FETr/y+wLWcvxNZZC4CZ99DojrIFALwCsV6Mnb/GUhAe3dkMhdSkN5i+rTv6G0mk/n
	dlJqhRMJa5ZH2nzi9ZF3O8YKpiaE9VDuMXLS2V3OcvkYiblv3kto76y1sEccIEv5NyR9ov
	+1cNvYVZvf/5eT8whgnGei06/l8PNfg=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-42b3ac40ae4so4187088f8f.0
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:45:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763567157; x=1764171957; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aBNrwlYX8KQq53Dd2Ff7QORfdDzZbYxDqKu/vrV5PaM=;
        b=C5ZI5kYpZwvhW6EoA4DbNCwSVgDgQGaU1PopF7CFGxfY4OnhVGkXD+0Izri58urLAA
         mLAQliWevFDGha+LlJ9pEUkPafwGOvLGIkbJsKyXxDsuDBCQHB/nR0VwN/VGrrYqXiqq
         Yw4d4jqQaB/u33WZFMJUESyJ5qkE3kpjk1BPwJuC2Sv/O2XS8KTnnnwX5tniKr7T1wmQ
         sGO70m5gYfOmPu+Mj7wCanryFsJVXntht6JhqHANOucOle3p7jJez48VNrqWIsbjzuuR
         hQgY/M3fv65j7ikovuZEaSSb+X+U9YT2YBU/EYHlnfV/c2pcTLsdTWc+EMN2wETn0/p5
         RYQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763567157; x=1764171957;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aBNrwlYX8KQq53Dd2Ff7QORfdDzZbYxDqKu/vrV5PaM=;
        b=ZfGe9slkMT0qmnsNITQH3cs2LnjNADGn8QLvpLtxYsf8CU3O5eM7GCGrseGDQy1bES
         45L2gP8XWRMMd5ZNJ8RfVxAqe5XirawBBBRyFKU16OYZv3giZyzZPeZKAN/rayHz1UUR
         mK2vkjYoKb0Mn3aETNww0ufNvh1YiGGb7wVoNTSkfv2zByqm22K1e6dxzIdaQS8OEwYy
         rPYpXZFz+ei5LJVS8mZmlXkjg2nS2fkRJ8fETsz7PC0orrOx86xVLC8LsorrDsYDHYoH
         lyiUFeAaEYzxuCXYre60O6OXQoiwdzFuv/++Sx4Sc+FTlIUFdrrW2ETxIaLWVt2Bu6q2
         0M4A==
X-Forwarded-Encrypted: i=1; AJvYcCUXeE5F7cXBbvCXIIskLAwJan2LJQfehnjxTZJpPCOzAa6OVGTo1XFXqHWSVCH4LOij7qnyqRxqqQ==@kvack.org
X-Gm-Message-State: AOJu0YzWoe/plzxMawF+TTyCgiIeFKQ6dkZ8iQwNw1SDJ2romP4PRx+k
	UudIMSDgEhiNGUg9EM5cVUJZEnxuDAiDsZ1oVMOm3qGogiY4+vt/1vu1EDICfcvEM48=
X-Gm-Gg: ASbGncs2hXo9iglw3PLOajfkrHiix3tWn/BuCdVmueLXhLVdMYuB+kgB2Z0g/jTOFwY
	4118Juv+3ecPNNDaYplYpdT/VlfZs+Z4GP/qvFBEccb2Ozw6l5NO5ubxfoMSbvwdTL2ppVJsO9j
	HbnWDYoBU1Fx4NIEwST8bzDN0MbG09HxHH4S0tgL3GsH92INVUhP46QjRNv7YY7NVhmhlmUd9Ir
	tfSnRTnn9H8/3U9UQM1Tuwed5f3W+bQqpdwKbuRslpl+aHsRFBk3elal/PFNpqkkBIQgdoNKCHW
	hY0GAuEarGEhyhwib7vKBhNi29Vjk5Z7/g7q0fym84ZVYhFlTlHmg7qUqNYjzB5TrJu8U/g6fn7
	WITWBviBb6EHn7QCXqQgvcA80Wx0vRCQTBE90hiES3KVLmmP87U/k/ywi0qoHnxMbYuRh/z/hKO
	Q+jXAs0pwe2stttXTsie8=
X-Google-Smtp-Source: AGHT+IHMsSbrwKXE/iT+c2iGpRnN+BNbOo3hGgZttZwiDhEyh5x/2x4kZMct8HS2b5hiT6bCYQDvdQ==
X-Received: by 2002:a05:6000:2083:b0:42b:3867:b39c with SMTP id ffacd0b85a97d-42b593745c4mr20164142f8f.34.1763567157017;
        Wed, 19 Nov 2025 07:45:57 -0800 (PST)
Received: from eugen-station.. ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53dea1c9sm38765632f8f.0.2025.11.19.07.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 07:45:56 -0800 (PST)
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
Subject: [PATCH 23/26] soc: qcom: Add minidump driver
Date: Wed, 19 Nov 2025 17:44:24 +0200
Message-ID: <20251119154427.1033475-24-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251119154427.1033475-1-eugen.hristev@linaro.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 923EE140018
X-Stat-Signature: 94hx4uxow68ec453zj19zk4sur96r1dc
X-HE-Tag: 1763567158-694188
X-HE-Meta: U2FsdGVkX1+L5gQbmLq5C8LMLyIdECPCTq3cH5V0+QPkM0xozXmLdw7TsqOBaq4owg98hSWJey850pYZw8Rp4qZ3Bm5D+KKvOzlqP4P2KgMt5nRF16+Jt6EXr9K9DZLKpQQ82AjQsgsMLljIJ2C71xMfUPvdTab2eqopLRldjDEm9cG3sIr/36dJTRNboep/6vzniI4dNIzQZ7T0QlSZhN/v++3//bU5cQzvhi4UO84icaKe8Sxw8inUVVkyJusd1fPFIaxWm5wHrYaoPCi17XggygGeypweUdCzFM05xKHNESpoBHiV0DMEQYXkCwn6frnrmGrOOfPX5DB/7Yp+xFnqIJuLC1C9R32wvNtKGGqVdaGH0QAAMOYjvBadHefM2QLHdK/5YZ16zvamNrkZ9vnh8zc/YKMZBpRa0rBfHNslR8z4v26aBQFrKHHLBjg4P9Cv9pIbBLh4D8mqd7Oh9HKCMclaGBB9+iaer1xa4K6J7HCV/gxNlh8jq5L+PWz/UEoParnqPwk8QgSlXlMm+NpUW7wh8SlOHZKfVDAN+0QY5Y5PzXcU0dQlDHi8vwnlyHa7nOOdixOXg9KPMDraIORoIBfU0ctm1EjOab8m++9fQWMOuYp5dL93Eom8HMkewACIhbvupck7g5bLizIBcTc+cnIVt+z0Vv6FoJhKzfyoCeVpcPXCTPCSDKgOXOhTkxDS19Qbc5nXPahFcWaZbMAKC3MaOn+O4zplUgt52UWLGpBUX4HVMze7FTUmgPZQGJ9YFC3CkTvox0rCykPVf6lOTmz4GbEiwJSWGo8gg+j/MIIll28jSFpEUwbRuuAlGGXM2orFCox3jIeZQxxl5LG0wUWVLobijrT7S+ipW/2N+Ir7au8Tda378kMKBlQfE1Qc8yZnv2G5l6izr5GeMtXfMiP4Ka7L2WoYLJTwdot8jsovuVDmgld56/QMAeiFY7Bzs6ybPp36PaeJ7j/
 hYafXXQm
 HsbwFTUH9byUb1AmlLcLjWw8SKDJNfHQReKt8b//L/eDc2ZsTrtk+2GP8yq5M0ngHhuB7ab1ByFP+jOYw4wsLbZ7cj1lVXi73Ot48exlcOBg1uOdtSw3uL4LdwxUqdjNzo50anxWLUvCbK4fCjC1pIQCJb6FctAjEa8HYgJ7rI+wNwrp66xM8GFVQIVwFYfklmKLGmZVQJe/fTXrrE3WHL7/jlIz1Fim5hIuZF2WvraN3aPSMVENu5YTJ0CJx6PT0V9M27BoyhTlD6F04lSCHkqHcf7JR7+cJi8c6e2ArNj6pysZYfNFscB6P+O/6PaiN83D4Ws6qq99RlvQDBsg0o9ZGcjy9hBukxMXeuRhs/vrl/vlnvbvrknyUxjkpqpNsjhn2eAxfjdQp64MOulivQV+n9YOgwjEtuisWRnpuauuuhhlFU7P0gnv+z5Hp9RtNqE9veWS6WJ11WUrgsGBwWdYQMFva/T8mik4KeLqc023mAthgIFNz1uJCeQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Qualcomm Minidump is a driver that manages the minidump shared memory
table on Qualcomm platforms.
It uses the meminspect table that it parses , in order to obtain inspection
entries from the kernel, and convert them into regions.
Regions are afterwards being registered into the shared memory
and into the table of contents.
Further, the firmware can read the table of contents and dump the memory
accordingly, as per the firmware requirements.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 drivers/soc/qcom/Kconfig          |  13 ++
 drivers/soc/qcom/Makefile         |   1 +
 drivers/soc/qcom/minidump.c       | 272 ++++++++++++++++++++++++++++++
 include/linux/soc/qcom/minidump.h |   4 +
 4 files changed, 290 insertions(+)
 create mode 100644 drivers/soc/qcom/minidump.c

diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
index 2caadbbcf830..be768537528e 100644
--- a/drivers/soc/qcom/Kconfig
+++ b/drivers/soc/qcom/Kconfig
@@ -180,6 +180,19 @@ config QCOM_SMEM
 	  The driver provides an interface to items in a heap shared among all
 	  processors in a Qualcomm platform.
 
+config QCOM_MINIDUMP
+	tristate "Qualcomm Minidump memory inspection driver"
+	depends on ARCH_QCOM || COMPILE_TEST
+	depends on QCOM_SMEM
+	help
+	  Say y here to enable the Qualcomm Minidump memory inspection driver.
+	  This driver uses memory inspection mechanism to register minidump
+	  regions with the Qualcomm firmware, into the shared memory.
+	  The registered regions are being linked into the minidump table
+	  of contents.
+	  Further on, the firmware will be able to read the table of contents
+	  and extract the memory regions on case-by-case basis.
+
 config QCOM_SMD_RPM
 	tristate "Qualcomm Resource Power Manager (RPM) over SMD"
 	depends on ARCH_QCOM || COMPILE_TEST
diff --git a/drivers/soc/qcom/Makefile b/drivers/soc/qcom/Makefile
index b7f1d2a57367..3e5a2cacccd4 100644
--- a/drivers/soc/qcom/Makefile
+++ b/drivers/soc/qcom/Makefile
@@ -25,6 +25,7 @@ qcom_rpmh-y			+= rpmh.o
 obj-$(CONFIG_QCOM_SMD_RPM)	+= rpm-proc.o smd-rpm.o
 obj-$(CONFIG_QCOM_SMEM) +=	smem.o
 obj-$(CONFIG_QCOM_SMEM_STATE) += smem_state.o
+obj-$(CONFIG_QCOM_MINIDUMP)	+= minidump.o
 CFLAGS_smp2p.o := -I$(src)
 obj-$(CONFIG_QCOM_SMP2P)	+= smp2p.o
 obj-$(CONFIG_QCOM_SMSM)	+= smsm.o
diff --git a/drivers/soc/qcom/minidump.c b/drivers/soc/qcom/minidump.c
new file mode 100644
index 000000000000..67ebbf09c171
--- /dev/null
+++ b/drivers/soc/qcom/minidump.c
@@ -0,0 +1,272 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Qualcomm Minidump kernel inspect driver
+ * Copyright (C) 2016,2024-2025 Linaro Ltd
+ * Copyright (C) 2015 Sony Mobile Communications Inc
+ * Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
+ */
+
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/notifier.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+#include <linux/soc/qcom/smem.h>
+#include <linux/soc/qcom/minidump.h>
+#include <linux/meminspect.h>
+
+/**
+ * struct minidump - Minidump driver data information
+ *
+ * @dev:	Minidump device struct.
+ * @toc:	Minidump table of contents subsystem.
+ * @regions:	Minidump regions array.
+ * @nb:		Notifier block to register to meminspect.
+ */
+struct minidump {
+	struct device			*dev;
+	struct minidump_subsystem	*toc;
+	struct minidump_region		*regions;
+	struct notifier_block		nb;
+};
+
+static const char * const meminspect_id_to_md_string[] = {
+	"",
+	"ELF",
+	"vmcoreinfo",
+	"config",
+	"totalram",
+	"cpu_possible",
+	"cpu_present",
+	"cpu_online",
+	"cpu_active",
+	"mem_section",
+	"jiffies",
+	"linux_banner",
+	"nr_threads",
+	"nr_irqs",
+	"tainted_mask",
+	"taint_flags",
+	"node_states",
+	"__per_cpu_offset",
+	"nr_swapfiles",
+	"init_uts_ns",
+	"printk_rb_static",
+	"printk_rb_dynamic",
+	"prb",
+	"prb_descs",
+	"prb_infos",
+	"prb_data",
+	"high_memory",
+	"init_mm",
+	"init_mm_pgd",
+};
+
+/**
+ * qcom_md_table_init() - Initialize the minidump table
+ * @md: minidump data
+ * @mdss_toc: minidump subsystem table of contents
+ *
+ * Return: On success, it returns 0 and negative error value on failure.
+ */
+static int qcom_md_table_init(struct minidump *md,
+			      struct minidump_subsystem *mdss_toc)
+{
+	md->toc = mdss_toc;
+	md->regions = devm_kcalloc(md->dev, MAX_NUM_REGIONS,
+				   sizeof(*md->regions), GFP_KERNEL);
+	if (!md->regions)
+		return -ENOMEM;
+
+	md->toc->regions_baseptr = cpu_to_le64(virt_to_phys(md->regions));
+	md->toc->enabled = cpu_to_le32(MINIDUMP_SS_ENABLED);
+	md->toc->status = cpu_to_le32(1);
+	md->toc->region_count = cpu_to_le32(0);
+
+	/* Tell bootloader not to encrypt the regions of this subsystem */
+	md->toc->encryption_status = cpu_to_le32(MINIDUMP_SS_ENCR_DONE);
+	md->toc->encryption_required = cpu_to_le32(MINIDUMP_SS_ENCR_NOTREQ);
+
+	return 0;
+}
+
+/**
+ * qcom_md_get_region_index() - Lookup minidump region by id
+ * @md: minidump data
+ * @id: minidump region id
+ *
+ * Return: On success, it returns the internal region index, on failure,
+ *	returns	negative error value
+ */
+static int qcom_md_get_region_index(struct minidump *md, int id)
+{
+	unsigned int count = le32_to_cpu(md->toc->region_count);
+	unsigned int i;
+
+	for (i = 0; i < count; i++)
+		if (md->regions[i].seq_num == id)
+			return i;
+
+	return -ENOENT;
+}
+
+/**
+ * register_md_region() - Register a new minidump region
+ * @priv: private data
+ * @e: pointer to inspect entry
+ *
+ * Return: None
+ */
+static void __maybe_unused register_md_region(void *priv,
+					      const struct inspect_entry *e)
+{
+	unsigned int num_region, region_cnt;
+	const char *name = "unknown";
+	struct minidump_region *mdr;
+	struct minidump *md = priv;
+
+	if (!(e->va || e->pa) || !e->size) {
+		dev_dbg(md->dev, "invalid region requested\n");
+		return;
+	}
+
+	if (e->id < ARRAY_SIZE(meminspect_id_to_md_string))
+		name = meminspect_id_to_md_string[e->id];
+
+	if (qcom_md_get_region_index(md, e->id) >= 0) {
+		dev_dbg(md->dev, "%s:%d region is already registered\n",
+			name, e->id);
+		return;
+	}
+
+	/* Check if there is a room for a new entry */
+	num_region = le32_to_cpu(md->toc->region_count);
+	if (num_region >= MAX_NUM_REGIONS) {
+		dev_dbg(md->dev, "maximum region limit %u reached\n",
+			num_region);
+		return;
+	}
+
+	region_cnt = le32_to_cpu(md->toc->region_count);
+	mdr = &md->regions[region_cnt];
+	scnprintf(mdr->name, MAX_REGION_NAME_LENGTH, "K%.8s", name);
+	mdr->seq_num = e->id;
+	if (e->pa)
+		mdr->address = cpu_to_le64(e->pa);
+	else if (e->va)
+		mdr->address = cpu_to_le64(__pa(e->va));
+	mdr->size = cpu_to_le64(ALIGN(e->size, 4));
+	mdr->valid = cpu_to_le32(MINIDUMP_REGION_VALID);
+	region_cnt++;
+	md->toc->region_count = cpu_to_le32(region_cnt);
+
+	dev_dbg(md->dev, "%s:%d region registered %llx:%llx\n",
+		mdr->name, mdr->seq_num, mdr->address, mdr->size);
+}
+
+/**
+ * unregister_md_region() - Unregister a previously registered minidump region
+ * @priv: private data
+ * @e: pointer to inspect entry
+ *
+ * Return: None
+ */
+static void __maybe_unused unregister_md_region(void *priv,
+						const struct inspect_entry *e)
+{
+	struct minidump_region *mdr;
+	struct minidump *md = priv;
+	unsigned int region_cnt;
+	unsigned int idx;
+
+	idx = qcom_md_get_region_index(md, e->id);
+	if (idx < 0) {
+		dev_dbg(md->dev, "%d region is not present\n", e->id);
+		return;
+	}
+
+	mdr = &md->regions[0];
+	region_cnt = le32_to_cpu(md->toc->region_count);
+
+	/*
+	 * Left shift one position all the regions located after the
+	 * region being removed, in order to fill the gap.
+	 * Then, zero out the last region at the end.
+	 */
+	memmove(&mdr[idx], &mdr[idx + 1], (region_cnt - idx - 1) * sizeof(*mdr));
+	memset(&mdr[region_cnt - 1], 0, sizeof(*mdr));
+	region_cnt--;
+	md->toc->region_count = cpu_to_le32(region_cnt);
+}
+
+static int qcom_md_notifier_cb(struct notifier_block *nb,
+			       unsigned long code, void *entry)
+{
+	struct minidump *md = container_of(nb, struct minidump, nb);
+
+	if (code == MEMINSPECT_NOTIFIER_ADD)
+		register_md_region(md, entry);
+	else if (code == MEMINSPECT_NOTIFIER_REMOVE)
+		unregister_md_region(md, entry);
+
+	return 0;
+}
+
+static int qcom_md_probe(struct platform_device *pdev)
+{
+	struct minidump_global_toc *mdgtoc;
+	struct device *dev = &pdev->dev;
+	struct minidump *md;
+	size_t size;
+	int ret;
+
+	md = devm_kzalloc(dev, sizeof(*md), GFP_KERNEL);
+	if (!md)
+		return -ENOMEM;
+	platform_set_drvdata(pdev, md);
+
+	md->dev = dev;
+	md->nb.notifier_call = qcom_md_notifier_cb;
+
+	mdgtoc = qcom_smem_get(QCOM_SMEM_HOST_ANY, SBL_MINIDUMP_SMEM_ID, &size);
+	if (IS_ERR(mdgtoc)) {
+		ret = PTR_ERR(mdgtoc);
+		dev_err_probe(dev, ret, "Couldn't find minidump smem item\n");
+	}
+
+	if (size < sizeof(*mdgtoc) || !mdgtoc->status)
+		dev_err_probe(dev, -EINVAL, "minidump table not ready\n");
+
+	ret = qcom_md_table_init(md, &mdgtoc->subsystems[MINIDUMP_SUBSYSTEM_APSS]);
+	if (ret)
+		dev_err_probe(dev, ret, "Could not initialize table\n");
+
+	meminspect_notifier_register(&md->nb);
+
+	meminspect_lock_traverse(md, register_md_region);
+	return 0;
+}
+
+static void qcom_md_remove(struct platform_device *pdev)
+{
+	struct minidump *md = platform_get_drvdata(pdev);
+
+	meminspect_notifier_unregister(&md->nb);
+	meminspect_lock_traverse(md, unregister_md_region);
+}
+
+static struct platform_driver qcom_md_driver = {
+	.probe = qcom_md_probe,
+	.remove = qcom_md_remove,
+	.driver  = {
+		.name = "qcom-minidump",
+	},
+};
+
+module_platform_driver(qcom_md_driver);
+
+MODULE_AUTHOR("Eugen Hristev <eugen.hristev@linaro.org>");
+MODULE_AUTHOR("Mukesh Ojha <quic_mojha@quicinc.com>");
+MODULE_DESCRIPTION("Qualcomm minidump inspect driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/soc/qcom/minidump.h b/include/linux/soc/qcom/minidump.h
index 25247a6216e2..f90b61feb550 100644
--- a/include/linux/soc/qcom/minidump.h
+++ b/include/linux/soc/qcom/minidump.h
@@ -10,12 +10,16 @@
 #ifndef __QCOM_MINIDUMP_H__
 #define __QCOM_MINIDUMP_H__
 
+#define MINIDUMP_SUBSYSTEM_APSS	0
 #define MAX_NUM_OF_SS           10
 #define MAX_REGION_NAME_LENGTH  16
 #define SBL_MINIDUMP_SMEM_ID	602
 #define MINIDUMP_REGION_VALID		('V' << 24 | 'A' << 16 | 'L' << 8 | 'I' << 0)
 #define MINIDUMP_SS_ENCR_DONE		('D' << 24 | 'O' << 16 | 'N' << 8 | 'E' << 0)
+#define MINIDUMP_SS_ENCR_NOTREQ		(0 << 24 | 0 << 16 | 'N' << 8 | 'R' << 0)
 #define MINIDUMP_SS_ENABLED		('E' << 24 | 'N' << 16 | 'B' << 8 | 'L' << 0)
+#define MAX_NUM_REGIONS		201
+
 
 /**
  * struct minidump_region - Minidump region
-- 
2.43.0


