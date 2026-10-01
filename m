Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05BA3CA5FD2
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 15:54:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D73496B008A; Thu,  1 Oct 2026 11:54:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D23EE6B0092; Thu,  1 Oct 2026 11:54:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C61836B0095; Thu,  1 Oct 2026 11:54:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 953C16B008A
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:54:25 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0774BA6F8B
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:54:25 +0000 (UTC)
X-FDA: 85274504490.29.F27B042
Received: from mail-ej2-f23.google.com (mail-ej2-f23.google.com [74.125.228.151])
	by imf31.hostedemail.com (Postfix) with ESMTP id 299982000A
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:54:23 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N8W6U0mN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.151 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790870063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t/FSvKdD0Rw1UPKEmYKGjjwHZIO5Pn+E96++Oh5YfMs=;
	b=CeOJ+4TFW0imS5iRDJSoW5Y1ciBKgn98G1ROOVkY/7lnIN8wdD4hOYhq/b96o6zmjw7Pyz
	hG1op00oo5Ayi3ioBicrHfgU8VOvlVS3xGoyhR2iKAPYBFYdbbVnlSvr5l43yKnYG+vURV
	ElCDehUF8c4h1DsKJMZsqDZnDhynwY8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N8W6U0mN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.151 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790870063;
	b=LDNLUwTPFikxWOTq9PZfCJzvUy/fgSrj0f7xq4+TOruoJJlo7fm3tiX+onK2OEy3muEpzJ
	aehegTOhm+jI9Ca3AWh16XHpCB9/chNmt/fo7QdcP9Bn88ZDpQTCZvVFWEOhQoVdQcRauj
	g7bEoMrxzoix1NQMIwttEbrx3xypC6U=
Received: by mail-ej2-f23.google.com with SMTP id a640c23a62f3a-c2e27d11f43so121302066b.0
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 08:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790870062; x=1791474862; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=t/FSvKdD0Rw1UPKEmYKGjjwHZIO5Pn+E96++Oh5YfMs=;
        b=N8W6U0mNamZUzJKRKNLYDC0ZKAw2pCZTRVgiJWOouYZ4VSWOP/ydrH1DAw7PGBMvy0
         04fudgArgLS2Gvb5ahuKiRFldC4W383sjbEUB/1CRvGuz6h2IqlLNhkI6+J65mLWcWld
         +Uf3TD24Jla4I+6uE79UtpQ1xzQIrYYmF0xd2wsjhIP8HPx7q7nHGbniAaGYbExL8tlL
         X81sZ2RIoPEzz0DoUnRU9ErKbZoS3iI4yZRlRncs+uB7W+B8pQApvVFzVtcapJXrQYVI
         wamIUy4scJy1vT0SKrSnVvJJ79U1J8rQoXRGJpKGeKHcqouJc+fbBxiXRVDvgpQ5MGBz
         gBPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790870062; x=1791474862;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t/FSvKdD0Rw1UPKEmYKGjjwHZIO5Pn+E96++Oh5YfMs=;
        b=FLR7oh3INQEQfgL8LKrnOiRo8CiKtfQG188FJZiYQHQ6AktSpYfe0JvL5XchOeSeQs
         qFCkH7iIuDbRuysZNCgyXXtCgguYIGdq8mllK6jSpdXEhSOVxoKQIrYA6C//tQAq/c8p
         5tv0VHnENLpwEsRLSBJv/adSFa6gbkUzoJvsr3pbFB6AwEjSnkuc2yHLRXuQsQ/5UXqO
         rwOL4hiqOLZPV852DPbR8gBrdJvuS3N2I1HGPi4T3ScZP1ufvbKrvZ6BnEo7UKOZPGS+
         m8Ze9ureBQC3HHnmPYH9BQvcED3jIH9bbDhKb1zNAjrnqK6zsygFNn9CCRXyGwsHk1Fu
         DD/A==
X-Forwarded-Encrypted: i=1; AKwUvBw2LOlT+3ciI/TGjyM7kbyAtbIoAULX3TMyMPrilYIt2gpxAEsB2qqbZncE2R4PCKBEGVwJqCJl8g==@kvack.org
X-Gm-Message-State: AFuF++lfPAnZuJDFxMx1ff7DHP6rFnJTGia7p1w3+IlVELIVaE81VGi8
	26b1O9sAK3537yMBFBmJFK3xX/nOZeOzhuPS6j8br+YYR8vZjaYKQ/6B
