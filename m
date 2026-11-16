Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2DF6606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 22:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=YoJqUPPg
Received: by kanga.kvack.org (Postfix)
	id 094BB6B00EF; Mon, 16 Nov 2026 17:16:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0464F6B05B0; Mon, 16 Nov 2026 17:16:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E76966B05B1; Mon, 16 Nov 2026 17:16:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB59A6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:16:18 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 370AF40252
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:16:18 +0000 (UTC)
X-FDA: 85442391636.12.CF2C5BD
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by imf04.hostedemail.com (Postfix) with ESMTP id 513C540004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:16:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=YoJqUPPg;
	spf=pass (imf04.hostedemail.com: domain of 3rID7agoKCPkkuipvhiupohpphmf.dpnmjovy-nnlwbdl.psh@flex--jthoughton.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3rID7agoKCPkkuipvhiupohpphmf.dpnmjovy-nnlwbdl.psh@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794867374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=L7R1P89DbfMkM5Fqa2JcHWcdkWhJH7Nt4jSHJnkgB4A=;
	b=DGOPaJLckgC9rounHYLoh5XyOQQSWVUseS0WFm2qDCg+j5RuDAFBpjXNU8asrlpCSYJQJq
	1jezu91X2kuZ5PRJSy9oy7FlHkSBDZF5BfXcc8cfE6dWLvFw1nhXV1PWXR4yDFfcX15gMQ
	MfzJTy54KfjP4naynqQkP7gUMRJ4YDU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794867374;
	b=Egq1A6WXiigAYcaVYNRQe1grTTF7Jd5UAykDLYiXE7yOtgp9QqasZCPR6dwtyOZdrNthoY
	y4lQ6bzZa3x1+erOBpkJHk0KgRRHaP/Ur8l9JNo99sK65tyIqDy56Svj9kGogpMFQOBCfK
	ea4iVjJa66dA9x9W0uWIadRSkLevSMQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=YoJqUPPg;
	spf=pass (imf04.hostedemail.com: domain of 3rID7agoKCPkkuipvhiupohpphmf.dpnmjovy-nnlwbdl.psh@flex--jthoughton.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3rID7agoKCPkkuipvhiupohpphmf.dpnmjovy-nnlwbdl.psh@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cdb45b4ed6bso3714148a12.3
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:16:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794867373; x=1795472173; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=L7R1P89DbfMkM5Fqa2JcHWcdkWhJH7Nt4jSHJnkgB4A=;
        b=YoJqUPPgamf+p57woJCY4n2dOIoZd8IGMNmfohYPlFZmLx2WH01SplbphOuFrHYKs4
         W3sv7V961SLjRgDmXzO2JzUJuSDAIXPBMqQYaTVvc1QJpMc3Qk9I2CoU4S2WIJW3UtuP
         Q/pDk8kQvRON5kKe9/5ysioBXAgpaox1DyLY9Ht5uNrCmMfQFKVN516P5+O2n8+2bY/A
         iVe5a4cOlEs3MGEZqHLDhkuSgoB/gl5J8d0Q/N0Jpl0fTSN9VHVSiDTQVG7TOI68qxx8
         lSbfYJgXWAPxqE3L8HebCpa7X/IIKTsfHAIArO1PWhEsbDZHFeQSLUdJSU95fZLqK32U
         +2ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794867373; x=1795472173;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L7R1P89DbfMkM5Fqa2JcHWcdkWhJH7Nt4jSHJnkgB4A=;
        b=VZNxQVbwAd6D6GIJphluC29QmCbuLx7ptN2PJT9n0R3eXFE/mshGsRUR8PjLimpR5H
         GlHuEprh5fYsTZwneUlWg8xGtBmFxTO9Ntas1LRZCJgBPAmKhaNKXtshfzeqr3OGyXWk
         1lToi48LYZeHKllgg5FTyHH+9V+5DB4r+8poXXS/Cc05etPgGMM1DJYKh7D66WEILY6l
         QN5tLmXDjWljSJk4xfmpnG5VPAM3ELuO5s5AcE4yBjJIJkSIvBCdRkMPDUv6ituxo0wx
         djumBh7/S7kIq0PlJzTGseBYpFit+KoyeAD8fbcVwUxD6jKYp9bJfDN1z/XDoz4FyC4o
         opSg==
X-Forwarded-Encrypted: i=1; AL+hErGi55RIi80wlo+ZfA03V0L2RsdEnQdPn9TilH2zgIUisOXZ0Ped2VOhfoOPnHDYI5exIRK7+l1+yQ==@kvack.org
X-Gm-Message-State: APuU4Z8BWsvCMUGVFeCBTW1kGJvRjwsO6OAbC+AAKWaREjwfwswVEU9H
	fkpAthxu5ZnGQpwTcCcUbsXCMLLiXacSS/m54pYWjZP9xkoCO84fe4MldIfcFrzDiRq5KKirjmT
	6cx0YHV9XrdqiKfZPplIE8g==
X-Received: from pgcle8-n2.prod.google.com ([2002:a05:6a02:8b88:20b0:cdb:5eea:8c6c])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:2590:b0:3e1:282b:b69 with SMTP id adf61e73a8af0-3f7a7bc2dc2mr12230987637.28.1794867372545;
 Mon, 16 Nov 2026 14:16:12 -0800 (PST)
Date: Mon, 16 Nov 2026 22:15:57 +0000
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.679.gc527c65306-goog
Message-ID: <20261116221557.3128331-1-jthoughton@google.com>
Subject: [PATCH] hugetlb: Don't restore vmemmap of non-HVOed folios on bulk
 restore error
From: James Houghton <jthoughton@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 513C540004
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: orwrty3b5rri7hbrxb3uctqm8kh957dr
X-HE-Tag: 1794867374-972434
X-HE-Meta: U2FsdGVkX1+QlCZWENiIm/CVDNCg9YdPX13/vPHjB2iW5qNDFmootSJO7mzgEDYzFMioiun9NF3+Vy38nC2ZOw71XtkYZQ/xkunZFZfLTcdXtUYtVmyy15PuYvsJXHXdQxzFlqCZYQjgXk64M0JL9mqDqyHNlg07KC9HZ1hgSgXiZR+v4QHrJLFy/7K++EpSBlczQ0ukJiJ71AXdLUD0Zi2T9wI/gtsZt0NET4hUjCtXelfuYnmtVLTI8qq/u75geH16m76PRpIKjznQuUB197LvkSGI7gfoLkiXa/6WocrAJFWfUz6HPjS+1OQ5pzaq3YwpadYLWMm9bwjZ8wVI0BesF7pogiUfWjsWZ2mD2eUfe25im50qjOcQQ8twNgU0T7zrQ9h9Og5QKiXPzfH0Vh4NIucB1LWORQcCH/jr2p0VJ+wN+d/8DGxw04pnCYzYszZtDcMauumEyt3gn4O39x1DvD2AuprHiZhjC77pZ2wXf6QPSpv/XlYPNPLbhgmGrgFMe4yHnocrP/+lcqVj3FYofASfnF4pBmGuamdvztAl4glht0WiwNusv7GW/CzALJ0em78CXzuD8sCFlRW8KlFRPc3ziH+5EJk4IgIo8lT0PUiWYCnVJU5cgIpnaYh2m63Ytm+Y04LBPf8/i/8VaB49wfQZ/2vL0tViSsny6dSwYhDipQj4JNMZslMWtrEeJjA0N/qare4d4VVpYGJxDnH5H6a4tQw1Oplm7A9Ly5PhbE29Q6uG4sys8A2epTpYBnwMO9CLDSGG5KPHHWlPETP69SEZ36y55IedzU7zZ8+Vi8SFrQLW8iE/QZFp/+P19kv+7nIazAnghKG0pDKtf/dhUgwnPMEjQGN81AlZNkKCYeSMvZaO8X62a1wy101ldcHOQF9+o++cet1ekd0OdDekBnehQz12p6wFINf9fjbTuvB690d5lXG85VV/G0gdrBtIEX/EFvlIjTQlqm2
 oJkgkeDE
 4Qtsq54hSh9qKqzh4E3xkZGAMEFZutY57IXOwIzRATjkQM+lKLeZ5XQ/BkwK1vn7ZWiIi/mIadRH5cc57hIbjLJffwe7PeqOmhEg9RlmMtPWZ2SgZpg8MIIKc2C6a7VzHuPvaoQ8U7qLuPfETJhUqP3YWSTY9Y+8f06BENgeWV+dGjRhadnzEMilasTRDxdsJk6StA/cUTbbSwN8bCobKrezIdNsVg1CdEBw2Cst+3QaRGOBZSC7V3qNjZ16SwVSoeZTgL6qPydApkBcKmQj4Zi4xmNlAUu3PYWt9HjKf2msz+g26C01Q3MaOOU0RxHk7KcGCOFDYKXXMg/tq02YfS3TytJxNAYkw/HX89RuXfkhuKAGoz+nM2Ng2VK/zwIcYRRitwJ/2WG5Q2T6qjWo5ivXNfRFtyx9ThVkdjsreNgumoroW38/2ewWwy9vCqkpBXf7yth7DwFFRiuyCJbYR0ykUxsVMKtZOWdiQdGcpGftldGkz4C+EoTw8fW5CjCLOVCj6SD+fmJ9XbECNyLLzKTbUnnvUtkB7vUhOd+Tw3ahOpFr9qyFRi4O7fhPocuzTP55S1oo1BVlLGiHIf2kGQcT33VPQ+XzivspxeICSazlmj+aDJezBgcTP3ABbtXX7qcmS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When hugetlb_vmemmap_restore_folios() fails, it stops processing the
list, so folio_list may still contain folios that were never vmemmap
optimized, e.g. because HVO failed when they were allocated. Their
hugetlb flag has already been cleared by remove_hugetlb_folio().

If no folios could be restored, bulk_vmemmap_restore_error() then calls
hugetlb_vmemmap_restore_folio() on every folio left on folio_list,
including those, which trips the !folio_test_hugetlb() check in
__hugetlb_vmemmap_restore_folio():

  page dumped because: VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio))
  WARNING: mm/hugetlb_vmemmap.c:503 at __hugetlb_vmemmap_restore_folio+0x270/0x300
  ...
   __hugetlb_vmemmap_restore_folio+0x270/0x300 (P)
   hugetlb_vmemmap_restore_folio+0x1c/0x30
   update_and_free_pages_bulk+0x2c0/0x368
   __nr_hugepages_store_common+0x2e8/0x3f0

