Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F39BEDB7EF
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 10:49:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BAA26B0088; Tue,  7 Apr 2026 06:49:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 691A56B0089; Tue,  7 Apr 2026 06:49:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CE7E6B008A; Tue,  7 Apr 2026 06:49:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4F87E6B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 06:49:44 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C6FB81A0752
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:49:43 +0000 (UTC)
X-FDA: 84631439046.29.03CAD58
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 32BB31C0004
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:49:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dzh5IUru;
	spf=pass (imf20.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775558982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Htxp7/IabQ4Xiz+tFlCaJ+XZjjLfsrm8Ki7HPqCquow=;
	b=yP36dsD8NSBmI+CAUoc5CAjR3HQ2Lb5fEJ45aM1CHvaEb/9ojsW9O2c5KJKR1pMHD26VdM
	OUyxSnJRj3zCQtVfqR/Hv3ODGyf6jE7MWFMUuyl7vQghxa9NdehALdkDTXu/1FDgTwAx3Y
	JfCdc4zZsTZoM/Om9ZwYzP1mSnY/riA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775558982; a=rsa-sha256;
	cv=none;
	b=IQ32A1jWE6JRnpJzojhSFa8BIXglORTczgou8gYphupMQ9BoSrgrBEr8IUoNmDglrnZTUa
	DdNxeRbk9tqdmXWKnK6y9F5KknuU4cvQu+WAzjGPJ8sGBJOvTusmu8wtjPjwk3xs84ip0l
	7zkHDxfJVotCL3NBjfcXZdA/wul6RBk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dzh5IUru;
	spf=pass (imf20.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ABE0C60120;
	Tue,  7 Apr 2026 10:49:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23364C116C6;
	Tue,  7 Apr 2026 10:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775558981;
	bh=yaqqzWcBkz9jMC2g5Pf5xF7lU+dIw75/p3GRmnmxZug=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dzh5IUrutaRxhZXz1W3am7LI8nPeJxe+kz1+aNkv8ZJ2oDkOCH6R2JK2/o+t3T5DX
	 gkQ9H+60DlaDJ/NHCyo6aYNH62kgs2ww1ZBN9rXUBvXdnAlGOQ5QgsWXkp2YJojBns
	 Yoanq+Pl8G1Kwn7Wk4octwg/U+dk/QKOoykZXg5XnqI95EURyuM5gyh09xu1WHY++t
	 gF9uTh8b0gFb6vz+doNTynt/DOCoNlDAGQmUfx40bg6auimYgf/fSD4pPRvfKCLqlZ
	 QzNp8M26wMA+Ygg9/UEpRhGkqxRs2EGEaYOfNTFw0fSNMOQ9qFaz0GH0EcAprSA5oC
	 JBkR7koy0k18Q==
Date: Tue, 7 Apr 2026 19:49:39 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Hao Li <hao.li@linux.dev>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, cl@gentwo.org,
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] slub: clarify kmem_cache_refill_sheaf() comments
Message-ID: <adThQ3f4kpefqvLA@hyeyoo>
References: <20260407100255.40035-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260407100255.40035-1-hao.li@linux.dev>
X-Rspamd-Queue-Id: 32BB31C0004
X-Stat-Signature: 35ok46i6met6kdy4udstazabhh4wz8tx
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775558982-445673
X-HE-Meta: U2FsdGVkX1/p7o7reSJr8yJ+0ZdPte28gIH9DGJxr75wGnFcd3W3Cscj4T1D7kzmoWdFKOizOtKPeYanaPs8ix0YJqBoRnTTLHF9rHLEsB5xc9HEpfasof7Ua6n7AIrMVzvaTN94usB9GIHAnYaqKnRkCVGawMdejnzZINoT8sLfHjok+sEJOOF/rM4TvLx6qUvD+/1tJe1uVC4HGU/024aUKmZO4/AxNxn+kZnAfPJAXtkWgyIKL1QlA93HGBG4bfoVC+s4Y/26IBkgd4IuN0b9zlULiIprEhqwKcNxZ0Q6EaGG2x6yESpNy8HQVJw4LAgPvPR/T2eVzTwWKDNU1Tk+sY5fATmmO4qjlWvyvLh+Up561fBeDXL9RO6x4+IkBnrUtKWNVFGIAfuz+ODZrXz3Tf1zjKmgchacJEaEvtehM6ONrrpGCgO2orcuqqWtLZXND/bFOULRBPWndCRDYZP5K1lfdUMa9VoaMFdB4yQ+QDkFQbq7hpjd1SUO/ska4bn76EdKIadlVweEz11RYHSDxgk/iMmkZl2z9jtJ1updB4fp2444mjy99B3ntqPxMa0PFA8tm/mXvK8zcGzen+FzQUbWIRel9O6PGgyBlHflou+dSCjMvjERMiDodkYLKk1g+fxCTmGpOAdiHLuNsOeNSYZNB+K9xvH6SZGm1CfCvYFp70mz3pfjAp+9YTTk0yTzSr3sLcOm+hYY8BWjPka1g5rwYJ1qP18M+INsyzmCxnqh1VJqfwCAIFehMxhbCy4Dkn4YH3Se0Iu9eqMlJCB3lEOyUsV9rRrawer1hr9NGajVb2VRxbRD1V0FDQu8cr9HdEY3NDgUE7KjWWMi9uk6kU/rAJSu+itF+aNNjLyPFJ1T0q63MBzOMNmid4Hc5lbrlaYGVPAAJL9+ojuriJsuDBZLzUvVNwXtbvO4uHiA1t8bcEj3/HCNK0aOqdWuOvk0yYJE1gGPKXn80pJ
 yVIBVo70
 SIAvobEaWBTncIbijzq7jjNFwj3ZAmvRJK36q2fIL+DP4o/vtkEV9kzCjyJYlxcJ9mB///nLPlGANculnmDjfiH0kpwTYeNoBk1e5aumaVdbcLFE+9id40dEdNbR1KazDxOnW77MV700UPJhdjya0Q7ogdCFLhswAYZ5ghYRJbUdk5bqv78g9s/NK9aV6tFq9c6E5bZuTocIIoAOPwlWGStGNZIROQyhLOQ4ZE6VrFzIqBJVWpbbZ8kDZb99KNQ3PfeyRUWnmcCnxlU3Jdi38mYFrXh1RfAEldIYAyWBDG2gVVumOpXv5T6tJerSQtnMeSNZo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 05:59:10PM +0800, Hao Li wrote:
> In the in-place refill case, some objects may already have been added
> before the function returns -ENOMEM.
> Clarify this behavior and polish the rest of the comment for readability.
> 
> Signed-off-by: Hao Li <hao.li@linux.dev>
> ---
> Thanks Harry for suggestions on v1!

You're welcome!

Overall looks good to me, so:
Acked-by: Harry Yoo (Oracle) <harry@kernel.org>

With some small nitpicking :)

> ---
>  mm/slub.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 4927407c9699..a45eb1bd2ce5 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5120,12 +5120,15 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
>  }
>  
>  /*
> - * refill a sheaf previously returned by kmem_cache_prefill_sheaf to at least
> - * the given size
> + * Refill a sheaf previously returned by kmem_cache_prefill_sheaf to at least
> + * the given size.
>   *
> - * the sheaf might be replaced by a new one when requesting more than
> - * s->sheaf_capacity objects if such replacement is necessary, but the refill
> - * fails (returning -ENOMEM), the existing sheaf is left intact
> + * Return: 0 on success. The sheaf will contain at least @size objects.
> + * The sheaf might be replaced with a new one if more than sheaf->capacity

nit: "The sheaf might have been replaced with a new one" ...

> + * objects are requested.
> + *
> + * Return: -ENOMEM on failure. The refill might partially fill the existing
nit:			      ..."Some objects might have been added to the sheaf,
      but the sheaf will not be replaced."

sounds a little bit more clear (tm).

> + * sheaf or leave it unchanged, but it will not replace the existing sheaf.
>   *
>   * In practice we always refill to full sheaf's capacity.
>   */
> -- 
> 2.50.1
> 

-- 
Cheers,
Harry / Hyeonggon

