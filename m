Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D46ACD4F3E
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 16:02:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B4428E0015; Sun, 16 Nov 2025 11:02:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98C078E0005; Sun, 16 Nov 2025 11:02:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C8878E0015; Sun, 16 Nov 2025 11:02:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7512A8E0005
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 11:02:09 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 41D0FBC65D
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 16:02:09 +0000 (UTC)
X-FDA: 84116936778.16.45A0693
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf29.hostedemail.com (Postfix) with ESMTP id 838CE120004
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 16:02:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e3zmONaQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763308927; a=rsa-sha256;
	cv=none;
	b=baa4Ve0M0a+mZkMuDmjMVdgEibgvkCj+pBM34OnRH8aIdGjguj1M2kHv1+UYqQvOJKYiAu
	E89zsB3A950VjwPPoQ//+O9WMqLQmhgz/dCPbAKsIMbNPiskrHnUe1L9+pwmkw2Ml5qo48
	vQ0Vz1q7qi3afe9548+Bm2JmZlZYygE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e3zmONaQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763308927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gv5LMPLYwFZHYn7ySvTdnW/teh2/r5DB4ESRyn2nfxs=;
	b=yA6Q93yYUIMiZ4KRZW7uLYnMfD8oVIc4Rd8HYr3TD8G7y4aXJACVEkA/Zf1ng0s8j7LcZF
	Y+oNh5VeERgtuAvQK53FTQD9xnpcaQtRd3M+ew9PRBIsHEOPNdCtZ5oa7pUcHK6KRpGnIW
	6PM7kfgD9nnC2ap2//5CF7m/ac77fDQ=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-640bd9039fbso5918213a12.2
        for <linux-mm@kvack.org>; Sun, 16 Nov 2025 08:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763308926; x=1763913726; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gv5LMPLYwFZHYn7ySvTdnW/teh2/r5DB4ESRyn2nfxs=;
        b=e3zmONaQAnXFaejUpdwLVsYep5WS/DWPvyfZBIkDGsIcTQHTiKpp58GpKYpri/An6f
         o85RcJKksem3wPPyPI/izP41x8VRo8ddX5eMLUsJUTzUSgmOsyBr1jQQC0tn16ZaSHA2
         YWn8OwXqPqioXwGKDy2W64sK+ABryInQH+w4bEAmWSDOxybekalQnbA8xsREXXKIiBdE
         1N44aK6LNaDmaUy8pxQcdZP1fndV7y58lWVdZOBoCj/Pibe48NzD43dsAPS6zPdTRzfU
         3jCTAqfVNdN39mkQWYqy1kwvU17BDW4hxfPqTBoTDSVvFYth+gPB5M4ZJWJWap4AoaK1
         ohxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763308926; x=1763913726;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Gv5LMPLYwFZHYn7ySvTdnW/teh2/r5DB4ESRyn2nfxs=;
        b=dVglK273Yb9GZWZfzXCWOIe/qCIvMBIKDGQIs4ePKfHiTk2dlI4KCvFMNZpmsA2U41
         xoilmvfhn93cczrBLomRFxkhmT/ovaD4NpQaYPzvtCxEmpkizZvr8VPpZj60qS9ayxP2
         YKfZ+d4twiypv8gGzbWKSYpgBPHmoJ0U0xWxgtHZSmVekmR2O0RitSBJCFAxaei6zWDf
         A5bxiR1y0772IHRrF6dHFBPOp/BSAm7sv4XarfwAScnjnXwiEnU6kg9LYV53yy+FOjPN
         A9GaAQjvBlfpEQ4nonqi41uUP3vGdCvNH4lb63zX5w3QLIH11b1ycGuAwQjGxzWrNUo7
         TdbA==
X-Gm-Message-State: AOJu0Yyrv0iMbG0jjHd2Jvo51+yJxYYVHQm4yQWi7i9Ew+xOHfuyz00W
	tFZ0oWw4QDoaDFv3KSJt0cqG5ebP0ZyXLn1VOjtxBXU7x06L8UpALhKRBpVzw4X1GJ+KXc0Ymzq
	c6PYHbAQbhX/NPmf0oVDnt+lp8Oi/Fnw=
X-Gm-Gg: ASbGncvtezJmbPPi2nH5RF6ukiA4zP6G31ZkAasznjhG9uKB5vHMHfoXxUUmX2dU3R+
	2ConLjFCbZPYSW8XumUVgDI6HU5sJlJIuFMVxRPCxM2PNtZoQS+pW4t+EO6fv36q2gNodkcgoIs
	ARdPmK6GwZB7iYr80Y5YW3zhkrNNnanDB23PZxf53bU9d+uDe7IIzUsVYb2XfqX18879eEgYA9m
	ekKPSn6XNJr7z+lRudKOr1Ze/bQLxaOjDHFufg3R/ZM9oWn62PCgdlfwS2YqPJh+Pnpv0uDvSaq
	IOvdmtZorCGTmxOx5czUjm1ouP0gY5w=
