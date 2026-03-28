Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73F3210BA423
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 19:20:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B7726B008C; Sat, 28 Mar 2026 15:20:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98F316B0095; Sat, 28 Mar 2026 15:20:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A4876B0096; Sat, 28 Mar 2026 15:20:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 765466B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 15:20:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 272451B6E14
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:20:47 +0000 (UTC)
X-FDA: 84596438934.01.DFA4E87
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5D7781A000A
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:20:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=c1NTtrRW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774725645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6eOMEVK0bdwhht/5qtx+gcLztltfoVY6LX/uhJq+m1s=;
	b=GkMdxrXGrj5eozC1oOkroUUJdk7QlX1tNOgZx92/jW4E0F/zcqHn7I6RFScEDO+LXjOBFw
	xH3UHdHiyzgBgo2iAIIDTLPP/E14kD3AeLl1CeTxjzbXudW/V2W3fLsFoOX4WpTD7Rni3y
	X+59nu1k9UbRoy1BpuGoavLa09094mI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774725645; a=rsa-sha256;
	cv=pass;
	b=kJkXuWB77kPxEVsDDBS5vTk7WD4/7AXdqTbThtcpjGHxYZfxCnwA4MM+gUEGVzQvd7u5ny
	ZhXjr0++C368euqxEHauPbUerf6nmcbULhw7xxG6yVvyHtK3D83PnSbxFxqFU8vc0jE1Jw
	nh0zcQRmFE6zxNeYUttoLPx/tIPnTvQ=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=c1NTtrRW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-509062d829dso438661cf.1
        for <linux-mm@kvack.org>; Sat, 28 Mar 2026 12:20:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774725644; cv=none;
        d=google.com; s=arc-20240605;
        b=G3EoYe68JKodoW2K0Gsu27YLjZ9zEIFwFGqTliIesaZ//RLkyeHmHtAFX+Fi//H2mV
         xjX8scrbvhWPQO4zQfu5fjk+zATMB5u+d34zy6XXM74+pXlRzp1QRsZUROWZp5LQbJ+v
         FHcXnZ2gPBMJ8ZQjNgh+qVNV/vM3JpLCO69uXchoLruAin7kysELZMtEAjLBRX1m7ih+
         20xO4GLnS3Zh7uUEisqv3dwNfACZpirvQ6DES2+AlAz+SOJD4dTQX+UNVZb4/UEy+Tw0
         BEOoPk2/fDZNV0ix7azgWPCeIa0VCE3wPGd7XHxt+l1uEn0ftwsge8LojUZzwzI9wAIR
         48GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6eOMEVK0bdwhht/5qtx+gcLztltfoVY6LX/uhJq+m1s=;
        fh=PMSgvhNDFY74qjPLeuJfjO0Pu09nzB/oEmyc6SBUpJI=;
        b=YKwMjkQb6bhEEwELPv7FUamzhWRqn53ljUZi3IbISpt1NakzFZp/V/aOcB+a4ZJay7
         nLpfYQr4ehDJzolkhjQb948SSHu8wo212H5klj7eudbgUslvvswBKDVuVwCgyUJaamNi
         TiVV9LRxQ3PtjIEAHYcjv52TKuqaLVcfzM+jbNdQD8dC6Mv5UGFeCkir0G+kba8uH90B
         +pyj4Yhjy3PupXG8XrDdl8Gwr6tZqXZfBE69+rHVb2zXwkWiP59Asjn4s1KC0bms9ZWr
         oNn87mh28sIl6VHP9yF/7UzN/V1PEcnUyzEzPheEvNe38zv/I5q2YUZr0kU54DHgo5Uu
         6XyQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774725644; x=1775330444; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6eOMEVK0bdwhht/5qtx+gcLztltfoVY6LX/uhJq+m1s=;
        b=c1NTtrRW58x/FzTDKiDzZI0eIH7ZJp6kshLB+JV639l1xGkD8SSjeOYs7fEzOGrFy0
         yhcSSYw8Y7id1XjrflyO87mkzY5zAx9//j4NQTI4l/uYncovUbPM9vnZ8Gg7m2WAnh36
         1iR5kyc/t0zm4pfNobO5C/Gf8LaVAw1dD8AEZl9t4X1n7m8elkW7yCAxk6DCPE7ixocR
         ooNCwo4uB/0yyeit97DD1AdwZjtVrjBxcTlSDJLywiVptHq5A04ENtVJs2jdDpi818Av
         Q3oCJ9hVPxHT2Dt9Ycg5sMFLS/pThdzYAjhVIQjZu9227uz6Hg4iGK7YppToUicTaFi9
         pfUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774725644; x=1775330444;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6eOMEVK0bdwhht/5qtx+gcLztltfoVY6LX/uhJq+m1s=;
        b=E4kjBOhAPwl4kU2r+tMwmXfpnqXFTClDkpTr9PBMNQLz5bien+S40l7IsorG++a7+s
         hlQzoF0XESJHzlByni4xYEutF0JtxUlC19Qvnd34143BxD/pw9EQLg8EbXcI1ebU/wUy
         rl6qxvndcyckXMHp+InfMM7bNd9SZUgo0guBTF0KINyWShOdRYjWs51LL/mhwHtR/Ufy
         QbLk63CnoBa6ktYTtfiYw8FLwShW4ceBKah267VrGI9dE0Fah6mmO+6jE6k65UVNUt1p
         44DWaQbrwxcejjT0E8491OucmuS85MLwMBIPot4SyTVMRdo5vVWrljtBLLsUZKRyRB2u
         gVfA==
