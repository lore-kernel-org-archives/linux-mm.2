Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DE6FCED620
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 14:12:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5287D6B008A; Tue, 18 Nov 2025 09:12:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 500086B008C; Tue, 18 Nov 2025 09:12:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43CED6B00A3; Tue, 18 Nov 2025 09:12:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 307F76B008A
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:12:23 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CC7EFC0572
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 14:12:22 +0000 (UTC)
X-FDA: 84123917724.23.B30D684
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4A24940002
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 14:12:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Du7LtnY9;
	spf=pass (imf12.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763475141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=YJCbMXrFxc4lBmLKP9PfJMMIBxBx2LBYdV5jtGktq70=;
	b=SMhS1B+irLP8+QPa98qMMePFs9aZyu4pF6muPz74NMI4Yrv0OnY+2EP4MLJr0uCNtIj/Vx
	vpkUZulV6XodHNyQNLRIr488C4ZPvs3wsSBikeyB5N9CX9XMzp9qaHTUksx8UY9Vw8fQi6
	eiKOnyPRuU/D7caTgNIJlMx6NXP3veE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Du7LtnY9;
	spf=pass (imf12.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763475141; a=rsa-sha256;
	cv=none;
	b=jMqTg+qDfEIiTdlTYlLEVXT23uM1+WUzc7MruIY5RNesty1fzwP4hhLPTnMNMjAf9qHDCi
	CfIwk6clxtTus5wscB1uegXOavrpigd1F6t6QBNI/eflcpBlu+v/0eUAbs+z5OuIADrruc
	Z13dWEwgoMkuTq5mqErc6zjfodqf5pE=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-34372216275so6027209a91.2
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:12:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763475140; x=1764079940; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YJCbMXrFxc4lBmLKP9PfJMMIBxBx2LBYdV5jtGktq70=;
        b=Du7LtnY9KrCDjhf9Q/99pUGDoFDlsSULWTJuhTAhE94kV6CSv+wIgH2dA40HcUCPqk
         xlUxdNRruKvaTYpAPRBD4YP1BDHUb/Ldjs1hVZgiLY5ndsX5Yw4GdLXCPdYAtYKhsTcB
         562Iv7N283+gcZ0Eric8VQ6cfmGGu8o4gxpWrosWgyG1kopn8q8CcRcsKuQCRzo4YOcu
         Kl43X2EYfbAwDtwAAXdutqaR3TmJreSQQuAKAmPIjzDU5Ptl5ZSzR5bJfaa89Tv/H0SD
         R6aHewp0nexSQyAVQZ7wFPNQC9MfM7uE0eTQcuH3xOPiNpzTwy691d5yOqJkI0k3jP9E
         GRUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763475140; x=1764079940;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YJCbMXrFxc4lBmLKP9PfJMMIBxBx2LBYdV5jtGktq70=;
        b=MUNBostqh6wEzb52qdI6EUxlS3xPW7vvjnCYuyIGYF0oS3mUsD2vwZAI+Eb3FDyfEw
         82nptdhN16xd7jAREAlVU2MPN2iYMrkl8wAbc0IVGBZYuq9wMSMZJYmnIHnFCN5BjsFV
         CNu42AOrPtH4x9oOxgvZLrNTU6pnNIYrnLa3Ecm49BsK2K9Ly9wDSpZQS3bLrzHI+u4T
         pl2YfK6cuXCQrTSTiuW6dqvTZuaXTLP4CZg5f91r+aV6T7AUQYWczTEaMq59SzAxvg0P
         5dAFUTjCS8FNJSJtKyb0PZ3QOLW22N035uj9yceyu5WIVSzrk7wUxvBfjaGIPxYaA+Sd
         MaEQ==
X-Gm-Message-State: AOJu0YyfVih6HPLPSfrgM/LhFOmWSjeXkcW8hAzVoqMsuz7CV5ikrIsX
	7BL0eFjHoq1lq/FKrH1CgvwYX0+t+8BiQgjXGs4cL5k9kEeMh++mQkku
X-Gm-Gg: ASbGnct7nLsehotnj9SVvg+6EAkh2VEuv9zLK897kycJnormoq+Lm7zV/e7yDcVmnRh
	Y6u+0zfBq4VyiaMqqlxviXEeNvKVX7rAXJ9Fyf7gaxiPgYA/xo3uClgurVi3DtYaBRv5bkqfaPt
	udydB5kG9jYSXvo4/o+ImcpI136YMR+EY35kqtaofj7YiaLmVfh37M3QwvarA/AV53aabizzcLZ
	25EV15+6oZDATIDjqRwGBySPu+Pc/Ojo+INHIUHWob244iD91lKagqTfN38+jo8ndTY1h6aUsCx
	WiyA9Too6Dl4PHmEctVKYvEJI16wxki5XoDAODt/DnAp4RNM540D9Gby1d6pLSczND/gds+0Cll
	g3T/CI9OjrokpELlbmw+GU18WAYFXs7FVVC/RhiPtsyus+bm5c5kxd/zi/0gjl74QNneGBB/l9S
	7YjpGeCA==
X-Google-Smtp-Source: AGHT+IF1qIVKiE8DwAos/+cPYxxS2D1JpAkt4IZSDQhzjgwOLH+AWMhFOTG9x0eI/Lnzwx1Y2YGH7Q==
X-Received: by 2002:a17:90b:4e8f:b0:32e:3c57:8a9e with SMTP id 98e67ed59e1d1-343fa76c377mr19701586a91.35.1763475139949;
        Tue, 18 Nov 2025 06:12:19 -0800 (PST)
Received: from dw-tp ([49.207.232.208])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b92772e713sm16374708b3a.54.2025.11.18.06.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 06:12:19 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, "David Hildenbrand (Red Hat)" <david@kernel.org>, Christophe Leroy <christophe.leroy@csgroup.eu>, Sourabh Jain <sourabhjain@linux.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, Donet Tom <donettom@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Nathan Chancellor <nathan@kernel.org>
Subject: Re: [PATCH v2] mm: fix MAX_FOLIO_ORDER on powerpc configs with hugetlb
In-Reply-To: <20251114214920.2550676-1-david@kernel.org>
Date: Tue, 18 Nov 2025 19:19:01 +0530
Message-ID: <87a50j30z6.ritesh.list@gmail.com>
References: <20251114214920.2550676-1-david@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4A24940002
X-Stat-Signature: rcmos8tea4ci7bmfakem1n5o4984kiep
X-Rspam-User: 
X-HE-Tag: 1763475141-399353
X-HE-Meta: U2FsdGVkX18ywEZ7Pkh95/73QtNUHGjdwt7ZW/aNSUScWHSYM8L9ItPDS2C8nwj3HpVnXYHg6oBuXSa3XDrziNy0DM7pwn7cb/IYt20yOY4Sbl9x2ku311qukkAqaxeGdX3wavzB9U856d5Q7X8k7FDv8Z+SB9BKtt7adTaY3y9VOM4m2gI0zU88rpRt6nQiNXb86R1D6FtbG8Gi1nw21hxYTCN7yYKA5s00+c+ry9GKJtV9tlBZx6CRFE+g9TwRvkFwSHnFzDCxBpq/VZKiwFFgORxkpJs9xAYME+cBHDi0vDVe7vOitDyQp6AKtnDwQW8Acku00YQSFT/ggXS8J4KfJRR8HcfXOT2YhjHTf9ls3Ks08+MXu/XywGc9dpsPvmoKUizeKOR8Wus9SdYnDYyo6we54/s3QfoeP0A2EAgAzmYTGDr03VpQUxmvz2Gm3r9pyZvd2I5Ts6jd8VzrsTT0/+M++mGMiqu2dn7laiz1glpXvPTMSsTmjiriYHNSRqExPqHMz05mnXH+GxBXkhQ8/O/DRAwrhdEH11ZwbmF8kLVs2HM1XS1xZh2Gg+MUTCCRI7ChnuzbY9f9Jzd/nitiv0Gxk3AviGYB3YrQBLU9/X9BrrPfsPSvlk+NhoRU8x5eUFskwsGfjIJFH7Fh/fOzDusyj8WQ/WhrCFonOgsxIXWbkF8/KOTWsgyNIJJjn0LF9zzh6+6MCbelMW86hH+U4mkrR4NmYWtYU/9EOrp2iw8fnen3xHooxNaPSznoX9Y2VgKzCVgu6BsNkA4hqLQ/1NlG45BeqbMMjHGXeLsc3m+PokTdL5JRnkA/Q6D9JZrHhSFfPdZlmMekNRGTvLiWkmftFVOz1NzfgfMTQn/Ve4knhzddOEBwPxHALKLyfAipRNBNuHO5pYhPejF2F3fomzuadhlH5qsOjkeqcN8OyvVxteFZHPoSQ6+QsO8UVwN0QNEjQcTXITuexFm
 N/fVBVYO
 sXEfH1oZ/roi1svrholcAPgfctrDxL/JJg+nUvX3x/w5h2XPNaTrGKo22rPTUXFftHqO7Oow3FjcysxVeabauqWZyio40ZIqaspTLdkc8BE/mfaIChZ2IqSPva6A2phmsZodJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Red Hat)" <david@kernel.org> writes:

> In the past, CONFIG_ARCH_HAS_GIGANTIC_PAGE indicated that we support
> runtime allocation of gigantic hugetlb folios. In the meantime it evolved
> into a generic way for the architecture to state that it supports
> gigantic hugetlb folios.
>
> In commit fae7d834c43c ("mm: add __dump_folio()") we started using
> CONFIG_ARCH_HAS_GIGANTIC_PAGE to decide MAX_FOLIO_ORDER: whether we could
> have folios larger than what the buddy can handle. In the context of
> that commit, we started using MAX_FOLIO_ORDER to detect page corruptions
> when dumping tail pages of folios. Before that commit, we assumed that
> we cannot have folios larger than the highest buddy order, which was
> obviously wrong.
>
> In commit 7b4f21f5e038 ("mm/hugetlb: check for unreasonable folio sizes
> when registering hstate"), we used MAX_FOLIO_ORDER to detect
> inconsistencies, and in fact, we found some now.
>
> Powerpc allows for configs that can allocate gigantic folio during boot
> (not at runtime), that do not set CONFIG_ARCH_HAS_GIGANTIC_PAGE and can
> exceed PUD_ORDER.
>
> To fix it, let's make powerpc select CONFIG_ARCH_HAS_GIGANTIC_PAGE with
> hugetlb on powerpc, and increase the maximum folio size with hugetlb to 16
> GiB on 64bit (possible on arm64 and powerpc) and 1 GiB on 32 bit (powerpc).
> Note that on some powerpc configurations, whether we actually have gigantic
> pages depends on the setting of CONFIG_ARCH_FORCE_MAX_ORDER, but there is
> nothing really problematic about setting it unconditionally: we just try to
> keep the value small so we can better detect problems in __dump_folio()
> and inconsistencies around the expected largest folio in the system.
>
> Ideally, we'd have a better way to obtain the maximum hugetlb folio size
> and detect ourselves whether we really end up with gigantic folios. Let's
> defer bigger changes and fix the warnings first.
>
> While at it, handle gigantic DAX folios more clearly: DAX can only
> end up creating gigantic folios with HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD.
>
> Add a new Kconfig option HAVE_GIGANTIC_FOLIOS to make both cases
> clearer. In particular, worry about ARCH_HAS_GIGANTIC_PAGE only with
> HUGETLB_PAGE.
>
> Note: with enabling CONFIG_ARCH_HAS_GIGANTIC_PAGE on powerpc, we will now
> also allow for runtime allocations of folios in some more powerpc configs.

So, book3s64 anyways always default to Radix which by default always select
CONFIG_ARCH_HAS_GIGANTIC_PAGE. So even if during runtime Hash mmu gets
selected, we anyways by default had this config enabled on book3s64.

> I don't think this is a problem, but if it is we could handle it through
> __HAVE_ARCH_GIGANTIC_PAGE_RUNTIME_SUPPORTED.

Exactly, I see we already have the above config knob at most places where
this could be needed to prevent runtime gigantic pages.

>
> While __dump_page()/__dump_folio was also problematic (not handling dumping
> of tail pages of such gigantic folios correctly), it doesn't seem
> critical enough to mark it as a fix.
>
> Fixes: 7b4f21f5e038 ("mm/hugetlb: check for unreasonable folio sizes when registering hstate")
> Reported-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> Closes: https://lore.kernel.org/r/3e043453-3f27-48ad-b987-cc39f523060a@csgroup.eu/
> Reported-by: Sourabh Jain <sourabhjain@linux.ibm.com>
> Closes: https://lore.kernel.org/r/94377f5c-d4f0-4c0f-b0f6-5bf1cd7305b1@linux.ibm.com/
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> Cc: Donet Tom <donettom@linux.ibm.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
> ---
>
> v1 -> v2:

Sorry, this got delayed a bit as I wanted to run mm selftests and then
update.

As I had updated in previous version, this patch also fixes the warning
during boot when RADIX MMU config is kept disabled at build time (that
means only Hash is selected) on book3s64.

No new tests failures were reported on running mm selftests with Hash
mmu on book3s64. Also verified boot tests on few other ppc configs.

So even though I know this patch is already taken in rc6, but still -

Reviewed-and-tested-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

Thanks again for providing a quick fix!

-ritesh

