Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 034DBCA1012
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 06:32:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 389A78E0005; Sat,  6 Sep 2025 02:32:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 349658E0003; Sat,  6 Sep 2025 02:32:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 286308E0005; Sat,  6 Sep 2025 02:32:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 16DDF8E0003
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 02:32:50 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CD01C118DD3
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 06:32:49 +0000 (UTC)
X-FDA: 83857857258.27.0684499
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0749FA000A
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 06:32:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MqdaZ5zK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757140368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6kK5t+pdYQgl9moKxVuT5DIsEPulHjxs1HUx0Nbs+gs=;
	b=R/9FJfSdBvcg/izGq7EZHIB2kgdEd8e8lSRpX8CrHmAsLS7ET0eHyeIAlBC1TGv2SJF6zC
	Sf4Jft8zHVrjpelXK2nuAanw9qdwXZPMl2GKwyybfpe2g98wqfzvSBwo+zSmB6BmJM0+q3
	hgbWOyZ0e+/BGt/HnPzIJbJbhrnl9QU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MqdaZ5zK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757140368; a=rsa-sha256;
	cv=none;
	b=wA4BmHX6AHSpt415uxbO2vFqc88yqBABw6xHfN3Weot5EY/8jvZIX9P5iwypUirVeA+TQb
	PUD9DqfUIUA08Cujhd+0Y6NEEG/0WM7vPsVjo+5EpDXqKeaVyRv23ksrAG/8D/lqOQVzZJ
	rsld9KV0bPZHkV+FBL9Ixx0P1bZMewg=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-61feb87fe26so3030573a12.1
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 23:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757140366; x=1757745166; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6kK5t+pdYQgl9moKxVuT5DIsEPulHjxs1HUx0Nbs+gs=;
        b=MqdaZ5zKHnYzVcyLqmVhfN45OGXZVPXiE3HSe4ci7OwFZDW3WqTjFnrAl5IojaBE09
         zV1kqtonOpl5HswUjyXsYgBL4QrOOFPNasPOD8890TqrNGxD/A/N0ycaFiqTyrdFz1bf
         7xYru/+Zj58W2RjrgMyArg6n7PTMVZXs7xhYpsoM6/rKIaGse83dJ3uqsZzfr+d2w5n1
         tLhB8zIhrKYmfMWvQZk0ofDaYK2Wc1W0ZtnPqDfeg3zoW+ZvxNXsX04YCD35A0kVIm9U
         gWKUh8TanjPBJFKYdSd4lE1JjkYGPboMmLInnrS1r06yWzO0YwrNpLMd2kYHY0PzO25E
         QN6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757140366; x=1757745166;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6kK5t+pdYQgl9moKxVuT5DIsEPulHjxs1HUx0Nbs+gs=;
        b=XrCvF0tnOisNIS/qAJ2nnYTfELcL/MN9qnaC9PltMA36RbYmmUFC1pgV2NdvK8kvMW
         yXQBDmB9wubDRFLSLzRRVWNDYZOEWK9uSxo8zwYeVo9UStbsOH9JaC8xKQtbWxfRo2qg
         zAc1WQvRhEHsK66L/XYEOtfQwO8KOgnqAJEcqknXipKdzR9eMwEMKgQlLa+hGzHmZXs5
         4LNa2oPjSJwb3BDuBS6V8lPiYeDFb2vXUwMddv2R9L10QzNLmG8NBpr8A+h6YB/SOEJI
         H11DUjhgbZwQ3ww+WiFUafZVTuq+Vqj3xt1NosW0218nXVyQ7qahYOJM0H9SwFYgbXvL
         hVlg==
X-Gm-Message-State: AOJu0YwpUvb1kroMG51BAlTKidzVfqwUT/XkCO11qYTfzgpmvsq5BFfM
	cNK+QR6QDSSaLLNNbvt+rtrt84VsaSkmPftYVGxliKh81LFnV6TXLK1RVjySflfA1GAY8hqDxch
	losMaEm8ytcojStMHsCA7/n04N+FcpT0=
X-Gm-Gg: ASbGncssRLz0bHmWI4iLfOGwpCzK7YfQEivExaBP2z1kll7mE2wxeNBCLNm4vFXLbMA
	DnAu0cBwT7ILMGBjIYfdyDM1ZXk9Hw++Ce99OJ9UR+dXgERmN2FgxUBdQULQrssnqF0CbA0ZA2k
	+6e27SldLuwZFa3v5CmY+SAlOaK+8kVlzkyWZePO+PpycsZc1CXwsfhkP7EzxID6Pv+qvWXffLZ
	MlJnqN/8HQ4BGmzpD6OmA==
