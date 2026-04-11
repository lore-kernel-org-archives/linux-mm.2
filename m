Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC064F45A12
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 00:03:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D1626B0089; Fri, 10 Apr 2026 20:03:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A8CD6B008A; Fri, 10 Apr 2026 20:03:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BF746B0092; Fri, 10 Apr 2026 20:03:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0CFBE6B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 20:03:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D5A0C1B851D
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 00:03:14 +0000 (UTC)
X-FDA: 84644325108.09.5B3CDBB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id E0926C0008
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 00:03:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NLPjXPZk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775865792; a=rsa-sha256;
	cv=none;
	b=KkR9b3Pv8c0kel/wVHEjjiOJ/88Qw8BCIBGpgRpiHpH1gkPpvdvndHJBrXUFgiO7fIF9Hz
	585jtslB6rnZwg4R7q/TjyIs4yi9cLxGtxBu6XZpokOl0UP+EBQQaySSMgE+RbTg3OB6VT
	2y9XN8Eel/536t1VnGj/bPxcGyfjg4A=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NLPjXPZk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775865792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vo07IEEor44A45IKDz4si2s9ZMDcbD6/KaYjO1Ru0cQ=;
	b=bZRGr+XfnPgA4/hv+chx2QI+bes8PlheJcvtRyKxyELCOPZ4kktiV5W1LB8zJ/HeYo3Qto
	ZkIx2Lu8QLttuSF/XS3eYZu8IkZwrcQ4IeFNFWl4CPqkZ2fPGUhETYimNEm5U3Cg9QRav0
	YnPAtjKMDQopyCfsQOnBIx9OBI+aEVM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6471E6014B
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 00:03:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C14FC2BCB1
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 00:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775865792;
	bh=s00cJDKUdEFNZsjiigISTa6qpm7ELSvLgwGZQOmLVGc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=NLPjXPZkXUPep6eyutJdQordploqwiWZX2MwXTxbBHx91Fn2qJFzEtdqPRYcFBjuh
	 OfK4BZHK2S4fYUuN2/DaYrv5xW5qNzeaV26jKoaoSnF8IFfVxK854bZw5GCD1FwJHa
	 yKnOl1mDtjDk/PvVdHYbMcUTZka9C8pEmy/Ot9/JcW8CLZmTaY989MiV2qtask7VMk
	 zY9TOKYhIvgVHzBmVgYlOk3C7PQxeuEh92NP19nKBo3TDDqZV6PsLunvnji0QxxIjm
	 eBM9BfccRFVR1H+qYG7kx6j8OOOBaIGFeCn1fqpopS+taJ+9WJVDbxpCkM9N2NZXzI
	 ZGqORfsBZOQ+Q==
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8a154cc6a48so28248166d6.0
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 17:03:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWGHFW9HuHGyxjM9h+cb2J/qVK5yyT+liuk6max5wptcDCet7OOiqXU/Fne7TFd055BsuXNQUmUXg==@kvack.org
X-Gm-Message-State: AOJu0Yy7dXXkWDvij7Yl8qctxAkQlMcK5ec+XexjOmXQg6NnaDMzTY1+
	HK3eVyZwljHTUb8qEIWJe7+vgGk1sXMkCxWAXbk6NDg9eqqjFYczkOrl7Y00vl+Hb1r7H6UjUx0
	qkKm0LAjLdPcgwnheIEejSmle2qTuOY8=
X-Received: by 2002:a05:6214:4018:b0:89a:b0c:7268 with SMTP id
 6a1803df08f44-8ac862d6287mr77078176d6.54.1775865791296; Fri, 10 Apr 2026
 17:03:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260410-batch-tlb-flush-v3-0-ff0b9d3a351a@icloud.com> <20260410-batch-tlb-flush-v3-2-ff0b9d3a351a@icloud.com>
