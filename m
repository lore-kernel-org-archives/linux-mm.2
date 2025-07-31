Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E463C87FD2
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 22:04:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D53246B0088; Thu, 31 Jul 2025 18:04:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2B666B0092; Thu, 31 Jul 2025 18:04:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C696D6B009A; Thu, 31 Jul 2025 18:04:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B40F76B0088
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 18:04:19 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 573EA140518
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 22:04:19 +0000 (UTC)
X-FDA: 83725939038.10.F33D655
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6136E20008
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 22:04:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Yru6yr7/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=pyyjason@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753999457; a=rsa-sha256;
	cv=none;
	b=6BkCeGsaYbobcFzESyx3XLQiHzy4A8K/482EXEmiJMI4IKGx3lBlQDn2v48WRj2wPsFdml
	CAeBnrsnT1rtVDTaThIBFr0wbhMXrsXaXDMmA8Fywr1ZhDtmXqbhxKApPv6TGBg5hxILgL
	d55+U1qtZvPSThgPGWB15C4hVVMaWms=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Yru6yr7/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=pyyjason@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753999457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YuVXeYr7FDtql94sM1ldGgDheznzgmdavsiQoAB2NVw=;
	b=zorBWVRkfv2SqzS0KubK2NdBjAufzppptA6+LmcSKxxyMHTnFclzLet5iXGq3aGp24e7p6
	rJexp1uFr4moe3ESjn5EfsItcJEmJXAB+8fRjZ6lEt33zTNSVv+5kQOy0ba0KDpiUIBDem
	EeicJSmyvt6yrqzsZctFJDAhdFmhwPM=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3b785a69454so91636f8f.2
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 15:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753999456; x=1754604256; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YuVXeYr7FDtql94sM1ldGgDheznzgmdavsiQoAB2NVw=;
        b=Yru6yr7/KtnTyvxlWzHPbw34HKuv7mCHtnEXFyvMHzBG3Tp+ST/AlyKibeCEB/3nvm
         nahZELbOGAD/T7LwHX+7mJ4iZHnJk8qsIYPfyO0LQU9vy3qpb3+XXpHKrSVSx3J001O6
         hjizhAGXnZEldphj4cq9FiBJH26D44pYPVkAmEoQVTOPHP8iCoL/wQMiYJfZwSASt92B
         QBsuO3psIM5grk4KjvpYF9MeSjPH3w7SH9VQxd9ns2EKgapx/GsURMBVP8KnpnwWrXFq
         XKfi6zz6kUDsi64n0Nc9/zYG00D60IFLx6Tw3gIMhw4Xn5Bvh2TAAVhgbUSmimjreC/0
         lU5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753999456; x=1754604256;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YuVXeYr7FDtql94sM1ldGgDheznzgmdavsiQoAB2NVw=;
        b=sgHvvO3h54v1hMoOKhoW2rDl+/4SpD+gyATWg2uO+2FLhtbSiBr8PoDZ08767U39+9
         Ei3zkP59/4F9Fm3TlR9Cjo23V8rG6xLuy8aaG003W0U+cMKfrzzE1E4DP62Q1VUzQAbB
         1hkkmpocISWFSKIVdP3drNnBiP06M7Md3pfYg8zJ8BG73Gq7MF+kLsn6xWnwfH8AXKlM
         ds/9n8kpXIMv1knZbni/wsMuK8CBI5cvKt8IQh5R1C3PpNQKcFtEDLLO6OILMYtfI/iF
         vjajSFTEMVa1IN8fVJjgLvlOSxushstyzFgrQCGzhF4i7azodMgefTxOtiq+paclw6eG
         jeHA==
X-Forwarded-Encrypted: i=1; AJvYcCU6wWIwaC77tdljhgeb51QsdDbP2eP7HjsZ2tENpJU825oOuGaY16niifaw5UTWpjCQ6KpIBLvXgQ==@kvack.org
X-Gm-Message-State: AOJu0YzYq0xz7lnP0Mijd40mCuwhRaQbpPLsyBcEZZRVC02hNW7J70um
	HH5B1BV/DH6vjXFuqqFo6W130nEr3KiCmh61YU+rpi+sOHqOA41XVfp8
