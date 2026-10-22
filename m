Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D44C606A323
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 20:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=CVMKShan
Received: by kanga.kvack.org (Postfix)
	id 6C4326B0296; Thu, 22 Oct 2026 16:54:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6753B6B09C7; Thu, 22 Oct 2026 16:54:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53EF56B09C8; Thu, 22 Oct 2026 16:54:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 291CB6B0296
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 16:54:10 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 92DFFA025E
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 20:54:09 +0000 (UTC)
X-FDA: 85351464618.14.93E866E
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf07.hostedemail.com (Postfix) with ESMTP id 89A2A40003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 20:54:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CVMKShan;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792702447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q7AHGxYo2F1tyAP4/knTgDUev2PNwFvE7RNfo85FnlQ=;
	b=rIXNKIl3sgYioIODsXS4wuCHJH/NtWHSswVBAUymZWnbC5YLq5ddfaw/X84W9oQrHpg4/b
	JRAr0VZFXnRrLhM0QeVJHlsHfV1xTlbR1bghNEo9wlPOc6NFvR9hnD6nX4mr6f+QvnUzGt
	rvcicKrEIKZQGQXTqLpJIKvXhr+nC3E=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CVMKShan;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792702447;
	b=Gw4YbYs8+pkDeAE8gU3PhS2z0FvkX8KLVTBckaHxm+qUfUqDo1GItyPJY6d0Ntk/u3RYUj
	aMrTV1zsQsG9vPVqZmqJI78+8JwGKFmfa4uSgFvQjn7fuoUF1dE9UCBKJbU1VfMMQut63R
	G+SgwR8NJBtxHxgDUf/V36+Hiy62TGM=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b1aa2848d2so210964a12.3
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 13:54:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792702446; cv=none;
        d=google.com; s=arc-20260327;
        b=CF1p3Fq1MePZrQyRKyNCav1zyKd19GilaANOKUFty5/uq/mSiy2uBkdwIUB+PItSkv
         xVDHHC1LMvHXVZvMbbMkSuA50BSY+0oMNchXwzqmYkHBClvPXTz8jx27d+bNGCZbqv+Q
         qbkBAEM/eaYmWBDUjxBIQ3fea7zYgV5Xap8b1ooF3yMIVNPwT04nvao6l3fQ1Fpe22PU
         r2y/F6v5LrISjxPj06ORzMwk/5RV9osqBb2VsBZxSnzJvusSpkOESxp42RomuZ17XDZq
         x2wa9qgszNSnZj7wnQRHB3oLYyJmq3aTn7ZrZuKJYQQJrJ1W/I+aXUMAUMdxqhofQhMJ
         9+ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=q7AHGxYo2F1tyAP4/knTgDUev2PNwFvE7RNfo85FnlQ=;
        fh=jsMlt5HJvN1zA+oPfYCo1H7tpLrjyKqUkotK8ihYg8o=;
        b=PFZ7WepYfG5gfY9idp4ulT09+RA37omy/OFBO4h3P3PjLj4YmfaNdu+SD+G1kdFdcU
         cQWqKUCSi9vL3iotELpt6u3967Sy7nHbMWweUqkmHBJofPt/zbxV/5Lm9Q/LllNUfAke
         PL8ZZF/Wv11TMauUKWgUjlRs8loJB/ZrljTdLf9p0i+9zGLTUfH5dHAwXJXpU0Tc4M9u
         2iMn41ikM3SWy2t/5j3I6R7FWNvx86J0fwCN6IfSsi6SkwxY7JlxZzvOmEwbclkmKoZo
         r23GMqsm38As7P51ug3l6g+jo1rWyJptxKaIpiAQcMIm9Y3BF37NX0p00zxZ2Z4h8GUi
         Brqg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792702446; x=1793307246; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=q7AHGxYo2F1tyAP4/knTgDUev2PNwFvE7RNfo85FnlQ=;
        b=CVMKShanQqqDupOH2/YX3r4qynJpIUXyrJFWdPsopdnVuUvxTdMaA6uvqQsFAScOfS
         aMTST0N0lv090CUdnRrUuHjU8SE4gVnJsw7ESZJWDbGw5fo3b1tzjBu9P++XXK5COe+D
         +o75lUu6aqh3yn11PNTB+ughdvjYbYoaMT/+DVnHXd/X/DM5aDR2BPiBNs9iba0nb2/C
         xepSSgDmknR0GydyA23xdXlEeqJTnQeM+sIychTZDZ4UcdMUq+ryIlQompsj0ISHH8GR
         tHeGxqlrqLU5j4IJvqIpSgjhlq4lXi14EgSBwIty1wbnmYgVJspUnlCdi/bbXAwg0r5w
         g4ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792702446; x=1793307246;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q7AHGxYo2F1tyAP4/knTgDUev2PNwFvE7RNfo85FnlQ=;
        b=rJGsARH1nwL6TadJhxKR8dyXmriqsAEMA4d5eSl0V+OXhV3J5Y5PePL7CklTUN4BC0
         FP5TVLPrRMA/ER2oqYLvoCCNCR79xOs8ryr6yAkAje6ZgxkTCLx/THLGrx9QLn+RWiZ3
         AC/QJEY5WJXBujsqwALiUScJ+d1NRiHcXS/NEq1yLvz2ZAIloGsqUJ5gU9Lrog7k9qAr
         3zpRYV8u2LcnrM+ZMeijLKD4nvRpGQXgsuO53Cm0cXblYtQU3+9cso34/S79P1YHD3lX
         kKK0nQeeWeVRyNLgAp3HP0lNFuIWCwUGzGLJE9qzUedd2BmaT5ynClsGZy+LsQFh3UGt
         XqLQ==
