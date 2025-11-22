Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE55FCF64B1
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 07:41:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 532F76B000C; Sat, 22 Nov 2025 02:40:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F1526B000E; Sat, 22 Nov 2025 02:40:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 382466B000C; Sat, 22 Nov 2025 02:40:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 24EA76B000C
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 02:40:59 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DD8E0C0855
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 07:40:58 +0000 (UTC)
X-FDA: 84137446596.04.EF76C6C
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf25.hostedemail.com (Postfix) with ESMTP id 012EEA0003
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 07:40:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=fhA1jVE5;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763797257; a=rsa-sha256;
	cv=none;
	b=JWq5bVfGCFCylB3D2wgcBSuQ/FmOK3X66d684Cb9osR9RXf7xW4/IvGbZQRHHMvghMbtPP
	+m78IkLKUTAiqg/vNO8shf9zHv8RhT1DV4DMJr/cUWOTT20tDJJLEqDa/nJhCguoSMZMCw
	q4VGxONDZHWUDI3L5sW2sY6ClCHWmHk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=fhA1jVE5;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763797257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SP8ZymlO8cuxujreNygTi0dHk6OzbncHB3g2TEGb8AY=;
	b=rol7JvHD9kou1yspFD4WCv7u3frVXYXiU9yt/7X0f5RjQRhlsVvCfCCW30CY+Kq8OA9I5Y
	PtecBiL4TgEPur85zSVv/h4rVlTGoiUEB4M3w4eUdguRFOZ4OJDQM21pL0j8ph6tOessO3
	PB5H+Wy3M0VmD6+el8y9g/nNBcfzQo8=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-29812589890so33065845ad.3
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 23:40:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763797256; x=1764402056; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SP8ZymlO8cuxujreNygTi0dHk6OzbncHB3g2TEGb8AY=;
        b=fhA1jVE5wlS1qIUsaj04QHAUzvHWb7XpjHM6cH9asdTQhj0OUBN6aPlvNV8o7gl9ZG
         YK3+kLrQm1alfDeHlJW6CAE7h33f+TexTv8/PWYNvZyFdXBuM8alczDjhdjd7m7ReI9l
         6NcSTahayKM/rJEwl/t7x5VKqTdgR/AFdlyyE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763797256; x=1764402056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SP8ZymlO8cuxujreNygTi0dHk6OzbncHB3g2TEGb8AY=;
        b=kjSNjwfdG2CO5P6eiKY2P+wAcooxPzpMezFjPqnLXPe/fvimAKo0se08vnYYdBk7vf
         H/CeUnItSWgP9zd+/S68JLECUm4wifrX4oZndkjmLmpmtsneL0PZN2LFrbSde5kLDGTZ
         iT0GJOE7+trGZ7FG6D+V9lf0q/9CkRXM0BI+t6FJFrKK/Tbqop5QVu/vIFy7qE9ysjKU
         5HlLmq8SxHwyWwsc1HvPKkLsR7x/JniLM06oPFc4CRphs3+ejwxLRBUzMu4JgEATYGpp
         n3Oj3GMFTCJ+gOGSXDZ7QY0QJAFzslJcRXRWqiYaxT9LBQUXuw5m5gR9LQkBnrf9CyRk
         sp9g==
X-Forwarded-Encrypted: i=1; AJvYcCWY1kcc9FcjQwi1YeW8UN8scpxEFt723CLlZM+FuzCwoDg1lK2W97dJZFSQyrFr14sBtcCXbAyGQg==@kvack.org
X-Gm-Message-State: AOJu0Yw9YM/dCkBqFCQNHH2U04pDXBByhvSFcL6hQwybL0IDwzzxmHFW
	5f69Eh9kyFIAepQ+4lzvs1PtriNQb63W4TDPtZ5afw/+2nD6bg7xKLAJQXVixcCihQ==
X-Gm-Gg: ASbGncvO7tsb1tvzlKWwYgWuXdcE5pvNjdG21QBWQSerTRlOats7YrCbGYUD8N0Mbpt
	Dm0nkJt1Wy2mXjX6S+99uIFcCs4j5+HMW1ZxWNYvGt7piF8CeMgBZoHdJ2MTctLIZc7lZj178k9
	v1OqnDfR78ldlXVwQ4Js0SVdZIjOxfKVdMCJ8H8gnyLGuGq2KqcMLo3WGnTBz6QJ9VXZ33aktWi
	apRJxTvXUF40GBbli5CMInK1JDBxVxDXk7wWYBxlT6gEHnW6/yjRRd1frdYHV03UusUoEMmjxr9
	/tcPSgKWuP82irB4oBcTaPzun2FUyv93bQRViAg/ZDo3/PtYPRAOALvELgALQNBCS19jYYKs6iT
	7oiMrDliLillt6B+4IYb5jk02Cj9TLa/uvH9Wh6ah8zt8YZQ/j6lxmbxkzPIns1ekdYTyTJ+9+5
	2xE+yenrDUVQkLFq3KM2YGkSyZiqnPmsNmYjb6YX8EKkT3Y82nnxEv9Uiq5Yopi70/xJTU46sA+
	Q==
