Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCEE9CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 07:29:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DD486B008A; Mon,  8 Jun 2026 03:29:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08E746B008C; Mon,  8 Jun 2026 03:29:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBF456B0092; Mon,  8 Jun 2026 03:29:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DB5FA6B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 03:29:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7A4F3A0A09
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:29:47 +0000 (UTC)
X-FDA: 84855920814.18.78D8422
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id BF55D180003
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:29:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iWU1n/1v";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780903785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ix+o2luyIJ8fd3BbrUCJ3EpMfGnVYFgPUPESUwRjcmc=;
	b=valZBQ9UzswELVbAEZ39GCQfsqQC80wwMLJ4PRqszmPe26Odt4EF84adES/V72CsOf+5wW
	UfWRpfTWQD5Qi887nd2ocQQdop2MzzazjWc8W95LQStGRZsxGPthk+jLc6pK7cbk/cbvqn
	ngvBh0gYyUvRkkCHV5gbIoRtkUr8f5M=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iWU1n/1v";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780903785;
	b=r3f/9nTZTXsckP7JEPDd/+BZ+SIP6j5WqqXmOw39x2eiSTzXqoEs+EWprmURyOXZaqIGKc
	VNU2CSz/g5kCC6Xa00V7Ju0l/PaG46I/ynNJMbfST4fIR6UmmSXh+469DAETNk53VZg0eb
	7rOnkfT583Hl9cIZdOQf0WkUE7Zbzu4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 355AB6001D;
	Mon,  8 Jun 2026 07:29:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD191F00893;
	Mon,  8 Jun 2026 07:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780903784;
	bh=ix+o2luyIJ8fd3BbrUCJ3EpMfGnVYFgPUPESUwRjcmc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iWU1n/1vrRmqh0JmZv+whbB9usIHKqW+/tkhtI8O4Vvcky4fbEdPce/pVD4COljJ9
	 UlhJkcklaMEAZyZ/qSw1yU4urpML0ZbGz7pNJPzqLMQiVklbQfgFhNsRkDu7cNuPYo
	 OVj44jVRxTIU5XSN7WmLPpsFCZ+q6yYtLPPUwkE0WFiGTTlxepAboKhUxARrhe39PP
	 DAVtlWRaArnowXpIGKwUS3rtDhijwbluhFNHry2Lc1XqE46KeWUlb01DoBTsS0PxCw
	 77J+lo7gPWbX7RT0uT5LqpJ918wMDRiDoUmMG96gPNyu9CJwY5nqm94nbxMsGeT+s7
	 pgjc3j/AlqGOg==
Message-ID: <31ba1950-8d08-44b3-8183-58f1e179f0e1@kernel.org>
Date: Mon, 8 Jun 2026 09:29:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs/mm: document slab cache isolation with SLAB_NO_MERGE
Content-Language: en-US
To: Matthew Wilcox <willy@infradead.org>,
 Mohammed EL Kadiri <med08elkadiri@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@suse.cz>, David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Jonathan Corbet <corbet@lwn.net>, Kees Cook <kees@kernel.org>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260606155856.15548-1-med08elkadiri@gmail.com>
 <aiSAuP-qEhH_RoCn@casper.infradead.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <aiSAuP-qEhH_RoCn@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: oo9m848ysq5y8y5bxaikkbt9guta1mqs
