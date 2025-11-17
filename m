Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A02FDCEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 17:25:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1E3D8E0020; Mon, 17 Nov 2025 12:25:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECE818E0002; Mon, 17 Nov 2025 12:25:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBD878E0020; Mon, 17 Nov 2025 12:25:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C67D18E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 12:25:41 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 974351A0221
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:25:41 +0000 (UTC)
X-FDA: 84120776082.03.58B6C47
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3E1761C000C
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:25:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g7wpTxa+;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763400339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1hC5kH3c4Oy67S32KC16UN22dR9vlJmP74/QjELNj24=;
	b=3cFpO1pIhUc1Ns7YOPOe9aH9sUFktKGVjYyxqAoCpM3YvUA4tAPZVdpvy+0n+20BcDjh3j
	runx2VfEA/+ozzXGoyk1TJ6BiRIUAWGP/9aD/pptdgTQ4jl7ndsODmqDupz58m/J0f7He6
	EK4Ty6U+S0o+DhnRhFttWrW9+7u4qmw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763400339; a=rsa-sha256;
	cv=none;
	b=3u4pv4g5pffZYx4BFaJaC6+3ehgsNUru7qpEpRhbF8s1w17LBO2OiKhEdORWBfIayJCb+k
	iUzhdCRMckU//yZ3kM+cH22XiRD+Fd6ZB/QN03K+UFX1Ja4I7gM9NBDNqnJpXega/rNEih
	ufA1h2ljA3kKCOqzxO8vMBnd8zUkkUI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g7wpTxa+;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763400338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1hC5kH3c4Oy67S32KC16UN22dR9vlJmP74/QjELNj24=;
	b=g7wpTxa+IU7zY1fzIJHeAtXA4rk0KOL9iaA4GPPfKxv8v1AfmMQVNIAnsLKGyvNXqgp2SL
	zP95YHwGls91Fe591Yqzd9LJULUlMMm8F3u3DoVW8mY1TBS+vVLc9n1iFAHayIpKgnsMHg
	0OpHQ5S7PCKBcyC3HZqd44EG595MYGc=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-413-gezbwy5vPv2U9XUHv6uZnQ-1; Mon, 17 Nov 2025 12:25:37 -0500
X-MC-Unique: gezbwy5vPv2U9XUHv6uZnQ-1
X-Mimecast-MFC-AGG-ID: gezbwy5vPv2U9XUHv6uZnQ_1763400337
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-640dd6e322cso7934842d50.3
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 09:25:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763400337; x=1764005137;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1hC5kH3c4Oy67S32KC16UN22dR9vlJmP74/QjELNj24=;
        b=fyRxPeaJBFIVdXt+0a75FomLvbyXpdxeRK3Ci+Bnhm9Qfr1y453WW/JWFQ4hNQQPto
         y0buJuisUjBd5OxhUYTJTL3KnC6t5573a1OTjPbn9kg0qaKh/WdbFFT16jrHpssjyGH+
         4K+vFKKeAAq++uFXisjlTJiXGfdAzA2EV8lg+D81to4vxsHXfSvcJXNm5y9zGeUeK7vE
         GEVhWuoByc+K3Pc6pKvYxgPG66zFxui1xoKG/zwCvHCdTz6uY2INEVG//sYd1zc6UWL+
         fB0EAaehfY0OGvAesjmhpr5alIcG+zdcmD9ruVEswMH1RhtR2vCKa6IlrLJLXYgHtZuR
         fX2g==
X-Forwarded-Encrypted: i=1; AJvYcCV9WsTeLVVAR1ZeqG+TDMlguaILj8AXU3zR6YQ3mjSWN9Rq1SNqTkirtrpTVdMqq0nZQ2ylck2EKA==@kvack.org
X-Gm-Message-State: AOJu0YwhAJGahVqJ/alzA6lS1WUVaxDrC+AEK/0cvZIvkBUN+8LElmZk
	AHy1jkb3IyaOWX9+Jqt6O2sZaB5WkJTsLkTqCZWNiOMDS2AwNGFLNRs3Eo5orZ4pHylorUyhWJB
	u2Gu6/XqVzqkgVp3LRprHAGTVVd6UviEufN88tSHM+i8IBoWE4Fj1WLr6zWv2ID7Ica6bnMGae7
	Kkpe94WlzM/7rfldZqNgiXsFYqCZLK/a2by1k=
