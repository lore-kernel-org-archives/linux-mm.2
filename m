Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11BF9F8D74B
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 14:35:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38FBA6B0005; Thu, 16 Apr 2026 10:35:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3671D6B0089; Thu, 16 Apr 2026 10:35:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27D8B6B008A; Thu, 16 Apr 2026 10:35:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 180ED6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 10:35:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C36FB1B8C7F
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 14:35:19 +0000 (UTC)
X-FDA: 84664666758.13.5F6F6D0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id EB12D20003
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 14:35:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IAEt9ZhW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776350118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AHjwqREaX4olKNBTjGOGV1Zd7tIlqt0km+88j1qh1ME=;
	b=ucCY5lMP3nu/YTNKKwnjaRUPaWvGUsI22OAF+QCfrjNuJ2f4tzecgwMl0cFVHRPbxrbf2n
	T03QFAhHRMOkn4A9NA1QXejT8LkRkrDnw6N4ThmSim8l7qU75DuMzodqLo8fItGe6kzPkK
	sGzfn5MnmMJ/IVYgBRuEAb2hnE7Kvh4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IAEt9ZhW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776350118; a=rsa-sha256;
	cv=none;
	b=z1jkYIebZcSO2hdP+wUJBM9Nj9q0v60tp6t8GJSFqDqpUrhUG5NtnFguXpPb7DX6SPJnSi
	NYDVxGNqPzalim6ftTKbuF9D9URQTjPohKomjwe4qO85PQmjmsToxdM59BImEJGL0F9Lwo
	eFgZjuf0/m51cZy4WOH78TsNwUMnqM8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DA665436FE;
	Thu, 16 Apr 2026 14:35:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4F2C2BCAF;
	Thu, 16 Apr 2026 14:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776350116;
	bh=cogrMzgZEQxM7xPhwtdnRLBHYY01WZA4ogqqstyhGZk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IAEt9ZhW7IbIrs+qOCzY7b4TRDQln0yB06rerpru/HkeEmABN4EJA7eGnduu8N1Qx
	 66RmTLZwL6wiWz15bQUnOqTcH94svcNq9mSumPdoKZJdbMwgL7KdmK7iaAKnaZTCkb
	 BNVHE/Mx7/eNy5llnau+nvky+W1GGUJPV3XfakxHM3q9UZqAVDdA/a9HAA9KfmHkJZ
	 8zJefhxu7ohSv/ZXzX2BRq3RXRuWnZZrBDVOAZF6JRbrA1DuKTM15SW9T2JGmQF1Ti
	 g+FAD8z6yi5tIafKKCbmCxOgNUEKB8Ue08j/XSSghXGDuPXC+9rD63PKXOaRLe8j5H
	 N6dzSUjkzHmFg==
Date: Thu, 16 Apr 2026 23:35:14 +0900
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
Message-ID: <aeDzovGHlFmPFpNt@hyeyoo>
References: <d762c46b-36f0-471a-b5b4-23c8cf5628ae@suse.cz>
 <aZAWGwZP_Z75YHKt@casper.infradead.org>
 <ad_cqe51pvr1WaDg@hyeyoo>
 <af3a7fa9-b368-4ffd-964d-9e4fcba863a8@kernel.org>
 <DHUNDMZS4YQ0.24SZXD72JIMCE@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DHUNDMZS4YQ0.24SZXD72JIMCE@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EB12D20003
