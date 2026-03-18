Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BE24103E19F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 15:51:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FB966B028A; Wed, 18 Mar 2026 11:51:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AC1B6B028C; Wed, 18 Mar 2026 11:51:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C2706B028D; Wed, 18 Mar 2026 11:51:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 464C96B028A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:51:03 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F2B625B41A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:51:02 +0000 (UTC)
X-FDA: 84559622364.20.73A8B1D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 297B0180006
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:51:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BaDlG7Wv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773849061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RHWpk18D/S7RJcq3Z/KOxdrI452ISiLQvi7z7HX/uXM=;
	b=Jl0OjiQQpZA/WydpQHBlUgPxKBgP9IDfuBmh1dlDOh1lpsjJBlBUo+/8d8JVV2CTgH/od3
	UX5H8VqcWhdUtmzDiRooi4bdo3fvCiDHEEfPbtuAsvbrV7p+AOiTIQwiYXgDbRMDQMYpno
	8exGCAf53gTnavLi7xOKcHFxdefYpM4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BaDlG7Wv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773849061; a=rsa-sha256;
	cv=none;
	b=t+AzbX+0tpAsOGJT1LaDf0NAyOGxdJFnKQArSt5HF/vKxXQaWuWHD0Bx+/+M0Qzh1CvUNi
	UAeLqU6bhMB0qU3YiNZO63o8t+9k6anB2/anuUKjyxzn+iqf4x/7tmCIWOe9EIDQHBVtDC
	d5FRZ0jfgWI1cO0RtFQbfYnHMvEx7FE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 382C943E3B;
	Wed, 18 Mar 2026 15:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D464C2BCB8;
	Wed, 18 Mar 2026 15:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773849060;
	bh=SQJ+xaA6T7rtTDv5ZITRT2ozBtHnhjEavNkPFiCgolU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BaDlG7WvLYbHqQFCCsPUrdRfV1jR2o6D9cQ0UKImGdrMubiHL4dOxsg+8bbfsYg07
	 6TEjDQQx3NuPzrGuOOw7Kn8UUyy2NGH4AVYG5Dfqo0dHMQqaqG7vVPIDXVKmBJ8Ch5
	 NvEnv7lKruvRyYSaJ5XEKDm0soCP9ZVN3wcr0kmnL+b2JV6e4ofD4pkkUpS1CyE02A
	 NpAgclt3Xqp2/hey0cZEI4mzpivEWu1Ios5UpH7QnnWM2c/Zd/HpIXqoWHkrYO8xdL
	 Fp11AfrJsTAhnmsDT4h4P67l18xXuLAe2KybcfUaWyyX2LRSkZIQfbe3lePab/Hot2
	 5SGIiVtxomzJg==
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
Subject: [PATCH v3 07/23] mm/vma: add append_vma_flags() helper
Date: Wed, 18 Mar 2026 15:50:18 +0000
Message-ID: <868641e2dbf62e3e04108a0b8092df25c250e3b9.1773846935.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773846935.git.ljs@kernel.org>
References: <cover.1773846935.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 297B0180006
X-Stat-Signature: 34ifgr75z18kr18883fsdi9drroi3qz4
X-Rspam-User: 
X-HE-Tag: 1773849060-931084
X-HE-Meta: U2FsdGVkX1/9pVXeBbaGCtLcZ9TJhoUpIJdoWcvh82dwKkVOVzA73nQ4OydLR3XX+kuHYynuJDyVe5L7PBSrX/nm2gMrpL6oVKGHWP4bagRBCefu89Cssw5DcnL6Iw/NB+JCV8hIsKAX/kr36UY5d8auA9Bn/xVU5f4V89qPLXx/i3Mb5DXY/C9a7tfiOLF9xXnZrR75+tvWrcfR+RX/595HCkdOReaxiofN+jmbUQE4ub3F2Io9bYlnYD+kwDRkaTY5WOof/vXWGzqUwy3qjQBtfBgb2oYaYUhygVZeC2s7/ViBDJ6QUwO4JHaq1837MZQag9qO57XEq1cl3BLFdyE5gmCtyI1UXz+Q3LhkTCl+Vj14Pdrq4SsXDMQ1BzHO1eZeSPGi15T5ps0k+82jSAEgaqvogJsfFHFcljnjynaJjvIUTaXyaNnKSynGCW7iHQNWYD2YNdU9s2QFvLhbu3pR+9C3oQAF2DJRLTdgknU8TPSwWiCqznUtwj9W1/mwbuXBruxY1Va0q6UdjXQ73vyUyE9KQk/6Ke2r9tIkaSx3jT13Nkbwsn5/u8CHjrNcUVveKNG8AnCTJ6uMx1aqnrXrhYmu196A5qaP7s/2h1EcSH3sB7mQsejS+WTiQF9dCoZr8BK0/i98cRnkwK/FvGTnK0O3LVUuK9gJmWuo2U+iWijpdiFJnFT//IcRze05IKPm+V9LY0DCUMpPOUBTj4fnILOenbi8k6vyO6Myb02+4pteJMxZ17ITrMgeBD9IurIniWCmBPsXAGZU5MzAQUpHS4/fyvkscDVyr/DGD/ySQgL5APUpX17YBDCCK8DQeSMXjqI8hW1Xz3+g/3gJltmwfennmpn0voAeQxkzoh82w3hBoQY1Xcz9ljLBd9ZTxxyJYV9bB+0XhJ7/lfFLATcJ0ZXA3frKCRqkNy/WpJ/AbpsYtUyRFBKtd0T+mAJnCW9GEoTvzupzGGNzdCq
 9InHAx2w
 Qo3xaqi5h+RkqAvneLjuwFjDSC1zWyJQuPGZaYswuvMt2+JH2IG0l7x+uoZlts4Zelb5IYTC/TvZGYYz7l0bzbyfWM+sm8Su1Uzwiv7viS0Rcy5ahgLkmT6jIvohF9VCN+htENQn52+lXbpzWv6o5BoLsmn8I0JfIX72Ank00M8Y8Y9sskKbXB8V9BDJwMOaYr3dRJAubSwEAqSQulbWlojD/rJ5GBIO82OUqhlDLUzQwpJYATFbRTOBmTlzygiiC1LK0iqUaXjpURn30+DeOvZveILhSABRtBHjUk/oVwZ0FIts0RR5b+lmsKCQEMOr5jE/J1w3zA8Qrqrx/eoQWiP7ojVa9GXIqVZ6e
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


