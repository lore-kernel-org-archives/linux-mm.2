Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2134606A329
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 08:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YPZN9+4+
Received: by kanga.kvack.org (Postfix)
	id A9E626B05B3; Thu,  5 Nov 2026 03:02:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A77DC6B05B4; Thu,  5 Nov 2026 03:02:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98E2B6B05B5; Thu,  5 Nov 2026 03:02:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 648186B05B3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:02:31 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D2D581C4357
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:02:30 +0000 (UTC)
X-FDA: 85400323260.10.9D7CED2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2ABA72000C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:02:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YPZN9+4+;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793865749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DIr4alMJwbCTc5F0ZtfHQta9OEDwuGDlcSYgoMpOMGE=;
	b=Z3Mj8gJFKAOs9dcttTKDsM8LFT+XPm3jxMjZP+OmWQyudhUbTgJ+vcS44923ThRtNZqJA+
	sAEv1Rw3jyXRyoMUvPPzDAYCnB7i5HCm4mq7GeyUwUNtd5q3YIzx//2k/CI3gmg9iajxy8
	0Zf3sn3jGILyNy7ahHpk3Nq37uqnugE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793865749;
	b=2u9wkCwtemAkqYf3y2FqR1Vy1c6a3SzTNBKqYBYfm3BjpNx+qDwmgdKSH42c6GcvX+pHeQ
	1q7Zr0hCdrsPJoH1L9LlP9uQXCC0BAxitYifZxgLiKbVTBJr9qBTUbo9eLKjmgT4RbTEgp
	k4cMZCfCUmBXQnTEoGnQZwsFntFRUZM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YPZN9+4+;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 869A2601DE;
	Thu,  5 Nov 2026 08:02:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B7A1F000C1;
	Thu,  5 Nov 2026 08:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793865748;
	bh=DIr4alMJwbCTc5F0ZtfHQta9OEDwuGDlcSYgoMpOMGE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YPZN9+4+QaSqB4nhCcZSMQFpKZAnZ/PsWyoNoIOi0FfJwpb8mPYXaLtS735LYU4nQ
	 KOvPb1AY0aBBU/yqmmg+2mNrwpdTtfrTR4rdgciSOs2239zShUtklUtl4GM0/MaglJ
	 0XnC242gfBtznYbhCm/HymQr6eMfQIatjRaU8fxViYYp66t48TJzNenlKyfRdsfBfF
	 1bWCI1HcYo0db7r1+OyN+VwE6Fi0Whf+N8AtV0z0JdnJv8jZYF/TZtd/4W5/x1b7mv
	 RYLOBYtbgA+QtHefWrD0uy5LBiuMBH0yXqxUEqJ0qUJJkvQwcGAheVARxXCR9dhuQz
	 9jwsPnnxpHn7Q==
