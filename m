Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19141CD5BA1
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 08:54:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E0B48E001A; Thu, 13 Nov 2025 03:54:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6910B8E000B; Thu, 13 Nov 2025 03:54:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 580128E001A; Thu, 13 Nov 2025 03:54:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 446088E000B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 03:54:33 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E45D889C3E
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:54:32 +0000 (UTC)
X-FDA: 84104972784.01.7FF453D
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1BF38C000D
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:54:30 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=cQ7bWAQg;
	spf=pass (imf22.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763024071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=66o8xvNrn3Zh6yfKx4kveyWbQRFbxbGWIXOV/eFIVRM=;
	b=XKBtXX+x7IR1+GkuE3t3qGAQyS1fE1LoSN/yUXKgpgz1zyyKC/c+yDWGOvqkvHt3IflksG
	MjSGeUro4zjDFreg6BARCtVJxOf6NQVEkc3p9sTjyyzsWa6CwzUDCYQGUqJMRIdyzRQzZp
	/XKWe/rUX+Uq0FYCZPhc4sYvfFl5HsY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763024071; a=rsa-sha256;
	cv=none;
	b=DcVCDhgpeXKJHGDpU/7toxG27ITB7oupAoPpXgnETFNIVqibM2ryHsboMFMWKxO+Zt4Ifg
	sOQu5WpWrGDq7aNhPkdPi1gyUsOW3NU4uGQJa5XfuMQ+JeS50egTRDYe7jyZ2lGe2SPJEm
	Mz/Spcj0ztAjR7h9DBS9a597VSUWejQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=cQ7bWAQg;
	spf=pass (imf22.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-bc09b3d3b17so463998a12.1
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:54:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763024070; x=1763628870; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=66o8xvNrn3Zh6yfKx4kveyWbQRFbxbGWIXOV/eFIVRM=;
        b=cQ7bWAQg0ezdYSkuVznIeA9mcWs6nfTiciMYdNUmXH72tWaNAmhZ31xq6eL41xP80p
         rIxAUSd+Yw47CENZHXJ9RqFomBpCe/BkI7z+DkJW7GcAAz9i3NHP1gSC6Dj+c5/AE1H4
         mLf8CBHKbWI+SbsLag9T0sSJbC2ZzilQQqeQg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763024070; x=1763628870;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=66o8xvNrn3Zh6yfKx4kveyWbQRFbxbGWIXOV/eFIVRM=;
        b=P4ap3toEbxjPBm7I0jCzktMCp/OhvhLjKiIV/baXpUpRBr624xxP3eKlkWC9HAxrv8
         cuMiBDIeAUgLKVb/saK8wERMSEzQz6Tx79RAwwJiliDv2ctFiREGAtRM+ZxoAjlXK7LK
         4uzhlz21mV6MWvRc5J+/w8kY7bpT3tr/V6CDyGpII278vFd9Yus1YNaGPdNEaXWVCy9C
         zLvpXolOJuZmNvqIBR/k98D4QS1JyP1CCqAUBnKF7tNJnsP4Fwv1AlarEWUP/SsjJaeU
         1PMcF+Ct4LcrKui3nhn2Hb/MDMCB26JBNptm5dbx9MvsnNHo2Ax0Sld0r7MqQMHzWKAA
         6sRQ==
X-Forwarded-Encrypted: i=1; AJvYcCXebyAgScsLMIjsYTUGy46Q/SkiWwG7MHuq+jIvelR4K+X+CJU/tYV41aYI1DWEtx+M8MEm3nnB3g==@kvack.org
X-Gm-Message-State: AOJu0YxgInLVgbuE1sEbDCheMK1EbIHx7xIpJyObtcGt39CrVLAHmiyP
	FXkFuZYG/AxBnqQGhy+Lpzkl7HZ4HPbnKCnt/VmGC4P7bhHYEx46L3515xp7ngzYhg==
X-Gm-Gg: ASbGncvij4gyhDu91/r8UpDu/5ijqJjtcJqTA0uZv9xZKg+OcHRr05YB6VV+eqzx9Cb
	1LyWrMdP/M3GL3HT25wAbHJSrz4QdUvePT+vFjlCLBksTk3xSxh0wKIQT9DHMGLd15HS0WYYEHx
	Ha3h228oi6NwqMFIlYFnL/CGVjOqZemncneo2ifYaxY7QDwtRGGyc+vLpAwkrYYiIz3Dez9qbT+
	6/izsYQQLUGxtbORHWXXEqXApzxcInEPZM/S35mEizXZT1RVe9d+HJ9t4KzOjzsFOegmpMFKda2
	GL8kqhJ/eAPmv9Eq37Bjnb5TDLM20RG07eer8re2FVbUjnawIkN6kL8/wieQOf+Mnq7dVfQMLp5
	J2hr0Pboczm/xATxHNvylRQpBB1u/U9ZfVjkJLDOR/+zvIvFw4NZkZM5mZaAJmS+e09fRxEQbP0
	D3spZDryAAAKErb/0B4wuxlHKm5fhtx7DjWOtSkg==
X-Google-Smtp-Source: AGHT+IFCr46cECMeVud8wNJtWIGj5BffLnOQD6s1PPHNzh+xi7UWKBaPjYSgkMNd/Mok9dJQQjAbaw==
X-Received: by 2002:a17:903:1ce:b0:295:73ce:b939 with SMTP id d9443c01a7336-2984eda94dfmr81834785ad.39.1763024069976;
        Thu, 13 Nov 2025 00:54:29 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2401:fa00:8f:203:6d96:d8c6:55e6:2377])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2346f3sm17486465ad.18.2025.11.13.00.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 00:54:29 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Yuwen Chen <ywen.chen@foxmail.com>,
	Richard Chang <richardycc@google.com>
