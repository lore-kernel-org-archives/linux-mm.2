Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CFBDD7234A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:23:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95CB66B0440; Fri, 23 Jan 2026 03:23:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BF4B6B0442; Fri, 23 Jan 2026 03:23:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D9806B0443; Fri, 23 Jan 2026 03:23:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6DF956B0440
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:23:14 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BC55EB717B
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:23:13 +0000 (UTC)
X-FDA: 84362538666.22.1361EBB
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf13.hostedemail.com (Postfix) with ESMTP id ABB4320018
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:23:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gpCvamvT;
	spf=pass (imf13.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769156591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0NYRDoQ/3A47f1BvErhk2cyyDCVpwgJBfQUk6OyEvgE=;
	b=Kzi34LwlAYhg4G6xqIJwSkuiroWS2USHpJbMvmZhoUrT+o0War5qoZMW0N55ItO4f/vw+u
	P5B4oh9qmJtzPU4t5eD9f70MqbARVkWcJNb0ls0acE4NzeIE/dAQ88+DMIxsjYaUQpmiCs
	kKM4xHwgpAkdZz6skRCuQ03U4NLF698=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gpCvamvT;
	spf=pass (imf13.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769156591; a=rsa-sha256;
	cv=none;
	b=PKM353Mipazn6WX6vkmjXlTLLFe4o6pnBIT5CXIz7xkW5DOeDEIRV3RCVrtYJouBT9DOJK
	OlWS3c/s1EjkAn6AjxK9pCkSNSB2Cb9uD+sfnv0ya1ChLI9gNZOw917wcnoCyX9b1V9g5f
	F3x9N6s30ieYDI6cNVmGQTPidjP179k=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c05d66dbab2so1442741a12.0
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 00:23:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769156590; x=1769761390; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0NYRDoQ/3A47f1BvErhk2cyyDCVpwgJBfQUk6OyEvgE=;
        b=gpCvamvTDTQW6KJR9dsprxj28I9tE2Rn4kT4tbYUYmOd2yYzcZUTSNLDEWy6P+W9Dh
         Je0Xa3fx4yTcyMVE6J7b7IqlEilhF/FnpiCWPXFYBHia7WfdkYQ/o2WttNOXb6nGk4bl
         jJT9Dmex3TApEqGUZJpBBWtGy3dACZqMfebyRsq36IMzGAbIkenRjJDyoj87s+RomEo/
         HQ+/YzgF9/0qpMR1P+79EphXMgQMkejkQSd116afPhI1PKBFofyaEA6LQBPmQCY29ea0
         cqUTP/y6W1LB2OtrJnUdmvBOCaLrzH/K9fcUtjg8Ltib5l6ttij8+TpoQGUTqzaZalLM
         HsRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769156590; x=1769761390;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0NYRDoQ/3A47f1BvErhk2cyyDCVpwgJBfQUk6OyEvgE=;
        b=wOYEDYZ/kY6f6jZlOOLCB/DmFOmN7TzCGb7mRn7caCYXagzNokPp/vSpwrw3M6W4/n
         yEd0i3J1P7jDk0Ga1mTJhJ8H3tUGxE6Zadxl2FE4RnoVX+YnD1C6Pj4CzXQMRKRcYAwm
         yknZiwIq6bODKVMkFLcR/sCGfy8J/6aSMJoL7+KmJGCMHh2LpEZu/+ks8Rkbrp4hs1Bf
         OO0qbt/lbO1KS4eUPwUpoHmbvhHNBAh8jZcyWHI011bb6VtcnM2gsEZhKqFqKrP/w+T6
         iZhZXk3Y1g/F6nTe6JH4keNG5jbzCG8+sERgieNqnBZP6MCEzSKNpF3VyajFZFWi8Z/e
         530w==
X-Forwarded-Encrypted: i=1; AJvYcCW38zdLMrurtIodVjwtBz+X9j9n+Ah1qtkbpC+pujRLXlal9zsUnjDqaW/30TnRxTZ1tjNaT23TYg==@kvack.org
X-Gm-Message-State: AOJu0YzUnLJcKWw4VjqUsCwcbQY6gxB6Pz4x0fuJEQldipw710cjF4oo
	cE66vnmj6Ne4l/21eH0Bne0vhWDZAOHElva3R892wwZ1fJoa4nHmFQJ1
X-Gm-Gg: AZuq6aLPivLVJBlUWFMMlqCVORBdUG2bkHVT0pzDxCdXTCkwfmIEjqR3lR+4cAYtJX1
	moI1w/spU/Cucv05r1k7iu9k3cNbpma/9McCHUJE6Ez4NYEZ5dKRoJrbZrxvi4YKxqBeHq3vSe9
	2tKsIvqryLN4Kxa7trhIX08R3pL7AiTxz+hQPWr67sHyoO8RKemcMnc8FbI2+MEvhc+rQ1EDKm1
	vEcOYFl+jymy9aZouXtBlLoGcjXRmqPE6hmovL69w82ivVN0muO5i8k1Kqth1m6gbQ3LYFivzaa
	qYzC4hXNHpci0UU5wGpBUsU5LoSrHPmlHddVMtjDxuK7E0IYtrBjjYkdd4GmKn9bKIphBm5WseE
	LHRUPbaKJYZ37YEKzbQnPxjOa2tpJc+xoiwEsuQXu6rjMqt7X4jrhuj9EPiOW3y3CPoqtuBoc9F
	GC+3OLNU/rn8VwgKErVdB516sNv9Uz1sKgN04=
X-Received: by 2002:a05:6a21:33aa:b0:38b:eb25:7741 with SMTP id adf61e73a8af0-38e6f6a6badmr2287356637.1.1769156590493;
        Fri, 23 Jan 2026 00:23:10 -0800 (PST)
Received: from localhost.localdomain ([221.227.246.159])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c635a43f11csm1348363a12.35.2026.01.23.00.23.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jan 2026 00:23:10 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH mm-new v5 4/5] mm: khugepaged: skip lazy-free folios
Date: Fri, 23 Jan 2026 16:22:31 +0800
Message-ID: <20260123082232.16413-5-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260123082232.16413-1-vernon2gm@gmail.com>
References: <20260123082232.16413-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: c6aonthw57c348j1u36hbmogu8yz73f3
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ABB4320018
X-HE-Tag: 1769156591-254319
X-HE-Meta: U2FsdGVkX1+pklof2JQkenYqwi+FbQfaViOi4SRt1xysrqJzOcFxu4SOALyGCggxQo9e0phQ849QURHvy7PSH0PhGXFXju52zKB3PJfcgTBT8StsALTtUgJ+fBaPa0VupIeRtymsBUduZ+SrSQuZ9dO+M1xYTnDD0qlVmIZN1fQJkgD1haZSCN3l81uZuI+e3R2sy1GuDK/ZziGqZyN6Wme2rwdoFgSGWiDm62lDXez1iC1eAXtTOysFv6ZEAD5FmZqAqZkgTzBDtoI79OK6GVLGPMamu9Tl9bHAiaRGvbXJs3wCZGiJBHirLM6YjWOaqqyVQ4h+TfyyYCRuWPRnm7pEyCZEsPzH2mH7WR+obRw524s0kwolkH6KMvjQZIkM/tmCiPOiASXzYe5sxWnzKtk952v9kK8+8+0o0G/LeYQtr3Vx4d8xP9IYoDTgyy9XdvwN2Jm1mvoACw1eYUooXvZUrGxILdCU1ijPWPExoP3vOlSEjK70jrSve79U/AJT/Ke6xojxSCxtVAbKdCdG1qKXH5NUi+1L91ERn77wSLPo8DMaQiiR9gux4zrcv9SdrK8PV3fMmB0WVp/pCN7w0BgPliAmD4pGdfs2uq2a3B9X8KGlDT2rlyTJL1MLAl8aFh2h1k4GMKBlczL29CQjEeekBq4+0jrvOTpGYgaclf2V/nqfquX6bjEU6aDcEPduAtzsuiMBEwoHPEpl9UeSYGKNJST/BADezFix2FfA7hhmltpQiFDS6B8n1Zh4EWkekEqpGQNWpKML0nPgBwi1Ilv6tIsiym/IIXNyOASajNenAGu3VGopNSqD1SDZdjPf8Lh5Ko7dDH36lMrUIZe5rLLOlQpPG5IqC4hIx0VYDkPnzAK3E47tac+CDciHzxuZZkqQ67gvf1iQlPMK2dwUd4D3zJYhbdnLwJLfj0qzYPPXDfvRE9QowowtJ0zYfrUTbTkNbc3X9UYBsVa6T9q
 PM1ItCK4
 dLrdeXVNrNEFPL/2w+E+5iPoXuSLRdOP3jO8d5zHaZPA327u0kIE8I2XKXWsynXy42QkJPk2qzDCfGPllNK1B76p1kNXnqFEAlKMLfRnPyUAyshlvPfRrzR+0g2uNp8cuBL1vng/sTKijmYqQwTaJco/3aJFJ0RoGNDp8UzmwYhKkVx2veqnP4m+oK3PI4HR0RVhmtXopfgtq8+Uu6T+XEEnbME88WVE4RS38OL4KfhZmXunaaRBdt8V23GRjggki+HQbQF3NaWLIKh2bkzodLi5xtMT8Q59EBIhOH5DnATQiEuPGQLH6+Jy1VivRCgBIOTlA9ger+xJlcXwcFAgnsp5Q9Aom7rBbMWhD1VQT1PvrQMuRWnJ1rTDbvqcu7tmFOXlYtnSoUS5dAEM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

For example, create three task: hot1 -> cold -> hot2. After all three
task are created, each allocate memory 128MB. the hot1/hot2 task
continuously access 128 MB memory, while the cold task only accesses
its memory briefly andthen call madvise(MADV_FREE). However, khugepaged
still prioritizes scanning the cold task and only scans the hot2 task
after completing the scan of the cold task.

And if we collapse with a lazyfree page, that content will never be none
and the deferred shrinker cannot reclaim them.

So if the user has explicitly informed us via MADV_FREE that this memory
will be freed, it is appropriate for khugepaged to skip it only, thereby
avoiding unnecessary scan and collapse operations to reducing CPU
wastage.

Here are the performance test results:
(Throughput bigger is better, other smaller is better)

Testing on x86_64 machine:

| task hot2           | without patch | with patch    |  delta  |
|---------------------|---------------|---------------|---------|
| total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
| cycles per access   |  4.96         |  2.21         | -55.44% |
| Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
| dTLB-load-misses    |  284814532    |  69597236     | -75.56% |

Testing on qemu-system-x86_64 -enable-kvm:

| task hot2           | without patch | with patch    |  delta  |
|---------------------|---------------|---------------|---------|
| total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
| cycles per access   |  7.29         |  2.07         | -71.60% |
| Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
| dTLB-load-misses    |  241600871    |  3216108      | -98.67% |

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 include/trace/events/huge_memory.h |  1 +
 mm/khugepaged.c                    | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 384e29f6bef0..bcdc57eea270 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -25,6 +25,7 @@
 	EM( SCAN_PAGE_LRU,		"page_not_in_lru")		\
 	EM( SCAN_PAGE_LOCK,		"page_locked")			\
 	EM( SCAN_PAGE_ANON,		"page_not_anon")		\
+	EM( SCAN_PAGE_LAZYFREE,		"page_lazyfree")		\
 	EM( SCAN_PAGE_COMPOUND,		"page_compound")		\
 	EM( SCAN_ANY_PROCESS,		"no_process_for_page")		\
 	EM( SCAN_VMA_NULL,		"vma_null")			\
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index de95029e3763..be1c09842ea2 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -46,6 +46,7 @@ enum scan_result {
 	SCAN_PAGE_LRU,
 	SCAN_PAGE_LOCK,
 	SCAN_PAGE_ANON,
+	SCAN_PAGE_LAZYFREE,
 	SCAN_PAGE_COMPOUND,
 	SCAN_ANY_PROCESS,
 	SCAN_VMA_NULL,
@@ -583,6 +584,11 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		folio = page_folio(page);
 		VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
 
+		if (!pte_dirty(pteval) && folio_test_lazyfree(folio)) {
+			result = SCAN_PAGE_LAZYFREE;
+			goto out;
+		}
+
 		/* See hpage_collapse_scan_pmd(). */
 		if (folio_maybe_mapped_shared(folio)) {
 			++shared;
@@ -1330,6 +1336,11 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
 		}
 		folio = page_folio(page);
 
+		if (!pte_dirty(pteval) && folio_test_lazyfree(folio)) {
+			result = SCAN_PAGE_LAZYFREE;
+			goto out_unmap;
+		}
+
 		if (!folio_test_anon(folio)) {
 			result = SCAN_PAGE_ANON;
 			goto out_unmap;
-- 
2.51.0


