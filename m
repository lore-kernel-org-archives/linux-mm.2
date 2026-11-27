Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D641C606A6B2
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 08:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=126.com header.i=@126.com header.a=rsa-sha256 header.s=s110527 header.b=V4DWH0yz
Received: by kanga.kvack.org (Postfix)
	id B5E0B6B05B3; Fri, 27 Nov 2026 03:09:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B34436B05B4; Fri, 27 Nov 2026 03:09:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4AA96B05B5; Fri, 27 Nov 2026 03:09:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D5536B05B3
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 03:09:41 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CFE3D1A0228
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 08:09:40 +0000 (UTC)
X-FDA: 85480174920.26.E564E9E
Received: from m16.mail.126.com (m16.mail.126.com [117.135.210.8])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2AA2F120009
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 08:09:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=126.com header.s=s110527 header.b=V4DWH0yz;
	dmarc=fail reason="SPF not aligned (relaxed)" header.from=xiaomi.com (policy=quarantine);
	spf=pass (imf29.hostedemail.com: domain of nzzhao@126.com designates 117.135.210.8 as permitted sender) smtp.mailfrom=nzzhao@126.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795766979;
	b=XlVDfaHl8ZIPa0HugbohOKj9bq00GyKZgY6YQRjpYDQIiEbCASbHMxatQJxpM8tmBu6wQn
	hHXw6Xo7I8hOFplLd3ZZFlLo6N5U5rb1cXkBgPKWVACqjBbg2UhwdK+xffAYCiIztFt051
	GvTJR51/C8t0Tb1lYmL9xu48kP8F2Ck=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795766979;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z2WPS4JyLBQjVa8az6zNUmfoJeGYnzi48maeQui2YGk=;
	b=mmP+KZAuoP26A/ArACcr5nMs9j5VVH+OT2ekUajZ3fSxbgnN9L/YwhM+deVH9WxI2kfltw
	L8LC8Q/plLZda+9WvqAVV3PjeTuZK0EpSXqrgGuipLVDfv9QBhrmJWhQjtVLxyNfXlMuYP
	pobHjxiTDYtkRIMUH8QN/xtfhcSjyUQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=126.com header.s=s110527 header.b=V4DWH0yz;
	dmarc=fail reason="SPF not aligned (relaxed)" header.from=xiaomi.com (policy=quarantine);
	spf=pass (imf29.hostedemail.com: domain of nzzhao@126.com designates 117.135.210.8 as permitted sender) smtp.mailfrom=nzzhao@126.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=z2
	WPS4JyLBQjVa8az6zNUmfoJeGYnzi48maeQui2YGk=; b=V4DWH0yz4Hxc2E44OV
	3qnKP624PPmfYc2UKZj/j4RHu4IvoUIlpmO4VdqRjF/UWsiC6ipP9NCGzYEstCXs
	HCFGgJBFVTQQZc0ZdJmp4U6pUC/wM8d+QVCuYrTD8zDZT+VZwOIZN47swrwxwiTp
	PQuOVlTqiJeXWHPT0Ss5MOh1Y=
