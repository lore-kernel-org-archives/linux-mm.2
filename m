Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63ED5FF885C
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 13:30:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25C986B0005; Sat, 25 Apr 2026 09:30:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20CB76B008A; Sat, 25 Apr 2026 09:30:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D4F86B008C; Sat, 25 Apr 2026 09:30:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ED8FE6B0005
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 09:30:12 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2EE1E1C031C
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 13:30:12 +0000 (UTC)
X-FDA: 84697161864.07.415B8D2
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1D922A0011
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 13:30:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YNbBSlBk;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777123810; a=rsa-sha256;
	cv=pass;
	b=6a1ggwWVARjXi7S9Qwco8vPEP0iIz3JWS38U8/3CwUXSPUl08BeiJoWYNHeJ///1Kn8wZy
	+nPlTMttvb+YTP2AD154mgBn8TIp+F41jsXyK4VY9AW3RwigonxAu5qYXwRliqztO8kvJg
	jFX8FbO1SoU6+PlhJtOy3iCGxjuNIIY=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YNbBSlBk;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777123810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kdo7HIRliWY8XXFa7QUa9nj2slRxsOezIUZCSsSVAeM=;
	b=MfITyC1fhkL+RwbU010ypbvMP+OifC3O8VwKf/OD4XwRjyomS6p0zugMKoGNEDMVeNJ20S
	ztiyQE6N//zonrgpXO7YC+/2wE+k5+gRo4F9Pk/4MuOETi+EwUqvYVGHOsHzNb37aJxEyb
	F45OSFR8lJsjOHk3hRhm+i2YSi/aY+I=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-66b2d49ffb0so11148363a12.3
        for <linux-mm@kvack.org>; Sat, 25 Apr 2026 06:30:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777123808; cv=none;
        d=google.com; s=arc-20240605;
        b=akk6NLgg3kTyqJcgQ9bIAwuf/Pbo2LBXxLFziNDh7rOYWnCAxOwGtrpln+UldZjV6x
         9mBAsyGmAfI5zGVbT5+V7Llj/J0eskfPXu9Lbwd/Q2gPhOBVxXfk2j6sv/zh1UGr1nBO
         YjSR7o9ycDliAYULJfgbWqIWTmbuff3uZdGNtN9QNuAlnju2tJNEZORFixpl2va9WsHM
         tE679JsIeCX+MTLpoygfBOMiW58dXxEuEgXb7H/TQclsU5OK3kLIUl+ryhBoKkuSkAhu
         NBc2Thk77FjtmkWrOn1r/37EzgKri1bLKNEgkvUqjJc6CPlJMyiDaNb6YIBaEk0kOprp
         Lyhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kdo7HIRliWY8XXFa7QUa9nj2slRxsOezIUZCSsSVAeM=;
        fh=H8awOgofe9e1ujESOU2zM5cTDXjgfwcd8q93/hU1FxQ=;
        b=YtLVMFyhnv+y+MTdVUXyDCDrmAKGhHtoSLfMwRr+uUzyOI1/3QUPeHj61Us9ITG8BG
         QT+RwbSBhzzU6eR+pD13m3/5n1i7mqzxxEVD0ctvdRFgbgLSPsTqe39WGvFgiVQuC/b1
         dXXteaADj8jHYqsDMxt+SuS0CFtj1vpcK8CXIhGEZNUt4RXiaL5dZfS/q3DcnHLzqf3u
         kg7fgDUuYu92RSPVayFhSNOEZ5SpyNwohrd7dCD+38eTU7hpn6yNoNFWnolixFvD7IC2
         1xzmMWK1wXHGPMf2DSzLdCn739wsr3dbXNZoCAJ+4oIDXuDNWb/nXLO8hwT+COT5yqhx
         TeJQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777123808; x=1777728608; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kdo7HIRliWY8XXFa7QUa9nj2slRxsOezIUZCSsSVAeM=;
        b=YNbBSlBkyHpwDcPtvO2ZK0wE1x3+Z2CxB4H+wsbkRIwOnb5NPQdxdaZTEzQK5dAUmf
         NqddODnQyR8AEh5g3Unvy92WYZ5KePAwth/25liqnKCr/LwG/bn7sLqD4rOETOqW6gSt
         XpbL5MrGzmRtb1j78nv25K8GOHMgTYTSBKHNnORFttXpH0DzZySqJEAWbkvV+9a0Gt0O
         AJqBiZiGT+fGtgmh60moUhvEft6H0NiHfTiKqmla21XvbGoza18MQ2zrIsMOjPnJ+A3P
         uTzFctG7v7n040w3IKhHqksiz/iuLoPWZzgyJoXKcvlwut/3VfWtcZ0KR4/HkAV/gjua
         l9/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777123808; x=1777728608;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kdo7HIRliWY8XXFa7QUa9nj2slRxsOezIUZCSsSVAeM=;
        b=bKh0RNdWOdcI78muPaNMatIZrRFeFMfucR8Cbe6AtaTvbK+BHcIKXeIZMM22jBn5Sl
         RVO09MX/Kn1+caJWwR5ARhcnF5o/pRJNoVJtwpYPdreFmZkEStBpeZKqM6wcy76GbiX3
         ENdyxmepiUj9qHGhaGJNjTWgsvrfsUkUEnNHq2gFN9BooYyfYyjcTUypmyHvYdzziPxZ
         a34jh/mgUK1cMMsuvCNjUEzSmZkAP7gqNFh85sxgAQ/7SMBe5XnsNWG0HdYv+IBi988L
         eKfkJzHVCzJpZ7MxIp6YzZtu2KybZMMPUk4HoHzpz1bp/PTpjs843skB1mQkTSeAbNjO
         Swbw==
