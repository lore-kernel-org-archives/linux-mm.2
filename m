Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A340CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 21:21:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DBFD6B0005; Wed, 13 May 2026 17:21:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68C866B0088; Wed, 13 May 2026 17:21:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57BB26B008A; Wed, 13 May 2026 17:21:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 45B616B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 17:21:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F38B61603E8
	for <linux-mm@kvack.org>; Wed, 13 May 2026 21:21:55 +0000 (UTC)
X-FDA: 84763668990.01.8F7D5CD
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf30.hostedemail.com (Postfix) with ESMTP id F08DC80005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 21:21:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pvz1OTf7;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778707314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2LiBJ0GST8n1XIAy51r++M8mb131NJHPjLOoQNAGYF8=;
	b=gnZK7XiWcD4/WmSpGIGWuFgXMzJ2v2F+I6//g0THbZ7kLMx5DoLiDiXEEgcGlwTJN/MJV+
	kjqDR/Yc4Px36T+PK0ZcOcQHqBDDIWLgWd1AMdRwH7kX4u8/oEVNhYkE+lET7DvhHjcdvJ
	T9tBO6rj5U6Qr0ki230qjjKhZluge6Y=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778707314; a=rsa-sha256;
	cv=pass;
	b=j73rjoAfs3PD/3Xhy//SbR9HVV5slXVjwoaG/js1JHy1xcuEljuSVdp2VwVeyzwAxXCtcn
	9+PcSafWJyt1o2n/fVugV5ITD+AozHiRYZvkaW8rLOkgnlyJn4xECP4uSy4VcbMLsx0LNa
	OwBN1qOmVdukPx9ZtsFGggoQU8e/Uko=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pvz1OTf7;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-48e82c23840so34770545e9.3
        for <linux-mm@kvack.org>; Wed, 13 May 2026 14:21:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778707312; cv=none;
        d=google.com; s=arc-20240605;
        b=T2kEYWhmdGT9dD6H5glmrPsm7BLHBW2iagj+8tDvQBxYELgL8GtN8zlkyNm48Dq22V
         GL9kGabTPxhypr7bjI775QkzfVtKE9ez5KM22sW11LRoTCdewB52q83Kwirgl66QbPSv
         YI4Psq0G6booGceTI7kZh0lwnSz2JuvtzQBHsoyTZYgjzBL/BmD04DIX3tDUATCIzPv4
         VZUdL0oRORBcocWvEWNgyk8+BbLpS+6YgW5zVZ9n2SRXLAWHv2qM5TNaN2JnCX4uV1KU
         J3NGd4fF3SB5SIlnziE7uOGa2R5cY26gDaBoaUyxr/bzzM1Wxl7tR2siYs+ff7qq9Oyb
         HNtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2LiBJ0GST8n1XIAy51r++M8mb131NJHPjLOoQNAGYF8=;
        fh=X0cLCniVlDNhX7zT/1frvu+FiXE7QhhURsvpPvC4KBI=;
        b=BQq6QKvEA7YivLEWdrRDq4At4BYZStX1L3HiY4XKmfRYlO6mL47maEsXsGiWi2kOkL
         iUgk2GG0SMJRZgzr2zkLauG5qpsUMq+EX1pHZrQ7yYdfASQDtc4h3N8oNqjr/An1KYMc
         +XXd8UhnkNynvMNaXYsIzoIRgN6ieIVrEYauH/cxVsPlAtaYh9V1ZmIN3AWF/yS0RAuH
         QoC2K07aTdPPuwDcuecKrs8R8d5Tj9Z/9cwD6Zfw3AkNl4SPtC+/vdJR7wnaUFowIg7D
         gfHnHaXCY9iqxbw660xx779kwFyjQpYPuwPYPfyLlGPPTU0+eea2SF+clMV8Wfa0jMOg
         7bFw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778707312; x=1779312112; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2LiBJ0GST8n1XIAy51r++M8mb131NJHPjLOoQNAGYF8=;
        b=pvz1OTf7kRvypy9sbTSJ0qAHfBj9AnpexuEtIhQupx+kdvelOe6V8jLeEPi8sy4wNz
         Ur/WdZxgv6snTb2LP8dJ+pRz0Y/3k6wRG1aNW13sjPGszqD3xxb7Vw1JJf13UZlNTgux
         4FUB6WOghikUuqz2mpOdSDxIIBXUmDBGWB4RoqkwvRNYx2aaprz1W4YG0aYoh3IBxDSR
         j3GHmEEQGUFMXFPUWyeXseTR8pnU+/XZlZDwvh0Xl7Z/c51GvJwvxp+hKdtTsD+BgTz5
         T0OZ7Mc1y/n8Mj8/he2nM84dTads/QReniUfAJDkSY3BfJhSeTdedxgGts6rzlAGttGq
         RR4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778707312; x=1779312112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2LiBJ0GST8n1XIAy51r++M8mb131NJHPjLOoQNAGYF8=;
        b=aNKYd0Plmzey8V0+sHtMzFbAOhyIh6gvLjUfoUCfCfjX6fax0dGHZ9PgDDK7+fxo2C
         j8eRVuFCtPU+226XAu4rkcqhpjs0DlF8wGxRbj8CQzTQIuXPI2HOk5hB0QTDgZ5QVX0q
         7UAeAmEsFC7cgxBgac5FZFUGTYy8qcyAwaULzhirfA0f5+a1KHMZWOzwUWFVyqsxwd2/
         /b7hzxsJqRLSC8bWmnCOay5l78JRsSRg/mbrromrxAs6AvCKfGqXUVPqZEroPhXTUe6r
         fqdNCXOs8AUQOWsE58nRqLvfLeHfZRnP/0Vs2BYokXRaOgqDdKiCLaVacvzeM+CMrhIj
         7zBg==
