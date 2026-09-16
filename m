Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2B4EC982C1
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 08:39:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B7B16B0092; Wed, 16 Sep 2026 04:39:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 760E56B009D; Wed, 16 Sep 2026 04:39:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 651B16B009E; Wed, 16 Sep 2026 04:39:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 38C886B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 04:39:15 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A8CE540648
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:39:14 +0000 (UTC)
X-FDA: 85218975828.30.627B45E
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf05.hostedemail.com (Postfix) with ESMTP id CC2DC100003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:39:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pYw1bxEh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789547952;
	b=pB8ye5uXGz2bnMIkVMv6MOO8gG+7cnkjHWHF9I2K0wJpq38sX6u9+j7Low5m9Fr4Vl8nE+
	vMMCry4Fs0J/CkzR2bend2qaeL17ZOSIFyxyTZrhJ82wUBdkk9QCEPVPw849aJi5mAqK15
	D6h7orSgOT3g/VGGU4L7PzYPEOm0ixc=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pYw1bxEh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789547952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9n3jjmSPydEac4OpzLVHay3P89pv9PBRtC/AixhDU3Y=;
	b=gDXggHtZGfr3LyegT9goLOBVlY5TimseUpkve+E/MhFd1bdqK8yYBO8Jn8BjsVjZC4c6+L
	TdUhyLb4kxNV7NPrmkAOzjcv0NQ9nhSSnEhAkYputNE2Rsjw88UbMR+f7sx1+aBbYuPDlv
	/ArRYUPsRf13AGmMJB5NsTBuThXsH8c=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6a9a2f16ed4so2756737a12.0
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 01:39:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789547951; cv=none;
        d=google.com; s=arc-20260327;
        b=CVY9wCAx1hzeoE8feoipDtB0KxquTjiSWj2DprQV804QIas+FHNJpyqtAEEjiXDyU2
         mV7+64XIi1l+1XiCuN9780CPh7LbOKDDZySqklW/0RXnnGTz+r9bPuUXawaWRHbnA8UX
         kYBdcW+WVF2HBoyX/JnA/AKXur/dcvPLR9qOaD+BamVQhdxRWZd+qTscKJrlxgS1AA2l
         2ZbNvErk/Jq/oqxPwBjSdGgphRPcfjEUUgYLNzfp5/w8UjQ+nUK0VaW7J7O+01MuJeVF
         O5dHEM+xImq9WxAkw65xnuBXL/5KPiLsM/XKMUw4XJ5MlbuW9LPfbSI/LBYpjVdncpf7
         OW/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9n3jjmSPydEac4OpzLVHay3P89pv9PBRtC/AixhDU3Y=;
        fh=iQEUGowfYkiXT0mckEja/oBlef1aJIibQYEoU8fJ+aU=;
        b=jY2o9MU4nVXzSyvlIKCxd8sIdjo3f+kOiVVrb37hiWpNqDa+ilXrLHgZp0D2s5g+qU
         tLXqGXX1NGHt10GK03dX3U8BQcKx3HWefVQJtntdQ9y5kTqttNIievquWwOgvYuO4bVk
         pW8V+/Mi78F9ZpEJJq4c+dhyDeziC44n/gb98arvr25+UhWRjc3EgHkHvBUBzGtGLoX4
         A8cXTBAvQnmHwhF1EjGJfaFK2mqCH2Aho8QMxMSto/XUvz9Iq2XINkwPqRTeWYju16Mx
         pdJaDB5IGgSg5e5DoPoiPwpX5abCgwfLD1VryEqlX4LGtD9jaAHAGAhsGZtOv2eTKI1d
         K6SA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789547951; x=1790152751; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9n3jjmSPydEac4OpzLVHay3P89pv9PBRtC/AixhDU3Y=;
        b=pYw1bxEh6P1A5jExQi80GH3MGcqXDILlXt8QM5LTkZ9HEX/eREgqvhWHgvJZ82bn79
         wKMsLZ2K0qNRXguBsU5FTHBYmrjb16K8nu2r5j6oIocbhJuaOwGqCper2DL8AOh3F6ZI
         rVoHpZnNuRLk67rd3zxoFWLTkwtL/q/XZJGlahh0VtY/tGIvs4Ctb85ZajExArqOeU6u
         0FWRsl3tCZWCIhmW+EIFj08co+uP0PNPq+NkDqTZcAvybNnUYGsxrovnqa1M2olDk6lo
         tFnuPb5Cy/VOsjAfdRb3hGKFps0QYX0QK1s3iAeo2ODKO6C+zTbf2nm+5pWNPQNF2Duk
         gR2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789547951; x=1790152751;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9n3jjmSPydEac4OpzLVHay3P89pv9PBRtC/AixhDU3Y=;
        b=qzD8mNhss+dF+q0ShcksLW+oIZlZZpLrep7FpCGqq6KhXkaCZtBh1SYq3w0OK3Ds8F
         Y5RzjiyqYDw7dtbd0V/kC2B8w6GpO6WstjcIeF1ahhOu42bkxZAaeGhQK8IoikUs2GZi
         lBHPmn8bEZo52PIdO+njCNiTKZB2HbvQ/A7LxH7rGagJX+WSOW5vu00Y2iaxk3/21iJh
         iM32AgVP3J9Fzr3QVP7Tx9nQn/OBJlbF7VVGRUshaCjsFtEgRAe7sLRmuPnBf4O28XZD
         ufo9+yEZzZ16sbbHx4TqkzR0SA2oH89QXxXny61XkkGdDCcHwkmfmCm+rq5jthjw9w7C
         C8Mw==
