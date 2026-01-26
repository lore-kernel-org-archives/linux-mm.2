Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED2E5D13C20
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 14:32:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5CFD6B0088; Mon, 26 Jan 2026 09:32:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0B736B0089; Mon, 26 Jan 2026 09:32:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B16376B008A; Mon, 26 Jan 2026 09:32:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A14766B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:32:29 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4B09416081B
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 14:32:29 +0000 (UTC)
X-FDA: 84374355618.05.430897E
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6786BC0008
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 14:32:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iK5OL59v;
	spf=pass (imf28.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769437947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yauI0tcgo0+gYANQoQ4SC/6g3xcV7IYqYM+9jpJfB40=;
	b=vJ7/dla/gEqyId4JL8ocCDpbhtXkWFx7pC34ScK1z2WWEFJyh7ZCHSQv6FS5or47LHt6ld
	dCvO2B6JfhotiaOL8mmFw6rhdKck4IjL/j1/eefao3XQKLNzS8GmW41iCPCrc57XZJuS4I
	AiQkZRTc452XjPbjpb+NJNjpCECGIs4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iK5OL59v;
	spf=pass (imf28.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769437947; a=rsa-sha256;
	cv=none;
	b=qeGsyNbuoMWGt5elJE6jFx1yeZInuj84IqJZwoRilzgNE15kKD9uEFcbEFJ9yoycwqaMWD
	rnb7rdOvHqiOpb68axejnjgMmYK40UMJ7N4Fdrhvm1VxlqhvdUAVUqJfKHQqMbtFvzi8Gy
	79pooB5XjzobAwjZOUDD8ddNCAEvvmM=
Date: Mon, 26 Jan 2026 22:31:53 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769437945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yauI0tcgo0+gYANQoQ4SC/6g3xcV7IYqYM+9jpJfB40=;
	b=iK5OL59vC4WO+lI0NZoy2qozlsKaEVfF1lppmUeqPmFleXMViYrOi5L3wsDbk57Yaa2yu7
	S9wvsBgQuCZB18JkmqjUutFUVkjOxGJvXW0VHlGOorNk48Lq27MCADCz5ImzidSW46tQpx
	9LAdk0Sk4OD+h/vyrrmccmuPbWC7eDU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, linux-mm@kvack.org, 
	cl@gentwo.org, rientjes@google.com, surenb@google.com, 
	kernel test robot <oliver.sang@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/slab: avoid allocating slabobj_ext array from its own
 slab
Message-ID: <74km7ybuexsentai3jvf5wfbd3k7cf4mflyd2zgth2dzkxcfp6@l77gkdbpfcic>
References: <20260124104614.9739-1-harry.yoo@oracle.com>
 <bbhrcvqbwuvf6l4xwv7ax6w5iwuixaivvuknvlgutnavxyllme@r5zkvsh7mwtw>
 <aXdlheky-H2a29Uk@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXdlheky-H2a29Uk@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 6786BC0008
X-Rspamd-Server: rspam07
X-Stat-Signature: ph765g3a338x7tei9bxi5izi3w1c5a8i
X-HE-Tag: 1769437947-668663
X-HE-Meta: U2FsdGVkX18PCQA2sJTnHAtaOlG0ETxF7MT4MIY1pp+l7RnvDeBi6SfusOPJFcvssxYHu20mUROhGwWskpOvgU1GwifSn9P67goXuDpHL5A5E+osnh+UERdKzEryrlrfysOND1TAgTH/O1v3FbWMfrxUFJdXWPHD1KGTbIqAEdh6k77hduWdqebXMUAfBAr7WNAxNlDJW6p4Yk8ShKQUYMdOVrr7cacA1dQseWVvIFZVEhidesOysqdkiFUs+PgtXgYEEwyZabtwyKyMyJTt/wTVCW2geJZbnaCSIrEDR4P4BCgk0acDtBY5cCFhaCNXdzMRZD6EmdqPJxj/uxt6ktk0XKzCUSlFPePjuPOQhXfbGhRXHDuKZJH9ErQ3oeBRFLyyrMo8yhe+jBjMVJEAbS7Pf/IyFOLO+QE20aF5goO1vbXPyNWfK5QLAloBuhIUtomsCprZfDtlKVdvmeW5YsrvJ0Qo/lJ4Hh5hhvbpKc1SlfJ1CcfuOt//+5d8FeYZLI4VLaRm19n6sDIUZCqsAAOZSbtLbYfq6yH8fgDg5NpGgbyUlTq0ipGgAm+rkC3BR4T0VCnQ0acwpww76H6J0bd9O1m4KdsadevFoQyHSxa2H3IzJRpSLC5K7PpaOEe6Jg7KnGPWJukE1K65uAGf50fWo8gTDIlauNU9JFnL31gMorir16fmG72BYqKp18BRY57CQRABpC8w330yy5jQ+CpLQx1rZptrsSLzR/6EJQfoZL2CeGpb9u9G4Iw0ZcYzxfaCFEugQwJz8WGncIMnRnP6ZeUhsuWfBSNc+gcmpDyH1K5LpSGGko1Yu85qjzlyeCdnGhgPCE/tKhuwovTCAJAHFggNiv7I8eVS3euMMwgb/TGI48G7Y3BkByygsXkl170enkhLUPyt81hONxujyNvs4cdJ41ljz2yZKHgBbK0hueTSN44TxFKm7ezgYcI3IWW05P2BbBJXRbNKekK
 t/ndsbDc
 7U4nVdaWPJzI6ruCAzMfUGwQ2wMCCQc0IOESZk7/7tJkNsUlHQZ2AzndCyqdj5rrYJJ/KzEfY8wJHVneNXM0XWqb7PB0qmz9CAO7c6ycHpQcJfmC1LtdhLMpBNbpp+V7nvhNNNfIOLiWPrTJ9P3B8aG3eNPdoPW94NouUYbJ16ltGnMx9Ote04BYu4A7bNk+8a/6Cr14NmBBxjNeoLo4WtSZ7IwhaMXh2RujY0KYqZIqOoiI8DYHThoTjzO7GZ/rl7nR1lQEXJSrs1vYPIt0g0XkTNOmzRZjeObKCNndelKRCw3uOstJ9tDzGnNwR/KtbARWI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26, 2026 at 10:00:53PM +0900, Harry Yoo wrote:
> On Mon, Jan 26, 2026 at 08:51:10AM +0800, Hao Li wrote:
> > On Sat, Jan 24, 2026 at 07:46:14PM +0900, Harry Yoo wrote:
> > > When allocating slabobj_ext array in alloc_slab_obj_exts(), the array
> > > can be allocated from the same slab we're allocating the array for.
> > > This led to obj_exts_in_slab() incorrectly returning true [1],
> > > although the array is not allocated from wasted space of the slab.
> > 
> > This is indeed a tricky issue to uncover.
> > 
> > > 
> > > Vlastimil Babka observed that this problem should be fixed even when
> > > ignoring its incompatibility with obj_exts_in_slab(), because it creates
> > > slabs that are never freed as there is always at least one allocated
> > > object.
> > > 
> > > To avoid this, use the next kmalloc size or large kmalloc when
> > > kmalloc_slab() returns the same cache we're allocating the array for.
> > 
> > Nice approach.
> > 
> > > 
> > > In case of random kmalloc caches, there are multiple kmalloc caches for
> > > the same size and the cache is selected based on the caller address.
> > > Because it is fragile to ensure the same caller address is passed to
> > > kmalloc_slab(), kmalloc_noprof(), and kmalloc_node_noprof(), fall back
> > > to (s->object_size + 1) when the sizes are equal.
> > 
> > Good catch on this corner case!
> > 
> > > 
> > > Note that this doesn't happen when memory allocation profiling is
> > > disabled, as when the allocation of the array is triggered by memory
> > > cgroup (KMALLOC_CGROUP), the array is allocated from KMALLOC_NORMAL.
> > > 
> > > Reported-by: kernel test robot <oliver.sang@intel.com>
> > > Closes: https://lore.kernel.org/oe-lkp/202601231457.f7b31e09-lkp@intel.com
> > > Cc: stable@vger.kernel.org
> > > Fixes: 4b8736964640 ("mm/slab: add allocation accounting into slab allocation and free paths")
> > > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> > 
> > Looks good to me!
> > Reviewed-by: Hao Li <hao.li@linux.dev>
> 
> Hi Hao, thanks a lot for reviewing!
> 
> I was tempted to add your R-b tag, but since the implementation has
> changed a bit, 

Hi Harry,

Thanks for letting me know!

> could you please provide R-b again if V2 [1] still looks
> good to you?
> 
> [1] https://lore.kernel.org/linux-mm/20260126125714.88008-1-harry.yoo@oracle.com

Sure - I've reviewed v2 and it's still LGTM.
I'll send my Reviewed-by on the v2 thread.
Thanks!

> 
> -- 
> Cheers,
> Harry / Hyeonggon