Cc: Brian Geffon <bgeffon@google.com>,
	Fengyu Lian <licayy@outlook.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCHv2 3/4] zram: take write lock in wb limit store handlers
Date: Thu, 13 Nov 2025 17:54:01 +0900
Message-ID: <20251113085402.1811522-4-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
In-Reply-To: <20251113085402.1811522-1-senozhatsky@chromium.org>
References: <20251113085402.1811522-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 1BF38C000D
X-Stat-Signature: mqht8jpioa7ykrshh4k5bk1g64mhy9kz
X-HE-Tag: 1763024070-783438
X-HE-Meta: U2FsdGVkX189TmjrAez1jRMvCOaOBC1eAzBI/N6flmQZKLjY8DpBzPfQroix8wfojm7KNQ8qAwZFFA1PFZwex17HhpHJTo80bYMzHb4ZBEmQct1wNlKlADBDVTCuCmtVLa5OnMtxy2UlQGMynJRe8h+inIryM+HRNxRPK19YcJSwtf3q4LVKHpyAuXpS/k+1hOnjt8hNzolbtZeTxtqK7770dsNbG3oNx+0FXXdu7V/hHDNicthTP75FyER4Dnyrs027G376thsC7f0OazvloiBDIQOUEi4LG9wvWs0qE2MmCkWQSp6QMUaImyFhpuC1mIgnku/z73TVjcA9viL40Tz12RPhOSce4XapHkDjI/wkPZaaaKdA75Rx6vZ4wTW0xJsaB/fu2odml3Sy0DFI/1xNi6L3SAi+kGWOXy+RA3E1m/0Rnyo0CqszB3HXcZp1iEaGC84Uew7lIzaU1WmVDRZpkUVb+lPNNFIZOfDSSq9hDfZhT9/L+raKSkbAEgSuJkDQlGiqB0rzXy9Gj2d2ixB180ovLXzT0+g5zs0RFgz8dOcpFxtllRyt4tfGmklHMqfUMARNlNRdQYHjHnBQalL0dM13c6qcq64rv111mguLSx3CUGlTwQeJqd+F8WufzjRarMHdGWCuJ4plN4XQ3wui07W6Y+x1EoZWy9VulfGijUrF2+6uM9iPGbu5Ahp7rgw2iPeuXin51owigPjEsO7t5wW1yxjZ16qJNBQ3mLbf8r3Kmk6QiNmbmIflRaODAsDpQ+AbISTECbeSIjSOdAyLFRQsEi51CdAM7Gi6oP7M4qvHxzgElPtDEAMPuA3isj97XMb1vsbp7UwriIkfiurIa2J2/HJQLVy2YbAypnzTCu+gAK+a4wbEv6nVvTCRhYUS6S/xMuO4eyE71Q7YMNW56g8Dc1guiXYRb4WF0Q+V3UVYdVD3TsemUckzFuPsYFffHJbmFgIryzHJmqz
 6pjKUlLz
 K2hDcUdQKIfHLr7Dnp5JeBHkoVqYz6fLKpbfw3GeCCVA3qhLAc9ZpGhD+wAFv8EQHFPR2guU/9mAdmIeT1aHqxnT8QuuiH5hzd9hfpoLk6oiHjwXp6N/0TUmhJbavf2YcWaPAzxiXDtTojtAdHyxuJarvI4npNsKPq60it5rjWYmUfyHztf2xtL4F+86wK08oUCnbDHHmsYWZB7woEQecskOaUyunhnHmuXUGJ+EtVXvrkhPqw8151bgk43MU17gqgWNnuSzRnLge2RXGUSx7mIIa+vdPDI7ZQkMLXzThiEOD/tY5ZRlB+yIbzg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Write device attrs handlers should take write zram init_lock.
While at it, fixup coding styles.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 238b997f6891..6312b0437618 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -501,7 +501,8 @@ static ssize_t idle_store(struct device *dev,
 
 #ifdef CONFIG_ZRAM_WRITEBACK
 static ssize_t writeback_limit_enable_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t len)
+					    struct device_attribute *attr,
+					    const char *buf, size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
 	u64 val;
@@ -510,18 +511,19 @@ static ssize_t writeback_limit_enable_store(struct device *dev,
 	if (kstrtoull(buf, 10, &val))
 		return ret;
 
-	down_read(&zram->init_lock);
+	down_write(&zram->init_lock);
 	spin_lock(&zram->wb_limit_lock);
 	zram->wb_limit_enable = val;
 	spin_unlock(&zram->wb_limit_lock);
-	up_read(&zram->init_lock);
+	up_write(&zram->init_lock);
 	ret = len;
 
 	return ret;
 }
 
 static ssize_t writeback_limit_enable_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
+					   struct device_attribute *attr,
+					   char *buf)
 {
 	bool val;
 	struct zram *zram = dev_to_zram(dev);
@@ -536,7 +538,8 @@ static ssize_t writeback_limit_enable_show(struct device *dev,
 }
 
 static ssize_t writeback_limit_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t len)
+				     struct device_attribute *attr,
+				     const char *buf, size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
 	u64 val;
@@ -545,11 +548,11 @@ static ssize_t writeback_limit_store(struct device *dev,
 	if (kstrtoull(buf, 10, &val))
 		return ret;
 
-	down_read(&zram->init_lock);
+	down_write(&zram->init_lock);
 	spin_lock(&zram->wb_limit_lock);
 	zram->bd_wb_limit = val;
 	spin_unlock(&zram->wb_limit_lock);
-	up_read(&zram->init_lock);
+	up_write(&zram->init_lock);
 	ret = len;
 
 	return ret;
-- 
2.51.2.1041.gc1ab5b90ca-goog


