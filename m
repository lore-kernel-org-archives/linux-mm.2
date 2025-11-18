Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9B64CEE347
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 18:18:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F97D6B0011; Tue, 18 Nov 2025 13:18:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D0E96B0098; Tue, 18 Nov 2025 13:18:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E71E6B0099; Tue, 18 Nov 2025 13:18:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F052C6B0011
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 13:18:21 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A4D5D56503
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 18:18:21 +0000 (UTC)
X-FDA: 84124537602.10.57CA40A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2251CA000F
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 18:18:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hIjpsigb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763489900; a=rsa-sha256;
	cv=none;
	b=Mkr/q9NfA2QXrtpEQpcIFjeIhm8N3Wie6nl4nPjBR9TsJIUbCThz7wwH8miZoDwcuEkTMO
	KsSmHCTKiIChXAr2eWdWPr9jYZM/r7b3aZwYGNhf67sQ7gxcwDSpNgFhn7OXGicZT2M7lX
	nuurqziLCaPy3CQgOTZoXWs12AbMoTs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hIjpsigb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763489900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JgiFawHTV8sjMcTxgYzGBKzIQAziP/HDriKppK8XrKA=;
	b=jm1S8VMidIGANnFFwoDOBbnLX2hYWgqukB0WyQfhQ+aIm47TIrzMb7HZ2PiVO5NQO1iDeV
	Eo9rcNgC3lTIPpr000SVD3J26hQvmH7dlN8D0yVs7jiSXP13yx1JEp+eU5d5GUFR8FXX2o
	qgQIpRwox516TGSscxES+ebQqhU3638=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D6D4416DB;
	Tue, 18 Nov 2025 18:18:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15735C4CEF1;
	Tue, 18 Nov 2025 18:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763489898;
	bh=FWLUqOdMeWCRKRBg/ecVB9LXW/vLiI6Nwu+aIyQipT8=;
	h=From:To:Cc:Subject:Date:From;
	b=hIjpsigbCNnQYXYNp8d9ZiAyOO1Zwgsu9A+V1gdsHGNJLBYjlzdFAmsJyyIxCkIrc
	 dyQx6yhhm3emDdwE8Zq+dJcSTcIJNvIGvlLMTjtw/BURzonlJqWGAoAEsXRLJC0ZYL
	 dIh5QFwCOWleYdyi9USWnzQ94WEHzrewk/ggEEpK+4MTLdNpb6+VnEHGVd3DlyYsIA
	 kXrRhIXQRXWPSEQa1gsGhn+lYj20u5z3jAcXU7WlsbQPltws8ptQp8VOoXjADjRtVS
	 Dg8mUZrezNJApRZ0WpIOptUq95rvLeQPsPIP7d/CYSsHORCkQBD3VJ7OCehG1xyQ8G
	 +gwgNphc5NjHA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] kho: free already restored pages when kho_restore_vmalloc() fails
