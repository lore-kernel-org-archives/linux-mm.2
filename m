Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7546DC5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 16:31:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 768286B0099; Mon, 24 Aug 2026 12:31:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73F3F6B009B; Mon, 24 Aug 2026 12:31:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62F486B009D; Mon, 24 Aug 2026 12:31:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2FB806B0099
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:31:22 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A93CF1601C5
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:31:21 +0000 (UTC)
X-FDA: 85136703162.24.4BBCAF4
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id BB3CA1A0006
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:31:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qqNmSgiu;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787589079;
	b=D5p53a5AraJpkLW7TepO80k4uacKZ6javFQ3UyTf7F6N/WDJweZVLfHpTvDVbNpeNxLqzq
	853HKDJECYakRt7AmtYEs3yFwtO5QMO6iVLKb93aOclBjHPa5G1RIWS9Vw27KcJorwNgDZ
	jS/GCOZp3il8FhR6cBcIJ5lvtZgqjhU=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qqNmSgiu;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787589079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jKDnyhtd0eENDwLDsf23GJYh56L3iJu19fRA635QnCc=;
	b=05ljbpH52XhIyrJ6Xdstuj1vx+nwkxtJGS52Hf1CqVPYtOnR7i3uYh5/c8rcTNwKjbvY/X
	m6o0a4kzT5nW811g15EXeRCN63yi3lGOayoo7plJuhd46Dxm+D4O9cUdD5B4Huzr9DZJJR
	BYcwXdF7BxWy429KZbVg0hYrUeNaDiw=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c1677c91969so449714666b.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:31:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787589078; cv=none;
        d=google.com; s=arc-20260327;
        b=fwOeCKDMi+93eYopyO4WPX9OgNUbXBGGO8paTd2bqIX5ajERWOTnD0+h3a28uZkFgw
         3e76A4c9+SVPulpot12MkrntwN1CIfN4baLz2ULKl02VIsRBC/X1pfgf65qJfbI/F0ZR
         eK81CMcuge7RP0rRTgHBBsCcpuNPhdpQ/HX2dW7XCiv/oV3OrJpujU9bDpWUteKK1BOP
         QnNWABfvWOIK/JTCcxofAnb9bE+AYnwMmNxr6JVhd6ortZQI7Qqw6EUf/E7k6K+FOuzH
         mRxMM5jl+SGgpr+v1O7XrBxPCWnioabkcNew+qYtGlU232BszEeNazF+HOcE6vNkfXiO
         16bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=jKDnyhtd0eENDwLDsf23GJYh56L3iJu19fRA635QnCc=;
        fh=sSxWdZkaFVeQjqnPWV27Nlezj+mkFUIjYDnQV3tX/BQ=;
        b=LuzORG0TGTHswgMZA38IOwh/e9/EZujbsIrJJqiBCgSDFq0MdI1u13hfn/VBsIPVeI
         OfKIo2nZHsclig7cu4Myqud7g76+znkXoOqYmybzTojw9spUNgxA4gXd3A/D6aD/UHeC
         ymj1Xjeg3v0wDmHGvwykwbkVnps022d2L4Wcrj8YFqjdbvh8gZtct0vNICP6eoevbrJq
         kFR4avjoo92PePVXFy8WnJ3JllyAXIH8w0AUSbAZpubZeBXVUCtfZtpJIKRpaRzSejuJ
         t/ukd2sXVvJmnxX8gcdzgllZKyOUTnw519VuhC3IIJbQOw/XuAdLC0M+f4qxQUnhO47n
         M2kw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787589078; x=1788193878; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jKDnyhtd0eENDwLDsf23GJYh56L3iJu19fRA635QnCc=;
        b=qqNmSgiurdQ6YG1kLS7OsVqDUytCv3dieILB2xYlWC+/oBzzAHOLe4Aa7M6dzwS/le
         9JaAS8tqz8bYbVEnzJk3Rg96gQ9e6R9N5vdDmQQ6Zs4zuWizggJPfZtkcOWCtJ0vC3fv
         DI4bGuaVtp/tkarYkrljrSHXtdO9SuIF71pavdE2b6azMrx3mu9sAyfacm7OlkqR14Ud
         o4CZ336laEpREywcHCHrxW/EiZ32PHWth9tyVwJWHN7q6n3w4loHJEaAJP1uHgtqaHLb
         accKzlHoAluGdE6bjpI2i2X8/U4g+GQHEtPDnCdKLGnvi9VMnwRq4v8tc1P4eBYSe0tO
         FXeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787589078; x=1788193878;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=jKDnyhtd0eENDwLDsf23GJYh56L3iJu19fRA635QnCc=;
        b=nfFk0k6CvuwLwzqKt3NJlU1VCsGSKn/p+tATQ8RMzXvyd9CDI+HiuTD95q7akV8AUi
         Wo5PDFXiFqubcD9CIPpkxyymKL9ysEpko6TxvotpemA49qpcGTSy1+WZrl/Kn0PmQrWC
         clDBzFfhffSe+hFR2PtsG6hInAik1uSYsErO/ajphONnMGyG9JyAnqU1xGVptuziutXC
         F82wrfC84xI6Fdbzn+V47XC4031K9bJpR+kXrFIQHX099Fdvd31u6IVq/BGLKHMPuF+j
         fyVRxdEF7as9sW0RBjGW6ax9Kry6+A8fttGXPzWbcFOodQQ/ftEJroFcKEZGh2AorZ/Z
         PlXw==
