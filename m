Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDC4CCD98F0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 08:23:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA6E66B00AA; Thu, 18 Jun 2026 04:23:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B57196B00AB; Thu, 18 Jun 2026 04:23:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A95246B00AC; Thu, 18 Jun 2026 04:23:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 855576B00AA
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:23:48 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 037231206A1
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:23:47 +0000 (UTC)
X-FDA: 84892344936.21.D80FF8B
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id 11C9EA0005
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:23:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bfJZ8O6W;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781771026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dN14oRJSbqwIkwKM2Sd6jqKzksJad326cLtI3tbLbjY=;
	b=cGTTdUiuqFCl3GeWEKHvzVppgex3zdkw/FRMWowx4Kt6a9oWghmQFmO2bHYDKjANQhwUwz
	nvgmtrG4xFWiZ9sb/u3q6BmKhDHfo5eRY5Fq4E3CpQfQ9gqjLzvFMdYFn7WsFIedkfArJf
	zmmv52aDzfGgukyVNwV6a/0VszAjdc0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bfJZ8O6W;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781771026;
	b=6zEg8hDtShBXQwi+KcC6diklftoPCwOGPqWL4AbdBay/jvKdKPLYtzWaGcyYF2reJs19gN
	N6K6KMUqp6xWeO1WcD0DzMUcbPNuk/7sO1+HYzqLz6unytSdKOw9rtKUcYJUVJhi8bpDNZ
	a3NHqKiKGWcfluB/4CbaZ55vLOjGaJ8=
Date: Thu, 18 Jun 2026 16:23:32 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781771024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dN14oRJSbqwIkwKM2Sd6jqKzksJad326cLtI3tbLbjY=;
	b=bfJZ8O6WD2awZZmLUvzA/vF9D97j0zbcGCT7hs5TGLZkvtVRvAg9wCKDtLDdxOHIPRm/rH
	+KnXftHvAr6qfI4Hs/4olirIdD/duq5cji1tkOMEOdBk8CcLv07Tl0yjlEKfbqjclJXE85
	u72nZHF49mtYJ3CjAYaaq35xEAvD8hA=
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
Subject: Re: [PATCH v3 14/15] mm/slab: remove __GFP_NO_OBJ_EXT usage from
 alloc_slab_obj_exts()
Message-ID: <ajOpMCibPiFTkj6d@fedora>
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
 <20260615-slab_alloc_flags-v3-14-ce1146d140fb@kernel.org>
 <78b67a9b-44e5-4649-957a-9d42bfaa098e@kernel.org>
 <26c29e4b-09b1-424a-b4e4-3358aac20115@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26c29e4b-09b1-424a-b4e4-3358aac20115@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 11C9EA0005
X-Stat-Signature: 811rfga5ere1dbeynjd5zb3nyuubbeh4
X-HE-Tag: 1781771025-390580
X-HE-Meta: U2FsdGVkX19aPwYpjconIgmyRyVC1WlS6BpYsaZM/tWhxs3VoJkoqBzzTdtoQMBVOhp5+Zrf1R+FfIsgMjifm3qsI8l0+z3VpoOglYBGg9J92HFBonTkLV2PWRNePn3C8QTydp6JlzKUYhRiHdbeyhSUiC4euo45AREtPnx1lgPZnCwriGpn9aAaAYXzqLB8Bw1Gumx8/ICAlxIpdaf8yaWMy6XXJ5U6bX4rycuHmyuuE6Ogt85aV+HUW2DsYbdr32AtK9kOVOS66YOr2xt9AItzLuSxvtfD58ReJzuHkkwkfvr5lueg007FAqKE1FA7B65rW7XgDdd72A9GlCYdMEdPzUevrqUhHX39MEDlVWhU1Q2qVmd9afFW/nXkCRJII+RQcQNv3spkDN5Qzo/XtRRqHNcqoSkjl5abrmnW1/7TAkwjVN7/ylLMqqGZNzcaeaiILBuICDhVmPv1it6Gtt+EdDADMTnrRaSouDlRI3U94HlssRn7rcrNxcOI6kZW1IyP5iNm2IOF+tjpmzmrhGaVnTwBaG87keXclajViJqqxwxWshF73jdlwmYEbWMOnowQDBIEYFon7RPHOEIjaLdMT6DNJQctYq8dbU9JNPmxQZX3xZk6tMSBNPjXAPzXDq7cAkQYPDndjs84i9zWYwm4gUT+Cm5+d9z+Y4NWRrSxgySAF1HCjgTq20cyalhq+4zxv/9kFEMR07/zpbbP1LR7AHDpnPVtWk33ugfymCvyu+ZYha6acn173JtBia+ZtyakShVrScPsAr/B4XBrRsfrZZiFXinjdp3cVVGea/6Khn/t3xwt6+khcDg6zWwtylUSZVPp3oBoQkE2TyV3xPcIh4eXDtGUy5x7jDduWT7r5rrfW7tB6SnbfZQij3brN+lMHGqjvavD+bYhNmhkv7Zv2VEW2WbnZFDsiDK7E0WQWDZiJIOGl9ibdsDZkSyDYqSGbKgHPsv1/5l6Rqp
 QM6U1b56
 ORsjoKXcCp6BqIXvo+3BbGm629okZ8dYpgJVmSBxi74mMNTMxo9BBNgHgM+SKPIX0aVQsIgDLYneNWddJfBjIPkRJCG/TNsZKhpZSpQ2NO7yceT7yIaNtxrysG8BMh4RNDHfOYgJDhFJSjmcUfu178q72x6OCNiNVK4h8tL8Z5cd50p0RQImsyt8E5469ToibOFW0vabXXUp/ewirhc9tODRgu3hxwHHk+a3m/uEaW4CbNjxaV8nBXqzMjd5ni2Jqagqe/2gcQ/P7jyMCkF4Jm0mzBOpjPZ9yD3ql5WgrsbXR/kCzHBZS7V1ADnnKP8Mgf2PipQLgHaeIYJhMpFcnQu1+HoX6nlc17GEAcZdcDcmcvwk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 04:36:58PM +0200, Vlastimil Babka (SUSE) wrote:
