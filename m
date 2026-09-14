Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE010C88E70
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 12:32:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C70386B00B4; Mon, 14 Sep 2026 08:31:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4CC26B00B5; Mon, 14 Sep 2026 08:31:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5E3A6B00B6; Mon, 14 Sep 2026 08:31:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 912296B00B4
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:31:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 328551C2372
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:31:57 +0000 (UTC)
X-FDA: 85212304674.28.6656FE3
Received: from mta0.migadu.com (out-220.mta0.migadu.com [91.218.175.220])
	by imf06.hostedemail.com (Postfix) with ESMTP id 388BF18000F
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:31:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V+pRhF7b;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.220 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789389115;
	b=0LzXGcUAVSeBpNcnea3uveJTzt1BXD9wJzjRlnoudKSjRnkxK6Wa6gCBHfGngCiXdCR6ZD
	buf501exBjxN4OhYI8ApgzLPxhlFDH2H5mFAQ0lDSY7fu3zk6NlQUH2oZdmvCrKWARp5Fe
	mDWhwGMKXJrtqccCcTL55kctgvpHzn4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V+pRhF7b;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.220 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789389115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cIyJpw1Wh9dOciT+jL3z38Hzg3YRBSVm2MwjdHgkrQg=;
	b=CE1lo6NUWxeI2ytBMsgbxoaalwQGDY4Ys3o5EBvfB+6arPzV64vd4GqkcqJZdDWEPkrYeA
	RmAkH/Bt8v/q/EEX81WzJmn3C5LbJ2Nu4Navs3xlXewkS0JnmBTVt/8ABMLUEeAlAgBGqV
	6ckrDSUCLE/MBcWdbb1xHRnB5A6Fhxg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=O3Mn4KnTxiYaTlhEiHGB+/12dl1tDr6TCxd6G0YbQtw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789389114; v=1; x=1789993914;
 b=V+pRhF7bePafelNnSWtdASntDuFZFJAL1WKkfdOKocMP4eA5yguWiFjSAONjB/RL+TFOvuxA
 1pUjuwHkNd53hSoL8gVGXKQiJZbxim33Be/UwgM/Yj/3zwvx/got9n4cFIQ6OFDPr0LXaNw6Jcr
 q5z6cBm8Jm0bnf1lUyAKLmIA=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 849d2883d7f4742b;
	Mon, 14 Sep 2026 12:31:53 +0000
X-Mizu-Trace-ID: 849d2883d7f4742b
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [RESEND v7 20/29] mm/madvise: skip PMD swap entries for MADV_COLD and MADV_PAGEOUT
Date: Mon, 14 Sep 2026 05:28:10 -0700
Message-ID: <20260914122950.3283997-21-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914122950.3283997-1-usama.arif@linux.dev>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 388BF18000F
X-Stat-Signature: ko7zchkub9cwt1eonirghmwhaygkcpb6
X-HE-Tag: 1789389114-330300
X-HE-Meta: U2FsdGVkX19B5VEjubpP+I08Zfy5FWli1eLDbylxgugP206FZQ2jMalpPbvhk+INy8DEAQS4guTI+Hc+XYVNIKyss38aJ/4zm5yhKV50qTN1Jx4o5P7TgtzZi4/H2LD372ci/gEa7k66JQW8/7hrcS8DtHQFBqYSaqkMvcBzot4pjtyq0X/Gnakzmv98g/FfNmCUrQG/hcrEVyEbRJ95xSk2gNG9oMwfXWFT5VYQn6+XgXuMpRL8hMmNVhfCxZw3xyuVZ497HaX3d6oDw/MXKnIPOfjHG4ITy9FAzeo4k7SVQJCDFtZWnu927LpFTleR9th5FC2eyJgHnt2qzlYNjZx1g0ukZMy/kvtDcAUSE36Ij+eGZ8aCyPN35CHsGwoWzMY3aSEELGZDlbojJWdVQTXFdgG9tKns7ttrURusg/9zOO97Ivx88r310MpHBpU7y9I0znulQTnqEPOTz7oU+K+wLy7dljuZqgcR8hbaENWfo2Yv4NWTVGjGoSwQOzYS+GXCVzkm5C5KhelQf2ftl+Tz0vKISkcS4vNe2PXiJxXdNelCU+aEM5VA8pY7bG/PtPvS8Qv9YfAh6nHIYUdXr/ZVBb9jnZHcmw0JY38jPhWR80c89q1THcxPrm9hoOMb7sZTA/yP8Y9Rl+JvarzGrLmbHllh/SoLG+E/vRY8275X/Hk8USroVPfgHO24VGpHa4WQvr9IJmZVR2ykz0dyDuP3LJKzI+93xkmYLYsn5fI/fCb2j3QRQEMa37z1yfLC7jyBBO3jrAi7KMXJbtxDEMgXJFv6iMkzR9z42HQAFDHA0hAM7WSBgsRExD+WIc82od7TcvNo9/Nd3S1kYOlw+BO3FpmjpIp7wS9DBx5LSAGPZCMbEQ3GMnml0fiOuJkFFvoZ/Qp4P2iVuC6mj1QaD43wpzYOViJfvCbw2/zKHWsrR/NuoJbTjuJGwG8URraqj5U24MKF0KAnfWemTJ0
 th+FgWsm
 4HBS8QE7BtTbosWvDKyQWrg29OSUmeBq2rtcO1c6I/BBva8Y2xGh73iz36GX8mW0kjuEs5/ixw1UrK2MnV+k1uWyrm0PsVt4hR4vtsNSWtnTaeAEHduJKMoHaYYEVxcEse1hy75C2STLsm3Td5w7GsqaTGHAJSi9Q5/yegPFe9Tj7qZaptt6UmNOqdDHbvLKngEYG/eaBwoYS9lyo4BgRhitEFQAn+kSE4qYxvAhfveBAMujT6KNeK7WBnhLltYo9fnlsfGhYe67RYPPNm4dmxckiBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A swapped-out THP has no resident folio to deactivate or reclaim, which is
also the conclusion the PTE path reaches when it walks the swap entries and
skips every one.

madvise_cold_or_pageout_pte_range() gets there the long way round:
pmd_trans_huge() is false for a PMD swap entry, so it falls out of the huge
branch and tries to map a PTE table that a non-present PMD does not have.

The entry can also appear after that first, lockless test, so re-check
under the PMD lock; otherwise a PMD that turned into a swap entry while
pmd_trans_huge_lock() was being taken trips the VM_WARN_ON_ONCE() that
expects a migration or device-private entry.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/madvise.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index 70acb39b8b3dd..d3b5ed7e3cffb 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -385,6 +385,15 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 					!can_do_file_pageout(vma);
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	/*
+	 * Swapped-out THPs have no resident folio to deactivate or reclaim.
+	 * Avoid descending into or splitting a PMD swap entry.
+	 */
+	if (pmd_is_swap_entry(*pmd)) {
+		walk->action = ACTION_CONTINUE;
+		return 0;
+	}
+
 	if (pmd_trans_huge(*pmd)) {
 		pmd_t orig_pmd;
 		unsigned long next = pmd_addr_end(addr, end);
@@ -395,6 +404,9 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			return 0;
 
 		orig_pmd = *pmd;
+		if (pmd_is_swap_entry(orig_pmd))
+			goto huge_unlock;
+
 		if (unlikely(!pmd_present(orig_pmd))) {
 			VM_WARN_ON_ONCE(!pmd_is_migration_entry(orig_pmd) &&
 					!pmd_is_device_private_entry(orig_pmd));
-- 
2.53.0-Meta


