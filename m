Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02F8ACC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 16:09:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8E666B0088; Fri, 16 Oct 2026 12:09:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3F4E6B008A; Fri, 16 Oct 2026 12:09:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2D4F6B008C; Fri, 16 Oct 2026 12:09:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8CCF06B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:09:33 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 199CF1A04F1
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 16:09:33 +0000 (UTC)
X-FDA: 85328974626.01.4F32AC7
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf19.hostedemail.com (Postfix) with ESMTP id 30F411A000F
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 16:09:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZUsKTZir;
	spf=pass (imf19.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792166971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=01clFvS8PqYDYJUml8Ul3JDl8oOLRSNhVNdWYi0v5ig=;
	b=mupu1cHXl2KwPIbAc/jbAFBYrpQWbYniLvAFFt0HPaqlOnOxvpq79CGdjSgUtpPCWgYN0F
	nXAWiQeDpJ9zl3av/rX9DkdLfFd39o4EH61B7PbAQ9EtfKCPidMpjva7ilOk8NkNhygRYT
	x+cEvs6it4r8CdLgc92eGSkpB53hW9Y=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792166971;
	b=D2WkieYTWaMiFbIjAGUi7rqxmZaZmSSPGBqW2ynRzC+R3Y+glN1vZHmHifZnE7aKDYiHsD
	UlRwIJTQmUzVLcKREt9FvX+xXh6e2zuzFztRhimPsm+C00bfpXhMErR5Oq+qYqmDM3QaQ6
	QI+v5nkbKnf02tDw+EQ5X90YwD8avAQ=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZUsKTZir;
	spf=pass (imf19.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a1d484b4a9so1707755e9.0
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 09:09:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792166970; cv=none;
        d=google.com; s=arc-20260327;
        b=CcXeV/SLCN2mYaELkVJFpqeR34qZGGPwd4eExJ/vVgeSJ1d7xsIEfpmMwCemrpYMcM
         wTgeWnoPkraZh9brWWsKYPnD76yhft00ZjZYaHM+oPWAl4EpidSg6+ACT9TH6oOr8rt9
         5smLDkEOuZ49w+w26rHALAjZ5KJypitC/eLu5V+KxCYfUz4DYc9dWWaaXnGT/viggIk6
         m8t4h5cJxmoU/gXjRSgTNkU0ycZy84kkv5zKeSsc/B1acr+2gPyE3AVD1vz4NQZsPn/2
         iF7/EIEppdOJUqLsGPkgiXvemf4b1HxbZkpAndnv1ND0/vKCtrfejS9kAwsCkPXJdHcC
         rzjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=01clFvS8PqYDYJUml8Ul3JDl8oOLRSNhVNdWYi0v5ig=;
        fh=JI4Rb70QuLyh9dowYaXDPWzSxr2xn3/cKnqdtGnI/LM=;
        b=k1luhC+9i+uFgX7rJVQ0F3KGPF8o/eZurXXdzp0N5nGZHEuuOuZysgALuXZ6DI+aqM
         fQP0TUhXhJd3xh4dnj/lrlJOejBAVo9CFiOmwo7cqhoNSnT3Z5KF4zKt+gbflsRVRTbm
         5fYPTWrCoyXKU+ZsR9TYSayMyT+5FjVvekI1jiIknod5I6zvxYfu63/p0irNdN8h9rFj
         2BbiFPYmHBj70WY3fU0OO8MhSIxYthvoBXBkARtloiRy1JNQbKGjgqtH4TIrEwcWGZpb
         5M8li82E3MbFpjSO8J8+twtpFenzggAENNjIC8iQsdWRm9+C936l1OiXscjy/nKE4cI+
         NCRw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792166970; x=1792771770; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=01clFvS8PqYDYJUml8Ul3JDl8oOLRSNhVNdWYi0v5ig=;
        b=ZUsKTZirS5ZkU88ofBbjTkzi74RDkqxE3igSquMnM5VxUO0VwuRquhees/Y4zT+kVV
         Aifow8I7hNiJ2bYX3NcdIvyS3H85XzhoYFQBE4MKiQJet5njLJM+we6zG9jtpt8WqoFm
         9otHmcDRHNN9U7fUwctHfrvhVoOs8VK2ElzQj+kQkCGP+j3Y8mYk3hF5EUQddfuAspFZ
         f3ehQ2kS9K7aEamOv/NtjKXS4+1wOzbHsFxkWmJxedcRxHravHBkNlvM1sqrRGu3lfsz
         /qCX2QGgpbk88JDVsM9NfwoMywnWA29JIl0HL5E4x13HazPEsmZo44bVdxJJQIoLZxnQ
         hATg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792166970; x=1792771770;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=01clFvS8PqYDYJUml8Ul3JDl8oOLRSNhVNdWYi0v5ig=;
        b=v9yc/9Zt/ukCV7ydoZX1fmPrfoNLIy7dQxp1Cmyj6qmxkib4o+n3ET9IOQeXxiNBdZ
         gJH9BJWaRENeL5lDc663kYI8vHeXMzoZtAtZaISWmuGhHJB3DdnMIOSAkNvZ/tH32tkD
         axiouyOiFrOkOLJXVBIxMej3fXAWDuxOyYEjZokyzmT7atE9XyasobRkl1fom+dWQXeu
         119rEgStua28xC+i2EBRUbyg8U8LryMbr12RSvUk5lKENqy5ENYa0ELFLgSjYlbjCUwG
         P66dIFJQ6fSxk8U7Yx+NjIn9v2V3qfPnkny62Uud8Cb3KEhO62oeLks5dG1r0/UJEJq8
         yFxw==
X-Forwarded-Encrypted: i=1; AKwUvBxKG/DfMoIVJv3LOO0wP9zifW+dE1wr/mAeB25+BzlxdW9070Gym86kcZRbuDgVLIYxy8MsW1INhQ==@kvack.org
X-Gm-Message-State: AFq9FYLjKaJxvqR3S/Do0+yL2oLLksmWchFdfjppT9W/nuleDoHbZZpM
	S5Y7sIvStdF0Zp2bN6EZUO3uHukp409Tl8mQQl9XXcdoFs3syI3YyKoYCIV+8Qug5/ikg59+IBx
	UFJub9zFymbBTwfqHcdemavUx7K1m2V8=
X-Gm-Gg: AYBFou0K0JeN5Ps6E+P2aqaqKm9iHRVKjghQCVmf6pwTJJ7v1oLW4nlAPISwG7BTwTI
	jwW3Iw+rA92TmRFhCD4s0fJbQfz4GG4SWlr0d/29mVy0B5+s6vXxWplysTXiE1J6PM0gyl0tE+e
	oL7EVf7CPCwwSJkJF80UVGFhR3KZmOjlz2JNkH8bK1dhfNqLYA2hsBy/fMlStnJ8/fI7nHdrEqy
	+AWTvNDvOwRJyMOGiJBOlvapNn3Deva3TQP2PVJxdkyVayOn7RHpSaAW3hQTMYKzVwx5tyTBlpR
	JcqQTu20N4829Ns8DkMuksL7sONgblraoS/8W7Pw0TVDxxqtO9OABu6gdsiSnp44QA0fSyBuB7L
	Ls7IkMibsopo30kOcz7cp0wrAGsi+j2ZWk7/jhRzg0LhhfLNx7L0UzaY0cVmnbdbN072RtOU6g0
	AmNh6ubg==
X-Received: by 2002:a05:600c:6215:b0:4a1:d41b:5060 with SMTP id
 5b1f17b1804b1-4a1d762b705mr4918205e9.22.1792166969428; Fri, 16 Oct 2026
 09:09:29 -0700 (PDT)
MIME-Version: 1.0
References: <20261016120927.3191690-1-hongfengchen@xiaomi.com>
In-Reply-To: <20261016120927.3191690-1-hongfengchen@xiaomi.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 16 Oct 2026 09:09:16 -0700
X-Gm-Features: AclHuK_3q4fgvpP3PqMsH4m0BzcVF-oc6GrjQvM0hL6t6dEcQtFu56enbmqvAPg
Message-ID: <CAKEwX=ONniSwdiZAe_8NT5XwVj=Mmc-WJs_rWE4Y5snjFg2=Eg@mail.gmail.com>
Subject: Re: [RFC PATCH v4 0/2] mm/zsmalloc: defer object free to per-cpu batches
To: Hongfeng Chen <chenhongfeng0212@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jens Axboe <axboe@kernel.dk>, 
	Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Yosry Ahmed <yosry@kernel.org>, 
	Wenchao Hao <haowenchao@xiaomi.com>, Wenchao Hao <haowenchao22@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	Hongfeng Chen <hongfengchen@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 30F411A000F
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: hgm5iw7xs83zmwb5akeczbd65t9xe9i8
X-HE-Tag: 1792166971-478513
X-HE-Meta: U2FsdGVkX1+7dZ7lckevsUML1ZkkvLPlSAasRZ7M7RELu4qogx1JN5S+f/AxGAv1Wxljn5nFXqf/Rn+6MOA7KzyfdopC4b/7NZQ0GsAem3o95fkBzF8laubJc/9kXgpMGCbrgB8C3leVOnU9Jp/372TNZmRE5b5MoYEcgmofmGr0Y+ISARwtYxKicAp98xWGYLa+CHQgBt8dplabtFkRWvcMO8TTBZLPGeF+fegZhtb4dGNDJ7rw/Wgii3bqWznAZm1sIs5B4W9ZNN1IlK/IXzxnPVhMB7MHnnTpu3iDDMI8EfIax1PUr7I0GTgYviaJUThf4qoP9yBAfFOrY3AoR7STPMJIFe/0S6Fta9s3QdGqxhIM7ujqdw7bVvgyTJ7MhpLfcgui7JHPiGihWACt+wbd03NFOABmmRXFfNDRgIIl/TC3BynaT5ApUtwKzaG/N/zuhXPqGqLp2/N5sE2IhMhZZ1TF4ocIOM17Kg8+WQfK4D7Z5Tbvz3UL/xjM65IC6IGNixCMDLvIViSSVHm+H8lfVX+ylWSNu+hTh7Zp9dk04PVgwYQSxKQtTHZteDDmUyy/72EstV5U3SRGCPK6B/aHIKVUnkMBOSIANPYYXMkD1W0p+54doelB6xM+yiRMr+nRSI3AkMSMetpx0f6627h/zPDFVIKbqOwdwMb0HSWOvbU4lZMCMyzD8k4M2V9VS+6gq/dMQ+SC+1FcHxknFKmwmlkJnAEI5x127JHXm9qakWe9Nv6II8L7wCCsfRlrE0TldkOZ9FLVye6AgmnBGZYDPwFnty5zp1e63owrDoznLw+yxrPYawZ6J6TOc+XVx/oYlw697tOA48r31aNc7Qfs7GSvxGYlr7T3FnOCZNzjp6caj69yGk2IE1e3qQUkbpX4lQ51oLGPTPdebAPcszZwNLqBEMxBBawoKbLhlg/WJ6g9Mpx1c1sR2GsWZGxU6cFTMD92UxnS9A8m5UE
 J54n+Eck
 OXk27vsuxPgRX8lGOgMhCEta4WkUcTM/ieC92n+653OBUCqJEqRzbi6+Qf/ubB4GXZ9Xr3ExZ9m9Bjwcz+xFxvJw1zDLoScrblYFpRrcRPKQ1QDdvKs4jq+e1cyKtEN8f+6x2MVy0OfBq088i486lfeS/u3Uwpt8qWHY/uLpPjdics5zeE6N8igVhnrXZiagvv4A7oDoLhboopqJvFgb++N+susLoE515HscJu2YbJjJTjzv926Y8i8i/AJ3wU4aoUJE/jEPL0awIbNAtJlf8Q38vTXvcs7O+g6YWmHcAaEa59BXNu1ibBGmp4hNOYFfzjhHDTNnkcv6eQG2Yzp8rZfCChcfUyW95wyXZblEoWpTylXOyILvi5Hm5JQ1b1xtgCDwCcrMNshDaau63Ng2iUC5t8O8eEDV+gcTLt0p8PC8bVRLlmdcQ8szVMrPnt6NP6Omp7zrUEYVRLkeBvpy935LIqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 5:10=E2=80=AFAM Hongfeng Chen
<chenhongfeng0212@gmail.com> wrote:
>
> Performance results:
>
> ROCK 5B+ (RK3588: 4x Cortex-A55 at 1.8GHz, 4x Cortex-A76 at 2.4GHz,
> performance governor), single process munmap on A55:
>
>   times in ms, speedups over base
>               Base       Patch1       Patch1+2
>   size        time    time speedup   time speedup
>   64MB       13.81    3.62   3.81x   3.28   4.21x
>   128MB      28.50    7.18   3.97x   6.49   4.39x
>   192MB      42.19   10.71   3.94x   9.69   4.36x
>   256MB      56.06   14.26   3.93x   12.89  4.35x
>   512MB     109.50   28.43   3.85x   25.66  4.27x
>   1024MB    217.10   56.70   3.83x   51.15  4.24x
>
> Same machine, single process munmap on A76:
>
>   times in ms, speedups over base
>               Base       Patch1        Patch1+2
>   size        time    time speedup    time speedup
>   64MB        5.59    1.58   3.54x    1.49   3.76x
>   128MB      11.86    3.16   3.75x    2.95   4.02x
>   192MB      17.18    4.72   3.64x    4.45   3.86x
>   256MB      22.89    6.29   3.64x    5.87   3.90x
>   512MB      45.15   12.52   3.61x   11.64   3.88x
>   1024MB     89.16   24.75   3.60x   23.12   3.86x
>
> x86 (Intel Core i7-14700HX, P-cores locked at 2.1GHz with turbo off),
> single process munmap:
>
>   times in ms, speedups over base
>               Base       Patch1         Patch1+2
>   size        time    time speedup    time speedup
>   64MB        2.87    1.50   1.92x    1.14   2.53x
>   128MB       6.00    2.93   2.05x    2.21   2.71x
>   192MB       9.33    4.35   2.15x    3.33   2.80x
>   256MB      12.51    5.78   2.17x    4.38   2.85x
>   512MB      24.96   11.39   2.19x    8.62   2.90x
>   1024MB     50.19   22.78   2.20x   17.05   2.94x
>
> 1-4 process munmap of 256MB each:
>
>   times in ms, speedups over base
>               Base       Patch1        Patch1+2
>   mode        time    time speedup   time speedup
>   1p         13.18    5.78   2.28x   4.35   3.03x
>   2p         25.83   14.41   1.79x   4.57   5.65x
>   3p         35.70   22.14   1.61x   4.68   7.63x
>   4p         44.25   28.71   1.54x   4.75   9.31x

The numbers look nice, but I think it's a given that if we measure the
process whose work is offloaded, we'll see a speedup.

But would this come at a cost?

1. Would memory freeing be slowed down? Could you compare the host
memory usage over this period of time etc.? Hopefully the parallelism
would cancel out the extra overhead of setting up the work offloading.

2. Would this introduce isolation issues, especially when this work is
not properly accounted? Say you have a busy-ish host, with multiple
tenants. One of them is killed. With this new mechanism, would this
affect the performance of other tenants? (for e.g if we need more
cycles for the async overhead, or if memory is released slower overall
as stated above, etc.)

Some more benchmarking to show this would be nice!

Another thing I wonder is, how much of this slowed down is because of
zsmalloc's own inefficiency, and how much is because we just have a
larger logical footprint because compressing memory allows us to
allocate more. If it's the former, we should dedicate more time
towards improving zsmalloc. If it's the latter (or if fixing zsmalloc
is just not possible) then yeah maybe parallelism/work offloading is
the answer. An interesting setup would be, turning of zsmalloc, but
allocate just as much memory (logically-speaking), then kill the
process and sees if you observe the same slow down.