X-Stat-Signature: qozb7znn8kxc9m1b5ok3pfx7fpgxxqt1
X-Rspam-User: 
X-HE-Tag: 1776350117-119383
X-HE-Meta: U2FsdGVkX1+JNrSS5jkuti6or1uPqJtzeIGLN272bjsZEus2Ad2NByX4OwJPhCIHAInd3XapuMLCBRTzyhaTb9EeEOrmqJ4OPM0/gzjDl45DjHX9R+3D2av7IHr01r+lgAi4BRu3rbtl2H5YCPQR2hSaDFfjGxYPuf8RV5gVGlUGReJ2vE5MCCaSMfLHGiYqV2+2mBNDU0pXPJZw/Z9CHtwyiwuWoLtawWUpzIK/kivNevuGB2eJNLwVFLNs8G1JVLWx3eJ11sZzIoI8YyIxjbt/BfLCZbyvB1BLIDtgmNk/PZuRjeJqnsS03MwdKeZylDUd8RMKYIDHkAGZENvQ+zR1vvMDUHg3xVqWzr40a2LyRPhi9yJ9DMxk6mrb0cJwu9B/nEHKjEqO1Rh3T+1xHhPUy7LwsCdiCZunerK15k9i/Jb910jDs0W+5fx0JrXGbyi3BhyQ41ntMT8CanrrU79OA82a2ULdYDPKa7x2ussTjDpVBboNO0F8EmJ/LTZWBEotMgMGIxgmbAwdwNZVsLDRn0SztDFDRI/BBYPe+Cor9J8ahCYSQp6JEsGNGWjH7yC57kFV3s02wMJCqKeGGn5MdoXGP4krb4DSVepk6k87osk+cPD2Xq8RTKu9yDnnCAiQMF0yO1CBQ+ERkqaXz+ws7o3eNj2FXySqdDhjhn2DyTX3pA4UOmllYAQf+Lsvmd1qnu04qH/qheoiysGFfyNx7JEsayp6NOQPY6vLM8T89J8ZqWbC3so/XUwxvmkWQ362KVKijyWizqL+yPlfeeHX/FX8ZAwQE2McvvmrHIw+nxkPsqKl3FyBBt3SDEIilsLrPOx9FwBsHiluvdJ2qIyHPPhBdaWpVCnRYJYDMrtTs5JZRv9K/tT27OrZgyCCBktQhS1CewxhFOi5GbwZCN+xmZmT2O381zh/6Mc5eiId88Ftnm2lDcGKaCkjfyEAhIX5hYI/RX38UXj8fyB
 5m3iYQ6S
 MxFVT8q+dyUOzTEuF0QFqdq8Ayf1exfsdOOuSfMVw4mkyZPtsNK/BwMpDQfY2JiIO8Ye3kjMZ1yXpVGiVnvHQiIA7Z0LhTbYUgBVUg0HXlavxarwqNlnzABYz4LHiMMchT5nKDJSzeRZ8ziKfZ8OzdRR8JkuGQRl4XBKINX0f9pC055nJTlbezKphF0UQkIEm7XD5ahlJ9DbiaGwJGZyESCbYfO3fOuoypi8oQB+x+D3c1/vGZjKeJ/s5a0t1eEAUaRQeNQAcNvOEMqaEP/RjweVsxKiBD/5pGNxnIMig1+5eKrNmBdmit/GRh9mOmDebPIT/G70KdrIcVrP8Vy+mQ3Ik4sV72dzx2qAQFAgTvkfoXQt9GN5VTAXwBqD9SNyCXEdwzkqX03fmigIUF8Hy8Yv74QwnGHGX9sJVOMGJk1Zh+sbAhxAv9jSJXT81/m1MkaoFxTX/YiAkSQdXHUDDPbVCsenxrxnpI0xX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 07:26:36AM -0700, Alexei Starovoitov wrote:
> On Thu Apr 16, 2026 at 3:05 AM PDT, Vlastimil Babka (SUSE) wrote:
> >> I think we need a special spinlock type that wraps something like this
> >> and use them when spinlocks can be trylock'd in an unknown context:
> >> pcp lock, zone lock, per-node partial slab list lock,
> >> per-node barn lock, etc.
> >
> > Soudns like a lot of hassle for a niche config (SMP=n) where nobody would
> > use e.g. bpf tracing anyway. We already have this in kmalloc_nolock():
> >
> >         /*
> >          * See the comment for the same check in
> >          * alloc_frozen_pages_nolock_noprof()
> >          */
> >         if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
> >                 return NULL;
> >
> > It would be trivial to extend this to !SMP. However it wouldn't cover the
> > kprobe context. Any idea Alexei?

I think Vlastimil meant it'd be trivial to do:

if ((IS_ENABLED(CONFIG_PREEMPT_RT) || !IS_ENABLED(CONFIG_SMP))
		&& (in_nmi() || in_hardirq()))
	return NULL;

But it doesn't cover the case where kprobe hooks an arbitrary function
(in the middle of kmalloc() or kfree()) and calls kmalloc_nolock()?

> Yeah. Totally fine with that.

So I'm confused exactly what you're fine with. Did you mean this?

if (!IS_ENABLED(CONFIG_SMP) ||
		(IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq())))
       return NULL;

Or am I missing something?

-- 
Cheers,
Harry / Hyeonggon

