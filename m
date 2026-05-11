Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 773A5CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 15:00:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFE686B00A7; Mon, 11 May 2026 11:00:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD5C56B00B4; Mon, 11 May 2026 11:00:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEBA76B00BF; Mon, 11 May 2026 11:00:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C10E36B00A7
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:00:03 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5F36E1C0074
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:00:03 +0000 (UTC)
X-FDA: 84755449086.20.DC06DFF
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4CB161C0018
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:00:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gJPqUvgg;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778511601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HXK9Qgle7Puv113jAKFz7L/yq22PTO27vhn58OjsUZg=;
	b=YB5GK+f4xPf0N8KDYZiKHkaHCSJYDI4RFn3T6FJG0prM51HPa99J4n+3kRizQJyolhCT+W
	5osy4IPhsk/Z4TW4PKUKEIhne6ywu+DIODmJkFoQPjK0ZEsDvZLtetAWDpK3o0QYG5MBP/
	Y8c3FNtviWYi+o3RsrCqnqxNJvWw5I8=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gJPqUvgg;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778511601; a=rsa-sha256;
	cv=pass;
	b=zLUeB7iw3OCvMpiHWs9G4cWLJ8UwT2D3f667dzw7jabQ1ziw6Fl0F22dJsOMEOYmtCeswX
	HAeQmwcKBA3cQwE0WzjpgssKDR9fMvrhDK9jNdtxmqz3IY74HizLw/zlLYefOCGSx3civV
	5SBvXRLPqNm67xGR+ICK32je/+Deks4=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-67179ed133dso5342356a12.2
        for <linux-mm@kvack.org>; Mon, 11 May 2026 08:00:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778511600; cv=none;
        d=google.com; s=arc-20240605;
        b=UhxfO8iTCWpnXr0/iXnpgG9OrqdopM5ekZHRP0g6cIEiFrEfu2+lI72z8Cy3kK4vO1
         ozvOeGSv2tPiuuSqs4xWOvswKy6REMlPG8B0hooJZZforj/3YWbxa0VT4Fi6CeuwwL4i
         wTUTsv+b37AkEyPEWSGdzt8Sslvcqg1PpLzkiIE+mRT4TlgxHA1Sc0VZ+lcMtn55qgUZ
         EP1uCn9fI9D7hhbkwSjBqOnowpVioAT3ZLmIhXQDYza//J/ZWSKB+1GHjlCD9XwY8Un0
         6BvjSlX9jYhP7AcI6dVjiCYYCgPkyp/m6aEnF7qVtrIRfjHj1+88BqOosbhHhjtqpBFp
         PVgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HXK9Qgle7Puv113jAKFz7L/yq22PTO27vhn58OjsUZg=;
        fh=RliXjGCfjjJpfhqR8QCsILsAp44EZOk7EEmKbvyT/Sk=;
        b=Mw91/lJDGQOEvqQVvH43MLSX7nwRgW9d3QoZP8/qlbQpzY3X9YFZoTLTQrBMJQ8YkO
         dBCaQ/7bqH5ImBkMrFFwItNawsxs+XekJocirOI+oT8AzCQw+YMzZMfKkJpR8PURxhVu
         NWStppG8ffeVeqKzA7aU4gwGcmpzlxYJnQRCW9j7yizN1PGTo70RnWyjTy9DtKJrWLaN
         2wZxMAzXpiTyUPMkUqRt4QFq4XP476V97o7MyuW10MyJAsSaToEus79a0OvX+oQ6PEEK
         ap4BM/nd62ggERhvOar914Nl0F07aYhrGtwImAHp6EzJcDmDURitbaTrS3wTsSumO9Ba
         Rjbw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778511600; x=1779116400; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HXK9Qgle7Puv113jAKFz7L/yq22PTO27vhn58OjsUZg=;
        b=gJPqUvgg26+WyPm8ME6acLuUYUYcZ5Q2m15nGRG1+mqL4Kcfz1Whvv974kn451wpO8
         nfLHVHOrOFa9apL1sHfhQn1secNkD+ihMoC3nFTtijWwIfYFaL17PzbhP/K3W0tpOuDQ
         1BRnQvxYXFwSB8WBzthhYz15TJTzTsEwxhqycMslA8k84PfRvmWpDJF3eEleNSsal2s7
         MHY7delzJ5QjoQLvq4EAWPrQsRA87uE8+NsKEVWv7Nj8mDDO3yAlFxAZvjAryNw6J5sr
         k7kLsx34DTck1F0NMcylOBGg1zxwlKobDbKWzdWi7atD4zfVefmUDGsB98JIXJvVJerz
         BvuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778511600; x=1779116400;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HXK9Qgle7Puv113jAKFz7L/yq22PTO27vhn58OjsUZg=;
        b=hj8Jm2IM6W5t6nyh58AF5yRs2E2n3IUr7AKsP1Mb1gnuIhPfSADcUaC+uak1Mtx2VL
         nvtWT0FBntrCQ2d0wdspWk/fgCL5mrW15yZGwt2oUxmbmZhFw49M6hm/o4/j8XgsYymk
         hWMxVXyEtFYAugIq1iT5EW113rk8YisMyMHW0atvlis9Ei0ZBqlIjSL4+F7FqU9FfVE8
         3gnq/suDg9vNXfQi6LQlaFASJEgSNSqCGn9N0xvaRT/zq3HP5C4MWx9y7EnCa5hEkGwt
         kqDK9aJSGlF3kWf9cbkLnsasdAYPPHJU4QxXAFUomymzGfqjOT6AWTH4sZbsRxhB80Jr
         63JA==
