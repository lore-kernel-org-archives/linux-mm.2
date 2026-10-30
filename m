Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B719E606A32E
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 12:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bKBGo9SZ
Received: by kanga.kvack.org (Postfix)
	id D36A76B00EF; Fri, 30 Oct 2026 08:04:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEDC16B05B1; Fri, 30 Oct 2026 08:04:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFF456B05B2; Fri, 30 Oct 2026 08:04:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9DCC16B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 08:04:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A17B6120628
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:04:09 +0000 (UTC)
X-FDA: 85379159418.30.E2A3E7D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0605D4000D
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:04:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bKBGo9SZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793361848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v82mzkt/jt6jPtl1ei1Iq8wfRsMZYKIpIpg9HbC5F18=;
	b=oGTL+mubf8dj7IKAEWLPjFGUjoRULzAdNTn515xVwF312KSkkhWRSXyyFnc/t31yuwR6cA
	KqQIu7VOJ9s1THNPY0islH7IfS3FEeKTnmzLX9ahsT/KNuum8I7k36o0fA++MRHuVXnmmp
	/tMWheAjZMw7eITVxgM2TbEZ9e5XjiA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bKBGo9SZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793361848;
	b=ipzf04CX/PWuE4N3bTtRWYnikF59CEz3IoDmwYVMqx6Llvy74DPF5r1uVrTbM2/0b4ghxy
	/OIhnrdhGBPJFWhDHApjQD4ednC096ynGR2nhZ74bsgkbLVK7G8RxGwFahiRu9feH3MhOP
	Ylh+eShDKMPWjrnzy6UDhPiesl6jhkk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7015543602;
	Fri, 30 Oct 2026 12:04:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56CDA1F000C1;
	Fri, 30 Oct 2026 12:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793361846;
	bh=v82mzkt/jt6jPtl1ei1Iq8wfRsMZYKIpIpg9HbC5F18=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bKBGo9SZfxwjC/Xfqsy4J8CcQ7x1O4QhOR3H1pnysW62FBdsJRwtCvOy28QHYKcR3
	 VrjQ0tY9EXaol2fM77uzLHD7pYPlEk1J4x6OdzYA1y0Ma0UuT1ivg5wMECjifl0Utv
	 rUnI08CGpjcSJYa7vDOHCTTh8HAsV/KOVk2/4x8DzYVbujacQUZBbpImkrVWvouKx0
	 QcRuEbgagwyuFa0f3k/RGb/l7/6udXYs+QS3xtQ430YisTQ2zEg/YjK8JAM/8p3iYH
	 Da5Q8yZeBa+apnfcjjbIDPFYbLXav/zsReh2gHHinKOyVPyxzeM59lHemtrjCLDefk
	 jVON88cHrKDnw==
Date: Fri, 30 Oct 2026 14:03:57 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Pandey, Radhey Shyam" <radheys@amd.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, baoquan.he@linux.dev, pasha.tatashin@soleen.com,
	graf@amazon.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org
Subject: Re: [RFC PATCH 1/2] kexec: do not place the next kernel in a
 fixed-address CMA area
Message-ID: <auSHrdDdFrWRsuzM@kernel.org>
References: <20261014145731.3431527-1-radhey.shyam.pandey@amd.com>
 <20261014145731.3431527-2-radhey.shyam.pandey@amd.com>
 <2vxzh5i5orbv.fsf@kernel.org>
 <auL3UW2InVqYU6Fs@kernel.org>
 <2vxzzevwmz2v.fsf@kernel.org>
 <7625fa23-5f4b-4658-b17a-fe4e58103e7c@amd.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7625fa23-5f4b-4658-b17a-fe4e58103e7c@amd.com>
