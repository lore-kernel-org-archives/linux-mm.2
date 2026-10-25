Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91AB0606A332
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 20:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=egiPi435
Received: by kanga.kvack.org (Postfix)
	id 26EED6B05B0; Sun, 25 Oct 2026 16:39:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21F4C6B05B1; Sun, 25 Oct 2026 16:39:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10E596B05B2; Sun, 25 Oct 2026 16:39:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D09BC6B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 16:39:04 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 48C93C05B6
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 20:39:04 +0000 (UTC)
X-FDA: 85362313008.20.5FBD18D
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3C4791C0004
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 20:39:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=egiPi435;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792960742;
	b=mNcQOEY8YxIpuBGGGXJM7E00/Wy9XdsfT0A8pLIUnxdralvvQETqbqMhfENhWx2ebC+nbl
	+GZukUnBAE0kojgoleYRbB4xY+9besxy+PAcXhA+mY/zRR5JdnX9qVRfIul3F+mrvsjnaT
	lADPACfV5kl1s67UebVPHldNyugXhSk=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=egiPi435;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792960742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rp5Fden8a6neVzulsysbnvEXD4vRCF1NzLSbVrqKH4E=;
	b=nrnXt3JIs/6p3+vurHXUNZHI2kmMgkATXP0tgI9T1Oa8KgcYSDEcOWK9RIVsXySZcZkv+Z
	l56F9Sm5ZZHKnkNJ1v7n1hsHFPZK9LNxaOEo86VDgcPYDwvRRqRTLNVobS28D58QfVbbeH
	byR11Akg5yAPshj1iu6EhucT9wYoVCU=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6b1aa4d71e7so2477364a12.0
        for <linux-mm@kvack.org>; Sun, 25 Oct 2026 13:39:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792960740; cv=none;
        d=google.com; s=arc-20260327;
        b=qcBan1l5S+zOdlCDlYi7lH5AJbn+Vac4PQ3p+bHGTKjXuBfvlsy3i8WJFRvfR03IMd
         UwDiLkDCeMD3rK/CUCJ6oFME0EBxV0MyK2SAkmx3ly2enHyVu0jnAxta7bnSJuZHwzZ+
         4/ZlcFJ3OMVFCtMsEyw0b+2Pm5A5KXNHehdtwlk/Updl1kOq55EUxqOUUrkyOeC2NIyh
         1k7m586KKhUsW/lFp8Fqt0aq4bjviYG3XmATMK817dd+hq8WI1ngzIOv4kql9cq35usS
         +BsG8BKB2kxOpNeHlrIOpmVWycQ1hjHbZDnssZR9RTlVaH11Hxnex+WYp3wqcyHl2MbJ
         sgkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rp5Fden8a6neVzulsysbnvEXD4vRCF1NzLSbVrqKH4E=;
        fh=W/qhU1N8M6MkCDwqvbad8HBuZ5Mm3vaaaFxu2D+UMBs=;
        b=YRAds0TLWboJwmX7Wq8LnPmkrW8qaSZoJrPg7XerMldRnaEK+AHxxuAgrzvvcmybCg
         9jUVuu4hv5ChxoEv0l5I3r8LEBqVfuvZzRImjAAVSmG2TBE2RnCsayZ2rbw2VAuw0UQU
         YXHomuHNbTFuKpQJkMSb19LIi8vTYZpLvE5Hzj2T1kIheqBKUenZsdWDtgVpQYObm5JT
         8Rlp5yJsYgRT0TYMfCcivsuEDueRu1Ibipwm6SN93X7+itUhZLgtxaGgunbJqvC4Bj8I
         3cbeQ0PYpP8y9kXoy4XXZFtCPvLsI8ebvKzL90PuQHNYlj7pXBrZxTrHwPuPq370axA9
         VTTA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792960740; x=1793565540; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rp5Fden8a6neVzulsysbnvEXD4vRCF1NzLSbVrqKH4E=;
        b=egiPi435cwHFZWyQvl3pPiLXEidqIoCP6XfgPRN5y5JpEMwK9k+1Ceyam2XxoYVjTU
         EsTsMQtq3SZstzzn5+tcUaf//iS6IFFcV1oR+p4MtKVWQYpeTfRNEmrv7SDKOr/wrqUo
         tWcE6WN/axIETr8N5SfeXcOnlnY6EcH5c+FpEUWgVFbq5RN0oI/NbP2W3uSfpObzARSs
         0ie+aU5RswBuymG+K+ob3V2GQ4WBj9qWQUrTSfoEVhsfXIPYmnv/bObZt6nlZTpSdQ2L
         m6lJWCRydo1xRZpMsnSFCkxz2bKnRqQWavuS3g7+glc+qvcKpev5F+AyDjdArtmky15c
         AMow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792960740; x=1793565540;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rp5Fden8a6neVzulsysbnvEXD4vRCF1NzLSbVrqKH4E=;
        b=ZLOxvfEv0yIpdK9LONafEKTYtuBNqaZr97MQSFUKzx6vMXYgXwQFHit12jaBB11pR4
         qoRYbDXKKxJyzSailMOdiMXcQwJ+rbUabjuGBkBNAZCf2duqyHdAkrNIdCxtkY0TKke5
         AsJ6VX9IbgXMMhjMMbgFC2OAM5mo5/XLMknOlRs5QU12JTEhjLm2T5S1AnyjBwaqEGCZ
         Ihm0CcB0mphLauj+6+k2Tap/tFHn+qRHR9ALmU8PbLqpzKVbGb4YLPBx8yvVk9BzDeIW
         I+Jwa/p5TK5tDsnvIyMXjFitrqr4CR+JIA/teJgN+Ci+a0CiyHe5HfmyCc6jlBfK7tyA
         88zQ==