X-Google-Smtp-Source: AGHT+IFkYdruCKLfqa70Y9lQPVv+CmQM798vj8kDcIyt0wQWQh6wbjHwGhWIzNFmal8uvBYjguvEeigF8JQhnnjT1hg=
X-Received: by 2002:a17:907:72cf:b0:b73:21db:6f52 with SMTP id
 a640c23a62f3a-b73678f5f10mr902546866b.42.1763308925495; Sun, 16 Nov 2025
 08:02:05 -0800 (PST)
MIME-Version: 1.0
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
 <20251029-swap-table-p2-v1-13-3d43f3b6ec32@tencent.com> <CAGsJ_4xquj2Kbc2qu0vtY6Q+-q3sg56BgKEdPs8eHtKxLBk0gQ@mail.gmail.com>
 <CAMgjq7CDXh5OWy5BMXzNPCSuMQfODTdFPOhpCDGXrhisNfAGdg@mail.gmail.com> <CAGsJ_4yjU0NmQe0cM2xDkMYVdAWRc2Q1FUMGxpo8cVkEt5ifVQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4yjU0NmQe0cM2xDkMYVdAWRc2Q1FUMGxpo8cVkEt5ifVQ@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 17 Nov 2025 00:01:29 +0800
X-Gm-Features: AWmQ_blsmpBEQZ-qx-vgaYrW7xwT8kVUvZZuk7LfBUBchsPxLfPrdXeW9EhsQHE
Message-ID: <CAMgjq7BU5S3cPQSRA2+RriPRNEZzZZK-VeuRiMtAzOgva-ZUKw@mail.gmail.com>
Subject: Re: [PATCH 13/19] mm, swap: remove workaround for unsynchronized swap
 map cache state
To: Barry Song <21cnbao@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	David Hildenbrand <david@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 838CE120004
X-Stat-Signature: szwup36tjgzatdw4ooa78imhreuq41zj
X-Rspam-User: 
X-HE-Tag: 1763308927-796560
X-HE-Meta: U2FsdGVkX1+Eg4tgr/T4ulGbDdO2i6J0QgTFz9t5QMwLK0wkqNEnmIvNt6VZh/85zpY9peGbLNRINvrgjHA2d8n9NkgtQXeQYpm8ehT+rYXfuOwmspnFj66ZlgQkrtiUKJrn8ivdBqj55+yXopWTuRT2eovz4gVMCEbtpBKygdOBGT/8ucp2/gNmJTQGktYFA6a9Zbd+mJL8c31senyEQw8tExX0+KbgKhzAVpYD0QpU8rjK4SEzBDuZn0syOEQ9we7tUUpB6G5YEDvGpLJ7HZENGUJRmUVM0tCv7YjFQm+uv35p7kHDldiAfBKXopIxtREN2HIZkQ6PVpwIiHfAOqEYMK9KNQdBnE1CZA5Pe6iDGRcHUyvGtmLdr7C6LbrjxfP2sPXshHz4JJjkz4CMvS6ICqUhOnE//yRrU5/XXehxqGKvwQXecGmsJkrn91jUx+pZgt1jkosLBiUmsU+V6If0f6EGb64NGKsAffHr6MCN+Z4DMyX4a38efTELRLw4FyPAfoSiu0bb0p2rH22yYTdXb6StTHU1YmCWewNVXU/tVBKYmUfFWskqJn1gc+mQURF/bWaCez/KX798HRQ2i+FfvHTKbdjZjRSu5fhtcN9itHFLNojmaESjBnQOOnuoRInJm4/8sVo1LYdJdAX7Qv+vmWENd4+rRQ+WBZRDcWahwE67LADDKGUukGprYJIqE+trHmCerNgfDRnyZFmhi4k10uiDns3I3KZ6C5oCFoxvlHYzca1KaXH6VCTphwZ0V+ymsbbFJ/SvPOzxPkIJZKMzbAm0XY0OFGwPG34bZ66tyvBgqA788W2pX67U9W0911CKoJdRkuiXcIxHXDuenCim/LyjsSl+T+nolueeaCcowIzA3+zBU8jtWgIpfM7toXb8t+QDMrnuHGNPTwz/Cv5i+sB76lUNTzA51V/dj74QoLgp56aFyVt/9Q2EWF+AAunim7JBuaTm4WWjdQZ
 bwEEx/Zl
 48srq3PzhSWsIFi4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 3:21=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Sun, Nov 9, 2025 at 10:18=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > On Fri, Nov 7, 2025 at 11:07=E2=80=AFAM Barry Song <21cnbao@gmail.com> =
