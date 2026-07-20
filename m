Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F22DBC4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 05:08:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5E2E6B0095; Mon, 20 Jul 2026 01:08:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E360D6B0096; Mon, 20 Jul 2026 01:08:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D25286B0098; Mon, 20 Jul 2026 01:08:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A231D6B0095
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 01:08:15 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 19B22C071C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:08:15 +0000 (UTC)
X-FDA: 85007973750.02.2F7B627
Received: from outbound.qs.icloud.com (qs-2006j-snip4-3.eps.apple.com [57.103.85.224])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2C6F18000C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:08:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b="ZH6PEq/n";
	spf=pass (imf02.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.85.224 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784524093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EsyP5irdsQmvLw/lSwMp6yzpUiFqRmMgjYO2e0T/6PY=;
	b=IhsRbie0ArQF/yclNJCHaijiMVeR/yLTv2EH2Q47raVd8MGbSxsMY5GwIWKFf24h/yX5C/
	4FFtgJ3PdDr2Lry1sj8aCQtt9k9MBUEssehQmOGLin0h6mFlnqM9wV7Pul1Vrd8KE4ZDht
	AnG2BDYLurmaiClqzxyeo0Trx6/9Gp0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b="ZH6PEq/n";
	spf=pass (imf02.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.85.224 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784524093;
	b=qBBTyTBtQfxZ01Cj5YosPKlsTN5AaLqrYjVX6MdaRGtl2kPoU+/14ZT94nfaMxFLCLNHBc
	rPNrvDkt4x4ZS5lJHRDTSI6rxKjNIiolMmQMKSvIZMZMgfFqCz9HqV7RpEd9nzmc4ObOu6
	eBBitLWZIJEwbT41V35o7XMIpO8EiGY=
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-60-percent-7 (Postfix) with ESMTPS id BCFAA1800094;
	Mon, 20 Jul 2026 05:08:09 +0000 (UTC)
X-ICL-RepId: 019f7dec-a959-7740-851f-8b0f8f71ecbf
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhMHVwGXRxCCkEdXgBLVxQEAlodRw5AHVYWWAhOK1sTVRdGCRkIXR0ZHldQXgheH0wcHQ5YBhICWkUBXRcDVxxWRVwYQwldBVccHRxERVsTVRdGCRkIXR0ZCEcfCjADQg5WA0MHRQAtGRxXUF4IXh9MHB0OWAYSHVAcDlEFWwBGCU8BXRoJUwRaEB4ZWwkfFlUNQAUaHQddClVXDw5fAREJHAMJAQlyGVoUXBhTRVEfVEYTGU4bV01QG18CQg8=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1784524092; x=1787116092; bh=EsyP5irdsQmvLw/lSwMp6yzpUiFqRmMgjYO2e0T/6PY=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=ZH6PEq/n7EF6ttWD+sQmQGhBz67cZwgnvFO7VlmkFe57n+8Zwmlr5EphsZODxmOl8hYKo/ykWEKipDaqDchQFniG0jB5oHmHDuVH8035kurVuSXwMLJeWrhrVHV6IpOe0GBLB1zu5Yf4E3Z5YC8BuFWkhbvvbu1Qvn7m8jGxW9X7eo8pn07GkBCDPtDIkV5jhnLzKMBK5BJnlJsZGW/38bj5lrVMiO/r/PO6sYlDF81Riw4XhzOZ6HP7cPHAbANaYLBAeJeCCYCHQoppdGsFaxYJGb2Zd0AUSuzo5BaX1beIYuC4XZZGmP8Th0cd4cwIXo5jc0ntSa9OlyvwUUTIXA==
Received: from [21.6.122.162] (unknown [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-60-percent-7 (Postfix) with ESMTPSA id 30CDB1800153;
	Mon, 20 Jul 2026 05:08:02 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Date: Mon, 20 Jul 2026 13:07:40 +0800
Subject: [PATCH v5 3/5] mm/vmscan: extract pageout_one() from
 shrink_folio_list()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-batch-tlb-flush-v5-3-db943a0d0d6b@icloud.com>
References: <20260720-batch-tlb-flush-v5-0-db943a0d0d6b@icloud.com>
In-Reply-To: <20260720-batch-tlb-flush-v5-0-db943a0d0d6b@icloud.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
 Qi Zheng <qi.zheng@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Zhang Peng <bruzzhang@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784524064; l=4293;
 i=zippermonkey@icloud.com; s=20260309; h=from:subject:message-id;
 bh=l+BMBCV4bE1SQ4xqKdkiAu5ODtsRbK+KeBkmi8ZvYtM=;
 b=s9/X+XJmXWZJHCGfES1UArzwc9PYINiT2yqXEOrpNsPIR8ow12vpoftGTs9JFz4tFXW8/BwWh
 Rdf4e32+7epDNexK7cWPfQxaFy8jTAF1BtJ+voGRpU+DXH6ZElLoy+i
X-Developer-Key: i=zippermonkey@icloud.com; a=ed25519;
 pk=tPCLpFnBfIyHsp0k7eaUTUREEa36bQNW/69X+NS8wBU=
X-Proofpoint-GUID: N5T4eMakfuls9gzg2ocoGR5sco53UcYa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDA1NCBTYWx0ZWRfXzyk1OZOlY0jB
 PXGCZLeXDDRdTfmZZb89tH6u6ihldkVUk3XA+9PUHITim49G6I5DisTizDnJt1XQwxfE00KxJQQ
 NjdVL+1c1HNTLNj+SybrR9M96ixdk+/iKxcyUWKNK5B8ViNSoXmENTqXbjUN3c3eukZ42BQaqw0
 R7GOI4ds7bNWKPSoNPFN5jpKCW5AIWAPG55crnVrbs43W6CuBnhKu99QQXtZtit3cFBSZzAEjgB
 dQGmfGSo41Oena+wmZMQOwGAcygvjBNAL67xefp8/HO2bQEk5/olPI8h6LiPkhoVUTo1VzFX+5B
 uIktOytflSG50jhLTJB
X-Proofpoint-ORIG-GUID: N5T4eMakfuls9gzg2ocoGR5sco53UcYa
X-Stat-Signature: axyzxh86y1muzcjdbnn9x3on5b4aiuyh
X-Rspamd-Queue-Id: 2C6F18000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784524093-392495
X-HE-Meta: U2FsdGVkX184R0jhEaTp71yl5FOdOpb+rUsNE82B81FAMwUL4CLy6SIGOhn+0eMxC0hMYQ8q5zyPMMd2Hgpi1w0Tj167/AZS0A90wZV2W8cmDXGBwHzrt3J3jFaRSOYF/gwpZEA/wtNKn8ejrRJjIUYsiNGeuV7hlYN05D+pwMkA6AQCLov/rCGnSgk5aRSEkBMRVwN5EWo1Kt8s9x/dKrHyLwJO52iI5p6JvwLoreXm6VW6YeU6vDqi4PQS1knG03j9xvvuh9qMWnIrHHq4YzkpDIJl0bFPaczC8NEI+6w83UZxm4GJ0w8JtMvHFdCun+eCmAnY/a8Pc2TP7tbpQWuwRbZ1+DcJsWrzE2D0UTk8fyH7Cj647AT7Pi9KBxk0C0Xh1h++PXsCEUSveY9yQO94xH77iceGIBsHiUJhVzqMaUawl2l1sA90bcgwHGUUXO7CNNIpsgUtLk4H0Ht7CRt5AMIjxC6VsuS46gC3fbQBEENWbsRG4LYfit06dPG9sI8AQC+zSj4arbzMXu+7GKHcVcsiD/a9tNbQm6ZV1C9ag0zEnnilKfE+h6+8sxAQ/My9PlFJG7x8xPj3NihKY3+x9UIG+P2NB9NLkAe5cYtRpflvyvt/uPOQPaMRQyUftX8HsszOfJEWbVeLNLMu/96kwfAjN3NzQRDYW5jK9UiRZNTWwYk87spsmJqtB7lYcIcjtcWyWaE6TQLtNAqoAab8J2+AsWWD0/E9a8/xgR5QAZUvpYijMy0LquS9WGaZDd65qSpAQWm9quMZnKzsjAss+dtbV/yH1+IbZQxOQXd+PpTr4bmiNTd8ZTbegs337LzjnJpFtHDxzYNfLut7pVTvQ7/FS+QQdPC1XnLSsG8XXRNH33rUyfr+NHPIzIbKO2M3HxZ91GeOa9YA3RU4mf5YX/mhiZhEj2dUgnA4oCuQcLC7Vx5Hk8yzRmSf/1jhoBnNRV2WhawfON/WY4i
 PuRRVC/U
 a68eneAu+J0HMPCk1VOO2t3Yy9DHX2ttsMDaQW8zmcC7gGjST9mUo5W51DlIFA1uLJLgEL8oymedVCOVRE/+cYiM/0sOqMbUVpA7RZ0eIkyDFdmvgLQ0NQFGkemSzih34gqEMG0Mn7ZqHD21NjIQVe16sS1coGAxZ8PWLAXncGDe4K9gJPXckGbJIb8l0qSITnG+Q399ARPGRJkYTb1VMOZ3fKFlLWE0xqfTpkwY8Qi9Tr9ppiIBC+b8NFsZGMzy8kZPikPmxCCxelP+r8Wwn0mytHV90iRgdH7EfqXF2l4etZ64UO5nDP638YWvub9xDQ7fPeugWtxXqHQxd9cZFME0EPKM/HjY6J2djpFF1D+IXauVDZg4YEdKd2C19y4nj7JCjsNv6kqwo8eKQMjfoQSatw7NKNT3XyoSJJaGabotAowObNOjHY2Ky90RkMr/wuCuD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

shrink_folio_list() contains a self-contained pageout() dispatch state
machine. Extract it into pageout_one() to reduce the size of
shrink_folio_list() and make the pageout step independently readable.

No functional change.

Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
---
 mm/vmscan.c | 104 ++++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 62 insertions(+), 42 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index a0807dd01c5a..3e18948e90d1 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1163,8 +1163,65 @@ static bool folio_try_reclaim_free(struct folio *folio,
 	return true;
 }
 
+static bool folio_try_pageout(struct folio *folio,
+		struct folio_batch *free_folios,
+		struct scan_control *sc, struct reclaim_stat *stat,
+		struct swap_iocb **plug, struct list_head *folio_list,
+		unsigned int *nr_reclaimed)
+{
+	struct address_space *mapping = folio_mapping(folio);
+	unsigned int nr_pages = folio_nr_pages(folio);
+
+	switch (pageout(folio, mapping, plug, folio_list)) {
+	case PAGE_ACTIVATE:
+		/*
+		 * If shmem folio is split when writeback to swap, the
+		 * tail pages will make their own pass through this
+		 * function and be accounted then.
+		 */
+		if (nr_pages > 1 && !folio_test_large(folio))
+			sc->nr_scanned -= (nr_pages - 1);
+		folio_activate_locked(folio, stat);
+		folio_unlock(folio);
+		return false;
+	case PAGE_KEEP:
+		folio_unlock(folio);
+		return false;
+	case PAGE_SUCCESS:
+		if (nr_pages > 1 && !folio_test_large(folio)) {
+			sc->nr_scanned -= (nr_pages - 1);
+			nr_pages = 1;
+		}
+		stat->nr_pageout += nr_pages;
+
+		if (folio_test_writeback(folio))
+			return false;
+		if (folio_test_dirty(folio))
+			return false;
+
+		/*
+		 * A synchronous write - probably a ramdisk.  Go ahead
+		 * and try to reclaim the folio.
+		 */
+		if (!folio_trylock(folio))
+			return false;
+		if (folio_test_dirty(folio) ||
+		    folio_test_writeback(folio)) {
+			folio_unlock(folio);
+			return false;
+		}
+		fallthrough;
+	case PAGE_CLEAN:
+		; /* try to free the folio below */
+	}
+	if (folio_try_reclaim_free(folio, free_folios, sc, stat, nr_reclaimed))
+		return true;
+	folio_unlock(folio);
+	return false;
+}
+
 /*
- * shrink_folio_list() returns the number of reclaimed pages
+ * Reclaimed folios are counted in the return value.
  */
 static unsigned int shrink_folio_list(struct list_head *folio_list,
 		struct pglist_data *pgdat, struct scan_control *sc,
@@ -1501,53 +1558,16 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 				goto keep_locked;
 			if (!sc->may_writepage)
 				goto keep_locked;
-
 			/*
 			 * Folio is dirty. Flush the TLB if a writable entry
 			 * potentially exists to avoid CPU writes after I/O
 			 * starts and then write it out here.
 			 */
 			try_to_unmap_flush_dirty();
-			switch (pageout(folio, mapping, &plug, folio_list)) {
-			case PAGE_KEEP:
-				goto keep_locked;
-			case PAGE_ACTIVATE:
-				/*
-				 * If shmem folio is split when writeback to swap,
-				 * the tail pages will make their own pass through
-				 * this function and be accounted then.
-				 */
-				if (nr_pages > 1 && !folio_test_large(folio)) {
-					sc->nr_scanned -= (nr_pages - 1);
-					nr_pages = 1;
-				}
-				goto activate_locked;
-			case PAGE_SUCCESS:
-				if (nr_pages > 1 && !folio_test_large(folio)) {
-					sc->nr_scanned -= (nr_pages - 1);
-					nr_pages = 1;
-				}
-				stat->nr_pageout += nr_pages;
-
-				if (folio_test_writeback(folio))
-					goto keep;
-				if (folio_test_dirty(folio))
-					goto keep;
-
-				/*
-				 * A synchronous write - probably a ramdisk.  Go
-				 * ahead and try to reclaim the folio.
-				 */
-				if (!folio_trylock(folio))
-					goto keep;
-				if (folio_test_dirty(folio) ||
-				    folio_test_writeback(folio))
-					goto keep_locked;
-				mapping = folio_mapping(folio);
-				fallthrough;
-			case PAGE_CLEAN:
-				; /* try to free the folio below */
-			}
+			if (!folio_try_pageout(folio, &free_folios, sc, stat,
+					      &plug, folio_list, &nr_reclaimed))
+				goto keep;
+			continue;
 		}
 
 		if (!folio_try_reclaim_free(folio, &free_folios, sc, stat,

-- 
2.43.7


