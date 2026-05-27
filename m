Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E875FCD5BD2
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 02:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 267656B0005; Tue, 26 May 2026 22:34:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 218546B008A; Tue, 26 May 2026 22:34:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12E4B6B008C; Tue, 26 May 2026 22:34:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F03686B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 22:34:44 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A0A5C12049B
	for <linux-mm@kvack.org>; Wed, 27 May 2026 02:34:44 +0000 (UTC)
X-FDA: 84811631688.22.44F0FFE
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf08.hostedemail.com (Postfix) with ESMTP id B762616000C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 02:34:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="HMo6EQ/K";
	spf=pass (imf08.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779849282; a=rsa-sha256;
	cv=none;
	b=XtnlWDIS3mnhVqwoxe/R3OtP/d7Vwi2o1lXXalVh/4nl1JeEjJ3huR6lUgWLeVBwEXEj67
	qRA0x5QnfMkoqTvHV+Rz0EDHIwW8jr5dE206EBFt8qk38r8tM//yzww2tAL8STMh7RlkgK
	zy7OsOXYAeX8kHUTUS8VG4udh2O937w=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="HMo6EQ/K";
	spf=pass (imf08.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779849282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9pK/qCFzxhqWb9ZXlkS9Lyl5Svgy0N/OROixrRLPVBU=;
	b=uA5YCO4zXh6USaORebMFWD/2LXogZ+ilSvglc/TX3Aw7dNyb0CwjbFVKdWaRDvfrZWy31U
	2Z+i/cUPbYOzQO8Svm6WcJun1dzZXs9XY342Pi0I3L8y/zAk+HFy5aiUe6lrvW6v08IBSM
	Sd/It6UeepiPQVDmwfAL1CdST8cZG/Y=
Message-ID: <97c2501d-6d11-4a73-adab-dd06b7de54a3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779849280;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9pK/qCFzxhqWb9ZXlkS9Lyl5Svgy0N/OROixrRLPVBU=;
	b=HMo6EQ/Kw7sSi9APQe9F0mSCqt2Biq7ujEmoyMCOlKJeJRB0ttEUtweba4ruvsIk2rY+FG
	te1VnVutGNJ3KVc7vvPXpooYyp67iKDnXuLKiZ9Tc9IAobUF4OvuB/DVcMXLJ1oCw4tGUG
	ZK7gUDcydH5XFaGL1VVNGGW2gjYTTF0=
Date: Tue, 26 May 2026 19:33:52 -0700
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: JP Kobryn <jp.kobryn@linux.dev>
Subject: Re: [PATCH] mm/page_alloc: skip high atomic reservation at or below
 costly order
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com, linux-mm@kvack.org,
 usama.arif@linux.dev, kirill@shutemov.name, willy@infradead.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260519012532.272770-1-jp.kobryn@linux.dev>
 <agzH5BCkTMaK19Tx@cmpxchg.org>
Content-Language: en-US
In-Reply-To: <agzH5BCkTMaK19Tx@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B762616000C
X-Stat-Signature: w8g3474qxnqiixcdsqhder9xzg9dajho
X-HE-Tag: 1779849282-664881
X-HE-Meta: U2FsdGVkX1+8yfujqxwzgEkGnoUfVEaTbm9CgLWD+z8tX+dVHHQozctVbibIlpRyfw5cdSdbHzVsGym7mj3Z3W7w7pPbWVb/DfnGVO+pQEO6dmk3y/XL+9rDFUUtJHP2smdRld+7l38McsJSZDra0EX7LniF4vKHY/6/MO1pn6OtX/h3VK9WRBIR4R6KUFqW+URsY2I33Oo3MfrmMfPiai/53jLxW9KWiuCeAKm7bOBbFRj74w+XZJKc0ZHFdoYkQTf6BjSgrBtP7AKGW0e6EJcgIYCBVhnG84IHUDyWnanQyYYUPW99GZ8A/7NpP/QXn18rleBiSODm91IXHRV5D/1JfAC4dpF4d85SHIL/V6y1u/7n9wrsw/57j8Mlv2gLSyN7NWa6qnCTSWESEP+AuF9A3o57dpCixlbmDtsMEo6XEgrBFsd85irxlvGnDyZJpRVA3AogDHW+dzA1RznHZKtCD1FYcY/44vUUrLCB0qIwiqpdVo0C8EsvXeTmtnJ5YAG60t1Cf6YVU8C6DNluQdK5lqVX+bNOwS2pohcniMQXQqIIg5mYSBgPCW3Bt5me6vliE4/RE0rMPoDYA5Gvuy8ziJ/o64M07kppQONfbaAwIbXcJNgyFUApUrHjXF8DvvkOuApWhTI3WXIXTghmDi7ZXtO5Pg2dpyvN+kkeqGUZsNEQ65T7q18QrB1qwJ32R97inOiPPqhB7Rvm5H2rtq/Bbv06WgoFm2+xfso8+GeAMLHeiqIo+9G0Gdfl/4WLDzIy4LADj1Xsk9W847joQPVzwAuYDY3G1xrmUz0D0yVB5FlnPsX5p/wAeUWZc97TxWsNKWW6I0DLeNpC6jOiT+n1ep14X456RElrwchpysIITNDh8/jHMJQiuTvF0avyNk6UVJjzWs1EgBhV3zt5t3K6qBGuoI/4eJ50ZTqOSn8zdx64/A+f+3TXSJCGqzlWtSM00vycd2h08jDBEKB
 D8ib9XMQ
 cTYCH5mcHBh2bPIUaq2p0LOe9fn3qQFIysFMypahQmrX8C10l+yG504SOEJ4x8P3N4E5nCCdwyw7OBeIX/CIGmVtbH2Laa5oZjG8GZWitQ4aEkBlspPgwhjOEp6axnkRxVZ+F+eRnk0DbI3t0hbz2BC0w7UnZkrH9bFlQwaG5OO1BxQZgBW12OjzOpFcu5RDW0+jdX5LS0cH6hR9oyMKld6bbDI3HQNF92xM5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/19/26 1:28 PM, Johannes Weiner wrote:
> On Mon, May 18, 2026 at 06:25:32PM -0700, JP Kobryn (Meta) wrote:
>> We're seeing a pattern in production where 2MB THP order-9 
>> allocations are
>> failing due to fragmentation and triggering reclaim on systems with 
>> plenty
>> of free memory. Over time, the success rate of these THP allocations 
>> do not
>> increase at all.
>>
>> Inspecting zone->vm_stat[NR_FREE_PAGES] via kprobe on 
>> compaction_suitable()
>> indicated the given zone had sufficient free pages for order-9 
>> allocations,
>> yet they were going unused. Drilling down into the zone and inspecting
>> /proc/pagetypeinfo revealed why. Order-9 blocks were accumulating in the
>> zone's HighAtomic bucket (while zero were present in Movable). THP is
>> unable to draw blocks from HighAtomic since that bucket is not in the
>> fallback list.
>>
>> The heuristic for reserving pageblocks in HighAtomic is that any atomic
>> allocation greater than order-0 will result in the full pageblock being
>> captured. This means that an order-1 atomic allocation will 
>> over-reserve by
>> 256x, a full 512 pageblock.
>>
>> Gate the reservation on order. Skip for allocations at or below
>> PAGE_ALLOC_COSTLY_ORDER. This prevents smaller atomic allocations from
>> reserving entire pageblocks, and significantly helps when THP is in 
>> use on
>> a fragmented but otherwise healthy system.
>>
>> Testing was performed using an A/B instagram workload receiving prod
>> traffic. Each side had ~60 hosts with 64G memory. The patch resulted in
>> several gains:
>>
>> Unpatched
>> HighAtomic pageblocks per host: 309-312 (1% of zone or 620MB),
>> ...all order-9 blocks in HighAtomic
>> THP success rate: 1-6%
>> Compaction success rate: 0-2%
>> pgscan_kswapd (total across ~60 hosts, per minute): ~70.2M
>> Atomic order-4+ allocations: 0
>>
>> Patched
>> HighAtomic pageblocks per host: 1
>> THP success rate: 44-78%
>> Compaction success rate: 24-47%
>> pgscan_kswapd (total across ~60 hosts, per minute): ~29.9M
>> Atomic order-4+ allocations: 0
> This is an interesting patch. A couple of thoughts:
>
> 1. You disabled the highatomic reserve for this workload and it didn't
> seem to matter. Presumably <costly orders don't need the protection.
Right. Although one detail I realize is I should also consider
pageblock_order as well to avoid any config issue.

> 2. Maxing out the reserves is odd. ALLOC_HIGHATOMIC allocations will
> try reserved space first, and I'd expect things that are commonly
> highatomic to be short-lived. Why don't we stop with a couple of
> claimed highatomic blocks that get continuously recycled?

Even though they may be short-lived, the data shows the volume of
allocations is steady enough to keep the reserves maxed out.

> 3. The impact on THP and compaction success rate is pretty
> extreme. How can 1% of memory throw such a wrench into the gears?
Looking at the pre-patched high atomic pageblock counts, that's ~300
pageblocks that could've been used for THPs. They become usable after
the patch.

> Have you tried this with other workloads?
No, but the pre-patch symptoms will show up on workloads where net
allocs are frequent enough to keep the high atomic pageblock count up.
Memory size of hosts involved is a factor as well since it's possible for a
majority of order-9 pages to be stuck in high atomic.


