Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68F69606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 02:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LvT5tAEc
Received: by kanga.kvack.org (Postfix)
	id 1A97D6B05B0; Sun, 15 Nov 2026 21:46:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15A666B05B1; Sun, 15 Nov 2026 21:46:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0031A6B05B2; Sun, 15 Nov 2026 21:46:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B25496B05B0
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 21:46:53 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 112F21A07E2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:46:53 +0000 (UTC)
X-FDA: 85439444706.25.634D129
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 732F820006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:46:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LvT5tAEc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794797211;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lOVKoA/obEVXNAfiH5EjO2zc3iI4UeUvKoiLIVyJZ9U=;
	b=l6vNSZdgunfECaXjVtaC0L5dmaPSpRhuRht6PtMge5fh5mr1z78EaEZ9Ci6Qslzwb1pxRR
	vndmwqx+URnbiNLtJZcHIYEPAUNoRd3tSQV/Zxy/OQWsCbuNrn9yB0+qe22aZYl76ncO0L
	2fYE8whdeRbxm+mbZdYVD0GaOz1F6uA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794797211;
	b=VzEOCtf8DvpNByzblZhnpblEzszr8AmC432KMZf0hscloWIAO8ggceWcBCmqzImavjFaQj
	5SS7bAqg4obP3zXm01wgFPksExVzThRkhOsRxPMTPwzP6yKh7qFaSuns0xo3LPcI99/f6w
	+nTLEJynewEesRyL4/Ss3jEmrN582Qk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LvT5tAEc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ED66C625F4;
	Mon, 16 Nov 2026 02:46:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C071F000C4;
	Mon, 16 Nov 2026 02:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794797210;
	bh=lOVKoA/obEVXNAfiH5EjO2zc3iI4UeUvKoiLIVyJZ9U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LvT5tAEc107682ctgHCES62wGSjY0PJE9ja3Js3H3uPp82Bph9g0OxWCtJkEk5poM
	 jAyHYRECG4Vxy6XKbjEs5ICueWAOzeEtjxNn6Q8i7nuR72ZhuvZ1HrGaFy62V4dt/1
	 c23sZ/cJhNOmFmphnHKnMWVg0hJQbNv2OeQykc0g5Dyl3mMs0pwwJtqG8j7YF1aVU2
	 nctJK1QRhCBfDvEf0G3Ict70YSVN27jM0Qi0uLeprVbR2sJocuESBm0zXQUNuoFVkc
	 cuerLIX+lx0nCW6gsK0ApXCifsftGkqwT2MBSP4sUlGvu3dx8gJAqvKOhnBVRaU1Dz
	 latAoIdvlmFeQ==
Message-ID: <sashiko-outbox-216089@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v4 2/4] zram: support compression at the granularity
 of multi-pages
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nanzhe Zhao" <zhaonanzhe@xiaomi.com>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Tangquan Zheng" <zhengtangquan@oppo.com>, linux-mm@kvack.org, "Jens
 Axboe" <axboe@kernel.dk>, "Sergey Senozhatsky" <senozhatsky@chromium.org>, "Minchan
 Kim" <minchan@kernel.org>, "Kairui Song" <kasong@tencent.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Nhat Pham" <nphamcs@gmail.com>, "Usama Arif" <usama.arif@linux.dev>, "Yosry
 Ahmed" <yosry@kernel.org>, "Chengming Zhou" <chengming.zhou@linux.dev>, "Chris
 Li" <chrisl@kernel.org>, "David Hildenbrand" <david@kernel.org>, "Ying
 Huang" <ying.huang@intel.com>, "Suren Baghdasaryan" <surenb@google.com>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Kanchana P Sridhar" <kanchana.p.sridhar@intel.com>, "Wajdi
 K Feghali" <wajdi.k.feghali@intel.com>, "Bala Seshasayee" <bala.seshasayee@linux.intel.com>, "Nick
 Terrell" <terrelln@fb.com>, "Barry Song" <baohua@kernel.org>, "Bo Zhang" <zhangbo56@xiaomi.com>
In-Reply-To: <20261115024455.1465726-3-zhaonanzhe@xiaomi.com>
References: <20261115024455.1465726-1-zhaonanzhe@xiaomi.com>
 <20261115024455.1465726-3-zhaonanzhe@xiaomi.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 02:46:49 +0000
