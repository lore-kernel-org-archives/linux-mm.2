Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86D0210A3D9E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 02:14:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF5ED6B00A4; Thu, 26 Mar 2026 22:14:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECDA36B00A6; Thu, 26 Mar 2026 22:14:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0AF86B00A8; Thu, 26 Mar 2026 22:14:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D03516B00A4
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:14:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 845E4BE4E6
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:14:51 +0000 (UTC)
X-FDA: 84590224782.26.8CB2F45
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id D154C80005
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:14:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qCDvFHls;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774577690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aCI7ssiILkMHWnNEWRqeaTC8kADA5FVp8TNFAvIRw20=;
	b=Z7OT6G6ZeQRAwe95HPFYwmISGhaaGNYHv+C4xb9mbabsaTew5ebCp0X6sZkhMm4HHdOgeZ
	Qb9rPguNDR6HFCtoDNCtTHcH+hYL5L4WQAT5GLmTjme5c4uAWErrPZm+MtYda5qaTCRlJl
	a5cuiYyUzGPTCD/Gddj5PAtx0CkJbyw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774577690; a=rsa-sha256;
	cv=none;
	b=PrDiN5I/R4EH7Eri/nVjG4DjvpQXkMGkzerJM6cW/K2GeCPIhEy5vN6sNvEfyYyLL/oltN
	H+dgXeWal2p9FJJPFDNnJOnegyQ+1CU1Hffuan8CWi42pI4yBIlaDVUTlMOPdiCnBb6t2g
	z+29FzbBzDbHwmGNGhZboRcszmiJm9U=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qCDvFHls;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774577688;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aCI7ssiILkMHWnNEWRqeaTC8kADA5FVp8TNFAvIRw20=;
	b=qCDvFHlsrwn4BvHyl/OogfK+SU4PjAk/orshzs5oMnmbbYqMdO8VxcJG7SBrE5JnvZqhvW
	kHDxMSY4i21WqlUHUenbjsbHJeQSPwrgThPtMRU39TVbMcqqZ2CIv39avji+vUki/1rSj8
	MrVPi7UsYpHW/i7zFvcn0mt99gsGNQA=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	willy@infradead.org,
	linux-mm@kvack.org
Cc: fvdl@google.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	linuxppc-dev@lists.ozlabs.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	linux-s390@vger.kernel.org,
	Usama Arif <usama.arif@linux.dev>
Subject: [v3 06/24] mm: thp: handle split failure in wp_huge_pmd()
Date: Thu, 26 Mar 2026 19:08:48 -0700
Message-ID: <20260327021403.214713-7-usama.arif@linux.dev>
In-Reply-To: <20260327021403.214713-1-usama.arif@linux.dev>
References: <20260327021403.214713-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: D154C80005
X-Stat-Signature: kc7i3njoptjkqyxha5aceq31378egjq9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774577689-703044
X-HE-Meta: U2FsdGVkX1+ekz4Lz01s+5XIXUMhwY1e/4gWmHPHmc9/gRvpxHbhBx5NYO7vxfsV8HJcsNS9Oaq5pXn4lvgVwUHtLIEs3YQhiCt9Vi/fPWo7S4AhXEakZH1Cj+FyfwNNBFQDTGSWPGQ66KQIWVDyvO1qUkFPUrxerqNndEja2pwD9yq6RPzxGkLR+JJwGRHQHcipLzeknWKNIGs/aADpwR+H37ouQkF9A1wpYyoby9Idvx+enTA2ExiWESBYbYjgJbrkDRhrX8jQEWNazpxStvBzzPmhVrH1jS5tbI9+X6/Jb+r6dOT9L39J3eiqI/GWy5ljq2ZrWRqqp5XhKXKv0WIUk7ZYczwBdYrvxgBs3HGXe67F8fJK0K9TeXJFoCeAM3DRQDVT9aGpTXofCboO2HYA50b4cRGqBfNpJTv8oUQfxL5pJlBBbJdR/xPmsjR44XfsJ3ZYqV2DMhQIFK5C4VXL+PWdKYEyOpg+xiIYf4d64Tr2891i8y0Je2q8+MivO6U24jdEt+kDcCXYn+nUV5LG148L91i8czUFKbPGVcq00qOTCTijgtKjC1hBZvkni5U3g+e4V3og09oSygiXEVLzcWkWSnRHfJlLdmVaSLJScwEh2zJfar4GpJXTPww1tZnjptGM0do39DBKkr8Jftaw/A6poxkFZlh22n1jRkQrSnuCmUmBnN27uW115Ug9j09fqcvlkdGtipU5a5F3H0Y6p+BEBewAWNmyFkJlsNCvlQm+9pOBJ+Uez79siKAPqzCw5PdOLk61DS8DUAnKZ5SWzGzIlJ85oL4qBDpLuB30lQ/a+RwUG5zZzmwr/CHfDIKoA37GTenbPMRoXE1R+Amzh7s3flhyCx334QNghkwx/lo7KZPLDoZg3HwDmVWwBHHrLkFJb/JTnTcKk1H/GExpEB4llIRdFbHLGwoeJYtj1U9zWdjOWTg/kDzrScpqaIgoMz6DTh30IKDPAFU
 nlajNd+z
 WMe2iGyKWqL+mh/Rj7+oGxgXPNaGO+d4+hWVwrQO7nJkRwc6LpFNDvGl5qWcmvsFAbTZ15rSLrDZ+lZNiYeAalcYWq+ka/AWDM6VCCyBi0zfoEupHD3hiWvJ5d+1pOC8Powl0DK0EwyWmUfsOJLZFhV3Ek4nrFS3S1X/ZJpCxlf6Pah8FhBkN0tqYiHs8VPwjeSLCLJ4DS2wGfTmfllcVoTB4Xt5KyM0kqPKBsqSUU/jAflF7wkW6ytPASCetGlNgv/U424URkUCwB+xrMPGqXOGO5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

wp_huge_pmd() splits the PMD when COW or write-notify must be handled at
PTE level (e.g., shared/file VMAs, userfaultfd).  It then returns
VM_FAULT_FALLBACK so the fault handler retries at PTE granularity.
If the split fails, the PMD is still huge.  The PTE fault path cannot
handle a huge PMD entry.
Return VM_FAULT_OOM on split failure, which signals the fault handler to
invoke the OOM killer or return -ENOMEM to userspace. This is similar to
what __handle_mm_fault would do if p4d_alloc or pud_alloc fails.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/memory.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index caf97c48cb166..b99ec3ffc18d1 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6328,8 +6328,13 @@ static inline vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
 	}
 
 split:
-	/* COW or write-notify handled on pte level: split pmd. */
-	__split_huge_pmd(vma, vmf->pmd, vmf->address, false);
+	/*
+	 * COW or write-notify handled on pte level: split pmd.
+	 * If split fails, the PMD is still huge so falling back
+	 * to PTE handling would be incorrect.
+	 */
+	if (__split_huge_pmd(vma, vmf->pmd, vmf->address, false))
+		return VM_FAULT_OOM;
 
 	return VM_FAULT_FALLBACK;
 }
-- 
2.52.0


