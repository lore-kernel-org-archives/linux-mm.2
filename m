Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6EDAC88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 12:32:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89F4A6B00BA; Mon, 14 Sep 2026 08:32:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87E476B00BB; Mon, 14 Sep 2026 08:32:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F1B16B00BC; Mon, 14 Sep 2026 08:32:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 526356B00BA
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:32:10 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9DC591A03C7
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:31:46 +0000 (UTC)
X-FDA: 85212304212.05.04DAB1E
Received: from mta0.migadu.com (out-157.mta0.migadu.com [91.218.175.157])
	by imf14.hostedemail.com (Postfix) with ESMTP id AD1A310000D
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:31:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QhQaOh26;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.157 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789389104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=huH6oSd7gTMk6bCw3wFvetQjWaUFvstahrkAvJSP3YA=;
	b=aymTHgIXZ1bvSWfC4qCUAjXt+0P6tZvHXplS94CGpa7E3xjoGS8zs0aY2tqm2brmSmhfUX
	q5hi9TzRJe3FBgoOFIJQ7fxusSdfOQWjZqQDEgiWBWcFb5ibkztKa0OWbXnClGh1Y/ASa0
	8ckCgMAJ5rqKbsWZpJDrtOvUWQ11fdQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789389104;
	b=6E7C+TtqK4+w9Kl9jSLH8IbwOxlCMIonOzJ87RLBUeONAH5lNFo7W6Lk6naH37ZvsbjsPG
	T1bkQn1mmz+nnErc/ItkMFZFY6K9ZNvCVwRf3AkAbD4wOmBwLnfyioi1a2nFp2Pj++X9xM
	OJvXQ/ykqaEbKUKlnpMZKiOseIdPIbs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QhQaOh26;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.157 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=EsV4QmuE2zIVMKtO/SOhRrFUuEtNtiAe7xebMuMrx54=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789389103; v=1; x=1789993903;
 b=QhQaOh261LjKiwmhFo7BQr8VctZnuLzKLjEp6oDQVw5IplJ2Rkxh5gSunTOiHUYOG9iFB3OG
 gTKYbLaytZVkuyK2vP/g+Qh8FeBe4vvd5e4BtbIy9znwvjHVlUTMZGmok+tEFf3gfXu5bqAa+xp
 rKIA/i3g7E/Azb2/oRks0voA=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id e796bb344a1921fe;
	Mon, 14 Sep 2026 12:31:43 +0000
X-Mizu-Trace-ID: e796bb344a1921fe
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
Subject: [RESEND v7 17/29] mm/hmm: fault PMD swap entries on demand
Date: Mon, 14 Sep 2026 05:28:07 -0700
Message-ID: <20260914122950.3283997-18-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914122950.3283997-1-usama.arif@linux.dev>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AD1A310000D
X-Stat-Signature: 6rk5x341ag1kd695qcq73s98ou4jurf3
X-HE-Tag: 1789389104-221084
X-HE-Meta: U2FsdGVkX1/ZjQONNCPU+jndjj1zKb2f54tKcnUMkwJ381sB5BePZ3oQ4L8wl43hRsPDDV3WyAr+EkIOQHKVCia1pU3XRbn2DPYs77Pxe04dlqAkieF/yrA0ISqwiFr0bw6a1LKVqIq82xA2ec+WLO4efF1ob8COySZE21suXiE8LsKq8a4edr1vx2BPrilUwp4vRLI9azI1bVWB/kOEUsUax8dbPFrtW+pkGRdEnv/cTdlUGnKwb6sfG9A9AK2h2Q0Uq6U2Y6/95mUg1Tk0NRQnJMPl5f9y1hyJnzF592iYMHxS5wJf3Zdxbu4q/nfCMsFW6UzB7OzN1xV9ykNzMFziwXnvTEjMNtl49htNBMRXNOGBETCZmVE6eS8rxsVsGh7KiR8ypxliNLtbOYBi/7Pan3I9h1+bbeMPYoeDE3Mcmld1pIVQl8iQL2Z3axnGKag5U6kw/f25dD9Mup4FD+s5xdZ1V7BMIm2Al7a5ywZcC+ytI0IAblNPKGwJS5r5HgWd1rKnCeBM3M6slOdgFNmeyTaUSh6IBu1mqYZMUE3iIzxa+i1029g6t3XmR0ex/9p3p/Y3Y9dozoPlhkB2+3w8Oqlw0B1r8txQ+WBeHEVL7kgH0JhAMhvvChTaMynXtMsdUnCuEk0NC9KnGnkQt3dcNtqrq7hd53iYzCOf1eptYtOIdHxqgf8h0QKH9x4TnA5McQqLtBl2bbVEmuRg/ItxFmmgkWB0+M8TwQ3AJbMIEHxasKOFpRdMilzEhiJ6Rt5Ukw0DWZ+uEQNcTGUSkDwdHbhpozl5k+Yw1I8KSPXotVaXmRHaqlPdTxsetVoUzTDfnhnYsnD4Ypowp+8mwDs9qO2V7CcBkj67+w45OtLVPfbE8LXAbo7xnORg3yz5hiRp/JIQg7i+Ih9iwOI2ho+ZruNdkijHeABXEK2L612iX+D7b5fmV7YDS+BgIIEwlug+GGtVnGvYr33O2ox
 0qarepF4
 DiFq5d8z/hPcAQdoL3JLlVTbI6e8tK+7rss0HuopWSOZbwRqr8hChAwtPNB1ohWQ/69xJS6BT2RHZY62LSUfTpZQWqRcOd5BcDzH363zDaHERaG2+pZheOeofJkz+Gdm4HzDBGSYNhc4UNCRw8SnYe783So4MCmecComgfFr6DTl++7F2wc7sL7RWXXwcXdI92P9dyMneHXEqXa4Ru6hw9mqbTzAnrJkguk6T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hmm_vma_handle_absent_pmd() reports anything non-present that is not
device-private as HMM_PFN_ERROR, so a swapped-out THP would look like a
permanent failure rather than memory that needs paging in.

Treat it like a PTE swap entry: record the fault when one was asked for,
and otherwise report the range as non-resident with no flags, which is what
hmm_vma_handle_pte() already does in snapshot mode.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/hmm.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index 2f1e98c6b6440..95575ac378888 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -377,12 +377,21 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 	required_fault = hmm_range_need_fault(hmm_vma_walk, hmm_pfns,
 					      npages, 0);
 	if (required_fault) {
-		if (softleaf_is_device_private(entry))
+		if (softleaf_is_device_private(entry) ||
+		    softleaf_is_swap(entry))
 			return hmm_record_fault(addr, end, required_fault, walk);
 		else
 			return -EFAULT;
 	}
 
+	/*
+	 * A swapped-out THP is not resident. Report it as not-valid,
+	 * matching what hmm_vma_handle_pte() does for a PTE swap entry when
+	 * no fault was requested.
+	 */
+	if (softleaf_is_swap(entry))
+		return hmm_pfns_fill(start, end, range, 0);
+
 	return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
 }
 #else
-- 
2.53.0-Meta


