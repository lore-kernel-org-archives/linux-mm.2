Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3646CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 06:17:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C39336B009F; Fri, 16 Oct 2026 02:17:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C10B86B00A0; Fri, 16 Oct 2026 02:17:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B00676B00A1; Fri, 16 Oct 2026 02:17:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 811316B009F
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 02:17:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 108591C3310
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:17:36 +0000 (UTC)
X-FDA: 85327482912.14.7425143
Received: from mail-pz2-f5.google.com (mail-pz2-f5.google.com [74.125.228.5])
	by imf09.hostedemail.com (Postfix) with ESMTP id 385D1140005
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:17:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CvuKZvFa;
	spf=pass (imf09.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.5 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792131454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ICQyIKowVj3RyrjMn4gMzYuhROzG3qohL1WARXEfQY=;
	b=KU54KiKmcSDi6vzR/PCcFkM6ZYL1QEaqNG9ndbN2LJg9zj3YbThOwf4ws7rcdJSVREjXmS
	PkRWgLnyjFRloLN9Qa/WNWShom6VsovRZy4FytKWeoMBizDqn9WaBq4cp+3/5Gi1mqqVEy
	DTrO9VO7DVq+q1C9ItLjgtxZrW+A1Vc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792131454;
	b=KJFBkVR7Ur4YkFS4cunPy71r6pAJO1Y6/XP9VfGswg/P6sIUIFi/yvaZ2C99PSRT3RuakO
	s7EPvSrdtIYxtuv8o99OWMB6A4ZkD09y9vj5Ne50WQNbsYuHXLSg41HadBSLQFcrR05GPD
	ZezYp5O/b8QdXNRHe78KgOT/zNrJaSQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CvuKZvFa;
	spf=pass (imf09.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.5 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pz2-f5.google.com with SMTP id 41be03b00d2f7-cc7c286026aso1451952a12.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792131453; x=1792736253; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9ICQyIKowVj3RyrjMn4gMzYuhROzG3qohL1WARXEfQY=;
        b=CvuKZvFaJpfmi7BbtFpeqkH9KqjKYJl+jtnUP7DRURRU3HG42DSyFDOZQezlCHWOGS
         TJd6GSN/cAZsz0vD2eu2tttennM8gPF1a02AFu4KzTuXpWdTTPWRfFbdyJpu0/BtUrwj
         wuvkh2iep87JnGhyJ8jRoiuMjzPvC9aZ5di7piVeQ9PETpBCneBaueTSmhDWOBDVhHg2
         gsEJelvoOMw36EPin9u4vDuE9piDhUUK9odEQgT1Aq8O7NB+ZCl7FD47KmFHsMyE5vRv
         iRBRxNztq5+dx6RgXMoiFb7f8ENPlkUl2bJ3HGiNTRQ1R+4g18bBN2Ae3+kU17nQN5D5
         FETg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792131453; x=1792736253;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9ICQyIKowVj3RyrjMn4gMzYuhROzG3qohL1WARXEfQY=;
        b=eC+kuXnPuMZ+OzP3nJc9Jwbf+obbl5xLd4O8/ryMzY5rob5Pixlik3v9mDTI+QKdAW
         idkUFfpWT2yRQ0lcwZ7p3RRP9WB+8BL1kggNXFyeDHQZ8wJyKLwDHk8Lj/vx++MjVIzm
         wpYkbzHbdnlL9zosZROGJWnuYjJjU17+/PkbZu7vm7lhiyrGG39Kr/SC3nbNiMq+1Fkn
         tDedN2AXajGC7KOoACiM7bbbRrgSF/793Ti2j35ROKQ7+wJ/kEeADXxiBNvmRNAd/O7j
         S4csRnYZ6M2t5wM+CLxHIOyLxDj2nkWZF+igrEoQ/+e+pmLj2jH9Bh9prlDH6QOjeLLB
         YP6Q==
X-Forwarded-Encrypted: i=1; AKwUvBxv7l6xRvgNu2J2uY3gnhqY5COi3gDNYBGrEJL/BSM2nGwXRXY7jJFhIZVpqcpnajRHaZSTvwsuiw==@kvack.org
X-Gm-Message-State: AFq9FYITaDZHoyeupFP5xCnrt8KrImG+T5S/gykG/uu5sURQU2Q56YHa
	h5JYGSRMREDxNQWMh6yjbOg3pUjoknVtf5JGgInlsnrhhtz2nmswF01b
X-Gm-Gg: AYBFou2ms3q8dbAtWmA5hqCVnwfFG9vLCVkLtQkG/nkihVE4Z+O8Cz4ORarzBwNo0CL
	ICLOoq7E/UZoAwsa3rfSoFCXAxDL4sCdMBbqCVzxa32SPz1Y8HrGk3TyrmScclpBUtBwFhB8Vs3
	eoVxucVzN1QTI19t7/qBBc0D/sa09EiQo9KCFBOX/Ka0jUz6VU90rhdW2bg8tBpjNoAhj6zT7Tj
	j3bek1pF7IrA8sGDQj9u9nsLDaAYi97dNVgd6XITc48YGVIC1RpFp5wq2pW1qSLt5NyZqkDeItB
	kGLr8GnQK53Io+kt3ggd2+bxErbNYYBwlT0N/xRwWsLbGE/BaUPxyqSJSWaO7FcTh/vuSYaQkt9
	LF0+Awy+A19DkAv+EA4SHspeFb26Qw6sHbFuVLwTH1YZUsUeShEIEjtpSTUxvHHcj9NhKoJX6I2
	4M3PJlNfQtkOB7B+u0R/a/aoCIjMiVXXER0h4o2XozlILHY6Efj4+Yxcq+45WzHMgddTjtfxtzZ
	v3imL0Q9CM=
X-Received: by 2002:a05:6a00:1941:b0:89d:7f51:6492 with SMTP id d2e1a72fcca58-89d7f51698fmr8778955b3a.32.1792131453020;
        Thu, 15 Oct 2026 23:17:33 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89f57b334e6sm586375b3a.42.2026.10.15.23.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 23:17:32 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: robh@kernel.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	m.szyprowski@samsung.com
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	saravanak@kernel.org,
	akpm@linux-foundation.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	ruirui.yang@linux.dev,
	robin.murphy@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: [RESEND PATCH v8 7/8] of: reserved_mem: mark /reserved-memory entries with MEMBLOCK_NODUMP
Date: Fri, 16 Oct 2026 14:15:48 +0800
Message-ID: <20261016061549.4181390-8-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016061549.4181390-1-chenwandun1@gmail.com>
References: <20261016061549.4181390-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 385D1140005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ficqhxtjesfpfmtjh5cokh6e8fpiywut
X-HE-Tag: 1792131454-282598
X-HE-Meta: U2FsdGVkX19vxFv9LFrQvAbCarPeADxnxwGXdII8mpPsmGTsDn/AQP14wW4I0xhAHmOkVm8j1BsSgzcszgNqvspc/yfMnZy+x6opA+yDZdjfMwY1LbteandjsV674kQKFpS1ejV3+XqkTffNfCAKCTZ9rvfLZPbTEN46SahlESl6s6VitPW6pZumGlO5kLWNzV0kNWCBLajIuORjcZ7gHaijAQ8q1tLp6lrrTsf6EoHWTwKk5+LcCkfFL3qc8xhazKq2/jWh4gyMC1Xtv4lpP5go/Docv5MFrxTC+d02M2nFWM6LnUDl8nm5CuQQ8meq1QLeAKaBA1chJ1dnhjW9ie8rtAPCnzY+7EMYNIh5Zmz6qU4jJH9ZxXAWjUO/OvcWiZkTdMNr+e+i333+CmuaRRsEo/D3R51t7yRfiynrF5itVNZbVKDGf48T7yofM43judCXOOUW7lqg22R90OCDDft2tNXlNG942tlSG+2LS0scImBZqMrY7z4Bkjc6CesJc+/25noj3fkyB2ik0bvD3p+1Gh5hO2nEJUl8FoZKbrgwubQFZfcBd4vXCFtgB2C9jmqYV4BGwJw766F1h9Xlu0TjWlHXj5hHqcOv2Zcs+Qi+yzv0VX8+OHEfyVNJHOJHTgV2BELPBT6GVW5SsznQ05RhN6nYmXz7btHhLgNj4qrc5LM4Pt1wvKtIJCV/qaLNfyi6Bjbe6Mk2iXS0nKtfhr7pOpYKmht4LKr8XBEjs2txhuaFMm/btV8HRU7/ImW6Cbj/97yER3OFyPVQSWmSBDby+OT525qAN/CzDxnhL4oHdC7TWQG00Xx/Fws1dOHca/KWjSQ8zs9qdVVvrr0kxjMkpTSQG1/nvqG/lozNJoz17aKYU5qfzjVJTKzoTDXURpVk8hJvCuS3x48nf2YuwJ7vcK6AWbz4dGhhKkGc54QMfufktbcCnJjViMqGcfa0mPC8wMQQ6ltY13zOo4l
 pdQUtDGE
 evA8KN6642pVVKglfdi4EfV4AKjzgw8boTnVxo/wGtVQs8DaPktsA318IuRSoZ8PSbRNX69ySo+YhQKe3P55mWOmVh+NQ++vbTSkOlHJnzsG2dO1LeWmbeGfrDky4yAzaZ8Q2seisiOtRTq6R8vNt268tHeus05kTAGFK1es1dT9+pAyCdgexdNgSZ/9EShlFrMwiGwXW9E0Mm3W1t38IQixolQLLFt4Uyl7rU0mkgo8Y6iVNou5tiDoi9UAViMXWbrL6HDt6FBPzX0fL3f2tefNPPN3BIKY+sTjjvdvIOvA0jTwnM7iX4WnnVrzPycTHZDIjxRVXMseSo3HV7OLgNPfRjml3xjjhPlRcrN98JD/sI1fzjPVlVKblTCGLp5lAThaw+s8P1JEe4FNRHY7Ke/5QnxK7dBim/rYg4nDbFUQt9KggnilM9rAZphtlAF7JT4dWBP48/h8AyCjkpEqvwnKPF8pYpVUJahYncxHSHzs3g8jxtC19tsO36XY6p8cxllWPXh0tyhj6zrbyxaOhbMFqM+vyUXHdydnr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

Mark non-dumpable reserved-memory regions with MEMBLOCK_NODUMP so
kdump can omit them from the vmcore.

The marking is guarded by CONFIG_CRASH_DUMP so non-kdump kernels do not
pay the cost of splitting memblock.memory entries at NODUMP boundaries.

Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
---
 drivers/of/fdt.c             |  1 +
 drivers/of/of_private.h      |  1 +
 drivers/of/of_reserved_mem.c | 15 +++++++++++++++
 3 files changed, 17 insertions(+)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index ecc923102622..a5f223a74b7e 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1285,6 +1285,7 @@ void __init unflatten_device_tree(void)
 
 	/* Save the statically-placed regions in the reserved_mem array */
 	fdt_scan_reserved_mem_late();
+	fdt_mark_reserve_mem_nodump();
 
 	/* Populate an empty root node when bootloader doesn't provide one */
 	if (!fdt) {
diff --git a/drivers/of/of_private.h b/drivers/of/of_private.h
index 0ae16da066e2..505735732c13 100644
--- a/drivers/of/of_private.h
+++ b/drivers/of/of_private.h
@@ -187,6 +187,7 @@ static inline struct device_node *__of_get_dma_parent(const struct device_node *
 
 int fdt_scan_reserved_mem(void);
 void __init fdt_scan_reserved_mem_late(void);
+void __init fdt_mark_reserve_mem_nodump(void);
 
 bool of_fdt_device_is_available(const void *blob, unsigned long node);
 
diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 8c9d6395d6a3..f29a07e8fb23 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -677,6 +677,21 @@ static void __init fdt_init_reserved_mem_node(unsigned long node, const char *un
 	reserved_mem_count++;
 }
 
+void __init fdt_mark_reserve_mem_nodump(void)
+{
+	struct reserved_mem *rmem;
+	int i;
+
+	if (!IS_ENABLED(CONFIG_CRASH_DUMP))
+		return;
+
+	for (i = 0; i < reserved_mem_count; i++) {
+		rmem = &reserved_mem[i];
+		if (rmem->size && !rmem->dumpable)
+			memblock_mark_nodump(rmem->base, rmem->size);
+	}
+}
+
 struct rmem_assigned_device {
 	struct device *dev;
 	struct reserved_mem *rmem;
-- 
2.43.0


