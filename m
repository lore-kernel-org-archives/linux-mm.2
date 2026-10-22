Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FFB5606A31F
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 04:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=a895ZzQe
Received: by kanga.kvack.org (Postfix)
	id 4965D6B0873; Thu, 22 Oct 2026 00:12:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 447136B0874; Thu, 22 Oct 2026 00:12:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 336DE6B0875; Thu, 22 Oct 2026 00:12:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 013406B0873
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 00:12:19 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6CD854071E
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 04:12:19 +0000 (UTC)
X-FDA: 85348939998.16.139952E
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7461440005
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 04:12:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=a895ZzQe;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792642337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vprUskQTUd+SPbnT8TFojrEtK+oeOiPvhjewwpNbp/8=;
	b=T+dHvdHTjsSpJUWSGPVC8Hjc9deB/npeAgNqRbDs795+WJUOX4+nVO+4KUE6zTLELMztME
	wWljjscrqoA6htrj02uofxVcoXYnps8pG5hWR9JQT7faPy1UaR4sfTis7mbEh4Y7/1CzIA
	b7M4eGuv6WdBXtxFjGltFM4PXtnLXM0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792642337;
	b=7nsB2pvyoXRrcMGqFk1YzKA4becLhg208sGB8FDBJGG1bdVTa5R5laTFZg00ZSfeDVWJCj
	IjCnslCEXSQ0fYaUJ7jmbMIE7ghrl7uYsfQiA80gYYlQrOqFfmxm6GUyEfId3Wi/VcjZdt
	PGSqbBOlCL9XrhI+G2z2pkxIFBgUvys=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=a895ZzQe;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b21cf1a580so1420951a12.1
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:12:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792642336; cv=none;
        d=google.com; s=arc-20260327;
        b=JgtISitUMYyLlAvotmjh65bEiAKaeYNhhGwdGmjGDLWVJgLp17epxScb/Iu3EVXsGe
         oNxvOoSQTtE1D8324OnUfnhjIp7asJBkHw7i5ePY+SEnDp4x7LVn1j2F6SMjZkuDyRe4
         V/U13io4zWydvfdD0z6sRP0T5xSy4ueY6KiNTm4otwmRBP94rjxJYlsbdM9Iaep31Mdw
         B6XpFqR6jyHSbdkJs9MO+n1v0bJWkYPA2gkgcSbW1ltZyO8BJw7/z6vQtKy73DqvQX4N
         2BbOI+elm0EztjeNFkF0p1x909YUvrTaUO4YN8RHl/CWfouerEihbLoD3PlGLpF04EyL
         u7pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vprUskQTUd+SPbnT8TFojrEtK+oeOiPvhjewwpNbp/8=;
        fh=dZarC118HYAiDc+Ng5whDUjZAbubUnzOY0e6xc99DMs=;
        b=nPsbcPoRZl8mUG6Kl0XvjOWTm8qXYBZu7fpztv79WtZWiVVsTCi/185iRxBGiyHQgd
         KDmP9WyGvA4S6o4j9feFfll/bCe5LnB/nPcIlvbCbqAX0e6lwQ+AHPG5b1gJN9VRHHy9
         zepcglIS4LsDuM9Bus5vqvjX99ivWRjNAwm/g6PrWkIlnd9pU3TxWC2fSnoVu9gco/Bi
         UQecEXVvpSHxfIK88nw8vFtcjXaArdt8CXwmwWXEUL0OJExEG1bBnlG1FI/lLZmJNnbC
         tUcwexR5RrTXC7jDXeqr4z95as8lK61yD8sf2+Xfuf2dzDMQK1r159iBkaMuXhjFDlfR
         yfkg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792642336; x=1793247136; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vprUskQTUd+SPbnT8TFojrEtK+oeOiPvhjewwpNbp/8=;
        b=a895ZzQedlwu9w+apIDoAxm61MpUyFa50V4Lf6xra5RwHO8JRV/z318Tp4IKPBw5Il
         mwnl7i43HleOg51lP1VUc/WjIIqcuPAedVXtyHojzNEzZLaCuKFAFO+E9qZxVTJw6UJp
         ePY0rPdxSQNnM6E/2PDjhjke7qJ8YQhAZa3lEbKVAuY5shjLzISRLH4ZagagqIcLLsv+
         8glpgQZuDAI/uK4/3OFCDW5BLxtnK6OtP/EcL/8rgHmCjjd0CJKFphdP//YB2FkhBCbj
         y3esdAD/8Ki/VBDFtTSSc9TwYg5BOHdRtWvcw7PY2qtUI1HiCXeOgvEdx9tIc9WdHLiM
         kXhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792642336; x=1793247136;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vprUskQTUd+SPbnT8TFojrEtK+oeOiPvhjewwpNbp/8=;
        b=Sq6UizcKVH/DHlJcWPXINLbtEhacctZFQPEQVn1U1YYVU+oEIG/kG0z70Nf6kPOvad
         3oHhjyE20rJPQ4aqFlMTV1vB1QIb92AEIG4jdmQXg1WH5vnLkEfrbnw6NZvjMbZlTdQ8
         FkQQdf4PFVwbsWkZVRM0dwP2aEscRHLWJyEd6UYK5POcrFSmo0V9lgQ/8nFMCCtfs5Mb
         us7EwyR5D/wVoRb3QXYGHtmKuXS5Wt9BbZi2tQNcNG9bYpT696ggWxjar0+5Cxm0Ygkb
         qmGbamgVzDZ0K2nkJuzEqEZ5OYrbV6eXgmXv6/BcNI/9AhKaD3i3/Mf9lfaKWqIHlfq8
         SYBQ==
