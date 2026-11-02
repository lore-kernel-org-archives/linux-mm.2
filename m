Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A805E606A332
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 09:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q/XoAkL5
Received: by kanga.kvack.org (Postfix)
	id CCE136B00EF; Mon,  2 Nov 2026 04:39:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7E796B05B3; Mon,  2 Nov 2026 04:39:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6E676B05B4; Mon,  2 Nov 2026 04:39:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 823096B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 04:39:53 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0ED581A0C7F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:39:53 +0000 (UTC)
X-FDA: 85389682266.22.91C86FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1FADC8000C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:39:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Q/XoAkL5";
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793612391;
	b=bfOEvcIXquVtcvC5FKNLsbbFrnf3fqt8WDoYI3ESakOuCDKAOsijhdok8iC0hXnegJCzcp
	H9k6nYC5B6FwUKGEVRFxXZZ9tBeOYVXxAwYi+TpbimW+3ha2f/Aa+an/a1skxr/0FFPJ8P
	8nxOD/L7Y2oy8Im8Q7QfMAGehoDcoFU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Q/XoAkL5";
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793612391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Au4Oi0MWceZmpJKV/fPCRNAL50XGi5ZE7tYwaKOfapM=;
	b=GJyclSAad453Esm4XxJtLoeSkCOe5gavQrfaJC1NwoIad+UaqdRg83vAKy9/S0IFqby8ed
	OV7ShvDBTCCKMVj6xIifkaG8//RruQhDwHuHqCsgIfd/43/d8IDBJTO2RvDDWIgvCH4B2/
	ZzbWSLEQ/tRUaJWoXRoLd4olMmolZt0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B4B64359F;
	Mon,  2 Nov 2026 09:39:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03C61F000C1;
	Mon,  2 Nov 2026 09:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793612389;
	bh=Au4Oi0MWceZmpJKV/fPCRNAL50XGi5ZE7tYwaKOfapM=;
	h=From:To:Cc:Subject:Date;
	b=Q/XoAkL5RZz+iFo49oy1ZaVgejCR4vXmJ8/A2OFh4FzKs+97CmmTM93A1OZvAekAh
	 0vDgVnUw5z/anyJSjojt8F9f22A0NWeDTDCmN9UGNKT8/QRetF5uYIM+z0BkSUT2sT
	 61DZvxZvRaO1raucfxsGf+tHntWtRXqvp6j+yZYsAU8hfXytgrogTgbjI9NJDfCZ1G
	 Ehqpu54zmyx9Y0GWBhbm41VaBcJQKGRB2+A2fbKOQf36hgGwOL95OwY1C21D7cD8mT
	 T5euWXJ6EvmyhoI/xdCsPBb2Yzyn7xBrMT5IuP54gDLhqT3CzvI92toRpzp6aX4y7O
	 Ak+zXHPXXW1SQ==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 0B494198004A;
	Mon,  2 Nov 2026 04:39:42 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Mon, 02 Nov 2026 04:39:45 -0500
X-ME-Sender: <xms:XlroakDI_7O5jyH8JQCM-udFw2VPaxLG4NbntEt5nqSuBmLOdTh2ng>
    <xme:Xlroanl6gnTX0opeotuZ6y9-5VLH80cyVSNl6v1xzIv7LZLqMcPPdCRU17bcENO88
    eKQT_xMJTxDDmZcQkXSj9uq4KsJV0o0PLdR_08g78PR5bdftPlAOLXqlg>
X-ME-Received: <xmr:XlroaqiwquFLkb6lJTBqpXjiPJRjx7gO23AeV5QvjZuY7eJ-Ir2mkhJdH9I>
X-ME-Proxy-Cause: dmFkZTEhRarKBtCberBUjce/isjK9PfXutCTgFrSk65KJKrexvZPW1kHnXgqWxfsL477VB
    0B+PUPaT0e2V6Y1aPEXZVpEDk/+XK3MUho/889EWBmq9dmu8CIuWdZ8d3PoRSIBwOZdAl6
    FAQq6B3QTX2w0id03oZqWxDy7lBwXWKlG1aBfgfczDUssKofptZoug1l1tH0rTdJNE0frn
    8/dZfLluhMvsLe5R9E7RvpG6I6eP9Jlue9NB4farYB7LcaiXDNz/+vZ0sD6utgRIgufl9D
    aC7zZ2u4lnQRU5sqAqppO5dRDB2cw4bonYD/UqVTA3uyFtqvBsNQom54gAR5K0bW51m3no
    63Ee2F1tTcQBxaWwuBEAKR+cyi9JGCdUEVzz9GRGGU6gqw6hSklUQKltbix/cfAnapKVJy
    h+8dGc2ZbZdCwOaOBC0SiXE1Neo/HvfeXXxYlKitadtOszma/yeufwYv1+o1gF1nQKwFgQ
    zNcCXeUFHI72AjTwQF4Q4H1HYvBmUwmAZatgsY4Z7iRl60qtztd1PUTyHWv93mWerhhdEM
    bXi49E/GP6KLTpWxooA7iENbIjIe30PdDHpSpzlgAwyBoU6jNs+AkHwz1edXfPvOIdivLz
    Cxae+nqP7Ddo5G7GF2+yqaSWHNskBw7Ks5nJNbPqpVi8A/wX25r0ZabgrirQ
