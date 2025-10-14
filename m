Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBA31CCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 13:49:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DD4E8E0122; Tue, 14 Oct 2025 09:49:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08DD08E00A7; Tue, 14 Oct 2025 09:49:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E976C8E0122; Tue, 14 Oct 2025 09:49:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D83998E00A7
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:49:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9572F884EF
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:49:27 +0000 (UTC)
X-FDA: 83996851974.07.A373AE5
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf10.hostedemail.com (Postfix) with ESMTP id C9113C000C
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:49:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q77B6gau;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760449765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=PuziYH5gOWikDOgxQXF5PeVelX0sQIVGWR2PEkRsfOU=;
	b=UFMs7amrrfXEUWjQ918rhAW37b4FlxCVlPkaCiz5Akps2yJ40+6DRH8Of9lpV3sohhmbo6
	5vC7cGyG2/zQV4iqF9S1Hu7uW+XXIANKvksenYjNSEcCA8Cl3c9/qwiD/YN/Byz030+XPJ
	o1fYnJwbPUqMShEUWZ4iQTm7LuIcEXE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q77B6gau;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760449765; a=rsa-sha256;
	cv=none;
	b=ulDvW5H4m2ui5SZ75WujBSS5uLklEAroPWdtPIXZnaCMHC2eiQ2yyd2oPbaqbUBooom7l0
	ELafkG0joYM+HLKogIBxnjVV386ZxL3+KMeBupWw8y8MhFO9aDnndp3WqZpOEeBTI4/5rl
	1DkNmYVlqaRXndgHz8ixs/wNC3N+MNk=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-46e37d6c21eso30155425e9.0
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760449764; x=1761054564; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PuziYH5gOWikDOgxQXF5PeVelX0sQIVGWR2PEkRsfOU=;
        b=Q77B6gauQRv5N+IjaOGT59Qt0FNNKjzCRcOmBneMqzTxhD1SM7r0pwMi3MiVvwo5aj
         vIEzMDhF49Qv7r2z9oXBwig113Xisrxe/oMWU0WSWfXB4RX0Ln1P/lql0bMpK1tu1/km
         d1ZsJFdKRq2oasNQSqOvcrGJ9rH6slLSGfNAbfbjqZ6sC8z8X0af1ZytKayqWAHyOtLS
         6rDiJuhHqJBp74pXo4KJSmBHVTijI13YvVMe7aR8CBKpYQp1qg78BW3WtVMtBowrwlCU
         AVoC8IIpT+CVxcDo5lCDTUp7PV9eydtQXK9U0gr3UHKaNsv5JYlNLDHq7VpuIaXCeglm
         Og+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760449764; x=1761054564;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PuziYH5gOWikDOgxQXF5PeVelX0sQIVGWR2PEkRsfOU=;
        b=WzZHDuFx1U/xHlBV0K6NGvchQt+BuALK+/tGim6wjSy4/2yh4irRUdCCLIJhAULEjc
         6OYImV+BvMgdErK2Sq1IgA+b8iHwHUf/mKKzYFdzGUfHFrc3ZlaTHOla/LDvE8C5s5oG
         A/HJXrZ5xRPMiEHZBmoycBhmckKE81NfXA9WuBKkQk5UKVBvQWf3u0yW6ovw9VXJZ7a6
         69kr80LRiBtkjkaYZNxNqSsYimdUpp7bH8ENCFzpYr6dOCi+dlPRSjuswxMXt1rG8lKE
         e57mUH29KXlVrst2oe50GHGS9SZYZzgQ7qse9oBddxVFQcx33sGnBA7RbU6Eh5Wz9WDy
         H7Jg==
X-Gm-Message-State: AOJu0YxuqDq7iOe5G1Dy9UDnoDeRqQ1scg8Cc1SuGwtJsuyXvPJDenVz
	JKCy4zEI7FIP1DtO7UBwNjGHxmM31YlI/cAgfUzgq+jWniMgXx+UQard
