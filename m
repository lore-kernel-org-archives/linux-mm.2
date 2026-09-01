Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9CE9C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 05:14:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D20746B008A; Tue,  1 Sep 2026 01:14:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD0E36B009E; Tue,  1 Sep 2026 01:14:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B98AB6B00A1; Tue,  1 Sep 2026 01:14:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9DDB86B008A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:14:02 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D827C120311
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:14:01 +0000 (UTC)
X-FDA: 85164026682.05.70727B6
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id DD2AA14000B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:13:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="szXhF0m/";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788239639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UUD1uKVBIV0lE2LKCNu8RAcV892bBW+atBki9y53O4I=;
	b=lh33/CTgaC9TkTyWifwfwCznEmhMb1SqeuYZDlRBasAdM3NWKZhK9dCYw/Mr8NrKs7HM9L
	+3iSN8v9+u5K72XJHNYzIAoOj0gkPXMXTD6RscTCRqQBw2KONu96K+W+SBoW5WgP68emXc
	daMRgfRuFxWh+xwJZo0KJnXt0JXEYq8=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="szXhF0m/";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788239639;
	b=LcxdMifxr4L+WopjOkDXnajlDTCg+F8/kcn9o3VvOT+6pxBgYqjYdS0clPYb5cnh1jqGPu
	qGv2I7sSvGCF2ywtH8D2YfiyOcrgRkOk2MS7ok2OhR0wEpTJBnaYoWi2WRjkHalY+OcG4l
	nmL9m/QfhhV0NBovq5nVcFNXCtpKg/w=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-52faa58bff5so170281cf.0
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 22:13:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788239639; cv=none;
        d=google.com; s=arc-20260327;
        b=qWPOjLGnF895doUcGfB0DfH7k68h31uaOZcxxSTcrmzEB4ITpbeptEhVDKgC/d+DTm
         BW/9TPIL4Gf4+vOGDzWHPnJ9U9Ww+JvbMBB8J1TDF3SI/Wse360eZzf4V5hA8EVxmu9G
         0oqDiww1j5AqOUfSeGZUwtohIpsXGxh0P9vjjnyssPfseCTgX0DinCtADgvj2k92sPME
         w6liSb4fSTGavTVdd2XBqSc8EMgjZmqzSkj74NwsTP/FzJit5IA+KFGgXvQd2AFaJwZV
         3bAn/RSEdWIq2PxPAVY44v80YRLwf9UhyoI//M9gDy3fJv7J1xW5l/U1+AFvKyBBow3H
         0lKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UUD1uKVBIV0lE2LKCNu8RAcV892bBW+atBki9y53O4I=;
        fh=zXkz/uRD68/IaKMkcPYf32eTv4YWN7dkgqid77PDuMo=;
        b=ksCuodtconQ5U20S5CgUKJlnX6MgkwFBeWmGhSCra7QyFbXollentJar3RKp0RkSVA
         fKfhLHC50aZHePua/8/nJhtvca6WwmESlPWoNy9YGqh7u4tpZEVT1UF9VTzp4qFjIRy/
         O9JFp6ie7/cxIDmIDILFbZbHGsjAhoevZzxsj7I90qqocxFjPdofWcx6q22RF0wjQt50
         Q69IVHj8vppbopa0pMx5Rxri7jN1uRNOaJr8MbOMHXOeT/FpHd9x/7Qh/nhYqG4AOLhU
         kFsL90JWq6p3QUVORHSW17tZE4LBWKWSt6JLmYcEBZz20ZLbjIUF9bE+zML+f1lCRzLV
         OMhw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788239639; x=1788844439; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UUD1uKVBIV0lE2LKCNu8RAcV892bBW+atBki9y53O4I=;
        b=szXhF0m/v6F8MDAFzM1U83N4HwnGUsaMRHsrRgyqb4idLhZBXsYczUjORCn0S0f1ax
         PuStoueWN0AelgGKfFHm37aj0/KwKRP9cGOKpEMo7kVWKVbdY8obz0jLUxFNsXA2NWAP
         wnrMevO/90WD0WrtTobo8SxK3UpREMPzuikkal50gk/C2Js14K/EYf+OsMnuFSdsn7Yx
         4eax3X8Ph/PI2rocUbVQEG4vaz633Ba6XgVhQnOx9uU6rmoa3OrQbSiWovKs+xY2gF7F
         iPKF6FXcn/XSrZHNL6AAMeLpuE766fqIVvGrZ+3wGpfrlim85PxgoYgs53PVhQDd9NU+
         dZOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788239639; x=1788844439;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UUD1uKVBIV0lE2LKCNu8RAcV892bBW+atBki9y53O4I=;
        b=AKxIFbMtWlTm1MZ3wYrfwzAeNAv9GNGOZ3BrYxi1j6NhOajxd8rcVv5Hr4eI3vmhNH
         ivRmalRrEr3tZ660QvAG4u6HtlB/BJb2sjkNBFrXHGOhKHmtWKPxENYSvPrFwDRvwv+S
         BatLRTcC3pxEQ4NjIkUWN0DPwLtuDnNK/1zqPHjJlA/Zl3pHDX6/JyhNHrUEZyvOtDPa
         29/W5p9xmVzJvc8WUE7o0M2dlFa5xZuaR5WXaeW/Tc7FypRL4lmvdx6UHRPMR9KqleUe
         tqlHwlxeYsJeEWaz7kvL2ugRGLmrXxogva78KWqS0XGZvc9ANN7frkLcuxZoPKlqr9vK
         +G5g==
