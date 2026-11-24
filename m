Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F75F606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 01:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FCrgtsoC
Received: by kanga.kvack.org (Postfix)
	id ABC6B6B05B0; Mon, 23 Nov 2026 20:18:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A73646B05B1; Mon, 23 Nov 2026 20:18:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 935016B05B2; Mon, 23 Nov 2026 20:18:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4ED606B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:18:27 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A3E93140262
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 01:18:26 +0000 (UTC)
X-FDA: 85468252212.13.1AE7436
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id BD874C0005
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 01:18:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FCrgtsoC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795483104;
	b=SPub3V6oVcDJGmSq7KjXIe875dp/2fehO1o23KgN7B/ObvazqMjQhB1wpe79dw8z8fEWeZ
	TXy/yj22GwBIIltYPKwYsBnC6j8CmfqnBrP9qAK0Tjt8OLeBmvOZiJ9U/UMCi0jZU+OIZ1
	A1twSZPH3+hvCa1mDqbnqCRCUAdyMuo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795483104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lx5oGsaKBeC/olTwJTc6cvrPDCBTSPZQM0FAaQu0eIg=;
	b=map/040+/p1Sh5gFvTRWAw6bosouwQirZQGgfQSD4tWJff/DcyYH7E5RuvU/0oESSj2ByV
	amI1teS8UgUNU3Du0NVrnoV3oWz0Z+AyJ2DXFh0osyQ3xOX1JXHZek9oq1A4tzZPcZ17UZ
	3uK3JeQrQ1InADzMb8+iFlfN8c7aVGs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FCrgtsoC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0FACB4402E
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 01:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9921F000E0
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 01:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795483102;
	bh=Lx5oGsaKBeC/olTwJTc6cvrPDCBTSPZQM0FAaQu0eIg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=FCrgtsoCnwoodK3X+92wdwN11OUS1OG5GUTlIxQGObwlq6d/G59vXw9e5MiQ1rZsP
	 LxAkB97waYFXr+oVXtCQEZy26SBkqg3hMIX9a1YGgF4BWBRfvXF7VyjHIim/t5pF24
	 fdXA2CqJTxQUObadSI6lIWVhH/kQaq4Umvkg36Kgamm5gLy7cVCNGCiTw48bQ1B8h8
	 s3FKH/tswyY/NX5x5jOIGp0US3FMQNU9b+1A9QMTJGldEKVxsIX8+BL/Ey8uty8JRI
	 0sVFtkO0dN417LATFck0sY0zaBE9xtpY/3WKrYRJBX0/HV4WPBEMi15tZh2fSYdo/d
	 1hKOrvKrNobtQ==
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-93f3c616c84so320558785a.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:18:22 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErF9K8FCHWMEmu66m3e67Je6iSu4HTfiCqBzAyjdhMCNYXNWvx9FO9yQGqGlAs9fFCCs1ODXqXyH2A==@kvack.org
X-Gm-Message-State: APuU4Z9L3+R+2FHeDcOqTpNpAYlKFb0kAI5rKhgA2vuuBomRj4j2aI3F
	aIB1UcA5So2ohEdf/Sc/ifdwyQSg5NUoD7q/5waasdbASYChkGoOjog1spHRhVtnOXENMr9PrxU
	zb3uVbsYiajTk9ChSPpB/46scb23c9B8=
X-Received: by 2002:a05:620a:2685:b0:945:c4b9:3de2 with SMTP id
 af79cd13be357-949bab3e44bmr2217936385a.73.1795483101645; Mon, 23 Nov 2026
 17:18:21 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119134740.514632-1-ridong.chen@linux.dev> <20261119134740.514632-3-ridong.chen@linux.dev>
In-Reply-To: <20261119134740.514632-3-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Tue, 24 Nov 2026 09:18:10 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xsz0TdYUTtS2Pfr6PvfAs1PvDxzmPGU5wgBgjGVrB1EA@mail.gmail.com>
X-Gm-Features: Aa3M54r4lfyIzrlWDo6QCDZ4v43IqvoEb2hC2TOVsvf5QAL5gXSo6sD5gYxGoqw
Message-ID: <CAGsJ_4xsz0TdYUTtS2Pfr6PvfAs1PvDxzmPGU5wgBgjGVrB1EA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm/mglru: deactivate anon folios into the oldest generation
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Yu Zhao <yuzhao@google.com>, 
	"open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)" <linux-mm@kvack.org>, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BD874C0005
