Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 041ACC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 12:21:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2F386B0098; Wed,  8 Jul 2026 08:21:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDF646B009B; Wed,  8 Jul 2026 08:21:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D59126B009D; Wed,  8 Jul 2026 08:21:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A98406B0098
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:21:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4298914011B
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 12:21:06 +0000 (UTC)
X-FDA: 84965518932.20.B4D248B
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf07.hostedemail.com (Postfix) with ESMTP id 973D74000A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 12:21:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ajxAyxBE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783513264;
	b=dO+QISLPuxTEb1r8dx5Vy6hw1AbYD01vUA1IUJ6PGxbHGcZdwKuSWY9YT3Gw3BlJUzirRu
	E9toOpB4XX0IFaSyWI0kKUn0+39b2U5Y1aM2EVLiDE3TJg6BMmctGbGONbHQ/3htCbpJmx
	/nM6FC6pVhFbLmV5TStjIQT/J9zEfhM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ajxAyxBE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783513264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qeBPE3qqNKkGc9km/JVfd9nfFQXbGiGolg9akkEkv5A=;
	b=eoPOZzXI4UpYe7VycV3n96PQ1M54ET9+KSw/r51J8TSCu6FjL2QTj3fPNwXPzLaXxucgjK
	KkBq7VIXqzlGsEj/A++nae5dEOc0SHVphm1R7LNXC2GS3dhick53O8SuGZpUmFaEBrKxii
	SVGaaQOVH/RcObHgwaH2DktwPMfErXk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783513263;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qeBPE3qqNKkGc9km/JVfd9nfFQXbGiGolg9akkEkv5A=;
	b=ajxAyxBESal7boD/bi8HZT804WclfFqwcrYVABQRi2Eb4JTN+ed/D2diDMMtnVf2ZtAL6H
	l7flUe5QstIg0w3bY11GKBJ9WQZSIyGWgB/VTG9ZbfKM8Dnug2ZkjRP3HmokIqcyi72Yn9
	b132k257dJ21thKwizSZBaGqG0b1DRo=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	apopple@nvidia.com,
	balbirs@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	matthew.brost@intel.com,
	npache@redhat.com,
	rakie.kim@sk.com,
	ryan.roberts@arm.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org
Cc: stable@vger.kernel.org
Subject: [PATCH v2 3/3] mm/huge_memory: skip device-private PMDs in madvise_free_huge_pmd
Date: Wed,  8 Jul 2026 05:20:09 -0700
Message-ID: <20260708122040.861335-4-usama.arif@linux.dev>
In-Reply-To: <20260708122040.861335-1-usama.arif@linux.dev>
References: <20260708122040.861335-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 973D74000A
X-Rspam-User: 
X-Stat-Signature: 8befc4p31ipemfgkjej8do6dqub5eb6x
X-Rspamd-Server: rspam03
X-HE-Tag: 1783513264-49476
X-HE-Meta: U2FsdGVkX18QNEY26Mkwf6cSJvxrcSSsNPnv2zW5c/9KdMjT28sr4IbvmmStEAi9IL+rOdz+r7jqlUME9kIAelzqlvpJ2hbkx++yTm2EyN6ZUOW1o0gQ/SC+vCN0u/aiBvaFRbRTlmXqBIHyhGom8mtpsVph3QwNxpAyWWhmOBEa7zaXjoYpWWp/VSTlgLcTW7lmiadCQtWCSWkwHnWoWk/JHw0A2/W0+8x60k07g5gIM2H6jTNskNp0cmtjaZCzyM2viN+L6hst5wy7rwHTKpSTUqczWf6Nk3aj9DhJRXkGBE6VhPgHOYNNTldWh1OIzxZvrJguw8JBoHi/FjT7CN6yndsARB9EcnQYYz6BHyo2H1eXcpzRrcqN4z3ugOo72NWx0Dm00CKZNIclKeytKArvzaALgVcyjTgxRDj2xEMeGhXcksBCQbzhbDp4H07b6G34vnqz7F9CGtlu4CacFB/bGHvPH4A0AeILW8HL+YUT0OMpc19niBUZKQL4F7LLuYjmpUAxMzeAkogGjCCkgoTrOuf+A6sEDjmTiBZ/5TIe6iZp+eaHiwfuu9q1TrfrDY8iJUnloECSDLbZvSPaYrWgcyAzbTK6RdepE/OyaMhy1gQz3b6l+yxCaJcZk0Xf3AmnkhPx5ceCZIzUCdw4rXF3aqY7U6GCOAjm4Ytma/dyyA3UbKXNb66RhlqIRj1EW7K4do4d+jXQCvxouLIh4MM+SUci8kErI9BSdfKkBYmGQsU1oMacpXo4fb7S9sdhIs8dTrFzNUMC1tkdh5jbTHvGw9OQbfga2U/1TpxpKJQUvAF8mSyzJAz9Xp6oOxt2BMuFLlTfVz7eWv4ImDvGzMekssE2oiRDD5KLk1eJKx62kUvyTfZS3VMPyls6VjUPUxNVjvPj+SCV4Ggp2VjkSrMbGVlnrefo66JBpsC8TuunLpwWvQdI3qcIy1VakYlcf+yvBNNQT8vqaKAPlL6
 SiayBgoT
 Ry8z/qZczy9ZlyNf8u9U/KjDBCxtj6TkOc5s63l1zsoJXkL8+/eB+roiAFadP8vcRu6+QNerXYl57FiHp/vk7E5uHgrmc6MqI7ipA1sVuJ+Ne1Wr4WWb7D93jqKCFr4VHXi8QJfDT2IXV96SRCoHN5WGhClGWydAQ6eoy6QYwxcrdpqqJuRu/UaL9t6x5dB9jzxFjYZr8msgInYwPYuhK1uLRgRMtaBBmtSkR0Qu4iwDvGOeDTXXjXW9dZrytzHc5G9/EEyMCPYlWrcTWjROprBqN4mxm43JsmGsdBxf28F4XFgd5n+2WBoNTDiz2Kch2xHHN2aRk7rgO9msekXLHpsIFHOaeM4r+736wOAI3bAHwMAxh9k6lPU4uwUYaxecJal0KX0V1rU0yyf/hF8DrjC+Iotq48GXN1qrZZuxEhtkW7yg5OlEU6oo2n3TqBmwwGyDu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

madvise_free_pte_range() checks pmd_trans_huge(*pmd) unlocked, then
madvise_free_huge_pmd() takes pmd_trans_huge_lock(). pmd_is_huge()
returns true for a device-private PMD, so orig_pmd can be device-private
and enter the !pmd_present() branch.

Allow device-private PMDs in that non-present assertion and continue to
out before calling pmd_folio(). This keeps the assertion for unexpected
PMD softleafs while skipping device-private PMDs like other non-present
PMDs in this path.

Potential trigger: an HMM-based GPU driver races with madvise(MADV_FREE):
migrate_vma_pages() flips the PMD to a device-private entry between the
caller's pmd_trans_huge() check and the callee's pmd_trans_huge_lock().

Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
Cc: <stable@vger.kernel.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/huge_memory.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c0892cc533a9..ddbdc83b4cae 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2298,7 +2298,8 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 
 	if (unlikely(!pmd_present(orig_pmd))) {
 		VM_BUG_ON(thp_migration_supported() &&
-				  !pmd_is_migration_entry(orig_pmd));
+				  !pmd_is_migration_entry(orig_pmd) &&
+				  !pmd_is_device_private_entry(orig_pmd));
 		goto out;
 	}
 
-- 
2.53.0-Meta


