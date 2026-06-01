Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 394E7CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 13:22:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B8BE6B039D; Mon,  1 Jun 2026 09:22:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8901E6B039F; Mon,  1 Jun 2026 09:22:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A6306B03A0; Mon,  1 Jun 2026 09:22:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 697836B039D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:22:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3D84B1A06BA
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:22:25 +0000 (UTC)
X-FDA: 84831407850.11.7045CCA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 879BA180004
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:22:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LU6AW3wK;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780320143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WDT+8+ETf4Oj92XwVc++A5fr+CCglKoLUu0D8KimQ84=;
	b=P8HUWT0X91klSQWslMqWn/SWly39vWEGiraUx9TXIEx/Kz49Gm5CAXOtKHZRDvIG1aUCmh
	GvFL8s3kLxEXJzOBma6jQ/iHIxTJc+0gjJrkSC8j6JW8pDQntf0m6D2RDnA+PnEyQzM5iC
	hlH1VZ6kSlQX9gtfAUKPyWuBKJFZy4Y=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LU6AW3wK;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780320143; a=rsa-sha256;
	cv=none;
	b=fQ9JsbSew6Wzgiey84T6MGJsO9W5dfKEpQTw8RXhzWF1DbEKfCk5K3LORI0X2YC/NxuF0F
	c7YlYexP1JturaxxK+bjcN1drVhGEWYthNmXQz8rrOybxTpwuSdTAthlnaE/mvYJl5ur8W
	wa/dKJHgoLf5qXbyiSG8E1q9CdpNJTs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E9BE760126;
	Mon,  1 Jun 2026 13:22:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DBE31F00893;
	Mon,  1 Jun 2026 13:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780320142;
	bh=WDT+8+ETf4Oj92XwVc++A5fr+CCglKoLUu0D8KimQ84=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LU6AW3wKuu8SCk7DkUOYOGjAikqXBQEAcRgbGOhMTZuzzL/jEjz6W1NAmcd6J71nD
	 f1J9yPoVcNbopDcXDC/tRcytt3DWozJFC9hp37ufoeat0oPOYbTnmMQuustGcQE3Jl
	 PQ4S5jvRVPvXPa5T686eyp57lLX/9XOLhfmd+hvxtNThxOlIsz+ycJGq9VmnAeVdCa
	 p53tUKhy7GipyNvMCP3/OESrPe2OjXaHKvEbJoFGg0onrA/I81UnFMddcqeSHXxXdK
	 IWJiln4pvPHWl61ksfS3UuHn5NoD/Fb5Hyo1PX5J8sBDZjYxsOycLs822PbzqdfcIb
	 8USWAXGFgogGg==
Message-ID: <e3d023f1-ab6e-4424-b304-55f1294480c3@kernel.org>
Date: Mon, 1 Jun 2026 15:22:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/6] mm/memory-failure: surface unhandlable kernel
 pages as -ENOTRECOVERABLE
To: Miaohe Lin <linmiaohe@huawei.com>, Breno Leitao <leitao@debian.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, kernel-team@meta.com,
 Lance Yang <lance.yang@linux.dev>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 "Liam R. Howlett" <liam@infradead.org>
References: <20260527-ecc_panic-v8-0-9ea0cfa16bb0@debian.org>
 <20260527-ecc_panic-v8-2-9ea0cfa16bb0@debian.org>
 <19f968f5-1289-f573-4406-e5c91dcd8923@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <19f968f5-1289-f573-4406-e5c91dcd8923@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 879BA180004
