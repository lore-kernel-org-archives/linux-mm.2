Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C2D6CCF9F6
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 05:25:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B67C8E012A; Thu, 30 Oct 2025 01:25:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98DFD8E0112; Thu, 30 Oct 2025 01:25:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A3B88E012A; Thu, 30 Oct 2025 01:25:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 791948E0112
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 01:25:44 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2A9234A1AF
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 05:25:44 +0000 (UTC)
X-FDA: 84053643408.25.C45D216
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf19.hostedemail.com (Postfix) with ESMTP id 451B51A0009
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 05:25:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eA2i6twc;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761801942; a=rsa-sha256;
	cv=none;
	b=xbz/ZSFmXpfXCduzRdazCEmc1SBkk2boQhRtCx2GnxwdrRGXNeCKhxjSUMSmm88Q8TEzZV
	Vg5ei3eM1viPH9/b3F7JTPV1gMMUSpPK98scb2v7Mbrr/zcUPQX3+WqbwKB1kyyP2N3R6B
	1FDRTHTL3Lhr/MeqsM7XGy2qOjb7lN8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eA2i6twc;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761801942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TfysZUiKw0ccehvHsLCa5x6Zv8Uvqd+yTXJjIb1Wj5Q=;
	b=c4+teU4ldRoKGBFx/1dEJkgzJMEBlK2nWuhImK1IpH+CyBFZ38anRwzyKekUtyJioWNiip
	pLZ/RUHvCVUlsDV6YIWo/fodkzjm/hQSZKLj26ahOmjeK2wR9859NVnxGZg/jayMbHzvtL
	vraD2v/Ngs3oRvrUOv/ld7aPyf3V9dg=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b6d345d7ff7so361806266b.1
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 22:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761801940; x=1762406740; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TfysZUiKw0ccehvHsLCa5x6Zv8Uvqd+yTXJjIb1Wj5Q=;
        b=eA2i6twcx5FoqSQoDV/0Qsd5Zpe/0Aa6xkIrZm+4lZ35KLeMekvPGKgsSPG9Zy0Z8h
         A6hHFl+qmvfcRuB8yJz+OEdoqO9lKJz9wHXAZpvfQuMzqWaMld52ncyqmMHKp7rdyV2D
         ExrKjYF2UxD2cl1KQq7i45wG+2xAJMeFxNGAFb59cWf9QE1CZjoySEeOc89BbBtv6kob
         +LQNG5oolF8p1lF3HcXqCrz568HU6JjvoF7gp9a+iZGVh5RL7FO4mjxRnPs6YnLtLh0U
         cijVUNqt9MfPvCb+D5q6v94vphkOUWzjytl9sCTjIQ9LXPmCise7pdd9AiAWoVwHX4bc
         IqHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761801940; x=1762406740;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TfysZUiKw0ccehvHsLCa5x6Zv8Uvqd+yTXJjIb1Wj5Q=;
        b=jzN8aCXipelXqEgnTEGNgbzMgHtqtawSCUtVq3FfywSo6fRNq1N7uCZw8AOUg3HjRA
         T2d3xZPZht2o2pVjRK27jPNIA0Lqm0+no2nxJVjWyjd4hLjAUBkB8sCAHy1G6E1HnCwr
         0yaqsU9ECtZ3ToGN3PYzr10e/8J8kaAwDK9fhQX8C6Uf6Z53TYPacrPkbfhoy9dVxV0r
         rxXDsWaA1Q2rgVWHvFKX7j2+C/DmwL7oP925UaHrkKCM+KKpk5rDWQdi7AuKXsZutGeT
         wdloeYUiNdwfbSrr5pSSvPNB14371M9pPY4Z270rcDORIS8FKPZzZCF2U3QiOw5ugFRi
         3JUQ==
X-Gm-Message-State: AOJu0Yyb/PuGF/cYL6OKEJFva5DQpWmuRx6cXluukXLu7BL+3sifxSqy
	plm69Gj1RaSXTj6W1zoZHWQx2XrxNOLxwEaxzf83TI3B6fBG+4BEn/3VuSyPw3dOqoQw4DGzRNf
	xYjOniVVkWeQK/AC9AzplJtRk82keC0E=
X-Gm-Gg: ASbGncvc/xOzLDVLPG/v7mtcAgZqbw68F1vD/ANrOGVJvvnhkts+jRK5NpBPNV48l31
	qhrBm36H2SQp0lC4xS+4TFT1b4lw5vrgHal0HUC1TfZM3m4ptQfBvQqevjRfGawH0czLSIJr6HG
	JtN5ueQc3/L7X9UjKHxxXfsZ2nr0jkO6B840Cd3vpUCBxZwvdTcmMRlampIBG57glB36i89Oub/
	b5w7GboI/ijA7pVhKZdtTpqfXvk5CJT+fYV7M+EgYf88aG2+doj35qwNjWAylpS
