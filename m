Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67E6DCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 10:33:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B90728E001C; Wed, 12 Nov 2025 05:33:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B68288E0002; Wed, 12 Nov 2025 05:33:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA4DC8E001C; Wed, 12 Nov 2025 05:33:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 976E68E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 05:33:48 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2374F58E3D
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:33:48 +0000 (UTC)
X-FDA: 84101594136.01.A36C517
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 321328000F
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:33:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tsNJu+cD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762943626; a=rsa-sha256;
	cv=none;
	b=NYuTPLXX+aZoChRd5Ay6OhCF+zMe7ZCe9WIRP+CJu5wsmFw/IeKvLrU3i8gAJrlaPYbkaK
	RFTLSGggOMeJFb8EfcsJ4JyGtrvoVXJuPKjrWBULRRXTvPNBvbHaGyPvapdgSExjE5EOJw
	8FDBGWPcfro5mSckOSBE72/9Fbfdy+c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tsNJu+cD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762943626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=btZYaHUcIDMi2e+058eW0Iyq64T9g7JigRlxgSizQrk=;
	b=yBLzjUETMXkne0AvPubX6pbuE5cUT2HV1ryg2cIS8qArBErCrKr/Qo5dwbASBMjtuvJVo8
	Q63m+3Bxf1lIXFu6EFNgnRcp4gTFoHR/xaLWyHgtVgHdisN++EcmeEStzkBUuTlK/FwEPD
	IKzJN7t6KpzEE68XN2bkRKjvMNcIVZY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EFC8341AB1
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:33:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC3CC4CEF8
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762943624;
	bh=6os1QpRBV8+5AwChEFKqOE4/pzICEt5Fpg+noRChogc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=tsNJu+cDjDDdXEh0EDyKh8TkaQax/UchDUORnmyqw9mB8HktY2ClNm1dsIdwuEylf
	 Pjn5Jq/v/J2vcEaH5jhtcNmxAwRPf+2uVUmkNVrLYQCTBqccHnA9cSztP3zOWIyiMf
	 6ECj18Tu7my+VxZfkdEYrI1pjL73Cr9jbUYKWqIY3+hThxqh9ZBPC0MWXuVUV7r6Sx
	 wQEwH7hAa6qMm5A3apYjwIFY6HnIb6SfEWCOKfuZqLSwoBKIl5VCYWyMkATLSbyZrR
	 f1tw1FD1O+M3+YABAO1VRWwwrJvUvT8vM1PqUCSlFQrSrSR+H6aL+pcMxYVLR6L9a3
	 U8QTHJMfsTRdQ==
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-7881b67da53so1556817b3.1
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 02:33:44 -0800 (PST)
X-Gm-Message-State: AOJu0YzXKfhddsOL9H2VeAnr8Ip6QSK7M1fwPljRhFkuQXgcLYODQiVs
	QZsEWGHaMIfiDXXrGIdB0XzkupHcCT+j5AX0NsDGUwDjJDR4tD3hPYAZ+3/7rpPWneSetntIcGg
	+PUYfeZxEjwwHSQW9MNL6CdqCW8Xh+PLp+KQAuO/b7A==
X-Google-Smtp-Source: AGHT+IFJEmuYIDi01UFhuE/DkbKBDGrDMbCjJHTiVTHDatPgNcmeGNmC1jG+SeG3tSCjLst7swV3IZ0wX4R/TkQOu3U=
X-Received: by 2002:a05:690c:4183:b0:787:f5c5:c631 with SMTP id
 00721157ae682-788136f5527mr16083137b3.65.1762943624138; Wed, 12 Nov 2025
 02:33:44 -0800 (PST)
