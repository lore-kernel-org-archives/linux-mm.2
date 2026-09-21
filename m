Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B63B7C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:12:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B62746B00CB; Mon, 21 Sep 2026 06:12:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEC7D6B00E2; Mon, 21 Sep 2026 06:12:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DBAF6B00E4; Mon, 21 Sep 2026 06:12:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 762116B00CB
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:12:22 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 19C851C0086
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:12:22 +0000 (UTC)
X-FDA: 85237354524.12.CE037DC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5953F80004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:12:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="efcFt0N/";
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789985540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nkq4PyU1qKbwQ2e6I0QscIvmJl7UPfvDQHclD5YZt3Q=;
	b=G1oA7RK2y1OBl8MF+zOgc9qQaNfK+NB6cDUqaaUrPr/6F2gvA3PkwR0vUSQBe4BMc4Iuw6
	n29fbFU1hqsaejci1Cz5MIaYvu0diGlwtWVb+VxyUyl7mw6WCrt4J65Ls/ukKAUle+9Na/
	CwP2KyOaXYnqXSivtoMXVg5L9414ZgQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="efcFt0N/";
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789985540;
	b=DvE/zP9zK5zXrbSq5CTjhdo4iwVAK5QmfOtBZ/lj/FKcu7EGvk1bKJStbIqTopJeEIeKNm
	nd+nUABjVAX1tJdjWaEE6Vzki9Ltc52GHJ9Vt5vdLpG5kSPCl6DgvLT2wnPAwNDtQbY6j+
	wmNm+xnVjLYc5yilh9iSppsi3RwQ5Ps=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BF8EF600C8;
	Mon, 21 Sep 2026 10:12:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 575781F000FF;
	Mon, 21 Sep 2026 10:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789985539;
	bh=Nkq4PyU1qKbwQ2e6I0QscIvmJl7UPfvDQHclD5YZt3Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=efcFt0N/ZXrVKnbeXW3FxiDNTCJnNU6T6zulE4Wr6ItwNIoUALG4OVZGNzlHZ16Y5
	 lm3IwiKiJ4w+KakMcu4fkE/pO7AoCvIZvkYs4NuRhPkC3gPkSVEvRtfCi3f6cqfxNb
	 o0r+2iylj4WB4yv5+m771qLQmk40CLSdVFefxvOBkGQk2p/r2ikaSGXzyZRDBYrbnk
	 9suk+BteCmmW9+bMEKrQo2hJPY3HZx1dSnXAS22OjWtmmdojvG8i4DLsItTX2mM2uC
	 cA4x/GDqQWtezfsZcDSFz8UmGNqQp2uSHw1xv+l9ZziajFptMWe8wUbSN51wcsCD/q
	 LfGFkVScqtQGg==
Message-ID: <e22eb6f7-7eb4-4f50-af2b-13a2e3952cac@kernel.org>
Date: Mon, 21 Sep 2026 12:12:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] mm: split underused anonymous mTHP folios
To: Lance Yang <lance.yang@linux.dev>, joannelkoong@gmail.com
Cc: akpm@linux-foundation.org, ljs@kernel.org, usama.arif@linux.dev,
 hannes@cmpxchg.org, baohua@kernel.org, alex@ghiti.fr, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org
References: <20260916224437.1164512-1-joannelkoong@gmail.com>
 <20260920162014.4479-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260920162014.4479-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5953F80004
