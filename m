Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 557BEFD530F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 08:21:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2F5F6B0088; Fri, 27 Feb 2026 03:21:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC9746B0089; Fri, 27 Feb 2026 03:21:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D5886B008A; Fri, 27 Feb 2026 03:21:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 86D4F6B0088
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 03:21:51 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3E9981A057F
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:21:51 +0000 (UTC)
X-FDA: 84489543222.16.372AC9B
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6C49A40006
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:21:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=SUuyGkyD;
	spf=pass (imf27.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772180509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f3yf5ARvnDjqHtotIsjeKl4n8R0v3XhJ9293+3JNQB0=;
	b=Ekpf4B+vm6R2YNoj8MAbKSxxNJScv2g3R+orR/TMmoHutvISPBTfpM6GawHyqc3tGkR2Im
	ZEG1JSJvFS/zApzCX6r9K9i2OT5tS22pGhCL07qOL/6RrQLaT7Dmq8FXKZlbRzw+AqFxjt
	hxPe+qrwy2yBhwyP1HutIaXCeh61ipQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=SUuyGkyD;
	spf=pass (imf27.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772180509; a=rsa-sha256;
	cv=none;
	b=aXhIhj5qg9BuOwBLqHsgva2ms/dy6uV2i9ePYuCs6irF4rpCmNqmZ1caoEVSE/AkfeV4As
	68Dgk3t+TF3xeYx78KZyHjKrZgEuGQvpfhd4ULhO9QymGzXqt4GUeSydNEp0EWoeiekfxF
	ZdfkrJmp6gn26hFwiqZa4M2taqPJSkw=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2aaed195901so9023325ad.0
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 00:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1772180508; x=1772785308; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f3yf5ARvnDjqHtotIsjeKl4n8R0v3XhJ9293+3JNQB0=;
        b=SUuyGkyDHw3bLTjdW828vQKEhLCDezoeJfa1ti0AuJvgq4suhhLV7jy6Fzan4Mk67A
         oH28ooltqBVd8Qiwl9935wiVSWsGULmhv+uR1AoOORwzF4/Aimffl0MMJEfz/nghBq88
         Fr6NtgONpmNFPDWbk27ZHwtCaNSl3YP+XUczA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772180508; x=1772785308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f3yf5ARvnDjqHtotIsjeKl4n8R0v3XhJ9293+3JNQB0=;
        b=QJyjYzGijN32f3tiIz6rrq75nrgjeII3OpZU/llmESECqKQWS4mvjHRQk0ITp62tjB
         S3HlgQsuaYWjcKSuQZy8AYTovBO8fL9kK+EDWogV8NP+QKlgdEn5UZjNIKSFN6kd/Uwn
         /s15ucdJpOZC2o68TmPdcuG5b5PuSeiTPEbc5w7zMqOhAcJPzOuSINiFJj/J04M4Iyh+
         2w9KKboJ/LWoVM7IdjJ0aepqerSny0xokLc8EjZV0cbcOgDW9U9uGXU4rXbbkrDYR3Lh
         EPgmpL7KKPh0cIW60IDziJBPDQuwbL9fsDDWOqPlMaFvUxzNGHkpKs0JcpcdAMIMMxzU
         NrVA==
X-Forwarded-Encrypted: i=1; AJvYcCUX0g4CE5aZXzjcL741WctuBAndQ2euhZCdXQMv2XNhpghgprp4KtjILEHyOxoOUY5o9r82vd7ygw==@kvack.org
X-Gm-Message-State: AOJu0Yz2iiipx96ddYeWi6SX8oDiRDHi/2qwQ/s2BfwN6AqGwAzWFJYT
	1dJATWvPmMXi9TcKhNEY/mPGC9fU3px+iXSKSK5cVyeLkEW/O3dNKim2ty2mcmwkWA==
X-Gm-Gg: ATEYQzyPdq2/cwmlEjcX3ryOeUPQjIbcSP+6uFBk7zkg2nM0m/eNQIA4Ins/3HvKym5
	ZqE945hC2hPP3/0UNN2LeMHacvlS8brqxfaDEFTyQtVzeUm9YCoeAnvkYDYTwIivfy5qyTqfbE4
	MbN2OhM+4W43jMahzLz2feSlbLIsQiEkBmqHr8mqa7FSKEMQTefXLJd/Er5JuX4Qa/FnfuzQRfA
	guzseTx6TWTtn+xFbP0hb4Nn5uLiiGy6YZBzlP/wcOHdubaw8DpWEVMdwxlXiff3Moqe2eGYWDN
	NEa863SmhUXJPQ+5X/WOFJat7ai+yI7cuoT03nzlVt8PRVSSmz2RXX9q/tu4EEudTIk0vRGZs4i
	oY70AHJiIH+xzvhNH0krEAhKE5613ABf/t9rNoEhXlOnVGSk3rjPr+cFhbbrbUZ6ZbCxt3a8e71
	C6pXDNj3/1UdykSeY833Sh5zbunHp0KVF9qvy07fUF4aK8PZMdb/JOQxXXb9Ta7VOJFmlohQzcg
	IEkpf98rkolDA==
X-Received: by 2002:a17:902:ce11:b0:2ad:c337:5a32 with SMTP id d9443c01a7336-2ae2e4b0d31mr18520555ad.28.1772180508256;
        Fri, 27 Feb 2026 00:21:48 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:280f:e47e:6718:7698])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb69fa4fsm48796025ad.45.2026.02.27.00.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 00:21:47 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Brian Geffon <bgeffon@google.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 2/5] zram: drop ->num_active_comps