X-Gm-Gg: ASbGncsbDLRKYpqOztJEdH9Yr8cVR3LCZBd4GkF+AABlpfOw85RlrHDP0IsyX1f9k1j
	edCw5yuZyeBTlge7umOAu3VICHdzo69KQN4meIBIEhoajCsll5hIfqiexSuZOsUxVIYsRLLfQw6
	3973QCrUfgTE0lLTinbeKJiC5WO3v9xaTWMJGB0W61Kd69DyHG8B277DqL7bfBu9kFa3JtQH0Wj
	ywMvf9ncJElBmYhKptZY1/jETKYpsEmLnvyiCKipXXntIv9HQvqadltWdnDHJR3oCtPBfke4Sjk
	I7pnWCVPXwgTgyXgTnYY8EHQEWQzm6whnc8trfETHErjNFFSNxTAC9jPH1zWH+SB13sSKDXZgVn
	QEdRelBJm+BkpcXW6uvHs1X+UkuJHn2DiRoARmGcl
X-Google-Smtp-Source: AGHT+IHijAJjjMt5yZ1mK9H93s72p4Y04PKyBmz5nqKQa95WLDcndnjpOlWTw8ApSkOkSnZBYK3IeA==
X-Received: by 2002:a05:600c:4510:b0:46d:d949:daba with SMTP id 5b1f17b1804b1-46fa9a8f275mr176609805e9.4.1760449764091;
        Tue, 14 Oct 2025 06:49:24 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb49bd977sm240961315e9.11.2025.10.14.06.49.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Oct 2025 06:49:23 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH 2/5] mm/huge_memory: update folio stat after successful split
Date: Tue, 14 Oct 2025 13:46:03 +0000
Message-Id: <20251014134606.22543-3-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251014134606.22543-1-richard.weiyang@gmail.com>
References: <20251014134606.22543-1-richard.weiyang@gmail.com>
X-Stat-Signature: 9wtnqwbsqsiq9obdpcw3wr8f1swx6qx4
X-Rspamd-Queue-Id: C9113C000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760449765-708970
X-HE-Meta: U2FsdGVkX18qtHl2H5g0tVcgBt9zB9ykkmmdMPBw46mrDnesx4BJFLpjN5Up/MVjNyPyAT/EupQpFAlxbPvUK7HkjZ2URJT9ow+pHyplViyBUYu6QZ3mdMintnW4WhkZ8qdA31qWRtlEreqdCS3HSjhdUh9cnDvHUHE7LsWbcavjLEGU1D4GZB7B+niMDtzF63gM/+4nxZ3h7CVirRaHrcZMYbVL3dgbUvo/25/amuOFlwk68RNrGQu/gKyq1zjlA2fj5ty40gU1YNvavZrPE/kLR+6IgY++Jp+bpyhbdtMo13uu2pGAS+AL1zSuXdzLSl+kWqtkIln2DpYHWHcxA2HhZv8sm1yzWYqbo58iiuWiQGRQuGoB31MNuzMRZC2VnBv+77jhwwvK7taHU0Dt3tvFeWYCub7WFKr6sc0YI9l3vFwTpkTm90VJ940JXsAMCjMDRFRcEwu31Tef9l8zan9ljqoUC1uNkXfcV1m+oyNALJcetaV16bPxowQXvUr5u3Q6QBMMjmYSffOqqhlqUP+gFIPAq0wSZXuFjKmOcj76wASaHYxUeqfaud3bmUpWkN7y2vPCfiExIAcApFC1GkExUJa62UlRO+Id3Hn/EglvMtPB7O7Z7lY/k0RsvYANxVXMTIgnBLqvtXcKDbbzpLm0F7vwus0hfbXruQCATujRfQVtOGpxgubdV8+Inh1oZoeM47tbaU85YUwes/dUYWuMxSo6X9uS/wn/sBEu02BbRCyJ9TsisTa6Mk4ioWEYtWtiTk0fGBuB2+TgMEEvhZMJHyiqftaU7rCymGwRwWw2A/cb60CE1hCVzcdcjpisZ7kol4Qv1SIwqRZQWoscPEwqaO7KVm+ub0TweCMwoSazuYgO2fp/biuOPYGETOai5iKYdGJMJ7sbfvTe2+3jagIs2+r1p0HXxUEhCgkkvvO5Z1S47NPXsr9U5ucaeuIDpILK2YkXv/Fv0hEA3o0
 l6z5FAo3
 DX4zuXcZUPhp+gMwdlYKCr7z4itDgT55D2GFdMad/W9YIBDxXdy4vDAN1evgoM/aCHn88tchQ60tGJ/QfjzXO8deCci98QXkyb93qfRS+5cy6e/GZ3/0uhNvCaWg1cPggJx6+aZRR1uAYGCzwJgMT6uepE+sWb1RnYkANkqssz+ylVc39aECaLHxYlML0oZyYD6DAVbQdeH1J/YRxapWs9E/TY/zNVc2pvScRVlxRXwYVrsdPD+G02b5ngpPZY/4EH+m0FxrxW/Ty4E+8U3qKTu7OJBMWUaNgcdB2O9KE+Dfy+VDjR73uWxaLQbUkW9fWEYCv8x7pLx7dsBkVhAhdmMM13oTt4OzQRWNFRuIInY2XyuKNXqNxg+Unmvu71BguqIfGqc536gIZmJ8ZnhIOmYP/m7aHgwKoFgh3LeMPsZ9NlUL6J+85NmNE+fl/CQA2ykQKrdUjM3yUUUFCv0iosE5bge0dnxka3sPBfKFRcQAB94QU6HEHZLr3AQV3SeIZgtglqP2iikXK8CYViWusX2/XQvPHA95sNEuXh+QHcW6bEyq5udQUxTgFuOWAAPvAt6ZarlNaTDU6QAglyuZhOPXdTA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a folio is successfully split, its statistics must be updated.

