Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F649CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 03:13:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 609468E0010; Thu,  6 Nov 2025 22:13:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BA548E0002; Thu,  6 Nov 2025 22:13:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D5218E0010; Thu,  6 Nov 2025 22:13:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3B61D8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 22:13:48 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D039E88421
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 03:13:47 +0000 (UTC)
X-FDA: 84082341294.02.611D213
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf05.hostedemail.com (Postfix) with ESMTP id EEE1F10000A
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 03:13:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C+NhAC02;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762485226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NvrTpOGP7aMJ3ofU6Kesaybm3QUz/kuK5E5YnIxHukE=;
	b=jne4utiM7QvuyRj65yy0VtvzNUN7oZt0p3n2V79NDzvsDjjHFcivLkLgS47EOL2AXG7UwS
	7OWALM4X0wqM0Dk0ltzeFac7Yzo/0+EHbig/Fjit7224ZWy/7vA9j2gVrp0+NAq5k7m4lp
	L8xl3knAavW2nV6OOhOR+wDMhCsivbk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C+NhAC02;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762485226; a=rsa-sha256;
	cv=none;
	b=V5S/wVYFedgefeMcgwANqe0UhcSPTEjUYVG1TlX2Q/xUeMTa5PLZ9PRWy2RI0WnOFZ85Ah
	J0g/bVHsNsjibqWPrMghr7TeONkkA4OI6+tHeaVZAp4mJofkdB1DSLKrMOHBVooRXbIRt9
	kTKxdQIGSnE9PCdgPH+Gy4M0sp05NYg=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b7291af7190so42543666b.3
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 19:13:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762485224; x=1763090024; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NvrTpOGP7aMJ3ofU6Kesaybm3QUz/kuK5E5YnIxHukE=;
        b=C+NhAC02p3nI7EjRODQt7H5+Nr9h8cqf8OvvrFTOwi430EiLiWhvPsXGtmFekLBwUQ
         SRVOwM3Y70ck7DXEOEG25RCJG7oCIkphXvwDM0leXi7CSYZsVx2kRPEe3p0tdLSDAXwo
         Wr53ZORYcBu92tA5dDh9IGJ+oXTQjci9TgdQHJBC4deRP2+5BxidPhe9rSXvIfwzB9iH
         cIKuErC4ZMEZ3xotrxypQdL56B1qE3pL3YvCPKToUTpKztPftPcJOSX0hMFqOXrJnWp2
         rIOu7obyisgpmtw4GrrBLS4n7n0kiHqTe5oz4CmMRPn0JZexqhxCdmcEk3Jr2KIG5ihQ
         EEyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762485224; x=1763090024;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NvrTpOGP7aMJ3ofU6Kesaybm3QUz/kuK5E5YnIxHukE=;
        b=n2xpsGmxnQYHHj7UNOAqBevh19XCjVU1hAN5L9z4Vrjy1sioSjZVXUmd4ZurekHUUT
         /LqyvvynWN5oZzEf0AIH74V9V9+Kg6K+fBcOC1zmSiv6mwngQedplK6QPAOIUdRlGkBN
         TIgdyZWXGv0o2rDk8VhvlugCk9ByG8eGhxYYYeiAD26YkoebIBo9+lzw4HoDbFJaE0lr
         wWdOsH922jDE3MyzStdrFx6KdZfIBT50HHirrZLSK57CheyyYKFX9YrHRRXlVYO0lljN
         MGMEjpLCSfER5UVNMqvqcyvXKflVVZJ+WWOTDCI/HKH/o3HAzIx5N2ChuQxKCNE4e2hM
         I1QA==
X-Gm-Message-State: AOJu0Yx9ka9QGyFc2zrajmBEbCkBCnwytI1kNCHXoEL0VAJExDJWySs4
	wUUcRsvsoo89qO7oY0PMiplK1JXXVP8MailVGQ9M2/8TkkVYazvEq6m8vCQD6vgRSlqiO+RWGbu
	ktDiv15oQryFAlZeGxOOdfABP3bKRfbk=
X-Gm-Gg: ASbGncvsKLlhJQ0YXTnskvvWh2ao3QejhSH2JgCqR9WXfgqKjNzvQxRfl6ZWFnXX6Hz
	fr2Q5vV16lDFzJCUK1JnuSTZs+9+CVmv08/YkG9ttizHIUvWNhkXzCfAbc0boNAm4FLhok7oO6n
	PjRis1cP3BdIyXFENJUpY5luDj262cdYuy5H48dhpWMDz2i/Q1U249PnRx8b46aWLJHoaVD9Hy+
	mElHngxDPHsZbumwYQeXenYWlrorJcHig6kwcZASm3rowubLQgnELI+ZuXdVCoVu+vVpZecvb0=
