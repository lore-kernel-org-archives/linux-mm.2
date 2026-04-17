Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7D25F8E4A0
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 02:34:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BD7A6B0005; Thu, 16 Apr 2026 22:34:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06EEE6B0089; Thu, 16 Apr 2026 22:34:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA1C66B008A; Thu, 16 Apr 2026 22:34:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D31A96B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 22:34:10 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 53655140A6B
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 02:34:10 +0000 (UTC)
X-FDA: 84666478260.08.E3FFF35
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9C83914000B
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 02:34:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E5Ln9W9Q;
	spf=pass (imf23.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776393248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4NA6W2N4lguyRK/G4xeeYi0SNEjDYb0qxWjtPsw5HeY=;
	b=gt5X/I5X9Wt2uGV+T9ni8GSrVq4o0oSFCIZE4IGekGKfc4x9n5gv19pIBrktjR71wJzsoM
	oZNNR9bA1BDUv0ToxVZJNOBa9B1Ea86EUxbgxaheeXYhNxuKPoqjY1utKRsZLuUmBOwAjX
	GfxTvyfFVihMAzk314EpLexzyuxmwUQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776393248; a=rsa-sha256;
	cv=none;
	b=q1dQLJhQZuFHwt6A6iw0NU2YgFv4nR1aN9dJthUfj+6JNdQk/FFi39Iy3xQVKA7MviCm8K
	g8mgxnBxPmSTCobt8+Pseyem8KCAP07P+8KNB5XmTNVeBD7rbGa6Tr3L3ZuR5AopLdx7x9
	BedAZBJZABaRbkRm1BeOxV2b25pho5g=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E5Ln9W9Q;
	spf=pass (imf23.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5C32A405F2;
	Fri, 17 Apr 2026 02:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1B72C2BCAF;
	Fri, 17 Apr 2026 02:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776393247;
	bh=ygdv9g47ic9ApuOFDxBT5md9T4W1LAkYk/F9rQTlLT4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E5Ln9W9QE/J8EGYSL8qbYK9166EkbeNdXxjBB6QlRraHZfNZYjslaDk7b+7bo1ZvI
	 cjXIF0KblE5nOyIZGWwcIVwDOk5R/zul41ENTc2xRJKm9DnnJ3Enf7OtMIkTPx8keX
	 9P+EX8+x2GGnYiQQG4WD+nVqxHInHjVb/m7iRsBukR17nKdQQI67Oc8BfTmVQYxF5m
	 xO3gCjmMxJ2+0eRdw2jNlI09ANxXUxiVxYLKuGANxTMxfmSN+yd6PakQT1VOARwLGo
	 zP1zfM+Y1A3Ke0asKnHeopHGrUPQ5m0gE4JgWd2RdjqZ1OYX4vB4eY5d9cI1gebuxl
	 979LDkPy16BdQ==
Date: Fri, 17 Apr 2026 11:34:05 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Waiman Long <longman@redhat.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Steven Rostedt <rostedt@goodmis.org>, Hao Li <hao.li@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [RFC] making nested spin_trylock() work on UP?
Message-ID: <aeGcHXmbCuZ8cNis@hyeyoo>
References: <d762c46b-36f0-471a-b5b4-23c8cf5628ae@suse.cz>
 <aZAWGwZP_Z75YHKt@casper.infradead.org>
 <ad_cqe51pvr1WaDg@hyeyoo>
 <af3a7fa9-b368-4ffd-964d-9e4fcba863a8@kernel.org>
 <DHUNDMZS4YQ0.24SZXD72JIMCE@gmail.com>
 <aeDzovGHlFmPFpNt@hyeyoo>
 <CAADnVQLc_6SfF0h+-W+-sa-Qfvn8a02b6sbELJwpQcG7CFNqAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQLc_6SfF0h+-W+-sa-Qfvn8a02b6sbELJwpQcG7CFNqAA@mail.gmail.com>
X-Rspamd-Queue-Id: 9C83914000B
X-Rspamd-Server: rspam07
X-Stat-Signature: 761hcz4noqqz4isi91s3xxbr53xjnqcj
X-Rspam-User: 
X-HE-Tag: 1776393248-481203
X-HE-Meta: U2FsdGVkX1/vHgnK7O9NlMLQkMpbipdt2xlEkDg0OTyC3C11oVaG1+tJZMo9R3zdMBHZXjoWWud3FqJPeKbVC87I3Rc/p1fBfmH5Uh3XwXZyfhn7Qc3SrptZN9GNi9MRIx50ANB4NwCtdARfQmQwjVNIZizCArLnMbljF0/0mOxc31hARVFca8fRIfgfLiWFJAuJ1IsenevtxM/weTsY7H475X9+JKXQYHWD0rY/kdYnfyR0RfgxcOCC9pU77q4csLR/UN0zeG2rCFuwyFZQ3IJEfP1qgJrGZFIT78/LCIDTXxElxH6T4QNpKmiIpvsCylzqZ6ddgvq2mov25XxDJhax16zfN9z+vCGWa+scfd25oU+eNvLhO18Xmzo1et2x3lJ4VfG5XFTPkp3U+U6BsyjysYWzuZSVUXIJ/rVsR/Vk1Qe1YJvd3zsbP8CaGNzyf+hyCUQiWmju0TXvmS879boFfQ5fQAwmoKm8nmgN3B/S0PtvS6pXTNgsiX1l6HLARmGDzP3bLh9iRQgwV5ALuSiQj25or13sfE2XGQ79cGqGe/NjCj2D6BtSRQ3dlqPQ3/H9QipuYMwvL7OKehRP8Vbhve+zrKQUDzdwWFM4PIBsVBwNyvd7LUuWYBnO7N3xEtXbLzSDhdWlvoLKpJ66RYl+0MRhHaW6u1G0sLNnhaghT7F8uWG5nW+hWhAKLQ1vQJJGswryGI7qsWq2WHrpxskT6dJExBzFdLl3w5OnOKmk1y1FXXDsIBZqJjcO1qL4YbT1o4Ke6nKuckqihI8j8xoN/gAlP4RRKVXmj97jOxtgS/R6TS5/DYJM3QZz3CJBd7we10wWdt+kWDCH/bQI/lyqUosWAT10h6TVyx26omRPwVne/8+21RlvLi3DkUIFxSm0NNfnIMKwZRCVt4J2uf37nMlWfNjCmJry1Ufkl+MIQvfj+gL4ut6MshJD4XLWo8vEMXjD4QwuWQyYzys
 lAyL8DFd
 tbX+eoRVp2DNlUjf0zx5t7O2R7yFjs/0plKkTbZgdAeVs1sso2KEGsUPWOAnt2GhiMgm4VbGCzn/LEeGcijt+8yGG2b9jLgQazFRW9IPPqjsvV9If2u/dt/FIohE7Xa/UYy9B2KI/CHPeIQ+akDz+9aGduT0LpsD7NFFbT+vKk+F1mUoSdRJjsaiDMEtCGFmxiCUj4RMWHp2RmsuGaMMOI9s0qn19WLnHfdAAUBVQiJCEbXJQaZ/kL+rW735ZQrChrcSOjRYFtic4iBOnKxnackkbuIbwQC5wPzCELaRivwDwpHab/X3h+kpDQxo459yiFQtRyOZLN8DzwlE0jtabGSw5IiJIIAxeEDj0oqWSAvwuemOPc7sRq2j9L8Zkm4bf4Uvu5YP+6Un3iWAPKcBaGJUJGkK70vaXRUYr9QBiKIhjwqCSiOQDBJZjLNsKKvEEOa12DI/d7MQvgwO70YzeAuBGxu3PB6HyYmfHZrh2c7hBTDQPz5kvFyCulw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 07:37:49AM -0700, Alexei Starovoitov wrote:
> On Thu, Apr 16, 2026 at 7:35 AM Harry Yoo (Oracle) <harry@kernel.org> wrote:
> >
> > On Thu, Apr 16, 2026 at 07:26:36AM -0700, Alexei Starovoitov wrote:
> > > On Thu Apr 16, 2026 at 3:05 AM PDT, Vlastimil Babka (SUSE) wrote:
> > > >> I think we need a special spinlock type that wraps something like this
> > > >> and use them when spinlocks can be trylock'd in an unknown context:
> > > >> pcp lock, zone lock, per-node partial slab list lock,
> > > >> per-node barn lock, etc.
> > > >
> > > > Soudns like a lot of hassle for a niche config (SMP=n) where nobody would
> > > > use e.g. bpf tracing anyway. We already have this in kmalloc_nolock():
> > > >
> > > >         /*
> > > >          * See the comment for the same check in
> > > >          * alloc_frozen_pages_nolock_noprof()
> > > >          */
> > > >         if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
> > > >                 return NULL;
> > > >
> > > > It would be trivial to extend this to !SMP. However it wouldn't cover the
> > > > kprobe context. Any idea Alexei?
> >
> > I think Vlastimil meant it'd be trivial to do:
> >
> > if ((IS_ENABLED(CONFIG_PREEMPT_RT) || !IS_ENABLED(CONFIG_SMP))
> >                 && (in_nmi() || in_hardirq()))
> >         return NULL;
> 
> This one.

Thanks for clarifying. You mean not covering the kprobe context is fine.

But I have to ask; how is that fine? Wouldn't this leave a small
possibility for a kmalloc_nolock() caller to trigger
e.g.) use-after-free bug even without noticing? (yeah, very unlikely
for somebody to trigger in practice, but not impossible)

If it's unlikely to use bpf tracing on UP anyway, it'd be safer to just
disallow that to happen to begin with.

> > But it doesn't cover the case where kprobe hooks an arbitrary function
> > (in the middle of kmalloc() or kfree()) and calls kmalloc_nolock()?
> >
> > > Yeah. Totally fine with that.
> >
> > So I'm confused exactly what you're fine with. Did you mean this?
> >
> > if (!IS_ENABLED(CONFIG_SMP) ||
> >                 (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq())))
> >        return NULL;
> 
> Doesn't need to be that drastic.

-- 
Cheers,
Harry / Hyeonggon

