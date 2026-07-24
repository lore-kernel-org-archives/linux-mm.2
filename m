Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2662DC531CC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 02:27:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 500046B008A; Thu, 23 Jul 2026 22:27:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D78B6B0096; Thu, 23 Jul 2026 22:27:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 414876B0098; Thu, 23 Jul 2026 22:27:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A7E26B008A
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 22:27:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 977751C02D6
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 02:27:39 +0000 (UTC)
X-FDA: 85022084238.27.40F3B1C
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2DC0CC000B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 02:27:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LF6mDkow;
	spf=pass (imf28.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784860058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FShZWoUeiR8yaTtWAzmWYXgtRV6e+45cRzM/BkLtoQI=;
	b=IqCCrhllZgwatf5fY+TR47FANyruKYRVnOcIAiIMbn/u69jshs5Enc+biHnoZDk4MqqY+I
	lM5JRNEuO3JkMVGM2DrGrfsyGzpQjbODIG4dCfBC6T/980MmNVPErpx3cz3mR9Lgs3joKJ
	/vTd0q/olomePGTpNvZRoPdBCcplRrY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784860058;
	b=vX613zolQYtMGWx5p+LUU8Bu6ytAM3QofEFmX1SPP8CxZ6RNNbrVR/TKeQqRrVLWqkHrs0
	glxhrZEqKnzZaAkqApy3AHZ93l1z//jGXyOiWIMGeQjSAOPVkz1TntENyIlCwXyXh41/Ae
	A7ZgETCl1iwZHUcTg/h/ud3UJwXK3f8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LF6mDkow;
	spf=pass (imf28.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <76a3a049-fbe4-434b-b4da-0b8cdd154141@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784860055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FShZWoUeiR8yaTtWAzmWYXgtRV6e+45cRzM/BkLtoQI=;
	b=LF6mDkowv1vF7N4G2MH4TZH4n1BPDHc8Ace0C+zzJUTppm6NTA+vElOa64uZWamdA9+09O
	5SPw4EM06Q8u7Ww4HhcH0HtFwLcSbypqkY22VyU5tKWveJvjf0av4+lVX5xjUv3QFsCwkr
	Xv9fmX2K8+pHkAVXikdm8yO/kV6Gvwg=
Date: Fri, 24 Jul 2026 10:27:24 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 0/4] mm/vmscan: fix swappiness=max and clean up
 per-node proactive reclaim
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand
 <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Zhongkun He <hezhongkun.hzk@bytedance.com>,
 Muchun Song <muchun.song@linux.dev>, Davidlohr Bueso <dave@stgolabs.net>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20260723045718.2052070-1-ridong.chen@linux.dev>
 <20260723171842.137e45eb36b21b3b45245da0@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260723171842.137e45eb36b21b3b45245da0@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2DC0CC000B
X-Stat-Signature: 87cnfmepphixw1z6wkfa9b7pnjrwktop
X-Rspam-User: 
X-HE-Tag: 1784860057-660853
X-HE-Meta: U2FsdGVkX1/nyu9EiawADWLTLiUYFdlSe9b7/8aRsYLwybMHOVDy+ptoCPQLs5ytfpVsk2aCS35+TSyn5sb5qj/WqWf2yGAjsre4Wc0ZxosHpFxUKaYCK4EMc3ACo34PIRIhN642M6CHT76LbvvRBZDqiRmIrR+dAUfAk0LqYW1wiShyKzjzJ7H+qPhkIwUvwGBfZTEg1epa6jK2sCZcTjDJkfptJ3Aw9U6gD1Zwy9GD+sRGvfoXtLvm+RLeiDByePrpz+0jzoOExKdwx2peHKuz8DGv5A9nR4OltFdFuYsfcfgXWZnXO9xOrWrDFGVPowzqP8kkg718bFtqrpQIs+vMFpxBLZV5wiltV0vWFDyL06MdvZbxrslEZkOEEkK9ipT2vQxse1HfC6VQj+3Wl5kcJLamQyacrM3Lmvp5SV7cYv5fjqfE+NZOBTTMmaG0Mi6C1wtvwpnZnsOJhRQsula3wLQvjzH4LdvpUQyQo+Wz02czN/TVzjUwZRIpw4HRGCqZAlzc0lntjoa/A660FZcBCL1N8iIRPqKyATYijB+hJTKZoDch9XQgredGc4o12zqpGIzO5960HHHkgvx7QEYQ9/vD52ipeVfYilmugdGPAjAzIHlJpdkOQUDqDmSNgTWP/JFMCVwxspcS9MwAXIkWicHZKbaYW+3NuP7VlTG3QwYQMl44TS1teWpsCJ4VOcsDA+ahbBbNmDmE1Pr+JdZAMUMTJG1mCrYFXpsi/wS5tVvOF5j9f83zbydGq7hhqOL1sAZM7vhXZNGXwq0FiP+ZecpyoxBU7fUqeZm15CejOl7QlnTw/FkS/sngfNeq3MWhUliTwfWj8KzlAaWJ0E7ftBSpJzli4ml7rbbBs6zKsm8PNkVP+Xx2xk370NGg6LBVBsH32+iOLZOLRfw0yxMvmlXLiuwjBzg6imjHMnLCWLYtgyPfW+FYbCPmww093PmGN8UneFTSEwHJ6Ng
 aPWY941x
 b/XNUZQhII514HtiZJ6aCDR4zC1tjSVm5AncwLFLWiZ69mDZr5VIyoQiXpB+h9bQsJZGWyYwTTXnCobuTd2CnCd9jyi7qHHD/WtmCk4JM2a2imwDfGInHIrQ5xd3yWag41w8Jp4X5+Q/cO9/kL+xmCWUyQKw3aBvqLrbBYaq+jMpLLwW1hlK4jnpvSPVvWkgVl1dDa1aQyOSgNQQrsukQIt/thjApI9YXFWMKYE/ACmobs+/CUwpCP+7XltV7cqAzb/pBxoNPlGKNh5Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/24/2026 8:18 AM, Andrew Morton wrote:
> On Thu, 23 Jul 2026 12:57:14 +0800 Ridong <ridong.chen@linux.dev> wrote:
> 
>> Fixes and one cleanup.
>>
>> Patch 1 fixes "swappiness=max": the anon-only test in get_scan_count()
>> sat after the "cannot reclaim anon" check, so when no anon was
>> reclaimable the request fell back to SCAN_FILE and evicted page cache
>> instead.
>>
>> Patch 2 fixes reclaim_store() collapsing every error into -EAGAIN, so
>> callers can no longer tell an invalid argument from a busy interface;
>> propagate the real error code, matching the memcg path.
>>
>> Patch 3 drops the now-unused gfp_mask parameter from __node_reclaim().
>>
>> Patch 4 fixes the same "swappiness=max" issue for MGLRU.
> 
> Thanks.  AI review might have found several pre-existing issues which
> might interest the maintainers.  Also a suggestion against your [4/4]:
> 
> 	https://sashiko.dev/#/patchset/20260723045718.2052070-1-ridong.chen@linux.dev


Thanks. I will update patch 4/4 as suggested.

-- 
Best regards
Ridong


