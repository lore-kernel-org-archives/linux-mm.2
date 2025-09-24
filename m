Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13F10CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 16:53:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A9378E000A; Wed, 24 Sep 2025 12:53:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 580BA8E0001; Wed, 24 Sep 2025 12:53:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BD598E000A; Wed, 24 Sep 2025 12:53:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3D3A48E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:53:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CA13911B045
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:53:09 +0000 (UTC)
X-FDA: 83924738898.15.F5FC322
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1980D4000F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:53:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nyqFAsis;
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758732788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rAL5Cu+UfMQz37OQN1YYrMC/83wElraN+KKVT4FmBP0=;
	b=hF4WwEkDjRvObZJzgnCxUfpmJv5JZJ9+PvQeRagNYsgDgtUBIUgVctClTFz3OxNkKsVRMm
	HoxOdEoKH21A+s3l/3h1f0DkUCJJUnUk7hlQKau78n+rMUIBqLjqqxb9KaJ3RDiEknoSUc
	Q2U0r3/6Q0TgCUIJ+bIgTt1twBe0D5g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758732788; a=rsa-sha256;
	cv=none;
	b=bmw4W4xYblIqGnsKNpWtUTV+jS4SUtpdnyfeM4tfqpWBY2DYxWj7x/pSq2rn5LqSIlYY79
	Z75XiaOpwXHQrw9nWWN/DRVay988w9HdoOVnDPAwaMqssgVFOQqlWQ1IY8tn12sVnEUvm1
	gLebRxzo1/aJlKS5gQX4tvADZURtjy8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nyqFAsis;
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4b78657a35aso697601cf.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758732787; x=1759337587; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rAL5Cu+UfMQz37OQN1YYrMC/83wElraN+KKVT4FmBP0=;
        b=nyqFAsisTpPlKPow4s2pK9kitMCHXstrFkNEOw8UTUC/bOwLOi8krnoDlwejJ7deyK
         qK7ZhwLzjZ/0p+s0co/JnXPsGLByyktWG81z7MeDKqz0yTW7wTb/y/yoKzgulYK/0O8H
         1ZZIMDfRs+VB7jCvVwVDE8FS77112vF6HjnUxt4sikjxaf10ozx89/+Yyxv8XXWwxj73
         L9yPOhJjNmRzcKRUrA2OTZt5Rva1RlodgqJ40naC1DaGudt77lTAxzlsrSRWoEiZ7xmD
         e7mi1L0KOXCoNToO6lXB1z7bHaIdwiwWL5Hd/p9gRikYNXgmYq04+9GutGFgQbyKl/CL
         Bwhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758732787; x=1759337587;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rAL5Cu+UfMQz37OQN1YYrMC/83wElraN+KKVT4FmBP0=;
        b=ZqUwifxgeTaaqsr3ge7t9cLj0lcT4xESm+vRsKxtmrgi8MX3RzDoY0Wm7OHwGE8n4S
         CPGd0n1lND6U2YDh83HrZNxomPlI3Wo0UGEghvZ4obbAJy8rSD419zXkojnio4LD9HX5
         jD10gPDH6n6zxeZ/RwUIKQoLOWpxTUX/uO2QKXHHJcptfl/79zmfvtUDxsOnjDejjtlA
         QurKp/v1vFV8EhTawMnN3b2Q+tpkIEpg/o28timOmfIU+0PYXVG9v/rwV7w3MvIN5iYq
         +pEVX8kn0ZeTgm+IKjVuaiqhdXf2JKf88XZ41b4uAj7bd7JrcNxklr0TEOlycaky6Eah
         Fqjg==
X-Forwarded-Encrypted: i=1; AJvYcCVyYph+YtVilKlRMagdipvv/ATIl5ZRJ8O0+xYKvwdOYDwTo8LHkqS/9czU5jnFFC0vJ2eLyYbvCw==@kvack.org
X-Gm-Message-State: AOJu0YxCjgM3kf/w5TNOI5eH/8/JUR2b/go6sh9CRrzeOdk1LFx4tDHZ
	Ity5u5Ncg6UCOFtH4HcoP6xt/WSt9gPTndNC0AwHe0peIfWKSvjFoi1b7bHB5BmNl5qOOM7WBAf
	LI48094L6ijU7aVDTYbwXlOX1pcHO5yymYsDXo9Iv
X-Gm-Gg: ASbGnctqn3HEs4GOaggONjKp65de7iw6sO0DWoUi+UgIuT/lhOYdOfMmeSBFG7tJ0/g
	HcYDF/0sqlaMGuZ0PR6vDEsCvzJmReARxDWb/SMOyYA6fxAbWuOoK3L6sd0rCskwu+03u9SGPpE
	1XWVCyeqqncOS/2c/3hXD52GfJbx4q9aPh7ICgIgJILakdbWB6td7ERnvIxNKBfD6r7Naz3qSth
	Rnz+n30rrGilOtyoOEKI1BJNcV/SmnaZgGRGykM7iynq9RwLUR0
