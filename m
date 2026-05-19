Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A87FFCD4F5E
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 14:49:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3A416B0005; Tue, 19 May 2026 10:49:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEA756B0088; Tue, 19 May 2026 10:49:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DA056B008A; Tue, 19 May 2026 10:49:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8E00C6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 10:49:29 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3E40A1C17B4
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:49:29 +0000 (UTC)
X-FDA: 84784452858.30.CC49BF6
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf18.hostedemail.com (Postfix) with ESMTP id A6F831C0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:49:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=YePzFegg;
	spf=pass (imf18.hostedemail.com: domain of "prvs=359937a336=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=359937a336=alexghiti@meta.com";
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779202166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/o9H5FgasefROxqKDDEdYAkxJXhkPzeFoMZASp4p/7I=;
	b=sw7cLEjBXOrd6VbKmr4q3I9gZpYn7ISwDwj29M4WOQUx3/cMfl6X2JuyczosijQideb1E+
	FUi5kSVaeydDOck3jm5d0uQEjipzsFhUnIaRLJeM4OMLHHMb0pTQrHGcOOXVv6B+UhjJXy
	amqcNHKs2moM6XJdTTJ5/ndkwoeDHOA=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=YePzFegg;
	spf=pass (imf18.hostedemail.com: domain of "prvs=359937a336=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=359937a336=alexghiti@meta.com";
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779202166; a=rsa-sha256;
	cv=fail;
	b=FGp0luBv6rhKTQU5jOL0Fwl10Jwq7y1+NEtlqfvv4mDWHmYW83/5I4AZlYUE3Ea4t0WdVq
	PB08guimjprWpcOGVFeuWMgSxExq88nHqOwEkxc7bU/j102jP0WV+qMwuGjOrkyfgnMmCP
	quSC0KPKVb+HRG0ezZznEmnqCDSjAp8=
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64J45WH5322956
	for <linux-mm@kvack.org>; Tue, 19 May 2026 07:49:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=/o9H5FgasefROxqKDDEdYAkxJXhkPzeFoMZASp4p/7I=; b=YePzFeggFfd7
	k0G+KkznX1KeDWbi5eIpQTnUNjRv2n7oJVAtwKTw1gifhjyAZ0HP4YRUN3mcDphb
	Fxq1wJ1wBZMWf6ENu3vOFK5LY7b4Z4lZo+S98EB+PwKR7mKr0ANbFVv36g8293HK
	hbptH1/YBLN3FJC5SedwuuNNYTBZ30RNxAKqbHBKezjejTScQKhtcGkjCITBS+1F
	v5s+atDbjzbcxIVd0Vd1VqkI3fBLybqWysOw7peC4SgC49z+u+qswIBh4X88RKf2
	aTiVzV+x2TSUp9rVaeTGVfFdtUHZOGWMqWyQbtZ5sDOnjpZoRR1BWwxdgofBywiB
	Tzyuzty64A==
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com [209.85.208.200])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4e6mm0rs9u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 19 May 2026 07:49:25 -0700 (PDT)
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-38e83f0482eso12931241fa.3
        for <linux-mm@kvack.org>; Tue, 19 May 2026 07:49:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779202163; cv=none;
        d=google.com; s=arc-20240605;
        b=N/LeR6sPGx893FuXFyIFUw/+GqeEKFocuEDd6HW4d/TzCMDeRSfqxEHytTIZVADogs
         UDUzEb8yHDuJfuQNSCNyL+3GdxZuJwsRvEzF5bNuEUHRuL6FZphFH5RMwzyNmppk6R2d
         UyXFQ5QfwRlUtH//9v9sX2yQXDbnwp1Ozd5uSzDRlVl7xT+JWQJWt/pzo9O1etUL0YQR
         Za33Nzv55ZUUtsMe9KM2/4zcHVuMtb3NzHo1WodpOd1F58itQUduPbMl26UFq/oNUbDd
         aUj0XOL3wIex05oPgAZP0TbFhl4bFPe1jzU2gKjBKeF169Xg4Mvw/iX53snKGVC5XD3e
         7FYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=Ib2qdk+Mk5YH+ZIlxpjXJU9f13XhSARCz98MHoIpCJ4=;
        fh=sZu24rDFSslxK6jBHg419YssyjMTJAjx3aaIBgYDfRE=;
        b=Hxz5V6pm0lFsQYqhdNWjokN3dE9B8yrrHtuxWnUozKYdZwaHCKrP2WXbj1rkuXYPEd
         682HCvOc114CIQiWJ0PyWzmzKAdRrlBWAVHP9olLsrfLrE+BLBAGC7iydNe1KQV7bJKC
         H2ilPA72JF4AtsHZslAN0bOKOExeX/iuEtcXDSmcn0txyCFlAEv7DIC2KmnySxxSm4he
         Aq1TBqvZWF9OVXuhp3GoJNB7ct5DAfVDg6skK9HQ+wrdxC6OMDbQE+3pLndHy4O+oLae
         E3bPaa8BPhTX2tCDINJqPVl2sMyGgiuNGiQxx08lTSrafREz/wvXmR+8BP6IM1RYlHL+
         Nwgg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779202163; x=1779806963;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ib2qdk+Mk5YH+ZIlxpjXJU9f13XhSARCz98MHoIpCJ4=;
        b=RUYEeUJF7ts+y5XDbPLP1HGbTnp7D4DGuBUXZ0lEBvAl++7/uWtA6R05sBOsum/1YX
         1e6yrKHQ3//yLnC2yeqDczXuKBlYaF5w4FDgKTG4K2ki++h4NIef6HUutMlVaY7vbIeb
         wL5LyABejGeufh1IcbB0NQCrDhd3PR1I7skkQddiLfxUBs88MQPr5OCM4QaQ7Fp9dFdm
         OZAD7zdCXsXq5XdQYeEsTcutXjq1WtKOHIEoaMiL03c1ClCH++ixq09TxozJqXhFEutW
         AlYV2Noy9BCQ1qTvgZHdhDCKa+KEYyhUjfIr/59UVB+BwdzCRED6uiM595Jo2T4m99tr
         +haQ==
X-Forwarded-Encrypted: i=1; AFNElJ9e+OAxEUD9tpbGKDvQADqZ4FZ69QZPuFQ3c/Ed9M92ejQL5rcgV4U+pJch+VQvzpchnfP/HINOqw==@kvack.org
X-Gm-Message-State: AOJu0YxwcOzH+S/2hzJUehPlS8LiFbTtOAhiH3cU6xXCxmUDWbMOy6KX
	2hT7lUMbljlaJzT6PnFMye3qkz1HQERtMPYLA01hDC1ssNUHNNSQy3eEo40Cf6bP/v/5QmMflvX
	gai8OH/PLpp211HC5HKCbIono2GLOGattSmF+2haO1a8X4lW/VRctH8MCxIxRIHfBq/K3DQh+e6
	WoNA7aheEsCRAg2i8g0zUB4wrj4g==
X-Gm-Gg: Acq92OHYUR2ig44KOSvaHugsHchvvlW0s5mGtx9TL1uEFTFaFMbnpxZ4SEkMeXGfH70
	z9tcCWs9dp31sZrHWPzzr10zG6IDO/S9SAvG4++AM/ivxD+Ps50PCb91LuZcWY0849R7+tCzfRf
	pSyC/rXxX7GPan+KKpJ5JrJlBMDD24E/akwJoyL8AsrQxfqzWGKz47PlSspaTrECcTW6tGt79LI
	yLKzPGvtaNLROe3bJHc/Bt2/dEG9aZCPrIPH0sK
X-Received: by 2002:a2e:a016:0:10b0:393:e33d:b710 with SMTP id 38308e7fff4ca-39561c68c05mr42739371fa.8.1779202163542;
        Tue, 19 May 2026 07:49:23 -0700 (PDT)
X-Received: by 2002:a2e:a016:0:10b0:393:e33d:b710 with SMTP id
 38308e7fff4ca-39561c68c05mr42739261fa.8.1779202163019; Tue, 19 May 2026
 07:49:23 -0700 (PDT)
MIME-Version: 1.0
References: <tencent_8B437BE4F586C162950BF71954316C1EDB05@qq.com>
 <CAEmasaV7ejxqb9-wTT=7xdt+icxj-ZvdSLkSoC6X5i6NMfsKPQ@mail.gmail.com> <tencent_BE4D8C052157D1B38BA2F9FCA287D4C8E606@qq.com>
In-Reply-To: <tencent_BE4D8C052157D1B38BA2F9FCA287D4C8E606@qq.com>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Tue, 19 May 2026 16:49:11 +0200
X-Gm-Features: AVHnY4JC-rFMG-t67F0OvJvbLZscwsKubCWhiIUmHOgFww8k8IsUXBZ97bNRJ3E
Message-ID: <CAEmasaV=L8w4dF7ja7GkDu_7U5i+aVVH1a1qsXgtFr3wuWNOPA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] mm: support zswap-backed anonymous large folio swapin
To: Fujunjie <fujunjie1@qq.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        David Hildenbrand <david@kernel.org>,
        Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Chengming Zhou <chengming.zhou@linux.dev>, Baoquan He <bhe@redhat.com>,
        Lorenzo Stoakes <ljs@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: 0XiabfUyf6jhUAlW9_UX4ZtirXLZWlLx
