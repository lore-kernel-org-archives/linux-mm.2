Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A412BC44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 15:20:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 623856B0088; Mon, 20 Jul 2026 11:19:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FB296B008A; Mon, 20 Jul 2026 11:19:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EAE46B008C; Mon, 20 Jul 2026 11:19:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1D6D86B0088
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:19:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AF2AA1C011F
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:19:58 +0000 (UTC)
X-FDA: 85009515276.24.359B67E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3A64B1C000D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:19:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Em1b5/h8";
	spf=pass (imf20.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784560796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MJBxnIHKok6+v4NSROeyqP/dve9nYPcXS/Eilx2aqxg=;
	b=Akn3BInksKp4NLLIvcWzN3p7ALspIvgPltvU3BGHUPlCPZunPom0S84ur/IGxs9eQGMegC
	TRBZrOaT1t9Qk/D/MdkVWOn0IbAPX3gXJ79Gl1W1l27v97P3CcASp+u1qD829W1r2DKOGM
	1iA4hcfv/nm9uIiS/U4XP3hFCBeO8Hs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784560796;
	b=moRYcy+1DEn2lu1PSVholK/9SRib5nZALADvqThKMdjXCU02ojVtuhJOZYaJxkg/aC5xvU
	F9+0MP/DpeiYWZu/iHCsz5NtFqDdqInQ8jFrU6MX/H2nFIQIf8cqrCYBbRRDQFKBxjM5my
	gliSocUjwcyz4/Tls01C7L8sbKehEvI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Em1b5/h8";
	spf=pass (imf20.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784560795;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MJBxnIHKok6+v4NSROeyqP/dve9nYPcXS/Eilx2aqxg=;
	b=Em1b5/h8T8f6OrzV0SgBl5L8GE32QESODFd4+uruUpjAHBHAkx/VX8DHbZmIA7LSUvG0YJ
	x0UF70qZaI0o6ezaTNXkg94tFP4u1zhgoJcFRE7vX816HcDTupgkcLSLciqFlew40KploT
	8D3QwUOGVz/rsjafrQNdzu1PrP6ijo4=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-216-ykLevozYPXKTltd_2PUALw-1; Mon, 20 Jul 2026 11:19:48 -0400
X-MC-Unique: ykLevozYPXKTltd_2PUALw-1
X-Mimecast-MFC-AGG-ID: ykLevozYPXKTltd_2PUALw_1784560787
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-39c84c18406so29162071fa.1
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:19:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784560787; x=1785165587;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MJBxnIHKok6+v4NSROeyqP/dve9nYPcXS/Eilx2aqxg=;
        b=bsYckdp8wADinpu4BoZo27VbOvCcCUoZFabkJMREzwpnXUNxO1EyIv/7ZgREbKNRyT
         Xz5hXVzP+WDP1fOP8Mt9xEY+VqvMn6sV8CQ1JaZ5BvDz5a+eZiIpKAjAKsr3CgTHCNu4
         4pBrxuWePM4dpjfVkik99glP4HGXBi9mIuFct6RaASTpm1+qJ4a+xdRrpE+kZ2L9IcH3
         E1W4s2KVYhpXeIrS6BoVylFwakzC175EFiuq2fYB7mN8uU3W+xpr4ImD4+UUf+HcKLF1
         qeCjZMKlHhhEXyVF0wsncjtKoeYiO++4XsTo8FL1Mjac1LQY3dyu+DjQpiNZuP9N8kUc
         8LBw==
X-Forwarded-Encrypted: i=1; AHgh+Rr4SCMf4zMJPVGAe8qracbRiKPGm+U+pDfdkWkbF4eXnQSfJKqxTUBXJs1CkSfdPdWxKaOVd3aTlg==@kvack.org
X-Gm-Message-State: AOJu0YyDD6EffLOTPG9D/5rTOQ8MAbrdcYIiHKDci7yq8SLzQTp0QiD3
	4GlNDwUWfhPizKqJYvD4gEiI/Tu6vos1vrFobKRMHIHdOM7BE+DdGgpR/v+nL2bb0dnQbygKVmB
	Jdjno9JSoMfP54M7dcnF6LGddXPna1jeu0EoicaG624ppL7eXk4GLJeYzb85xm6Aakoc5LY/f47
	+/tPvnJGa6VlABn/0CKimjEBfkcZ0=
X-Gm-Gg: AfdE7cnGyC9L9/RCgznGsgKkcEllgowP2crfIxmOBZvese0kisXIW3wWtH0sIWkDXVm
	f3ijDe1mZ4ETvmZbTLzClMY0lm+8VpQJChXgiXDvJbroizsOQkB3T3uiunni9mF0Oy/NJDjMVFF
	AuNsFRJKobCF7EH6C+XkYyj8C/+wSl/5VDKC3FIy68dLOfpYwgWWtDPQ==
X-Received: by 2002:a2e:a593:0:b0:39b:14ba:a5cc with SMTP id 38308e7fff4ca-39eb294c024mr24426941fa.41.1784560786876;
        Mon, 20 Jul 2026 08:19:46 -0700 (PDT)
X-Received: by 2002:a2e:a593:0:b0:39b:14ba:a5cc with SMTP id
 38308e7fff4ca-39eb294c024mr24426781fa.41.1784560786195; Mon, 20 Jul 2026
 08:19:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260720142913.846902-1-pfalcato@suse.de>
In-Reply-To: <20260720142913.846902-1-pfalcato@suse.de>
From: Nico Pache <npache@redhat.com>
Date: Mon, 20 Jul 2026 09:21:11 -0600
X-Gm-Features: AUfX_mwij4qnWc3sejtxW5RwF5X0vNYb35jGeb18DQDmcyYz4P_vaebLNg1roHk
Message-ID: <CAA1CXcAk1SYopaokUGbT7RK9+gPNN2Jkm2UrpMaZWShjG3-z8g@mail.gmail.com>
Subject: Re: [PATCH 0/8] mm/khugepaged: collapse_file() cleanups
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: u8OuMCaGZvNJQON3fpHzP0SBbaNfnNQB8Ok9cWT_K6A_1784560787
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ch8zj7ubnzacs195dtswj1wkh3mh1bkt
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3A64B1C000D
X-HE-Tag: 1784560796-750204
X-HE-Meta: U2FsdGVkX19WOyQ1PFvJ38D3zPEKo0xfUGNcgGeiqwz+TYXVnsgvmlBu1qtbSHWB2jnO7O9t0IY4kLwl1PFvpQaXkAC2JY7apTMe0TsYBKUYf1Sz3VHGNJhn5lxeieanQjcOg7s/EJeJULfqvG/HfSmT+SSTuhVhkLQmERfROULiTejcrXOlNQRweFpw1R0QC+J0yqk1vGDi6s0tRdDgde5SNjDvSvmbSHSnnjppK/ncViFBSCebE4+dL7LA9et6UEncKasX50kmlA/BlMJz+GPqixVa3h9/00QfI/VO2d+YupiHeuHCbUif818Vnes6/05blldhHKMNk34VxM6OlgT5U0azazFC0mr9PZUydrSqqwR1be1EEtX6U0Vle4HlIKmP3v8HsycLCqELK7qPIW552a+Kezv0Kj2QDJC4IFsMOnmWgEDf8x40SQvgOI1NDfViv/luRL5TsLQ7fmaZ0RjNQlMRXWNcS9RoKivSgV6yvr5T39z7XURMJnRht/G85bylh9CxdZ1lmHLwnokrAGxVsX0LOiSKpDyl8dvltEBfHboD+/FvVFOWbHdMajoj0MGrFYk9Q8akSYPphilSbw7nyv95AkgkI0wSMFKafLEDifuf/qUziOuOEhHcCEBpJfZnzkKs+HUiTbKvMSD8uwxCQJlrqWcOykqP0ulcMhqD2LbB6v4r4OxMWbeCOAdzHXSpEiRIEJQsaQO07Kh2Vc23HDQhLgb0Vc5FW5RCNFQPP/rclHp2vN9/HlrPK+uy2TBQFF1hIQqrkRscwjjuowHu8CbFHJKS2MI281++4UQKHVa8XaU2GuewoQE7N5j7iaS9QWWm7qR38B4X2KkQqQKmkXJfo+cKFiqCAgiAxpkvZDtRVt9iFd8pmMziA/FB01dd9Ln3z8yanybj/bh2HS/80ovUSkVCB5nJ+IkSV8fVHqPaiJjl6+VJ5x4FgdZEUslFYqlF/j1d1szCgap
 1s+6hJyP
 OZbcWAldg98+Cyu95YyXgZsMHgTJLfj22qe3Tx39abOP95Jdmzbmi3K8AGLneUiiGfmZebfz7fpwVb2L4qAk0OdKbD/XFFBg24BNVc/jXqg4KtAwjqUE6tdoem9eO5ZwIa2TsJPpV+5RSAHH4ZA1NdHoVJskZH+EeeTT47u3bzkjHODZc1rXfLp5lify18YFfrsJF8TeGG01MtA/qdy/wKurpcp+xjW61CGyAuDcRxcKKTwozwo0/W4WpEwBM2fLIdoZcbiScA9JBWz5nuTfKb/RpmU26tppTmexmNvTKuUUyeM5hcUxRo35naWORbNwRrO/RE5atFxnrGf42G6+Z4a3wOzKJgw5ndLmhkyOdNz8Tr48EYnLD3CutmKxT8YLHak7nGU+tExERRoDzQydnfjA+vCxs2eiC0Y0pSv9LcnK62ixh+of32V6Z9DlLHIaY56qFkLapb/NISeG9TlOCxBfoQ0DgHxm90Myrcdbgo9fXr4kYMrbBKzJYnUoel75X4ShiarD8V5ad8r0hD0xBiSE1IuYyNYUhcv+azp45mK0xsTE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 8:33=E2=80=AFAM Pedro Falcato <pfalcato@suse.de> wr=
ote:
>
> Here are a bunch of cleanups for collapse_file() that attempt to aid
> code readability and understanding. This is part 1 out of N, and only
> attempts to address the main collapse loop. The exit path is still a
> mess but I figure it's much easier to review if I send this batch as-is,
> versus sending the whole thing.

Hi Pedro,

I have already prepped a cleanup series for collapse_file().

I was waiting for my work here
https://lore.kernel.org/lkml/20260715025941.1571316-1-npache@redhat.com/
to be reviewed (and in mm-unstable) before sending it out.

Our series have several similarities; for reference, here is my version.
https://gitlab.com/npache/linux/-/commits/khugepaged_file_refactor?ref_type=
=3Dheads

Cheers,
-- Nico

>
> Based on top of latest mm-unstable.
>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <liam@infradead.org>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Usama Arif <usama.arif@linux.dev>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Pedro Falcato (8):
>   mm/khugepaged: separate out windy folio logic from collapse_file
>   mm/khugepaged: factor out page cache folio reading
>   mm/khugepaged: factor out and simplify dirty/writeback handling
>   mm/khugepaged: simplify prepare folio locking and exit paths
>   mm/khugepaged: add kerneldoc to prepare_collapse_file_folio()
>   mm/khugepaged: hoist isolation into collapse_isolate_folio()
>   mm/khugepaged: hoist more code into collapse_isolate_folio()
>   mm/khugepaged: fix and flesh out try_to_unmap_flush() comment
>
>  mm/khugepaged.c | 424 ++++++++++++++++++++++++++++--------------------
>  1 file changed, 248 insertions(+), 176 deletions(-)
>
> --
> 2.55.0
>


