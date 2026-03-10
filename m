Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CFF6EB1054
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 14:55:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A55A6B00BB; Tue, 10 Mar 2026 10:55:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76FF46B00BE; Tue, 10 Mar 2026 10:55:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 686056B00C0; Tue, 10 Mar 2026 10:55:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5517C6B00BB
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:55:03 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20F16C0EEC
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:55:03 +0000 (UTC)
X-FDA: 84530450886.28.30B86A8
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf24.hostedemail.com (Postfix) with ESMTP id 600AB180008
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:55:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Q7J9Xayb;
	spf=pass (imf24.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773154501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Koap7c4nmBUn1jQcRs2TKnT3RilQxG9yZc8gbf4yHA=;
	b=JIpiwk9DtQdSxnqwcKjZvUL8+GzfgFbDIxXcPvKPFe4wUhdH0nsTjgA5gwPsHt0UYdOIst
	+OGkoe9/xgo3/Uy1fxKhK96uwPHSkkEasYiYFRsg2yrMyMjdx95bFNVSdx8CpvmNNDN4cY
	8qoPG715EwvGmbkbHPeflzbfgeOKyIM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773154501; a=rsa-sha256;
	cv=none;
	b=xkVHDSqGNDy+VO5mD5ngalEgs4DFNrBSrbCAfMI6JFimj/iu0+YYYyu9Aq6y6CcQhQP+2k
	m/4CioPONl9FKfXfZLuaZn1w93wV/JmqP6QdRQZ3ChOOFpYw0um0CqJKjG2TxkQq4JBDaI
	QkN19wqQlNEgO9c74HvNudfSoCCENFk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Q7J9Xayb;
	spf=pass (imf24.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773154499;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Koap7c4nmBUn1jQcRs2TKnT3RilQxG9yZc8gbf4yHA=;
	b=Q7J9Xayb3tuq1RwczoR+kkYcwmbHr2IBdva+1kWyUfpOmeUqFxY8p3HhUG0VvkvFVRO7cq
	rcbAym+WsHWFr//SsTKMXbfjnthBN1AVMJKC4S1BQIu+Y4f+asu6YqEK9FjMKM6HNAuqFg
	o+kIhQjL1lj8wyLdBd5OI3jV01FKMB4=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	ryan.roberts@arm.com,
	david@kernel.org
Cc: ajd@linux.ibm.com,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	brauner@kernel.org,
	catalin.marinas@arm.com,
	dev.jain@arm.com,
	jack@suse.cz,
	kees@kernel.org,
	kevin.brodsky@arm.com,
	lance.yang@linux.dev,
	Liam.Howlett@oracle.com,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	npache@redhat.com,
	rmclure@linux.ibm.com,
	Al Viro <viro@zeniv.linux.org.uk>,
	will@kernel.org,
	willy@infradead.org,
	ziy@nvidia.com,
	hannes@cmpxchg.org,
	kas@kernel.org,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH 4/4] mm: align file-backed mmap to exec folio order in thp_get_unmapped_area
Date: Tue, 10 Mar 2026 07:51:17 -0700
Message-ID: <20260310145406.3073394-5-usama.arif@linux.dev>
In-Reply-To: <20260310145406.3073394-1-usama.arif@linux.dev>
References: <20260310145406.3073394-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: u48wfk8ghkboh1ew4yod7odg4tcjf9j9
X-Rspam-User: 
X-Rspamd-Queue-Id: 600AB180008
X-Rspamd-Server: rspam12
X-HE-Tag: 1773154501-16187
X-HE-Meta: U2FsdGVkX19oXNg6vnkjLDLjoMvlQWnSiZnjYSYLrr10v7ZdOcBb6+FJ6FlzECobFC5SXaTy31ZAWckFjjvOzwQCx1Cv3nRC1yxJ+fGRz74h/FtkJPzxts/D+qFoTuUlZnpFKawenSdOAx+8VLbn27+gyE6VIyRM6mvH26dFGTD1o6SaYacBHXH/egq02qr0qxTD9aT/7D2ewIe8ez1QUw2lr7X5ChWhk1U4P4/wzoqqc3MsRiJlDjM3ibi4yZn8YtKDTagtd/PGnjJA8RhLiRFbzcMW+C6AbkzxX/JOhtwOPdSd6lRJyhJlY8Pqgu45gzcqnlIzKpM32ZwCViiqXfr0hmXDVus2xC7pUgm4cZarOqvRHQoAc70/9hxZvFTjB3ZW/rVcNm+x2hU0/u1DKVWar6hijPqmzgSVNxTk2hSmE7jEJJYhihXFrDT91nTh+sbgja1XwcHWauo7YQL+7wHPryVshlLjfLj6BN1BsMGoPPBPkAAOYi0myqT8eHSTaitPACdHKl69MeLrbHOIdTE0QBq7zwDCAeb+P6lth+RWpzocvkarJ6ybsnUBxeMkFqJJo5HaWKzx4LlqeDokrHn4g8j+yaC8oOZASefhQ4387ugkgS8O2UdqlQ4unSjW01JZsZJesi7KbcJlkJyQjSuoY8IJjWr4Ph1nd8uhqfnCo7Euf2x6toxIvf62G97hu4RPMXcTJgsNVYjTQuLVV+55XfT2kXJF9wc2PTF8zZCUykSsebog9qhBF6SsS22W8n4BG1eDIVjiX6cbITt3bzYGi9/M1kflWHz58JC/9Yun0ghw361flkeU7upUKYXtLlyxpEWPOUo1/EcsjF2YFRAHHQdj3+wQpDui/6kUAJfZwbGnFLz2AQOgdJlx8iMiOCk9HKLdY51HklxIlt7SAqsUwYVLKQk1eTIzcgeqeYb8de0vdaziHBYeoihYC9aMthh4F4iMCBMOoPilp6R
 UNy3USg6
 455o/to5TFWHrFiCgPMFVoBtLRTh/QPvB1bHtV1LZStz+UjXkx8ToZsG7kMbTFLitrPfMZ/bsTDX1SDGf7MbonZkUfgbFvVn5hnIWi/V/XwIi3bogvpm9mNpeIOAuAFpnRe3fuDis/wObr8ARdZcr1ZAxXabhxe4DehNrgNALXjtjmvw1JsffABqPYu2DS+GahXhX6/53RwRFGzJJfUQzNA7Ixtb0zyu7f2bNk7ASXi3aJsFnQhYXP7x+IQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

thp_get_unmapped_area() is the get_unmapped_area callback for
filesystems like ext4, xfs, and btrfs. It attempts to align the virtual
address for PMD_SIZE THP mappings, but on arm64 with 64K base pages
PMD_SIZE is 512M, which is too large for typical shared library mappings,
so the alignment always fails and falls back to PAGE_SIZE.

This means shared libraries loaded by ld.so via mmap() get 64K-aligned
virtual addresses, preventing contpte mapping even when 2M folios are
allocated with properly aligned file offsets and physical addresses.

Add a fallback in thp_get_unmapped_area_vmflags() that tries
PAGE_SIZE << exec_folio_order() alignment (2M on arm64 64K pages)
when PMD_SIZE alignment fails. This is small enough that shared
libraries could qualify, enabling contpte mapping for their executable
segments.

This applies to all file-backed mappings (not just exec). Non-exec
file-backed mappings also benefit from contpte mapping when large
folios are used. Aligning all file-backed mappings ensures that any
large folio in the page cache can be contpte-mapped regardless of
the mapping's protection flags, reducing dTLB misses for read-heavy
workloads.

The fallback is gated by exec_folio_order() which returns 0 by default,
making this a no-op on architectures that don't define it.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/huge_memory.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8e2746ea74adf..1c9476a5ed51c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1242,6 +1242,23 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
 	if (ret)
 		return ret;
 
+	/*
+	 * If the arch requested large folios for exec memory, try to align
+	 * to the folio size as a fallback. This is much smaller than PMD_SIZE
+	 * (e.g. 2M vs 512M on arm64 64K pages), so it succeeds for mappings
+	 * that are too small for PMD alignment. Proper alignment ensures that
+	 * the hardware can coalesce PTEs (e.g. arm64 contpte) when large
+	 * folios are mapped.
+	 */
+	if (exec_folio_order()) {
+		unsigned long folio_size = PAGE_SIZE << exec_folio_order();
+
+		ret = __thp_get_unmapped_area(filp, addr, len, off, flags,
+					      folio_size, vm_flags);
+		if (ret)
+			return ret;
+	}
+
 	return mm_get_unmapped_area_vmflags(filp, addr, len, pgoff, flags,
 					    vm_flags);
 }
-- 
2.47.3