X-Gm-Message-State: AOJu0YzzcBaAvTjO9vobsX7lwlS14ID+81OhwVBjAxyIfr8+K5uZNtQt
	KjdnfRlf2GPwpVCuJHWMrJMQN9IjvsH3017oA1FbQwHbA37f2yUKlctuYIbMGAZnn4PLan5d1y8
	+9hirA4SOSh6SYo7YaMn1mS8+6ko1kAM=
X-Gm-Gg: AeBDiev/NilQtjR0RK4dtY45s/+AOTW6Zx0C0vaWAwTmMt2j/GsDCTgqF6cOJkygy8r
	tLVG1mdSKLtzPGM6EZhfyBqp2kDkGTtrXHaV+N0TV+J94KV2k81+s4jHhV3bP6kMrI7a3fRF7FO
	0pNa+DdyUKoA47TOnjichvOSNdD4NIIbz+X0KGXzazhht6USF4lhc239aGdnXjLEgpuCnkwZ0n9
	tOV0py8tGM6Ds++csEc+of8NaBAVBUs9gH8Uk6rbklK/NoM1zotCtCcvTGlZHK49bQqaJaT3ikY
	aUYcf3H0cNw/lNxxhd1e1FJXFdyZmSsTziaFy5dxEFFlOgEDlt0=
X-Received: by 2002:a05:6402:5485:b0:66f:76d7:56a4 with SMTP id
 4fb4d7f45d1cf-672bfed8b0bmr15123268a12.26.1777123808073; Sat, 25 Apr 2026
 06:30:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com>
 <CAGsJ_4wLc15iF4sa6z+i812vaoabAGHS5ErPpjRyjLGMP=44AA@mail.gmail.com>
 <CAGsJ_4xre-x0e+qNVm=KLFnO1dbPkPX5RuecqwvTZu-vS+o8yQ@mail.gmail.com>
 <CAMgjq7D1bzYd+WmdbkUvS_7sNmC-QKYYY2+J2Oy60njJx4FfJA@mail.gmail.com> <CAGsJ_4wKStv8roeKmWLXScz0k0cMJmsnyEPjoLfH21k+R00V+Q@mail.gmail.com>