Received: from nzzhao-ThinkCentre-M760t.mioffice.cn (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wD3Pwd_OglrliZsEA--.60259S2;
	Fri, 27 Nov 2026 16:08:33 +0800 (CST)
From: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
To: sashiko-bot@kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Tangquan Zheng <zhengtangquan@oppo.com>,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Usama Arif <usama.arif@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Ying Huang <ying.huang@intel.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	Wajdi K Feghali <wajdi.k.feghali@intel.com>,
	Bala Seshasayee <bala.seshasayee@linux.intel.com>,
	Nick Terrell <terrelln@fb.com>,
	Barry Song <baohua@kernel.org>,
	Bo Zhang <zhangbo56@xiaomi.com>,
	sashiko-reviews@lists.linux.dev
Subject: Re: [RFC PATCH v4 1/4] mm: zsmalloc: support objects compressed based on multiple pages
Date: Fri, 27 Nov 2026 16:08:22 +0800
Message-ID: <20261127080831.3599864-1-zhaonanzhe@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-216088@kernel.org>
References: <20261115024455.1465726-1-zhaonanzhe@xiaomi.com> <20261115024455.1465726-2-zhaonanzhe@xiaomi.com> <sashiko-outbox-216088@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3Pwd_OglrliZsEA--.60259S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxuFykWr4rXFyxtrykWr47CFg_yoWxXFWDp3
	WxCanrAr4rXFy8J3y7Ar4kAanIywsxKF48KayrurWfuFWrJ3s2gFy7Kry3XF48ArsrA3yx
	Xws2yw43Aa1rCw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U9XocUUUUU=
X-CM-SenderInfo: xq22xtbr6rjloofrz/xtbBowHLm2sJOoG5ZwAA31
X-Rspam-User:
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2AA2F120009
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Pre-Result: action=add header;
	module=dmarc;
	Action set by DMARC
X-Stat-Signature: i6rorsfn6kzycau3xt34tqs7czo57orf
X-Rspam: Yes
X-HE-Tag: 1795766976-122070
X-HE-Meta: U2FsdGVkX1/SMfCneXwYOUVA66bKsoGcdXsOuYdVbyzVC+QGGYpnROJLICS+vf5vx3WFxdvep9jvbBcH4asB5jlB4UIwrz9EdzKlvBiOkxBEXNsjioLicr1dGUbLlqb9ByiF50OrMLeKhAKOabo6yVXNW43QuEXwve/e+OFrPd+U36ss2iar0tEGT+Jsf83p+5zRyycYc5MQL/e70GPvu/Duv6gEh7UK8OO8XycFvJnVqL0ciFuYBZ3SQwLT2phq+VDoeMYOgpvGFt8xhZdkUuU+Eiey2JFpdwys8QN4pC7pLUDgu+XU+2+jXV5sLc53mGQ7KJVPPHViJUokN5OYzaWys9Hpvz8+y7oWSc46z+jd3kv2MdG32aEQ/d7LwIU0TsjY6q1hAIdNXCxr8Dmk5/mlIyNpMipLEN2f3bb53J6JRfVR3H4oz9hw+huC1pgwFglHL6cpjyv8vN81XwNZPjZwGvMzGmc2L1U2btiQyrQBtc/fNZKu5ea15U93yMCKs6hfHtiKVPXWAvFDqR7qkGCfOiQcBBooaqfkUU94dfGdYtCOTmCLOlHgg3tKRNJi9hNhpLRLw8ciPfEwVtRRDq9V2vA4v+ywLDyZMWVuL2cxE7g9jbOCiF3OVjhhst7DwLSe5fy7NxWbVhzccg5SJ0UP0rTYUi3tq6HNPk1zVFmEWpliPmDSZrwAciIMdJSewnYoLbrc+yaAQiHpf1SRm6FofVJYsiHRKHJj1NW2WTA8C90gyjmDzGHhYXIuL+xg4yOz903pxnUg9pOExs9anhunw30h/mDXlzQVVvmtT8CZg6QxV8Gv/xMzaaTsD6vKYV6gh7T9jFrKehtDDKm+EJoPyH6OriWsxEuOqDK0eFDUdyyoItD0Zk5uDk8zyWZvmIbVIXQTAKlnFOkLfdQn+oKwaHIyPsncT6YSgBGXZX17CToMf6tim75vNt1LauTokTwY+5XZdPlnl1aTe6w
 GcCU3lad
 Tvh8McjeQM/iI9XnuxFbR8wTDY6EPE767xOEaCqgJ7sEHQnr60H0Rtvw3FUPZOeBt3fARs3fFacgJaFBCqRCqR4qkklpBuF7mqp2RnxF/4NNf0vSmPD7zzJbOne98rHgv/m4OaBkVfluxDzeqYik1MGxp6qCAKMY+TpcGUT6qZ6Fd59HvBDXNqWQzOSDZpiVq1b0k9O9ASCLNWtY5jOxjRBcfPtLtY+AzLKqObDxdSPKP0Z3M+pkkoMn6U3JzLVOvGA4RIQrirO7AsBnZcjVHO+isV5WFPeeSf/SAb2w7AKnO3G8BVejwoVLNXoFaEkK+IQYQMg07sb40IvlMwhetYK+jZzQ9YpJ9sjlsZ67Gp2emuNUjD9HZR80HTq63LoMDXhWgei7/iP3fkmGuOHxs7tX/4wvHdvsDG2sc14Wj9egLuBTUULE0EuIR5zwXbGN2Z65aXLKRM95KUeIGSbRAWymcl+HwbNjgViNgxbxLKBhHvaM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> [Severity: High]
> Does this break compilation at this commit?
>
> obj_allocated() only takes two arguments (zpdesc and obj) and returns the
> handle pointer, so passing &handle fails to build until commit "zram: support
> compression at the granularity of multi-pages" reverts this line back to the
> two-argument call.

Yes, patch 1 breaks compilation on its own. I will fold the mm/zsmalloc.c
change from patch 2 into patch 1 to keep bisectability intact:

--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1698,2 +1698,3 @@ static struct zs_handle *find_alloced_obj(struct size_class *class,
-		if (obj_allocated(zpdesc, addr + offset, &handle))
+		handle = obj_allocated(zpdesc, addr + offset);
+		if (handle)
 			break;

> [Severity: High]
> Does calling memcpy_to_page() here trigger VM_BUG_ON(offset + len > PAGE_SIZE)
> when writing a multi-page object that spans two zpdescs?
>
> For a multi-page class, page_size is larger than PAGE_SIZE, so off + sizes[0]
> equals page_size and exceeds PAGE_SIZE in the first memcpy_to_page() call
> (and sizes[1] can also exceed PAGE_SIZE in the second call).

Agreed. I will replace it with kmap_local_zpdesc() and memcpy():

--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1270,16 +1270,18 @@ static void obj_write(struct size_class *class, struct zspage *zspage,
 	} else {
 		/* this object spans two pages */
 		size_t sizes[2];
+		void *dst;
 
 		sizes[0] = page_size - off;
 		sizes[1] = size - sizes[0];
 
-		memcpy_to_page(zpdesc_page(zpdesc), off, src, sizes[0]);
+		dst = kmap_local_zpdesc(zpdesc);
+		memcpy(dst + off, src, sizes[0]);
+		kunmap_local(dst);
 		zpdesc = get_next_zpdesc(zpdesc);
-		memcpy_to_page(zpdesc_page(zpdesc), 0, src + sizes[0], sizes[1]);
+		dst = kmap_local_zpdesc(zpdesc);
+		memcpy(dst, src + sizes[0], sizes[1]);
+		kunmap_local(dst);
 	}

> [Severity: Medium]
> Should these helpers use zone_stat_add_folio() and zone_stat_sub_folio()
> instead of the double-underscore variants?
>
> __zone_stat_add_folio() and __zone_stat_sub_folio() require preemption or
> interrupts to be disabled, whereas alloc_zspage(), zs_free() ->
> __free_zspage_lockless(), and zs_page_migrate() call these helpers in
> preemptible context with no locks held, triggering preemption-disabled
> assertions and racy per-CPU vmstat updates.

Agreed. I will switch to the non-preemption-disabled variants:

--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -345,4 +345,4 @@ static inline void zpdesc_inc_zone_page_state(struct zpdesc *zpdesc)
 {
-	__zone_stat_add_folio(zpdesc_folio(zpdesc), NR_ZSPAGES);
+	zone_stat_add_folio(zpdesc_folio(zpdesc), NR_ZSPAGES);
 }

 static inline void zpdesc_dec_zone_page_state(struct zpdesc *zpdesc)
 {
-	__zone_stat_sub_folio(zpdesc_folio(zpdesc), NR_ZSPAGES);
+	zone_stat_sub_folio(zpdesc_folio(zpdesc), NR_ZSPAGES);
 }

> [Severity: Medium]
> Can ZSMALLOC_MULTI_PAGES_ORDER=9 overflow the 24-bit first_obj_offset field
> on 64 KiB page systems?
>
> With 64 KiB pages, order 9 gives a 32 MiB zpdesc, while
> set_first_obj_offset() masks offsets with FIRST_OBJ_PAGE_TYPE_MASK (16 MiB)
> and only checks BUILD_BUG_ON(PAGE_SIZE > SZ_16M):

Agreed. I will check ZS_MAX_ALLOC_SIZE instead of PAGE_SIZE:

--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -551,3 +551,3 @@ static void set_first_obj_offset(struct zpdesc *zpdesc, unsigned int offset)
 {
 	/* With 24 bits available, we can support offsets into 16 MiB pages. */
-	BUILD_BUG_ON(PAGE_SIZE > SZ_16M);
+	BUILD_BUG_ON(ZS_MAX_ALLOC_SIZE > SZ_16M);

> [Severity: High]
> Can the last base-page size class exceed PAGE_SIZE when
> CONFIG_ZSMALLOC_MULTI_PAGES is enabled?
>
> Previously, ZS_MAX_ALLOC_SIZE was PAGE_SIZE, which clamped class
> ZS_PAGE_SIZE_CLASSES - 1 to PAGE_SIZE when PAGE_SIZE - ZS_MIN_ALLOC_SIZE was
> not a multiple of ZS_SIZE_CLASS_DELTA (such as on 16 KiB and 64 KiB page
> kernels). With ZS_MAX_ALLOC_SIZE raised to ZSMALLOC_MULTI_PAGES_SIZE, class
> ZS_PAGE_SIZE_CLASSES - 1 gets size == PAGE_SIZE + 32 on 16 KiB and 64 KiB
> page systems...
>
> Should sizes for i < ZS_PAGE_SIZE_CLASSES be clamped to PAGE_SIZE, and should
> the multi-page classes start at i - ZS_PAGE_SIZE_CLASSES + 1?

Yes. I will clamp base size classes to PAGE_SIZE, start multi-page classes
at i - ZS_PAGE_SIZE_CLASSES + 1, and adjust get_size_class_index() accordingly:

--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -211,4 +211,4 @@
 #define ZS_MULTI_PAGES_SIZE_CLASS_DELTA	(ZSMALLOC_MULTI_PAGES_SIZE >> (CLASS_BITS - 1))
 #define ZS_MULTI_PAGES_SIZE_CLASSES	(DIV_ROUND_UP(ZS_MAX_ALLOC_SIZE - PAGE_SIZE, \
-					      ZS_MULTI_PAGES_SIZE_CLASS_DELTA) + 1)
+					      ZS_MULTI_PAGES_SIZE_CLASS_DELTA))
 #define ZS_SIZE_CLASSES		(ZS_PAGE_SIZE_CLASSES + ZS_MULTI_PAGES_SIZE_CLASSES)

