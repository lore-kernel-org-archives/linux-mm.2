Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8503CCFA1A
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 05:33:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 353668E0016; Mon, 10 Nov 2025 00:33:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 303C68E0002; Mon, 10 Nov 2025 00:33:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21A768E0016; Mon, 10 Nov 2025 00:33:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0CE148E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 00:33:46 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A97565C9ED
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:33:45 +0000 (UTC)
X-FDA: 84093580410.12.AA23991
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf13.hostedemail.com (Postfix) with ESMTP id C61E72000C
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:33:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ljw9ErAD;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762752823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2YPse+AqWc5TNScb2DsIrm8BhXLhTwQmVOCKCe+y8NY=;
	b=4eoGXi38AnU+sU0NYyzC7oF6Rtjv6k1Qrrp0/tOO0dBuU2mSFxbxAch/cDNoCJvUVgcpTn
	6owkqEHKOMs4CaLmkvel4tYuXIeQuDOfMKYhsWSY4qto5icHPXCWUpYFC6eEJfC2+CEKvw
	+vjVYod9xmDrHfqWqBBLVJ5NLsxMd9Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ljw9ErAD;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762752823; a=rsa-sha256;
	cv=none;
	b=vqGnmJAsfHfcCULwuP7VLxsTxJPF9vlI6Ki1+IrGD0bIdMJMYg01DSXEIVRi+epFnVpvsR
	npV8yAz4Odv6ajPftY4br20FtPhV41pL2e70/dlrargRZ3eg5LBmPHaBHoq5PyENtI2xQd
	HoOEzj3cDk3nzls8tiekal0GndcHnYA=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-64080ccf749so4011938a12.2
        for <linux-mm@kvack.org>; Sun, 09 Nov 2025 21:33:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762752822; x=1763357622; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2YPse+AqWc5TNScb2DsIrm8BhXLhTwQmVOCKCe+y8NY=;
        b=Ljw9ErADVVWQsVvcOQvNncRzxJ70W6o/2RaVIK3yHjeQkMZZJZKXlf26pqTtMZCsOS
         CQyCdGzNc7uz84+6/0GyNMPLI8wLGbb3PRmttzxNfST+jNf2ijcmOUaAv97dyz2e89hF
         P5xHA/rlCHB2MI5e6YR4jLaGhl1/UU0ZGciQrF8ei3MrbbImWXmgvTx8a/bV9KLh8058
         VEk+QFzFkqRWiZ/zEOLXxjWGO3ynWPn6FMGl/YlzOJnHCtVNxY3SFYa0djQzFN8uwg9x
         TeQOc/dsPS6+peDVvEt22PAmp0SIkWD8PyKb1FwkV4rrMAvIJXWJF+Fnb96WdaPFEBYt
         pcPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762752822; x=1763357622;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2YPse+AqWc5TNScb2DsIrm8BhXLhTwQmVOCKCe+y8NY=;
        b=NOWwmONECVZGEhfYzwnGJ4OLOTjsIzBSs/zW0s6iEWGugz0pMIHmeGFC0EJYXh/69h
         6/VXZd0igfbg38K+RfzemyaL+JbhJt0+R2ribHfKaBpWSNkzIbM9FfLy/ynqkL7U8OKa
         lZQIrqTD0R6OEZd+atQd+Qi1txxgl9pVuYjn5iPG83bPH+n32NiLkGXeJzTz0FMzw/66
         MP9w/cB8NUVitlQ+h5cii4gw4F4ZSqW7Y9nx799XsPLhKjIg4OPDELi2JUaCbLYmBcl1
         FKW8IYs4a8M/10ULkoOdCRhIUSsImUdsxl76MzP/6ClyNSxI/K9R8SQjG634gWtShmx9
         BFxA==
X-Gm-Message-State: AOJu0Yx8RTWdALv9Xc44o21j7f5bhOFeMezdcr61KZ8jdaJpwJaVg9Ai
	iWFVh25sBE4MxkjwivEhl5pqRJQ6vUiRxwxkhABJm/Rx25MTKCy+wPEimKimtun3GnUI2M5kepj
	x70uuu+J3MKYxXTX9ZoCF50i9KzKlia8=
