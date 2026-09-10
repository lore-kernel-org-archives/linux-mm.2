Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D73E1C79FB7
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 07:40:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0F886B0096; Thu, 10 Sep 2026 03:40:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D79376B0098; Thu, 10 Sep 2026 03:40:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C60936B0099; Thu, 10 Sep 2026 03:40:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4CBA6B0096
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:40:26 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BE1FE140459
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:40:25 +0000 (UTC)
X-FDA: 85197054810.15.9D0AB21
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf24.hostedemail.com (Postfix) with ESMTP id 93C8E180009
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:40:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=hObn2qOa;
	spf=pass (imf24.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789026024;
	b=LxokXcLD3omzqPKWP3W6PvH6ZIyUcFG45RP30KeCIz765MowxxgPiH1575EOevsB3gV1cB
	pR5umpS8ctnyN4K/XeXwqZDDSGu7GTzA/kH/Q2h0weJWINpEC8Vm4fRtwM9w76AtQYWfMB
	v0VnlqZ8OJUf84fOaWRrdggmOhQaLh8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=hObn2qOa;
	spf=pass (imf24.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789026024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nO/KQnopE23Wizv8xSIWVHEQPNqM2xv6VOHjFuXQ9M0=;
	b=d4Qty+W1MK2UhkgjJxmFPmTx1oerMgfEeDiswfAz4pmOx7JvFaTkz+yKxtHITQngiNlRW3
	t0hyRPQRCThuulX+E6YBEH7DeII3kjLqfWAaA8AdqnAj0H61Z6TtshaFem2OwBKUKs8VJc
	QYUfTNuB0DHb/Qlb+oRvcqyBYeWW/5Y=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789026019; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=nO/KQnopE23Wizv8xSIWVHEQPNqM2xv6VOHjFuXQ9M0=;
	b=hObn2qOaq0A3X+0I/izOXtHdCNfRASbw87T3QgCGYi/yv0rN3eSrFnWlHLyezIN5IwoEcadQzCazc6zLqKLCAChfDQWtc7zcupV36M6SD9i9XAHWHzFGFyFT0PuKhz1TCKJZKb9Q3rnGA1C9ZDxtYdilA/PtlNmrvgt0M1uS/0I=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0XAgyQpm_1789026012;
Received: from 30.178.84.157(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XAgyQpm_1789026012 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 10 Sep 2026 15:40:17 +0800
Message-ID: <de74c87c-b52f-4310-b3f7-9a64b1b01eb1@linux.alibaba.com>
Date: Thu, 10 Sep 2026 15:40:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm: memcontrol: drop kmemcg_id and use the memcg
 ID for list_lru indexing
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Usama Arif <usama.arif@linux.dev>, Dave Chinner <david@fromorbit.com>,
 Qi Zheng <qi.zheng@linux.dev>, Yosry Ahmed <yosry@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 Xunlei Pang <xlpang@linux.alibaba.com>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260907110111.2286932-1-qinyuntan@linux.alibaba.com>
 <20260907110111.2286932-2-qinyuntan@linux.alibaba.com>
 <aqGjkGA7XeYEHA2T@cmpxchg.org>
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
In-Reply-To: <aqGjkGA7XeYEHA2T@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 93C8E180009
X-Rspam-User: 
X-Stat-Signature: kh6ynyds6jtr6rpznag7g5416rsrkdps
X-HE-Tag: 1789026022-804106
X-HE-Meta: U2FsdGVkX19xaQ9IvYJC8LATGJxl+6VVK4QJzr5pkxWtLCfXi2neD6EMM+pheCrLh8NVTkpMMNFJyd2c/pyr70sQJTrvBfp2tNIOnUL42xSZN5LqO9dBYzKH48jWiy0rHuD9FhTe5dlV2PZNOdCggH99feho4JGS8cNkqTVkSCFzCWWqQcRsmSQI0zz4D1oxIRDoPhyNhnMpg0g02VD1VhpWJiKnQVQKvHPu+VkGbhm4KC0lYYCsCpnvFUV6h51AG8u5k9PCqQpPauRNPzQZ8mdEVWpW9ni5kT+clTMTpdICfXAfbB0W2bwfF9R+y5IKraZ+oz+kpcDjoDtuSIlHpaYqsEyDV5EO9H+TinG3tHjMdSwdQZi6vX5neXfJ5RMeXO8YLg8dFJn97GF+QYvNlk2xU8sI9ucO1CRob1EsS98STMFHfh/ZkN8zwP0yIp/bHa75MMPFdnMFbR6bMCQw59rPPoh+XNp4Wg5HL1H3KnT/Vjl2I8gWxtZ81QLxbct0syM80xfkGPJvf8V8SJb5431prZNPS1lNACLPyY+SnggxyB3ks5h7NrP6FaFcL56O292WDlcRCwalPynB1IzQD8Yc61yANhiqbTO6C4FvAJp8YBijRl+VL7o6Wa/qLMFOGO4pGJJbWQC+IM5xHY7ufRB6PlwKo+HDZQWaiuSeu5XmxYtGIVrFClx5jnrueeW/ADjRvTpf4w5cK2qbRI+qE4yoaHKk6U74DATAiE41hnsJfeMfESfsGggiS402KUAFJmxVFxcp3EJ+mvpHoRN5c7BP1vIWYdILfyGFoqjpEzFFTdZuUjQ8KaWp3Ty+pgZij8XMNmqH4KJsITjFRPWVdy9nm8owxjIZ1tAP9pwuy2ZQ6fDWQdc6nPU1mSWPat69n0w7Rz4MT6sHX00Es1/piOSlQ2WOprZQUPYxKxG2w0yTbuOiBGnLTxg6MUk5tRD6hJE8GR8y7hFlOopV/nf
 VD6Il/P5
 oweSqm+4/ywLZYF54e37+5LjpaKqafLFybrmz52BcmV6/Mnvw06/Bt2j7BZWlxlpvdKuryyVBuwltdCxK8e0meMLKgCHHXBj8lYQY5KkBlazFLlmnQu0cgOj4bLNCLyhdrAVv/JtOYWdOTZe7EZ8mfPvMcBQzmIPqO5jWKd5nGn6uo9bZozeOx+1TIOPl85Az2zkLqgbyhY2/TS7UoHQ0W7mzywo+BUfcFfaOVFBRNZeAJXMTG8jXUCXx3KUEiDrhMwTOsKWHHHa/kcd3EDkYAQVD3pLgaoCalg6StQkQIaVo72TC4NRws0u9uXLfrkKqw/U4Gb3XJhQSgqoQMSeSXOffc6B+JJQRxPGA0gHJT6GGkU4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 2:21 AM, Johannes Weiner wrote:
> On Mon, Sep 07, 2026 at 07:01:08PM +0800, Qinyun Tan wrote:
> 
> This is a private ID with lifetime only guaranteed for online
> groups. Reparenting happens right before it dies at offlining right
> now, but this is not a great dependency to have.
> 
> Use mem_cgroup_id() instead and just get rid of that helper.
> 

Hi Johannes,

Thanks for the review.

Right, the copy of the private ID carried exactly that ordering
dependency, and the cgroup ID removes it cleanly. mem_cgroup_id()
it is.
> Both of these functions do very little now and the asymmetry you're
> adding on the mem_cgroup_kmem_disabled() check looks odd. Please just
> inline them into mem_cgroup_css_online()/offline():
> 
> onlining:
> 	if (!mem_cgroup_kmem_disabled() && likely(!mem_cgroup_is_root()))
> 		static_branch_enable(&memcg_kmem_online_key);
> 
> offlining:
> 	memcg_reparent_list_lrus(memcg, parent);
> 
> The root check is unnecessary because roots are not destroyed. But if
> you'd rather not make that change here, keep the root check, and leave
> its removal to a separate cleanup patch, that's fine too.
> 
That makes sense. I'll send a v3 with these changes.


Thanks again,
Qinyun Tan

