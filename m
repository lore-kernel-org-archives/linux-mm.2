Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85062C44511
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:04:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92B956B0121; Thu, 16 Jul 2026 11:04:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 902986B0122; Thu, 16 Jul 2026 11:04:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F2316B0123; Thu, 16 Jul 2026 11:04:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 505286B0121
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:04:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 64353140194
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:46:06 +0000 (UTC)
X-FDA: 84994763532.20.3F985C4
Received: from mail-vs2-f0.google.com (mail-vs2-f0.google.com [74.125.227.0])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6CCA34000F
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:46:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fdsREzzQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of jaeyeon.lee.dev@gmail.com designates 74.125.227.0 as permitted sender) smtp.mailfrom=jaeyeon.lee.dev@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784209564;
	b=21m8lMkGhY/1e1n3ir1H2xn/vd1v4/T8hMWtk5Sgf4l2H1S99EgVwTzewZJXSZDXyNzuzN
	qim+RRLVk2WPl5sH+DckiQvtigMiDDO9U4Lub174rLPgtbng+C9pX897hz+p920RF2A+Mg
	g0i5Y1A0k+DG6moShse9avp3xtaDTBI=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fdsREzzQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of jaeyeon.lee.dev@gmail.com designates 74.125.227.0 as permitted sender) smtp.mailfrom=jaeyeon.lee.dev@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784209564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QxAFuQ5xZZyrvLrkS+Zmn99zGko7SEm0ZPZdWZNa3q0=;
	b=4URNyR9gGb3mRvemZj4uEEkyWUWuDSvcmf6AF3fXjWy7IRVnB5J/VWT0rdcMMA017rZiwa
	AHVLmPwPsLQI3czRMTXWDjvoNhUvuJGXdHCW8rBVCjDmmhcgBhO38UJcgTFv5bgT4fErui
	tGAcCn0RdT2SqUpe6h+KTUFPFZgeS5I=