X-Rspamd-Queue-Id: BF55D180003
X-HE-Tag: 1780903785-360869
X-HE-Meta: U2FsdGVkX19oegjo62FtDSKcHtaNexnKm5QqVGZl1igb4F3pPVjDhLVG7koD3InzdP6Fyo+gu1i1cT4VkTc/+QPRD2/FpITLsOzXbLt7znRky1XUf2/+pBuv+UkfBfaXz/jJ2f9nmTzgHoFTmJ5mVJB5bcfsa++jb8LTdVWb5seZLFFLMYu6mDvEaVUHY8kxz3nmzfy5GFlFIdRGn0dLF4S6NNoXR+u/XRSkhavEQxEX2glk0BZPbC5bERyiPQUeBBVouc3Vz2cfZ9uB1YsmCLVP77XBUiQqyiksYOZ9PH68IgHdFbXthw00Z5mot40oOt8L4g3mYV5952xFhc4xS1MB14MiX+XhLX1QbN5+FGiMzgJPF1zBLnf/SNa7SrE13Vqijjb9nU/3a3+LQFL9XGB0UG+hJawqSsQHVu2Gip4CNcygr9r/v5BPtqPIqJW5PR8amuQcbjJJuAfYcd/7PEUhd/JlZJ7qm6MjjZFH3h90tLOTgUVM/Y4vUlfSbpPKQQyYWop05qNqfUnoJ4thNAfka8jOUkjwznnHCfNKta0O9oMRdNLB5bekl1k3sWh+xG/jmg4xJljbikEEDBXXYs7jvro2SV79KBU79l5Zm6Kswi3QOgJ1xvgIY7clfwEvH9KEPUyf3m5XJwqVSkCoPdOAova6crQUZhBt1iWq/7MClqE9EaiX4/YhBOQwCAQo1v4LZh8xlqbc2oXtBZRzqtDyNY9LyPXGXrg0w0W3sNEnVlT9i73/MXX1I+eg9Gph+8p6QrKGTDNcAaaXZJGTrerNWT6fAjiI6rxscNnmH4UXSwzc6cSHGdbMTK9TBLbA830avAso/XPxNKqUNL46hJrwXvxPaKRbFTrN49izVWTqzEL+kuUN2aS6FGvxi3Nf7n8HhvxwOin6P2WINwgdet25Aza1uPslqR309S5FhESGok6qb2wcCXqgoHbkgGIxtOoQj+P1JN8lJ8DEAMX
 0ydgMsjJ
 ZEZ4ISxQg5NHQSqcDZo+iN/mlvUSYbm3aqgcaulpmmTvKEwlvFJp1eVkPtvCbljtzGmIK7kDJXlHL7vl2QVsHEaWi2RvnoVvg2jnoMPqEnoTAVOwRLhNK7kUY6u5ubqyyqSKSbfs3U8aQD43GpyLeesKBlFlmUFx+jqbfQ+LumnE6LApOjXfvVBQa4LhJT7y0cXgQjZAuqHKFgbDW4mBuirwiSISavjqoFPPw1y8DesB0XZNfFXlH5kDGSPSEo/e1+1mCVytkHJ2y2c1vFjpgNTdHRfLS7JID47cz3Aq+2FC6I0g/kQ2MXi2ucw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/6/26 22:19, Matthew Wilcox wrote:
> On Sat, Jun 06, 2026 at 04:58:55PM +0100, Mohammed EL Kadiri wrote:
>> +The SLUB allocator merges slab caches with compatible size, alignment, and
> 
> More of a question for Vlastimil ... do we want to continue to
> distinguish between slab (the API) and SLUB (the implementation)?
> I don't think we ever want to go back to a situation where we have
> multiple competing implementations of the slab API in the kernel.
> So shouldn't we deprecate uses of SLUB, particularly in the
> documentation?

Indeed, any new stuff should talk about the slab allocator, with old stuff
can be converted if touched for other reasons.

