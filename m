Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0C93CAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 16:30:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF7048E0009; Tue,  9 Sep 2025 12:30:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA6758E0001; Tue,  9 Sep 2025 12:30:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D96138E0009; Tue,  9 Sep 2025 12:30:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C775F8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 12:30:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7C5FD160566
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:30:21 +0000 (UTC)
X-FDA: 83870249442.10.022F757
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7D4194001B
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:30:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=v5LjQQev;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757435419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FHJHNlNOaMOyVoBAHvHo+maMOWkTYnhe6QXua4Kxw8s=;
	b=KPfTWR5vumU38JystjP3VXsAzpOfXGS8Vfew5PneM9+eElSeFGGxwRCr8BgwSP4P6ldV68
	GVUSg7m0GUOXz+pGPjejxdSGF/u/Ko7P9q77ReXhbHOjDCx8gAG/mfqY7EJwrHO+0KAebQ
	TsGUR95xxDQNoycbohB/9CGGcxNNe10=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=v5LjQQev;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757435419; a=rsa-sha256;
	cv=none;
	b=vPBhEGpRJQN0fAzGv/sI8iSd27zVOn2GgZ2OnnReIO1YOR+QTaU8NNeSH8KYImqGllpphF
	rSdmvVBi6lrLBGq4o39OTV6VE6uisxbm7UPu9E4UfumbG4V/LwgIRflMAJXFRu1ISaK2Ce
	ORjcKWCwIUNkybSi6uZ02T0p35+qAew=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-621c6ae39b5so50a12.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 09:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757435418; x=1758040218; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FHJHNlNOaMOyVoBAHvHo+maMOWkTYnhe6QXua4Kxw8s=;
        b=v5LjQQevBzlKiKkhi6tgGZFUpi2nqAs/q29eIPwuW62DEKvFT0fTqOJh7r+T/2fNvF
         xVTyxov0u3WDfwDArLZM+kh6yDLzX8x1r1he+lxbWzqVtjVlTsNJgnaTB0N4FnbuGBZW
         s3xhNFTVVO0uCBSKZxCYj3TuSpdj684zu5kJsW1eubJ6vgeH1s2umrqgHx24kH4Nx/OD
         f37nbkT58oOAoX1Cyst28l9GzLCeynAVdkkAX3vCLqC7y233TpkIS3TrvyBqPFc2duun
         E75g+76ZfHF/I1FoZdMspK6DiMsonw7ueLDYNCPpwEP4Fze6tnLL/xvoIsovswBDg92L
         Vhww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757435418; x=1758040218;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FHJHNlNOaMOyVoBAHvHo+maMOWkTYnhe6QXua4Kxw8s=;
        b=v+y187iIbERej4/1VVQU8Y9y4BWbCHqMUeRyXc7TSemAR16PVjUmyENW6mIlfjyb1Q
         5nJ9u7W9g7ZjKSxVtVUbN+kyylx8GnxlX92F7FqsHyxdcNLYKsVz5Ync6z4wtzk3aqzQ
         daz5B1lhprVoXwycA2ENJuOcCuCBW7Mc05UXRJbM8fp9KNgm+ZMpKYw7TbjIJW2GF5um
         VUwVqJG6p6Z4WhAi9XQLcjD6FYPNOJlJaMrJ27V1f2hQs0dxtI1yzn+7uC+Kxe+Sk9Ju
         yFZmeBeFHSY6XDoDlQW6khkQa31/xq8QmGSopJc8r7yCUGr3OoJuxhXYJrVq0NDqWQGh
         fXCA==
X-Forwarded-Encrypted: i=1; AJvYcCX6c91o7JbSKrTWHXPtn/8/QxN3hk3RNMem1P/Vz3a3IJGflroBTkvSHz2EydCmWwSSuAUxlkFZZQ==@kvack.org
X-Gm-Message-State: AOJu0Yxv1sHz9CgNel6nY2zvSABJzQRNx1owp3Zyp7ynrbp/MhpZXKY/
	nIuY8H036ctEQu0uEm9RXl1noHdzq7fag2xu1diDpEGMBy4Q6VaoWBBwp6saqHYAL7bwke9od16
	Pu4UuZ0XXvyZPRXO9ok+u64gEU2UEjXdAOT3bh4Vh
X-Gm-Gg: ASbGncvSe38rGgYMu+FA5Bf7AS8RsOBbFpK2F1njKnkWdYOG6hx3b//d8Iynpf2eTV7
	gWE5cQPoIjiO/1lSc95ajyAYEOARSFOnt/nls8rbMfurRVnn2psSnEvEweGiEvBKAyZb7Z52k9W
	jK5tlqVLCcjvGerMN/c9la3urr3oPC0c+Aumxt4X41621Tx8il0hlT+fVyxLfH1flgTemMfVqa4
	ah5P8wnBQZgmmmwFCp3KqyE86+7qLzhqEdV+A7DxUkS
