Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5719CFF8862
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 07:10:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A99AD6B008A; Mon, 27 Apr 2026 03:10:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4A1D6B008C; Mon, 27 Apr 2026 03:10:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9123E6B0092; Mon, 27 Apr 2026 03:10:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 80FFC6B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 03:10:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1C1C51A07C0
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:10:34 +0000 (UTC)
X-FDA: 84703462788.20.6489C9E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 615528000C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:10:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HpQ94iUW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777273832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d/ieis3Qlm/AJcIQQ0DNFjNy9a83QXRjFRDaM8yCOdk=;
	b=SDClFsJszHBCvfZ0snWE+7MZwh61ULxSCvOq8J1UOUSfzuNFaZLxgxYpOldv9YoTr+cQXB
	89wQ5hTDSK6D9UKb8zcn5niyGydCoDlpIBRCU8zMfTpvnvS1sNyuz/HhDdRSHBM4f2XGy4
	4TkiBtoYdZPGlx9Q8BDU4w7HKOdaclc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777273832; a=rsa-sha256;
	cv=none;
	b=V8odfNp75uYQFRHzq13eILMZgr+aVvGqy0aXrQLTBP6PfC0WFxqdaFoXX7wJ+ku5BA8Q/B
	X4vl/l6el+mTvHLC/IqBY7ivEjIxxFeWbSK41K4CzPoAy52cPSD2ESBgrRxaD4loYGIlZw
	jvoeDnrLNp8DrckZV3uc3I5fPXyyybE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HpQ94iUW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2AEA844525;
	Mon, 27 Apr 2026 07:10:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF42DC2BCB6;
	Mon, 27 Apr 2026 07:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777273831;
	bh=f8fG+Ov6SZaQufkiq2WTLEXvbWtRIw+ej5o9FaRUj7s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=HpQ94iUW1FbbntkG34+YyOJJC9K2Y2MHX/jxzhKTKmDo09P24Xb5Ooc83YMCCx5Lv
	 d5LIJRQjP4415ffHTQSCb2lrmoJOfR/ymo+0xLt5caMimpAp/V2E9gjfBAWVq2Lk0m
	 mldUw9d6THL96fsm8pVmf7Uq9VviaKy9GGteLan6talPR85+5izDAmqO4j9DoAx2MR
	 QG1NIznIkt9z/DHrnxkkzMtUWvvbWbASBundbjw+RobXJr5/UhWB+5U0CGSCDf7ypL
	 7DDDsmlJwMoaP2991byEXTVHcjT40y3P2BZVpyr3qVUJ8nUE4jpSQVh5MxZV1Ev/Is
	 KM9ISIPSgfRcA==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Mon, 27 Apr 2026 16:09:52 +0900
