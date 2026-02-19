Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD9C5E9A03B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 07:57:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFA456B0088; Thu, 19 Feb 2026 02:57:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA7586B0089; Thu, 19 Feb 2026 02:57:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7C9D6B008A; Thu, 19 Feb 2026 02:57:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B264D6B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 02:57:10 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6AF92160473
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:57:10 +0000 (UTC)
X-FDA: 84460450620.27.23BD7CE
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8045C1C0006
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:57:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=T5RPnuw5;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf21.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.49 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771487828; a=rsa-sha256;
	cv=none;
	b=W4Lh7R24ccJ4UgHWn4hv6zyDsdqw11WCTTOZIiqrVHglTIpCgwq/hodbIVQnivx4PlqaYk
	4ELjMn6ePR06UMmRAN7t3O0qi78CH7/qycV2RoR0kfEKWGgm1jCYHZudMFoiOlNtfZSB7D
	fO4vYts0FoypB9COL3yhJAcDMApw5lU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=T5RPnuw5;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf21.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.49 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771487828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ee6rz3n4lRLIfzQydkYiBi8fGnwsN3AAWbuDK39dnaE=;
	b=t93TZRukRT8SP9uXURn/cnmE1QEymQhT0J0SARnTAyyCap5+wjSZlRAngQBS0qtpkGeX0g
	fkbDAPJr5dUiMkex7zL0+GZnXSmS6gmfnR0Pi5IGCnrsy4xPK7aIfpf86tseyC2rr2PCvC
	nKHU2KCeBVaMSo9vmIFDXox/4YZZeKk=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4806f3fc50bso7511445e9.0
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 23:57:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771487827; x=1772092627; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ee6rz3n4lRLIfzQydkYiBi8fGnwsN3AAWbuDK39dnaE=;
        b=T5RPnuw5Ml0s94iiK9hjYg32YIwt2stb5Oks2FpgcCSDRVX0eaNtxFDGna22OOgjEr
         845LRfdxX98B6DuuRfUw2XSFKscRKkGHzo5Dc4DVETa8Ptei87pO0PDII/p+mvUNEII7
         HfORBwU86TjzAlaDr15zMyN0E34UvMA0y0hlUVbAmsCAdev5CADQYCEiG+xx5yx6OXMD
         S2Dey/qKGfSG2Ap9M/HGHMJR4/xSoTxukZjQE2mwJLrl8QPT4NgUNm9ssVP0s06yfg/N
         6dZVu5ukB99ecobGUTsvuMRVSrFYPo+76x/8RuSWrbjPlomPtuPMmPK4Tg+dTsxH84cm
         uxfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771487827; x=1772092627;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ee6rz3n4lRLIfzQydkYiBi8fGnwsN3AAWbuDK39dnaE=;
        b=aXKS5RyzsHfE5fU8OsmTczySfbss1JmL/NcOYIM0jnkalVKZBoW1kzInKbLGgQKlq8
         vJkzSx9qGPOcL/mDRL9Xy41/IHUt7nQFmpXtl3EqOoBlSX1Wi8/m2YWCu0hsKmVaFYuM
         Qt+AN+coS3HtkuRD9OjsIrYDSoATX60HPuX35+8N2R9tW+TM/idiYIGWllJYMmR5WUFS
         hm4FMG9ZMtzDFEoUjI+GbZw/3Ym4R2+LvbKy4D1rvunvkgRblFAoIFh9Py0ede/gWBmC
         +MtO6GGXdCuPIzBlMparNNxI52SuQmzPCpoiJPHiftxCI/BR6fP2pEdC54YNnvrVKkXU
         A0Dg==
X-Forwarded-Encrypted: i=1; AJvYcCUQScC0tZFcCQWDHbYzZEvzCRlQMW3OkT/HLuJvNeEQfFSHqPVUFfdnVw1woPlQVpY/I7A3qi61jA==@kvack.org
X-Gm-Message-State: AOJu0YyfFsoAARPUFGrW2yrVAyl7kZNa9VyIOQlGxEqAHFRV7MnhzhsS
	zM0s1TFNT5V7O0eT4CPIRQpl9nwjKA0OTCVeRCOWRuTb//KS03GId4lz/VL3+S3xGtg=
