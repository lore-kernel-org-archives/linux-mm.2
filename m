Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BA9BC87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 22:03:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B55886B0098; Thu, 31 Jul 2025 18:03:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B073D6B0099; Thu, 31 Jul 2025 18:03:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A43056B009A; Thu, 31 Jul 2025 18:03:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9063D6B0098
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 18:03:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0E5B3135499
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 22:03:37 +0000 (UTC)
X-FDA: 83725937274.22.9ED61C7
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2122280009
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 22:03:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ac65Y+Ql;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=pyyjason@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753999415; a=rsa-sha256;
	cv=none;
	b=LVTCb13vnZF79rhgUGawc0U8W7X/YmMlASnqzFmniW1XmQW/6xJ+tbjc5QM9lhCWHUDW/t
	yzG5rS4TOsP78qOGGkLc0pBFbOnky5nh1Jzg0eY6eSlQHxvjWRh5B/ohlH8+GHgh2yYAA5
	fB+3ftHDmQCIzvCfpLH1FAA1vt55BYw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ac65Y+Ql;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=pyyjason@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753999415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EGu/ALKuNn9LH5k5HOTa1HKwUmJnZbmVQXYYh6YCD4M=;
	b=CCoTunm8dqh7s8QCtJZhdz01UstgfOYulyhqIR2J/nhhSTfMxZ/D5orWtcS+l7D4pmLalf
	LvhtE/AfJMzhZGR7zREv+F+pSPoS89Wf7Pv3nHs7Yak/47094fdJ2qxNtoHUDY7HBlKm0Y
	J3Wa8WzLWbBVtMmj8xIql635pF+60Zw=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4538bc52a8dso7732965e9.2
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 15:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753999413; x=1754604213; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EGu/ALKuNn9LH5k5HOTa1HKwUmJnZbmVQXYYh6YCD4M=;
        b=Ac65Y+QlRgvEei2hm2inMloS+m1Cm9vagZ8N5CPboRcTqa1T4BhFkDm8Sshm5pY8Uf
         yQvG+R9+6dU8FFTWWR1a5oXoGQFVbm/M9Vm4vWCJzh5vOsrCArKSNGaOMCRVp9dQ69CI
         kDoLqOizG5ZXqbB3cSUAf7XQ0RbbpjXbDruZxH97sCjwK3LD8ydKHDecV6JcqSAyVsPY
         t/EBggguTdMvHxyd3dGB2/MW3uyyvdWOqUeC9CcnR9wbgErQqmVKArdHJQve1xFAsEpa
         VExysLzIBTLfKO5uF34rthsJeg4/v+nOk1Hq68uZTswBFuwRExWelSg7l9kxZxt1USKJ
         bTJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753999413; x=1754604213;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EGu/ALKuNn9LH5k5HOTa1HKwUmJnZbmVQXYYh6YCD4M=;
        b=vKoUkxQtXwww55BFos8AiQMXOrd82apQNrdhhz4M2FBlqB65XVR3+DizUksfkZmswJ
         DaYiiQgnnJeRDOLDNx4fmNyxUyLURaGHCWo+N7ycXRFle5m79yfFpWgspmoT3bc9FPLB
         bOo3y4SwVK/RWIk+RjA6MUtQ46bCQgbu9yh6OZSUQyZKe/wQxymb+baikwZEUmaicoZ6
         yjpHrnnmYTgriEC3WFJdJ5v8uOrBGwuqOBwRhRWAanc3/MXj5IEX/1fCBrIZNQVJ/774
         /rH3oYIzv9Qp47BgnFKD8DGP5wGQfrijWLX1IfwDDe4luYww08DMOwsVGflTjdNJZNRv
         D/Tw==
X-Forwarded-Encrypted: i=1; AJvYcCWUhXEifGG8K9uEiAbPR3Ezpgt9Ml5w9q4VG0juJXTTT3DktS2DXxxW61ddWpYcU3C1flLlCGJYcQ==@kvack.org
X-Gm-Message-State: AOJu0YzMWew29hKzu0Mq4vx8U90y98nFPWK1FNlXyWwBAMHOMejwN4z1
	gQBD+jhOLHW2dUQeDN41djPgzUGuVAqpP6mp/CMcalwsCkgb4Eq1Lmri
