Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 147C5CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 15:10:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 706336B00AD; Fri, 12 Sep 2025 11:10:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DDDE6B00AE; Fri, 12 Sep 2025 11:10:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61A986B00AF; Fri, 12 Sep 2025 11:10:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4F8D26B00AD
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:10:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DAD7E16084A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:10:29 +0000 (UTC)
X-FDA: 83880934578.02.E74FC7B
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id 07D834000A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:10:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=dfpmHqvt;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf07.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.179 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757689828; a=rsa-sha256;
	cv=none;
	b=VV7RJ76/GRFJx/fT4So5kCq98wd9/lX2uSyzdBtlFBjfAfDRXVvQLH6udIOtH1rY8qAnBa
	hdl1Tg5Lgv/amrzAXLf+5tGeNtrFRAMP0XTkynSg2RNFUXOYXMppQJWm7p++j2koFaOA/o
	+8PAVt7xQbGugLR70+Bw9LyCp8SbKE0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=dfpmHqvt;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf07.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.179 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757689828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/4llYgtc09L9A5EYyW7VZ9K8LmFJt/10Sl5wTfADcVo=;
	b=vGavVpzLXVAX1OEyX8ZUGkh4ruVU6XkYrXbG6NizMLJqXJrV13KfiuMAfI31INAp+SAcLC
	ZD2pksrY6zwdCrhHeETc9L3Z8U30m69kWtf14/4Ima/Z5Beyy3Qq8MNd+2D4hFWEfIiW0X
	rwaptdKUay1/yaj3f0uXZimzGhIVJvw=
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-72e565bf2feso14078007b3.3
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757689827; x=1758294627; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/4llYgtc09L9A5EYyW7VZ9K8LmFJt/10Sl5wTfADcVo=;
        b=dfpmHqvtUuV9UJqM6sJ1xlyAvHnc8kW2J6RpyfbNTRkDtXUJE8CQFcD46N2l+Cw2Yu
         Y8Ix/tEinDEtGLf1FxH5GlA97U2p7dpW7ots7K8UVJIWLnZZp/U2IUgNoYTDgFs/6e50
         X1iJyCVDfpeWJSD3iyZiWV/Krp/8XpNg8YnEjwX+WDQaBlgFzR0w/2leoEG5RZROcBrZ
         s5cHRJQLow8cLYVpLAr6swaoXD3bAHLCkLkpOj+xk/OMdch6WZV1r+TeUAURoJNuv3jW
         0ybrZb69QAoZX2A6kbTx3PqWZ0wxOTOEZpvXPIm2AQJ/X4HCx+7L5AfTOEQjPMs678AP
         V4HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757689827; x=1758294627;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/4llYgtc09L9A5EYyW7VZ9K8LmFJt/10Sl5wTfADcVo=;
        b=bs8t2GpmgbFTpE2wCLjg++nucluviP5uuaVyTRCo9WJPE8iNS6wwWzJLdyv6B8DFfh
         p+dyHrZxKhKlSJslvDmOlYrySfpeO1nxEUMZVYft/NN0b4MgtlZ6i+WefF7Qe/XxOtQD
         bhlb6r3TKKADXdrpb5huG1sxMn9+CkSVUh9iCHkA5mBwz3pGKuIGTpO3fqyHYqsdvzm+
         uJewJJM4WVS0BEuVEoHT5xA9lNr2b2JXjNqor5NGen1cin+0++WLSCTMM//0Tz6CJ/WW
         AyJwXoPmKvLWjoMjr4fcXULBxe5HQ/sBEofzx4yA600HajQzPPXIc8D7qYzZUzecO5BL
         nJDA==
X-Forwarded-Encrypted: i=1; AJvYcCVW71CGh+Nq+x8zImOG52kOSz5QsbnIgDW6nCp66VaXgDxJSBM/VnmF7cJxoDhHzslbTqP1riDouw==@kvack.org
X-Gm-Message-State: AOJu0YxmW1NWvw9OkFmLDvsIG5RwA9Urq/xu9jg5iPgB/qsFEsWmpw0Y
	Nafml2gB6WtjwhLYy3k1tcX1/MEdQBRPOCudZ6Gc5zToGmttk9us/WeYgTUIX46G3q4=
X-Gm-Gg: ASbGncty5uVkaqZymgv2jwK39DNSGleFId+B/qEIZEsIC9zhLk39xpR4ADxrsgolrwS
	V8x87bONPFXqgJ/IcxPdWpPewMUDPu83YnrYH9aTt4W7Z2tlo3aJbzyO6I+9yVx0RgzT0E5yDYQ
	nRzOeAtq9jSYjKS+BbvcC7zhg5e7WA52u5gSOTflIC+PBtUS2DqcHmlHZyNoeAuyyKm7dJBniYJ
	+DB09fGYzBpFfpv8pgPVlQJJM+/mOEWHi7dHvhzyPugxYTGS+MwmrL0Vm9XB9cn2ccoIar2LYY9
	J+oAaFsRMh7ycn5aRMQ/5LU0UwKTRJOjOgxg+t3TpcZ90q5hdWLwaXrjI9DOAVNcr2UDWyjlV2F
	nzd3drB+s6szSyEYFLy6dP+gvtY1vhejTqA==
