Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32A32C4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 05:08:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13F546B008C; Mon, 20 Jul 2026 01:08:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EEFE6B0092; Mon, 20 Jul 2026 01:08:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 004F06B0093; Mon, 20 Jul 2026 01:08:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C10946B008C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 01:08:02 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D11BAA0F96
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:08:01 +0000 (UTC)
X-FDA: 85007973162.13.66A2F16
Received: from outbound.qs.icloud.com (qs-2001h-snip4-11.eps.apple.com [57.103.87.83])
	by imf28.hostedemail.com (Postfix) with ESMTP id DE5C8C0006
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:07:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=nElY1mpx;
	spf=pass (imf28.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.87.83 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784524079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=10j7WY6pZYOXAZEZpweX4crZCY4OfUrYCS2F0Vpwmv8=;
	b=w821YOcel93D/tN0Sr+jpPSHUwg6i3W5rmxugkvnQ10vLb4MKkMfO2Y+YwOnOmtyBVCCYX
	8/gMtKwoXijoLSqW+xaw9FpDAA23ueWHPf5gdVhQnhfvROwEbB8DAi/uumnJIMwNEjS0qn
	RXHYyTSM0BFQj9ntv8NHW0nXxXGl4y8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=nElY1mpx;
	spf=pass (imf28.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.87.83 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784524079;
	b=WOWVhJ9XdU43Bp44B4fAJdwZ1mNSEu8LCr6qT/sr9ksXAjkoJRx9QExv7dUGEbvhNOZqm3
	mlTU+13frt4yx5GooIN6L2WCPHjxutqAAmr1bamsmzJYllv3e/0hifKeMUxNqpFf7GNRyZ
	9GFSoLyCegbx0juGEu+pQzChflZ+oVk=
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-60-percent-7 (Postfix) with ESMTPS id 8CAC7180014C;
	Mon, 20 Jul 2026 05:07:57 +0000 (UTC)
X-ICL-RepId: 019f7dec-79d8-73c7-91f6-a38505208ad8
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhMHVwGXRxCCkEdXgBLVxQEAlodRw5AHVYWWAhOK1sTVRdGCRkIXR0ZHldQXgheH0wcHQ5YBhICWkUBXRcDVxxWRVwYQwldBVccHRxERVsTVRdGCRkIXR0ZCEcfCjADQg5WA0MHRQAtGRxXUF4IXh9MHB0OWAYSHVAcDlEFWwBGCU8BXRoJUwRaEB4ZWwkfFlUNQAUaHQddCFVXDw5fAREJHAMJAQlyGVoUXBhTRVEfVEYTGU4bV01QG18CQg8=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1784524079; x=1787116079; bh=10j7WY6pZYOXAZEZpweX4crZCY4OfUrYCS2F0Vpwmv8=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=nElY1mpxXvsXBRr9n2BLhYUsrVAAyAUFZDjRYKE4tBuUC86UqF/ub2746q6jG/Gbt3YUkR3OcTQ1MVojpEkXA6X2uOc3U5AUD5LI3QffBj2DnV20Od761mWaBccX3sVzSA+bv6Vj/m+QITqn/o+bQp3uHR8DgIQJp8/meSBprIiVDykwFgv7IwxOj7vScaz1e08J+v/xB4l7LFCqrNgIBCmOCHWXF14V2PQftjiT7MJND/XPaC0DwbCMnrpgG3kqgbO8tENM6qYTFpkXf+IALyisXCPYM773gAYJDhpDZ9oAsTbx0O/T7ub0BdO3Ilo8oVOwJEOzKlRmDQbzB2fqLw==
Received: from [21.6.122.162] (unknown [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-60-percent-7 (Postfix) with ESMTPSA id 16CE0180010D;
	Mon, 20 Jul 2026 05:07:50 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Date: Mon, 20 Jul 2026 13:07:38 +0800
Subject: [PATCH v5 1/5] mm/vmscan: introduce folio_activate_locked() helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-batch-tlb-flush-v5-1-db943a0d0d6b@icloud.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784524064; l=2344;
 i=zippermonkey@icloud.com; s=20260309; h=from:subject:message-id;
 bh=/o7xQp7LYCOHZ22PnOkQZVfltgn9zHZheEocHYd6IiQ=;
 b=rhn1vXifhzIq4xrjZIPPTD8K48FziRZqJrzYtujzYoZ7k1ac5K55GLoD6NWFWzwaHpknPJXeC
 wB2/2OcCH3RBJLZ5LdN3ftGi21PhW2czvgmaUeTa/RP8/Z+OSFdFa2e
X-Developer-Key: i=zippermonkey@icloud.com; a=ed25519;
 pk=tPCLpFnBfIyHsp0k7eaUTUREEa36bQNW/69X+NS8wBU=
X-Proofpoint-GUID: hV3P6CG3dzB9ygQveRXF6_8kY3ngsOKF
X-Proofpoint-ORIG-GUID: hV3P6CG3dzB9ygQveRXF6_8kY3ngsOKF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDA1NCBTYWx0ZWRfX9TfIUtfr4Y/6
 0W0xMzbYYVkmZ4Z/NcTqTvdfq3seAKfGJDpyXgWJ2EdH8QJnCUn0SJPdvL9jTafxgzAowXNF5+Z
 JrX5b9buGldQ38R767BQRAAQraU8qmn7Nz9GfsVSOsZQXOxB635t5kYV5IKYxJvM6CX9QbtopML
 cuuETdFy9BtmPU1OfTaWkbJY/yam8vbDI+hyxe21BHMS0Y/f+EcFe0qFAM9aOLevQqeo0Daea2S
 tU34N1urIidECC8pGfm4yzaLTJaUWUV6Cm8ETiHQFCQPBz52OqUZb0saZcJpPOXvS4Zgl4r0dRK
 blNl9y+tPDXd/SSW30S
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DE5C8C0006
X-Stat-Signature: d4fjuqmuqomcm3ezgn9rdcz4wzg79xtm
X-HE-Tag: 1784524079-229949
X-HE-Meta: U2FsdGVkX19K99QBKTUJ8087ZaPc8Wkuz5e2OdZU9gONW5vWVviOtqe/7nzJ0RL3VG1RXSJGb7GibDc8KTrUejKic1QzliXJQdjo+rphWu4EZIrWJ/0lWwNsvX19WLSwTte7jrNb8noyt00tDiW+WpmwEgtdXNi+tcw5xTFSMsR+xIUiFOJzkAOZsazDGriJqDH9xSyQ4+cegWZZGKwvzrOpvQ3IhOJ7FehnJkjbG07Uk1Gtq7WF4C8pw6urn8ol4lbATNDp/1XopXl32RWHT1DceQbtBKVL7UrTU7srjC1cD6aKQ9vuOqJh8i7GuDJLnxyuoeWr+WSSMz6Riw8Y+zuT5TXj5Coim2wBhbLlpDAqndUROUgSCiqZzDWLFMOr1vVVRsNpTFMaAGHg7OaImKCL8aLu5r8KZ25W7uW5W2MijvaNINS76Hp132B/tCIs1JORXNdUI27aLIEALRV5IP6fL1n3qRRbQzCjnsXsSCLg5fBQm3LTpftfLHY6BeL4hSk15PcdCbd7MwxhnC1DOycUOF/Bgvx2PNsKcfIFS+5qq1b+uPs87wDB/QLSJK/FQGXEn/I3cu3yDwv3wEAfuwvFez59N+uB94xaQlhoN2CM5XXEQ49DPoM7XGkQ+TNJeiU+qWyvMfYWdjj3/MfIibPVC4rFnJWh6m6AqjRyRqaYJ7iikDKvyrXXOwvEo0YW6tBvHrxRklYgbcuHMnTxk8MXg1erLl9+D4WIwV3G2nJowtVQNBfUycq80niDqH0BzuobNgMWbdxubEj0N5YmZmLPZfGUH1uoECKix82MFoSTLYjaa0+EAfKWwPgvl4d81Ck+FcS7rT0YYc+e1pkvQiAbMCi1IzHFo7kPXJiW82uUuTpt62w+HxuWLQs+zuWipcRGmggpNGIVgMdZc2ZUxdlBK6ieDqPUojC+5b/iQ9iDqyKFvzGVjKobNVXIEHUa6ytuYOpbAQv5nauAif4
 D7cl3DeG
 2rCswFT5fnytpjbIeyy2PPEtVwgJbVtcmq9L097+8aaNLCTAAA9Y/xCEmWlSXj8A7aQWg7EsxYEdaVCOxlRjS6nfRryzj1A9/fmNGp76rhHSJZbYhcce9cVNEIaq86PFI7PFFMB5uCGEAlG3MFGoD+efKNCqsZM0hZMyGstv2v5n4yW7Lu0gRkYzSsk3d9VUjfiR6ew3kPfu2n+iSkPJ90UNoLaNguQsG8EydR8jyOT2Suhd0RvQ4TV4+3qKLVwdc4Ft9EMtePRahv2Bma7jA1wH0N3ca824nFS9kga6MjgtH/t1PtQxaWKX0El2GRYk8oeagPpfXifqHM48maKG/e+T5xgpQirEFjyJRTcLNnmbRmm2C+inJdAKVXWF89b9PyJZtwKjoT2z3kv4n4XIs4G+I0fHKIvtAaHY2yvsLMOtxQCwwjL8MYOMvdZdVoT0W7NIL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The activate_locked label in shrink_folio_list() reclaims swap cache
when needed, marks the folio active, and updates activation statistics.
Extract this block into folio_activate_locked() so it can be reused.

No functional change.

Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
---
 mm/vmscan.c | 38 +++++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index ca4533eba701..5ba880dce21e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1050,6 +1050,32 @@ static bool may_enter_fs(struct folio *folio, gfp_t gfp_mask)
 	return !data_race(folio_swap_flags(folio) & SWP_FS_OPS);
 }
 
+/*
+ * Prepare a locked folio to be kept active rather than reclaimed.
+ * Reclaims its swap slot if it will not be swapped, then marks it
+ * active and updates activation statistics.
+ */
+static void folio_activate_locked(struct folio *folio,
+		struct reclaim_stat *stat)
+{
+	unsigned int nr_pages = folio_nr_pages(folio);
+
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(folio_test_active(folio), folio);
+
+	/* Not a candidate for swapping, so reclaim swap space. */
+	if (folio_test_swapcache(folio) &&
+	    (mem_cgroup_swap_full(folio) || folio_test_mlocked(folio)))
+		folio_free_swap(folio);
+	if (!folio_test_mlocked(folio)) {
+		int type = folio_is_file_lru(folio);
+
+		folio_set_active(folio);
+		stat->nr_activate[type] += nr_pages;
+		count_memcg_folio_events(folio, PGACTIVATE, nr_pages);
+	}
+}
+
 /*
  * shrink_folio_list() returns the number of reclaimed pages
  */
@@ -1525,17 +1551,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 			nr_pages = 1;
 		}
 activate_locked:
-		/* Not a candidate for swapping, so reclaim swap space. */
-		if (folio_test_swapcache(folio) &&
-		    (mem_cgroup_swap_full(folio) || folio_test_mlocked(folio)))
-			folio_free_swap(folio);
-		VM_BUG_ON_FOLIO(folio_test_active(folio), folio);
-		if (!folio_test_mlocked(folio)) {
-			int type = folio_is_file_lru(folio);
-			folio_set_active(folio);
-			stat->nr_activate[type] += nr_pages;
-			count_memcg_folio_events(folio, PGACTIVATE, nr_pages);
-		}
+		folio_activate_locked(folio, stat);
 keep_locked:
 		folio_unlock(folio);
 keep:

-- 
2.43.7


