Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C0A0D68BE3
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 06:57:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 103586B0089; Thu, 18 Dec 2025 01:57:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C3586B008A; Thu, 18 Dec 2025 01:57:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1C446B008C; Thu, 18 Dec 2025 01:57:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD6C46B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 01:57:06 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7CE61BDFEC
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:57:06 +0000 (UTC)
X-FDA: 84231684852.26.E6A1425
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id 829711C0010
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:57:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QaDmyBFl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of brgerst@gmail.com designates 209.85.161.47 as permitted sender) smtp.mailfrom=brgerst@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766041024; a=rsa-sha256;
	cv=none;
	b=A/39POAim7zhJrKwCO9wYf2AMKQxBw3BNnSev3A/rOXLha6nYTY8Q47Rj75wVxmc1Xmk7O
	LPfls1QGTQDqne89cOpKmQjaD73mQzvoKmvzjTznkbhyn3NKakxj+8xqTL+nj5tfKkXhwP
	YD0onRksAmLeJV7LynTkj2trvnGSkKY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QaDmyBFl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of brgerst@gmail.com designates 209.85.161.47 as permitted sender) smtp.mailfrom=brgerst@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766041024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IrlPr+wtyI1Uo99JO4RRQCXi++qPSF8IhqjKEAT8dVs=;
	b=3gzUZxSmzm9NhSqBLEKittA48nyr9X4aScUzcFgGqOKGlGDeIqKx5LH0lwMvS6sW+Atd9Y
	+5fadUP2bNqc1y8JDaWKkLCTC76Pk3Lky/GDcqOWqg3VuYv3WvwXxjmMAQBZ7T+CwpTg+k
	52RaKQmJvzEU+pYQ2KAjW5XenaG0iO0=
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-6598413b604so176130eaf.0
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:57:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766041023; x=1766645823; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IrlPr+wtyI1Uo99JO4RRQCXi++qPSF8IhqjKEAT8dVs=;
        b=QaDmyBFljm4azV7bJWFfEFsizIrXNtF0rCBsst8ZKePfOyYcb9+gkMtn5mT0aqb78x
         abQg+xcJx5vz1o2NT5KGeRZS4l9Eutn2bEpsI7usM0iwZTVRo0M+KnnM37vGXGGIIkAU
         OTqefdN8KHfAMRPeNe3zAwMYhQB3NvRZIXoYpUmndENH1lAG1r464s7he1Pg2RXWk7qK
         ztL7rcltco/lFN+M0TiY7AzVrSDIQU9tpADaW2IdRIlmd5ogWrspl7bdXbQuegSr6x2A
         Mrr+2X2Y7Kk5exOtmGdE3hENCRnm67SbXET7sANQbknvnoz2rN/PyNzSv2zn6GBG5j+r
         CuDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766041023; x=1766645823;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IrlPr+wtyI1Uo99JO4RRQCXi++qPSF8IhqjKEAT8dVs=;
        b=I5UaSKAlT2Z1Grjcw6nZZt1/Lwxc5eCO2sqnk4PFUai9uu0oaGrWfGwRTWhCNHjnst
         Olqt+KFawS5ohlkCTlMTWufZNhgidyYmwB2gt+yn8RAjnbx0r+oLt/SoNzeUMk8MVBYJ
         sLqw2c2dE1QXpp2hqVgALT1pOBOchtBkyH297IkyHvcq3JGWfSu97FS5v9PZLi+BHajW
         PjEkiBLZKlizxs9LlVgDYMCyGi/Yk5PS22HToM0mY43Q3cLOU1oMsDtrpp10bCm5toPD
         dXvh1W+/i07t+tsnPdMwJwtKs3cLP2LzRSa1YNsNKEPneQiEhx5deXDioHc1hnXL4wPw
         KTWw==
X-Forwarded-Encrypted: i=1; AJvYcCV3vrOPX1AnPeyHkYh5kxllEbGWaTtw2oUE/fpn10QIm5sXiPYzq6jiPpcP3gToZ1uMMerIxRDcBA==@kvack.org
X-Gm-Message-State: AOJu0YxLmkGwjj0hb6R0JsCLE2gCx6UytndsdzUGGWx0Ez82aKRMuMyq
	eS8Ezmmvx7ro9AqkMpKZk1j/JexwT3fsgc7RAcIb0gulOu1UXuyDkzBNzHjntyG3crfSEdFba5e
	QhI39+CWuV2MRdmVV7+SQF3MWl8u6hw==
