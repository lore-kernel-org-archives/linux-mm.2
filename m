Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB5D6CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 08:43:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80C256B0088; Fri, 19 Jun 2026 04:43:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 795986B008A; Fri, 19 Jun 2026 04:43:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65C1B6B008C; Fri, 19 Jun 2026 04:43:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 376596B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 04:43:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BC8E01C497B
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:43:46 +0000 (UTC)
X-FDA: 84896024052.14.B46065E
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf14.hostedemail.com (Postfix) with ESMTP id E904B100009
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:43:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cTgxJITT;
	spf=pass (imf14.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781858625;
	b=W0BNW86PzDF1Ls9Kd4njXxsVFhJ6R7yVo8LolnbnvxzNq+GqyNbp2uXXIcXvVBriJHKGxf
	CmOvJc7UmLaBweOMrHOU2t4HMq/5leHTy4b4wDTxFYm2DFZevQrvfYeknwbMrkW1aaT7o/
	rZhaAkUy7MJGrJK2evV3nW6Xapn/ga0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cTgxJITT;
	spf=pass (imf14.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781858625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+JT3agkcvHZt5F7xrG4mpo3JBg3ES6F+qE2PnUZWPoY=;
	b=HfYVCjctnjghdW0F8qIqpib8nKoojqgEKeLzdcxRSkvUhIyBfJaGIcYEl2RhJ3gVUincqo
	WJ84ODfoacIL2ts7aQpfRXF34IK9mmDPD3bgYuQ0ncwJo9QTZYmQ0bU2vkJm+KbYjp1Bbf
	bwL3rXHT/YxK5o8jnqIEcJHp5c48viA=
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781858622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+JT3agkcvHZt5F7xrG4mpo3JBg3ES6F+qE2PnUZWPoY=;
	b=cTgxJITT5pXSSlZ2K4cY9UptzxTsEBWEKnVjQXQR0CMYn/dZvGA4pMdRTFDUzxDKfHf7DW
	YwsOk3J5u2GrSfhW1ql+j9ZZYOZZizTTlxe4rnUzQEJHp1LexIpHXPn3CpNQeDpUCYBDK0
	evTdnePbygzBIUKlah0fx0PxuRaF0RU=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 19 Jun 2026 08:43:33 +0000
Message-Id: <DJCW5UN9FGSY.3F00439Y7YBYD@linux.dev>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Vlastimil Babka"
 <vbabka@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi Yan"
 <ziy@nvidia.com>, "Muchun Song" <muchun.song@linux.dev>, "Oscar Salvador"
 <osalvador@suse.de>, "David Hildenbrand" <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Matthew Brost" <matthew.brost@intel.com>,
 "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>,
 "Byungchul Park" <byungchul@sk.com>, "Ying Huang"
 <ying.huang@linux.alibaba.com>, "Alistair Popple" <apopple@nvidia.com>,
 "Hao Li" <hao.li@linux.dev>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Roman Gushchin"
 <roman.gushchin@linux.dev>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>, "Harry Yoo (Oracle)" <harry@kernel.org>,
 "Gregory Price" <gourry@gourry.net>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <linux-rt-devel@lists.linux.dev>
Subject: Re: [PATCH] mm/page_alloc: unify
 __alloc_frozen_pages[_nolock]_noprof()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Brendan Jackman" <brendan.jackman@linux.dev>, "Matthew Wilcox"
 <willy@infradead.org>, "Brendan Jackman" <jackmanb@google.com>
References: <20260617-alloc-trylock-v1-1-83fd7858832e@google.com>
 <ajS96fWbG4dzP3u3@casper.infradead.org>
 <DJCVLX0WK118.3V7CXOTLISFOQ@linux.dev>
In-Reply-To: <DJCVLX0WK118.3V7CXOTLISFOQ@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: e5tmq4naenkmdpxxn354s6eje949jmzi
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E904B100009
X-Rspam-User: 
X-HE-Tag: 1781858624-573624
X-HE-Meta: U2FsdGVkX1+49c7Xa+A/j9k6eDta9KpgIM9VivbE4fQzUM9MT7Fswu9nTbAh3cMIxcfX7Xr44GqDn6AoyDjCpfCnav29aK+Qsz/kV1QqXN+nsr62LKiMbpMGtla38+BJNaw4w9j0dGsiHSq+OFqoAjtIOE3y5Z/VcHht3BL7gRt341GASftqKUOyQDF+H4MPagaz4fK1LlZi85NNR/V1uM1kQJM4BqLmVtScpf1Gvvjdm4ORWY2WTX5prdeeqinSUK5+POOWZOAZ2zhgJjXup9sLM8oRjazF9a32wGOoi0Hwrcv3zt8VYAEvnjlAanPmas8PvQnloWqjWw64K6w7GKEX0rw0OMgBwqNUuhKzwIe1nwDksk4krwoyQS8+Yic5hlhf1hfMqeIs7gRgwZugO7xR/UtI4oSdymR5WjFiRYO1Tfms7sB3i3LN6Wrhwd5wuuYqux/VkWBJ3MeeB0mb2iv0agD5iVm9rhJh7Q/d0Io3lSmrvFcEdM/10pVx6ihVZzamIOLNRnzEzxp9wnXJxIZYbYg2RB3QB/0BMQ9rxlBGQJiYxy/eVpT7vxCPYoFuvG9AWsC5qJ2SGs+xXZieBOV45Yz2wOvcVY4RWr8ONlq47lsuHrTbvlwowsmLoO9eTHXetlpnZFQmPwCFnUalKWqNAb+lzMVdssu9Os5/R/Dv4nkIXcyLzjJBZ15FUXAhSc/HYCAL9m0DvBjFdWisjQzbYRII3/wtkpuq3ZtF4tjngwwNlZtJfBj6OxDnNBno1fw/2P9f9aUFlY1v508EOrsKtpsVi4xmHZ3fp2hOFBWQ7jsjHBY8v+U2wDfz6GLHUVlTakZU/xI/O/UI/BHbproYqFC2GBxZVQ9sEkeX6v6Os4SAO/Qyyt6HMA6ILg7ymY0WepKS9rUg3ieW+7WtZzghZ3IX8sZSl+Wp4/HRC0O3PCUPEnA1wQLhfuJ2sCy1+peveWGFhYpAd1AueT/
 Yzl+KQ8P
 a+/Y96JeWpTrWVOIFzc3s8OZ5MRO5PwVVTUI3k9ErTHNvor4uMC6w1PJ+5Z7Dm0Uo42oRkZV5pQRFky6jlREjM4Lvw5PIIxtfd9nTxiXsJykIuFTV9RvTsfduvKUgSGCPbX7YjX5rCvh1TGft4OEYl+fcciVwY/0q58BKSZW/wSQYTiOZKX31qerB3wPjaJz1zKfGxi/PrKsCjqlRQzevShGMmpem7D8JTxzHJa3yrsiGX28/WzmDpHT3yoRrnFGORJlRouIgBcKg5K+D1zbgVp5rYUpod71Qf0JnhdJZgAk70N3zrpYyfMzBxgZkNCe2dJiGRQeUKHFpTgSbC+rbbGOcOD8mLtHkCefNVofpMMjE14U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jun 19, 2026 at 8:17 AM UTC, Brendan Jackman wrote:
> On Fri Jun 19, 2026 at 3:56 AM UTC, Matthew Wilcox wrote:
>> On Wed, Jun 17, 2026 at 03:29:42PM +0000, Brendan Jackman wrote:

>>> +/*
>>> + * GFP flags to set for ALLOC_TRYLOCK i.e. alloc_pages_nolock().
>>> + *
>>> + * Do not specify __GFP_DIRECT_RECLAIM, since direct claim is not allo=
wed.
>>> + * Do not specify __GFP_KSWAPD_RECLAIM either, since wake up of kswapd
>>> + * is not safe in arbitrary context.
>>> + *
>>> + * These two are the conditions for gfpflags_allow_spinning() being tr=
ue.
>>> + *
>>> + * Specify __GFP_NOWARN since failing alloc_pages_nolock() is not a re=
ason
>>> + * to warn. Also warn would trigger printk() which is unsafe from
>>> + * various contexts. We cannot use printk_deferred_enter() to mitigate=
,
>>> + * since the running context is unknown.
>>> + *
>>> + * Specify __GFP_ZERO to make sure that call to kmsan_alloc_page() bel=
ow
>>> + * is safe in any context. Also zeroing the page is mandatory for
>>> + * BPF use cases.
>>
>> It may be mandatory for BPF, but it seems wasteful for other uses.
>
> True, don't see why we shouldn't push this out to the caller, I can do
> it as part of this series.

Wait, I wasn't paying attention to the bit about kmsan_alloc_page().
__GFP_ZERO is load bearing for the implementation because otherwise
kmsan_alloc_page() does things that might not be safe in the current
context.=20

> >> +	if (alloc_flags & ALLOC_TRYLOCK) {
> >> +		VM_WARN_ON_ONCE(gfp & ~__GFP_ACCOUNT);
> >
> > So the only GFP flag the user is allowed to specify is __GFP_ACCOUNT?
> > That seems bogus; other flags would be reasonable including all the one=
s
> > in gfp_trylock, as well as GFP_HIGHMEM, GFP_DMA, GFP_MOVABLE, GFP_HARDW=
ALL.
>=20
> Definitely makes sense for the ones in gfp_trylock.
>=20
> For the others, I'm not sure - this "nolock" functionality is a bit
> weird and sketchy,=20

...

> I suspect the reason for the WARN here is "let's make
> sure we have a proper think before we allow it to grow usecases that are
> meaningfully different from the other ones". I think I like that
> conservatism here, I would lean towards keeping it? Not a passionately
> held opinion though.

I'd probably still lean towards pushing __GFP_ZERO to the caller though,
and just WARN+fail if it isn't passed, to make it explicit?

