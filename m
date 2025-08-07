Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84B45C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 15:27:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC2DB8E0002; Thu,  7 Aug 2025 11:27:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B73268E0001; Thu,  7 Aug 2025 11:27:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A89348E0002; Thu,  7 Aug 2025 11:27:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9BBA78E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 11:27:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EC7D3BE74E
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 15:27:22 +0000 (UTC)
X-FDA: 83750340324.14.1EB47AD
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1A80B40011
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 15:27:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZLOItzNB;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754580441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xioyC2IWw8hko9lVkldYv22q6OUtLq1NUecRh4m4n4o=;
	b=xN5UBfscQ4GJ2mvoHwAfDlYmo3AmGRs7cmlti1bCvsB5sOCIfvZJ70y35ABGLeJ+pnBTCO
	s1/ituRTsWDg7aA12zIOkEqFg5dxGl/uC8DGViLxLHtPmtn3y2aXN3wPEiYIJqFdLf2dVq
	i5iYezN8WGAF5pOFSeSViG5jmC9JA20=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754580441; a=rsa-sha256;
	cv=none;
	b=UNK6ubi0+YSEkuw1i+K3MI0OCdsfH2UITb2rYZNkCMs/WYdg4Pgh/zE46q6/f8aGJb2zYj
	vOIQUARNcpCRVImjG0GZxpLLTzQhm4tRfYqnqRsUAdgqnN5How7RX3mmveahMLX2lWT7t3
	K/mnXMO8lmMob1gRioGw84Uu1oL3vkY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZLOItzNB;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4b099118fedso356121cf.1
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 08:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754580440; x=1755185240; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xioyC2IWw8hko9lVkldYv22q6OUtLq1NUecRh4m4n4o=;
        b=ZLOItzNBXjJlrIk9DvSddQ8/lPf+fp/klEeTHDpRJKt1UEtzzb9EVThriYhStkEvj5
         u911ud6f7fqEbbkuakcRVaAt8MblwMCfFunpz4mofL/cCFH+Po3hRk4dIaD4hkcR3O6g
         mUrCbTpaRnTiq3XhXq3dSXVa9Pxmf1GvjnYP/jzPIqb6DF5SS6y+UCPoICC5iHXQm+CJ
         p7CBGTNn3eAU7Prpc99E/yaejscGI3WhWEcf7+D5yVSIjVkSizbHcfvhw5WBH92EMYHN
         hkKY3Fsu0sPLy2omymGq7vQA4rSCxfVU/aMxv63K3BtJqWZt+N1OEpdLDRQEE6+byNIo
         kD9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754580440; x=1755185240;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xioyC2IWw8hko9lVkldYv22q6OUtLq1NUecRh4m4n4o=;
        b=K+u72ae0/OK8+d4w+vYVN7NTApiIFx8XsLkQMma/8tu7gzHy5XxKzPtropkDoDksj9
         9/I+BpOF1Qw8vr8rsKSsw8JAptGRikvqapZx1CdyfVSjHsyammEavHURgwfeQJpM+3HH
         Z+SOoOAUdH45UnHDojq7YFd++5oNIrf4DZR2MtlCfy33YyFcWxR9r08urx0+YxNaq+D5
         jTRThL5gNbO3J/0SuZ8/FXheXCmbqk/83cLcBPujqduASGFfqluPfnVnQbKxO/GjVYxv
         n1hsqJXWitz8/77edmC8BqtpEwWsWndLEXF0CG/F+WqOlCjes3h2ePiNOvSCir5I/csA
         xvMw==
X-Forwarded-Encrypted: i=1; AJvYcCU+x0QEVs5HH8CH8sKay92vwuH6gnBj7fwhoYYtAbnGSI8RDpVgH6ju0U2ZGk5DkW20esKHGsa/HQ==@kvack.org
X-Gm-Message-State: AOJu0Yzic4/G5x0amMtj9O6ye7G8cChHSpgWZFKD0xj+cD+sTnl4zCl7
	ewn+mSCbUrmhAEQlT2mwq1cj1gF0fzwHm7pmE1MuefP1mv5Yl4e7o0DGGos2LohJY/zr4rWu4TH
	B/1x9/XHETw8epZUvUgKzB3ZVgrph0I4hupyNUyob
