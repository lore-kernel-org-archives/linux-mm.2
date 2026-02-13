Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 328ECEF48CC
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 07:18:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81E606B0089; Fri, 13 Feb 2026 02:18:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E89C6B008A; Fri, 13 Feb 2026 02:18:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71F216B008C; Fri, 13 Feb 2026 02:18:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 620AB6B0089
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 02:18:56 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3706113ABE4
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 07:18:56 +0000 (UTC)
X-FDA: 84438581472.08.C140EC7
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6DF3E40006
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 07:18:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q8s5gGk6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770967134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mHfHSc3Ob3QWgekFQ3UZMwloiqpQ6O0L56YYA+KphRQ=;
	b=Z6bWDnE4BwUkoEgE76iQx+XxIt49s+H/g9tzkdz4ol7DdtbYCxlaB0PJJ5LluDG2cgzF6Q
	uyh5rfeO863iVALDfBn8qKqXCUbrXxgGKt21/r1Pu40QEWMMwV2aykSrKwQSrCkd26jGOq
	kRIaKcAJcLEcF3HYx3LQR8aIhYTWPOo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770967134; a=rsa-sha256;
	cv=none;
	b=fWCwnj9Kt3YP2kJerFaWOGWRDvL9kq+cuDd4VYJ3C9kDthe6MwgVWh3xPQclcntORwzP4Z
	7vYaFzY0ojIEbCk3V6tcmu4iiCjNQ8h19DX8Y3CPnnre9gk4TC4ZgtI0P9ZM+tb2F9Qoxb
	N6+dl+G/H5KtXTEMyI15P66l6ZvACCw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q8s5gGk6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770967132;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mHfHSc3Ob3QWgekFQ3UZMwloiqpQ6O0L56YYA+KphRQ=;
	b=q8s5gGk6nAy7TfViTElsNOtPlfFYJ5AKUJcxKKqU6N/XWwt2pCyQB3Kb7hQRh7V1JSa5Ew
	L97yUQC6jl83wBZqHVzK6GLQtifrsAMqT29P+FF2tc20W5qyuG8nD3ekQkwUtTQDRt4B/o
	WL2zvutLAMTUbwgTkfzHX2BiHTtzGo8=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: jiayuan.chen@linux.dev,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Shuah Khan <shuah@kernel.org>,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH mm-new v3 1/2] mm: zswap: add per-memcg stat for incompressible pages
Date: Fri, 13 Feb 2026 15:18:22 +0800
Message-ID: <20260213071827.5688-2-jiayuan.chen@linux.dev>
In-Reply-To: <20260213071827.5688-1-jiayuan.chen@linux.dev>
References: <20260213071827.5688-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 6DF3E40006
X-Stat-Signature: m5tbzp3hiz961n4nfr4wpd1ueeaqwdpz
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770967134-225027
X-HE-Meta: U2FsdGVkX1/ZtJcmp1J4Yr2DlznkMl0MV+Q6fkadN/JJDNcXvJROiauuqlNtqF6ZQd76d/V2Jy2jFBKZZRgppmoKG7ZNACQFPLSqWgg2w4dP+r2GgiOLpyPNDSx6z2ZHGkg+jpd258zh3RC4N8kOz5g0U8RHcm55h0w+j9AJSRMwq6WMkM1VR7hfA7iYVoSFIVDvfwU42DUHWQfEziwT+mrYbv/o12WCui8y7Ovq1/zf0mMkQpCLQyQlIH9erjW9XApj0ZhgS9zUmVkUR+b2X2Z5NpElQpyCY38CU55a6P9CXYRjakf2IbQimAoqvv4F+uKeHOPZmKAKXs/+7xX/qaXP6+hqwclPtFZYtHx8nps7gerX+Qh9mov0bbyRIrY58un1q5UZ17XTReSP1yy6dFzrmsuFwdPFcor80uaSjME/G6UYoUrR6YP6LsFYParFovnGmqNdh1eSeQ/yzZGE2LKAttvZqZtu0QQtCW8N9fefF8F72j20LZJjF4OmLoqrdTf4wasJbvIClXbLf3fGJbluLlxGJc971FF16xgsMsewG9yBvjtPrjZFFnKWsijqUU/QlfoEeLCLNs+2QbcGVSOZDPe2iITZrVpi3Z2grHYQ2lsY3AGaIDu4e3auk4SKa+vHCnTdF6DlRGFLGnjxN2JV2d83r1cwmcdmMtR6ncDINLMRIiVQKz8oga35E1GPh1kjiVlxSDubNxRPAnb/cjc3P0W0V6THZjbMgkifGg6P2yF9yNPZJogzBvHUbx1w0+cA//UWV559xRdAbk/36EQE0JlsIaIPqLr8wJIkUrB5V1kMN/ay5ve9TcPnEl8k7DrzJNRyI26dqgGluWVaLbELhR56CRLPPXJgBCWk88mX5yTHHa5k1RjQT2lOwLW/9bamM4pmBZ0nOfCzkjgLuSPWW/QoZ/+OdTl1i7EGr8/j+KKKRYI3BeJ4EaLKNo01IEhezWgn6pas5rj/vT3
 +S0Hw9+m
 0jSXxen17mvKg5uHQUX/fiBK0aqx/LiALS+Pqb+QfptVEETeoXnoMKZ3uFiBk0DqFdyUp51saxdprKr/tvJ0GG707HkosS7k9dNbGjwHS+fnHOERIe8pOpDrokcBUP4JQrOkDGVfdOo85Qsn3Q+F7z6/MM6+xMX8rBSTNBcS4ZCE2C+No0fKVuyK/3vIjBHOKb+UWYLSuuyg6sL3lC8N+bHdMZTvtjW7ck2/mI+aAN6m5PR0p2dFQiXZLYBS9/sps4VW2EauIBJpJtSxyCLs7ECy4ft/Hv0mAeoZ2m30wIsdTYU3KID7sUKTSXg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jiayuan Chen <jiayuan.chen@shopee.com>

