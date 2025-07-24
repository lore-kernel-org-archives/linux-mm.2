Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FE3FC83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 13:56:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E7266B02CC; Thu, 24 Jul 2025 09:56:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 471986B02CE; Thu, 24 Jul 2025 09:56:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C2FC6B02CF; Thu, 24 Jul 2025 09:56:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 16EC56B02CC
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:56:31 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E5296B9404
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:30 +0000 (UTC)
X-FDA: 83699308140.21.2F48631
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0B191C0006
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=PgCC1Lk0;
	spf=pass (imf28.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.47 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753365389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wXG7080vUoTS71soVhA4Gbq56Ym56pqDEVpEhL2XCIg=;
	b=EihBmKKe2nGEogqtoOdQ+RCFdy/HQKuNLCUXQbqPwimccC4fugTKleHoZ/g4MgdBhtQ3qi
	z+YCo0KtdcLyeYOWocKY1+yNMooOqovlDmeHQpgrFeNjrMwOPSH3fHoGV4h9EriHa7qH7p
	W3YHAlxh+BTb+cPSoDAAgNfPAp3SqCc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=PgCC1Lk0;
	spf=pass (imf28.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.47 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753365389; a=rsa-sha256;
	cv=none;
	b=PpAe/oO3KSmBKuuKSDEZr0M6oYkfltFeG2tODvItxirmvvleFfhCXDpGjNw7awLLxs/b4V
	z3ZXh2E3ryEhKnRTRMW80zioyoO/tOkyYamnkRgOVl0X3+bV/sDEIEgMQuQVrsURFLzuri
	xmNQRSV6myfAGDjy0jdZjTi1spweW6g=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45629703011so7322125e9.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753365387; x=1753970187; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wXG7080vUoTS71soVhA4Gbq56Ym56pqDEVpEhL2XCIg=;
        b=PgCC1Lk0wUf0QhjQQjRvazxAXK+lqyPlFMq840a+utUENAwokFsUS0sMZUW4IoQbaV
         q+kiUdQRelg1eT8GauotJbFIVHbNhThkZp4DCOm3E24UUJOQlnN2AJiia0Nl/NhpmkPD
         5RsAPvLNDw2h1mhDlcUaEXmOaJ0aklR1eABlq+XZbV5AkAeYDFVk7k+2N87rxJ7vnyqH
         fljFtYbiv8xYUyDk8XHdnVflO6qa/RSkoqfFIeXs823E/DXBze4XY6lAERPbtm+O8VQk
         eI8BSAG0taTkx72mhbGzau7SpVxvzXReFSFx8YgyWSr6vZaMKqp7yRp0tChM96sbh4VS
         EwwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753365387; x=1753970187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wXG7080vUoTS71soVhA4Gbq56Ym56pqDEVpEhL2XCIg=;
        b=ID2bDe5oR8DiKlYVTl5F+WyFs1MZItX+8ReDQhnT9DL3gWS7IexBWBeqtw/LvgSVLU
         pa6zf5n5buPqGd+cTM+QglhfPAdCU3q9x5wVrMpQg1XN5306ptOkprYUSxIEbtTuRs4X
         yJ0iXpDh8EY8JEXgGFJFXQMgPp287d6fw3hsHPgTruYjZqq+QFDh1IyuKTyBHib1CXx+
         hOQ5yX+1C1cpQxYPfNTHBs0DiihMNnJYuwJ+9X5FHVs30e/L9U+iH7e+HK94aUv0DOiQ
         Cbpf9PYl7ojDFMjiYXe5SwDbavPcsAUlpvuLmIEV7sy/EQsiJMarfd7IftjxLz0iSOQO
         rH9w==
X-Forwarded-Encrypted: i=1; AJvYcCVvTd5T9IYYFUggmklZTdAlmKJiQlbwKie1a3oDFPOszpAitrdm6UWJAOc7W+ZnfCf49DTHi0Z2jA==@kvack.org
X-Gm-Message-State: AOJu0YwHL4EPIFjZ5BMFNRrrCzwcfEg+W+lIRWnNqwQtVvp9MpnREXuH
	1SQq2NWp6Tyus5sjUcZC/PK970IfP/i5qzu4+jCoWstM1c6wYsEqtRyh0hxYW0cA+VM=
X-Gm-Gg: ASbGncvAE8HAc05kAs0LiXWbmt7tHwJhIoZo4cejucbxj7RrEfaGDk4PA5iTg7MIHVS
	mJrV7Xso2JEe2fvCD5VFJdMGg71mCTsSkofL0o1+0LMNW0xu1AYQX9o5q5VK2A60ir3Ug2rfmAS
	PoC3ii6QLP60011D6mBBD5l2hXZZgHRnPdpW3nV64XzUFRt/HAtimu/5SZsFQ4/WZ2sJlcLmTwm
	OH/loTflhRcknLL0pDXg+Kyi4RlNEhTE9GAFQmy0upFrt9HRnXPt95LA6Zjuv+iUX1gAyQgrTtj
	1QCl5aI0mFyAObZ44BdIFNLFwlDHbVBkdn33ZQ90Ih+la6LayOdz7nGsQejTAixMbaFCO1w3PXp
	gY3tp+75TsjuFzNYFK5W2ZijmSvmakYwFkVdctUEWmPTy8rJn3Qjt5qKWZ7e29YIPIiXVWslwfD
	ryHEFkpbYfFqIA
X-Google-Smtp-Source: AGHT+IGoSF/EqSdGIwDb9gZl52m8tCgkgoHOuTGrpWGU+P8oq0e6jpOpRi4GM0HClIhflbnZpXQODA==
X-Received: by 2002:a05:600c:630f:b0:43b:ca39:6c75 with SMTP id 5b1f17b1804b1-4586a7df4e9mr64595105e9.16.1753365387527;
        Thu, 24 Jul 2025 06:56:27 -0700 (PDT)
Received: from eugen-station.. (cpc148880-bexl9-2-0-cust354.2-3.cable.virginm.net. [82.11.253.99])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587054e37dsm20889375e9.14.2025.07.24.06.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 06:56:27 -0700 (PDT)
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
Subject: [RFC][PATCH v2 06/29] soc: qcom: smem: add minidump device
Date: Thu, 24 Jul 2025 16:54:49 +0300
Message-ID: <20250724135512.518487-7-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250724135512.518487-1-eugen.hristev@linaro.org>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: f8wydom7179t1rntz7wfcnnhrzetijr8
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0B191C0006
X-Rspam-User: 
X-HE-Tag: 1753365388-553110
X-HE-Meta: U2FsdGVkX1+bdgJx/Hy4RHkoOpblXY0lITJ4nD0LWBus6LzTO77O/BcfSOqBrZ4Y4zJd42SAPfUPrrBCVKFb1prn8vVO5jx8JhREn3o4aXrBaklNy1PhNbvNEucF6EUFvcKNjSyEoy0ehb9F5vH7XTqHZ84z/Z8P14cwxznk0tqsY4ZbtLrEKnPUfJdvfJtmAOmaHP5X9lW24yrPUdmKWVn1xnlFVo5BQrpLfC0/jfFjerk8Pg3wgRLm1yFxWgRBXSsq7flOL4+70YGmtRGkluFvNnsX2iidFJqcsCEENVQ4GSwWy3hR7yJcNlNymAze1SYlEPieTC18glPID+vs+/hPFcZTN2rPRWH5n0a5DfZrIJ+M+Ely0e53GEOGXzGUNs1kA8KibIDvwScxWGmc1N1t7hJRmFMO94d19OM0eXPN04Y3xSLtee7rB7KOyIV8A9e8yKIoGqoLhdIpXKnV9az0KozJsM++9iWs3gTYr3Zb+8unvqd2ToGX8IAopUD7IWHtBqj+1rEwvvMT1Aih5G32JR83VzOcLh9j+Z7oYlVlKCDXk/0hcLLxn96ypWCShTShu4/Qt4XUiNf8Oar36ewu4GL/1KFkpuyYYtAzFbms94maLo8ox4uqv5OsbGvmU/AbI2jsj2CpZndh6l44taycsDryt+R49Ov6IQv4XZlVK7GFrqM07yvg2cE9zkR2dwQ0P01Y9vJ7Qz/NOVMGwoEhwZ1Qx+PFXce0bFjUV8hNGnKbJ/B+kV6hnBvPHYdRNqxTi2IZQTVQqd4Pylu5XfKOkCaRpLxSuWN0UH3VDACzy/jsBz0H8i9QQwmJHJQlyu9SMLxalXXsBxiVH8nzwi1lxGa8Yaym8NqMpvJx1RfmQ96H5mL20Gzgd1rawk1GJzLowHpbWDxu6UnTj6aJQvWAOyDGpPRE2Nq47jUtXMqDBia4JLfRPHeGOrj0bGNZb6eD7VR/V1JbrWE+ssh
 WeHg1Jfr
 cO6y1DjSsB32/nCthWfTK439AMlY9ky/xDXU3Rb2aK0ngZDlfs96JriBIfZ4oEUGjDSg7pFmnFWoecvyDnzxnuotRLBMDlh8vDnd/PgODqSiIizvpzrtwIuVwPfu01bWbVvtnwGMN3hm/GSFcr9HI2CnbZxugfScfwFOPD88V3ZqYmCcfEfogkzj5Ja3ymXSFDaFwHDxGJRTYWA1Su5dmHebx8s5W03TgoNe8VtNWv9cKL4EOOrNyYmNVdSxBgiy1z6CG43OIVx43mgcA1iXQTulcoI3R/wM3yskHCBMQN2FO6AjRRFBC8wNHxNmehB3IngqEujyUufDXblY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a minidump platform device.
Minidump can collect various memory snippets using dedicated firmware.
To know which snippets to collect, each snippet must be registered
by the kernel into a specific shared memory table which is controlled
by the qcom smem driver.
To instantiate the minidump platform driver, register its data using
platform_device_register_data.
Later on, the minidump driver will probe and register itself into
kmemdump as a backend

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 drivers/soc/qcom/smem.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/soc/qcom/smem.c b/drivers/soc/qcom/smem.c
index cf425930539e..2aae0e696150 100644
--- a/drivers/soc/qcom/smem.c
+++ b/drivers/soc/qcom/smem.c
@@ -270,6 +270,7 @@ struct smem_region {
  * @partitions: list of partitions of current processor/host
  * @item_count: max accepted item number
  * @socinfo:	platform device pointer
+ * @mdinfo:	minidump device pointer
  * @num_regions: number of @regions
  * @regions:	list of the memory regions defining the shared memory
  */
@@ -280,6 +281,7 @@ struct qcom_smem {
 
 	u32 item_count;
 	struct platform_device *socinfo;
+	struct platform_device *mdinfo;
 	struct smem_ptable *ptable;
 	struct smem_partition global_partition;
 	struct smem_partition partitions[SMEM_HOST_COUNT];
@@ -1236,12 +1238,20 @@ static int qcom_smem_probe(struct platform_device *pdev)
 	if (IS_ERR(smem->socinfo))
 		dev_dbg(&pdev->dev, "failed to register socinfo device\n");
 
+	smem->mdinfo = platform_device_register_data(&pdev->dev, "qcom-minidump",
+						     PLATFORM_DEVID_AUTO, NULL,
+						     0);
+	if (IS_ERR(smem->mdinfo))
+		dev_err(&pdev->dev, "failed to register platform md device\n");
+
 	return 0;
 }
 
 static void qcom_smem_remove(struct platform_device *pdev)
 {
 	platform_device_unregister(__smem->socinfo);
+	if (!IS_ERR(__smem->mdinfo))
+		platform_device_unregister(__smem->mdinfo);
 
 	hwspin_lock_free(__smem->hwlock);
 	__smem = NULL;
-- 
2.43.0


