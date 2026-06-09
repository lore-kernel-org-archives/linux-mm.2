Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 993A4CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 20:53:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2E036B00E6; Tue,  9 Jun 2026 16:53:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDE816B00E7; Tue,  9 Jun 2026 16:53:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCDDD6B00E8; Tue,  9 Jun 2026 16:53:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B54DF6B00E6
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 16:53:30 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5BE3D1A0791
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 20:53:30 +0000 (UTC)
X-FDA: 84861574980.01.7EB01F5
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5AD3F140007
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 20:53:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UGcH+PGh;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781038408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ciPLz0BxzGV6iVw62tuwMuRgsc1E7ocBiaZ0b0Nuy6o=;
	b=mPaeJXQrEOoxf/BTcX2Vl8GmV0B4EA0YT5IpMVSx9ybZ0h8iv5Erqg/pdOWW6YrCANAllN
	npS/Tj7gte8+JUVCiwIFq+K3QnGFMnnZJmhfmez+LO86l2PZ6H+Mk3x8Y+TiiKDtL0ur8e
	zufpEiQFZRMwOnrYnU0zLw0L7LE6Pj0=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UGcH+PGh;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781038408;
	b=3VQoMgGuIJKB8VzE2CfI0mQimc4pkz2fYiBjCUZJpszaZGQbuAomM+JGxoNlxlwt3AaQAi
	cxj4ayTsZ/RktqaHA2xpZu75VsaJ2afr93oa4Jnu3eN9ybhbeU4LiJdIndrnVcwcxsMEZh
	AyIUlbavIFcYtBVXQcNXqQAq9U3bTEw=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2bf2911f93cso3645ad.1
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 13:53:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781038407; cv=none;
        d=google.com; s=arc-20240605;
        b=M0Fb/5oPRbZW8+BmhIv+UgnixXQtE+D3MqJRnVEo+gpXjxwbwKDITE4luyW/KNFOfd
         b24o8OxrFp41cA/RMlwHldtFfCW99NrL/U1TgHaY1vAjQ+sz3dCha1+hfFRWSDsid8Ge
         jfkSAiGreEiavbMHxbIApeIOGIPkok+J8z3N/rl1zhxufpToM17HNAmR2sZKHMuuzcQs
         IKtfh9n9ne8CDMq3IqEVsK5FHE5TGlw2JMMC9heCH4iRABoCHP996HYFgx4LcL1yscJr
         GghMMZ3iHX+qveXGkHNetKoivBSjNZjE9CiqcR5h/sd3YCZTU4LRuvxev4Bsvzy7F9vI
         nuRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ciPLz0BxzGV6iVw62tuwMuRgsc1E7ocBiaZ0b0Nuy6o=;
        fh=Dbm59YGvkyz4Hi3zuGWyQn/X28JC+URoyMaJB8spD7M=;
        b=OkpCjE+c0SOPcd3O+kHuLJj4XiNLNrWQOEmIE0DpPIrWjc9VY0o4s6UNT6TZUS1q8m
         zumPscYZq832bSJ/RzksA36d3L/F/2TjDf4QCuvNxMDnWtmOkFoRsHTBRLtLTRiOOmth
         TzWz9xb97ynwPfPx0nT607udw9thsZ2DdSGrVlSC+incOn9JvXKMJ7pACFZDzFCa1WU8
         5QbMTItZgO30DDQQL6OHWDmw63OEMLwuVs2aoXFZY4F7xc6gKu4JPdMZqgqQS38ALGLL
         gHV7JaXgGwez0Pg2XmykaNKqw79Pi9fAaf8217y8+WmdqVTQX2oXnKFof7+JOTKX0rj+
         2TKA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781038407; x=1781643207; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ciPLz0BxzGV6iVw62tuwMuRgsc1E7ocBiaZ0b0Nuy6o=;
        b=UGcH+PGhIBP4Mm7mx2zx0F8veUh8SDJpNQYGdUMkNqpg/ubiMj+822CaWblWeTv4wW
         WsPlpQcgnEIAAdA96dggHXtzutZ3BaUecmIVVG4EzmfD9aBlxFwP01cYDuTxFiw3W/96
         eFGTr9kPheziISrL+RZvniEeb3RbXqQwTDffYted9+3cZwSe0WOhx1tD3ONr/zrdd1UN
         45U+7OSoHEzUEc0Snm2FFFKHwOJ/NjDlTMrscXyYh8p08QN09XMaIhZ/QKCulTLQKGKu
         M3g422Nkfza8CbJwwbClS0hZwzpql/wdb+ArM22McwGseBmK86KQtS9ttBgT2ww4biL1
         DNiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781038407; x=1781643207;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ciPLz0BxzGV6iVw62tuwMuRgsc1E7ocBiaZ0b0Nuy6o=;
        b=PhnO93mOVwXSeNs4AyAedAuT4YZyYdWuMnA4samRBQ+/wujhKCHZWOMlJ3Y/bp30vE
         dnGGDhvrj5DHG6xDEADqyRMgq2PeGQIJLwVdUuQhi7JBtW0Uuds0sKOcn0HWt50aGbpP
         vvg7zP7pGYzm+DEx9v9/QjmVddHx1zo5cK+2mMhpQ5rOMfYNzg8Wu/cjx9IZeIwISBIx
         NB+pz62magGBGrZK8WJTDDjgphnTCHNojG4M9FZF1aUL4+LZJdO6pzdWt/wjCG/CA3Nr
         ihP68Qe3spDW4w9w1tADo39zvwRccwHpoYMF6pp0HwdoujnaUmpQPp9k5OW7naCSSboi
         qbZQ==
