Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F334106ACDD
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 19:16:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC4BF6B008C; Thu, 12 Mar 2026 15:16:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8EB56B0092; Thu, 12 Mar 2026 15:16:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B473E6B0093; Thu, 12 Mar 2026 15:16:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A76B16B008C
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:16:44 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 72FDB140309
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:16:44 +0000 (UTC)
X-FDA: 84538367928.21.2492839
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id B57402000E
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:16:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mD8due7j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773343002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EyNOJRFBn6GYecjz/uIi6J1r7bpamrPl/8rZmvXcRyc=;
	b=tynRnLfLFWko1s98ySEUpDku+obe+TpO3O711TgaWJ8uKA9bsLolmaniLyU5+lvSBvcgNZ
	eV6QIbd/ISjT02XZuI6QX3WWhkcX/0iyL+FgZcYyiHY4qT9GMvaXsnbKKloWmyxFf9Yh71
	mroC5Elgd8NkYAyVQXAlOK6Q4rS+IoA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773343002; a=rsa-sha256;
	cv=none;
	b=XP705wKWB9A5d0QyA3DJjAuVJ2vfWz/Z/XX2VIZjXOr/QDEJNGgNcljp4yR6QdZWSXJJhY
	Rxsljxgqgrc7uB61iLLLHeq3HXvZ5tLcSgyfiFPXUXCbrOfm2OTpOHOb9nul9FxOH94DFO
	AqkxbZHqT3emSEaqAVg/dEhqyiRZRq4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mD8due7j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C91E944504;
	Thu, 12 Mar 2026 19:16:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E70C2BC86;
	Thu, 12 Mar 2026 19:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773343001;
	bh=bmvUDjwEogjDbOSJi1Au4cu8FeNepAROkOURcG3tLdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mD8due7j6LcH1JQ77FvTm2O64To7W0qOMNPmhfFPikEgImXxT3veeh3L41ScCRDBh
	 hmg4qqqniVoHcKkT7m8O5H+mumGm8N4zmYge7Opsa8Ce/9GDHTedwhM9/CUSKMWgwY
	 IU6e/CBYw2NRKVOVFqQ2bgGlpInKV5G+fS4rkhtPIgTgj/deO9vmVz7mlvAjgVC+y0
	 7ims1tNWR6jHJF5nM+CJQxylOO6k9izJWD84PHMXlW2lamVOJSdsyjSiiiJAPNBn3k
	 Gtips/dqUFGzguPMfBbLSaJzhO9FYdS+kBwGG+aI/v6lVZ5+gEbRp5AK402grOd7TP
	 H8o+1/QbaQGqw==
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
Subject: [PATCH 03/20] mm/vma: add further vma_flags_t unions
Date: Thu, 12 Mar 2026 19:16:01 +0000
Message-ID: <cd3f6777c6a11a425ce5e249a5d315448e954b46.1773342102.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773342102.git.ljs@kernel.org>
References: <cover.1773342102.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B57402000E
X-Stat-Signature: pi4j5joz1sjocse8a7x1uzk63j5cb4a8
X-Rspam-User: 
X-HE-Tag: 1773343002-219708
X-HE-Meta: U2FsdGVkX1+ydrejmjfMls//ScLeLvAwZGOhSZCY4PObdg0t+1TLhjjEqcH4ZL8ta6noE1kp5dGJPIzbbtYCT1+6VywzlYJpzUIOgZ7hn414xKigy+y5gircXSO4c/mtB7+0QqMeRTeaBU7PHXyNlFwhZzUJajy09nyVnTtHBnoWcNlkZdlaZ5AFGHXppHa2MKr3r/BvyEtoVWqSMlal4II5SKOrBdNsRlideox6Wu3imn/ADGc9ybAdFCgnJEpWgkzFdOxP1k9fz4RTAPjxWfwDFhSt6QEXadmlk4AHzMujzgIA+hTPvG9sbeGLDnGGw9OzQe+XkdDGwr6erVzTkbH4eELMUobHI0h8X+hN6P+Ha+dC3Dq3qIx+KDCBmpbfCPsMjU6n1m/LmGrC4TiXiipji33pxpJB9YFH7ZJvosHRYy6kw8XMxQxb2nfL2EVL0tBVqvcArQnVhRpoRfXUcV3FgY1fIlV/HhlwuEaWpL5m0yxqt2nK2UYpx8TUJ9FrOkHFsGbiuaeYY9MONL9pSpvXpkA5zG/MJex2dxFaGHO0MpXJtE7WWsOX0zDvl2QDJuNewFs+hMTr7EK1r7mj2Q/NNyncEV52wdFK3Np8mFy+AFQXuMaFzwM4XszEeeNPITv5siHAtCSIKyXdSPAECRZQ2TsUiCfJTDCQ6mNf70fRG/XxFRZjeapFCu8/OMDBzSJJO4vKQS7CI8YfvNC+JIycTiepPBDBk8Nk51senVpAyCwek3/SUjFQpfPwdoTY78TrYNKrE/EFxbX5GdBce37SlVEhTf/yxVEgea6WfYnPvdeoQ8jjZh/NP21DVO9qbrW+++Vp3eqAccdQgJwCGgFWGDJNFOaeR9tBQk80jxb+6iEYIjd7TffATN7b79PmJie6jxw1a/tiiB/UFpyGSTewisCHMknSBvaBImZbA7hkjrmwRONaHU+3gdqI6PJVP3iZB1inySb+MD1U7XC
 oCL9wR1n
 NMj69GdSFQFp5KetxHsC0qz++XLBghOeRezXjWyVnZE1U5wUDRtk2YTefaFw1nexxfE5uFgNCUbJsiecUb2ttxcvHndzBkoq8HNchjTLN4kfF929Y3ghxrfH8v2w9lb3etKzduxIBck2HnHWNTLi8c9zFdy5xL7DjEnmugpgiDsZEDDXBNBNQGI80BxjcspUYIyJYIQ5xwat5QBBSjNcVLRqK6rFMZuGpZap26T4YwsQooNQbfWw7sYkk+F7H15wfOjAOqLLW7rUN52dfFA7y7gxIifgEOBLxivCondx+QufuNZ4ehskyPE9XCa9N/g+g2lrGySeJtAQSaJd+jDw+iJxlJhN14rO0yaLL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to utilise the new vma_flags_t type, we currently place it in
union with legacy vm_flags fields of type vm_flags_t to make the transition
smoother.

Add vma_flags_t union entries for mm->def_flags and vmg->vm_flags -
mm->def_vma_flags and vmg->vma_flags respectively.

Once the conversion is complete, these will be replaced with vma_flags_t
entries alone.

Also update the VMA tests to reflect the change.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/mm_types.h        | 6 +++++-
 mm/vma.h                        | 6 +++++-
 tools/testing/vma/include/dup.h | 5 ++++-
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index ad414ff2d815..ea76821c01e3 100644
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
index 2f53c27ddb21..faaf1239123d 100644
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


