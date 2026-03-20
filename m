Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C74E21099B3B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:39:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35F206B01AE; Fri, 20 Mar 2026 15:39:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E57D6B01B3; Fri, 20 Mar 2026 15:39:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B02F6B01F0; Fri, 20 Mar 2026 15:39:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ED1196B01AE
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:39:44 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B5F691B7306
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:39:44 +0000 (UTC)
X-FDA: 84567456288.14.376D09A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4DA1140010
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:39:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YNEQNMxC;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774035583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MF3HDfZN/X2IuMlCa6w9U893UanxlzUmNuSBnCYYxSY=;
	b=f2WYfqoAYobk4e3hqcHxdbeWb0UBE4O7VSbQsBq5pU4IhpmIDK7E3hTVMuwybMm35VUsk2
	pAiRSZLIHNxSBsgv08QV2AkTjBhSu5dR40WXnvkJCvlgwxplkQ8GObop5ntnD06RL5f3Q/
	Po38RINOVaCbWI5F35nV0wEjvBc884w=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YNEQNMxC;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774035583; a=rsa-sha256;
	cv=none;
	b=asAL7WkZPvJa7oSm+hlvgEuxARk6yHnkxkpOFteCBn/CdVRFblAn023dxmj+IkNwJld36M
	XRH+b4kkVo0vFuoQXXTcYEjoR/LXzqmWJbHOuksqD7F1fRgC2qi7YOp1RlpbCF+VjwQSOT
	EcUjWHq98jOrV9sihMCneBnDsPTRzsI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 891DB61857;
	Fri, 20 Mar 2026 19:39:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57BFC2BCB4;
	Fri, 20 Mar 2026 19:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774035582;
	bh=Zhv1fm6PGlE9I5DuXJBB0cLrVMXpxk9UQr3R6GGX2pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YNEQNMxCWbltp4ulEcA/1pi0w9rAVKrTGQS8+v4PLs+aFYEzztK3IIefy1UFIkuOR
	 rTDQcWY0SioZrCgW7IXmcLKciwKlGXqabHTR/PcPYieqDzBPZ60XqkkxP5s59rZg1A
	 xan9A1ghdC6iIBLyXGYzuD8n0RYMLN+9ymJTqE/THx9LECKRwfgZYXza+nT86iX/k6
	 8p+GKYR5eQNho+Uv+ID2mHduFoCDPEsGOedTudZT9YZBqkya5QuQ6VKpjiS64ChS4F
	 YZzIJnzVkO0R7vQNfDQ1O4zJG1AtpdIzGw2MrsNefJt4teIMi0TcMEfp1mYeAj2lCz
	 AoksKkIoUqu0w==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vineet Gupta <vgupta@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Brian Cain <bcain@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@suse.com>,
	Paul Moore <paul@paul-moore.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-hexagon@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	selinux@vger.kernel.org
Subject: [PATCH v4 25/25] mm: simplify VMA flag tests of excluded flags
Date: Fri, 20 Mar 2026 19:38:42 +0000
Message-ID: <d395c5dd837a9864f5efcec42175910afbe3ce73.1774034900.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774034900.git.ljs@kernel.org>
References: <cover.1774034900.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4DA1140010
X-Rspamd-Server: rspam08
X-Stat-Signature: s4zau51s3g3m3unqh5fw3kdtibtmbcn8
X-HE-Tag: 1774035583-374340
X-HE-Meta: U2FsdGVkX19+sb8wMpN2oa25OJdg3/6Q4NSihH1gZRnLAeAw6Voo9gVFl1XjIdezzKxXo2SuU7huASyBNg3f4qUbCZxosW9bVoEqimZUeu639Q/tz32Ym47+Zv4XAzW8HaqsYPzXffdLGqAs9euYrQaOQq6ikl+Zc4lVZhtNiLDx6M8eUN74TcH0TLE+ctzlI8cL6BYvufeYgMuVVQERD4DnU7SE/auaSDBYjYMOHOSnNyo4er0VfNiSk0tPwXgaTQEtM6vX3pWbN0vopVzHqH/tjLcf5QNl7uuWq9j5ngph9ndNELN+Zkpg1I/Ry6HxyPqNscDpYll3O8yuxu94hduacx82rQIcLj1yLv+uZ/HKtx8IO1BDFokG86fDICwO5q3/jPYrGIgAcMBNSlcYBqOE7VujlszVZCeVpa7C9e6Wo8/fpdfA04WhzMnJ4SL7UYV0i7GWijvHUnmOXNO59idMNmo6veZ7SmSEOLWf64kJHXTy3qE7vNOkuLSukiJGLjkgyLAnwXpKjDdHRv18tDmgwph3ntwL+wgHJxU9c6Txp5hlbViUlFhhsuFyVO5UGO1NYuBuBtAXoSR2FpH6rZf+doZs7jmS+4xXnAUOkpIEyZ2OHYXdEz64+FOlTiZ7I4tWOTcff7kyIehdQi6wcWHmy0XxjntbHY6JVOydw52bc4rU9MREFeQGVpXybdKKZA90pmtlbrDW1gkS0OJjFD5b7VCpzl+y5SsKhfOenYKWNJxwnbIczdU+CSa0gKXjiypvh5NLB7UUDbPeim8ETYsYoifQydGXT2txxIR/4kI1oPIp/etAQSZ1POw2nuMZwd8vdW8uqup9cDLNq/YzOWmz6G1KAaYU99nDNUbYAA7y8dASwhQ03s87k/c87TXvBPhK2rawzNZUBbnn8r4DC0sQ+dsnId4lHk5majXlaFcygzfnbZ0ZPO2Etr/hMBRskS4ar8hv6xEKB3EqXPV
 fIZbiv5Q
 53jVdqpXa8GJAZGwbMl2/EEv56WU78CeKCyjg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We have implemented flag mask comparisons of the form:

