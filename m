Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED022D65529
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 09:47:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E8276B0089; Wed, 17 Dec 2025 04:47:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AEBE6B008A; Wed, 17 Dec 2025 04:47:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B19B6B008C; Wed, 17 Dec 2025 04:47:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3AF7E6B0089
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 04:47:01 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 075C1601BB
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 09:47:01 +0000 (UTC)
X-FDA: 84228484242.07.EFDD852
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id 563901A0003
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 09:46:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ly15AwCg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765964819; a=rsa-sha256;
	cv=none;
	b=C3MLO2w+zgRBBd3XgMbGhif7M5HhIhsSnuV54Wu+L3tPKscyIQhKZXsFrH8TNGJdg0H9kM
	5kdU6s0HYzxqLBjDvStt59EATAM+v55QwhAJITQOuLdBpXXAyAa+k2oM8m/Qh0q7dnQLpi
	pdu6EriRgEKuMbYI5Uyr9XZyD7SfXWc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ly15AwCg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765964819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bw+1Lau4jkXgNGH1w/oSy1pnIcM7wv7myPLVDHR+sFs=;
	b=r1sS8cEF6TTuJ4Z0V4bGx9Ca4mVkaz+E7cgcX6rqIyuVq7HUm8NXD40/m8EZERcMs2tHlK
	rFotP2fhAm6Cny31jrhtc8+tCZbJQ2CfUvFygK3ruzw4DNnmpGiZsqTcowdy4eCxHGJ9xK
	RTHlW7ePfV2EdBWiyg6uuAxT1Kn6xuM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765964817;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bw+1Lau4jkXgNGH1w/oSy1pnIcM7wv7myPLVDHR+sFs=;
	b=ly15AwCgeTCvVgfKEAGM4N6+Qr/3bm4QCI+29u9WGu6pcYXwgBs1OKy52f7HilHkjkHMPR
	sHiouE4YFfRjE5AAkAK/J8ELyx11QzPsbKV6xCapoiF96UFCkEGY/h6yJrWtaXJGp1y3sT
	pxSpzXa0XWo0t7W7DaurMYa8P4nGSAc=
From: Qi Zheng <qi.zheng@linux.dev>
To: will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	dev.jain@arm.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ioworker0@gmail.com,
	linmag7@gmail.com
Cc: linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-alpha@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-um@lists.infradead.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 1/7] mm: change mm/pt_reclaim.c to use asm/tlb.h instead of asm-generic/tlb.h
Date: Wed, 17 Dec 2025 17:45:42 +0800
Message-ID: <67a0725081c82cdc2debce6cbdb9273412039553.1765963770.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1765963770.git.zhengqi.arch@bytedance.com>
References: <cover.1765963770.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 563901A0003
X-Stat-Signature: z8gjrdc56tzf5kmm3zmqcish3titnuxo
X-Rspam-User: 
X-HE-Tag: 1765964818-413594
X-HE-Meta: U2FsdGVkX18zos7sgUMt7jU8KpKaNL+XCgtNp4/AC+zC2MiRcgrdZkoe+Hj8n9FyvdabS1sJVqPHUo8pUwaQzSdOCsmL81GipgbkZxQSC/iJAT7PBoC0Ty8bHNnVsRx4ByJnMAYOl7xOr3It5pQrKAUBN+8TTjTrpMu9uOPP+w7jS7lZtaotPcFXongRXF8rFKZxwxuyAPp++IORhiii4BATq2S4UsUDLZOD8kdBiCApTwSsAnKFG+B81O11J9PdcJ52y7VciHMAPLZh1+s6E8WvM8u6iG/mtbIGYdESQbGiNCONNeuMTPbCJwzKYsaFCX5xqlQnJ91mvpVbI6u924XQ19e7pV7AQKGGZcDds5TPytzOci0lIaR/hCaLhwSkYuj4in4Y7FObXkKJFuOhAQGpsr205sAN7JFKl7P3dpCRd4cVpMJz7yfHtgH5DwToSJYAHxXVzp0jwvsN0YTUcWcpMO9fYmPpj7DGXyNNroqOpptKhsPFySw2vnYSO+tvuJNGmP79QcCNXCqFRq5yK6/pn5ATEWJQ4TXdhGLm94XoYC5eSaIZvLaZd77IF/YDY04XeotEEtDzIPbZY/ybLE8fowCN0TNvbVffxGOXDd9k6XJk9Ntf0Vc5LmG59wMoaQWJ/6lW8KqzvdgQmNdie7YVB7JuA/O47uDO4J8LYseOwH74Xs6nCav0LxG++uNnoY5BlAbwOYlPaZ2IJmLptj/3Qb3yndPE5DS4OvQJhT8ZYpHIedSPTZEW32N8e1HJwPnzV/ZVlylPcZFe0a6yVLlTW5AVbHf4XzLtp992xp0hLInnTlCBWjedrs57mfW1i9K24TTSwyIkIxhSXAGn8vHy/J9N3cQpCL59j1FrbV0ntp3t7APy7hL+0wjUxxfrskcEG805/HrPLlZ3Z7wJn4K2ZftZhHbyoT8BpQAvTnmrT9NbDqBEEqTXROvxE9r7JnF8kj2wP5IdakIswRp
 B0hCZd3R
 sglOwwnBk5n/LzwYTtN5yqgEHxEJxQ5R1InA0Yk6cjGhQkHTdwK/3pqlVI3ryChakYH3KwBV7Db9BN9hIoqdFmatgaYNBU4UjsIL8l/coSUFStFPurT9PhMwYpcZoVfq+pxSe9G2m+Ptx/6FzpgWQz6dc9L4IUqVc5FKBmyN66qCpvcrFUzXqKnIeimB4q08bzKMSqG5ZaKN638g3pIrqnOsJ+KTNHAK8bFRhfLYe9DsCjUIBSaLdCCSs6YdRlmW18ertmLFwrRpWlwXYbI4+upthsZND3SxYON2p
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Generally, the asm/tlb.h will include asm-generic/tlb.h, so change
mm/pt_reclaim.c to use asm/tlb.h instead of asm-generic/tlb.h. This is a
preparation for enabling CONFIG_PT_RECLAIM on other architectures, such as
alpha.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 mm/pt_reclaim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/pt_reclaim.c b/mm/pt_reclaim.c
index 0d9cfbf4fe5d8..46771cfff8239 100644
--- a/mm/pt_reclaim.c
+++ b/mm/pt_reclaim.c
@@ -2,7 +2,7 @@
 #include <linux/hugetlb.h>
 #include <linux/pgalloc.h>
 
-#include <asm-generic/tlb.h>
+#include <asm/tlb.h>
 
 #include "internal.h"
 
-- 
2.20.1


