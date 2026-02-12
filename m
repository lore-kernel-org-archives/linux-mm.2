Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5AEDEDF04C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 07:28:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFAF76B0089; Thu, 12 Feb 2026 02:28:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA8346B008C; Thu, 12 Feb 2026 02:28:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7D066B0092; Thu, 12 Feb 2026 02:28:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B164A6B0089
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:28:00 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 167A613B8BC
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 07:28:00 +0000 (UTC)
X-FDA: 84434975520.08.55EC092
Received: from mail-dy1-f193.google.com (mail-dy1-f193.google.com [74.125.82.193])
	by imf29.hostedemail.com (Postfix) with ESMTP id 40A0F12000A
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 07:27:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PWiaFwmj;
	spf=pass (imf29.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.193 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770881278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JvjQ6ERmtGGT/bQN0zFK0YTYG8Pns6F7R1sS65GLjRY=;
	b=Arm0wVJ74HB7vN6w5jkG2snWGlRCo+L4Y3rlvRvrQEOYuIn/BPrQ8AAjlAWNph8XxP3LsC
	aBsHNZ/W/frZ/2f73adeKAYCvyz5BDYngNSPwUr3AtFEGkL3jRb0DlX3U8Wb6NiRflCgXP
	QdzHeE5A17SsS9wF+CwWTqeS6BMkK1M=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PWiaFwmj;
	spf=pass (imf29.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.193 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770881278; a=rsa-sha256;
	cv=none;
	b=ZZdlKD/XxSjqqOutPH6g62zLc4fGe1nH94Xsp4Y7ZWDavPJ6ryacqRj6qBee2y3q25unm6
	jW18s9XYz6BRN9T5rmRTueqGbuWXauOFr/JOyXRifW+CuLRx5Czj8fCBkxHQA4+e7fr64U
	zrEq94SCWNMVAuGeH9+WQmRH3/JCgCg=
Received: by mail-dy1-f193.google.com with SMTP id 5a478bee46e88-2b6b0500e06so8100971eec.1
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 23:27:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770881276; x=1771486076; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JvjQ6ERmtGGT/bQN0zFK0YTYG8Pns6F7R1sS65GLjRY=;
        b=PWiaFwmjFHowzECmZWuxqJid7eESw/AQUWoaJHdkwr9vfq/PUZfRC+OG/158Bn9PUu
         OsKKWhmg5dbvhcZj1mHNJyZ3tHTVyuUom6CMrcQ0wbo7x/sp2V0V90ehmuOILERTe/et
         tSbsYA1u0WiOBz212Fw7PxMzHaxPYSgmLRUyNLysPyZgJjv8RT3yXYyX7gmT0S6zzXS5
         nmXRhMYFNaLx41THsuHNzV8dciPJmwXGDguIGG7BsflzqLXcYZuRxqtMe1Zx/bMPskfp
         w0ncfAopdkcHFODPX57Yfhy00G7JbaTICx+yGxCH95OASsFQUmwOXkCFZ9VrPLdojlU+
         scIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770881276; x=1771486076;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JvjQ6ERmtGGT/bQN0zFK0YTYG8Pns6F7R1sS65GLjRY=;
        b=LFSHuOvE+VAVKxMmCwFREbPbkPyKF9hBykz27unSu2vEq9y3XqRj1yLbnVbb1DcOo9
         6xsTzPIz2LfXKn+GVr4VWhV6bfoUa9qVnimVMzF4dFC0dILvbcunL1osU2h+W0BImZV8
         gXo7gHsQfhMNnEMflzUemT9YdK/zE8LIlYNVT+p08a+wniqIkPMSdStzShijKObaqFkI
         krt/8teBulbsLkeQozr8UyebTer/BgmEC8d2F0jodqWJiHnebESWaz5TVD4jXer9DLAS
         WSL9R33E8Akzfv93aLChoDjcFgD1Jl+n3WeE5b5zP7kyjZ5qhGOnpF261Ry8wfYh2yrp
         wI9A==
X-Gm-Message-State: AOJu0YzAzXVxwFvJ97I+LmiOBmrUbthSwIKqXgYdJiNhYGEvxl1+Bfyp
	TQzIoPC31HK0W9s94AMTT9k4MMeDbEZT7rq+fM64+Cj+ZeR6zmgJa6gn
X-Gm-Gg: AZuq6aKt7dH4+ER0HmVNz6RuXg9yjhEc3vRcmqMCo3Wty7T578lpwWkHL0Jehev3RGi
	4OnZ3Js1POG70MOxLf5/hZ0NHiqY3dXw+B7EyCScFBwMcHaYYl+7aMhCg7qboFHxZJQrgupqw1w
	hv2Lvlkt+i7BGHhyDNdyFHNBCqR8wcfMaYPzl/iEYb2WBoFszS4IkkcA5dDUiWEfS8FZE2U+eHd
	Hh7Imbby08A7Z90Oa/MOa8V9uNHU8wctVGRJ1Za3F+iR/oMQvba8nrwLJIloEjScqO53gUEEW4v
	fbJa3k8+wxULchk3GXkKFc/NAEEy07WY157LXE8ntbRoOpwcE064+m1ULZX+5fT8xjA6rdUrtxR
	BmXSM7pDiufl4MToz5OR5kWTRRy3+OureYLQop6doj5oq5sG/knEJoAmGjupqYG+UTJV50LT05a
	2dev+qv0LdqX88oBBv
X-Received: by 2002:a05:7300:d709:b0:2ba:6978:2b4 with SMTP id 5a478bee46e88-2baa804699amr734834eec.20.1770881276349;
        Wed, 11 Feb 2026 23:27:56 -0800 (PST)
Received: from wujing. ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ba9dcfb804sm3058378eec.28.2026.02.11.23.27.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 23:27:56 -0800 (PST)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Thu, 12 Feb 2026 15:27:41 +0800
Subject: [PATCH RESEND v8] mm/page_alloc: boost watermarks on atomic
 allocation failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260212-wujing-mm-page_alloc-v8-v8-1-daba38990cd3@gmail.com>
X-B4-Tracking: v=1; b=H4sIAOyAjWkC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyLHQUlJIzE
 vPSU3UzU4B8JSMDIzMDIwMz3fLSrMy8dN3cXN2CxPTU+MScnPxk3TIL3bQkQ0tzy6TEZLO0VCW
 g7oKi1LTMCrDJ0UpBrsGufi5KsbW1AANjg49xAAAA
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Lance Yang <lance.yang@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kernel test robot <oliver.sang@intel.com>, 
 Qiliang Yuan <yuanql9@chinatelecom.cn>, Qiliang Yuan <realwujing@gmail.com>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 40A0F12000A
X-Stat-Signature: 8x1it3aqup9nq1m1n8mwqfutmandcup5
X-Rspam-User: 
X-HE-Tag: 1770881278-82099
X-HE-Meta: U2FsdGVkX1+1NFhKzyudYWYbYbrTgqgoVoSspBRBrvs9IBYwwyLvylMi4ITYBPQroQhPZtDcPj9zRN28JkTuoBOJtvax7mEvki7ttj36uruhfJ/ODThWivc8zhpaKcYtJmEcfYD8g6WpdIdo+O3tR1fDAEP3e4s/mglHNiPtDgPzACixRuiH7boDLyx6EKlWCx4H90Fd/Z6DNfS8TQUBOMtI+H9n6ikiyjUFOuVIv4YjXxW1Lu0jcOyZrNFZAo2SN+hY13MPQ0jyX4sbkMjGkkctt+g+W9M0qIDul4MJ6Vm7JJaZIB8dof0NUU6w8N3qXM77n/TYByQGJAxshVJGDuo6PHT9ra1bzJIvGgQkpXOzXdwgeBHC0sVrhQYT1cyuDDeJeMUiP7fmH2l5txLINfz9dGtxh5OAwTbN0M/j1afA4EeD7tvztvy7C3lck1cmaJaEXqjARpOmubDaX6Kd0vubeTVwne+XL2WWwnZihctUIHY4uM/Zsoabwr/WoDwdMTcXZFGoc+dmLEdC4YdVS8TpEEzAOcRbNgs/cq3VWk7BsgoiYXdWYVyU1VBQLr/6jXLGVLNdoMPLOGu0DVaGk2BTA3d7C6lQETQ6ySrHRfy9TxV4Rgd8CKSAgORSctq4m7H/PukgedugsB6H1wqZWbf8dnXvef1L0FIO6AtNNiWqcf8guRNqY5KUGJZ2LHWu0EyPV0Vk7Wlqx42J+L/bYIobmGQ1qaQK65tGPSZh79he/OrgI2qWNHCc0e6uoAgR3wnFg7CpQIrkrRfPj0gnLdbGdZztKV9/VsEA3sQj7ZdQn5xqttDtuLnAplaTvQlYsq2Fv5+i4N4+itpuC32V9gdcDbjVYtp6P7bKBlQAd9A89aatEsUf5i46c61O74MdOGsDZvjx42XcLK1oPWtsXUjmYbEZ3+S5BfAwY1FXvSXXKCVyiM8rUgMVfi+Hi6S+MXICopW2HHPUxNRTFGh
 nJWcfBJ3
 6R5GFc+QUr5YNTzbhYEM6iU2ce33BqKfmNI/S6M/7DgAFIu48jhXYrdCUy8w38J60f1gyQMus82lBFa1SnkSW7BTZ5tQOCtj4fDQtzbCHRJwpbw/m9Anl0i1Wu3tqjKuFRFaOHYX0TaZtOooSy490yFSL/flb1mKo6eaODMpCjWAa3IzUtmvJULGn3NpzHviDgiY/FkByk8Ua1EBK0RyYBU3KCB0KK3RaMbbf2XE1DjpddyYIYPC7NCyy4euXonPUkBRbqEa2k/Vl+JiOZ1R9l+Pu+eyq1ecLz7f6mMOdNlWe/A0AcAdmJM7uZC1EdU4rOVvoVuzLI2901VpFyRuA3TuBeK5TnKmKxETRs6FCxOI7RkFXwnguDX2vNuWtEduRXQxnPkgmocp76ENLL/z/nKattAZyKOePAb+g0InM39GZcV0Ix9UnOkQs974bn5VGvpsmP9cJSJpjCEhe7VcobV+Ar/48v2PzPjgDMZSuFnmULE3Pnuo+6dIti46cumyguWlRBHNWHoREOGQwsllwdyjr/qJfWs+ol7ShwMMYa/Qn1hnAm+keutZfUd0GvSxZ5pcDX7AXUoYYOfM8veJpydQzsqk0HAWSM90h
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Atomic allocations (GFP_ATOMIC) are prone to failure under heavy memory
pressure as they cannot enter direct reclaim. This patch introduces a
watermark boost mechanism to mitigate this issue.

When a GFP_ATOMIC request enters the slowpath, the preferred zone's
watermark_boost is increased under zone->lock protection. This triggers
kswapd to proactively reclaim memory, creating a safety buffer for
future atomic allocations. A 1-second debounce timer prevents excessive
boosts during traffic bursts.

This approach reuses existing watermark_boost infrastructure with
minimal overhead and proper locking to ensure thread safety.

Allocation failure logs:
[38535644.718700] node 0: slabs: 1031, objs: 43328, free: 0
[38535644.725059] node 1: slabs: 339, objs: 17616, free: 317
[38535645.428345] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
[38535645.436888] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
[38535645.447664] node 0: slabs: 940, objs: 40864, free: 144
[38535645.454026] node 1: slabs: 322, objs: 19168, free: 383
[38535645.556122] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
[38535645.564576] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
[38535649.655523] warn_alloc: 59 callbacks suppressed
[38535649.655527] swapper/100: page allocation failure: order:0, mode:0x480020(GFP_ATOMIC), nodemask=(null)
[38535649.671692] swapper/100 cpuset=/ mems_allowed=0-1

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202601271341.5d24a59f-lkp@intel.com
Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
---
v8:
- Use spin_lock_irqsave() to prevent inconsistent lock state (softirq-on
  vs in-softirq) as reported by LKP.
v7:
  - Use local variable for boost_amount to improve code readability
  - Add zone->lock protection in boost_zones_for_atomic()
  - Add lockdep assertion in boost_watermark() to prevent locking mistakes
  - Remove redundant boost call at fail label due to 1-second debounce
  - Link: https://lore.kernel.org/all/20260123064231.250767-1-realwujing@gmail.com/
v6:
  - Replace magic number ">> 10" with ATOMIC_BOOST_SCALE_SHIFT define
  - Add documentation explaining 0.1% zone size boost rationale
v5:
  - Simplify to use native boost_watermark() instead of custom logic
v4:
  - Add watermark_scale_boost and gradual decay via balance_pgdat
v3:
  - Move debounce timer to per-zone; optimize zone selection
v2:
  - Add debounce logic and zone-proportional boosting
v1:
  - Initial: boost min_free_kbytes on GFP_ATOMIC failure
---
 include/linux/mmzone.h |  1 +
 mm/page_alloc.c        | 48 ++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 75ef7c9f9307..8e37e4e6765b 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -882,6 +882,7 @@ struct zone {
 	/* zone watermarks, access with *_wmark_pages(zone) macros */
 	unsigned long _watermark[NR_WMARK];
 	unsigned long watermark_boost;
+	unsigned long last_boost_jiffies;
 
 	unsigned long nr_reserved_highatomic;
 	unsigned long nr_free_highatomic;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c380f063e8b7..7dc1e056a082 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -218,6 +218,13 @@ unsigned int pageblock_order __read_mostly;
 static void __free_pages_ok(struct page *page, unsigned int order,
 			    fpi_t fpi_flags);
 
+/*
+ * Boost watermarks by ~0.1% of zone size on atomic allocation pressure.
+ * This provides zone-proportional safety buffers: ~1MB per 1GB of zone size.
+ * Larger zones under GFP_ATOMIC pressure need proportionally larger reserves.
+ */
+#define ATOMIC_BOOST_SCALE_SHIFT 10
+
 /*
  * results with 256, 32 in the lowmem_reserve sysctl:
  *	1G machine -> (16M dma, 800M-16M normal, 1G-800M high)
@@ -2161,6 +2168,9 @@ bool pageblock_unisolate_and_move_free_pages(struct zone *zone, struct page *pag
 static inline bool boost_watermark(struct zone *zone)
 {
 	unsigned long max_boost;
+	unsigned long boost_amount;
+
+	lockdep_assert_held(&zone->lock);
 
 	if (!watermark_boost_factor)
 		return false;
@@ -2189,12 +2199,42 @@ static inline bool boost_watermark(struct zone *zone)
 
 	max_boost = max(pageblock_nr_pages, max_boost);
 
-	zone->watermark_boost = min(zone->watermark_boost + pageblock_nr_pages,
-		max_boost);
+	boost_amount = max(pageblock_nr_pages,
+			   zone_managed_pages(zone) >> ATOMIC_BOOST_SCALE_SHIFT);
+	zone->watermark_boost = min(zone->watermark_boost + boost_amount,
+				    max_boost);
 
 	return true;
 }
 
+static void boost_zones_for_atomic(struct alloc_context *ac, gfp_t gfp_mask)
+{
+	struct zoneref *z;
+	struct zone *zone;
+	unsigned long now = jiffies;
+	bool should_wake;
+
+	for_each_zone_zonelist(zone, z, ac->zonelist, ac->highest_zoneidx) {
+		/* Rate-limit boosts to once per second per zone */
+		if (time_after(now, zone->last_boost_jiffies + HZ)) {
+			unsigned long flags;
+
+			zone->last_boost_jiffies = now;
+
+			/* Modify watermark under lock, wake kswapd outside */
+			spin_lock_irqsave(&zone->lock, flags);
+			should_wake = boost_watermark(zone);
+			spin_unlock_irqrestore(&zone->lock, flags);
+
+			if (should_wake)
+				wakeup_kswapd(zone, gfp_mask, 0, ac->highest_zoneidx);
+
+			/* Boost only the preferred zone */
+			break;
+		}
+	}
+}
+
 /*
  * When we are falling back to another migratetype during allocation, should we
  * try to claim an entire block to satisfy further allocations, instead of
@@ -4742,6 +4782,10 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	if (page)
 		goto got_pg;
 
+	/* Boost watermarks for atomic requests entering slowpath */
+	if ((gfp_mask & GFP_ATOMIC) && order == 0)
+		boost_zones_for_atomic(ac, gfp_mask);
+
 	/*
 	 * For costly allocations, try direct compaction first, as it's likely
 	 * that we have enough base pages and don't need to reclaim. For non-

---
base-commit: b54345928fa1dbde534e32ecaa138678fd5d2135
change-id: 20260206-wujing-mm-page_alloc-v8-fb1979bac6fe

Best regards,
-- 
Qiliang Yuan <realwujing@gmail.com>


