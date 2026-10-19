Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BE5360A2601
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 20:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=H0LhZGsR
Received: by kanga.kvack.org (Postfix)
	id 1AA486B0379; Mon, 19 Oct 2026 16:40:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 135AE6B037A; Mon, 19 Oct 2026 16:40:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0028A6B037B; Mon, 19 Oct 2026 16:40:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE85F6B0379
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:40:11 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 49BA71C41D1
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:40:11 +0000 (UTC)
X-FDA: 85340543022.05.AC68F11
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7D6F8140007
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:40:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=H0LhZGsR;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792442409;
	b=lQAG8RnnyzSJnFUwjZMT8L0pVnPR5dtp4dV7TqAL1EgQmEOVr4RAainmBdT3Yw48scOgZj
	s3Hy35BuTv86Et85LDAOVoIFPaf+ayWaps61rSWYmGY9YlB0YokFd+M6Mk4vPba+RF62Cy
	g/9OutXqDcF66+DgW5fTurADkw/xcwc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=H0LhZGsR;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792442409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5TU2bw9dZra1XsKruc6sjmGSbXJI2gRuYiN6+oX/+4Q=;
	b=jASaQU9OqCZvgXp2NDWegp0sYKiZWH/6UlFfNQi9Hrvb2ERmR7OTDJTWXwBoI3rqwnfuyL
	ZMJ/1i3qg+zmQmvKeywLiwUDc8Ggxg6f7NiJxCLj57aMw+RI+GNaUlBKPJpk1KA9ak5bLy
	5Rye88WF0ZALmWQochFyI4+dSu0BgN0=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-91b8306b9f8so38979856d6.3
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792442408; x=1793047208; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5TU2bw9dZra1XsKruc6sjmGSbXJI2gRuYiN6+oX/+4Q=;
        b=H0LhZGsR6itMOfy86DDxFxOM15VgFO7qH3XhIT3SnWkY+B4n9h7oAS37+ZJjU77avy
         iuOAdQWBPhYuWB4okRah9AYi4Vccd1l+yBePW32tMttswTI5a1zFvkKkT9Gp4audmv7W
         UzRqywlkEiW5DGgMx0DICOMupncOWLko5/f057eO5N0rQo0RzA4mwkJWrYMJTBniOOM6
         cxryPBzKSc0KRj7kcpwO+6zPTwUao6aRkEEdJii/D7a7bWpG8eeLTS9Sy4y5jCJPPKPl
         b+LQbfqDFdpaEDL4JFSfsTdj0NUcrkFqc6vYRsj4dszAelFBj746+fuZgb+UfBRf0BQE
         3JbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792442408; x=1793047208;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5TU2bw9dZra1XsKruc6sjmGSbXJI2gRuYiN6+oX/+4Q=;
        b=xFD4LH54p0oS9SEHr2tYVoDxNjVZkBzWeK27vuK9IMj6y3QeT+etp9VAoKQLFUXpvq
         RJRUNxZNkhjiN1GAahqL7jWbKrPlkJmH+qM9UKdI2Y1rXhQudnNSmQjlp6TIm9W2qHTe
         zm/LX6FIvBLO3zGPqaZFW2rvpNZBffQ0sStwxrNQIElwJsNsttU1DYbI5uGE1zJsn5gc
         BGSnDBYCSIPHsLeOr7n0k35z86CHLZsphV5I/PGpwTpCahXkJafljRTEIvv1y34l8Q5E
         K6rhAg86hn33tHk9d25EeCwi+Xz81nqgHhI1z3JzVCUcLNifFDOjxnMLyJhSLCOfP+9u
         gvAQ==
X-Gm-Message-State: AFq9FYKhwCd/pFvg4+efPBgALbJdhXqz7V6wQJCr7O25zxGn/8wBC8w3
	aN44i/6vS9j03mtWp/Sc6lLnMIRfAIccxI7scWPTqhCAEJ+vfYoB1ZKlRlsOl6D6FDs=
