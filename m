Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE887606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 03:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Afjc+tzM
Received: by kanga.kvack.org (Postfix)
	id E34B06B00EF; Sun, 15 Nov 2026 22:53:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE4E86B05B0; Sun, 15 Nov 2026 22:53:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFB806B05B4; Sun, 15 Nov 2026 22:53:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A52206B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:53:11 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2F2081A0893
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:53:11 +0000 (UTC)
X-FDA: 85439611782.04.49D385E
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4C74FC0003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:53:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Afjc+tzM;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794801189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4TL7rU67dcCsld58oJYx+NVlFE0fH5IBsAjLGvpEK3U=;
	b=aDfMPwXH2ezGrsus/poTOHIDvE9Txfpzpa9Sdg7R5REnxD9Q8AC2yHik55b+kIgM7Ykbcr
	OlEXdFr+/wQWyRpcfAHihpCC5TNs2C8G8RPrXwIyXousT4wTqZrD0yiM++sRYTSfle8qbw
	UsiqMPPj66TnB27IcDEuXxhhZl2VvJc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794801189;
	b=jcGrUSZ6BxxruR3LfhisRRkCe+o3jSKyOrIrhXquRd7eWI9fktlUI+VbdnIsfT3dwpm30G
	51zUInPkl8X/cZp6EA5BAhi2u/gUYvlDj/SKgVI3M2pCSukNA1M+nizso89S6cIDsOIOZA
	WDvgmCFKxSMRf7YdIWxPe2s1gikMkTY=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Afjc+tzM;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6b704171bc9so3914461a12.0
        for <linux-mm@kvack.org>; Sun, 15 Nov 2026 19:53:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794801188; cv=none;
        d=google.com; s=arc-20260327;
        b=WJQOBcZtadoMIhgfAMrJ1lGPBN3sXHEShPs6w6MU9hPZ2sXh1rhnsPVMDbqVH5/kFN
         gP0cC94j88DPTy5/4/R601BTDAm4FVE2/SuNg2VMFO8/DHwnQmnnJNknAO3BE4fFrsi7
         x4bl75KDXbiD0ce9CnqE+X42/IGHN9u0UVDfzlGf3iD4R+xBJeiQicHoBxnlg9pczA0Y
         maSC217ZJBmt9hyioMM3MeEVD7uUzv902Xov/WZ/MPOhJWJYD9fpdlWDKnXp1enFHbPm
         Ql9mTYlzDUzMkd6Vd4WAvLkhvRAeHcl12VBA0WQ7C6VlfVAy8e9y+41Ue/go8WQB5/LO
         A31A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4TL7rU67dcCsld58oJYx+NVlFE0fH5IBsAjLGvpEK3U=;
        fh=fSnpxyQFzYBuLIUxwelhy4CB2h483iJp3FJ3zS0Haxs=;
        b=EBBbweo2wCisPYWnB9QvMGcVgjK/wQMju6vrqzvAlMk5zdiBcN9Cfwj3so7is1voax
         NNGwhD/jrg7UtakUjTO4LIXALKh9DwDzWKejL/FJlUwi4BFd/SYRSeWiYxeY4pW/cbQn
         elfcHoJFtbW5e4tcJXuH+9lKX8N8cckx0br2hVaoqvEyDlmOtqvVhwaRyQhO5OR8xbBP
         CDJZMh/Q7EN4iBaaS6K0gGDNxzHKzcI1Qng8+dXmJBMnkkA/TybTYbgCzusTMeIqTvWk
         M0JCNL7ouJd32FqOWEsJLpRRbtWjkUZrIdXpaF/prSASjdd1BGCZE7VfHDozxKJhvVCa
         upHg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794801188; x=1795405988; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4TL7rU67dcCsld58oJYx+NVlFE0fH5IBsAjLGvpEK3U=;
        b=Afjc+tzMFSbUbKexWcbDwE/UX6mM6GBiljmgOr+urguwimnFeiYoAYZKpwxZ11QmIl
         tivnxXzdWIV/9Gkr/5TkRdQ+PG9WOVNIp0QRHLgBxXsFI5mM+AsZGArIXZT6o1IA8Tx/
         IjJKb/XMCaWxjxLX5OBdmjhjD2EefSqt8qtNmfACMXUpHDfUrULwYfESTM0uoaOVkQBq
         rmAr845RpIv8DPi4bFkouEO1g0Vfrx20PO27IjVvxmdwlU0sfqwIu36JBGYxmpxBG+ce
         Iev4aMvyKkiSLQGPplTMjE12fgL53QMyYA7q5CgMxowUaYX/OLWmxqZBAsIrJEWDI0h2
         ru9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794801188; x=1795405988;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4TL7rU67dcCsld58oJYx+NVlFE0fH5IBsAjLGvpEK3U=;
        b=flwHFHyS4n6yPKir4FyncMLsp7dk2U57DzEY33QWW9bpg6ZJ7AHlF4XIGftljlO393
         VcVTEXO/2iLsE/D374NV2tIaWV4JpeYHn6Q1VFGQt+4tyaSZ/4GIK97YSzSfLlszPoRS
         JDUUn3v8bpYS0Uc5bIKNYRmTHeF5DLGvn0w/G/hoYWR/evzj8ffGDkfKyiZhZccbBKaO
         OSMo7RUBgcZMkX3jI5gjG2metaFN1pfxKg1J7EkpxXb7J3SHX71o83brBliLx/JMMYfw
         o6lrCKlrHNpgzMDEaFpQ7kwUwgB6bRuXcg0/fJXAz1c1UzHiH0W89crVjuJgRCqNVbfh
         RWyQ==
