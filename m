Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2A77606EE82
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 16:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ldaoIdlx
Received: by kanga.kvack.org (Postfix)
	id EA7156B05BA; Mon,  9 Nov 2026 11:01:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E56596B05BB; Mon,  9 Nov 2026 11:01:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF7766B05BC; Mon,  9 Nov 2026 11:01:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9517C6B05BA
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:01:04 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 14AC78034C
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:01:04 +0000 (UTC)
X-FDA: 85416044448.15.C4F24B3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id F0D528001F
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:01:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ldaoIdlx;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794240062;
	b=QYHh4kS5JMMH3EufW5Swk2S1Lbo0Q3PHAKjbzT0h2cF1RkWgF9J10GINaa7IS7UcL1mU9U
	Rclgv7HJyVBsofj1Au5R4knl1wgOJUSZstKrMeyDHgpfTEJQd326i6lYUVrdc//mfoFmKN
	lt/NH7wcN/0vNXfy37Qpuy5VV4LnjHQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794240062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w/xadSNxlF1dcE7NrliZqcaX647rTwn6tKWJSB5uaPw=;
	b=Pt4gnHDQVnrybDTraiAdRZ6tLq8ufucclNUNYMNSgJQcknmNwNq8VVkYo7PeUv7KTAYi/Q
	cOXeObJR1Gpx1KjYMnxsjf40j2w8RS8hzCj4PQDZA2odT5zrKbxvYaCDvvPFRIVF67Qy9Q
	0LoKI6JWakT1RJqLJEVPYh+lpK00chg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ldaoIdlx;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ED4381758;
	Mon,  9 Nov 2026 08:00:57 -0800 (PST)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1C7CE3F632;
	Mon,  9 Nov 2026 08:00:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794240061; bh=VFlm1dBZL32mMpdbEZlu0B521tRtjxv6y79g4lyfR7M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ldaoIdlxnbqof2ygpu7uoIS36TRPBb0a7KqSQG47lJO/WyvgR3DFvILsv50YAk0y9
	 YPbtFv4E19oYZr9mArtAtTya0NZev3zEDxoQQ+SFGyaoI9nR7OVEAfsZj+yDBnj9r7
	 azx2Nrk5IQtYdL2p6rRsHUcMe572fiAZENG3IiO8=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Mon, 09 Nov 2026 15:58:30 +0000
Subject: [PATCH RFC v10 05/22] arm64: set_memory: Implement
 set_direct_map_pkey()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-kpkeys-v10-5-aa6c4d9603bc@arm.com>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