X-Forwarded-Encrypted: i=1; AKwUvBx/c9c7hvKkTQrV9cQW19oUtDT4RKGCylj3vSVfZA4qhf1vXkvZoJdilz105lt4iO7WIkFpDajVXQ==@kvack.org
X-Gm-Message-State: AFq9FYJ8zVn4SGzwTfx8+XIWOSNDWkFzU3Fokh/0AJStsuRjp7HpQ4KA
	UbJIY+7W1pBo2O/kMC1+MUeqSzQEty7TpD07OOlm97QN8dnF6q6X/EVX88p+d1Hh3v7cTYBswbq
	1Wq/gZeQcky0smAHZN/kxMeuV3YCPfly/pAa4Yinkkw==
X-Gm-Gg: AYBFou2eBLw8UCZhioPfaxVPpfE6Q+FfIKJXXzXc0PEx8gHQXxTjcDpmLK342qsZ23V
	UADsnVei+5IYSMj9qyAQfNThGRT5qenLSiCeLgPRW+wLEJwP+eEgS1IU9jnJewSbMYirOUa0TD0
	rpMHfqDL+TeAc8DrHbENwbZ6WBtef5TU9RDgiMo9V5+s8P4ErlCjURGoyk3O+5p2pDM5uzddSn+
	k0EJBIYFECFEE0VDBAUqEadAljv2jMQaV93k2ujtd3PQmobIO1Uizfq8f540i0T+gyA8+EYgb5Z
	EC6Y0gSnMu/mx062PGOAFpDMfm0S6Kjyt+x/o8nITXa3jDRZ22AGOImqETsB7hXzQx9Hahh53At
	zfJNF3V6azjX8M4pSyyQrAVzB+f0z9oIhZe/8MM+TFOe/T80iqZqrXtq5kPPSxIjRdAg9
X-Received: by 2002:a05:6402:321c:b0:6b1:c299:b3f8 with SMTP id
 4fb4d7f45d1cf-6b432c1a486mr859420a12.33.1792702445990; Thu, 22 Oct 2026
 13:54:05 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <CA+CK2bAQbmq3ArP3XMErF_8RC2CUwvgpLY0H83D0nCJTaVKYyA@mail.gmail.com>
 <9huzecdi6go0.fsf@tarunix.c.googlers.com> <CALzav=dLdJoVy=B1pv0FAurD9OhAzLSTjJNbtjTdJRmSqaB0yw@mail.gmail.com>
 <CA+CK2bAQRMAEXZyHTEuUN0_Fo59Sn0hBmYbme_J9ewjx6gPyJQ@mail.gmail.com>
 <atlKsD-aJB3mJr2j@google.com> <CA+CK2bABt4OZO31TenVF2+uBUWVwViWbvfE00=0xbAw=f7K9SA@mail.gmail.com>
 <atl7peoVHdP5hz7z@google.com> <CA+CK2bBFXnJA1kddbLKGq0DAHDgjYhsTSQQay-xeX7jJC1V_UQ@mail.gmail.com>
 <CALzav=e=ho2gVrn+7KpZ3ZyasvH2u15-pC-RSRSS7KcMfKqUJQ@mail.gmail.com>
 <CA+CK2bAJo8dnTOyKMgnnMnk-SCXbTsv+JCLEOWkjyj-wqtEkHg@mail.gmail.com> <atpNFEFIlqAoYIwH@google.com>
