Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7BACC79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 09:44:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B97D6B009D; Wed,  9 Sep 2026 05:44:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2918B6B009E; Wed,  9 Sep 2026 05:44:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 182166B009F; Wed,  9 Sep 2026 05:44:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D75E26B009D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 05:44:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A7E151C0819
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:44:43 +0000 (UTC)
X-FDA: 85193739246.15.4EBCEF6
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id C63B9180005
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:44:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tY8OL6y2;
	spf=pass (imf16.hostedemail.com: domain of hughd@google.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788947081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l/77qcoGASc/bcotpYpu7s8Toxgxo4GzXR5d/4rRuxI=;
	b=xeUBWBKTOkHc1J0xz48QC4dtpmtUV5WDZRx+dvxLWIX1UuDcUGqiqvi4Tq0sHtQ+T/qXTC
	YUK48WaKwtxyfZJQQpcMIYNV8h5HqJcUN8ZuiFZVhAnwufi42Xjm9Ejz6oZ7OIKgxWPLhY
	GHU/WJmSrsKo8vpoONG4SMQTqi+nRyg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tY8OL6y2;
	spf=pass (imf16.hostedemail.com: domain of hughd@google.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788947081;
	b=A3fzK0qqGoEcp2+8nZT6AJVTW8/hHnkULsdY+NzGrUXHHEnpvor/2YkzzbJUXhLWku/16U
	aAlIJWKQ+MboXfCFS91RMO0dmtzu+mtcBbnr02zwA4VRFaUJCZJVfKGPiwj2+Y5Qt6cNTw
	kDafBcfMlcgH8GmrrWcm+tjbBPfyYF8=
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-86162c086f8so53598767b3.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 02:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788947081; x=1789551881; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l/77qcoGASc/bcotpYpu7s8Toxgxo4GzXR5d/4rRuxI=;
        b=tY8OL6y2qsYWo1zjGaHwT2i9bnNppBRhr4ODSrWKxIPoGhykGNccmILt/7VBxz5C7H
         D+9OGYu9o/Jc+vScMguwZiV3pv72tBGsYhTVqELokvDzpZghqcVrV2TkohAzJRCi4tRe
         odSG/u4gdkCe7r6P6h9ZObV3g5olJQfe9BFfqshpr+2We1xf1HtNnYsh8dItlnEdE+4p
         gpEepp0eH4ZeJtJH8b/cebRhWjnyRs7NKD6uH3oRQdJN5AKadmlVSfYcyCpaMn8869QO
         pV67UfOZ+MJ/Q7S+ot6s5u1RKpAUYZ1UvvLnpQnSuqVSrcSngUcOOUPoNZTCPdTe0cLf
         3fZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788947081; x=1789551881;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l/77qcoGASc/bcotpYpu7s8Toxgxo4GzXR5d/4rRuxI=;
        b=nSY3TZrfpvKKtiKRy2ulUbKh69N8exdp3dN0lxDeMaYO3cGuYNc9PDKyw/7A0yQk+m
         LmttPJC3YbCMwAhhYjE5N/3BmzlUfzLwqwOH4kZx/JTH7+GDSXML+oVhyWJfZ6yFHoVF
         TnfQ15+fJHj7drIWHXz2sWV1nEFTVqJKwhD5uU42o2mODofYzqZSbQ7yMQ6S8kTobYqY
         MoUOUAggVVkZxPWNCcg1WGs9pvdFFvq1SP5ufSJ0KRDpsx2pScJ19A5KBf9dNag1oxcg
         bXrzlmWRLBhdX7lV8s8HxOhj7GQL6CjoRqLH271fAVk3DiUlc1LDqt5SS3Ml7NR/HrQs
         CJsg==
X-Forwarded-Encrypted: i=1; AKwUvBxEzEPArQpkc/2wXdf2qGrIRbrSN+mxuPZDGq7Oet1ky2WGAbzDOR6aXOYnTv2VV9/tt6f0o5H7xA==@kvack.org
X-Gm-Message-State: AFuF++nuYy5xpwaCuDITLXc9S6/VvRZ/lFywv4Q8aO9WF4UfXs3saS6K
	12/knB3Y/TskI1D/MSKeUrEf/V3bRTsdYeQ5pcUg6UJZGA6r2/+/b2jevsJpKT7tZQ==
X-Gm-Gg: AYBFou21P+MlmQgfnmFWbN1aBLD+bpgqm3ChlEC6uL8DAscbrngSSqjPs6BAS0B6q4r
	ttqWkMdA5fSGkxZ3ELlvJLZH9qRQXgeWsgRRHx16ZJHqjIbtaxue6DeWJZGBkysxqrThyeXICBR
	dw+DlgTJJ2JCV0xnGdrJmRx/7lRNOWjEPAdsUKz4SBuyO8NzRxHRTOmlagQEpsJGGiwE1CwZJnO
	VOieAc5goHBt/9x0yKaSVfnqVNSct4QBuwiR4uKjqJSPPPEQWuq5Cvc9cAGlMzHduFh3NCAZNw1
	raTgyQz7pTNDwRAl2Jz0i8mwRtZder9hdh/Bi9T2eAZ5mz87ex1w7aovyoPVH9pQRyaj6K5inZ5
	7wr6B9wQFo6sLlnWOgsn0p36ysAfR/0eZCgVtWxr8Lxfd3Err+2n94jSEzNesM0N/1tSMKvCggS
	0hMK4pGulTbWvjmer2Ah/a7C+pU554oUmaj7FJ9LuNWvcoyXw6VOWWOTCW+FVQwT7XhFqu/a9Ze
	E6U0XPAxIdEKhnfLBUVjbOPANv9s/IiV45sVXALsk/G8DbBL64ZlJ4O5zY0
X-Received: by 2002:a05:690c:a84:b0:7f0:38f7:6ca6 with SMTP id 00721157ae682-86e6d7905ccmr129247067b3.5.1788947079991;
        Wed, 09 Sep 2026 02:44:39 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-873194f76e3sm92930227b3.5.2026.09.09.02.44.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 02:44:39 -0700 (PDT)
Date: Wed, 9 Sep 2026 02:44:34 -0700 (PDT)
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
Subject: [PATCH v2 02/26] mm/fbatch: allow folios_put_refs() to skip
 xa_is_value() entries
In-Reply-To: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
Message-ID: <c441176c-33b7-c8f8-fb7f-51774e1fd853@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C63B9180005
X-Stat-Signature: gk735na5upx5mwkucziysisiij8y95kt
X-Rspam-User: 
X-HE-Tag: 1788947081-348390
X-HE-Meta: U2FsdGVkX1+tY7g/8L7mMiFExSSZCG3U76rD3BeJU1OxK72MWhvbwRmXB1Wb6XotpSfdeHdb0/m/Fq1U7xwZebmm4qqWnqd1OaSuBrL+WQBfY6MF5m/A2fsfxC1V71n1WlzH7sCupQUTmvjt1xVHfyrXO+2F4y3b2khinqBp//bRZ+hkwz/76E7maUMa9M8CI/QqbsDbI918ygeoH5k8ntgFvFHVfYaXhoSS/s0834Wpd50ZJ2lQ3VujFms3cjpZmM5YCI6URnO2vxhCALTNiP9d7Pz4WK1FyoWHMjpYD+dPt12uVVVtXUbSmYBEbixBs/AmEaIqCbm7CpqbLwpxatuMdiin/ShewOkNyJAvgMcwWiKiJh2rwtFU19lVwFHb5Vw0taKVEMucG/+obPYNbdZYOugmUcqwsdQaJvBxQ7d9/S5GCALO8GxjbMdrosHrerAFbO6EppC+7kn/Gb5S5ydz0/PNFSCkRQMGX+ZmUpP5YK0WSwUAebl6lij4S0EIsHOU30cczwoJJQp6zWqwTA3t0AEED2ckGjgPVA+OOVvJKfak04JlBeaJ0hLpTloL6LIBM7Rnw9JCKswp+J5m/PF2/9Kb1kvcxoREpw5/aGwlWJz/dbHWKxKhjyzJu42tIf59ItwsIXVeNpWv2YpYhWX4v1LF9cTKhgBJsqIygks8wUdkp/65lUoHvLHk6q7vH1jX63r0xBk2mUgCk0PrI9dwz8zsf3CgxXTL9+9/9utTRhzTXahRQOpd67HZQ5IDP3Tt7JsPhvGwoH5YXYH8xXdLGKzHOfKyCHgx4/QyHeZek+Qxb+pDTIEoFEk+gjG18YasLuokQ2ZWJG++LrgBDL32R2kgl4jMhxOWkPuAPB/ETEqE3zzzepgIzmvfL9HPTz5hPKq6bk4XmX5+KInxT7rOyy8eYtQz6+G7F9kPlF/BF48Hrp8tHAfAMfn/sQS0X9t/JWcusvObADXGeO0
 hlXsnt3m
 wjzrJL+TK7oqswp/cwqfSLGUDI6sPsYm59JUzlKxpByGZ5AZk4YSnf7725YLGvvmH28RKv0+sNGKWRXPni1RVvsadyFKLBDVQuxZZPVKR1j0LbQg+5+Lph2KqE06uJqlV6TJbV73Nv8iVxn4apsmJwKLPmOC7STZ9Zdji/85kwu8ZCLCmd/GJSRQwjATB48Gj2akmw1lN2j9EHUOtQoAEBhpTBq0yVnzX73qFmOOVJ7PdpPJEE94uKZKvtG7btMGURWoFNQXUaF8/A1D7Xib9YUwTuCLfc0wM/EP6qJoZ7UCPKhUIUU751ojTS6rJpJo+zE/HKyPoRDfiEdgTdtnHo2KjDPc60AeL8tj718o8lPGm1JNbXISsAaFkx+X5QutVmEwHML8dpjw3SUhWqgJgC2MKXdHy0Bim6NIokUp8p2daYEP+NPxwuH7nqPd/bVAiKPWGt0f+XHgyr62/j1z2x0QwKUPwXrPcgHfGvZ2Ax1MDlcXlQjX31+wyDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let folios_put_refs() (hence folio_batch_release()) skip xa_is_value()
entries, and therefore remove unneeded folio_batch_remove_exceptionals().

It made some sense when introduced in 3.1 for shmem swap entries only,
but workingset shadows popularized exceptional entries in 3.15, and it's
silly for so many sites to be squashing exceptionals out of the fbatch,
merely to suit an inadequacy in folios_put_refs().

But remove exceptionals on leaving truncate_folio_batch_exceptionals(),
one of whose callers then passes the fbatch on to others less tolerant.

No longer essential to this series, since 7.2 commit 9669b87065a6
("mm/lruvec: preemptively free dead folios during lru_add drain")
allowed folios_put_refs() to skip NULLs; but still an improvement.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-By: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 include/linux/folio_batch.h |  5 +----
 mm/folio.c                  | 25 ++++---------------------
 mm/shmem.c                  |  2 --
 mm/truncate.c               | 16 ++++++++++------
 4 files changed, 15 insertions(+), 33 deletions(-)

diff --git a/include/linux/folio_batch.h b/include/linux/folio_batch.h
index b45946adc50b..e1cc8ae023f1 100644
--- a/include/linux/folio_batch.h
+++ b/include/linux/folio_batch.h
@@ -22,8 +22,7 @@ struct folio;
  * The folio_batch is used to amortise the cost of retrieving and
  * operating on a set of folios.  The order of folios in the batch may be
  * significant (eg delete_from_page_cache_batch()).  Some users of the
- * folio_batch store "exceptional" entries in it which can be removed
- * by calling folio_batch_remove_exceptionals().
+ * folio_batch store "exceptional" (xa_is_value) entries in it too.
  */
 struct folio_batch {
 	unsigned char nr;
@@ -100,6 +99,4 @@ static inline void folio_batch_release(struct folio_batch *fbatch)
 	if (folio_batch_count(fbatch))
 		__folio_batch_release(fbatch);
 }
-
-void folio_batch_remove_exceptionals(struct folio_batch *fbatch);
 #endif /* _LINUX_FOLIO_BATCH_H */
diff --git a/mm/folio.c b/mm/folio.c
index c093ca900a3e..ad6c64a4c22c 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -964,6 +964,10 @@ void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
 		if (!folio)
 			continue;
 
+		/* Skip any "exceptional" (workingset or shmem swap) entry. */
+		if (xa_is_value(folio))
+			continue;
+
 		if (is_huge_zero_folio(folio))
 			continue;
 
@@ -1069,27 +1073,6 @@ void __folio_batch_release(struct folio_batch *fbatch)
 }
 EXPORT_SYMBOL(__folio_batch_release);
 
-/**
- * folio_batch_remove_exceptionals() - Prune non-folios from a batch.
- * @fbatch: The batch to prune
- *
- * find_get_entries() fills a batch with both folios and shadow/swap/DAX
- * entries.  This function prunes all the non-folio entries from @fbatch
- * without leaving holes, so that it can be passed on to folio-only batch
- * operations.
- */
-void folio_batch_remove_exceptionals(struct folio_batch *fbatch)
-{
-	unsigned int i, j;
-
-	for (i = 0, j = 0; i < folio_batch_count(fbatch); i++) {
-		struct folio *folio = fbatch->folios[i];
-		if (!xa_is_value(folio))
-			fbatch->folios[j++] = folio;
-	}
-	fbatch->nr = j;
-}
-
 #ifdef CONFIG_MEMCG
 static void lruvec_reparent_lru(struct lruvec *child_lruvec,
 				struct lruvec *parent_lruvec,
diff --git a/mm/shmem.c b/mm/shmem.c
index 897fa2b61346..1f2809adec54 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1157,7 +1157,6 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 				truncate_inode_folio(mapping, folio);
 			folio_unlock(folio);
 		}
-		folio_batch_remove_exceptionals(&fbatch);
 		folio_batch_release(&fbatch);
 		cond_resched();
 	}