X-Gm-Gg: ASbGnctqo+QJ6Eje58KVfsl7/uV9v5wNZLxusUYKSaihBn7I1POlDfZ5w/HKFtC3tsj
	PzncUDzmKemLI7fDc5UvryNNX4XMViTWHzU4oqaWWWWtUMXXER9fJDYT9+AjODk/gGLMuivW3za
	sYGE3zJabbZgvAr7HjLI7EKv9uKJ4HgGIrVGfXJLs2EasNmqS/LoUbVRhfNx4lwvB1FgJHTA==
X-Received: by 2002:a05:690e:23d3:b0:63f:9928:3f85 with SMTP id 956f58d0204a3-641e768089bmr8017756d50.62.1763400336759;
        Mon, 17 Nov 2025 09:25:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFn+qE83StYW4JaJMR0MXslllTAnfCiyDusArx7oEF7GmzhthN3ihbIGihCkAU3r4eAoSONerMQNcc+AVltJ9A=
X-Received: by 2002:a05:690e:23d3:b0:63f:9928:3f85 with SMTP id
 956f58d0204a3-641e768089bmr8017740d50.62.1763400336313; Mon, 17 Nov 2025
 09:25:36 -0800 (PST)
MIME-Version: 1.0
References: <20251114030028.7035-1-richard.weiyang@gmail.com> <20251114030028.7035-4-richard.weiyang@gmail.com>
In-Reply-To: <20251114030028.7035-4-richard.weiyang@gmail.com>
From: Nico Pache <npache@redhat.com>
Date: Mon, 17 Nov 2025 10:25:10 -0700
X-Gm-Features: AWmQ_bkj1TqKLmWz3SiVPp5fVTGUs9i2vOmqLX3cLk6O9_rSyZPppgKRtfR9bBk
Message-ID: <CAA1CXcATqLCv8k0OEoEcYy-=e1NevsjoebnefFbV1=yB-gyygA@mail.gmail.com>
Subject: Re: [Patch v2 3/3] mm/khugepaged: unify SCAN_PMD_NONE and
 SCAN_PMD_NULL into SCAN_NO_PTE_TABLE
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, linux-mm@kvack.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aUDPgWA4h-4NMlgN2H5RnkBNbYOnp5Uqcaef9qUAaFA_1763400337
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: dq6eehwax67yem5segonpj4dqeu3njds
X-Rspam-User: 
X-Rspamd-Queue-Id: 3E1761C000C
X-Rspamd-Server: rspam10
X-HE-Tag: 1763400339-530881
X-HE-Meta: U2FsdGVkX18UvUYCHEL130zYsQ+bjdEXRUqTqawYEXWbU/62O2gcMFmJ9hJCWykkdt8+7M8CkzVFS73EqcgaUNQSUaPn9pnyHSi6qYRIhRBgsM/grFu9hOcZVbSa6OWUNiuKv4Y++QpNasXA5CV0QnMFLXJtRE8Qptpz4KxR9zAV2aVhCSl/GH8ky8iLmmZkueVYw4RG4kFMLTpTR7Hn/07VPBayTW5O+Yv1vOxBttW3Qrt8edlPux+1kbQmgl+VSwoWJVbv7AHzGc07op4cPX+WEQokoSdhfX+bkCqEH1LHTZVMSnz5awbjAXSQF2+hRVqUln+cPIjG+2dauzOMISxDCOC28V+vZTIlCibcul70AWCQIJJmJuafv5IMo7a73T2guA84C2MXUHVY6aLAg9oYbo3Pb3aey1bBTPRDqvz/i0LlEOajVEZVRDrjYIrM9sIQJQU2dmKGbwrqNRxvNVQ9jm9QetYCCzoAw4dIkByNrEuaHGmIRKSbdU6tr3w7TZnAaI1uXA307a7yBw1+1UToFrm3Gh6PWdN4NrFRlCq7WV2PplZ5OpSKvsV6H4rXUf/hrdWt4kgzt2vp91i98pl1E34/b94W9ukcWomNxdMty3n7yH4dNA5CxtbKypQRnBiSDys2G2LTzcnCdD4DeH3lvMP3aIFztt00DIcfItoDPNZly961ign9CVXTfmfFt86L87hHH6GpEZHklCUbB5MBdfsIOS84kVJFhblcMmIb4ygJU0W69i+IgOdIl1+oam7lbQ6xwQuMAYGq0Fh21tvoeZ7+jER/4J+lPWeY70xRTmClS1RUlJ0zFdYN5Pt5Ve46ZG6DW+dSvL9/JMXgUn8C7NR66Q0h+IxfeAlVhUj1TBTCZ+RfuSgHrSLP9iZSGY9yztlGK9rKXYs00+0LH7siWvyQ79l6xToPFltfs/5BIiOeyxb/onoepkF4TPzR7cJ5dduaTKm2mPf/KPv
 nRBcr3Np
 bVWLpgkxSx45Gohft0j2XCl4VxOz+Vc9vNOpEb5LbltYh59hOfTBUaIUnTYzEOIw3ElHIUzmH7gBNCBcli47QuCtxnFqVVNwEMJiRUlThdYEUxFYOjBuaUyoX7SElYDj5Xifo15diZ/Anc/L8hmnjUjD2tzGIDtmakaeKmXH0FvYdizQCzmHKkHiU3HQ9KjXimWs/JsGxXzKeE90rY6y59pGD4HEsI58idmI8xLMe3OCmdeDQm1/nB5vHyOYaZxXjpZKWAhBmP+o5sjBGdjE9bQ7L/19nPou2Ayh/bgefdOivKgdXI4Qn9S1SyLzkPWrYAEh2LXNeInzsBktoIdN+xh+RwMl75r7lkLVdhMtxNii5OukhIIjTyAQne4zL5U3hPeFTzEJzrDhJGQFjS2emq1WKlGz8AWhQ4N8coesVQ/lmEvtKW/eGUrZiKI72cI/0VnUNwgY6Y0bpqf6jzyB9onMzK/XgWhnfDoQi8+FsADtiXWDCfHhTMi7HW3gxviVzXhn9mY5sUxcFwqCyzrlx4WROGX0hy2N0T1tq5YAPTylq0y1MR4yKHcf7XOaESKBATxKm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 8:00=E2=80=AFPM Wei Yang <richard.weiyang@gmail.com=