In-Reply-To: <atpNFEFIlqAoYIwH@google.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 22 Oct 2026 16:53:28 -0400
X-Gm-Features: AclHuK_o-bcMo-_bEmG9OJEk39HO6mWdZ96jtolFahfwsqDnw1LYQXgLWQ4gcJk
Message-ID: <CA+CK2bB2C3Am5ssRuzYpfiU7_vB81vxMGc19HQLq7N=_7YrbTg@mail.gmail.com>
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 89A2A40003
X-Stat-Signature: ar6hq3txt1szba6rjo8z185owjj3ka3n
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792702447-389922
X-HE-Meta: U2FsdGVkX197pzZOWsWEzznh4+gRvDD5GXxbjrFhgkjRu0EYSizrHzpMY3NGrG5e4eHNPhPaLEo0eyoKQSSUMR65SQ4Kcqlfshj8P7whaAbL/8g9Fz6xy/DSAGp8sYSPhL8mC9ABmNUe0gcsCX76pgh9y0YpauN69BYQacc0visWsOwK7L3/gIFcIFShe5REZzdLy8RUWN9XbTVQAXrzl+fYeA3M2NHd1tdIknH2TNJvW/KaHAaHIr8+iSPQe+hdW3alSEnHSv3mEwDBt+JQO6KcoDYoSUs0CmeEcGDk4m65SdhV9I8mRg8w/tDEN19pNefJeAnKxK4L3sYwwkcuo1k0sGp/XsvyqjOJAgwqT639TUlerPJrAIg1HRQmxLP0bkehYLSshtywPUW57WebixB8weTmdPXYfU36ZAhGEBppW5Ekv2iviQHqb1UEEeq+jAJDzbQgPXwOtWNdR5dYLkde9pE578RyIWSW0vVilg/xABmJkkb1EBZHxkUAGua4GurKT716pvaEbUl+MNU5q8iQF5uYdGg6azQ4xiSbQK30HgYl3iUmFjLm9gdskmmWQlKrz5iqXnQoW4Cmyll6ZFRbDWD2QPl5EXy4R0tIue+EErp2/ZswHk1U2uu/JcfX0fMk9MbVMdILI/b+jaIaHMuuMiBVM1v/yQzmhLkjIpIaP4K9mGvOBWNZ3mCUd5DWtTscRYL2tUQchEi6f4xfA3QG+bsk5VSZ5+LO5bxLWi7hsy9TqYBSmETT8elPZMNU/RwWTtTxYeMrBs4U56+HTuCgRLIu0hDy+oHCPh8IVeh6FIAS/Z6WiXW6WcoyCX0M6pTjZuFpxilxy3aZvIrj9BB379e4v8bVKBFkT0uYOmsSQeuuoON1jAbLCDsTmXSXkYFnK9zYrDA/RUFUDvLywJIQKESQFsNoRkspgDsxYDAAD7TIhkIA0J5+WK8q0faOulkyKtdlomcLcsd5Ejh
 gWeTzDRI
 h24UKBM89kOdB3zJWxSpG/yU0KQsiwkwtre9IMZYh/MxUz/aEKyifeRdvIyPVp43f6FizLXcfGUYlue+JBSPmPXNMnTh68yezGdd+vjMzPVRifFpgIcShUAdYXD0B0Dv6c0GPjBimnDu/eFu3xhc5IGDnm1RDMOYYRoKNL+c5pyfxzEEf+rFwWtG8YWIIyPUHCHSLmICrbm56WjWLJ6KKXI7OGthOuScdoC00v2C1eoilr/aW5EH8q7T2K37HmekQ0zlncL0zQyyBaZs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 1:51=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On 2026-10-22 12:11 AM, Pasha Tatashin wrote:
> > On Wed, Oct 21, 2026 at 11:53=E2=80=AFPM David Matlack <dmatlack@google=
.com> wrote:
>
> > > > #define DECLARE_LUO_SER(name, expected_size, ext_flags_count, paylo=
ad_type) \
> > > >     struct name {                                                  =
         \
> > > >         __u32 size;                                                =
         \
> > > >         __u32 flags;                                               =
         \
> > > >         __u64 ext_flags[ext_flags_count];                          =
         \
> > > >         payload_type payload;                                      =
         \
> > > >     };                                                             =
         \
