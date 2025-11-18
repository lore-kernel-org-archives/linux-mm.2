Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1267CEE350
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 19:38:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BA7D6B008C; Tue, 18 Nov 2025 14:38:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 592FC6B0098; Tue, 18 Nov 2025 14:38:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CF8B6B00B5; Tue, 18 Nov 2025 14:38:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C85F6B008C
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 14:38:52 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D27F5564E4
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 19:38:51 +0000 (UTC)
X-FDA: 84124740462.11.7A0375F
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf01.hostedemail.com (Postfix) with ESMTP id D8A1A4000F
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 19:38:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K6ztwnWZ;
	spf=pass (imf01.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763494729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xP8obOsgLV+Mi7QU5SctjthhRGiNVWVhn+AWfuje1og=;
	b=BIYCGo5n36juXNOz7K2nIWRBUX+h10wO9aveYrIcg8uM4VrGYlN3Ry5vZWDGWz6AlRpdkF
	T+ljhFMpjjbvzooXldOtPI9mLkgCC1HnNG5oHLIavFhbuzq6IrKPLWJAqwuY1ioZ4Nqvvt
	Y+UPkDbEk7ypHsttPVhasNz+lUiXJtc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K6ztwnWZ;
	spf=pass (imf01.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763494729; a=rsa-sha256;
	cv=none;
	b=ha4sQBGEZl8+au3RL3qavmSHcT5qmX28VhXSyMG3JmhEZl81oyG+gY8hSR7GZc3SmZQn0o
	sEPstYoCJBK7JKMIzjRBYztGu/GLguyTDbOOAvfSV/p7fXR061Ng7PltA88THP1kRNNW4T
	2OfKfylTnThjUzUKXE8sW3KAzWnLq60=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-343806688c5so6339057a91.0
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 11:38:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763494729; x=1764099529; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xP8obOsgLV+Mi7QU5SctjthhRGiNVWVhn+AWfuje1og=;
        b=K6ztwnWZys/nJ9uuksNkQzs1ygMuseh58U03YLY1lX38tk/x9nDL36+lHpmdqV1UxN
         o7EqHeOHCxJJJrTJmBcRE/fx0QSB07eCso2bh+Zlzbyjb0NkR1OX9fNtjPab64XapT3w
         jhW7ApHjax3vqCU9QcT/asU61LaDM/NB6c7Qr402Ei9qKipLVvz7VkLelVaHtSVDct/G
         wHt2Rh6V+NWmPPA3uRM2EFq/tKfGp7PII14rmCjhmPrFpdX7lJ+Lr3nMyh/bHj49qHUk
         lrut23cENFcWIuj10v5bX1RbDAZsdP2FrLQXqSUVdKjzO1kdaeKAWlTOwABHmJc+Fhwr
         eIzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763494729; x=1764099529;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xP8obOsgLV+Mi7QU5SctjthhRGiNVWVhn+AWfuje1og=;
        b=FOjlp6jgEhht5rWnUXFrBXZ/9ymCdIaM74ZKaRtRalz94Hi5zeE1pWy+q1EDoepy1n
         Y7mIxE9kN7+GhfoImdkiQJjK3mVE6hchUkSsCcUI0jbnldxi+gxBIatdk2/U6Aa/S4RY
         EwNf7HV12iFmHb1Ul4O3bCz26fCouPWiBBuc1UZX/sHVtcZzxkvdnq3N3zC9MModQPQ/
         m1oRnh4VKR289pdQzRX8AoGxEuJgVGV4YwFBGxLzfHNtWHUmujneecjJjbMRP/KVGLc+
         VExcpvahfFxPcGU1j/BsUI/1nxIUn4yL2YGdnrEK4VpBGb6Is/XgupRuDQ7ss8coTLG9
         tOUw==
X-Forwarded-Encrypted: i=1; AJvYcCWZfWF9cL4VuWzEaf51HOzH+EorAjL11+khxsbEn2UUihPGrsjhvsZHXz5BfmK0e6tUJJ/HrJ+Mqg==@kvack.org
X-Gm-Message-State: AOJu0YzBoz97dBCSfwJ/YCc4LVkN6La9u6aaDMP3zWAznrBzepci25I4
	d5fd3iVEaJVXuOcD6RXzu7Orv+99egvMBZdsSTC3zoSIrhT88ueHTIsmrz5qJxLqwFrLYXHQKgQ
	+2fo0Ja2l4eIOQ9+kIbuXcBqF2fQyPihgzmx2fuM=
X-Gm-Gg: ASbGnctz2Xa1YfJKO0xcyUcrFeSnwj86zqjaS4n0DHdOE2olAFbBjG6IIzSpgYyLkLI
	tJty9jQEtVzdIhqv1/RfRVA7sRWSQYm0UPPRvzlayZIRfaJ4rfG/zUEMmt9ly9ggN1ZtAuLTnV6
	9NCkioz3u5O3vllVDbIyiQMyI9i0UFsy7MaWvGf1rjlCAPHrajySaTnJZFHJwIKN+b+WIH63UJf
	HvubEonM1969uulhY+pbfUMtZoeHChrJJnSd6uYQsthA7BX+cG60uXcnB1HWGkviqsDxZ+YSRYI
	ivICMtRGLIgfC2r0gqHm2g==
X-Google-Smtp-Source: AGHT+IHjQ5qI54V48OaD9lOMuf97MRj94VnLpjJI2NcKNfYtXCw0gbO/k0nfKsSQ9TEAtm7URf1eXdHMpVdLUVZFnJg=
X-Received: by 2002:a17:90b:58ef:b0:343:7714:4ca6 with SMTP id
 98e67ed59e1d1-343fa62be93mr16554523a91.22.1763494728613; Tue, 18 Nov 2025
 11:38:48 -0800 (PST)
MIME-Version: 1.0
References: <20251114193729.251892-1-ssranevjti@gmail.com> <aReUv1kVACh3UKv-@casper.infradead.org>
 <CANNWa07Y_GPKuYNQ0ncWHGa4KX91QFosz6WGJ9P6-AJQniD3zw@mail.gmail.com>
 <aRpQ7LTZDP-Xz-Sr@casper.infradead.org> <20251117164155.GB196362@frogsfrogsfrogs>
 <aRtjfN7sC6_Bv4bx@casper.infradead.org> <CAEf4BzZu+u-F9SjhcY5GN5vumOi6X=3AwUom+KJXeCpvC+-ppQ@mail.gmail.com>
 <aRxunCkc4VomEUdo@infradead.org> <aRySpQbNuw3Y5DN-@casper.infradead.org> <20251118161220.GE196362@frogsfrogsfrogs>
In-Reply-To: <20251118161220.GE196362@frogsfrogsfrogs>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Tue, 18 Nov 2025 11:38:36 -0800
X-Gm-Features: AWmQ_bk9sXea8jL7B_XWSvq1NtCko5Jbx6_OaVtFvyVo8HnLwKRsCuuE1XHa0Cc
Message-ID: <CAEf4BzYkPxUcQK2VWEE+8N=U5CXjtUNs6GfbfW2+GoTDebk19A@mail.gmail.com>
Subject: Re: [PATCH] mm/filemap: fix NULL pointer dereference in do_read_cache_folio()
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>, 
	SHAURYA RANE <ssrane_b23@ee.vjti.ac.in>, akpm@linux-foundation.org, 
	shakeel.butt@linux.dev, eddyz87@gmail.com, andrii@kernel.org, ast@kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev, 
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com, khalid@kernel.org, 
	syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com, 
	bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D8A1A4000F
X-Stat-Signature: jnfd685em9ro5d6pjhex4rotz8tghuej
X-Rspam-User: 
X-HE-Tag: 1763494729-681295
X-HE-Meta: U2FsdGVkX1+zcKTQ/G1MnoJtbAvqbzYpD6fsaLDwgK9kr5ZAy/pBbmlgPzkJXzgV1nQM3Fa34TRyCWnA8amwnpdXOot7f+uR+VBABLyFcsoeKRcjy1KsJo2xenur383k1i1/3YtIgoUhaaWVD7XpXfgvACMc/2Qr82vtgQBfB5bdmYADkOJCkh9Ku4th4RG28DeEJ6qrGE+RUWC/g1JNKH5V4Q/Dpzzf6zDFl/keb84HcO0aoelboiWMXlhF5qrHSaM3iPFRPTjz1Jmp7MIYlWmnCCpgRLbcUtUBP7HRzj6n1cBCeoknhTkJDLcz3Yhf+ueG6e/0WMmu1oaQjhn/obrMTQ81NPsy+FJhJgtIdE4zzTD2KeZUsDLt6DoQEWLeBYTbgHm+Clc9Ozw/FXJVNcrIJ2kvlmW3XzUN0yIN3zq2F8M65LKvDBFYdSG1q0oRTy3358YcByYMkL3C1JR4NKGTn5wstRPv9lzdqe5yYNUQUVnfXY6zj3bEoElvJduckR54kGBhiBDpaPGtoqmn5i5LPwVqZyAZ5f+DDRPe9wbdG+jKr1oODjj4wLRPHevKK7KcBPvxvcBlS+kbhYZYB4ndFiedyZvBaqT5mlfuNZkK3SJiLN2/uA7qoXq8hXhk11wvFjgWWQ4trdobgqleUKT5QDEJfuoPwOtdVUcdf146R72aPsFcI4ZFXFep0IECBXA7QBl92+gaIVdUM67Pw83TWn9b1lmI8jfYDCHPoPMG1PP2GxrbEp+0GBWecyEafvf3GFm+Cmv6GTlZG5to9V5EGEjQaIEkie/NFsXPCXYoFyATJoHWxuPbjdgD//FoFcHd9Q9LPDdDXbE6KIA6P8P/4ONe0LzatKNYALI9Gsd9+4Sx59R+zfoIdpZk47ibbaZHd0Op0A9yGwyYCe+zwEn2ie2P3+kRASestB5CcmXhc8L1tAVctm/9jJJhtYEkFV8d4cBed97GFNZrIYp
 KXH4jVxY
 EPimqx3xd8wT6ocK6h+UoTFpBOF7wHZcthMdazcnZmCglfk00/1ZCWZkM+rN5LbIqJdGSmtdiw/s1nJUNH+dWTgl4yqTJfLw6CHEtzIg+v8xov3XLmSSaJr5Yj0atiNyD0BrqnKtTjNhBJiynkMYEWaA8rTGu46TuotPVLKMdg+5AV/9Y5Cs7gPFrxg8HHgxPPHhS0ckVBr5CQU6ei0x60HKbAOWMEbuCZapiH8hU90BujmYE6lu6lW0m6+mBuICaBrf3OsfCVlFnUnX2E7MHIxdfToZXKrlQUMLKXn3Xeuz5SOW3OFZ0O2QrAa1Y4ycQrezTEV3VlmRtZ/6aPp40+zQQQBh++HjFVHZ3+yeohnp9zoyc3gHD4dz+sqKvMfui87kI0ev2fKNbCFM2wK1KO0hfYQZmX0r4j1+7m0pJuXW9SUL1mf9hXInffzrUn1lVij7OYmlfVmmi22rhzuZkyJ2C6yfTFUFrtStNKxE9n6B/9HKoVGYA7wWnVvZr4g1CJnvXm/LCrwnEkO9C+bDdxUm1v7h/brXH+NQrnI8dGo/eJh0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 8:12=E2=80=AFAM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> On Tue, Nov 18, 2025 at 03:37:09PM +0000, Matthew Wilcox wrote:
> > On Tue, Nov 18, 2025 at 05:03:24AM -0800, Christoph Hellwig wrote:
> > > On Mon, Nov 17, 2025 at 10:45:31AM -0800, Andrii Nakryiko wrote:
> > > > As I replied on another email, ideally we'd have some low-level fil=
e
> > > > reading interface where we wouldn't have to know about secretmem, o=
r
> > > > XFS+DAX, or whatever other unusual combination of conditions where
> > > > exposed internal APIs like filemap_get_folio() + read_cache_folio()
> > > > can crash.
> > >
> > > The problem is that you did something totally insane and it kinda wor=
ks
> > > most of the time.
> >
> > ... on 64-bit systems.  The HIGHMEM handling is screwed up too.
> >
> > > But bpf or any other file system consumer has
> > > absolutely not business poking into the page cache to start with.
> >
> > Agreed.
> >
> > > And I'm really pissed off that you wrote and merged this code without
> > > ever bothering to talk to a FS or MM person who have immediately told
> > > you so.  Let's just rip out this buildid junk for now and restart
> > > because the problem isn't actually that easy.
> >
> > Oh, they did talk to fs & mm people originally and were told NO, so the=
y
> > sneaked it in through the BPF tree.
> >
> > https://lore.kernel.org/all/20230316170149.4106586-1-jolsa@kernel.org/
> >
> > > > The only real limitation is that we'd like to be able to control
> > > > whether we are ok sleeping or not, as this code can be called from
> > > > pretty much anywhere BPF might run, which includes NMI context.
> > > >
> > > > Would this kiocb_read() approach work under those circumstances?
> > >
> > > No.  IOCB_NOWAIT is just a hint to avoid blocking function calls.
> > > It is not guarantee and a guarantee is basically impossible.
> >
> > I'm not sure I'd go that far -- I think we're pretty good about not
> > sleeping when IOCB_NOWAIT is specified and any remaining places can
> > be fixed up.
> >
> > But I am inclined to rip out the buildid code, just because the
> > authors have been so rude.
>
> Which fstest actually checks the functionality of the buildid code?
> I don't find any, which means none of the fs people have a good signal
> for breakage in this, um, novel file I/O path.

We have plenty of build ID tests in BPF selftest that validate this
functionality:

  - tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c
  - tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
  - tools/testing/selftests/bpf/prog_tests/build_id.c

This functionality is exposed to BPF (and PROCMAP_QUERY, which has its
own mm selftests), so that's where we test this. So we'll know at the
very least when trees merge that something is broken.

>
> --D

