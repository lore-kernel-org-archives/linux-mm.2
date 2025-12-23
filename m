Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E247E6FE41
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 21:23:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E86E6B0005; Tue, 23 Dec 2025 16:23:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 796536B0089; Tue, 23 Dec 2025 16:23:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BFE36B008A; Tue, 23 Dec 2025 16:23:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 599A46B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 16:23:51 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 21A1D59516
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 21:23:51 +0000 (UTC)
X-FDA: 84252013062.22.6C5E84A
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf14.hostedemail.com (Postfix) with ESMTP id 212AD10000A
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 21:23:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kCdejj2C;
	spf=pass (imf14.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766525029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aUOtxvoS/dJ0bosqqi9uYzrSZp+RubGpXgIfU8VaOC0=;
	b=ffuNe3G1E90jon4gMRsfD6MX5shQYBVDqi0TIoNrQxmM/VECgPjRvm7NCQAEpt/kGxtvEp
	pTbtp1sawAsXbjctloE+TEq7NYp5s8hVsrtRBy27SgVr7ZD9wZBrI11PWfl5QiDaXIbGp9
	p28ivElx3Pc7mvi+dOI0qpSFF2Dbpfs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kCdejj2C;
	spf=pass (imf14.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766525029; a=rsa-sha256;
	cv=none;
	b=1TMo+WvoDaY7Xn5+9+W6K9ySFLYnIgkHokP2R64blfQlSn3TXIRlu9REkp/mgm6YHmlJ9L
	zPh+xoNVUO8mf3JoetdsUoK5bfvNtsmwGEtpGlYquzycainiKClgXvoxy/dF25pKOTgXGr
	hBydm1/b5YGfcRC9bQl0AmMFr3DBfoM=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7ade456b6abso4493452b3a.3
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 13:23:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766525028; x=1767129828; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aUOtxvoS/dJ0bosqqi9uYzrSZp+RubGpXgIfU8VaOC0=;
        b=kCdejj2CeydkskvfU158qCltreIaKYuXQyuXG5br4OS3+brjYWLmNZo0SUsEz9C6Tb
         m+esQyb9Ht0zeFHM+WCmoP/STRaJxXoNsYdj7rYsQjqDCYHsZ9yEIsldxOnPfwbRQw3b
         2mgB7TL3aXKHBofEZ8b+LKAXssLHf1C7e9Kh6p9H/ivEhbOZm9jTlM4gmlTU/5mJdWB/
         U5qwgxLHjS49axrPc6jGgP/qtPvfjyicfJSkUuDTSrTS063bN584p8ziLjKc6p336Zwy
         6z88UM7aZoASsEZKYf3KDJI6LXX9ksI2x9+qganFHTZkgr0h2tAB700DHL+h7SwSZ0Ef
         mVdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766525028; x=1767129828;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aUOtxvoS/dJ0bosqqi9uYzrSZp+RubGpXgIfU8VaOC0=;
        b=L81fN85mkVSqSUGQvIf1FQhMTT3S3YqRWz/wzg78AZuOiY48pMTb1YzxcIxOIeseNl
         Zn+3oOqHc8oo8Iza4Gvr+DxWPKzCFBwB6UYG7d05/OFTdQa5SKEYhL8FkomYaD27Ubkv
         yGoHjmqIckpBYcwdDt9c71ztfLzAjfmyTy7X+fZy6EY93oGFYclFhMtgFn4PzAOB4sfe
         XHHibqiKaRSfKfL5I9BH7rBvR06XpI44DnKG/ULiEhcK7IL0aFzXh37evawznYyKwfdN
         zCWM8GibYronPtHOEOfGawDn1PIwDkcpgJqrMpvsH6iVK9H5imw0lG98mScGXh/3LGeh
         f1Zg==
X-Forwarded-Encrypted: i=1; AJvYcCVAbKGnuXDfNBMKITQfrh0hF9PUv3aYufxIzBQeBTYcBBztR/cM51zYI079z3/ztJNvLvOUT2sX5Q==@kvack.org
X-Gm-Message-State: AOJu0YyiAKIIrpd/G4rkvWbL/X9ZW9OSiJiHIhKewOxAJTOnw/1P3dtn
	E8QEM80YfOf5BcogzX1ULARlgTIKA0LlATvpIFIc4ZcwEOWEUdbEwCc1
X-Gm-Gg: AY/fxX5NfhazoeWwST0yvFAy/BFMdzZ9CxrHgcNXnni5JhSeOODpnl/b9pV0SwpUS3I
	t0Kf9htTI2ClCYH1gzjHR7g8+ay4KNecTt3O2IG4DCzLnbyidQSFROZ3OZlToSflzRrPOIQcAPw
	FGnmyF3XeDCPXNV4FhLskatIeS2XzbQbOxEhMpGFgkH7vfhoND0qMahUQ+fqzQoWqxtBmJNLTkP
	9JoOVGiHmGTb7sd83oVdbeE7qtCpR2TaKgE0Bj/riChmNKnjcU08Tb/ph+w/qMC5rjIVhhmRM2i
	vwG8tG5IJMnrLsi0j9Axc/8lAG/Sg+Peg83+vloY7EmOxcUa5uqUcUZy5NfNL/LkuymnncnoHZ0
	OxrIezT6f5biVZbznOeaKQuBEVSFop0Z0/dHoDOhMBKudksSfvqSk3092oFS4/v8XlUbUggyR1r
	j36QVxUPKMqA1MZQZadXcjcTA=
X-Google-Smtp-Source: AGHT+IFjl4NYgeswg6t6gVHpQmyKXq6Zs/y+ycrSPrseIyz6yvUumVrAY0eo9AqIFMVJD/juZ07wKw==
X-Received: by 2002:a05:6a00:3017:b0:781:1f28:eadd with SMTP id d2e1a72fcca58-7ff646f8f08mr13731625b3a.20.1766525027718;
        Tue, 23 Dec 2025 13:23:47 -0800 (PST)
Received: from barry-desktop.hub ([47.72.129.29])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e48cffesm14433009b3a.49.2025.12.23.13.23.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 13:23:45 -0800 (PST)
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
Date: Wed, 24 Dec 2025 10:23:34 +1300
Message-ID: <20251223212336.36249-1-21cnbao@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <aUlC6N1jmDbMDPc5@milan>
References: <aUlC6N1jmDbMDPc5@milan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: ognarot5q4pmw51axwo7teid9658bxzs
X-Rspam-User: 
X-Rspamd-Queue-Id: 212AD10000A
X-HE-Tag: 1766525028-394293
X-HE-Meta: U2FsdGVkX19l8wnt2FSkDsoIV5xjLH7GYFmg/ojnzUGN8jKqiOumCeZ5iGjhskh8ZUjbN/udh4Sh+vYsq9EUa/UbYszFEhkamkS+ZrgI37IIeRoEqLC3MhSVCXy9hKSjFXjgJTaqJzp1ZJkr/OOF5PhPK2sXU1mWwLdxHsCKFpYdE7rZDnXA5m+C4OA1BucGKRXvpRUbaHXWkdeUsPVKSBVjfP6WZrhP5gsNn7Wet3IchlNutPv2aeNhJc2BksU9PuB772jTdOShxSvelqBXTCou3PMOuDE3sRrwOCb/D9cu1XDBgveza5tUHQttg0hcrYFx5C5IYNScy6fJfgzMS5CnAF+/+1Unr/z+HiGlNK/TJ6RuXXoJvz8LPjpr/BTQSH+KokYNSbec9z3dloXAjSg4iscvSh6TNtLp6trnhiRVfCWcBiQTEXd8DavjhPhWP6fqRGftPskeFXsHiF2c66OzvxQn1NmB+mKVpJzRF9ecoAEIks9MUODVeo7Fm5mrmsStRF809i8YX0fr5PWMikQfEu0YyJAwstBxbwdgwq1NWZQ6mBHDzq25ttKIqMn8HVweA+/vPNiJ0uABLDHsGOO15lxzYARzm6tJ4EoqSKJlyOmk6NdFDh/uz5CBkm5fq8rLa8jjH0ao/XgFeNJFhskZOplEgYEL1FF0kL0FuaqXNwwhtlMwhdRqH3Nd8AnUxgE4rylB3uwTYFMV7jwz/wLudJSppnPn3uCYtp4ZnHDsLZhvwqdCFQnQFtBjuoQ8yikB560Uq9NRSKyaP5FYlQ8KEnRoXxYEmCx+X43rS+4j3lS9ypcdV4ehwyrogOtxazCrviCuOJYG5Cp52rOGl/b+s44YPcAyy7WNXGgI4IvmQPE2pCp7XEmyXOG15Z14vu+U2sKOskscAfrzWIZe5NX8xiyhbgQorlyfuDWTXt+ss0cad1lWWcDXx0mjkRR0FcKXE29mxN9jXIl+AO0
 AHr0GEaQ
 EbRBQFl/7P6vNivNecED4CG9DJYIa0IwQn/0xRsxvi9/WexTDMDCBFCLqIMYTNsLArKfkdYuR/0Lz07lqA99QzZKr8KO51nfIh0DjWtvAH+xlURtuMAFoxXURjPzGGjEmJJ3ug6MFesGY3jGnSI5XqhQXksr1ZB8l7B7gbRjznUiB4CQBVohkzCgNRk6zxykGv3yHUGzpKKKPipu91SdVlJ+C4Frbf4CSw/pkz2NX3IqcGUG9elUviFlaJrsbKu+mOBYLica4THvqI/rIO3FEIqdPqoh8Z1o1k6uXUaJF47Q5fnhWBtoaJxQT6/ZIfXwAeLLVLFGIkL0jua/VXGpoHjGlWHS4P9dSUCzVNISNLOtvdt926PL3JoOws6JTP+ZZtjYPBFTJbw2idCW6ihgHFIrV9tpDFTLBlpXl1JFXFOejcLA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >  /*
> >   * vmap_pages_range_noflush is similar to vmap_pages_range, but does not
> >   * flush caches.
> > @@ -658,20 +672,35 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
> >
> >       WARN_ON(page_shift < PAGE_SHIFT);
> >
> > +     /*
> > +      * For vmap(), users may allocate pages from high orders down to
> > +      * order 0, while always using PAGE_SHIFT as the page_shift.
> > +      * We first check whether the initial page is a compound page. If so,
> > +      * there may be an opportunity to batch multiple pages together.
> > +      */
> >       if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
> > -                     page_shift == PAGE_SHIFT)
> > +                     (page_shift == PAGE_SHIFT && !PageCompound(pages[0])))
> >               return vmap_small_pages_range_noflush(addr, end, prot, pages);
> Hm.. If first few pages are order-0 and the rest are compound
> then we do nothing.

