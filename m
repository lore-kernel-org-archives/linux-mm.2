Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AA63CCD1A2
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 21:02:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 622E78E0006; Mon, 20 Oct 2025 17:02:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FA588E0005; Mon, 20 Oct 2025 17:02:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5106A8E0006; Mon, 20 Oct 2025 17:02:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3F66D8E0005
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 17:02:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F21A7583A2
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 21:02:23 +0000 (UTC)
X-FDA: 84019715766.13.6166966
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2A6FC80002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 21:02:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JvWFnz0J;
	spf=pass (imf02.hostedemail.com: domain of chuckwolber@gmail.com designates 209.85.166.181 as permitted sender) smtp.mailfrom=chuckwolber@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760994142; a=rsa-sha256;
	cv=none;
	b=hVXkEQBjpWBiixNSZQql+Ko0PbedmMWHNYr2kkqTf4veH2Om3a/WDFEkFURPy+R3sGuRac
	5k275nZ99bU79vOm2ojS+64r5LwkdoDlFXhEqvCsdSCiZuqch3PJZSB5jcwim9L51PsRnF
	dsE/V/cCErPsbmh6zNq5HCMHyqIAlqE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JvWFnz0J;
	spf=pass (imf02.hostedemail.com: domain of chuckwolber@gmail.com designates 209.85.166.181 as permitted sender) smtp.mailfrom=chuckwolber@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760994142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bEuxap4uXOw4PVhBkZanJl9OA3DpfYNQ9aSaoCPuf2A=;
	b=nGCdL1BW/ZdtFj86GdxT1+1Ev7cV1pO8Z5jqiWCyHK+KZuGFmgLA0ygZvzFiRk3MRHZMhW
	o2mlgvQvuC9xrszY9YN9HY1hUd2t31nsZvc1Ig9iHYkBHdfU75eaBGPf1n1qP56325JfbY
	3wpd0v/bsiF4uvwCZkdJGe4BkcuhQN0=
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-430c180d829so18519845ab.3
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760994141; x=1761598941; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bEuxap4uXOw4PVhBkZanJl9OA3DpfYNQ9aSaoCPuf2A=;
        b=JvWFnz0Jue9d2FRBn53EFEWC7j2LwF46FBLSOPdN8WHwQAdbGTC7YWXNgii96CxhlP
         yShBziJOeazB5Evycmz6hbNHkp6E3cBEIzcqbMnplXEdHpOFnieDKSQOrPuFzF/L/dxX
         EGOT8iCtVeehFEFdCEPNC+SX60rcMCTocfJ+vtuete9bgOBq7AMQOiLQX64J2NWSi53i
         BRZGy1fuTzKshvjSOqUsU/Tl9tbNrAt96HglVaJfVZ/UcH+169+F6aBSGObQGebdtczX
         ScltjcCfA32IJjPKNkq8y1ro8cRn67pk1GZwTeWY2MCtgrj+MRexk085VfrOnxTON2NN
         JH2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760994141; x=1761598941;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bEuxap4uXOw4PVhBkZanJl9OA3DpfYNQ9aSaoCPuf2A=;
        b=J3ZwfPE1yLy2kyRQ9eOd6OGhkT4F3Ku6HhUd9m8nk8IDUIcevasvQD+A4wROUhc19Z
         +Swze+p64/7d7tdKfR1pOUoZR8kmS9Jbqja3N1ffB9JdfFZkHMraCHv3X8ocEzuHI8zc
         ubXMKP96BYoHfimYdV254YFyicuhEZfAnT8wJalHOhZY1tBeJ5mAk0bEk9pGsvF0hvZc
         uOUCZ0D3FcEzC7QMsCAkKhNr7efjq28X/KV692t3kCsC5vbftjAbirqMOAtCCANwuz34
         tkfAGo5+5HoAT9jNzP+915OazjPgYHSwc3B0wSrrE7b1NoExi86gTrQ9hTF/twHt2JgH
         PgZg==
