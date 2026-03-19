Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD46F1075280
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 09:08:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E47626B044B; Thu, 19 Mar 2026 05:08:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1F606B044C; Thu, 19 Mar 2026 05:08:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D37426B044D; Thu, 19 Mar 2026 05:08:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C295E6B044B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:08:45 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 604FE1A0455
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:08:45 +0000 (UTC)
X-FDA: 84562237410.23.487DFB6
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6DB8D4000C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:08:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FQfkRvbM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773911323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ayqCI8G9id7CGanBnvKzqe8B2JggIRF4somjJjU3rqk=;
	b=bSqVlKAWLB6xA3xiJF1jMz+xaIpn1u/3J2kjrn1Wb8AjenpOqjC9W6N/a10/86EFXPstj0
	z/VHO/lHOYhntUrojnfWFYoCY+IDB7iM4+rD1M3RtEz7xV4Pd5Oiw11cKuGN+67nQttmQz
	I7HjV54kT6JjImQ8LtXpS1n/PXk5Ziw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773911323; a=rsa-sha256;
	cv=pass;
	b=m62r4VxrCCmXqH69El49lXFLHf6tNC4o0J1gc9/5/wqm9pFLuqvHKfgLm9GToyq3xsdBAi
	ovTFUv9iCjm6Yl60F2d00Ke7QE844cTCb2X5E7UGS/7n1Y9+Ln29rf9u31JRdzpBIwVXrW
	iSXNb8y44QYaRRntavUVsrbnvMbmsJM=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FQfkRvbM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-78fc4425b6bso7277417b3.1
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 02:08:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773911322; cv=none;
        d=google.com; s=arc-20240605;
        b=koUaO7kPABBjooF+cFvhFL6BWzkvBe5BI5X9d8ElO83cB7ip6YotTNwP3UpnK57/Nz
         WLauxyHEOgHfq+ksXTgOvXIgD4cOzHxIXL3DkfjdDyf/JIqEMhxyHxvV1hjeBzgECSyg
         h5hHAeMDVi2VZ9FlVORhdVty8/KsqpbYaMQlvqbI2H++uXqKQY7iQ1k6P6vCrbXgl+nR
         UzJ0+oFFzyH50SRT8nJtvW9d6k6dQdTwkQ1VCijUy4mQ/7qmb8X0jU1eG7gUBQFsFYf7
         bF50dPflXKZz3XFb246qYyrvntKsMLKli0gsRNUkMbc6OYrTjUSZTKWLbk0TczM0wPju
         Mqcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ayqCI8G9id7CGanBnvKzqe8B2JggIRF4somjJjU3rqk=;
        fh=ST02hxu5kmQ/CKM+v+LbREk2ChyZaWFPvPa5pNPgiIY=;
        b=Ff51WL1MNfCVE4J+mzunweFL3N0HKSHg/myGTp9AypmH6/zplELebtZsgIX+BtW6f0
         elXiKyK34DLWMsFnEdxxgoHNHy35bajbJhCWRZX3odX+nK3rlENFu0yJR52Vo+M3VTQX
         eOJZWqmZgxDpRh1ihE5nXXxx+BiKVkl+ERgu5mcYWYpPEPQeqFT3qObJVXwdvJP8g6+o
         ptF4BxJBIhNywML7jofxlxkDywgpNZujrH0TkM9UaodEMEQfiHkVu3vlIQ637TngoQZu
         PUJLPmni3lq8sfUeMPG4G5QvOBmf3aGdBNWwfQTPyXdLAGlFczW+4Xe/qtAXaHr7m9ZX
         LY6w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773911322; x=1774516122; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ayqCI8G9id7CGanBnvKzqe8B2JggIRF4somjJjU3rqk=;
        b=FQfkRvbMtgPBWHN+sPDCCnKzmSBXwbwwGVKXsXsUu04RbmSw8tE/NXcJ3pcurGHBWx
         +HeNd0ZuhOOwQGUtLr7txgJAdusZAIv2ftjay914+dy1zXIXBv8onqeAGLxgTEHGpwWM
         A4HNy96UCGRjxV7Fj8Ijp32m+qoOuWTg/1J1cp1m/0P82xo/6RGpAT7s5DrYORo2NPrS
         /9X305Ly4/Wg06V0cjGRieDcKFkhouLtAKOYORQ0isp8PnFm4veJQOEzjCcOnSejRUVu
         5hm+5ax9eIMVynbxdOEC3mMK05Ipi02L3O+ume2DzdwzJ6+6lBW1vMTpBq6qMZPXvdKh
         I71A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773911322; x=1774516122;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ayqCI8G9id7CGanBnvKzqe8B2JggIRF4somjJjU3rqk=;
        b=RbYPnsmYWUwdgGu5kq9kM7d9zH5s6EjJivsjIoDopgDCLfBhZWJQ7Qz2rz5ZOwBZQc
         RxS1SDe1EUGpnzZs2/Qye8kGt5sDeZ/08XU70qpNyU8TJ7mQgQvScuD5THNegVvszE1d
         pRZHQZbwCsQbiJeO1HgPw8edbeUQHMfy4HHcMPvdDDHyv0hrXJFKInipBNo4xGDzFJT+
         GnGmKpjPCDJXSthYdIaZAQ/Iyz7GNgPy5xIghDApXYFlVCVRyrFNdytTUfklhIvPlKVA
         vKKEwRtuuqE8KMuEbgTlpTD+Qgb0b31LRn+9btIgTqYTFpnMHYHTOhiRhPi3UmN9QQV0
         aYow==
