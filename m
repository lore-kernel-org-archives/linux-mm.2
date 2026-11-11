Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6299B606A88C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 15:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kxRiJstm
Received: by kanga.kvack.org (Postfix)
	id 7E3696B05B3; Wed, 11 Nov 2026 10:46:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 794A96B05B4; Wed, 11 Nov 2026 10:46:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65C886B05B5; Wed, 11 Nov 2026 10:46:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 392106B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:46:39 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C8589160322
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:46:38 +0000 (UTC)
X-FDA: 85423265676.28.996B5C8
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id D471D180005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:46:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=kxRiJstm;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794411996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i7mcrqf7XWOgEb4YXjGMz5tqNzLFKqEiO04XvkJXxpY=;
	b=bLgY4weYIOAVgUYQoO4ZAJH+tkkQv2GG1XopZaPjwXERZjLLv1MZHOG0kESmIycSQXaUxF
	EYSxrCHYOpU8SScIbvdgjAdMkjkCu+Lr79FC6qftASNc4Pw1ggauVRa/+5MF+4dn2lUylC
	dSkwaWS6e2le2QtQyNvcs/s6u8eKaTk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794411996;
	b=559/hl0nZPVeDSX+idDyyoA4ck6lT1jr3mRB5XhG+/V+9bZF6QOrnmaMUzjUk2xa8r2u8/
	cYtueLXICbNPs2z1rLesxHc4ZOgoWZrjXu9q8dLwX9KYa6mhtwEdMuRPYm/3toCPNVGzYt
	fhY2TvJI9xz2jvO2CXWxYNvG4Eikc2M=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=kxRiJstm;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b5669a5100so4386260a12.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:46:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794411995; cv=none;
        d=google.com; s=arc-20260327;
        b=lqLLVqLR1RWupZyCqHI16FtKiX5Ny96tqAhDJgblDFH9//Exn2atvfFG1sFgtUpiGM
         JaaSOz20xEwO3Tkx/AhjsmXeoAU3Ts7b1rm7DLoGXqZ6nzEvpMpZUTQ2xCWZafrqBL9E
         f5SzzwjPZwmUHELNAwwD2+J7555bxnovekRlCqrFWohY3dnFcmK/gU2ElCgygG/vIcvM
         5G2qKOruEVrNnnnb5fVot0ikwFSXc2xAEoy7AK8yVkBK1GFT8l5beIdpTyBdt+6BQUMH
         Bnipg8abk9P82z09m31r5Vyrd7cgXAO0zDXPspeAHb6vcDGQpD4jI87yEdERnwAUcwE6
         SkqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=i7mcrqf7XWOgEb4YXjGMz5tqNzLFKqEiO04XvkJXxpY=;
        fh=fyrDjdGjHZG1UGN2PzEWKW86R5YhFF+WTYxp0Im0Wmw=;
        b=ZBlyX6a7K0V27cVIcQWqSR8xPIfbwcCHL1YhZhXxeV/Geo7f+EDGTGW4g9Q1D1tg9a
         XPvPGoD9bSR19lKkzMO+PChyk8/umWnbVuKIc3fTxZuUjwAAaM4uznlFwtUKwgZL8zIv
         RH/+ST8cmNFHbtHRs+GlUHKanwOnSNlpPejD0s0nrm0SBz/qRDnUXSeldqE41H4pHzOG
         ACdWf04zQCOP5yqYeSNkXLunFzsMqbZnQLHcZ7sQL4hHsc6WYc5h3DJNMC1xPbcNdK/D
         eLGSBOdrL4mVnhR3qnFllpS7EndGSQt/AlDIIbVRmDRme475OfIDS95Kxd7sEDnM+nac
         g9vQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794411995; x=1795016795; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=i7mcrqf7XWOgEb4YXjGMz5tqNzLFKqEiO04XvkJXxpY=;
        b=kxRiJstmoFnxAdzK9w/ovpGqAfQaELfC1MWhfAEQQg/JyOwgvF98LUq/LCICMxu7R6
         0i0OcMKy48SG8KfBdETKtkOsaVnNkGFIcHQzjaEqKGGdOUk2dtpANU1ruqPxo6g/WKBd
         AOajYK1a5J6jQBxhlIdXcWJoTdMGD1OxQ8zzM/SCHcen1k2xclbmYI5X1/OGaSZzpRUy
         OSxUkNwQo5rPmsdRrql2jFkrbxa6M+5pVjNAq9QynTMMb/93wtcasmeB1S9VB9yR225r
         EVKJ8HPNxc6JMYqIWtk704Zr9IM1gOBQOamIs9hS2qYpP/ZQ7vpJyk8wY9nDgoexfmGo
         96Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794411995; x=1795016795;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i7mcrqf7XWOgEb4YXjGMz5tqNzLFKqEiO04XvkJXxpY=;
        b=RoFmqCKr3GwyBEGKPDZzygVXjPdmmx85mIiS111vsyzN38/XGPMedgpLQLvsjVVBsP
         fxkBbx5BoeXJ4JB0BItvPpL1RQBgdb7dvi0/0tdP/w8nVhmBCdDHaj0odBvuvrM6Wb6v
         hYFDTwKHUoW99hsadG7lnNnAs2yhVf01BVyrH7fbN6G1B0XuoSWvjnU9ElYmeiUR/4yr
         ++IDplXDyUApohQyHaxVudCdaE5whBTYo4l3vSC/K8JoWm1IP2On4cYbsgDZ+zARiPTb
         PVOUL7JpfC49ww3zQAt1hw8wmOM2D2iEhJpBXYV8OykgnPScERKT3T5AWcH9A8bfX8/Y
         tB9A==
