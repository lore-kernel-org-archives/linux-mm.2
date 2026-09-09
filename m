Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4BF9C79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:16:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7F4E6B0096; Wed,  9 Sep 2026 06:16:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B56D16B00A0; Wed,  9 Sep 2026 06:16:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A47CE6B00A4; Wed,  9 Sep 2026 06:16:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7EDA06B0096
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:16:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C2A6314017F
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:16:24 +0000 (UTC)
X-FDA: 85193819088.19.6827C83
Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0869CA0005
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:16:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Qz70umdd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of hughd@google.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788948983;
	b=ma4wdOlJzymdxDgS/EIq3v+mtImamwWUaVrYuNDaTOlWs9b5IJtu+r65J4NeVf/91/9Yj0
	zWrh6+nhpujnTcsxMWJc0zfYEpemErBjqqH17AYLp6ORRFoGTnRVZJ88iofyfpxEBUARwV
	UG//WxfIeZU1zUFECWNFZ/a7DGT1y5A=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Qz70umdd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of hughd@google.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788948983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ovd1KkFuD5rQg51sP3+p0bllsBxKk8b6qXB17QYO0U0=;
	b=3M5wAnu0mRAbYXSERQk36jR4i2FX3u4DbWb3rmSbucH8jOujhtFkIVC1F0cw0ig6ScAv9i
	izuSzFAJ7kdTmgvjUUMCkaYXFl47HIUBFyLnFIa0+HNmiryW9DHG8pSQ1QynI5vaLMWgmJ
	HudD8reiKe26er9m6gyySdPBKn+p6js=
Received: by mail-yx2-f12.google.com with SMTP id 00721157ae682-85d46e4cdccso8725617b3.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 03:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788948982; x=1789553782; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ovd1KkFuD5rQg51sP3+p0bllsBxKk8b6qXB17QYO0U0=;
        b=Qz70umddysFrkrVCfFvowL969jU2j3L71JDYX1bNrLf4dJhyy/zjv00lEtrqEVv1rF
         3xkSDYuUzwIvUuy1AYOqdHethzSKKV329Bkwzm6Kj1ZvLygu9QsAopndZr0QxXYzvLe9
         9M7IesUZeATsrnsolRYF9FzFRoc5jAF7PNQ7hYYkkf94QyM8iTpLZ8SfMpMaR7fl55Cu
         0MIyjTfG+BAu288UWBk2YZWRXQDARfmQyZALYlXkLGvc/GPGlprP6gSBpzkk6d6NufqB
         gYnHyYQJdCOPgx2OFlt1NjRCVOPx6zqb92kzZK0y3JYgdojmwPdGAj6vwHaY/hd+gVOh
         eh0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788948982; x=1789553782;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ovd1KkFuD5rQg51sP3+p0bllsBxKk8b6qXB17QYO0U0=;
        b=LX+6LEygf5lB143x9syeWF2ZWIQRcpPWdMkAHvlu22G2E/iCw4VwrsNq3zcEItJXdw
         2hKyzFEeQqem7NgoGWkymzrCBpSU8ygNEG2E+pC6YGGLT3tAe2nBjWA0qQwBIKnKsuMa
         ADrU1YbwwEskcakueF01sFN+poTa8yGHG9MV8XGO2Z2ZU4Kr/a81AzB+soVnUVrqAQ1W
         8eGdFiatZVWXXOTTHGJK5NXBllazpthXll/kUQgmpWmclFF9oDG1NFWhoMMpg+NY4134
         8T8o1f35cT2lNGgxs3xZBxncjkz8I0C0Pvz448EVFpxRHtUPQ644nEwlxGXKvD5G+pbp
         jDZA==
X-Forwarded-Encrypted: i=1; AKwUvBzWEBK6TQHzx0CYxPWDKGeINdtYXCgXE8P7mn/6K6raWES3bluVhOUXQliLN46BZLwfXbtwbJALHw==@kvack.org
X-Gm-Message-State: AFuF++m97+tp0S5SvDCmc9l3NWzTBG4Vv7ume/LVYtzV7H+pOEhBCbHu
	Wr7mV4Rz3xOOcaiOyfw3Kmc8Vkq36gvWSd162E3tyuyUhm8Mj74lxZW+MhKSlZyIdg==
