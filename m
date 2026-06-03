Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72DCFCD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 18:23:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB7196B00B3; Wed,  3 Jun 2026 14:23:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C68606B00B5; Wed,  3 Jun 2026 14:23:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2F8A6B00B7; Wed,  3 Jun 2026 14:23:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D3436B00B3
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 14:23:49 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 619661C0D4D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:23:49 +0000 (UTC)
X-FDA: 84839424978.22.D361AE0
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf30.hostedemail.com (Postfix) with ESMTP id 408E880015
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:23:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eg+AuiOo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780511027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H5/qixCBVKIn17fieXnZwtlY6rJGJD1uIM6atv0ZcW4=;
	b=vNei60LqLBPZS7J6tSXdLrcmqo6JEVDTd6XLh2CDaJKg4wjcK4VT15NZ84Mr7POcWjA+nb
	1NotvC+zTfTgyuoRaN+Gh20nZz3Jld1C9KIeAnJa2qVYC2EBXK5PkieieU4d9gf/cQk9S9
	TLmNzH2kHw7Hd/iJwObpYqGAx7aPcro=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eg+AuiOo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780511027;
	b=3HkFkViS+bcpjQhPLvGCL4N2qMq6JowbtwTjMxL3n8nd32ZlO51uqkdCMVQj8dl4nAOTEF
	nB8z8JvpMGhNrJfdFTcXwm7ZstTbZvjQdVOHKQDTRkzOFZ65Fd2f2ylFdppDvtJKjZOFzx
	vcsOYFZe5BgbXq1ALF3eUPw5PLTigIg=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-490388fd0dbso127950175e9.0
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 11:23:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780511025; cv=none;
        d=google.com; s=arc-20240605;
        b=ew57/iHid14n1pOCKmFLTpcwWSHKa4zndYYnaS48yqwXNxLpc2TcvFOXWlZ8MmfjRY
         MaFXmsjoEb41I4p6M0yisegGku5arTHJZUt+OCxPPi7qmEDS5dTMSU49188QOsJ98WSZ
         k8k3FnZEX6yJjvkgpaqxi0l0gWrkLVqhKxMYAFbF+1TFP91TAk9h2d0IlPsU7v1AmH62
         /XY/4BfXcQsAb2n9880u9YguscSIY/L3d9J5kTsC8cuTFfs4QfuL5rdcuFR8A9K9rKhX
         9WzUNrggqDBB7Z6pdqZk7G9UIM/Dspj8tF7/q7zMmIloTddYA5BAJe1OjsnvDJZqlZm6
         j3nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=H5/qixCBVKIn17fieXnZwtlY6rJGJD1uIM6atv0ZcW4=;
        fh=Po+wPK9ablbAAzjs3ZBYk54Q5uO8/SXxvKdnf5utJrQ=;
        b=cIYNHskF+YX4yiERRiH11YSAPSZIXyu4f0NE4MxGsk2GNousFJJTuS++FBtyzrGi9T
         EV0DfrcUi6xWXeb9w3tMwVIaQmnVIVfGpdcTzr+boQxqAwwkIXlBrULPQvtzhVf358Gy
         +drm2+zzWLGBzGNnCdHVsiph+nzO8Yd1MkhvXaG8uzIgQrTviVo6IrUaup5bn84WowDe
         yw1O6bqV2ExMu95RP0nZsBt4fUgcxWGb+Yzkr7t2Rg0o8bkCxun95yRHDGRfA6uIYXAk
         nimdanZKA7YNcGQRxJZTc+dNmKW3ZIAsa0Bi0UODQLlZeaooGUpu6XBn8Kk2Q5ncwyNS
         P1Hg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780511025; x=1781115825; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H5/qixCBVKIn17fieXnZwtlY6rJGJD1uIM6atv0ZcW4=;
        b=eg+AuiOoxytAb6tBGnegdpOuxwuQ+Rdrbd7+kyIIHpqv92VC5+Bh9sBPig+QqnPgdk
         vbxFMF7kplM+oAScw+eFEerF5uuFLFrT417BX9v1pubtBIbwHHECfNbd6L2p9Pog0Wef
         uDygBN/6LOO45uGxKUN+OKDrsGMz9ZFszsK+rLAPvAEvi3dxXfkUdoyKgs+vzBEgPx78
         YoLgXAriYoq2lhEJ+p8a+K27qZ5DGDpIC36xH/WDHpnX8bhFA51zMwEL+TeOKuSXuLJh
         j216dLWb7Z7COznJVtVsgHlAhMmvRAOaQ0PuRL2CO+AarOyVtJn+CmEJeNe/gdEaw4e1
         P0Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780511025; x=1781115825;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H5/qixCBVKIn17fieXnZwtlY6rJGJD1uIM6atv0ZcW4=;
        b=f/s+CoF3BkAyQnUiqopa70EHodbhB3B8OyAWrlZ4m2D2GtTZV9LTMJhxeTB5E63/mK
         oTYHVPSSHq7jdgw5Y/L0/5ZfSswxeupsJ+745HKjQtW6hQyVRzDyv1ALlgMe9KLt5UQR
         qtyXOSUwHktwmx/4TnnIIN4+LOfLjMgLrKzNd4RB4KslPvwEMSMiCHINePsqkv2XGMW2
         HYLrSFrY6IkO4xop18PXbMkpSJJ1THCgvRgLmi5XeVaC1cnhNZghQFpq+TlCGo9Dlu8D
         1MKCy4cH8RPntYHbgVniVe0TEz1Hpawt2M2wIcMNMbnGDux9OgGgPrrE8jDROHJ0rChK
         5vKg==
