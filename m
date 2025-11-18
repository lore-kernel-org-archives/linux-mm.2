Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D00C7CEBF93
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 07:30:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B71A8E001D; Tue, 18 Nov 2025 02:30:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 266948E0010; Tue, 18 Nov 2025 02:30:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12E368E001D; Tue, 18 Nov 2025 02:30:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F0FBC8E0010
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:30:24 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B8B6B13AD61
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:30:24 +0000 (UTC)
X-FDA: 84122904768.19.7FEC0B1
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf13.hostedemail.com (Postfix) with ESMTP id A14C320002
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:30:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=hMfLDr6X;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf13.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763451022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oLeikw5PJ/qN7DZHExYRK+yLqtuCtzgt/wbA4Xek4OA=;
	b=h0vB7Y9u7TpK4Op19k99NCZRKqrfz2JmeQvSjdDt896PlaChVHtDvQ7d3r8D4cB2qerxCF
	JSrvzCIJywXISZovpwJdwf6s/0ZHoEDIqsFrg/SiuwLlSOqhlrx4NrhadvDxppYQbqGRP4
	Qn4OtSCUGDSCQOzsePtgNtpTEe7FVh4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763451022; a=rsa-sha256;
	cv=none;
	b=EaoMOfcsnPgm6wEaZmdqjqs5v86Cf07lS7+8xXVsy2CdOdZtrzqbRnelPYmFB0tgfU+Z6R
	XTNAg0IO46tFo3UKeO6MsCQ0cBK+qHCvPTJbiaIed7xY8/3XXBFkuO6/6ptQz6PpHsxoci
	SieJ4wvsdawbFBinxkOC00ox4SYIClQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=hMfLDr6X;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf13.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-29853ec5b8cso60174495ad.3
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 23:30:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763451021; x=1764055821; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oLeikw5PJ/qN7DZHExYRK+yLqtuCtzgt/wbA4Xek4OA=;
        b=hMfLDr6XdX8a59WrQ01op4uUV8Ja6Ah01ODZRyF+tK9BtYUfyBno8C4hZrOd78LM82
         ie9WxfVijPT6eAfjGU4CQmKWWho4jwdMP7FcB36Ym09cW2t5lKDVba0dyucEf9YpYwOF
         MiXWovJ+R0xqaXlAlNVwnBVOVDCRZJgtUErZQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763451021; x=1764055821;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oLeikw5PJ/qN7DZHExYRK+yLqtuCtzgt/wbA4Xek4OA=;
        b=WyUUcTrhAotLH7sXJafUX9ZHQ+dvGt01AFA1VYTi6Fm3anqTvC1ppO5yCiEILwL6YX
         jLZt0hynnGGM5GF7Yk27X/3Kgx+4TUHgmI4bX8j/pwf9k/RbNc7i2rzbgMTL4HDXntE2
         Ztke8HUWbSLsGL8PQO4blfnBLBnnR9/tC4wquFuGPl9GKwhlyYp956F1TJc3Ui6YCuen
         c70NZj8jDUXncGkQADpOa0El+yoJmQk6L5QdBOpK4iJQa94Y7b6shXXyp1ZxNAM6xlVw
         9hAOuM14LR6P4qbZ1p7fOUn3MiwPcZluTDUaUrLCBTYJd/4reg35ROtNrz7MjIgf8I8r
         EMWQ==
X-Forwarded-Encrypted: i=1; AJvYcCUe8n5axuSthbFWcJhYBTx/7erDk8eQsnytipMh4WAJLiufWY+0iDBuXZQWHgLMTglMaw/vXaa+xQ==@kvack.org
X-Gm-Message-State: AOJu0YzEytpGQVnShFWUvLnhZ+nXV+9sAf+qjJGrmZuPWG45ZH0Yms8g
	nxmHW+l0H/+N6V2PD5nqqca7ympUGJ2I7Xa1B2UAGgygh4EL3JpiDKOoH9aMkc//gQ==
X-Gm-Gg: ASbGncvROvrnp7nzvt6K9WomMciohNtaAqN+qX7Vr9jrxNDD0EzwKvLgnOkk4GGQTU5
	nohan7QF5KNmOnVjns5KeC/WfviSCw0g1kvu+dAKpt0nqxEmJxbTqSHASRz9i/1b/+b8+ncaLlQ
	o4X6LPU58XLDVYJDbVoVLqCRftuYR/Zn7vyXkiZzntGkYr3ILnLeXuG78KEH4UyijraktW5kcKe
	F5/SijAJUz6Rhqosv82X6b6IwGGjNNcZp6Aqxwf5Ok5TDyslmr7TQqGiGyfc0TNp5rHJq5VvnZT
	Rpeblobwi1jAB4kSjwRe4E0UO/W/EsQAZhjVoa+x980wpGerH9j2OqP9IpqZdySqJ0EIv9vsOM7
	ulW6x2Xliat6/Vf9lGfYF6PG97z9dJJagTYYnAAidlnQMES+N+YxT6lkws0TmKY3n9U+vQiPvJN
	EGs/i7vW7iQgjgO5+FtGphiTQrmM3b46QX2RY6pg==
