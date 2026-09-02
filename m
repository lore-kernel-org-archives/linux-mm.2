Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD765C624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 15:40:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E35066B008A; Wed,  2 Sep 2026 11:40:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE5726B0092; Wed,  2 Sep 2026 11:40:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFC586B0099; Wed,  2 Sep 2026 11:40:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B195C6B008A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:40:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 43213120275
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:40:17 +0000 (UTC)
X-FDA: 85169233674.27.9EA6490
Received: from mta0.migadu.com (out-167.mta0.migadu.com [91.218.175.167])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2299B20007
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:40:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QbF+57ia;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.167 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788363615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SK9vxnWpHC64/KXq2W93aMYtQH0bzeUnVk04EBGc5uI=;
	b=HAxbGj68kST4oDLGOvp4pLrghqJr4ynwIs5skDTOBJBh5GM5V1DDXyNYuEZ+mo5ki9cfs/
	7lJ7ZazBQpk2Yhv788vRCGrt01XB4NHsBd9r1PgTJtJaszMML2ZveXNmIIOg+FUlrp8fwD
	qnCKoq97PtuNbhx66Obe02bwl+zaxFM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788363615;
	b=0Jd/9w7mX/OnyuXjVM8YznRdNq1OMDDW3EW0u6OhHO0M4tZoVgoAu+mIKL3hCGcb46Dasv
	IDqYB3S6l4+j/Jw58IZ3YuLRZkbZP6N9dHg4ER8hajF01InKEGmHDqAlIo9ztU+y1FOJuQ
	QYZIKKASp9yWy6nXGOvwJZVv0hEX3tI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QbF+57ia;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.167 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=XgAxi/AozePVAAsGuyYaplqRMqNIRGre5HL93/nj7/E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788363613; v=1; x=1788968413;
 b=QbF+57iaD79gvn7EK/B7z/gopq8GRR6y5Heai5CRsGqbqdrdwkEmPr0m4bjALgJgauVUPl6l
 YaDfRFev1om365xVxLQiPRAQwv9u12FnCP8TzDQmyIUbdQDJ5IciUmx5HR5r6eVyR0Zh2xLgATg
 UEM4UBdp9j8qokVhK0m+3K4s=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f8325dd3e3de5b6b;
	Wed, 02 Sep 2026 15:40:12 +0000
X-Mizu-Trace-ID: f8325dd3e3de5b6b
X-Migadu-Flow: FLOW_OUT
Date: Wed, 2 Sep 2026 08:40:10 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/shrinker: fix bogus set_shrinker_bit() with
 cgroup.memory=nokmem