@@ -586,5 +586,5 @@ static int get_size_class_index(int size)
 		idx = ZS_PAGE_SIZE_CLASSES;
-		idx += DIV_ROUND_UP(size - PAGE_SIZE,
-				    ZS_MULTI_PAGES_SIZE_CLASS_DELTA);
+		idx += DIV_ROUND_UP(size - PAGE_SIZE,
+				    ZS_MULTI_PAGES_SIZE_CLASS_DELTA) - 1;
 		return min_t(int, ZS_SIZE_CLASSES - 1, idx);
 	}

@@ -2305,4 +2305,4 @@ struct zs_pool *zs_create_pool(const char *name)
 		if (i < ZS_PAGE_SIZE_CLASSES)
-			size = ZS_MIN_ALLOC_SIZE + i * ZS_SIZE_CLASS_DELTA;
+			size = min_t(int, ZS_MIN_ALLOC_SIZE + i * ZS_SIZE_CLASS_DELTA, PAGE_SIZE);
 #ifdef CONFIG_ZSMALLOC_MULTI_PAGES
 		if (i >= ZS_PAGE_SIZE_CLASSES)
-			size = PAGE_SIZE + (i - ZS_PAGE_SIZE_CLASSES) *
+			size = PAGE_SIZE + (i - ZS_PAGE_SIZE_CLASSES + 1) *
 			       ZS_MULTI_PAGES_SIZE_CLASS_DELTA;

> [Severity: Low]
> Does the format string need a trailing space after the third "%5u" to match
> the header and Total lines? Without it, all subsequent columns in each
> class row are shifted left by one character.

Agreed. I will add the trailing space:

--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -670,2 +670,2 @@ static int zs_stats_size_show(struct seq_file *s, void *v)
-		seq_printf(s, " %5u %5u %5u", i, class->size,
+		seq_printf(s, " %5u %5u %5u ", i, class->size,

> [Severity: Low]
> The kernel-doc comment above zs_huge_class_size() is missing an @type entry
> for the new parameter.

Agreed. I will document @type:

--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1292,2 +1292,3 @@
  * @pool: zsmalloc pool to use
+ * @type: zsmalloc type (base page or multi-page)


