Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14D0DC44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 16:03:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E7ED6B009B; Wed, 15 Jul 2026 12:03:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BF576B009D; Wed, 15 Jul 2026 12:03:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D5A96B009E; Wed, 15 Jul 2026 12:03:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD64D6B009B
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:03:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 82DF91C014F
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:03:32 +0000 (UTC)
X-FDA: 84991481064.17.3613AE9
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id B150C14001A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:03:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GdUJteil;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784131410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wq4Xlfz2K7spej/LQ8u/PS2u0PCFcebceIGSlDs05bg=;
	b=KNoHAevBV9Y53ifvMV+6Afz/a4Gza9udgSXJgYj4xhHi5Er8XAfGF955I0VxXBRQqnKY4J
	AOfR40b0nZAYy2uJTiMflFn9iBDGIudeFNTlQGe0aIjh/B0bhXgzoMigqHTAgbEp1r/+XD
	Dss+2kzgjku6e8Mi24j04krcFR1Qp04=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GdUJteil;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784131410;
	b=Sj9i4EpwkZamuFnl6iCBvSnbct1677dSODSveFJaah1r5S/xE4TSMN7mHRUgDuUOKS/dGL
	NOKnmZuk9XvcrhzgAkBnEtt9WNFxMpM4xDcH3qrMRbXGw0io+zxWg0fW/V8I0OFEWbctlz
	+l54+V4KGQ2TZ62CNHsHTauKDVAPZBs=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2cc6dd436c6so28075955ad.2
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784131409; x=1784736209; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wq4Xlfz2K7spej/LQ8u/PS2u0PCFcebceIGSlDs05bg=;
        b=GdUJteil9LqU8j1qCg6KiiVNZLUzTT8Y8NJtULtsyVzYGa75tekBUrHGAwRKgl92Qn
         Zy/QfuJNKStkwHDZUTXBjM3Bov5hHfdemhsPEEQ/nJT3hQC0AYtEGk6DMJvTBIdEXwNE
         Pe9DmKKDP7PM+f0PoHIzDHC8LquW4CWh4B1+92OdKhU1GUDu6vn4hCkvoY66XIMW9H8d
         cdShIMdKt/wYGCo14dVwOQ2boyPzitNTCiYSNxm7ftkr1ByCNCMAFI4jsabH+Euuga01
         CzPcNANWGfBnCFIpV87J9To2NRCS2aD65avmtZhMptFrK40uG1of1teOr1WPPbMEG9f9
         2mdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784131409; x=1784736209;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wq4Xlfz2K7spej/LQ8u/PS2u0PCFcebceIGSlDs05bg=;
        b=bUUuhRpJfoVXY1DD2IVJO6FP+ElQvqe7xNZ/r7DhD71vRHpmU1yvGxSvmeBm+BNfdS
         yU4Y0kvGo/PNDhKUadc3J/X/pLBzPVVBlOljqpt5DspWbkZ3CcMj5x90zgdxfc7psNQo
         sp02TNAeKPkfY2bx15DlJmWaN9mU/X4nan9HgS4xkIpiHjwzomtVq3Np4+w964ilLd60
         +ANgySxZ1tfR2CwbMVXLeWOAqN/9plJcLAkVJrKmTpu0XlSzQrbc5FgD+2iPBfsreJgi
         nC97/VJoBCX1JPCUXTYy8ayvJpWRxTo085nrMyFmSGn4kq/BS2hez982bD5UT4I17/5w
         qIjA==
X-Forwarded-Encrypted: i=1; AHgh+RpCMdVrPNXtmtrH3N93/rgdVXS6RuVVW/EyUjWxbHVGohSKfwYu1woV/khmL+FEvtRWOGGKR6SK1A==@kvack.org
X-Gm-Message-State: AOJu0Ywl6d2ydhDWYMsENJSloC0sE5Ijsnmwfn8nofv1uy0QVECbubqT
	QUqSP5cU/vWAEIztXMITevwjY0lUBOyY5vJRlrnAo8rmWX1doKGHOidq
X-Gm-Gg: AfdE7cl81U6hP4u1gBNVX3Rgc6ULjOWPwaK6Kzm158iLr8/1Put3ukaCqCx5I+y4vGd
	qADuK4RM/EiY+UD1SrSHGnpxmfEEoTGxzcVc6cTPaKL2Upi8BR3xCKaNIIcrzumEl/upLJed2rT
	9d1EhxeFdURYwr7A/PmoKCEm06XZgRTxmj0Y6Lz7xXckBqwtNVz/bgaySnOE4rQDChDu1vMB3lS
	bWz6R5ZO0PvHzTAYAia3zyZDP9haovMtu4pohjdiCY8Yh+1AVmBG9vY9WYjXvubbDspEV1kELtt
	xbAcgqvFZCBwsVs6yL2W00sBw0triy1ZF23EHf0aQIu6758kBhG9/topnQQWsWIuUuqYtX1CMZ2
	BUgyT77r4Mzq8LlLk6NRYM0olzFamm66oNUwDoUSkvr7FN6izterb/GyQI0beesIaevArP20/o4
	ZzE7OQloYgySPFqs4yKyMURP+hwSGhjs5N69NKEAQt1MqQATRQ