X-Gm-Gg: AYBFou2sSllYQIKmSptCJwDuFUkCC1pgfKuHL42eWs2931nBzcchJmXwO1eyOGALM8W
	IDfsNe6M0sRXhRRmP6QHklRsvjump9P/3uHGsfRw6AJaapXHXC7sKizMGjhwHiAKZk0RaIEkn7+
	c1Tz+lRmRmRZIwUoNwy5wRwru6WS3ZM1RUh1Pw6wKLbfVicrBOOdz8e978DYzWi5uEk+7SHJyr7
	vgeGTxjyDF1dHND1xTKxWZfofwLSkKgUc70bbrWvi9qTUpNEcFcLadQxijWRYbY/tG8fUYEPwCl
	NhEnuKvDbVRocj8bM7boxTP176SNBVSdyI9B+mpGMk2QapSOgifg975b01GJAmV838ygyKfg+Mb
	T3PRcUZn2fK7Tk5N4bVm3HeRI826q9Fs73L/aMT/VKKDHUfzrfFjXJj7X0yCeLpB1lod/nr9vNX
	W1YVRxhdyQ8UxUkAM9JfwKbgx18YQ3/Lvi674Ivbp8KFGWd7APNY/+suaVsocgkqPVS/Estp3gZ
	GX3mhFPmWXvhqr5kpPSDaDZ8vuwQ+WAICVGhUNzpastkDrCwli8bhZ9HKs=
X-Received: by 2002:a05:690e:484b:b0:670:f743:6eb5 with SMTP id 956f58d0204a3-671030a9c66mr1404195d50.19.1788948981459;
        Wed, 09 Sep 2026 03:16:21 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66fb4912962sm11717181d50.12.2026.09.09.03.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 03:16:20 -0700 (PDT)
Date: Wed, 9 Sep 2026 03:16:16 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
    Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
    Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v2 17/26] mm/fbatch: no lru_cache_disable() in
 __alloc_contig_migrate_range()
