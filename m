Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84EDDCA5FD6
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 15:48:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 292A36B008C; Thu,  1 Oct 2026 11:48:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 269BC6B0092; Thu,  1 Oct 2026 11:48:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 158816B009B; Thu,  1 Oct 2026 11:48:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E2FAE6B0092
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:48:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 81A6716047C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:48:21 +0000 (UTC)
X-FDA: 85274489202.09.902C661
Received: from mail-ej2-f43.google.com (mail-ej2-f43.google.com [74.125.228.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9DFB3120003
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:48:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pnOR6NKS;
	spf=pass (imf29.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.171 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790869699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1YG6o6wTRxoEQtd5iQEcu4HXOz2uoJ4yfyWYLykx9lM=;
	b=hOxiSR3rhp8x5z+/j8CO1ULyx4X6tPYraS0Ie7SdPz4vu96xEPZdVV58y01YTpll3nAbhy
	crtOr++THoZMmPfx/Trxn98ICx75+1ouFJliiogI9D+wzVoQDl8gNfOe3TxNy1g3zSEtYB
	i4Le1U1TyDClAN4oM6I0eYsw5laClH4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pnOR6NKS;
	spf=pass (imf29.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.171 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790869699;
	b=wmQqIzt7/FDYMpKVzhoLc1a6ttGgpN6RlUwdUcd+4SXE5VzFYR4yNnLUcR27XAx3Ojbf/w
	bi39Dag4X4L5h5k2G3yOkhhjf5m8JfLRPNnm0cmdjFNRf3LpPl6I8GiwZkcaWxkXfZgBtB
	U22TsSrppQpx+3TN7aaNALJ5OdnRPMs=
Received: by mail-ej2-f43.google.com with SMTP id a640c23a62f3a-c2e2050feb1so357329466b.1
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 08:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790869698; x=1791474498; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1YG6o6wTRxoEQtd5iQEcu4HXOz2uoJ4yfyWYLykx9lM=;
        b=pnOR6NKSGeusmFpcEKbXbPCWqTWtroxMrCwOKiT4dhZxFX1kU4IgnV47VQWN9C3DwY
         YD77DXGp4dmYS0p/TShD+n5JU59t3nMfnPUrWZHDvhOtKW1YpqLKXVlZ8udwg7XRACWk
         3G2LHHkCVZRGeRVMs0TUjwxuirkosHCrIhdXGEvVrjdYcgQizYRW78BmS1yeV0W3ADaQ
         PblLcRtnOMcz9ttfgHpQaS4kmWk4QKYxaEepJLG4unC43uO+qPiffBbzYH+NrYEQfW4M
         n/9JCS1m/WUnMTQHnViWa/mPywNstGiFkTzZUwGLSkTIeG5N7WQtOhD67eGUIE/b9MPz
         t18w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790869698; x=1791474498;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=1YG6o6wTRxoEQtd5iQEcu4HXOz2uoJ4yfyWYLykx9lM=;
        b=IWLce3VEjcgEcmYzdoIGdZlEWfj2JXYdJUz/rOsQg/tBhu1nKbyk267LIpB389ZoB5
         QVlhs2lnYrhplZ9uuf+3l/mmRkh9NKj20j1U3+gpNYkfaBAyii0B2aT3em2MpnPpTQvD
         YHWO+DtOCWEUy4KeLvSiv5kCmy8oObRklO2uoz6RL+4r/bDfjhn+3SyFWyv/k2R8sN6W
         CQIysiIcK+I58gVLNNadIdbm9Ec5sxBoTTDfinIt2pBX+5RWYnaEH9SqqwzAyuM7PbWu
         6GwH+pAgnu3tE3AfxoS0Rqu0RNKTO2R9L6xUOXVBYV856t5HiHOr13g4KVjkFQH3keQA
         WkCA==
X-Forwarded-Encrypted: i=1; AKwUvBwN6+3VFir2+nZj6jbFOpb2J9qhvDTwjI+fNwQ//HS0v/yJA404cZ9rHfRUI5ODE9AOInNkaTQa/w==@kvack.org
X-Gm-Message-State: AFuF++k0zlkRCzQnvJfnb07rf0VrLdPqXXvdtoQfZSCyXGbiDj5b5XPD
	cHIczOhr1jJTxuN60kl8t2MX1U2L3NXDqt6YPVk+mGeLEKeAok+5nZra
X-Gm-Gg: AYBFou31yDCrxrU7pZxwGMIZeTVGXsENlABJBhYxQi9TcXSXChWl/QjkFjqua98fCsa
	hUmUCm+nQHho+hNUxMhcTlL9duPeQGKe39RSGk8oukjx2caFaC5cSOhnmz4Ew987yV1JBFBrD1U
	WenQ47jz55Yyi+dWmuImJ8h9ZUAq2kUMGNJpxhanJYRsKidQCjY97aGRcN/Qt/iu453zVlvpCeW
	4qHJf/A3fIW2ZmnA6sNlPzo/uI/8BFHaZ6Tk1Nmj7PP0rx0Y2xQOuS3cB4IseMeKZRkteoTxioC
	Vq8vEkS9WuNvMG0cQOIlSMOUWmYu/86jbCarWTr0AH4xHStR8eaDwVW5xsqMhkrchT5ZG60WcZa
	MsWyT9FLxAI5cLtHepqItD/OkcHRFEzWlC3pKiLHzpIDXxX+xDjyHV8TE0/D+U5Yg27XAiUk2nY
	Q4bwd1ekHHmm7ZEwREfd6PuzTqPN6ublEjlPM=
X-Received: by 2002:a17:907:3f87:b0:c2e:856:2a08 with SMTP id a640c23a62f3a-c2e4a9b37a6mr2297866b.1.1790869697837;
        Thu, 01 Oct 2026 08:48:17 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2e31d87bdfsm180664666b.57.2026.10.01.08.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 08:48:05 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 1 Oct 2026 17:48:00 +0200
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, akpm@linux-foundation.org,
	catalin.marinas@arm.com, linux-mm@kvack.org, will@kernel.org,
	Xueyuan.chen21@gmail.com, ajd@linux.ibm.com,
	anshuman.khandual@arm.com, baohua@kernel.org, chleroy@kernel.org,
	david@kernel.org, dev.jain@arm.com, jiangwen6@xiaomi.com,
	leo.yan@arm.com, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com,
	rppt@kernel.org, ryan.roberts@arm.com
Subject: Re: [PATCH v9 09/10] mm/vmalloc: map contiguous pages in batches for
 vmap() if possible
Message-ID: <ar6AsIvAviFFQjEh@milan>
References: <20260923062832.479455-1-jiangwen6@xiaomi.com>
 <20260923062832.479455-10-jiangwen6@xiaomi.com>
 <ar0lMkKxugZV7xyw@milan>
 <CAHKocdEqnCCyW1TgmiRotFO0hQdHt7pXP1sdqzZ7Up6wc+-Bsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHKocdEqnCCyW1TgmiRotFO0hQdHt7pXP1sdqzZ7Up6wc+-Bsw@mail.gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9DFB3120003
X-Stat-Signature: 96bgkcoinhxndor7dkn6k688bcnudf3d
X-Rspam-User: 
X-HE-Tag: 1790869699-408494
X-HE-Meta: U2FsdGVkX1/j604ueH68EuWIOpjHihU/EzcgcpwOvT8RWfoUxLf6V+3OZvbwzUHr8fj++hB+C8iWMZU/LXkZZ3aD1OyFROggbw20xMfZdZNo4LUOTS50MDDbsBpsl+Np0IpYgQSONc0T4irkXUrtpYmtOi7dlsLnfApqGR4iS7FiVN4c3mvJsqXI21G7xZeqY0ekTS2FHU1UlI66Z8V2qNk1piprXyRwSKY76XCfll18tFmZ+nA45Sd8VDY0g+w+g8aRZjPjydijYNCeC3HrUlLPPrz1Lajqs+4HsT3pDo+Pb0V0m4BmL7L00dhQQBcPgSvVMqdyYDLwQeXimICA1Lnopk47K4q1a4gtVQbBEiIWIlNXsrAhErqT6km9MFk1fvR5ZV6sZs9NZHTYTdcYQHoB6/PgqPhj37/p9uDVfFK3pjU1HWKmjc0sE2ThdAddIU4+mKNOJQWNkEAVSGftdfNbFoiTXFmtun0ZSrlxlNDdUh2/VWMUVNF/X40zhdt8+ahbjEk+92WY6MwFh+raVu+qhxUccE+YpAu1f8pODsBe/RQ9RUyYiwU5VSdwcM+31jl3FymV0NqlV7a9I+1XPaSIf5De4rQ4TTKfNq3LWXcexxMr/lEQ9+qH4Ulm0UZCYlYOtXoXmP/ANoMIepbN9Gp3ROjG9ok/dypvJ72ffFykvthiGqQ9XUvsPPAMuwBpmFQX0vrQo639IegTzo3xa6DrosIhQ/2BZQsHwcqlv+gLS1EyTohAhJ1qJKKcYyShBvdeXm5GrW/18fEUid3rCIzO5Nkob8v8DelN/EGw0lEzE0QwVlhdZrfuZsmYpGcnn0lLwjcSYtE8vBb65obb53CaYbwPp5BeiRm8fK3tYcV6kwWjKcGU/xpAH8ACubVis0JzxZjpJwnet+b/vNY1iFmg1g5crRhUV1W5Rb9zyuoq/ub9MUwAYiP8f6MKPGG0hLHo8cRDSUmzDXWAli1
 bC1I7Fj9
 /wS4B85/ChYpHPLHEQxOyD92olu2iNcpe0nToTkyZPHuIDPvQW0X/TurCTSIkv765/17pa3aCLsF2FPO0Lt66c+4XFdEWRcYPQoHld922G1H5yt9L5H8m6VoY67FztZbiHL6B/rpQGtgckiZUbcSzYjk+2C19nZYsiArXUjjgF9ccSFy/cbmmvElKwqf0AmkhtICGWvGe713cOEjxbSten35l/hqdnx70IwUAGvi/R/GsyegaWuoRXrfQXnuuTDJK/Uy72h4+3+QoFKHlKJ+g/d4/8YixGDUX6xYtf2KbKLw2qUCjUvAoUzjvirJcE1ZZI1v5XyLcojDbPIpqSMmytnV+7DIUKzkcfrFEL4KtYxppdhYGQN6PT8JU3DtSk5hpAa3aOGBQQfdVhzqYj/2SzTOwfpPISJSo9+NJRY0pGRUw776M9XbIQ/JkFitz4qolfKwvMnHHx6ki+PcXbkZ9iXsJyRU9ChOI7KC2UnK0hsbex1M/AOR2c5mW6LnhJGIDFennaRD0D9y6GOTPJLKnJAUeyCxoncWla8rye3cWYBB0bwAOIIXbuW6jj7dKai5rP7yOye5cnfSonOT/IgKLSCtLM4c0r0CTyVpn6cCx0xCaWaXvs5BwnKyENuMXo6+8guSWoWD5jqz705MyB9Bo4klaodkQC4j3MKtX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 01, 2026 at 04:09:24PM +0800, Wen Jiang wrote:
> On Wed, 30 Sept 2026 at 23:05, Uladzislau Rezki <urezki@gmail.com> wrote:
> >
> > On Wed, Sep 23, 2026 at 02:28:31PM +0800, Wen Jiang wrote:
> > > From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> > >
> > > In many cases, the pages passed to vmap() may include high-order
> > > pages. For example, the systemheap often allocates pages in descending
> > > order: order 8, then 4, then 0. Currently, vmap() iterates over every
> > > page individually—even pages inside a high-order block are handled
> > > one by one.
> > >
> > > This patch detects physically contiguous pages (regardless of whether
> > > they are compound or non-compound) by scanning with
> > > num_pages_contiguous(), and maps them as a single contiguous block
> > > whenever possible. The mapping order is determined by taking the
> > > minimum of the contiguous page count and the pfn alignment, allowing
> > > graceful degradation when pfn alignment is less than the contiguous
> > > range.
> > >
> > > Pages with the same page_shift are coalesced and mapped via
> > > vmap_pages_range_noflush_walk() to avoid page table rewalk.
> > >
> > > As users typically allocate memory in descending orders (e.g.
> > > 8 → 4 → 0), once an order-0 page is encountered, we stop scanning
> > > for contiguous pages since subsequent pages are likely order-0 as well.
> > >
> > > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > > Co-developed-by: Dev Jain <dev.jain@arm.com>
> > > Signed-off-by: Dev Jain <dev.jain@arm.com>
> > > Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> > > Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > > Tested-by: Leo Yan <leo.yan@arm.com>
> > > ---
> > >  mm/vmalloc.c | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++--
> > >  1 file changed, 80 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > > index a43965016eb4d..37cddb7f45a4f 100644
> > > --- a/mm/vmalloc.c
> > > +++ b/mm/vmalloc.c
> > > @@ -3576,6 +3576,85 @@ static inline unsigned int vm_shift(pgprot_t prot, unsigned long size)
> > >       return arch_vmap_pte_supported_shift(size);
> > >  }
> > >
> > > +static inline int get_vmap_batch_order(struct page **pages,
> > > +             pgprot_t prot, unsigned int nr_pages)
> > >
> > get_vmap_mapping_order()?
> >
> 
> Agreed, that's a clearer name.
> 
> > > +{
> > > +     unsigned long pfn;
> > > +     unsigned int nr_contig;
> > > +     int order;
> > > +
> > > +     if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP))
> > > +             return 0;
> > > +
> > > +     /* Limit nr_pages by pfn alignment */
> > > +     pfn = page_to_pfn(*pages);
> > > +     if (pfn > 0)
> > > +             nr_pages = min_t(size_t, nr_pages, 1UL << __ffs(pfn));
> > > +
> > > +     nr_contig = num_pages_contiguous(pages, nr_pages);
> > > +     if (nr_contig < 2)
> > > +             return 0;
> > > +
> > > +     order = ilog2(nr_contig);
> > > +
> > > +     if (vm_shift(prot, PAGE_SIZE << order) == PAGE_SHIFT)
> > > +             return 0;
> > > +
> > > +     return order;
> > > +}
> > > +
> > > +static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
> > > +             pgprot_t prot, struct page **pages)
> > > +{
> > > +     const unsigned int nr_pages = (end - addr) >> PAGE_SHIFT;
> > > +     unsigned int prev_shift = 0, batch_idx = 0;
> > > +     unsigned long batch_start = addr, batch_end = addr;
> > > +     int err;
> > > +
> > > +     err = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
> > > +                                          PAGE_SHIFT, GFP_KERNEL);
> > > +
> > > +     if (err)
> > > +             goto out;
> > > +
> > > +     for (unsigned int i = 0; i < nr_pages; ) {
> > > +             unsigned int shift = PAGE_SHIFT +
> > > +                     get_vmap_batch_order(pages + i, prot, nr_pages - i);
> > > +
> > > +             if (!i)
> > > +                     prev_shift = shift;
> > > +
> > > +             if (shift != prev_shift) {
> > > +                     err = vmap_pages_range_noflush_walk(batch_start, batch_end,
> > > +                                     prot, pages + batch_idx, prev_shift);
> > > +                     if (err)
> > > +                             goto out;
> > > +                     prev_shift = shift;
> > > +                     batch_start = batch_end;
> > > +                     batch_idx = i;
> > > +             }
> > > +
> > > +             /*
> > > +              * Once we fail to batch pages, we expect to fail batching
> > > +              * for all remaining pages, so just give up.
> > > +              */
> > > +             if (shift == PAGE_SHIFT)
> > > +                     break;
> > > +
> > > +             batch_end += 1UL << shift;
> > > +             i += 1U << (shift - PAGE_SHIFT);
> > > +     }
> > > +
> > > +     /* Remaining */
> > > +     if (batch_start < end)
> > > +             err = vmap_pages_range_noflush_walk(batch_start, end, prot,
> > > +                             pages + batch_idx, prev_shift);
> > > +
> > > +out:
> > > +     flush_cache_vmap(addr, end);
> > > +     return err;
> > >
> > On error, if kmsan_vmap_pages_range_noflush() succeed you do not do a
> > proper cleanup?
> >
> > i.e. to cleanup KMSAN metadata: kmsan_vunmap_range_noflush(addr, end);
> >
> 
> The KMSAN metadata is cleaned up by the caller: on error vmap calls
> vunmap(area->addr), which reaches kmsan_vunmap_range_noflush() through
> remove_vm_area() -> free_unmap_vmap_area() -> vunmap_range_noflush().
> That is the same contract as the pre-existing vmap_pages_range() path,
> which likewise relied on the caller's vunmap() to clean up. So there
> is no behavioral
> change here.
> 
Right. With better naming:

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki



