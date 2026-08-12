Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0786C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 10:06:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C21946B00C1; Wed, 12 Aug 2026 06:06:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF8D86B00C5; Wed, 12 Aug 2026 06:06:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B36E26B00C6; Wed, 12 Aug 2026 06:06:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 91B816B00C1
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:06:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1F94DC016B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:06:48 +0000 (UTC)
X-FDA: 85092188496.30.023CD4D
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf19.hostedemail.com (Postfix) with ESMTP id D68B91A000D
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:06:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ukPsUs3H;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786529205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=whbGaMoThWv2dBW7Kxk5/d4zBPlY4UqC7T4kOF653JI=;
	b=AZwCEv9jz4Kyt7Ay8niYTOrGge+CudQWQwATelDlu17TM1uEON1tmTQk92xPbJSWVIthP5
	a8ddU8AibsD2VfzdHzVtZ+fPC1yceEJJivANaMEszgFY195G7yN1GXOGAEYGokxNxtVBEb
	qE/Ao52b8rTvKzqRexwh/+yWO3+lJVM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ukPsUs3H;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786529205;
	b=ihnBs7ziMeWdYoFAp39mrsgXJ/vSB8cq+VPsQMGRb9wpnBmpoC47PYgm9Mj1CVWFplHdhY
	C0HawN5VswznH6KUiw8JFnvvK0oKeav94bhg+HG+6tk4slp1iK4ppJhGkHGVpTGG+4OwNC
	QSKbN0IkDfyyJrdgYTBBlJvLPiZu5uM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1786529201; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=whbGaMoThWv2dBW7Kxk5/d4zBPlY4UqC7T4kOF653JI=;
	b=ukPsUs3H5gm/TgSR4DKe2upzPVQANr3kkcPMiiAl/AuPeWMgMzUaC+TeBzs4X3tbUI8A/ST3BMtWbsXN6pW1gvv5KUzN6rjS0rJQmbPFFQVoHuRrClTceHTpSLwmqF59MMDMvLMZTPgF90MMTAlF3hTbqyOJ2u6vJ1+HwpGs9rk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R261e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0X8rG3jP_1786529198;
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X8rG3jP_1786529198 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 12 Aug 2026 18:06:40 +0800
Message-ID: <9ac2eb18-1b8d-49b1-bbf5-757c4164c566@linux.alibaba.com>
Date: Wed, 12 Aug 2026 18:06:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mglru: fix and remove redundant unevictable folio
 handling
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Oleksandr Natalenko <oleksandr@natalenko.name>,
 Suleiman Souhlal <suleiman@google.com>,
 "Jan Alexander Steffens (heftig)" <heftig@archlinux.org>,
 Yu Zhao <yuzhao@google.com>, Steven Barrett <steven@liquorix.net>,
 Brian Geffon <bgeffon@google.com>, Kairui Song <ryncsn@gmail.com>,
 linux-kernel@vger.kernel.org