X-Forwarded-Encrypted: i=1; AJvYcCWJVzXTLlv1ZOMpoEFvAbXfcKw156u3EZG0pfdcgqBi+1ofNT3lyVt6Mz8QCLmesPS9mM6k7oRhKQ==@kvack.org
X-Gm-Message-State: AOJu0Yz3kgs9A3q6jNCw49TqDbYqqQXd4tdlGSQt6SqKR8ciTyfamd1h
	Gcin6ldv4hdps/k12whP6oG0KXfVsrq5CZQRfugkRDHPeDsmJPyYNMP/LgjuncnuPdg31t4zbdb
	mnI0yC2/OCH1nz9T9aLafjrM7Gse2454=
X-Gm-Gg: ATEYQzzTJHzUIww//eCMykTv5L4/OVNdxtC5QMM3DZDrP2y4aWSTHnKwIhAYZXmy1Do
	nec5RzWy4DxWxwvk8BwfljHpsInjrLZxDUGSY/8W4TgWabBFkbg7kQs6WBhdMYi/yPJlNgsjFeR
	8neDf76qIbV2alYxDgvWKN9Tuc5y+LpOykExPImLyUH/3+eSs5ddn1sg/64Ywl2O21QjdJ+uLxM
	pQ5tKtUDW41jAYVSAL55DVBRkRJoexlesT4eu3lMWs5GsZF2VObTht4WFiOzu/SsWUfieGYaWjB
	ggqUM0G2
X-Received: by 2002:a05:690c:4706:b0:797:afeb:de93 with SMTP id
 00721157ae682-79a71830834mr48925157b3.12.1773911322382; Thu, 19 Mar 2026
 02:08:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260319-b4-switch-mglru-v2-v5-1-8898491e5f17@gmail.com>
In-Reply-To: <20260319-b4-switch-mglru-v2-v5-1-8898491e5f17@gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 19 Mar 2026 17:08:06 +0800
X-Gm-Features: AaiRm5300GxerLFgOQQB5S5IteQid131To_pj9OOMuACAoDStGAhJI2A4M5R88w
Message-ID: <CALOAHbAJ1=i04iYL2JKQ25ePtmbZtjRLqgjXirbOupLyYui8Hg@mail.gmail.com>
Subject: Re: [PATCH v5] mm/mglru: fix cgroup OOM during MGLRU state switching
To: lenohou@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Jialing Wang <wjl.linux@gmail.com>, Yu Zhao <yuzhao@google.com>, Kairui Song <ryncsn@gmail.com>, 
	Bingfang Guo <bfguo@icloud.com>, Barry Song <baohua@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6DB8D4000C
