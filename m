Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2568FC88E75
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 02:14:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F3266B0088; Tue, 15 Sep 2026 22:14:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A64D6B008C; Tue, 15 Sep 2026 22:14:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 172D76B0092; Tue, 15 Sep 2026 22:14:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E44F86B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 22:14:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4B509A05BE
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:14:54 +0000 (UTC)
X-FDA: 85218007308.11.4FFF17E
Received: from mta0.migadu.com (out-243.mta0.migadu.com [91.218.175.243])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4766B180003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:14:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K8deB8et;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.243 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K8deB8et;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.243 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789524891;
	b=rI5TYI5sKFxr6sUUxexy3mQ8Rbe1fTPuH0VtDkojPdehB4SjYgR7qPJYr00M7KQYGXznuH
	pJtz6sBuSnq0C8aXWYsbjAo4CK7HQgOIAelqx66WGGsDAp7laiABfXaoH9RV1zAcebTdfF
	gpmVrX6McRNPDWnNM50NN2NFaKkiJPw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789524891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+YofiNmc2k+r11NsLNUY3ZWxaGTJvfbP28Oty+Lm/Cw=;
	b=GpQJ+W7MGC8rxthKbcGJo7WtFuxgmjNJU/8oDpCeIgZuyh8JQgibloBLensaAdKFf6fIsB
	LS4O/m5oHbCoL5kakKvPWAahE5v48g3RnkW7GIzF8gJozBppkvFiqUzHEkSigMCd1JDh3M
	QvaLkRKwI5akdlFI5vlMOKVCa4G2aSA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=lqLsdeTEg6cA2AaSBrBEJdlEzfNC4PV/xJxx+hp/HkE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789524889; v=1; x=1790129689;
 b=K8deB8etutTS0bx6JOtfjx9Pv09f0fg1Sww/JfiyNxtsz09/PpnkKFhrX/MltuqWx4+JUx7M
 rAcfURnxR/0lDp9SKWZf3reXV0BmwCAgVg/vwLpBEbrwcQU5BwHgl2ofDqpIg3csq+3J34tO3U6
 SamAD/l8cx98qmTJY72xMDlo=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 7a9ac813747d9e7d;
	Wed, 16 Sep 2026 02:14:39 +0000
X-Mizu-Trace-ID: 7a9ac813747d9e7d
X-Migadu-Flow: FLOW_OUT
Date: Wed, 16 Sep 2026 10:14:31 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	"open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)" <linux-mm@kvack.org>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH v2 2/3] mm/mglru: add tracepoint for scan_folios()
Message-ID: <aqn7h3BVCCRFI2TI@fedora>
References: <20260911102939.2485750-1-ridong.chen@linux.dev>
 <20260911102939.2485750-3-ridong.chen@linux.dev>
 <aqkoeJvFzqpoGeaP@fedora>
 <e38f2b80-20f2-4787-9e07-fb601552f550@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e38f2b80-20f2-4787-9e07-fb601552f550@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 4766B180003
