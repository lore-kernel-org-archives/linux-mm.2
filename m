Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1584C44511
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 16:58:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C11966B00A1; Thu, 16 Jul 2026 12:58:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9ADD6B010E; Thu, 16 Jul 2026 12:58:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3EB16B0111; Thu, 16 Jul 2026 12:58:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 66FCE6B010E
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:58:36 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DE305A0246
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 16:58:35 +0000 (UTC)
X-FDA: 84995248590.22.85ADBF0
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf09.hostedemail.com (Postfix) with ESMTP id 02BC314000C
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 16:58:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kGkRx94M;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784221114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZrlZ04ZdYwGS+r38b45VN2VrqoPhkoeiUDUc8B6lYLc=;
	b=d5I+KeD4CvZYhCKdX/4bMWFuxYjNWfh67zpTFK9MsMtxdOuDkdWotQIh6PcZCfodDMJWxU
	BmysY+XlmCUpdfkVTzfgyu1pKajuLZQpoRFCs/x4XANEh6rYSRVea+p8OhIYMVAHFhMtcR
	Svuw7MyMIoSlMemZRWK4G1fi8MAxvew=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kGkRx94M;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784221114;
	b=Bw2hPQd2/Ct2MGWHKc/prNi2SRNKvE2w4yBpfJPH/P9UF43wUhk0HowMoPHLLgCQAEGbcn
	PgGs4IRut7HdAX84aC1eBcPmbtg1IJm26x/7c0vE5dT1jKIJrRnZepCoXcNtwnupgiZZxr
	vnJPK3i4EkACYV7C/3gWbTodkx19aVM=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-4629051c9d1so2174239f8f.2
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 09:58:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784221112; cv=none;
        d=google.com; s=arc-20260327;
        b=VGnXJpvmViptVXrFqkGrMEfskhPDIBsSm94lPucmvPTcEN80nrE5qOS9tp3Q+U3aqU
         rbNl5Ojf5Go43DgWDxWVIB7kMAfFh3ImP2nHVQz4eAhmD5ViqZ0oJnph9F1IOSo9vISU
         ptWQoRtQrumKBkkqMrKf2ljO45hpUaEL2EMSTBdjhbXqeiw0Ju9zMnIlmMLuisBvfOlg
         CJfk5Opc0EUyx47P2CRkc371aNT39odfECPAEb/5BFFWiefDIOR4xfhCuIcO8v37yvw1
         xLDjnTu+6KA+mW0l8wSFMpfFcEhZuUqXEZNNV6d2KTi9G2Lh0dwcGBVQ+uVu3/hrmjvh
         0CKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZrlZ04ZdYwGS+r38b45VN2VrqoPhkoeiUDUc8B6lYLc=;
        fh=h8m6QdC3YwL+JmNI6NNCPbnx0U/i2wd3uTgxxeU3JVA=;
        b=BzNVZr6kq4QR3ESH5xjmlIZhwyfHfEnd6jCrE//d7+cpZVwNa/xn9++qP24c3JYyeL
         l7jGMWag3wrTDH7Htt8FeiMLqKXB3YntAyBSzhKwfgDdMRusc+a4tVahsyPTNeuUwOq/
         i6igDdcVdB+K5KkMqkcB2StuwTOQRuNZsEGIERgHixHgJeR3L+a6boqDJRVOv4TMagbc
         J1ijuYiHXbYzX7HqcY2DVzsDPcM3X6Hf1tF1bekRXHWbtDxr47WiSJFZqTNyG2zrs05Q
         X2sBngouYuT5IxJ0/jdeB8cmNRrvXmxjBJhCjIb5MbFTD8G21vfYl5OhkJAffcUnlGyl
         FAqg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784221112; x=1784825912; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZrlZ04ZdYwGS+r38b45VN2VrqoPhkoeiUDUc8B6lYLc=;
        b=kGkRx94M7Np3TisYey9gpIlDLnv+bguoUSY358XHcxOJ+Ianu1cjIgI/xQCNeGlt6O
         spRHuMvByOTUrSK+0Vb1/cBAnWCDeH8BvTbw8jlk/mHg7IHYT/VsvKhDzBsM3piW04fP
         8l7ejLnYMWT8DloqZJyfp1Tv5J/fakBUZHjFivf/nga2lZpOR0HJ5e9kmwTWnmNlFts5
         seHU7gCG5dasL7mfg00rcTpqfYzvlsO29H5Q3xf4L3eFYo1M9MbAzOJpnwHEV4LJ7Nw+
         K7eetsvW3ftb15e19/0EfcL5c0noP6BQGDoKyxrcBUWp8EIt9le9ppYwORA9v0DQgB3R
         qRzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784221112; x=1784825912;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZrlZ04ZdYwGS+r38b45VN2VrqoPhkoeiUDUc8B6lYLc=;
        b=gGc32Zgvh63B3m1wRjrYAjlg64H6ZTJsd3nMWg11jGxE2tOCrGOwWvtxI2e2dhgWMq
         Tho9sN/sNr54ajD152rK3y6/EIabsoXpgydsl3cky/+subqrlSySUVMm8plN5Azs0sQy
         g33ckqwhD+SYtmtZG3PxIfh85wHN8cLguWRaD3R3Q+V0wedHf3+7MRqT5yPMR6I0cEua
         ZS+c2J/FL6vmNxU4ZQJpao2RRUeUnMXwzxJ6vPDLGk39crZ8b7kGxAvZvIuutXL9kRiX
         IJm0JptIz3ThqRAfEauaJqLd3Lx/PGh2vvbrllQ+keflR4uoqRuiwI5QG20yruZI+ByP
         +TKg==
