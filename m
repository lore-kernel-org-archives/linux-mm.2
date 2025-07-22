Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 393F0C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 04:09:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B39AA8E0002; Tue, 22 Jul 2025 00:09:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEA1D8E0001; Tue, 22 Jul 2025 00:09:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FFF18E0002; Tue, 22 Jul 2025 00:09:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 850C88E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 00:09:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1B7481A026E
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 04:09:05 +0000 (UTC)
X-FDA: 83690570250.02.4B5C39A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3BAB3100005
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 04:09:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of justin.he@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=justin.he@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753157343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=I9rkxPgkR9wY/NsTR+xuIpXHWRLQ67PZNdy0kPDZoNg=;
	b=DSrnqAJq5QFFbqX24KmX+1WiRwMTi/wL7t9vB8e+ZfEP0DM0GpHY8fiSJEpLiXeWW/WQz+
	3UVJ/ldbIIiBtXF0qwq2gnXvxlqVTpn53B0TKHm8dn5DyRfzUf+/H+6FySC06reZFcXNYT
	rQ439ZS2ou8caQVM/Um3I0mF6O5oQhU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753157343; a=rsa-sha256;
	cv=none;
	b=PbSkiETjzvO5rlGNiz8NPOgl42UmotbMRoWXA5Q4H3UeMJ3DWkCCav2cdnNJgj1X1kgPOK
	5Io7NHv18/TNKkUz/CY+b/iTmzjpmh4HTxXk/WTeLe3sDYt+bRrDmXY92lv+XqngcdReXG
	VTcJsGNz/QwjC1Y/3GILuzLQzawgZuM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of justin.he@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=justin.he@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5C0B3152B;
	Mon, 21 Jul 2025 21:08:56 -0700 (PDT)
Received: from entos-yitian-01.shanghai.arm.com (unknown [10.169.217.82])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CF0CD3F66E;
	Mon, 21 Jul 2025 21:08:57 -0700 (PDT)
From: Jia He <justin.he@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Peter Xu <peterx@redhat.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Jia He <justin.he@arm.com>
Subject: [PATCH] mm: vmalloc: use VMALLOC_EARLY_START boundary for early vmap area
Date: Tue, 22 Jul 2025 04:08:50 +0000
Message-Id: <20250722040850.2017769-1-justin.he@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3BAB3100005
X-Stat-Signature: gr6z9asoon9cny7y3hw94mweqdizeetr
X-Rspam-User: 
X-HE-Tag: 1753157343-615310
X-HE-Meta: U2FsdGVkX1/+2RINfaDmB85/sDNSqyt4qUbD4nkeuT+nDWcZVtaFrm/ordky61O08jHF6A0K8NIMFxvw4NAxsR0bGk/tnCF8/2kksi/YJd1Oxy5uO5TEsIeB6PMLutZuZF4RBoT/HnZgwoyzzkak5je7ARUFPk+83mOLAnbFwO+a2GKqLXvWiGW8BQo+LYfegi3dN9dPC7eAs+jWf6g3/3YKWVH3Zs9El7JtzvkMJCcIbVTthLareR0bcxvmJVzi+v5jOX64dJMHzlVfx7lpw4BDxrwB56oX+60TOjI0VIqe5OQh3ZV+ooqPiIJBTc2shg2PMZRMNK5w1A4x3pwqv98CwTBSoDf5MDNw0gNTCarkeg2chLfANoWsW0cPi1z8Cw4EyIkDAOhwiPe2uPV1I5rwxKZTHf+WaJGasNxpwHVcZhccTbV/JLfnKfIO7HD9fF+dxb1cor75sAwuQn0kB+Qw1P89vR0mkcF7qFieUSo35pHP8BXIL5LHHveKIuYRlYNfLDL1wnfCgwxuBEsYp3kyrA+QhzW54kKoEJO4CWkczil70w33S/aRl0UgaSpY/sSQ1Q+LO2cJlCSls81SK3jMlgRYPBIrbsqXBdIZKS998lxcu4rdZl2te2VHqJZGDZHuErGVs8n1/YmrRmqLbcu8+kifn1gMkLImLvSVBccZHf0S2LB/crvfTVRlNe3pc5MwRplaKg3N97VjQ/OyMYYfyTu2bJNwE3kOs/INUENCISzlluAghf+7hfmywyqxVRkN3yDogGxag7QZfWknDIioJ0aPgAYzcUORDUeHYHzUM/a3ycxEbG4GMigy8Phe4/+6RQMWtfdnnKm+8P+0s1syM9pd1P0cbcv93eKXaYhFejvoWvtiJp4FjhqY/7MqN7fuJwNotpzVqW6s9plOdrPgEqsF2cwslE7vGeCIu69o3cOLLyekovm8+DPmc8E7JeEFN2zb2LeAEpXQZ9I
 hqFkBJtI
 wa9X11svR1BnylsjN8WXqTxLmmhr6/lf2dV3AbqOOH3TCkyv0zscjqqyE77G+6u7F98aS+ZCTo/FdbOUQl9GWD5TtLAlYj7dcLTMbtGu4Qzha6Be6EvplUroycqS4r5DNTB63cJhi4NL95MqkguglW6nd4+Sj2kCc3CrxEsS4YWA0/cd0FGr7ObN/M4f3p8IPqirksyspwYlI9+M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When VMALLOC_START is redefined to a new boundary, most subsystems
