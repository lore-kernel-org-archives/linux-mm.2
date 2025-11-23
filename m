Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B569BCFC518
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 19:30:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7D9C6B009E; Sun, 23 Nov 2025 14:30:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5AE16B009F; Sun, 23 Nov 2025 14:30:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6B5E6B00A0; Sun, 23 Nov 2025 14:30:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C2AC86B009E
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 14:30:27 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 642F11A0137
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 19:30:27 +0000 (UTC)
X-FDA: 84142863294.29.986B3C5
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7F004120003
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 19:30:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=eTlXLQN1;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763926225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XzqHK/TIOOgnA9zIhGUtOJHBTL40HX8egZzA4W6eWFI=;
	b=hhHGgt9/rxb2Lyr8U+YpoHuiiKdGn21it7aC4OlSh2hfeqEWtBEL8KhwjdnPsp1nlRDsxB
	43mzUxOLJ+vyjqw5du1FqwDJOmWtd97ez+Qt2t7AW3pCkdPTQtpoyohRmf0BU7HZWBvdkl
	o7YTAfoqjX85wh+WUgAWlooYMqvPN5s=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=eTlXLQN1;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763926225; a=rsa-sha256;
	cv=none;
	b=VH3PzdXIZXqGBp7zhhDj5klb4GiU9st6mybEWB5ycnbQRJiTqzIu0d+kQH1yrHxS2e2+fP
	d2BebREh4K+TlJbxUrC66iuvQjOvmYc6tEjOc5hb4f4DyU1toqckZITnLgloGDQTWCaSh9
	UFuVuupqzdA8o0Gs1bTY/hUB5G+is8E=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-640b06fa959so6093048a12.3
        for <linux-mm@kvack.org>; Sun, 23 Nov 2025 11:30:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763926224; x=1764531024; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XzqHK/TIOOgnA9zIhGUtOJHBTL40HX8egZzA4W6eWFI=;
        b=eTlXLQN1IHZK7Wz+AY06niouT4kHTWIXHH8d1UOYnhHUKHHvlrf6rCvAxKtfV+DIiB
         3Fm06Gq9sDBQFzXq6+125VoeZHDrQWxCMeoQ+n9zkB2xghTWImom77qpkbSsTLUvngh8
         hxCZMOc1yx4y1Tbpo2oSsJctaMiOVkyZBCCOX34hjpWXB6XiVImmzgxwgL5l8laJMxUQ
         G7w0mX6W5coRQ9ngh4+9ics6GFdHzPujBq20V1IEPUldxkSSL1bVkhdCT43trNmhqFyk
         jveZuMvaGWlhzGsO6JIawRL8JlB4t6n23PaT4qz5A0xXfTgbXp12yJ3A0WJ9s4qoAu70
         PQ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763926224; x=1764531024;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XzqHK/TIOOgnA9zIhGUtOJHBTL40HX8egZzA4W6eWFI=;
        b=TPDpYBw2nQ+Akh6OU9xN0wSA3Nyd2rjsdWO3AySnaBVY3WmGyJ6MdR/exDfMU8+qPZ
         Pk1TmdoqXXD6sRAfkKO9nNxfqg5i/gaxkyxb5BLXnfux0LkndwlQjtoOQ5rk/OAk1R8O
         26Wi3r4CjHazAUhVIK6I5+nuofzK5mFOPaysGiAPM9ho7UHEGIeeGTOiJtp1x7xO85nQ
         SW9+4VOnlcueZ/2LJviWsBOylQqLKTZKih3GBzSAq25deHpxkOF40UFTxJ+2hptIKGvi
         SpFF3/w48PJcUjp75s2i0NDxFAjRjMV4BUKBerBRFnaP5tP2rnv2hcMPfEgq7kLdYdYG
         IgVA==
X-Forwarded-Encrypted: i=1; AJvYcCWV3wgj8Y4TMkulxYl5ASQdVDM8tT3ZtPvkJfk2U79gS40+ThthUHtH/2D6S8q1WtlHiE9R4kBywA==@kvack.org
X-Gm-Message-State: AOJu0YzZ0glmrfaj6NKpDGYwUP4ysj6+s9P3EQrBH8V96lL0rOa1bAwA
	2WsfLx3ucLlGvJuEdTtJc252izhqp661jVP0d8fdhtDlKoxG9KE7tzP853+IL1fZFwGzrpPAxXE
	zIcacm/aOhADR8NrdoRxGxJdB691N0dzIkTwnPaAz9g==
X-Gm-Gg: ASbGnctDQgF+s9geavHesRfxpvIp3k2Fmn6EpyWk8mTSftlaoXyk5nFlFcL20hht4u0
	8Z+gbGuFMHbkmHb/R8jFT7vWF7n2iifvATyDLoyc23shb2numxvx9sqkk+6ecEKvaqb4jYfaEA+
	F0PyFJeZ6emAK/fhp4M2+jtibb0O6kLkDBEC007INW+V5q5ikPi4abdlIc5v+Inog4IMBSA4VGE
	QuUra0wqlIw2KWXK7bC49kemiNJJBVbUaPfuut/gFPrb29bJvWm4j5A21e3ln4oSfSU
