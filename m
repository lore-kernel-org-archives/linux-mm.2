Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72C9BEFCE43
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 02:51:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A33166B0088; Wed,  4 Mar 2026 21:51:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D6986B0089; Wed,  4 Mar 2026 21:51:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F0286B008C; Wed,  4 Mar 2026 21:51:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 715346B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 21:51:32 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 23EA31405C1
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 02:51:32 +0000 (UTC)
X-FDA: 84510483624.10.808A054
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6766C40003
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 02:51:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=quHxP0Mw;
	spf=pass (imf27.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772679090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9FqhU6Xi0PEqicBejsWOUxlERCcjHUVkJ8ZqPzRTOYU=;
	b=rTKpNu92vEUT3pEB2I08J89s6J7rVWYYpAufz/gejvBh1VuifIZMUNs4YUayxKeP+wnQ74
	YTLAKKSRyN25C3tI48cMr17iJyGpJmMlr7mMoQUzCtUoKg4gKlAGNV0S/Vq8ILv2uGyHyQ
	/M4wR2pHHK8IvMD34OtGpDYI54QyjeM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772679090; a=rsa-sha256;
	cv=none;
	b=u+nRW555GVESZWln15aS0bmSHSvg5ZC/Jwf0iv0I9ThOEdPdBEitPBJi/9lZJEYwBR4KAS
	/kccp1sioFQtJt56/E+AJEb3qmZEIyPNq3ptt3orHsioKkq9FapnQVQX/sp/gOIQaCSvyQ
	ZTyYNk6HXFSpew+x8lMkDvxwH04yX/0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=quHxP0Mw;
	spf=pass (imf27.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 5 Mar 2026 10:51:19 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772679088;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9FqhU6Xi0PEqicBejsWOUxlERCcjHUVkJ8ZqPzRTOYU=;
	b=quHxP0MwZvOap9vf1E4sRojPwn/nlQlO8RMKQU8tbevfLu6QO2IBZOMfqmKxLJJF9mHM1q
	zbECuBQnbYD5HjbvRNRhGY96P4rqxlGt26YFhyabRnf6k+YGCussA5DsFNYU5/nMQLynve
	AMZnEAdXjc31hAk0JwjmGT3AryIJSvg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.com>, Harry Yoo <harry.yoo@oracle.com>
Cc: vbabka@suse.cz, akpm@linux-foundation.org, cgroups@vger.kernel.org, 
	cl@gentwo.org, hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org, 
	muchun.song@linux.dev, rientjes@google.com, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, surenb@google.com, venkat88@linux.ibm.com, pfalcato@suse.de
Subject: Re: [PATCH] mm/slab: change stride type from unsigned short to
 unsigned int
Message-ID: <5r7p6pelk4u5c43kvuxwi75f5dr6msx3x7hapaezourrpgvkr6@jlala4o5z2xf>
References: <20260303135722.2680521-1-harry.yoo@oracle.com>
 <fe9dacdd-8b96-4375-8730-8fb9ed5fad60@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe9dacdd-8b96-4375-8730-8fb9ed5fad60@suse.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 8nfz9gg64bb5j8rmz8gm6gubwss4bw6d
X-Rspam-User: 
X-Rspamd-Queue-Id: 6766C40003
X-Rspamd-Server: rspam12
X-HE-Tag: 1772679090-194121
X-HE-Meta: U2FsdGVkX1+9FIbUh9Tv5chZLIbfD6YiG1ja7PfEvudQUaI8Yemc+Vrnkwe41n3KFRN2mXjMKsngu9PBGphavreYf6cPO77jd+oA278I+S39RHuD4Z1a2gBhQ8+tzWW0vAKvRHbRbEGX9hc6XwtLRycevWxfoqHZ2uk619WOQYFrEY7GachzDFjXCi71VFSsoI85BXag4COyfDM9wCjTGDmDjf9n3WoOIV89yXjQIMp2uiBNNBIom+ErxpvHRPgK2X4WGHYUw25zKaAI6SEUNYmQ7orK7NKTNIN8/56lFN0vZerdl+ccOO7N3vyuAG91dWZUVGKM0GYggW3TsZqwlXLsvfm8J8JkW2s8+ju2Lsm+bv/WxtrBhD7hAFim5p4rlYdeVDfSKr+SZBaPqeUfqBrdhfG3dPD3UxTxNMh81lQ23VBYne2/OuFYizZy2O24OVufHxJHem+G4r4xTxIJBicvfPhKPDRx2qgPlCMaqqUKFijfG791mnmj6mR7SUs/vsJPFdP63FyLIWURQeH2cw97hyVsAdafLLoF64NV3gNp7iCKsgBG9jsOutAdQ2qp9ggco/InPYQCFf/P9mjGmylbfwysUNoHykQRv9wHaNYlIFXjDXAJU0yzA29PeCWT+0uicsplpncB4QloPq76mdGUnxh6P2kx3dRsiCJ0JnrjBSDQThlDxOsItfdnpw8wrlYspcotTpGA3zFZKg4wnZo4eblkNbJvWe24dTBzw0g9OxufYVDA33OWdt3krMqs0d1M9iYFltORJloWXytpT+KAhKoqOyPt1x+wJp9c0fYo4CtUtwTY1pbQ59WACmfpRLZUMFPkbug+eyvS3rbxzP3Mkqx69RvccaXWHu7a9WE8iX7fefSbdHQxalJvbFkM7F1vY8dUyNY73Xty/n2GThAHSOWEggvVacUXO4kh78aUgh1/w1/CEfrLBtcXwrkKrVLvctpnDuapgBkyu06
 843Dt9uH
 F39fv+SEd9LVEHgH3pFNNvIG49rnfN24Dv+1+dKcEZ+WSEvxqCQgp/R4LiUYDSTWnSUoF6eojxe+Kdeqx4qtQMGR3h9d/coESJp8FVipu6lepVJyCJMVZKIri95N2eedvjg00VpPDMJUljXDMsOvdwHySN39PCCf0MxapR9CZPWqDI4d09EzvasGbfkOxr4Wittk7b8ruOIg5IkBrAbS5N7VO6xQ9g1sHYWPrkwZSKDs3UX7/ElQNoSx01OBenMgD8ozYbRf17nRjxH1ky9iPYXmcEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 11:17:46AM +0100, Vlastimil Babka wrote:
> On 3/3/26 2:57 PM, Harry Yoo wrote:
> > Commit 7a8e71bc619d ("mm/slab: use stride to access slabobj_ext")
> > defined the type of slab->stride as unsigned short, because the author
> > initially planned to store stride within the lower 16 bits of the
> > page_type field, but later stored it in unused bits in the counters
> > field instead.
> > 
> > However, the idea of having only 2-byte stride turned out to be a
> > serious mistake. On systems with 64k pages, order-1 pages are 128k,
> > which is larger than USHRT_MAX. It triggers a debug warning because
> > s->size is 128k while stride, truncated to 2 bytes, becomes zero:
> > 
[...]
> > 
> > This leads to slab_obj_ext() returning the first slabobj_ext or all
> > objects and confuses the reference counting of object cgroups [1] and
> > memory (un)charging for memory cgroups [2].
> > 
> > Fortunately, the counters field has 32 unused bits instead of 16
> > on 64-bit CPUs, which is wide enough to hold any value of s->size.
> > Change the type to unsigned int.
> > 
> > Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> > Closes: https://lore.kernel.org/lkml/ca241daa-e7e7-4604-a48d-de91ec9184a5@linux.ibm.com [1]
> > Closes: https://lore.kernel.org/all/ddff7c7d-c0c3-4780-808f-9a83268bbf0c@linux.ibm.com [2]
> > Fixes: 7a8e71bc619d ("mm/slab: use stride to access slabobj_ext")
> > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> 
> Added to slab/for-next-fixes, thanks!
> Hopefully Venkat confirms the fix and we can close and try to forget
> about the memory ordering can of worms again ;)

Oh, by the way, for that earlier patch that added a memory barrier, the
reported testing results also show the issue no longer reproduces.[1]
So, could it just be that it didn't happen to reproduce that time?

[1] https://lore.kernel.org/linux-mm/84492f08-04c2-485c-9a18-cdafd5a9c3e5@linux.ibm.com/

> 
> > ---
> > 
> > Hi Venkat, could you please test this on top of 7.0-rc2 (instead of
> > 7.0-rc1) and see if the bugs [1] [2] are reproduced on your machine?
> > 
> > I reproduced a debug warning on a ppc machine and fixed it.
> > The bugs are expected to be resolved by this fix.
> > 
> > p.s. After more debugging, I saw stride appeared as 0 even on the CPU
> > that wrote it, which likely rules out a memory ordering issue...
> > and I discovered this while decoding ppc assembly suspecting memory
> > corruption or a compiler bug, which came down to:
> >   
> >     "Hmm... why is the size truncated to 2 bytes?... OH WAIT!"
> > 
> >  mm/slab.h | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> > 
[...]

