Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35434C9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 05:26:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDB326B0088; Mon, 28 Sep 2026 01:26:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8D0A6B0093; Mon, 28 Sep 2026 01:26:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7D626B0095; Mon, 28 Sep 2026 01:26:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9807B6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:26:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0444B160B5F
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:26:15 +0000 (UTC)
X-FDA: 85262035152.12.3F33FED
Received: from mail-qk2-f40.google.com (mail-qk2-f40.google.com [74.125.230.232])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0EFDD40006
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:26:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VZOKcxAd;
	spf=pass (imf04.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.232 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790573174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=9uhJQMU9Md0aI6D1ejMKihBiU/dixd7kNMrT0BD86Fg=;
	b=14VkkMP5nnXYLUVKHus3DNwZpc0TphJ6Bh60Ygs2eR54oO5BWyd4Kvfmg4/MKADhCw/K1d
	LeWiqnvII/rtxSqMB+vkpU00Ywy8fFJabmVRTmLVgRPa5AtwPdAdIJ3m1tK9JQIBBa4tmR
	O8IlXTGIZgEAVehrNQbB7o/4yGEfpNM=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VZOKcxAd;
	spf=pass (imf04.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.232 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790573174;
	b=n8Z7/k2JPYwTHI9E0UsYHYHStkE9RlD/bSXaeK3KGRL5fbDqx1lLFEQ2pjurgHuL3tznFt
	3x9f6dryaQyfeW5oLDhD0hEC2hdq8gIuPc810PAbzgTD7uyJTXEv8Xv5xp0Vd5GoebU/sv
	jtot2Q5jTbitYse5C1a3jM7CWqSplhA=
Received: by mail-qk2-f40.google.com with SMTP id af79cd13be357-93c5b166b8fso141480985a.0
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 22:26:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790573173; cv=none;
        d=google.com; s=arc-20260327;
        b=FrFEyhl/t3lGO8LiLQxD1FJTIVnw6PhEWW+Bvum8jH1vSSMSLo1v2pdB/rJt/NXFfw
         K5F8n3Ij/xZtk/dMecelaQftY/iPlCZ7TSNwG/yTmsgxy4j3qByLieXMK0mqkXwfRLn/
         Yi+YYIdMg+P+hsOCMKObz9LpAbicsVghE/sLBnMwaPFESMEX1DGbjpg0RibOaD8tz40N
         4BY5XaPQJm0CZBhie3SJB5VquVzwlvlHLaEIjt7+doRzlG9aYP92vhSJJddpp2jLvf92
         X+Eo1rqW7dAEnGbn1n1wl5iqF+3srTI0E+5cAcFMfOso86LkBjoTs6FjqnZCAtaHH4tT
         8VCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:in-reply-to:from
         :dkim-signature;
        bh=9uhJQMU9Md0aI6D1ejMKihBiU/dixd7kNMrT0BD86Fg=;
        fh=JLxPeZg3KP/HY7RUO3xbtJ1cl6JeqECdXlUQ+CjjAs4=;
        b=N/e02bbFAy8WunHt97WDvUnKc24IPVk5dZGrVDCNq8Na6uRh8z/IgHNqcU83Plu96E
         /3fe0gD8dPfW4Huj8gI1FB6atgHJ20hcknwkrY89/YkCWKA7b1kVx/AV+B/2cRyHPdUI
         LDc4JLRsFkFIBYWYMUDIzK3r088EmiOmYSNapOuj2n6XlIrthT50dp+fSu+XqfwVrvuz
         0GjvGuKm3EZoK6oq30wf2PXlB/EbNQAvfHx1X8jU0OURGfTV8ZLkqJsEhZRR30w4dMkP
         zQZEvWGIgPr8BZzqgTMBnv6UJnOUwS9zCDeVwLfpn/pkV6xYl3wCoq5XmmLn6Ok+gZ/S
         OZVg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790573173; x=1791177973; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9uhJQMU9Md0aI6D1ejMKihBiU/dixd7kNMrT0BD86Fg=;
        b=VZOKcxAdOrdi0Bd9R66YfWuAaaJyLYGwMYW63gVV18To/6nVFf6CLESCNd+rf8mZD3
         p0dgwuC1tHCNqMPFvhWH2Jz365O4ohIfwmKlnPpONp7R7nhEax+OhHb713UcFHEXMyqD
         UTrHhJJOBMnvYmhiGO/Keiv7KkmbUdMqF2CPJu2ufrxbtxLSkAb4OFHcBg5fsnrgNg3Q
         1xpLHEW1a2xRpJTZnqLm6WjNYT92e/FqXqkB73kJN3tg+zvPvWJyglydV6EdilYwbLeo
         RKH2adoiHnJuaP0QlZ0LMdE/11yASyuxedX9+jSMJ6idPCMYvbqjKpm5vqszQLsRyy0M
         G4CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790573173; x=1791177973;
        h=content-type:cc:to:subject:message-id:date:mime-version:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=9uhJQMU9Md0aI6D1ejMKihBiU/dixd7kNMrT0BD86Fg=;
        b=pSodrypWoh1PUfUKtYdbri1plCzvOLZD6Cuw8Jw9V70PBv6nAYvHLR4LYuluQGsldY
         4tsyRvSiVjfd7otQCi+JVr5GeuliX9+Xd0QXvGptmoqkXAyOC8jMWmnX8u4XTWubPowi
         3wgrZNHkUB6ybjkt9OuS7Gj5AxlZf1TDrkowcMMAyv3PJ1MPEsdtYb9OqzPgVFgGYKcw
         BBTAnNDsUNAmPSZGVgXU2miCZtCMnbgNG27mKkmGg1a0TlDJu9lPLfjAGm5mmoEqsYvh
         dM4BdmVDkB8PwoIfWnOGbbSt/IwLjoG4lSpeZkvYFP3ZbdrWdPRHvxqtcXwWi1hFplBT
         U/QA==
X-Forwarded-Encrypted: i=1; AKwUvBwvnpwXwripDraXCY+EbL49XFP7L4SPgmaeeYK1Jr3AzIN446NwxlYi87DwAUVjRIMC1fdJfqAFpA==@kvack.org
X-Gm-Message-State: AFq9FYJRXqbrIve1MdKCH+QvvnJTPMfKsxOsvQtrAfwpua2TmsIcodWL
	gZjCtSnBUwf+cbIk+h8iaFr2HapNaYTdU/bH88SolnAJJlJ/t5ovID0Xusfe44PA8US5BG66woA
	Wo7D38UFF/NwH3xmqF3RGTgBFDrG79PDi2wRxWUYJ
X-Gm-Gg: AYBFou0numUxBMHPy4vnLmlT26jzPJdHSSqeHowfQnF1i9Mu6xswTNp5k0u/nq9Bw7W
	LSdC7u+iBchMnEdzCuJWWbC1UMBDJFI1kPs8YQPqHhs6CFNTCshbDaNyImkrZw3ljr09yfessQ/
	8l+2qmt0z84Bb452Nu2NJGhU8fTvIcNpqvNkvFGN6RRS+5msYDO9uUpi7JwUruDlBRg5asr14Do
	pm8yndx6uWSZbddZHulJC2K9QMnaLUBqzWQ6Wf7AePEIHbLy/YlVgUNVODB3i8ULalHmyalcAk3
	pkD1MBtYHnw5P8uj1fXePkTS/UH0+OyNOciPgcEL2ShWYFSsTHv7QfCsaxuUoCb68UYWbYModyV
	RRkMGxNO39A==
X-Received: by 2002:a05:6214:27c1:b0:90e:8dcc:4e5 with SMTP id
 6a1803df08f44-9142f919107mr186704706d6.28.1790573172597; Sun, 27 Sep 2026
 22:26:12 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 27 Sep 2026 22:26:11 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 27 Sep 2026 22:26:11 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260428113037.88766-2-enderaoelyther@gmail.com> (message from
 Zhao Li on Tue, 28 Apr 2026 19:30:38 +0800)
MIME-Version: 1.0
Date: Sun, 27 Sep 2026 22:26:11 -0700
X-Gm-Features: AclHuK8teF1_hnBMYASoAggcWTeG1bGk-jNppBGAEy7BhwDUpekXIrCo_Z7K6QQ
Message-ID: <CAEvNRgEh9_cMQmiNLXumFLt7JtFy0VNNCNB=1mY71bz9JzUxtQ@mail.gmail.com>
Subject: Re: [PATCH v3] mm/hugetlb: fix max-only subpool accounting on
 alloc_hugetlb_folio failure
To: Zhao Li <enderaoelyther@gmail.com>
Cc: akpm@linux-foundation.org, mawupeng1@huawei.com, muchun.song@linux.dev, 
	osalvador@suse.de, david@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Karl Mehltretter <kmehltretter@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0EFDD40006
X-Rspam-User: 
X-Stat-Signature: 14xmbybqtukz3yzekkb8j9awisiaaesw
X-HE-Tag: 1790573173-336
X-HE-Meta: U2FsdGVkX18pp6FzVjj3ZL+AfjZhr0sQr4UG1V3NEcgHUhakmwnA8T5I/D2wKaJLqvhcAajVe79BSwn8fIQt5IQO95fFpnXqrNLQPbDUgdE70bxgaYbI/06KUi4HHKNO3wbyI9jRQyr+S4hMGMq9oM13ymdhrQA6Yf/4oi+GQ4mWJ7YVfYQramgGnKFQGllBGMqK5ECI0UvvZamFW4DAJ5pmW9RWpoKNmohtJs/kKNaxWbFjeSDY77wPx8xmSgwBIiPhS2zYlZhfhz7i0IMSgVrNtpiwO9JnUl9yF1P/cqEpMyJM9cF2di0br+FqXPx9hkZiGA5LwxZ3PRe4LM9rWB4pk0k15gWSeVhKuO4oYZF2eEnYIkgiid3FCrGD4y1oexEByZ+njslW4RMLwy/dhL6Bizktst64uOS5JGVK01nRxoVzCFXUJQbXMrsS1KEmUHzVJiw48GYBs3/IqeXwLSgkn3Ja+vpmsQUJFeBrTVbpbzWmt0t22m2xi926gYWiZ74vPn40C5C0ZWpohEnaysvHu1jme08Vt8ffV3s++nuFQxy6qBJPaRg4DGIygK/+W8vM1EuaiZ2W3S0aO0CMi/wAG67r54muJNrM8KItAyXJRn8Pz2y9yAcdzgRbrPl/f5XVejonZHqA/l5sjd6kyolTaj7GIHizWTDguLs3lba4z4gHID4VbDSiJ7r7H5kHp4qmRw5zof49xkaV1Mvs7YDMiWHoLOBHv1r798T1aXzBhdK0EeGmKPMNh40PVWeCnI6RB1YRL2m7ZU1NKCKFcfyGhR8gBoPGJkUrxgqT2qKg50ZwECjp6r/WkTm8tJCDJFApjcCYOZV4Mz/wC2iyCFA1ZRplMkFx6YlGLLp4j83gqn1EBPi1wghiknPpMjBT7d/ECKLC2lJk4BMN7xAqZH0tkte533bM+axOHHAc6uwRKszgi37McRlrI6jEHdHdu51rOqGrzuZ7+dKq4HP
 eyS4YgAr
 cxnmOHcApbzkBBmr1AhhT7dKE0gcCsT4k9HgWdljK9F5tE3XIeH5iOljBS5pyHNJnfq2kYZkJz96mWOACfB8dxuEnMc0pqHPbQZL3kz2/vXUgGIqMpN+4J3AN0glIx77mhl0n2EAaKhxTs0UCdHlwVkJRw2srmPjEIuROJ3Us/LkqtknlF94oMEo1vsTjL7Rz+rUCqaE/tmagX81IBLdpeuN/xdxnt4aNJ0aKNZw6CDA3hdvOsghvL8U40UHbHiIFRLcOkUjtoj7JV9eASTiVAgmFpKjCmQlql3sUiVkRBcoyrwDBSvW/0+dE8As783lCX7Qtxdh769aFtoMDh5E9kmtFnIE6q4lKHndy/iZFUGykCtpicVfvhpoSk4Rdec51yCcW07x9X07NY2SBit9phDkXCjSBBN56ZN0/89JhRKaYbf147DMZVhIg3bsudaWyKxh9/jKJqBn31Zs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Zhao Li <enderaoelyther@gmail.com> writes:

> alloc_hugetlb_folio() calls hugepage_subpool_get_pages() when map_chg
> is set.  For a subpool with max_hpages != -1, that bumps used_hpages
> regardless of whether it returns gbl_chg = 0 (rsv slot consumed) or
> gbl_chg > 0 (used_hpages slot only).  If the allocation later fails
> before a folio is returned, the unwind must undo the used_hpages
> bump.  The old cleanup only ran for !gbl_chg, leaking used_hpages on
> the gbl_chg > 0 path.
>
> For gbl_chg > 0 on max-only subpools (max_hpages != -1, min_hpages
> == -1), hugepage_subpool_get_pages() took only a speculative
> used_hpages slot.  Drop that slot directly under spool->lock.  In
> that configuration hugepage_subpool_put_pages() cannot restore
> rsv_hpages, so the direct decrement is the exact inverse and is
> race-free against concurrent puts.  This matches the used_hpages-only
> part of hugetlb_reserve_pages()'s out_put_pages cleanup, but
> restricts it to the max-only case where no rsv_hpages restoration is
> possible.
>
> Mounts with min_hpages != -1 are left unchanged for now.  v2's
> approach (hugepage_subpool_put_pages() + h->resv_huge_pages++ to
> back a restored rsv_hpages slot) double-counts global backing under
> concurrent free_huge_folio() and creates phantom reservations under
> concurrent hugetlb_unreserve_pages().  Safe cleanup of that quadrant
> needs a coordinated fix across multiple call sites.
>
> Reproduced on size=20M hugetlbfs with the faulting task in a hugetlb
> cgroup whose limit is exceeded.  Vanilla leaks 6/8 hugepages of
> subpool quota; this patch leaks 0/8.  Verified under QEMU.
>
> Fixes: a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
> Cc: stable@vger.kernel.org # v6.15+
> Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
> ---
> Changes in v3:
> - Replace v2's hugepage_subpool_put_pages() + h->resv_huge_pages++ on
>   the gbl_chg > 0 branch with a direct used_hpages-- under spool->lock.
> - Restrict the cleanup to (max_hpages != -1, min_hpages == -1) where
>   the direct decrement is the exact inverse of the speculative bump.
>
> Changes in v2:
> - Skip the gbl_chg > 0 cleanup when max_hpages is unset.
> - Add hugepage_subpool_put_pages() + h->resv_huge_pages++ on the
>   gbl_chg > 0 branch.
>
>  mm/hugetlb.c | 25 ++++++++++++++++++-------
>  1 file changed, 18 insertions(+), 7 deletions(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index f24bf49be047e..cfdeaf6394c5b 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3025,13 +3025,24 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>  		hugetlb_cgroup_uncharge_cgroup_rsvd(idx, pages_per_huge_page(h),
>  						    h_cg);
>  out_subpool_put:
> -	/*
> -	 * put page to subpool iff the quota of subpool's rsv_hpages is used
> -	 * during hugepage_subpool_get_pages.
> -	 */
> -	if (map_chg && !gbl_chg) {
> -		gbl_reserve = hugepage_subpool_put_pages(spool, 1);
> -		hugetlb_acct_memory(h, -gbl_reserve);
> +	if (map_chg) {
> +		if (!gbl_chg) {
> +			/* Full inverse when subpool_get_pages() consumed rsv_hpages. */
> +			gbl_reserve = hugepage_subpool_put_pages(spool, 1);
> +			hugetlb_acct_memory(h, -gbl_reserve);
> +		} else if (gbl_chg > 0 && spool && spool->min_hpages == -1 &&
> +			   spool->max_hpages != -1) {
> +			unsigned long flags;
> +
> +			/*
> +			 * For max-only subpools, subpool_get_pages() took only a
> +			 * speculative used_hpages slot. Drop that slot directly.
> +			 */
> +			spin_lock_irqsave(&spool->lock, flags);
> +			if (spool->used_hpages > 0)
> +				spool->used_hpages--;
> +			unlock_or_release_subpool(spool, flags);
> +		}
>  	}
>
>
> --
> 2.50.1 (Apple Git-155)

This fixes out_subpool_put in alloc_hugetlb_folio() on a mount that
specifies max_size only, and does not introduce any further bugs AFAICT.

Tested-by: Ackerley Tng <ackerleytng@google.com>

Further details at [1].

[1] https://lore.kernel.org/all/CAEvNRgHQLifmcD1NO6cd7EVcCiQb6gJgNUo4HkFhZAvzuwMq0w@mail.gmail.com/

