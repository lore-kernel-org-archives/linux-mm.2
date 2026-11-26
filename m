Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0505606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dm2c3+DY
Received: by kanga.kvack.org (Postfix)
	id 1A40D6B05B1; Thu, 26 Nov 2026 06:23:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17BFF6B0618; Thu, 26 Nov 2026 06:23:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06B816B0619; Thu, 26 Nov 2026 06:23:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 49DA66B05B1
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:23:01 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9DEDD1603C8
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:23:00 +0000 (UTC)
X-FDA: 85477033320.07.B0B7569
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 048431A000C
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:22:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dm2c3+DY;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795692179;
	b=SXUJFZMoaAC2FQuEi3n+ghDQjYbhK76D2jf4+5c4DaNTrgstOQEBpd+aAcWoodvQHUPPSP
	uboHQCfEHx47qwk2uD+pFusqpCI3dH8mSCqhuZSeVgDmAAQRMwIgDeBYnRc8ZVKYxZJhMr
	3N9RuoP30yoYVRSaIAatWK722cJONsk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795692179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eKUr+0/Ji0+0NqFinQ2LX98LxUecEFKvXWWLdTPhIvY=;
	b=eWQS0x9rzUpiN0reJcjXbEmb2795ozQ08PdgcHWuIP58d3KtNPMdqGv8nXAimHOcfMFkUW
	DS7j2eZuIzxzgbKxfgswjOUNV6ZmAuQm6gGz8Em7MUgTXkn+bLPUA23MQJ/NGyW7VPEA6M
	pQlZQZSPDRtgVCtUMj9WftcJGkM8TnE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dm2c3+DY;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 789C161178;
	Thu, 26 Nov 2026 11:22:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F0C1F000F2;
	Thu, 26 Nov 2026 11:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795692178;
	bh=eKUr+0/Ji0+0NqFinQ2LX98LxUecEFKvXWWLdTPhIvY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Dm2c3+DYVRKxMA0zs3xasLS8OkivKgv5DPVGeim/BVShbcjacDNtx+3LechYlp/Op
	 ThMaD/L6hZeU0tf9h1p4vdNlg9eJwD/HQ5DKkLYtUlVMXa5jZB51zTO4XDajG8ySii
	 wDdVkCpfdlAyFHFHhcQRVOJBDOr3P0UU7Ca08L4iRAAPp2+L0HKCxoLX0Z1W5yumBt
	 TqkF242aFp2Kl7rJJyODroSQL1/f8Y7xLMjmBfv3PTeuMzMJae+NcbcLGJU9+jBwEE
	 LadWoZogFWj9c6qH76TOcKMgugfhPlYgvvKxPVlm8M1UiTmkRzwSE7aSWCiTf0+7g5
	 qb0Htg51a2W+g==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:15:06 +0200
Subject: [PATCH RFC v2 53/54] arch, mm: enable the generic CPA core with
 ARCH_HAS_SET_MEMORY
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-53-723f1e33c3d8@kernel.org>
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
X-Rspam-User:
X-Rspamd-Queue-Id: 048431A000C
X-Stat-Signature: 5i1nxjety77r7juare71h5qhk63zm48r
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795692178-693314
X-HE-Meta: U2FsdGVkX19glwPPzYSgUpUh3MoidKV0Gl7WMoWQKR3gDvQslWWL+SdUVRTy9zzOIo83Gcjw3IOY1LUVB/AvNdlN66K6yMRF1G5ih7YSHO1Z/Gm0orFVqAPQUSn9ghZJ1DvoLQ1TzMaSKizdiPdpSDWNPDFuVdECvtQtLNw8WOrJDxAfhn8pKDU6qbTzcQRjazsWQ2xJ2yNugYEzgAeOVRKkI77TXyaSVq3ylo+t2vGvGwlvim0X1+ahCn+R+AxZvrRx/kT8CmvqsV57Qho03SWp0Ayw96UjkGlN3CQflqXZ4wn3MI8CSZ4QlfmbDvSXVoTAwRgPBctrQxO8OPEaFjGgLDapyVIab9Zfu30WwH/tL/bxxhVYWQO6nNsavaeLf5jRFVsCoQYdSZSHyYDegju71DVU0M/1dSMM5Kk8gRxVcnuc22qlUwA7MrPbilYvPLYwdportYSjuaRoY7gkSEKzBVyxacRV7h7giGuCmoriOP99fDdLGCudrjKQfj5p64bbCnQ3oP/g8NwgwTkBbvIv3k0JejVig3wI8ofsI8H72utykvSxTDfVPgPG3p6Tg0x2WiGpsw1VzVI7douhu9IupAUZbOJacNqP6KV5kzlU0Z0lxUOGP10crjz2nQRd8LhLGJRM3cL/APcM21VlozqZEFqNK8ntbfrTnmG59wQa+XKnw21/QTDCLlfKLa44gs0jlARP4jlidIuU5mW4JDkNKJnpteW6bC+VcvHAUPaQPVAt5RxBIpOajnVukgmQR8Q6m3XcLVmU7o8g7nnkXVOYg/VDh749zXOqMQQmqqIQ5wkX2GEvijiHiAhBkCnl51ipFEgLXUfKtfh2/Vk5S3bGcXNkUjB3l5sv3i1uqS4s8aL3j1HyVkl32EREdCrPQG4Iffb6swKSWAsoJui4MFlYfZr811QGkYQejr4fICdhH3sVnGb7arTULADoI88N08xRlOi3Unj2PLbIjU1
 WkDQoYkO
 oDCS1Hx7UrNwouyAP/dvOuRbVSIXtwrpQAVLO9YPSBfxPxkP28cscsI4NS9Ee34NeYSGigHlfaWNlSb/ONGAEVAizxv6o9VfuU+I/fPjnd5768c11w3iYv/QVJN3K7EhUbVZescC8zFLon3hV3KaPgBP6z+2QIfhToUnBZ86ZQ8KhuZ6Miz79AIzdwDZZPVSlv5/Jh5msC9T4cOtBg+wZKd4NDnrjWarQ1PfQQnvvcBWiJusPwsn7w0mO6nSdRo3NWTdFX4oHWVKhoEJCdJwVXNgXQFedsv1387mDjAWBgl6aRhJ+AStsID2gPrQOgAzumqnSSuVhEaJxozVGPb2bQ1MDvTxZk27la/eVKr0DOOS6Rth8l7VavUehzmjn5JO3SJWVN4IBn3Y96w7h+elV0TBHFG/DB94CS3yE0lmtXydlwTTgLFSdNeoXWJKNNUil2C5bAaUGOlEwbIDdOvklfgwae7Hl03MfrfKaBNM46q2pSLYZNtsUcW5ZWWBNeEk0BE+LpjmtCmSvYEaLKcuMTfx0AFZ03x6jDbIjs0P5szhr7Kw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Every architecture that selects ARCH_HAS_SET_MEMORY now uses the generic
