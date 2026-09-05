Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24AE5C624D6
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 16:51:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0529E6B0088; Sat,  5 Sep 2026 12:51:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEF886B008C; Sat,  5 Sep 2026 12:51:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBD766B0092; Sat,  5 Sep 2026 12:51:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD7A46B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 12:51:17 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5B4F11C1F6B
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:51:17 +0000 (UTC)
X-FDA: 85180298994.24.4B4ED79
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6A53040002
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:51:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HX1nRK8D;
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788627075;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hGdYscbwYaZ8j/KNlo316T98ZnNplIe0XQHu2i9D3So=;
	b=m8KNakFhXKELH13NM6afj8euKAn/WlTHDaX5Y8cOIu8F4Z5QqJ9++6JbHiSb+elyi3+Hqd
	86SNOh/SH653taR3QXI03KLuo4yO9L0BQfonJxgoQ3r7deG80YKkqhwPDv7xEQNqmc+4sP
	hrQxsL5HU3btdIhpqN8mfWEuf5ZUK7Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788627075;
	b=PTs7vbDeRQNkjDqQ66N1M/zJbV6ZmOSYc4kUPHzCVzc6kuWu0Ze1Y2ivli0J3lKiZdZnS0
	DFUWRYsLkLN+bVKBzKdgqZZRyTPOhaVJi7c4wMBUxzF95ODKhXGcGnRUprsAs9u4do3XwR
	EnMhjkgsL+npM2qRkWGy1NRMYVh699w=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HX1nRK8D;
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4BD874381E;
	Sat,  5 Sep 2026 16:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 21C4EC2BCF4;
	Sat,  5 Sep 2026 16:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788627074;
	bh=dskzQeDGxBtirZ5ohMl5zEVdQosEdst7khpwTL27U/U=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=HX1nRK8DRRdhEB8JADjUNXQ9wgUM2sxu0B7FBNFJrho3d+Os79D+Fnw64sRVm/+ms
	 /hx+GP2r4U2uyMCFemTy1BgAgRZaDFW+Xu/irXLuRe4LN6824RQH2Wu9BB+4YyPXtl
	 p6l2Rl/pJHG4y8jAZZF4WnFPOYpmYmbqbCFi9cKIOp6XVncjFC+qcAc76Kin3oDK4M
	 37uLuVIpGk2BflXSS/o0vCNPyYMT+4Ie5ZOXLjPEdaZR24jNCqcZSqKflgahS9jNLy
	 aeegFQEkg4ER29m0FFny+CQ5wp2b+MF1N5unCC74G2AklYGl4hyDaC4jP4vGIdjvQW
	 WlWunQuVL5/Zw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C35AC624D3;
	Sat,  5 Sep 2026 16:51:14 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Subject: [PATCH v6 0/6] mm/mglru: clean up folio counters and flag usage
Date: Sun, 06 Sep 2026 00:51:05 +0800
Message-Id: <20260906-mglru-flags-cleanup-v6-0-9aacbd77d4ca@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/33PTU7EMAwF4KuMsiYoTpP+sOIeiEVqO52gTjpq2
 go06t1JhwVFU7F8kv09+yYSj4GTeDndxMhLSGGIOZRPJ4FnFzuWgXIWWulS1VDLS9ePs/S965L
 Enl2crxLRNOgdldZ4kTevI/vweVff3n9ymtsPxmmjtolzSNMwft1rF9jm/m9YQCpZU9uSQ0W6x
 teJI3KcnnG4iK1j0TtFm2NFZ0WBMlBoAOP4USn2SnmsFFmhxgNW1ubH60fF7JQCjhWTFU1giVh
 RxQe32F+lUfpYsVlpqK1KoKpq2P9V1nX9BtZJkdHiAQAA