X-Forwarded-Encrypted: i=1; AJvYcCXfF1WIPMjmwHeFjNq+cM7hBtF/Bx0sg5LUWc76k6XaHwUqtmckLkW2jvX/7DTR/4BHvcrNeeWSUg==@kvack.org
X-Gm-Message-State: AOJu0YxnPZFlXQz6RAw7BKLGKiKNWnEnxIW+fLoIJ1XhM5SXQQ5dyO7j
	WzUReWMij1iVO50KlSLP3wJgZ/g3CeBGsA/EgLRx3rp8GpcssiXPbCAeMCwr90pIGM8+htUeucH
	28Mwr8v7tp/tS1+Xu2AyBavWuwAajkUss/Dy2Ztrm
X-Gm-Gg: ATEYQzx9I7X/Bw8o33SKFt5xDfJffkGh1WHE20XyMCYK6zFApF9Xa6VgwHMlEyyPMpf
	H7wHS8DK6L1FJTZGUv7kZsvt6QYpp2aFYhyFNG9wU2oVZMToZdXSk96nMFt1JuFAq54xYEcNZWk
	RMFsZA3l+cl/SeNBQh81pXHAeZXCuI7PHU/9t9OPf6C5iRrtLeguD+mh+eCcU9qN44l7o709o/L
	Ob6ru28xK4vyyW1h0vmDV3rmolnbPlh2rcHePlg9RLR1AWOy874H7DFrerWIAmPdxDdFrb0QFfB
	kRVUFtlORA8CNWQc
X-Received: by 2002:ac8:7f90:0:b0:507:35b2:6b9 with SMTP id
 d75a77b69052e-50bb3d40d81mr10237821cf.7.1774725643909; Sat, 28 Mar 2026
 12:20:43 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1774029655.git.ljs@kernel.org> <6c4db67952f5529da4db102a6149b9050b5dda4e.1774029655.git.ljs@kernel.org>
 <ce065f40-38a6-4601-845a-78021af80f04@linux.alibaba.com>
