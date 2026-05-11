Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73A34CD4855
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 21:41:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3AEC6B00AF; Mon, 11 May 2026 17:41:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C12CD6B00B2; Mon, 11 May 2026 17:41:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B28726B00B3; Mon, 11 May 2026 17:41:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 99EBD6B00AF
	for <linux-mm@kvack.org>; Mon, 11 May 2026 17:41:05 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 578201A0278
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:41:05 +0000 (UTC)
X-FDA: 84756459690.16.9097CE9
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3B266A0004
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:41:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amlalabs-com.20251104.gappssmtp.com header.s=20251104 header.b=JH8iQrm9;
	dmarc=none;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf25.hostedemail.com: domain of souvik@amlalabs.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=souvik@amlalabs.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778535663; a=rsa-sha256;
	cv=pass;
	b=2jgc+mtL39CnvxjkoQECW8lkZ8y1mKsjMmTnEByiBZgHaSWoMF4w5bhT8PIIasTw4I+glr
	Oj3QmIXF7K0PhCxttjf4qfIy2cVQ1uW4cMG2RwbVJiO+AMVhHISK2rbq+OhCyzmDXMTnYe
	B4Fw02AkCG1dlnMXBmi+Evt6Hy2HPwc=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=amlalabs-com.20251104.gappssmtp.com header.s=20251104 header.b=JH8iQrm9;
	dmarc=none;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf25.hostedemail.com: domain of souvik@amlalabs.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=souvik@amlalabs.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778535663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nXGS2COif/6iKudvleqhAUyTu2yl4tq3AvaH+a188Uc=;
	b=iUzcpBC8NtKNDcncj3OfFqzEthQZx0AENiDcGkPe88XliEQD+/wHh1zldGWKBUzp2/ucnM
	+M5IEO7sN2mY/n7lLk9r+ylSwXusZg+6F1XsfZAbTobo7PJT4hCbuC9vCuKfIEIa/s29K1
	tzjc4sAdg4Le4PagjdIrgeQeJAqEoCY=
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-393a44854d2so37989671fa.3
        for <linux-mm@kvack.org>; Mon, 11 May 2026 14:41:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778535661; cv=none;
        d=google.com; s=arc-20240605;
        b=BpIrupGVbjXLdHIyaO1HNO3nDl1wMboBLsbuFI97r1wfjPF2ezTpubw2OFJxhOXBNi
         a0zivuyUTdkmgcDiJGmzj+M5AEryO3d/a2DeOpueHtT8Xlr29ccNKZOiTKcEWdqVymQU
         6xXXGbABsOIKvU/CeURDlfIdNy9ZNMsulA4t+tgpPuJXMxl2DouWmNYDvpcNSR7uoWef
         TkmVP95EQv0360HxDt2jLpQN6wVJSo9BjTW2TriD3bIMHqDKOhAyXx/eFkbZ1JnaWGgV
         eTcSh/L6FMA3goBGtBuVPZZ8kZo2qjAuI2M0H54WIFnm+zsB/PbAVKJHKizf9VuNVuc4
         jeoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nXGS2COif/6iKudvleqhAUyTu2yl4tq3AvaH+a188Uc=;
        fh=IZfRCHVMuLbdRGCosHIkc/TnoUeMlq6Op5QBA2JOUik=;
        b=W9brcnXCtDbSBIVfTrgA3Oq4/GF8quWRrUfgDiz0HrmWxsrgGv6JYuL0M/GfInZNlT
         T0XHHjXDduvwqrkVqg2Q+XkVlJbuUqsftcHpxu/gq1DtOeqvV9TbvrSZRnS9cClbpEXO
         /+4PvzG8K4i+DDwRLajl9RQEauG28VTbftvIu0LyL4ZUjQeD9NOIIur3d2kLRVMQsBDL
         RREffmRGFa8BYxfZFLGYKoWsW2BDgZLXozxXf6JBfl965lkg0ZZR/tYUozxhTW8EVtY+
         ZdVkIFFTbBiJiD0fvZZW2vou/Q8HPSeT2DsXM7ug6pwo3YjA5OO4gj6XiYrwi9t3gwnW
         8/gQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amlalabs-com.20251104.gappssmtp.com; s=20251104; t=1778535661; x=1779140461; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nXGS2COif/6iKudvleqhAUyTu2yl4tq3AvaH+a188Uc=;
        b=JH8iQrm9hFLytfZ8GA0hBrhIG8Zm74k36T8VFljgTiq2/5cBi5zZ1pJsOhrRh+Ekkj
         YaDpZoc0e3BBz3IujcAvdiqB9as5Hqq7huJD3NyxvHljRJHfLOG4tp8R3zWnwnaCsLnG
         c5UKGWdDasP6dNnbkGf1JTxNl/1mPhRLr4wPHfn7IX5/6w6j9q0YfzAHy1kKc3AdaxeR
         NN3DayIS48ehpSsApPUAKHUzb+MMG7FjFCcI7BBJ6L7cMySXCixjDx1e/CnRR7guwAAD
         F3c8Jz8gItnl77myaFOMt5KNjMkiY0zdA6mFfp1OYT9/8zX+tvahpeD3cwEiwztsCKdZ
         w6Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778535661; x=1779140461;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nXGS2COif/6iKudvleqhAUyTu2yl4tq3AvaH+a188Uc=;
        b=FUsfP307JhaMAqed1EjcbJLqmS/vBn76NF5heiKE794xjpJA+WzJ1N6vNda9/HBHVs
         2rcGsHgZADnQHNY/OQXtqVcieHVLGQlWhYO9L51592t1HgEKZRhAtPIsp/IIp5Jesrqu
         74OmIyqrQ/FgNQVC++yeWNYxUPYwdJCTl46ktCbcWoKdW682HW1/sLhlzZJFa7DtiHcZ
         7+GJPenVMckLocA7o8/u0sgdyAOOWkSwb/gYrzFLBOt91Si1VAzczqUuzwMsR9rbFmtI
         q8C1fmpcW7tRX0HnXahyX/RO2T50DM/tLGdZaAgGNsl7hJK7LDMM2nyEhZIm/fG6e19e
         WsFQ==