X-Rspamd-Queue-Id: 0605D4000D
X-Stat-Signature: qaugkoo38qbcfuegs3icezwazqpwuhiy
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793361847-108332
X-HE-Meta: U2FsdGVkX1+8uhZjv1zuItBV3jVv1C3v+HpEKljVLEzXc2wVry4TIBavx/65UMUF/Pu+TSKLOg8KhkS3SjcodDpSMVlbGPlLlyCFFPx9OryRL6NHyfdgUtUEnVBbJh05K+hguVsIB4lT9mP/Q49F2HeUmxUyHlBLu/BNWWnFQ8RAFkreoooFgjMllAdhzJvF/yQBwEPabr5MdAPpMdzGnMnXa1UF8wCUomYgOKThPv/XQqyPtUCALynhc83OOhorhZ4MN2zKP63pfzm5lx1H6c70hF+poc/MoA2yldL+UEXP+UkJlqc2d+Fs2G5UkmJ/Sd27wJDBN3+KUW5UFaAarHyWb7e7yn+zr1hOGYM3C4sIdjC4anSPs8zkOWzezcQB1FAUHllzeF6zq5nWo2k4nFoyCjVCbNwXpCAa36rGaTo2XaAtHQWfYFekh9jQnimP2mlBkbmIqUmmrXPts2KNJ6dDR1KSk+iy2oOh4/MwXRTbQfNonP4PgYOLyn8FCtPeO3yinXtvds7JwdjdEuQIAmZEEZNS/GI38NiJIUsqXNL0NXV0dAurWwlz8hE80rkt3oEeVk0MZLWwYy3LUxRapBYuevuQKFvTpACPWgcBxOxvkuFVLG3ev3DM0RSu28aj8Hm2RD2evzJ7rgdYZBArh1OFhqk7XM9oNBGfFhkbR8n7/zN6MpVuedn9deAUi47R/Bve0BE/6Kt5li/J6M4zxGQNJATU/U+dQDgXEv55DDa2RBRu8IDU8bohmN1d79jqribYrYvjAF/3j0+753fxMMXZ040v+Sg51HWKccw4b+bjUKFT5eFupb2nCn+KCFZ+FNOexIrQcVnQeZ4YuolYg3GvwOOdlAnzizOI50xkQ1T7xHg0q46Hy94cJobw8ZschTgmFyJisTNEQucfwhlO4zD1D/7JZuxQZn00Qpif59KiUHKxwDPwciIC5lZ9Pz1wDWZpAsW0r7gXOoNKW+T
 OpvbsK3e
 6IgkCMhCr13lMT+Y0SvDF++UfXGNPmZzAMZJ7YVbz/FkM61vwCVpFJTBwJ7cUoq7qE6xREKSzIgTOjakdW/pOy1iVRb1x95kKv38ApFMmwYpKhkB32KLEa9msq2t8kI+KJwjVe/90ls5qLbpbyd6du7QfrOw5z5oWMyudnM+6fwG4MZQIthWj0JuaOBtopUJTo+M1WLEp6iCO7PCmybgFU58YeJ1P72uHaBCJI1cI9VjWt7xxbd2jDggHhTmNKn2gByrZHnCqUiqNDPzoHHe7ZPD7Htma27544EPX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 01:22:50PM +0530, Pandey, Radhey Shyam wrote:
> On 10/29/2026 6:41 PM, Pratyush Yadav wrote:
> > On Thu, Oct 29 2026, Mike Rapoport wrote:
> > > On Wed, Oct 28, 2026 at 03:03:16PM +0100, Pratyush Yadav wrote:
> > > > On Wed, Oct 14 2026, Radhey Shyam Pandey wrote:
> > > > > @@ -304,6 +317,7 @@ int __init cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
> > > > >   	cma->ranges[0].count = cma->count;
> > > > >   	cma->nranges = 1;
> > > > >   	cma->nid = NUMA_NO_NODE;
> > > > > +	set_bit(CMA_FIXED_BASE, &cma->flags);
> > > > >   	*res_cma = cma;
> > > > > @@ -517,6 +531,8 @@ static int __init __cma_declare_contiguous_nid(phys_addr_t *basep,
> > > > >   	}
> > > > >   	(*res_cma)->nid = nid;
> > > > > +	if (!fixed)
> > > > > +		clear_bit(CMA_FIXED_BASE, &(*res_cma)->flags);
> > > > 
> > > > Nit: This reads a bit odd. cma_init_reserved_mem() sets the fixed base
> > > > and then you clear it later. Wouldn't it be better to just pass the
> > > > fixed boolean to cma_init_reserved_mem()?
> > > 
> > > Actually, we shouldn't expose cma_init_reserved_mem() at all.
> > > 
> > > The current callers of cma_init_reserved_mem() should be switched to
> > > cma_declare_contiguous_nid() that does sanity checks before calling
> > > cma_init_reserved_mem().
> 
> Thanks Pratyush and Mike for the review.
> 
> The switch from cma_init_reserved_mem() to cma_declare_contiguous_nid()
> looks like a broader CMA refactoring and requires additional changes to work
> correctly.

Hmm, you are right.

How about we invert the flag meaning?
Than cma_declare_contiguous_* will set it where appropriate and we won't
have the weirdness Pratyush pointed out.

And Radhey, please, make your LLM to spill more concise and to the point
text and teach it to trim emails ;-)

> Thanks,
> Radhey
> 

-- 
Sincerely yours,
Mike.

