Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D9AEC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 12:20:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F7AA6B0092; Thu, 10 Sep 2026 08:20:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A9126B0099; Thu, 10 Sep 2026 08:20:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 199AC6B009B; Thu, 10 Sep 2026 08:20:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E28C56B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:20:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 703CB1204D5
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:20:13 +0000 (UTC)
X-FDA: 85197759906.22.4444FD5
Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7E77E180006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:20:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UoACehFY;
	spf=pass (imf16.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789042811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GKU0/FHl5mVBML4DoWOvt4O7S2tAPpMpMuGdOEW4TZ0=;
	b=oOXmJnhcKP8kUvU5FNGxu2WK/qhb0vZpmcmk/6XQ/yrKy9xhh4fyzkyAs84oaQM6lS4UVR
	NKWEh1AbA9YqENR3eoG+i33E4RnLx/9rDu2YQPqg2muzZBz2USOSRQpWWBSKJ9lKQOXprO
	j5m5cK6auoEvpR7U8aVXt8mW7tJfPUk=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UoACehFY;
	spf=pass (imf16.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789042811;
	b=SqlyhFz6CjBNvvJCZFglYzklI+tHirHUcVf0MQiDzpv6YTwApLPjN5xeTaz2KmZmfpVptE
	gMVZB77CFJwYVaEW7YgF45oQe5WIcO6YopPzuPndui+sqYezSPmWvEKcu9jJZjBjQsqQMs
	kB64xtwUrTvTjGGEbYrOg5BuD6EPEVk=
Received: by mail-yx2-f12.google.com with SMTP id 956f58d0204a3-67109935888so1214271d50.3
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 05:20:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789042811; cv=none;
        d=google.com; s=arc-20260327;
        b=CTeO5Ymrp5x3cYhUddnxdFZVbj8FTnGoxTYa5YGLVKGPqcfmfy5bq4yiV4fXipX7h9
         Ykz6Uqi/Bua/HHuGHM7XcXvNsYiV59CitM5jbGyYu0CurzXC1lnofBh5fHq6tWflkPie
         h8XlEcKbvKZFMRKV36BF3YDldS1KxgNb/qx5NXs3Hloyu9a5fFr4/YaAccEYm94rVWbR
         ANCJfT5dJmH960daBMAl92Wi/J4ipVdr4NuwQ8kGOsOcO8hhgY8E0Vbp6a8XKpMHMqA0
         xyaJg63DERp9YgMUqYaKp8BDh/RWdtnxLxFPSAEMYtbIM49Ja3VtOjwVPzwrm5ZWW2h0
         FIsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GKU0/FHl5mVBML4DoWOvt4O7S2tAPpMpMuGdOEW4TZ0=;
        fh=IoRx9Iy3FbpwJ3ixORSmqwHPR3gq7TVzeRfrF1tIwC4=;
        b=ZrsRSrMIaMnWbSdyK/Ujf/KdY/NwgFUG09hkisK2I6XVuhucY9RJSbSCVHyEEVRKie
         ALM8e/0gxnh58FTrjQ8+6HxWMxLxjnLHpTrsKE+Md5tkFlFYT4tLS9XmeEgrcBlHmKA6
         KtPVDAguGcAY1KkdM8+QUOpbbHPETM4AxS4nNUFAd1cIbNKPAWl7Be7NTEJ1njXhNVUL
         7FsD8pfBiBe+5dVRVK+UhG7Rs4ZHE52KxVoNm5KM0jx3fo/dfNyTRzaZgI1CzzNUeA8Q
         +/kjknfT+AXgAYWb61dRyfkkR8mX9fe8a6U6k83fFpqk5qc95SWNILjjebk+PR+HVssk
         z0ug==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789042810; x=1789647610; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GKU0/FHl5mVBML4DoWOvt4O7S2tAPpMpMuGdOEW4TZ0=;
        b=UoACehFYgDCdFunSy14QDVnyf7LFO72pslhLY3xQqutxTYp76h6ZmP/tUiClQnLvo1
         UAvWh3bzf78gx4bjxmoAlUqndSU3taD1xvdoeFO30BMbekk5eeMkhUXPiyhT3afFzCBL
         +YX/Vff0f8kwxQPxgOLubF5VKCwHvsNoIZR2XM/vasxwRxrqu1uKHHVruLJvGjhuk98i
         Med02RBZkzu/2nbewmRm8t1yS/bbIKcS7qEIkvPd4vvxiGGyNzE5beu84RwXnjiN9BRi
         hvzkAeie3q5bqHJSTFuuDIJOCzSn5KlSq84OGunSHalqzSawrCbmf9boHTrmJM4rQ8FC
         xCnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789042810; x=1789647610;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GKU0/FHl5mVBML4DoWOvt4O7S2tAPpMpMuGdOEW4TZ0=;
        b=EUNgx9RmVLjy+RXchqcJLrVT0EXN3Ig7RD+LnSmHMN9nG50p0vsxN/B8zVVM18zg31
         Wubc6zR9i7uwkiTd5O3hhRPXW+uDFUnHU9wrlY/TQYHIoMBSLE4R3Y48Qa0njvxyaoQH
         rlOnpXxuaTViA1ebCDiy7sW89lUkA+sxFkbtkC0VuomNFNFO5VYLMD/Y1YDVNqlIzKUr
         Gh/WnHma/8IpNbLAf97smhZyYfRaV8XnDSPzFBYc8NNeYJD6hsY+avyAdhXOylcPXitI
         cMMuYzzVw9LCdtEVh68G+FiOpI22CsIKWMCejqiPbWfYB1QZR0w6vx8tUl+kl2WjN8qE
         zqkg==
X-Forwarded-Encrypted: i=1; AKwUvBxoYX29/+TD5o2IAJFo+Cl+palqsSb6vvmPayRPe/53fr3JkeBStWk04kYWpLcQwmPaYhVApYv9eA==@kvack.org
X-Gm-Message-State: AFuF++nFvGMC75Dc2EDcB7TL7L7pMGduP65Wa12UvSYmLLFuOtytAgay
	a6JZY6kpssCV1ZsSHUB/aK+mXWrIzLJ0yO+DUvNgXi8t7WbqLF0nyyIeOUiQB7mV703isVbt29P
	i0HzZzGoKD8+WWfRO90RZV49XQX9yVOrT7x8e
X-Gm-Gg: AYBFou3Wvt/36gBlhuVeR0pfbfGT0p1fjW7tvubTZVwWt4X1Mj8zxQq7owvRfPImrz7
	fGkREsU2vnUFm7gIFburrPG+MRCfGA0JwmuPIWEHxn2ik2Cw8ZZK8eHJgdV2DlYpg5FceeK6Exx
	k490k+UH94f1DqLo/Q8Tpjq9Xp33vya3NT225QVd73yDsgGVX2IYA1G0Qaft3ayoOmeD8Mh+yFd
	rvBM5xekTIh1SGAZ2ABr5ZYFlGdboko1z1poCLJOszoUEoRkTiVTjeb3cZUMQmMjnOQEidEqxl1
	x4Bsl3/zayPoxtcHAIyw95KQNiKClgOpg733Nv/RYEOs6TpkyJo+
X-Received: by 2002:a05:690e:191a:b0:66d:1131:b81d with SMTP id
 956f58d0204a3-67110077035mr2833039d50.29.1789042810592; Thu, 10 Sep 2026
 05:20:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260908165733.1703766-1-ekffu200098@gmail.com>
 <178903430147.1489479.2162515570306846533.b4-ty@b4> <178903518466.2710705.16546329711992780120.b4-reply@b4>
In-Reply-To: <178903518466.2710705.16546329711992780120.b4-reply@b4>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Thu, 10 Sep 2026 21:19:58 +0900
X-Gm-Features: AcwNN1Wu7PyYvEPu5hr5ApiS0PQHDrnjYJ8G2Tvos7aVIx5OZlbNC3HXwvOxm3Q
Message-ID: <CABFDxMEAkqGhXc93crUKjP9bKs2xh1gb0Nt32jzC08qSADJjRQ@mail.gmail.com>
Subject: Re: [PATCH] memblock: use for_each_zone() in reset_all_zones_managed_pages()
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7E77E180006
X-Stat-Signature: oic9pwrr8ue83dr38bg5agcc77ibzsb7
X-Rspam-User: 
X-HE-Tag: 1789042811-900729
X-HE-Meta: U2FsdGVkX1/ViiLEmd4j7iswaTnPY8U8ZJzXdxyIXmE4K0JeVicv4S536mieS2gLIRYv36zAs63yg0S9Ept4cKNQWmFddlkEhvmns4JI5EDtCuemc8IMm4SJF6bJFxqn8EFbj00qnAcXVxyYbgY+ejh9zW7/Wduyiej9cYiVn/ceLDeulXo7/UxRndknpaJh4af5dYFeCV9zxvBNBHkLPaQMGZmKJSnpf0h0unL40HSSpaMi/1JjypjGL5UXLWjcGt2EvlSh1utgpOsJq/wdVxSLRAvY+O0wAtpBS9ZTmk2fiaDdek96/tsqyFDdNunRxBj4CaCxjuv4FQcVuuXrO878rDZ+ZQJZLqDtjaTHq4nYFi4aNngtk8Hl3jCOxL3jhjdLxkDZyEy2ORX//XKC6/afeuvwu2CkhqTURag9dKjDRCDAX9JeaRGzcP1pzD6GVR5QN4xMCDpyvqtYe/OAEHXE5qzWlz4Ge/EGXua9i2R1TsFv4MBOf5phCz58tSh8NmDLzIbbhV4XhDoUbUkapRPgqYqpiDk58C/8tWOH62Le+S7dobarMSCcXAeDGwyuYn17s0bAVJ8jfnW4dd2Anp4J5eWBoPsz6bgPJl59j8L4rzIyzePJAjHc/IT/AqSkjSA1pHfGWpPY3HQnFgcqpRJWE3YI23VivkZZgRC64WNudGnC4JWMk+2wLY1MTln6S4slVS1LayCULH5IDYSOaneO96V96rDqd/YJbm3dD22ECboxtInRnMqQ2t7WYsbTXLKVcPTVQwmLxRAjRydplUvElY/UYMc8sY/U9a/ty6ZxTD6PZqVJWRweJ4MDq1UHAeqwo1wuDAAomROiS8bDvwvVfDAG59mdyw9eiHvi7FZbXFC0OuvvlRfV6ajA3tJ5HzRzlyimuam//YYBWKDS2zJE2gg4NU124vloKPsRTRbqulse7EQpoYzXDf4FP4HOaF6K1WrdC/m+egIJMkI
 8z3OzduI
 uW4o0rlXYHbCnJ99kK33IbAIuE+nn4TTiVWP7JDaVN41qRVfzITg1BesvNBa90d1chTV82n0FGV8fS7bsd6eLX/RAwwOSucysVJuCwsrf3kJAZz9NH5Iqp/ATFZoiRxQZ2t0xeMyYLomQ7nKR2ZS9Ui3lVnCvQm+Kart3056CCVoEcDgOQsDTu57RiUmzpl3ENKsKPWE3wORQ9dujG+FfDT+OJ7repHQQA7iS468ir305iTc9AObJOhXVs/ba6rJE1iBTjeGCceLk6ImeJWbQqEFyCZTent95ocrbmYzq5PtzY0/2qYU/EqVMpX9AmPsha0JYOpCMd703jdtFP7Vyzp9c02lL7OnzamnHcO/3VILx9tgyytzuU5jTYriEFagRWospr3nbPhRP2d2iogkPCOtbC4HNn+ojPhsfbVCVHiFBLmDdOA7+graLqhnLpvhsyWy5Oq++HvgrVDsPr4D4g8MUYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 7:13=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On 2026-09-10 12:58 +0300, Mike Rapoport wrote:
> > On Wed, 09 Sep 2026 01:57:32 +0900, Sang-Heon Jeon wrote:
> > > memblock: use for_each_zone() in reset_all_zones_managed_pages()
> >
> > Applied to for-next branch of memblock.git tree, thanks!
> >
> > [1/1] memblock: use for_each_zone() in reset_all_zones_managed_pages()
> >       commit: 0876b2d8794913c867a1bb0dc3fd22ea1c5f0a95
> >
> > tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
> > branch: for-next
>
> Hmm, I was too hasty.
> This breaks mmemblock tests, so I dropped it for now.

Sorry for the noise. I missed it. I will keep it in mind next time.
Just give me a second to check.

> > --
> > Sincerely yours,
> > Mike.
> >
> >
> >
> >
> >
>
>

Best regards
Sang-Heon Jeon

