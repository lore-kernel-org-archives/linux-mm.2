Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DAB9606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 12:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qkt29cAf
Received: by kanga.kvack.org (Postfix)
	id 9B7266B05BA; Thu,  5 Nov 2026 07:37:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98F986B05BB; Thu,  5 Nov 2026 07:37:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A5A46B05BC; Thu,  5 Nov 2026 07:37:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 64C316B05BA
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:37:51 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 08AD91409B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:37:51 +0000 (UTC)
X-FDA: 85401017142.24.C96AE91
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0EF9D80008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:37:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qkt29cAf;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793882269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6NWrhtkA+nf836kZhtN+FQ8fIUYc2L2nWz3fs/cJ8/M=;
	b=Jiy+wwuIkoVChtn3oi8MYjRRy0HJ/bSzmqDG4cqKCNIRdQFv2ZrspQXrr/51UYvL0DUtEz
	gajzIahc0xvPfl9sLFJ0NPDC5rv0pPTnHLtCEQ07SsJWguWCdv489jhE43TFr1gScrM+d0
	JbG5rcwNZCM/sDnYnVpVblCKOwjufSk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qkt29cAf;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793882269;
	b=11ASG1sbR1zbKOWgg5/DMPZRCtD7U4DBBwVBTHBiH/lZr+G6gy1c51W91pTifJkcPDaFhZ
	CZb+04DEHN02yAjHAQe7KULJOs72/EIUo888nRocfIi689op2/xS082z6NmjHg3l8ZdW6D
	H7zPg/YuwYpdpaMntU6YiC/5xdCCQCE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 89B596062F;
	Thu,  5 Nov 2026 12:37:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F8E1F00919;
	Thu,  5 Nov 2026 12:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793882268;
	bh=6NWrhtkA+nf836kZhtN+FQ8fIUYc2L2nWz3fs/cJ8/M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Qkt29cAfCYKLOG+M6cAgNgbClr0IJvbp4B3TMyYgO7+3DsD/U1f3PPZoxDYJw/63M
	 7zwI3NopsqKQRMLUdnSY1j4X5LiunIafhZFObEr5HTH9TBmZmHtt7v99oCJ6BL0i+r
	 L7hVNIxc+Wn+z9xERFFNPIcYG6onDhh3bv3bxO4VCu3ETYgNYNfWkwce1YPBE90gZV
	 /6F1qfyOOpg3tF+JC8LWMffy08ggb7AARdhTjFSpZx43BF6v0ZaAG5qoN1NPiPIlj0
	 YpCujSYN7rzDxQ7vJHZoW8Pjj3JXYordWtSD+v9pIWdxk5ajS2Pyy3Z+3YITT/86nQ
	 I4L6ajuTs9jyw==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id F1A4D1980052;
	Thu,  5 Nov 2026 07:37:40 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 05 Nov 2026 07:37:44 -0500
X-ME-Sender: <xms:lHjsalvO8ZP8wgZjNh60XmuJQ40IAtZ5GOhqVObxvRMA7SXmJQajNQ>
    <xme:lHjsaqpK40X7pDFhoe9WbgRcG6oXPuYyd_DgH__-og5aV0izpIPYL1zK3fPeePPVh
    8L_1SnpgZduxsxqP50RXBf2o5CcwPJrYuI9QWEymIapR9taJEVuUABf>
X-ME-Received: <xmr:lHjsav7sYzyg-LfEFvsvgqHgC6gLFqDHslEsMC9jMpbvS5ylyb5KT6wYHr0>
X-ME-Proxy-Cause: dmFkZTFm9V5eJ+Rbf9jRmTYNKjzKU9cJBRCqvz8P1pvqtvpzSkaNDECvFL/BmhNntuB1Pq
    TcyC5G1gfJbucZjwqubwBtX4ao1ysLN7tdGdl8KXwAcNl0scpNLDBr2Xz3iZ5CS5TfZ7Fm
    P/scGp+wgBs4GjuuT10pms65wdnrFh7YIOrbwvuVOUU7+RS9TkFlrEuS217klAtEqRNoDf
    nCaxZv9yO0/oNxLEc7sd077SPYzdPIS1XVontV71Aw8tGJjDGwstaTLB22HKKusyI32zI5
    4Oe+7JzlkOZGGdi0aoM9dEG+8w5KSsumiOXRvnNc/9Dv+9cGH+jmA64vXXSn+73daPMkN+
    ZacUAEab5/jMk62gih6GTtTUR0qq35c4MeelDQhemrbuw1wqS1QpiBvr4CvW3szIMVwLnd
    9qZi5ZabFMkfk/O9BcJLjiiMAZ+bniYmErekVG9YBzdXwCz9bP3W64OugMiXh/yG7bHAL1
    gx1vf7Dn8hnyXFtsDfg6Op3csDWfS1fmn0HuOVaywdPzFRsrfBJ9u8kCV/3S5jDhGDvBaJ
    OSVTbwJxLPXwVpliz+/+rFmcoPTKmShlonuTx9stHEztJAFa9FU67CjRx0mwlg4j13SUiF
    KohkZr79wkgYOBXeX9e3ZbMGG9wrlPcRCySHQSqYsj6uXwbtA9M4nt9Yi3mg