X-Stat-Signature: b97woccrrho9ykp1ujkf5tz3azpw5czn
X-HE-Tag: 1780320143-528793
X-HE-Meta: U2FsdGVkX1+IBl5hK0M7/QD1cJKMFg3Oep0bb4JVuks4J2aLYf2iD3sixSGvot6D3c4PGiwEKfOkEK8zFYnCFDIrQCfx7ktu9Jfkp3Imq+RzQf+BD973AUjCMxLcodQeXxoHfHfwf9im2ShDRtmhJtTMB6HqjlIQ7hMb6vH5RBMBhp+Lf5130423Gf34L4QFMB2DlX1JocTC2ZkvTwZKmPr6P9rAtgIQEEHoOowD1J1qFqOVKEJy8SOSQme9bX7+yednVt1ZwxDhXf6oECZfP3pyXtdLfsssF3QvP2VVgPkmzC8vg4/Yh2fVSu4G2uNOFJz/Um9Z9EmwmAPj0kBDO4qoSUjhXGrkQWz4BhjMQGplVAcJx47fjW6s5blMuA0Rp3FyGctsAjhtRlyrfd1S1vi+Ub/Mo6NTBl2TZZ/SvDW5ZPsfJM2mC7w47S9JAvLTMnXW6b7Ks+dmm4+GMtmO7RPnQxFIaeZBlcUzJ3L5oVRNrqDC1tispse38+pzU1s5pcHmAFaHA1+8YZK9cJio6SbLFOf3tGt/FCQu6ioQZKxJh+6gvvOKldZ++pqFA/w18TelJLKegichjmqr3dWBx4lzzOXb26CUVgXnsOHkb7q3b9auZ7WPpYBuvhwAf5SAHChx4l/IbNhPKe8XujAcij/iZ4ApSdPtOXU9MxilXRoX85hsTP1RFZOmCyADeXW7WcrUN2B5kIKx4qv9U4FelE5aQ7qzDnAe14GX3tQHJRx3GGNfBtpCBnJYV6kHw2P1N+Sfuv+S2FzJyHPW9TAYlZRUQLR8X4R1R1v5K0Ng+t8Jy/rrcztEZ/QKbr23CrNHl+8UWcAdrj1zZUO4fumNHJxQLugjSXGkaSHFD0zFpWGm8BPBMQSgeOVIhEAb8GZQfy3WeJk0gGSt9eLCAdq5BYQvEBmuEospUoRpdvQ773+hBEUp/oOvd9QIQb4Kq2f3/KsEcQbK0e1YmxX98xE
 D7sNoFA0
 HLtqqH0r00pE9xYhLfxmkWjMSlFBXg+2Rr6kckQhQ/pu7E1OGH1djl0skHmCrPHUxzo5LIpbBiid6XofZh2euRYktsDTT0uVBulBojayECwsVNBV3spSfNox1XjX2BaEzniuIvhlm7S3PPkbd135vXLVHF54CbAnL5qS1gqEkchd4yVF3dmiwzySyx7i8kNoOZtl7cftV2w/imbvbvVXZePaGvMGHBwzeqtQjUIw9owlVp6Tg7QCVSX2CmmVgq5HWxJg0tsvjk+UIvcPy4zD+VfPVRV1jve4RiydZvaIlPamF6f6Pnfuq5vgf/VnAqepGEzGwWFMQOyOw94rcNjqwtTDOi6l+DTKxw6a8+4bJapsBVXbtEZpi+PvHVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/1/26 14:28, Miaohe Lin wrote:
