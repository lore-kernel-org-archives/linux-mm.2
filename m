Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFB94CCA471
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 03:31:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5D0E8E0006; Mon,  6 Oct 2025 23:31:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE6CE8E0002; Mon,  6 Oct 2025 23:31:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AEEF8E0006; Mon,  6 Oct 2025 23:31:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88F688E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 23:31:10 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 42A801607CC
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 03:31:10 +0000 (UTC)
X-FDA: 83969892300.02.CFAF49E
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	by imf09.hostedemail.com (Postfix) with ESMTP id 74995140006
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 03:31:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Jg00QpX7;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759807868; a=rsa-sha256;
	cv=none;
	b=Ag5KpDxiMOKVD4rp9Wupe7LbVAkkljb9xZ+/AnlxxorEEK19IeKatkBpYkPFYLwEGD45wv
	f7QVayvawRs5zhdpSbPjHlMdBUEiiCQ5Z1yNspnRXrYAkJ0vPga9Z/bFRpvaYdxRugB2XD
	eccvFUPHEbXKHeg6p+8KvW52vQ5Bh3E=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Jg00QpX7;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759807868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pb2j8N8Az+uWt45nNFfEUmcYJA7/O93dKo/dsaUrS7Y=;
	b=c5YOEzT1FqDR0LM+vNk9IWPxsoXCtDPVwWFcTz/ibTMucTLzm4eeSKeV5jZ3sVUlh741Y4
	rDIHqfXdhGoYLpT8E75HLNab7e/XbBo9I16crnSYTu6wT4VBQP2qWBrhMqf/Mk62XxhnLB
	9PYcLNE4PiBCCzZk3TsB7MrAlFzo3F0=
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-54aa6a0babeso5166854e0c.0
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 20:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759807867; x=1760412667; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pb2j8N8Az+uWt45nNFfEUmcYJA7/O93dKo/dsaUrS7Y=;
        b=Jg00QpX7ag8NH35CaAvyLEjzupuCtGw0tloJLwMMgqxtfRUZViokLYLJzwP+xaQHeZ
         VJk6QU8ikOfWvfCaCr8T0zF0DXndTEgEzDuN9tEhJzWui2i3WcMrTe7/QBYoYRGI4nRN
         61XxctUNmSD1yihU+xqoR7NdGJ9Njzq4g7k/gLUpxgJU2XPvxw9+fY4BGRjOG8j/JVF1
         uFhRvfgJmTggpqMsEXkGR5p+uDB5TO0d/injnx1msnDC3Q/PPbKD2vJ3eXpgvYWfJ4iq
         XPLoOftel4qIFYQUqiwMpzdT23X2wCN9RmJb3nKB6bmSS3sj9xLcf2vu2jN3PY1qh1bk
         PW6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759807867; x=1760412667;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pb2j8N8Az+uWt45nNFfEUmcYJA7/O93dKo/dsaUrS7Y=;
        b=LVH9ObTBlluMnEX+4F4i3ixlKlBQkuhtJFoh9UKS+12V2uPbHoC5paVxY+IiK+G5T/
         rVUV7QzxgFa5kRxxmOxVgs+NBJ/cYAvBaFpcVCQ5Smg30OvA0fZ5+zGuoDBDoYsPngaB
         aXETpIJgL0hjPovJdeCUCkvcicXZrR5X13asE3dq9bCbNCBSxdBJ/Ynuwp7Gxn0BIw9V
         0XIHncAM0z4SlBp6KgUhoreHU2da3c8T/q3cFYsuyGelAt7LjYKl5tryGX7+UFUITO/T
         D1BKBvhSdOTRt1a4n03AKPjMA2ynJVMp0EkyNA/tiLoHcLg6FJMK2FxWs4gYyKCoHjLS
         KNRQ==
X-Forwarded-Encrypted: i=1; AJvYcCVKujEJYsllw0zNBkqXjcSDAPJaNukL5tdft1WrLyDMkLKiysxgZRwlzKjwy/gWFCRXJIAn/trpqQ==@kvack.org
X-Gm-Message-State: AOJu0YxfswkCf51dFsfltWoIrw5vt6Q/qqb5lCfjNNQuA+wMTYQD26EB
	AfKo2TCjJHswQ3rQCHKNgAtMxp4/XvnxdLwB4k4LboCVpx3J4VdWbTJo7GwjkhOTzpU=
