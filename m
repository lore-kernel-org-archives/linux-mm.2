Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D33F4C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 02:05:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 800FA6B008C; Tue, 22 Sep 2026 22:05:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D9096B0092; Tue, 22 Sep 2026 22:05:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7179A6B0093; Tue, 22 Sep 2026 22:05:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EE4066B008C
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 22:05:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6B2D4C0650
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:05:56 +0000 (UTC)
X-FDA: 85243386312.15.A039A6C
Received: from mta1.migadu.com (out-104.mta1.migadu.com [95.215.58.104])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1C55D180006
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:05:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nQQrrWPb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.104 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790129154;
	b=UZ2TyhTkWhETY55Qf5WKV/YgH9iTxOIJg5tMq2xaKlAgEFbEJ8bUJD2gHiTKF5RQIeEFzd
	GevO9PAjPHHaKrHJqi7AGv8O8oESuQ+mpReDiOgQAd4XWmkubqoF0ao+Ip3EIvZ5bH+GbV
	e8cabbW/JcxveCSopGyThCdkeFOsLR0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nQQrrWPb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.104 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790129154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=pN9mV2MMc0cxVzTt86OQlKGODGTfmRcUSb1r7Rj7vHQ=;
	b=jziIk0gRJJRpEBghSdYq4gwzFg4bK1WtDw3p1Ii6/q7eeBdGIQUe9Ah3fG1orkJX9ar42H
	dhLYy8S2R96De18Xb8cAyY0xlRhtoS4ekVSMQrfOnmRJ8zw4KnTHLZ0qdP1x9pCCpXb4FI
	7w5s1oxWZQ19SZDlO9O08Npb23ekuFw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Lh2KAWhxN/KUy7SbPIyEGCqRbIP1h0b+ba0VIRohGTs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790129151; v=1; x=1790733951;
 b=nQQrrWPboKTz3yKFJ1BDS/AX5JhakNG1qbKpKUiwGYvNNaI4UG9WpRucx+6sQub9Fr7fG5IT
 alfeMKyIqKA5MRYy8D3UtnWQ0sReZORsgFr+3pE7QHBohpYi1so/d9vai+YuqfNuHP1Vlj4BiNf
 mIimygs7NDFP7bXHJggsjLWA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3e0c62f87578aba1;
	Wed, 23 Sep 2026 02:05:51 +0000
X-Mizu-Trace-ID: 3e0c62f87578aba1
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
Subject: [PATCH v2 0/2] mm: fix hugetlb NR_HUGETLB accounting on folio
 migration
Date: Wed, 23 Sep 2026 10:05:14 +0800
Message-Id: <20260923-for-hugetlb_state3-v2-0-e8a36245bfab@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMSwqDQBBF0a1IjW3QUiPJVkTEz2utIBq62hAQ9
 25rhmdw704KJ1B6RTs5fEVlXQI4jqif2mWEkSGYOOFH8mQ2dnVm2kb4uWvUtx6ZKcrMcslpMeS
 gEH4crPzuaVX/rVv3Ru+vEx3HCZdqEap2AAAA
X-Change-ID: 20260922-for-hugetlb_state3-573f27215d4e
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@suse.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Nhat Pham <nphamcs@gmail.com>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: hongfu.li@linux.dev, Chris Down <chris@chrisdown.name>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Hongfu Li <lihongfu@kylinos.cn>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790129144; l=3156;
 i=lihongfu@kylinos.cn; s=20260915; h=from:subject:message-id;
 bh=Lh2KAWhxN/KUy7SbPIyEGCqRbIP1h0b+ba0VIRohGTs=;
 b=YvOPgCX20y0ccSSoHy0fUm9cg0wU5mkNoQ2pYoGvL4Evn4zDlV5WAToIEiN7MaC94cVVFkqMs
 44lLGpFkrIFAZu91iI7yon669lqbXoigrE5wuglQhL7OyMsBEVVExQq
X-Developer-Key: i=lihongfu@kylinos.cn; a=ed25519;
 pk=rUpDSpB3neoNZRlGG6dHlFb3RepiJakcev+ucyqaZzw=