X-Stat-Signature: xwbee75dznstcup96661xinc855j7ttg
X-Rspam-User: 
X-HE-Tag: 1773911323-596713
X-HE-Meta: U2FsdGVkX1+ndx6Dx1oHcRl2DRr3VBxAu956Apmni6DeBCsXSyR9UFh2BM0tJt0AXj3k4LYyYXosJJDinKWkwoST05NBWnp9N8bUKGBXTk5i9U9ksMTMlTFzefam4R8kOoyQgpCr1z6vI0cPvCLifGhdCxfgFV8EXQDuIcNJukgqm1BYU1R0L6nPvkxQC72pKJKYv4UUdGjhUSmFp8y3vtDY8Pczjkj37tOoiUOxXOWSZKPfddEj7DE/rzbdHj3d2gU7fXYHzVPO0eXZ/XrjqIHcoay+JNCLAo5sz8kX5k+HadGzRQayjBTkCVqJBUNv1S8p2GyVcMhsve8AoQK1cWQtGLx7z+ypgVRB5SU8CKz5yX47VczDBh+V4qPpzRJ9qFNkCaHkrho6nKmSshrVdMhVmIYi4hn+VkRxplX5Cy4nuFdGXOI/g/Qh9pEtixoDQH72QY2EZ+pf0tWJR3T1Lil11OFraMTyOGjH7SvqVB5fsM/GtSyb3eJpaI51zwR4rF0v8XGySRSvAhjw0JQ54Uqry9znJ9HxBS1KUCQgf8OC2iZhQz9cjeNLTPTAk2BczLvFNqSLsNSi5KEubc539QlVuAsNI6SoZ7x8rHldHcQqc2qtBxFWETCzkQVE13pU0iKHQyxCs/atiAG3bi8YkQC8m2uk0JxsqRN/kO9Jq9b/x26YrmD1RpjVjvrt2HD+zSWn/TE5W7VNmqTmT2+/EfaIngpUxsiIe9YzMWNk9f8n96T7yd1wGXroGZQqcnYKPWR/a2qO6W/wIeSHyhVXhIT1Yt5noZXhTcdcJJXgVmp5DHB+GHMrF//CUMSqh7sX8zZG5iKUb74kLnV7Wbh/A7zuADxoMWwbiXVsag4n/lLtORI+mh4lYeoFLbECooHrafKMEBYga9VI5jnzDrcIJ8XLfk4vJsj23Gnzui1PkPrR3ILbchtO5sMrkUyLu2QP23psECJf6Uf8+Ky+JFx
 gJZc7IBC
 axhAmdaHYnsVwbAJsaT5g4KdKHCgfTmyFUcKuuddUO6w8BH3Rw7xAMkUwicDDxj3DeQUlqnIHs65g2tpYf3BUa8/iR+FnEHAHPcIVk5elVgCKU4o9O3Tuf6r1ZXizFGIqB1EpZD70CSYoPHFJsQhWGQ5PWcRitWz+bG3mVm8dswKnVp6BgESZGBQjKW/68oe+O8R/MzyzxmtlepDkH3ah/VwZcWSImi/tT6USiYTbZWnnXnmJmQ3Zc3JZ/mi8QrQ/snLGDU2tCQQKPRuOPl28MfgYJG077EA9pNcGWUKd4QP67cgOIl0gKFbwtmlBBntH+A+lHQ47sQI1DaRid5T81FFmYBFuoPrUfduv8ogLlltaYX71Ney8tDxTlvPb2feWwmO7LJSQ4OY81RWxG77ZFBK5Sr0QvKxy3e9/v+C97DAMgn2HtwLeqBOj9FjBGgdzMU/Uc2Ts4map/hJ+wZIzrcDdisdFmG0znxIjqj2/mYQb2aaeIR0AkasUWpPOnJlzSrI0+FgA3rli1B4Fnlq3Y3FJRxlf6aANQdgcm8HYXfhYMOBeWAZr0Wxaycn5YrGsl/QV9NTxSEvB0s99g7ZeVyqeDOoGWPiHd/6tvf+NFahnx4OrUS4a4FJsMy9037lpBpYjvo4vWnySXa5gChUi22xPCqseDS480DzWGUi5CMWyrBNFkRNiVM4i555DUuymF+ZrTUk83d5rHszyGeG4YmoLqffB6EFXv5MzYnmJb7rgr8g=
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

