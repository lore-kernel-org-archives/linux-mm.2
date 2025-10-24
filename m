Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0348DCCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 15:06:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F9E48E00B1; Fri, 24 Oct 2025 11:06:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D0D28E0042; Fri, 24 Oct 2025 11:06:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40DD68E00B1; Fri, 24 Oct 2025 11:06:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2E5E38E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:06:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DF0C14963E
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:06:49 +0000 (UTC)
X-FDA: 84033334938.29.F89AEA5
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0AF3F4000D
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:06:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=RumWiha4;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761318408; a=rsa-sha256;
	cv=none;
	b=cVr1FnTuib+cemnK6YbwECAzEixKjqhyCrRBMBXWY9vGuwst9Ga6DlPTgjDAqXThlPQg+R
	y4rTojcXdxi9xgrcbMznEZkoG1MSLoVpTtxvZyJhANB7alUsg45yPUVaGkOKTAQKtKVFC+
	D/7alG5RyiZ3143qSIDeUx+bFRpvTOQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=RumWiha4;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761318408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tAggPenHEekpw1xsWjUuRRKCQ64Rzgw+ORJ7ssWDMm4=;
	b=lwfnpZcLImL9V1ljEwv6CqO5iE78EUarIKHOh7Nz97FxGEL714gp3gNKZ+1rxAs+OenL5Q
	NOZX07eMD9akKkoFhxYGAkQqbpgFPKCj3/g/EJ0EvMq4egxUtY7R5riLa2VHnD6xrSdEhO
	wv+oF1HEvdUBAtwjqnr6/TPlFZjQobw=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-61feb87fe26so3736170a12.1
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761318406; x=1761923206; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tAggPenHEekpw1xsWjUuRRKCQ64Rzgw+ORJ7ssWDMm4=;
        b=RumWiha4JaFldvjNHVq90qJuOStZPhvcmM7s6X6L87sMuiB9W06uFaHe45vedSY/I0
         /JgahLDnvzazqE96nTeCB5OPUkgaZV6vUsyT9t4QYeT16T3vrchKbgA6SmZTdpSY5X30
         waXpGmfzHXbWhWiL4/jC87vbt+p+c6wQwJw1YONykoUEuFVtiIo15nKvZIAjLwaM0btH
         tT7QKzZxnEwCV32AuV2Uc0uItVIeB6nCw7oOt0KiemzGGbeu23UM6wIge+Wfy5bTExL+
         xKELrWp0RqLefplgjepH8okuXrNI50Mhd4//TtHuXzKJW5qzBTDbCjScijq1vEkD1pX2
         aDcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761318406; x=1761923206;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tAggPenHEekpw1xsWjUuRRKCQ64Rzgw+ORJ7ssWDMm4=;
        b=TW3VYMSsmt0UE9pqcdfua/2uFWZT8Epq0qToanJ1/NH7OeTLP1B+sJTzHi6V5WwOtD
         uIsFw7CCBLW7KWaIP2oDBRmIv571BgjUhH5NeeHlmQw09TZIfdSwQ+5NP6eYgOcVzcwX
         A/MwWJVPo7fPwKj+tbAKJ9afU6WwPuaKYzShX0S2Klu5T0/H1czuMBDqNRZqoagNEge9
         Zb1bj+TAWGXUZPcXJbvUBaUJS6zfrGlSs4uBReics3UQ0QKtQZ5jcWWymu7ErqUklrBB
         Z5vd/+wp62I9QmI266xO1NE8MAOvXqzHyafbjwCLkP2IED4g2pQrJVMUXHE1hEChhvWf
         5E6w==