X-Forwarded-Encrypted: i=1; AKwUvBzYEK8DW/71eSvrQMn40rg40Qs7fwhbtUnDlfo7DHFTH11XDcS63hpQ2ozV3CRW7Fz6ahO6GVuuPg==@kvack.org
X-Gm-Message-State: AFq9FYLzOoY1Tuam5nZTY4AbYAmRGSCP73xzKvuGfkFoh7NNusfki79Z
	eUVD+dp4Cdbd/rMNI2USOe0dJY0e1eVQ3uLtxppOPLgAv7FCtJ5HJCtm+41Cr3Tgq/IOVjEeKG/
	K8yG3hMr3aSoL2GPEwsl2FFqtvHSGVc9Lg1YUdYvlJA==
X-Gm-Gg: AYBFou0MATRt5arZm1uwmE2bw74LDyjZqW1DUk3JmYw6YrOIip7xiuM4adCPuwZqEHp
	kF9a2kpO3gIzlyWLP7IWZcDEyl+y7AwzwpR42meJYtMH+6bNHPyA7vVET9tMsejHjKFPwkC8G3I
	rxa/TGU48sf8V8j77S3e/flUmjCps8jp2zNj2DvIk6+HTSnqzHDhIHg5A3m/jZb6J7LYeEJU4s6
	nhAEYDNe1Kfa2IE18RHxN1GVXd/1jNuFmCsguqPiw+1k+H5pHgVmooc1GBP7eHLVfO1Iwqn/hdQ
	cnPMZ+1LDTQBXvIu707hyIC5+vweEcl15lpD2Zmb4+5ZNdC1SN9KWFHJ1wsYGtvJpsccpV2tFnA
	ItIHcf80Uqey55HJmX7D8AYvdAfTbvtHpd8E3btH4vT+YrBDrkVsA1v4cN2VQyWqhIurA
X-Received: by 2002:aa7:dd0f:0:b0:6b2:2339:370d with SMTP id
 4fb4d7f45d1cf-6b443000b00mr4543991a12.39.1792960740017; Sun, 25 Oct 2026
 13:39:00 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <CALzav=dLdJoVy=B1pv0FAurD9OhAzLSTjJNbtjTdJRmSqaB0yw@mail.gmail.com>
 <CA+CK2bAQRMAEXZyHTEuUN0_Fo59Sn0hBmYbme_J9ewjx6gPyJQ@mail.gmail.com>
 <atlKsD-aJB3mJr2j@google.com> <CA+CK2bABt4OZO31TenVF2+uBUWVwViWbvfE00=0xbAw=f7K9SA@mail.gmail.com>
 <atl7peoVHdP5hz7z@google.com> <CA+CK2bBFXnJA1kddbLKGq0DAHDgjYhsTSQQay-xeX7jJC1V_UQ@mail.gmail.com>
 <CALzav=e=ho2gVrn+7KpZ3ZyasvH2u15-pC-RSRSS7KcMfKqUJQ@mail.gmail.com>
 <CA+CK2bAJo8dnTOyKMgnnMnk-SCXbTsv+JCLEOWkjyj-wqtEkHg@mail.gmail.com>
 <atpNFEFIlqAoYIwH@google.com> <CA+CK2bB2C3Am5ssRuzYpfiU7_vB81vxMGc19HQLq7N=_7YrbTg@mail.gmail.com>
 <attmFVIFU_mS0Y7p@google.com>
