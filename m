Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43097606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 02:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=E1PXjego
Received: by kanga.kvack.org (Postfix)
	id 36A5E6B084F; Wed, 21 Oct 2026 22:55:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31B0C6B0859; Wed, 21 Oct 2026 22:55:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 230FA6B085A; Wed, 21 Oct 2026 22:55:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E3C526B084F
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:55:47 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 673501A070C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:55:47 +0000 (UTC)
X-FDA: 85348747134.06.ACE4AC8
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8BDD8C0002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:55:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=E1PXjego;
	spf=pass (imf28.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792637745;
	b=LhDMbC2osvGVrjaKmi/F6a4PBWP898IOt1phKeGikCXOPapfzNng14f1FITj/Wcs5CsIOO
	j25n+qSxjXOliDFgJeav1jCUBN2J+h8kzVGyaLy9iM4UFk4ZeNHEqMGBX2rBYPRK4L1l25
	vaNX57y9zHVwQxI4BC97cZ91b43Ae3o=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=E1PXjego;
	spf=pass (imf28.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792637745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cr4fF23yKRo0SqQXK8klVw/Syk8sr6hkGOQHdTp+MUU=;
	b=CfAKxUpJoWsr77pA1e9pmCuwqqBgwJMe0JAMduFdCWibINLraeSJnmTQMnB1vkgHvMoiV6
	tXW78IXAsxCuToLxO5PW2ePmuq196y3+zajdgSTDhjdOWuB70+yd6H6UoRCKLONB6CE+FX
	YxzoO0V2KpoqUYj/0NR0odhRukDThVU=
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-3645f0f3fcdso2403705eec.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792637744; x=1793242544; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Cr4fF23yKRo0SqQXK8klVw/Syk8sr6hkGOQHdTp+MUU=;
        b=E1PXjegoLVmhmQ/YgCwNW6EFWx87RdosqehV1QHTJ/yHabTdoNNPt/taVvn08U/blK
         SnDDbaBbVNHUsfsGIbzTJozGUSUTVrISBfrlT0UIk02xnR29U7vDNFdexJBMFo5cu3x3
         tFSg/cObSRRMiL9oIBDTy5JBlk6+zLd3SEQhw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792637744; x=1793242544;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Cr4fF23yKRo0SqQXK8klVw/Syk8sr6hkGOQHdTp+MUU=;
        b=GjYni9ZIxO89ggFufg9BhT7+95RBKXZzMqwbJzKSmqtYuHDRyWarhU7qb+h2nOVjaL
         rypc7oKmni+pAcc5hDURzW6QRg/TiRyd8dz52Z7sf2R+L5h888eDu3HdTV8uGzdn2GC6
         5CHvQxLtUocT1e6c9mUX+9oyvGyIM8NGCW2994FP9spY0UV8028EZpVnwujfZdxXeFhc
         BJ4B1V4oJ/7tzGkN3PO6DFw9+bNFOj8ZFvE8SbOON+CWeUg+xBXMjZpg4CKaF32hczcf
         60gKrL1dmDaTrVkhN4SDuCUu/1AqTx+H0q1YsSF9ukYCr9H7vOR2op9X2MPIzBKfaZFM
         CKbQ==
X-Forwarded-Encrypted: i=1; AKwUvBzVL2PkSXVq6myKovo2nG/EKDOAkr0R5lnCe6ZyVegjRqi3YHggYuY7IbZi4KGgAx4Zt24dVCkjoA==@kvack.org
X-Gm-Message-State: AFq9FYL4MeISZOo68RSuFjq0am9ozF2OdrR3WfVq8Pb1sWCKy6EB9Tfa
	rV+J1Z2H6tyJTx/VYu3z4kB2gllXUXwfvSCqoWCdJfLbxEhFuEgLs1AV5l+NY7SFTg==
X-Gm-Gg: AYBFou2y6f1kUM5Tuecatd9K/HlV1JSZlAeGdu6TEHp8do/x8PGAYAr/5ztJ0Xw9b04
	8iBmRpQHkD+KE5WOK6WuA+6n2v8/KZK72kmXLtDfH7llOjZgj0tlRRpaLCLDsI3Erw91X0/puyj
	TSxJF94vcXdJQS5/Yqy2x9/B2vucEcaBHypCZj7eRur2F/yrmVa1vD4rTg5SdSqIcUEUqSgs24P
	QY6xVtw/ik4eYkVThETL/tvJYnenQKIECfoIKy6WQYf+1RDOKN84Q3liwZvGEJeI8/z1lKwSf1Y
	tHDU0VnEzLK6pbdFWZmn4Pw2eYwxjPkOZ2aQoTEMHBRsucDHeXQY+vwaX0erl0poxgPBWZFtg6G
	d7i68RQgJB0RhVXQn4mi6wq+4liA69fJJP7+RqlH5Vw3ZXrXBQpYsAj9LfZCwQCd2GGVRHV48Xm
	LjJJ1Fm6ZNdntUEGNacjwmpB9+9t/Otheiar29w+4XhMkzjbi8fxW82kBP+2AOuVr939yR0erYW
	G+zN0JAqB4Vf/Wei6OVhpPH8IGQq85lWdOvnna/6g5NaDPtr64eAdVo/v/4wBa0hWoowhh4xVbL
	Hwrl08+uUKwXqSzjppLnKqh/HzjBGoHPM/njLDsiEg==
X-Received: by 2002:a05:7301:f89:b0:35c:85fa:5a61 with SMTP id 5a478bee46e88-3674f1186b6mr4958712eec.38.1792637744268;
        Wed, 21 Oct 2026 19:55:44 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:5145:5add:2df6:4671])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-367405ee5e3sm11457355eec.4.2026.10.21.19.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 19:55:43 -0700 (PDT)
