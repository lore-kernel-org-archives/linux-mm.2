Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EACFD711C8
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 21:24:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E79526B0088; Thu, 18 Dec 2025 16:24:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2FE96B0089; Thu, 18 Dec 2025 16:24:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D25926B008A; Thu, 18 Dec 2025 16:24:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C29A96B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 16:24:49 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6E60412F57
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:24:49 +0000 (UTC)
X-FDA: 84233871498.11.A1B0E81
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7BC77C0011
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:24:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WHPAZDhh;
	spf=pass (imf28.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766093087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YTohBmtIORr8n8lsBagnrEz6IPI4sdKvMwJT/pJENjY=;
	b=QvLjrFaoqDSeEKjQOURdbHO9HYWM51fU9R4DOCAa39EihAJjFuMrYHuruBs6VXVR68gt5r
	B2/67HT6BLu7KHVyBsQKHO8q+N/iWDEqpBxSUmKUUwpas/Ipe1pBEGiFGWxPzhbx+T+k4H
	44tZ0JRihhO8pV0h5nfGLGabZjJ0VO0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WHPAZDhh;
	spf=pass (imf28.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766093087; a=rsa-sha256;
	cv=none;
	b=maw8EFU9I8390ZHLFkioei2yn1uoOI5kMRFOHqgYDm/0HrH1kmx2xnlOXJNeI1N4yvClDc
	4/fJYxyq5K8k1Ozxze1PggM+OtuIKUYfyIca9fuukiKVQvrYPBc6yOSHeWpkP4wkIDA8NG
	/VTFuFj/T0al73spI6k1q/sjnftKusg=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7d26a7e5639so1334205b3a.1
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:24:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766093086; x=1766697886; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YTohBmtIORr8n8lsBagnrEz6IPI4sdKvMwJT/pJENjY=;
        b=WHPAZDhhKXJhLi1w+TttC7e55TmB43/wtTrqHpulwa3zq25qNUFDREYPv4ENAX9giA
         CVf7li8sWI1zvxyT4GqNXAFC8GiffLyd/Z1KeFv4Qp0OTtAXWBVEOqRkcDJqyaNnnOvF
         aN/MGH7vDDgs1Hvko6S8XlP+NWQ3JQUPcK7fm6TY8f3hMacSYfPCZAnrl9lDrGignj+q
         AOQiuUTJnmb3187iljDANzj585isUnt3btRhmJBERKFQyqJDTBUV5aRgSXYBI4Bl2TMy
         4WNo0Qgl4FIX11UVGMPaqHSk5aPOhj7UT4naDb0x5oBDpqbCqz43P4QemcOxsrezvKIC
         Qc4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766093086; x=1766697886;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YTohBmtIORr8n8lsBagnrEz6IPI4sdKvMwJT/pJENjY=;
        b=Co74JZz3lzDcDbga74dAU1/2ypenEUTbcMt2G46uQDI9WWPKpkVMf4+XWauc4m4VVS
         nva3XY7SnYDGfLPGuDYdGmU7qldoVGi/KBly/g+EgJrq89onZungxXPi75SSNOr5uKeL
         sC0UwgN1XoBnIKHancY8MneAc2C6kN6PPvSo3U0sAIdNYjgM+xFcC3g76j0u3Ix3BtF4
         se6dAFYiMDgv7gAR6A+5T0Zkyno3FdOAlLHmCo7ME4qUKyvEnlrGyAEGZMyyFvMXH+/D
         UTQnCUS7q95bRaNWVdyXFudjNPZXux3VIdrXAbRy3/WshaIyPVuqDt9MAbMAzbVQ94mF
         k+vA==
X-Forwarded-Encrypted: i=1; AJvYcCVI0+Le/nRkBHAbXRg0Ya00zt+QAam7FCQxOIGL/+LHya8HvBwGL/oXnunykiXBE3fAd0gCoS0bOw==@kvack.org
X-Gm-Message-State: AOJu0YyMeP1n+zy8QEQVw1X8ClhYfGn0HtvtY/BUMsoYGvpJW+dexarr
	Ns7+6i3O2Q7FpZir8hPOxizkWiGY/TtlfNylTmkEAYyAd5mzlQYZdnSD
X-Gm-Gg: AY/fxX4vbeuFqV5drDfORvT+ewnIBbsMvW5E9QTyiZ02PoKQ+Nf50JvohT9BCv5RvJs
	fbe1NRvJQvfQwZoorLpKzrn4OQ9O7ZECl0aZod6GvA29vPug92MmjMeAAttSnJw06HF38V5FiTg
	FHUDT3woR2kP04ogM1OMwnHJQc/eQnaLmU0M4F7eNjUEB/6Uigd8jRHje3Tb7VWDvXLXKM/psdi
	0nOoUoSRhMJ6dy+BxUFlaf55UDothy8H/+xQxscEqowuKHMQsTgy8qSHISjYS8RyX8YBDCB12N0
	m/JtQ6TBo++yLddb2rZbY/tVbqelZINJ9jWU1Llf+HrXR+AkCo/cmnvtNL8C+h/ON6jrhZIglUg
	bA1tsnPu8gMr6cqYlHlB3aY75Ze9otB5t4O3tGy7iaBd4sr12MvCPhcOdedJ7gG0jEYxD/YeHzD
	PITkK6TId0qu2k3s7DGT3Rh7Tw
X-Google-Smtp-Source: AGHT+IGdOHVdrcCuEhBbazWVZdWwuUQF6Z6rcTSGphDUl2qn81RLeTCX0R1hfWncTkyQFdQxgYXjUA==
X-Received: by 2002:a05:6a00:808c:b0:7e8:450c:61b5 with SMTP id d2e1a72fcca58-7ff6607b7e7mr687761b3a.37.1766093086042;
        Thu, 18 Dec 2025 13:24:46 -0800 (PST)
Received: from Barrys-MBP.hub ([47.72.129.29])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7a939ea2sm258519b3a.4.2025.12.18.13.24.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Dec 2025 13:24:45 -0800 (PST)
From: Barry Song <21cnbao@gmail.com>
To: urezki@gmail.com
Cc: 21cnbao@gmail.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	dri-devel@lists.freedesktop.org,
	jstultz@google.com,
	linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org,
	mripard@kernel.org,
	sumit.semwal@linaro.org,
	v-songbaohua@oppo.com,
	zhengtangquan@oppo.com
Subject: Re: [PATCH] mm/vmalloc: map contiguous pages in batches for vmap() whenever possible
Date: Fri, 19 Dec 2025 05:24:36 +0800
Message-Id: <20251218212436.17142-1-21cnbao@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <aUQHss6K8b_esvpw@milan>
References: <aUQHss6K8b_esvpw@milan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pcj1xmb4oeds58mjzh9gjke3docdfhib
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7BC77C0011
X-HE-Tag: 1766093087-425599
X-HE-Meta: U2FsdGVkX1/MsW/Hg1tJmqzIpiLZFF6qsyue5qxsjb3YDjmD9bLp+2IvAKEmg0M3DMpARTcmBGt3xTD0ZGwL6CfuEjP7uh/GtNWmG1cJNKgkapyq5fJ9Fti71jmOAyZ2RypCCZhFys67UiyFn8Ov2Y6mm7MV5mG51accws8TSDVBrsqjiizNJyHDLcz9EoD/5lkqooTWdhX26cianfbnMPD9JawEvKmEex/TvQOdQQDsEVg7AuVlVQwk9ACD8tJ6k+cZUCulUTj4HOQeX750EkFF2w3DmZNdeIoh4IPN+QYt9eBGx1qETFDvWIoslEtfc50lwkvq2PaesRwE7kXjbapXYNrI2dIOFsIRwkk+X+tdpkCxFA1/aWdHEkxcGjahCRxdG7t8nu9cb9AMHPhbV8jmEyO33tzGHzXJGB6C/bq2lfd1z1ZvS+kn0gWXPdp79Vxym9/qMFiR9HMdkaQJZDhBb63HilBf1e7wN5mP68aqlSEbmoMNLBqitg62t37fg87y/Gqe5KV4JaBS1sQyrRwp5MivkJLwcrNsTOmJ1m6O3OiIOK5T+TPNET5bMAfQPNJHYBnXC/OiyUC+cdyXiwglR/h8n+qU8PowaGs95gi7am1fqjLeA51TXEP2XkeO8qvzlzKhMoX7WgL1Uns5MwxDXm2MTDYpitICutNQbF3DenSjH0R7tnoLxNvjWVlMtSK7RnLN+7+DYFmZKZp6rVDHJ5McLGEmr+ruH2cqEUaC6ydW6CZqmmgYDR6AqfpAVGXKfwiheyBpAsLI9OV69Eb9EC241jG95zme8CkivEQyak8D5uAn979d5T8eaO2pTBykjZc0nhPBDLAnWH4q21dey7TNEGxI1s57Ti/KRxfcH4MQrrt8pd+oxbjMezERnOnV1Bq+DxCTjTpiPTogC9FUyi7GHldF62tfZW2hqoYcZ5VpSCwm+av9OLyNN/N2qP4ZhKsc5wAmQpQ8bUm
 33eQNf4d
 MWTn5SKiVCiRs/IT552zSSpR7feN3LmcLQaDyF4aaiG9Blc8GyNQAS2SIEZer0zzbHXdCNxs4z1C47ZX14dZ63NIYpZZIO46cbXelGkbg9rgCy7jiHLEitOjsJ0yRh0N2CGc/j3KCKFe5Qe7kE9a+e8aeR6aMJiR4LfOqabqwHhdrSMcMR5XASldBkUjHnPFzfjw738zTdE20+5b2KPAF0NkmyvWK92yJYrnx6K1EKSmNOL5sbP7wZbKym4b/u8fOqXhXGqJXVPfjNYqF+F1zzcJxQ05UmEvvuUMFYM+2IBou9YgQ//bZOxbynhMXETg4SLwqvpiErjvyRFnWOem2CvEWCkO8fgDEwFfPpLOZOnVT3zgsHMTunFoM1Mcgp1mzWDVSpvnQjZVljU3CYNm28/AeCdjFyhGCMfzLLQJjnLqH7bOd0saTx3ajB2xVAx/oAC+oDW39Hl+3DwI0xoqLraufpogS7xd7antIE0xpyt1YaYRq1MyZVDNZA0S7XdckmtFd133IPRGXhkdFB7QZOu7oIoGryF0hvdCqkuSxE4AKuyU/RmTIgEMLfl60wK1cq3CfRDRuHLhfum0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 9:55 PM Uladzislau Rezki <urezki@gmail.com> wrote:
>
> On Thu, Dec 18, 2025 at 02:01:56PM +0100, David Hildenbrand (Red Hat) wrote:
> > On 12/15/25 06:30, Barry Song wrote:
> > > From: Barry Song <v-songbaohua@oppo.com>
> > >
> > > In many cases, the pages passed to vmap() may include high-order
> > > pages allocated with __GFP_COMP flags. For example, the systemheap
> > > often allocates pages in descending order: order 8, then 4, then 0.
> > > Currently, vmap() iterates over every page individually—even pages
> > > inside a high-order block are handled one by one.
> > >
> > > This patch detects high-order pages and maps them as a single
> > > contiguous block whenever possible.
> > >
> > > An alternative would be to implement a new API, vmap_sg(), but that
> > > change seems to be large in scope.
> > >
> > > When vmapping a 128MB dma-buf using the systemheap, this patch
> > > makes system_heap_do_vmap() roughly 17× faster.
> > >
> > > W/ patch:
> > > [   10.404769] system_heap_do_vmap took 2494000 ns
> > > [   12.525921] system_heap_do_vmap took 2467008 ns
> > > [   14.517348] system_heap_do_vmap took 2471008 ns
> > > [   16.593406] system_heap_do_vmap took 2444000 ns
> > > [   19.501341] system_heap_do_vmap took 2489008 ns
> > >
> > > W/o patch:
> > > [    7.413756] system_heap_do_vmap took 42626000 ns
> > > [    9.425610] system_heap_do_vmap took 42500992 ns
> > > [   11.810898] system_heap_do_vmap took 42215008 ns
> > > [   14.336790] system_heap_do_vmap took 42134992 ns
> > > [   16.373890] system_heap_do_vmap took 42750000 ns
> > >
> >
> > That's quite a speedup.
> >
> > > Cc: David Hildenbrand <david@kernel.org>
> > > Cc: Uladzislau Rezki <urezki@gmail.com>
> > > Cc: Sumit Semwal <sumit.semwal@linaro.org>
> > > Cc: John Stultz <jstultz@google.com>
> > > Cc: Maxime Ripard <mripard@kernel.org>
> > > Tested-by: Tangquan Zheng <zhengtangquan@oppo.com>
> > > Signed-off-by: Barry Song <v-songbaohua@oppo.com>
> > > ---
> > >   * diff with rfc:
> > >   Many code refinements based on David's suggestions, thanks!
> > >   Refine comment and changelog according to Uladzislau, thanks!
> > >   rfc link:
> > >   https://lore.kernel.org/linux-mm/20251122090343.81243-1-21cnbao@gmail.com/
> > >
> > >   mm/vmalloc.c | 45 +++++++++++++++++++++++++++++++++++++++------
> > >   1 file changed, 39 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > > index 41dd01e8430c..8d577767a9e5 100644
> > > --- a/mm/vmalloc.c
> > > +++ b/mm/vmalloc.c
> > > @@ -642,6 +642,29 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
> > >     return err;
> > >   }
> > > +static inline int get_vmap_batch_order(struct page **pages,
> > > +           unsigned int stride, unsigned int max_steps, unsigned int idx)
> > > +{
> > > +   int nr_pages = 1;
> >
> > unsigned int, maybe

Right

> >
> > Why are you initializing nr_pages when you overwrite it below?

Right, initializing nr_pages can be dropped.

> >
> > > +
> > > +   /*
> > > +    * Currently, batching is only supported in vmap_pages_range
> > > +    * when page_shift == PAGE_SHIFT.
> >
> > I don't know the code so realizing how we go from page_shift to stride too
> > me a second. Maybe only talk about stride here?
> >
> > OTOH, is "stride" really the right terminology?
> >
> > we calculate it as
> >
> >       stride = 1U << (page_shift - PAGE_SHIFT);
> >
> > page_shift - PAGE_SHIFT should give us an "order". So is this a
> > "granularity" in nr_pages?

This is the case where vmalloc() may realize that it has
high-order pages and therefore calls
vmap_pages_range_noflush() with a page_shift larger than
PAGE_SHIFT. For vmap(), we take a pages array, so
page_shift is always PAGE_SHIFT.

> >
> > Again, I don't know this code, so sorry for the question.
> >
> To me "stride" also sounds unclear.

Thanks, David and Uladzislau. On second thought, this stride may be
redundant, and it should be possible to drop it entirely. This results
in the code below:

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 41dd01e8430c..3962bdcb43e5 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -642,6 +642,20 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
 	return err;
 }
 
+static inline int get_vmap_batch_order(struct page **pages,
+		unsigned int max_steps, unsigned int idx)
+{
+	unsigned int nr_pages	 = compound_nr(pages[idx]);
+
+	if (nr_pages == 1 || max_steps < nr_pages)
+		return 0;
+
+	if (num_pages_contiguous(&pages[idx], nr_pages) == nr_pages)
+		return compound_order(pages[idx]);
+	return 0;
+}
+
 /*
  * vmap_pages_range_noflush is similar to vmap_pages_range, but does not
  * flush caches.
@@ -658,20 +672,35 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 
 	WARN_ON(page_shift < PAGE_SHIFT);
 
+	/*
+	 * For vmap(), users may allocate pages from high orders down to
+	 * order 0, while always using PAGE_SHIFT as the page_shift.
+	 * We first check whether the initial page is a compound page. If so,
+	 * there may be an opportunity to batch multiple pages together.
+	 */
 	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
-			page_shift == PAGE_SHIFT)
+			(page_shift == PAGE_SHIFT && !PageCompound(pages[0])))
 		return vmap_small_pages_range_noflush(addr, end, prot, pages);
 
-	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
+	for (i = 0; i < nr; ) {
+		unsigned int shift = page_shift;
 		int err;
 
-		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
+		/*
+		 * For vmap() cases, page_shift is always PAGE_SHIFT, even
+		 * if the pages are physically contiguous, they may still
+		 * be mapped in a batch.
+		 */
+		if (page_shift == PAGE_SHIFT)
+			shift += get_vmap_batch_order(pages, nr - i, i);
+		err = vmap_range_noflush(addr, addr + (1UL << shift),
 					page_to_phys(pages[i]), prot,
-					page_shift);
+					shift);
 		if (err)
 			return err;
 
-		addr += 1UL << page_shift;
+		addr += 1UL  << shift;
+		i += 1U << shift;
 	}
 
 	return 0;

Does this look clearer?

Thanks
Barry

