Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D596BC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 07:52:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2C406B00DC; Tue, 30 Jun 2026 03:52:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C04E16B00DD; Tue, 30 Jun 2026 03:52:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1A396B00DE; Tue, 30 Jun 2026 03:52:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8CB4A6B00DC
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:52:18 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 16979A0412
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:52:18 +0000 (UTC)
X-FDA: 84935811156.24.9918A3D
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	by imf17.hostedemail.com (Postfix) with ESMTP id A45E940002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:52:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782805936;
	b=KfIFFW9uX5Mnq9D54QqxSpLZWk/YVSEy46xkWFl1Y59T1s+3R6hjoA3PzAy7ij7pyM60LT
	QNsdJhRJ9ekFHGdu8nnFY2ky6heJnoqfvSd3W0RDarezKmTPZMYj0UcARce8hM9FvRkHwz
	NVuHZIidBj0kIx6oRxFprGXP/199DVE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782805936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=Z/N/XIqRFZutF9GT+YyhD88ZaB8PHRTBk7Y1WCSCgyE=;
	b=o2KT64tYTWqeMDOlwxPYvJaMszsFuk3v2fiMjKM3zz8QXCbOu8Yc8qKlFPShFySgqFNLDm
	jZ2C5mSVR6WhagNEOwrtYuQq3DXdxJE93BVYOuGQHcxGkr87L/7xyFhx9cqJEKHKHaAlHv
	TR4N5hmvWJDgBR/a6Hrt9Vy6YnnWIM4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn;
	dmarc=none
