Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99A17606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 02:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AgeHjZkb
Received: by kanga.kvack.org (Postfix)
	id A5DF56B00EF; Sun, 15 Nov 2026 21:46:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0CAF6B05B0; Sun, 15 Nov 2026 21:46:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FC896B05B1; Sun, 15 Nov 2026 21:46:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 60D4B6B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 21:46:52 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D2180C057C
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:46:51 +0000 (UTC)
X-FDA: 85439444622.24.BB8577D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3784E140002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:46:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AgeHjZkb;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794797210;
	b=38pODA3dZV+fsGoMGisNkGkYOaX9rruub9HPje2yiziRuSueB57w09hAC++euW+eM23aYn
	/Q18RjIxiQw4kP0YDqxQGl6tsBMK6uher8SR+l3TN343b3A5xG3MK7I6EnPXfqLZ5mEbA7
	nymt+h6CWgdqOBXq0QoKqK0g0pfPtGE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AgeHjZkb;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794797210;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BaO4L6YbRbuHC29tPnzuQPmH9WuJLP6Q1ycYGqc1/Ao=;
	b=OXD5LYIeMU6uIGtVZ35krtXLE/3ov93XnKx0C5QRZi+57QgeOfIEhXqqwXEqevLjIvF1MO
	jivqQCPqX3lbO46zjESTqf6VqUdc8Pl7itutgemxhZ76pEKyh30keCN01Fe3RioySGxAxH
	HIyer65m+1Yw5M8hFzjmK2iK9b6Ho5E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 63343624AC;
	Mon, 16 Nov 2026 02:46:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A3A1F000C4;
	Mon, 16 Nov 2026 02:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794797209;
	bh=BaO4L6YbRbuHC29tPnzuQPmH9WuJLP6Q1ycYGqc1/Ao=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AgeHjZkb8XCX4pN841klxkQdryIgLXYFJwQlU6Xq8A1o00s4RG+2M7rNvuTLjsmlo
	 PKHisHPYGSyX3rwPlC7qk1y0ZxhKoC9Np/NKMaEph/Bt+k53E0zsB/ZQl85ILROmH3
	 l8IhAX//mclDQXsSg0inpLahREKGL/rr1PBumAdbuKcp7bQdRIYT/OxeX3aA6z7ZHl
	 H6MrPVZt6PC/k6gxXHF3JHsT4IS0FgxTdBgVDcBSC2R2RbcLh6+R/wkSQK0N3kYcNZ
	 DKoXIFNUspXc1QpkdLVWbz5CYjBxNKPhj7pgDbVGU7FteC5qbmQ435ibjo3tY2i+F5
	 qatoSsA/vrd+g==
Message-ID: <sashiko-outbox-216088@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v4 1/4] mm: zsmalloc: support objects compressed
 based on multiple pages
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
In-Reply-To: <20261115024455.1465726-2-zhaonanzhe@xiaomi.com>
References: <20261115024455.1465726-1-zhaonanzhe@xiaomi.com>
 <20261115024455.1465726-2-zhaonanzhe@xiaomi.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 02:46:47 +0000
