Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13A09606A31A
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 06:28:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11FE86B05B2; Sun,  8 Nov 2026 01:28:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FA9B6B05B3; Sun,  8 Nov 2026 01:28:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00F206B05B4; Sun,  8 Nov 2026 01:28:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D75C46B05B2
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 01:28:49 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 54EC6120438
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 06:28:49 +0000 (UTC)
X-FDA: 85410973578.23.87B95F9
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf13.hostedemail.com (Postfix) with ESMTP id EA1B620004
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 06:28:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of shao.mingyin@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=shao.mingyin@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794119327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=c78D4a1RW3JHtc1NdajB+jnOJRb2qfhMFFzLKACsSM0=;
	b=hZQmkT3JV2qQq9ioWiaznqsKPBIM/KgCIibnIrQ2NHAXIzuFgzrfY4aLHK8en2IA/iZPtN
	PA/CdfE/mFGLI68hVFeDOyzBKflqecgu5zQqq1BKFhYnz0D0ML5IyHQ4KDnfoxZ4iItPOn
	lbkJ8xZvkUUB3s3BvETZjDQSi8I0caE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794119327;
	b=SQpAbAnKeCzig0a77K4y/+pwXdXfwN1ABmbm1i67tt9b7lSatjrMqGixqnJbThmwQEw21D
	VjpmB9ECT7soJt/BNUCwzbQJQEZsaH4HgT8ImWkzjPNw6xUHRUhOkT4xS7ogMYm1CcMH5H
	d8R4/20UkOv0ivz1bvjTo4zdknqTQXA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of shao.mingyin@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=shao.mingyin@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4jMjfW41Wwz55RJ3;
	Sun, 08 Nov 2026 14:28:35 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl1.zte.com.cn with SMTP id 6A86SUiH057590;
	Sun, 8 Nov 2026 14:28:30 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 8 Nov 2026 14:28:31 +0800 (CST)