X-Forwarded-Encrypted: i=1; AFNElJ/R/Es4+6Kf6ZQTvnE4QPmPdJSS+Z2XHRZfMmOpl0pNu1UO368KykxLWVgv5DHmustApo3dISuFoA==@kvack.org
X-Gm-Message-State: AOJu0YyBS8skUSN7vtySJ2ZFf7633AWx9uIyAxo2NcGcGn/CroB0FNHF
	gEFsplW6uPDtpbykDXKgFp1en0ftd9h2+swlv4R9Z/PscCEOSTtswN8fUsNHVGXR/trW+HMg+ro
	vvL2eQ/rlzituz8IYmnfmP3USwtu4gJk=
X-Gm-Gg: Acq92OH6YBvSIOAXZ6D8RnCJYCwY25FZnJTTpDSCgiOYw7lmI6dBzG23fDWf9YoIe3b
	mBBRFA/Z7yxCciar3Y4rGmLJDFjpMGbkVAm5NOSBkOv7njgruYCLzKXUrc+vRrWkvsvjP6RPhIm
	bqmyO0KWmLnaKmv6zklmFqgpQ+6WeVXbggdTxj3oXgb9wbvdTUvWpZqWJZ44HdDbDGdNajuGfmJ
	WxadtGe3LOz0v0wp2nXH4XPNcZDLVnXOMoGMPbH0N0oi2zol/pUyVaS14JP9ji1ev3soH6rndr/
	SzQKm7DoNjskqh0tBpHxvfi0CwUGaRY1F694DdU=
X-Received: by 2002:a05:600c:828d:b0:489:201c:dc46 with SMTP id
 5b1f17b1804b1-48fc9a0eda5mr74529125e9.12.1778707312397; Wed, 13 May 2026
 14:21:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260511105149.75584-1-jiahao.kernel@gmail.com> <20260511105149.75584-4-jiahao.kernel@gmail.com>
