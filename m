Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 215C6C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 02:58:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B64A6B0005; Sat, 27 Jun 2026 22:58:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6673F6B0088; Sat, 27 Jun 2026 22:58:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57F916B008A; Sat, 27 Jun 2026 22:58:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 332B06B0005
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 22:58:22 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9B0C9A030B
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 02:58:21 +0000 (UTC)
X-FDA: 84927812802.24.DE2B326
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf25.hostedemail.com (Postfix) with ESMTP id BB943A0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 02:58:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MtA91UTS;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782615500;
	b=oOuf9I56UAROoOZt5GfH8O4qSbmDPhS6dEKTjhEsiJuDQbhNKF1S2P7q6htJCi6TOIKkYr
	zd7CdTLiA3oWcWFtJ0nnx+J35yo16ONWpBQwLGk5pQPLseT7bAUoofUAl0C6717ViQVNwY
	beNfKSxyKHbInVUPkmT+kEa6RxY0yPo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782615500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4QGjDrc94iYtKB/2VDYW46TVOW3u0FLV/oySj9gxXuQ=;
	b=mLwX3JHHJ5KlOokFKYwayF+wpcZcPcV2rV5nXVNyjhbW2lY10OgOdaqyWCfJw0weqgwGpw
	L9y4W3W8Vi4iLdk0fFf63Cb8mAtPu9IWKuKWobjXgfLfuz+5/MlNkYmjiezzVdgTRZCE6Y
	clAbL6rePaabBTBpQd3Lx1K3YWhEKfc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MtA91UTS;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Sat, 27 Jun 2026 19:58:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782615497;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4QGjDrc94iYtKB/2VDYW46TVOW3u0FLV/oySj9gxXuQ=;
	b=MtA91UTS1oJHSpQEQeUuziB80H/5pCqnyTlOMzJfLBLdy0kz6IaDSJsi+PaEqJPQqL69gx
	gFkxpoRRiewwH11Sm4EXcX0fo5lBTH7zNPmv60mD0Yu0U5cTjdp5cwMtJUEyCo2JrYR/m6
	hMhh/4BqnIpq98A4WAw0KUScFRlkZtw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	Usama Arif <usama.arif@linux.dev>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Danielle Costantino <dcostantino@meta.com>
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
Message-ID: <akCJRTnmA2um3CIy@linux.dev>
References: <20260625230029.703750-1-shakeel.butt@linux.dev>
 <62453403-954c-4cf1-8924-6d38184b0810@kernel.org>
 <aj6re83IC84lkFL0@linux.dev>
 <09267187-6c85-438f-8791-4cce8d07892a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09267187-6c85-438f-8791-4cce8d07892a@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BB943A0005
