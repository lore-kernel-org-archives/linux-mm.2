Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F40FE83828
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 19:24:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CF056B0088; Mon, 16 Feb 2026 14:24:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A5FC6B0089; Mon, 16 Feb 2026 14:24:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A8DE6B008A; Mon, 16 Feb 2026 14:24:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EB5076B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 14:24:17 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6E7CD13BAAF
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 19:24:17 +0000 (UTC)
X-FDA: 84451295754.26.EC49771
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6ECAB12000D
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 19:24:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LnGvGyao;
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771269855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rz7mQp8ex2cSaZFr8FlTwlodXakULcF4/KmW1plCXjo=;
	b=YgzwO9LY+IlTvd8Qy9i6/9sbtmiP3VnJRcZzkCTmXde81e8iCdjZM61/ekMh/9iH2juJcE
	qAdr2JWZQBOQr+6+Pz4HthQaIhjyc0YE0InMhaza8giSqvQB0WoLU5v7Qyy2FN1MoIWOp5
	Gof9UVOieGru5wNmHFdxEKEME6DcmxA=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LnGvGyao;
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771269855; a=rsa-sha256;
	cv=pass;
	b=UQqAXl6Oeflw7xN+/MbNbGR+S4FEqVAYtatMX6Axd6UpD2SsGdHXrLzVwnf6y3nXulq7oA
	FHNNNXiQ+ZUz3W8p55VkdrksrwkDTcaJpFMLkx91Bmmdy3c+4WtPdHru8Uc2niMLTarhzH
	sOm4oq8uNbvLSE9XKaGeqfGbk5qsg/E=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5033b64256dso1023931cf.0
        for <linux-mm@kvack.org>; Mon, 16 Feb 2026 11:24:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771269854; cv=none;
        d=google.com; s=arc-20240605;
        b=UaEeWGlCULtpguse2mgNiPNudF4LKjruObwmKd8R2Swp9yRUMprsDfp1d6oqbmfGD9
         Vl8gbBZ7mIQgTuqRldol9qctOo/QXVyP6D1YcwhBxjrnM0LEgX/6kaBe0EmiHFZJ/L3H
         oWgdD3s7KPSTGdXzFg0klmWmfE3GGrxn6yQhnHqbO7DuUw20Kbds1qL7Yp28NtYgWumm
         KcKyzYTcf44ie4jLAeYI39bjnduRmbpGzhfXYpbTMof2CSLKv6V1cShkpoWPe2bWNHMu
         2P3y39Lx6D3psTQYUpjj7JJKuwdzsGy94rA9KeakWlxgLdtPY9yiXaQb/7GR4tJ4Vd/+
         gCMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Rz7mQp8ex2cSaZFr8FlTwlodXakULcF4/KmW1plCXjo=;
        fh=NXQAqJjbfFNsXTl/4a3k3kCbIUHPNrn1FKS1+l26Sa4=;
        b=WC1A1OspeJLeFMBsaaspOLdZV/WjptDlo2K3QBTNvC0SFYieTHwmvP8jhYAIcW+yqQ
         vyOsOaXoKy93ljKfX4Fnh4NE55jvvpJ9BQMn1j94jo+DFbf6uYkX92B8EosqkaHpb7xw
         Keed0NT7EbWW2OuUR9Whbou3uPNN/W07+lb3AL7V+9JkSKhQRQtYJ2c0Sxo9Bt1Hf0Cj
         KbQj6ZGmQnp8tPyXY+doD4i4fXVDKSAHEjqQnVNDc0BCIuav1OGwfipX9iynh3NBkcin
         gd9nJmwzvOQ8QsJCeQpEm77PPEn6CtLvIUZ7c+W+tuMr2SFCm/p2jVfljSNjGZIiCkkP
         dctA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771269854; x=1771874654; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rz7mQp8ex2cSaZFr8FlTwlodXakULcF4/KmW1plCXjo=;
        b=LnGvGyaoPcSOAMbtvt65y7o6Q0K3KWd+T4CK2VW0uT0top6io1FATCkauN3ma/ZLEZ
         o4IhPbgBG1gVhYewc+4+Tf46a8lXWzxFC2jAeiTku8W1WTdeyEYjcTWmT3TxQMMmJsG/
         ZTF8buqyxzc0u1FYOGY41K8M79PtJwGun6ihWX4KErAIWOM9f2HlDVk2XsA0Vpos2CdU
         ykfQpeftm9MyiZvCjtg9GERjbLq240xdV0bcSA1P4TvJfqNLekAeWKMJAQWmI8EuCsum
         /IsY3B/35WzKoxKB3mbG/o4XBaLpYh1qx6DgxSNrVyOR3lHjrcxRmTN7o26VoNNBGn9Z
         OCfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771269854; x=1771874654;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Rz7mQp8ex2cSaZFr8FlTwlodXakULcF4/KmW1plCXjo=;
        b=P2XW4a8reCVaVNEeJABoTpmzGFDGSKUlrSLMSt59zJyc6gZGnudoRfwpVVMjS00jec
         aN8/7FXR9eoswCimCre04BqrsU7EGYcD2J69NY53FvcShE+2Z4J5T+b2McxeaFkPMBI0
         iHZWXtkltj6wRXYzk7Wt/f/XnIAYoqT4XNLt4wm+bvttiGmBDBaTtCbahSRkHDRm8emK
         GuTkQYnaf3oXlOJCPci+ne4x8aqPxe9sxOi+5PgVdnCPlbiaT1nwaShL5aQXCbDeemu5
         /fvdNynBlK0vEZFquYS8q7adCUj7AXYhnLDV3sl6zcA4CKz9/Qnx5ONaJdsujj4el8Cr
         3W0Q==