X-Gm-Gg: ASbGncvAGQlowtS0+s3tB9OGha/n8P9DGeXsWW/u9HvcHT2irjd9QatFdqWvQdvFB7K
	egs/AfVhmRWNdoBhv63irXIvGWSbAODlccUA06AUM34i3U0Y8fGsAiSRvZaNW4mDGmoT6GLuWJT
	I6aMdF7hobCc8NVuXII2bNDiwtnBZfrOQZVEYP3SKerRowdVx6iGckcWaBtqDA7K9UCFaMcKSQY
	ChN9HqxiolNks1y3g0b/e62C9xyAE8b5oeGeBttGQYbuf2hEzvQutpUPs6e5Wy5ADykrx9P6ZpN
	qqCZO6RaZ9876TBW5huPkiKs1lWrfoZnvXn3j3S5ac+97DNatZOoUROEOoM9AzplGNVaFuycJOt
	kPVHivrYgULiN0lXl3iuzY3OhEQ3rXuJaFGG+ZXMdvCk4y4QaU433drcPqtmbUYmUroag5F7rhY
	IDWTQ4qJStnvOlS5SO3ekijxB+2C/6k2s=
X-Google-Smtp-Source: AGHT+IHKWYvZiwypYwTwT1zKSJgyEU7e/SRkQV11sdxCZs7Hd6H9BMFs3IwoGAGyQxuhUHEh8cuY/A==
X-Received: by 2002:a05:6122:8cd:b0:552:3366:e822 with SMTP id 71dfb90a1353d-554a8d1b310mr1055414e0c.1.1759807867441;
        Mon, 06 Oct 2025 20:31:07 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-552ea335f07sm2446030e0c.15.2025.10.06.20.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 20:31:06 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	brauner@kernel.org,
	corbet@lwn.net,
	graf@amazon.com,
	jgg@ziepe.ca,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	masahiroy@kernel.org,
	ojeda@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	rppt@kernel.org,
	tj@kernel.org
Subject: [PATCH v5 1/7] kho: allow to drive kho from within kernel
Date: Tue,  7 Oct 2025 03:30:54 +0000
Message-ID: <20251007033100.836886-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
In-Reply-To: <20251007033100.836886-1-pasha.tatashin@soleen.com>
References: <20251007033100.836886-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 74995140006
X-Stat-Signature: t1ftqd3jzqeitip3amhwakijnkmt7awj
X-HE-Tag: 1759807868-481438
X-HE-Meta: U2FsdGVkX1+hLxgCEFkGHCPc+LIBbTBMaqk3y3WG61m7LqaZHEJc7JCyXUwfbmDPUAdSVewnRP6GOtBVA1hO/ugT0/crKSWv7X+AAcgS10JmE/HhBIwUfjDossxlzQRpImKfl/yl5vn4FsFdcZQrKq3q+54ROC0SAM1eoaRYvAQSvVGYHW+Xyn+6mu0zs7STi6t+SVbso881RTtRmevkGHstIq828y66jhn+RYxqHI3rGVJaqNbD8u0xJiNTuEWHU7XR1Nlq98ETTZfuzxMZwdneg+anx2uGtYBYLqMQzdJITRHHbZJDfyq1L/hUT9H4qZsdv0ZlZnjtw2To6Js80UM1WdM4uxk195iMHBN5FHeMC20DkJmUKdTIKloxaY3gB0ZEyj/4cS5wyXdVDkd/2GCfw8/3oqmLWlcBwiixpsXhqMg+RT0V4/EHY5A2HvBDpWVuicxqm1YAIvjVxlIbEuv3JJjZh5I1s03hV4T0AEEfi8CybOYof3xGNCOdl/GPaaQRGNoSPv5hBj41vjVdGjTH7o774HahvbwyWg3nZCLLbCIUosVQMDGjHggB1QKBaDBvFYccynO5BonjTZI8pAMaDiclIjP7AZIE/RaomUksnaSoKyHt6NgWVFkzcrkYTirnTcKQdNWHYUXRxFLqCX6SKKuY+xlTYmWYf0PWuUc0hayb3qJK244YgmhLoZPWXwd3la2E3x1nEqD+4LKGHK9WW4dN42MC6dcOP9eFRaj1B5gsxkG/M+SuGFX3uH80AIMQfnhN8ovIZsVaEocPjdBM0lM16fbTdrUQUix27ctBlTSpeh9Pwo22NFc1iRy/LTXKgUvKFaX8+4S+HPcnQCPm803EjpnRAT9PIOEgC6syvafmYf+di+gA07X9inEhOrjg6wgDSf/vgnMGeVG/EaNtj/qFLsynCAjiJNhEJg9MCsMjaAcpdnF83MVdbyRqoCuVYzFlHJaFmK1Wzbu
 rZSN2SD9
 MgiEo/5d9Pujfcoar9m8aN70z3U6Yoyp5KStXqDgBzWe6cAi784G1e5sDy8JgRMuyvbo4E9Hv59kOpSLr0LuV30zdZZtKbCDMqLMGQnzgaU9V8d/lD/HWadWVw+Z7rdPP2oc04pKG3IKWyba+DEe+0W0O29YXSjbcaUVAzrZd7fGMohd2Vsep8Y/ryO5KKIk/SGYk00Jhqp5PXZxVw7HvKrTWh8CkhpT7YmQrG35eq9SM0BQZd79ljmTMltLBgLdON/N9ItKtLgJjWcRDuDY5UrciavfBpSkQOfRZof8HBNSciiJSL5vQZxEvTB9DIKRtRY+tbE8cbmfVL/BRN8I2I9jQOxjeAAI8X4gO5ybbWF9mD7M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow to do finalize and abort from kernel modules, so LUO could
