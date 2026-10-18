Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D470CCA490
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 03:51:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3ACC6B0092; Sat, 17 Oct 2026 23:51:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D11C86B0093; Sat, 17 Oct 2026 23:51:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C01486B0095; Sat, 17 Oct 2026 23:51:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 795D06B0092
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 23:51:44 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 742E1A0412
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 03:51:43 +0000 (UTC)
X-FDA: 85334372886.25.9B3A9B7
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9DFBA1A0006
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 03:51:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=h6tayB2K;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf19.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.52 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792295501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kSllIrSwa3+mZd7MmtH8oNKCmldtJhE3Jr9UEV+PDik=;
	b=4hZvbtFDI1JHoixQ5yMFkYIpoEehr5r82dAQYyA1M8WRz2EE/t0LzOJEeyLbZ+Bs3aKXIr
	dMDS4sOKmtBA8GiQATttV9H/9RukZy0L2kaL/LxtUeK4ejmlOSTvLtrL0CKvg2RMM2H/u5
	kI4iOFQl2COGsoX8wxWTGhEONBAzYIg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792295501;
	b=MYyZCEchXdNcmgKdtE2LxeCvbElmDEZXuVeeZIO/HhC95V9SRtjJZ1ocmLFrYxFbBuVPMi
	2bAQ4HIIvYDnmuCadLrEsvyS4SW6nUwIs8xHXODKBCpZM7IDg1rPJKQEauvGPMBwUPIOCv
	LTn0YPwEmGuuRDR9z8g4GTVIpvnC1IQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=h6tayB2K;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf19.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.52 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3ab752f6244so976697a91.2
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 20:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792295500; x=1792900300; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kSllIrSwa3+mZd7MmtH8oNKCmldtJhE3Jr9UEV+PDik=;
        b=h6tayB2KdPbw4bfcrzLf6m/LqietL/OQEgSiZV3SIezFIVj3b9C7WyyUOdtuEf7HTB
         WIfFv3PXg+vBZ6LnklF4/h/CKkf9Jp705xyhNQkNWGrrvWFhU53LGsul1+KLZe25IzhY
         mpH20PfZOB+8M5UQsnK531MzVf3yJpiB8+eXM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792295500; x=1792900300;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kSllIrSwa3+mZd7MmtH8oNKCmldtJhE3Jr9UEV+PDik=;
        b=DUwoeFlV3Nb+9taiiS4IWWfCAo6l8a+Dhbom09uwLqUl5OG21minj3IysZ0GfilDRT
         jcYkg9sqIcOyUG2lU4IPHfC3xUmNTRYcwgJ+NjELfKKv4Gi9Cz865a99h4xHcM/8+eFF
         p62updNauujPZZINW3IZovNCjlo1yvofIciAz1+1xV7vnanT/kRtqgzncIKMeLFV5WCh
         21yzpGuQG1shWtaR2IoPXADo3fCxAXAMTjIJOLKPCkG5ktL0hDao/ZstwOsB2gOBV0wX
         cU7kGC9U1WnbNiGIEmXRfBfGQha9Q652wFBJQCRO6Zv5imRrVnawHg8Qe6X6P5WTIfq+
         MyeA==
X-Forwarded-Encrypted: i=1; AKwUvBzi0ysa8O2KhuSF4utoiboeOaRSUaTcBuUObQ2UNpCu0BYoGqjy0bCas6gwvjHPoVu8i7l+mWbkBA==@kvack.org
X-Gm-Message-State: AFq9FYKTT98poDs6Ohmf45ZKX8rGfTGgAnaO4BNdRRmlgV0Q9q1VqheM
	Gqu76SpVEXks+Ff9xDVzSZQLHuKT3BjsodpEH5bNlwCunCZZUrCA52vUpywW8sFLPg==
X-Gm-Gg: AYBFou0tgo3CxU+sjZdP3hpvPBxvZUgYcJL5AcjrVMdgiAYy0IN8DCrhJGx7FtyB3xV
	Cd834VpvR+qjiM8gMFwDO55EWcjFVcJan43yMxxeVuVrLMqtZigBOiZFValJ7wV6VP7UB6YrTqc
	m2Qu8JPZIJDAzpQJNW9Bm90Fn32osIYA7m9SnzUziIMgOfMoQkEgCWPb4eiHnwyxNiFV3vd6Lr6
	3ie5D/PjjgTAIji5NUZocpR1iROn6+xEG0qXzAAAdtfecZOTV26PinkAGNiqG/DIhXlB86ypI2A
	TuIkjb+60n9xSUeaI9bbu9vcP6ufxnCBPET8K8ri8Y6eQc/D+kEJnzpb/sessW0A4qzAjkoRxlc
	Fu5YM/y9ffVQ4cnHxDht0fsp5vC33kMmK06k/eeaN8flfdCbSHp1TBh1gwZNh2dzBpFrz/8R1gI
	FdPSe5ETKRotVLl827l/fCvL/wKHEENIICKkAVTJUHuma5xfEA9UHSlPYybxuRoyQBLqP8Rpois
	yPW8nrYnJFOdq2ziAtitLOXFsCQK/FoEgp1oF9jUibzwS5Bm2iEE3r2PeZ7bda0HIrBzgtHYQ==
