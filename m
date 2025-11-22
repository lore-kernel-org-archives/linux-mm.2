Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 864DACF64B1
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 07:41:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 079CE6B0012; Sat, 22 Nov 2025 02:41:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02A126B0022; Sat, 22 Nov 2025 02:41:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD2B86B0023; Sat, 22 Nov 2025 02:41:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B6E776B0012
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 02:41:06 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 69D001407EB
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 07:41:06 +0000 (UTC)
X-FDA: 84137446932.22.66B6F7F
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7D3CC40011
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 07:41:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=W1Qh27oZ;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf01.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763797264; a=rsa-sha256;
	cv=none;
	b=sNcPdrXkpJB0HD3bua27vyU3sDH9Uky/AuyrQmc3/LoDPTNO7zPbBh47xB0UGVJchwyDOV
	AyvkzLSadFnu4k2R88+g/iUw3cu4POgxWqztNGNWWQoY/e0NRg4mdJkuXMQYFxXbnUrt7O
	u2sFLdQV2BDiliuX/YKkjgqXyLzBqjc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=W1Qh27oZ;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf01.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763797264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LukW8/snVEFz9ku8flFGtdBZP5+NLLDt4ByDCK08AXY=;
	b=4/HizjXwFhBjTh+JyDMKaiWBroNNQVHBWNBIqDLCcTFmWXod1CvUorcBG4WEJRF/5LvwVa
	Kp9hu0rlo5TPLU/YzjbVQ73CQTLkohyAYDO1YHiFigqydwwiv3/GnCPXcH0LNW17XOTZd9
	myD39tCfRjnr1vQmdsrQ1AFrmI1dUzc=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-29555415c5fso30516815ad.1
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 23:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763797263; x=1764402063; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LukW8/snVEFz9ku8flFGtdBZP5+NLLDt4ByDCK08AXY=;
        b=W1Qh27oZTghG/6tF6ASbjxK5ZTCt4mGajKYkP2Urrm3UxcYc4V71p0do7duR+Xn+BS
         Wa/3n1h8Z0RoGVAA/VZNg6P9QM6A1crGJQticj0MuPII8j70qdq825Ke0CeOquaBOiXa
         CvtQz37+1knnk1xC8eYbQhOMpwCwj7AZiQejE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763797263; x=1764402063;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LukW8/snVEFz9ku8flFGtdBZP5+NLLDt4ByDCK08AXY=;
        b=qI5/AwLkNG7ssWHefD3+4TRpL2mvMSmFgik3rBjanlJn871lIGLKKEWIh56kzwd5uW
         2mg7d9kwhRwpA3I4Y/qIVL70PlUnGaiIDgCSTfBMqBeNLLQp3ZGesDvKy5ZhzT4Vnw2a
         Iecz8IYHRhvOrkBKGbD5GeGAk5C/pTzBrppS9tKa5ElwRoo+qpf3LgFc27gLIZGBCmcH
         stFOR3iw9/P3lXve85TIoM8N2RfF4EEX8W7NW9BXH6ozdCbf9EAzNOMKSTnbAoumwKR+
         +vRGxvG0LnWpZhsXuDBUjn79yerIxvUQ1cMqYcZyGOukbFx+46i7StkYyEfamMtKI7Ey
         5FPw==
X-Forwarded-Encrypted: i=1; AJvYcCVG/+QrYJBq4PDUBYoilUbur1/pWbYaCm9t3fXX+vKmfjcLjbo1uhCBR0BvK93Z50gBDpSrhik+sg==@kvack.org
X-Gm-Message-State: AOJu0YwilOnO5315s+f8lfUqPEjVpxNs2ciBp/CGO1xGZGxpmI1EcgU6
	GXABKRSPsBobhP0LcdGOclsZwZbIDR/1CX/MU5GmtSmAAbPZ2tYc5N21QIw5xPQXKmrXiO3PfkW
	ExRg=
X-Gm-Gg: ASbGnct6Shig4X2a9NiX1Dlpo3BwkPlgdYS7NLrOQfae7/GtvZHZ2rSiWkPkPDVsYQr
	HunealNY5B7qj0p852XApVGNAuJSyz0EQcQqq+w+TOReQCP4VInfop5IqqjzIPnOMRaPAYYPg2I
	TKUDgVnqSjqVHWqm+8FtolaYw6tNtNeC84i2ZsUMSnebt37aNtSlU5V1twjSel0TIduL2Ed/7SX
	XCBFrBvb4XiIsKSKixyxN6SbmP8jnIs2qhLvD3UjGNwW3Q/8KQxPgIiO/hUzhqofv/Z0mCaPSHF
	e403WSpIlit+ykaYMYiEvdhQ2lbFLQERGDsMD5ouQzAvJxvulf00sdzlpGH4eOJRiIU5379e8u9
	5UhueCHJ82zcBJIZ3MSarhZYfrCh//U/dbPZydlf6+V+I2aLT7+8iZ4Kw/94y+MqO9Pk+hNUyjS
	7koSiGMS2B2RrGVRFDrQUk8+fuCCgy2o4RDq+Wslup0uawmRnIZW/l+xgeYffqG3WAqZA/6IEn1
	w==