X-Rspamd-Server: rspam06
X-Stat-Signature: nhiwu1mwzpnttwj784ii37hjsoxnmiij
X-Rspam-User: 
X-Rspamd-Queue-Id: 1C55D180006
X-HE-Tag: 1790129153-731545
X-HE-Meta: U2FsdGVkX18/Kg/Vkg33LxYYG5FfTW2lJYnRuoPWS0cVswtuL3kDHFw5vcADhEvb1Vo6b25B9pZWYIDdtxg5msMEkc5vx+Ks25F5MjONdzAC5k+XHFm2q53vrNHpawxex9WgkGW6Z84zKctxDzO8ZEKn8EGF+1+zA7pEMTyL8jHSNJKvG/GFdHCL4LQ7ZrCAWOhmHGRYPITb9IewiXkHYPMdYBMznhZCTVJJR4MlGvaYhKd8UyIysoZCGsOeQyzfRaiMNVwmvoyajKERm2bRxzLoUpZf+66r4wu797lESOKJSmwN5rldeHRHuHEMx1HcJAZLyd1bQ6Ex553td3sYUu4/PIQogHsAtjtT4rtw9qFxwPe0kStjtUiiIIAWcOtZHG9LPv+LmOQGLrNROaMOUajSk34+jpsG5/qWqNZMeH/NTYsP3Ugok2MJDniDTqFVoderfboskfV9GloQmQxArlRFfGa7KTBCydWX6EKwmYg/qPDp2gF2AH7OKUnvKtsNs8l9A6L2ivIbXt0NkqacVVvu4igWSVCY86hJcv9ej9cWLtPv6a9oe6mGpu7RGa8KZjxCDG4baG5hAutI1XZLuFJnJomwh6PcVtspT9NbWbhqWwXMxcC8XrTHGWaJHTa77V6BpwRro6E8F+zLPTS/W3xX2PNbMnDZyXZ8D4ueK//yMapFh7oX0nyRIXISDyQn3mFHDEBeOW+jmGTFBY/lXWzlxWkFrK9WedDxE4sx1dQAr2NoTzTrZchNzjKQaO52IwnJDl5OYAQXm8aHXfFKLzbN+kLFOA5i143s2GM6EgzZ+2JBew4VQY23RPb50kQv7jKe3666JzGkqMyz2re6pS6MkSmnZohY98Ve2xSwYZUE2ZGhOvD/MLGz3V2hTO4SNvHypZDD/1dJGsFVQ4ZWfXENAg83/E2J4IH0zB9exFZ2XJg4ejQLvOIROZzj1j7c/PiFMasaRaPBkPh7cGf
 bwoHGYty
 oPYk6d/kLwx3AqscKdhGJ9fL+ojS4gGsAQO6wo2KHsIX8g4TPZ2FUzYSPociAM2fWhmNDmg0vc+RbiPkC897H6UKnUprHl9L8/Kfpp1DoUe5+MfMPdDDzL7x7X0SfctMucyrleYtG9oCkAe/0jlON7FaOezFOEzXKZb/XvlClBZPi2tHQflZ9+hYo6+2p6gZjYrfgCs0/0RwxWCheWGL3S49Oc5npcVmY6zB4htvZycmEAFfwOgfqiWT/qZ1/CyNjD+n3Jf9ddub/WVV3xhH4DKjJq75oB6cOAx7rvid/HVfrkIBrnqKIFKVRFKV08aBAVRrf5j5pKcPWjU73dE09GMYhTWSpzp78cgaEvprHFfjN95EPfkpwJlhgw7ES+B5D76M4Fom4MpCkv+9NPii5SeEoeFhxoHp4XhLpmHQtV0/vZ7hgG2abbPRIXY0epmNd53SlY1dgcX5zgxXxljnXzPVbrAWx8Df80EdxZyEvx70KvMi1F5ykHJS+0Kzmc3Zds4dr1BP2k9embn6/7ZJTYyJm9SeDq4fAF8Q3kzZ69umTmj9kjtJg0Z1KTxFvAw8kPtkmgFhgeNMsDrxgFV1TN1LuQP+0CfFQmPGy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The hugeTLB counters added by 05d4532b60e3 ("memcg/hugetlb: add hugeTLB
counters to memcg") are maintained in two per-node places:
  - the per-node vmstat counter NR_HUGETLB, exposed as nr_hugetlb in
    /proc/vmstat;
  - the per-node memcg lruvec stat, exposed via memory.numa_stat.

Both are accounted against the folio's node, and both drift when a
hugetlb folio is migrated, though in different ways.

A migration target folio is allocated by alloc_hugetlb_folio_nodemask()
and inherits the old folio's state without ever being accounted, while
the old folio is freed right after and its free is accounted. That
alone loses vmstat accounting: the target node has no matching increment
for the decrement on the old node, so /proc/vmstat's nr_hugetlb shrinks
by nr_pages per migration. Patch 1 accounts the folio where it is
obtained, so the increment pairs with the free in free_huge_folio() on
the successful as well as the failed migration path. The memfd page
cache preallocation helper has the same asymmetry and is fixed in the
same patch.

The per-node lruvec stat breaks differently. mem_cgroup_migrate()
moves the charge to the new folio and drops the old folio's memcg data,
so the old folio's free right after migration skips the memcg per-node
decrement; the count stays attributed to the old node for the rest of
the charge's life, and the target folio never gets an increment on its
new node. Patch 2 moves that per-node accounting along with the charge,
in move_hugetlb_state().

---
Changes in v2:
- In patch 2/2, move_hugetlb_lruvec_stat() no longer takes the objcg
  parameter; it takes the memcg from the new folio and uses guard(rcu)().
- In patch 2/2, move_hugetlb_lruvec_stat() is moved to mm/hugetlb.c and is
  now called from move_hugetlb_state() instead of mem_cgroup_migrate().
- In patch 2/2, make mod_memcg_lruvec_state() non-static (declared in
  include/linux/memcontrol.h).
- Collected tags on both patches.

To: Muchun Song <muchun.song@linux.dev>
To: Oscar Salvador <osalvador@suse.de>
To: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
To: Chris Down <chris@chrisdown.name>
To: Johannes Weiner <hannes@cmpxchg.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
To: Nhat Pham <nphamcs@gmail.com>
To: Michal Hocko <mhocko@kernel.org>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: hongfu.li@linux.dev
Cc: Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: cgroups@vger.kernel.org

---
Hongfu Li (2):
      mm/hugetlb: account migration target folio in per-node NR_HUGETLB vmstat
      mm/memcg: migrate per-node hugetlb lruvec stat together with hugetlb folio

 include/linux/memcontrol.h |  8 +++++++
 mm/hugetlb.c               | 60 ++++++++++++++++++++++++++++++++++++----------
 mm/memcontrol.c            |  5 ++--
 3 files changed, 58 insertions(+), 15 deletions(-)
---
base-commit: 8d29b5365d528da545c1fe0768a55babadee95d0
change-id: 20260922-for-hugetlb_state3-573f27215d4e

Best regards,
--  
Hongfu Li <lihongfu@kylinos.cn>


