Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B290FCCD19F
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 22:18:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFAE08E0008; Mon, 20 Oct 2025 18:18:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD2D98E0005; Mon, 20 Oct 2025 18:18:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE8D28E0008; Mon, 20 Oct 2025 18:18:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE4638E0005
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 18:18:39 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 573BA13A821
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 22:18:39 +0000 (UTC)
X-FDA: 84019907958.03.777BF24
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6BF5E2000C
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 22:18:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=duzqBFSu;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760998717; a=rsa-sha256;
	cv=none;
	b=aFGdAQfldZ04l/Sn/30yGXfp7n1lwH/cfSPuPwa0mVau/zORrhZpV1ZOSsbQC5qPqNPdGo
	X97lIu9gmCfvOV6zmnKCTPqDFtEmMrE/+ZGGiol6s/aadXiBIT3Pq8m5NU0OqjDYkBP7Dm
	Msf+ha3qJyPv97G53qNT7jJsWpXIQns=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=duzqBFSu;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760998717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WDaMUs9ysjJq2V2EnmmexrY7sMGK4Wn3C8vR2OOio/g=;
	b=t+vwz8DucaLPEh7/QFoYsr0tIVT+fHM2Ik5OAmI/GNC9dgNEdVTgOVf2vHlGtZgDetd+5g
	D/v+oc4kB4pBB2MQsmKzMAnbUQyKiGjtE4MXg3+yXrrR/5CAJ5U9ICSvRsl5v+iqrNlsAA
	XaoxZ5CZ0lfNSfT7gtE3V1uSVyXRhic=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-63c556b4e0cso5225937a12.1
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760998716; x=1761603516; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WDaMUs9ysjJq2V2EnmmexrY7sMGK4Wn3C8vR2OOio/g=;
        b=duzqBFSuRcm5j3omZfYzj7TG+g6srtpSD4Gk1SKkzBT83je0O8qkwdQCgcYCUYwqyI
         RVBM/hKXzAbca26IIcfZc8HYbiDrqwBWVOMAC0SEbxU+nyqyYCguwkTLyCXH/a91xaqa
         Pitjqcq61ZGcH8pJXdfyyTFfhh4KN8lvg86ld0MHFCtgB01WHEsMksUdXaW0uB80pRlV
         MEm+lLL7NQigb7jZ27La6/BkNTnRA7YgEyVtxwvXHWl5Wr5iMOf8nR0uWAixs7zlNcS9
         h1AMxl37zZt60c1OWorsGvTZ1GgfjbewXrzb2Aqg/DkCFQVQSuUolfrPNLuUNQpFAjn/
         kVlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760998716; x=1761603516;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WDaMUs9ysjJq2V2EnmmexrY7sMGK4Wn3C8vR2OOio/g=;
        b=jN+mzFTulbTxDn9SRpcZNNJvgEpQkkeXaTdOSTp+lHcYIfSLVJ+RqXwR+4mPJt75Vv
         RA777T7ZphJptmj9y4BF4sMt/nbtjqeovr2oaCo/ZuL1WOAC2C45LbA264Omqymy2VzB
         Som8ZgKlhNRaymhj2KITyQ2T7rT65vDSQHIdjnzZ9e+X6zUqMToURQ2el7E1QFFfVzai
         DXdbYw9JtGjvyrSKtuo8BAlKBUJbEecLfv35Ff14KZkAOtzNS2RfvPyjj0zdOOMgZv7V
         sFQ70v9MjY5RsK+mkfyB/Qk3nhNIHpLrthd4guk6f5ODJ22i/53sKpVtP9VepKGstRjN
         xcvg==
X-Forwarded-Encrypted: i=1; AJvYcCXvfQZYqPTyKMHE40BxS5Y8X9/co/HAq0CQvQ0ZvOjlMRhy6z0KnjeCOQb16PWoeRaexYRblrqhag==@kvack.org
X-Gm-Message-State: AOJu0YxpqYQC52nXVmo6W+V0HiwHCosoV0BTe3htth9EHxDmscRjS146
	MwPI1fXMixmxUmRAy3irjlURD3cPdUL7kFofgj6g18cWFO9t2nL8fS6TgX/5lnJqn0vJCxGBHja
	WtcH94u0mtkx/SYvruNiQW5KM7RugxGCtc5WejkJWPg==
