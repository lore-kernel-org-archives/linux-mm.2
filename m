Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1635BC531C9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 12:21:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1670B6B0088; Sun, 26 Jul 2026 08:21:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1178F6B008A; Sun, 26 Jul 2026 08:21:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 054FE6B008C; Sun, 26 Jul 2026 08:21:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D7BD86B0088
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 08:21:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6849E160477
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 12:21:37 +0000 (UTC)
X-FDA: 85030838634.20.C41F9DD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id D436440002
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 12:21:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lw4Gd1Iy;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785068495;
	b=tHdKMcIZW+xo5ECEcgYPAB1clSyyMTZ3D+a2W8rHnntMHS80a5XH1lOXdSZlz8J3d7j2Vm
	KfflpSMvXPotYUV3ypxuZTQ1TMbtvoUR+5ImdA6j4zUj6Gx56PwaOxLdHIWIveMiar98A5
	UDWgtFSSYDkX0c18uzrA71lek5mTE8U=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lw4Gd1Iy;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785068495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cMhtlkfEDVE3WxvRE/7goFu25836RScGrqUUGkruj54=;
	b=IKaUWUmijizhjZ5wF9QyotigeXDO2zmZLjioUyyoDnHVBMyDCgj0osuw1kj7FMJBlhNhrF
	P52ZV8PqPsv0K/kQPkn+g4v8bvTB3GZQe6QL99LrpWbbQNULWXGDrCxfOK34XwrVl9sXIy
	jfOGhcl9e+ObkzAErVrb6R6XePoGn4s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 46EE2600C3;
	Sun, 26 Jul 2026 12:21:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F5E1F00A3A;
	Sun, 26 Jul 2026 12:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785068495;
	bh=cMhtlkfEDVE3WxvRE/7goFu25836RScGrqUUGkruj54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lw4Gd1Iy1sT7rxfxj3C2JKV/UjyvDgWvUdK9mj7wUSfhjV/Txdqrw9DsgPC5/8xuG
	 4m8lN/OQYY+WLY6OiwwR0nr3662ZQa11d3WeGdqxwb3mx3dIi+cX1w5SZlrxrv5rfY
	 NxIhbGqQoeIV17vcGY/APzrVu+gZ16ZyB5BSK6ZPA6dTmymIEyCEl9EEhiwoPlBjR5
	 W5aBuyob3tyGafxqDDqK7JeHmW90h8XLue6dOzkJHVnKAjW5Pr1QAtqs2ZyYcFwMRr
	 Cj3mmmGk9ew3nHjs5cva4KhMHlPOJUVGG02NWlvs0TvD3TcKC+5z3wO9BewpxC8Xwd
	 T8JZWuwcwlvnQ==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	linux-kernel@vger.kernel.org,
	lyugaofei@xiaomi.com,
	stevensd@chromium.org,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH v2 1/5] mm: mglru: avoid scanning empty generations in scan_folios()
