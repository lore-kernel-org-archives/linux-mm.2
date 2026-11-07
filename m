Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E45D7606A33F
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 13:39:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09B906B05B2; Sat,  7 Nov 2026 08:39:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04D156B05B4; Sat,  7 Nov 2026 08:39:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA4146B05B6; Sat,  7 Nov 2026 08:39:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CF2A16B05B2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 08:39:12 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 57D981A030A
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:39:12 +0000 (UTC)
X-FDA: 85408429344.13.C0B0854
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf04.hostedemail.com (Postfix) with ESMTP id C0CB94000B
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:39:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf04.hostedemail.com: domain of shao.mingyin@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=shao.mingyin@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794058750;
	b=cfW7jd30D9yFpY8TXBZADCbabLFw5js/7YIPkUdaTCGNEz4vlyXm02geMmzftoJG+6JV4Y
	bC5/fAuR4p1KDFK/LA1zhaZad2dmLfKFt1MGh5By67Tlz+atryhgol6dSCnfIOLj4NNdPA
	OIHeJdI0tfBYOS/RVk7XaCjulxom15A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794058750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=dJYm2TImWbj5dfwHqPoqbjQsYL/GbiBHCiSucATnMBU=;
	b=E4stPBxBAgPsV3rCLOXYEL9g75bV8vqC38lq8Zfwn6qZG0Vf1A38l+aCxF+AiITQm5ZkGu
	zmlAlzfoWi1q+Ys9oGi+GKgNYcZTua3u/lB7qEB53HIkBiBEpEPqc+M31r53fWHf56UQNX
	oqb3nzn5heaYUKtLVw0W3LOaRe00YXQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf04.hostedemail.com: domain of shao.mingyin@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=shao.mingyin@zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4jMHFZ0R10z55y2J;
	Sat, 07 Nov 2026 21:38:58 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 6A7DcrEa017445;
	Sat, 7 Nov 2026 21:38:53 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Sat, 7 Nov 2026 21:38:56 +0800 (CST)