X-Forwarded-Encrypted: i=1; AHgh+RqsQ2i+KQzQ2Al3BnLWViwHCJLn9rXdoE6V7nEy8CTYKk49B5Rftw/l1fGei8dJsHHMqgWhkhsr4A==@kvack.org
X-Gm-Message-State: AOJu0YzMkW8Ze0iSjtP44jDaaw5ygzAiYYLcI+y8V0QzYVwQBh1BqCAa
	CPXT0l7+0sDTbn1uYe7Te6DBRpYvWdsFfXX+t/stoAfFtrtAUnF6qRez6aZ4z7bdF3QTD1NL+qR
	1WIotJJFazGTB2IuU/5WL+nzJhyK4M0I=
X-Gm-Gg: AfdE7clj+xOHqnuupIUovhRqwTW4P51HWy4HX6mYXf2dIYn/YicJIHIj7zS/q6gevF/
	WZEZCJ4dvsUGefhqN8+vtkUH2/j3EOLXX4hLlps3h6WV4sAK81+vJ3TFrzJafn62XtRgY04RpCO
	GY2DeNi0vy/Mhdfxmar+H+y0nHfEPGqqrxToO6U9eiGrphWhKODFtyU8+iYULNtIzJGgqjZQ/uT
	qRwXxFO+oABkmZclQZa278W/B68qmLYxQvRLHH6Bh55aJZeSrzr16FrB05OTIvmHjKWrMTKDwZb
	lGH3uQIMzG+CO6z8dExedQFi60e2zzTBrw==
X-Received: by 2002:a05:6000:461b:b0:475:7de4:82ee with SMTP id
 ffacd0b85a97d-47f2dc9bf0emr28663442f8f.17.1784221112260; Thu, 16 Jul 2026
 09:58:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260707082614.95030-1-baoquan.he@linux.dev> <CAKEwX=P50av2rfocpsqZoDQowZ=EEhQ-5vj5tBykbNz8vtKTzA@mail.gmail.com>
 <ak-IS61GeP85Jnxg@MiWiFi-R3L-srv> <CAKEwX=PEgnJ4nGFZYUwMryjq+Yp4v8Op_HdZ6_xEJ4n_MrM0Yw@mail.gmail.com>
 <aldtS2S-TXc7ocsH@MiWiFi-R3L-srv> <aleW5xL2gYcU_Rl4@MiWiFi-R3L-srv>
 <CAKEwX=Pm_C6OD1jAo818wzFVVhLwgVFu-4bLdNrmUZ01URpLTQ@mail.gmail.com>
 <CACePvbV62T9LA894vTXzBZQ2PNh6iYZD7eH6=UjeFSWhUW2aDA@mail.gmail.com> <CAKEwX=NXJ1LKQOA8Qy_4YOS6v+jGbAJnbD5K0=jNbgC8Da0iKw@mail.gmail.com>
In-Reply-To: <CAKEwX=NXJ1LKQOA8Qy_4YOS6v+jGbAJnbD5K0=jNbgC8Da0iKw@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 16 Jul 2026 09:58:20 -0700
X-Gm-Features: AUfX_mwwICHVeK2vFbbGYc7NKtxl1fmLwB_YMlKTfy0_BTyqAQ56djoCQCUhWB4
Message-ID: <CAKEwX=NyNtbiObRsbZvdTT7Kz3p4KhMm5DkjeU37qWJu1fo4-g@mail.gmail.com>
Subject: Re: [RFC PATCH 00/10] mm/swap: ghost swapfile with backend switching
 via Redirect entries
To: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, baohua@kernel.org, 
	youngjun.park@lge.com, hannes@cmpxchg.org, yosry@kernel.org, 
	chengming.zhou@linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 02BC314000C
