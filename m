Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FAFCF33809
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 07:52:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFEA66B0088; Tue, 17 Mar 2026 03:52:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB65A6B0089; Tue, 17 Mar 2026 03:52:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9774F6B008A; Tue, 17 Mar 2026 03:52:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E8716B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 03:52:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0BE6CC1FEC
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 07:52:21 +0000 (UTC)
X-FDA: 84554787282.09.9D977A2
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf04.hostedemail.com (Postfix) with ESMTP id 19E1240002
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 07:52:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K41Bw1IQ;
	spf=pass (imf04.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773733939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wXuSrwefBf4r7rRiK0LKFFEFXQP30aBEiH93AgmCVb0=;
	b=RxjpYv1zUdhsUBTZSga6jnY5Ic0Qysu7S2NQhFMk8/QNCLwVaiM9dqVfRTmaZqyONwi92G
	W/fyixTAD1TCPR6kkMxFwbforfq6ttiiNqJ20uSgdKu8gjDVFSdn96Yf68hondJ/1lPuuz
	1K6C+z5cpvRFnZLdjeVgqhJx+IBLLqA=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K41Bw1IQ;
	spf=pass (imf04.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773733939; a=rsa-sha256;
	cv=pass;
	b=KuN8cr4o53q/kv/qIN0dP8AEibxB6QJ+IfsybceOU4xCccsFB6ewTnIAkweYmfVjOXbb03
	9k7b5Ov9R5OWjLUf8w3i8n3lWFM7FYNb7Wzb+BpV6MOiTjSx7qH7w7cJ/P94E/AGwbo6x2
	3geWrdo42GYLluMW9MQ4l3vHNfk36nw=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-89c55a0a470so18763766d6.0
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 00:52:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773733938; cv=none;
        d=google.com; s=arc-20240605;
        b=GLhrnOSaPnSUzALQl1vIxBfo3Lk/m7e9xGaf1GjkroBEy2+73UxrzQA7S1vwBqQLCe
         RstVeN7hJFARYnrSjLgd5QaFt8SRWpAbq5kmQmz8s/mVz8sSSPMnNzIzRjcsdQ17Ca5D
         420Ht8ugV560C7+MfGx7/TOifrGqQvzV8Vyli+w2EvkWGqiG1vp6GwGZETLgG0nTrAHr
         LfmD2jw3I5LuNi54ieFVA7MzjsB9OVx6r+LP7nwBWeRt8CPO+ftWgCUjVpQn4mcbe+XD
         EkFwvpIqjkp4OCLa7PlVGjeRnKNxvKHmB/YZNlRKBMSaNz87VRuoyvfxPh5afGAChWnQ
         X6Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wXuSrwefBf4r7rRiK0LKFFEFXQP30aBEiH93AgmCVb0=;
        fh=pY1NKYZzVXOPpfN0tRqcI069yzoewMdijUYqvVi3R3Y=;
        b=Kz3TTzRZ+qH6O4wNgBIj9X/d95A/KT5kbG+9mmE4yE7qckZJutUyzJ3LxV4KPom5JF
         Nq5uXgfPyN3vWXMD+uBWG40Ef9Eli7B2a7Yy0O4U2JnfS3HvQBRgBB8RzFgNqE6i5RL/
         +RkfkXFOFqUYPZJPPgq+rDixkK2yp1f4pPKfsx23F6gr7JWPyGOhNR5D9zV7C+1PMeEf
         JTJuOjZM8SS28x1EGRvUUbO+AC7wV7MUh1oxk3uMqfilX9dNiBAaHVfe7t9GnN48SKVk
         rakqNoJNobgnLV/k4RCP3NTywkYPle1VP2N6w9M9Y8lkrr2ahs5osUAngx+YEdZrA4e5
         H0Cw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773733938; x=1774338738; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wXuSrwefBf4r7rRiK0LKFFEFXQP30aBEiH93AgmCVb0=;
        b=K41Bw1IQcnEp2GNhRx1RuBjAA3xDO6/PgIXfDVkKdZmPldLfO8ZcAgn5UDxCdjD5VZ
         168Lq3qhoh6doB0AxWofUiH1H+k0dIDBdY0vIjuIonBDAISFyuDyjBybmklIB6psVbq1
         pCy73RgxF6fPSmSaNoZ03WtYEeZPFyd38GYpwC3P4IRkivoMJmPXEzIi4oqOOLWNb5+2
         FDBGVroUG79QcRbTr8ytI4U9nZRA0EoX3VhvRYD6gNhen46xzXVI/dzhZAxVfE86WITs
         8qsL/eJU0Twzn9ABppu2ew8qjJhiLjPLYOcSe8lYU3Y73Er/mWrL6RQ6WYwbKkX2lpri
         mCgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773733938; x=1774338738;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wXuSrwefBf4r7rRiK0LKFFEFXQP30aBEiH93AgmCVb0=;
        b=O/acF5goJsWDfyGEtdILdxyLSaV6RNBA4RFClGSHbr1FBQRA1Cp/DsEWmbdZ2FJYAl
         O3O+GXz4JfTqdu/frMUaUwiqe1QYEUrPWg/N/GteVTW19zFllpxd4UYOMUXGgZAydIfr
         zzhNEivgBlZWnqzpLjKa0Z3BiDJBw7FkIctb8wilWG3NTBffTOE4eGLcaQnv08AnaYVX
         Oc2Lsv8w/bzkBDKJU8Ldi9IQw9R1a5BTvTDGRVUlppvgz6UbeYoqq9qFXXrg5I5VnrqL
         UNIjHbRlpqb9xrL9HoY0xzIsum2m18QI4CYIVKosE89INMO2n1BVVPksmm8M0s5b+O96
         jyIA==
X-Forwarded-Encrypted: i=1; AJvYcCWnyjWXuBP3fejRrGEKczP/H4qNXVJEHDdqA0Yv52c9AXRgW7UsFVV+/FTXLmEozC/jt82LSdjVQQ==@kvack.org
X-Gm-Message-State: AOJu0Yz5bOgUVA+lekmJzbHWjEt5U0eLeIQBMz2gnH0w5eWSDo3/airH
	pcE2c8tdvzbvICBgYoqLjSpI5lBxyutaszbjSJkgC28/a5oSBZvDVMUEaVA3cA1Q4D+PrhHZYNx
	6rx1Qnse/pZbUCff4Padq0NtUC28Sfls=
X-Gm-Gg: ATEYQzymFzkDiW+Xmfnkhes3Wq8YrMBRzHZGzDcyOzED/cy2EO+aJhsUVmgeBtsc3Xn
	9XpFVzpSAG1i+QvNSDuxn1bc6vq6ICj2FmUJ7vFEXEE/am2WD7wdZmEqtuGwe6Qt4qGf9rM6IMV
	GrOk/NN4Tq7uCnQHfaQntMZ/U4hMt78GTh1OH+ba+bNp/I0H/WDhU3nqJz35Dns4pjhBWCicQTX
	k5zK3x/KGXusc5OEgbXcM4vvgZBr5vHtpUbtUl/34uIcDn9aFgNkNVdQQVchSarcyzgPuNlCkxX
	2pkeYA==
X-Received: by 2002:a05:6214:1c85:b0:895:4bec:c629 with SMTP id
 6a1803df08f44-89a81f72f79mr239209446d6.31.1773733937720; Tue, 17 Mar 2026
 00:52:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260316-b4-switch-mglru-v2-v3-0-c846ce9a2321@gmail.com> <20260316-b4-switch-mglru-v2-v3-1-c846ce9a2321@gmail.com>
In-Reply-To: <20260316-b4-switch-mglru-v2-v3-1-c846ce9a2321@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 17 Mar 2026 15:52:06 +0800
X-Gm-Features: AaiRm51GNcm7uVy_98J3LHYNT9VWrNs49syxqXXl6QSWhyKbrp0fFX5BWdE32Y4
Message-ID: <CAGsJ_4wvmZMnLp9V68zOAs9xze3zpSrNGhGZT9gSi_9-93LjgA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] mm/mglru: fix cgroup OOM during MGLRU state switching
To: lenohou@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Jialing Wang <wjl.linux@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Kairui Song <ryncsn@gmail.com>, Bingfang Guo <bfguo@icloud.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 19E1240002
X-Stat-Signature: 6o36mqx6pftjhx6pyn8aokpdwkson91t
X-Rspam-User: 
X-HE-Tag: 1773733938-227709
X-HE-Meta: U2FsdGVkX18FmfZf6FmzpN6is9kqyrjJTQYkmVKLWxqS6qI56srCId8jGG1PPX6W2LGuQv59stEroXgfUNYhzrFvwRcFnD2OlvpZWhy8EaaDE//6GNQZGHX7WZG3JZHPA+yBCV65BFzM6bZeowPQI2ot7M8HD3sejMKCTSTeyKnHgXoQ9mP/DpT3PaVm75yhcP/z7Bo2/WDjoA5tkjZZ0U3o7P3Hbif7wF5G3NWkrKuFvFL9ne5UQSZ9qRVv+54Z9awx+ULhhapGZdaXD1O9QxtUXEPQjDHpiPr5oEqeII+mxRVa5P03BIwXowFzKOjXghqMWTJDskIlrqEmdFdAIOeGHZfjPj5I0WN8UmG4HefYDlDMsEHVtfSvM1CyNE5TV0ww6P7K9KpxS5uZ9YU9U/Jz1kVwtFJeqSgp11Na2AJebmVBJ2gPFaCtHUWRWqlmfHK0IovmForzCVCoMZf5uzd1qogoTqncNsXlaQoX4/AsMxO2ki0Vx9WnsqZRZTO6cp7NyKdW8TKPRBK8h834133fz+UHxRqzrft+A/pHt2maYDSLVSOv7f9eSjTHdAOGA7YxSIdwoLil2TuHkNSwu2VbU0oTiG/NoTBg93tZ4bjHyvjvPeqidW0I0yvokcZv/kl/pEmTn8J/feXVGH/VWDwEfJJW7P1eKS1oCXFNk2cZPZybYpAM4RnVWhejhqLH/5yu2g99YkKYSyEev1Y7093gdZ9oaa14JDrUchdXrM+YHdtMGr4s3ttOVeja4hETNwO9rKEgc9wjk1FiCj+wbuBJZ3VNNhh/KTruMJ0Ocj4AYzqNftUhBC3RnRdCn/YFJLSEIu++ziS5PTd6bfKuLS1ZsrF1VrCLorvpgTOKsAdBZMeofmQPq09fgZSvTcbQkOORk4KVxrIzz9aRmIDgaut12ZukYznvW6Ez7nP83CUGCxE+sq/0GnDmjnzvVjh1miG0q9sO2gKxlJvrQne
 ROAkzPZ0
 PiB1s6yZHSDdbEalrrw3OiYwz2zK1+dNXUYcYBM1TyyoM7cuJDUJDzfeT6DZYXlYcbkkBYFiHruEtWwM2hQI3ChNqEFB3K6cIKOv3bhc6OppiJx3VVEh3wsI+yifZvy51akxeB7JOYsOa419Ssai2s7TkAFYALcHTwXz9l2a7WH8QX4J2Lb/sIBrLN7nGHTNHktckzVLS0+2PzcRPKWreJ3X52NQZjsTKEOp5SC5BXZRHgI7sqQvumtqua+KqbyaKWKyuIG8Zh/N6f2mBv63VoDNZqx9WQ/FBH+dyWoexbFHWAXk9T4o3JnukOPiCn9YgbsMX9oTRGE24LZtuReHKAeqcOsMnKI3PEcNGV2Wy6OJ03AJxpGrAYgxk+zj9cm7+CI7cveUODtGET6lvsg7sFg38kkqR5IK1fofJFc1nwCXNcI00T2TKO24iTDJ3Y/ISBRad0nK3wda1thHBBRQlsSPl2iUZ4QK+1JY5Rnmk9MqPYvHoiV2CzUmFapMAG8VaNI4BuWfqGkzPGAwL+F9ltnGtEdU5W2Pz5EMtKMLQiSrKIdbPlyrT7Ib27oKqTVSr4Z3D/acx6DNQ6UoKwaqe/bTh92J0EDu5efJbTvyCxlDD7zhbGI1oD0NwAbJc9VVwBFDpNA9LVjELTx4gNBkQReQ5I/8gMo52jUNeJv9FNFcukXhzoZNsOzaXUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 1:56=E2=80=AFPM Leno Hou via B4 Relay
<devnull+lenohou.gmail.com@kernel.org> wrote:
>
> From: Leno Hou <lenohou@gmail.com>
>
> When the Multi-Gen LRU (MGLRU) state is toggled dynamically, a race
> condition exists between the state switching and the memory reclaim path.
> This can lead to unexpected cgroup OOM kills, even when plenty of
> reclaimable memory is available.
>
> Problem Description
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> The issue arises from a "reclaim vacuum" during the transition.
>
> 1. When disabling MGLRU, lru_gen_change_state() sets lrugen->enabled to
>    false before the pages are drained from MGLRU lists back to traditiona=
l
>    LRU lists.
> 2. Concurrent reclaimers in shrink_lruvec() see lrugen->enabled as false
>    and skip the MGLRU path.
> 3. However, these pages might not have reached the traditional LRU lists
>    yet, or the changes are not yet visible to all CPUs due to a lack
>    of synchronization.
> 4. get_scan_count() subsequently finds traditional LRU lists empty,
>    concludes there is no reclaimable memory, and triggers an OOM kill.
>
> A similar race can occur during enablement, where the reclaimer sees the
> new state but the MGLRU lists haven't been populated via fill_evictable()
> yet.
>
> Solution
> =3D=3D=3D=3D=3D=3D=3D=3D
>
> Introduce a 'draining' state (`lru_drain_core`) to bridge the transition.
> When transitioning, the system enters this intermediate state where
> the reclaimer is forced to attempt both MGLRU and traditional reclaim
> paths sequentially. This ensures that folios remain visible to at least
> one reclaim mechanism until the transition is fully materialized across
> all CPUs.
>
> Changes
> =3D=3D=3D=3D=3D=3D=3D
>
> v3:
>  - Rebase onto mm-new branch for queue testing
>  - Don't look around while draining
>  - Fix Barry Song's comment
>
> v2:
> - Repalce with a static branch `lru_drain_core` to track the transition
>   state.
> - Ensures all LRU helpers correctly identify page state by checking
>   folio_lru_gen(folio) !=3D -1 instead of relying solely on global flags.
> - Maintain workingset refault context across MGLRU state transitions
> - Fix build error when CONFIG_LRU_GEN is disabled.
>
> v1:
> - Use smp_store_release() and smp_load_acquire() to ensure the visibility
>   of 'enabled' and 'draining' flags across CPUs.
> - Modify shrink_lruvec() to allow a "joint reclaim" period. If an lruvec
>   is in the 'draining' state, the reclaimer will attempt to scan MGLRU
>   lists first, and then fall through to traditional LRU lists instead
>   of returning early. This ensures that folios are visible to at least
>   one reclaim path at any given time.
>
> Race & Mitigation
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> A race window exists between checking the 'draining' state and performing
> the actual list operations. For instance, a reclaimer might observe the
> draining state as false just before it changes, leading to a suboptimal
> reclaim path decision.
>
> However, this impact is effectively mitigated by the kernel's reclaim
> retry mechanism (e.g., in do_try_to_free_pages). If a reclaimer pass fail=
s
> to find eligible folios due to a state transition race, subsequent retrie=
s
> in the loop will observe the updated state and correctly direct the scan
> to the appropriate LRU lists. This ensures the transient inconsistency
> does not escalate into a terminal OOM kill.
>
> This effectively reduce the race window that previously triggered OOMs
> under high memory pressure.
>
> To: Andrew Morton <akpm@linux-foundation.org>
> To: Axel Rasmussen <axelrasmussen@google.com>
> To: Yuanchu Xie <yuanchu@google.com>
> To: Wei Xu <weixugc@google.com>
> To: Barry Song <21cnbao@gmail.com>
> To: Jialing Wang <wjl.linux@gmail.com>
> To: Yafang Shao <laoar.shao@gmail.com>
> To: Yu Zhao <yuzhao@google.com>
> To: Kairui Song <ryncsn@gmail.com>
> To: Bingfang Guo <bfguo@icloud.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Leno Hou <lenohou@gmail.com>
> ---
>  include/linux/mm_inline.h | 16 ++++++++++++++++
>  mm/rmap.c                 |  2 +-
>  mm/swap.c                 | 15 +++++++++------
>  mm/vmscan.c               | 38 +++++++++++++++++++++++++++++---------
>  4 files changed, 55 insertions(+), 16 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index ad50688d89db..16ac700dac9c 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -102,6 +102,12 @@ static __always_inline enum lru_list folio_lru_list(=
const struct folio *folio)
>
>  #ifdef CONFIG_LRU_GEN
>
> +static inline bool lru_gen_draining(void)
> +{
> +       DECLARE_STATIC_KEY_FALSE(lru_drain_core);
> +
> +       return static_branch_unlikely(&lru_drain_core);
> +}
>  #ifdef CONFIG_LRU_GEN_ENABLED
>  static inline bool lru_gen_enabled(void)
>  {
> @@ -316,11 +322,21 @@ static inline bool lru_gen_enabled(void)
>         return false;
>  }
>
> +static inline bool lru_gen_draining(void)
> +{
> +       return false;
> +}
> +
>  static inline bool lru_gen_in_fault(void)
>  {
>         return false;
>  }
>
> +static inline int folio_lru_gen(const struct folio *folio)
> +{
> +       return -1;
> +}
> +
>  static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio=
 *folio, bool reclaiming)