X-Stat-Signature: hwyf6eih6awb6in6nc1ejdxhe1rznjmy
X-HE-Tag: 1782615499-196864
X-HE-Meta: U2FsdGVkX18N2J9e7RRyZxOEDh2FC6HYxuTqyitnKut+lM/6WDT48M45P5qS6ZuWgEveQPIBxrhZZmQYkni6KzNjfZORLhYWkM15b+hmIbuzVAVf7xCR4NBT7ZQIaKdX7UfLWmnLIv8XLCSVJCcfcN3twSxORtkt58bbAe1kkuwnE87UfF5iUM65hN+saaDFO18GTqFPoyf7WNTKyldVSPRHBm/9z7rLUukOb1Ez0fLSiqmUBUYD1zGHtmgiiJbT95gevb3Ys0vYVG3fcyxMFXCap1uITBXfN4OTlPk36Z3sP0kKmrOXMfPjh9TRjO6rXy5XEfxmQ/Cws0aahMFJn1Ly7hQ9clyTvu0OhUwF5pTcClNrfQbgHUMLBGhPiILALz/GJPotBnkK1ZDj/C7L7e23Lr6FeaIKq4vLPMUYaOMlxKtk+lfgmaDyAe9sF6v6w30Krw3id29w/ac+6Ks8Zq4zcEa9gnmtXI4U5qDuRfZ7L7jXkCcnBGiPhHFuYVztirBIh8Tv0WMSUg8YxqaON1ma+1hYACVmBXzNSIWwwsYsQlKIlJEZwg2+kP1H7j9jroijcLDj9sMQBPzkUiuskmZa2scJSXHPb1jdeLm0EZWtUgitv9LB1FlnOPTwKKS5Vgko5M7kBVH5RTUY3TIFj21utQB68VNk6rbwakMeQrf3du8KX4exoO1aykqGhhn0jgKfobOMNQnNsCnKmoxqxLPjvrVdksghF4KPsJSIvwrRZbJ6Cy0qHpA9GIhDJk9g8DiYK/vN8QOytuHc/LnwuNGQf87L1u4ozMAZmlvwnROiNjl09xt1xN5v4S2wM5/wvE1v5DSigL3mI0ssDU5orxy+PVmGEv2M6FJ7eqyvleNMMkZ0m8pd6/4ilJtOSwm4RrfbPIivDQONesfGzTBURVcyO1IOd6I8z0fNap7T2QRPHlSss1mOytbtNUHDkO2gLyMpWKS7ETv+mFb8+CG
 jmABckTP
 5LDJIxY+15ToRUWrufwhE1J5nSyGP+Kzhae2CJqVUaR15wSxbB5V33tOFo/ieUXAyBg5v8TgK2Fy95FUaSeWfHr0mypVNQg0qwCspleLo6SHgcHIwSfar1Wg0EO82ZSNViiwzg8Tnc2OuaUrA3HKIRWR8l9D6n3Y3zM8i2G1+8RVO7p6XDIIHxd9dmb6vmg1bKLv4IYDpc55TVIDJmEbGia+jUKA6+oJjNq15vPDUgCEhPG4zbYmywYbK3pzbZ/ye+hELohBP98VPgNYfCRojVzG1ldpTbEU21yZkFdjJB3LUEh/qn1Nvo649CA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 07:11:33PM +0200, Vlastimil Babka (SUSE) wrote:
[...]
> >> > Fix it structurally by removing cycles of every shape: serve the array
> >> > from a cache strictly larger than the one it describes whenever it would
> >> > otherwise come from the same or a smaller cache.  Every reference edge
> >> > then points from a smaller to a larger cache (here kmalloc-1k's array
> >> > moves to kmalloc-2k), so the relation is a DAG and cannot contain a cycle.
> >> 
> >> This will fix the problem.
> >> 
> >> But this will waste memory as we need smaller obj_exts array
> >> as the size gets larger.
> >> 
> >> We should probably create a new kmalloc type to avoid cycles instead?
> >> (needed only when memory profiling is enabled, though)
> >> 
> >> That would also prevent recursion even further.
> > 
> > Yes but I assume that would add kmem caches even for users not using memory
> > profiling. Anyways, I think that is a separate discussion. Am I understanding
> > correctly that you don't have any concerns with this approach?
> 
> Umm, the memory waste is a concern?
> 
> Minimally I'd now want to only do that size bumping when allocation
> profiling is enabled. Ideally that means both configured in and not booted
> with "never".
> 
> We probably should have done that already in 280ea9c3154b2. Because AFAIU
> memcg-only obj_exts array don't have this issue (or maybe they do have the
> [1] issue? Harry?). But if memcg-only should keep avoiding the same size
> bucket, it can keep what it was doing and only memalloc profiling would do
> the strictly larger thing.

memcg should not have this issue as normal kmalloc caches do not serve memcg
charged objects. 

So here we can do dedicated caches as Harry suggested or make this size bumping
very specialized as Vlastimil suggested. What do we want long term? Orthogonally
we do want this fix to be backported easily to older stable kernels. I will see
how does this narrowed down size bumping looks like.

> 
> Suren's input would be also nice to have.
> 
> Thanks!
> 
> [1] https://lore.kernel.org/oe-lkp/202601231457.f7b31e09-lkp@intel.com
> 

