Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E064A1099B3F
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:39:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF37E6B0163; Fri, 20 Mar 2026 15:39:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC9A16B0167; Fri, 20 Mar 2026 15:39:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1C946B016A; Fri, 20 Mar 2026 15:39:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BBB446B0163
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:39:05 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7888BC1941
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:39:05 +0000 (UTC)
X-FDA: 84567454650.20.A82817D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id A75ED14000E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:39:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TX9TqBiv;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774035543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DSr9YPtTBFmCcV3Iu6aATRNXdarTgI5pv1P0501wtPM=;
	b=QL92oJeQC3rhlUeT5D74FCrIxNa12Q3+GrKxm3VRnhaVDslA8lMQvy+5ONNLvnYXrlhf8Y
	x0JABdV8FYMNw2eWYwofzLSbquS3R+YA3r/faiBTIoac4SI8/4gtxWLuadzZXa5jkaBS0z
	Nn1KWdedAaG6V7qgs1TXzMsoo0FW5/o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TX9TqBiv;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774035543; a=rsa-sha256;
	cv=none;
	b=X4a+iFAXLHwMsgJWpeGCeAh8JiGWX+uVqb0n/B444iAXnF/nXoKwpcyBRRJCXktcLLpyqw
	WfcLe00k7KBDFZPfzkpLVLnelJpw9vEOTlye9rbWgBCz/fGCdsIhZdB9g5GYzyioKF6pVp
	RHk8+xHkT78E679MdAIrxrPwTuPQfF0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C01D0419CE;
	Fri, 20 Mar 2026 19:39:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3EBC4CEF7;
	Fri, 20 Mar 2026 19:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774035542;
	bh=cITTwW3KtjNI3MI2f1qiU0MXGmAz47+sw5hIa4ck1qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TX9TqBiv9cENPf+e1h/UWHy9x4ct4D/qEGGX4oOHx2bgG2GzAlngxHUa9MnlkWinH
	 g+zuP7nkWsANmyNcWEiactmB/P2AEvzfuLoewMrG1N6IxVjoHiZj+TM4exxBWkcClO
	 ZedxIYfLnHJGIdkEgHs+y/mCrk+k/8iyIOCUFWIn4dZkK9M4iGebSiqvUyDmgG00Pu
	 wIZaEyUEdesRoF/Wrag5Vyks71F8VboQcxXN3s+11g839Xq+8LQVeqmggg7EsQZCI0
	 Pw+oqvaTi2KZLK2ze4GF0iuQo4p7eAfFaafc26QBLYTXc5nCRa7+1Ckx/BN8K68TeT
	 PnPzPiaZVh2xw==
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
Subject: [PATCH v4 07/25] mm/vma: add append_vma_flags() helper
Date: Fri, 20 Mar 2026 19:38:24 +0000
Message-ID: <9f928cd4688270002f2c0c3777fcc9b49cc7a8ea.1774034900.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774034900.git.ljs@kernel.org>
References: <cover.1774034900.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A75ED14000E
X-Stat-Signature: fs1x94oqcaqy83bbepmm34aeaaocruqk
X-Rspam-User: 
X-HE-Tag: 1774035543-488721
X-HE-Meta: U2FsdGVkX1+571Bz0p3CH6r8QoiBjjHjKZztQ9xRXz/P7Ce50fLHZekYcC95Mqu9wD+QQgdzPa/ppw3thfseh4CVJeCRnaCxMeCElHZR5d9vsD3suAwsFg/EflHjn0Gr3pGwufszTCAzkzQ+GPJkqF5X8bbSm0EVP4gRK4J6BNExDF+VNSCTcM0807n/OkSO0pJIszvHNAg09KC0hnlgWDmdQNgNKcDAMGj/AFLrmteiljbvlW+QHvz418+dgpvz+Jpt0xdzCAUKAEx/Mnwn0ty0TQURGLUfXP6hnFh6Ee7bJyQvdDxCFekMN2FgfRjMPxnQkDgBwgmGtQDmbdcTESTd0DiIIfgREOLcm661YS18VjN+WmafkwKz9YrInzzGe9Jb+oI+ZgQ+24fYQpUz4dLPvod7OZ2jfS8DLJN4Cee02d+vIo6gMYrsR08g/GDP2Gf78oXlNYyCidUCXahLp5znXrQj3m7Zl7bC/kc8JdUlp1Vheu6KsAS1r0MgdhoSiJ2h7ApMY9cs8x+Vb7ry3YuXeR9mdf29rlKbdpGVaWk/gXPYdXQYhqR5vK9yIL+s8+/3z4f5sAnbc+9ioTbf4Zr0atuoppmHW55+yoK6pEFE+NeJHGDzuDHWwL23SzDvFrwfYnjB3gG0hpVjNKum91v/zunkcUdKYaQjj1VPD8/+LgAJXAcC8sln7ukBp1duSUFNZSxSLwyrWCZQBHIcmUvACoRqG6zn98biZ1HvL/UGG5+3VuzHqI9Kmn8SQmK6juEbps118qRpvlVBCUypZb3VoK8FHmOCqTgnHS+33J4RMuFO6z9cmk+oHmbp1Q1QGVofWj/jL7N0DV63sJG3t87w9HRxJ29uM8B9rjsFRUYMXjalQt05cXgLoATm83koO11CjZ1vmXgv0NrZkFh0fT9HrO/vYwRhXZhr0ffG0YkJGJrKPmkDxFt6gDs+WEk3ZxAeDLbQsM9EFmCEjL9
 lZsRM8io
 uzBRQjzuE5Bk95UR/o1hehqw77ZsJKd8OOn8htiYjRTGZVPLl/rCzb1+gx6ll0ueOuILqVY9kd59eRfi9xvO9NBeChtAcRJWID/ZBqKm2TwYi+qAlsABey70G6xg5YWTRVcYgU1WZCT+3I7gv5HCHUlCYqaJno+zRoCbghOwUo0AbFbZP/B+DhLscN6rwcJg1Y0KtHJFhBDsr0HCfXWJPkT7lR8wyenH5/FXmXSnToKDm7qXNF0Az/EqIYMJ+fnTPwKWF2iJyWEvW7NGi4uBQDCChRMdCHIPynj9v3Iaoq+A+gJDMeKLrXfcv5zTcRY6L0tzYNhZ3qO5nNf7KFVmbuL/c+DUPzeRCifOY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to be able to efficiently combine VMA flag masks with additional