X-Stat-Signature: b3hm9iberor6h4ik1ycws6njq3in487m
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 732F820006
X-HE-Tag: 1794797211-731064
X-HE-Meta: U2FsdGVkX1/fMc9j8CwR6ab/6Ruhz91cLvqg+YpwTnxvrE369TwnY9dFBS1ADfJAj33rcnNZJLDb2/7IDPMS8+6pJr2fq74JZtnbdrAeZDEUxfaaJi3P6XzeJM36jvw/I1IIYR9lSEIrfJAios/6x3GbpnWJJFuCMSWVuIRmc+xJoRsSAv1+14GFgDGxcNk+avkug3uZxSZd2W7kvCk9nfn9aFr5PU72IIFrTfTf2YRVUmuflEBMdGOWFIWNWAkMaGw1tt3gaV+NaqVdY5CNrJ7cVOLcKUwD2+XgAXfNLPxjctvZt+87MqZFaCgdpLEP1cXWhh5WMDy7Egoh6RCq4YNkxkVTCbbO4rkMWF8Nv2vtVZa6rGoNAiR94Gg2KLNCsqUVRygfmm1Jm/lIga0/Ws73b+nEc1NbLWjiur41fbynmSXBJymQW6FFBZ9cGzNUphzRFPUGeY1/Z3oSWmGxWXvCbAEj9cRyAMoG/5hkoMujzGIpz5b5IjF9K4st2mQMSpcUo/2OzaWWG2EPDJzX5x4kDAi1Wjrf7AQQQeD5/+6HTrK3DdzBU7Q8XZJClehPifxJHnJtkx7xCDIeLzR0gbbrzKC+H7o3iHYk+RdoZepMcehYCbzNe5oOMAUV0TB4FtOEJ6BgVgxfNcRbMBFpxIUQbsKAJuB37fmFu40X8UUDI2GUqlCoTPZVT29QSlu4p9tlZ14VrwUIqEXdcgnrrU71CweLA4gMpvdvWeDQrHOn+I5yPjk4mqrz5nbLPScKpiYkKufmp6lsJubcKqLentILEOdnetSVGETPKKr0Aviyg0XT2ifGgMSkyITw5CuxhyD8PO2ugON7LPzfwQf3iseDef+UwJZ7RiClURznDr+TMMFwzWkhNsCyMsNWFAqpRreg5mcFFr7zL21eKUJSYX+W/7ouCoYVtQxhUWwi8QpaS9k6Nw29xdq6qbfWr1RZJ9hMutR+bjjXeKWS41l
 /gYKr2NH
 r3smlHX3cjQHHd7SuHHgiG4mMMIHY5KbMbCrjgT7ZNNCROyrrnoQT3cQUl7omFTtEUd/wXdzpWEu75jyPDPJG7b55+vezRP+D6M2hXCgiDjIAG1G8juxUneV5shLwzdgX0bYOkww6c20u73BB8++ol5WnF20kpG+DKFwEmAhTD5qNmdEosqm0O8u03OPedVfecuvWv1aZjhq6StsueSti+JUetDsomKyCpSsUu8c6MLHUKC7FIFoVCo3rcDwp92TSLmdgqez7AFCsfKdwSCzZpQVfJk6oDz9S8Mj0FLJvYh3pN6CVS0l8RrTA3aDC8KLCAHK6Y2alGAG2F9ObEMQiLFx16T4K8a8RsgoslDwuRjhNbkfOuKbSQCcBsuK+6cECBFnTtpaNosWrmIEfmBPooFQj011wHL7mlQCfgvHZARRRbsnMbZCt78KV1/KUO5OuNhhOxIoIfTaQWFz78SYvfffzpFOKqfVBM5dcjNclFKRDGCh46owaBDQTrZErKoFsaBZAHKd553fBxDxay7yU10lQ5aPg73rlOJy19D0P2zpdwlFjNvpKiGN7S2svi21E+GmJGjGeOeoJGxMhpQ7hDO5A9e9eXGGTR+XvIE7ndLa6xIA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 14 potential
issues to consider:
- [Critical] zram: partial read in zram_read_partial_from_zspool()
  ignores bv_len/offset
- [Critical] zram: OOB access and data loss in zram_write_page() using
  folio_size()
- [Critical] zram: bio-wide routing in want_multi_pages_comp() and
  test_multi_pages_comp()
- [Critical] zram: multi_pages_bvec_iter_bvec() and partial read corrupt
  multi-page I/O
- [High] zram: unlocked flag updates and leaked handles in
  zram_write_page()
- [High] zram: sibling race and premature flag clear in
  zram_slot_free_notify()
- [High] zram: unlocked RMW in zram_bvec_write_multi_pages_partial()
  loses writes
- [High] zram: use-after-free in zram_bvec_write_multi_pages_partial()
  on ZRAM_WB
- [High] zram: out-of-bounds access in place_pp_slot() and
  post-processing overflow
- [High] mm: zsmalloc: VM_BUG_ON in obj_write() and bad offset in
  zs_rebind_handle()
- [Medium] zram: out-of-bounds zram->table access when disksize is not
  multi-page aligned
- [Medium] zram: ZRAM_FLAG_SHIFT overflows 32-bit attr.flags on 16K/64K
  page configs
