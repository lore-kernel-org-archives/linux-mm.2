Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E58B9C79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:38:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7B386B009D; Wed,  9 Sep 2026 06:38:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D52BE6B00A0; Wed,  9 Sep 2026 06:38:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C479B6B00A1; Wed,  9 Sep 2026 06:38:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8EC5D6B009D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:38:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7C37A14016F
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:38:04 +0000 (UTC)
X-FDA: 85193873688.18.17825D1
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf29.hostedemail.com (Postfix) with ESMTP id A31EB120008
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:38:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="B/Sz0hAK";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of hughd@google.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788950282;
	b=WHqHODnrkV14d2iB2JKwKDh5IELCxG6fPPOBXKgSwm5PdnJPSkqk3pPnefW19RSZWLn6AT
	7ClKCKsOeAa2z+DDdL6ICYTH9VVYyo3pUDbdJHAF996b4v3b/F1BBlK6N6EyPPxbu5oMuj
	Pa7ZsVoq9e4B0NrSykqZTPApgFK919k=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="B/Sz0hAK";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of hughd@google.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788950282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ubgJuILilCUv+JDm5jbfScMjR0I7p8athUKDiI1DXU4=;
	b=qaw1np12YTbgYu3QWP6H3B1CiKyTzNxESJL1AfxUCXkun4C/g59/M1afTsvbegvcfD0BlR
	jx0RhfxmN9fdbPeCLS/IXoOzzKDUkTHVSYlOa5dAlQetr7BjMTDd0ceO4SlZPCUVpRUNJU
	IwUC2mhetgjSkZxPuUE36NPpySzbLhI=
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-66fdf2a9aacso3725253d50.0
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 03:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788950282; x=1789555082; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ubgJuILilCUv+JDm5jbfScMjR0I7p8athUKDiI1DXU4=;
        b=B/Sz0hAKuVYn3O6Iw+jwEDHyFh/Jt4RwFtwBGQt29nx7n/5RPl64ntFLcyNCoS7PAx
         X7wznDh0PMik8ZKZivJHfuxqchGhjkrViBOTogluoIkqH9TLDQUhgJI15C7OJRp2QgmK
         sHKG0ED+IAV258JcILpgX/ZaCFmiUUsFF60DhCGX5243zComEI1CvK853jWkN96S3+yX
         h5YMV525PLiKqUXWKakWVmyfMg1EqZ7RtB6t/OFiEXebyFvPILPrgkHlPtb0t9v5dNqF
         2x9j+YryO6yJFQ8oq+LHI4/TbgWV+Blt4Bzah1A6y2/lP/JQ1Msx3Eqwky0f4eJhe61G
         KfWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788950282; x=1789555082;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ubgJuILilCUv+JDm5jbfScMjR0I7p8athUKDiI1DXU4=;
        b=eKv4FaqwFEr163Lfq+MTKktc9p/jcwxMG1pwMayBBIVbB3sxik+u+Jelq2fDnLE/yJ
         WtXzaHYV6dCoJl9aoCkpi5Ey3d8epC4TOfx2t25qE1Qidx+D6W2/+0ffLoAV4I76pSS3
         sudcxBYhH++659sjFABNRXnUyuUwmx+OX6LGljJ64tDARAVCqTy5bMruN5UWNrSt3tb/
         P5LBf0uw4j66wsFtkN2iiKvrxXSuJNp3RQw2Rz0xyq0n5i5sWxEPGxgvO6U4EytcUSey
         hHlZB66IuoKPWNkP8fe4gkCJ1Z2Z6nZcKDrBpfBR5xqYY14B9SB8Qj7Ai4kSQRLvLfso
         ZTwQ==
X-Forwarded-Encrypted: i=1; AKwUvBxwue5wGutvdRnDwX1lZ5GXbmemTtwwwdo3prBXXTy/cdqC1HD/DO3ZCa316eiMGQkZBO5jmjDDdg==@kvack.org
X-Gm-Message-State: AFuF++mup3X11Chyz5RY5ifOfYic/9qiOGsPRD94gkLb6RGWnTSC7R6d
	BsGUw4oQTR3D1hYNaeugOqFBY7EY6MPCMMYblOv33TLydzkgWj3fyd5byZeJ1COfiQ==
X-Gm-Gg: AYBFou16MCAOMEjeMyWP9aXVR3K9yGxZ8ItKPstCFftECq4wVslO433JFnU5UXb34c/
	rA3dn+84zoIWvT2mZcRuMMvGW8iYzbOHk5euv/8vCvtRYHHYBNEhnQOXQYZXxkFaDDhEWDONm2k
	qtOGELPfMeKGQUQbVyj9g6EPLQQpUz1py1O6eIBxHFZiJAH6QVX9nZ1d5ng7jn3S/Pc10vg8c5c
	Kth6Xqen6fPBz5O/S+aYh1jENSSU+qaJfKpC3CF5ryX6FpJ/+IAG+7ISkwDMcQ2P1V1hTeYOn3i
	NfSK33YCZ1yANalznk0gK/LRwkoSbD7pZaZG+78xPYJXRiYdR410gnXmFtviQ+f6ePvP0zoD+z0
	f8rxSZt67Tv3JiyNprv+l16WtuXsupM0U8rncQs2dz8CEBnRDW53aIPW4ouXJDIhr6a6bb233dF
	BJv3pVeR2tGKyM3aaJ85lq2QD6YdSkm0u46sjdv6Fi74Xq82weHF6rVYtjbXB/+ExEoDatryOCV
	jYYkXBWRNoXtVKCgbIhF8rV/JwslpWrm6rqAo2RSuWtWdQDM+bQ5g==
