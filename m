Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66409CFC51E
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 07:41:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0CA86B000E; Sat, 22 Nov 2025 02:41:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBE726B0010; Sat, 22 Nov 2025 02:41:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C855D6B0011; Sat, 22 Nov 2025 02:41:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ACC0B6B000E
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 02:41:01 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7CC4DC0860
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 07:41:01 +0000 (UTC)
X-FDA: 84137446722.02.6C74FD8
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id A03DA40003
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 07:40:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=LNOINlDv;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.50 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763797259; a=rsa-sha256;
	cv=none;
	b=gTlxZCSgFqv49NcjCDlG79UpF45qA67yOFgpx3VXqXx/gXsQkpxshux5fdN8bPPYXqk4K2
	f0dkZs++7TUKgET+2clJ446pXo4NblZDfAQK2Bqxfa3gn5pZIylE2g6QIAXJ9Ax+5VZq7m
	PCsLEPmK1eZIOcfaCwlqgjl06ZLJHIQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=LNOINlDv;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.50 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763797259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OgbFFpUkfI22QXU79O82s8Mc2xvY4Nv+z0knw2TCbpE=;
	b=3m1mGrI7ScBQRUII/OY3//Z8H8zMXLlWq6uk9Umus1HWcKUbS2Vf9Hij4WCvTVz6CSJZqf
	HiG73LoI8yas6fKgJ/sm7/EXEPtcocOYU4Tx85PUWXeNe7ebCXbzG0fRzgPvTlowNkxC0T
	MPtf4+rEPjknbuyPx+Nxh9l+rUGv3Nk=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3437c093ef5so3007251a91.0
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 23:40:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763797258; x=1764402058; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OgbFFpUkfI22QXU79O82s8Mc2xvY4Nv+z0knw2TCbpE=;
        b=LNOINlDvLQ1dQL6Vg5pv5f66mrt2rBv6LrLHsg4Cr0zo1qSSBWzwFyhY03+QZHEoZC
         MlvmJi3JsEsLhrk9R/nLO5SI/IZLzo7GLGbqWmY60DJ6z/Tq39fac+2fYFqAK+ca1tMH
         EVJIVH58Io4UHDlurIu+bOSYPWjvA1GnhRSss=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763797258; x=1764402058;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OgbFFpUkfI22QXU79O82s8Mc2xvY4Nv+z0knw2TCbpE=;
        b=kbpMcr8S5AonBl5R42/0gYMunl0LwpoKja6sOIS/tLA1SR61hbSnLIfC9uDMJJU+XP
         dev+Pl5gIdB4BE+e2pYxLsGd+woL36E3qVvhbXASje3fhR2I10pcWlNY22V0eUxbtQwb
         ehoXjvzE9+A146WUwM53Zzqy2v8MfFmaEfZ3cZY0h4e0jwsobTuyJj4a0UE9dFBvj13E
         hZzYqo5kRSYKsb5N7kzCNY1SgCUJtF52C3lm7qaCQrb8q6l7xLKIUjDUQjUPMkH1x4b5
         +R9JLasHCSBrKbDjKOdZGsDoUp0oTthYXWw7EM2Fv2MW+9qTEbdy6HolDM1nZwBUCQje
         9lJw==
X-Forwarded-Encrypted: i=1; AJvYcCVZN35n0C5t0kFNIb/TyuOObqKpZJNvb6pwrsVbf5KNhy+VvUsmbhikxJDQyab91MjAHyM9CHAHAw==@kvack.org
X-Gm-Message-State: AOJu0Yzi9Ln6bwirgIzdyuzWTcbxpiOHrMMcj7W4ef/7HPtyDn27Vb0J
	Wq0Ra9NNUgeliMO61//Ry49Qf2BSxpag+U6OlE14WFUfq4WQDhAxVGmLBotAJ6rpfQ==
X-Gm-Gg: ASbGncs+kYRrXNaKxM9ZcTROVkufwbi7uOIQu9ubLuRyyDFrsBAqp5n+JOP8n7zx2zF
	CMr93fr7hS1IFq8qdynwzTWovrT1wMBjywSiGBMKIyaX6TjAGg6Ze7d4uHflAknPZQFkH6iSMhk
	zSY3bmwJbck1fWR8E5GOzDpK6LvLVK6l+iQOzTmF9deM1tSLZldl4LqAywzhPAhKbHuhxz1YB9N
	X3B/q35sUl27hgU8nRtZg/VdXy3ORSHguraKPP/1vjSugiwc7Sc5EkpFUf5RovL5pecNH1QJqbg
	SCGwKiNJe81TlYWUld7TsdApWh0K5y03d5Ut1ZBm5B8PGl9tsbQ0yD7vr4aKjnpzcVqejrol691
	PZcNMHivEinDOxH6cYoliDKm1Y76LdfuvO/6NI8F31ICptexcaxgzWEP+anokOD+XZJ1VMalx8T
	3C6/F1UMacnAp3AXxn/qN1zwWmHYmQ75wrcRM72i0BrUfzHDbee4qy6kVSvYg3/6PDdPuudn660
	Q==
