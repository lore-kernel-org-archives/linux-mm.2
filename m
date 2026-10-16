Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 599F8CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 04:45:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A97B6B00A2; Fri, 16 Oct 2026 00:45:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 680FA6B00A3; Fri, 16 Oct 2026 00:45:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59BE86B00A4; Fri, 16 Oct 2026 00:45:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1AFFB6B00A2
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:45:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0222A402E7
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:45:01 +0000 (UTC)
X-FDA: 85327249644.13.76F4D02
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3DAF9120003
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:45:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=gSOIM9Bp;
	spf=pass (imf29.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792125900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6B418+SzCM2Ac+ZkuhfOdHoqL+9AUQAlnO0fG1JXa14=;
	b=5boZb6KmJrJQ7LdHWqoio8V0hSEy1bBwlz6+DaEK+XLue+Key1UCI2ifmFpma5bLFv5Yi7
	XldkEP2gcbguIyAdXbwK0izQ7sUI3AkCybd6RrplDo7gBrfNWN0bALMhpqbdmBFSuiZp0M
	pUSNxrTf9oGjv33FOknoJ2iFDFo7bbA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=gSOIM9Bp;
	spf=pass (imf29.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792125900;
	b=CbzouTiMPHY3CrZCM2RTgdVsd/73CotVd4EZ2KkVEQGOCugGc+fTvWkXyMC1FdOBvaNiPd
	hj+9J8QNz0L73ODQF5Cmir0tnoRvsn8xFwqHaV9+aKBRReu+n+9LPF6jLEYo1eXKzmLg/P
	k2xG1buehE9USXQzVRpZDeRbiZKB9cI=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2e946155442so21016075ad.3
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 21:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792125899; x=1792730699; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6B418+SzCM2Ac+ZkuhfOdHoqL+9AUQAlnO0fG1JXa14=;
        b=gSOIM9Bpu3oouI9PImvXX0KYZd1MiPyRZpymsxZ9VJKkbbCaerdfHTO46fjRKph+Hz
         CSW9DT6rbwe7NzrlO7R6/N99EtUxPYTLnfndktiYgEvC5cbeNx2Tl4mU3PjhMYm+u3TL
         64VtsX6vFzdFr1w8SZzHlbhl4CSuiKQN4JxZM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792125899; x=1792730699;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6B418+SzCM2Ac+ZkuhfOdHoqL+9AUQAlnO0fG1JXa14=;
        b=S9Jo8M7RpJ7MKzlpOUZL0ZI0IdJbjpHiIRwQ1KedofvBzxRfgIY2AKtRYbFzOUjnaj
         7l+lLkrqzIyViPANZdfXtzBs7/EUrTYLeDUU+ueb86D8BHcUBr0lzmKNpQYjPEQxNSnw
         eoBWwPLrflqeEKEkLJDkstXA+h4yafoMTINYD5Vy5UUu3vG6cbsrpvuT8R5KzTrEfPnq
         Q4nYhm24+8x6KzDLbb+kHZwJA8jnAJjYRqG0C4rVlerxtZzX2pBmooUp2QnMPPY6yM6g
         FSnLSXhYh7GX6CzCtFtn/xKY076N1HZ12016O71+BvYHJKRA2YaBHGCqm3G2lQJiUr+s
         pQvQ==
X-Forwarded-Encrypted: i=1; AKwUvBzYMhwS5GVgxAoVt4xw6NU+kW6U8LYNm7eLIrofSqszVOmPKEXEzCTCoOgoAkcppqZbuMIfIin9Bg==@kvack.org
X-Gm-Message-State: AFq9FYIAlD2ylQW2I9TDIikAs4eiLwRRSCoThC0GzL71yXozupO0th52
	B00pCAhPrYCQzupN9lCBZAS/2GqKsmgCH59YHmcSS+wxI+zbP4JbHrT1UmJlifEMvA==
X-Gm-Gg: AYBFou1jCryFnoGy64wlfn3ON8cfoCUo78l87+QDH9wHdgkzNwU/gcWipmbhPGg9wW3
	iH0YGOWgDTXX9FMjwTJcTZpfb0YbCcG0fWZw0UPLYH9WQZ7ruEoPK8qJl6XNH2k5XNRZVfs6bN5
	D7D8Gh/TTeB6CNvrJD6ihjFXvh3nD/J2oJYHRiYObs0mmhYhOt+ekWo0xinb7wrh7KM//QrHPka
	vbm+BnZjYQ/cGCaTSP6kiHjlYCuJJ0jgm+NCfiaOK5Bb3gIKOQVIIn36GhQyPVbyf8d4KFjjY9O
	Xc9bUsFkY2mXX7/BTlxohSnglTo2BLQ8uJKksaHoEhDCvbQ13T74Mwq/ZHtWFHnGUfq/EXD5++R
	s+ZQefLbUeNtkA9uSW8W/7WsedRLlkKUNht8hAaaTxzGsn3jM1PopYVlqZOPB4mHTS9ikvUHXlQ
	jJ6JKzjHp7BkNZJt5jUr7qnpU0fVfjpHzORafM6itDeX5f2EvWDpozY4iPZaVqUD3L/hx/f2359
	d3menBPYKc+iw2A8zXVHImRzYKwI93sImH/M5Np1JFmxa5KXrxBxB8y1S/SZYMdhOdn2aohVg==
X-Received: by 2002:a17:903:2a8b:b0:2e9:4f7b:affd with SMTP id d9443c01a7336-2e94f7bb5bdmr57755475ad.6.1792125898232;
        Thu, 15 Oct 2026 21:44:58 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:a579:8b87:8304:7ac2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e97e8b1b5esm4137235ad.67.2026.10.15.21.44.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 21:44:57 -0700 (PDT)
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
Subject: [PATCH v4 08/12] zram: reset writeback state in zram_reset_device()
Date: Fri, 16 Oct 2026 13:44:13 +0900
Message-ID: <20261016044429.1304561-9-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261016044429.1304561-1-senozhatsky@chromium.org>
References: <20261016044429.1304561-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3DAF9120003
X-Rspam-User: 
X-Stat-Signature: 75uwyuzuji5ppf3wcn3j5duagpkfa3dy
X-HE-Tag: 1792125900-752388
X-HE-Meta: U2FsdGVkX1/uDDUSL/ZH8iIAKRGEyYL3jT6XwrWbwlouCkA7Rme0lXc7OSXr/4MkWRxPPKI5q9msH+swOPxBY5xufnufCTsrtSZi2KocEv2JVEELV5GWbLWYA+V2tkOWamH+QYIVYl2Sa65+YPYm+PVx5qUOKQ0bVr7Vcq6EKl+psXsO5UN5Fhd5eMCdG9hCllJvV7Ea1nC6RzrPHDJSTJ6CMgKMkLYbb/uJ3NkQiVH4kLINlF2Qc2e74MQMK6ZWoeKmemHeMm7qKukOX0lvz+W3m635FpFNGbL+OEVKnzHoT8KKh7rLScFjp0rRgoHJWgFmhq54L2akvCz/TtZ780IRnr1nVmeTcbvaycIMOtAhdowPZrajPe6OgRGZjDt7H5nlD0ZCo8Pbbijm6zMGrwXy1sPGFpVrB9tuGlXdPKLtkYjq8Ntb9QzfRY7nabyLuMxEZ2qz9L6Ucosa40vU0tERtvCXSaHYXEfjO3wN6z1JmhtpQbDRVm6Pdm0shA0AEDDFryJV+QMUvbfdf+Bd2xJha+M3cPDNknN9jcYdpYEXIQ9W+8eblm6+4Yapn7/PS2RKZ4kG8fyL1rlff9daaAj/Pb+12oRXx5hzwN6+MoXcTrxplHG+AQs+1I2fT+XCUPjc+gB0IfJQN3qC0rB9xVDW+o3BKPjDMzm4Z6iv0GGXJqPXGwL0Rp9PbbRmyCa+IaakCdsmuPso2wCn+Ql8gIfPDvE5ePXD/1EzCaZvmmXYDONV4y2slIgab18ObTiADHjeLCMAtpDZjFOOAOvVDME9GhzRX+FXVg+ql6ifoEdUMyrkzErs00D9Wlhxig1XEdm/eXnDIH1Zkv4O55UjEtrvnsnnO9Hhmh6ViHE4M/cKJQ8o45UTai7rx9Zlf//oZhuqC4j/aw4ZJa9ywpzP55bmQBd1MLM45lj4DgNt+8wbbO6NFT3dXfsT0WrA6zzYh+P7RthvVB02Or7jZRv
 T5emIZ+p
 GeUY+as06czF0zqDp+9Q+tvQiiD0TOh+qBJJZQ8J82mcHVqUlrH1ekcn9tUrY8KF4NJZotxdMDFubXqyrk2ZYb4/2eiKYa63NeL2+TMgSflsSkM2+WmlQ2viJL6jgfyqslIdNYN+IhJPL+7X6plYUd/DRE8NHABC9ILpsp76qVdtif0zGIPL6iCyQW50glewLGEVG26JbNQsXrdm5pFWzwnYyEriIXPNySGJjIVvsmvF32c+F+Hyn1Ey85tmpFJY/HyEvggbw2drEUOE9hhoiCtvRmiE+jw3ieuDF6wk3JqjkE583qoNKXO8hSCuT4upwIfdNxF7J+SAZufLLy90x9vwJ2JWbJJyH9G3UjklGr3/+1KBZxoQnjzSZvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reset all writeback state to its initial defaults on device reset.
We used to keep writeback related data in zram->stats, which
zram_reset_device() clears, but commit 1d69a3f8ae77 ("zram: idle
writeback fixes and cleanup") moved it (along with the newly added
wb_limit_enable) to struct zram, after which neither of them was
reset anymore.  wb_batch_size and compressed_wb, which were added
later, are not reset either.

Acked-by: Brian Geffon <bgeffon@google.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 593fa4ae47c4..0e1aa0da11aa 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -694,6 +694,7 @@ static void reset_bdev(struct zram *zram)
 	zram->disk->fops = &zram_devops;
 	kvfree(zram->bitmap);
 	zram->bitmap = NULL;
+	zram->nr_pages = 0;
 }
 
 static ssize_t backing_dev_show(struct device *dev,
@@ -2881,6 +2882,12 @@ static void zram_reset_device(struct zram *zram)
 	zram_destroy_comps(zram);
 	memset(&zram->stats, 0, sizeof(zram->stats));
 	reset_bdev(zram);
+#ifdef CONFIG_ZRAM_WRITEBACK
+	zram->wb_limit_enable = false;
+	zram->bd_wb_limit = 0;
+	zram->wb_batch_size = 32;
+	zram->compressed_wb = false;
+#endif
 }
 
 static ssize_t disksize_store(struct device *dev, struct device_attribute *attr,
-- 
2.56.0.176.g3575e65682-goog


