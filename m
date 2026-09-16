Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31C81C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 14:00:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CE5D6B0093; Wed, 16 Sep 2026 10:00:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2680D6B0095; Wed, 16 Sep 2026 10:00:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17DD46B0096; Wed, 16 Sep 2026 10:00:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E96476B0093
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:00:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 708BB8072C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:00:45 +0000 (UTC)
X-FDA: 85219786050.16.814029E
Received: from mta0.migadu.com (out-134.mta0.migadu.com [91.218.175.134])
	by imf09.hostedemail.com (Postfix) with ESMTP id 36B0614001C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:00:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="dZ/K0710";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.134 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="dZ/K0710";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.134 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789567243;
	b=dkhBpuCnsG8AWqrUUdXER2iSe+mRKMnGJjQN4Hn4NoSmvtqmIEf/PIibyGHUn7jg7UFvG4
	CNbay6rIVfGQc4DwKj9UYIiFOSrZRLhhy65qJLBXa+Pg2zYJFCDwmiVgdsAwZ1vGBQ2cp1
	zk8acKe8oWAslWVYerCqclVJz3f6mRw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789567243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K+tp+8CWpgt9KQvrIq79J7M4Xia1oIGIHoddALpW1aw=;
	b=Pgc4w1PhBEnTfSYtJoJ0o7ESesfjId7MtRchyP2BtxO1tOmuhuhvkh9RMtUBGqb2JkP241
	Q55HDAwCdHSKHqzKJ9dLYS0hKwXdOxUK73Xmb44LH65tvAPhz2QQ+tKiesSwh7xnXr2OE/
	gHTK5xDLvepknK0Q8BzSf+GxMEWXYmA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VnaTq5M5se49V/9M3c8zvRQnGAJq4+i+kTu1qxqaOlY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789567238; v=1; x=1790172038;
 b=dZ/K0710yObmAG+nqd1rTazeVb+9Xjw1Y4sc2mahRs8b4ON1KXMv2wHgoVNCFsjfXAFcL6RK
 OUSfvlltt8yaWpY8Aie2xGPcrhAvnLlAuMFiCVg3ENYMyRfleAKepEdGigcIrgPHVuzfizpbCn1
 f05ucNYvb1Untg5iScLXE9Z4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id da512f38a1cd2b39;
	Wed, 16 Sep 2026 14:00:37 +0000
X-Mizu-Trace-ID: da512f38a1cd2b39
X-Migadu-Flow: FLOW_OUT
Date: Wed, 16 Sep 2026 22:00:24 +0800
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry@kernel.org>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] mm/slub: make the case handling in __slab_free()
 easier to follow
Message-ID: <aqqfP-bj2jh0pN56@fedora>
References: <20260824122004.3652-1-hao.li@linux.dev>
 <20260824122513.3829-1-hao.li@linux.dev>
 <aqf4IsztnhrXBocx@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqf4IsztnhrXBocx@thinkstation>