X-Forwarded-Encrypted: i=1; AFNElJ8znqINuqeAghVPCh0K3gsS3+Mo95Nsv4ltRNFsTQLXHIGOq31isGlvdMIPIbuuFIQKB0iew0t9Rg==@kvack.org
X-Gm-Message-State: AOJu0Yzy7uZ4YZOxz9pjrgqAgHLAmX3px4zGE4TGTsIT8ppiWA3yDEMp
	74LKVhsHCI7bp8Q3/akUibv8gorGangBCfAc1RAqPM3cl7FG2HOz9BXTRGFxb5BJahejd+N7d+b
	nC+rmujv6kaCBjdL2thwmDvEY5OEFob2C0eWoPTQmtm0=
X-Gm-Gg: Acq92OGb39um4154U35GpclIDrR/43HO/RxQejeYRh7Z67FE/uungPc/rDRhsj30M2s
	OaqpZou+r69Cx6qZlIqXs3DN9LAs/QpGp9/LWZZVdNnvnLyNxlsl7H+i/cA+kTBSYj5T7EcEuwb
	2hqIfkqybMemiibabXuLVTGml/R8sOdCeuowjMWcs5/3G9Fn6yMWsB+ze8qcl7+Iaz9vFdlKpLH
	rhVz8yF8DDX96n2/s29RdVngM6DY1dYhpOwfhdLV+h8QmQoU2ZSVMBzhyUsfbceCW1HPOlOWqX4
	its86VXWFVFHK3KtxThuOCRKHHE3hcWRHOGTLA==
X-Received: by 2002:a05:6512:acf:b0:5a3:eb4b:37a7 with SMTP id
 2adb3069b0e04-5a8b6c9c525mr2973242e87.6.1778535660345; Mon, 11 May 2026
 14:41:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260501233933.2614302-1-souvik@amlalabs.com> <a708a295-9d80-4538-9d12-53c12820f9ed@kernel.org>
 <af4SR5-QwUCAClR8@nvdebian.thelocal>