Received: by mail-vs2-f0.google.com with SMTP id ada2fe7eead31-736e73a5fc2so5557537137.1
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 06:46:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784209563; cv=none;
        d=google.com; s=arc-20260327;
        b=r3OPn7df+v35CGBTF+cRiruO6h2r9ZDWpyb0TbkjiSFfphUSWqQ7aH4wYy979pfyUF
         b6Hx8sE5iFliXesyI6i9/PCt/DY1F6ZGy7BUwBZUn/Tw6Rrhp2i9IKmvm49Pg9RdBXP3
         Mivj2U9ERBh99uPmqFXqw8HwLEiYDpoSmc7Yc7whGEJ7wAZ9yx/O6kT6UEGp8j03XSjo
         LBXRf5PXiLm1TDZgaGPujCInsSkU6QkLDWLvoV/5IEk0Y1vyJgtbUBGzbwetmOlhGz2K
         LwMtUw76R5spDZ5MNXt5SOUaH+LDZw/Nra6zra/pB8WF2btYFiOejlyE5OiqweRCRDM2
         J98g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QxAFuQ5xZZyrvLrkS+Zmn99zGko7SEm0ZPZdWZNa3q0=;
        fh=bAeE0pSChUQjGmZmfh3RJ0eiuHNggMOk5ObZnGicYCk=;
        b=Azn1ZnLEv7od1TjWyLmkfmpVeFh0ER322EpGDE0vDQ7/W5O14XFoyZCl9Ag5ueNk+H
         Kiir5iE/zlsgB/EonktytJZMtB3xAAhqMbxMZcOTWNu/TJDSHqVmtdD/koevz2wa6As3
         6XNlPk1QK5DUScfoAIdfVTxbqBSj2Cy1FcJP5u7xdfJLbygQCnfZZnQLSpyAIc2C3vYJ
         qa9e7Tf9AEjmMZuYGe8pDW/BaK899p/PO97nEr1grr7edGzLPy5XcJrvK8Wt3CA9MORy
         lROQP+fF+DhCVyJoFkWK7jVijJ3y+gAcg+EFGaJZnGj8iqQzXYsqrh9lINDn7/uN0XhU
         W+4Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784209563; x=1784814363; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QxAFuQ5xZZyrvLrkS+Zmn99zGko7SEm0ZPZdWZNa3q0=;
        b=fdsREzzQlTTVRhd5Bi5jBmWb02jdveuFWkuDLgVKiT+Hykz7Pr4Fjm2K8X++MNyY7C
         gPTCWyS5F/tQJqDXVtbq9M7h/8y+aoUqhplNdRAIs78h1BRpLUMvvDsILIHd2V6bhbu7
         Lp4fkPNNS6N7H2MaxSROWxbJ+cRwwTX21dlRMcOJXOI0uYVSnvvgDX21GBM2HTJFdF8/
         /hk6B8aL9bGzAN31jXWwLzK1Lb+csr+ta5iqiq60qCv4nAZEvWWyLrCTfbyarSFhoVqK
         H+tzLF3KjREfemz8G0Q4eMYhMcegWKoc/QgNf/2nIcJa/dX4GUykw6ehi76E83631pFz
         kKdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784209563; x=1784814363;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QxAFuQ5xZZyrvLrkS+Zmn99zGko7SEm0ZPZdWZNa3q0=;
        b=c/5U5ZPrFtcjI22aUJByujLcsj10FL9ObYDulQq5nfWDhjkp5fHs9hHkDYTDXlcmCn
         dA7xcIFGvl1mPGZmJvLvDX8aoAnHvDKF2Nu+ecOs/57yVmqmqe+HYyKbsTO2UKPK8KvU
         y2ATsH9Veu74L/8IQeeev9Iy1fqNDDqyRTrNApghIbzXEcPduPrxcuWgKN903WUby7FE
         N6K5whxOi16UIi4PlcDzjnEkpHpaT4mHRAT+Ucb8C0xZeeNu9blEPpSLqXwD0nywMCwm
         HgRfiOxfjK5qnj0USr+QEwYyMeq9Idkxde7RBFEhB5+2Ac2A9ezyZNGlJoEkSxik1YW6
         3B+A==
X-Forwarded-Encrypted: i=1; AHgh+RpxOcfEwMsnaGg7fHbfg63Wj+6qjQ2BSItE7mPqlvkQqNgwYEGsdZ23+pq9b2wu4fX5wpcHO/hPtw==@kvack.org
X-Gm-Message-State: AOJu0YxDA9Hiuc+Ugz/AQhR4QJSDKdVKJqVweio4bEkzkFMuIvStJC9f
	Oy8yzFVxnKAef6DKoCklY0lwqJH7jQO1JLhQ6L1OL4gzBs0hGbcyXfoRH5HcDL8wvnmYtrAz4Ec
	W1hivVhB87e9xq99OsZNBWZG1tcDHMdk=
X-Gm-Gg: AfdE7clAy4DOD3VqGZriWQ+nnU8ucseXlvtiiBOCeJl7RCOiQEbMTuZQEv4w0bRC7X6
	CiddnhGS6J9XEfPCoCHb2117cRFhQEdo7vnI1pPF0VigwrwFEGYBJ/GFALNoOGpVVMvmPZSK78n
	ix+5M3XuJO6halpY01M50t5aVcVt9BppBJNsMHPu7houipiU3sRDxMmu4fUmeoA1ujspo/sy5iY
	eSBo/DEwQH2Trg/M6HzUWrK4FWCaRG0mJQVqA6XEdf/Cgwum1P5CC9DwZRZ/AnetKB2bD6JFgUW
	ab1HMz6cSqgAZxdcIn494Mn4H90xXg==
X-Received: by 2002:a05:6102:5e93:b0:738:9c79:7507 with SMTP id
 ada2fe7eead31-7458754907fmr6687137137.21.1784209563424; Thu, 16 Jul 2026
 06:46:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260715133418.170386-1-jaeyeon.lee.dev@gmail.com>
 <4b6904b5-81f9-4e27-8ac5-5bd7e7174c5d@kernel.org> <6c474ce7-8f1d-4e85-8587-8a60983cec03@arm.com>
 <0c278b69-3ecd-4ec3-b418-dea84e043732@kernel.org>