CPA core, and a new one should not need to select two symbols to get it.

Enable GENERIC_PAGEATTR for ARCH_HAS_SET_MEMORY on MMU kernels and drop the
selects from the architectures.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/arm/Kconfig       | 1 -
 arch/arm64/Kconfig     | 1 -
 arch/loongarch/Kconfig | 1 -
 arch/powerpc/Kconfig   | 1 -
 arch/riscv/Kconfig     | 1 -
 arch/s390/Kconfig      | 1 -
 arch/x86/Kconfig       | 1 -
 mm/Kconfig             | 2 +-
 8 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 7a7ccc113126..0cc289a7184a 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -77,7 +77,6 @@ config ARM
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IRQ_SHOW_LEVEL
 	select GENERIC_LIB_DEVMEM_IS_ALLOWED
-	select GENERIC_PAGEATTR if MMU
 	select GENERIC_PCI_IOMAP
 	select GENERIC_SCHED_CLOCK
 	select GENERIC_SMP_IDLE_THREAD
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 846fae788b3c..9b08b2457a55 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -138,7 +138,6 @@ config ARM64
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IRQ_SHOW_LEVEL
 	select GENERIC_LIB_DEVMEM_IS_ALLOWED
-	select GENERIC_PAGEATTR
 	select GENERIC_PCI_IOMAP
 	select GENERIC_SCHED_CLOCK
 	select GENERIC_SMP_IDLE_THREAD
diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index 455a72b8669d..bad699e2847f 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -107,7 +107,6 @@ config LOONGARCH
 	select GENERIC_LIB_LSHRDI3
 	select GENERIC_LIB_UCMPDI2
 	select GENERIC_LIB_DEVMEM_IS_ALLOWED
-	select GENERIC_PAGEATTR
 	select GENERIC_PCI_IOMAP
 	select GENERIC_SCHED_CLOCK
 	select GENERIC_SMP_IDLE_THREAD
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index fbe3a3abeea8..c3b6cd655606 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -211,7 +211,6 @@ config PPC
 	select GENERIC_IOREMAP
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IRQ_SHOW_LEVEL
-	select GENERIC_PAGEATTR
 	select GENERIC_PCI_IOMAP		if PCI
 	select GENERIC_SMP_IDLE_THREAD
 	select HAS_IOPORT			if PCI
diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 0453c665fc64..e7891a2a89da 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -122,7 +122,6 @@ config RISCV
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IRQ_SHOW_LEVEL
 	select GENERIC_LIB_DEVMEM_IS_ALLOWED
-	select GENERIC_PAGEATTR if MMU
 	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_PCI_IOMAP
 	select GENERIC_SCHED_CLOCK
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 413b886a9e9a..7138d923d86f 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -180,7 +180,6 @@ config S390
 	select GENERIC_CPU_VULNERABILITIES
 	select GENERIC_ENTRY
 	select GENERIC_GETTIMEOFDAY
-	select GENERIC_PAGEATTR
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_IOREMAP
 	select GLOB
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f4aceaceaf65..6cf8f121879a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -178,7 +178,6 @@ config X86
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_RESERVATION_MODE
 	select GENERIC_IRQ_SHOW
-	select GENERIC_PAGEATTR
 	select GENERIC_PENDING_IRQ		if SMP
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_GETTIMEOFDAY
diff --git a/mm/Kconfig b/mm/Kconfig
index 3948e64dc590..97e152442e1a 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1139,7 +1139,7 @@ config GENERIC_EARLY_IOREMAP
 	bool
 
 config GENERIC_PAGEATTR
-	bool
+	def_bool ARCH_HAS_SET_MEMORY && MMU
 
 config STACK_MAX_DEFAULT_SIZE_MB
 	int "Default maximum user stack size for 32-bit processes (MB)"

-- 
2.53.0


