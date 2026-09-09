Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C15EC79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 09:59:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A84B6B00A0; Wed,  9 Sep 2026 05:59:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 480EF6B00A3; Wed,  9 Sep 2026 05:59:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36ED16B00A4; Wed,  9 Sep 2026 05:59:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D7026B00A0
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 05:59:31 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5E17214016C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:59:30 +0000 (UTC)
X-FDA: 85193776500.10.9C5E06E
Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9BEB3120009
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:59:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MKuEW6+N;
	spf=pass (imf29.hostedemail.com: domain of hughd@google.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788947968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lcHKAya+E91RVS5tU8FF9W2nmuTVga+iF8pC6HMIeNs=;
	b=WIt3kXbMMOZzYUNjpZV1tPZmb2AJgvBlV3FHNs+BDMAZrqcIOPXJEtvvkatu8kI4IAs2Wu
	lS+DW80i9ya42TUDsHiAiM8FFr5ZHK6ghHpG8cReZlnCsz3YwM0ZK5o66+jlqVXbT1/qjC
	LCk+r4GDKfDsDwjPwU1CuOo3u3pzbpY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MKuEW6+N;
	spf=pass (imf29.hostedemail.com: domain of hughd@google.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788947968;
	b=1XOri1skgeso51dEfMGW0qO7PLLHCAmnrf+gztd8W3Dou2eFg78a87Pnjlog9yF+T/F+dn
	RAZiT74adCbmrQKEOkKcPUvftGtxDbXxlN6/YAs3ClN/PbofWse4ewgb6Ko/ZnuxSDqtvm
	j8zFIbBqWfjxlLQxqm6fd5MDOnQpzsM=
Received: by mail-yx2-f12.google.com with SMTP id 00721157ae682-85d43da99easo4467b3.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 02:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788947968; x=1789552768; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lcHKAya+E91RVS5tU8FF9W2nmuTVga+iF8pC6HMIeNs=;
        b=MKuEW6+NR7hYufZk424cSghsKrkOb61Pn0eOsEEsksruIkjyUMBlFOweHmJehTCfl8
         IFi6PQR80JZXiY63BXEbAZHpFcktceTgej4dmhaJN0yJjnWDjT8LO8LkBomVTMF9SK8+
         AdgliNf/Ew3w2nlbZt9OnwTYS4Bq95juvUWeaN4m9pHjrAyX5f9fvSRkLMW6QxUtpy38
         1/PNfWfjgVksXo59KyZbYh+CaaFvzS0yxUp3gKS4Vw3IIWJHTaIy6OgyG1IJjwYhwERK
         oULEfzm5T2alZYmfTOlX4mSP1kvi3TnH9P7ffEbZzboNIxol+ufVGpIfV+gu3XjnchHw
         WgTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788947968; x=1789552768;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lcHKAya+E91RVS5tU8FF9W2nmuTVga+iF8pC6HMIeNs=;
        b=c44ZixG5XgMhQ0tpZR3hDkKaiGK0RfkbF7KFbJwnqj+j4MSZiUVTA5ObfGgofnLM3C
         clZQNpeqcmn20tPo3HIraT9XYo3bgFb4b1/HbhhZ1Qc4IRLsT7tMmrQbs8F7G/KbB4FG
         GXqzd0krrMbeRrIGHU/pE2ezALdeGDiNt8DH1+d4MDe3UbxuU8LEBFRfkFylOUBL0i84
         YJ9Vu9hH5vJeZNd/GUSNfAOQllmBMcyVM8B2uy4+HzcWvEdirytbLKsqGLEiYCNgW6z7
         mMLFtDgsiCovkhUJ7YkWMw+kdxgtqmKQFDTwNB3g9F1X0J6qCAgYNj33eDTleT9/KnIU
         t8uQ==
X-Forwarded-Encrypted: i=1; AKwUvBz+RVgUhEwU5y+lRXYhFrUWtmzksqhm8hh3woXypGUb5sUCQBEamPXVrBqjlEB8UrPNJL0sRtXf7w==@kvack.org
X-Gm-Message-State: AFuF++nOfnlhSqIsLYPWuD8mBJ5D02ly11tJdJQxoW27vZxZEfnLD4om
	SCXUrtKKr+SVn6f/TCrSLdx57odZOWbBbB8jnVjFNUTVJLzHfi/e2mm/pXu/M9SKUA==
X-Gm-Gg: AYBFou0x3ZKrOfZJNgZKXBcociBGZgZO2OQ7geoDMbTKhB+RoMP0S0FytQEqQHGbcRQ
	DRi5FRWYDgbwXy4MrGdtUqo57fL2ulqOpSYfLnyai6Cbb8GnPutjNAyABj3ouAremghac0HKxFA
	gIazJzyyoUtRpnC5vEz1GOjXtxdPLKunQPRro01+u+ZP6rKtD6YpYIy6W0oPnejHDsVIMhDYWx1
	wsugr/xHtngovGswsZoMxLOQWDdEPLU3eimW+5ru0zZf4ksPmvFzjQ6fENTXNmxOVh09dDiyoDk
	N4bCDHl3rqGVvpaYG9NNZbWyGq+I3YSsgz2vTCHwS4gKBeA7+D7g5GWyKWHGEvKzhw08+Lrn3aA
	FzGl1zwmE3xKr7ZWyuAAAy2IMpWQ+ycactT/qjRSvWC1se+JVVCjLDcXLGQTDDZV1qC40eDPq/p
	T+xlApOU8t0XemwE7oqU6ld4UsJulY3zrQxkv2D2xEfHLqeK4BHxKEXYVXJOjxDyNQuTGJH9s68
	nBkqLbybf0gFmUmQq9FVAkeJxcVuzCK8Xu+lzq///9RNUno0zExYOFDw7fMOjr7y51Q6w==
X-Received: by 2002:a05:690c:31a:b0:87c:a15f:b667 with SMTP id 00721157ae682-88153e6779amr21037b3.19.1788947966891;
        Wed, 09 Sep 2026 02:59:26 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8714c1e1eacsm107507057b3.49.2026.09.09.02.59.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 02:59:25 -0700 (PDT)
Date: Wed, 9 Sep 2026 02:59:21 -0700 (PDT)
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
Subject: [PATCH v2 09/26] mm/fbatch: restore mlock+munlock batching, without
 extra ref
In-Reply-To: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
Message-ID: <69ba633c-8fd5-1f4b-2e1e-b9b15b8946be@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9BEB3120009
X-Stat-Signature: crp7zohffhaaexutnaxddf1p6w6mrxcj
X-Rspam-User: 
X-HE-Tag: 1788947968-720329
X-HE-Meta: U2FsdGVkX1+LbLN01WRJu2nOxBricXDzgNd+qwNzFw6nKtnX3XZDq3fPhcQukv9IDPGZG9kpldfrAM3mUYherijKQUTdoD0QwqfPgJ/xOOoi6VEYX1FXLh43fMzfdQyRIK6zEFdjd5YyJd6AR7j5fzhRWpNjB5YqTH1nxJNzBrfi2NWAhniISNSjHa0chP3BHdRE96W7wN9lGUlb9Vr1doY4Bz5vD1H/itaiLewlMo93M2tG0JAMtehG4vtDpZu7V2vtJYOgV2cYmNriDVRrdap6iEVA/s2XZMnKidjopniYmeEQ+CUaNpDh5MHHa1qIMG5idAm491T5S63wOeEO0K6DIDGI4zxsJHBtjOcO3Y7h7k3PQu4phh0GQ736VI0K5lWD5znzt5/+WI139vvFxi2kEPhxqDkNSHkWTZ6kKKKwT3Xh/DYR2QHPxNObx5uD8F15DJw9aJhktEXr18KmxSb/LVwJdw6NoqiMsGM6SaiEWvisTZBfg6K8Zop0WFAn/IWAx7xdouk0VHSSTg6+5mxcDyIx0r092chOBWqd9VDFqo0y7aYh03Q8MgnNkyUjk6d9JpQwXSngR9qDa4EcrZUFVLytT2W2867l0KlWvQNrMiJwe3McuOBLNldso+Q0YzpIh5bBYeNMsdcmM2/tsg3Aln5aSTu8sZJbExzzeCkRV9LZPI/Dm5LTC8NlCpsSWvAMJ/W5JUDTxP7gYhsL6/o/5oGqJTOKL0vVWEeOFuecq7MOvXUX/G9BqofOOYbkp3RYRfbpp2ao8SyUzSqZjbAjRPuFYvHT6bk/WAWnrdKXipIwjNZCAzTtXSXunAjdGB3y+pucGAeEwPFuB2ekZ/vrn7kIUa+ZrmBTvLv6QmUgG6mr/63dXErK+z4RXo2ghADYqqUjgl4TBraGOroS8cPtS79/2gKI9m/ums6e/cogxJRVDFVqAO3PNQOT+ov8Zz0ejBxsNMZWWMJcK+m
 PKxcMJvN
 m7kI6LmnX0wSGnQRuMSbuovUBUrF1w5CHxol7Euv2Cxco37abJMXx8vB6sUw9mnlkfMfAKkrMI0Fn1wtVhoDKsW9uYbI86POuogBIh1MGFKuLncCewPRXjOLPDxmPANS3dWf7KPLpWmwTNsUAr8awpSzAEQGGnnyLhptuByEi5rtDRw3zCCJVh2mVDFA3ANaR7EAIDk3X+HNRkTbY84rtw4Pf7JShyvu7Gg750TwuGWr2GIz0EkaS0ukCLK0oJb/jBnJs7MQWHCHOFsP9STGTouldZFbKK5WXULX99b4Szgip5PoPXRPktoazWjWEdQ2Nmy0woGDggYBlZrGRDD7uyV+FOsF2E2VQ4b5Xfz5Tcvj5quY1mQZQYRHP3NWGFBiiD7d59eV/wFyyzi7Z8+QdoaYlUtg2DVcPzo+rwaWB/dmh8rM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update mlock_folio(), munlock_folio() and their fbatch callouts and
helpers, to do folio_try_get()s at batch processing time, instead of
holding a folio reference all the while in mlock_fbatch: as in folio.c.

But more interesting is the use of mod_mlock_count(), using try_cmpxchg()
to update folio->mlock_count safely when possible (now when on lru_add
fbatch as well as when unevictable). While __mlock_folio() is as hard to
think about as before, __munlock_folio() simpler because munlock_folio()
can adjust mlock_count itself without clear_lru() or lruvec lock, and so
do the folio_test_clear_mlocked() immediately for itself (without which
unevictable_pgs_cleared was likely to appear high, when it should be 0
or low to indicate good mlock health).

__munlock_folio() is safe for use even when the unreferenced folio has
been freed and reused. It appears that __mlock_folio() could affect a
folio which has been freed and reused, but only if it is reused as an
mlocked folio, in which case its mlock_count is spuriously incremented
(but usually a spurious munlock decrement will follow).  How grave is
this? If unevictable_pgs_cleared remains low, not so bad.

I've gone back and forth on whether to move mlock_fbatch and these
functions into mm/folio.c: for now they stay here in mm/mlock.c.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/mlock.c | 147 +++++++++++++++++++++++++++++++----------------------
 1 file changed, 86 insertions(+), 61 deletions(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index 2c690f18031e..1050010bbe0b 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -58,6 +58,20 @@ EXPORT_SYMBOL(can_do_mlock);
  * indicate the unevictable state.
  */
 
+static long mod_mlock_count(struct folio *folio, long incdec)
+{
+	long mlock_count = READ_ONCE(folio->mlock_count);
+
+	while (mlock_count & MLOCK_COUNT_0) {
+		if (mlock_count + incdec < MLOCK_COUNT_0)
+			return MLOCK_COUNT_0;
+		if (try_cmpxchg(&folio->mlock_count, &mlock_count,
+				mlock_count + incdec))
+			return mlock_count + incdec;
+	}
+	return 0;
+}
+
 static struct lruvec *__mlock_folio(struct folio *folio, struct lruvec *lruvec)
 {
 	/* There is nothing more we can do while it's off LRU */
@@ -65,6 +79,7 @@ static struct lruvec *__mlock_folio(struct folio *folio, struct lruvec *lruvec)
 		return lruvec;
 
 	lruvec = folio_lruvec_relock_irq(folio, lruvec);
+	lruvec_del_folio(lruvec, folio);
 
 	if (unlikely(folio_evictable(folio))) {
 		/*
@@ -73,92 +88,82 @@ static struct lruvec *__mlock_folio(struct folio *folio, struct lruvec *lruvec)
 		 * folio be unevictable?  I'm not sure, but move it now if so.
 		 */
 		if (folio_test_unevictable(folio)) {
-			lruvec_del_folio(lruvec, folio);
 			folio_clear_unevictable(folio);
-			lruvec_add_folio(lruvec, folio);
-
 			__count_vm_events(UNEVICTABLE_PGRESCUED,
 					  folio_nr_pages(folio));
 		}
 		goto out;
 	}
 
+	/*
+	 * Something to keep in mind when studying the arithmetic here:
+	 * we only come to __mlock_folio() when mlock_folio() could not
+	 * mod_mlock_count() itself; but by the time this is processed,
+	 * the folio may have already been munlocked, or another mlock
+	 * already marked it as unevictable and so mod_mlock_countable.
+	 * And don't forget that a folio may be unevictable for reasons
+	 * other than mlocked (hence the folio_evictable() check above).
+	 */
+
 	if (folio_test_unevictable(folio)) {
 		if (folio_test_mlocked(folio))
-			folio->mlock_count += MLOCK_COUNT_1;
+			mod_mlock_count(folio, MLOCK_COUNT_1);
 		goto out;
 	}
 
-	lruvec_del_folio(lruvec, folio);
 	folio_clear_active(folio);
 	folio_set_unevictable(folio);
-	folio->mlock_count = MLOCK_COUNT_0;
-	if (folio_test_mlocked(folio))
-		folio->mlock_count += MLOCK_COUNT_1;
-	lruvec_add_folio(lruvec, folio);
 	__count_vm_events(UNEVICTABLE_PGCULLED, folio_nr_pages(folio));
+
+	if (!folio_test_mlocked(folio))
+		folio->mlock_count = MLOCK_COUNT_0;
+	else if (!mod_mlock_count(folio, MLOCK_COUNT_1))
+		folio->mlock_count = MLOCK_COUNT_0 + MLOCK_COUNT_1;
 out:
+	lruvec_add_folio(lruvec, folio);
 	folio_set_lru(folio);
 	return lruvec;
 }
 
 static struct lruvec *__munlock_folio(struct folio *folio, struct lruvec *lruvec)
 {
-	int nr_pages = folio_nr_pages(folio);
-	bool isolated = false;
+	long nr_pages = folio_nr_pages(folio);
 
-	if (!folio_test_clear_lru(folio))
-		goto munlock;
-
-	isolated = true;
-	lruvec = folio_lruvec_relock_irq(folio, lruvec);
-
-	if (folio_test_unevictable(folio)) {
-		/* Then mlock_count is maintained, but might undercount */
-		if (folio->mlock_count > MLOCK_COUNT_0)
-			folio->mlock_count -= MLOCK_COUNT_1;
-		if (folio->mlock_count > MLOCK_COUNT_0)
-			goto out;
-	}
-	/* else assume that was the last mlock: reclaim will fix it if not */
-
-munlock:
-	if (folio_test_clear_mlocked(folio)) {
-		zone_stat_mod_folio(folio, NR_MLOCK, -nr_pages);
-		if (isolated || !folio_test_unevictable(folio))
-			__count_vm_events(UNEVICTABLE_PGMUNLOCKED, nr_pages);
-		else
+	/* There is nothing more we can do while it's off LRU */
+	if (!folio_test_clear_lru(folio)) {
+		if (folio_test_unevictable(folio) && folio_evictable(folio))
 			__count_vm_events(UNEVICTABLE_PGSTRANDED, nr_pages);
+		/* But whoever puts it back on LRU should rescue it */
+		return lruvec;
 	}
 
-	/* folio_evictable() has to be checked *after* clearing Mlocked */
-	if (isolated && folio_test_unevictable(folio) && folio_evictable(folio)) {
-		lruvec_del_folio(lruvec, folio);
+	lruvec = folio_lruvec_relock_irq(folio, lruvec);
+	lruvec_del_folio(lruvec, folio);
+
+	if (folio_test_unevictable(folio) && folio_evictable(folio)) {
 		folio_clear_unevictable(folio);
-		lruvec_add_folio(lruvec, folio);
 		__count_vm_events(UNEVICTABLE_PGRESCUED, nr_pages);
 	}
-out:
-	if (isolated)
-		folio_set_lru(folio);
+
+	lruvec_add_folio(lruvec, folio);
+	folio_set_lru(folio);
 	return lruvec;
 }
 
 /*
- * Flags held in the low bits of a struct folio pointer on the mlock_fbatch.
+ * Flag held in the low bits of a struct folio pointer on the mlock_fbatch.
  */
-#define LRU_FOLIO 0x1
-static inline struct folio *mlock_lru(struct folio *folio)
+#define MLOCK_FLAG 0x1
+static inline struct folio *mlock_flagged(struct folio *folio)
 {
-	return (struct folio *)((unsigned long)folio + LRU_FOLIO);
+	return (struct folio *)((unsigned long)folio + MLOCK_FLAG);
 }
 
 /*
  * mlock_folio_batch() is derived from folio_batch_move_lru(): perhaps that can
  * make use of such folio pointer flags in future, but for now just keep it for
- * mlock.  We could use three separate folio batches instead, but one feels
- * better (munlocking a full folio batch does not need to drain mlocking folio
- * batches first).
+ * mlock.  We could use separate folio batches instead, but one feels better
+ * (munlocking a full folio batch does not need to drain mlocking batch first).
  */
 static void mlock_folio_batch(struct folio_batch *fbatch)
 {
@@ -169,10 +174,15 @@ static void mlock_folio_batch(struct folio_batch *fbatch)
 
 	for (i = 0; i < folio_batch_count(fbatch); i++) {
 		folio = fbatch->folios[i];
-		mlock = (unsigned long)folio & LRU_FOLIO;
+		mlock = (unsigned long)folio & MLOCK_FLAG;
 		folio = (struct folio *)((unsigned long)folio - mlock);
 		fbatch->folios[i] = folio;
 
+		if (!folio_try_get(folio)) {
+			fbatch->folios[i] = NULL;
+			continue;
+		}
+
 		if (mlock)
 			lruvec = __mlock_folio(folio, lruvec);
 		else
@@ -218,19 +228,25 @@ void mlock_folio(struct folio *folio)
 {
 	struct folio_batch *fbatch;
 
-	local_lock(&mlock_fbatch.lock);
-	fbatch = this_cpu_ptr(&mlock_fbatch.fbatch);
-
 	if (!folio_test_set_mlocked(folio)) {
-		int nr_pages = folio_nr_pages(folio);
+		long nr_pages = folio_nr_pages(folio);
 
 		zone_stat_mod_folio(folio, NR_MLOCK, nr_pages);
-		__count_vm_events(UNEVICTABLE_PGMLOCKED, nr_pages);
+		count_vm_events(UNEVICTABLE_PGMLOCKED, nr_pages);
 	}
 
-	folio_get(folio);
-	if (!folio_batch_add(fbatch, mlock_lru(folio)) ||
-	    true || /* XXX Temporarily disable mlock batching */
+	/*
+	 * No more to do if mlock_count is maintained: either the folio
+	 * is on an lru_add fbatch, and will be moved to unevictable in
+	 * due course, or it's already counted as unevictable: no need
+	 * for an mlock_fbatch entry below.
+	 */
+	if (mod_mlock_count(folio, MLOCK_COUNT_1))
+		return;
+
+	local_lock(&mlock_fbatch.lock);
+	fbatch = this_cpu_ptr(&mlock_fbatch.fbatch);
+	if (!folio_batch_add(fbatch, mlock_flagged(folio)) ||
 	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
 	local_unlock(&mlock_fbatch.lock);
@@ -244,15 +260,24 @@ void munlock_folio(struct folio *folio)
 {
 	struct folio_batch *fbatch;
 
+	/*
+	 * No more to do if mlock_count is maintained and still raised.
+	 * But if mlock_count is unmaintained, we might need to queue an
+	 * munlock fbatch entry, just to cancel an undequeued mlock entry?
+	 */
+	if (mod_mlock_count(folio, -MLOCK_COUNT_1) > MLOCK_COUNT_0)
+		return;
+
+	if (folio_test_clear_mlocked(folio)) {
+		long nr_pages = folio_nr_pages(folio);
+
+		zone_stat_mod_folio(folio, NR_MLOCK, -nr_pages);
+		count_vm_events(UNEVICTABLE_PGMUNLOCKED, nr_pages);
+	}
+
 	local_lock(&mlock_fbatch.lock);
 	fbatch = this_cpu_ptr(&mlock_fbatch.fbatch);
-	/*
-	 * folio_test_clear_mlocked(folio) must be left to __munlock_folio(),
-	 * which will check whether the folio is multiply mlocked.
-	 */
-	folio_get(folio);
 	if (!folio_batch_add(fbatch, folio) ||
-	    true || /* XXX Temporarily disable munlock batching */
 	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
 	local_unlock(&mlock_fbatch.lock);
-- 
2.51.0