X-Zmail-TransId: 2afa6aef29f0f9c-e49ea
X-Mailer: Zmail v1.0
Message-ID: <20261107213856462Jx8pIdgdtLvPLfOFTwV4X@zte.com.cn>
Date: Sat, 7 Nov 2026 21:38:56 +0800 (CST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
From: <shao.mingyin@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>
Cc: <linux-mm@kvack.org>, <ziy@nvidia.com>, <matthew.brost@intel.com>,
        <joshua.hahnjy@gmail.com>, <byungchul@sk.com>, <gourry@gourry.net>,
        <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIXSBtbS9taWdyYXRlOiBmaXggc29mdGxvY2t1cCBpbiBkb19wYWdlc19tb3ZlKCkgd2l0aCBodWdlIHBhZ2UgYXJyYXlz?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6A7DcrEa017445
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Sat, 07 Nov 2026 21:38:58 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AEF29F2.000/4jMHFZ0R10z55y2J
X-Rspamd-Queue-Id: C0CB94000B
X-Rspamd-Server: rspam12
X-Stat-Signature: oztcexncbfhjk7y6rh1nkdiirb49s9kc
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794058749-965085
X-HE-Meta: U2FsdGVkX19zlXCBH58d39j236HCJtZZl9+jS6CzIcrEoYMoiCOt5GZiXbiBGk0ApmbQoWG5ebcCnAJtWLKwk5ZHqjiGmdSnNRHKmfHPzo4YzKGv3wTcIscnCdLVdRTtl17mAdAFn5pdD3d9OmMdfaCmkxZ0js4wPij4/WnfWIwvyys8S2glbvB+JYUZvWbTibEAIoX1jR8iibaaGjR7s/IweVTRBs2FR4zoS9wV+2KY6RhP5aFVCXkGAjLYW2X0ry5JLTLvxdyVTk9vFDlojz1dDmbUfx55acr8WWi5cgDtbInMY8/vmqN6OcJzvrSZFAByLIjU8e9zQFQEsmtS2cmjYOVRoZm5357MQF4Q2cH7HLrOvEs8owtEYLvNPwrPJhFBO5/m+hYcObbtBDHWHFiA7GVzHY+JdxEKpAxaP0ztiYrzCubGZIge/skBhlRRkP99zh38MWIIajKHGmJfA/t4sk8oJfPQDfhoLGVXbE6N3Q+ao7VpCzFy6lPJ/bNwLVKZ+DiQHHPLuQ1Lo8ej+GFtHtXkKcGtLscZ5WoE5gSLxB/enStnflBQys16LuEVHt5hO1pYpAcqO8baGi605EOx5ZZ/n8qZCCoUANJ08k5hidLivl356o8t4r6Q6xoV4pqPPM9YientDxycLU09Iw2JVnTin99PEJMQot+DlT2xNKmQ8G2p86WHHnqGnn14+MNxmeS1mWs63a3g8ulBKdc3Yz/oLRRjA6iZTC770IS2uX8q9pcixn2UQUnO4fDskvVOPVx4hC4SDVUmXifMmt3FKwxDOU+YjPTF74UPbORFMuWzaqJelQvKDqucj0I5pCJ/efqmf5ixqOH/9FVFNK1tA8Zf+313s8PbYBjHzN+7FArV4ii+HncSJ0vH20plRVbxEZiiFLIjNgJCJzOw+7PJA4erS9LM4H0CfBt14/lAt8AK+8EN+Ht5dhBWuJWqOpAAf9v4qZPKEoCcYKq
 aPesKuh3
 P5SkSO9mul87oGoZt0skz2mjomYQlPA8F56XVbmnNEeDDUh0p21G8OqQXuWxlQNk3tNztYug1kHMmBlgt/+uAF/KTwXQ0t56TAPo35jG9vlbh9qhIw2IuFaSKjXDdgQ+DRYQeZfoC5B+1TtPFzLcclNK8kyZJohkgTGL7TI7kJIszYHC0blCAiA++KMLfaVOuXRuceJT7BM6mlBqTOn1esZKhplIbsPZsxFTmCvYjp82U/eJY/6F1ImwJ+bBbse7+MukMjR0OtJHjbJaLukZn7XVG3puh6F16XYNVvpTY/WXkxyLkFON7c7Dy5OHk46Rxfnwpv19GFJjBMFka7N2FsZO7Xy5DwwaTrWugvzMzCxN8qiBHZJpjnwPTVXdKpl3dX7q4tNFq8bElFpo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Shao Mingyin <shao.mingyin@zte.com.cn>

mm/migrate: fix softlockup in do_pages_move() with huge page arrays

do_pages_move() walks the user page array one page at a time.  For each
entry it performs two get_user() calls, an mmap_read_lock()/unlock()
around a folio walk, and an optional store_status(); none of them has to
sleep when the arrays stay resident and the rwsem is uncontended.
move_pages_and_store_status() returns early while the page list is
empty, so an array whose entries all resolve to the same node can run
the whole loop without any scheduling point.  nr_pages comes straight
from move_pages(), so a huge array can hold a CPU past the watchdog
threshold on a non-preemptible kernel; with KASAN and function tracing
enabled, ten million entries can exceed it.

Add cond_resched() so that long calls yield periodically.
do_pages_stat() has the same problem and is being fixed separately.  In
current mainline only alpha, hexagon and classic m68k can still select
PREEMPT_NONE, and they cannot enable CONFIG_NUMA, so this mainly
targets pre-v7.0 stable kernels.

Fixes: a49bd4d71637 ("mm, numa: rework do_pages_move")
Cc: stable@vger.kernel.org
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
 mm/migrate.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/migrate.c b/mm/migrate.c
index 875079464930..3122ecb85270 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2372,6 +2372,8 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
 		const void __user *p;
 		int node;
 
+		cond_resched();
+
 		err = -EFAULT;
 		if (in_compat_syscall()) {
 			compat_uptr_t cp;