X-Forwarded-Encrypted: i=1; AJvYcCV2vV0VEy8fnjwdM0UgNehDyX/en+YGXoN4ioOT0kteS0NzJWotrhUfgrPlAm4wcn0kfU2k5iKsQg==@kvack.org
X-Gm-Message-State: AOJu0YxXOAT/XU9jbPYhvqY7STk412LQ/y6Q3ummzl4eTUh3bSUzn6ik
	n+0d8yjs7hZgmdPkOtv2pXFB8yLEIOGNB8CMn3W2cR0sYd6+AaRLuWV+hv7AIYNfaCpHtlUAaiS
	3DKmj5sjGL2oDTftQUSnx8gJL8Z/mvBEcW/rK2Uadtg3Me9MyKFfy
X-Gm-Gg: ASbGnctbEIp7XgaD2ZdruIMODkG7WkvwPaGNGKFCVF/IjQziwixA/gsA9qXQG2T+Twt
	dS5kbtCKA1GzWRzQkLfsf839Y+Xm6S3yk57Hkb/6+oABrK39eN4GUGI8XdKR9Ey43THzpDTd4LI
	xfEQ7ORcmPygkVLF3RDiXi9HZfcs6n+gNO0lN6Sm8Nyg8JUI5a67IrONx75HZLAbQ/v9MBxGAej
	OqSAhnRpQm/3W7cSCdwTvdUlZmD6/bZO53MlmN09K7zMbRIZnCFRl8LNhG3yJ/ffYEYj+y+SSQ9
	Ej0=
X-Google-Smtp-Source: AGHT+IGJ6GxYCa8q7rSrU/U7gWUFVxG4yyZcVGPe6x/UkHon/1sZO0bVqDFGJeZ2B7N9o//bnwlEJ/gsM5ocEkK4Mlk=
X-Received: by 2002:a05:6402:13cc:b0:63b:f67b:3781 with SMTP id
 4fb4d7f45d1cf-63e6007d032mr2315279a12.18.1761318406399; Fri, 24 Oct 2025
 08:06:46 -0700 (PDT)
MIME-Version: 1.0
References: <20251015053121.3978358-1-pasha.tatashin@soleen.com>
 <20251015053121.3978358-3-pasha.tatashin@soleen.com> <mafs0v7kgjoxq.fsf@kernel.org>
 <CA+CK2bCG011xf7v9nGMq4WQAUta9wDt05+W8KmRuc-JE7ZTwqg@mail.gmail.com>
 <20251024132509.GB760669@ziepe.ca> <CA+CK2bA_Qb9csWvEQb-zpxgMg7vy+gw9eh0z88QBEdiFdtopMQ@mail.gmail.com>
 <20251024142014.GC760669@ziepe.ca> <CA+CK2bAmPN+v7SYsdHA+RL4kFfnoQvKqTqZ2YQ4wdq6dnFkotg@mail.gmail.com>
 <20251024145508.GD760669@ziepe.ca>
In-Reply-To: <20251024145508.GD760669@ziepe.ca>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 24 Oct 2025 11:06:08 -0400
X-Gm-Features: AWmQ_blMLbNOm0uoJKs5bR4RSgG2ejq2gkg9FwwwkGNR7IXB5OE5p-7PHsMu37Q
Message-ID: <CA+CK2bC2XNKDd497_+mXxQ=3YaA0QwjxjPzQ95WG6O4nhjeoLA@mail.gmail.com>
Subject: Re: [PATCH 2/2] liveupdate: kho: allocate metadata directly from the
 buddy allocator
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Pratyush Yadav <pratyush@kernel.org>, akpm@linux-foundation.org, brauner@kernel.org, 
	corbet@lwn.net, graf@amazon.com, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, rdunlap@infradead.org, rppt@kernel.org, tj@kernel.org, 
	jasonmiu@google.com, dmatlack@google.com, skhawaja@google.com, 
	glider@google.com, elver@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0AF3F4000D
