Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD8F110AB83C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 02:15:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 532F36B00B9; Thu, 26 Mar 2026 22:15:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50A246B00BB; Thu, 26 Mar 2026 22:15:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 447726B00BC; Thu, 26 Mar 2026 22:15:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3545F6B00B9
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:15:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 01B8C13C2B7
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:15:46 +0000 (UTC)
X-FDA: 84590227134.03.1EE051D
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5870F18000C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:15:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Hnot0p5K;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774577745; a=rsa-sha256;
	cv=none;
	b=tuvcj1mK36jMIyr3wI0N8yiGczRlqjeki4AP+titdu5iNxGNuS04MMH1YvdYTgbuTwGDx5
	/rReg6ODqGd72pHGPi9bUgtNPN2nSB76n3kssnw4Bt980hjUU9wkKXO3pFYgAavyZ5RdKu
	zUeZf2CtmUNI/qEJbghRN05Me+IH5sk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774577745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8tx/Qjve1iVx/sjsNymGDpKKmMZv1TUyDs/EfcYY5GE=;
	b=Rg302JzgrlplHou1tNHLCYrwRkHPdOMWBC3Zk/8fcwLTKNDJmQF4LgxovghA5KiVR/MeWw
	TUKjizYN3E30f4+aVr2+zR/wpSp8DcPwjb3fwKflRGrIf23hDGcbrOLCzO5cByRq+dwEM5
	fTdWSD4OBhL+aAjDhbOViguy88txRTc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Hnot0p5K;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774577743;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8tx/Qjve1iVx/sjsNymGDpKKmMZv1TUyDs/EfcYY5GE=;
	b=Hnot0p5K89CAv1AQSFPCVNypjXRfAocNMIZyWJnznY4gpq+GWy2CVy+0V7yyIEu0F+HuLG
	VCDbIV/SqybnVZSHtV9JQkcdTWMzMp9IQ8Hs+qWemVt0yevh5Dk4OIgO/2Wqfo3fp+W2Sb
	aJvabR1V9LfLrBzcx+XgaoHKYXMXuJs=
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
Subject: [v3 15/24] fs/dax: handle split_huge_pmd failure in dax_iomap_pmd_fault
Date: Thu, 26 Mar 2026 19:08:57 -0700
Message-ID: <20260327021403.214713-16-usama.arif@linux.dev>
In-Reply-To: <20260327021403.214713-1-usama.arif@linux.dev>
References: <20260327021403.214713-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5870F18000C
X-Stat-Signature: jtzixah4ikmagqur9f8i5y365zjm8o4c
X-HE-Tag: 1774577745-766645
X-HE-Meta: U2FsdGVkX18G4UAD0W51ZccfHsokDEecyw25rqu/b3yRJwbg6/Af48+/vJZfBRBpyePMF4/su9IaCiq9tAgDWASH2Ff4FoQJeWjfEplmg/mfz5WChQM59VK87bVTmn2W5L5AX6JUU5Ti6dK88hYcidUIbaYtO21FJrlAYZj1KgITwVUQCSyq2QEUpDNzfjU410Q0471BCVFdYIvasOfdhDZp1oBHXneBkurHpTULm1LBYGX1HbNOp1QUG1Blha97vSrWU0LbIM94NBFEQpNTdjAxAnALRd+ohIWo9cOwjpvBJHGD+hTMjRXkoj/us1dxgtwwX0yRY39KpMnsRPf5SlZlfxjBqtZM8ZfG5jqp3tZia1WhA6N7MtkYeMVtQyJ8I0TduI9ZPJyeUqls/Ui6FrmxT3djezo9KR0NLlQghePCAYeZFGM7y9I7AXWbv7ytAXgwiOLtoIKrd7jrLgqyNI0fIoSKwEIIKCCYs2KeE88kBQ5HdSz6+UYyzWqiqXgn9L/KMyEHnh871d+LGtN2FQ9SmeeeaPXutDWGFJCnVJMxTXp6rNPHYsCs73FSA4APJDIK3GFcri6X8bwnXPJ5mO6QQCbXt/3/PLK+O2qA8R7883q7N9WXytl7kffMUQflTXL9y7jWmjMwGeTs40BRtt/4t6G8HVJ9W4oUskfWTGR3IP0ni3EU7qYZBBp/fTd+D9gH0FwtAe6y9bwwli1rbNoXyCC6va0KcdzVlTXkxB1P/uDFP0nKtgLOINgOnnyAiJKG4JSVOEHPAxERBD96jdganDg0/IPzo6HigVhegpVkHXLSKGpg8kZaECiZZDhEQhV6qAANaFvKpf2SIZTTTsvllcM1K3Q61z4za1x+Uf05Ax+MaMJJS2GSnYyKW+oKZO5BRMCgq6GMO7vdS2rcGv9LniZoT5Z+8RIVkpshrxlVjYGt9eeMnbK6i4dKaMF3h6T5vwAo1udgy3r6sPY
 nnMUg4Bf
 SEBDnnfl26th0hi+DinbnglZqXXmQUbZInjX02Svj3CA7eOFAnSg9kJxXKrHsx2NE2p/BGfp20Hyd33QSjL/eo5kQoevj5cdJ7tB65N8IOGcqO9/f4FpnWM4Dtl3mNgmkU1uWA9v8UnFv2hghs/DX9rzwFfGwcwhjpgUi6ZCFlXWIfzM0/q/n+E5AvkLYCYUYARcw3tObnUH8DFlHq5n80O/tVkPbJa23bPsK04oZDUjgLunnb2l7KQT0dQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

dax_iomap_pmd_fault() splits a huge PMD when the PMD fault falls back
to PTE-level handling. The split is necessary so that the subsequent
PTE fault does not misinterpret the huge PMD entry as a page table
pointer.

In practice this cannot fail today: DAX VMAs are always file-backed,
and __split_huge_pmd() only allocates a PTE page table (the operation
that can return -ENOMEM) for anonymous VMAs. For file-backed VMAs the
split path simply zaps the PMD and returns 0.

Use WARN_ON_ONCE to document this invariant and check the return value
for __must_check compliance introduced in the next patch.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 fs/dax.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index a5237169b4679..ed1859e8a916f 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -2039,7 +2039,14 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, unsigned long *pfnp,
 	dax_unlock_entry(&xas, entry);
 fallback:
 	if (ret == VM_FAULT_FALLBACK) {
-		split_huge_pmd(vmf->vma, vmf->pmd, vmf->address);
+		/*
+		 * split_huge_pmd() cannot fail for file-backed (DAX) VMAs
+		 * since splitting only zaps the PMD without allocating a
+		 * PTE page table.
+		 */
+		if (WARN_ON_ONCE(split_huge_pmd(vmf->vma, vmf->pmd,
+						vmf->address)))
+			ret = VM_FAULT_OOM;
 		count_vm_event(THP_FAULT_FALLBACK);
 	}
 out:
-- 
2.52.0


