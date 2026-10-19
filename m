Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F356CCF2E3
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 14:37:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82AC06B0286; Mon, 19 Oct 2026 10:37:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DC686B0288; Mon, 19 Oct 2026 10:37:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F2F46B0289; Mon, 19 Oct 2026 10:37:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 367C66B0286
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:37:46 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9A2F31206E9
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:37:45 +0000 (UTC)
X-FDA: 85339629690.10.14A2B8F
Received: from mta0.migadu.com (out-40.mta0.migadu.com [91.218.175.40])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7583B140009
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:37:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f97OAP5B;
	spf=pass (imf26.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.40 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792420663;
	b=6yefZiG+FH8qmR0JN0wQZdUVXey9tHgI+UcrC+v00zyhH0LMmKGiM0LLDrnmbnotmfleGw
	57qvsc4GnHBv69rHXYh7C7o/EgZY09m+JBwTSFfr0gKdTeFVn8Ufu7IBqwFO2CsD7+drNX
	HauOI603L/xsnatNzM8gEzTwGa1yi5E=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f97OAP5B;
	spf=pass (imf26.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.40 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792420663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yznd5my65H0ybOhYgA48NtuU+2YbkhDlCksdNM4BT7A=;
	b=15kVeqb0JdWLofAVv9xwEL5ZN8j0arrAS0giMEneLvit4ip/2POXzbSF3nmrsFvRdEcqZC
	hvsA7BwS8tMO7/UKxbuyLX2b/vo0Ziq59c4HywD8/K8fVNO10H5sIIDGJaKz7+C72HQYcf
	iIC7w6rH28GX7Cee/6QC5lxbBsSXSuc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Pdl0oIvnemB8EPi3eJVtyka3qkkaZD8i9MNNRHe/YMY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792420662; v=1; x=1793025462;
 b=f97OAP5BN7Wt/TqBKXZRCA//6c9Vt0KGOvJycBfzIt80H0n1wsUgg0mf5k3n9iUig8jc7QlD
 M42qC81bKrpiVdEokef8iqFz9r17pyESMGyjNTYFrcqWV+UiSavQsAqJirFSmzTl0ZbN4kL6Xty
 5tRgr+UM2Jgn5ipJrBwh4rVc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 87511d3e1b116c5b;
	Mon, 19 Oct 2026 14:37:42 +0000
X-Mizu-Trace-ID: 87511d3e1b116c5b
X-Migadu-Flow: FLOW_OUT
Message-ID: <4f361479-1dbc-4f09-aa26-e1ad6c06cbee@linux.dev>
Date: Mon, 19 Oct 2026 22:37:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-next] mm/swap: free swap cache folios the zap path gave
 up on
To: Nhat Pham <nphamcs@gmail.com>, Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 linux-kernel@vger.kernel.org
References: <20261014090821.227366-1-jiayuan.chen@linux.dev>
 <CAMgjq7D50X47JFsTnF2-jYGv7i-Nd3WhQLK-TJGy4XkhMQU4OQ@mail.gmail.com>
 <62d17959-d695-4fec-a87b-8eadaaf995a8@linux.dev>
 <CAMgjq7CJ+bwKgwUmCzO9Hr7TrL68bDjgAsLx-4AGuXo6zowh9g@mail.gmail.com>
 <CAKEwX=O4sPx5MtGL4-JwLzD4TWm7fNycFMiuOqLk4ADFUUipNg@mail.gmail.com>
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <CAKEwX=O4sPx5MtGL4-JwLzD4TWm7fNycFMiuOqLk4ADFUUipNg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7583B140009
X-Stat-Signature: qeirkifpr9m4cqgikbixupda63kpuwxs
X-Rspamd-Server: rspam01
X-HE-Tag: 1792420663-731148
X-HE-Meta: U2FsdGVkX19c/GDIbLRM8hR18P0tVwvrNcNgia65cwDl3//Zdk3Kgx0vQNp/5+z6w1Q+zeX1xh5XLv9VPJlQHv/qPs0nuDuk/DBeKBG2dfP+JeNuj2V7wtXKEQWZfDllAyM++PUWHraK71gPBylvMOjpVVxy/daKJxA3E7SzUPv7XyCfMxAj+0hqi9C24IO57v0uhNTzGP9Nh3nTUaTqbip+r8lY5pfUoEz93PQ1yIG3BKSPtNDuPcmyEmfqM39Q60EcEt/rW2Bi4D34lu07izdJD4H9DmgOuv1hgNFQrXnhprX1G9jezMthbV+maOvTMJvqmWuwCz45cPCJuln4hNiKH5D7G4cPhov0CtM9orS5JYnH5malSeX7cVaD+f5Q+1aThJIordXMsSQi9hoW0KeD2WCzzrvESVQw3y4TsWLPONNO6jvJr2mrxraKqnH78o/Miqv32190MySOUsSfWJ6reaa53BkE0UVQmnoHOyQdXDI4TI6B8QqwY08/OZZcNglnT7+VNEkbZPrRLHjYOqi4NpjxcJ9n+uesfldV1YUwReZ+rzxiA43F3XWcLmL14Sr21qskxSRC2Keu1HOuN0RNqgHoLvOL72jSKoPhIDhP9lbZIPz85qfS0VA51ZP2INDUOc5N3YhVIi3Lkb+D1Er4WXQaODsu25X4tw2SvUzf6GnL6kOo+e0KbWYXqI+OVkiqlk5OVZ4X+5qETC3c6enRhLB1IrSEWCZOZ0nrCwHvAHrwuKTDI7Gvqr6bdMwYv8O0FSrGIxrznw23cjALmlx1Jm7LQa1kL4J/7HXxjeljaHgQJjeQ4rFZc9vXOu/Mo6gJEYp5aP47Zf0U923OK8zSBaAMcI5sjXGjxTFRhSXOPIHFCG+glFnr7vVBddM/Im6vTsmJksNXHdLFj3/FMsy4NaTR9OIJ8cIH2sEN1XY7GoseLi0e+yEyEZiK7capk8aCLI1xbm/P5Wbeakk
 3NFq+uT2
 N8XPCA85GumzmdaP8KXtKVmat66iO93m4TGgi2CJaCIPtHMl7i1mpNBlgEfPGlG4VhtlPnv53/fkE5fLbc2JhF1CT+hchZKymdWzjJ3lxOM21RZfvBWMHo28aFz8tzyrzMBaIuP+H+4WJpkdn1YOP3ShieHP+8wnxZgtaL6e+hR+2rH7QjSyHTQU3sJHTi80g1VTHzfNZ/88qvki5NSwmYVEXDVKmsOBdw9vp6xKupDX6KbYfrAUcQZ8xVeh8EPxx2IUz2lqujfQPy4rTCHtNt7OZNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 10/17/26 3:28 AM, Nhat Pham wrote:
> On


[...]

> /proc/meminfo | grep Swap
> SwapCached:     489006260 kB
> SwapTotal:      976561148 kB
> SwapFree:       487554888 kB
>
> cluster_alloc_swap_entry() picks clusters from nonfull_clusters first,
> then free_clusters; it looks at frag_clusters only when both are empty,
> and at full_clusters only when vm_swap_full(). A cluster gets onto
> nonfull_clusters in partial_free_cluster(), that is when
> __swap_cluster_free_entries() frees a slot in it; after
> alloc_swap_scan_cluster() has used it, relocate_cluster() moves it to
> frag or full.
>
> A leftover slot has count 0 and a folio, so __swap_cluster_free_entries()
> never runs for it. Once the live slots of a cluster are gone, nothing
> calls partial_free_cluster() on it again, it stays on frag or full, and
> cluster_alloc_swap_entry() doesn't pick it until the device is half
> full. That is what the swap table looked like after the run:
>
> list      clusters   leftover slots
> FULL        106415       54484480   (all 512 slots leftover)
> FRAG         44822       18471614
> NONFULL          1              0
>
> Making cluster_alloc_swap_entry() revisit those clusters means changing
> the list policy.
>
>
>
>>>> Or, from the LRU's side, put swap readahead folios at the tail. I'm
>>>> actually trying to do that and it's not very easily doable at the
>>>> moment but will soon be easy to do.
>>>
>>> That helps the RAM side under pressure but doesn't give the slots
>>> back.
>>>
>>>
>>>>> Options considered:
>>>>>
>>>>> 1. Fix it on the readahead side: after the read, check the swap count
>>>>>      and free the slot. Covers the lock, not writeback, and the
>>>>>      asynchronous read path unlocks in the bio completion where the slot
>>>>>      cannot be freed. Two places to patch, neither clean.
>>>> In fact, readahead checks the count before starts the read. It should
>>>> prevent some of the problems but seems not enough.
>>>
>>> Right, the count is still 1 at that point. The zap drops it to 0 while
>>> the read is in flight, after the folio is already in the swap cache.
>>>
>>>
>>>> And another idea, what if we just add dropbehind flag or rotate the
>>>> folio, if folio_try_lock failed in __try_to_reclaim_swap?
>>>
>>> dropbehind would work for readahead and writeback if the read
>>> completion honoured it too; today only folio_end_writeback() does, for
>>> zswap writeback folios, and swap_writeback_dropbehind_folio() expects
>>> the folio off the LRU. It still misses other lock holders (migration,
>>> split, ...). Rotating only helps under memory pressure.
> Yeah might be worth trying. You'd have to modify readahead and zswap
> load logic to check folio_mapped() etc. I suppose...
>
> I'm not sure how reliable it will be FWIW. There is still a race
> window right? Albeit a bit smaller - the readahead thread might check
> the dropbehind flag before __try_to_reclaim_swap() sets it.
>
>> Right.. But I think it will be much better to avoid such folios from
>> hunging in the swap cache in the first place instead of having a
>> worker to reclaim them. I'm not strongly against adding a reclaimer if
>> other approaches are too difficult at this point though.
> Also, IIRC, dropbehind can only be handled in task context, right?
> We'd need to make readahead bios to complete in task context
> (BIO_COMPLETE_IN_TASK). I wonder if this has any perf implications.
>
> Another idea: how about, in swap_read_folio(), where we are guaranteed
> to have the folio's lock, we check if folio is mapped. If it's not,
> invoke folio_free_swap(), unlock, put, then drop that folio from the
> submit batch?

At that point the swap count is still 1; the zap comes while the read
is in flight. Checking after the read works for the synchronous zswap
path, which I tried first, but the bdev read is unlocked in
swap_bio_read_end_io(), in interrupt context, where the slot cannot be
freed.


> That takes care of the readahead race. Seems safe to me
> (I assume if a folio is not mapped and swap count == 0, then it's a
> pure readahead artifact, but maybe I'm missing a case).
>
> The write direction already tries folio_free_swap() before submitting
> the writeback, FWIW.

Same shape: the zap arrives after that check, while the folio is under
writeback. On our box with a swap partition that is where most of the
leftover came from.

Every check on the holder's side runs while the count is still 1. Only
the zap sees it go to 0, and it cannot wait. That is why the patch has
the zap hand it over instead (very nasty i know it :( ).


> So that takes care of both directions. But who
> knows - maybe we still have a small race window, and that's bad
> enough.

