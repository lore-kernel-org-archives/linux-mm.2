Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F95CD2D0E5
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 12:17:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 964436B008A; Tue, 13 Jan 2026 07:17:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9112D6B008C; Tue, 13 Jan 2026 07:17:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80FCD6B0095; Tue, 13 Jan 2026 07:17:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6FD576B008A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 07:17:23 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 259E913A5EF
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:17:23 +0000 (UTC)
X-FDA: 84326840766.26.C774C6F
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf08.hostedemail.com (Postfix) with ESMTP id 59BDE160005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:17:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="bJkdTPM/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768306641; a=rsa-sha256;
	cv=none;
	b=CcJLIl6EDyIViTeoFWRSDIbcqt30UoiNbvMd5zRJ+U0WVDH6J/5qFaNqC2H18zysrL5IOO
	F0vPs+Fl81r28VYbWG2LhNAVXqPFJRV5dzN6HBfena97VaDycxSsnQHixf0rfEL1VE5Zyw
	ySfG/oxKVxkBzdl48x26X6ZsBKNGCFs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="bJkdTPM/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768306641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DabuHi3K9u7UKNn7EoClhxIBJInkjBMtz9wL6ThmFfQ=;
	b=xt8Pw03fEBY2DxBNZ5shdpacdpFrzgWHTNGVncqnaMVn1QpSgAQyvK8fAd1YBjoeJcJNmy
	2rudkwDWthSKSJ9HtOzmFVgH5YdON/KHLrjsn9B3FB/1Ck3PP9fP0x03sw08MU9s8Uliwe
	pI+BMwfkOgQWThd99dMstPSdy1EjvxY=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-bc0d7255434so3353516a12.0
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 04:17:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768306640; x=1768911440; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DabuHi3K9u7UKNn7EoClhxIBJInkjBMtz9wL6ThmFfQ=;
        b=bJkdTPM/tVZ1NZaFo2zPGSCqVTJ7at9tE647ZhX+thG85zkpUjhb406WM27FLrexfb
         e/sysz2I10bwUQtKS+LxEDJR89vx314hbu8YtxNtAzpe7zB7S67va4m93Udks4bVJpNr
         dtho4qVDfF1AgEGm60geV9R4bf3BQ8/wylU2RLNk1nURZXZaitIyeDuuudvs/nwIuT7u
         HQa1eXVKI2fDn4IExY2IzDLc6FHv40+EFY/8IiNSxyPM3SKqQyUbZZk6u96FyYsoBuJ9
         rUi3GdUYv0ZD+FSVUvOXexg7FjZaT+yhu9Aju4O97VRPmb9v9w5+Vg+OaOHHrs7KMm5R
         2Viw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768306640; x=1768911440;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DabuHi3K9u7UKNn7EoClhxIBJInkjBMtz9wL6ThmFfQ=;
        b=jiqSTlFNOYF1OQ51WtiROyOk6Shr4csT9pienB9Apo4DJo72fHX5j1kKCkQDacUEO3
         MTSWdWA+I2KNUEXfz1NmBVJUfy34IKa2cARYzXLxBv3XKNt2+ObW1TbywE95y0x/Jvyy
         Ip0xnHiFEK6G/+G4ou5yxtq89CDNMq/yOUw8f+GiqEgblVymsy/I0yVjw1HgaT/9hPxh
         S2YiwkNN5CNYZ4pC/zfAZCEL9IhkTMbTvLeq0zDKKX8HxZymCjzfYawdafC947UdvAoJ
         I0+sEgrPs2eadbN1vjqexe/VceL3+MnX/xjZVoTQ6bhIbuvNAaol08Jor+RMIo8/SWUT
         QdOg==
X-Forwarded-Encrypted: i=1; AJvYcCU21M86nVM3i4Pu7EUFnDSyTMx/elgd+/bVl7QCIkuG/sbrLkOw0GqgWs6qp46Z+8T/yoRmFjt4pg==@kvack.org
X-Gm-Message-State: AOJu0YyO4LfcdoaTmFsbtRJendKlRmvhTCijnbaOBgI4OQiAs8XbFozP
	bW05cIGrXJllXQIEIALlWABTrrjlBhZZyYhO/wEd/Em1Ky7EmlBIbOe/
