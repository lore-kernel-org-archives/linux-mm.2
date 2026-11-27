Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10831606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 08:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.a=rsa-sha256 header.s=s110527 header.b=AHFaJuEh
Received: by kanga.kvack.org (Postfix)
	id B12636B05B8; Fri, 27 Nov 2026 03:28:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEA2E6B05B9; Fri, 27 Nov 2026 03:28:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DAAD6B05BA; Fri, 27 Nov 2026 03:28:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 07D046B05B8
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 03:28:14 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 53E5EC0279
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 08:28:14 +0000 (UTC)
X-FDA: 85480221708.08.EF38A0E
Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.6])
	by imf20.hostedemail.com (Postfix) with ESMTP id 563391C0004
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 08:28:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=126.com header.s=s110527 header.b=AHFaJuEh;
	dmarc=fail reason="SPF not aligned (relaxed)" header.from=xiaomi.com (policy=quarantine);
	spf=pass (imf20.hostedemail.com: domain of nzzhao@126.com designates 220.197.31.6 as permitted sender) smtp.mailfrom=nzzhao@126.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795768092;
	b=o25fdqnFxIyhX4gLG+CcW6wBVL7hWY4BoIu3FmP1mZx4RKOPdcsigGZpanHf9ytLM6TJlu
	emNrMnZOsMWfzBhUzOwxqMfq12TUeTnijWzTvaigQnlGgoARbIonwdcRL9ED0jb34xBz2A
	laLzLhjITNrLmy36RP+2UBLKcN1Nhso=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795768092;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1sIJUe4O4CsWbtMbQNi4aeXjMyQYal1HiWg977wjesI=;
	b=8I/02FHmzGW4fgPTQS3EndbpkIWts6WEOo/IYz59Vn/4WFHYwG/OWEFhRBpx07/eqRqD0f
	EKeAdZh1UXHdaQnD2q1gd7sNEP+gqs2Z2/AuNaflwsvhittPXrF5dDPFPrYMqZO92rwIjZ
	Hn7+lNHEIKvPtBxtkAHLyis2St8rQCE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=126.com header.s=s110527 header.b=AHFaJuEh;
	dmarc=fail reason="SPF not aligned (relaxed)" header.from=xiaomi.com (policy=quarantine);
	spf=pass (imf20.hostedemail.com: domain of nzzhao@126.com designates 220.197.31.6 as permitted sender) smtp.mailfrom=nzzhao@126.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=1s
	IJUe4O4CsWbtMbQNi4aeXjMyQYal1HiWg977wjesI=; b=AHFaJuEh0EIkAkyo2c
	ZVBqUZ9yupduHxWzUtjdjRTae0SDHFnaZIZf1Cj8HuqZGfghrCYnrxiuplKwyjLP
	kJJ9i4K8NXTV3yo5ESq/c2u3G1GsZ1QOUjIoY6Wfh1KN2jHQ0jDCNjFtfWmRwUw5
	dOeKubTHbfksoYyH1iOaTPaQo=