- [Medium] zram: inverted lock order between excl_lock and buf_lock in
  zcomp
- [Low] zram: misplaced zsmalloc build fix, missing commit data, and
  stat format
--

commit d614cb6134b7b12651ec475514fd15b492598ab0
Author: Tangquan Zheng <zhengtangquan@oppo.com>

zram: support compression at the granularity of multi-pages

This commit adds CONFIG_ZRAM_MULTI_PAGES to compress and store large
folios in ZCOMP_MULTI_PAGES_SIZE chunks instead of individual PAGE_SIZE
pages.

> diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
> index ad8c7dc739223..8fa2a44adaa30 100644
> --- a/drivers/block/zram/zcomp.c
> +++ b/drivers/block/zram/zcomp.c

[ ... ]

> @@ -101,11 +105,23 @@ static int zcomp_dstrm_init(struct zcomp *comp, str=
uct zcomp_dstrm *zstrm)
>  		}
>  	}
> =20
> -	zstrm->local_copy =3D vzalloc(PAGE_SIZE);
> +	zstrm->local_copy =3D vzalloc(ZCOMP_MULTI_PAGES_SIZE);
>  	if (!zstrm->local_copy) {
>  		zcomp_dstrm_free(comp, zstrm);
>  		return -ENOMEM;
>  	}
> +#ifdef CONFIG_ZRAM_MULTI_PAGES
> +	/*
> +	 * Preallocate a decompression buffer for partial multi-page reads to
> +	 * avoid memory allocation in the swapin path.
> +	 */
> +	zstrm->decomp_buf =3D vzalloc(ZCOMP_MULTI_PAGES_SIZE);
> +	if (!zstrm->decomp_buf) {
> +		zcomp_dstrm_free(comp, zstrm);
> +		return -ENOMEM;
> +	}
> +	mutex_init(&zstrm->buf_lock);
> +#endif
>  	return 0;
>  }

[Severity: Medium]
Can zstrm->excl_lock and zstrm->buf_lock be acquired in opposite orders?

In zram_read_partial_from_zspool(), an exclusive decompression backend
(ZCOMP_DSTRM_EXCLUSIVE) takes zstrm->excl_lock inside zcomp_dstrm_get()
and then locks zstrm->buf_lock.  A shared decompression backend
(ZCOMP_DSTRM_SHARED) locks zstrm->buf_lock first and then calls
zcomp_decompress(), which locks zstrm->excl_lock when a two-page object
falls back to zstrm->local_copy:

CPU0                              CPU1
----                              ----
lock(&zstrm->excl_lock)
                                  lock(&zstrm->buf_lock)
lock(&zstrm->buf_lock)
                                  lock(&zstrm->excl_lock)

 *** DEADLOCK ***

CPU0: zram_read_partial_from_zspool() -> zcomp_dstrm_get()
CPU1: zram_read_partial_from_zspool() -> zcomp_decompress()

Because all zstrm->excl_lock and zstrm->buf_lock instances share static
lockdep classes across devices and CONFIG_ZRAM_MULTI_COMP priorities,
this triggers a lockdep circular locking splat.

Also, zcomp_dstrm_init() runs from the CPUHP_ZCOMP_PREPARE hotplug
callback every time a CPU comes online, so mutex_init(&zstrm->buf_lock)
re-initializes an already initialized mutex instead of initializing it
once per possible CPU in zcomp_init().

> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 8b7d6926da266..e258289679015 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c

[ ... ]

