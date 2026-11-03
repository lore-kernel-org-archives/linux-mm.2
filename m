Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 941D7606D819
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=jQ1mEG8I
Received: by kanga.kvack.org (Postfix)
	id C43C56B05D3; Tue,  3 Nov 2026 03:01:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF4856B05D4; Tue,  3 Nov 2026 03:01:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE4126B05D5; Tue,  3 Nov 2026 03:01:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A4B06B05D3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:01:36 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 15A8440369
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:01:36 +0000 (UTC)
X-FDA: 85393063392.09.7A43A17
Received: from mta1.migadu.com (out-66.mta1.migadu.com [95.215.58.66])
	by imf13.hostedemail.com (Postfix) with ESMTP id 31AA420002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:01:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jQ1mEG8I;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.66 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793692894;
	b=CxdkIVU/Y1kmJW6MuZ2r0sJZQ3hEwRqkdYXanqflX3jBNZRqtYqWgwc1LGq5I6tNxLuvUD
	ZjsvE/11UpXU0enGvzOC7N+Lso9i28DFPog+bStDe/G+z9iRfFmAklmOj6QyyNSUFKsSwj
	WPFuJlb92EplRuoTFgxYsiKeseL0Cp4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jQ1mEG8I;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.66 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793692894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4EgA5xkJyAmBnEfHDvfxKLGqQoQIa9SsFw2zzB/YR1U=;
	b=EyzzjC7ttcBOVQyDPZOWJr5x0BpKMwT5gIATklrfzIOhAR8OeEtjH7ct3zoneX/Eu38yaf
	OIVsUFJDzfmQmrt04JzhhQILVEi2Jsvx9+uhpRLbS+SRxmgGdQbjGHMGCPXyYrk2q2JWJz
	gERaB42IuP29/9em6jIw3N4VCDMAktI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=C2H3ojY+P3grZeC40yIYdvddeGt1gzpz1d1fTn5CZ9Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793692892; v=1; x=1794297692;
 b=jQ1mEG8IJtNHSeOiU3fvwCnyj7oLCu4Oiiq8NLzYDXxiQhsXGxpdHLUpAWXMJePF0rge4FeF
 4SPy+iUqqH8AyGrA7aLv9mIjpz2XbZ4h5Kpx3SJblVQWlQTA0WKDWe4tSZWq/XE58izSXAUDMQN
 ZP/E4/peV+8cBNyj4k49vOl8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c6f696fc8136050f;
	Tue, 03 Nov 2026 08:01:32 +0000
X-Mizu-Trace-ID: c6f696fc8136050f
X-Migadu-Flow: FLOW_OUT
From: Qi Zheng <qi.zheng@linux.dev>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	azpijr@gmail.com
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH 3/4] mm: hugetlb: skip CMA when direct reclaim is disallowed
Date: Tue,  3 Nov 2026 16:01:06 +0800
Message-ID: <325d33655f29a2799a0859c788c48625feeb85f1.1793692578.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1793692578.git.zhengqi.arch@bytedance.com>
References: <cover.1793692578.git.zhengqi.arch@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qdmzyco8i38sadzznz3rdxjdmt68m3cj
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 31AA420002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793692893-710934
X-HE-Meta: U2FsdGVkX18HB2gFreB+YsOKAaSju9PMS2vCM2lYS96WXRKbUjLfw1BFWM12IL2ehjAT5s2Ky8BvkOFie21TEpyY8h6/6NQMwcvHyGWxs47oDa/MYT1XRupF1ScaKQBdkbD4QKSn5qDRxaThQJg3UPWVIx+lihOXf9w3XoTyPkD0aBdUq9ttyQfy73hRKtOL8j3FU31nT1gIL/SgKgOkwcFuZDUkVrOtObsdeEdqnmUZ2SDE13qnL/Kg7jkUYFYTKBHn8t/yE2F59DfJuL/QKMQ53KcTWNDU2NU4XSuS4k8jASC+OFXKhc/qc8TR86OALxq6GUg/4kwBPFMlHaylunAxMIZ+qy9EpU5xDkilAA/mwjKRTpMzozPgO/UsqWnLxdO5AbvKyrTqz95x/Zbmk/dlZNtLyo9jtfZ5myNszzzfvD7E8KUY9GFk0s+EDkygaiFsVABPIbQTipqqD3BLW7Vt2cUTjmTSsZZsGjehLM9yzPmcnyWrc5bEn8e5ZZ3WeXOZUuIQWGbWNCkqs1/GR7QKwIUhTar1Ydo30Ic6J0Z7wnoO2qSRZAln/F4hyMqcwcqhiImd0RGJj+pGj80H8fj5ktreMO7x0vNToegVP9zmK76xx9qpwXAt61qT35s2s9N4FFbBvQC9sjCRdl8CgpSNec7QMrFmEBOqfjbd9WWEWp4GIy3Sbg6MbfwHMjmHPdTY1g8Gf9hoM8BJaLTSOtYr2Z35T5/5n1oSCzrCIiGBLztyVb4jrMjYQbKVKr8yDZoUKFncYXhQ9uXeJuGdgj0oKUTFCLOzu021WGdgYW3Tm1ct2mlrxvvIIq79qDrcpI5c+sGad8MVK+HYv9qMZc6KYakRw5x9uFG7bwk7pn20l3G3LTU24nBe9g3APPdJM9tACziFDnwNfkTYVYHnzBzG5R8KtU9IUHtZiXX8lPykJUtPp1WfC+4+Ul0QHmJH5y22/AcOS+GUIe1MQjE
 2I7+83S+
 WnEG+EZu2TsZ3TSfuxkPBZ0JuyE8w8gLI+hDonxEmZTEBVMDqGvSWkaJB4UAFcP3cmgCBAVo+iUPVTOR0nADM8kWygxMGrRTH3jDPYlQP6EakQ3CzNMJrNtSh1QtyuSIi4ld0MSuHXQ/jYRvnxz6FCI+IrQyWu72DSlTMfrQ9w6X0o+CO9sGKAexOxZUK2+zC/aZb5LE40VC2Uvze30CznPA9qnLvlOF1eOrKmymDgb4+cYc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Qi Zheng <zhengqi.arch@bytedance.com>

Switching HugeTLB CMA allocation from cma_alloc_folio() to
cma_alloc_frozen_compound() stopped forwarding the caller's GFP mask.
The new helper uses GFP_KERNEL, re-enabling direct reclaim even when
the caller explicitly disabled it.

The first MPOL_PREFERRED_MANY allocation attempt clears
__GFP_DIRECT_RECLAIM to try the preferred nodes before falling back to
other nodes. For gigantic surplus pages, the CMA path can therefore
enter direct reclaim while allocating migration targets during this
attempt.

Skip HugeTLB CMA allocation when direct reclaim is disallowed.

Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
Cc: stable@vger.kernel.org
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/hugetlb_cma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index dde1c866406fb..90f8d718a1f16 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -59,7 +59,7 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
 	const nodemask_t *nmask;
 	unsigned int cpuset_mems_cookie;
 
-	if (!hugetlb_cma_size)
+	if (!hugetlb_cma_size || !gfpflags_allow_blocking(gfp_mask))
 		return NULL;
 
 	if (current->flags & PF_MEMALLOC_PIN)
-- 
2.54.0