X-Gm-Message-State: APuU4Z/Y7zCWzGTxgRo8oyTPVs39AMHU1BMKsg2kLhObJhaOEGRA3IR1
	sjJzWW5X5bW+9xNPPmiI4W0jwXEkXkZT6Xn90Gb2W69SEnypx7+jxrIF6wt17vV8jLTD/y2FmUr
	g8HZQOU3klhvTO7ieB/gXK2qxvBPON2A=
X-Gm-Gg: AYBFou2uzCNziHrnjR+ETOLbHxQ0A3lKWyk7moLEpOtzEGMmRkPWT+WQFEdzcmQDWSX
	VAY/ytpHsfvv5wyneK8VzOuXayGWyJIf7GbnQuPLPOIHNGkvcjxK8Pn+wAsjCXoawAYXd32Scqz
	loIpyhye6L1kJmmO2Sjwy/RTv9PSmvqQPDdPn6t05OUihuKC5ZVThd2IePT5Hce+HBkNpa5OgBx
	+HW13tDsXYs4KSRQT609qwXt6fW85yxea/ddN5euxeK95gQN9h4iWl9zEdQl5a+exyQsMwApSbK
	aXMR8/MwlcUKkEEJvGcY/ot083ZbzMILrta5BT3WtIO6favmChtLs4jl5p/N7+QaYhV1+N/Co06
	IKp1oGjY5BJ5yZD7ch2GC0m61iTg6uhT41sh7T/IHDHThVznHNQ+LgBlAAtKPH+nDnTVaNg==
X-Received: by 2002:aa7:d94d:0:b0:6b6:ef7f:600d with SMTP id
 4fb4d7f45d1cf-6b7c0bdfeb9mr4989199a12.21.1794801187760; Sun, 15 Nov 2026
 19:53:07 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <cover.1794666741.git.lianux.mm@gmail.com>
In-Reply-To: <cover.1794666741.git.lianux.mm@gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 16 Nov 2026 11:52:30 +0800
X-Gm-Features: AclHuK-rF5dWOJJFyqz4l7zmtSSFEl92bKNMjIKJVssyOdhF23YiFc9B9U-bN9Y
Message-ID: <CAMgjq7Cq5OQWdompBbEpyJTG3PhtdSLFUdb_Dtht3qH+u5HVhw@mail.gmail.com>
Subject: Re: [RFC PATCH v4 00/18] mm/swap: introduce priority queues for swap
 device allocation