In-Reply-To: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Ard Biesheuvel <ardb+git@google.com>, Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 =?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org, 
 Ira Weiny <iweiny@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794240029; l=2186;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=VFlm1dBZL32mMpdbEZlu0B521tRtjxv6y79g4lyfR7M=;
 b=VcY+DXHdsUztqYXuF9Z+OxZq5jyyzLtxxEifnN6W5UAiKiDqSWPeuNeQjq7koKky74S76Ikfc
 0B9SJZKJAOlBze/gVmLterM9t1uoECjb0BHcViK70dZmXCfp5Ka6tQ/
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Queue-Id: F0D528001F
X-Rspamd-Server: rspam12
X-Stat-Signature: adasqutgqi9j5j8jfz7fe3mnx91146no
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794240061-216173
X-HE-Meta: U2FsdGVkX18QIRbNrJ7+jcYscDgKRnehDTl4cDb+cp5nn9mx4INRfed8oy5pie4sF98cJHCuE6scWg7TeOSK5ZS/VWl+9a0iQHv9AkTCiVxrqDRlzVFOsQ8wdvm/QSXL0HXHle1Vhd66cepVJbZqf8Tma3b0X+AnVs1+UZceWhD5apSUsHaRx0XaRN5ZpOf5WfP9CVxkARShSCOGpDh6UCq98HrMdXxD+oo0WMpSr+I0sXRHBIjXpTBANd73B6x0N0zut940HTWBzjyNKu+Z3wzmOqt0ip/OhR1tHx9GWEMDKYhq/qnCM3MISn5J312GM/bgGu/tlcSHTfg5cwssNU9cf6srQp251r6baTtr5EEuBMU2yhhOPKXFRH2/8a+5vaHVjt0h/rhkYHc/mIsvNoIcQaof3GJafi2ZSAKb4fQ2cP4mt7sFIXFTRxqleAivyPgLvyZb0DCVeB8i3VaMgDv8hDrDJfaBl0htiPnb3fNywGCFDLDJ8LjsZ5lC4Nk0grBlXwSzSvMVn8TX9dXUAF2TA5bBFhLHnr9Q1KpxBHQJxjIJ+U0idNT7ssuUHEiZO48AnjR0SzdQGkRXEG0DFTWktQrk3aKPhc8hx/0+hsNMXmEPcthwxznXFjFER/Z/3TF7NJeCGqTT9/gb79m1jnqBYbQwvlRnTWx046LHraarO3MliTo5j9xPoUk7tfKFhvp7M93j1CBoSYtle1A5cJX+pGVmOQtzzCYlO63w/eAtJDSdlFr5+LMZXgZ0zHwyVgIszO4gmVprwpp39upcUKyM2fZxTkS8xpPosBIJC+RkkKlCEB7Ke8N7xhIKHDrxdFGnrNxU3ER4LLY9z536PJQcuQcfYZBx/JUqYnir1Ro76Bag+2ryb+LnTNqZkMlmSwiM4yCHmyGAcmMGRI+7ap9egPjuRIW97eCkI+BHDCzkWOyqqtFPsHQ2enz48Ff1+Kdz206xwdJX5gQOyFy
 bEYsk/KG
 r/+Q2EFhsb52cBMvtXbhw7FHCOk55odM0/dZ98ZmtOBlS+6dd1hAi3DGOY/eRsDyTpvQ0MCEC2GUdf/yzuOAAERLSKyIOae6OKjUXEtZx/f5Z469gK5EZv1iY7838SK/ji+nfovrl4WdELAjS+pmJmnaFVgRf6qnXgJnw9nt2RYnDCX6km4S3kBPepVyWO/oS1yrrAAVJxazN4ZGkn5EljdnaVOTr10e2Mev60wX2/irAJm1KV3jR5RODFG/PYRg5CO5kReZSML430wihntk4zj2Z9Sd6ECVSL9CYNWXzt+w+Xe6nd3qFGS+C3scdv3p2+d9u6d/KrKA+5tADTWP8cc9FCeD9nyCoZASj0hNk4gAK1R+oHBKZcf1b6jquymt3LNm8JfsKq/uoFbkNjg8Ln/sWFSgjbyrCtPzhUFAwEcvdGvMTDTQlZssIy9QfE5PIWywrgUdJHovE/W7F33uMJY53bBwlCet6TPKZjaKktBYlIFBJQTeeiSr0lbggLbC+KZYzrzQiMAngqJwdkX7PZ2H9bQaGC2fst71xDP0xgInLfRBECIfIa5IU3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement set_direct_map_pkey() using POE.

Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/set_memory.h |  4 ++++
 arch/arm64/mm/pageattr.c            | 26 ++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/set_memory.h
index 0091ba12200e..8322615b8ffb 100644
--- a/arch/arm64/include/asm/set_memory.h
+++ b/arch/arm64/include/asm/set_memory.h
@@ -18,4 +18,8 @@ bool kernel_page_present(struct page *page);
 int set_memory_encrypted(unsigned long addr, int numpages);
 int set_memory_decrypted(unsigned long addr, int numpages);
 
+#ifdef CONFIG_ARCH_HAS_KPKEYS
+int set_direct_map_pkey(unsigned long addr, int numpages, int pkey);
+#endif
+
 #endif /* _ASM_ARM64_SET_MEMORY_H */
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index de7bf95003ea..7143bb2dfecd 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -9,6 +9,8 @@
 #include <linux/sched.h>
 #include <linux/vmalloc.h>
 #include <linux/pagewalk.h>
+#include <linux/pkeys.h>
+#include <linux/kpkeys.h>
 
 #include <asm/cacheflush.h>
 #include <asm/pgtable-prot.h>
@@ -319,6 +321,30 @@ int __set_memory_enc_dec(unsigned long addr, int numpages, bool encrypt)
 				      __pgprot(PTE_PRESENT_INVALID));
 }
 
+#ifdef CONFIG_ARCH_HAS_KPKEYS
+int set_direct_map_pkey(unsigned long addr, int numpages, int pkey)
+{
+	unsigned long set_prot = 0;
+
+	if (!kpkeys_supported() || !can_set_direct_map())
+		return 0;
+
+	if (!__is_lm_address(kasan_reset_tag((void *)addr)))
+		return -EINVAL;
+
+	if (pkey < 0 || pkey >= arch_max_pkey())
+		return -EINVAL;
+
+	set_prot |= pkey & BIT(0) ? PTE_PO_IDX_0 : 0;
+	set_prot |= pkey & BIT(1) ? PTE_PO_IDX_1 : 0;
+	set_prot |= pkey & BIT(2) ? PTE_PO_IDX_2 : 0;
+
+	return __change_memory_common(addr, PAGE_SIZE * numpages,
+				      __pgprot(set_prot),
+				      __pgprot(PTE_PO_IDX_MASK));
+}
+#endif
+
 #ifdef CONFIG_DEBUG_PAGEALLOC
 void __kernel_map_pages(struct page *page, int numpages, int enable)
 {

-- 
2.56.0


