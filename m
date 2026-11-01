Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F282D606A325
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 07:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LH6zBUF5
Received: by kanga.kvack.org (Postfix)
	id 037E36B05B4; Sun,  1 Nov 2026 02:16:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2A576B05B6; Sun,  1 Nov 2026 02:16:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3F426B05B7; Sun,  1 Nov 2026 02:16:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BC9BA6B05B4
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:16:25 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1DB37120A2C
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 07:16:25 +0000 (UTC)
X-FDA: 85385691930.17.A7E989D
Received: from mta1.migadu.com (out-98.mta1.migadu.com [95.215.58.98])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9A58140002
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 07:16:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LH6zBUF5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.98 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793517381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sKUtUKSAT7N9lWEULtTe5OHLm/0QKeLXLq/cuehm0hY=;
	b=6SOKyyPUlXoKS4QxTQ2n+juCc3uI8/gRQhP5/4ZDhpmyqIV7y1CFVcdpVH0FFaXIDz/yS/
	QOIugAjJPo/oeglSNxpNCP32YFyUctheZMUe+vd5x16yB/mxFN5QdwvDuNxF5aZV6zEJoA
	O4BGj+eo17aHpmN8qEFDV7PYqJ5Em+s=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LH6zBUF5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.98 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793517381;
	b=U9NnbC5t/LQzizN3ITAe3bWb1mVVDK0+bJgeeL8rKO3L2Z3dri1OEQHupIEef+SUZWCe6G
	TNo9QZDc9FznfPFrjuU+mumOg9ublV7RZSuat/3Vp6rGrGM4bXXKL+XEWnbHC7EJ9/jMyk
	s/h+GEdR+77+HPIK85IRCNISXYKGPhc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kHUvHYnw2dekg8CUjBUhuxM8s0SCtb5RHv0FpAGfgMc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793517377; v=1; x=1794122177;
 b=LH6zBUF5EdvcDy4FlVd/3Q5UigVrRVxhrnhHOqrazo9ldwqMs9obVky87NL6QenKubvhrI6q
 XMj3bb2b2YjNvk0CTEXFPZLQAaKmniolyu8Akifd0u0A92dWuwIDu0goFqmfLXuNds+0D3GofNF
 uuMft3H07+IoN39TmjwhZuRs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3d2700dedfd938b8;
	Sun, 01 Nov 2026 07:16:17 +0000
X-Mizu-Trace-ID: 3d2700dedfd938b8
X-Migadu-Flow: FLOW_OUT
Message-ID: <fe601caa-3676-4623-b77c-35930a6f65e6@linux.dev>
Date: Sun, 1 Nov 2026 15:16:09 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/12] mm: hugetlb_vmemmap: unify vmemmap range
 restoration
To: Muchun Song <songmuchun@bytedance.com>, Oscar Salvador
 <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, James Houghton
 <jthoughton@google.com>, David Hildenbrand <david@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261020115306.813483-1-songmuchun@bytedance.com>
 <20261020115824.823278-1-songmuchun@bytedance.com>
 <20261020115824.823278-10-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261020115824.823278-10-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9A58140002
X-Stat-Signature: 3mbsy6uzrnw1dh4smi1ig381x6ssce83
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793517381-378760
X-HE-Meta: U2FsdGVkX1+tKDvG545ssJ4/rIcBEbppzuoYAFRcDdT/uhrcna3xLvSwHRXOQwCKdaj47ntLnbfYYr9Q6t0RTqqMRsBlF+5DZVfuc4XU1XbNnLjAIZVJnVXyrB10j/meb4tTi/YP/lWh7burEZGIYZ4ebcSdCA0vIa0XjuRhjLVVqYlfCjInrAGQNRL/aIF4BQ7h1v82+ALmCoZlhWFy95W32gKlmyOZCdxxOokgWqFTAeKHQPkue5pTkFB1Cdp2S/zNM3CzcksdGwGUnwDu0agaewA5tivpgZ9gPyQfu/SZ6P/b5pdQTwyrA5ZjrLBSKdhqyS9hJmwSmAuAxQ0GyH50LN83xelvjz0JPjOdAbtBkTnqoACTSiHH1gH9eJVZ7J2bUxE265OPgBiQZJuG8ZNwBorTibEtXNm+5A5gsZuXraBSa7L5l/QEWQGfJGuCgpfwmThPfrsuSZoUwAZhj6E2RCySH1WxaVmhKDCfJHimEOSWFSL79MVDbq2/wYhNo7BSqM/hjyb3AqgAZ22fwk6FudhgsmBTZymQCPtsH7Xv2VxgPU9uWQsB0/IjJUpdNglEZlmiKUqlXCOl/p8S4JAh8g0Ckkd3+tUcsqHCfezHwOq9bKMsikq8/saNVafCvMV3+syhPW/BtpgVK1YvxgNZQTR1qS7qHgz3o0MYliKcbGTq8jNz2oCx2kxwlgAjcGC+GxDZUdRQDsJcUxl76Mr7X+hJU2jzui/5HOuTCpJHOJrJKgc0gMoSk85TaDpzxXp+ZCZT3m+0imfVJlWEcjsTlZJBqjfNeSbPQeTqFNZtpKTtVzOoyKqsAqSbUQDbVAN3fB/uhhcJkNZEh+EHPxxrmCcrVGeSv5kOXlszomJnOI9hmd31gNw3iR0Rx+3S9fsc6wP3wM2RO+kbj9wwGLC8IpMI9yHq4xgJdJsN5TuIDwXiOxRL3C02QW3+VEl6PcWWJ9IJ65keUePaun0
 NhQSpxq1
 0QlWq7w1Vx/cjHsnfO48TSm/FXT6YJLfdg7kC851PYWxPpu+YATNeo1xzMX4z2XvMqVfrZl1akbT4tDKnAaXdvapg62HQmHFxPJ/ze8pt+kdAgGB/qtuc1l7SMFx6y+TfcBlIN6uXC2q9WyloS5l1cNOLu19brDEepQl8lky6sXCpBLl5CGNJMxALsAhlrXJq3Y7WD09e7YRp6KDAO0cfrdymklD/MjvsnoTYRZitdyPo6pwTrqjoGsdSLxVEJSbOmkXtIE9up/qivJ7jFIGlbALlTfrdqombQi21o9oqgPFkSAnGQgfbY1CaV9hUDVLQssNPyr7faKmonN8xXQNBqi21WQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/20/26 7:58 PM, Muchun Song wrote:
> Restoring an optimized folio and rolling back a partial optimization
> both restore a vmemmap range, but the operation is currently implemented
> separately in each path.
> 
> Use a single range-restoration path for both cases, making rollback an
> explicit bounded form of normal restoration.
> 
> No functional change intended.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>   mm/hugetlb_vmemmap.c | 33 ++++++++++++++-------------------
>   1 file changed, 14 insertions(+), 19 deletions(-)

Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


