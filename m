Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77B2FF506CC
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 13:09:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D21986B025E; Mon, 16 Mar 2026 09:09:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD9716B0260; Mon, 16 Mar 2026 09:09:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBAD76B0261; Mon, 16 Mar 2026 09:09:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A61766B025E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:09:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 56D2514026C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:09:05 +0000 (UTC)
X-FDA: 84551956650.05.BD9B754
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7C12110000A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:09:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="bZ/0Uom5";
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773666543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qFO98x0xjvDv2m172P8M+3+Va2AChNusVU0e+ehXkTk=;
	b=BOoU+knR4AmUu7d9PM7bFAkZZUrxMSrQxXgQzXXXfqwe+Yjl1ISvcIp6hKlG0ScJ77TRAz
	5RwDdG2Ra0O8Z+AgZuuynsBL3Jkn0CrNt6KMfsbbRsdh0RVjWlmgNAhbRzn0m0bQeWyoa+
	bML7u3v3dclYdr1ZRAApHz7RhG8l/Es=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="bZ/0Uom5";
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773666543; a=rsa-sha256;
	cv=none;
	b=qv8e9ioL0kgXcSms4yWN3DX1+kUvij0WbvDnqA7PB8EOC9Q7alzpKIEADdOTlaigbslSoK
	u95wmONowb+3ioFNvV0Y0m4OrUxKxQpe8N5P4VCtnwPdmRZ0KRJYQ84nof4K2o2ptpzcXC
	MIkJFz0/XJqECWSIJ2iPMwQvRkXN9Ms=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 91483438FE;
	Mon, 16 Mar 2026 13:09:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0DDC19425;
	Mon, 16 Mar 2026 13:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773666542;
	bh=2bgwsSAPZtKZ4SCtldRI7sINolEwa6xcZ3YIHjNJ4Zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bZ/0Uom5mgBQr1HgT+j40FYVRLhBQ0ojMjIytJU82DHtW+o9EqipX1MEMhvG0F9np
	 GF/Fs+2339hQWZx6ny71PjOl/3BZ9+oTiX0gHJkITvA2xFvTF5rWvO4DrpfcEGTP+S
	 0/8JIeNX/fbRbVoF9uMT79o0Ewtw/LJhYOM1Gd+q1Y0dB8a3F1zPh/tYb9hRTjFkiP
	 i7kLfqzmPA1xC7IgrzCgn48y1T9L3y3d3W3C8h9d5dZbryzynLkrwwobkjPLcqQDLc
	 92VXTBBcblJ2zMJWDy5yIr0JdLxBHfDsm5vU98N6BK/1bx0JuLHMNWrtGIvX5xiAL7
	 HPGXHogrINxmA==
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
Subject: [PATCH v2 03/23] mm/vma: add further vma_flags_t unions
Date: Mon, 16 Mar 2026 13:07:52 +0000
Message-ID: <a37030f2eefc90147e84f9273e325cc289cb9e1d.1773665966.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773665966.git.ljs@kernel.org>
References: <cover.1773665966.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7C12110000A
X-Rspamd-Server: rspam07
X-Stat-Signature: zxn4qjfy49dpbpcnh4epeuit7fbpzonu
X-Rspam-User: 
X-HE-Tag: 1773666543-747513
X-HE-Meta: U2FsdGVkX1/a/AiXImd7BRrwmwdugMlgc6qRCfkv4M6SUhdPZ36O4cv7nER6jVTK4EU8by5PQULL50hQa3cOEIdQpWoDzU/0e1hKDqJAcx2BE3/H3FNEYvl5SGWkKPn0lFXfZ6ExHQ4Ev1v60mw1xAMzg+ymB2V22K7nzn4LTV20fkdufDTrhuLLYS+u7HPt8GtmsP4x1n63udu43OYqsClx7dSyCNZ7QXqKTgqiURxE5cfsndqmu8vjAQWIsZFf9BB5N1HFZZdqQCZsMeYsYh3jv4q5uZ9CLiEp8R25ZLYF3doKGEoQyBHdOKdY02iEUoCDThzI65BeAie3hiagr+o7sHtxbFb9MItxuATg/XpfjgrmfET3CZ9y17EdOle06F6RwYM68E5Ej6Nuh8Y7VPbEKURyzqRGNRLiocGbCBWSrDyYXj0qE/r4Jl3Ugfb/wE+2H48zWCOJid82T+/X2iJyAkHGgReNCDRCh3vtvbhH39tDA8snO1/xhafLA82SkTunoS9nKkSEKK7NxpGaStkcLeGxm0lAfi5R3AaZS665keXWuRl7rbYujUqVUIQGewk3P7bJInG33AGSRWSo9peUq2AiGSVkMbDVzWJIzqxRy7WlpY1ZqvuqWdRIJpj3edWZ/79msDS7wfD3Hw1iuObFlfJrOPtrB9PFL0/EycJeyg79uPGSQAcDEpl9WfrDp5/iVPoQ8cHNhw4E8G0Lj4iCdqfeD5jZzmMh9kwLC0GTIoFhk7GegNAnca5fUXXwSZJZ+MlMFe0+77JdJPkh2+0D0yNCqOqvoJL4269Deo0Hp4k0c4zhjfJR8LYLfsqnQk2lqgivsfBRJKLemM8zaIbHks0Z5wvYQnxHtD5GB/cgsHgcRLJ1VAVE9wdo9XBrN+zKf0LnYDq+9G4kblKa/5fFbyb5Qlmn+HWZ3zZoxbPEMdEQvY+xJl/GcZxSDbGoGufDfz3ASfFNs/64Rk9
 qolQ7ECq
 h6N91eEiKctVspb+0RlGXnMAl892CpbB3x0x0+STbRP/KqOUHA4LG/eMAcDObeG3QbcbjMrwBfMAREC6ApaMvMwd2qCKaleT45HyPVcLueEXznadtxGvyrV2DcqJpDrqNpk5ubbsB+WBap24lH58ilrEDwzLVz4gzIzGpWvhwnwM6ICyhfe9m6MAkV7lMyaO/IWwAJJ3FczZiaEItvrGw520qF/hoOk4IQSgTBHFZpd+KEG6W31u9AiU92Jy3gP3Vs8rM+eggrLTyS3Q1WeGPgq6l8TcRYH6HOoyRUA13F9HSxM0ABbN65/Y6Fs017s7pCn4RWjMC1WiNCyBCnf7/95jdXuJJ7CW7nL7K
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
index 13c03bf247bc..e1ec818de239 100644
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


