Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FEA9C44527
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:47:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BF246B00BA; Mon, 20 Jul 2026 05:47:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 896F66B00BB; Mon, 20 Jul 2026 05:47:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D36D6B00C4; Mon, 20 Jul 2026 05:47:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 507C56B00BA
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:47:06 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D1405807D7
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:47:05 +0000 (UTC)
X-FDA: 85008676410.15.5A759EA
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf28.hostedemail.com (Postfix) with ESMTP id 29C9FC000C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:47:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aHKJsKZw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784540824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NXXO5Tq1xzHOucyWExyfULz72X/w8Civg1XxI0ISuio=;
	b=tEdatDGE/DQbx7nij9jmfZhv9UQxUDOfhP6nfagCRHP3kfKBaamFCigN30Dn4TSPCN283U
	9xY/DisSoiJA6Nybn0MQzTPw/bC1Z/a11rVCxWQYeBXH/2NvyrSoRNKG3RbdXuGMpluzZ0
	0BC76UZ3E3Yn6NwGM7/8vf1FCCHYUCo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aHKJsKZw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784540824;
	b=2fkO/3cSJTl/aqdHxjWUMjM5pAOa0X7LNy8vHLUxOdZFozxDovK+9RFWB1mZb2ZC5SJoYc
	loon/DvSXPsMKUnDfdZ1B6Hl7DesGZpgyEUrkGgPZxdXK+yKkVjbI7A2OK+HGiP6/XWoIv
	wMtb5zj52Sh6qeIik+nPVCneEQWj8tY=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2ceb096e675so96696915ad.0
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784540823; x=1785145623; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NXXO5Tq1xzHOucyWExyfULz72X/w8Civg1XxI0ISuio=;
        b=aHKJsKZwjb4sEZZwoeH9y27bx3v6WJ9YT8dUjwYao/gwg3uv9hYV8BNdaGksLHQQq3
         lAyR6xFNvHaTRvne+B1HI0vax9Ll99teOvS6aPkgN1bN+kWqQ+l6NGYzt+Du2bKRNVG2
         Bizfg82UCkOfHWExLtnq2SRkkOVGrk4CTC9wmhVOimgS0wPWoFtrImmMRraEcFkQ5jLc
         MtVIhQ0o9fUttpekqIfGoFtoJOV0X66mgPj8L0pkHFanpWl1RDvE7RMHFmtce9wLbj9p
         goPgF3sbAtYyf+7StX5eDXXtE8fg3u0M4xKEMuFxi0Ah+hXCGfo7cBadbk0r9fzWmvls
         5Kjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784540823; x=1785145623;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NXXO5Tq1xzHOucyWExyfULz72X/w8Civg1XxI0ISuio=;
        b=A3ZrsmmPd2GcYGWQu6TE5KqG4TPn3nqxtC8glUCfc0NOcYz13OHJyrO4tJ+iuByrw7
         ihvgddKSNWTh19vU2t8akVNdpb6tAjZXyOe1q3bp4znYKNpx3LI8fVVo7xiCM3na13Zx
         5gsDhsjCkDxrSVc8+SG0kCl71dLw2IYQ7jpxWjp8sbhF2PDCIu0TvPkrlfvUbss2IBjI
         n7DbSynUqDjctYJffvfmopc+IFwH0FvUTD3dHCiG7NXilq8UjuZnar3qG64u/XjS/dyD
         7eCaFvzRfONipXvOFvX3TqQHhJEyB7gp/A/1alrS4yTlRcti564sDxJzAT51sjSNzZBh
         N7Bg==
X-Forwarded-Encrypted: i=1; AHgh+Rrhd+zkeJlzUSpMoJ/2m8q3neCzW4Zuf/+J6OFLTp5NDLEcBrA+lSPfC41t9NxdDgszB9PD8A+5AQ==@kvack.org
X-Gm-Message-State: AOJu0YzR3efMRwuVidnsSflymf4r55RtITNy/CIf2BUsNSfwSJvPK3rP
	4Gq/PG+7vCFQfacK9YgY7W4d1HLa9NzvRno4CkBcetChAMnsyF791xBN
X-Gm-Gg: AfdE7cmd4HdWt2UuhM6ei/mfG1UWRgpUfDiRzJnqYbyGg+2tgkkoWh/ZJ5vcPojYXiy
	71wMY2b0qtiMzaWDCpJwlUcKL3f2c2ORrxGthszIkMwm5L/xsejRHlKiJBoX3VjIXXZq6TWRSu2
	uiHauoITaTlRUKCUhOQsTljKneWvPjAXYTgE322/acmcCJZAxitZ9wdQN1P0coni7hPf/F2/Dpy
	AtjkGUQGGpUlendcq+23E6gDSbGon43TQDv6/+p3YVTA8WjNZr+8UyVVGUDiZg7z7/Y47g43vZt
	hY7wPa3OHYlosyOgKBkPITJ7pCN+2rIl55D+GnL97gBSx36EDVV3EzcADArSGiJvVP9pBC9CRJA
	+e7l9WGq+USXAHbpVjePSFwL0RVIKoCaYj4Jonqu2fE4eaBBEE+XzCze3BgJXXoEabEuCXVCylN
	iinM5fXSrkylKgG7Jl5Sv61RUHrVH65A==