X-Gm-Gg: ASbGncuGKBi/yftwkP4L7fhJ9kjy415dwSr7m7qPcXAqfJme5zYaL/7g+1CgrexV3U8
	xO9W3jGcExL2FZTirIT/JWswpGYUMZxAeL1MDIHRlFtDhiFpqtlA8/R3D+BJSheAbwTumOz6SZ3
	TjGBkD2cZinim2E+lThwd+bFEJeVWmxXN2POxK/0C3rQbPVAufwQZru5Z+pO9b3lC4wxaLAhfow
	NJsp6mKGnxVwKvy6iQ7Imh6AFwCbEfXYSYNzZLzeLrlsRQvitn7ATMrFV4Dv1+Y+JaU76VLTtDL
	OxNkSYxL+K5xFDxeT1KCbB+sMumC1J/KtjXhcryNFc85ESTy1tZLR+TPeKZvVvaoPeDKM1MmyWi
	KBPVx/Z6Wj3mUGYbW325h+2MVCYd0KeSRvTCvQ+48PSk8a92LKrAFFiPzGbsgFPKPcqCDvTiqTd
	OC0DopW3s=
X-Google-Smtp-Source: AGHT+IHCw7TRuJh2aGg/Nw+v2xuOt+mi8XWdyGvHc40uQSFW40upZ5IOazoX2RAMaX9h6uizaidJkA==
X-Received: by 2002:a05:6000:1a86:b0:3b7:8ddc:87a1 with SMTP id ffacd0b85a97d-3b794fc187emr6918829f8f.4.1753999455654;
        Thu, 31 Jul 2025 15:04:15 -0700 (PDT)
Received: from Yueyangs-MacBook-Pro.local (vpn-254-003.epfl.ch. [128.179.254.3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4588dd77cbbsm67628505e9.2.2025.07.31.15.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 15:04:15 -0700 (PDT)
Date: Thu, 31 Jul 2025 23:04:12 +0100
From: YUEYANG PAN <pyyjason@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>, damon@lists.linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/damon: Move has filter to ops-common
Message-ID: <aIvoXMbW57IL9X1o@Yueyangs-MacBook-Pro.local>
References: <06734aa15198e542f9defbc1d29fc0731671c3d8.1753895066.git.pyyjason@gmail.com>
 <20250730174506.60001-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250730174506.60001-1-sj@kernel.org>
X-Rspamd-Queue-Id: 6136E20008
X-Stat-Signature: zhh8rgbw3xmek35tpnjte9p4qct1amfu
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753999457-177511
X-HE-Meta: U2FsdGVkX1/qyEUS/V64Z66Jk/QULilVs3MI5OpdgQ7257RzwbXu+jRlHe8LOVIXSrNGD4ck9MtcjzVHl4ureRJDIfJXjZHO9Ka2mWZUfjiR9icBGkZ3sDJW98hL8tEmapU88TKTs/DhFtR1o7Vp3D6uN9+0c/yyXRnN85pEUBUnfTSZSyoV4P0GzC7SekPjZ23InA6iywH5vmN3fyY+/ugLfPEzuQ6fOmXSA6xBPP63aI9g+IYW+jPYfycGRwzHbW54cJ6FNwWJhHvnOlqJ7I7nJqtSnCyHtjHVXUEuvDD/O6TNLnZSTHV05nDAchcLxTdzuifvsHJMUmtOj2XlmVGWgp1bbkmxnHE8lRkWHZoynm66yNlqT3OS+phoAdObNTKi+0Ux8bH3BZ+LBrSvK0e8zcxK2J4a3yt4Wi86i0ThqUAP2SQSW8+pobdRXcBUgMtgPE7UKD68YEsT8+Hm92ghRWnGbS4ArAaJk1iF/wBpq3dr2GxtWE950KMu8gnCGrXkhepqkzAxHZQK+HiDLssH4LjGowuy0u4Q5KXj7vpy2fOzjj1MkQAykC0AcSUpYmtj5QNIo/b47h9kQAdjw3OI+QzIkkEkmgY1sQU0gvO3cL//AlBiEhxQKYATMSasDS/ekfYTQH6UO2EAaS9d/xEl7Mk3t4/AEDADq9iz2Ym5DcvepGouCl6Lql0Z+9zDUraIFDFnDqQI7nsfCKQqGHRhw3HlGxWR+MR8A9c0o/JW6F5iZOFZtrdCH/P5LYHpaKlhGImyHjUWMbhXFILVEJb1HhsYgEEJqKfJT9uAF0BDExU2xLapsZjLC+Mee8eY89rWftmB1J06/9s1zCLZGLFZDARc5ogal/MaWyf5KAwo6IbA+ChtJcZFnqvsRxtqMXW0BoaVTi2C5Dh+9eG0s5HaoT6nYbiyIEg4JSWP5APcVKEWNWaNa/qDb6h/XezHLUn5E53EdqUhMdH7u/h
 vhoyN2sq
 +t1uqXZuYWcSGr4xwqVFv+3US/o/ErMjO4l0F50P8TVKIZyiRN76OvQGuNWQEo91dm94Km0mA5Cq+tn8N0VCpCGIQnHUdNWCAPKU4/78NbKcxJGQMo8+VYBeT2uP+hiZikH+OFpfq+p0bBawQfXUrtwS4RjUKvKiQDtWP1rogb8/stD2nZy8nF09LbxtdBYZms557mc7sy+DHEPOU+ujPie4aXLsodRZqwG6CkPeWhkf7AFNJ5UH3CYfjPBbvBZxorsrlis6AI9aYglsEmjEnWh4b+qdLzwjPEsfLJbXqlFEvsOAE2ghpI2FmDHBJEdCUGwbujRXqpcGGQcmW5XM29xYifIoZz2uKxTOzsZKOlN7P20PK5H2DZoP0WHDOJEFZC5jN/PQsY+V5vlEo2hYtzsga35PKzGlRG4u1gQTh7Rj1VXa6YxsBm5MP9BH6rDzZ46Gb52pdkwqJWcc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 30, 2025 at 10:45:06AM -0700, SeongJae Park wrote:
> On Wed, 30 Jul 2025 10:19:55 -0700 Yueyang Pan <pyyjason@gmail.com> wrote:
> 
> > This patch moves damon_pa_scheme_has_filter to ops-common. renaming
> > to damon_scheme_has_filter.
> > Doing so allows us to reuse its logic in the vaddr version
> > of DAMOS_STAT
> > 
> > Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
> > ---
> >  mm/damon/ops-common.c |  9 +++++++++
> >  mm/damon/ops-common.h |  2 ++
> >  mm/damon/paddr.c      | 11 +----------
> >  3 files changed, 12 insertions(+), 10 deletions(-)
> > 
> > diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
> > index 99321ff5cb92..3ebfa356ca46 100644
> > --- a/mm/damon/ops-common.c
> > +++ b/mm/damon/ops-common.c
> > @@ -412,3 +412,12 @@ unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid)
> >  
> >  	return nr_migrated;
> >  }
> > +
> > +bool damon_scheme_has_filter(struct damos *s)
> > +{
> > +	struct damos_filter *f;
> > +
> > +	damos_for_each_ops_filter(f, s)
> > +		return true;
> > +	return false;
> > +}
> 
> I should have tell this earlier, sorry.  I now think it would be good to have
> ops-common.c own prefix, since this namee makes me expect the function is on
> DAMON core layer.  Also, I use normal 'grep' and ctags at the best, and maybe
> I'm not the only one that that lazy at learning new tools.
> 
> Following the weird and none-public naming convention we have on DAMON,
> damos_ops_ for DAMOS-related functions and damon_ops_ for monitoring-related
> functions would be the prefix for ops-common.c.
> 
> So, what about renaming this to damos_ops_has_filter() if we have a chance to
> revision this once again?

