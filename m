Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2AF8CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 14:41:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A80A66B00A8; Thu, 25 Jun 2026 10:41:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A321B6B00A9; Thu, 25 Jun 2026 10:41:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FAA66B00AA; Thu, 25 Jun 2026 10:41:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5FC176B00A8
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:41:29 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D53B81A015D
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:41:28 +0000 (UTC)
X-FDA: 84918698256.18.67657A2
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf28.hostedemail.com (Postfix) with ESMTP id E228AC0009
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:41:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="T/e2pJoz";
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782398486;
	b=7+Cdpt9EgKE0hLy+e6eTEwe+FPCCkU5JJP5fLFjWzt/BflPnz54w2h4JoXeycXE/xNVOHn
	YTcjoEkZ77gvh8w0iEt7kEYJbRda6CDTs7xsqwtyOOFGw1mkPkhYehAGIoEzFDdm/TdyWS
	PoESREEbXObuo98MrdDjZV7ONyj0Ivk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782398486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=slSRypEduuNZ9JgILeAUNdKSkqsw9CkFddos67AsSDk=;
	b=T7xuOhrD0sJYtQVkcNoV/PWscZOdBWvxiKqn9ffeRRon+15TYficDs0iFiNTefqjX5D4u2
	iKIQCSzZhI3fycQtywJG8pwySTN+VfKyw+FZ/Qx8iDBAWVBY+mq8pOOQ83ANCYAajNJACC
	4MSjX3N3EP82BXgK3lguQ9cRaRpuE3Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="T/e2pJoz";
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c86307c4e6bso891709a12.0
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782398486; x=1783003286; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=slSRypEduuNZ9JgILeAUNdKSkqsw9CkFddos67AsSDk=;
        b=T/e2pJozVs7n8zNfTfUsTCJDh2rgErtG4kpBOk45+NDU72dL0Xdy8d20t9hbBQG4CT
         mtiUFfzZWS8rBfJzmIbcpVxRjba4haPqjxVy7NSPquP01rVwL+eVlxLmyBSMjsoQEoDE
         NBE3sgkiz/GJjmXNMHSpuQKvLMIAAQdtsm32wReVaEu0tATHy4zI3ZMFxdkL8NYT3Hqg
         WxI2ux0Bya9K3VOfb5D3cCHWUv5zwO1o4jdwLLAsVRbD7K+mP/o4iyT/Vs0i9RtrwnEu
         wZcFWMBOulxFsul41ozAh7VbZrINFLLf3pf5EhTzWNqSGcFvOeQy212T1PMHOFDOPo6Y
         x3OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782398486; x=1783003286;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=slSRypEduuNZ9JgILeAUNdKSkqsw9CkFddos67AsSDk=;
        b=WFXtLDdTaZVzobe2Q8SOD+n0LDMXQzBRwwxnEcteyrAUFwhLXmMCbD7wN851ruXZXg
         FG+1U1Im6FDDYdimThRk3tyinp3Zicx2PG65zVHctejp+Haco5WpL38C9L3xdtOoAwiV
         i02cTM14rLdqtQbsiMW/3iPqDgpyQXspAHUSqfqSZ8F++c7RK8o++ZNya1umBM88Ee9a
         vDGnipsK0CMqXTxPKJOL4Zyne6lmgZz9fLFNhXRx9uGCb5dy40Sm4dz3P3UcnO0tqbHK
         gwAur2DTmB9GJhEbLJ3dCZ1mT/QCFrWipAl9x9t+4y7DZzc+rx/kDfe8MAi0UpAvw/Ml
         UBTw==
X-Forwarded-Encrypted: i=1; AFNElJ8uDL2jzrrhAYQ/ueE5L5E399yOimwL0arTVWfoKrBSgWMmLNgQnxJ7SnK909H6HLdQK24A65HFrA==@kvack.org
X-Gm-Message-State: AOJu0YyOLcW5DB502IdCyozUHPBt2wcMtH+xCFciEKh9UoBk+/Xe6QOv
	eYd7Ky7yf04xHXfM6zNGfhlUPp+Bv+44IMs6rl5PvAkEzc7BujZGP14s
