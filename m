Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 044DAC83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 17:50:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97A9B6B012E; Wed, 23 Jul 2025 13:50:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9520D6B0130; Wed, 23 Jul 2025 13:50:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8682D6B0131; Wed, 23 Jul 2025 13:50:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 76FCF6B012E
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:50:09 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2653DB6612
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 17:50:09 +0000 (UTC)
X-FDA: 83696268138.30.6D800BE
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2F48F1C000A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 17:50:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2+g4kEkX;
	spf=pass (imf20.hostedemail.com: domain of jannh@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753293007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N3CjZ22bo998Gf96yMZtr59wxIw8Kk30KdGo+Ax6K5M=;
	b=NyHpQzpT2Cotd/DIO6wDuaeA5Ra3fO0XO38OToTLt47BoKCY7yIJseT8luP9XRJGkyqcdL
	2aJk9H1sV1c0yIqE015GLJqokHz6bLa8rSQ7c6cL1fReCZufzOjaKn1JqxkWHyoWKtr8tm
	3NvJ7s/T/YN6pmQO4gl1UdHAsaa9ewM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2+g4kEkX;
	spf=pass (imf20.hostedemail.com: domain of jannh@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753293007; a=rsa-sha256;
	cv=none;
	b=ji9VcZG5k+zSsThUDBA2JVr1R/PP92nAHnvch0Pjc4MC2svMLCSSmw5e51PqaUn4WhGbPO
	GkMK97F8lqZ1lnG4JWLOhm6fHkJmzPGmeqBqKk/URmCmzfUiN0Efniaqn9LEmtIhFLvbKO
	fHhyPBW2WYK58hv3849aR9/acu+hwRY=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-609b169834cso1333a12.0
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753293005; x=1753897805; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N3CjZ22bo998Gf96yMZtr59wxIw8Kk30KdGo+Ax6K5M=;
        b=2+g4kEkXkesTPa4xZVMJDRsGLqxxrVZeKZi9P7k27aRF3CRbm7WyZZ94lPnsAJ8CYK
         hFTSPyYVyHG4ft8q8ti7Ewuzv+hYpV/vnhenO2W5uiqGel/nryYhtBnO7hXAVzzQsCAd
         x3IufUBsPlLmgnxDWc7Ak6K/ZJxOZnLb/FrrCvGNmDl38qzHehll8sW0Fh9VLvUEwTag
         rErSkCntRBBcmCkWSlmjq6zGudPB81Bl0Gho0JV+HR8nXhVsbiPKYeZy256bWzWXuLGB
         cQAeeBkka6g4ByIG/fOECJesDONkrnCK8nuTLCTegjvUgtaEy5pDfEFVsHVzlWu7Jm6E
         sHhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753293005; x=1753897805;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N3CjZ22bo998Gf96yMZtr59wxIw8Kk30KdGo+Ax6K5M=;
        b=SvgfmrLimxxf7QULH6b4eOkNfuZ9W7rYN6d3ETTU6U6TgCImjh5B8jFePOS2kwh/J6
         5GGB1d7ipZapFTl1fXgtOHK4VZbM347oQROYCf/A1mlCG4DjdupdK1ZoHOozb+Z7P4jY
         U5f6yOe7ODWyQ2gEXZXxwx5gdoV55Ao9muistsQYr3lTTWctGa6+07gYT52BazAzuOMn
         52ai5BdTT75n5RO/aDxDEo+bYUlhbgSdjCRwA8H4M7VEMXrORL1Lcnau2XS0N4Lt5WPG
         V65YXxuV0EqsHeHcVPM4zzDyUkme9QxK3a5lRPXv8ehnLrvt63XJ+apablhgNSM+Q3wC
         +4uA==
X-Forwarded-Encrypted: i=1; AJvYcCWmylEA2uF1fw4sWKiN0uwvnAxhXTfeQ6TfLq2ROB04PL6qOLNAH1Q+B7o/rpMjfLqVcCcSJWq1EQ==@kvack.org
X-Gm-Message-State: AOJu0YyN0pqEF8mCXnmLCnLcljEvDUDm9LSMy8tUfD+RL/fHtK+OD+cU
	rt2t0FDc2s99JIc4v1mVgc5f6TjxpCJ/Oshq3HtUED7vXEQ4ePfVPAKylpHGERhuVGvpYvCx6i3
	SuygsmtBT8Ct/b1XVeGt6mr7u8RQW9YQ/1hXAjUxa
X-Gm-Gg: ASbGncsP0XF3klFRXI5dnkivIprZW/EU0A8/EGIBdeW7b6i36mAHl/cHRIyTPzkOuaj
	f4Uv0el9VutOlbqcB5dpj/ao82aTaXjc+R6u6jT3j6TIYVGcjxTjT8AjbphOGAQoiKb1EoH0BBI
	MxM9YeRcfoll2ocxsSwSjZuGPi8O7gjlENLnYKq/j48mAMxP5DtfFKhRjJGmzuvju1je45BQ/4O
	wDCNfUHhGBh6lA4oJR8RIV3AT5DXfrjfnE=
X-Google-Smtp-Source: AGHT+IFZndI4SLY2jTFfc7anANksmXujHTfbPGok6SPCPQiLXDZT+bTXYZL7u6XX3OLnry7gojrC+xg7+iozT5iiYuw=
X-Received: by 2002:a50:ab0a:0:b0:609:99a7:efdb with SMTP id
 4fb4d7f45d1cf-614c4e2d68fmr959a12.2.1753293005107; Wed, 23 Jul 2025 10:50:05
 -0700 (PDT)
MIME-Version: 1.0
References: <CAG48ez0-deFbVH=E3jbkWx=X3uVbd8nWeo6kbJPQ0KoUD+m2tA@mail.gmail.com>
 <16c97e30-19c9-41e8-b73b-c0b3c8eceff3@suse.cz>
In-Reply-To: <16c97e30-19c9-41e8-b73b-c0b3c8eceff3@suse.cz>
From: Jann Horn <jannh@google.com>
Date: Wed, 23 Jul 2025 19:49:29 +0200
X-Gm-Features: Ac12FXzJzTto75PHjdORYKleZSwPq9-F8zjWYdNYD8vo7sV26qM4zAkWjh6UImY
Message-ID: <CAG48ez1qhjQNHC+3572udqVWHTANFpQ0ngxn_4ZDC9F8NCXsFA@mail.gmail.com>
Subject: Re: [BUG] hard-to-hit mm_struct UAF due to insufficiently careful
 vma_refcount_put() wrt SLAB_TYPESAFE_BY_RCU
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Linux-MM <linux-mm@kvack.org>, 
	kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 2F48F1C000A
X-Rspamd-Server: rspam06
X-Stat-Signature: 4tgtfyd3eg8jt67hup4r3gk71pnp1iuj
X-HE-Tag: 1753293006-106938
X-HE-Meta: U2FsdGVkX1+HISHy/6nRvaQB3ECfilmQv9NJ2W1+ScQvvwZjwwmWzTACSeiseWp5NKz/z4elfJy5D6Noml0RgBu9qfG1wMLqcn8e1QyvzmAcT2lZYDBxhOo2+27IgXzZC2kUH1b8nEifv42xm3mTiq0ASHMsDPW4huCW37dZymLOBNTNCLI1UwyfieWKIEXx7JbY/1NCQcgFEgNz2p2eY8EK7r1g9RDxjlWfheaZPU9s+4tGt/x6CI93N9hUqScd6XwRzqDfqm7UV2sBQnlrERbaVqJ3U2qc+L7wZD5sdyXOrYaeb3TUv/CUIdhFVB4MYtgmkGncuw1StmpZgzKQQtuj3NUvqot4XtMQnknOPGFG9P3CqxQEgjZlEBZiHn51RTJKFRLie3QGASjNfKRFCYu0nHYNdrpwr9MYNvHv65IuZkcrGcn+/pOKF/i3NXmrRQ4Hq4qcC8AOnkg+nx/rm15bPg9uzLKhs6y6hVmJvU20WQkFE7ky2g9MFI/sDHFkRfBwNocEdBUrv+2tNLR4QvwariPlbIwD73UN5tu7tbAewAYC/ffTaTcIaTvN3VsrMTZ6cmeOnn8z0n5LmdZl3W3cg6Tyr0X0OtZHopm8X+BH9p8UuL88GltJQFNUCGG0b0vxgVvQuRBT4t/Wab/06RG1YdC9mmR2cqiB1x5W4EjdQgFjTohtkjslbDvMydsi2i0VoqGbSo55t683ZMfr+wxq4huY8kIsPWxeDyCltcNnSFfYcCuier8wFEVu3kL1zzJD8xDnSM1izQXXFPCFMXqMj40jvoSUuzgTOGqFo0qG8WMPnFq1Z295PuXszenZ+gsL5hgqMFo8nBS67HPbNZf90UQo0stc71/vc49kSoIjuTea2vGNKGHFjuI3o0qas+vsH4eqtdTvJ5RmGbsxgqwdnmR1JNN4aGioQEfYqXbmbReyn1iR3OKApyajbX9uL2Yx2zriDtiPqywN1hM
 3/ZdCq76
 WvZKqv316sXjCk32o9jWPFH3YrdQU290idV/dEIQynU/yfMazc7Iv3WIwZSKpvLsjdYVeFW7oPn9IK+8BE14zoeaZ6S5qpQ/fJ5hGtDhcHx2i8kVLamzv6mMV5FMGnQbKSMT5Ya5sCgglXNwBKhqs8yq8UL9irNXVNo4BQC4okBe28UQaQmfPtcTuCNruM8iAMxseV3sFSYJmzGMlQJE0Bz+RCFoKc46S47/UHZpkknSl6y0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 7:32=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
> On 7/23/25 18:26, Jann Horn wrote:
> > There's a racy UAF in `vma_refcount_put()` when called on the
> > `lock_vma_under_rcu()` path because `SLAB_TYPESAFE_BY_RCU` is used
> > without sufficient protection against concurrent object reuse:
>
> Oof.
>
> > I'm not sure what the right fix is; I guess one approach would be to
> > have a special version of vma_refcount_put() for cases where the VMA
> > has been recycled by another MM that grabs an extra reference to the
> > MM? But then dropping a reference to the MM afterwards might be a bit
> > annoying and might require something like mmdrop_async()...
>
> Would we need mmdrop_async()? Isn't this the case for mmget_not_zero() an=
d
> mmput_async()?

Now I'm not sure anymore if either of those approaches would work,
because they rely on the task that's removing the VMA to wait until we
do __refcount_dec_and_test() before deleting the MM... but I don't
think we have any such guarantee...