References: <20260811-mglru-mlock-fix-v1-1-8b2321d0e1d3@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260811-mglru-mlock-fix-v1-1-8b2321d0e1d3@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: kpgyrwfy9eukzxxebh3utp7ajz7yzqmg
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D68B91A000D
X-HE-Tag: 1786529203-940708
X-HE-Meta: U2FsdGVkX18NXCZRC3gQFOymkvwNhXH7Ew5IuJ+XMbAETlPzB2rIjQiE8TgL83TFsw3BZ/QeRLyeqNUQqcaYdqHLXy+HXWYEpq1dd5rKBxSp/1yg81sZHT7Vt1rnRxXBF1h9UKmfErrozXPS/h1hF4pw26cmun5IKKBOm2lavh/q2I86xCgWQxKr+GpGWUUaVHjrDHEpE8Nk/zuFC4p6LtfeBm0VvQzESyVVUt3Vvc9bgdt10DuemLvI5G2sClqXIkgcerm7/3GU22S6bRzn+K/ryNvOloZriY46+lrncJi3p4oQY4oC2nOBSTTSfk8s0Xtpdqc/dNBU+571i0cyyYM8Jnd5MqjAZo9uOoDMpVo15BwEBr1CmrRt6L3ID2u2IrRMWtHmtOCuChlY9THTZk85cZf1NyInZUDcIQjrNpoxWIeXHVfQhuZuvVSaSXxLIW/fKXs8p6uGYVj7VMWyRmckDnCIdON4+jBPVMAhkqgqpR7ZqFqLeOZFvQRPWCFZZ932agw88uoBk2EGBLzzCV9COs4+26zu9Ux2n9GECJfsoIJa8+MppVULfaUx+22NMojSYku9I1wo5DICqfkXSqYz++O/epaRp7xiSs6q+iKTlfnyGl5cTSDgAALWEdTaToXggjEcBYeuPfyqY+p5x/g4HCRhTlQacTYYcO25grgwFKvV9ucMUonUSp2/CgsATBBiIpxbu1n35rO6cvC5jUo6SlpdhPJvKsZBqYJDZZq+mNeXakG9G+w8jgSfSe3voWP/+5MAejULvJpHd6u9S+bxGo0BliuCuHm9wlmK/NcFJ0/B2W9nleVLMp2E0Sdn23oyhXZWnFhKTBaP/VcaxTm3eI2WLBNY0wqlTRhBr7pPQVX4iI8kvyhKJgjE5eOlgGGy9/R7GBinatTRXexhTbSNJjRl3wNPlzrSkcmCSWshN4cy7EJfglI9OccdZDaEK4xYvkj0Nj9J1NaUHBz
 Xow8pMqr
 YTPfnA971QKBMR26ZwFjBYM3nrngd8r0WO0Fd6MqP40kJ+s7RextAe8h253NPq0Kk4RJPAym1VIRAYswwaZyx/wtLMyyweyXhP12/HqbKDsgfMsSh1kvhSxUDSTBLiYTjoKwCUdyJtNqBQBZ9zsWFkrluWuKC2Vdzge5tLaqdpumxy57O6FkcwjU/5YcWcCllu+5mbeGgBvN0WKeg9vHxM/UWG1HMOZKK4Q7pSGXogX4PlpdKNxDdCx+TmWgcQ6X264iD3b4uqce58Fa3WXZzlYX0ZHo4jfyDOMFCWJQ1VX4uxJEEWkKf8Fcrjafv2h3ZFP9Pj4o/bgrYhfQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/11/26 5:40 PM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> sort_folio() has a shortcut for moving folios that are no longer
> evictable but are still sitting on a generation list.  However, this
> shortcut is buggy.  It does not follow the PG_lru usage convention,
> and it has a more serious issue.
> 
> Unevictable folios are not threaded on lists[LRU_UNEVICTABLE], so that
> folio->lru can be reused to hold folio->mlock_count (see the comment in
> lruvec_init()).  Hence lruvec_add_folio() skips the list_add() for them,
> and every other place that turns a folio unevictable initialises
> mlock_count explicitly: lru_add() sets it to 0, __mlock_folio() and
> __mlock_new_folio() set it to !!folio_test_mlocked(folio).
> sort_folio() sets nothing, and the lru_gen_del_folio() right above it
> may have already poisoned folio->lru via list_del(), so mlock_count
> ends up aliasing LIST_POISON2, which reads as 0x122, i.e. 290.  The
> result is user visible.  On munlock, __munlock_folio() decrements that
> bogus count, finds it still non-zero and bails out before clearing
> PG_mlocked, so the folio remains unevictable and the Mlocked
> accounting stays inflated until the folio is freed.
> 
> The shortcut also touches the LRU flags in the wrong order.  It calls
> lru_gen_del_folio() while PG_lru is still set, so a concurrent
> folio_test_clear_lru() (e.g. compaction, folio_isolate_lru()) can succeed
> on a folio that has already been taken off the generation list, may
> lead to unexpected behavior.  The generic path gets this right:
> isolate_folio() clears PG_lru first, so a racing isolator loses the
> atomic and bails.
> 
> And the shortcut is redundant.  A folio left on the generation list is
> picked up by isolate_folio(), shrink_folio_list() sends it to
> activate_locked on the !folio_evictable() check, and evict_folios()
> then hands it to folio_putback_lru(), which sets PG_unevictable and
> counts UNEVICTABLE_PGCULLED from lru_add(), with mlock_count
> initialised properly.
> 
> There is no performance concern either: such a folio goes through this
> once, and then it is off the generation lists for good, since
> lru_gen_add_folio() refuses unevictable folios.
> 
> So just remove the shortcut.  This consolidates unevictable handling in
> the generic path, and makes maintenance easier.
> 
> Fixes: ac35a4902374 ("mm: multi-gen LRU: minimal implementation")
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Good catch. Make sense to me.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