>> +flags to reduce memory fragmentation. While this improves memory efficiency,
>> +it allows objects of different types to share the same slab pages. This
> 
> s/ pages//
> 
>> +enables cross-cache heap exploitation, where a use-after-free in one object
>> +type can be leveraged to corrupt an unrelated type.
>> +
>> +The `SLAB_NO_MERGE` flag prevents a cache from being merged, ensuring it
>> +receives dedicated slab pages.
> 
> s/slab pages/a dedicated slab/
> 
>> +2. *Actually mergeable*: The cache must not already be unmergeable.
>> +   A cache is already unmergeable if any of the following is true:
>> +
>> +   - It has a constructor (`ctor` argument is non-NULL).
>> +   - It has a non-zero `usersize` (with `CONFIG_HARDENED_USERCOPY`).
>> +   - It already has `SLAB_NO_MERGE` or another `SLAB_NEVER_MERGE` flag.
> 
> I don't know if this is good advice for users of the API.  It's true
> that the slab will already be unmergable for these other reasons, but
> it's harmless to specify SLAB_NO_MERGE in that case.  And it
> communicates intent.  And in case somebody removes the ctor in the
> future, or we decide to change which flags are in SLAB_NEVER_MERGE,
> the slab will still be unmergable.

Agreed.

>> +3. *Bounded allocation volume*: The cache has a predictable number of
>> +   active objects, so the memory cost of dedicated slab pages is
>> +   acceptable.
> 
> I don't understand why this is a criteria.

+1

>> +How merging works
>> +=================
>> +
>> +When `kmem_cache_create()` is called:
>> +
>> +1. If `usersize` is non-zero, the merge path is skipped entirely.
>> +
>> +2. Otherwise, `find_mergeable()` in `mm/slab_common.c` searches for a
>> +   compatible existing cache. A merge is prevented if:
>> +
>> +   - The `slab_nomerge` boot parameter is set
>> +   - The new cache has a constructor
>> +   - The new cache's flags include `SLAB_NO_MERGE`
>> +   - No existing cache has compatible size and flags
>> +
>> +3. If a compatible cache is found, the new cache becomes an alias. Both
>> +   share the same slab pages.
> 
> This feels like documenting internals rather than documenting how to use
> the flag.  I'd drop it entirely.

+1

>> +The cross-cache attack class
>> +=============================
>> +
>> +Cross-cache attacks exploit slab merging to achieve type confusion:
>> +
>> +1. Attacker triggers a use-after-free in object type A.
>> +2. Type A's cache is merged with type B (they share slab pages).
>> +3. The freed type A slot is reallocated as type B.
>> +4. Attacker uses the dangling pointer to corrupt type B.
>> +5. Privilege escalation.
>> +
>> +CVE-2022-29582 demonstrates this technique: an io_uring use-after-free is
>> +exploited via cross-cache page-level reallocation to achieve root.
>> +
>> +`SLAB_NO_MERGE` prevents step 2: dedicated pages mean a freed slot of
>> +one type cannot be reallocated as a different type.
> 
> Not sure this section adds anything to what was already described.
> 
>> +Tradeoffs
>> +=========
>> +
>> +*Memory*: Isolated caches may have partially-filled slab pages that
>> +cannot be used by other types. For caches with bounded allocation counts,
>> +this is typically a few extra pages.
>> +
>> +*Performance*: Zero impact on `kmem_cache_alloc()` and
>> +`kmem_cache_free()`. The only effect is at boot when the cache is
>> +created.
>> +
>> +Relationship to other mitigations
>> +==================================
>> +
>> +`CONFIG_RANDOM_KMALLOC_CACHES`
>> +    Creates 16 copies of each `kmalloc` size class and randomly assigns
>> +    allocations among them. Only affects `kmalloc()` users. Does not
>> +    affect named caches created with `kmem_cache_create()`.
>> +
>> +`SLAB_TYPESAFE_BY_RCU`
>> +    Delays freeing the slab page by an RCU grace period. Does not delay
>> +    object slot reuse. Does not prevent cross-cache merging. Solves a
>> +    different problem: safe lockless access to freed-and-reallocated
>> +    objects of the same type.
>> +
>> +`slab_nomerge` boot parameter
>> +    Disables merging for all caches globally. `SLAB_NO_MERGE` provides
>> +    the same protection selectively for individual caches without the
>> +    global memory cost.
> 
> These two sections also feel unnecessary.

Many "product of LLM" hallmarks, sigh.

