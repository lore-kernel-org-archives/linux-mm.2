Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB204CD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:43:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A8B86B00D7; Mon, 18 May 2026 19:43:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 159146B00D9; Mon, 18 May 2026 19:43:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 021766B00DB; Mon, 18 May 2026 19:43:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF2326B00D7
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:43:14 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9FFE91C09D5
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:43:14 +0000 (UTC)
X-FDA: 84782169108.13.54C7A34
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf07.hostedemail.com (Postfix) with ESMTP id A96A04000B
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:43:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="pC22Cw/+";
	spf=pass (imf07.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tIQAWxEmdM/RrKGZCNpzQANMh1bWzdys4gzz0aFMA0g=;
	b=d3dZ5zkRaOsLi+ZBaEtEzc4KXDuP0LHo0dOSZF4LHzDYNlIAqQE0eDqxnuBrh7K/ukFg7C
	/HjPthkaKGka6I/gqA53qA1pUD/CmLdTasqnA2f7LR/srbXifkS5Tji2DXcKgbax/YVPVf
	1p6BtXEAPvrR6Kg3h0pXbBtPdxubljk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779147792; a=rsa-sha256;
	cv=pass;
	b=jmppEfpaRZJZKlwfR69yQQ7CBUBEOMTZJPYQk0+C2/MRDg9oPx4TKUQJX06V5WN78Z1pOW
	ZrG8mRUZjnZiA1ZgiPm8br/cS/6N0xjEpqEQ2o/PTAszwJZRkhytP6AOXjO3isFz8DEUuq
	iOC4WJbQ71Kr2CSdgq8bZQj1U78FIyc=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="pC22Cw/+";
	spf=pass (imf07.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2ba180a022dso1165ad.1
        for <linux-mm@kvack.org>; Mon, 18 May 2026 16:43:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779147791; cv=none;
        d=google.com; s=arc-20240605;
        b=aZckcxK5WDMGIhgHQoVzoXJF2IVAzuaPSN2lM4tFU22RSzgoGyY/UGnv8cu/twaGwW
         lMm0JIdovz3uN0yWVnVYPYNod+mQevGaFjU/KIdHatB5d/0z74PxRlohiEAiraArPaNW
         iZo+lt4EE6HbFxZ9BVE+LwF0rvXg8QSYg+vlt9OOXfQB5vfSzgzTrEtfMf0jIl9vYxHq
         x05fHVTpRf9uxFSwfKBdnBjB6KsueCH4LZTztPLEBGy26KhdLqz77fEnoprRrDA0cRnJ
         id3l3PqN2zUztpznIBf2qBGAc0zTGWEEq639umiuEsys2G9sBOpLnls3/YsQ5NX/w+QX
         cfjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tIQAWxEmdM/RrKGZCNpzQANMh1bWzdys4gzz0aFMA0g=;
        fh=Tnj+t9+qfZzNAxH7BmfcAD1CBYeyjdTNx+8oIR8bboA=;
        b=KZT099GKWn4dkzJHwDMVxOp3C78lKZvXaSgGlZ1Lhyd9hULVo4STIpsqi0gphvLJvD
         QL4u29+OAyoFL8Kv/RN2S3hha7qkjLjtKI220fJ5BWUNpoe4FMKEYVgJxeKBqBqy+PBJ
         g083r34L1FpYB6wrMq3ytbLlVE+i82j9IYpwTmQG0FSixUvkJowGIG8xVOnO9qYmHWkK
         WFgm4dT0tb/1Kl0qzsaUGL9nYzTMMLj9j/dl3xOfPzcu+negcYAWLXpxSN8mXdiVf9ZM
         qzkQtzW/EG3ZSyijMqd2IwXpIcrcA1MjkO2oBqChk3itfou8qJlh7JgEcDw+RxzmbhXk
         Vm1g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779147791; x=1779752591; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tIQAWxEmdM/RrKGZCNpzQANMh1bWzdys4gzz0aFMA0g=;
        b=pC22Cw/+OnWUrw4BnrKJGNvxsW3ka3ktvUYLal7ZM5HTbG2xt/stJOWDRm3Tss4rgk
         4F/PkwG5ahhM+NrgOy/S20HCAMYZt60pAxqsmBhw11HukakvMQeWAzWnJr8q2z1slH2E
         OSWhdySC1OfVwJ9hEuAD/JrcWlG+dCzQUVvpLNUdjaLaAIW5+ZPE8MGFrD8zjFy6pk3W
         IFAaImo3x0ejXEUe4E1/zoAO4n5fQYki98lWXg/7iCjsPbgi15/0kHsyCnY/mz3DPHkz
         kXw9KNFP/rK3XUfxsjB8P6/uP7xt2pFEFuoEFEJNa3lWj3HpaRWAnZ3vnLGzN5YrJPgL
         cZ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779147791; x=1779752591;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tIQAWxEmdM/RrKGZCNpzQANMh1bWzdys4gzz0aFMA0g=;
        b=laYbB+gw0+iqUzxsn/XvcRR3bwcz0+mu2iFNbR2PbLFrEHHZMSv3zk8ypFDftE6Yi3
         GDKf1HfqwEciCzyeFi5TzQDAUeM2XX63jAL7oK6ZIXrLwgoZw7onOygf+PCvhdqwQfuX
         WLUF8xraEQgbM9xJ/EDviLLUjecusz/Nph1DBoUt9Yq3Nb21U3jgQ7Fv7sOqdLUaLebk
         qvpVRkSAzVzhowwjlD1R6MOtNwCsIfieLZ53BBqHeojqaOvZNH5Y6tJDpU5mbR2xufxi
         4YxyWkh/72UYbiJiJQEIozoninC79WKjG3OfyT3eSyTsDGaP6JTq1AV/OkhDgmPMPs8x
         ZAuQ==
X-Forwarded-Encrypted: i=1; AFNElJ/x2fyiH0gUvJTmdJKCG6YGxFJET4Id5dpMuxtdStmu1Q9TpmfKLtA4Tzj2ArfXrzK/j1/HnYCdhA==@kvack.org
X-Gm-Message-State: AOJu0YyPrbqjQ6H/iBXfnrUjWzY9q4UmsaHTPVQaKj9uZMOVY10h/nRf
	uvqA14sVz6D8iIbJ4L7PAOEQErL9Yb9xIYdyBrWLuIoFlOgxIA6BgEVGk0puR55yGBl5kWnxNXm
	lTvGEf5IaDkbkugVcW5Y+awRfVXys1HrtL2bfranq
X-Gm-Gg: Acq92OFu0uHKJ0uW8s8SaO+2jv5j8mPFmWbqK6hxwSEr+GeeAwJCOdV4gSkWNJh8CnL
	0Io2KECoG81mSGuRPSxenydScfUnqapYl+9Qj57OZ1Wt1f/8qCvy01rvHXUaYQqiG3+CU3S9SwG
	w+ZK7lfpSM4gvlAd/Jrtl0HKDYmLXoXzdhcg7CBW2WC6d7LFbpNM5rEnEmZFQBvL4wbWywXWbWy
	1ampHQjvpJB1mFg/8pFy61cthebm50Bs0dUijwjmR9NU6uyWnLsiE2ZTLRH+SVEdCCztRz7mDYK
	4QMxehPFYyYeE0LRn20kbBj4IQ4521O7sRFNVXu0vBsdd/gX
X-Received: by 2002:a17:902:ffcb:b0:2bd:6dad:7ccc with SMTP id
 d9443c01a7336-2bdb0416634mr4524725ad.24.1779147790769; Mon, 18 May 2026
 16:43:10 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1777936301.git.abhishekbapat@google.com>
 <2d1cbd93b987198d9569ff54b7fee4ae6aad5ff6.1777936301.git.abhishekbapat@google.com>
 <7e4881af-3fca-474a-abb7-daa75986e3ad@linux.dev>
In-Reply-To: <7e4881af-3fca-474a-abb7-daa75986e3ad@linux.dev>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Mon, 18 May 2026 16:42:57 -0700
X-Gm-Features: AVHnY4ICS2Wy3i3Nmz4pvA_CeAv8fx1_nlprwGLEcpakt3R2q4lzl0AtWVkwJzI
Message-ID: <CAL41Mv50-jqm5Zmd9Ko-yqB5y7P4kHzweuxFH3Q8W6jr=fPGUA@mail.gmail.com>
Subject: Re: [PATCH 2/6] alloc_tag: add ioctl filters to /proc/allocinfo
To: Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A96A04000B
X-Stat-Signature: rqj51izy4eowfzehapcbuupt38af3s34
X-Rspam-User: 
X-HE-Tag: 1779147792-762668
X-HE-Meta: U2FsdGVkX1/ZC3Lh5k7qD0g+P8LKF6Mbp1Hy35W12vzTGJchb7h6c/N8FJeCdTEWTmTaSnrRXxEa/fyIdqlhTcj+/fSL+hf+QFL2rQzdeP5YR0uYc/P4busn5tLwbGRPhPVVfjk6f6r0DqqiSaj69HLKWcFRzp9M+My8YEZ6Y77fQwMFFZAY24vL12sUFQw78bMbtb6fl46iRntVi6a+ZUoRzgAUeZTNPIbjafKQD9/2I2FT/mmi1PyY4wyGIX4wqvIosA7s0D6FvbrD+qldvKG/Zxka4Mvamxqh6NJlntZL4lyPUTs2KwTrggDaggCW1B2BHyxTDPmecKmqpNNOVDZwaXbhKE070etm0+gNzNhmaznkXgGLFPD4kz5y5EBntFCniak21bbEoT12z6cPZYv0lJVNYGK20VhMLHlMD3grSz9E/NAfB+T/DEgticU4XrootznrfWhz4BRCIwXvekIn686WhOHaG65fbv1ShyxwqqZW0Hp2hRnfPSlwInD2C+0uJfqoh23fNT4atAKlHsRYh+y1hzEbj9qxzJyorsG6gpuBkd51afDzanpBwiRbH5L6+jRxaxjeaZPWFEkmretW4WoH5UBfXnZS59DlaMVqvw3MPm6K+J+xdYvn4yrHvWvmXfYdlfQKLABS49uMz8hbxJtZX2SCcMJNGXbgr0aNpwYuvb06G8uD4lU36eXzX9Udr4CvWTh0GiVeWWkj6SrCvWQRFeDIe5W14mcPLztwcdoM4NG20K6noKlFgBQLCBlhpdxwBRIArpGe1asMkxSxHwARNON+NjfFTN5igxaeqRWNPG8qcKdZy+10lzjRc43JbL6WaUts+Eq36wDbqRqvFukH5pMd2TGEr9P7Rq1Vzd7uhiVk3sxULeX6nzlsVv3D/NGHuUFgdT87/H6YA98zfXj5WGLv2xvFPooPA7CK1HbSfN3VwFOgaOt27eXicXKZHN3tvYLO1XYLk0n
 +LTp2RYf
 GgiygOsO/KYZHL8YvPw1tqmTf+M8ZL8/tnN6VPvxrQJacoy+z+iCCq4FSdLJDLD8Mmt8VGJhBWpeUbzD5xlbJudRs/mpjKfws7UyUFqSA6D9jzv2JInF54h2Xg3rriIx3z6dEQW6UHut7Oqxg3FCbMvOXEnMameZIJ4FJh6oERHpQc5mvRAV/PogA3nCWYO99PaOy6INMhgj593DLpNIWyIxZKzOnDXbw5dNKZecXoXym8kRLFimrXQWAPFm9Nnu+siJRGd4FdUNVfuIKL6rNK2B2PgEVKD88olVOnPRMzxWiNMGz/76n+4aF2jZbz0X67lCYEs2ri92zih4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 11:15=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Abhishek
>
> On 2026/5/5 07:36, Abhishek Bapat wrote:
> > Extend the capability of the IOCTL mechanism to filter allocations base=
d
> > on tag's module name, function name, file name and line number.
> >
> > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > ---
> >   include/uapi/linux/alloc_tag.h | 26 +++++++++++++++-
> >   lib/alloc_tag.c                | 55 ++++++++++++++++++++++++++++++++-=
-
> >   2 files changed, 77 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_=
tag.h
> > index e9a5b55fcc7a..0cc9db5298c6 100644
> > --- a/include/uapi/linux/alloc_tag.h
> > +++ b/include/uapi/linux/alloc_tag.h
> > @@ -34,8 +34,32 @@ struct allocinfo_tag_data {
> >       struct allocinfo_counter counter;
> >   };
> >
> > +enum {
> > +     ALLOCINFO_FILTER_MODNAME,
> > +     ALLOCINFO_FILTER_FUNCTION,
> > +     ALLOCINFO_FILTER_FILENAME,
> > +     ALLOCINFO_FILTER_LINENO,
> > +     __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_LINENO
> > +};
> > +
> > +#define ALLOCINFO_FILTER_MASK_MODNAME                (1 << ALLOCINFO_F=
ILTER_MODNAME)
> > +#define ALLOCINFO_FILTER_MASK_FUNCTION               (1 << ALLOCINFO_F=
ILTER_FUNCTION)
> > +#define ALLOCINFO_FILTER_MASK_FILENAME               (1 << ALLOCINFO_F=
ILTER_FILENAME)
> > +#define ALLOCINFO_FILTER_MASK_LINENO         (1 << ALLOCINFO_FILTER_LI=
NENO)
> > +
> > +#define ALLOCINFO_FILTER_MASKS \
> > +     ((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
> > +
> > +struct allocinfo_filter {
> > +     __u64 mask; /* bitmask of the filter fields used */
> > +     struct allocinfo_tag fields;
> > +};
> > +
> >   struct allocinfo_get_at {
> > -     __u64 pos;      /* input */
> > +     /* inputs */
> > +     __u64 pos;
> > +     struct allocinfo_filter filter;
> > +     /* output */
> >       struct allocinfo_tag_data data;
> >   };
> >
> > diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> > index 5c24d2f954d4..7ff936e15e97 100644
> > --- a/lib/alloc_tag.c
> > +++ b/lib/alloc_tag.c
> > @@ -47,6 +47,7 @@ int alloc_tag_ref_offs;
> >   struct allocinfo_private {
> >       struct codetag_iterator iter;
> >       bool print_header;
> > +     struct allocinfo_filter filter;
> >       /* ioctl uses a separate iterator not to interfere with reads */
> >       struct codetag_iterator ioctl_iter;
> >       bool positioned; /* seq_open_private() sets to 0 */
> > @@ -156,6 +157,11 @@ static void allocinfo_copy_str(char *dest, const c=
har *src)
> >       strscpy(dest, allocinfo_str(src), ALLOCINFO_STR_SIZE);
> >   }
> >
> > +static int allocinfo_cmp_str(const char *str, const char *template)
> > +{
> > +     return strncmp(allocinfo_str(str), template, ALLOCINFO_STR_SIZE);
> > +}
> > +
> >   static void allocinfo_to_params(struct codetag *ct,
> >                               struct allocinfo_tag_data *data)
> >   {
> > @@ -187,26 +193,67 @@ static int allocinfo_ioctl_get_content_id(struct =
seq_file *m, void __user *arg)
> >       return 0;
> >   }
> >
> > +static bool matches_filter(struct codetag *ct, struct allocinfo_filter=
 *filter)
> > +{
> > +     if (!ct || !filter || !filter->mask)
> > +             return true;
> > +
>
> Minor: in matches_filter(), returning true when ct is NULL seems
>
> semantically odd since both callers already check for ct !=3D NULL
>
> before calling this function. Not a real issue though.
>
> > +     if ((filter->mask & ALLOCINFO_FILTER_MASK_MODNAME) &&
> > +         ct->modname && (allocinfo_cmp_str(ct->modname, filter->fields=
.modname)))
> > +             return false;
> > +
>
> In matches_filter(), when ct->modname is NULL (built-in kernel code),
>
> the modname filter is skipped due to
>
> ct->modname && (allocinfo_cmp_str(...))
>
> This means built-in allocations always pass the modname filter. Since
>
> built-in code doesn't belong to any module, maybe it should not match
>
> when a modname filter is set:
>
> if (filter->mask & ALLOCINFO_FILTER_MASK_MODNAME) {
>
>      if (!ct->modname)
>
>          return false;
>
> if (allocinfo_cmp_str(ct->modname, filter->fields.modname))
>
>      return false;
>
> }
>
> Thanks
>
> Best Regards
>
> Hao
>
Ack, will include in v2.

> > +     if ((filter->mask & ALLOCINFO_FILTER_MASK_FUNCTION) &&
> > +         ct->function && (allocinfo_cmp_str(ct->function, filter->fiel=
ds.function)))
> > +             return false;
> > +
> > +     if ((filter->mask & ALLOCINFO_FILTER_MASK_FILENAME) &&
> > +         ct->filename && (allocinfo_cmp_str(ct->filename, filter->fiel=
ds.filename)))
> > +             return false;
> > +
> > +     if ((filter->mask & ALLOCINFO_FILTER_MASK_LINENO) &&
> > +         ct->lineno !=3D filter->fields.lineno)
> > +             return false;
> > +
> > +     return true;
> > +}
> > +
> >   static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *ar=
g)
> >   {
> >       struct allocinfo_private *priv;
> >       struct codetag *ct;
> > -     __u64 pos;
> >       struct allocinfo_get_at params =3D {0};
> > +     __u64 skip_count;
> >
> >       if (copy_from_user(&params, arg, sizeof(params)))
> >               return -EFAULT;
> >
> > +     if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
> > +             return -EINVAL;
> > +
> >       priv =3D (struct allocinfo_private *)m->private;
> > -     pos =3D params.pos;
> > +
> > +     skip_count =3D params.pos;
> >
> >       codetag_lock_module_list(alloc_tag_cttype, true);
> >
> > +     if (params.filter.mask)
> > +             priv->filter =3D params.filter;
> > +     else
> > +             priv->filter.mask =3D 0;
> > +
> >       /* Find the codetag */
> >       priv->ioctl_iter =3D codetag_get_ct_iter(alloc_tag_cttype);
> >       ct =3D codetag_next_ct(&priv->ioctl_iter);
> > -     while (ct && pos--)
> > +
> > +     while (ct) {
> > +             if (matches_filter(ct, &priv->filter)) {
> > +                     if (skip_count =3D=3D 0)
> > +                             break;
> > +                     skip_count--;
> > +             }
> >               ct =3D codetag_next_ct(&priv->ioctl_iter);
> > +     }
> > +
> >       if (ct) {
> >               allocinfo_to_params(ct, &params.data);
> >               priv->positioned =3D true;
> > @@ -240,6 +287,8 @@ static int allocinfo_ioctl_get_next(struct seq_file=
 *m, void __user *arg)
> >       }
> >
> >       ct =3D codetag_next_ct(&priv->ioctl_iter);
> > +     while (ct && !matches_filter(ct, &priv->filter))
> > +             ct =3D codetag_next_ct(&priv->ioctl_iter);
> >       if (ct)
> >               allocinfo_to_params(ct, &params);
> >

