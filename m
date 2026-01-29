Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3EEED6B084
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 16:07:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8022B6B0088; Thu, 29 Jan 2026 11:07:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D9BF6B0089; Thu, 29 Jan 2026 11:07:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70FFE6B008A; Thu, 29 Jan 2026 11:07:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5F3106B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 11:07:17 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 08399140229
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:07:16 +0000 (UTC)
X-FDA: 84385480914.05.BA30A1C
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1CADD40002
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:07:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KQyhd+zH;
	spf=pass (imf12.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769702835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W4DyRR+8pEpil2SIyjO3JCOq7XaAaTnp588uXM7WQog=;
	b=OJpz9m+10CNgIDiKb7vw1mofgUTP0xvHuDIvFmeHKCEaDT3oB7Fn+CCP9CGWHc1sAro/cm
	MrbEjYoyrCARuMnugPyY+LBC56uix1pD/XB+WbhcNhif1Uuk5ESxK1PYP3nhYYBBHg4uSD
	TWwrJlv8bYkjdDj0AF11GwZklEEQVBs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KQyhd+zH;
	spf=pass (imf12.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769702835; a=rsa-sha256;
	cv=none;
	b=5r+wdE0cOvjxEulDTowD9obLDPrCwJCLhshEm6Dtf5qPOxNTWpTy3f7ZYIahkuC8Ulew+v
	49FlKbr0PFl0JR4EXfxcWOLVWEZYaS1hF5F+vTbaM7mhox6Wy418v56ZBFyOAVvZ47ClfD
	BAyXek9IZrF4LfQSaRWD4GuVsXeCWc8=
Date: Fri, 30 Jan 2026 00:06:54 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769702832;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W4DyRR+8pEpil2SIyjO3JCOq7XaAaTnp588uXM7WQog=;
	b=KQyhd+zHftxInKZGx+Z8mxveTRnfwHYW/v+DCnqYEnM+WXSvsxPmKXA3qc53XywMh1RYwm
	FroW66WMQTV9+PNir9U2yJqEhvQITRlLXF7m0gfSv9/BACckTTglyOvI32WGqct9o4ttWV
	yrgwzMfflDgF+IaG0NhAXbptwGh055M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, kasan-dev@googlegroups.com, 
	kernel test robot <oliver.sang@intel.com>, stable@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH v4 00/22] slab: replace cpu (partial) slabs with sheaves
Message-ID: <aozlag7qiwbdezzjgw3bq73ihnkeppmc5iy4hq7zosg3zyalih@ieo3a4qecfxg>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <imzzlzuzjmlkhxc7hszxh5ba7jksvqcieg5rzyryijkkdhai5q@l2t4ye5quozb>
 <390d6318-08f3-403b-bf96-4675a0d1fe98@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <390d6318-08f3-403b-bf96-4675a0d1fe98@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 6skeq6zwk5yeygmbwo837yp7jp4dpzau
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1CADD40002
X-HE-Tag: 1769702834-67318
X-HE-Meta: U2FsdGVkX1+lbBPBKiHE+x98mBhH+bP9WEc1ajVPYIkXKdpR66B7HYekTZFNNJT0TUcs0M7E7tbLGMfsMaecVcaU/hvUVhE+Kt9JbkoVLbO2YJs5/RubP6hUzuLjRi1FnKa0ctRzFmD6LyyDjrR59Uw2Fna/8oU2BkU9wWfNHyLp3d4aTwb4qnwjkjO0Pqbs+FroK+e6DpYCTeFJlB9r/SzwZErMLV438nVrN1xnwHA5VrHHL+zR7i78YUm0aGIjJP/KfB2Yjj9BCiDU7hNlyqXhQ81dmU75ifxY/Jr5GzwxxDFRYYFNbJnj6l0+0Mit6cTuAwAj8Jnn3zBssXud97K4dWYip6Jq5rAicUTFa71PpcHqJud65X75q2WKmxyM94C4mq3gHAGjfT3Bq3pCkuq/VHYQZPHVOkunyISOPdJx4jmJ2GMykHdVIhq+Vyu+CbaE7C0mcXA26a3NNoTWrcgIYUVcvmHJVghwVOawAUbZiJALTWR1sC2ZStO6zUIZVK70EzDsPVSowdqexrSK2JCjg+IkybRY2xv4o5bkcKQ4Ie9rtXck5Eg6NtlsB2+tZhZ5ylKatbyMhE1SZJLgYDQzC1G7jzDdDkCqHAXZ7BKstVFHbnwu31PSeXyzDBm/pOBiMfVFZAIW1NeAVpr3kZbImosVqJwAQfHcysketFTO17yXnstSAjc8Eq3a/OPFoKVqd1Jqv7lGox+JxEdz6N6GlOe1cvVlU973GIZaRmdu+76FOFi7jKOuD1RBpFxAlF87rScbJK0wykPRK8veNZ0wVk8JZ3E0eHfIHN6CocJvUsrXPMzbMYcsMeFvDNZFb3haGwvZh0d+11ja4bTmzvPUtAm2sa58p8Zu8p0qsUG7QxkpJuprBw+yjd531ydkVfDsY39fQ5IrXS78p4Q3tGhVULEwS538g2YeXwM71+08e2zWbkNhu1eY9Coyl1TKBclhvwqW7QATvdpBwhj
 9KbMCOys
 B9mysVIl2f5RoQuRa5kWewZmh3rIknJqxsrrl9K0z4zXG7gtmiqDSxL78aMmK609IUcKw9P662Qh35bm038ZI+12LNYaOo5zTuHvRaAFAfXkREIKviOXRVvrgAjoIvIJnUeyecBN0VNuhOaqX2equtvgKmaZEul6Q3ekh8RiLQ5nXXH6kOEpSk2ovt/yQ64ZO9o+INaXYalsCIaNM1B8B9+TJfA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 04:28:01PM +0100, Vlastimil Babka wrote:
> On 1/29/26 16:18, Hao Li wrote:
> > Hi Vlastimil,
> > 
> > I conducted a detailed performance evaluation of the each patch on my setup.
> 
> Thanks! What was the benchmark(s) used?

I'm currently using the mmap2 test case from will-it-scale. The machine is still
an AMD 2-socket system, with 2 nodes per socket, totaling 192 CPUs, with SMT
disabled. For each test run, I used 64, 128, and 192 processes respectively.

> Importantly, does it rely on vma/maple_node objects?

Yes, this test primarily puts a lot of pressure on maple_node.

> So previously those would become kind of double
> cached by both sheaves and cpu (partial) slabs (and thus hopefully benefited
> more than they should) since sheaves introduction in 6.18, and now they are
> not double cached anymore?

Exactly, since version 6.18, maple_node has indeed benefited from a dual-layer
cache.

I did wonder if this isn't a performance regression but rather the
performance returning to its baseline after removing one layer of caching.

However, verifying this idea would require completely disabling the sheaf
mechanism on version 6.19-rc5 while leaving the rest of the SLUB code untouched.
It would be great to hear any suggestions on how this might be approached.

> 
> > During my tests, I observed two points in the series where performance
> > regressions occurred:
> > 
> >     Patch 10: I noticed a ~16% regression in my environment. My hypothesis is
> >     that with this patch, the allocation fast path bypasses the percpu partial
> >     list, leading to increased contention on the node list.
> 
> That makes sense.
> 
> >     Patch 12: This patch seems to introduce an additional ~9.7% regression. I
> >     suspect this might be because the free path also loses buffering from the
> >     percpu partial list, further exacerbating node list contention.
> 
> Hmm yeah... we did put the previously full slabs there, avoiding the lock.
> 
> > These are the only two patches in the series where I observed noticeable
> > regressions. The rest of the patches did not show significant performance
> > changes in my tests.
> > 
> > I hope these test results are helpful.
> 
> They are, thanks. I'd however hope it's just some particular test that has
> these regressions,

Yes, I hope so too. And the mmap2 test case is indeed quite extreme.

> which can be explained by the loss of double caching.

If we could compare it with a version that only uses the
CPU partial list, the answer might become clearer.

