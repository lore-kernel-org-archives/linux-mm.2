Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5069B106ACE1
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 19:16:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 850956B0096; Thu, 12 Mar 2026 15:16:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 742A36B0098; Thu, 12 Mar 2026 15:16:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EFFA6B0099; Thu, 12 Mar 2026 15:16:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4F3DE6B0096
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:16:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1C5DD1A0340
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:16:54 +0000 (UTC)
X-FDA: 84538368348.19.588878F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 64053180007
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:16:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n6fR6eUA;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773343012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yZD9sqfvtvuOO7fq2K/BG2mYlq6hr+aFR1YF4JgwAOw=;
	b=V5duFGYXzypGdCPx6+hYtKJxhS6sncgfrXE/7YUsXahn3/QMdTjk7rnfaxhUayEn2Zw4/q
	jx5WbgOPLqLyWUMSZMvQens7K6WSS0vcoQgVKBQA3buHsEyLA6LYq7VIvGKEuyzRtVwySX
	IVEz4syMgbSOtKEnFpdFOf57MfrPj2U=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n6fR6eUA;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773343012; a=rsa-sha256;
	cv=none;
	b=giqUolPGP7wD6KswAnXs6VLsEs8lENxlvSt1bdjb+8tG4M9puzCMELfeCTe5UPBXAa5YmQ
	R2ZJgd4iibd5eib4rOzsrNGhIdvthSyAm1e7oRr366TC+TCYVTk64PDGPQvoGXX6b/z1Cl
	gZNBWaBFAKuQm1tGoAQ7wWTzYw7kDSQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6CC1344510;
	Thu, 12 Mar 2026 19:16:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBAD4C2BC9E;
	Thu, 12 Mar 2026 19:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773343011;
	bh=PE+79SwCD7fosJSOIvbwHAGwcb45uOKMid7HM/Dh6oA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n6fR6eUA63QunMsWSIzaCYe33LTDMFRPvmipbF6v7wSIJDBNz39ISBMVua7R1BfsU
	 1qo+hM8zksLXKVnZQ5CLvTGbUQNdXU3bhcnlDpA8pmrz/6uCgyScdnOX3xDONteP+6
	 MHR4uV/zQUxbOqm2DLyTW6Ye/fmaOPuLycSRro9LB5UCF+JH7y8RYU2y1uefPZ8XYX
	 M4qp20x+mPsix0yLfdfMRsVEvhAr7vxwh8tJb0a/mFM1R6LI55h0L5+ebOpgpBa16H
	 hzuYVSX8BmNoyD+DxUAQp+H9fAL0q7eUBcKXaBeworsh1q9l3X6DJihddMUvZAJ+yc
	 7IgDFGxav0bbg==
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
Subject: [PATCH 07/20] mm/vma: add append_vma_flags() helper
Date: Thu, 12 Mar 2026 19:16:05 +0000
Message-ID: <eea579f943910c6d41dc6c0cadc33ea3b9b9c89e.1773342102.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773342102.git.ljs@kernel.org>
References: <cover.1773342102.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 64053180007
X-Rspamd-Server: rspam08
X-Stat-Signature: fc9ewf4brn5uohsmfwzhbp3c3jpoj383
X-HE-Tag: 1773343012-390139
X-HE-Meta: U2FsdGVkX19Q/syutrV/tb5W8k2Sr/Xz7izEA+Jk8vgw9ycpFRvIUwKqfoLfMqF53adhQDB7tui2SP7jKhsuUqX0tyxMSmWEIFfd7dmiQn/hABuXkZYPEM6TXo/wElZx+k9BXu1Fn50IV2ecSsoNZkzuMy9EOGgPN47mzwrH+VbW0IIWy6ECNm65VgOwKp0qV5EYcjaCg1R4TQo4ndhUKImV678mtp5bwgw9jTmYfJ187AvNPt5wELx50hyPnN4BphWLsvP9Kj+SenNZTENn+4pKWAgBcvFzem353TUVn6gUH1AqDFToYPJcJpHjpMtKK3ozX9/P6PppEQUtWRMUqRwYTEfX3E89e4J8c8krwkDS1pY2weDDV8dJ/uuDitmb8+k0g0yevqO3Sox7Vxjc2hzQSSGRtWNsILHLlSbgsFe8b9zEL/ITTydAUaIKEwlZE18IUP2KpEV3q235B+sESSV/24fYfdd/5lTd5yXKaz2xfN++pUE+hO9SSznFSGs5ukiK//6YCy5YQdYHQxUwoPBqU1VwyI8sgNAXdO2DllY4NlKlTtThn7fO1iALz2gP+9npaza0GDq8dF4ijhpFRQZC7335q+Pe9PW2u4twtuUQHV59OasHd9o29XkxtNtsXeBgHb0VlMHO84dYm5KbXuzOsK78eTHRC0CPTGCwpQqXGXY7R0JaNn5xBBbqesSmJA2dMsvEQTNwjCSlDNngnd/X5x45Ku0pMN4zt2vmqUry4qz8+Yvxafu3zjn2lAxoiIYhoCkbz+bs8UM+wytsjvgs3VqG2K6vgHlPRbr7H/jFGXYSNo26BppDXmosjHsfqJYO+2LKWlrk13vgX++S3vcKnZAfrUz/5ncpfaKglLAnHK9sViTxUtSPfHxPblIebCagoImRBpDqYRZnmhDHfWAVrHqk0dNkMGdR1r3+NsmvKGzGsDxTIxm4QeAHK072/olXwTJwKeRpESRpLyw
 zBJMOY2t
 nxAY2qfoK3KMH3zHVvT3QNSrUwEmF07uowZZj0M+xYxSWyrYra1k7G2X6xxGuvMOT90Hu066L2xS2QkJhmtIgyPov9bnoItvJnAmGvEuxj0ifp3KyqDgp/Rbhqhxxfhfs2wRSDGcGLtNybNcye2zXZNLowa66xGADnTO7PLnNfktm8kWqYtRYmnm6t/N0TFBeaQoKh8OrqrJOo36F1nAaiOuTNzVurZQjZ27qK7S782DcgMVHbLfIWXFSJuzD2K0KlBdkaH1mDdwE8MDWKosm/VjVkeoWxdZf5dYVmQHyOa5gyA2cEVrwQHrha01WodB8iIkz+9nnfxj0yC+KT0oPWUIXeXzPe9woO7XF
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
accordingly, and also provide append_vma_flags() to allow for the caller to
specify which VMA flags mask to append to.

Finally, update the VMA flags tests to reflect the change.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/mm.h              | 20 ++++++++++++++------
 tools/testing/vma/include/dup.h | 14 +++++++-------
 2 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7acd2f0237eb..5a287e58c1e6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1049,13 +1049,11 @@ static __always_inline void vma_flags_set_flag(vma_flags_t *flags,
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
@@ -1071,8 +1069,18 @@ static __always_inline vma_flags_t __mk_vma_flags(size_t count,
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
index 29ff6c97f37a..0d75ac23ac4d 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -851,21 +851,21 @@ static inline void vm_flags_clear(struct vm_area_struct *vma,
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


