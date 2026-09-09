Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85667C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 09:44:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77AF06B0092; Wed,  9 Sep 2026 05:44:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 724C16B0093; Wed,  9 Sep 2026 05:44:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63A966B0095; Wed,  9 Sep 2026 05:44:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 378C06B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 05:44:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8689612016C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:44:25 +0000 (UTC)
X-FDA: 85193738490.29.26FA1B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9328A4000A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:44:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aGCVbomS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of devnull+linuszeng.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+linuszeng.tencent.com@kernel.org
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aGCVbomS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of devnull+linuszeng.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+linuszeng.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788947063;
	b=Z02p7rcO2yHDivmemgLSjlFNMXuMOawbkgbixjoM/VqZ1qQP6ITPHjWtZanHs2unXP7NEd
	rCUdl1f+eKOTV40/xMBqEvxI9+stiaQD7RqaijNC9vLkaYkf35M4o7tX4VdOLhTVJZjn9j
	4dEIDoohkzGTdQ0zMlyfmqKWu9y0KwU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788947063;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ceF2U38uXuHKPgJcmUxfM6+scb+3tzvHBYKiqk50Z4c=;
	b=DzxV8g+UPclXr0lQ9e8yzC1fZYIZpuRilh7Fxeyo4sw5ruIxLXZkBDEzdhs9yLteu4Ed0m
	PYyW7KZSM6W4Y/RApZhlAVjKGKcy2JIAEdeP8iGKohp1yvEnN1Z3IxKVaus4wuPwwQBD6h
	gpLeEvndTBV1H1n4BCCkyXB4mrwCaNs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AEE2240467;
	Wed,  9 Sep 2026 09:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 84301C2BCF4;
	Wed,  9 Sep 2026 09:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788947062;
	bh=p/FFus9bKe5tMEJQcywlfhVh8H2JBkhG45wwhRpVejU=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=aGCVbomS++Z2D+pnl6D6I/WvraSgdcxXB1PWnieNuY/YFqXVDyDvx4gwD8NdKxola
	 gKTEE8wsE5zssmRlKcXpsHX7LI5eMEdSl27dwgmRx4FLy+falJR15j4VpoCOJzQdK+
	 nX2QkvLvz5aInYezpjesG2lqKKRw+C8f94FDj//QntD8/grEncLgLKvxBb8LgZ5eyg
	 0O5jLZYx2yNWn5XQb/SQaTjaefeiNOinx/XKBmUpe5MCFMb9YXQTu0BUz8Pw27o38Z
	 YJfB2EYHFS5rGI2WFHBGRmGDzGAcKiVnKPmF3J7wBBNBqGDYpNzNZclxeia/ptaKi0
	 RGm2ekaof4N5A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E507C79FB6;
	Wed,  9 Sep 2026 09:44:22 +0000 (UTC)
From: linuszeng via B4 Relay <devnull+linuszeng.tencent.com@kernel.org>
Subject: [PATCH v2 0/3] mm: page_counter: move hierarchical protection out
 of struct page_counter
Date: Wed, 09 Sep 2026 17:44:18 +0800
Message-Id: <20260909-descriptive-name-v2-0-d7dd7c099049@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHIqoWoC/32NQQ7CIBBFr9LM2jFAkwquvEfTBcLUzqK0AUI0D
 XcXewCX7yX//QMSRaYE9+6ASIUTb6GBunTgFhtehOwbgxJqEEYY9JRc5D1zIQx2JaReK9vP5qa
 9hzbbI838PpPj1HjhlLf4OR+K/Nk/sSJRoNRKm0G6p5D2kSk4CvnqthWmWusX0JWKTLIAAAA=
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788947061; l=4455;
 i=linuszeng@tencent.com; s=20260909; h=from:subject:message-id;
 bh=p/FFus9bKe5tMEJQcywlfhVh8H2JBkhG45wwhRpVejU=;
 b=hJTwX6JHH/uUOp9uHufT3TwNsMm+bWbW8cQjl9xqdJC3KPtmdS0V4dRJcPJJbMw26XXmcfYw6
 f4kAsSPB1svC72rIgJlJBLAxwUHAIMyEP1iKgbuGtVIe8pJCi+QT/mm
X-Developer-Key: i=linuszeng@tencent.com; a=ed25519;
 pk=6K54xRzYIRWqatrAPy86M4E0MsI92BVJBhXwz5NdC74=
X-Endpoint-Received: by B4 Relay for linuszeng@tencent.com/20260909 with
 auth_id=1017
