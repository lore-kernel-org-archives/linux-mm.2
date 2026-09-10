Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8DFEC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 13:13:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B206A6B008A; Thu, 10 Sep 2026 09:13:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF8516B008C; Thu, 10 Sep 2026 09:13:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0E876B0095; Thu, 10 Sep 2026 09:13:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 724106B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:13:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 90511C04F5
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:13:40 +0000 (UTC)
X-FDA: 85197894600.07.925C301
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 574CC100016
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:13:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hqAwcaXh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789046018;
	b=Yw2e2Ly+XGK9EKY4+IW7ukp4FXJ5nh/7TyVugqblRYlonIs/nsDs/YLxUirFGJ23lUKOWB
	fsKccNtHWPzNcqpn8YLUd+CWtTo5Ytw6l4ej/hcJ7SPMhEq5ZfgeoJCCn/Wh9qVbE3qURY
	HyT+ZqrO7Mgj1fJOm8+C2Rxmvw4aCfw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hqAwcaXh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789046018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M03ebMR2GKtikJbVp9or77lbtsT5C8bLQjQstJD9IH0=;
	b=oWZeTx6Eb5rwcKdvvcD0Q8CR6r0qovG7n0HCYDuFPu59vymYRMWBejc9m0IZcaQivXhy1o
	GAaVb9Hv5bzaGgMNL1+XYqoexIHWb3V8wpup3EbvWgNdgJ8m4dpoH2Ot0q2MTVMuwLezga
	61KI+RfRJaBun5SEhnwmUm/WWXUccsA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B1FD43C7F;
	Thu, 10 Sep 2026 13:13:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416C01F000FF;
	Thu, 10 Sep 2026 13:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789046017;
	bh=M03ebMR2GKtikJbVp9or77lbtsT5C8bLQjQstJD9IH0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hqAwcaXhDzP+yYjnbYdR3g1bT4aceHrBAgY/kWg1c2IIMDwKU8Dgoyl3FeIJskkTf
	 q9lQ+AoPFumCh12tvrOwwxIFYJkwL3mcZ4HAGeEqLYBwvHMersfljYsEowmwE1lFrk
	 VODA8neke1SK7KST2MZMFJe2YpE5Gahxjeh+dlaY7GEAK1AWkDja4ZZuApeVWqcvBd
	 EYbr5EzErcvNmYtl0E6fS2UGEH3S5A08tlBbh/9j15OIs4zI/SJKUrQL1LL9sAbM6O
	 6by5bkxMXZgcEWraEFa/Nv8Yhy/HYlw16OWa3sUwHiDwqGYnvDQZfrC0yh5bjex3Ky
	 K4gqbtwTJv+kg==
Message-ID: <ff5ac35e-1dfa-483c-82b1-0e542a850550@kernel.org>
Date: Thu, 10 Sep 2026 15:13:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/12] mm/sparse: move mem_section init to
 sparse_extreme_init()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Oscar Salvador <osalvador@suse.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org,
 driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-1-008fc8d579fe@kernel.org>
 <aqKnDa6ukWwAXs19@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqKnDa6ukWwAXs19@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 574CC100016