Message-ID: <76431b4e-27b4-4922-bc59-bf97516b40fc@kernel.org>
Date: Thu, 5 Nov 2026 09:02:21 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm, vmscan: make kswapd unreserve highatomic pageblocks
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
 Johannes Weiner <hannes@cmpxchg.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, JP Kobryn
 <jp.kobryn@linux.dev>, Frank van der Linden <fvdl@google.com>,
 Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261104-kswapd-highatomic-unreserve-v1-1-38be5106adf5@kernel.org>
 <75540cfc-0577-4d91-9369-d1c4fe9c3096@gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <75540cfc-0577-4d91-9369-d1c4fe9c3096@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2ABA72000C
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: brwqq8me1zjkbg46jxf6rg9m5kzs1xzx
X-Rspam-User: 
X-HE-Tag: 1793865749-482099
X-HE-Meta: U2FsdGVkX1+qiBAYlWX5NTB2cx3CBNOlARiLJ1LDsQjQkjqdvLVLVnQzf8Ktj6j2vp6FQzOKyul+t9cPSayFcjC88KFtjm7ihhcGMPIaeHXSf5fgrpGj3EMS08vWHl8sFBzSwiD2lMl5ikQqAJrtojAZB38AHodI4CeRiYP87UXQXi4N95j/ZGilS4U4yQD3qSb/ueauF6GLKEZLgPAZGN8nZtrsm7S0yVuO2CnZxDB7q8XTl1KoyTpWKVDv9o3r9Wr6Tp9W3W+AZpHvRHVtg2r7405MDhi3c7htsB7esyMOZQbEDUpjnL8TGCF2ceeSvZ3S58I1XQNVCGNvGgjjs19r5tYJLhv4Lb5wmozSdkZTZSIPmftG7QUewlS4wOQRjN7TiF03Uq4Mat3kJ+MEPaPBDR/m9+u2ytubuBOREO9V4idmrW/wAAoJSEmRyQOdoGIpKloOWVLm8rGHsBpa/nCzSReUnFBR/NPmr4y0zPls4O6OcpR2ccSnZYylswFba4uJMtcS1eftcfBEZ7qIlvH3Z4jUv2PPKCZvs8mj33hYLjriCoZ2zb5oU6ZpeeTsCUSbgWQ19+YZEhtwY2epWmWRhyQqRzu6roQdptsEZEs3+QYU8GuXpSqkZq71sq0jGQnrc0R+BRvIObZ2mzs2FoDOle0xVIde/H0sdEeKGd3Y20b5KRB3/yfCo0v3RHTP9d5lr6jubDrlfxo1cQWqn3sZGLByYAy5n6XRnA4m0hFgWrTRzazsvIoeHsQadnkw5itTUisyV5oF3ugJR7A8CpVCNVhh7csTclX6d0lKN407aVuFO5cZlYXvAfIW2L/EazyBT2+hc3a/BKMLQKyk11mHOdveFS24mwGvuKG0kcVa2VDZQp0RB2I5esH7WG/8shjItGRPRAVmLkHTVV11GpJ1p9HmcqytFcGMJ1y1sSeCs3s9N9Z+JCI9miSawQVZCLiIBD7IdDEAct9wWoj
 3GsFVE04
 368pBSsnhlZgunaITsaXyds69b7mE/zcJTj84N2G8tJsAGdp1NJ20UqiA8Ks+3nwWjv4NBV2QFiFtTbsSuBOGlbdZUg/+BtbV3mT+Rj82Pku8P3rUr2zZMn81LgqQzU0RSHSKfoUgvJRDzUUf29fU5caAmctGaHbWK1kmv080rp+TEpCRvVTLDOW+gWHNtav5/rukP+K88AdYvW0xolLB/o95VkG53piXJBLE+Rpq32C9rMckY05GNOTQTG2dIblrS3kI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/4/26 22:56, Jose A. Perez de Azpillaga wrote:
> On 11/4/26 7:38 PM, Vlastimil Babka (SUSE) wrote:
>> Hook this highatomic unreserve to the moment we are increasing kswapd
>> reclaim priority, as that is when kswapd is struggling to make progress
>> and it should roughly match the case of direct reclaim failure.
>> 
> 
> isn't raise_priority true after almost every pass at DEF_PRIORITY, stuck
> or not?

Can you elaborate why? At least at first glance, kswapd_shrink_node() should
return true if it scans the requested amount of pages. So I would assume
that although balance_pgdat() will do multiple iterations to reach high
watermarks (because every round of kswapd_shrink_node() will limit itself to
SWAP_CLUSTER_MAX per zone for sc->nr_to_reclaim) this should not be raising
priority if the rounds are successful?

> [snip]
> 
>> +		if (raise_priority || !nr_reclaimed) {
>> +			/*
>> +			 * Similarly to when direct reclaim is retrying, try to
>> +			 * unreserve highatomic pageblocks on the node. Convert
>> +			 * them to movable ones as kswapd doesn't have a target
>> +			 * migratetype, and passing unmovable should lead to
>> +			 * least permanent fragmentation.
>> +			 */
>> +			for (int i = 0; i <= highest_zoneidx; i++) {
>> +				struct zone *zone = pgdat->node_zones + i;
>> +
>> +				unreserve_highatomic_pageblock_zone(zone,
>> +						MIGRATE_UNMOVABLE, false);
>> +			}
> s/movable/unmovable/ in the comment?
> 


