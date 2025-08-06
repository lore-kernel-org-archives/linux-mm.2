Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6ED0C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 19:04:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87C2E6B0093; Wed,  6 Aug 2025 15:04:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82C7C6B0095; Wed,  6 Aug 2025 15:04:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 743116B0096; Wed,  6 Aug 2025 15:04:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 659FE6B0093
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:04:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3F52B1DCFD6
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 19:04:54 +0000 (UTC)
X-FDA: 83747259708.20.82BBDA2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8CEE9180006
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 19:04:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kU4kKZwd
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754507092; a=rsa-sha256;
	cv=none;
	b=Phr4YagqtgRlLNklBjv8MCEicQdhOyXqDViFpNu/42eGsDqojrDZ39fe35rP4vZhoyEXYu
	FbPd/LY2y9H1nAZehLjQsu/CleGcXugssdfjE9q1ZxYhhrjqcgVmZnXynyB8CoJBuNxSnj
	s2WBDC86gvhlibWPvioNBtUWdTYJKbY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kU4kKZwd;
	spf=none (imf16.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754507092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q5KGuTr1CbMv6W93SRl257CJWBNfnISVaVBNnkkdcGA=;
	b=RkKQHQ01dDTODoXT4h1icZbGymawhRI5VAf+SISe7Pe9HUw3KFkmHwlEymGHROp/wV628I
	38umxgxwaLOP7mZvUzwg014CrUupySM3PMcH9ehRFlpMbvceBq0pVkO/lwCvvYt3qNg/sn
	2tt+ELunVocvDWuAQfsjodOOX3poUt8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Q5KGuTr1CbMv6W93SRl257CJWBNfnISVaVBNnkkdcGA=; b=kU4kKZwdiyDDYIJ8KsyNE9uu9R
	auyHSdvk9h0/avZJnOKYQ05I7BlZhUd0TORQoQU6ZTjn3Iod95U2rQdCIoV91wdavUVe8nnkV27XH
	7Opy8ZJDqjfU1Ax91oma9h4YT84eTUQ4xrzzGvUFPXGSaWjxXe2zqLrHCpFte8Cp60si7D1II3WRC
	ROgmmfDG0xqUzNZIFepFS+kS8GrWPjyv4nHD1RLt8/M7u6gfu4EzBb0DZAj4fu9+lsWTYisMXmOB4
	tOgMx/d6tppiihlVn4t3HqJ7pqBMo7w9hajgQ6Ut/U8H0Lj5s8x8nL//xIJmr/yz4MtEobDx42VC1
	Zbt26c2Q==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ujjRR-0000000BCQe-1KeS;
	Wed, 06 Aug 2025 19:04:49 +0000
Date: Wed, 6 Aug 2025 20:04:48 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 03/11] mm: Introduce memdesc_nid()
Message-ID: <aJOnUKm_uE-sp1VU@casper.infradead.org>
References: <20250805172307.1302730-1-willy@infradead.org>
 <20250805172307.1302730-4-willy@infradead.org>
 <0EE8EB3C-EF13-4F6D-A1D1-9F840D8C10EC@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0EE8EB3C-EF13-4F6D-A1D1-9F840D8C10EC@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8CEE9180006
X-Stat-Signature: z16gsafue59pofdw9z1p4eaec4wn8uy6
X-HE-Tag: 1754507091-336438
X-HE-Meta: U2FsdGVkX1/We26bO48cn534EAdHqaNa3up1a5uTnQXX6VhJacGwtnAst1utdc9IQBgGJNLxH9As7TIoV7p2Wr3YFn/82IFx9tkn/JcWJADzBz/RY+CPxqyiN6ZIKo9mzsXyw21BVAvoCNJm+jBNAlYsIngufBioYcNgZhYcwuKev6PXw9Kc8OLEUfboZuddhnPd6BKWLSd/cAuAyAUM+CZJDiukAwrIgFMVoSTlvU19pdYj45Mck7W2LfFp2xHEoaYDkxreQdq+SaLzc2VegGHGFT68jiYejtOpN+07UjNx8jJVsh7xIc4ju7qh2ClXoxuk7P41VcPCplfRz7OO2MTFkw2dQ3Lc75Pzm+Bu9qeWS/flVfDrp6UXXWpdTIqnM7WD8rkrxI/vcGBBtPRERc6yqq/1dgax0rZN7smdeXFQzefTADh5SkJR48ICYEc22nsOkuEHW7neHQJy42t8QSz/lgetXFGhR/H9O0FBkNRsxFteFoLyH/+5xdVfqjATZDwBx4WyxjYowAVW89TMfrn2xacA0MmbABG7Q8vs+fcXFEOy0hzKBXqmiXZETQig+RDHkR2PFkY7VWa5Wy4U/99AUWnmfwwLNSmTwM+5XoAMZ8AwwmN3tCaVkTuyeBcbdCgYC78isfWNm/RFT7cod/1K+sglx72D1l6tVwV7XvaQoiFo6Gqb6p6v9POnLhIIXw2cJuHpFLHC5eFkBX6gdfGnJISmb2XvYC4rx0/kYEdWVVGXDa0O3UgpO6qlyizW/hazwoFJ5GOC+FuHw4Mv9H0Zq1tGEirXkHiOi0S7tRCnqbzzHhl6KKogvX214Q2kVRCX0+UKFJhfDu7yOhgabiSIq9g5I0E/C5QT77Tl27GF8pjWOVuht+ypQaEk0goXSq4B8ct33elRuBO6uLH3PkP+qKBysA+pphxY4JaqjbwTefUia3VjLMie1YCB8/QeulvAf7H+rZ+OuTRsgN+
 IgGIsJPe
 OXiuu0p/eTNX4SrllFe0NHuLVZDh6nHPBHMf2dDKf6wFQvrlu/Bf21nUp06wOvJ7OTtjWeVaygkVXYHTH0yqBA+fTGFll4F+ifVzWuqbr7GP2y4N36y+meYj78GSLwy+S0UzHYteMeqNDETiEea8ZqRh7MBnoJKHRbCsrTza89/XlWcxR26IPoAen3XerlI6zSgxDGmtZhvTtAhlYLIpqqD+KeRZRWoHBKdYaqWcyWJwdnh2wUnPPQFzbW+sAXZYl/oJcAjT1XBcf4OJSjnYI5QUKv6U26EUS4CejgH/JGeQSyYyoEdHf831NsZKfg2hku801vBC+eu/jMUKlohT7UzrhrQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 06, 2025 at 02:47:19PM -0400, Zi Yan wrote:
> On 5 Aug 2025, at 13:22, Matthew Wilcox (Oracle) wrote:
> 
> > Remove a conversion from folio to page by passing the folio->flags
> > (which are a copy of the page->flags) to the new memdesc_nid() function.
> >
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > ---
> >  include/linux/mm.h | 21 +++++++++++++--------
> >  mm/sparse.c        |  6 +++---
> >  2 files changed, 16 insertions(+), 11 deletions(-)
> >
> >  }
> > -EXPORT_SYMBOL(page_to_nid);
> > +EXPORT_SYMBOL(memdesc_nid);
> 
> page_to_nid() no longer needs to be exported, since it is a wrapper of
> memdesc_nid() and in mm.h.

That's right.  Did you want some verbiage about that in the commit
message?

> LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks!