X-Google-Smtp-Source: AGHT+IGZNDdkma+UR16y6zplIu4ueK4Pamyx6VF+j01x7vICoEVtRmcp7DWVNtzU2Xbnd8nWKOnwDIdltdp9Fb9DRhs=
X-Received: by 2002:a05:6402:4308:b0:61d:6bf:12d with SMTP id
 4fb4d7f45d1cf-623783645bcmr1473765a12.26.1757140366516; Fri, 05 Sep 2025
 23:32:46 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-6-ryncsn@gmail.com>
 <CAF8kJuM1Qjq2QjX-=XiUZ3EATPcX8wY0_COdce+Zf8nb=1v8Aw@mail.gmail.com>
In-Reply-To: <CAF8kJuM1Qjq2QjX-=XiUZ3EATPcX8wY0_COdce+Zf8nb=1v8Aw@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 6 Sep 2025 14:32:10 +0800
X-Gm-Features: Ac12FXxno4Q-NpwwKgRz1yo_NwUomWZKwH5I0eRlSUqSUkTlzqqlpVCECnitMLs
Message-ID: <CAMgjq7CD73QJFSna4gNuDBGiFnVVjiOJv0O1Yh=8q94SXaAMHg@mail.gmail.com>
Subject: Re: [PATCH v2 05/15] mm, swap: always lock and check the swap cache
 folio before use
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0749FA000A
X-Stat-Signature: r6brrugfnafywdt5yee7eygx37uhxd9h
X-Rspam-User: 
X-HE-Tag: 1757140367-605443
X-HE-Meta: U2FsdGVkX1/ckO8pKQ/IvEVhovmQg0YvM2qfRe38gTCXP3xpl+Ywk3CyvN5Iy5c3t593Tk4vCmkyNv0LczwZBP5u694y0IYyFHu2uqm9K9xKByC9DcxJZNdyZNkbVFQ/EYVMoyD1pOOg8aTPSZBc3X1VIimTjw7y9LX8P1Z+ddjvd3+TXmX7hAgsWQpLaAR/4kkty9hyu+OQG1HUTrc0mk1vjUNQiNjJMz/iDjzI13yuMlABPOmicSUDOB7tws1ap379pSs2Y6/sc5DrTkf7NQtiLD52ZMENTUEjkrQMMQhbtbhwrk9oMV3GXU0dEpnxxAvoI/seV1YxupZqvzvtX2KIPfjJgQhDdHTBmo+V5kLn1JSEo4gb0dqj4vlQ9Jpqm/naOf+uRAK/ifMg79ROY06Ppkv3Z4Zy3qCxSJsWWiPDSBHEAUz82s8+4HXbRKkDmcCDg4Q/TNu1N3Xfex6s8P0Cpsiit6ArhENp6yTa31uxE5lNwtqvzfD3UG677HID9BwluVnTt+8EhhLA48fXYp/gXfrp0XMpkGFuAORub70oqv1PybGqfNqp00ktooDayU1Sb+oxsDSYVu0Y0x4Hsjd46d+82sacjNRNKFGDRTSnKhseZgoyWfLdXQRJyiy18CRlv3LG9z63GCLJz1F2Q+Q1cZC6zZ5wBX1Gesw6WDNEziPPdHMHRe1vt+Z0UK0V+3/Kjk4SslP4w2BMpYsLb44VkdvtOh2HNqyE5r5Iz2sCC12JUkRXKXaWncteqGBnDHIzIBUjYVJkHTKbs4KKL7P8S5/sf1C62taMtTgXbSdSVb3IFkYXZJbhsKjUe1Y9OBrdY0ZpCXRsbZeJyRVawdWkFGDZ3/JPcxx94Obc1QS/pQG3qgifXbTQQ1UNLNvaS9aG9MwHzQ0iq8c9BLR8P8RCzcL3ynBgGr3jZwVfBDcO1kl1MB6yggqFqCLdEMUG96u+1N+MzZrXFq0i2nB
 EI7yLhrt
 bVt3hrS+gYUs06FNDAL6mmNaDYJawjdtEETkYGbGDmtFbJjxEzg5ts+vUJkUFSLDaI6eJoE6sXUKVSCOkLZxY+B6HtW6S7dSw8r+6vRYC1A37pnjjzL3eQRretiRYO7Q+qWiXnYVIK7lJEzdHSeQQ+hM06MKCt0g0PC2f+ZP5i7uBKrWBiqpgwxdo/6xQGQcEp9bE+9OiSC5DwWuoeqsDA9IR1DntZNGxwAQK4q4fuYlzOdnuq+mC1ckwvd7cM6unElmw7MDaWmKvkkEtjm9bDYniBTHcMqzxSoen/v3IUO6yBFAO/A6Tcrt5/Np+Yv8O3i+bph311yW2NPpErD/iQ+/aSbyHsjNxzZVpO6RHkKJPuH8f+NfZmlmQvWNyMOy92c1zK+Ih4Qboou9Y7noKPbnsWLLNZNDQoTzPNwj31eIadZs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 6, 2025 at 11:51=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote:
