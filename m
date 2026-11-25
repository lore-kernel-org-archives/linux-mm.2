Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EA51606A33F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 16:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UwsoFC6G
Received: by kanga.kvack.org (Postfix)
	id 1496A6B0A79; Wed, 25 Nov 2026 11:31:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 120E26B0A7B; Wed, 25 Nov 2026 11:31:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0370B6B0A7C; Wed, 25 Nov 2026 11:31:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CB07C6B0A79
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:31:58 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4C88140BBF
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:31:58 +0000 (UTC)
X-FDA: 85474183116.16.826A997
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8A43D40013
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:31:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UwsoFC6G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795624316;
	b=lDRWOcM6lWmHIMNVG41haUSmcLpBp17F2943XruBEYq9z3oEyjtriFOgXtHYM6aCxCDgQY
	PofOgWR/dQ363M3hW75lBPO6MpAJ3YZgBwXT4ElpynR04F1KbeqSNMk/sM3iXCOxegKZ0c
	ep3PG+7XPVs/7K9C8/xoxqYQhrAc6kY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795624316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kYj2Xxi2t6rEOEW9AEQRhf9Q5ZB4wLf+bcqG0Uy1bcY=;
	b=WU0AAlqDbCkvQEvaN1rpWaIo4GkuY14jXi6QeGdQCnzUk/telx++ijGYCPBdMFWmztUkqC
	Mx7Ljiv3QhIGse4tJuq9lTUZDuUaFakBQdqUpt2G2vTmBjDM8pJeKIdAxxpDGludUh51II
	pqE4jt9zPJAqZDTLTNxGgQVb2svWPnY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UwsoFC6G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 70B3E43C6A;
	Wed, 25 Nov 2026 16:31:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D4F1F000C4;
	Wed, 25 Nov 2026 16:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795624315;
	bh=kYj2Xxi2t6rEOEW9AEQRhf9Q5ZB4wLf+bcqG0Uy1bcY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UwsoFC6GUk6xmqNyiFsiWG5CS43wb19dTAzEGOVwsIQXV9Es1/Eqjx2EfP4fkWo0k
	 EyZiRiW0SLvsTXdEKJYFp30+UseXNsFGz1uTSQk9+dO8C2Nbo5nxBW7HsjkCWmdRsD
	 0poUolRdSnNBhWyW7VdQ9MVonkxfKP4vy4uFUO/iuF3VDT7N+FiV5fpcxjs+Ujdo1n
	 LnGdPqzX4+TvYEQY9nHXD2op9pxnLxOzuH5s4re+tLWEGo+0guYV9N4tYvsZZfXXod
	 usHl3/EQiP76XMzlO4zhqvkbgb+oHgbI3AXftbxnE6BJ0+u0lVhtMOr/SWw4ybZYDh
	 7yCIV6iE2oFHQ==
Date: Wed, 25 Nov 2026 16:31:53 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>, hannes@cmpxchg.org, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Subject: Re: [PATCH v4 0/8] Batched zswap_store() framework with compression
 batching