Date: Thu, 22 Oct 2026 11:55:38 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Hongfeng Chen <chenhongfeng0212@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jens Axboe <axboe@kernel.dk>, 
	Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Yosry Ahmed <yosry@kernel.org>, 
	Wenchao Hao <haowenchao@xiaomi.com>, Wenchao Hao <haowenchao22@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	Hongfeng Chen <hongfengchen@xiaomi.com>
Subject: Re: [RFC PATCH v4 0/2] mm/zsmalloc: defer object free to per-cpu
 batches
Message-ID: <atl6mcXcDt9NZoW8@google.com>
References: <20261016120927.3191690-1-hongfengchen@xiaomi.com>
 <CAKEwX=ONniSwdiZAe_8NT5XwVj=Mmc-WJs_rWE4Y5snjFg2=Eg@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=ONniSwdiZAe_8NT5XwVj=Mmc-WJs_rWE4Y5snjFg2=Eg@mail.gmail.com>
X-Stat-Signature: zc6fhi3esucc3dbweme8xiegdjtayw85
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8BDD8C0002
X-Rspam-User: 
X-HE-Tag: 1792637745-581165
X-HE-Meta: U2FsdGVkX19wHFqu7AzmrrO/V+3gsFHMxv7Lji32+B2zJMJjskrCD4KsqMmBDHYYsJyX9YNZTDz68qZoe0OmmwVNFBP8lXL2b8Yy/ajSd/3xR2wDWpyKRGgxD3WwrnfGBQWiRw1dc5w680+jucRX3U+gfbjeglDpK7eaJv8d5rbzDU5l+glfZbuxWpGO/ua7WzHTgA/VvXnHzzyYw1eKzE+9DsLtN+AZI+MvzV1aJyUYEc+ZSoeHZtGCYUP8/TdwrWt/QdSlXypT5hTpvW+Sx9IGLl0nmyzYYnO7A+eXzfB9w8NMQkrOvwZ1EEkSsrtAISxPbI+SGwR2QVYclzQx1yZquj1oItD2pn3yu1WnoXdmiPebYH6gQqZOFPjHfg1VJOvTq7LjNlvxaegWGeOeNTG6V5o0PQGY0Vh4pHm8FpCEEsVHjRlW1n9vpF+w+TalT9oXZDv3V5USG59A/Zk1IIAiMGagHqm/Yf0LV9hMtGQ35kRrTzeFDrkCPGV3Y0pIOIKowzIkV+u1aHcwHTr7pE8jDtJY58TbgLHHOxdSMUPz2O0TqchRKD3CMTzRI+xyCBbrI5dcmbPGRp+Y/yPhaueAfRzZqf1uOZ9rIwtKavyt/njwI/ZBHCpbURC2R5w9BNft5pUceittvc7FBR+jlJLy0vjGukxBHLR1PV+ybR+PsGHd1Fjmdft2BRqSdXgk+P28i4rdZymB/PaI9BLGP2zAUrfpxwL9GbdTNPpzQqI0dCY6KrxcIuipzcenJMQRpsfyPBCcFV/Fr0aKmShYGM03Zol/fJI9D8WxNrGXF0munLkq6ivLf0+r157CMcZXxaMeuRikDHOqfH+DSgnILlVXNzg7iX8v4c3tkVaH2j9ZBdTPI74ii+Yi6wWEKjel9G3R7hDboL1zXLsp+R804NFj8roH6Lsf8lYcD3/hWiwZYhM894p/e2ARlC2MlH0akcsgI9g/PkZ16LVZueL
 yEaHrMgK
 PQlWUHzIPHD7SQefH1EivA4deCxfegEcdOz7LUAsrZolcbZuLSfK3wY8jopTNexNaXYaNQ+5hhZvhMKy2ZsQW9LXzLPqBMqqdWOEg80Akpjfw9SDp6DQzpZHuxR5s7/CjLplEMKWvL4wLKoffpqgVlL8wMqIi0Re75gXJ7e7c9nEM9HalKHTmnhNPZsLC0G9OMjuw7hjoHvh0TJGLNri5WLi8+8qXDqJ7M0FEUkL3FPNS/zsRHAmXKMHNkTf02Cki6vzM/6gNbqV2qoTxRps81B8dDKayqDXud6R3m4drIjE19fA27jah0mIr8j+TG0k13XIjqn4g5wl05FpY9laK3FFp32IGa6cZBKb8WwBZdklNL4zIpMMA+7a51jEy9vdA0OSykjJ3CNdQdkV5KIp43hkqTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/10/16 09:09), Nhat Pham wrote:
> On Fri, Oct 16, 2026 at 5:10 AM Hongfeng Chen
> <chenhongfeng0212@gmail.com> wrote:
> >
> > Performance results:
> >
> > ROCK 5B+ (RK3588: 4x Cortex-A55 at 1.8GHz, 4x Cortex-A76 at 2.4GHz,
> > performance governor), single process munmap on A55:
> >
> >   times in ms, speedups over base
> >               Base       Patch1       Patch1+2
> >   size        time    time speedup   time speedup
> >   64MB       13.81    3.62   3.81x   3.28   4.21x
> >   128MB      28.50    7.18   3.97x   6.49   4.39x
> >   192MB      42.19   10.71   3.94x   9.69   4.36x
> >   256MB      56.06   14.26   3.93x   12.89  4.35x
> >   512MB     109.50   28.43   3.85x   25.66  4.27x
> >   1024MB    217.10   56.70   3.83x   51.15  4.24x
> >
> > Same machine, single process munmap on A76:
> >
> >   times in ms, speedups over base
> >               Base       Patch1        Patch1+2
> >   size        time    time speedup    time speedup
> >   64MB        5.59    1.58   3.54x    1.49   3.76x
> >   128MB      11.86    3.16   3.75x    2.95   4.02x
> >   192MB      17.18    4.72   3.64x    4.45   3.86x
> >   256MB      22.89    6.29   3.64x    5.87   3.90x
> >   512MB      45.15   12.52   3.61x   11.64   3.88x
> >   1024MB     89.16   24.75   3.60x   23.12   3.86x
> >
> > x86 (Intel Core i7-14700HX, P-cores locked at 2.1GHz with turbo off),
> > single process munmap:
> >
> >   times in ms, speedups over base
> >               Base       Patch1         Patch1+2
> >   size        time    time speedup    time speedup
> >   64MB        2.87    1.50   1.92x    1.14   2.53x
> >   128MB       6.00    2.93   2.05x    2.21   2.71x
> >   192MB       9.33    4.35   2.15x    3.33   2.80x
> >   256MB      12.51    5.78   2.17x    4.38   2.85x
> >   512MB      24.96   11.39   2.19x    8.62   2.90x
> >   1024MB     50.19   22.78   2.20x   17.05   2.94x
> >
> > 1-4 process munmap of 256MB each:
> >
> >   times in ms, speedups over base
> >               Base       Patch1        Patch1+2
> >   mode        time    time speedup   time speedup
> >   1p         13.18    5.78   2.28x   4.35   3.03x
> >   2p         25.83   14.41   1.79x   4.57   5.65x
> >   3p         35.70   22.14   1.61x   4.68   7.63x
> >   4p         44.25   28.71   1.54x   4.75   9.31x
> 
> The numbers look nice, but I think it's a given that if we measure the
> process whose work is offloaded, we'll see a speedup.
> 
> But would this come at a cost?
> 
> 1. Would memory freeing be slowed down? Could you compare the host
> memory usage over this period of time etc.? Hopefully the parallelism
> would cancel out the extra overhead of setting up the work offloading.

Right, especially interesting what happens if OOM-kill of an app with
a considerable amount of data stored in zsmalloc pool, is not immediately
easing the memory pressure.

[..]
> If it's the former, we should dedicate more time
					^^^^
					and tokens ;)
> towards improving zsmalloc.