wrote:
> > >
> > > >  struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_=
mask,
> > > >                                      struct mempolicy *mpol, pgoff_=
t ilx,
> > > > -                                    bool *new_page_allocated,
> > > > -                                    bool skip_if_exists)
> > > > +                                    bool *new_page_allocated)
> > > >  {
> > > >         struct swap_info_struct *si =3D __swap_entry_to_info(entry)=
;
> > > >         struct folio *folio;
> > > > @@ -548,8 +542,7 @@ struct folio *swap_cache_alloc_folio(swp_entry_=
t entry, gfp_t gfp_mask,
> > > >         if (!folio)
> > > >                 return NULL;
> > > >         /* Try add the new folio, returns existing folio or NULL on=
 failure. */
> > > > -       result =3D __swap_cache_prepare_and_add(entry, folio, gfp_m=
ask,
> > > > -                                             false, skip_if_exists=
);
> > > > +       result =3D __swap_cache_prepare_and_add(entry, folio, gfp_m=
ask, false);
> > > >         if (result =3D=3D folio)
> > > >                 *new_page_allocated =3D true;
> > > >         else
> > > > @@ -578,7 +571,7 @@ struct folio *swapin_folio(swp_entry_t entry, s=
truct folio *folio)
> > > >         unsigned long nr_pages =3D folio_nr_pages(folio);
> > > >
> > > >         entry =3D swp_entry(swp_type(entry), round_down(offset, nr_=
pages));
> > > > -       swapcache =3D __swap_cache_prepare_and_add(entry, folio, 0,=
 true, false);
> > > > +       swapcache =3D __swap_cache_prepare_and_add(entry, folio, 0,=
 true);
> > > >         if (swapcache =3D=3D folio)
> > > >                 swap_read_folio(folio, NULL);
> > > >         return swapcache;
> > >
> > > I wonder if we could also drop the "charged" =E2=80=94 it doesn=E2=80=
=99t seem
> > > difficult to move the charging step before
> > > __swap_cache_prepare_and_add(), even for swap_cache_alloc_folio()?
> >
> > Hi Barry, thanks for the review and suggestion.
> >
> > It may cause much more serious cgroup thrashing. Charge may cause
> > reclaim, so races swapin will have a much larger race window and cause
> > a lot of repeated folio alloc / charge.
> >
> > This param exists because anon / shmem does their own charge for large
> > folio swapin, and then inserts the folio into the swap cache, which is
> > causing more memory pressure already. I think ideally we want to unify
> > all alloc & charging for swap in folio allocation, and have a
> > swap_cache_alloc_folio that supports `orders`. For raced swapin only
> > one will insert a folio successfully into the swap cache and charge
> > it, which should make the race window very tiny or maybe avoid
> > redundant folio allocation completely with further work. I did some
> > tests and it shows that it will improve the memory usage and avoid
> > some OOM under pressure for (m)THP.
>
> This is quite interesting. I wonder if the change below could help reduce
> mTHP swap thrashing. The fallback order-0 path also changes after
> swap_cache_add_folio(), as order-0 pages are typically the ones triggerin=
g
> memcg reclamation.
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 27d91ae3648a..d97f1a8a5ca3 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4470,11 +4470,13 @@ static struct folio *__alloc_swap_folio(struct
> vm_fault *vmf)
>                 return NULL;
>
>         entry =3D pte_to_swp_entry(vmf->orig_pte);
> +#if 0
>         if (mem_cgroup_swapin_charge_folio(folio, vma->vm_mm,
>                                            GFP_KERNEL, entry)) {
>                 folio_put(folio);
>                 return NULL;
>         }
> +#endif
>
>         return folio;
>  }
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 2bf72d58f6ee..9d0b55deacc6 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -605,7 +605,7 @@ struct folio *swapin_folio(swp_entry_t entry,
> struct folio *folio)
>         unsigned long nr_pages =3D folio_nr_pages(folio);
>
>         entry =3D swp_entry(swp_type(entry), round_down(offset, nr_pages)=
);
> -       swapcache =3D __swap_cache_prepare_and_add(entry, folio, 0, true)=
;
> +       swapcache =3D __swap_cache_prepare_and_add(entry, folio, 0,
> folio_order(folio));
>         if (swapcache =3D=3D folio)
>                 swap_read_folio(folio, NULL);
>         return swapcache;

Yeah, that will surely improve the thrashing issue. Having a
`folio_order` check as the charged parameter looks strange though.
Ideally we will have the swap_cache_alloc_folio to do all the folio
allocation so there won't be many different swap in folio charging
callsites (currently we have like > 3 callsites, anon THP, anon order
0, shmem THP, and the common order 0 in swap_cache_alloc_folio). That
will also help remove a WARN_ON check in Patch 3.

