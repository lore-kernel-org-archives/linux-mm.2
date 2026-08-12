Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8592C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 21:00:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB87A6B0173; Wed, 12 Aug 2026 16:59:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8F5D6B0175; Wed, 12 Aug 2026 16:59:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCD176B0177; Wed, 12 Aug 2026 16:59:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9C7FC6B0173
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 16:59:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 97A5C120475
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 20:59:54 +0000 (UTC)
X-FDA: 85093834308.21.9BE2C5A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id CA2EFC0004
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 20:59:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="omo/IJPB";
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786568393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9HhQDV4TMS1IsLfsE2GhssqJQtN6BUemuKTL663tfbU=;
	b=VujOuISHZd7nkTBY3MNZly3Qw6GxKc5BnNB0Yi0nJX84gP+AntTWdZ0wXHSLHwHq+tiIjC
	wrjM1c1xYhdUbOvLtk3W83OSyS9rnBqp8quOYhfli9+pw2JoHuBViCT2gzARB+GnWb/vWH
	7/ACeGe3q3QPT+0WF2aqVb0Z81+l40A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786568393;
	b=bHqqfp/jgaMTSOZicdS9k0RpRgRW1JnuEoRqU6qvI6EXUnAlauz5fheiAgZLBOh1zg3rGU
	4jJxgwlaAqlwtXnwHM263R9y5ExsE2lB5au03BRcnSv0K8kIa+xqJ4dMNqppgTk0kcnzqX
	T1EKwYh0FTmJfW0qKWPcKq1fGfMjhKI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="omo/IJPB";
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CDC3D409A8;
	Wed, 12 Aug 2026 20:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0D41F000E9;
	Wed, 12 Aug 2026 20:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786568391;
	bh=9HhQDV4TMS1IsLfsE2GhssqJQtN6BUemuKTL663tfbU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=omo/IJPBCvJE92c/rcnjZDz5GE2f57flieOy47UKYZSiTjBEwtf20puIX65y+2GsC
	 6qb+G8t5KVimug3Lyg97m/IgE5SK0Z6HoSxSFOm3W+c0qFX/E+NiLEAmoLeoAxQyne
	 V+6+8NbbWJ0FrLyubvZp5Tu+1W5UTqb9xYTpuhbU=
Date: Wed, 12 Aug 2026 13:59:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kasong@tencent.com
Cc: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>,
 linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand
 <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng
 <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo
 Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, Oleksandr Natalenko <oleksandr@natalenko.name>,
 Suleiman Souhlal <suleiman@google.com>, "Jan Alexander Steffens (heftig)"
 <heftig@archlinux.org>, Yu Zhao <yuzhao@google.com>, Steven Barrett
 <steven@liquorix.net>, Brian Geffon <bgeffon@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Kairui Song <ryncsn@gmail.com>,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/mglru: fix and remove redundant unevictable folio
 handling
Message-Id: <20260812135950.232d9b326bf3630e8edf17ca@linux-foundation.org>
In-Reply-To: <20260812-mglru-mlock-fix-v2-1-a3fec5853c08@tencent.com>
References: <20260812-mglru-mlock-fix-v2-1-a3fec5853c08@tencent.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: yqmzxi5nyr6b7fgyo8n7smxdxeda5tfn
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CA2EFC0004
X-HE-Tag: 1786568392-467088
X-HE-Meta: U2FsdGVkX1/8LP6ukfpx/m0UyXnQ0j5jcUgeHELp0K4usEubmKtj+V7mXUFSfI1Kd9BEa4TPNLqV8ILm5Lk5mKn0SrQx6tr+yyhRIr4S0aNDy82fMqpE5mqZB77Jramz6qndNoJxVZuBBr77mRP1VCtxa2HTV+XgT4AVnPs0jxp0MFCWRiZC7+dpCcwsjW/ojGLEiWTfC7YdDLgqOAhqGEBs4Go9hwmNgQlR1jhIYf95gYs8AT0u2jegEWcRalPMtfFAdSP46lYNPKl0x0z3leVqdzbrCLsxwqc//zmfZ3L73bL+uigwvmIdGnnj/i0DH758JSoBYuRvLtXE8qQwmI/JFp2VPo9afKkyHrOnZNvMgl/7+kAECHZDGJyyHPac1O8ehp5HzuDPOyWEwgeT0LMp1YNcuRbhlJ4cJ1WUnxifb2RULlSRMoWYJtMqk82KoE/e2NkFOIhmq3RgZQIp4cZD/cjpq0vui5JOIl6JFkcTsmwasBxIIJ8fNb6SMf6516Rl+gEV2YItvDwcpuaCZ0uhi4LrbAZSikyb36Z69EPF8x1oXcTHNc72W6KNtaGOgUcKOF6Wg9bmZrm81CG8V9lEI9KPLsw+KqLaE8GIStVR/fkj6DFVs6t8dA4U0I40xEnCb646Mg7S16Tc1K4xE8biqgBaoThtbIkUCPPkc9jwgdL7xMhdvUN19vX7hrjIx+3DE9LUCzwidAWypkuz3tvuJh5V70nUyWQxU9m4M9Xivxei37sl9wI0cht7f787R531OtT3w9wg72xCigm8kESMusCayRP/ofulbMGquuvKeyyACKWk0sTQfvc9WxZTM3+8TCpBdYk2TYZgf90oQINQyNotXapbE/096DCICQrB4IJjmLeVSvrDZMNDA6mBJy7xVfssZShmrebwbAFG+aa89fzvFQg/9wJoFvWeCL+gpfkiRicPZchBU/NvFBw4coDGFv1dYmW4Nnwncfl
 BgHn/nZR
 10S49YrY2D9AimpP/2R5zwtOe1/lciVNdDkLj6YlyaOhlKXvrJfgH4WhfOuHPKctHuIrLH9sDWkgUuVG1Uo0ROwip5gfA6+9KolpwMuRAYqsloDaq29ZEQimGe8XFQNAhXaXC+Bz7j3/+gLrmw9+C22SglEHMGx3q8JJWQ8R1OnxyQDWtWHwSi8rnms87bSLGNhBbuf2Dg2UVUZG1zUcjK/nrPLUIZXy0mEuaWR0eP9fW6JxD+A7AtZrPtDVTF5riq//aErLSwOSQRtKVuZo/9A9w5jGIdz9wMy5z81fl8sBkloIeb5nXUZRa4zKEOy/uAYUQa9RwFeLnBBlIs3yduy5pA30EfVRc7Qlpy/wk318x9ZGaRk3r7UHR2JDXom0A4cRyiMGkdcf16fNUsAoW9NkVAOFSMWqIGBYH/pEuBfzD/ns=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 12 Aug 2026 20:22:39 +0800 Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org> wrote:

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
> folio_test_clear_lru() (e.g. compaction, folio_isolate_lru()) can
> succeed on a folio that has already been taken off the generation list,
> which may lead to unexpected behavior.
> 
> So fix it by isolating them as common folios and letting the generic
> shrink path cull them. This matches the classical LRU behavior, and
> there should be no visible effect on the generic eviction or isolation
> behavior.
> 
> There is no performance concern either, such a folio goes through this
> once, and then it is off the generation lists for good.

Great, thanks.

> Fixes: ac35a4902374 ("mm: multi-gen LRU: minimal implementation")

The above description makes me think -stable wants this.

That ac35a4902374 is four years old makes me think that we can feed
this in for 7.3-rc1.

OK?