X-Google-Smtp-Source: AGHT+IG5fXLGOtdx1TXZEsH8pnjPldKBNeNKvpm0G0lpVW65pfoy/FrInnxHNz+d96LXs8VdsDk4Tg==
X-Received: by 2002:a17:903:19d0:b0:295:2276:6704 with SMTP id d9443c01a7336-29b6c6cdf6cmr49815225ad.51.1763797263463;
        Fri, 21 Nov 2025 23:41:03 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:948e:149d:963b:f660])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29b5b138628sm77771555ad.31.2025.11.21.23.41.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 23:41:03 -0800 (PST)
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
Subject: [PATCHv6 6/6] zram: read slot block idx under slot lock
Date: Sat, 22 Nov 2025 16:40:29 +0900
Message-ID: <20251122074029.3948921-7-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.460.gd25c4c69ec-goog
In-Reply-To: <20251122074029.3948921-1-senozhatsky@chromium.org>
References: <20251122074029.3948921-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7D3CC40011
X-Stat-Signature: o3741epfhan88ac884c3xd6cxpc8hgg5
X-HE-Tag: 1763797264-8961
X-HE-Meta: U2FsdGVkX18S7KnhsjHZ9ikSW0+javfZJXcWKWwAE5kkf0oT47wRKR1cxGU3G+0bLh7iuZ+FipI0ACDVzmoXZHRFoxrqU4CxgtdU3lmlsN88FTbg21k2i8HJSKnO5oEPQqGdQIQFaZj5aVXXg/7+956fGvO035YKWdcUcJ+Lq4SnJLjGwXYyKOfHvkxnbdv95VqZsWpi/ilbgnO+jTKHls40NtIfAjwrlqTwQ1ZuSV1S+CUKHtET2KXaW/2xdAsPY3bnWw6/C/HapeOqPPqkKAWeX8Lv04W3W1+yk+yln+cv88aG1e5Keh6r0hcDDKVUHiysVjokKZZ1JNyn4iRDExp+NzyzVFYzXz1Xgqw5/YYhY40lEK36I/OLnNfvBi+HpKm5ruM15zbqTYDKieyd9K4jJqcJCP+8iIaKaz2y7edEuzEg4zXIZbul6ubPKEMHdA4K+B59JvUxayuiHmnpOvszkFAq55tfu1grMCK0vpEh3SemA95Fm7mFYnE/jDPZgi3m8KZnUxVWXEeXRJA34IbMZw1pLTaM2fc/PYjJSn0OHWGgBaEWj9/VaDzVBuCyQ3zW3zlredR83TSULvvFB117g91SMQXo4wTpq1tV0bUpsgYp19LmxUj8im/x/yAtwddd0yAb0T2MwLRkBwXc+8pOGCL/BVyc+YwYpAhNeLkWeoEKgZShEZ8TTYualg0UeUCfPhUxPOFnYs8qz6CQVSnuQVyAYSYIljsXlp3WjR4u8wDqTp0+fNb+rFoJFno7qaP+M7J5XUxsIRAStbIXY/GLY5mitayeV+KUw5XuSBDS585j4cNcQNcQhLtkD6rzi0Dk1VYPPPvYxLqcaWXrfVpTGG/hxL/4jEVbFTPCw2Kfx96s8Q2DA61LS1CAKCZz9nH1YIIwrcblN/oL6QbtAtjh2ghe2XrKnUUXPsHK3f/otsP2U6zBonM6CQkfpGJfvXTbv8OmTPVGKM4jMt3
 G6icjr52
 8O3qj8ztbDun7kadPjQ6Ekb8P1SM9mwVfjCxXX+0RYFydR51IEeq4ZnVKGdRC/paIzn57Kqm2JO6nzFU4I6vYoCCFEOvhuoslbHrvR/HpQ2LyTnLC+qLivgc3AUZSPiIUj0p/T/zTfCVIIF8rL9yiPS+9tgx08e9IYnkzBFDGsWFIrSgJjaOI+t9gSt29lsMwgMG9aaXjxg8pD+uDm0jQqUc1fhTcIpDz2sLZmUaeKYuejBSBAkPxxb7jJCgi+RhhJKDoIZI/TI/9v+/lcgoxKLe+QKNLby9jZJPVPTqZAyexnk5R/mHXJei6FQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Read slot's block id under slot-lock.  We release the
slot-lock for bdev read so, technically, slot still can
get freed in the meantime, but at least we will read
bdev block (page) that holds previous know slot data,
not from slot->handle bdev block, which can be anything
at that point.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 1f7e9e914d34..3428f647d0a7 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1995,14 +1995,14 @@ static int zram_read_page(struct zram *zram, struct page *page, u32 index,
 		ret = zram_read_from_zspool(zram, page, index);
 		zram_slot_unlock(zram, index);
 	} else {
+		unsigned long blk_idx = zram_get_handle(zram, index);
+
 		/*
 		 * The slot should be unlocked before reading from the backing
 		 * device.
 		 */
 		zram_slot_unlock(zram, index);
-
-		ret = read_from_bdev(zram, page, zram_get_handle(zram, index),
-				     parent);
+		ret = read_from_bdev(zram, page, blk_idx, parent);
 	}
 
 	/* Should NEVER happen. Return bio error if it does. */
-- 
2.52.0.460.gd25c4c69ec-goog