> On 6/17/26 15:56, Harry Yoo wrote:
> > 
> > 
> > On 6/15/26 8:54 PM, Vlastimil Babka (SUSE) wrote:
> >> __GFP_NO_OBJ_EXT has limited scope within the slab allocator itself and
> >> gfp flags are a scarce resource, unlike slab's alloc_flags.
> >> 
> >> Introduce SLAB_ALLOC_NO_RECURSE alloc flag that has the same intent as
> >> __GFP_NO_OBJ_EXT but a more generic name, meaning that a kmalloc()
> >> family function should not recurse into another kmalloc*() for the
> >> purposes of allocating auxiliary structures (obj_ext arrays or sheaves).
> >> 
> >> First, replace the __GFP_NO_OBJ_EXT for allocating obj_ext arrays in
> >> alloc_slab_obj_exts(). Make use of the newly added kmalloc_flags()
> >> function, where we can pass alloc_flags with SLAB_ALLOC_NO_RECURSE
> >> added. This will also pass through SLAB_ALLOC_NOLOCK so we don't need
> >> to special case kmalloc_nolock() anymore.
> >> 
> >> Note that until now the kmalloc_nolock() ignored the incoming gfp flags
> >> and hardcoded __GFP_ZERO | __GFP_NO_OBJ_EXT. But it's correct to pass on
> >> the incoming gfp flags (only augmented with __GFP_ZERO), because if
> >> alloc_flags contain SLAB_ALLOC_NOLOCK, the incoming gfp flags have to
> >> be also compatible with it. However, we might have added __GFP_THISNODE
> >> for opportunistic slab allocation, as pointed out by Hao Li, and
> >> __GFP_COMP by allocate_slab() as pointed out by Shengming Hu. Solve this
> >> by adding both flags to OBJCGS_CLEAR_MASK as it makes sense to strip
> >> them anyway for non-kmalloc_nolock() allocations of sheaves or obj_ext
> >> arrays as well.
> >> 
> >> To avoid recursion of sheaf -> obj_ext -> sheaf -> ... allocations at
> >> this patch, until the next patch converts sheaves to
> >> SLAB_ALLOC_NO_RECURSE, use both gfp and alloc_flags for obj_ext. The
> >> next patch will remove the gfp part.
> >> 
> >> Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-15-7190909db118@kernel.org
> >> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> >> ---
> > 
> > Looks good to me,
> > Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> 
> Thanks!
>  
> > With some comments below.
> > 
> > I was worried that perhaps replacing SLAB_ALLOC_NO_RECURSE with
> > __GFP_NO_OBJ_EXT will create a cycle of
> > 
> > alloc_slab_obj_exts(SLAB_ALLOC_DEFAULT)
> > -> kmalloc_flags(SLAB_ALLOC_NO_RECURSE)
> > -> alloc_from_pcs(SLAB_ALLOC_NO_RECURSE)
> > -> refill_objects(SLAB_ALLOC_DEFAULT)
> > -> new_slab(SLAB_ALLOC_DEFAULT)
> > -> account_slab(SLAB_ALLOC_DEFAULT)
> > -> alloc_slab_obj_exts(SLAB_ALLOC_DEFAULT)
> > 
> > with __GFP_NO_OBJ_EXT, it would have been passed to refill_objects(),
> > but SLAB_ALLOC_NO_RECURSE is not. However this cycle does not exist
> > because alloc_slab_obj_exts() clears __GFP_ACCOUNT (as part of
> > OBJCG_CLEAR_MASK) and memory profiling itself does not invoke
> > alloc_slab_obj_exts() when allocating new slabs if SLAB_ACCOUNT is not
> > set (which is interesting, by the way).
> 
> Hm yeah I think we should propagate alloc_flags to refill_objects() etc, to 
> avoid later surprise. But can be done as a later cleanup.
>  
> > Also alloc_slab_obj_exts() propagating SLAB_ALLOC_NEW_SLAB to
> > kmalloc_flags() is little bit confusing because it does not have any
> > effect due to SLAB_ALLOC_NO_RECURSE.
> 
> OK let's address this one by this fixup:

Both the patch and the fix looks good to me.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