X-Stat-Signature: ert11f7z5zq6krhksn1ywjgt8zdo6i3z
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795483104-450810
X-HE-Meta: U2FsdGVkX1+lXnEI7UDYHnbnb4M2+XkFJDwo9CFB4c9RI2xr17guxnBzdWQ2HVup1AeyA7jl+hzFIrTXtAMqS+v+XJ8SROhghfm+gVg+NjgKorIMgJFliZM6I1BACCncR8R4TvD580CUK6TzROdr6wIP/GlskhtbSxFxX3CnJmoUdhyc5UPYvElRFjuAN8ZC4tcDOgV5X4RqM4SqA9v3WoYlA5a712amvOAafLevcWtHYCr4gcm8u7O/bsR9+RrAhvQCHQLFz462XagSZdxmg+qN3QvxdqJ71DYTl9H35W8pN4ZiqsXQctgllPsIFaKvdLJOO72z4lFxgxCkyBvTxuGDRv9SjeuHGV6oYM/K95IP5SkCDNDHfvp6vZVFaJDodkKiKIPQ7KEFVIxyhVL+MsjJePlKSQFvp2l7OkG9FNKbo7hzV3ohVTvyZiCgdt3S4kb0hTqAh5KF0+ODhh0LVLpoHCXmdIEZR3HB8rJgjTRcqrOpBOTjDPazpfUzOzPxD4/c1+VlU3kSco9HifxOcqCydOLo+OtpvTG/P1T6/5H8b20E5tvS6cDKP3TUu70fgdzwoP7IjJar2D3u/dJcNPOUaPPAOQn2NKPjShIBdFIRzpwV+GcFbY8Z38iPm5XMq3vdnhX7neUxMvtpV7747/e+iWZr5AxkWLZpAj25sh7kZBYatNwIGuWt8i477maKfvW2WIb6e4WKnQ8mVtA4Ed2AMz2E34AxmXQeQ9ayQ3xxdWnbfSMM11KkeWJ0Z752HNY1dRaIEegZcZaDbmmoOOdrOcDPiyNG53pMEvsxLrb5hLQRpPZcLVAeyoiQw471UOFm8Ot2AO5SQ1lKf16cbVLOgHY2+agNs/UocNb4oxzGBM6Gr/PKZBSZd0qR4EjAIkcWzV3+r/tw5G2RIPpnZ2IFB8QoBHTiNFEJTGQs0hfphNleBqUnpyNcvbhiNJV72CPpZOiwOABGSVwVzwX
 KHTrKi9W
 rEXjZCoqsI5EgLA0vwzDNoVPqBdYJMqDWOSTuXkrnTRd2SAnD4rHbJnmxICGZvWOi6q94txkLpVJVs32Rf68hdljgW37srDJ2C7b5lq/GVALbs6eGrpjxY3hpRI5GM49g7DbRwDOW6JrVgd1BR5Hkwk4A0V06q43zMVecsREqEyWOFHyO60bwoO/t2Ev4WEDWU31aTn1FOa0EPt5nDZEz18IIATw5vnqof4kWLw8tf2veML+eW29xgeKcZ2Xf62dm9Ac7ZpPUnwrM19yHuYC+WTQtz85+oc+YaWKxWbz9eQmKutoPL2QA060c9Ttmsp/Kg+wGaJ0hufwrb2n/+Upv+/ict4blRS1eNULdLRMTkV1cU9d9t3YAZWqR2XPfHC+hbFeQbnIuderDaorMgnj459jf87il4Zg/pASIkTrTn6PEns9r0LSbThgrIbSpsEbuy2dSNwVaJJfYw+cvNc/Dc9nIulDafw0F02ErUq3/aZP0MBBcI9oZNROyqak3nWVCldJM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 9:48=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
