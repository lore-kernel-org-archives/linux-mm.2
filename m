Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15E59C61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 03:54:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11E366B008A; Tue,  1 Sep 2026 23:54:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F5EC6B008C; Tue,  1 Sep 2026 23:54:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F27016B0092; Tue,  1 Sep 2026 23:54:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D10646B008A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:54:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 428DF1606E6
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 03:54:54 +0000 (UTC)
X-FDA: 85167456108.15.B2D53BE
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7981340005
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 03:54:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="T/i/Mr4C";
	spf=pass (imf17.hostedemail.com: domain of hughd@google.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788321292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y3C3YFkFN20q0dqMhyWIalQhIX+NjYlCT3NZSRQXbv0=;
	b=ZtrJl/R0yuJadzam5LI3JJHQMcAmUXxrI/fSzreb6POFXPgr+RJ1Zg/+6QB9NVtyLrx2An
	Ec4gogtPdyuAIRNVK6TKW0uXvwawq9LTb6KyJ1X921SjFZTEk8TRG6Ix/Li5PKxKHbFeug
	3JNktQoDYhvF3vck07NH4O7eu//P7kQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788321292;
	b=Ym2cWEVMNsl7JtoExZuavYKPhG26oB02LA1CL7/JMaLj9IIlK2XUwYZbSCmdaDfEDH59n0
	HRh1BUYHYedpLNUR+ioGr9UDuYfSA6vIykmJbV8MXsId26NHnRq8hvZbw7nlKS5JFxJiET
	mMzATWA1QG9NZBz25BGi/j8ErZl1sYc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="T/i/Mr4C";
	spf=pass (imf17.hostedemail.com: domain of hughd@google.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-85a50f6a7f7so9292147b3.2
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 20:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788321291; x=1788926091; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y3C3YFkFN20q0dqMhyWIalQhIX+NjYlCT3NZSRQXbv0=;
        b=T/i/Mr4Cs3PiIRbAazJzxzNY6xSMf8+uvKkmjwbNSZHqgB6CK/ATnlJwlNjaVhc4Fd
         jJ/jjcgrLSHUx88oneaeSV9yEFA6wOQJMbtcR4U5xOPGDynjnvsRxLX9RlIuIBwvyOCW
         D2P62E7qiG48CUQbukSu4v67pFEQgHQEYvVTd3Ct8Tt2Rb+cp41x1krSP4RqhU80T1nS
         UtV6Dm8IVvMzGQ8ocERfDQDLbwQmrGWw9xCH8m/maxM3Ag0LRyPENcVlUmk9kqmgkIlf
         Nfce/ISOhng52vixkpMG/+gKdVGxiCS84hcT4iy2c+AWh5dq5OL/WANACUl8PoKfT6pS
         1UuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788321291; x=1788926091;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y3C3YFkFN20q0dqMhyWIalQhIX+NjYlCT3NZSRQXbv0=;
        b=PI6n+3QosQVHWkNJiKaCb3KpLp5u46+kXnKl958cMoA5kBE+2n+toqrM2KC8bUayoR
         6aKdL2JzSqRS7dEKilBumKD/H62SPPAVXRWszP3Twnm89KqqxhCAkPyaz5imaBHkHMvQ
         WdeJ3SeX8mkP2ig2rs+unFwl05daXu/6Tji6Rehos13FzX4hOmViaoTWUJU5WLWq5bDF
         7nVzG62RcMUm3Eyoq0jiYenbNc/+UU0W8MFGouZ7NUY01Wju8MUSiUOE2+3mWYhRp3ks
         am7tDAhpLc8qAqcGKol+St247deItUfnpu1UUEQUUx7c46l75b1I4mTxIAh6U3Sucrhc
         UNeg==
X-Forwarded-Encrypted: i=1; AKwUvBzC4x8JxxPQPigojJNSJmREwo7px+1nkyZiKBIQoA1indx068qByLPtZGE3sd5i8ks/gnHuRRwb7Q==@kvack.org
X-Gm-Message-State: AFuF++kjJtjBfHY97QeE+CQNsRwtalr0T085rkOrqw02DvgM8o9LWEE8
	fT/OKG/Ec2uPXmPDkimYACxxLmlQhSIlXEwkR2pI9baltyUKxLbB1THZ7zWPkibEtA==
X-Gm-Gg: AYBFou2gJk5mMb4wp/GPXuY3/o3FuZHtf26X/SXfNMyyi1zBQvJK7HJmGP5neBYqdVJ
	WhFi+AYYvq8BZb/BI7qEGfkq1kkB8I1ODHlQqRbSu/8kJIc5sWfx4LHQ8QqECrfm+b5RTBMita+
	IGFOpZwWsIVC8NoN5gArgHqbg9cUgo9ekO34NsfPRHmjPW5xc0eUiK1E/q4ejCg5jqPQqMSJFc5
	Q1Gs54aemq4KGh6E6Ep/NHIRSFVwY5Un/xyPHOKqiwvKg3DrdVZIIBA4vtECADMoPX6+E7mmTRG
	22rOUy00rH1+nxKxcRY5gh0npvVF5CMElXhWD8u0cZ8oKR5A37XA5Qm7POV7/V2poUSOekFZU0k
	CtD0sb02KYqdcC6ZzWOu2YoF4+OO+nREJcR66r99U89D68KL+190bKj9LzujgKbuD8e1PD2zoks
	wzGhajtEtJa7INa/LL5tZ7LWS3yOOBgjcKyBZyDTE2w2NgF4NWXjNWwLnXi0HjJdg6U2oUJXRR2
	cg/dQ6CRMljUfewy1910efnYf0lu2IDNmyhIWysJPNiGsdp
X-Received: by 2002:a05:690e:264e:b0:66f:92a7:1b28 with SMTP id 956f58d0204a3-66f9bfd8205mr445722d50.49.1788321290911;
        Tue, 01 Sep 2026 20:54:50 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66f985611casm1051256d50.8.2026.09.01.20.54.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 20:54:49 -0700 (PDT)
Date: Tue, 1 Sep 2026 20:54:33 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
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
Subject: [PATCH 26/25] mm/fbatch: drop reference inside the loop when
 draining
In-Reply-To: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
Message-ID: <6d24ca2c-d535-cbdf-dab1-97046a3914ce@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: fnr8fdp6zom4pk6imxf78agtxnrjx1r4
X-Rspamd-Queue-Id: 7981340005
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788321292-249003
X-HE-Meta: U2FsdGVkX1+iZZN61R5vrHRWu4aylWkc2YVwoYunzR9+hhqgGv/oJ/OHJUJJuPiZ2Ws5AoI+JSmP9PmtJee6QApf59hZCCA0vluHXkw3mRKDAJehTm/ayTkJ2wyYWShSIJWVMKGIRTmJPJj5nVW0k3Qdk3MY7F7kq0GaJCVlaRBFdla6mFo4vB2TbzKskDVm4OqAgnb6J8lsqW9fltYmKVymFRz5wPf+UP97lCVUu6uxKjg5HxSOF3/D9afps+fn/gQ3G1qQ0rEvyzjNhpWnCi+XxRhp38SkqE5iB50GAIMtM4CgMXOS/DDwxnLrqaMOjJjUz/7A77mqTrUDFPJ6EyoTIO+eaLnB3/MqR4q9GJ8pX/VqhsjsQcHh2bZdpD4Qk1aGcZ9+5BuVMWxxL1BGUU928ApfuBj9UCNpWSYRUOCEJ5sTx3vzXUCbyQsTM/s2MMBYmuie7KJnzBL+kg2HRoTCluNmZzwjfM3Hax2mH+Uf6auJjqtl2f75hbl60reQVkD+ye8P82q1LZ5mzlqTo929dxVEGNJ4JdQmACuZA2dvkCjiOCr1iLW0o8Q+yGOhXdPG4iVFxTpOU00xsP8xPKQcwdRcfqluXBmAXtUKV1glfhEaAnr9qU99a+Q7WhIPdsQvERPRByz4fGcAheUtmtN65LfLX/uFFgJmcvhnZyCh/6z1BU23H9kA1THlKleOtFlozj+mHnh0gUgMnv3DaOBvDzmNmINyhs3Obm+lIfMlka1lF43moVX2kGLDzpDUXdbWVAS9+hszFQ+g+RaOX8MKBQnVNuzeBFULN5b9BZEOAb/590G+f922zko+SWxApbhWTI61pQQdLUUnsCOVmXOP8D27NGolvLVTlxrxzOwL2piD7lcj/0kwhCU1HEE4dejZdv4bqxp7M8Ruq1e8MIKSgF19fc5ZZyc6BBXp01aVyOEkD5lKCLOa4X8ybgf49FVSHE8R6cglzQszcP/
 OzdPoHKy
 /FMLKgCSV5s6eiP7gji6bfZN7KKz+a4Kr6ODmyftwH+fJRCaMP68H3Qt/BfqBKjbU7uNw7lQNJRL2wZjePwqvrqwpV6Y5SLxaOcCcdNJfdA+fFxhGMg7q313SAjNIlkvsC1bBiOfPvHY9DIEHEYm7SmvDcSVuVMjjo7pNPXEvrAefbrlj3W7aI2v9a3kRS3d2I9HI4MPDYdpjGscmr28X70+8Yd38oxz7AWqWhBipQXvOpx5lQMhCupUv7Pyr1IbmhbA4g1Q+CvRgZ4ddCH1R8G8AzRZhnPkyTDdE5k5UgPo9ZS2/RC1iRZu3Io8APIoQiAWeZrVkdGeAr9Ylztch3jKMan3IrecHy7zYpWE2sCuq2Y7k4/gP9HGiHuUrcglx4qPNPpZ2hLkbYaQWfUB1eRX2G5JIugol0l33Mz/JuReTrRemTylyU4jiYqhkYfOTEvlwb74im3QaKkU=
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
I shall have to rebase the series, but this is an important
afterthought which is best added into the review now.

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