X-Forwarded-Encrypted: i=1; AL+hErHMfhMMX84/DU1aZFRFu1THQjafyYIkmD+LJKD6dICZTUws19yjdi5hFN0ELk6ujH1icsGPDef3iA==@kvack.org
X-Gm-Message-State: APuU4Z/icCdbOI6psk7RqE+cqjS1Zx/sWO1qouukrZcNJ/uB8mUoBeQ3
	oFQQLCOMUiGsJ5GG3Lrj105ACsVID617RVhVn05Xde8qmJSWuOKCyWkEm0bZoosx61SN6ZfNKRG
	IDWlCegiEX9wjFIdzIK8tq7gR0WqmcEs=
X-Gm-Gg: AYBFou0zNhFeVeqwiF0WZ2HmweOd6Ao+zkZ7vHtVWKiBSZSv+YpD5olG3k7xm/wWbf2
	eliqqX2akhl4XRKVzWA2PftsZQLXxW49ycbE1em0o62KYWfmOD/lfSatiXHuke6Wuj0gDr7lDSi
	XDHdz16joChX5UbmAmYoU+pT3csG+GB5dJP1/IS7rJowga8dlqB0j3rMBHGQ0zSAu7/jdEUE+Mt
	Ga+R8gl4m+uMQazkIu+m0clhQXLtfSO8c63ZTvmAfpYZ+Kco7CWzIHvtWqP4HKsDcvTLtsm+aPE
	lx4Gh7d4sWhTeZDT+DlmcuehGziLUzYfTP+K8xqzgxnPgxtukeb5rsSosxoe4ZGWhwOWIyXVKVT
	Ic5qHzxxZHayxV5+YVcYGnHGaycUst21TKxxvLbdT4IOgnVhhV7WuVDC/LhfxdsJ3Ynnf/g==
X-Received: by 2002:a05:6402:1f49:b0:6b5:9714:dea8 with SMTP id
 4fb4d7f45d1cf-6b77782dfaamr2361925a12.45.1794411995161; Wed, 11 Nov 2026
 07:46:35 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261109021611.22247-1-hui.zhu@linux.dev>
