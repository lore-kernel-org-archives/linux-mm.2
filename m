Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0504CA1015
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 12:58:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 447BB8E0016; Thu,  4 Sep 2025 08:58:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41F948E0013; Thu,  4 Sep 2025 08:58:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BFD48E0016; Thu,  4 Sep 2025 08:58:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1ADE58E0013
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 08:58:43 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DC4EA56731
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:58:42 +0000 (UTC)
X-FDA: 83851572084.25.B345220
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4AF5940012
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:58:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756990721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nirw51lPbify+8xW0U8926rJSOPYlf5WSj5+UPxSk1M=;
	b=DQBV2ZMoop825LhrYTXXDsSRhd/8d1nI5CkpUtERJ6z5CPzU/Z0vUommHvVfIoAeLWzJry
	ZxJThf2dgO6POsCp+YFJkUbXg1DREdVUo7ZBz5Js8tz/MrT6mGm7eRDSgzg5hEnEOpqeMv
	4PmuZHDr+7KwGv7J2jlDBJnRCN8yq9Y=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756990721; a=rsa-sha256;
	cv=none;
	b=D0wsW5QQfCXUGnAL7u0WbMMO+LTuS8/4SuKxQP5bln+bVnBX1zxUmkRz0knHTYnn5gTgLB
	skWP0GwAjuia+oN+UWnpohMN+BghPsxdh/eWmt2h/apHJc6yLh8XL3tKoJpASvemmfbX0E
	+BWR6HGqaPEX7O3nRK8NrvzTE1/9GWs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2267F2ECB;
	Thu,  4 Sep 2025 05:58:32 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E64E73F6A8;
	Thu,  4 Sep 2025 05:58:35 -0700 (PDT)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
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
	Ryan Roberts <ryan.roberts@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	xen-devel@lists.xenproject.org
Subject: [PATCH 4/7] x86/xen: support nested lazy_mmu sections (again)
Date: Thu,  4 Sep 2025 13:57:33 +0100
Message-ID: <20250904125736.3918646-5-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250904125736.3918646-1-kevin.brodsky@arm.com>
References: <20250904125736.3918646-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4AF5940012
X-Stat-Signature: gxgj1h71ju5ctkn65uog36zcwb3is6z4
X-Rspam-User: 
X-HE-Tag: 1756990721-542181
X-HE-Meta: U2FsdGVkX18/hCmb57/4b02RD00h2JNfYEsXHEP/gAmJeh4kq1uUyuM18AUT0Tn3JwAnRfffNHxd/gnozTQwcEXOT/M32ktZW646GUPVLyGxLz1oVMqPwzFxuuw1dEU3KuR5ZKO7K5Y3oeSOanThW4hjZxOB1u/6PJFb6x9aob5P/MY4Qhl3Fc2RvTAwrUSgol0hP/ijYDvKmQ7YKolJEC/c0Pdv7vNWY/hAT5xN3VBcGc87FXMrW0v4hNCHoz7Qdyl0tuV2+Yos12/At7Ovf2vLgD8Y7pNJtGWldUy9cE3wAVzbET4LrdD+LfcG2F5GnjFJABPH7XNrCTo883iFltcY+I+SO5LgjgSJraNFYRBpdqhgfPai8YhLUdd0dmeZDsGy16jWUn8ccs1SIoAnQsQ80hDcsmhIHVCk0VcT0v2Pd65ht9Ji4E6H4+t+adiPuq7lH1K5JELLKocmKOqqKi/CFH8hac23hUqeihbXNnVgZXHGQwBfJ3Pnj8h9XrA/+qZLTYnck0HOwpM92TPPuRgvNteCiCirWrV96YxQ7mwgX4OH/3mSsPGbKIWhZLEne/MECLh/aEugW0GfrbxfiwKD+u9X3yPvluOdtnLwMDQLnNZ+4FHVS5FGCqx90EpFS5dNY7H24/HxtQXcbK+rBM2o8ILTfmdT9TJzMCr12XINlykGWmFYHPOsSNMzT4IfswdsHDYcViDM9RuhGBZtXqkZeSmUkFmA981T/9I5/ESRaazNrilUo5Apc1xFob3dGi331ei7ayuJEdf4QjYdy5pyzga8atGZwKQ3QIX+7Px2OGHlWrEH0SEmdT2/kTJo5MXisgUikghPkQh/0qBpXhxDfmqlRgxO2cwbq/hnVKqA159kKaFXHvNKT15aoHat/56D5ghBbeyhj1Py015d0jKM9V4aZtw9CJldgt7+iQbgpEeHXevi6hwPBFDa62vGCpPx2lz7PGzrChBYle4
 ZU5JTxzk
 si218rdcE6aMQmBLVxME9J1J4Pott6h+HXKxwr7EmWAz+olO2N6P9xVch21CJi+30hqi/YFDEqiXCSMrhR01mF3LSdMoiOqscyYbdBbAm/1SySdH0AvETbesxYn3L/xKv+HrG0UFxUjqwqiKkNpQFXnCztoO2SIKVeJslSGT4YRcMLeKy/D+u9v0uOvnB9KxI5XIr8pAYM0hLtCg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 49147beb0ccb ("x86/xen: allow nesting of same lazy mode")
