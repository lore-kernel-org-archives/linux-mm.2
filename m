Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F046DC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 15:42:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0084D6B00AD; Wed,  2 Sep 2026 11:42:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F22136B00AF; Wed,  2 Sep 2026 11:42:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5ECC6B00B0; Wed,  2 Sep 2026 11:42:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CAE7A6B00AD
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:42:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5893714028A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:42:14 +0000 (UTC)
X-FDA: 85169238588.03.B3DF645
Received: from mta0.migadu.com (out-199.mta0.migadu.com [91.218.175.199])
	by imf22.hostedemail.com (Postfix) with ESMTP id AE81FC0008
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:42:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SlqLN419;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.199 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788363732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ymb3X9991WuCnhvzTfNSuyLn/F8xlBWh2xI22inucpI=;
	b=d98GVgSf1qAEWZ0SBQcFGazRngyxC+Z+cojNrmD2cdNVHbtsXF6TJgSUEcQ4aQPOqbpZtW
	4NJBbErcted0HMRklYtRJuxb0x3GAEhU7hmNKpsGreUntHik12/pRKCjNbXT809mo8K1ce
	8+gEUjiogvLrbQvHdEVHyaUVg8HWaZE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SlqLN419;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.199 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788363732;
	b=BLSOUf2Kl2DgKTRPKonYSG0IELIZ8Yqmz6gJhCAkeV7U0qNPm93+EEUeoUDfkTWBBOHMZR
	0LGtr6+QvQcH8V4fA7xn9mEHUiOIMqeUfMgs2MrAe/hegEHacY6pePh5U7Lm2JPE7MYiud
	7fId0PbCPoYZxZKOWntcsoLibIyltB0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=oQAtHMDdxLMd+IseQsUdtJ1A0k1c1Qwn3qdXWbS3Pqk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788363729; v=1; x=1788968529;
 b=SlqLN419V7SAOO7h/q10ToEfqiyIKMDWnOdnKgt3nykFlWoPEYGDqVyh4B7NVSjDZhVuzjxu
 GGZfg8V5A83a+Q9rMQOsxZ0bDoWFk9AsIM53ZWjLZb0z8k04ReVb0nMTHbJQ8ewdSbSv0dVI4bA
 r+5lGc0xunNsHGxrMj6Tf6o8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6b5cc0fcc14a6291;
	Wed, 02 Sep 2026 15:42:09 +0000
X-Mizu-Trace-ID: 6b5cc0fcc14a6291
X-Migadu-Flow: FLOW_OUT
Date: Wed, 2 Sep 2026 08:42:07 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Ridong Chen <ridong.chen@linux.dev>, Lian Wang <lianux.mm@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH v5 1/6] mm/memcontrol: move the lru_zone_size sanity
 check to the reader side
Message-ID: <aphDtvu4xDCW3cOK@linux.dev>
References: <20260902-mglru-flags-cleanup-v5-0-9db761d779ef@tencent.com>
 <20260902-mglru-flags-cleanup-v5-1-9db761d779ef@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902-mglru-flags-cleanup-v5-1-9db761d779ef@tencent.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: pqiey9hnownomsa17yf3bn6893zigp3k