X-Gm-Message-State: AFuF++ltJtR4y6XzBStFfb7jP7JSv49thuuQwItB9im7sCDyUlroKfc9
	Q08v/7Hka9fT4PgmkDttBTRmNXh6ImoKzrEzfRrzs42/HoD60T6xuD1GvLFUHsXZzs7Vuyevj/J
	ej7mYAT6yMDyM5iXNmCu1XHEjqqzyAws=
X-Gm-Gg: AYBFou0vLyq8VWgbPQWS7cEVircnIGnEYAUwXnc4zefiF/xOaRX1UTq4KVuHpIrPwuD
	uIBCxxrLAFK9M30fBdokiioF0oWyirjE5M8+Pdl6vuX6MPAbG2/MTwd/UYBVlM4s85lsoZtaXc3
	b65XpcuRO98+4g+B/kvbU9QMFMYp7h1qc/dR6axiLdaxZ3s/JLSvGix03bqlVv/HLtMPUyW2QUa
	eUBxWi8odbNnJqX6cp0a5o06XI3L5Td7ZdoX0uboGSAKDaahna1JgzBl2VYZyoCziA5vgc4CNJ7
	jWIWv8fhYKIOIj1uec/3YOEnH/eFu3UecDhe+K1VVnPvspKaCHFG5dHN51xp/HKbhmChHmn5iaO
	qhiXZJIJ4GHk8KzvCv0lb5ZA=
X-Received: by 2002:a05:6402:a246:10b0:6a9:8863:ada4 with SMTP id
 4fb4d7f45d1cf-6aa03f4c4ffmr3790992a12.3.1789547951018; Wed, 16 Sep 2026
 01:39:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260911-mglru-fg-v2-0-f26e5cb26da7@tencent.com> <EF8E0336FFC4841B+20260916074241.3373002-1-zhaozhengzhuo@uniontech.com>
In-Reply-To: <EF8E0336FFC4841B+20260916074241.3373002-1-zhaozhengzhuo@uniontech.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 16 Sep 2026 16:38:33 +0800
X-Gm-Features: AcwNN1UpOaSQEBAOnxFM7gGPIqShqgdOpI3fmggqN1N_R_GBYHUnJOQm-8PiMzM
Message-ID: <CAMgjq7BMHPxkEYfTOaaP-dXX+EDhOdG1Yu9O8yqaEUHoeBa5XA@mail.gmail.com>
Subject: Re: [PATCH RFC v2 00/15] mm/mglru: frequency guided promotion
 (MGLRU-FG) and flag cleanup