X-Stat-Signature: caid8oqfcpb8zth9518o14m6jtirapz8
X-HE-Tag: 1784221113-387636
X-HE-Meta: U2FsdGVkX1/O0ykzOifulvOpMJp6f+sf6YmyEdTwiSsgHHUjpF2wL+crSAy1/1RopPDZER5s9VAW7CvGXIX+862EvvltX50rQz9xOeTeq1NpVsCj7GJO2W4ZrGj6wcbOVmenjoeXJWMn3fi0ohJOaYAvJAg1vtOxma0khlhs7DQS1b7/eFISWGxw7K2HFXa2zeO5th0cOh7Mw8iNksF0MCz49GxuFLjr4/w/HzWERApqoSK2ACb2vndpIAOMhhQB4JFND6h5d7A1nhV+qltsfXUG9mu/KL2aRH/aNPuusyx8ncAPACb7lPFl7lnGjmXC5ladyZVej1Z7YQQ4c7m/Lx3aEorHqxYwHC5UWHW5TKTqLy1zUaCNgnznbYZvUUpTamotKrD/NeFvy8rgAgX7jRj14lPA0CdR/MhLsAMmCIetKoSjGntO4h+XipS0rKOJvwsYnxaaZS/PxzLJswdxRycqib8oIuU4sf+tZjctCQ61GNmOVxcpjLdCMrYXhzpl/1Jsyoe+Tj0LabD1PAd2sTAamn2KXXCyxP0+tgbKbhZlT4d8LoU/zFHssLBbMrA6NipAFi352GS07o6ihjov0UZFgXGreZ0h38FgMdmpt4A4ASvmPV3zCozw6s3hDAbDDXR89wkYu7js767NpuOyM8NWnKK064cAI4Lh6TdA/NRyv8XDhBRq+Ke7dysFEkkXJane1kw6S1DVoz0IrcnjdSCdV7LGPuRkLneEg0aOfEg+5chF8YHC0/7X/I27Y3eqmOrSLZ1GCMZ8m9M6uiIQRZ1iRngMua0qKMYI6AM6qDy9EDEJMAlKpIKNgZd48WMofVqnu79knFH4DKFpoXkNfOxk3kF+8RjKWtudKx54zIwXhGC0M1Tn8V1HFiXlC2PqIsWBovyhPMHZkMv5Kgw76Qv7N6CBRSxTrRDjSY7+NLg/3tc4qHqwLyD7hpZk8IW+dvMy5Zj28SMWhwCvMWR
 FBfVVmaT
 wEOGb4k8bMa+vNIF55OJGGv50UsDqQsEjdmwNqxpVV+SqoTstfQ6SuUpmX6bziuxwTutw+w3yPf+hEtfXnT6MpJv2LOgRE4sWwzg4JtBuZWmyg2lu/mIBkWf16EvnV9v1n05doo2ssqThX1CS29ugb9fF2OR2dpyO+4Gn5v+UNnEFaD9N0rTJO4amZvnWBSvUQn1iYHWB5WgRKwYjh+Vg8WKhDc5CUqg1jGZMth0JMTQkjyOYtkFyhBS4SlZ5YxSoMvwMW4KlIBQU9AUaTU1Hk8tU+/ncmobOSoNsYxNeahmywV9UZIQo+SWs13nJ61L3kMJDs4DwuERvUg3OfEWk27+bJR5ccUke6r9df8H7GsqVijAZkQolfFbH/jhl/XvDkRV0MWxHuNCK3QXOMjuXqL2lXKogQeP1oJ63T1oDkaqaZXTjMMAY7zWe31fDE1ixyvlK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 9:49=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Wed, Jul 15, 2026 at 4:04=E2=80=AFPM Chris Li <chrisl@kernel.org> wrot=
e:
>
> Hi Chris. I have some thoughts on this - let me know what you think.
>
> I understand the memory overhead discussion here. In the case where
> vswap slot is backed by a real swapfile, I have not figured out a way
> to make the overhead disappear yet. The damn rmap is very annoying - I
> have some strategies to get around it for certain operations, but none
> of it can be done without a full fledged patch series of its own.
>
> However, with the ghost zswap swapfile backend specifically, I think

I think I this is a bit confusing on my part. Let me clarify - I did
not mean having vswap backed by ghost zswap swapfile backend here.
What I meant here was, "in order to support the use case similar to
ghost zswap swapfile", i.e zswap-without-writeback.

Vswap extended cluster struct is just the normal swap cluster struct,
with an extra array to hold the backend, which we can use to store
reference to struct zswap entry. If you don't do any writeback, that's
sufficient - there will be no rmap etc. extra overhead. The rest of
swap metadata follows Kairui's swap table design (and any advances he
made in optimizing the overhead will be applied immediately, since I
pretty much did not change the swap cache and swap count operations at
all).

