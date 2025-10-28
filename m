Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20578CCF9E5
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 00:03:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58C4B800D1; Mon, 27 Oct 2025 20:03:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56337800C9; Mon, 27 Oct 2025 20:03:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47A77800D1; Mon, 27 Oct 2025 20:03:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3661A800C9
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:03:54 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E64DAB7D82
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:03:53 +0000 (UTC)
X-FDA: 84045574746.26.7D643D6
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf03.hostedemail.com (Postfix) with ESMTP id F04F12000F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:03:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=eqY5+5tH;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761609832; a=rsa-sha256;
	cv=none;
	b=xZLIIaES6tXKqKFdXIooRcJvQRWvqHujaoN4viYkG/By5Cd7aRWpwmmCqLk9YpjazbA3CI
	gTxUISUKrJxYMabCDXRp5di1mGSEyOUptnCHFVYJiieWxLnhg40nZoxj7ukUcQ4r6bOPTY
	JuJqeL6sggutg/PMfNPlSN9kVgSVKNo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=eqY5+5tH;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761609832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eIf9RmyxDj8h+YpH5/36r1Zq7AreK8JR3usDRLV8Ek4=;
	b=LU5uf1lxMM3o5S7E0qqjlYKsqodibWr5/evXn8rCj8aFG0gqSY/UBnBnezPlSoxtDnvMr+
	XBmBuuprM6mzpLK7oHbqRUvS0JIDgc/PXc0WRE0esXv2xXzyt+ii8eZIVR5cB/UtM8dFf3
	l3kT2g/LrXJytvMgSjZQk8YqO+a6CnQ=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-637e9f9f9fbso9744926a12.0
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 17:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761609830; x=1762214630; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eIf9RmyxDj8h+YpH5/36r1Zq7AreK8JR3usDRLV8Ek4=;
        b=eqY5+5tHMQLq869lqRZrqH1kAwCW+a4mb8edpmODrGUEEo14Oo0Cn35og84zNQdX2e
         SzQUXA1ueRQg3BJEoRzes+LFQG70+9BuAAzyDa6J0M7XK9U6Dj1Y608LWMIOKLTUvyl4
         2PbAGArWQNs8Ju2MRi0YVi2Hygr3vpU0LBk8KJgpot1BZSVN4tQOK/eurfyTDaDHft5j
         +rUFVzdPj697mK/kFjSHYs7bfb92RZZd+8th/J0mBuLrl4viam/bpjLB85v1Z6x3dwkd
         jqo+1EHr+c2+Vb4zyQxYdKe1lKIaluNZmas4ceHJJBbPwvBdyYJ3hx7bvCV6q/GtYJNP
         1G6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761609830; x=1762214630;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eIf9RmyxDj8h+YpH5/36r1Zq7AreK8JR3usDRLV8Ek4=;
        b=Ekdf0DYX7zbLzWkmFuDDtQNkH2zkqIzvidKrvYBxfgn2lUUwMnFjOiCz2n95VsHb2A
         EZvDpvLsgvvYqjAiFD2o7KzWDrlio6Nj5NWseudTpQUAncmlFZJbHzAkpXzQFrqv/jCX
         CMBxmxi3IhNWcI8sxq75Re8j/TpVRkyC53e9RJzd/6upK0zOEFFPfXp83hEv7Lqpb0Jo
         0Kv4I79v0AaSVLclIP+eqOchi16bL3bvQIZ4bqXlGIAXqOQaZ0aPr6U1YArtpFb06Ccf
         tSc0ONx39MP9FVT5ATcucb3yZj7TFZsMvCFA84ZiZ8nI/lvYD/t42Bhz1u/uYRDg9q16
         HQ3A==
X-Forwarded-Encrypted: i=1; AJvYcCU3uWzzlzsJeeBwRg5r/Ryagjw6c2YWgyEteF6GnBT7wrxgaRMR3BpAsykj0YqEso1mdontv2e4WQ==@kvack.org
X-Gm-Message-State: AOJu0YwVyvwpctdR9AG7p5L6GkatvI1shzXSb0575CJnMpQTGIlGAZAb
	HXSkdZJgBE7XcfuHmte4AKycQQxJSvvjNf0ro+SiEXdwqGfnSvZCCRpObOCFy94CS6G0arSTsas
	AO4ileycuaFSap+KZ5l6OpPS/ou8JvHmptVXwfbz9FQ==
