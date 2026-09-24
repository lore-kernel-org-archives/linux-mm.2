Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70D65C98318
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 18:52:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83C7C6B00A9; Thu, 24 Sep 2026 14:52:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8147E6B00AA; Thu, 24 Sep 2026 14:52:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72A746B00AB; Thu, 24 Sep 2026 14:52:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F16B6B00A9
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:52:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BEE0E4036D
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 18:52:06 +0000 (UTC)
X-FDA: 85249550652.17.F95F4D9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 13D3E2000D
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 18:52:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hmKwra2T;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790275925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8fQuNmR+wyKKa/NE7gKqnglhXs6oXfwgf7LqT0NLqJM=;
	b=zi+PhiqS7uC4VryftFziFzeFLvablBRSCklvV4PHgNs9wESjXwax3/Td099EWd1D6npr4l
	QdIsqR5QLVmgtJLG7U9U1ofSCAaPcq9fibkO1oc930gQNnWOkCMWRrUu9ywoR27Rg19ktb
	OAt1CWQtR9xkVZIMkhYzX5dOC4MEDbk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hmKwra2T;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790275925;
	b=KEwQEKDgsDob0nbt8dXkQ1/+ObAhXKPuzamSFmuS9BAPxkkw6rX1U+cWhR8yUAhLgJD9hl
	X3P9p7U0enVk1RsSk3qv+N9J2x/ZMHp3M1MzQK4zxhWBnHlMfVT+rWDfWhaqmDFuNyd0Yn
	wD5vyJqDNVzmvTeu2THoOoPdEaKM7/c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AEDB060236;
	Thu, 24 Sep 2026 18:52:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E851F00893;
	Thu, 24 Sep 2026 18:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790275924;
	bh=8fQuNmR+wyKKa/NE7gKqnglhXs6oXfwgf7LqT0NLqJM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hmKwra2TGt4NKXHAA/TkRcGPes5yT9c5nvFOd+aZbIBb7FPyc7k5fI9FVjH9eU4GG
	 sODuhzOfxulRS+W1TQ3EiWAHBIdTotMlSZba1Zftbd3TRwCMVH/BoCBE0RnoxRtNik
	 oXOPyebbT1FC9GA19P4NRoEdFGMIwEzKIX/PEN4ZgpKlbbq7Wn06FFrvEdj9QL+WWx
	 MgKLgK3yz6RTLmkPgA8Xu6Vs+paDS02BGoGLXXkQew1Mxmq75NIxaodkh1HOvLTjr2
	 AOtX5ao831YTZLHT9N9YMT57zQXlry8BCfVNNahANt8tvX99YtRVHO8EYnTQok5MF+
	 50pdsWexQGSSQ==
Message-ID: <570cf649-a8bf-4073-be71-207fbb2bef40@kernel.org>
Date: Thu, 24 Sep 2026 20:51:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/3] mm: implement page refcount locking via dedicated
 bit
To: Ilya Gladyshev <ilya.gladyshev@linux.dev>, Zi Yan <ziy@nvidia.com>
Cc: akpm@linux-foundation.org, andrew+netdev@lunn.ch, apopple@nvidia.com,
 artem.kuzin@huawei.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, edumazet@google.com, harry.yoo@oracle.com,
 hramamurthy@google.com, ivgorbunov@me.com, joshwash@google.com,
 kirill@shutemov.name, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, muchun.song@linux.dev,
 pfalcato@suse.de, rppt@kernel.org, surenb@google.com,
 torvalds@linuxfoundation.org, vbabka@suse.cz, willy@infradead.org,
 yuzhao@google.com
References: <cover.1789239015.git.ilya.gladyshev@linux.dev>
 <ebd6540ad89a4bb80e2a62d00901b5c827315b66.1789239015.git.ilya.gladyshev@linux.dev>
 <DLFJL5U9DI6F.3QJP9YP0KX636@nvidia.com>
 <56e036665dbeb0a8f51d697220d5ed84f210994c@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <56e036665dbeb0a8f51d697220d5ed84f210994c@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 13D3E2000D