>  {
>         return false;
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 6398d7eef393..0b5f663f3062 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -966,7 +966,7 @@ static bool folio_referenced_one(struct folio *folio,
>                         nr =3D folio_pte_batch(folio, pvmw.pte, pteval, m=
ax_nr);
>                 }
>
> -               if (lru_gen_enabled() && pvmw.pte) {
> +               if (lru_gen_enabled() && !lru_gen_draining() && pvmw.pte)=
 {
>                         if (lru_gen_look_around(&pvmw, nr))
>                                 referenced++;
>                 } else if (pvmw.pte) {
> diff --git a/mm/swap.c b/mm/swap.c
> index 5cc44f0de987..ecb192c02d2e 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -462,7 +462,7 @@ void folio_mark_accessed(struct folio *folio)
>  {
>         if (folio_test_dropbehind(folio))
>                 return;
> -       if (lru_gen_enabled()) {
> +       if (folio_lru_gen(folio) !=3D -1) {

I still feel this is quite dangerous. A folio could be on the
lru_cache rather than on MGLRU=E2=80=99s lists.

This still changes MGLRU=E2=80=99s behavior, much like your v2, which
effectively disabled look_around.

I mentioned this in v2: please avoid depending on
folio_lru_gen() =3D=3D -1 unless it is absolutely necessary and you are
certain the folio is on an LRU list.

This is hard to verify case by case. From a design perspective,
relying on folio_lru_gen() =3D=3D -1 is not appropriate.

Thanks
Barry