X-Gm-Message-State: AFuF++kciDmdhOZRizz/MXiPybL5t55d4MwBMm7mUVw3QKTYU3sv1hIq
	95UBRVOsTyaxKJtaH97QSmTDwBvIhRRl2CcXvtY25R95tXyqG1Xnp+hVGR0VSKzBrH2Ge/VMMmf
	spKrlD8ipQKYeJOHV3ZHX//uGfPGLrvU=
X-Gm-Gg: AR+sD13piMqfmf3IDl6YKCHOeWFoC0f0vxoen5s0yRcrVwAVpzhJCZRCdkiS1f3936h
	ZVgBNGh2JC+a7lamRHzTV1jkyuG7ONp2PgPepb6KjewUM7dGAuk/SSyPooPQwaMiCztPwM+tRLY
	fm3dVAG0smt2XLRqnKPYK55yOhcWnUN1NU47jPP4CzNxj/Nnwcrj6dRmkSfFhsaAuqD3cduFZU8
	NJRDJSijCPO0s0qnJG36/oVrz3Er2zmiKeKQmFI4YpOGp4+1zLH0YY6Zh6aT+0Nt4avjHV95v2r
	V4B7mC/p0xcrXZ7etgKMds3sLCCOzeVOY9BLlRIUkQ1bF8mZwWgaW28ze3Z2QNRMQbKp8hX4tEO
	QLiQfpalNCdQd
X-Received: by 2002:a17:906:209c:b0:c24:cc3c:db11 with SMTP id
 a640c23a62f3a-c24cc3cdcf3mr595871666b.21.1787589078066; Mon, 24 Aug 2026
 09:31:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260824-mglru-flags-cleanup-v2-0-0104132114ae@tencent.com> <20260824-mglru-flags-cleanup-v2-2-0104132114ae@tencent.com>
In-Reply-To: <20260824-mglru-flags-cleanup-v2-2-0104132114ae@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 25 Aug 2026 00:30:41 +0800
X-Gm-Features: AcwNN1VH8-bOniuA8E6yY3_HjFay55kxzw2lY4Eo1sZSYSutQu4Ycnu52ZLcbp8
Message-ID: <CAMgjq7BYze16AVf7O4qBzYiNBOuTo_ayza3AjWFEQ=LG4pwuxg@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] mm/mglru: introduce helpers for manipulating gen
 and refs flags
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ridong Chen <ridong.chen@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: BB3CA1A0006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: q8n3kndj58oja4hjpuhfcaet9143fu6n
X-HE-Tag: 1787589079-417963
X-HE-Meta: U2FsdGVkX1+dvvniM6kn5moh2h8kOMPkExKq7RAtAf4Byd+YFZ5kR9TVPCOR1D6BYJ71pWneVNpM2Y/Unw3GvDwl80eHI0WZFOSXlr6r6jknIi2tF+WeqxrqTmi1v84g73RaoqzJpt3uwwW1XgIvcG/VdF9mmc7hyrC2ujElVge2brUEPUc7/p/cBX/mMuYu1JXzGwNwKJXxXV6EGW21uz77JA73NWCkWg7kWy7nPufEyaQEGsc7Z2toJwAVfU/nHUlUUAxnoU6F08sTsp2VrNyIDmOikBvfOkLnkqj2UfxWR0mESMoZxb0uu+OCxOMeM7OokaKu9I+oeLDAD7Der8HDmvVFJYjarjCK3r1xo77AutFd3dNyupn4Yg2tz9S7gAfgrC6pFCQB3nBm/Jxm+FReR3PmS309z8qDxpl2PuS1nOtwyArJtGzWhUoGJaCo4fIbwZqEUHQt724e2VwDD2SJyBOR6W7JwvqWXYpPcjl7Sx21jVX99UK2dc49eNVUIhefSlkMR6nGCB3zhTUOoW72SnSUU/RnXnU7Q02yaiqTqTfcV7WjcQui8qTk1uCAvkDesBvASWM9PruM88FLNPzoKwnD7gLru6/JCLHbkuqaXdnMY1Vmi0LzsYFYIMqLwBEs6OJO9Ig1jem4Nl90H+QwRJrGXpgxiYSk0DgpXpRhyHQDlWew1uzlgCyBCQFxz7g2lBxzCrFbsSdVEf9PWICV1mTPeamMvLAU8WiIh8fYNBN3FGaGDCCqOUYCVeMmmgI/xeWSnhHGn+8EXBCtZtz1vbrTa9eHROKUyn1ggroWU1mIxKpFIE9bMZT30XB2azhzpRywPH4FCYqZFTfvBVLMkAUn/jGu4EkBFDyyPMsbQv2kiNk4AmigbPYsYXCQivllEtjVeM4TfBdUuDQbUubPZrnKzlKSKNH+MryW2+IwTM+xGEIJBloZCmM1TGz41/MtNRkGSXnc5CXoR3d
 CFa9X+zr
 ocSbe7NN7eSuG/lPXFwXlOJL88uGWAN47YFOgu0fP/Dn0TzJD4p+al1DoxqNp1WKytkGP/1SyNtMGiyhTNrSP7VOX4pzryYFMLnqFdNCzoJAySv/6iKDClvtYgHgzJsoAH97nV6pm1E4cu4pH9qb55MoB0RhbeKlEx6/nBJFjsJufeXNf2LMGI+wDNgL8wA8LAPg6pKiB+7zzWDknvQQelltpgo37EIP14BjxUPJ+fwz2Z+bW348cKDJ073WRUvEIXxlWp+3jpRfUwVQANWy09JDmkQ0bOuLtxFzQifXOtBNLCAQcVTC6x43KfS0tE4AnAVL8gU1JBjMKv0Z7cGOWCCKE7V9EC1PZJRZkBRFArTqJVdbOgrMOqea8bU8AaWofPSYJazax5YzkaMdHKwDq9lhHXdpKqYnWiQR2VA847BdHQ5I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Got this from sashiko (I consider it false negative since that is
extremely unlikely to be an issue):