X-Gm-Gg: AZuq6aLqeci+etQOZVxB72lmToEPe8Ka3ncMYT03oT9+tSq2LP8s8+oNLPs96oMz8A2
	IQaj85HJ7RQNvBstZr5BwQ5ssvZQ5lPD5XaaQpUVPRJg1qErvWxvWk0HeqS8slP/5KMZlIoc/+p
	56mPeb5sZEyrxa/HX2kOfBsfYIhcJy4ve4VZp2JrsmTXxpQpzQPN6Yi0pRobQsQ3hHKlBx+74Uh
	/a14CfX9KGRGxqaVoLdbH3y50s/zXHfke6408rTYpW5+herjJilGXK2Kid8gRIEeozpIaTfEy9c
	fuaNzl9yMziQpzKOwIpDAslhWSCnKmQMJ+SpunvxDT38ypjLHmDMBKzzMIgVldFcpTTWFWGenkC
	PRT4cgB96Ffe1P0rRJW+wMFSEQyorkJGhhe+oOpAmyc0aFEO5Do1PbJd+wh2dgegh9N9Bo5kk6y
	OjdMvoOpQeZVsIP13IibNitKEsZGaM
X-Received: by 2002:a05:600c:698c:b0:477:5ad9:6df1 with SMTP id 5b1f17b1804b1-48379b932b7mr310004635e9.3.1771487826769;
        Wed, 18 Feb 2026 23:57:06 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4839f96967bsm15143135e9.3.2026.02.18.23.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 23:57:06 -0800 (PST)
Date: Thu, 19 Feb 2026 10:57:03 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, Jann Horn <jannh@google.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Marco Elver <elver@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>, Joe Perches <joe@perches.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Jakub Kicinski <kuba@kernel.org>,
	Yafang Shao <laoar.shao@gmail.com>,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Alexander Potapenko <glider@google.com>,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	linux-doc@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH v6 1/5] slab: Introduce kmalloc_obj() and family
Message-ID: <aZbCT3-q3O4M5osr@stanley.mountain>
References: <20251203233029.it.641-kees@kernel.org>
 <20251203233036.3212363-1-kees@kernel.org>
 <960729bb-0746-4709-a40c-2e254f963deb@suse.cz>
 <202601090928.5CFF95F@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202601090928.5CFF95F@keescook>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8045C1C0006
