Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2257C104891E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 22:16:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9E7B6B00B9; Fri, 27 Feb 2026 17:16:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4C426B00BA; Fri, 27 Feb 2026 17:16:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4B906B00BB; Fri, 27 Feb 2026 17:16:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C1A246B00B9
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:16:18 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1CA761B83C5
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 22:16:18 +0000 (UTC)
X-FDA: 84491646036.09.7993CDD
Received: from layka.disroot.org (layka.disroot.org [178.21.23.139])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9F7484000D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 22:16:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=disroot.org header.s=mail header.b=h0Jo5g9c;
	spf=pass (imf17.hostedemail.com: domain of mcq@disroot.org designates 178.21.23.139 as permitted sender) smtp.mailfrom=mcq@disroot.org;
	dmarc=pass (policy=reject) header.from=disroot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772230576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pZgn6EROfNCTDjJXVBWH85Hc5zFSfKEyA5xUTLk80M8=;
	b=Z5cjii7n57Yovx+oSCsXREF404Q5ASBzCVdXoy1ZwBwMFHegaPq4YOIYdOB3DhAo91qiDt
	vmxxd4jdUeT1APCfV5NttEjBRGr9deTfrl/iRmcOOHzmvm9w+Rb9TXO82zUgvKbpZAkoZp
	8iGV/u8nmZHKq9pwA4s3k93hvaaMFG0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772230576; a=rsa-sha256;
	cv=none;
	b=0N5N0G8qJJ4+2JKa4wUzJwWiJQqkSiHQswdxQnqxPgpdeJqx7BNKgH4VdL023e8hqPTwQS
	HsFGKaL8v1fLfRh+cczPb6S/lbIPxO17M1E6wmwVNchS5cLzG1QhfTT6DzFxdJBFTnhOhq
	z62IRej28lW5DLz25BXefDHIy7U1+kA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=disroot.org header.s=mail header.b=h0Jo5g9c;
	spf=pass (imf17.hostedemail.com: domain of mcq@disroot.org designates 178.21.23.139 as permitted sender) smtp.mailfrom=mcq@disroot.org;
	dmarc=pass (policy=reject) header.from=disroot.org
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by disroot.org (Postfix) with ESMTP id 68D64267A1;
	Fri, 27 Feb 2026 23:16:13 +0100 (CET)
X-Virus-Scanned: SPAM Filter at disroot.org
Received: from layka.disroot.org ([127.0.0.1])
 by localhost (disroot.org [127.0.0.1]) (amavis, port 10024) with ESMTP
 id MmUHzmlSBhrO; Fri, 27 Feb 2026 23:16:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=disroot.org; s=mail;
	t=1772230572; bh=M1kB3xBO0gGt9Cq4a3VvzqYU8hJTnWIcMiuRFk/Dh4g=;
	h=From:To:Cc:Subject:Date;
	b=h0Jo5g9cRVnkUCNWUnuwgH/XGHTH4M2x8kSFlCE1lBYpa9pQ9KW6cKtOz7e42XAw0
	 T/3mHdSmWuZYbBDjyTc0jPv1Z/evHjq1hq72/vS61a68xdVPAPqxktzrasfOpx7Kew
	 GS68b1Rcse+K119wZyiVv+FcfQ5OkbCIiOmhbLxqaBn+c5vQkuMFrWpP/f+E19FHOe
	 EotBVYjisw/m4E0OxbslAOMkZ/jOEm2ll3AFP+N7Ax3e8vn/G+d9H185tGzFS8fm9Q
	 rY9hwOv1OWK7nKrMcBQFcgxFwLVNdmrcP+rPUjGJOtmVcHWP6RQSOuqGRXYs+64Tg4
	 cwwZl4rNzKb2A==
