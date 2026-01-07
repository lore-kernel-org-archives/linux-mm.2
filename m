Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E490CF6BED
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 05:38:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A166D6B0092; Wed,  7 Jan 2026 00:38:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99A3A6B0093; Wed,  7 Jan 2026 00:38:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87B946B0095; Wed,  7 Jan 2026 00:38:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7635F6B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 00:38:45 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 21CB4137DDB
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 05:38:45 +0000 (UTC)
X-FDA: 84304063410.30.752596D
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3748C1A0004
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 05:38:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=iZQcobHV;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf19.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767764323; a=rsa-sha256;
	cv=none;
	b=BwVxKJ8H1GfVU6GBT3PDPA+olvHnCXZy0ZJ07UZJw09vcv+PRBLf1QmaY/sMRJF6QJErNN
	Y9eBz/x2bT3mhQir/ajhSA/gyK8wK5DyEFK9mFH9ilBqVNq0GfiBkrXmWkBFUNiaWBbP0u
	cfYiI4+HButxvugFpELAKrGXDZ4a1C8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=iZQcobHV;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf19.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767764323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oQPq4dNJwxRb95saNeygoaZ8gFcR1vkqOSFcxL/Ow/8=;
	b=H4t+xeAOTrKFhmFbl7WE6t0o9LTQrej0vDJX7F/z+VX1kUncoZXyk/pj4viIpIoV1yEW+d
	y9LInOil6AEvy/f+Gp5GPZjkm+hI4nUzsnkfYt8eV8JIY5wvSVR7y3wSiFYRlYItcltYUY
	DbElVpTi+jlirgQx4eh0GOMRzvvFdS4=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7b9387df58cso2123787b3a.3
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 21:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1767764322; x=1768369122; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oQPq4dNJwxRb95saNeygoaZ8gFcR1vkqOSFcxL/Ow/8=;
        b=iZQcobHV9Qv6CbQI0OtAFL90lKsJ4UR4e84/XGlag3BAivNEQcAXjgEqMLs8Pw05OP
         WIk3VSyteZXbvq34LIrMLjzcl3CV9hqWdvzaA45LOVUKsHHVQPaAN+FUfChJ+v77xJ3j
         YWnqsAGBa4e2+L0ZMh1RDeNK6VVm7jjZq5kDE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767764322; x=1768369122;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oQPq4dNJwxRb95saNeygoaZ8gFcR1vkqOSFcxL/Ow/8=;
        b=fP4RSLvjgg+GTlZcCT0oXIA1AyrWht2zZLRPc/R+4hZDCfKS9Rldv3IE6ZuDPlQP+d
         4uIvt75yOqM4PfuFWAa6lNuxXndW2v2Ung1HCx307+jkvvtFdsxZV40hWBjXeqcH9UgI
         UdJkEBCVBzGRRa7odW1DUObaKRzWiQuugs7myIKruOnVKTVOMiPZZ88cxb05rOrx94ix
         4sp/X4cH9UFcH4kQpYhVmv4xG/4KhcDLxNVhzOgK4xwepUvJHb2u4O/Jll8SMYEhf4EK
         z30UE3HfyY2GGQX4Y58eYIioGJZIhTpftoI+xWU3rNP3RvUPBMb+8xB8H1wpZz8LZbRx
         GDEw==
X-Forwarded-Encrypted: i=1; AJvYcCVKoNVJEC9rgUp7gkvB3EvGFcUacSyyfT3626UhEZR1/OAPASwz8l+L+yIzKSrcZ+H5AjY5NwV+oQ==@kvack.org
X-Gm-Message-State: AOJu0YyVNmzpCKTsqjjAZUPYdl4APGci8fr3bKLLBJvcvyVZffcfBp7j
	CLAZPEcTExKirnlt3T2dEYBkow6F/JPbo1W33syFsfQyG6/2K1HcyWASh9+4Sc3tTg==
