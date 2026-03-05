Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DBBCEFCE56
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 02:16:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAB406B0005; Wed,  4 Mar 2026 21:16:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C57F56B0088; Wed,  4 Mar 2026 21:16:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B57196B0089; Wed,  4 Mar 2026 21:16:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A3A9D6B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 21:16:33 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 109C95A3E7
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 02:16:33 +0000 (UTC)
X-FDA: 84510395466.13.FB44B3A
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3C9A74000B
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 02:16:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=QDbPAmcp;
	spf=pass (imf17.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772676991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=esyn4MiJLCvi8Tm+OqaXpfyuFYdwvpybvevGJy0UR3M=;
	b=ziwixgIrcsqOkLA7yYYGQMcE+w/UyzwHcR+OvlvdB9x4ASOPiXyJf3o2OG+sE9k04MGW1Z
	caspZRae9/jegMGGsPD6aEUmrWEnrNAgnGoc4QPqXHafeshBX+pvPA9aC/0K8DS0XuqJiA
	A6pNiv4o6xBt475E7ycOLKKgK4IPHAw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772676991; a=rsa-sha256;
	cv=none;
	b=Q3vU6FXSSj0StPDfh0a0nG7T1PKgzFNZrS3lfD0sm+aWR+fWt/iHuLg7xN7TN940c1Gmor
	zrey2xdIkeq7c8bATe19wDllVYXBWLr1+ZKIEKGC3drC0RCFkw5PTuwALT0Lj3/t6bTsSg
	LFQhnIHWF3TBKyKcHzGwEbYRhui0FLQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=QDbPAmcp;
	spf=pass (imf17.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-827336c0994so4347017b3a.0
        for <linux-mm@kvack.org>; Wed, 04 Mar 2026 18:16:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1772676990; x=1773281790; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=esyn4MiJLCvi8Tm+OqaXpfyuFYdwvpybvevGJy0UR3M=;
        b=QDbPAmcpkA3UmZmsDtVBlpLZT4ZcyotvCr3UVRrWM+KGVe1orfrdB4hF5I9W9kk3/O
         wp63h1sDoPHFCF+EL65xMKF/CURX/OWvmvdYx3yXRfzMmOVVMDmfmoQxH7yB0X28rj+3
         1MgeaYqL5wuhf66JPzvu02Yp5TIoags0SDhmg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772676990; x=1773281790;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=esyn4MiJLCvi8Tm+OqaXpfyuFYdwvpybvevGJy0UR3M=;
        b=di4IhrdEmPVBzZAE91Uxqb3sqgyIkyY5RD9HOgaZd2nefjr186CHIT6AcqsNbbWaWs
         6W0DaZQUCxg0V2GjFDrwAuBGOCJP7WyZSJ+g6OM6egnHZxP3LXfgOOFR5p5OfEbG1eKZ
         izOnc8W/y/q/gbRjFACftChLoD0xIk6iOZeOClYUJLFCDWWZbk1ja3U7FO7A8kHdngdP
         FlDozLkckM3fdKAMkpB9v0NrpacK+oH9TyKc5lvpX1rBouG4uPYoejqOPRACF71M8UwL
         CfbEyoHcm6SaAkIqa68KsjK0iC8LSPpu+NRa+k4EIOUBoG+Su/5xJOZYtWApDTnnCKCq
         tNyQ==
X-Forwarded-Encrypted: i=1; AJvYcCXWVEFcbMVqPgyWX8R81aWADadbsDSz7+Ur36PBB+ZLKkhKWpO600/+4utNxP/Jv4QbX60rwX6zCQ==@kvack.org
X-Gm-Message-State: AOJu0YzNmG57yIgHa2ZOGC75OImbaQ0Ti0HPV/3vwxNB3FZRp81wJh4j
	7yW/WnYM8zFKGSjrKuAC4aDyVpLq66HYBb56d0khHfgBf2YcZiUi7j2FojeRkODgPg==
X-Gm-Gg: ATEYQzwN4iZVXX5EWMbVP1hNYEmF67FhmxESzlqCRds0Xa2fEQNYXnfhKKUI2fUu9hm
	cTQ7+SzwarQo2uMEkS+p7iDNHVpOFN20sWGdsdFgqMWzeL3n2evly0eHVXGxE1hrWl7koFH6q33
	Hbk+8A/fyxzAQkrxIODchvI9Xq/wz+W/tgTZyO092NU2HOxtaCSOWLu82pxzSFmIhPrkw6P0l7d
	bdAHVkilljCt2v+fx/ANmal8tFVIVzW1zMZutEBvOCIQ+3mrmRdQiUG4NQDnNpxNdqH4tMZNgNF
	iR22w/ju0qCC1MupmH0CSvpPGF2GwON4NzgkZGHJT6bwt9wq3BuR+f4k6yU4txdw/2G5cSvQokY
	9HRBA5H+yyA+R5uqgSYMuYSyvOuMqCKzDNn8V1Xqka2fNbX6z3QmpX+Oc2H4+wrqTAafm/Yb6hR
	IdGdmjZWvKcxHhr8gW0jdmsJUdUtpiWG6raNLAHaJPf1yL3akFaJ1oXgV2hH09QZbFXIMGb4lbf
	bLX5GRBIhp8bEEQIQML6SrQ
X-Received: by 2002:a05:6a21:6492:b0:394:5fdc:cd19 with SMTP id adf61e73a8af0-3984239bf6dmr701023637.10.1772676989980;
        Wed, 04 Mar 2026 18:16:29 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:713c:a5b2:ae9d:686d])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c738d87b2c3sm418348a12.13.2026.03.04.18.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2026 18:16:29 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Brian Geffon <bgeffon@google.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH] zram: use GFP_KERNEL for post-processing slot allocation
