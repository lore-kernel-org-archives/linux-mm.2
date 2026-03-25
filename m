Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C99CF109C028
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 15:22:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C5966B0093; Wed, 25 Mar 2026 11:22:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39CD86B009B; Wed, 25 Mar 2026 11:22:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B2CA6B009D; Wed, 25 Mar 2026 11:22:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 188FD6B0093
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:22:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C7ADCBB9D1
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:22:13 +0000 (UTC)
X-FDA: 84584951346.19.48B8BE3
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id 883911A0010
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:22:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ngPfHWaN;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf19.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774452132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ouu8y2VMlIQ3NjrnnBtkXQCrxDc+lrHn6mGN4M1Qu2g=;
	b=jdlwmwLtSii9I4aj7+lkHdpTCnE07KHN7FEFCw4+w+lMbq0Gj+fXbbbWvz6Ww7nWEXauca
	lk8nXarg6pArxWqQ4AU69+GgpL3RN6w2vrRPHeTvLhrfD7b6Tb2M95vd1KZLgOGp3JT9v3
	jHSUBJn34tPwrM3KEiJAVHkON5ckvhk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774452132; a=rsa-sha256;
	cv=none;
	b=MABGpj13ka6gHhPA8loDmKh6EG5IbXDb2LX0k+nZns+z09n8TqO5h4+87avnK8VMgf5bkq
	MNwg25SElb1Vmt42xehCX0rhF4KPRwTZpG9+3p4hPZ9YTDJfEN5ax5PQi2tbmlP4B31rkS
	bKY3ESUN9GiRDsVV98k69IWCzQqDz34=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ngPfHWaN;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf19.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=Ouu8y2VMlIQ3NjrnnBtkXQCrxDc+lrHn6mGN4M1Qu2g=; b=ngPfHWaNuTdEWFecBlMqJVZLbZ
	UjHCci+mc4+m2b0xrxeof+0JLPJLA5Ay080MBB0KUiBec1WZzBd6QVghx4Hc6onu3YjOD1it1aNRm
	nbU4BkhtlbPZZz9KQaxZ8iLrkrVd7aEQHd4YsUzIA+M1lAFddPnAyZM3/FUuaWxqufFbCAooNN7OE
	CqWF2vOwAqgGUgQtMvDGC2UKqpME31EUzTF2OKPorCoZkumQ5dcsYt23fTpah08Z9lQBHkutGPPOm
	EgPyQm29HSb12y+Lg3jEAQXpwgst++yyfiwkQMOPU6oMGUQ1rjlSHkwzrfAt4sahU7l392dF0/gTq
	CUtY6WsA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w5Q3c-0000000G3qq-22UA;
	Wed, 25 Mar 2026 15:22:08 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id C80DD300312; Wed, 25 Mar 2026 16:22:06 +0100 (CET)
Date: Wed, 25 Mar 2026 16:22:06 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Dumazet <edumazet@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Hao-Yu Yang <naup96721@gmail.com>, mingo@redhat.com,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [PATCH v2] futex: Use-after-free between futex_key_to_node_opt
 and vma_replace_policy
Message-ID: <20260325152206.GH3738786@noisy.programming.kicks-ass.net>
References: <20260313124756.52461-1-naup96721@gmail.com>
 <87a4vyihlx.ffs@tglx>
 <20260324140019.GE3738010@noisy.programming.kicks-ass.net>
 <87fr5pgp5x.ffs@tglx>
 <20260324174418.GB1850007@noisy.programming.kicks-ass.net>
 <c892e7ce-473d-41e5-aa99-b95e0366c3fd@kernel.org>
 <20260325151445.GH3738010@noisy.programming.kicks-ass.net>
 <CANn89iLnJv9_HRV1vuURFM5uVA-y4SqBsBRD24kSJe7UmBtXSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89iLnJv9_HRV1vuURFM5uVA-y4SqBsBRD24kSJe7UmBtXSQ@mail.gmail.com>