X-ME-Proxy: <xmx:lHjsanx-Kyr3x-d0v022zvdwnIAWLMJAQa48j-Kr4StgVj5GrKc7VQ>
    <xmx:lHjsanTi6wvZxUcRkGXcXL8vAXu2-2A8lEMHN7TzjuGiHL_ObvsQCw>
    <xmx:lHjsah95kI1TGJC2L4Da3s3KnWibK5Uprn-mpquLghT8g6Yik31u5Q>
    <xmx:lHjsahGf1jpmzFexAN9kVECV0IHa7nHZ1rUSsPa8JwBq8U4m8jnZIQ>
    <xmx:lHjsaswCX1HeVow4OW3tB3HqaCi003akD_TxPxOyBEkHo9lBXO3kCjZ2>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Nov 2026 07:37:39 -0500 (EST)
Date: Thu, 5 Nov 2026 12:37:39 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: sashiko-reviews@lists.linux.dev, akpm@linux-foundation.org, 
	david@kernel.org, ljs@kernel.org, baohua@kernel.org, usama.arif@linux.dev, 
	hannes@cmpxchg.org, alex@ghiti.fr, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	lance.yang@linux.dev, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 4/4] mm: add anonymous mTHP folios to the deferred
 split list
Message-ID: <aux4FcaEdTrJ60NR@thinkstation>
References: <20261103212004.1356327-1-joannelkoong@gmail.com>
 <20261103212004.1356327-5-joannelkoong@gmail.com>
 <sashiko-outbox-198104@kernel.org>
 <CAJnrk1auD1u1J0yQrXOeJrxvVsQfbxYf+nsMS-9qFQ0hfchG-w@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1auD1u1J0yQrXOeJrxvVsQfbxYf+nsMS-9qFQ0hfchG-w@mail.gmail.com>
