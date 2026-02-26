Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77B74FC5930
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 11:34:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D96356B00A6; Thu, 26 Feb 2026 06:34:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4D976B00A8; Thu, 26 Feb 2026 06:34:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C70456B00A9; Thu, 26 Feb 2026 06:34:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF76B6B00A6
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:34:00 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 45A941CFE8
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:34:00 +0000 (UTC)
X-FDA: 84486398640.12.86FA7E4
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8E0F3C0005
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:33:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GNBY0ei9;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772105638; a=rsa-sha256;
	cv=none;
	b=xRaJCW4UrR8VzDCzVHp/n4m0Go7FB9RmG8punhGhpNnOxPyzAeBYoVV27LgW00Ni2cpCSX
	DYL/6rwX0eM4DxHrttD0x+Vx+ZpqQODYAcQ60vTZ+DJATGciTl616faCAYBJ6uAqfvsVgH
	5uBKnO/gINAUqXsTv+Ryygd+2mppu4w=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GNBY0ei9;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772105638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3aUMkxnHNH9mcF53dL6rFOoKpYMbGORopHm1QOQnqHs=;
	b=z1t6XYqLnnnq1aAUpsDlY83LsnWi69ZmOJOo/+pvnm0XPQn8wPJX4w8+xkTlFrbqqqDRTy
	CJs73BFAi0T5qK5NexWPdukgcj2WQIX5nqxilqWIs80IsYFd6HjSdKazLXe+vqZLochTor
	p8Uuq9XByZ0b9zU5rh/XtvkW2nregFQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772105636;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3aUMkxnHNH9mcF53dL6rFOoKpYMbGORopHm1QOQnqHs=;
	b=GNBY0ei9szFMPQP/mBgbMCFztPaf5KixVYVsniCIVlDSW7j+DoDleEyGyDQNRUFKeG506m
	zD1Gi7r+Zhgmqi4g2f201lHrFpqSlyBpA3zLxA945W0jK92rfYWz4T6YR0Uiy0ohgdYeQc
	JMgf7lbMY23ljMMajF764JDFPOwe/Bs=
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
Subject: [RFC v2 10/21] mm: thp: handle split failure in mremap move_page_tables()
Date: Thu, 26 Feb 2026 03:23:39 -0800
Message-ID: <20260226113233.3987674-11-usama.arif@linux.dev>
In-Reply-To: <20260226113233.3987674-1-usama.arif@linux.dev>
References: <20260226113233.3987674-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 8E0F3C0005
X-Stat-Signature: tpk3ew8q6uaz6h3znaybpurh311tjxjx
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772105638-556611
X-HE-Meta: U2FsdGVkX18j2ZwEF2bF1PuQJMrtMalI90n2ud22MoeyWioVw6tJkxGE8uepWzhAzokP44Wt3axehNBPIm66+RJpU5NsU4yCenvtzHDKJj4Wv+spsMJb4ghOBclN5bROsvFfkT70TJKp+YMWkZHlekiE7QozSfr0BIHzs8b++MgYz7IsZg4/M0PTtweXhjlULsOADFI28liomCnKujkCZzuVV7jBC5xrX/pgzlSQP8pPnv+AJ2WGNXm8mtGUWwwlwBkKVBZuIbvGa0CqTyQZlC3PCWNXwAVcIauCUO3GDCKIlJRSjZM5Hg3bVDBb9Nwvqzy4AguaAWEGYaqFZi4AuGo2mRFl+5SHSpiMOHP21DUbF01j35757OXMJ+l29LlWRvZxHRd5OardfYJS+TFSUzAW6VhNkcTL57TggUz3ZczVjVk97w0CRcZoSUVBiA4QXr1eW/MjigakZfJQ580I2Qx7rcDXXxr+N+v+cL9L0w28O8LzkIqZyziTxkX1xrcQz+Sq6MSTSDOKHWrsl/uiuKSUFwzl/jLsBjcb97TQBPkEUj22fO5ge97fLY1HnjIlmxRWBXR8JuBHJthzQZ3xiSSzfsh/+8PqU7f3Up1Fuq7G4pS3DuYeD3Lo+vPS93gMBAlPC6E3Yi+A8QxorPL6XC6GPUTyloPVa4d6tIZk3oX364J500GFbESnQpHglQai6U7/XWOs4P4j1e6gvwSh6XVOXa35XDREAibTAA3b4J0SBUvQhB6b7FsQPPUprrxMUwrA1oJyHqADHNupvNgUdUxeNlwCXu7tZWNrBEG3SFann6w1qvWZ62vrt8wVbROslqF806lfkhCP4rCkG311tW399mzRqRBQTAbEtFhgn0USzoFRR3iHAB9RvuOluYR6RiX2A0d6ht5/7WQ31S40MzNVZnyiGc7gGbJddiknlsBkw07v8n/KVWzxzbaUuWVQUFsAcOOM7x31k/rr+Y6
 c2BthQQ5
 U+5AzGBMMG5aNyoS/nmxuYFht5dqLmrbND1UtaPGVSEuYFCZ3bfWZpUvHqu8qY2X4s3AxFj6tnHVjOQnYmTodoUz8Ic6w97OY9kfUengQm6YNOnQo8iKNGntGaMpj5jfEPFBR6oWAgOZUKCiPQLEGTqYTDgD2ohbgy0mdDvvzjlYzxDOV2k4TAu9yNdtNr1lTYkkuasyvZvyu5IsMeNqvii49BvJolqHsBZxMsP16WKrx8NUFQZlsLvBO1sUkpe9p2wSo++Z53dS/O9Tjzqa7fjR5AA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

move_page_tables() splits a huge PMD when the extent is smaller than
HPAGE_PMD_SIZE and the PMD can't be moved at PMD granularity.

If the split fails, the PMD stays huge and move_ptes() can't operate on
individual PTEs.

Break out of the loop on split failure, which causes mremap() to return
however much was moved so far (partial move).  This is consistent with
other allocation failures in the same loop (e.g., alloc_new_pmd(),
pte_alloc()).

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/mremap.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 2be876a70cc0d..d067c9fbf140b 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -855,7 +855,13 @@ unsigned long move_page_tables(struct pagetable_move_control *pmc)
 			if (extent == HPAGE_PMD_SIZE &&
 			    move_pgt_entry(pmc, HPAGE_PMD, old_pmd, new_pmd))
 				continue;
-			split_huge_pmd(pmc->old, old_pmd, pmc->old_addr);
+			/*
+			 * If split fails, the PMD stays huge and move_ptes
+			 * can't operate on it.  Break out so the caller
+			 * can handle the partial move.
+			 */
+			if (split_huge_pmd(pmc->old, old_pmd, pmc->old_addr))
+				break;
 		} else if (IS_ENABLED(CONFIG_HAVE_MOVE_PMD) &&
 			   extent == PMD_SIZE) {
 			/*
-- 
2.47.3


