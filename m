Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26445CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 13:42:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 671138E0034; Wed, 15 Oct 2025 09:42:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6485C8E0015; Wed, 15 Oct 2025 09:42:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 584EF8E0034; Wed, 15 Oct 2025 09:42:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4894C8E0015
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:42:57 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 03DF1B6874
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:42:56 +0000 (UTC)
X-FDA: 84000464394.13.9CA7AF8
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf30.hostedemail.com (Postfix) with ESMTP id D891480018
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:42:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SaFHUq+3;
	spf=pass (imf30.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760535775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/4BAAdWpTo7kdkSn1s2ZaiJLRC7v+maKfFZOfYvdC5U=;
	b=aUb+48HI3ufoSDZntPgKXtZpOmCUbvuzydARUJsmI3MdEY2jYABCWkCSLGhWgEfCv402f1
	pBLFs8tIs4cPorYfLc3f9RMtwxCy6SKQntj9zCwN6aHqYwFv8D/hzl08FNDqqLE0SB0Q0c
	dV0BDpWaPDwlt6/s55NHHsSAKrlRJ/0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SaFHUq+3;
	spf=pass (imf30.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760535775; a=rsa-sha256;
	cv=none;
	b=0afTF+7V4Zgqmli9oTew3odWdLYikrI05jDWIcQNGtzTR1uTzIOOC9Fu945SVs0CfPRQMO
	LrqG/ny7K0/ABxufGPLZsF4KiY75dn9ORRIBf0tlSUWeHL+AtBcfAFz0XHRCDVogU4Dx1F
	j68MtFmmsqweZm8t+YYbs/6UloJXMkY=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-57bb7ee3142so7235980e87.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760535773; x=1761140573; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/4BAAdWpTo7kdkSn1s2ZaiJLRC7v+maKfFZOfYvdC5U=;
        b=SaFHUq+3QSeS40Li2hNkbU0XtoRmqpDeNZna0w2CiFlvnYCZiyzTOVZjTK8hLQO0/i
         bqk6/ApmebICNraQknu9o2NVznvhzlaO9QXIKQ18zhYUNaG7emlW9/9y3kX/sy0X3Ha+
         qjWvHsknH+5WkaIDFpCEi2nbM6JIvAEXbamuJRUU7cuFtypyYv2JdJPG/QD8jMuXK2ad
         s1BVic9YXhrwo1cEPBGl10uE1WOK70h0D3t2fCxhOJ1hidG4xmYx7UxIjyyr1JTIPx5n
         qKZN3Az6qHhlfeFpypcltyHmVYBmrdKsRop3H3lnTuqfEMA8iql/TiHcX4ks1T30JNaU
         710w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760535773; x=1761140573;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/4BAAdWpTo7kdkSn1s2ZaiJLRC7v+maKfFZOfYvdC5U=;
        b=BuhNU9RSS4V4Ly5FU9DeK+FJVIjGMDp7k8cvdVjtOEidrgZhX+I6tBuBdZTz+7MWAx
         HJc84vOQWj0BtLoX/hYpllylP4A2SUDbCDpQZEgI0KHL97EmTxYFR0OGNv6k5Y7i2+3y
         zGHwWFz1OgrbxBnr1zU9cXtiYkFjpvwvlLJtwG4Ze0asANkprx7J503B+WJFPohHxD5M
         4mufIl3/KSdxXyFG2ueOAgsNFq0Il6KmHFcUyUFlqmdq3BLEF6JHyurHc+SSHZy+T1ov
         wQXcqeOZKoY33mrVweHTTsnrRA0acOjrUkiFhi0aUXcYL1bkebRaXpnBlt64m+BflwOv
         ugJg==
X-Forwarded-Encrypted: i=1; AJvYcCWbHF4McwWBIe23dLsaG975EhzpblkUUOWLiLz/1lrs1XtPXFwaiwWNnN473xWn31O8pHnYM96gSQ==@kvack.org
X-Gm-Message-State: AOJu0YwgcMrqrxrD4L1tNXSJODJ+1IcodXDoLYln0pyp95DAThUC++q6
	pBSZPv4Ldqm9Ox3Sx1oMkip3xK88qCMZkFcilKjb0gFWekHuVxFCzqox
X-Gm-Gg: ASbGnctbIiA2wADojDkj4xxUqfqC8TflKqmfE+1EqEQg/PSpGdzjTHjroHjccLyxyxY
	dl8Lk250yuVj4dTv5c+KWur2H1by/8AJ3u28HlUh2cST/Cj6Rxnj286c4QHWaVENXqCkwQBmbQZ
	BxXOcyxM/j0PPbqnIZeSgk2Z8Q7fnodAWkdRA3tdg8GP9YriHTh6VYTm+xueVToxnVWcPTH2vgr
	f1f0k5drE3780z7uQ5pOaAI9CmFldGAHwuSN8TPF4OE4dH/Dh2c47sxvPr7HxkooqFbNOcJ28I7
	KezCjN56sk1pJ5qL/kYKGmdWBMkcpC6xu2VIRuXo6owY4yUfZNlwpgS10KwJeCoeP4Nujqztjgq
	rM33Kah17
X-Google-Smtp-Source: AGHT+IE4CBzGf+pfUMzaLmENf0m0ABzFMayERas37FKG/vTFO9UrtjuBcJdv1VdnwKssMMa2kCUO9A==
X-Received: by 2002:a05:6512:3ca6:b0:56b:f8b9:fbdc with SMTP id 2adb3069b0e04-5906dc183acmr7954235e87.25.1760535772616;
        Wed, 15 Oct 2025 06:42:52 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-590881e4e21sm6221048e87.2.2025.10.15.06.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 06:42:52 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 15 Oct 2025 15:42:50 +0200
To: Matthew Wilcox <willy@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] mm/vmalloc: request large order pages from buddy
 allocator
Message-ID: <aO-k2hBimow9oYuR@milan>
References: <20251014182754.4329-1-vishal.moola@gmail.com>
 <aO9Z90vphRcyFv2n@milan>
 <aO97BjvNZNh0UV3u@fedora>
 <aO-Wxj7al7I-IadV@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aO-Wxj7al7I-IadV@casper.infradead.org>
X-Rspamd-Queue-Id: D891480018
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: uqgafs9bb49dy8ypfahpidtsu5ei1ixp
X-HE-Tag: 1760535774-553214
X-HE-Meta: U2FsdGVkX1+OWZmNV/rzKLKX02l8qqfh6G3xSaFhwAA6jPnEZYto79XPgGlKF0E5wQ6M3vohLuy37srrfBPcIuXUVyYDwCDtqJEF2/KMxbGtP+Yvvfmb4PDhPdkbk0+noC5bxAvZtBKG5b0WDWiIpMDCsPNQQh43t3BRU8qLRpF4P9UPqRqt/V5pLfibbXtUTsxKPWklI2g8oRZS1vRQEp0UMKP8qilOS3rrpJwb2WQcouV1ApWBILF783UyJH0k+FVW6kxUOfWD33gtjHfJTmgJZGM6Va38NUXDXYcNwrOkEh1E5xCz0l4iRzBE27yieq+/CXfaVR9Yq7WZgD0X/p+KitvDWnqq20v7nET8dRLPK4OTWwW5TyT6/fWw7WY6kj1IEZGA8EBVM8KXfnUxXW4DRvYFDIRrrx+otyG1cWGmCqXFWrJudz+mT8QjSbNZ9lGWNf9B1wE+DTASK/Q/FSaEfyrNxbVJMavGEqILsUfzT4sHK9wFDPT1K8K2UTMX515Rknbfnz+8vrITOK1y1nlKgCj7K1zb+9vwuFYqVVz8zSAYtuqjnNI6VenvIXlcrC055suzBNvbzfEw2nVB7Zm+0l8eXof+syIz6BRA9Y7mbT5WE0aWxXf7z/en3NHRt8+DGlsk4kYyqMrJblZywyzsQmSChUXY3ZXrH4/TTanE7NobDl1QjB/SIGy8lSl6SGR0dVY+6dc/2+yIJRi/BwT4zzg9O79jTVvEVDgDGWewMQUudohl+Iv8wapfKW5PHG4f+J1I3DVOBLgukvkvZ3mpO5Z6CIn76bgO6908wu6HDxDF3qh+8R5d1aGcVQkpeG2Qb6X0h3QieImEGABNTRTVWp/4q0nYmvk11IKKBwMze8aCNhFKTJqyjFxHPf1D6VeFDZj9nlLpZMsUb9XOSQOqQ6N2XQfoBNOeFPWQI4JRcJ3dSUs1IhgEjnAEytwPfW8pbitIWUOr7JeRlav
 GUS0h4Lv
 R5mEIgONtsDpU+lkd1Yx313ilo4z/wZea2hn7bN3npy/R2EILPTcZIviVgjNKgg1hd18xgV2eWbbp3b0EGy+0w5TLEF3d0wfvOTO14HPRYJzRHeNzo9MFBeZX/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 01:42:46PM +0100, Matthew Wilcox wrote:
> On Wed, Oct 15, 2025 at 03:44:22AM -0700, Vishal Moola (Oracle) wrote:
> > On Wed, Oct 15, 2025 at 10:23:19AM +0200, Uladzislau Rezki wrote:
> > > >  	int i;
> > > > +	gfp_t large_gfp = (gfp & ~__GFP_DIRECT_RECLAIM) | __GFP_NOWARN;
> > > > +	unsigned int large_order = ilog2(nr_pages - nr_allocated);
> > > >
> > > If large_order is > MAX_ORDER - 1 then there is no need even try
> > > larger_order attempt.
> 
> Oh, I meant to mention that too.  Yes, this should be min(MAX_ORDER, ilog2()).
> 
> > > Maybe it is worth to drop/warn if __GFP_COMP is set also?
> > 
> > split_page() has a BUG_ON(PageCompound) within, so we don't need one out
> > here for now.
> 
> I don't think people actually call vmalloc() with __GFP_COMP set, but
> clearing it would do no harm here.
> 
Agree. We do not want BUG_ON() in split_page(). I think it is better to
control this even though nobody invokes vmalloc() with __GFP_COMP.

> > > The concern is then if it is a waste of high-order pages. Because we can
> > > easily go with a single page allocator. Whereas someone in a system can not.
> > 
> > I feel like if we have high order pages available we'd rather allocate
> > those. Since the buddy allocator just coalesces the pages when they're
> > freed again, as soon as these allocations free up we are much more
> > likely to have large order pages ready to go again.
> 
> My PoV is different from either of you -- that we actually want
> to allocate the high-order pages when we can because it reduces
> fragmentation.  If we allocate five separate pages to satisfy a 20kB
> allocation, those may come from five different 2MB pages (since they're
> probably coming from the pcp lists which after a sufficiently long period
> of running will be a jumble).  Whereas if we allocate an order-2 page
> and an order-0 page, those can come from at most two 2MB pages.
> 
> I understand the "allocating order-0 pages helps by using up the remnants
> of previous allocations" argument.  But I think on the whole we need to
> be doing larger allocations where possible, not smaller ones.
> 
OK, i see. Then we can start from highest "fit" order as starting point
and switch to lower ones if failing. Fallback to bulk or single page
allocator if it is still not enough pages.

Thank you!

--
Uladzislau Rezki