From: Benjamin Lee McQueen <mcq@disroot.org>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Benjamin Lee McQueen <mcq@disroot.org>
Subject: [PATCH] mm/vmpressure: scale window size based on machine memory and CPU count
Date: Fri, 27 Feb 2026 16:15:55 -0600
Message-ID: <20260227221555.29969-1-mcq@disroot.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9F7484000D
X-Stat-Signature: e1bu433obcing18tym9npzbhnmz6unsh
X-Rspam-User: 
X-HE-Tag: 1772230575-981608
X-HE-Meta: U2FsdGVkX18bpIl7U9yCWN74pLkWrWAvcWTrqjsMZc0MYvTwgOtS8pOboZDbtbNrsUso2mOG69WQ2g0UNm3CBCy9EtHuC1/kcwtHkw40Z6wSMHwhCugpQfhJTPGdY1CTiSU8SGYCPOKcxjvM79flFoCzgdmoxp7wFLSUq2Y8cv+NKSjGOlPqH2R4q/2aQ7r8Nc2oPtZdKg48PMBZBGXdwo8SQQC4eXO47bldcaeZkTfB3aS/+RdZjIJYEWO/iZb0qELHch/nHDUCXIGvWGEbXaZA3tWrrJNYcJaP7H1fD2C++XrJv9kKjeW19H1eOuD0fIcdFa8XTiNUQMIQnCyG4gJK6GcCHtPcLIo25rbN3HEAQrbmwjc4eBG4gbsDopWf7wmGizGMyOHYvyYQrwihaDGI/IyuinRymQprWYPO57q4Zqxf9Vpm+k70bd2s3QUQLMOwOnxUW3tSJ4POjeaE1VhGwIhI2aDJd1Tib/Hn0MLTiIuo9hPopWhG8+vxVZoVGOtYoqPdMsaiFegOwEMM9YfAilr1AJ3QxwVwH8mdVIXp8XgRqFlrTJC9xXDrivivvBE84URcCDqZi6LLZ+J/prErnTUovKDAyiwqhYClLb5bdASBWsmy+QXUmWeTuCSYTYrwghJo/zNF2mS052XQOCjzq0lQBjmKb10OC5a8IbhhIWtDamFkW8qoCzxqBb03tRCCYuATnrK0hOjSu5V0Wtu8837cLez0cLu+6CojgwC2o95BtLm/8og7cdcH6ZoknxnslWsGyMtgUUQnumDZ8BDbzkWzuDjAR55BoD9VuSb+EPHEPiAVE4gyQh355SZ94kp7F0LqIxcHEpS3W0891+0qMOWqL2eQ8nO3jJbBXKZM6DYALiDw0uZYUwADyNnYkwJle1168MMP787cOoIfWwwTszbHOrHOKjg5eCEM4kpOyTJlRQl146fzpeop5u/UlvJl6C0zUJx3Gz7ovUF
 u4eL9XMg
 rEWl3o+v4Y6W2ZqBw90oneaTdNZdPRbz/mRw7uwdkn7W7Sz3vLHaiGiPYLpO93sbHXfHA2XNH9gTIww7JAW9aWKRqen5N8A0jvn2aSepCXqvFGuo4QQOkpbbSsET1k73QpXRqbhDOciISj422sdGag/Ll8Ytf7nzID30kJvGK6stYbyHCJvsyonJky90o0h334t9hegMZwVyWwaAo0NVUK/FSLzhVgXmwszR2gWtX4w0H0OO3jKZN5MI0M1FOJ+xAJ9RAimbamh7rsy9ZpXYLpx3zPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

on systems of different sizes, the fixed 512 page window may not
be suitable and cause excessive false positive memory pressure
notifications.

or should window size be capped to avoid excessive notification
delays on very large systems?

v2: better commit msg, also tried to fix the whitespace.

Signed-off-by: Benjamin Lee McQueen <mcq@disroot.org>
---
 mm/vmpressure.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index 3fbb86996c4d..925659f28dcb 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -32,10 +32,20 @@
  * As the vmscan reclaimer logic works with chunks which are multiple of
  * SWAP_CLUSTER_MAX, it makes sense to use it for the window size as well.
  *
- * TODO: Make the window size depend on machine size, as we do for vmstat
- * thresholds. Currently we set it to 512 pages (2MB for 4KB pages).
+ * Window size is now scaled based on RAM and CPU size, similarly to how
+ * vmstat checks them.
  */
-static const unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;
+static unsigned long vmpressure_win;
+
+static int __init vmpressure_win_init(void)
+{
+	unsigned long mem = totalram_pages() >> (27 - PAGE_SHIFT);
+
+	vmpressure_win = SWAP_CLUSTER_MAX * max(16UL,
+		2UL * fls(num_online_cpus()) * (1 + fls(mem)));
+	return 0;
+}
+core_initcall(vmpressure_win_init);
 
 /*
  * These thresholds are used when we account memory pressure through
-- 
2.51.0