X-Stat-Signature: e5fgtp7apefgohb56iwozmiytn1yahy9
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3784E140002
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794797210-89808
X-HE-Meta: U2FsdGVkX1/tbekcQIY4ADw/O6lTSuPV5VdKHMGvKPuShVxVFDyJuMVWMeSjCxBYKBDOKKzvdGk1eNVeCyvfd7+2l31D2yzt93BgD7NkpdHqxRDZe4f0x/4BLje8cm3SGJOh8Z0+CAkDgD68XGS6rcUfhmoCkJB1aTLtF9GwUgNYtzAznpwHPOyarOm6zWRZGIoN0xxtUxESLyWZ/ISSZ4uTGCAX++UZoIvRvOOyrIu40pEte2OJX5OVbcfRIDoS2dGHC+uyL8/0ImkIKb7XPMlXVZZLETF9pgp76MQ309bdxf1iJ99ktPvxJ+du5bakcxz3EDWLaRezFIMhCAmGx3h7yznbJ3rqPciaP3UX1h0w3DE7TAgvPIDF23U80/nxQDdtSOmbRfsoizSYp0IX0b2RjpINOH80D+R8z22RFtddvsj5XzaOP8PC5Vr0hAjD26x0xop7uMjn3Bq4KJuuFMlQSzO7kPFSqJA4xT4CNF5fE6Vwo5SHdiftDjPcL8L30PFitmIo4qR2IyZ+lzemNK3jTBbi5zZtaTOgH9j8vT9wzLimE2ihk1qntlDAGVZrSFLAOnhjqAeP7AsJWvsmjP61/anoomO+gPztpusFzotMQ48mpknFsmHFSlq5O5drY0zXEimUcwokYfELHOzJ1TWKcqv5PU69BYl3RhN4bdwzPJiULCLiD7i9NRuLxg/ZeAUAKH/P7cLb5k3zK1YeQxtsQB7+WUo381eqGsWVNbceCccSHpZQxqG6GUe/mrNYlCT2gbH+klZVEhtfbdfjt7G/8SMrFXmTLmWkaOQrqQkpf933jK86V+RVb3OnTtzIJ5hCpcNTc54OGqJmwQcNRIS+UCIxqPDROf8T9ZPG9iPDE3pfnlivZm/hbtGkRsv6oaGhIUDRF2UExshrRTBhZdwCAd08sVHPZUW2i3OQUdWiJFqVsCapoFkOvYbkC5Be80tk/F9GpDusWSD59W8
 cYZhW8RA
 dHQh5YX9ioYifZBIe+hMNZBrHf8hssw5u2R2w6WcSt/YxjfEcTyQ/fmd7johtWwoTHOFNPXgudzMES/UkjxCPAk5btxFPo2O4NazIT162iKCrW0p1eyYQpISo4meXPKW4hEXN5ElIKh2sqQrwxX6FFRRREVqqVzfYqwKcWLpT5Y95OsDpohwMBYK34HAhqD60qIDCL47giY6u2IkswYVTVi/7XPos4HSiXYeOKgQtj5lBUi+9qY4lavjWK+Z3Q8c65Nde3WkMaf5KYUWAccUdAwSxGrdkJodmXqVTVBCvJy/Hg4xUGQ7sEyxXE2pglG+LxWX6DsrloqmQjwL1YK+986Q0YUd1otKPSpTWBIxuV1CZmznqbN69+bS9+snop23EbHp5JLX48DEGDgOLxS5A8l+Z3m3fxVY+K9SAhuLxLox84A4ky7OczMUYEnODwNBx/GBW9cLg9ZP3tHwaKk5ZY3/X9dC31PfUnVuJC0NlOfd23fJFw2KtPj8xvD5naC5b38YpbKHVLT3ludlTj+LXJGGPBKMiLYtEW+mfv6QExcDwNCk1AI13KbiOD2n+o6lcHCIrBoQf5Hf/22e/+pO+IZdzHck20xyDvFEtnRpvJzY5jNo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 8 potential
issues to consider:
- [High] mm: zsmalloc: build failure in find_alloced_obj() calling
  obj_allocated()
- [High] mm: zsmalloc: VM_BUG_ON in obj_write() calling single-page
  memcpy_to_page()
- [High] mm: zsmalloc: memory corruption in zs_rebind_handle() using
  offset_in_page()
- [High] mm: zsmalloc: unclamped basepage size class in zs_create_pool()
- [Medium] mm: zsmalloc: 24-bit offset overflow in
  set_first_obj_offset() on 64K pages
- [Medium] mm: zsmalloc: preemptible __zone_stat_add_folio() in zpdesc
  state helpers
- [Low] mm: zsmalloc: missing @type kernel-doc in zs_huge_class_size()
- [Low] mm: zsmalloc: missing space after order column in
  zs_stats_size_show()
--

commit de88105665ba4d7f0292945bc4a5ae1786f09efe
Author: Tangquan Zheng <zhengtangquan@oppo.com>

mm: zsmalloc: support objects compressed based on multiple pages

This commit adds multi-page object support to zsmalloc under
CONFIG_ZSMALLOC_MULTI_PAGES, introducing compound zpdesc allocations and si=
ze
classes above PAGE_SIZE up to ZSMALLOC_MULTI_PAGES_ORDER.