Now the dma-buf is allocated in descending order. If page0
is not huge, page1 will not be either. However, I agree that
we may extend support for this case.

>
> >
> > -     for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
> > +     for (i = 0; i < nr; ) {
> > +             unsigned int shift = page_shift;
> >               int err;
> >
> > -             err = vmap_range_noflush(addr, addr + (1UL << page_shift),
> > +             /*
> > +              * For vmap() cases, page_shift is always PAGE_SHIFT, even
> > +              * if the pages are physically contiguous, they may still
> > +              * be mapped in a batch.
> > +              */
> > +             if (page_shift == PAGE_SHIFT)
> > +                     shift += get_vmap_batch_order(pages, nr - i, i);
> > +             err = vmap_range_noflush(addr, addr + (1UL << shift),
> >                                       page_to_phys(pages[i]), prot,
> > -                                     page_shift);
> > +                                     shift);
> >               if (err)
> >                       return err;
> >
> > -             addr += 1UL << page_shift;
> > +             addr += 1UL  << shift;
> > +             i += 1U << shift;
> >       }
> >
> >       return 0;
> >
> > Does this look clearer?
> >
> The concern is we mix it with a huge page mapping path. If we want to batch
> v-mapping for page_shift == PAGE_SHIFT case, where "pages" array may contain
> compound pages(folio)(corner case to me), i think we should split it.