X-Gm-Gg: ASbGnctSuZnacdgJgoSFg582UzXm9WpJIFgEZqydxJHjAJ5pcUf8AFflcZPTG8YZRfX
	1tcxlQAusFAWAHAnSm3vUV6kGCKoVjezgaIYhh1j5F5kCnAxv1S3wWS/zahw1JMyrx2n3q599gd
	ML8+dZ54Qlwd3+z7Ow2P1o7ZYv9q9gz6kqLlZx8ze/05VC2TtXyU+/bTeu/QGODXY+8ANTizHBc
	U3/uv1uZiOxYlrUvZTBwXYwHbOH+kFvYIY6M05E1Nck/xbV
X-Google-Smtp-Source: AGHT+IGqSzXAmTUh3Qi2CUJgK4pgM8gORIxm8uH+FHAhS4VzwkyY6xnxbuHT0p3P7PQwzevNQcRG65DrMC35ALNZ2Dk=
X-Received: by 2002:a05:622a:41:b0:4a9:a4ef:35d3 with SMTP id
 d75a77b69052e-4b0a6dd90f8mr4013581cf.7.1754580439612; Thu, 07 Aug 2025
 08:27:19 -0700 (PDT)
MIME-Version: 1.0
References: <20250806220022.926763-1-surenb@google.com> <3eba855a-740c-4423-b2ed-24d622af29a5@redhat.com>
In-Reply-To: <3eba855a-740c-4423-b2ed-24d622af29a5@redhat.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 7 Aug 2025 08:27:07 -0700
X-Gm-Features: Ac12FXw0D7Y6MNnLaNuzRlNa7wyKoBPDReSLik-x4NPnGAkXfZmI9tMKxVv_LLY
Message-ID: <CAJuCfpExxYOtsWZo6r0FncA0TMeuhpe3SdhLbF+udtbqQ+B_Qg@mail.gmail.com>
Subject: Re: [PATCH v4 1/1] userfaultfd: fix a crash in UFFDIO_MOVE when PMD
 is a migration entry
To: David Hildenbrand <david@redhat.com>
Cc: akpm@linux-foundation.org, peterx@redhat.com, aarcange@redhat.com, 
	lokeshgidra@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1A80B40011