Received: from [127.0.0.2] (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowADn+9KjdUNq_hZpFg--.48286S2;
	Tue, 30 Jun 2026 15:52:03 +0800 (CST)
From: Vivian Wang <wangruikang@iscas.ac.cn>
Date: Tue, 30 Jun 2026 15:51:59 +0800
Subject: [PATCH v4] riscv: mm: Avoid spurious fault after hotplugging
 vmemmap
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-mark-after-vmemmap-populate-v4-1-febbc15da028@iscas.ac.cn>
X-B4-Tracking: v=1; b=H4sIAJ51Q2oC/43OS47CMBAE0Ksgr6eRP4mJWXEPxKLtNGCYfGQHC
 4RydxxYzAgkYFlS6VVdWaTgKbLl7MoCJR991+ZQ/MyY22O7I/B1zkxyqXkpS2gwHAG3AwVIDTU
 N9tB3/ekXBwJd2XpheKWMMywLfaCtP9/19eaR48keyA0TOTX2Pg5duNznk5h63y0lAQJIm6quS
 mNR6JWPDuMc3dy1bNpK8k/TvHivSeCAVuOi5soWqnjV1H/twzeVv2GucYHOSP2kjeN4A/GIZwJ
 2AQAA
X-Change-ID: 20260525-mark-after-vmemmap-populate-68bd790839c9
To: Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Alexandre Ghiti <alex@ghiti.fr>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Vivian Wang <wangruikang@iscas.ac.cn>
X-Mailer: b4 0.15.2
X-CM-TRANSID:rQCowADn+9KjdUNq_hZpFg--.48286S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZrWfJr1rJr1xXr1xuw1UAwb_yoWrXF17pF
	Wj9ws3KrW5Cr97Wws7Cw17Wry7tFnYgas7K3W8Cr1rZr43JFyUXrn5ta1Utry5XFW7Za4x
	A3Z0v34rC3WDAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9F14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E
	8cxan2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFV
	Cjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWl
	x4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r
	1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_
	JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
	sGvfC2KfnxnUUI43ZEXa7VU11rW7UUUUU==
X-Originating-IP: [36.110.52.2]
X-CM-SenderInfo: pzdqw2pxlnt03j6l2u1dvotugofq/
X-Stat-Signature: k3mqf6946ywn1c139eo3ittuj3sd7bqe
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A45E940002
X-HE-Tag: 1782805934-69755
X-HE-Meta: U2FsdGVkX19JgIWizND+iec3Ffq6l7PcgGJnnBEzKb1rFyN+meEtdSLMdIhREd+Q9F3g8fPUOo6pvRBJoVyFMD/HGFQAg7AFOZ4oCHAKBHqibxFKhhD0qXIx0f7tDW5LoVSFtSauUetBPoRWfr8M9BB/UrnLhHhOxZHvcMLWPiRcxcZ/QK9q0su65s30TQvClxPmdUnsUu7u8iteziqaj2a10gDwZceZR9zIau/GIM8ROSw0fE5RMT2i7oNMY2eElONw8yb+Bg0XPTq6zCS4lwW0nHm8vjvbPWGog1IRyMiMHEdG3Gq1sgdOg/cYZQCTCZqw0nW7jRxnvzg+rv5pYVrnzYFbm5M3MfDflgZ5cccyruxxpXCMEexNgeiWJUVrv1oeXu62BnCshbB4BQd4ZYrqjLlBKs11Sd5+n+A5OyQTUdjhOCJRzI2qrnE3EQNpr4Xhcot3IE/MvQ9walmG0sUQL/oGMkxctZzHHaMCU6JryMBqA3Ok1NLP++brQaOuGIqMHyxa2gETKA4VrRjIRRgmCb8Y5tWJ88zwnmezoIdSd0VUTsNm4DLwez1R09tCSIckasrPqF7Ib9hjbo6ATbvyVhPqRI0yOnGcOQ29QmQD9cISHGmwQQdMW3AZ6FKUdLP3poJpyQkqJVMTu25zNK4O3POr2WXCqapTi9dTlcc4IJXrEXuaRGlZnbr8KREYT14aZ8YxBU7I8cj79LaXX+gzkQMSmYTsC21PclxNo7OZ56oTfgxA5oQoEYE3How3TBkP7gvxg4Vj/SLL2e7b7CEkzhRZwNmyMSZLoEt5lCU5vPh9Wbe98yJsF63bQXnRNbfBLY8e9m8Kf4x862Q4I3Au2m+Fb3CCa/FAgDSlM0uGwgkZMOGck/EeVQlrMbOkNA/0bO6UMgT35j/uTWtzUTkyAI1LhP8eRfctYqtoa2vV1FhIeS+mXhvGc7asbi2QWS0febiDypj8L/Ueu3K
 YC9TxCHx
 TUhDj1HeZyeh5Wy6OHaQaiv1SGo3t7Up+P/yHlePhVRIW7p6zMeEiKriDggMe+ziYjg2yk7uUtR/cH0MUrob8HpTmpAFs3dV5T2lVC4c6xR9inISOI+NfTlYvSJRAOx+0HjXVc+gqlTRmWpLE+aarZpbp9hiiAkKCGCDy9uoCkE9eCW1kSlnfiC/YSL7wyYexiRlT97Zwa/hv5vrHMhvBvBbIPXuMxL3sUlNqfi+BdglXMxFabbzO1PQOOdLz21/lfmj46Tr/mVwQxxmQM+tgbKMHf41ikCQ6myR3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

section_activate() does not flush TLB after populating new vmemmap
pages. On most architectures, this is okay. However it is a problem on
RISC-V since there the TLB caching non-present entries is permitted,
which causes spurious faults on some hardwares.

This seems to be most easily reproduced with DEBUG_VM=y and
PAGE_POISONING=y, which causes these newly mapped struct pages to be
poisoned i.e. written to immediately after mapping.

Add a hook vmemmap_populate_finalize() in __populate_section_memmap()
after population, to allow architectures to handle such situations as
needed. Then implement it on RISC-V to arrange for the existing
exception handler code to deal with these faults if they happen.

Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
---
Changes in v4:
- Rebase on v7.2-rc1, drop dependencies
- (No code changes otherwise)
- (A concurrency fix for mark_new_valid_map was sent independently)
  https://lore.kernel.org/linux-riscv/20260629-riscv-mm-new-valid-map-ordering-v1-1-60d8c10c6292@iscas.ac.cn/
- Link to v3: https://patch.msgid.link/20260605-mark-after-vmemmap-populate-v3-1-a06001ac9264@iscas.ac.cn

Changes in v3:
- Merged back into one patch (Mike)
- (No code changes otherwise.)
- Link to v2: https://patch.msgid.link/20260604-mark-after-vmemmap-populate-v2-0-ab6a7d03b434@iscas.ac.cn

Changes in v2:
- Split patch in two, hook point and riscv hook 
- Explain hook necessity in patch 1 message (Mike)
- Make hook #define based (Mike)
- Call finalize hook only on populate success
- Link to v1: https://patch.msgid.link/20260525-mark-after-vmemmap-populate-v1-1-e698d859ba16@iscas.ac.cn
---
 arch/riscv/include/asm/pgtable.h | 4 ++++
 arch/riscv/mm/init.c             | 6 ++++++
 mm/sparse-vmemmap.c              | 8 ++++++++
 3 files changed, 18 insertions(+)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 5d5756bda82e..6b000c990ba7 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -1253,6 +1253,10 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 #define TASK_SIZE	FIXADDR_START
 #endif
 
+/* Needed on SPARSEMEM_VMEMMAP */
+#define vmemmap_populate_finalize vmemmap_populate_finalize
+void __meminit vmemmap_populate_finalize(void);
+
 #else /* CONFIG_MMU */
 
 #define PAGE_SHARED		__pgprot(0)
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 5b1b3c88b4d1..800cb5c007d1 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -1372,6 +1372,12 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 	 */
 	return vmemmap_populate_hugepages(start, end, node, altmap);
 }
+
+void __meminit vmemmap_populate_finalize(void)
+{
+	/* Avoid faults on cached non-present TLB entries. */
+	mark_new_valid_map();
+}
 #endif
 
 #if defined(CONFIG_MMU) && defined(CONFIG_64BIT)
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 99e2be39671b..290cafcfd723 100644
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
 

---
base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
change-id: 20260525-mark-after-vmemmap-populate-68bd790839c9

Best regards,
--  
Vivian "dramforever" Wang


