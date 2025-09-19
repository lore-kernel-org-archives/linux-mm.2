Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A92ACAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 16:21:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDB808E0008; Fri, 19 Sep 2025 12:21:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8BAC8E0002; Fri, 19 Sep 2025 12:21:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A54268E0008; Fri, 19 Sep 2025 12:21:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8F7798E0002
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 12:21:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 38874BAF1A
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 16:21:48 +0000 (UTC)
X-FDA: 83906515896.20.9BD38B4
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2C63620011
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 16:21:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=w+iztjwr;
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.52 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758298906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KU0e54WZ9xSy3fCSUGF390H8SijTBET/vQ6EcFimkXE=;
	b=ODU4TJeVHtEUkcZc2ko34y6lDImIkiQv9YfIFoAKwHakEyUMSrPcqoJbiQ18jcPFqr8ofd
	tFiEJGk6hZlvM6nhhIkh0u9HutY3NI2kcaORhZaQeH6jh2uhGU8AxMH13Hjr7XMV5DUgj7
	LYs1eYhjWjHSJE0KzrF/UZitBqsmTus=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=w+iztjwr;
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.52 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758298906; a=rsa-sha256;
	cv=none;
	b=Bk/2dyFwjTsSUMWuE6tRD7RpVZl21nhfSPC41tyoiT5igK+RbmAODo79dyktEn5LLa4pEO
	YYnTolZNd4Bx+jrbgx/y6LAPGYKAk+nd24s/h4KDzSWW3owhm/XoLJgfqLxtGmKoZ3SB2i
	GZ/sCcaoBGU19dP4g+jwjDA+11V1PDo=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-7960d69f14bso11232196d6.2
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 09:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1758298905; x=1758903705; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KU0e54WZ9xSy3fCSUGF390H8SijTBET/vQ6EcFimkXE=;
        b=w+iztjwrTRiIQgWhuZUTch7jMPqjSwUm5+FD0SIgc1EUsvpLma6HQqNkdVwhOGajlc
         XJ4Oq4dmqO8jD5GEKIvXsk+w1HEkB1wfh7sXhSYMWxqh0MBmIoS+yn+XcHHuUuBh3t2R
         AVKZXMZpTxk+Muuiv1OmSRsGVLviuUOkhJd9Vh37V+JETxnk4LpizliDgYCOvRY7WIpb
         ruCGnYirPlOou48CY2W5Sbf1zwtiXzvlG7El18OSWdCm3RZ6zfo5sIugCJc7Sa8gl24B
         obtgSWqNW7wU34iGrq70z6EPOL7pxGwm+lwCmtjokKBBTkUowZG1Y+NkAHxZsGMrNYcz
         LjvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758298905; x=1758903705;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KU0e54WZ9xSy3fCSUGF390H8SijTBET/vQ6EcFimkXE=;
        b=FF+4CsNHgwTjqvFQX2WlXDSiOEYj9xnKH+HAbbOrJm/mChiHM+y7Q5jSRcyBh/52k2
         XkzjDdBKKy6oMpMac1GU7vrACvhzj4cIoUbp/ymYe6UcCTImX3aZjBHJsQBijIbHZLBk
         GwMtTTJN7bRAV3x/MrpLqYPhqd1txvlMqfhqDar1Je68NC7mmQkqvGyLucrqljRkjWWQ
         zvyS9e9axyhGe7bJSYxKN37ZzEo7XSgFtpjfmyXkbtoU59t2q8OIXaxljKtmYq2BEwrf
         g72puenv3b8MX9oj64h27S0CdMcscyfzCRZ4kgMYYnuRyayqB3xnzm7cOgc0d6PbtfnE
         YwuQ==
X-Forwarded-Encrypted: i=1; AJvYcCXWL938/43uWSFcQF+80zqBfSVli/fYu7nnruaHwkTA+QHouKEOOwp0vBGs+SiOBVX3aC8Fyxl4HA==@kvack.org
X-Gm-Message-State: AOJu0YxbiYOWupKOFm4preTlEFayWzQbAoRssGbaTsuKHvmaS37hWbog
	ddRmGDVJEcO9HDy78T5Ohhws9QeQcZkaKZUqUFXPs6yM7ySsrP86tRJZPNjSEhkxxyM=
