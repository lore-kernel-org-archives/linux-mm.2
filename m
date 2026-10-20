Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A8E8606A320
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 11:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=NmWXkX5k;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=QaPbA8Nk
Received: by kanga.kvack.org (Postfix)
	id 6FD606B0490; Tue, 20 Oct 2026 07:09:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D7426B0492; Tue, 20 Oct 2026 07:09:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EAD76B0493; Tue, 20 Oct 2026 07:09:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E3B26B0490
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:09:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B228F160122
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:09:53 +0000 (UTC)
X-FDA: 85342734666.15.F64F009
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf11.hostedemail.com (Postfix) with ESMTP id E795F4000B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:09:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=NmWXkX5k;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=QaPbA8Nk;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf11.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792494592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qze9GsVDCuvc0w6qB++Wj9RPinmXFdwTA+6BdCxY1/M=;
	b=LbdMG0z0prAkdc3TtCyWuU7ryaq+iDs1xwM9r/ZIZz01mBkQhf0D3UQfrOLXVZvJEGmPwU
	N72y695gGKfgCAbn00WbA//zZfbalL1yIX+sfzZXpkd/tyFs9+5RmHBjnrpiJt5uceKHsl
	wfRNpntlf6tfAMfvrQli5lvTnZwHV28=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=NmWXkX5k;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=QaPbA8Nk;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf11.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792494592;
	b=rgyT7GUuOhXDOqfSuZYX9b0VHK0LMLBexxLdPyO4T4+I/st7uHm+CiUp9WmnaPYt6b/Aon
	kKybzgHpa/A7W6nNn2Rz4ktEQj193SE5ZvhklDxXkUtWh3smULcezO6k5MwgFqo+MaVJZa
	dFmpySIjLhm49P7JZCAc4/cGZOAjxs8=
Date: Tue, 20 Oct 2026 13:09:48 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1792494589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qze9GsVDCuvc0w6qB++Wj9RPinmXFdwTA+6BdCxY1/M=;
	b=NmWXkX5kiRg47zHcScMu4FDG96YeUHWrE1RYjqbPrQ1ZhB5vy01TKBsfKFr5mFWCPBJ899
	MDXKEuI2g2g0aBFfFdSOkXqkc+QgKfYcDd6jBbrQfr1Y6Z2jKBKS0JjQzxbtXc5FGYteby
	Z9JeX93y8BCaUd5vJpg4+9I3IYqT58hAikmwvmLgku0cyKEYCUCbCvENRTqqCHGPzWVRwX
	a2druN3/XV93Uc8a9HhNkFyJ9/Ufi0TS4H5g4h672pvjDvsTxQLJTL3B5/HLFa/iopNwuw
	BlPUlPEvgu97qvCqRqjQswP/pFcO5/0nooZPxNHGQIAyBLJXCClUO73jO2CZDg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1792494589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qze9GsVDCuvc0w6qB++Wj9RPinmXFdwTA+6BdCxY1/M=;
	b=QaPbA8Nkwz1OAhyo1nPjOtN2F30jqrtsR5wGbN3Df2I5yvgZqmk1ZxKGT5qns2rGAB7zLC
	mM//MeqmqRVENJCg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Alexander Duyck <alexanderduyck@fb.com>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: skip shuffling and reporting for no-lock
 frees
Message-ID: <20261020110948.wv_yGAhQ@linutronix.de>
References: <20261005063515.6312-1-kmehltretter@gmail.com>
 <f5e7b114-2bda-49e3-974f-170211501203@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f5e7b114-2bda-49e3-974f-170211501203@kernel.org>
X-Rspamd-Queue-Id: E795F4000B
X-Stat-Signature: 6pz8eng3aopx3ikiqx3pf716pi8zjhmb
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792494591-338074
X-HE-Meta: U2FsdGVkX19o1raWj8QC3B77if7BeisYtCq2X/FYEFjrZACW04IhNlExfw81C/WejINhHvoe13a7nQbXMR0yB7fP5UKNBvC857kSuTFsrUhYq1iifGevsz6Wja3De2/z+uTBfxYlu/4zJhBUXGeNZeWTtoWLRbjG5y+hvGX0cJPX2JNDeaSFgkugOINZ5x5E4id8wsf0yAaE5wBf+kaoBNut2MV6t/mUCJB6LWAZtHTa2l5sueMLZds8pfFfPmlsxp5QlnVEPbWjYx9PzUU0SG14cTJzrWKn53xWUAKDxjmWbsx+THGURwvP3/G1kLzWt67upqkxEHl1XQGYA3Qyco3WXv6MCy7P7z389Y6DVmQVvID8Sbr70Q3Qmm9UBOcu31NixLK+Ug7mqpsG3R+hZTwHZ0SUbdEzQyK/lYZMPytKvaVP+6u0BbeX7qDDfNdVw4vAESQSb+TFS3kWhCsgOvwsfTZfStlcG9qIrRgGrUMX7BaYjWeIJPZDY030WsgkdKgnamo2BpVDQ25L6FVxZgeYfAEVtBwTSIMcvvFs93+baOpFiyaNsy7rM4ZXkkgf0N+IzcB66WDRvnxTod3Vub57FI2QcNXMGc/ChiM0DVyOO3dAoOBFMvGb34N/bUfEAaUuTmX5vp4NVK2m1ZC/qDZqIZ6iwpwAuG8dXp+o5Grir2Wa0sZjEC61SZIo4Aa4knUk0Wwwmd2go5Zl0w21XoMoqRnzjTesoOzp6kjqTT/o5N3K27k86jumDQ90b1OCdd4AauBMfYheFtNZMsL3zGBb3Vd43peSAeqqQQblF6ooB4zL2RH4h8a+GWljTvts6zWWEIrooqUtSUesPBZO/ZxVCekn4H3lSPEZyiQhph4NTe/o4lJE1a3fbqAdzaPu5xYEFvDqFarsX4GnXPaXQbZmKJcC8JsAH8D/zCt+yFzMvFXAfEQ/Z2Izt3QoufYLJR6BA+rglmGg51HeuMi
 w9flxH/Z
 psf7LX6EaVq1/vUnwNZK8yRFJwLCL9roXT196e14w3BKkbpFBEj8uf3cGC++CWwJl7Tjtug4AkbGWz4DVKNT0EAQBd/oysGHorziRWfTN8AXwogORXa7L1g8xtElCHCh7J7NZC/TauFH3nT8trLjP/wWsMmtz9iH/WGARI66S4j6jfcNvhKC77UwRWkqYu9aRGJWCh0DzQ7kira+iem3wdzF55aH246p6UBE6+pprccPb54tFkMUab/mSxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-20 12:02:01 [+0200], Vlastimil Babka (SUSE) wrote:
> > An instrumented PREEMPT_RT lockdep run forced a random-bit cache refill
> > while calling free_pages_nolock() under a raw spinlock. The unpatched
> > allocator reported:
> > 
> >     BUG: Invalid wait context
> > 
> > The attempted lock was batched_entropy_u64.lock in get_random_u64().
> > Lockdep showed the raw test lock and zone->lock both held.
> 
> In slab we solved this by using prandom - commit a1e244a9f177 ("mm/slab: use
> prandom if !allow_spin")
> Could be better?

I hated it at first but now that I looked longer at it, it is not that
bad.

Sebastian

