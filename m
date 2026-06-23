Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A7BCCDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 06:52:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C02C6B008C; Tue, 23 Jun 2026 02:52:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3494A6B0092; Tue, 23 Jun 2026 02:52:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2106A6B0093; Tue, 23 Jun 2026 02:52:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBFF66B008A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:52:55 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5E64A1C5775
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:52:55 +0000 (UTC)
X-FDA: 84910259910.01.3A87BF2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9E56A140002
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:52:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mUV+sE88;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782197573;
	b=TVgoUwwRXulcA2haR+CwJL0a0xkJgujgBIV5lHDZLUe+xkmtfYkv60eBAE/rjKp8PsNFCz
	jVQkdUdxatL0K8AKMAT3SswbRXAnRwhwRJH3kDNu0bUAzwN5ZVLVTL/afyPtHEFRj36R4N
	9oJdhDZeOj8JfpTLoB+LoQOvdiPiJm0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782197573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=215KAt4ZF6PKi/x9INQhEQFfQVlRJhnzzyDvuOGBx/s=;
	b=mxyUSl2u3Lg3XvOvNjfrP5i+QIsEEHznBfeDA6ZgYcv3W1iEAW4TqEWzl13o7AvbsaFC2b
	LC65UXFurq/h2AXmArxsivPWDVOIe/dF8vH9IedBlPtYYGqEUt9W4UapzGAomGN0t+ci4+
	LbehZf39C+904713CBemLLsgZeqpXD8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mUV+sE88;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DC43B6001D;
	Tue, 23 Jun 2026 06:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41DD1F00A3A;
	Tue, 23 Jun 2026 06:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782197572;
	bh=215KAt4ZF6PKi/x9INQhEQFfQVlRJhnzzyDvuOGBx/s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mUV+sE881IqjdiqytyCyFxCSfe6YHl4T6Hxvfb06C9zk7NSMs4CFgiNOwUm7E/mlq
	 FmdLbKOMwZA+nxek0eFGqjk6gM2zSAwy5SWvaa5EM3O0UBR1W/h4KPu3CrSasrWD1P
	 kjjo3wSC4G+HlTxF2aT7Cawjvn1kv6TdirkYHmmvo3CFdDhAjJdomH0VYh46CiSRuf
	 rqkbjLShI3Tnrrn/vTp+5GVuVobyyk5e7KeDE6zJPnxTrd7xjOIdQ63DzY6+/4DchM
	 mAAflgE4lQHaue3qH6rSIEjV8D8Kl36jUKPqjdcKt3yhj5dmIrZeSMsf2SN7HuLEJE
	 hV069jH2AXUuw==
Message-ID: <ef2db739-fa41-4203-91e5-61c0625ecbf4@kernel.org>
Date: Tue, 23 Jun 2026 08:52:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 0/4] mm/page_owner: add per-fd filter infrastructure
 for print_mode and NUMA filtering
To: "zhen.ni" <zhen.ni@easystack.cn>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260525081652.2210206-1-zhen.ni@easystack.cn>
 <20260525125819.1857f215bc56b26a0727bedc@linux-foundation.org>
 <5ef656db-c6b6-4a2c-b6be-628e5214952f@easystack.cn>
 <7b2125bb-c2d6-4678-9ae3-6f4e93034391@kernel.org>
 <444a6fd9-26dd-4d33-b836-987ef220b5f2@easystack.cn>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <444a6fd9-26dd-4d33-b836-987ef220b5f2@easystack.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9E56A140002
