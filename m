Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A769ED4A5E2
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 02:38:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 197BF6B0088; Thu, 15 Jan 2026 21:38:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 145EB6B0089; Thu, 15 Jan 2026 21:38:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 048776B008A; Thu, 15 Jan 2026 21:38:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB82A6B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:38:23 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AF4C2592B2
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 02:38:23 +0000 (UTC)
X-FDA: 84336268086.28.6B4E84B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1D3FE1C0004
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 02:38:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LA7feMTf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of dennis@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dennis@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768531102; a=rsa-sha256;
	cv=none;
	b=pJ/PyU552YWPMaXyA0LGgovrzjFY1iN8JmXZwdTqLoC+cFHXxpIknQvly5vCHVD6o12Hif
	Ibqt35dN2hPJ+Lq6p6diXqJnTKMWpXiDT9XG8/INqb/v1fnUjLsZBxxDWpolQ9T+KyFqaT
	rebAvJK9MCanF6jDx6fVsgI/U+sxDDU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LA7feMTf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of dennis@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dennis@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768531102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AELZBeCJGH21HBefAeEfZSHKVeFrfSvOdqmpNpCzFdU=;
	b=sHUp/n0Ws6bVUdYiiAnBvrPt0cBLREFUeoxclIeP4+dJpEopCEIbYFLDlt75S48e7so1jV
	04/+n3jyxN+Z1dHThCPDv/6XqIcsa5S5MFsuzhPJ6IL4C2KgODJ+eZHC61+ZeoXj4VGwGl
	b7aDntavJFfhoapN04sNgZXKfJM7unk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 80F7660167;
	Fri, 16 Jan 2026 02:38:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05933C116D0;
	Fri, 16 Jan 2026 02:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768531101;
	bh=p+22kgeBsgnSIyq5SAh8/KKOsILQTuQeuv+YPGKAS/w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LA7feMTf5OhQNkBxcSbWrXVn4VpbI1mpLuEplow35p+lglgr/i3cHbCbLpgGYsssi
	 SDfvHpDdFCeja60UyQP2UOiC8rOUZ9ZJjbSQHXeoO3eD5bwfESBvkX93EmCvQ6WLyn
	 hUzG05qMfTFPDS6sWHuoYgn5x9JhgDyAD1IibfdmicjeYIG024TdSYsxe6zrFUbJxp
	 brXit+fGINNUJ6ODTY6WfN9b84Aqzj9jbsy+8aFuCP2dRlOMQiCvOybsR+V6Of2oF9
	 Fc5NBSXAVH5YBinvOmzvjxtzw/svnNQtUoR56lv4fOv1o6Y6j4xtXvNbmSIHiMX/fn
	 p8Ch8zaaqTkNA==
Date: Thu, 15 Jan 2026 18:38:19 -0800
From: Dennis Zhou <dennis@kernel.org>
To: Chris Mason <clm@meta.com>
Cc: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH] percpu: add basic double free check
Message-ID: <aWmkm3A9qavY9461@snowbird>
References: <20251220002737.84100-1-dennis@kernel.org>
 <20260114122209.1075584-1-clm@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114122209.1075584-1-clm@meta.com>