X-Google-Smtp-Source: AGHT+IE05jz80rZyj75VVfkojSuXeLlQ8FesBIh1qUPzdQMfW1RSq+XVJJpyUf5jF0hPWhI5fJ55dpas+SZJguxrA/U=
X-Received: by 2002:a05:6402:27c8:b0:634:b7a2:3eaf with SMTP id
 4fb4d7f45d1cf-64554664dd9mr9384496a12.18.1763926223214; Sun, 23 Nov 2025
 11:30:23 -0800 (PST)
MIME-Version: 1.0
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
 <20251122222351.1059049-9-pasha.tatashin@soleen.com> <aSMwsLstAutayHbC@kernel.org>
In-Reply-To: <aSMwsLstAutayHbC@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sun, 23 Nov 2025 14:29:47 -0500
X-Gm-Features: AWmQ_bk8jtjaq-w2yB5rB_UsOYzOhWiPvf-U2Ch5k2I-jXXb8CYrf-XuoPC_iX0
Message-ID: <CA+CK2bC6_Ls0AthtWHmFH7hc-ER1uaG11Ques0=zVyozP-gyOA@mail.gmail.com>
Subject: Re: [PATCH v7 08/22] docs: add luo documentation
To: Mike Rapoport <rppt@kernel.org>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, 
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr, 
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com, 
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com, 
	vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com, 
	david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org, 
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org, 
	cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com, 
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com, 
	aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7F004120003
X-Stat-Signature: g8pu8t1qpmhcntpney8mr6dx8hkc6yoe
X-Rspam-User: 
X-HE-Tag: 1763926225-222366
X-HE-Meta: U2FsdGVkX1/G5s535KfdNa1VHd3LL7mejCvCRVdduoWg//YKgATRE1KOcp8Qs4TwJ2KYvXzDGgJGvLLy3mLH3QTZPoFLiKfV48gkmCkD8vxDFR41VYZQGD3GRc3Ah2SHiLyDBD6wjULdPxb+XgsPZr+M6mEwX/ijC95ohRMmda0Nk8V/HSWaEMUzHQa2xm4cj9KuDjxZceTnJq+GME7U1yDgXxJReyPf+24yEXh/+rg301YCmwyJFiqMc9mdesJnrV0S5aCq3b0anxcYHtIZy8fcpgTkqxTvJZ/fbN8E2q7LQVHo/Af/F1E0pVWAl9iRBERj6ELsL6ojhiEgKxE88pZmmit2cNxkfrWBglrLb+nUBRt4csfiCaYmeEpK4E2Z/9+PGc0JK1LhCX0ekYVPCzMgIm9zLZObr4gKV6M98YGDGufCkFctfwCdsaYiapm6RC66vTwcm14ZBytWlGrIPkWMQaiAavj0bHN/ahaqLUQgzGTehSkWXSFEectfnMR+oD1w7uPPO5flYN3Bml3aNDK6Ye5yf3NhSxUDiSBsptuDW/FP8v2ke3TX8nml5B6IUPesNsBr2eKKrJWINVjyGQOtFkbs/ymdwSi0pPJv4Onw0w1flQ3TMd4QDb0VMwi5UX2lAcHhBJB2V1gFUWcp/24+62U23N88pSLLOqAvMtHWgy/DIDyRhPymB3i/OIzCvP+QyS85ur0M3pVAi2Mo+mJNJybexvxbtck33jHu4B40Gho28eIAv/SaA44YYT6jdgs1Ik7IyDSqdW+9xqnEiPnUiQIsCJxdPxscFKI0Aha/dzXFcGYwMIzpxHyxDXU+K9dzhizmM8uSl8HrWBq6SWWdiIzojciYATamoCFg4aK8QTfiKqvLh7izp3zDsdwDyOOeidRJ/nSfMs8V+fFsX3zU31hBxY2RWW1NoNF8TN4jQegZWb5CL00Xz+rq11lP90LejlIASihpsK0x6cY
 QMB8jnn4
 Tuf+9A6XYM65EL25t/miSTNu3DGytXKp+dxWtlQecTmL7Mo3ICEHqHjv/h4NIcbOT6jEwuy4+Zh2XN056rwSzVBri6T/K7l32XiBoLND6d+1OiNqR8Y1MrlWM9hVPOQnb9pPUYm1Y6NBahRcLVNKABG/r6i6xLSPiBiVkBXoCIob9z/lz1HyD9cmTAPl0UByqzusqJZ5/jkILwjGYJNqBemzLGXI5agxpvu5UIjlSC0m76Wa3bfLUzkrKAb/ULh3ILWckhTh6BQChZe78ZZK+qvSBruK/GYf6pw+8awmE9UtgksF0RVDWqGX0ACfANgiI8x9Bru59oaXETlvhaec3ujTTjAGcoKj0GhnFi7vaZy+MFRkBCAa+RhHe7I7smCX0Lptz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 23, 2025 at 11:05=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wr=
ote:
>
> On Sat, Nov 22, 2025 at 05:23:35PM -0500, Pasha Tatashin wrote:
> > Add the documentation files for the Live Update Orchestrator
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
>
> > +Public API
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +.. kernel-doc:: include/linux/liveupdate.h
> > +
> > +.. kernel-doc:: include/linux/kho/abi/luo.h
>
> Please add
>
>    :functions:
>
> here, otherwise "DOC: Live Update Orchestrator ABI" is repeated here as
> well in the generated html.

Done, thanks!

>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>
> --
> Sincerely yours,
> Mike.