> wrote:
>
> The current hugepage collapse scan results include two separate values,
> SCAN_PMD_NONE and SCAN_PMD_NULL, which are handled identically by
> the consuming code.
>
> To reduce confusion and improve long-term maintenance, this commit
> merges these two functionally equivalent states into a single, clearer
> identifier: SCAN_NO_PTE_TABLE

Nice cleanup!

Reviewed-by: Nico Pache <npache@redhat.com>

>
> Suggested-by: "David Hildenbrand (Red Hat)" <david@kernel.org>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> ---
>  include/trace/events/huge_memory.h |  3 +--
>  mm/khugepaged.c                    | 23 ++++++++++-------------
>  2 files changed, 11 insertions(+), 15 deletions(-)
>
> diff --git a/include/trace/events/huge_memory.h b/include/trace/events/hu=
ge_memory.h
> index dd94d14a2427..4cde53b45a85 100644
> --- a/include/trace/events/huge_memory.h
> +++ b/include/trace/events/huge_memory.h
> @@ -10,8 +10,7 @@
>  #define SCAN_STATUS                                                    \
>         EM( SCAN_FAIL,                  "failed")                       \
>         EM( SCAN_SUCCEED,               "succeeded")                    \
> -       EM( SCAN_PMD_NULL,              "pmd_null")                     \
> -       EM( SCAN_PMD_NONE,              "pmd_none")                     \
> +       EM( SCAN_NO_PTE_TABLE,          "no_pte_table")                 \
>         EM( SCAN_PMD_MAPPED,            "page_pmd_mapped")              \
>         EM( SCAN_EXCEED_NONE_PTE,       "exceed_none_pte")              \
>         EM( SCAN_EXCEED_SWAP_PTE,       "exceed_swap_pte")              \
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 2ee5048b764e..40f9d5939aa5 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -30,8 +30,7 @@
>  enum scan_result {
>         SCAN_FAIL,
>         SCAN_SUCCEED,
> -       SCAN_PMD_NULL,
> -       SCAN_PMD_NONE,
> +       SCAN_NO_PTE_TABLE,
>         SCAN_PMD_MAPPED,
>         SCAN_EXCEED_NONE_PTE,
>         SCAN_EXCEED_SWAP_PTE,
> @@ -934,7 +933,7 @@ static inline int check_pmd_state(pmd_t *pmd)
>         pmd_t pmde =3D pmdp_get_lockless(pmd);
>
>         if (pmd_none(pmde))
> -               return SCAN_PMD_NONE;
> +               return SCAN_NO_PTE_TABLE;
>
>         /*
>          * The folio may be under migration when khugepaged is trying to
> @@ -944,11 +943,11 @@ static inline int check_pmd_state(pmd_t *pmd)
>         if (pmd_is_migration_entry(pmde))
>                 return SCAN_PMD_MAPPED;
>         if (!pmd_present(pmde))
> -               return SCAN_PMD_NULL;
> +               return SCAN_NO_PTE_TABLE;
>         if (pmd_trans_huge(pmde))
>                 return SCAN_PMD_MAPPED;
>         if (pmd_bad(pmde))
> -               return SCAN_PMD_NULL;
> +               return SCAN_NO_PTE_TABLE;
>         return SCAN_SUCCEED;
>  }
>
> @@ -958,7 +957,7 @@ static int find_pmd_or_thp_or_none(struct mm_struct *=
mm,
>  {
>         *pmd =3D mm_find_pmd(mm, address);
>         if (!*pmd)
> -               return SCAN_PMD_NULL;
> +               return SCAN_NO_PTE_TABLE;
>
>         return check_pmd_state(*pmd);
>  }
> @@ -1013,7 +1012,7 @@ static int __collapse_huge_page_swapin(struct mm_st=
ruct *mm,
>                         pte =3D pte_offset_map_ro_nolock(mm, pmd, addr, &=
ptl);
>                         if (!pte) {
>                                 mmap_read_unlock(mm);
> -                               result =3D SCAN_PMD_NULL;
> +                               result =3D SCAN_NO_PTE_TABLE;
>                                 goto out;
>                         }
>                 }
> @@ -1187,7 +1186,7 @@ static int collapse_huge_page(struct mm_struct *mm,=
 unsigned long address,
>                                                       &compound_pagelist)=
;
>                 spin_unlock(pte_ptl);
>         } else {
> -               result =3D SCAN_PMD_NULL;
> +               result =3D SCAN_NO_PTE_TABLE;
>         }
>
>         if (unlikely(result !=3D SCAN_SUCCEED)) {
> @@ -1270,7 +1269,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct=
 *mm,
>         nodes_clear(cc->alloc_nmask);
>         pte =3D pte_offset_map_lock(mm, pmd, start_addr, &ptl);
>         if (!pte) {
> -               result =3D SCAN_PMD_NULL;
> +               result =3D SCAN_NO_PTE_TABLE;
>                 goto out;
>         }
>
> @@ -1544,8 +1543,7 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, u=
nsigned long addr,
>         switch (result) {
>         case SCAN_SUCCEED:
>                 break;
> -       case SCAN_PMD_NULL:
> -       case SCAN_PMD_NONE:
> +       case SCAN_NO_PTE_TABLE:
>                 /*
>                  * All pte entries have been removed and pmd cleared.
>                  * Skip all the pte checks and just update the pmd mappin=
g.
> @@ -2832,8 +2830,7 @@ int madvise_collapse(struct vm_area_struct *vma, un=
signed long start,
>                         mmap_read_unlock(mm);
>                         goto handle_result;
>                 /* Whitelisted set of results where continuing OK */
> -               case SCAN_PMD_NULL:
> -               case SCAN_PMD_NONE:
> +               case SCAN_NO_PTE_TABLE:
>                 case SCAN_PTE_NON_PRESENT:
>                 case SCAN_PTE_UFFD_WP:
>                 case SCAN_LACK_REFERENCED_PAGE:
> --
> 2.34.1
>