Received: from nzzhao-ThinkCentre-M760t.mioffice.cn (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PikvCgDnz+_cPglrqen2EA--.50878S2;
	Fri, 27 Nov 2026 16:27:09 +0800 (CST)
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
Subject: Re: [RFC PATCH v4 2/4] zram: support compression at the granularity of multi-pages
Date: Fri, 27 Nov 2026 16:27:06 +0800
Message-ID: <20261127082707.3624358-1-zhaonanzhe@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-216089@kernel.org>
References: <20261115024455.1465726-1-zhaonanzhe@xiaomi.com> <20261115024455.1465726-3-zhaonanzhe@xiaomi.com> <sashiko-outbox-216089@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PikvCgDnz+_cPglrqen2EA--.50878S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJF1DAFWrCryxWry5KryUKFg_yoW5Xr4UpF
	y7Ga42yr4kJF1IqFsrCFZ7u3s2yr4S9ay8Gry8tr47Wa4rX34qqFWqgwnYka1UCrWfW39I
	gws5ArZ5J3WUZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UvksDUUUUU=
X-CM-SenderInfo: xq22xtbr6rjloofrz/xtbBsR3js2sJPt1GbgAA3V
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 563391C0004
X-Rspam-User:
X-Rspamd-Pre-Result: action=add header;
	module=dmarc;
	Action set by DMARC
X-Stat-Signature: mkr543z19y18qzdtwk1u8upyyrfsp4s6
X-Rspam: Yes
X-HE-Tag: 1795768090-415451
X-HE-Meta: U2FsdGVkX1/CaAOhkFoxbjjK52LRrGrDHRiAD5WP5vCzgC3kqF47ffBlhDGurvFfYweWuYTfJX+Lm+LzmcNNSwcaANNzIM/ORPUeASE6PzHvQWSn3HgNBJP7SIuF0tB18Cqb6ErxtlavNIrlpIFCJ+IVr+mY0frEglKGeeJVw+U0LBciVPWN+5jPSqUf2QfldavOTII204tG9w8BupscqJcR63Rwat6Qwojqt+L9hXisKthbFnoSq9AzyjH0jt+7j9MKI42OMrnM5tb7q3X2TpD0rpdH3itJf1+FLYQIvzOUwhStHGbfyBruyfoy3Ybx3zuSK5yBL/ODPqObfU9eEdhTOyGzVTyA1BFjUyEXxd9bLVd2P2XNvEXtdRnHX0VwxrMUQ7TK7rtkTVeBtigAh/+nGfxvIOt+VzViuvB5bFre2K+avmoja6Jd2FfsAFcQZCOVrGo4P1I783hY2daFmXeD2w6mxhd22BWGfz9Svh8b999rMsRnz9zreyMKziqHgG9iU7h8ORsK8sjjLzdIfqFABe98xTfGSW/XYyaVAQDvIEmxOPxWVaQIFgWkvsrGo7I+XManiisCDA8+lSRDTjMYXlt/BRdMxQvHZtQZQlugjAndGBhOgfPRH/1oRy9KTHQ3gNvMAWbKHuWGQ0+5vhbpZeuC8bKlygas0MTkshS9O9wPBD/4O44xi12rfrD447ltzjQraSnkIe7cxcDf/Nzjx0BHcLIzf3Z04fnDqgOTiPzLP1+5ZvS7sczY139YVcV70bKew938nDRBiemmuDkmRNZtA7KxGEud3lK8SgR4QeCBNP1/QTioqq83g3Uex0wuvuSK2BNgRqA7U6ulLUXJVk45ZDW5w0ChP45cUGHYVxBZz8Yb6QxJbzDwtLjJtAlHmOayXADt3GekDxMl0AyPgFZJO/vN21rl6VjEXWVQtkQeoIA3PwjIASTNUzHcq2/Nb1WnYuJVIQdT8w4
 wV7ShkKu
 IMDhaQQwe05CE1c2uKpkf+IntI2JRgXwz7WRfMTVUDzm5NRpJMcuV+U6vgKd6uROk6PkwdaKngds+iqZCA+MsFNKXLqutBTH3WhFguVHWu4+JnLsmOtA+/HeN57L8GXVkodHc3qMiHOa8LZuOWflUHo8QUXT5XOZt/NaL/cjOZNGJUi3a48m+HkQzurgGAnjD8ohHzve9dO3MAi/rBMyn5x7TMEbemEi36HlOhVKPyRvDZiRHFFeD1aAB9ukopSSxm/+REyPokeInMjON6OylSJ49l7xMr57FbXwyHfjmpyTrYg0LK4hQqIx7bYJD+Hz6Xlq8xiO1GR4difWk3V+EqphJhcraNyykqXeSj6hiLKPHKhj52GF1dHATSUwEa0VzojZ24BmZmLHzUQXw+pFAD+PkWxiwMMZuHGolY7zV946iBbjWN/RDECIvcrjfNTnKnRe1Ywvj8lQUe+qkPyhvM2E4x5YBn7RD5UpVFarOSggrbtI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> [Severity: High]
> Does passing bio as parent to zram_read_page_size() cause a use-after-free
> of page when ZRAM_WB is set?
>
> When test_slot_flag(zram, index, ZRAM_WB) is true, zram_read_page_size()
> calls read_from_bdev(zram, page, index, blk_idx, parent) with a non-NULL
> parent bio:
> ...
> read_from_bdev_async() submits an asynchronous child bio referencing page
> (inheriting REQ_OP_WRITE from the write bio) and returns 0 immediately,
> after which zram_bvec_write_multi_pages_partial() frees page via
> __free_pages() while the backing-device I/O and completion work are still
> using it.

Both writeback and recompression currently assume that each slot holds a
single PAGE_SIZE object, which conflicts with multi-page slots, so I plan
to temporarily make CONFIG_ZRAM_MULTI_PAGES mutually exclusive with
CONFIG_ZRAM_WRITEBACK and CONFIG_ZRAM_MULTI_COMP via Kconfig.

> [Severity: High]
> Can post-processing a multi-page slot overflow ctl->pp_buckets[] and
> req->page?
>
> Neither scan_slots_for_writeback() nor scan_slots_for_recompress() skips
> ZRAM_COMP_MULTI_PAGES slots, where get_slot_size() can be up to
> ZCOMP_MULTI_PAGES_SIZE.  In place_pp_slot(), NUM_PP_BUCKETS is sized for
> PAGE_SIZE:
> ...
> When a multi-page slot's compressed size exceeds PAGE_SIZE, bid exceeds
> NUM_PP_BUCKETS and corrupts memory past struct zram_pp_ctl.  In
> zram_writeback_slots(), req->page is a single PAGE_SIZE page, so
> read_from_zspool_raw() also overflows req->page and wraps PAGE_SIZE - size
> in memzero_page(), while uncompressed writeback and recompress_slot() pass
> PAGE_SIZE for a multi-page object.

Same here. With writeback and recompression disabled under
CONFIG_ZRAM_MULTI_PAGES, scan_slots_for_writeback(),
scan_slots_for_recompress(), and place_pp_slot() will not be built or
called on multi-page slots.

Also regarding the related zs_rebind_handle() issue from the patch 1 review:

> [Severity: High]
> Does zs_rebind_handle() also need to mask the object offset with
> page_size - 1 instead of offset_in_page()?
>
> When a non-huge multi-page object sits at an offset >= PAGE_SIZE within its
> zpdesc, zs_rebind_handle() overwrites 8 bytes in the first subpage and leaves
> the object's own header pointing to the old src handle, so later compaction
> updates src instead of dst.

This is tied to the same recompression issue: zs_rebind_handle() is only
called by zram's recompress_slot(). With CONFIG_ZRAM_MULTI_COMP and
CONFIG_ZRAM_MULTI_PAGES mutually exclusive via Kconfig, multi-page objects
will never reach zs_rebind_handle().


