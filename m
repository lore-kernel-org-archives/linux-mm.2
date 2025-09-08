Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92A49CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 07:41:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F22218E0013; Mon,  8 Sep 2025 03:41:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED1E38E0001; Mon,  8 Sep 2025 03:41:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC1028E0013; Mon,  8 Sep 2025 03:41:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C596D8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 03:41:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5D554C0A47
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:41:06 +0000 (UTC)
X-FDA: 83865286932.12.4B34CEA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id BCDEA4000A
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:41:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757317264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EhKNqTm0VPwIV+TJCnfOAdRU6AcIQZTQAVGXVHxTG+k=;
	b=QKWJVhxOSWwg6LDiRQQ2yw2wCXZ7oYfjjvugs+v/NjogTuwb4Djcgvx8hSgmBL53/qyBIq
	v9E49BFi75XYUlzHFWDSnRkMWyb8Y76Ngpo97S5D15xSWUcFxcL3GXvsk5nLD951DLp/tI
	7v2IV+/kTnwmzqg9PtrKUH6u7x8osak=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757317264; a=rsa-sha256;
	cv=none;
	b=8J7D+m8aTrA6IpM3jIELEidmeRVO7iuC2pcYi7TD6trzD/DKjuvCm+90OBTlVJ1P8THisN
	rQqqnG0bCT46MIc8ZYEhT4CiE55qkcuPxZe5EM0y5NwmiG18weNf8fFgIAHDZvAVa5GIXO
	C+g9VtrW0Mwe1VaImOK94k3ThO9O7wY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A803E2C46;
	Mon,  8 Sep 2025 00:40:55 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 553163F63F;
	Mon,  8 Sep 2025 00:40:59 -0700 (PDT)
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
Subject: [PATCH v2 6/7] sparc/mm: support nested lazy_mmu sections
Date: Mon,  8 Sep 2025 08:39:30 +0100
Message-ID: <20250908073931.4159362-7-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250908073931.4159362-1-kevin.brodsky@arm.com>
References: <20250908073931.4159362-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BCDEA4000A
X-Stat-Signature: ht44nqsh78a3frc1tpjfyfqgwrrhd3rh
X-Rspam-User: 
X-HE-Tag: 1757317264-74882
X-HE-Meta: U2FsdGVkX1+fa4v7L0VLGfz6++jICidbIGaU8Ma2mRhcYCfjUqeZVikVMO6xbFENN4eokUwy4QByJCycLdxXb/gefIa41MkX2IRMn5ZgIR8t0hCDo1W4xh2VmhllpJ62eLaqrRZx6xqihWzo6Whlx/thEr+uFsZnmqL2qFB5vp2SG97UpFc+4furQ6ens9LFSjR7/fAPla2mMfrFsBoZDolNOWpPP99SbQerP+x6ZAC6xmxIRI08E0h06u9JwB1ojZk//nH9O0uT6dHmTn3r+5af/c4aRBbUfSzznWEB+Rh+a5qbJNEcYl+xiSTJcpjZN5ShI5R/Q4QMByh9T1lJ70IVyKMG9S3TnnUEAAaVdl2ryYH713Y/ThqvblZKvsgmt1Sy2ZZHDhn31U1dbZuNrZumJuISt8S6mwUCWybYsbiFppDn38mgaGLdr37PKtLvG/t8dnUmjglKyfdyxdwjWXT8HDasVbqtVIgQpUx1yNhCwtGJyxoMWhtaRPpDZkAOUSHCRn6m+n+VIiUnW1veIl5i9ZkP4CO3xgKqfbmcnjZk22e+jx8Xf9TdqRZSSVomrfOFZOOPqb9udrvyIcK6lwftNGVxkE+ME9yEdDNcIDLJvVJ0ksa6RQDzljUs25Fwg2trXedyz4Kh5XXABPwcOYAubmMo4X2+J0u5ZDBPja/zRh2Qt7/CtuOp0FL7bS1twGgYkQq0SjDHu++Ef7vuJYxc61pq+IguK1KEgBHF3lqGE/ZOoKzeBSdMwoWWtacK5kNfrl55YmCkHhgls4f2oK9U+moYoknpILQPha6flPgNacqr8k9x7mRm0la/PqADNBWP5pGXW9PSg5DSp5otFpHMnZ/KyVgmKL2dlcHCrLX6iJqZeKYW+chm1OOABjvrl20jNf5rlrh5D2ZEadpHCZ/6FhANbjkpW0otpACHVGjE95ok+CPLqxrFi/zGHhx86GO7bz4H7ki2ssLW2MT
 np5ORd5j
 sPdYrF5mbXTY37lA+zQHbLZFdy10klj9LatBkv2+kNFWZ6o4MIZ+F32ppDxIH+3whZqF33SMo8Acxw2P66xfWyJ5LzkKmxNt14OPK9FkakWcCRwWkOE+PcHq7TZfBV8y7Pz4kiKa+IlHPxI35hGqFQejjaC0Khe/TtSg/uHLE/mvv4o/0h5ivCfG+dR1yuQfCnbMCMcVbiFi5iq8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The lazy_mmu API now allows nested sections to be handled by arch
code: enter() can return a flag if called inside another lazy_mmu
section, so that the matching call to leave() leaves any
optimisation enabled.

This patch implements that new logic for sparc: if there is an
active batch, then enter() returns LAZY_MMU_NESTED and the matching
leave() leaves batch->active set. The preempt_{enable,disable} calls
are left untouched as they already handle nesting themselves.

TLB flushing is still done in leave() regardless of the nesting
level, as the caller may rely on it whether nesting is occurring or
not.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/sparc/mm/tlb.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/sparc/mm/tlb.c b/arch/sparc/mm/tlb.c
index bf5094b770af..fdc33438b85f 100644
--- a/arch/sparc/mm/tlb.c
+++ b/arch/sparc/mm/tlb.c
@@ -56,9 +56,13 @@ lazy_mmu_state_t arch_enter_lazy_mmu_mode(void)
 
 	preempt_disable();
 	tb = this_cpu_ptr(&tlb_batch);
-	tb->active = 1;
 
-	return LAZY_MMU_DEFAULT;
+	if (!tb->active) {
+		tb->active = 1;
+		return LAZY_MMU_DEFAULT;
+	} else {
+		return LAZY_MMU_NESTED;
+	}
 }
 
 void arch_leave_lazy_mmu_mode(lazy_mmu_state_t state)
@@ -67,7 +71,10 @@ void arch_leave_lazy_mmu_mode(lazy_mmu_state_t state)
 
 	if (tb->tlb_nr)
 		flush_tlb_pending();
-	tb->active = 0;
+
+	if (state != LAZY_MMU_NESTED)
+		tb->active = 0;
+
 	preempt_enable();
 }
 
-- 
2.47.0


