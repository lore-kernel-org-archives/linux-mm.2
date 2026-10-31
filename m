Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7C23606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 20:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=j5GdpMGp
Received: by kanga.kvack.org (Postfix)
	id A6DF26B00EF; Sat, 31 Oct 2026 16:35:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1E466B05B1; Sat, 31 Oct 2026 16:35:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9343E6B05B8; Sat, 31 Oct 2026 16:35:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5F0546B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 16:35:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DDA41C043E
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:35:58 +0000 (UTC)
X-FDA: 85384077996.27.E7A743A
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4741D180003
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:35:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=j5GdpMGp;
	spf=pass (imf06.hostedemail.com: domain of 3K1HmaggKCMQ2urk6ktkqyyqvo.mywvsx47-wwu5kmu.y1q@flex--skhawaja.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3K1HmaggKCMQ2urk6ktkqyyqvo.mywvsx47-wwu5kmu.y1q@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793478957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mWqOErFXDyqrG4+5c5D2/KSgqZrNhszC76dEZeElAkE=;
	b=HMWFg1AQj5JLFU7E86QPHdUCat2EImdJ+T9yKNQBItuPkk89k8/ZbRwT6v3Ao+1vrrwsun
	8AFGrqRPlVl1hekW+1ddopk+1es6ZACzmToTkeprxH2lEvl1ftM8G9/7VDuwt59p4fZD64
	jTOowCZzH0lUh8mXZTlLPSxbDJwIgKc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=j5GdpMGp;
	spf=pass (imf06.hostedemail.com: domain of 3K1HmaggKCMQ2urk6ktkqyyqvo.mywvsx47-wwu5kmu.y1q@flex--skhawaja.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3K1HmaggKCMQ2urk6ktkqyyqvo.mywvsx47-wwu5kmu.y1q@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793478957;
	b=I48KEO31onrN+rT/0PCVi5VyIgXmXrkNUQtMHXPzCuJbm9sj6BV7ZreI28N9cZIXa4oSlm
	bHbgDAgucBMYIUHahbZcfrHJC/8XvE9pN8DWQHA5vcz7lk8C2UHmzhqtuHrMCPrwl2g5xy
	SXGxZyIzNG8rMrWta6Zo46WvwpIu104=
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cc1ca15334cso2064597a12.1
        for <linux-mm@kvack.org>; Sat, 31 Oct 2026 13:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793478956; x=1794083756; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mWqOErFXDyqrG4+5c5D2/KSgqZrNhszC76dEZeElAkE=;
        b=j5GdpMGp3z2EGB/twAiNIxcoJGART0bpmxi/1P28maC2abnvcZBCisl/6PqygdUaUc
         8NvRkvhpLvIf2ovv7/B3CXtcq0aTmj+zSHDPiVO5tijeAByWD+O7T3BI/lMz/ZDdZ1Fd
         09bT8vYs3EqGUVwiRkp7FQx/90nz7D+bepKdlnBIp6W6FgR4kqffscbqbnu/doNsX2B7
         t8UvnwhYBorwns1U8xfyPSTd94k/wVGPxYEcRG91KSOgpURAHGbWwV90iBkqOOvc5Ysy
         E1zER0Xtg+UMOEObVBl0Yc668DxS/Kgcn1NH685nIFdv3vGJEvfBrpSsASNbxcYhs8J4
         cm3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793478956; x=1794083756;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mWqOErFXDyqrG4+5c5D2/KSgqZrNhszC76dEZeElAkE=;
        b=X+IRJdEGZqeZADNRL6D6b1mDlDDsfahnmgGSWRFiZoHEOQEdPG86sHmQXgGUUKlFfe
         p8f86KOJXME7kwxB1pGsuN3bQh7eXhZyK0El20VgXHn+aoGectWT65ifDBQh7vnEazVg
         zT7xR/FIilbJibyIxYuml2QyPdPd/gG3T09hZ36RJT1nbe3MnmzXrmm8kmlN8qVt0c3n
         oL8EQBAe/29+gavU0GC4uVcZACOQu/PjyagcEeEK3jYAS05i8U4c08qEDkUFYLIa85SY
         727gWCvWTODGeqlQgfJKMY3YWwrbirAuO2KBVskVETggYeM/XUXBy90qiVhF+IOd+9E5
         KWmg==
X-Forwarded-Encrypted: i=1; AKwUvByywj/J2wCXm6f7FZDaJ1+h3VyNdug913QgVv1rYYAEcjnQO+dl89gjxT8w5XHZez2RZZnNIjJ37w==@kvack.org
X-Gm-Message-State: AFq9FYKTzGhq6Y+++4EbWGG3N0FWTBwjImmQt2Vg3wBFbocT1Va2mxIE
	h8kdpT5jbi9c7YggRlEYG3Olmpsv6avM6dbWwGyh0SHOBpXWtz/2iSKxN5j1WsDXNQxZrPW525t
	sTJemLiZ5As9EaA==
X-Received: from pfle16.prod.google.com ([2002:aa7:9210:0:b0:8a0:e479:9889])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:3945:b0:3e1:aa91:7134 with SMTP id adf61e73a8af0-3e928ace8d8mr5315059637.72.1793478955460;
 Sat, 31 Oct 2026 13:35:55 -0700 (PDT)
Date: Sat, 31 Oct 2026 20:35:40 +0000
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261031203540.2282507-1-skhawaja@google.com>
Subject: [PATCH] mm/gup: check folio->mapping under folio lock in memfd_pin_folios()
From: Samiullah Khawaja <skhawaja@google.com>
To: David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Andy Lutomirski <luto@amacapital.net>, Chris Mason <mason@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Samiullah Khawaja <skhawaja@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4741D180003
X-Stat-Signature: ri7ce3c3b7hfdxac4xz4sn3wccaa8db3
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793478957-450949
X-HE-Meta: U2FsdGVkX1/leul3oUdH3JgoZrH4bH5jYGpmsekGZvENC47hSFXfHZNIaTfRRyocqmcaeweO1qsopFxvATUjCYRkqphm0aMuTkEWCtN2om8RH/Luecvoav1zIPTloVaJP1wMGRcUG+tqgDmz4QwKTIZ+h+qqybY6uwrAhbuEBsyha2co/kARkO8KbxKL6paVqt8EaaZWcIsazDJVJEJqSkZlkBR6aD1RzNShYxm8eHXc0gIl3XS3JlqkC770JVqrl3kAjh/7rDe/GOVPfaqvWMWfNLSZXcI1FbswXxoJNKmCbMF2sNfWLnzoT2dx4aQQMQxkjV9decdOjGvhQBcqwVVcp2O6e+1FiJZEqvo2tciQqfJMHYPEMVY/WdcrNdomQRRZjxnJ4e+FxYCIvm+xAaxflzIGevpyJMWTCS/RBMhESp/FmT+q8Hs7/1sPlS8uMLweRXh5RocAlty4nuc6qNexvEDhgTT+I4O2pmUtk38dQ4ksn3xFbtZP/ojxgeORmliw4hSR5wyqjrUkzQG9iLfocMu74aZg20LGYQ1NR43ICC0UD1OxQ8FwHOgTXHOeCi6L5OuLvAffHeE8PYcRvR8DQJI3AQ/9myq4tNmlOKPsvCw0F95f3schfwwqQ4/Vd2eqphCTSjnP+mayZ3zJJTO3QHPW/8w6hNt3bm4dgHIoNE7GmJR6w6TKILdUeq4ATONSndbaawYurHzSy9paje4+YzawPHZVSdTzmNcuvDfCtUroCe9XB9NhrKbZEOw8Ow8JU4Ix/LXPEq3DtRzNZ+nVwiv670pQSA7HEYIyh6g2hdr0NQyDt9eCD0uvk+Buux+Nk+HmcdDezlpsZxtUcvM/U8CFu7zKaCfsXSzw+9RRNx3bQIzM6UkWa3HkmYyKf2xC+Qm2LoA0qWEuMODfC17nl94SX+tYQ8jkzdtY2th0MKeLkcZQuKLkpg5d+BAolC+jwQRcXZWljAX8lc6
 Kzj99ysg
 x0JlaLQj2QVPfLm9JhcK1wqbru+cJH+xB+VaxvvJzXz+ncnrCfaHD5wZvrtDLvF91/sa6cNnURYBIarIMxVY7TBVaaMHz/3V77c3508mtUi0OW1UrZZWQFusG39DDtE+QkmL8JBSUI2Bd6UNXI4Gp/fKORQ9Ob0OQTQqP/lVaiLLnuU3AGRur5DjMY+pHguP5iXrDGFW6aGbtTVVDTWxVQ08DDj/U3ekpQ/8VS+R3bSTyy0Kw+nNbWQZaTMZvzmExq379NEmsseYh/lsmUFbnqDGuk59ZrAzrYsoLeGQjtMiMDR1o+EACwURbPfT0k+nyGf4wrCzmxUyBaDt3CfW0V1RoF+mtL/ihsIcKxF1ayqAZCU9x2dlozDx+Bj6pVwOR/vpbimzTeb3EA4SwcWvKReN74rVJPSG+w0/ZWoGLa3kOVqiyKtFEj8Q09AqnYB4eyRcRtXZ6fkKdjpCUMniLomsQiMbq3/nZc1E6JYC5bFwsRVKQiaO89QJncqJx5wQlN5tWtKVg4BHWxjLtCBhcZcbiwr/EFReZfaYIH2aKikdbsUMvx+pfSfdPk3ERQ9JaVTSemDO+TtBUlvSieRvRUAuUqGiddgbaLdWx3jAI203AzsrXKcP7BoIACuCpQuRPjoHMVX/G3FZxIQ0BiEdGU9kKJdKAOggevPKznNddAucKVOXFOK/bNTG1/sqde0MjfjmwJyvZn0VrNVnaPO1rqW79nonVdQ+aeNeL5tHxthl0zv2mJDKdwzus/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

memfd_pin_folios() pins folios from the page cache without taking the
folio lock. So khugepaged or MADV_COLLAPSE can replace the folio after
its refcount check while memfd_pin_folios() still pins the old folio,
and the caller ends up with a folio that is no longer part of the memfd.

Lock the folio and recheck folio->mapping before pinning it, like other
page cache users do. If the folio was removed, retry the folio lookup
from the index that was removed.

Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
Reported-by: Andy Lutomirski <luto@amacapital.net>
Closes: https://lore.kernel.org/all/CALCETrV5eqg6d9=+BQhCpRwBNe3aCQiut8vxPBs8b7PToqjaHg@mail.gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 mm/gup.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index ba4907b35232..2b405cce2ca5 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -3471,7 +3471,7 @@ long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
 {
 	unsigned int flags, nr_folios, nr_found;
 	unsigned int i, pgshift = PAGE_SHIFT;
-	pgoff_t start_idx, end_idx;
+	pgoff_t start_idx, end_idx, retry_idx;
 	struct folio *folio = NULL;
 	struct folio_batch fbatch;
 	struct hstate *h;
@@ -3512,6 +3512,7 @@ long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
 			 * reason, we try to allocate them and add them to the
 			 * page cache.
 			 */
+			retry_idx = start_idx;
 			nr_found = filemap_get_folios_contig(memfd->f_mapping,
 							     &start_idx,
 							     end_idx,
@@ -3524,7 +3525,21 @@ long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
 			for (i = 0; i < nr_found; i++) {
 				folio = fbatch.folios[i];
 
+				/*
+				 * The folio might have been removed from the
+				 * page cache (e.g., truncated or collapsed)
+				 * after the lookup. Recheck under the folio
+				 * lock.
+				 */
+				folio_lock(folio);
+				if (unlikely(folio->mapping != memfd->f_mapping)) {
+					folio_unlock(folio);
+					start_idx = retry_idx;
+					break;
+				}
+
 				if (try_grab_folio(folio, 1, FOLL_PIN)) {
+					folio_unlock(folio);
 					folio_batch_release(&fbatch);
 					ret = -EINVAL;
 					goto err;
@@ -3535,14 +3550,12 @@ long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
 				 * page cache that were never cleared.
 				 */
 				if (!folio_test_uptodate(folio)) {
-					folio_lock(folio);
-					if (!folio_test_uptodate(folio)) {
-						folio_zero_range(folio, 0, folio_size(folio));
-						flush_dcache_folio(folio);
-						folio_mark_uptodate(folio);
-					}
-					folio_unlock(folio);
+					folio_zero_range(folio, 0, folio_size(folio));
+					flush_dcache_folio(folio);
+					folio_mark_uptodate(folio);
 				}
+				retry_idx = folio_next_index(folio);
+				folio_unlock(folio);
 
 				if (nr_folios == 0)
 					*offset = offset_in_folio(folio, start);

base-commit: 96995467b456942f5bf1c7f2c5c004467f9dd14e
-- 
2.56.0.317.g454f8302e1-goog


