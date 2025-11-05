Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42783CCFA04
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 07:49:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 858F28E0006; Wed,  5 Nov 2025 02:49:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 830818E0002; Wed,  5 Nov 2025 02:49:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76D8A8E0006; Wed,  5 Nov 2025 02:49:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 64A148E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 02:49:43 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F0E72B7449
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 07:49:42 +0000 (UTC)
X-FDA: 84075779004.30.34CAEC5
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf12.hostedemail.com (Postfix) with ESMTP id 912514000B
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 07:49:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762328981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=NiGzKdKwyxHtOIvZQAR0SjqLU7BoJ+d1SSckXZDCQwo=;
	b=3t+M2lXm8k12RL1qO+66Cwmw8lsTNQeTWT//bN5Mvcw3WCKweI9Tmg1B4/dZuPEzBlQedN
	jcnukUbr+8AzMRLl8POZvvNBbWqU8oWd4kRLbl55lY1S/4d+uUsLT3fL1nHqgz1cN3dhqV
	5d29lU1A8L56vj5Mzrkihvfl0phVjX8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762328981; a=rsa-sha256;
	cv=none;
	b=MZsnT6+RqCimZiHqnQXoAbdc+hVYx04731fSrUZzuqLaASSbUexcg2o2rdekCghU6Tn10I
	0LKEkVcazBpBDU6yKqjij6MtiMxKszKYp1XetIFhClqNDnSPmAG7gEY4M/y473oUeBBnA/
	Af7mSQdpghGFhqDA91/ne80tJx0eV4I=
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4d1csR1Z54zYQvM0
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 15:49:15 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 90D071A06E0
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 15:49:31 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgAnyECIAQtpnJ8VCw--.65210S4;
	Wed, 05 Nov 2025 15:49:29 +0800 (CST)
From: libaokun@huaweicloud.com
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	willy@infradead.org,
	shakeel.butt@linux.dev,
	jack@suse.cz,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	libaokun1@huawei.com,
	libaokun@huaweicloud.com
Subject: [PATCH] mm/page_alloc: don't warn about large allocations with __GFP_NOFAIL
Date: Wed,  5 Nov 2025 15:41:06 +0800
Message-Id: <20251105074106.3508870-1-libaokun@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgAnyECIAQtpnJ8VCw--.65210S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Ary7Wry8GFWUCw18JFWkJFb_yoW8uw4xpa
	yIkrn7ZFyjqF18uanrAa12yF95Gw1rJFW7GrWIq34ruF43A3WI9rn2kr1avF18ZFZ5CFyk
	trs3ZF9Fywn8Z3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBj14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E
	8cxan2IY04v7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwI
	xGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
	Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
	IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k2
	6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdhLnUUUUU=