X-Gm-Gg: AYBFou0yvgK1jyvoWUJ3PfZLT1i1RrLXF0+oAQD3rwZC0LUpOOrt9fF/ZooTEF2zzcW
	zVIiE7A+PSWcxXgyoqNULAnRnxblN/4XIJM2E0yNmEwIX2AYpeEswXBPCsSg6dQW8tptynbbgwT
	nkNVXkiqkyH23PPj8jp+Dhx+IvRXJQ+OtYFXPccuMTPH0a5Ac/9KshApan8OkSJP8MvFg/jS1sv
	b+HxYh0QILI/L5LGOOcCwiO6+5ROr5TXoU/IkAfWpPHihVic6QoQzouUyBTd14Ibsp6errg53bg
	llxO+Nr1NImK7g4IdLKdccObHXjGDU8qXyAKHdbKdwmdIkKSLJJOdWc7KrTuyksuuQtihMtQguZ
	Tgmmku3YnNZFH9hO930lehL4yVeZD/EOYLYJFcTpVySo4dNFVneVOnhROpzy7YNeujZMnGtGhkr
	/1QKxQ7kZoYbUhScVD2emWQdR8Bvb5sZzwarV9sODpaUSoC2wL4legir7TUgxpkIqZDMHK4tLU0
	6Dx2T6nMPuksnfdYQUQXStzo6N9aPM72S8hSGwMcVF7QW7u0Mpl2QU=
X-Received: by 2002:a05:6214:d4c:b0:915:eb0e:321d with SMTP id 6a1803df08f44-91bdf3fe6b1mr160127356d6.46.1792442408212;
        Mon, 19 Oct 2026 13:40:08 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c040da11bsm5657186d6.35.2026.10.19.13.40.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 13:40:07 -0700 (PDT)
Date: Mon, 19 Oct 2026 16:40:05 -0400
From: Gregory Price <gourry@gourry.net>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com, 
	brendan.jackman@linux.dev, ziy@nvidia.com, flyinrm@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: let the highest memory node recover from
 hopeless state
Message-ID: <atZ8ej_zL-D_FIIt@gourry-fedora-PF4VCD3F>
References: <20261019184850.3427905-1-gourry@gourry.net>
 <20261019201321.GJ371161@cmpxchg.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019201321.GJ371161@cmpxchg.org>