X-Received: by 2002:a53:a6c1:0:b0:66f:79dd:19b4 with SMTP id 956f58d0204a3-66fb5a81fd0mr8721653d50.33.1788950280907;
        Wed, 09 Sep 2026 03:38:00 -0700 (PDT)
Received: from [192.168.1.242] (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66fb49763bfsm12116197d50.19.2026.09.09.03.37.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 03:37:59 -0700 (PDT)
Date: Wed, 9 Sep 2026 03:37:55 -0700 (PDT)
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
Subject: [PATCH v2 26/26] mm/fbatch: drop reference inside the loop when
 draining
In-Reply-To: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
Message-ID: <5af5eb5a-2a18-268f-d86b-5dd079a748be@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A31EB120008
X-Stat-Signature: fdjr1zdf5b78hunk87eoqp9wdmdhebgp
X-HE-Tag: 1788950282-91994
X-HE-Meta: U2FsdGVkX1/K/YLM2BnRvolD5AKH91pOk9v7A5ZrqFOdAgc+Z/dyr568ywVqREWl4D02Jt4pTNAjQnYJjzdMjGiE0QpcZ2WJz+nfEaopb5AYuKYylQOljUeMCeLXoNpf30CQmJPNtR4yIIpW6zFQudnOlgz10pWwljeGvJa3V3w2b9Ui+aI3tg1wYHM8oOXiSsRu1EN8Xvm7KjGYGzTXZ/YdV1SJm4SO+BLS3eGwJt1c72v9pU9inQm6b44lQG7fTSTpf4LD/K3OHT1An4zXYzeaGiBBiZMBoRB5X3NqvbqtdyQdZm2bnjX9iKa5IzodNAJJpfqfSAGg0D4Z6lSB8ZQQMqKfUbJ+JdA3W+kX4B0pra6w7J79frUGnUpMmvrx64zBP9vNAJMswwb3BKVDp6TBcNP2ZvZexvncxM9N2aalMhax0nHyIGHvqk4E0cpu9783aWZjkd7BfIg2xc1o3y8/zGZKi1Nyxu+mTOeh2QW3vL2FrfWsvrj8E5ms/HvY7r+BYmRa1nkD3Bmwd3F9l5cWdaxsiyoyjwCpasxQxEPrmTDdAiWypBMs5HgcZN44B2LOhTrIxcCtexn5l+CowSpE4eGs6FHXu2e0i07jJC+RfzCuiJT6oQuLzFDJWGdbGK0Wmn8k59mE5USvGeQP1f5SSdOQeH4Wo0X7yiC9hO+zasdqBFw6ZVPLoVE+gx2ReJEfj2x0sNSLwosJPztgztVPBMQkrOGiyHzHNZXYLANww9TIn3zdxdgeRtDJr+NPyGI4g7Y+c4IJ9e1FTQZwKycAUeg/ff1+e4Z7QxKRdDO9fgb+xolrHcax2+Y+x2Q7Wwf5jZe1K2kTq4H3MaRf2ZTx5q5YaSuzA8IMdFr3O84UjiiprzuDKWAgUhyYHG+FpmS4iD2c4J7zEqryB3C+UpyRZbRlq8iACa9cP6mJSqCsvs5cyt2ZK0Ojc5Wf2Pb75rbb4cKPhGNxY5kKRaH
 KVvEk4VD
 J2VvEawFoCBPDt02vwEQE2z1sL3/MqLZQMiMfoW+yoRicSgAr7PFklKMDSc1wsP6kzS1y7dNNZA6Wg8lpLN13kVEmnPqRDt9jKyEhTCaCdiS2Y0N9BkztRaeRVWnKpkEFEvRKc01LfVGIqFLDRw/1pKuSizBXyitRV20xvzLlcD4PLr/pfB4AzbZStZax/QyNGpRkilyRNNZibD6/ZySUCF4NH1ELKWxGjOJVM31YqHKdS+zS0XtGjlMNEsHuWv65sBa9X9oZkS63YSmgvt2Pnz7vENAX6pqCGr2sKps4i1U7oayVFbBYYK4vxfqLBqLWykNGBcO7HpkZaPb0+l2gjwvDDhHXgJBSSPgeO0MhpbKJUPysxB5i5W+cSvkX7vxvhPhSL/qtJc/GHK4PikMoog9JpKIG2KjixXndcqZcKz/0uNbs9ksAIrv/im/xQ9GgySqJNLOz10/wqEY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_batch_move_lru() and mlock_folio_batch() used folios_put_refs()
after their loop: but that's counter-productive, to batch up dropping
all the references acquired within the loop. Now folio_put_testzero()
inside the loop, where we also already hold (bar races) the right lock
to remove the folio from its lruvec.

This should be much friendlier to compaction, in the common case when
the folio is still in use, to bring it back to expected refs sooner; but
I suspect that when the folio is freed, compaction won't accept it until
it gets to be PageBuddy later on?

Respect the comment in mm/vmscan.c move_folios_to_lru(): could be done
differently, but it's not worth optimizing the case when we cleared lru,
since it also has to handle the case when we failed to clear it.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/folio.c | 23 +++++++++++++++++------
 mm/mlock.c | 27 +++++++++++++++++++++------
 2 files changed, 38 insertions(+), 12 deletions(-)

diff --git a/mm/folio.c b/mm/folio.c
index 55ca799a9dcd..7c545e4c090d 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -128,20 +128,18 @@ static void lru_add(struct lruvec *lruvec, struct folio *folio)
 
 static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
 {
-	int i;
+	int i, j = 0;
 	struct lruvec *lruvec = NULL;
 	unsigned long flags = 0;
 
 	for (i = 0; i < folio_batch_count(fbatch); i++) {
 		struct folio *folio = fbatch->folios[i];
 
-		if (!folio_try_get(folio)) {
-			fbatch->folios[i] = NULL;
+		if (!folio_try_get(folio))
 			continue;
-		}
 
 		if (!folio_test_clear_lru(folio))
-			continue;
+			goto restored_lru;
 
 		/* Do not add to LRU if it has already been added */
 		if (move_fn == lru_add && !lru_add_del_folio(folio))
@@ -155,11 +153,24 @@ static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
 			lruvec_add_folio(lruvec, folio);
 restore_lru:
 		folio_set_lru(folio);
+		/* See mm/vmscan.c move_folios_to_lru() comment on ordering */
+restored_lru:
+		if (unlikely(folio_put_testzero(folio))) {
+			folio_unqueue_deferred_split(folio);
+			__page_cache_release(folio, &lruvec, &flags);
+			fbatch->folios[j++] = folio;
+		}
 	}
 
 	if (lruvec)
 		lruvec_unlock_irqrestore(lruvec, flags);
-	folios_put_refs(fbatch, NULL);
+	if (unlikely(j)) {
+		fbatch->nr = j;
+		mem_cgroup_uncharge_folios(fbatch);
+		free_unref_folios(fbatch);
+	} else {
+		folio_batch_reinit(fbatch);
+	}
 }
 
 static void __folio_batch_add_and_move(struct folio_batch __percpu *fbatch,
diff --git a/mm/mlock.c b/mm/mlock.c
index a3cfdb274fc7..c528cf7135bf 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -27,6 +27,7 @@
 #include <linux/secretmem.h>
 
 #include "internal.h"
+#include "page_alloc.h"
 
 struct mlock_fbatch {
 	local_lock_t lock;
@@ -170,28 +171,42 @@ static void mlock_folio_batch(struct folio_batch *fbatch)
 	struct lruvec *lruvec = NULL;
 	unsigned long mlock;
 	struct folio *folio;
-	int i;
+	int i, j = 0;
 
 	for (i = 0; i < folio_batch_count(fbatch); i++) {
 		folio = fbatch->folios[i];
 		mlock = (unsigned long)folio & MLOCK_FLAG;
 		folio = (struct folio *)((unsigned long)folio - mlock);
-		fbatch->folios[i] = folio;
 
-		if (!folio_try_get(folio)) {
-			fbatch->folios[i] = NULL;
+		if (!folio_try_get(folio))
 			continue;
-		}
 
 		if (mlock)
 			lruvec = __mlock_folio(folio, lruvec);
 		else
 			lruvec = __munlock_folio(folio, lruvec);
+
+		if (unlikely(folio_put_testzero(folio))) {
+			folio_unqueue_deferred_split(folio);
+			/* __page_cache_release() without irqflags */
+			if (folio_test_lru(folio)) {
+				lruvec = folio_lruvec_relock_irq(folio, lruvec);
+				lruvec_del_folio(lruvec, folio);
+				__folio_clear_lru_flags(folio);
+			}
+			fbatch->folios[j++] = folio;
+		}
 	}
 
 	if (lruvec)
 		lruvec_unlock_irq(lruvec);
-	folios_put_refs(fbatch, NULL);
+	if (unlikely(j)) {
+		fbatch->nr = j;
+		mem_cgroup_uncharge_folios(fbatch);
+		free_unref_folios(fbatch);
+	} else {
+		folio_batch_reinit(fbatch);
+	}
 }
 
 void mlock_drain_local(void)
-- 
2.51.0


