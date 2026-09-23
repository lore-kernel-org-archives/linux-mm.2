Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 635A1C98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:55:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F1546B008A; Wed, 23 Sep 2026 17:55:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C88B6B008C; Wed, 23 Sep 2026 17:55:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 604F66B0092; Wed, 23 Sep 2026 17:55:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3A6D46B008A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:55:13 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B3B03C0129
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:55:12 +0000 (UTC)
X-FDA: 85246383264.08.9225BA0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id D7BC520005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:55:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cgw3afYu;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790200510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SpXPGh64kpxQKL1N904LXrN6hkR3B6eHCfE5NZYijII=;
	b=q232VpoEqsHBk//GC/9uOC9Ti30smMpS5/t0hszoVllXxp4/fljF0Df8oEFzwwitOwhh+I
	ZIWEoJpazDY9NeVQLG5zpzoAX0APkimNkkbXGX+5pt1UEuogVv0KMgEuRcI/hyuuVUcwzb
	8qmiSxHLX5zYD3hYd0cPxQzPIRliNKM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cgw3afYu;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790200510;
	b=MJTzv3FY8jKZi1ZSaD5n6avub3C6+Oeg5iA5Hd5c3DOMZPqLR2rj7q2RHwGoaGBsh73/H3
	/A0qMtKvB67DUxKRqs66t0WEteTnmCZOPwgyUbWyiFp4396TObxWbHPLISaRVTo+e43DjH
	Ey/MzesS3HNncvAMd1+HNt1qtmfn8RI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 52576601FD
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:55:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41A21F0089D
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790200510;
	bh=SpXPGh64kpxQKL1N904LXrN6hkR3B6eHCfE5NZYijII=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Cgw3afYujNqlrWM/WhXomv6w5ymB9ASvZlKeEGsThrj5KwbV0o78k4RyPSTvGYY1T
	 xTyNNjPQe0dyBODmMwCzxN8qPec5CC32ksR7FpvgtShi3F+PYBHnxCAYj10pgVrMOD
	 Vj5VnKeKQwHskPqOTx692ErN7Y4A2tv32iesJZGxGgCM/bKkRNCR3vMflD+gWoPeoc
	 /PWLIAjHQMmje4LAJug8HdcgpZr5oYEJu/XYL+/eauTR3V4X8cOyB8KzwgnJqEpIcm
	 +zBA+oytBZPJyf6hJdHBl+fHVogHN+5Dv4xlWqZB+RzfkZXb1jT085vOrt9TGTd5eL
	 b3rlsOUx/FALQ==
Received: by mail-qk2-f13.google.com with SMTP id af79cd13be357-939109f067fso147130185a.2
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:55:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwKgmGKg3hrPpFVZYHRw4nphk4Akjg4vk0iclB0DmX1NAxi7Q9+5qCfpuwkIpCTGxVV6eTZmXj1qQ==@kvack.org
X-Gm-Message-State: AFuF++mVuUpDIeHw71SmwyaUVg14LNh6mbfJ1cqiC7/ea1fmwfvn/NTp
	DWxgdDOVnElTxmL33zcnp3aQQqvwAYD+E731FZufHu7zCpo4P5QBIVQqCbKlhrwItBNmN7E/M+E
	JjyHg+facJGf3zqo33S8TaHLurWQ4RCA=
X-Received: by 2002:a05:620a:284a:b0:936:dfbf:85b0 with SMTP id
 af79cd13be357-93c363a8152mr1388985a.35.1790200509327; Wed, 23 Sep 2026
 14:55:09 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1789718658.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1789718658.git.zhuhui@kylinos.cn>
