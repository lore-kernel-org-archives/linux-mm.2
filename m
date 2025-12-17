Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23CB7D64077
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 06:05:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A0CD6B0005; Wed, 17 Dec 2025 01:05:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34E616B0089; Wed, 17 Dec 2025 01:05:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24D6C6B008A; Wed, 17 Dec 2025 01:05:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0FEE16B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 01:05:09 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AFBC313BCEB
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 06:05:08 +0000 (UTC)
X-FDA: 84227925096.05.5CC1796
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf27.hostedemail.com (Postfix) with ESMTP id E8CB34000A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 06:05:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dOGwr88z;
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765951507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Pyag2RFbDMZaEW1ZUfh2mD7Rosxr3z/BITgh98T+I7s=;
	b=NgdwyaM6gFiW34Jvti7hzDSSJdiuFOqlmrZ/jCqY3Zt116Uc1goS8O4THMUcFK84rtHqOy
	bZB/lA+q0R+tbYlqh6wm+JyvkRa6o7dREwAIxdPxB4h8JbgRkaht8cu2MGPpUliYlRjGG1
	QVLSTa46xSt4eJBZKrHNMh5TL8Z8Bbo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dOGwr88z;
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765951507; a=rsa-sha256;
	cv=none;
	b=oHlHDO4/jymq5h+It4qejuDuVCzvSu8uck6T+UViYQkPtWXGTuIuNUfphp3EPP81puC5uW
	AAYn+U/hI7d0qmes8IN0G7S8KDGeDRO911Q3fZpZKHW3SGw+swqH1NPkBhiDEQ24arEGdk
	r13GBM/zPjNmbcCC2pnO4OPJVhufGI0=
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-78c5adeb964so52943307b3.1
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 22:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765951506; x=1766556306; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Pyag2RFbDMZaEW1ZUfh2mD7Rosxr3z/BITgh98T+I7s=;
        b=dOGwr88z1Bd32zT73c5SZIUmozu08uN3SGji9vNtSc3TsCX95ojrL47ZGV0EHDqs8z
         ZIkls72b8ekTxyFGrFprXRk+7/bB4dp4bBq6y8VlMlDU6EmbneGcNY+6PjJ3obuNH/YN
         p+fIJmJFcQmqNuwn6pDybE04Z9uMA4oEoJt025qF9CMLflgTbH70ej1m+5VLYnM777jU
         P5gGP5MmyyA6/yHyXOeiHMJ8H1OtbJK5LK08VhtaxjcTS6B2WOfMd6J5NkFtWBTOIQsi
         PoehWIc61uuh654UeOHpTK+r+WDWcE5QchKv7GefI6HsNxBP6qCFxD7j3VwNkGbvO2Zr
         xz1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765951506; x=1766556306;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pyag2RFbDMZaEW1ZUfh2mD7Rosxr3z/BITgh98T+I7s=;
        b=JtZACvKZgTCeGqtun4zP9BjBI6zC2uhm6mrWPKhfxN0rfC0wesMUKqH5eAwcHDzksR
         ThzqRa6ox45C7i2+fpIjKPdH6WB3yutzW6WP1po+j+tQ9TAlmUMEHIJB8KxmcldDn356
         WFeV1XZOzQbMsM2t06X0BKrWvuDIJ90TT2Va8vm0m3DOwJ4f3S3AhMaJ08rHmVw0j52/
         zFRxqN7Ukzc9w6Fgc/RqIQWS7jpE509nzLIW/QyWFtQDIFlsuGCtWlRAHJgM8X81T3uV
         zGWTI4IgA2XBLqiqU96LqAUXNwLFivT7uypim2+7zJbOwbFKpIaEpiRq1CX44NHbICwH
         Djww==
X-Forwarded-Encrypted: i=1; AJvYcCUnUkGwk7e6GFyd3ozAUYiMoNyy48223Dd+9pvJ+H+CBg2z/8uCMMEsDFH27lLLj9wBGEz/XcvMJg==@kvack.org
X-Gm-Message-State: AOJu0Yy9SlkVI84Wf4ZOkWQRB98yqrrqOc1F/cYCmWd9dqYfc2HTOOLO
	GJysbDcHWdHvbiULuH5GuOLk5WhwOweH5Fcynxv3vp0j2eA9goGL7W6Y
