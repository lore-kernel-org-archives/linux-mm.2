Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CD97FF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 13:12:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C026C6B008C; Tue, 28 Apr 2026 09:12:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD99B6B0092; Tue, 28 Apr 2026 09:12:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B16BF6B0093; Tue, 28 Apr 2026 09:12:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A12276B008C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:12:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 391E31A0157
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:12:16 +0000 (UTC)
X-FDA: 84708003072.26.D141DD9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 83996C0013
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:12:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IFp9yso8;
	spf=pass (imf22.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777381934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aVeeOLx0+4wlXH5eXkf38UYrnBp5tCQviyDMQPYi4+I=;
	b=oCFYyTTkZjSw+fspMcKEqAUVcfZVeql8aqm9O+TGzylz1/7YbAWkJPlS8kpGhjutpHV/w2
	YmdFkCSto9mPgQvOvDXCGtVrxPAQ/lzeuP7y/tR30+GRhDHQxWQuKoNaqtG3nN8ORJAe0l
	fls7t5BDPkakEAyRkc8qPk6oRdk6mFQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IFp9yso8;
	spf=pass (imf22.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777381934; a=rsa-sha256;
	cv=none;
	b=7hxcaghD/XtPLj5Q9FHxsmWVvxrzjhyzw/BcOZMvSLFMAhOAVMED3XVppPoUqG2TaP9s+V
	+GupDIto9SOP2mM8rhC7Mxu2kkCDpdK/pBZ/nrK4eaORppjD8PxB9mk0Bs9M2P4Df3CJPV
	FsjYKBQcbKhRsEo2lv2Ms3gjFW31fd4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 86242408BF;
	Tue, 28 Apr 2026 13:12:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E11F7C2BCB7;
	Tue, 28 Apr 2026 13:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777381933;
	bh=uY0VmYi3Cia4jgbgasYSewRnyQIPG2VCw0HBtI3tMlM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IFp9yso8BLkxrRD/pTw23VCq6WJRRGBFUs20CT5PW35GYCmnQlAm+da4pQNsWYMTu
	 wG60R6P8a/4NPr/5MWxl+7paFjSDOyLKwCWXpqNT7y39RcDji4OJILcnPzS5luCI8e
	 u35A013OVxxGgwCEJMPisAhSMjO44HY9JSXTw8yxKi7wtkx43l/Zq0lOHazX+iP++D
	 BdX8TL4WXby2ykUrZ5E485a4jd7f0dfU/Z0B3rQ/uU+PTLHg4wIrcgk7YnclpkULWQ
	 eBbovPR2Fx1aHgG072co7sp1RPmER9kYtDFDTYJgl2WeCzFI52/18WcrGWbIuhHsJk
	 kf1+Inf8EoRgg==
Date: Tue, 28 Apr 2026 22:12:06 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hao Li <hao.li@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	"Paul E . McKenney" <paulmck@kernel.org>, Frederic Weisbecker <frederic@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>, Zqiang <qiang.zhang@linux.dev>, 
	Steven Rostedt <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, rcu@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/8] mm/slab: introduce kfree_rcu_nolock()
Message-ID: <3s4jafam3la72a6y3dkfvhtzxk3fsngb2cka3bpfqrirl5m633@pz3vzizefoxb>
References: <20260416091022.36823-1-harry@kernel.org>
 <20260416091022.36823-5-harry@kernel.org>
 <aejeVK0J_jHSfVhD@milan>
 <aemevSofweaUSx0n@hyeyoo>
 <aeoD_Ts6hLsgNc9-@pc636>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeoD_Ts6hLsgNc9-@pc636>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 83996C0013
X-Stat-Signature: 87jwumomzc67xrby5zj5kx8drzqfpi53
X-HE-Tag: 1777381934-814103
X-HE-Meta: U2FsdGVkX18IzyW2oMV7YYXrYHzNFv1903ESin/mrT4cg0AJiF3nv16NFR3CF1fMnN/YlDA+kgIxpX28vqh5mmneV/fbtILGQOuVaOe4XodXGrAi+9F9EQeMGRopEWwUpY8sARJVeYsUm8tziiCxU0J67VnvZ3xSVYLzgMD2Ga3PvfPs9UESEpy4DGlO6IYgZfp7TQjJjqcNh+OON3kDTYYBPXrHjosxJP8FTBozecoEi+w8v9bOeOeDIY31msVI3v/SguXtG2O9MWvpNWCvbKDy65p+FwUHYzQwr3KTA5NcM3+ryW2T0BQfiQnlTYYMAugvspOHAcHnhjQReySDybF8PSBlkrcbnlMDQ6+IR6Zdbiqevy1QNM4tQ7tKAgbE7DjTIGip3jUdWiCL72fxd5dP2FmbLHjO9xWc1oMnY6+Qi9Y1AaCHuWBpcLk9yoMGIFM95wt/xy2iGOZ4LLcKX3o0lq/8cSs1TpMHFWdvzP9B3jdBr/E3a7BubWWJV0iP0Fk0fpTNTRr/S5Kj/3at5Y/nlW/+rB9A/nzNURgPA8ltZSfbVCTPSL3dxTCy8wrxiZMPJK/OWUGo7EbJ7VW9U5TYqi1J96mdtMeAjUFzgpojWpjZCjS9Ye0G+Zo0ar3kdBEvdKRq+HyDDSJ6803t0gaP/M9lyHnq07hUlydaqAHdapJcdUoLaTCb3bY9B22qAFxPVUgL+xpq6ZoZzG2c5OkG+aEfX/6G71T1y1TrYsoDs8m+U/05iwMkCEWdLcLGhi9WvKUv+GUIvXOU6QByTa+i9SQGMzYcGeezm3vk0gdDqjjyfxwP8mKqZ/uXMe3BjTEMY9yrqTlZJlIfTAOU56oFOXmIm+KCjF5l6TY1BT1JPyJL925EVpHXaSO0HeNmzwlcopOi0Z2Lb8ZZBakiYH+S4mj4z4oEEAjxTUc7DjEHpg9lhJUzicZe9qzaxxdCmmr+KS7GkLvUt3PKPQp
 QS0VzGaJ
 7S8UzU9chOfN4kpfzyJwTFBDxVA42dOsbpESM8U9d7ZEUhlGBjOh0GAbGmGNAcTsH8ITZ4HM6skRgGG3bYIT4TE2P59FJD7HAdI+2SLdoaetOvH3u+faAmCfElDSGUyWlAirdaI09aM6jWMQoAZV/GKUA+SlJm1CLFGQalpN6ArBh++W6YxdUwh/yNx3+K+jxawE+qPnucGixU502hYTD5ju1BEsnr/NcpAT37z9PIup/p1/vDR5dGUl+gtFiV2opmuPAZhrjG5TbmdjwtEmZLoqE4ho+gat/CjOV4estl1pdBg6ylHpd8CAYY3HzRqyVzCbVgEuOnZwow3pJB7Lmiaq5fHpvdvwL7OnD6rNtMVbT8j6K69BYxev1UNGhwT90gzD8wR2NLj76EC5sKlUCjL85W86WaJfrOxlRUMh33rnr8On3R6pa6cCC/jvboSadGJI8kXsvQhObWoKUh7x8zkQjoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ulad. Apologies for the delayed response.
I meant to reply sooner but sidetracked by other issues.

Your questions are fair, but let me try to clarify
the current situation.

And before diving into details, I would like to reiterate that
there are potentially two points to discuss here:

Point 1. Can we justify complicating subsystems by passing
	 `allow_spin` parameter all over the place?

Point 2. Can we avoid adding this complexity to kvfree_rcu() and
	 let slab handle it instead? (as mentioned in [4])

On Point 1: IMHO it could be justified, but at the same time I hope we
end up avoiding more complexity in the long term by working on Point 2.

This reply focuses only on Point 1 and explains why it could be
justified.

On Thu, Apr 23, 2026 at 01:35:25PM +0200, Uladzislau Rezki wrote:
> On Thu, Apr 23, 2026 at 01:23:25PM +0900, Harry Yoo (Oracle) wrote:
> > On Wed, Apr 22, 2026 at 04:42:28PM +0200, Uladzislau Rezki wrote:
> > How much performance do we sacrifice compared to
> > letting them go through the kvfree_rcu() fastpath?
>
> Freeing an object over RCU from
> NMI context is a corner case. It is __not_ generic.

First, I want to clarify that kfree_rcu_nolock() is not just for NMI
context. It is intended to be used when the context is unknown (because
it can be called in an arbitrary code locations).

There are two kinds of problematic situations where BPF programs
are attached to:

  - 1) a tracepoint or a function that can be invoked in a critical
       section (w/ a lock held), or

  - 2) a function that can be called in an NMI context, which might
       preempt an arbitrary context holding a lock.

