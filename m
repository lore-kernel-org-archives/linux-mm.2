Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FD18CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 10:33:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65F846B00A3; Mon,  8 Jun 2026 06:33:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 636946B00A4; Mon,  8 Jun 2026 06:33:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54CA66B00A5; Mon,  8 Jun 2026 06:33:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 44EF56B00A3
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 06:33:49 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DD6111A0A3B
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:33:48 +0000 (UTC)
X-FDA: 84856384536.12.BA2A93D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 879274000E
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:33:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b9DksW6W;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780914826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZPTWydL2gyYK6rrTGbtwML7Nkf7Wr+6W3UdOPzF34xk=;
	b=excDYBL6tcbgu95Mx/j0NjLGFkpbTFYcDwnZWZIexONnZedb6BnYUbtRo0q2j/PGBDEsyr
	3MsKg4yWZsjXT4/3ZBPFD2K+ADlLaSgJ6ul1iTAt6FNg6vDcjyfgR7YG1AACGZ8RFydjPz
	qzHEPA8kSL8hbSz8XB/APP7IBBU/mv0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b9DksW6W;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780914826;
	b=MF9cBiiLz/fIb3F3AVBat4WK0/cAdYM/XKWz0KtaZhsQKoRuTK8Et8fsNE8z/IArJAEJFz
	qVGrZZlQoXlIY/ab2nv6Z0ge9C5B1va9wM7YzzzyPIp4tMTWZNTZX0JLSxiUOI20vcbT5l
	2ga/3nPpVB15mCaaGicVEPVA0ElQgg0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780914825;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZPTWydL2gyYK6rrTGbtwML7Nkf7Wr+6W3UdOPzF34xk=;
	b=b9DksW6WoU20PpSGe5JHvBHXrU5rEVVLne2aPuafqoKW6mR70FYffntNjMa4GzXNT5lbhE
	Wsiq+AQo5xq9cbLGKCciy9IFnXK6TM+V8cL1m0khpEFCRJNGvJzutgZCmLskPrHQkJgiPs
	eHQA941Z8f3LxQRjgwES5cFkgMGTIFo=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-457-ZcMeQs8aNcCz1w5fpM4D9w-1; Mon, 08 Jun 2026 06:33:42 -0400
X-MC-Unique: ZcMeQs8aNcCz1w5fpM4D9w-1
X-Mimecast-MFC-AGG-ID: ZcMeQs8aNcCz1w5fpM4D9w_1780914822
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-6607988ca90so7075938d50.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 03:33:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780914822; x=1781519622;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZPTWydL2gyYK6rrTGbtwML7Nkf7Wr+6W3UdOPzF34xk=;
        b=MV1DldvkL0Myu0zCbUP5Q3ggDNGucN8Q7z3pWGxAOiUeInmst3ImUpsDfJ7qvF3PaU
         ixvrGMQ1M+wF+0s6dCCZ0O4TENxCiYbWF65JLeJ2KZ+LmsoUwmbA1/T0vBM3JGNGMzjK
         qPF+BNJBw2CKXmxHw8UTOknQr+fT0i6uDb2T+0OBtLN8sS2Ab8uvyRIjE9J5B0XVSm1v
         4gu8bXvSfr3wwMGKiEbnV7LC2g4H8S34YSiA22kDNCyv1DCPUVBpmWLRHmNhi1kkeK5k
         1l1ABMjffJsKrXmnFSH2V3EbXz9ggNikKihvauE5z8eYBRcZ0x3A0UngShwvGAVxmegJ
         5+mw==
X-Gm-Message-State: AOJu0YwmnXlRGdqk3YXU39PIQc657k7yWTUkKlK7Y2ja8YAM+2doSK/L
	Y+AuYDjhKWQMNf6dbyXTw5g3ilngCLDlDukNziSdWqB2zTnA8aPBwCOMAGN8cmIRUoCDC6w4ug9
	R0dbPVXoxSGKw8GZYEVQGG/wxk/YKNPGtwGt7H7JejYxTTfU9sdm5bPNBU6puChzm2g9JqzZI4/
	tu/JUjxH40KJIwIMN/Ai/4Ko1pqkE=
X-Gm-Gg: Acq92OGKhT90Ze08T/Plbu/iXqO7HohMF5rteTBKM85sZj8K6Lo5K88UjR7xjTpQSKO
	WwA8ELb0sBlpjGhG/Fr2Sp0lihvCPzGpby/Gcn+n2fKk/3NX2/XcEO6nYMvaaZHqrNVurqOPBLA
	AW7/y7n6X3/urpdFLPiT4Qkjqcyxbw6+vLDIbU/kSJLnYJjqN5/KjF+XIghaMqXh3UAJDxDhIPk
	6oNNskbD1TP/Kc=
X-Received: by 2002:a05:690e:c49:b0:660:481b:c56 with SMTP id 956f58d0204a3-6610708d728mr13746975d50.58.1780914821993;
        Mon, 08 Jun 2026 03:33:41 -0700 (PDT)
