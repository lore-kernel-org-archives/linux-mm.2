Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55DFBCCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:34:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E1BF800C1; Mon, 27 Oct 2025 19:34:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B80E8009B; Mon, 27 Oct 2025 19:34:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CEC0800C1; Mon, 27 Oct 2025 19:34:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 72EB48009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:34:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 032E6160289
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:34:34 +0000 (UTC)
X-FDA: 84045500910.17.363F2D0
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf11.hostedemail.com (Postfix) with ESMTP id 145C240004
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:34:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=osandov-com.20230601.gappssmtp.com header.s=20230601 header.b=YxCfl5aM
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761608073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uPCmD4uzhtfswoc/l5V0R9c2cekIs5r3x52JtrQEQ6g=;
	b=jh0UtRLClQMAneKVdBo9dwhLqnmA9h0jVJFgu58y82CBGtjmIUgNSODTCkj6ckXp2YUP8H
	WLdCdZRHvRRBJXgs/JYlgmzDRNUO9i7ACzuGXLYNP9LWykCIzSH+Rc4Uga1+jqJ9aKm1ev
	AjG8iQXW8jGGCWP/s94/zas5iwi5jE4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761608073; a=rsa-sha256;
	cv=none;
	b=70lcFesuW3SM9FL+2nRrGIc2Hm+aHteACN46NsraGD31TeUC3zUZVgJ4MzYTwVN8YWeYdL
	dSFG5oS7paMmd6WeBVOC6dCXnZ7eN0+s5qzvD+j8AYYqfT+oLSed2yhsRMDjp2mxyU3WGd
	aqdD30Bk3JG04sV9ruCVNYN26PtaGz0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=osandov-com.20230601.gappssmtp.com header.s=20230601 header.b=YxCfl5aM;
	dmarc=none;
	spf=none (imf11.hostedemail.com: domain of osandov@osandov.com has no SPF policy when checking 209.85.216.47) smtp.mailfrom=osandov@osandov.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-33bb66c96a1so1552719a91.1
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20230601.gappssmtp.com; s=20230601; t=1761608072; x=1762212872; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uPCmD4uzhtfswoc/l5V0R9c2cekIs5r3x52JtrQEQ6g=;
        b=YxCfl5aM0eaT8Pl+/p7wfHg+K+ELt0/o10GRIYtr4/y0PvGaQyXhdrdzjiIa7WvbPZ
         8lG+qvocGcv27+Z2xgE+Nl9JCpK55M4WFFFYnrt77O4bBGntjld80qlavU1hwug9/4XG
         SP8zL/eMVypCk3CtziPsS3oZDjLzzSdV3oR6GRr6W99fPj83gQLLcDzls15/RaDh0MDf
         lSDBgHK/SWjZGU+tKCsiE+wNqPPsYbRdw+utEaarAxiDmPt3iCq/ekxTJyBdHGNOdMth
         MqODKCCW3Nb5E7RewfOJPR8l1d5C/pzQ6B4Yun0ermzRBFZA+87l4FsC0S1Uzeq/XSgS
         Mwsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761608072; x=1762212872;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uPCmD4uzhtfswoc/l5V0R9c2cekIs5r3x52JtrQEQ6g=;
        b=he/dH7Akn55Rz8Q1aDoBjE+8IbIpi9Z5HqEsxDxIvePoHiJRQd0JaaFQPG2NvidYs3
         gPr+em1aBvD5wRisMQ7oJWIE6eRP85uxYN5rLMSpEYm1n6HX8Win7I4py15UXQlai04V
         rzwBIPn2hAETszRx4hWJRZow2u8jd4DOMfZpQPlJLMZbCEk875Z6OV1tiN0/8igssVkq
         PTysgEvaGbfieQkjpALkk/aROymqWhXQTbexNLEx9joyu+ctz64hhc2fM3l1IKUCU8YS
         TD7IPILQ2ilmkOVKpNXcOwxCFAtcmYSXvm0QvLNP58RpxImtvLJn/T4Jd3VUflKo18SI
         wHiw==
X-Forwarded-Encrypted: i=1; AJvYcCVlqS0b83IRdZ4wgSseH68hbTZcOF8Pug2JmPCTjlBW2lOATeMqVT2AyqKt7AsyT84gcNyVBg7U8w==@kvack.org
X-Gm-Message-State: AOJu0YxmbwhQ37SEbvd591nU7Ivr4GByNBtFt2XfSovXXSSjQx+dsONa
	RzWK5SsrFZ40h5fddZpJa51oGhjgWBlLM4NhHKl6nMpu9RP08OkMypFoo4bFk2xbjCE=
