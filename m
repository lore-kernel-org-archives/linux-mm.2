Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B14ECD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 03:51:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A1F66B0088; Thu, 11 Jun 2026 23:51:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 853786B008C; Thu, 11 Jun 2026 23:51:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 769636B0092; Thu, 11 Jun 2026 23:51:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 65ED76B0088
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 23:51:06 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 10C68407BB
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:51:06 +0000 (UTC)
X-FDA: 84869884932.11.3A03F99
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf19.hostedemail.com (Postfix) with ESMTP id D79371A0009
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:51:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iDVoXPJP;
	spf=pass (imf19.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781236263;
	b=dfwSfD63ReRFdAHm1VxCN9nj4bZZ1ZdD9p02Xu5nIKdVAzdoNFX9zN5riSIkdsjbLTy88l
	qyScSrjFEZcS5G4WUQF0VcMTWWe/VAa1d1JgFX7fiFyB/2kAbh5ZEaBja07ulsPBLLOciW
	g1vEcyVsjcLfrKxtkdzBVjDsjHsSrI8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iDVoXPJP;
	spf=pass (imf19.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781236263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YFablcsfaJDFV28UgBUNum1R14bfzcLjgvR4MHNUUB8=;
	b=a22+Rn1zJ0FSOh/DJBSqIHH00wtdnPF5KbbO5ClGz9Mf+y5qmY+Xj+3wjD3/FCycIC/YwC
	hy55ewH1HLz/SZUpvVpdMKDURSVjVt0SsE7Fxe/Hzye6F945kGKYqfmQhpvf97/EFFpyPm
	uw/GtW+ZQRGB2e/R/TEwKvazdXLg1fI=
Date: Fri, 12 Jun 2026 11:50:28 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781236261;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YFablcsfaJDFV28UgBUNum1R14bfzcLjgvR4MHNUUB8=;
	b=iDVoXPJPbZ/3PSb05ZM5akVqcgSO4QZ+ARaT2daBspxmVqa6IMcmpUr57SBhcl1lGZXGYE
	hVWzkEUd076PffVQMKdItpA7i2zDLY7Jiqlav3KFgCJOv1i9x+c+Bxq0+uPptIQPaCsSUg
	4Ln5GvpNWulb/ERj7FWip5zcDV/QrVs=
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
Subject: Re: [PATCH v2 06/16] mm/slab: add alloc_flags to slab_alloc_context
Message-ID: <aiuB47Lj0vFGyuFA@fedora>
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-6-7190909db118@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610-slab_alloc_flags-v2-6-7190909db118@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: D79371A0009
X-Stat-Signature: fypetyiuzenuj3sffggowo38xr88jo5u
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781236262-292471
X-HE-Meta: U2FsdGVkX1/7LNiRI/X0DPaiyNa2qh4kWmLmok6FBDpQTco7mxWUkOnbfRtibfrT5J/u9W/ZxpYWJAV+JGes5pZE+s0rvgPTc+Z2V/Pje0lxwFeBVHv0KLaBOnc9+uxhk0H9yZpZRvSb7893LOBSXPjXm7llIsZHIKRaD36zpEVQIT6L+DZqXwZmfv/Uv574DHDaQ7WUNDCBiOK7bt/C97rlH/AfZKZY4P+P7CzddLYw0wiuIV2oYB39JamIqix4TW9scGyMraAoIEhyuUo01rbCDa0xqv7Z5wvrJcIDZaiBJsxhoMOm3GQJtOpC5SUcipp6NdJGV/AsUiKhx6rDKg8yqfD3yEFn7ZCWjl753dhoyHAB4N7ItyrjYGl6G3sCgqQAlga8k65uqFbUoaHLuYvX5ZlMfV2WHD597oIXflr7CnUjAJXLkUnlVkpO9Ll/dAZSb29HafD9wyK1P3RyW7qtsg9I9t+xKtpjf6ahIjXbcqgRH6h3xP8uFLcUtQcz4ld6Qm3VPUJEQOxdkDy0JPHY0pIpr8UEap5q9wJMAidWhKhFlg8wyZVBuTZerlc/9elD+wt1F5qvCTEO77zIEgRXDKP+A1xc2HEpRm6WXGUDmHinXk+/ZdIkkGUWz5w0ej5VQR3kuIRMrPjTkGf77oi1WDymBbvtOwXnlWhtotd5hfpj3bijhH/tRNmu7e0W93nWpvcitZM5/SVjWcTNT8zn1tK2QsuIbx5/pxDXR27iKiHa1ofC/ujmHvSDWPP2DTvcObi/Jw4LJJ6KcyiG2tH2Iyh1dFev0pv4NXVDETRgCYUvOu9tx6L1MGxcCNk5IdeTgwOrES+B/lGVIgGa5MQAeFPqfr3kf1K3gMU2bUwXu2Rgeu7gJhx25Yw2DmTlSzV+LZSZf7hQKQXuNQYkXAyMoB/PzKi2gs/oT30o5dT6M1NzxpLTwg0QibulBfdukuoth2S1dBg/NBBEdpz
 5xybrHG+
 EQd4hqryJjZ/mvk2RErUuy8uShopNTbQ/1GCgfQdsbXm1Ht/VHlrHl+LjxYV5Kjm7GUH/5sNPmM+QUqxS+7xd/pu+ZAJdGi8fjJlGuwFFFEBmhSjrkhqKYZ5NR0P1MFPdi+ISVCxIhH9oWQgRqmwMKgXbfIDEdgI+uCqKZ+zvkBhTXWghfsxh0+dSNvE6GkEbxabJQHC0tFr89eJ3Pon2FzOHyxeSHYtcu1PeZz4GYl6s8nNPsHvzpUB2FAl+w7LWqucVufS8ekPsDRIATtywoLbDEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 05:40:08PM +0200, Vlastimil Babka (SUSE) wrote:
> Add alloc_flags as a new field to the slab_alloc_context helper struct,
> so we can pass it to more functions in the slab implementation without
> adding another function parameter.
> 
> Start checking them via alloc_flags_allow_spinning() in
> alloc_single_from_new_slab() (where we can drop the allow_spin
> parameter) and ___slab_alloc(). This further reduces false-positive
> spinning-not-allowed from allocations that are not kmalloc_nolock() but
> lack __GFP_RECLAIM flags.
> 
> _kmalloc_nolock_noprof() initializes ac.alloc_flags using its flags that
> are SLAB_ALLOC_TRYLOCK. slab_alloc_node() and __kmem_cache_alloc_bulk()
> are not reachable from kmalloc_nolock() and all their callers expect
> spinning to be allowed, so they can use SLAB_ALLOC_DEFAULT. This is
> temporary as the scope of slab_alloc_context will further move to the
> callers, making the alloc_flags usage more obvious.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