While 1) and 2) are not (I think) dominant use cases, and although
most of users can legally call kvfree_rcu(), BPF can't use kvfree_rcu()
and must consider the most restrictive contexts.

> We even do not have(now
> in mainline) users because we never support it from NMI,
> just like call_rcu().

Unfortunately, we've had this use case (of allocating memory for BPF
programs) for a long time in the mainline. There are two current
approaches to mitigate the limitation:

  - 1) Pre-allocate all memory. e.g.) allocate all hash table elements
       when creating a BPF map, rather than allocating them on demand.
       This ensures correctness but sacrifices memory.

  - 2) Use the BPF-specific memory allocator [1] [2] to allocate memory
       on demand and avoid preallocation. While this wastes less memory
       than 1) and also maintains performance, it is re-inventing yet
       another memory allocator.

       Also, the allocator reinvented kfree_rcu batching as well.

Now, we're trying to avoid 1) and 2) as much as possible and use
kmalloc_nolock() instead [3].

> If BPF needs
> it, then the first question which comes to mind is not about performance.
> It is how to support this case in kfree_rcu() without adding noticeable
> complexity or overhead or hacks to the generic path without making it harder
> to maintain.

Since there will be only few subsystems that needs it, and because
they already use it on production systems, I don't see much value in
maintaining a simple implementation if that compromises performance
(and thus make the transition harder).

