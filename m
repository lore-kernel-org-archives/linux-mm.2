Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C397CCD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 18:41:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37CD96B0093; Tue,  9 Jun 2026 14:41:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3547A6B0095; Tue,  9 Jun 2026 14:41:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26A9F6B0096; Tue,  9 Jun 2026 14:41:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 168216B0093
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:41:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D2D4BC26C5
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 18:41:36 +0000 (UTC)
X-FDA: 84861242592.21.E5A88A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1291EA0016
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 18:41:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="n/s/LF6J";
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781030495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rRqUAdkAgr6Ypp8Su6+2n5PtsOSqMs20GrK0aAXdiU0=;
	b=i6dpP/2IDmW/snZ6+sU5FXCKugprJoKgDYQVthvtXQt3dmvUAqvUirfBGBiCNvD4jCRtAm
	WGxeG1jyxFjps1XeBQawulhtDLI5/ritBfFEJI+Z+BBVnDQcJpF5qthq5hRxtVAX6tIdfu
	l7wx0giuvOSGLTXM1FaTBTPuc8OPPMc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="n/s/LF6J";
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781030495;
	b=4G4E8R1BqiJiDwN5qVUb/bs6uOxQ+vcd14ytBH4Qa/Zh6O+lPsGqh5h2XpiH8Sfu3Vfruu
	Ms6+mjta5Q36kNyIxUtfpJdEVRKUrrp/a+C7aSWhYd+eHsRQaeEIRDgXQa5Us4w2PAHTtD
	B8nH5KpkqrTNpcM4eKo3+kb48ED0GDU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D0E86024D;
	Tue,  9 Jun 2026 18:41:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A02BC1F00893;
	Tue,  9 Jun 2026 18:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781030494;
	bh=rRqUAdkAgr6Ypp8Su6+2n5PtsOSqMs20GrK0aAXdiU0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=n/s/LF6JEqwIWKt9Q7XElB33dDXdgS/LPOJVRmRcwWm5MAB6i2lkrwfbAhA0gfTx+
	 59NfwWG2KwBDmUOV6bsAfxSArZcFcKV/SvaBUmia5LCaZ2W7892C52u+Z++06W3dCi
	 C6/ZSHM+j2i3qfGcqTHnuo0H3xgWvHlFCel0FC0751zl6BUXxf8XZ3j5MpyPEp6p9I
	 zwFfXxt2Z03iYrdd+7P/RBEy/Qe1jPd2NSesyYWhKUw9wu1wMX3EAziFf4gQ/LvBPk
	 35cWOxTQwJ7vG4cyGBIvJewYSa968HRt1WkEKYwHe420u5TmWsPPFerMxQRedNug1m
	 CrKWll7YTrRgw==
Message-ID: <cf2bb24e-9341-4ded-b238-064dca442a92@kernel.org>
Date: Tue, 9 Jun 2026 20:41:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/6] mm/memory-failure: surface unhandlable kernel
 pages as -ENOTRECOVERABLE
To: Breno Leitao <leitao@debian.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, lance.yang@linux.dev,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 kernel-team@meta.com
References: <20260609-ecc_panic-v9-0-432a74002e74@debian.org>
 <20260609-ecc_panic-v9-2-432a74002e74@debian.org>
 <174b8d76-5514-4942-af5d-c975ff95ee03@kernel.org>
 <aig7jzwDHfVCxikl@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aig7jzwDHfVCxikl@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1291EA0016