In-Reply-To: <CAGsJ_4wKStv8roeKmWLXScz0k0cMJmsnyEPjoLfH21k+R00V+Q@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 25 Apr 2026 21:29:29 +0800
X-Gm-Features: AQROBzD-4mDf45lLLuJ90PZkSrLOvSXqBEP2bVSEyJtDHgQLh53jWVEvuO84ZxE
Message-ID: <CAMgjq7DM6Sd5EYx=PLtYHBYk6gAPFupYg2a7nib2KrGBO=HtGw@mail.gmail.com>
Subject: Re: [PATCH v6 00/14] mm/mglru: improve reclaim loop and dirty folio handling
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, David Stevens <stevensd@google.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
	Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9ci7dyqa64fb3a9u9wcd5b5whep9ws4o
X-Rspam-User: 
X-Rspamd-Queue-Id: 1D922A0011
X-Rspamd-Server: rspam07
X-HE-Tag: 1777123809-958805
X-HE-Meta: U2FsdGVkX18rOcFQZgSM0kCkwWJbFqBgbgr3NnZwXhqVFH7/pV0DWCB1AoO1lYW4yrVvYtIEm7yeigoaUrwU5gKav55eIxOXaJB8ZHrFcI2xffYnRxWPXXE0sVE7SXH4nFaisC1lW+kuuVHqVcxM8Q4RgVrSjTxzcKZpRZmLLTeK3n4b6NY4uPZlF/r3uDdc+fzJlwOObVuM9qJSd0jwNaeARXjhjHl5eRaYKuo/Bfbxl0mZLituvVmyieR6ogqEwCt0/9UkVyrrxpE1SOztwQsh2hFDuz86CmcoH3Xi468/uGR/4+vqq3yLjPZwm7OElc/2q8hEfUMnP/+R2lf/f+OeSf68DYp2A+LKH3ENpMdOBCs9LLXrAtUgNlQFy9XJyEOTKDIQXeEkv85fmGOMzT9EyI/eWMQRXIQYNSBzD2847TVhByxtsuPOyVwQ05xP21mcmciumfGBMNaiaiiT+4bmdpqz2Cu4PPXzixFNv3z6zt9zcov2lQaIjKGc3+YCHeHNM42MFJ7WfOM4zeA0xhH/7WTtUk5L9YWNREO4+7LL89b14HZIR8rfUfcTnPGmA5dSJ5cyKXqC31pdZ9MKEdiy+k4SLEDqJhkkPO2SYMLG2xBdaai99XZOuXjU8Habm94NsGnE/3qtaKPtvIlG/aa1+kb11Rc1jnwc2pcBDKU0Q1YPCIDJhJtUuwJ+7VNiceKssrCbVAoaM/tWbkId0nk/OICEUjdFU/0Jnf8bqorCxufwYeemNbGxnQxAMQwLd+NMUspO1Ij28CbTG5Ogd5uEugbqc0XO56bSLwmlNeYpc0Dp5zEKFW17KDqoyeZ2PGs2XKLYn80+6ILbc0qQrfg4RzJPPk+yGWv8F4w4cVHephN+a65sa6m4tAHJmw7gidO/j/QjspqgNBc1lFJj55tvtAn9fN/ADVLQ1Y9P7NjHSFg5Cq/g0U+0ZOzQWZ1f4fzFKLkGtsqFC1D4SFz
 NDSpGnr3
 hgBBOoz/xfK5qBn1geZawIHG2a37nqrW3YkgHNH+iApfVmFRfan2ZcFZTpINS0feURqXSQ42ptjE4f3xzOxvbTWVUyZ9yuJVN5ydRzNCsNy7ZUjbQcjiTAauB7dVKZdYvPEwpyQZxvqA4Yk/kfwMhN5yfU/lGobMDczy1BkAdlwkzzxudflxG2yiQh1v1NqtAeoldh+W8h/0lFZw6MggktGFlajeG1hOnoD2NJeM5IEUdErA3aB7sFg01woXFlOWjvl9tpULvoAbhTU8gn7ARst7+hteVIogcjhidf0c5JUmuX8KuftzIcmkHc1bXNpS0TONuQ7GCOMUTlEbrOJAxVXvTqr/NnJNxG6SmP2HkEfiy0p7uozyLNzINZu+W+YEN756DVDaLER+GHYWNgxu2ls/Lr8LBqWCcgQC2v1eyxpwyz+KmwrIrXuK39cL+0UAGoJd4IGAlj6vGblZ73eGZTyGcFCz2ax78I9ztpcR5yQldZeq/KByAKUB5x/NPiTM/x0xNIgBC3dyOg5WcpbusAI6HvM5nwb7CMFEFQ9nFo6w1zXKr6aNDj+Ts09QPw9H0AyijlxhfCPcFP/AJWOfXco1A1e4F1oCx9weD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 25, 2026 at 8:18=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Fri, Apr 24, 2026 at 8:56=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wr=
