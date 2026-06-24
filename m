Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF838CDB481
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 13:58:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97CBE6B0092; Wed, 24 Jun 2026 09:58:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 952F46B0093; Wed, 24 Jun 2026 09:58:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8691D6B0095; Wed, 24 Jun 2026 09:58:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 61CDC6B0092
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:58:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E2A94140312
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:58:51 +0000 (UTC)
X-FDA: 84914962062.01.6DDCED8
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1D3641C000E
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:58:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DCyXc2DL;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782309530;
	b=x8S27zNytaN805xIuVefgmk7rD76E9V9lMYc60kkMS3tN/WkPLaV/rePtDwjtHtffSBmbK
	yWCuuKmZpl+r2kyHOChjNG+De2ZcQZrSPz3groJWwIe5R077/9fsQvbva/4iMiwQjjq4sL
	d/+owDcplyAHI5NxcLnD+XhBqzpl2iM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782309530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P+krzB/fRPIXJmRo7sPshCRvS8tomogxFOe1laJV1Q4=;
	b=TJvPSpxgakPLFbRnLKK93EXjb5sYalvc6+81xLZx+N107dpEYcKUwdIDXfy63uekvlEgfH
	OLSODBRGh0nInU2s2xTtDfbzqOATQOBmRF4hh8LbuQDsdUolOwpXhx+J6rJwoxLL3iwaCg
	YaWR4HsKepbx5sNrMGNZj+d8MCBr74c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DCyXc2DL;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782309527;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P+krzB/fRPIXJmRo7sPshCRvS8tomogxFOe1laJV1Q4=;
	b=DCyXc2DLiYxBZbHYHiZypoRq6CzXuRtdzU94TSzA6n6GdsTNuCBVE5wLYjrb6rZSufKDPY
	c5wwCLciI1neOVi+KtBNGBdGe+A0lElCFiU7wPfxqJlmrpLjiE6pKNVDfZ50+Ys7SbKU52
	lTq6BWHedR7bvsd/VgxhInujJxid5Ps=
From: Usama Arif <usama.arif@linux.dev>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-mm@kvack.org,
	yingfu.zhou@shopee.com,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] memcg: bail out proactive reclaim when memcg is dying
Date: Wed, 24 Jun 2026 06:58:38 -0700
Message-ID: <20260624135839.2596358-1-usama.arif@linux.dev>
In-Reply-To: <20260623062800.298514-4-jiayuan.chen@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 3qmm751mwzxe4ybfekqbdyr1wyts54ku
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1D3641C000E
X-HE-Tag: 1782309529-579879
X-HE-Meta: U2FsdGVkX1+lZdnz6EXJz68ZKoWdj2H45/XZHETLCE1iTT54GVcfXe2pE8RwN8ij1FiDBo2MCbuL/ykFVnafiVt6W0bPem4YHZv9rUDTsHV7/wLHvliR3k1xPResUiqsrCfDuZD7zWU9wLm+9onC8tY9mHyWHwfjv1vziFBg1anxaUkuXn2a4rcrp6i+zG/YlfsjJOEy3B4KllnCvH7fx9+Bh9GIurNFg3+oygN7tmjPIA1zuCSsZa6NS7l2e3Rgy5l+s6WK4vxbAhJShF437Ped1dSdUJliEc3YNpIG5QkXrLfIabSKyjK+c1GtTi87s7dU9Mg+a968Hg1rQxH5o1MQiFcfhttkfNXB5Y8cPl4DA9n/oDjbIxUmAtHusBJ3zgxf3LS7fSbZTBV/rwbsjrKEHip4Ok4kLY7QrSb2ljHcvp4kSTRhe8Mou/3k3ed2g+4KQffXyThl7+S2OmRBSjQyi+7eqAtQ4PBAh6iD2+wTsqoOo8ydI7+BFaoHwxIr4Vlp5r5jZJlN4kCBIlz4/GsC0NEiGH2T+JGduN/agDD6NAYhKK5wnijfQ7O11zeWIdR6Kyqox99dvP8zAfI9jx9fiTpyiEAMJd946hT78ZDORBQMIlxx5Awvxk8dy+zNESEFIEOtDV+OTtxVF/TeVnq5fK1WRREv8J4E05JjvG0gJtejsu3K7/9rALh8aWI61oIR0vBpEN1V2mbc7qK9PKkG+r/RxfMeiA9Y4wmzpA/4tuGXt351vOw40kRNayKZOmNVdXPB4YWNKxeGgwySqHvQ2G/VppPuvNJZUifvPAVTBXFIeP0sUkHdCwMjkyxYdHorYuUjAUlor97PzoQSdyg7r4fhCJjlP7Xy8U7MCLXakaeb91hd1tJ/B175Fv3WUGvRCgoTgKyKsOgFatkJEB4J42OGNm+d+AZpYf8hsj0bsGhUlha9N2SjT1dMQPnqazdS/UY+zNIAIRKjS8Q
 pkoa+kgj
 kX4AQWXzQUDc/qE9GT5p/x2FQKwg7FC9cqKpUoh+tJz7m0dzoXuzzNqy/IFYuVidaCJ2GjUy7+3Ie0MLXY3HeRMHhmOXEyfJAw5SrR9hD13N7D4Ic6dn7dkKo+CAIrQS+Yzx6lCQDJeVauK1+pH2WPYZwXwdiaH2XwaTsYEKGNB7SEaEF6t4W9BKtmakQiIf6wyhullBO5afGz3FudhX3yYyanaRPbrFQGZVrYopgU02k34XaK+xTButD42pEgyfQyu8x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Jun 2026 14:27:56 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:

> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> 
> Proactive reclaim via memory.reclaim can run for a long time - swap I/O
> or thrashing again dominating the latency - and delays cgroup removal in
> the same way.
> 
> Mitigate this by stopping the reclaim once memcg_is_dying().
> 
> Reported-by: Zhou Yingfu <yingfu.zhou@shopee.com>
> Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
> ---
>  mm/vmscan.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 8190c4abec84..1162b7f76655 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -7922,6 +7922,9 @@ int user_proactive_reclaim(char *buf,
>  		if (memcg) {
>  			unsigned int reclaim_options;
>  
> +			if (memcg_is_dying(memcg))
> +				break;
> +

This exits the reclaim loop with nr_reclaimed < nr_to_reclaim, but the
function then returns 0 and memory_reclaim() reports a successful write.
I think you want to return -EAGAIN here?


>  			reclaim_options = MEMCG_RECLAIM_MAY_SWAP |
>  					  MEMCG_RECLAIM_PROACTIVE;
>  			reclaimed = try_to_free_mem_cgroup_pages(memcg,
> -- 
> 2.43.0
> 
> 