X-Gm-Gg: AfdE7cnCSJnyqRNewRCZD56oZsTKhGlatZGjJPQNKNFJ/LtCuHI+BYVJ9K4mho1UNl6
	ZOlS/S7mTACR7DQ+IJWGeDbQfsRPk0XVCCTFItExEfsaqs0UNXTB82HpdyQf5JQt7lzCDQ2niYe
	eAjA7p5JT8bw7JIzcSqE3y23pIWkUqtO5HxsWHnr6IJV6EnzKh2Yd4dES9+xrSNBV1q3xKEdRJ9
	SdumWgPscHEeqah/fhWTulNnGLroYfaOQHhr/zLIfRrusubFnPxMEoWehmCtcNTZ3jyYxqmFn0R
	KVTm8qEFRjTzuNZRNtGQiEk37cjIFmz7BaljTk8DtQ3jns5zyyu3K95D+zJgExfp6ghnz0HO4In
	x9CpmB0JfhP4wAo+pphVmFMcNqeSjC71KOQQHv0UxO6kM9q8Nssiz02FEenIhH6+1c+gGMc7mTz
	qfMj55+p8+Mgs2dTa47YSA3LXsbAQkJ1xS0VNNMieQSuRt3MHE
X-Received: by 2002:a05:6a20:728a:b0:3b9:5efb:cb2a with SMTP id adf61e73a8af0-3bd4ac85f3cmr3409358637.3.1782398485438;
        Thu, 25 Jun 2026 07:41:25 -0700 (PDT)
Received: from KASONG-MC4 ([115.171.41.167])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c92b96ec739sm1834186a12.2.2026.06.25.07.41.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 07:41:24 -0700 (PDT)
Date: Thu, 25 Jun 2026 22:40:50 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Barry Song <baohua@kernel.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, baoquan.he@linux.dev, 
	chrisl@kernel.org, jp.kobryn@linux.dev, kasong@tencent.com, liam@infradead.org, 
	linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com, nphamcs@gmail.com, 
	rppt@kernel.org, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, 
	surenb@google.com, usama.arif@linux.dev, vbabka@kernel.org, youngjun.park@lge.com
Subject: Re: [PATCH v2 4/4] mm: try to free swapcache for non-LRU folios
Message-ID: <ajzm3pHq-wQlLNmm@KASONG-MC4>
References: <20260623231635.43086-1-baohua@kernel.org>
 <20260623231635.43086-5-baohua@kernel.org>
 <e56c4d73-ed4a-48bb-8d0a-97b1200d4a35@kernel.org>
 <CAGsJ_4y3yC1DCsHfCn5FP6vK3jqNRbqU5pbBqHnb5LB7GgtWOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4y3yC1DCsHfCn5FP6vK3jqNRbqU5pbBqHnb5LB7GgtWOA@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: rdthny88mu8eshyu7cz6hr3k3867r7qb
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E228AC0009
X-HE-Tag: 1782398486-234473
X-HE-Meta: U2FsdGVkX1/sHwHpQDSnT2mNAbmYdiHIp1ZUpok7oxxzAJ62liPnZ7nT7KCjPgSKmniYzPnU3k5O6j1QGxKZFlbxZl3jFlW6QtIbs9vhXgUwqyvOlX9b1k8wgI0umNW2xJBAOj2s0SOz5c44VasfnvjqdTIMCA8iUrRaeDFxEf3e1rZX7hlYbEU156v1wUxtCtzERsLjpq6zTWvFcRHdqErDb43J/b2YTwQFYgVzrr9+BYxdCCDKbI7yAY74e00srzajvpI8asLrThJwT9l4iFA/WWaDSch1J/MkBNjvM935u/rDxXppT53Bok5FmvazJmw8qihmof1I3fk8EefoEwGLvhx2BkD8W90Gmi+861b8fnihf4sCocE34tQPwWRxaLix3NGKcYw769Z3SiQIgypgQ5OB2R2rwfDdHP+47C0ZgEEAIGDLfEupuu2XmrXngJUXMVenu/Oj/6JdI7sFm1LGpby/z2Kxnko6MTbODwWbO36rCwfXLIfZyJrhuk+KMZ72IkMXaS+SLjorzLLjEM+d3Pe77YxGLu/gJ1D8+p2RabpVIv1UxcSbyzoQw9aTgLdBaY2hoBCYzuolkfKcORD11jH6t4S7TKvczCOW20T6JnhE0jMJhoVNPR+IsTGJ7881zbdv98WGfnEGCn+xvoyYLcdFfyGVBr5z7uL2Z+gV/02bKHAkkkZMT+CF9Lq5uF8oIIReNdDPTfpqYYWVROPlhivd3pTtMaNhcRKdwUlspVJKCVtFqr0mMsp9AvmtS2JbhoRUVgFSct8HBs0ghEMfn9iJphDz3VyhSSa1eH6hE5ekm2WtK0cmQVwn+lCOMb0q87uSMyaJfGBTU6RAr0T3SSe/8SGydild1cy6E1So7lA1lXPHH6VhV9gRUhSkIKn1EDecgNoBOUyMkik9pKdW54TSY99Yu+/RYfbjieE8PH6cBgNxb7c/GZuXuMQV5cRhK9FRCFzKoIC50Nb
 dLE9yzGs
 0rkRQzV/bMrO4rX6R5B0qnMTGo98blmDZssf6jGjJC1+hfho0xFc5cK8FEil2fCAj+/3FupW7ENT6iNzZxIog8EzSQp76EQB+66ILwnj9go2xn9y7mwii0SlJMNuZDzZVOi93VuP82NEygznSfCTfvktvqO3Mz5Hc18yU51DVd9MQxBHNcqp3fW+h32Y3kZRxMsa8qqyU26JUAIHXzKZ9shHvkJxSMqF9P4yHDt6OFoWqapxyMc0y5RGQVw8SYgWXKjn+7JWXnOEb4vLJNuvbhQp6Rqs0g+ylNLmAIs5AzzAR/EfXapWw0rOGgEDPndBMECsbEXvsbXoh+XEpFD/KeGuni8e5gdcirosyJsPxWF7pcHkAt+2Pnx7LzXTJA7PKY+kz4wh1MTCzL+f7TajvL9gQQviRhrn24wAUjOu8f6NSVCaf6i8emaDTVL3z/Gp5WAqp8mELNr9umDNr0EJSQqgaq5p8KwcoS/gqMMKMWyaNv18eaw32qWWqGET2Ng9rwH20GttAYbhJt6kW9CdADFOJrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 05:14:45AM +0800, Barry Song wrote:
