Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60BFBCF8865
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:22:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF0056B00D8; Thu, 20 Nov 2025 10:22:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E53D36B00DB; Thu, 20 Nov 2025 10:22:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA52B6B00DC; Thu, 20 Nov 2025 10:22:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B6B4B6B00D8
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:22:24 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7B4111394EB
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:22:24 +0000 (UTC)
X-FDA: 84131351808.09.8621D1D
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9C8E81C0002
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:22:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=AViNnHnY;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf21.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763652142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hNBO1q43Z4HLMo3u95PxV7vGEr2bqJ5I/H/pDo2xib0=;
	b=X62bPnz6QHnC9lr5bIL2jxP1zPxRt+3K8bGqAjylkVgjre/pX9NUhaVNmtdFGzEJUe6d8l
	84VTW9w2Eb1Npq5Gy3abKRklUF5IsXkDvqD06vGhw7YJgWtflB7qaPR4fevyUmxoTApuJj
	ze/3wv71jK5iAua/+vnB+7ym0QdqrvA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763652142; a=rsa-sha256;
	cv=none;
	b=Nf8S+UCGdcMBaMK5vZOhXONMMuFnCB8X119rlqjrOUZ9dsYO27qcOltTuEEuQmVvxOhHtJ
	VyvUf6FQ5C+cc0SQnCiIRCuXLQzpnSZsyTMwIXDInUpNrVrmGLuVfx047nFhAgIQ1012ER
	P9/JyGUmJsd6Jyhdiu0d0wvXDG2AXtg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=AViNnHnY;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf21.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7b86e0d9615so1279978b3a.0
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:22:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763652141; x=1764256941; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hNBO1q43Z4HLMo3u95PxV7vGEr2bqJ5I/H/pDo2xib0=;
        b=AViNnHnY8qJaJkfOogjTUNZi36bmfLy52MKCfmcewEVm2RD01cmI3JCliKNlIJyBYp
         bytIm0eyWUAfLWmXCX19it+2s/6LqRheqKbgHmw09R67tRELCIS5goMYX8m5TnLYwaxt
         58GW5TOrR8ZcZOnIx1x+UtCT5yFpjBw1U2Mvg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763652141; x=1764256941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hNBO1q43Z4HLMo3u95PxV7vGEr2bqJ5I/H/pDo2xib0=;
        b=m/cz8+EJIjvU3u/FUgeI6SFDGaUY9dU73asyOvIP1B68DBW4lnwbJHPDWR6GENeyCv
         GnjDa1keGSJlwmZ9LMAGA6r3fGPEQZpIgTYpP1dmbti4da2LlPgheWwErCew/J4AKnuI
         LqVV13mcH+AgbZ30gQD9iSQXd1t1tZWyVVm7AgcNVg3CY3+sza4K0kW+0mUv7RiKN3hv
         1D30DhB4Vm+TqkWRAHn+i/krVZGlU7BI0hveE5FMY161g5LLNpEflByus/qfM2AT9aHy
         u/+D04mn2z/RbIVCjsXVKF4hEBSMUAwSRHl03APjEXaugdGQ/3C7GhKlGCyJLmbBJywL
         2XeQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJ1l79MkuBLKUi49EwCmTCwJWjkfWAAyT3dwLa5fgoExBJsYqqFEpqzsbykr9GpPkR09aR/3lHPQ==@kvack.org
X-Gm-Message-State: AOJu0YxBNk3f5eks4cH3CFQjgoaKXRc/h2bGYCkoFKg/zDEuQB1TCv6I
	c3NRk15n59qXvW372t0wvST2sVfSmfRnk6cd880GfCgUQnJPXE4N8incyOhqh0dnlg==
X-Gm-Gg: ASbGncsvQvRinUWUd+3WEOTg8ILzb2Xc/GxlPKtJ8Hi97AK4aUuNwrYGvCrrvUSihow
	b3xmFxhPbu3KJ2ndYw7oZ3Cf2b3Nj2W2m8uAte6zwI3HoHJxshmJidZ5s6vC51mNDGOMo8jk79Q
	+8Io89VLLjLLNnvmSU82uSiKey+My77iDvR7cQzw6rL+5zE4E3H1K/VNY8Rmdim1ubKkTC6qhGG
	XVO2M8Ca9hHu5hIQ7oH5t2JG0dzpHfQNnjzzNY5K0r5ygYv3UiPDpvuX5/t3HaahMkGAszSd6tl
	3d9CIIzmdfbK8rPP/zsOkG2OKhGw//W21pL64r6j2Q8UPyRwe2u0I7Ca1SGuiOPffLHQAdE8iyG
	ZePs5cUCAZXE2DUcctQkvMKblC9e4GJv6PAnERt4SP5faWWyUZi0bFa+q/l4V8zM8KyQHw16nXo
	o90B2T2ZPYXU6SzwJM/JiPm+Yrzrjlro+sIvg8uQ==
