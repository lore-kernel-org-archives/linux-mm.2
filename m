Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7AFFCF6ABF
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 10:16:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 162296B009B; Thu,  8 Jan 2026 05:16:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10CA56B009D; Thu,  8 Jan 2026 05:16:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F347A6B009E; Thu,  8 Jan 2026 05:16:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE4FC6B009B
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 05:16:38 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 81BDA160678
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:16:38 +0000 (UTC)
X-FDA: 84308392476.01.5399D64
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf22.hostedemail.com (Postfix) with ESMTP id A8A13C0002
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:16:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DrW6+o+f;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767867396; a=rsa-sha256;
	cv=none;
	b=bbe83aE/AteCBTECXzB8PsW8ULJdPlHGCZrWltIcOzDRezVVpPD+TsL0a7SICCnOnxpGBO
	sXkebeeTGICgmmqhKJYvL62gER8it8r23iDZWd97RFcxDfyPFYW82DIhOZQvNazZZx3jPT
	N2AGbwXEKviFBIVw+M79tCa2LUEHfIE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DrW6+o+f;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767867396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=suTkrZ1EkPHRVVH34Oml2yxp+xWgDllJvbX0nsQJyK8=;
	b=LWKJz5bX3KYcNyovb3XeWLD4WpG+ggNjSpxD2x7eCap2wpB2ewSdZqfQkpcUClDuRfc6N8
	0uOhQiE9y3DZ/r2Y6CzXp8dpPcAmhsvF34cGUV7JAC8jKM5T7rU3RRHez80CUsSD0e4wwa
	9MfUl/Z+SN74/xyPCHRWy42CZaDQXU4=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-bcfd82f55ebso785284a12.1
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 02:16:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767867395; x=1768472195; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=suTkrZ1EkPHRVVH34Oml2yxp+xWgDllJvbX0nsQJyK8=;
        b=DrW6+o+fX3x5MwTGkbXr69G0AcAz1YqOXCoXsBF8XXDsrmMxHHno/j5x0kYFFgHvox
         WRp3i34HJHGEHWtJtmu6LafNqD5QMorvq0R2gZiu0QMEAjdZ9eIaPACZ402tf1kLYH6p
         EiEUxfisPnuV08vOtS1n8xDzYc0+1lIM/tng+vAt85Jvb6b2rwcx3JYHx8trN7+4wKrN
         hV/XoXuU7RqX7yQe8Ot/Skg3Lrt1OgC3d2u7hL/lW182iBfmngUmO8qF4yDH7ZvfvrpR
         /8iZVjydGo97ZsGwGgE2gmAHbWomxBge6K9PyMurGPx5ygkKugYLDDTNZfYlXL05aFd4
         0afw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767867395; x=1768472195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=suTkrZ1EkPHRVVH34Oml2yxp+xWgDllJvbX0nsQJyK8=;
        b=lJX5KS1gHcFwQ9HxxLiAZjHPz0HOLypI8sZ0HrZcQNSw56OU9pvwDHEqzXIad6wEZB
         8RfG6Q4a81oxdFCI4MZgBavkZN7LcmN6QLcRWbQNcNaucoNUsukWWt8PfBJVZxeJBLF5
         ELr93Rnwd6XTNA26szw8LY964qWSrQkTFeiIsoDSTx0QuPZz3cNbX3g/HXRoUQuWdiC3
         cUFDiCnspcMeWmJ7jkwgdTkeUmpEKavtBEe3XTIR9cA5HJ7Pk/RUgKEY95VtTVBOicx+
         MSyuFsMW9dDsets6LkhD0AaOqJ83rNy8Lb9GpTCAHaGEG+8kUNPK+lIEn5EMnWRAGJsC
         qglw==
X-Forwarded-Encrypted: i=1; AJvYcCVaihsLxgd4kdC17xYYNcbKJF+XA9M9l22j/lMzoPHp1nkWarPFTSTh+MeRT9I0Jxu4/syle1Qh0g==@kvack.org
X-Gm-Message-State: AOJu0YxgXPg3/Xg6XpB6e0zAtCNoM8Y3XYphtHjXAL7wHNlqI/trEmD0
	pzjHOu8wGq68JZxtXfkL8CmCAcpJYHnLlKolCmsy30+hZIB2zofRAPQ6ROkVaQ==
