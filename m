Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED37CEA719A
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 15:56:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 606DC6B0321; Sun, 19 Apr 2026 11:56:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B79E6B0322; Sun, 19 Apr 2026 11:56:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A6A26B0323; Sun, 19 Apr 2026 11:56:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3905E6B0321
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 11:56:18 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0D7B016071C
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 15:56:18 +0000 (UTC)
X-FDA: 84675757236.01.9D79BFE
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf21.hostedemail.com (Postfix) with ESMTP id 094521C000F
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 15:56:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TY7QFakU;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776614176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bS1cThwHIktcd5p9rJSSzoXzcbmkZO9SdVakwgQGsP4=;
	b=3FrMYaA/PaNam5uheRzxKFexLFxDu6Qa6KnLakUek3b7ZL9+xA34dc7kN5Yvb6x44MFOSV
	1NuST7PFP/BPlM2m+VGYcxW+EuOygwojdeRry1pY9FvXwacQVDVPiC2KYOrVb0TSd470+h
	RZwpugAKbFVgb4E1ZWuZnMVo1qYwkZQ=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TY7QFakU;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776614176; a=rsa-sha256;
	cv=pass;
	b=PMTJu8vRXhC+AnL5rAb6oTz8fOPevusJza7mUxg5t+nKgvwuqnf92flvCicUfwkNfP3h9P
	lpfKL5Ze/CSRde6c9Sa2g7D6PnPhYddYkImDV632Wnra1/8tp2L2KekDrWVYz8uNC9wG9Z
	36Eeb8Nuv0N81aOUOOhDS5xoGoAAw0o=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6715006f4f7so3451887a12.2
        for <linux-mm@kvack.org>; Sun, 19 Apr 2026 08:56:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776614174; cv=none;
        d=google.com; s=arc-20240605;
        b=BwPnaNZ+Ti8I4rzW7vgL4BZUSQB7K5HibR808OPVUMGo+KTId1EkoM4cOE4/mfvzBM
         NthRYbM44oKLLcJg/3lONkHJEfwNOrNXB8jm1I/geJq+W4w67jxRNPQ3DKS/a8jVssVL
         CPI2CSeXEALnNBYfENo26rZ/y0chCjZJEbgVd3ekZAXXio1JiHUpsniHWjdUQMBYWFv0
         UoNP3I4wZflL0Sl85/ye96MrhbQdwOrR2CaG27h2qjxiPVIqmBZihLvnleS45cfSE9Zl
         fQwzNGh64IWkqufCTj6q9K5HIvU2UaWUB1ikfbOT3gWwVYVS1f6m2uamrQ7A/haHFlCS
         0QZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bS1cThwHIktcd5p9rJSSzoXzcbmkZO9SdVakwgQGsP4=;
        fh=KAxxboBNJJnOQ5uGr4jc/iJwjxgD1w8O5mgqjElOD2g=;
        b=FkFl+qDQ40uANPGMvCLIlCpupX5Hi8k/VIeP+ZoSGmjwNA9wpY4EVYAC69c4fHenaK
         tkXpvv4klklhuUkD/pfUunLtQAil4sGf0hb/w/3X94SeD7DL/0sbckOiQ9qCND4emWwx
         a0wOQMfuQgu1p6wBHOkDQc11wCCjC9Xn7F19qBhE+KO+yUhQc1M8SIA2xMXItJmbRwDD
         g9KQFc8HBjW0dYMBPmriv2r3gh6jmBg/TW7tpsHO4F2itEmZxa4bxTkWc3/sl/F4Dmpk
         k8M2K0bq11X7b7W/kXu8jBpUvZwvZCZ5mVUuHryFuMJag+YmrZj6y7cLd7yNs7Huof1r
         hEDQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776614174; x=1777218974; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bS1cThwHIktcd5p9rJSSzoXzcbmkZO9SdVakwgQGsP4=;
        b=TY7QFakUmDSnFkO9OCueGrxxE3kyULCWCSJseVljtd7/YdGBWg8gSPwfaKPTv71PYr
         r1/losgZX7D8VP54YTFVLgb3ZK2dEI38SJGlSSVQmmb8gYUgmsrDVS79oROatE/sC8Hc
         YtxbXCDFcmA+Peqn/sXbAFhKBh85lrNx8d7/aPzAtskwqENxmF0a31H0xZ8sveLqE6Q0
         L+phaS58QkuVHgoTx8MP59WlEsA7zzqSmvCwbZ86PjjNZDA/RxvDtYfKOjPG4QoUJdYT
         4g6cM1y8ik2YlLl5QX+e/1vaZJcdEv5EkLMcioYExSGe2B2K6pO0NmWnpx2EkyUGv4gv
         0DxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776614174; x=1777218974;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bS1cThwHIktcd5p9rJSSzoXzcbmkZO9SdVakwgQGsP4=;
        b=DWWOKoNOXtNzth9uJ+EnUPpwA5in408utnYksP+isVZkOsxz8X5ego7YcJb+6++3uC
         nYxcOry1ClRC6LkrCyEP8rp8TYD3Tah08LzEVp032CH89f8nfw7JH9Dy5m//Ruo4SxxD
         7RSJ9qXY4yyYp/XUcGxUy8YKDffuuCParb8DoyWxsRO83VbckyPZkKvjqaoRkxTh18HE
         dU9RCusD6qkXQEz6OIJf1RbqfWvo+dhDpryUxZ4UMCHE4nT6s/Cx6oVPj17ip8CZXQac
         Ss9bd8mMAecV5Tml6Pd+EejvHoczBaGfhSm8L2rl/VV3byQgDKYuXqBiY+B3TBttDcCA
         86Kg==