X-Forwarded-Encrypted: i=1; AJvYcCXe9u7btahfuHTpH8FhcOEVoGb8WMCQFTUtCvYDpGX2Fpg0DNSAxEKesLc/Pcq0Z+EzgFyJmy0z+A==@kvack.org
X-Gm-Message-State: AOJu0YyoWRASCWqPtO/R3bZGDj9/UTglux6jfq8HEJSgsUgYtifH+uTe
	DhMsMlwvkN/wnPIEdJNCdYVAFlzcdANOzcbhw8pnkwWBH4jD1Te85Sb6GsLNoVKnRr0sHiBXpsI
	g7ZoXWun1ShFRBPDrTV3eqqBVCT3t6Is=
X-Gm-Gg: ASbGncszA/NL5DjHRiZ14EAd+kwalpEN0SQXC+R4CDdVoNucHBkjdYWFfH2x65bPR/8
	86ByUPimznkxfo6vou3laZDechXkFE9ts2iC9kz83jwdBIv5xQvJ66ZaAvhmakn7KlrodZCNoCW
	PMEMPPdnf4T278BL+G4p57d3vYljMznz+ItZwpPkoiyYrPEyivzSOwJmSPzt1+RjO2I3QCGSiRL
	zf3imhq9mhwUY8s9WcWI54mYK+OD69k0S/G2tGEQ3Pdosy75khUXnhXL8x58UBRj+mHiybPmbQT
	0d/AUspAhsXqi5aXakLjsnI+4db5P9rqoDNIIBrVAI5lKBICHIEq4MK0JL0w3kkvPQr8+ztetJl
	TmV6mXrmg3wZnUINA9mj2GKwKoMDUJYD9YodmP0hOG1DrAnBOs79+N4GK
X-Google-Smtp-Source: AGHT+IGAeJGAQIBM2nto3h7wo4Ux1j4JQv5kFnMFKMPjSOsA8laTc7KGJRta+EANCOydZnJICpXKfizFw0bVF/vJHG0=
X-Received: by 2002:a05:6e02:1fc5:b0:430:e9d2:8f3b with SMTP id
 e9e14a558f8ab-430e9d28f40mr20917205ab.27.1760994140614; Mon, 20 Oct 2025
 14:02:20 -0700 (PDT)
MIME-Version: 1.0
References: <20250910170000.6475-1-gpaoloni@redhat.com> <20250910170000.6475-2-gpaoloni@redhat.com>
 <878qifgxbj.fsf@trenco.lwn.net> <85166a8a-ad54-42d0-a09f-43e0044cf4f4@redhat.com>
In-Reply-To: <85166a8a-ad54-42d0-a09f-43e0044cf4f4@redhat.com>
From: Chuck Wolber <chuckwolber@gmail.com>
Date: Mon, 20 Oct 2025 21:02:02 +0000
X-Gm-Features: AS18NWAdMqoSfNFq5XutKr0MnkgQ82Rnk3fUSUQqpBl0J3sT2E2MC5yWctws4W4
Message-ID: <CAB=6tBQP3aCDWch4ZcEYMqFsJ4OKXSyC_hb9V9hA7ZZty7vFeQ@mail.gmail.com>
Subject: Re: [RFC v2 PATCH 1/3] Documentation: add guidelines for writing
 testable code specifications
To: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Gabriele Paoloni <gpaoloni@redhat.com>, shuah@kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, gregkh@linuxfoundation.org, linux-mm@kvack.org, 
	safety-architecture@lists.elisa.tech, acarmina@redhat.com, 
	kstewart@linuxfoundation.org, chuck@wolber.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: xgc4s1ryqm7op3oixbsgjq43kj64iddj