X-Forwarded-Encrypted: i=1; AFNElJ/a2+s86A46eFMT5u4Yf1sUcTp8ZT8TJBfpK4AFIjHf8K28dv4qeP54RuUMWr/R+cgz+lILvGc9SQ==@kvack.org
X-Gm-Message-State: AOJu0YyobSruV8dgNW/zBkLo/imwnV50pFUv38GSucsw6plpxixsaNhg
	mVMtQOxqkLdBTGYbm5bbd4m1HQ9ApqmjtP6lJIOWH07AF5klUkVPjjOeWkmg48M8GiBP3bnH7TL
	xz/G5pmNkB2vZFHRVTTkMm9YosaQd4gw=
X-Gm-Gg: Acq92OHC4ex9ZX/sRD84cwIhCyzy99NTJIt3OOP5kmufKQb2MuLNGg6jK9Nim5JESg8
	wPKC6dnn4wX93IeiF+hWwD8nomWtfBF6LoS6QWYm6xaJcQaU9qzjwQTWzFQucdMH49ZTY6QYnLz
	odKBStcQozT1atZYybN8l569FuZkAVV4ssVBub/otcjK7L5hTuYKBKIz8S8PwxbDitr0MCkYp81
	zdy9euI2GF8vSrhGF7456/h6y71s0ftVejHO2XkPOMNRhH+Zeq/efz+fmi2WA3XcOb3gg8hG6h0
	DXDa88A01BJbnQfNYmOLTNQpRDUolqz3CTLu0YQ9Se6x5LYx+FYQxRpXmxM9
X-Received: by 2002:a05:600c:4695:b0:490:bd1d:472a with SMTP id
 5b1f17b1804b1-490bd1d4865mr418905e9.15.1780511025470; Wed, 03 Jun 2026
 11:23:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-3-jiahao.kernel@gmail.com> <aho-Z6wshceTAYd9@google.com>
 <ea2c1323-1440-e927-f14a-0eac54a245bf@gmail.com>