X-Gm-Gg: AY/fxX790eUO42KnW3QKHs1Ht3LEb+DaO+mECVbE6AeHqNwg29Ix9UkMXnUv+1V3wIZ
	0hVMvWrQeEcq2bScfMcY29I/k0in0bKxmJn6LZXGSmxLM18VBz4f0BK4EUBWmIy//4YLgRlDG1c
	tFUo5KqmYtdn6dOZ2hqGoobGK9kXxEaCoHe3mvtiLK3iskTBRMLR3/hu9HD9zlmv8xxovqsCYnd
	w00K3uHczRVdApuhdXskqWwygllqs6A5M/FQSF9vKdP+tQirijYDfzCzxcJ6vDqv2Ctyp+SSPAl
	2lPA+R117fTxUvHPT45FtoKmD+1OLBCRtE6cp/jzT6LUADYooNw72tHzYAb90JUEA8wSYdPPtxS
	YqNSLDD6hqK8UhDulAzzMmvtSZaUa3uoVRQXefdza7cVV8utf3If1im69hyhBg8zvj1muDFX88y
	0vDexuBsh1L2b+Tl1NCbUZnKtCN5JyjvsSrj7MvdlX1HHKNliJVpY=
X-Google-Smtp-Source: AGHT+IH36QHeZRJf03jTkhGbbb56PW6HvZEir1R4xQf1nA4piFwCu54+lXS4X1nyTNlfTxOsowdOrw==
X-Received: by 2002:a05:6a00:4390:b0:7f7:5378:da2c with SMTP id d2e1a72fcca58-81b7de5d83bmr1467242b3a.25.1767764322086;
        Tue, 06 Jan 2026 21:38:42 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:9f6a:2617:8891:93ff])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-819bb0ddf97sm3655738b3a.19.2026.01.06.21.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 21:38:41 -0800 (PST)
Date: Wed, 7 Jan 2026 14:38:36 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH] zsmalloc: use actual object size to detect spans
Message-ID: <3tiwggkz53gkl3ysemobzny5ymvjzn7ssfxbevae6ptpfbdzph@riv2id277ctm>
References: <20260106042507.2579150-1-senozhatsky@chromium.org>
 <qh2p3k5c2ulb5g2zmckhrm4o2eoruatb5lnumkrwrvmsxwcn3s@nh5vx4kjn5in>
 <og2yztajena3ywyvus6xgc5vlrrecjaynyezygpsrt64kjkqlv@agceajv57eet>
 <vkhwvmazwys7dz7m67fil7xlhevdsc4xbvq3h6nknb7rqojjis@vx2c57ylvl44>
 <ofjlah554fgcc43e66djtysmnagd7gduqutueyauipovs35qb7@mw7keptebqau>
 <5smqbald5bollibqjsvqw2tfngdoiiucurikdgqtz6xjb7u7vz@7p6hskoixaak>
 <lupjar4x2wz25knuntywor5oyx3ksyhh7g7yv4apmztn47ayep@sncrwg4gjlut>
 <3xsreqvvclcuqyllgdz5avxwdvhc3rqri4565xj2hbwk6r6uol@6mnhvdgaxfrl>
 <mumv2eouuqepj5btx4jeghevlleucdslt76erxtt4sm5ntavx5@oipdwrdhzlta>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mumv2eouuqepj5btx4jeghevlleucdslt76erxtt4sm5ntavx5@oipdwrdhzlta>