X-Forwarded-Encrypted: i=1; AFNElJ93/Bxzd7tmzvGM0BR9yIdeU3gz4k4I7wFFJA/owcMtraJqMEBD5DNA1uIko7BKRWhqnZc3WzfNxA==@kvack.org
X-Gm-Message-State: AOJu0Yzj7DYuYngn4PWmVp0tZ+aXsROa37F9DKyWCgyRfA3MxXYsHOOV
	ehM3LvHh3sgNu1JoiFSV31G+XQUewA3t4RPQfFdDHRsC+3m7wphcWGMaPI5ljMWRQwenFokoxMn
	u5QVaLYv02WbZDfaGGSCXx+i6e15VQT0=
X-Gm-Gg: Acq92OEMqhYWsgfd6CNATfr2ANUfc7yeBbbNuE31Gp3CP0I0/AffmCbDPCKNZSvCMuD
	Y0jEUC4SbISaneAuh/MzsqN6HNEB/hZOyxBoKrXfC4t7JfqpowgM6C6UnO8bHs45c9W7VqSqgr9
	LvvYhYAQJ6ufmp3+XUsy1crGPeN2shUa+OJT4ExskFuUSAV4Jl9AIIUejqkR6lalW+7GRd1DG0Q
	98qctmPvDuGYldswmYRwYHRmmtBQiZVqGeQcKUxoIlGkcL7/hPcZ2ILqM/2AU4XeVZubcuKevxW
	ima5IU4mEKgIX723bVYrbILteQiqCaOcKAgdbolb
X-Received: by 2002:a05:6402:a587:10b0:66b:f527:c69d with SMTP id
 4fb4d7f45d1cf-67d63d8b66emr9561584a12.8.1778511599490; Mon, 11 May 2026
 07:59:59 -0700 (PDT)
MIME-Version: 1.0
References: <tencent_8B437BE4F586C162950BF71954316C1EDB05@qq.com>
 <tencent_CD11FE9B4A0B362E95E776C5F679598FAA07@qq.com> <24edd9d6-99f2-4d3d-83eb-69b406f4a9a0@kernel.org>