X-Gm-Gg: ASbGncuJ2FBYAxgOGb7tfZ270+51/3OQzC6HHiXEEb14Kp6TFQm3DgyFehpr+52v1+P
	gMN7MF2ZiHamaKE6wibLs7IODOF6PqtMYU6g1iueZRCYhca0YJ1Ti5NJ3i3qyntYSmV0fp/Dm2H
	GxFsJ9LOFEL39xiCABvf5bDhQWQ+GntOBAf+BqNfa01R/48MysHjsOXdQNrGg5MG6j7GlpBmB1U
	d7WuGvktEw+Skecla/6h/HO/pIAZn61ffdF/gDxWz+33meKV1EPcXcyag==
X-Google-Smtp-Source: AGHT+IGRw73AgZE0pgL+h9bAcX5qxVKML+YkSwwVXL0+lNAI07sxHdi/1qytUtu817sC0wPtWFmC1YiZiNMsQzgmG+I=
X-Received: by 2002:a05:6402:4313:b0:639:dbe7:37b6 with SMTP id
 4fb4d7f45d1cf-63ed82669a3mr1767152a12.3.1761609830497; Mon, 27 Oct 2025
 17:03:50 -0700 (PDT)
MIME-Version: 1.0
References: <20251021000852.2924827-1-pasha.tatashin@soleen.com>
 <20251021000852.2924827-3-pasha.tatashin@soleen.com> <CALzav=fmTVGDxAUcuqmcegAtd8gEW4F3Zp3AGMQBtXrCQgp+aA@mail.gmail.com>
 <CALzav=fD47OCZRMNqDmHs798qpZzeU6eHHuNA+wyhmZ19aJ9vA@mail.gmail.com>
In-Reply-To: <CALzav=fD47OCZRMNqDmHs798qpZzeU6eHHuNA+wyhmZ19aJ9vA@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 27 Oct 2025 20:03:13 -0400
X-Gm-Features: AWmQ_bmun6_TBMsODMO_7WW-_vSEWe2X4Vt2vU_u_Hwqc2ubbYZU9T3vQlpJuDM
Message-ID: <CA+CK2bAKjU8PmfuwGJwwOyj3U5bYaterE_KQa9uVu+mmmLmmew@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] liveupdate: kho: Increase metadata bitmap size to PAGE_SIZE
To: David Matlack <dmatlack@google.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net, 
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, pratyush@kernel.org, rdunlap@infradead.org, rppt@kernel.org, 
	tj@kernel.org, jasonmiu@google.com, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F04F12000F