X-Gm-Gg: ASbGncvuavm9tb7oqkUGLiB14B6d4MEb81LEo91QMPGKlIZM1QUUkUuuJA7F3Voy7i7
	uoerDHDKhTQimZiV/HXZvhBuPRR9TktH9VLLoGAtuyPvxPIG/opvStM8PuplTPCor2rewJe25cI
	bHZGgf+XyXlJWMzAXCYwy8vMLbnRoBn/XXEc3Jyb0p78b3zMWvJJDUqQtpeVLlYwK9x82PGg0Vk
	u9rIgimRKAt3Sno9/Niot+ZXglDKb3v9t9IOMzIZdh2G5SRL7GQcBXcb8FfGrvN0l1Fq1OYLKr1
	/JWdTCCNWy54i43qYYuq59azeNs0yzW9YlvSHzi0cL0xkvmn+FkUanadUakLLAbd5SKtn7N6dfE
	g8s1W7D4bshoWDd4W1f07oRfZBdO3kLHY+/8oLlJZoQhm1U37TrADk/mVkjmXJSQyDxo=
X-Google-Smtp-Source: AGHT+IF+fIC8nkEhc1qH8rsvSrdHlsUcfw3Mhoj6ntlufIF+zqKXRzzjo2Jm1L6py6bmWl1j/Yu00g==
X-Received: by 2002:a17:902:db11:b0:25c:9a33:95fb with SMTP id d9443c01a7336-294cb502797mr8728975ad.8.1761608071589;
        Mon, 27 Oct 2025 16:34:31 -0700 (PDT)