Subject: [PATCH mm-hotfixes v2 1/2] mm/page_alloc: return NULL early from
 alloc_frozen_pages_nolock() in NMI on UP
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260427-nolock-api-fix-v2-1-a6b83a92d9a4@kernel.org>
References: <20260427-nolock-api-fix-v2-0-a6b83a92d9a4@kernel.org>
In-Reply-To: <20260427-nolock-api-fix-v2-0-a6b83a92d9a4@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Harry Yoo <harry@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
X-Mailer: b4 0.16-dev
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 615528000C
X-Stat-Signature: posqqcuqbz9iu56t9f8dh3oh4iitcod7
X-Rspam-User: 
X-HE-Tag: 1777273832-390396
X-HE-Meta: U2FsdGVkX1+6o/Qv1qS2HhWmWJrE7Cffbx/dmSQklWx6Hsu1ReIlP8dIZV7RC07BfkEetrNx89MOnaYcfSXlloFSj8EIosDOyBFHDXotkbmE8h33wik2ezAX1ZXKc/AlbhCE/i1r2HUhd1HNOgjvNwE4DDnhstIaj4L3n3S8lFHEWBPwWQF1DKnla3WSA5iS8CaFQn/BivVc/weeHAEv7/0sgL7KmrpqGLW0GxGAkct7nFIDe/wZGw+RB0vkaz/n7KwlEjfODBYdvmfCQA5kPFDv3qolr2aTpOlAd0gMgzWuOgWzZ3WQbaAZp9u+Grbr/mYrex89g+vkXZ/+NYJ2OjsVMMuau/vMOWZA/iWzwfht6isqZWne+FFikb7lDVl/6GeVoRvUDbRq5/VnwC9N9co6XYSj/w1PCT6LuHl8IzSyDbQMOYbWNc9ikzIUxv+CTtH4aDbbUYbvu0JOEgS2FdteuCvg3qbXp8w9429eSlrR1w0dLNgNrGA9g0Qpg/0I55un++Xb5FdBkeo8nHPwmZfIxlyU/wXPKYcm5jZAy/bcBbdKK62UGFTsueil2fg5f2djV300Ft5hhG7MTxlE+UB2krGZzBu1iH0hBDEhnDt2F3F7x9O8W0fZ38Ov8nHjHI9RPFiXfrrNKMsYCyqK/RRW+Cxxl04KX5ccV8CM/8PQrdhrL4T92p8l3+KJJ9/fcFnnOgS8avhOa+u54nrNVrJ+wZc61hKBmC2MzMn6zdZP3yN2b1gmiS3XXR5bFRwYc5708bDFAQx9cBu+odoE33vT08lkVVeS0+wG9aam6HKT+S6m3l7MM1O/CNpRAVS1GRU6NxlLVJrVRIM+uqC1+g7zc18ssiZKNntmMDBZxeqNVLH/bvtyL/T/d8fJHdfKUKRGwHKYQCYGe+cc0eSFd3zZGfrRaS/wR2G2OdxHhPrFzzZylPSZmXkyGN1ZQbj+Gtc+0TsilUV6aOkV4af
 4AKXJjQs
 H+twLun6WdVewP5MNHZsBXg1sfQiu3KTkQ8yr33cxBVfxSVXjvoAxYv+xZ7PBCxxJky7Uoua9a0xAZKtj12FUZjuQc7V3/uxBa5EKKYPAxyCslf1WcXRaDOzBSkH+VEjrr0jI/FmNKRaBCmF28yn295W0+eIV61pgSM7OtbkBm+ST31smSEx3peMP64Ji/OtBJID3qa/y1iW6lYWVaiw4nwJNnYoSB4dpxsP9ERf52C2tSuIp+T77G/Sie9yco4Llb0A+3BICbUwtSfA9CMcGTavFqXOBjjROioua
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On UP kernels (!CONFIG_SMP), spin_trylock() is a no-op that
unconditionally succeeds even when the lock is already held. As a
result, alloc_frozen_pages_nolock() called from NMI context can
re-enter rmqueue() and acquire the zone lock that the interrupted
context is already holding, corrupting the freelists.

With CONFIG_DEBUG_SPINLOCK on UP, the following BUG is triggered with
the slub_kunit test module:

  BUG: spinlock trylock failure on UP on CPU#0, kunit_try_catch/243
  [...]
  Call Trace:
   <NMI>
   dump_stack_lvl+0x3f/0x60
   do_raw_spin_trylock+0x41/0x50
   _raw_spin_trylock+0x24/0x50
   rmqueue.isra.0+0x2a9/0xa70
   get_page_from_freelist+0xeb/0x450
   alloc_frozen_pages_nolock_noprof+0x111/0x1e0
   allocate_slab+0x42a/0x500
   ___slab_alloc+0xa7/0x4c0
   kmalloc_nolock_noprof+0x164/0x310
   [...]
   </NMI>

Fix this by returning NULL early when invoked from NMI on a UP kernel.

Link: https://lore.kernel.org/linux-mm/ad_cqe51pvr1WaDg@hyeyoo
Cc: <stable@vger.kernel.org>
Fixes: d7242af86434 ("mm: Introduce alloc_frozen_pages_nolock()")
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 mm/page_alloc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 71859993dd54..23c7298d3be2 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7737,6 +7737,11 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
 	 */
 	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
 		return NULL;
+
+	/* On UP, spin_trylock() always succeeds even when it is locked */
+	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
+		return NULL;
+
 	if (!pcp_allowed_order(order))
 		return NULL;
 

-- 
2.43.0