> > > >     static_assert(sizeof(struct name) =3D=3D (expected_size),      =
             \
> > > >                   "LUO struct " #name " size mismatch!")
> > > >
> > > > For example:
> > > >
> > > > struct luo_memfd_payload {
> > > >     __u64 pos;
> > > >     __u64 size;
> > > > };
> > > >
> > > > DECLARE_LUO_SER(luo_memfd_ser, 24, 0, struct luo_memfd_payload);
> > >
> > > This looks pretty reasonable but I would name the payload
> > > luo_memfd_ser. The combined struct that DECLARE_LUO_SER() creates
> > > should never be used directly since the offset of the payload in that
> > > struct is only valid in the current kernel. So I would give that
> > > struct a special name that makes it obvious you shouldn't be using it=
.
> >
> > Lets drop the fourth macro argument and generate the combined struct na=
me:
> >
> > #define DECLARE_LUO_SER(name, expected_size, ext_flags_count)          =
    \
> >     struct name##_hdr {                                                =
    \
> >         __u32 size;                                                    =
    \
> >         __u32 flags;                                                   =
    \
> >         __u64 ext_flags[ext_flags_count];                              =
    \
> >         struct name payload;                                           =
    \
> >     };                                                                 =
    \
> >     static_assert(sizeof(struct name##_hdr) =3D=3D (expected_size),    =
        \
> >                   "LUO struct " #name " size mismatch!")
> >
> > For example:
> >
> > struct luo_memfd_ser {
> >     __u64 pos;
> >     __u64 size;
> > };
> >
> > DECLARE_LUO_SER_HDR(luo_memfd_ser, 24, 0);
>
> I think we are getting close, bu I have two remaining concerns:
>
>  * Reserving bits in each flags word for continuation leaves gaps
>    in the flag space that users have to know to skip.

Yes, but callers should never manipulate the raw flag words directly,
and we can provide simple accessor macros or inlines that take a
contiguous feature ID (0, 1, 2, ...)

enum luo_memfd_feats {
    LUO_MEMFD_FEAT_HUGETLB =3D 0,
    LUO_MEMFD_FEAT_SEALS   =3D 1,
    /* ... */
    LUO_MEMFD_FEAT_FOO     =3D 15, /* Automatically lands in
ext_flags[0] bits 0:1 */
    LUO_MEMFD_NR_FEATS
};

if (luo_ser_get_feat(hdr, LUO_MEMFD_FEAT_HUGETLB)) {
    /* handle hugetlb */
}

>  * struct name##_hdr only matches structs written by the current kernel
>    (in terms of length of array and offset of payload).

This is not an issue on the incoming path, we never cast incoming data
to struct name##_hdr or access ->payload directly. Instead, we parse
the incoming buffer, dynamically compute the header size from the
continuation bits, and cast the payload offset to "struct name *"
based on the negotiated feature flags.

>
> How about this instead:
>
> struct luo_ser_hdr {
>     __u32 size;        /* Size of header + payload in bytes */
>     __u32 nr_flags;    /* Number of features encoded in flags[] */
>     __u64 flags[];
> };
>
> Each feature occupies 2 bits of flags[], so feature N is always bits
> [2N+1:2N] of flags[N / 32], with no gaps:
>
>   00: Feature not present
>   01: Feature present, safe to ignore if not supported
>   11: Feature present, must be supported by the next kernel
>   10: Invalid
>
> The length of flags[] and the header size are computed directly rather
> than by walking continuation bits:
>
> static inline u32 luo_ser_nr_flag_words(const struct luo_ser_hdr *hdr)
> {
>     return DIV_ROUND_UP(hdr->nr_flags, 32);
> }
>
> static inline size_t luo_ser_hdr_size(const struct luo_ser_hdr *hdr)
> {
>     return struct_size(hdr, flags, luo_ser_nr_flag_words(hdr));
> }
>
> static inline void *luo_ser_payload(const struct luo_ser_hdr *hdr)
> {
>     return (void *)hdr + luo_ser_hdr_size(hdr);
> }
>
> and bounds checking is just luo_ser_hdr_size(hdr) <=3D hdr->size. The
> payload is always 8-byte aligned.
>
> Payload structs are then declared on their own, with no header:
>
> struct luo_memfd_ser {
>     __u64 pos;
>     __u64 size;
> };
> LUO_SER_ASSERT_SIZE(luo_memfd_ser, 16);
>
> The static_assert covers the payload to catch embedded structs changing
> size.  Asserting the header doesn't add anything since its size varies
> by kernel. And because flags[] is a flexible array, the header can't be
> embedded in front of a payload in a combined struct; it can only be
> reached through luo_ser_payload().
>
> I think the only downside is that the header increases to 16-bytes when
> there is at least 1 flag. But I don't think we need to be so concerned
> about an 8 byte difference...

I would prefer to keep the default header at 8 bytes. With 15 features
fitting directly inside the base __u32 flags word, adding the first 15
features to a struct keeps the header at 8 bytes and does not shift
the payload.

Computation-wise it is also very similar: for the 99% of structs that
have <=3D 15 features, LUO_FLAGS_CONT is 0, so computing the header size
is just a single bit test with no loop. Even if a struct ever needs
ext_flags, the loop will walk at most one or two extra words.

Pasha

