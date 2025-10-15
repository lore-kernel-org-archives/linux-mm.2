Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8F8DCCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 09:28:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D1DD8E0022; Wed, 15 Oct 2025 05:28:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25C028E0002; Wed, 15 Oct 2025 05:28:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 123988E0022; Wed, 15 Oct 2025 05:28:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EF06B8E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:28:55 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 97C1D13C1DF
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:28:55 +0000 (UTC)
X-FDA: 83999824230.26.E5F1F6D
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf14.hostedemail.com (Postfix) with ESMTP id A0ED7100002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:28:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ag0rLbKh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760520533; a=rsa-sha256;
	cv=none;
	b=dtW3+v7H5a+mW5b1UO7GVdOYc/zvsxpBGAgn64SuNJbLaabFladBlJsXQnKN8Xk22a4sU2
	IxQLUM1zrRw6KNAHyoMj3TULwQqWDk8PYFCsREWcccbKzEriG6vPMDy59wK4CCQY7ZVuK2
	TLes3VsCyYUC7CqV/vQ5YaiSo3cFbkM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ag0rLbKh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760520533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hp2fYKx0k402gU8wOiSoX7ghMVY2eXtiYBiomEBCu00=;
	b=P1xNdWjg1ZzbgnT9HFrgZUeEMQoHYHytRnYv0xogsPUaP+nkGlZNm3EVDd8jRWEwgIa8Xy
	Uuhdml0CqwdggE45o8uWjaP5e5X+pJhDhYHxNEG9B0zWSXtsyfruT7myJ11Ud8CUNotCms
	/tzMtIJIp92yNCL7FOCqsFHynHgPrP8=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4257aafab98so5274647f8f.3
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760520532; x=1761125332; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hp2fYKx0k402gU8wOiSoX7ghMVY2eXtiYBiomEBCu00=;
        b=Ag0rLbKhI91OIu7846u9fOYh897CUAn8wxs7HghaBn3uZtBfdaCPZVsWS7LTrtcg8l
         MA5pdCdUkZNuHhG6tM0wofpKjbv6z2SM0rNOqZdT2+I3Ki6PFM2rapmgk5WzWbDwuDl5
         ZTwh7/bHoKIbP+vT0/HFVNbAItvsbbqzx1D0RvBDqzGeixC0il//KYUk43E2VmMCQvTk
         hcxQCUj85+zFNFB2as2d2zDHSaSfc4bTCZW0lwnqrwdbESVG/7grIGwwU+LrrRB7Uz7/
         xG3rkfJB9s1g3heSHeq1s9VnLXlSWuY39PY8REwbxa8nGtzTj7yeoeKzacepOF4X02Bp
         R1Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760520532; x=1761125332;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hp2fYKx0k402gU8wOiSoX7ghMVY2eXtiYBiomEBCu00=;
        b=l8BKLWkZ7t8q1+LPvdyGsbscxlt3LR/848Ni6vdE9Z2rm8Bhgy6T0NMMbGMJFiTYpi
         UHFz0zIX8kG1lVD/KfWLyDLdjN/vKNcRL6P2/5qOVr00h9pRjbH+4iglnJPVkkMA+JrZ
         31LlVw3VKdjZPQThGwcrYzEoaU8mcHUBXQokw8b7DyXOCN9lIuIqVL9oxBVyYZbAFOZ/
         vEfFfhY1yFttCQK6W1/36fZXh8YqCsH/LfNvc27aWZfoCzungKa1RSbs07+U6fKcUpRQ
         xbKRtoDl0FMYW0dk4u6qGWBt+x4t5rIEG/UV5FRXGEMg8FdTt1OfHVQSyX082Xa0YN0G
         Z3bA==
X-Gm-Message-State: AOJu0Yy38P9UYXHwtW90Qm3TTsBzD4roxTBq7LVqFLcBUbewU3f+v9Wb
	dXBPczA8r1jmTs1DnDlM6S2SIRcqdwO9q3w1TED96E+7cnre+42phRd+
X-Gm-Gg: ASbGncvagWdXgd2kTISL0VjElMnFe693Bct56RUqtDJLFOWlaaOP3jADLeFbduIY1nz
	j9ET+66U8f2nHP5ECjaitkjGaTOrxo4dMXH+GMkTJ5ErQMKLBQkll/XI3LN37KvS3PI8EPZ/zyX
	Q9ZhO3oRRJ9X6dv75OSZY98Xwvf1T1Rz83AkWaWTfDjdHxRjh9iEMbV7hTKjAkHlFXhkENL3mpX
	GYx4wkxlb8pbbMFVO3n7DkUMl2wRq4mCaqoz2mxi1ix8WiIi+5HrTFdSB5WiIwfEDBdDTLDnNrn
	3E0c6uTj3fUhSIemM6KTRqp4M4BzhCVprzVEUqop+nKQfpG3+DZ0WgxdcKsEDjZOzxKoH4bvxVo
	dJyeNPssbCVkebh+DrdHc/4peU0iqSkXjlE8=