X-Stat-Signature: mde44cmoa11rmq5h3x8idx7ra8jgkwgq
X-HE-Tag: 1789046018-764363
X-HE-Meta: U2FsdGVkX18LltcFpYczWHm6FV84j+cAOfccwOVWDL0yy9VYNCRVAWXVgZ3Ukhi49nv0cmjxX0PIJi2TxPxk5lj+o2NR7090M6lYPgZrdupbVeIyNoxg2AV8BTVUSPoatbnJSN+z1YNhbF8tcJjjzbwnNBBd2m83a4gUOBP1pDCAwqj8Ik5EL+lkzeLtSGSNWkQqnSzWFo+ZolbFdDCqScOJNtq6uxzBtTKBZWqFX/+PXQ9qyadYrQLEKqHS5oGhTE56xUoqFVGG0UWt9S3HPkerATfj4wNz8qGx1pvQjiu8GmJSmf16glfaFCcgfN2Hz8C67Y1QBB77KKVZ7uLJIRRFd28M2CuP9FzPCsbAKKfa/SrzjNu4iwp4TlIPDwqIOg1X18RXPEVNQt1bpOOQ4iel8xVihbXDS/W3qNYKOw5cfwJdctK+tcqz6JzOt3pUwx7o0nVm2YABCp6V6GTy1Vfy08gKV8e/nU3ldRBvSTpjYfn/vSxEuKguGgv4nl0NeqkGe0Ujtmt9ZJH9nkaa5KessLtwu8XSOvTeM5Mq4pcCniHwuzUpIdwKRsQyMQ0O6YlJ+hU3JgM0wZQ79mt1sWgz2OPkDN8DQDmuBBMZL88z4sj5RmVqWljU/+KCCjfY8dAMxV+Gnyuv2Y2U7PNLOfvL6fUp8609gOFiDRKXZrGgC4B9h0GnhC3GLbSC3SamYjI49BaMtpf62bNCHUHrpMdKoroonl8mMrmxqZdGuhLA6iBHyuE1sDpXWeP20SZorC4hxd/CkU2uFK2W15XkllPIKBvleRWleHbKwZCEat6mChIT/iGKa1yU4SEr5/sLJ60wOGGwqK7X4qR2MLnG+8AjG8riUJGfCD6fvTuCQdmJM2Usf0PYrA814NfvCsbfhuGfM8akXL9JS3PbNnoQOKvw4xlzb+kg3c25lzEcfQSVBatDMR7rnY5wCP8V2po3+wCE0JpN3o1UmsHQD92
 XqNi7eKd
 c2NUfihIdHGmjuNvKg+/Fu50UtbJzCLKUnJ00Ml+emegSQyVPpLXj6octaO2A/csJQEjaXHrrmPM1huznzIS7jc7HVGeDvLc4qYtrHNu7k6O7dMXR2kw5p99GgYycRJ9kcxOyh1KWbxfi92xvMYBeqPZrk1HOfYVvAy0hnapqZ/e2BiI+9zOxw2C7YC5CqVCVvawlS6eJRnYBFpkPY2OSyqwGenM+e9EV6DNUMoY+HeIujgqmbe9eGIbIIE/XCc0pGqop/Q68xoHN2gGdumNJEYWv12XexDPxjJwseW1n71Uj/RVLyS3xKYKz/W/QGrtJnaZJezXLDE4jL80=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 14:52, Lorenzo Stoakes (ARM) wrote:
> On Wed, Sep 09, 2026 at 03:32:54PM +0200, David Hildenbrand (Arm) wrote:
>> Let's just avoid another pair of ifdef inside a function. While at it,
>> switch to INTERNODE_CACHE_BYTES by just defining a fallback in cache.h
>> as well, given that the x86 variant already provides one.
>>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> Nic ecleanup, one nit below.
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 
>> ---
>>  include/linux/cache.h |  1 +
>>  mm/sparse.c           | 19 ++++++++++++-------
>>  2 files changed, 13 insertions(+), 7 deletions(-)
>>
>> diff --git a/include/linux/cache.h b/include/linux/cache.h
>> index e69768f50d532..b6e857b985bca 100644
>> --- a/include/linux/cache.h
>> +++ b/include/linux/cache.h
>> @@ -89,6 +89,7 @@
>>   */
>>  #ifndef INTERNODE_CACHE_SHIFT
>>  #define INTERNODE_CACHE_SHIFT L1_CACHE_SHIFT
>> +#define INTERNODE_CACHE_BYTES (1 << INTERNODE_CACHE_SHIFT)
> 
> NIT: 1UL?

I decided to replicate the existing

arch/x86/include/asm/cache.h:#define INTERNODE_CACHE_BYTES (1 << INTERNODE_CACHE_SHIFT)

If the shifted value would ever not fit into an int something would be 
going really wrong ;)

Thanks!

-- 
Cheers,

David