X-Zmail-TransId: 2af96af0168f4ca-27bd8
X-Mailer: Zmail v1.0
Message-ID: <20261108142831046W_fbNCAFfuY0BjHPCCHgi@zte.com.cn>
Date: Sun, 8 Nov 2026 14:28:31 +0800 (CST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
From: <shao.mingyin@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>
Cc: <linux-mm@kvack.org>, <ziy@nvidia.com>, <matthew.brost@intel.com>,
        <joshua.hahnjy@gmail.com>, <byungchul@sk.com>, <gourry@gourry.net>,
        <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIHYyXSBtbS9taWdyYXRlOiBmaXggc29mdGxvY2t1cCBpbiBkb19wYWdlc19tb3ZlKCkgd2l0aCBodWdlIHBhZ2UgYXJyYXlz?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6A86SUiH057590
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Sun, 08 Nov 2026 14:28:35 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AF01693.000/4jMjfW41Wwz55RJ3
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: yni16mdgnenyesn46sxpq48pixrxsb9u
X-Rspamd-Queue-Id: EA1B620004
X-Rspam-User: 
X-HE-Tag: 1794119326-714646
X-HE-Meta: U2FsdGVkX197tmRJ60uh0NLrYYAig7gsdLG31O5vDSmgT3MPkoRaNjtxgjfHALpdaEHLM1519JkqJH27t8XdyhCNcd5k5lUlwmv1Ro1FBexNiYtc2+xcjTksnHff//zRVp/k2SJh0XZaCXrpNOxMhAGgAUGY2hxJP8gZ9zA2Blee//Rcad3V2x9GtbOHk8CgmBYWB9cl74c/tBBNG5rKzT3JS22RsyL2X/nrZrsGfY5ETTotIwCvdQvaceE06ej6v6Uwnac5qnZQlQubAvDhaUbD8g625mbTzKKQPmsNLJfzmCyI3ethk1yTcIvNWTEgWEroTf9pu6t6UKuCcjAjB7Nx7q1GnicPY4ShDEF3R/Yo4upFDHEfV7hvMHkNhpBpeknOhvIBir42Si48kCK6FMRVSdW9/m2U2Jc7O2/73388fqHbiFUAI6xVB3iAuGxWOP0eWawIRxabDRyRCRwV+PHzzYBJ+cALzSi9aeQmh4I5HZoQtoF+YI6kv5oIzO2N7SQwhgi5snGOrkV8T1mroIAWL9DIGYRSARZJDVA2tI1QYwEh/mPV5avJ58vHCJyMuyHqLpWXOkPGIzVie/ZQNgSLeySht/sNgjKbhSC0tgrXsL2O7UXDVtLCZyqaQxkcEqRGcMkRKBoXPOygLLkhsQZK+jZnUUwdleguTiRk/wYM7MHBEIFPxDDvQQVz7vQSrC64VW9jBAZXFRr81SbC8foejdwiOHlR93PTOkjgeWv2H79cwsl2cUfHbbFFKqTSt/LJfMJKkb5Ja3CJU+Yf1dtanXN/WjIAx2bSuVB+zispO0cd7oa1+Y3DPcvZe4aaLPxktkfxu21n+i0YkQHwk8+hN23+oE+WT+MS7/SZ5asWnvgQbav2MKSEFLhbJ2nCAjCvKCGJ3mzR54OQFAxawOPXjTWtX7HeNDh3a50Bk+haI/1ddi3SUG0hhojTyMMmrrDxgwiRBYtZjMkbo2+
 D7PJBTAt
 y8ks+iQknl+gB6v8oyKttOd+UKFNZ7UJdV6iOuUL6maHig/l5gwP4HmVrZbRdGLCxurG9o7C2XPXhjyJkvqNxPtQAtOXyzWgRDA0/RKdC3Q2myRbAeLqNr5Lnhlvwnhl8+9GxkYlWJeMfO1X2eVUnD7zmVGBZJrTRmgEd3aXanDxGinT4r/WCUS2ce/UBlRZFFSCiyQFXbBAJBPDziCQGEs5d9t2KteK3rhvRp9Hi9mCrvtdMbo2ylKfQDS3k5eayL38MJNnJaOK63hOqJa9lk6hlRL/tcmFqxM16DDhbhf4W3TfYshthw1mdJvErReVyVUspcukDKHXaKOcuOhnapivqRDJCrQPVTeQyU9Y7Y4k3Ngk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Shao Mingyin <shao.mingyin@zte.com.cn>

mm/migrate: fix softlockup in do_pages_move() with huge page arrays

do_pages_move() walks the array one page at a time.  An entry naming the
node its page is already on is never queued, so the loop runs without a
voluntary preemption point on a non-preemptible kernel; the existing
cond_resched() calls in the migration code are only reached after a
folio has been queued.  nr_pages comes straight from the syscall.

A 6.6.60 x86_64 kernel with CONFIG_PREEMPT_NONE=y and CONFIG_NUMA=y
reproduces this under QEMU TCG: 50 million entries pointing at a page
already on the target node keep the CPU in do_pages_move() for 42.9 s and
trip the softlockup watchdog; with this patch the same call completes in
44.3 s without a softlockup.

Add cond_resched() so that long calls yield periodically.
do_pages_stat() had the same problem; it was fixed by 8e934ab44389.  In
current mainline only alpha, hexagon and classic m68k can select
PREEMPT_NONE and they cannot enable CONFIG_NUMA, so this mainly targets
pre-v7.0 stable kernels.

Fixes: a49bd4d71637 ("mm, numa: rework do_pages_move")
Cc: stable@vger.kernel.org
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
Changes in v2:
  - describe the reproduction and the code path, as requested by David
    Hildenbrand; no code change
  - correct the do_pages_stat() reference (fixed by 8e934ab44389)
Link: https://lore.kernel.org/all/20261107213856462Jx8pIdgdtLvPLfOFTwV4X@zte.com.cn/

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