X-Forwarded-Encrypted: i=1; AJvYcCWpRoxrMDRyX2Vz9ysJRh5DJ9RqPX+ZNZO0GY78gJi3cBq+6AFLPu19YHYQtlACmufPfvnEsMVKLA==@kvack.org
X-Gm-Message-State: AOJu0YwYWTjdOVQUt4SKtPPn/nS5fZMyjd2Nby4ztMF50sXYQClL7cQa
	Y/d9iKOqHabTQcf0T6mTxPaXxmwT4l0dJUnCau+AI1q/unx2+IU6fuhsXQI8vO45MF1UW7Denu/
	tOEkMjT7fJsV+PTFERwjFmarR0DMfzNWDYKkC8fu7
X-Gm-Gg: AZuq6aLovCBJOY7Or799GQuc9dM6OwVPuqt9md7vkBt1aWUmejwpI9QvkSCP/nzkP1R
	gUoCcZIYE2xVhmpVuSAeedEX/WbFkjRljcHUBVbZhzNG4mRVmicHqBgkNekigQB4oknT/ze/ouQ
	7RRvo3BC6GygznndOsk7ZJchpe/EkCXvbh/NmYe5An1F3lUcwOJ4HXYHz3bDL7bPnaZjF8kC3kz
	ryBs4zq5wiJGbcqRR6xXXPdxxNWVsYI/PXZpDcUywrgQr8ru8haMeZhjRjANyy5/IrxL19otRzP
	8y8WuY3pn/fnjeq+PFkSNgC0h1+GlgYwPFI=
X-Received: by 2002:a05:622a:8c15:b0:4ed:ff79:e679 with SMTP id
 d75a77b69052e-506cdb80f2fmr9503821cf.19.1771269854100; Mon, 16 Feb 2026
 11:24:14 -0800 (PST)