X-Gm-Gg: AY/fxX7ctmu07lkges8pC4H5gOofWt/TL/pRWjx96a1i2C78QYq/Ci3NH1o5xDCzF2r
	9MroMN7fX2ybhxUKO6z0bQtjcy3rzISvRZaCAqmmDQzb3RMV09dfnMqEdiMT4RELJqTdJW5lI3U
	n/fGsyAoJKAzb7V3PdXPJXLhnJaZQbgdGudJdiTvSUSq9aCIRXHghDuwJcHD6wQsKbTJ2Njt0oz
	3DFLXVD0Z1oW2kX4dztyAWiZ/O+QFKu6n+TEqCkabZCYoBAr5plsZ9ng8BPFmhgWs2yVxc1uH2y
	Ta8w9AK/lEuu35+9eUQSmbbPMxR9Bc98a4nLco1wV6BvD2UJFnMuqTDms3pLbd2wh5W8Rt5vMlU
	/Ub+y4CigoeJQAclFwNSD44bjaGNKn3Wr/ezXjc5w8j4zR8HAQ5KqfqI3X/ZDSd0TOcvdeLAOf+
	4xSZI5v79IYnHuZKwlpg1Cwg==
X-Google-Smtp-Source: AGHT+IELDZriJQKqPex0nsZHy75JNITcXwoBTqk7IfmCVrXhJRy9Z0N5R1WndPoDPwVcQlcm/Ub7lQ==
X-Received: by 2002:a05:690e:1307:b0:640:d009:e998 with SMTP id 956f58d0204a3-645555cdd3cmr12576419d50.12.1765951505907;
        Tue, 16 Dec 2025 22:05:05 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:4d::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64477db6476sm8629460d50.20.2025.12.16.22.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 22:05:05 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Palmer <daniel@0x0f.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm/page_alloc: restore 0-handling to zone_set_pageset_high_and_batch
