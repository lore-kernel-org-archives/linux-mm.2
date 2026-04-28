Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D8D7FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 13:51:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B06646B0092; Tue, 28 Apr 2026 09:51:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADE226B0093; Tue, 28 Apr 2026 09:51:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F3A06B0095; Tue, 28 Apr 2026 09:51:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8FC276B0092
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:51:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6374D401A1
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:51:50 +0000 (UTC)
X-FDA: 84708102780.15.7092B7F
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id 66D46140003
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:51:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Do6+tM7h;
	spf=pass (imf23.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777384308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IT9jA57kngE+X3yajSLSMobQf0P1+rq/CPccLhdmIvE=;
	b=t1qfL5em+KEPx/W5E9xoM1bxnzqX1fWa0dJKayxZfW42fBKBbsGGQa7g3J6iST1cIYKFWf
	vVVd1oq+qAnfedd2Z+YmYvbdj+QBrSgmaFiVRk7ZI5F2bsWp/h3/WR3ssO85RDRo1hsptO
	QkopswabwuJBrXYounKEKayq04P9UCU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777384308; a=rsa-sha256;
	cv=pass;
	b=BEyvSixPYRAizX6pyw9hsQ+31Yc6O3ZavTqwe9t6VwwfrlF9nZUsjWj0FvhIbk6YmmnCmv
	lSJOsxuuRPJo8eEiNqlevJIPDKK+forpVviVANrLev+qDLbktmD/T3RuVzTAqkDmhq3s5A
	RPWIeNqCYPyZ8Exce4qLmpLqMX2Vmk4=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Do6+tM7h;
	spf=pass (imf23.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-7baee75f874so97212977b3.2
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 06:51:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777384307; cv=none;
        d=google.com; s=arc-20240605;
        b=NiS1XJGqFg8Q3GEJHD6Y2eo40Z1k/QFIB5zvdkBpqZvgc42X12p+cHmH+CY1HKDkVR
         NSOHnq0SjDr54drZ0cdrg2poggCMxUPKegSiGzhlB40Ct6nzgyPTWimM/TNKGkaQ9FGc
         fR63VS8W/mara2HWApEEmGCVuZnsMFVB1PGan9zb+c3IPSBvsMaA0t8OJaTZbcWYe3NR
         88Pe/LciElOYxkzqrOPNlTH14b/NptU51zxZ7oWVGinUXQnUwPDqua7h6pe7l47ZUVBT
         v3Xzu0vcuS73iT9uN/hIeg3lBWA1g6BHcx58HKMSTqhgRSBVHosW2UJRMfIPU2p4zOy4
         5Mdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IT9jA57kngE+X3yajSLSMobQf0P1+rq/CPccLhdmIvE=;
        fh=MkpxcMXqBIQJ5jttdO5XnIj25am0xMFs9Ogja15tbVw=;
        b=NzSlG+dmErcvtg6MuBIJLge9Ciy/ZK2p1+n6Og0KfL3vs395RndpByBNcpOHR32cJI
         yq/ShdyINWxeLteABQDoYSTZrXZ3yKhayUOr3WJtHN6Q5JAYO2KHDZHjW4h3bgbe3w29
         SAkO0H/gh72I1JD+X6OO4zEKoesw5Mdn0ATVj7k5ryhoO4LtNgtSsL1UNp7qE8RCFoSl
         OHi7u5QSOp7vkFMYwBOFrvT4Rj0UllSWf+qg++/ftBUYQ1aRDULnJ+Aq4zlHe8g6vPWa
         5z6TW97oesxqUimJvgW+8h1EC/3SvV/y4rHktRDlXo/uBiz5Rr31pjz6wUPjs5seJadz
         1Hlg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777384307; x=1777989107; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IT9jA57kngE+X3yajSLSMobQf0P1+rq/CPccLhdmIvE=;
        b=Do6+tM7hvO/R8OrVvCmecnFytYFmhx+pVRQ2rcNdNlEIDLIPP1T1meGwzg3A8bPBtx
         dKWgbVc6BF4i9QinXS/MN03xFRlYC9SxQezvr8405dB5A7PEgnhE01tyDVNu0msUe/PL
         /tykMtaGKPCCL1Lzruo7VC0C5bmRnjo8CTN4Xo9S9T7JJ5i5jVOymLNtrL2U0+4EoyrA
         g764a01s4L9komz1BFTD/xzUlyAFrkCeZ3032L7aQMPArkUI4e4HVmyDLL3UkEB/uTX1
         HrIeO35mu0SGetCRFYzrlR9SWGuDoSOBANoxEiNHzBROEUIcgpzFr/gqBKNQVo4QPZEd
         2Vzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777384307; x=1777989107;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IT9jA57kngE+X3yajSLSMobQf0P1+rq/CPccLhdmIvE=;
        b=eeZXeX0glZCrE1U3J0IptebHuvDzHY4QyLXCDKRLx/bXq/Lk6JBdOa76FKdhqgZkhw
         4V9cOXyBM/D3X/gITVGABfAIm7XFVSXci6lv7OopcX6JJpAoF+zZwY8rPimdshnqFKmA
         h+tduDIfLJwCuo6PMsEql6EzG/OzBi5+acgrMy00Y2QmSHlbqZr7AbrE2vIKb1ECdMGo
         Kbuh03TJUHhcKP1ZE6HKOCE4PH8kheAQKZIwHSIZNRnP8yIxpFge2lwkX1V2FyRGssOM
         PeAyddO2k1H8/hcJcb87pyCHDqsu2S4SKEqTlbtGkndGUgMZgZYEaj5yXxtfuLNttzwR
         CGlg==
X-Forwarded-Encrypted: i=1; AFNElJ95gAlJPkEKgUMtyRxIIlW5wj7kFLDUR7p6SH/3mUxP/RZSbafMXnCxJl0xcXj6MaV0gblozWIRJw==@kvack.org
X-Gm-Message-State: AOJu0Yxlw0SG24GoC5H0ovUmIWpksTbJYoikGbS0oxeTWPC2TdLEe+Jr
	eGyP6YoeknkHDJsfvkVWN5frs9HQzfxowbexdaMzQv+hduC3LugUZMsyjxNM2YCLN4VlozDzn/G
	llmkqM3C7OGbjIgwqAOyonM90VC/HpBA=
X-Gm-Gg: AeBDieucbaQWj0q8dbhwdT0nwzKFZkQzDyj2OP6+3rNzhTDrC9hnM3H6fGxgf84g2wJ
	ypcxvAl597U0zByb/AGMtFNX9kdnqDpb5X/EN6WJTdfVRW6+nwSAdK1m/Hs2CsWRBdrZUhNsUmc
	8fN0DNmue3notJHFtaVDmrtppv5HoX6o+y/HHG3YHn4mWvYdX4XYA4pHaTrdK2Tv65qkIGq0G5S
	wA2EGzR+lLSd9LbSZKXZUoCdQDB3ItsQqsk4wtA8LxsqCrZ2o7cif3S4EMImZtgDl+aEd1SHlru
	hMn1vkyLGAqzPmWBfdrxfVZZ99oN9A==
X-Received: by 2002:a05:690c:ec7:b0:7ba:f129:3770 with SMTP id
 00721157ae682-7bcf50d140cmr28884857b3.5.1777384307109; Tue, 28 Apr 2026
 06:51:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260421121616.3298845-1-haowenchao@xiaomi.com>
 <CAOptpSPs-1UrEa8AHg19e590=SiV6bpnex7gCbif8=aY7BtpuA@mail.gmail.com> <CAO9r8zOjugCwWqHP3zxXPmjp8TwpoROCjCqTZ_uxOBQwVqCWqA@mail.gmail.com>
In-Reply-To: <CAO9r8zOjugCwWqHP3zxXPmjp8TwpoROCjCqTZ_uxOBQwVqCWqA@mail.gmail.com>
From: Wenchao Hao <haowenchao22@gmail.com>
Date: Tue, 28 Apr 2026 21:51:35 +0800
X-Gm-Features: AVHnY4KQE_Mj9gpvMzdnnS_asaY09442_U9fmG6eXMks5pomkHazCuttZ-HneD4
Message-ID: <CAOptpSMQyyb+q-VJdJ0RzNkjaer1CTePM5WkwEj_7cAO4aUToQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/4] mm/zsmalloc: reduce zs_free() latency on swap
 release path
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Barry Song <baohua@kernel.org>, Xueyuan Chen <xueyuan.chen21@gmail.com>, 
	Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 66D46140003
X-Stat-Signature: pdat5b9iz9jo43eda7kr6odxu3d6oktb
X-Rspam-User: 
X-HE-Tag: 1777384308-768447
X-HE-Meta: U2FsdGVkX185TGQyQ9fbJnsDjynTg7fPT/nPj7F8TBg9ZYRZtmkvEBxHVMx6j6V4mvvpDITED8hlLEkwk0khV2Sf4cUmeKtRlX89OVOWIqcE/7xOHJ29S61GEymYjEIw7kkIeeBYakQ5+z1sQgKKFNJJY0qqIWcMFDkDY84Ug+aKjlEdR+GXBh/52kbMwSpo4h4a7VJa8EraNFHxqQrZgNUTIXJ1RBrs2bVPDe42Gs97Vuy2q/rjCnIFfHF2GEdjJlSQ6VtexAlPrwePK81APG8viX0mDp655+p83NKDVBugDXxxm6WBAVAhAGL1fQgEczGb4eBbg0RhJmL99F7NVPVis0dRe1oKuriNz6ExJuMVkU7jBOdd7Pd5g2YmClGo9VyTmACSOOOuDd78oXdLtbpzD7RQpF2rEBCGo62MSriU9pHwcU4Q4Un/CALep/PlMc08zLnm5YYtEDjpFZNZLi/y2lGXRZXuRGQbCwbo40R9fYtpYF8O4JkODUkYlHoSy85OPwYPUVq8PF6nlWpdK/G7pohnKLh+MERjUSoclWMdu0lVV4xHpoduSwAVNv2Vf2r+OacYYBzVbxdbOnV55p1YDTnoJXBsIHWD1bxhlvIZCPEdKE4y+3pUuW6mm4GbTFpd35B53KIvNk3mqxDajrX1BWZJCZE4cuyZDTuMv/Ndbq3Ro56fwijgIZ0SPNK26tyc2jl1o8p24hpuu9oa2t1UMnBuTIIG1bOyP8LwmHnC1ZOZUKtRxY75SrQhMjf6m2m4OS889s19+bgBBCG9NRmg8/x4R5JXnHilANKOMFSJpRrCjAyZwjmOIxef4+RuNNsvaFWpAYmIX0OEFmKFCk51AfiSEaZxqMfFhfFpeObv7yRf8Kt94jx9CAxVk5XIqKvhg/ViMfU/4bOSy49qe3TaaSZxOwqsyUa83hDcEngYVPGX8m+pKP7sXjUU932qxast6fsbyOBsvVBJ95G
 IshcgkZb
 1mIp4IDEA5bCopeIF2jr4ucR8FTvhofgCEUItORBgsNg+C1fiPeiTvKf/Pa624NYUL1xvjmR0RjNNDLwngL3vCwIHHQsc1LtHDO/JiH7vACUfp94WuvGRUx7HgSCBdqZ41j6IzIBibw92XdY0G/uuWDkYaSvksubhsBB/Z+fMk1rzUSVf02MaI00DI2F34KYmQKhdIGKMcwYotyU4DRofWj27RMKP/flWJzWH0JPsgvcwnO9y4dh/gnd7ZkqQzM1+Oe9xFIYmxQ0eGU5wSTP5narftQLHSvl/cl/oJs123SaXANAEfeAA2aklJZXuUjeBJr75ytKwDS0n0orJGJRJsv46Ja+ky4t0EqjiPwijPUeS2h0HVaqK5RcqDDkpRJTZPyvuNme8tm5F11+xrB8ohniVfbC0VAJBuTa7UGdTUR0TP7IzWpM7hzPoVXUs2DPExX2x4GaREuwFaLE4RzKVSNKvUDwl7evWyCsH6QwGq6TC+3tBDFb0GpiRPWD2pHYvQQDwqpCxwJggeJvgmXgybFZJi6NRA4PC5XSfjBgEBLIpfw7yZzTlbP8TKxzghuBUwNqu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 2:17=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Sat, Apr 25, 2026 at 9:13=E2=80=AFPM Wenchao Hao <haowenchao22@gmail.c=
om> wrote:
> >
> > On Tue, Apr 21, 2026 at 8:16=E2=80=AFPM Wenchao Hao <haowenchao22@gmail=
.com> wrote:
> > >
> > > Swap freeing can be expensive when unmapping a VMA containing
> > > many swap entries. This has been reported to significantly
> > > delay memory reclamation during Android's low-memory killing,
> > > especially when multiple processes are terminated to free
> > > memory, with slot_free() accounting for more than 80% of
> > > the total cost of freeing swap entries.
> > >
> > > Two earlier attempts by Lei and Zhiguo added a new thread in the mm c=
ore
> > > to asynchronously collect and free swap entries [1][2], but the
> > > design itself is fairly complex.
> > >
> > Hi Nhat, Kairui, Barry, Xueyuan,
> >
> > Thanks for the review. I agree with the direction and have some ideas f=
or
> > an alternative approach.
> >
> > My approach: first eliminate pool->lock from zs_free() itself, then def=
er
> > free to per-cpu buffers with a lockless handoff, and finally reduce
> > class->lock overhead during drain by exploiting natural class locality.
> > Achieving both per-cpu and per-class is difficult, so the class->lock
> > optimization is a compromise =E2=80=94 but one that works well in pract=
ice.
> >
> > 1. Encode class_idx in obj to eliminate pool->lock
> >
> > OBJ_INDEX_BITS is over-provisioned on 64-bit. For example on arm64
> > (chain_size=3D8): OBJ_INDEX_BITS=3D24 but only 10 bits are actually nee=
ded
> > for obj_idx, leaving 14 spare bits.
> > We can split OBJ_INDEX into class_idx + obj_idx:
> >
> >     obj: [PFN | class_idx (OBJ_CLASS_BITS) | obj_idx (OBJ_IDX_BITS)]
> >
> > OBJ_CLASS_BITS is computed dynamically as `ilog2(ZS_SIZE_CLASSES - 1) +=
 1`
> > (8 bits for 4K pages, 9 for 64K).
> > Since class_idx is invariant across migration (only PFN changes), zs_fr=
ee()
> > can extract class_idx locklessly, then acquire class->lock and re-read =
obj for a
> > stable PFN. No pool->lock needed.
>
> How much of the benefit do we get with just these locking improvements
> without having to defer any of the freeing work?
>

Hi Yosry,

Thanks for the review. Great question =E2=80=94 we tested exactly this.

With only the class_idx-in-obj encoding (eliminating pool->lock from
zs_free, no deferred freeing), we measured on two platforms.

Test: each process independently mmap 256MB, write data, madvise
MADV_PAGEOUT to swap out via zram (lzo-rle), then concurrent munmap.

Raspberry Pi 4B (4-core ARM64 Cortex-A72):

  mode        Base       ClassIdx-only   Speedup
  single      59.0ms     56.0ms          1.05x
  multi 2p    94.6ms     66.7ms          1.42x
  multi 4p    202.9ms    110.6ms         1.83x

x86 physical machine (4-core Intel i7-12700, 2 rounds averaged):

  mode        Base       ClassIdx-only   Speedup
  single      11.7ms     9.8ms           1.19x
  multi 2p    24.1ms     17.2ms          1.40x
  multi 4p    63.0ms     45.3ms          1.39x

Single-process shows modest improvement. With multiple processes,
each read_lock/read_unlock atomically modifies the shared rwlock
reader count, and the cost of these atomic operations increases
with more CPUs accessing the same cacheline concurrently.
Eliminating pool->lock removes this overhead entirely.

This only works on 64-bit systems where OBJ_INDEX_BITS has enough
spare bits to fit class_idx. 32-bit systems don't have the room.
I'm still working on the compile-time gating to properly enable
this based on architecture and page size configuration.

> As others have pointed out, I don't want to just defer expensive work
> without understanding why it's expensive and running into limitations
> about why it cannot be improved without deferring.

For the deferred freeing part: the class_idx-in-obj optimization
addresses the multi-process scenario where concurrent atomic
operations on pool->lock become expensive, but does not help
single-process munmap. Deferred freeing moves the entire zs_free
cost (including class->lock and zspage freeing) off the munmap
hot path, which benefits even single-process workloads. The two
optimizations are complementary.

Thanks,
Wenchao