drive the KHO sequence via its own state machine.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/kexec_handover.h | 15 +++++++
 kernel/kexec_handover.c        | 74 ++++++++++++++++++++--------------
 2 files changed, 59 insertions(+), 30 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 25042c1d8d54..04d0108db98e 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -67,6 +67,10 @@ void kho_memory_init(void);
 
 void kho_populate(phys_addr_t fdt_phys, u64 fdt_len, phys_addr_t scratch_phys,
 		  u64 scratch_len);
+
+int kho_finalize(void);
+int kho_abort(void);
+
 #else
 static inline bool kho_is_enabled(void)
 {
@@ -139,6 +143,17 @@ static inline void kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 				phys_addr_t scratch_phys, u64 scratch_len)
 {
 }
+
+static inline int kho_finalize(void)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int kho_abort(void)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif /* CONFIG_KEXEC_HANDOVER */
 
 #endif /* LINUX_KEXEC_HANDOVER_H */
diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 76f0940fb485..76c34ea923f0 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -1067,7 +1067,7 @@ static int kho_out_update_debugfs_fdt(void)
 	return err;
 }
 
-static int kho_abort(void)
+static int __kho_abort(void)
 {
 	int err;
 	unsigned long order;
@@ -1100,7 +1100,27 @@ static int kho_abort(void)
 	return err;
 }
 
-static int kho_finalize(void)
+int kho_abort(void)
+{
+	int ret = 0;
+
+	if (!kho_enable)
+		return -EOPNOTSUPP;
+
+	guard(mutex)(&kho_out.lock);
+	if (!kho_out.finalized)
+		return -ENOENT;
+
+	ret = __kho_abort();
+	if (ret)
+		return ret;
+
+	kho_out.finalized = false;
+
+	return kho_out_update_debugfs_fdt();
+}
+
+static int __kho_finalize(void)
 {
 	int err = 0;
 	u64 *preserved_mem_map;
@@ -1143,12 +1163,32 @@ static int kho_finalize(void)
 abort:
 	if (err) {
 		pr_err("Failed to convert KHO state tree: %d\n", err);
-		kho_abort();
+		__kho_abort();
 	}
 
 	return err;
 }
 
+int kho_finalize(void)
+{
+	int ret;
+
+	if (!kho_enable)
+		return -EOPNOTSUPP;
+
+	guard(mutex)(&kho_out.lock);
+	if (kho_out.finalized)
+		return -EEXIST;
+
+	ret = __kho_finalize();
+	if (ret)
+		return ret;
+
+	kho_out.finalized = true;
+
+	return kho_out_update_debugfs_fdt();
+}
+
 static int kho_out_finalize_get(void *data, u64 *val)
 {
 	mutex_lock(&kho_out.lock);
@@ -1160,33 +1200,7 @@ static int kho_out_finalize_get(void *data, u64 *val)
 
 static int kho_out_finalize_set(void *data, u64 _val)
 {
-	int ret = 0;
-	bool val = !!_val;
-
-	mutex_lock(&kho_out.lock);
-
-	if (val == kho_out.finalized) {
-		if (kho_out.finalized)
-			ret = -EEXIST;
-		else
-			ret = -ENOENT;
-		goto unlock;
-	}
-
-	if (val)
-		ret = kho_finalize();
-	else
-		ret = kho_abort();
-
-	if (ret)
-		goto unlock;
-
-	kho_out.finalized = val;
-	ret = kho_out_update_debugfs_fdt();
-
-unlock:
-	mutex_unlock(&kho_out.lock);
-	return ret;
+	return (!!_val) ? kho_finalize() : kho_abort();
 }
 
 DEFINE_DEBUGFS_ATTRIBUTE(fops_kho_out_finalize, kho_out_finalize_get,
-- 
2.51.0.618.g983fd99d29-goog


