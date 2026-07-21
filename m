Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB111C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 08:32:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 835756B00B2; Tue, 21 Jul 2026 04:32:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E5666B00B3; Tue, 21 Jul 2026 04:32:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D6F56B00B4; Tue, 21 Jul 2026 04:32:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2F7526B00B2
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:32:00 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A44A0403C4
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:31:59 +0000 (UTC)
X-FDA: 85012115958.30.06E8455
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id AEBB72000F
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:31:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="aag/oVMn";
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784622717;
	b=HYYFio6NuiEtsB1D/Nbkx5mkTjIA9Vc3Z6RTG7Vodw1e+R+XSyL7QdVoWvrsDIaZBe0k6T
	JIHdhy6XefAuxYxYrlF+GJLMinb/pl+3vxmeIUc3445SqnIKIB1QBHFHd3wIP7RXWp9oEF
	9B8s4NHhaxfx67tYI94jq3UKtPGl21k=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="aag/oVMn";
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784622717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lL531QQnvcWxU6R5Pj5cVLkNLnRVqWipSkDdgrqC3ME=;
	b=o0+zgDrf9fQT1aTeJu0sVsYHMxC4NSUxBVFJTPed/+jrjMnqtRlMNrWKhgq5a7pof7kU0C
	hB2JXFQcpcL2BanyR3BBW3XzgwwmL+u5aE76UewfoosjdsyVKtchWwK0SgpFOhq0H7hObA
	DWorzOaBDIf1KDgLKShdVjiJhZJOfYI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 145E560A98
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:31:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03E11F00A3A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784622716;
	bh=lL531QQnvcWxU6R5Pj5cVLkNLnRVqWipSkDdgrqC3ME=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=aag/oVMnUdiciyOuJtBr+CdlYtiCqj+0z5KMfGtYAG8MtHmIYibSK/zoEhw3+I3y0
	 4FpdPzaETefkBk1bdk3FnBbMTbkKjYix8cGY8pSsUrk5bojOrlxEYtBi0R5ngmIzp4
	 Iax5g5YXYo1K3O6x67quIRJZZJIKRVraleJ7D3C3qVXQXmX2K4PL5qdfvbiiZ5k5jC
	 ULoKJTdUEkofB1BmxJbZjpCF30WJnqliD2yRFewDZkyWP+/gc/QnVqmgcqSKccEdU9
	 NrGSTMOkr32PLuAW5UdPg1trVZ2mL5hYw1muybfl1L5yL5AF7R6aiDGSkvVaQpnDJS
	 tdcLv6I9TIukQ==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-92e67555e24so566676185a.3
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 01:31:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rpbb5VBmZ6GxOKhdKkeIVoqi4wsVgou9iD8zAnM7TS7XEenkgUoXCbvPQoRQdUA9RGR89aYOsB3jw==@kvack.org
X-Gm-Message-State: AOJu0YzGDn38EfJl9QqvsL5LY3ma3xYSH//gqzPWbpeY+lZyB5MdzG6C
	DT1iZWUGSXKphPs/MBtCp1xoYuMCrcceulqYUMPALDiEbHUd6NoF2vEX1wysQCut03xbhGCB0U5
	GLhV1W7+ToCm7bp7Ye1vu9+tqLv+UCoE=
X-Received: by 2002:a05:620a:2b9c:b0:914:bb06:288 with SMTP id
 af79cd13be357-930b3f2accemr1586443285a.22.1784622716188; Tue, 21 Jul 2026
 01:31:56 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1784509721.git.baolin.wang@linux.alibaba.com> <f57d94b1d85bb3d620d89bb739128f0d929bf9c6.1784509721.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <f57d94b1d85bb3d620d89bb739128f0d929bf9c6.1784509721.git.baolin.wang@linux.alibaba.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 21 Jul 2026 16:31:44 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zBpd2o0chB84P=hNYAeM34E6xiFYMb89nrq5epr2GbVA@mail.gmail.com>
X-Gm-Features: AUfX_mzuW85yFyFqMP4yeVsIMpfEjLCFSomJMPiQXNiKXNUbm-a5eGjX9bD0H5g
Message-ID: <CAGsJ_4zBpd2o0chB84P=hNYAeM34E6xiFYMb89nrq5epr2GbVA@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] mm: mglru: promote mapped executable folios after
 first usage
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	hannes@cmpxchg.org, riel@surriel.com, liam@infradead.org, vbabka@kernel.org, 
	harry@kernel.org, jannh@google.com, lance.yang@linux.dev, kasong@tencent.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, mhocko@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AEBB72000F