X-Forwarded-Encrypted: i=1; AHgh+Rrg0nmGcp9TKOei3QepMtFeO4GhC6NygRQdFc737B/NciGv4MoYqUapyGLdl3abiozYxqdXb39Yxw==@kvack.org
X-Gm-Message-State: AFuF++kGBjEzbngZzO55XZT7kcgc9rfPeKd4Vtr5Sl7kOJ/pVvlJgba8
	RywLTvptYiVxXy+3YyIUv4LA7FlaMI8N6UCaXBe5cOQu3jJY5Vp20YEi6yXKNsmVjssaUdLRElG
	5ahgnDmQUFqyyMxB5x2UU/M3k+Y1zYdgoJSGvR2Vi
X-Gm-Gg: AR+sD10y1lof+8b5LLvSb3HQl56eZCACDkauqzajs0LqcNSG4OQ3Cy9nJKslsHSRaSR
	B+7RZV9MyQlsk2cjrWxAEtrAVzXNH1qcosNb0ey1d376bwekdysQl1VgTcV/d8rdaHodS9khcE7
	CfqTG84wZz9hgYuHFCEBiSTTE617cs1ObkcCkDEDhqpG5ghQCkxIxtXj3mYm/CHfSR9n6n6rXqa
	t9Xe5CUHOmSPgyOzpAwgMfJ2p41yudL1tbpidNxWlFDChjXJX70dd5S50V5XwVS7Ke/ddewtFAD
	dvMHAaKQv+Q9FldFLMxX0+/yLFqKGtEZ73D2HBUg+hU=
X-Received: by 2002:a05:622a:428b:b0:52f:8389:29e0 with SMTP id
 d75a77b69052e-53024be8e1cmr8537361cf.0.1788239638146; Mon, 31 Aug 2026
 22:13:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260813193433.3318288-1-surenb@google.com> <20260829185625.f5ee1b2931818843a78af88d@linux-foundation.org>
 <apVhzM2501wSiGGg@google.com> <apX_r59k4e-XiI-C@google.com>
 <CAJuCfpEDgdC=N8__Ye1xP8rZtUwWrGhKhJ9Qnn0hdV+u5r+hJA@mail.gmail.com> <apYOTPIBTsuQKUXE@google.com>