Otherwise this is benign: the restore is a no-op returning success for
non-optimized folios, which are then freed as intended.

Skip the restore for folios that are not vmemmap optimized; they can be
freed right away.

This is very unlikely to happen without fault injection, as it requires
both HVO and a subsequent vmemmap restore to fail.

Fixes: cfb8c75099db ("hugetlb: perform vmemmap restoration on a list of pages")
Signed-off-by: James Houghton <jthoughton@google.com>
---
This patch was originally part of the series that enables the HugeTLB
vmemmap optimization (HVO) on arm64, here[1]. It has been modified given
the feedback received at [1]. Based on top of mm-unstable.

[1] https://lore.kernel.org/linux-mm/20261003002123.505555-2-jthoughton@google.com/
---
 mm/hugetlb.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index cb2de24affdc..6e9f3fb04a3c 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1628,21 +1628,28 @@ static void bulk_vmemmap_restore_error(struct hstate *h,
 		 * If are able to restore vmemmap and free one hugetlb page, we
 		 * quit processing the list to retry the bulk operation.
 		 */
-		list_for_each_entry_safe(folio, t_folio, folio_list, lru)
-			if (hugetlb_vmemmap_restore_folio(h, folio)) {
-				list_del(&folio->lru);
-				spin_lock_irq(&hugetlb_lock);
-				add_hugetlb_folio(h, folio, true);
-				spin_unlock_irq(&hugetlb_lock);
-			} else {
-				list_del(&folio->lru);
+		list_for_each_entry_safe(folio, t_folio, folio_list, lru) {
+			list_del(&folio->lru);
+			/*
+			 * remove_hugetlb_folio() already cleared the hugetlb flag
+			 * for folios whose vmemmap was not optimized, so they can
+			 * be freed without restoring vmemmap.
+			 */
+			if (folio_test_hugetlb(folio)) {
+				if (hugetlb_vmemmap_restore_folio(h, folio)) {
+					spin_lock_irq(&hugetlb_lock);
+					add_hugetlb_folio(h, folio, true);
+					spin_unlock_irq(&hugetlb_lock);
+					continue;
+				}
 				spin_lock_irq(&hugetlb_lock);
 				__folio_clear_hugetlb(folio);
 				spin_unlock_irq(&hugetlb_lock);
-				update_and_free_hugetlb_folio(h, folio, false);
-				cond_resched();
-				break;
 			}
+			update_and_free_hugetlb_folio(h, folio, false);
+			cond_resched();
+			break;
+		}
 	}
 }
 

base-commit: e1f34fb16e0236c4e60b5f392f1cf5aee76f7d0f
-- 
2.56.0.679.gc527c65306-goog


