Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C91BD5B175
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 15:04:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C68896B000E; Mon, 15 Dec 2025 10:04:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C23776B0010; Mon, 15 Dec 2025 10:04:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B08846B0011; Mon, 15 Dec 2025 10:04:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9ED886B000E
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 10:04:08 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3BB5389573
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:04:08 +0000 (UTC)
X-FDA: 84222025776.28.A864B2A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5555D140013
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:04:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765811046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8PjcRxlbU/ydtWRj6Ipq1dnPy+qOjNejDozpydmwU0s=;
	b=1jVdG8zMUDOXLVB/gylu5ruCiz5yZJrOnY3D9OiwMSI7UwFWQEMDlIg2WRLI76uP72t9Fe
	7jflDg53XZG8ayGbZyL1VkIdQLgimSPdBglSij4HWLijRwALnOGy8dic9h+iT4B0C6y9RS
	/Xjpn+3eBSjnlIAC7Xpv7UaRFe8QFXw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765811046; a=rsa-sha256;
	cv=none;
	b=4XU3aIfUU3cSQoATPIkJ9RPYmR6Ng1Q/67u4VeQ+W8rzEht3RVUXsWO0N4opSanb7QD+iR
	VqyGzWEF+DJ9TM1XV7uC4I790rw3ORf4S3FB5zkGT174EkrTlU+vl+gfKyD2wIRi5hOnAZ
	zZ2MyBUMQC6dvvMhfCjfdAPCEej3s5Y=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4B751168F;
	Mon, 15 Dec 2025 07:03:58 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2A0493F73B;
	Mon, 15 Dec 2025 07:04:00 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Woodhouse <dwmw2@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jann Horn <jannh@google.com>,
	Juergen Gross <jgross@suse.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	x86@kernel.org
Subject: [PATCH v6 05/14] mm: clarify lazy_mmu sleeping constraints
Date: Mon, 15 Dec 2025 15:03:14 +0000
Message-ID: <20251215150323.2218608-6-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251215150323.2218608-1-kevin.brodsky@arm.com>
References: <20251215150323.2218608-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bad58eda9q8s745bcdzwtshjwt64hdhe
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5555D140013
X-HE-Tag: 1765811046-207194
X-HE-Meta: U2FsdGVkX18yPpHJmcNfgVme4bAHZQB9bO4njWxqg5jcXHWKbVk7oZqszvyZQHss0cAcwJEVI5CbFSo7lT+FyTV7VMprZ0SjhYLhJlcn9eXZ7AaYDrTdqGe9JvPqDr+su4YLe0ifG85g1irhaswQMdCi384i/DdIcO6PLKdOoULes7GU57MywXKyjnDGZoCTtqaGR4eeD6D6hiomCaRzp9brqaiVPnJe8pRu13/M9SAamqD7xrpxnqgCHpykgCBtD8IvKlUwmtUwCEi9yn/ZdlP7a+dSm3fAaQkLeur9DXrGrq0UDgTmYb97gOnuxrSEpOae/GJI3ts3DqdOMuvlwLjR83AAEOkpO9IM24V+e2XVRwzZ79tkxETJd/GLgDpF8Zyj/4Nq01U/eLrtOgSSDXpKcs459M7ahHGMh2MrwZ92RYmlnOHqyLbMbd6GknZOJxVLm8ZX7sqP3+vbFvnX+jpHJeRhSAzV+Po3j1uOPKEq6WemK3VvCjE0ark53E0e7ZhtHeB21K4J3CU0vvX/S9GK5aXQhMudWkVhS4voFbTf18QlST9xfEOt6DX5fgnm4UXdVbNSiaJFjBPyAu2fxoah71yw9bkVhr+c/nfTE/N5rSUcaGlHRoOw5XfTibuom8sjRmpclmnd9Erdhil3+9iHaVdEeAdumg2GJ4igbmUcU/3LK+E2biMIy4qIKPL1kTrB/RiTrBZVOxPFetcUgQxTLScxRetW3FxKTYy7IMlDnLvPNH6xS54BeUvsZ8IhIdw7xWNlO7tyXxI1xfEUFNE5cIvtu1m2kMrsAn0LrJ4YTupeplcBGfzrNXo5bheCVhWQd3PDsat6Ha2js2mfJYAXQ+FUGW/hCWbfcNgzfNnvXz0DxK4C4ght0xPtfr4iGy8AFuu1LgG5Y+35t5ejcYZ02rZLseZAhtG10KKRg3YT4xkmwgfpoO+hQu9UA3GPW0fwKQXjLtGl+RTUPaP
 9SfmNFoP
 WG/Rm7U5bTTKRDBuNhLpDqDTl1bUfiZzE05pWK1hDzRZCn8IZqGYNE3kkxSBOapTGwwTbRdikHnyKabMcJP8kU4NPQyk3cteAvvIKYiuAlYSsxr+iB5tovUy6IeoOS6WiBag7qX15RPrZRUIjQdZ2s9xw6JlnGIAaRSmS8HQqa9WfW0KwqG6PUVMnq2F4qQUQmRLmMnmNmuwBKSoKvJhTAniUVgRuoBbyDy0DrWL4rboY4Od7hPHtU75mcrU2QVMM60X/g0ILoGK2yYgiQV0OGRu8+Nz5aEKRIi5nV3LsdmXCBRd0IycW9idkYA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The lazy MMU mode documentation makes clear that an implementation
should not assume that preemption is disabled or any lock is held
upon entry to the mode; however it says nothing about what code
using the lazy MMU interface should expect.

In practice sleeping is forbidden (for generic code) while the lazy
MMU mode is active: say it explicitly.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/linux/pgtable.h | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 652f287c1ef6..1abc4a1c3d72 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -225,11 +225,15 @@ static inline int pmd_dirty(pmd_t pmd)
  * up to date.
  *
  * In the general case, no lock is guaranteed to be held between entry and exit
- * of the lazy mode. So the implementation must assume preemption may be enabled
- * and cpu migration is possible; it must take steps to be robust against this.
- * (In practice, for user PTE updates, the appropriate page table lock(s) are
- * held, but for kernel PTE updates, no lock is held). Nesting is not permitted
- * and the mode cannot be used in interrupt context.
+ * of the lazy mode. (In practice, for user PTE updates, the appropriate page
+ * table lock(s) are held, but for kernel PTE updates, no lock is held).
+ * The implementation must therefore assume preemption may be enabled upon
+ * entry to the mode and cpu migration is possible; it must take steps to be
+ * robust against this. An implementation may handle this by disabling
+ * preemption, as a consequence generic code may not sleep while the lazy MMU
+ * mode is active.
+ *
+ * Nesting is not permitted and the mode cannot be used in interrupt context.
  */
 #ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
 static inline void arch_enter_lazy_mmu_mode(void) {}
-- 
2.51.2