Date: Fri, 27 Feb 2026 17:21:08 +0900
Message-ID: <eb7cd3ca578320be9aff13e71298fc36e110af41.1772180459.git.senozhatsky@chromium.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
In-Reply-To: <8a5d53d19a8dbd51d7d81d153676895163e0735e.1772180459.git.senozhatsky@chromium.org>
References: <8a5d53d19a8dbd51d7d81d153676895163e0735e.1772180459.git.senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6C49A40006
X-Stat-Signature: bses6dcj1x4g43zhuk8n5nqi7z1w17w7
X-HE-Tag: 1772180509-193445
X-HE-Meta: U2FsdGVkX180yAHUVv8v85obExb+7muM7RHCAUdn/3yIpEaYx9vnvPfHBvsoYqbeX9hR2pSIAVXkoqLOKsrtmzIjqKVk8LpQD95GX0skhAi+88i32LJSJytJ183ctGKaswn1d4B7PDWuS2Z8uz6uWxSwWPgQyKWjj8cNCvfDWPAL+hDTY6hEWG8+4ekmSchdaXMMdMA9K19+WaTqyVvSaJzcWrY/oUxK+W16KFan5PtbVCb/5I/F7RQMkYVOGL/KYE4RRmVTdpWzf4gK//bak6TWkm7hsNy2xepgu1iY+BgoPIYuu73TgI5NTvS1HRAPWtAtLjlQV+oR9WrsAf3HFygQ7PFbuCEnAuL4Xasb3srxm8LXEkCt2H3RVVlxmxz+UYj746CpmnVQMeCWejzJRoBdPsIMec417z/rFKf2MW7vyLymlfpHia8Z2pz3OIM8AVOImLuWVF1e99ZY3xc6iFJMPVT7EW20Dwz/cVAen5UKIBiI/+agUaB45r89WwA+JJ5c6BHlhP3bSrUEIQckNKaBVh2b8n0ioHAYfhsGGDiJemldVaCvhzN+JCdM2L+YEx99WfngwgubUkAg0/EmgSS9TCBPXq3aVnh/Qp7FafUWECLd7w0l3FYUVshUWNh6iCkGx31FPbURisVn0K04DIk4KDirm17poKV0PXWp/w/16BZchaQ3sVUGpTbbJPtKV2V7sPboQzqpQXbdEZb8UYQMSGmSK6/qDw82zpUixasD7RpTuoDtsTZM3sqdPK4Y8QOeXBiNYniGdmRtJBfD22WcKxqJS9artdQArRGsUxjhdUJd8TVfjH/44OafKWYwFMOeWM0/VjJolR9XBFliD8oLtEgiyBRgFHe+C8tsYcxtYM7GZpsB9dzw3pcch1+o+JdQweVvJ185GBVsLCu1vkqBecEznT9Z4u2IKU0Vu3HibGqwhu1eU7GxYJAyvQj35I77BQ7iuskmQu/IAvF
 r02dENB+
 f9/7hzTN1+jhTaa7xpa1jtdKXfP8YPkLRULeww+HatVG4x0gYU3xLiX7YWrZRkxGEzQfS2q4dI2QgDCBt/HZfN7eaBkezRiybmy/Vus3o0Hxe+L7Bv7fgHANS/RM6b2n5fJKU9StHpVFdXI4Dolhs0UdclLnnl1B6dBF4Ny3Cfl+D8181mE4sa6b8DT9jGWs2BhQYNTJWM7/1chcLm/O49qEFa6uRgjUkQPGwlLCznGluaTUEStXg1PcJhkHLFkOM3Kh1HhSEOlhyQB+1GRaIiNqhG+W+aAOHbKJ+jxQUHST+N86TYhX7i5Lj3LwoM1Nlvb1zBnwxfdu0tSDqt5UfudvYO1fPKwnfRjh6J53GR7qFmSf4zUEmxOzYRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's not entirely correct to use ->num_active_comps for