To: Lian Wang <lianux.mm@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Jihan LIN <linjh22s@gmail.com>, Kunwu Chan <kunwu.chan@linux.dev>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, Thomas Gleixner <tglx@kernel.org>, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: adau7njgzy64o47y8k3ff85wan53chxy
X-Rspam-User: 
X-Spam-Status: No, score=-1.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4C74FC0003
X-HE-Tag: 1794801189-786043
X-HE-Meta: U2FsdGVkX1+vCJv8etdtM3uUip/R5TgiXyCv+gPGM6jSmQKzQesYpy8TUjoJc4YT8XaD0z95xkutRD7+r7K0pc0vS5+PJyBcaA9Lv6gNUT1cWFq5NIonlNGnQHxUIKcG6RE/DxBisA1z1rRHkH0v30pCEaQr7QFoP5waZ4xoNLuXfGMHR3LvJg2JhWAMtwxhuqBdXbXC0FyJlKAV6a41WFhSVF3p6e9FZ33mM/CnBXAadbTIioPYzuOF5UpCgUDkFY/D97PymQE81Hqt6PQlreO9NLRoCDNp2tTnuHKu9wfzyZK35DV3eIS5hl5Hn7diW2wi2ywdFeaWJeL5WXTzNCderR9PvBjN2sfiQJaVyXWNBN9VdofZJfJr8YK1WVSoNJ95aA85I2Bs8A8dBgR0MKdNSbSD4sqrjpX64oRZe6fB3K3sH2FMg+NDmkfiNSrKoQJr/ySVJUAWnCfpIoSCV59OaD/OWbvoG09yK4BJy1B3YTjXlPe7vc9snvQcyXkjRaT0RhOYuvCcYuU5bq9b8RH8WqeqYqVazLU00CpQQEYkfn9M9vEtFXzNB77Me4EynM/q/FBktFwRN3O1rj2S2PspY3k4xE+p4XVwg77R/lTSuoVulxo/EjDnABBWTzU3KmvNXTvUb7AYHA/NuEq5yWAD+5XI/eJKkgvxlyJvbqoi1zyblpkuD5fwbljhTdyiYbJWLmiDyOQWm6VoriTtAJSMVH+uIr6ERC3PHF+bzw8EeqTC6UMMzV3G2oJHgK107S0ZlDHWal/Lf3lKitVU3AmYrv+b+It/fXst+7mTXaRDj/B1vmq73S9A05fbuxzzq/xz+6f8TAYyaHEF2W5Q6iHFjO2Png4F9URw4+Y3/TxKb7B3AhH7oiqGQhRRh0rXtwdjN/i35FcyECuPvAKQOPH6G8bVzdu3JA79gsGiDSWuLE/AxZom/lWRvsc5rPMoYYXGggCzloUaBQzHzoa
 wS1qQORi
 blNeuiysUP/cSGHgCciQf4kBuKSwWkuQ7M16Di3k4/TREFXw879L2jCaLE76Fgl7TGDX/tOY0G0fCadfLiuPqbjFZUWpQGNo79qgtYRaD8nrbbP9hySRjWzANBVy7lyR6vvYHuY8HQDq3an2CLg3u4BQiELZvV0b2bBLPQuRw+RDKYHtn588adFa74jtMVziXqHyKGs7jW0XodzNMGPN9eahtobCDiFLM0J0YNmD68MdIbxEYP+FJXrpB+93ieaDDgndMflq88UlPrjmzZMzT5Xu/H5SF6rSCUhzQgf09DE/eKgD2Y39WcPRE6AeBu4Dl1jI6HGq4uHm9D03SSJl9yXB9zctcyDn5IlshfvIXzoVxVLdO90yo0YiV9IuWFidJrK8yGEnC+GYJfZSF0GgQH6kFo5Eqi3BKcXtIuA9bn5gsMyqOeOfn1fvFV+7nSWdcU2ebkxVHHe2p7fxG/0LRFiQdwXGtjpY82qiW/V30GoWvLicHtJGvB8gNkQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 14, 2026 at 10:48=E2=80=AFPM Lian Wang <lianux.mm@gmail.com> wr=
ote:
>
> Hi all,
>
> This is v4 of Kairui's swap priority queue RFC [1, 2], retaining the
> original authorship. It separates device selection from device-local
> cluster allocation to support integration with the ongoing swap tier
> work, while preserving existing swap priorities, the swapon interface,
> and memcg swap accounting and limits.
>
> The global per-CPU cluster cache couples device choice to cluster
> locality. Moving that cache below device selection gives each device its
> own allocation hints. The available plist's shared rotation is then
> replaced by a priority-ordered array of same-priority device rings, with
> per-CPU starting offsets and quotas. A task-local cursor keeps each retry
> walk stable. Rotational devices retain per-device sequential hints shared
> across CPUs.
>
> This remains an RFC. The current scope is global device selection under
> existing priorities; no tier ABI or per-memcg device-selection control
> is introduced.
>
> The series is organized as follows:
>
>   01-04: Parameter/error-path cleanup, device-state boundaries and
>          iteration helpers.
>   05-07: Locking, writer-serialized publication and accounting.
>   08:    Restore per-device per-CPU cluster locality.
>   09:    Keep cluster metadata population out of direct reclaim.
>   10-11: Introduce the safely published queue and remove the avail plist.
>   12:    Bound order-0 synchronous discard outside the allocation reader.
>   13-14: Preserve priority-aware throttle selection while removing the
>          active plist and unused plist_requeue API.
>   15-18: Reuse reader capacity, advance cursors directly, bypass singleto=
n
>          rotation and redistribute reader phases on membership changes.
>
> Changes in v4
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> The device-disable and discard paths have been revised following the
> review of v3 [4], including Sashiko feedback [5, 6]:
>
> - Complete writable/off-list/availability transitions before releasing
>   the management lock or topology writer, including intermediate patches.
> - Run bounded order-0 synchronous discard outside the allocation reader,
>   holding a live device reference across I/O, then restart selection with
>   a fresh cursor.
> - Handle discard queued by late reclaim scans, with at most one
>   synchronous cluster discard per swap type for each order-0 request.
>   Preserve large-folio same-priority retry and split handling without
>   foreground synchronous discard.

