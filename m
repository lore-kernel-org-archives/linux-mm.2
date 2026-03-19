Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4C0F1091916
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 20:49:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE03F6B0513; Thu, 19 Mar 2026 16:49:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C91126B0515; Thu, 19 Mar 2026 16:49:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7FFF6B0516; Thu, 19 Mar 2026 16:49:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A43DC6B0513
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:49:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5B6FF1DA06
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 20:49:36 +0000 (UTC)
X-FDA: 84564003552.09.1032EE6
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf28.hostedemail.com (Postfix) with ESMTP id C75C8C0012
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 20:49:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cyPYWwAl;
	spf=pass (imf28.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773953374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mk/FdkrzbHPB2q2H0hzPTF976Mgv7I2iTRANQZSXHNo=;
	b=mxzbgys3f8WFzBuzMpeUV98v/FHuzKI1hyV1EDOssKv8WL+8HlW0R4oY4oVL9ykqftUiaJ
	wVB4hFWYRTGX4QM2DQfsljweMWnyuOdI6X/RiLTxriyX1Bx9HHaUS4FnH4PubhLp9vFy/v
	OqYHtKBSNRiH+t/Ct1CtcCxHzwr9zlc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773953374; a=rsa-sha256;
	cv=pass;
	b=OxUmE9NnDyVzvspvwHhXdzgWRcEN4pc0vLRRYZG4vYRVOTrj9JDuLqZJ4at9f8eK5xokJj
	qvgC1P5H2dlBgU5HuIHinZs3NA9Fbi1u5tN57Hp5+eHqHHIsKBKTy8daF3Lkp5QgqHV4AD
	9riO0qIqM8xsDPHOTGv+s4CtI3CUBXs=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cyPYWwAl;
	spf=pass (imf28.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-89a1d7cc7f0so12846886d6.1
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:49:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773953373; cv=none;
        d=google.com; s=arc-20240605;
        b=Gslpcq9gGA7xJDoUuxM8D0JkK86MgVH33tB6w6QMeqmo1fQiHr1V17zgdzF+B8YPjB
         tLjaA5iWansnHtn5qt/6HUJY9iVARR2DEhr8kkTeCabHw/jGA+b9oCnpuRbv2OJg/zHD
         5qRP4dO2RJdVMMxTZ5xkInP8RkixsED0X4rIEFeDE5ZStM2urdDJ1O5jjiZsdxix1tGg
         YCpnmNYhfypMe/a/8foK37dDwH9+y2/uZMvGXPqmw/MIJjZkpfnb3onOPoCpk+cfNO5i
         j5JOLmPC6DLb2ptCzxJmUthLRcEQNtw8E6hy6z42V8DtePpOjRS3WubD1RlaPjJInf4u
         2ImA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Mk/FdkrzbHPB2q2H0hzPTF976Mgv7I2iTRANQZSXHNo=;
        fh=J+pB95G9D5LJQgpJG8UMwERTbrYca3H2K9LyBOCWwf0=;
        b=hG9YLHxafrNicfYq3XLLet2g8tuKnExK+EENe1yq/UYE/P460pKzafMJdKMF//KMFV
         kQd0+iMGgU0rgvuHdi3d/SjiOq7RJD0ZB1HI/CqgzBO7Fi/b7q2dkuwbAQCBEflUJTnv
         RNDn+xHMMf28P/Mh78+rNFAolctZR5Tnh19uqzyUzZl9ZZ5sKQUJb/hP7vTXLTDRdVRg
         sZZABvRKN6XeL1RxJLjG9KFZ8abmO1dYzk2aimLr+VDGrLiLzkn2Dn7WDS+GcENWvaRo
         vOaN+i5NxyyZTgKLUt3QnbjSVdfyUOaRZnK2/HAKXX8niWvyozn8pcqQKcYybE0nQYLb
         kX2Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773953373; x=1774558173; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mk/FdkrzbHPB2q2H0hzPTF976Mgv7I2iTRANQZSXHNo=;
        b=cyPYWwAlhYiTrp6s7x+GbL4fqFGE4c7ANizGLulU2QGI0YOY4lpKHb+mBf7//zXpNL
         19tR4W8mom7Q6vnWBUU6M+FusuMj7u14CAHRQV5YS9j1QBcUXPoOXnxMjN0MzySYlyup
         JPM/EEpq+I3eGSOX5laMVUJXG4ctIg5TiJNH4YGbanc9DKdBOmL2m9ReGNzzNjl+i8gf
         k7QLBri5pUHmGN9Je4MnC4jZN3uwNJPzrcx06nIOixXamIY1cKNdBt1Mi1Y4ZrT5I4ft
         6uvoIpCwnZg+nKRXH1yrG4s8dTmiEufZupXq+J9q2Lpth8OFnWPhp3n89H2IggpfRoQU
         SxBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773953373; x=1774558173;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Mk/FdkrzbHPB2q2H0hzPTF976Mgv7I2iTRANQZSXHNo=;
        b=dSrjG13WC0lbODkUIgEQG4CpFxD5t2CZdtIHeraAlfhSKElTKNHq1N9r5KlqHHFuwh
         5mJLZGuQFOFGJCrf4BF4brSOPBT82H8SBjRgiOO5pJ3OTgHyDH9cQ3y6RwRdajtYyu5Z
         3Ocw4/O/F+iXrf/FEYCgtq0UvjikEkhdqMRkQK44fA0NttQy473NMoLOkbWfCxh8VLfP
         6NOzCFnNvkHKA8dla/bt8Y7u7eUK0rsS3aqxyWeIpEGhU3WT/s+UoLtKG4Yrh6ou/PX8
         88agT982d2wKrYGfzDnQoCCeYnkiO+jiz/QrhrSL/yn45Fdttjz2anzBH6bpSQIOUWjL
         Os4Q==
X-Forwarded-Encrypted: i=1; AJvYcCUj19ssFQ7Ci1WB9ACA+8rdZ8woq1grq0i/BtF61CaR4wiEzgg1rDrZrtSJ3b62EWChDZ7M0w1JqQ==@kvack.org
X-Gm-Message-State: AOJu0YzGKRKiwuIGvHCpRjlWxKM2hyi8nI/2+hTlpF82rX0XNxEDIhiN
	MPta5W6vEsAxdQDERR9AZSSLmA+dygZgaG/zGqGxOy0GOslcusknAzk1myKaMCQAslE2S4wYRs8
	0SqelkUj0qPSKXUunEe6dTkYI4PI0CR0=
X-Gm-Gg: ATEYQzwGIXY/v/KUeVLeBM01ZCQL5Jd+myS4MRMftLcEyaD4NUOohVJKrhDT+G13SsC
	DZkK/JgOtdU1nJAxSPamnHFD2KU1u6qqwMoeBATvu6kjwslgAVQ5FuyHwlw/4b2W9UqVMU/LtNR
	Nfwy3PPTWO8t5NCbutF0ftQ2wZ0nPUvCFZWhvAolEURAUB9qtnJHhOtTPRtJkKT6PJvkqyaG/1M
	3nMVjTL4M2+dDCbeoY1dCKRDTtnoa/J6FyWCG2LirSDdWtSj1I6/oBC57laJHbZMgIfYxWrlASd
	/+bPAM9A
X-Received: by 2002:a05:6214:2b8f:b0:89c:823a:c4bf with SMTP id
 6a1803df08f44-89c85a0fca5mr8608336d6.14.1773953372405; Thu, 19 Mar 2026
 13:49:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260319-b4-switch-mglru-v2-v5-1-8898491e5f17@gmail.com>
In-Reply-To: <20260319-b4-switch-mglru-v2-v5-1-8898491e5f17@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 20 Mar 2026 04:49:21 +0800
X-Gm-Features: AaiRm51unDrwhO6wepn8Bm2RuLFP8uk43glHWWth2NpZnZi2i6MhheVsq5vexJA
Message-ID: <CAGsJ_4yY6q_kP74LtKpD=FEWPBH811Ch3EA=v6dxgYfyNtmZyA@mail.gmail.com>
Subject: Re: [PATCH v5] mm/mglru: fix cgroup OOM during MGLRU state switching
To: lenohou@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Jialing Wang <wjl.linux@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Kairui Song <ryncsn@gmail.com>, Bingfang Guo <bfguo@icloud.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C75C8C0012
X-Stat-Signature: ymternzzy4dxs5a7s1xau38afabfutg4
X-Rspam-User: 
X-HE-Tag: 1773953373-135134
X-HE-Meta: U2FsdGVkX19rYPzzCjHu6SweKahGeIp3eus8qmRIAggflCYUBqVSOihKFmvOAYWj9swJagvuc3TUdXH+mbvoUdxc6AgiFmHNy58UEQA/0En9kqzlOR3DDgwVHRh4tSlrpDYC2SxmS86PBxmBABeFJM9EoriQj1VSbCYwJF5EDwnSfpo/u3iJ+ZsRbKW1yzLFyoU1R5QJ/eFVr4UzsLmrB3vvLUDvSBKMcAdGVnsrQHyeMPixTvKoCgJgp58YwuZpVkwv/eGjurptVgMC/x+qZZ+EX6VRSsjzQDsoSHxFhumjTimwDuCsaoK3a+PtaEv095QU64OFxO10GGB38FF9C0qG4Z5SYAaVlYEaeYfH1CPQzu6rdF9DB0w/K8cW36fVykEdOTq6E+MvcmTfvRbStrZp3IAPoyB62LaQTTE83PJ1pvF2oveEhvIybZxclPLT/GS9teI0c0CIMJMM3aGbE0R7pXDRCyO2DrZP7OdQBhYL4l16qzpCYKbFzoeidEXVVNDFcMIeB+FcHF7fFI5o2zWzGtB/kYKezb0ji8MzuKC1IpIGQN4qrJvhXrZaPbnsyoH4NQxj1e+JjPifg8Ev9nW0bTgE00FtNX0PjMg9Ma4AULLwZTv8oAZqFWQzt83OwX91CaxjACuufnLtlV5FDGRrToA+BylN1pIfyCVVjq3NdIDD4UNGrhfX1kTWZP1XI0Qpu/pqwNPHrWDbpgqLo2j3Zx9d8Kk/BbExVuitpSb/NcAjKBT8toXDrrodETnOZ90ddK93f6W9CqbNsSoaek3w8c8HFVkVQ4nl/eMuFKqNSlHRqLRKZRscIiqpEXQbbzLXC8jgAc69UDllOVRzdh2e08816blvu4nbYExCurWgCwL8bhtJmPKdg5s6p10YhsZe1RXK6YhE5swHZpP3sGVOzt8OWKYIQVtFZdRA3aP0jHQgzN7hLz4PzE+33oPGgxOnE6KHwBQApkaEiv1
 gvSwvCq9
 FOQK3pXG7zvS7uLal17sUUoBDxuDXB1JL70w8QKyNyBE0GWV1kz/nnzpFxw3HOsd5wm0Etzix6TFadqM+6A5+ioTicNFV4FkNC1IArpFBRQc1owuqejOJC8SZ4t43+6Zixhrh4UBxe40wphHPdXdiLizvyAMWSp0FqKMlOfswUtW5G+fG9WzOhGWv85pB4/zCk27RoYDiq1pk01MnyvTPe17J3jb7XRktT6P7xIE5ihQWS2v00gyqyTmHi33ay5kKz3wPSOe1As8EaA0GXPxYPuafqfnXgsTeztr7J5Hiw/fVY9ROHjGzd7DqRA7QX7rd6WIs3wXu7v67DfpGiaIFyFSG9qiNZ+zBkwzktwsMPR2T61BnjSt3bJSKrD0LdB2SQnUYsq7KCD0xbBrbnmiDgFk0PjaFTi23v2+LJW2tLFNKFrEcI8BCQgclhBUziiQTTMYImh5KY40lMQzrdDJogoPSBSxvG0jZK/IjEUtXUlSJUNY8JxSxNPYLiBTTkARxwGAeMLf8gYuhxhhoRboU0ZF3PcYm/MFyzLHBIDXLLXh8ggtjSyayabomWrfwlphEBTKCUO0t2m7DmJsJv71Jr+xuaSuT6Fvxdbl/CRaGsuNm4/WBt/9lTycfPdPFdLrKAb3zV3QUISewzQNl2L/7wiLgfGxegz9JnSX+Sa/XFhvBRxMo5rldIt97VgvFZ03/wlbQmS6Y/rR6HFND42tLo2edOrXIL7u+qqV5zs0URAN5bHs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 11:40=E2=80=AFAM Leno Hou via B4 Relay
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
> Introduce a 'switching' state (`lru_switch`) to bridge the transition.
> When transitioning, the system enters this intermediate state where
> the reclaimer is forced to attempt both MGLRU and traditional reclaim
> paths sequentially. This ensures that folios remain visible to at least
> one reclaim mechanism until the transition is fully materialized across
> all CPUs.
>
> Changes
> =3D=3D=3D=3D=3D=3D=3D
> v5:
>  - Rename lru_gen_draining to lru_gen_switching; lru_drain_core to
>    lru_switch
>  - Add more documentation for folio_referenced_one
>  - Keep folio_check_references unchanged
>
> v4:
>  - Fix Sashiko.dev's AI CodeReview comments
>  - Remove the patch maintain workingset refault context across
>  - Remove folio_lru_gen(folio) !=3D -1 which involved in v2 patch
>
> v3:
>  - Rebase onto mm-new branch for queue testing
>  - Don't look around while draining
>  - Fix Barry Song's comment
>
> v2:
> - Replace with a static branch `lru_drain_core` to track the transition
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
> This fix has been verified on v7.0.0-rc1; dynamic toggling of MGLRU
> functions correctly without triggering unexpected OOM kills.
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
> When the Multi-Gen LRU (MGLRU) state is toggled dynamically, a race
> condition exists between the state switching and the memory reclaim path.
> This can lead to unexpected cgroup OOM kills, even when plenty of
> reclaimable memory is available.
>
> Problem Description
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
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
> Introduce a 'switching' state (`lru_switch`) to bridge the transition.
> When transitioning, the system enters this intermediate state where
> the reclaimer is forced to attempt both MGLRU and traditional reclaim
> paths sequentially. This ensures that folios remain visible to at least
> one reclaim mechanism until the transition is fully materialized across
> all CPUs.
>
> Changes
> =3D=3D=3D=3D=3D=3D=3D
> v5:
>  - Rename lru_gen_draining to lru_gen_switching; lru_drain_core to
>    lru_switch
>  - Add more documentation for folio_referenced_one
>  - Keep folio_check_references unchanged
> v4:
>  - Fix Sashiko.dev's AI CodeReview comments
>  - Remove the patch maintain workingset refault context across
>  - Remove folio_lru_gen(folio) !=3D -1 which involved in v2 patch
>
> v3:
>  - Rebase onto mm-new branch for queue testing
>  - Don't look around while draining
>  - Fix Barry Song's comment
>
> v2:
> - Replace with a static branch `lru_drain_core` to track the transition
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
> This fix has been verified on v7.0.0-rc1; dynamic toggling of MGLRU
> functions correctly without triggering unexpected OOM kills.
>
> Reproduction
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> The issue was consistently reproduced on v6.1.157 and v6.18.3 using a
> high-pressure memory cgroup (v1) environment.
>
> Reproduction steps:
> 1. Create a 16GB memcg and populate it with 10GB file cache (5GB active)
>    and 8GB active anonymous memory.
> 2. Toggle MGLRU state while performing new memory allocations to force
>    direct reclaim.
>
> Reproduction script
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> ```bash
>
> MGLRU_FILE=3D"/sys/kernel/mm/lru_gen/enabled"
> CGROUP_PATH=3D"/sys/fs/cgroup/memory/memcg_oom_test"
>
> switch_mglru() {
>     local orig_val=3D$(cat "$MGLRU_FILE")
>     if [[ "$orig_val" !=3D "0x0000" ]]; then
>         echo n > "$MGLRU_FILE" &
>     else
>         echo y > "$MGLRU_FILE" &
>     fi
> }
>
> mkdir -p "$CGROUP_PATH"
> echo $((16 * 1024 * 1024 * 1024)) > "$CGROUP_PATH/memory.limit_in_bytes"
> echo $$ > "$CGROUP_PATH/cgroup.procs"
>
> dd if=3D/dev/urandom of=3D/tmp/test_file bs=3D1M count=3D10240
> dd if=3D/tmp/test_file of=3D/dev/null bs=3D1M # Warm up cache
>
> stress-ng --vm 1 --vm-bytes 8G --vm-keep -t 600 &
> sleep 5
>
> switch_mglru
> stress-ng --vm 1 --vm-bytes 2G --vm-populate --timeout 5s || \
> echo "OOM Triggered"
>
> grep oom_kill "$CGROUP_PATH/memory.oom_control"
> ```
> ---
> Changes in v5:
> - Rename lru_gen_draining to lru_gen_switching; lru_drain_core to
>    lru_switch
> - Add more documentation for folio_referenced_one
> - Keep folio_check_references unchanged
> - Link to v4: https://lore.kernel.org/r/20260318-b4-switch-mglru-v2-v4-1-=
1b927c93659d@gmail.com
>
> Changes in v4:
> - Fix Sashiko.dev's AI CodeReview comments
>   Link: https://sashiko.dev/#/patchset/20260316-b4-switch-mglru-v2-v3-0-c=
846ce9a2321%40gmail.com
> - Remove the patch maintain workingset refault context across
> - Remove folio_lru_gen(folio) !=3D -1 which involved in v2 patch
> - Link to v3: https://lore.kernel.org/r/20260316-b4-switch-mglru-v2-v3-0-=
c846ce9a2321@gmail.com
> ---

A bit odd=E2=80=94I=E2=80=99ve seen v5, v4, and so on many times;
at least three times?

I=E2=80=99m starting to suspect my eyes are broken.

I guess we might have a changelog issue here?
Otherwise,
Reviewed-by: Barry Song <baohua@kernel.org>

Thanks
Barry

