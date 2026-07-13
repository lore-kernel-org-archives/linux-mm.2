Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7E7EC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 08:55:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD7676B0005; Mon, 13 Jul 2026 04:55:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8E196B0088; Mon, 13 Jul 2026 04:55:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA0A06B008C; Mon, 13 Jul 2026 04:55:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 861EA6B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 04:55:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1A1E21C43B2
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:55:40 +0000 (UTC)
X-FDA: 84983145240.13.DA2D3D1
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf24.hostedemail.com (Postfix) with ESMTP id 872AC18000E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:55:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VCPm2n9U;
	spf=pass (imf24.hostedemail.com: domain of guopeng.zhang@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783932938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lRQmt4fwY1pc83IFqnyeFa3xOFtn7qun/zE5d+hdHz8=;
	b=jtbSCSt21o0kJd5Ei6yqzGZAMSM9YyVUkj/mKEGRl5LZFpQBGJwO3qUk5BjM1jaVzrE9rf
	pH71pgaC/2i51kWkY3cjIVyVA9AROE9Xx22R0oKMwr4+BneSNfXvOVV/omqw0SiW1bzzPs
	dIlG2Ngw2cbDrwUaUhv+WC4NS53+DbI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VCPm2n9U;
	spf=pass (imf24.hostedemail.com: domain of guopeng.zhang@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783932938;
	b=o7/pHqhruOH7k0YK7BSNsH2JiEX33WWLs1HxAoEAwTwA95QdmEL/Y87SVMRqk3h+NQx4Sm
	4IAv3JZ2tZrK3HWRS1GBiWiQF0kfKsCZogx0JznGTXJVzglSN1drt9r5aRdoFxJtxETOBR
	i5zhgTZ5FtrpNElyRyGjPUDYc1Kt+kg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783932936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lRQmt4fwY1pc83IFqnyeFa3xOFtn7qun/zE5d+hdHz8=;
	b=VCPm2n9UQKVR4xjj4T1LbYJORcayH6qqLMp+hCPm9RGeN+6D0xu8GSkBowu/PS2guv5m+b
	Xwu9j1vMNww/fxb6P1mSg1LquSQuJ6REZqA0NFDLFyHXJRaLs5Pv6QD0ngboHOKkLPQjIc
	SqKb1sHStxIMiionF5pejh9FjoMr5js=
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Stanislav Fort <stanislav.fort@aisle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH] mm: memcg-v1: account vmpressure event allocations
Date: Mon, 13 Jul 2026 16:55:20 +0800
Message-ID: <20260713085520.2953121-1-guopeng.zhang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 872AC18000E
X-Stat-Signature: a7ewggnx8cbi4rgfat3iwry9fkbmmx16
X-HE-Tag: 1783932938-183098
X-HE-Meta: U2FsdGVkX1/CIgfIGAlbE4fFT/4DjET/1O0fBXZwqY4SuwCoKuxrkQ2QP/OgeEmlbh+zJEruR1PXKdp4IF68Rq+HOvWtuSLb+LTTplKQnIoX4hc4sWYazH2l6SbxXpyfKG2A+1IRH4L6a33XPOZaBvmR8w9ZZesXZbr9GNODaT1zY3885zdtWjQIkc3cVfDUAwqn8Zrbcok3fEgDtDsrNdim+Ze+DfNu5zrW4OpS0o0n2PmwntKfIoHcYBgw+zlz6DX9blfqpL/BhNhO6z3BhHvFSLDOslLrzcHm2smfR8Rx2VuJlLN9Hhb5FAF8el9fltVl964YwDz7RgfK4HD2mVzZqS3Aa2zOEa6z12jtWxevvyyRvjFR0Nmrxj7dz83pdjPPZ2UdMz+uP/dadjm6ZG5CQ++svjfV7xvy4fqEfxjDJyRMYkzDXUKwIUpjLh/c7xb0nZdqhT7T6e3fGGabqZwXnkmm1nt5MRIUEXqVRVmIcRT0DMP0Mo8MQnax8eva7HmX9EA/qDESe4NC73W3Y3mSfJt+vbSiG37ktpTVPKUMIX88kLvJSZ2g3PEz8kS7fWz0Z52FBTucfc1A8298Fuohigcz2IOGb7UXeBtaDvkZetlw2vJQzS0yqerWF4cnT18g/TVnHNvw/qwa5WsHqpKTqIUoVKkjMKuNn3UUreesomMJtLBn7VPXkYFYN60uQQm9Mm44u0E1BP4c8a85EZbPqy1Ucu6ATZuoMQ4hrL4KET+47ilOqrSVOp54vaZNz07oiA4inCBExKqGNJiCVlfjcQPdzMiMQBcHhVHd+/WhzGM4ibYX/WhhHsN8kIcFPaJVqJDV+jqnXksc+gBvod05UHpYqkHrEth/jK0fcE6TcL0KliMFY0juF4SAom97xBJ/IK5Aulw7556/o/oWGedDKTqKQom6mYixh/ZxnlRtCIumYTVKRv8wYzaicTZFe9cBWSqB9W/gz5UQIO4
 FGdIP74Q
 FqN+ChDWRr/xJ/8YaeoiqajOi+t0/vJJEuz0j8TvOO8xPXFlPoMMZOgpdVvL0PYe7XWaNfOvaG+dA0gQQtFfLzc5c5tg8c88NclVfdobwrl1vn5au8YN7SZ+gOztMjJBOolDqyJkTP09WY/axKRftJZ3OgHfMU7Y2w/rVKNtyIInq9l/OlmjUV/scaUpTB1J2wf4jlnqPyhkiSwiA+fT9ENkri6i4VgtE2781
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

Commit 72797d218b43 ("mm/memcg: v1: account event registrations and drop
world-writable cgroup.event_control") accounted cgroup v1 event
registration allocations with GFP_KERNEL_ACCOUNT, but missed struct
vmpressure_event.

Use GFP_KERNEL_ACCOUNT for this allocation as well.

Fixes: 72797d218b43 ("mm/memcg: v1: account event registrations and drop world-writable cgroup.event_control")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 mm/memcontrol-v1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index e8b6e1560278..f8424ec3734b 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -1721,7 +1721,7 @@ int vmpressure_register_event(struct mem_cgroup *memcg,
 		mode = ret;
 	}
 
-	ev = kzalloc_obj(*ev);
+	ev = kzalloc_obj(*ev, GFP_KERNEL_ACCOUNT);
 	if (!ev) {
 		ret = -ENOMEM;
 		goto out;
-- 
2.43.0