Message-ID: <awcK9oNDbc1QFJr6@google.com>
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
 <CAKEwX=MLrDn55wmVKKba5=PcU+qFpkEbMmN2SjGTfTBiFKX8cw@mail.gmail.com>
 <awXr6iHBR54wBB05@google.com>
 <CACpmpodH3UUDLEze8=5v8LWgKnZWQVrQBhzSGJFY-PwEYmHEzQ@mail.gmail.com>
 <awYsDfYqrS2ldOTw@google.com>
 <CACpmpofsU3f=PVQF4moe6n=_qit1ZGyo4FMjyM-sVgumfyN0iw@mail.gmail.com>
 <awZt7P_p-GNZ3A2i@google.com>
 <CACpmpod_87WY_PcOsNmPZvFzmJyBtCpyvvq1a_BqmZgGmO1e5A@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACpmpod_87WY_PcOsNmPZvFzmJyBtCpyvvq1a_BqmZgGmO1e5A@mail.gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8A43D40013
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: iympr9pu6cy4w79r5mthzp7sfsqpejwj
X-HE-Tag: 1795624316-179932
X-HE-Meta: U2FsdGVkX18En5AGzv26PXr/TCBhu2zZ3iKNKlbXyJUyeK6rixRDAx/n9gwlHEUinlIcxezRQCD0MDMA67ywQOLiKre5T3RQBOS/d1mr0fUtD2jZtE6tL0sTCIJDumEaQX7Z0T940Qtnc22dPjK0luy0ucROgusBkX+lPEVq9XBu9CUeGCYMD5eIjZD+gWRFGSW31ugpwPOiHTu++9jsQdtteUy7Ik1i13RyZcetgwPr7jSg3UM7/ZChDE4yUWxPOTsdlKbPmg2ujSMq5quhXGrpveLtbTPh3owfk8nRK8JFJVhrPYmpPmTtW6m9VKm1Isf6Fb4JesPyiGSv5HnaMh46WYsDq84fLJvj2WJRDOaPNaPylggbqxP7Fb9Mraw/S5VUVvHxM5oTMIwHsMFo7BHaxnZzDpVl/CDdK369NuFn/DU7yjIexygApTE/Gq6f82SBh8XkW7dyk8QCARO0q6Behvo9d5IQirtvlIx4yzKxtzH4l4uUOBk7503c9MgNGHTA1bnp4fkfxTonYIouLxfvBvpK8WRblqgqLDXyGT051AP7xTh+MXTqefUfi2C708t5oIVPy3ILIF4TL173+wBDPqbr+7ygMBuAY+Invhz3ocWFlCr9+nbUprmjqodMyhgzI8IlJv+XlrZI0DV+e4ceOS0TPycErLT552OFtHMei0pYfF9ykyyac9dyUqrxxk5xcOTub8Sd9VvEKC7Cgevdt0jovlW+yPx63eFoK7wcwKrm/dlg3q5q3gkrYXr56XTmt7JN4L5poDRouLDMDxDzu6wqsb9m/lcYia3zAZWVVyEWdS4Afp4k6iB0H/NzXglfq8AK249zHU2e1zrRuSfk1L3ysK9aDwLoc2T0tDsu3UtxBEpN0T/ZrSXoimnCy8kbJpnjsGCTnkN6v6YHCU3eDxokdp7B9B8XdlxikkAVCbXQQlOj+s89i04+pS1PPfYaIHXaRUTjyLnAmCG
 l7yUvqta
 JH0HaTY55rGd5uK+ysm5Uhx68Uh99bYhtOb0cl1L1h6F7kr6JiTB+NN1lAzIUffIf2VtS2cEKkPD+hjrNFldwf6Z5QBiHjV1mpq77GGOePaFjhkjVQDD02qz0OtAMr0jS4Faxet3CtVCHqHD5jfS6ALN00s6WyOlW7c8ophgRaSzKc4JVTkICEEY3uFjQwmwn9rUEvEQq/aEjBeOV4ynk/3sqED5eKl246bCkzarAK8cRftfXobCTiXi2bfh+QJzurrBaAN27Ze02PwmhLt/K8UbwC/R7aegUVVhEsTBe/5TKUF2r+aqm6oY+KUPc0dW0ptbL042FbGs+gB099wMvUItHlHpHgyngNcbEPOpWzHs3/iNUPBrUwCrBas4a9iCR9BwQ3Q+jxKX3fg0CDOPc6Ljb1k9WtgcsPPbGBbV10MlzD4olPpBwS3Ox2VL3rTSEmnKgs5siSD9XJer48QZ5S6pvS4WTESAlCyGdBlWGjgE9KJAnZiCG79mUQNhMZQBmsooiFILYb8exfeLqfkjJsHsY0Z/R/VN9rjJixV83d0oKQ8aSlzEzV5aMpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

