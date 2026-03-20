Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EAC21099B3B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:38:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0BEE6B0144; Fri, 20 Mar 2026 15:38:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE3816B014B; Fri, 20 Mar 2026 15:38:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF9B76B014E; Fri, 20 Mar 2026 15:38:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9496E6B0144
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:38:56 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 668F3B6540
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:38:56 +0000 (UTC)
X-FDA: 84567454272.06.672809C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id A3252C000B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:38:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=liqFOLuS;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774035534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mDmT/d4gU/ujLRxYybjgEyO5KzFd3992QKL3dwN7te4=;
	b=7IMQ4AJM+8q73kPLDfI2DbUP/DveMzQ1EfXYLwmV0oZdRZHavZ22zyouMfoAPXduguFVxr
	wAehZZofAedQKvkGKt/ThQh4AJbw9rPamJzmSs080hM+dRB4KZwPII4p1WL+nep5BNbtne
	e7jf+xeINpeobp6/53qrXlAoNrLUzSo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=liqFOLuS;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774035534; a=rsa-sha256;
	cv=none;
	b=41ZYBxi6ajOkICs7LIVPeCNsBCh3rAL0ubXJN8JjCttJAovUWPLtkOGaB/U4gvnTaftdok
	v0Xd4iDeXniqBY8HRsQvX0vKPRU9q82u2eJJokPm6r+85NXKOQsdme7cA8DuQyiudt1cre
	j4gvsxHrEzHZ8665ynytukV7MwLAHo8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B68AC401F5;
	Fri, 20 Mar 2026 19:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B32C2BCB0;
	Fri, 20 Mar 2026 19:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774035533;
	bh=PvxeCoUH6mYcAW+t825wYCo2q3PVvHiBg5/Yn7CCaIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=liqFOLuSKA9Wc9gTQOMeY6jA3+GN7oM4ESZtfQ3WaIml/s9yeaVEFKKgeEdILjfHw
	 6ZSFZZkdExG3YmcOnJmcxHfOb8dwWPPdm2Kius2AZPeeLOtScCYWy92jmr0lpis+1p
	 ObjYYywPs0TKvgjLKhcxbeMtroVdrdrR4W1KbrQVUwrUoR5d53labAWfWzlmljvzFY
	 4OqfQVhaFctQPOcm+41zXUXSx+ztfgGsTqUZ33MMm1/40NVD0waoy99ETjRoFTIObP
	 /LyUn+4yOqna5Pol7EibTuGDNg5m3J7Ar6Z7GuhdtSF2kWO1D+tnk/2hGZh/+Y0PSx
	 6QnH4WE044V1w==
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
Subject: [PATCH v4 03/25] mm/vma: add further vma_flags_t unions
Date: Fri, 20 Mar 2026 19:38:20 +0000
Message-ID: <d507d542c089ba132e9da53f2ff7f80ca117c3b4.1774034900.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774034900.git.ljs@kernel.org>
References: <cover.1774034900.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A3252C000B
X-Stat-Signature: 4enynru5xgoit9dhh5hi7dg7319bofyb
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774035534-536613
X-HE-Meta: U2FsdGVkX19dPP5t0e1FbvkWGLLrtwnFBWYv0JZd+K0pVjxXCQIkrJXxQbzmeRNw7agNQhSrzyuEimJ3OubU3Kn8yrg8zFwVxrvfg17jUKbpM4FJChQp3lmOqVl99w4ziaGQ4oBR82E5g9eGFyypKmMa6+eGTTgvaiUI2H46ka1ErkolCnHBTHlzBGWKt5IwG6UZI/IFAor0HNEwUfj735OsDQ2B9ERPyplcL+xQPOS3ABIoPgHQIGTTujU9lXVMS26gyaVtBtG7J0EM+7Bu9omu6Y534NbGpSnhSlJ1WGImPs2cmgZR5uVJE5PO058cWEw4mpNpcdg5DPxbSE9PLJrWqO58nELOiH5hu7OJCFPup1fqcK9lPT6j3/tx0lAJWXCLtxHo4VEfCugMbL1ewcDTBs+JCrDeRXhq0HJTuyH5iIWS63DSam5FMTlVC60bU36LzV1Ir+YUKLBqebouTLu0VA0y7uENqpqQd9DPNC5ZyZl4KC11mbzkcR8KSuucm4Jmy0wcL1l81GCKCx6URIe7kdkeTCJ+Yer86SBrkYOP2oSyG5y7QrAxL9MduEVUC4jd/u63qcZ9ifQ/37tGSMnKAT62eP7/b98V5UNef48J/s9iBefUim0aoHsn3tbu8NGupDXlP1cExbj7odyfw/oIIhNsNZTJyb+AeVXNVoDW8wmsg0o3o6DcjIwJS6m+y88VGyrCPljOtZPpufXp8clKBPRusMRujzod8lACh3UQprbrs1TBenFNW7i31efdUYbAO1w9jPHyhfpBL1jTHbpbLfn4dB/LtZk4cdQ9TT7HSBGrPFY2G0c+9cqSbvKycfGEXFHWqqY8kwPe3UZWEG7jKU2RXut29C2iJtSRuXu0rW3xJPW8dSl283dumQYxWFR2BtK6u/8li9Oh/u8P1x+0FfsRQKZ46+yHHHlByJqfft/W5JEGpXXhU+2gZqWcj7kYeCI4xc3QtQz6lGQ
 sFliO1jj
 4XEKh51tT9lbsZvQkSnGNY9OtQ7a4keryArcohVknT7IwsTbiwV2s4D6a6tNmlVtVD6dXiAQkU8vggzHPKJFzJ/FM1lcb/nEh9eBpKT2+6WBP4yCTsGomDoJ4bMg/6QFCMcNec3PoCBwN4nZ0NRmeVYGMatgZ+abhYiWeUKw9IaxtGiwINf0PxqLq23pCOsGSC7Me+uxamOoLvptE0137PJC14bnSgzaaO7SapwWL7X1x0iluVrhxTl7JuBU61khOA6mn8Xqun0lOHbhWCgnqwOEfsrt8fqJRiJbMXzR4BLgLlnzReyLnwB/7ypjaCu8WIddkcWwS4ZQbK6FIrLCkCkqi6WSvK59ircIU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to utilise the new vma_flags_t type, we currently place it in