X-Google-Smtp-Source: AGHT+IHNyXHD9tuJVWmX0HGoxsmgdCXdnVfsLSRiQVKCm3qLDQttk267xLovDM2ICaKjf/7vxbQtpUFH3F3g94OPSSs=
X-Received: by 2002:a17:907:7f94:b0:b3d:e757:8c36 with SMTP id
 a640c23a62f3a-b7051f28d17mr219852766b.3.1761801940298; Wed, 29 Oct 2025
 22:25:40 -0700 (PDT)
MIME-Version: 1.0
References: <20251029-swap-table-p2-v1-14-3d43f3b6ec32@tencent.com> <202510300316.UL4gxAlC-lkp@intel.com>
In-Reply-To: <202510300316.UL4gxAlC-lkp@intel.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 30 Oct 2025 13:25:03 +0800
X-Gm-Features: AWmQ_bn7Lyv0bXlIQEUl3x-IuvN0KJgIKA5RqyN4TyJ6a-kvBKh6n54oDVlmgZo
Message-ID: <CAMgjq7DcxG_8q9Kzwg-4kLBXw8eN8DvwmSR0gRUjYWPoFH8xsw@mail.gmail.com>
Subject: Re: [PATCH 14/19] mm, swap: sanitize swap entry management workflow
To: kernel test robot <lkp@intel.com>
Cc: linux-mm@kvack.org, oe-kbuild-all@lists.linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	David Hildenbrand <david@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: qcji3fpz9nqa39413h7oqrkn8ghosn9e
X-Rspamd-Queue-Id: 451B51A0009
X-Rspamd-Server: rspam09
X-HE-Tag: 1761801941-739682
X-HE-Meta: U2FsdGVkX19u7sNo1IV822cNOaSxHYfw7WsZuRphTFAzSd/2W6kB8ojn0wja9wPm9tN4hSgsIxx81Gymmx8mZH0bdjVs3RNRnJxkrrQx+cNx4rLxI9gTdlow8Xb2DI/ctdjD3lwQpwlOXwosJsf0tyKQo1F5tBk9hfwsw6SFN5ajDnh2a6rrtdXBDc3ZYcuKwQtq3Xdjop3VAeEpGsHvUTzPneR61WUX/Z+thWc9RvwDQ5QVlsWpCioS7sHkNzeQ5oIjpidDdNVMReZaTZ4czexSc0A/JtxRTKiekh58l44EKw/LKdPtQ9DZeqkoStuBb0rRP+byNjB693Z0wgVoM8bVHLx+k8ZGvNbeF8V6lrjS6v5YlLxgpnFmNmmvOJIiDneySei7EJw4aRaq72fsdU0zyrUW8FwaiBsHn95udI5ofNojLf+1P2T3a9RlT7kfpw7SQ2R8W8CQL4e1w65nelPge/Ndvw7MuID2SUynHgiWlpAmiRDlvj8iv4OoY5XsCCqiW181TEWYJpo8Hi64NYjlLen/NyxLEpS/U1EQgue9+ThGmOQhCVSWZ/x2TuUayHesDu6qaEY3c0y/c7USUhn52yc1pGe0Jz/5liGAmzcuQYzPhc1fQiMoQcfpRKyrqrgdpxKKeKafg8t3Y9F5b/090jXwGZSUNhSP8Ld5Emd395wATMmj5NPn3yUaskIcfiLTFCfyPuIbTL1s2VxcolMgKkRLeNGpuhRrCDXYbKX9G/jWEV5nxboYUjKlUlOMgX8G9JVUUqSRxdN9ytKKylpDP2EwdrbATLpPMND425MPh72FUWVvi08NWFXeFSchEjdoJsX4QNeegeq7haPuLfylA0uKOH82qMZRqg8uSELqKV34bPNDNh7uMQBaJAoMZRLI75sBS8oGvIURQ3vIjGGryzCuLw+pjLa/RiowAGqrP+OVdicbzXjshIVtRlaDm0u4zbpA/lbvRLAIu1q
 JttrFzgE
 8fjf9VKWY34rf9wLXsbVZgwUZXmvWDWLBZ+t0W9qFLXmVlmJpliahhFSAvX6CFcikI4c55hiHOpqCc7X3GN6ihimqulmXFmpOT0N4bspUmEdJYw4vN42iAIuSRxOD+gi2bvBq3xVnTaYaISvLMfZI/xy4pxCRjaTLl6xWSeEv3hS+gnSbrPlYjKFaUC/UwIJ6o3OreejChEktAocXOl2XX1bVps7kkwmy4ETtuzj+OD8CST+gBjzXwrW8Pr7VSZjf2cLq7Htw7jz3o0RRsJ2R96NMycb2aPZJe5Vie26NfUcueKC4O0n26lXSS067s2WW4tZ1i/XU62B6wDM9ni40hZJY+JJ6cpCafZ8l/dzSrhJ08eWWM+S/CXw3+knaTIvQSWDEHeSaCr/RCytA4UBgmGWhCtAAq+IOwbTKYOgp4sUNF9w2dIJ2XTpKvos4CAaextferLHy2eN22fPJT12nCPm9BKWBXIJeDjxEkehGeKvE/zxDgaNv2v1KDQ3w1U+nlyGH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 3:30=E2=80=AFAM kernel test robot <lkp@intel.com> w=