X-Gm-Gg: AY/fxX7nhV0sA59E2s9wz+NRAnu0xLw3SiiZR/QIygBeslE27VQbft3l/iJDhPul0Dm
	0l/w7xT9G9LSQG6YbP0uVSr0vdbQo1FlbBwcprdDqlSjvCKL5c24SkyIJxXdZrTFh4HG+fP05qL
	2XNmWHeYtp52gnbDNPta+jmXih9kkxuC8qgMZgbxYUOk3bVNtOVm3mt+D2TorlOcNqSS9qOkIiC
	FfU98wcW8oCcmU0GBo/aDdBckFoygRjAA4w+XGhASHZCrt0ykjAChWWL/2H3B725sDqQku4ez9+
	6Qq8osOveqRi2GDsDdnIw1M4gQQ5yaW9GchLd7XXHbGGm2LzIg8Dje6sIX6hwmJm2JzVDDjoYl5
	FiM+/JiVrr2iYDC9OlJRTYFruCQ5YDio/o0rpi7SJ7tEOVFOw6VRmGjrWNHtw4HhFmxruh3r9+x
	zzD9OtvKny+uJSc6kXvaMDLJ8H
X-Google-Smtp-Source: AGHT+IEjPBmAvzyeXCoA9/7yT7vSwivlYjHbfpR026nkIclI0cizfQblaziO9HyuHaaz+q4kQ2IDPw==
X-Received: by 2002:a17:903:11d0:b0:29f:1b1f:784 with SMTP id d9443c01a7336-2a3e39828f1mr90701885ad.4.1767867395489;
        Thu, 08 Jan 2026 02:16:35 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:8352:dfa:3b18:eb4e])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3c49299sm73785245ad.42.2026.01.08.02.16.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 02:16:35 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: akinobu.mita@gmail.com
Cc: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	bingjiao@google.com
Subject: [PATCH v3 3/3] mm/vmscan: don't demote if there is not enough free memory in the lower memory tier
Date: Thu,  8 Jan 2026 19:15:35 +0900
Message-ID: <20260108101535.50696-4-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260108101535.50696-1-akinobu.mita@gmail.com>
References: <20260108101535.50696-1-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A8A13C0002
X-Rspamd-Server: rspam03
X-Stat-Signature: 8r1sei9dh8xu5uehmiuoakh9diaydh89
X-Rspam-User: 
X-HE-Tag: 1767867396-912776
X-HE-Meta: U2FsdGVkX18d/ZyipUl7vc9oo9fcQvnkxNhY782w1OQLsfY8iRaw+GsdWwKAjd5y/8dbq+FN7q5b3jxUkk7wduXLd9d7XXYV2OlqljWpXSW80rmPmpUUBblcB4ct/r89ePq2N25vyKbXlhDdWLqDtd/JT0St/sH61Tq7wMTDPUE9L1qKjxXsCsQ8Dj3EOhRr4YRbWmI/qbTZKqBpyhZu1qJhQ8xB8isfdhoQYnLICe6mV4OIYgkJeruGM9HWiQxmSfr0z41PluXW7CPY5Zpf53Za5Q17iDzww3Id25NKIiILm8FbLwAztTwoOLoFMW1E/JgJZpoI9DA36CFofNzIolFwPlo2Yqti73/jlQE7UoetioJzngodlg0SggUyypuIW7ncfqeL7aXvk9CXTOiGV30nEJA+3JPw4Br5Du/3HnUlYAPOecgMXeObb14t94lPxk4oKFK4laPwO4cmwweddV/krdEhyS82kVkBKYrstaLScLBMJc6RBmO8huuMlZHFRd3AnjePOBHmEZt1N7ygPKf4ySQurlwC0y/txp5PjaFrS9GUb41Ljji2cPO5liC9oLoAIJGhIhZGoaO+xAufH5tYCww2VcfLU85CnKH2PqIlxVikRGyFRyD/Pzldb4QrmyjDJ9i/MqaCR2owScmmJ6JK2Gc6WJ0uOSSBGKYDDW/Y9TLSOozWUODsVXOpuanGQ0w38arQ3k/kcjJZUDtqAezuBcL3/XhWnZjAJTQbJebRtqx1IFZTTGlu7NKyaWs0vqfKiRl4PhoNUjDWoQB5qfy9Va2H0iwcgidCAj3Dms8NMnB4fKjXRb65tf41FHnlN5m4/pmEb7j7U7HyxS4Lqj7WaPI+QglTsT5MLzOwKdgheoeaLaK4Uwe4Nm60g7WzdFkh4eFG40tc7Qtzv1LbnQvh7ddLoXC56kcFq4tmbFtLjQNZeH++0lB1zu7BT+k8nwaT91ELG0bi0d1wBdu
 J2omIoti
 sVUdWpa49XU5BYa7WfcfLaFq7+zuuF7eLI4pwjMkvKs+1n5eYjaWlQOZluX8xrsiEX8Vq+t6Dvs+kNQwV8/Ayb+OttnxiQLx6HnpHRIzd8ZtBzAuqVGTCAlJvbUQZfpNzOdJr7U5BfaSLd+sojszfGhbqGZQgzeaaA5jrKk5kzJR8Fls12ko0Ikwl9GMPrAEA7vVUeWZGzUuJRnRPR5Tco2tkShaqSI6THoxl4u03z9dNFaORpQVofG9oehLmCnM0sVOA5URdrg+opEWDgPPeEwRleYzry4wF7yUah03JC9LVsN6nreoH1AjkRy7HoqBBTawgJ3hxjfydKOANsAlHmdoDJoP6LSEcATzYYpmdJuzRZCKMJr4lN+kgO4AQnxPp/FBxjRLH1Bc417RS2byL5MHtbMwWkQjeh/+3Z04h+YdS0zjFsz5Hlb7oEiX4i2EhMeJ9PpJMiQC84DU5qzceDrdYreFNsGcxiPL3AuG+3VddJc64BMJlB3QMtnVS2nHYhMQfRZ2lfUjcK7rd3PkZMJNEOwVthN2DoPiPLpA+kFzG1f/Ur9e84M54YQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On systems with multiple memory-tiers consisting of DRAM and CXL memory,