X-Rspamd-Queue-Id: AE81FC0008
X-HE-Tag: 1788363730-80410
X-HE-Meta: U2FsdGVkX1/yCH0olH6sRb9JRreUCsHEP//Xp1O6/wX2TWwQGkJeuGXpWm25gEIp5zdIB+W0JcSrTEpOa1y83xiVFJKO9gBSQVI5AY9PvJlHRr/6D7pUGA7p44r1f2xgeDToaLVBXASaarpxbo0LqsSculC9GKbvt6Tw3jZDhBUxOt/GYvfj2qD7O9ab6AlTaqPzwlMxOBrV2ZZ0yDLqSKvHLa9h5D2d102+nd82hlUeErts0oQWF/7Zufcqnirq3TUue7vts+qhUptyKxMCUEjIL9y1/h4NNsbPFeZJCXxiic0zSxiy4nigkVqU7aqCZnPvbLGdEa0hLOR5t6UgNzEqP0Ib/1hHNWorN3HLDLTE47o5RBez9ABSLpXjP6Nvj1/MbsCTS3w26YoAxcj19RbyuoufL0hc8CbwBJBWDbuIuJ3FhSXcH9BgyvW0JT4FUYpHIw2Z4WVhzI/rNwgVmyfjnm7JCv3NjeZGx2kvjntt8QA7ZfOF4JWgIcOZ7UpusBiGQBWSWDA/46JLJ03Cn60XT7MnqXAvcONxsz0gVG7Rgn9Sq4Ew8/knGB64HSomZwUVCq/I8wRiCSu+puWVeuEU9nl7j5h8AlnN5CDfiVyBAGelAqvvy19XvbMIpYhQCTHjiHtJuDVzniELA5zRoeaESazcgS/udFFIV6xZJaWKu5c7xeBBLatbxaB7JZPWGdjs15TVBmlZ2B2GGDn1MModxqJnCqGo15N0vIcKqLzw/LtMI90ShLskFQ6AefcZQlbBEzRVwxtWcn6FNa+oookXA0YMb9DKcLdMZVvqmGT2oXk7tjLbkEriP/gK8f4sceXfPiZUl4b+p2ZeRwYDJXI+LegzVF0eOZa1K8u5DPgNDGEkNBaKB+wh2MSxun1dDFuo0jmgWEjWUa4BYNOfaRnlpxvIFtqWdQR3rUO9wwkBfMr8B1tXbqmjRmgSNWEbyKUsSsJ1t3wneBVc5C2
 Bzt8r7NH
 B31+z5usVKUtbODuMWamdZFKlLLz9UuB6RnwpNkTLP4Itnq9o5YU8jVHwX05FbWXDzdanOXMQ7m9heiceM08BbpD6RZI6ixG8Jagv2Ci0lsyzmvy06QKYppZ56LeR6VlxTB4ZSglWk0rIoF1CPq+/IYhIco0ncNbZP3muWwRL4+RlsxcR84E75pFIn5tyo2zMhNUTZK6VG2cF+N4gugMucp0i5W4RgdloSe8a9mFaevMR6YPXZfdQl/HG/dFw8O8m/kdxTBw4V04Smw/U70Jh9xdbNvO9a0IeWwGHV6otF/RC2ZukN2l7j/hswSVFnpf2vglQ5zVsuIWIBCqGvYEPNTMZaGrlVYUb8BJgaHMDijgXOFA9NGxJtoZj7DlxagBB2iHvBIZ5FpI2jf78AHeHHYGQMRRDknUGNe/wrGzDzrrCqYMArL2HJ5fcw0LkMMG49j6M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 05:50:54PM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Instead of using an unsigned long and checking the counter value at
> the updater side, turn the counter into a signed long and check at the
> reader side. This reduces overhead and simplifies the code.
> 
> commit ca707239e8a7 ("mm: update_lru_size warn and reset bad lru_size")
> added a sanity check for memcg counter underflow: lru_zone_size is
> unsigned, so an underflow wraps it around and returns an enormously
> large number, then the memcg shrinker loops almost forever as the
> calculated number of folios to shrink is huge. It also checked if a
> zero value matches the empty LRU list, so the positive and negative
> deltas had to be handled separately. However that emptiness check was
> already removed by commit b4536f0c829c ("mm, memcg: fix the active list
> aging for lowmem requests when memcg is enabled"), so handling the
> deltas separately is no longer needed.
> 
> The remaining update-side check is costly and cannot really catch the
> leak it is after anyway. It runs on every LRU folio, and if a folio was
> removed without updating the counter while other folios remain on the
> LRU, the WARN only triggers much later, from a likely innocent
> callsite. While readers are much rarer than writers, only the reclaim
> and reparenting paths read it, once per batch.
> 
> Checking at the reader side instead leaves the update path a plain
> addition, and puts the warning where the value is actually consumed.
> 
> Note this changes the behavior on underflow: the correction is removed
> and a negative value is kept. A massive leak of the LRU size counter
> would indicate that something else has gone very wrong, and one should
> fix that leaking site instead. Besides, the original behavior might
> cause false positives, or make things worse if the accounting happens
> after the actual insertion: the value is not leaked, just delayed, so
> force-fixing it would cause a bigger problem. The warning now only kicks
> in when a consumer actually uses it, in which case the reader gets zero.
> 
> Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