X-Google-Smtp-Source: AGHT+IELEo3IIrw2/QnWmoSL7oBay1esdy/6RcSnsiIQj9jdk3byMst9Z0k97wU9qaWUWBvFOqWfkQ==
X-Received: by 2002:a05:690c:6406:b0:727:c325:c5dc with SMTP id 00721157ae682-73064a12b20mr30549157b3.29.1757689826814;
        Fri, 12 Sep 2025 08:10:26 -0700 (PDT)
Received: from eugen-station.. ([145.224.119.89])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-624841586c1sm1302244d50.6.2025.09.12.08.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 08:10:26 -0700 (PDT)
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
Subject: [RFC][PATCH v3 07/16] soc: qcom: smem: Add minidump device
Date: Fri, 12 Sep 2025 18:08:46 +0300
Message-ID: <20250912150855.2901211-8-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912150855.2901211-1-eugen.hristev@linaro.org>
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 07D834000A
X-Stat-Signature: wwobez8pfsuep3gdn1d1dsaj151z7r4m
X-Rspam-User: 
X-HE-Tag: 1757689827-777494
X-HE-Meta: U2FsdGVkX18kU9w+7vTzqx3c1lPBG1NRxKsg321iJAIEurJB8lBSKi7zXvk6FnBVk6vCZbzR0rIYDHGya+yxHb5CeDodp4MVTOwmZpWTMBVIfHA1M4gWSpNOM4KUk6gjU7OGM3gsFfGxczKQoeOu6rKItleeOnk1GVuCfLBQ7+Teiuc4y3kewgT+qw8zlNOHU95+02AIXyScNkKaq5iHtpVEgmcj3tlQ0z6fg5mfrQa8u4Y+Il4fu9Sq81898OjLZOaBpGRS4tTaAkPvcUEG3omb7kyAg3CERKHA12ilbbfao/fRPPbbSJ02ppW8+yDn2ETV322fN4XxwfrF7iKtTzMcQQYmYkQs/K7kt/BGEDnldgxB8G1XeMTy5/SXrhkCqU2eIbL5UAHMC0dJ641T6Vve1KfpM2JLj41Vbij+iOCQWQpeZR9+5cwQrk4+oTNNU6zudpSiz+iYB3PEPvCC3ASCbGX9dcAn5W6mPBYalKsFPf8O2gg1NS6PwF9PrTSa5L5pme1DJdjSBE8UcimwFmrzCVm4p2jjmwJvOnYLdtCLfX5EjrcjRmNbixu/itS/bIoZin/izJPARZs8Vg0cibjXi4a0Z8gDYjQD/nkMBeH8jAypbfBLvcAXtfWDfnkWKcQGbNw6mw+EXtpGL9N5gWIBX8o+jq5TzAnxAjSr+y836iSpkgdGOmfAa0OuPJnnHJS1UBRVX5Mp27dfYoTsbOy2OkTqunBskqM3v6iIfQBD7JhrWrCrrIctLwvFs2ONko+nG9P69JebLAWZJcCWkTya88YvQd5N8g7vE9Nr+/8j1vpYIy8j2c+G+D3c+co31n9compf/qQlexlSjbbFwKh8JwT+2AuClMsHNGDA2aOZ9rwFxuTT2SPoXfHNYB0xqapKxr5u7ApS0KLGYZw0kXebnTSzOkmBehTz41Y+ELkOClLsAYbNA321MNz+DVc7b7k/0yj8yjJSMokM+9T
 wRXV7unh
 30s7YwwY6NYJnRb10KrRvgU7vlbSZVm8aWmWy99MRlGgiNDY6fWPRtztPCAGRLC8EojDqNKt5hjnI1x6h4/AN0fe2tEW6+I6JZEQVF0wKdO+syFWLZygcAtWn22CI8G7Xt3x96YXscbjMfcC+kFBfAS3RCy9ZjFmuEFPccWz/NmNGe9rBDfsd6NlcYaqIqvWeRclTCmji7qUl7T2hFbw9NIksw3ccwds80jjyeauP/YYy5Orui5x0CnUCSjWwi4QhSZRZ01lPTT82q7F0MDJSY/ClL+JTVxP6e/ZKntHj/q6tz69a1Dsc0/RsPLxSnk3OOHuleYuda6XUa4Y=
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
kmemdump as a backend.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 drivers/soc/qcom/smem.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/soc/qcom/smem.c b/drivers/soc/qcom/smem.c
index c4c45f15dca4..03315722d71a 100644
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