X-Gm-Gg: AY/fxX7TdIDZgFMApg8PfIIiNf63VrVUKPHAiVesE8vZ7hoM7y5DLV5Pu7Uiq7KUGEP
	cHcz77QWnib/CiIrB9bPb5osVtXTSfLGAgJ9YB+lRYyGku0LDDhVFplB1/6nAQmu39CCTKoxQcL
	YvGgwVa4oLV5Bt32YWCUlHdF1lZzoDQfVyHWB9YadPfdX75rR9YJlFvm5HoMUJzHNpIsXLdOXGn
	qRQrDohnSmlam3GFDTjwXuBTYehOfeIWAD1kWPdfBOTXmowYfGrqmAOegpRSwWA6zFwdPvvL0sW
	hJhE7iuZfQ==
X-Google-Smtp-Source: AGHT+IHoyKgJft9GXWOvq29wKjxPOdiqHvAXZh4kRr6kHL+8DE+l609ZcYKgNfj2eeC4DwCl0S+iuqFUSarqUO9+Dc4=
X-Received: by 2002:a05:6820:198f:b0:659:9a49:9044 with SMTP id
 006d021491bc7-65b45165e85mr8281438eaf.15.1766041023437; Wed, 17 Dec 2025
 22:57:03 -0800 (PST)
MIME-Version: 1.0
References: <20251216212606.1325678-1-hpa@zytor.com> <20251216212606.1325678-8-hpa@zytor.com>
 <CAMzpN2g9QNnYhxkGvkO2YcOJTmJGf75qFhKiEQQY18ZaEPQNdw@mail.gmail.com>
In-Reply-To: <CAMzpN2g9QNnYhxkGvkO2YcOJTmJGf75qFhKiEQQY18ZaEPQNdw@mail.gmail.com>
From: Brian Gerst <brgerst@gmail.com>
Date: Thu, 18 Dec 2025 01:56:49 -0500
X-Gm-Features: AQt7F2pSEHTNrfBDjbeKYJMaGHx2b0RfaShrNHFVQFaZQtwh_3mq6tdQ_izXv3M
Message-ID: <CAMzpN2jJ9T=xtXZo1=sxEBjJoqmv4DhfCR-Ef3Mj-cfrhrv3gg@mail.gmail.com>
Subject: Re: [PATCH v4 07/10] x86/entry/vdso: include GNU_PROPERTY and
 GNU_STACK PHDRs
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	=?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
	Xin Li <xin@zytor.com>, Andrew Cooper <andrew.cooper3@citrix.com>, 
	Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, 
	James Morse <james.morse@arm.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>, Nam Cao <namcao@linutronix.de>, 
	Oleg Nesterov <oleg@redhat.com>, Perry Yuan <perry.yuan@amd.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Thomas Huth <thuth@redhat.com>, Uros Bizjak <ubizjak@gmail.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-sgx@vger.kernel.org, 
	x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 829711C0010
X-Stat-Signature: akib3p47qz9ozwm6znc35gnszfazzhcp
X-HE-Tag: 1766041024-364089
X-HE-Meta: U2FsdGVkX19nAVD2Hldt8fZQK1uN16tjuKgpVTsAKRsSRNaaPVabU0+AQv5GWiY/mq9H8nG/2Kj+ckrt+mF33w9U0UG/TYAeafAWfpYUz2CgcyH5pz4WkRT7+FE6crrkBAAN/61uaCpShTf61/XjCToIL0r2OFEscE8EftyWJ2YRI5Jj4VvDuu+NAjNaxnsEZKGbWaL1IjoTClCcsDwnf965h1wHnAGVIvj2N6W456LbWAxeycaDNJ8SFiYxvOhNCSdfIJV8S3wWgilshumfVEgfRICJRRbVyw9gLbzei2cmRtIFe10CQz86gz8mUykiJpfRCIZVtJfkE+3J7N0UTOi6uwBkLXCB3lIqMtMqIi+2mb02lR23OKDr3bdDjarWofvCLcWgrWxEfNYWxUzbPLGzohRrqiO1ap5Yh/Phs2iJf0Rbw1+h1xAV4fZt6PoMHibyWIthZ387VLKqsTnjOXaKQdjSTsb/2tDKAcKkkL/Tb4Y1t5+wYtnF5LfZkCQeVWRL/JJ1beDab3LV1//4XK+zR3/4e6nOxW2UY55IvujOYyKO9cwS1/UrblHwNdpgi7tz/10UEm1U3BCXbCjxihl836c0LGcwJ9zjifczUwqjWpYgOPOvjgvL0x1kMCAIWFxkeSKxh/+6xbaHFVaKLiNeTvkMTyEVsw/p2BmDNaa5SFuEDbutycNiZ0Il3rnj4iiKsNvkhEMyyC42aNzuTTVxSqJv2yjtN8WwSfIBO/bz9YaOazajrRgf1js8kQeFlHyj/Gq9rLVq4royqRl3tS0lntJATJ+ICKVvSIzpFmdF47voN+X/04Li0J0LPKq5Ww7nwUYBD9ggTszvj3nLX7mhgKmjrpGcGOSJ1pV1j8iBnYmZNOq0oeSgOMzFcif0czc8aPr9ScXJS+uT5t/MEgSD5js7hR4hwPzdDaCkJfyJAMeaWClnLMTXbOhFMvy04VeOD/7vhl/0U7zQwRF
 f9OcjSXv
 /Aj4iWQ4dWFTKB99p8BvD1kIH+rNTHfLMXKe420URXzuq8iBYPJvoaeDAc/mkQLsdLyJdDDMfd194yjLN8zJHk9bQZahXOWaOslKHZ8+5oPez1nlNxKI/qtXYjF0oSCkHhhsZrz5jumjWtJPDkXhxbPlFrraneM+oVApi08RPdOHSLetkZrJFAPkPw2k/AheDnb4VvfFNjqhtqbeoimWCRX78cClm1GuAHmmybeqGC571IYuzoz6CgCfxSB9dq55+eZCjbKS3j0seWx5o0oODXUfLhz/PuMu5s0rZSv4VP+ZS7voOkzbaQD9nUND6wA5oJJqsXnbH7wwoef3ofKZWunVMnEO6yxxBwcqxFXJr9MKqfgfagNPkX9mCSUgt3DDmMR4uzElLEVRkhfe184xYW2MmvkFTXUPpgrkGuUATA6NkqTH9ngQy0LJOhtS6yzW7qHQmxMKVJfobvzDSSdG0DEPxKiT8iypLv4YY8iuHcS9OcrU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 9:16=E2=80=AFPM Brian Gerst <brgerst@gmail.com> wro=
