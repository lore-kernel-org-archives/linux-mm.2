Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF139C61DBD
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 19:19:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8589E6B0088; Tue, 25 Aug 2026 15:19:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 808F46B008C; Tue, 25 Aug 2026 15:19:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D1166B0092; Tue, 25 Aug 2026 15:19:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 341626B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:19:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 95F48C0196
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 19:19:26 +0000 (UTC)
X-FDA: 85140755532.20.22D0F93
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6661340005
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 19:19:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=OkZyCfhF;
	spf=pass (imf17.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787685564;
	b=TYaZSnGsYSSdppj2pFkPXWD1P1bk1B63cOYgzQ7A9bHSvIKs6JjUl2RbuMnzRcsW+ZJX5C
	HrsD2lcTSGEo6bOiURKu+ST1h2mBnTjLcOZS5VZoOSodM56Bqu1eJyKUyg4q2sz8vMCEFw
	hpl6w9TFAO87/+sixbPTSpdKFenHj4E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787685564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vh4FcSFvMp+s/1TmS+CMXh1e8vfSlZ803gr4X3HQDps=;
	b=XjF/X6F0p+MFrSmy7jK/v+kcRmrW8MeY+jeHyp/jXnWdxe0/Wtac5xcVVwv/2dsBowVg2B
	sjb33OA8BPk4VxkZGRxucYcxqgrwoIpAP45vT9xxvCzrshdFBNXo6pFv0KxGmdnlAOw5L2
	RUzxR1bL3+sH9IX+dQgokRtFXCf7Ke4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=OkZyCfhF;
	spf=pass (imf17.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c197e7e4e94so5405166b.2
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787685563; x=1788290363; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Vh4FcSFvMp+s/1TmS+CMXh1e8vfSlZ803gr4X3HQDps=;
        b=OkZyCfhFOehSqsSgGOje1WPZX4xsix7pmVE40WfXCbKYIDxUYINEF4AIY6ZAKa93Uw
         v0IoVEGJ0ukfgXDNsLFL8+eDTAhBppGetzVIRjONpexyViQr98OHmAXnInhUJbQFJrti
         FSGDZa/1pA/awcN2jBrn4i1wAAKwCY0WQ8V35FaJFU5npwEVOL+74cPdzFioyCQc7tLO
         1PkGd3urP9mlPPr/9vj7FHqYBypU2EIRcKg6rF8s9i+qVFXr3rS1ctyjekqOQJSRt6ec
         B8q7O4aKQh+qMrIGXIFdEsWfrg2WYlZW75KhPHQcJsBlX/S7SrIOo0lpipGyqCfmlCls
         TXfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787685563; x=1788290363;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Vh4FcSFvMp+s/1TmS+CMXh1e8vfSlZ803gr4X3HQDps=;
        b=cCk+hTdX3Sw2mMEQZSFgy0YexayYJOXveoCW6OXZktyyPJxoNRYx4ssWd/qMFxPrTj
         Iy3KEW0b2hU6tfasg2s1zYnnShQ0jJ50KkqILMeqMMA2rmvx9AT9Rv0UVW9D4oZ+ya5x
         XhTEJaLJsCpJTlDVUP9ze00LC4CBO9HEz2mhE37maYjDZlNwEehumdEazGVX0Xu/8Mjx
         D4YTkJn1IlGyvCXNxhSL4alApz1TWII5GYVl4a0/pcowXYFBuVww+d1zcWoulTA7sO3F
         dMwswdG2VATNqGRAFneN75leHNfGrolB0xVj9iJHLqF0GxJ/uzsCpF364MAWjQtmgCmW
         1NvQ==
X-Forwarded-Encrypted: i=1; AHgh+RpVSjxmJEd8cNFdE/65sBWauM2ViHo8cIjbk2H/esM5x5ELg4W7sCfJCfDtLEbwI7EoHU/5YHFzLA==@kvack.org
X-Gm-Message-State: AFuF++lhslKbjw6mk8A6VLL0Sdt7PrfYEpYwEsuMCpEyVD0LDH3fMqId
	RZdUyx6rQe6l9tp2YifQ0kP5nG+USYjkI/i+3PBbUS6DXcrPr2G3+apR5pyObaC66DM=
X-Gm-Gg: AR+sD10sOcTy8wHg7fHecb///0Bg3CUGXO6BifgSGG1s+7OfEGVSQiwKexRYYUhXGFZ
	hWfHu3tIBLAF0+3IjYdhZ3kjKrrBN+Q/Q8T0IW9nSMnEfAEiRWWNFSLZ/kwFKaXN+aqlbqxZtxS
	U9tUTrYn/7Vv1CNK704QMkxH9CD0oN+8sTQcAr77HJYIZ0tOGsV3Lh7LAMXbdrs8NwV43dWqwH0
	FUWMb1FWHQ063aEgajcXdENsxNo3MhhBaBWO6MXlisx0i+EODl0y8u2pMITDP2t6HmjPoIJNEYj
	Ms9SNK/fJ6+oLb4GSR5a/UWbMZAuwS54Zy6PqsMWukHydKuPp2BTkTYbMp0NUPkHybK7LD3UwXK
	eylg4KGvh7kGhZK34dTpWZVkIM9B45VDyOehPG6iZgBft38DF4IdwjrpKbixvsvD0gVkksYL6hA
	Qml/rQbHU5h+AraOZPw5e6QcDkxK0yxKEMZJZ6gdA7UFoYU9KzSNgLhSqUsov6Eh1Fwg0g+88Jo
	z0R
X-Received: by 2002:a17:906:f049:b0:c24:7cb5:d617 with SMTP id a640c23a62f3a-c250bb7e76cmr111451066b.1.1787685562796;
        Tue, 25 Aug 2026 12:19:22 -0700 (PDT)
Received: from localhost (109-81-80-32.rct.o2.cz. [109.81.80.32])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c250a6fda44sm132189066b.14.2026.08.25.12.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 12:19:22 -0700 (PDT)
Date: Tue, 25 Aug 2026 21:19:21 +0200
From: Michal Hocko <mhocko@suse.com>
To: Eric Chanudet <echanude@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, Maxime Ripard <mripard@redhat.com>,
	Albert Esteve <aesteve@redhat.com>
Subject: Re: [PATCH 00/11] mm/cma: charge cma allocation to memcg using per
 area counters
Message-ID: <ao3quaSze8YjPjxZ@tiehlicka>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
 <aowHqqaqK7TeexQH@tiehlicka>
 <ao2gA_m3BCBu2esy@echanude-thinkpadx1carbongen13.rmtusma.csb>
 <ao2t6HP-Zt5KDg30@tiehlicka>
 <ao3UKM5SbxBmxuR0@echanude-thinkpadx1carbongen13.rmtusma.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao3UKM5SbxBmxuR0@echanude-thinkpadx1carbongen13.rmtusma.csb>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6661340005
X-Stat-Signature: 9pb1wgn1u5pa5if6bfqc86supu9z7k4e
X-HE-Tag: 1787685564-84774
X-HE-Meta: U2FsdGVkX1/FR1bTNnYrV3eCpuv5A749PGNAhod7UK5BXEU1lm34vBAnLvhoWYXYATj4g2AlkaYOwn2SNQTwqtVsM+sfpNZ9fiIBTqEt1NqMpiT0RoK/LHwC4Wrro3A0LJTWSedfmJBQYxOSXJ9YQvJcdwd9wz831WblX6ESGGrS6g3yHITVYAsaNKZvug5FT0jizoDHW4Dn9Xm68jEBrVSWmzUO49PazYSOid3FmRHmvwVqUxiqTz8CRs8MS53j6u/Gln8m3/CkRNcaObApTvXjT06UpCVfLdWkjunQL6R/qG2j+8GAh/gOS/P1Xl1P8j0RIAprF4Hm4nfm3pCtnWzpgRocHKAiaLAu8Q0rt6ce4jr+lXveABSlwE5l1XSrwlh2IeHola6LCt/dPGcEu4x7DraZMg/7V7z7jNJnkalBV0DEjrXXGqaPOJu5eBNq4Xn0fr8Dy1wHYD8fCUJ/TrH+BbzTfqtp5VxiAY4xsz9r0FfcNQaL6UFsVuLpCREXzutl2C3n0sJSg7vyUHbnLXBHgxfnpnw41NeExadNgv6sLZzE9lxA+NL7nS6bfvn0ycWGoiGhJPOjS/FGyj8ejN186n0WKB+1OOhMI4I8qoflBMsi2yPhLFpQ67ROLmSfxyjS+hyVK5b2uXUOaeaWPC2RMdCghZ8lWmQUUV5U+tHoZuGOPN/stTI5nAyntrxIK9dY0zMTSai4RvxRv94ZH1Z09xgJAMCBMpwtgnfUYYEdJnQy/Mi2oClSiAMxP5XQR9EiyozOQdHbvKzy8DNOsy+q8OcSDn7I6O7nQg+ERDvQzmF3JW2JMDgtsij8m4k6ezsdcmK1qSB0R9kgHAZLt46X/7lFymexC3QYfC1sGKV554GVBVSSrHuW8Wyh6Dgkysx+okjogkx3BaU/AWzavsn0KynifU4z0wGfAgu8eJnUPfcEj0fhEFZMO/bCuA2TYxXy1Lf+cywhrRDV8RN
 a4uQ8j4K
 DMt04HhXapl5BXKO+Q6Xq/4GCx+7RezLF7AXUSEWHTMNvDgCXRtbiH/N+NQlJA22zUPN+7g3GEQkueYNqGkZb2QXGg54DONHv/h20AuD0mP75LQSUvsXCPkmrqiaY6BqRilZ8TiiLdUhY9A+2I2J7m++ncjCdGgqPcKIJk6QdseDIHH+6FLGgdb2UKnO4Gpvai2fwIkSWLXqJwRgWLfUannfmM8OoNiMENj9IqVbOzRW0D1X8pAl0If9JxEuQ6gX3JicmZbyf8sIO/fxoZ+NA8TIWuLGA7D2aejbLRbyyeYbsxFHbU1iv9AKP71nnuk0faO0+2N0mjCsNY+Km4Gz8NyhhGwgS6WscYE+VcC5qa5yUvVY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 25-08-26 14:33:48, Eric Chanudet wrote:
> On Tue, Aug 25, 2026 at 04:59:52PM +0200, Michal Hocko wrote:
> > On Tue 25-08-26 10:47:53, Eric Chanudet wrote:
> > > On Mon, Aug 24, 2026 at 10:58:18AM +0200, Michal Hocko wrote:
> > > > On Fri 21-08-26 14:56:52, Eric Chanudet wrote:
> > > > > CMA allocations are currently unaccounted for by cgroup memory
> > > > > controllers. As system resources, they should fall under memcg, but CMA
> > > > > areas partition the available space for different purposes and memcg
> > > > > doesn't have a good representation for that.
> > > > 
> > > > Which CMA usecases are covered by this work? It would be also great to
> > > > spend more time describing usecases.
> > > 
> > > We would like to offer some usage guaranties to userspace processes
> > > ending up doing allocations in CMA.
> > > 
> > > For example, a shared CMA area is described in device-tree for an ARM64
> > > platforms. Userspace components could then, for example, allocate from
> > > it through the dmabuf heap, or a device or framework-specific ioctl for
> > > that matter, to use the buffer with sensors. The dtb may have other CMA
> > > areas described additionally that may or may not be used by that
> > > component. In this context, we would like the ability to limit one of
> > > the userspace component to over-allocate and choke the other(s).
> > 
> > How exactly is this supposed to work? How is the CMA access controled
> > and opted in for accounting. What happens when memcg limits are hit. And
> > many more details, please.
> > 
> 
> The administrator opts in by mounting cgroupfs with
> memory_cma_accounting. At which point the cma allocator will charge CMA
> allocations against memcg and manages a per area counter depending on
> what area the allocation was made into.

So each CMA area will have its own counter and limits?
 
> Assuming memory_cma_accounting is set, if a non-root cgroup makes a CMA
> allocation over either memcg's max limit or the per-area limit set by
> the admin, the allocation fails with ENOMEM.

No memory reclaim is triggered?
 
> If memory_cma_accounting is dynamically unset, no the CMA allocator no
> longer issues charges. Whatever was already charged can be uncharged
> when it gets released.

I do not follow

> It looked consistent to use memcg since movable pages from regular
> allocations may end up in available CMA regions until a CMA allocation
> needs the space and has them moved. So in an extreme case, hogging the
> CMA space of a large enough area could trigger system memory pressure.

I really do not understand what you mean here. 

> > > memcg
> > > looked like a good fit to achieve this, albeit handling the areas, so a
> > > cgroup has a quota in a given CMA resource.
> > 
> > Please expand more on why do you think this fits into the memcg model.
> > AFAIU we are talking about a unreclaimable memory and reservations of
> > CMA areas.
> 
> Since memcg already accounts for some unreclaimable memory (kmem,
> hugetlb),

hugetlb pages have their own controller

> or induces failure if no reclamation is possible, I did not
> see CMA allocations being unreclaimable to be a blocker to track what is
> otherwise system memory.

yes, we can have unreclaimable memory charged to memcg, that is not a
real problem. We have all sorts of memory consumers that need to be
capped charged to the memcg. If dmabufs are another ones then fine, just
charge allocated pages from the cma area. It is the "make all cma users
memcg aware and have per cma limits" that I am really struggling with.
You cannot really assume usecase, requirements, lifetime etc. for an
arbitrary cma area. I do not think this is a viable way forward. Focus
on your real usecase, which seems to be dmabufs.

Explain what do you want to achieve and then we can think whether memcg
is the right model for that usecase.
-- 
Michal Hocko
SUSE Labs