In-Reply-To: <24edd9d6-99f2-4d3d-83eb-69b406f4a9a0@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 11 May 2026 22:59:22 +0800
X-Gm-Features: AVHnY4JN-XJcvjTgr_FM1HBFd_31lstixyAZ5EE20tY16YbXFrjdSuhpS5x5o2A
Message-ID: <CAMgjq7Cokjb4-F9=cvwKmWR0q4==Vd61FHnjKbRdSHKH57erxw@mail.gmail.com>
Subject: Re: [RFC PATCH 4/5] mm: swap: fall back to order-0 after large swapin races
To: fujunjie <fujunjie1@qq.com>, "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Jonathan Corbet <corbet@lwn.net>, Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Baoquan He <bhe@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 4CB161C0018
X-Rspamd-Server: rspam06
X-Stat-Signature: hrrxtcsm99wr8ziroe8a4whdm8izem5w
X-HE-Tag: 1778511601-416632
X-HE-Meta: U2FsdGVkX19XJFhN4NMXCL4kwayu6oZygG0D4cuMvEazBTkHnxt7T5mNdhe7kbkPWrMJsFrWc9t8jodQOW53UyFiKmvm2BLu9C1bMNYjKO0YLw5KChvs6hjMEHevh60pCvvTY7kBjmdOWuVpwU4ydPQdEzCCwlHeA6lLBT/UFw0/Gmw1tU6CJYFlToJN3SuVIb3ls/cHvRHx17h6tx2iEB3jXdRkV57NecZ/MS8Ch2rJC2CkAZIQJBauUToMV/7ACai2R7hCi7xcsciZv0BLRJbAXUGLwpQsqNoNhhDoSQt9NdQ25uMnj5qmR2Ow2nu20zUPc2JDez1pY8MsUKONbXEPIvCVLouFtgsJuRu1sXMKYArZmB9jIbJaXlX0J0D0npAcim/+NQhw76zJDD4aGUJ2ZOL6qiJQbOaIxw7p0jR2iiMJhKJ1UYrvhv9cd0KPb1KCY21hgNE0i8zzwVu4UmxzTwDCjpL7API+KGKgQq9QbD/r0aDsjZT6L475ozQnw3LEgZgrXlsHvi2Q1zoZBrrlbxqmLTw2zBEmgi1jMbNqew/JGoHaPiivZ9bQpGq+LFeQa8mORpysJ12ub6t8xrPDkZdoJHB5W/d7ZeRpcm5wFrL6KOIw3+veZ1HtDN/ZSDNOVcedoCGPCi1QAngrHi6i4Aopus+T1EGalujb56rRJxhm5QfjRdKavGrdIX77hx8YfJkNZcX98Rryrza3R6T2ZrvumVbesDyX0POZ6NidjiEd6yvfgyZATKOH6V3U+zQRHlZmnub10uE9lViC+6dzmZjmBP6k/6Km8WhnNV83BabosCTJlNvWf071HCHS45iVCvYkcXjoB9nuvtkRbCjEaRnxseQ/9cWHIPrCAsw71dxLFrKSIVf7X0ayBDUbd4H75FQhLIxDpBFHDS60t6i6lNCp5OK7sOIT0SnDGVimk8Z/Yh97GC7Pp2o7M5MmyP1jUDwA4T4CN1jlFub
 ZWH9tK9D
 X4FaVeTBi4+MMsLNPui2KUw2s+mPai9RvOBS1Q78ObuRCRzSOT/LuL+fMhNMhq1qWRreyQHOSFBEG3Nld7sAnIFSy7oyBfL3/nCklX+fbE6fcqECNqD7B0/Z4dwPfWR3Is/tsXuwJxEZOCLGrZSWNCil8gIXP+HGpAUbKbvDYxQLz1TfkWkHMzDpYrJgMxgTn3eA6IomBEU20iQ2cFiVzRg40W7vczq2XQhEIxpZWoLoNutOKg0GrLftDEJgmTInAXe/rTQXLVgUwfOIhiWkXSsyb/1V9nHSk9a4/C31qp7gTBVd3IDtOr55SnvYda7T0pUOIs/ngsnLu7ljsU6rn2tlrDLh/qBWJkDCF5CkTYCasn4XQwHgDMAQaalCZ+FgUQ+oSup5xFbh/Ak9UmntYQZSCRuzC65RezegSkGB4YL2XnNTIRmF5/WLBz2ONrYmTU77Ax3M8RluQeRTWxMiCbSXcKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 9:14=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 5/8/26 22:20, fujunjie wrote:
> > swapin_folio() documents that a large folio insertion race returns NULL
> > so the caller can fall back to order-0 swapin. do_swap_page() currently
> > turns that NULL into VM_FAULT_OOM if the PTE is unchanged, which is
> > harsher than necessary and gets in the way of rejecting large folio
> > ranges for backend reasons.
> >
> > Move the synchronous swapin sequence into a helper and retry with an
> > order-0 folio when a large folio cannot be inserted into the swap cache=
.
> > Count the event as an mTHP swapin fallback before dropping the failed
> > large allocation.
> >
> > Signed-off-by: fujunjie <fujunjie1@qq.com>
> > ---
> >  mm/memory.c | 50 +++++++++++++++++++++++++++++++++++++++-----------
> >  1 file changed, 39 insertions(+), 11 deletions(-)
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index ea6568571131..84e3b77b8293 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -4757,6 +4757,44 @@ static struct folio *alloc_swap_folio(struct vm_=
fault *vmf)
> >  }
> >  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
> >
> > +static struct folio *swapin_synchronous_folio(swp_entry_t entry,
> > +                                           struct vm_fault *vmf)
> > +{
> > +     struct folio *swapcache, *folio;
> > +     bool large;
> > +     int order;
> > +
> > +     folio =3D alloc_swap_folio(vmf);
> > +     if (!folio)
> > +             return NULL;
> > +
> > +     large =3D folio_test_large(folio);
> > +     order =3D folio_order(folio);
> > +
> > +     /*
> > +      * folio is charged, so swapin can only fail due to raced swapin =
and
> > +      * return NULL.
> > +      */
> > +     swapcache =3D swapin_folio(entry, folio);
> > +     if (swapcache =3D=3D folio)
> > +             return folio;
> > +
> > +     if (!swapcache && large)
> > +             count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK);
> > +     folio_put(folio);
> > +     if (swapcache || !large)
> > +             return swapcache;
> > +
> > +     folio =3D __alloc_swap_folio(vmf);
> > +     if (!folio)
> > +             return NULL;
> > +
> > +     swapcache =3D swapin_folio(entry, folio);
> > +     if (swapcache !=3D folio)
> > +             folio_put(folio);
> > +     return swapcache;
> > +}
> > +
> >  /* Sanity check that a folio is fully exclusive */
> >  static void check_swap_exclusive(struct folio *folio, swp_entry_t entr=
y,
> >                                unsigned int nr_pages)
> > @@ -4860,17 +4898,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >               swap_update_readahead(folio, vma, vmf->address);
> >       if (!folio) {
> >               if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
> > -                     folio =3D alloc_swap_folio(vmf);
> > -                     if (folio) {
> > -                             /*
> > -                              * folio is charged, so swapin can only f=
ail due
> > -                              * to raced swapin and return NULL.
> > -                              */
> > -                             swapcache =3D swapin_folio(entry, folio);
> > -                             if (swapcache !=3D folio)
> > -                                     folio_put(folio);
> > -                             folio =3D swapcache;
> > -                     }
> > +                     folio =3D swapin_synchronous_folio(entry, vmf);
> >               } else {
> >                       folio =3D swapin_readahead(entry, GFP_HIGHUSER_MO=
VABLE, vmf);
> >               }
>
> There are some upcoming changes with:
>
> https://lore.kernel.org/r/20260421-swap-table-p4-v3-5-2f23759a76bc@tencen=
t.com
>
>
> All the of that logic you have in swapin_synchronous_folio() should ideal=
ly not
> go into memory.c, but into some swap specific code.
>
> But
>
> https://lore.kernel.org/r/20260421-swap-table-p4-v3-0-2f23759a76bc@tencen=
t.com

Thanks for mentioning this!

I think Junjie's change fits better after that change indeed. And I
checked the code, it should fits easily too.

It's already strange enough that THP swapin is bundled with
synchronous swapin, we better not make it more divergent here, and add
more bits into memory.c.

And this commit will limit it to anon, no shmem, which is another
strange detail. Or we'll have to repeat everything and copy these code
to shmem.c...

Once all swap-ins uses basically the same path as in that series, all
swap-ins will be able to have similar THP and zswap THP support too.

