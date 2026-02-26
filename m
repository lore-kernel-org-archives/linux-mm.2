Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58A09FC5933
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 11:33:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EF8E6B00A1; Thu, 26 Feb 2026 06:33:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A6436B00A2; Thu, 26 Feb 2026 06:33:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C9696B00A3; Thu, 26 Feb 2026 06:33:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7706C6B00A1
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:33:44 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 163C013C0B4
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:33:44 +0000 (UTC)
X-FDA: 84486397968.08.EECC28B
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4005C100003
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:33:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RzdiMKp1;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772105622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HW5NR2wuAB2pCKpIclCqiHUIfVFdsbldp3G0DhmGrt0=;
	b=vJkUjekkT0mlDQRC8gnxE9XYCAh1GzM+eiqEPrmTnmDKdqHE54LUbAAqB4Puwd9EMfzl0S
	vpj0jLZ9XjipWMY5rGGnnae1FjtfoFIk8YuP4bG+pHypyFXJfy/LcsfM0UG0GjvsKaO9Ei
	UDgRaCmk16i4QOGrI1osXP49fkGRSlA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RzdiMKp1;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772105622; a=rsa-sha256;
	cv=none;
	b=pIrMsloPEcCxNEijlMRycfL+8IFLiwpvYnmF/BOlwN4d9BBnun1u5RlhZIAICVis8q9r8T
	9ptQRGUGtgMI2EOwcL44zATK3mGsABnyYzQa18QOioppZ92ayD5nrpSnGO5yzJNpXdNb/k
	rcuxp0PMrvYLQCNxKEnDENY0rgrKaas=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772105620;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HW5NR2wuAB2pCKpIclCqiHUIfVFdsbldp3G0DhmGrt0=;
	b=RzdiMKp1lP+byHUz7l0eKCj1eX9Ut37lQaDPNj8KBcBVLlesiFHpqHK5Ah8iyhlMOrVaW8
	bKBZ75Ay6+l6RYyt5Y/uNJyEGcxJ4zFpSZ6y9Ko1EHA6ZJ6Q6nV1TPDvRsz7Z/op/nwRKq
	NXqpxWMbKJY4XmDlR6gubAl3bFel52M=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
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
Subject: [RFC v2 07/21] mm: thp: retry on split failure in change_pmd_range()
Date: Thu, 26 Feb 2026 03:23:36 -0800
Message-ID: <20260226113233.3987674-8-usama.arif@linux.dev>
In-Reply-To: <20260226113233.3987674-1-usama.arif@linux.dev>
References: <20260226113233.3987674-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 4005C100003
X-Stat-Signature: 35eo1baqu35eih516pbopx4fowxnper7
X-HE-Tag: 1772105621-322454
X-HE-Meta: U2FsdGVkX1/ddCQ8Jr456v9QrEZNJ2DG+vUuCD4U0dmi2iuAYRdiaMcRCe6bKMFAG/szM1I95xYkVOed9Y2sSdeH+u9n4N+/B7cqAXuftUNNq9WviTu/jZPeimnuFpzk8cqlCbgKML3Pjoelt5XvSVUnOxfIBMx0acNf3POCd48lVJYOJGGC7d91U3J39CfwRcCQZI5Bnh8OuwMtBgeiV/HoTN8m1cwOqE2wsM/1LqwbJS9YkDBnhRCKpZbSJEAyiAh6pHV0C+z46f/sjzJkei58tFwM8M54KpsNs8hUntot31qmqY7Be7C8Xs8RN1OgC+xVDpqvsLYK2dTp9Cu4+ALhf862kAOlrXtGxUGNbV0sdC2Djb1lbAuahPe1Wd4oxMsHVqJmvHFnsQWcB5NMdHm9LoxgbI1F4VltgV008M/oDJoyb0LPXM3j38/yw0rqwpVbmo2FqNsAXrSgjkd8xSUYmdy6z8ay+fpX9QLFqPKHoMRu3Pm8yIaxuskYeGrktsbZLwM1emrgkLCylrK0/3MH0NYSYBAzRP+B2p98YzY/UUkIR91WiqtlYMQbQhv50qfC+rSd6sfKeW28ZEtZtiHYZfpw+fgf7mMrdwl+yIGt4PsVvWdVJrTKLc5xGBEiChlo8pBV7m4lzjyNKANaFztosRtIpBCkR/QuRsPcncZ3K74J383tSRqBktO2XXzNXUOoCWDpZGI11bIh5sn3C31pn9SJy8V1ziJIJg3vgyGXEAc/LK8T0EFiwGalCveLsskxw2BQ2AdicQ5nL3jH0fWfmTmre7wsbbR9xCA3FRQgocVvjaWdRHmWNBq4qDz7BXy6FHdarVPzPjVUcvarxhKmW5ThT84CbspsP2KIuhw/STHwjVOL3Xc6Ymanhcliqntd5LhesesXFBJ5IXLJCyt9+R8c8+ZkrgnAk0Ls5KnIomHG9LKantVXZFSiNWVOY4ENfXh9puBE3ffgKDZ
 pFXTc08a
 1+Q3yG9VJXwxvekTvZbLqWbG+7lNe/uDRun64Jlt3DxaRrKA3MUQqWnw8OcTve6WCNmSeFIWkIR9ZuKoicjupiIMjMVnPLx6PSlu5p0DYmCzPVhFrjUkIwmZB3FflYCVmWrHmiDy7tc0ok7nndyHpWAnirD11jytbOQgBjO1/YLzCQHSwmyl4PfF/hzppvjyIRBg+vvLaFgZQrm0tzx9Z4xcxKmaHCkhxRrHOUwSp75JoD1qpgDVWVu76a9O5QlO5iPHEdAJ64aP3ji4gefWYVFJ9bA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

change_pmd_range() splits a huge PMD when mprotect() targets a sub-PMD
range or when VMA flags require per-PTE protection bits that can't be
represented at PMD granularity.

If pte_alloc_one() fails inside __split_huge_pmd(), the huge PMD remains
intact. Without this change, change_pte_range() would return -EAGAIN
because pte_offset_map_lock() returns NULL for a huge PMD, sending the
code back to the 'again' label to retry the split—without ever calling
cond_resched().

Now that __split_huge_pmd() returns an error code, handle it explicitly:
yield the CPU with cond_resched() and retry via goto again, giving other
tasks a chance to free memory.

Trying to return an error all the way to change_protection_range would
not work as it would leave a memory range with new protections, and
others unchanged, with no easy way to roll back the already modified
entries (and previous splits). __split_huge_pmd only requires an
order-0 allocation and is extremely unlikely to fail.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/mprotect.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 9681f055b9fca..599d80a7d6969 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -477,7 +477,16 @@ static inline long change_pmd_range(struct mmu_gather *tlb,
 		if (pmd_is_huge(_pmd)) {
 			if ((next - addr != HPAGE_PMD_SIZE) ||
 			    pgtable_split_needed(vma, cp_flags)) {
-				__split_huge_pmd(vma, pmd, addr, false);
+				ret = __split_huge_pmd(vma, pmd, addr, false);
+				if (ret) {
+					/*
+					 * Yield and retry. Other tasks
+					 * may free memory while we
+					 * reschedule.
+					 */
+					cond_resched();
+					goto again;
+				}
 				/*
 				 * For file-backed, the pmd could have been
 				 * cleared; make sure pmd populated if
-- 
2.47.3