X-Stat-Signature: 576erzxkgbu8rmgmpm3yy1xb8jshs9pu
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754580440-916190
X-HE-Meta: U2FsdGVkX1/6chDaECGZS77Xc2leHwWQY44jcRdooEVmtWn06Lk1dZY40WXL3Ud95h3/XkeKalj9apQpMlokIIgQYHpc7ygdkIai+8F0QIHsuMBWP9P72phgbgBYsBAt2cvK4wOnL/79haDUGWpuJ7QqyL6DJ0MJYTeMgHbbfqYWX8Kpw8+7bDETXZy2OjoSVHgMCa+9I4r75lNAft4b8zgqMLNp3goyGp4CDsXh9aXIcCiLiI6bGHGUmLe7r8W4dh5tw8z9J/u8Ajic9PGEW0adCh8Q8bdSQ61tZlVGQkKGXBd/E/PreKBoce8IACA5SaCvhx2VR3DHCSB/tC2b2EuQVIGQUblhvycZbQtVCSfP70zUYpY8Lh6YCgbjPjk0zjECLMlIbTxV8P+KXTVPBKCQLf7GgMc4OUdQwcajuLwg7P4BIrUcPuj2sqbGmbN4sjFvLcVL9EaMWffT89WfnqkcMMRda+AJuYlHwRxd3Q8XVNxCPpRZDfHexKDWx+/qK21ZSllHedN4PvQcnoSMT2XJQ3RsvtQKJW0WS+hVCanEdQ+SBvVicmU1Bj3g9DmwRFcloTDvD+5ImIsoqA2Q4sYA3XL6spZqw6Zi2MAh62vlJ0hgxJNzQqK9wIR6HCbGmT2TWqCLscPT2UQnAwHw6jRYJQsOiwqQOwBeEXjX/7nC42IRKi4rvtFg52kGpzXGMFr/H8U50bwCnKEz1k1bMzLsuXG/SDSF2wukrlCMmyEvd/j065q66g+7f4fTcDm6NLMHYkpxBGEQV91ifC3PN283VaSmBFTspPrVFNjuSvOBKdOJWGqaFNhQuAyy28ec3hEMb5h+n4Y8iqp31s/0EGnMpBMQ4UE3seJmuFWj4XXQb42m0db/NJNOW5NfnxJEO5znd4puzzwj44hD6CA8qdcLJ4sB7ksWOxXoXc28PXBfY3hwbC0zYDIqdNJybJg6i+HOkuFiDlbgWmI7sxk
 kN/qob4e
 HztBE2upp1zYiLqNMm7FjLiyJsudxSeiI7S7BRvIhWIii3ZPs37FTelCPoWq2NDiEQHQIDTdgWzfYvwclCBndN6OK9x/9Jq/owcWwAOhGvkiGKfO8RBBJGpKXjdsf4EZxWhUZKuMFOeVMcPRKefQCyE+/KpisyJAI1SAdiULoI8Df0n0Ehlk7Hjr5Vs+CkBVUtcR6Gc3hRfZ7frmFDtkQIPYbhzPfand+13rq7SYBw6GFdWscilYBmp542iFKC4mqAh9f/w4IG+/HZVxyn/izWyNusx1HgT8o4vuzzKqgNA7wV0occY+IgldDi5GkkaYoypaOLde7eb2wiPKxJq9hXI7+CSjrRwuxJLIuEn//fimnBN7o7qff2uKTyut7r2KSfEYlkeap5UvHKpFqaCs1HCwl2TR6GBw1ftbaZA35exbJTSmY2i40S1L+k7H8eBUNqRh/L1xfIc6kYa0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 7, 2025 at 3:31=E2=80=AFAM David Hildenbrand <david@redhat.com>=
 wrote:
>
> On 07.08.25 00:00, Suren Baghdasaryan wrote:
> > When UFFDIO_MOVE encounters a migration PMD entry, it proceeds with
> > obtaining a folio and accessing it even though the entry is swp_entry_t=
.
> > Add the missing check and let split_huge_pmd() handle migration entries=
.
> >
> > Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> > Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
> > Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693ce.0050.GAE@go=
ogle.com/
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > Reviewed-by: Peter Xu <peterx@redhat.com>
> > Cc: stable@vger.kernel.org
> > ---
> > Changes since v3 [1]
> > - Updated the title and changelog, per Peter Xu
> > - Added Reviewed-by: per Peter Xu
> >
> > [1] https://lore.kernel.org/all/20250806154015.769024-1-surenb@google.c=
om/
> >
> >   mm/userfaultfd.c | 17 ++++++++++-------
> >   1 file changed, 10 insertions(+), 7 deletions(-)
> >
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index 5431c9dd7fd7..116481606be8 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -1826,13 +1826,16 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx,=
 unsigned long dst_start,
> >                       /* Check if we can move the pmd without splitting=
 it. */
> >                       if (move_splits_huge_pmd(dst_addr, src_addr, src_=
start + len) ||
> >                           !pmd_none(dst_pmdval)) {
> > -                             struct folio *folio =3D pmd_folio(*src_pm=
d);
> > -
> > -                             if (!folio || (!is_huge_zero_folio(folio)=
 &&
> > -                                            !PageAnonExclusive(&folio-=
>page))) {
> > -                                     spin_unlock(ptl);
> > -                                     err =3D -EBUSY;
> > -                                     break;
> > +                             /* Can be a migration entry */
> > +                             if (pmd_present(*src_pmd)) {
> > +                                     struct folio *folio =3D pmd_folio=
(*src_pmd);
> > +
> > +                                     if (!folio
>
>
> How could you get !folio here? That only makes sense when calling
> vm_normal_folio_pmd(), no?

Yes, I think you are right, this check is not needed. I can fold it
into this fix or post a separate cleanup patch. I'm guessing a
separate patch would be better?

>
>
> --
> Cheers,
>
> David / dhildenb
>