X-Received: by 2002:a05:690e:c49:b0:660:481b:c56 with SMTP id
 956f58d0204a3-6610708d728mr13746943d50.58.1780914821542; Mon, 08 Jun 2026
 03:33:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260508170509.640851-1-npache@redhat.com> <04ea0e68-de56-49c4-8c9f-1734139d5e7f@kernel.org>
In-Reply-To: <04ea0e68-de56-49c4-8c9f-1734139d5e7f@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Mon, 8 Jun 2026 04:34:26 -0600
X-Gm-Features: AVVi8CcNSt1ptIP_oCgTguk6In5klbvhbZRzef-mQLFACUnfD2PKaqd_yypC4RA
Message-ID: <CAA1CXcCj7gbcdcuFQ2Zg3fTxys8NRteh4XH36pwQ5=BX6uUasA@mail.gmail.com>
Subject: Re: [RFC] mm: restrict zero-page remapping to underused THP splits
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, yuzhao@google.com, 
	usamaarif642@gmail.com, lance.yang@linux.dev, baohua@kernel.org, 
	dev.jain@arm.com, ryan.roberts@arm.com, liam@infradead.org, 
	baolin.wang@linux.alibaba.com, ziy@nvidia.com, ljs@kernel.org, 
	akpm@linux-foundation.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZPyAoAtwVeSydlE79PHCRnyni80NCMAZIIxGcTOT1lY_1780914822
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 879274000E
X-Stat-Signature: dm6kugkm741wxizc6ipbsztq5r4mwdjm
X-HE-Tag: 1780914826-513725
X-HE-Meta: U2FsdGVkX18+MfiAMTmq3kphAEp/DUzhJVwuYM6dYyvRNcHkKQWR7Pqq7qACVMB2O0ngSvC/duzTHkN222eURH2JPUQz38rGH+qCm9L99dHZf+MkccMQOSnqyvv8KLGV6Z/J4dzDBTpSJp5uUSlpuQPYjyu+kcCHK/AiI+BZMNaOewRd5IH5NLYscAcPOVh1enN4HzdRszTs54/8A/Jtkrt5rBkImoK5bHLDEJ0lCxD59lF9RReOQuEXTVaBxtMPoUsy6Q6157Z7B1ZFbQL50akh8smuFUWxUXPaR74YU0QkoYxyjF352v5fp2ulMk++eTsC8iCWcr4yknUnzx7Kov+a00P/Jrup609R/cxD+0AfXalhQT3oS/b7lXYOpsuQeHcyVYbMdNfTkCuFE9OKt3ul9FYpRKzsHOOTKaJXAmtTAnoVXWKzjS1EDydC5gHEz5h8M+jdGkug+zILEVOaddvqcX6vsaJWUxu5M0fBjruH6uia5lyJw2NbHrWijLA0mTX7I4CxVM1OPMdO6/9jGVlJNRWMYp+byfEeUXtZDipMAOpcJLJVxpqYD06bdByMnXF37IQl9x2KPGY7OkzTcaTVkvn1u6WWlko0MSLwUG2G8+xrY7m3wcKUll3uOSHgpf8i6rtRHi+UASAzo0o4DxEEjrtciQw07YIthPwFK4mH07nIPRz7jshRFd7jf7yFgcfs3Q99050wwM7kLTZyKwv84CGz14SSfeyVCC6Wtoo5EmoNWYjNypduoopAWoHCmHaDj2xCdtIhMgTeyjsmDScN60DfPWfrmlgtsCJi33VwV70vO6SRnti+9yt8IUFJIkxMJ3+8Mm4Y43j39/fBFs4UwY51ChC7KRD6Mqo9/o678DgPINY9JhPQDLuip5x+UN1ISpoE237255GOU9+N6PtVO9x1x4XKB5qrsdiSH+EeehMIa+nKG5BvV0DAGqCmcWWc+19t5x0+SWDvgSJ
 e/QGaZZv
 da0P7wyavWpq/HSo9B01W65esoyYrOdjuKwAoK1KM93dIDm/8rvtLJ+SYSt9c0TrTsrapvimS67IHvxONk68bTUhxvNpKX2egEIFEWWc4NEzTgwY2ctPPJtTG5KijscS9xh/MO4livdcMOFJ7vKfo4rnmwSmUWOx7vRLNFI3uYl2MLraI65BUEvzr2qNdFlX3ggFf3I3bB5yR728jlQZfksUCsHAdCXqMPE5VuvdbCAod6UvxbsxktoWbENJtCuUx+oawlp+Hdf72xulS/sbtQrvta8RjdpA6FcFwOxugEPQsFR0igmUq81w983Ey2pY8EvJlnFJFNTSERBM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 8, 2026 at 3:32=E2=80=AFPM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> On 5/8/26 19:05, Nico Pache wrote:
> > Since commit b1f202060afe ("mm: remap unused subpages to shared zeropag=
e
> > when splitting isolated thp"), splitting an anonymous THP remaps all
> > zero-filled subpages to the shared zeropage via TTU_USE_SHARED_ZEROPAGE=
.
> > This flag is set unconditionally for every anonymous folio split,
> > including splits triggered by KSM.
>
> And even when the underused scanner is effectively disabled on a system. =
Hm.
>
> I don't quite like that we scan for zeropages when nobody even requested =
us to
> split because of zeropages.
>
> I can see why we would want to scan for zeropages in a setup where the un=
derused
> scanner is active, even when the split was triggered by someone/something=
 else
> (below).
>
> [...]
>
> >  /**
> > @@ -4340,7 +4341,13 @@ int folio_split(struct folio *folio, unsigned in=
t new_order,
> >               struct page *split_at, struct list_head *list)
> >  {
> >       return __folio_split(folio, new_order, split_at, &folio->page, li=
st,
> > -                          SPLIT_TYPE_NON_UNIFORM);
> > +                          SPLIT_TYPE_NON_UNIFORM, false);
> > +}
> > +
> > +int folio_split_underused(struct folio *folio)
> > +{
> > +     return __folio_split(folio, 0, &folio->page, &folio->page,
> > +                          NULL, SPLIT_TYPE_NON_UNIFORM, true);
> >  }
> >
> >  /**
> > @@ -4559,7 +4566,7 @@ static unsigned long deferred_split_scan(struct s=
hrinker *shrink,
> >               }
> >               if (!folio_trylock(folio))
> >                       goto requeue;
> > -             if (!split_folio(folio)) {
> > +             if (!folio_split_underused(folio)) {
> >                       did_split =3D true;
> >                       if (underused)
> >                               count_vm_event(THP_UNDERUSED_SPLIT_PAGE);
>
> In general, this looks clean.
>
> But imagine the following: someone splits the THP for another reason: for
> example, because migration is unable to allocate a 2M THP, or because we =
have to
> split on swapout etc.
>
> Not freeing the zero-filled pages means that these pages cannot be reclai=
med
> anymore easily. We split a possibly underused THP but didn't free the mem=
ory.
>
> The only way to free the memory would be to wait for another collapse, an=
d then
> have the new THP be detected as underused.
>
> Hm.
>
> (1) As you say, the alternative is to let KSM say that it wants to handle=
 the
> zero-filled pages itself. I'm not a the biggest fan of that approach. We =
still
> have two mechanisms interacting to some degree.
>
> (2) Another approach is to just let KSM handle this in VMAs that are mark=
ed as
> mergable while KSM is active. That is, we check for VM_MERGABLE and ksm_r=
un =3D=3D
> KSM_RUN_MERGE in try_to_map_unused_to_zeropage() to just let KSM do its t=
hing.
>
> That really just stops both mechanisms from interacting.
>
> (3) Yet another approach I could think of (in general) is to disable the
> underused handling in a system where the underused splitting is entirely =
disabled.
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index e9d499da0ac7..5eca99271957 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -82,6 +82,14 @@ unsigned long huge_anon_orders_madvise __read_mostly;
>  unsigned long huge_anon_orders_inherit __read_mostly;
>  static bool anon_orders_configured __initdata;
>
> +static bool thp_underused_split_active(void)
> +{
> +       if (!split_underused_thp)
> +               return false;
> +
> +       return khugepaged_max_ptes_none !=3D HPAGE_PMD_NR - 1;
> +}
> +
>  static inline bool file_thp_enabled(struct vm_area_struct *vma)
>  {
>         struct inode *inode;
> @@ -4188,7 +4196,8 @@ static int __folio_split(struct folio *folio, unsig=
ned int
> new_order,
>         if (nr_shmem_dropped)
>                 shmem_uncharge(mapping->host, nr_shmem_dropped);
>
> -       if (!ret && is_anon && !folio_is_device_private(folio))
> +       if (!ret && is_anon && !folio_is_device_private(folio) &&
> +           thp_underused_split_active())
>                 ttu_flags =3D TTU_USE_SHARED_ZEROPAGE;
>
>         remap_page(folio, 1 << old_order, ttu_flags);
> @@ -4497,7 +4506,7 @@ static bool thp_underused(struct folio *folio)
>         int num_zero_pages =3D 0, num_filled_pages =3D 0;
>         int i;
>
> -       if (khugepaged_max_ptes_none =3D=3D HPAGE_PMD_NR - 1)
> +       if (!thp_underused_split_active())
>                 return false;
>
>         if (folio_contain_hwpoisoned_page(folio))
>
>
>
> I tend to like (2), and maybe (3) on top. Opinions?

Coming back to this.

for (2), I have to export the KSM run state, which may be fine, but it
introduces a race window. If a user disables KSM, a split occurs, and
then re-enables it, the bug will present itself again.

Would it be better to just check if its VM_MERGEABLE?

(3) makes sense to me; I'll add that before sending the V1 :)

-- Nico

>
>
> --
> Cheers,
>
> David
>