> @@ -484,7 +486,7 @@ static ssize_t idle_store(struct device *dev, struct =
device_attribute *attr,
>  static int read_from_zspool_raw(struct zram *zram, struct page *page,
>  				unsigned long index);
>  static int read_from_zspool(struct zram *zram, struct page *page,
> -			    unsigned long index);
> +			    unsigned long index, unsigned long page_size);
> =20
>  struct zram_wb_ctl {
>  	/* idle list is accessed only by the writeback task, no concurency */
> @@ -1092,7 +1094,7 @@ static int zram_writeback_slots(struct zram *zram,
>  		if (zram->compressed_wb)
>  			err =3D read_from_zspool_raw(zram, req->page, index);
>  		else
> -			err =3D read_from_zspool(zram, req->page, index);
> +			err =3D read_from_zspool(zram, req->page, index, PAGE_SIZE);
>  		if (err)
>  			goto next;
>  		slot_unlock(zram, index);

[Severity: High]
Can post-processing a multi-page slot overflow ctl->pp_buckets[] and
req->page?

Neither scan_slots_for_writeback() nor scan_slots_for_recompress() skips
ZRAM_COMP_MULTI_PAGES slots, where get_slot_size() can be up to
ZCOMP_MULTI_PAGES_SIZE.  In place_pp_slot(), NUM_PP_BUCKETS is sized for
PAGE_SIZE:

drivers/block/zram/zram_drv.c:place_pp_slot() {
	...
	bid =3D get_slot_size(zram, pps->index) / PP_BUCKET_SIZE_RANGE;
	list_add(&pps->entry, &ctl->pp_buckets[bid]);
}

When a multi-page slot's compressed size exceeds PAGE_SIZE, bid exceeds
NUM_PP_BUCKETS and corrupts memory past struct zram_pp_ctl.  In
zram_writeback_slots(), req->page is a single PAGE_SIZE page, so
read_from_zspool_raw() also overflows req->page and wraps PAGE_SIZE - size
in memzero_page(), while uncompressed writeback and recompress_slot() pass
PAGE_SIZE for a multi-page object.

[ ... ]

> @@ -2298,12 +2365,27 @@ static int zram_write_page(struct zram *zram, str=
uct page *page,
>  	struct zcomp_cstrm *zstrm;
>  	unsigned long element;
>  	bool same_filled;
> +	unsigned long page_size =3D PAGE_SIZE;
> +	int huge_class_idx =3D ZSMALLOC_TYPE_BASEPAGE;
> +	int nr_pages =3D 1;
> +
> +#ifdef CONFIG_ZRAM_MULTI_PAGES
> +	/*
> +	 * Multi-page compression packs ZCOMP_MULTI_PAGES_NR pages into one
> +	 * compressed object.
> +	 */
> +	if (folio_size(page_folio(page)) >=3D ZCOMP_MULTI_PAGES_SIZE) {
> +		page_size =3D ZCOMP_MULTI_PAGES_SIZE;
> +		huge_class_idx =3D ZSMALLOC_TYPE_MULTI_PAGES;
> +		nr_pages =3D ZCOMP_MULTI_PAGES_NR;
> +	}
> +#endif
> =20
>  	mem =3D kmap_local_page(page);
> -	same_filled =3D page_same_filled(mem, &element);
> +	same_filled =3D page_same_filled(mem, &element, page_size);
>  	kunmap_local(mem);
>  	if (same_filled)
> -		return write_same_filled_page(zram, element, index);
> +		return write_same_filled_page(zram, element, index, nr_pages);

[Severity: Critical]
Does sizing the write from folio_size(page_folio(page)) instead of the I/O
length cause out-of-bounds accesses and dropped pages?

When a single-page bio (bv_len =3D=3D PAGE_SIZE) writes a subpage belonging=
 to
a large folio, zram_bio_write() takes the single-page loop and calls
zram_write_page(), where folio_size(page_folio(page)) >=3D
ZCOMP_MULTI_PAGES_SIZE is still true.  If page is near the end of the
folio, reading ZCOMP_MULTI_PAGES_SIZE bytes starting at page reads past
the end of the folio, and setting ZRAM_COMP_MULTI_PAGES across index ..
index + nr_pages - 1 on an unaligned index corrupts adjacent slots or
writes past the end of zram->table.

Conversely, if bio_add_page() merges ZCOMP_MULTI_PAGES_NR physically
contiguous order-0 pages into one bvec of length ZCOMP_MULTI_PAGES_SIZE,
zram_bio_write_multi_pages() advances the iterator by
ZCOMP_MULTI_PAGES_SIZE while zram_write_page() sees folio_size() =3D=3D
PAGE_SIZE and stores only the first page.

> @@ -2320,9 +2402,10 @@ static int zram_write_page(struct zram *zram, stru=
ct page *page,
>  		return ret;
>  	}
> =20
> -	if (comp_len >=3D huge_class_size) {
> +	if (comp_len >=3D huge_class_size[huge_class_idx]) {
>  		zcomp_cstrm_put(zstrm);
> -		return write_incompressible_page(zram, page, index);
> +		return write_incompressible_page(zram, page, index, page_size,
> +						 nr_pages);
>  	}
> =20
>  	slot_lock(zram, index);
> @@ -2341,10 +2424,18 @@ static int zram_write_page(struct zram *zram, str=
uct page *page,
> =20
>  	set_slot_size(zram, index, comp_len);
>  	mark_slot_accessed(zram, index);
> +#ifdef CONFIG_ZRAM_MULTI_PAGES
> +	if (nr_pages > 1) {
> +		int i;
> +
> +		for (i =3D 0; i < nr_pages; i++)
> +			set_slot_flag(zram, index + i, ZRAM_COMP_MULTI_PAGES);
> +	}
> +#endif
>  	slot_unlock(zram, index);

[Severity: High]
Does setting ZRAM_COMP_MULTI_PAGES on index + 1 .. index + nr_pages - 1
without locking or freeing those tail slots corrupt the slot bit-lock and
leak existing objects?

zram_write_page(), write_same_filled_page(), and
write_incompressible_page() only lock and call slot_free() on the head
slot index:

1. Because table[index + i].attr.flags aliases table[index + i].__lock,
   the unlocked non-atomic |=3D in set_slot_flag(zram, index + i, ...) races
   with concurrent slot_lock() / slot_unlock() on tail slots and can
   corrupt ZRAM_ENTRY_LOCK_BIT, hanging waiters in wait_on_bit_lock().
2. Any single-page zsmalloc handles already stored in the tail slots are
   never freed before ZRAM_COMP_MULTI_PAGES is set on them, leaking those
   objects.
3. During a partial write after some sub-slots were already freed by
   zram_slot_free_notify(), re-setting ZRAM_COMP_MULTI_PAGES on all
   nr_pages sub-slots marks already-freed swap slots that will never
   receive another free notification, so the multi-page object can never
   be freed when the remaining active sub-slots are released.
4. If the head sub-slot was freed first via zram_slot_free_notify() (which
   clears ZRAM_COMP_MULTI_PAGES on index), a later slot_free(zram, index)
   sees ZRAM_COMP_MULTI_PAGES clear on index and subtracts 1 instead of
   ZCOMP_MULTI_PAGES_NR from pages_stored and same_pages, while
   slot_free_npages() on discard or zs_store() failure leaves
   ZRAM_COMP_MULTI_PAGES set on the tail slots.
5. On a zsmalloc multi-page size class, zs_store() -> obj_write() calls
   memcpy_to_page() with off + sizes[0] =3D=3D ZSMALLOC_MULTI_PAGES_SIZE wh=
en
   an object spans two zpdescs, which triggers
   VM_BUG_ON(offset + len > PAGE_SIZE) in memcpy_to_page(); similarly,
   zs_rebind_handle() uses offset_in_page() instead of masking with
   page_size - 1, corrupting object headers at offsets >=3D PAGE_SIZE.

[ ... ]

> +#ifdef CONFIG_ZRAM_MULTI_PAGES
> +
> +static inline unsigned long zram_multi_pages_head_index(unsigned long in=
dex)
> +{
> +	return index & ~((unsigned long)ZCOMP_MULTI_PAGES_NR - 1);
> +}
> +
> +static inline int __test_multi_pages_comp(struct zram *zram,
> +					 unsigned long index)
> +{
> +	unsigned long head =3D zram_multi_pages_head_index(index);
> +	int i, count =3D 0;
> +
> +	for (i =3D 0; i < ZCOMP_MULTI_PAGES_NR; i++) {
> +		if (test_slot_flag(zram, head + i, ZRAM_COMP_MULTI_PAGES))
> +			count++;
> +	}
> +
> +	return count;
> +}

[Severity: Medium]
Can __test_multi_pages_comp() access past the end of zram->table when
disksize is not a multiple of ZCOMP_MULTI_PAGES_SIZE?

disksize_store() only aligns disksize with PAGE_ALIGN(disksize).  When
num_pages is not a multiple of ZCOMP_MULTI_PAGES_NR, an access to the
final slots has head + i >=3D num_pages, so __test_multi_pages_comp() and
the set_slot_flag() loops in the multi-page write path read and write past
the end of zram->table.

> +static inline bool want_multi_pages_comp(struct zram *zram, struct bio *=
bio)
> +{
> +	unsigned long index =3D bio->bi_iter.bi_sector >> SECTORS_PER_PAGE_SHIF=
T;
> +
> +	if (bio->bi_io_vec->bv_len >=3D ZCOMP_MULTI_PAGES_SIZE)
> +		return true;
> +
> +	slot_lock(zram, index);
> +	if (__test_multi_pages_comp(zram, index)) {
> +		slot_unlock(zram, index);
> +		return true;
> +	}
> +	slot_unlock(zram, index);
> +
> +	return false;
> +}
> +
> +static inline bool test_multi_pages_comp(struct zram *zram, struct bio *=
bio)
> +{
> +	unsigned long index =3D bio->bi_iter.bi_sector >> SECTORS_PER_PAGE_SHIF=
T;
> +
> +	return !!__test_multi_pages_comp(zram, index);
> +}

[Severity: Critical]
Can routing the entire bio through the multi-page or single-page path
based only on the first sector crash or corrupt data?

want_multi_pages_comp() and test_multi_pages_comp() inspect only the bio's
initial sector and bio->bi_io_vec->bv_len before iterating the bio.  If an
unaligned write bio with bv_len >=3D ZCOMP_MULTI_PAGES_SIZE or a multi-bvec
bio enters the multi-page path and lands on a head slot that holds a
single-page (PAGE_SIZE) object, zram_bvec_write_multi_pages_partial() or
zram_bvec_read_multi_pages() calls zram_read_page_size(...,
ZCOMP_MULTI_PAGES_SIZE) on that single-page slot:

- If the single-page head slot has ZRAM_HUGE set (a 1-page ZsHugePage),
  read_incompressible_page() calls zs_obj_read_sg_begin() with
  ZCOMP_MULTI_PAGES_SIZE, which takes the two-page branch, gets NULL from
  get_next_zpdesc(zpdesc), and dereferences NULL in sg_copy_to_buffer().
- If the single-page head slot holds a compressed PAGE_SIZE object during
  zram_bvec_write_multi_pages_partial(), zcomp_decompress() only fills the
  first PAGE_SIZE bytes of the unzeroed order-ZCOMP_MULTI_PAGES_ORDER page,
  and zram_write_page() compresses and stores the remaining uninitialized
  kernel memory.

Conversely, if a read bio starts on a single-page slot and crosses into a
multi-page slot group, zram_bio_read() stays in the single-page loop,
failing decompression on the head slot and reading the unallocated tail
slots as zero-filled pages.

> +static inline bool is_multi_pages_partial_io(struct bio_vec *bvec)
> +{
> +	return bvec->bv_len !=3D ZCOMP_MULTI_PAGES_SIZE;
> +}
> +
> +static int zram_read_partial_from_zspool(struct zram *zram, struct page =
*page,
> +					unsigned long index, int offset)
> +{
> +	struct zs_handle *handle =3D &zram->table[index].handle;
> +	struct zcomp_dstrm *zstrm;
> +	struct scatterlist sg[2];
> +	enum zcomp_dstrm_mode mode;
> +	unsigned int size;
> +	void *src, *dst;
> +	u32 prio;
> +	int ret;
> +	unsigned long page_size =3D ZCOMP_MULTI_PAGES_SIZE;
> +
> +	if (test_slot_flag(zram, index, ZRAM_SAME) ||
> +	    !zs_handle_is_allocated(handle)) {
> +		void *mem;
> +
> +		mem =3D kmap_local_page(page);
> +		zram_fill_page(mem, PAGE_SIZE, zram->table[index].element);
> +		kunmap_local(mem);
> +		return 0;
> +	}
> +
> +	size =3D get_slot_size(zram, index);
> +	zs_obj_read_sg_begin(zram->mem_pool, handle, sg, size);
> +
> +	if (size =3D=3D page_size) {
> +		src =3D kmap_local_page(sg_page(sg));
> +		dst =3D kmap_local_page(page);
> +		memcpy(dst, src + offset, PAGE_SIZE);
> +		kunmap_local(dst);
> +		kunmap_local(src);
> +		ret =3D 0;
> +	} else {
> +		prio =3D get_slot_comp_priority(zram, index);
> +		mode =3D ZCOMP_DSTRM_EXCLUSIVE;
> +		if (zcomp_shared_decomp(zram->comps[prio]))
> +			mode =3D ZCOMP_DSTRM_SHARED;
> +
> +		zstrm =3D zcomp_dstrm_get(zram->comps[prio], mode);
> +		mutex_lock(&zstrm->buf_lock);
> +		ret =3D zcomp_decompress(zram->comps[prio], zstrm, sg, size,
> +				       zstrm->decomp_buf, page_size);
> +		if (!ret) {
> +			dst =3D kmap_local_page(page);
> +			memcpy(dst, zstrm->decomp_buf + offset, PAGE_SIZE);
> +			kunmap_local(dst);
> +		}
> +		mutex_unlock(&zstrm->buf_lock);
> +		zcomp_dstrm_put(zram->comps[prio], zstrm, mode);
> +	}
> +	zs_obj_read_sg_end(zram->mem_pool, handle);
> +
> +	return ret;
> +}

[Severity: Critical]
Does zram_read_partial_from_zspool() ignore bvec->bv_len and
bvec->bv_offset?

zram_bvec_read_multi_pages_partial() passes only bvec->bv_page and the
slot offset to zram_read_partial_from_zspool(), and all three branches
above always write PAGE_SIZE bytes to offset 0 of page.  When a partial
multi-page read has bv.bv_len > PAGE_SIZE (for example, 2 or 3 pages) or a
non-zero bvec->bv_offset, zram_bio_read_multi_pages() still advances the
bio iterator by bv.bv_len, writing to the wrong offset of bv_page or
leaving the remaining pages of the read uninitialized.

[ ... ]

> +static int zram_bvec_write_multi_pages_partial(struct zram *zram,
> +					       struct bio_vec *bvec,
> +					       unsigned long index, int offset,
> +					       struct bio *bio)
> +{
> +	struct page *page;
> +	void *src, *dst;
> +	int ret;
> +
> +	page =3D alloc_pages(GFP_NOIO | __GFP_COMP, ZCOMP_MULTI_PAGES_ORDER);
> +	if (!page)
> +		return -ENOMEM;
> +
> +	ret =3D zram_read_page_size(zram, page, index, bio,
> +				  ZCOMP_MULTI_PAGES_SIZE);
> +	if (!ret) {
> +		src =3D kmap_local_page(bvec->bv_page);
> +		dst =3D kmap_local_page(page);
> +		memcpy(dst + offset, src + bvec->bv_offset, bvec->bv_len);
> +		kunmap_local(dst);
> +		kunmap_local(src);
> +
> +		atomic64_inc(&zram->stats.zram_bio_write_multi_pages_partial_count);
> +		ret =3D zram_write_page(zram, page, index);
> +	}
> +
> +	__free_pages(page, ZCOMP_MULTI_PAGES_ORDER);
> +	return ret;
> +}

[Severity: High]
Can two concurrent partial writes to different sub-slots in the same
multi-page group overwrite each other?

zram_read_page_size() unlocks slot_lock(zram, index) after reading the
multi-page into the temporary page, and zram_write_page() only re-acquires
slot_lock(zram, index) after compressing the updated buffer.  If two CPUs
concurrently perform partial writes to different offsets of the same head
index, both read the old multi-page before either writes back, so the
second writer overwrites the first writer's sub-page with stale data.

[Severity: High]
Does passing bio as parent to zram_read_page_size() cause a use-after-free
of page when ZRAM_WB is set?

When test_slot_flag(zram, index, ZRAM_WB) is true, zram_read_page_size()
calls read_from_bdev(zram, page, index, blk_idx, parent) with a non-NULL
parent bio:

drivers/block/zram/zram_drv.c:read_from_bdev() {
	atomic64_inc(&zram->stats.bd_reads);
	if (!parent) {
		if (WARN_ON_ONCE(!IS_ENABLED(ZRAM_PARTIAL_IO)))
			return -EIO;
		return read_from_bdev_sync(zram, page, index, blk_idx);
	}
	return read_from_bdev_async(zram, page, index, blk_idx, parent);
}

read_from_bdev_async() submits an asynchronous child bio referencing page
(inheriting REQ_OP_WRITE from the write bio) and returns 0 immediately,
after which zram_bvec_write_multi_pages_partial() frees page via
__free_pages() while the backing-device I/O and completion work are still
using it.

[ ... ]

> @@ -2814,7 +3189,34 @@ static void zram_slot_free_notify(struct block_dev=
ice *bdev,
>  		return;
>  	}
> =20
> +#ifdef CONFIG_ZRAM_MULTI_PAGES
> +	{
> +		int comp_count =3D __test_multi_pages_comp(zram, index);
> +
> +		if (comp_count > 1) {
> +			clear_slot_flag(zram, index, ZRAM_COMP_MULTI_PAGES);
> +			slot_unlock(zram, index);
> +			return;
> +		}
> +
> +		if (comp_count =3D=3D 1) {
> +			clear_slot_flag(zram, index, ZRAM_COMP_MULTI_PAGES);
> +			slot_unlock(zram, index);
> +			index =3D zram_multi_pages_head_index(index);
> +			nr_pages_to_free =3D ZCOMP_MULTI_PAGES_NR;
> +			if (!slot_trylock(zram, index)) {
> +				atomic64_inc(&zram->stats.multi_pages_miss_free);
> +				return;
> +			}
> +		}
> +	}
> +#endif

[Severity: High]
Can concurrent zram_slot_free_notify() calls on sibling sub-slots leak the
multi-page object?

__test_multi_pages_comp() counts ZRAM_COMP_MULTI_PAGES across the group
while only holding slot_trylock(zram, index) on the current sub-slot:

CPU0                                  CPU1
zram_slot_free_notify(head + 1)       zram_slot_free_notify(head + 2)
  slot_trylock(zram, head + 1)          slot_trylock(zram, head + 2)
  __test_multi_pages_comp() -> 2        __test_multi_pages_comp() -> 2
  clear_slot_flag(head + 1, ...)        clear_slot_flag(head + 2, ...)
  slot_unlock(zram, head + 1)           slot_unlock(zram, head + 2)
  return;                               return;  <-- head is never freed

In addition, when comp_count =3D=3D 1, clearing ZRAM_COMP_MULTI_PAGES and
unlocking index before slot_trylock(zram, head) means that if
slot_trylock(zram, head) fails, the last ZRAM_COMP_MULTI_PAGES flag has
already been cleared, and another CPU can also reallocate and write to
head in the unlocked window before slot_trylock(zram, head) runs.
__test_multi_pages_comp() also does not check whether index itself has
ZRAM_COMP_MULTI_PAGES set before treating it as part of a multi-page
group.

> diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
> index d64c99b74214b..1e3ebfec972ec 100644
> --- a/drivers/block/zram/zram_drv.h
> +++ b/drivers/block/zram/zram_drv.h

[ ... ]

> @@ -37,7 +42,12 @@
>   *
>   * We use BUILD_BUG_ON() to make sure that zram pageflags don't overflow.
>   */
> +#ifdef CONFIG_ZRAM_MULTI_PAGES
> +#define ZRAM_FLAG_SHIFT (PAGE_SHIFT + CONFIG_ZSMALLOC_MULTI_PAGES_ORDER =
+ 1)
> +#else
>  #define ZRAM_FLAG_SHIFT (PAGE_SHIFT + 1)
> +#endif

[Severity: Medium]
Does ZRAM_FLAG_SHIFT overflow the 32-bit attr.flags field when
PAGE_SHIFT + CONFIG_ZSMALLOC_MULTI_PAGES_ORDER > 21?

CONFIG_ZSMALLOC_MULTI_PAGES_ORDER allows values up to 9, and enum
zram_pageflags defines 10 flag bits above ZRAM_FLAG_SHIFT.  On 16K or 64K
page configurations with larger orders (for example, PAGE_SHIFT =3D=3D 16 w=
ith
order >=3D 6), __NR_ZRAM_PAGEFLAGS exceeds 32 and triggers
BUILD_BUG_ON(__NR_ZRAM_PAGEFLAGS > sizeof(zram_te.attr.flags) * 8) in
zram_init().

[ ... ]

> @@ -167,4 +190,24 @@ struct zram {
>  	struct dentry *debugfs_dir;
>  #endif
>  };
> +
> +#ifdef CONFIG_ZRAM_MULTI_PAGES
> +#define multi_pages_bvec_iter_offset(bvec, iter)				\
> +	(mp_bvec_iter_offset((bvec), (iter)) % ZCOMP_MULTI_PAGES_SIZE)
> +
> +#define multi_pages_bvec_iter_len(bvec, iter)				\
> +	min_t(unsigned int, mp_bvec_iter_len((bvec), (iter)),		\
> +	      ZCOMP_MULTI_PAGES_SIZE -					\
> +	      multi_pages_bvec_iter_offset((bvec), (iter)))
> +
> +#define multi_pages_bvec_iter_bvec(bvec, iter)				\
> +((struct bio_vec) {							\
> +	.bv_page	=3D mp_bvec_iter_page((bvec), (iter)),		\
> +	.bv_len		=3D multi_pages_bvec_iter_len((bvec), (iter)),	\
> +	.bv_offset	=3D multi_pages_bvec_iter_offset((bvec), (iter)),	\
> +})
> +
> +#define multi_pages_bio_iter_iovec(bio, iter)				\
> +	multi_pages_bvec_iter_bvec((bio)->bi_io_vec, (iter))
> +#endif
>  #endif

[Severity: Critical]
Does using mp_bvec_iter_page() in multi_pages_bvec_iter_bvec() keep
.bv_page stuck at the first page of a large folio across iterations?

Unlike bvec_iter_page(), mp_bvec_iter_page(bvec, iter) always returns
bvec[iter.bi_idx].bv_page without adding mp_bvec_iter_page_idx(bvec,
iter), while multi_pages_bvec_iter_offset() wraps .bv_offset modulo
ZCOMP_MULTI_PAGES_SIZE.  When a folio larger than ZCOMP_MULTI_PAGES_SIZE
(such as a 64KiB or 128KiB folio in a single multi-page bvec) is read or
written, every iteration of zram_bio_write_multi_pages() and
zram_bio_read_multi_pages() accesses subpage 0 of the folio, repeatedly
compressing or overwriting the first ZCOMP_MULTI_PAGES_SIZE bytes and
leaving the rest of the folio unread or unwritten.

> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 2d83fcc8610da..81d908d6d5a8d 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -1697,7 +1697,8 @@ static struct zs_handle *find_alloced_obj(struct si=
ze_class *class,
>  	offset +=3D class->size * index;
> =20
>  	while (offset < page_size) {
> -		if (obj_allocated(zpdesc, addr + offset, &handle))
> +		handle =3D obj_allocated(zpdesc, addr + offset);
> +		if (handle)
>  			break;
> =20
>  		offset +=3D class->size;

[Severity: Low]
Should this find_alloced_obj() change be folded into the preceding commit
"mm: zsmalloc: support objects compressed based on multiple pages" so the
series stays bisectable?

Also, the commit message ends with "The following data illustrates the
time and compressed data for typical anonymous pages gathered from Android
phones." without including the data table, and multi_pages_debug_stat_show()
is missing a colon or space before "%8llu" on the failed and partial count
lines.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115024455.1465=
726-1-zhaonanzhe@xiaomi.com?part=3D2