In-Reply-To: <ea2c1323-1440-e927-f14a-0eac54a245bf@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 3 Jun 2026 11:23:33 -0700
X-Gm-Features: AVHnY4JV9IZeIUq7QxB_DLa_b3AR5iHZZp6MXPsHjOzMK24TtH3slZqwmfSKyPA
Message-ID: <CAKEwX=PoBZ4ci30tKHQXs1o9=NDpPrtbe7RxxZTbnzVJf74ZYQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, akpm@linux-foundation.org, tj@kernel.org, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 408E880015
X-Stat-Signature: bkbgfbpypiru6sdmm4dq7kiytk3crf5j
X-HE-Tag: 1780511026-157723
X-HE-Meta: U2FsdGVkX19Y19RIiLOeOLmz8bD4ON/Bm8IDbJWWPfTGOS1S5vxjdlq3KXKGHtWRj8/TqeUBJcPX3+/MtSj6Aob8i0bWpe674mHjThZ69Z4c5Ua3crRZejsAC1ZfUgq6yakpOfgL/EpDaHQ4xuU7c00RolbDuFRT7pJzVlyrUmfFmbdzMsixSVUJBGo0VZDUeZU3ue0MTG++4kG7t7eutwKPQWTW+E00UGSg6qvBkEGze+76l+44gdqbIgq5rj0MZGbV0xdwu8exh+4NOP20KTVYn4sxdqis3TepoK6LNXb4zRcz1aBW56LqM1L+W/id0+CBX/trAxMjY8SnhvE56aewMNJNcnivgVc/u7n6wbJa7W6YTJxLwaBQuBtHS5pC0WxMsPePDSNbOc5Qnh+JjJoiMifN7pOdaa+TNDevlCqQzuKLgmpUBjQDCTUjJaPN1XtqK54u5y39Vo7N/0BGbGdT03X/TCTF+e75jqdlJBWbxyme73zEI9d8mOeoZJZ2+gGJbUSJZ+vqu0oHEJWsALU4RSOLAmQJoZizdzisxkR0/oFvgNwRQwauWbbJUM2IuczmQicQt/RjA4/lxb7Dcn+qfT3fwG0cZ4IJSOeczllPGCNpVnRysu6dsJ3b5QB76ajInec4xHgSlufYAnUN79ERv78hrUtFEitfbEGx5Yw7j3h7KzD26P3UK5c+YqgHBPqxWYox+zXQHSWjaVIezUYOvZOBQGQQpklH7bMTC4VN3XnrhOiNG6acDC1Ghk5p1JJOfoA0b6ybzOa5PY4NjKKzU9JmPb1fF3O73EhiZzn1nv5SAR7Gvjz/uxVQ3iKoZG2igz3VkgvkYfs+Ayb0qIpF70DfB/dd7Qhh1FESnWTM2+PAocLyIH/Dd3O2VVZ87YPud4Mp0S+wDu2s0pFBzP5o25bl8SDG45xMcIsOutaX2kYD/0JjE8d0SDtTu/8M3Q8C16qRMODGyYRE5He
 qJp1UmHQ
 RruRf+g0Ppuuc5jbHSXXIUBbwiHZLNRzyrPswyWoXCsneo4GFRqC7/5yqHRw/oxDfFz3uT4pq7S8jO5Dkqc56doP9ASNVVgXnCgytm+Ny7m21ogzNhP+ulWHMB+DHZjHf3f5mbNqzNIlQwNERUbmOIUd2G1sVaTzrjHekdsIUAhTdjiW/dSFwC3Dd+3x0DUy5dijYhRJH6cjO3rzRfESNUJw/znGQCEUtfd6ev2bGYtRnRvAHC12xMryqnIGpboUhPJATju+yZjphSLEzxtoyGMQL0NxOPGyPg3soXbUUaSfhrk608MN2DI6D/hZDYbtn3HJSpVHaYyPlO52wcvgiW4R44j/iTURWQAR3OgwcZdk9KEGUO1+ZpcWZTPfDyDGfFLVFTeR+Q5FajvFMvwcXQNrX0LjvPGtsHrP7DwbmBrudKVVRabldDVhqNB7qBZ4CIyjEYIC0TG5asHrEWor1eU2JWJmb+PqzvnQPosJKt9blrMWYjHsGYeNscjgvTD8LNnhNm99fcI4VmQaos6SelAxJ2tBfg8pdtQorE6AZEIswH8GAuY5s6UhSH2HL7oBpJXVnM2Dc0S0oHzM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 3, 2026 at 4:27=E2=80=AFAM Hao Jia <jiahao.kernel@gmail.com> wr=
