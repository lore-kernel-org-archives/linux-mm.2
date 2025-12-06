Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71DBED3ABE7
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 03:09:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCAB86B0349; Fri,  5 Dec 2025 22:09:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7C936B034B; Fri,  5 Dec 2025 22:09:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6A5B6B034C; Fri,  5 Dec 2025 22:09:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A16B26B0349
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 22:09:26 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3D4AE896D7
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 03:09:26 +0000 (UTC)
X-FDA: 84187565532.26.5007D80
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7C87F1C0016
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 03:09:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.172 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=samsung.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764990564; a=rsa-sha256;
	cv=none;
	b=aGqykoBG91KkreZfUwncyek4L3Ilsi+BPuR3OhrNEOnKQwaRCqIr5zb0cbaREnDMh/IkQ0
	k96ZR/n6CEj41ule8h7DUDFSVrmkRP8YPZknYEHfyUAy1Rpr0sj3wowdQvQXIPzwkUbDBx
	CoVm5oaMAIY80DN0WujVSG9T4QDqVr4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.172 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=samsung.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764990564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=slWDcKcwAJ+Y2tqjA/MblIFxfiG7s1k+JhDbc/3/jDE=;
	b=vohXDj3reiFZDdBQ3wZdw91WzU3cJTYAjJ2h/lmn4plJXMiYshqAjLbJDPBg71X5hj1el5
	tSMlo3IjjMb5ZMoEADHNTpyO5UHyTNWjuydL+NoXuGTY3JzbgasnJVXFvSrfTdh02G9TNi
	LC6tpjs4Hp+BbwstPW1R5UqtCfmc8bU=
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4dNYB91xC6z9tqH;
	Sat,  6 Dec 2025 04:09:21 +0100 (CET)
From: Pankaj Raghav <p.raghav@samsung.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Michal Hocko <mhocko@suse.com>,
	Lance Yang <lance.yang@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nico Pache <npache@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	kernel@pankajraghav.com,
	tytso@mit.edu,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [RFC v2 3/3] blkdev: remove CONFIG_TRANSPARENT_HUGEPAGES dependency for LBS devices
Date: Sat,  6 Dec 2025 04:08:58 +0100
Message-ID: <20251206030858.1418814-4-p.raghav@samsung.com>
In-Reply-To: <20251206030858.1418814-1-p.raghav@samsung.com>
References: <20251206030858.1418814-1-p.raghav@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7C87F1C0016
X-Stat-Signature: ogi4g7hgwdghxpsjy7t5hk1u77cr3k8x
X-Rspam-User: 
X-HE-Tag: 1764990564-555363
X-HE-Meta: U2FsdGVkX19hvLM9+/uTE7ZMsFQNuMZDXGtUT1beoKZvIpqts7SgAxP+YYmAi9Ojl9WxgGHcCyV/9AZwcCNj8mYN6/4oi9DFo1KRsmT+9xArKIMduoTgYRA4tgs6KsKlTVhB2FSo5L+QKErrWH6b5YPQz7se5KFmb7NeaEWg7qTcG4OkPjiR4Uwm6Mx3hU+ToVhAoxsHXNH6i0IdNT2iTaou2EdkpQqWMPKdjh66CkgJNPlEKzHKLwYGGS4ap0BJJKbLxZMl+d/wTGJhX24QFijs7tsz86Ne0DlO4LmAax+lWgLV4pNjuMQ7+I6lepI6aJyHXTJhz5/ePw9ixKMN021Er2L0nHALLBML+DeDv3s9qF4uGibN0lbEYYUJIQ9rjy0/ImW3Zeh9tgjlwf0APFce9ilXDk5Kwal6LtwKWgHFnYgU6IOfYlI7sl+2+aaBV8rw6tqcT355jE8CqV9VI0niyWQVwdlPpQOU3rIExAj8g5Tdsmc+/8slb6M4PlA0NAijYOjJe4M+V284f/R2KyVnfu2CDJRMbIUCfdJNICOelHd+YievL9zKfcTsDZOo+TWZkFdih865OU0ih5nrkmM7mt9i5j5dVS4/oGbF1AzlxJ4WvRJvxqHfk5cFTMMZnGxOipL9l4eEgRAFB6yPyuo5OmSvF6Pzbb/g6kWslh5o9RfHJWSSD2spyxmnzdBDJRWhJPfl7C0frSgSzpFQKqgb+pNc+rqqCIG1L3OtSiccUS+1xOQLSufRLkP7GI5cyOvUEAoy4zwiNlnXcNYdYw51l93yJUL5olzY4MVrOsGuZ7417t6830fNxJjmUlQy3JrlN2VqKnlgvDeBbNDUdjlyeZL0qX2tqhalqLBs+I5dDDoIUhDvrs+kxBf1axdhl513oi9Dneq8BMR+QFd2Ywq/LsbVbV28QfeofG5EhQdlfsi2AVA9EonwsydoIlVsaGXfwAIggUc+wkmtoA7
 eCKtHUda
 j+tqT/CdHtOamrSuIk2nRH+5+m6oVrnmmJyhnwuDsJlgu+EshkRRQVeNvjJaTELiBc7pKVRoPCBCBMXZMZTfYWPDmQZxSEcxKLehPLRSs2syMZ1yqwP9XrdGbXa6ynm0Z7q/DIJ3Xt115MKzEWkpyr3zqWjugNKQIC1+U2joKx+8460jcIYA4WZejG8AdPkVqzmiZTX3ZsOzO82fPwhlOWk21krRXq34IncOIJM5gccfONp2jflfJEz9CfXsMZC9Pt3InCbYqRnjc55wmBWa3/nU6Yfo9GMnqtWsK4w1MYWhG0BeOJNeOaikWIwoHXf6YDF1P6VVCj5um2ZcyYPjI6KiVZMD2uZGEUt99wQG2tvlC7tg5cEmUtr96OQxWkL4Q3DDX/IpyHftZSal11+UzV0RvpSat59eezTc4OQC7H2YVW5rP5Mq5xjzIkRQYpCXS1O19s6f3C+Aj7OY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that dependency between CONFIG_TRANSPARENT_HUGEPAGES and large
folios are removed, enable LBS devices even when THP config is disabled.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 include/linux/blkdev.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 70b671a9a7f7..b6379d73f546 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -270,16 +270,11 @@ static inline dev_t disk_devt(struct gendisk *disk)
 	return MKDEV(disk->major, disk->first_minor);
 }
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /*
  * We should strive for 1 << (PAGE_SHIFT + MAX_PAGECACHE_ORDER)
  * however we constrain this to what we can validate and test.
  */
 #define BLK_MAX_BLOCK_SIZE      SZ_64K
-#else
-#define BLK_MAX_BLOCK_SIZE      PAGE_SIZE
-#endif
-
 
 /* blk_validate_limits() validates bsize, so drivers don't usually need to */
 static inline int blk_validate_block_size(unsigned long bsize)
-- 
2.50.1