> Performance wise you noted, you mean:
> 
> a) call latency(this is probably the most important for NMI)?
> b) memory footprint?
> c) pointer-chasing overhead?

I think it's either

- The performance of kfree_rcu_nolock() itself (a), or
- Not distrubing workloads running on the machine (b and c)

depending on what people use BPF for.

[1] "A BPF-specific memory allocator", Jonathan Corbet, LWN.net, 2022.
    Link: https://lwn.net/Articles/899274 

[2] [LSF/MM/BPF TOPIC] Reentrant kmalloc usable from any context,
    Alexei Starovoitov, the linux-mm mailing list, 2025.
    Topic proposal: https://lore.kernel.org/linux-mm/CAADnVQ+=x31Rcjh6-qX1C+d2q0LBRCH=1gPqfKOaMXYx_fkQjw@mail.gmail.com
    Slides: https://github.com/4ast/docs/blob/main/Reentrant%20kmalloc.pdf 

[3] [GIT PULL] Introduce try_alloc_pages for 6.15, Alexei Starovoitov,
    the linux-mm mailing list, 2025.
    Link: https://lore.kernel.org/linux-mm/20250327145159.99799-1-alexei.starovoitov@gmail.com/

[4] https://lore.kernel.org/linux-mm/ael8R0vOeZ0Xbcoe@hyeyoo

After finishing this email, now I realize that I probably should have
elaborated the cover letter ;)

Hope this helps.

-- 
Cheers,
Harry / Hyeonggon