X-Forwarded-Encrypted: i=1; AFNElJ9Yv3n5QoVi/dslp6NcS1yoAhxSnUcwM846z5/7M4nyMIxse0B/kmjwwo43k69vBr3VPfUSFyFvJQ==@kvack.org
X-Gm-Message-State: AOJu0YwKh+EGV/msZ+L774eSX0H10pnzLAHE5yxAyF6njWY4skEfzwGO
	tT/RfyVGGuASsGND/9vz0rF18LvbgPDSI8kticwtzfLqoZOuA52VzQJrBWsc4wLiMPGrvByKfzi
	Ei+zOeiizOfa2/JRUBDJ0HnwzDNQVyN5RJKr/iWah
X-Gm-Gg: Acq92OGh0sKXDnOsWJ6mb0myxhTY/8xPgBTkRyhNLXvNkFavb0R1fbvdbnlCMR+ldSa
	EOy4F7ap6YdeJZiUdWaThUllahQyGojwmKRe8CKnOZIdbxiqZrzKceI7of7ohQSBx9iho1uOaGS
	RjkiUwP0uohRC5G2K0GXgl4dXlLutlN+EiZWVGHJQ68u8Pm2ngDqEFuvnW0AO8NiBN0jMFailA+
	HpPmNT0GjmYT6LDFQhTFbBbtdR1hi5wvVSkXmdeqb1ek+VjGH1NWWWjayC96aFR/RrjmSftnA5g
	GHSeCKuCAnd0XeuLLUmjGsinIPGPK0+sGGrkG7jjzg9KJhEW/pqxqHXJHbc=
X-Received: by 2002:a17:903:2283:b0:2c0:b19c:2e10 with SMTP id
 d9443c01a7336-2c1ea96cbb5mr8374015ad.0.1781038406624; Tue, 09 Jun 2026
 13:53:26 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1780701922.git.abhishekbapat@google.com>
 <b608a6f7d71e3b728f766dbc6dfa1d1753ddcff5.1780701922.git.abhishekbapat@google.com>
 <1ec17313-cd2b-4389-a05d-998757af30b3@linux.dev> <a58e659e-5f54-4511-9a29-dc921002d102@linux.dev>
 <CAJuCfpHtdd=9D68cfRp4HDHHHCZdzTNP_RH9i2D-f9tJXht56A@mail.gmail.com>
 <ebcbe4a8-127b-4d12-83f1-dec93f0a9c61@linux.dev> <CAJuCfpGbxO0zu_UAWCYNNv8RHgT=E4AF0tgG-kWoLXECOL3byA@mail.gmail.com>