ote:
> > Hi Barry,
> >
> > I ran your test script a few times, and strangely I can't reproduce
> > it. Swapniess behaves similarly after or before this series. I
> > directly checked out the mm-new commit of this series (4ce85c040e0a)
> > and compare to the mm-new commit right before this series
> > (31a112f05f62). I also extended your script a bit to test more
> > swappiness:
>
> Hi Kairui,
> I reset the repository to commit 4ce85c040e0a using
> git reset --hard, and I can still reproduce the
> swappiness issue. My machine is:
>
> barry@barry-desktop:~$ lscpu
> Architecture:                x86_64
>   CPU op-mode(s):            32-bit, 64-bit
>   Address sizes:             39 bits physical, 48 bits virtual
>   Byte Order:                Little Endian
> CPU(s):                      20
>   On-line CPU(s) list:       0-19
> Vendor ID:                   GenuineIntel
>   Model name:                Intel(R) Core(TM) i9-10900 CPU @ 2.80GHz
>     CPU family:              6
>     Model:                   165
>     Thread(s) per core:      2
>     Core(s) per socket:      10
>     Socket(s):               1
>     Stepping:                5
>     CPU max MHz:             2800.0000
>     CPU min MHz:             800.0000
>     BogoMIPS:                5599.85
>
>
> swap is zRAM only:
> barry@barry-desktop:~$ cat /proc/swaps
> Filename Type Size Used Priority
> /dev/zram0                              partition 12582908 280940 5
>
> The data is as below,
>
> *** Executing round 1 ***
> set swappiness to 35
>
> real 1m51.699s
> user 25m31.134s
> sys 4m13.127s
> pswpin: 1562949
> pswpout: 4840525
> pgpgin: 8751872
> pgpgout: 19741097
> swpout_zero: 1095783
> swpin_zero: 18079
> refault_file: 515292
> refault_anon: 1580980
>
> *** Executing round 2 ***
> set swappiness to 70
>
> real 1m51.603s
> user 25m33.600s
> sys 4m21.738s
> pswpin: 1786413
> pswpout: 5350804
> pgpgin: 8833652
> pgpgout: 21715596
> swpout_zero: 1230981
> swpin_zero: 21051
> refault_file: 313099
> refault_anon: 1807417
>
> *** Executing round 3 ***
> set swappiness to 105
>
> real 1m50.315s
> user 25m40.863s
> sys 4m12.446s
> pswpin: 1555289
> pswpout: 4911737
> pgpgin: 7597548
> pgpgout: 19956948
> swpout_zero: 1125969
> swpin_zero: 17594
> refault_file: 237475
> refault_anon: 1572835
>
> *** Executing round 4 ***
> set swappiness to 140
>
> real 1m50.992s
> user 25m34.774s
> sys 4m14.068s
> pswpin: 1642575
> pswpout: 5027730
> pgpgin: 7937214
> pgpgout: 20426400
> swpout_zero: 1155712
> swpin_zero: 20248
> refault_file: 215237
> refault_anon: 1662775
>
> *** Executing round 5 ***
> set swappiness to 175
>
> real 1m50.207s
> user 25m38.244s
> sys 4m7.655s
> pswpin: 1522633
> pswpout: 4788104
> pgpgin: 7307172
> pgpgout: 19464984
> swpout_zero: 1109281
> swpin_zero: 18085
> refault_file: 186203
> refault_anon: 1540669