In-Reply-To: <af4SR5-QwUCAClR8@nvdebian.thelocal>
From: Souvik Banerjee <souvik@amlalabs.com>
Date: Mon, 11 May 2026 14:40:48 -0700
X-Gm-Features: AVHnY4IWwwENmh7P5b_KrrZMmOGLtrgr6q2JnnDVvjY__BAFZLDH8ZYDhGP0lUc
Message-ID: <CANCY+o6T8eSnkw_mETH=kd9JDxp9tguHWnaU7L6Bp-sJMpniSw@mail.gmail.com>
Subject: Re: [PATCH] fs/dax: check for empty/zero entries before calling pfn_to_page()
To: Alistair Popple <apopple@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, dan.j.williams@intel.com, willy@infradead.org, 
	jack@suse.cz, linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: rdc9m9j9gzt1s44srkbqwis9nrig3xxy
X-Rspam-User: 
X-Rspamd-Queue-Id: 3B266A0004
X-Rspamd-Server: rspam07
X-HE-Tag: 1778535662-354997
X-HE-Meta: U2FsdGVkX1+zNr/A7+i7h00KH2XOOy/qfHdMnNCECR7+LMBY/EMj3vD7XTpAo6dwi2zN0+ejr/PDANbiIoIDT2tJRpIxTCyaOmgPEw0nZJ8UF8bq2S52RdHrVfr9u+9WEvkX4w3HAuzHkMWu9NRQXs3lufknC24xLccR3Bu2xWU0hon0k4tllB7QyNWHb28RMWfWlgOgoNF9/jRP4ljD1MNKoR9GCjzxXkbybmaBFwb9nhbj/gozGjt3wn9pb8WT7E2FKutK2tWtZYbiayLSk3y+ixbgGOx37iSU3N6ljQm9NKRmCcx3mhufW+MQwpmcmtmIRq8gJ2Rsu3WfGVSjx5eb8o96sfkR6Qo6QqInGy93iGR/6dm9chX/8poU7UTRdfvSUUervtqjLpJriWeye2AjXISyXetjNZ66DuWf1UKxey8gSZO3BGwnBadtD2PFKs2hBdmsKwgW3PZXjeiCw25MZ4dkwhK5bhKgEuTgG95GcXLeYdw1ovYRengEidyrjWGQ429hBDlG+brvJNejmdXStwwoGXJm+TzNap8Q7RVACXR5tjRGslKeNPM9E1q0nGIuV2OSvh7iTYyqD+jgU5f8Sl3euVLv/l/rUg+Cyd+CXsQAQyVCP9Zpk/Xe4R1X1DSVpc3rAh/wjADyDGhjIAGBPXFBFm/9njpRfmgd7gLl6A3qPHuwEnjDFBR0Dza2R0VHi2KjVwBCbggcW565HprtNXNM9G+wCzAVEshRekNfeQshjvP8pZBILsrJJgGBfTPoSY0XahlHTjpfQHw9U4TLg6s7iPLrkbebRs52ULHYIqU+WS33ofxxdoX9xEIwtCQSWwlFsxdg8y9KFWWYSV0Gs4a340Sbufmf6R7Aui68AxlbL/LEHPXfilNdfeOQ4AfRY6VTp2w4NeCMVBwRPX6uxXV4bLm6ewNirNmIfT02biONwqKZJincBJbrCCR6YK0fNLIum4kHxe7YHtA
 MHXFZahZ
 LeNm5K/YH0/d5pjC5buWhkp56PQfuLFoU8kPqk1i6pP8/vJGOwBroCa+4ayuXHtVf2i9Y6pxdArJctDA77pxVnn1deCyKg9mGbLLO5hRCSjp5JptMOSjM+Ali5WzvObjVx8TfLzHRao9fKZOFsGcuuITbfIcccijZ1IsGMjYuCmXck+p0Fs7l28NLeBT537bB0xgcZmLu0JTfZjf6LrPD6nM5uEpy4o6uaXmmvEEEOpm5UHZ/uefRsWOMqmf6ycIVhPq9zqoPnW1IixuhosIZUXnDM2VGJPr3Lw6dNX/Qjk6PIWIktmoQPOjPSYUIubnP2OUdkTNpSxi/E2ijiQ81ELPVl4Yd14WGj63HoLrysfv80n4nhZ9DqtzJz5j8zkFZc+GjqSacmKm7dzYS0Y1nfcZhIE7MnYLFumThYV9ICWfxfL4esWmczAXmcz4spfF5n8AluD2N7zJaPeE9CWA9rtgCBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the review, will send a v2 with this feedback.