X-Rspamd-Queue-Id: 883911A0010
X-Stat-Signature: fx53xxnmdfhciwke7mkxud6fdcj9eq3y
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774452131-116653
X-HE-Meta: U2FsdGVkX1/WOsQgjjNGDtGDVIsldVAXLFe7yxntu6ALJ91CYv955ae8mSwVpGI37y6ZKABATdNsXXF9aFVhYfhmqPgUmyBcztwdT6pFQUfJTZBo0hZyb2peyYQV3VQZTDPF2FntKawE7Yv7LrRFz/BY5BsSlqrZigSNHBWxTvLoxW5fZCmH4pprZiQeyuV8cGjbt/p9wR6cGuzJst1WCqAO17T7z1U+4cQ2XvZUp4RT/BNEOJW1PXYz0wEkaJMVuLHK1D3KydJlorFvYyAMg4KQ6aKTBlcy2AFQgfEcTESqfzMDPBhT5vltzOXZ7Ji9t3MiM49OKkfP6NYoLBqiBatP/WUgYMzLEhiEs9avTqxq87dm9tfoCLXyqdrkSXdQ5T4/BeVB6kDZDPM3nHubIBIembIfs4nhUgN2c+q5uKAGqBmF1x1H/fFaxIu7t+JsuMPTvsr6tAbEkzjl2EoB28PAhQQPT90XvTtEG3dJvtY1FIxQH+3XkVQGPTtXWuXPhM2B8GvI5/+owy0WBCInAVHkSpDJGQG42oU8zrnQAP7NA6lYuyDJiZ3kz8AzNGAQxT7kHhkkVF1jvVZNynlmnSJ6wRzhTPkAe0VFT76Qg+x69v1MZmXCP9mNejCTTy135ks2RCMH3HEnvU+tNmgH8Qjtd86XrTn4+giE0MI25IVhHkb7dmzRA2RBBDpYSx5MHqPBujqpaye26x4JHt6B4wP5P+dZtrgpsovDoK2VroA6J27FO2qhyFVYDObZ9lFiaagHHzQCOIpM2BSZrLgCcOTmR5swlEmLkquiBuKsyc75MAl3CmK6kAh8Rd1R/k6o1jEFXuct0RbinvMmL1QQ6kcVa1pFMnJkeph8dW+Y9Gda3RNxXSY5N+saQNxYHz6Rs9gx4LggOvMWajYfYPcw3sVDstzuMG3ROU22OQ/gCQXGsN/ocX3HkWeA9ltyNKoaVXojTV+VtUHqEiPMhmF
 En2+Sdo3
 jFqSwQp5I3vA38yfFRgfLbSCqlkBa5emwGtg1yp1bt6vivTVLig/VTSERnsRzisrHZeqcxD2gy5raJUph/YV7ahkXPJ9tb6/yjLI3OQJ+6OsmR67P8ZCMe/EUvrupPP3gbqMUTSII4dgnapqlettfmE7RcbT04ODDXhbvRpvgfA6sdP8eC0a/iR8EPJhbvSmA87buA/W71VBuH/py8XtDlglbB2eGRbbnP+CPy3RQoih3G5Pl22VUlB1wvvYr63UwP7svKfio81fUTa0NPNMjaswbJ5Bmw4KE6u/ZS5QTo+l4SOYoIqIYjafidWsEpSpe9ttONA21sWeHmzKTKTzdFBsfnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 08:19:24AM -0700, Eric Dumazet wrote:
> On Wed, Mar 25, 2026 at 8:14 AM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Tue, Mar 24, 2026 at 09:27:41PM +0100, David Hildenbrand (Arm) wrote:
> > > So IIUC, futex_key_to_node_opt() looks up a VMA under RCU, without
> > > holding the mmap lock. Concurrent mmap-write lock is detected by using
> > > the mmap_lock_speculate_try_begin()/mmap_lock_speculate_retry() seqcount.
> > >
> > > After looking up the VMA, we access the VMA policy.
> > >
> > > vma_policy() does a straight vma->vm_policy.
> > >
> > > What prevents the compiler here to do some load tearing while it is
> > > getting modified by mbind()? Or what stops the writer side to to some
> > > store tearing?
> > >
> > > Shouldn't we be using at least READ_ONCE/WRITE_ONCE() etc?
> >
> > Bah, at that point we might as well RCU the thing like so, I suppose.
> >
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -1026,7 +1026,7 @@ static int vma_replace_policy(struct vm_
> >         }
> >
> >         old = vma->vm_policy;
> > -       vma->vm_policy = new; /* protected by mmap_lock */
> > +       rcu_assign_pointer(vma->vm_policy, new); /* protected by mmap_lock */
> >         mpol_put(old);
> >
> >         return 0;
> > diff --git a/kernel/futex/core.c b/kernel/futex/core.c
> > index 4bacf5565368..6336a80e3dca 100644
> > --- a/kernel/futex/core.c
> > +++ b/kernel/futex/core.c
> > @@ -342,7 +342,7 @@ static int __futex_key_to_node(struct mm_struct *mm, unsigned long addr)
> >         if (!vma)
> >                 return FUTEX_NO_NODE;
> >
> > -       mpol = vma_policy(vma);
> > +       mpol = rcu_dereference_raw(vma->vm_policy);
> >         if (!mpol)
> >                 return FUTEX_NO_NODE;
> 
> Yes, but sparse will bite :)

Oh gawd, yes, and then people will go 'fix' it and it'll turn into an
unholy mess.

> READ_ONCE()/WRITE_ONCE() on these two locations seems acceptable.

Fair enough. Like so then..

--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -342,7 +342,7 @@ static int __futex_key_to_node(struct mm
 	if (!vma)
 		return FUTEX_NO_NODE;
 
-	mpol = vma_policy(vma);
+	mpol = READ_ONCE(vma->vm_policy);
 	if (!mpol)
 		return FUTEX_NO_NODE;
 
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1026,7 +1026,7 @@ static int vma_replace_policy(struct vm_
 	}
 
 	old = vma->vm_policy;
-	vma->vm_policy = new; /* protected by mmap_lock */
+	WRITE_ONCE(vma->vm_policy, new); /* protected by mmap_lock */
 	mpol_put(old);
 
 	return 0;