In-Reply-To: <20260410-batch-tlb-flush-v3-2-ff0b9d3a351a@icloud.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 11 Apr 2026 08:02:59 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zsrOs7RTGKrSTEN67XUKotLfP+yfYQGm=SL1isYd9_-g@mail.gmail.com>
X-Gm-Features: AQROBzAop7mpqEHfVnKaMoeA0iDqGmmQIMtaADkvae83UhS-6WP-9mE9Tlj4nWk
Message-ID: <CAGsJ_4zsrOs7RTGKrSTEN67XUKotLfP+yfYQGm=SL1isYd9_-g@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] mm/vmscan: extract folio activation into folio_active_bounce()
To: Zhang Peng <zippermonkey@icloud.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>, Zhang Peng <bruzzhang@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 33tj3f6ipwqjag4fa9msmsmro9wuyx37
X-Rspamd-Queue-Id: E0926C0008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775865792-58125
X-HE-Meta: U2FsdGVkX1+3IHbj7ANsJIGEb6/2eCqjga+MFcjR4nCCMDY/aKn6D6Xj10xYsAhWIqpmNPg9X9b0WGHDoOEXlRlNgYwFbhSncMBVpLY67vnkYi90qaQIJ4bIbmDdwrJGxX0+GjwwzZSFSgvis4fJDSi/NJ9EulVGzmbOXRgzz67y7lcs75RfGdUrRpItcVYWq0qdoIeyuxgEL+Gu9rmkdJyo8QYoqj1j6wkAs3IzX1om3pMQQfq4d4BymPLEKPbgkUP8dIM/uAMGqNQMtlMLWZYGK3PhJIbq8CLwgnaXBzzJ0ntz/jh+5YVE8hGCGCm+H/AzFKi9bPuIpBpoUN1wG5O4NAh6ccS5No8dpEeO9nhH8pYvcBe96UN9yfQK8vFtDFCi+Kilw9i80NTxpuDLqUIFt40ODf01NmO1iEKeloDQ9R/Dj1ekGntiT9Qy91GLoLYqTU3y5HspedypqLZhWDoxLAbVkiVxzAiLV4yOMy4mg42NMeOym5XezND0cM0DBP46K4d2labCGyJ6ny+LZkMtKggxR0M2alhglcKEi6rMrOhD3x6AwfeDk9Mu1brI11Da3QVvYQk3gvFtjSmMgaITFjIQBNdg3OJG8vRJyoSlN0rQsQvO13/WdzuRlnBizYC3ytF98oOvOnn+APX7VT47/lC+7hS6mofk44t24nwOVUANEoee09UqIr/9s3IIYNP0gg/5LVLtXS3L1we8zXtxTR8VXm89y2Zt23XoyuNqi/nY6aiXjKP7GrMSrAdsxrt3/jgWaXAiAR77jsNXwBEX4UPUvvme/YdGASHaPvVpGrfkJHrHNh1UOrhgr0Et5hTCa7zXZhVKQiSwdEMBX6E/AkpoCV2PfMc9kBGnCvtHT0V2QJCzBRpg71ZJiZ+S2rflv32UB0ThxEd8a9svceA8KfguPL2AqBpP4GIxLPg8DOBGFKsXeDfdv+CKx/ho42le8iGJdb3NF0R6nbE
 rL40NHy8
 lvKYgemk3u2ulw8L1I1n18OO0pvmpoPIxsO3hlYL5qrT1u+HlAJ3Vs3Mz0Zcydy4LUeXfxilnbKn5E+vQsTxpS2PriAQGdTktLoM94uRbD5rSXWF45O09DNK5ummwsAE2Te4AtBaBGRMlJcGMUA5+ppHCDi8jczpGZ5tLnzMPq0U8Sc63L+sDX+t9MpvdS/4n5iEPiOrb4KtXl0NFL4+8hAxbqyIQBIXnxLmb1Kge15g8BMMJKqkPU5GIcI+/oVb95tKhmVPj/KE/dAMpm+51eHIEyfhTR2Ns4o9O3cFzlS3U3CwOWiCgwsh4rDawfbhbwHE6Tpwgkv04wIhuarvBHAtiIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 8:47=E2=80=AFPM Zhang Peng <zippermonkey@icloud.com=
> wrote:
>
> From: Zhang Peng <bruzzhang@tencent.com>
>
> The activate_locked label in shrink_folio_list() handles swap cache
> reclaim, marks the folio active, and updates activation statistics.
> Extract this block into folio_active_bounce() to make shrink_folio_list()
> easier to follow.
>
> No functional change
>
> Suggested-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
> ---
>  mm/vmscan.c | 30 +++++++++++++++++++-----------
>  1 file changed, 19 insertions(+), 11 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index f3f03a44042e..0860a48d5bf3 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1052,6 +1052,24 @@ static bool may_enter_fs(struct folio *folio, gfp_=
t gfp_mask)
>         return !data_race(folio_swap_flags(folio) & SWP_FS_OPS);
>  }
>
> +/* Mark folio as active and prepare to bounce back to head of LRU */
> +static void folio_active_bounce(struct folio *folio, struct reclaim_stat=
 *stat,
> +               unsigned int nr_pages)

Not a native speaker, but =E2=80=9Cbounce=E2=80=9D sounds quite odd to me.
Also, folio_free_swap() doesn=E2=80=99t seem closely related to
=E2=80=9Cactive=E2=80=9D. I don=E2=80=99t think this extraction improves th=
e
readability of the code.

> +{
> +       /* Not a candidate for swapping, so reclaim swap space. */
> +       if (folio_test_swapcache(folio) &&
> +               (mem_cgroup_swap_full(folio) || folio_test_mlocked(folio)=
))
> +               folio_free_swap(folio);
> +       VM_BUG_ON_FOLIO(folio_test_active(folio), folio);
> +       if (!folio_test_mlocked(folio)) {
> +               int type =3D folio_is_file_lru(folio);
> +
> +               folio_set_active(folio);
> +               stat->nr_activate[type] +=3D nr_pages;
> +               count_memcg_folio_events(folio, PGACTIVATE, nr_pages);
> +       }
> +}
> +
>  /*
>   * Reclaimed folios are counted in stat->nr_reclaimed.
>   */
> @@ -1527,17 +1545,7 @@ static void shrink_folio_list(struct list_head *fo=
lio_list,
>                         nr_pages =3D 1;
>                 }
>  activate_locked:
> -               /* Not a candidate for swapping, so reclaim swap space. *=
/
> -               if (folio_test_swapcache(folio) &&
> -                   (mem_cgroup_swap_full(folio) || folio_test_mlocked(fo=
lio)))
> -                       folio_free_swap(folio);
> -               VM_BUG_ON_FOLIO(folio_test_active(folio), folio);
> -               if (!folio_test_mlocked(folio)) {
> -                       int type =3D folio_is_file_lru(folio);
> -                       folio_set_active(folio);
> -                       stat->nr_activate[type] +=3D nr_pages;
> -                       count_memcg_folio_events(folio, PGACTIVATE, nr_pa=
ges);
> -               }
> +               folio_active_bounce(folio, stat, nr_pages);
>  keep_locked:
>                 folio_unlock(folio);
>  keep:
>

Thanks
Barry

