Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 052F8F94CA2
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 02:19:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 095E76B0005; Tue, 21 Apr 2026 22:19:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 047606B0088; Tue, 21 Apr 2026 22:19:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9F1A6B0089; Tue, 21 Apr 2026 22:18:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC7476B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:18:59 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 87EEF8D640
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 02:18:59 +0000 (UTC)
X-FDA: 84684583998.23.68A8903
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 128F64000D
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 02:18:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZK0gfWPY;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776824338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=iDp15JH4UfNo4vjohQZVb1xXaazj2eML+1p1sYxSLeQ=;
	b=RQakKCe06SV9ALzwnUKcmAEHHEI6EnSe7WaibreG8UX7FDq8XsJr6B/9OwWKEwmAy6YAwZ
	6fRxnZGEEqIgbBqP6bZhcoX6fuh35p9DYdjGMeuLopGXEGVQPjxhwBCbUsFuZ6S1FopHgQ
	qmjlkeJIjpqrpI0nZ2I0P+XQBCKYmxc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776824338; a=rsa-sha256;
	cv=none;
	b=mRfD1b9a0HC0AZcbnqr92JPdzRI8bhdg5Wu+3Q9bn737LrymAvjHmnCEFNgx+46wb2O+2i
	SciDZeL/1rmJtxWwWNuaqDrByK187ZXBH6za+kE8TCh3M4Q7gdq7Z2t4EtBtiWXbGvR4ia
	xZyS8/Dd1OrYHxxi19Fh6y8PuugeS04=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZK0gfWPY;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C7D96011F;
	Wed, 22 Apr 2026 02:18:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B90DC2BCB0;
	Wed, 22 Apr 2026 02:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776824336;
	bh=boSLg4aDv916i+8i5C7Y/j6Uxjyf83HUmuA5DXnp/po=;
	h=From:To:Cc:Subject:Date:From;
	b=ZK0gfWPYBQTysXRK+OftjkYNgCnH0oRHlX9CZj4sjA5i5KtZZ688sgoywK5QeRKSw
	 NWnTgKyZojtwwxrIhBCo02MIvbY5hiDpQZHBOJSXFYaATDF3uHe+NV2gqHrhN5lOdj
	 pcEzrRiNNOrN3gPEZ6s2Cw0ECtizWe2rcIl4+2kNoMylfx3wu05849VmYJkuJrLjfL
	 w/3SaYQE8c6QEpbMEJS1E5MvjbbHZVfVbnwM4VbFmB0Xj1w9VhhoEd+OwuFTVzH2RZ
	 Ti94HxgP6KQER5QDtD4kyNuiTurmO0L09AaxbSnlnNvukpTCUIpTF/Fv2nXwE1BNTz
	 9t/ho9nn1/oIQ==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	"Barry Song (Xiaomi)" <baohua@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Wang Lian <wanglian@kylinos.cn>,
	Kunwu Chan <chentao@kylinos.cn>