In-Reply-To: <CAJuCfpGbxO0zu_UAWCYNNv8RHgT=E4AF0tgG-kWoLXECOL3byA@mail.gmail.com>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Tue, 9 Jun 2026 13:53:14 -0700
X-Gm-Features: AVVi8Cfn78ORqX4oA_nr5VyV7O6esWdCgDaXx8ANezh2vF1JBG6XK4Z31C3kswU
Message-ID: <CAL41Mv7pdX-m8rOQE+PjwTUkXi4x5FffR=6Yjhe2N7-DBaR2VA@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] alloc_tag: add accuracy based filtering to ioctl
To: Suren Baghdasaryan <surenb@google.com>
Cc: Hao Ge <hao.ge@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5AD3F140007
X-Stat-Signature: r3zkfbecth43ko6f1b1yb8uupj6rwaqm
X-Rspam-User: 
X-HE-Tag: 1781038408-497229
X-HE-Meta: U2FsdGVkX1/7H++tTB2BKe6lua9/nrDOYdpz75KNgXZnhT68dZtYAnzEjPNGa0YlAXVfdolCfAc2xD6I0ZkL5IdqtiyYYzZF4Q6yxIFeGLPWB8qMK6NwPaiMO53R/f7PJ3pZqTwyyxUibgSc/7caszhm6d7XfnuKMA/0+vmqb2OhqMj7rFXBjGrFSlThGMfwZ3NWkZxlmsWrOoBxqJbsKv7bpqoA66ZCU/u3/fVt2L6Bjj8bIZa139mLeIIepoeHkgDj79O5U0Rgk5yAHMM9/lnZZejUUWeHDm4vWJxqGiYwwPN1Pn7mxF9utUg3iioyMAPCtAxPbNiBx5hxn9KdHtYGT6LW2m1bm/LnSxmt6fDX4k51K0ophuhV4RK0MGIBMuHVx4uCwmVOhh89noHQiPGeWdEPmsrSB0uqAUSaq9X9DIwl/dRJntgLh97MCPq+lwa9MnDe7CkwEZK4hvPtYuAFqGomj90io2G3wMNR4EnHfAUEC13gkBSXOQWfmo2eRuoyj2NJidp1BnFP5omm0B5wBbMdc7tgFlelyfLyUASLHQIk4VqedMWyBhkGVkGDfKvfqtPmI52PP9rOW+tkkqh1KTJ7Rg2ziEHtCdiKh8GTDA5w4mFWne+Upuaf9/5mnQnttegWQzrMp9UyiQ1HDmGs7/uS7Ilg6acNw5y8Wt9rn4e0/qufCiXaGj/8Jug3r/kdC7VGCKx03lAj7t8FH1ns+jJpvPssDObteW4SrSbSjORr0+qEjPXeM0EazujL7PofD7wZkwvPo/LrkyIMvm1MkW9/odrvX2+2sz0octXpUy7brIvq5H/j62sntVT+8U/fjzIVaunuiRsdtkgeBrA2XzNGegKrFBC9sjQK+NFbmjYVq4YzhbFVUqdmBUTArD1Dy+VtlUfEQZhsXH0Ica8SDc9+m03PNfzPcllF397GFhymzMETlpWvShNzXzbFHhANjTSqrTu0Xv5TzqR
 aesC/zge
 0Ml2HAWs1Ne7vnlgXR0t00R5sgwVKfQ5eS5kdbWn47CgsoZyVIM4ZeHU+b7fvtyLV6eOYxUKibJjbwWdzufigY3NhzlO1LuXwdjR581VBOHXfVfzzjd7iz/1CbD0tPeFSiiDlWVoot73Mzlb1igpGpaWCOrelYTaUO+lrzCCN8x39p529F1tZkCigggHacP0PelTSaHthG2v6gZBhnvuEmEDOI1ISmgVIwwjxVZ44FMp6uXGSqLNg6HjCXX3vp4qXn+kGgO6hsVgBdfV5Uwd/KmAYXIAq7vi+WwK0enYomqonDPg13LnO4xeXrSAKmL8JsdrG1B3TEJUNZ08=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 9, 2026 at 7:41=E2=80=AFAM Suren Baghdasaryan <surenb@google.co=