X-Change-ID: 20260818-mglru-flags-cleanup-cc49cfad654f
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Ridong Chen <ridong.chen@linux.dev>, Lian Wang <lianux.mm@gmail.com>, 
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>, 
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788627071; l=3580;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=dskzQeDGxBtirZ5ohMl5zEVdQosEdst7khpwTL27U/U=;
 b=c12Fl395Bz9yonkrDDvw0bsBMU4J4OnfMbYdVzc+uUwH1FEGqU5ysTHxGqgnSRDcgtknxkfzX
 YAvjHxzMlViCZNwTdVvDMg/KXp8x21JoepotrEeSoxF5dZeuTCH5m0k
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6A53040002
X-Stat-Signature: h1sf4qtrndxkybosx9e4groq8wdwrf6a
X-HE-Tag: 1788627075-944181
X-HE-Meta: U2FsdGVkX1+vtn7RW6IZRXKopQ/t3fUYrISnyvGP7JM7BxU+lUINHb/S4cP925IRDcoX6ZrBsLFI7sfX3Nsm+AwtFK5WYUzqgUzvcOv0dKAwpF4GTD8bIaghpmiTokpnCLR5bHmt0jjjdmlBLpHjG79sRr/jcEbZ9zfn/kb+whk7OCnx5ClK4LgSCJtWbV6R2ncyEvWu4VZX1Lj62Dg+NnrNY65aB+0Jjjn1DDAMYNmblVi5e/oquslxaw7KfDoWqB1RZetkMNWvfNHk1WlJTZgvCdnw6hQ082kmsgiF83nxkrL3S9wVxqW5Orv6+fHgG7B4rGKmOfRWjy6r2mti9mnklori2Xeesc2r9VjDb3DXyh6kaMi5Zm/AKZZ1xLxiC7nmgGKHWJF5yDg2l0y8/caEoNFqnJ+A5kwGCWqSEP62kUD6oUqs07ffiQchTNQocbmLKtiAlBFbr2+7zpX/P2Krv5rYS3111EATUflue6wDayknXmyKIYWOdvGWDZByBE6i3oovQe8eD58mixSUpvE2m5zYgI4/fyzRFdYbJCenot8CXTpbLby7yj0QiMjK411Waen+8dVeCMxiAGvCqFqN/+OlZpR8KouruO+CJfJSXxz+rzCiVG77bhWlds8JmCHdhnoD8344yt9HjLxC0BSB+f94X7U3QRNpKxWzbX3UxoqDNeKoyuNbdcfVH5pmlKLoFoifxZkIoq7nol1lpbpXwuttoJ4IJ4btPOmVDFSwUbv9hd3mE+a/TzRPmzB+ejFe59O1lNWH8Be8Vxl7JfJx5G9+PJOVzg7mwxC95wtbh0qYso36ZYRJAclbJpNt8h+J4zHxmTqLPvCKhkxBzaS2EnKXeX43l3BF+9EW4Ng5T7fLj1dvJix0uMtAhmPfufjthbd7PYW8ny8cF3rwATXgYTNFviwImg3jywiMPXxrJUMGkmEUi23iEUhzDe7C3HwsjrjiqxyNpUJJrHe
 shAuPS0H
 +QoaOMCUYIIZhgLek9WXPevty3rM2u8n3+HqEMvaDza3snm3e0/8oUJ/jac7Oq6GqgXvWMxrWVUyp1xTBA41eI4e9O5ptJWvIcmCUWxf9IUU+iTQaQq5bIl1OLmj69yAv2L14qjK+VS1x3Gcz+NpV73JPeoZFyXRykZ6P/zRNCPyFDq7QIdRuhLtGWfOeOQfB+goVDA1/C0Z8XzwbRjLbBLVsinwnXFjsc3d/FIXHcfWKuwtfq3LvYBRhnSFWNXQ5bXw2qY9K34gLetK6KQgMorjF5kht3N6TQdv3LYsYEDErxyg8u6DLh8hqSSi/eJyG9Bka/Af5b9MIs0I1+axqTuzJYiqLFQ1j+o3uib1lD9eJeX4wnN8dgl59pYmV6zqimIgTiod7RkBdK+Cy73d98aQheBKFxKGguR4afUmKBCvEzypouwW2RU+PplDOM7NVHRt0skOkDciI7Z8d+kStqCRoySSXk/llUbF7BwKPlwEzxGQ0aYhPir3lLF6kzSa+6CWC7cWkCqH9o+xOKDChwLLk2krpP1oLjjxsY2cdqDw+LBM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a cleanup series separated out from the MGLRU-FG series [1]. As
