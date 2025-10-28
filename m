Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29FA4CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 19:56:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F3448E0194; Tue, 28 Oct 2025 15:56:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A3748E0008; Tue, 28 Oct 2025 15:56:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 693D28E0194; Tue, 28 Oct 2025 15:56:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 54BDA8E0008
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 15:56:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D5AF814056A
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 19:56:43 +0000 (UTC)
X-FDA: 84048580686.15.6513317
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf28.hostedemail.com (Postfix) with ESMTP id 00648C000A
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 19:56:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D5dgUg4j;
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761681402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Usl2MxJgf75ZtIXA3HYGIOIjCa964SgbdX/Oqx8od4=;
	b=Q0GsuCIUp4HXTMaxEQP8QP7UB3BYgIisnbBiW87nz6AKTg5TyDi0w3dsjdyF8+Fi/IQeAP
	GHRtzA47OBWX+jOTRoNPvzibTboQb8xY/vQlym7hdbROTA3BW7HHx6bq17DRzX1gEUTPdE
	kOCZMKRiZpBKKoEqIlMk8peOUBs+PIM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761681402; a=rsa-sha256;
	cv=none;
	b=TUDD0tT4BLxW98r3xLYckEfnEhpjetaKjM7LHxQCnCGjEjYLW+UWjO3gFhmF+ofXyNYrsf
	QAth841yoR13wMtxCiuSAkNpPAMoZc7KqY1UWLvtgR0IzlJ8lmS1K66PTrG6B+8U7hxcd+
	9AqiigXbgHxyE7F1NZyQWeNUpJiXBgI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D5dgUg4j;
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-46e6a689bd0so64013265e9.1
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 12:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761681400; x=1762286200; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Usl2MxJgf75ZtIXA3HYGIOIjCa964SgbdX/Oqx8od4=;
        b=D5dgUg4j7dli//5fhyMBy+QHFIX2MpA+WHz+Vjipu8HU6p2djaFiWF+PLf2kcIAG2I
         TAP+8BtbtaljtMiAMoVYRs4WUpKAP4Alqja+nqKEUVLK70mNH17VTqwmX5+BsCG6xNOK
         Nm39Nhf+g/TUTupPgCZ995cPjmIOve//sG/tiUSVr1jMtpJ4PQZ+Dm8ncUEU94fW0/7U
         gVMe+joTKxOfN80TkxasGr3/Hx2ZehU2Nfl9CIx9pt83JVQMxw4o94z56DkaF3io+7Ii
         6MgDH455G+DxccpqVQg8p2zaOuXYCXfThvJxyoo+bNARmM/7ozE+srY0v5d3fYu8QDRM
         ibkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761681400; x=1762286200;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3Usl2MxJgf75ZtIXA3HYGIOIjCa964SgbdX/Oqx8od4=;
        b=qvjVL+yA5EKrcZJqEj8VGcHsOVsFiZVIV5n6Ik+cAoUQpEbZLvyK6a44Utn+XPQ7yM
         fTJ6ZBPb+N+LhGYpX3+r8ir/P66GYeJL71b5JbRbpeI004oRJvIsLB056WJ768YPYGZr
         69xqUJRXVJKDGRkMx+8qHohd8yuQsvXAk5kZnIZToiYUAeRc2D5ayq56TT56YwybzQIF
         IvUzh2XqOBKNJiB9nKFS3lpvgwr80TXjO2gm7lAB49eRrnKa7TOl5t53Yed3v7LHG6tz
         sSuTmkn+S6kkhdjKvt6vJwwH7Dgybsow7BUIuuVIkfQw9IykXXb8hDWIX3l0hj6XiFWI
         qGgw==
X-Gm-Message-State: AOJu0YyYD/Xh6to6rrntEFmdQANDG9ljVPkmPr8falRIVLBQuxaepTCc
	quoQmVg5ZSHP4v5sskVJFb+JNcBuk+Q+U4Via83Aa4oiDgMGEIXJxArAbNJ73R9MAynsD2fohc4
	T0XPZV3Mdulz5cGlMQQNfovXvSziPr0s=
