Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C090F53D8C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 19:21:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C03B26B0304; Mon, 16 Mar 2026 15:21:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB0C06B0309; Mon, 16 Mar 2026 15:21:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB3686B0315; Mon, 16 Mar 2026 15:21:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 95DE46B0304
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:21:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5417213AB5F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:21:55 +0000 (UTC)
X-FDA: 84552896190.27.7F03F3A
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	by imf17.hostedemail.com (Postfix) with ESMTP id 54E2540010
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:21:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M0yz6WOH;
	spf=pass (imf17.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773688913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O/swCiLUQxkB77YOGD2XxDGx+9lgFBn1Ha1FZsF1F/w=;
	b=dAdYNm4xjou4dAMVfynDaoowA5nA3m3uzgO7P/TLoVuIXp+kNrQpo5j2P11jEcznliB+iy
	2TpQj78Sw9EUtwqY+tQpPwFVopime7/fxrDQNClc2zqlzPe7wH+QYSMJshDn0mJOUN6VVi
	+P6iRlSUNDxcN07/JH8rTWUtIhg5vTg=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M0yz6WOH;
	spf=pass (imf17.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773688913; a=rsa-sha256;
	cv=pass;
	b=u0JubzJWJl/QwsAHJW6AIHdqdAGwnDGzCIxGSNOV8rReXI2NRadix6LTh+UhckOiLZ9Fds
	5lRsxPeZomHMn6k9aSJz/zjTISkP3s1svWDaHx5LachgvR5EIjRHGspxr3YW4f6Ebb0nHU
	S0g3jcvvU5xz35xHMPPdh1TfZNxYBys=
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-2bd9a485bd6so3465093eec.1
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:21:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773688912; cv=none;
        d=google.com; s=arc-20240605;
        b=hT0yCdjDHRk5Ma2GicaiMgYT9KnJwZ/YPb5bAF2ak2DMr5OAlfdvEJuKcaY4FmLcpX
         8UL7yuA+f2dHIias/yrF7MbiAYNf1ERN0p05L616B4mFnXDdD2DhLodKhtwOflU6qq9y
         HTfu3yYfmyEy7iyMrlXoQOxWxkVtALJDC9woPC7xicbqtwaNt69rm0K1VprgP09h0aeb
         Tq6+rUd5vuh7bJ7Wy4R+IFoVtRV4nTsRLrc4w2QGhMxHdRxi/iRjjMZjS5ArCvaCc6Gz
         RZzYr5pT4Mba7bt9k4EUgKxfjjKhg1mwkIeJiOEgmHr6xGC6CbdPWZ57Bd2F8SiH52zO
         CRzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=O/swCiLUQxkB77YOGD2XxDGx+9lgFBn1Ha1FZsF1F/w=;
        fh=5zKTdh9kPlb6I24S/48ya/CjSekbCm15s6YQRvdRLPY=;
        b=ks2WZhLItKaGHX+LmoqtZoCqrwsOSy+KMRyZaZwacB56Lhq33X+uZ1Ds5yGXU4aH9p
         N1Kc2Jiw1z0BpFNXoMACjTH82RSVDS2Of1UUYbfD6iMpkckz+Am9Ffbopee0jbT+hLjt
         U6wiAQo14yoDhNaJMQ/kBgYds12Dy/3wBRYXIlPYqzqraPuhyXPDF0X+Fh+IxgjKSoeO
         +HMMY297yBisbSqQMX4r1d41xyhizWlff5HcKUyD8iC6sqm1Q9qHRf1FEKEDkpvICqD2
         FKT4aCma6KSz9ikzBG4EFcU60BnTYa0o2jmBXnSJmYqTz7YPFOK3qnn66aMn5dpClzxa
         Qpag==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773688912; x=1774293712; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O/swCiLUQxkB77YOGD2XxDGx+9lgFBn1Ha1FZsF1F/w=;
        b=M0yz6WOHvHck21A0tN+1yZughiu0sZF4j9opmkmHGTQtU63QqKg2GKBJYeXyRjozo6
         guWpuXWC7lsxBTfYCtIaWZWHcwhMpy6MH78KYxjPOBBt0iOhqqwh1NIK1GuLidP9SKD+
         wWGnw+gHpbiXZ/N13b0COPPOBGf+fd7dsSUtzIYFiTdYRlGeKkC8r/x4MKbkPYE9uEZB
         sLeNLqPymBxXKQga+8xjpN0paaWnBxnfvCKG0Q+s3ROQm5++EAsUZJq8Y0JggY8/+Tpr
         Tcy/VAzBpVpQxiCvKotILrTdhZYkDTeYuE0VpeKYVVaUB67ARlWRrCktT3qzVzi+pZHy
         N9KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773688912; x=1774293712;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=O/swCiLUQxkB77YOGD2XxDGx+9lgFBn1Ha1FZsF1F/w=;
        b=bj/4DhibW6ptASgRmckwzwDLUnbckZR5MelTIAZZqiIJI59yPqd5AstgkOtDjaSbi8
         aiA5Kmiir5xPhuQQPHxSmcKNUzlujfXOvomQJ/xC1Dm8WB1+kYwIgTGkYUcPUkgviVpH
         DfaFdvcCrtj7o/xFfSnnU5EH6sRyE1XlqADKFn8S2/znkeKwnvVjuWQ7FPKsAVPfRzoN
         M/KWwS/5UPPNR80rqPx5nYOgRBJLAvaBttOpnXV/SXvjXbCDiOd/nuOoEPqne7WEVF20
         FjhCI/jfn3741kp4tjL9WmKzTdfQzV56K5ytgGt8EhfRYT6rXGfueFc3QUI7jGNt+4Gt
         J3sA==
X-Forwarded-Encrypted: i=1; AJvYcCUNARbLCqusc0FCTmjI2NpGWXKhvTSse7WjuTDjOrH4IGuWvgd7jtSTejaC5HCpo2w03Tyb7R3JGg==@kvack.org
X-Gm-Message-State: AOJu0YydSLivfan0RK7CkTf9LqFhsV+Or97GlTRzjcI03654Z2YCzoAM
	zLFqwB0Wx4NEhoqcENtX/u1Ore8PtmiJy3YnvAJrhIeQehJ/hob+MldRaTzfpBbPW6zeIlGj5Oe
	/ZWX9ZHOAsiwkgnZekjyBAwFNoKOt8mg=
X-Gm-Gg: ATEYQzx9B1w/KQ+fVHwkPWE+VVqmrPLzEdRlMWHl9PzHxTAqb3cP9u6eTNDPTDOKe3+
	0xzcblDi0wO2zVjtpBLqnmR7D//AVNHDdNHZF4qs0Hc7V9W5GmZ8B+OPEOPmF2xcbqDguISGtkw
	XfXruLSx6N/y5ykTaY9FC5Z+8DcrLr29t2P2V5nHV3MGKZBFTPDukv+RD0vOd3wSSpCK5t+pzor
	WCoxSDxypIPoAzPyTmJcUJFIJZGRQIAubOiLzktpd+4wgieNbwshVBeJMgNqv6K4sflAFl/7YOh
	K+1kDlYVmv2JhMvgdKcW0KmqRG4fJO4wlkiXzk8=
X-Received: by 2002:a05:7300:6d05:b0:2be:171c:5047 with SMTP id
 5a478bee46e88-2bea54a4dccmr6616487eec.14.1773688911832; Mon, 16 Mar 2026
 12:21:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260314051632.17931-1-kanchanapsridhar2026@gmail.com>
 <20260314171150.fd6a80a8f51a5390144d20d6@linux-foundation.org>
 <CACpmpodjsMELCrJ-QX066CYiGgraysr_ZhFMvU5N-6nr2HsRsw@mail.gmail.com>
 <abgbx0YXbxu2mAHU@google.com> <CACpmpoeo0LhxkoA5Wx6q+9=2scn_az0u=3bar-JgBvTA-ZBkZg@mail.gmail.com>
 <CAO9r8zPR+Sbo9erKEn_qFG4GXBbSd4EJCmtBYRfV8Qvuh5262Q@mail.gmail.com>
In-Reply-To: <CAO9r8zPR+Sbo9erKEn_qFG4GXBbSd4EJCmtBYRfV8Qvuh5262Q@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Mon, 16 Mar 2026 12:21:39 -0700
X-Gm-Features: AaiRm53ixHYKjn1wGaIM0jpKDPYAtaPS04N0_lbdntKX9ASAGR8HVS1lLyutr4Q
Message-ID: <CACpmpodvy8wrSNQcSPn_koA=O+MM30U=T4p6Yr6Dkr8R8WsnQw@mail.gmail.com>
Subject: Re: [PATCH 0/2] zswap pool per-CPU acomp_ctx simplifications
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 54E2540010
X-Rspamd-Server: rspam08
X-Stat-Signature: ceoek9t879dt4r1o1aj7k689oes5gmx3
X-HE-Tag: 1773688913-335493
X-HE-Meta: U2FsdGVkX19d5wmoDHzBIlJIlBiH7vd5tFGd0krqMnDyyrobETUJ7LsoY6RqjmQCCqHwwDnddgzB5hzxGrqMNYMq4OgY3ozVkfzjjQp2uqfLcazT5BvaFap12Nql8cJlOHePG1cvghElGwAw5NQ0UBO1JoiJEOq2BxDTxJ8zwm4iEz315iybjMBSNlnYQ2HTspS3SQcHMQQMf/7EkYIBYPvbafBOlwegmDpxFyKdLwTJvgGHdGgWdho1005I4if2EtGbYAvet3O0D0EqPx2v/XPG73nE/kVbinYBuQ7CygFLDtPfe0MAPKTdQFIfA7Q8B0O8uw/SUj11jNUJ+0o7U+rnhSC3x1DPhT9eoX8Zr2XJZXoUILwzUnocAuzJOIRjNyRLOQwDfow0jDxkFkxKIm5ASc09WxhipUHzF/e78TeL1QtpJAjM6xg89W8U/pUIovm7aFsrHej1CD6z1VvawVqrLZnbsw9QMIsK1HmhvnZ4kg4u5Gf1JGN+AcDZC0ZtKjjPTG+ZbLxcOGwW97FdvUyPYm1KVADIvqr78Sd/QWJEzOnXPL2k16t78GDs9h8c5bj9pldV2a/OGfpR6Jsw70Vbs5mdYFo9K7azi5E2mlerjT5Flo+akyEBj6A4z7UdRviFBmd72UciS51ZuxRzNLZkhqE2Jq7bZ2hxZzgu7Q4QIef3IkMR711seaGCf+TTb4v57xurY8KtodKxoylYwMGhmI32Xb4PqSfnbiDtPWvAGc/CXt0m7OY7pEL3MwI3S0W8kGB3wdG4XVP+2FFcDsJXtdyH+RfA3SpNBN+I/kNeFpYZg69RVq0Kvc8+3lI6onz/YW+aECLZeMcoQ/TxbbUq821ImndPzACX0Xks57TYDfmU6ZeRlRQprVU5k+THL4PdEpN3YlfvGg6PMX6jszClKzIWt9JpPxIFA7tZher+jeNptWcEnZ4TBr3Enoa/LE5F5uZ8eYTcrdxc1MO
 EkPVU6L+
 i1QcUimqkE8IKSogWsn0wes1uc4icQNJ3XBJGX1ZAFxw3Jimg9OTSizSWgnxh92fiRI4naHQYhzDwhRfu3WF6ZScyW0pDbwc3ZWxSQBd84mPx9vzCs6Mj3EwoaRectUNiLN5UMw9UWc7zFPWsrAWHwpBtrtGpVc3MpnHC2JuFxOy3WztHfT6sQMvRIxHly65H0tBgIqjthAKL1QdmJKuQ8HH/WBy9nP4swWV23c9d75lDjbHn/ynXZlrNEyrvrfz8h11CX/084N4ClygrAUIr3TjiCb3CSRYDxVK/1gKC6WxDECoLLdUSaSfNz1FOIA4r/ZnFCWrEw5rKyEa8MhjIsLS4DiVewrbRpnqdeC9FOJQ90fFBsRyrormhw/+C58JiPoTz0u8tzr5RSp5iT5+olWR2s/0Ov2JDLMiGPUzSlaKQwO5jht/RHW3R6Q7oVsk1a95LneSk11MSaX4NxUdvHNijYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 11:30=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wro=
te:
>
> > > > If the maintainers think future-proofing is beneficial, I would nee=
d
> > > > to handle the PTR_ERR(NULL) which would send a false success status=
.
> > > > If we don't think we need to handle a future NULL return from
> > > > crypto_alloc_acomp_node(), then I don't think this change is needed=
.
> > > > We could leave it as IS_ERR(acomp_ctx->acomp). I would like to get =
the
> > > > maintainers' inputs on how to proceed.
> > > >
> > > > > > acomp_ctx->req =3D acomp_request_alloc(acomp_ctx->acomp);
> > > > > > - if (!acomp_ctx->req) {
> > > > > > + if (IS_ERR_OR_NULL(acomp_ctx->req)) {
> > > > > Is this change necessary for acomp_request_alloc()?
> > > > > This function strictly returns NULL on allocation failure, not an=
 error
> > > > > pointer. Changing this to IS_ERR_OR_NULL() obscures the actual AP=
I contract
> > > > > without providing a functional benefit.
> > > >
> > > > As of now, acomp_request_alloc() returns a valid "req" or NULL in c=
ase
> > > > of an error. Same question as above. The only benefit would be maki=
ng
> > > > the code more robust to handle changes in the acomp API in future.
> > >
> > > For this one, do we need to do IS_ERR_OR_NULL() in acomp_ctx_dealloc(=
)
> > > to begin with? If acomp_request_alloc() only returns NULL, maybe that
> > > should also be a NULL check?
> >
> > This one is debatable, since acomp_ctx_dealloc() is intended to
> > replace zswap_cpu_comp_dead(), which has the IS_ERR_OR_NULL(). I think
> > replacing this with IS_NULL(req) makes sense, but would like to
> > confirm with you if changing existing behavior is Ok.
>
> I think it's fine as long as acomp_request_alloc() never returns an
> error. Maybe do it in a separate patch first, change IS_ERR_OR_NULL()
> to a NULL check in zswap_cpu_comp_dead(), with the reasoning explained
> in the changelog, to avoid hiding that change within the bigger patch.

Sounds good.

>
> Actually looking at zswap_cpu_comp_dead(), is the IS_ERR_OR_NULL()
> check on acomp_ctx also misleading? Should that also just be a NULL
> check?

Even a NULL check would be redundant in this case, per my
understanding, because if the alloc_percpu() call in
zswap_pool_create() had failed, pool creation would have failed.

I think a NULL check on the acomp_ctx would still be a good idea, just
in case, since this is all part of CPU hotplug. I agree, we don't need
an IS_ERR() check on acomp_ctx.

Thanks,
Kanchana

