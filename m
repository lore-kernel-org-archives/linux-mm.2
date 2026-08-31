Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51EA5C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 09:07:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CA756B0088; Mon, 31 Aug 2026 05:07:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27ABF6B008C; Mon, 31 Aug 2026 05:07:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B81C6B0092; Mon, 31 Aug 2026 05:07:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EBA5F6B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:07:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7785DA042E
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:07:00 +0000 (UTC)
X-FDA: 85160985000.11.17C52A9
Received: from mta0.migadu.com (out-4.mta0.migadu.com [91.218.175.4])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0198F1C0003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:06:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="LB2AA/Ev";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.4 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788167218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=77r7HGecFPubCuPL26GMR0jGS4gIz2T+4WOD8u3JrBc=;
	b=1NKncX9Yu4fXcuq81ZqR2ba6C5LaPinCiBcqc+45snH32fop5qKPOv+/nnptWFmy5BXI2X
	mi9EwzSUfGB6/Sxvxcxa9jy0reOw7MSzoe2OAVLrM0TNb2KJ46GEiGRiJpmxry/0ycC4sT
	BM0ANGqPqHl+8BFbFtRQXd8CV/Lm6/k=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="LB2AA/Ev";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.4 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788167218;
	b=W9Ts9o2flLQK6DMH2rln7eMXhTJF9SYWWjXKSdZKEfVk0XOE29Z+zo0IgqtOShybEly0cF
	NADPBbMo0gdVaJ1MaY1uuo/22xHPNkt1lVNKPWipISrQiVQofYgX6XWpj3KIPyPXarGrTf
	o+2NdDNnKgeR0W9THSJRui4lMmzXUOU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Ay756BWLfvfN9kwsl9VEisA10j5cWcMCG782Tfg2UzM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788167214; v=1; x=1788772014;
 b=LB2AA/Ev9SQYA2GlWJb9apZEO35ewz7AFMMOmEQEclNyT56m7q1trzlFRH5RLto0/GqGk7Pf
 9dCade1Ej2bRN3a4EbKGbhFVXPNySoE9nHBbFSjsei9CR7fr2pZq1NI174zQvTQQb2rqeSn10xc
 eS77RCvV0+rmmg6mhCx3HmwU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 589db87ed55c533a;
	Mon, 31 Aug 2026 09:06:53 +0000
X-Mizu-Trace-ID: 589db87ed55c533a
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
To: hughd@google.com,
	baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org,
	vivek.kasireddy@intel.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH] mm/memfd: don't unreserve hugetlb pages on -EEXIST in error path
Date: Mon, 31 Aug 2026 17:06:31 +0800
Message-ID: <20260831090631.29227-1-hongfu.li@linux.dev>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: djqadxhx6nfjcbpxds9i14hos4aoz6og
X-Rspamd-Queue-Id: 0198F1C0003
X-HE-Tag: 1788167216-354573
X-HE-Meta: U2FsdGVkX1/CCpbQlm1Jh9HwmtaX2dTttraspKNOZ2YLCUNIiLHaTxk1+p64Mo1LLKLstKpKo9OSRW/wBIGHmLTgnFr416IgzAiN5rzIDiLOF6AalV96m5G0K8USJNGnB/PigIqFn5yuivDZuTbs8mRBHZOakOqWmqvN49u/OU46hZ0AZxYRM89gifh1KF7/IiBZP9PWq20juqu2jp2MB4Gms8CVjbJs/OBYIhYXdRcec0bGSZtDqZT+mTpT3YMKmNyu7MFbbhUbcdx27q4EdAHIJHOvW9ax6wpCYfYiK23a+LUd/9nQWCMsRQ0Y0/LKK67OgNZ6flA6u/IO6QU3WL034MVAHZNMu70COUF89is/krKcfnrpPbHmZeGJVSU8NOhtBimx/3Z0wPwJqZ0m36KLle/F8kc7o3BidatvdvN/YoVTYmLheCl4+uqoppDVsOPvpHXB6U1i+/f9gXFH/iR92HO4WSBA5IpHdxibEVHT2CJzqxB7TgZl6EKGtdqSvTCVcG2cFvIzHDP96pwqMhu3JVUwfEbtYdvaS4Ms5Phr2wjEbOrNYyp8MOs1u1jKNKHgBNZLUbACnC0dCHKYEcb0kd4zTtJFn1+VOrtvBNq7s6HazH98VZrRnGG1RUPAAKTxX0DLYTjQQsNB3h6YaX75/XJCB521BIHuMXYxOHB0PxfdzvDgx1L7qpXwyHGNtaIDoDOqskgcu6AZcSxkqFQQogacH36/U9sDl7GZzhg0sHnvZZPaCMjb35Zj3WVdupyDO2KHGDCWxGq9apXlZzl+JDEphvW4DagJ7T2pJivofWDSUdjHYJ8Y9GIjPXFObLyTLgk3UvLc+mPq0W/o258OIis3yO+yYsKdHpQjHB0ys+E4DgFe0D0IsR8rwh3i5ZfU6iCEeD1nCpkeFd2w+n1RUMgPR4hzjxePOc54OU6W0/TmCP/CB5hWiKR8R4iFG6/fUJfbEj1KQJ5OBv8
 MDLygFmn
 o55z5XsMP5rTH+uFHdoun8w0tRxTTQtcNk3Aascv2DYgxzBhH9Rufz59XPifJhoX7diA+CwU1jbC1C+y2yIQ7zGV8DzB9DdOYQgKjvbsKvY+9Rn5HuNm6nYrEOZY3nqQCuOyY6+kp6t+ebG1azZjaLilxGz38wQxKHipzl8HM03hDROUuMyUnezUxN2SiDFPxwu3Okj60O0UNisdxXgFuIm1EpYOKEt+2Tql0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongfu Li <lihongfu@kylinos.cn>

If hugetlb_add_to_page_cache() fails with -EEXIST, a concurrent fault has
already instantiated the folio in the page cache, and the reservation now
belongs to that folio. Calling hugetlb_unreserve_pages() in that case
incorrectly removes the region backing the cached folio, and a later
truncate or inode eviction passes a negative (chg - freed) into
hugepage_subpool_put_pages(), corrupting subpool and resv_huge_pages
accounting.

Skip the unreserve on -EEXIST; failures other than -EEXIST leave the
reservation unconsumed and still unreserve it.

Fixes: 717cf9357325 ("mm/memfd: reserve hugetlb folios before allocation")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 mm/memfd.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/memfd.c b/mm/memfd.c
index c708d92533f4..1b65bc22fb19 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -128,6 +128,12 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 
 			if (err) {
 				folio_put(folio);
+				/*
+				 * On -EEXIST, a concurrent fault has cached the folio,
+				 * which now owns the reservation; don't unreserve.
+				 */
+				if (err == -EEXIST)
+					return ERR_PTR(err);
 				goto err_unresv;
 			}
 
-- 
2.54.0