X-Google-Smtp-Source: AGHT+IFbWAiDVlID1hnyzgk511dH5neUI5OLeqIjJ12rVpIAxmuNfaLD/tbpY5u2JY5Vm3Sgx+0SMd1CXr4QkvXrU5o=
X-Received: by 2002:a05:6402:4541:b0:61e:c6ae:7a58 with SMTP id
 4fb4d7f45d1cf-626a1f9b6a2mr267968a12.0.1757435417828; Tue, 09 Sep 2025
 09:30:17 -0700 (PDT)
MIME-Version: 1.0
References: <20250909090659.26400-1-zhongjinji@honor.com> <20250909090659.26400-4-zhongjinji@honor.com>
 <CAJuCfpHVzRtUQukO0kZP072vCu89DwOEAocS571b4sGxMc6Zow@mail.gmail.com>
In-Reply-To: <CAJuCfpHVzRtUQukO0kZP072vCu89DwOEAocS571b4sGxMc6Zow@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 9 Sep 2025 09:30:04 -0700
X-Gm-Features: AS18NWAA3gXYcKcu6BJyCASw1JY2Tg5yKdBcwtKDAMzJA7pfY6LSVb0ENi0HJp8
Message-ID: <CAJuCfpFKyPht_31Xq+a7YXhjxMWCrucdMSjJS--YnzMf6npqoQ@mail.gmail.com>
Subject: Re: [PATCH v8 3/3] mm/oom_kill: The OOM reaper traverses the VMA
 maple tree in reverse order
To: zhongjinji <zhongjinji@honor.com>
Cc: mhocko@suse.com, rientjes@google.com, shakeel.butt@linux.dev, 
	akpm@linux-foundation.org, tglx@linutronix.de, liam.howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, lenb@kernel.org, rafael@kernel.org, 
	pavel@kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, liulu.liu@honor.com, feng.han@honor.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7D4194001B
X-Stat-Signature: pryi7w58ujdqxpkdj8ej69uhb5y8ew3r
X-HE-Tag: 1757435419-664418
X-HE-Meta: U2FsdGVkX19652NDBZoL0xsYUojcq1xyIVw4yK1auA1a1oiJx7llq2iKobniWQeOXu/zaabEvFcrS0y/yFuJDw+DGFTpYetTOxeac1sU//51FiXO0+/PlQhZ7tutM7CCbMzRFJkjk0ETVdINYNJ3n+M5xS0WCjHIae5Y76UHd2p3WWwFyIjBjU0MPgMruKD5FcqbW5ZKjRoi9MC8Jue81iiUpdGv9RIldCOEkTbEjldOZnaYAth8i53gdQS0AwHOJJs4CmtdOuhhpx8p3NTfwyo8NjGUEs9xW2BZ8fador5KaJhtUv2qEeG0sT3X8WiX7iHQJnNLb1Wiwg6Wkq/UByMD62B6y2r3Sy5hH8Bd57lW+R4lFR7pMQoC3uv3eRsWVPcvWqnE8xh492DauzEVf5jho0TqAySJdLX7DcAt9o4a3ph5k+wuPFEwZU1KPFrvLYjuXCUJnyVZVU75ekgO51C34IVaq6cLgDGRmdLPB/+qKtXnT8yqSrFhAMml3Fc9jrAZi80J4UbkeAG9mftdCDdWTTBlbugs1nYgjPr4w3btUyMeyEVJjVBZzNi4poG4LAlukH4vnNi63+do86S3NVF8bqvRsjVFL/6QJf6rBGnJc2UJzfQuWP9e86NZPw1rNBr2OokIitbEqm66H3+bMuOJGqCSJFjJtfEnlVzjvzdMir3T2zg7C5LEUP8hiGefuMELf//dbMx7f9PrvoK1CAysfuEpfMHpBBtnblUX4OeUUXW2cv+KDqcAkHUMGz+G08KpnKIHnUGJ9R/VE1RBh4T+omBj9InHbTSM2eUkgTpSuXZk3FxvCTcgreLuBg3tNxAnd4kowiloHwaoIRFVhtiYepKkRE2wr3t0UHN9LKr8F4KmaN2hopveOqYkghLYlCDFPuqLiGGDmi/zXStLl6QV4A86JMWj5tHWXMQLszZl49BAiBwEX+saRu0vrHkAL50MgmWG1z6LYIm1NI+
 +WmkFIXk
 HWUrTTy5xuSAaceeq5KUsdHHVES9Zyd/acpVNB3i4U0lfOshSE0VuEb+nhD6BoQqCVI1CSnX9XOaTUNfu/fQ6ybWntEiP04xIS+TSSnPdqAF3jZaZJZjtLRMF4uYoo0P366pGV93Wu8T67AZfDIdFR67uG4eITmcAK7dgClez4HN3IiThUDxgbAkjzC0lJdmGSCeyu+xS6/TDluJ1ljkJXxOsTzcZwZwv4JJEqEeAm0w5u1dURbWk8OUCkQUwCO+Fe5weqOCmbFxKi+V7yVJZ/L7Og5Skn4CCncGDQnmYOFc0/XqxIDZvjETIytrEDd+QoMIb7ZCAea4zjE0dcSMH3q0e5lxAh1/ckJw+l+St69mhxnPdc8A5cZ0yCzPnLaPjNjwLk5WO/uPF/vdO7be4Io37Eg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 9, 2025 at 9:29=E2=80=AFAM Suren Baghdasaryan <surenb@google.co=