To: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CC2DC100003
X-Stat-Signature: ptdu8ibyxsmrqntzq6dkrpw5fk8wr79u
X-HE-Tag: 1789547952-217383
X-HE-Meta: U2FsdGVkX19JKG0LrRLilLUxgddGQ+2bkWZjb5z9mAi+Zhpmm8sWX9XDTIEQIG0vTXdymftNDCyGkOdhqs/2FcVq9m+e6esRIqUBmdoo9ewGg8VS+OY6WRqcOknpMEM4bDRdl9PUMPFarDzg5Y0evyN4sMAL7ROShkXeYPMVe4SPMUV06zFZDlcZRdePqrVEAmEKOVDNyq/gXSI+JY7EfBcAhpvviEwpDQ2p1EV8A1iesFKPwrAX1khTntjQFpy97Ci0Gau2K8BYvL8PtqPnqJPXt676EptQ9AWPl3Bb32MpaPpryctemPzjZHHU3fScQR4jCihgfYnM180tl3/PWrWrW9iYkGZSSm36emAkfc3ctoSUNm6w1bLmoHAgJA0S8MRKDjg9IYzW4Jpkrq1M20R/m/4MYIOHhtKkA/ALl20aIdfMofDOQsbTa+biK/tKC5Xw38aLvwZS8u8MyGqfzh31BdtS2oj6XCLHHbEwOF2rs05+bP2rfwD3wN9z6Fecxfzld3OekIjZsl/kImrMyO3eJjwOXK/bJQ4+/KkzfNqg+Xz66oCKefUpL86Ip2ev0z2uuSZv6ho1ToxXDd5rVoxxV2WQ8sUmG5goib8114DFKXm6G9Ac0L4WeE17SkbDDz0prqEiG/0gNrahXI7woAB2OL14neQF4gLTfmPUh2a/l88M/paEUhK15QMMjIP6cDTNw74QsYIHU3RdlHKs4IMGVNgGhJWdvFE26I14Hc8WUVT8lG+utpCqCxUC3yf6VdHmcng1yIgWYtcZuQbemyjo16jui7gY4C+7teS7WnK+KRsJryjh7kAVuv8eTrR1zqL9JCJ2U7QdZCVJVKeXA/4lvfmQKbqqG1VGZAtGTQG9FnQSlymwv28/kP4hW3t0jT0UH0CDvqggg2I+SP5N9hu/oGLboacrd3PWXSd3grGQBMPzqzVvm+YZTFf1acyfFsNhObUOq3ILnQfd3d7
 wD8i0UnI
 UAmOt6jW6KotSp12h+iRFYM7z58NEmw/mV6k2OryUYTuB0FxoIJUfzZK1Hgj5SCdXxtUvdpw2IvpsBP0h9uO3VS7UK5uRkHjxCZYRBt0qx95AOfGVjYyhz+6XpwwfNpvReb5yw3/pJt6dlBcGnTsrIVsY6qdxU3riK/hPXgSigNduXPlzL9G1/+LOV8gbKsyxs93v8AcU8FYfA0g4FF9CKCBqB5xbPmLP4TS9qmTFtP3JaqLVfS622PhfGce63bkLlBDQKaigq198jwC/wncc0g7IoBJpYD7CXfRyP6dKzmHlXNQ/t8UGYvAAXuyNP93mPqhV7AkD2TH1e0xPIhiVMYgwOR+cf/DwGHTHP0fpLgVbXOO/PvlGlcuIrRJ2fMSNS+sfuBh99WhbaYmR0KIauRLkSSyyV8eULikfUF+fj/YvLQ5yMI1Vbx/kEyF+IvIk8y+rR3ZXxHV2BpmS/bK8y+aIm1ZesYRI/W5njD3iMDfHZ1fEpXvxgKDEAYCn4BvuVmsoQg89eT6VuZ6BlVloa5ErBxnGnPYAv+rbJmE3euY/0rNBX/ZT4zGHJlY5ol4l25pBiRtwcMrCjOC5k9lsb5nFZ9nPaSRqyj8D2hDQloS3brxw7hlude7X87Fjzu90s65fehCIPSeaZRJaJR68dVqBCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 3:43=E2=80=AFPM zhaozhengzhuo
<zhaozhengzhuo@uniontech.com> wrote:
>
> Hi Kairui,
>
> Following up on my earlier v1 test report [1], I tested the complete v2
> series on a small WSL2 box. Applied on the stated base-commit
> 9958290885035431e2494159f555e332c3c14906 (mm-new): all 15 patches
> applied with git am, zero conflicts, and the resulting diffstat matches
> the cover letter exactly (20 files, +812/-499).
>
> Environment
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> WSL2 VM on a 32G Windows host, 12 CPUs, deepin 23 userspace, swap on an
> NVMe-backed virtual disk. VM memory was 15G/4G swap for the kernel
> build, fio and sqlite-grep runs, and 20G/8G for the DB and browser
> workloads. The distro WSL kernel ships without CONFIG_LRU_GEN, so both
> kernels were built from the distro config plus CONFIG_LRU_GEN=3Dy +
> CONFIG_LRU_GEN_ENABLED=3Dy; the two kernel configs differ only in
> LOCALVERSION. MGLRU was toggled at runtime via
> /sys/kernel/mm/lru_gen/enabled for the CLRU/MGLRU split, as in your own
> harness. Workloads were scaled proportionally to this smaller box as
> noted below.
>
> In summary: no After-vs-Before regression anywhere in my matrix, clear
> wins on fio miss rate, Chromium&Node and sqlite hot-path stability,
> both MGLRU modes consistently ahead of CLRU, and classical LRU
> untouched (MGLRU-off runs agree across the two kernels within <1% on
> every metric). Both kernels survived ~8h of heavy memory pressure with
> zero panics/BUGs/warnings. One caveat: your +13.4% MongoDB gain did not
> reproduce at my scaled 12-thread setup (+0.7%), but no regression
> either. Android was not tested (no real device here).

...

>
> Tested-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>

Thanks!

Glad to see this is working well for desktop and smaller devices, most
of the cases here are for large servers this time, with fast storage
and maybe WSL has double caching of files (not an expert on that) the
effect of LRU is limited. The result still looks good, which is good
news.

I tested Android and deployed it on my desktop look alright on my side too.

> Thanks,
> zhaozhengzhuo
>
> [1] https://lore.kernel.org/linux-mm/92DCEFFD13221261+20260828102344.1537=
874-1-zhaozhengzhuo@uniontech.com/
> [2] https://github.com/brianfrankcooper/YCSB/blob/master/workloads/worklo=
adb
> [3] https://lore.kernel.org/all/20221220214923.1229538-1-yuzhao@google.co=
m/
> [4] https://dl.acm.org/doi/10.1145/3731569.3764820 (artifact: https://git=
hub.com/cache-ext/cache_ext)
> [5] https://github.com/ryncsn/emm-test-project/tree/master/sqlite-grep