X-Gm-Message-State: AOJu0YwUbkKIwsYIqpNDxkPClqm3skT9xP4ItxicOz8IK/35MV7obLqT
	4mu6tpsUHHEY/c9U2qTv56LsCCenBxIrQ2K+XDMjyJCJbJGVlVHMnU10/Xd4R+nr2B2ER3NcKc4
	CiK6/9RyqvuhRlUDOndw89j5eaccG6Fw=
X-Gm-Gg: AeBDieuHfwS2PdUcfdX66A0TPfTl6SHF41kFNXJR2N6anuI+QmhHIei9kb3rhU/dEpA
	Z1XN3JfakPkyeNFIsk/qzacBvqiZJSkBc1JqolYrYqKGaTC1cTp/XNdeps7TA2aLTyoTJBei34l
	xmH6VKAmwOq0oG2FCoyprQvu7iJBMKblXw/iaLNq6Sru7U+KmnFU8q9x1fXonuCSVVBV0VSHTZ8
	WK0hCjQjKtH2Mwv0zVUfds6jN95/PhQoptRHYYfEhzDIFwTxjeFdBQyHMnPn3+MKKBNwAelY8Br
	NINKTyeKtPdgbUsCNQIUS1TaxxiW5IKCfOxwPWAaUQ5bmsNXDXw=
X-Received: by 2002:aa7:da09:0:b0:672:88a7:3888 with SMTP id
 4fb4d7f45d1cf-672bfd82e36mr3319269a12.5.1776614173974; Sun, 19 Apr 2026
 08:56:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260417-swap-table-p4-v2-0-17f5d1015428@tencent.com>
 <20260417-swap-table-p4-v2-9-17f5d1015428@tencent.com> <aeOPKlF4qAdM2oMH@yjaykim-PowerEdge-T330>
