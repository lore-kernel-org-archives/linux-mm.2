Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBDF1C43602
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 16:03:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B6566B0005; Wed,  8 Jul 2026 12:03:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7672E6B0088; Wed,  8 Jul 2026 12:03:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6570A6B008C; Wed,  8 Jul 2026 12:03:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3630A6B0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 12:03:35 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 962821401F6
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 16:03:34 +0000 (UTC)
X-FDA: 84966079548.25.C8A4049
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9AD4440004
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 16:03:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uac0fSBJ;
	spf=pass (imf01.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783526612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A9k15NC2tu6GIqgaUNafNWbmC+Zeria+kWA/766+euo=;
	b=qr6fXTqMxIXt/1LWnVhwJqIwliuZTgyR6OvulpAC0YgzhllfvzeTsWkouHVxTnI9DVLFZZ
	5p2qOv7VmJPhLspBrU5EozMl+IjpnUWyPhUw7t4H7XHHuTaTvo3dZeb2bySscGKo283Kyk
	tCdttBTaaiNU/4ZeX52D2qJQ7Hj1Xyo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783526612;
	b=GeX2/bEaic2I4YiPQbv/l4OaNHcT2+h3/pHGFufl0Kzmy3IPwksbHUfGPVt1EwhD6SBdvY
	9VYPYoUUx4/+aCwZJEaLSKoRdUkhTaHr6K9Lkbl6UfU5eZ0daTiNuia2iNBBX5X5El1N6t
	nzYMdtyNnD2rVDQQqA3irCrZkuVqj/M=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uac0fSBJ;
	spf=pass (imf01.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-493be0fbcc5so67785e9.0
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 09:03:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783526611; cv=none;
        d=google.com; s=arc-20260327;
        b=KqyZOrIdfkfrTwFKq98TwHIjRL4KIyLFf1m+UxJrgNC7AnENkNLgw3glukb7ujUyaA
         p0pnMWgsBewwwdRcQJZwouIK4j5V+oBW+I490oUtCb9SA7G4d0EaWgzziyk4ypxoZDkx
         bLRctvf055RqvpnZzrLMlhXewKTMupBM0Cm7phZx9VNBReYC4DDCdbQn0xRK3e1tXsaF
         f322STlacwDGPwytlIMW80/yQxMcmx/58clWYv86NGoj8nRmTFun5ss+q/CmzWzaNYXq
         f/xdPEghT3wS9XX5f+T7o/7NuYsdu7TMl8lxyt/O3u0AIKM2LKDl4y8qECT6Y2nFfHTM
         cDrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=A9k15NC2tu6GIqgaUNafNWbmC+Zeria+kWA/766+euo=;
        fh=3puZ8cTtEIMg3yW2n6re0yrS5TzRqZzccVCBus3K8+w=;
        b=i5SmZd301yg6NiVgfvMOYLFj5CguZFgfd7V0lvPH4CW/ha8R9oAuen2nsXbJ6wc286
         ZnmdRWN9puMQao76OP17IygC4c+eBgNH+LivrWh4nHJApsF5Su5neEN2FTsflpUXg+z7
         j7R4jt82I4tvybvdNTJNfE5hgt95v8FObg3cietfBMbJnjwKeJKi8PNX6DcRkCPN4Twi
         u9dCzt9ieQkJ6198YdXSe3Kd5PAEmojLajs9KjYMHoswCa6ZIcrDr0x3HPiXeq1OqXKm
         bC0hgU3CT6HvpMHCuY5gAtZacZsaX6OIB/OTyxGSpf6DsJM/q/K4gE1c1WvN464JDBSZ
         /BYg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783526611; x=1784131411; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=A9k15NC2tu6GIqgaUNafNWbmC+Zeria+kWA/766+euo=;
        b=uac0fSBJPccAUXUqQ2TpIWUYOWiIr4qNS632ymYjAKIVHHsBbhDGdkXShJL32uIUfH
         jU4KI2HNRLIht5zAlThN4M3IC2hemSxyacS5HXOngDz6Knub4z4YOfgHHIe/cv0huODw
         Ek9oan85birYZo58pDzs38ii8pSCbb7pwcwDJuDoLm8CYodNiwzxLBtmVnJqp3B2UdgY
         O2RE4RcLrwuV3w2r9zJ7qCjVZDRccuUjL/UYjWfkLvAXBUJINBvdsRzul6Hgtq9adccb
         jnr70ANHsTMgibUAEJ11gnuvdlRkLxTkkZr8ZdAyEJl5JXd+CUfB7Hgl8HZ8YBayGZjW
         N53w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783526611; x=1784131411;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A9k15NC2tu6GIqgaUNafNWbmC+Zeria+kWA/766+euo=;
        b=I7xdOtGQcAS/wORVfPdj3nca+Ba6Qq8y7YXLsIZDueFnU7KWaa7xXldPlxy4JSjwa3
         r/+aMmSBkrUSYDqeCrphPA8q6MOtnP4Iozj1eTSGrX+4PnorNjU9f9Gprke9sU9zYO5R
         OYnGB8ehCgD5ONT5b7mllV04uLf0QllGwQQkUCDykBBV0/+/Kwu8T7WCrNnR3y1SH578
         mQVAqnwR/6dRYKamFnzKK1Gyn0jUIqWwza+XeRQ+oN4eNi12TW3uUPz/ch+QjsUI41NS
         jsan0yrLW0TnVz/hPQP8B2lin2/WK4UP3Dt0OBvVtGDFgU5pmRwhzGpBSyLgX2mucfiI
         nEGA==
X-Forwarded-Encrypted: i=1; AHgh+RrRU5VRR5YqqHXdmt8DLizQwfA0lXIsxNyAeCGO077vwBYoR9QHWFBC0igz+DJsr7Fn5BEB9rmsMw==@kvack.org
X-Gm-Message-State: AOJu0Yy4ETHuDHEE5q6FLaOklkzjh9yjxDdYrM653JZsRXAzyUi7tuoa
	+CYFNZUBOtro5GmupNNE9/Jj/MvYh8RMZGucZiWAQKmfDEPmUGfRYGzNfLlpWVwQXX6j6bm45iH
	jRHDH/eacfKoYLXzK2EhF0nXMD9/atsj9Fw7FcZDX
X-Gm-Gg: AfdE7cmL6FDrGOLcuGFwMpt81pdOMGeLvV5Snj2gTPQGTzF2U9UWwt9F2n7t5PsbL46
	zFDv8+qSvGHmo5h0+wJdyTBMzmDcii2NEWb49swrw15QJ8nlIvqy2F/hSOO/8k5yQ2rd8s1bulF
	+pUd5c1LGz9nZIFzk4IzmqvAhMYRd3yoiDsImf9oD8zVhb3Il/ON9sg5gb/kxFfNr0wk0GhTXTD
	zavxO+9mkjsJYiJPxxNVGN23KzUWFktJyKOJDQBEJgjBG0ZY7hoNhD2FcZszFhHgVgmHo1JXW0F
	xIhBp8Rm/N+OwHi9BUiLYaM7uqgrDjqRCmFauG9mu0Wl/Uw9k0RKdrWWKyK/9POqcQ+j
X-Received: by 2002:a05:600c:1c0d:b0:492:203f:a378 with SMTP id
 5b1f17b1804b1-493e121b8cemr1125155e9.8.1783526610773; Wed, 08 Jul 2026
 09:03:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260706081218.3438762-1-richardycc@google.com>
 <ak1XzPxbwBF72d1m@linux.dev> <CALC_0q9=KNnkQBE_7gC60jZ2Akj9jgL+VaDMFd7yGvqyfTJbYw@mail.gmail.com>
 <ak3Xtrtm5iVayEx7@linux.dev> <CALC_0q-juSkv=iqG7mAGCuGqbdCtjEHEy6oD1pcxQkFdBMJHWg@mail.gmail.com>
 <ak5wxwj8cID-QQCF@linux.dev>
In-Reply-To: <ak5wxwj8cID-QQCF@linux.dev>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Wed, 8 Jul 2026 09:03:17 -0700
X-Gm-Features: AVVi8CeKwW_bIq12eer8jqRPGlfjRD0YcQhmUYS4ZpC1uymCZabPMvvX7Vk_-Do
Message-ID: <CABdmKX2C-XPN7Z3G7joSHUxhzEmp5dgNf_oA_ojQ_coM_CmvPQ@mail.gmail.com>
Subject: Re: [PATCH] mm: vmscan: abort proactive reclaim early when freezing
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Richard Chang <richardycc@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Martin Liu <liumartin@google.com>, 
	Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9AD4440004
X-Stat-Signature: 19z6oqj3axi8bpqsaafntg59unbw4ad7
X-HE-Tag: 1783526612-848816
X-HE-Meta: U2FsdGVkX18FoBj7/bXpZJuOfOlgzFDz3lqTQ37kQKmFDBoXUtg6+kOKUzpJriWiutJU34xeQZxc09XdRP7nnHIq8F5ClluAXi1uWXN10Tm+kVGFIszIWDXjeLQI/HsyXQvkMtNulQ/hoHtT2eNFwjuMd0H7MP9KN/kaWlXCq6L3hzwE6F5vQBSfsJUQPci8teYUh+OhogHkgpoRG8f08MW39jJ7RdGWAnTU/PXLTz5YsPJSN0MuOZAWZIBF7O4A8aV4aWPn/dAry2pOHn96PMA3P0Q2eQDbVJHRJ21uZhwQR93wCG7SNaJMN8YSrVdsHKsGKK5+1WfUFQMoVxnMIwDMI+8967GfbK8LyWouGKJDo4MPRRZOcPCPkCFIGO6P8Q1RYxkSzl8NbXT23aA/yE8iHHhueI2e1uJWOR7QxGv95qfQZj7i3oVR6ir1ov3Kakw/5fm0GbxIF82W48Hb+nK499oSLP0UeEkQSN24qDqaizLtobJtDTWjL1cal7FaWG3H/0nsmgjZ31kkBNCjbuO+PYJky0T5Vudqhx5nbXbp+FYrK8oiqGZR0KZjHTVs1TcAEWb7pysU0W6EA/XuRSP7Z1x5vBgH534dtZscRC12RtAvwBWzQ331MJQkEb2q26D6kIHP33m1bsJ81WQg8lKqsTplI++vHpD1kaOlVS6UNQ3Z4S5eCWYZkQ1vra48NBxlwm/EOR5RnxyQHGFgn/rory26dFxpZYGgXOAZUG/yg1NT9wgaUIMy2h+dJmVmG2vL5GZ/8Tkk50NQs5BhaYerL9ijX/PEQ7xBn3v3P7CHZ1mar013bw78/ztJ7jEcIFrTXB23WmVVZnvAynkgA9Kr/pDIeQSVyBPVtR9qmhLdgJbqbXEx1fX7ewoB3rNZUBLvX4+KuTmVXgIpfzMdH39gZC80GTEhykzhxBpfEbYgNA5grkfZha1iVntkdo8bKxjSIhlsOFkqPIIe0Wx
 Hd0j0H3V
 bcEqDdpnMGQ4W+UJQc6S7GYOIzNqSz9G+i03kQrf6lVJ9sJvLyRjlaICGVGI1T71WFCw8ZM6KmyGN6SWFL8bwlGtBldd4YE37rv1IVvUIJYj+9GzwFBv+1cuEkI/gb0F+ezeUbvkc3Zq0A8a49tyk5AGGr3N0ChNDG1y93nhaSTl35YuIjN6yosmUkh17X3RB2kYimdAPxua8aSeBMTWxKBWMja9O78DCU/Uw4Ta0WLqf//3KwOkSR83VPITM621aC1tsNPdOOCq/B55JR6pwFjTcksmpJJdFFn+c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 8, 2026 at 8:48=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.dev=
> wrote:
>
> On Wed, Jul 08, 2026 at 03:24:15PM +0800, Richard Chang wrote:
> > On Wed, Jul 8, 2026 at 12:54=E2=80=AFPM Shakeel Butt <shakeel.butt@linu=
x.dev> wrote:
> > >
> > > What's so special about proactive reclaim? Why the same situation can=
 not happen
> > > for global or memcg reclaim?
> > >
> >
> > The target batch size of the global/memcg reclaim is typically very
> > small -- usually SWAP_CLUSTER_MAX (32 pages), allowing the task to
> > yield or check signals between attempts.
> > Furthermore, kswapd is a kernel thread designed to be freezable, it
> > explicitly checks kthread_freezable_should_stop() in the main loop.
> > In contrast, the target batch size in proactive reclaim is
> > user-defined and can be extremely large. Without signal checks in the
> > inner loops, the task may continue scanning and evicting pages for
> > seconds at a time.
>
> Why can't the proactive reclaim use the same batch size as memcg and glob=
al
> reclaim?

Because it is very slow:
https://lore.kernel.org/all/20240202233855.1236422-1-tjmercier@google.com/

