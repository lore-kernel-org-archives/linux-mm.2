Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63D95E9A04B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 20:23:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 916C86B0089; Wed, 18 Feb 2026 15:23:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B6546B008A; Wed, 18 Feb 2026 15:23:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C2276B008C; Wed, 18 Feb 2026 15:23:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A29E6B0089
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 15:23:29 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E252B1402C1
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 20:23:28 +0000 (UTC)
X-FDA: 84458702496.14.23B5397
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1FA6514000B
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 20:23:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RIQo03zl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.160.42 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771446207; a=rsa-sha256;
	cv=none;
	b=bGfMBfOYTcTWGmh8KE69MsMcB+xtI2Dd4RlylUH1e9/leUMGI9yPiQzSPTvNur+KRKcEUL
	zp0COcb/NcRUu2ly96SsRxnvS5oFGKK4GvlOreLA9Oi+cju2p4ApuDMqJ/xELNtaSGJ9fv
	mPWuvS+iWyEEO9hPjvs/dLZuUoL1sCY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RIQo03zl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.160.42 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771446207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GrumwxZuhFamLyUUgDeF5N06yYF8U9bWGEw44JTe9AE=;
	b=1xC0aljYm5gbOSZ0SUbMEEQD/fgJSmFIGM9FL8A3LPUFl3VOHffLXDGI1aZkIiyB5VeJ6r
	AmRITEblK1lqqu2vcxmHoBexh+mRfbDyuj7mbiHQxCZGdMgprLt+QnkoN2s7tWSjoFY4c0
	x/8a/lVrgkHBIqtV3+UkXlhnvnCNwBI=
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-40ee486a76eso128940fac.2
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 12:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771446206; x=1772051006; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GrumwxZuhFamLyUUgDeF5N06yYF8U9bWGEw44JTe9AE=;
        b=RIQo03zlIE8Df/4TXQx+K4orIBftjpHHPgM+voYkyS8ezowjJroHNOHhF+Mbbnc4sp
         vOcAp8WWqNAqQyaAzuy7l/QOy/vTAqHhly9DBUrEoerDop4gZcqAlUpmOeuMaT+HhDE6
         JPGIzKFuqziLW7CAINeYhnRUzUrqbAFNogdzBB8wXil6ZKEQx8GviD+VC5s/eW/4oBtN
         CQGzMEzL2rZdxdeqAihEGi4kG6tsnvOhY9H8w7uccMrCPEiGufiGqeY0g6cpFAB7EQOB
         wIjgAqFWag8ZzWpfAjTIAQbFMI+HzyIaB7NcONfsALfpeB99Utc8uLx/+rH9aMtGDMIk
         LSEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771446206; x=1772051006;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GrumwxZuhFamLyUUgDeF5N06yYF8U9bWGEw44JTe9AE=;
        b=pDyPmrqZwtOxX7cPJ7qJ747uGpaW2cETEp6NBcHUO7y4Q8rEdnQ7IJ2D2lv+DzMdsa
         uxhLAnAIoE8XnCO9piDQ9E8mQ3Sa50w4vYVDn987mAkC1pg6jJF5BdgQ+LA/rcOFzPCS
         QIKw1E1qsJnw1j1vio72tssdfmyLSa4XdMcBepkrZK7mV7mr4PXzG1N9R8vgzMl8cLvj
         jjvjHFP28ODnwAX3IIv5rbAqauj7x3UQzpnFYv8UFZYWgd8lD27KC1XUHR+touvrEjVz
         ttUemueNzQTJk6HrNgHboWTSzGvAw+Lr2LoIxCfeu+vG2Hsh7LaBX+bBMYqXcORwc9VC
         0LmQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+tjh8DGv06OYpQ4tB6EZZwfezpO1IjcAI0Gk1s8cEE+4/n5OtSwJYa0o+Z9t+S4Z+c2lS00jNxA==@kvack.org
X-Gm-Message-State: AOJu0YytPTt3XZngvb9yxwGVyv784WFEf2RtNQxMvKeV439HQaS/NC94
	SwCiqTjrWCuSx3Pqp6jqEJXuchqKYmTl/vCR1zAoMFrrVYGo3iga9onm
X-Gm-Gg: AZuq6aK7I0Wo8X0k5uiETZIOOUFj2WC0YKaIwmMy045iV91p2aUc8mU92RwZYnkQcUb
	c5RHYdNKQdovSgUhaRpONwgzRwGxBKaYgBM8AYU7UVPqapXsLpzvW7GhmbP/4BlwjS90PujH6+4
	OvTMCCuPZqBpuDEnNXxsdIizi1pJkmjROP2Du66n43+ESe5FIneQeAlmyK51j7PXLePE2G6goSp
	IUNJAd0jtjtSQSriPJ0u61U5GypH1NkEOG6hDkXRLPvl8OfxodMgVsvMRbK1hkI7gQWvprHvGqZ
	R59bGiyfMjbO7ACbekEbBzM3s7b+aOSTlHlbZH3bt9Igl4a2n7kkj/hpis6TOfLR3k04d9Oyw+q
	FsPkZP8UOR0l2+DwVE5GIHEzzL3eknnJpy82WaZIqxuor1Kq4LuaOZ6whORULb6XzAso44uRtoD
	SnsqfMer95C6zIoNdOMLnVBy+n0tvt4sM1apft0XcEy+poWizjKwKo5yN7+gqJTOxMiNUxOgdAK
	GpSnLptqsTGtiuml2DYwU9YFDgR2QXVqQZ6RNw=