VMA flag bits we need to extend the concept introduced in mk_vma_flags()
and __mk_vma_flags() by allowing the specification of a VMA flag mask to
append VMA flag bits to.

Update __mk_vma_flags() to allow for this and update mk_vma_flags()
accordingly, and also provide append_vma_flags() to allow for the caller
to specify which VMA flags mask to append to.

Finally, update the VMA flags tests to reflect the change.

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/mm.h              | 20 ++++++++++++++------
 tools/testing/vma/include/dup.h | 14 +++++++-------
 2 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index b75e089dfd65..0c35423177bf 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1047,13 +1047,11 @@ static __always_inline void vma_flags_set_flag(vma_flags_t *flags,
 	__set_bit((__force int)bit, bitmap);
 }
 
-static __always_inline vma_flags_t __mk_vma_flags(size_t count,
-		const vma_flag_t *bits)
+static __always_inline vma_flags_t __mk_vma_flags(vma_flags_t flags,
+		size_t count, const vma_flag_t *bits)
 {
-	vma_flags_t flags;
 	int i;
 
-	vma_flags_clear_all(&flags);
 	for (i = 0; i < count; i++)
 		vma_flags_set_flag(&flags, bits[i]);
 	return flags;
@@ -1069,8 +1067,18 @@ static __always_inline vma_flags_t __mk_vma_flags(size_t count,
  * The compiler cleverly optimises away all of the work and this ends up being
  * equivalent to aggregating the values manually.
  */
-#define mk_vma_flags(...) __mk_vma_flags(COUNT_ARGS(__VA_ARGS__), \
-					 (const vma_flag_t []){__VA_ARGS__})
+#define mk_vma_flags(...) __mk_vma_flags(EMPTY_VMA_FLAGS,			\
+		COUNT_ARGS(__VA_ARGS__), (const vma_flag_t []){__VA_ARGS__})
+
+/*
+ * Helper macro which acts like mk_vma_flags, only appending to a copy of the
+ * specified flags rather than establishing new flags. E.g.:
+ *
+ * vma_flags_t flags = append_vma_flags(VMA_STACK_DEFAULT_FLAGS, VMA_STACK_BIT,
+ *              VMA_ACCOUNT_BIT);
+ */
+#define append_vma_flags(flags, ...) __mk_vma_flags(flags,			\
+		COUNT_ARGS(__VA_ARGS__), (const vma_flag_t []){__VA_ARGS__})
 
 /*
  * Test whether a specific VMA flag is set, e.g.:
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 3005e33d1ede..a2f311b5ea82 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -854,21 +854,21 @@ static inline void vm_flags_clear(struct vm_area_struct *vma,
 	vma_flags_clear_word(&vma->flags, flags);
 }
 
-static __always_inline vma_flags_t __mk_vma_flags(size_t count,
-		const vma_flag_t *bits)
+static __always_inline vma_flags_t __mk_vma_flags(vma_flags_t flags,
+		size_t count, const vma_flag_t *bits)
 {
-	vma_flags_t flags;
 	int i;
 
-	vma_flags_clear_all(&flags);
 	for (i = 0; i < count; i++)
 		vma_flags_set_flag(&flags, bits[i]);
-
 	return flags;
 }
 
-#define mk_vma_flags(...) __mk_vma_flags(COUNT_ARGS(__VA_ARGS__),	\
-		(const vma_flag_t []){__VA_ARGS__})
+#define mk_vma_flags(...) __mk_vma_flags(EMPTY_VMA_FLAGS,			\
+		COUNT_ARGS(__VA_ARGS__), (const vma_flag_t []){__VA_ARGS__})
+
+#define append_vma_flags(flags, ...) __mk_vma_flags(flags,			\
+		COUNT_ARGS(__VA_ARGS__), (const vma_flag_t []){__VA_ARGS__})
 
 static __always_inline bool vma_flags_test(const vma_flags_t *flags,
 		vma_flag_t bit)
-- 
2.53.0


