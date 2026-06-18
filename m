Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA498CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 07:27:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CA606B0088; Thu, 18 Jun 2026 03:27:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97BFD6B008A; Thu, 18 Jun 2026 03:27:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 843556B008C; Thu, 18 Jun 2026 03:27:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 102E06B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 03:27:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8C677A0657
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 07:27:30 +0000 (UTC)
X-FDA: 84892203060.22.37D737B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id A71AE100009
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 07:27:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jEvfewlg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781767648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DMRA1kS0c5QJW6KjK0w1R4M6xusuj/MFHWPIs+KMaDo=;
	b=k76foi9MMyNK1Udtt3TMlcCxrEokkVnN92Wfoxl4GjnlhgVOW5DgNK4aiOqUaajxp+JlQ4
	FC4uqrEIAi4JEHXrbsP6Z3uW6FFHQdOTAAzRUIOkFzHr5em6IxlENcbACi2q6N9RryB8Z4
	jL/ethJLLSgiGQ+mgRtgP1GnyXoc1Vk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jEvfewlg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781767648;
	b=8K4mGb4/81uD83dhY3HskRWkmRmivLM9Q8eixyfJYM2WHRDjg5xiLn4qXY99d9ERVbI5v9
	KDgvNxLBhCQ4ubmK4l7yVtFCgQayRLLe5cWGVZs2IlSS4WuLxtb5Mn5vHu+rVeDAMQtsmo
	eJ+2CkWsjaXMXElXwYDEI8ECbW1/wVo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 98D7043852;
	Thu, 18 Jun 2026 07:27:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA78E1F000E9;
	Thu, 18 Jun 2026 07:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781767647;
	bh=DMRA1kS0c5QJW6KjK0w1R4M6xusuj/MFHWPIs+KMaDo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jEvfewlgsozJDyY9uc5/XwOP7JZxkV+lvPJOs51kM7dUP0KQWyaXfliYM4UzWctJS
	 UbLc2DJIqHpeSxSySfXC0MS5lz6iBqZAM4vGS/Irvll/kpYC9rKcoOb+rP2QdUgufU
	 PC8bOBpmXkTZBkTt568/S6rZIibIWPRXvH5N93PLsnAjcI2SnsE5jzRCwA6yism1rL
	 2Hu/nUPlASLTfQVJSCYZfBew6+8Fr3lMiw3mu/d0/ZjEKWzrobYue515OGF7XvdnSA
	 q+NewhUkPs5UFIK37p8e4IIMAsZvp8wjwbucGi9/2gOZjmywM32POsXyf+F9XzKxaD
	 eTkReyk0n6wXA==
Message-ID: <7b2125bb-c2d6-4678-9ae3-6f4e93034391@kernel.org>
Date: Thu, 18 Jun 2026 09:27:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 0/4] mm/page_owner: add per-fd filter infrastructure
 for print_mode and NUMA filtering
Content-Language: en-US
To: "zhen.ni" <zhen.ni@easystack.cn>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260525081652.2210206-1-zhen.ni@easystack.cn>
 <20260525125819.1857f215bc56b26a0727bedc@linux-foundation.org>
 <5ef656db-c6b6-4a2c-b6be-628e5214952f@easystack.cn>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <5ef656db-c6b6-4a2c-b6be-628e5214952f@easystack.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A71AE100009
X-Stat-Signature: fkmfhj1rj4s94htgzbmpqdp8ixbtqakz
X-Rspam-User: 
X-HE-Tag: 1781767648-294092
X-HE-Meta: U2FsdGVkX1+jMqadI9gPG0sFq6u/Uz/qqRw4FEEmqs3bS7FfD90ORlXUwLNJ7pfxk3ag0Bz1XtNZKShMtV58lwpIcJ2JPLgntcqL0N/smE3+Mjo6aWwAe7JG337SdSG2+K8WZ4KoRULLVzoghY1KCKKWNPm7YD5ZgKxMVWBM67ZwwKgyIhBpVAmP4Zbn0TLK846BB2XXqkKIcNcf8Cbp5yeI0Bj8KAMxnYmMRRUWW5X7L0IKmjLLp8NCXPmRi5DQ8Qrs5E11hK+YL8X2n4OIQEH8xlrIqBUnZgBRhHfaCTGe2QhCucdGd0+OM/6CfD79tgP1WNLv5H/aZ3e0HmX4fkP+BkjqbB7PQN1rTjW3JmWz+MKZuXTEFHziTF+eE/OG9BQ1eyXND89s0ORnJBYPrtPpW5KlLsNQGHKUDiph8bGhTvHS3I9ZXKdEhtqV2NCRWQ8eZZeDpXpw+XA0/4Qaec7rOAlrttFanoB8O7veC01UAEzf8Hd27dmpoJOZLpU4HRdsxfeJ6SMrefr6ZmyT+9S+3nVZpjCs7rQK216UtybgjeFZ1Zzwj1Tj6C9WWNve7adiAhXvtnGNCldHzUVUEm2W/Zt/oEr6O2GDgGa+bYE+rKwvyb6kW/qJN3nc7WERIajGfkpGb47w2cxjBuDKqOvsoMQm9P+nFS+cDxW7HflAHk3vxoF6KT1NarpuTQpvsBTSmLnih3BMncf3c0+ztHQvFjT5MNDtQyz/iLAySPrqxEq25A6ZhJr6hVbB0cMnZlJciaau4NU+G8JB0wWw2022tsEXhapfl9wQDxY51oDpIm1fQfqtpL3AC5wNpGRHdbkpk8kJ+xr6mCOoytWyJiDIF8cCD/tKVXqxcPK9OgUafPMEJus86wt8PH2Nhd8BEowzneIfsEGwl8RBNX4BrO4y5uPxzh58QfvF6RWR6LpokJyPCsGFkgkHT7niefUnxBta6AxCKYRcGOBAhBx
 e4c5CLeq
 GUWS8Cyo5AmsfpqP0Y3jL/UrAjqQPOyLNuYFdliZ1fIGD0tSJSOQ4TOVQm5TIuXaLlHU+XpqbS/piqH+yaS60A0or02/eGW/ooQPiiOWUcC5JfSWVCI1wiaWJTGvO3GTe+2bthSAyGue2SkSNiIyYz+OxgjUzypcldKkUOkxoozb7hfnvxj7mTw7wb2eElcfN0kVGQhf45ENeVwiUGAdNzxcEgJOZrHIGsI9kOubS9acgEN7u6HkZe5CLc98QnjHjzeA8CgHYbQ5qDFpSot87QPwDi0WfbqFdY4LCjovFu7AywOtPVPt5/HCYB0Z5/m5S5JyYnE1RH2ZVJftVJ1zPnF4d/USKQjwN/lNU85BfiTgpsWBqigsKj1yenc8HDsYEbbOMDLggtwysoa8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/17/26 10:52, zhen.ni wrote:
> 在 2026/5/26 03:58, Andrew Morton 写道:
>> On Mon, 25 May 2026 16:16:48 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:
>> 
>>> This patch series introduces per-file-descriptor filtering capabilities to the
>>> page_owner feature.
>> 
>> Thanks again.  AI review has found a bunch of new things to get worried
>> about:
>> 	https://sashiko.dev/#/patchset/20260525081652.2210206-1-zhen.ni@easystack.cn
>> 
>> 
> Hi,
> 
> Can this lead to an out-of-bounds memory read?
> 
> The NUMA filter in page_owner (mm/page_owner.c:790-798) bypasses
> PF_POISONED_CHECK() to avoid triggering VM_BUG_ON during concurrent page
> allocation/free:
> 
>      int page_nid = memdesc_nid(page->flags);
> 
> When NODE_NOT_IN_PAGE_FLAGS is defined, memdesc_nid() performs unchecked
> array access:
> 
>      int memdesc_nid(memdesc_flags_t mdf)
>      {
>          return section_to_node_table[memdesc_section(mdf)];
>      }
> 
> If page->flags is poisoned, memdesc_section() can return a garbage
> section_nr that causes out-of-bounds access.
> 
> ## Lockless Access Safety Principle
> 
> The page_owner iterator runs without locks, meaning pages can be 
> allocated or freed concurrently. The fundamental design principle should be:
> 
> "It's acceptable to skip a small number of abnormal pages, but panics 
> must be prevented."
> 
> In lockless iteration, TOCTOU is unavoidable - even with reference
> counting or RCU, page->flags can still be modified concurrently during
> access. Zone locks prevent this but are prohibitively expensive.
> 
> ## Proposed Solution: Add nid to struct page_owner
> 
> Record nid at allocation time when page state is stable, eliminating the
> need to extract it from page->flags during iteration:
> 
> ### 1. Modify struct page_owner
> 
>      struct page_owner {
>          unsigned short order;
>          short last_migrate_reason;
>          ...
>          pid_t tgid;
>          pid_t free_pid;
>          pid_t free_tgid;
>          int nid;  // NEW
>      };
> 
> ### 2. Record nid during allocation
> 
>      static inline void __update_page_owner_handle(struct page *page, ...)
>      {
>          int nid = page_to_nid(page);  // Safe in allocation context
> 
>          for_each_page_ext(page, 1 << order, page_ext, iter) {
>              page_owner = get_page_owner(page_ext);
>              page_owner->nid = nid;
>              // ... other fields ...
>          }
>      }
> 
> ### 3. Use saved nid in NUMA filter
> 
>      if (state->nid_filter_enabled) {
>          int page_nid = page_owner->nid;  // Direct read, safe
> 
>          if (!node_isset(page_nid, state->nid_filter)) {
>              spin_unlock_irqrestore(&state->lock, flags);
>              goto ext_put_continue;
>          }
>      }
> 
> ### 4. Update nid on page migration
> 
>      // In split_page_owner() when page migrates
>      page_owner->nid = page_to_nid(&newfolio->page);
> 

This (presumably LLM) suggestion is a, let's say "lazy" solution to the
problem, leading to more memory usage. I'd be surprised if it's not possible
to read the nid in a way that avoids the hazards. If page_to_nid() can
trigger a VM_BUG_ON(), then I'd add a version without that VM_BUG_ON(),
handling the poisoned state gracefully - if it's poisoned, return e.g.
NUMA_NO_NODE and skip the page, or something.

> The remaining two issues can also be improved. If there are no 
> additional comments, I will proceed with sending v10.
> 
> 
> Thanks,
> Zhen