m> wrote:
>
> On Tue, Sep 9, 2025 at 2:07=E2=80=AFAM zhongjinji <zhongjinji@honor.com> =
wrote:
> >
> > Although the oom_reaper is delayed and it gives the oom victim chance t=
o
> > clean up its address space this might take a while especially for
> > processes with a large address space footprint. In those cases
> > oom_reaper might start racing with the dying task and compete for share=
d
> > resources - e.g. page table lock contention has been observed.
> >
> > Reduce those races by reaping the oom victim from the other end of the
> > address space.
> >
> > It is also a significant improvement for process_mrelease(). When a pro=
cess
> > is killed, process_mrelease is used to reap the killed process and ofte=
n
> > runs concurrently with the dying task. The test data shows that after
> > applying the patch, lock contention is greatly reduced during the proce=
dure
> > of reaping the killed process.
> >
> > The test is based on arm64.
> >
> > Without the patch:
> > |--99.57%-- oom_reaper
> > |    |--0.28%-- [hit in function]
> > |    |--73.58%-- unmap_page_range
> > |    |    |--8.67%-- [hit in function]
> > |    |    |--41.59%-- __pte_offset_map_lock
> > |    |    |--29.47%-- folio_remove_rmap_ptes
> > |    |    |--16.11%-- tlb_flush_mmu
> > |    |    |--1.66%-- folio_mark_accessed
> > |    |    |--0.74%-- free_swap_and_cache_nr
> > |    |    |--0.69%-- __tlb_remove_folio_pages
> > |    |--19.94%-- tlb_finish_mmu
> > |    |--3.21%-- folio_remove_rmap_ptes
> > |    |--1.16%-- __tlb_remove_folio_pages
> > |    |--1.16%-- folio_mark_accessed
> > |    |--0.36%-- __pte_offset_map_lock
> >
> > With the patch:
> > |--99.53%-- oom_reaper
> > |    |--55.77%-- unmap_page_range
> > |    |    |--20.49%-- [hit in function]
> > |    |    |--58.30%-- folio_remove_rmap_ptes
> > |    |    |--11.48%-- tlb_flush_mmu
> > |    |    |--3.33%-- folio_mark_accessed
> > |    |    |--2.65%-- __tlb_remove_folio_pages
> > |    |    |--1.37%-- _raw_spin_lock
> > |    |    |--0.68%-- __mod_lruvec_page_state
> > |    |    |--0.51%-- __pte_offset_map_lock
> > |    |--32.21%-- tlb_finish_mmu
> > |    |--6.93%-- folio_remove_rmap_ptes
> > |    |--1.90%-- __tlb_remove_folio_pages
> > |    |--1.55%-- folio_mark_accessed
> > |    |--0.69%-- __pte_offset_map_lock
> >
> > Signed-off-by: zhongjinji <zhongjinji@honor.com>
> > Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> > Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> > Acked-by: Michal Hocko <mhocko@suse.com>
>
> Reviewed-by: Suren Baghdsaryan <surenb@google.com>

Apparently I misspelled my own last name :)

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> > ---
> >  mm/oom_kill.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > index ffa50a1f0132..52d285da5ba4 100644
> > --- a/mm/oom_kill.c
> > +++ b/mm/oom_kill.c
> > @@ -516,7 +516,7 @@ static bool __oom_reap_task_mm(struct mm_struct *mm=
)
> >  {
> >         struct vm_area_struct *vma;
> >         bool ret =3D true;
> > -       VMA_ITERATOR(vmi, mm, 0);
> > +       MA_STATE(mas, &mm->mm_mt, ULONG_MAX, ULONG_MAX);
> >
> >         /*
> >          * Tell all users of get_user/copy_from_user etc... that the co=
ntent
> > @@ -526,7 +526,13 @@ static bool __oom_reap_task_mm(struct mm_struct *m=
m)
> >          */
> >         set_bit(MMF_UNSTABLE, &mm->flags);
> >
> > -       for_each_vma(vmi, vma) {
> > +       /*
> > +        * It might start racing with the dying task and compete for sh=
ared
> > +        * resources - e.g. page table lock contention has been observe=
d.
> > +        * Reduce those races by reaping the oom victim from the other =
end
> > +        * of the address space.
> > +        */
> > +       mas_for_each_rev(&mas, vma, 0) {
> >                 if (vma->vm_flags & (VM_HUGETLB|VM_PFNMAP))
> >                         continue;
> >
> > --
> > 2.17.1
> >

