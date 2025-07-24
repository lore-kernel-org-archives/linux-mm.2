Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65433C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 13:57:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C89078E007F; Thu, 24 Jul 2025 09:56:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C62A78E007C; Thu, 24 Jul 2025 09:56:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4F698E007F; Thu, 24 Jul 2025 09:56:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A500F8E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:56:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 73050B95D8
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:44 +0000 (UTC)
X-FDA: 83699308728.04.DCD5DEC
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8DEC6180002
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=qMAEsPgy;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf16.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.41 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753365402; a=rsa-sha256;
	cv=none;
	b=x9kavQY+R4SKdJ+yek7eTimkhVHbdp3NKkNytHZqdf8YjwIwUS0SOyQU0UPrzpbDyxk7+9
	rF6thYiFRWDdcQiWDqfIX14cyjWugiYW80wIXFBe8FaF1Sa+kJhIFkkh+z4BFi9NNbdeCS
	KBlnow2MVGuvqARuZmd8NkrROrxRSqY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=qMAEsPgy;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf16.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.41 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753365402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ieqGzTCdj4VITWiplNNA/VccLe5fuArNXR2nSJt3s9g=;
	b=EOGCm0VCkBbOY0LPLzZSf3zjjGscW+vDhXjaSraTaOW9/4XFJvpJhgXXsQOxsEVcLJW+MU
	GBlE1nO3wvO9VsWgD1WlnreaOKGqlUXzI+PG2DdVgJflIAIZcYRQcd5lolc6iTXpA6ZQAm
	9En7PW0dzywFz8c2aLu1H2le8YaHIq0=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4537edf2c3cso10995785e9.3
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753365401; x=1753970201; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ieqGzTCdj4VITWiplNNA/VccLe5fuArNXR2nSJt3s9g=;
        b=qMAEsPgyUbESox8P9flg+UVx4OHT+V9WmlwNCx51lu52hZjFc+6WgK+h1w9liBfB/f
         25nkW9G/uTCiCdEhsUMX4uGkSpIAIZBSZmuqW3XQQad9rR3pOReJeJj+SBDFUFQz7pvN
         jR2Tc5Alh0c3nZSvuBwhiCW2hIBkvmX1WF5nGpL71GUhdZzF3yBuErZNKrLFfyr+xkb4
         IIPyeH85ZnVxPwPdOCqzoa5eD4420ydlI2Egidw2SwjCJ1+xA3BxLJYVYuzB/UJ2lYEw
         wJtLG/DNmoGPwvyPAD65VrQtBu6RUP89Jlllzk3l3bhndIJq/ijAE15YmVYKPlB/YbWi
         E5Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753365401; x=1753970201;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ieqGzTCdj4VITWiplNNA/VccLe5fuArNXR2nSJt3s9g=;
        b=nNEfnRGB4slpS7o3CszoHqZmhxpB0Ocz87VM4leipsoaSGmwJ2hQ9yw/xYZahQajZ4
         fgKQSQWbw4Mx0WGf3WDJdTUDMc+mkyEbugWEhbJqcmPivaHiuYgDqUywdJOoocuiYX2y
         TuHjKk5XHx+ul5ke8K7fzmq/lMBs9EP+ZRnd/47anjnFtN2b05nhkej44Jm/JHpdWLeW
         YdSF1HpJ2UY2pXeXR3Yj2VSEdRq5NleYJulKc9z2tr/bmV6D/n7IJtY9ldzEBcrO1mNt
         WmXtDHBY+qLbGcDKiE6CaPTniWR/eAAMIVm1pa6ZEWjcnh715avx/216PpJ3jMEkS3vb
         uCPw==
X-Forwarded-Encrypted: i=1; AJvYcCVgueBoRxSFOwCQCA5Ye9iny8p8Pa7/gEnH/jtN+Y3bHPZXMQK7nIaBWT7njxbBpMe3htMoIlO6QQ==@kvack.org
X-Gm-Message-State: AOJu0Yzw2u1krnZLHd6pcl8FA7THgPfSJez7VMQv74jHHh7a5CVg8jA2
	K5uil0OpVlgnslavlawhILiK3lAepjAsA4xML+IFb9d/BZlTva1Z1xC58VxMBSIoV94=
X-Gm-Gg: ASbGncsoW2Y6KgD5VGjmqLQeb+djom2oLiRJVipGmFigQTh6DQ5Nr8/o4GNperjCjiX
	6ndgYmHrLMZRmcA1d1gOQdFKdy7Iyv3GhygeNs8BeR7cRxleIOPElDIB6SSWUOIScGsXhQyjPmI
	uzURZ5TsaRWVw22T1Dsd/QV7SayLDlqhCBJ5nEByDSS6/qvqya6vSIVy7j5kj+gClphl6GPi68a
	2Lf9kRhkpgDHRH9Gy75KWQNjptarTINNW4edBXd0XDsqwvG6LgkChAiJEOCixqtRBPTDMbiz7ot
	PWsSy44AjCvRqoZiOqxFToWABkfjIsjtYwuNZk7FLBeFktZOcVwdpawYZV2ilaHWKQrL5E5Pjux
	0OLbvhRsNoLFytbm7cwKF3yv+wR/kdoEGmN7Zf2zDttcDork+EIygIr3UY68qZH/Y6WvA33Uih0
	nhqEZK4wyf7/8O
