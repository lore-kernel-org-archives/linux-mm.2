Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C05C9CAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 09:17:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 293C88E0019; Tue, 23 Sep 2025 05:17:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 244E68E0001; Tue, 23 Sep 2025 05:17:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10BE08E0019; Tue, 23 Sep 2025 05:17:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EC6C68E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 05:17:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8A0D986D2D
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 09:17:15 +0000 (UTC)
X-FDA: 83919961230.29.D5DCD87
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id A9DBD180007
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 09:17:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Hlj5ENzb;
	spf=pass (imf06.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758619033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BMEpf3Ea3B6J3gmDiquYNV20PPyPPv+3X/VUa2fqYkk=;
	b=kU0ls5uwPtQf592zHEtjUGqNqPWmkdoYtW2Zysvp/LJGsXPpAKaMTQaWLAV1zsRb3CvZTt
	BZAVPKF/VkXyiWuPL9B9v3Pqy0droz9b2X9gkA0eQNKMcBfpSGvznEildxUt559vJgR4J2
	bDadtoj/tns/4381eZzCLcu1qboGZw0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758619033; a=rsa-sha256;
	cv=none;
	b=f+W4F88f2OOoH2s5fNiZMQ5wDIunkYJ/yfgHXT4IVqbg4+JoOOalMeabmrURwjOOyJHxqW
	dIC6pDh5M21a4Stmaq/2koe/KZw/uaLCm0ZdIqh89+GzBfqdTYll7SjaMRaaDPJ/qrfWoA
	0INLuTmr0QVnFdvB/q7jHA5PBW25T78=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Hlj5ENzb;
	spf=pass (imf06.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-77f169d8153so3016350b3a.3
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 02:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758619032; x=1759223832; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BMEpf3Ea3B6J3gmDiquYNV20PPyPPv+3X/VUa2fqYkk=;
        b=Hlj5ENzbgxyZmcIE2gfMj1cXfMWkjBipJbLUTJLWd+u9pfDIOfbzIHvxTVksU686Px
         KT34w0H2fKuOFVOz071ekSqcDpRRPDAlcEr4RZ2Kle61ZUf176Jb9rLz3qx28UIP8r+J
         OOfCGqo2db9ioP8tDwMNA7h6UiU999ZBXpakclPbZe5dbM7yM9xvtQPHaWVIV+cmgpVm
         MDAc9+a8gOAbPZ5CmZgKymyOk6aCcn/jFK/IQ5xWI/pE9fJDJcSCopR8beCyPc238aMI
         hC2qM0PtZuODk8qacyBz5Fd6CwXsKQQhOWsFACt98O/1yCxqit6vGetA7oHoWVlsUrdn
         diUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758619032; x=1759223832;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BMEpf3Ea3B6J3gmDiquYNV20PPyPPv+3X/VUa2fqYkk=;
        b=pmKG/ODeMt8ZfAbgIcY9T4MHuJnnnTKZVilKodwV9k9wBJdHzu139bk++xCB0DEY2h
         CXsF3Wm2Qh2raIDIqOTwDTsws+KQEL0xR23SIwCP+EC2Beo7H38BNgFpOOo3zOq45Ilo
         Xw/twvnlW/h0OTn7jaV97gFkB+ZR4sBZjPIM39oWAY76Rvg7nUrOZ0NR6+NVdFgVsbn+
         2OSFd2cV4CcPriRHOkEokW3+XrUu6+QzgIZNiytAHCx3RKNbHZmCiEzLmtVAp5pohrZ+
         pJmlAUFWtlN8v9jqiqGi+djW91wjbC+5TsLsbQf0+DCfqZ+Oa7Suw8Zy3icys27YaBDG
         7v3Q==
X-Gm-Message-State: AOJu0YxwE0PjkgYKQ1NNeeEjStTzuUf9EN/J5Mo4gDovuQ+ln0DtK86f
	ocCK8DUVbf8tmmkiUfbrneoMzipo2bM4GLZC7VmYBHRAHpqUZ2SOIS55OSCHyB571Vs=
X-Gm-Gg: ASbGncsiW5DS3Ev7dexoMcm0YizOg9ISXxC4ga9OOzfuvFAUoH9W1SqhRMxRXybx7BX
	S4G9b72S6tchgzccMETgdBpxogEOc0TWs8CgZcub10RsT22WUId7CMCO76Ycq5nzWttd9RpYd/e
	y1KE/oZZM3xZ0Rn3lzsfMCYs1fax+TBF1KySL1PcPwF3KaQUIClESQSJYD0lAsyDkfE7l3+4l6m
	FDTQa+qcrC6PzkjXHQ0SH/qIiLRjAI5ABnd+QgHVUSu2C9jSGKnK/2v4OnqC37Ti+rpnfRgJ9SI
	gia1hCiR4PzFdD8giWubDEocKLFAC2WoOdj8Wtz2yit45RChtv1jrttBhRHCMhw+W+T7IZfRvVm
	/8P5Ds9puTjkEAXgXV2PCnnTC8m258HUOi5QPhww7AW4BIj8A3W6xNWNDOqjw4wCTZ6ZA620=
X-Google-Smtp-Source: AGHT+IEjW7nlqMYtk1SjNV/LLbiGjcZcRqySo0SKeu4Hh2+wqVdplupwS9kqc4xr8VvvoRI+XMKetw==
X-Received: by 2002:a17:902:ce01:b0:250:6d0e:1e40 with SMTP id d9443c01a7336-27cc1380e40mr22109715ad.7.1758619032483;
        Tue, 23 Sep 2025 02:17:12 -0700 (PDT)
Received: from G7HT0H2MK4.bytedance.net ([63.216.146.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32ed26a9993sm18724713a91.11.2025.09.23.02.17.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 23 Sep 2025 02:17:11 -0700 (PDT)
From: Qi Zheng <zhengqi.arch@bytedance.com>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 3/4] mm: thp: use folio_batch to handle THP splitting in deferred_split_scan()
Date: Tue, 23 Sep 2025 17:16:24 +0800
Message-ID: <782da2d3eca63d9bf152c58c6733c4e16b06b740.1758618527.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1758618527.git.zhengqi.arch@bytedance.com>
References: <cover.1758618527.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A9DBD180007
X-Stat-Signature: ti1n6m8se7dydra779c5yeky93s678j7
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758619033-686525
X-HE-Meta: U2FsdGVkX19zpbrUOZzMz8XtXvnn3CjkcorICrB6fXIXnW1uzk0zWE+SkfNrUsdVCIuKeHb9US4fQR7+NO+Qxe1me/K7G3CMrpYBzChJHBRuUk5e0QHdJjAQTNJfJHY8sxAxaV2eUS0Li+RMWliwLPbH5hU4316jL/psts52FlGen4lvY0efeieJBHCiIfJAMsuKhyAhq5yvdXDGyDd2baTZSQbH3lWC3lRQDxNIQMgGHHzBPAphD+mscLYWyvXi5i4aoI00NNUvyBoa9JYZgyfMLzJaD/fAL5q94+RXMfmi1Qnh/SGtzyxkgH0QmqVFK5X5tmew/0gmMUK9brr/06swWK3EHfxypQ1ItT7Z+fM5LyclUYvZDESq9v4frh7sU/YjM1jF/ECu5CAwfF1mYbSsH1jSLqhKmU2nu6eX2sMiehr6VLyiQusrPISYWtCyQEyAGW/ZZ3QL6EpggXI+kP1Jezf/jGJGgOLfdnT5Mp3CbxNu/C6itxunSpHCMRHspmevWT8zMvd6eAqMJGfjFIz9qfm4Baj3vO9WIayfWPQXiw2dxUcsETcRRcLkZlYw15gLeL2Hpdgd00ykkUZSYAWZb4zQb8XbLjIiZyLAXNdBA2KIet8XMTt9IgW7P4MdBUVXv0PW6f0dwNPUloX+Mblmh8ea0TfDvqxiw24NfTO64rFsWLRNCDHDgLgO+1wprTcdBcrEUsuwodirNJBWhv+VF+Ra3CqIF3P/TQnp39GO+fA9IdnT+i4AbOeoN8sACF42vB9vwwkwoPPk3rldkR5LMuUwcZsNzH0AX1asHWxEFdJfeW2OrdDECiCeo1B2gir6B27GtYPvo3u4/AbJCUFMJz9VMbPjvDj2hC0loZpQq3xKlrztg+CSeeqM4/19pzoze5MpHqX/EudtuuiADKZD2+5F7EGZomTud5RFwMk12Rv7GR7SmpUZKE0DEw2YUuqsvNm9SDo3mqkoQeI
 S3Y2QPhw
 0G4+ekPACjlI5CZcyjVCq1s4yT0oOl3EjcUKoFFesWfj0or3Y4P4Qa66alwOofMEt1qrv2mRLcoVoGfY6CR/n0o/cmwQBZqnEQ8FSQuUkf9o+U8nur3GQ4jE3bPS6Z3cK/8EEwwUAg7PDVjJXLJVWKH3p4lPz+i5WI3LvRa98Gy2iHVrQH3TUat60Vn9T0n1Rd2ZuTwgqUdDE7bS3k65otJQ2xykmqcTxobuD34FHaJej6R4jRjawLJtoAGNMTnHk+k1Ty4j7GAirHpBVSJWRN23o5yIdV1y199Q5l1daE4YycNmqXuK8gHR/rr+9bF+5kwd3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

The maintenance of the folio->_deferred_list is intricate because it's
reused in a local list.

Here are some peculiarities:

   1) When a folio is removed from its split queue and added to a local
      on-stack list in deferred_split_scan(), the ->split_queue_len isn't
      updated, leading to an inconsistency between it and the actual
      number of folios in the split queue.

   2) When the folio is split via split_folio() later, it's removed from
      the local list while holding the split queue lock. At this time,
      this lock protects the local list, not the split queue.

   3) To handle the race condition with a third-party freeing or migrating
      the preceding folio, we must ensure there's always one safe (with
      raised refcount) folio before by delaying its folio_put(). More
      details can be found in commit e66f3185fa04 ("mm/thp: fix deferred
      split queue not partially_mapped"). It's rather tricky.

We can use the folio_batch infrastructure to handle this clearly. In this
case, ->split_queue_len will be consistent with the real number of folios
in the split queue. If list_empty(&folio->_deferred_list) returns false,
it's clear the folio must be in its split queue (not in a local list
anymore).