MIME-Version: 1.0
References: <20260216121751.2378374-1-arnd@kernel.org> <15272AAE-6C14-4A80-AF70-4A46D1047B61@nvidia.com>
In-Reply-To: <15272AAE-6C14-4A80-AF70-4A46D1047B61@nvidia.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 16 Feb 2026 19:24:03 +0000
X-Gm-Features: AaiRm53h5sGEBeQUyfgg8Ll2rURgEV3bOB95Z7JNPTwawirSgjFHLij38fBcZp0
Message-ID: <CAJuCfpE=79uHrqKn4vmQ09TuR1uZBxpDck9WXXoG6OK6a0pZ=A@mail.gmail.com>
Subject: Re: [PATCH] mm: change vma_alloc_folio_noprof() macro to inline function
To: Zi Yan <ziy@nvidia.com>
Cc: Arnd Bergmann <arnd@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Arnd Bergmann <arnd@arndb.de>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kefeng Wang <wangkefeng.wang@huawei.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6yr49b7ogseyn4rya4h8c9uqau6939p9
X-Rspamd-Queue-Id: 6ECAB12000D
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771269855-444829
X-HE-Meta: U2FsdGVkX19DFSXOWn9ZpXHZ8tMX4PsU+uY5akz6MXfr+UBl1LYNjPwYfvUvPAc0Bimm/U/oQh0O+vRyrRCZKV0WzLmC72Ycl1CnHzDkpYf/3Lblw+7jgjxH+CLhUIZ33StvKXqraLBKwS0sLEjpi4Q03BHEGtNoU1CWwjs9mfRyGizI8ocMwxaHPIa4Kii7KrOVwiBlp2seKpTRY0EsHmpkVq6SuoVDC+cZ5Goa7QgE50cnFuggTGDOCQs6PUsGIWnsmQZe/8JES3uzU//IiIxFcyH2pOI6XrN1NR5aI/vCAFopMzUi5sXaHXDEE+vG12ljtPyQFp0uRtk5atfIvYij7Xpc9M3IdqYdIj+pItQ46Tuat5YhI7r94AbTIYUMcHkHtu+3Nd8ewCfyChQIbrctoHBnzwgZobEYXrVexh6Ok1tg/0k0ITl3LtCneWOZTQPtt3sPi4IfVGIV1Q494cREc/UOxz5RJkYOgK+OIK7yxQtZaumSnZIpIt47oNUQWLwoZ9ayIujrW1yrH5ESVrO+ppwsCNAagPJELlrdtjLFpY4hWdcwgXjBcr2lcSrtn7lx0zu6ub2nQvBsokmcoNy54CGEHgq+ngxA1XE+JA2MmoE16MZ2XAl+i4f/cKkCyxjgZNZf7qxLKVzOtjlyIKLoumIAEUGmVExVAj6Ko0tAYCqtFSSXAemxSn7V+jtK4j4NjiLw4V1d8rzztXbbjrYQbvph5wcaN7lRYaUQYAZX4tdcptD3prJsg9bu7+0m8uUFbhRsAkqFT49yNUfPpBlyVe62qSPBviFvtbN8CZquzg3TKkldBTtnHzNboVKeBB49jnUXkrPh77IZabvh59Fn4cmvvAO0euSx15V/FDT0/GQTGBAp3VxXloG0z3TpLvOvy1lPzlMIDQsk4wfgpvtw64kIHIjQ1TkoaU+/NYSXq2BHU3CRIAcEl+ZwGJ5GRCfQS7EciMdD7UoWVVv
 PNoMA+Dx
 qI3hRLIot8atORNvFncBmGJmGBxMLbAzk6MiJbR3nfC7o8L9Z0IkjdinCQQQcNMjJYP7UI7h4JJOKVTxd+VnNtFfwvDC0tKGzNwd4MHPuM1adWSWO6VZPGugN7Ak4GLjTMK0WyJnOkOLm1W3MihbE1ObvE40Vl0O3woKs8VGcIKhOnGyjp/vckibxliTNO8aBY5IxUlQC1aoYh3E+/eboSVnAlzhhTDvMroLDfhAnXiDf2K+70RD4mrVmNS4QCgqYUw8BTO44bK+od6qX6VqSqqGsVej6/3FVyW8vz86B/hEGlIh2hW0sb4G0AGd8OOwrj0R/bC/KHjMfRo+Vg+aM5GwS4CCHEr0FxUSmXO47+csOImGiCi3QaAlLIfWPB4eHIgFMoxI8jOs+RDGFx0dETDJYd0WIsXMbuUgY6ouE7lqAyXiAAvvKI27MUOc5YR9htXNZTjBiIX6IGIy6ZJTJeJoxEOfWWsUS34yoBskNqYdRGMmkiVDxy3BlX4O/S9gpb2KP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 4:58=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> On 16 Feb 2026, at 7:17, Arnd Bergmann wrote:
>
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > In a few rare configurations with extra warnings eanbled, the new
>
> s/eanbled/enabled
>
> > drm_pagemap_migrate_populate_ram_pfn() calls vma_alloc_folio_noprof()
> > but that does not use all the arguments, leading to a harmless warning:
> >
> > drivers/gpu/drm/drm_pagemap.c: In function 'drm_pagemap_migrate_populat=
e_ram_pfn':
> > drivers/gpu/drm/drm_pagemap.c:701:63: error: parameter 'addr' set but n=
ot used [-Werror=3Dunused-but-set-parameter=3D]
> >   701 |                                                 unsigned long a=
ddr)
> >       |                                                 ~~~~~~~~~~~~~~^=
~~~
> >
>
> But addr is used at line 739 or line 741:
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/=
drivers/gpu/drm/drm_pagemap.c#n739
>
> I wonder why compiler reported the error.
>
> > Replace the macro with an inline function so the compiler can see
> > how the argument would be used, but is still able to optimize out
> > the assignments.
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  include/linux/gfp.h | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> > index 6ecf6dda93e0..23240208a91f 100644
> > --- a/include/linux/gfp.h
> > +++ b/include/linux/gfp.h
> > @@ -335,8 +335,11 @@ static inline struct folio *folio_alloc_mpol_nopro=
f(gfp_t gfp, unsigned int orde
> >  {
> >       return folio_alloc_noprof(gfp, order);
> >  }
> > -#define vma_alloc_folio_noprof(gfp, order, vma, addr)                \
> > -     folio_alloc_noprof(gfp, order)
> > +static inline struct folio *vma_alloc_folio_noprof(gfp_t gfp, int orde=
r,
> > +             struct vm_area_struct *vma, unsigned long addr)
> > +{
> > +     return folio_alloc_noprof(gfp, order);
> > +}
> >  #endif
> >
> >  #define alloc_pages(...)                     alloc_hooks(alloc_pages_n=
oprof(__VA_ARGS__))
> > --
> > 2.39.5
>
> The changes look good to me.
>
> Acked-by: Zi Yan <ziy@nvidia.com>

LGTM. _noprof() functions don't need to be macros.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>


>
> --
> Best Regards,
> Yan, Zi