X-Forwarded-Encrypted: i=1; AKwUvBz7oHzPJQNLknojRSQELGKEMBWfU84w/wlIRPL8hQGyY15JluWxM5oMW4AhPgvT1YdsofgHSK8MRw==@kvack.org
X-Gm-Message-State: AFq9FYJSQ605FRF+k+Y54R1z9Ba4szQWZKblWe4uXEjFweXcLoPu6pDp
	FznsueTcoKsqGSBW7It+SqmmqiIpy18ue3Q6btI/29fxAiTajj39dzVlYY6RqO8xYZ6E4vSp0qs
	cyGiEYFpKjr2WjLlDDWeNfALF1ARtCHwVOWUdj9fWyA==
X-Gm-Gg: AYBFou2R8jH5VJsxnYMVING5U69bAkgRn3mhQ4hfR1uE6GMYfvF4NEHRwM67M29pMa3
	kfoJNHtSsOFd0/MPkWX7+KseDxaDIiJMvZP37bxwH41BxhdHzszcTYq4a41a2HKngAK6JKVaXac
	JPO62/Vb+sxWqfwzcdZcAZnqifnCvWBCjBNQirnqhw2CywgNS6t/xBID/tBmwvWEB4N5qaiZqUo
	vExQ0DgMl3kNJ6IDGTq4LirXLDuF4HfTYud/pwon9fpJ/BiGGIS5SBiET/orDFdh7uX1UDW3mP1
	ujybuZbHHFskOXYaqjhA2Azf58Yt5y/VU8MtnYXb+lzLPSyT+XSHXr+R+zJcdRUQqz1t9EkBut2
	q1K60PDxaAPF8kJVsG4pORpOmulp9T0YtdbdT+o4v4j31bwPjCjRV7Zk0c//oadM02/rZnrnQNV
	dx5pZMIdeiFQUtp1YjNyWxrHHvTtg=
X-Received: by 2002:a05:6402:5d4:b0:6ab:e30:c9a7 with SMTP id
 4fb4d7f45d1cf-6b408e80bddmr3221542a12.10.1792642335878; Wed, 21 Oct 2026
 21:12:15 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com> <20261021152527.375070-4-tarunsahu@google.com>
 <CA+CK2bAQbmq3ArP3XMErF_8RC2CUwvgpLY0H83D0nCJTaVKYyA@mail.gmail.com>
 <9huzecdi6go0.fsf@tarunix.c.googlers.com> <CALzav=dLdJoVy=B1pv0FAurD9OhAzLSTjJNbtjTdJRmSqaB0yw@mail.gmail.com>
 <CA+CK2bAQRMAEXZyHTEuUN0_Fo59Sn0hBmYbme_J9ewjx6gPyJQ@mail.gmail.com>
 <atlKsD-aJB3mJr2j@google.com> <CA+CK2bABt4OZO31TenVF2+uBUWVwViWbvfE00=0xbAw=f7K9SA@mail.gmail.com>
 <atl7peoVHdP5hz7z@google.com> <CA+CK2bBFXnJA1kddbLKGq0DAHDgjYhsTSQQay-xeX7jJC1V_UQ@mail.gmail.com>
 <CALzav=e=ho2gVrn+7KpZ3ZyasvH2u15-pC-RSRSS7KcMfKqUJQ@mail.gmail.com>
