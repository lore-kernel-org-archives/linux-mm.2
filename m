Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55158CCD193
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 08:28:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1F508E000F; Wed, 15 Oct 2025 04:28:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF7A78E0002; Wed, 15 Oct 2025 04:28:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0D338E000F; Wed, 15 Oct 2025 04:28:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 90F1D8E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:28:01 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 32DCD140BDB
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:28:01 +0000 (UTC)
X-FDA: 83999670762.08.385664F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 99C6D80008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:27:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760516879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yc4JyEzgXUEDCHx7ygqg8Zlo7z2PANIL8HSlmTIOFcE=;
	b=LhpB7pk0LDNNdNUhRVi5OoMxAl+8WXtpcxVHwEoYT/Z3jiTAylL4LX4/vb5LSrfSUY2MJV
	/Y9WKGa1G5AKv/imTVke/p07lmwmoY09SBnn2IcGNZM6VJJwtFz70Ho3aJLNrezFYsbcvI
	9YXtqM+S9y8muVFnRBeKns8I5VWLsbc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760516879; a=rsa-sha256;
	cv=none;
	b=UApIXHxSo7U5MN69zqgVtDaC/kpEkgnyId8cAqrGZM2in9kOQXGaZYfOxaOhgQL6rIgb4S
	QjG1VE4RwWwjagPPC5SVJ6PnLR4/XA97XOuUjfgm734p1Kiw/VmtSMp/AjR9Vy0xBGgkR+
	YJ/4Kix8ydlx0H3aodj2gO/rwclAEFA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E422222EE;
	Wed, 15 Oct 2025 01:27:50 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DF8BD3F66E;
	Wed, 15 Oct 2025 01:27:53 -0700 (PDT)
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
	xen-devel@lists.xenproject.org,
	x86@kernel.org
Subject: [PATCH v3 03/13] powerpc/mm: implement arch_flush_lazy_mmu_mode()
Date: Wed, 15 Oct 2025 09:27:17 +0100
Message-ID: <20251015082727.2395128-4-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20251015082727.2395128-1-kevin.brodsky@arm.com>
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: 3i6be85g55zocf5sg4fids5wmetsz65k
X-Rspam-User: 
X-Rspamd-Queue-Id: 99C6D80008
X-HE-Tag: 1760516879-420250
X-HE-Meta: U2FsdGVkX1/oSd5OXH+vySzw5igEU8pUPgnbyWC9R6yHZK3GEFj8b63NSgaiBL5pUamkcs7c9Ir7CFa5HGJP3aa07bKM5mWbB3HJCk1Ld4viMYMFrAYrlAUzF32I/e1QG13q6FnGoht/4FaoSTNHPVvd//CxaCLASpIDgrMlvQDhDUraCqHid6XSwSvO2D3h3SFM5AQVSJTY/EPkMO1z01UncHeRwfsVm2oKDdEHASTarZFy+Zzwez9pEki4GpoVEiyUJs6yj9iCkl02cRqo4aqRZBTV8xEiBaL+hptcf4Xa6wRKoyfnD2dUzakSNqra60AwgVjbN35WNaitx12diGa18FMCw72OIshlhNA4iO6eUNeQ727JXMZ9gWhE8Q/FJeXtAtQ5xXpmylWiidx3Q3AAdvQNRr9GpzuuxWEn93tGvCFb76X+CGIkEDD7Rqm4uRdV5gCTrGyYD+dwBa6TgvbJmOyZilEOejnwKecerNZP0cRQothNwDlv/8pFc6ErqrysV9REB6w0zP3xd9qKNltwTLmOFclDafzUm8Lp2sco2K3y25sM0ND+63xUmyXZjVgbMKpe944wg9o2nnH8CTzDIM0GSbi3Vb2VHFtPkzgBxyFwjThzL2Lgx/s7kQppRAefPWtPCTNH0mHpzVeD5q4P6WQ/uz6NE9a1xPmjl0ziQTFDMrb43mpEkeZrjcI88ledM0xkx+ta+8Wwx66BU/6KiwDpccQHOD1AbZM/4EhNt/RWhUudZUIFIaB43qH6A8wvI7tg7qpbbAYy5EQPnd+z8POTAnyc3trfDmT0ESTvgMf0/qUUFFGndq5KWInvWL5fzZfN96Pv/BVE6PIq4XzQ394M05SUEaAw4VbhCAVb422vGaF//u+dgdubt+kikrPN0wII9fj/KE0DriYdrElRAVzEJ2SkRDr0iHsCN+pAFZHdAVZf+uxzblIqiQZsXNhwK213dIyVog7HG/b
 8ZVKRWVH
 y4+1W8CQPDYq+wdQJ9Tz4xlS0HrTPdQNqTSN6TURCqZzrPf1lElhSnk653H8ooueHuA4Ii2lnC1nGpEmqQQMUcC27LX1tNGPw2Ja6vejU4wOmeo/Eu1iGrzOy1U5cYxvDSE9tn/Ic64Bwb9pdZUlmDEHdDcBjw8mcMJVzLBT+hgICnciX8sFRY+7mLYrXLr99+aBGzZSW7lcsi1wjG1QQs4qrHVhk6xGdl/PVpsD82W/pm9E=
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

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 .../powerpc/include/asm/book3s/64/tlbflush-hash.h | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
index 146287d9580f..7704dbe8e88d 100644
--- a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
+++ b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
@@ -41,6 +41,16 @@ static inline void arch_enter_lazy_mmu_mode(void)
 	batch->active = 1;
 }
 
+static inline void arch_flush_lazy_mmu_mode(void)
+{
+	struct ppc64_tlb_batch *batch;
+
+	batch = this_cpu_ptr(&ppc64_tlb_batch);
+
+	if (batch->index)
+		__flush_tlb_pending(batch);
+}
+
 static inline void arch_leave_lazy_mmu_mode(void)
 {
 	struct ppc64_tlb_batch *batch;
@@ -49,14 +59,11 @@ static inline void arch_leave_lazy_mmu_mode(void)
 		return;
 	batch = this_cpu_ptr(&ppc64_tlb_batch);
 
-	if (batch->index)
-		__flush_tlb_pending(batch);
+	arch_flush_lazy_mmu_mode();
 	batch->active = 0;
 	preempt_enable();
 }
 
-#define arch_flush_lazy_mmu_mode()      do {} while (0)
-
 extern void hash__tlbiel_all(unsigned int action);
 
 extern void flush_hash_page(unsigned long vpn, real_pte_t pte, int psize,
-- 
2.47.0