In-Reply-To: <20261109021611.22247-1-hui.zhu@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 11 Nov 2026 23:45:58 +0800
X-Gm-Features: AclHuK8H6vMQ9aNXuQur-lybZMeytisFbQmvaLjndZEn1wQmQOwgFWQhFSvLZ9c
Message-ID: <CAMgjq7BwQg8b+v18c7efqspDRFFEnuF7K=eVdi1r+MWjG2pkWA@mail.gmail.com>
Subject: Re: [PATCH v3] mm/mglru: fix a no-op lru_gen_clear_refs() call in lru_lazyfree()
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Yu Zhao <yuzhao@google.com>, Barry Song <baohua@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: b1fgfga51hzpgnoc86nfsmiugz6xxb9n
X-Rspam-User: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D471D180005
X-HE-Tag: 1794411996-588441
X-HE-Meta: U2FsdGVkX1+Wu5gnkJiWNmY2o36ebTTjgxhRMh/LGisaO8z5IInbAjs1LjjnHJKz5OaECPQyNddmMUeoElSnBqfXn9tNXwTNlAUre6SOC80Sk6X3yoKPuKEZHRCCGtTCJJRclzPasuMnYmKL0BreiWACXCE49xhmH8OzC0WLmXK9ENJi9TqFSzuwxL12DI4kwX391uaqCavcg0lQj84EFmYe2ugji119XLzYz3XQDe2oOoxeixRE+kl3JWRnLxP8/O+yTQp0ckjxvE8I0aqmUIC5lhUoB2Esjr5fxqGoiNGFEGzY/ljPOxO1j3cgvq8m6mzBJtwp0n59phqFw1XmHdG669EGHruJGgBapGpxVssHAUEFCIzaD8ZpqaPX36HtaQLqsIYilfBcEgH6ZsB1D6ar9pC+8Nz8L6ob0iJjTG98vVDSSpCRir9Wjvd95Snu1TG4KqcmMSO3B411sgJvZtjU/zRerNZBDZOvyecceYgJsOmOrlksjC9cDjcGYQ4PhusjNUmhg9ty47nWcrsXcNeDlHh50bwtQmV2/ee41OiD7k35sZOD8wyEgMdPYqoET5JAlJr91679IyAjWEvbudkfjLGk9M0lDbmVoj2REMuf2pepnYNtsvq6mlr63Yu0tO9DpqkQam1pvpzgw1g/aEiFjNIc/cJibpgZtF2Afrq+VCDi6JFEzd08gsOO42hkhm0MZlmrvC2OJKbnlmKeLW3CNJx5FxgWNFwq8rbx3yOwdW2YTPCsQ1eZ5VycRj0h0T5My4C9M80XQyhkl6WO7IjSuhjAXu0bZsUJY/m1eKyukfvZrRzjSgrKs3ouqyV6/mZMFNEBlFXT8zwM9RPYq2BfWTNgiY8S2F79xAitjYAOFFGCFwoJkVYiF74cxkMYlphHNrkEfZDpt3bWuPU0fsg4f6PcxdpYcqJXNocA+YXmHJfltN+vSTq5my0cUUKDGpkpry6qf9NAloO+vg5
 Dr/RtmMB
 tj2j1FKJnlTBcUhJP93dAYvdwXAqz/a6Bls4E8TQB6qe0SfVct//U779v5ioNHd5IH/r0XJPOK0WLdxgapJNqQjx0SDQrMHXmVLjlouLiFsh+xTAMgzceSm4OHjoxyheglADlG7gAzf2imVzfDVFIed4n/EG4Z6JRTyCXEwsK7W1lpA81gMmZE7gxkvtvEpeWycPfCzCAEsGe9uvpJPd2IVvXQD4EOndpTYyk107zvYa/e4jqlWe15XiO4Z97V+MpT5Wx+VlifcdlPviifxJ1IAI6gcL68j0G9UHmHWi8IP3cp/DyWdnLRreBoBrI9F/8wlDTDe98pApslAEiltjYU/1z8Jv+zWzkKIdB3Omq+gZtqi/GyiH4utfbASgY3PuEcP0XwaQluf/xbsW3LFHUAI+/xccEUB2Go7rxC1eySw1njS/SEa+AR/mqLRUZiQeeFy+I7R2fA3AtPG0aH1vfhWs6QVOBuHDTNgHuZgIOLy8ENkonKUHtQMjlpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 9, 2026 at 10:16=E2=80=AFAM Hui Zhu <hui.zhu@linux.dev> wrote:
