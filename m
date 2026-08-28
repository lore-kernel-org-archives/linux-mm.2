Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACEF1C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 07:47:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA9696B0096; Fri, 28 Aug 2026 03:47:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A31EC6B0098; Fri, 28 Aug 2026 03:47:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9244B6B0099; Fri, 28 Aug 2026 03:47:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 71F756B0096
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:47:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EB77716027E
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 07:47:03 +0000 (UTC)
X-FDA: 85149897126.19.33FD382
Received: from mta1.migadu.com (out-167.mta1.migadu.com [95.215.58.167])
	by imf05.hostedemail.com (Postfix) with ESMTP id 84042100003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 07:47:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DrmnDUrE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.167 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787903222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ntv7z39asiz96JFL5F6YCW6x0htHCiGEUU9XTc/kPLA=;
	b=8aFI/i82mU/zoZZpo3sNn4XGJO5PX1CdMspZb9wyGeLZKoNSqbAGCj7U2nhnQUVkzUBmr0
	zi5kcFve1epHA3dtA9kJyp5Tu9QMLaQ3aPaE7PK4uubwIwGF8F4A4VZpOdH3qWLARAnyuA
	qe+4621rUno4bP1VN2qoCMGPHdXHtr4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DrmnDUrE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.167 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787903222;
	b=IZkSmAiWnJJJvebGe4mICPZmOlMcidPANreHZGXst8FjhPzPHz9h2YYxEUUGVR+F1FX99a
	4CyTSNd6uKtojXy1xJkOyNovpNSPHnCpPYEwXBSfzLgJHNl65sJ/gAsAQebYXooxkJvqhc
	Zis1fTxsxd0tg0xxnrR7ZI+5NIyeK4o=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/k4TG1Rle5KzwgSRdJXSrTrJk4IzEWYgF1HxKUgqwrY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787903218; v=1; x=1788508018;
 b=DrmnDUrEBHIiHMolOwEXI9sqCF/xcwRUf8+SHQiv+yF2i1SPXY/2d7jtQHIGukKn3CmU19MM
 jhggZfRgNEBWXwYzT40icM7cNUABuU4BlmgLTOCcvrXNYmX4fk/NoaIyc9ufdU4GFhF74KSy1vw
 lFgN6E/xD9VCDi+gemmeNeu0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 64408cc1a14974a2;
	Fri, 28 Aug 2026 07:46:58 +0000
X-Mizu-Trace-ID: 64408cc1a14974a2
X-Migadu-Flow: FLOW_OUT
Date: Fri, 28 Aug 2026 15:46:53 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Barry Song <baohua@kernel.org>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org,
	akpm@linux-foundation.org, david@kernel.org, rostedt@goodmis.org,
	mhiramat@kernel.org, kasong@tencent.com, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com,
	baolin.wang@linux.alibaba.com, hannes@cmpxchg.org
Subject: Re: [PATCH 1/9] mm/mglru: add MM_WALK_EMPTY stats and tracepoint
Message-ID: <apE87WYTYvfAqXbc@fedora>
References: <20260824073806.629593-1-hebaoquan@kylinos.cn>
 <20260824073806.629593-2-hebaoquan@kylinos.cn>
 <CAGsJ_4y-aAhfYEEroOD0=hromLZA63CYw6OegN9tgYBswD20cA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4y-aAhfYEEroOD0=hromLZA63CYw6OegN9tgYBswD20cA@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: f7ysu9x1koexdjrtjf3s7b9xbw5zj8zb
