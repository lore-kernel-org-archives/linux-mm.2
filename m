Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03BE4F53D91
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 19:32:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 434CC6B036B; Mon, 16 Mar 2026 15:32:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E2C66B036C; Mon, 16 Mar 2026 15:32:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BA646B036D; Mon, 16 Mar 2026 15:32:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 194E86B036B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:32:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BB16713AC04
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:32:01 +0000 (UTC)
X-FDA: 84552921642.15.0E7194C
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	by imf27.hostedemail.com (Postfix) with ESMTP id B719C4000C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:31:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=H12uWSkm;
	spf=pass (imf27.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773689519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OgrkkO5YaURhF10Lfediw6OI82LGMdA/s+/oEFTz57E=;
	b=sqSemZ9insIlO45bIQ85kXQbQq+zVAH1YzEAmkh9hvCHt6v8HQiKJ7L7vHckMUV2ezsB7z
	SEzhJL2Kai9nLP0yCMHYwyGKsO3eT6c6Y7ahZPjFGa3/yt0g3QToyeszrD8rG7ltDDIPUQ
	fIG+vcRXOS6YxYIdSCy0AAETsmqtrTs=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=H12uWSkm;
	spf=pass (imf27.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773689519; a=rsa-sha256;
	cv=pass;
	b=ixY1gYbvntxy/GvQMa6muJ8VSM0BuEJyyr2I5ciBbzRlq6sjCJ8dqq5/tj7x1Y5mqFnHi7
	yDRMiAqQ+eKzCIGC65KGk4XLhg2k3yQM1n6s6+WspyR4FZqFZn0qRhDU94d2vwIX2bnHV8
	Xvz5G9hnNsNie+yKY1vYgXY6c8zr/ns=
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-2bdcf5970cdso52715eec.0
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:31:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773689518; cv=none;
        d=google.com; s=arc-20240605;
        b=Y8SJwcvxF4enoBQZrT6/ipj6bePvBvXGqsZUDpGS5rAvB2sje7QIdm7CmiwJTkboi8
         YP6S0gcb33FdDAvpfaVKX+xpMITYZXhwN7/VoDXbMnbKjYpP85wgYrcJ4eCIJfLQG+Hv
         ZjEQEeFTfnPBmUsMfwrFDg7vLBUvTbBLfWCndI3/kRb8vSciOxzfwOa0op+pwNvWmMxd
         gZ2NgKqfLzJFmaMze5tIFdhZO2yZsotz0EEBeebVYqXMxpyFzO92CF4v1ISIVrHy/fn7
         K63QjtWPNG5x7lW43h8U2iFVjudz+x7ZISutFgC74EdJ122JmPqV+rkhZ67wIpaZmDb1
         MVmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OgrkkO5YaURhF10Lfediw6OI82LGMdA/s+/oEFTz57E=;
        fh=ZU2qOUm1yeKjs6CsMpH+6IVS2edlUOISe8T/4vS4k0E=;
        b=XKkcSXh8wr5nVmqTX/S/+gVygqLeNln3i+2EIq0gqOdSQaIxVU3o9BKNWId7eKNzPA
         CZFsg/4lMvfIFIiaQVvkRsaWTdln0Q1E90gPQoDNXaK1UniAyasXlaiyYD1XPMvr7NGv
         mSfmVuVTNhrIWnikrojCQQyqjodJjoy2TrKa+Vf2GXSFz5Hv1jecbVLlgucRccGHnthP
         WHYnDlRIHNVociTuj/g4ahLPyor+jO4BU9smOnIJI1MYRxjF5RAFUQCRrvTcEzQkEzdt
         o5MLIWzUiCLfj0WzgEKqPmBVoG3oZ3vbeKdNJ32v9FvpLoj24Ksb0GioXAJNVGqDDbKN
         o67w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773689518; x=1774294318; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OgrkkO5YaURhF10Lfediw6OI82LGMdA/s+/oEFTz57E=;
        b=H12uWSkmDrgEwrnzR+8Ncq0YNS+wKvXxx76oly4/G7f1warKY9lq0OXkMYQTDiiA7t
         +SuzNPkzCnIHefmiAjS6+sUKN7RT0qJOSV8DUTTMffVyFORBdrcsrQ7nYqs6WX1Gdnhy
         PfqZcGjLagfgpGuUhlJPQIoynXT63cYAovNbqhzQnEYueuNMpFbRden/iyBjy0YlQQHA
         aGujsEdzafRXO29b6Zp91TegFC/Buq6Fd7gh2LAxDpXXx2PSF4MW0MgYGMoM8eTlbN6B
         SrGbiprMesMzb0wQlJUQcVWkUddAsYdicrjU/9xO8aHWdh7sz/oNiRXr6AeSw/ggCT2w
         mvWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773689518; x=1774294318;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OgrkkO5YaURhF10Lfediw6OI82LGMdA/s+/oEFTz57E=;
        b=BGvYG1DWXVCoh7iSDGiecn59ulQbhWtDX7MfLcFn9z8xfYbHdqSU3IlXhyECs+DqWd
         gxmngEIgQDh17OmuDoRx7KUiNuPK5bvJfqqXkX1jlgsjbRPpKa/so9WEQ3Wy0mR0z7iW
         KFxibL4N3kEac9AUDlfzsy8q2+NZnpVSOHE/AodcCSGICu0I8YPPxSkyRfPAw/nedftC
         RY/sCDTaq4dAFAQMYzz6zkmqjthhuRBZ6MMjsP+Y0EbYPcPSN66pgF8N3GnTUs0CHRSW
         AfBFE7WxFCvbOCfLziGlhn1A9HPhZaFOAWHUejY1EPIffYCaua6nQVY7co7erHkWt1DB
         PZAg==
X-Forwarded-Encrypted: i=1; AJvYcCUOZsIhoTEeHdxNlysgGILlUbhQUZvcl0USRZTlMBwexfXeQ51hqSngwwO5q7CjnjnuyCUpEbOgeg==@kvack.org
X-Gm-Message-State: AOJu0YxH2PFzQ3OcICrnJFoycdBwKh2FJ7EB/YZMSQz3XvUuDdaN7CCi
	e31kJ/U/10XuccPJWhnJPsqyxmC8T927mjZ2jldFhLVEeDBgDsPAJ5QTrw5UzdQ1RSyExEHTAeD
	Dg8P0gxUc/FKJWP57mKd21hdZmbMKXltvFGyOeL8=
X-Gm-Gg: ATEYQzwtvvkbAVIV0/HBBJbMM2yOd8fMz7bCvArLEDwPTnMD5Tg5vrZ4iqAW7l8hhgR
	9NHa68NQreYobUMBOEdaSZ+R1Cwm6uoC1KH1CqFc0AROZsWsa1zsUrVog8auPc5BZgImtp2Z+2T
	eWTkd7gEeQs3sQWQqjh0TSx4DHK/XUNCulpZhOJK/SMSCB0AKDn9KcAj5WlyTtJ4VnTkMGm6NHI
	9YnWA8YPQ5q7tbDm25+L2GqeqV1wD1AqIpYxPKaOHOa2t4tGFBHlsfKYH2bJbNh3Pgm6trhj9Sq
	FemF42g+BXVvUEDaqPis29nZ
X-Received: by 2002:a05:7301:1689:b0:2be:acac:af7f with SMTP id
 5a478bee46e88-2c0d50e51a5mr383826eec.7.1773689518500; Mon, 16 Mar 2026
 12:31:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260314051632.17931-1-kanchanapsridhar2026@gmail.com>
 <20260314171150.fd6a80a8f51a5390144d20d6@linux-foundation.org>
 <CACpmpodjsMELCrJ-QX066CYiGgraysr_ZhFMvU5N-6nr2HsRsw@mail.gmail.com>
 <abgbx0YXbxu2mAHU@google.com> <CACpmpoeo0LhxkoA5Wx6q+9=2scn_az0u=3bar-JgBvTA-ZBkZg@mail.gmail.com>
 <CAO9r8zPR+Sbo9erKEn_qFG4GXBbSd4EJCmtBYRfV8Qvuh5262Q@mail.gmail.com>
 <CACpmpodvy8wrSNQcSPn_koA=O+MM30U=T4p6Yr6Dkr8R8WsnQw@mail.gmail.com> <CAO9r8zNGKR4R+Y2gZrevtyan5G-9Dc96aYTUHrgv8b=3V_RKMA@mail.gmail.com>
In-Reply-To: <CAO9r8zNGKR4R+Y2gZrevtyan5G-9Dc96aYTUHrgv8b=3V_RKMA@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Mon, 16 Mar 2026 12:31:46 -0700
X-Gm-Features: AaiRm50uHztc3hCRDyQop5B6Uy8frGI_0E3Rv6hXqHswNBPf-6R2AC5AIzYdFn0
Message-ID: <CACpmpodX-EqcS6e83W82YtSnRmFhbF6Evgaot3deqAVGFeV24w@mail.gmail.com>
Subject: Re: [PATCH 0/2] zswap pool per-CPU acomp_ctx simplifications
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ojmpo9g9msrja3wi4cjpdbxe9duwabkq
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: B719C4000C
X-HE-Tag: 1773689519-237171
X-HE-Meta: U2FsdGVkX185QZcqMaqrpWltI7bMRApDpq9Lh5uQoXGjZyTDLB5YfY8ed0ax26xcm3ZkHBJ53eM/4MdWeHnDx/qAXH3v7BM5Rldilr1a2rE3MVravrYMJAn2XH/2ay0U8Rr48/vXca3U0bIAxc1X6NKxYWLZlGWK2LIODBT3KIImjh/bvMXjprr21/ECjg1i94jheDWmbvVRL+Zd0csDwAdnX4F2mnHpu/EtNeTqzCZuad+7awPg8Ba4dUQiIjvE7Ia3GzkUm2RIj27qA0bL+CMX/mD4hFUa/vT+FBfQ5Mcy9lq3BgEObo9fCNjCQE7CI8nf8Zfr8FU5c/mzaYK3wKRPgquPIuBVB9m9ZO29QA5O+gWC2nbxYR3o9RaOumpDw3Rc7wCKD1lSs+O1IIcobGlTXHHr4vV1S4YYbFiEsNWWIcqICN3+N13BuRz1e/aSOmNTnMdFifzigx2yzzDYb5ZtMsMvPJ35Ch1mhUS06EzVhePrLPuwYiqcs3yzqfeixgujTv0GIEYnr8P7n1JWPRA1/AD//yHWZPoCbCEDVqf2KP4iRm6hhAXr4mzu5L3yoNo4GAl177vj3Lvz3NAAuRGrRBm9kAe/dedT8A/4eVT0XSmK8jKS2YsM9i5t1PyxG5QmBVLvaHOTXv7c2PGzdTLQ0E4oXOoLNWLQAYWBc4oXnxNw6TWaAwKUEjMMjhOAtd/sYtoZTsmNzEntKRk+ELmXTMccw+2FMnnrGZ4yv/ya0ff6YDcJGO/MPdsfwnWWPx4/ikuVDRD42c0rLxxRtXWEC93vyK/+3V/G39u9nVW6RGQAPMtPmPnDf2Aqi76K2mwR17NtYPleRygWpxz6gBbMLo8Dd1C8vZuuBasn7gyAufJfT8x7cSW46DZN6rEnVZoBkEJjvbZNsXRpnB0fBI6Za6dLb/3+/FRfOVzXV6kA+3blx7pcxB2MGc7LRJyQfzYoGgFacMS21tYKk5z
 MnYXmvuu
 KBM7LZ0C+flvx846xfXRKs5qFLSrlMaOEJk5WklmJkZKDCkaQhpffMzqvUg2CMdtjL47WCP6dgi6Vi64i3oPZijG9UwAqkYmR/opnS+3nnV+U7CE1D8uIQQ+wviBGrHlFRCpGGnXWM6lRJ4msxEw+rdMSMoijGaHIMV+znjAKBzkk8tBtGSATi4CzYipNeCvI+KkDzq54my8HoApwtlZAI8A811+a+P4gR3QLqUtm9mj4nuyv3zP5aaWc9OI8rk9hn1TQPZ0JFmRpRzfv8EL950pCPrO4iUog229ZjRw4tv60uXSb4keJI4f2dgOhrM2pEClXVxbLbI3+EVmD6PTDcbabV39YGgZ6NqmEvCssSAGQiarrUyQGn6FAHWHtmtcXCkRQdmo2iLr6XlzxmVVWf/U4WLgD6CI0lIDhR5KLbOs2pQdQMedSKZ5CEhvcyD+0+jizD931I+MpBKlKaUv1NxqepUMcEUS4gsx/fkTJ3H9+TtrEHuwiHOpkJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 12:24=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wro=
te:
>
> On Mon, Mar 16, 2026 at 12:21=E2=80=AFPM Kanchana P. Sridhar
> <kanchanapsridhar2026@gmail.com> wrote:
> >
> > On Mon, Mar 16, 2026 at 11:30=E2=80=AFAM Yosry Ahmed <yosry@kernel.org>=
 wrote:
> > >
> > > > > > If the maintainers think future-proofing is beneficial, I would=
 need
> > > > > > to handle the PTR_ERR(NULL) which would send a false success st=
atus.
> > > > > > If we don't think we need to handle a future NULL return from
> > > > > > crypto_alloc_acomp_node(), then I don't think this change is ne=
eded.
> > > > > > We could leave it as IS_ERR(acomp_ctx->acomp). I would like to =
get the
> > > > > > maintainers' inputs on how to proceed.
> > > > > >
> > > > > > > > acomp_ctx->req =3D acomp_request_alloc(acomp_ctx->acomp);
> > > > > > > > - if (!acomp_ctx->req) {
> > > > > > > > + if (IS_ERR_OR_NULL(acomp_ctx->req)) {
> > > > > > > Is this change necessary for acomp_request_alloc()?
> > > > > > > This function strictly returns NULL on allocation failure, no=
t an error
> > > > > > > pointer. Changing this to IS_ERR_OR_NULL() obscures the actua=
l API contract
> > > > > > > without providing a functional benefit.
> > > > > >
> > > > > > As of now, acomp_request_alloc() returns a valid "req" or NULL =
in case
> > > > > > of an error. Same question as above. The only benefit would be =
making
> > > > > > the code more robust to handle changes in the acomp API in futu=
re.
> > > > >
> > > > > For this one, do we need to do IS_ERR_OR_NULL() in acomp_ctx_deal=
loc()
> > > > > to begin with? If acomp_request_alloc() only returns NULL, maybe =
that
> > > > > should also be a NULL check?
> > > >
> > > > This one is debatable, since acomp_ctx_dealloc() is intended to
> > > > replace zswap_cpu_comp_dead(), which has the IS_ERR_OR_NULL(). I th=
ink
> > > > replacing this with IS_NULL(req) makes sense, but would like to
> > > > confirm with you if changing existing behavior is Ok.
> > >
> > > I think it's fine as long as acomp_request_alloc() never returns an
> > > error. Maybe do it in a separate patch first, change IS_ERR_OR_NULL()
> > > to a NULL check in zswap_cpu_comp_dead(), with the reasoning explaine=
d
> > > in the changelog, to avoid hiding that change within the bigger patch=
.
> >
> > Sounds good.
> >
> > >
> > > Actually looking at zswap_cpu_comp_dead(), is the IS_ERR_OR_NULL()
> > > check on acomp_ctx also misleading? Should that also just be a NULL
> > > check?
> >
> > Even a NULL check would be redundant in this case, per my
> > understanding, because if the alloc_percpu() call in
> > zswap_pool_create() had failed, pool creation would have failed.
> >
> > I think a NULL check on the acomp_ctx would still be a good idea, just
> > in case, since this is all part of CPU hotplug. I agree, we don't need
> > an IS_ERR() check on acomp_ctx.
>
> So I think we do one patch to convert both IS_ERR_OR_NULL() to NULL
> checks, and then the current patch 1, right?

Yes.