X-Google-Smtp-Source: AGHT+IEM8/Y4dIBBOwac1lJfHeplWi/wxjKlMN7X/1wlrBnzk52Ba8uHOaEg9loOMYDOH+d1fhjFKw==
X-Received: by 2002:a17:902:f608:b0:295:9cb5:ae12 with SMTP id d9443c01a7336-29b6becc884mr62810705ad.25.1763797255895;
        Fri, 21 Nov 2025 23:40:55 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:948e:149d:963b:f660])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29b5b138628sm77771555ad.31.2025.11.21.23.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 23:40:55 -0800 (PST)
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
Subject: [PATCHv6 3/6] zram: take write lock in wb limit store handlers
Date: Sat, 22 Nov 2025 16:40:26 +0900
Message-ID: <20251122074029.3948921-4-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.460.gd25c4c69ec-goog
In-Reply-To: <20251122074029.3948921-1-senozhatsky@chromium.org>
References: <20251122074029.3948921-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 012EEA0003
X-Stat-Signature: 5mihwe1fw1s6kxbfwtx6stuxeswqfoug
X-HE-Tag: 1763797256-321936
X-HE-Meta: U2FsdGVkX18EdxbcfZT33dv2jFLlEB8Xl/sjdqfzKBqfCw56ICWuVAtky/aIec95Sh63RSNgXB4ItydCNrMNjqxA3s53TGDZGiczHsjj52YhMFqOmNKPIXXsEOhYKq6MbJ9is4/Gef7Bv9+fYDckIyTEwrPZlETA5N/gZr/+CbHcpArbGuzqbDHV6vvhHZfjJTZ+JW4qSedGvPQEjHl4nGkKf2kqWlcuVkLO2gZXKIPpCAW44bEbaHu6hZHZ5zEx5p6oiTgiLUnorK3dKTdLHlTirJQP8PA1ogo4ozN1ssZFPc0wQTdjHEa+NucS1XND39zaUj84WOqh4tLpY803aorobxzZsDEmKO9XnvO7NkPrIAHbCrxJWZG4FvP+YVpHBUmP1ky/hdWxh5iwBTrm+JsYsATwHDAiTYfDqPa3rREWU+M5xy6I5VC8UnUhI0HD8vEr5SicTRLFGhUR2rPV4ovgSU5UOzrp13MEhhl7iHpXg2qOhQwo+cwR2Va6tHJRVF2X1bGVvUBMjz/oU6cLSMt6RkHhZHMb2GGy/PUCT0Tt953OQA2BuV8WtAguPuBJkTicNixLle8zyxlwJ1sAFEQGau/fTem0Hg0pFuJYDxllmXjgrZ6JIraIfUONwydCIiP6rX8qGZkoBD/cWhe6ZH8sz+AecAvLE8+Cadp+vc9+LP6UH6biA1+6bAsZeQh3Jy+b5xP1Ovm8eNBjM5YLh5vtdFVDTNI+aGCm/ZTKumYNVrGrqUcEEpK73RQj0PLYdH0VOEOMypXHVXrRmh7cnFNnwPTl3knvlqehRX08FOF5DVyxWPXbG69r7QIB1GCGQGMGCMQ4n1C9Xhju2Z0AAJRqpiNY+NG52rVhyP8wPkzzskAKYUbJAVdkTCQudKAC/Hky3VWhNA6z2RcDYTdP4RhWcf64P/TMuceJw+eaoAX/arEFs/b4N/zKdqGCcu/aLbE3Gmuvrlg0jcGDvc+
 x8/fl5GE
 +AQMR0MAH+dvA7psPQMk85VZilTPLBMz/4cK9lFnL5zBAV3KTrzSW4AoZDJiJ0aR7PbpjO7PDuvRy7yLImO8ARtXDAeMLOB23vYC+Bm/Ctg3fhPkUCZW23hUJfuYdUpvGPdxslWHNn0LcVdpVZ6lMGRMrOLzcDzeMbMjgfeNbP8hehwpydkv2d8EKq6f59kDY/vUyUD4jSFBIfTV1aLYts5Gg3QqGMMf8TQ/wiV1GbcIM0XApqMMSBWkD4VOqzDAK7F4vnXZin6o5Lx9iXJMG15fe0uRnxp/Rv7wb84VCrWhnE13GL/uvQUKhQDdUSRajgaUVAGsBBhf5krI=
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
Reviewed-by: Brian Geffon <bgeffon@google.com>
---
 drivers/block/zram/zram_drv.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 5906ba061165..8dd733707a40 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -521,7 +521,8 @@ struct zram_wb_req {
 };
 
 static ssize_t writeback_limit_enable_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t len)
+					    struct device_attribute *attr,
+					    const char *buf, size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
 	u64 val;
@@ -530,18 +531,19 @@ static ssize_t writeback_limit_enable_store(struct device *dev,
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
@@ -556,7 +558,8 @@ static ssize_t writeback_limit_enable_show(struct device *dev,
 }
 
 static ssize_t writeback_limit_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t len)
+				     struct device_attribute *attr,
+				     const char *buf, size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
 	u64 val;
@@ -565,11 +568,11 @@ static ssize_t writeback_limit_store(struct device *dev,
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
2.52.0.460.gd25c4c69ec-goog