In-Reply-To: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
Message-ID: <84ed3bf8-da32-3447-0577-052c5d1a56b2@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0869CA0005
X-Stat-Signature: cfahhk9k648w63ytkhra9uki1gzx8azc
X-HE-Tag: 1788948982-971586
X-HE-Meta: U2FsdGVkX1/PlFzKyKubfSbDuFHP1ehBMDh4mY7fybwWpfa9VWldVMXh/EUG8PeVEtia5WZ/bd5j7fRlx9yNv90POLY+YV52do3iHCQeRgUwOzNL0QOaTM+IPqeoxXnHXE1OO5a8oQW0Rpg7fgtY0Aw/Q4MkvmyFEPXzSJz5rk6taxMTOF8sMmYZ8fEpnGIswzjPySko4YaJASRD/IG5KghJ5pzcgFWkG4weI1u1llV4CdJX6wpWmDhjyvc8wpcmNKwa6YL+mKjXNOhaDSFmCnUkuocd2xj94fSlM7eFLb8IISgbQCdq/sPFgA0pKBdtPwnvukVN4gRn+9t/7MIVhn0W7NOQ7gWgskgKcb0+gFQPFe0xUPE3VMUYWJjLkZOZfpu+0pSyCd0SYVdl75w1nqSJztjSHvexTAOz1xoLSqS7a72nQ81WlqwqS0WLCkTzKyYYzdRRCFzjuugv1rT6+U4CBUY4341m01Mxmq60ELwdeeuVumwYkP8qyZXq44T83BkS/s1zl7gXT3fOiuACdiIlm2BFojlI3tbapApkSw2+ifA9dpUgVDQBxyBzuVAqXpu1kEUytxsE2HT1ayWisdqGdhv1TW6rYl8MzcDPCz21WRk5cujRl5Ft/9OcrjKxgL3mXD8JiLRGDVtIGaGAykvzyc8jN5FEgIQItEntYz51FrlDuc0vAdPyys7CaJDvC81ykDeuqNnytczX9FnYaEwRvaBXK8tDArWyBj2cxjdmaEcAzUFU4x/8+OTGLHkeCgwRsSV8aoWBbasLA7S20isKhiN05Oc8YYKqGj7AhMlO7qx85Q4RUBCu0MO97rNkNT+q2EEo/MzZff1qOo3JkHSSk7xhz9UqVaJbSHRpikW4WUHn1gfDIj4qHc+wSK0KicmGDtms11ka2EvQrNv+e9C6b36k8VnHq42XokS3OyAeks7iaAKlfIPo//9ZKbu4kByNc7pgjV6JLkidgAO
 6LSjlscX
 9Yzr6vKzveBVMKIuQYck7Lu06XjCJ83/m152tG9RwC2voRTmHtxysxwHmA2+7dXEWgfNap01uy9MwbjVUtWKS06hgXKyVtVYWzsZ3UyLYg0eyL+v5Txyhmu2TKkWJWPJdC58oInAQBNOeQRJNnUh2Wgwu89YV1cB5+26o1u0DyQ2TNZIb/i74/lYxd67woFC981UI9/7cvoktk6E9boh4vJNQyZ3DcBCF3YrB+eTxWEecOVz8ioO/RSJIqMzHr4pk+nDm8YgU8GA6m6tPjDKKPIVXnFUf0lstFiGT27iE7A6/EalplvcgY+OngGKG8ffy0tfEKAb2ovY0D1TOuNDpUfTP76E58oP02qmoZrR4wuTCd5OT5bcdAWsjLAwEx2Z0D2ZeanPJ+WsAI9toXVMj8kxE2GuBKF37TVmunbD16lj91JIW7ZAR9v0XUBmaoOiClNh0K4Gpaa8BKVe/gpWcUhRvKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove lru_cache_disable() from __alloc_contig_migrate_range(). It does
not now benefit from lru_add_drain_all() first; and gains little benefit
from invalidating buffer head LRUs first, since 5.0 commit 80409c65e2c6
("mm: migrate: make buffer_migrate_page_norefs() actually succeed").

This will be more controversial. lru_cache_disable()+lru_cache_enable()
were brought in for CMA page migration, see 5.13 commit d479960e44f2
("mm: disable LRU pagevec during the migration temporarily") through
8cc621d2f45d ("mm: fs: invalidate BH LRU during page migration") - I
guess the testing there must have been on a 4.19-based Android kernel,
without 5.0's buffer_migrate_page_norefs().

It's possible that invalidating BH LRUs perhaps 0 times, perhaps N
times, will average out worse than invalidating 1 time and stopping
everyone else; or that folio_test_clear_lru() failures manifest more
than before (note how folio migration has retries on raised refcount,
but isolate_migratepages_block() no retry on failed test_clear_lru).
But let's give this a try and look out for regressions.

Don't delete lru_cache_disable() yet: leaving stale folio pointers in
the per-cpu fbatches, with folio_try_get() yet to come on them, would be
bad for memory hotremoval: the lru_cache_disable() in offline_pages()
protects from that.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/page_alloc.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 12fac9084c48..3e085a25a776 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7147,8 +7147,6 @@ static int __alloc_contig_migrate_range(struct compact_control *cc,
 		.reason = MR_CONTIG_RANGE,
 	};
 
-	lru_cache_disable();
-
 	while (pfn < end || !list_empty(&cc->migratepages)) {
 		if (fatal_signal_pending(current)) {
 			ret = -EINTR;
@@ -7182,7 +7180,6 @@ static int __alloc_contig_migrate_range(struct compact_control *cc,
 			break;
 	}
 
-	lru_cache_enable();
 	if (ret < 0) {
 		if (!(cc->gfp_mask & __GFP_NOWARN) && ret == -EBUSY)
 			alloc_contig_dump_pages(&cc->migratepages);
-- 
2.51.0


