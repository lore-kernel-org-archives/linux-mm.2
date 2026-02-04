Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2508EEA7946
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 21:47:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6258D6B0005; Wed,  4 Feb 2026 16:47:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D2CA6B0088; Wed,  4 Feb 2026 16:47:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D1296B008A; Wed,  4 Feb 2026 16:47:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C20F6B0005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:47:48 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BE5AF160349
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 21:47:47 +0000 (UTC)
X-FDA: 84408111774.23.A8096A8
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id 069E01A000B
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 21:47:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GBqmuE+y;
	spf=pass (imf19.hostedemail.com: domain of 3gL6DaQgKCF8GF7NFV7KDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--jiaqiyan.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3gL6DaQgKCF8GF7NFV7KDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770241666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1C8BsUE0cw0C5/pQHANl3vMiV1SA8sa3LG6A1Szcvck=;
	b=jkbgAk6PB/TauFq/Vmy27ta7JXCq7dBj/pdp9Zv96SExQF0q6TsqYoBvziPO02QClRQHX1
	ewnqfCn0CDBPXi4gyBp0V6ME3gBHqV3sJdU+5cJsIYNNbZXxTWS0cOBHbc77+OavqAGy8w
	bWJvJCm6sBWQk0hBwTzFCSBxvbwuT9Q=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GBqmuE+y;
	spf=pass (imf19.hostedemail.com: domain of 3gL6DaQgKCF8GF7NFV7KDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--jiaqiyan.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3gL6DaQgKCF8GF7NFV7KDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770241666; a=rsa-sha256;
	cv=none;
	b=rzAd4wpCPR88UoxWR79ItcyiuSiTJpraxjVskSiwI3Es9UavXBwmTNCHB10KyUMKSZiMWA
	drr0eTaitcQylVLYQnuGN1PzXy/NrkrBzVIs5FpMfzFu1Gk6sEqB8bHbmhF7gi4ho2jrad
	0vznSQivLk/T4tMHBGRcojwNZe8B/fs=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-353049e6047so109531a91.3
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 13:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770241665; x=1770846465; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1C8BsUE0cw0C5/pQHANl3vMiV1SA8sa3LG6A1Szcvck=;
        b=GBqmuE+yTi0SuPOz0eaQXayvUP1R0JCfeewq6AF60dHLnGqQ7Gg14nOx+Ag5BsVZZQ
         KheA6G7gqbSSZCJ1wlXWb7MDhQCvdTYXWeOE+Go4CW3QAats4v1mdoPd5usEwzIVoxeQ
         xcckekyeuwe6fAhdgDJ2SH6WiuC5HA/WUbGQanXZTydESgnhdxI+D83THba7m+IfgZnG
         QvJysSy9qgyNqR0bWE+6gzQvU8PeuokMRgu5qwxH9yB0Z0UkozCehg2q08v8wqbrw9qX
         cq9TkmKQR2AtxtmturdVggOejgrEIoNPRm9ViGYByYvbg6KgAexF11pzXpEqLnVj31Wo
         ujvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770241665; x=1770846465;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1C8BsUE0cw0C5/pQHANl3vMiV1SA8sa3LG6A1Szcvck=;
        b=WTFjJobnyzMSfrdg81U+X1cHcpwdM9ndVsv22DmB0J9gPSkXyNblalxUTVCyksIpgB
         eZX5Qam0EBtXXQOZLKLTTeAz3vbKbxx6QwGdz1MmLlCOO5zmx+5Nc63xC4FZTBvaP1+m
         VSFtHNLf9OLqgaIAreweVygOsGwbfl8IsC8z3Sz4nQlAdLZzr3E1atMjkXOSPxu/SvnX
         e5ORl5iocFf6nf4S1uSPwUdWFHoZV8uC4UmJwuX76a4q9/BBwF0eP0V1yZVceX+QORuw
         zxo2rS2s6GUsgfTLaaeNcuW9+nqU0D3AACv2h7M/MKOKr88Xs6UmVuqgYYrMuFQRESdY
         vVCg==
X-Forwarded-Encrypted: i=1; AJvYcCUPXTbHUiyA0YLabm7YPo6/BWcH2l97hwQVtTdheLTw2DtLwHGXlIka3ee6+QrRqJYUlQmaR1rt4Q==@kvack.org
X-Gm-Message-State: AOJu0Yz29laEv567XY9GB+XC+8vJZ8q6sDjgYCjzBKCr8SDPUKlzuzOS
	HUl9PqdjtjmUVe7vYWoo3Yu2K5sVJfGwFeaSoZOqnXB4BBn0fXb377IECtgNp0nnRwZK324onZk
	zz6607nFThbT7Ig==
X-Received: from pjuf20.prod.google.com ([2002:a17:90a:ce14:b0:34c:2ca6:ff3e])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4c84:b0:34c:6d33:7d34 with SMTP id 98e67ed59e1d1-35487123756mr3731737a91.16.1770241664741;
 Wed, 04 Feb 2026 13:47:44 -0800 (PST)
Date: Wed,  4 Feb 2026 21:47:41 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260204214741.3161520-1-jiaqiyan@google.com>
Subject: [PATCH v2] fs: hugetlb: simplify remove_inode_hugepages() return type
From: Jiaqi Yan <jiaqiyan@google.com>
To: jane.chu@oracle.com, muchun.song@linux.dev, david@kernel.org
Cc: akpm@linux-foundation.org, osalvador@suse.de, william.roche@oracle.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 069E01A000B
X-Stat-Signature: 5kpmyngdqa6mx6qawoeyt1gzk6xgcjc1
X-Rspam-User: 
X-HE-Tag: 1770241665-438128
X-HE-Meta: U2FsdGVkX189TY/S7v9JdmHNN9QC3iwQfTWWo1bxE/cSX37Q99X3iDJypQoKtu40d+Ad5uQSloY0Xis56hTMNE6/ODZ9hH80QewjV5M4ahE0TPJwetKsDz3y7Ob4MHnJVrMl5Ue0Wca7mlTTWAq2qnS6BKFd4rFqzA4sBPYVvNgUfuFWfl9wnDYPALbfWWXlqGvwe31RjKe3XJeoffxrvs2CyWq3pFcYwSJ1ivWesN4BKtJ0ZJn6DOQbKQLY3XCn6qUtdg6plAunPS+2nYVpaOd/iv5BGVb9DVdH901MpsYbquWCQR5wc1bztrkqbkhy0+WiEaNXC4YEacttkEL59qC19Bzy2BpSeiIj0nqRaTJxi4HVePT12h3ZOGpp16s0z7g/NkWFnoPZTl5gpRqER6AzBbbYnfnPw5CCSCEBlqh+cg/LII8Gp4Sz9ha5TSyMiNoJR5BjsABkaepcWy1XAri2d7/Ztds17s/JzSQj4+p3tr6vX7wXs3/gixm4lDivfErDyZcr3vUUpFz5Os6AHfwta5I11/4Q9h7LtFv3wsJeB3WIakoqTkWYgp2jobpCVAyKe2zL8anX0yy8vJHdRMq7ncWhXB9rUlrhNZ0Asx0YeAxqMHf+P8FwXOVK1CwgLEgRhAko4tC7E4x2uUD/QbXnFebGmU32IhQhOz/qOlcO2ssWeCNMf2FAcCIcGaFy78CNs9TMRHMY2ohxIYUKyEt7us6MDZftI3UG8fnlT5lPwUKbmV/+6HozEuUl8i4w8bodH4BrpIOA5mWIK5dyGWH+UWoRju0amlBo8oc0OaOztKWNrbV2m6503TiC/9VA1IfgMphrRyxCnUTdLTLCgOjFaGuIZmAhHLUCgVlNNdOaA74LzkkHrS7wTBi98UJGW4W4IXyjX+8VZg6kYpvuCwPBkjyA96w87Iz4De8cTnfcMvkJxzxk6CJL2ZoMBI2PTVj6kOnk5VqmtnUZRwy
 Iovx7JgE
 4wCrkUiPxkBd8fKj4sH/CJLt2bi3W5bA1c0BsGne7OYcQ+BXPb3poInp+/ibvZAGI/EwnJZG/COpZad94ecMoNKmL4ukYrNmVydD5+HcpWdLUE+NftXz0yqi1Mt1ypO45Igm3pn454AXlvfZlvNjfKqR49uVuXBBgg9OE1+EjsgRGzv7Iu5yniFqwoiE/QxhbYxQEIptRuQ+ShdeLQpJIIobtcs611aC/BduE4IAaLpzYYPDyeINoPIeqRZZA1XvaEGsf5h3EgDnyZK+zLZIJsFm66HU+xZ4gwv3ojpoNfsxwyFyJ0Chkl+hTVSmG+DRqHbT0l55EI2L7fQFR9BJylLrL9EywhmT2UsHXo+XMhtlHbQyR8xYBo3GcQHQ31AWzYYBjPUpFKzjOI7rbfNTmhwbOyjqc863l4tRMEooovqLyGiku6xml/xVknPCgj0mSpbOC8cnbqgoavybVgahp7SJhTCYplBXixkV2eitQ9z0QpKkCMSZn16LFUmezZSTMXRCsXVY8uLCuKY2V7Ff4UpGUG8GGFL0MKjMXuQKmeY7cQEBQu+YRhIJL+L2DXZAOSbkCw6eonzuO0gNi+93nkFD5HD8ri8THYAB1Dcfv9jzSsw+lji7+VOPLPjO65++Z2+EX4+y0IM0Z674=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When remove_inode_hugepages is introduced in
commit c86272287bc6 ("hugetlb: create remove_inode_single_folio to remove single file folio")
it used to return a boolean to indicate if it bailed out due to race with
page faults. However, since the race is already solved by [1],
remove_inode_hugepages() doesn't have any path to return false anymore.

Simplify remove_inode_hugepages() return type to void, remove the
unnecessary ret variable, and adjust the call site in
remove_inode_hugepages(). No functional change in this commit.

Changelog
=========

v2 -> v1 [2]

- Use two-tab alignment for parameters wrapped to new lines.

- Remove return type in remove_inode_hugepages()'s comment.

[1] https://lore.kernel.org/all/20220914221810.95771-10-mike.kravetz@oracle.com
[2] https://lore.kernel.org/linux-mm/20260202233617.2350734-1-jiaqiyan@google.com

Suggested-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 fs/hugetlbfs/inode.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 3b4c152c5c73a..09c88c09718b4 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -513,15 +513,11 @@ hugetlb_vmdelete_list(struct rb_root_cached *root, pgoff_t start, pgoff_t end,
 
 /*
  * Called with hugetlb fault mutex held.
- * Returns true if page was actually removed, false otherwise.
  */
-static bool remove_inode_single_folio(struct hstate *h, struct inode *inode,
-					struct address_space *mapping,
-					struct folio *folio, pgoff_t index,
-					bool truncate_op)
+static void remove_inode_single_folio(struct hstate *h, struct inode *inode,
+		struct address_space *mapping, struct folio *folio,
+		pgoff_t index, bool truncate_op)
 {
-	bool ret = false;
-
 	/*
 	 * If folio is mapped, it was faulted in after being
 	 * unmapped in caller or hugetlb_vmdelete_list() skips
@@ -543,7 +539,6 @@ static bool remove_inode_single_folio(struct hstate *h, struct inode *inode,
 	 */
 	VM_BUG_ON_FOLIO(folio_test_hugetlb_restore_reserve(folio), folio);
 	hugetlb_delete_from_page_cache(folio);
-	ret = true;
 	if (!truncate_op) {
 		if (unlikely(hugetlb_unreserve_pages(inode, index,
 							index + 1, 1)))
@@ -551,7 +546,6 @@ static bool remove_inode_single_folio(struct hstate *h, struct inode *inode,
 	}
 
 	folio_unlock(folio);
-	return ret;
 }
 
 /*
@@ -599,9 +593,9 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
 			/*
 			 * Remove folio that was part of folio_batch.
 			 */
-			if (remove_inode_single_folio(h, inode, mapping, folio,
-							index, truncate_op))
-				freed++;
+			remove_inode_single_folio(h, inode, mapping, folio,
+						  index, truncate_op);
+			freed++;
 
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 		}
-- 
2.53.0.rc2.204.g2597b5adb4-goog


