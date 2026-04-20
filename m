Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89EFFF588DE
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 14:26:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDC286B0005; Mon, 20 Apr 2026 10:26:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8D646B0089; Mon, 20 Apr 2026 10:26:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA3A26B008A; Mon, 20 Apr 2026 10:26:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A55CA6B0005
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 10:26:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 44BA71A09F6
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:26:28 +0000 (UTC)
X-FDA: 84679159656.10.ECBCA5C
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2E0604000D
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:26:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gCtCErEb;
	spf=pass (imf12.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776695186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YpoyB0p61DbmgrRFMwxcLVjkrfcdRI7WHDVdIX2rSis=;
	b=U/rdXTtE17Nq0WXDU7VtJpzZNg5T3uNse/Fpfyt7mwEdafEWAhxVf+trXVljdaK0w13L2o
	fB1goUG1DKEiO1SZ8Y9YHdJfhabXIFKm/BZco9VZnutEApOPPCNBL4z7dRaYmM3DX72rZf
	lmcSASzi+MlpYQAA9PvX9gVaUH6fD1s=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gCtCErEb;
	spf=pass (imf12.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776695186; a=rsa-sha256;
	cv=pass;
	b=SM5vB6KJf5+P0P2RflM0bmZP2IWGtsv85t4lZ22G0A6QNhQ21vZq4CX6+buB9ZE/PZM6dW
	dnIzkCvbUx5jR1W0R84EmrGQBvodN6NBaQC9LD3zR/KgIGiXUB1r5xFNFebKxvhi9Y5bxq
	XfIrFeHdMi6wFOYGXT35rHthUpWs7E0=
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-7b248750279so27893877b3.0
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 07:26:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776695185; cv=none;
        d=google.com; s=arc-20240605;
        b=ZeyoabG2TXMQaO24xBzFqxB2K8DM2eIe+fSDsGFg8rf+XqPmwvhiRQwi8esNIu91rD
         ixmsAOGpMK8fh62rOVC3YgpiTX03Jnt2SGPOZX8KZpP3T0Rv2FPoKbRL/xCGdvOBlpeS
         SYlMMeprg2XLeptoJmEEvpNiZgzaZAukoJLaGGwh++jZdsPGQRly8h54jqJ/ls7MXhhH
         EBeBcpFZkmsWOA7duBQ08+qb/Qz3NHyhh6ZdPurw+p2okA6VEnlrs51taefZ5XRNV6+o
         qRkkhM2pErLM2u0SWZ4DjVgq6Svzg2d3wn6nKkCxolnTbkq+qOMz/hAyK/CUUf4L9rVz
         VJpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YpoyB0p61DbmgrRFMwxcLVjkrfcdRI7WHDVdIX2rSis=;
        fh=3On41IorS5HHOrCH9yZIIvrCAuqdYeI6IcdNrgIKsWs=;
        b=JWcvHsoJaUVAWV2odEWn6VhAOqUwaRp+I4XtdDCxGWqXvR7HwgOGDiigkGHw16/TVn
         zC2Fl0bVCkn/8Wr7m1mgQ6mvngggpmKIFyb7VTfDekxWeA7oY6hxTPZ3MkwXXAftCRss
         pDpu5vAAxxg0xzOHXFZsT4g9xIGvlBknjioDEpDKC4uLwQSbjCR9aGKY+jhvnuChbfe+
         m1Ud9pmUL1eye3K0f7yyxbcYnKUY8WHmKu2s+KaxV+CNajwvh6SoM0tofp6clyBCDSVC
         vh7ktCQX3v9UVfu5tHGTC9H2Cs6rUCoXxRq7gN64VZJD9lCDb6bvTdYnVhhaRiNb9R7b
         dq9w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776695185; x=1777299985; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YpoyB0p61DbmgrRFMwxcLVjkrfcdRI7WHDVdIX2rSis=;
        b=gCtCErEbah5ZRQFyGLFL5/8lpmahi9kW5L56Qe2+R1p3NOAL70XzpUPpyayN0SaDPl
         Jpg7Wa60KqTNxoeXWvzNF2CS0nfntfbp/WWzLwYA2ZTjbR2S+/t8zdTRzTMkXQOqGaoV
         wSCjFvuyO762q+Kg/psm7Nr3XRQXDot4rDP+9AHVdiGwsgbScZndrFLCSEI561MkA1Tf
         sIkrYw/dRGJsroaj6jGjutc0nDs8uZxMugXDizy8X5XwK1UqHrIFERM3MXBKBQz4P99x
         PnXtRQodPkQq/Wg13/v5dUnaHVhH4KjgiYN+pP7mRmdKsNSrefN6AF2BARC0Punpnaeu
         S8JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776695185; x=1777299985;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YpoyB0p61DbmgrRFMwxcLVjkrfcdRI7WHDVdIX2rSis=;
        b=CJ1BRw5e7bcQPVtMnGmVPN+u/WZmwrZxZQhG73UEgYlUV17hAS/OkHY2aAlDI+oclv
         +caGTMirtt9TUn+NUMKo4hCXSnTohwdagZFSdhNjQlv7Eg8i4FjdIYyVR58qa/4jll8j
         QpdLaEtMoQ4M9355Ys22513hbLQVrPCzFKwa4bDIz3SZcZFGpCnX6/4jrHPynpNRaaDJ
         nUxGdGyUgzDy+0zrGJP4CnkPFZGVzpPTdp5mfyPrJTq8A5WKC02oWSHbhGwLj7jWOezO
         P6lesFY+i9UTmP+zHegW9eF6k8kFTlo8H2hWPEDefwmgduagz5yATMJTuUcSaICLBlxu
         xnOg==
X-Forwarded-Encrypted: i=1; AFNElJ+nMyBA/YRcGA4clhIataGL6OqMKFr1LaGWKlIEGxHrl5BYfg/AKJH2zzv7Dcab47SIHaSiiDD3oQ==@kvack.org
X-Gm-Message-State: AOJu0Yxru5C6MwbjaB/RXblg5Oi3jsJcTPWvxBIvRrG/sCwiiT0gitqj
	WBuuvlscef0BGeeXdZ0uzkwnSK+XiFkEZhjJggXIPQwOzFELFT5UgRUSYPlYMMN6gpIMk3gM45N
	tffVVHDh0PT9eVv4KyKu6UgPmX2g/jppa8HZA
X-Gm-Gg: AeBDieu4XNlt6mbgMuKb0i47U+HCKWou1ch3YYbgIFnO80NNGNxTV3xCGYLXZD5UHRu
	/hYsLSrSrLD/mR7P1kxr9RUyuUbt5ONjFLurQTt/8fSL/ve5ve06QWOMPu0pmboprOCWysFPKBP
	+Xo5/qlXHmzwKdIOWnhuGr6dV+JC3jN0ktVZxVDZDHmnAgDmRqr7jIKzO6uqay8kq5oVT11seiJ
	7JX5S4PLZOAwa3rArE4BwtZO2BCevLXssjrNsx+8685ypd9r2OUGExNEwAcehF1i5q6fNtKld/K
	qcLpdp2CS5pwbD4=
X-Received: by 2002:a05:690c:386:b0:7a2:8cdb:b597 with SMTP id
 00721157ae682-7b9ecf8a79fmr143914487b3.23.1776695185105; Mon, 20 Apr 2026
 07:26:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260417135805.1758378-1-ekffu200098@gmail.com> <aeXIKM9BeRmaCZ_d@kernel.org>
In-Reply-To: <aeXIKM9BeRmaCZ_d@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Mon, 20 Apr 2026 23:26:13 +0900
X-Gm-Features: AQROBzDRo8gue2r3sFy4C089fUSXJBIuwNelRmGQTbvzh0EWOmNlK27ysYtNwi8
Message-ID: <CABFDxMHT0W-FFuLJwiWMqXueXZvz-2wSsZyRPKJ6ki6FhVPLnA@mail.gmail.com>
Subject: Re: [PATCH v2] mm/fake-numa: fix under-allocation detection in
 uniform split
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, djbw@kernel.org, mingo@kernel.org, 
	linux-mm@kvack.org, Donghyeon Lee <asd142513@gmail.com>, 
	Munhui Chae <mochae@student.42seoul.kr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 3szfh9srws54st7bjt4w3ymwox6pf947
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2E0604000D
X-HE-Tag: 1776695185-479142
X-HE-Meta: U2FsdGVkX19HRUGoMJ9xtzovcc47Orj2m/tAqITGuJfuu/ZDjwEsW3rlhdUAlREMkB2VVdtIDjIhz1IkPwBDSPT2SYov5CF1L2w0qWwyqF1itFSRN08MhGB22jktS+mXmsurqMG6IBX3IB5kOeAbKD9OghCK5351Q19FToQPfg8XSmS96wd4cb+vg1IUhQ4Mi/OBf+KROe0n2xu6LJ3E5KG01F2slTCpguOEXEf2Y4XgClTydm4crsYZN9OJ7rJHomBqQQVvlmv/7Fte1K2F3ABklSUZL8QEXxr7Lib8js+WtmWV8+//n0miN1dso+MnwOkp+bkz6y82DP0xjiEOw8wlIuXv2Ir9NzyzxcbVafyDER7zdQlPKJjiCqIhLdVDmQEDvNEYqVVz4o0/EWZbPFawiVSDzgQmyAexBA4y2Ncl5njYJSq08yXIvf++1u0qIyib4q39Fia2sS9g90+KoobeKgwGHHCvJG1gzAbLHfDJLIlcQDeZDu1pwrOPEtS6orFTnUasvkSafW/jDZsmbu0ALCrs9kqmwkcZi2cT2gfMCdQwItwKZcl6ucYF37YcHgdUrycHz3WmDksxxuWy6Lb6awd0CwlMdVBbe2cN6IXV59qeN29wL7grG91TVs/SoCH+HVuRES1V/Mq4D5dGnH1vr+31TK+j1fpSYnEZTJo2/3Em7Onq+329006m805/Inau2HHlN6eneBHHR+V2ChxEKb/fGY8idy/73O/1SnngIJKTI/Y5LOrZH+s/OYjwHU1Z3xTwGBzGWrr59IUifT5wwvPwDffnELTBHDZhIg6nGtB/ErpsNp0VHJbxyNbnvPHU7gYYVi64zro/QPa7tW4FPC6LWtn57N2YDNzvvgojT6oCwBhQqtsfpOv5GqXUHTEa505HfaXJKkptqxiCeunQ9q1MrGUlEsBHo8m8oZW5lfWdJcxMQj2kwXvFJG+Tm0hQhulMMDykJQ9WnZ1
 Ne23iYoN
 W207WNcmANqEciFYwgAg4QKWYPnrDoHHnpkaZwI6u0ht2PV0QvZflowrFIkboBygllgvaB9AEWgMWwVKrVgf1OQifkq2dcrWlDgB4EpnbZE+wwLQ6l+rmGX5k/I0P3IWQurVQETL/j9kdwFqDs8F4XCVOeCXEuzFbxZNXJHTu8Q5dNDaiYHQu/m7uuIdmdap32LzgF6G1YdxPbjI/X8QzzAso0Ik9k7Ho4lSwLlQzkg9n0ilFc1x5Yr+OFRbgvY7m1fv5uyKWOjN3mMUCCWk9JBGNzeq1pZWKro0OOp0vXhC353KYH+2YI4ULNfYQraQS0kmbto/0EJntzsCPnpf93qLvSfuIyOa5fJ6rVuyZNO2R1yXmBByAun6sLm7S5R5hQRCfp6r1KNhGMtrtWYuQByBM1lMR0TFvmfWPPWsAsTe9a8JlnhBjK1ECfC0zJxKtySDC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi

On Mon, Apr 20, 2026 at 3:31=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> Hi,
>
> On Fri, Apr 17, 2026 at 10:58:05PM +0900, Sang-Heon Jeon wrote:
> > When split NUMA node uniformly, split_nodes_size_interleave_uniform()
> > returns the next absolute node ID, not the number of nodes created.
> >
> > The existing under-allocation detection logic compares next absolute no=
de
> > ID (ret) and request count (n), which only works when nid starts at 0.
> >
> > For example, on a system with 2 physical NUMA nodes (node 0: 2GB, node
> > 1: 128MB) and numa=3Dfake=3D8U, 8 fake nodes are successfully created f=
rom
> > node 0 and split_nodes_size_interleave_uniform() returns 8. For node 1,
> > fake node nid starts at 8, but only 4 fake nodes are created due to
> > current FAKE_NODE_MIN_SIZE being 32MB, and
> > split_nodes_size_interleave_uniform() returns 12. By existing
> > under-allocation detection logic, "ret < n" (12 < 8) is false, so the
>
> In this example it would be 11, won't it?
> I'll update when applying.

Oops, my previous reply is not the main point of this review. (Please ignor=
e it)
But 12 is still correct, because split_nodes_size_interleave_uniform()
returns next available node ID.

IMHO, it would be clearer if both the commit message and the function
comment change into "next available node ID".
If you're okay with it, I'll create v3 patch soon, including minor fix belo=
w

Sorry for the inconvenience.

> > under-allocation will not be detected.
> >
> > Fix under-allocation detection logic to compare the number of actually
> > created nodes (ret - nid) against the request count (n). Also skip
> > under-allocation detection logic for memoryless physical nodes where no
> > fake nodes are created.
> >
> > Also, fix the outdated comment to match the actual return value.
> >
> > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> > Reported-by: Donghyeon Lee <asd142513@gmail.com>
> > Reported-by: Munhui Chae <mochae@student.42seoul.kr>
> > Fixes: cc9aec03e58f ("x86/numa_emulation: Introduce uniform split capab=
ility") # 4.19
>
> ...
>
> > @@ -416,9 +416,18 @@ void __init numa_emulation(struct numa_meminfo *nu=
ma_meminfo, int numa_dist_cnt)
> >                                       n, &pi.blk[0], nid);
> >                       if (ret < 0)
> >                               break;
> > -                     if (ret < n) {
> > +
> > +                     /*
> > +                      * If no memory was found for this physical node,
> > +                      * skip the under-allocation check.
>
> checkpatch complains about trailing white space here.
> I'll fix it up when applying.
>
> > +                      */
> > +                     if (ret =3D=3D nid)
> > +                             continue;
> > +
> > +                     nr_created =3D ret - nid;
> > +                     if (nr_created < n) {
> >                               pr_info("%s: phys: %d only got %d of %ld =
nodes, failing\n",
> > -                                             __func__, i, ret, n);
> > +                                             __func__, i, nr_created, =
n);
> >                               ret =3D -1;
> >                               break;
> >                       }
> > --
> > 2.43.0
> >
>
> --
> Sincerely yours,
> Mike.

Best Regards,
Sang-Heon Jeon