MIME-Version: 1.0
References: <20251111-swap-fix-vma-uaf-v1-1-41c660e58562@tencent.com>
In-Reply-To: <20251111-swap-fix-vma-uaf-v1-1-41c660e58562@tencent.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 12 Nov 2025 02:33:33 -0800
X-Gmail-Original-Message-ID: <CACePvbVu52yrPd+4EPqfSpC5fCmS6mYOqKDNGyzcpSvAQgh0pg@mail.gmail.com>
X-Gm-Features: AWmQ_bn7QCBcJADZbM2huFUVMcx-IOnydFhAnFGmEpZSzaNGRhEh8MWWHlrht-E
Message-ID: <CACePvbVu52yrPd+4EPqfSpC5fCmS6mYOqKDNGyzcpSvAQgh0pg@mail.gmail.com>
Subject: Re: [PATCH] mm, swap: fix potential UAF issue for VMA readahead
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Huang Ying <ying.huang@linux.alibaba.com>, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 321328000F
X-Rspamd-Server: rspam07
X-Stat-Signature: w4eibrrux1xh1kbzqgnteggstr4jp8t1
X-Rspam-User: 
X-HE-Tag: 1762943625-824182
X-HE-Meta: U2FsdGVkX19I/ie8g7TtVi3yIiZoQs4T4mzxwS01cYsa8KzWH2BFqMqvzFKWcYvFnZW5z4ABMJsbXftJ+aTszGBI8iWJHmPLWegvZg5E02Z9C3ClfqqAiKi+koUARIlXpUFMC2SVxN0rfgDcHzLbJtv/cybiJFG5MvAnr2Y9rn49XdcDAhbgVDfKf67h66rCTHkgmTkgjwR/11en14h+/Ngw+o4cPhkKH22iJK6GTbFCFWqIqTv4yWTPLUznr8uEUdFR83z3Nyz+HgANgHK3FzqkUc9gQU/drf3oN+ZLJ2GDEeqBhfan7adn/amLGcCeekkTkjC/7C8s3EDdq3EhobWQPWtGQSHOvZb0rICjCf7nseQs7jlGXVUHmIUOK9B0bbgSKC0CYLH5SPk7LFF9YIM2WzlmHJR+N5TVhNgyrCPLgVx/UGntsgn+35O2VSvKx/X9UDAEtxYmswfW2+zYi7+mDm84K2XWM03ltNDOZvQDSSAR7jav/VcPm2cdvTOPQsuE+m6N9UzUc+HalghkrSQ4xq6vtijhj5XROue85E/ato60J2yBx82OhThmxG1Jn8hFWHxLrLMQyFOTNFeJ05ThqnmOEv3UYeOIohZ6SOLBt8a54vTjTbjTQWgr4OmwhjHCxvUtGOQakwXZr+krdxA+7ElPxnX5r0Yf/gMUHuNYFOx+y7Zc9OmWAUr9WPA8h9G97E0SiCNegoq5+xZfUoxk5YAnFJslGpXGYUe0RwQ++bmZeu0AVe6nme9aN/4VDTYc60ACdCoEEBI1Xr8aGKhx4l1AHYrsmuaLO6pQSZENXto433KWps9Eu5UT/PdMrZPhfNlHpdGNTyKkXX02ZlLPNLrsiItEjSyaQo+cZcxevZFaFj2pP4tIOgTXn5uGl6JmFpT6jWoUuIHXzcX8oEd+DZtOQCDa+Wd+TZ2hwVtpNyzhtR9hLmKDLXX1RhBlunQY0GjXFjmWy/nom3j
 RzUClRTD
 H02PBfavq6wqu8sHvgygc82Jk3I+uWygleHaOSQ58EqAcRnNluECJKDuz2xablnMPHrA7jg/TrLQvkuRwZ52tw/C+BCxfxnZrsUs/pqdZql7zBmVc3843RbkRItW2tB5LUKXMlxP+Q2prImwhYV2KLnM0V7bIxmVLWLyfhTumQLpex9hrqQo0TexuZY3UMWV1nh9cAeq7lwk5q5f8rWlbG51Rz4qoRWrAha+kr7ZTDSX2k41EQlImso6JwMJOwUFJRZkkXndnqJ/sqCQ5coe7OkeXTD2RoRmRWaUiO1RFG9QfPJMeyYVBgNSUM3GL1ZXq4XRzCeR/ZMNBhd4vLGs9fgFp0sUkQSej5peBni7RA82zjFNnuitrj4gwhIvLWWVzPjNh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

On Tue, Nov 11, 2025 at 5:36=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> Since commit 78524b05f1a3 ("mm, swap: avoid redundant swap device
> pinning"), the common helper for allocating and preparing a folio in the
> swap cache layer no longer tries to get a swap device reference
> internally, because all callers of __read_swap_cache_async are already
> holding a swap entry reference. The repeated swap device pinning isn't
> needed on the same swap device.
>
> Caller of VMA readahead is also holding a reference to the target
> entry's swap device, but VMA readahead walks the page table, so it might
> encounter swap entries from other devices, and call
> __read_swap_cache_async on another device without holding a reference to
> it.
>
> So it is possible to cause a UAF when swapoff of device A raced with
> swapin on device B, and VMA readahead tries to read swap entries from
> device A. It's not easy to trigger, but in theory, it could cause real
> issues.
>
> Make VMA readahead try to get the device reference first if the swap
> device is a different one from the target entry.
>
> Cc: stable@vger.kernel.org
> Fixes: 78524b05f1a3 ("mm, swap: avoid redundant swap device pinning")
> Suggested-by: Huang Ying <ying.huang@linux.alibaba.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
> Sending as a new patch instead of V2 because the approach is very
> different.
>
> Previous patch:
> https://lore.kernel.org/linux-mm/20251110-revert-78524b05f1a3-v1-1-88313f=
2b9b20@tencent.com/
> ---
>  mm/swap_state.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 0cf9853a9232..da0481e163a4 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -745,6 +745,7 @@ static struct folio *swap_vma_readahead(swp_entry_t t=
arg_entry, gfp_t gfp_mask,
>
>         blk_start_plug(&plug);
>         for (addr =3D start; addr < end; ilx++, addr +=3D PAGE_SIZE) {
> +               struct swap_info_struct *si =3D NULL;
>                 softleaf_t entry;
>
>                 if (!pte++) {
> @@ -759,8 +760,19 @@ static struct folio *swap_vma_readahead(swp_entry_t =
targ_entry, gfp_t gfp_mask,
>                         continue;
>                 pte_unmap(pte);
>                 pte =3D NULL;
> +               /*
> +                * Readahead entry may come from a device that we are not
> +                * holding a reference to, try to grab a reference, or sk=
ip.
> +                */
> +               if (swp_type(entry) !=3D swp_type(targ_entry)) {
> +                       si =3D get_swap_device(entry);
> +                       if (!si)
> +                               continue;
> +               }
>                 folio =3D __read_swap_cache_async(entry, gfp_mask, mpol, =
ilx,
>                                                 &page_allocated, false);
> +               if (si)
> +                       put_swap_device(si);
>                 if (!folio)
>                         continue;
>                 if (page_allocated) {
>
> ---
> base-commit: 565d240810a6c9689817a9f3d08f80adf488ca59
> change-id: 20251111-swap-fix-vma-uaf-bec70969250f
>
> Best regards,
> --
> Kairui Song <kasong@tencent.com>
>