X-Stat-Signature: 7nd8u1ztsbqw5gqnfdrfshmb7xkbemne
X-Rspam-User: 
X-HE-Tag: 1784622717-349064
X-HE-Meta: U2FsdGVkX18AdItWDiJNNweU5ZPdDy04VzNWcesrFYMoGXCObySNwcEcdjLIcupkbvsTy2ESchVGJYQZWnkc2QfUiGPygY+G51uA4nJC67jwIVCvzn680TkOXnw1wRdnccC1ngApDA/ZmnSsnnL9djFCd0GmFrbGDt5NblF+iAMXaMN1iKVJG1jgELNuBWdQojHrQbLE9NLZV1Wair+ImYSxlR78yvfshD2+ocbW5uaw/mCmAs0Q73GQk5IpvZ1qNKHQl9+vKCv1oC2W/cJqXruqUe4c8QRAXPHwJN/mcqcn+kkMr5o9TYsdGC0qhBy5dP8EqzF0fPBMWs3C53cJtNBk63O8S2uHiKSAQdHgNgP5PSa9zKDKY5q3G7nE0SKYcxPErIkXFeBZHmRV7AWGES+ipr6PyFekhLQRvnkL1gUoL9NdrFxzwmVnGcex7qBpccO8gqbWr4Z25KCu+2A7RaRxCCBF7VwIcaxZ/Vkcy6OQGlUkkaZEkKRWN4kLqDRbUkeGZqi6jN92GnbR7FfOokTupXoufte6qmrn5JNrFzBOVhf6owKGtrKPHQjwmSXhYNAV1k3EaGedG77fN9cp11B/g6YfqegHYmG7hvKFx0XpQfuASdi000jLiCcu5LJ++ZcaeaXgeOoWDQf23WOy/DHPRZjiZvLF1dJfGG8X+vI77+WSP2AWFGG5P+iym1DqtP8HGxRGgAvwZI0xPJozzr4j2sCK/qk62WwpE1JvO+AFmkN5lpVWfKOp9SVDBM4pYdSIm2E2/5uIEIFKn2FbDMpcWJo/qibtvHhtL7M65mzbhvh6WezrA4EOSmbGlrkm8ltvWb8YtNTuMAi6rTLOkN0CsDz1tw1YvPuCdN6etstQlcHcE+64U6UZfGQE8F34jVBBUy2lFLg0SgMhweEsHco0QQyL22TeWtozHAvONdTYosDddRoRGWVdP281MY9A3mzdmTVx4hyGQK11FJW
 lZu/dSle
 MlXFwWDzYlmqCxyEJt7Wkcq/VkraZ6ALyu+54oghzHcvM30ZMgrx3hiV6B2fac88K2IHmmV5vlL+YLdaebtv1+YQMPVaxUsLvvOljuL+cHmNt3j6gKYDyXUzUwrYCpe0yGlDgG4ogRtY4wF6M+FzagNZ2Kz2gT8UtfKnAwwDAlcSSMT9pC2WSE4t7fwhJsCEqeE29D1pfS6JS8aiEPSm7R0P6w0FIvD49V4JYg6kvLf+t2g7fF5QHdd7YhzMa77GFwBKbNa9MGyg69aSe2eEYhZ++pO6sErYOJbYWtwJ8h9VO/7WU4+y1RpCEOWm44feC1UrNkHrPb6Dw9kA8hkgcbY1qCH2S2VI5Ts9KlwkLVDZOtKxIq+WZoveM//Db5oTTf7uTTpcPjaRk3UE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 7:12=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> Classical LRU protects mapped executable file folios through commit
> 8cab4754d24a0 ("vmscan: make mapped executable pages the first class
> citizen") and commit c909e99364c8 ("vmscan: activate executable pages
> after first usage"), giving executable code a better chance to stay in
> memory, avoiding IO thrashing and improving workload performance.
>
> However, MGLRU's protection of mapped executable file folios is less
> reliable. Although shrink_folio_list() checks references, the access flag
> of mapped executable file folios may have already been checked and
> cleared by lru_gen_look_around() or walk_mm(). Additionally,
> folio_update_gen() or lru_gen_set_refs() only sets the 'PG_referenced'
> flag for mapped executable file folios, which causes shrink_folio_list()
> to ignore the first usage of these mapped executable file folios and
> reclaim them easily.
>
> Follow the classical LRU's logic, promoting mapped executable file folios
> after their first usage in folio_update_gen() and lru_gen_set_refs(),
> giving executable code a better chance to stay in memory.
>
> On my 32-core Arm machine, with the memcg limit set to 2G, running
> 'make -j32' to build kernel showed some improvement in sys time.
>
> base                    patched
> 9248.543s               7861.579s
>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> ---
>  mm/vmscan.c | 43 +++++++++++++++++++++++++++----------------
>  1 file changed, 27 insertions(+), 16 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 8f0c31a4848e..b1ec65fb8947 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -841,10 +841,16 @@ enum folio_references {
>   * with PG_active set. In contrast, the aging (page table walk) path use=
s
>   * folio_update_gen().
>   */
> -static bool lru_gen_set_refs(struct folio *folio)
> +static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t *vma=
_flags)
>  {
>         /* see the comment on LRU_REFS_FLAGS */
>         if (!folio_test_referenced(folio) && !folio_test_workingset(folio=
)) {
> +               /* Activate file-backed executable folios after first usa=
ge. */
> +               if (is_exec_file_folio(folio, vma_flags)) {
> +                       set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BI=
T(PG_workingset));
> +                       return true;
> +               }
> +

Hi Baolin,

Do you see any performance difference if you change the code to
something like the following?

-static bool lru_gen_set_refs(struct folio *folio)
+static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t *vma_f=
lags)
 {
+       /* Activate file-backed executable folios after first usage. */
+       if (is_exec_file_folio(folio, vma_flags)) {
+               set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS,
BIT(PG_workingset));
+               return true;
+       }
+

Best Regards
Barry

