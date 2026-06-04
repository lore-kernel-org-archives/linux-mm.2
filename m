Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BDA1CD6E6E
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 11:13:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB1F16B008A; Thu,  4 Jun 2026 07:12:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A89EB6B0095; Thu,  4 Jun 2026 07:12:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A3F96B008C; Thu,  4 Jun 2026 07:12:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A1806B0095
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:12:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 08BFE1C1452
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 11:12:56 +0000 (UTC)
X-FDA: 84841967952.29.C8997D6
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	by imf12.hostedemail.com (Postfix) with ESMTP id 54CF140011
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 11:12:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780571574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hVze3XLbxqBZdz5tJfrO/8X1qxS6iQ8DlHLO2nhAGL0=;
	b=Q4hZVyux06KUH1M6tIwxelJfVMsenOAAOoH68AknZp0F3n1foGF8o+0s7PmEJc0mT6BXz6
	RhpfrjfK8iaEX0vMK8e60bP4TVqh6BRr80Mal6x1UPh6NUiB7xLQGn1EY691wBLsrt0MSh
	vP2fiy1IxDeyRCpVu2Cr/zLtPVfiuUU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780571574;
	b=IE9dT6DTwLLusNfwK31tVLgeKVgmPMMnKQRCAuMCKvWcs1FTxI0rqCCMIvfl1YH3ivWEXq
	UCCf+UIAxQSns5qdYj7NjE+A4QP/1ZO0l+xKVr9+KyPExXjyfZ/WIoLG7SY6n2qAwOt+Yg
	lN5MgoQyJjRuSwrG4fH7bFD4y0SWm/M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn;
	dmarc=none
Received: from [127.0.0.2] (unknown [123.118.218.239])
	by APP-01 (Coremail) with SMTP id qwCowABX+tKpXSFqnS2YAA--.469S3;
	Thu, 04 Jun 2026 19:12:43 +0800 (CST)
From: Vivian Wang <wangruikang@iscas.ac.cn>
Date: Thu, 04 Jun 2026 19:11:54 +0800
Subject: [PATCH v2 1/2] mm/vmemmap: Add a post-population hook for
 architectures
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260604-mark-after-vmemmap-populate-v2-1-ab6a7d03b434@iscas.ac.cn>
References: <20260604-mark-after-vmemmap-populate-v2-0-ab6a7d03b434@iscas.ac.cn>
In-Reply-To: <20260604-mark-after-vmemmap-populate-v2-0-ab6a7d03b434@iscas.ac.cn>
To: Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Alexandre Ghiti <alex@ghiti.fr>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Vivian Wang <wangruikang@iscas.ac.cn>
X-Mailer: b4 0.15.2
X-CM-TRANSID:qwCowABX+tKpXSFqnS2YAA--.469S3
X-Coremail-Antispam: 1UD129KBjvJXoW7WFW5XFy3CF18Zr1kGw4xCrg_yoW8GFyxpF
	yj9w43KF4UXFy7uw4xC3Wrury3tF1vgayxG3WfK34fXw13JFyjgryrt3WUKrW5JrWfAa4x
	X3Z0y34jk3WDAw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPE14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1l84
	ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I2
	62IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcV
	AFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG
	0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI
	1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_
	Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17
	CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0
	I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I
	8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73
	UjIFyTuYvjfU8XdbUUUUU
X-Originating-IP: [123.118.218.239]
X-CM-SenderInfo: pzdqw2pxlnt03j6l2u1dvotugofq/
X-Rspamd-Queue-Id: 54CF140011
X-Rspam-User: 
X-Stat-Signature: yasyus5tnxi3yk7o73f98bhafgehwk65
X-Rspamd-Server: rspam08
X-HE-Tag: 1780571571-348724
X-HE-Meta: U2FsdGVkX1+irJIr0ePjNS/tsf+qwnXqsJ0YmD/xs83oNB0GAzC7jvoU36VXrajhaZSTddbexIdIlkM/jlkK0boFOjGaIweBcLqPiHxxCOGUzFXq8m/cjRfN8KRj6omcnOyVVkMY4uNhuVnswAhZdtiouKjyu1A6fLY35lB94rNqkW+geX1zd+9MFmiZIUoJhCBlC+7LFbIwzXhmd5JrZyoEjBhBguIqd6GFY8D3CLazWpJSRq1ANEHcVpNhY3EB5QFNqt98Kv3zXU4m62FN3F+JTSlM9ER/rD3L/MWDgtp0btPuZ1zlGhvjIJyOyhTsfVU1V+itmbI1euqZsOEs9G/Zq53OMfNaZmqZlUnFISo+rRO4KJRz/q/G6+RbkUVpL9vHvLRDDfIjEfRpXfmIugeFwrQR4+nQEBn8Py6ZNlSw8HozDHGA0KUtvjbSypW9nUwipwcaA7yquVSSQDBgLYCswtfSscCAkZnj8x/ysGjsh9eJY2ixPeNc5NSIaAi4EJli9rhi2Z407zyoEDNiyjE6fRJ9Hw2qhe1/BQ7Z4MtkueZ9lomVMo30SM4UUaowdPS5HzN4U/gzHBH387wDjc30NNZWYBbSuWmUOlvFg0osbVLZaZdVniN0tmMo23+AYV0s26jfIzCE5cd+FrHHJ8fvWJKz6OQWARpHT2wznh0v4N6BvbVOHzQjjpzR4vFGzYeADAKpjHUfA/NQT4Yf6fvNmVZQoEQbNoUQfqfVahOtTUU8zJLs1sMIABPpBL1Q79SiSLdYBo35zXtJGfazVYCgaYWMubFSg0md80GpF/oMpO3C4W4bJgls8cFueCpiyXw+LuDKOLmy3jlnV2h2GWeji2VSgQepeGgaYXUgxO2Qnv7PQPUPmgiNV4EVsUV/OIjHk9VwFGsV2l5RN9NFEqxq3EXl6IrZINFmYlGO2rJCstw+H9VGMcQNpcH5Rx5ymOYJy7/khH/8guk5rNc
 URWEPor5
 ZlId2KXqpfYE+HYhCCbmuUETgb4mbzkBHV/rm4eo+BTb3A3Dk4w//ROGeZY1gfMPXuGRScifXnTUrpOJ97/blpdZkhOQTGrxz1nP6KjqAcwhIwxSmOqWiaxXt9TZnvv4eXsaFZQKvlo2DNSipwZ6WfdHth96RHd7OcBNtm0TsuG6ONWE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

section_activate() does not flush TLB after populating new vmemmap
pages. On most architectures, this is okay, however it is a problem on
RISC-V since there TLB caching non-present entries is permitted, which
causes spurious faults on some hardwares.

Add a hook vmemmap_populate_finalize() in __populate_section_memmap()
after population, to allow architectures to handle such situations as
needed.

No functional change intended for now, but a hook implementation for
RISC-V will be added in a later patch.

Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
---
 mm/sparse-vmemmap.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 6eadb9d116e4..2a8b923fabe8 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -544,6 +544,12 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 
 #endif
 
+#ifndef vmemmap_populate_finalize
+static void __meminit vmemmap_populate_finalize(void)
+{
+}
+#endif
+
 struct page * __meminit __populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
@@ -564,6 +570,8 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
 	if (r < 0)
 		return NULL;
 
+	vmemmap_populate_finalize();
+
 	return pfn_to_page(pfn);
 }
 

-- 
2.54.0


