Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E877DD5B175
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 15:04:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 479826B000D; Mon, 15 Dec 2025 10:04:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 429DA6B000E; Mon, 15 Dec 2025 10:04:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 318B76B0010; Mon, 15 Dec 2025 10:04:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1C5C56B000D
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 10:04:03 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 93BA61DFD83
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:04:02 +0000 (UTC)
X-FDA: 84222025524.21.143DED1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id A9347A0011
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:04:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765811041; a=rsa-sha256;
	cv=none;
	b=P7fbKZ/CKeG8WXo4667RLGWEZKpsbySWpTfbCfyUtaZykKsbOqdaNtvMHMSnBouAUPc+ef
	D8AcSkZdO8R27nne7nanzmq2Yiys6D/v87p2rwLQxfYY9pFevAyE7UDOLtATM6caP7v8jH
	GrTYNgHC4Uwwy2zn6x4v8MbtBnfgwwM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765811041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wxflffJTh0pyYZvyWMeVPJtd+lYqkq24w2n0H8YxAm8=;
	b=700kB+tH5rPMAr74HmM85L6JwEWqnOFSTeTPm19sejUR7NiZaoPBPL3Kyep1SmlxSh2bZ+
	xwWb80fvkF7x02vEcj6ecNsjLsEPBW+aBg2Da2pup3XzNzlI/lAdZO6B6U9Zs23F1b56C1
	cz3+o/jvAyVIE2vg0mXVuhjuCpbWWP0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ABDB91684;
	Mon, 15 Dec 2025 07:03:52 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8D5F43F73B;
	Mon, 15 Dec 2025 07:03:54 -0800 (PST)
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
Subject: [PATCH v6 04/14] sparc/mm: implement arch_flush_lazy_mmu_mode()
Date: Mon, 15 Dec 2025 15:03:13 +0000
Message-ID: <20251215150323.2218608-5-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251215150323.2218608-1-kevin.brodsky@arm.com>
References: <20251215150323.2218608-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A9347A0011
X-Stat-Signature: s5h3asoz987kj9dh7soke64h5ai4rup1
X-Rspam-User: 
X-HE-Tag: 1765811040-638802
X-HE-Meta: U2FsdGVkX1+keaMKDh3W3dk4mSU63FzqXntOdn1bTYyxpewkBshO+anT8GQcDWGvZtoU0BBM16lmlgV6OEXCbfPUd0k2d8qhKKLmgWanAfkR1AZe5WJ0uzlDzOdXU1d7pyexnLxeZ442tcEx7QXX5263Z8MI01WhNzmjqZh+KZGCON+VClhBaSKWTVaGsgLtsX73vjuPwneNFpNcEq+2exXGwU7mcBGakn5kh4xpU6CXafh7YG2P+CerAbZXLMOyDFqisUlEOXVs7Wx8JVa9EnCGfQR7ZE2QWwFuAF/UkYhfQOdQRdS+0CiNodcdat/u/upXVYKejOpwZUH6kZH72oMNTmycWUohd8OrHiIWPDyodyLDYfjxul53nb6JNC1j3UBWGcNqeQ5sSZb5z5hD/B5Un/a8iAXyPPt0A3RlqdyB/d9455vXH8aQTWvPyC2p9/GyYkGBPIpT78vCBbQ2+QX0FeOjMKskff5iALdyNUq9OS/inK3A3l37XhzC2Y8ezOizaJ8/ywX0Edbe1TM7ahfQuxPIBbTywDHGB1E5REu4i3lrXdFr0uVuzj+H1GaTx/5r+TXj0Q2ppKYXYhyt/IKmGc2xn7Zdbr5KStQ48qG0P5+vtFux1zZWJuVND+AM/qtoxmz4/ww6RTxKDt9fFwkV1OnlixKLFTihc+O6VFBaCrYzY8PPCfguSC8nmqagai4B6qPhQCBzAsUIBmb5M5yKx6KiTKxHKVc/PvufZMRBGfj6CWJuPjc88R3AvsaMn4XKib4534kCiXd7PRhgg2WWY2Ezf8oISiNKzetamBmHkms6npYg+JeBKm+61U0x5nhrMvVuq2lmMGKaZQFKoFxaaVUDMzEbQyvivqfjap1di7R7Zr9f8FDgs6rP0UPcj33Pq7FcWUScGhcXYyoN5w/JgiYiWpLXufZ7nmhLUJzWhrRtnYzfKyBy6qrsJgtQ/U9MKwL9myJ5FKKwg9T
 W0Q7BPNB
 WFHVuM+JAeOzVSllUoMIQjwHOJdVdlN3Mmf6COdOm7C2XDoimfWyVijpbamC+TvTzKJTLmbYiVrH4DBb3Fh6BMiVZfhAJKRKLRQmneJOFuQaTfx11KUhXxfrDuMDKoYiDXf19UDGnrYoj/LRpwUm0daPKCbEKJaqf9ybf/io4bh+GNxXRpZ76EtTFLD48AeG0VkVo1Nn2FPh6X6j5GHOZhL/eATZc9Av3Ruds1Ix+dILBf1miM9ZidOMAzFoeknMVqUJNovMbDItbdubMYPb8n1YeCStziB03VHpTUT0rdpbRvEU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Upcoming changes to the lazy_mmu API will cause
arch_flush_lazy_mmu_mode() to be called when leaving a nested
lazy_mmu section.

Move the relevant logic from arch_leave_lazy_mmu_mode() to
arch_flush_lazy_mmu_mode() and have the former call the latter.

Note: the additional this_cpu_ptr() call on the
arch_leave_lazy_mmu_mode() path will be removed in a subsequent
patch.

Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/sparc/include/asm/tlbflush_64.h | 2 +-
 arch/sparc/mm/tlb.c                  | 9 ++++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/include/asm/tlbflush_64.h b/arch/sparc/include/asm/tlbflush_64.h
index 8b8cdaa69272..925bb5d7a4e1 100644
--- a/arch/sparc/include/asm/tlbflush_64.h
+++ b/arch/sparc/include/asm/tlbflush_64.h
@@ -43,8 +43,8 @@ void flush_tlb_kernel_range(unsigned long start, unsigned long end);
 
 void flush_tlb_pending(void);
 void arch_enter_lazy_mmu_mode(void);
+void arch_flush_lazy_mmu_mode(void);
 void arch_leave_lazy_mmu_mode(void);
-#define arch_flush_lazy_mmu_mode()      do {} while (0)
 
 /* Local cpu only.  */
 void __flush_tlb_all(void);
diff --git a/arch/sparc/mm/tlb.c b/arch/sparc/mm/tlb.c
index a35ddcca5e76..7b5dfcdb1243 100644
--- a/arch/sparc/mm/tlb.c
+++ b/arch/sparc/mm/tlb.c
@@ -59,12 +59,19 @@ void arch_enter_lazy_mmu_mode(void)
 	tb->active = 1;
 }
 
-void arch_leave_lazy_mmu_mode(void)
+void arch_flush_lazy_mmu_mode(void)
 {
 	struct tlb_batch *tb = this_cpu_ptr(&tlb_batch);
 
 	if (tb->tlb_nr)
 		flush_tlb_pending();
+}
+
+void arch_leave_lazy_mmu_mode(void)
+{
+	struct tlb_batch *tb = this_cpu_ptr(&tlb_batch);
+
+	arch_flush_lazy_mmu_mode();
 	tb->active = 0;
 	preempt_enable();
 }
-- 
2.51.2


