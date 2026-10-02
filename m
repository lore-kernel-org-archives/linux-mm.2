Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EB53CA5FC4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:57:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EADA56B00B8; Fri,  2 Oct 2026 05:57:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5E6B6B00B9; Fri,  2 Oct 2026 05:57:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD8566B00BA; Fri,  2 Oct 2026 05:57:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A40636B00B8
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:57:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 46B9BA7621
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:57:06 +0000 (UTC)
X-FDA: 85277232852.01.D249B82
Received: from mta0.migadu.com (out-136.mta0.migadu.com [91.218.175.136])
	by imf22.hostedemail.com (Postfix) with ESMTP id 68E0DC0003
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:57:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NeCRGXST;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.136 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790935024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=huH6oSd7gTMk6bCw3wFvetQjWaUFvstahrkAvJSP3YA=;
	b=hkGc4srr0HWE5GBvV/MelStTwTePePPhflvzNbIEjkJFGEuuk2C0hmCUNeuiAb3bOrY6Wo
	gVlBa8vTOp/gi62Ec7o3oK4g0+a4qeL5jK3rR9qm3gD5wY6KLoOqeUhVP1Bd6QAO7Q/Iaa
	je1ABrLpKh3Rr4v7D1bCOd5POHyFjz0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NeCRGXST;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.136 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790935024;
	b=nyA20AFIC/218P01r7l1Baxbp05p1zqmIhf18fiDCn4DwJFckYP4dx12bOCa20njsZvuAb
	B/eQON6TUZwPP+Bu/nEFiNl0011gCMhYHIWU7CJpsco7UDUlBVCyV9nt1+bKzl9X6OL8BY
	X0prOAy34QWR3rKeMsMmfz8Ah7rJCNs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=EsV4QmuE2zIVMKtO/SOhRrFUuEtNtiAe7xebMuMrx54=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790935023; v=1; x=1791539823;
 b=NeCRGXSTGWfHGH9nTdqHnUHOoYToHUcfwajejK8iXk88Y2IhVI1ONvbD8VUmxLyOhGv8LhDZ
 WZz/2rZr+zCQsx6NahvNRERAo6khQdf77pwuvV8U4H/wrAX0gBooXejKZSb5NKfKqgS7vTtE6td
 pggSbfzxY5DEZuhRpW/yvIiM=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 3b859f7e4ff92309;
	Fri, 02 Oct 2026 09:57:03 +0000
X-Mizu-Trace-ID: 3b859f7e4ff92309
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
Subject: [PATCH v8 18/30] mm/hmm: fault PMD swap entries on demand
Date: Fri,  2 Oct 2026 02:52:32 -0700
Message-ID: <20261002095503.3585565-19-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002095503.3585565-1-usama.arif@linux.dev>
References: <20261002095503.3585565-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 386p8mod3kzm53pd4kbiyqzsagnpajow
X-Rspamd-Queue-Id: 68E0DC0003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790935024-521312
X-HE-Meta: U2FsdGVkX1+Yb/8ky5kJhHj/3dzIOsxhW1GpE8tqDipEzwleQQMLZP+q16TNvZtVpOsV469XoqBz+Xn/YNYY0Ph37WI3CMVXJ3O5DvFCer9jHitCEIVcy/QYOOjDaFuvyvYOtDUP7SGpRvSonESqVjergiZ4uGaDoUpwOdMKQY6o1TB/ZxlXV+EGWUfsYjEnh/f03U9+7XbBLNliUoypCpikuZRQtRi3EH8iIqATMJIR1OFKgG6EYx+IcYBII93CW9bkF+QPY2ixhFkY4TwYEdAsUSMKIG2H66DTSn9nVnLuZ4Zro2nlxlshCFX1kt30p5y1yYzFbZaNTj8dm85FL0byzbS/tqlbCjGiwYt+KybpcQ94uU30SqEh7XiT7g6TU7Si1ho++EAv7GE+8jyHHVStYdAT3FIMwW/VHVgumA/seYl6AJbxP3QnZNWE+ekQ9RZFoAhvunA+nm1P5ED/qCQbyw/zP7AvNxnSKDrMwyf657PSyP6IFRqQ2Mkd86Y3AJiOy1dg0oWptUouEUjmpjKjIUdoMaJIMvA8adhQDK5jV6oiEYxe8Wq23V44SCDdLGDT9Jh00LuU4LCs5FmQxglHvi/XQZkAz/90TE9IGWYweNbgljIgrWWZMJGSGj7i8QNR7pIwL/cacQi/q0raPyKTAwl67l5e1W3lBtTBbdvPdPJy7gOIT5Kk6SI1KLF8bzB3OTW1sFCQghjdTAJw/UmFkbj0SI4sSe45f5x7hfS2jXD6Arv1U44wIsxBPTRZybxtWvDqFiSmNjv0L19RrSPtVRi0t1kLinn+ropNPpxCG9Pbpnw8IIlhFg/OosueUVtlgSaKh/+8OJr2+SFWCqpik52Qo4e/Su/cL//C+nPFp9Fl7KbyROsyeSfq4w6LYFV7UeHEv18cZSTsKb4jAP1T5n0VP6tKYZpfN+Wb2VD5/XsuChkcE3ZL4EyCuwGxJ+f9FGG7PyG0WzzyP4O
 1B4I9vWg
 dinETKVlDg6R4ejn0P/TYMgxoEOGOqR4ZDqupDjgDasHMgJhiGBGKQet5bicj2r39IEjDq5IJQy3ONfzZwzJQfUDc64DNqMZpPDsox1UifmCt8HdqbDFDJHwY4Iz8MfcFjW1zAs/tLClGv7Qp/sQsZw2UezYeopWJJCtrdOBc26gnIyii7zrQVGeRuipHjWACq5zlQcntoImt5EnIlsOxxMmcgIg0xiHGz6C/
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