In-Reply-To: <apYOTPIBTsuQKUXE@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 31 Aug 2026 22:13:45 -0700
X-Gm-Features: AcwNN1VAaOHg69O9ZoXyWul1qNpWHuewW8j4AbDLbUQZo9pKosyw0CLlNI76Si4
Message-ID: <CAJuCfpHFsjmGwfmhmOaGdnwJkyzMNdUqRne4W0GN0DDkpMkExg@mail.gmail.com>
Subject: Re: [PATCH v6 0/5] mm: Unconditional per-VMA locks and cleanups
To: Carlos Llamas <cmllamas@google.com>
Cc: Alice Ryhl <aliceryhl@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, ljs@kernel.org, 
	david@redhat.com, willy@infradead.org, shakeel.butt@linux.dev, 
	vbabka@kernel.org, jannh@google.com, arve@android.com, christian@brauner.io, 
	tkjos@android.com, dsahern@kernel.org, davem@davemloft.net, 
	gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 5dxq77fq5snetqs53n57kf59dsj1g76u
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DD2AA14000B
X-Rspam-User: 
X-HE-Tag: 1788239639-386668
X-HE-Meta: U2FsdGVkX1/n21Q0ZSTXBMM00WvnEcEi4TdBR4bixXelXeQfnLBenW+deysrx0BZnS/pl0Ecdza3Tfp2cJFlBKJ5Qkp3AK5jkns0X5JuIY8PnAIwq6vjXGNI41F1CT8WLwP5Tlso9TXzHZ78myy8c3mEldLeoxitTrGKJ8fR73xDXRd3VbGaL/NDChpYPGzErWnvzetsWB3Q9j1EtqmSJdrs1IkSE71OUT1+KOPfTFGKPu8rr71VyNjzjLS/3ttc8/NxyfsEKIDjm55SGCF7ZCXI2hwbfxl4N0qMYcRGLJYLZS/B6vi9vYC2Wfd7yX+y6hFDvjCmkMzVVo5kpYE/acrma3tloAx7xL89lN+5XKYHUcyxK5VHrHYgOVvc/cbQhEJEwJZaOTUSQNNcqC9bb3qYy8Dpl8lPQ8yn5Urccp5o1FN75dvvrQZr+90TbpL4umLVAJDkElFDVK1jG4r5wqhuVgVBmiWR3lEkNbFysPuigreyHSC18AMVWYOJQkij+ySRcPgZdx25fiRUQeh3gYva3SCvGeenwVIP+F41BjlaqCDvWr4u3ZA+buveShXjQ/iipfezFxejN/GjwkEU/ZeUxyEYDoVq2OmmhiIZnogdsIlhTpij5FpKpgq+tmQ8yPHCIHFhOSOozOAQEnggg1YawiIaMB9unijlPC/AjoHURg7XAsY4n8GZ5PFAkpbV0QDjVB7GPbV6qrEPWBaDucCdQ61N5PRX61xDcdeVxvNCmRRFBoNIZKgkgu+SYeBeFai7sHLBf7itSKW1Q2alTbqHfBPXfxxnNyhSX0L99Amc6RWSJ7ELiKyKb1LmKjNguZr+hNf5opaIPhphWMMYtYsQyDZudRYU9l9OJCiyZV9Z1k7DuSRzvipu7TEzgLK9SY60RZgO7XZurMRSP0SzWvN/JH90oO/WcTuWSVR3SckfWIAomNPmJjXSEx7HHBRpOwwxyOWYTECg9gi10gu
 slaGsz5e
 Lb4G9+cbCpos1kOdxY07zCkwpcUN/LVKY5teqoRhrKogjzOmYMb/ZUpQTwYFjTJJdMg7AsmmrZMg1becZZmw2BsXFNnZUZd2F3ypw/c1V5skVznJAYt3XjzzggytWMDfJxeJl5ZoV4aKEllCIFXEINEmVkyER7eRkZ05OZ6Zosh9012HH1VKU2QwkqR5cJWfhJkMc/vdeFCFDLLnhl62cJJqG36UCydV2LAzmCl/jc6bv4w72Lu+4DH6MwLBFgr61Bhfg+xtrm2ob+mKqxRgJx2dFhlqve7nRZa7NTb1CvFGGqKZ9ZyLpwMCYrtnxy7fW2Xu5n4NrWGMLH+ylDFHasHSS8hvfSmjcHghHBPdIZDkIqY/aliZs0XeXhQBgeo1ROL+ZszPNrpGodjE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 4:29=E2=80=AFPM Carlos Llamas <cmllamas@google.com>=
 wrote:
>
> On Mon, Aug 31, 2026 at 04:19:39PM -0700, Suren Baghdasaryan wrote:
> > On Mon, Aug 31, 2026 at 3:27=E2=80=AFPM Carlos Llamas <cmllamas@google.=
com> wrote:
> > >
> > > On Mon, Aug 31, 2026 at 11:13:16AM +0000, Alice Ryhl wrote:
> > > > On Sat, Aug 29, 2026 at 06:56:25PM -0700, Andrew Morton wrote:
> > > > > On Thu, 13 Aug 2026 12:34:28 -0700 Suren Baghdasaryan <surenb@goo=
gle.com> wrote:
> > > > >
> > > > > > v2 version of this patchset [1] was written by Dave Hansen and =
per his
> > > > > > request, I'm taking over this series.
> > > > > >
> > > > > > tl;dr: Make per-VMA locks available in all configs. Simplify so=
me
> > > > > > of the per-VMA lock users now that they can rely on them being
> > > > > > always available.
> > > > >
> > > > > It's been 2+ weeks so perhaps a refresh-and-remind would be helpf=
ul.
> > > > >
> > > > > But it applies well enough and is adequately reviewed so I put it=
 in
> > > > > there for testing, thanks.
> > > > >
> > > > > AI review might have found a couple of pre-existing binder bugs:
> > > > >
> > > > >     https://sashiko.dev/#/patchset/20260813193433.3318288-1-suren=
b@google.com
> > > > >
> > > > > and a small rusty thing which you might wish to attend to.
> > > >
> > > > The binder bug is not actually a bug. When using VM_MIXEDMAP and
> > > > vm_insert_page(), the vma takes a refcount on the page, so there is=
 no
> > > > use-after-free even if free_page() is invoked without removing it f=
rom
> > > > the vma.
> > >
> > > Exactly! I agree the refcount on the page would prevent the UAF.
> > >
> > > However, we should still reject mremap() because this leaves the page=
 in
> > > limbo since it is not given back to the shrinker and also binder can'=
t
> > > make use of it anymore. I'll send out a patch to fix this.
> >
> > Ok. Should that block this series or it will apply over it?
>
> The issue is pre-exiting and unrelated to this series. So I'll take care
> of this separately. Thanks!

Perfect. Thanks!

>

