Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8278EC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 07:52:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 546A96B0005; Mon, 29 Jun 2026 03:52:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CFCD6B0088; Mon, 29 Jun 2026 03:52:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 371266B008A; Mon, 29 Jun 2026 03:52:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0276A6B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 03:52:48 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 85DFB1C269F
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:52:48 +0000 (UTC)
X-FDA: 84932183616.18.3C2FE06
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id B24A9140006
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:52:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aCNhLqRc;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782719566;
	b=a4RtrRKNMUw9ZaN6mXJJtcbheFQf03OXMDKDqh1THUZXDA1MyNf/7Vv2ylfP5DzVZorJ9z
	N2JuCRyFDWFqV418i7cdW+oYT0/7USFr+k4VEXslywKxekAtT9dz4/ZNoXc9ICy/Oa2oT6
	Dg4O6OPlNEfdczTLLuxrzh3XUDT2xJE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782719566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lqnCPVOgrUYFBt4PAD1xowXcIl1r0kSA2ozOlCjtUFM=;
	b=FwRfL266ogXJeIGJE8yfNdmChcX7qIGx3DKKXF4wXP+Ywqg1iSW9jcbYSLwPNRxuucqTHE
	SbLe9cQDqJMQa/LrL8ijZGFl1AX0+FJdvol2SGOHoobduaO+jnhZCe8x3+c/zSUcySm/FC
	e/awmL0qT1GLESJcih8R7ianWIE38bg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aCNhLqRc;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A9C6B40504;
	Mon, 29 Jun 2026 07:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606701F000E9;
	Mon, 29 Jun 2026 07:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782719565;
	bh=lqnCPVOgrUYFBt4PAD1xowXcIl1r0kSA2ozOlCjtUFM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aCNhLqRcW4J0cZZARaBIuk5Omeh9jhNhygSmi7CZZavheXQRBD/Cei7KaiooeNR0y
	 WbWC2rmUK6thogFoZTvcbqf7TZDp7K+ilpPoF2ko/2kH3RTqB5Uh06QTpqKwVNgF/u
	 BDMN8sTppceA4alYkfQ47BSHi2+w9zy6o6oEhhHMs3fzuGHTlmtQCofKQekvTKSkgy
	 ffcBkH0WbjwUe1kd1WmHZ8F/WejLYp3+lN+4N9enYojyVBffNhD2jo2cSZLf4Cmw/d
	 KCf/ZfZS8syNFGyWxMgcAOUg8f3qoX32D7sb19VX10coGIsj51mYM9diMPIRI4NOVx
	 ycMIwskRNHgQg==
Message-ID: <3903def5-e823-4fe3-9784-b6bd63470516@kernel.org>
Date: Mon, 29 Jun 2026 09:52:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm: avoid unnecessary lru drain for
 wp_can_reuse_anon_folio()
To: Barry Song <baohua@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, baoquan.he@linux.dev,
 chrisl@kernel.org, jp.kobryn@linux.dev, kasong@tencent.com,
 liam@infradead.org, linux-kernel@vger.kernel.org, ljs@kernel.org,
 mhocko@suse.com, nphamcs@gmail.com, rppt@kernel.org,
 shikemeng@huaweicloud.com, surenb@google.com, usama.arif@linux.dev,
 vbabka@kernel.org, youngjun.park@lge.com
References: <20260623231635.43086-1-baohua@kernel.org>
 <20260623231635.43086-2-baohua@kernel.org>
 <bf2bbffa-dc68-4a3e-a8e6-1ad57c10255b@kernel.org>
 <CAGsJ_4wJ-2JFY4+ADf-Bn2PrbpvOnWeVwZY3unKnB=TZ71-hzQ@mail.gmail.com>
 <c4718e32-2baa-4dee-873c-7ab99f21ca4e@kernel.org>
 <aj83c5ix_YCFMU-M@linux.dev>
 <CAGsJ_4xbYOVvonZg6d8eeuKcY9SUic3zXLbWUvxJrbf=U9sQnw@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAGsJ_4xbYOVvonZg6d8eeuKcY9SUic3zXLbWUvxJrbf=U9sQnw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ofsmkuyxw41k7gbgx99xe3tc75bsrrwq