X-Original-From: linuszeng <linuszeng@tencent.com>
Reply-To: linuszeng@tencent.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 9328A4000A
X-Stat-Signature: oh8k56pqc33yj5jm4awfiphck6f1ajou
X-Rspamd-Server: rspam01
X-HE-Tag: 1788947063-138375
X-HE-Meta: U2FsdGVkX19WvDIP/GBCZ/n94NEQp67mZiVDGngdEFTNbPq1PhXxl8L9Vm2Ph3QLORGjJv3Ga7ouKe6kzJd5nPyA/mrAytzUxbFSznwqcxc6TdjRgf7b5SNPCr3yyL76sJNJmU1zEnxUaxywOh53gesMA+qpDXGje1W2OczzMNWlL2GsBpinzRYBowsqKQEIZzmL2TFE2zLEuss4jB16DrLs6mxygYDbla49dcwK7oRR+kJHVZ3+GQRZv8tLzcM5AXOhJezPd7tGu1pbBkETP9PIBaaIK8XrVMBy+xV46olyHf7MYDWF7nyGBGFIl7T7DvKiF4lxqiy9bMo2qSeFVLUvg2dSfunZFrLqW4orVtJYM1oIgyV0V4mhuVR/AbJ2uUW9Zqqr4FvNItv+8g1+CbETthNakqjQAHHoHVTt1mOJpTftZLjdDAniP4qiTnK5y+pD1DdjHRFozGFbBd9lgdCmzdylv0JQWkL9vdw0ufh4SqfDEX3DcUZfQluI3UP7oMf69193AqOYCzy3mtoM+EI1KMbtmejrb0u3etOPO21p85kt3lmUDZJuuyUrA2yxqjqcGp41V1MI4Qxiz9GFCOLVYRGEv7CQaoOqyzh702OD0zxggQqzauYnrTBhHRYHPNLzv3o+PC7X1/JQtRwBxT2pfFRY9P4Z02jC+NgDrcXuB4yOwBQigcH78FeR96Ley1+ayfWzoqT9FTYriHHGycxZM/+0Y7eCI8lHoun2k7JeHqI28xEVwE4mR1RNRXOqowh6M/AIAtAcT1osc+O4CS0/rNi0HPy219u+yFutKsO/Om3E3PhJYrg3Aj8zProL70nolQI5vb52vacYF4eL2flQ3pInv3Uwn8RmBJ9Oor0oTZEmu2FvXXlIVSgedUe/DonLhIF8PxWqtRezBr/93e5uWa6OCofhPeRORl+S+rk6Y6zaq7nazzVJg9XdrW20eSm5/QPfBZWFP8RaJWw
 ZZ9r/QUb
 RWMzaw+HEDIQGEM4xnJnhR09lPk3EHgLabvhPakseOkdHBK9xcm8HYDItTsfjy8wzHK5iraQHOEWLH9kprkX5oXdi7H+2YbHlsjmjeSqBKKKZNyi6Bg1aZCWwYjtGzXvysrqgpggt59Hm+uLv/8T2kAvM20mKRxW09yadW82ZjJXldEkOm3C2QunnmW+cjB6nB0J3R8CKPkPLvknj6JOU7lkLXziG41JyUVKZD2z1RtXSRc1FJqIhTKXet1G5UEDZgNEExrQhEMwzwt6HjR2G5jVBgPmzr+axjdBEJIuQ1nqYWftiJYh7+lImuivN48pV+5jktsXvTd2EzQuKV/PcnI2KqIB6Nq6JlrGik87XMDWeCuHujAxKoY7XKRpbwGA1I6gl7iM6Lqa05gx8O/S7BS415tHWaXeLnZ0I8TYfuQ40JILQE+Kd+aEWaKCHDRdOZ5T0VDb6eCRNdcmB4H63ANFmFdZzG707FDkafwQBY8nuflCdlO7UqzChySSMhv2bn6+mCo6/aEyR5unO81z6QWTdCw==
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
Changes in v2:
- dmem: fix up prot.parent in get_cg_pool_locked() too, so bottom-up
  created pools keep hierarchical protection.
- Drop the orphaned _pad2_ padding and its stale comment from struct
  page_counter.
- Link to v1: https://lore.kernel.org/r/20260909-descriptive-name-v1-0-1828961cb01a@tencent.com

---
linuszeng (3):
      mm: page_counter: add page_counter_protection struct and init API
      mm: page_counter: track protection state in page_counter_protection
      mm: page_counter: drop protection fields from struct page_counter

 include/linux/memcontrol.h   | 15 ++++++---
 include/linux/page_counter.h | 73 +++++++++++++++++++++++++++++++-------------
 kernel/cgroup/dmem.c         | 21 +++++++------
 mm/hugetlb_cgroup.c          |  4 +--
 mm/memcontrol.c              | 29 ++++++++++--------
 mm/page_counter.c            | 61 +++++++++++++++++++++++-------------
 6 files changed, 133 insertions(+), 70 deletions(-)
---
base-commit: d118502628f8b673be9023db8bdf878f64a7ed45
change-id: 20260909-descriptive-name-e382a3f978dd

Best regards,
-- 
linuszeng <linuszeng@tencent.com>