X-Google-Smtp-Source: AGHT+IGhErKOy64d9/b2jMz0wYrCY+Ob/EHUO0qOvgBR2Gdz3Vtc7ebOk0y6bVbTKFpbvvdrluUWvw==
X-Received: by 2002:a05:6000:1a8f:b0:3ec:db8b:cbf1 with SMTP id ffacd0b85a97d-42666ac7279mr18043977f8f.24.1760520531741;
        Wed, 15 Oct 2025 02:28:51 -0700 (PDT)
Received: from fedora ([31.94.20.38])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce582a9csm28053606f8f.12.2025.10.15.02.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 02:28:51 -0700 (PDT)
Date: Wed, 15 Oct 2025 02:28:49 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] mm/vmalloc: request large order pages from buddy
 allocator
Message-ID: <aO9pUS3zLHsap81f@fedora>
References: <20251014182754.4329-1-vishal.moola@gmail.com>
 <aO8behuGn5jVo28K@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aO8behuGn5jVo28K@casper.infradead.org>
X-Stat-Signature: 4rqimkmze9ekazb8pg7go5jsmetqufc6
X-Rspamd-Queue-Id: A0ED7100002
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760520533-786164
X-HE-Meta: U2FsdGVkX19xgoX5W9z9iuys2lu4+Fj2sd3I38tIkvl2JDyR3g2Spj7V1OSDAibQ4hfz7j7Srr2DyU+YGQKhbUJvOoZJSUOVuiIc6t606nvwwv6uSj2XEs/AwESSpAkVMfPb8px8ahwwQGf2bqofIP/+xTdNIBKk4tusmp4cCYymDRbnRpomgTh82iwbcDdOrqXGXGSccxYZZCCu2UYuHrTggfprHgzeACbWCmucA3ejiDR3IaLV97Cy+QD+kCbKI3D5ROnpS5FxfRg94BIl1x4b/sQbXvlDGWC3Xzd02HH2aYkRWSDYQKD8yJWGh86yawxbwTBrNf3So4BhmJQbDUVjqtxVyFlxNffJF/QTzCdy62y8/hSvf6/iZgjJ0kKyGBaECv8Gfaji+4DZVjdwEBIcC2/pLqRFrAKkwCp7uUa1KNDHAEKySO5yFTMfzjjzt/Fh13ZtolvGUC1nWkKt1QDePbqfmgIKdtV62J/UtVN6HEwfBIl9+5aNH0R2S0+3TBze7MDVjxq+RoPBv9Ma2Kb58v2MRM8Ksde7wph1aMV0sXHFSmXzFxTNFdhCs6/UEBDoUqk+hYFzeeeqASUotHzM/8+o1XdBp6MVlUhEorMJkpqXuBjPCWKr9OqRVKXBIdiUWjnYjaNGf4rrT/ckUzUYw9UxM8xSubVYBLyZNpmqWI80F1mCY/Uji22fium255bhSNVvjipOfqe+SeTWzrWpGJnAf/Ds8io1fpce4l7UtH4Zp8ZQ5mrYG3/euAQEpDXx4I7dV8Gt+dRppT9dW9gAt+CLqmfVKOIIJXyUdjekCCUouOA8mDAeRRXjmQg1HhqYlBgVZFy4ak3hqL5ApRCWJvzjQlbk0Ph9PGZ4/zsLI5jinkKK3EZ7Esr/i6Uw8mcYBs4dDa+z7d4HHYfvNKhwoiZ9/sK9GwjyN4s8sV69hjXt587HiE9tIuHyoGk8yrO7WWOo9TnrzDGFJ3+
 iieLhw66
 W16SWDPQsxWoGj1o57e006mOhLLF++VA/MQ416QdGIL/UIEG+qojhQoIkkus1ynXJrgQmPkGngrAIhpX5A7IV8V6icP9ey0mO7Jdz4aYEVYVmbmSoYqq+2KbJGOhBboS/gbxxw5znvWcco3yW3Qxbyzr5TE57BpxRfuF2yeSXKnuwxuI/2aLXYwm9dco4mHBDZrG7WShcnObxXq9dMtc0NmEgc1VQGlkyGgXTajEVI1ooL1vLkuJT6WWt6AF4UWaZN5/Mp3czBvqtl581X1vAc+GSQ5j1Tb8HpOHlajQVMfc7Tlx8woXbLhJsb9fyWOq5Luq7tzSUYME0kAHwiB28FFb0oTOmQtVnhRe/4Rq3/EdKCnEiD1whzM7ImFdohnyEn7BBL+QHo3mJawvUL5pGmHSL+QcGrZWZ4fQ/HlWzdqVt0KsfLp+N12hxBWsKtIInofGj4H/pNkmIYUPFifN25Po/eQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 04:56:42AM +0100, Matthew Wilcox wrote:
> On Tue, Oct 14, 2025 at 11:27:54AM -0700, Vishal Moola (Oracle) wrote:
> > Running 1000 iterations of allocations on a small 4GB system finds:
> > 
> > 1000 2mb allocations:
> > 	[Baseline]			[This patch]
> > 	real    46.310s			real    34.380s
> > 	user    0.001s			user    0.008s
> > 	sys     46.058s			sys     34.152s
> > 
> > 10000 200kb allocations:
> > 	[Baseline]			[This patch]
> > 	real    56.104s			real    43.946s
> > 	user    0.001s			user    0.003s
> > 	sys     55.375s			sys     43.259s
> > 
> > 10000 20kb allocations:
> > 	[Baseline]			[This patch]
> > 	real    0m8.438s		real    0m9.160s
> > 	user    0m0.001s		user    0m0.002s
> > 	sys     0m7.936s		sys     0m8.671s
> 
> I'd be more confident in the 20kB numbers if you'd done 10x more
> iterations.

I actually ran my a number of times to mitigate the effects of possibly
too small sample sizes, so I do have that number for you too:

[Baseline]			[This patch]
real    1m28.119s		real    1m32.630s
user    0m0.012s		user    0m0.011s
sys     1m23.270s		sys     1m28.529s

> Also, I think 20kB is probably an _interesting_ number, but it's not
> going to display your change to its best advantage.  A 32kB allocation
> will look much better, for example.

I provided those particular numbers to showcase the beneficial cases as
well as the regression case.

I ended up finding that allocating sizes <=20k had noticeable
regressions, while [20k, 90k] was approximately the same, and >= 90k had
improvements (getting more and more noticeable as size grows in
magnitude).

> Also, can you go into more detail of the test?  Based on our off-list
> conversation, we were talking about allocating something like 100MB
> of memory (in these various sizes) then freeing it, just to be sure
> that we're measuring the performance of the buddy allocator and
> not the PCP list.

Yup.

What I did to get the numbers above was: call vmalloc() n number of
times on that particular size, then free all those allocations. Then,
I did 1000 iterations of that to get a better average.

So none of these allocations were freed until all the allocations were
done, every single time.

> > This is an RFC, comments and thoughts are welcomed. There is a
> > clear benefit to be had for large allocations, but there is
> > some regression for smaller allocations.
> 
> Also we think that there's probably a later win to be had by
> not splitting the page we allocated.
> 
> At some point, we should also start allocating frozen pages
> for vmalloc.  That's going to be interesting for the users which
> map vmalloc pages to userspace.
> 
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index 97cef2cc14d3..0a25e5cf841c 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -3621,6 +3621,38 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
> >  	unsigned int nr_allocated = 0;
> >  	struct page *page;
> >  	int i;
> > +	gfp_t large_gfp = (gfp & ~__GFP_DIRECT_RECLAIM) | __GFP_NOWARN;
> > +	unsigned int large_order = ilog2(nr_pages - nr_allocated);
> > +
> > +	/*
> > +	 * Initially, attempt to have the page allocator give us large order
> > +	 * pages. Do not attempt allocating smaller than order chunks since
> > +	 * __vmap_pages_range() expects physically contigous pages of exactly
> > +	 * order long chunks.
> > +	 */
> > +	while (large_order > order && nr_allocated < nr_pages) {
> > +		/*
> > +		 * High-order nofail allocations are really expensive and
> > +		 * potentially dangerous (pre-mature OOM, disruptive reclaim
> > +		 * and compaction etc.
> > +		 */
> > +		if (gfp & __GFP_NOFAIL)
> > +			break;
> 
> sure, but we could just clear NOFAIL from the large_gfp flags instead
> of giving up on this path so quickly?

Yeah I'll do that.

> > +		if (nid == NUMA_NO_NODE)
> > +			page = alloc_pages_noprof(large_gfp, large_order);
> > +		else
> > +			page = alloc_pages_node_noprof(nid, large_gfp, large_order);
> > +
> > +		if (unlikely(!page))
> > +			break;
> 
> I'm not entirely convinced here.  We might want to fall back to the next
> larger size.  eg if we try to allocate an order-6 page, and there's not
> one readily available, perhaps we should try to allocate an order-5 page
> instead of falling back to the bulk allocator?

I'll try that out and see how that affects the numbers.

> > @@ -3665,7 +3697,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
> >  		}
> >  	}
> >  
> > -	/* High-order pages or fallback path if "bulk" fails. */
> > +	/* High-order arch pages or fallback path if "bulk" fails. */
> 
> I'm not quite clear what this comment change is meant to convey?

Ah that was a comment I had inserted to remind myself that the passed in
order is tied to the HAVE_ARCH_HUGE_VMALLOC config. I meant to leave
that out.