X-Rspamd-Queue-Id: B24A9140006
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782719566-653409
X-HE-Meta: U2FsdGVkX19eirQ1MjMsF4eoNjWBCtxdgVBJDil2stkvuFYvC+ES/MJQQBgEb5w/7NwUqczHv2jIeXKvBZ6vFyuuRdvBFEs7KLN3i3tFYzHzAQmjyFOevZK2oHSl9md7bh+LUhJk9kHGXI2UarMs14UpEaj3qsgVnWVCEIFeC+LWXTVV4x48hmAWhpZCxB0/PlyROKHwR8k9XljI/+Ss2MyysQJtRuI1OdtJCdph0vlypyAC6Tw+DU8xEzbrgcR4NhfNM+h+DazrgA1MYN41rJjqiPq6PFIlrFz7ti+zGGVcdmDVEPrcS6JA78jgSJa9vFkceJ6nGQHbLula98y8j3pr099QiRa14hlPBkb/mpUKkN/yNDsLt36dY0Xt/6FS4uozmg78xiLykeKL4geRs2urmYtD0TXyQiip7T/KN/beZxsLHMmSqwreQfDmV1oDNz3Ml/qrGvOTKAgzV/YkEEkwnA2aPxF+FFupQwXubtrneX6ObGKTv2+6w0Npli9OhhxedAnBIuyRnppAPMJtOa7diSUQVKun2/2RF2Tzs6NfYvAL+65B8MaXiMBTGjdg0vVxYh2ZgZgTonm+jBGZSGSVqwzM5zLesmjLkTd56lL60f5vxMlEhvPA1fB7vjXgqvHpnT8nvw9VRC5amED7yAedjNjnIi7XF33/CkxVipbOlgFka5L41+P8zGXCefeW2bpwaHbh04NDQ1DptUebZdyWzn+1Iiz+Ls2DuRnqIjvooHX0UCFpJGD8gsHJtE3bSG6RW5e4sOlgXwq4KnWOirHEo2xW8i33o5garHioAvo76hEh39Exy/L30r9GJ+bB18mW9SnQ9CpFWedffil/1rKDVo60CTFqDNbUwuYNbmPUQDNo2nH8TjYzH3DGv3h8eSyCSXwJwEeyO9yMI4Yl8mWZxRdA6x9E03LlIK5wzb3omFnDwdn4lkPm4UgFQNNMq4jdCbOJJOFAmGiZuWv
 aQClu4Mm
 WU7wOnJ9OYVeFs34IAz57Bs+kATmLLCwCN06fjWS4J0tcgBo0iEPdDTJhCXC3HaXzSh80x/Xbwd4cig7PCyD4GOHKo0axcbFBnqrMTn+W1eAmGISc9VjKXvruVWgb4IZ8M6UMMBBRnqZsr5KFwcfvawe0UA7Z5z0HX67/nuQa3JMqpm6alVFKBnE00o4vx+unNz5kq0/Xhswq3YwkM/rtclCHuLL+YA3K1mNF/gQetA1VYdB1+93+nvEJxRD6awBoSeYXrbBblv6N9jNga4wRGcptr2z4Iq+BJyh3TryQodMhgAnI5KIADAEcSkvZVm25y2CbMXArTjNCahOiRmDLG3WwJ6DFYj/iYo2hl6n7jG0wSAmRo3LnD2A5SPs6r+GtnYyk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/27/26 09:20, Barry Song wrote:
> On Sat, Jun 27, 2026 at 10:44 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
>>
>> On Fri, Jun 26, 2026 at 06:25:48PM +0200, David Hildenbrand (Arm) wrote:
>>>
>>> is this with this patch only?
> 
> Right. wp_reuse_skipped_drain accounts for the behavior
> introduced by this patch, while do_swap_skipped_drain comes
> from patch 3/3.
> 
>>>
>>>
>>> This is all data that belongs into this patch description, not hidden
>>> somewhere on the internet :)
> 
> Agreed. Sorry, I was being a bit lazy.
> 
>>
>> I asked the same i.e. to include this information in the commit message [1].
>>
>> [1] https://lore.kernel.org/linux-mm/ajK4N2zK3sPZFQuf@linux.dev/
> 
> Sorry, I missed this one. I'll add it in v3.
> 
>>
>>>
>>>
>>> And why do we care about local draining? This is not a drain-all.
>>
>> Let me take a stab at it. Local draining can potentially make the lru cache's
>> batching ineffective. The whole reason for lru caches is to batch the lru
>> operations to keep the lru lock contention low but if we keep draining
>> prematurely we will continue to make lru lock contention worse. This is
>> particularly bad for workloads which chrun a lot of LRU pages through
>> allocation, free and/or reclaim.
> 
> I actually asked the same question myself in the RFC here[1]:
> 
> "On the other hand, the folio may be sitting in the lru_cache of
> another CPU, which the current drain cannot flush. As things stand
> today, the drain only succeeds if the folio happens to be queued on
> the current CPU's lru_cache, giving it roughly a 1/nr_cpus chance of
> working. drain_all would clearly be too expensive to avoid.
> So another possibility is to drop this drain as well. The folio can
> be released later, at the cost of missing some opportunities for
> reuse."
> 
> After thinking about it for a couple of days, my gut feeling is
> that keeping it might increase the chances of reuse in at least
> two cases:
> 1. It could be a newly allocated folio in do_swap_page(), and
> do_swap_page() may subsequently call do_wp_page(). In
> that case, task migration is less likely to have occurred.
> 2. On systems with fewer CPUs (and typically less memory), the
> chance of having the folio in the same CPU's lru_cache,
> which is roughly 1 / nr_cpus, may still be reasonably high.
> 
> I'm not entirely sure about this, so I chose a relatively
> conservative approach: making an obviously correct improvement
> without introducing dramatic changes. Another reason is that it's
> also hard to evaluate the impact of removing the local drain
> across all systems and workloads.
> 
> Shakeel, David, what are your thoughts on this? Should we go
> with a code refinement in v3 as David suggested, or completely
> remove this drain?

When we added that code, we didn't have PageAnonExclusive yet. I documented that in:

commit d4c470970d45c863fafc757521a82be2f80b1232
Author: David Hildenbrand <david@kernel.org>
Date:   Thu Mar 24 18:13:34 2022 -0700

    mm: optimize do_wp_page() for fresh pages in local LRU pagevecs

    For example, if a page just got swapped in via a read fault, the LRU
    pagevecs might still hold a reference to the page.  If we trigger a write
    fault on such a page, the additional reference from the LRU pagevecs will
    prohibit reusing the page.

    Let's conditionally drain the local LRU pagevecs when we stumble over a
    !PageLRU() page.  We cannot easily drain remote LRU pagevecs and it might
    not be desirable performance-wise.  Consequently, this will only avoid
    copying in some cases.

    Add a simple "page_count(page) > 3" check first but keep the
    "page_count(page) > 1 + PageSwapCache(page)" check in place, as we want to
    minimize cases where we remove a page from the swapcache but won't be able
    to reuse it, for example, because another process has it mapped R/O, to
    not affect reclaim.

    We cannot easily handle the following cases and we will always have to
    copy:

    (1) The page is referenced in the LRU pagevecs of other CPUs. We really
        would have to drain the LRU pagevecs of all CPUs -- most probably
        copying is much cheaper.

    (2) The page is already PageLRU() but is getting moved between LRU
        lists, for example, for activation (e.g., mark_page_accessed()),
        deactivation (MADV_COLD), or lazyfree (MADV_FREE). We'd have to
        drain mostly unconditionally, which might be bad performance-wise.
        Most probably this won't happen too often in practice.

    Note that there are other reasons why an anon page might temporarily not
    be PageLRU(): for example, compaction and migration have to isolate LRU
    pages from the LRU lists first (isolate_lru_page()), moving them to
    temporary local lists and clearing PageLRU() and holding an additional
    reference on the page.  In that case, we'll always copy.

    This change seems to be fairly effective with the reproducer [1] shared by
    Nadav, as long as writeback is done synchronously, for example, using
    zram.  However, with asynchronous writeback, we'll usually fail to free
    the swapcache because the page is still under writeback: something we
    cannot easily optimize for, and maybe it's not really relevant in
    practice.

    [1] https://lkml.kernel.org/r/0480D692-D9B2-429A-9A88-9BBA1331AC3A@gmail.com

With PAE, this case would now be handled differently in the simple alloc+swapin
scenario. Throw in a fork()+execve() in between and the optimization would still
matter.

So yeah, if Nadav's reproducer works even without the drain (which I assume), we
could indeed think about just removing this optimization here.

-- 
Cheers,

David

