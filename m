Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EBBBCF34D9
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 15:46:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9E196B00D0; Wed, 19 Nov 2025 10:46:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B272D6B00D1; Wed, 19 Nov 2025 10:46:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A16766B00D2; Wed, 19 Nov 2025 10:46:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9080A6B00D0
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:46:02 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6554A88499
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:46:02 +0000 (UTC)
X-FDA: 84127782564.14.E11B5D6
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3555540015
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=vBOIz4Bz;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf17.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.51 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763567160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rqVd/I23ujzds6aG+1Lfyj/OLmPD/Ehk8Zy8jv9bGeE=;
	b=6BF7WFCKHkVU5Ry0v+6qLMxwahEG2U3tUGfMKnWk2668N/JAq3xhu/e0JyM9TjEdhhGpcJ
	q8YuyZaoV46DTYJjsRmcY0In0joxLmE/Ey08k6klm1w9lJ6l6fRC287nHjgrlb8mZFwfgf
	s6++Luh2uK5/Yc4qDO429V76E24KQVY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763567160; a=rsa-sha256;
	cv=none;
	b=s9hA4Inof+VDjHJdi1GSPPVtW4tn9uyqn4HTemJP2B5vm4eNGtCBpSqWOaEYUpbVLqb0v7
	bNfPWxPUNxc40/22JLmIQWE9ABss3fLVqBM4xoQWo9noutxdlv/0DdQ7nDpRoqK8q29k5o
	aiCMIi1UIFw+KUpb9ozOV/c2uAqWTzo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=vBOIz4Bz;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf17.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.51 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-47775fb6c56so68788055e9.1
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:45:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763567159; x=1764171959; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rqVd/I23ujzds6aG+1Lfyj/OLmPD/Ehk8Zy8jv9bGeE=;
        b=vBOIz4Bzszc11rTy6gTJ6K2HKMnR3k0I+aZUIMGYbjJ7a5qbnqRGgp5YZFbiJhXsjy
         KFNyhZdLYE4C+IMVlf1zisbSuIbWCkqXrmRNRMkMInvUu57HfVb3UpAjQrLfp9GrSg9b
         nIApUVyrMzJC/hkjgjvTnhA7pPl8C32gkdkt4J7bAI8Og56JdiHggvyRdXvCU+t7KW71
         NvALSF6zJ3UUH4jjZryyGuu7YSianFkw2nNVnEzab54laWfr5LhR1ioOCGEGxXCSSGj2
         fbcE+K3Sa7hxIpenjHK6Son0zj/63cfPkvuAFd+McXd/tJQHKutiyg9GpJPbBxYVsy0s
         00Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763567159; x=1764171959;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rqVd/I23ujzds6aG+1Lfyj/OLmPD/Ehk8Zy8jv9bGeE=;
        b=IctYD0AttI0glCnQ5AKrCbGcmuhIcMH9Va4GdWUUmSv0XhHbjfiQ6MW3Z5IBiwigRF
         fErYrw2gYNJh7U0C2QlqoEjvD/p70lW43pk8cBnVDm1aIdkUBZqLw7RLZ97PXPLaCi0q
         Gvyf98nsT8AIdvXb7vvCWTv0D2/6iVKH7qWNqz/IbsyrFSG5bx+u1sQo8EUvgPepPGpX
         8jU0AcLsLOF02urwelVjJvFtErL17NXsCkO4h62hXTNKQl0MMBETq2LeYtMbZUFUQDLV
         jZVKyGUF/9VOXNnlB3WTxXFuC33kvoeUugSpXlbK6hMKC9V4yJPQAtg42gLN3E7M/Ox7
         DLEw==
X-Forwarded-Encrypted: i=1; AJvYcCXAcZv0oVQX3G7TiuNdzJi1uJvyGyV9c8XVXexjUrU5F2lYYudl1tQe5USDpBjxgJR4qRCCV5W7CA==@kvack.org
X-Gm-Message-State: AOJu0YziWcK52nyTLuHJDq2alQ/vuxyAjD10t10LYnH7q4aTHLWJGWQR
	EPHwBpjqhWFHfkpeil2S+2WmMy1xDwVfWk0mIOAOEkaMPDcCnQqrYpuU89axSkxwgE8=
X-Gm-Gg: ASbGncsUOcdSbVbTLWL11Ts4xO/LZXUFVXPspdJFO1WXMko048kzpS1KK7KdSdUTrJr
	MtjnKWxQgZjATHJP3SfpTR4hBw0nZwEe5RtaIBjJ5d8oNLOElEUfAPQfi4fAFQimtTImPLNxaPv
	up/MibCvxaNzN/o+tb4yhN3wNt9G2T5wj0dptVzi7Z3FA5ukFGkeDZJi5MAbcainD07X42cABPn
	iFIuQe0hGDeqqulOm0LZK/DppBhINoOU2VnmW4RB7dX4sSIv0yNa9069sw4UdR7ttN1tIteTUoo
	RuXjO1I1FTgsIftkE+r25BuYccH5fILGwqTvSat4qC2adRcBU/+8mg/dfYTLjUEB5CKkPTC0oQr
	28jYGB6N771SjbJkIPEFYGs7GFvNY/hdybcree2i6IVxG1eikiM1B98VOq8E3IaUOTgzHPV0MIJ
	G9Nc2xphvxgENz4E+Isap9e7EVbttl/g==
