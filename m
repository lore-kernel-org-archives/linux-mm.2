Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 990F8606A338
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=drSwB0BU
Received: by kanga.kvack.org (Postfix)
	id B2AEC6B05D0; Thu,  5 Nov 2026 13:41:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B022C6B05D1; Thu,  5 Nov 2026 13:41:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A180F6B05D2; Thu,  5 Nov 2026 13:41:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 87F786B05D0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:41:48 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 316E4A81A6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:41:48 +0000 (UTC)
X-FDA: 85401934296.28.7828CB1
Received: from mta0.migadu.com (out-238.mta0.migadu.com [91.218.175.238])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4DDC618000A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:41:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=drSwB0BU;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.238 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793904106;
	b=KyLGd4TekSp6P+uIgDP7HITLLKo4oqOBtmB2zTR6NTOMe/26L9tHDYX6wzTai6Qdz/i92W
	jz+HsUSMi5/djm1i0rifFW5y4atNKIOcRzMq2w89mXCmK0fsKVMfp2xOesGkV6eoxdv2Ol
	Ep/tQpahaYqJKnO0IurBsl9o0zvy6QI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=drSwB0BU;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.238 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793904106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=huH6oSd7gTMk6bCw3wFvetQjWaUFvstahrkAvJSP3YA=;
	b=oHTHJheK8gXflXoTBaMEP3kqMaRhcywGojAlA3yDM8LUoCmmjn0zTVNfRyVT387N428d37
	ewoKu8vIf2Gsjh0Rsg2nCmveA78addRx0cVLCur4yNYCdqIYAjL8rGP0lMBm9UzY4usVvL
	qJvFzMNTagbuEtGN+jpXuWRuyT7JY64=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=EsV4QmuE2zIVMKtO/SOhRrFUuEtNtiAe7xebMuMrx54=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793904104; v=1; x=1794508904;
 b=drSwB0BUQB4y3mqZ5QqCOmuetVLGNhLfJs3FrruXVdLLLcWiP14JKZNdbtvB37tgkypfW7th
 TZVvLY/pEgacQvV49SFKnrZ+1dG3BwALFjj1oZIcHaDfeln0uALWK6Q9XSEz4O804spjh6Ve5r0
 /xD7b02uWaZ1bTT5iid5gKfs=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 7b89403d16ddfb12;
	Thu, 05 Nov 2026 18:41:44 +0000
X-Mizu-Trace-ID: 7b89403d16ddfb12
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: chenhuacai@kernel.org,
	ying.huang@linux.alibaba.com,
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
Subject: [PATCH v9 20/32] mm/hmm: fault PMD swap entries on demand
Date: Thu,  5 Nov 2026 10:39:04 -0800
Message-ID: <20261105183940.2236717-21-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105183940.2236717-1-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yqqixfxd8jyto5wsfud8dpx8re9o7bhn
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4DDC618000A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793904106-317084
X-HE-Meta: U2FsdGVkX1/d8GIvnNYJOT1pnVd+2CxnFlnDt5GeBCfyBkfHs9dlkQDKv0bgIv7i+eoRYpOdYgjn+uupE8tUlOmXt2tOCvATVPB9GaQ/nHmkOmrkHcvUtTwdI7XTdExg4QQUHKk7F0qDd66mdOlCZ5wAD/pR63yicrswH2tOz4FiJTmsUsTC5xvBrCOgkocOnp9pxFEuao/ILCiNIxnioyAzjpRl8Pjw6tZz9+3fquLGconnQR7DCBG6cUJu5s7meFL3d1kN9kXaNMe1SJxFKbDRWHuCSZ4NB+e7QtqLyw8+uIw4BKeN2pQvAsj4Eaa0L8O6IfvbUQriCLL3Tv0o837LQByOafrzDWdJccYi8+LqzMVx2q7tlufBB5G52GM6BpoRqVkHxTibKe1IcTcVmqwI5UPJJrLWX6QPkCugKrxF12yFx8Kghg8b46vGUapZzF11vKjJix5hRXlmZRYt4RpJv8Mt6XMUeaYxlO5MvB7NYGs3AgLMlTAdRMN0XMjGzGcj0l6Uh/jy1zoEfKKt5jVRYksh2LgVeRCc1D9EaiglwZ/YPjxhOIgzEF440bBDMlCxjwusxfe8HU8q7TjY/Yjwq7H5DMjrNQk4euVYb/elGTQnIt3kjZ2UTGtaO2H5/HD6kC6lcOja1kk9x517aczIrwkkY1ZcnFuqfM3vovZCGliGpvJy3kufiwKkLQsf8xxTAk/h8aAaieoONwCrVqFE488sEtpRd1DB+SaE2jiTyaJ8uMAdz5RCJZ6OhgMNDXGymZVnPBXXLi+Wspa/HKGpK8K2djg8Rvwm9/9R+2ZGgA29I899sUdB1zqnSyrZYw4y1bmacK36agJEsGsfAL/lgP0xrM8rBKYZwn8xpE8yniNqvFIXXyvr09XwJItbUG6FzAtlsXeHFHUOx/Xd42Ji2Wji2eVyNleR+kFWYJcizH7fnn9DzQitnm+Nc15JAGG2ks9HL73DMPG0E7/
 bXERflYA
 IGamayyV2k6P1DUNMrYB+DpjakkkvldKtCMmO1SJMjtWYfSsMQ/CdmucOdqmPVruuV01xocoTUSq6IwVxyN5ssUnukOL5LmdQpLzcIU4SP2mrcXjYAPUUieOtKrwwaP1kFZ/apPcQpwRZ98oT+mPHSTDcZjlG9Wnhl+a6UbZitnl9Dbwn2xkKVGjsV40cSoUy9+ER0nk+w5Sl1gp0AmwkK7vuPv2rf70Nck07
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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


