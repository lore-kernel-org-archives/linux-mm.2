Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7B76CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 13:08:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DE818E0044; Mon, 18 Aug 2025 09:08:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B5EA8E000B; Mon, 18 Aug 2025 09:08:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CC038E0044; Mon, 18 Aug 2025 09:08:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3BD658E000B
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 09:08:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D8C101187A4
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 13:08:29 +0000 (UTC)
X-FDA: 83789907138.26.1FA1D70
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id BEC1240011
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 13:08:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="KFapMUo/";
	spf=pass (imf27.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755522507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HyuVXrZJ7tQHSn/WZiZiqfIBmKXwsNldZJSI/ZLU+6s=;
	b=MmkNg8GOBxXtauake4jXFFMmoeroJIYNSA8Dk8ThVqMiHNbQZfEjczjp86GzOEOcDee8VY
	vSQqb942GVya+cNaW+Ha7J9jujoGfa2FesUUvTUv+ECe7xCLRMQ/KcPh6G/LCPFUmCq7Ra
	BeJ4Bqyv3Q6d1ziMR2hh0n8C+diZUT8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755522507; a=rsa-sha256;
	cv=none;
	b=cIvYj31MZYM8XGMTmfH+YKNV49ZfuWDq9dcMCaWNAjDRntQp0Z0SdHr0pbOIGzmuAUNMiT
	D0Mtu0dXhHfmi35zRmtvQfHKI+ik60X2rfjLPPuuKhb+8TR1EaaKTxzROpUo0Is/hci6ac
	XDgHtIbXiBf0oRZ/gLg3qkuW3Sig4Is=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="KFapMUo/";
	spf=pass (imf27.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-55ce526627dso4175158e87.3
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755522506; x=1756127306; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HyuVXrZJ7tQHSn/WZiZiqfIBmKXwsNldZJSI/ZLU+6s=;
        b=KFapMUo/gKuoh7q5i6u8vOreh8tBqmVFUh40MCnq+NsigG2jGiMMxDkWqMtmhXAJrC
         xZgfMzDtV2eVLCdW3csSnHqxtvE52NKbqnTILK7PqMI3j1EjP1prITQ1t3gXT5AwCsPG
         VdMhYiM5jZfn9W2ovRQTXlRQZmeNSNX3IkdScvHL1s750cxS0o95L1GHxVwfUgNeISKX
         WhfPwOQ6hOb++cZpL1cT4IDBcGc1G68S16fN7B3+4asUV8IiEc/Ef4El+IvIHsRQ5nbu
         U0XpMaU+ebcGaGUvsJeX7aXpqFiJxWHCgOzZJU//LcBfhFSLg9ivNbVZqfgDvrkIWtmc
         up/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755522506; x=1756127306;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HyuVXrZJ7tQHSn/WZiZiqfIBmKXwsNldZJSI/ZLU+6s=;
        b=KzlPbiD/h6pvUilcE68UMSUH6mLT/nEObjIX6ntXgZ0Pe0K5PVpSmyH4xak2CuK0XB
         6NamLtuMlOICaFz255r+Fty6VbC9l9ZnPnuNlk30O+zSGgMq4ojB3WwlZHYP0EajxeUl
         NeQeXQOFRJzilwAI8dmtf0f7mw5/6a8u9YSMQzeFe2RS1fqTgiVAqTM8psdBjQd6fezI
         uc3b0JA3D6t8Hrlp5fcBJ5MoKxB7jPoNUdzdSZUhYi0rT/voFcrmv8VjR9lj5eZd05U9
         q4JQ7B3Ar0iCwfNv8nsLGNN2+yRuZVO3WRLJW0cjmfrMh+jHBdjaak8TNtLnws4Encqi
         kyAg==
X-Forwarded-Encrypted: i=1; AJvYcCVjPoPcaJvyJwm5oNMydPkf3n2g8GmWG5LNC2fyAuJ10SNbrWSpt108NHidCSRpLvcJXqaKtTHjVw==@kvack.org
X-Gm-Message-State: AOJu0YymtyJtTMAXhjibED2oVNgeNS8x/scoBdVAE+wz6XzZ7BRqHcWS
	AW7wikSdrIC0eNAWi0Hc5CYoMaEV3THppcz3ckbYz80Hcc1j2dB2gSOCCQYXJw==
X-Gm-Gg: ASbGncuJicNLa33vxVY9BSIUTwCH/+Kz5wa5+5uaXsH5t51dEM8Fz11aOVMFLF/VYq9
	yK7eomkXsiCQPfGb5Df3SoSR0XzVHGrxEjTgvdDCdsADe+ZKXIlSWZhXjQnAzGSdSu1Q1z3j+hR
	bKjAbDTtbjVCgbBMAuP2rHnRqG1ISrtWZj41aJ3TtIoapkxWIkQjeUoTxO4gKo66Z1JhIj0SjAf
	ZgSBZfHP5gOafsAgI5Cb6Cn5K/kle4E3OcwltKwkoynaIVBSJ1g603COckvINgtxVdholspaA92
	ORz62e8CCBEoug9ASFbi5Wewbn0k4VZpG8F//J/XdDKf2o79TaX2fmdw3n3qnTDDFEssZS1PuQ0
	ZfB46bMwGe1/cFRpvX8CXxM1aTm5IMUUowBKIPuSjs39P9GHBEA==
X-Google-Smtp-Source: AGHT+IEIBUpvwsmKHbgEdF4HCrjf2IRGG5QGH8UtbpE1PIOQZSfKKpE3aMnzFvwN1+GQhKFI7y2drA==
X-Received: by 2002:a05:6512:2906:b0:55b:827d:e377 with SMTP id 2adb3069b0e04-55cf2c82686mr1712655e87.22.1755522505558;
        Mon, 18 Aug 2025 06:08:25 -0700 (PDT)
Received: from pc636 (host-95-203-21-145.mobileonline.telia.com. [95.203.21.145])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55cf4d0d181sm1102471e87.57.2025.08.18.06.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 06:08:24 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Mon, 18 Aug 2025 15:08:23 +0200
To: Baoquan He <bhe@redhat.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] mm/vmalloc: Support non-blocking GFP flags in
 __vmalloc_area_node()
Message-ID: <aKMlx_sATwnGsXXp@pc636>
References: <20250807075810.358714-1-urezki@gmail.com>
 <20250807075810.358714-8-urezki@gmail.com>
 <aKKthIZbD4oNywY4@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKKthIZbD4oNywY4@MiWiFi-R3L-srv>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BEC1240011
X-Stat-Signature: 753cu1tihafq6k7jmd6iukptmqw835j3
X-Rspam-User: 
X-HE-Tag: 1755522507-575952
X-HE-Meta: U2FsdGVkX18LNNxtekLq1qNBAGc0Yg/ZxZnBMZASEtnIC1ZWy1xMw57064X4Z8Rl8TE75EYNSai2D7cb7hy9Esfc7eLaz6GA4U+mFlbo6WeO3llrOuPFv/ru90tbE2lvA55EsqMgoZ3VmekgbYp7EZAoVJLdBvftkoUseVncvWWidyMnyGsANFQ370JnI0uJRK7cgzQZO+UfdI82ZfEWeCu8RbOBFJ4PwfJzbLCcihfFVuBzRRUaSD2r4uwP3UCUKfXRkOQt4zOI0yzxZe3Nut52MTDM5B57Mn3vgvlL1TSA73HRMzqdBG7/exm/WiJfkAsMa1Hosczlq3S1jRHcQzpcKN+WQwkwqnvO/Zi65bMkppb30vSx9DeNEOfOdSbXklH0AiVf1macrrgpTnB5MBlGKBr1ogRNRTJhR4rRXxRQEjmzPh29MewuNP5MPl5D5Z7ZsfNEekHuO13LmQujm4I8WG7csjFmO9tC5W887ejG0pjc1MXTM1j78Mjw55XsjteUrr9qUG1UU40os2B3eIlb69mhyDIqn2ap9HC93EOvYl49s2JxrbgpysdKBcskjnVYaWB2wLUqmlo0HDgNoeqDidDBb8o73hg+aJS7bzlAsB7eH7ntRzA+0rte08O5PlUQ9ESZ0GT+PtVoexkUzfT1rT52wA9pdIp3i8mHEzgqGv1iSK7PWtQ4CO1xSCm+vEJeTta0/RROcv+5bXGrhT036Oq+Sk5YulUVEfC52mmsSdgN7LQN89nUJwh5Vj1Y0a3g+kLFxekt1vUOHqMAdyjA5QVN45ExI6HL2Ad/zvqAxFF47ruCfS3N35XIG3RsU7EmSi0EPncfjWXMG282AvWWcPbnOasuBZ9hohdHyQbt4WKii28vH9OMK+XNosmA5jANJVTRkYxtNApTmG7dwdjasXyYB/i0KqqZn30hDi89u9vZqRuH2Y8KeT4r3D0K7WxhtQ5sDKO7KzwiJBy
 NnoG5Reh
 5UcWtLYrdim6vDPRq8n9F5uI6FagNM2nwpE8MODzEos1e5P5LKmqzh7EZQLV3HKYacdpoHYM1w4fcmSoopweB2+XJID77sWuX3L1RHpAA4/MlRaEiGiHqFtj+NJZK/mVfGc07e46A3Iz93OPlhNiClOtLGIREEk+pVTIyhul9ymp6lBIjO+N64LvZws7Bzw5Tf1Qp6pv4RSr+ACdqh2Ua3hlWlOGiEXXspNATIElhf4QTWgf6fdTP2QOws09/iwImnIAGPe/hKUejkHHf8sHa6bMVsH6iyfLLFo0e3WPF7D/J5z7MAFVb4kZFTQfRbctpyOYQ0qsTyPjrAC/K/Zb4s2K4PZcaNtxXgXXNvsE4C1Osqrp4NGXvah3ugeEeRy69Qxa/A7glyvvH3DHijHWjFeCkp7yxg1HY4XEUOVo6JAJ7/FwUlGkFqi4oFtBhmj/qs7QhNWIavK/pOYYGhHUXVp/IgNW5EjmT9eL3GskmHUE/SaBB18YCfmhNjA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 12:35:16PM +0800, Baoquan He wrote:
> On 08/07/25 at 09:58am, Uladzislau Rezki (Sony) wrote:
> > This patch makes __vmalloc_area_node() to correctly handle non-blocking
> > allocation requests, such as GFP_ATOMIC and GFP_NOWAIT. Main changes:
> > 
> > - Add a __GFP_HIGHMEM to gfp_mask only for blocking requests
> >   if there are no DMA constraints.
> > 
> > - vmap_page_range() is wrapped by memalloc_noreclaim_save/restore()
> >   to avoid memory reclaim related operations that could sleep during
> >   page table setup or mapping pages.
> > 
> > This is particularly important for page table allocations that
> > internally use GFP_PGTABLE_KERNEL, which may sleep unless such
> > scope restrictions are applied. For example:
> > 
> > <snip>
> > __pte_alloc_kernel()
> >     pte_alloc_one_kernel(&init_mm);
> >         pagetable_alloc_noprof(GFP_PGTABLE_KERNEL & ~__GFP_HIGHMEM, 0);
> > <snip>
> > 
> > Note: in most cases, PTE entries are established only up to the level
> > required by current vmap space usage, meaning the page tables are typically
> > fully populated during the mapping process.
> > 
> > Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> > ---
> >  mm/vmalloc.c | 20 ++++++++++++++++----
> >  1 file changed, 16 insertions(+), 4 deletions(-)
> > 
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index 2424f80d524a..8a7eab810561 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -3721,12 +3721,20 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
> >  	unsigned int nr_small_pages = size >> PAGE_SHIFT;
> >  	unsigned int page_order;
> >  	unsigned int flags;
> > +	bool noblock;
> >  	int ret;
> >  
> >  	array_size = (unsigned long)nr_small_pages * sizeof(struct page *);
> > +	noblock = !gfpflags_allow_blocking(gfp_mask);
> >  
> > -	if (!(gfp_mask & (GFP_DMA | GFP_DMA32)))
> > -		gfp_mask |= __GFP_HIGHMEM;
> > +	if (noblock) {
> > +		/* __GFP_NOFAIL and "noblock" flags are mutually exclusive. */
> > +		nofail = false;
> > +	} else {
> > +		/* Allow highmem allocations if there are no DMA constraints. */
> > +		if (!(gfp_mask & (GFP_DMA | GFP_DMA32)))
> > +			gfp_mask |= __GFP_HIGHMEM;
> > +	}
> >  
> >  	/* Please note that the recursion is strictly bounded. */
> >  	if (array_size > PAGE_SIZE) {
> > @@ -3790,7 +3798,9 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
> >  	 * page tables allocations ignore external gfp mask, enforce it
> >  	 * by the scope API
> >  	 */
> > -	if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
> > +	if (noblock)
> > +		flags = memalloc_noreclaim_save();
> > +	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
> >  		flags = memalloc_nofs_save();
> >  	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
> >  		flags = memalloc_noio_save();
> > @@ -3802,7 +3812,9 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
> >  			schedule_timeout_uninterruptible(1);
> >  	} while (nofail && (ret < 0));
> >  
> > -	if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
> > +	if (noblock)
> > +		memalloc_noreclaim_restore(flags);
> > +	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
> >  		memalloc_nofs_restore(flags);
> >  	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
> >  		memalloc_noio_restore(flags);
> 
> Can we use memalloc_flags_restore(flags) directly to replace above if
> else checking? It can reduce LOC, might be not as readable as the change
> in patch surely. Not strong opinion.
> 
> 	memalloc_flags_restore(flags);
> 
I agree, those if/else cases looks ugly. Maybe adding two save/restore
functions are worth doing specifically for vmalloc part.

--
Uladzislau Rezki