X-Stat-Signature: dmfoh1k8bj93afac719yssge18w643zo
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0EF9D80008
X-HE-Tag: 1793882268-514102
X-HE-Meta: U2FsdGVkX18ZiF5lTKn5AyKMSTErqnDkz6emV0YsqQEs6cOPW0MeD45rM3iXbexFGUHL5QXE2zDIUuHPfK5FGp2JTrUX3gw/JcFi/F+S/IsFBUtW3RWGjZpRGicHBHBs83EhskctPX5mD8Hu60OlYec2iqDIn6QBb1p6Bc4I7P5c0sRJmRI/Pe9d5+lFWoIntpZmSxjTdAPt469O5t+pF1KVfIHkjEFvQKdWZ3YEaDi5E8W925445aTcAjdvByCMRGNadwT9k6ch9o19ct5s4UKQwV57o7d1+uISYLXj/y20UY5gze6npxAHd3mFwgYL5o7IV8+ereABCu/q77WuYiK5wI43OTWE/REfMl4QUxUkGQ/HHY8vidWpjjo3XkL1K74ZFzB89Lbi6pPQuprS1mcbYast+FIE0v0SUhvKmhD8541a899MGzv8b9hvTIczAbS1Ju8UMtve/wjMZG7ftFTSN0ppsZ1HNwcmpCqdlsJfT44vtQbQtJdxvdW9C1cbuL4ZnQ16x6qVeigkiIXX05Y6YdWb5NewJUd1rYfQvqjdrgcHOsgPQXCj5UNA/2akplJTnmvzjRyM/3qIovs1xi6hlEGfTBB7kHAkw6F7KmRCFSbltr4HBcUVKIfkFPoK7tKN60s6KOqe0BXA8xDyWItsrYzItj+Trp15Jeu3MItZpc5TD5k5xP0gqEyCg9TX8kK331ZXT3bFmbOUfQ9/1zZ3DuoOiys/f52K2QUqNOKsfOhiZhP7IIMttKSLgXqvMbF/Up5ZxnUqhTeLSPnY59lauRZ2mYq1Q0HZUeoEqI+oJPn7yRw81nl4F/ViAFZjw53D5ySnj0722Fnez88QYsEbAZLJWP3z1EFbuuV7nSSiBAe2uOXueQKdxOtuZ4QNTtsXMGmfkyQC29h8TcBe/SrBfele4cnj1/3mXwgWhMpID66w/DFVV11fXKwZ/QWySj2RqzuulmPCR4kXpV4
 T2JbEWkA
 QMu1wne6g/4l11uRKi36iORghAjGkm4YQqAYcP8DcjOD3cHGide7xN1N2VK50aTt5wCnm3nYE/Y+X2nuPqcDxCUrhBpX2HQQ34gzAgNiloyg1RgIZxJvjl3/9rlNtrxY/grRrjeGGJFkP7uAiJV+a3qTiHLPNEjY8W9wuWUrI/fiEScdgBoY0z/3WC9MNTMWE4fPLgBfIpD1vfhxPq5V8lFF8qvJp1gTV4echq7kcEPW0s4/e0mSbBC0NhlAzvQnTJj6GSfYtn6EytSOOfFKJ3opjzQtbVMzzmmZ4ZFGaIcVnY4FHr2KK1g2rJGsDX5YWO0gV5ZL7zzm0QMmwXvMPJr42q/reoTdIr9WZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 03:50:58PM -0800, Joanne Koong wrote:
> On Wed, Nov 4, 2026 at 1:21 PM <sashiko-bot@kernel.org> wrote:
> >
> > Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> > - [High] mm: try_to_migrate_one() triggers deferred_split_folio() on underused mTHP
> > --
> 
> Hi Sashiko,
> 
> I'll try to address these points below.
> 
> >
> > commit 82b7b7063b986d802fe52e75e17211e58f3f420c
> > Author: Joanne Koong <joannelkoong@gmail.com>
> >
> > mm: add anonymous mTHP folios to the deferred split list
> >
> > This commit queues newly mapped anonymous mTHP folios of at least 2M onto the
> > deferred split list in map_anon_folio_pte_nopf() so that underused mTHP folios
> > can be split by the deferred split shrinker under memory pressure.
> >
> > > diff --git a/mm/memory.c b/mm/memory.c
> > > index 0c9ed04528d88..44376321180b5 100644
> > > --- a/mm/memory.c
> > > +++ b/mm/memory.c
> > > @@ -5477,6 +5477,8 @@ void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
> > >       folio_add_lru_vma(folio, vma);
> > >       set_ptes(vma->vm_mm, addr, pte, entry, nr_pages);
> > >       update_mmu_cache_range(NULL, vma, addr, pte, nr_pages);
> > > +     if (folio_test_large(folio))
> > > +             deferred_split_folio(folio, false);
> > >  }
> >
> > [Severity: High]
> > When deferred_split_scan() splits an underused PTE-mapped mTHP folio queued
> > here with PG_partially_mapped left clear, doesn't unmap_folio() trigger a
> > false-positive deferred_split_folio(folio, true) transition during the split?
> 
> Yes, but I don't think this is specific to this series. Splitting any
> PTE-mapped anon large folio that isn't already marked partially mapped
> goes through the try_to_migrate_one() -> folio_remove_rmap_pte() path
> you describe below, where __folio_remove_rmap() requeues it as
> partially mapped mid-split. That already happens today (eg underused
> splits of PMD THPs whose PMD has been split). This series makes it
> more frequent since underused mTHP splits now take that path too, but
> this issue is pre-existing.

I think it is a bit of understatement.

For mTHP it is every underused split: the folio is always PTE-mapped and
try_to_migrate_one() drops one PTE at a time. Each underused split bumps
split_deferred for that size next to the new split_underused, and a split
that fails at folio_ref_freeze() leaves a fully mapped folio flagged
partially mapped on the queue, which the next scan splits without
calling thp_underused().

Can the fix go in before this series? I think it is hard requirement.
Let's not brush if off as pre-existing.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

