Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C5DCF506D0
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 13:09:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B32616B026C; Mon, 16 Mar 2026 09:09:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B14E06B026E; Mon, 16 Mar 2026 09:09:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A00936B026F; Mon, 16 Mar 2026 09:09:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8DF496B026C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:09:17 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 33134C136A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:09:17 +0000 (UTC)
X-FDA: 84551957154.03.A856A72
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 71AE51C000D
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:09:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hk4WTrBo;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773666555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+dO4mX80n5A/XtOUjUDPwEn3uKn4e5mOjIgZdU02nPo=;
	b=aWOiOfLh7KzBYjfbhXuX49ZeNhlIz5IkxiYKfoIwsReTDRG7/JGJUcvIBmTZwtYdIvi21W
	Fd625t3lyVQoor/PYvaGyfmYA2f7UtiADzR0fPKyr9Npz1bzzZr/0eMwxrF+x+CHay1tEi
	Igmags0ZxUOktmONktS8Cm7OLQJ8r3M=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hk4WTrBo;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773666555; a=rsa-sha256;
	cv=none;
	b=Tg1b9qcSrJIEyNZKkWaizrcBaAO2wJiFl/D0W/C0SkiyFX/nl+EKMu1Ur28vgKqTCTJzVp
	1D+eyjerA+xXoBKFpEbn6Vd0QKXhsOAIiKGxPmN7L974oOc9FwW/L7+iT30FUaDSJCyOi7
	mIwzqFLXt+9fXC+c+F5/jOLOGS20iJg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 87FD8438FE;
	Mon, 16 Mar 2026 13:09:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17E0C2BCB2;
	Mon, 16 Mar 2026 13:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773666554;
	bh=bbEhjgEqkd4dPM1XP+mWknexfvrvA44Gz/j1bC4Udqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hk4WTrBoPWOBisLqTaABf9fprbTvuJu/Ce8nfzyYRukSQ7cCNTw9jbplRWm+5ptKs
	 wRDV9EpK7zX6W187Q18m4r4W/fvBdSHHbvfyXUEYWIEQq5b2HABkd4R9mI1+zkQjDp
	 04H2T0NwBBwr/oK+x559mQRTMaugWTrORpGgLy2B7zM1M33rshsneJ/YQPtsNws255
	 aN/7Vr+NoO+o0qFIovTO8QzIrFgfQgIr9xylOgtxNyMEbumME14YoxQkHfWK+DrI3k
	 NUMXWGY2EXXXuknHM29ID1lox1bk0xSspJIU9KeGcEvkNQkoOWr+CvdRbrilZnPzgN
	 LrgcIxD6b2N2g==
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
Subject: [PATCH v2 07/23] mm/vma: add append_vma_flags() helper
Date: Mon, 16 Mar 2026 13:07:56 +0000
Message-ID: <756b9c46ee23e00c2fe64d453ff61dd3b98aa3fc.1773665966.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773665966.git.ljs@kernel.org>
References: <cover.1773665966.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 71AE51C000D
X-Rspamd-Server: rspam07
X-Stat-Signature: fhu63fy7uk18p8ua51jn5erjruen6t1m
X-Rspam-User: 
X-HE-Tag: 1773666555-622642
X-HE-Meta: U2FsdGVkX1/NidHcCNiVl8jrci/71d8+gOXfUKBBJK5+ONhPIkOTv6l2TGxzY7R19VOQeRkRJ1b9UvMVHUx7lRLb3q6p53u53XYUXKK3xpQB2SDbif35b8PMX8372MQEb9T5yypRBcag30PW8a6TjZulI1zbR7t8tOxSFrr2E/fso0kxFGM3FBHX6uXEnAbrCouY+mV/NuP9IFoag1cJU1TDA4YHN1whGJ1Yeu8MmNXCLtme0jxPcuOPp5JU421GMR30kSUPS7GUnqj6EepGc/oAS0u+Z3hY5+gLNCxMFZmfU1McSBO1FQJPeixGeFeCsZEme9QDbhqnWboXy8sfHRUu1rhMUTghkdTmA1V+C7NDSowbJyu17YpZhJjK4ntThb5l7LF5dBtoLo9Bt7D9GKzy4M7t40HuyXwqEmD7pQDgUKEhEEuxD+y1hiQL3Yk0VHJ6IxFiYXS1HSQHPYTlLlp3igSH/fZAY/zmQSOW0G/oiaxPwAGVFa+K+OqptCT28Kzg0soU1FKi3rmQ2kxem8Ute8kGkmP6oRnwkrVqxf4ScHUQQ8noNfvqkUSOGk9S8prAF5tC1v7U85l1lExNGfr/9tGPaSE5OiGs5AuxetBLT+bv5FtSMgyWCgz/BJbeEoWFvBeQGA87xjdZ8VvAGlMGWKRLeFawW8hVDN+jPHfA+o2lm/Zys3oLw1oThTJmb+lcjkx9g/tvULQw9+W2ogH8JKRuOTHe87BjQXjWU1ugKqBoxAS+yXYutrcEiyTiZrCERh+GoyFX9xg+kywcFfkanzK5AAQo+P773n4JjhcAZctOjp0pdijFD3xjNgXbSnQb8BZ32AJVAmOviF0bq0hPorw7/LIyI8jXcfG4x19FlK5jqg8WUIl2FXBfcpdogCQ2SbcQXE5HBjJ0CzeU6+gqflTauoqgFvfBf3GAWmsXGFpEctWzJLBBgBVTMLNUCtQaTXyze7RsuJ+o+rd
 KcvlZMKu
 eYqI//xs+pulzGdnUZ2NL+crX711CuEfOJ4jqFQMYKA82HghY7qvLeQGgDlg6u/ksQIeKoSiG4Bu8aICIZc1kMIIQr6phAniFnSHSkwtovBRVqrLhlz+qCyo4w8XiF6iNwSsb4X0IRtC8nyQn3vO9G8uSuZYcJ+lDh30v0j5A0xEzY5VbR7rojFMZqNYA5qVbbOpKMMR2Zon05GLjtA0dPAnt5pFb2Us/6xi/h7cytoAJQsuA2jK+uHcRzsQ1mbb2m+rhrN+z+9oLLWxbk4y2th9ZeNJu6Y0v2WFchFJWvhunA3r6XanqKlZsJsCZH9JY667odBUdZPrZop/efMA76TktzGRp2CliHWX2
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
index 64b9089a0018..cbdeb03ee7e5 100644
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