The current implementation complicates this process:

  * It iterates over the resulting new folios.
  * It uses a flag (@stop_split) to conditionally skip updating the stat
    for the folio at @split_at during the loop.
  * It then attempts to update the skipped stat on a subsequent failure
    path.

This logic is unnecessarily hard to follow.

This commit refactors the code to update the folio statistics only after
a successful split. This makes the logic much cleaner and sets the stage
for further simplification of the stat-handling code.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 44 +++++++++++---------------------------------
 1 file changed, 11 insertions(+), 33 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 4b2d5a7e5c8e..bafbd66769ac 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3530,13 +3530,8 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 	bool is_anon = folio_test_anon(folio);
 	int order = folio_order(folio);
 	int start_order = uniform_split ? new_order : order - 1;
-	bool stop_split = false;
 	struct folio *next;
 	int split_order;
-	int ret = 0;
-
-	if (is_anon)
-		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
 
 	folio_clear_has_hwpoisoned(folio);
 
@@ -3545,7 +3540,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 	 * folio is split to new_order directly.
 	 */
 	for (split_order = start_order;
-	     split_order >= new_order && !stop_split;
+	     split_order >= new_order;
 	     split_order--) {
 		struct folio *end_folio = folio_next(folio);
 		int old_order = folio_order(folio);
@@ -3568,49 +3563,32 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 			else {
 				xas_set_order(xas, folio->index, split_order);
 				xas_try_split(xas, folio, old_order);
-				if (xas_error(xas)) {
-					ret = xas_error(xas);
-					stop_split = true;
-				}
+				if (xas_error(xas))
+					return xas_error(xas);
 			}
 		}
 
-		if (!stop_split) {
-			folio_split_memcg_refs(folio, old_order, split_order);
-			split_page_owner(&folio->page, old_order, split_order);
-			pgalloc_tag_split(folio, old_order, split_order);
-
-			__split_folio_to_order(folio, old_order, split_order);
-		}
+		folio_split_memcg_refs(folio, old_order, split_order);
+		split_page_owner(&folio->page, old_order, split_order);
+		pgalloc_tag_split(folio, old_order, split_order);
+		__split_folio_to_order(folio, old_order, split_order);
 
+		if (is_anon)
+			mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
 		/*
 		 * Iterate through after-split folios and update folio stats.
-		 * But in buddy allocator like split, the folio
-		 * containing the specified page is skipped until its order
-		 * is new_order, since the folio will be worked on in next
-		 * iteration.
 		 */
 		for (new_folio = folio; new_folio != end_folio; new_folio = next) {
 			next = folio_next(new_folio);
-			/*
-			 * for buddy allocator like split, new_folio containing
-			 * @split_at page could be split again, thus do not
-			 * change stats yet. Wait until new_folio's order is
-			 * @new_order or stop_split is set to true by the above
-			 * xas_split() failure.
-			 */
-			if (new_folio == page_folio(split_at)) {
+			if (new_folio == page_folio(split_at))
 				folio = new_folio;
-				if (split_order != new_order && !stop_split)
-					continue;
-			}
 			if (is_anon)
 				mod_mthp_stat(folio_order(new_folio),
 					      MTHP_STAT_NR_ANON, 1);
 		}
 	}
 
-	return ret;
+	return 0;
 }
 
 bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
-- 
2.34.1


