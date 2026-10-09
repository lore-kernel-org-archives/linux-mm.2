Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F85DCA5FED
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 06:37:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 876326B0092; Fri,  9 Oct 2026 02:37:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84D9C6B00A6; Fri,  9 Oct 2026 02:37:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 762F96B00A7; Fri,  9 Oct 2026 02:37:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56E7B6B00A6
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 02:37:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E55FB14018C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 06:37:12 +0000 (UTC)
X-FDA: 85302130704.14.4B9412B
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0F296A0004
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 06:37:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OxYM66ao;
	spf=pass (imf25.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791527831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EvP1SWOpOajfYwpFnq5wtxRsl5w4aXBljAw9HkukLSA=;
	b=deAAA6E39/gkQ7R14iF0k7gCmxZe9+l6TZM5IEZx5LpKtui/7YE6r3m/g3SaZOhyOul3Y6
	ysDQ+S3FFpDl/t5OTGOHzNIgHRdfHc03uE42yt07wADX/dXbY4w19ZaIkl3hN03UiRR8/T
	r17SgOML6a1ZWvxkVTgYj2CgjDg1ZTM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791527831;
	b=JrmG/MZgkVzGOVvVH/r7pUeBxkc2D1UemiPs40dpsKWdd8K/fdxLPrta5VBd5DyCLNSb2c
	T/X7RTSBAWg7XreOjJ8BxcB3J+++LoQbJAL6+IQsGs7HDHlqeL0UA2JX/MTJWCJrCo93OJ
	5l3FMtOytyA4/bRQD2iTl+IohMN9oSw=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OxYM66ao;
	spf=pass (imf25.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48afcd7ba9bso2178349f8f.3
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 23:37:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791527830; cv=none;
        d=google.com; s=arc-20260327;
        b=ULPE1fAr5LQ5VPkpX/Ua6Qi1Iwc4A8QY1D+Y9cZeXDeeHBKAd5akZ3Ggb59ssRat8C
         qKnJp2usVBsuTyt/uUz+8X5dSQeYUYHeMsADSuMGeIFt4naZSF2B7PZBlnxmgRWV8Ry6
         wdow2M4wnjm3vQKyA2SkYwfD8YACBOHLITuZtMxRlnP4RBD0o9nduEMEu+qBonxmZRpE
         lBHaLG8gNZB6TLzC2HBd40ZZ4f9bk+bj7/1wn4yawa7URv7E/tI3qjgzYFu216Pfw7iV
         3VBm+SW6AOgBUfe0gewcz8Ni0D3cnEYMnQN4vmiqsfByAa4715zJl33NdYbx3u1vBpCE
         HyeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EvP1SWOpOajfYwpFnq5wtxRsl5w4aXBljAw9HkukLSA=;
        fh=bcEPE3CR+OddF51KqqJLDSZk7qQvv/ijtX/Tm5dhCBg=;
        b=FJCGphW8mOPIpNjy33Nm7qpdpxqkAIhcm0abFLAWpkhAGtNZgK0/X/wo8XEiuXRCqO
         1bVOIyg+1EhmMIWkxUaXNZ5Y3NfHpmUkBLP3+S2eZ4+cqIVaX928MMFjieacEKlRqq+M
         MMwwoVkR5w8wM9xUP+DaUdEG8IdTrWuCCfRk+mhFmVLmP6XnYj45jZn8xEbN6CnG4a8V
         EySvdA9CLBr09DHoxrA/3eAx8r9yA2zeKZCX4iLNOhHaEBf04wRUuMbuW6/vSPXujmLv
         0IGK1ywRfX9llB0W5z339brwJdMKDiKnoNnfjK39sbJfAexGSuwOnIYMB4b0+o7bVWgq
         O2SA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791527830; x=1792132630; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EvP1SWOpOajfYwpFnq5wtxRsl5w4aXBljAw9HkukLSA=;
        b=OxYM66aoRBJQK9vCqJImMyJhRJBV148Zq7QDDmEXFZAyLZ/G+/hdz86EIGBeON0aia
         LvmLwgVliptzIU6mcsSCdu+7XgB+J5HVERa9eV+T7g0C0qsptdwr5pwgHmRwg/pttI51
         zlCV6Z+AsptgJFiFJR9PAtI+1r0aPB08R+GU/MO6iBX5kkZGi4uF9C5UZXZ8x5Fz81Af
         +7PXN1qL+7W/BwKE+6c0kOa+vuukANwgjjHXE/9pIrfEBc0acMQ41/st7AWjsWWyg35m
         E5fH3kYmef2dxfEeqfLkvXkbf06TB7pnGrDltH7woI3CeabziiSvxns//uyqfFPKA5mo
         TCqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791527830; x=1792132630;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EvP1SWOpOajfYwpFnq5wtxRsl5w4aXBljAw9HkukLSA=;
        b=Uivfl6XqXGbCzJu5A0LLP/xDpDhLJZaJjyheV+XSYe5ATFziU3k81wH4W3pOkGH+zc
         WPiNen2R1pDurTeDQgzOwXXn18lt1dBJHCOwWCYhTYeR2b3L6z8siDXUEo5tBZQk/mVJ
         AbZwBFXAQUy1Mxut/Zd76qNlAiQAOvohKcj32EIuMI65svfdpWorQK2/w33bUaEJ5b+8
         iXjlaU4BjIec4jjceySSWg/Bvq3/tFX7WhU53XjwcMU9xoVBjVkYCL9qeIOCd9kQ/tlr
         M5YWzjsVa+Yd8frVXub2HlvWuIg1WSPkWWY/CDpYtUVZZayV6vIpjseUoP9LAOYBNI37
         mtUA==
X-Gm-Message-State: AFq9FYIlTxoK/imXP16+Fgg2D/bUabM3d2TBIJF/Yolq+XkDzEg7GHAS
	LPwUsGIwUSfnsXEsJ0Dsadl8uiYOPuNk+XdmXrrZ0il5wgkuwYsAZMzitSDMl6F2Zcn9lBrUeyb
	YcjJzQAo+gFhS2WQmu0RoS3FduQ0IljY=
X-Gm-Gg: AYBFou2Sl8943ZKVjUmbIZlZTaDIhJd0NpWB4EeMHm32ZFJF5KfCqQIsZsbRDr/4+NH
	EGrrWG6AnPnj0is6X/trmKkAVKWu8yMAVKJYF4GpsaB99mJik9JdVnvnZEhp8UfQaEMLtJ0VU+k
	kg6fRr9b2Jr2HZkDhrVkkJw8NQUm/EZZwhrqPkBQcpA7qVCkEbcdVSGlb3CacQKSs5UyPN5Yzd8
	lxKChqPj8CXG5X6z87h/vcFfsW+Q4xyYi8PbUAHy41i9LGIdCztwCweHH0JLWHROM9pi9JiItZW
	bhijpQG2YOxkbD0dl/pVCmYLBGidKsNrhlvbMaA8t6mmR71Ag9mIWW9J+iHu/DZYNHSxMn8uVq9
	hq/1Qk12R9iDY
X-Received: by 2002:a05:6000:4681:b0:48c:7386:af18 with SMTP id
 ffacd0b85a97d-48dba784c65mr1075334f8f.8.1791527829623; Thu, 08 Oct 2026
 23:37:09 -0700 (PDT)
MIME-Version: 1.0
References: <20261007153507.50715-1-alex@ghiti.fr> <20261007153507.50715-3-alex@ghiti.fr>
In-Reply-To: <20261007153507.50715-3-alex@ghiti.fr>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 9 Oct 2026 08:36:58 +0200
X-Gm-Features: AclHuK9vvbQEcKxc8F9ncIiH-4LY2ASnROXyq_1dok4ogbPPfoegotvRhFcR0BI
Message-ID: <CAKEwX=PZZi0r4AgSWXW=4S1SDmLQ+pSAKHUuCB=rXRSsZxJqKw@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/zswap: plug the writeback IO of an LRU walk
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry@kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Christoph Hellwig <hch@lst.de>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0F296A0004
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 1n1tujypqqaj6qqeysyye6chbfao9gd6
X-HE-Tag: 1791527830-162415
X-HE-Meta: U2FsdGVkX1++w3tA0/0ad4ytWAc+32B5NwPzwNz5FUurTAOQGKBkDh/o7XYD1Ay7KQfTHX6VPQbttp/nIXLsAGONmSMsGwcy6T3u/Qd0KILLqgJKN1FnAmSlaquAB15jLDDd0Vn/XVLrpDmeRlzZub8/OoQlF+7596M2yAEdXod+ydky68ZiIg2Ywm9wzFwPM2FdqflC57GoLklpJm3tmTIq+54uHed2e8fEWLzXdU/EDbJmqoxkI6vpS93BEj/JNJulMP+8JXnb4uZP86b7vYKtB7STkOOOwJnUwVr422YxJZEFM1yIJXuqm7aPzRdvfUlS3D6hdF/Am8xjTH00kAJkD0K+4hXJnTwDHJMr6lxtd3Mi7xoDEy8coLctNwDaKvGA4ZP+lzEBXz0qNMLGtRSZrZGkLvCq9hGULjPlCOPBiLvfl3ph+CinbNnmk1ZRvmZ89qiVdFas26czEQByGTkSr5JrX4gmgxVqDZrOIeb+USR91oR8hcAMqllON9fVuAPbvRtrs3Bt5xNR9X6sNgR5krbh6jO4x7VQqQDJsw6J+q0e4o+c+u3FLXVInomY5iHJkROrRwFRfSE2elkce/FajJgMDf3vJvTHgj9gK3jgQrofEi9zp+OC54wsGAYLxmFpgOzagVJ8TQQ5E32fRvgXpCLFWbrGobsT/kCL1vwpYvA0XQtY/beAD8ZstrakOzJKVk6QrwiibeXTHOr7NrMuDK+Bp4dtikZz1nnE/PC5GouZG1+L5Pi6/ks7e7wA/v/+f4LLyK+jSZ2vRfLVI02cEAbxsB1xRsIs9gX65NCcmhXWCJdVYIV1zn1WrG42uE4VmkhROiq2nTw+q2Yh43YOlsbCwfGQjD3lfsRC77u02AoR78Vshivrn7ndjbJLKN2e7676JdMzFD+jBlI3LF7HSEFozuv/SGdf7HrcjwKJG1FAj7a69dPpk10iVA8xAxo/WeIN+q+sZKoeYIS
 K1Uxn/S3
 CvmJs5+uJiR7RtsO4NLjhneKnsOuh6cTi0viG1z6gSVwkx8faJ2oCrV2f4ovTHNWWbGzxWgfuuxYsiUhvbVuG1tQFht2W5SYlyH28h12te+Vyo1vVG70uXRDBseoJLB/ZOIXGQ6b/S2imG/9FQRb6pZs51OjkamYtvY27Pvp8CVvtKDBrWfGlaJBlUsleZvCxhFOFqIYKHM380IFD2z7Hi87cAlJqE6fkhnB6VGhcBgwYty0vIFDhFvH53mStR4v6j45HZbCAMR6PKvQWmBcinhNtwrZWH0paoZvwqGv8+j4f25fab5Hr+CnQffJy68BGE+EiQCOi2+sanBkwHYL1RM+50NQ6ZUunKzA6JTyU5M0P8QlMSt1SvE4elYTsfn06CotVfghGsvGwE8Vht5bTKJkKPIAxJLvfO/KGmlyyqFzNB5s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 7, 2026 at 5:37=E2=80=AFPM Alexandre Ghiti <alex@ghiti.fr> wrot=
e:
>
> zswap writeback only appends an entry to the pending bio when its slot
> directly follows the previous one, and submits the pending bio
> otherwise.
>
> Plug the LRU walk so that the block layer can merge what the batch
> cannot.
>
> Kernel build (defconfig, -j4) in a 600M memory.max cgroup with the zswap
> shrinker enabled, swapping to an NVMe partition with iocost enabled. It
> runs alone, and next to a sibling fio random writer with 10 times its
> io.weight so that iocost throttles it. Mean +- stddev, counters from the
> build's cgroup:
>
> Alone:
>
>                                 unplugged       plugged
>   build time (s)                1061 +- 2     1057 +- 2   -0.4%
>   write requests (k)            622 +- 34     579 +- 21   -6.8%
>   pages per write request    1.30 +- 0.02  1.36 +- 0.05   +4.9%
>   iocost debt (s)             14.0 +- 2.5   11.0 +- 1.7   -21.6%
>   iocost wait (s)              7.7 +- 1.8    7.1 +- 1.1   -7.9%
>   IO full pressure (s)        18.3 +- 1.4   17.5 +- 1.3   -4.5%
>
> Next to the writer:
>
>                                 unplugged       plugged
>   build time (s)               2188 +- 45    2104 +- 75   -3.8%
>   write requests (k)            594 +- 21     567 +- 24   -4.6%
>   pages per write request    1.30 +- 0.01  1.35 +- 0.02   +3.6%
>   iocost debt (s)               648 +- 22     645 +- 29   -0.5%
>   iocost wait (s)               624 +- 23     633 +- 29   +1.5%
>   IO full pressure (s)          615 +- 31     550 +- 44   -10.6%
>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>

Acked-by: Nhat Pham <nphamcs@gmail.com>