X-Rspamd-Queue-Id: 84042100003
X-HE-Tag: 1787903221-291866
X-HE-Meta: U2FsdGVkX19KSj5Xo6JeYfb/230TuVymnw5KE3PDsc36fxxYblQCU25kUSp9LwMs6aVKlxC3STp8FHlxcOtmispkMWsQjxeAwDxulIkuoMYCxQfw1ffhWEYH3uOUBrgi6gjmdhKViVvvXKYhVQqTi638H7fMRtPA6w37buX2L02x2T/Yum41A902RuzbZcOLAWOom0kiGMb/Ieze8c2SCMzlFsu22D8QIUVx+LreEDTh1dk3zZ23iPgDFGA/dTNQV6X6SEE7aot7v0cutzh9jt9CBqahjdL6eW62kreiP6zLWZh07z0mhg2cpqvmmq3d+WWIE6Q6QuVLV+n5WAL1gNh+2cNgKG2zkrsBpOvgyo58hj6pIIPBHlkrkSTBUt2VtzVNxD6uOFub3fHTgQFx9zfGfy1FkGaO49rEP/ABy0mMXAT2wxcNy1GgFu13nZz+eSo8YfifAXs/u1uCWe96QZfbRjPZ8Wiojp8cVrOTsAfXAd150hbtN/OX+TAe/6fgbPPN+lNgBVY6z2NZYY1KYSpBsod0dn18jkRDFP5S2vVNDoxb8tps8sz7Gh1yOu7STnRQ7PsQ88mtKW+qe70zAAyvbwqK1wVZv008X7g9uQkUBasJAie+UDyGaS19/r70OUFFtuO31AoYUWXqw2n28+5bd9vq0RvYfQakp7U6kIY1Q5nSUtLjQ6lVDS0LiunT4SeaxaGscJBZgd8bOGxaTGrFzUrTzDnKYSOPETVtONK+HrnRwADeH5pJXgFtI0yTI4KJO3GMSQz+2ZSIvFyANfW0FYmRSLxkrdn9baY1EMYFUk4KxaSLswUhg0/4qCwIQE/EB+6Nf5TTkbkl4OzzfMT6gA8rKBRqY+0C1XsUiZyPRU44wdHgU8q7ZDZbfO25W0Uj5l2FisGWY3ypP4jihnrspCt/ZjigWBE2uleCHRO7/1MIKmPmnYsCWhX5IWSMxHBcSp+vhRyzXzKUpGb
 fpXEBRsd
 MWdEk3w5KIMhy1jh9rKvAZJlwj99uisXW09Wyyx8+6fheFm0w8jaa6Mh8fKZZO+Fr+3jfz3DzTCKQObySD1ywQ4TcKkaYiJC24RjWGjr8Ooxc4J5XWLRXUeq/c9dqxtJdGQPVI7Rs12Nsbt1UDYmRBUm5lt8LDLn2NxNs8M/Zhirg3cehcnPX8iG26AFLewUdnv/InnmunkoLyqCxpG2tSyxab7NWhPSkHze6CEAAGrezi8Z9r8OeDgG1YkCuta/DLS90XA4Wy1SMWpp6ef1App4juqDqORmWMdCWpHdjqooPT4RREfXBINZIJ0M/OFCCvnmQyJvs8r046lavSBAvlHrPMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/28/26 at 01:37pm, Barry Song wrote:
> On Mon, Aug 24, 2026 at 3:38 PM Baoquan He <hebaoquan@kylinos.cn> wrote:
> >
> > Add per-walk counters to measure empty aging walks which traverse
> > an mm's page tables but find no folio for the current lruvec (node+memcg).
> > These are common on multi-NUMA node systems because lru_gen_use_mm() marks
> > an mm for all nodes at every context switch.
> >
> > New counters (accumulated in mm_state->stats[]):
> >
> >   MM_LEAF_ELIGIBLE    - folios belonging to this lruvec
> >   MM_WALK_TOTAL       - page-table walks completed
> >   MM_WALK_EMPTY       - walks that found no eligible folio
> >   MM_LEAF_TOTAL_EMPTY - leaf entries scanned by empty walks
> 
> Hi Baoquan,
> 
> I'm having a hard time understanding what MM_LEAF_ELIGIBLE means.
> In particular, I'm not sure why "eligible" refers to folios here.
> 
> I'm also finding MM_LEAF_TOTAL_EMPTY quite difficult to understand
> without looking at the implementation.
> 
> Could we come up with clearer and more descriptive names for these
> counters?  might be?
> 
> MM_LEAF_ASSOCIATED,          /* folios associated with this lruvec */
> MM_WALK_TOTAL,               /* completed page-table walks */
> MM_WALK_WITHOUT_ASSOCIATED,  /* walks with no associated folio */
> MM_LEAF_WITHOUT_ASSOCIATED,  /* leaf entries in such walks */

Sorry about the confusion, let me think about this, and your naming
suggestions sound good, I will update here if I have different
thinking. Thanks for careful reviewing.

> 
> >
> > A new tracepoint, mm_vmscan_lru_gen_walk(), fires after each walk, and the
> > debugfs lru_gen output ("TYFALWEE") exposes the new counters.
> >
> > Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> > ---
> >  include/linux/mmzone.h        |  4 ++++
> >  include/trace/events/vmscan.h | 28 ++++++++++++++++++++++++++++
> >  mm/vmscan.c                   | 30 ++++++++++++++++++++++++++----
> >  3 files changed, 58 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index 94f9c3ff5416..229d27fbfb54 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -595,6 +595,10 @@ enum {
> >         MM_LEAF_YOUNG,          /* young leaf entries */
> >         MM_NONLEAF_FOUND,       /* non-leaf entries found in Bloom filters */
> >         MM_NONLEAF_ADDED,       /* non-leaf entries added to Bloom filters */
> > +       MM_LEAF_ELIGIBLE,       /* folios belonging to this lruvec (node+memcg) */
> > +       MM_WALK_TOTAL,          /* page-table walks completed */
> > +       MM_WALK_EMPTY,          /* walks that found no eligible folio */
> > +       MM_LEAF_TOTAL_EMPTY,    /* leaf entries scanned by empty walks */
> >         NR_MM_STATS
> >  };
> >
> 
> Best Regards
> Barry
> 