X-Stat-Signature: apjc8zqbb81zcpwmz3s39pounb5jxdda
X-HE-Tag: 1761318407-510716
X-HE-Meta: U2FsdGVkX1+DK3upwYMM8w1xwgPKKw8SmTkRaAB02Bq5pHgN90o6VOy1GAq4KxNcCzgmelGVoel5sRJFy6mU8+JSKZ49XCH4y813jB9i8arFtjJc4WnFBpge9wgPSeC1bO7cah8Rb/HGmYK5Ua+h+WskcXTnkxE3J4pVeXcZSjdqhjJS3eAbZTGHj5csWU4t83aMAAAilLNzx21z3+Zj1bRxpJMxS/7kjhLbxVZpsiILyR5s6iwYa00QN/MwwcSJfeVFLLtCoH+rvJ4OQAe5ZXHDdtgqu8nY0fI/wUNEVwhnIePzC1CszoC3h2DZAekESewJA3vjZBqYupU5pNw1wpp+TUVUQxP57hJSv09BmRDpR7t27kNHRJQ8MAPyCJoo5DP/rlPuLH/ecHTtJXZ7g+hSuTdKOqL8Ulr4t5jUuq95bFlcZM4tIfY9YKpvCqq6tAloLXfZDwSMwpzeW8tpVf74jduN3hhDmctD0ZZFpLhCsiuVny3SlVxb5/mbeBDFyhZOJNv+UaNoWOuQ8TXs1fumzDzSB5pvxQOceDMEITkxdkMXpFYAsOQhUQUMzcKHpEGVBQaRzqZAh2zr+ivV7qxfiK2U29qx9yLAQecBEUJihUCpxTEBDzKwviQzRvp5Ulfv+FiTQTLGOHP1WGtwrFxT3PGr1XFfYCKBLo9ArnW77qumfrxXc+voG+1yJdsC1i/rBCHNvFcZ3+sEhu6bUKnesIrXx+EGDwSnvJfBGI1qr8S83jdO8UBW29hhlbzwNc/hxxHwraIyLXBJRdhz4VXI4709SiwREoxwvDovbKYo5CPx3pE9JtIZodroh3nfgT+dUAh5clwwUI/rhq07stC2pu0OddRRy8m592maYQnkf9hn6s7E810P/lgni8zSqAML+XNxSmzi85inesInKs+40x30SSSD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 10:55=E2=80=AFAM Jason Gunthorpe <jgg@ziepe.ca> wro=
te:
>
> On Fri, Oct 24, 2025 at 10:36:45AM -0400, Pasha Tatashin wrote:
>
> > We do not zero memory on kexec/KHO/LU; instead, the next kernel zeroes
> > memory on demand during allocation. My point is that the KHO interface
> > retrieves a full page in the next kernel, not an individual slab.
> > Consequently, a caller might retrieve data that was preserved as a
> > slab in the previous kernel, expose that data to the user, and
> > unintentionally leak the remaining part of the page as well.
>
> I don't think preventing that is part of the kho threat model..
>
> >
> > > > There's also the inefficiency. The unpreserved parts of that page a=
re
> > > > unusable by the new kernel until the preserved object is freed.
> > >
> > > Thats not how I see slab preservation working. When the slab page
> > > is unpreserved all the free space in that page should be immediately
> > > available to the sucessor kernel.
> >
> > This ties into the same problem. The scenario I'm worried about is:
> > 1. A caller preserves one small slab object.
> > 2. In the new kernel, the caller retrieves the entire page that
> > contains this object.
> > 3. The caller uses the data from that slab object without freeing it.
>
> 4. When slab restores the page it immediately makes all the free slots
>   available on its free list.

Right, we do not have this functionality.

>
> > > other patches are small and allocating a whole page is pretty wastefu=
l
> > > too.
> >
> > If we're going to support this, it would have to be specifically
> > engineered as full slab support for KHO preservation, where the
> > interface retrieves slab objects directly, not the pages they're on,
>
> Yes
>
> > and I think would require using a special GFP_PRESERVED flag.
>
> Maybe so, I was hoping not..
>
> Jason