X-Gm-Gg: ASbGncsG2xSBg2g/6KHHEw+3QyFAMR/n7f94wPR/flJ+EeDtTKj/6FY0Ys+3PEQ05Eo
	pgq31yWCfiIMoGZB59Huc3tF+2k6GTpTyRM7HM0rClDl6y0/uepqxp0ETudvyK0HdZDBaQCPMvY
	8aoDXO6TXa1IPmd7NSRhgcQpLPxBUat3ZLDJIOO84bJgFZHcsG3FJrNw/vS7H036f1B8djI2j9Q
	tcLrtwD+t9JgsI176uy0jq+TuTIGU/Bz4vx2igqCtBlSAJV34HBg9dtdOfkHOVIn16i6/sZ3MQh
	2Mnr5hrS/F2a6GkRJ/3+H4gPlUp3O0w6QGbMQD6VXcgJxADHgWXaRrJL8mhN++ajY+bTc8np+Y6
	CuWtN1Aj8nm9cqLZt8d1PBw==
X-Google-Smtp-Source: AGHT+IF3YqXL+DiZ1cpJVimdnZ2j3EsIyc7usMA8XFckTWUwfy3Lewpe/MvFwizF8tQB4kpD355gAQ==
X-Received: by 2002:a05:6214:268b:b0:78f:1a9e:2590 with SMTP id 6a1803df08f44-7991c124a4amr47454426d6.34.1758298904870;
        Fri, 19 Sep 2025 09:21:44 -0700 (PDT)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-796d68804e4sm22102636d6.67.2025.09.19.09.21.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 09:21:43 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Gregory Price <gourry@gourry.net>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: [PATCH] mm: page_alloc: avoid kswapd thrashing due to NUMA restrictions
Date: Fri, 19 Sep 2025 12:21:34 -0400
Message-ID: <20250919162134.1098208-1-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2C63620011
X-Stat-Signature: czrq8x8rn4ddmkd7am5j8akwgnpgg3q8
X-HE-Tag: 1758298906-758733
X-HE-Meta: U2FsdGVkX1+uAhksyy7aWod57exkcHc9Eo0WMzf6rWuAlUOgRsNMPcyRZ/AyH3jaPV0SeG+ZyD8TXgJUk3gD5auFLwjHpyYaszj9rKyZnmZcMzm1nBMVjrQZiRL3FqHrXyVf1kq2m2OsS7SVR1sHJVpGUNSck029T7NRP01f/qtSSFq4uBBOCpN+aT+DvQkQKQ39TYDXez4t3ejc8tFnZR0MYGyw6ykpOdSCqiPO0PTvSB//1OflgPkpeIQW0CCrk1SzZd9OjDvF6J3gCao2MrdoRpEPQyU8xa/zzuhaKP6qPtzzXexwAdJwPrnjgcTCW0wGl262weHrb7LkVKRbQHrCr/8kbuynMjMNFdoYKDgRff7uUwYqpeDVjp+zNx+wC8TfQ1pOxiD3dWHfED5lGbEFAWRSYl9OVervQ1l9G9Ok5h1xQRGHdQ1t/0yIhfbeMaUXA3tMv1KxYHo6TlwoORL3cMDN3TKYv8kncao3byIXajzs0EVhBktvFmvtK1I9eVt53uN1OMG8VV+XBZB9lX2t7HhfwZx9WMdT8RkE1ztPeLbXhEP/wnrEfAAzA7tozyYC1r5giefG0SLWbf+4KMlLYrd4vrKThwmtUoYdA2Y6bwa+s74WscAgMQsLguW7HUTCz/0Cnihck1E4DoEjfo0hqO3L11ItlOYwNIeGkZSVDl8+DcuEyVOVmTuDtpOxAXFdTDTVx9uU/8ZniWszWnfAPMn05f/630lgWlJeNcTHiD4n7yL0aOqAJbV1d+YnZOzCnqHYz0O/Br3GbZRU2U0nmei3eU1btUpEmjq1DVWaQwLO/GiDX+vKg6aE2f5wXpjePa5jDpMZ0IGm5Ngi74tN/DOSTFGIDpznoy3OLQ1cLgiKiIkk/SeM2uxsbBGD5NXEz8QVhDLREByAsDDldZ6lrq5OfX4F8XmDPvzDkJ9Bwi5Qpfam0dMiTTj1qPRYWoql+lpFC5rjwGmeHn3
 tYUGqu9Y
 hQPKOu2NQzodPdvDOjFu+Fths9l04hpDD8su3QmlImkCclq/mAYHKYMsYucV9yOysKw0piFc9TwewY43l1GeskfwQGM1GvAzxmr7nezq6mLzVwPFfaJkIwhcm9FFB8YMtSgnxwEcIw4UlfNPTBRriuzefBV8agBK/qD72O7+P7Y/ffEMgA7VLMERwEQDc/JytHNEFR6KASdXoR3o3ZrhUu9fCLto23H7Z8JeMAwytmgIlRFpCZ0SKIG3Y7FZlt7oHUOK0QhvclKaU8pHfEDpYN7xY0/VnXXfQeESpydHzGDsZzDz2BgeYR3O2EOR+CriLCNJ6RZP7ntPYQMDC2IQP1SlI1CGtgKA6GWuEvSmJEpX+jbasiMDeSXWwTSzqCwTbvfObv6MoQjsjPobC5qDLkL2xxLOvigHG5YlwI4nl/y/x+9gNPqaBzEIHQcsMxOfgVsfz8JzJZW8YOw9NzFsRm3YnuKubi+9o7eiwcrLOpUpPxX7ANauSWBjmM91Bc+WIFHOr2I/a1voTaolJWKGRZ8Rt8VruEj4/mTDkOT6hcCpGcipPp3pUJQ0Y2LIVyQuuHP1NIVmH3NIltIQXKRYhi2LP95X/6h6hwrTi8bnJ68zBxm6DeN7SF7SdeZm01Cr/cD+mvL7FU9oaDu8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On NUMA systems without bindings, allocations check all nodes for free