X-Gm-Gg: ASbGncuUQftNSKd3ypK9Q4rtOW6biZJL9hHLcYnhnPJkbTTr+HowiExvyOE7W1VENRL
	msM3Ocuo3gbxN6CvEhWoPYuuLDZe0PfjJr6D4IOMBTDJyz0uCFvpexrzk5ZMwLjRKeJtOwxdc62
	8n7gFU6nnPXsgBx9gPayhGnIrHK4vWLsWGKvz9uX5DYt3do+JW4otHfiELKq/RVewm7n5PSSJlE
	vVWcsfhWKWg8ST1i/9BSPIANryS8FAkiFj1CTlm/oc7EPyAaENHYr1uARJFcFaZV6lGESc=
X-Google-Smtp-Source: AGHT+IHIgpKw2JS/4nW9GWH99xD30wamSLuWzRvjpP+v876+1IW6dPW88z704lMHVQvozZxjzLX+eTNtmZCa8pvUdhM=
X-Received: by 2002:a05:6402:270f:b0:640:b7f1:1cc8 with SMTP id
 4fb4d7f45d1cf-6415e822f52mr5145100a12.18.1762752821989; Sun, 09 Nov 2025
 21:33:41 -0800 (PST)
MIME-Version: 1.0
References: <20251110-revert-78524b05f1a3-v1-1-88313f2b9b20@tencent.com> <2025111053-saddlebag-maybe-0edc@gregkh>
In-Reply-To: <2025111053-saddlebag-maybe-0edc@gregkh>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 10 Nov 2025 13:33:05 +0800
X-Gm-Features: AWmQ_bkULrKqEl-qbo8niCo2wz3BnMM2b5Qc9JZ7etDw2JSDO9jzr5c_pKKh-b8
Message-ID: <CAMgjq7DnaD-bH1efF9c1X0XAvZaMufzBUGxxeRrRAJBzBe59+g@mail.gmail.com>
Subject: Re: [PATCH] Revert "mm, swap: avoid redundant swap device pinning"
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-mm <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C61E72000C
X-Stat-Signature: xxdthbognubkt5pxjrbax4bunosps66i
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762752823-79066
X-HE-Meta: U2FsdGVkX1/bYRaHN2asa3knBsA40a9fzcMUq4K/O1a2SVSDhtQBLLLUla0EiOVOaKbUp3j2n8vzg2Txv1bqES/b7rKnEqb8Q1yhilyHPAfxTmCpSQe08TMwthFCZpwgCZhLCn9Skc6AaQKTdX4Wues9J+FuQO0Wsu0TENTpOyf3WXEdpIMguBMaXotfMcPW5R9JfbhsH6TtMuLli5TuCOPkSFbrS6Q3QG11f87jhemWqCHOPno3pJ8i2yZTo5b8pXXZmA3K8MABcXvZsOwgBKxieTfkaPTu2Eukzz44n6AkOnPBBrxOBBTiuANbxIBuK9UE428hihoKwajrMDnfJTZ8oh6O7t1cwX5CSE6rQYmpGD+4Dnqw4nZ1YmnaeWdwiPCy+uiEDADZzjlD5ip17+GWMwyPut1IXXxOM1LChV9KdJ5jjMf/N5yPIv9lSoL8qNI6sp/S7dQO4Jb4QMdt7mTAIprKEGD/YLlODF3COoedl1CjojW9G9mEBire4UXlHquu8yf7r4P7rI79BzSqwW5IjeHTrjxxYzyjoztS2a0RckGf0lKu9LPek0nIobqDnFixFsvNNjgs7jZKc+zuR8kdh0KS546j20npLEcOF6eOL0IizAO5HgcrgfxFSL1eynAzBod7YUjtnr8w+J5GgGLS1lkR6V728FzNWpJL8xtTclgFvXLbCGH18qWmhBlEpRVU9eJWmgHGDGquqGoLM2iT6FUIq0zJLUgMLl+VaLqDgjvofv04EGvuoNX4WCAcxDqcsBER69sM3vVxSIEj0Cbyb5pRbA+A4xpLQdGEccMg+gGxgWW3AKrborubUjCdn5VNl+6JDEllAPkawzxXcqg04lA91iDWsTbLnusLFDAfuR2lJabAMlOdagwT4Tej599P1ic29Bkr7YqUXO3P5aT1pJRFA0a4/LxsNZiwBRjx4ywCNM+bdYlAaNBRuAPrKW/mw5urkn+0tphcn1F
 Kr45a8aZ
 khF4JVOD3d+H+3Y9XrhLsmdwZ8Sr1oiz6EtzK7+iVIqItASAn1zjxfD16po0BRYkYt6DGFIJFSoyeqBQbYpclMbehJxNz936l0sI3gbxRcclNIiGWBvXGxfY28Je3EzVvG8Y851wnYs9HUJX9UVcSPStzoF2CFsh+MyQvTIhPfxTyT0Svg2P2JASE4Uog63Wv14R6qVNWZK6ZEaYgxc122jb/RoEnY7GD2/XXCEr2+MW68NgYCgUprumpRNuvYtsOkjejEiJ7SOtxBWpcTCu1UXQvfMRRJp1p4idDTGCN3+d2689V0G+YGaOrCEtVTViQKYDXNZ82rXUxa8EeIj+igE/u4oWDxAsgVtvEVvr73Am7qK+TS+Tq9M/2RawpcRCLKmcTpwqZafkJ3DB4+UAjuHW4wUKgIodHa3xmqwsz8g58I9wSaEWw+/awyX2cXJKDVgzS6N6TrYoNaX0le01JvXjdtQnr2CF3ZC8LjJERND9H7bbss3rlhQ3K+n7Z2ujU57tOCYfLhOIf281Gk7PYLOU58lIqjxTh78Evj9SCQAmTI0s/a5PeQD7yx1Ql4vGa6AYJqoX1G/f0YWw0dlCsOqYvH8rjye4JKlm+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Greg KH <gregkh@linuxfoundation.org> =E4=BA=8E 2025=E5=B9=B411=E6=9C=8810=