X-Proofpoint-ORIG-GUID: 0XiabfUyf6jhUAlW9_UX4ZtirXLZWlLx
X-Authority-Analysis: v=2.4 cv=UN/t2ify c=1 sm=1 tr=0 ts=6a0c7875 cx=c_pps
 a=SnYHy3I4CegsE2y0OFdo8g==:117 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=tpM8CJlwf7uhpglF1g9U:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=UqCG9HQmAAAA:8 a=dZbOZ2KzAAAA:8
 a=xaCPWuQt8fWdwKYzCrQA:9 a=QEXdDO2ut3YA:10 a=bxEOM3YTG7yY-q-zGZQo:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE5MDE0NiBTYWx0ZWRfX/8WCFLSXC02H
 gU2Wx+MNlOlvolUXDL3hUQnY5m+VwjgNRgW1pU/vSAI9ECaUW/IXgupdhhDK9CvuV9aDngO7O75
 17lxjQX7/hT6PcHMJCqgHB0N8VAARVmgWlIIhzAqvPJ5mTHyEi1n0xqiOhmouuDO+IRgoT3rLxU
 cFEJM1BHV6VjaIsVY24ejjHkdhEw/gJH4qf+JgQqGjfqFKPyFImcelDt+uBQlVMjFCIvhgiNXIR
 rRJg1b0QM012gErA9ZmxMrF/341FEkQ3rd3bqC7uhCSoLwKeVAzfMZDOkWE8sToryupd/bSL8Ez
 fmzohe5C2zTEEdixCbNm2iSfZd53KPOz0OCFcYV/ELxK+Xa9VpMGTxQ4xkjFj/O53uAUvoqT92Z
 LfBAuoO/f7FodocKGB76TrjXVs9CaNv9MH21c5R6U0h+sdSott6XAenOWeERE2DUXBT4yeUekjD
 lz26V5NffK1bz70Wzsw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-19_04,2026-05-18_01,2025-10-01_01
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A6F831C0005
X-Stat-Signature: iaebcibmowfbx49sw4xxrmifhtpppx6b
X-HE-Tag: 1779202166-754336
X-HE-Meta: U2FsdGVkX18ooD1k0uTKom054IBC+qbmwVy5uhfOmZUTzKjnX8WIlWhjrea2dCpYdVNeXBlQWX/SnsGIHXdO0xfLmH4nXrRng6v3j3YPgdFMojQ66rtuaIvk4+Z7Djv77ilRO6CphiGTNKK5I4p2G7/ubLN+SQRjOjU2os4/o5At67AE0LpNVWl0mc1WQ7AKrYtSB6281UiS+Wt+J4P7WA6SVSdOdzykJOnSo/bzrn5VoTUw/ZWkBvkgquH0ajIebntF95RgyT/jS1G+f0fx+XqwIbWokzumnrdqY3Pgksq4i68mcYhlOlhPm90XbMHJDhO7QdENLc0dTw9LGDQ6UH9TT0VGSYYhHN6TbHS/74xHUQRoOVOXiom2fc8TmDDQvKsvAGXd/g3xpogmCBqQOBX3HP+5veL7elbL0XVjAhMas3fFcVAza/wmc0bsgNpONuKyXAa4TPk7zv6L80vcfv7fwXN8Iu0oPQDZUMe+aRkVKLU/Qaa+5jLNA8j0JUZNpqR6fc0wsyNeU9q4ZcfxZ4VpWmyWPUDmqC+2ATFLGesua9P9Y8ssh42OPL0tVez4tjmYhfSiR4YOMUArbt98VSyZUqQN0EDW09Iw8CPQcDRFOiivdGUKxIqzNI6bhEEO16fHaZ9YrJ9Qtv53/utPHmPYkE68Na/T+40lv0yH+f3k1oK+WBW79T/vpZKb1DdyFHr+zf0n8yBmwlg2bKhhB9e/761EwpA9VqwyJp7XKRN2ftepzPipIj4y/QrDPxj9qpKUGtekqhc73n/UZj4m6apsjU4OYQbV2VdVmTgsNvmrsoGpp9PMm+W5yxXuZz1P1ayQ4JCDckjcCsl+G4dhtOMBQZuRBuMpbtjybk9KkxcG6CWl9pgft+VBAomBXag3B7Nbl6Z3OxG68urJAZY2/+7uOf/K9aw4dO2ur6O7hutSM2BFNgImW1afV9+GHC9uOkULcsyMtzir1gmAy2q
 VD89U+Bp
 Q3xn6nk3QDYx/WDu6J7ReoCpdu1PrKy7JwSCUtjg+6i8e0dgBlDDweuOIsCk1PkoGTb+FIYJyVQ3357WWCT7E9m+rjlgZrpjkc7pTRNsohvj3rib05VmMMd2QWIvTmRJGYrmL22c5Zg1O+5+9dEJICFey942KYFlTvp2bAwg65DDO1wCg3KwqeEgY04iBDAJhqfbwEhJd/8OhxO4uVLHPq8OoasglyXi/qHtvxAjfnE18AtkxfZBAbLngTI1bG9Frr6EKR2WVfGBlUaoiJPB0QfeDDs+eqn2UMI2UjpRgl3PbBQCA+dM3ibkKHamEbiO9v75e5cNuqLVPGUa3cOnfqJ98wZpRchJFzPzeRPLx9d+Ocys2BFFV4lACpebualwVfx6ArY73+g2QnOhieFO+dlKjmM3R2P8iC2IKGci90HbT0zTeoZvYYS3gy0duxOY/Zm7mPFyUoVpN6lM6yzLCOMSNUjApn2+yLXlY1x1ntapqR3D+sKykRhMBdAwWig3L8DDPmx5otNZWirI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Tue, May 12, 2026 at 9:46=E2=80=AFAM Fujunjie <fujunjie1@qq.com> wrote:
>
> >
>
>
> On 5/12/2026 12:20 PM, Alexandre Ghiti wrote:
> > So I have been working on the exact same thing for some weeks now. My w=
ork is based on Usama's series [1].
> >
> > The problem with large folio swapin is that it can create swap thrashin=
g: to swap in a large folio, swap out may be necessary, as reported in [2].
> >
> > I implemented quite a few throttling algorithms on top to try to avoid =
this issue and so far, I have had mixed/inconsistent results.
> >
> > How did you test this series? Did you encounter thrashing? Do you have =
performance numbers?
> >
> > Happy to talk more about this, thanks for your series!
> >
> > Alex
> >
> > [1] https://lore.kernel.org/all/20241018105026.2521366-1-usamaarif642@g=
mail.com/  <https://lore.kernel.org/all/20241018105026.2521366-1-usamaarif6=
42@gmail.com/ >
> > [2] https://lore.kernel.org/all/SJ0PR11MB5678A864244B09FDE4D914EEC9402@=
SJ0PR11MB5678.namprd11.prod.outlook.com/  <https://lore.kernel.org/all/SJ0P=
R11MB5678A864244B09FDE4D914EEC9402@SJ0PR11MB5678.namprd11.prod.outlook.com/=
 >
>
> Thanks Alexandre.
>
> My RFC only had correctness testing so far. I tested the all-zswap path
> and fallback cases under QEMU, but I don't have bare-metal
> performance numbers yet.
>
> If you are already actively working on this, I don't want to duplicate the
> same effort. I will pause this RFC for now and wait for your series.
>
> After your series is posted, I will take another look and see if there is
> anything that still needs follow-up work.
>
> Thanks for letting me know.

Sorry for the late answer. I took a break because of the inconsistent
results that I had, perhaps a fresh look could help so no worries if
you give it a try on your end.

Happy to discuss further results if you continue.

Alex

>