X-Gm-Gg: ASbGnctDRVyDbqPnViwCMsNiNYSxCjlgWcZI/YNUhiJ4rWZJSD0KyVzxiF2Ud8ySK4a
	qxJG2smUGt0hhiPe8+5cUO7HnEmjtO5lCCp5M1jWk1RCiyB/zPZqPSVQoXCrHn1W4JrPf46xvGj
	yNNCC0ldv9b0UlFmJ8UHhWKzBnJXjv2vvrB6sbSGSQIYisC9xeMp1a6w9NJc+QxGN3KdM+OPpIC
	aCu6bzm6UBVlDRWfcwtYv9dg8PomejfATEnITnr5aX3OvNy/kDGAQ19zNDLs5tGm+fYiomVIxFN
	HtO6s7WApHFuEGtyF9Qf7BjlsQdYCkGgoBdCxIW8YTlm8G2kDnsOEuQoPCCTd59+9pYDVG9v0N9
	eslXfsGy0MC7ZDYSFvv/4yYQVpoCfYxy+32Mug0/wuVrMpkyC2suj4vJYHs0CX02v0B99C5nAxa
	tqRYFec0SUsdOMoTjE3w==
X-Google-Smtp-Source: AGHT+IEpQU5RUUY6u5gnu7NyPeCEdAAfsGAjn+vhiZE1PCPsLtEeTjEmZhRhMRAnMw5GEfshKbtFxA==
X-Received: by 2002:a05:600c:3483:b0:456:8eb:a36a with SMTP id 5b1f17b1804b1-45892b9d8b9mr85100285e9.13.1753999413041;
        Thu, 31 Jul 2025 15:03:33 -0700 (PDT)
Received: from Yueyangs-MacBook-Pro.local (vpn-254-003.epfl.ch. [128.179.254.3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c453c80sm3623933f8f.43.2025.07.31.15.03.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 15:03:32 -0700 (PDT)
Date: Thu, 31 Jul 2025 23:03:29 +0100
From: YUEYANG PAN <pyyjason@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>, damon@lists.linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm/damon: Add damos_stat support for vaddr
Message-ID: <aIvoMbici26ekErC@Yueyangs-MacBook-Pro.local>
References: <c05b1b4f66758c0154e4d037adcb15c43917f38b.1753895066.git.pyyjason@gmail.com>
 <20250730175652.60173-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250730175652.60173-1-sj@kernel.org>
X-Rspamd-Queue-Id: 2122280009
X-Stat-Signature: s16eidrpzwq6e7jmjgtdi1p9ghi9c1pt
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753999414-508563
X-HE-Meta: U2FsdGVkX18s5u2kQurjNhgRNffSOL1J2qPo+Ojw1gphu/qAc2wnQ/P6pOMNveDbqEBs0ea34LC+Sz/kY5c6k8rMYjhbb3gbFykzjtvIST+zoJjltSeupEym8WLUYEqDGoHr+c3I5FvpDeyXRab/JBxVnxVYicpFs6s9h240G+bslaIZ/Ph+5b1hYsTUgMkQ+JmrfZ+pemuRzvA7cFJIo9znavq5DU6Mknx9fsGdpRWPJcSnANvFzsAJim6+eFm1rXySibAobJwatQ/NiYiFejZuQjVXi2sXo+PrI33sI6niFaYfQE+cCrPkPQ7cFgN947WXP8oj1b0320txFTaVZ2NvgHlKe/93Z7qOsdoQwmkWN/gEBDnUZZPKzDkirFRr421JIOFI0IuujAM3FwBM+C5fZGSM3YY+raLnkhDcdgd2s5dN6kqIOz+ZRKqtM2b7BzZAhf6RQLVzDE8BsUv78E/uFph2T9nBz1O/nU8uDhdIZNjY+Gl5XGkkntlgkOLicKN50Z/XGErtjFFBpPwAruFgeQYFYWZECgJVxXnU0a41+FoizzTktoKSy8P8aj6Q+SF1MLUxLwheSj++JMFPxGZzAUUWWvb5ML7ol8TZwF/CG5xzWjcJy7gZe1lftWwhcKXF4GjELbDtEFVuVLDGa81roufxbkjtgYzHVzrRt2+tIbiHj8XYzq08Lfr0/dbdVnfxaNlPJlyxRWslaL7DHEC2Q0F5iiK72qlsPBhG7O/pN/LSfKT5MXIhVsYQZpMh7RUmoj9Tezr0UW2GQYkzIChzfmgc4WvBVql3ZiV4kGg1BbIkmuXojNv7Bd80p5Pvs31yByTedrijTC4C0R4ztuWYKoEhP+CMzCJY/FNdcm00CH3aJ+SLc7/oi6GbGIg8nuLV/EWyu8CXp3EBWEZfu603kKyUEQabCb/lLDsP+sGoI4wmWqSlBATxfXyVKBnaxEdbzx8Zi/h1p/esy7a
 4QrSupbI
 Kdn4I3PpHv7oWvLiOugmfEiPpqm8HiOrXbR9Xn2Wy2aUa3adwuD/4jYc7arRzDtQsGHUbP1vV0ce38ynOzuDaLT2z0X7xOWEfAoRvBl+LZSDSpSwkWcdmlhiklqVjlKKU0sn0ZDMCa1t40YVZxKe7sqOAdczzESXnaWM5J3dYt01S42GnkVFDG1jtlKONeUDa/MUNUq502yfpJB2DJ8wgvR5qjSQ1bgYvBpR+sOYI0giIHF8f+q4hAOUe1rIh4nAVN7gtn5G3+qLPl1qNpn743+HasTVH0g8yBUFP+IW5lQB4pk2KpHHyCtxXwUkwyMKAaRaBp3hcne/eGlQGkkm0XflzZct9Mww9Rub5jkzqnjWXz99RNcC2d5hvLNcTQf+jvXP8ELC21qMjJ94Yj2W+F8kDdJCrj2nJOsQwlmgls03GmZ6fBZuBCx/VlXMk8DMxRniBmsVeWn364vuhzsK9zBWNz0RyGgyMTcShkFhUTaXhAcT5yA87RD7OCYqv2sLEDdE+EwurItc74OVEocMp5ID7Y6z5fp0LkTcK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 30, 2025 at 10:56:52AM -0700, SeongJae Park wrote:
> On Wed, 30 Jul 2025 10:19:56 -0700 Yueyang Pan <pyyjason@gmail.com> wrote:
> 
> > This patch adds support for damos_stat in virtual address space.
> > It leverages the walk_page_range to walk the page table and gets
> > the folio from page table. The last folio scanned is stored in
> > damos->last_applied to prevent double counting.
> > 
> > Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
> > ---
> >  mm/damon/vaddr.c | 105 ++++++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 104 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> > index 87e825349bdf..6ed919e817e2 100644
> > --- a/mm/damon/vaddr.c
> > +++ b/mm/damon/vaddr.c
> > @@ -890,6 +890,109 @@ static unsigned long damos_va_migrate(struct damon_target *target,
> >  	return applied * PAGE_SIZE;
> >  }
> >  
> > +struct damos_va_stat_private {
> > +	struct damos *scheme;
> > +	unsigned long *sz_filter_passed;
> > +};
> > +
> > +static inline bool damon_va_invalid_damos_folio(struct folio *folio, struct damos *s)
> 
> Weirdly DAMON code usually keeps the 80 columns limit.  Could you please break
> down this line?
> 
> Also, the name feels long to me.  What about damos_va_invalid_folio()?
> 

Thanks. I will fix it in the next version.

> > +{
> > +	return !folio || folio == s->last_applied;
> > +}
> > +
> > +static int damos_va_stat_pmd_entry(pmd_t *pmd, unsigned long addr,
> > +		unsigned long next, struct mm_walk *walk)
> > +{
> > +	struct damos_va_stat_private *priv = walk->private;
> > +	struct damos *s = priv->scheme;
> > +	unsigned long *sz_filter_passed = priv->sz_filter_passed;
> > +	struct vm_area_struct *vma = walk->vma;
> > +	struct folio *folio;
> > +	spinlock_t *ptl;
> > +	pte_t *start_pte, *pte, ptent;
> > +	int nr;
> > +
> > +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > +	if (pmd_trans_huge(*pmd)) {
> > +		pmd_t pmde;
> > +
> > +		ptl = pmd_trans_huge_lock(pmd, vma);
> > +		if (!ptl)
> > +			return 0;
> > +		pmde = pmdp_get(pmd);
> > +		if (!pmd_present(pmde))
> > +			goto huge_unlock;
> > +
> > +		folio = vm_normal_folio_pmd(vma, addr, pmde);
> > +
> > +		if (damon_va_invalid_damos_folio(folio, s))
> > +			goto huge_unlock;
> > +
> > +		if (!damos_va_filter_out(s, folio, vma, addr, NULL, pmd))
> > +			*sz_filter_passed += folio_size(folio);
> > +		s->last_applied = folio;
> > +
> > +huge_unlock:
> > +		spin_unlock(ptl);
> > +		return 0;
> > +	}
> > +#endif
> > +	start_pte = pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
> > +	if (!start_pte)
> > +		return 0;
> > +
> > +	for (; addr < next; pte += nr, addr += nr * PAGE_SIZE) {
> > +		nr = 1;
> > +		ptent = ptep_get(pte);
> > +
> > +		if (pte_none(ptent) || !pte_present(ptent))
> > +			continue;
> > +
> > +		folio = vm_normal_folio(vma, addr, ptent);
> > +
> > +		if (damon_va_invalid_damos_folio(folio, s))
> > +			continue;
> > +
> > +		if (!damos_va_filter_out(s, folio, vma, addr, pte, NULL))
> > +			*sz_filter_passed += folio_size(folio);
> > +		nr = folio_nr_pages(folio);
> > +		s->last_applied = folio;
> > +	}
> > +
> > +	pte_unmap_unlock(start_pte, ptl);
> > +
> 
> No strong opinion, but I'd like to drop above two blank lines (one after the
> for loop, and one after pte_unmap_unlock() if you don't mind.
> 

Will remove it in the next version.

> > +	return 0;
> > +}
> > +
> > +static unsigned long damos_va_stat(struct damon_target *target,
> > +		struct damon_region *r, struct damos *s,
> > +		unsigned long *sz_filter_passed)
> > +{
> > +
> 
> Seems this is unnecessary blank line.  Let's remove it.

Will remove it in the next version.

> 
> > +	struct damos_va_stat_private priv;
> > +	struct mm_struct *mm;
> > +	struct mm_walk_ops walk_ops = {
> > +		.pmd_entry = damos_va_stat_pmd_entry,
> > +		.walk_lock = PGWALK_RDLOCK,
> > +	};
> > +
> > +	priv.scheme = s;
> > +	priv.sz_filter_passed = sz_filter_passed;
> > +
> > +	if (!damon_scheme_has_filter(s))
> > +		return 0;
> > +
> > +	mm = damon_get_mm(target);
> > +	if (!mm)
> > +		return 0;
> > +
> > +	mmap_read_lock(mm);
> > +	walk_page_range(mm, r->ar.start, r->ar.end, &walk_ops, &priv);
> > +	mmap_read_unlock(mm);
> > +	mmput(mm);
> > +	return 0;
> > +}
> > +
> >  static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
> >  		struct damon_target *t, struct damon_region *r,
> >  		struct damos *scheme, unsigned long *sz_filter_passed)
> > @@ -916,7 +1019,7 @@ static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
> >  	case DAMOS_MIGRATE_COLD:
> >  		return damos_va_migrate(t, r, scheme, sz_filter_passed);
> >  	case DAMOS_STAT:
> > -		return 0;
> > +		return damos_va_stat(t, r, scheme, sz_filter_passed);
> >  	default:
> >  		/*
> >  		 * DAMOS actions that are not yet supported by 'vaddr'.
> > -- 
> > 2.47.3
> 
> 
> Thanks,
> SJ

Best Wishes
Pan