Date: Sun, 26 Jul 2026 20:21:19 +0800
Message-Id: <20260726122123.7614-2-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260726122123.7614-1-baohua@kernel.org>
References: <20260726122123.7614-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D436440002
X-Stat-Signature: ffebf4or6g8a673o7wqjxupjk4u9ugwf
X-Rspam-User: 
X-HE-Tag: 1785068495-799952
X-HE-Meta: U2FsdGVkX1+Ds1HRCmu5ugwmROX2WhW0FdQIXWjhaY2TMB9nXHCULEvMCy4tAgfhnQNslyJbK7+BW55c8PyQP+fCyMv6k4n7vxBuuX1BGWftvUnxt4arAliQNI9iGBufe0SLFA3tn3ybd1JlSfJKBy21+rwe8grdRfZhcnVE6n61tPT3WdTxuOUvCu1BK8Zhl6xnywlwz+2n9I5NOt8lsyMFGwEQQzynnw8+Vsb9cu9OFUPVAgPfjBLtgD1dZXvQVplwvfQKqlu6/H+HYicF/ECS8be/RyB9FW9ZXOoc51y4MeO0qbiqVhJgRMpXIMFHZ1TLN1hHhmtnzO/O1bbc0KrUikeXCuoEPFz7v6GF8Eb+yfiuPyBTie/cqh6kZUcDd0CVs89xv40Yl8mEOHtv262SQTckSOf6qLvyxksiqUbayinH9Lzt/bDkC9L7aSlU/d42zGhkqdeX8MWYL54BRfRlyhAoLGn8yiTulGiTE+13/DEXGucfXdv0/xtCQQqYFYHUyb2mYwFVVm6Fbwwi/rI+Dusub04bnwdbq5YoQIqJGwIx7CQzwkPiLnhaNn1hnjZHtkO4RXLJ/DMljTsIL4ORzzsq3qvPiueNszoT2G9gP3itFCEOvw8JZ1nSsrpR7fw2OcU1ToEtmm64nY5wGM1JocjJtusy9qni1/WRrFAFpan5f0u2K3MblB02UV4TJyWHxgqQ1bHqldIDKuN1tT/7GCLEbfpOXSGmhthHc9d9C0V1gjMGcYcjET6mA2gH6R5XZaGMujz2x3dHxcXXqmUiylINbUglBiJQdIovnYT6XWLYm9Ml5R/hHu1EfmKKMw0ZnQFiLNiat8f55letvzCfV959q0gZEzGiYNhMFL7EycA7ZWEbY41AzAzeDNLMvCjx2X6PiDsnGaQ4jKPBwtrqqF/0v0xbLPm7lULVh1YcFOprvVTca1GymhGuL2M4u7hjJjYsdAPQSxW2xdZ
 0VFSBftm
 WH0zpRusyZF1G+XKQI3bJMyrkBrxp6RWceiHIoLxVEAjOPUL6vI/3uywrhGeBfBGWqeN8Sac1ADWhRcXXSJL24ARNXNu5zDhlSPnWyc6unOWEa1Rsncwx9+K0xI72Z06QXRQUKx/2qtkDPZyfk7efYNT1z2kIUVNUX+cr3NZuXaJ4a/0JvBNUupoeAkwZSwGR3g6qmlGVi79y8+X+T2fEHbG1hJY6o+yu9ZhVTiVLEiUevZkplwMs9/b9ut9f2nGR+Ali8vY1x0BJxSNlMdvbJ97pqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 16b475d2ac3c ("mm/mglru: avoid reclaim type fall back when
isolation makes no progress") only falls back to the other type when
scanned == 0. However, I have frequently observed cases where
scanned > 0, but the older reclaimable generation becomes empty
after the first scan_folios(). As a result, the second
scan_folios() for the same type performs a redundant scan over an
empty generation.

We can avoid this by checking whether the reclaimable generation has
become empty when scanned < nr_to_scan and we still have fewer than
MIN_LRU_BATCH isolated folios after scan_folios().

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 566c4e837c7d..babbce4bbfe8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4852,11 +4852,14 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			break;
 		}
 		/*
-		 * If scanned > 0 and isolated == 0, avoid falling back to the
-		 * other type, as this type remains sufficient. Falling back
-		 * too readily can disrupt the positive_ctrl_err() bias.
+		 * If scanned >= nr_to_scan or isolated >= MIN_LRU_BATCH,
+		 * avoid falling back to the other type. The preferred
+		 * type is still reclaimable; otherwise, it would have
+		 * already run out of reclaimable generations. Falling
+		 * back too readily can disrupt the positive_ctrl_err()
+		 * bias.
 		 */
-		if (!scanned)
+		if (scanned < nr_to_scan && *isolated < MIN_LRU_BATCH)
 			type = !type;
 	}
 
-- 
2.39.3 (Apple Git-146)


