Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFFBC606A880
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 13:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gfxT8tOq
Received: by kanga.kvack.org (Postfix)
	id E932C6B05BC; Tue, 17 Nov 2026 08:02:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6B966B05BE; Tue, 17 Nov 2026 08:02:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA89E6B05BF; Tue, 17 Nov 2026 08:02:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AF4336B05BC
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:02:50 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 86FF6120444
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:02:49 +0000 (UTC)
X-FDA: 85444625658.26.0C24F7B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id C8DEB4000F
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:02:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gfxT8tOq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794920568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NHTczoTsGMT8ANQ9iC8XTxFw5jbc16CYKcnRaKdRcNg=;
	b=UpIogxT+51sH71fMXfCwcaVdmCfMQ/lHCmiGJ3JNSCkWwYbKp8XyAIv9JwTGaC5NOeKdHJ
	ZFCxdN0nsnwQiV4Fp7xLKzwEjZcKDaIad6OzR4HlHJWe2h10OTdYo60jDMzaGNjxumYgdd
	6RvM+rIyLz4p8K50szE0KqNMv5ki5m4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gfxT8tOq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794920568;
	b=gNT7G4NIAVssCtBu6mQqZG6VOzAblR/j4UkTjyJi2ZWa+VIYFryTCv/s6jx63IDTTXZPdY
	WDTZQlc0s3Ql4hIl5L9Od4SzFijBu2cPM/Wy7Zfo2ErT4U0XTj714yoXJxoQfBgBvBdCaK
	7hcT7yS94D9FRutq18qcij/8InLzFYA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EC62E43DBC;
	Tue, 17 Nov 2026 13:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A401F000C4;
	Tue, 17 Nov 2026 13:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794920566;
	bh=NHTczoTsGMT8ANQ9iC8XTxFw5jbc16CYKcnRaKdRcNg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gfxT8tOqXRdUP5ZGhbJ9mvTZb9kVbJlCny4E1YJEXq4QCHqILWvyyL92de395wqXz
	 ZTrkgEVjPKlbgziWlZZ4lU4NGMJvegsJS9UdZVHQqjkki7Eg8n79kHP+P0J14IUu1m
	 qAFCqvOiSA82cYhO0NFWvAkLMME2hOz0vOS/DKYraMWvIMTHiqfxg+U3mtFG8BNRoX
	 auMV2ID2jVLzveFiwbhv6laf8XUc7xNBW/FtCrxj97dZhjmBpX2yKjrgO+s7yWkrz2
	 GJWoW2qpZh7gDEMEwvedgCqZxTby9dujjuZ34/yaCqfCq38tc+6fFdz6QInoX2ekgm
	 AuLwBMwCmpP2A==
Date: Tue, 17 Nov 2026 13:02:38 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muhammad Haris Awan <m.harisawan@icloud.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Kees Cook <kees@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] fork: mark memcpy() in dup_mm() with data_race()
Message-ID: <avxPvfV4NxKL58ZR@gremlin>
References: <179489519663.1444496.15875846661591982934@icloud.com>
 <0b565b9c-1462-4fed-8836-9a7d08e4b861@kernel.org>
 <179491109101.4015489.11185824873441987133@icloud.com>
 <f75945f7-82bc-4ff2-92ac-9ec057347a41@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f75945f7-82bc-4ff2-92ac-9ec057347a41@kernel.org>