>
> Looks correct to me.
>
> Acked-by: Chris Li <chrisl@kernel.org>

Thanks.

>
> With some nitpick follows,
>
> On Fri, Sep 5, 2025 at 12:14=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Swap cache lookup only increases the reference count of the returned
> > folio. That's not enough to ensure a folio is stable in the swap
> > cache, so the folio could be removed from the swap cache at any
> > time. The caller should always lock and check the folio before using it=
.
> >
> > We have just documented this in kerneldoc, now introduce a helper for s=
wap
> > cache folio verification with proper sanity checks.
> >
> > Also, sanitize a few current users to use this convention and the new
> > helper for easier debugging. They were not having observable problems
> > yet, only trivial issues like wasted CPU cycles on swapoff or
> > reclaiming. They would fail in some other way, but it is still better t=
o
> > always follow this convention to make things robust and make later
> > commits easier to do.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/memory.c     |  3 +--
> >  mm/swap.h       | 24 ++++++++++++++++++++++++
> >  mm/swap_state.c |  7 +++++--
> >  mm/swapfile.c   | 10 +++++++---
> >  4 files changed, 37 insertions(+), 7 deletions(-)
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 94a5928e8ace..5808c4ef21b3 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -4748,8 +4748,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >                  * swapcache, we need to check that the page's swap has=
 not
> >                  * changed.
> >                  */
> > -               if (unlikely(!folio_test_swapcache(folio) ||
> > -                            page_swap_entry(page).val !=3D entry.val))
> > +               if (unlikely(!folio_matches_swap_entry(folio, entry)))
> >                         goto out_page;
> >
> >                 if (unlikely(PageHWPoison(page))) {
> > diff --git a/mm/swap.h b/mm/swap.h
> > index efb6d7ff9f30..a69e18b12b45 100644
> > --- a/mm/swap.h
> > +++ b/mm/swap.h
> > @@ -52,6 +52,25 @@ static inline pgoff_t swap_cache_index(swp_entry_t e=
ntry)
> >         return swp_offset(entry) & SWAP_ADDRESS_SPACE_MASK;
> >  }
> >
> > +/**
> > + * folio_matches_swap_entry - Check if a folio matches a given swap en=
try.
> > + * @folio: The folio.
> > + * @entry: The swap entry to check against.
> > + *
> > + * Context: The caller should have the folio locked to ensure it's sta=
ble
> > + * and nothing will move it in or out of the swap cache.
> > + * Return: true or false.
> > + */
> > +static inline bool folio_matches_swap_entry(const struct folio *folio,
> > +                                           swp_entry_t entry)
> > +{
> > +       VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> > +       if (!folio_test_swapcache(folio))
> > +               return false;
> > +       VM_WARN_ON_ONCE_FOLIO(!IS_ALIGNED(folio->swap.val, folio_nr_pag=
es(folio)), folio);
>
> You should cache the folio->swap.val into a local register value.
> Because WARN_ON_ONCE I think the compiler has no choice but to load it
> twice? Haven't verified it myself.
>
> There is no downside in compiler point of view using more local
> variables, the compiler generates an internal version of the local
> variable equivalent anyway.
>
> > +       return folio->swap.val =3D=3D round_down(entry.val, folio_nr_pa=
ges(folio));
>
> Same for folio_nr_pages(folio), you should cache it. The function will
> look less busy.

That's a very good idea, that should also reduce line length so it is
easier to read.