Date: Tue, 16 Dec 2025 22:05:03 -0800
Message-ID: <20251217060505.681923-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E8CB34000A
X-Stat-Signature: nbkq3wsijczokwf3uymyr3qhzaq3t67x
X-Rspam-User: 
X-HE-Tag: 1765951506-557841
X-HE-Meta: U2FsdGVkX1+0pWrmUC4X9LBDIm8Fsi3Yncx4Bm01Ot/bd3XaJ3A95yoVp/FoYRDC3eoc3uu4FF89LA0TOrR7DwD4e72DTl98PH3ICE1MlffPpJMmT31S15P2VoVNdbCqcYqWIyMomQjM3/go9NiXD+NuwkADvUJjjTVyGx7JzbUa/QchMkwBBm/As2fEg3Xmx8iYebN7CZ30KoCmz68ppVt7BILT5NhMKncxY0OxUf55TQ2A1FCuMTTOtCr9rdRma4d6x5TVu1Ethv6jPZAEg+uV6gWppUhM9GEiIb5BDoRl90hu9n5OGaXxjy+n/fkFllh56Du4mwGyYvA2NTKV2/zgN6oi/srPAZ6wG3bX99VLkGRU9o/QTRG4KSSTmGKV+v1EBLBU0zbDxvf4Cf2kUFHQEMaAiGX9uO6N6XR1BDRsgo2j9J5m6DE4nkQpQ1OpAyN1bS/BskVJY98MtKWfQkB42uUBqkPb1EhE2p3Jj5HcY9hQf4ILjsDgRcrSTZEY0cNPF/xJ4UdLtXM9z+SvGtQA8JTYeHT5pdPhZGBys6te1taX78uXimxM12Ea0mq03hNq7Y9ujKSQir2GjrIxB3ex8kXXs/OOTDc1iGKxSorHm01kw2yefDfC57QAS8rkFN2+nVuHJxw6SEJkepicXsxBas2phHwJDKrVx4H3v6fAgQcDEGP6vHaTiPp6XOpSI1uMrFiT8S6dRotDVnOIq1cBPHZjE3gmZTeEQjBNXxXGQ/40QTVsaXICwbMOYqR23/9FSxDrL6x7IHDXbcQ3hCA2Vz8ETplCMohsXZTA7v6h41Lo0R/RfyPP61tYUTob5OkfvkH/kzt1EI5C62EyzaAhQI0D1dskZT9Ozn9KVMkH/zUH4BMYER/FTdZw6mbHmJaEAdW7La7RgzidtTRQn0bkW7Bzh6d+SMe9lXWh8xHt+KLEdGMosiW7pE61QWuBDxtjEeoNraLxsbGTnBs
 fFBNCSzJ
 FSAhWs3dL5P4s/b4dDWyTWuHTLUwmje7O0FRVpV5+YLkjlj6TMOU/LkwOThC49jcCj3Nc8GDIHcHn5KCZb5voF6ZyBeWH8NAK2FZhBMnN1iSNCXMtSWqNuKQbBfYS+cKvN86xPFM+/mH8ndj8wq/jWfYHRk7pFZhnrrVF1wAuXKIlQXxOlbZoR/6zWnlvsCZp9SdJ/R4/NMjS1guB9etKHKQUdkToUeVogmkqtXU2cx7BS2xNjiI/Mwt9PyD3yj5YWEvcaevju9DTKYjk527DT9mF7CqKDnVm5mofgsyOC/D7E1vw2yrSRRWrLRtb9DlJhBHHv4XGCjZwFPVojRUVJ7vfb8UkC6mIobg/KB8B4ct/oZ+ttWWyT3Tja6Fk1+WAEbWtJ1kqgp3BpFt7RMTkObTrtavEMg6xEb8SGGo1tdlP2VBk88XdRz786eBqWp0qO1lIs40ltgj7Kr9fINVIU+tcA74OEbz797cm86hXylW8bgAGpJROGPTHgbq2vFXxnYDvYsg/V1LYRKLzRXtJKW+3A1OU3rKbbbJidgGvYsdCS8YGAH3EhUOY2qzpCLSOYfCosf9Ew+ri8EYxh/IyAdliBQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 2783088ef24e ("mm/page_alloc: prevent reporting pcp->batch = 0")
moved the error handling (0-handling) of zone_batchsize from its
callers to inside the function. However, the commit left out the error
handling for the NOMMU case, leading to deadlocks on NOMMU systems.

Since in the NOMMU case the reported-to-user batchsize should still be 0,
we would only like the error handling to exist in the callsites that
set the internal value for the zone (i.e. zone_set_pageset_high_and_batch).

Restore max(1, zone_batchsize(zone)) to the callsite to prevent errors
on NOMMU systems.

Fixes: 2783088ef24e ("mm/page_alloc: prevent reporting pcp->batch = 0")
Reported-by: Daniel Palmer <daniel@thingy.jp>
Closes: https://lore.kernel.org/linux-mm/CAFr9PX=_HaM3_xPtTiBn5Gw5-0xcRpawpJ02NStfdr0khF2k7g@mail.gmail.com/
Reported-by: Guenter Roeck <linux@roeck-us.net>
Closes: https://lore.kernel.org/all/42143500-c380-41fe-815c-696c17241506@roeck-us.net/
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 822e05f1a964..10c1297fd3ea 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6045,7 +6045,7 @@ static void zone_set_pageset_high_and_batch(struct zone *zone, int cpu_online)
 {
 	int new_high_min, new_high_max, new_batch;
 
-	new_batch = zone_batchsize(zone);
+	new_batch = max(1, zone_batchsize(zone));
 	if (percpu_pagelist_high_fraction) {
 		new_high_min = zone_highsize(zone, new_batch, cpu_online,
 					     percpu_pagelist_high_fraction);

base-commit: 40fbbd64bba6c6e7a72885d2f59b6a3be9991eeb
-- 
2.47.3