Souvik Banerjee


On Fri, May 8, 2026 at 9:44=E2=80=AFAM Alistair Popple <apopple@nvidia.com>=
 wrote:
>
> On 2026-05-08 at 19:15 +1000, "David Hildenbrand (Arm)" <david@kernel.org=
> wrote...
> > On 5/2/26 01:39, Souvik Banerjee wrote:
> > > Commit 98c183a4fccf ("fs/dax: don't disassociate zero page entries")
> > > added zero/empty-entry early returns to dax_associate_entry() and
> > > dax_disassociate_entry(), but placed them *after* the
> > > `struct folio *folio =3D dax_to_folio(entry);` line.  dax_to_folio()
> > > expands to page_folio(pfn_to_page(dax_to_pfn(entry))), and page_folio=
()
> > > performs READ_ONCE(page->compound_head) -- a real dereference of the
> > > struct page pointer derived from a bogus PFN extracted from the
> > > empty/zero XA value.
> > >
> > > On systems where vmemmap covers all of RAM that dereference reads
> > > garbage and is harmless: the early return then discards the result.
> > > On virtio-pmem with altmap (vmemmap stored inside the device), only
> > > the real device PFN range is mapped, so the dereference triggers a
> > > kernel paging fault from the truncate / invalidate path and from the
> > > PMD-downgrade branch of dax_iomap_pte_fault when an entry is being
> > > freed:
> > >
> > >   Unable to handle kernel paging request at
> > >   virtual address ffff_fdff_bf00_0008 (vmemmap region)
> > >   Call trace:
> > >    dax_disassociate_entry.isra.0+0x20/0x50
> > >    dax_iomap_pte_fault
> > >    dax_iomap_fault
> > >    erofs_dax_fault
> > >
> > > Close the residual gap by moving the dax_to_folio() call after the
> > > zero/empty guard in dax_disassociate_entry().  Apply the same
> > > treatment to dax_busy_page(), which has the identical pattern but
> > > was not touched by the prior fix.
> > >
> > > Fixes: 98c183a4fccf ("fs/dax: don't disassociate zero page entries")
> > > Fixes: 38607c62b34b ("fs/dax: properly refcount fs dax pages")
> > > Cc: stable@vger.kernel.org # v6.15+
> > > Cc: Alistair Popple <apopple@nvidia.com>
>
> Thanks for fixing this.
>
> > > Signed-off-by: Souvik Banerjee <souvik@amlalabs.com>
> > > ---
> > >  fs/dax.c | 6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/fs/dax.c b/fs/dax.c
> > > index 6d175cd47a99..6878473265bb 100644
> > > --- a/fs/dax.c
> > > +++ b/fs/dax.c
> > > @@ -505,21 +505,23 @@ static void dax_associate_entry(void *entry, st=
ruct address_space *mapping,
> > >  static void dax_disassociate_entry(void *entry, struct address_space=
 *mapping,
> > >                             bool trunc)
> > >  {
> > > -   struct folio *folio =3D dax_to_folio(entry);
> > > +   struct folio *folio;
> > >
> > >     if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
> > >             return;
> > >
> > > +   folio =3D dax_to_folio(entry);
> > >     dax_folio_put(folio);
> > >  }
> > >
> > >  static struct page *dax_busy_page(void *entry)
> > >  {
> > > -   struct folio *folio =3D dax_to_folio(entry);
> > > +   struct folio *folio;
> > >
> > >     if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
> > >             return NULL;
> > >
> > > +   folio =3D dax_to_folio(entry);
> > >     if (folio_ref_count(folio) - folio_mapcount(folio))
> > >             return &folio->page;
> > >     else
> >
> > Makes perfect sense to me.
> >
> >
> > What about the usage in dax_associate_entry()?
>
> Pretty sure the issue exists there as well given this code path implies w=
e could
> pass zero/empty entries there as well:
>
>         if (shared || dax_is_zero_entry(entry) || dax_is_empty_entry(entr=
y)) {
>                 void *old;
>
>                 dax_disassociate_entry(entry, mapping, false);
>                 dax_associate_entry(new_entry, mapping, vmf->vma,
>                                         vmf->address, shared);
>
>  - Alistair
>
> > --
> > Cheers,
> >
> > David