X-Google-Smtp-Source: AGHT+IFvgxJuStMmVIqGXsCVlkmwIxDJudtKdUSj37nh23HRpbEzPGQyRTGMo2HV4vxKZWgtPhjnfS6zCwu87LUXriY=
X-Received: by 2002:a17:907:3fa8:b0:b72:6383:4c49 with SMTP id
 a640c23a62f3a-b72c0a6dff2mr131328766b.34.1762485224270; Thu, 06 Nov 2025
 19:13:44 -0800 (PST)
MIME-Version: 1.0
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
 <20251029-swap-table-p2-v1-16-3d43f3b6ec32@tencent.com> <CAGsJ_4zW92dnCk6qUF9fKe+=b0dORLrBjuQC5mjq_nbTK4aT4g@mail.gmail.com>
In-Reply-To: <CAGsJ_4zW92dnCk6qUF9fKe+=b0dORLrBjuQC5mjq_nbTK4aT4g@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 7 Nov 2025 11:13:07 +0800
X-Gm-Features: AWmQ_bld9YwZqZ0D7Pb92DTAq9jlfQw-Il4i-YD5dCPjDDQ_ZS3qtNSBlgava0g
Message-ID: <CAMgjq7Dwhtt4ACmOFSqEvzSoA+Ny0D9_1yeZz9gf7bWvSjj9jA@mail.gmail.com>
Subject: Re: [PATCH 16/19] mm, swap: check swap table directly for checking cache
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EEE1F10000A
X-Stat-Signature: w5chfzotuuebhukfzbiy4ofraendgx56
X-Rspam-User: 
X-HE-Tag: 1762485225-342746
X-HE-Meta: U2FsdGVkX1+0GlWQcbasXDKUfccK/wV6ILR2SZL8FgsX74mHL/hCTUK9yoLA+iDd/09LopYvu3iE2dMVCjjsCYs4n0hGzRnal3xnW3h5NfMSEKVM4ekQk1uhybVe2F5f4rK/sMxdoBT0Q60gWwGVjE85RHcBcOgR23Hg0PzENLGQ7CJViAjNS9ukcEJPqKHRNQRmAup1CjmwQD3lxLqiPzAttO26ybq62OypeevPDAIMm3/GfD1cs89HaRMX8ZBMXZdqTtbZ7+Hs0/0nUmVZxeNpEiHL4WFUWK2vkt+mmjo7vzBsPLsW0+HZwWcZ89/3iHYYdk2KZ68K+dFSu6VqwfiJUCBN+jzJVTmmyLy5piJshl33f3UUvLFdrN82SVMNbRza238Vogxkluhdr2QOJcNHKYeZFEMZgKOnm8dYQqmaJL3miwV0BFDWmWbeALCjMGg2UpVgR+/0NT0jqbZKqDbq6WtscVR6/aCOqEvOp6w52Ove3KP6LfahCiuLt+AFwSyF+1DmcFSKFOSy9rbxIkhmlVSXloAEcY4aWJKqltYMDsVEN7d/xbitBR+fL+cE6hnV9UL5kacVNdR7vezhWPaJZ2vMjpENTM4pBFVVL+lhSofS27mxvB1X1oXCa7b/D5kcNlzVi9PhxeYNR0EfqvQ3XcImI6r8qMmXGMW+iLnjyyMWvdYJJeuyrRJcLpnmAxXEVQnZtuPj2aS/mxwo/UNnFvV1+bCmCtszTsOlJIiDI/pPUqUBOo4g78P1F5ebwV+27rYzDknSLDpG5Hb65i7kFphKbAlV83C9m/NJ9styIZMJlTZtQSlyeXUYP/npZm24EofBhMn1E+QV9PhKMOtqrGPxBFQfeLbRe/ixH2fptsjbCf66l6yICzHV8KL18gW8htkeJErVfCCAl5DwRN/VJnp5Uqm/nDuTpGp8LJlWqTWJTLdzbiOW/nrXsbbLuEcerZYJDQzoM+inM3b
 axuSCJzn
 KQEoFCgbq06qmShkel+POdbF9lGIxrtIm6nrDcEAFEZU5Zet6b/XeWxS8s3BzrMECFx9xTNu+GKGGgeZ4/YwizSijTznn8EB3g/17HR7bE2+0Pe28vUMqivNb51fKwggsrBddU8yw9Fvf91/z7t3QXNEsWw5N80TXT9R5ylrg9XXpTHw+VgwWNvJXKtCj0wfodEpX/AFsqhjb7W0AA/SxQHfEmIgCCoVKoNnphtVASJloDZDwQ1QJ7TAo0atb+0Udaeg1vaM1lYwf5PEAv4Q//A0dkwBa/0VOagbhfRFx8yyCagU9fHVo/4C0RrfXVCQizCq6olob+rV8a1/Lyo0It/oQtWySryTmViqxvBlTGPGhC6wRg+ESdhAaE7Mr7ORrG+xfKHXONsMHrTDF+Lx8LPM31Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 7, 2025 at 5:03=E2=80=AFAM Barry Song <21cnbao@gmail.com> wrote=