rote:
>
> Hi Kairui,
>
> kernel test robot noticed the following build errors:
>
> [auto build test ERROR on f30d294530d939fa4b77d61bc60f25c4284841fa]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Kairui-Song/mm-swa=
p-rename-__read_swap_cache_async-to-swap_cache_alloc_folio/20251030-000506
> base:   f30d294530d939fa4b77d61bc60f25c4284841fa
> patch link:    https://lore.kernel.org/r/20251029-swap-table-p2-v1-14-3d4=
3f3b6ec32%40tencent.com
> patch subject: [PATCH 14/19] mm, swap: sanitize swap entry management wor=
kflow
> config: i386-allnoconfig (https://download.01.org/0day-ci/archive/2025103=
0/202510300316.UL4gxAlC-lkp@intel.com/config)
> compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20251030/202510300316.UL4gxAlC-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202510300316.UL4gxAlC-lkp=
@intel.com/
>
> All errors (new ones prefixed by >>):
>
>    In file included from mm/vmscan.c:70:
>    mm/swap.h: In function 'swap_cache_add_folio':
>    mm/swap.h:465:1: warning: no return statement in function returning no=
n-void [-Wreturn-type]
>      465 | }
>          | ^
>    mm/vmscan.c: In function 'shrink_folio_list':
> >> mm/vmscan.c:1298:37: error: too few arguments to function 'folio_alloc=
_swap'
>     1298 |                                 if (folio_alloc_swap(folio)) {
>          |                                     ^~~~~~~~~~~~~~~~
>    mm/swap.h:388:19: note: declared here
>      388 | static inline int folio_alloc_swap(struct folio *folio, gfp_t =
gfp)
>          |                   ^~~~~~~~~~~~~~~~
>    mm/vmscan.c:1314:45: error: too few arguments to function 'folio_alloc=
_swap'
>     1314 |                                         if (folio_alloc_swap(f=
olio))
>          |                                             ^~~~~~~~~~~~~~~~
>    mm/swap.h:388:19: note: declared here
>      388 | static inline int folio_alloc_swap(struct folio *folio, gfp_t =
gfp)
>          |                   ^~~~~~~~~~~~~~~~
> --
>    In file included from mm/shmem.c:44:
>    mm/swap.h: In function 'swap_cache_add_folio':
>    mm/swap.h:465:1: warning: no return statement in function returning no=
n-void [-Wreturn-type]
>      465 | }
>          | ^
>    mm/shmem.c: In function 'shmem_writeout':
> >> mm/shmem.c:1649:14: error: too few arguments to function 'folio_alloc_=
swap'
>     1649 |         if (!folio_alloc_swap(folio)) {
>          |              ^~~~~~~~~~~~~~~~
>    mm/swap.h:388:19: note: declared here
>      388 | static inline int folio_alloc_swap(struct folio *folio, gfp_t =
gfp)
>          |                   ^~~~~~~~~~~~~~~~
>

Thanks, I forgot to update the empty place holder for folio_alloc_swap
during rebase:

diff --git a/mm/swap.h b/mm/swap.h
index 74c61129d7b7..9aa99061573a 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -385,7 +385,7 @@ static inline struct swap_info_struct
*__swap_entry_to_info(swp_entry_t entry)
        return NULL;
 }

-static inline int folio_alloc_swap(struct folio *folio, gfp_t gfp)
+static inline int folio_alloc_swap(struct folio *folio)
 {
        return -EINVAL;
 }