X-Google-Smtp-Source: AGHT+IHHl8vDZNN4ihdi/Rw6H5hLCSLd9BU7mCbrs0a2xeos0HXBVBYR3WSbjHwRbViXwwzjKXzfdA==
X-Received: by 2002:a17:90b:3d90:b0:33e:2d0f:4793 with SMTP id 98e67ed59e1d1-34733e4c735mr5306539a91.11.1763797258406;
        Fri, 21 Nov 2025 23:40:58 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:948e:149d:963b:f660])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29b5b138628sm77771555ad.31.2025.11.21.23.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 23:40:58 -0800 (PST)
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
Subject: [PATCHv6 4/6] zram: drop wb_limit_lock
Date: Sat, 22 Nov 2025 16:40:27 +0900
Message-ID: <20251122074029.3948921-5-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.460.gd25c4c69ec-goog
In-Reply-To: <20251122074029.3948921-1-senozhatsky@chromium.org>
References: <20251122074029.3948921-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A03DA40003
X-Stat-Signature: k9pk1mbokyb61nqc9wnd4pqzkcpk6geo
X-HE-Tag: 1763797259-612143
X-HE-Meta: U2FsdGVkX19zk1xbEn2P8nSx8RdR+JZbG8AeDaymuH92OHvJwLg8jWpzE3j1tVS/bRt0C9E0yF6/gbDLT5AowDTKMnrvkyOPkMyS754fBpvd9gP++BnVphrCSBmjdImi5dlCkt4tUMvaZftAhNuqwHuYei/bvJEJA9OqbzJZDIihlmpc/BkMl2KDWaOxHNM8Apg3MRJfTpu5+ohS5StL5H7EUHRRqWxysUif8R6QNU/rWlRN5FoA6vr1TiYYhLD9ozt3LXWdi7NJZucNeUmfUB9jNCj5MNTC7HZAbbI2WW+f7es4nLoQ0Q7euVt7Ax6IK97MGe7f2oxxm/0U9zdsR1Gh8M4Ea8Sb7SEFlDGBUA8sBw7GZYtGmjPlZU/25HS+M9k0E5oWUTawBx2SI5Qx4dClUz1yUyKJgQLOOAp/3d7LeSh9BKZw/EjdmLYkYuFGTC6+yGs6Y68Niv+gIY+rC8YWGOgbysy1zjbXQVvOiFrh1VnHsjcK+TimcAbfBteF4ZhfpOCxaBcEjY/kzExaJF2EsikASBLgVIQg75D1gmxZXzFo8iCyn9Be7slyzsddcf0JjS5yQegpni1vSuQVjGLaLR6oQcP0N+vEnE+aMYoJDyQneFYwgspsPNLR2uVYQLYVnddfjnFVfZ4rKNtOg2JFQY05TE2zZH2AvzsYW2inuVEb8DMbTDdEw4YKM4hU1lNbaN5ZiCmDj2NvUQSk4UqeVyoN2LnGYm9vJ4QuSm10dMuEII8uqcxNYSHNMKTByfiHsREZT5kZeJxDSIsFZEOhigHwnI7wF51Ao88kwK+iWGowo1+nfKkRUIKONCNeD2kXjbkhSy3d0Eya68iqJb7bs/8w0n3w56frfYIC2VNzadSH3j0jltllQ41PDERBTsQvuXogJ4fqyp9KEwgGJ33ho0NF6m2nEWa9M8Jh4MAMHeTiRZX71SNh86FfuV9ber1Z3vn+TDvNh9Ba776
 cJt+Hhhb
 1KdRGNjRWmGLOe6LF4kz8ymY87of4Zqgu8Jdkw1qkt0lzMcBCgx9R8RvPH7v2lVHeavvYVMF5U3Oy9lBxNa6KNkJIXaHaIh+2JukR57oBT3Rfl9boQVADN6Od/WV6lTvn3Kl9yCwUCTglaPKn5wdar+jVFonI52Cl/DYFmE2PgtZ0lMJeruIuJv8tAFDhmWFdDrsZ1ZrNV7w3YbCMSsCBGqPzrD7xaUeHjpJJsb6xZFhWjjE1FGA3NPiUCeRz3F+EfEuMgBlXAYwcDOvVUcBDKH7EdyF9CQXoXnhLvqPULmBI/CY/pzS5XTOFxvnj1qzbP/Z4yKUVwK9HHm4u//EK3Xa27G/tt9JX4IUIUV4O/EP9W2P2QtQ4XCn7tA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We don't need wb_limit_lock.  Writeback limit setters take an
