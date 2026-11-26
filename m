Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9816D606A321
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AQ824Twb
Received: by kanga.kvack.org (Postfix)
	id C00BE6B060B; Thu, 26 Nov 2026 06:21:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB1A06B060C; Thu, 26 Nov 2026 06:21:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEEDB6B060D; Thu, 26 Nov 2026 06:21:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8AC786B060B
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:21:45 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0D2F71403FA
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:21:45 +0000 (UTC)
X-FDA: 85477030170.01.58A3132
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4D0D2180009
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:21:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AQ824Twb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795692103;
	b=BH66H9UABrmRRRzB4sq7i0vuasuhLt0Rl8VaMwxQmFh2vtgBT+2Cs8q9+UopFJ44It9/Ik
	cqXT7pNtgXJ+esbpAXBENBvSVCpt7Q7Y1ckRsGB+qYb+mMx6pV5/2ocGyYCT3kxUk4sZ0F
	zO+P3ErlzkUcLeCNHTqBkpwVGVAqMuo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795692103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AWz1FsKs9LGo5NyRovT968VOcnA5bINSvJfjoSeKHiM=;
	b=zpaRbTFD2CbkghuYh4W87LLWxwf9VGDgkdynnRuLPrVtC98PbsjodCAM1HohucZGCjPBLN
	vn8V4VwBxWi/DJvToKNDG9NcF9RzyeJSM+9N4L58d8BHVNXe2xJLmvsjfiGZPmbZH6Fsms
	PlD15LeL3GD7h5A4fssek9CxYptDe8c=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AQ824Twb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 71179465A5;
	Thu, 26 Nov 2026 11:21:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD22E1F00A01;
	Thu, 26 Nov 2026 11:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795692102;
	bh=AWz1FsKs9LGo5NyRovT968VOcnA5bINSvJfjoSeKHiM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AQ824Twb4ALIqbjov3o+wIN2U+2/6b51/CWeKM+zoQx5APB58zI/yLVE7AgN02BLY
	 90rmSuGQUtENr/nE4mNk+jvdK++v4rBBpkaAD/3lGFydSk94agQAQvnGNBIrUt7pqJ
	 qeG0tLyEXHORMngIoNNGSeIOYL0uTbbz0Wd9xJhVugOxmWuCAufAq2YqzjGtP1LCA/
	 o3L4T1istYHsA0MbvoYUVeiWmyGjXxpLn3lmCyFfZvQheV46g+ImAlMUwMcVpcOlZ6
	 dYQ8sYKoKt8MvfmQsAdZfRioSw6scLwAFDjaPy6WIhwYm+gm398pxo1SOKIvCx2SKz
	 lLqrMgtJFIy6Q==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:58 +0200
Subject: [PATCH RFC v2 45/54] s390/boot: map the identity map with 4K pages
 for debug_pagealloc
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-45-723f1e33c3d8@kernel.org>
References: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
In-Reply-To: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
To: linux-mm@kvack.org
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Borislav Petkov <bp@alien8.de>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Russell King <linux@armlinux.org.uk>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, linux-arch@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4D0D2180009
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: 9tk4om1rtwd6fbi5e9un83o4da38tm43
X-HE-Tag: 1795692103-913278
X-HE-Meta: U2FsdGVkX18l/bH2BA97rpWav/o4YO26eSy+O+GQDlw+yItturBV0wZMPoZ39EaNFvFALJBjeE6GnxvyKc5KnoG30/Y7ZTopfHWz5ixhGM084A9ES9v5Bv/u/0usK0OJozQvoEbGjMTIArMg8jPDQcP0FmV7Q3qPxo8GwOj+XzIBFS+pbI6BG4VavYFRN9HxpLYXKrXKuLNARPqSKVEBjvBOuPU0H5pq/60eBQznUEr0D4FlBgSj3alwN2bp6llLKN1zN7MWccONA6OZGvC3jmLVAE5r4EqHZqfpdq+AfjM1jYcN2JdciADxO4F7Tcm0W4+xb7QrB/ZIQ1mkx71QnA5j2URSUcIwtxE1TfLD6+hLmXPTRzqK2/cfKsfGJglDN9/YVThDo+/9v+6a9u9oCCNdmNG9jO0xSIN6pfgxDp1bIl5C7ln9fO/4NhMqPgin8AQpeXUxAktq+pgzJND/1au6poXmNGEa/gjlmCjPkmkehhuroL00LajSzC0TCYCvrV6xa3gR4PAl72ZFTElBSTfq4Z5lmE2R5lgkpsoXqMWC6SnEQUQXykDQJmTzCL+DNMkueBTKiA2+X4NCYMAbnhzm3UBrak2SC/vFjPhkQ1HC6uICESVNg+ODdsIMWtn9l18knR7Tv140iRr9QAmdFZNPUmV4XLh44yehtXs9bwnShi03sXq9hJeOZlLeefi/UYzxNpr/j73dV/U3HGBpomcKxFWYyDREpk5CWszk1HumecHpUD6TF8BRIbxNOQqIoslH9sQsxH6eegLxn/DbVz/UQZ4z4Y6sKTU18dID8Un/mLr3CgEFP2TGlHf6DmOi+iyZZDMxC5weawugrmN9PnjinIi7hq++cRF7vdfbwE2tu5p/uo9vEycMCfvkUdIVL5BM2TImHQW+MQwoQLF8S/E1GglTNWstEbIog1ss2gOqwBKOz3cIrc5yZCruQV6bg4UwHa6iR5PI0U7f8NC
 6+JiwOQ5
 SRVSUaBFQSXg2jGIJsYJzH16P9vlRkJFf4R4oh5aKASVEsKbySYBmx8Jq1n+57wGE2KG0yLGvtZk+Vq2Cy/5TSbQ15/I2B9b40n+/IgMgiNOkj8DuIurd7MxMFsQyKXp23Fa31RU7H9QTLKKFaYexpZK0+JdMXUpK1UxsA4Y33xga+9n0FHQV1FBFef2OE2XoNDSt+qfklovt27MrBc9HcAOptb17FkXqJrdiEjmRA2bDnliKOwtYaqR+iij52tDBIly9WaZuvMxPeulZytiXjVwEikN4+osrmJpJ0cXpziCcADJPDyclHd3M7V1b8CmZAHouWjmEH3TzSWUG3AWqZuDw3m22zHGYs57RYvAzOmz4E4AF0HkXa65cgDqaRJ7+TEflobAcrwpWFEDz5V+NDMgPKYMa7/Wggu5iAB/PJIcAanN6n8047wxcwWVcoOWz7K35I67QE0KUi0XDTbJllptBnFHuxWJhK3bvxjHXAmIQKTkMg2OzA3pQ0JCTPmefASo7K/xLD5yJY7UZ4lkPe2M8hVjPp4wYrKJ5+GuAdzi7nqE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

