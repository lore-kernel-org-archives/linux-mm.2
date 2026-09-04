Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5665C624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 03:54:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF9876B0098; Thu,  3 Sep 2026 23:54:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD15C6B0099; Thu,  3 Sep 2026 23:54:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABEF16B009B; Thu,  3 Sep 2026 23:54:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 843B26B0098
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 23:54:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2A17E40702
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:54:22 +0000 (UTC)
X-FDA: 85174712364.20.A2D6BE2
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id B828D40006
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:54:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=H1DRkfKo;
	spf=pass (imf01.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788494060;
	b=qq/8SZsSzOwYLxoD4Kd9av4wWpfSbmIgukJwz4/HzOJ0IIIFV4iZZhDanYz6K3cZknRJhk
	QwlGo2B3/eod5elarXnFGZn51N8mlQK8jApyTJVrKtwL5NqEilXX2pfIEs08t3fub4hYFe
	lfZ66B2+Vn4uqzyDQnBmSFvK93uzSeE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788494060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RgILmAj8pZmVgzIjSER8ulyJ/VZ7FZsMUaib2i4Gc/c=;
	b=zmjOhbRStAbPw9Jvu5aDnaYHb7HSkwGchWU1rNMpPFWVe0td3fa9fEKGB8T1yPLLGmPJDa
	/0EA2shgJ16XdX3wLUDgjfWkRB3XuY63YPthsAHYvlLeWnplJMMKbujYZfIyyBYcFflcrM
	7CsaR4cTgyc5+xbJV6awtPuqUBZdEsI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=H1DRkfKo;
	spf=pass (imf01.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788494056; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=RgILmAj8pZmVgzIjSER8ulyJ/VZ7FZsMUaib2i4Gc/c=;
	b=H1DRkfKoPKGu6Emdmr2jAdGSCpJI8BtCHVoWSSjmHgm84Pog15d+5enW8ZvbDFFUnpEDsnC2h8SA5pusEafE5NAsrZVpLOT9jeBFeiBqZ6l5D6Hml1GqpbfrBjqzRkoIGfWQavhSkNUmDjF3voSHv3UM5XsuZyiuKMuvZjRLH4g=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R791e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=29;SR=0;TI=SMTPD_---0XAHc.dA_1788494052;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XAHc.dA_1788494052 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 04 Sep 2026 11:54:13 +0800
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Xunlei Pang <xlpang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Chris Down <chris@chrisdown.name>,
	Chuanhua Han <hanchuanhua@oppo.com>,
	Kairui Song <kasong@tencent.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qinyun Tan <qinyuntan@linux.alibaba.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] mm: memcg: settle memory.high debt after THP faults with non-blocking gfp
Date: Fri,  4 Sep 2026 11:54:06 +0800
Message-ID: <20260904035407.4098627-2-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260904035407.4098627-1-qinyuntan@linux.alibaba.com>
References: <20260904035407.4098627-1-qinyuntan@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B828D40006
X-Stat-Signature: eqftussuutk6n9ptcj5bpgict5ua8wuu
X-HE-Tag: 1788494058-942587
X-HE-Meta: U2FsdGVkX1+JbV6zfrVpf+2SwJTRh1aR5jNuMhZ2cVHdwdQX8u6nOZ7Z7VPrYItgyt+FDTm/s6NoDkAWnLmHfw+WQMIyE3mYJ6uEJ+M7Xni4TObRwzLLcWtX0QR+/Kg+URlv2OFtIbPkB2EXU1Y3zfGO/z/QAd1tJNMVyw5JfJWwKMaK//8hdnw+f9FoNjb/RwCNt0zM4lYJr1ytM6zpT984JxC4mOqsA9s02Qre5TnrT0tCPtmQXyiQdVCjnFusDRmbXq2DtV1oP7RZAvJ/yC35ojrdrH4IpCkJYxd4yzmaYSYgEQUQaUXX/yFUds68t/nfKIcPKqbaNRp7O2dfTGl/jOyC0oUHzzRzkOU3oR2FDE2yvo6YBgUeoqDUjLAExVRXE0qCcBI9z4Q0jYIw508+43MlrEeQrrKjhf1W11WpRmst7RjdwqGM5mIXp+3SaObEK6OXra2p22eQWxI78DWk2p+n4uVEQyheV4f8ZLC4QflH+kWesQKnSoH6NMZrzHvxkxPhwQoBvNQn3R5fBHV7WDseLVA3OIV80pCzFDDDA85e+parZQV4D4dGJZ0emL5WdnX4aulpFAFYI9p860mVj4QrYdoLpfZY5O7cuTVJUc4XM0P6V9yMFyVr3eVPX1lvCZp2W+mCPLbj4sHFwUQ3qhhEHWawPyO46Ap+skY3kIV92690yLA+mzuNpCXhCDSPODOJ7HTSqNue1OTqdW9JugO7NcHPi/v3Aaf3216qqOhEgVBVg70TjsaD7mofXv2IoWqgzYi0W2kYr9VqTq1R++B1RYwZjUn4gUV2+9n6wnEv3J/XrAsMXhHerC/+QKLiBp3Tf878T9XUW1VD67fzQ46Bv1VzsWdqaB31znKkjabJ72S1yW08FiBIR0E0s2VxDbxHhRLEQnVXchl+jHGLrCpp8SBHdAQizBu2+YWSzxzorg6yNfaIItFExPoICUciqz37B3k0DRtqOkv
 yAQHKIwJ
 XNpFhxOnR5nLRjrxruIg6mCwSUlxDH/T5l/nX+o8FGK757kb4rRa2FJy10ZasIWS+sJC82VZdrz8ERzvqmO6AQ6ccko0Towcm/efaE7DbVDUPbGFPnPwNoWzT13tcY6K5+3VkEwD0NHa5x4lassbGZMJ1eZk9RJwO7nKHkHmS4J3xd9cQ9+jpFtCjANWOqkWOflySHQV5onQYoqZs6p7J0vhyCh3yHAkMbmMqbiqvH8IIKG8X1VrbN60PlpuvIJ1JrPunuUiS6V/TduSqOCx1UB2nFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Anonymous THP faults happening in a kernel loop that does not return
to userspace -- the populate loop of a single mlock() call, or any
GUP-driven population -- can drive a memcg's usage from memory.high
all the way up to memory.max with zero reclaim and zero penalty
sleep.

This defeats the containment memory.high is supposed to provide:
above high, the documented promise is that "the processes of the
cgroup are throttled and put under heavy reclaim pressure", and
userspace OOM handlers (oomd, Kubernetes) rely on the high..max
buffer as their reaction window.  Only after hitting memory.max does
the non-blocking charge fail, THP fall back to 4K, and
folio_prealloc()'s GFP_KERNEL charge finally restore throttling --
by which point the entire buffer has been consumed.

memory.high is enforced at two points after a charge succeeds:

  1. from resume_user_mode_work() on return to userspace, requested
     via set_notify_resume();
  2. synchronously in try_charge_memcg() for large overcharges, added
     by commit c9afe31ec443 ("memcg: synchronously enforce memory.high
     for large overcharges"), gated on gfpflags_allow_blocking().

A populate loop does not return to userspace between faults, so gate
1 never runs.  Gate 2 is defeated by the charge gfp: since
commit 3b3636924dfe ("mm, memcg: sync allocation and memcg charge
gfp flags for THP"), the THP fault path passes the allocation gfp
from vma_thp_gfp_mask() to mem_cgroup_charge().  With defrag=defer
that gfp is GFP_TRANSHUGE_LIGHT | __GFP_KSWAPD_RECLAIM; with the
default defrag=madvise and no MADV_HUGEPAGE it is plain
GFP_TRANSHUGE_LIGHT.  Neither allows blocking.  This is the right
policy for the physical allocation -- a THP is not worth direct
compaction, fall back to 4K instead -- but try_charge_memcg() also
interprets it as "this context cannot sleep" and skips the
synchronous enforcement, even
though fault context sleeps just fine (it holds the mmap or per-VMA
read lock).

Fix this in the fault paths, which know their context can sleep:
after a successful THP/mTHP charge, settle any accrued over-high
debt via mem_cgroup_handle_over_high(GFP_KERNEL).  This reuses the
existing throttling machinery (reclaim + calculate_high_delay()
penalty sleep) and is a no-op read of
current->memcg_nr_pages_over_high when there is no debt.

Deliberately not changed:

 - The charge gfp itself is kept coupled to the allocation gfp, so the
   fail-fast behaviour at memory.max (charge fails -> fall back to 4K
   instead of reclaiming or OOMing for a THP) that the coupling was
   introduced for is fully preserved.

 - try_charge_memcg() is not touched: gfpflags_allow_blocking() is the
   only signal it has, and it must stay conservative for callers that
   genuinely cannot sleep.

The pre-existing selftest test_memcg_high_sync, added alongside the
synchronous enforcement by commit 6323ec54b450 ("selftests: memcg:
test high limit for single entry allocation"), readily reproduces
this: it mlocks 200M against memory.high=30M and memory.max=140M
with swap disabled, and expects high events with no max events.  On
systems with transparent_hugepage/enabled=always it fails without
this patch -- the population bursts through to memory.max -- and
passes with it.

Fixes: c9afe31ec443 ("memcg: synchronously enforce memory.high for large overcharges")
Cc: <stable@vger.kernel.org>
Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
---

Note for stable backports: mem_cgroup_handle_over_high() only gained
its gfp_mask argument in v6.6, from commit 9ea9cb00a82b ("mm:
memcontrol: fix GFP_NOFS recursion in memory.high enforcement"); on
older kernels the call sites take no argument.

 mm/huge_memory.c | 8 ++++++++
 mm/memory.c      | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ced400f72d43..543ba4a74dc3 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1329,6 +1329,14 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 		return NULL;
 	}
 
+	/*
+	 * The charge gfp encodes THP allocation policy and may not allow
+	 * blocking, which makes try_charge skip its synchronous memory.high
+	 * throttling. Fault context can sleep, so settle any over-high debt
+	 * here instead of letting usage grow unthrottled up to memory.max.
+	 */
+	mem_cgroup_handle_over_high(GFP_KERNEL);
+
 	if (folio_memcg_alloc_deferred(folio)) {
 		folio_put(folio);
 		count_vm_event(THP_FAULT_FALLBACK);
diff --git a/mm/memory.c b/mm/memory.c
index 8b0c2c735d3d..24cbf2a26905 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5362,6 +5362,8 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 			folio_put(folio);
 			goto next;
 		}
+		/* Same reasoning as in vma_alloc_anon_folio_pmd(). */
+		mem_cgroup_handle_over_high(GFP_KERNEL);
 		if (order > 1 && folio_memcg_alloc_deferred(folio)) {
 			folio_put(folio);
 			goto fallback;
-- 
2.55.0