=E6=97=A5=E5=91=A8=E4=B8=80 09:01=E5=86=99=E9=81=93=EF=BC=9A
>
> On Mon, Nov 10, 2025 at 02:06:03AM +0800, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > This reverts commit 78524b05f1a3e16a5d00cc9c6259c41a9d6003ce.
> >
> > While reviewing recent leaf entry changes, I noticed that commit
> > 78524b05f1a3 ("mm, swap: avoid redundant swap device pinning") isn't
> > correct. It's true that most all callers of __read_swap_cache_async are
> > already holding a swap entry reference, so the repeated swap device
> > pinning isn't needed on the same swap device, but it is possible that
> > VMA readahead (swap_vma_readahead()) may encounter swap entries from a
> > different swap device when there are multiple swap devices, and call
> > __read_swap_cache_async without holding a reference to that swap device=
.
> >
> > So it is possible to cause a UAF if swapoff of device A raced with
> > swapin on device B, and VMA readahead tries to read swap entries from
> > device A. It's not easy to trigger but in theory possible to cause real
> > issues. And besides, that commit made swap more vulnerable to issues
> > like corrupted page tables.
> >
> > Just revert it. __read_swap_cache_async isn't that sensitive to
> > performance after all, as it's mostly used for SSD/HDD swap devices wit=
h
> > readahead. SYNCHRONOUS_IO devices may fallback onto it for swap count >
> > 1 entries, but very soon we will have a new helper and routine for
> > such devices, so they will never touch this helper or have redundant
> > swap device reference overhead.
> >
> > Fixes: 78524b05f1a3 ("mm, swap: avoid redundant swap device pinning")
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/swap_state.c | 14 ++++++--------
> >  mm/zswap.c      |  8 +-------
> >  2 files changed, 7 insertions(+), 15 deletions(-)
> >
> > diff --git a/mm/swap_state.c b/mm/swap_state.c
> > index 3f85a1c4cfd9..0c25675de977 100644
> > --- a/mm/swap_state.c
> > +++ b/mm/swap_state.c
> > @@ -406,13 +406,17 @@ struct folio *__read_swap_cache_async(swp_entry_t=
 entry, gfp_t gfp_mask,
> >               struct mempolicy *mpol, pgoff_t ilx, bool *new_page_alloc=
ated,
> >               bool skip_if_exists)
> >  {
> > -     struct swap_info_struct *si =3D __swap_entry_to_info(entry);
> > +     struct swap_info_struct *si;
> >       struct folio *folio;
> >       struct folio *new_folio =3D NULL;
> >       struct folio *result =3D NULL;
> >       void *shadow =3D NULL;
> >
> >       *new_page_allocated =3D false;
> > +     si =3D get_swap_device(entry);
> > +     if (!si)
> > +             return NULL;
> > +
> >       for (;;) {
> >               int err;
> >
> > @@ -499,6 +503,7 @@ struct folio *__read_swap_cache_async(swp_entry_t e=
ntry, gfp_t gfp_mask,
> >       put_swap_folio(new_folio, entry);
> >       folio_unlock(new_folio);
> >  put_and_return:
> > +     put_swap_device(si);
> >       if (!(*new_page_allocated) && new_folio)
> >               folio_put(new_folio);
> >       return result;
> > @@ -518,16 +523,11 @@ struct folio *read_swap_cache_async(swp_entry_t e=
ntry, gfp_t gfp_mask,
> >               struct vm_area_struct *vma, unsigned long addr,
> >               struct swap_iocb **plug)
> >  {
> > -     struct swap_info_struct *si;
> >       bool page_allocated;
> >       struct mempolicy *mpol;
> >       pgoff_t ilx;
> >       struct folio *folio;
> >
> > -     si =3D get_swap_device(entry);
> > -     if (!si)
> > -             return NULL;
> > -
> >       mpol =3D get_vma_policy(vma, addr, 0, &ilx);
> >       folio =3D __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
> >                                       &page_allocated, false);
> > @@ -535,8 +535,6 @@ struct folio *read_swap_cache_async(swp_entry_t ent=
ry, gfp_t gfp_mask,
> >
> >       if (page_allocated)
> >               swap_read_folio(folio, plug);
> > -
> > -     put_swap_device(si);
> >       return folio;
> >  }
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 5d0f8b13a958..aefe71fd160c 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -1005,18 +1005,12 @@ static int zswap_writeback_entry(struct zswap_e=
ntry *entry,
> >       struct folio *folio;
> >       struct mempolicy *mpol;
> >       bool folio_was_allocated;
> > -     struct swap_info_struct *si;
> >       int ret =3D 0;
> >
> >       /* try to allocate swap cache folio */
> > -     si =3D get_swap_device(swpentry);
> > -     if (!si)
> > -             return -EEXIST;
> > -
> >       mpol =3D get_task_policy(current);
> >       folio =3D __read_swap_cache_async(swpentry, GFP_KERNEL, mpol,
> > -                     NO_INTERLEAVE_INDEX, &folio_was_allocated, true);
> > -     put_swap_device(si);
> > +                             NO_INTERLEAVE_INDEX, &folio_was_allocated=
, true);
> >       if (!folio)
> >               return -ENOMEM;
> >
> >
> > ---
> > base-commit: 02dafa01ec9a00c3758c1c6478d82fe601f5f1ba
> > change-id: 20251109-revert-78524b05f1a3-04a1295bef8a
> >
> > Best regards,
> > --
> > Kairui Song <kasong@tencent.com>
> >
> >
> >
>
> <formletter>
>
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.ht=
ml
> for how to do this properly.
>
> </formletter>

Thanks for the info, my bad, I was trying new tools to send patches so
the Cc tags were missing, will fix it. This patch is meant to be
merged into the mainline first.

