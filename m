Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DE9DCD98F1
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 02:45:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 077506B0088; Tue, 16 Jun 2026 22:45:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 028E16B008A; Tue, 16 Jun 2026 22:45:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E80806B009B; Tue, 16 Jun 2026 22:45:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA70B6B0088
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 22:45:23 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 24E9140287
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 02:45:23 +0000 (UTC)
X-FDA: 84887863326.17.B04782D
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id BC79C1C000E
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 02:45:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UxhGKY27;
	spf=pass (imf20.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781664321;
	b=3wCcNCOvuaVk/j0PjrItJEPtiuEcWf/ZXNJAQt0Fjya5jcfG7EZbLEOr1KpIp0Vi67jhz6
	0apG2rNXTbJyTu1FrmzuK1pcyBt5vgwGAzWErNfWtCgWDf0vXCqt/TvfixTkV301n5LYy0
	v29mhVl4bg9ViFa2z8YuACiFQQdPEfQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UxhGKY27;
	spf=pass (imf20.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781664321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TE8Zhx+tik2mlGT1brOJRNQEI17yTIRb0RnlAbDQgYg=;
	b=daBrDBrgCPn5juoifvLzL6RxJmUBkZkREn3eIjXwSRASsJONIxGw/xxsVHV8mM4Vps1jOq
	HQuIzSiLujIYLgRfnIDwBoomFTckoiAyxwTQvQWxHV85h64shYX1G4azWMSOh6nGHFAj5d
	SDyeoEQgxrxH/UNaL0RLSJ9aF2mergg=
Date: Wed, 17 Jun 2026 10:44:39 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781664316;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TE8Zhx+tik2mlGT1brOJRNQEI17yTIRb0RnlAbDQgYg=;
	b=UxhGKY270xQ434cr59J2MJ1zakMyO/B9jgpWgY5G4CzFeuHp4qiKIk7lSEA3NoLTrpLmWP
	CkDbvK6+IvyYSkCJaTmVRT1D5WHiJebwpfuphi9UlY/h1I6xoqjz6VH3HpJvXRVSG4bV2Q
	e+NtAD+KA60PGKs8VTSmbx2C1vDBqoI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v3 01/15] mm/slab: do not init any kfence objects on
 allocation
Message-ID: <ajIJ9sS68jxkQdeR@fedora>
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
 <20260615-slab_alloc_flags-v3-1-ce1146d140fb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260615-slab_alloc_flags-v3-1-ce1146d140fb@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BC79C1C000E
X-Rspam-User: 
X-Stat-Signature: di81y1ponbkpamxpggmce14y69se6tzw
X-HE-Tag: 1781664319-485873
X-HE-Meta: U2FsdGVkX18DbJsplU3gFU4q1yp9LpESK4KJC36Yxa9EyUrod4cZWTz06+ICCm5JojjOOEgWhKXildITSl1ZSJoTrucItseVYzTbBOKPe5pjYHyG908ontCNnr6TxMc237KTK8zzKzr+x+cTtNYTfTt95HHFNcgcaiJPIqyzyze7Vbuq5jK93F5OHtxwuthTusoEt9O78dAYVnMU4R8WPQNQbCoUIeTN3vUErhAbY7wau0ixV6vopLZXT4e7hv82yTH/vfqVL2BC3FSxJDQ3EJkMk7ZUZe6z8pYKN+glkDWiVqggiBiahDqAq3Jsp53kd+dGxaoNe/5/C5SJhUse4Bdc1/nOqb0YJ3JNtpjVKoqRVarqyUzacrQq/CUlsO4bWdPJhKfOXRyOJTvY5K2vKWazUyjR8R149CfkRVgU47TQ17FFDtbdyHC6KPyfjriyNUcDdPxAeoqaDKj7CpSkKO8jonnAs+3zqEu6SUXuT2xzPkhmK1va+X0eaQBRQ5iJHAy9fQRoCgHMqYZSIf+74DbvGemut/VAsUzMtg2o9pwBHM/sm44nAreA9gnTiSu75Pm21g8Rh5pkjbiBGPUkQYmx3EUO7rNwIsBildXGqFaZ/UH339/CGqptDe1BtTMPzxnF7o41btu8Hp/62xvG+uE04fhH/ytTsG9P/e1mIVtmDJUb5qmA3T7EjKJo1b/QOVzQj9hKo6CR7h52PBR+mgs6LqymK4BK0U3bmeVl+jx2p++zs7dcIyzcOGT+FDH4yH8SsIjyEVl/63nZPHT2CFi6UzeKNY7L/Dma8m/cLSbl/URG48Qp3IlZBgmz/O90wTwkO04CahLhAuy2XkE+ludcnK/AVTpb4M0+rmDDewacLD2QPQwG73FveLa6zjcTnDLpdoXJR/dtA0Z3t4TNsCLVbch9hYYwz1HhI+j6dAZBxlxoJJPlLlK4T4vO0gT7mOQwXyyYdF0jCstmnEj
 Mf+/yWYX
 zWqgJeLtSzpW7BXKV7trxTQ6zNKFPVffdYG+/gDxKivLmmC+6TF3CvcO/9IXXAFED7mtC0YcoVOKH/ApE9F5Ew2567cl5UVw+Bdt3H2rOV7j62XsbwApZLuj8IwBsiiXjj+kJ8KXxphbvPLb6GUy03fNFSxo2uw7zTCDpEJuSh1RtiOZGQTWuxbCHOf3vWL5e/tILwD7IGFCJBuwVmI9LTq9+mTjaa3F8jNtcnAHsUvHu1+vubhd0gECfinN6Cuze/UxmMUDkyU49d6bqiyV+R4v68S3d3qXahxGzcHg2HP30KdgCiQfsvOHv7lFrUJ6MlcXPvpm/1KoYnUuB/eamZ/mfrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 15, 2026 at 01:54:34PM +0200, Vlastimil Babka (SUSE) wrote:
> When init (zeroing) on allocation is requested, for kmalloc() we
> generally have to zero the full object size even if a smaller size is
> requested, in order to provide krealloc()'s __GFP_ZERO guarantees.
> 
> When we end up allocating a kfence object, kfence performs the zeroing
> on its own because it has its own redzone beyond the requested size.
> Thus slab_post_alloc_hook() has an 'init' parameter which has to be
> evaluated in all callers (via slab_want_init_on_alloc()) and should be
> false for kfence allocations.
> 
> For kfence allocations in slab_alloc_node() this is achieved by subtly
> skipping over the slab_want_init_on_alloc() call. Other callers (i.e.
> kmem_cache_alloc_bulk_noprof()) however evaluate it unconditionally even
> if they do end up with a kfence allocation. This is only subtly not a
> problem, as those are not kmalloc allocations and thus the "requested
> size" equals s->object_size and thus it cannot interfere with kfence's
> redzone. There's just a unnecessary double zeroing (in both kfence and
> slab_post_alloc_hook()), but it's all very fragile and contradicts the
> comment in kfence_guarded_alloc().
> 
> Remove this subtlety and simplify the code by eliminating the init
> parameter from slab_post_alloc_hook() and make it call
> slab_want_init_on_alloc() itself. Instead add a is_kfence_address()
> check before performing the memset, which will start doing the right
> thing for all callers of slab_post_alloc_hook().
> 
> This potentially adds overhead of the is_kfence_address() check to
> allocation hotpath, but that one is designed to be as small as possible,
> and it's only evaluated if zeroing is about to happen. This means (aside
> from init_on_alloc hardening) only for __GFP_ZERO allocations, and the
> zeroing itself comes with an overhead likely larger than the added
> check.
> 
> While at it, refactor the handling of evaluating when KASAN does the
> init instead of SLUB, with no intended functional changes. A
> non-functional change is that we don't pass kasan_init as true to
> kasan_slab_alloc() if kasan has no integrated init, but then the value
> is ignored anyway, so it's theoretically more correct.
> 
> Thanks to Harry Yoo for the initial refactoring attempt, and for updated
> comments that are used here.
> 
> Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-2-7190909db118@kernel.org
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