X-Stat-Signature: z33iaqh4xrc9wi65pktza77u8byse577
X-Rspam-User: 
X-HE-Tag: 1790275924-632912
X-HE-Meta: U2FsdGVkX184patTxI6Madx6IE+dgskZY6hPAYG5jwCpCdA+pPFwgUm81CWDZTMiYVOtLBt4KVBqRzAxO4Y9T1dgKolVbtFZ5hntcUGLzUJihVPx1swx2hRywvmH2ScyoR07M0gSlUGK/VcH/rXzs5Vrgs7VcaFZOCgp+9VBDUtJ0NnGX/xOo+klKDJSBdhOrwdVntAPowTU9VFJvij5jmVyMT8KXt//NAsVRcKWDliheBhTwS5HCY5fY1ZDcKG0x4MYne1VCErF0dvQi36kSS1yLMTe3xkaoWP+IqjJbhkWPFLJr2vSZd1sMK347GoXl1FnwfOI99HMdH+UdZE1AvID7FmM/OCzEfIN0PYG+OOZ0r2dYWPuqDZ7IHY/1/bi71ZZnbQ5wfgK9Z3kJ0Df1W04qNxNXQth5F3vu8cknA/2XZYq44pYbfGkiZ8M+hRU6xFftj97tqU1L8CWehSNdfUsaYBsqu8zojp8eIdrJouM1ZlHjphzDpZchDb6diyKNjXiN8aL5hdSFeyjwEWAzh3VkcQ1BXpH7q+RGF9QuOwg7kPq2D7/X5L6i9Y+z23nEJHIiJlTped6xkRVnyuR/NQ48Mz+HRA5Wq4hay0kdBG/rhoLeFqeY4ZVli5QGcmtNcdLfVaBzKlvd8ZbP4ZMKnEbH0XNxq+STqqGLpNJz1Ulfq7soWFst3Z80PZ11wPfytcBCQG7dbEZ4dyJBFR7sxw0ntNhqmEGQuujhs1Z1/7Tc0sQLtPpeoON+dY/3jVS/vOyAx/MAYTsu6/PceqAympt6pcEglRucxT5taTIZy8OTY9+2PAI92/YI9NXd0pe3WnojXDXYGdgYBgurJQGc8yZvFfTMi11YZNvc+Djx3lr2agV8LAAm4TfFxvTTCTCI5OOOOwLYEdUt55o4BFjyFimQUi+KUBLyjdr2nyj9A4W/q4LVywUYXLNIy6ZfwuJ1BBnCnEKZlo0SFjyFjE
 fOe88nox
 cNs/EWr9Mszp9xXHFvRaj5vT/M4s8iwREf6QVGCZO6eZa35zFnW3Jm4hTNCunWhXKhql1Eh5MpiE4Bic5s6zq15tCqiVXXvlrK3WALpzsVPurXOtbmpgvIC7U1hpLmaRomfXTZ1Y4SfoeUpXPKNAs1Ynm0StugJ/zjBdGh3Pea7id1kVehtDWF2jmg6NRsRGWsEaFRAdfTaN+uKW3mloYFw4Lg3wsji+jMZxsJ8N4xE9D4/C3U5BNJ2DhdioCb58JdG2LroUSgL6xUzJvE/cMbt1sCwrPxOa+m+Ql7vCmWnnPo5iBoYPHj5crmqPZwno4PKMFSA43bO7hkdHGHgm4dPAfVmTGx/VHJqnHzU+/9d0dGQ0KNrgQovnS494cdNO454MjTZyucZI9XFM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/23/26 19:34, Ilya Gladyshev wrote:
> September 15, 2026 at 5:42 AM, "Zi Yan" <ziy@nvidia.com mailto:ziy@nvidia.com?to=%22Zi%20Yan%22%20%3Cziy%40nvidia.com%3E > wrote:
> 
> 
>>
>> On Sat Sep 12, 2026 at 3:50 PM EDT, Ilya Gladyshev wrote:
>>
>>>
>>> The current page refcount implementation uses a single counter value
>>>  (zero) as dead. So, to prevent incrementing a dead refcount in
>>>  folio_try_get(), it fundamentally requires a CAS loop.
>>>
>>>  This CAS loop can act as a serialization point and can become a
>>>  significant bottleneck during high-frequency file read operations
>>>  [1][2].
>>>
>>>  This patch reallocates the refcount value range:
>>>
>>>  (1) refcount < 0 means dead refcount (uninit / frozen)
>>>  (2) refcount = 0 allowed only as a temporary state (see below)
>>>  (3) refcount > 0 is a regular reference count
>>>
>>>  In other words, refcount is now split into "dead bit" and a 31-bit
>>>  counter.
>>>
>>>  Refcount decrement now works as follows:
>>>  1. Counter decrement
>>>  2. If it is now zero, try to put it deep inside the dead zone
>>>  (CAS to INT_MIN). Or you can view it as "set up frozen bit and reset
>>>  counter".
>>>  3. This CAS can fail only if someone grabbed a reference in-between --
>>>  that's okay, this page is their problem now.
>>>
>> I am not sure this works. David raised a concern on V4[1], where if a
>> folio lands to page_frag_free()'s free_frozen_pages(), it will not be
>> properly handled. "this page is their problem" only works if every
>> folio/page free functions call a generic folio/page free function that
>> checks the page type and does the proper handling.
> 
>>> Refcount decrement now works as follows:
>>> 1. Counter decrement
>>> 2. If it is now zero, try to put it deep inside the dead zone
>>>     (CAS to INT_MIN). Or you can view it as "set up frozen bit and reset
>>>     counter".
>>> 3. This CAS can fail only if someone grabbed a reference in-between --
>>>     that's okay, this page is their problem now.
>>
>> I am not sure this works. David raised a concern on V4[1], where if a
>> folio lands to page_frag_free()'s free_frozen_pages(), it will not be
>> properly handled. "this page is their problem" only works if every
>> folio/page free functions call a generic folio/page free function that
>> checks the page type and does the proper handling.
> 
> After some thinking, this scenario is indeed possible and problematic. The
> complexity of the required setup give me hope that there are some implicit
> barriers, however I wasn't able to find them. But I am not an mm guru,
> so maybe I missed something :shrug:
> 
> -- Below is a minimal buggy scenario --
> 
> Thread A: network code that calls page_frag_free()
> Thread B: calls folio_try_get(). Maybe it is the DAMON paddr scanner,
>           maybe this folio was previously used in page cache
>           (however this noticeably complicates the scenario)
> Thread C: user of folio's reincarnation. It also requires destruction via
>           folio_put() and not via free_frozen_pages() -- for example hugetlb
>           or memcg charged folio.
> 
> Refcount operations as follows (FR = FROZEN):
> 
> A: DEC 1 -> 0  [ page_ref_dec_and_test() ]
> B: INC 0 -> 1  [ folio_try_get() ] => success
> B: DEC 1 -> 0  [ page_ref_dec_and_test() ]
> B: CAS 0 -> FR [ page_ref_dec_and_test() ]
> B: * deallocates via __folio_put() *
> 
> C: * re-allocates page *
> C: DEC 1 -> 0  [ page_ref_dec_and_test() ]
> A: CAS 0 -> FR [ page_ref_dec_and_test() ] => success
> A: * deallocates directly via free_frozen_pages() * => BUG
> 
> This can be fixed with a `s/page_frag_free/folio_put/`-style patch, however
> it seems unreasonable...

There needs to be a common page freeing function that dipatches stuff.

folio_put() is not the best future-proof thing, because not all pages will be
folios sooninsh.

-- 
Cheers,

David