Date: Tue, 18 Nov 2025 19:18:10 +0100
Message-ID: <20251118181811.47336-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.51.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2251CA000F
X-Stat-Signature: sjwu8gyu3z1ynr779i7srksnwfe7qeai
X-Rspam-User: 
X-HE-Tag: 1763489899-340777
X-HE-Meta: U2FsdGVkX1+ZHm6hPDNuTvbHHoMcF0U8ClXBvVFzXXn8tKEoq/Q8mJlknJPUOA4aa/LwbLFEPHtL9/NTMIlQUuG/iLQvGEVBzX+ViIbTGN/QdqpXhauCYt2eijCB+lW3FYKC57jzggHhNGIzrNnRemSEaqHl4SqQed4+uhiGhE8tyDlrDHyyZ3ol6yzoX1y3LzTs5ctDBc8K3GWHLuQN/gpd5tm1EsBJYP38hw7/lbJYwdYcQgYZszXCC7pA8WpmzJOhiCqvU//hIq0JP5cpk8/bB9aCsybwP2rIyDipLz9VZSo8suGdnt4AtK5fkrjgHXWULmE4S1LC2nNr7CxkC5zvn1qcK8dYjE1w/PTYKVqp7U9i7m9LuAtzlcmgpDZ+GpeX/Cd1LNRKssQ5j0lLC1BUbr03NVhutgtXoMDFjQ/shCg4KPw0m/Hop8GnNFpEl/Rxgui4GiIG1Aky4ujot/is1tqIairFSv2Y8PGe7nqNqw6ffc2WN55g52CJry3XbTTh9Zebj9+FmoRoO8D/KCiDLcQFNLKjxG8ple6HChIshSLBvGDru9rgBa3vOI7b5Q0zAH6WIbcG1/Nziu9gGqFVuuWTRQJfZCBI64AlZD7xmtF+JExuHZfsWUFyrzfZw8qNLFdzzzZ0DCa+QwBIt4dOsOqtOduPsHN905q1FSzK5M+L6+An+lUKH2/QkJ0URiA/xXjnBHiqfkVb5i77nyynPl1uzjwvzUiZ1PO8YNb5hObIoooHtJFbwXBdT4lUQEILX7C5myy6U+MrtcUuFYaOMJEWy0ofBU7AHq28CwBSL5mtlns+YyuaDVxyi2teNGNduUCeYXQ962+mJPeiCz/30Q/g5bkXQnS2h1UBQllwn11a+354pHJEp7wiKIzO48Yu/Py6cIPb4y4+kvKsmmnjcfkaKRPnwuK/PNPPZ4VLulNFuXn7qKwMNk5p/nQEYs2+rhRWxj8VZm5bCti
 pg4GWRLJ
 RQHcJ1/SvyyfC16hMC9vLPn7lZvcOpCGUXJT1iKjRVzkD3GJ/6bZy0KKiqj/gkeMr4tSLFpXJ2uGVEMDapmZLV+G2M2seihn07hakIrOEqMIF0y19PEtk8yaDpDIXGNAmiQF1mVNoH3myG1znopYhlFPh0j4hgWPIC3TIBQkbb2Hy98euuXI+DyQWako2CzTSCG8f+9LCgOngbmCb4wLc4arMY+44Ec5aTrxv0viwJj6i37LzAREAMJYtp2Ys4QsVK8Br/Nx/pp+HQUmfQxrXBFqMnA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When kho_restore_vmalloc() fails, it frees up the pages array, but not
the pages it contains. These are the pages that were successfully
restored using kho_restore_pages(). If the failure happens when
restoring the pages, the ones successfully restored are leaked. If the
failure happens when allocating the vm_area or when mapping the pages,
all the pages of the preserved vmalloc buffer are leaked.

Free all of the successfully restored pages before returning error.

Fixes: a667300bd53f2 ("kho: add support for preserving vmalloc allocations")
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 224bdf5becb68..515339fa526e0 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1088,11 +1088,11 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
 			phys_addr_t phys = chunk->phys[i];
 
 			if (idx + contig_pages > total_pages)
-				goto err_free_pages_array;
+				goto err_free_pages;
 
 			page = kho_restore_pages(phys, contig_pages);
 			if (!page)
-				goto err_free_pages_array;
+				goto err_free_pages;
 
 			for (int j = 0; j < contig_pages; j++)
 				pages[idx++] = page;
@@ -1102,20 +1102,20 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
 
 		page = kho_restore_pages(virt_to_phys(chunk), 1);
 		if (!page)
-			goto err_free_pages_array;
+			goto err_free_pages;
 		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
 		__free_page(page);
 	}
 
 	if (idx != total_pages)
-		goto err_free_pages_array;
+		goto err_free_pages;
 
 	area = __get_vm_area_node(total_pages * PAGE_SIZE, align, shift,
 				  vm_flags, VMALLOC_START, VMALLOC_END,
 				  NUMA_NO_NODE, GFP_KERNEL,
 				  __builtin_return_address(0));
 	if (!area)
-		goto err_free_pages_array;
+		goto err_free_pages;
 
 	addr = (unsigned long)area->addr;
 	size = get_vm_area_size(area);
@@ -1130,7 +1130,10 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
 
 err_free_vm_area:
 	free_vm_area(area);
-err_free_pages_array:
+err_free_pages:
+	for (int i = 0; i < idx; i++)
+		__free_page(pages[i]);
+
 	kvfree(pages);
 	return NULL;
 }

base-commit: f0bfdc2b69f5c600b88ee484c01b213712c63d94
prerequisite-patch-id: f54df1de9bdcb4fe396940cdcc578f5adcc9397c
-- 
2.47.3


