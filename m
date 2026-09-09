Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48D59C79FAA
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 08:09:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25DB96B0095; Wed,  9 Sep 2026 04:08:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EA856B009D; Wed,  9 Sep 2026 04:08:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB7866B0095; Wed,  9 Sep 2026 04:08:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B69566B0095
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 04:08:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D335DC013F
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:08:57 +0000 (UTC)
X-FDA: 85193497914.01.669B1CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id DCB88C0004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:08:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ScInSnsM;
	spf=pass (imf22.hostedemail.com: domain of devnull+linuszeng.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+linuszeng.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788941336;
	b=xjx1gdAOCGHkoHybtVH25Hp+lXSKnpuIv1bZrZ0bZ8n85lq2ZsddsrRkOXcFMIqDa/6VAl
	mAK6xHNZCfHHl+tRARAYUg99fN+cjxSMls2RlkZbL/B8xev3z6nrT/nRGpXHcD/MQ/kR5q
	+zu8h7SR/bD3qFytt7jJFEvvVvl3C6Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ScInSnsM;
	spf=pass (imf22.hostedemail.com: domain of devnull+linuszeng.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+linuszeng.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788941336;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/5+NsYrwn59j/aLQH+4FC7gqw0xokgFl5IrkCnrLg3M=;
	b=xDh9+qek6jhovAy/Nv0sK0a3eIpyjFKczPzyJ1DjyNUyVJSbuOKMD+bK0PO79vux0Qtt95
	ZOGb6bzmxi7bL1ZNhHhM6YsKEn9Ix2mTTpUUGzh2yNC4VeNcKGqVwofsaA5GkoX7Vn1DKq
	YuYDpQEL/3LnowURGcYQBgSGERBI5OA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F0A043AD7;
	Wed,  9 Sep 2026 08:08:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E7E10C2BCF4;
	Wed,  9 Sep 2026 08:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788941334;
	bh=0N4tCqvoyEM1SL2Vocr2i9WoAjYrlgAoSQ2+oga4Vkk=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=ScInSnsM2M7JBpwIMPq/Id4rgoksbi3q3+WQmS3bqquSv1GVtXJgYFOmqJ/BhL86T
	 JC7kDXzzKkJYSJxw2hvAoCDQO/iOvVYRM3X55/JOrv9OVWSGribrNdY62+rgsDdEOa
	 F3bJa1z5S7XjPIBsPzFOA7B7v85Q4g6X1/t45whBk8ZKWQ//V9/au9XNASLOx8JstS
	 TqkDIi1rBoaCYWcj8Xf7IsD1PRyxKAClkbAgLmqJId5/xFAszed3p8jYRL8q+4bpym
	 iiPOc6cbT90ZTfJ8f8bwW9hanrSTWd+UacYGg2Fnmdc96yWY4v5NHfpEH8P8pwJcC0
	 gi9+CbjTdoG8g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4A95C79FAD;
	Wed,  9 Sep 2026 08:08:53 +0000 (UTC)
From: linuszeng via B4 Relay <devnull+linuszeng.tencent.com@kernel.org>
Subject: [PATCH 0/3] mm: page_counter: move hierarchical protection out of
 struct page_counter
Date: Wed, 09 Sep 2026 16:08:50 +0800
Message-Id: <20260909-descriptive-name-v1-0-1828961cb01a@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABIUoWoC/x3MQQqAIBRF0a3IHyeYQWVbiQair/qDTDQkiPaeN
 DyDex/KSIxMk3gooXDmM1S0jSC327BBsq8mrXSvjDLSI7vE8eICGewBiW7UtlvNMHpPNYsJK9/
 /cl7e9wOwMuUWYgAAAA==
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
 Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Jingxiang Zeng <jingxiangzeng.cas@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>, cgroups@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linuszeng <linuszeng@tencent.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788941332; l=4127;
 i=linuszeng@tencent.com; s=20260909; h=from:subject:message-id;
 bh=0N4tCqvoyEM1SL2Vocr2i9WoAjYrlgAoSQ2+oga4Vkk=;
 b=Pt6vMJJnazt3S702QoElX0h3DiSOPfuKq644OwsYOWwrBGuuzqbgGc1I5x8AomssdowVUMDs4
 53xvtqoHIipD+Mkj2ZSK1V4uwV1wqmkXLlj0IzhO7K0eYBvimjsL7eZ
X-Developer-Key: i=linuszeng@tencent.com; a=ed25519;
 pk=6K54xRzYIRWqatrAPy86M4E0MsI92BVJBhXwz5NdC74=
X-Endpoint-Received: by B4 Relay for linuszeng@tencent.com/20260909 with
 auth_id=1017
X-Original-From: linuszeng <linuszeng@tencent.com>
Reply-To: linuszeng@tencent.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DCB88C0004
X-Stat-Signature: epc7ama1wd4hg47kjxn1g4c1arxf8iug
X-Rspam-User: 
X-HE-Tag: 1788941335-36403
X-HE-Meta: U2FsdGVkX1+1326kTL5Oawi5ekoaQRQE3uw4kxjtHQ35hjCf5SaksU1hvfAaJ6lgBMD1XjUVSSrIwaUf+3WuaP+ilaYuCl7M8ORcRl8wUa8+AJfR/Zd6CdeaVb71cnvOVnKtxzFe+Y9jb/elqK7EgI0hoplzZ2AR4kVWV/IvPBWxdyvse1ifSFDmEJCBtecF4jppIiOFXKIz79A+3AwZXW730bnMU3lNAL3d3JH6IBGCxpYJaGg7dlSx2AytdZvaRykcIk71u9JQ4IfudT4xBbFoLCRI8JbTrcBFDS8QSii2FK5fJWt0PSahIQ+H9dy2DCkGEguxcvX1DyAo07OTsPu732LvCY8z0ZKIc52x6+pSyxdhj+t6hq8YoCrV/V7Yitb+akwX03essp/of4Sm7B53+I4SzzCJLSvWeHEl9a2L/sPjGgW8HQEeQDOpjCAvCv+LCAt0kd+Usn0J+jlADKRa21rwnAoalyK6JpHH4ANeXv9/z16OLcuYJWKNBieq6ZKYc/BvFyrx5I543e3q9PAnVF0Y9D8/b/MliZmNFrn3xldZmc7g6bsnwj9cbOotlTqqGhJSqZl65vKV2WbtEYJc0hidM2QotLBAtAKtrjm/MdMX9xpLHW1dRwEjnvNz0XOmDbVEB0PWndTpQfCnGGzwTZuCtOuD/NRWo66LkO0KLX2eRhUVvvBi5f0GRnQhOKYgTNxlZ2Dyz3sV7gzBku+FsyD5LsQ/6o3xJddTIECW5w8Fb2Go5/6B0RaOYED0C3W6x6GwfKJ7TnoZQ7BK2M5efi0wXLIDpcrs3aHkyH6lj640nWTVpKOa+1Bi4y3Sl6Y5bQBJ6jTtSF872hGiSwCeqmjWjPYYodWxuTronLic2G+TFV5ydWLBpFIdYhDtliZW2ou1qBoVDVQLgpb4VDxo5TimN6eI6T99FP4H272JHh+/0cuSHMpz/fuliEKWJBRQ4+ROA51jnM9O1+l
 TT07Sz10
 7U+8+bvriSyvsu9NgOvRx5tUDuvzTnlL1kEN7AWMwY7KoKiIF9JcN5WNWh4oByMNpM/KHR7mh7bu6PnvmbItUVf391HfFxnq8Y4juqoseNPOefQoz4pHZuKnN3RfxcMuUAGj9e2Bo5FyRurFkOIhJ7RZDbspy32u+Uf6Bl0plpGtrA+jxP1iBguxARQwR8J+wSnxq3mIHm0zwP5ujONKUpAnEL9IDDsP9JoBQ/IMuzLzSevw+VtXmHAamz9rG7j4RGTqw/PCR4PLmUQ68sMtUs5X1XHYynVt+H5RIQ20V7oRfsPe3NohJsY3/zbQEVg5nHsPaRxJ9ZYLPjb9asDHSgx8uQk1VzlsLbZm0OGsB16WV18mJNg5eNzrXlQAAA8BkVb84mBS3S8Th4YeGWpw03AEJ1CVcviVdDkAB1pdOpDbXsdwaSqoHNxVGPlEclaW/GgveIsq/woeqbsIYnJdtbLY+4Lk9BPEuXwvhexfhDu8z788f3bKouzKiSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hierarchical memory protection (memory.min / memory.low) is built on
struct page_counter today: every counter carries the full protection
state - emin/elow, the protected-usage trackers (min_usage,
children_min_usage, low_usage, children_low_usage), the configured
min/low values and a protection_support flag - although only the memory
page counter (and dmem pools) ever participates in protection.
swap/memsw, kmem, tcpmem and hugetlb counters ship this state around
unused.

This series moves that state into a dedicated struct
page_counter_protection, instantiated only for the counters that
actually support protection, which shrinks struct page_counter by one
cache line.

Patch 1 adds struct page_counter_protection and links it to struct
page_counter through a ->prot pointer (NULL when protection is not
supported).  page_counter_init() loses its protection_support argument,
and the new page_counter_init_protection() attaches the context.
Protection stays enabled only on the cgroup v2 hierarchy, matching the
previous page_counter_init(..., memcg_on_dfl) behaviour, and the root
memcg keeps it unconditionally.

Patch 2 migrates the read/write side of protection onto the new
structure: propagate_protected_usage(), page_counter_set_min()/low()
and page_counter_calculate_protection() now operate on the protection
context, and the memcg and dmem accessors (mem_cgroup_protection,
mem_cgroup_below_min/low, the dmem below_min/low helpers and the dmem
eviction check) read emin/elow/children_*_usage from it.

Patch 3 deletes the now-unused fields from struct page_counter.  On
64-bit the structure drops from three cache lines to two, one cache
line saved per counter.  For reference, pahole shows the layout before
and after (x86_64, 64-byte cache lines):

    before:                                after:
     0  usage                               0  usage
     8  failcnt                             8  failcnt
    64  emin                               64  watermark
    72  min_usage                          72  local_watermark
    80  children_min_usage                 80  track_failcnt
    88  elow                               88  high
    96  low_usage                          96  max
   104  children_low_usage                104  parent
   112  watermark                         112  prot
   120  local_watermark
   128  protection_support                 size 128, 2 cachelines,
   129  track_failcnt                         11 members
   136  min
   144  low                                (the protection fields moved
   152  high                               into struct
   160  max                                page_counter_protection,
   168  parent                              72 bytes, allocated only
                                           where protection is used)
   size 192, 3 cachelines, 19 members

The four embedded page counters of struct mem_cgroup all shrink by 64
bytes, which translates to 128 bytes saved per cgroup once the one
embedded page_counter_protection is accounted for (2176 -> 2048 bytes
with CONFIG_MEMCG_V1=y, verified with pahole).

No functional change is intended: protection semantics and the cgroup
v1/v2 behaviour are preserved.

Signed-off-by: linuszeng <linuszeng@tencent.com>
---
linuszeng (3):
      mm: page_counter: add page_counter_protection struct and init API
      mm: page_counter: track protection state in page_counter_protection
      mm: page_counter: drop protection fields from struct page_counter

 include/linux/memcontrol.h   | 15 ++++++---
 include/linux/page_counter.h | 76 ++++++++++++++++++++++++++++++++------------
 kernel/cgroup/dmem.c         | 18 ++++++-----
 mm/hugetlb_cgroup.c          |  4 +--
 mm/memcontrol.c              | 29 ++++++++++-------
 mm/page_counter.c            | 61 ++++++++++++++++++++++-------------
 6 files changed, 134 insertions(+), 69 deletions(-)
---
base-commit: d118502628f8b673be9023db8bdf878f64a7ed45
change-id: 20260909-descriptive-name-e382a3f978dd

Best regards,
-- 
linuszeng <linuszeng@tencent.com>



