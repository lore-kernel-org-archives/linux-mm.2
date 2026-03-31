Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20D56FF60CE
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 06:27:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3EF06B008C; Tue, 31 Mar 2026 02:27:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEF4D6B0095; Tue, 31 Mar 2026 02:27:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDDEB6B0096; Tue, 31 Mar 2026 02:27:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C848A6B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 02:27:03 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EA65213C069
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:27:02 +0000 (UTC)
X-FDA: 84605375484.23.D53F7D9
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1570540009
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:27:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=bgaeDLGi;
	spf=pass (imf01.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.42 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774938421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=iFuV2hrKChe8VPlJWziIwCmvIdRAMcpeZAmPUEU/b+E=;
	b=c+dtiCzLSeysDVt1Jelm6HL7vCLkUQm6oyDBXVele7JFNs6VE70tl5+9SERleTNyyBhzj8
	/HMKnJhQ80vwDJ8fBTY0qUh6WUllLQ0ETnDdk20CtnkVZTBNStY/kYiiBWuXaaV/PT4M31
	MAOPvK2FNfys9hOBVIxVEmknAZKqIBM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774938421; a=rsa-sha256;
	cv=none;
	b=5SiVPCvOWOwGUlnHz8YggbaPMC6ZqePjRWTdrSfBYl47q/bpvMBpy++vp+RqK/rG0JQiMj
	PGkJn5G7sG4ecT0Xjfz39XBbjEfs7SiWrXq9Q3t3jInYwA5pP1VBxiEpiYuuwJOOIS6pQI
	nyERDyakoXop2RpmVW0vP8+l0XV1SUk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=bgaeDLGi;
	spf=pass (imf01.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.42 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-354bc7c2c46so3125830a91.0
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 23:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1774938420; x=1775543220; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iFuV2hrKChe8VPlJWziIwCmvIdRAMcpeZAmPUEU/b+E=;
        b=bgaeDLGihNDbdWafoI88XiDXdcuopQLOehWFhirLvmeKsItmbFVkQtDa9RXZXfmokF
         s1b5xwJZIRY89w4WFcv/39XJ0M7u1FAZ5u4A7HUps+JgBBcKW2c5li9EescV9iy4LNdA
         uBucvmKCv73P0A1scpAGxVj6xXi4kdARuCBCk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774938420; x=1775543220;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iFuV2hrKChe8VPlJWziIwCmvIdRAMcpeZAmPUEU/b+E=;
        b=Vy1xf5RSeFOnNYmLdAw/e8WVd+vKhlwKR8lRw+d1C645FBhoL66+lvJG1gi7i0Dwwj
         F0Ll80S3G6DU3X3N0DZqj8xtxMwD5F4XA11B4q0na+YszQ2Naa48HTG02If8rXHM1uHr
         90F6KQ6DXq4TbOeo2PNUkbxEG9EXHP3YIojdWyPI9YPj8Xl44hvSu5/0wX+96Bsf74Co
         O3eDN2RLx8YqYiDwSKrxselUM6yCwfFVSK0IN54gHCZge69EkmSRa8AfVpQmSKTaGveR
         a8FYu8KvuyRrJ05ekRWNByglBAv69/1Qyh7BAFvr0C4dYkC/JFAqFu2aykphHzVr3NOz
         7CJA==
X-Forwarded-Encrypted: i=1; AJvYcCVVq2kwA7wWkhCOiud3aqSZcHFWwtK5qG7FS5xpeXfvXPlLEsXFryylfeFI4oaKmjnkVZ+jmsjjCQ==@kvack.org
X-Gm-Message-State: AOJu0YzGnSMvuF/qVS8hjAqsaBHjRBDfO8VVwtSaZ89F9ZZ+PGuIs5t9
	YlbFEevHczEdrpmm0csOxsx5qU6JhExEgQ1C6TanBE2R7yfg6reXw+IB0LyU4sgmDg==
X-Gm-Gg: ATEYQzy1pILH5cBWowY9Ni4oJwLZNCDqLeb8BxkLEEVe4PAmprxtnx8ZUh/sRgmz8Y4
	rj2QzDuQ4xp+aRbrrjThij+L+vs7XgN052wRXakSo2JX9LfB1poblEORzwCOB9mUb7jWfQwMekX
	aS5Cpo1tXaE9WEOLlMlE/NCjp/YyWZvbeCNZzU19OQ07vQxLtFnq0QMUCiIvKc0zwITdMNrpHPI
	2HL2o1jotKCqt7yUFatNgsvZpwiOFVXJX4yEtvlRrRkd4hdB1OjCDaZCO/zvxGx+yXO0wdba/74
	7tynEspMxiUMh34Ng03Yge3vXhuhrcdMkdTovyfwzeM4oppeFpnI4fT6uYK+R2iq9/reld7kTer
	AiKYyQ6CYMNh/B5EHaNWgsC67A+4LKyEpP7PoqJQ7+XE8bSj8LcVcPEeelA8DBusVPeh/3/m/x9
	1/kR4p0IPven84P8jB3E3mkZmNb7m/S6smW4ukfU8QhvKudZPlUBpXAvZRlzBWLF0GLOx2Hy7wC
	THVKMIfw5Fqqw==
X-Received: by 2002:a17:903:19eb:b0:2b0:5a4c:726a with SMTP id d9443c01a7336-2b0cdcd55f7mr169704795ad.43.1774938419771;
        Mon, 30 Mar 2026 23:26:59 -0700 (PDT)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:90ef:61f3:1679:56f5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b24ddc0afbsm90813585ad.64.2026.03.30.23.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 23:26:59 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Brian Geffon <bgeffon@google.com>
Cc: Richard Chang <richardycc@google.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Suren Baghdasaryan <surenb@google.com>
Subject: [RFC PATCH] zram: update ac_time of written back slots
Date: Tue, 31 Mar 2026 15:25:59 +0900
Message-ID: <20260331062648.596077-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: ar8p5nre5nwprgbfwdg67yy5yq4fgxji
X-Rspamd-Queue-Id: 1570540009
X-Rspam-User: 
X-HE-Tag: 1774938420-383450
X-HE-Meta: U2FsdGVkX18HTuS9EBj14XNx3ZAx9/urjKnF3YkTk8ujwIm74mN5EuimZOWoKMTiXKAXSeJNDtVzwRZpPBxeqqDvAwxWDm1o0rZcjAzPHCnLuR2wxmxQ3GPQpgQD2Z1vRei5BEQPE3IalvYFHIUa4CMFDnyFUFkW70NoUF8+7P91e4rwU20GcgpZkO0FfEtjkcMcxiHe/4/cgPpHCo54n8t/K+RfFoI9THM18Jcz7tBoxc5C1M9LbsSkNnfcEC8r4ZJC9mGRGuz6vQ13f+5cm2NjsUflqEaRlsveLVyYfxPXOjkRhXW0gcT3pGmHkWUFYaYssC/EgJqsXoYZEO5ULubSGfZbD2e5ys/9djgRS/1M6HbwjILKatTw9NIPG3/LuRaLgJtTUH3IZBJwef+h01/p92bdBo7sP9uZvRAs3JJvGk1SBWOC2Cn5vyjfsNlQ2WBfL0CrclZI+Gn6wb+/Cn7tAjXvTSbb4qzTGTOi7QGWAX/4EypXwDsr6JmYahySiqlz/9FqZZlaND7k4KdASQ1EeAaU+JAfsyzWRii0vn2x5xC2pdggWDbBgDa5qrphrpV71DjzT6WXSOINYbMs5GHoJMjlnnjvIYhjagFyZjAWVGK1rFcWRgz2UYPWwv/svuXrBGX/RWRyOIkFKwQGJ+w/zgdRvBxFgA8QKE520fm4UzYjyltOoS0G18DkADUQSVlIvizYfUOqLCJ4GIZx1RcNd0g5RQjVNc0IFA3frHSsLjDl1O4hrv3Zc1Z7zs+IO6d1ug06PBoKUNfiulvyQmQCz8LH5PGmto+lM31tyOgn9R1dOu3ztvlwxEYdkTFToG0T4zQKRfygYBe9CzrdgUnj7GOtmq/3JEgWnmsNV6Y103evmHG1zEDGnsw8bk89vDwC2Y8rLCbmcOVmEv4Uhwe7kltqZKHlolqRWsvFql3HcmXR/Xq6enj11vHgfj19NJg47QtCRd0MfWQw/e1
 cpLyWMGq
 1zJb2gcJz9uC4qONpNKojOe0pvy9Q6z/MTOFqRte4elRTAovAPc30LaYRgWNs8Ni0xlPJTcgkI2aFxysBOggKl5Y4IruKpM778bl0sVQN4u5S2ZLcGysPJQ1uNAz1ML4oFfG2/12ZBMjObXd0P6Jb4UBpw3FYJl68DSXBG8hcd4+bciWbadWe4qnOqnY1XZJdDrBrDRWRrYCLAN7JjxWFqU7H4mtPG1fFpb1UhNFg00P41QvYE23eCR8qwbOjoV1MaTIQqvHeOaHmtDxcK9lTQCucY6KU/wZvZ9ISUh39a/qZntT7nB5oqUlpPLCF6KQlYHRiTsAkTBiR9XnHGir1VEjeuUm+LoheDTkDDS2tr7mshbmz7Siug/aecpD/6XbukO2jmBEG9xKsRX4cz8Xe01VKK/IO1oWFM8cz+YsCSC/nawGoAsE9AoLPWF8dMZVG/zFppU/0S99GDos=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This makes it possible to tell how long each particular
ZRAM_WB slot stays on the disk and, basically, to monitor
writeback efficiency.

Note that the patch factors out a small update_slot_ac_time()
helper, which we call on writeback completion, instead of
calling mark_slot_accessed().  The reasons being is that
mark_slot_accessed() clears ZRAM_PP_SLOT flag ahead of time,
while we want to keep that flag set as long as the slot is on
the post-processing list (unless the slot is freed concurrently).

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Suggested-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Brian Geffon <bgeffon@google.com>
---
 drivers/block/zram/zram_drv.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 5ecc4ba40e9d..dcea703a6766 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -185,15 +185,20 @@ static inline u32 get_slot_comp_priority(struct zram *zram, u32 index)
 	return prio & ZRAM_COMP_PRIORITY_MASK;
 }
 
-static void mark_slot_accessed(struct zram *zram, u32 index)
+static void update_slot_ac_time(struct zram *zram, u32 index)
 {
-	clear_slot_flag(zram, index, ZRAM_IDLE);
-	clear_slot_flag(zram, index, ZRAM_PP_SLOT);
 #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
 	zram->table[index].attr.ac_time = (u32)ktime_get_boottime_seconds();
 #endif
 }
 
+static void mark_slot_accessed(struct zram *zram, u32 index)
+{
+	clear_slot_flag(zram, index, ZRAM_IDLE);
+	clear_slot_flag(zram, index, ZRAM_PP_SLOT);
+	update_slot_ac_time(zram, index);
+}
+
 static inline void update_used_max(struct zram *zram, const unsigned long pages)
 {
 	unsigned long cur_max = atomic_long_read(&zram->stats.max_used_pages);
@@ -952,6 +957,7 @@ static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
 	zs_free(zram->mem_pool, get_slot_handle(zram, index));
 	set_slot_handle(zram, index, req->blk_idx);
 	set_slot_flag(zram, index, ZRAM_WB);
+	update_slot_ac_time(zram, index);
 
 out:
 	slot_unlock(zram, index);
-- 
2.53.0.1018.g2bb0e51243-goog