exclusive write zram init_lock, while wb_limit modifications
happen only from a single task and under zram read init_lock.
No concurrent wb_limit modifications are possible (we permit
only one post-processing task at a time).  Add lockdep
assertions to wb_limit mutators.

While at it, fixup coding styles.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Brian Geffon <bgeffon@google.com>
---
 drivers/block/zram/zram_drv.c | 22 +++++-----------------
 drivers/block/zram/zram_drv.h |  1 -
 2 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 8dd733707a40..806497225603 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -532,9 +532,7 @@ static ssize_t writeback_limit_enable_store(struct device *dev,
 		return ret;
 
 	down_write(&zram->init_lock);
-	spin_lock(&zram->wb_limit_lock);
 	zram->wb_limit_enable = val;
-	spin_unlock(&zram->wb_limit_lock);
 	up_write(&zram->init_lock);
 	ret = len;
 
@@ -549,9 +547,7 @@ static ssize_t writeback_limit_enable_show(struct device *dev,
 	struct zram *zram = dev_to_zram(dev);
 
 	down_read(&zram->init_lock);
-	spin_lock(&zram->wb_limit_lock);
 	val = zram->wb_limit_enable;
-	spin_unlock(&zram->wb_limit_lock);
 	up_read(&zram->init_lock);
 
 	return sysfs_emit(buf, "%d\n", val);
@@ -569,9 +565,7 @@ static ssize_t writeback_limit_store(struct device *dev,
 		return ret;
 
 	down_write(&zram->init_lock);
-	spin_lock(&zram->wb_limit_lock);
 	zram->bd_wb_limit = val;
-	spin_unlock(&zram->wb_limit_lock);
 	up_write(&zram->init_lock);
 	ret = len;
 
@@ -579,15 +573,13 @@ static ssize_t writeback_limit_store(struct device *dev,
 }
 
 static ssize_t writeback_limit_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
+				    struct device_attribute *attr, char *buf)
 {
 	u64 val;
 	struct zram *zram = dev_to_zram(dev);
 
 	down_read(&zram->init_lock);
-	spin_lock(&zram->wb_limit_lock);
 	val = zram->bd_wb_limit;
-	spin_unlock(&zram->wb_limit_lock);
 	up_read(&zram->init_lock);
 
 	return sysfs_emit(buf, "%llu\n", val);
@@ -869,18 +861,18 @@ static struct zram_wb_ctl *init_wb_ctl(struct zram *zram)
 
 static void zram_account_writeback_rollback(struct zram *zram)
 {
-	spin_lock(&zram->wb_limit_lock);
+	lockdep_assert_held_read(&zram->init_lock);
+
 	if (zram->wb_limit_enable)
 		zram->bd_wb_limit +=  1UL << (PAGE_SHIFT - 12);
-	spin_unlock(&zram->wb_limit_lock);
 }
 
 static void zram_account_writeback_submit(struct zram *zram)
 {
-	spin_lock(&zram->wb_limit_lock);
+	lockdep_assert_held_read(&zram->init_lock);
+
 	if (zram->wb_limit_enable && zram->bd_wb_limit > 0)
 		zram->bd_wb_limit -=  1UL << (PAGE_SHIFT - 12);
-	spin_unlock(&zram->wb_limit_lock);
 }
 
 static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
@@ -1005,13 +997,10 @@ static int zram_writeback_slots(struct zram *zram,
 	u32 index = 0;
 
 	while ((pps = select_pp_slot(ctl))) {
-		spin_lock(&zram->wb_limit_lock);
 		if (zram->wb_limit_enable && !zram->bd_wb_limit) {
-			spin_unlock(&zram->wb_limit_lock);
 			ret = -EIO;
 			break;
 		}
-		spin_unlock(&zram->wb_limit_lock);
 
 		while (!req) {
 			req = zram_select_idle_req(wb_ctl);
@@ -2962,7 +2951,6 @@ static int zram_add(void)
 	init_rwsem(&zram->init_lock);
 #ifdef CONFIG_ZRAM_WRITEBACK
 	zram->wb_batch_size = 32;
-	spin_lock_init(&zram->wb_limit_lock);
 #endif
 
 	/* gendisk structure */
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 1a647f42c1a4..c6d94501376c 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -127,7 +127,6 @@ struct zram {
 	bool claim; /* Protected by disk->open_mutex */
 #ifdef CONFIG_ZRAM_WRITEBACK
 	struct file *backing_dev;
-	spinlock_t wb_limit_lock;
 	bool wb_limit_enable;
 	u32 wb_batch_size;
 	u64 bd_wb_limit;
-- 
2.52.0.460.gd25c4c69ec-goog


