Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCEF7CD6E74
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 05:24:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E80786B0005; Fri,  5 Jun 2026 01:24:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E30AD6B008C; Fri,  5 Jun 2026 01:24:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D46406B0092; Fri,  5 Jun 2026 01:24:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BAE936B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 01:24:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4C0344048A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 05:24:18 +0000 (UTC)
X-FDA: 84844718196.17.A518443
Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	by imf06.hostedemail.com (Postfix) with ESMTP id BA24D180008
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 05:24:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.25 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780637056;
	b=8WIJpp19oXWmN1RTsMMuDlaTYasl5nEPJ94jYRlSBsbsEFs0g8McWKtoQHj/1GSeFkj2S7
	EkLX+ICMu4g4rRtA/QQgS3o8KnsyK/mvlsjXC/itT/Y9fde0cJvyz9UkIQ2yt4y04AbADz
	RLlkV0PfmRoz0XazPSiN++IzqUDu1sY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.25 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780637056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=M4sHmUT5RQKhV1PJJ0IsqTQK8t2ZkF4IfIoZMFkzEaM=;
	b=fY5CRqvgixpi5jyD7CIC0jGpxG+4L9KiN6BreADbzQOWxFdoBLW8J3DbFCIjwl+OTsNs8T
	NZ5b++qlECqVAzZ0B6667OV+nknelgNENJwiB6yVOUjc5fvKA+WeheV/U0bzMIMeugb+Ey
	xEUaMMQ0B07HMyTZuae6WswgWEcvOoQ=
Received: from [127.0.0.2] (unknown [123.118.218.239])
	by APP-05 (Coremail) with SMTP id zQCowAB3zhF1XSJqwQ1mEg--.1348S2;
	Fri, 05 Jun 2026 13:24:05 +0800 (CST)
From: Vivian Wang <wangruikang@iscas.ac.cn>
Date: Fri, 05 Jun 2026 13:23:22 +0800
Subject: [PATCH v3] riscv: mm: Avoid spurious fault after hotplugging
 vmemmap
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260605-mark-after-vmemmap-populate-v3-1-a06001ac9264@iscas.ac.cn>
X-B4-Tracking: v=1; b=H4sIAEpdImoC/42Q0U6EMBBFf4X02SGFAgvEGP/DaDK0g9tdCtiWR
 kP4dwtror4YH29yc+6ZWZkjq8mxNlmZpaCdnsYYxF3C5BnHVwKtYmY5zyte5iUYtFfA3pOFYMg
 YnGGe5mVAT1DVnTo1vBaNbFgkzJZ6/X7Qn55v2S3dhaTfkV8NS29LnPW3GuvQEcjJGO3bJJzSD
 KzMXtZtbxtyDg+lNrk/jAQXEDXVQHDtaZQEs518HAA3L1ZPi4Mel8FDyIFDX3NVi7KIkupRO4k
 uRZnK8YHtdmft/GQ/jleE7JD519UhgwyoampVl02HWfUTfZBD/k2rePE3bRfFrsKT4qIrRPGbt
 m3bJzrWIba0AQAA
X-Change-ID: 20260525-mark-after-vmemmap-populate-68bd790839c9
To: Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Alexandre Ghiti <alex@ghiti.fr>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Vivian Wang <wangruikang@iscas.ac.cn>
X-Mailer: b4 0.15.2
X-CM-TRANSID:zQCowAB3zhF1XSJqwQ1mEg--.1348S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZrWfJr1rJr1xXFy5KF1xXwb_yoWrZw4kpF
	Wj9wsxKFW5JryIgws7Cw12grW7t3ZY9a43Kw10k34rZrW3XFyUXwn5Ka1Utry3XFWrCa4v
	qan8A3yrC3WDAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9014x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
	VFxhVjvjDU0xZFpf9x0JUd-B_UUUUU=