> On 2026/5/27 22:06, Breno Leitao wrote:
>> get_any_page() collapses every HWPoisonHandlable() rejection into a
>> single -EIO via the __get_hwpoison_page() -> -EBUSY -> shake_page()
>> -> retry path.  That is correct for the transient case (a userspace
>> folio briefly off LRU during migration or compaction, which a later
>> shake can drag back), but wrong for stable kernel-owned pages: slab,
>> page-table, large-kmalloc and PG_reserved pages will never become
>> HWPoisonHandlable(), so the retry loop is wasted work and the final
>> -EIO loses the "this is structurally unrecoverable" information.
>> memory_failure() then maps -EIO into MF_MSG_GET_HWPOISON, which the
>> panic-on-unrecoverable sysctl deliberately does not act on.
>>
>> Introduce HWPoisonKernelOwned(), a small predicate that positively
>> identifies pages the hwpoison handler cannot recover from:
>>
>>   HWPoisonKernelOwned(p, flags) :=
>>       !(MF_SOFT_OFFLINE && page_has_movable_ops(p)) &&
>>       (PageReserved(p) || PageSlab(p) ||
>>        PageTable(p)    || PageLargeKmalloc(p))
>>
>> The MF_SOFT_OFFLINE / page_has_movable_ops() opt-out mirrors the
>> same exception in HWPoisonHandlable(): soft-offline is allowed to
>> migrate movable_ops pages even though they are not on the LRU, and
>> we must not pre-empt that with an unrecoverable verdict.
>>
>> The list is intentionally not exhaustive.  vmalloc and kernel-stack
>> pages, for example, do not carry a page_type bit and would need a
>> different oracle; they keep going through the existing retry path
>> unchanged.  This is the smallest set we can identify with certainty
>> by page type.
>>
>> Wire the helper into the top of get_any_page() to short-circuit
>> those pages before the retry loop runs.  On a hit, drop the caller's
>> MF_COUNT_INCREASED reference (if any) and return -ENOTRECOVERABLE
>> straight away.  Pages outside the helper's positive list still take
>> the existing retry path and return -EIO, leaving operator-visible
>> behaviour for those cases unchanged.
>>
>> Extend the unhandlable-page pr_err() to fire for either errno and
>> update the get_hwpoison_page() kerneldoc to document the new return.
>>
>> memory_failure() still folds every negative return into
>> MF_MSG_GET_HWPOISON via its existing "else if (res < 0)" branch, so
>> this patch on its own only changes the errno that soft_offline_page()
>> can propagate to its callers.  A follow-up wires -ENOTRECOVERABLE
>> through memory_failure() and reports MF_MSG_KERNEL for the
>> unrecoverable cases, which is what the
>> panic_on_unrecoverable_memory_failure sysctl observes.
> 
> Thanks for your patch.
> 
>>
>> Suggested-by: David Hildenbrand <david@kernel.org>
>> Suggested-by: Lance Yang <lance.yang@linux.dev>
>> Signed-off-by: Breno Leitao <leitao@debian.org>
>> ---
>>  mm/memory-failure.c | 42 ++++++++++++++++++++++++++++++++++++++++--
>>  1 file changed, 40 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>> index f4d3e6e20e13..8f63bdfeff8f 100644
>> --- a/mm/memory-failure.c
>> +++ b/mm/memory-failure.c
>> @@ -1325,6 +1325,28 @@ static inline bool HWPoisonHandlable(struct page *page, unsigned long flags)
>>  	return PageLRU(page) || is_free_buddy_page(page);
>>  }
>>  
>> +/*
>> + * Positive identification of pages the hwpoison handler cannot recover.
>> + * These page types are owned by kernel internals (no userspace mapping
>> + * to unmap, no file mapping to invalidate, no migration target), so the
>> + * shake_page() / retry loop in get_any_page() can never turn them into
>> + * something HWPoisonHandlable() will accept.  Short-circuit them to
>> + * -ENOTRECOVERABLE so callers can panic on operator request instead of
>> + * spinning through retries that exit as a transient-looking -EIO.
>> + *
>> + * The MF_SOFT_OFFLINE / page_has_movable_ops() opt-out mirrors
>> + * HWPoisonHandlable(): soft-offline is allowed to migrate movable_ops
>> + * pages even though they are not on the LRU.
>> + */
>> +static inline bool HWPoisonKernelOwned(struct page *page, unsigned long flags)
>> +{
>> +	if ((flags & MF_SOFT_OFFLINE) && page_has_movable_ops(page))
>> +		return false;
>> +
>> +	return PageReserved(page) || PageSlab(page) ||
> 
> Once shake_page finds a lightweight range-based way to shrink slab, slab pages could be freed
> into buddy and above PageSlab test should be removed then. Maybe add a TODO or XXX here?
> 
>> +	       PageTable(page) || PageLargeKmalloc(page);
> 
> I'm not sure but is it safe or a common way to test PageReserved, PageSlab,
> PageTable and PageLargeKmalloc without extra page refcnt?

Checking typed pages in a racy fashion is fine (PageSlab, PageTable,
PageLargeKmalloc).
Checking PageReserved in a racy fashion is fine as well. TESTPAGEFLAG() will
allow checking it on compound pages.

For PageLargeKmalloc, we would want to check the head page, though. The page
type is only stored for the head page.

So maybe we want to lookup the compound head (if any) and perform the type
checks against that?

-- 
Cheers,

David

