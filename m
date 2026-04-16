Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 506E2F433D6
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 02:42:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 814316B0005; Wed, 15 Apr 2026 22:42:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EC326B0089; Wed, 15 Apr 2026 22:42:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 728ED6B008A; Wed, 15 Apr 2026 22:42:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 606016B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 22:42:58 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CB58716064F
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 02:42:57 +0000 (UTC)
X-FDA: 84662871594.29.A676A97
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1DBB680010
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 02:42:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OtSI4yYh;
	spf=pass (imf30.hostedemail.com: domain of gxxa03070307@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=gxxa03070307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776307376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jZJaqfJhNBqrOO/s3SINJABJCRs2OTnsX0moK8bxdko=;
	b=weZU7SG/Wpnlea49Pq8MtMcHkFyUV9VEbOXHi9Wh7l/58BhZ8s89q+1OKf9o4Is89DfaWa
	PNcbloVKE+n4SQ4eaUbL/yzpbc0WCNwdu7jiww7Sm6KU3RvHzR8P/lxsOzLbWpdaPWqjhi
	f5fsNLgLXN53fkZNt/GdBg6/fiQCm6s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776307376; a=rsa-sha256;
	cv=none;
	b=OZUuPY4PwOb+2p65oklVwFTzKM4YM6IcfQr9hWkz3T00Pq7C2zEPMyZUO1nITMkkyoeUoA
	T0EfdpSVQpPnXOierrWLcqNSwWbR8X/VDeTg8aOU11QuLctO/mQ1H2KuAk1F/dFSCfV/RM
	Blk/z8S3R09YVyvJA2zvGq5YJElLCOM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OtSI4yYh;
	spf=pass (imf30.hostedemail.com: domain of gxxa03070307@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=gxxa03070307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-82f6b592fc7so566673b3a.3
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 19:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776307375; x=1776912175; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jZJaqfJhNBqrOO/s3SINJABJCRs2OTnsX0moK8bxdko=;
        b=OtSI4yYhbtIGjBG9xPwQv1kar1QqERzIFDBPxIn7EncuA6w8h5j0OriVzr83OEdEeK
         vmMhX/AJ9Yv650OaaL/FupHi1Ra7VxoKxmUIoD9Cix+JO3ITa3IgmEqfqHRWQPbF9pMl
         m+MTwYRKtudkEExuugm9a6IEu5qrr1/UefWZRDQUWfGl9AgqV3XQ+THO3ca9D2M8FY2v
         Sa8OBPo6Z5YVhGR6pqwOoZHI4BN4ZBbVNtYEu0KyBl8LPlmOTbXhQ6PGhCZ8RGvYQQem
         QFKaRzNBUZ2cfWjwlOQdayxErWR7qgrYEGsXWOQ0fHsbcs3rMJgFyslTwKR2OZf9qK/k
         SoEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776307375; x=1776912175;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jZJaqfJhNBqrOO/s3SINJABJCRs2OTnsX0moK8bxdko=;
        b=Le1teYL4WxyKSw7LUjS3l8i21/CZOF2NAnzqqIWPQoiZtwU56dFbjEvjWez/4cwzlB
         71umS7arwf9J+HSUybxEo/kzsc+NueFIL3nIs6vWRfKM/p390dm9kwIQG+UbdunOAMul
         8ExqyZzZpHVMmaD6cDFjF4moLrNFefMdpmKGViTnOuG1Hg4N60xtYxZC4UtH/tKVDEBd
         PD1H2kMDTCeo6HYtwucES/GYAG8JiIedwwpQUteW2h/+pqipzT6DlwPWvaz9yDy6foqE
         tALXUc5re5RwHgzJa9PuC8fy4rLLlzOsNMmILl5b3kX9pAxy92gs/v6jS2IhB0RHVMCz
         I2qQ==
X-Forwarded-Encrypted: i=1; AFNElJ/2ojPQaKZH33GJgR9MthSkWQk5VSkXRqEgyEopTXgCgLx8cf63OhRa1XHDTyfq/eCBYuOT6r0wsA==@kvack.org
X-Gm-Message-State: AOJu0YzYpKa++KrXcaxlmvPN4/p+RqyrnDEUfA30kSmB5Zwp43sNZgiA
	Fw4gHqW99A6oMpiwOKFm+rakcRDbS3tnOYi/7qt1VYz6Re4HEhMG7oEc
X-Gm-Gg: AeBDieuFqf+Hb8jIg3KjA3HYxwswSew7eRoYDNRJrbiDIbKFhBs8fTO2ZSB0UMznb0V
	QNHLxS/XMXHEOrl2cdc09e6kbSlBFupx1PfMtTluvLMJeKK0Tj35MGglDtprJ6a7PWNvXexN32J
	AaNGb8HphzBy8CaeN4lyzgEVZEY7ooTPvSgV43XyFHVlr5ERstxlKYyl5WDkUJtZnb8+edQ5EMZ
	d03SV7CQCFe4vXSjmZpjUCRX4UFetzGlyMIA2NQctixPRYF71ayk5OwTAad9fWA6l3o4wCwZNoj
	X2VG9AkWXtGeIuZzqKpcLvMTLxIj4681mt9+JBCJJLft3M8k6uhe+nBF2xfpNkkiR8smOYclVRJ
	5gnQ5xTCPYHOh4KjfXHR2Z1sJJ5UWByRofRn4ANS4OMgry9knFOcY76cU9AI1c4luYXNDPyyQOe
	YaOKENF4Zk888Opl7sRaRd60zyujyQV4D/
X-Received: by 2002:a05:6a00:2411:b0:7f7:2f82:9904 with SMTP id d2e1a72fcca58-82f0c135b0dmr23761369b3a.5.1776307374811;
        Wed, 15 Apr 2026 19:42:54 -0700 (PDT)
Received: from xiao.mioffice.cn ([43.224.245.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f7d3ab76csm214411b3a.3.2026.04.15.19.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 19:42:54 -0700 (PDT)
From: Xiang Gao <gxxa03070307@gmail.com>
To: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	hannes@cmpxchg.org
Cc: weixugc@google.com,
	david@kernel.org,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Xiang Gao <gaoxiang17@xiaomi.com>
Subject: [PATCH] mm/vmscan: fix typos in comments
Date: Thu, 16 Apr 2026 10:42:48 +0800
Message-Id: <20260416024248.687943-1-gxxa03070307@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3qs5sezjqqjf7f6scy5xqf5q4fd9ee5k
X-Rspam-User: 
X-Rspamd-Queue-Id: 1DBB680010
X-Rspamd-Server: rspam05
X-HE-Tag: 1776307375-746479
X-HE-Meta: U2FsdGVkX1+cC08H8Zdvg6JJtczhzly3Ns/EtIbq90dfNnRhUYIFiWJYq2v7NouvW7j5HRNYX6rDTix9f+K1t9WlN/A2vZOW7cb1ragqcPvd3K0QYv80i/x3SkktFAgaK3yFDvVXNZL5eZZVAhXKH3uLAettpdogj4gvqOvxatoD/WKYLieDQOOMcCo2KxwyHrPwDA/wFwERI5qdxIGUh8kLw3c6Pc7Jml8UPTMZS1A8eXeFSMfWhEpoV6ZHmkUTS/PY+0di8URIMUHAKf5i30wU1IEL4izGB5I1ys231IxRD0OoOyDYUST7V+qOaZhNkPX/r0rl2lZebDbGBoweDy96hN7xX1ezq/NP/oo6KIIjO862EMHNMQ1VS7/FhFwAaDrSBFhGbqZhwtiDsTy0utqXDTzFJoLbDBWDO+8GI0sFoIYkF5gGWcI2zvpr1um+8EbZPO4BZ81cJ1egXCbG1QGXqkENQrGU/or4Z0fgPkSkEAfn7oSQMInAhN71bwZcGoJQ+5SIzcmh8SdcnDkMGeBdlb5BH31EPOd9JQOhYeoIWy7u9EnIOcujP1KLvDzaM8+RIo1MxFdtAETuAKRA/UNA3KmS7I7BUm2hgYTD6BUUm52AVUhO66+ljfeJTwQ9x+L54QjOIeAMlaMA2/ZMSviGQVsAdw9Ms3UIFqdeTNHTz+N/BEvB8YYrjS9VYe19djhKQ88ouw6WD50bjoadVzYUCFhptxoCc4EYc3QU/nfyyN1cNkYtYM5DEEZuku4iLMtRVviEJhE5rdoEkoqxH5pWv1fZZiuljE/c4wLgyJzOgvnwnCD0ygWjTt8FH1z23N5rIFaJoetRRtqRuszQ4TqgB3Q61XjjJlY0rIHRev1geZduhNgnW6bIqPwDJMuJmrwYptJRjGVX36MN6MGN9WV6E9xmankIlEzR2VGD0tAp9USzaigblw6hnALPTlBFFog2Q5y17yQo/zwRJDa
 gsDIFPcc
 zQ+/87xjJ4LRjO7jAKsAna/DRj7D2U+YIaQLwg9F+w1ea7kpKVj5GOuA1kPpRrwrXXuNjQYg2W7N+VgChexsIKpuRPpbNzq3l/iV/RRLh+vp8aQ47M5kTF8LJ4i3SwrRcdMB5ySJzV4Ltr8uheKG3j/mdFsONfBwV5EaXLXnYFklEou6r82G8m6bDgNo/6mTAiCHE+ef6NhJ6L0TyzPzC/iYKTgXHvCHzEUppdbXk22WC4ExK46NccEKZnX+wTgCLgaWnW3lOPJVAbpP3h/CGnwZP+miQdXLWeVG7STZRLbXYDNfZU7UDT9rMBkUlm7JfLXdMPi3odgzp/XcBqVQq1SxZUbItcIX2hdBEAXfojGtnn29pQr84p4XqsFvHwD3lY+c/V/An7Zj8v0VrOzH5mhDYsDCS9EP3UkJ6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Xiang Gao <gaoxiang17@xiaomi.com>

Fix three typos in comments:

- Line 112: "zome_reclaim_mode" -> "zone_reclaim_mode"
- Line 6208: "prioities" -> "priorities"
- Line 7067: "that that high" -> "that the high" (duplicated word)

Signed-off-by: gaoxiang17 <gaoxiang17@xiaomi.com>
---
 mm/vmscan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0fc9373e8251..710fbe1ee151 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -109,7 +109,7 @@ struct scan_control {
 	/* zone_reclaim_mode */
 	unsigned int may_unmap:1;
 
-	/* zome_reclaim_mode, boost reclaim, cgroup restrictions */
+	/* zone_reclaim_mode, boost reclaim, cgroup restrictions */
 	unsigned int may_swap:1;
 
 	/* Not allow cache_trim_mode to be turned on as part of reclaim? */
@@ -6205,7 +6205,7 @@ static void consider_reclaim_throttle(pg_data_t *pgdat, struct scan_control *sc)
 	if (current_is_kswapd() || cgroup_reclaim(sc))
 		return;
 
-	/* Throttle if making no progress at high prioities. */
+	/* Throttle if making no progress at high priorities. */
 	if (sc->priority == 1 && !sc->nr_reclaimed)
 		reclaim_throttle(pgdat, VMSCAN_THROTTLE_NOPROGRESS);
 }
@@ -7064,7 +7064,7 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 
 		/*
 		 * There should be no need to raise the scanning priority if
-		 * enough pages are already being scanned that that high
+		 * enough pages are already being scanned that the high
 		 * watermark would be met at 100% efficiency.
 		 */
 		if (kswapd_shrink_node(pgdat, &sc))
-- 
2.34.1


