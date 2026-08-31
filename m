Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1006C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 08:18:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8129A6B008C; Mon, 31 Aug 2026 04:18:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EAC96B0092; Mon, 31 Aug 2026 04:18:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7277F6B0095; Mon, 31 Aug 2026 04:18:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C4F36B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:18:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 12A8F1C1DC5
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:18:19 +0000 (UTC)
X-FDA: 85160862318.19.945DF2C
Received: from mta0.migadu.com (out-250.mta0.migadu.com [91.218.175.250])
	by imf31.hostedemail.com (Postfix) with ESMTP id E2E6320004
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:18:16 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HMMQ9Ima;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.250 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788164297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oO+Ut4kkB1GGcSxOC6RuevH1eS7jBVJdILytnLiBn5M=;
	b=YFMCT/ESr9XbbfqetEyMx6u0lnTZt1BwpoVEQg/IyGzBzgbJnTKCy4KEuPk7wfA8OutF88
	f1loXxkkzHPbeCulgiv+VrvyPOrkIiVG34c+vIr3NtWDv3eSAy65rhZ+l7R6wfhRoF122l
	Rjuqz6sMkJXFyVeV2qJHNRh56ZTkT6A=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HMMQ9Ima;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.250 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788164297;
	b=tpReNJlmT6ClpQ3Oq0FECa7Cesoqva9HLOeJAwtyZVK1BWjsJzxEMARniaSAV37+abvT1R
	bx7x9KEcLBcH+Dqbj7BldaLkk8jYZTOpezPn3moUVJ5KrVP1C2nlsFNG0kmIpuSTo6iEWU
	KoGrKhz6B27610bCaUmsCjVmOoNnNOY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=p0Wn5LXFNiUqYCTbv3Nqi2VHkDFFge54B76gAv3Ms94=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788164295; v=1; x=1788769095;
 b=HMMQ9ImaAIs6PchMlPBCNZPoznCFG4eNwafU/GCKM27yoTlFIO9hOM++r0Ed8SOxPkNHcWMe
 7Ob/rtPunkKXjO9E5ICeHpyvEgsKs1HTHLUHhQe0O0opNP5hhT/6vDBHdM6kx/H7V+Ji3l2J6m9
 GqzeIMXN2nLcfxwrMG9tiYLI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id b65819945f0b82dc;
	Mon, 31 Aug 2026 08:18:05 +0000
X-Mizu-Trace-ID: b65819945f0b82dc
X-Migadu-Flow: FLOW_OUT
Date: Mon, 31 Aug 2026 16:17:56 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Barry Song <baohua@kernel.org>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org,
	akpm@linux-foundation.org, david@kernel.org, rostedt@goodmis.org,
	mhiramat@kernel.org, kasong@tencent.com, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com,
	baolin.wang@linux.alibaba.com, hannes@cmpxchg.org
Subject: Re: [PATCH 1/9] mm/mglru: add MM_WALK_EMPTY stats and tracepoint
Message-ID: <apU4tEOSo4aR-O_q@fedora>
References: <20260824073806.629593-1-hebaoquan@kylinos.cn>
 <20260824073806.629593-2-hebaoquan@kylinos.cn>
 <CAGsJ_4y-aAhfYEEroOD0=hromLZA63CYw6OegN9tgYBswD20cA@mail.gmail.com>
 <apE87WYTYvfAqXbc@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <apE87WYTYvfAqXbc@fedora>
X-Stat-Signature: 9r9bzu4kmy444ex8a7m67axpmjn8e8ju
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E2E6320004
X-Rspam-User: 
X-HE-Tag: 1788164296-137141
X-HE-Meta: U2FsdGVkX1/4WTpUi2QNB9fr2cxT49270R8qe1zzvgDLnrglOUTInV/MR0svRsSte8qj9egfoT45puI3S1dr6RYB31WRtebj5OO8EGcp6Hg3GZkIqd1NVqBTTr/xkeBLFeNDXNu0G3Vp4yQaYymsb7nsPk2bfOJ1aPxvfX4EA8adYysS/zkY+4rzwCMpx/8FT9Sts3P2iKY79499eR0LDJZBEO++prqFgEqqxriRv6d4+VpQXWocn2GImhQqFGTtMxRpS+krSqvB5sGdi7p7Jw+160JY/pPRBLFyPJq3xLpsUYN4M5ykSg0eBDTqX26ABfGzFOmQ8qehVdfqq839Djcp9BOhx7ceVDjTrHnPny5tUKncbvfijuzzx5fjqb73rzfvjjeBPJyxKWLAArtKiIBmWmk9I5MC/IpeF2v6uejhNVbCljkFGLwfnuJcQIcD5RfOyQ3+0u/XvSgpmDjhvo/IQ5ecSpOXQAMmYE6kn+Na1P0pSQPhb1x5XKaAmpkSd0axWknWV9ZGC2My75nk+CncjaNDx/CkDwQkh4lIFNDzzE9MePMQnwplgcdTVtCy8qu1eY9sSO75/ZXF1g+5qs03uvOXgVbdbOd1X+pKWeNNFdXN9jsEiYebpSrCyBpMyNwz2vuy+SFF6SSe2RZgj9gsNDkD+tgUuRvRJ7g2WunW9B3Dh6IxF+poqkSV3wLUO2uN9Oq8f5ZjKFwelsdogaxMxzD8++ITTmWlJs/WJQj5HS2PCgh+N0sIq9+oMin6CVgHEnf0PWra+O0aOkBgcMgyA2XWebAzYb6NuESWWDsmVGYsdLJxzvp3h25TelskkA1wY6Ff+U6NQKYcHCfMeXeGZ6xlSCF1JLfrZKFPB/z6O1XABaRLLLXuaIbxKRwYzGlviklHP0L5cwQKjqmW09ChXRZ7tNQD25U3K3vpomR4nYqw2EnBl9R1tvHf+nBwa6YDSBMd6LaaMox1Ika
 wZS5eEVt
 eop4KAq5pIwtlFOctBStJPER6RHMRuynSIBYJ3UAsdOwUElGzMdj0d/8kmujfC62pqOHmLKwgmyfuCMLHdQVEJntvNl6UVH2R82ZzwFg+AMJS9sXFuLVJJKowgYg3mrx3/JvIJNN23+ncLteA3/Z3fOrG0yisOS5WSxH2CDJEwq62WHfb8wrux+U4e2y8hVE0zTompWMWaJS3gLzpRoF134tDAAMK2Et0HgHl/6oKp3J28x2S7LG3DXvRyO49oZrVXTzIxvouxQXH5jGzWtende9cB5Xoq+VJ+ldU7iwdLAFdfJnCn0kTOLrhiW6HcfON6y8niFVKUD+3UHxkTrZu++YuWL6sdI/evOgN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/28/26 at 03:46pm, Baoquan He wrote:
> On 08/28/26 at 01:37pm, Barry Song wrote:
> > On Mon, Aug 24, 2026 at 3:38 PM Baoquan He <hebaoquan@kylinos.cn> wrote:
> > >
> > > Add per-walk counters to measure empty aging walks which traverse
> > > an mm's page tables but find no folio for the current lruvec (node+memcg).
> > > These are common on multi-NUMA node systems because lru_gen_use_mm() marks
> > > an mm for all nodes at every context switch.
> > >
> > > New counters (accumulated in mm_state->stats[]):
> > >
> > >   MM_LEAF_ELIGIBLE    - folios belonging to this lruvec
> > >   MM_WALK_TOTAL       - page-table walks completed
> > >   MM_WALK_EMPTY       - walks that found no eligible folio
> > >   MM_LEAF_TOTAL_EMPTY - leaf entries scanned by empty walks
> > 
> > Hi Baoquan,
> > 
> > I'm having a hard time understanding what MM_LEAF_ELIGIBLE means.
> > In particular, I'm not sure why "eligible" refers to folios here.
> > 
> > I'm also finding MM_LEAF_TOTAL_EMPTY quite difficult to understand
> > without looking at the implementation.
> > 
> > Could we come up with clearer and more descriptive names for these
> > counters?  might be?
> > 
> > MM_LEAF_ASSOCIATED,          /* folios associated with this lruvec */
> > MM_WALK_TOTAL,               /* completed page-table walks */
> > MM_WALK_WITHOUT_ASSOCIATED,  /* walks with no associated folio */
> > MM_LEAF_WITHOUT_ASSOCIATED,  /* leaf entries in such walks */

Hi Barry,

Thanks for the naming suggestions — they helped, and I've incorporated
most of them in v2. Here's how each counter ended up:

1. MM_LEAF_ELIGIBLE -> MM_LEAF_ASSOCIATED:
 - agreed, "eligible" was a bad choice since it normally implies reclaim
   eligibility in this context. Adopted your suggestion.

2. MM_WALK_EMPTY:
 - I kept this one rather than MM_WALK_WITHOUT_ASSOCIATED. Two reasons:
   - (a) "empty walk" is exactly the concept this series is about,
     suppressing/reducing empty page table walks, so the name ties directly
     to the motivation;
     (b) "a walk without associated [folios]" reads a bit weird. The walk
     itself isn't associated with anything, the folios in its page tables
     are. The comment now is changed as "walks that found no folio in this
     lruvec".

3. MM_LEAF_TOTAL_EMPTY -> MM_LEAF_EMPTY_WALKS:
 - I will go with this instead of MM_LEAF_WITHOUT_ASSOCIATED.
   The latter sounds like "leaf entries that have no associated folio",
   which is confusing: those leaf entries do have folios, they're just
   associated with a different lruvec (node+memcg). What's empty is the
   walk, not the leaves. MM_LEAF_EMPTY_WALKS ("leaf entries scanned during
   empty walks") is parallel to MM_WALK_EMPTY and can't be misread.

All four counters and the tracepoint field are updated accordingly.

Please check if they are OK to you.

Thanks
Baoquan

> > 
> > >
> > > A new tracepoint, mm_vmscan_lru_gen_walk(), fires after each walk, and the
> > > debugfs lru_gen output ("TYFALWEE") exposes the new counters.
> > >
> > > Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> > > ---
> > >  include/linux/mmzone.h        |  4 ++++
> > >  include/trace/events/vmscan.h | 28 ++++++++++++++++++++++++++++
> > >  mm/vmscan.c                   | 30 ++++++++++++++++++++++++++----
> > >  3 files changed, 58 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > > index 94f9c3ff5416..229d27fbfb54 100644
> > > --- a/include/linux/mmzone.h
> > > +++ b/include/linux/mmzone.h
> > > @@ -595,6 +595,10 @@ enum {
> > >         MM_LEAF_YOUNG,          /* young leaf entries */
> > >         MM_NONLEAF_FOUND,       /* non-leaf entries found in Bloom filters */
> > >         MM_NONLEAF_ADDED,       /* non-leaf entries added to Bloom filters */
> > > +       MM_LEAF_ELIGIBLE,       /* folios belonging to this lruvec (node+memcg) */
> > > +       MM_WALK_TOTAL,          /* page-table walks completed */
> > > +       MM_WALK_EMPTY,          /* walks that found no eligible folio */
> > > +       MM_LEAF_TOTAL_EMPTY,    /* leaf entries scanned by empty walks */
> > >         NR_MM_STATS
> > >  };
> > >
> > 
> > Best Regards
> > Barry
> > 