that series is getting too long in following updates, seperate out the
clean up part for easier review and merge.

No feature change is intended, except one bugfix. It mostly replaces
the open-coded bit operations scattered throughout the MGLRU code with
new helpers, with proper kdocs, sanity debug checks, and hardens a few
MGLRU functions.

A subtle generation counter leak is also found during the refactoring
and the fix is included.

Also collected review feedbacks on the cleanup part from the posted
series.

Link: https://lore.kernel.org/linux-mm/20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com/ [1]
Signed-off-by: Kairui Song <kasong@tencent.com>
---
Changes in v6:
- Rebase on top of mm-unstable, also mergable on mm-new.
- Collect tags.
- Link to v5: https://patch.msgid.link/20260902-mglru-flags-cleanup-v5-0-9db761d779ef@tencent.com

Changes in v5:
- Change atomic long to plain long in patch 1, and adjust commit message.
- Rename is_file to type, and avoid touching folio_is_file_lru in patch 7/7.
- Link to v4: https://patch.msgid.link/20260831-mglru-flags-cleanup-v4-0-2d15dde0d7ee@tencent.com

Changes in v4:
- Rename lru_gen_set_flags/lru_gen_from_flags to
  lru_set_gen_flags/lru_get_gen_flags, similiar with lru refs helpers,
  as suggested by [ Barry Song ].
- Added some comments to cover concerned raised by [ Barry Song ] and [
  Baolin Wang ].
- A little code shuffling and better sanity check for concerns raised by 
  [ Ridong Chen ].
- Collect tags.
- Link to v3: https://patch.msgid.link/20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com

Changes in v3:
- Set PG_workingset before setting LRU refs bit to avoid any potential
  under report of folio tier.
- Migrate folio's referenced status before PG_update so lockless readers
  won't set stale referenced status.
- Link to v2: https://patch.msgid.link/20260824-mglru-flags-cleanup-v2-0-0104132114ae@tencent.com

Changes in v2:
- Dropped the redundant LRU_GEN_MAX macro.
- Renamed folio_migrate_refs() to folio_migrate_lru_refs() and reworded
  its commit message to describe the referenced state being transferred.
- Rewrote patch 6's commit message with a detailed analysis of the
  anon/file accounting race.
- Dropped patch 7, it doesn't really fix anything, and might be in
  conflict with other updating series.
- Collected Reviewed-by tags.
- Link to v1: https://patch.msgid.link/20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com

---
Kairui Song (6):
      mm/memcontrol: move the lru_zone_size sanity check to the reader side
      mm/mglru: introduce helpers for manipulating gen and refs flags
      mm/migrate: copy all referenced state via folio_migrate_lru_refs
      mm/mglru: move max_seq read into walk_update_folio
      mm/mglru: use explicit tier range in read_ctrl_pos()
      mm/mglru: fix potential generation folio number leak

 include/linux/memcontrol.h |   9 +++-
 include/linux/mm_inline.h  | 115 +++++++++++++++++++++++++++++++++++++++-----
 include/linux/mmzone.h     |   3 ++
 mm/folio.c                 |  19 ++++----
 mm/memcontrol.c            |  18 +------
 mm/migrate.c               |   6 +--
 mm/vmscan.c                | 116 ++++++++++++++++++++++++---------------------
 7 files changed, 188 insertions(+), 98 deletions(-)
---
base-commit: b5529903123d9535bcf74386c1f4e185e8632dd9
change-id: 20260818-mglru-flags-cleanup-cc49cfad654f

Best regards,
--  
Kairui Song <kasong@tencent.com>