debug_pagealloc maps and unmaps single pages of the identity map, so it
needs the identity map to use 4K pages.

The decompressor maps it with large pages regardless, and vmem_map_init()
then splits it with __set_memory_4k().

The s390 implementation of change_page_attr() skips the PTE level for that
request, so the split costs little more than filling the new page tables.

The generic CPA core, which s390 is going to use, has no such shortcut:
after the split it would visit each page of the identity map, taking
cpa_lock and walking the page table for every one of them.

Parse debug_pagealloc in the decompressor and map the identity map with 4K
pages when it is enabled, like x86 and arm64 do for their direct and linear
maps. Drop the split from vmem_map_init().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/s390/boot/boot.h     | 1 +
 arch/s390/boot/ipl_parm.c | 9 +++++++++
 arch/s390/boot/vmem.c     | 3 ++-
 arch/s390/mm/vmem.c       | 2 --
 4 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/s390/boot/boot.h b/arch/s390/boot/boot.h
index 61a205b489fb..07ca806ff8ff 100644
--- a/arch/s390/boot/boot.h
+++ b/arch/s390/boot/boot.h
@@ -110,6 +110,7 @@ extern const char kernel_version[];
 extern unsigned long memory_limit;
 extern unsigned long vmalloc_size;
 extern int vmalloc_size_set;
+extern bool debug_pagealloc;
 extern char __boot_data_start[], __boot_data_end[];
 extern char __boot_data_preserved_start[], __boot_data_preserved_end[];
 extern char __vmlinux_relocs_64_start[], __vmlinux_relocs_64_end[];
diff --git a/arch/s390/boot/ipl_parm.c b/arch/s390/boot/ipl_parm.c
index ac4cf1ced71d..cf6c6679c5a5 100644
--- a/arch/s390/boot/ipl_parm.c
+++ b/arch/s390/boot/ipl_parm.c
@@ -34,6 +34,7 @@ int __bootdata_preserved(cmma_flag) = 1;
 unsigned long vmalloc_size = VMALLOC_DEFAULT_SIZE;
 unsigned long memory_limit;
 int vmalloc_size_set;
+bool debug_pagealloc = IS_ENABLED(CONFIG_DEBUG_PAGEALLOC_ENABLE_DEFAULT);
 
 static inline int __diag308(unsigned long subcode, void *addr)
 {
@@ -332,6 +333,14 @@ void parse_boot_command_line(void)
 			stack_protector_debug = 1;
 #endif
 
+#ifdef CONFIG_DEBUG_PAGEALLOC
+		if (parameq(param, "debug_pagealloc")) {
+			rc = kstrtobool(val, &enabled);
+			if (!rc)
+				debug_pagealloc = enabled;
+		}
+#endif
+
 #if IS_ENABLED(CONFIG_KVM)
 		if (parameq(param, "prot_virt")) {
 			rc = kstrtobool(val, &enabled);
diff --git a/arch/s390/boot/vmem.c b/arch/s390/boot/vmem.c
index ff6d58a476ba..3a6cd62c31ae 100644
--- a/arch/s390/boot/vmem.c
+++ b/arch/s390/boot/vmem.c
@@ -286,8 +286,9 @@ static unsigned long resolve_pa_may_alloc(unsigned long addr, unsigned long size
 static bool large_page_mapping_allowed(enum populate_mode mode)
 {
 	switch (mode) {
-	case POPULATE_DIRECT:
 	case POPULATE_IDENTITY:
+		return !debug_pagealloc;
+	case POPULATE_DIRECT:
 	case POPULATE_KERNEL:
 #ifdef CONFIG_KASAN
 	case POPULATE_KASAN_MAP_SHADOW:
diff --git a/arch/s390/mm/vmem.c b/arch/s390/mm/vmem.c
index d2879ce860a1..191326ee7ec8 100644
--- a/arch/s390/mm/vmem.c
+++ b/arch/s390/mm/vmem.c
@@ -681,8 +681,6 @@ void __init vmem_map_init(void)
 	 */
 	if (!cpu_has_bear())
 		set_memory_x(0, 1);
-	if (debug_pagealloc_enabled())
-		__set_memory_4k(__va(0), absolute_pointer(__va(0)) + ident_map_size);
 	pr_info("Write protected kernel read-only data: %luk\n",
 		(unsigned long)(__end_rodata - _stext) >> 10);
 }

-- 
2.53.0