X-Received: by 2002:a17:90a:d2cf:b0:38e:5e0:74ed with SMTP id 98e67ed59e1d1-38e05e07585mr10053187a91.35.1784131409251;
        Wed, 15 Jul 2026 09:03:29 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e172b6da2sm3435409a91.4.2026.07.15.09.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 09:03:28 -0700 (PDT)
Date: Thu, 16 Jul 2026 00:03:22 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: baoquan.he@linux.dev, akpm@linux-foundation.org, chrisl@kernel.org, 
	usama.arif@linux.dev, kasong@tencent.com, nphamcs@gmail.com, shikemeng@huaweicloud.com, 
	youngjun.park@lge.com, linux-mm@kvack.org
Subject: Re: [PATCH 3/7] mm/swap: also use struct swap_iocb for block I/O
Message-ID: <alZ0fgRSy0RpHxcT@KASONG-MC4>
References: <20260713093350.2154226-1-hch@lst.de>
 <20260713093350.2154226-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713093350.2154226-4-hch@lst.de>
X-Rspamd-Queue-Id: B150C14001A
X-Stat-Signature: 61c7qdu3bgjththc8swzwcuh3jn31bj3
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784131410-675635
X-HE-Meta: U2FsdGVkX19Pe+kxRGt3FsU2X/dKvZcmlFGHEr0X/sElmHSuPI9Z2iqrsDHh1sXoHdfD4XpnVEWY1OQBF821rrPI52qn7ckAojAWeEXP+WFcaNyNic/RdmCFP1vNUlN/ou6HXwVThgnCNhkA3VuLhC183NZIfy3bxcyVdB8DEF/tOYzrgQwQVKNkp7Wqq0/VbLKSqxaB2O0E+FDsEQ+4c9J4fOcjaVOBbun4Vk2+NVGmfHRfI4Cw95A2LnN0iidY6siQpx9PsAIrJy8RqDOaH19i6R4/O0zYcgZ6IVj3kiqDPkw8dNGmL9NKiT7RTq+GngsdyWN7L6RQQbxKK37yWu1ZzogcLxJzAw8Lde7t6nMyihRmrmfpg8UK6cNiKbUDtLdyYRuFf1yzNWuhgd0IgINM3v6ebcOjsYZXqYC88B8Le4xAX390s7pweeb7oeabi3Er8xuKy1sdLY9fFGRXVtjOv7dCSOykvrI+uMx7aGSU99CPNiDbD/TZNWmjaLcJAaAvkAP0p0SLTKdtmu/vCvCQTo7zu4zu+SZ1LoZsF9ilDSKv3oCCcDVBLnM3/ZbEsE8QFYWinok2Of6k+z3lzcPiPJJMctJ9MGSvuFmFiD9hMpVLALKsMiGsCdyyMAEsjrFRGLlPVXVyu5l46YDiOsumyNjgslk5PKcLAnJXrda7UTRok44e6Orn32/AwXFbdezVpwpqG6Lse5R4D5VF7+KTaz5OWFC6HnxBgiyHeoooH7if+AZz/LkA/SCBNsv+XHxMceZf9dyBD5pcDjoQ5LUdpWby8cUUZ5LW+NEO7VYwe02Lhh8MmDyElUU+9E3d9c6ON+RqDPWjrFztys/uH6tTiLR2gfyKOEpnpJgNEUtZEdKSz18m0wpcRVGRebDS/t3wfIIzVK+S/FgdugVGCvv5R27H00DqLDXPp3EYCa5MSXuC0oS+xLRqOIWMzZOXgdBA3CewvUvE0ZUARBP
 bWz6k2Ll
 luCBKsCL9cih2ia0Z+wILttXRjbpHuKSIuRu1eQp23+qMxXhphpWV6NiVP3oaef81GqtkicRRoYpk55sMU0gicJVJ4AJCxJk87yT5RhBi9WiHjrN8BxXE8B3G7I1SOXW7O99f1zMXQvj5H6T1Fqb7VZbPKdEzqjACHS0eErrRt3Rmlce0jGABY77qzCCPWBa8WFlmUGVYYxjJ5opx4liX5eAwC3tznuRLycsuT3EsCTnJbkar3u8hkjcYZ5gewlsZEktOOroEIlOltiI3NgLlgLUIsYcv6Ut4YvkxyEyrqZb/ENYIp+ei+nj8tX0qDoIqyo9vvnnx5trl1VgEH6AB8Uqyw3x5uaKCCb6/aL8v6eXL7Dg/hWrVmv2m1wdcseGXxNVaqYtrE2m3HMY/caT5MUVZk8ZcTcUnd+YeqHbv72mr87ecBXkA1ebRWlVJAmga7AmPJYCH1kSzr2B5+8J0UxpyKqqgSnNxS/BHeZfuP29cdRg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 11:33:40AM +0800, Christoph Hellwig wrote:
> Block I/O benefits from batching just as much as remote file systems.
> Extend struct swap_iocb to support building a bio on the fly as well,
> and rewrite the block based swap code for it.  This especially benefits
> submit_bio based drivers that do not have the block plugging available,
> but also saves allocating extra bios for blk-mq drivers.
> 
> Add a pre-allocated bio to struct swap_iocb in a union with kiocb
> used for file system based swap so that struct swap_iocb can be used
> for all swap I/O, and initialize the pool for it unconditionally.
> 
> Various low-level bdev and fs functions are now replaced with a unified
> can_merge/add/submit scheme.
> 
> Note that the block based swap code now uses the same memcg-based
> check previously added for file system based swap as well.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  mm/page_io.c  | 526 ++++++++++++++++++++++++--------------------------
>  mm/swap.h     |   1 +
>  mm/swapfile.c |   9 +-
>  3 files changed, 254 insertions(+), 282 deletions(-)

Hi, thanks for the great work, sorry for the joining this late as I spent
quite some time on the new swap priority list, now checking this series.

> 
> diff --git a/mm/page_io.c b/mm/page_io.c
> index fe24a49e034c..0195c25a77eb 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -28,54 +28,6 @@
>  #include "swap.h"
>  #include "swap_table.h"
>  

...

> @@ -336,11 +306,18 @@ static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
>  		css_put(css);
>  }
>  #else
> +static bool folio_blkg_can_merge(struct folio *folio, struct folio *prev_folio)
> +{
> +	return true;
> +}
>  #define bio_associate_blkg_from_page(bio, folio)		do { } while (0)
>  #endif /* CONFIG_MEMCG && CONFIG_BLK_CGROUP */
>  
>  struct swap_iocb {
> -	struct kiocb		iocb;
> +	union {
> +		struct kiocb	iocb;
> +		struct bio	bio;
> +	};
>  	struct bio_vec		bvecs[SWAP_CLUSTER_MAX];
>  	int			nr_bvecs;
>  	int			len;
> @@ -360,171 +337,70 @@ int sio_pool_init(void)
>  	return 0;
>  }
>  
> -static void sio_write_complete(struct kiocb *iocb, long ret)
> +static bool swap_can_merge(struct swap_io_ctx *ctx, struct folio *folio,
> +		int rw)

Will a bool rw suits better?

