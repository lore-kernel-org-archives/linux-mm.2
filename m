Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A9B3CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 05:58:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE9798E00E1; Tue, 12 Aug 2025 01:58:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B99DD8E00BE; Tue, 12 Aug 2025 01:58:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A613F8E00E1; Tue, 12 Aug 2025 01:58:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8E8498E00BE
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:58:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 429CC1A0194
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:58:41 +0000 (UTC)
X-FDA: 83767051242.27.0068C88
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 303B41C0005
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:58:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rHPm74vQ;
	spf=pass (imf20.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754978319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zjLRO9jlztFg7Xlmb6d+mGgiFh1eSfbawN7/i0rsBCU=;
	b=YjZJ4/5vo8w8vd16UMT4DVZTXdYRkkeKIVeKRJxHZ3skcFT5SXovTzR0mIhx2pJreNgYMo
	X4OJXWP9UJIpHoGxEhJ3TdiSI0JJn3ywINlL8H06cMyvgc+HP+70pAGZDj+uF/C75U2vpX
	a6RySAiVPL04qU2y8xtJpWr8PYRIa9E=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rHPm74vQ;
	spf=pass (imf20.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754978319; a=rsa-sha256;
	cv=none;
	b=m6Pkz98g1rtKtnjZmN8n4qCrgN3TsSHwb/7so88h79FZCpQ9K2ciV/p0sl7ojqB53ogr3H
	F120zVX6N6/tTOTQYolVQbS2/hzJu8ZB7nSbG/L4h2uBV3mS3Bs4nPI7GDZg50uvqpdSBd
	LlmHvio6fm3XWz/+cj80RDEz/cgsDho=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BF24445FAB
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:58:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99160C4CEF8
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754978317;
	bh=5/IY6DIk3onVp/qtCNMehb2TxY8eCwzuw7RtOQJuQas=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=rHPm74vQQP6+4xv5GKUq+Yid8PFLFpE16C1OzihWakyVIsdQph7mlcJiR6GcoBqk5
	 unkTOREJE5OJ5z+/G1XWSShuFgX3q4eSev7xu/AlnyW0rHpLpo6/3Du5yF1VzkQiyO
	 ZAdPPWGmBjaK3PrO6WnQT1Dueluf7HzeY02QuiWxZ7mTs7gnbZpkQeCKN2orsFbQYb
	 gXdcro4Z22fkTxbrO6JUxG8Jqr914Zl9oq4abyyNE/AERslF/WO8JgBifScTD01rj7
	 6qtDt1AW2bwByXJJ6/78BHVJgWPkvpQMgJjpeTkQy5n32U52/cvA74At3FQTT3Z+5G
	 d+NuoioC1oU8Q==
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-71c06bb7470so27268027b3.3
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 22:58:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV/Uwu5HUFbivduCn1R8ShbatWxfqP+QkdxzJqsgcqpaqt2FbUgvxOn+imVCe5Th2F3oKphxUd/UA==@kvack.org
X-Gm-Message-State: AOJu0YyxQuOQ5o1J57kAD+QUZTOyMJWMziGgqSwtsvEGMm5Rh3B9b9SL
	HYa4EThTS3SqrmY3wCCq2GTZD4WBy6yqpEauLhNBtAnREx8gEt7PN0cIr5/1JdFaF+6x0ElFES3
	3T15Vxk3smkox7mADZKviigDrFNOMjCFBUyK7xTuyHw==
X-Google-Smtp-Source: AGHT+IHxPmqLpRi7tVGLNW6BM10nSnUTAR4Hfu96ndWi0UBHb9Z6BoUVpa9fxWCcvwq63GZGNjOqRrIM8H10gWjMOgE=
X-Received: by 2002:a05:690c:4d08:b0:71c:1754:26a7 with SMTP id
 00721157ae682-71c42a7b6fdmr27964767b3.32.1754978316845; Mon, 11 Aug 2025
 22:58:36 -0700 (PDT)
MIME-Version: 1.0
References: <20250808-swap-scan-list-v2-1-d50e4758ecee@kernel.org> <CAMgjq7DnniGUdpQQA0YF+LuMuL9+FCLQJP2Q04G_Hsd1sztv9A@mail.gmail.com>
In-Reply-To: <CAMgjq7DnniGUdpQQA0YF+LuMuL9+FCLQJP2Q04G_Hsd1sztv9A@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 11 Aug 2025 22:58:25 -0700
X-Gmail-Original-Message-ID: <CACePvbV65tjGnWr_zFs5ZHoAX2x=As=rMrwJKCho6c5-Dw7qaA@mail.gmail.com>
X-Gm-Features: Ac12FXxqc0syoLGdo5ljlvqqxbaJSAIDobIKRfOTmrg0MugEHBH3FWYc6Za-Hmk
Message-ID: <CACePvbV65tjGnWr_zFs5ZHoAX2x=As=rMrwJKCho6c5-Dw7qaA@mail.gmail.com>
Subject: Re: [PATCH v2] mm/swapfile.c: introduce function alloc_swap_scan_list()
To: Kairui Song <ryncsn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fr1eay3hqthna6qhehhskeg61ymdnyfu
X-Rspam-User: 
X-Rspamd-Queue-Id: 303B41C0005
X-Rspamd-Server: rspam01
X-HE-Tag: 1754978318-125223
X-HE-Meta: U2FsdGVkX19NzQV0p1Gbiv7j8H4vl0UEyhvI8vvxbz/9fKlrq4yEvPIVUibKkwe1NbgCyajQ8H6ZG+QZwEVcjZEiEv0PFXHMKXOw9zSx4PkMvCy2e8/noUZ0oYe6/ybaiEXDJh+i9IBceMa8yTueZSrQEXtocnDIu5ogXFWG/l8ecIDsg2/LO9zbdYOmL0EYloDxNGtHAgPnUOlYby0OYwzbsM1aNCRjAWpYsEDehNVvQXnNXXiRq5WgLlh3W6b77hIOTC9DYsjYTq3CnKoeqvCG85LRsg4+locvKc7IEdkC5WhTQZ3Jq/OHT7Tg3MCPHDlgw6uHvWa+GqzIArHfLCSzYKIO0UnkbIx99Azs0H2l2bBitF8apy4XXMNPxUvzggrGsn52VfYZyCjTngt6RZJvtmm4MyKSVBARNSiJSY7rLIvKQJsJJB83wS4Att3Wr1kr5VZT0of+evsJANeuAyNnupl1q5sm0JYnFUexh6Sk3e97jpKyAnamoVI187NAK6IdahbTQwe4EvjbiVzp551Mztko2sYuAJrA8DnhOuUspzNmf9bmm3Y3d/9Hwb3q3c+p09eezf11uy8K06fO8FTRlIKCI5apDzkoK5YpP1OPPrtutrDoT10nPdUvrKraFFjf8kowPO9AbHvTh3TnE96nr7hBJnYB/jUnbKvVzcUZkG+6ttMsHOsw//pyLhO3uomvQAipt15+JGLJeiWZRq7vFMPEJyaTT/XH1L3wcG1/ibLIVFNX5CXbhqjJKAWmXIeov0k0klJ3CAsLt9BKUybkWcMeS3kHbL5eFXEhdBViiLeBluzdiCpRZlzZClrL2OfYDL4F3UZs7BnMHbPq7lUnfqDkZS+eRVw6IMts1tsrxgdZS6nmjEfq2OXSl4Bv20LLHHkkV1hdk5c8luIxt03o8Ec27na8HhmivqNVcIFRVcgYf/bVldFTfqVvHqAn+GTgOHqmkrU/t8hxlWA
 580s6YWO
 xrsWOK9Lxk3V+lAbqfN50SEeeAkvQaaH6ITrkHblDeTWmGV7xrtKv4IjrFlmn1X93JLE+oJGPN+IB4TGUud3bH5PvmpBb/Uz45Jb/WQMQTZL0ANIP/8qR515eZyLu4i3sUfy3zDGH7msZ20R3ixVRR/lr+Fhw3bcp6bkOiZgHFciu5lRw03uGNgntIQnWKwgAk0nu/YBuGIyeKf0jt5rQXcvxsEDg93NdpUyCEk3A+h3xWsKY31MRZRisZdFH7FGhjkZZtVoLZx6kk0JIzOH15PWpNpqxACgmRMG45fZpUsAqnif4eqAqkxFLzaTUDXCV9ypLDmEFPPq8fpFlwceBWTPN9av1mRA300n0GNqy9JJRByQz/Kb6vdXVJA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 8, 2025 at 12:52=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Fri, Aug 8, 2025 at 3:48=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote=
:
> >
> > This the alloc_swap_scan_list() will scan the whole list or the first
> > cluster.
>
> Hi Chris,
>
> This sentence reads strange to me, but English is not my native
> language so I'm not very sure about it.

Ack, my bad, let me rephrase it.
>
> >
> > This reduces the repeat patterns of isolating a cluster then scanning
> > that cluster. As a result, cluster_alloc_swap_entry() is shorter and sh=
allower.
> >
> > No functional change.
> >
> > Signed-off-by: Chris Li <chrisl@kernel.org>
> > ---
> > This patch goes on top of Kairui's swap improve cluster scan series:
> > https://lore.kernel.org/linux-mm/20250806161748.76651-1-ryncsn@gmail.co=
m/
> > ---
> > Changes in v2:
> > - Adjust change base on Andrew's feedback on int type and break out of
> >   loop.
> > - Link to v1: https://lore.kernel.org/r/20250806-swap-scan-list-v1-1-a5=
fe2d9340a2@kernel.org
> > ---
> >  mm/swapfile.c | 86 ++++++++++++++++++++++++++++++++-------------------=
--------
> >  1 file changed, 47 insertions(+), 39 deletions(-)
> >
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 4a0cf4fb348d..f26678d68874 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -820,6 +820,29 @@ static unsigned int alloc_swap_scan_cluster(struct=
 swap_info_struct *si,
> >         return found;
> >  }
> >
> > +static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
> > +                                        struct list_head *list,
> > +                                        unsigned int order,
> > +                                        unsigned char usage,
> > +                                        bool scan_all)
> > +{
> > +       unsigned int found =3D SWAP_ENTRY_INVALID;
> > +
> > +       do {
> > +               struct swap_cluster_info *ci =3D isolate_lock_cluster(s=
i, list);
> > +               unsigned long offset;
> > +
> > +               if (!ci)
> > +                       break;
> > +               offset =3D cluster_offset(si, ci);
> > +               found =3D alloc_swap_scan_cluster(si, ci, offset, order=
, usage);
> > +               if (found)
> > +                       break;
> > +       } while (scan_all);
> > +
> > +       return found;
> > +}
> > +
> >  static void swap_reclaim_full_clusters(struct swap_info_struct *si, bo=
ol force)
> >  {
> >         long to_scan =3D 1;
> > @@ -913,32 +936,24 @@ static unsigned long cluster_alloc_swap_entry(str=
uct swap_info_struct *si, int o
> >          * to spread out the writes.
> >          */
> >         if (si->flags & SWP_PAGE_DISCARD) {
> > -               ci =3D isolate_lock_cluster(si, &si->free_clusters);
> > -               if (ci) {
> > -                       found =3D alloc_swap_scan_cluster(si, ci, clust=
er_offset(si, ci),
> > -                                                       order, usage);
> > -                       if (found)
> > -                               goto done;
> > -               }
> > +               found =3D alloc_swap_scan_list(si, &si->free_clusters, =
order, usage,
> > +                                            false);
> > +               if (found)
> > +                       goto done;
> >         }
> >
> >         if (order < PMD_ORDER) {
> > -               while ((ci =3D isolate_lock_cluster(si, &si->nonfull_cl=
usters[order]))) {
> > -                       found =3D alloc_swap_scan_cluster(si, ci, clust=
er_offset(si, ci),
> > -                                                       order, usage);
> > -                       if (found)
> > -                               goto done;
> > -               }
> > +               found =3D alloc_swap_scan_list(si, &si->nonfull_cluster=
s[order],
> > +                                            order, usage, 0);
>
> All other alloc_swap_scan_list calls use `false`/`true` but this one
> uses `0` for `scan_all`.
> And it should be `true`, right?

Yes, good catch. Will send out a V3.

>
> > +               if (found)
> > +                       goto done;
> >         }
> >
> >         if (!(si->flags & SWP_PAGE_DISCARD)) {
> > -               ci =3D isolate_lock_cluster(si, &si->free_clusters);
> > -               if (ci) {
> > -                       found =3D alloc_swap_scan_cluster(si, ci, clust=
er_offset(si, ci),
> > -                                                       order, usage);
> > -                       if (found)
> > -                               goto done;
> > -               }
> > +               found =3D alloc_swap_scan_list(si, &si->free_clusters, =
order, usage,
> > +                                            false);
> > +               if (found)
> > +                       goto done;
> >         }
> >
> >         /* Try reclaim full clusters if free and nonfull lists are drai=
ned */
> > @@ -952,13 +967,10 @@ static unsigned long cluster_alloc_swap_entry(str=
uct swap_info_struct *si, int o
> >                  * failure is not critical. Scanning one cluster still
> >                  * keeps the list rotated and reclaimed (for HAS_CACHE)=
.
> >                  */
> > -               ci =3D isolate_lock_cluster(si, &si->frag_clusters[orde=
r]);
> > -               if (ci) {
> > -                       found =3D alloc_swap_scan_cluster(si, ci, clust=
er_offset(si, ci),
> > -                                                       order, usage);
> > -                       if (found)
> > -                               goto done;
> > -               }
> > +               found =3D alloc_swap_scan_list(si, &si->frag_clusters[o=
rder], order,
> > +                                            usage, true);
>
> And it should be `false` here.

Ack.

Chris