X-Stat-Signature: fxmqn3kqn5b9x6sqeeryxxou59tbowx6
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782197573-824244
X-HE-Meta: U2FsdGVkX19OQN39roJFnkdwMwwNC3W/ZEpu2WP4cRRPq0yndhX5FZrhX+WlY0md8aqwbI6sKF+/+i99HoyLh8RCh8i197MPTJ6P784MEyed4VdxuRU49qGAlMF8KIND15JBrr0+mNEFrc5NxekAzE1OoPvxLPgSJ5IxU8lemgMd5VcL8vhB5o8krnOPquyvf9Qsy0Hz/ZPqVz6r+E/h2pZ65kfw8coZQuBdeJIRQgUe2ixXQ6O2akDMYI6rT1UsLqWSXmPEjIkOjvzBvn1MuWRbfszo7vPlyuzAlDv1LaHBswGQdmKjzXNQ41RHcMrJe5Gtdh2crZlQBviT4S2xNRPdje7T/2fGAGnAJ8r2mFKrQZ8t0aJvpG8cCinE/2pX3EqNFtwx8yudeNgNj35ui0qI6OIBuU+4LVIRRCXLg43LteYSUcBPmzRh7Szi1VfyvrYECfLQ7ZZ6cBSlmbnDoZO1gME5C02Q0pQ2WjybNTTnWwVyik4QvHc1S5mxJzV9p0YSS2tDZR53ts2ZU7NYpLxhg+x1GTboYa1XEJrGXSTI5W3JRUZb2OQS8sP9DYpm/uA0qq4yxHlacaOo5WjdCMnWlkyWYqTBfGvv9cgSLcy0OfyuUfF50dVsHWOf3PHNVzgbsr36v2H+Xqf9ii/0kTO5Mv5Y2aymsPXIw7Gd9IrG9wk+idm3ec+7X43NwyDYNyGQpPBV6uwCLvS8BFkPdOllLubes5I/i5LeQjX0koNMiXtRNLIsdld/FUKUk9S/IGezXUGiW9tyCW3ky9F0w6u4GfYOxJi4zZl2dSa9kBrZABO+2cZ8iPxA61kz0OwXrRoOObibAMcDdACO7nF8ritH0Qfx3nG/plshNu9EWbRFqkj4aXeObJA08qyQhHsN1sELmshR1V9KLJrc1cZ3pyR7+7ORHBmUbfvepib8+/KwYi/OhdzaP5throwMY+KrVPOPaAVxLoBYwcfy2JU
 Co/fE+QZ
 Y7KGouIEXpxh1midcx808hqvDw5V3pKdd89RywqFUiDF2f/d4nW7wZofCKI28BvV8hzKo/qPCFJ7npLxJgsx8DJmdMUNQ7Z8/wv5L7TUVV9crv+Mssmov1/6T9OdHmbh9ebl7Y52pmOHvlLqA7bht0DdKbnjFxiRcBmfOesd1s56d8jtzw2HH57VAaCrZCUisQWh2XFLJokvJFs345bEz9q6sQV6mS00ndxdELgy+42wp2egt9hVoL4mTbHeRlGQtiIosF/KV+CTn/cTuS1kDdTMRf0NpEvzcV2uvWmW5H0iv1QN+c8UlAWtzL4a0wEdFhppt6edom0HvGkTWog8iHgzXQc+aC+XEKvd9YTLsqhEIVjFoScJCGDe7lFRdae8FXOTx4PkD1rtMO1M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/18/26 10:15, zhen.ni wrote:
> 
> 
> 在 2026/6/18 15:27, Vlastimil Babka (SUSE) 写道:
>> On 6/17/26 10:52, zhen.ni wrote:
>>> 在 2026/5/26 03:58, Andrew Morton 写道:
>>>> On Mon, 25 May 2026 16:16:48 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:
>>>>
>>>>> This patch series introduces per-file-descriptor filtering capabilities to the
>>>>> page_owner feature.
>>>>
>>>> Thanks again.  AI review has found a bunch of new things to get worried
>>>> about:
>>>> 	https://sashiko.dev/#/patchset/20260525081652.2210206-1-zhen.ni@easystack.cn
>>>>
>>>>
>>> Hi,
>>>
>>> Can this lead to an out-of-bounds memory read?
>>>
>>> The NUMA filter in page_owner (mm/page_owner.c:790-798) bypasses
>>> PF_POISONED_CHECK() to avoid triggering VM_BUG_ON during concurrent page
>>> allocation/free:
>>>
>>>       int page_nid = memdesc_nid(page->flags);
>>>
>>> When NODE_NOT_IN_PAGE_FLAGS is defined, memdesc_nid() performs unchecked
>>> array access:
>>>
>>>       int memdesc_nid(memdesc_flags_t mdf)
>>>       {
>>>           return section_to_node_table[memdesc_section(mdf)];
>>>       }
>>>
>>> If page->flags is poisoned, memdesc_section() can return a garbage
>>> section_nr that causes out-of-bounds access.
>>>
>>> ## Lockless Access Safety Principle
>>>
>>> The page_owner iterator runs without locks, meaning pages can be
>>> allocated or freed concurrently. The fundamental design principle should be:
>>>
>>> "It's acceptable to skip a small number of abnormal pages, but panics
>>> must be prevented."
>>>
>>> In lockless iteration, TOCTOU is unavoidable - even with reference
>>> counting or RCU, page->flags can still be modified concurrently during
>>> access. Zone locks prevent this but are prohibitively expensive.
>>>
>>> ## Proposed Solution: Add nid to struct page_owner
>>>
>>> Record nid at allocation time when page state is stable, eliminating the
>>> need to extract it from page->flags during iteration:
>>>
>>> ### 1. Modify struct page_owner
>>>
>>>       struct page_owner {
>>>           unsigned short order;
>>>           short last_migrate_reason;
>>>           ...
>>>           pid_t tgid;
>>>           pid_t free_pid;
>>>           pid_t free_tgid;
>>>           int nid;  // NEW
>>>       };
>>>
>>> ### 2. Record nid during allocation
>>>
>>>       static inline void __update_page_owner_handle(struct page *page, ...)
>>>       {
>>>           int nid = page_to_nid(page);  // Safe in allocation context
>>>
>>>           for_each_page_ext(page, 1 << order, page_ext, iter) {
>>>               page_owner = get_page_owner(page_ext);
>>>               page_owner->nid = nid;
>>>               // ... other fields ...
>>>           }
>>>       }
>>>
>>> ### 3. Use saved nid in NUMA filter
>>>
>>>       if (state->nid_filter_enabled) {
>>>           int page_nid = page_owner->nid;  // Direct read, safe
>>>
>>>           if (!node_isset(page_nid, state->nid_filter)) {
>>>               spin_unlock_irqrestore(&state->lock, flags);
>>>               goto ext_put_continue;
>>>           }
>>>       }
>>>
>>> ### 4. Update nid on page migration
>>>
>>>       // In split_page_owner() when page migrates
>>>       page_owner->nid = page_to_nid(&newfolio->page);
>>>
>> 
>> This (presumably LLM) suggestion is a, let's say "lazy" solution to the
>> problem, leading to more memory usage. I'd be surprised if it's not possible
>> to read the nid in a way that avoids the hazards. If page_to_nid() can
>> trigger a VM_BUG_ON(), then I'd add a version without that VM_BUG_ON(),
>> handling the poisoned state gracefully - if it's poisoned, return e.g.
>> NUMA_NO_NODE and skip the page, or something.
>> 
>>> The remaining two issues can also be improved. If there are no
>>> additional comments, I will proceed with sending v10.
>>>
>>>
>>> Thanks,
>>> Zhen
>> 
>> 
>> 
> 
> Thank you for the review.
> 
> I'd like to clarify that the "nid" member approach was my own design
> after careful consideration of alternatives, not a suggestion from
> automated tools.:)

Alright, good :)

> In fact, LLMs suggested approaches like "check then access" which I had
> already implemented and rejected in earlier versions due to TOCTOU
> issues. The key insight is that page_owner serves as a buffering layer
> for struct page,  eliminating lockless access inconsistency entirely.

Sure, but is the elimination necessary if it has a memory cost?

> Think about it this way:
> Even with extensive checks, page_owner->handle cannot guarantee the page
> won't be freed when printed. The time window between checking
> page->flags and accessing page->flags is unavoidable in lockless
> iteration.

Of course, but that's an argument saying that page owner as a whole can't be
a perfect snapshot anyway. Then it follows that "nid" snapshot doesn't need
to be perfect either.

> By recording nid at allocation time (when page->flags is stable),
> page_owner becomes a "consistent snapshot" that can be safely accessed
> without locks. This is the same principle that makes page_owner work as
> a debug feature in the first place - it accepts a small inconsistency
> window in exchange for lockless access.

And that means we can accept some more small inconsistency for nid, without
occupying more memory.

> Alternative approaches (adding poison checks, bounds checking) cannot
> fully eliminate TOCTOU in lockless code - they just reduce the
> probability. The buffering approach is the way to provide both
> safety and lockless performance.

Please explain how the following "page_to_nid_robust()" (or similar name)
code cannot eliminate the out of bounds accesses completely. The section/nid
in page flags is possibly the most stable part of the whole struct page, it
doesn't change as page is allocated, freed, or how it's used. The only
problem is the poison.

memdesc_flags_t flags = READ_ONCE(page->flags);

// our flags variable is no longer subject to TOCTOU

if (flags.f == PAGE_POISON_PATTERN)
	return NUMA_NO_NODE;

return memdesc_nid(flags);

-
> Thanks,
> Zhen