max-prio limit, as ->num_active_comps just tells the
number of configured algorithms, not the max configured
priority.  For instance, in the following theoretical
example:

    [lz4] [nil] [nil] [deflate]

->num_active_comps is 2, while the actual max-prio is 3.

Drop ->num_active_comps and use ZRAM_MAX_COMPS instead.

Suggested-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 29 ++++++++++++++++-------------
 drivers/block/zram/zram_drv.h |  1 -
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 53e0bbf9d6ec..6ca5a76c3865 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2371,6 +2371,18 @@ static int scan_slots_for_recompress(struct zram *zram, u32 mode, u32 prio_max,
 	return 0;
 }
 
+static bool highest_priority_algorithm(struct zram *zram, u32 prio)
+{
+	u32 p;
+
+	for (p = prio + 1; p < ZRAM_MAX_COMPS; p++) {
+		if (zram->comp_algs[p])
+			return false;
+	}
+
+	return true;
+}
+
 /*
  * This function will decompress (unless it's ZRAM_HUGE) the page and then
  * attempt to compress it using provided compression algorithm priority
@@ -2478,12 +2490,11 @@ static int recompress_slot(struct zram *zram, u32 index, struct page *page,
 		 * Secondary algorithms failed to re-compress the page
 		 * in a way that would save memory.
 		 *
-		 * Mark the object incompressible if the max-priority
-		 * algorithm couldn't re-compress it.
+		 * Mark the object incompressible if the max-priority (the
+		 * last configured one) algorithm couldn't re-compress it.
 		 */
-		if (prio < zram->num_active_comps)
-			return 0;
-		set_slot_flag(zram, index, ZRAM_INCOMPRESSIBLE);
+		if (highest_priority_algorithm(zram, prio))
+			set_slot_flag(zram, index, ZRAM_INCOMPRESSIBLE);
 		return 0;
 	}
 
@@ -2615,12 +2626,6 @@ static ssize_t recompress_store(struct device *dev,
 		}
 	}
 
-	prio_max = min(prio_max, (u32)zram->num_active_comps);
-	if (prio >= prio_max) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	if (prio < ZRAM_SECONDARY_COMP || prio >= ZRAM_MAX_COMPS) {
 		ret = -EINVAL;
 		goto out;
@@ -2833,7 +2838,6 @@ static void zram_destroy_comps(struct zram *zram)
 		if (!comp)
 			continue;
 		zcomp_destroy(comp);
-		zram->num_active_comps--;
 	}
 
 	for (prio = ZRAM_PRIMARY_COMP; prio < ZRAM_MAX_COMPS; prio++)
@@ -2898,7 +2902,6 @@ static ssize_t disksize_store(struct device *dev, struct device_attribute *attr,
 		}
 
 		zram->comps[prio] = comp;
-		zram->num_active_comps++;
 	}
 	zram->disksize = disksize;
 	set_capacity_and_notify(zram->disk, zram->disksize >> SECTOR_SHIFT);
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index f0de8f8218f5..08d1774c15db 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -125,7 +125,6 @@ struct zram {
 	 */
 	u64 disksize;	/* bytes */
 	const char *comp_algs[ZRAM_MAX_COMPS];
-	s8 num_active_comps;
 	/*
 	 * zram is claimed so open request will be failed
 	 */
-- 
2.53.0.473.g4a7958ca14-goog