X-Received: by 2002:a05:6a21:488b:b0:3c3:bdce:27c1 with SMTP id adf61e73a8af0-3c3bdce2f1amr10290377637.51.1784540822955;
        Mon, 20 Jul 2026 02:47:02 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:8d9:11d7:8597:c44b:bbf0:2c09])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31429f9bcccsm39349563eec.4.2026.07.20.02.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 02:47:02 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>,
	stable@vger.kernel.org,
	Yikai Zhao <yikai@z1k.dev>
Subject: [PATCH] mm/damon/reclaim: fix typo in damon_reclaim_timer_fn()
Date: Mon, 20 Jul 2026 17:47:08 +0800
Message-ID: <20260720094708.243937-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ii78pipg4hiaa8jn11rgd77x3bfybuc6
X-Rspamd-Queue-Id: 29C9FC000C
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784540824-149578
X-HE-Meta: U2FsdGVkX19rcWVr9UjgCcT5tI1E0G2pAgVm1pTZ+XHtfXMkBMu+eqm3D6PdcH3PYNv8+OG+VlirO7psHFtYBXVBi7c5ElaZml8MwPWh8lPqiefyBRXXS/eVDSdVtCo9c+v3+cmkm22pnFmJ52I/+WOLU7/BcFsTF8iKMyTal4pHFQ9HQkFB5KO0v3AwXrNIDnCa/sl0hdwo5oy7yaLCVvS6NYnmYDfMBfxHkGGnMSZr3ZhzuyiAKZIWRgG/aXE0z4Hx1FxO/D6bnDpwf/qFOZDfz4lObMOJnFvLgDcbJL93afrViBe/YozRdIHB4etV5HxLkZbUWKWqeOPDgNUPyjM8UkwVHX5xmhBmKrZsQFDx2LfUc4w+ywmH520i0AgByNnL43LT33OwxsalC87jdN0igkeomlzo9YFOaOh0DmbNxi3o7N/A+cvEIdQ+vDBsfoXx6jE/r2QH/GW7Tv4jh5nbDybdNqdiwlOPtcoMJZDmzxazPY/UlvKSNmypgTVti0VIAkcgvWo1QVv72a1s5Vj1kyCU+h9x7cYWBhOy94DK2vBFIMiCLa5YS6xOfLDVHA353a4WQEFK8h8Y6TRNjfFTXaY/T8oMlnrQ0m8Udc9FGn46phHwFPrgZW5ldZbLbPS0FPMgP7Bk1cXzwBFvA3KkCKvgE3n0jBxk3hzYgBzoapLoOgBGKWH9SidRORN01nKXYa1CpFXLxHZQYMNLsasnSGXWskclt9JSZizcX413zsukpUsUjjIZshyMJvS68qONtqALKiP3CSyaft4oo1mlYPSIMCRWeAfbBjuO9PaJEqhENCpSjC5TYMmMHU3tTTECku7XG7FXEtqp1ArlEX4qM0Q7RjJIgzKToNHvYxEIFolMAQLtAxeoVu6B1rQeuXETQHl/RhlA/j1jIZo9iggsPn0EUzZhDy7RYvSPZxXY9RD4Nx72iEoRxkhgJtP6xWKBUg57azYrbC2yD7f
 q36Dy5uR
 IVphN+vCbZj8lQkD1w9VtaKIYrGwq1tupe53c6DerQWAl1/D/T31X7XXfzfNJa1KubcImbM5o36e0mXU4WyMNbj1jVk+KzjhnHdjkpTeAxP1BJAIOjdNmO0ulYPWibKvF3QBFqUniUHzwBJWz1RysmEGV46dpgehI8yyHMag+6tl18UaIXlH+1KVqONRCmjW24ws4gZMdLr1lhU2EtcMCyd9qVQ/3vlOmGZb4avEOiCFUANKhMSFiLIyjII0/CmmqkdQSOkY0fg28S/KxBYBKTr9r7OsTNHlB3GnxPjSyfKiEs5C4QsuyrDAgcVvcDGnVNZAb/n3nXpyQogrctBfpzeBsPLK7ALxcK0lxpLoENJ406TEohwqKfwkOUKmkW6Rcu6EU4V0vBFBU2JVSvsn4MurwRhLEjiBLkhcb83SNHok26pBEeEwol0wRhWITyq/QD3TsekqHzX1Y7DdaUL0ys+y/PyDpVUe107FiY/fQU/QdV0s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 2f54908fae211 ("mm/damon/reclaim: detect and use fresh enabled
and kdamond_pid values") introduced a typo in damon_reclaim_timer_fn()
where '!=' was used instead of '==' (unlike damon_lru_sort_timer_fn()).
This caused damon_reclaim to return early during the delayed work,
breaking early boot parameter configuration like
'damon_reclaim.enabled=Y'.

Fix this by changing '!=' to '=='.

Fixes: 2f54908fae21 ("mm/damon/reclaim: detect and use fresh enabled and kdamond_pid values")
Cc: <stable@vger.kernel.org> # 6.1.x
Reported-by: Yikai Zhao <yikai@z1k.dev>
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---
 mm/damon/reclaim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 016cd8d83ca9..bb4b705d842c 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -198,7 +198,7 @@ static void damon_reclaim_timer_fn(struct work_struct *work)
 	bool now_enabled;
 
 	now_enabled = enabled;
-	if (damon_reclaim_enabled() != now_enabled)
+	if (damon_reclaim_enabled() == now_enabled)
 		return;
 	damon_reclaim_turn(now_enabled);
 }
-- 
2.55.0