originally introduced support for nested lazy sections (LAZY_MMU and
LAZY_CPU). It later got reverted by commit c36549ff8d84 as its
implementation turned out to be intolerant to preemption.

Now that the lazy_mmu API allows enter() to pass through a state to
the matching leave() call, we can support nesting again for the
LAZY_MMU mode in a preemption-safe manner. If xen_enter_lazy_mmu() is
called inside an active lazy_mmu section, xen_lazy_mode will already
be set to XEN_LAZY_MMU and we can then return LAZY_MMU_NESTED to
instruct the matching xen_leave_lazy_mmu() call to leave
xen_lazy_mode unchanged.

The only effect of this patch is to ensure that xen_lazy_mode
remains set to XEN_LAZY_MMU until the outermost lazy_mmu section
ends. xen_leave_lazy_mmu() still calls xen_mc_flush()
unconditionally.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/x86/include/asm/paravirt.h       |  6 ++----
 arch/x86/include/asm/paravirt_types.h |  4 ++--
 arch/x86/xen/mmu_pv.c                 | 11 ++++++++---
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 65a0d394fba1..4ecd3a6b1dea 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -529,14 +529,12 @@ static inline void arch_end_context_switch(struct task_struct *next)
 #define  __HAVE_ARCH_ENTER_LAZY_MMU_MODE
 static inline lazy_mmu_state_t arch_enter_lazy_mmu_mode(void)
 {
-	PVOP_VCALL0(mmu.lazy_mode.enter);
-
-	return LAZY_MMU_DEFAULT;
+	return PVOP_CALL0(lazy_mmu_state_t, mmu.lazy_mode.enter);
 }
 
 static inline void arch_leave_lazy_mmu_mode(lazy_mmu_state_t state)
 {
-	PVOP_VCALL0(mmu.lazy_mode.leave);
+	PVOP_VCALL1(mmu.lazy_mode.leave, state);
 }
 
 static inline void arch_flush_lazy_mmu_mode(void)
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index bc1af86868a3..b7c567ccbf32 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -45,8 +45,8 @@ typedef int lazy_mmu_state_t;
 
 struct pv_lazy_ops {
 	/* Set deferred update mode, used for batching operations. */
-	void (*enter)(void);
-	void (*leave)(void);
+	lazy_mmu_state_t (*enter)(void);
+	void (*leave)(lazy_mmu_state_t);
 	void (*flush)(void);
 } __no_randomize_layout;
 #endif
diff --git a/arch/x86/xen/mmu_pv.c b/arch/x86/xen/mmu_pv.c
index 2039d5132ca3..6e5390ff06a5 100644
--- a/arch/x86/xen/mmu_pv.c
+++ b/arch/x86/xen/mmu_pv.c
@@ -2130,9 +2130,13 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 #endif
 }
 
-static void xen_enter_lazy_mmu(void)
+static lazy_mmu_state_t xen_enter_lazy_mmu(void)
 {
+	if (this_cpu_read(xen_lazy_mode) == XEN_LAZY_MMU)
+		return LAZY_MMU_NESTED;
+
 	enter_lazy(XEN_LAZY_MMU);
+	return LAZY_MMU_DEFAULT;
 }
 
 static void xen_flush_lazy_mmu(void)
@@ -2167,11 +2171,12 @@ static void __init xen_post_allocator_init(void)
 	pv_ops.mmu.write_cr3 = &xen_write_cr3;
 }
 
-static void xen_leave_lazy_mmu(void)
+static void xen_leave_lazy_mmu(lazy_mmu_state_t state)
 {
 	preempt_disable();
 	xen_mc_flush();
-	leave_lazy(XEN_LAZY_MMU);
+	if (state != LAZY_MMU_NESTED)
+		leave_lazy(XEN_LAZY_MMU);
 	preempt_enable();
 }
 
-- 
2.47.0