X-CM-SenderInfo: 5olet0hnxqqx5xdzvxpfor3voofrz/1tbiAQADBWkJ0jVblwABsN
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 912514000B
X-Stat-Signature: xkmcmpwqxrgop8eoadyqqykma4symazc
X-Rspam-User: 
X-HE-Tag: 1762328976-209869
X-HE-Meta: U2FsdGVkX18KgQmjTF1QgZMetJ5ML69b+dLrXaoLZW5ySdOwKS5T33ZPocRedXGpU03+ZcDmT2tIg6PAUQebNIBoDxiZlyWW7sxIMhyQB2OCkP8CtxZkfxCnhdL+Q4NR3yHrkmvaNypMyDlpWmL0v13Vg4+XcNBT6QAz/38OGlr4VytXWHD5WVjmtQPGFXZQUcXyyr5etFF/Y0Gs/w/nbKDlPBnnc3CRhoTD/GQA0hccYEp20w5vxNSAD5zVTMy8WMqcVMDoSxW1kzdd09yzHG2axsVfqZUEQUJj/CpvesXOkjgGxXNMkVQc0sH9yIGMm4Khv3yt/4vnTbsh2b98KwXZKUE7IkNAc6ortr5VtmGvr0eEs0HHgbNnaFnkxsGQkp/iikqWDk1JkW/xBUrB5MSO4fDo2o4/7ZbzHmzv5dphmMEyxJ14kpvhLit+sZ4MeSVPE0mH+dQ8vIw8Z8JpF1KcQDoQ3Dk5A/1pFWPHy16GvqBDPp0iT8iVguB8gHBDvV4y7avxZ0Si+d6kArLqK/VUmus2J3+COSBOhXYwbmY2dcatoPIFN4o9EfYafOUB5TKBoQ+00OM591pFICRXygee0bRNrlAFMHV2tRlM1zBiTB7lPGWcmthcPKV0858VahVXb5C8Hq/PqquldHjNqqwkaIIGvtGznT91/Cho6Zph/sznzoiVl3hwUrNTkIQm4EkMo/aqV+x0VU+KJKocxTxVIu9NUOUFj1b8C9wVbhhtctE1QdUn+uOY8BxdEFkroR3oGi842qW5HXD3gwXCFoGjItXd1213lMxwyXK+gRlvqPD8pFL2Jnq2rZC6cbXgFEu4epxreCxWXzZRMRbB9DncTMkUbkDiXAOIzrCWMnohFrxOo+0QwlYQ4dV5FkOcW4SubJew701IlvU3i7ju7IlMGNvK3GOOLp82uxyYaW572YJP5LoT4ocvK0IGZLfV9yBUYTtU9PF4RmRy11r
 rdc+GMnA
 Zw1sf2EfJ3nvtQSmQWbfcYAQAIeuyS/J1t8UUf4LnMJ8WnJcK7PomIwNMqsyJeLq/8/NQdSHu1cW1KFhuRfGtTNWrG9ODXGCqdkDcMAYpH9/hRHum7aA2XaQTejw+BNxvtvoK9fRu0huKzQ0+47jXD4NNvew9Q/YWV2xiMQVXpz4nHrpXfCRTLanQPcopHwGsvtl6bQaOtznSUXS4qKdM6kdUzMIjqtzDcWvuCLHSZi++T5w/bsiCLR2hGtubY1cnVCflntsNA1MCe1bYSnXy4/5MEBRGdDfRMW4EZiLkVVijqv8oMdtT7bfo6g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Baokun Li <libaokun1@huawei.com>

Filesystems use __GFP_NOFAIL to allocate block-sized folios for metadata
reads at critical points, since they cannot afford to go read-only,
shut down, or enter an inconsistent state due to memory pressure.

Currently, attempting to allocate page units greater than order-1 with
the __GFP_NOFAIL flag triggers a WARN_ON() in __alloc_pages_slowpath().
However, filesystems supporting large block sizes (blocksize > PAGE_SIZE)
can easily require allocations larger than order-1.

As Matthew Wilcox noted, if we have a filesystem with 64KiB sectors, there
will be many clean folios in the page cache that are 64KiB or larger.

With gfp flags and order already included in the OOM report, both
Vlastimil Babka and Michal Hocko suggested that we can take the risk of
removing this warning first and then observe whether a large number of
related OOM reports appear.

If that happens, we can consider adding special handling in other places.

Suggested-by: Matthew Wilcox <willy@infradead.org>
Link: https://lore.kernel.org/all/aQPX1-XWQjKaMTZB@casper.infradead.org
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Link: https://lore.kernel.org/all/188a95ba-6384-4319-bb74-c0d9ec6c4079@suse.cz
Suggested-by: Michal Hocko <mhocko@suse.com>
Link: https://lore.kernel.org/all/aQotQBjnDDeL_wHx@tiehlicka
Signed-off-by: Baokun Li <libaokun1@huawei.com>
---

RFC: https://lore.kernel.org/all/20251031061350.2052509-1-libaokun@huaweicloud.com

 mm/page_alloc.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index fb91c566327c..e4efda1158b2 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4683,11 +4683,6 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	int reserve_flags;
 
 	if (unlikely(nofail)) {
-		/*
-		 * We most definitely don't want callers attempting to
-		 * allocate greater than order-1 page units with __GFP_NOFAIL.
-		 */
-		WARN_ON_ONCE(order > 1);
 		/*
 		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
 		 * otherwise, we may result in lockup.
-- 
2.46.1