In-Reply-To: <ce065f40-38a6-4601-845a-78021af80f04@linux.alibaba.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 28 Mar 2026 12:20:33 -0700
X-Gm-Features: AQROBzAzePkeGMKplAF_r9bfI103zLkTA57Mnfe3m0ONDiP20z6QOCSUr8PJ7TQ
Message-ID: <CAJuCfpFM7t33uEyMcLYuq0UTuWwriXhaOf4oOg7y_h52e3+J4w@mail.gmail.com>
Subject: Re: [PATCH v3 10/13] mm/huge_memory: separate out the folio part of zap_huge_pmd()
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5D7781A000A
X-Stat-Signature: tj5n9iguxgur9u6w74o9wh59xzb14jdo
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774725645-769152
X-HE-Meta: U2FsdGVkX1++01ULuQJovX/gIQtrOjEwfNmjhIREkLiKKRpGHmGOEoXEjNmJM18q4i+n34hrSuT+DTYbnrBfLQGasMIQ5Xas1a3TlMITPYKB950BTRir/ebErUl/EYp9isqyZWoczx5IVYfYGad52HbxZpewG8XLopPTwHm01uUOr4CbnVfJb1MhN3oWyXzg7O8t7IJCk4PwjwdIlNp6Y8C/ioQtH7j+Ue5TCAOcaxO5JEpyZrx5gLs1wa9TyV5yDNDh7Wt2vCKXRir694FNf4TuGSLPCA40RSGBMI0yLtkYPEEAKhpfhWcq1Gtq7ZbA66yoFR11N8/i0vFijeJFAblLRmrUfxL2o3TNd9Jb6fb7uLuikQBqFD+FCqBaDvRBdU1LKpvBpA9ums4lDMtj1L5ElXbzLBTY0OGVxkBrmVd5TSSG1i9dyD/+zJObd3hrcD2zxFBfDfsC/uRME3prQqItxMt+4JGuSqZhViHtXAmmxvgsfbQZOsIJ6+JhtOWM1tdb9uBkT2Ki7lz2y+Lj01Sru+FPrEY1WfyP6b0YT98hYoy/Baftq30mvZJ04+wGiMPjqoJ0kEhO3vPHPl9uLxvr5BZm2aMjo96LenzQmlS9u8NMPKi3ZO6GDxCwsgvssi6JT3WIYMayavcBnhvPDrNCjc8QJyUHLnfJciRZm1bsVChxJdxfuf6q9gpkiP8uHXbfLIbHzjoDwfvPQWGdqgblEfRG2weQatUY7lilkhA9H4qJzdZWBE1uwI/2g4L4uGW7fIfuOPBbwBgaJT4ZvSLq5BWrfh3c032Bpj3XC9hHPinQbhP0sPgnt5lbthx+rZWM2Bo9mTMeXXocc+9HdFRSv0ixv9RYAtNnf6cUxh5ywqGO9f0cLQF0N5TM50mIK6CnsyWNUawbr6O3ioNENl66kk5dFxg2arRofyqTNWl7mnJnkkEluUppzmG+bP7/M47lqOLfzcS+3Nx+tag
 SaBy+vMW
 O4mCK/kh/+AYEl/2ev18QYOE0izrVhPJYWNsJYZZ0MnXOPW+ZZs+r8Uri8cFWHOAhuJ1f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 10:59=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 3/21/26 2:07 AM, Lorenzo Stoakes (Oracle) wrote:
> > Place the part of the logic that manipulates counters and possibly upda=
tes
> > the accessed bit of the folio into its own function to make zap_huge_pm=
d()
> > more readable.
> >
> > Also rename flush_needed to is_present as we only require a flush for
> > present entries.
> >
> > Additionally add comments as to why we're doing what we're doing with
> > respect to softleaf entries.
> >
> > This also lays the ground for further refactoring.
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > ---
> >   mm/huge_memory.c | 61 +++++++++++++++++++++++++++--------------------=
-
> >   1 file changed, 35 insertions(+), 26 deletions(-)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 673d0c4734ad..9ddf38d68406 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -2325,6 +2325,37 @@ static inline void zap_deposited_table(struct mm=
_struct *mm, pmd_t *pmd)
> >       mm_dec_nr_ptes(mm);
> >   }
> >
> > +static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_st=
ruct *vma,
> > +             pmd_t pmdval, struct folio *folio, bool is_present,
> > +             bool *has_deposit)
> > +{
> > +     const bool is_device_private =3D folio_is_device_private(folio);
> > +
> > +     /* Present and device private folios are rmappable. */
> > +     if (is_present || is_device_private)
> > +             folio_remove_rmap_pmd(folio, &folio->page, vma);
> > +
> > +     if (folio_test_anon(folio)) {
> > +             *has_deposit =3D true;
> > +             add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);
> > +     } else {
> > +             add_mm_counter(mm, mm_counter_file(folio),
> > +                            -HPAGE_PMD_NR);
> > +
> > +             /*
> > +              * Use flush_needed to indicate whether the PMD entry
> > +              * is present, instead of checking pmd_present() again.
> > +              */
> > +             if (is_present && pmd_young(pmdval) &&
> > +                 likely(vma_has_recency(vma)))
> > +                     folio_mark_accessed(folio);
>
> Nit: these comments were added by me to explain why 'flush_needed' was
> used:). Since it has been renamed to the more readable 'is_present',
> these comments are now redundant and can be removed.
>
> With that,
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