te:
>
> On Tue, Dec 16, 2025 at 4:26=E2=80=AFPM H. Peter Anvin <hpa@zytor.com> wr=
ote:
> >
> > Currently the vdso doesn't include .note.gnu.property or a GNU noexec
> > stack annotation (the -z noexecstack in the linker script is
> > ineffective because we specify PHDRs explicitly.)
> >
> > The motivation is that the dynamic linker currently do not check
> > these.
> >
> > However, this is a weak excuse: the vdso*.so are also supposed to be
> > usable at link libraries, and there is no reason why the dynamic
> > linker might not want or need to check these in the future, so add
> > them back in -- it is trivial enough.
> >
> > Use symbolic constants for the PHDR permission flags.
> >
> > [ v4: drop unrelated formatting changes ]
> >
> > Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
> > ---
> >  arch/x86/entry/vdso/common/vdso-layout.lds.S | 38 ++++++++++++--------
> >  1 file changed, 23 insertions(+), 15 deletions(-)
> >
> > diff --git a/arch/x86/entry/vdso/common/vdso-layout.lds.S b/arch/x86/en=
try/vdso/common/vdso-layout.lds.S
> > index ec1ac191a057..a1e30be3e83d 100644
> > --- a/arch/x86/entry/vdso/common/vdso-layout.lds.S
> > +++ b/arch/x86/entry/vdso/common/vdso-layout.lds.S
> > @@ -47,18 +47,18 @@ SECTIONS
> >                 *(.gnu.linkonce.b.*)
> >         }                                               :text
> >
> > -       /*
> > -        * Discard .note.gnu.property sections which are unused and hav=
e
> > -        * different alignment requirement from vDSO note sections.
> > -        */
> > -       /DISCARD/ : {
> > +       .note.gnu.property : {
> >                 *(.note.gnu.property)
> > -       }
> > -       .note           : { *(.note.*) }                :text   :note
> > -
> > -       .eh_frame_hdr   : { *(.eh_frame_hdr) }          :text   :eh_fra=
me_hdr
> > -       .eh_frame       : { KEEP (*(.eh_frame)) }       :text
> > +       }                                       :text :note :gnu_proper=
ty
> > +       .note           : {
> > +               *(.note*)
> > +       }                                       :text :note
> >
> > +       .eh_frame_hdr   : { *(.eh_frame_hdr) }  :text :eh_frame_hdr
> > +       .eh_frame       : {
> > +               KEEP (*(.eh_frame))
> > +               *(.eh_frame.*)
> > +       }                                       :text
> >
> >         /*
> >          * Text is well-separated from actual data: there's plenty of
> > @@ -87,15 +87,23 @@ SECTIONS
> >   * Very old versions of ld do not recognize this name token; use the c=
onstant.
> >   */
> >  #define PT_GNU_EH_FRAME        0x6474e550
> > +#define PT_GNU_STACK   0x6474e551
> > +#define PT_GNU_PROPERTY        0x6474e553
>
> Do we even still support the old linkers that need these constants?

Digging into the binutils source, PT_GNU_EH_FRAME and PT_GNU_STACK
were added to the parser around bintils-2.15.  PT_GNU_PROPERTY was
added in binutils-2.38, which is newer than the minimum supported
version of binutils-2.30.

Probably better to just leave them then.


Brian Gerst