the OOM killer is not invoked properly.

Here's the command to reproduce:

$ sudo swapoff -a
$ stress-ng --oomable -v --memrate 20 --memrate-bytes 10G \
    --memrate-rd-mbs 1 --memrate-wr-mbs 1

The memory usage is the number of workers specified with the --memrate
option multiplied by the buffer size specified with the --memrate-bytes
option, so please adjust it so that it exceeds the total size of the
installed DRAM and CXL memory.

If swap is disabled, you can usually expect the OOM killer to terminate
the stress-ng process when memory usage approaches the installed memory
size.

However, if multiple memory-tiers exist (multiple
/sys/devices/virtual/memory_tiering/memory_tier<N> directories exist) and
/sys/kernel/mm/numa/demotion_enabled is true, the OOM killer will not be
invoked and the system will become inoperable, regardless of whether MGLRU
is enabled or not.

This issue can be reproduced using NUMA emulation even on systems with
only DRAM.  You can create two-fake memory-tiers by booting a single-node
system with "numa=fake=2 numa_emulation.adistance=576,704" kernel
parameters.

The reason for this issue is that memory allocations do not directly
trigger the oom-killer, assuming that if the target node has an underlying
memory tier, it can always be reclaimed by demotion.

So this change avoids this issue by not attempting to demote if the
underlying node has less free memory than the minimum watermark, and the
oom-killer will be triggered directly from memory allocations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
v3:
- rebase to linux-next (next-20260108), where demotion target has changed
  from node id to node mask.

v2:
- describe reproducibility with !mglru in the commit log
- removed unnecessary consideration for scan control when checking demotion_nid watermarks

 mm/vmscan.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index a34cf784e131..9a4b12ef6b53 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -358,7 +358,21 @@ static bool can_demote(int nid, struct scan_control *sc,
 
 	/* Filter out nodes that are not in cgroup's mems_allowed. */
 	mem_cgroup_node_filter_allowed(memcg, &allowed_mask);
-	return !nodes_empty(allowed_mask);
+	if (nodes_empty(allowed_mask))
+		return false;
+
+	for_each_node_mask(nid, allowed_mask) {
+		int z;
+		struct zone *zone;
+		struct pglist_data *pgdat = NODE_DATA(nid);
+
+		for_each_managed_zone_pgdat(zone, pgdat, z, MAX_NR_ZONES - 1) {
+			if (zone_watermark_ok(zone, 0, min_wmark_pages(zone),
+						ZONE_MOVABLE, 0))
+				return true;
+		}
+	}
+	return false;
 }
 
 static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
-- 
2.43.0