In-Reply-To: <CALzav=e=ho2gVrn+7KpZ3ZyasvH2u15-pC-RSRSS7KcMfKqUJQ@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 22 Oct 2026 00:11:39 -0400
X-Gm-Features: AclHuK_pCDHndbxcQ4IiuuWok4wCO_ZxudIta9yn_V-W6vImOs3uvaPF1BC9RHM
Message-ID: <CA+CK2bAJo8dnTOyKMgnnMnk-SCXbTsv+JCLEOWkjyj-wqtEkHg@mail.gmail.com>
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7461440005
X-Stat-Signature: iiaa5smaa7crjam61o1say4ukr551swd
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792642337-631871
X-HE-Meta: U2FsdGVkX1+a0UcFBpC2Bl/mN3mVGFrzPC2+mXcRaBmbwxqrKv28aOsr8JhD5jhP8SOBSzd5saXh7MCOxKKWW305FqmRpTIFhhsyJwPuwkCmQmsN+qOdJoOdR+Dd1OClVlTMDKqNJtqn/EZ32n81hD2UMEA7PF0SLRuqEI3iZrVp8DYLJsTaqye9ZOyBCwcnYgKsDin32NUl1NeMAE9JliRgoEBncSwzGx+UnhhtLIrjnjJs2pHOEGoBV5M7rpFYAXSfRCJZACRmPUFlnzmJy3YnF4y4+QiGF95wUWNM4NGiCHgt56+59r9JgCBS986M0APd09Y4kBgSgb6GIV5b8tUS+09zN9mmCusVrt0iPvKWfUUc53KDCL0GoSnLA6eAX/kb765+bngZYoiwyYVoSK9CGhtHWj1a+OwaB2EJb388becVWOcrYZ7Bm6Bmft7LB4YylsD0/swZcIsF9oV1cZk7y4OzoIhfgSH4a129NSAhcMuszsQX9KHZGh2lXo4RpTb4aQVhfwFSam0IAmjQskxvfJ0FsrovAVxvHPNylPP3bRhAqEj39tUz3DzZuZya9RNfE10oHGutxLDVotmEZDj/4g1/mYPk/XVz3HU5KVS4Jri2BEygW/U35y9DH/GGnE8jLJ1/tKmYQ8OtL/DWfwAiSv4xKikhOhdxZux/1vSwF1csZvUTJ8K4cXwYCAmC8WZk+JQprvRRr2v3EsJoyUImwF90ViyM58rSjpBc4LcxuhnGEwtrC+gDevp7Hz+YFYZNB2rTcRG4d3usXg2nx6L8RSp+XAnl8IMCcN26aG2Fh8qFvMbpOrorZa3XMOyaQ2rcDzczKPJD9JU3r0Vharg/fsadOuuqPa7j8Qb6MRdFIDE7alOPUCJdWqhOybVf6eJ/tyQcZSMJqefUmLQHwecqCD2nts2M0zwKbnQUKpvVIXAvk/MN4++zCndTZuOxb8fFUmsrTqzMw9GcGBa
 pXCNTDUv
 XMbww0mFvhQ3WC/KqT8fxwTiEm6ItUOj1ghfhTpWRwjJMTlIG61WqO0yim2ImREp+S0P7Aw2q1KHShzo16KTsYjMOjP2H/yItLnD5oF2WauI7hKuOwt4uj/eUrQ5uCYE7kLVMp8szWVdYrVxVpeA6M1IKuxnIeN8q3bopt7gWwXtfZ03nvAh2mg0918xIIQuSsmwLsqM+ncOpeTP5STVD2fdx/CAglFIWi969w+uLMml0CqYx6OovvAASirrCyWoH/BPSVyGH75BeVsiwSGmbTqUpuWrigLytrcvBDhgDDQCfQZpSmrhUP7ob6YqVPtv9n1tI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 11:53=E2=80=AFPM David Matlack <dmatlack@google.com=