In-Reply-To: <0c278b69-3ecd-4ec3-b418-dea84e043732@kernel.org>
From: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Date: Thu, 16 Jul 2026 15:45:52 +0200
X-Gm-Features: AUfX_mxaZp1KmD29X-ZII3zTTTVur5EMlazjDkqL0QNPD91M51xZ8UzVLh_5paA
Message-ID: <CAD+X6aB79DQCVZgp7ZkcS1qRuFC8Ypjc2MvTrJy6qhbryri88Q@mail.gmail.com>
Subject: Re: [PATCH] selftests/mm: khugepaged: skip swap tests when swap is unavailable
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6CCA34000F
X-Rspam-User: 
X-Stat-Signature: 1dfecmsdr4x5qpr1raafr3d8e7kt8yzd
X-Rspamd-Server: rspam03
X-HE-Tag: 1784209564-509159
X-HE-Meta: U2FsdGVkX1+NrS9aj5mRZgaNyU5iEiys6ORk9qPrkMEh4cWS23hxk1UpVwoSiPFw1SYYzqUa5zJX/gO4jaH7wrgZbiObmaVPDWQnFB48NT8iIkylRSV70SZ8WXwmWfFddIOvnHvco5VL4N9eGUBzZ/9dZFgtlvYUgdqveADgFfBRvCjyknplGtVoXbejkxKgpsyAzH7DhrGUuCRYPnCfB9vP4nQUgj3BGj5Kzm923RHoKP3wH6Es8hSDkaiLINMf5sdoY61tPSfy3Ayoqb3B++IpuTZHF/6mduyV83gUNsyvgJd1MKmdbFNYwy7L/W6rAwiUaFdGBRxF5xmZllymeXBEs9+d/5udgCLFxYwfrNCwXc/PiADBhLy/JcWZMys2bYg4mF7Nfp6ntYK/brCi6K0FccLz/L0VGWGwf8LWXMESQnZlGU+GH5194ajhS/GyG5sRFtxqtHxlp/q3UXbRpK0vV0jF3OBE3u8Z0199PzKapPdCtxs/Od6FPg29PAxuFGqPx9i9xXUiQIeQJOVLGDaSI9EB9/Y5gCVmw697uAwGhuHAEzMj/gvo59jD/nQO1reR81K0q7FV6C1edHdR9dBkj9ty40cpT/I1A28lVUvpX2s7VNjTIAVeuhao4eBlE1VUe6Px6RJ71YGRYeyGejK6sLSsXEcdgktbhD6AUqJLLOMmszT1IX7eG/XYE6KVG//TUcHkCD1obmyukET3twDBSBhissstNHOSKl0EjkOuPRcGc992lLPLs3WSX3ZmRZ1L0KvWKy3vSPxSRh8tZa+o0uZ67SVku3W/zQNKRrJP8ukgt6z7e56lk9G3pp2XFJsJN8QOgL7PRN8j9ECZObxGwShWZfaxvwuajTw0pz0MB1m4mdGNb5d48ok8rNMV4meui9ykOX/HtUBXML+2GdBO0KLOGoFRKuPI7mZVnJhK2Ms1jl7uxsr046aadW6Lq3OzU3huXVj+BBu8A7Q
 rSBOJnur
 6NWq1Ud5/7FTArHdzDB9Y8xEN1M7N2fsDWhposMESa1yr6eyrdkRX8e2m7o6E7kOKFYnqc9IPyv4asFdvCg2RyEEOavWaDpSo/PcUrLwNxkShWygWKyZ4K5q0JylbE15k3QxW6nlj8RX/G2ieOBVIHBhjTMdqLy8cCHJc/reDJNMo0vAEi9wTGXbBcOHLysop81NBvK/Dn1WHbbKjzc26HThjh3hY8oAFbO0G9x5DQWaCI/t87cdvmPdWa/KMoRykPYMCV+04XuClDBZsnnL/vFKIx7XYebvn3/BD8RmdOpIF3ByA30Hvdhv5yeXXs0WWULCkLOh8pxSG/3njKA+CkLIuevF9pnLbTeX8cnK595FA/O+Njmyr3J9khf3KHPfEvmT6lL1hfc/PNngBnLfSZYCuifSBhmVw/9zL8640B2rkkgD5aurXFCoFMw0eTAfi7pLzh1GYP6uZl2Rmc6lPP8Np284bwWnSgt41
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> I would not pack a "let's test if swapping in the system even works" into=
 a