Hmm, but reading the result you just posted, isn't swappiness actually
working as expected? Here is the data you just posted:

swappiness:  35 refault_file/anon: 515292 1580980
swappiness:  70 refault_file/anon: 313099 1807417
swappiness: 150 refault_file/anon: 237475 1572835
swappiness: 140 refault_file/anon: 215237 1662775
swappiness: 175 refault_file/anon: 186203 1540669

Higher swappiness we have, lower file refault we have.

> My bisect shows that the commit causing the swappiness issue is:
>
> [PATCH v6 05/14] mm/mglru: scan and count the exact number of folios
>
> Before that, swappiness behaves as expected, and there is
> also less swap-out/in activity(and much shorter sys time).
>
> *** Executing round 1 ***
> set swappiness to 35
>
> real 1m49.406s
> user 25m28.458s
> sys 3m41.098s
> pswpin: 984605
> pswpout: 3329809
> pgpgin: 5985696
> pgpgout: 13648560
> swpout_zero: 780136
> swpin_zero: 11379
> refault_file: 367629
> refault_anon: 995982
>
> *** Executing round 2 ***
> set swappiness to 70
>
> real 1m48.577s
> user 25m34.994s
> sys 3m42.694s
> pswpin: 985650
> pswpout: 3450097
> pgpgin: 5468828
> pgpgout: 14116020
> swpout_zero: 820143
> swpin_zero: 11808
> refault_file: 245353
> refault_anon: 997410
>
> *** Executing round 3 ***
> set swappiness to 105
>
> real 1m49.262s
> user 25m34.871s
> sys 3m41.633s
> pswpin: 998178
> pswpout: 3553741
> pgpgin: 5328896
> pgpgout: 14535068
> swpout_zero: 840706
> swpin_zero: 10393
> refault_file: 205514
> refault_anon: 1008525
>
> *** Executing round 4 ***
> set swappiness to 140
>
> real 1m49.417s
> user 25m35.395s
> sys 3m47.169s
> pswpin: 1138043
> pswpout: 3756034
> pgpgin: 5807584
> pgpgout: 15345816
> swpout_zero: 884539
> swpin_zero: 12652
> refault_file: 185767
> refault_anon: 1150649
>
> *** Executing round 5 ***
> set swappiness to 175
>
> real 1m49.654s
> user 25m35.244s
> sys 3m53.330s
> pswpin: 1235427
> pswpout: 4058085
> pgpgin: 6108792
> pgpgout: 16547764
> swpout_zero: 974086
> swpin_zero: 14280
> refault_file: 170452
> refault_anon: 1249705
>
> It=E2=80=99s too late today; I=E2=80=99ll continue debugging tomorrow.

Checking the data you just posted before that commit:
swappiness:  35 refault_file/anon: 367629 995982
swappiness:  70 refault_file/anon: 245353 997410
swappiness: 105 refault_file/anon: 205514 1008525
swappiness: 140 refault_file/anon: 185767 1150649
swappiness: 175 refault_file/anon: 170452 1249705

And after that commit is:
swappiness:  35 refault_file/anon: 515292 1580980
swappiness:  70 refault_file/anon: 313099 1807417
swappiness: 150 refault_file/anon: 237475 1572835
swappiness: 140 refault_file/anon: 215237 1662775
swappiness: 175 refault_file/anon: 186203 1540669

So I think the problem is not swappiness, but there are more anon
refaults after that commit.