X-ME-Proxy: <xmx:XlroaodtHk7aGcKr_YzseEk-PrDx4lmjEF7M0d_2UedQdUlm_uB0Ag>
    <xmx:XlroaiCoIMLIUN064fo2I8hdYC-r7t166mVaDBxD3rvaw5K6s6GJLA>
    <xmx:Xlroak7uuCaYPSVTKIy6m7h1KUTYf4zBfTLTViUcXPJu4Ff68nSZ3w>
    <xmx:XlroanzjgyF3US9HUYxyo3oi4xHL-N7EWnRe0OEnGbBVuEtbPdCSJg>
    <xmx:Xlroaol1N_NYgwFjW88m8VTXlU-xqzSiRp3m0z1UUG6nujWOGoQJI290>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Nov 2026 04:39:41 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Dev Jain <dev.jain@arm.com>,
	Harry Yoo <harry@kernel.org>,
	Usama Arif <usama.arif@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2 0/3] mm: make watermark checks honour ALLOC_NOFRAGMENT
Date: Mon,  2 Nov 2026 09:39:33 +0000
Message-ID: <20261102093939.3340540-1-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1FADC8000C
X-Stat-Signature: gaxbpjfqyuhzgs7syerhudp6u7oaraw4
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793612390-946038
X-HE-Meta: U2FsdGVkX1/A0yulJ+AOFOaPoVeV14hLGtxcLclkMWY0widDSSn140abUVrOYImZstZ3GSPZ+Qt4tb51pCUGvvtnwcrQ9bflWvUKWjIzsfrbCsO/n1Ia6FhAvHZfZHtU70+AIzvcozVjDCNI660neJYV0ugtU2R6oKTUSej/X2ZTcfbUnBtFy8gi1gRf2yhEwh1Z1Jw9iZRvYBJrvtWaU3hevAYvpElUEuw0iLPLiAgCe7Qw7QwnIgtrem4g1V5T9okUTvEYv0HyVN9ErH0miGCBg8S5TunVT9t5eY/9tLhDkmxNU4GhZi2C9uYLSzu+n241gVrHnXfBqnW4MwXcPe0egQzDq2MFGRzNynlnsT5ZoCHBjRVZazs87U8MKk7PEyRz/SXPasQTIW3OaQ+LOrPTFltyQa5wa69cTkBgwJNJcd90tLSwwpoyyFEjz1hbg89as8WgV2QouepFd0PIj5+pNNEznSbEKLjDxSrHS0qxFawzcFAnkHjsN6LQ3CGBdjHkwR1oKd4gz829S2I3HbXAQWJhxGU6JrH/4hcgq8kJhFRorxIYAwMsm0FzV8o9JpBkZfwp8e8ywWsKamu/ojjch009NlpaOjV+ekEbGICvYLNUp6BPtms926sOFxwrhj+03LFdRiuAMEcDaSjezbyIzIaZgdhbKpPnmzwBnAMJYLaYsEkuUvhFio1Wa5DXOXeQO4zi/zl8B0Wwhb/Xg1XDdxTnrURP4KpnMVb64Pcr5Ha9m6uqP/hAG5Erc5pLVvW5pXZIxPnDuC4j4FKOuaJXEoav/rlN9cg3xelZThxrqdMlIlVUS+eBcaDfP4MUsVtDp0fSlxZp2XarBZwgLfKFfOYZ+GAkic6at0W6RsiPiNQ2OYoLmEhFJIuYIoMd4V5uLttALy5r3N81lp2kehqObnpC9ArZCrlqUS2DeJiJceirT977fc/UW5fRDrlRjtJMuaRIa4Tb+6ehYTu
 oPuhx3U9
 ytAE5PGbR/Wax5YZJSGQUonf4bFsa6q1jwAn6i7pTN25isEtUECOcrVxLAyNykauAaJGlTlI6jZ68O85qN6Yj/GyAazsYMlJb6Qnoy8AcpidQyZFTxQnTM/vjCsstlEmjGAlPpYiTm9u96gol1vb8F/fHUE/cV5gTqCXW65x1XU7lLfqk7Uh9iFSWYagv2jxXxHdFGl4Qma/hLXiY80kP4ZLRf6bpfHAwWSA4gVU94b1IxvGsNEBgg7CKGj5l8Dttlg56nIBjGhjU35sMtBbRj/l8w+u0fIvzZRvAqajMBqEEADTBeeAOXDB/1/CF0I9xYp7rY4yab9fSVTp/S/0VwSL0BsMlXpRcfjYR8j6HaGsxbSk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With defrag_mode, 64K mTHP faults under memory pressure stall in