> khugeapged test.
>
> I think we can reasonably assume here "swap subsystem is not completely b=
roken".

I understand the point. I won't pursue this further.
Thank you for taking the time to review.


On Thu, Jul 16, 2026 at 1:20=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 7/15/26 16:47, Dev Jain wrote:
> >
> >
> > On 15/07/26 7:39 pm, David Hildenbrand (Arm) wrote:
> >> On 7/15/26 15:34, Jaeyeon Lee wrote:
> >>> The collapse_swapin_single_pte and collapse_max_ptes_swap tests use
> >>> MADV_PAGEOUT to swap out pages before verifying khugepaged collapse
> >>> behavior. On systems without swap configured, MADV_PAGEOUT succeeds
> >>> but the pages are not actually swapped out, so check_swap() returns
> >>> false and the tests report a failure.
> >>>
> >>> These tests cannot run meaningfully without swap, so a missing swap
> >>> area is an environment limitation rather than a test failure. Detect
> >>> the absence of swap via /proc/swaps and skip the affected tests
> >>> instead of failing them.
> >>>
> >>> Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
> >>> ---
> >>>  tools/testing/selftests/mm/khugepaged.c | 25 +++++++++++++++++++++++=
++
> >>>  1 file changed, 25 insertions(+)
> >>>
> >>> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/=
selftests/mm/khugepaged.c
> >>> index 10e8dedcb087..f9b4ebe733ce 100644
> >>> --- a/tools/testing/selftests/mm/khugepaged.c
> >>> +++ b/tools/testing/selftests/mm/khugepaged.c
> >>> @@ -100,6 +100,22 @@ static void skip(const char *msg)
> >>>     exit_status =3D KSFT_SKIP;
> >>>  }
> >>>
> >>> +static bool swap_available(void)
> >>> +{
> >>> +   char buf[256];
> >>> +   bool ret;
> >>> +   FILE *fp =3D fopen("/proc/swaps", "r");
> >>> +
> >>> +   if (!fp)
> >>> +           return false;
> >>> +
> >>> +   fgets(buf, sizeof(buf), fp);
> >>> +   ret =3D !!fgets(buf, sizeof(buf), fp);
> >>> +
> >>> +   fclose(fp);
> >>> +   return ret;
> >>> +}
> >>> +
> >>
> >> That doesn't mean that swapout will succeed.
> >>
> >> Take a look at cow.c where we use pagemap_is_swapped() after MADV_PAGE=
OUT.
> >
> > That suffers from the reverse problem - in case of a real swap bug, cow=
.c
> > will skip the test and anyone running the test won't bother.
>
> Yes, because there could be other reasons why MADV_PAGEOUT would not be
> successful (speculative page references, out of swap space).
>
> >
> > I think this patch idea is reasonable, we need a way to say "swap defin=
itely
> > won't succeed because there is no swap device, so skip" vs "swap failed=
,
> > need to dig in!" .
>
> I would not pack a "let's test if swapping in the system even works" into=
 a
> khugeapged test.
>
> I think we can reasonably assume here "swap subsystem is not completely b=
roken".
>
> And if we want to check for that, have a separate test that stresses swap=
ping,
> if available.
>
> --
> Cheers,
>
> David