X-Gm-Gg: ASbGncv5oGZ2ltKwb1wBBGUxS8cC1A8QvmFuBzUB/besWBEk5wGHTHIlmoU7Mdx/4Sr
	WlKqBE1dcrMLH9ZtJqpAXN6d5thC1dVNIX3HOWSVTbJzaoHIgrGj8+JFaCQ3x4vuPAKnkLtxg+4
	EmI31ICWr4AGAfKgek09qS+Kc+u+Y5VcI4VgBz2IpwbjtGp2/C+a9NzQAm2GSHkDskLES7wlet3
	MjA7LH8hJ7SCnL7wdGXOqSIAxpN7hJ3dNsPeziYqpMiDPaLCOeu16kygA==
X-Google-Smtp-Source: AGHT+IHpcn+eKk7XEoX7aUKCVR8RC7VrOxB+A/nsWUVptSZDoAunp24lGEpEiln9XZ4xk7g/xSicMHFuYPSNsvfuSts=
X-Received: by 2002:a05:600c:3511:b0:46e:428a:b4c7 with SMTP id
 5b1f17b1804b1-4771e1caca2mr5555895e9.23.1761681400086; Tue, 28 Oct 2025
 12:56:40 -0700 (PDT)
MIME-Version: 1.0
References: <20251028034308.929550-1-bhe@redhat.com> <20251028034308.929550-3-bhe@redhat.com>
In-Reply-To: <20251028034308.929550-3-bhe@redhat.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 28 Oct 2025 12:56:28 -0700
X-Gm-Features: AWmQ_bmOuBXACtD1EpZ1FFWt5uI8t6B14R06sXXZZmSea8TeOEwh8DbHgD1FFPU
Message-ID: <CAKEwX=O3VkZx=4uD2o7dvrv_SdKsD9fcpUyS2YoR7xrdwqjywQ@mail.gmail.com>
Subject: Re: [PATCH v5 mm-new 2/2] mm/swap: select swap device with default
 priority round robin
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	youngjun.park@lge.com, kasong@tencent.com, baohua@kernel.org, 
	shikemeng@huaweicloud.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: 9x4ejwtf74defqgyarufniibf5q771s1
X-Rspam-User: 
X-Rspamd-Queue-Id: 00648C000A
X-HE-Tag: 1761681401-165604
X-HE-Meta: U2FsdGVkX1/X461IdOOFHk40fn7gXPMnffCUNZsIYqhkHbhMYjOq6aD1htjCiWTIqXV84iWx+HIsluLwsSaPUJNIsKpVlOMltEUV3Pxpxhsq2eCYEjDNWqtJ4gMbM8+BVeVkrhHEInsUPijFiRo8fptsIvysahp0gb31GluEAwR8QWgZwLH9Ksb/BJNT4udTEAPhQRbdRho20GGArG1JRTyhgUGA14ZH5TS48EGZRK1j6TQqPVcoGoHxcnpYEGZzpYlsX/gSeedF+WGl1L2TCWFGsYpgEcX8/fOc+qvIvJ7qrEMXRF2EC4xLZhjmSm6m2LKWzXQ9EeZ9Mr/VIpfIer+jQVttK8INHFbyMRXBWkaujRN2k2rTiFEkIgoGAWTOvhLzf8M/4cjrPCXdH8+dJY2DbLV4ZDjaOx0QB9pnWWjpB00soFyh0aUZhyrP64jDCvAgLFvGn0JG46vtOucSthLBi+PZ9MjJvZy2DcbmdXVeH6HKFRcstk1Z7akHrwzmSnyJ/Xu3qG0t4tX63G7uXRTZ2+s5d3qYTK1OiYcuPqEryXdfmGailElkRIOZ4lz8BH60sOz3gJHshTxFbCpmtkrFQRkOf58jnNy3lEvtjlcogBxh35IShaCM6fJJsMQcwREv/QZp0kNo/nFR4sw4mM9NgYDdBEu+V7//uKD60I3mWgCIgejscx3Sn+IJuvVZt0km4mjAKbcsNMFVzjjOPJktv7lVQoUfgUIz4u8Pw1G9sXuW2lUXT2tJ/EHFMYkv8ftA0NRSQG89JdhKPSZysolZ1/JShSzq8PtnG5OALv2TK5ei5L86BVXVWdjUWU84FpQHQ5UNS4hAe8nTFU+gvUGwxftzdYmg7OIfuO5BZywA8qwlxWjMjCMdUkWLRvMRmpRfZLARJUxqX/DUwJKFeL3jbRcoA9QSKD+1jUfDu1QKW0C+CUjH0tt7rQroJtBlI5LMz1lzGPeNuHM1e73
 yOslOjtf
 tvABZkUp88HMtx2v18iFFPs6lNxYafwG27vk5V7HF8egLItZ5p/X0kmVXmhjx9gx/1dgCCQoT9cSfDuuD/4WFZtj0DewrYRCC2kUnFAfStz8XRcW1qz/4jVDAyOInJkc9xPb8AvL2q68Ltfx2BbBXkCBjRh6KGR5mmeX/efSGN89XJyLSren65JLS3Xs+gEAvV73zXkMSx7z+lvkg/BYyhKagnm6at6tIkIykQLFLVlan9rAVXB4C7ZCU1HvZ38lCQYyaeV9QC1uPgPMlocT+SmpxovdPAI01RVO8FC72w66639wmuqg6p+2ap3dDApzl6l3FmwFf75TEhtHbdJfCNhstqGRECh6VGyZ1po+FeFvwwiwiv1jkN14/eyLOhEI+N6jnPPbFjAZJNqFzj24egphJPMoyXCkMiDnvE1f8dwMk3lI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 8:43=E2=80=AFPM Baoquan He <bhe@redhat.com> wrote:
>
> Swap devices are assumed to have similar accessing speed when swapon
> if no priority is specified. It's unfair and doesn't make sense just
> because one swap device is swapped on firstly, its priority will be
> higher than the one swapped on later.
>
> Here, set all swap devicess to have priority '-1' by default. With this
> change, swap device with default priority will be selected round robin
> when swapping out. This can improve the swapping efficiency a lot among
> multiple swap devices with default priority.

Yeah, I agree. In a set up with multiple swap devices, this can spread
out the swap writes, potentially improving throughput.

>
> Below are swapon output during the processes when high pressure vm-scabil=
ity
> test is being taken:
>
> 1) This is pre-commit a2468cc9bfdf, swap device is selectd one by one by
>    priority from high to low when one swap device is exhausted:
> ------------------------------------
> [root@hp-dl385g10-03 ~]# swapon
> NAME       TYPE      SIZE   USED PRIO
> /dev/zram0 partition  16G    16G   -1
> /dev/zram1 partition  16G 966.2M   -2
> /dev/zram2 partition  16G     0B   -3
> /dev/zram3 partition  16G     0B   -4
>
> 2) This is behaviour with commit a2468cc9bfdf, on node, swap device
>    sharing the same node id is selected firstly until exhausted; while
>    on node no swap device sharing the node id it selects the one with
>    highest priority until exhaustd:
> ------------------------------------
> [root@hp-dl385g10-03 ~]# swapon
> NAME       TYPE      SIZE  USED PRIO
> /dev/zram0 partition  16G 15.7G   -2
> /dev/zram1 partition  16G  3.4G   -3
> /dev/zram2 partition  16G  3.4G   -4
> /dev/zram3 partition  16G  2.6G   -5
>
> 3) After this patch applied, swap devices with default priority are selec=
td
>    round robin:
> ------------------------------------
> [root@hp-dl385g10-03 block]# swapon
> NAME       TYPE      SIZE USED PRIO
> /dev/zram0 partition  16G 6.6G   -1
> /dev/zram1 partition  16G 6.6G   -1
> /dev/zram2 partition  16G 6.6G   -1
> /dev/zram3 partition  16G 6.6G   -1
>
> With the change, about 18% efficiency promotion relative to node based
> way as below. (Surely, the pre-commit a2468cc9bfdf way is the worst.)
>
> vm-scability test:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Test with:
> usemem --init-time -O -y -x -n 31 2G (4G memcg, zram as swap)
>                             one by one:      node based:      round robin=
:
> System time:                1087.38 s        637.92 s         526.74 s   =
  (lower is better)
> Sum Throughput:             2036.55 MB/s     3546.56 MB/s     4207.56 MB/=
s (higher is better)
> Single process Throughput:  65.69 MB/s       114.40 MB/s      135.72 MB/s=
  (high is better)
> free latency:               15769409.48 us   10138455.99 us   6810119.01 =
us(lower is better)
>
> Suggested-by: Chris Li <chrisl@kernel.org>
> Acked-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Baoquan He <bhe@redhat.com>

Acked-by: Nhat Pham <nphamcs@gmail.com>

