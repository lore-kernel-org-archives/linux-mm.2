Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0292C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 16:51:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ECF96B009D; Mon, 24 Aug 2026 12:51:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89ECD6B009F; Mon, 24 Aug 2026 12:51:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B39D6B00A0; Mon, 24 Aug 2026 12:51:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 608886B009D
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:51:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0747D1A0194
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:51:18 +0000 (UTC)
X-FDA: 85136753436.13.71B97A3
Received: from mta1.migadu.com (out-158.mta1.migadu.com [95.215.58.158])
	by imf03.hostedemail.com (Postfix) with ESMTP id EAB0420003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:51:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l+ThLLPl;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.158 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787590276;
	b=Umcwu96WUruNFQ0J41NndvUs0jqakgpE0siZyDsdswg0lhbq+nhIW3XtU4bUcWiHrUez04
	hqs5wLa4pbTtB58hO1u9eGHf3HJerrCAdhCCmq3whRp92DMWlHyeU835B9h0F6ZfKTVzQm
	a6Gu5Huo8av2zPtdPdNxpSW6YlRvWrY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l+ThLLPl;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.158 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787590276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VITpa+ghJ07mw1XijAJ7bVQRsNRrYu/FquTnGKD+P+s=;
	b=IqQ3NpG0q5JU2wO/JFQFvdSQoHPF32LlRS85akG44RzkEkIOfpDaqdCP/2Fw11m51Lzj7y
	lPGOo+6Sxtp1epb3xMG1AYG5zWG7PV6424WZgWnK8x23F+j0WjKxBIoUvdIg39cs9BjVV+
	QHiWaw3F73oXg9yB+FDyU+84FdZnsAM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=PV2zLJMeUDfjBLQlhAwSR9WqLY4Agrz21Du2BoFyGno=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787590274; v=1; x=1788195074;
 b=l+ThLLPlPVoch9kUhuFTsZdGTJH14lVIMrgwBLchDY9wgqPhxYmjXn2P9mu3uB964/rZJRuw
 KDBpGVYvv1pZadY4I+Vm48EZWb5ey7iVaYVe5J3lpqZmQ4ACnpiwmP2MWY2GUDSmxHZdH20H+kc
 KUZoELVJpg2BZ7NSqC2NGZHc=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:53::)
	by smtp.migadu.com with ESMTPS id 1cfc0863f37e0941;
	Mon, 24 Aug 2026 16:51:14 +0000
X-Mizu-Trace-ID: 1cfc0863f37e0941
X-Migadu-Flow: FLOW_OUT
Date: Mon, 24 Aug 2026 09:51:12 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH] mm: workingset: account MGLRU pages in
 count_shadow_nodes()
Message-ID: <aoxzzAHm3tx33KZA@linux.dev>
References: <20260824091631.836473-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824091631.836473-1-hui.zhu@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EAB0420003
X-Stat-Signature: k5i5n5315kqq1mp1prqh1ic8iqh7sb65
X-HE-Tag: 1787590275-677532
X-HE-Meta: U2FsdGVkX18Lt2YMG54gjVnU2zwkc6VaDJRmE1xtM/aOBE7Q43rcCztf1LlFnzi3yGuzIvBWW9Vni+2/tDRSEp1atS0YJK5VSmkbiIj/NT6HXwiWLhgVqxxvcqZfbYtvTUJjMMrZUWU0BBMI+V9RXiohVRQ9vwMZ/nkckD1YPGzLtPQ/nO2LepT3/UpVzF5DBoclz4RxuuG95eRp9pDz4TU99OVxWJzeDUcvHAY51034mOvpvu+L73iMBphy1rphyG5CDsEANjjMjDK5cDZwQnnzvHKszQoxFsVsL2FV4l7cRWUD7y8X55ho4LE7j+jpTiUHzkiXPFWgOtZsm8OgdrgHVOJJe8+EV1tRn04LglwuzFiwuZBOFMk50co+3Jlj59kYl9g/GfgRGIox3XUfK9zdStoT40hkliEbtU5FFwysab6y1QodwpIeWQZwXKu2b2b7v92BtaIbEOqzPMxA0Yb9h/xhJ+NG7gwBXRkACCsExm3W5H/ZR8X4//cG0823h4+/aVP11PPojjUyef1Nwy6WRGvlVYpJ9XS3+o4IlTET8ZOH7YkOTUN5uacuMKcmyrsHxQQIphWMurWwU0tTJIEMC7OHrf+dL+Q12lNieTJ5qSyz4iTQzbdJwI1ayvF9e34al0N/smUBaWRaC4LRbIwkZtFMWRjLIbcaSHnlC1UHVPh+VsNiCvPtj/fRz0/wMpPWDXRBvzPsLI0YuhH0oUxJUFXhs5JjdT7d3y43QWCSZBf3uTm0JKCR4uTqAWuPlpAfZgeIKinJx9fhfP0BWfVro1SY/vX/x8qREdPmnPlQM1OQBxXmS0FbSjmVGzRhmwZRCIlPC4oE9tPGb7C8fbMdQHaGNMrynII2zY3UkdtKluINPIMgSn6m9OGHOfSB+2e/V3fiNhnmbzAO8GGgq0pkExwfJn3zmJC//fIPKxQJGnOsK7Zk4T0j+AIkIHK0pOOZuDCNOQpCr4YwuF+
 PRciCQ9M
 fYPMOdKQyPBYZGQqc5z06ZuZUeEhC35DdobyMQLwba+rXIp5CflPRNrlOzIwZNKBROjEiXOk6hLwurc7hvQsxD7vF6FB1LRPvn7N7xNe9p+tpX6asQszJ00NGWRIyKCB5tpr4HW/jqjYuEIz+wfx+6CYTGSMremxl0Te0alfuizSBMhrD1zmUDh0jZq26zP9bx3UJkhscTa1bpGe1ARXmq9BfDuf1iFScxvJhHPlJQce6Lh9xZbtUn2/gEwEqjhQiGGOXgd/qRgZzELSYyNd0azKXrLTNec/5nnTkfn7GIYe0Aw0QLiaD8JhcBBF8zknrmfE155jsOmEwIBaXSHP4scEeIXrwOjoOu9qp95n0K4uEDVk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 05:16:30PM +0800, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> Commit 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the
> number of lru pages") switched count_shadow_nodes() to
> lruvec_lru_size(). 

Instead of adding more complexity and increasing divergence between classic LRU
and MGLRU, let's fix lruvec_page_state_local for all. Usage of lruvec_lru_size
instead lruvec_page_state_local was mainly due to concern on adding upward tree
traversal on stats update side i.e. get_non_dying_memcg_[start|end].

However offlining should be rate. Let's just use get_non_dying_memcg_[start|end]
everywhere and not just v1 and measure the impact.

Shakeel