compaction 18 times as often as without it, and get about a third of the
folios.  Dev Jain reported it [1].

The high-order watermark check counts free pages of every migratetype.
With defrag_mode, every slowpath allocation is ALLOC_NOFRAGMENT, and a
request below pageblock_order cannot take free pages from another
migratetype's pageblock.  Under pressure, that is where the large free
pages end up.  Two callers act on the wrong answer:

  - direct compaction's up-front check returns COMPACT_SUCCESS without
    compacting, so compaction is never deferred;
  - direct reclaim for a costly order stops early, having freed little.

Patches 1-2 give the check the request's migratetype and make it skip
the free lists the request cannot take.  Patch 3 tells direct reclaim
that the allocation is ALLOC_NOFRAGMENT.

Dev's benchmark in a 7G VM with only 64K mTHP enabled, medians of 15
runs:

                              defrag_mode=0  defrag_mode=1  defrag_mode=1
                                                            + series
    compact_stall                      1690          30669          7366
    64K faults allocated              20750           7391         20129
    64K faults falling back to 4K       725          13832          1339

defrag_mode=1 still compacts more than defrag_mode=0: by design, it
keeps 64K faults out of unmovable and reclaimable pageblocks [2].
defrag_mode=0 is unchanged: 20698 64K faults allocated with the series.

v2:
 - Patch 2 changelog: describe what the fast path change does to pages
   on the per-cpu lists (Andrew); drop the should_reclaim_retry()
   paragraph
 - Patch 3 changelog: say that the benchmark baseline already has the
   high-order check honouring ALLOC_NOFRAGMENT (Andrew)
 - Rebased onto v7.4-rc1

v1: https://lore.kernel.org/all/20261028132638.2560361-1-kirill@shutemov.name/

[1] https://lore.kernel.org/all/4aa14b41-9b89-494c-8825-55fffd5a541c@arm.com/
[2] https://lore.kernel.org/all/auCDnqJc7fsBpUW2@thinkstation/


Kiryl Shutsemau (Meta) (3):
  mm: page_alloc: add a watermark check that knows the migratetype
  mm: page_alloc: make the high-order watermark check honour
    ALLOC_NOFRAGMENT
  mm: vmscan: tell direct reclaim the allocation is ALLOC_NOFRAGMENT

 include/linux/mmzone.h |  3 --
 mm/compaction.c        | 16 +++++++----
 mm/internal.h          | 10 ++++++-
 mm/page_alloc.c        | 64 +++++++++++++++++++++++++++++++++---------
 mm/vmscan.c            | 24 ++++++++++++----
 5 files changed, 89 insertions(+), 28 deletions(-)

Range-diff against v1:
1:  c630170105ac = 1:  ed3ef9f9fd13 mm: page_alloc: add a watermark check that knows the migratetype
2:  918bed282fed ! 2:  3347b0a24b0e mm: page_alloc: make the high-order watermark check honour ALLOC_NOFRAGMENT
    @@ Commit message
         __compact_finished() the same rule for its fallback test, so that
         compaction, once it runs, stops on a page the request can take.
     
    -    The allocator fast path gets the same answer.  A zone whose large free
    -    pages all belong to other migratetypes now fails the watermark check,
    -    where before rmqueue failed, and the allocator moves on to the next zone.
    -
    -    should_reclaim_retry() keeps counting free pages of every migratetype.
    -    It does not ask whether the allocation can be served now, but whether
    -    reclaim and compaction can still make progress, and they work across
    -    migratetypes to free a whole pageblock the allocation can claim.
    +    zone_watermark_fast() calls __zone_watermark_ok_mt() too.  With
    +    defrag_mode, an allocation now wakes kswapd and starts reclaim or
    +    compaction as soon as the free lists hold nothing it can take.  For the
    +    orders the per-cpu lists serve, that is earlier than before: the check
    +    does not count their pages, so the allocation no longer uses up the local
    +    list first.  A request that may not wake kswapd or reclaim, such as an
    +    mTHP fault with THP defrag=never, falls back to a smaller folio instead.
     
         Fixes: e3aa7df331bc ("mm: page_alloc: defrag_mode")
         Reported-by: Dev Jain <dev.jain@arm.com>
3:  a7ebde665647 ! 3:  0ecbcc5f5fb0 mm: vmscan: tell direct reclaim the allocation is ALLOC_NOFRAGMENT
    @@ Commit message
         and cannot take the free pages left in unmovable and reclaimable
         pageblocks.  Reclaim stops on them anyway, having freed little.
     
    -    In Dev Jain's 64K mTHP benchmark, an order-4 direct reclaim frees 16
    +    In Dev Jain's 64K mTHP benchmark, with the high-order watermark check
    +    already honouring ALLOC_NOFRAGMENT, an order-4 direct reclaim frees 16
         pages on average with defrag_mode and 45 without.  64K faults get a bit
         over half as many folios as without defrag_mode (medians of 15 runs):
     

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.54.0


