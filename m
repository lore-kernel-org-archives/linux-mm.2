Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 160C7C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 21:11:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D2FB6B0099; Wed,  2 Sep 2026 17:11:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AA466B009B; Wed,  2 Sep 2026 17:11:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EB256B009D; Wed,  2 Sep 2026 17:11:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA2BB6B0099
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:11:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6D47F1203A5
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:11:57 +0000 (UTC)
X-FDA: 85170069474.17.AD74F9A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id AA2D6C000A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:11:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OAewaOe6;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788383515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R58uimUktAT60F2STGL0CVSJ2s2uXX89Ga88btTYWqM=;
	b=U9/Y9932z5UBGveKoz+j3H75i5FadvrgNeOeEYDgzzqNcYgJzJ0H3MvHSdedz36yPBHQoG
	gRa2EMURTtfU40kIc6K+0NFIyl1zc9yBQUmSsF6FXbj43AxdxQ5ZRWVIq+OBk8LBltaNbn
	rdMPh+bVQr+6g3qKYh6wY5g9HSG758Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788383515;
	b=6xSVX+WFpB+R7sxQmyWfrbudQidaTq/PLrsr/9ig2CEWQ/SLtTzRiEIKvJdqW4LN7Fhj5T
	LmjHqzCHEl8HvU7Q+jX7bP3n6xcuOswFLltSdhejjPU+W7PaanOT+ANhy/LHlb/UlbZhfW
	Maj3Dv0EEyjucpBctF1860IGaZFzrnQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OAewaOe6;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 31677600D1;
	Wed,  2 Sep 2026 21:11:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ADF91F000E9;
	Wed,  2 Sep 2026 21:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788383514;
	bh=R58uimUktAT60F2STGL0CVSJ2s2uXX89Ga88btTYWqM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=OAewaOe6yCKjB7JUZQRUerIw15rxe4H1LtPvtO1QqwsRPSX35jud9zfB+jPjbywpe
	 3zE40WHpcGOpZWzbxhhpn3G8nPVpUhZD6bEf8gvdJCWZSx0pEI4nZwqbj8y8lZJVSy
	 2MDQ/Fzay7tHMTX5AyjyI4F9upy4yeICOWkjPNBA=
Date: Wed, 2 Sep 2026 14:11:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kasong@tencent.com
Cc: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>,
 linux-mm@kvack.org, Barry Song <baohua@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Michal
 Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Ridong Chen <ridong.chen@linux.dev>,
 Lian Wang <lianux.mm@gmail.com>, Yu Zhao <yuzhao@google.com>, Zi Yan
 <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH v5 0/6] mm/mglru: clean up folio counters and flag usage