union with legacy vm_flags fields of type vm_flags_t to make the
transition smoother.

Add vma_flags_t union entries for mm->def_flags and vmg->vm_flags -
mm->def_vma_flags and vmg->vma_flags respectively.

Once the conversion is complete, these will be replaced with vma_flags_t
entries alone.

Also update the VMA tests to reflect the change.

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/mm_types.h        | 6 +++++-
 mm/vma.h                        | 6 +++++-
 tools/testing/vma/include/dup.h | 5 ++++-
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 5584a0c7bcea..47d64057b74c 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1262,7 +1262,11 @@ struct mm_struct {
 		unsigned long data_vm;	   /* VM_WRITE & ~VM_SHARED & ~VM_STACK */
 		unsigned long exec_vm;	   /* VM_EXEC & ~VM_WRITE & ~VM_STACK */
 		unsigned long stack_vm;	   /* VM_STACK */
-		vm_flags_t def_flags;
+		union {
+			/* Temporary while VMA flags are being converted. */
+			vm_flags_t def_flags;
+			vma_flags_t def_vma_flags;
+		};
 
 		/**
 		 * @write_protect_seq: Locked when any thread is write
diff --git a/mm/vma.h b/mm/vma.h
index eba388c61ef4..cf8926558bf6 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -98,7 +98,11 @@ struct vma_merge_struct {
 	unsigned long end;
 	pgoff_t pgoff;
 
-	vm_flags_t vm_flags;
+	union {
+		/* Temporary while VMA flags are being converted. */
+		vm_flags_t vm_flags;
+		vma_flags_t vma_flags;
+	};
 	struct file *file;
 	struct anon_vma *anon_vma;
 	struct mempolicy *policy;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 8091a5caaeb8..58e063b1ee27 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -33,7 +33,10 @@ struct mm_struct {
 	unsigned long exec_vm;	   /* VM_EXEC & ~VM_WRITE & ~VM_STACK */
 	unsigned long stack_vm;	   /* VM_STACK */
 
-	unsigned long def_flags;
+	union {
+		vm_flags_t def_flags;
+		vma_flags_t def_vma_flags;
+	};
 
 	mm_flags_t flags; /* Must use mm_flags_* helpers to access */
 };
-- 
2.53.0