Message-ID: <aphDRUyFXJjEEhJN@linux.dev>
References: <20260902073800.305481-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902073800.305481-1-jiayuan.chen@linux.dev>
X-Stat-Signature: er3566p4ahwnyygswyymhk3q44nsii85
X-Rspamd-Queue-Id: 2299B20007
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788363614-382668
X-HE-Meta: U2FsdGVkX1+ovUG77E/7txNkLEazZ1TQvzOmK9rvcbiyacD0L2fLXEBJHexglK+WjlIKtAtEs0rSASfEdBy0fYXPdQyYnc7Rn4353RkdJWSL4Y7+4s6ZpFh8fSv40qjyTRg6Ebfznu7Hz0wo311YtrTu1B5ZDpt/9S9hjvasErs89ro3AdWyHPmRq3JY5boIhaAD55u2IwGkRDlQmGV8w+Bkv2x2FbBrvpZIH8CVMroRlT9Zz4lzvCtKFFEtxIIXBtdiDHXbN768rnrtEBPqUeVdGpA0iafhp7DqkSj7gBR9JqMVl7eFosR9JiwfBk7kqUSOl0zs4urQGLidPaWnwsT5+7mCaorqO+rJimClK0Ty9v5wkQs6mf5FJiaIqg0dqs0/w5gyVP6/YWuBOoehjq6OzUQbObqcVvXJOVxDSun6xAUSa2XhA2wX4w+XNlfydbub7YE7psMbu1/8h193W/homx/UB6lE2eo7FYD9EEVlCRTPW1GHMBaC4Kn8pCI0NxR7Nx9Q+q2yt2xkHuuQsL4DmF9GiplxTClopYPeI0BGiYnq8MNwC8ED6QLAcsjgt9utShMfhCjId7nz1kqG0H6GWfnXuBJDYljO4d7Ysw7yUb45LGhNsBVzApKwy92iBjfVj9+s5xCZFTlgD8bFQicgbS6HMxZyU9D1FSYcXCKC+EmVurQPpzSwD2Gx88MjjGkXfBJCpZetq/4VSWfRxP+yMlvquEFja9IYoZONXxrgwFGsyWsZJfrpZ4x7kJ5N775OhlCIawe+vJlntbfJtbh5BAccrwo1eOyZSowVwaaOYstSf9do0uE4glT9qfy+XuBQsurSPt344eApmTPOnyBuguqz8qwf2VjTLIH6XIjQg/Mn9WNTtWUzYf+B55AFSpja0JY4FPElC3+lsNohmHP/fZ4uEht5++jGPo5NMXGkUi3HX0+s+ulXMp/embkPAIUWxClhGwkCkqRT5JT
 E28QiEoY
 BVtCjwmMhTtwACcn91dAJi6jXK9/q3KA/8Gcf20devHC3TFfjvfaBGppEndOYRy2WbCI4JFTwNb7jQCK8AoAeAkTQGb4cjLNBKkjakyleuHjNEX57HkDPNKFu8q85Uy24Dtcf+BuBcpYYX8wkIdkQtU9ZtN77EC9/Kc2+cZ2iseY13scZz8MXijxKFvYXjE1eG4Qw+4tmJo1QkZBaJSYdXJoJhAiQaxKILEFpS8F8fWCrAqWzMCj1lduIVCZtIA7yh/wpwxLl2PEx5CYIX1uTr7gOGnKJx7lVyQWFDELRdFLSi0PsLPMaUDrNXwOPJcrDhNeQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 03:37:59PM +0800, Jiayuan Chen wrote:
> With cgroup.memory=nokmem, shrinker_memcg_alloc() bails out early and
> never allocates an id, so shrinker->id keeps the 0 it got from the
> kzalloc() in shrinker_alloc(). __list_lru_init() then copies that 0
> into lru->shrinker_id, where it looks like a valid bit index.
> 
> Nothing calls expand_shrinker_info() on nokmem either, so
> shrinker_nr_max stays 0 and every memcg ends up with an empty map
> (map_nr_max == 0).
> 
> deferred_split_folio() hands a real memcg to __list_lru_add()
> regardless of whether the lru is memcg aware, so the first THP queued
> in a cgroup does set_shrinker_bit(memcg, nid, 0) and trips the bounds
> check:
> 
> WARNING: mm/shrinker.c:212 at set_shrinker_bit+0x7d/0x90, CPU#126
> Call Trace:
>  <TASK>
>  deferred_split_folio+0x18c/0x220
>  map_anon_folio_pmd_nopf+0xdd/0x130
>  map_anon_folio_pmd_pf+0x14/0xb0
>  do_huge_pmd_anonymous_page+0x1a1/0x620
>  __handle_mm_fault+0xea9/0x10d0
>  handle_mm_fault+0xe5/0x320
>  do_user_addr_fault+0x1cc/0x870
>  exc_page_fault+0x81/0x1b0
>  asm_exc_page_fault+0x27/0x30
>  </TASK>
> 
> Harmless, the WARN_ON_ONCE() is what keeps the out of bounds unit[]
> read from happening, but the id should not look valid in the first
> place. Clear it before returning.
> 
> Two other spots could paper over this: drop the id in
> __list_lru_init() when nokmem turns memcg_aware off, or make
> deferred_split_folio() pass NULL like list_lru_add_obj() does. Both
> leave shrinker->id lying around for the next caller, so fix it where
> the id is handed out.
> 
> Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