Before:
pswpin: 998178
pswpout: 3553741
pgpgin: 5328896
pgpgout: 14535068

After:
pswpin: 1555289
pswpout: 4911737
pgpgin: 7597548
pgpgout: 19956948

I just ran a matrix of for kernels (mainline, mm-new HEAD, before this
series, after this series) X 3 different memcg configs (-j96 3G, -j48
2G, -j24 1G), and none of these showed any regression but all
improvement. That's really odd.

One possibility is that I removed the:

if (evictable_min_seq(lrugen->min_seq, swappiness) + MIN_NR_GENS >
lrugen->max_seq)
    scanned =3D 0;

Which will make the reclaim loop go further and trigger aging.
Previously if reclaim drained the LRU's cold gens, it may go reclaim
slab instead. So idle inodes will be dropped with the mapping and
reclaim more file, and we won't see any refault data from that since
the mapping itself is gone. Sys will be lower too, as IO isn't counted
as sys. Checking your data, despite sys is higher, real is acutually
lower, which matches my guess.

Will the following patch help? I'm not sure if this is the problem,
but this added back that early abort, personally I don't think this
really makes much sense as it's more like a workaround for other
issues, but if that helps we might better keep it.

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 30a89224117b..c1e7c65ff3b9 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4837,6 +4837,7 @@ static int evict_folios(unsigned long
nr_to_scan, struct lruvec *lruvec,
        int scanned, reclaimed;
        int isolated =3D 0, type, type_scanned;
        bool skip_retry =3D false;
+       struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
        struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
        struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);

@@ -4852,6 +4853,10 @@ static int evict_folios(unsigned long
nr_to_scan, struct lruvec *lruvec,
        if (scanned)
                try_to_inc_min_seq(lruvec, swappiness);

+       /* Out of cold folios, return 0 to abort early and also
trigger shrinkers beside LRU */
+       if (evictable_min_seq(lrugen->min_seq, swappiness) +
MIN_NR_GENS > lrugen->max_seq)
+               scanned =3D 0;
+
        lruvec_unlock_irq(lruvec);

        if (list_empty(&list))

And this could cause early OOM, we have observed that for several
times due to the early return. So maybe we better check sc->priority
too, or move this to should_abort_scan?

Or perhaps we should just restore the behavior of never running aging
at DEF_PRIOTIY, which seems better and safer like below:

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 30a89224117b..2080522ea924 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4917,14 +4917,14 @@ static bool should_run_aging(struct lruvec
*lruvec, unsigned long max_seq,
 {
        DEFINE_MIN_SEQ(lruvec);

-       /* have to run aging, since eviction is not possible anymore */
-       if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq)
-               return true;
-
        /* try to avoid aging, do gentle reclaim at the default priority */
        if (sc->priority =3D=3D DEF_PRIORITY)
                return false;

+       /* have to run aging, since eviction is not possible anymore */
+       if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq)
+               return true;
+
        /* better to run aging even though eviction is still possible */
        return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS =3D=3D =
max_seq;
 }

I'll keep testing with more FS and setup. What FS are you using? This
might be related to FS side reclaim as well if it's caused by shrinker
balance.

> [...]
> > Since you mentioned it's mm-new vs mainline, and you have reverted
> > part of this series and the problem is still there. Could it be
> > related to something else in mm-new? I'll keep testing more stress and
> > workload to dig deeper too. Or maybe the swappiness behavior just
> > changed slightly, some it may perform better or worse depending on
> > timing and workload? Swappiness on MGLRU currently only works as a
> > factor for calculating the refault and reclaim balance of anon / file
> > so it may behave a bit unpredictable. There isn't a proportional
> > calculation like active / inactive LRU. That's a problem too, and we
> > might fix that later.
>
> read_ctrl_pos() should also bias towards swappiness, as
> both sp and pv gains are affected by it. Yes, we need to
> fix the swappiness for mglru.

Yes, read_ctrl_pos is the helper for calculating the refault and
reclaim balance that I was talking about.