X-Originating-IP: [123.118.218.239]
X-CM-SenderInfo: pzdqw2pxlnt03j6l2u1dvotugofq/
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BA24D180008
X-Rspam-User: 
X-Stat-Signature: z333dj1ips7p4si6k4zi8ucgfrn9zng5
X-HE-Tag: 1780637054-442705
X-HE-Meta: U2FsdGVkX19rGYmj+28yPrJ/jwGVpu1i990c3VlJqtvRPsirHgJwHagsCr13GeM7mkSwJDv83OEtqGkzcU1+b/Hpgdb/DlKWwdcDIBh2ztXXsRacpxF8NbqDe+vGpx0xtGLIiC4TR39R1Xk7Do4pXMcotZQVgzN1llVtMsRgjuoxeAG+hZHaTuGbNJx/4FDstziEUwkS2Us62UvG+HBQ/miysHxYE3aJwmXew/IbiWw6MsJr2zxMtMcWZi/vk2dTA9NWwf1/7sj9fQpiBBdNQFG9cucvjaKxuyDtzjuvC/n73ORyR2t3QcKuTy0VVqu7xDr2YGvA8uYpmdYrGEz8Qk0KUhvCv0LaFoOIdb/xbNUdKip4MIRrCDKynWSb+mNYZ4vzr0R6hpKKBZlo85JzIvxcuq/tiwJUIVyw4m5Fk4RMtB5rolkIKkn7PZjDd/icRDZv9920IpsMJHiPNbSeTmkys2r5k1ZfgG5oW9+cqaT8wu3oWmY+7tVT0Dk1w8nLoQlokr120hOIaJqwZO6KpE5WhllFFguT5WEH1begsjU6+eTDOwdYf+RkWi/tENKUZqgD+J18f4AGwO1Jat8b5pIgpys6ceO4KS0uMPAwR2g6a5oK4Jf6ExaB8zvQQqM2kbC6lEqwE48QgC9BhXTfNT5xXOEJ4NhKhYYxZ/oeWAs0uWBtOjivGcP2F23rDGcB/x9ryh68Gol359e5hDwv3YVbpCtWSUivw4yLiYX2odGO4EzK8/2uvQC9k/rIP1zm0U+CjKNQV9DYfka2fYfREC4dS7bjvbQn+vxI73p1Hh6GxpBcOsp2rRBvJCdxFJsi3BtB9HX+d2Dfeoait8t6HXvCLS9HxnGr8WJ+oRWR6KRYg3bQRyGM5t0+tWqz7cyxx8l8mIB75X4XcnFG63XcuMrING7yh7gRxs8zIR+Q7eoJcYLHbWBEu8wXvtqdH1fSRAkXQ1JXcxwntDKzeoC
 lqzy57gh
 pWRJnEV6BU1vjyibVSYwkm9NpcqaXFM6P3vCbx83oERtgw3FRsYrvdqne3U6b1et9cPmKQZ6B07Yl31lAQGEDWJxOdB0TDmAaXEq+WQ+NpRuuepoiLeOo5sRi/mwHJ0ZKQF+ll0nljBAoX23HeaDKjfzARpj+7Bsjgep0u1OJlW5k01tU34S1s9UIuSTJhDCp0qXdsQlJGlMrQIO6uJC3DPqS222nV2DXDziUrC9IawDLJ+nK3tnxfHiReifP5RQRdEEWOWwfcl36hBWdGKg38QQzMw==
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
Depends on my earlier kfence fixes for mark_new_valid_map() [1].

Found while testing AMD_HSA/ZONE_DEVICE on SpacemiT K3. Using
ZONE_DEVICE requires another fix [2].

[1]: https://lore.kernel.org/linux-riscv/20260303-handle-kfence-protect-spurious-fault-v2-0-f80d8354d79d@iscas.ac.cn
[2]: https://lore.kernel.org/linux-riscv/20260309-riscv-sparsemem-vmemmap-limits-v1-2-f40efe18e3cd@iscas.ac.cn
---
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
index a1a7c6520a09..aa0f50e3d534 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -1243,6 +1243,10 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 #define TASK_SIZE	FIXADDR_START
 #endif
 
+/* Needed on SPARSEMEM_VMEMMAP */
+#define vmemmap_populate_finalize vmemmap_populate_finalize
+void __meminit vmemmap_populate_finalize(void);
+
 #else /* CONFIG_MMU */
 
 #define PAGE_SHARED		__pgprot(0)
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 706f43523935..cf9ae4099f82 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -1360,6 +1360,12 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
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
 

---
base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
change-id: 20260525-mark-after-vmemmap-populate-68bd790839c9
prerequisite-message-id: <20260303-handle-kfence-protect-spurious-fault-v2-0-f80d8354d79d@iscas.ac.cn>
prerequisite-patch-id: fdc42f2647e21d111f44a6532887a6705cd470a9
prerequisite-patch-id: 096fa339c84c36643ae4311fd8362dc63e23d950
prerequisite-patch-id: 305c876a5f4a23a840a8142aea79b796ed297545
prerequisite-patch-id: d78cb55d6a616b1170f06a401c8fd44acd11e5d5
prerequisite-patch-id: b02b4a76e94f3e2821291d4c23b46f6e5ecf5203

Best regards,
--  
Vivian Wang <wangruikang@iscas.ac.cn>