[..]
> > write_s would be calculated averaging the time in the ".. bytes / ..
> > usecs" lines, and free_s by averaging the time from the ".. usecs to free
> > memory" lines.
> >
> > In this run:
> > write_s = 37.31 s
> > free_s = 23.39 s
> >
> > With your patches, I got:
> > write_s = 37.03 s
> > free_s = 18.86 s
> 
> I am not sure how useful it is to apply user-space gettimeofday()
> results that time many higher level C code API, as an indicator of
> zswap_store() performance.

It is useful to see where the time is being spent, and it is consistent
with the perf profiles.

[..]
> > You can see that the cycles spent on zswap_store() are almost the same,
> > and the cycle reduction happens in zswap_invalidate().
> 
> The cycles spent in zswap_store() should be normalized to the # of
> zswpout events that these CPU cycles represent, for this to be a
> reliable measure of latency improvement. There could be an increase in
> reclaimed folios for any number of reasons, all of which are not
> necessarily due to performance-improvement/degradation of
> zswap_store() itself. IOW, more work for less latency per unit of work
> is not always indicative of a performance degradation in this case.
> 
> A realistic scenario would be that with zswap_store() becoming more
> efficient, the 30 allocating threads cause more memory.high breaches,
> that causes more zswpout..
> This would cause more CPU cycles in zswap_store(), but the fact
> remains that zswap_store() efficiency has improved due to batching.

The zswpout number is almost identical: 45,796,107 vs 45,796,089.

[..]
> > > > If we want to address lock contention in zsmalloc freeing we should address it as
> > > > such, not by batching compression.
> > >
> > > Lock contention in zsmalloc seems like an independent optimization
> > > that is good to solve. What I don't see is a way of explaining the
> > > gains in this series based on zs_free() lock contention, and hence
> > > drawing a questionable conclusion that this series does not optimize
> > > zswap_store(), and further that batch compression is not attributing
> > > to the gains. I have provided ~10 reasons as to why the combined
> > > zswap_store_pages() batching and zswap_compress() batching improves
> > > zswap_store() performance in [2].
> >
> > See above. I think the performance improvement is a side effect of
> > calling zs_store() in rapid succession for pages in the same folio, and
> > more pages in the same folio ending up in the same zspage. As I
> > previously mentioned, this happens because all pages in usemem end up in
> > the same size class.
> >
> > The right thing to do would be optimize the zs_free() path. I am looking
> > into batching zswap entries freeing, which I believe is the right path
> > to optimize given those results.
> 
> If I can restate what you are suggesting, and please correct me if I am wrong:
> 
> 1) [Data needed]: Normalized zswap_store() CPU cycles to # of zswpout
> vmstat events in baseline and patched.
> 
> 2) [Data needed]:  Normalized zs_free() CPU cycles to # of calls to zs_free().
> 
> 3) If (2) confirms that zs_free() has become faster, then that is a
> beneficial side effect of batching, per your analysis above.

The number of zswap_store() and zs_free() calls is almost the same. So
storing doesn't get faster, freeing does.

> 4) Why are you suggesting that *instead* of acknowledging the
> beneficial side-effects of zswap store/compress batching, you would
> want to find another way to improve zs_free() latency by batching of
> zswap entries freeing? I would imagine both need to happen. The zspage
> locality side-effect isn't a contra-indicator to zswap compress
> batching.

1. It is unlikely for realistic workloads to have folio where all pages
compress to the same class.

2. Even if it happens in practice, we'd optimizing the wrong thing.
Consecutive calls to zs_store() landing in the same zspage is an
implementation detail of zsmalloc, and if it is something we want to
enforce, we can do so in the correct layer (e.g. by adding per-CPU
partial zspages like SLUB). The gains also depend on how different
threads race, and the effect of cache locality on the specific CPU.

You are basically proposing optimizing zs_free() for this scenario by
batching zs_store() calls in hopes of landing compressed pages from a
folio in the same zspage so that freeing gets faster. That's definitely
not the way to do it.

If the zsmalloc class lock is a bottleneck on the freeing side, we
should address that problem directly.

> I will run some experiments to quantify zswap_store() improvements
> better, with compress batching.

Feel free to, but we have been going back-and-forth on this a lot, and I
am trying to make it clear that your time is better spent elsewhere.