Received: from telecaster ([2620:10d:c090:500::4:c4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498d273cdsm93594155ad.55.2025.10.27.16.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 16:34:31 -0700 (PDT)
Date: Mon, 27 Oct 2025 16:34:29 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>,
	Israel Batista <linux@israelbatista.dev.br>,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-debuggers@vger.kernel.org
Subject: Re: [PATCH] mm: Convert memory block states (MEM_*) macros to enum
Message-ID: <aQABhaMC8xfO2Vem@telecaster>
References: <20251026162156.12141-1-linux@israelbatista.dev.br>
 <811fd675-b231-45e4-b9d5-636fe63bde6b@redhat.com>
 <aP-2x314BKks2_N9@telecaster>
 <3d3bfa52-3e13-4d23-8ef7-6cb8b1ab7d79@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d3bfa52-3e13-4d23-8ef7-6cb8b1ab7d79@lucifer.local>
X-Rspamd-Server: rspam01
X-Stat-Signature: cp3ie48qgeyafyfggkzo14ohxmtbr1ix
X-Rspam-User: 
X-Rspamd-Queue-Id: 145C240004
X-HE-Tag: 1761608072-923463
X-HE-Meta: U2FsdGVkX1+nr1/EentDYgYbFQVOypQ5Ss74bsVVGxGuBRS8geN0Nv+vzNjMJ03AJ042IdeF41z09fN7+uWLxs/DeW5dKiTPgV6oqOwdXYwq2LXk4oz63R9vw4Q5plmBjE5rHAlZhvszYAwRvTozKg3WmsA6YaJQU8s3q2iOdO8z8FHZIWiysgdQ0ow8DoqLPBr6LIqVWCodT0eiCcTCV1wQVGykAp/WHHQ4btB1FudUpRo0YBICVJC5CZvlCk8nMwIn9BAM7WA81AXhDDlKMPP+lE1MsroIWSMjX76+blKXH+Ek/45DSkjopl2Z6pmPOI7DwaP9aVIH23tJp3yvAXnmgMBVg16S2vxJFsGzxG2IWEnCuMLriFhxP5H/VWkVMxHhHO3cMVLm+bx2q6XLF7xvwAYbAaLPzxq8x8yR8j0ztrcxEgzsjw9A8OtEjvEDEvMdpRJ6LA/rHcYhVwuG9q6dNkFKMadGueCQnfdx1+tzym8D+UnSG1D1tPYuEZvlV9SM8Oy3eiAUHSBPADsnbOepOBHhW/MjJODiKjZ3X34ZJTBIX4JMaq6s19V6yK5YeA3p3uHnGW4IurI0lYbs1rC6CkDz59sVi+M+7l8VK9KU+pQtFhkKB2zKXjVgmYYwISgz07KNJLU6UQhLeurIx/iB5o0zsfAEKWjUK+sOOBSd6VGBywBOX0N90GiDEG47BoVM2rf2nj3GTBnQJKPHzQrCK0RVpFb5VwRuMsudfPFshS78FR7t3oZnR2JJ95gx08U+QKivWup25GgLNtDUa6vgLjsZC9V/OE2y9lAeMFaPkEJCMJLtnN29n0KwMLUN77V2/Bos15ng+U2UHlCCfkZrG29iic80K6XRnxlByRmJl5TRzpCqF43lQ/bQHNqcHgtyvvAXSxBdM54iZQcMhe7K8/MiTWiabsgs4o3QTOf/F6YrtSvFLyCHMidtcwBWKqeq1ZiUwM+tDNKzTvA
 L1vt9T6Y
 NJqQAS9fXGy494YchbZjE/mMceS5K3sn4TdlQj+DQNiYC74PFiJsCl6IO0txVeync5wwNh2J1b+k7cnoFjbAFn6EvCxjzpl6qRiX5Jmz+FqaC22o4bgb6d5O3UNhND1Wtaddj1yK+V5d7wo9Ap2t23eodO2A9qwBoPuphwiDAG4ozovbhekIgoemM1KVEJ23hfrXxseGyOsJUJ9YUD07Dg3Dza2dBYfaqElVHtqNvBi0VmktC88/RHn+MPY33fWdFsc6UaNGPkee+Nn3PMdmTTjeSgFrHSXd53V67bql6oKQuja8ErRWDgkekZlbRVd6wRhq4UIuC4Kl/f5DG+bPFGRuEGVRRf33hnETY8Q9NwW+FlcfLOBziCnuCC14V5GveUCkZOesOWkSAi8OtsNRvvv+TIWlD2u+dQBrIPJhl80M34h8CFVS+iSz0mw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 07:46:43PM +0000, Lorenzo Stoakes wrote:
> On Mon, Oct 27, 2025 at 11:15:35AM -0700, Omar Sandoval wrote:
> > On Mon, Oct 27, 2025 at 10:29:15AM +0100, David Hildenbrand wrote:
> > > On 26.10.25 17:22, Israel Batista wrote:
> > > > The MEM_* constants indicating the state of the memory block are
> > > > currently defined as macros, meaning their definitions will be omitted
> > > > from the debuginfo on most kernel builds. This makes it harder for
> > > > debuggers to correctly map the block state at runtime, which can be
> > > > quite useful when analysing errors related to memory hot plugging and
> > > > unplugging with tools such as drgn and eBPF.
> > > >
> > > > Converting the constants to an enum will ensure the correct information
> > > > is emitted by the compiler and available for the debugger, without needing
> > > > to hard-code them into the debugger and track their changes.
> > > >
> > > > Signed-off-by: Israel Batista <linux@israelbatista.dev.br>
> > > > ---
> > > >   include/linux/memory.h | 16 +++++++++-------
> > > >   1 file changed, 9 insertions(+), 7 deletions(-)
> > > >
> > > > diff --git a/include/linux/memory.h b/include/linux/memory.h
> > > > index ba1515160894..8feba3bfcd18 100644
> > > > --- a/include/linux/memory.h
> > > > +++ b/include/linux/memory.h
> > > > @@ -89,13 +89,15 @@ int arch_get_memory_phys_device(unsigned long start_pfn);
> > > >   unsigned long memory_block_size_bytes(void);
> > > >   int set_memory_block_size_order(unsigned int order);
> > > > -/* These states are exposed to userspace as text strings in sysfs */
> > > > -#define	MEM_ONLINE		(1<<0) /* exposed to userspace */
> > > > -#define	MEM_GOING_OFFLINE	(1<<1) /* exposed to userspace */
> > > > -#define	MEM_OFFLINE		(1<<2) /* exposed to userspace */
> > > > -#define	MEM_GOING_ONLINE	(1<<3)
> > > > -#define	MEM_CANCEL_ONLINE	(1<<4)
> > > > -#define	MEM_CANCEL_OFFLINE	(1<<5)
> > > > +enum mem_states {
> 
> Why are we naming a type we never use...

As David suggested, naming it means that we can then use it in a way
that enables compiler warnings and documents the code better.

> > > > +	/* These states are exposed to userspace as text strings in sysfs */
> > > > +	MEM_ONLINE		 = (1<<0), /* exposed to userspace */
> > > > +	MEM_GOING_OFFLINE	 = (1<<1), /* exposed to userspace */
> > > > +	MEM_OFFLINE		 = (1<<2), /* exposed to userspace */
> > > > +	MEM_GOING_ONLINE	 = (1<<3),
> > > > +	MEM_CANCEL_ONLINE	 = (1<<4),
> > > > +	MEM_CANCEL_OFFLINE	 = (1<<5),
> > > > +};
> 
> If it has to be named, can we just expose the bits as an enum and the values as
> BIT(...)?
> 
> > > >   struct memory_notify {
> > > >   	unsigned long start_pfn;
> > >
> > > CCing Lorenzo, we recently had a discussion about such conversions.
> >
> > Yeah, I've been asking people to send out these conversions as we
> > encounter them in drgn, but ONLY when the absence of a value in the
> > kernel debugging symbols causes actual problems for drgn. I want it to
> > be clear that we're not spamming these just to cause churn. This is an
> > unfortunate corner case of debug info that leaves us with no other
> > option.
> 
> Right. That really sucks, but I like drgn so if reasonable I do want us to
> make life easier there... :)
> 
> >
> > > The states are mutually exclusive (so no flags), so I wonder if we can just
> > > drop the (1<< X) setting completely.
> >
> > FWIW, putting my C standard committee hat on, there is nothing wrong
> > with combining flags in an enum. C11 is silent on the matter, but C23
> > made this explicit. Quoting 6.7.3.3, paragraph 16: "After possible
> > lvalue conversion a value of the enumerated type behaves the same as the
> > value with the underlying type, in particular with all aspects of
> > promotion, conversion, and arithmetic." Lorenzo may have been thinking
> > of the stricter rules in C++.
> 
> I don't really understand the argument being made there.
> 
> That's just saying the enum behaves as if it's the underlying type? I'm not
> arguing otherwise.
> 
> Consider:
> 
> enum some_name {
> 	X,
> 	Y
> };
> 
> void some_func(enum some_name val)
> {
> 	switch (val) {
> 	case X:
> 		...
> 	case Y:
> 		...
> 	}
> 
> 	// compiler doesn't warn about missing cases.
> }
> 
> This is already giving some sense as to the intuition that enums specify
> all the values as declared specific enumeration values.
> 
> But intuitively, with the enum as a _named_ type, it's _weird_ for there to
> be possible values for it that are not listed.
> 
> The problem here for me is the type being _named_.
> 
> If it's unnamed, then it doesn't really matter, it's just another way of
> declaring the values.

I read
https://lore.kernel.org/all/809f552d-3282-4746-ba49-066d2bd8d44f@lucifer.local/
("it's not valid to have flag values as an enum") as a claim that this
was invalid at the language level, but it sounds like your objection is
more of a personal style preference. Which is totally fine, the MM
subsystem can have whatever rules it wants.

To play devil's advocate, using a named enum for flags makes it easy to
document what flags are used for a given field. I don't know about you,
but I'm often annoyed when I come across an undocumented `unsigned long
flags` and I have to track down what set of flags it uses. And switching
on a flags value doesn't make sense in the first place regardless of
whether it's a macro or enum, so I don't expect that concern to matter
much in practice.

> If drgn needs it named, then just name bit values and use BIT(...).
> 
> >
> > Of course, semantically, it makes more sense to use distinct values in
> > cases like this where the values are not actually flags.
> 
> enum's are kinda defined by being distinct values...
> 
> >
> > > IIRC, these values are not exposed to
> > > user space, only the corresponding names are, see state_show().
> > >
> > >
> > > Won't the compiler now complain that e.g., kcore_callback() does snot handle
> > > all cases? (no default statement)
> >
> > Only if the controlling expression of the switch statement actually has
> > the enum type. All existing code uses unsigned long, so the compiler
> > doesn't care.
> 
> So why are we naming the type... does drgn require it?

Nope, drgn can work with anonymous enum types just fine. As long as
we're all on the same page that naming it/not naming it and using bit
numbers/flag values is a style choice and not a language requirement,
I'm happy with whatever approach makes the maintainers happy.

> Thanks, Lorenzo