> wrote:
>
> On Wed, Oct 21, 2026 at 8:32=E2=80=AFPM Pasha Tatashin
> <pasha.tatashin@soleen.com> wrote:
> >
> > On Wed, Oct 21, 2026 at 10:57=E2=80=AFPM David Matlack <dmatlack@google=
.com> wrote:
> > >
> > > On 2026-10-21 09:26 PM, Pasha Tatashin wrote:
> > > > On Wed, Oct 21, 2026 at 7:28=E2=80=AFPM David Matlack <dmatlack@goo=
gle.com> wrote:
> > > > >
> > > > > On 2026-10-21 02:50 PM, Pasha Tatashin wrote:
> > > > > > On Wed, Oct 21, 2026 at 2:47=E2=80=AFPM David Matlack <dmatlack=
@google.com> wrote:
> > > > > > >
> > > > > > > On Wed, Oct 21, 2026 at 11:40=E2=80=AFAM <tarunsahu@google.co=
m> wrote:
> > > > > > > >
> > > > > > > > Pasha Tatashin <pasha.tatashin@soleen.com> writes:
> > > > > > > >
> > > > > > > > > On Wed, Oct 21, 2026 at 11:25=E2=80=AFAM Tarun Sahu <taru=
nsahu@google.com> wrote:
> > > > > > > > >>
> > > > > > > > >> LUO and its file handlers validate handed-over state wit=
h monolithic
> > > > > > > > >> compatibility strings ("luo-v5", "memfd-v2"). Any change=
 to a serialized
> > > > > > > > >> structure, even an optional additive one, must bump the =
string, which
> > > > > > > > >> breaks live update between adjacent kernels. Replace the=
 string in
> > > > > > > > >> struct luo_ser with a feature header, so that the target=
 kernel can
> > > > > > > > >> accept or reject the source kernel state per feature.
> > > > > > > > >>
> > > > > > > > >> struct luo_feature_hdr is a fixed 128-byte header: the s=
erialized
> > > > > > > > >
> > > > > > > > > This patch is all wrong; 128 bytes is far too large. For =
every _ser
> > > > > > > > > struct, we only need 8 bytes instead.
> > > > > > > >
> > > > > > > > NOO, It is not. It is intended to avoid complex mess with u=
nnecessary
> > > > > > > > over-engineering.
> > > > > >
> > > > > > 128-byte per serialized struct is not starter.
> > > > > >
> > > > > > > >
> > > > > > > > >
> > > > > > > > > The first 4 bytes are the size, and the next 4 bytes are =
flags (i.e.,
> > > > > > > > > 30 feature flags + 2 reserved bits for flags extension). =
The last two
> > > > > > > > > bits of the flags indicate whether an extended flags fiel=
d is present.
> > > > > > > > > Each extended flags field is 8 bytes, and its last two bi=
ts indicate
> > > > > > > > > that yet another extended flags field follows.
> > > > > > > >
> > > > > > > > If we will have dynamic extension of flags, Think about thi=
s.
> > > > > > >
> > > > > > > To support dynamic extensions in a backward compatible way yo=
u want
> > > > > > > something like this:
> > > > > > >
> > > > > > > struct luo_feature_hdr {
> > > > > > >    size
> > > > > > >    flags
> > > > > >
> > > > > > __u32 size
> > > > > > __u32 flags
> > > > > >
> > > > > > >    extensions  // offset of first luo_feature_extensions (or =
0)
> > > > > >
> > > > > > __u64 extensions[0]  --> but the size should be specificed in
> > > > > > declaration macro that I showed in the next patch.
> > > > >
> > > > > I think you may have misunderstood what I meant. In my proposal,
> > > > > extensions is an offset to the first extension, not an array of
> > > > > extensions that immediately follow the header.
> > > > >
> > > > > If the extensions immediately follow the header, then the number =
of
> > > > > extensions is baked into the struct layout. Every field after the=
m sits
> > > > > at an offset that depends on how many extensions there are. If we=
 ever
