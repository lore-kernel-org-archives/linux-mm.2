Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7922210AB832
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 23:37:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB2006B0092; Thu, 26 Mar 2026 19:37:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0F0F6B0093; Thu, 26 Mar 2026 19:37:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EE3E6B0095; Thu, 26 Mar 2026 19:37:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6DE006B0092
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 19:37:09 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2D3DC140EFE
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:37:09 +0000 (UTC)
X-FDA: 84589827378.02.AC7E958
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5ED5F40003
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:37:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=c+BGhUMZ;
	spf=pass (imf01.hostedemail.com: domain of 3IcPFaQsKCBQuw4yB5yID7008805y.w86527EH-664Fuw4.8B0@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3IcPFaQsKCBQuw4yB5yID7008805y.w86527EH-664Fuw4.8B0@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774568227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CNb2uR0lRZazBe4OJVZFjtnQRAuzu3Ihzf0aacyDPTQ=;
	b=LdY2IPJIKf1PRMY3EYP16x+eCI46d7+6fF5VXW+WqfOwocjGiIDyhe6yPcx/BOl8z3xorv
	ZJDnAmjhvDxjSfMdDIOfTPQgK9Y518SVVbugdzB5fEYz0ZV8+XkFtYw7oElqFZzntXPbmw
	77xNhSopruQUYZa1MuAfrVaqljvF28w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774568227; a=rsa-sha256;
	cv=none;
	b=BHdcrHcbeYZgofjqMzMQLbEWxu8kxyK7ECh/48Fr9oA34k+SUQXOh7IMIclveq6v42cZx2
	mxl2ppm/nvwwgMMkiTQ/8WYFxAdrV2RsrBhEGANYXlUTDTo6jB/fMiEkneG+pbNDGFRnjs
	wj1YMenLx2x+XOVicOuChI1iE0uDB4U=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=c+BGhUMZ;
	spf=pass (imf01.hostedemail.com: domain of 3IcPFaQsKCBQuw4yB5yID7008805y.w86527EH-664Fuw4.8B0@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3IcPFaQsKCBQuw4yB5yID7008805y.w86527EH-664Fuw4.8B0@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c738b1f630eso3449638a12.2
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774568226; x=1775173026; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CNb2uR0lRZazBe4OJVZFjtnQRAuzu3Ihzf0aacyDPTQ=;
        b=c+BGhUMZ7Gq3VCuJ/JYaGJqQXJrtuEUFjRsW4Nsbwj8nwr0TOyERgmztPFFB+A6zrb
         JQduJ757K/p2BGrayRSFk2aFyvUlv7maSLLan+aiFvUd7+1ybEPTg1nOhvxahrNFD/xn
         cCr72z5DG7sBxjYllordQcHBY21xbzIkGoKvO9iK6cH8HypLeLI1HhXysE3uRkJwuTyK
         tgvC3uM523ARGQ7MeAIAbkx3RifTbeKAflo6ygPoTAjnFgj45gLJMVyMWw9Q4AzR5urj
         CzNCJZqzykNFqOh0VQC2z4VcgAMN6pqMPcErNvku/NrvrITsmxDqNKY3zP0ijCwP0dCY
         Nl1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774568226; x=1775173026;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CNb2uR0lRZazBe4OJVZFjtnQRAuzu3Ihzf0aacyDPTQ=;
        b=YOROdYhk+/4EIp3VZwHS+qmrJlwUX4xa+NsoXviAkR/tW/3mCwlPwNnV5qh7DH8kX4
         HUnqhwvctFsqzNbnH0tgX1PBveNVulILikTWiHy9OMC1FrTxvsIsoFSIiIYLbPraueoM
         4UfDKnAQjf5ZZ64o5Sw/Fwy+tp9zVAieahSgCPWwsHPtSG54CVorPD1RTXnTB6z5Xhg8
         1JoTYztOhxahYlLeVYKRyc31vhtsU3El3SbphpxudZ8Dmrfr9GhFzjVlwnPuKrGwVuqO
         KBKOlRQRBtXFAU3eaI4n/MHzBozj8NR03UgrswSwlCl0CoBpWa56fB7QQJJiO1FW0QIr
         ajsA==
X-Forwarded-Encrypted: i=1; AJvYcCWqbk71KUfB9UijaP8iToC5zKDBpDlnE0FpdQGLECO0qyx8coQjA1LzHDJ4uL6I5yu/vqZZkT+IBw==@kvack.org
X-Gm-Message-State: AOJu0YymYBItXuFYxlku5ThWAWwWubpP4M+4T/OywJMDqlnvirJnHmkK
	thOGs4+GKbdwyuQFReJEbif2bbfGG17EVi7yhS24VV2d17Y5Lti+2W3QJHjw5eyVOvn9nAU3R36
	weZUWxNhWqDbeSsaT2DiEj/W6iA==
X-Received: from pfbmy7-n2.prod.google.com ([2002:a05:6a00:6d47:20b0:822:4e8c:2c9e])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:430c:b0:82a:1044:3563 with SMTP id d2e1a72fcca58-82c95d32c02mr282953b3a.23.1774568225809;
 Thu, 26 Mar 2026 16:37:05 -0700 (PDT)
Date: Thu, 26 Mar 2026 16:36:42 -0700
In-Reply-To: <cover.1774568083.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com> <cover.1774568083.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <a52f7c79f45b3e411fe221793d7cba6f4540766f.1774568083.git.ackerleytng@google.com>
Subject: [POC PATCH 4/6] KVM: selftests: Allow specifying CoCo-privateness
 while mapping a page
From: Ackerley Tng <ackerleytng@google.com>
To: ackerleytng@google.com
Cc: aik@amd.com, akpm@linux-foundation.org, andrew.jones@linux.dev, 
	aneesh.kumar@kernel.org, axelrasmussen@google.com, baohua@kernel.org, 
	bhe@redhat.com, binbin.wu@linux.intel.com, bp@alien8.de, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, chrisl@kernel.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, forkloop@google.com, 
	hpa@zytor.com, ira.weiny@intel.com, jgg@ziepe.ca, jmattson@google.com, 
	jroedel@suse.de, jthoughton@google.com, kasong@tencent.com, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com, 
	mhiramat@kernel.org, michael.roth@amd.com, mingo@redhat.com, 
	nphamcs@gmail.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	pbonzini@redhat.com, pratyush@kernel.org, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, rostedt@goodmis.org, 
	seanjc@google.com, shikemeng@huaweicloud.com, shivankg@amd.com, 
	shuah@kernel.org, skhan@linuxfoundation.org, steven.price@arm.com, 
	suzuki.poulose@arm.com, tabba@google.com, tglx@kernel.org, 
	vannapurve@google.com, vbabka@kernel.org, weixugc@google.com, 
	willy@infradead.org, wyihan@google.com, x86@kernel.org, yan.y.zhao@intel.com, 
	yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Stat-Signature: wkstzmkqs4rjbi9rbwyykjjyb68fnm77
X-Rspamd-Queue-Id: 5ED5F40003
X-Rspam-User: 
X-HE-Tag: 1774568227-114748
X-HE-Meta: U2FsdGVkX1+aqsIEkrMIps8FuLYjnIt9JVxr6KDfU7QoL5QJeqz+cRnvdli8I6Lmn8ZywS35HeBoaHJKJx0i9q3IAsm1VQOrvs2bfB071rMMtFAVO/PGNJ5fyAhabBIXIw4/LaRMeD+vqg3POTisGI3NQpDKs8Iz6+l9+F7GrlWkXfS8EmwsrMORpApbj8ILBAEjzFmE9Tc3bw+IEo6QLcw4pjbDSsMWFycW6kFGs2kiH0yQlbb/3rSs++NOgAK6uk4SrsxQNcvGfIYXhv32rS4SoZioXiDFmTr4vn6Bxitb9ugdSIVyl9XLsjM8O2rwNveCSFASd90FuZra6ZFv3oxjxBmjAjBbuvQmEUy0IS0m1hOwQD26TYat4P7yvvrtdxVTe//HMha8i1uhp3eM2kPf42bUeIllmV8ZHJvRS30I21S6kaYgbQ6s/qCPYO3kbHVl5cH3m1i7jJy/S5QHKy4SWuI7wiM3imrr6X6KUcqBms+5I3EAb+Mi0LaJbsB8Y7NwyVuaRJZyD/BCC1gnq9PsAgkMbSfPEZplQOOussku7WOCF2qD6Y4EROv05F5n16jxx7RH+mBMZUaRZDMcT/jhV89GzctSHrA6r4qLT01o0ZZo5oZQ7HLGGFXPYrg1UUecxyt4PdGZZWibpONOmameRGXsMMTr4+w5KL7CkZY62d5Gz5Nc8mWAXJbHknez/PzWzcPITokIjOOiarbzW5LEg+3wT1vwFhs9N/7inAUQfgVFTM7/KL0xXMeu/lgVuNu0R96X366m42Fk4k5VdRBTGBDeGIzcFu9Qlb+9FSGY5czKrxwhpptUe4EZvOA7H6yoP/MXhAZDhYC8sjUTNEakJAcqTe012Sbxfdk8dwkM3oGhxrh5TrFyEdGQT7gxEayvsy+A7joXx+zmDM2RVpTpcQEeiPn+t0ElfTkcFAChHMWhGChrIE8lgkKJiYv7HfxBT+6Tc+YHCzEUGOf
 zFjz6dEL
 JmtkMCTB4IrsQc3Iv+NnNBm6y9DPHMrzmOyVr46mIcv+oQ2qpzhVne49KJq8HNICSjB+3fkStDUlB01NejXYoLMSfjQrQa5FbRYRLOeEnRreQsso5Ngcoi/mN0p89T5zPld7w6bH5dmepaGwimvTp/UGdjyh+N8G1wDvR9RQthmozx2q1Rnp1fg06iOkJ/jgcqwDWns8XLCDxc2y+vn5EjlqnyDlzB4K/1aCJ1hAnWOPg+7wz90s1cmszHPo6V3uEWQ+KcGFD3T4gs1UBjiumd89+xprbiUaMV/y9BpSVjoWC2yE6XgQSC/OIafGlxGd+FfOfYmDBr1q6QbQFJMf+HehWZqLvXV66iz8xJeIu3/BR6C3Oi03cvrhrvvGG9u5wKDBmfX5l1fOg66g48t8GG5TpWpjKnQWqUxcO3kuz4FoLuY8mLrEIKgISf9y5rBtK2uv6qFrV9xgcvTpZ277m0NUupevsEsH65XJHMihfHfpYWQFKj1s0x9/6czFsrnYvVNF65j31GsVKRjOmUf9wntp2SJH94gOLTFge0l4HCxq5vAisPKhWFDxfUeDaGaqUSXii1Bl9Cvx9BxGhcMrRlp2eCTUS+g1YmQiZbCneB7kQ1lo7ITSuy42FlWTIoALQVBXoQn1D2qv6BW7/4QJohfuZWa6UjhzaEYk0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/x86/processor.h |  2 ++
 tools/testing/selftests/kvm/lib/x86/processor.c     | 13 ++++++++++---
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 469a221221575..64870968ee47a 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1499,6 +1499,8 @@ enum pg_level {
 void tdp_mmu_init(struct kvm_vm *vm, int pgtable_levels,
 		  struct pte_masks *pte_masks);
 
+void ___virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, uint64_t vaddr,
+		    uint64_t paddr, int level, bool private);
 void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, uint64_t vaddr,
 		   uint64_t paddr,  int level);
 void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 23a44941e2837..fcdc4ae40b167 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -254,8 +254,8 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
 	return pte;
 }
 
-void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, uint64_t vaddr,
-		   uint64_t paddr, int level)
+void ___virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, uint64_t vaddr,
+		    uint64_t paddr, int level, bool private)
 {
 	const uint64_t pg_size = PG_LEVEL_SIZE(level);
 	uint64_t *pte = &mmu->pgd;
@@ -307,12 +307,19 @@ void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, uint64_t vaddr,
 	 * Neither SEV nor TDX supports shared page tables, so only the final
 	 * leaf PTE needs manually set the C/S-bit.
 	 */
-	if (vm_is_gpa_protected(vm, paddr))
+	if (private)
 		*pte |= PTE_C_BIT_MASK(mmu);
 	else
 		*pte |= PTE_S_BIT_MASK(mmu);
 }
 
+void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, uint64_t vaddr,
+		   uint64_t paddr, int level)
+{
+	___virt_pg_map(vm, mmu, vaddr, paddr, level,
+		       vm_is_gpa_protected(vm, paddr));
+}
+
 void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 {
 	__virt_pg_map(vm, &vm->mmu, vaddr, paddr, PG_LEVEL_4K);
-- 
2.53.0.1018.g2bb0e51243-goog


