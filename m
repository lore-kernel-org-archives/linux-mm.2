Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 014BD606A328
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 00:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Wzk/ejJT
Received: by kanga.kvack.org (Postfix)
	id C98736B05B4; Thu,  5 Nov 2026 19:05:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C48636B05B5; Thu,  5 Nov 2026 19:05:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1BB86B05B6; Thu,  5 Nov 2026 19:05:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 412616B05B4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:05:37 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3ABC4A8BD9
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:05:36 +0000 (UTC)
X-FDA: 85402750272.30.CDE0467
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3E427A0003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:05:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="Wzk/ejJT";
	spf=pass (imf25.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793923534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zGe6RH8jO1PkEqlKrUq+hUFFk2bxgmP97XnZ5LF8Xyk=;
	b=oZEg8uVjg07mWRBoM9ylBMY2ft/eT538DjJekt89Ndv8yDtGc0avJWIfwfSJvJFSLHtZmk
	iBZw/atx8kAcVdl8DLhGaN1nQvhYb+L3ouK9KgFRS8LzQpGPtGkmhrs9fQOH+gpTDwxngh
	7BpaC3cJACtgS3ijGjyP4DQDy9/3rLE=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="Wzk/ejJT";
	spf=pass (imf25.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793923534;
	b=x2Y8xhrifGK5MTsaRrcEJdZuFnLWUagcjzY+i6uzM3SLYc3OBXDjoPFFE87DWLBP1gQkAJ
	axvS6/z9Fx2jfJSlByD/oLf3oLaB2QsmukUsoaeoY4vFDyD2ttqnZK4Pf/70EV0A2Ft1to
	/lwi+NyRwp53s4uqCTx3Jx6CQGBbxjg=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48df4f540ebso52142f8f.3
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 16:05:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793923533; cv=none;
        d=google.com; s=arc-20260327;
        b=YZLD3XQnxl3U8y/7MaxPDcVX/rBJJdJDQU+hlzqat0yiltDEYjMDIH4a+Et5Trv+F9
         Hv2EobsV+XCb/Q5aeqTAuSEPVZYYcJ1telXUTHo9oMAJ17xzb4O38cyk7cRXYVAPpghy
         WQLkAgjxLR5xXfDmqf4mzd8ooqWYGjMWJvlA+hXJhe4d8RuMzXqslS3t8vGirWhrUc/H
         BYuravQtrMiFl2lhUfCQM56uq3+OC5pn33nR6A1s4K15kvZd77lyORl98AG6khmHn9iV
         IaVQ5wauVsVbyD0afiT/JhbUYvHhy4yiclM3fr/WHOupGxT3ykPjDJRz1DQnuvUEk6LU
         NYOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zGe6RH8jO1PkEqlKrUq+hUFFk2bxgmP97XnZ5LF8Xyk=;
        fh=tpBRVhB52gAGXIefzxQIp7tlBj1GBKDkmR+w+0JvIZQ=;
        b=Bv/ME5r97b3bH9PWcRnYb3paLreO4Vicni1M0bRbUpG2fA2PnxIwXee/mViaF2w05y
         EEVmSKlatP8Sys1zEnFjf2Z5oxh19eUJ+lguCdRWrzFtbgw9R4F1M5GoPzfqsA8BEsjr
         uhexXXtZDkj8vuNXBHMZ6pcWCeupdsKaB529WomWMFH528s+8HoEjlywidaZG3lnhli2
         VoVhy7rZ5P031kRfHFs8sjtdcvc4etL9vWBeLEvS3Gxbo6n5CCX0/JPnwsiTxMNOWnEX
         LQUgbo67q4QGCUPNjRmBKjaZEkEGINyXYiZiiiZHrgzhOd1PceeioissJ3PHuVrHhyxi
         x/yw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793923533; x=1794528333; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zGe6RH8jO1PkEqlKrUq+hUFFk2bxgmP97XnZ5LF8Xyk=;
        b=Wzk/ejJTjOaANZAh6r+m3WrysSzc3ezglSh0BXOauD6NFs4ME9c45TKsuXM1iiPicz
         dwGbyJ9PVnc4+j+WNSuZ4q4AAaDQsDfQdGQQCqGoyU2IxRJ1RwnUpcxcdtlxvIS33aSc
         aapDEEjgWAAkeTl+VlrtcSYQcZqt8hXjcnwlL++vQSHU2w/rD2B/gjqZHZux8M6AMC55
         Ri7i4+lkHxCmVptQ8gsiQFJ12hwgjc78xhuBnQjnFVX/J4N+TpO/jvoBt1BHtrWxj/d1
         3c9JgDT4JVY8Pm+6RVb0cFwnXpadVaFzB1JLqTyEmaVf4k4cQ6MhkRO+ZF4G3vDt22Cc
         9SLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793923533; x=1794528333;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zGe6RH8jO1PkEqlKrUq+hUFFk2bxgmP97XnZ5LF8Xyk=;
        b=jYeCpNmcHFra7kkcQCYDcyWh5k6Sk0RiLBnXlWnl9/If8PO9o75E0EBRzbJmn+2dxL
         +NpdQE5gjgn1VU62Z3KgSPUDqdyTbb1CdeHC63onDU78fVLqSLoDWGTsxW1Z/yeMqF5w
         UHSGi3IVHrQjuXHWnxZojWCoIsiEPGh/JvGFF+Yv/xymTVsh1c3tbkTul1cLvVUqDics
         /1ZUsNHfgON69SfecCCl/qjAxOVj9cc4kuJwltbyDmx3WIe1TW7yJwEvjWpVlHeQpeb7
         2Fug97hZ2UDCja2awa0zKXedaryedOMgnr73kJQB2TkJkP2EzVCRkj4rg09LXE9V3d0g
         UcfQ==
X-Forwarded-Encrypted: i=1; AKwUvBxrBVjpw57fg4m47WEtA3q8i8v9EDs7fFN/ohriEWWrNssYOr9EAJS9HhlObwvPTUX0vlP4ic6ccA==@kvack.org
X-Gm-Message-State: APuU4Z+mukKsYW1eib0jdeD04qL6IBrbO233slsGNdwQc3Cplu0aL/Hx
	ldv5I9pjhin5/NSKQSE0Jze2BCtv/HiA/FfOftXTdM3VQcpF7X4c0Qw8UkgYfEaI7LbgX8N1BrF
	27zVaCMJ5srCz+Pan2LEWy95nyBP1y+A=
X-Gm-Gg: AYBFou2gyYAXi7hL6mzEpwihizEGeatjsV7Z83YP9lnleCQ7ZzblUhfSr/dlrH40TJQ
	DsN4cKmBFHyQMWErGH7Cx0/p3zEE/Ft0LHqoIv5sR7emNEiBlbKtltEyOGA3vCV0TRzDTPAZbvb
	ZAUX401+ThAtILZQWytrWWa+MJ9FOohTZs/bO1nOwrMC+y2J1IC486g75LeO3cQqjY7BMeNTbbe
	Rr2v7Qq1Ae7VbA6rQfO2vnZr8rLghD76nHzRnoXJghAj+hGcrWlBnOmcdET16wfjrfWoo/mwLMO
	XKIW4RhwuLvPYN43I5GsWonteXz50fRsn/etIZl2MeKTIlB3oybam0NY26JqWS8fDZRArzPBf3j
	QcmLQAyIVwf/OmDYuvUAoFBD8FOkwP4wufyvJD+MtUw3yh2KCVP2y5dHXlTU9mfMD7d9nI5LPTB
	5o4fMStJvW83BU9SEwuA==
X-Received: by 2002:a05:6000:4819:b0:48e:75a1:1e38 with SMTP id
 ffacd0b85a97d-492784555f4mr2086202f8f.56.1793923532544; Thu, 05 Nov 2026
 16:05:32 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261103212004.1356327-1-joannelkoong@gmail.com>
 <20261103212004.1356327-5-joannelkoong@gmail.com> <sashiko-outbox-198104@kernel.org>
 <CAJnrk1auD1u1J0yQrXOeJrxvVsQfbxYf+nsMS-9qFQ0hfchG-w@mail.gmail.com> <aux4FcaEdTrJ60NR@thinkstation>
In-Reply-To: <aux4FcaEdTrJ60NR@thinkstation>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 5 Nov 2026 16:05:19 -0800
X-Gm-Features: AclHuK_favFgX046LpM4Y2ghwoXnBoevU1JO2s_bhvQczk_tdcYOmudpHFcbITU
Message-ID: <CAJnrk1Za6=B=Y3HOaJjhU7orq_P27QFe92_n9F2y2+108xDSOA@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] mm: add anonymous mTHP folios to the deferred
 split list
To: Kiryl Shutsemau <kas@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, akpm@linux-foundation.org, 
	david@kernel.org, ljs@kernel.org, baohua@kernel.org, usama.arif@linux.dev, 
	hannes@cmpxchg.org, alex@ghiti.fr, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	willy@infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: n9bqcpcf8orbou6cyyx7w83ksg53i653
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 3E427A0003
X-HE-Tag: 1793923534-473890
X-HE-Meta: U2FsdGVkX1+R+8aiIpLtSCAPaNIFu2GZkbZTUdK05tTcoQnpL/XIh96mbhz49uWlUM9WCGAqfVXMmhKPtdHnTx9GfJ0fw+CXARXN0RRJv24bSTFcgwGk3IXafnJHevZW1GTs3Uz2Ily086buUILInBhREAvPCDyUOYmbJgiB/Igq98F6jwY1UHmRGNcpip5jAzHv4/0TE5fx9o7/ZMQ70dcTtABRSARhhgglZL7h/YaMKeg4S9gr8iV9SMRoW8jNKKpP6pkPq1e/HnNSRReIBRT6zWpxZ3vmlh2Sifh4ccFeqUrVfl+qMKk87nuQlHzXkpXJ/yFsz6C9FEkYVR3KLwxz7/8HCij5Ir0JnLJIGZ/ZjpJZLDK5PRyAW+YvS2V2Kxm6IZv9gAkR871JtiPrDOwnePu6Tccgcc2bxRrdtMmJnXDhUJg0S11KpMFiVDp4DXnIKN2iAquPjiJPD2QabD6VgxIwuqKeBfcVNKa40Ge+6GdQryKkN0M9rHwgjivStZj714AI4RafTcvV5fCJKDGPXONPlYynEo0XIzqAb0Movx6JkVEfJs4ntB+4DHZuOKOE1BuK//Vi8tjqTgTtxfZrUubvKtFDVMU42p4bMzlmQ9EUgNooCbcNhB7yFF11Fch2CAidjUrAtE7w8kiQ6lnxTv/6rgTIUnqvvrtze/NO/BGaKOTb5gfhbaC1h/Yh+bzAqKd43jO5FI7pQHJZAKc8/CsJSqhfEfZB9n446apQ3n3j3KXaZMNlb91cIARSR4CUp5vCY+cLLxnDMof6bWZKaMq4JhfCQ++J9MgyjvMI01rUi3C32XU8BgkN4m+7Fl/Fg/HEmy4j+eKS8oGagkjZtG8yKE/7J9r1eET+w+K2ad6EPiX++JwO+0PTVu5+lLu9nePVE/+eM3uAu35QkHApORdDRhJMlX8J8pgMI3qpMy33cUcojjInPB2T1sEdf09vVvMV89Wrp0DB41l
 Ev/OiGhu
 96BAzlvb+5FpvlvYMnhN+a+vmrdrVvH7ZhE0pAbTmNh9WXOFqSJq7RXfCJz2MrHrc97Pw+d8Wl4szXeqS47DDq7A/DKeBCeZdfIfBNOmdHvwtK2lPkhdl05EUsDAMgtHnM6pFrBjBbSXpV2wLrk3UJgdL5toy0wdaakARdVEACzvYnCQgL/Hzthje4Ey0Cz0e/2ipomxkk65LmL2sr71XSmDY15G+7Ws66eLAU1rZGJYo2180b+PSrYqo/tvx6sC0ZCbD/EjKXBDNOj9eY4E8OpJVRbKnjh7X10DHlhkppd4T/pyz5oTAh27BCSOZcCUmquyYBg/QYS9DzlYozpJcTiCNktzo+NSR0FlSM20L5deG8f3auD/FfKKYE22hf140kfYuXBrokazYpb2KzI1CvDxhEkKEjbT36/h/xRWsszeJSPWbGMGDsKS5VG6VYgekj1To
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 5, 2026 at 4:37=E2=80=AFAM Kiryl Shutsemau <kas@kernel.org> wro=
te:
>
> On Wed, Nov 04, 2026 at 03:50:58PM -0800, Joanne Koong wrote:
> > On Wed, Nov 4, 2026 at 1:21=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
> > >
> > > Thank you for your contribution! Sashiko AI review found 1 potential =
issue(s) to consider:
> > > - [High] mm: try_to_migrate_one() triggers deferred_split_folio() on =
underused mTHP
> > > --
> >
> > Hi Sashiko,
> >
> > I'll try to address these points below.
> >
> > >
> > > commit 82b7b7063b986d802fe52e75e17211e58f3f420c
> > > Author: Joanne Koong <joannelkoong@gmail.com>
> > >
> > > mm: add anonymous mTHP folios to the deferred split list
> > >
> > > This commit queues newly mapped anonymous mTHP folios of at least 2M =
onto the
> > > deferred split list in map_anon_folio_pte_nopf() so that underused mT=
HP folios
> > > can be split by the deferred split shrinker under memory pressure.
> > >
> > > > diff --git a/mm/memory.c b/mm/memory.c
> > > > index 0c9ed04528d88..44376321180b5 100644
> > > > --- a/mm/memory.c
> > > > +++ b/mm/memory.c
> > > > @@ -5477,6 +5477,8 @@ void map_anon_folio_pte_nopf(struct folio *fo=
lio, pte_t *pte,
> > > >       folio_add_lru_vma(folio, vma);
> > > >       set_ptes(vma->vm_mm, addr, pte, entry, nr_pages);
> > > >       update_mmu_cache_range(NULL, vma, addr, pte, nr_pages);
> > > > +     if (folio_test_large(folio))
> > > > +             deferred_split_folio(folio, false);
> > > >  }
> > >
> > > [Severity: High]
> > > When deferred_split_scan() splits an underused PTE-mapped mTHP folio =
queued
> > > here with PG_partially_mapped left clear, doesn't unmap_folio() trigg=
er a
> > > false-positive deferred_split_folio(folio, true) transition during th=
e split?
> >
> > Yes, but I don't think this is specific to this series. Splitting any
> > PTE-mapped anon large folio that isn't already marked partially mapped
> > goes through the try_to_migrate_one() -> folio_remove_rmap_pte() path
> > you describe below, where __folio_remove_rmap() requeues it as
> > partially mapped mid-split. That already happens today (eg underused
> > splits of PMD THPs whose PMD has been split). This series makes it
> > more frequent since underused mTHP splits now take that path too, but
> > this issue is pre-existing.
>
> I think it is a bit of understatement.
>
> For mTHP it is every underused split: the folio is always PTE-mapped and
> try_to_migrate_one() drops one PTE at a time. Each underused split bumps
> split_deferred for that size next to the new split_underused, and a split
> that fails at folio_ref_freeze() leaves a fully mapped folio flagged
> partially mapped on the queue, which the next scan splits without
> calling thp_underused().
>
> Can the fix go in before this series? I think it is hard requirement.
> Let's not brush if off as pre-existing.
>

Sounds good, I am looking into this and will submit a fix separately.

Thanks,
Joanne