X-Rspam-User: 
X-Rspamd-Queue-Id: 36B0614001C
X-Stat-Signature: ywfkgmsrh31xdwnx1e4cmywccppifp1i
X-Rspamd-Server: rspam01
X-HE-Tag: 1789567242-190187
X-HE-Meta: U2FsdGVkX19FG3jGoqJYofQK8ipfwjpgl5bWcrCNdYgUqPPT/EmBhLK5IZYmzGTPmhOFXEaME7r39KYk9IjdttuEIqfmmguEhg4PfCF+0LIB10b8zXBVF+r3DLYZIectVTVixQtsSh4nJ9Lz+nEjvNeXA1PniaxfqyPnzMkA8HAkOy+6Du0l2brKJR1fXT64hSVFnfUrFo7rhvGevLtJqxanh21QqSmu7CRCLUlrAuuUCfP3g4qvITjqgchm8Yj/w82nzQmLe5FTc8NM8kMSrNCdZBSUZqZId6ICLlekLxgpaBWhheh+H/5BerFwwDBTdo7818z04PfQCO3pHH2S1N+JZPUIO4e6McMAQbRQvs4hP044k8R73Liij/OtnqCu+7FvPuJavEqRWppsfdOCvgszFv4h3KpOy1mfnabAc1uXaWxVF6Ug6OjJdcSh/XWVckfy4idXzGXW3KbIRvApZOxo8eKeUQZF8nrgF0gKBuGNwzVRZj3Ekg+bX9gDPzypNGzi0TFV2aeGP2wfm3XuunNvBigYu1eK3KkuNzCeoH1pQT+kgKQQQ3MpDt8ZlcxOCt2d1Dczni09d1SCiw6K0EtcqnsPMev5g4yu+arE3RWazCHrZpRbkayQfevbYdvRtDE+r/AvIS7hQRi/l6VZNaVewaqya3lTTZw9L0yRGyf9pyz/IenEhd0JSeb927V+PE7fFJyb9hP/8jbKuqEscb/2cdVf9KkKTefsYao+f6SYy37q7Y+AhRaIsqNZKU8Uv5z7+sZYDodB67JlajEhLy1ELvEKWrdF/hcZ6K+H871UeuzmN9XLBEx1Fg94U1EdFGuVBJQkdUjG4mP3KM2jh4rcpsha7k/Oz/Bt8oPIRHzLniPGmx1FXJ07Oln2oUZzpkl7eY8Ke2Jtqwoc7kKh13N1W+46flcmFvCt/ScrTL6W5UUjpYW57WRMMQjlbvX8rJKPt4aJtD0+wVGIK80
 eh5oddzT
 PQGhQ0NmUkKqk8PY05bLkiXa2ZfkNfaYqnNH4PAAcnNCUfNPL/2R07pxLZMN1HBICuwH/v0q4+8vOw5F3wf4wltRXRsAKIICFdQobg9MKc2hHJLLsh/G2IAKBTs08LSf9DKEf2G2SG3j34udpxhYRPeWXYd+x55/yla6CBT+okOIdV9iJjyX99eJKRBH033S4PEv7SNG8QES/6ihomApTX95eUTg3yhth/qK8P5Oztnl0tS0tsFRqWBxC4adNiaOeTOIDj5DVlsGPmRWzPV7yKscFrB7HKIfm0nLEA5l1rxu4yqsotDo78W42PdcDCCMy5O++WdJs1tkp3lb2No0IoJFy8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 02:39:16PM +0100, Harry Yoo wrote:
> On Mon, Aug 24, 2026 at 08:25:09PM +0800, Hao Li wrote:
> > There are 7 possible transitions in __slab_free():
> > 
> >   a. partial->partial
> >   b. partial->empty, offlist
> >   c. partial->empty, onlist, exceeding min_partial
> >   d. partial->empty, onlist, not exceeding min_partial
> >   e. full->empty, exceeding min_partial
> >   f. full->empty, not exceeding min_partial
> >   g. full->partial
> > 
> > (There is no offlist variant of e, f and g as a full slab is on no
> > list.)
> > 
> > Clarify which case each branch handles, and replace the goto with a
> > return at the end of the skipped block so that every branch explicitly
> > states its coverage.
> > 
> > Case 'a' is the only path that needs neither list_lock nor list
> > handling. Give it an early continue: handling it upfront is much clearer
> > than forcing every other case into a nested block.
> > 
> > Also, read SL_partial once after the loop right where it is used, rather
> > than re-reading it on every iteration.
> > 
> > No functional change.
> > 
> > Signed-off-by: Hao Li <hao.li@linux.dev>
> > ---
> 
> Looks good to me (with Vlastimil's suggestions adjusted),
> Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

Thanks!

> 
> >  mm/slub.c | 95 ++++++++++++++++++++++++++++---------------------------
> >  1 file changed, 49 insertions(+), 46 deletions(-)
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index b0cd0572e2f2..e20375307770 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -5748,76 +5748,79 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
> 
> [...]
> 
> > +		/*
> > +		 * The slab might need to be taken off (due to becoming empty)
> > +		 * or added to (due to not being full anymore) the partial
> > +		 * list.
> > +		 *
> > +		 * Speculatively acquire list_lock before calling cmpxchg(), as
> > +		 * performing cmpxchg() prior to lock acquisition races with
> > +		 * concurrent paths, such as the shrinker.
> 
> nit: it's bit weird to mention shrinkers specifically?

Yeah, better to remove it to be more generic.

-- 
Thanks,
Hao

