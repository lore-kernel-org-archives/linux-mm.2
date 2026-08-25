Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C802C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 17:53:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC36C6B0098; Tue, 25 Aug 2026 13:53:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4EBA6B0096; Tue, 25 Aug 2026 13:53:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 877AE6B008A; Tue, 25 Aug 2026 13:53:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 50C7F6B008C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:53:42 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BE90F12012E
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:53:41 +0000 (UTC)
X-FDA: 85140539442.05.896B579
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id C545B120003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:53:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jZlZINKj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787680419;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=so5v0DvkbWswD0/odNA8cZRA9wcbHOjwzhg4pTb75JI=;
	b=50yTIzrSIeuT6ew0PbFcvvTC365i2Ocwms4SFBibPT4FUloHqGajOYYw59IN0N0TPJN7p7
	ErJ7/URS93E2rnlfEd0BhDJf1EzaBTpOcO0BReZij+1OTmmcTYG+AvHsMp31IgP54LtPX+
	PgOruAlfKqjIZ2sUU/JyRjBjJzHC2Sw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jZlZINKj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787680419;
	b=UDlBcqqFeFh6lYeCiyb+HmOsXEZ2PsPflaBH/D8Dp9Hw9m39+JxZU37cK2q0d366S4cPSP
	/F8Ihut7oEqa7UlJxYf4rLuP+hIT6d/Q2PoJ1WdpxrQbc09Gg8830JDagCos+PQ4Iw0sky
	yOq8I5aYOuzV+TTM4bxghNlqLppzVic=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B424040BA8;
	Tue, 25 Aug 2026 17:53:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8CFE6C2BCF4;
	Tue, 25 Aug 2026 17:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787680418;
	bh=yGhBrxPFg7q4A7at7HAzLQQYUvr4U8KOXRLVnzUgTB4=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=jZlZINKjJEQcQaaLf//L+XieljpgjnSINNQSXjq30GzY7JB0gPjt+U4tcFvI81scF
	 XiYFwhJVEZDm8DHbrC5ve0ZgFeGSekpilv9yUQvcpDNMjloftmX+Jy/1zi6uzotHDy
	 QLFW8Qq6xAg/QgDyCO2Ofylgiq7hAYcy/4/80GIBzqfCpEwERfNawQmnODTI6YvPT8
	 CgqY/TVICG0IfGxYslQ/0nOdtj7eSowV22JoLQpDFPPLCKTbxmPfE5HanJO5xmKSxB
	 T/TYrOuUFJOH7KPggmPx5Loq9ho0B8COWRVYu2xoYd64QSBS9VYl+ufU03MdZADcnc
	 bZaBCQCrbex/w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6587CC61DB9;
	Tue, 25 Aug 2026 17:53:38 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Subject: [PATCH v3 0/6] mm/mglru: clean up folio counters and flag usage