Date: Thu,  5 Mar 2026 11:16:03 +0900
Message-ID: <20260305021619.617481-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 3qduhw48ojf3jej5mj69wy1bn75krd6b
X-Rspamd-Queue-Id: 3C9A74000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1772676991-487715
X-HE-Meta: U2FsdGVkX19TM2CM5pYjf40FV83Nc1ej1cMgz+OzzfMH85Z0HtfCAPkaXKOG9yyzfctVvx4KVqGRuafavGqvh4rrfsdQxyjJyEWYEYOsPZIA/M4tGgPGM2ZdU5pcMLRxHC7oOhTXhFmCOh1QmRbOx2N/cLozpbjNkItJT2jedU+fM0RfcX9Bfv/l6jhe1U4xsqytN7vmtsYF5L5/an0UngYL6gOthwGOe8ASVwGxR/iaKNJ4ALrlQme2NWEXbI6GsAjOME8sZZAcVf2F7AYeTlfCHsyGFKwCg18J4tMCQ2uqTTmM2CIyReAeE4dxb/OO3FZIfW8u7iolwQ2jUi9f6dRUCCOnmZB+fVSNIKHSJQt9srfFrwkqypf8DjamV3A2YNGTyerz5F019e2aTzLpock9gZrU3DTc8iYEkJTD8ceFdJVrSHQJPmtBBj98ovqlGVi5LNw7LXEaDUALkl09DjBvWHxHzgbWwjgEaE0vgSq+eLF2wBLnQMmtcvJqCfdk5fFso2TzUfFM+xqSKW49KPvu1zBmsfMTfhCCKKctvVcGWBd/h+yy4/1bHSqEJoDs0HFjP5O/mgb9tXpO2XhUje5ElfsaxtTpfapFAaBI3xE/PEtks7Cp+ZV+Jb3ZvtQ7NNDzIP5uELUYkCeRlbqm/ZA02iD/kGuveD/NKQMv8CO8ym//r5AxL5k+MU0Yi4B6qe9be4J06p+SYxLDS4eFKqW1nuThDWqUHq++LoBVuc+KhYTbUd5SKgsvapDM/SeKxKCwNQ1cMgBEvIdlCsxZFitJHjTTWm+cZ9Ei4rG2WRJiCH9LsMyGa0hE0cEzmBPR4IIj/QYsib5K0wrg91Kw4V2+7i3Cx6C2eYqeZ/JyxgD9rWAFSqYSuAWjmtoxW1Gyju3Jmu/+p8L7pHDZZhBmIrGkrl+zVo9TTxQzi9bp2wXAQLCEy1uDifyJWd2/CC37+NDCP18b4y4hxEk+zkh
 Hdtgad0n
 qzGV8WGTICGKS2i7sKNLEBJCSeXgXC/ZZfq1gBD1u00/gpY6ThYqek6y1BcC/2xv5vCLBMJ5+eMmkOAZ5ObfPQMd5FJHBjgbEzExcrZmsDvQg65DqWPhXYUFlSqyHy3Ga+02ppj9BiYMzvbtI6VpQ8G7wAio04PgEo+tLlPE0V97+pwQGH+ygxZgQK2KuDOtswrQuj16Y7xrTu6lIsXpdGMcTuA2NkYWffsxZhjawvJb3iw1fWUBgFsqBQCTnstBQ0Dve2hBh7Cfa5azKL5iyeCqYZHRP/jovVsVjGJGwji41nBkbeph2czPqPU2VDLixhquTedvers5oEx5OOQiAWISTT1MJ3q3Bbnkilw4RoDN1ZGTN1vZDiGa/lnNqoM+APwMaoKTP38yq2VXk2wNaruhv0FjMEEEp4MwI2A1GoUc/e2Lma0xwhkur3ulVf/QPSNxrs9ImLWEQYheAPFhfk1eeSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Post-processing slot allocation used to be performed under
slot bit-lock, so gfp was restricted, then we switched to
a sleepable slot lock but gpf still remained restricted.
Drop that restriction and use GFP_KERNEL instead.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index fa38d26119ec..6a6fd08a5a15 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -297,7 +297,7 @@ static bool place_pp_slot(struct zram *zram, struct zram_pp_ctl *ctl,
 	struct zram_pp_slot *pps;
 	u32 bid;
 
-	pps = kmalloc_obj(*pps, GFP_NOIO | __GFP_NOWARN);
+	pps = kmalloc_obj(*pps, GFP_KERNEL | __GFP_NOWARN);
 	if (!pps)
 		return false;
 
-- 
2.53.0.473.g4a7958ca14-goog