X-Google-Smtp-Source: AGHT+IFPr244P47pEFismSmInv5GHAI8P7iTWZDuNYFcomfeTvjtA6iKN1AEqAASeGrUa+CcERTWXw==
X-Received: by 2002:a17:903:41d1:b0:295:7f1d:b02d with SMTP id d9443c01a7336-2986a6da8a4mr198877365ad.22.1763451021561;
        Mon, 17 Nov 2025 23:30:21 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2401:fa00:8f:203:beba:22fc:d89b:ce14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2568ccsm163926215ad.50.2025.11.17.23.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 23:30:21 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Yuwen Chen <ywen.chen@foxmail.com>,
	Richard Chang <richardycc@google.com>,
	Brian Geffon <bgeffon@google.com>,
	Fengyu Lian <licayy@outlook.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCHv4 3/6] zram: take write lock in wb limit store handlers
Date: Tue, 18 Nov 2025 16:29:57 +0900
Message-ID: <20251118073000.1928107-4-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251118073000.1928107-1-senozhatsky@chromium.org>
References: <20251118073000.1928107-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ztdd7tb3w78x9dorf67q3at1oqf3qmhc
X-Rspam-User: 
X-Rspamd-Queue-Id: A14C320002
X-Rspamd-Server: rspam10
X-HE-Tag: 1763451022-26010
X-HE-Meta: U2FsdGVkX19foKTfn8ihtstZYfnSbfUZTwZTSJsBLwUzm9XIvE/QECQp4oyuUpHc3cCQ0V5G1ohOt5ktRIHl4waPbq/R85QHfTuUl1+p3xb13L0nB1+GvqZVE1QLUdsinz7S6f24kXqScTmQanPgoyJS2nQyxKKk8KXKLiCzkO7IjpflSUxIse8A+QH5Nj/EltXu1q1YlMbqXYLG7XY6WoHOzfY+8Gy4J6O0p8ZcHGUa/rGt0N7lg9Qt6F4/nWERe9O44urgjngGzfqXx0cpX2pEZ9QGYKCh+E+AjKV0SDKQjEsSovnq1/F0x2WchLib7MmW3rn6Y8Di4SUnVKRrjkdWd0bcOB8bxZB75lO3yZ/VUomm4iY6AKJCo2QYR191SjNdC89nOCZwjqSLVb+ESmdN994Ab7xp5cHOqSqkOySr00ecK49sCHUc1LO5bxH2U/aTl1G5vKtDxlPbCvvY52HlKrPn2N17dd/ZtieDwp4iFUUr1f7qey3fx8amccC8DWGqGpbQuf3ZRRxQK/jx7n7CBA2bx7ocooYgsiqdlF3fiYULrcp8FyvmFdVM1jIq6CZLgzRRubfuwbP2ygN7mvXzADV+VLdRXSPGvj+a8jejXQzHU8ZBtTJYfru9B7zkauNupT1Xim9tNJwQUm/VB4E4Ekx4t3XlwA78dZRgI7AoH0gnBMNsfcoXz3cxnBgHT/Me1ONHfS44h8SL2TE9bXBV8T/pppUFkMtx+vX5gaFVMrPVoZlSNPVo8QvvW6Dw/jJ7Xp5YUoNMN7rBbW+XVachiAsxzOI0WJSdoblG7nVpXMPwPy/h90nNvQxaealS7RTru3CbXDfz0pucf6bkZq4exElohAPr5nnz4Z+1VUQ+sbgbcDjQCGx35SDSc/4p3qrNLCnhMqGR2d+caGBSys01yqW9360D4Ll1aamaa4r91HgcOCg9vswSRjlVQefRMzZLmeDAUXEwtWqiSlu
 hIsNyJMh
 NrMoEDsJfa7jRcOpccSjynlmDaGrRMZui9/xR1sknjX8H95410zqv22F3oAXl1UczPdWNr4+BllBhvQJZyHkj1E8YTJ5e+BQDDaqqSAH5gsIYsYQfWm6mfdbdDeJcT4km8QW4+jDcNc9Yelx+ngtItbboi/7Jdac1jabmy3anpmfwOir8YIGlTO8w4intgjVFs+sKiBKU37Xfp/lBj7382DCy2xqMndrHTSFvD4ia0rGnvSGppPbIGfYSAKMGOKh2brtEukaFhuyMzi9TlG962U0SYHAuIBEMFDqw4giQ7nDIPTBS1lP0xho3zw==
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
index be39fe04b9b1..073a12132cb3 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -519,7 +519,8 @@ struct zram_wb_req {
 };
 
 static ssize_t writeback_limit_enable_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t len)
+					    struct device_attribute *attr,
+					    const char *buf, size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
 	u64 val;
@@ -528,18 +529,19 @@ static ssize_t writeback_limit_enable_store(struct device *dev,
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
@@ -554,7 +556,8 @@ static ssize_t writeback_limit_enable_show(struct device *dev,
 }
 
 static ssize_t writeback_limit_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t len)
+				     struct device_attribute *attr,
+				     const char *buf, size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
 	u64 val;
@@ -563,11 +566,11 @@ static ssize_t writeback_limit_store(struct device *dev,
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
2.52.0.rc1.455.g30608eb744-goog