The global zswap_stored_incompressible_pages counter was added in commit
dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page as-is")
to track how many pages are stored in raw (uncompressed) form in zswap.
However, in containerized environments, knowing which cgroup is
contributing incompressible pages is essential for effective resource
management [1].

Add a new memcg stat 'zswap_incomp' to track incompressible pages per
cgroup. This helps administrators and orchestrators to:

1. Identify workloads that produce incompressible data (e.g., encrypted
   data, already-compressed media, random data) and may not benefit from
   zswap.

2. Make informed decisions about workload placement - moving
   incompressible workloads to nodes with larger swap backing devices
   rather than relying on zswap.

3. Debug zswap efficiency issues at the cgroup level without needing to
   correlate global stats with individual cgroups.

While the compression ratio can be estimated from existing stats
(zswap / zswapped * PAGE_SIZE), this doesn't distinguish between
"uniformly poor compression" and "a few completely incompressible pages
mixed with highly compressible ones". The zswap_incomp stat provides
direct visibility into the latter case.

[1] https://lore.kernel.org/linux-mm/CAF8kJuONDFj4NAksaR4j_WyDbNwNGYLmTe-o76rqU17La=nkOw@mail.gmail.com/

Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 5 +++++
 include/linux/memcontrol.h              | 1 +
 mm/memcontrol.c                         | 6 ++++++
 3 files changed, 12 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 7f5b59d95fce..78a329414615 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1737,6 +1737,11 @@ The following nested keys are defined.
 	  zswpwb
 		Number of pages written from zswap to swap.
 
+	  zswap_incomp
+		Number of incompressible pages currently stored in zswap
+		without compression. These pages could not be compressed to
+		a size smaller than PAGE_SIZE, so they are stored as-is.
+
 	  thp_fault_alloc (npn)
 		Number of transparent hugepages which were allocated to satisfy
 		a page fault. This counter is not present when CONFIG_TRANSPARENT_HUGEPAGE
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index b6c82c8f73e1..d8ec05dd5d43 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -39,6 +39,7 @@ enum memcg_stat_item {
 	MEMCG_KMEM,
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
+	MEMCG_ZSWAP_INCOMP,
 	MEMCG_NR_STAT,
 };
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 007413a53b45..4c5672169753 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -341,6 +341,7 @@ static const unsigned int memcg_stat_items[] = {
 	MEMCG_KMEM,
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
+	MEMCG_ZSWAP_INCOMP,
 };
 
 #define NR_MEMCG_NODE_STAT_ITEMS ARRAY_SIZE(memcg_node_stat_items)
@@ -1346,6 +1347,7 @@ static const struct memory_stat memory_stats[] = {
 #ifdef CONFIG_ZSWAP
 	{ "zswap",			MEMCG_ZSWAP_B			},
 	{ "zswapped",			MEMCG_ZSWAPPED			},
+	{ "zswap_incomp",		MEMCG_ZSWAP_INCOMP		},
 #endif
 	{ "file_mapped",		NR_FILE_MAPPED			},
 	{ "file_dirty",			NR_FILE_DIRTY			},
@@ -5458,6 +5460,8 @@ void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size)
 	memcg = obj_cgroup_memcg(objcg);
 	mod_memcg_state(memcg, MEMCG_ZSWAP_B, size);
 	mod_memcg_state(memcg, MEMCG_ZSWAPPED, 1);
+	if (size == PAGE_SIZE)
+		mod_memcg_state(memcg, MEMCG_ZSWAP_INCOMP, 1);
 	rcu_read_unlock();
 }
 
@@ -5481,6 +5485,8 @@ void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size)
 	memcg = obj_cgroup_memcg(objcg);
 	mod_memcg_state(memcg, MEMCG_ZSWAP_B, -size);
 	mod_memcg_state(memcg, MEMCG_ZSWAPPED, -1);
+	if (size == PAGE_SIZE)
+		mod_memcg_state(memcg, MEMCG_ZSWAP_INCOMP, -1);
 	rcu_read_unlock();
 }
 
-- 
2.43.0