m> wrote:
>
> On Mon, Jun 8, 2026 at 6:26=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
> >
> > Hi Suren
> >
> >
> > On 2026/6/9 04:55, Suren Baghdasaryan wrote:
> > > On Mon, Jun 8, 2026 at 1:25=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrot=
e:
> > >>
> > >> On 2026/6/8 14:22, Hao Ge wrote:
> > >>> Hi Abhishek
> > >>>
> > >>>
> > >>> On 2026/6/6 07:36, Abhishek Bapat wrote:
> > >>>> Extend the allocinfo filtering mechanism to allow users to filter =
tags
> > >>>> based on their accuracy.
> > >>>>
> > >>>> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > >>>> ---
> > >>>>    include/uapi/linux/alloc_tag.h | 3 +++
> > >>>>    lib/alloc_tag.c                | 8 ++++++++
> > >>>>    2 files changed, 11 insertions(+)
> > >>>>
> > >>>> diff --git a/include/uapi/linux/alloc_tag.h
> > >>>> b/include/uapi/linux/alloc_tag.h
> > >>>> index 0e648192df4d..42445bdb11c5 100644
> > >>>> --- a/include/uapi/linux/alloc_tag.h
> > >>>> +++ b/include/uapi/linux/alloc_tag.h
> > >>>> @@ -20,6 +20,7 @@ struct allocinfo_tag {
> > >>>>        char function[ALLOCINFO_STR_SIZE];
> > >>>>        char filename[ALLOCINFO_STR_SIZE];
> > >>>>        __u64 lineno;
> > >>>> +    __u64 inaccurate;
> > >>>
> > >>> I was wondering if it would make sense to define inaccurate as a fl=
ags
> > >>> field
> > >>>
> > >>> (e.g. __u64 flags with ALLOCINFO_TAG_F_INACCURATE (1 <<0)),
> > >>>
> > >>> so that only bit 0 is used today and the upper bits are reserved fo=
r
> > >>> future use,
> > >>>
> > >>> aligning with current kernel codebase.
> > >>>
> > >>> This design also allows for better extensibility if we need to
> > >>>
> > >>> add new flags for any reason in the future.
> > >>>
> > >>> We also need to add flag validity checks if we go this route.
> > >>>
> > >> And I've reviewed the issue reported by Sashiko, and I think it's va=
lid.
> > >>
> > >> When we expand the allocinfo_tag_data structure
> > >>
> > >> struct allocinfo_tag_data{
> > >>
> > >>       char modname[64];
> > >>
> > >>       char function[64];
> > >>
> > >>       char filename[64];
> > >>
> > >>       __u64 lineno;
> > >>
> > >>       __u64 inaccurate;
> > >>
> > >>       __u64 bytes;
> > >>
> > >>       __u64 calls;
> > >>
> > >>       __u8 accurate;
> > >>     /* padding */
> > >>
> > >> }
> > >>
> > >> I think user space may see two fields related to inaccuracy.
> > > Yes but one field (inside allocinfo_tag) is the input parameter which
> > > user provides to specify the filtering criteria and the other is the
> > > returned tag information. It's similar to any other tag attribute
> > > which you can be included in the filters.
> > >
> > >> How do you like these modifications?
> > >>
> > >>
> > >> diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/all=
oc_tag.h
> > >> --- a/include/uapi/linux/alloc_tag.h
> > >> +++ b/include/uapi/linux/alloc_tag.h
> > >> @@ -20,7 +20,6 @@ struct allocinfo_tag {
> > >>        char function[ALLOCINFO_STR_SIZE];
> > >>        char filename[ALLOCINFO_STR_SIZE];
> > >>        __u64 lineno;
> > >> -    __u64 inaccurate;
> > >>    };
> > >>
> > >>    /* The alignment ensures 32-bit compatible interfaces are not bro=
ken */
> > >> @@ -40,7 +39,7 @@ enum {
> > >>        ALLOCINFO_FILTER_FUNCTION,
> > >>        ALLOCINFO_FILTER_FILENAME,
> > >>        ALLOCINFO_FILTER_LINENO,
> > >> -    ALLOCINFO_FILTER_INACCURATE,
> > >> +    ALLOCINFO_FILTER_FLAGS,
> > >>        ALLOCINFO_FILTER_MIN_SIZE,
> > >>        ALLOCINFO_FILTER_MAX_SIZE,
> > >>        __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_MAX_SIZE
> > >> @@ -50,16 +49,20 @@ enum {
> > >>    #define ALLOCINFO_FILTER_MASK_FUNCTION        (1 <<
> > >> ALLOCINFO_FILTER_FUNCTION)
> > >>    #define ALLOCINFO_FILTER_MASK_FILENAME        (1 <<
> > >> ALLOCINFO_FILTER_FILENAME)
> > >>    #define ALLOCINFO_FILTER_MASK_LINENO        (1 << ALLOCINFO_FILTE=
R_LINENO)
> > >> -#define ALLOCINFO_FILTER_MASK_INACCURATE    (1 <<
> > >> ALLOCINFO_FILTER_INACCURATE)
> > >> +#define ALLOCINFO_FILTER_MASK_FLAGS        (1 << ALLOCINFO_FILTER_F=
LAGS)
> > >>    #define ALLOCINFO_FILTER_MASK_MIN_SIZE        (1 <<
> > >> ALLOCINFO_FILTER_MIN_SIZE)
> > >>    #define ALLOCINFO_FILTER_MASK_MAX_SIZE        (1 <<
> > >> ALLOCINFO_FILTER_MAX_SIZE)
> > >>
> > >>    #define ALLOCINFO_FILTER_MASKS \
> > >>        ((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
> > >>
> > >> +#define ALLOCINFO_FILTER_F_INACCURATE    (1ULL << 0)
> > >> +#define ALLOCINFO_FILTER_FLAGS_ALL ALLOCINFO_FILTER_F_INACCURATE
> > >> +
> > >>    struct allocinfo_filter {
> > >>        __u64 mask; /* bitmask of the filter fields used */
> > >>        struct allocinfo_tag fields;
> > >> +    __u64 flags; /* bitmask of ALLOCINFO_FILTER_F_* */
> > >>        __u64 min_size;
> > >>        __u64 max_size;
> > >>    };
> > >> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> > >> --- a/lib/alloc_tag.c
> > >> +++ b/lib/alloc_tag.c
> > >> @@ -249,8 +249,6 @@ static bool matches_filter(struct codetag *ct,
> > >> struct allocinfo_filter *filter,
> > >>                   struct alloc_tag_counters *counters,
> > >>                   bool *fetched_counters)
> > >>    {
> > >> -    bool inaccurate;
> > >> -
> > >>        if (!filter || !filter->mask)
> > >>            return true;
> > >>
> > >> @@ -277,10 +275,11 @@ static bool matches_filter(struct codetag *ct,
> > >> struct allocinfo_filter *filter,
> > >>            ct->lineno !=3D filter->fields.lineno)
> > >>            return false;
> > >>
> > >> -    if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
> > >> -        inaccurate =3D !!(ct->flags & CODETAG_FLAG_INACCURATE);
> > >> -        if (inaccurate !=3D !!(filter->fields.inaccurate))
> > >> -            return false;
> > >> +    if (filter->mask & ALLOCINFO_FILTER_MASK_FLAGS) {
> > >> +        if (filter->flags & ALLOCINFO_FILTER_F_INACCURATE) {
> > >> +            if (!(ct->flags & CODETAG_FLAG_INACCURATE))
> > > How would you filter records which have only accurate data?
> >
> >
> > Sorry, I overlooked this case.
> >
> > Since allocinfo_tag_data exposes both inaccurate (from allocinfo_tag) a=
nd
> >
> > accurate (from allocinfo_counter), userspace developers might mistakenl=
y
> > read
> >
> > inaccurate instead of accurate when checking accuracy.
> >
> > How about we add a comment to clarify?
> >
> > struct allocinfo_tag {
> >
> >      /* ... */
> >
> >      __u64 lineno;
> >
> >      /* filter criteria only; see allocinfo_counter.accurate for actual
> > accuracy */
> >
> >      __u64 inaccurate;
>
> I think we had comments showing which block of parameters are inputs
> and which ones are outputs but I'm not opposed to an additional
> reminder here.
>
Ack, I'll include the recommended comment.
> >
> > };
> >
> >
> > LGTM for the rest.
> >
> >
> > Thanks
> >
> > Best Regards
> >
> > Hao
> >
> > > Overall I would prefer ALLOCINFO_FILTER_MASK_INACCURATE rather than
> > > ALLOCINFO_FILTER_MASK_FLAGS. The fact that this attribute is a
> > > single-bit flag is a technical detail. It's still a tag attribuite
> > > like file and module names and IMO deserves its own filter.
> > >
> > >
> > >
> > >> +                return false;
> > >> +        }
> > >>        }
> > >>
> > >>        if (filter->mask & (ALLOCINFO_FILTER_MASK_MIN_SIZE |
> > >> ALLOCINFO_FILTER_MASK_MAX_SIZE)) {
> > >> @@ -318,6 +317,10 @@ static int allocinfo_ioctl_get_at(struct seq_fi=
le
> > >> *m, void __user *arg)
> > >>        if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
> > >>            return -EINVAL;
> > >>
> > >> +    if ((params.filter.mask & ALLOCINFO_FILTER_MASK_FLAGS) &&
> > >> +        (params.filter.flags & ~ALLOCINFO_FILTER_FLAGS_ALL))
> > >> +        return -EINVAL;
> > >> +
> > >>        if ((params.filter.mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
> > >>            (params.filter.mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
> > >>            params.filter.min_size > params.filter.max_size)
> > >>
> > >>
> > >> Thanks
> > >>
> > >> Best Regards
> > >>
> > >> Hao
> > >>
> > >>
> > >>> Thanks
> > >>>
> > >>> Best Regards
> > >>>
> > >>> Hao
> > >>>
> > >>>
> > >>>>    };
> > >>>>      /* The alignment ensures 32-bit compatible interfaces are not
> > >>>> broken */
> > >>>> @@ -39,6 +40,7 @@ enum {
> > >>>>        ALLOCINFO_FILTER_FUNCTION,
> > >>>>        ALLOCINFO_FILTER_FILENAME,
> > >>>>        ALLOCINFO_FILTER_LINENO,
> > >>>> +    ALLOCINFO_FILTER_INACCURATE,
> > >>>>        ALLOCINFO_FILTER_MIN_SIZE,
> > >>>>        ALLOCINFO_FILTER_MAX_SIZE,
> > >>>>        __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_MAX_SIZE
> > >>>> @@ -48,6 +50,7 @@ enum {
> > >>>>    #define ALLOCINFO_FILTER_MASK_FUNCTION        (1 <<
> > >>>> ALLOCINFO_FILTER_FUNCTION)
> > >>>>    #define ALLOCINFO_FILTER_MASK_FILENAME        (1 <<
> > >>>> ALLOCINFO_FILTER_FILENAME)
> > >>>>    #define ALLOCINFO_FILTER_MASK_LINENO        (1 <<
> > >>>> ALLOCINFO_FILTER_LINENO)
> > >>>> +#define ALLOCINFO_FILTER_MASK_INACCURATE    (1 <<
> > >>>> ALLOCINFO_FILTER_INACCURATE)
> > >>>>    #define ALLOCINFO_FILTER_MASK_MIN_SIZE        (1 <<
> > >>>> ALLOCINFO_FILTER_MIN_SIZE)
> > >>>>    #define ALLOCINFO_FILTER_MASK_MAX_SIZE        (1 <<
> > >>>> ALLOCINFO_FILTER_MAX_SIZE)
> > >>>>    diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> > >>>> index ddc6946f56ab..cbcd12c4ef9c 100644
> > >>>> --- a/lib/alloc_tag.c
> > >>>> +++ b/lib/alloc_tag.c
> > >>>> @@ -249,6 +249,8 @@ static bool matches_filter(struct codetag *ct,
> > >>>> struct allocinfo_filter *filter,
> > >>>>                   struct alloc_tag_counters *counters,
> > >>>>                   bool *fetched_counters)
> > >>>>    {
> > >>>> +    bool inaccurate;
> > >>>> +
> > >>>>        if (!filter || !filter->mask)
> > >>>>            return true;
> > >>>>    @@ -275,6 +277,12 @@ static bool matches_filter(struct codetag =
*ct,
> > >>>> struct allocinfo_filter *filter,
> > >>>>            ct->lineno !=3D filter->fields.lineno)
> > >>>>            return false;
> > >>>>    +    if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
> > >>>> +        inaccurate =3D !!(ct->flags & CODETAG_FLAG_INACCURATE);
> > >>>> +        if (inaccurate !=3D !!(filter->fields.inaccurate))
> > >>>> +            return false;
> > >>>> +    }
> > >>>> +
> > >>>>        if (filter->mask & (ALLOCINFO_FILTER_MASK_MIN_SIZE |
> > >>>> ALLOCINFO_FILTER_MASK_MAX_SIZE)) {
> > >>>>            if (!*fetched_counters) {
> > >>>>                *counters =3D allocinfo_prefetch_counters(ct);