X-Gm-Gg: AYBFou2C0rTaRhd78N+TzUM9bIM4UTh9Aakwix4v44tu1TAi9ydouB6SooP1B5F4qqC
	YROcY4OFB8g24TMnAnvLlxvgovQdtR20zSSTrYhCCFLsl4gPu7MR2xm5dgTAL5bf+i1WyGnuKgr
	npDJnD5qW9q9eQM1q01TxbllyDoRA3kbbfDnPfsobTAA20SaTJMpC7qhjhKZZINLmCJtyD8Kl3D
	ju07yz9IxnHV64MnuY+tO78BkjgyL1mAHhCDdRmGGixB/oM7UgMrUjI7z6B2iX4ItxAkc6lDhFY
	aVDJWvAtsyjEKkjy3PL9xpQmLlZpTKWXZ60JXwSj4V5ivy8WsMoxutL4d4Rz8anAewVnYKgxkev
	xsjGbsU2StTF0x0IMLtLgcaKE0O1CB0Yi0VziK3KrzhJSzPeUYEC6Xo/bhwAwn6fBDmIhwLs9be
	e0OBi07zr86OjGcuVlk91tOcnHGVzJcUiGF0s=
X-Received: by 2002:a17:907:d87:b0:c2e:4397:7c82 with SMTP id a640c23a62f3a-c2e4aa6562dmr2262966b.6.1790870061590;
        Thu, 01 Oct 2026 08:54:21 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2e31cf0d6esm183317366b.37.2026.10.01.08.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 08:54:18 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 1 Oct 2026 17:54:15 +0200
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
Subject: Re: [PATCH v9 06/10] mm/vmalloc: extract vmap_set_ptes() to
 consolidate PTE mapping logic
Message-ID: <ar6CJ9pWSEB8fAcC@milan>
References: <20260923062832.479455-1-jiangwen6@xiaomi.com>
 <20260923062832.479455-7-jiangwen6@xiaomi.com>
 <ar0fJcjNmGGV6uFu@milan>
 <CAHKocdF43Rqnt8-v0WP-t=Dxz2sSJ9xpyjLAYc2fzzKAW1_N8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHKocdF43Rqnt8-v0WP-t=Dxz2sSJ9xpyjLAYc2fzzKAW1_N8A@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: jt4nn91j57izsm96c4z8qthii96fnc58
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 299982000A
X-HE-Tag: 1790870062-482802
X-HE-Meta: U2FsdGVkX19DqSgd+eN8THO4VBfjomBnjhlNY8t0ulJHrtiBCbnZQJwXy/MZL2OGvFIDTre4+ZFoTT0+i/fqsvSoHyQblwfemY5PAvhB6hZDqKr43r1VXOy5WLBLPR+RKa/Dymm9dKPo7r3iUD8YoouTusk0il3ouY5pBIpNhv6Xh07qVLkDiKEKnNi5hOrYWirgKUiHRvJ3OT5Pqjm9BbXHrlTG9WGY1rGzP5ofqIhrI6JK6v6ebmTl7yb6oMwqiBKRrLrNws6dr3jFF6ju7Yah52pWxC7HGNsXb2Pn320ioPbK00HDbjvcP/ni26OPKVuP71Ut/Y8mddoblvaBBMIusjjUqxGlfjtS5x1wAZeXFdwNRPQnryM1l1Bpy1zjLEKd9YHSkRKRdZT4LcFveoxANCEwAS+b0qsUyZX3kXzgYXynMqakSYsPurRQEimzAKPmL6Ib9rZtd4sMMNo5V8OSCZ7Gv6uoRdCpfLk2KbLntXSYNVwnxOBd7wVrVfNUMDlmoLA9XjM/wOMMTQMRa3impxlW4+o90KdA9SlgGBcQIum8k0lv6eO9NxtU4679bp8cwn4P9xND1Q5jsa/EOZDbCRKwE9snGenRPpdzpcsCKyN5RSEqmu1j2cBfjEbGp32IxrqJ16c0Y+jyUo9WhwnwZjZkJ363580E5FFHQj0VLvQ4wAFIxjWI9xEudrfCL/cWcXZQRoNDZkhr2o43C/pfnHzO4hof6bkIV51aC8jUx0feZOKok0HS7idOtGZ43Vb5uemzPiHwhEThFh52yzbe0mE2/0PXyi8VWurrkY1ydp+Y3+2DeSK6MGhABZB72/9eXxbhhnv3JLnaoMhNj/X039KUlTwwk7Vce1uICtpc41UQX8k7VWuZybS2mV3hBtF95qi5gyDHtDm4rgHxi/WFq8zO+ExuF8t7v9xxM30zY7qkXd+1crrRQL7FbQlvMiNP9pFWl0QNBfT6dbp
 j6s25dYt
 b22bY2pjighVY8E7/r+zUecX3U1z5n5Q6sxX5PV4O2DBH1Ks44DGtR91vAD7FRWT+Q7zx5dolUzWKbj+7DEqKLbB5YNNaiz9US5rbF2mM5mbrlbYhUVRA9ROvcCY9+9/g9pdptVfLqDNjaM7toAhphR1zow6+/ROFY1eoclemqwUfy7ZDqSjbqF+DbKmTt3RTFFLmKCw2Q8yw1DJ+sroyh4uF7TxtsClNDmwpo6kzqqV8u+9YRbK5fDg4kgjo+zBMquoef8rXi5Z8bZZcnQmDyGJGWHbXeGQ+RnRUL19rzqPfoj6cEorKHF1tz7Zo+mJkoV7dnERapILBVJ3hDJBLYYZ4DtJatdxACASCFbIG3sXdy1qvVq3QmEU9QG04bpp4xyXanhPUhAwKBJ8XAFQVATdIDXH3IrEuw9q1xh/pHO64Ckk7b0aK2q7NffuTIzWbc3Ob901LnnZ7Z3fimGIDYAgWfCOEnutvMpY5nOYpBxiRhoO3CD71aqr511XVKT8b3rXlXjZ6o/Y7Vmx5p6h/0AGJqN4aKH45rFdvIMutAJ9siwlkNVEyk2RL4HmCv8G64ehdZDTyqy5h8cEsFH6o/CUynGAXqfnMmV9AYd3zwoTOAC6ttXaXmuUwCuSLt4LyHj9CZvDAh2szglakKzklxj/dX4glnhi6G9AR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 01, 2026 at 03:58:21PM +0800, Wen Jiang wrote:
> On Wed, 30 Sept 2026 at 22:39, Uladzislau Rezki <urezki@gmail.com> wrote:
> >
> > On Wed, Sep 23, 2026 at 02:28:28PM +0800, Wen Jiang wrote:
> > > Extract the common PTE mapping logic from vmap_pte_range() into a
> > > shared helper vmap_set_ptes(). This handles both CONT_PTE and regular
> > > PTE mappings in a single function, preparing for the next patch which
> > > will extend vmap_pages_pte_range() to also use this helper.
> > >
> > > No functional change.
> > >
> > > Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> > > Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > > Tested-by: Leo Yan <leo.yan@arm.com>
> > > ---
> > >  mm/vmalloc.c | 36 +++++++++++++++++++++++++++---------
> > >  1 file changed, 27 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > > index fb757d95bde25..d475e52110e4a 100644
> > > --- a/mm/vmalloc.c
> > > +++ b/mm/vmalloc.c
> > > @@ -92,6 +92,29 @@ struct vfree_deferred {
> > >  static DEFINE_PER_CPU(struct vfree_deferred, vfree_deferred);
> > >
> > >  /*** Page table manipulation functions ***/
> > > +
> > > +/*
> > > + * Try contiguous mappings at the PTE level for arches which support them, and if
> > > + * requested by the caller. Fall back to PAGE_SIZE mappings otherwise.
> > > + *
> > > + * Return: mapping size.
> > > + */
> > > +static __always_inline unsigned long vmap_set_ptes(pte_t *ptep,
> > > +             unsigned long addr, unsigned long end, u64 pfn,
> > > +             pgprot_t prot, unsigned int max_page_shift)
> > > +{
> > > +     unsigned long size;
> > > +
> > > +     size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
> > > +     if (size != PAGE_SIZE) {
> > > +             pte_set_huge(ptep, addr, PFN_PHYS(pfn), prot, size);
> > > +             return size;
> > > +     }
> > > +
> > > +     set_pte_at(&init_mm, addr, ptep, pfn_pte(pfn, prot));
> > > +     return PAGE_SIZE;
> > > +}
> > > +
> > >  static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> > >                       phys_addr_t phys_addr, pgprot_t prot,
> > >                       unsigned int max_page_shift, pgtbl_mod_mask *mask)
> > > @@ -100,6 +123,7 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> > >       u64 pfn;
> > >       struct page *page;
> > >       unsigned long size;
> > > +     unsigned int steps;
> > >
> > >       if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
> > >               return -EINVAL;
> > > @@ -120,15 +144,9 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> > >                       BUG();
> > >               }
> > >
> > > -             size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
> > > -             if (size != PAGE_SIZE) {
> > > -                     pte_set_huge(pte, addr, PFN_PHYS(pfn), prot, size);
> > > -                     pfn += PFN_DOWN(size);
> > > -                     continue;
> > > -             }
> > > -             set_pte_at(&init_mm, addr, pte, pfn_pte(pfn, prot));
> > > -             pfn++;
> > > -     } while (pte += PFN_DOWN(size), addr += size, addr != end);
> > > +             size = vmap_set_ptes(pte, addr, end, pfn, prot, max_page_shift);
> > > +             steps = PFN_DOWN(size);
> > > +     } while (pte += steps, pfn += steps, addr += size, addr != end);
> > >
> > #define PFN_DOWN(x)     ((x) >> PAGE_SHIFT) - how many pages covers the size.
> > Replace steps by nr_pages or nr_ptes?
> >
> 
> Agreed, I'll use nr_pages. Since vmap_pages_pte_range() in the next patch has
> the same "step = PFN_DOWN(size)" pattern, I'll rename it there too.
> 
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