X-Gm-Gg: ASbGncu4OyrFTMwTTjljTxqs42teU0X9YDt6XM6CMAz6HUTSj8XJVuPX8xqeqfwO1+J
	zN1c+2L+zS5jc7wVa7rgJtBCQ7d1BgMoZt/+fg9zkICjvTBtQ9YwmByceUoS0pLNotQ7IjmhmuV
	69tAgJXCvJCp0vZsfiU2yYbngAfpcQCdD4MDGNck8e/+IYJQFmGvBzt9YkmgajHNZ1xeQiaVaoz
	fV+g2sovl/8MAPyJdPDfXJgf5XAqrmrTX7mXyJwGIGzVAaDvy9JR+fvag==
X-Google-Smtp-Source: AGHT+IGFz985JP/FEtDxD1hvHY/7YU+GyiyLDce6kdCarRwFKUOACHslpISyiCG0GwShiHdoOO2eNcmYTRmxIn7oa2M=
X-Received: by 2002:a05:6402:5656:b0:637:8faa:9df7 with SMTP id
 4fb4d7f45d1cf-63c1f6cefdamr10653493a12.29.1760998715953; Mon, 20 Oct 2025
 15:18:35 -0700 (PDT)
MIME-Version: 1.0
References: <20251018171756.1724191-1-pasha.tatashin@soleen.com>
 <20251018171756.1724191-11-pasha.tatashin@soleen.com> <aPXtWDPGHA2kCg32@kernel.org>
In-Reply-To: <aPXtWDPGHA2kCg32@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 20 Oct 2025 18:17:59 -0400
X-Gm-Features: AS18NWBy5p958YNTaetPtzYmdWYcTYv7f79OnV0oOta8WbMPy_4qsdcA5pKLWHA
Message-ID: <CA+CK2bDicreG8UPFPDmE9KAbKUy-M_oOPdrmwmsU0iFfjHKzvw@mail.gmail.com>
Subject: Re: [PATCH v6 10/10] liveupdate: kho: allocate metadata directly from
 the buddy allocator
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net, 
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, pratyush@kernel.org, rdunlap@infradead.org, tj@kernel.org, 
	jasonmiu@google.com, dmatlack@google.com, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: dxuu4p1s75w6xyk3txbtghi6e1mgk5go
X-Rspamd-Queue-Id: 6BF5E2000C
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760998717-740897
X-HE-Meta: U2FsdGVkX18HIir/u6+RfE1fxiO7KkT6yGxukTrDoSjNCmcNaO8YhQMkELa2ch77lz2MN0s4w08tGhUBn9fPwDKVJHmp0ZELuJjz7TlxFD5xozsOSM5A+RjE2bjjlvnVeB2gkZbMoyHDvbz6oOTlYaQJVEH4en9thE8CQEmuK2QPNNii3o1at9XW7pnVavjw8zMHM+T2xgcgXtgb6oHPUenquOeU55ID+LLaWbJtG8chgHpdvVQs1KoNCplSRTNPRm9vrTtuuFaPqjNo9qtnmDJ/F9syk2Aw3+NWVq5TtxiHHB1fx6nS/FkkH2OLsPFjN0vTivf3SKcA8OUBV/CkeDdntUDji8QKgXDPoswpImht1kkda2iDLNfoxGi9wqzlHD+G6ykPNMA66NzI+yA5et5wytg/i6y2Hf9hpgqgHzudvgFF9ox5wmkZouvnHm9f7t/TpCBqk3m/TQR2rcq8hszuZQOjBCyiY9jDWWa+6U0NyTsRmBDtlINwbBp45fhkB9RIeEJtvMYERY9l2M3S1CFXbKxqv3XRz73MzIXWmgF76rX+AxWlZIU3I2S1tq/QC9+EOFNKApfY1nuM7kHmCybEV8K0gfPLOq2aNoslndMMbtDhfK6IxwVqMk+EWUeKMmYgw1ivVBcCpJmoDiZKG6hs3NU3Q/afaRuNz/9Cn+gRQlgGLP1G2bAkA4e2dN+h1FdO33eJjaC6g5H8cwUHSpWk4u2RcqGxYrgS4E3how/o/RV/DvO9IF08zJiPsHLJOsfPHS6/aAi82utvOGw8pDin+wXkYrdZ83qs/icgzInQ6IlK7Hhe7+jykHFedTEeBzZpML5hxYs47c7hHtpivAxcTVLLNOslQfAe2ACF3IFbCieInS0xANkqV4c8SeQ31mAq4vBbbv8GRI1DEVdLBH8vXoMBoEbwlBiJ5MvqXuBkoesAQLxdQgGk2+JF2hx9cmj2r91RFs2B8IcIXva
 50Rh4Lw9
 fV96CKsPTraVC7HbqQOTLYh8ypOsV6dnyWaDSzc0ZpCNS1OCLUj8Bn180eDU2yrc2doHGe9MLrSY2bajlOz+GPqcZiVul9WCrOo64SBD2XW/FVPTlcgIHNnlC4nXVNUP98gu/cIBTI6NFoIUviUgtQa74xiLP0h9y39sljeSi0nzIReysmNY5A46PB4q6nsz9h4H1kZCT0gHVFFJRfVUrIubcqBZLEhHzN44XRD2dsmPoKCTHnFV5SJ66v0Us8qZxwD0SvgHEFqx4ZJZMkcwcWeqsNw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 4:05=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Sat, Oct 18, 2025 at 01:17:56PM -0400, Pasha Tatashin wrote:
> > KHO allocates metadata for its preserved memory map using the slab
> > allocator via kzalloc(). This metadata is temporary and is used by the
> > next kernel during early boot to find preserved memory.
> >
> > A problem arises when KFENCE is enabled. kzalloc() calls can be
> > randomly intercepted by kfence_alloc(), which services the allocation
> > from a dedicated KFENCE memory pool. This pool is allocated early in
> > boot via memblock.
> >
> > When booting via KHO, the memblock allocator is restricted to a "scratc=
h
> > area", forcing the KFENCE pool to be allocated within it. This creates =
a
> > conflict, as the scratch area is expected to be ephemeral and
> > overwriteable by a subsequent kexec. If KHO metadata is placed in this
> > KFENCE pool, it leads to memory corruption when the next kernel is
> > loaded.
> >
> > To fix this, modify KHO to allocate its metadata directly from the budd=
y
> > allocator instead of slab.
> >
> > Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation=
")
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
> > ---
> >  kernel/liveupdate/kexec_handover.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kex=
ec_handover.c
> > index 7c8e89a6b953..92662739a3a2 100644
> > --- a/kernel/liveupdate/kexec_handover.c
> > +++ b/kernel/liveupdate/kexec_handover.c
> > @@ -132,6 +132,8 @@ static struct kho_out kho_out =3D {
> >       .finalized =3D false,
> >  };
> >
> > +DEFINE_FREE(kho_free_page, void *, free_page((unsigned long)_T))
> > +
>
> Just drop kho_ prefix and stick it into include/linux/gfp.h

done

>
> >  static void *xa_load_or_alloc(struct xarray *xa, unsigned long index)
> >  {
> >       void *res =3D xa_load(xa, index);
> > @@ -139,7 +141,7 @@ static void *xa_load_or_alloc(struct xarray *xa, un=
signed long index)
> >       if (res)
> >               return res;
> >
> > -     void *elm __free(kfree) =3D kzalloc(PAGE_SIZE, GFP_KERNEL);
> > +     void *elm __free(kho_free_page) =3D (void *)get_zeroed_page(GFP_K=
ERNEL);
> >
> >       if (!elm)
> >               return ERR_PTR(-ENOMEM);
> > @@ -352,9 +354,9 @@ static_assert(sizeof(struct khoser_mem_chunk) =3D=
=3D PAGE_SIZE);
> >  static struct khoser_mem_chunk *new_chunk(struct khoser_mem_chunk *cur=
_chunk,
> >                                         unsigned long order)
> >  {
> > -     struct khoser_mem_chunk *chunk __free(kfree) =3D NULL;
> > +     struct khoser_mem_chunk *chunk __free(kho_free_page) =3D NULL;
> >
> > -     chunk =3D kzalloc(PAGE_SIZE, GFP_KERNEL);
> > +     chunk =3D (void *)get_zeroed_page(GFP_KERNEL);
> >       if (!chunk)
> >               return ERR_PTR(-ENOMEM);
> >
> > --
> > 2.51.0.915.g61a8936c21-goog
> >
>
> --
> Sincerely yours,
> Mike.

