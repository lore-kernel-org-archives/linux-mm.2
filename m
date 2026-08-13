Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9BC2C5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 00:46:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9718A6B034E; Wed, 12 Aug 2026 20:46:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 922416B034F; Wed, 12 Aug 2026 20:46:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8386E6B0350; Wed, 12 Aug 2026 20:46:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 54D746B034E
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 20:46:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 435D016047A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 00:46:01 +0000 (UTC)
X-FDA: 85094404122.26.FF9E736
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf03.hostedemail.com (Postfix) with ESMTP id 379C920003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 00:45:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=o3Y2hbTo;
	spf=pass (imf03.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786581959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QRT8RrGVuqSxCv/yXXyh/unIGYLOWUOs5uKYEzFW/BE=;
	b=c3PlB5CQw7urAM9vuxYT8xSW87CL3R0sZuXJIHlwOO5g5uoQ+2QFk8mHtA3LKo2VmTxY70
	ze90tzTLuxKvV+lBjSHXr9qIjuhzGAeLMwyupHvR7UBKGKamnmgrsEDrrt+sMJoQXSGMVK
	xo8eFbMjxOIILL267hsQmQAtpjy1JHA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=o3Y2hbTo;
	spf=pass (imf03.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786581959;
	b=0sVQ1uQUxs39KAGzpUjgZV+L74ZiWO+9glvS7f0tGCRkr47KGxRivA95Y5lND6Bc94JVGw
	gHA4y9NUXa1/Ht0yR6uZ53kkohdBqzp+y5lL0ZnxjThOVYy37EgCbTcgPH/Hw1HMTrjBxY
	KRFJEd2VBxWE/bLA24ZI9Bt4W6GNi68=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1786581955; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=QRT8RrGVuqSxCv/yXXyh/unIGYLOWUOs5uKYEzFW/BE=;
	b=o3Y2hbTo4bUPW4VzGcWbtvakiJKjBq68qibjvVAB1hG5RodUqBTmIWpZSfypqo6BcCWS5pm7de7VJmRFZCMKzwPab6MNRKM/WaYf4TcZ25X4y8EFlOyVNdpubY6QTlyDtybUYbfxZF2D0kMcLI8D6tAAVOk9iFYYPSaWTDGSlt4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0X8sfoOn_1786581952;
Received: from 30.74.144.111(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X8sfoOn_1786581952 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 13 Aug 2026 08:45:52 +0800
Message-ID: <6fbd52ec-e16b-48a7-a4cd-eb495bdd43d3@linux.alibaba.com>
Date: Thu, 13 Aug 2026 08:45:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mglru: fix and remove redundant unevictable folio
 handling
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Oleksandr Natalenko <oleksandr@natalenko.name>,
 Suleiman Souhlal <suleiman@google.com>,
 "Jan Alexander Steffens (heftig)" <heftig@archlinux.org>,
 Yu Zhao <yuzhao@google.com>, Steven Barrett <steven@liquorix.net>,
 Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org
References: <20260811-mglru-mlock-fix-v1-1-8b2321d0e1d3@tencent.com>
 <9ac2eb18-1b8d-49b1-bbf5-757c4164c566@linux.alibaba.com>
 <CAMgjq7CgrvwrkciM8GrjN8UB2O+HeRax_5zjvhRdpGKxhFxvXw@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAMgjq7CgrvwrkciM8GrjN8UB2O+HeRax_5zjvhRdpGKxhFxvXw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 379C920003
X-Stat-Signature: tydudsnnipipdpd47uopiywb6xzgd3n6
X-Rspam-User: 
X-HE-Tag: 1786581957-572852
X-HE-Meta: U2FsdGVkX1+cqjTwipcIhL2kex1n+snTtk5GU08nIJqPWAt2BZNafQb11+KoJoJbMJf+2ThlPHF4Qv0dE/F3hxN+8dDR6w2r64tM/2gZJJYDkI2tXZxCtuvBlM2rMxWZXGuIMAUCBHisnIzQRws3SjGhRc40BOY+I6ACGpghbyLYHVka6Mv4k6ICskw94A4JDs7o6vt4hxUA/PnjjnqE0ITaOYqKLDF8HFGx0AgaV+lfgh7iH8Y6qeRcgRCEin+Akro4CDto1lVsBUplHmX+Zvg+5v0ZMvqGpH0O5jL8iG3NRNnWenJbcVCnn75EAgbm68S8OkatuNTiJ5rKCCHc+ecHgjYHBz1N+ql0Pyz+WMazNoLJLoxdwsA1HzBY2WPpzEdWUmMUppF3xCi3UEQYbyiTHadD30lwvGsALCZYBQ//AKg2Mk9Li8gYw5TAZvNtrqZIpERoAz9Y8mlW5EyALUxEf5PhgAmg134yz3yVuifZJh6cbUkaNnuJkMnaQU77Kq1bpatg0+sOBTFqE9CMlp2f8jLAEaKUXjrOBdp79co6L1l/eMj7D5s+rMNte0IYodH4UFO30WLm1VNoi9VWCYSI+Kii9ePQDViGw22mtYBiY2BxLPW8S1FRrTsnYsOklFwEGqNF/aj9951ICEEUIjhtNxF2/iwktVbL6o4AaQknq51hYLDhcLrCxcnPGH3XbHgARhRSSmHV7z/jiggBKUBVmwZt0FEvggasiua55sLeqSQJAtGYY4BvoISH87JMnaPjaWiD5sqSdURE+JqNBpN5V1XiDX9Xn593otwYcsLC1+U/HGuG87Cjn/mC2isObZ1emf+9h2D08mhNCtty6fUI55/T93YT49Rh0jLWXAtOAuZ5TC82bzHPNaV91VlghxH/o1cWZw+xxeOBgTQALYCRzvXHu3bmqS23o/zHnWaxnpVPoXEWZQZ1MGYjTK7dYfrQVNqGXOO6R291pOj
 j8EANlDj
 eno/7QMq+EQSXcmVfM+Wsu8RnBmNJto1YpYarO4hsUZYraU5yAUk8LS5V4xn4pb9b1GSOVT4QqyvL7uVTe+jCPHiTxOYBvxkrInG6xXzbxfW0N2a1VrzEtp7KUoFlJEdcS2hfZuE3I9GLya2LM7pOSUSzHFPTnHYE1XHl8H1BOCPSMYM7QPydSe4V8dbT52RFFw1cWLeL3eWAtvPOaDGOKtLv7pj+c3IowObeeNhp1o6QVbXKfsc1y2J2w8aNXk3FMkdkqKGhUyCM+LVkciTLWIGlc5oLPK3O1tQ5bSabWWhfHTFryrrjckKMPYWlnwJ1bnaKJsx4yGJd2lLt+PpTqpWRwAWbQGgNPfaO3vMzuBIXA4PpWzS03EhKVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/12/26 8:28 PM, Kairui Song wrote:
> On Wed, Aug 12, 2026 at 6:06 PM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>>
>> On 8/11/26 5:40 PM, Kairui Song via B4 Relay wrote:
>>> From: Kairui Song <kasong@tencent.com>
>>>
>>> sort_folio() has a shortcut for moving folios that are no longer
>>> evictable but are still sitting on a generation list.  However, this
>>> shortcut is buggy.  It does not follow the PG_lru usage convention,
>>> and it has a more serious issue.
>>>
>>> Unevictable folios are not threaded on lists[LRU_UNEVICTABLE], so that
>>> folio->lru can be reused to hold folio->mlock_count (see the comment in
>>> lruvec_init()).  Hence lruvec_add_folio() skips the list_add() for them,
>>> and every other place that turns a folio unevictable initialises
>>> mlock_count explicitly: lru_add() sets it to 0, __mlock_folio() and
>>> __mlock_new_folio() set it to !!folio_test_mlocked(folio).
>>> sort_folio() sets nothing, and the lru_gen_del_folio() right above it
>>> may have already poisoned folio->lru via list_del(), so mlock_count
>>> ends up aliasing LIST_POISON2, which reads as 0x122, i.e. 290.  The
>>> result is user visible.  On munlock, __munlock_folio() decrements that
>>> bogus count, finds it still non-zero and bails out before clearing
>>> PG_mlocked, so the folio remains unevictable and the Mlocked
>>> accounting stays inflated until the folio is freed.
>>>
>>> The shortcut also touches the LRU flags in the wrong order.  It calls
>>> lru_gen_del_folio() while PG_lru is still set, so a concurrent
>>> folio_test_clear_lru() (e.g. compaction, folio_isolate_lru()) can succeed
>>> on a folio that has already been taken off the generation list, may
>>> lead to unexpected behavior.  The generic path gets this right:
>>> isolate_folio() clears PG_lru first, so a racing isolator loses the
>>> atomic and bails.
>>>
>>> And the shortcut is redundant.  A folio left on the generation list is
>>> picked up by isolate_folio(), shrink_folio_list() sends it to
>>> activate_locked on the !folio_evictable() check, and evict_folios()
>>> then hands it to folio_putback_lru(), which sets PG_unevictable and
>>> counts UNEVICTABLE_PGCULLED from lru_add(), with mlock_count
>>> initialised properly.
>>>
>>> There is no performance concern either: such a folio goes through this
>>> once, and then it is off the generation lists for good, since
>>> lru_gen_add_folio() refuses unevictable folios.
>>>
>>> So just remove the shortcut.  This consolidates unevictable handling in
>>> the generic path, and makes maintenance easier.
>>>
>>> Fixes: ac35a4902374 ("mm: multi-gen LRU: minimal implementation")
>>> Signed-off-by: Kairui Song <kasong@tencent.com>
>>> ---
>>
>> Good catch. Make sense to me.
>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> 
> Hi Baolin
> 
> Thank you very mcuh for the review!
> 
> I just sent a V2 here:
> https://lore.kernel.org/linux-mm/20260812-mglru-mlock-fix-v2-1-a3fec5853c08@tencent.com/T/#u
> 
> This is a bit different, idea is still the same but I changed the
> code, since the patch is very small so it's basically a rewrite, hence
> I didn't include this review by. Can you help have a look at v2 as
> well?

Sure. Thanks for the fix.

