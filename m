Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1712CD5BD1
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 12:35:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F9FD6B0136; Sun, 31 May 2026 08:35:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3840A6B0138; Sun, 31 May 2026 08:35:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 273386B0139; Sun, 31 May 2026 08:35:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 120D66B0136
	for <linux-mm@kvack.org>; Sun, 31 May 2026 08:35:44 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CA0028D136
	for <linux-mm@kvack.org>; Sun, 31 May 2026 12:35:43 +0000 (UTC)
X-FDA: 84827661366.21.AA87956
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id DECEF120003
	for <linux-mm@kvack.org>; Sun, 31 May 2026 12:35:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aHJ+jbXp;
	spf=pass (imf29.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780230941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=EfgyKc7oYPiDXAc6Y5k9wYfmjU0jfx8Oqt1OQ3/P3TI=;
	b=zynl/99OF7t9O7Q1Oe3mtLXn/LcFsTWOIN9/5lr9RcfsYBukalQOycSntvgdw9C3L0e2bU
	s9XmubdQX6pJc/z5gAAvLBfH4+9Ra4rAfqGVvnm/LJgJ5WKF70RLQF1K7jvThA1BgLDjdp
	wZ2gIAAiIJMrhrAYerKTQBafLFjq5rs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780230941; a=rsa-sha256;
	cv=none;
	b=ru1/shn9AGsOvB6gN27+TwguX1u8fb0TPEQexsIXJLKdlYFsJnazI1G/xnUnzq5FHIEw71
	el+N3yMcpsKKXziQHbylN38x6queeCcXo4X/LDlt94jqV/DthQXOCWPJuMxnXU+ILxjfS1
	hpcjYoIMsvScgL7z3oqf+Ld7uBr35G0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aHJ+jbXp;
	spf=pass (imf29.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2c0c2d8b95bso3131705ad.1
        for <linux-mm@kvack.org>; Sun, 31 May 2026 05:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780230941; x=1780835741; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EfgyKc7oYPiDXAc6Y5k9wYfmjU0jfx8Oqt1OQ3/P3TI=;
        b=aHJ+jbXpUHcCuBUEJvP6oMvA/QqD2pDmY9tA9fxCpszqPYK1++z1pDTeGhAKClOHoJ
         Lr8AjWSy+dJA6Cn0bqicv4mTau4Pj+oxnvrbt3gvvErmxgZPoH+JTuiyVL2Zqiqnht0p
         lzUckcS7qXB9pB/EWFfex76uNctB1HCkdhw0nMi56WMb6vS23EeOpQKHpBicVKWcdZYb
         7ddIMMeWdgniOq6IVnFns94R4PwkoV9TUDGp7EzCWz+HwlBZ8nZBv7VfQQoQeoUWP02K
         nzCmrgotPfgMn+BI0am4wE6sKFRuvX07NNl3HCHsy079qkhteFcBsYZSdFKtS6rq5G26
         WMhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780230941; x=1780835741;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EfgyKc7oYPiDXAc6Y5k9wYfmjU0jfx8Oqt1OQ3/P3TI=;
        b=KRk9hhw1HU1az2YXrnsisNhRXDR27pt+LYoqE1Uv41UQKyIuSVVoeYTfQHKMXfnhj6
         xOZmU6+BsKLFPe/3t16Xm0MmKXrO1j7UwMXWSvSqMAY0ODXd5xAMPh+8X/rYC04Fsbog
         LmbmtlKA4TAAtqPDEBTWnCUtgNeKZ4ZeObto/bLNTWBdxLEfaYuZRGjyRU2yCJ8w5j92
         Xnn/capGndwhDOOZ79Kx1mi8DNuq6Sjn+OBWcFJj8LdjsfB9uW+wAjCSUmqsBYWfRZsa
         1SkERmZDeFCKs8xtBn6luf1y2zCxEtAjaWanhBJ3Tq5m7L1G6C4V4tluXEDe7DpGPv9H
         mM/A==
X-Forwarded-Encrypted: i=1; AFNElJ/PsdJhKOQ0YWRRP0WtPZ03jtwta3KclNFxXyH4dEl7kwFhZdkuyscH/9f7Rsf1h5aGc67oqRu+jw==@kvack.org
X-Gm-Message-State: AOJu0YyL+K3FiEvXb/z41MDJuqQXbgFdkiFf1edNPDjN8Fbcn6CubNWZ
	PuNG4Y8CtnasYGIboRhbUhoVnrFcxqFcK6xB0Kw3NM1i8/9NoaLwcxs0
X-Gm-Gg: Acq92OEZ0ft2EsF5MBxHYGG4UIMTdpRe3htsJhTp6StCBkt+Bqi5LRXqE8CdoUV74uy
	aRJl/GdwMl6gRFdrpyUuU9YFbsGRrZmyDI7KL3gzmELO/Tt/6VPXlHbE1yTrg7QyGrtIpr5RMJz
	g++6d47+m7jd3fHpvPS7I95e1tglDqCEhl3gm7ffW3TVxNMrdkpN3y1BHIThb573Sx5Xx54B+HM
	1r3EeZ8jai/CIGLT1gVkVcydtFZi7YWl9oWxrCQdEEO1vUDxkVyhxY3RO6tFx1va8TFGBRFmcjv
	GGZ0ABeuDR4zrMkjf7jkb7wqqEcrywsVJCNBUlW2DX57Ci8PlaGqgxwxzqqqTt/71HaNb9PCiIN
	Q1zsLx4vDW1cI0xhIaCYPs1Tn6OOOMPmta8FczO3cpRz/Y6RDTciSX+tCWn+7B01+tj53dmxTNh
	qBAhtRknmAWtuZ1uDZEKRGombaGLupdOYk295eKkqbMPsI3w1FI4pyXz9SrmcVlpK58E4NQlkrT
	bF4Eb2f4g==
X-Received: by 2002:a17:903:3585:b0:2bd:a5e:4c66 with SMTP id d9443c01a7336-2bf367c2510mr81775325ad.14.1780230940704;
        Sun, 31 May 2026 05:35:40 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf23b011d3sm75581205ad.52.2026.05.31.05.35.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2026 05:35:40 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Sun, 31 May 2026 20:35:16 +0800
Subject: [PATCH] zram: fix partial I/O config check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260531-zram-fix-partial-io-config-check-on-akpm-v1-1-eb085d98faea@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAMrHGoC/x2NSQ7CMAwAv1L5jKUmQFi+UnEwxmmt0iRyEEJU/
 TsRxznMzApVTKXCtVvB5K1Vc2rgdh3wRGkU1Edj8L0P/XHv8Gu0YNQPFrKX0hM1I+cUdUSehGf
 MCWkuC3Lw98vJH1yIZ2i5YtK0/2q4bdsPilMcgnoAAAA=
To: Minchan Kim <minchan@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, Jens Axboe <axboe@kernel.dk>, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-mm@kvack.org, Christoph Hellwig <hch@lst.de>, 
 Jianyue Wu <wujianyue000@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openssh-sha256; t=1780230924; l=1070;
 i=wujianyue000@gmail.com; s=id_ed25519; h=from:subject:message-id;
 bh=5K6jI7JFHe7FUIvV9uN1RWnD5dUnVYFc8z5pQxjkUFc=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgW51Zh3v9nG0Wlld2Ti8ylp1TnO7yB
 H+z9CbXty/WEAQAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QBkwggpDqSVHNBr+N81oydCDWAZf7H8FHq6RvO+oz1JCXQJEzyz8+E3c5iCUO5K71cROfmO25gN
 o1oQ7x00ADgE=
X-Developer-Key: i=wujianyue000@gmail.com; a=openssh;
 fpr=SHA256:gVWBPJbHGWlCIw+V8F63Ff0k21S7AB5+rZt8+huemvg
X-Rspamd-Server: rspam11
X-Stat-Signature: 3xez54pt4degzzgt3jtty3d469drer9i
X-Rspamd-Queue-Id: DECEF120003
X-Rspam-User: 
X-HE-Tag: 1780230941-469845
X-HE-Meta: U2FsdGVkX1/thsdmMBB/kiPyXsl4HJtQOrNz735PCcneYddRxXJ5bNSDRjxsG75UFKjPRMmBDj4ueogff2zrK2FKQP/X4l0P3awG5W6Pl+YUt9IRyfcwXmoNjjXWRxeUtZy7WGVtva9r30HbUKfdWg/qsIDt15YNLM9pIqIyrKmQTcft5bZj3BrVX1VvODUNOGFZ3L8jTccRbr7p3vhren4co8Dc/7A/32EO57LxalK/fofUIVLxkIm09d4n2Y8WghpJ6GGGQLY4Nl57VwBN2zyzAJHOvh/xlz6m7csTyRGvZTvsj6CNMLYzlegQS3MAPUFjhk/u/ehedYZxY5y8NYPIiY+iWHC10U2TQt50Zr22Oe/2Gq3shq1z0nE3mcnvPAGYUkUgj+aOXJJEcoSuuabOfz9T83OG7oqG6VhHvHV2vkst0ydjWQdjJro0/7KTNnigl3fXuJP0Fz33vNAhhdGJ5+K6FBuRg8DdpqBgxpXFwgzN6K5swrg9RmpfN7iuKvfQNyZ03AOyoplByCXE5v2n57jb26SD+DXAn7Kdo7CAYRZuqWq+A0UE8RvbRZ+4UwltOZd6GhupnWF/tQwK2ffIaTSjLDSxcroAXhOBbgmVwHmhdG5dsq8fJRd+C0Mwkq6refrFpy+vnWj/q3fB4AtDe7SS+f9e/kOz1G9ijT1trKEJxnVKTpR2+4yAVPrPQWjIgiPTWXMnJDi7h8r6Q8kB8c5Xr2XLh1VgHQoaifjPSlAPu21WIWfiHwrLM5ANV7We9zj7DenzhAzU+DUdtOT61qtJuOEDr0Hcb3cnTOws97aya57BzwN4V6MeQH0eUpU1lk6Da5uP1nHFcgg3+I+V8Up6KyCCxXKHcQy5oEpBXVTohkogxrh0Yp0fDBV8VgjKKFQ+LanBrjvBYh17gZuiJMqqUYrUs3HDFOqs0da6JEl+f8YNYZQTkIDcT576gf/Jqz+83rUMTcr6/Da
 i8Alog77
 cOf4kotdn5bXJkl8aCsLwyqfzhTW8tHCAd2kuXs6I3992YlvVDhK2uJ+89a7jHd5d0zn/irdZhru9rP2zAncA51dq5/k34nPf0hJ7TZz6DdkR/2OLhqZEquBey88CKKUaF9MIxM6otfwFWa3GqcOqhX5isIV1XDcmIf2ZMNn7O7yRWTf/p+pDWENFbj8Oyiegl+DhuKLWRcCNkc7fsfdV6IJQ265YW0XwfnxkuxB6Q5toRrcCV+n8xXqyzgb6R2Hx1w1ZM2Q/bHw/7OdFVPfCWR5p07KbI24VIxLHs1SG9rc2aUARXJ0KCy9Wr8/yx1oU+Y9/7qyflKGIVFSgxIbpGLWGdHvJh/MrHoSGEfHJ6WYLpA+cvmFv7DFlsUXV96nruB+XkMVkIB8uaB0TUSfPufzIRGu/vYdDZAKOk0c3vH3FIfuLDLBgkokXV+ZrHlEpfJQY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

IS_ENABLED() expects a CONFIG_* symbol. Use the real Kconfig symbol so
this warning reflects whether synchronous partial I/O is built in.

Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
zram: fix partial I/O config check
---
 drivers/block/zram/zram_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 6e1330ce4bc1..72f89fd5572e 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1510,7 +1510,7 @@ static int read_from_bdev(struct zram *zram, struct page *page, u32 index,
 {
 	atomic64_inc(&zram->stats.bd_reads);
 	if (!parent) {
-		if (WARN_ON_ONCE(!IS_ENABLED(ZRAM_PARTIAL_IO)))
+		if (WARN_ON_ONCE(!IS_ENABLED(CONFIG_ZRAM_PARTIAL_IO)))
 			return -EIO;
 		return read_from_bdev_sync(zram, page, index, blk_idx);
 	}

---
base-commit: 404fb4f38e8f38469dfff4df0205c9d18eeb1f57
change-id: 20260531-zram-fix-partial-io-config-check-on-akpm-c62b972416f8

Best regards,
-- 
Jianyue Wu <wujianyue000@gmail.com>