X-Google-Smtp-Source: AGHT+IGXEHFsoY1KVpxzOAw5TwDBINg782dVci0CvVy56NLBcwsZCPP5/3Z/QT3qLnRYduHfxvJiyA==
X-Received: by 2002:a05:600c:c167:b0:456:1c44:441f with SMTP id 5b1f17b1804b1-45868d7266fmr61139855e9.31.1753365401169;
        Thu, 24 Jul 2025 06:56:41 -0700 (PDT)
Received: from eugen-station.. (cpc148880-bexl9-2-0-cust354.2-3.cable.virginm.net. [82.11.253.99])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587054e37dsm20889375e9.14.2025.07.24.06.56.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 06:56:40 -0700 (PDT)
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
Subject: [RFC][PATCH v2 21/29] kernel/configs: Register dynamic information into Kmemdump
Date: Thu, 24 Jul 2025 16:55:04 +0300
Message-ID: <20250724135512.518487-22-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250724135512.518487-1-eugen.hristev@linaro.org>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8DEC6180002
X-Stat-Signature: dmmfbky7cqybu87u87jrz85bfmt6gdoh
X-Rspam-User: 
X-HE-Tag: 1753365402-991722
X-HE-Meta: U2FsdGVkX1+BymhHa/vIO8nkMw2EDcpQsCAGCp4yIYjMcEs1/ZNXKHyxCpb1obh3HcDjuk4E1jHEGth2ebrF+Ly6AWVc1MPeNIE6w0p5lxlfNCG0SncjjZjbbmK7GDCW2tw80nYihV33t0k+BfVaD39URorFzZxdACcatrf/NMLOhkqgLoh/uIdFEh1kyp4NO11yWSRR4NkLidOZwVr5yC6h+xVpO6ZbACNWuKpyiyv0gOUY4hDa24OLTTUJZn5TEDzhimB3tGjA/+W/n9+J5e0aGb0TrhyhpEbwpA/R7LuRFovV1FaTgcshE/14X3qhXmi++iCAejtppcQiMIulT1H5UMy9+2LCymbfxeRT/p/l1/EjIJYrHWqhKcl59t823Bpk5UQ/GXxy+ok6LLL6OuvKTnjMxzugQ8PWWfStEfy+eiDy4hBf8UjE7p0dnvPWEndVBjUWehhkGQAbWs0AVe2MUvTZzogK9RodC9ZcCWIgFocwLqTwrJFa7ZdeyelEuWqflNWlntY/sR/fi+VDocMdLN44G0e+G5DBSwynuc7ddwZMFa0XcbiP7/08mo8fQYPGc5sG+hE10+WENTnPCxBV0nNgcwoxPvngFMan/EwRFI1c/oAN0UZyMyXftAliIRUGBVL2LFFU2HYpT8qlPF22NsiON6yh7TsgA9Yjbrp0oySLWVEa0w2s/4AKxoTVSyg4t0uS3B4Fnz7Ugj/meQqSNLApT6Tkq1O3J9/OYjRbcStZfwSvSt5eV+vydZAeR1umD+gHwProdSBVf4NQcOEMNEh2qL/bW7MfJXgbhKCq1v0L4mCkHRxhKUKM/J6cKwnmUFKQMFo8sU5wzC/bkyiDa2Z/2XvNIbZy6kCwUi5ygzLoh4sZFau3XjSvtSmLUBUyZH9ivxP+uhhgaF6x3zeW5/6gIYAiplp705S3mer3xUX9aWQh4OqLnfY1z8e16i/sd4CHCWG1dDKu6FZ
 OFtxHeDk
 5GdipFEJcoWGYH4zHzPxZqoZW2uY+ByL2Ki3daTmmgmBG9NM2pUVDxWqzzyKwrhpIlHpRsBOvH1vvVVi0o8eRc+yRaC/4BENSwMevlmJxKgpj1ABJdzY0teyy3ZrMILZWTu2nmo7P5wN6Up8up/X4lFKa4oO41NDpG61zMQhgKy3LXd7xPRFspW7yCzkVwrYmRY9NtxxlJjR9w2ZTJYAKQktZaWW3CWDp73P2NP4odLGkobClOLWgJO68Vq/4cfmoFSMJs5Z+2pln4w+qMC64+ELAz/J00UUM5VwF/bA3AEvTXBlRVLOC3FuE7sQCOnAmSyxJPprW4AqkKJtWtOS3+P2L6+oxiZyChMWXayjrdTlolByex9YGaImvDEfI/J0nrFHZUepH74oxjVjyseJRWuoMpQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Register kernel_config_data information into kmemdump.
Debugging tools look for the start and end markers, so we need to capture
those as well into the region.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 kernel/configs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/configs.c b/kernel/configs.c
index a28c79c5f713..ec94b695f234 100644
--- a/kernel/configs.c
+++ b/kernel/configs.c
@@ -15,6 +15,7 @@
 #include <linux/seq_file.h>
 #include <linux/init.h>
 #include <linux/uaccess.h>
+#include <linux/kmemdump.h>
 
 /*
  * "IKCFG_ST" and "IKCFG_ED" are used to extract the config data from
@@ -64,6 +65,11 @@ static int __init ikconfig_init(void)
 
 	proc_set_size(entry, &kernel_config_data_end - &kernel_config_data);
 
+	/* Register 8 bytes before and after, to catch the marker too */
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_CONFIG,
+			     (void *)&kernel_config_data - 8,
+			     &kernel_config_data_end - &kernel_config_data + 16);
+
 	return 0;
 }
 
-- 
2.43.0