I agree this might not be common when the vmap buffer is only
used by the CPU. However, for GPUs, NPUs, and similar devices,
benefiting from larger mappings may be quite common.

Does the code below, which moves batched mapping to vmap(),
address both of your concerns?

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index ecbac900c35f..782f2eac8a63 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3501,6 +3501,20 @@ void vunmap(const void *addr)
 }
 EXPORT_SYMBOL(vunmap);
 
+static inline int get_vmap_batch_order(struct page **pages,
+		unsigned int max_steps, unsigned int idx)
+{
+	unsigned int nr_pages;
+
+	nr_pages = compound_nr(pages[idx]);
+	if (nr_pages == 1 || max_steps < nr_pages)
+		return 0;
+
+	if (num_pages_contiguous(&pages[idx], nr_pages) == nr_pages)
+		return compound_order(pages[idx]);
+	return 0;
+}
+
 /**
  * vmap - map an array of pages into virtually contiguous space
  * @pages: array of page pointers
@@ -3544,10 +3558,21 @@ void *vmap(struct page **pages, unsigned int count,
 		return NULL;
 
 	addr = (unsigned long)area->addr;
-	if (vmap_pages_range(addr, addr + size, pgprot_nx(prot),
-				pages, PAGE_SHIFT) < 0) {
-		vunmap(area->addr);
-		return NULL;
+	for (unsigned int i = 0; i < count; ) {
+		unsigned int shift = PAGE_SHIFT;
+		int err;
+
+		shift += get_vmap_batch_order(pages, count - i, i);
+		err = vmap_range_noflush(addr, addr + (1UL << shift),
+				page_to_phys(pages[i]), pgprot_nx(prot),
+				shift);
+		if (err) {
+			vunmap(area->addr);
+			return NULL;
+		}
+
+		addr += 1UL  << shift;
+		i += 1U << shift;
 	}
 
 	if (flags & VM_MAP_PUT_PAGES) {
-- 
2.48.1

Thanks
Barry

