Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFCB6CAC58F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 15:10:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AF296B00A8; Fri, 12 Sep 2025 11:10:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 160516B00A9; Fri, 12 Sep 2025 11:10:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 027FE6B00AB; Fri, 12 Sep 2025 11:10:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E4D6E6B00A8
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:10:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 93674C08C3
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:10:18 +0000 (UTC)
X-FDA: 83880934116.05.491333F
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf06.hostedemail.com (Postfix) with ESMTP id CF477180005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:10:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=LIKWUxRp;
	spf=pass (imf06.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.176 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757689816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PYcAOyUQwZgCVnm8L3SgUsalr9j/YAFyY5/IbjQaIJs=;
	b=k/mK/vm82BrLZMYSkk5lc/fZjEIZ1Z+7Pkqm4Yr9DHRl/m+JCBvq5SXTkAh83/wlYaz9Xr
	ewP1VwNIxxEtfSzujQTQRaZLk6fdnCwClHNNHt5Bvb5wsOYKB+7IVMDhMkJDhsQX2IAGZi
	v9YNltM1z54ZlwM0FdOWvNd57yIdpao=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757689816; a=rsa-sha256;
	cv=none;
	b=i7bIgTUi+VRF/UKtSxh70GOhdM0kZ2Z63kkiWjj6QbNx+WHK6lPhl5omBmiyhIOSftAdXF
	EwJpdXclNaEd0j/oAhP6E5vxCvGF8A6jwVucGau3pqcEibJAYVkBxs7z2Tv/FS+s2mVr8d
	BrUPstzhpomCpz19k1+M79o7KDBN6do=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=LIKWUxRp;
	spf=pass (imf06.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.176 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-71d60157747so14573007b3.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757689816; x=1758294616; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PYcAOyUQwZgCVnm8L3SgUsalr9j/YAFyY5/IbjQaIJs=;
        b=LIKWUxRpqXS2ScrlPOZiEgSFhoIYvmBPJr+LS5ENvL4QuCrQWKzxPanlwzXUKtfdqI
         ZtTH49DDnq0YoKKDwBp+jXh/pAj9FJLgkSHBCY4SIuhhp/XJTtHs4bAtyazITtbjBSrT
         7J8EMr9l9DbSe2Hl7hHg8JiTz4GJSt6snGCGo/wC4CSEL4GlCSck3086iRHHUc6FnHZe
         5lND4zEYZAlWHII4MSxO3hzs7+RnzHF42dUofmGblSXVEnEPrWnlm5jN0HKbF7NCXSyO
         gbd4a3hXZj7t9JgvHdJmg0ZpagrIK3Wmk3gb8JH5HNkODD6ZiqmbTMotZ+MEYfAQBQt9
         +i6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757689816; x=1758294616;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PYcAOyUQwZgCVnm8L3SgUsalr9j/YAFyY5/IbjQaIJs=;
        b=QRIe2BAccaAPrYCkxvTqbMScKe5Ocxq6jJA4WMPfg6oEjU/S62lveC1KMzZ8yDrMcy
         qNGtVK3TXkqidBosIjI/uJh+6nsrvAyYLskWBuRavyrVixedFJHxUKiXcb6zZEbG8gRz
         FJE1/z313NbuxBgAraD4UckqyIs+UsDXoYaO5I9GVJ6dfsA6B1LI1No8prVogqZbNfrR
         8GcHw0y5RsKVh4lRYGK1uwf/0sqG4Il3oOsjKbZKIFaSjFGA/KF6Q76PH8wWuAwb4Vre
         nvk0H9PQ/reQfyBIVDDn8dbwof2Jkpkp+EQV8FvGf5j5BaGRbWU1aWHwChqIm8aM8A+h
         xH1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUb0qAm2cpP/Mz6EF2sDBWDDCIFpJOY48meB2+8CjWyi68JflTPwpK4e/uLgu7SIh6BW6qETCzG3Q==@kvack.org
X-Gm-Message-State: AOJu0Yzj5xT8xcDb/GNMjRyE6dywL1Vwvak9T4GHkM9IQpDMY9mjD43z
	3kASvaKPQog1A67ME00t3I6TnVW0af3b5AWjLVk4gtSHj4uEnLXJNeru7QQCAJYbv5k=
X-Gm-Gg: ASbGnct5e/zghrqt6MtV1LYCDYC5andHSjXZagg1ZrqNemgD6aAmHljq4/8uo4KsliU
	FOwQ+78hU1NwMqYaOVNxcuqYLE0hjOLj2dJiGJAhjyacYUijGG9exr0Kdce/Voj6iXw7lF/0msG
	d9ZSr+f7eFaFkc4j0jaC8/k6kBBS2NSKpjwi+pBlu620DFSTyNFi2s518kXez8BmtZzTsP+nfRm
	SzVX6SIJyHv1WmeLNnbZBvUIY+Uk5T7tse8KHQ3XUDsSynjrHKBmwA/SVeeZWoe89BAZgA+qjKr
	2CmJlHPB/f2LMCCic4uKfrl5707TSHFt9O7Izm+sMm2ROoFtxrbj9nidAvw6o68oniP2U4i3zIT
	hB2yUnFUbeo7m1FcfUTt/RAaSfAmfTht2zuyEEL4joYMj
X-Google-Smtp-Source: AGHT+IHdun55kCQevX+5NMIZ7KQNmYxmG9E8Uto+0Ih94+Wvd6F4Zhy4kkyG4jBHuGQaEGCxBRlhMQ==
X-Received: by 2002:a05:690c:4d8a:b0:723:8943:d6d3 with SMTP id 00721157ae682-73062ab4292mr27250037b3.6.1757689815690;
        Fri, 12 Sep 2025 08:10:15 -0700 (PDT)
Received: from eugen-station.. ([145.224.119.89])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-624841586c1sm1302244d50.6.2025.09.12.08.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 08:10:15 -0700 (PDT)
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
Subject: [RFC][PATCH v3 05/16] kernel/vmcore_info: Register dynamic information into Kmemdump
Date: Fri, 12 Sep 2025 18:08:44 +0300
Message-ID: <20250912150855.2901211-6-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912150855.2901211-1-eugen.hristev@linaro.org>
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qy64max93td6nncw78tchyw3t6zq6opt
X-Rspamd-Queue-Id: CF477180005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757689816-791758
X-HE-Meta: U2FsdGVkX197EKKDOM4Ydmp1Pxqbdb9NzaVgZFPD5r5Wyg+ATQ0/xHBPh/Q6axzMjQQmbqzEj5P7qVgsq+qQDqoxSqYNUuhgfYtiTIcExwRSBvheVA+ZTKmI2BB75WuWgoy2wwfnIVlkUDi8udCh44JU2JzVQZGCPs2UXc1Dorll7qNJLO3Z+TPNq507CxEsso+GvMvRzTPOSorFhj4PwlLzxWSKLJrEgk6hW4CMFCgZiJ0kjhTdp/Mqal6WzBsls9aXAIvPq+Ps19+wKvqbZAZZE/QC3wmmlm+YcvgQ7YX32sg14++HqEbA/uz23a45T+I4m61JBoOj2S/G0dHc0d61Te0OHmJYd+CZixLt2O32lkTKdA8vyBazwqsTj8eqCVKFZ59RFHXZdhlTYw+vFTeKYQufq9ipp1oAIFC4dlpk7BGf/EKCknjPW7yRkgm+Ikot0Bg3J8wfT/UBBl69dDeWwWe0jhAIY9E7QcXgEkkMswd1SLzNNZZsCDeyaduFYlIWR01f0LfjeacYUUKwB1NCqs6CQG760v253/FM/U11g939WEMiQEGJhCEXbsqVNzNUvP17FfQ055rRDR/DcB33Ksdik6zEet7sjY4TKLi/IrB+PGYVT0PN290Sf9bkwOwgGgTSAq7obm88xnYwIx4M5GIMFgc3daAU5J67/0NOXOOr4VWc6YBtA1cyiUDi1C1FvP47LlI0SUUXmZW/I8NlEdhBzMdiYUkEuJrf6el0LSSRqQy9kbxJRC8F9VR1Z4ASjlvm+h7ML9QLyJLF1i3feHalaqMJyRgf/GPMQvVvBR2cMHuk5y0Kels6XOSJLRE2gRifh7NQmE/CD907q6FIEt9897jA74y0kd6OIJ5xUifJhlnxmhsZSDqVPrN4CTjbgZuiOi9fUmyEnhE0XEuYsFAQA7ZWwTaCRlxEqMlF8I2suJnTDY9sNvaYBwPaURguK+k8clLXOKL6ktP
 8TBtG4KJ
 wDmK1GEVfcY0VEQVDWieYhsWgcNAfFOk4PL6dr6Q6oDXL87ZjvXbj27q6NxKa+udDX/AUWRNgIS0o8O/Wu8JISzKRC8h5Hid5iVPY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Register vmcoreinfo information into kmemdump.
Because the size of the info is computed after all entries are being
added, there is no point in registering the whole page, rather, call
the kmemdump registration once everything is in place with the right size.
A second reason is that the vmcoreinfo is added as a region inside
the ELF coreimage note, there is no point in having blank space at the end.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 kernel/vmcore_info.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/vmcore_info.c b/kernel/vmcore_info.c
index e066d31d08f8..3e2e846ba9c8 100644
--- a/kernel/vmcore_info.c
+++ b/kernel/vmcore_info.c
@@ -14,6 +14,7 @@
 #include <linux/cpuhotplug.h>
 #include <linux/memblock.h>
 #include <linux/kmemleak.h>
+#include <linux/kmemdump.h>
 
 #include <asm/page.h>
 #include <asm/sections.h>
@@ -118,6 +119,12 @@ phys_addr_t __weak paddr_vmcoreinfo_note(void)
 }
 EXPORT_SYMBOL(paddr_vmcoreinfo_note);
 
+static void vmcoreinfo_kmemdump(void)
+{
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_VMCOREINFO,
+			     (void *)vmcoreinfo_data, vmcoreinfo_size);
+}
+
 static int __init crash_save_vmcoreinfo_init(void)
 {
 	vmcoreinfo_data = (unsigned char *)get_zeroed_page(GFP_KERNEL);
@@ -227,6 +234,7 @@ static int __init crash_save_vmcoreinfo_init(void)
 	arch_crash_save_vmcoreinfo();
 	update_vmcoreinfo_note();
 
+	vmcoreinfo_kmemdump();
 	return 0;
 }
 
-- 
2.43.0