X-Google-Smtp-Source: AGHT+IETZCFytuhcxmwyAYMbvVQ+k0LcHrDBKuExYdhaEVzislepliPqczS5k/WGmFJtVck24Vggmg==
X-Received: by 2002:a05:6000:2405:b0:42b:3a84:1ec3 with SMTP id ffacd0b85a97d-42b5937ff2emr21375859f8f.29.1763567158737;
        Wed, 19 Nov 2025 07:45:58 -0800 (PST)
Received: from eugen-station.. ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53dea1c9sm38765632f8f.0.2025.11.19.07.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 07:45:58 -0800 (PST)
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
Subject: [PATCH 24/26] soc: qcom: smem: Add minidump device
Date: Wed, 19 Nov 2025 17:44:25 +0200
Message-ID: <20251119154427.1033475-25-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251119154427.1033475-1-eugen.hristev@linaro.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7n9a1sihawyxqqgxbg1o1jpzynosjra8
X-Rspam-User: 
X-Rspamd-Queue-Id: 3555540015
X-Rspamd-Server: rspam10
X-HE-Tag: 1763567159-460997
X-HE-Meta: U2FsdGVkX18IIFhP8wfKzecfmy5Yb+/n8qxhvWmrBn+32bhkuBsPLFtbhAf6VkIvW7+2zHbqFxZkb8D3wH52Lv3RbcbPOgmO2/RpAmo3D/cEYXedfXvTbYMS/LHBQNjrHJ0MJL5FfTneRycZcv1mG4kmIEQLGgyj3tKm6moGhrw0F89cSNLLB7/QVy8K+8wh4K/9aWTteBaBTmfSDlf9jKWnkMB8l7V9puuv9BCFUVSSakPb+sBG6bz7lqxgwbSjjBJOGWe+/pNsaj+drhsn9YCFuECLS/z/tC7LB8fmBtGcsY2rt3BsZAs1xG/Tyd2r6xyzUGnZdtSuQR5DDR1yvvGvRC1UjRIheU3+REfkd79ZAHklk4gnrGdpaqD3N1L+MgCLcZeYhpcJ/CfidWKYm0FfI4qV+qMZrVMqwX9xx4xIICHv1XICjYVFC4qVrXFTdhclF7wxRlWXwTop0bwTyDzKNv1tF/1z5Ninnot7va2D/ipuzh9bqUOlZa1V+Zyl1SZlzT6acmfBqEGH9r5QNIzhHhBbs9zRtZSy3BkjY7ccx7hxG9uksWu7qyzFg5b68R7Ax9mCOKuEyzielScIdOkfb1mlPFUVEQTP7An0nPxjgNE1kgPGr7NSH0X7ZDf1qDJ4r8Sg/lbIbMHxR9Lc2nRRviZh/jRFTg+WWcuX8jvnxSCHqE/mSr8RjtYNV0ApehK841mp1+2m5iHK7Uw2Vvdh/QcVg2h9j3HOOwnaFtIJOlB2lUS08Sys/JqzJU7yzSmeh0qJeGa4prpFt01jkJW1BAUQZyfRiec/a67HSmBejaLkfYnYQK3MqpiUhSDwNwNSpzHyxwkh3AbNqo1vG4LUgrw51bTYF2gNM84gzUGDq3zNlbfcJ789HF4UD3BjS/62EltEtdRJxTEUQWCcoBe5X8OAJvXGygD69boaQuJh7v3zJT7PYqDg9oV9LQOUsYXPR3wXsp+ntBCCO1g
 4B8t4E0P
 q/oflh+RJylHGGIgRi18j131TPN0tIyKGsst4d60/bYBKyhmAI6t/opqB/8BVU3Mbvh8c/1uPk4eTo74KaG4jj2s90kIgmiqjEvtWDOh2fbbb0XAGseX8At2/MpTviurPbTFXXNgUUUzHr7jlnv59PnHzLuahy1uudN9EfmHkmQbpJKF1Fn3sW1SNSzeCUKbXNZ/IFGm2von8lTfir4kDcEZRRoNvvni4Ql+WRmN/Lb4UZV3e7eNucb/3nLql00XNdjiOzp2w2Ij3ErzLXjIgwEieLt3OtzgXxtQFjLCAp/BsO7Om4Y1VWrN6VlJ9qHdQyDedWcydl12/1p796rU7M6Gj0/LaPzIdyQevQT+WPyiZlTBPIFbT8IArdqFzHZZLBWqeVSaAvQFrFoXgCau/oL8QS8ekbzmJE1QO
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
Later on, the minidump driver will probe and obtain the required memory
snippets from the memory inspection table (meminspect)

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


