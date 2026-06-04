Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 540D7CD6E6B
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 11:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72F516B0005; Thu,  4 Jun 2026 07:12:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 706FE6B0088; Thu,  4 Jun 2026 07:12:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 643C66B008C; Thu,  4 Jun 2026 07:12:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 50C3B6B0088
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:12:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ECBD6120640
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 11:12:55 +0000 (UTC)
X-FDA: 84841967910.23.825DD54
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5EFE214000F
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 11:12:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	spf=pass (imf09.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780571574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ws3VRlJd/M29a5csCVSWp7qfzueoRuTqhFhMdNTF6ik=;
	b=j8bj0StdPOL6+yoEO7lux38+hP7tbOmsEYB0xhfovPgwNdUzS3fV2NZ7kiDfckPqM2Xp2u
	2PNXP+jxQZSAvTgixZqoQxbqXFwQzf4QpwLrokbmAL3zm7HWPOEfGuEhSJBrtWMCIvhO3Q
	J6ObYVPgV9KumpRPhtMgF/TzbeJmQcM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780571574;
	b=xSOuaj8Re8pcnlw6l8tfICDE6KOJKKQTW6lNM4Tr6+bZ8vF0CNuaH21S5J9q9/icefo7zH
	c6mibWteAWtFMtXvWh0KLz1Z+6SoOb096PGsjI+45FhH9FqCVgh+9Y6CrtHLK44IDoEAJ1
	GDUI6tdrjayqgf20ZsZ4MSK60cdTRPQ=
Received: from [127.0.0.2] (unknown [123.118.218.239])
	by APP-01 (Coremail) with SMTP id qwCowABX+tKpXSFqnS2YAA--.469S4;
	Thu, 04 Jun 2026 19:12:43 +0800 (CST)
From: Vivian Wang <wangruikang@iscas.ac.cn>
Date: Thu, 04 Jun 2026 19:11:55 +0800
Subject: [PATCH v2 2/2] riscv: mm: Avoid spurious fault after hotplugging
 vmemmap
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260604-mark-after-vmemmap-populate-v2-2-ab6a7d03b434@iscas.ac.cn>
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
X-CM-TRANSID:qwCowABX+tKpXSFqnS2YAA--.469S4
X-Coremail-Antispam: 1UD129KBjvJXoW7ur4rKFykAr1rtF4DWrW5GFg_yoW8Zw15pr
	Z8uwn5KrW5ur97C397Aa42gr18JanYga43Kw1UCw1kZrW5XrWUXrn5KanxJryrXFs7ua48
	CF43CryrC3WDAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmj14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AI
	xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
	vE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xv
	r2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04
	v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j
	6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7
	AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE
	2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcV
	C2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kfnx
	nUUI43ZEXa7VUbH5lUUUUUU==
X-Originating-IP: [123.118.218.239]
X-CM-SenderInfo: pzdqw2pxlnt03j6l2u1dvotugofq/
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 18rj6bpyoymzaorqnpptoxn1hwnp5y9k
X-Rspamd-Queue-Id: 5EFE214000F
X-HE-Tag: 1780571571-116597
X-HE-Meta: U2FsdGVkX1+o9utRxygVWeCoVnHoL8S2JqS7VIj2m5mjeD9r8igVShqvTVRpnfQNIA6e4eJDg9rdPrAtpF+s3x6bVZFI5pGuACmcunxhmepv8gbs5uXd+56sjXCmaU+Of2Y92TzMn/c5JgS/0JE+k0e3kYBqf24KvWERqhd0yugGin3wHbLHW9Mxbcp8BZEjN2+Qukgoz8tGSpXx7a44aGytHa9ZUxRRfpPM8p/onjqxecSMbiP7fCHoO3K5ab5jyIj/qLjbqftss1sBme1Y2RgHH95easUiuUh+depGot0Sjb6XWIDakihwXXJ+i4H55PySjj4OwvQAFhsm4HyGehdGwoBBejeQ5XjHM4yFGUS8scytf1LFVKpXrBGMQTdyg0ERPm5wTZstaoSW7br2ibrzylICue0B6PbpHhQUnUSDsP8et/5hE6svQmhR/777GK+Q/YPmToi0LDnoJfHAWbnNCNmEGpLfcPaDiBO0ntjC+G6wJormgMjGAkSUSxa+ksfPgOWapyMhRaGLgvn6U3xHTRnaqbtcgYCm+EKCrJX9toSgvP47pl06F5sJbz97M4hT44xFIz9mkgJOci45KK+PD6FASn/Rrf2GRTtab+hC28wfGRkrC32OQwyVSk18IP5w+BUYNtKJ1+4GEcExspjd1/gXMYpuhD3R+wKV8Ga4zqfmt06/8aD7HL1Gr4BrAoiqBV0bdwFo0M9kEsL74S86nk5Hbif9C9qE/T5X6xPr0/OMoDYhx3XMtl75EyCr4DxwiHcwX2u2AWvTvWZTk/R7NOqqShzgUKBP1gdzMJfW/NqH9YcbWUlhMFlcm3VCDnP4JJMur7ZAflPvp+c2cc4b22vtKDKhvqMCIJeYmywY6c8FXiF+paKMdSQjIGK+XriTK2ATAuxKfV9lfk/cOjg8P73dvM2fweUgk+szdK0KBadwPUwPgNUXSLqK0FIadOa/z9Z9cPBV6LI5H3d
 s+7th90d
 IagpIt9CV5SsbtnNJGxCCc+JG5N1DSSPcT1WCr67/q48Ej9VwlpALcCn9AZEm9kj3LUWwuNRCZS+YjkVcvmuxI2pQaclhivyu0r7ddLQNZ+mp2y4wNc5uVqbWQYsllekLEghtFcCcVpmly7BPm7tOTOtUVBffYSsXcRw2geOjTBiQbdw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

section_activate() creates new mappings in the vmemmap range without
flushing TLB, which may cause faults on some RISC-V implementations that
cache non-present PTEs and crashes.

This seems to be most easily reproduced with DEBUG_VM=y and
PAGE_POISONING=y, which causes these newly mapped struct pages to be
poisoned i.e. written to immediately after mapping.

Implement the newly added hook vmemmap_populate_finalize() on RISC-V, to
arrange for the existing exception handler code to deal with these
faults if they happen.

Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
---
I put the declaration here since it's the file where vmemmap and the
vmemmap area addresses are defined.

Depends on my kfence patches for mark_new_valid_map() (see cover).
---
 arch/riscv/include/asm/pgtable.h | 4 ++++
 arch/riscv/mm/init.c             | 6 ++++++
 2 files changed, 10 insertions(+)

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

-- 
2.54.0