X-Stat-Signature: tpaofzb61qfzqbsgcc3nyyf39mpaqysu
X-Rspam-User: 
X-HE-Tag: 1781030494-692268
X-HE-Meta: U2FsdGVkX1+Dcim8toNKHZUK4zDGxvByYL9i4qxZ5FjkXkObLfQsnlNQcfk/iPegnu1Gre4TADqaQtJviF9br1sltjLHy9XzNff5BuxemKxPa89uRkf4McOr3XX4e097qrXfwWw8BYgqVU/tm8OPEdMk2sNZuEX/zn5FSGK7iVJrg+O8FMgnZIQcJr9gPL1rnN7hf1cy/BiJUDnkp6h27GHJImwCWTJqgLSzxqB2v7Rn1c5GNwWre5ebF0H2yIbzuAa4Ce2jt9DejdVCnIL3OUogpUCoZVSSANtU20o9nYYxmv8FGQ7stuiZja0MWtxXmQ1qasdqNh0pCI+r/vYW6z/w4QHJKj5vFxTAOESI7UdLHktvO2p3phHVfu2pz77X96/3WExY86H0Ny1mxoboLzKXGZh4nNmbUHlqnSH6pMHKONYaXVIjIAzV+bULcDpxNimjEBHqpk6epJJFPF94UBSdyRIID90CmLuzycG4Ixh1lGxVafm4pPFFtxq7rwXscV+2/wGZMUEExZe1vh89TMo34JKVcOYHP0iA1Ulj6mvMptimqMD7kJ2XcKLiyIX0HMUoTyNx5XVrH0lIew/OHIiJtqxl8tatcVycsaGeqZNSPg0AFaeNsYVJwh5ZMOjLwyebU/HbktY2uqyKfvtGt6Y8X0XywDInaAFJuHKymjljXbhE47iam6s3LjYEh/zmupCcQG5dTM3iQ3bKUtvb9om6uhy+FM+p2WG/wRyf7rYNB7EMfzQw6zy7pUOovuGCVqlMpxfEc0KAAKB/1ubUTID6tlCmYtM3+1h9vHtBwXUrozBbP+H0h7Uefn8YeYJvTaUIDuSbq5scfA6dADuFeptffKWWFgR+iJJXRkqHMTC2y4jMlAIV/m6Qhebo7E4YrqPIWPYr7dDtwN78OoP8ZcKUDxgCeMzEg2rsMORnKzbITlf6yXorycaTiQAl//iLhsvOsP5nzqXTwb3T5f/
 WX5Rp/+c
 zaOQoXoceTHm2n0TOq8sNGweCMMtSWF+h1Fp9/AwnlEmisgtQbmiw3jnmptQWFBoOOC/KFN8+e8of5cPH/CeT8v3pHo+AgfonxJE2IWls3F8BbTzTOsVQdTUHQnn+Yw/FUVl8cq76h8fDveyiRzYK4Tglydcmg13OWoeJbI2VsBMF3mziHJtsCEU++CAmXqTyNJloK+0q7ror0Aoi+2rHCTMvhMNi5/HJ3EnLWyHyuDyLjB3CUNTml/8G7r5a7O/pzYwuCH9vn59luOfGDJa5vLpnaAPYoeu3j6UPZeAmK/LyCzRJ6aAmqexYbvrkazr7nrEA7iiaIm+BXCvgZKozgIXalrKC+JlBDiwn9KoI/pKVf7tuli28CF0jMa7F3kcRNoDG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/26 18:15, Breno Leitao wrote:
> On Tue, Jun 09, 2026 at 04:41:01PM +0200, David Hildenbrand (Arm) wrote:
>> On 6/9/26 12:56, Breno Leitao wrote:
>>> get_any_page() collapses every HWPoisonHandlable() rejection into a
>>> single -EIO via the __get_hwpoison_page() -> -EBUSY -> shake_page()
>>> -> retry path.  That is correct for the transient case (a userspace
>>> folio briefly off LRU during migration or compaction, which a later
>>> shake can drag back), but wrong for stable kernel-owned pages: slab,
>>> page-table, large-kmalloc and PG_reserved pages will never become
>>> HWPoisonHandlable(), so the retry loop is wasted work and the final
>>> -EIO loses the "this is structurally unrecoverable" information.
>>> memory_failure() then maps -EIO into MF_MSG_GET_HWPOISON, which the
>>> panic-on-unrecoverable sysctl deliberately does not act on.
>>>
>>> Introduce HWPoisonKernelOwned(), a small predicate that positively
>>> identifies pages the hwpoison handler cannot recover from:
>>>
>>>   HWPoisonKernelOwned(p, flags) :=
>>>       !(MF_SOFT_OFFLINE && page_has_movable_ops(p)) &&
>>>       (PageReserved(p) ||
>>>        PageSlab(head) || PageTable(head) || PageLargeKmalloc(head))
>>>
>>>   where head = compound_head(p).
>>>
>>> PG_reserved is a per-page flag (PF_NO_COMPOUND) and is tested on the
>>> page directly.  The slab, page-table and large-kmalloc page-type bits
>>> are only stored on the head page, so those tests resolve the compound
>>> head first, then re-read compound_head(page) afterwards: a concurrent
>>> split or compound free that moves head invalidates the just-read flags
>>> and the loop retries.  The lookup still takes no refcount, mirroring
>>> the rest of get_any_page(); the recheck closes the common split race,
>>> and a residual free->alloc->free in the same window can only mis-tag
>>> a genuinely poisoned page, never reclassify a handlable one.
>>>
>>> The MF_SOFT_OFFLINE / page_has_movable_ops() opt-out mirrors the
>>> same exception in HWPoisonHandlable(): soft-offline is allowed to
>>> migrate movable_ops pages even though they are not on the LRU, and
>>> we must not pre-empt that with an unrecoverable verdict.
>>>
>>> The list is intentionally not exhaustive.  vmalloc and kernel-stack
>>> pages, for example, do not carry a page_type bit and would need a
>>> different oracle; they keep going through the existing retry path
>>> unchanged.  This is the smallest set we can identify with certainty
>>> by page type.
>>>
>>> Wire the helper into the top of get_any_page() to short-circuit
>>> those pages before the retry loop runs.  On a hit, drop the caller's
>>> MF_COUNT_INCREASED reference (if any) and return -ENOTRECOVERABLE
>>> straight away.  Pages outside the helper's positive list still take
>>> the existing retry path and return -EIO, leaving operator-visible
>>> behaviour for those cases unchanged.
>>>
>>> Extend the unhandlable-page pr_err() to fire for either errno and
>>> update the get_hwpoison_page() kerneldoc to document the new return.
>>>
>>> memory_failure() still folds every negative return into
>>> MF_MSG_GET_HWPOISON via its existing "else if (res < 0)" branch, so
>>> this patch on its own only changes the errno that soft_offline_page()
>>> can propagate to its callers.  A follow-up wires -ENOTRECOVERABLE
>>> through memory_failure() and reports MF_MSG_KERNEL for the
>>> unrecoverable cases, which is what the
>>> panic_on_unrecoverable_memory_failure sysctl observes.
>>>
>>> Suggested-by: David Hildenbrand <david@kernel.org>
>>> Suggested-by: Lance Yang <lance.yang@linux.dev>
>>> Signed-off-by: Breno Leitao <leitao@debian.org>
>>> ---
>>>  mm/memory-failure.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++--
>>>  1 file changed, 58 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>>> index f4d3e6e20e13..eed9de387694 100644
>>> --- a/mm/memory-failure.c
>>> +++ b/mm/memory-failure.c
>>> @@ -1325,6 +1325,46 @@ static inline bool HWPoisonHandlable(struct page *page, unsigned long flags)
>>>  	return PageLRU(page) || is_free_buddy_page(page);
>>>  }
>>>  
>>> +/*
>>> + * Positive identification of pages the hwpoison handler cannot recover.
>>> + * These page types are owned by kernel internals (no userspace mapping
>>> + * to unmap, no file mapping to invalidate, no migration target), so the
>>> + * shake_page() / retry loop in get_any_page() can never turn them into
>>> + * something HWPoisonHandlable() will accept.  Short-circuit them to
>>> + * -ENOTRECOVERABLE so callers can panic on operator request instead of
>>> + * spinning through retries that exit as a transient-looking -EIO.
>>> + *
>>> + * The MF_SOFT_OFFLINE / page_has_movable_ops() opt-out mirrors
>>> + * HWPoisonHandlable(): soft-offline is allowed to migrate movable_ops
>>> + * pages even though they are not on the LRU.
>>> + */
>>> +static inline bool HWPoisonKernelOwned(struct page *page, unsigned long flags)
>>> +{
>>> +	struct page *head;
>>> +
>>> +	if ((flags & MF_SOFT_OFFLINE) && page_has_movable_ops(page))
>>> +		return false;
>>> +
>>
>> On a second look: Do we really need that? The page types below never support
>> migration. So I guess that check is not required?
>>
>> Apart from that, looks good with two comments:
>>
>> a) HWPoisonKernelOwned: this is not the common style for us to name functions.
>>
>> is_kernel_owned_page() or sth like that would do.
> 
> Ack, I will rename it is_kernel_owned_page()
> 
> In my defence, most of the functions similar to HWPoisonKernelOwned()
> has this name format, and I got this discussion earlier (with Lance?
> I think). Here are the similar function names in that file:
> 
>  * HWPoisonHandlable
>  * PageHWPoisonTakenOff()
>  * SetPageHWPoisonTakenOff

Some of these probably date back to our old way of handling page flags and
things, like PageLRU.

But we really should stop :)

> 
> I will update in the new version.

Thanks! Probably best to wait a bit, the merge window is coming up either way,
so this will have to wait a bit either way.

-- 
Cheers,

David

