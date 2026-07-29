Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 260F1C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:57:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F7176B017E; Wed, 29 Jul 2026 10:57:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 252A36B0180; Wed, 29 Jul 2026 10:57:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 167A76B0181; Wed, 29 Jul 2026 10:57:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E44C66B017E
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:57:21 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8D680160523
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:57:21 +0000 (UTC)
X-FDA: 85042117482.14.7C50323
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 047AF1C0009
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:57:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=efO7ojKA;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785337040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t+FsuwC2RrexyYjQNFP6CQ0ttOXgehh40MLyehj+reg=;
	b=q7QH+xtjNWFJ8HjofJ5m3JIvPS9GgtOZoF3HkZ1IGrSBX8uvXetva9izYb5O7WQ7cwHSJy
	os9astkggT0s2tNzQ1hYR+M5TDyQWaNyX3dHSSZrRQnjYQwvnygYz+q+wQFW8++dU/ZNyV
	O3lNDtPVf6yc2bQeBaPCJCVB4vqf14U=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=efO7ojKA;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785337040;
	b=AVKEyNfn4G0/BaNGnr0vY7+CeOMqTPRDs8fsTNxsRbtVRF+pca/Y0ChcLJLs3o8zYeNB89
	JMMscAhZkRZSMnx/THA6vzOhjRhm9Z7Yt9V5I3Xb9jIwNa0CNXGUzvGKTX5bl15ifN4LTj
	g7Ml8e4RQyIrdBYQ+BPLA3C10Z4FLlY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D5DB60A8F;
	Wed, 29 Jul 2026 14:57:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19AE01F00A3E;
	Wed, 29 Jul 2026 14:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785337039;
	bh=t+FsuwC2RrexyYjQNFP6CQ0ttOXgehh40MLyehj+reg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=efO7ojKAzloBKSRmnh9bcoj08OaYUtZKHmgRXQQoS1KBUEifIe+XxH3QyOsf0G6VV
	 usL/CcWEmlzNfD8Tv1C56UKLk4oYUl7wB6023NThMVHCiuu7UkWg+phiT7oPRovW56
	 YKx+LYBTx/ItWVA73ZhkceBrPQeRLsDl5E8sUsc22lpMGb8CSDTZJ/M2Yuhclak3kd
	 awsuKZlV4O4h/SB0X4P5C+Q3q8FFva+zgyE/69msRNycjrCsv41yNO3aFD+ewIBs/b
	 0xak86gc+hOhS2Xz+t1U05C5LLPbLC7aaSQlxIws5+G5y3VzqVbNp3wTjdXiwSlJJW
	 oB52WTFwFd7Cg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 22/22] kho: exclude hugetlb memory from scratch size calculation