In the future, we will reparent LRU folios during memcg offline to
eliminate dying memory cgroups, which requires reparenting the split queue
to its parent first. So this patch prepares for using
folio_split_queue_lock_irqsave() as the memcg may change then.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/huge_memory.c | 84 ++++++++++++++++++++++--------------------------
 1 file changed, 38 insertions(+), 46 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2f41b8f0d4871..48b51e6230a67 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3781,21 +3781,22 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		struct lruvec *lruvec;
 		int expected_refs;
 
-		if (folio_order(folio) > 1 &&
-		    !list_empty(&folio->_deferred_list)) {
-			ds_queue->split_queue_len--;
+		if (folio_order(folio) > 1) {
+			if (!list_empty(&folio->_deferred_list)) {
+				ds_queue->split_queue_len--;
+				/*
+				 * Reinitialize page_deferred_list after removing the
+				 * page from the split_queue, otherwise a subsequent
+				 * split will see list corruption when checking the
+				 * page_deferred_list.
+				 */
+				list_del_init(&folio->_deferred_list);
+			}
 			if (folio_test_partially_mapped(folio)) {
 				folio_clear_partially_mapped(folio);
 				mod_mthp_stat(folio_order(folio),
 					      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 			}
-			/*
-			 * Reinitialize page_deferred_list after removing the
-			 * page from the split_queue, otherwise a subsequent
-			 * split will see list corruption when checking the
-			 * page_deferred_list.
-			 */
-			list_del_init(&folio->_deferred_list);
 		}
 		split_queue_unlock(ds_queue);
 		if (mapping) {
@@ -4194,40 +4195,44 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 	struct pglist_data *pgdata = NODE_DATA(sc->nid);
 	struct deferred_split *ds_queue = &pgdata->deferred_split_queue;
 	unsigned long flags;
-	LIST_HEAD(list);
-	struct folio *folio, *next, *prev = NULL;
-	int split = 0, removed = 0;
+	struct folio *folio, *next;
+	int split = 0, i;
+	struct folio_batch fbatch;
 
 #ifdef CONFIG_MEMCG
 	if (sc->memcg)
 		ds_queue = &sc->memcg->deferred_split_queue;
 #endif
 
+	folio_batch_init(&fbatch);
+retry:
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
 	/* Take pin on all head pages to avoid freeing them under us */
 	list_for_each_entry_safe(folio, next, &ds_queue->split_queue,
 							_deferred_list) {
 		if (folio_try_get(folio)) {
-			list_move(&folio->_deferred_list, &list);
-		} else {
+			folio_batch_add(&fbatch, folio);
+		} else if (folio_test_partially_mapped(folio)) {
 			/* We lost race with folio_put() */
-			if (folio_test_partially_mapped(folio)) {
-				folio_clear_partially_mapped(folio);
-				mod_mthp_stat(folio_order(folio),
-					      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
-			}
-			list_del_init(&folio->_deferred_list);
-			ds_queue->split_queue_len--;
+			folio_clear_partially_mapped(folio);
+			mod_mthp_stat(folio_order(folio),
+				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 		}
+		list_del_init(&folio->_deferred_list);
+		ds_queue->split_queue_len--;
 		if (!--sc->nr_to_scan)
 			break;
+		if (!folio_batch_space(&fbatch))
+			break;
 	}
 	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
 
-	list_for_each_entry_safe(folio, next, &list, _deferred_list) {
+	for (i = 0; i < folio_batch_count(&fbatch); i++) {
 		bool did_split = false;
 		bool underused = false;
+		struct deferred_split *fqueue;
 
+		folio = fbatch.folios[i];
 		if (!folio_test_partially_mapped(folio)) {
 			/*
 			 * See try_to_map_unused_to_zeropage(): we cannot
@@ -4250,38 +4255,25 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 		}
 		folio_unlock(folio);
 next:
+		if (did_split || !folio_test_partially_mapped(folio))
+			continue;
 		/*
-		 * split_folio() removes folio from list on success.
 		 * Only add back to the queue if folio is partially mapped.
 		 * If thp_underused returns false, or if split_folio fails
 		 * in the case it was underused, then consider it used and
 		 * don't add it back to split_queue.
 		 */
-		if (did_split) {
-			; /* folio already removed from list */
-		} else if (!folio_test_partially_mapped(folio)) {
-			list_del_init(&folio->_deferred_list);
-			removed++;
-		} else {
-			/*
-			 * That unlocked list_del_init() above would be unsafe,
-			 * unless its folio is separated from any earlier folios
-			 * left on the list (which may be concurrently unqueued)
-			 * by one safe folio with refcount still raised.
-			 */
-			swap(folio, prev);
+		fqueue = folio_split_queue_lock_irqsave(folio, &flags);
+		if (list_empty(&folio->_deferred_list)) {
+			list_add_tail(&folio->_deferred_list, &fqueue->split_queue);
+			fqueue->split_queue_len++;
 		}
-		if (folio)
-			folio_put(folio);
+		split_queue_unlock_irqrestore(fqueue, flags);
 	}
+	folios_put(&fbatch);
 
-	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
-	list_splice_tail(&list, &ds_queue->split_queue);
-	ds_queue->split_queue_len -= removed;
-	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
-
-	if (prev)
-		folio_put(prev);
+	if (sc->nr_to_scan)
+		goto retry;
 
 	/*
 	 * Stop shrinker if we didn't split any page, but the queue is empty.
-- 
2.20.1