@@ -1277,7 +1276,6 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 			}
 			folio_unlock(folio);
 		}
-		folio_batch_remove_exceptionals(&fbatch);
 		folio_batch_release(&fbatch);
 	}
 
diff --git a/mm/truncate.c b/mm/truncate.c
index b58ba940be47..4151f7a167e3 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -53,7 +53,7 @@ static void clear_shadow_entries(struct address_space *mapping,
 /*
  * Unconditionally remove exceptional entries. Usually called from truncate
  * path. Note that the folio_batch may be altered by this function by removing
- * exceptional entries similar to what folio_batch_remove_exceptionals() does.
+ * exceptional entries.
  * Please note that indices[] has entries in ascending order as guaranteed by
  * either find_get_entries() or find_lock_entries().
  */
@@ -95,7 +95,7 @@ static void truncate_folio_batch_exceptionals(struct address_space *mapping,
 				dax_delete_mapping_entry(mapping, indices[i]);
 			}
 		}
-		goto out;
+		goto squash;
 	}
 
 	xas_set(&xas, indices[j]);
@@ -113,8 +113,14 @@ static void truncate_folio_batch_exceptionals(struct address_space *mapping,
 	if (mapping_shrinkable(mapping))
 		inode_lru_list_add(mapping->host);
 	spin_unlock(&mapping->host->i_lock);
-out:
-	folio_batch_remove_exceptionals(fbatch);
+
+squash:
+	for (i = j + 1; i < nr; i++) {
+		folio = fbatch->folios[i];
+		if (!xa_is_value(folio))
+			fbatch->folios[j++] = folio;
+	}
+	fbatch->nr = j;
 }
 
 /**
@@ -575,7 +581,6 @@ unsigned long mapping_try_invalidate(struct address_space *mapping,
 		if (xa_has_values)
 			clear_shadow_entries(mapping, indices[0], indices[nr-1]);
 
-		folio_batch_remove_exceptionals(&fbatch);
 		folio_batch_release(&fbatch);
 		cond_resched();
 	}
@@ -732,7 +737,6 @@ int invalidate_inode_pages2_range(struct address_space *mapping,
 		if (xa_has_values)
 			clear_shadow_entries(mapping, indices[0], indices[nr-1]);
 
-		folio_batch_remove_exceptionals(&fbatch);
 		folio_batch_release(&fbatch);
 		cond_resched();
 	}
-- 
2.51.0