X-Received: by 2002:a17:90b:2c87:b0:3a8:9d0d:ca50 with SMTP id 98e67ed59e1d1-3aceec709d7mr3568222a91.10.1792295500608;
        Sat, 17 Oct 2026 20:51:40 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:4569:b311:f3ea:5f8d])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad25d5d1b4sm253024a91.16.2026.10.17.20.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 20:51:40 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Barry Song <baohua@kernel.org>,
	Bo Zhang <zhangbo0325@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v5 02/13] zram: remove debugfs entry on init failure
Date: Sun, 18 Oct 2026 12:51:04 +0900
Message-ID: <20261018035125.3120704-3-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261018035125.3120704-1-senozhatsky@chromium.org>
References: <20261018035125.3120704-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9DFBA1A0006
X-Stat-Signature: ghxwzyex5gg1zti454wyayubudsaxrcx
X-Rspam-User: 
X-HE-Tag: 1792295501-683276
X-HE-Meta: U2FsdGVkX19A/Qy9cSyxPiFyobq+malDsvoJmn+A7uCeyujL+4upYdxcYs10hlGJ7iZXDyYOTsGGBoklrQkryFK6Rf2SvD5UtPVDYquCPTMZx8AKconi8bV4CtsTFGp5R7YuHM9y0NU4mem38/B1ucWLmqZSX3JJnQ8h3gXtZA3IYJW3eKscl7BmIlI1SSlsvoJ5FBPlN3v/GzKhmM3bVT/1SSMxwLv/knEzVoU4KLTuZwhVcitInhYQWBmYmtbzx+jEU0yGSXTdwhCk5mMe5wzC3t78NHBnMoWM+VNebQnM5HD4wZHEwdljlMYLWPsDXgd8XkkDXa1NG7F2VRb8NAtUgpwtLMLxvpNgHitOkBH55cNiufPqXYyZ0UodM6WjohqJCvQ4eWAOUuyLwaQCsmAUB+5jTXyEjGad+Oevyoka1zAlNrBDQGbS7Ydfhr2DD8Ijab5wLH8/2fuWTMT//Vjk1Ef7UxSHhqL1tD6vR7UDIMnKOuaH/watULmaX/QiXFTiBWeJszjoCSollp/pJ/OxcA6hLhmtKq+SaYlz3hbFW41oRSdx8MUMUQGZ3rlNiB+dfRA0NEK1RyUSPyEkmWmN0VM0BstRBVYqX8qyfW8374oWSr8jc4AaUiQDkIJBFuYcCwS4TL7TvoTxojwqkbDhwx/AY9jXY73WUnpnIgMjN/43MLpHHKV+medbhhnFwCOMEJio5QgeY+HxKjxtt0njbRuscVAwKJ31/2KJZaBY8knxTW+v1A8LOQC1MfRtXJTnVbi8dMCoi6XNrcj3iBE0uDVxmIuNYJ2WodyrMXJV9RLQECEF2+urUOtV6ywdhg2MhKKCOORgYoBLFx95hVBMU6W//i+TCbSfJLz3Jkwr0unpdEHIFjC51uHbNfeG5r7amRKafFgpH0STAdTobSX6vXZxVrAUu0O1ppsoLpOKL+exRelT6pJLsX/Ag9M5WAljRsDAiN7sMaHIWsa
 L1/2kZuV
 Xj9fPhVmoAg9PMSQbju6cGanEZFD+MrrNXocDoqf/DLUgwKMvsDX77EPlLnkgLk3m4Y9tvqIjQTDz13ESKyUrQO/KXIFZxJyKI4qlCZFBl/gw1RZzQJVZV5D0eOadV+fCcS2AtnRRIMCPefXtvkV3/ahFHZWjbeylzF4bUDxSl/fxAcP+jJF0RTXcL71nTlRnlA5ltnVSltMI9+oDbsDI1iUH7/zjnKSKhZXkJYlrfjwO2Qbu3TvzTp4xWkT/pK13jj7ynMcCL7h+O70LtCDFUJHnnuaH2r7THxGJBEnlJSBvtWNbu4KB322lCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Do not leak the debugfs entry when zram_init() fails to register
the block device.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index ab064c84b092..593fa4ae47c4 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -3297,6 +3297,7 @@ static int __init zram_init(void)
 	if (zram_major <= 0) {
 		pr_err("Unable to get major number\n");
 		class_unregister(&zram_control_class);
+		zram_debugfs_destroy();
 		cpuhp_remove_multi_state(CPUHP_ZCOMP_PREPARE);
 		return -EBUSY;
 	}
-- 
2.56.0.176.g3575e65682-goog


