Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 007D5C61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 18:43:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF3276B0088; Sun, 30 Aug 2026 14:43:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB6656B0096; Sun, 30 Aug 2026 14:43:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A307D6B008C; Sun, 30 Aug 2026 14:43:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6D3A46B008A
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 14:43:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DF41FC0330
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 18:43:40 +0000 (UTC)
X-FDA: 85158809400.19.69A0F07
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id E5A7A120004
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 18:43:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TgJLfl0w;
	spf=pass (imf29.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788115419;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=P1MRy+CZnfGmLLPjy6iJGXdt0LkGmnRtyh9AqvECqzw=;
	b=HF21ceTkur0BDp3znV9vBLpVx31TwigG/xa/cxK+vHGT7XgtTYdPX0Pl1MJcmjSN2zck4r
	kZH9cwWG6E7thObwplmd3WmN7DQ36hVTOLmcLZA+osv/jXp1A5sgvF+ilgYdLHgPxKUrgm
	epjiZzRtLkhHbWGOi8qW/crIKKZd7wk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TgJLfl0w;
	spf=pass (imf29.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788115419;
	b=Xt601mKVJ1Z8QaWAkHowTOwBTauRQe9nw0jTgTqNka3WGwmBRama9Iu30QcxGpQqiB7blX
	q0fqvjvK90DWVFZ9TC6/tG0lx4ShrWpw7qJM57Xy3makb2ljzYRlQNhKDKp+LyEz9Lg5uX
	uGVmlEx5aWfFTVLHBbGZEZ22k31iddw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D25BA4378B;
	Sun, 30 Aug 2026 18:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A51C3C2BCC7;
	Sun, 30 Aug 2026 18:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788115417;
	bh=r8MlvVN1Hrr7nFXT/twKw1mcbQBSoK+7gb7Pqz1TrzU=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=TgJLfl0wz14V18Wx5yNmcZ5PnrAtKMHEiuZabADBTR84kMn568rjpEjb0CWTm9w1S
	 SLO3wq4XrDirTVtd+VwgTvfMbcHmOr6376z2QqNHdnbP4YtXOn2kiOQkommp5OJMNv
	 exKhqS0LmhzA4BN+6D4W6U2YOKJ/dqIz4yhd1U7YqNlovHNWMjWJV+glUOT13m5/K3
	 RQtl1gGHX4JUUhe9H6HlaRQ1orAXeq9zOxAQ73w6MIFQqdR2WZKluetLU0H/633LR6
	 d0Jh9Rm9WjdKhKzpvvb6GV6rLW2HGIoV/kj2nf2sF2grWYNHKLbHa9aD/JtGoCbyBc
	 jj741jNX0OjVg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CBA6C61DD9;
	Sun, 30 Aug 2026 18:43:37 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Subject: [PATCH v4 0/6] mm/mglru: clean up folio counters and flag usage
Date: Mon, 31 Aug 2026 02:43:30 +0800
Message-Id: <20260831-mglru-flags-cleanup-v4-0-2d15dde0d7ee@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/33PQQ6CMBAF0KuYrq1pS8HqynsYF2U6hRospgWiM
 dzdghuMxOVP/ryfeZGIwWEkx82LBBxcdK1PQW43BGrtK6TOpEwEEwVTXNFb1YSe2kZXkUKD2vd
 3CiAPYLUpcmlJurwHtO4xq+fLJ8e+vCJ0EzU1ahe7Njzn2YFPvf8LA6eMKlOWRgMzQsGpQw/ou
 x20NzJtDGKhCLmuiKQwziTPBOdS46+SLZViXcmSYg6Wwz7P0+PqWxnH8Q3x40MQVgEAAA==
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788115415; l=3114;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=r8MlvVN1Hrr7nFXT/twKw1mcbQBSoK+7gb7Pqz1TrzU=;
 b=qvvnolvYWKShhvmr1tUm9SVdTo6PBNA1ZlhFYB/9rJqU/D1nqXkHACF4VUiZsG7q24kwA1i/q
 AoyKSNXNaiDDBhZ61n6ZzFVKQ+U6TYuP5GRyLpe7fIoC7KeswtgHzkw
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: saehawoeqmit7b9qpbqdm1k1ubmakyct
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E5A7A120004
X-Rspam-User: 
X-HE-Tag: 1788115418-671292
X-HE-Meta: U2FsdGVkX19PysQGxYBvCZYsT36QCH8inpTMh/hdOErD9vS47R+WA7HxJfdj4zJkpZblb3FvSVywCDBIQuSbBTcE0cJ4HNvvSXNJ4TPLPWupfDCdwTI65Y5umcjt7NJ0EhnW70PJYeK2LfyvCVce8E8lJmUnRu6sth9TrrjO2OgUcYbqUQehsCDsGB+AWN/9TqBxGVEei890EQIJRcVyV3X5ZkYCgXuE7/yRWgOTgZ2NR6kUIOc4Yh34VlYW5fvdwG+AeEg6hUJvvilNprR+bLnBN3NM2vCunzZtCS01oIf7OBI99U9jImS4xfBE/gLC+9lL8zBixkSN0vWIJRcaHnsDGiySS9FbvX6M9Yu6y1xjlSHmAztzalf/Wk4swja/R6Hu/pD0OSHWKx3wkrt+WLAEwbxjxFUu31TClbAHznmzIWi5PwnoYPyRpgNH1OiVX/WUoA8YTmY653cBlXUVVexJxFO7FpNSJQv9HbbZuClQaKP/KQvZ7x8y7YrzIaZJ7Cx3UG6+KZBs3m8HvpkpPbt2+58cKc5hkHNqSZJELMIBJTf8tz0j63IXPGTX+JmfjM6WcttI33m8Pth59Ak5a2IXYvoB2ZhYODRQp4+rSC3z5gIlSVrHDBbd6U95UpxnuuDTdJIpjamUuqFGgkewebVcZAegS5ooKtkP9ImMYIzkpapW17tiy7zt4zKWzxMxljnTIJC4hE9N00kDxjhq6cce7cfc3OkWRrer+1PF2XbRs8I2CQVNlttfzOnIaw84J7VzeDtcCOEBjev4/DgWVau+LOIX9lWqw8SAvxBYHCQD1C95SwA3/XfyIKNahe2/IkMUcXIrjMm45//yuy1F7+XEuN4QXJaIYhmtcfqxWLTcweeiuARhoRxzR6WhdzxXaZZOE4BfIHJWxSnM/xTwuDzmceO894Z3G4VqANSJQu52woRMpPKW0wVbpTpkocH81ZJ5oOrVFlxO232Toue
 dJrOQ01b
 OZLE9e4NHWqJiStC9dOPnkwfyx0ebN4Cr8qLnB9c/gdrs6cIepEvBp5b37GlprBUmcmcbk34kBQOWPgMOReL87uFQlaR0zoUMkbpUXxrEzhK5+wif4C/2TFuBZyDVTyEJuyhrZ/gpjSpX/oi0uSyXqsHeD8rOEdLkCqQXakjIwsuVw6TouxlL7Ej7MwuJjr5WVtPlNHKb92ZOH4cwhrjDMfvhDkzw+S2fW2qRfJenJ5JIZDl7sK7me0ZyC9X/zZabeO5m2gJ2oFktZ9ikURJig3d49FbdWsc0fnwJxceqWSLKG+bRk3fGjBEGdvDjQBfxU+V7o6iKh6U8rTUAn9sR3xywnRr/MFro2+7Z5f1hYE4xUstj7FQBfegr7xFsR4jTA6SiI9UbL+xD+4NYIl+Nsz20gMk2xKNTb0LUTp7xXAWx6ViUO2YZsD6wQ29sllrQXlOnZR7RTLXOsz1EK8ocCu6T8I6wY/bbTPLcAfba4/4dW7WnO81zftSs8H9AsraJOjX0MxLB6IDC2irpIzA6ZPcuqIkQXeC1DfY6PBMSFzT5pTg=
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
      mm/memcontrol: make lru_zone_size atomic and simplify sanity check
      mm/mglru: introduce helpers for manipulating gen and refs flags
      mm/migrate: copy all referenced state via folio_migrate_lru_refs
      mm/mglru: move max_seq read into walk_update_folio
      mm/mglru: use explicit tier range in read_ctrl_pos()
      mm/mglru: fix potential generation folio number leak

 include/linux/memcontrol.h |   9 +++-
 include/linux/mm_inline.h  | 111 ++++++++++++++++++++++++++++++++++++------
 include/linux/mmzone.h     |   3 ++
 mm/folio.c                 |  19 ++++----
 mm/memcontrol.c            |  18 +------
 mm/migrate.c               |   6 +--
 mm/vmscan.c                | 117 +++++++++++++++++++++++----------------------
 7 files changed, 183 insertions(+), 100 deletions(-)
---
base-commit: aeddb4d52acfcc5ce5e988acd48f2906fe966ca3
change-id: 20260818-mglru-flags-cleanup-cc49cfad654f

Best regards,
--  
Kairui Song <kasong@tencent.com>