X-Gm-Gg: AY/fxX7AVKSr8bzXD4re/TM9aYD0EwebTW4T8G+NJNAOaT3C0swTw3pvjAOQGVdBwqY
	8Bw50frceKO51iXjYqJNKh00AwGUh7SrR/zrfIf78dGjZ9hTiqCjtjnUNgyB13Yx+a6yaW5lDR8
	uWiR566tiGgzKP9IJD1rx2zcknNiPsVko5wQLBfTQHRB5O2eMY2X58GdbyaU+PlBPa3khbGa8NU
	kZXVjBKjzpA4dhbtKVj+cCT0FlXKPlYC0px393c6PYJ67HRGxavQtPlHZbSAGASjqS1MUuRyPAF
	YOkUvXFFtm+ptSI+dTROiTfeL/Y3pxV3+t6e5hN9YoRpmZmocfIeof13zwJtuU3szXIvCep5MlK
	Czujkp67O7hM2UklF7o+95zbMsyyk4YDZJQrdi0A2r68J6XE2ZMaiaO//zYJBklaaNkwW+XuyCj
	W+YypLbMAXSJ1X
X-Google-Smtp-Source: AGHT+IHcMGs8PoLCswC0jcVFT7uA/GxGBxuYPiLqvqoQfhZ141q5O7/FTfDa2atu+Qn3ppbT66iemg==
X-Received: by 2002:a05:6a21:3286:b0:34e:865e:8a65 with SMTP id adf61e73a8af0-3898f9cd677mr23369587637.52.1768306640111;
        Tue, 13 Jan 2026 04:17:20 -0800 (PST)
Received: from HP-Note-Host.. ([222.234.91.137])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-c4cbf28faf8sm20775186a12.7.2026.01.13.04.17.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 04:17:19 -0800 (PST)
From: JaeJoon Jung <rgbi3307@gmail.com>
To: sj@kernel.org
Cc: JaeJoon Jung <rgbi3307@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rgbi3307@nate.com
Subject: [PATCH 1/2] mm/damon/core: modified and tunning damon_split_regions_of()
Date: Tue, 13 Jan 2026 21:16:42 +0900
Message-ID: <20260113121646.31441-1-rgbi3307@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 59BDE160005
X-Stat-Signature: 91cauz9newqjshyqqujndzq8qmx5iqex
X-Rspam-User: 
X-HE-Tag: 1768306641-470806
X-HE-Meta: U2FsdGVkX18KvLHaWU1OHZFjL17rp3uQ5u1/Zd94Ss7R31djnXcYhiPgntNeHh1L5NmtzkIWoY6XFCqatlqEkisQ4VsQ7Os4FLQNf5f9MY72zKTTTENA4yY8zQPpcdZDW/0R8A73xTnHNFe1OxhfXeMfjR6liiYQjv9YNt5IaHFUbcl3rhavAWvgXkYOnm2vv7tP7s40fLU1azO7bYJLXjUgpfgklybr1A4iim8it867uK5G9XaK90zs44pLG1OdYLOMVoBSOn2UbNWwjEPCe4bVoVg4raZcZdr2lX1Vx4D3gWWxDtGgfRDwnPv8D4ebLUaoep9/rc8NJxLRf18SmGU22efTWgfAt0t22HU18Cc0TLHU3nUeJiN/g9kqDJam+vGrQ5j+8csDzqsH07+Q/zLg33XLhFS8CTB+ye0u75V2KMLBhYOveBlWN4+mmJfB+JAE7XO1dw6Rna1j916d9wLWwdCGE4HZiSe/0l95EUzH6NnccO5Bijg3jAhCDOGwZ61iBLAytPJkYynpz4iimx+M4DRODz/t6ivitsEG+Q2pdyUtLBY6bPGIWj5c9XrlBNYBdEfUsjmbJOaU2dbj+ePyFgL1/P3jF7ZKsHQCFm7v/6urrPxGIaTUtdSVxiKP+1XobMZfW4xMeMuh8NVAhBK7hwshN5G2dK5UCk+b0w341ob5xQjhv9TCBvO2Cp2N+JtgqrxsL8r8FHJHywaiz0pIcQYPxW2RB88bUOQM4Vz8dJ3NxK0qU+m3SPcvhNc5toQ3sIKtaJK/azQz9/NC/UeXMKtBmT9uQ+wVYnwu1KhOFOkJzWr/yU61UtR5c2SQ5ctDYTaQRiSF61sp259ZxR5JINdMoTTm6Vp7ICufWlYdAN5A9lodY4Y4Dbf3+RVFApY3ngB1JQtWbbVzYd9m3iaQbe10+O7aJZCjtVyaOpTnNiJaIcgPYPaR/jyGux7R0/S+nwulDUhBnuzBHK6
 gdot4+4D
 YmeqDE62gtz939r9226qHaAoVMWYCkTqz+kPnjvcDi4FF4xtKt3YPui3ITpOdPJmDQU292TZdM4bliRvOWHs7MKFQ9TW0EoofmkYWoJXig28ZDPP8Vq3GWt6MTbyd/9583TWgxhH2/a55bwZ4EYDItP6Y08PuTKUaauTrriIbO0C8oC9DupI9vroQ21YkKN9eeKNbkY77zchX9N6A76S8QhE/RFyjeuMPPkFMQOXLGrJUmhiE6BdQDX9s+H8YrypFSu8lGGSngWDGGiUyv846nhEkXvxhaL6eI27ShALRJOYdj0K95lLDhl2FxfLQYxe5LKJEft7aP7fLxCZJtiKE2vR8KwOWxwGVm0x/vykqjIMVaRM5xrEr1gNXA/G09cIIJLNinM/DZj6g/1jiypxwoT1Up+guoaWhcSSD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.001894, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Before modification:
                                                             sz_region
    |--------|--------|--------||--------|--------|--------|--------|