X-Google-Smtp-Source: AGHT+IGM/LtK9fM0SsN5LsA6eyPljhRQtoqszEcAtB8Xy29m8uMD4FUL1K10u/XIZzdHc9yqVpK3Kw==
X-Received: by 2002:a05:6a00:3926:b0:7aa:2d04:ccf6 with SMTP id d2e1a72fcca58-7c3f211a3femr4367565b3a.0.1763652141473;
        Thu, 20 Nov 2025 07:22:21 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2401:fa00:8f:203:6762:7dba:8487:43a1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3f023f968sm3179642b3a.38.2025.11.20.07.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 07:22:21 -0800 (PST)
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
Subject: [RFC PATCHv5 6/6] zram: read slot block idx under slot lock
Date: Fri, 21 Nov 2025 00:21:26 +0900
Message-ID: <20251120152126.3126298-7-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251120152126.3126298-1-senozhatsky@chromium.org>
References: <20251120152126.3126298-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9od7bjz4rho1kd31n6uxgc4tz6w5szqs
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C8E81C0002
X-Rspamd-Server: rspam10
X-HE-Tag: 1763652142-358716
X-HE-Meta: U2FsdGVkX18FR2ykMugVYggoFsrqc5aoC+PJttnP6/DisBNCl2Ir1mN7aGFau3LGXmkfRp96UHK80+7765g60fH53/UIqCrRUyx3cNe3jajCU7AgSVb36gCHm9TCh1bwaApUvpBrXJs1Ojw9Uw5DzUdhuYn/1Ry7SzAUY0UPxLNd8RCgQ2lfEhA6QbmJQhnG/LVAGKiRVwCWQS9gbY++N7+H0ijJCglo5f2UI4nyTPXegzXXCKU3y4Smv5MDPFk8RUWJ2/x+vWyNsNOmt6v9yM5lQNTdd81Vm8Ah2PKvJnCzh2jTpqfKvGCcDG1C3+ZsAEdQBE/ROfMU79tVpcuwM5WdhXXIawLzu6HBMAYOuLIzpt7HckzQpWLos1XP5eBx6KjILSFZQqxb8YKxdjiS/RSu1wJ+m9E6VoS1l7Y7Ie/RLIt3820Jn2EnzNQ4x8JR14V37oBboudscmKxiWreDnezzpVEp+kKIRT7M4g4n9jE0/bvDlBv11vpK9LB7Ogx1OfHggrsCp4B7q3ZBCVnruxrp6sA1wxJMp5SN+Tt6wkHz5P43N3VZnQSG45PFefwgayIPmse1YY4ecS3fEMknlUd81dsPzyX2fERnqEdyd2ZMwHIjKL6UiOaXA0tapXqOH8TNKdzhS6v3YYyriiKHPgDTZtZ9tofSX0HQeYnT3JW3vWiwpKk1dRMezWmo8YVhQdDzIsm9xs51+ZtBUdDYOjc0ndJ3MY+Wl8krK9r+zFuMVRYZhD2PxnWNqDVSZh1+o3TbM14zJ184mnchiznj9nu1p67Mn9/qV6rXnNZDmD5wlQUIEapfgrSEim7TExU9XoBJ17dC2kordjldvMeXbim8tKOQUHc3oDKhopjz0z2zgd4/jmZWAp0j2EnguUFJfs+9EsuCxtA5YnwcrK3tjyQeMymrN0MhUf4d42KQT6RKhBYABmL9KjylzEG1+MxDmBa72H1gyYJ7dESoBX
 ZueA2Hq9
 H804O3eoRzYvX977MznPJQLFROAmZdssUOA0g/zMxRl3AiN756mtUQK90x9Qm43bTaE5Hl5AthkqKfP0xdYgIborAuc3DrRkLsWXxsHrcoPc5kJDx3kreHgxetO51778Xlb1e6Si+IfstYjuqWVILfZmB3eKf1z/C26uwWCEXxwj8VFpBxC8JooEfShoS/xRvvzh8oyYSwsuywbAwM+oa9CviTxlYfgdS/oXuJvrYC/aB5R3/jfPTvXCFoHKUj+lOqMJgMmMg9QFj8kQ9itlr7qnpaeB4Ojt+Wfye+o8WFepsjzFLF/WVD80unA==
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
index ecbd9b25dfed..1f2867cd587e 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1994,14 +1994,14 @@ static int zram_read_page(struct zram *zram, struct page *page, u32 index,
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
2.52.0.rc1.455.g30608eb744-goog