X-Google-Smtp-Source: AGHT+IFM4bC1CM0lReVKUj4FdqmsLyiIGG5AgB26WGF7py0Fxnl1epvOibVW8GFjcF4KFlPv5Uc4yba9NX1j26NP/mY=
X-Received: by 2002:a05:622a:1819:b0:4b3:8ee:521b with SMTP id
 d75a77b69052e-4da23acea56mr1381191cf.0.1758732786627; Wed, 24 Sep 2025
 09:53:06 -0700 (PDT)
MIME-Version: 1.0
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz> <20250910-slub-percpu-caches-v8-2-ca3099d8352c@suse.cz>
In-Reply-To: <20250910-slub-percpu-caches-v8-2-ca3099d8352c@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 24 Sep 2025 09:52:55 -0700
X-Gm-Features: AS18NWAeKekoZw_EZc6GYInUxqn2E30S29JpUuV_6-vLoJBFCrPesQlPq9v554g
Message-ID: <CAJuCfpHzNyQw6N5CjfNXsMLyUQem2noSm+_A3O2gm+skA7qDsA@mail.gmail.com>
Subject: Re: [PATCH v8 02/23] slab: simplify init_kmem_cache_nodes() error handling
To: Vlastimil Babka <vbabka@suse.cz>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
	maple-tree@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1980D4000F
X-Stat-Signature: 5giebi63qjiwaextdph4goqiu9d1b61c
X-Rspam-User: 
X-HE-Tag: 1758732787-370308
X-HE-Meta: U2FsdGVkX18yUPIVXZxYltnTzCbPkBuf9KD2sAorJ7xMMQSa9/67wajPsYAryNZUy278rIPMsWZgW4AryrYD8buavcSnAuQNTTewa6iauWCL0ZvP0PXxeFRU4BjGZuxq+eit/pnuzfSRbqQbSi/sBjbhUxYsAbukBWF8RMZHchGJFWMadx2vJNgIRXW716sys2NlPzSE65aHVTgLepz2Fs+UR9eaXdIMebopwOZnZvFWhv3bYNOb0aN0bYt28yUAzjIn273PTTUd1zZKZgG67DKo8mIlqtweY1DYdlosenKgWmo1xHivxgytCxY4ypYbfCQXPhnSj++/2p6usYDUZpB6PRoTvbuxDRsT6gEL8oYqU+4KnThBXj+5k+6YMjcJOEy0N/ejrc/mfw6J87H2x3r39X9h37AaiqnfMxwr+eLKzm5dvaG0kGN7PBwWb+NjmgytpZOwWxJi44KVeqFwPPr6V38gwTDIUWnz/JLcav34Cb9PJJnI6Vo9mMPwxm5UhjuNClpmzuKjoBBA7SUaRUGc7hqeEjdxpYWh3EmdZcBniz6T9i00qGbbpZA8H9Cgcld/e3t+9UOrDLDa8QFaZohJsVrd5px9p0B2uxWl988hZx4xcRLNRDBTTeIP798DLuVlqUOjYWH4Fms62aRINWaQ08qxqQFeQKNqgC6von3WLDYPBUEWgKHjNMVYDCtVEYq8qTsT81ldFm7wf/ty9vO1OmPsJhAMdE2eSLHrbdhQuqyqVnFg8iOwfLC2mXzC2jyAXfb/HZWk7uCpsgEspOPjlb3K2Z6dfDSR3Wz960XOvEfo7s4o91x2XeUZEQ2ALDM2vhS92dPukjiRf8hUOkf7cjlIYzZsbzS1lZNpDdksYZapBGC1gcy+RTCNVM1Xg52xk1TYu2frJnIe2LV5PBh/kU5I5I3+YQE+wF3jJtAK4KmorBGXncGBad1muwJBshmc6PY+LYI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 1:01=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> We don't need to call free_kmem_cache_nodes() immediately when failing
> to allocate a kmem_cache_node, because when we return 0,
> do_kmem_cache_create() calls __kmem_cache_release() which also performs
> free_kmem_cache_nodes().
>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/slub.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 30003763d224c2704a4b93082b8b47af12dcffc5..9f671ec76131c4b0b28d5d568=
aa45842b5efb6d4 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5669,10 +5669,8 @@ static int init_kmem_cache_nodes(struct kmem_cache=
 *s)
>                 n =3D kmem_cache_alloc_node(kmem_cache_node,
>                                                 GFP_KERNEL, node);
>
> -               if (!n) {
> -                       free_kmem_cache_nodes(s);
> +               if (!n)
>                         return 0;
> -               }
>
>                 init_kmem_cache_node(n);
>                 s->node[node] =3D n;
>
> --
> 2.51.0
>

