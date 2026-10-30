Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB284606A31F
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 03:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UhErc/r4
Received: by kanga.kvack.org (Postfix)
	id 012CF6B05B1; Thu, 29 Oct 2026 23:45:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F053A6B05B2; Thu, 29 Oct 2026 23:45:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF4B76B05B3; Thu, 29 Oct 2026 23:45:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B28156B05B1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 23:45:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AB5C412053F
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:45:07 +0000 (UTC)
X-FDA: 85377901854.10.636CA89
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id E0CD7180005
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:45:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="UhErc/r4";
	spf=pass (imf06.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793331905;
	b=mSwAEVA72iSGUmJaJNMvD+F6rocuY+g4JSumNrUh/A54lwvFdWtZljT1uEKGnkpPwAif4B
	Ckr8ZWAyZrUNAcbKE72e0LQfDiIY23vbPytQczg1xEdD9+GXWmVGxORXKV8eUwR4zuwAvK
	KpDGolWxa5FJLBqFDDjhRGIxrbB+Up4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="UhErc/r4";
	spf=pass (imf06.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793331905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=XtTfodCHuVaVxXQYCj+jpdhwMxAv9AL4leDlwu5qJfs=;
	b=RRi+u1PsEt1V8FHKYKEKKBOVasvlZ/lDNaV4j3C8rKfzhL5qYopXp33PMZZElnjQf8Cfnc
	IBDrw85bW/gsIaIXMk5qwZ6AqIUCzOkf5nqF6NMy/W4T4ND0e6qaTTJ0aw5vF43U6mOyow
	MPP2GRVHe3bj6mXX5J/gTMqmxfQgyD8=
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-36a0f27c9f4so547881eec.1
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793331905; x=1793936705; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=XtTfodCHuVaVxXQYCj+jpdhwMxAv9AL4leDlwu5qJfs=;
        b=UhErc/r4s3AzowSoovw0fGFAjca5u6PqAuudk8AFKrbgN9o4VxofEDFfXOp05WGNUg
         ZOh5MT50zBkcug7woooVVPDqi51k5HRL0/MCxnoENMpeSk6SRPNTqkq77HXBfVYaxVnI
         M9gruLIoafj1VjjFzLf32rVHxIXyUPRTlVqpmQ8WIR6a6aAstqmiYrQfv6J+oc80RzXw
         fG/URNa6KwfP/tt1hclu9YO1e77tGJxrrar/A+3EZK3W/iYGH8+WXMOJeBb2TS7JXezf
         CTgodJ8HXODkmmSXGZrpW2K5IwhrcnkDSKt13TAAdYnJDdA/KTBu6E+9mbyQB0WR5aKU
         Ezkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793331905; x=1793936705;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=XtTfodCHuVaVxXQYCj+jpdhwMxAv9AL4leDlwu5qJfs=;
        b=Do6EDiQM5c5WtUOqnoNRpq+3pM0DtP58TkD63+Uw3/EV0gP4Jq1WRr9Ai1qdpoW/TE
         UMiJ/EBTxF6bIofbOhMXp02j49zpF3yhNNI+OdzJNKyNS0WPPhqMnyV0hgMwwRDhIoI3
         fZ6RxOFDjYravtrsOCtkLYH6EHSt4S1sGyS2Na+QQinpby39jI4t/6SvKBdDLyO45WYg
         O4TKb2IRvZ/KUcNa61I9Idbo/fkEXR1E1SHpOr7o1F3fnPt4l30UqbZpVHti8hAYVPpd
         fuy3csU1cCk2Quit7SgdEIrlBTxBkvIqYqkbRQvEcbsNpYb4dDbe3iDIwHPIGWcV1ZEg
         RkgQ==
X-Gm-Message-State: AFq9FYLHyH6IJ8roQq082VbE8TIl7rsm/s7jbj0Otb5hIlysY00rMcQa
	U8v8phQB6pvjx50G6Pq2o/z850H9qSSquKmw7D8Murab/9qGdM8qCy/5
X-Gm-Gg: AYBFou30qWAOVcs/bb2kHGgu3XeqJeBdiue7bKrHAcmUrWEKto0+6c8CYWj+jvMOfy8
	nZLbqJ8/DBbyvyhw2e8PA5U9UP2bM1nrmwcrWHUMDnpbjcVai3hSAVwoafje4Xb3C5RXAJzBOKa
	xY8cGEbebszHwplediyIS5pY+Unypr9sOH944Hw1k1BkrP10Ic5lQ54V09csh+tkdPWOxCVl3Vb
	NXddEkorCFZDu03DSo5IBkE6tDq8GUyCVXJ3u1KBL4LHNJDC4nCmwS1g3AtbM02XQoX1Ls1bvFY
	KO28JCBp39fGBw/FiTNNnNLlWp6S7xldXJcQxXe8sfsJIFN41mm55vUae1qesVvZt3cG1QND4gP
	IRmdEZ/zhpW5AYsNX8GTe7X4NSAu8WfSAOuP8GbdpNgbSQ98ibYvQrJED8kZDZ4aDnNGI9DBf1e
	ltMBKzjh6WRrJuFtCb7Q39jWeZBobncK5jkYOi6/S7BE03I4aGqDtElMyR2LmkjueExrH7145Hw
	kz4zfg7pLFB3L82OHrbOFTXi7ElRout51JXCh8wMpabwRDcssmpHCvXK0/methinyZ5aN5eM8vk
	ZD+QdMOgOMOREkuTvmzIhFQD
X-Received: by 2002:a05:7300:c8c2:b0:36a:117:522a with SMTP id 5a478bee46e88-36a423bf71cmr1949263eec.22.1793331904245;
        Thu, 29 Oct 2026 20:45:04 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428af1easm2836585eec.5.2026.10.29.20.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 20:45:03 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Thu, 29 Oct 2026 23:44:57 -0400
Subject: [PATCH] mm/shmem: remove truncated folios from the page cache in
 batches
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-bug-mm-shmem-undo-batch-v1-1-59b34212fe78@gmail.com>
X-B4-Tracking: v=1; b=H4sIALkS5GoC/x3MQQqAIBBA0avIrBtQF4JdJVqUjjkLLbQiCO+et
 HyL/1+oVJgqjOKFQjdX3nOHGgS4uOSNkH03aKmNktriem2YEtaYKOGV/Y7rcrqInqRU3joTFEG
 vj0KBn/88za19Dg1HF2kAAAA=
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Queue-Id: E0CD7180005
X-Stat-Signature: edbhga6xoicjurbspqsb5xqigffb1jrg
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793331905-381550
X-HE-Meta: U2FsdGVkX18CUBELua3MHdoZzL3VE8FlZfT0hAnZnuR5ZVlIlQYu99Wy4pO7D5+rAvzvbfdEptE5xcJtZH2nKfMxumZB3uD1tZk7wgLS3p5iLjbo3zoLiN0pQJ2TmMi2SIF0m/iDjQluaN1phE0CzHdQXaAvdLPsjiGu0+0faoCpnpT5skrJeQp6S83GxhlrEPSlMs0LXKvS/xfciNtTMV+XWxGn/qm2VRRKDo4+DP3tHbvLeFO+Ekdn2vgcRT1DZ/VXxjOcx5QvEA9k75mmQ735cINTenQzlXQOTdeb59c2eUtJok3AYNb8qxOF+ULuCgO52TqkTvCz8f3DlFtG957COWNGEaTLEQSQptDknwo+Z/H0Rm0T6Ny/cYw9ozXxtHgXHujkmiaxdXdk2Fr0vCH12x22JeK8m2ciO8z7LMq+/stIDMWQxRWRpz6K4yIhqUzhAMegAoU2whze2uwfY4BkAW+6SUKs8YpIRDSAOPtQssR0Vmka3ixMGr0xTP94UT8GLMa17633urW3RuoRMID23z5NJ+g+CSVtTEZrYVlaRZWMZoDSGsCWZPrTXyC1bDCJb1LD/mmkaeqzOkCTw7OxuNbuTDz68Kf1Ydv+lKuX+qgs9FcDXbizDtb5OpHP42tYgivoCFZjNrH4C7s26uFVjRJsRTyTXVwn6sSDjD/ljYIaBzXKn0KWESZuORT2ACc3RnN+MSIyhc/1JK9FyVgxfNSv9l5gzkldCeYaTqxOhXHW7BlXuPJyhZXL8LcopZ6MJaUp1OqYf26liL/CC41wonlo7P6p7xPkRvdri+Z2326YCuOO4ywQqRLzaQbOZgReM1dazU3ftDUgdRreWxFRWuSAk9/iOoN0vIDVAmpF4APo+a3LDMebCqYVOaQYxO55GRFw9/Fl4HfQ9hulHpCnfFu0neyCkdaMfGsvDrHMGWMG6TqcOAYYfquI2q5BDm2kYl77oCoIKB6knYb
 iU0Eia+1
 w3fnOYhKghj37gqrgu16ZtukJ2SXu5onE8JcwbIiS+qzgcGFbB4J99vkEG3+Q3ZAixIlSfJeSosngL0XSA5HfjieLPhfv1SYf41CblR6UuRgjw5Ha2hyfEC36MtE/B5m57tfN0Mcc8NVv9tOd7MADT2LE6L6A4vW4HUikxDbjw2JvbtYb8k6KcSwruGD7s38ODjL0UgrL6dmpfBvzD96Fk3UpjRoFEuNjr3hwzbYdxPPcR1iJ/PCGq7qJywoMZUvyBnKnl54xlBaI+sWescNafONL8xFWmMrN1wdQX8HyDhV8Ak8YdK4W3hS53Mz4stBatHFvjMwWpm42UYGIXje7EzXIw7U674iDTXY+Uic9OTU5IUeELS/FgGn92ZMJJWt+FXFTewzE9C2XqKxzuor4K5QsZ38gH4GvEnHrEoHGT+qFAv9FNDR6shk3w7gPUAazSEwwclVIROsg6a0qairnucmVlG69qQ3pli+X77FK89ohwheQwmUAXzpCtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

truncate_inode_pages_range() takes the folios it finds out of the page
cache with delete_from_page_cache_batch(), which takes the inode's
i_lock and the i_pages lock once for each batch of up to
FOLIO_BATCH_SIZE folios.

shmem_undo_range() calls truncate_inode_folio() on each folio instead,
so filemap_remove_folio() takes and drops both locks once per folio.
Truncating, punching or freeing a tmpfs file or memfd made of small
folios, such as a large /dev/shm segment, pays for that on every page.

Clean each folio up as truncate_inode_folio() does, collect the ones to
remove and take them out with delete_from_page_cache_batch(), which
needs truncate_cleanup_folio() outside mm/truncate.c. Swap entries, and
the folios kept when undoing a failed fallocate(), stay out of the
batch. Dropping an 8 GiB file of 4K folios, median of five runs,
averaged over two boots of each kernel, in a 32 vCPU VM:

                        before    after
  ftruncate() to 0     1163 ms   913 ms
  hole punch           1155 ms   914 ms
  close() of a memfd   1161 ms   914 ms
  unlink()             1162 ms   916 ms

Files of PMD-sized folios take 20-25 ms with or without this change.

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
To see it, fill and remove a large /dev/shm file:

  fallocate -l 8G /dev/shm/f && time rm /dev/shm/f
---
 mm/internal.h |  1 +
 mm/shmem.c    | 16 +++++++++++++---
 mm/truncate.c |  2 +-
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 566cbd2dce485..abe64e49a4170 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -628,6 +628,7 @@ unsigned find_lock_entries(struct address_space *mapping, pgoff_t *start,
 		pgoff_t end, struct folio_batch *fbatch, pgoff_t *indices);
 unsigned find_get_entries(struct address_space *mapping, pgoff_t *start,
 		pgoff_t end, struct folio_batch *fbatch, pgoff_t *indices);
+void truncate_cleanup_folio(struct folio *folio);
 int truncate_inode_folio(struct address_space *mapping, struct folio *folio);
 bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
 		loff_t lend, pgoff_t *pstart, pgoff_t *pend);
diff --git a/mm/shmem.c b/mm/shmem.c
index af21a89abb0f6..16b6e38503bc3 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1352,6 +1352,9 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 	index = start;
 	while (index < end && find_lock_entries(mapping, &index, end - 1,
 			&fbatch, indices)) {
+		struct folio_batch remove;
+
+		folio_batch_init(&remove);
 		for (i = 0; i < folio_batch_count(&fbatch); i++) {
 			folio = fbatch.folios[i];
 
@@ -1363,9 +1366,16 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 				continue;
 			}
 
-			if (!unfalloc || !folio_test_uptodate(folio))
-				truncate_inode_folio(mapping, folio);
-			folio_unlock(folio);
+			if (!unfalloc || !folio_test_uptodate(folio)) {
+				truncate_cleanup_folio(folio);
+				folio_batch_add(&remove, folio);
+			}
+		}
+		delete_from_page_cache_batch(mapping, &remove);
+		for (i = 0; i < folio_batch_count(&fbatch); i++) {
+			folio = fbatch.folios[i];
+			if (!xa_is_value(folio))
+				folio_unlock(folio);
 		}
 		folio_batch_remove_exceptionals(&fbatch);
 		folio_batch_release(&fbatch);
diff --git a/mm/truncate.c b/mm/truncate.c
index 733d2713a875a..c6bf4aa0b91e8 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -151,7 +151,7 @@ EXPORT_SYMBOL_GPL(folio_invalidate);
  * its lock, b) when a concurrent invalidate_mapping_pages got there first and
  * c) when tmpfs swizzles a page between a tmpfs inode and swapper_space.
  */
-static void truncate_cleanup_folio(struct folio *folio)
+void truncate_cleanup_folio(struct folio *folio)
 {
 	if (folio_mapped(folio))
 		unmap_mapping_folio(folio);

---
base-commit: d89e1d186ec9271bf78e62771779e9fc03bf0fc3
change-id: 20261029-bug-mm-shmem-undo-batch-de001d9c6f1e

Best regards,
-- 
Qiliang Yuan <odys.yuan@gmail.com>