From: Barry Song <baohua@kernel.org>
Date: Thu, 24 Sep 2026 05:54:58 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xuc0+Ehih7hY2YEhRR7tppbf+B5O62wdP3nxDp+K7oZw@mail.gmail.com>
X-Gm-Features: AcwNN1XTWzCfQmh8uM20cSrnV3apsyMT9Ecd9a8pnvLDRtaQT8_TZ6QtW38rdjA
Message-ID: <CAGsJ_4xuc0+Ehih7hY2YEhRR7tppbf+B5O62wdP3nxDp+K7oZw@mail.gmail.com>
Subject: Re: [RFC PATCH RESEND v5 0/2] mm/vmscan: fix NR_ISOLATED accounting
 and throttle MGLRU eviction
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D7BC520005
X-Stat-Signature: 1wpe8c5a9oi9smobfrfksj8ytucimes5
X-HE-Tag: 1790200510-696608
X-HE-Meta: U2FsdGVkX1+lOGyg9YOyEu5AHZy2AXS6TcfLIJO+Cva2HNtAeeVe2OMuF/nKzwcRpX1eHBV7EaOxvClk+EgcGlg//TrMc0Vuvv8yo1oM2MEn5nblNMoYVXZpyobDeF5gNrk//xsmcrS3O+DHSFJLzlcHM82d4tZCwyOYRbCHhJfN9sfKEeNhtEK+AJmxvGLtgQ+PBrQIwc0XrzYJd0v6iHwIfHL5RmfSsf3pU23i2HDgClBkj3+LJzYqudiq3lT8Yyb60FpSPMHHZADv20//V54R3/NqASmBc4KdSn3NTODLiKwaxLCIkd3Byu+aX1c0wtAixrSzhAltis0Al1nQsKmSNEjWKca7wS4ARpYrBHl/dBUw5yb4/btu4zhc+naqHisPa1bdyKzIL3r8gC32N6JgXIjPxHpEcYuUY6HtBTEBKX/zVjUZCAcp6tg9pXV27c+xSp+sqn8V22MEQDOBrpi6VyuBgFTAXX2asp+APqkxX9cpwx39LGsAYrrJJQDFgxFzs9XnJrIhnSDgPoYZ/G7G9mHz7aoPMtMDRQ3sPLDBRfoD/dJVDhc1lqQjEgLouF4X5V0F7fc5SFmZj5TiDmOrsImUQf7P+qotpYdI/eUiwoUNSndNv1HmTNYtesFHLpesuu2rvZBrt6XyfDJAmYH6c0x5hH+coadVh1c3aUeBV2o/ADWWmnSAA/1nF2yemqEAYFnr4HvssRQoHnQFUvp3XUU1OoJszcFfyFx3ber8olpkjuaWlyuq4vr48F4f8k6bWcI+fXtzV8tR7Mjuyg8zy8Y/sWbgj1tSdWNr3WuyiP7YL59ESRwS+TYv/SSXtpJKDzpTtdRDjy6jqvfeB1TD6jr1em+mLGUdEjSJ29BvwXhWV8WukHn6wHsgICBadzILmrw/ir8vsL9T5whCGGA+lkUoNzmiMuQppHyw6RmHFP54/X4eQBcIf0PquY/aOUnSYQUg2DtjCNcfc9g
 9RbgoKPN
 e2yGNvh7y9geLssR9l9FrzlPAORMvJ9Z8R27APxMFMdQ6KlkCkj22zMGw8lDv+YXYvZXNl/n7ULjXRnCKggSV2YfiEgE5fei6XWqWjYqfJrji+sndutYraQ5z3sgY3RS0sRFACF78VS2gjapIyrhRxZ5qRrZ0bHtL85K/CweRiM+YCZPmn3ww4mO00fNPTM2s87PxROeftXYt/HhEJ6gLAYqn4KOYr8kCHsek8VusmWGhcdgvfeehaRVtAusi1rVwWDPXle1z6iuD7OGn6rKIOxuNTxxPvRsQram8nFyMMDTxfd0t9wefLaQgMwkrA35l+xsV0W6cqN/on8XfIHRg9ukV3hrvGsDlbgbv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 4:07=E2=80=AFPM Hui Zhu <hui.zhu@linux.dev> wrote:
>
> From: Hui Zhu <zhuhui@kylinos.cn>
>
> Previously the patch was based on mm-unstable, which caused issues during
> Sashiko apply.
> So I rebased it onto mm-stable and resend.
> Thanks Andrew for the heads-up.
>
> The legacy reclaim path has two mechanisms around isolated folios that
> MGLRU lacks:
>
> 1. NR_ISOLATED_ANON/FILE counters are updated when folios are isolated
>    from the inactive lists. Compaction's too_many_isolated() relies on
>    them to decide when to back off. The MGLRU reclaim path never
>    updates them, so compaction cannot see MGLRU's in-flight isolation.
>
> 2. shrink_inactive_list() throttles direct reclaim via
>    too_many_isolated() when isolated folios pile up. MGLRU's
>    evict_folios() isolates folios without any such check, so many
>    concurrent reclaimers can over-isolate the same (oldest) generation,
>    leading to unnecessary swapping, thrashing and premature memcg OOM.
>
> Patch 1 fixes the counter accounting in the MGLRU isolation path.
> Patch 2 adds a per-lruvec throttle, mirroring the legacy behavior but
> adapted to MGLRU's per-lruvec contention and its dynamic type
> selection/fallback.
>
> Testing
> =3D=3D=3D=3D=3D=3D=3D
> Two test scripts are provided to reproduce the problem and validate
> the fix. Both are available at:
> https://gist.github.com/teawater/3ef51251f2e91a5a600e3d26bb477e34
> Test environment: 10 CPU / 8GB QEMU guest, MGLRU enabled, a 16MB
> memory cgroup, anonymous working set, swap backed by dm-delay (50ms
> read/write delay) to slow swap-out and lengthen the isolation window.
>
> mglru_iso_repro.sh (64 threads, 48MB working set, 60s):
> Drives concurrent direct reclaim inside the memcg and measures scan
> efficiency, throttle events, in-flight isolation and throughput.
> Neither kernel OOMs at this concurrency; the value of the patch shows
> in reclaim quality:
>                         unpatched       patched
>   OOM kills             0               0
>   mm_vmscan_throttled   0               35645 (all
>                                         VMSCAN_THROTTLE_ISOLATED)
>   nr_isolated peak      0 (invisible)   230
>   total touches         246,499,132,369 301,456,426,692
>   scan efficiency       0.0261          0.0194
>
> The patched kernel completes ~22% more work in the same 60s: the
> throttle keeps concurrent reclaimers from trampling the same
> generation, so less CPU is burned in reclaim. Note nr_isolated is
> always 0 on the unpatched kernel - the over-isolation is invisible
> there, which is exactly what patch 1 fixes.
>
> mglru_iso_repro_v2.sh (192 threads, 48MB working set, 60s):
> Raises concurrency to the point where over-isolation becomes fatal:
>                         unpatched       patched
>   OOM kills             1 (task killed) 0
>   memcg oom events      51              0
>   mm_vmscan_throttled   0               512292 (all
>                                         VMSCAN_THROTTLE_ISOLATED)
>   total touches         0 (killed)      682,300,003,972
>
> With 192 threads the unpatched kernel cannot keep reclaim ahead of
> allocation and the task is OOM-killed; the patched kernel survives the
> full run and keeps reclaim making progress.
>

Hi Hui,

I=E2=80=99m perfectly fine with using a script to create a scenario with a =
small
memcg (e.g. 16 MB or 64 MB) and many threads. This is how we do R&D and
build simple reproducers for complex problems.

But I=E2=80=99m still struggling to understand how this scenario maps to or
affects real-world workloads, other than `iso_stress.c` in your scripts.
Do you have any idea of a real workload that suffers from the lack of
throttling, which we could present in the cover letter?

Best Regards
Barry