Thanks for the updates!

>
> Rebase
> =3D=3D=3D=3D=3D=3D
> The series is now based on mm-unstable 24231596edf2 (7.4-rc1).
> The base includes 53a6f71c147a ("mm, swap: stop cluster list scans once
> swapoff clears SWP_WRITEOK"), so the former standalone scan fix is no
> longer required as a prerequisite. Its si->lock serialization of
> WRITEOK changes is preserved.
>
> The metadata allocation paths have been adapted to the upstream
> allocator-lock reacquisition and publish-after-revalidation contract,
> including -EAGAIN handling and the tableless-cluster relocation guard.
> The upstream free-cluster preference and hibernation-slot semantics
> are retained.
>
> Test results
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> The tests compare the unpatched baseline 24231596edf2 with the same
> baseline plus all 18 patches, fbb87083afcc, on the same x86-64 host.
> The kernel configurations differ only in LOCALVERSION.
>
> The kernel-build tests follow the v1 workload: eight 8-GiB ZRAM devices,
> make -j96, and 12 fresh-output builds per revision in each of the 2-GiB
> and 3-GiB memcgs. Both revisions built the same workload source
> (4dbe24720eb3), using x86 defconfig, bzImage/modules and a fixed toolchai=
n.
>
> The BRD case used twelve 8-GiB devices and a memcg with 24 GiB of memory,
> 64 GiB of swap allowance and memory.zswap.max=3D0:
>
>   usemem --init-time -O -y -x -n 32 1536M
>
> There was one complete BRD invocation per revision. The BRD capacity and
> memcg limit are host adaptations; v1 did not specify those parameters.
>
> Mean system CPU time, seconds:
>
>                          n/arm       Before    Queue (v4)     change
>   kbuild, 2-GiB             12     4372.4983    4417.2192     +1.02%
>   kbuild, 3-GiB             12     2314.6025    2322.6550     +0.35%
>   12-BRD                     1      143.5700     137.9900     -3.89%

Nice, but what does n/arm mean?

>
> Mean elapsed time, seconds:
>
>                          n/arm       Before    Queue (v4)     change
>   kbuild, 2-GiB             12      168.8092     169.1100     +0.18%
>   kbuild, 3-GiB             12      136.0650     136.3500     +0.21%
>   12-BRD                     1        6.6500       6.5100     -2.11%
>
> For the BRD invocation, mapped throughput was 7391.28 -> 7550.23 MiB/s
> (+2.15%), calculated as the requested 48 GiB divided by elapsed time,
> not as a sum of worker rates.
>
> All 50 invocations completed successfully, reported no memcg OOM events
> and performed swap I/O. There were no warm-ups or profiling, and all
> samples are included. Before ran first on a separate boot; the 12 builds
> are within-boot repeats, and the 32 BRD workers are one invocation.
>
> The kernel-build runs show small increases in system CPU and elapsed
> time. These descriptive results do not establish equivalence, absence
> of regressions or a stable performance gain.

It's worth mentioning that the global cluster cache is gone, so tiered
allocation will have a much better performance.

>
> Cooperation with swap tiers
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> Device-local cluster hints remain below device selection, so a future
> tier policy can determine the eligible candidates before those hints
> are used.
>
> The current revision keeps the refactoring under the existing global
> swap priority model. Integration with Youngjun's tier infrastructure [3]
> remains follow-up work. Device membership, swapon/swapoff publication
> and lifetime should have one agreed authority. Within-tier priority
> semantics and reader scope need agreement with that work; this series
> does not define a competing tier or memcg policy.
>
> Youngjun and Chris, I would appreciate your feedback on the integration
> boundary and ordering.

It seems the sashiko review is all green, which is great, let's hear
what the others think about this.