X-Rspamd-Queue-Id: 1D3FE1C0004
X-Rspamd-Server: rspam06
X-Stat-Signature: dgth6udw6t1gsiy6ipikxhd5336f6mch
X-Rspam-User: 
X-HE-Tag: 1768531101-825279
X-HE-Meta: U2FsdGVkX19HFFd0AyN/J23WVg+G2wgsKGSNvJECqLDUMJkGOb+br/RU1t4zyUjma6GPih+E+H6SCjjad6H6ZC2DBA8CIBrgSp+ASfRxj45pHnVuiDTQe7uUtOn4k43be9+Dq9scit64LzOWdJmeISKkSyLONiO/0Hh5Y9ipK0ZubYjBkQZ+IPlXkhNmuXx8s3cxjYi0gG0Nn/zCoenWQjzq9+TR7dCqe9er245QXSCgtKCjQJ96ICnyfmvFgLUbZr6mIodQGQZ57eYACjAKMvwAH+QHX0OY2fKvmyH5/K0vljuSZNWmADGXJGJAuvg8Pz/ygZZkzaR8vLo2iiIBUUTYUKnJYiq27afAFyWWEcmcMOszwCyhg2Bdae7hNqdrIwod2NWod/DoW5iGVMaLVgnw52aTWTAitx+74r/NhYjhlxdslmMYquiULXxgV9DfoUspx3vohCLkoUOsc+0FsWfo6H4+BkYB/hr4AUAMq3JKDHk27ueC5un30l3K/RBUTAaQSENjybb8DaVuW0a9dm58yPtw5yUbW6kZriCfrPZNFf1VQybH/yv2jC9B3HCXPvEhdDU19gtx9w35kfzQYbjC8o+UhTWB2BoPtkx0qSH8dMPFYThRY7q+aTpqEl2EQzMPFEsjfnn/3LJ07/BBWSebJVU4qvGLXK9oJEjYYpefYhlpyajamtSKZOr4CRdsBvRE3zIR9LJT7PiW7lm3DEiiV72nXwt7RlDKqU0RPq/SGUiSr6fagbnpvBUWer7DBMKcoEdZoHOi1P/W9DV9I7Lb7ZlAvtAqwMrHmJCdMLok8xdCTKztrCuAu234Oa9erh6eKfVEPmvikhQtgqCO1mIZ89jt1pPbGaSn1EYhcrGXwByfFqJEtOvFUJZ9uFXe2a62qHV14jdHr+ChAnxc4KOhlr4t0AAIdtwSOkaiPFfOozvEFe7RP+uORTGMUTYWLo+/c3OFY7a6pSXufeq
 Yk6PhoRj
 LkXZsQ0K+8Rzj8CFOK1YWW++Td5WFsZ8A07/xLc16riSHu0NG9g9yGrokOiOdngsL5Tc8jeqsCRCM9gVrSmXH2tMDK61k3Qf9zbmQw37tyCM2u54Ro85jFXHmwsw0KMfKyOPO4QSxZ+07Ou9y90pmaenzy/hGL8uN2R5QxlmVehi/ShNPUHpUFmQznt5PR7UbeGN3jEzh7KY0mYNfftHvHv3PMScuuZbkq84zuQPCKMxD9/Ek/MuYwD1xqNRFA4WlVImD/DQULhSTnswIjOMl8diif7mZ/thQB2yyddsx8h9RliFwHXXeGaeYMQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Chris,

On Wed, Jan 14, 2026 at 04:22:00AM -0800, Chris Mason wrote:
> On Fri, 19 Dec 2025 16:27:37 -0800 Dennis Zhou <dennis@kernel.org> wrote:
> 
> > This adds a basic double free check by validating the first bit of the
> > allocation in alloc_map and bound_map are set. If the alloc_map bit is
> > not set, then this means the area is currently unallocated. If the
> > bound_map bit is not set, then we are not freeing from the beginning of
> > the allocation.
> 
> Hi Dennis,
> 
> I ran mm-new through the AI review prompts, and this one was flagged:
> 

Wow that's cool, thanks!

> > diff --git a/mm/percpu.c b/mm/percpu.c
> > --- a/mm/percpu.c
> > +++ b/mm/percpu.c
> 
> [ ... ]
> 
> > @@ -1285,6 +1286,11 @@ static int pcpu_free_area(struct pcpu_chunk *chunk, int off)
> >
> > 	bit_off = off / PCPU_MIN_ALLOC_SIZE;
> >
> > +	/* check double free */
> > +	if (!test_bit(bit_off, chunk->alloc_map) ||
> > +	    !test_bit(bit_off, chunk->bound_map))
> > +		return 0;
> 
> Does this early return corrupt pcpu_stats.nr_cur_alloc and
> chunk->nr_alloc?
> 
> Looking at pcpu_free_area(), earlier in the function (before this new
> check) there is a call to pcpu_stats_area_dealloc(chunk) which decrements
> these counters:
> 
>     static int pcpu_free_area(struct pcpu_chunk *chunk, int off)
>     {
>         ...
>         lockdep_assert_held(&pcpu_lock);
>         pcpu_stats_area_dealloc(chunk);   <-- decrements counters here
>         ...
>         bit_off = off / PCPU_MIN_ALLOC_SIZE;
> 
>         /* check double free */
>         if (!test_bit(bit_off, chunk->alloc_map) ||
>             !test_bit(bit_off, chunk->bound_map))
>             return 0;                     <-- returns without actual free
>         ...
>     }
> 
> When a double-free is detected:
> 
>   1. pcpu_stats_area_dealloc() runs, decrementing pcpu_stats.nr_cur_alloc
>      and chunk->nr_alloc
>   2. The check detects the double-free and returns 0
>   3. No actual memory is freed, but the counters are now wrong
> 
> Should pcpu_stats_area_dealloc() be moved after the double-free check,
> or should there be a compensating increment on the early return path?

I moved pcpu_stats_area_dealloc() to the end of the function in v2.

> 
> This could also affect percpu_stats_show() in mm/percpu-stats.c, which
> uses chunk->nr_alloc via find_max_nr_alloc() to size a buffer:
> 
>     buffer = vmalloc_array(2 * max_nr_alloc + 1, sizeof(int));
> 
> If nr_alloc is underreported due to this bug, the buffer may be undersized
> for the actual number of allocations tracked in alloc_map, which
> chunk_map_stats() iterates based on the actual bitmap contents.
> 