Since nobody toggles MGLRU very often, we don't need to over-engineer
this. As long as it works when you need it, that's good enough.

Acked-by: Yafang Shao <laoar.shao@gmail.com>

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
>  include/linux/mm_inline.h | 11 +++++++++++
>  mm/rmap.c                 |  7 ++++++-
>  mm/vmscan.c               | 33 ++++++++++++++++++++++++---------
>  3 files changed, 41 insertions(+), 10 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index ad50688d89db..760e6e923fc5 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -102,6 +102,12 @@ static __always_inline enum lru_list folio_lru_list(=
const struct folio *folio)
>
>  #ifdef CONFIG_LRU_GEN
>
> +static inline bool lru_gen_switching(void)
> +{
> +       DECLARE_STATIC_KEY_FALSE(lru_switch);
> +
> +       return static_branch_unlikely(&lru_switch);
> +}
>  #ifdef CONFIG_LRU_GEN_ENABLED
>  static inline bool lru_gen_enabled(void)
>  {
> @@ -316,6 +322,11 @@ static inline bool lru_gen_enabled(void)
>         return false;
>  }
>
> +static inline bool lru_gen_switching(void)
> +{
> +       return false;
> +}
> +
>  static inline bool lru_gen_in_fault(void)
>  {
>         return false;
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 6398d7eef393..b5e43b41f958 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -966,7 +966,12 @@ static bool folio_referenced_one(struct folio *folio=
,
>                         nr =3D folio_pte_batch(folio, pvmw.pte, pteval, m=
ax_nr);
>                 }
>
> -               if (lru_gen_enabled() && pvmw.pte) {
> +               /*
> +                * When LRU is switching, we don=E2=80=99t know where the=
 surrounding folios
> +                * are. =E2=80=94they could be on active/inactive lists o=
r on MGLRU. So the
> +                * simplest approach is to disable this look-around optim=
ization.
> +                */
> +               if (lru_gen_enabled() && !lru_gen_switching() && pvmw.pte=
) {
>                         if (lru_gen_look_around(&pvmw, nr))
>                                 referenced++;
>                 } else if (pvmw.pte) {
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 33287ba4a500..605cae534bf8 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -886,7 +886,7 @@ static enum folio_references folio_check_references(s=
truct folio *folio,
>         if (referenced_ptes =3D=3D -1)
>                 return FOLIOREF_KEEP;
>
> -       if (lru_gen_enabled()) {
> +       if (lru_gen_enabled() && !lru_gen_switching()) {
>                 if (!referenced_ptes)
>                         return FOLIOREF_RECLAIM;
>
> @@ -2286,7 +2286,7 @@ static void prepare_scan_control(pg_data_t *pgdat, =
struct scan_control *sc)
>         unsigned long file;
>         struct lruvec *target_lruvec;
>
> -       if (lru_gen_enabled())
> +       if (lru_gen_enabled() && !lru_gen_switching())
>                 return;
>
>         target_lruvec =3D mem_cgroup_lruvec(sc->target_mem_cgroup, pgdat)=
;
> @@ -2625,6 +2625,7 @@ static bool can_age_anon_pages(struct lruvec *lruve=
c,
>
>  #ifdef CONFIG_LRU_GEN
>
> +DEFINE_STATIC_KEY_FALSE(lru_switch);
>  #ifdef CONFIG_LRU_GEN_ENABLED
>  DEFINE_STATIC_KEY_ARRAY_TRUE(lru_gen_caps, NR_LRU_GEN_CAPS);
>  #define get_cap(cap)   static_branch_likely(&lru_gen_caps[cap])
> @@ -5318,6 +5319,8 @@ static void lru_gen_change_state(bool enabled)
>         if (enabled =3D=3D lru_gen_enabled())
>                 goto unlock;
>
> +       static_branch_enable_cpuslocked(&lru_switch);
> +
>         if (enabled)
>                 static_branch_enable_cpuslocked(&lru_gen_caps[LRU_GEN_COR=
E]);
>         else
> @@ -5348,6 +5351,9 @@ static void lru_gen_change_state(bool enabled)
>
>                 cond_resched();
>         } while ((memcg =3D mem_cgroup_iter(NULL, memcg, NULL)));
> +
> +       static_branch_disable_cpuslocked(&lru_switch);
> +
>  unlock:
>         mutex_unlock(&state_mutex);
>         put_online_mems();
> @@ -5920,9 +5926,12 @@ static void shrink_lruvec(struct lruvec *lruvec, s=
truct scan_control *sc)
>         bool proportional_reclaim;
>         struct blk_plug plug;
>
> -       if (lru_gen_enabled() && !root_reclaim(sc)) {
> +       if ((lru_gen_enabled() || lru_gen_switching()) && !root_reclaim(s=
c)) {
>                 lru_gen_shrink_lruvec(lruvec, sc);
> -               return;
> +
> +               if (!lru_gen_switching())
> +                       return;
> +
>         }
>
>         get_scan_count(lruvec, sc, nr);
> @@ -6182,10 +6191,13 @@ static void shrink_node(pg_data_t *pgdat, struct =
scan_control *sc)
>         struct lruvec *target_lruvec;
>         bool reclaimable =3D false;
>
> -       if (lru_gen_enabled() && root_reclaim(sc)) {
> +       if ((lru_gen_enabled() || lru_gen_switching()) && root_reclaim(sc=
)) {
>                 memset(&sc->nr, 0, sizeof(sc->nr));
>                 lru_gen_shrink_node(pgdat, sc);
> -               return;
> +
> +               if (!lru_gen_switching())
> +                       return;
> +
>         }
>
>         target_lruvec =3D mem_cgroup_lruvec(sc->target_mem_cgroup, pgdat)=
;
> @@ -6455,7 +6467,7 @@ static void snapshot_refaults(struct mem_cgroup *ta=
rget_memcg, pg_data_t *pgdat)
>         struct lruvec *target_lruvec;
>         unsigned long refaults;
>
> -       if (lru_gen_enabled())
> +       if (lru_gen_enabled() && !lru_gen_switching())
>                 return;
>
>         target_lruvec =3D mem_cgroup_lruvec(target_memcg, pgdat);
> @@ -6845,9 +6857,12 @@ static void kswapd_age_node(struct pglist_data *pg=
dat, struct scan_control *sc)
>         struct mem_cgroup *memcg;
>         struct lruvec *lruvec;
>
> -       if (lru_gen_enabled()) {
> +       if (lru_gen_enabled() || lru_gen_switching()) {
>                 lru_gen_age_node(pgdat, sc);
> -               return;
> +
> +               if (!lru_gen_switching())
> +                       return;
> +
>         }
>
>         lruvec =3D mem_cgroup_lruvec(NULL, pgdat);
>
> ---
> base-commit: 39849a55738542a4cdef8394095ccfa98530e250
> change-id: 20260311-b4-switch-mglru-v2-8b926a03843f
>
> Best regards,
> --
> Leno Hou <lenohou@gmail.com>
>
>


--=20
Regards
Yafang