ote:
>
>
>
> On 2026/5/30 09:37, Yosry Ahmed wrote:
> > On Tue, May 26, 2026 at 07:45:59PM +0800, Hao Jia wrote:
> >> From: Hao Jia <jiahao1@lixiang.com>
> >>
> >> Zswap currently writes back pages to backing swap reactively, triggere=
d
> >> either by the shrinker or when the pool reaches its size limit. There =
is
> >> no mechanism to control the amount of writeback for a specific memory
> >> cgroup. However, users may want to proactively write back zswap pages,
> >> e.g., to free up memory for other applications or to prepare for
> >> memory-intensive workloads.
> >>
> >> Introduce a "zswap_writeback_only" key to the memory.reclaim cgroup
> >> interface. When specified, this key bypasses standard memory reclaim
> >> and exclusively performs proactive zswap writeback up to the requested
> >> budget. If omitted, the default reclaim behavior remains unchanged.
> >>
> >> Example usage:
> >>    # Write back 100MB of pages from zswap to the backing swap
> >>    echo "100M zswap_writeback_only" > memory.reclaim
> >>
> >> Note that the actual amount written back may be less than requested du=
e
> >> to the zswap second-chance algorithm: referenced entries are rotated o=
n
> >> the LRU on the first encounter and only written back on a second pass.
> >> If fewer bytes are written back than requested, -EAGAIN is returned,
> >> matching the existing memory.reclaim semantics.
> >>
> >> Internally, extend user_proactive_reclaim() to parse the new
> >> "zswap_writeback_only" token and invoke the dedicated handler. Add
> >> zswap_proactive_writeback() to walk the target memcg subtree via the
> >> per-memcg writeback cursor, draining per-node zswap LRUs through
> >> list_lru_walk_one() with the shrink_memcg_cb() callback.
> >>
> >> Suggested-by: Yosry Ahmed <yosry@kernel.org>
> >> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> >> Signed-off-by: Hao Jia <jiahao1@lixiang.com>
> >> ---
> >>   Documentation/admin-guide/cgroup-v2.rst |  18 +++-
> >>   Documentation/admin-guide/mm/zswap.rst  |  11 +-
> >>   include/linux/zswap.h                   |   7 ++
> >>   mm/vmscan.c                             |  14 +++
> >>   mm/zswap.c                              | 138 ++++++++++++++++++++++=
++
> >>   5 files changed, 185 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/a=
dmin-guide/cgroup-v2.rst
> >> index 6efd0095ed99..6564abf0dec5 100644
> >> --- a/Documentation/admin-guide/cgroup-v2.rst
> >> +++ b/Documentation/admin-guide/cgroup-v2.rst
> >> @@ -1425,9 +1425,10 @@ PAGE_SIZE multiple when read back.
> >>
> >>   The following nested keys are defined.
> >>
> >> -      =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D            =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> +      =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>        swappiness            Swappiness value to reclaim with
> >> -      =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D            =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> +      zswap_writeback_only  Only perform proactive zswap writeback
> >> +      =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>
> >>      Specifying a swappiness value instructs the kernel to perform
> >>      the reclaim with that swappiness value. Note that this has the
> >> @@ -1437,6 +1438,19 @@ The following nested keys are defined.
> >>      The valid range for swappiness is [0-200, max], setting
> >>      swappiness=3Dmax exclusively reclaims anonymous memory.
> >>
> >> +    The zswap_writeback_only key skips ordinary memory reclaim and
> >> +    writes back pages from zswap to the backing swap device until
> >> +    the requested amount has been written or no further candidates
> >> +    are found. This is useful to proactively offload cold pages from
> >> +    the zswap pool to the swap device. It is only available if
> >> +    zswap writeback is enabled. zswap_writeback_only cannot be combin=
ed
> >> +    with swappiness; specifying both returns -EINVAL.
> >> +
> >> +    Example::
> >> +
> >> +      # Write back up to 100MB of pages from zswap to the backing swa=
p
> >> +      echo "100M zswap_writeback_only" > memory.reclaim
> >
> >
> > memcg folks need to chime in about the interface here. An alternative
> > would be a separate interface (e.g. memory.zswap.do_writeback or
> > memory.zswap.writeback.reclaim or sth).
> >
> >> diff --git a/mm/zswap.c b/mm/zswap.c
> >> index 73e64a635690..7bcbf788f634 100644
> >> --- a/mm/zswap.c
> >> +++ b/mm/zswap.c
> >> @@ -1679,6 +1679,144 @@ int zswap_load(struct folio *folio)
> >>      return 0;
> >>   }
> >>
> >> +/*
> >> + * Maximum LRU scan limit:
> >> + * number of entries to scan per page of remaining budget.
> >> + */
> >> +#define ZSWAP_PROACTIVE_WB_SCAN_RATIO       16UL
> >> +/*
> >> + * Batch size for proactive writeback:
> >> + * - As the per-memcg writeback target in the outer memcg loop.
> >> + * - As the per-walk budget passed to list_lru_walk_one().
> >> + */
> >> +#define ZSWAP_PROACTIVE_WB_BATCH    128UL
> >> +
> >> +/*
> >> + * Walk the per-node LRUs of @memcg to write back up to @nr_to_write =
pages.
> >> + * Returns the number of pages written back, or -ENOENT if @memcg is =
a
> >> + * zombie or has writeback disabled.
> >> + */
> >> +static long zswap_proactive_shrink_memcg(struct mem_cgroup *memcg,
> >> +                                     unsigned long nr_to_write)
> >> +{
> >> +    unsigned long nr_written =3D 0;
> >> +    int nid;
> >> +
> >> +    if (!mem_cgroup_zswap_writeback_enabled(memcg))
> >> +            return -ENOENT;
> >> +
> >> +    if (!mem_cgroup_online(memcg))
> >> +            return -ENOENT;
> >> +
> >> +    for_each_node_state(nid, N_NORMAL_MEMORY) {
> >> +            bool encountered_page_in_swapcache =3D false;
> >> +            unsigned long nr_to_scan, nr_scanned =3D 0;
> >> +
> >> +            /*
> >> +             * Cap by LRU length: bounds rewalks when referenced
> >> +             * entries keep rotating to the tail.
> >> +             */
> >> +            nr_to_scan =3D list_lru_count_one(&zswap_list_lru, nid, m=
emcg);
> >> +            if (!nr_to_scan)
> >> +                    continue;
> >> +
> >> +            /*
> >> +             * Cap by SCAN_RATIO * remaining budget: bounds scan cost
> >> +             * to the remaining writeback budget.
> >> +             */
> >> +            nr_to_scan =3D min(nr_to_scan,
> >> +                             (nr_to_write - nr_written) * ZSWAP_PROAC=
TIVE_WB_SCAN_RATIO);
> >> +
> >> +            while (nr_scanned < nr_to_scan) {
> >> +                    unsigned long nr_to_walk =3D min(ZSWAP_PROACTIVE_=
WB_BATCH,
> >> +                                                   nr_to_scan - nr_sc=
anned);
> >> +
> >> +                    if (signal_pending(current))
> >> +                            return nr_written;
> >> +
> >> +                    /*
> >> +                     * Account for the committed budget rather than t=
he walker's
> >> +                     * actual delta. If the list is emptied concurren=
tly, the
> >> +                     * walker visits nothing and nr_scanned would nev=
er advance.
> >> +                     */
> >> +                    nr_scanned +=3D nr_to_walk;
> >> +
> >> +                    nr_written +=3D list_lru_walk_one(&zswap_list_lru=
, nid, memcg,
> >> +                                                    &shrink_memcg_cb,
> >> +                                                    &encountered_page=
_in_swapcache,
> >> +                                                    &nr_to_walk);
> >> +
> >> +                    if (nr_written >=3D nr_to_write)
> >> +                            return nr_written;
> >> +                    if (encountered_page_in_swapcache)
> >> +                            break;
> >> +
> >> +                    cond_resched();
> >> +            }
> >> +    }
> >> +
> >> +    return nr_written;
> >> +}
> >> +
> >> +int zswap_proactive_writeback(struct mem_cgroup *memcg,
> >> +                          unsigned long nr_to_writeback)
> >> +{
> >> +    struct mem_cgroup *iter_memcg;
> >> +    unsigned long nr_written =3D 0;
> >> +    int failures =3D 0, attempts =3D 0;
> >> +
> >> +    if (!memcg)
> >> +            return -EINVAL;
> >> +    if (!nr_to_writeback)
> >> +            return 0;
> >> +
> >> +    /*
> >> +     * Writeback will be aborted with -EAGAIN if we encounter
> >> +     * the following MAX_RECLAIM_RETRIES times:
> >> +     * - No writeback-candidate memcgs found in a subtree walk.
> >> +     * - A writeback-candidate memcg wrote back zero pages.
> >> +     */
> >> +    while (nr_written < nr_to_writeback) {
> >> +            unsigned long batch_size;
> >> +            long shrunk;
> >> +
> >> +            if (signal_pending(current))
> >> +                    return -EINTR;
> >> +
> >> +            iter_memcg =3D zswap_mem_cgroup_iter(memcg);
> >> +
> >> +            if (!iter_memcg) {
> >> +                    /*
> >> +                     * Continue without incrementing failures if we f=
ound
> >> +                     * candidate memcgs in the last subtree walk.
> >> +                     */
> >> +                    if (!attempts && ++failures =3D=3D MAX_RECLAIM_RE=
TRIES)
> >> +                            return -EAGAIN;
> >> +                    attempts =3D 0;
> >> +                    continue;
> >> +            }
> >> +
> >> +            batch_size =3D min(nr_to_writeback - nr_written,
> >> +                             ZSWAP_PROACTIVE_WB_BATCH);
> >> +            shrunk =3D zswap_proactive_shrink_memcg(iter_memcg, batch=
_size);
> >> +            mem_cgroup_put(iter_memcg);
> >> +
> >> +            /* Writeback-disabled or offline: skip without counting. =
*/
> >> +            if (shrunk =3D=3D -ENOENT)
> >> +                    continue;
> >> +
> >> +            ++attempts;
> >> +            if (shrunk > 0)
> >> +                    nr_written +=3D shrunk;
> >> +            else if (++failures =3D=3D MAX_RECLAIM_RETRIES)
> >> +                    return -EAGAIN;
> >> +
> >> +            cond_resched();
> >> +    }
> >> +
> >> +    return 0;
> >> +}
> >> +
> >
> > There is a lot of copy+paste from shrink_worker() and shrink_memcg()
> > here. We really should be able to reuse shrink_memcg().
> >
>
> I will do some consolidation and code reuse in the next version.
>
> > Is the main difference that we are scanning in batches here? I think we
> > can have shrink_memcg() do that too. If anything, it might make the
> > shrinker more efficient. Over-reclaim is ofc a concern, and especially
> > in the zswap_store() path as the overhead can be noticeable. Maybe we
> > can parameterize the batch size based on the code path.
> >
> > Nhat, what do you think?
>
> Nhat, since we now have the referenced-based second chance algorithm,
> should we consider doing batch writeback for shrink_memcg() as well?

I just take a look at shrink_memcg() and realized it's reclaiming one
page at a time. Thanks for the reminder - I hated it.

Please batchify it if it makes your life easier :) We don't reclaim
"just one page/object" anywhere else in the reclaim path, Sure, it
adds a bit of latency to zswap_store() if we reached cgroup limit, but
IMHO if we hit zswap.max limit at zswap_store() time, that is already
the slowest of slow path that you should have avoided with proactive
reclaim/zswap shrinker in the first place. And, setting zswap.max does
not make sense to me in the first place (I can write a whole essay
about it).