if ((vm_flags & (VM_FOO|VM_BAR|VM_BAZ) == VM_FOO) { ... }

Like-for-like in the code using a bitwise-and mask via vma_flags_and() and
using vma_flags_same() to ensure the final result equals only the required
flag value.

This is fine but confusing, make things clearer by instead explicitly
excluding undesired flags and including the desired one via tests of the
form:

	if (vma_flags_test(&flags, VMA_FOO_BIT) &&
	    !vma_flags_test_any(&flags, VMA_BAR_BIT, VMA_BAZ_BIT)) { ... }

Which makes it easier to understand what is going on.

No functional change intended.

Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/mprotect.c | 12 ++++--------
 mm/vma.c      |  7 +++----
 mm/vma.h      |  6 ++----
 3 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 007d9a72b2f0..110d47a36d4b 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -784,14 +784,10 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
 	 * Private VM_LOCKED VMA becoming writable: trigger COW to avoid major
 	 * fault on access.
 	 */
-	if (vma_flags_test(&new_vma_flags, VMA_WRITE_BIT)) {
-		const vma_flags_t mask =
-			vma_flags_and(&old_vma_flags, VMA_WRITE_BIT,
-				      VMA_SHARED_BIT, VMA_LOCKED_BIT);
-
-		if (vma_flags_same(&mask, VMA_LOCKED_BIT))
-			populate_vma_page_range(vma, start, end, NULL);
-	}
+	if (vma_flags_test(&new_vma_flags, VMA_WRITE_BIT) &&
+	    vma_flags_test(&old_vma_flags, VMA_LOCKED_BIT) &&
+	    !vma_flags_test_any(&old_vma_flags, VMA_WRITE_BIT, VMA_SHARED_BIT))
+		populate_vma_page_range(vma, start, end, NULL);
 
 	vm_stat_account(mm, vma_flags_to_legacy(old_vma_flags), -nrpages);
 	newflags = vma_flags_to_legacy(new_vma_flags);
diff --git a/mm/vma.c b/mm/vma.c
index c335f989586f..a4b30a069153 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2343,7 +2343,6 @@ void mm_drop_all_locks(struct mm_struct *mm)
 static bool accountable_mapping(struct mmap_state *map)
 {
 	const struct file *file = map->file;
-	vma_flags_t mask;
 
 	/*
 	 * hugetlb has its own accounting separate from the core VM
@@ -2352,9 +2351,9 @@ static bool accountable_mapping(struct mmap_state *map)
 	if (file && is_file_hugepages(file))
 		return false;
 
-	mask = vma_flags_and(&map->vma_flags, VMA_NORESERVE_BIT, VMA_SHARED_BIT,
-			     VMA_WRITE_BIT);
-	return vma_flags_same(&mask, VMA_WRITE_BIT);
+	return vma_flags_test(&map->vma_flags, VMA_WRITE_BIT) &&
+		!vma_flags_test_any(&map->vma_flags, VMA_NORESERVE_BIT,
+				    VMA_SHARED_BIT);
 }
 
 /*
diff --git a/mm/vma.h b/mm/vma.h
index adc18f7dd9f1..1bfe7e47f6be 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -529,10 +529,8 @@ static inline bool is_data_mapping(vm_flags_t flags)
 
 static inline bool is_data_mapping_vma_flags(const vma_flags_t *vma_flags)
 {
-	const vma_flags_t mask = vma_flags_and(vma_flags,
-			VMA_WRITE_BIT, VMA_SHARED_BIT, VMA_STACK_BIT);
-
-	return vma_flags_same(&mask, VMA_WRITE_BIT);
+	return vma_flags_test(vma_flags, VMA_WRITE_BIT) &&
+		!vma_flags_test_any(vma_flags, VMA_SHARED_BIT, VMA_STACK_BIT);
 }
 
 static inline void vma_iter_config(struct vma_iterator *vmi,
-- 
2.53.0