In-Reply-To: <attmFVIFU_mS0Y7p@google.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sun, 25 Oct 2026 16:38:23 -0400
X-Gm-Features: AclHuK80OiwlBnY6tUr3jZ6atHcY2MdRSOFYk5-Bhewn5rIfzUZ_oGQw-LNyjus
Message-ID: <CA+CK2bDXDWbww_d3sD6OZqpo37V1a3t76_ubbrXLQS=9DB3dWA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
To: David Matlack <dmatlack@google.com>
Cc: tarunsahu@google.com, Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com, 
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org, 
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, will@kernel.org, 
	Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com, 
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, 
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, 
	skhawaja@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 3C4791C0004
X-Stat-Signature: 1geuwpjqfftdth1q8szia1pfw6qurtyx
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792960742-573319
X-HE-Meta: U2FsdGVkX1/OK5cPBY9+Grovm1jAga0v8gfxEYTv2peipV06NE4RsWYMf1rRD4qwGEHevhbUhfz6XulWJ0E9nU1H/YivI3HQUldJVP3f6OpBFxZ/L89k7EGdcRCeAEXoB8XkPjI5CbjZblDJtNHRjhv96nfIWVRjtLqT3Bayubuyb8K39x/HM5+rk8ah7tvpbORe9FZ7GPi0tfkPv6lU8ZXMZdqbqwtbPgadNPE3NvRLNGZ/8mlBiKEvkF75wyS9Hu6+SroY8Ia08ZLShhlG2fq//xGBvrPZH6HJ2D0QlDNnyQshzVw4bgDwcQb6WVBtUmPGHMIHCzmZp22e+mpB9SuYJlWyl71n2Glu6HdM1y+YdEAoXRVCA2u6T847bwlcWyfOIBoeUoyTZF32d6frhUhyH4hosPGpkb1/js1WVDm2orpPGJq2N889TVi/iNqFoC7EspKFSCX5VV4dg3mApOwkhSxZOpWikZuqVoqanrGJ1l8dVmCbjBhjFTyqHZD+p1zEGtpHQciKbQCTK3WzMVhfJ07Xvg37B/xxSQBzMpSYx78+Fuk1EHPi/f6vnCR6GYz9QNbuashp7A3zOCFttyL77BFeJZoUqTU8xDCey4VfC0pmnvg+HrOCpybmiFHlOywiEySbNYyQ9uun4gMVdf6tTGO7vj9TW+oOXCqJXy1BQqccg+N4zdEtSKNL8BYPqbyzXg50b5u/ZfAeLJvFl4FuFCYByDgcDmWzhuRFPmyHNyHrXVsG4l17yRskUIwu/5DX759Q28raWgdqCKqsoYG3CsjI3wMSvBrkZHYR5F+CUkIbojGZTDP8TEe+CdBdj+9y7uZsPaH3FmWvOO20Fer+Ty0xVIq75A8wJPNM2Nr0qa+1ZSHw+UtXVuHXlEbZMGgvUlmytJ7E7Vo95NjoNNZB9DVklbUYAp0oFLeO1zoM4PYgkB5PYaxCxFeYkGcXxBvI2cfnNNrC0rGj7FL
 frFT3ab6
 rvEqm6SqgK7uYY48mZ8vEojSGJcKhcBsA8aKvfibt5uoOym3IpvFecO+lmNkJLVYp4VpOMn68YO99eVFh4D6QRP/9tGvpBeqwREH2K2To9/g3UXpCsbHs8RJKBEq3HT+fuvlRkHCiczm/ippqNf5yAXFqvzWWmAbyguJlvJcxI5go6Tf0mqDEG7d0+ahUwcLR0cLqJ9rxxR2N4CPI1WAQBuClzN6io6UMzxKUCviXQJkLlJXyK1dgphXzeseZA6nMvdNAvMrmpXK6qCs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 9:50=E2=80=AFAM David Matlack <dmatlack@google.com>=
 wrote:
>
> On 2026-10-22 04:53 PM, Pasha Tatashin wrote:
> > On Thu, Oct 22, 2026 at 1:51=E2=80=AFPM David Matlack <dmatlack@google.=
com> wrote:
> > > On 2026-10-22 12:11 AM, Pasha Tatashin wrote:
>
> > > > Lets drop the fourth macro argument and generate the combined struc=
t name:
> > > >
> > > > #define DECLARE_LUO_SER(name, expected_size, ext_flags_count)      =
        \
> > > >     struct name##_hdr {                                            =
        \
> > > >         __u32 size;                                                =
        \
> > > >         __u32 flags;                                               =
        \
> > > >         __u64 ext_flags[ext_flags_count];                          =
        \