continue to function correctly. However, vm_area_register_early()
assumes the use of the global _vmlist_ structure before vmalloc_init()
is invoked. This assumption can lead to issues during early boot.

See the calltrace as follows:
	start_kernel()
		setup_per_cpu_areas()
			pcpu_page_first_chunk()
				vm_area_register_early()
		mm_core_init()
			vmalloc_init()

The early vm areas will be added to vmlist at declare_kernel_vmas()
->declare_vma(): 
ffff800080010000 T _stext
ffff800080da0000 D __start_rodata
ffff800081890000 T __inittext_begin
ffff800081980000 D __initdata_begin
ffff800081ee0000 D _data
The starting address of the early areas is tied to the *old* VMALLOC_START
(i.e. 0xffff800080000000 on an arm64 N2 server).

If VMALLOC_START is redefined, it can disrupt early VM area allocation,
particularly in like pcpu_page_first_chunk()->vm_area_register_early().

To address this potential risk on arm64, introduce a new boundary,
VMALLOC_EARLY_START, to avoid boot issues when VMALLOC_START is
occasionaly redefined.

Signed-off-by: Jia He <justin.he@arm.com>
---
 arch/arm64/include/asm/pgtable.h | 2 ++
 mm/vmalloc.c                     | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 192d86e1cc76..91031912a906 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -18,9 +18,11 @@
  * VMALLOC range.
  *
  * VMALLOC_START: beginning of the kernel vmalloc space
+ * VMALLOC_EARLY_START: early vm area before vmalloc_init()
  * VMALLOC_END: extends to the available space below vmemmap
  */
 #define VMALLOC_START		(MODULES_END)
+#define VMALLOC_EARLY_START	(MODULES_END)
 #if VA_BITS == VA_BITS_MIN
 #define VMALLOC_END		(VMEMMAP_START - SZ_8M)
 #else
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 6dbcdceecae1..86ab1e99641a 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -50,6 +50,10 @@
 #include "internal.h"
 #include "pgalloc-track.h"
 
+#ifndef VMALLOC_EARLY_START
+#define VMALLOC_EARLY_START		VMALLOC_START
+#endif
+
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
 static unsigned int __ro_after_init ioremap_max_page_shift = BITS_PER_LONG - 1;
 
@@ -3126,7 +3130,7 @@ void __init vm_area_add_early(struct vm_struct *vm)
  */
 void __init vm_area_register_early(struct vm_struct *vm, size_t align)
 {
-	unsigned long addr = ALIGN(VMALLOC_START, align);
+	unsigned long addr = ALIGN(VMALLOC_EARLY_START, align);
 	struct vm_struct *cur, **p;
 
 	BUG_ON(vmap_initialized);
-- 
2.34.1