> diff --git a/mm/Kconfig b/mm/Kconfig
> index afff1b25b5438..b68720f6fb6bd 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -157,6 +158,24 @@ config ZSMALLOC_CHAIN_SIZE
> =20
>  	  For more information, see zsmalloc documentation.
> =20
> +config ZSMALLOC_MULTI_PAGES
> +	bool "support zsmalloc multiple pages"
> +	depends on ZSMALLOC && !HIGHMEM
> +	help
> +	  This option configures zsmalloc to support allocations larger than
> +	  PAGE_SIZE, enabling compression across multiple pages. The size of
> +	  these multiple pages is determined by the configured
> +	  ZSMALLOC_MULTI_PAGES_ORDER.
> +
> +config ZSMALLOC_MULTI_PAGES_ORDER
> +	int "zsmalloc multiple pages order"
> +	default 2
> +	range 1 9
> +	depends on ZSMALLOC_MULTI_PAGES
> +	help
> +	  This option is used to configure zsmalloc to support the compression
> +	  of multiple pages.
> +
>  endmenu

[Severity: Medium]
Can ZSMALLOC_MULTI_PAGES_ORDER=3D9 overflow the 24-bit first_obj_offset fie=
ld
on 64 KiB page systems?

With 64 KiB pages, order 9 gives a 32 MiB zpdesc, while
set_first_obj_offset() masks offsets with FIRST_OBJ_PAGE_TYPE_MASK (16 MiB)
and only checks BUILD_BUG_ON(PAGE_SIZE > SZ_16M):

mm/zsmalloc.c:set_first_obj_offset() {
	/* With 24 bits available, we can support offsets into 16 MiB pages. */
	BUILD_BUG_ON(PAGE_SIZE > SZ_16M);
	VM_WARN_ON_ONCE(!PageZsmalloc(zpdesc_page(zpdesc)));
	VM_WARN_ON_ONCE(offset & ~FIRST_OBJ_PAGE_TYPE_MASK);
	zpdesc->first_obj_offset &=3D ~FIRST_OBJ_PAGE_TYPE_MASK;
	zpdesc->first_obj_offset |=3D offset & FIRST_OBJ_PAGE_TYPE_MASK;
}

When init_zspage() sets an initial object offset at or above 16 MiB, the
offset wraps modulo 16 MiB, causing find_alloced_obj() during compaction to
scan from the wrong offset inside an object payload.

> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 4a6ec43f418b2..2d83fcc8610da 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c

[ ... ]