>
> From: Hui Zhu <zhuhui@kylinos.cn>
>
> lru_lazyfree() calls lru_gen_clear_refs() after lruvec_del_folio(), but
> lru_gen_del_folio() has already cleared LRU_GEN_MASK, so folio_lru_gen()
> returns -1 and lru_gen_clear_refs() exits at its "gen < 0" check without
> clearing the refs or PG_workingset.
>
> A MADV_FREE folio therefore keeps the state it had before madvise(2),
> even though madvise_free_pte_range() has already cleared the accessed and
> dirty bits of its PTEs.  lru_gen_folio_seq() places it one generation
> younger, and PG_workingset puts it in the last tier, so sort_folio()
> promotes and protects it instead of evicting it and charges it to
> lrugen->protected[], which read_ctrl_pos() uses to balance anon against
> file reclaim.  __folio_inc_gen() clears the refs but not PG_workingset,
> so this repeats every time the folio reaches the oldest generation.  If
> the folio is redirtied first, ttu_anon_lazyfree_folio() keeps it and
> lru_gen_eviction() packs the stale state into the shadow entry, so a
> later refault is promoted to the youngest generation.
>
> Call lru_gen_clear_refs() while the folio is still on the generation
> list, as deactivate_file_folio() and folio_deactivate() already do.  Its
> return value only says whether the folio is in the oldest generation,
> which lru_lazyfree() does not need because it re-adds the folio below.
> Keep folio_clear_referenced() unconditional: the classic LRU needs it,
> and it also covers the folios that lru_gen_clear_refs() skips.
>
> Fixes: cc8ec7be78ff ("mm/mglru: optimize deactivation")
> Cc: stable@vger.kernel.org
> Suggested-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> Reviewed-by: Barry Song <baohua@kernel.org>
> ---
> Changelog:
> v3:
> Add Cc: stable@vger.kernel.org and pick up Barry's Reviewed-by.
> No code change compared to v2.
> Per the thread discussion, the __lru_gen_clear_refs() refactor will be
> sent as a separate cleanup after this fix lands.
> v2:
> Call lru_gen_clear_refs() before lruvec_del_folio() instead of
> open-coding the flag clears; drop the lru_gen_enabled() branch and
> the comment (Barry Song).
>
>  mm/folio.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/mm/folio.c b/mm/folio.c
> index 35e242b48870b..ea3adb6a89d75 100644
> --- a/mm/folio.c
> +++ b/mm/folio.c
> @@ -597,12 +597,10 @@ static void lru_lazyfree(struct lruvec *lruvec, str=
uct folio *folio)
>             folio_test_swapcache(folio) || folio_test_unevictable(folio))
>                 return;
>
> +       lru_gen_clear_refs(folio);
>         lruvec_del_folio(lruvec, folio);
>         folio_clear_active(folio);
> -       if (lru_gen_enabled())
> -               lru_gen_clear_refs(folio);
> -       else
> -               folio_clear_referenced(folio);
> +       folio_clear_referenced(folio);
>         /*
>          * Lazyfree folios are clean anonymous folios.  They have
>          * the swapbacked flag cleared, to distinguish them from normal
> --
> 2.43.0

Reviewed-by: Kairui Song <kasong@tencent.com>