X-Stat-Signature: 8sbh9u1ntiybkpez3co63xhj1pa4h96m
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7D6F8140007
X-Rspam-User: 
X-HE-Tag: 1792442409-274463
X-HE-Meta: U2FsdGVkX1+VhTW9txQvYWbPSWUBC3U2SCj18L6m66bEBmRdV49XE29yLqiPzPoBJ8+xAntRRJd8zGabHrGCnbnoDz4zhp2NM7vImkCeZ3MmY0V0rsYKIjlJl8itn7iENqR6SSY0agK2QHom2sURbKG/KJw2EKJ10DEMhWt1etH9O73lBJXxAIrFnA0PoaSa3BSmUTRjf4dpElKNN3hPKdc7nlLwxtCxXQRdPskXB6rKrkNs3cV7XIUhWLb08o1HNzaf6pS/X8uQZwlt+vZK4Petvk3AqCu3kqeOzfUMBxnzPvOrbsN1DIf+FAxAxbMpTzlD2zjpkq9m2iEgghz2rtgce6hDlBaaAURAagzSvr8zJJApsw5ispDmXbGs5R9YFJIS5RExMW4wPat5YOU2x6ufCBc29cyP0S0GWNdCSzGsLJxgSqj2YiRef+tbRZN0OSQV0Kawt1DU3rPGaTxECTmeavltXls7YY6knXclzyDQllo8GPsCg/+bUKOBCJA3xxk33K8H1dhAybJOvjWYIEPuWjxPj8Szizl0zEddqodE7qqbqihvT7o7mQbnyAczaUN+IS1fARJ0IYvkFVOBq9k5D3gAmkD4K2B1T8qHWvx2v+yuRLKshLclWHnZRNUmoR8sqE2UR7yAflDC1evFzGB/bgEKUNDVLQWHqbA8AQDQbfwTuCSPlIik08dk4yDp+luFe5Vx+G2vAxbkCl0EYGb6zqA0R8wSve0H15UBejZ9sQBlyD8lmXo35567zP8zFsQD0W2M/x0y3DnxFktnNw5khqbk/pnEbA4K1MBQWvFxoLJTdA/2+6ywRK4qbTJvvsWck6T5FjrBnO9il9vrWZ8HTAfkOO4OoBvqtjXoFPuoWB62f9MKmoLktwZX3Qg11mvMpzwh/Yo8ZePqpAaeYmI8zcYCcGRHMjbhC5Cp57IB9H4IfrexjOgYFKWouENICN6F2kixtqmlnkVmdqP
 r7Jf++Yb
 de/nUWjXQqDfZ/1u7aLe13Zgd+3CZ825BxKAioNxDeyXtoBYvUtLOoMoQCy3G4qby0duYGnDYAWRxlCoudQFNEgkJq9AZkKf4mzeRARK3WHe3p2D9ZSZDirJHtICQWHorWHLAug+klLeXOUOcircZd/wkCoVWiy6pg4SFTnmrCSX0p29XygqEoVJBZ5znoR67hWST8W/L5oNSti6+0zgj/qQQI71NSiEwABY/iCtonUbA2+ZwbHqMa/w+oIVsEY6AY5RYxbOmtNYh3aVdkfCQzO3P+F7wDCkEktli9fEBU7Jo0pXDiiKiXz3NEEPlhW2dK+9EkJKul3VbCmaW7SlcEHlnvpD6HZo/ZtfM/JdaTVon2ExXZowDbhhQetZ80k5kUO4g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 10:13:21PM +0200, Johannes Weiner wrote:
> On Mon, Oct 19, 2026 at 02:48:50PM -0400, Gregory Price (Meta) wrote:
> > free_frozen_page_commit() clears a hopeless node's kswapd failures once
> > its zone recovers above the high watermark, but only if another memory
> > node exists for allocations to fall back to.
> > 
> > The test `next_memory_node(nid) < MAX_NUMNODES` finds only memory nodes
> > with a higher id. The highest-numbered memory node therefore never
> > recovers on this path, and its kswapd stays disabled until reclaim on
> > that node makes progress and balances it, or demotion is re-enabled.
> 
> This seems to be the express goal in the commit referenced by
> Fixes:. Can you explain why this premise was wrong?
>

tl;dr:  next_memory_node() is not the right check for what the
comment and patches say it actually wants to check.

on a 2-socket system you would have:
  if (next_memory_node(0) < MAX_NUMNODES) /* clear's hopeless */
  if (next_memory_node(1) < MAX_NUMNODES) /* doesn't clear hopeless */

despite the fact that each node is the other one's fallback node.

> The patch in question also only added another re-wake event. It didn't
> remove one. How can it be at fault for kswapd getting stuck?

Not at fault for getting stuck - it didn't fully fix the thing it claimed
to fix. So this patch completes that patch's attempt.


> I don't understand what "having more than one node in the system"
> means for re-igniting kswapd on this one node.
> 
> Generally I don't understand what the heck we're trying to do with all
> these patches against the hopeless state code. It shouldn't be that
> hard, right?? If kswapd on a node failed for whatever reason, let it
> sleep until direct reclaim makes forward progress, or other frees
> (unmap, etc.) put the node back above the high watermarks (which means
> enough of the unreclaimable pages were freed to justify a new wakeup
> in the future to attempt reclaim against new pages).
> 

Zi said the same thing, and I agree.

I didn't want to propose that in a stable tagged commit, but if there's
strong opinions here I can just outright drop it.

~Gregory