> > > > > need one more extension, all the fields shift and old and new ker=
nels
> > > > > can no longer read each other's struct. That is the problem Tarun
> > > >
> > > > We can structure it cleanly by nesting the payload: something like
> > > > struct { struct header {...}h; struct serialize_data { ... }p; };
> > > > That way, the header can expand dynamically at the front, while all
> > > > fields inside `serialize_data` stay at fixed offsets relative to th=
e
> > > > start
> > > > of the payload.
> > > >
> > > > Since the header size is self-describing via continuation bits (e.g=
.,
> > > > the last two bits indicating whether another flag word follows), LU=
O
> > > > can
> > > > easily compute where the payload begins in the incoming blob. This
> > > > keeps the implementation simple, avoids linked lists of offsets.
> > >
> > > Oh interesting. I agree a dynamically sized header at the front can w=
ork
> > > and is simpler than a linked list.
> > >
> > > So the header and the payload need to be separate, and the payload is
> > > located with pointer arithmetic on the header. For example:
> > >
> > > struct luo_ser_hdr {
> > >     u32 size;    /* Size of the payload in bytes */
> > >     u32 flags;    /* Bits [31:30] indicate an extension word follows =
*/
> > >     /* u64 extension words follow while the continuation bits are set=
 */
> > > };
> > >
> > > /* Size of the header, including any extension words. */
> > > size_t luo_ser_hdr_size(const struct luo_ser_hdr *hdr);
> > >
> > > static inline void *luo_ser_payload(const struct luo_ser_hdr *hdr)
> > > {
> > >     return (void *)hdr + luo_ser_hdr_size(hdr);
> > > }
> > >
> > > On preserve:
> > >
> > >     hdr =3D kho_alloc_preserve(luo_ser_hdr_size_for(nr_ext) + sizeof(=
*ser));
> > >     luo_ser_hdr_init(hdr, sizeof(*ser), ...);
> > >     ser =3D luo_ser_payload(hdr);
> > >     ...
> > >     args->serialized_data =3D virt_to_phys(hdr);
> > >
> > > On retrieve:
> > >
> > >     hdr =3D phys_to_virt(args->serialized_data);
> > >     err =3D luo_ser_hdr_validate(hdr, ...);
> > >     if (err)
> > >         return err;
> > >
> > >     ser =3D luo_ser_payload(hdr);
> > >
> > > What would size mean in luo_ser_hdr? The size of the payload or the s=
ize
> > > of the combined luo_ser_hdr + payload. luo_ser_hdr is self describing=
 so
> > > maybe it's just the size of the payload?
> >
> > > What would size mean in luo_ser_hdr? The size of the payload or the s=
ize
> > > of the combined luo_ser_hdr + payload. luo_ser_hdr is self describing=
 so
> > > maybe it's just the size of the payload?
> >
> > Either works, but having size cover the combined hdr + payload
> > provides a few extra guarantees:
> >
> > 1. A single static_assert validates the entire serialized struct at
> > compile time, including the header and the number of ext_flags
> > elements.
> > 2. Bounds checking while traversing the header continuation bits on
> > retrieve: we can sanity-check that luo_ser_hdr_size(hdr) <=3D hdr->size
> > so we never walk past the end of the serialized blob if there is
> > memory corruption.
> >
> > If we declare the payload struct separately and pass it into the
> > macro, handlers also get a clean type for luo_ser_payload(hdr):
> >
> > #define DECLARE_LUO_SER(name, expected_size, ext_flags_count, payload_t=
ype) \
> >     struct name {                                                      =
     \
> >         __u32 size;                                                    =
     \
> >         __u32 flags;                                                   =
     \
> >         __u64 ext_flags[ext_flags_count];                              =
     \
> >         payload_type payload;                                          =
     \
> >     };                                                                 =
     \
> >     static_assert(sizeof(struct name) =3D=3D (expected_size),          =
         \
> >                   "LUO struct " #name " size mismatch!")
> >
> > For example:
> >
> > struct luo_memfd_payload {
> >     __u64 pos;
> >     __u64 size;
> > };
> >
> > DECLARE_LUO_SER(luo_memfd_ser, 24, 0, struct luo_memfd_payload);
>
> This looks pretty reasonable but I would name the payload
> luo_memfd_ser. The combined struct that DECLARE_LUO_SER() creates
> should never be used directly since the offset of the payload in that
> struct is only valid in the current kernel. So I would give that
> struct a special name that makes it obvious you shouldn't be using it.

Lets drop the fourth macro argument and generate the combined struct name:

#define DECLARE_LUO_SER(name, expected_size, ext_flags_count)              =
\
    struct name##_hdr {                                                    =
\
        __u32 size;                                                        =
\
        __u32 flags;                                                       =
\
        __u64 ext_flags[ext_flags_count];                                  =
\
        struct name payload;                                               =
\
    };                                                                     =
\
    static_assert(sizeof(struct name##_hdr) =3D=3D (expected_size),        =
    \
                  "LUO struct " #name " size mismatch!")

For example:

struct luo_memfd_ser {
    __u64 pos;
    __u64 size;
};

DECLARE_LUO_SER_HDR(luo_memfd_ser, 24, 0);