> On Wed, Jun 24, 2026 at 11:20 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > On 6/24/26 01:16, Barry Song (Xiaomi) wrote:
> > > Originally, we unconditionally called lru_add_drain() for write
> > > swap-in page faults. This might drop the reference held by the per-CPU
> > > LRU cache if the folio happened to reside there. However, there was no
> > > guarantee that the folio was actually cached on the current CPU.
> > >
> > > Now that lru_add_drain() has been removed, we have lost one
> > > opportunity to drop a reference held by the LRU cache. We could
> > > instead incorporate that possibility into the condition evaluated by
> > > should_try_to_free_swap().
> > >
> > > Suggested-by: Kairui Song <ryncsn@gmail.com>
> > > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > > ---
> > >  mm/memory.c | 5 ++++-
> > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/mm/memory.c b/mm/memory.c
> > > index 2983a6baf474..14577c67c61a 100644
> > > --- a/mm/memory.c
> > > +++ b/mm/memory.c
> > > @@ -5087,8 +5087,11 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> > >        * Remove the swap entry and conditionally try to free up the swapcache.
> > >        * Do it after mapping, so raced page faults will likely see the folio
> > >        * in swap cache and wait on the folio lock.
> > > +      * Assume non-LRU folios may be queued in the LRU cache, which contributes
> > > +      * an additional reference to the folio.
> > >        */
> > > -     if (should_try_to_free_swap(si, folio, vma, nr_pages, vmf->flags))
> > > +     if (should_try_to_free_swap(si, folio, vma, nr_pages +
> > > +                     !folio_test_lru(folio), vmf->flags))
> > >               folio_free_swap(folio);
> > >
> > >       folio_unlock(folio);
> >
> > Hm, in wp_can_reuse_anon_folio() we'll try dropping the swapcache ourselves.
> >
> > So I wonder if we still need that handling ("If we want to map a page that's in
> > the swapcache writable, we ...") at all?
> >
> >
> > Ahh, I see the problem now:
> >
> > commit 4b34f1d82c6549837b2061096dea249e881a4495
> > Author: Kairui Song <kasong@tencent.com>
> > Date:   Sat Dec 20 03:43:35 2025 +0800
> >
> >     mm, swap: free the swap cache after folio is mapped
> >
> >     Currently, we remove the folio from the swap cache and free the swap cache
> >     before mapping the PTE.  To reduce repeated faults due to parallel swapins
> >     of the same PTE, change it to remove the folio from the swap cache after
> >     it is mapped.  So new faults from the swap PTE will be much more likely to
> >     see the folio in the swap cache and wait on it.
> >
> >     This does not eliminate all swapin races: an ongoing swapin fault may
> >     still see an empty swap cache.  That's harmless, as the PTE is changed
> >     before the swap cache is cleared, so it will just return and not trigger
> >     any repeated faults.  This does help to reduce the chance.
> >
> >
> > That changed that behavior such that we *must* now always fallback to do_wp_page().
> >
> > What a mess (I didn't ack)

That's awkward, my bad, terribly sorry about this :(

I sincerely apologize for the oversight and the trouble this has caused.

I haven't seen any performance regression in any workload recently
though, or any correctness issue, perhaps the round trip of
do_wp_page wasn't that bad. It should still catch the reuse folios,
just more costly than doing things in-place.

I think we should restore the original check first. We might also want to
avoid dropping the swap cache if the folio will not be reused, which
was discussed here:

https://lore.kernel.org/linux-mm/CAMgjq7BDfvNXdWH0cqarsujjUn3i3tDDhDkmSg01TR4h-tDorQ@mail.gmail.com/

Maybe extracting some common part into a helper can help make this
cleaner.

> 
> So it seems we need a patch before patch 4 to fix the missed
> swapcache freeing on write faults, because the write bit has already
> been cleared by the time the folio is mapped and reused?
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 14577c67c61a..e8fc5a86f6ea 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4752,6 +4752,7 @@ static void check_swap_exclusive(struct folio
> *folio, swp_entry_t entry,
>   */
>  vm_fault_t do_swap_page(struct vm_fault *vmf)
>  {
> +       enum fault_flag fault_flags = vmf->flags;
>         struct vm_area_struct *vma = vmf->vma;
>         struct folio *swapcache = NULL, *folio;
>         struct page *page;
> @@ -5091,7 +5092,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>          * an additional reference to the folio.
>          */
>         if (should_try_to_free_swap(si, folio, vma, nr_pages +
> -                       !folio_test_lru(folio), vmf->flags))
> +                       !folio_test_lru(folio), fault_flags))
>                 folio_free_swap(folio);
> 
>         folio_unlock(folio);
> 
> 
> Best Regards
> Barry

Hi Barry,

The problem is more than that, the `exclusive || folio_ref_count(folio) == 1`
in do_swap_page is also ineffective now.

But that earlier commit 4b34f1d82c65 is kind of meaningless after recent
refactor of swapin. It was trying to avoid redundant folio allocation
and thrashing from concurrent faulting process of the same PTE, but recent
swap table rework already gated that with unified folio allocation. We
are freeing the swap entry first here, that is effective enough so that
commit is no longer needed.

So perhaps we can first just revert it, how do you think?:

From 8009328e0782fc22365ef32474bae749beda637b Mon Sep 17 00:00:00 2001
From: Kairui Song <kasong@tencent.com>
Date: Thu, 25 Jun 2026 11:44:26 +0800
Subject: [PATCH] mm/swap: free swap cache before mapping to fix folio reuse

This is effectively a revert of commit 4b34f1d82c65 ("mm, swap: free the
swap cache after folio is mapped").

That commit was trying to reduce wasted fault and folio allocation
from parallel swapins of the same entry: keeping the folio in the swap
cache until the PTE is installed makes a racing fault more likely to find
it and wait on the folio lock, rather than allocate and charge a new folio
only to discover the race and throw it away, which leads to thrashing.

That benefit is marginal now. Folio allocation and swapin are both gated
on the swap entry count in the swap cache layer since commit 02d733a7ec1d
("mm, swap: unify large folio allocation"). Once the winning fault
drops the entry count, a racing fault that misses the cache will fail
the swap entry count check too and back off at the page table lock before
allocating anything. Note there is still a tiny window with or without
either patch, but it's already minimized now and should be fixed in
other ways later if needed.

Meanwhile the earlier commit has a real problem, as David pointed out [1].
The swap cache reference is still held during the write fault folio
reference check, so a sole-owned but non-exclusive write fault always
falls back to do_wp_page() instead of being reused in place. The
write-fault path of should_try_to_free_swap() is broken too as the
FAULT_FLAG_WRITE flag is missing.

There is no correctness problem though, only the reuse and cleanup
optimizations were lost.

So revert it. This makes the sole-owner check effective again and
recovers the reuse fast path. Also slightly adjust a sanity check
to be more rigorous.

Fixes: 4b34f1d82c65 ("mm, swap: free the swap cache after folio is mapped")
Reported-by: David Hildenbrand (Arm) <david@kernel.org>
Closes: https://lore.kernel.org/linux-mm/e56c4d73-ed4a-48bb-8d0a-97b1200d4a35@kernel.org/ [1]
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/memory.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index ff338c2abe92..f31d6b8e8c0b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4512,7 +4512,6 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
 static inline bool should_try_to_free_swap(struct swap_info_struct *si,
 					   struct folio *folio,
 					   struct vm_area_struct *vma,
-					   unsigned int extra_refs,
 					   unsigned int fault_flags)
 {
 	if (!folio_test_swapcache(folio))
@@ -4535,7 +4534,7 @@ static inline bool should_try_to_free_swap(struct swap_info_struct *si,
 	 * reference only in case it's likely that we'll be the exclusive user.
 	 */
 	return (fault_flags & FAULT_FLAG_WRITE) && !folio_test_ksm(folio) &&
-		folio_ref_count(folio) == (extra_refs + folio_nr_pages(folio));
+		folio_ref_count(folio) == (1 + folio_nr_pages(folio));
 }
 
 static vm_fault_t pte_marker_clear(struct vm_fault *vmf)
@@ -5033,6 +5032,24 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	 */
 	arch_swap_restore(folio_swap(entry, folio), folio);
 
+	/*
+	 * Remove the swap entry and conditionally try to free up the swapcache.
+	 * We're already holding a reference on the page but haven't mapped it
+	 * yet.
+	 *
+	 * The swap count has to be freed to 0 first so folio_free_swap
+	 * can free exclusive clean cache. Concurrent fault is very unlikely
+	 * to trigger redundant folio alloc, nor will it cause redundant IO,
+	 * as the swap entry count gates it.
+	 */
+	VM_WARN_ON_ONCE(nr_pages != 1 && nr_pages != folio_nr_pages(folio));
+	if (folio != swapcache)
+		folio_put_swap(swapcache, NULL);
+	else
+		folio_put_swap(folio, nr_pages < folio_nr_pages(folio) ? page : NULL);
+	if (should_try_to_free_swap(si, folio, vma, vmf->flags))
+		folio_free_swap(folio);
+
 	add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
 	add_mm_counter(vma->vm_mm, MM_SWAPENTS, -nr_pages);
 	pte = mk_pte(page, vma->vm_page_prot);
@@ -5067,7 +5084,6 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	if (unlikely(folio != swapcache)) {
 		folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
 		folio_add_lru_vma(folio, vma);
-		folio_put_swap(swapcache, NULL);
 	} else if (!folio_test_anon(folio)) {
 		/*
 		 * We currently only expect !anon folios that are fully
@@ -5076,12 +5092,9 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		VM_WARN_ON_ONCE_FOLIO(folio_nr_pages(folio) != nr_pages, folio);
 		VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
 		folio_add_new_anon_rmap(folio, vma, address, rmap_flags);
-		folio_put_swap(folio, NULL);
 	} else {
-		VM_WARN_ON_ONCE(nr_pages != 1 && nr_pages != folio_nr_pages(folio));
 		folio_add_anon_rmap_ptes(folio, page, nr_pages, vma, address,
 					 rmap_flags);
-		folio_put_swap(folio, nr_pages == 1 ? page : NULL);
 	}
 
 	VM_BUG_ON(!folio_test_anon(folio) ||
@@ -5090,14 +5103,6 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	arch_do_swap_page_nr(vma->vm_mm, vma, address,
 			pte, pte, nr_pages);
 
-	/*
-	 * Remove the swap entry and conditionally try to free up the swapcache.
-	 * Do it after mapping, so raced page faults will likely see the folio
-	 * in swap cache and wait on the folio lock.
-	 */
-	if (should_try_to_free_swap(si, folio, vma, nr_pages, vmf->flags))
-		folio_free_swap(folio);
-
 	folio_unlock(folio);
 	if (unlikely(folio != swapcache)) {
 		/*
-- 
2.54.0