In-Reply-To: <aeOPKlF4qAdM2oMH@yjaykim-PowerEdge-T330>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 19 Apr 2026 23:55:36 +0800
X-Gm-Features: AQROBzAI4J739VXKT-UIynZGa6quQ6SqqMiU-pl0eYmKaSYDrbeDnFMA736To2Y
Message-ID: <CAMgjq7AmizS9v-F-VTeCwgexYdA42DJDMOPx17_aL3FFyhYSdw@mail.gmail.com>
Subject: Re: [PATCH v2 09/11] mm/memcg, swap: store cgroup id in cluster table directly
To: YoungJun Park <youngjun.park@lge.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Yosry Ahmed <yosry@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 094521C000F
X-Stat-Signature: 5mzcq7crt1e9mwzakcuouk8k3ck1tdah
X-Rspam-User: 
X-HE-Tag: 1776614175-240187
X-HE-Meta: U2FsdGVkX1/jvF9XFz/tnPKCiPt5Fw7XAbs6wMnXECOqRdYRGQ39pNkGI7UlZGRqcCUZd1RFd80uh0tWHwTjM5kyxcQPiNZmPJySyQQaZQ1ehnCWK0Wy2nkwtfdbsQBYH7e6PlHVAZj197dDzuFW3Ans/zp/TCAzGHhIcsQq6R9fwChQzGAs0dfTMkBLJ9MVgaMs9DtiCisekfr9UfwFtp5KaTAE5+n2XSZ3WiXMDsJh+ZopZC3Y96jlodTJkTpwPM/Tvo1nCKUtTPUKUq+Nrgon5HLWCv/kGGOztzBYZCF6KQ5xiqapN35GGFuPl8+nyJTOXHSWPY5jf+sjF89pJw/mEA8pBjjhEt/y1r2RU3qxsfE+PxMfsQnVa668VJqSyMCiAInf0IcL4yHwUPfgXEESqQqEyvxC3Xw7Hl/gtRTdBvoWUuiVBilvTjv0IKyxsgl9chzFI+vCTLutn6d/pA1ZlRUSRqczZ0n/w187TZOwurgD03uvkaACGine1+ztQzPYHGbHQ2gF9vsj3H058rr1cQqviBM4uQ6be2oQ4LSKcIueU6snDrj+QFG6vyxrxBgDebWqaiKASJ2sWEb4FHhZZIQlgZ0tH5tqZDvsOfTcYgrdQ8dw6V/nj4XAdRL0LmT8d5YhKIVFkl5ELpSo/HvNArqe135axkz3UIB+lHcpfGsirtV3ji3NxMB6P9AWAa2P0v+93f2z4HaAONfg/rVYYTv2SMIBdIQfAYUUUpey4iAvRUqKGDiWQwc/Hk3uiDnY/LlXXe2/b0XJX5GZfWBKUUM0l9U32O694nmoTpEOKYmEqe4jhCbAcebXyZGfD1d9xL29hdeUPO+PrdaR09KzOooOZaG0GLlxFguz7TIlAqZK04rpbpc/oIKbisjzFZ+fTaGvFOXQq4lfVpKZ0gQpgkLYFDiSGYROl4xT4S91gpyxXI6gRNSxTMsWaU8m5p5pAEMFy0WowXgPTN0
 L+baUO+3
 PYFK00L/MKlnwfs238aZ9X1cbUCcVlbj0BhnEF0X0rXvbH8KqvcS5Nn2Jn0m3xpSZO0zUNs5Oodht4NF6d2144ApCTwYdZYTAsVsediDonjJdtnl/fREqTvDTY8d1rn5YZ1pxlJ/xiW3g4rrVPZNs/dVMxOtcu9Ta2JPxbyohppncaIFeCnHFiMB3obfEwOv0+rn8QA9d+wAltOVo3ijwQD0eaMM9QdJ6DPVZvr0B2dcfjPtMn/saKSz9Nntd/tTb3P/AXvBi+oG42VEVblwzn/OyGm2VZpVlTMDF/W3zISC9McJKDEIZPwvvn0Iz3OWMLnAiklUN/c1w7bKM9MRHJM2I5Db2yn9rsnvBOrtZX2VMqFCRWXpj2Vm4UiRNtVO/dqEfh9tAmsbCfDetw1RWa5H62Gs4rbsgtdrpIb4obysHDAE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 18, 2026 at 10:05=E2=80=AFPM YoungJun Park <youngjun.park@lge.c=
om> wrote:
>
>
> > +             if (IS_ENABLED(CONFIG_MEMCG) && !memcg_table) {
> > +                     swap_table_free(table);
> > +                     return -ENOMEM;
> > +             }
>
> Hi Kairui,

Thanks YoungJun,

>
> Nit:
> (Just a readability nit. purely my preference, feel free to ignore.)
> the checks around swap_memcg_table_alloc() reduce to two
> equivalent forms of the same memcg success/failure question:
>
> (!IS_ENABLED(CONFIG_MEMCG) || memcg_table)   /* success */
> (IS_ENABLED(CONFIG_MEMCG) && !memcg_table)   /* failure */
>
> A macro for the failure side would let the call sites read as plain
> positive/negative:

Your suggestion is really helpful! I also thought about maybe I should
do some cleanup of metadata first before adding more metadata cleanup
for a memcg table. In this V2 it's still not that hard to follow, but
in V3 if we have an optional zero map bitmap, things may get really
messy if I just keep piling up things like this.

>
> #define SWAP_MEMCG_TABLE_ALLOC_FAILED(t) \
>         (IS_ENABLED(CONFIG_MEMCG) && !(t))
>
> SWAP_MEMCG_TABLE_ALLOC_FAILED(memcg_table)     /* failure */
> !SWAP_MEMCG_TABLE_ALLOC_FAILED(memcg_table)    /* success */
>
> Equivalently, the same macro can be expressed by splitting on
> CONFIG_MEMCG.
>
> #ifdef CONFIG_MEMCG
> #define SWAP_MEMCG_TABLE_ALLOC_FAILED(t)  (!(t))
> #else
> #define SWAP_MEMCG_TABLE_ALLOC_FAILED(t)  (0)
> #endif
>
> What do you think?

Good idea. I also agree this part needs some cleanup. I will take your
suggestion and do a few more cleanup in a seperate commit. Maybe just
let the helper return early if MEMCG is not defined or something like
you suggested.

Thanks for the review!