Thanks. I will fix it in the next version.

> 
> > diff --git a/mm/damon/ops-common.h b/mm/damon/ops-common.h
> > index 61ad54aaf256..8d5c5c7631ac 100644
> > --- a/mm/damon/ops-common.h
> > +++ b/mm/damon/ops-common.h
> > @@ -21,3 +21,5 @@ int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
> >  
> >  bool damos_folio_filter_match(struct damos_filter *filter, struct folio *folio);
> >  unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid);
> > +
> > +bool damon_scheme_has_filter(struct damos *s);
> > diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> > index 53a55c5114fb..daeceed981a0 100644
> > --- a/mm/damon/paddr.c
> > +++ b/mm/damon/paddr.c
> > @@ -262,22 +262,13 @@ static unsigned long damon_pa_migrate(struct damon_region *r, struct damos *s,
> >  	return applied * PAGE_SIZE;
> >  }
> >  
> > -static bool damon_pa_scheme_has_filter(struct damos *s)
> > -{
> > -	struct damos_filter *f;
> > -
> > -	damos_for_each_ops_filter(f, s)
> > -		return true;
> > -	return false;
> > -}
> > -
> >  static unsigned long damon_pa_stat(struct damon_region *r, struct damos *s,
> >  		unsigned long *sz_filter_passed)
> >  {
> >  	unsigned long addr;
> >  	struct folio *folio;
> >  
> > -	if (!damon_pa_scheme_has_filter(s))
> > +	if (!damon_scheme_has_filter(s))
> >  		return 0;
> >  
> >  	addr = r->ar.start;
> > -- 
> > 2.47.3
> 
> Otherwise, all looks good to me.
> 
> 
> Thanks,
> SJ

Best Wishes
Pan

