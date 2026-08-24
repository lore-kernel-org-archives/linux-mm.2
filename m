Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFD6FC5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 13:55:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAAB36B00A2; Mon, 24 Aug 2026 09:55:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A83056B00A3; Mon, 24 Aug 2026 09:55:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 998D86B00A4; Mon, 24 Aug 2026 09:55:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6428C6B00A2
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:55:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E6F421A014D
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:55:28 +0000 (UTC)
X-FDA: 85136310336.15.57A03F2
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf07.hostedemail.com (Postfix) with ESMTP id 171D140005
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:55:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HiygY0rU;
	spf=pass (imf07.hostedemail.com: domain of hughd@google.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787579727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kV9CvWZgKJ3OzoIjmFQaCybgDiXpPYv7ZoBPddJ/7AM=;
	b=yuzLxfCeUgGdoaZiaORDxSIZWN0YZFog9YfZSp2UhFLr2OUkNB2SzsSHm7eGtbgFPTLzZN
	tEBmVW242MY5ShCGc4PFB2BcflBsbY60D6FnqyuUP61DtzH4Btn3BE0iF2AOos/nVBrMQG
	qjFgKQQ8IQ/O9cMLM2z7Cp62JpNyY0w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787579727;
	b=KPtw+3jj3TSYn/grAJznUwuhhzFaHZTi2v8uD2zlFOsJTPkiWcbJ6N1ceqMdpfbO0ZgOXM
	kON0DJc0vaRE425RRMt/qMFDFNr4bNJkEIXa0Ryuvbeau3oskqSkQ8EsY6SI62JLj/EkmT
	8GbOAR73+exfnB48h2ui29Xcut7m/9Y=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HiygY0rU;
	spf=pass (imf07.hostedemail.com: domain of hughd@google.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-836c4474028so40356927b3.0
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 06:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787579726; x=1788184526; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kV9CvWZgKJ3OzoIjmFQaCybgDiXpPYv7ZoBPddJ/7AM=;
        b=HiygY0rU00aW9ciON0LG8eahlmmRmtQMA/2AzFwSPTB2Iu3wZtqJZ2XNgSu4Jc71e3
         bAMUSn1r4TAporoRM4wwYgw49Xn/7MFQVPCvjRyyQ/NCURaOQ375l7u1Y9ApFYoLshyE
         emF/tQjkEXD++WYLuVAskJF5ScA1QWBlBSt1kDJPQkdx5gmoZcoC513dlp8UqwpQ4Yut
         G1EWO5xCszZbbpXNCWgLKlTqPYKsyWZqI1OS6EzvjCeX/ThGOFMAlTxhD5JxNTb2fVoQ
         JQQDPfVmmeK4g2fX37P3LCIsJteu/67tmShFLl9foxNWFv1ZLAT9qUfic0PhePBRU+01
         tuTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787579726; x=1788184526;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kV9CvWZgKJ3OzoIjmFQaCybgDiXpPYv7ZoBPddJ/7AM=;
        b=IjeXcBdD5V2yUhtuTwOb/gJurDHoBXPHBDIIVtYm4ihWygY9TWVqZRHS+9scAIox3+
         7ax7Fl448fW4k/hO7BZo2UQWe4Vo/0k8mXxiTjgFLAEy1V0Cq1WbAOehcJhPheIlTZN+
         9B7hvJcmA3IYjwy16OPSkCCE7vpfMJr3lptT1rZVRYqqJbnfHL0r44y56EaviyCj9m0w
         BOjz2lucj5Ld0yLuo4AYYzWalE103tTEBBKAGksjJy8pb8+lIUOz7NQdlHCVuadstEoV
         xiDse9zVMs3r15GVRWrqEOO2he8Den29Wzo4o4459nNge8vXOjLWwEI4fjMw+tj/gsp3
         JGIw==
X-Forwarded-Encrypted: i=1; AHgh+RohEqBTE1VPc3PNuBEXZX5GLKWPF7ada3uRov5ibP+zUe2R6Vd5YQEg/c+wtmhW2Zp9XomExi2KDg==@kvack.org
X-Gm-Message-State: AFuF++kd9EptJkm6qzVefoVcWXN3Zg+8+GoEXIEQjYQMac3TLk/AZ/Ei
	D/kIFfS1BzpSBpVwR09sLt6E4ihlczP7+C/+aKCOI/npnWoEw8b0ahzOctaEpF8rJg==
X-Gm-Gg: AR+sD11t9cFISvwa5NQhyDol6rTXFPy4q1QlrOogWeXZqYvIg/nSAQIiHqlUP1YReLz
	1cH/SD+xdjC7xPDkAu8Q+YPZGCzn1k3z56N8UPVWEeavr1yybDDCcicZ2YCgQZojJVBqYkql/eX
	FgDU0+ykK7Eb1NluCt1od2efofQFXvAwlVEEFzc2wqAzDXO//w/XLVeXPGnj/O27uCaPqznODbE
	+QITn5gCm9wd/lKlF++Oo9KlvHoh0fU7sDqyYiaJXsoUhbgI6wy6nFgn2y8/wSe3GwM5XCBeO+y
	XeL1pv75BBJhWCrx3nLG3pQ4ZPTNFp3oCY7+gN6u7A54LE7p05elLoydOYZUlTK+9nfpMkk5R5A
	aI6pf48VtMdcvaTOVwZ/NBsZfvs9RIdVfN3uYTXb9HO8WiN3Fmpsyq1h3QQMhgWduuShlh3QcE+
	fhm35C3H6ptcnhVR+drQcUbK0VOfsIrqinZX2TFMHck7dQZ3mS0ttPKzfrfZAEeWws/IJ0zBQP/
	rOLwJCyk1nbxXVPOBjUFrtAB84wcvSBgtxs2d4dWkSj/pR3pjgV54bzYbSZ
X-Received: by 2002:a05:690c:e3e5:b0:844:7e98:fe01 with SMTP id 00721157ae682-849f18a8409mr92007567b3.5.1787579725434;
        Mon, 24 Aug 2026 06:55:25 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-853ff053a0esm3017297b3.0.2026.08.24.06.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 06:55:23 -0700 (PDT)
Date: Mon, 24 Aug 2026 06:55:18 -0700 (PDT)
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
    Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
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
Subject: [PATCH 02/25] mm/fbatch: allow folios_put_refs() to skip xa_is_value()
 entries
In-Reply-To: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
Message-ID: <44c7773e-5806-d24a-83c9-f39b3a134138@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Stat-Signature: 9kh37jmhr8j7m5x4yy94hh8dqskrfjge
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 171D140005
X-HE-Tag: 1787579726-761348
X-HE-Meta: U2FsdGVkX18uUQaspmJKBbxRknypRhUwxaFsnxwoPzld9YUGegn3ISU93IusoMnNU6z43Y9Lu8UsUT6K7Bf9ZpdJJN4LJUjDwfC/CM83ZFE5Orfq8wZ+1mUCK3heJUKp9HIW0x3MBjzY21zEa2MFJJz7IPzrdCztRhJYRPMnajYYR8m7GkJBPOm+/eArVXi6GPaf8d6VkVcevCxWtVWTJDl+4t3Yq0Q7M56H1ezD2Kha3/LjW3XKMm9API5pgKoDyX5TJE32NZLpUJxFnmDn5SkMnvMHeW6P24YMBKGfpcywwyo/3RpByZkbipV+rFZzWG/x+86Hw66wKwVhjau1LIw5Jhey0jXxAacSQuzq7lci0xB/CL6D/PLjo8VxNf0lph4/6Ek0HAbaIVa8Reuux0exCkcyE/90gc44bvFdlrckwU9p5SpVLmXZa/WdnWXx1p/klCPvoGXod5zZhge0eYY2fPM36VLrFK8PR2JMj1qbQB/UYJlV6WkJU0VPBhxmJqFsRFKHWQlR/z1QgzN/iFaJATjz6NZJU6VTnJbl7GroPFQ4gGsILJYMN0R8BWYTwbhWKW7uM7At1YdacWlo+E70mD8uqnzZZId9AFuqtO9Cb4MOwGmnSn8/eEnf81bEMOC5/qnRMpPHekRxringIzPnmbHbf6tJq7/NR1xmPPhzwqWDKPcce2nqajd2amTLr05/pAc1SI+ho6q6oiwf9EYmwtJEyfUzR80/lVpfESjfeymK0dcMB+DhuUlnXcB4SitlOCVE9ehIKFzdPE0djKNFoWD+DriMjU2F7C17bGl86GwpnIJOo/BDyNbvqOyIq3/30MGxRtLam330gaRz7JwlT55XIhCXKzaBv5VdfsGLso+sx18StNflf3lLIx+vg2COB/3quFuc5asbnKvVPpGakgVXuOoSGi9iDx+ZSt3Huwwbl9vKDpO+k6OjMqKK4j+LiFkN1nv9Hoe4uPu
 M3cWYZcA
 i7L3aLEYeGlI44UD8hwC+0JxwSZLujVfrnsOoShAeP+7LxSGVR4Sg4sKu27DJzvje4a+bDepC+PrQUJ/ud6dYtbIHXV+dWM0RHPCDQZU2zQA5pcoES5HIZ8JXtOlXhz5JvfNLWMledfPVk9RZEIX4o8Kfg62G39E8c+M0+hnjI3ziIS+MDT3Hkc02j2fDRGgjoP75M8XzuyIhTymD2dWWK+jdnZ00ckd2xycedF9mlmzI4w1dGypm2OtuMX2GPOa4Ena+K6oMAKt+XPfTBXSRPW4h/DRVtI7/Z91F+FwYrfTHCI4EcBlpQOToje/9If5cYGUTQc5GwynSxjrfEazF35Mh4nc7VUh3bfEOFmv8LihCQc7MfCvy4rcHhmMKhKzE4GVGrBBCKB1rRLyvRRxVfgmbA3jKA5PIxLper/4ogyt5RX7OL+iANl9of8thkpL6FL0EbwN+68VT9ak308JiIptUBxpx9bc8TuBb3OJBQYrvheOyCFWTPV9qRV72XFZPyu59
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
index 62b96c9ce19e..b2bce6b77498 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -983,6 +983,10 @@ void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
 		if (!folio)
 			continue;
 
+		/* Skip any "exceptional" (workingset or shmem swap) entry. */
+		if (xa_is_value(folio))
+			continue;
+
 		if (is_huge_zero_folio(folio))
 			continue;
 
@@ -1088,27 +1092,6 @@ void __folio_batch_release(struct folio_batch *fbatch)
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
index 89a1495e55f7..3911721e1e55 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1156,7 +1156,6 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 				truncate_inode_folio(mapping, folio);
 			folio_unlock(folio);
 		}
-		folio_batch_remove_exceptionals(&fbatch);
 		folio_batch_release(&fbatch);
 		cond_resched();
 	}
@@ -1276,7 +1275,6 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
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