Date: Wed, 26 Aug 2026 01:53:33 +0800
Message-Id: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/32NQQ7CIBQFr9KwFgMUm+rKexgX9PNpMZU2QBtN0
 7sLdaOJcTnJezMLCegtBnIqFuJxtsEOLkG5Kwh0yrVIrU5MBBMVq3lN723vJ2p61QYKPSo3jRR
 AHsEoXR2kIek5ejT2sVkv1zeHqbkhxKzKi86GOPjnlp153v0vzJwyWuum0QqYFjWcIzpAF/cw3
 EluzOLDIuRvi0gWxpnkpeBcKvy2rOv6AqPmaGYQAQAA
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
 Ridong Chen <ridong.chen@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, 
 Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, 
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Kairui Song <ryncsn@gmail.com>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787680416; l=2634;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=yGhBrxPFg7q4A7at7HAzLQQYUvr4U8KOXRLVnzUgTB4=;
 b=sHCVoCfyGamTgCWDX0xKsxNkLAKq3PcT7NYv721IP+dfR3tZSevLxl3Y8/geemFKddnMjWJjc
 TW7eb9p1+pPAR/L8wR2YLl/uXR34CYl/yr4USTabnbrTUwIfD2WQ2rF
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C545B120003
X-Stat-Signature: acf18p1db3m1ojxo8gn6e7h3fdec4hy3
X-Rspam-User: 
X-HE-Tag: 1787680419-326296
X-HE-Meta: U2FsdGVkX1/J1CKb2A+e6rVwvAEL0TbMXDsuVA3ZBWXAQcTbpD3ot+Utb/uX6SdtqAnkNFZvgN0Z5oDZVWKa7BUnhRFX894HtEn3NOvJDE9fu0JmHiCn/YO5XNidFtkan7RF9m7v6kQNGX/o/lA8/2cm5JBd1qr09BJR6DKQVNEeSoqyJhihSsL18Tn59+howNa4o6kuKSUpoiaTvjERTGmo2mKPYtfCDDMBLxVuFvNSl1d2IcZVvkwOub6jZtswBL72MAHn/QsLYzPSDoJkTDfO6NuMOuxOjDWoLtO7M2pR6xbbXe880HQVM77GLVPaHbWRf0A88NmKsD1NbubBiMHtqJep7lb3932+goz8oLTdOWyCXwbdkd2FMzWXQKs8TRWp4SjD4A8ArgF+7phzWREZK084fAu8X+uY8bryCbOyNFiG5kSvaPTXOa9yakbduq+63ijER9o36xq2qCJsqjnpf/ZXbXhju3yRxuqSDu/DLO5Ip/3wf2YsV2bNYVeihvct44juMuYoUz5ZNBkPWWOKU7Nc6ff6A1ZcezncBB0XAUDeC9k2wVTkpbzSS4dPITX6gkNWRkJE4oMeQYFNotHQ8nt36lurGebUZSEKRij0JyLsRXtFFMnOQAZ+Ju5/OP5Vk9ds2TwBOksiCB3wdr5hemR0TvssihanpZqmtaE77J5ycmrM7sCqWPJAGeNi8As7xqX9A/f8l5KPn5yAgbJiRyY2xF8nm+gMLmQq2Otty/g4DhhK+Ktk6lns2UuoVixPJdiuPN7QcE+2o1LrRvPKyFmMnW6fS4JHUVgcWmblZYzuO7r33ggZRDgbo6mMJmyihO1F1pNIISae3PIB/dusREK9u0z7GpZkemBs9a+nsLkdF137ryLg32vg8YNJ8ds0a2OvaQo9m9qQxxFWifYTsFX/EI0n58QOkNgn5lj0FeZz8c0Ws1GuWhAboXYZ9UAyQqFNMxTbtwiR4gQ
 B7Io36/a
 ivNkizsC/fig0kDUrEz9mMdfmtATDAqpAA3PNzOKSU3hWSxDhIGGBgxXJw42RU3Kou5dRlDdHs4iVnazhUZsn+TdyeKguKJlfvn3ed7nbL0VM9YRzvBttQrongAaLovIVn61ZivqMQZAX2Yz7LsvLZV4YFtFaajtc8tG2ZQ7fkvRy6bE0eTvqevQI4qojpHX2yD2BgIHgR6nh/TPosSc80MpK2sCjfRxJYmILx4N/F6N7AIErcXoohpzNqsFTD6R9mnUt4fVin1aEbVE3ZUTW6YI7steeeLU1r0aGZTEoKsFQYRAOr1r0J2xqlyRRk7kSgYInH2VVlfsj3EB40QmbFVq/MDApwkiTF775+AkN+MSKx7huEKryLqXACwY4YDomYv/Z/Z3q5O7qW+jr8Mcl4vQyWLN33Dmwc5c9dOsFKTMGO1X9C1TFHqCy4PYiZ3dvCGKZTmmutMzKeY4+2l+y92EsyCLS5XWl4e4YCd3Ak+eUooGLmGleCFhHwRgWiNPQCyjYNmLhUYOFkkA=
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
 include/linux/mm_inline.h  | 103 +++++++++++++++++++++++++++++++++------
 include/linux/mmzone.h     |   3 ++
 mm/folio.c                 |  19 ++++----
 mm/memcontrol.c            |  18 +------
 mm/migrate.c               |   6 +--
 mm/vmscan.c                | 117 +++++++++++++++++++++++----------------------
 7 files changed, 175 insertions(+), 100 deletions(-)
---
base-commit: 169393fff5d1ec2690934067eeb95544ff5ebdd7
change-id: 20260818-mglru-flags-cleanup-cc49cfad654f

Best regards,
--  
Kairui Song <kasong@tencent.com>