> @@ -295,27 +343,28 @@ struct zs_pool {
> =20
>  static inline void zpdesc_inc_zone_page_state(struct zpdesc *zpdesc)
>  {
> -	inc_zone_page_state(zpdesc_page(zpdesc), NR_ZSPAGES);
> +	__zone_stat_add_folio(zpdesc_folio(zpdesc), NR_ZSPAGES);
>  }
> =20
>  static inline void zpdesc_dec_zone_page_state(struct zpdesc *zpdesc)
>  {
> -	dec_zone_page_state(zpdesc_page(zpdesc), NR_ZSPAGES);
> +	__zone_stat_sub_folio(zpdesc_folio(zpdesc), NR_ZSPAGES);
>  }

[Severity: Medium]
Should these helpers use zone_stat_add_folio() and zone_stat_sub_folio()
instead of the double-underscore variants?

__zone_stat_add_folio() and __zone_stat_sub_folio() require preemption or
interrupts to be disabled, whereas alloc_zspage(), zs_free() ->
__free_zspage_lockless(), and zs_page_migrate() call these helpers in
preemptible context with no locks held, triggering preemption-disabled
assertions and racy per-CPU vmstat updates.

[ ... ]

> @@ -609,7 +667,8 @@ static int zs_stats_size_show(struct seq_file *s, voi=
d *v)
> =20
>  		spin_lock(&class->lock);
> =20
> -		seq_printf(s, " %5u %5u ", i, class->size);
> +		seq_printf(s, " %5u %5u %5u", i, class->size,
> +			   class_size_to_zs_order(class->size));

[Severity: Low]
Does the format string need a trailing space after the third "%5u" to match
the header and Total lines?  Without it, all subsequent columns in each
class row are shifted left by one character.

[ ... ]

> @@ -1189,16 +1257,17 @@ static void obj_write(struct size_class *class, s=
truct zspage *zspage,
>  		      unsigned long obj, const void *src, size_t size)
>  {
>  	struct zpdesc *zpdesc;
> +	unsigned long page_size =3D class_size_to_zs_size(class->size);
>  	unsigned long off;
>  	unsigned int obj_idx;
> =20
>  	obj_to_location(obj, &zpdesc, &obj_idx);
> -	off =3D offset_in_page(class->size * obj_idx);
> +	off =3D (class->size * obj_idx) & (page_size - 1);
> =20
>  	if (!ZsHugePage(zspage))
>  		off +=3D ZS_HANDLE_SIZE;
> =20
> -	if (off + size <=3D PAGE_SIZE) {
> +	if (off + size <=3D page_size) {
>  		/* this object is contained entirely within a page */
>  		void *dst =3D kmap_local_zpdesc(zpdesc);
> =20
> @@ -1208,7 +1277,7 @@ static void obj_write(struct size_class *class, str=
uct zspage *zspage,
>  		/* this object spans two pages */
>  		size_t sizes[2];
> =20
> -		sizes[0] =3D PAGE_SIZE - off;
> +		sizes[0] =3D page_size - off;
>  		sizes[1] =3D size - sizes[0];
> =20
>  		memcpy_to_page(zpdesc_page(zpdesc), off, src, sizes[0]);

[Severity: High]
Does calling memcpy_to_page() here trigger VM_BUG_ON(offset + len > PAGE_SI=
ZE)
when writing a multi-page object that spans two zpdescs?

For a multi-page class, page_size is larger than PAGE_SIZE, so off + sizes[=
0]
equals page_size and exceeds PAGE_SIZE in the first memcpy_to_page() call
(and sizes[1] can also exceed PAGE_SIZE in the second call).

> @@ -1230,9 +1299,9 @@ static void obj_write(struct size_class *class, str=
uct zspage *zspage,
>   *
>   * Return: the size (in bytes) of the first huge zsmalloc &size_class.
>   */
> -size_t zs_huge_class_size(struct zs_pool *pool)
> +size_t zs_huge_class_size(struct zs_pool *pool, enum zsmalloc_type type)
>  {
> -	return huge_class_size;
> +	return huge_class_size[type];
>  }
>  EXPORT_SYMBOL_GPL(zs_huge_class_size);

[Severity: Low]
The kernel-doc comment above zs_huge_class_size() is missing an @type entry
for the new parameter.

[ ... ]

> @@ -1365,13 +1437,15 @@ static void obj_free(int class_size, unsigned lon=
g obj)
>  	struct link_free *link;
>  	struct zspage *zspage;
>  	struct zpdesc *f_zpdesc;
> -	unsigned long f_offset;
> +	unsigned long f_offset, page_size, page_mask;
>  	unsigned int f_objidx;
>  	void *vaddr;
> =20
> =20
>  	obj_to_location(obj, &f_zpdesc, &f_objidx);
> -	f_offset =3D offset_in_page(class_size * f_objidx);
> +	page_size =3D class_size_to_zs_size(class_size);
> +	page_mask =3D ~(page_size - 1);
> +	f_offset =3D (class_size * f_objidx) & ~page_mask;
>  	zspage =3D get_zspage(f_zpdesc);

[Severity: High]
Does zs_rebind_handle() also need to mask the object offset with
page_size - 1 instead of offset_in_page()?

mm/zsmalloc.c:zs_rebind_handle() {
    ...
	if (likely(!ZsHugePage(zspage))) {
		obj_to_location(obj, &zpdesc, &obj_idx);
		off =3D offset_in_page(class->size * obj_idx);
		vaddr =3D kmap_local_zpdesc(zpdesc);
		link =3D (struct link_free *)(vaddr + off);
		link->handle =3D (unsigned long)dst | OBJ_ALLOCATED_TAG;
		kunmap_local(vaddr);
    ...
}

When a non-huge multi-page object sits at an offset >=3D PAGE_SIZE within i=
ts
zpdesc, zs_rebind_handle() overwrites 8 bytes in the first subpage and leav=
es
the object's own header pointing to the old src handle, so later compaction
updates src instead of dst.

[ ... ]

> @@ -1615,13 +1691,13 @@ static struct zs_handle *find_alloced_obj(struct =
size_class *class,
>  	int index =3D *obj_idx;
>  	struct zs_handle *handle =3D NULL;
>  	void *addr =3D kmap_local_zpdesc(zpdesc);
> +	unsigned long page_size =3D class_size_to_zs_size(class->size);
> =20
>  	offset =3D get_first_obj_offset(zpdesc);
>  	offset +=3D class->size * index;
> =20
> -	while (offset < PAGE_SIZE) {
> -		handle =3D obj_allocated(zpdesc, addr + offset);
> -		if (handle)
> +	while (offset < page_size) {
> +		if (obj_allocated(zpdesc, addr + offset, &handle))
>  			break;

[Severity: High]
Does this break compilation at this commit?

obj_allocated() only takes two arguments (zpdesc and obj) and returns the
handle pointer, so passing &handle fails to build until commit "zram: suppo=
rt
compression at the granularity of multi-pages" reverts this line back to the
two-argument call.

[ ... ]

> @@ -2215,16 +2292,32 @@ struct zs_pool *zs_create_pool(const char *name)
>  	 */
>  	for (i =3D ZS_SIZE_CLASSES - 1; i >=3D 0; i--) {
>  		int size;
> -		int pages_per_zspage;
> +		int zpdescs_per_zspage;
>  		int objs_per_zspage;
>  		struct size_class *class;
>  		int fullness;
> +		int idx =3D ZSMALLOC_TYPE_BASEPAGE;
> +#ifdef CONFIG_ZSMALLOC_MULTI_PAGES
> +		int order =3D 0;
> +#endif
> =20
> -		size =3D ZS_MIN_ALLOC_SIZE + i * ZS_SIZE_CLASS_DELTA;
> +		if (i < ZS_PAGE_SIZE_CLASSES)
> +			size =3D ZS_MIN_ALLOC_SIZE + i * ZS_SIZE_CLASS_DELTA;
> +#ifdef CONFIG_ZSMALLOC_MULTI_PAGES
> +		if (i >=3D ZS_PAGE_SIZE_CLASSES)
> +			size =3D PAGE_SIZE + (i - ZS_PAGE_SIZE_CLASSES) *
> +			       ZS_MULTI_PAGES_SIZE_CLASS_DELTA;
> +#endif
>  		if (size > ZS_MAX_ALLOC_SIZE)
>  			size =3D ZS_MAX_ALLOC_SIZE;

[Severity: High]
Can the last base-page size class exceed PAGE_SIZE when
CONFIG_ZSMALLOC_MULTI_PAGES is enabled?

Previously, ZS_MAX_ALLOC_SIZE was PAGE_SIZE, which clamped class
ZS_PAGE_SIZE_CLASSES - 1 to PAGE_SIZE when PAGE_SIZE - ZS_MIN_ALLOC_SIZE was
not a multiple of ZS_SIZE_CLASS_DELTA (such as on 16 KiB and 64 KiB page
kernels).  With ZS_MAX_ALLOC_SIZE raised to ZSMALLOC_MULTI_PAGES_SIZE, class
ZS_PAGE_SIZE_CLASSES - 1 gets size =3D=3D PAGE_SIZE + 32 on 16 KiB and 64 K=
iB
page systems, turning it into a non-huge multi-page class while class
ZS_PAGE_SIZE_CLASSES starts at PAGE_SIZE and is unreachable from
get_size_class_index().  Storing an incompressible PAGE_SIZE page then lands
in a non-huge class with an 8-byte handle prefix, corrupting incompressible
page reads in zram and triggering length warnings in zswap.

Should sizes for i < ZS_PAGE_SIZE_CLASSES be clamped to PAGE_SIZE, and shou=
ld
the multi-page classes start at i - ZS_PAGE_SIZE_CLASSES + 1?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115024455.1465=
726-1-zhaonanzhe@xiaomi.com?part=3D1