X-Stat-Signature: 5agkfcm8w9jmu5uu4w5gwi5c5m8dkaz9
X-HE-Tag: 1771487828-495536
X-HE-Meta: U2FsdGVkX18hm8Rnz5hpVf21QuZlrMGvkPEPO0F4wmEDPnVptW2ydPDQY74UoY5PHv6zauRtpHIihWcdHLc6Uwyp0ZbUHEEf3YQ0ZEZO/nKBzwX9gMGd6HRPR1LmJywb4jXZq37Y9YQt3dS7b5rSAscBFuo3joS1z4GR1Tbd9v/KLbifFCLQro4weR6JkI+/vIOsSekqf0UlNe9ytUF3ap/QI3nCIgknOWAbjIDow6VXbi5YgbG2Tn8+Yfy2nMpzwigvArsX7xzRUjI1/H/RnLqCUX44U7lOOeFdqKiHhQDdLmvBLf7I9ypy7HMTenL2yembvH9AjtHEOOGx+TV9m4jwRr/LeF2A0smgxPvGTbPV75fE8qwE4Gp7z1bFOvL7evvkWiKz33omq0g6CJS8kGkGhWPsULfKFJAY50e5Se9zGFQZaz3e3Co4BND0HZdYIEum0OTr1vGvvpZpnU9czrzWDng2uiQVZLut0+iXHOg0BLaEVyUNqNmLM7JKlt/bOR1KWVvDAFfjv2GKt/L7lGuN1hriMDK41gCFqKZnlfMglnfv+dv9iINO+HLm9l2wGYVYofUJ4ORHKIYud8VxYrJW333xv9QF6lrTO4VLoMVYvxIvEAINovhvmuo3xV5xNiJJUya4sTqC/vMyKDvAnE0ULTGTTeSUJvJT5hwelASDRVwUtPhulo9Ah6Fg+AIfPhrXnyAqGAMvZBJMhLzn65JLf+Okljpbko+a4QVACIkHDY4tY2Ijs7ALGmD1gzFmA0SFSIuIqVXLCW0asjVaW4lEQ8pKtKFdUwjl6RyyLEqvWHwDk0DCKYVDmo71m1y0INUqF5pVGbF8xnVYz7e+1RWBtUWSulHm3kz7wjR3unZv5Qj28dW3JFhZK91BCgfKm8ivSOCZ3TmiYNALft7kNL7I5o60foTNzW5hf9RWrlKocnmjIqkF70lwJNoGkWLBpN/Og/6AfU3MUOY7AvH
 7Xizw5u4
 EtHdhnfJ64jp+02vMf7a0tPkR8ofa5BQ/3EszVfFVWifzuXqtkWLy5jZUqgiGZMtcqhv/fDDNotyVQrC1w7HeQeIDX6z9/GdG/a7PkKY2/+6LPYZHszF4A+T49PYuDicouxde1Et4q/RTzxRAVp6ditLazQCEGrqHllPj31xdgYX36Srl+Q9iSakJcyzgN22eXy2LY6uZrC3l7T1dnmep4fBJDD6G6CPDqzRavvYrCk/x3J626peuY7IspiDeTtpQPXiDmzEdaJU6CRgOl9h0MNKfAVBpiTEmJbMQorACmGhog97di0tYPpzibPdQyw32uzy70Sxw9EQxCq8qnZXJfUaqasPuJkOSiy9bYJvH+MpW8WalleGOq4KaP/vBpAUEn/au9Y7ME1rhTsnmvi4D2Xnk9GAsllL+YlBby40Gyn0P0RYKafcNCTQH07bCtuoG2UpG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 09:31:03AM -0800, Kees Cook wrote:
> On Thu, Jan 08, 2026 at 03:01:00PM +0100, Vlastimil Babka wrote:
> > On 12/4/25 00:30, Kees Cook wrote:
> > > [...]
> > > +/**
> > > + * __alloc_objs - Allocate objects of a given type using
> > > + * @KMALLOC: which size-based kmalloc wrapper to allocate with.
> > > + * @GFP: GFP flags for the allocation.
> > > + * @TYPE: type to allocate space for.
> > > + * @COUNT: how many @TYPE objects to allocate.
> > > + *
> > > + * Returns: Newly allocated pointer to (first) @TYPE of @COUNT-many
> > > + * allocated @TYPE objects, or NULL on failure.
> > > + */
> > > +#define __alloc_objs(KMALLOC, GFP, TYPE, COUNT)				\
> > > +({									\
> > > +	const size_t __obj_size = size_mul(sizeof(TYPE), COUNT);	\
> > 
> > I assume with the hardcoded 1 for COUNT, this size_mul() will be eliminated
> > by the compiler and not add unnecessary runtime overhead? Otherwise we
> > should have two core #define variants.
> 
> You're correct: the compiler completely collapses it with 0 runtime
> overhead; a variant is not needed.
> 
> > I also noted that the existing kmalloc_array() and kvmalloc_array() do
> > check_mul_overflow() and return NULL silently on overflow. This AFAIU will
> > make SIZE_MAX passed to the underlying kmalloc/kvmalloc and thus will cause
> > a warning. That's IMHO a good thing.
> 
> Right -- I prefer seeing the SIZE_MAX yelling from the allocator. Should
> we change how k*malloc_array() behaves?

Huh, yeah, it's weird to not get a stack trace if kmalloc() fails.  On
the other hand, if we're allocating SIZE_MAX, that is probably a user
controlled size.  Since we don't want people spamming dmesg, it should
probably be WARN_ONCE().

regards,
dan carpenter