X-Stat-Signature: 8dggjed1w7mia6gzjo8piormitembwbj
X-HE-Tag: 1761609831-525258
X-HE-Meta: U2FsdGVkX1/Mh1zSJ84qZVgAiHk5/t5AEoVcbKYWy0gjh6PdSaWQwAABDKCIVbHogYFInbgk46gsMer0KNq1mho1NnbcWa6xnkBsONc1Oqzhk/fycjwsNMwCdhRCejSteLQYkyZs/R4kYHdjuT+p/xYlwTVJ+YxF0ZCDdaPO0uF6P/fEWomfOpcd85v271Z4Oxym9/QtKToUFzA+sh1iEWYYQfuygxaQlg+mV6eb2UOjcnXCKQEmeOFnObOwOF2IPCz1WN3E0hYRGljiXUXIpZq9p8y9uAUwQneOfCZdkmpxafS3nGiGfvXllwKdftFZNhsd82Yaus8ERrGBUeNhPNfCfrbIiktKKBRScZyA8Z5Uvd796cGPYoZjGzKvZNvoBnG/6t/93WQghcUXGtAlfV7AvPumqBeIa9TfdeJ4jDmrdNrRLYReiI7VtVutYddpnpkXhYJ/MCnK0nmYoaHUY2cbyfgy/r5aMTcDG7T9rL2Wr0+x2VRJgJ75OLSicDhiY+uVvpqM6OjqNRu8YKGttrgPIBQzT8YusRRRiOKdRVwLUMWNbK5JFUav8d+fDMvNHRlV6ULyS3DCokEGtBsr7CzhRnOuGL5jYJWwKF6DvGJ3fDC3bGEG3mxI7VCdpjTyfAiSH0FXE7Unl2w8DweqKf5DX++q2xuXhjers0MDevEqjPPsdBoTrQ6TAD+o4/khco+yDzZgkyZTOFU0OM4o07Wn2xIzna+Sl/5rj794755AY1Xk7k3cuPTxEM4nFmILQgQMXKvOG1DOmbQtB8BWloc2pAuBv9qoYD8zff+LvY211YqwJPPzl8FURSSVhbf/sp9UPWqck8qTDMstczsGKU1tAwGIQOaDY4GwWj+DOBh9qTGBGowk3/9ghg9kpipyd4Syou38DFK6lfItwDzYhXfevZ0lxufyejF4OUcDaBm3PzJqHosCswunMsZ8FRzilngSfJ3X2S4TZiKPBMT
 OJZg5yDT
 y3WLFyXNbXwY43L4rgtHHSq06IYtbvaV9vaiYopHzbN2NjIyvY7F3u3ygXsiF83LMqhfMZKC31fz9SwhvZ9iTC+F6a4f8iqcoFssmeTv6z3xtv9pnyWqBYThDuaot+kHmMF+FqzG7A+Y7BfBFHeqy/KHT/qqNo0wToI1/e9DNlzcIZRA8xGY6X0VvJlNAAXBFZYK3DKRonrY89D9xIvBvP+SNtZPzm/l661KQeZYvYQbvKPMd3UMQLnSpshLm7xoLFkcNytdVmQc3cR6vlIAD2wNeilnsp1JYfJk7v8Do08SmGd+cSgzBUWbrJQapX3kyizIu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 7:02=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On Mon, Oct 27, 2025 at 3:56=E2=80=AFPM David Matlack <dmatlack@google.co=
m> wrote:
> >
> > On Mon, Oct 20, 2025 at 5:09=E2=80=AFPM Pasha Tatashin
> > <pasha.tatashin@soleen.com> wrote:
> >
> > > -static void *xa_load_or_alloc(struct xarray *xa, unsigned long index=
, size_t sz)
> > > +static void *xa_load_or_alloc(struct xarray *xa, unsigned long index=
)
> > >  {
> > >         void *res =3D xa_load(xa, index);
> > >
> > >         if (res)
> > >                 return res;
> > >
> > > -       void *elm __free(kfree) =3D kzalloc(sz, GFP_KERNEL);
> > > +       void *elm __free(kfree) =3D kzalloc(PAGE_SIZE, GFP_KERNEL);
> > >
> > >         if (!elm)
> > >                 return ERR_PTR(-ENOMEM);
> > >
> > > -       if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm), sz)))
> > > +       if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm), PAGE_SIZE)=
))
> > >                 return ERR_PTR(-EINVAL);
> >
> > Reading xa_load_or_alloc() is a bit confusing now.
> >
> > It seems very generic (returns a void *) but now hard-codes a size
> > (PAGE_SIZE). You have to look at the caller to see it is allocating
> > for a struct kho_mem_phys_bits, and then at the definition of struct
> > kho_mem_phys_bits to see the static_assert() that this struct is
> > always PAGE_SIZE.
> >
> > I would either keep letting the caller passing in size (if you think
> > this code is going to be re-used) or just commit to making
> > xa_load_or_alloc() specific to kho_mem_phys_bits. e.g. Change the
> > return type to struct kho_mem_phys_bits * and use sizeof() instead of
> > PAGE_SIZE.
>
> I see that you replace kzalloc() with get_zeroed_page() in the next
> patch. So the latter option is probably better, and maybe move static
> assert down here and use BUILD_BUG_ON()? That way readers can easily
> see that we are allocating for struct kho_mem_phys_bits *and* that
> that struct is guaranteed to be PAGE_SIZE'd.

The size is verified at build time via:
+static_assert(sizeof(struct kho_mem_phys_bits) =3D=3D PAGE_SIZE);

