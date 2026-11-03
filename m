Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2A15606A331
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 20:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RcoDvnjE
Received: by kanga.kvack.org (Postfix)
	id C49076B05B4; Tue,  3 Nov 2026 15:22:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAB346B05B5; Tue,  3 Nov 2026 15:22:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A72C16B05B6; Tue,  3 Nov 2026 15:22:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8779C6B05B4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:22:04 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0F22EC03C7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 20:22:02 +0000 (UTC)
X-FDA: 85394929284.27.2252D43
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5A6FD1C0004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 20:22:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RcoDvnjE;
	spf=pass (imf18.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793737320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZI36IvN614wZfc+9bgno27AitbTt9jTYGJEoJ2XdrFY=;
	b=Uam5Yn83gb0zfOKKwLtx53lPoZfqGfZ2xeT+AIA5c40bpxooHrrXeTgKqQo2zV3v+uP7dx
	eWGTHxyTHOpLF8EZUv4GR9fRA5FsQmnJh7cFIbV/ooU1oXaPTn3prKpdODt5JlT9bCAcca
	vjyFyBT6tq2kn3jF1sHOfvAhd7ajCj4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793737320;
	b=bwwe76M999WwcI8rOZ6PQNE1eFYL4tSX3pZjY9A/k3JBn0TJbjYOW+Jm/R8sJRLmdF6X7y
	QQ2uj1py4z9EHKX3nmjpMAgF3jcil7OOqdTNpCf3FHgApHF4QJMaHrJpvqF4Gb+6ZLZer4
	vbjepeuol0VbM+A7RZPDK5aly7l/b80=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RcoDvnjE;
	spf=pass (imf18.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B3FA43A1F;
	Tue,  3 Nov 2026 20:21:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54161F000C1;
	Tue,  3 Nov 2026 20:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793737319;
	bh=ZI36IvN614wZfc+9bgno27AitbTt9jTYGJEoJ2XdrFY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RcoDvnjE7moujvLfJtbEFbra0suwdCXxNcVPBt9C+MQr2fIm0ROIdyzWvCf0r6dPm
	 h1Yua3KwN/dXEbvecfBPraEq1DvHkQMvoF2Bp11NIyhrTb2NCMYj2w27/1eh/hNvWH
	 O6IP9cDUNObqZD1pqWdB6kNJNl7EUFpDky9G3OiS6bKFKY1mVeKeMUUn4DvFnIuQJ5
	 MfPvPYy2mOBhzLy8ZAizjeqfuKz6tTG4VQwTE83YJIVdVX9wArgcLLkJtkotpfWXyF
	 9aX10naWVt/B4m4NQciKHVny928DYGf/UA8QtXJSt4Dc85L5sZuX2NERO9yskptzgY
	 fgwK4+Cxd5s8g==
Date: Tue, 3 Nov 2026 20:21:57 +0000
From: Harry Yoo <harry@kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, kernel-team@meta.com, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH for-next-fixes v2 4/5] mm/slab: fix a deadlock in
 memcg_alloc_abort_single()
Message-ID: <auo5G__ac1qA9JRs@thinkstation>
References: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org>
 <20261103-kmalloc-nolock-fixes-v2-4-19167cfe4779@kernel.org>
 <DMLSN9VHK0P3.2A97046A4YXGY@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DMLSN9VHK0P3.2A97046A4YXGY@gmail.com>
X-Stat-Signature: 5nqzma34ka7sxuwsqd66aqydim3gfx4o
X-Rspamd-Queue-Id: 5A6FD1C0004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793737320-66924
X-HE-Meta: U2FsdGVkX1/zGJ+BogrDY3KP9F6CvvR6dI8qAy1pVEfT2Y92fuk2NdVe5Q5aP2bptRoSQN6j1D51RuiQjkBcZXNJBRWhR6sseCIRBnujBRvGSExZ7oOH0SgKUVE122K5I6rjBq8slDq2KgIllu6Dh6p77jo1njCxAGuaOLTV4lNgYU0lP6WlDjHZtDl8tq9PkcuIvZnzkz0WNcnOheuMJphWdxqHdIIbGifp5H7hTBCsdj1rLjrFwcIueS1e3MfL3K8apAQ3t8lpofC1Pk9HhzGrwDvS9TElsu7W6Z9te0ELCRN29cE3DqdUDUe2aMn8AMxkyc8tPG+9cOAhqN+s4jRVHxZ1nDkrsg9VT8I+5xx/Vn45TXVa+jvyeYOvXxIRsa/vsy1OScoh7WrykZScbc+0CYivoXS/ZJRFF4zQgzVQYG8NFjx6FNDIFUweUd0bsOKSeKC9Z+v65mfmaSo0zyR0c60OJ8uTeAuljUD7Sp7102jqRDIs6E1ul6ZvfPJOB3rqFcq0Ld+TCq0j0It51h8esN+fYbu1eaBPg9fjZkn+L1Efp0C+1lj2+BxuCLigQM2JAhvWs6jxaTniFH7ImZHhkMjlbLYoYrdmtLNTkwpmYAFvdR56qS6G+1KOLMwQ64sQh6t+iAO5IH5QP+Jj2l2FNUl/FoFWu5ZUyY4I+xpaDRs+H2f9BcOxCdjtPaRdh4YOQlY6dX6IgA9LPY4TOb44OF2NRMopI/PLwBH3DqwpIifukhFFeVcaQPd5gyVWKBKRIv/oRpYTRh+jjhVkFyUhWDyl5EwJHL6vla+TjWeUOW/YOidFKZe5VytJv/iV4v1KdxJPDHgL+B3sgw12qny67TzeAymGK4lamZbS+DjjApcRtmgEQuqneBKucDpMYY8xTCGXhFCh5JLPNe/92f+pc3HioBfRFdETg2dJguLfCnkQYT8KGtbJ9/fvn3eW69BarlDY231/itkBUWZ
 Y5Zm6wXJ
 2g6lJnaOmIFAuJBhJnxDp6Yf6CRFuvf0SdW7cCshnOqzRAVMUkJhh1RuJMfc8/KtI+a9DWsu7/fi/KpYvhlay4mTbixL5kjzIpXdt/DdSshAq0jhR8brWBe7qpxbQIsX3/ZmCB2kkYaHOkRHA18/+9kceoGl3BT29vc21tx1Eq4Od9dkgDCIUkezw27QLan4Ds8I9NAzyHEnwcDa6hTqxphRb4HpB5ZDV10xQlWcUvUUeK0cEvY5PKGOLRxehFBfR8Vr2MCV9mAx9jf3e+Nktmlhp5S0mw631YVFyvUqg+t28SH+slqeU2qzqUSTiSk9Wm4m8CAKCHXRAJY+ocgsyI6RobBuCNsgTY07gnOLY50VKhP0OWH/YBv1KIG5KqGcqLheVp2cPdm1qbNmOcJGVlJ4hkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 06:40:09PM +0000, Alexei Starovoitov wrote:
> On Tue, Nov 03, 2026 at 06:47 AM Harry Yoo (Meta) <harry@kernel.org> wrote:
> >  	if (likely(size == 1)) {
> > -		memcg_alloc_abort_single(s, *p);
> > +		bool allow_spin = alloc_flags_allow_spinning(ac->alloc_flags);
> > +
> > +		memcg_alloc_abort_single(s, *p, allow_spin);
> >  		*p = NULL;
> >  	} else {
> >  		kmem_cache_free_bulk(s, size, p);
> 
> can we call kfree_nolock(*p) here when spinning is not allowed ?
> Karl's patch did that. You replied that memcg_slab_free_hook() should
> not see an object that is not charged:
> https://lore.kernel.org/all/asaAwg1KeZoEYd4K@thinkpad/
> It's fine. __memcg_slab_free_hook() skips an object with objcg == NULL.
> The else branch relies on that. kmem_cache_free_bulk() also gets
> the objects that are not charged yet.

While this is technically true, this relies too much on the current
implementation details and makes the code hard to follow.

> > +	if (likely(allow_spin))
> >  		__slab_free(s, slab, object, object, 1, _RET_IP_);
> > +	else
> > +		defer_free(s, object);
> 
> That's an irq_work interrupt per failed charge.

irq_work overhead should not matter by the time memcg fails charging.
the kernel can't reclaim memory in unknown context and allocations
won't succeed anyway once we hit the limit (unless somebody else
reclaims memory for us). We have a bigger problem there.

> kfree_nolock() tries free_to_pcs() first. It calls defer_free() only
> when that fails.
> 
> Then no need for allow_spin in memcg_alloc_abort_single(),
> and the fix doesn't depend on patch 2.

Patch 2 is an independent bugfix as-is already. We should really stop
open-coding slab_free_hook(). That ended up missing init_on_free handing.
 
> Something like this (compile tested only):
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 45e077c..fb92b48 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2551,7 +2551,10 @@ bool memcg_slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
>  		return true;
> 
>  	if (likely(size == 1)) {
> -		memcg_alloc_abort_single(s, *p);
> +		if (likely(alloc_flags_allow_spinning(ac->alloc_flags)))
> +			memcg_alloc_abort_single(s, *p);
> +		else
> +			kfree_nolock(*p);
>  		*p = NULL;
>  	} else {
>  		kmem_cache_free_bulk(s, size, p);

-- 
Cheers,
Harry / Hyeonggon