>  {
> -	struct swap_iocb *sio = container_of(iocb, struct swap_iocb, iocb);
> -	struct page *page = sio->bvecs[0].bv_page;
> -	int p;
> +	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
> +	struct bio_vec *last_bv = &ctx->sio->bvecs[ctx->sio->nr_bvecs - 1];
> +	struct folio *prev_folio = bvec_folio(last_bv);
> +	size_t prev_folio_size = folio_size(prev_folio);
>  
> -	if (ret != sio->len) {
> -		/*
> -		 * In the case of swap-over-nfs, this can be a
> -		 * temporary failure if the system has limited
> -		 * memory for allocating transmit buffers.
> -		 * Mark the page dirty and avoid
> -		 * folio_rotate_reclaimable but rate-limit the
> -		 * messages.
> -		 */
> -		pr_err_ratelimited("Write error %ld on dio swapfile (%llu)\n",
> -				   ret, swap_dev_pos(page_swap_entry(page)));
> -		for (p = 0; p < sio->nr_bvecs; p++) {
> -			page = sio->bvecs[p].bv_page;
> -			set_page_dirty(page);
> -			ClearPageReclaim(page);
> -		}
> -	}
> +	if (ctx->sis != sis)
> +		return false;
>  
> -	for (p = 0; p < sio->nr_bvecs; p++)
> -		end_page_writeback(sio->bvecs[p].bv_page);
> +	if (sis->flags & SWP_FS_OPS) {
> +		if (swap_dev_pos(folio->swap) !=
> +		    swap_dev_pos(prev_folio->swap) + prev_folio_size)
> +			return false;
> +	} else {
> +		if (swap_folio_sector(folio) !=
> +		    swap_folio_sector(prev_folio) +
> +		    (prev_folio_size >> SECTOR_SHIFT))
> +			return false;
> +		if (rw == WRITE && !folio_blkg_can_merge(folio, prev_folio))
> +			return false;
> +	}
>  
> -	mempool_free(sio, sio_pool);
> +	return true;
>  }
>  
>  
> -static void swap_writepage_bdev_sync(struct folio *folio,
> -		struct swap_info_struct *sis)
> -{
> -	struct bio_vec bv;
> -	struct bio bio;
> -
> -	bio_init(&bio, sis->bdev, &bv, 1, REQ_OP_WRITE | REQ_SWAP);
> -	bio.bi_iter.bi_sector = swap_folio_sector(folio);
> -	bio_add_folio_nofail(&bio, folio, folio_size(folio), 0);

bio_add_folio_nofail also increased bi_vcnt, now it's open coded and
bi_vcnt stays zero, it's not used right now, could there be any user
of it in the future?

> -
> -	bio_associate_blkg_from_page(&bio, folio);
> -	count_swpout_vm_event(folio);
> -
> -	folio_start_writeback(folio);
> -	folio_unlock(folio);
> -
> -	submit_bio_wait(&bio);
> -	__end_swap_bio_write(&bio);
> -}
> -
> -static void swap_writepage_bdev_async(struct folio *folio,
> -		struct swap_info_struct *sis)
> +void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio)
>  {

... The git diff is not very human readable but fine, here
we have __swap_writepage not doing IO anymore but add the folio
and deferred the IO ...

> +	swap_add_folio(ctx, folio, WRITE);

So this removes swap_writepage_bdev_sync (which was calling submit_bio_wait),
we are replying on a later swap_write_submit, and just add the folio to ctx.

In the previous patch, swap_write_submit is called after the whole batch of
folio is iterated, so there is no more IO completion in pageout().

Before the series, pageout will detect for writeback finished and clean
pages under PAGE_SUCCESS, if the IO of a page is done and writeback flag
cleaned, the page get released immediately. But now, almost all pages
will be put back to the LRU waiting for rotation. This also make the
reclaim have a stronger bias towards reclaim files, and anon reclaim
become less effective.

I do observe a real performance regression with classical LRU and ZRAM,
ordinary swap seems also very slightly effected but could be noise,
test is done on my laptop by building the kernel using make -j12 and
tinyconfig in a 2G VM with mild pressure:

Before this series (With NVME, in a virtual machine, NVME drive exposed
to the VM by virtio):
152.02user 42.34system 0:32.07elapsed
3303408inputs+0outputs (83567major+15910796minor)pagefaults

After this series:
155.72user 46.19system 0:33.88elapsed
3617720inputs+0outputs (94045major+16094079minor)pagefaults

Before this series (with 8G ZRAM only):
175.39user 125.89system 0:40.54elapsed
26581840inputs+0outputs (1186391major+22698964minor)pagefaults

After this sereis:
165.59user 216.02system 1:04.06elapsed <- the problemic one.
53531464inputs+0outputs (2550441major+31974007minor)pagefaults

Because all anon folios will be derfer freed on next iteration of the LRU,
which caused a much higher memory pressure.

And, very interestingly, with MGLRU, things are looking better in
every way (which is kind of expected, see below):

Before this series (With NVME, in a virtual machine, NVME drive exposed
to the VM by virtio):

155.96user 42.15system 0:30.57elapsed
2057792inputs+0outputs (75116major+15860836minor)pagefaults

After this series:
150.42user 44.18system 0:31.21elapsed
2545616inputs+0outputs (69325major+16141325minor)pagefaults

Before this series (with 8G ZRAM only):
175.57user 120.27system 0:36.32elapsed
24655320inputs+0outputs (1568694major+22468687minor)pagefaults

After:
180.59user 119.43system 0:36.18elapsed
23893384inputs+0outputs (1546158major+22302635minor)pagefaults

I only testes each case for 5 times and take the median result, it
could be a bit noisy but good enough for now, the results are mostly stable.

So in summary when using classical LRU with ZRAM, there is a major regression
because pageout can no longer free any page directly (40s -> 1min), all page
have to do a round trip to the LRU again before gets freed. Other cases are
mostly fine, but maybe pageout might catch a few clean folios before even
for ordinary devices and free them directly? So we are seeming a slightly
higher major fault due to deferred free / IO? (Could be noise though).

Things are looking good with MGLRU, because MGLRU have a secondary
retry for clean folio direct reclaim even if pageout() didn't do that
(see the "retry folios that may have missed folio_rotate_reclaimable"
comment, that comment isn't that correct either though).

I remember Barry mentioned that someone once tried to implement a similar
secondary retry for classical LRU too, but got rejected.

I think this better be fixed form the LRU side to always try batch free
the clean folios after one iteration, which is also part of unifying
MGLRU / LRU, compression (either ZRAM / ZSWAP) may also benefit from
batching though, and free the folios in batch it could be even better.

That could take more time though, so shall we have a way to just submit
the IO early for now?