--- Patch [2]: [PATCH v2 2/6] mm/mglru: introduce helpers for
manipulating gen and refs flags ---
commit f0369e7dfac3789b1433352b10e442443527f4cc
Author: Kairui Song <kasong@tencent.com>

mm/mglru: introduce helpers for manipulating gen and refs flags

This commit introduces helpers for adjusting a folio's refs and generation
info. It replaces bit operations on folio->flags.f, splitting some combined
operations under the assumption that the resulting transient states are
harmless.

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index c1404a59523d6..080132997d876 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c

[ ... ]

> @@ -843,19 +843,22 @@ static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t *vma_flags)
>   if (!folio_test_referenced(folio) && !folio_test_workingset(folio)) {
>   /* Activate file-backed executable folios after first usage. */
>   if (is_exec_file_folio(folio, vma_flags)) {
> - set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset));
> + folio_set_lru_refs(folio, 0);
> + folio_set_workingset(folio);

The commit message mentions that splitting these atomic operations only
creates harmless transient states, but could this specific split break
lockless MGLRU protection?

Because lru_gen_set_refs() can be called locklessly (e.g., from
lru_gen_look_around() holding only the page table lock), this creates a
transient window where the folio has both its LRU references cleared
(refs = 0) and the PG_workingset flag not yet set.

Concurrently, evict_folios() runs under the LRU lock and evaluates folios
for eviction using sort_folio():

mm/vmscan.c:sort_folio() {
    int refs = folio_lru_refs(folio);
    bool workingset = folio_test_workingset(folio);
    int tier = lru_tier_from_refs(refs, workingset);
    ...
    if (tier > tier_idx || refs + workingset == BIT(LRU_REFS_WIDTH) + 1) {
    ...
}

If sort_folio() reads the folio's flags during this transient window,
it will see refs = 0 and workingset = false, causing tier to evaluate to 0.

Will this cause the MGLRU protection check (tier > tier_idx) to fail and
incorrectly isolate actively used executable file folios for eviction?

>   return true;
>   }
>
> - set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
> + folio_set_lru_refs(folio, 1);
>   return false;
>   }
>
>   /* Promote on second access */
> - if (folio_lru_refs(folio) > 1)
> - set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset));
> - else
> + if (folio_lru_refs(folio) > 1) {
> + folio_set_lru_refs(folio, 0);
> + folio_set_workingset(folio);

Does this have the same transient state race with sort_folio() as the split
above, potentially causing actively used folios to be wrongly evicted on
their second access?

> + } else {
>   folio_mark_accessed(folio);
> + }
>   return true;
>  }

===

In theory, yes. In practise, it's very unlikely to occur, and even if
it did, we are totally fine.

And I have often observed that folios stuck in highest tier due to
PG_workingset is actually causing worse reclaim. But if we are very
paranoid here we can do folio_set_workingset and then
folio_set_lru_refs. (This may cause a in theory, still very very
unlikely, aggressive protection. And in fact I think we are definitely
fine either way). I might update this if there is a v3.