> > > >         struct name payload;                                       =
        \
> > > >     };                                                             =
        \
> > > >     static_assert(sizeof(struct name##_hdr) =3D=3D (expected_size),=
            \
> > > >                   "LUO struct " #name " size mismatch!")
> > > >
> > > > For example:
> > > >
> > > > struct luo_memfd_ser {
> > > >     __u64 pos;
> > > >     __u64 size;
> > > > };
> > > >
> > > > DECLARE_LUO_SER_HDR(luo_memfd_ser, 24, 0);
> > >
> > > I think we are getting close, bu I have two remaining concerns:
> > >
> > >  * Reserving bits in each flags word for continuation leaves gaps
> > >    in the flag space that users have to know to skip.
> >
> > Yes, but callers should never manipulate the raw flag words directly,
> > and we can provide simple accessor macros or inlines that take a
> > contiguous feature ID (0, 1, 2, ...)
> >
> > enum luo_memfd_feats {
> >     LUO_MEMFD_FEAT_HUGETLB =3D 0,
> >     LUO_MEMFD_FEAT_SEALS   =3D 1,
> >     /* ... */
> >     LUO_MEMFD_FEAT_FOO     =3D 15, /* Automatically lands in
> > ext_flags[0] bits 0:1 */
> >     LUO_MEMFD_NR_FEATS
> > };
> >
> > if (luo_ser_get_feat(hdr, LUO_MEMFD_FEAT_HUGETLB)) {
> >     /* handle hugetlb */
> > }
>
> Sure but why deal with all the complexity just to save 8 bytes? All of
> these structs are allocated on folios and there are kilobytes of unused
> space to fit this header. And even if we optimize that we are talking
> about 8 bytes per FH/FLB... or 16 bytes for structs with arch-specific
> sub-structs like the KVM ones.

The reason I care about keeping the header compact is that we are
defining a foundational kernel ABI and want to use this header across
almost every serialized data structure so we can evolve them later
without breaking compatibility. While some top-level structs are on
sparse folios today, other serialized structs are tightly packed, and
we are looking to add KHO slab support in the future where tightly
packed allocations will be common.

That said, in your proposal, as long as nr_flags =3D=3D 0 is allowed when
a struct has no feature flags yet, luo_ser_hdr_size(hdr) is already 8
bytes and only grows to 16 bytes on the first feature flag. I am OK
with that.

> > >  * struct name##_hdr only matches structs written by the current kern=
el
> > >    (in terms of length of array and offset of payload).
> >
> > This is not an issue on the incoming path, we never cast incoming data
> > to struct name##_hdr or access ->payload directly. Instead, we parse
> > the incoming buffer, dynamically compute the header size from the
> > continuation bits, and cast the payload offset to "struct name *"
> > based on the negotiated feature flags.
>
> How?
>
> This is the only data structure that describes the header. Are you
> saying the incoming path will parse the header purely with a void *? Or
> use this header but just be careful not to access payload?
>
> We should have one header structure that can be used on the incoming and
> outgoing path. We should not have one header data structure that can be
> used on the outgoing path and one that can be used on the incoming
> path.
>
> Also we need a standard header that can be shared across all structs,
> not a per struct header. Otherwise you will need to do weird casting and
> overlays to implement the shared helper routines that parse it.

Having DECLARE_KHO_SER_WRAP() in include/linux/kho/abi/ makes it
immediately clear just by looking at kho/abi/ which serialized structs
have the versioned header and which do not, while also enforcing the
header when preserving and static-asserting the combined struct size a
compile time.

So with your header (and let's use KHO as we want to version KHO
structs as well):

struct kho_ser_hdr {
        __u32 size;        /* Size of header + payload in bytes */
        __u32 nr_flags;    /* Number of features encoded in flags[] */
        __u64 flags[];
};

The wrapped struct will look like:

#define DECLARE_KHO_SER_WRAP(name, expected_size, nr_feats)                =
\
        struct name##_wrap {                                               =
\
                __u32 size;                                                =
    \
                __u32 nr_flags;                                            =
    \
                __u64 flags[DIV_ROUND_UP(nr_feats, 32)];                   =
    \
                struct name payload;                                       =
    \
        };                                                                 =
\
        static_assert(sizeof(struct name##_wrap) =3D=3D (expected_size),   =
    \
                "struct " #name " size mismatch!")

On the incoming kernel we don't use struct name##_wrap, but we use
struct kho_ser_hdr for the wrapped data, validate the flags, and
unwrap it via kho_ser_payload(hdr) to get back the struct name *
payload type.

Pasha