[...]
>
> diff --git a/mm/folio.c b/mm/folio.c
> index 7a3394e7c5dc..1bfd746d7f07 100644
> --- a/mm/folio.c
> +++ b/mm/folio.c
> @@ -423,6 +423,14 @@ static bool lru_gen_clear_refs(struct folio *folio)
>         return gen =3D=3D lru_gen_from_seq(seq);
>  }
>
> +/* add the folio to the head of the oldest generation */
> +static bool lru_gen_add_deactivated_folio(struct lruvec *lruvec, struct =
folio *folio)
> +{
> +       int type =3D folio_is_file_lru(folio);
> +
> +       return lru_gen_add_folio(lruvec, folio, -1UL, lruvec->lrugen.min_=
seq[type], false);
> +}
> +
>  #else /* !CONFIG_LRU_GEN */
>
>  static void lru_gen_inc_refs(struct folio *folio)
> @@ -434,6 +442,11 @@ static bool lru_gen_clear_refs(struct folio *folio)
>         return false;
>  }
>
> +static bool lru_gen_add_deactivated_folio(struct lruvec *lruvec, struct =
folio *folio)
> +{
> +       return false;
> +}
> +
>  #endif /* CONFIG_LRU_GEN */
>
>  /**
> @@ -609,7 +622,8 @@ static void lru_deactivate(struct lruvec *lruvec, str=
uct folio *folio)
>         lruvec_del_folio(lruvec, folio);
>         folio_clear_active(folio);
>         folio_clear_referenced(folio);
> -       lruvec_add_folio(lruvec, folio);
> +       if (!lru_gen_add_deactivated_folio(lruvec, folio))
> +               lruvec_add_folio(lruvec, folio);

Since we're already introducing a new wrapper,
lru_gen_add_deactivated_folio(), could we make it more readable
and self-contained by handling the fallback within it?

This way, lru_deactivate() only needs to care about deactivating the
folio, not whether we are using MGLRU or the classic LRU, or whether
MGLRU is enabled at compile time or runtime.

index 1bfd746d7f07..5a6092e64fe1 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -424,11 +424,13 @@ static bool lru_gen_clear_refs(struct folio *folio)
@@ -424,11 +424,13 @@ static bool lru_gen_clear_refs(struct folio *folio)
 }

 /* add the folio to the head of the oldest generation */
-static bool lru_gen_add_deactivated_folio(struct lruvec *lruvec,
struct folio *folio)
+static void lruvec_add_deactivated_folio(struct lruvec *lruvec,
struct folio *folio)
 {
        int type =3D folio_is_file_lru(folio);
+       unsigned long seq =3D lruvec->lrugen.min_seq[type];

-       return lru_gen_add_folio(lruvec, folio, -1UL,
lruvec->lrugen.min_seq[type], false);
+       if (!lru_gen_add_folio(lruvec, folio, MIN_SEQ_UNBOUNDED, seq, false=
))
+               lruvec_add_folio(lruvec, folio);
 }

 #else /* !CONFIG_LRU_GEN */
@@ -442,9 +444,9 @@ static bool lru_gen_clear_refs(struct folio *folio)
        return false;
 }

-static bool lru_gen_add_deactivated_folio(struct lruvec *lruvec,
struct folio *folio)
+static void lruvec_add_deactivated_folio(struct lruvec *lruvec,
struct folio *folio)
 {
-       return false;
+       lruvec_add_folio(lruvec, folio);
 }

 #endif /* CONFIG_LRU_GEN */
@@ -622,8 +624,7 @@ static void lru_deactivate(struct lruvec *lruvec,
struct folio *folio)
        lruvec_del_folio(lruvec, folio);
        folio_clear_active(folio);
        folio_clear_referenced(folio);
-       if (!lru_gen_add_deactivated_folio(lruvec, folio))
-               lruvec_add_folio(lruvec, folio);
+       lruvec_add_deactivated_folio(lruvec, folio);

        __count_vm_events(PGDEACTIVATE, nr_pages);
        count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_pages);


>
>         __count_vm_events(PGDEACTIVATE, nr_pages);
>         count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_pages);
> --
> 2.34.1
>

Thanks,
Barry