:
>
> On Thu, Oct 30, 2025 at 12:00=E2=80=AFAM Kairui Song <ryncsn@gmail.com> w=
rote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Instead of looking at the swap map, check swap table directly to tell
> > if a swap slot is cached. Prepares for the removal of SWAP_HAS_CACHE.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/swap.h        | 11 ++++++++---
> >  mm/swap_state.c  | 16 ++++++++++++++++
> >  mm/swapfile.c    | 55 +++++++++++++++++++++++++++++-------------------=
-------
> >  mm/userfaultfd.c | 10 +++-------
> >  4 files changed, 56 insertions(+), 36 deletions(-)
> >
> > diff --git a/mm/swap.h b/mm/swap.h
> > index 03694ffa662f..73f07bcea5f0 100644
> > --- a/mm/swap.h
> > +++ b/mm/swap.h
> > @@ -275,6 +275,7 @@ void __swapcache_clear_cached(struct swap_info_stru=
ct *si,
> >   *   swap entries in the page table, similar to locking swap cache fol=
io.
> >   * - See the comment of get_swap_device() for more complex usage.
> >   */
> > +bool swap_cache_check_folio(swp_entry_t entry);
> >  struct folio *swap_cache_get_folio(swp_entry_t entry);
> >  void *swap_cache_get_shadow(swp_entry_t entry);
> >  void swap_cache_del_folio(struct folio *folio);
> > @@ -335,8 +336,6 @@ static inline int swap_zeromap_batch(swp_entry_t en=
try, int max_nr,
> >
> >  static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
> >  {
> > -       struct swap_info_struct *si =3D __swap_entry_to_info(entry);
> > -       pgoff_t offset =3D swp_offset(entry);
> >         int i;
> >
> >         /*
> > @@ -345,8 +344,9 @@ static inline int non_swapcache_batch(swp_entry_t e=
ntry, int max_nr)
> >          * be in conflict with the folio in swap cache.
> >          */
> >         for (i =3D 0; i < max_nr; i++) {
> > -               if ((si->swap_map[offset + i] & SWAP_HAS_CACHE))
> > +               if (swap_cache_check_folio(entry))
> >                         return i;
> > +               entry.val++;
> >         }
> >
> >         return i;
> > @@ -449,6 +449,11 @@ static inline int swap_writeout(struct folio *foli=
o,
> >         return 0;
> >  }
> >
> > +static inline bool swap_cache_check_folio(swp_entry_t entry)
> > +{
> > +       return false;
> > +}
> > +
> >  static inline struct folio *swap_cache_get_folio(swp_entry_t entry)
> >  {
> >         return NULL;
> > diff --git a/mm/swap_state.c b/mm/swap_state.c
> > index 85d9f99c384f..41d4fa056203 100644
> > --- a/mm/swap_state.c
> > +++ b/mm/swap_state.c
> > @@ -103,6 +103,22 @@ struct folio *swap_cache_get_folio(swp_entry_t ent=
ry)
> >         return NULL;
> >  }
> >
> > +/**
> > + * swap_cache_check_folio - Check if a swap slot has cache.
> > + * @entry: swap entry indicating the slot.
> > + *
> > + * Context: Caller must ensure @entry is valid and protect the swap
> > + * device with reference count or locks.
> > + */
> > +bool swap_cache_check_folio(swp_entry_t entry)
> > +{
> > +       unsigned long swp_tb;
> > +
> > +       swp_tb =3D swap_table_get(__swap_entry_to_cluster(entry),
> > +                               swp_cluster_offset(entry));
> > +       return swp_tb_is_folio(swp_tb);
> > +}
> > +
>
> The name swap_cache_check_folio() sounds a bit odd to me =E2=80=94 what w=
e=E2=80=99re
> actually doing is checking whether the swapcache contains (or is)
> a folio, i.e., whether there=E2=80=99s a folio hit in the swapcache.
> The word "check" could misleadingly suggest verifying the folio=E2=80=99s=
 health
> or validity instead.
>
> what about swap_cache_has_folio() or simply:
>
> struct folio *__swap_cache_get_folio(swp_entry_t entry);

I was worrying people may misuse this, the returned folio could be
invalided anytime if caller is not holding rcu lock.

I think swap_cache_has_folio seems better indeed.

