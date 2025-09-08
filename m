Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B0A8CA1013
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 07:40:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B03C28E0011; Mon,  8 Sep 2025 03:40:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8B8F8E0001; Mon,  8 Sep 2025 03:40:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92CDA8E0011; Mon,  8 Sep 2025 03:40:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7DB6F8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 03:40:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1A4BB1DF796
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:40:56 +0000 (UTC)
X-FDA: 83865286512.07.B02D212
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id A455B4000A
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:40:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757317254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nirw51lPbify+8xW0U8926rJSOPYlf5WSj5+UPxSk1M=;
	b=tjmGRGccN1mOttiyuEsMPH4YOxwO9P3VI8wGKimeiC/HP9EsMa1hdM1qDr9zNwtlVtRmpO
	z9h/BgHy3NRVuSA13rQtoQQ0k2BxyMGYsh6jmyX25mVSS0avog9DmC/kDxJip6NS0MAZ4Y
	475K4Y8ikzHV+at2SQxmyq9zDM/065Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757317254; a=rsa-sha256;
	cv=none;
	b=Zvl3Sgigxyq8WYsojKUZYCA9jhl0NasjfauvPRIOKcF7qdpB0KU2vc49oWkwI75WCweCZ5
	j7YbMgWsZKJdiXYuYFbNICKhqMXEYcEPdXm02w3d33dvdKYh71Os9+cIDbouXG1oyMTYdw
	YTYWgkL//4MHmW57kHoTwK2jKrk+4NE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ACC311BCA;
	Mon,  8 Sep 2025 00:40:45 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 589A33F63F;
	Mon,  8 Sep 2025 00:40:49 -0700 (PDT)
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
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	xen-devel@lists.xenproject.org
Subject: [PATCH v2 4/7] x86/xen: support nested lazy_mmu sections (again)
Date: Mon,  8 Sep 2025 08:39:28 +0100
Message-ID: <20250908073931.4159362-5-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250908073931.4159362-1-kevin.brodsky@arm.com>
References: <20250908073931.4159362-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A455B4000A
X-Stat-Signature: k39schg9ou8p5kqyrywfahefhrejbh86
X-Rspam-User: 
X-HE-Tag: 1757317254-238366
X-HE-Meta: U2FsdGVkX19DyrXraFxO8/MB6HgGTv5lb13M/3ioCrY8aY9KPEJNWlyDoSreoyr28mqjaPbvUUMUEQ2FmqU6N2vdyYEuc7/1+mqvfEcSY66B6zam2cJPrzQJCFWhWfWiTfyM2GxCJ/JvrDOOFgEN1yjeHYF+kIFDeQxb2f8CFuk66Xs3AXQmtWdRsTFUEZw8fsdroMJk+qOBBOesZznQ87uiVrPVnv/1orikIIY/MIBpvlPoofRP6b8Wx4GdR+wpJQesbURutRdYuXl0XU3K8eG/AFNqfeXRdzF3jNEru2vGLeabOw6yEuzc6ehlVOpbtrkTwoNsSjeUKPIA2TaovCf2mCUL2AR0mbG6v8sIDrfUwG8DcOzjftZ0DG6X/PmNh52/oDYWXuf3UBTYfRhzh0x+09lfzlK5g9/WOSB7kB47YQ6IT0hBIJ04ffTtoxXzGhg3HAspCcLzYrUWL6FnjIyr8P+qd4Y9p4jXVA30emYQLUVuZp5OmdZ/agfx5T/blc65BdXToaThtk06AlASk8WxgaF38iV8fSyUhdYE4IhXMtvJozzAiIbd11XscY2RH4fIfet741BQjD01S4hQdHQFGUcE1o5O7z6SG6LzIXQlUgafmruKYc5HXvbtjSRkSB5BIR6bAGlCfsyy/b6amhBXV7Z32c94Gif6RmGxiENNDOsZcOrxiQ4khQNTqX7WlWPIgBBbOGDzpaok/dISPvDvO+aabeVdrmmzWaR6+xH01Wvua1a5Bqd+0lv+dmr4P1qrFFQJMvKXHT2vvHt3/QWiz0lqBymPp54uXfWCx6oQ3Yjak2ZoQDJM68blSGTKEqLQwy/7lQPEdF6Ah11K0zuXubr2d/hrIil2scsRrpe0dLR+dXuyrrYHw7fNwbqrJJKYog03odg=
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