X-Received: by 2002:a05:6870:aa92:b0:409:8564:840b with SMTP id 586e51a60fabf-40eeeccc090mr10681264fac.39.1771446205902;
        Wed, 18 Feb 2026 12:23:25 -0800 (PST)
Received: from syn-2603-8080-10f0-ab80-0000-0000-0000-1382.res6.spectrum.com ([2603:8080:10f0:ab80::1382])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-40eaeb42708sm22257991fac.0.2026.02.18.12.23.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 12:23:25 -0800 (PST)
Date: Wed, 18 Feb 2026 12:23:22 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v5 1/4] mm: Add address apis for ptdescs
Message-ID: <aZYfusoUR69JO1_X@syn-2603-8080-10f0-ab80-0000-0000-0000-1382.res6.spectrum.com>
References: <20260211195233.368497-1-vishal.moola@gmail.com>
 <20260211195233.368497-2-vishal.moola@gmail.com>
 <0ead4a2d-c88c-4c89-b1dd-5954c28edb99@intel.com>
 <aY0ALB5yKXLY-M-X@fedora>
 <aY0Z2qA1xiabEafk@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aY0Z2qA1xiabEafk@fedora>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1FA6514000B
X-Stat-Signature: p7m14arz6376xuu6q9guuqn6iho7or1a
X-HE-Tag: 1771446206-922443
X-HE-Meta: U2FsdGVkX1/weEGHFiv71yUtC0lFCweXQLIgQLHBVRjVEa7W8Puh4dzGpHTpwxf358fU6uuhO0Y2OvbVcKfX/iobUrR7bWoKFcvdKVv0fSISmeJ35Zb8/uZ8SoweiCHLtzX1TDmCZxDSy5sVNIA3698n/4l20s1uFK1OkrmiKEzxtQVS03sp9ep7urQ7e/eeXMnyKAfYstZxclk/SFoL6pzL4ek0J9k6ImAVtAKmN4SdLYLhm1oTt/l2/CNqDXFIGvR9O26N2QD9IkePO/ONkMn2P81IvKcB2DcuPwULPZn/5RC52hGvlDOh7G57yAVlbc6uQ+ip0tfHhkb7EqBHsJn1907Nq9k6XpMX+Fv9L0vbV4PeD1Ki5CuKaHUW3RNslaGKtR27lFb5UCN3JJTWborCYuyjKK6cVBe6eoOjSEigEWgIt6IxC7wzM/GqLPQ1pzmF6uU8FkjcfirKFTYVV5fnmDVVYIa+vvdyHcYZByREV+0kBmwnuLMZ1cSlHUISHy/I3GmnEf9+te9M/A+HBpyEjBEI+rZ7m63vEwWcj8skOmqcmmIOu74iQ2JgF4fplPGtFHwW9X4cuW4REf3MQwl7TsmNwHcamjN3ulbrQA21YfRlrZRl8jzdIqbPHCkauK3LoV9OhbXGHGNI3TmLa2RokNtohNVU0h3dschnWuU1Ds2GRF8h7NzETcqhG2U6XO6yAamQLavLD40IozY8TS6gulyMUuhYDfSovJ7BIV9jbrdSpMzZIywn0xvWoySxztguYNyfuTc4ZeYdfuf2oFowvggavAUv3P0XrytU6HP9Pj3cc0FgjT5HGJBpNWc08MC5Zoyrhb4PHHLY/dRLAC3WfKxLWuxTmbH3zCMQh24E1zSIYv9q7vuFqB2VTBGO+9632qjj/BZH1cYeTB1IV0jwmu62jpCQtSGFx1AFxDycYLAhvnWmzfEqFFmEZ46ATFk7h/LNJjbxnuKdT0J
 kDkrkK7c
 do88/zRP08f43G6jVQsSnzHaqCs08w0Nvpk8UXY1ax99wZOY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 04:07:54PM -0800, Vishal Moola (Oracle) wrote:
> On Wed, Feb 11, 2026 at 02:18:20PM -0800, Vishal Moola (Oracle) wrote:
> > On Wed, Feb 11, 2026 at 12:13:10PM -0800, Dave Hansen wrote:
> > > On 2/11/26 11:52, Vishal Moola (Oracle) wrote:
> > > > +/**
> > > > + * pgtable_alloc_addr - Allocate pagetables to get an address
> > > > + * @gfp:       GFP flags
> > > > + * @order:     desired pagetable order
> > > 
> > > FWIW, I don't like how pgtable_alloc_addr() looks in practice. It reads
> > > like it is: "allocate a page table address", not "allocate a page
> > > table". I don't have a better suggestion other than having:
> > 
> > Hmmm. I meant for it to read "allocate a page table and get its address."
> > 
> > > 	pgtable_alloc()
> > > 
> > > that returns a page table pointer, a void*, and:
> > 
> > Initially, I intended to name it pgtable_alloc() & pgtable_free(). I saw
> > arm using pgtable_alloc() and powerpc using pgtable_free(), so I looked
> > for another name.
> 
> I've done some digging about these names.
> The arm cases uses a function pointer, so we should be able to use that
> name without issue.

Dave, I wanted to follow up on the below question:

> What do you think is a reasonable name for freeing?
>
> pgtable_free() is defined for sparc and powerpc. I could rename them
> prefixed with "__" to get the name since they only have 1-2 internal
> callers.

Matthew brought another question to my attention in this particular
scenario. Should pat/set_memory's alloc_*_page() use pte_alloc_one()
instead of get_zeroed_page()? Is there any reason not to?