Message-Id: <20260902141153.93b932ba572b1d3375216cc4@linux-foundation.org>
In-Reply-To: <20260902-mglru-flags-cleanup-v5-0-9db761d779ef@tencent.com>
References: <20260902-mglru-flags-cleanup-v5-0-9db761d779ef@tencent.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AA2D6C000A
X-Stat-Signature: dd9fm49czzhwfdtfykt8nskrrb1gpay3
X-HE-Tag: 1788383515-671636
X-HE-Meta: U2FsdGVkX18eykJ7VzLeQJbwXrp2XS/JVKEDHafRxmKtyUBeYbDNgTlu16Ov5XZvafPSgBywVL+sgN6qG2B1g93Hhmyw9TUvKNXApBBxbsaaAuR0YvteGfFWCe6k2QLNUZsS4Lkm8qU59YX/cF7Ep4Yu/Uw9DO2thI+EuLeqPDE35l8e3VLL3Rjx34va31OXvOpv0MimBGudM1bPOz3+Ha2gXAa8hfp1H2zdkK0W6pXW4LW+QOeZT96GLmxEKy8nHxAmT3qScSGQUmFYJpyJCztf7DONFZiONa7XODWIl1g+5FWVpLFKI2jz0+7ejmB9AmTzzI5vw1tx7uCGMqX7UXPuYMW/Lm/ocXH9NQ2fRT618s8JZ8pdqDVYaKFGPHUo9FS3CiQbK9HpcVRTQ2Wdo/H6PA7ua6pfoMQ7sNZTgJF03mcAbJ8a/MYk2YX82U2fK8SMdljYptm/ysPgrA2jpqSJnPEv4VLOKDCLGXujzLHVVWQivHnPMcJ44qAZLbOH0su++6/xhWCGJMS8SOiLYe1Mi68SWDfzr5tRjcs3JtvhE2zHIBfzL1xnCEA6ZLrQcJ/zXem1KfiO6tKaVRbsa42ac7YHg/MGcvaGkRsHNe39HdrWG+EQ9YoDpbcSQ7x0wl3HHtaFmHAb28pDcKW0kD5oPGbxDplfqkJu20kfw8LckZ+VxjhiXObuHB/jOr23aAfS+aElrzf8sjPZUvyCk5wvrIXUWe9vIr57j/vpvhva2B0UyG1yrp5de6SnMXx4BCaSOe6RXzQCf8xVBtHLtQD5teDCSjfm9OsA2/qbu+ol3yBlARHjHdpB0XL8FbS90einUxCMt1Y+7xQMF0BrkT3A8dBE/tpruhxrIM4Po7+AykGlMR9wUX1Gd+xM7Zi/+Ol6HjFYjnzw5/SD1RJoOEp455D7pF3DkiRdeUhcftP+URkXjMExD6ixOgE920TlctusNFHQBGCanDmUY5a
 njU+9voq
 HfLX/Vv8PhP1pnSJeupob2ydkQ4a65RsNOkq1E6YNWNDyAxE0Xu1Scb0ScBwytDiVpEvRCLScIOo6EyHsXeYgsTMSaWJX6xybaEtcdkYPiefXT/CB8XMNvBUpBvANV5e1tvN0xP8eWnldbhIt9u1llE4BZukRd2qmfMIHkHW47cXkK4h/jGBGul49xj6nCcoWtepVwFJTby1QdeRfl7+Ru/XbnOHB8m/3rK54QJ3V6UIW4PcuNteaDNujIw0s+EVJQzIlEe2Vl+XUZ3c9hySsUrLiU/ywsEgV/2HcK4ekq+6xiqGLh+y69/496DIx8MkPnS64p4S5QPssuaLHVgOqrUEj49LIZhf8D9kj+13qceHqdAJtUje4m+KIOny9o+OS518xCJZSr/V0hu3W5D+dHrqBlYAlJXxNzrnP+p1QlUYcTAOrlGTgBWoAJXk3D4UrGxgevzHlsY/k7/ExMyLYcoFTjlw22tDsQG8Qp1o02ivJj+Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 02 Sep 2026 17:50:53 +0800 Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org> wrote:

> This is a cleanup series separated out from the MGLRU-FG series [1]. As
> that series is getting too long in following updates, seperate out the
> clean up part for easier review and merge.
> 
> No feature change is intended, except one bugfix. It mostly replaces
> the open-coded bit operations scattered throughout the MGLRU code with
> new helpers, with proper kdocs, sanity debug checks, and hardens a few
> MGLRU functions.
> 
> A subtle generation counter leak is also found during the refactoring
> and the fix is included.
> 
> Also collected review feedbacks on the cleanup part from the posted
> series.

Thanks.  I hit a non-trivial reject in [2/6] presumably thanks to
mm.git (mm-new) race conditions (appended).

The patchset comes nicely review by humans, but AI is less happy:
	https://sashiko.dev/#/patchset/20260902-mglru-flags-cleanup-v5-0-9db761d779ef@tencent.com

So please take a look at all that and retry in a few days?

Thanks.

--- mm/vmscan.c
+++ mm/vmscan.c
@@ -3307,21 +3313,20 @@ static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
 	int type = folio_is_file_lru(folio);
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
-	unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
-
-	VM_WARN_ON_ONCE_FOLIO(!(old_flags & LRU_GEN_MASK), folio);
+	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
 
 	do {
-		new_gen = ((old_flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
+		new_gen = lru_get_gen_flags(old_flags);
+
 		/* folio_update_gen() has promoted this page? */
 		if (new_gen >= 0 && new_gen != old_gen)
 			return new_gen;
 
+		new_flags = old_flags;
 		new_gen = (old_gen + 1) % MAX_NR_GENS;
-
-		new_flags = old_flags & ~(LRU_GEN_MASK | LRU_REFS_FLAGS);
-		new_flags |= (new_gen + 1UL) << LRU_GEN_PGOFF;
-	} while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
+		lru_set_gen_flags(&new_flags, new_gen);
+		lru_set_refs_flags(&new_flags, 0);
+	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 
 	lru_gen_update_size(lruvec, folio, old_gen, new_gen);
 