nr_subs:     1        2        3        4        5                  9
split random:    <----------- (*] randmon        LOST -------------->

When dividing sz_region at rand, the random value may be small, such as
1 or 2.  At this time, there is a problem that only the front areas
corresponding to 1 and 2 are divided, and the remaining back area
becomes too wide.  If the area is too wide, there will be many missed
address access judgments.

After modification:
                                                             sz_region
    |--------|--------|--------|--------|--------|--------|--------||
nr_subs:     1        2        3        4        5                  9
split from   <------------ (sz_region / nr_subs) ------------------>

It is recommended to divide sz_region evenly in the ratio (sz_region /
nr_subs) rather than using rand.  In this way, if you decide nr_subs well,
you can logically match the number of divisions and their sizes.

Signed-off-by: JaeJoon Jung <rgbi3307@gmail.com>
---
 mm/damon/core.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index f9fc0375890a..ff9af9d6a788 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2394,27 +2394,18 @@ static void damon_split_regions_of(struct damon_target *t, int nr_subs,
 				  unsigned long min_sz_region)
 {
 	struct damon_region *r, *next;
-	unsigned long sz_region, sz_sub = 0;
+	unsigned long sz_region, sz_sub;
 	int i;

 	damon_for_each_region_safe(r, next, t) {
 		sz_region = damon_sz_region(r);
+		sz_sub = ALIGN_DOWN(sz_region / nr_subs, min_sz_region);

-		for (i = 0; i < nr_subs - 1 &&
-				sz_region > 2 * min_sz_region; i++) {
-			/*
-			 * Randomly select size of left sub-region to be at
-			 * least 10 percent and at most 90% of original region
-			 */
-			sz_sub = ALIGN_DOWN(damon_rand(1, 10) *
-					sz_region / 10, min_sz_region);
-			/* Do not allow blank region */
-			if (sz_sub == 0 || sz_sub >= sz_region)
-				continue;
+		if (sz_sub < min_sz_region)
+			continue;

-			damon_split_region_at(t, r, sz_sub);
-			sz_region = sz_sub;
-		}
+		for (i = 1; i < nr_subs; i++)
+			damon_split_region_at(t, r, sz_region - sz_sub * i);
 	}
 }

--
2.43.0