Subject: [RFC PATCH v2] mm: Improve pgdat_balanced() to avoid over-reclamation for higher-order allocation
Date: Wed, 22 Apr 2026 10:18:42 +0800
Message-Id: <20260422021842.78495-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 128F64000D
X-Rspamd-Server: rspam07
X-Stat-Signature: 8q7sgyfbg6u7jx4oucbw1urzep3tagwj
X-Rspam-User: 
X-HE-Tag: 1776824337-860103
X-HE-Meta: U2FsdGVkX18h99VgAbjeB+LhlW55KNdWJiq8xAl9zfuKyu/79osNTmA4heW3vYy8dzZJJbFs51KMUEiqdrB7+XVIgsCK8bVmKCl+517zZTVKOBDgCvcoIzu6LfjV6lMbTsLNoYWu7RJqp0WwcaSt4iuboKP/RVl/LVhks3FwPlWCVR7eONni5/EBaHo/tti9goDOFaNqDWHlN6r5kxlSX72mEHuzfGVTdIm0YGWfcuJYa3BdTbbjPVbwVWEYD2KSNZfjzXDmNqflj3aOOji927+9P1YIlVVf4z8qQZnLdKOF3U+cYh2wECuXKk8rwU78dxOk11hmCgK+pTkwEX3skSeucyGCBp5u8glhCjYf2toxlM0RExHo9sAInJJNkRNxni5cEZQ1o0/POuTYAL1oQRsyYt/EkDlXz93e7RV0dttjj1kKiggbr29GfrM/HBVTcdK7n/ScazhTVyqkko8KMAnvlQBNP4a1SLoMvM6avBk9RaodRkUVsEi/ayuAxf+i0wc4gUz+6OtQyZwsuvPRpA9Y3g1VIXnLMeoux0t7fnHfIHKv4vWTnlt+6ElB3VtNmqpdzsGqsElCJaVSmz8x/A9AOJqxXe2bfHRfxHHEuNdeSVekkZrNKFEnIlREAH3NbETewbMpX5utM7QVrghWw2IvQca6DnilpNVn1G1hvdBAYUQ1w+o0qni48NmHa+YvzbFiPVxyBKXYkmsaB5WKiusLqCQCCK5t130BkClJA24nY7z3Dy2vtK/aVYouMGsVP/a8/tXbilp7VkHDllW89JbGC8sO614OTqrYHIVKio/B2sSrPRC3F4zjx5h1uFhu1Dl8WFhHOnWrZ2YOFfu0m58aousCsKhm08k4Tm3IZIy44AfWgbXwd0LPFDyZdXgqu14Yk5hwwDjCOFoP6aRO/2sCusKtk5TjGolRcd4ISjpCkBL6oiLbKBbj541jD/jfafQ5qKm9CHt1hgxT3Ie
 kDAQZN7S
 QDz3W+zzpctqkYiHhUrQ/RI4ZzdExPu9ZwKU6pozbPRNh3knp6VzuRrO6NwhDjDU8+VQyOW2s+IvZYbIVRjKfVS1yEuCxWybxqxIxzHFgmPkgBvHCtedTXndX27wTG5ozM/Z0u7rok4f06lBtILgS9q1PcY+obSRrWF8Qb/illFPs/oc3tGcu3R1HGArbjDwpzHfz6HTrWDPe55VPHTxuTaot/NiFOaqoE2SpymD/bdCF4oRK23AODjcPH+/Nd5IV97tuJ31tWoLQTyRV9Bth56Yi1o8dTZJA2tp2oP/PunaLAOHbrunvM/OjmhH2UMO1d9DR9pux0UhrSqeHVsjRBUwPHYi1baD/Wy6cDkcGUB1xqnxqH9edW0Cvq+hQKG3CwIZcHXaorL+HpHDCAit1fILfm/vYBh7E6lYGMj+ptQ7x5j5EltIhTSZoSDYxitkfi1kWMd3RopZ+SW8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We may encounter cases where the system still has plenty of free
memory, but cannot satisfy higher-order allocations. On phones, we
have observed that bursty network transfers can cause devices to
heat up. Baolin and Kairui have seen similar behavior on servers.

Currently, kswapd behaves as follows: when a higher-order allocation
is issued with __GFP_KSWAPD_RECLAIM, pgdat_balanced() returns false
because __zone_watermark_ok() fails if no suitable higher-order
pages exist, even when free memory is well above the high watermark.
As a result, kswapd_shrink_node() sets an excessively large
sc->nr_to_reclaim and attempts aggressive reclamation:

 for_each_managed_zone_pgdat(zone, pgdat, z, sc->reclaim_idx) {
 	sc->nr_to_reclaim += max(high_wmark_pages(zone), SWAP_CLUSTER_MAX);
 }

We have an opportunity to re-evaluate the balance by resetting
sc->order to 0 after shrink_node() with the following code
in kswapd_shrink_node():
 /*
  * Fragmentation may mean that the system cannot be rebalanced for
  * high-order allocations. If twice the allocation size has been
  * reclaimed then recheck watermarks only at order-0 to prevent
  * excessive reclaim.
  */
 if (sc->order && sc->nr_reclaimed >= compact_gap(sc->order))
 	sc->order = 0;

But we have actually scanned and over-reclaimed far more than
compact_gap(sc->order). If higher-order allocations continue, we may
see persistently high kswapd CPU utilization coexisting with plenty of
free memory in the system.

We may want to evaluate the situation earlier at the beginning.
If there is plenty of free memory, we could avoid triggering
reclamation with an excessively large sc->nr_to_reclaim value
and instead prefer compaction.

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Co-developed-by: Wang Lian <wanglian@kylinos.cn>
Co-developed-by: Kunwu Chan <chentao@kylinos.cn>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 -RFC v1 was "mm: net: disable kswapd for high-order network
  buffer allocation":
 https://lore.kernel.org/linux-mm/20251013101636.69220-1-21cnbao@gmail.com/

 mm/vmscan.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index bd1b1aa12581..4f9668aa8eef 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6964,6 +6964,13 @@ static bool pgdat_balanced(pg_data_t *pgdat, int order, int highest_zoneidx)
 		if (__zone_watermark_ok(zone, order, mark, highest_zoneidx,
 					0, free_pages))
 			return true;
+		/*
+		 * Free pages may be well above the watermark, but if
+		 * higher-order pages are unavailable, kswapd may still
+		 * trigger excessive reclamation.
+		 */
+		if (order && compaction_suitable(zone, order, mark, highest_zoneidx))
+			return true;
 	}
 
 	/*
-- 
2.39.3 (Apple Git-146)