X-Stat-Signature: mbraenh9wsq5b5ajpdiepdg1aa8drxa8
X-Rspam-User: 
X-HE-Tag: 1789985540-850689
X-HE-Meta: U2FsdGVkX19oedaMojIOK8n68vWBfm9RK93rIO2D7YEuOgPMGVrkh5UF07ats+ZQ+DwhawfTu0mDJwNVnBBTyexXcFKOQOQAXaU3m1fBM0zyQK76ZhRelIlmdbsSmoyWPJgg+jMp4K2tVDX6tM1rXB/v848i7s6XDEx09q01jfcZRT9lPVKbBjOmJia7IH3hgqAD6MBa2PAV3r1GgUX3u2Kp2iSdbwtzgJ+OmcTiV/JrzBic7GwpkP9BY0b2uFTa+mQO28bvSWziQADSporjGsDpM1E/nyX3oV7mdpxkzzqzVwnIKYYX9nFqR1U/3OohSwB82KKepr4+AaGoYimDm8WF2JiY+TBTXsZp3t0ShD2WFAiT1UjPFvFpbnsKDEc/ADKnUt3m2wDYJxTuAQmH5wFqTXdyloqUIjtm+RdJOiQABv8WDbWLYDJbpmxc24p59Y+BxyjhRbo37ll/Kv9giQS/XVxxwRlqPB1uaE4+GiQsdzRm2VPB1lMB3aTVSffqt4StMRHxJE1cOzCkn4i60NrQA8dSTY2ukwHVrM08C4Q2jQyQACbcYnZy4dE+F9ApdKSPRxI7FeyGVmP0zQkNgB7hq/sIXWB0eSRU0e+qGeoP8t1SreBqgPPsiY8qx8q7ndmjoy9zGMF3ynf7TGt5UWdE+CQOJEKMsNOw6ktBJ8a5Is2ZqauDca1RLeBFEANqsTJyK1rAFKl5QYBZsX9ywGYqWzTRYXGXeot95fw4GXB5bw6wZAEVb7l/LFmnuMYBBGwUeDL/XT5j/HX6+7uPYWvYhCoSQx7NZ4g94ciP//LLcqAiP4H/N5Q/jb7zpZuBMAu6Fci15ZYF+qsYTC5EhEL1zsISaTs/HilirblEV+kSyzQroBn0A1KXl26/vebSiAw+8/hlGo9Ve2SmtjDHf2YIWATaQ5Blz0u9nVORF76Kv/7Pq5cIdKC04YbgvVtW61TnbG0GFRw0wUW7dy/
 lFOToMZ4
 k607Sa1NHojxoC36clUzyP0The6u/8aQ3IMooOvO4hP5YiqR/PdifISAGRQ2jg6TYBisqF2Fm9EXME0tIO1ujnbXjVb/Zf1P/DNo+6aaE5c5f9Pgl7vXGRmr9KKvAcscpJUXEbb7kGIFHP1GQyXBd3Je0/AapruEK6QowyeP6K98APGYGcDCElpaV3GWwblxLmfkaJMxIKEGlXheykoIzdiebvfLYc/Wer+LIBACbypqbbmkE/BW5O0nWD/ZNbhR1m+mo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/20/26 18:20, Lance Yang wrote:
> 
> On Wed, Sep 16, 2026 at 03:44:34PM -0700, Joanne Koong wrote:
>> PMD-sized THPs that are mostly zero-filled are reclaimed under memory
>> pressure by the deferred split shrinker, but this is not done for mTHP
>> folios. At Meta we would like to deploy 2M THP=always on arm64 with 64k
>> base pages, as 2M provides the contpte benefits while the PMD size there
>> (512M) is too big to use. However, 2M THP=always causes memory regressions
>> unless the unused portions of those folios can be broken down and
>> reclaimed.
>>
>> v1 did two things. It scaled khugepaged_max_ptes_none down per folio order and
>> it queued every anonymous mTHP folio. David objected to the scaling since

"David objected to the scaling", not quite. The tricky bit is the scaling when
collapsing (creep).

When freeing, I'd assume scaling should be alright.

>> collapse had already rejected proportional scaling as either letting the memory
>> footprint creep or being confusing to reason about. David and Barry separately
>> objected to the queuing, which adds list_lru lock contention on every anonymous
>> fault, and hurts lower-order use cases such as Android's order-2-only
>> configuration. Johannes suggested keeping khugepaged_max_ptes_none absolute and
>> simply not queuing folios that could never exceed it, which addresses both.
>>
>> Read as an absolute count, khugepaged_max_ptes_none also implies the
>> smallest folio that takes part in underused splitting. A 2M folio on 64k
>> base pages is 32 pages, so the knob has to be set below 32 for those to
>> be queued at all, and any folio with no more pages than the value stays off
>> the queue entirely.
> 
> Em ... I'm not sure max_ptes_none should also become the mTHP underused
> threshold ...
> 
> Say we're on arm64 with 64K pages and set it to 16. Khugepaged PMD
> collapse uses 16, while mTHP collapse turns the same value into 0. With
> this series, an order-5 (2 MiB) mTHP enters the deferred split queue
> because it has 32 pages, and is considered underused once more than 16
> pages are zero-filled. So the same knob means 16, 0, and 16 depending on
> where it is used ... That's a bit odd ... no?

I very much prefer scaling over using absolute numbers as proposed here.

> 
> Would a per-order value make more sense here?
> 
> An unset value could preserve the current behavior, while an explicit
> value could control both mTHP collapse and underused splitting. That
> would also give us a way to leave max_ptes_none as the legacy fallback
> instead of adding more meaning to it :)

The problem is that: we don't want any new toggles unless unavoidable.

-- 
Cheers,

David