X-Stat-Signature: pxr8dz8ngfm73he7hbzn3wkf9hzi99yc
X-Rspamd-Server: rspam01
X-HE-Tag: 1789524891-273554
X-HE-Meta: U2FsdGVkX1+nq0uwdedr6TJWJBgjllXxctbyQcTxUeFF3aiRgFaxXGpYE93XCViXlQcKbsT6T3NTjiIeS83tp/u0/kos5Nku2Yb/fKXlooSNMnWsoxkuU8Vyvt7KMah23s4RFDbjj7dE4cWnGgG/qi+Mu/rrMhWr2r0mbWaiQTBtRkOglEfQS92vWCQ0q7ktaaOrVCvL3Wob9Wod52I8mjpW2Yly4AVoTLuotgWKsA9KfjqRSfvjcl1FDezGmrc9KXHzQUZ9671MUFbhG8VDSW3jqfYs9cP0ll1vyt2n39PyOaVjaqw3fjqxg9lSnAIsv/2Ms1XL6nTRyTZNHSW21+9OZFnBYhRck1YeD7ugqBPp9yWmvtUXDgigNeKgrs5TjB3xkpQH8ppM1aEXyfLcFAi8sjxWojCIHz5G+dItXtIrj9e1WgUYhQzSyRcu9rHyzZbor00+DRvpLnloAO4lAWZKIH6GrItIWU9HATCtcEdvd5RHZiGBtCh/86MPVcFHcWgF52fD6qCmzPlBfagNLGBjs8iV1KGmb+HU8IK/RlinnRwUTCBKFbs9B5QA6OEulqcf/ukggfubOCBW6lLf29U5tbivJx56qWqI3/RPFYu55Ss1YAko2iqD/2C9HbFs+atu99fKGJoW0JyI0B28LDJU9aMqdbNgmqvjSPGMu7H3F9VXLSvnTrWSfzc8HCA6kS66oZGXp8cfPW2fVNqt6PQewHeHZZO9HUcVj8cxAJUtq/UD39mc6PG/S4O6IJl4yFTp9noHcSxqMYKG/LGpq1t5CKIeKwiOsC+LZB2icZtXeNZ6JoB3wSOh5KjcTxpuZuahT4aeoPXa5iWoGpS7KQuzu6haU8pugHryhfWLfjcb3+lwRVl4BRmq2gS4F0mARM9ze+W7uz+Kvly/yJJuKtvrp62f6HoUs7B5WCoF4vOdbL5mX8zQf1Y8eUfwokN5KBU6ReHkzdtuVOYu/Ju
 MdI0hUC1
 aq0sMb66L/ixWuz5mfzDhEMAZLDKoCsY8OifGA5ZWmkRIle+C4jvjIPXepdcPhEerz7+yUGwLq3DwlLIBOSeRuuARMtF+V/l4w6hvFFTLjcJMfUbDXcxK0L0a+sFJ5GCZeujXUaroi74KBBj0BSBvVdqYfJy3qO17OSmIZZQxt0uJ9LOGpgQBddIIP4SffEQcVLnCEKv/HPMFJsGNAqH9COZMegtt04gpFVh4a6CnxAxs0bQnjmOB5c3AkXbPCO2Sk9ofw9lskTCZy+Z8M63wGEzsMbANu88+7cx6jWn1x9ByYn09Xug2QL9P+Sz7cyLhYqpXTRs+z3W5LNF3j3zgg588cg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/15/26 at 08:17pm, Ridong Chen wrote:
> 
> 
> On 9/15/2026 7:14 PM, Baoquan He wrote:
> > On 09/11/26 at 06:29pm, Ridong Chen wrote:
> > > From: Ridong Chen <chenridong@xiaomi.com>
> > ...snip...
> > > ---
> > >   include/trace/events/vmscan.h | 63 +++++++++++++++++++++++++++++++++++
> > >   mm/vmscan.c                   |  6 ++++
> > >   2 files changed, 69 insertions(+)
> > > 
> > > diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
> > > index 8a872990b4be..5defa8f6719c 100644
> > > --- a/include/trace/events/vmscan.h
> > > +++ b/include/trace/events/vmscan.h
> > > @@ -392,6 +392,69 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
> > >   		__print_symbolic(__entry->lru, LRU_NAMES))
> > >   );
> > > +TRACE_EVENT(mm_mglru_scan_folios,
> > > +
> > > +	TP_PROTO(struct lruvec *lruvec,
> > > +		int highest_zoneidx,
> > > +		int order,
> > > +		unsigned long nr_requested,
> > > +		unsigned long nr_scanned,
> > > +		unsigned long nr_sorted,
> > > +		unsigned long nr_skipped,
> > > +		unsigned long nr_taken,
> > > +		int lru,
> > > +		unsigned long max_seq,
> > > +		int tier,
> > > +		unsigned long min_seq),
> > 
> 
> Thank you for your review.
> 
> > Do we need show nid? Guess phone vendor doesn't care about multi-NUMA
> > system.
> > 
> 
> Eh, nid is not an mglru-specific key. Since there are 12 elements here, it
> can't be added here.

Hmm, we print memcg_id but not nid, it may not be so clear. How do you
differentiate several lruvec-s on one memcg? I am not very familiar with
trace mechanism, do we have a element number limit?

Imagine I only want to trace this function, now I can see memcg_id,
zone_idex, while don't know node/lruvec, that's a little pitty. Just my
personal opinion, I could miss anything.

> 
> 
> > And I checked v1 thread, seems Steven suggested to move the two int to
> > avoid extra padding.
> > 
> 
> Yeah, I will update it. I updated v2 to fix Sashiko's issue, before Steven
> had any comment.
> 
> 
> > > +
> > > +	TP_ARGS(lruvec, highest_zoneidx, order, nr_requested, nr_scanned,
> > > +		nr_sorted, nr_skipped, nr_taken, lru, max_seq, tier, min_seq),
> > > +
> > > +	TP_STRUCT__entry(
> > > +		__field(u64, memcg_id)
> > > +		__field(int, highest_zoneidx)
> > > +		__field(int, order)
> > > +		__field(unsigned long, nr_requested)
> > > +		__field(unsigned long, nr_scanned)
> > > +		__field(unsigned long, nr_sorted)
> > > +		__field(unsigned long, nr_skipped)
> > > +		__field(unsigned long, nr_taken)
> > > +		__field(int, lru)
> > > +		__field(unsigned long, max_seq)
> > > +		__field(int, tier)
> > > +		__field(unsigned long, min_seq)
> > > +	),
> > > +
> > > +	TP_fast_assign(
> > > +		__entry->memcg_id = mem_cgroup_id(lruvec_memcg(lruvec));
> > > +		__entry->highest_zoneidx = highest_zoneidx;
> > > +		__entry->order = order;
> > > +		__entry->nr_requested = nr_requested;
> > > +		__entry->nr_scanned = nr_scanned;
> > > +		__entry->nr_sorted = nr_sorted;
> > > +		__entry->nr_skipped = nr_skipped;
> > > +		__entry->nr_taken = nr_taken;
> > > +		__entry->lru = lru;
> > > +		__entry->max_seq = max_seq;
> > > +		__entry->tier = tier;
> > > +		__entry->min_seq = min_seq;
> > > +	),
> > > +
> > > +	TP_printk("memcg_id=%llu classzone=%d order=%d nr_requested=%lu nr_scanned=%lu nr_sorted=%lu nr_skipped=%lu nr_taken=%lu lru=%s max_seq=%lu tier=%d min_seq=%lu",
> > > +		__entry->memcg_id,
> > > +		__entry->highest_zoneidx,
> > > +		__entry->order,
> > > +		__entry->nr_requested,
> > > +		__entry->nr_scanned,
> > > +		__entry->nr_sorted,
> > > +		__entry->nr_skipped,
> > > +		__entry->nr_taken,
> > > +		__print_symbolic(__entry->lru, LRU_NAMES),
> > > +		__entry->max_seq,
> > > +		__entry->tier,
> > > +		__entry->min_seq)
> > > +);
> > > +
> > >   TRACE_EVENT(mm_vmscan_write_folio,
> > >   	TP_PROTO(struct folio *folio),
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index 2554a6513aa8..67f59aa73fb9 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -4876,6 +4876,12 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
> > >   	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
> > >   				scanned, skipped, isolated,
> > >   				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
> > > +	trace_mm_mglru_scan_folios(lruvec,
> > > +				   sc->reclaim_idx, sc->order, nr_to_scan,
> > > +				   scanned, sorted, skipped, isolated,
> > > +				   type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON,
> > > +				   lrugen->max_seq, tier,
> > > +				   lrugen->min_seq[type]);
> > 
> > And seems Steven also suggested to calculate lru, max_seq, min_seq in
> > TP_fast_assign() in v1 which could be missed.
> > 
> 
> Thanks, I will update it following Steven's suggestions.
> 
> 
> >          TP_fast_assign(
> >                  __entry->memcg_id = mem_cgroup_id(lruvec_memcg(lruvec));
> >                  __entry->highest_zoneidx = sc->reclaim_idx;
> >                  __entry->order = sc->order;
> >                  __entry->nr_requested = nr_requested;
> >                  __entry->nr_scanned = nr_scanned;
> >                  __entry->nr_sorted = nr_sorted;
> >                  __entry->nr_skipped = nr_skipped;
> >                  __entry->nr_taken = nr_taken;
> >                  __entry->lru = type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON;
> >                  __entry->max_seq = lrugen->max_seq;
> >                  __entry->tier = tier;
> >                  __entry->min_seq = lrugen->min_seq;
> >          ),
> > 
> 
> However, 'sc' is an internal structure, so sc->order cannot be accessed in
> TP_fast_assign(), and I don't think it is worth making scan_control an
> external structure just for this.

Agree.

> 
> > 
> > >   	*isolatedp = isolated;
> > >   	return scanned;
> > > -- 
> > > 2.34.1
> > > 
> 
> -- 
> Best regards
> Ridong
> 

