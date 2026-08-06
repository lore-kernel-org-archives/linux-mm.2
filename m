Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29F52C56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 10:30:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17D516B00A4; Thu,  6 Aug 2026 06:30:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12DA86B00A7; Thu,  6 Aug 2026 06:30:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06AF86B00A9; Thu,  6 Aug 2026 06:30:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D92E26B00A4
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 06:30:55 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 68EF012068E
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:30:55 +0000 (UTC)
X-FDA: 85070476470.12.A49E42A
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf14.hostedemail.com (Postfix) with ESMTP id B78D9100013
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:30:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NCjeseqn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786012253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JK2AKIRn82zgxTROLz0cwM7jg9tWPGT5sQ8PIyewZYk=;
	b=oYMEaA9dfRVFNVq9PpWUaAw36gsOK6c6boLRGbGNmbioRjAE67pDQw1M++1Go+m02B1AvN
	uPLsDt5JuWQsqxoKqtiIsrh1C8+mOJULUI9egy1uY+9jDJsNG2kr2DDTu9/j/b6n+ykuo9
	B5Lm4U2Al/joqSdWAggi8WDzopw2CuA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NCjeseqn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786012253;
	b=11b37CIKwTd9IfkyjlC/qfATt75zg/ykMfgLbHw3tYcOJIhOLnLwEKuoLFd8W0Hp0xkhmQ
	GOgYeq+V2B2Sl03BrtURWuy/vJ6y7fP62ug//Sv/v2Th6qg6E7+IDDFqzVwVg4jruTxRAX
	MqXoj9jcwC2PVh2NPKMKLnNRxLQEd0k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786012252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JK2AKIRn82zgxTROLz0cwM7jg9tWPGT5sQ8PIyewZYk=;
	b=NCjeseqnEmTpQbi0MmppVqiVmyc4wlO5c5CsxDHvXIq3GONofZpFATn/ZeAKBiTYmVH1T9
	FNsbDA8HzpYXqiEJCtA2vYd6fwiCnoL+RcSBmYytBV9P2ittOcusdgue+IrxyLghJLOBeA
	WER4gfW5hJ0A18CM2rZpJLMlvfZajEI=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	Baoquan He <baoquan.he@linux.dev>
Subject: [RFC PATCH 4/6] mm/mglru: report hot PUDs from the rmap feedback path
Date: Thu,  6 Aug 2026 18:29:58 +0800
Message-ID: <20260806103003.3924438-5-baoquan.he@linux.dev>
In-Reply-To: <20260806103003.3924438-1-baoquan.he@linux.dev>
References: <20260806103003.3924438-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B78D9100013
X-Stat-Signature: r6xe5xocaeqcc1nto5jmtx6b83s86bwa
X-Rspam-User: 
X-HE-Tag: 1786012253-276954
X-HE-Meta: U2FsdGVkX18j33SCQZwmH/6/KJ9SY5EfEqvWlIlL745+hCDVhVdXL8nrlhvb4G+aMbWCDqz5VD34n4NJHf1qN87Tlb3MbGZsETI66us4fSSb51qw4Ii5ONjv9ltE9ihLmNZJakmreBtG+8Wldgr1TWPrMfWaktzDFfv/vjx3njazZ9Bj9mkIblhHcRth/mYUsiZKjq3OBmgPBq60DdpS4Y8HHuIwdt/Ugf4LeRxAEm4ForT74XNnxf5kfnrVt3A6aQ/x7vaaHOFAmZvBmqtI5OfAZHvL8I/MsEPOHhLZKdg7H2kBRFn1rgeq4kVfgagqmva3iHPxTzlOXPu4sLoIV2pooiKun5+e/uOi57n4DVjNthALVLDxyIcnXnQZkq8sibYavbb6LFXyI26Xvorml2tYKTGB2NbE3TMYf9MmoU2Mf8K0ha1yhdwdLVzq6pCGYbOY4Reh8JQ7P18cdFHbw/XX2c5GY4d5ggaJZ7Pnbzm2FFx29pXJnOxAJQ4AwNRCkpzRmNrlNSFGx/wrYLcMJRcW6CARqKvc0KOOohfK4nKX/a1buHMtUpBEVV6Vk7+JLPfdR45tCG4yaj1Rx15O1Ftq0cTV/DO72FnBUvGgcNcJ9LpMAiZKC+HaG7erdKbXs9VFg3AQJk1R565GSNQzqGOIYPseCYY1wbEsJx380dor9/o+3+QsgkgCmdB0oecnBI3PTGy7vIAOGkjWKHFbbDmJqOoCJl4Z6cUN3NFAScTY1Xy8sewfZWERrd1OH86q+ZZlN/TtJzyd4Ge6aPEuLDxrrefbpm9jTGTj7aV0lizFAhcM1fmjd+x+QxvfNyzE76ul0IcT6/hjrF6CohmjAemsCF4smyuspX0FY3J36ArIiSwcqPnrDOoWEbs53rfHlQpQQHYt6/uAGpcdWSVsf9Hq4wB9V/KzyObmW/aWntEaCeZJkJbxVZONJd9FG9C/HYSdpjuPHOXxYPz6Rbz
 y/zwopRM
 tD1FpOJyUCkKxLzoo1NP6iB1rpQfXnqWeVRLZVbpoUOVFb99X/hNv4fFSxC18ZBe+P97aXIVfb5sPFmh3JPPhed0i1Zn48yJek6/IwBpcrTJvEHEzCrI+TECNne2QA4y44PyJS9isZWUqsGvktPhIrcl0IQpcRWgJiGdpopyYzFToOOp/clnC/gXR92JBd3Vs15dS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

lru_gen_look_around() marks the PMD of a young PTE found during the
eviction rmap walk, feeding hot regions back to the aging walker.
With the PUD-level filter in place, that PMD marking alone is not
enough: the next aging walk would test the containing PUD first and
skip the whole 1GB subtree if the PUD is unmarked, never reaching the
PMD. Mark the covering PUD as well, so regions whose hotness is only
observed by eviction keep getting re-scanned by aging.

The PUD entry is re-derived from the mm page tables via pgd_offset()/
p4d_offset()/pud_offset(); it is only hashed, never dereferenced, and
the mmap lock held by the rmap walk keeps the table chain valid.

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 mm/vmscan.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 74edfe2a747d..ca0f06641adc 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4416,8 +4416,14 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 	lazy_mmu_mode_disable();
 
 	/* feedback from rmap walkers to page table walkers */
-	if (mm_state && suitable_to_scan(i, young))
+	if (mm_state && suitable_to_scan(i, young)) {
+		/* the PUD entry covering the young PTEs scanned above */
+		pud_t *pud_p = pud_offset(p4d_offset(pgd_offset(vma->vm_mm, pvmw->address),
+						     pvmw->address), pvmw->address);
+
 		update_bloom_filter(mm_state, max_seq, pvmw->pmd);
+		update_pud_bloom_filter(mm_state, max_seq, pud_p);
+	}
 
 	mem_cgroup_put(memcg);
 
-- 
2.54.0


