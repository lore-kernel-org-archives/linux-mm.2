Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2094C79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:05:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E763C6B008A; Wed,  9 Sep 2026 06:05:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4F276B008C; Wed,  9 Sep 2026 06:05:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D653D6B0093; Wed,  9 Sep 2026 06:05:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B9A8D6B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:05:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7958BC017D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:05:25 +0000 (UTC)
X-FDA: 85193791410.12.DB76CF0
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id AFA631C0007
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:05:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=s4Ww2bMA;
	spf=pass (imf20.hostedemail.com: domain of hughd@google.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788948323;
	b=glGAaMNanNwMQmBVEA6a017AdiOfdRbrodWwbTetNazJA6CsZLUYrTt+UJ4kGXl6Sk/Ta6
	W4zqwJZRM0pNmeb1p0hud4xNqjHIqWJBvnBArhd2umcTTadwy5ALc8T5P+DqQasAygbCL+
	hD3Obf/V6orZvmdW76f+v3jyioaR/3w=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=s4Ww2bMA;
	spf=pass (imf20.hostedemail.com: domain of hughd@google.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788948323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yFQHd4CD2vPDTEJCwRK4KnJHHa5RS0l8x4Ius5m53Xw=;
	b=qIecMiFZpncXjq8bws/5qcnd+9+mjFmvJ4RPT1+UXJK7j4PPQgUGlVln4szc+C7MiV3nsQ
	xXLLlOg8jqoEDxjlsWoMa0ccYEzfir807TlmAGSpI+ypo0ueIlva91l3w9vCs/VefMRoBl
	s/dcK/yqdvg1m//KeVYtypSIoSd8lG8=
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-87005a0e052so66073197b3.2
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 03:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788948323; x=1789553123; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yFQHd4CD2vPDTEJCwRK4KnJHHa5RS0l8x4Ius5m53Xw=;
        b=s4Ww2bMADYcQTb0r7bthYqrKHUuYW5RUu8+RnU8nskuiGOPZEo1b/DQIrz1LZ+JwJo
         caBm3qoLWDVImPDmncKYHvLXM8UFfA3ohzTcS9VZHhjGYLouDsNyY0feN/ZUFUcfnoHj
         rJY+wSgP5+vdPJ/UuIT7+SGc3GLOVmppayZ7RUokR5Bv/0Q5nvicfN6jXv0P9/bbKPmc
         uXNBLnAramTD/FHMRZNlm7TeZ0KdW1xEtIByACp6CTloHzIDXagd39g95pzLILM1LJIs
         GC3TWy4pH5rZY/7sJC1Y99qwjB2LKDmVXwXeSJYVjosTMthDsfBJsKUpibp/UeSttiDO
         OZeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788948323; x=1789553123;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yFQHd4CD2vPDTEJCwRK4KnJHHa5RS0l8x4Ius5m53Xw=;
        b=ZGloloZGhLoxYaOJUI/IlUj9gWzYuFqTVyWyPc5a/5o33XhI3Cj7osyz/ujCbqrT2U
         OVK5Qfsd6mVqT1w5JY/NIiun/iP6biMYcuFIYynLtxnPaff+zdfzrG6Z8kOTNNZ/XYPH
         vsQseuQQ8gqT8IhKPJDZHlY/71BDrU62mfUjpvU75syAX+sYYu/3a6UI0t10CnKVD7fx
         2lxX7KCqmEUM/8Aq+rncP5bCvx/v+8/RuY2fYfsmTBSPyahwv3+itSzYZr9nXwkaxvBH
         Qj5VbdFs6J2QWfIipPF1AK8+T9eo3ZiiZ4Flsai3XLuk3l1VkJEZwn2nQlKaCkp1GiLF
         /zUw==
X-Forwarded-Encrypted: i=1; AKwUvBys+IyipdeMJSyVifapchlnXP5niXhYuAqp+pB1Uo8HFdR1e7qmYJZZBLPhesGBDs/3IPY3T9OEFw==@kvack.org
X-Gm-Message-State: AFuF++mAdAnX41zO+WF79dee1OtguUvQxxeMPkWcY3en2iR3xeENs9I/
	x4iX9/jiroqdzmNjaxcuj/SfU2Pmz1bxF/nnIudyy22fcGOZdmnWES1naN5CCSEKGA==
X-Gm-Gg: AYBFou15t/XIw1QLHrqANU7zZtDpQipmgwzjxjETKuV5pqlbBp1ySSnqfhnFM7/Noop
	e/4XUKhGwzkMIw0aI+RI5k/AJf6rvX9F4yeSmTgoq34Gmt2OOwsMaMByPD3AMuT/NprfpAha/cg
	QxIZ1RVW1DPwWokP7H3CTPNUGSJCRRBvbh3P1OcKAC9gWyMSFKSPv2VpTL4CXkDkvO0791Imlcz
	oHdLJVGqWZKtd+igpoi4Ev0B7m75sla4qLD94QB0/YUAzYMSDYoMYpp64gLibkC1pgBMRNEkSi6
	l3YVoRjEFarhVNEZkkVAOEV7/79lNzI5qiT4A53jkanZUoWSVNAgdEOXTXkX6wpxpYzntgib0bm
	w/+8jMM5Ivm0OEB3jr66vpjUF4NMXzWU/BqgW8esOnQq8P/POJw+jV/V8I0Qid1kETHVtOflATn
	tXC+CHj82KFAMLnn6XK+MLxlVqGPUPOT65Q+8xqyT+aAD5ZfobYyYu5tPh1B67rgaxO/dIE+2oK
	n/PNMR+YbChFpSdnEpteD4GBFy5M2KntLf0gsCsWvhKA+OD1JNoIvRh5IQ=
X-Received: by 2002:a05:690c:88:b0:864:6f4d:ef7f with SMTP id 00721157ae682-87121acbbc5mr139779397b3.7.1788948322156;
        Wed, 09 Sep 2026 03:05:22 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8714befac64sm107718397b3.47.2026.09.09.03.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 03:05:21 -0700 (PDT)
Date: Wed, 9 Sep 2026 03:05:16 -0700 (PDT)
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
Subject: [PATCH v2 12/26] mm/fbatch: remove percpu_pvec_drained and
 folios_put()
In-Reply-To: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
Message-ID: <e5f75b23-a65d-85f0-850d-a3c375ef420a@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AFA631C0007
X-Stat-Signature: qqdmh9gsyw6mfo8y91x1uf878yx6xqea
X-Rspam-User: 
X-HE-Tag: 1788948323-164989
X-HE-Meta: U2FsdGVkX1/5B/39zrPJLczkcQzms2/sl0Jjg8Umk/b6TxxSA4879WbScM0DLlQ9N6evwGSDmILkhtuFbA9URsof/fDSZT2h5p3yGHU6zH3jXEk8jcVN08hnSGT+XopI7hWUv/MmqNoJlAWNCXKs1gFwizg/Xctu8vEm2e7Dqppb6Ra8TnyL50cWcLVC90xumVljoILlMDl9beU3B/Pcy1bC3OSdTYUkP66OIenB2ZyTppiHKLKf6qbiOtKJxMLMZXG57+jRaQMyEeWUphVAHtzPek/i6n4AJWsdKY4U6vUCuZheVBe7cfvdGUgP17+f7i5M2/3teSWeL5OjUT+aanpSOs23gi3v3GeCE6xDat1J8VE51T8+nb7qdKrSQcCcKtElm/AQ61LQmhUAOAtHMgEafxGtQSRBDX8Xo1KJnCJBIqwk/BiBHFjXLh0znYL6MLTy4ZV0aZRD7axmOtt8Gywr93ppBqtbpvSnNJzLS0O4mKh92o9BN3Z3ywc7hTAR7p8Pc0W7tN62gSo+MOL0JvN62+RD/3ZkLRxH4iG57oopqKFiLrch0oj2MGIa4PyOn31oVSQbnQdqPkK7dUh+1kTUo8dIC9Vzx1dYqjRCH3SKCmJh9igE76+fGp27nqga2wKu4cA/tUzyixyHip6ail/qIeKLwXiOJ8piyhFnFlhIhthOLS6/gJgLG2FSlMut3quPA4xVv3c/5OuMQ8wDWATsTyTiDlArWNGswpr7ebSd8GROwZI9ff7W8rCSQiKKq4KozPW9DJnZTwta7sTbGoZ+IEZzpkFUf5P/0ZEWaNzornzdudSYeIYrz2vwBgMA5SbQsDJfc7d6d3C+6w9Hy2Hr5MJY7Q8Ih3rKYBNj4cXCmdQV6VHCVicMWNbCZprweghmz2lBNXbu4VqhDvlOJjR1M0FJ1cm/ubqh9Z6o5UwdYuuSKokb4xCr4ntDzId2F/9vHA1F0JtdBuw0eXK
 TBNlCTVb
 icMNfEQuMNIZ7WQUkxwO8qaU/ZdKnUchqHXt8pRQ1tBA1oejKppPqFq7Nr+5r9zATMNQ1a77Dqffz3LGCNk/MKD8tPkBiOXxLj/ZCY5EvZvzvqxtznQI2RssAOIgWVBmRNW7C+QABsRXbFbV+2yQkhlB/rhi3CSKmVaAL42zfLkBsH+ST0ZhoULCsoHeioXWeYRNEHzb2LAEbtQ/g46IQJMDD3w2EbESmT5WkizjSyIHVj57Fjf0+oIUi4yZEYrz/LmVQGTPpySiTWp3GYylPlkJOyuPvEVEa711u999KPfe7T7X0T4hTuxlq1t9bxkrJaED5U3HjIifmBRX6FGZYUqAhHnC6AHUjL8/cpFoxd4TjIzsCFBzSb3RI3c4MHoyDf/i+p27uQ/jmGQ3gBd8sK+8pb+k+8xzG5z3H7iJS7CThxV+6CgJWfCsQ5oC2UF3bsC2pXkdmPkLb+a9lo4pbI7WVGZ/iLkotFu57
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove the percpu_pvec_drained field from folio_batch, and its only use
in __folio_batch_release(): remove that now pointless lru_add_drain().

Which leaves __folio_batch_release() as an exported name for folios_put()
which is itself just a wrapper for folios_put_refs(): mm/mlock.c and
mm/folio.c don't need such a wrapper, just say folios_put_refs(,NULL).

Or should folios_put() be the export? But __folio_batch_release() is what
drivers/gpu and net/sunrpc are using: don't change them in this series.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 include/linux/folio_batch.h |  2 --
 include/linux/mm.h          | 18 ------------------
 mm/folio.c                  | 17 +++--------------
 mm/mlock.c                  |  2 +-
 4 files changed, 4 insertions(+), 35 deletions(-)

diff --git a/include/linux/folio_batch.h b/include/linux/folio_batch.h
index e1cc8ae023f1..a3337f70e109 100644
--- a/include/linux/folio_batch.h
+++ b/include/linux/folio_batch.h
@@ -27,7 +27,6 @@ struct folio;
 struct folio_batch {
 	unsigned char nr;
 	unsigned char i;
-	bool percpu_pvec_drained;
 	struct folio *folios[FOLIO_BATCH_SIZE];
 };
 
@@ -41,7 +40,6 @@ static inline void folio_batch_init(struct folio_batch *fbatch)
 {
 	fbatch->nr = 0;
 	fbatch->i = 0;
-	fbatch->percpu_pvec_drained = false;
 }
 
 static inline void folio_batch_reinit(struct folio_batch *fbatch)
diff --git a/include/linux/mm.h b/include/linux/mm.h
index dd09c438fa23..942a9d9ed5c8 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2201,24 +2201,6 @@ typedef union {
 
 void release_pages(release_pages_arg, int nr);
 
-/**
- * folios_put - Decrement the reference count on an array of folios.
- * @folios: The folios.
- *
- * Like folio_put(), but for a batch of folios.  This is more efficient
- * than writing the loop yourself as it will optimise the locks which need
- * to be taken if the folios are freed.  The folios batch is returned
- * empty and ready to be reused for another batch; there is no need to
- * reinitialise it.
- *
- * Context: May be called in process or interrupt context, but not in NMI
- * context.  May be called while holding a spinlock.
- */
-static inline void folios_put(struct folio_batch *folios)
-{
-	folios_put_refs(folios, NULL);
-}
-
 static inline void put_page(struct page *page)
 {
 	struct folio *folio = page_folio(page);
diff --git a/mm/folio.c b/mm/folio.c
index 18e97923e527..5021639c5494 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -160,7 +160,7 @@ static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
 
 	if (lruvec)
 		lruvec_unlock_irqrestore(lruvec, flags);
-	folios_put(fbatch);
+	folios_put_refs(fbatch, NULL);
 }
 
 static void __folio_batch_add_and_move(struct folio_batch __percpu *fbatch,
@@ -1043,22 +1043,11 @@ void release_pages(release_pages_arg arg, int nr)
 EXPORT_SYMBOL(release_pages);
 
 /*
- * The folios which we're about to release may be in the deferred lru-addition
- * queues.  That would prevent them from really being freed right now.  That's
- * OK from a correctness point of view but is inefficient - those folios may be
- * cache-warm and we want to give them back to the page allocator ASAP.
- *
- * So __folio_batch_release() will drain those queues here.
- * folio_batch_move_lru() calls folios_put() directly to avoid
- * mutual recursion.
+ * This used to optimize with a drain before putting: no longer helpful.
  */
 void __folio_batch_release(struct folio_batch *fbatch)
 {
-	if (!fbatch->percpu_pvec_drained) {
-		lru_add_drain();
-		fbatch->percpu_pvec_drained = true;
-	}
-	folios_put(fbatch);
+	folios_put_refs(fbatch, NULL);
 }
 EXPORT_SYMBOL(__folio_batch_release);
 
diff --git a/mm/mlock.c b/mm/mlock.c
index 1050010bbe0b..97134eff6b56 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -191,7 +191,7 @@ static void mlock_folio_batch(struct folio_batch *fbatch)
 
 	if (lruvec)
 		lruvec_unlock_irq(lruvec);
-	folios_put(fbatch);
+	folios_put_refs(fbatch, NULL);
 }
 
 void mlock_drain_local(void)
-- 
2.51.0