X-Rspamd-Queue-Id: C8DEB4000F
X-Stat-Signature: efcnezrpabqo5k4n96xu8kaz6ppigm83
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794920567-171936
X-HE-Meta: U2FsdGVkX199x/CBSKjODsvjoDs4O42rHWhFezNOeDI9btNpFKqkd2ycvHMqa0LiFwbFhNTbzMSQxAjyY6/EMZSIrmsVUfbMKnhJdJUMcP+jNJu1mYhp4/5tiCVmgj7k1NWYAOSqN0SAMfKncMPvIMQ/iHRaB6MA+eoP7nEZbqKMIM+ivS+0LLnIGhNzQYaMw/wdt3nMakfD5sctA/FvDdlrsmyq32EET2lPRr9WwlwyKoQhWqZMesrCPMJ1kdUrGHqSVt+A+ymJghjeYIB2hHYdWbnasyXfGj+Nopsj9k68U+wGDYUiTP6Wi8t2pnVFV+vpNDl/MVHRaKyZG6R/x3pAyr0pMJun+Xcpl2XRrat4ZGmWtWHMJ5FbRaLA094cavRY1xM847jwhgXdDnhxaSlEvLQHc65Mw/NrXQ8/36wOgKZunu2jhLE4asDrMdknt1TpcRg+5/v95wobTnMzljK0jJ1ppnhwIcJVvEujSv1D9YoVruYwqJWqsGdMwq77hiutR40bGrCh/sb1EQpu5QLdVvftX5jckxtIbNhEp7Hialx5aLJPM48LKfzYspNZIVjIcRXz+jNJKWlJNkomXJMjq1/5QsOdRRPWiYkzCOpDh0Vy9wY6OvRS9bDH8LWOTSFwviPhtdS9tPCu4XglqjQDbl4uPoMHouvT5e13pJt03HKqCIoUxAqfIuSQG3Mqrse6ZpjzmRH4vVlnQ12L8XCeUtAthOBBuSY2VgjWPTIPJIO/JSBtL+GfcE2XZ8+jSDSrZrhu/kDHB1Ikk0zzXQ6MEpikD5iEkFReHMgNOqfg5g3jrvQ0ELcExH41yOyB0l85HUwb7+gpR1iYco+4RvZz8WBPdUo+edZMmlJlhivUzJrgA3Cv/cTaDQJC4Wl6x8w+ngut0z/JYLPDrDk/qWOIAmUaSxwJ7vIjWTIJbWwde0gzTGVFYfmoNQIVfCs/CQW/3nFTyQGdq44oMd3
 K4Yx7eHM
 JTg3zIxEAjQdtxz6zTR6Gx/ghqn6B7rrPDxDTpNHM8Q4KtcFZaRkPOERiGfWYHSmHVgz2kq5HLvm0RXmkQyfBniAeQwPbOl1sH62rCCZ3oUjBlkzuZqIb5Eeqyuk2HDhJFYkic6KMqZjjhaHyFiEXm4V/TPIjPjcGHrcXKg5yGJmeVYEv0ULN2EPJK4Enlcr7crKFcKFYVAmtoPq7ErUBkRPMpO9TUdlwJQQNbHruxoj81j0DlW2FCJWONC7xchEoQmVdigMxYq7XrBmZYIZw8dYh8D4Xia47h+fw9GGJs2jc6iU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 11:54:28AM +0100, David Hildenbrand (Arm) wrote:
> On 11/17/26 11:24, Muhammad Haris Awan wrote:
> > Hi David,
> >
> > Reclaim isn't touching the new mm being initialized (which isn't added to
> > mm_list->fifo until lru_gen_add_mm() at the end of copy_process()).
>
> Oh, that makes sense.
>
> >
> > The KCSAN read is on oldmm inside dup_mm()'s memcpy(mm, oldmm, sizeof(*mm)):
> > oldmm is an already-live mm sitting on mm_list->fifo, so when an adjacent
> > exiting mm calls lru_gen_del_mm(), list_del_init() updates
> > oldmm->lru_gen.list.next/.prev under mm_list->lock.
> > > Since oldmm is live, lru_gen_del_mm() has to update those list pointers.
> > The alternatives in dup_mm() would be taking mm_list->lock (plus
> > mmlist_lock) during fork, or avoiding copying oldmm->lru_gen / oldmm->mmlist
> > (awkward because struct mm_struct uses __randomize_layout). Wrapping the

The focus on __randomize_layout is really weird. What, were you assuming you
could avoid it by using offsetof() or something? That'd be an awful solution
anyway?

> > memcpy() in data_race() avoids locking on fork and matches dup_vma() in
> > mm/vma_init.c.

(BTW this reads like it's an AI-generated reply... sigh.)

_My_ LLM says that lock thing wouldn't work without really fiddly changes as it
relies on memcg and you'd have to double-check a concurrent change didn't take
place and etc.

All to silence a once-in-4-year KCSAN report...

>
> Yeah, the only concern I have is that this is the big hammer for any members,
> not just the ones where we expect races.
>
> We hold the mmap lock in write mode, so one would assume that nothing can rally
> modify it. Well, besides these list exceptions.
>
> Let's see what others have to say, but I guess this is fine then, although a bit
> suboptimal.

Replied, but this for me is far from fine, since it means that we basically no
longer have any KCSAN protection against most of what fork does.

Since it's 1 report in 4 years, I think we can just live without it. And I don't
really trust the submitter to not try to slop some broken alternative solution.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

