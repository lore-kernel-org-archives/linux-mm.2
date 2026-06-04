Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E95A2CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 16:05:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 455606B0005; Thu,  4 Jun 2026 12:05:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4062A6B0088; Thu,  4 Jun 2026 12:05:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F4FA6B008A; Thu,  4 Jun 2026 12:05:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 18AD36B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 12:05:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B078D1401B9
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 16:05:36 +0000 (UTC)
X-FDA: 84842705472.15.E6BC089
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	by imf23.hostedemail.com (Postfix) with ESMTP id 275F114000F
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 16:05:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=YAN04h6W;
	spf=pass (imf23.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.181 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780589134;
	b=ADu2pthXvKS4eXiwsTI9de2IJoGCKG0K8Ew+r1fnpCEIuVTlXwuNiFFSmXkyEjHeyF+dZb
	OMYC76XnDwOwY78pW43q4p9W27+VqwjpE7wg8STx8sRFOBcXTkj59AfKxc+GzdXvk0f9hI
	0CIntIjeeN1VwiGBEAA/9EP22KnLiZ4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=YAN04h6W;
	spf=pass (imf23.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.181 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780589134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7+wqPGUkYgYLzLpNrBl5F+HLbRSqQcg4ZruoWvmFRPs=;
	b=WOKOKXmjpfyQykQlh/UqRkP2DBxqFLJvl4+7a9U25Wze+C806+axhpYEsxCBnGr5qg/ADa
	u1JcvqwKZln1LV9I5Olt9BuUldEe7S0GS2Sjo9RIS/oUTpQkCefK4zL/Mu4k3lM83ZzqDD
	ErbqscWPc1qTLVTtQEP8WODy2ARhIBY=
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-396775c2720so8230651fa.2
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 09:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780589132; x=1781193932; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7+wqPGUkYgYLzLpNrBl5F+HLbRSqQcg4ZruoWvmFRPs=;
        b=YAN04h6WKs8OrRoVHNRm4MVQo0wUnc7hEaGu0o0aGO0tdNeCGCBvjH3UaeA/ZK6v6L
         nRWr6uKbv3xmTatZ7DHgmkeNelQnhbUkfQ0X5xgstWnn/cLCzR53TAvBvNNMMx2EsvLX
         mS3w1pD95idoJZbv1c4a1ks7A4rPAp0Ojo0JA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780589132; x=1781193932;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7+wqPGUkYgYLzLpNrBl5F+HLbRSqQcg4ZruoWvmFRPs=;
        b=sk3pxzPrnEhclMzjL9sYfFsMBL71FXkUdIPz2EbdDuXmixjkHNC75TnsAN5+x1tgnn
         tKIfcdZSOCfEPiA3rjfTtzsz3p43Tab8AiyUWJAPYzb5kyuzHcdEPI+/aWi7i+aFpwJs
         kKu0XyphCKsDwqnvea6P/RG2/ze16eV1T0UWxZytAjc0fnSdFC3OewVqCMBEbKx+7Bea
         umJWDEqqZ/KMgkD26sfYciVwvlB94MTymi2cEM57fQxEw5W2PIRzyN7JBIsdPlhjC4qk
         fYyXXZdKoMG1a6h9ACl8P13Mfm1M2xYnV8JNaCkC0txHpTZj6NaL5mQ6xwtwccRz3h+t
         bu9g==
X-Forwarded-Encrypted: i=1; AFNElJ91oi+u44rEHpKz1dW2FPmEMc5WB6Qe6p8AJg3xVu/DNgVVlrjnuQD3EWcD05pHu6bUav2e+AH1TA==@kvack.org
X-Gm-Message-State: AOJu0YyI3IeMGXEa2XlfBShf5bB7gnL5OAGHxz8wC4wEDhrhsWBZy+8i
	gx6hAfckV5i/4QbgBNGe1DAC/LiYNr+EZ4rD6R45EL5jMgUycQMuDebyNFVVaiyd/M3oxWypA18
	rPRmBdZr4+g==
X-Gm-Gg: Acq92OEGsQnqlsyqzijNMxilpttGkUdiMWNR3ATISksTqXVhmLTHf8DU9lr0yVtBkv8
	sXNiUrxN5kwDYfG9Y45kHQl0qkAo/7hOLOnpbW9oRWfGbCDP710bgz9uhCNLRM9SG6iivf1p61x
	0okprLfhVZs0NgmQf9mdH4L74A463x1CAR0mN2/PmESGxFVLP3hHOXASdKa/IAg11b4IXzwsTYI
	MqJMGakgEeiQefqaTkw+YbSSea/AbQrmFCl2SnDO1fTd+7aDQ1JnrHZuwnQywKOuFhn6rGG32kn
	DxyW80179WQoWDCMkVjtodRDbG0ReezeznyeRDZh2m2R4h1CSMvKP0i+iCEgfpvcfaCxALUmA/e
	+m8kwBl9xUZ58qNB0fTMcOQ+adPtgKnoYy3u6MphIK3UsI99/L5M+sv3oiI/nVBxSdYI8us1Dgy
	B/qUoCaHdqiLxpGdxhwLFSB/MLFNcCgWg7OIjtWt/TLb8AU8kToRdryWz6ecYLDpX7w2MUkBKmV
	IrNHt3f7rURPY0=
X-Received: by 2002:a05:651c:50d:b0:396:8eb7:e70c with SMTP id 38308e7fff4ca-396af0f3c35mr27595961fa.3.1780589131891;
        Thu, 04 Jun 2026 09:05:31 -0700 (PDT)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com. [209.85.208.180])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-396ac2be04esm18131471fa.25.2026.06.04.09.05.31
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2026 09:05:31 -0700 (PDT)
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-39657d28132so7042641fa.3
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 09:05:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9HILE1agCUQsjkjbZ+f9jzwohMIbf6hHQ8R6JMbPfABhWA87NskhHqiAMFAH72Fw1uCzUNglEnLw==@kvack.org
X-Received: by 2002:a05:6402:268d:b0:68d:235a:cdaf with SMTP id
 4fb4d7f45d1cf-68e6e447981mr4450863a12.5.1780588730255; Thu, 04 Jun 2026
 08:58:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
 <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
 <20260601173325.GH2636677@ZenIV> <20260601160455.2c187574@gandalf.local.home>
 <20260601172825.a51a588ec1c32617a0e12d78@linux-foundation.org>
 <aiEb8CTM-ovMIq7-@1wt.eu> <CAHk-=wiQB-j53cTs9kM4UeXoXPaFj78aJe3D6Yp1Fohg7i4tWA@mail.gmail.com>
 <aiGfgRch99l_5z11@1wt.eu>
In-Reply-To: <aiGfgRch99l_5z11@1wt.eu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 4 Jun 2026 08:58:33 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg0e8pP5haNW4qJP1=QwwUEctwjK5k07sv8bskitoMDgg@mail.gmail.com>
X-Gm-Features: AVVi8Cfm3XRgcYqAOfqktIkPjsqV4jnNlBPsed_wU8pvtWHjKA_FxUEOuJC1FXo
Message-ID: <CAHk-=wg0e8pP5haNW4qJP1=QwwUEctwjK5k07sv8bskitoMDgg@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Willy Tarreau <w@1wt.eu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Askar Safin <safinaskar@gmail.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-api@vger.kernel.org, netdev@vger.kernel.org, 
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, 
	David Hildenbrand <david@kernel.org>, Pedro Falcato <pfalcato@suse.de>, Miklos Szeredi <miklos@szeredi.hu>, 
	patches@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 275F114000F
X-Rspam-User: 
X-Stat-Signature: z3ystfnnpjdqfia979tnqqjnch7au8a7
X-HE-Tag: 1780589133-140443
X-HE-Meta: U2FsdGVkX1+fqn4ZBrZ71yBQ6K4IwTsyMm8ZLuJx8ETTfBRu1AcwthZSLIUQ9Y28NcrjHM3C08t8poLCfHBEmvCZM/i8Bt0eP5gR41QD2LgNqwjUpGWjUAj4YcqcDiQjraDtQjzm2GQxXavny2oS5BdwEOlvoZtUg53OqoU1z08fCfe6TnKGAM6ZwuHy6nscgk+Phsob05+NbVWsRNVV7+Rvk8chQVdGHsy8LbqqMYgchLqJ5IBNH6C9MKq/LMjerLLFJCkAsh1Tev3i8pCm+nwetRtB3mW+Tw5CzwusCsQZBgMKnbIUTK6PQ/3gvee6BiEsTO29CJNUSB2gR+qMhLERSzvMbfNJbHZTrshjYjQz2oK/arUDSEDgQ6fLW57Ud2suMM7sOwJxO2PiO+1kq4up9GzkpVDtvpRwCjaWYLcjaV2XuaAGjxyeGupvKzN8cq8712W1FtOZSdMKYO6CwZfhWmv1R0mTDaf+WboMVrbrrRmaWLgKiLTvOnmRT/a+OpYETJ3SQ69jJdOzODbijHK58BNsc5DqcaXFEtq8liYxcnPP56+Tr5ObWH2CVrMsuOfueuIAL1N3suMqB65xhwdoa3aUcqG41eJyilEYQcxoc/B8/SQBRaygPYLZnSQksHPFUNImw3cMzUZt61g1ZCP7Rif1LQB6WiatXwYVXRPIFfXqd63zada4wr0VMwnS1XnxRmdH3y9oKsF+62ZaV4hW3C2GLiHDAr0PxZSrVcA1Ba/BKrIbPTvGJ6hzcltcArV4WCjiYnTIQvfqld9NSd+XWI/wa+/vV3bMEUs3SbQddh8GM24TN/NZqkgH8NSo6RT1d6fLMSSM5mRsp1MG7iUV5Fj9FT06HnNhsBRY8kPfeEt00q1z9rP02FUqu2iUlBaHlusXFX5TuBtHEJgIu1Vt1weJl/vvTS9+vkzjqbqGOoskoL8O6a5oyiTaCaBaWfWaTrHNdvCS9nabUAT
 oa1XmtRe
 aU2w4UxB0pAOWw4B/sj29xqzL3DTcEdafY0p4rySfgrL1pPlKlFvLdEGARs9+OuO27zZ1a4uthuGf6tSl/VfVLn1mEIwf0Vxo5YmY5F3TCtAEjRwewQsziGfB9epO2xxsEO8NTyRpHRGFqsI9sOAZHKmfwLfzFm2wx/VWVlzfM8TUNRpEpKJkyqGUHNCxWwyvWHC4QXc9Sc/cSVlPH402UBqE+g+6E782w1A2rWyVG++hJ1js8L+TTIF3oEzAnT5aw7xWeqNie+rRTjWcsVxoIBCVESJ2hdJZRB6sxsdv/z3eNV6+o8VE9oYEwa09/oanVBOe/vlsF9x/lLMfYmd9B2DpwnrqC3wnYR27vDGvuii4/I511o58ffulpMl4bHwmZ1rehEp/vle9ZvE56eVr57sfsLo8uYXJQi3Ye4yXfDJzsC3dBi3p7Xl86+jCRrBsqSPtbN5z6wATYkN3AxZ7SERAiIFt6oiSp3vRmjAshpsHu58C/EJA49ElqC+GcERPkcw5jRz5Ogue8GgxvZGY67Ssvh+kf4tayBBR4RV6gQtrZ2KtDr0B2sanail5RKk/8UXr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 4 Jun 2026 at 08:53, Willy Tarreau <w@1wt.eu> wrote:
>
> > It looks like you're actually doing exactly the thing that I thought
> > was crazy and wouldn't even work reliably: you change the
> > common_response[] contents dynamically *after* the vmsplice, and
> > depend on the fact that changing it in user space changes the buffer
> > in the pipe too.
>
> No no, it's definitely not doing that (or it's a bug, but it's not
> supposed to happen). I'm perfectly aware that one must definitely not
> do that, and it's a guarantee the user of vmsplice() must provide.

Whew, good.

In that case, can you just try the vmsplice patch series (Christian
already found a bug, but I don't think it will necessarily matter in
practice - famous last words) and that test patch of mine, and see if
it all (a) works for you and (b) if you have any numbers for
performance that would be *great*.

There aren't many obvious splice users out there, and even if they
were to exist they are typically specialized enough that you have to
have a real use case to then tell if the patches make a difference in
real life or not.

So you testing that thing would seem to be a great first test of
whether any of this is realistic..

               Linus