In-Reply-To: <20260511105149.75584-4-jiahao.kernel@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 13 May 2026 14:21:40 -0700
X-Gm-Features: AVHnY4LlrQC7Ry6VArRSJYRPvyqB23MBm6HpLrXk9Drx2Jq6lQCY_hsRAA8ZZgo
Message-ID: <CAKEwX=OigngmcNo1OU-apCFG2hebt5yZwXQxZQHqgC7SwH_HAQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm/zswap: Add per-memcg stat for proactive writeback
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, yosry@kernel.org, mkoutny@suse.com, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F08DC80005
X-Rspam-User: 
X-Stat-Signature: 7x5ff8kcfrowzp8zj11jr5dixdhfb6p4
X-HE-Tag: 1778707313-290100
X-HE-Meta: U2FsdGVkX1+5uxsZB2LTgB68D2lVxzvkasIWLJ7WCM34inB++M3+1iKxRzcBUtwsVZTyLU8zuSOhx5ratmLoQHfGHiNhEkzJM6YB8wcBk5EBzpYpOvShhdg4i1UAeEtL6xoCAJA9D0iUTZMRGwvJkzrzMwinKBJ53Bw3zKRm+bmA1iRlwEtl1gLb2bMqPf/uAEJHYgma3CY23bwI3o6EvMDzt3FJ5U4btMquCk6PiQWLzQmHA4fwefC1oi+3HjZEveRvYD2wljjQ/p3BBs4q+QUwIV3uCypYP9TmxeVr12V24Lo6tbJPcwBEZl/M32uss50GPqYkaAB5zKSsc/4nEMrWDQBSNjdvug7+rIybixd3SkrQ/8nh0rLPI1tkoGn+rKrMoA4iEL18lytVd19qK8bFIgkp3fbeVODp2qgcuEnMVT4qkuBhmuVwin1VlGL82yrKq6ydnJcQDkHh2JTH8Ux9eE3C6v+00X53qz65lfZtXGN+HMELHKQTSfSj6hTeH835P+Bd000Myv1EaoVQ3lmA7SfSfqnCCMPfJAwPpXZYQbiaexA5JxN8WjVM2Y9Oq3n0lr6EcWe0LAhaKLXrHDkv8IIPajIbdx8qW5z+OMLMYV8b1jED+3nzT5GT39504/7AbG+OF2P4VwE+RXLRJ1ltYm+eMjy6ECr3mwylhKaClSSDMH0YmwCnWA9Hnqygd/VBZdwBMalmLgiB1GtzvAtsN71swf5SfI3NaQgcMrr+1V6kbCVaFxfeZf3uzTlzMG72hsg0+v00KVAzgECEOwWyO6ykna1ABXC2P13rAyuu/byQqdJzuVRd0fHkUX6LlE05KB6772XKJTTIxPiVzTb5H/havh/Zmg4swTD/nuZC8tkpRuthpeitFx3BzAzQeDklO2E6j9TM6W2Tb2y63tkQP23MRT7PMvRU8odB6nc3lOxdvKBQm7Tgtr+EdIX+zglLV7CcU7XCvbzDbIw
 bflGTVY3
 e0nvTeRMaJaJ0GDrmHkmrcHOA3FkqIYfXDG/RFp0DxV5sy9s2nvPKqq3zEQ2Wm0OP9eStZ5WZ2Or9OYOO14c6qPJ7txlr2xL4Bu+5FOF/Msfa6RYL79a0fn09bdHFEWCcvaXh5GFEiNTpWuMPJUsHRIx3AMqvLyjGTiptxSAg0PxI6wZICFZSsY7k9wS0b+VpTxSRIAWyVK7e1xpiTkPBxyPDj3HDxadrDSMY5+6rG5+RFuDlqhgCYzTba/Dl4NscEqeGhXmK8t3ZJ9IPhojvvqR4v/lnfXtIweajjvnI5PMq1xlCuOtERQ/5IALoC6nkMySnbQH0r5ZNEbGyR7p/B/bS75VXDH6e2PJqt48r510Oh4XjTMyfM2+de8+w5YQ+RDy7ci+HSzRJqxG6jtMD81QRtud/o4nTrk3eedES0D4Z+A82Ms/bKQXYDZabloKsuMrW9fbbk5mMskn1qzG3iYQRvxN6uZelF5UcR8ee3y9aL+MHlf2SMnlD1jVXkzFHZzQPcLaaTfFnsymwcjpAaSvUnrdD9/8AEw+yRejyJMOEMdU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 3:52=E2=80=AFAM Hao Jia <jiahao.kernel@gmail.com> w=
rote:
>
> From: Hao Jia <jiahao1@lixiang.com>
>
> Currently, zswap writeback can be triggered by either the pool limit
> being hit or by the proactive writeback mechanism. However, the
> existing 'zswpwb' metric in memory.stat and /proc/vmstat counts all
> written back pages, making it difficult to distinguish between pages
> written back due to the pool limit and those written back proactively.
>
> Add a new statistic 'zswpwb_proactive' to memory.stat and /proc/vmstat.
> This counter tracks the number of pages written back due to proactive
> writeback. This allows users to better monitor and tune the proactive
> writeback mechanism.
>
> Signed-off-by: Hao Jia <jiahao1@lixiang.com>
> ---
>  Documentation/admin-guide/cgroup-v2.rst |  4 ++++
>  include/linux/vm_event_item.h           |  1 +
>  mm/memcontrol.c                         |  1 +
>  mm/vmstat.c                             |  1 +
>  mm/zswap.c                              | 11 +++++++++--
>  5 files changed, 16 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admi=
n-guide/cgroup-v2.rst
> index 05b664b3b3e8..29a189b18efc 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1734,6 +1734,10 @@ The following nested keys are defined.
>           zswpwb
>                 Number of pages written from zswap to swap.
>
> +         zswpwb_proactive
> +               Number of pages written from zswap to swap by proactive
> +               writeback. This is a subset of zswpwb.
> +
>           zswap_incomp
>                 Number of incompressible pages currently stored in zswap
>                 without compression. These pages could not be compressed =
to

nit: once we have reached consensus on an interface, can you add
documentation for the new knob in cgroup v2 doc and zswap doc too, and
how it interacts with the other interface (memory.zswap.writeback,
shrinker_enabled sysfs knob).

A kselftest would be very much appreciated too :)

