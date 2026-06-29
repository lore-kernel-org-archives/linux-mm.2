Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9530EC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 00:21:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D3B16B0005; Sun, 28 Jun 2026 20:21:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35DC36B0088; Sun, 28 Jun 2026 20:21:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 200356B008A; Sun, 28 Jun 2026 20:21:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E09176B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 20:21:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3B273C1F26
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 00:21:10 +0000 (UTC)
X-FDA: 84931045500.26.7642361
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf08.hostedemail.com (Postfix) with ESMTP id 472E416000B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 00:21:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LlYeafmc;
	spf=pass (imf08.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782692468;
	b=qJ1lahsqvLA8ZN3dlQB5dv/gb/5E+Q0I0A4YwbXEvSGesfRZgcsfVWVdjcMddPu0QDJoSJ
	525itbI0xWAbPGpd9xvuJwG648SUUycY/R9f+QM2Lbke4dDePODAva7gPAxSNESIsiG+3o
	k+vOWNutnsHnrcDLNzZHtWjI53Q0/qU=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782692468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=neBR3VtamRz9x5zM02CGSvqqsQzuRKF0xxUw39lUWvM=;
	b=t/8DIgw+fKvpkijBb2GeE0Q4y+fx7E465zBLEeltG2nV2Dj5pLpdrhmsVI4GfxfwM3uzeN
	3f6Z4Mc3CG1lwpddpNzueRU9qkHXvETI4LyFnnCS28tB+McrFmu681dcvzBnt86CfNUzt0
	C5c6FrKThZQBunQ+GNNgi4nN8Qx0b3A=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LlYeafmc;
	spf=pass (imf08.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5aeb18fe7ceso635612e87.0
        for <linux-mm@kvack.org>; Sun, 28 Jun 2026 17:21:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782692466; cv=none;
        d=google.com; s=arc-20260327;
        b=lJ28IT9qiNALsVXlhyhPX+mPPsAbhJIlaXveTPjpFWe10Z2sM+lCQK96Istl4HykV4
         AW77rJbpCAmYx0lWxUTWeuFb/oxzKNQFmX7Q3lhB69RFD7W1406IONNFM/qX02gv7xl9
         +V8zf5fN3xARvM0anlmHYoyWkKXbiMa2ctKvvtaclyIMNE0R8sP1HqKXxNMir/yzeeh6
         vckr+zNC6r6b/1tYEW0IRkhL+vM0nQP2O6Sa6IjjSLxO64cZPYI5uV/oV3wcJvKIaDy0
         M7HgmnT5HCVEhqdGj3jNCCx2d6DN1e/faApwdfutehBJrm405sZeoLQYBw+agn2U8rS4
         +myw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=neBR3VtamRz9x5zM02CGSvqqsQzuRKF0xxUw39lUWvM=;
        fh=oa3Ss5v5RysVbWQLd109uLkeb+ekiFOrnqoJUhz0kko=;
        b=LKKNVaYSbtPcs1lRvznb4CKIeBlXqkghe51CC5v83EkqaDrEtFtd+s4miHJlRBSwX4
         DdkcPrTyICdsJcPJWizoqAyEcG5A0VwyGWUI8dEhMl/mkwUAnmujf2SOsBoZwLcNJGLS
         y4Hk/WmvJLDoPc/vuDgBC+yXBd0qp+Q8V+AcCaWiBn7R6tuhJ4lx9oJu9q3QvNDJKbzT
         B6d1bQ99t7tpZZECdYCqBhNIzJNDJpUDU8V2vg/32RrrMt1aDdQvr3qe8aJwc/bwyohD
         qWpTrMc4gVxW5SxCRWd7IK7/SuDT8IAHPo7hrFl0Mbe16Ay0+0yPlNEs0hly8f6eUJhI
         e+Mg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782692466; x=1783297266; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=neBR3VtamRz9x5zM02CGSvqqsQzuRKF0xxUw39lUWvM=;
        b=LlYeafmc2gpvPAczsBOq3Me+HrFI+OIVtInf9qYZleqHJtM1KSJSgs2qq2jw5a/HOZ
         TCdo/Xfkr3IKNlis/iBmsYfrj54AbHrZ2r3ZQiz+FjPqdj5pzNgcCxdjVGjFupY3nW0N
         V03jRPuJzs48kZCjFe5kcAjiq9CICIRlVhyCUoOZCYhqAbPyrrbrRBllxeNrINCQuSJP
         ZrjPia3dPs5lXvpFXRxOY2PSIr/c2zHRV/AISm0F4sEEGTochTsdavoZZfVU/ZQOoOc/
         TonjOw48KIyaBPKPdtedZqRwdN2SBVJmGGvjw8EtmVipODIajnav5HLk8ydWHlBKcYq7
         a+NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782692466; x=1783297266;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=neBR3VtamRz9x5zM02CGSvqqsQzuRKF0xxUw39lUWvM=;
        b=r0jqGaWD72o5xq3efS0t27K4N93ztQ7X7CxDc/kWgH+QtnztsENE4GUiPIfFXqaVmE
         j8aArdbSWHZbD+rOMlZxH0leSbJFWZCQBxWBOrC8fOg4DpljTQ2ChYESRVEN6b9yfRUY
         pAuQRwn/2SXW14gqKwPlM+mKLQuIn9YBXshLjVpNbziI+FwysLBmQ2EOjBanJIkgS3YL
         0vyfyBexb9RFQRubRrlN5ir/WtGIUs5Ws+3THKzhwbS94KkxwzaT07VuZR4ZMiJfKrwx
         jLcg8LwIGSlRCBaMX/B8O6oDvUMeIvLvtGwUywNLN45DnKLEjBgrYDyHP9vMqfU+ID6Z
         cGOQ==
X-Forwarded-Encrypted: i=1; AHgh+RoP0RRuG9qqka1CA8Fyk1Wv6hmXjWs6NsFV5gECE8cpWG5efRrBaCAw5mbeuqDD/UaAM+BOlXwS0g==@kvack.org
X-Gm-Message-State: AOJu0YyDQojfwgMW3cSPU2IvKAtmAsOVyg877J5CE6BxcGNj5yiKivs7
	DAFGeY8E7gXl57eU93LooPRMuZJnyP4tXRAx/JVVDdCUEsAyLu5puQd6t7TR8L16qVISdRbQal9
	Wt2O+htYLbUi0/iC2ghlD18DXZI7Be1s=
X-Gm-Gg: AfdE7ck9bpbUbL1FVZMYvV3cnV3CJcwyFcjG4vqi9DnPHAmYaWNI6SDmjSfUye5e8LF
	74hQ4wHLNRFVL1BcwNZvQy7zZw45J/dogywT2wXzeUOeQgHKlM/L0H5pLDmVLBoHrDDbLvWWPtO
	08LIY7538FeCNbBW11XSCEkVQ3Ky21bTQBFm2waF7sudEgWF5AFLxi6l6EN+hZWb5+dSWz1WKbz
	hKfgjKD5neqxnp79UxnKYloa51be8mDd8GyjogHa7+T1NLwguIie5EIwlYOnoOTPzVeYDhlbGyX
	pQca5tPt9OXdmQzEKjuz95qXfQ==
X-Received: by 2002:a05:6512:6407:b0:5ae:9c54:8037 with SMTP id
 2adb3069b0e04-5aea1f48d55mr3968120e87.17.1782692466242; Sun, 28 Jun 2026
 17:21:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260603-ch-swap-series-plus-folio-lru-cleanup-v4-0-ce0219e100d9@gmail.com>
 <20260628140322.c3ce1a7428d6c6d021069e7d@linux-foundation.org>
In-Reply-To: <20260628140322.c3ce1a7428d6c6d021069e7d@linux-foundation.org>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Mon, 29 Jun 2026 08:20:49 +0800
X-Gm-Features: AVVi8Cd4GbRDyyHZTqC0TU_IFKD2RqlTPO7y-VMam-g57uC7NkQtHOh0OQDnYh4
Message-ID: <CAJxJ_jhp4i+hVtdrmGHffn6XyYaS8-uwbFNYS-MMEZbwq3CXjA@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] mm: clean up folio LRU and swap declarations
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: te4ygkqupyur9xufy1hrm74nxe7hrkym
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 472E416000B
X-HE-Tag: 1782692468-30685
X-HE-Meta: U2FsdGVkX18OijZOnoyeW+F1WVWO4NbLnoirWdrTB7Dkz52R4uQ3mtdjvlTtbf7sn0hIYtFNFrBihmG/V6l+Q6O4ifWg12AUOFvU2+fG+5uo23aIdcAXH7vhpoW7Ow6lGyVwSf6tcytFfeEXuUz+HMvpSzTTB2SrhtUYSzNDTf7TFAWdqGmd+77g6Z6BaupGnHgkJcEjox7utVJrnnddgcmWu3JLtwS+fDuqvxdUxwXWUhYpoXHk5tEvAB1vYFibT/UAVzhERuXBpNGCj7aXHTB6JsEs0/xTEj5hpDfV1RDxX9fabN5cChVM6f9AzObva/f7oz8xKkr4WU6NfYuvAW68KdjaQvXszO6y9uut2rkt0o4qvRiu8bUyGaStQlGzYoEtBmpcuVrYndR3+jSmaus5Y5PjPoKwXprowsQ8T9QEkuKr+BK7nGiJA2FEL+4LUHMzKfKmdAGTyWQhlNe1Aa/gZVqfQFhhgk80qcH1FweI18tJ/RhW6gfJ/eOaVAIjpJav3ygKUCmSiX/p9EQnKQLWZlhqijiRJfr0q3M1SCkTJbCh0twAOHpuuX6DZwN28X5DkKRCpm/2F4fX0c30FSivaa7sA8ouzmgsSyZZQJv5FyoC4OHlbS+I0VkvNQuu3DQPhYb93HHBLrNTYFGTug6bmy5qrkP3/9jANj+guYKaOtncDoaQpki323VEWpvpmacrq3ZEg9hVXiGdVFRBv+dlJTiaB7fEOo0aT6kWF0EXxwAVcrjg96gWlo1YY6+LVVPiNHnF1Qjzh6Z1Ww5Lw4h9iCwzyDlzfB89SRgHj4k1baf3/ljMBXHP1YaQm2XYBMrZ0w+RG98IkBgJezev2nWQDeWyJ8KOFGV6umrOWuKxVwEiiMi7Na6dw8q2PTHybyTJkapO5PNhhtxcVWWmIgBxk5tSApGTJsK94q7RZVQW5u3hh0x8PqhVZuk7TFOqXV6HoQTV9PuNwDgL/Nl
 GiLJAFC6
 73fn+NSFXE0WJPYF3pbvpGBurYau1GEza/p4IovbIJDVOcgM83qjqFWT5Jz+5iMXg7Nlijhbmiqkw/HB/bl4fJLJEeJfXlGh7TPhziU18kZp3gLdeYvFhDXPP1w67P/fpZAzYt8H7Z+XamqcuTx08FZjs38PpQsIA/NhUHIcK3QgjVSkOMfFsLbgYn9QwHA7MgiqXbM/kx3PkuMw1avg/2Butl+/7ST9jW8YSBtQarXnf6bBf5zf//TY3I9qLKvqtri1bOoXqvzsbiYa8HRVvCX1BPyGEFCF6zV3mDsThu0u5JJayDV5dZuJHYdcGoP2uKcWv5QyvGUi3xcezooSO2WhjkblPtUYKPR08hrW71Sck04VAg0UPZDVOvT5J0Yf9fS/O18qFQ8kaF7QM4Y80ckg5YON/7SM1xMe5EaLcnYKyh8Op3taZOWtHGIURk+4jKNyYn2MPhQY8SlcvHUYHybY2yvS2dvuL1xGdALm4h9yxkx2F406b7g+BZ6qPute/nprq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 5:03=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Wed, 03 Jun 2026 21:05:31 +0800 Jianyue Wu <wujianyue000@gmail.com> wr=
ote:
>
> > The previous version moved the folio LRU helpers out of mm/swap.c in
> > one step. Based on review feedback from Johannes, Baoquan and Barry,
> > split the cleanup into smaller steps:
> >
> >   - move the page-cluster sysctl next to swap readahead in mm/swap_stat=
e.c
> >   - rename mm/swap.c to mm/folio_lru.c after the swap-specific bits mov=
e out
> >   - move MM-internal reclaim declarations out of include/linux/swap.h
> >
> > After this series, swap cache and swap-in readahead stay in mm/swap_sta=
te.c,
> > folio LRU helpers live in mm/folio_lru.c, and MM-internal reclaim/worki=
ngset
> > declarations move from include/linux/swap.h to mm/internal.h (public LR=
U
> > helpers used outside mm/ remain in swap.h).
> >
> > The first patch handles the swap-specific page-cluster state before the
> > file rename, so the rename commit only carries folio LRU code. The last
> > patch keeps the LRU helpers used outside mm/ in include/linux/swap.h an=
d
> > moves the internal reclaim/workingset declarations to mm/internal.h.
> >
> > This series is based on Christoph Hellwig's swap_ops series, which
> > moves swap I/O dispatch behind swap_ops and leaves mm/swap.c with less
> > swap-specific state. That makes the folio LRU cleanup more natural to
> > split out on top.
>
> Patchset looks good and is well-reviewed (thanks, all).
>
> But it's a little old and Sashiko was unable to apply it and I'm seeing
> at least one (probably trivial) reject.
>
> So please can you refresh, retest, gather the ack/review tags and
> resend?
>
> Thanks.

Hello Andrew,

Thanks indeed, I'll do it and resend:)

Best regards,
Jianyue

