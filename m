Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79788D6AB1A
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 01:03:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89A7C6B0005; Thu,  2 Apr 2026 21:03:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8247B6B0089; Thu,  2 Apr 2026 21:03:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 713806B008A; Thu,  2 Apr 2026 21:03:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5C5416B0005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 21:03:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F155D1A0286
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 01:03:54 +0000 (UTC)
X-FDA: 84615447588.16.181001E
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf01.hostedemail.com (Postfix) with ESMTP id EE79A4000F
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 01:03:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Z/MxJZPP";
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775178233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=53BQQ0sHBNvn674bx/yqTRF2ETsE2dMIOa2LRdAyEbE=;
	b=Wtho5GwqSwdWxTuxZ6Uey2WoOruyyIYs4N7ov1PEG9uCRhSTeNncr4kaRwDTt/0A+oi2Z7
	pIwXDokNov3aNoEErwzeWQWCoPbE8IDkCGLkJ2SrofwligWAXKNmDkX0UAN68U8Ge1dTQL
	tZ0/ubweYjPUnWHn+GmuiWIyjyAUYd0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775178233; a=rsa-sha256;
	cv=none;
	b=YJN77koPuQHPJ4iydDrAWJgP6dCLLtv1aOUtW4eMfXY9ihCNj3uwJbrRag9j9FheOD8fKJ
	uz9pXVWduGHx2OP6hJnUsD8rTIWyqpkpVQBgLLjJh6lOv+3e5Xpp5Oe45ZyVA29mwDFc4m
	loNasbFqPRuy1HDVIP1d3g3u3zkxMHA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Z/MxJZPP";
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 2 Apr 2026 18:03:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775178230;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=53BQQ0sHBNvn674bx/yqTRF2ETsE2dMIOa2LRdAyEbE=;
	b=Z/MxJZPPnsX8EwiAvUnTfqMgeFGfJRCzrXPTm8DTel/l7vcNI33UAbPJY/rnSxrwBZwfD6
	qi+IXFa4TWtZcl70sQi+mYuc+Aupau0+ryjaj6kb9uWyJ4qmh17WH9eFz/PFvdDB0BWnZb
	r/U5c7QJdQE+LDZMppnM17iGrgepiHw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: linux-mm@kvack.org, willy@infradead.org, hannes@cmpxchg.org, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	kasong@tencent.com, qi.zheng@linux.dev, baohua@kernel.org, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, riel@surriel.com, kuba@kernel.org, 
	edumazet@google.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm/vmpressure: skip socket pressure for costly order
 reclaim
Message-ID: <ac8DEuZhb_aQA4ez@linux.dev>
References: <20260402232511.17246-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260402232511.17246-1-jp.kobryn@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: aiiujpkzr9p5yopaz4z64os3y6398gje
X-Rspamd-Queue-Id: EE79A4000F
X-Rspam-User: 
X-HE-Tag: 1775178232-373858
X-HE-Meta: U2FsdGVkX192ZuvdDzw9BoyMHciJaQUvcDQXyKw1h3EHDDwh9w69E8rZcKrecRKJn2BKzEewXLtOfl6cMqUB+R352lZT4BZgn4oraWqX546iAwuZJwExoZsAEcyV10tF1h81KAj9mYm+eKE85nI+ox7pdosMixIDSWruFrr8G03cpAr7JJLDiuUXChbj2R+FgSRyKDHktQIEpqepuFX468zIw1kTlqNK4jfduCvgYyG994XHRqwY/jnShj6dA/zlPbsgB+Ouvm57LB6KKa183MoiX2FFyDKHjkIZ3u0QnTMsxJWbD667JYiJ40TyGjUYh6Y9G2NM8HlwnX4GPVz8lgoM3v8q3ccwyHJl9I0i596TwQbIyk/2txY0OW9tfoXiU/Ec5eO+1Nla2LJ3XolJolifIgrAwH+OncDlxWPRdUaS63Co8BOKUiTocYnXJXbkoFotrEOESei20cy2hdvTFEyv5xEeMvez+DjEM9XixpFyzO8PjdcGgGLMhqUYYnhBCRSBn1zuOwwhPRmBUY0iAMmeGps+6g16p6rjMiOBq4vQ2hDU4xzdt8h1aXKcpMlq1Ox8Sr0zU35w6HZEz4aPtsAuzNTQcX+r2cL8I+4Im06tyOo01kCVc4XyERArlFF6ZiLmCgdOSytWQCcDfFCpHsyMHa1ugjGwTjrrh396yooIyBxspeolDNDqIgWiYBDJ2v/CBgtt0UJbN12ABNqxlNGcSeVfbNNroSQbB9bAr7YPcJthjppsGDFEDFrsmirPVNNa3eBjxvNmJLD2B/bmrzG9piwXZ015EDyMTculrptKF+DcFOz9av1/sIxJL7Y14DL94JZkxTlArBQbgaaNdYeYKXs0YJqUAtMTCJY46cn2qxOgqvT9q3Nb3uTE/UXPRgo5H0bvF3petWlyAqy76boJYxv5pCXD3HEzyK94h3UK8OldSlrOUTR/6zOxs7MsO4JRtqzhsocqxy799c/
 JE1YcIRx
 H9P8q6atR3zrfL7M31XYuB2zTOZLcxglQ4Hr9CHXV/GICZrGoiEGHRTfirynEp6j2An1LmThQTB4Fj2Tl3br8p7HfeNTiHYXWZ8KKikzov3tDr64ypK4hitzx8E7dDG3Jq7FuSGYb5nPU5Ad3nNYJ9P2wmlUHBdpqBju0eePOHYha+w0FOO1kzBQLeyAfczJ5wTXlTlslzzooXO8VBH/ucviJTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 02, 2026 at 04:25:11PM -0700, JP Kobryn (Meta) wrote:
> When kswapd reclaims at high order due to fragmentation,

* kswapd is woken up for the higher order reclaim request

But this can be direct reclaim as well.

> vmpressure() can
> report poor reclaim efficiency even though the system has plenty of free
> memory. This is because kswapd scans many pages but finds little to reclaim
> - the pages are actively in use and don't need to be freed. The resulting
> scan:reclaim ratio triggers socket pressure, throttling TCP throughput
> unnecessarily.
> 
> Net allocations do not exceed order 3 (PAGE_ALLOC_COSTLY_ORDER),

Net not doing costly order allocations is irrelevant here. IIUC you want all
costly order allocations (like THPs) to not raise vmpressure as those don't
necessarily represents the memory pressure.

> so high
> order reclaim difficulty should not trigger socket pressure. The kernel
> already treats this order as the boundary where reclaim is no longer
> expected to succeed and compaction may take over.
> 
> Make vmpressure() order-aware through an additional parameter sourced from
> scan_control at existing call sites. Socket pressure is now only asserted
> when order <= PAGE_ALLOC_COSTLY_ORDER.
> 
> Memcg reclaim is unaffected since try_to_free_mem_cgroup_pages() always
> uses order 0, which passes the filter unconditionally. Similarly,
> vmpressure_prio() now passes order 0 internally when calling vmpressure(),
> ensuring critical pressure from low reclaim priority is not suppressed by
> the order filter.
> 
> Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>

The patch looks good. I think we can ask Andrew to just adjust the commit
message and then you don't need to resend.

Moving networking stack away from vmpressure in my plan for a long time and this
tells me I should get to it sooner.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