Date: Wed, 29 Jul 2026 16:56:07 +0200
Message-ID: <20260729145610.2827231-23-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <20260729145610.2827231-1-pratyush@kernel.org>
References: <20260729145610.2827231-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 047AF1C0009
X-Stat-Signature: 4em1hoaeusrnywyuxefa116tftpwps5r
X-HE-Tag: 1785337039-962850
X-HE-Meta: U2FsdGVkX19I6jQvNRu4wGcGKO1ovKvxz40X24YIhvqpYH+bpkOr5yheybqqQq3J1b24WbUHd7lHt7QkwOyFYGId6gpRNgAyTbTHW9TXpAbQ/yU/Ey8A2pKTT3DCQMHmhxggnI+yIdN145zjjljSaF+drQplYbppioL7ExXR5KaGfKNhytKhCjLxNjvzSW6gpheSRUtTYRyy9E9pXQ/C8GNarMcWakD6C+CCYp4pseAu3S7lWUsRCa42Fakns+yKJ7OXm1O5cOui/N3Gtq1f630KoHupG1NNZUuYbPDGaapxzU8Pt1pT0kTsVeeg3XymUjDHk2aFYEexHBZZzGFnoDWz0YwydcOWFKyJQUljr0SwxBcpc83CwFXdSma8aD2/+0HAyPVpzYskCB6aFPDEDfQx1qMpBRbtPe7n9sWlVGb8/0hsOKBLfheGnQn6wbLnFUmPsf1ufFNkdkkDoMtIHVxlxB0eLFAcsJSjaMOu0ykz9pWf4HKv5xb/v7i7JGyuuy4aJ3lO8Gv1pkOlKvndZ/CpSVxYOFmbn+JU+GZwToh6mCpBC8Mi9XhkIvT9P2+UcEaOe30CyZ4tdm1z0yQ43bUEnq7Pf8M/E1tl7oEC+bOKpvRVwFAuCvGsc/x+CVBHf4bbUMSKLnnfWhK0P85hI8Jv97J1rs2gfSchp0Tvvev7lzRD3sLJf8zvJtxaR4ddlf8p2nXBEKnSaRGLbx2eq50zx5pTStoiV8nNXeieyFCI+bsnrzQwUfW499kHu1tIEtpikOn+1UaVMdDbVY16WyowqUfsAw689MofHwneTOhyV91L9B/KRnNu/NSuGglOUpMDT7/Imm6j2N1TGSgXjR8hCuELCnCcwWgtulprvhkABz3nkK4a7+LXXV3tUT2CqOp6WqWjg77GgUPCjoyU8nRXGl7X9A3IhUPi0SKQmgnWKtW3ZdF/CMNurzXKvVaWPk62zRQ27yyPEb44cuw
 XIRREOxn
 wY8vKdJUK1jbVMis+l+eZ89iqhZSKYqHfCTq7F4VY2EnRAjey5FVQgfMzRXY++QqTGajIp5M5k1UERj+meGDwA2nwzM6b3kSaI5JhwWdzrsjswHBJKyDb6Lq71Q7hxc1gvi4Apck6qsnPykcseHlex1NrLspVxLefqG1bIajQHzx0o6bpTCgmy7X+ChBv+/CME7Yny4pWTHITrpzKDZTG0H+JtZnXVAKywvT0llsjnGx5nmw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

HugeTLB pages can be preserved memory. So they are never allocated from
scratch. Instead, they are allocated from the memory blocks with no
preserved memory. These areas are detected at runtime on each boot.

But since they are allocated via memblock, they show up as RSRV_KERN,
and blow up the scratch size when scratch scale is in use.

All hugetlb pages are marked RSRV_HUGETLB. Subtract their size from
RSRV_KERN when calculating scratch sizes.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 4c0756993b1f..1ccd7b7c59a1 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -742,19 +742,24 @@ early_param("kho_scratch", kho_parse_scratch_size);
 static void __init scratch_size_update(void)
 {
 	/*
-	 * If fixed sizes are not provided via command line, calculate them
-	 * now.
+	 * If fixed sizes are not provided via command line, calculate them now.
+	 * Remove HugeTLB allocations from it because they never get allocated
+	 * from scratch.
 	 */
 	if (scratch_scale) {
 		phys_addr_t size;
 
 		size = memblock_reserved_kern_size(ARCH_LOW_ADDRESS_LIMIT,
 						   NUMA_NO_NODE);
+		size -= memblock_reserved_hugetlb_size(ARCH_LOW_ADDRESS_LIMIT,
+						       NUMA_NO_NODE);
 		size = size * scratch_scale / 100;
 		scratch_size_lowmem = size;
 
 		size = memblock_reserved_kern_size(MEMBLOCK_ALLOC_ANYWHERE,
 						   NUMA_NO_NODE);
+		size -= memblock_reserved_hugetlb_size(MEMBLOCK_ALLOC_ANYWHERE,
+						       NUMA_NO_NODE);
 		size = size * scratch_scale / 100 - scratch_size_lowmem;
 		scratch_size_global = size;
 	}
@@ -774,6 +779,9 @@ static phys_addr_t __init scratch_size_node(int nid)
 	if (scratch_scale) {
 		size = memblock_reserved_kern_size(MEMBLOCK_ALLOC_ANYWHERE,
 						   nid);
+		/* Do not count HugeTLB pages. */
+		size -= memblock_reserved_hugetlb_size(MEMBLOCK_ALLOC_ANYWHERE,
+						       nid);
 		size = size * scratch_scale / 100;
 	} else {
 		size = scratch_size_pernode;
-- 
2.55.0.508.g3f0d502094-goog