X-Rspamd-Queue-Id: 2A6FC80002
X-Rspamd-Server: rspam09
X-HE-Tag: 1760994141-635999
X-HE-Meta: U2FsdGVkX18SiuT0rzXCtSYtUtD7iQNZxAmNfItAa+jXuQSrhRE0vweZqomBheg6nIoFisWjUJYdgpbUxDy9P+kc3+KSMxOXBXMX045uZirTWmuf5lxUL4wAyTgJPyU8SbxJ2rYZfkkTBzTvTX+s7dTuh2oe4Kk/IC7XCYG7E6bgt5Ys6+UQlPDOJ/9Xr/tOYnOP0l9dBHFoe7K85JeIrGxH/z/qWcQBEkFympUxxglN3o0fpDNKjXVbwTfEZlMejQ1ky7NJ4BhJIYfmDUO1ohIRdE55NgMqlROEoNXBBt8hYUEddIx1CNX1UyWVRh6QRzXBf/luMbwTJSvI0oj2wr0zxPjF5DeETa6eygyBzkZTkc8kOQjlrA4feUvU6aSAVptqaaLyQ3rPsWwHJYTOHN5I7HIuGYtzF0G0p90Ya3ngMa0fHb4y5v/zK+BF2QpvlkfnGRTzQpy320OMcrFI0hQYJ4zXK81Pdui0IEegcEg/neVzAZ4w1V76FmfHzjQy7tFN/787M6IYfJhlWDqKEmwwYlbot33YprhqzRPT8BBGQK1WnHRXdsVaY1OqVNpzD4wZoLt+Ifmv5qlzAEzNlqOmvUXmyCujwqBnVaE3UgUljzl2XXPypcUrJv1Goj5XoRoMQrIHcBSdzJxjxVXGx2Ok3zzkO1IesjQwOu4cPfm8ndNz/dWU6EQ/h4W48Nb9Lh3tNL5jDSsfvCYC7C3wlw1LqQb0z6s2c0n4sYZcDd0het2SjISEUjLAxuDLSSy50TtSwNZiHVL4Zx/97cqGzIPzfEUpyZ5NKE1zzjMM14wzgLmj67n5jrUYvRVqjFnaMUg4Jgrf8eHvbsRTX+ZzG0lCWa12Ux51TLzcdwoMk7m8TnJ/EuLvxrhvjksO+aKbIhwpd0AmLDC0Qp1pKMYY1BA3aibQ/BVAezV4qLS40JLvSdwRwZKl39Heh0XFZS2gOKDOROslRb6ZEF2oiRY
 Ajke0rUN
 gjIgSzpPcMfxd0QFjQNSabKq7YeMiehUQsUX5ltlfoALfDa+i4iSoG7gJ0LsX1JnGMryEmmBN4FuOTRUWAquJaPqTMGovbJghQsgpo9mgjvIK0k5rhSj8aBytmz8Pfc9LtSJ4hykxS/mAT3OorK1yXY5hwMobtejKCFAZWdDvX9Htr0ozk/fZn76tJX+UAJ0O2203XZMDubdA4n+TbVkqIOOImD33eH6lfSQNbFatc36mahC+5rCts8SfgiUqEjdcFvVeZCoO1h0PxP4mBq6Qbvme+CIPHgpmK0I+Cjt49mahErMMDAbIhYv92ddGDAjAWbsLhgTy9tiUUQH/XAglLNm1uhiOKw2snXYONkyQUACnUzwWTNNVP6xgWyGzW5zQ8UnR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000002, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[Reposting with apologies for the dup and those inflicted by the broken Gma=
il
defaults. I have migrated away from Gmail, but some threads are still stuck
there.]

On Mon, Oct 20, 2025 at 7:35=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
>
> >> +------------
> >> +The Documentation/doc-guide/kernel-doc.rst chapter describes how to d=
ocument the code using the kernel-doc format, however it does not specify t=
he criteria to be followed for writing testable specifications; i.e. specif=
ications that can be used to for the semantic description of low level requ=
irements.
> >
> > Please, for any future versions, stick to the 80-column limit; this is
> > especially important for text files that you want humans to read.
> >
> > As a nit, you don't need to start by saying what other documents don't
> > do, just describe the purpose of *this* document.
> >
> > More substantially ... I got a way into this document before realizing
> > that you were describing an addition to the format of kerneldoc
> > comments.  That would be good to make clear from the outset.
> >
> > What I still don't really understand is what is the *purpose* of this
> > formalized text?  What will be consuming it?  You're asking for a fair
> > amount of effort to write and maintain these descriptions; what's in it
> > for the people who do that work?
>
> I might be wrong, but sounds to me like someone intends to feed this to
> AI to generate tests or code.

Absolutely not the intent. This is about the lossy process of converting hu=
man
ideas to code. Reliably going from code to test requires an understanding o=
f
what was lost in translation. This project is about filling that gap.


> In that case, no thanks.
>
> I'm pretty sure we don't want this.

Nor I. If you find any references in our work that amount to a validation o=
f
your concerns, please bring them to our attention.


..Ch:W..