X-Rspamd-Queue-Id: 3748C1A0004
X-Stat-Signature: ijtb3u8wetp9c75yiwkgrh7ug4jehs3f
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767764323-777200
X-HE-Meta: U2FsdGVkX1+xCzdVolzkMs5eKLs1AXzIc4XjimUWuCz+qMskZh8uybt8EqSekeCoqkRMymmL+Ztw2l2bcEvIsN64p7EVxacl5YbjQdUIzOZFplRpj4jBKJBa1utyxSXo9i4iqrH2Rc6bG4/1b2sh6d9u/eJ9aOG6uW8NMx0zj+zul+AMbnpZlaVY4Trme6x4h42tEMWEWQJGMbZ3MjjcL6oXjFKeker96Qu3XcohkJwiIyeSztSK8eExM8s7HNA+8f/NcUHG/8B6gV/WVhMtSbsrRFDOMwF4vSLijM4gbxRUFqALo3kGHKqhrJdQD/wJQrNt2LEkd5GoI9twFrly1956GIQbwQ2bxmmRb1M2hPqzlil6k0lhO0wKw+fj3d/iKSN9Dgs06w4l3Z4o2eu1Yv4+Ru9LisH1SgiPz6hq4kI5kEH/bRpoBv6cOOiAyon8LEdcZVlnmZs5apO0wTuqRdJW0htpB85yb5qFEv+Z9tmX+b/fRN+eTu0+oq8AcHtvUVbt874RfUBf+fF8/dYx5K9HTgq3Qr6YTLZMg/a90pws0K62rsfXoPfmVnHwimpmd+7URs++5rn2iVOFys1NxnaCADLctEeEBNs3dgEbzKxZQX0UUB0r0ap+CJvFVYlkTHyXzyxtb0zKzJIPqpP1f75kvfCrdq5V6Xc/KIyvvFI0UPEBlr5tMGM0PsPftJuxRxYWRlGRJaST2Xv+qmtLLS0AfPnjH6bMC6Qq1xVVKYFSBShX/6GKylqH+/gLSK5SQWO8TrZCLx0Oj2q8rUfEJmyRaTUqn8sNKnFoI0R6FnJvw4RTMmVWsxKAJ+vUqUdvEn22yft9M3+Q6VhnTPWqolnfZuacjH7bcPzEOWC0iKVOkodzhIPaAphvx/nPHjqrqmqhjVJLmBYf6SCxzjoZJLQPyn1Fz1dMXlUxCv6N/SnndEXVQouQMAmjkKDrbKx7+PffvSXpWeBsPlw+zp1
 G8gwMHUu
 T01KJjktY90DXvKTcolvULBCZff/0zrf73QJ1ouyoppTnZKivWF1wa4VpBwNciD80ex9ds3G+DZ7L5gaIpb2O9TI8+PjwFXUjrrhONALRkls6R4jeomMajRvW839GbGNyTEwfZ/a8h8xxbFTCESPsj57iYj1j83jFYyEEdDjCMFSUpC/rjr4C7w7Qsbl6wnYEeQoTCvlB8Ask2QjyTfFA/9W8Qk+WLcFbWIFX+Bldj3YJ0IMa7wxjY2bowmj89yHE9PjE66scqqobgWdiNFwA7q5QSEo1O4KBuc4RSnmBs4ymga3MIlhOixya3S5AM4nu793z/jGHxs+Y4fXB9l5UVMoiR5aAQTL2GXgjcOu1PT8n3eI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/07 05:22), Yosry Ahmed wrote:
> On Wed, Jan 07, 2026 at 12:03:37PM +0900, Sergey Senozhatsky wrote:
> > On (26/01/07 02:10), Yosry Ahmed wrote:
> > > I think the changes need to be shuffled around to avoid this, or just
> > > have a combined patch, which would be less pretty.
> > 
> > Dunno.  Do we want to completely separate HugePage handling
> > and make it a fast path?  Then it seems things begin to work.
> 
> HugePage should always be PAGE_SIZE, so never spans two pages, right?

Right

  if (unlikely(class->objs_per_zspage == 1 && class->pages_per_zspage == 1))
      SetZsHugePage(zspage);

> I like separating the logic because it's cleaner, but I want us to
> understand the problem first (see my other reply) instead of just
> papering over it.

Sure.

> > diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> > index cb449acc8809..9b067853b6c2 100644
> > --- a/mm/zsmalloc.c
> > +++ b/mm/zsmalloc.c
> > @@ -1077,6 +1077,7 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
> >         unsigned long obj, off;
> >         unsigned int obj_idx;
> >         struct size_class *class;
> > +       size_t sizes[2];
> >         void *addr;
> >  
> >         /* Guarantee we can get zspage from handle safely */
> > @@ -1089,35 +1090,27 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
> >         zspage_read_lock(zspage);
> >         read_unlock(&pool->lock);
> >  
> > +       /* Fast path for huge size class */
> > +       if (ZsHugePage(zspage))
> > +               return kmap_local_zpdesc(zpdesc);
> 
> Can we WARN here if somehow the HugePage is spanning two pages?

I can add a WARN, but that really cannot happen.  We always allocate just
one physical page per zspage for such size classes.