space, then wake up the kswapds on all nodes and retry. This ensures
all available space is evenly used before reclaim begins. However,
when one process or certain allocations have node restrictions, they
can cause kswapds on only a subset of nodes to be woken up.

Since kswapd hysteresis targets watermarks that are *higher* than
needed for allocation, even *unrestricted* allocations can now get
suckered onto such nodes that are already pressured. This ends up
concentrating all allocations on them, even when there are idle nodes
available for the unrestricted requests.

This was observed with two numa nodes, where node0 is normal and node1
is ZONE_MOVABLE to facilitate hotplugging: a kernel allocation wakes
kswapd on node0 only (since node1 is not eligible); once kswapd0 is
active, the watermarks hover between low and high, and then even the
movable allocations end up on node0, only to be kicked out again;
meanwhile node1 is empty and idle.

Similar behavior is possible when a process with NUMA bindings is
causing selective kswapd wakeups.

To fix this, on NUMA systems augment the (misleading) watermark test
with a check for whether kswapd is already active during the first
iteration through the zonelist. If this fails to place the request,
kswapd must be running everywhere already, and the watermark test is
good enough to decide placement.

With this patch, unrestricted requests successfully make use of node1,
even while kswapd is reclaiming node0 for restricted allocations.

[gourry@gourry.net: don't retry if no kswapds were active]
Signed-off-by: Gregory Price <gourry@gourry.net>
Tested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/page_alloc.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index cf38d499e045..ffdaf5e30b58 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3735,6 +3735,8 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 	struct pglist_data *last_pgdat = NULL;
 	bool last_pgdat_dirty_ok = false;
 	bool no_fallback;
+	bool skip_kswapd_nodes = nr_online_nodes > 1;
+	bool skipped_kswapd_nodes = false;
 
 retry:
 	/*
@@ -3797,6 +3799,19 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 			}
 		}
 
+		/*
+		 * If kswapd is already active on a node, keep looking
+		 * for other nodes that might be idle. This can happen
+		 * if another process has NUMA bindings and is causing
+		 * kswapd wakeups on only some nodes. Avoid accidental
+		 * "node_reclaim_mode"-like behavior in this case.
+		 */
+		if (skip_kswapd_nodes &&
+		    !waitqueue_active(&zone->zone_pgdat->kswapd_wait)) {
+			skipped_kswapd_nodes = true;
+			continue;
+		}
+
 		cond_accept_memory(zone, order, alloc_flags);
 
 		/*
@@ -3888,6 +3903,15 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 		}
 	}
 
+	/*
+	 * If we skipped over nodes with active kswapds and found no
+	 * idle nodes, retry and place anywhere the watermarks permit.
+	 */
+	if (skip_kswapd_nodes && skipped_kswapd_nodes) {
+		skip_kswapd_nodes = false;
+		goto retry;
+	}
+
 	/*
 	 * It's possible on a UMA machine to get through all zones that are
 	 * fragmented. If avoiding fragmentation, reset and try again.
-- 
2.51.0


