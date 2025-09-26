Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC56ECAC5BB
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 20:29:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8D0E8E000D; Fri, 26 Sep 2025 16:29:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E41298E0001; Fri, 26 Sep 2025 16:29:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D050E8E000D; Fri, 26 Sep 2025 16:29:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BAD968E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 16:29:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6326B1407E9
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 20:29:17 +0000 (UTC)
X-FDA: 83932541154.15.72838AA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2A8DA8000C
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 20:29:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Cr1reFXD;
	spf=pass (imf30.hostedemail.com: domain of cmirabil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=cmirabil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758918555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nQdtd6aty7MhbXUeyU1S7f0YHdth4v9lOBvY3WPAYoQ=;
	b=b1pBtANrRf3wZWWWZ/SfySAkgH0Nsa/PWPdYMj9y3qMyIufAOGw+3dNdBICWfQLzInicN4
	UFpm1I09l2MR3dAyYYrqwxZwW3uwWChV/9bo9e0qFTBKL2vfvrppJn73DCPl2Ll6JnqHan
	j9ECIBwk9ftPtFEUv+8ATrlGaLyQJDU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Cr1reFXD;
	spf=pass (imf30.hostedemail.com: domain of cmirabil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=cmirabil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758918555; a=rsa-sha256;
	cv=none;
	b=X5/oLJQkxP9YMUecjs15tK8WM7iCwbUcGDasPvBChWTw6sb6TkEkHmWUEV1HQQMHyW1W5W
	ZSPBeUd62VzWpMnkHrscs1XuT0IZhLogbilAQTe32+/ClmW7y5UZER+E12nDsfMIqk/OK0
	AXkozoih3C2XNPbwd2W5+ShaSmPqNfU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758918554;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nQdtd6aty7MhbXUeyU1S7f0YHdth4v9lOBvY3WPAYoQ=;
	b=Cr1reFXDK+Bp55vt2Q1ZL9imyPMgjKK40/tOq8BgiC3PaNDblBVOxSmmpt9vVuhtUQLc1C
	2aW4Txu3Y72A2L78pVVBf3y+z+QjnGKYHq0no5f95SELt6C6DuORsbXNUK/TffenOYL7Yi
	MGe9DfCxBWerFwV55Bl8Si70eZbul+A=
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com
 [209.85.221.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-htRWYEZoN0WWLDFVoX9IAw-1; Fri, 26 Sep 2025 16:29:11 -0400
X-MC-Unique: htRWYEZoN0WWLDFVoX9IAw-1
X-Mimecast-MFC-AGG-ID: htRWYEZoN0WWLDFVoX9IAw_1758918550
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-54a849ec449so1366087e0c.1
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 13:29:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758918550; x=1759523350;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nQdtd6aty7MhbXUeyU1S7f0YHdth4v9lOBvY3WPAYoQ=;
        b=V5AHJpV4eJa7nuntuW95zfMXBQC7flduZRPCjbAk4Cv2sRcaDO0RvtrZmkDEeJcRSS
         +y1n2Ddmm3vQFH5zOo6qgUJwMyP/TMouVQ3Wom9Mxu9pRzjGbW/T5BM8uKrRxCMH+eyS
         OD2W87+bIcZYNGw2W18S69BYav+4ZJXtWCNu0os3CiY1UzSZwAZGfq1sgYxW5tRiWbbj
         x+8B9/Xspqiwi7nvFhmt4h6zE0ICnBewcIeZxF3pBEDMkdYJAi+EjgMcVSvKvYlDCDJw
         T8AByocv1MEP5o55UsSQB2m78WNI6sMsp6nvbiywIQcjA3Ta2F09z5jK7u92ETmPqOVy
         mIjQ==
X-Forwarded-Encrypted: i=1; AJvYcCWHVyypgSdVC8GsNBUvO4Bs8AebJTpxL+2t7HNOYgujA9XzY12eeP4NIxLgkydOOK5g3rFbKnVHhg==@kvack.org
X-Gm-Message-State: AOJu0YxBWkgU1ArSqYWtOQNvdQGBMRVCWOeM1Ec3nypjwELycOZ8Fyfd
	AyABSe7e0No/N1UemmOe4NFL+OFPTuiSvwkAD0NEQmd5Q05rajYDwQkJ2bxXvHtdh78gMZwcoHO
	iv/UfPOyiXBAvEVYJvYZOcYoDcr3WGJSW9S2+6Nybma6GXmZ9MhtJz7Da9EfSzwMhgm7a69/UNa
	9i2hXqJM/9OUBtziHJ4045YBBpuQg=
X-Gm-Gg: ASbGnctwSi0gZWCB67yVH6CsqCpnfQ0VHhaD/Av5NG1PkWE9G9gDjgeAlWjgqggazkH
	yFWutdtHmVfNEnilnVTCJzrWLKjtr0ZzhYYN5/forgWFL4wpZ7K3T8bSBJCukZYmxeIc+W3n8mx
	2+cXW1WVPbD9rpdZkE62JNrR2Q0opzBA==
X-Received: by 2002:a05:6122:7cf:b0:54a:a1f1:ef42 with SMTP id 71dfb90a1353d-54bea1c094amr3516275e0c.5.1758918550398;
        Fri, 26 Sep 2025 13:29:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF7vlUmlGwUwL1AFRKnR2zoH9F3EoJncOgSNp7RigeP+sdlLnxuFXDBvEmapswDg4BXwIBnMV2DKbzUxG+jaYQ=
X-Received: by 2002:a05:6122:7cf:b0:54a:a1f1:ef42 with SMTP id
 71dfb90a1353d-54bea1c094amr3516251e0c.5.1758918549953; Fri, 26 Sep 2025
 13:29:09 -0700 (PDT)
MIME-Version: 1.0
References: <f953ee7b-91b3-f6f5-6955-b4a138f16dbc@kernel.org>
 <20250926192919.349578-1-cmirabil@redhat.com> <aNbwNN_st4bxwdwx@debug.ba.rivosinc.com>
In-Reply-To: <aNbwNN_st4bxwdwx@debug.ba.rivosinc.com>
From: Charles Mirabile <cmirabil@redhat.com>
Date: Fri, 26 Sep 2025 16:28:58 -0400
X-Gm-Features: AS18NWAFmNYbXfsrHSUccPVQ7i16EPHPLja0OCz6y6mucuuIuUMLPbxAtsOG_bI
Message-ID: <CABe3_aE4+06Um2x3e1D=M6Z1uX4wX8OjdcT48FueXRp+=KD=-w@mail.gmail.com>
Subject: Re: [PATCH v19 00/27] riscv control-flow integrity for usermode
To: Deepak Gupta <debug@rivosinc.com>
Cc: pjw@kernel.org, Liam.Howlett@oracle.com, a.hindborg@kernel.org, 
	akpm@linux-foundation.org, alex.gaynor@gmail.com, alexghiti@rivosinc.com, 
	aliceryhl@google.com, alistair.francis@wdc.com, andybnac@gmail.com, 
	aou@eecs.berkeley.edu, arnd@arndb.de, atishp@rivosinc.com, 
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, bp@alien8.de, 
	brauner@kernel.org, broonie@kernel.org, charlie@rivosinc.com, 
	cleger@rivosinc.com, conor+dt@kernel.org, conor@kernel.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@redhat.com, devicetree@vger.kernel.org, 
	ebiederm@xmission.com, evan@rivosinc.com, gary@garyguo.net, hpa@zytor.com, 
	jannh@google.com, jim.shu@sifive.com, kees@kernel.org, kito.cheng@sifive.com, 
	krzk+dt@kernel.org, linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, lorenzo.stoakes@oracle.com, 
	lossin@kernel.org, mingo@redhat.com, ojeda@kernel.org, oleg@redhat.com, 
	palmer@dabbelt.com, paul.walmsley@sifive.com, peterz@infradead.org, 
	richard.henderson@linaro.org, rick.p.edgecombe@intel.com, robh@kernel.org, 
	rust-for-linux@vger.kernel.org, samitolvanen@google.com, shuah@kernel.org, 
	tglx@linutronix.de, tmgross@umich.edu, vbabka@suse.cz, x86@kernel.org, 
	zong.li@sifive.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0OmKBNQQB9pjKGlGp6K7rpabglKe58wupRjMg-bnYHk_1758918550
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2A8DA8000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 5k1eqdhc1wwyiwy51jm53tdtyed6is5g
X-HE-Tag: 1758918555-273702
X-HE-Meta: U2FsdGVkX1+3Z7w7XE2gkTT/Yhvi88/kEWMMKV7LJhllbDjxVCNi8fR8P5FtAy9mxFNVahAfOp3SXjSYTr1vDcUX68WkTc4/5Zjc4SxYTo9v9CQySSf9gefnfNQMhvilmDZrr8n8uP1MjnEsNJOxH6gU0KCrjblfR6SK5Wsqv2sgSiX4SWIThnMkC8mV8kl+QN7lJ+r86GZmlM3GF9fNZFZJO1FW4Fj4UoacbnHRYw1XKdr5OPUMDbzR9FZ0vDsMaEB2BUR9UAn4diVYpfivF34drdVoFgwtBf6k6GUbWHcc884zTLgu1axfG9v/fIRSOvdrWL7oNwkrJIhf4BKXWqU2Hdqb+Ii/SZaYK0iubbY0rsdozCQ3cO18it05OOaEqx2uQ3BXhhd/qwx1pcqPF6AuAZI7Bt6DpBMWGfGj3IzGCavm/864pVj+vNhAdyBkCCpspDSkl3Zv0hiIZSgd3b+A/JmsUQL9cbULgBVajGE4vUGIOHA3mj1BCR5dMgQ/weqW9NJfKtUHEgmsv3XPZ72CrHu5t2doa+kNoAUht3guybWCx142j5/bpm7MHU1QaXXriaf+pCwcFSfpPDfNeJVUgyFEPzzlROlXLLnJ/Ok6RXNgZUFaawZRcRo7cEi6aJIYlYXTs5Iq2S/StNF7n268rKYdXYEiRhbyQTbPxwAwcVVyFcqxKw27yvdeMx6Ow6zDBns6oScB4g69nXCXcMLHpD+5ZIPUEpXTj25Ue91BNYaUbhRbL0TinEwHFSlLZqg+EWlWIzPWlnEaV9EqN1SZx41LAE03AoOiKX+osFkWoisfA8HhYGvcllSJFs7Sci2ZqJoplFoZ0lc8kH/N3Q+CUITgVXwef/RIXgTO8pe6hOPO6ehlQqIXXJux6wkxPBBmUoAZroBKqJLCqc8Tp0jzjxrkfBYJqGSsEHiU3E19Yjz0IMXRjEQLgC9TVGTh6DLHdSrDpbcAsB9rwyK
 b/DUlPzY
 qzn7GD/j4itecuW3WP0tQk7cKo+m6yS0dXunBxcWX9Ezs/vBe5usTU4rLinGbXMhDD4XKHkQQtvFurs51wyh/5OCZFxcjLtpOWIgZPksbf7PqAtPMa5CN3LRq/puaz7wD46FDdDz9HwV4MD9ypMT0zhFvGR9KBNsj5QwLXjFDosxTbsySdovU4o9o17WzGtDvP93KfKG8D2QUoyxJwaBR+qTGUObJD12TdHxSn0sC3y0LagjrmOr3wMg6+zaEhhBimPfDlZbRKoDNfRBoHGmkm5I4ahJcayE0K2DwIeKtW5k10ojGLzQvNodUjbvfiuGwrnZGwn4IW78zSfeFEU5pp7ZPFY6UOAkx733mhvRvIzKtGkKqs8E6oCaEsAZeU1dMooY7h31+n7R4qle5CFn6EfuQ4YF4ATt0J2ipU6LU9vmxxkxoSes+Z63gs43erFeObatavLcs3SIB2NVOMqAs0gblZ/FemY6mMWcb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Deepak -

On Fri, Sep 26, 2025 at 3:57=E2=80=AFPM Deepak Gupta <debug@rivosinc.com> w=
rote:
>
> Hi Charles,
>
> Thanks for response. Rest inline
>
> On Fri, Sep 26, 2025 at 03:29:19PM -0400, Charles Mirabile wrote:
> >Hi -
> >
> >Hoping that I got everything right with git-send-email so that this is
> >delivered alright...
> >
> >Wanted to jump in to head off a potential talking past one another /
> >miscommunication situation I see here.
> >
> >On Wed, Sep 24, 2025 at 08:36:11AM -0600, Paul Walmsley wrote:
> >> Hi,
> >>
> >> On Thu, 31 Jul 2025, Deepak Gupta wrote:
> >>
> >> [ ... ]
> >>
> >> > vDSO related Opens (in the flux)
> >> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> >
> >> > I am listing these opens for laying out plan and what to expect in f=
uture
> >> > patch sets. And of course for the sake of discussion.
> >> >
> >>
> >> [ ... ]
> >>
> >> > How many vDSOs
> >> > ---------------
> >> > Shadow stack instructions are carved out of zimop (may be operations=
) and if CPU
> >> > doesn't implement zimop, they're illegal instructions. Kernel could =
be running on
> >> > a CPU which may or may not implement zimop. And thus kernel will hav=
e to carry 2
> >> > different vDSOs and expose the appropriate one depending on whether =
CPU implements
> >> > zimop or not.
> >>
> >> If we merge this series without this, then when CFI is enabled in the
> >> Kconfig, we'll wind up with a non-portable kernel that won't run on ol=
der
> >> hardware.  We go to great lengths to enable kernel binary portability
> >> across the presence or absence of other RISC-V extensions, and I think
> >> these CFI extensions should be no different.
> >
> >That is not true, this series does not contain the VDSO changes so it ca=
n
> >be merged as is.
>
> Look at patch 23/27. It does have vDSO change. Although shadow stack
> instruction are inserted as compiled flag for vDSO only when cfi config i=
s
> selected by user. Right now default is "No". So it won't impact anyone un=
les
> user explicitly says "Yes".

Yes sorry I caught that after hitting send and replied to my own email
(but then I said 19/27 instead of 23/27 *facepalm*)

>
> >
> >>
> >> So before considering this for merging, I'd like to see at least an
> >> attempt to implement the dual-vDSO approach (or something equivalent)
> >> where the same kernel binary with CFI enabled can run on both pre-Zimo=
p
> >> and post-Zimop hardware, with the existing userspaces that are common
> >> today.
> >
> >I agree that when the VDSO patches are submitted for inclusion they shou=
ld
> >be written in a way that avoids limiting the entire kernel to either
> >pre-Zimop or post-Zimop hardware based on the config, but I think it
> >should be quite possible to perform e.g. runtime patching of the VDSO
> >to replace the Zimop instructions with nops if the config is enabled but
> >the hardware does not support Zimop.
>
> Why kernel need to do this extra work of carry two binaries and patching =
it
> runtime?
>
> If for instance we do this, and then this allow this kernel to be taken t=
o
> pre-Zimop hardware, it is assumed that entire userspace for such hardware
> was compiled without shadow stack (thus no zimop). In that case, kernel
> should have been compiled without CFI option.

You raise a good point, it just breaks the tradition of runtime
detection and backwards compat that has been the standard for riscv
extensions in the kernel so far.

It would be nice if a kernel could be built that would run on both
pre-Zimop and post-Zimop hardware and be able to offer CFI to
userspace when running on hardware with Zimop (and Zicfiss / Zicfilp)
but agree that it is a burden.

>
> Just for sake of thought exercise, let's say Fedora 43 is first release w=
ith
> RVA23 compatiblity (zimop and shadow stack), there is no way this and fut=
ure
> release will be able to run on pre-zimop hardware. Unless redhat is going=
 to
> start two different binary distribution. One for pre-zimop and one for
> post-zimop. If that would be the case, then compiling two different kerne=
l for
> such two different hardware would be least of the worry.

It would be one thing if there were hardware supporting
Zimop/Zicfiss/Zicfilp readily available, but I am not aware of any
platform other than qemu to test this code. Since it breaks
compatibility with hardware I am not sure anyone will be able to do
anything with this config option and it moves the burden on to each
distro to go in and specifically enabling it vs just making things
work to get important security improvements if the hardware has
support and not if it doesn't in a backwards compatible way.

>
> Only other usecase is of a seasoned kernel developer or build your own st=
uff
> in embedded environment, those users can anyways are advanced users. But =
it
> forces complexity on rest of kernel. There will be more extensions taking=
 zimop
> encodings in future, we will end up patching vDSO and keep this complexit=
y
> while rest of the userspace will not be patched and will be separate bina=
ry
> distribution (if OS distros endup distributing multiple binaries per rele=
ase)
>
> >
> >However, that concern should not hold up this patch series. Raise it aga=
in
> >when the VDSO patches are posted.
>
> As I said earlier, these changes default cfi config to No. So whenever th=
is
> is selected "Yes" by a distro, they can drive such patches (if there is a=
 real
> need)

If we did the patching we could make this config default to yes to
that you are building a kernel that is set up to be able to offer CFI
when running on hardware which supports it as long as you have a
toolchain that recognizes the extensions which I think would be good
for moving this important security feature forward.

>
> >
> >>
> >> thanks Deepak,
> >>
> >> - Paul
> >
> >Best - Charlie
> >
>

Sorry for stirring the pot on this. I really appreciate your work on
this patch series.

I agree that this is a difficult call, and I could see it going either
way but I lean towards trying to maintain the backwards compatibility
because the hardware doesn't exist yet.

Best - Charlie


