Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B647103E19F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 15:51:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A09FF6B0290; Wed, 18 Mar 2026 11:51:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E0DC6B0292; Wed, 18 Mar 2026 11:51:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F6B66B0293; Wed, 18 Mar 2026 11:51:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D5816B0290
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:51:11 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 47EA11A0864
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:51:11 +0000 (UTC)
X-FDA: 84559622742.14.2FE6AE8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id AF9F5C0004
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:51:09 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rmU8NO6l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773849069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YPXp+xUw+qiLA4n8LAet54qmXzrkhyXPlTkMGV//3zM=;
	b=8qeI2sTzg06JqIVjLSOKmt7Th3NFCxu/a9IGOyHHIcsPkT3AFacO7xFarDVZzp02dbJyzU
	8gnVLt0QLhfwf/6TXLge9POSKDv4zd8SOrJt1aeGdlqWjjx/EsNGfP3qbfanm0M+skRPl6
	wqOyTRuYtSmyR4++I0cy9sYpiSJ3hoc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773849069; a=rsa-sha256;
	cv=none;
	b=YtynpNaIjtW08EzBy2wT9hWQQtl9UCQc75QYLtxDHGPj0Cg4ano5pe1ylXnGgTFX8H3BQ0
	aIlTiqvg4oaP58uGyR9LDFkDCGw3DjzjCaZ/4+0c6wnc4R11JTDg9zQa7F16cumF/O71a/
	eGOuLZKRGRAxGixfsC7AL8D0IRXPzyk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rmU8NO6l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3574560123;
	Wed, 18 Mar 2026 15:51:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF68C2BCB1;
	Wed, 18 Mar 2026 15:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773849068;
	bh=8XdVGVcW7Q/NIDMCLqZpb+/JQ5inTXzEVPggkjMwfDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rmU8NO6lu68m7dsZm627W2f/PRCpD8agMZwIp+xMIgX3czLSrnNm8zNu3djfRt6xe
	 K7LKrCAiyXun/G+k/XcklluBNhmNgw58TR7VtJEgPXQ0NShUpCjteDW7+kNP25/+sY
	 9Ai7sjoZ1e4/pEsOVNxeuqeSz8JqvGhpTpWpoBfF/kvsWoRc6/xHf4WA4Rk7XFSeIS
	 F3HzRFhNHylMgXuj29cO/H96cAW9cNDQ2yLiWwgiZPsIYY04EPSlgQT3IiNmYdUhMK
	 OtLdkgTgXSMcLSR4tbu8hdjfRD/kZ0UuCJlTEU7HgVskr1JVtwqQK4Lq8IG47CskcN
	 m1/8kOa7UNNvw==
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
Subject: [PATCH v3 10/23] mm/vma: introduce vma_flags_same[_mask/_pair]()
Date: Wed, 18 Mar 2026 15:50:21 +0000
Message-ID: <028d03f1b980b7f65fcc556db2e97224c06af1a6.1773846935.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773846935.git.ljs@kernel.org>
References: <cover.1773846935.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AF9F5C0004
X-Stat-Signature: 4m6b1cizpzewibw39a6itn96brrqok3o
X-Rspam-User: 
X-HE-Tag: 1773849069-623594
X-HE-Meta: U2FsdGVkX1/E5PvODt2kHJ3/fOoDmxLOJdUsW2u0NQsBoXgYHzdfz3vkbTYhfspBMuQsqq8Qv5b8Bd4Ff5sEVYEWbmGgkXr3HE9GufS4R7upYjCMwsTTb+skPqxkbfSQWh0YgqAe5vM3K/VoQyh8JzKhvM9e4s7Tk2GQB6KSPh24H4i15wuQI7IgeU1nBk6rfmpADLyifKLYtcDsYz5WHzZLXQwOPNl4hbHmplrEWB1/SIHO1ZIkA3bW4fCNVqgA+5s35YNrt3D9mU90xR9CdqpVhN1CYLYRvSwpQ9NmKsgoniOtaErvZLTunqcW6m0lHOrgmveU4Yz4M2YQD6Uu1oRO31X2N0UIQip21S9cpIlWkPFVRBXJLFvEjJRulQwkShcT8hrmTzF44eV+i6oD+DYfjsM7BwLVE2LsZux+kPmV9tDYceChvKKzVdP3chPdZWqerHzpfFZpFMDdjlydlfFnTokQrwKQy3xGJeyNtfFJHzvdkROjC1o4RodBxt8Lp6o37FpHjP4MoBPFhj8P8T3LLpWswQP2hRrF8dPPuyG0gOBtfFBc6QNAHVb3sElhPZpgq5J8xEFKeu2PjFtLt0fkHXh4F+fOlfT/e++3UObByWaX1u/0sn9yYqd/gC+2Ye12XUxgg3q/JjJz29Z8qbWK4PK3hEWiX1KourpZ9ovJ/zc2h/HsMQDvSda5WzraH9EwUG2y7ok+I5BVI8a0lAsE/78XeP7bJC+IPt6aLyxtSqkbgE4HaQtE7ag4+21pzeS/Rt6RPBeWToglLGDm3eVVWVjjDzv9JnSS0LX78L1QcXFwppn+pp/wd8Gu4lwLJpttmSxX330vpIhHwhVpTSuqduiWqIMNZgPfGqAl3Ki8IIx8cwCGftBHIhYtfSCZ555pRBjUqB2GUfH+AV42/Z/RHz9yAkE2qczlqrBGbYvn94utSCx2r84fgNZZXziLofGk23ZhS0hcJQaw5zw
 w92QnHU2
 wH9ouVx4/XDXjLuGmiMHUkJSzxwcdNBvNkIEo6J4QZxbM+zQIQrMEJbWXnZW5PcyJqQ1+GW1VT6bqy2kSPYbRSXBb5HGX1HokQJ5jTDlSxZ3w1XKOr+Y5Zp9/JI/ctC8covTDtNJm0In0NP8YBxh1BmRHQdgk9K2PE4xa1GPTMo/L7rTrBfgSVcz+tBbfit75wI1gXS05Jcq1MPPxn97ubQx2W/Ihk9C3nSBssa4lR6f69y0LAZYIyNcfQ7gvegOSR9kuboOWeBTpIjE3/knfyBprnem7BrKq7koyJd/qEjz4+nWSqIj6HyjAl6BYG+74+HARJhb6o2MP3olBLx/8tAgYu3CSx/O7L40q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add helpers to determine if two sets of VMA flags are precisely the same,
that is - that every flag set one is set in another, and neither contain
any flags not set in the other.

We also introduce vma_flags_same_pair() for cases where we want to compare
two sets of VMA flags which are both non-const values.

Also update the VMA tests to reflect the change, we already implicitly
test that this functions correctly having used it for testing purposes
previously.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/mm.h                 | 28 ++++++++++++++++++++++++++++
 tools/testing/vma/include/custom.h | 11 -----------
 tools/testing/vma/include/dup.h    | 21 +++++++++++++++++++++
 3 files changed, 49 insertions(+), 11 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 42d346684678..b170cee95e25 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1207,6 +1207,34 @@ static __always_inline vma_flags_t vma_flags_diff_pair(const vma_flags_t *flags,
 	return dst;
 }
 
+/* Determine if flags and flags_other have precisely the same flags set. */
+static __always_inline bool vma_flags_same_pair(const vma_flags_t *flags,
+						const vma_flags_t *flags_other)
+{
+	const unsigned long *bitmap = flags->__vma_flags;
+	const unsigned long *bitmap_other = flags_other->__vma_flags;
+
+	return bitmap_equal(bitmap, bitmap_other, NUM_VMA_FLAG_BITS);
+}
+
+/* Determine if flags and flags_other have precisely the same flags set.  */
+static __always_inline bool vma_flags_same_mask(const vma_flags_t *flags,
+						vma_flags_t flags_other)
+{
+	const unsigned long *bitmap = flags->__vma_flags;
+	const unsigned long *bitmap_other = flags_other.__vma_flags;
+
+	return bitmap_equal(bitmap, bitmap_other, NUM_VMA_FLAG_BITS);
+}
+
+/*
+ * Helper macro to determine if only the specific flags are set, e.g.:
+ *
+ * if (vma_flags_same(&flags, VMA_WRITE_BIT) { ... }
+ */
+#define vma_flags_same(flags, ...) \
+	vma_flags_same_mask(flags, mk_vma_flags(__VA_ARGS__))
+
 /*
  * Helper to test that ALL specified flags are set in a VMA.
  *
diff --git a/tools/testing/vma/include/custom.h b/tools/testing/vma/include/custom.h
index 8f33df02816a..2c498e713fbd 100644
--- a/tools/testing/vma/include/custom.h
+++ b/tools/testing/vma/include/custom.h
@@ -102,16 +102,5 @@ static inline unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
 	return PAGE_SIZE;
 }
 
-/* Place here until needed in the kernel code. */
-static __always_inline bool vma_flags_same_mask(vma_flags_t *flags,
-						vma_flags_t flags_other)
-{
-	const unsigned long *bitmap = flags->__vma_flags;
-	const unsigned long *bitmap_other = flags_other.__vma_flags;
-
-	return bitmap_equal(bitmap, bitmap_other, NUM_VMA_FLAG_BITS);
-}
-#define vma_flags_same(flags, ...) \
-	vma_flags_same_mask(flags, mk_vma_flags(__VA_ARGS__))
 #define VMA_SPECIAL_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_DONTEXPAND_BIT, \
 				       VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 802b3d97b627..65f630923461 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -954,6 +954,27 @@ static __always_inline vma_flags_t vma_flags_diff_pair(const vma_flags_t *flags,
 	return dst;
 }
 
+static __always_inline bool vma_flags_same_pair(const vma_flags_t *flags,
+						const vma_flags_t *flags_other)
+{
+	const unsigned long *bitmap = flags->__vma_flags;
+	const unsigned long *bitmap_other = flags_other->__vma_flags;
+
+	return bitmap_equal(bitmap, bitmap_other, NUM_VMA_FLAG_BITS);
+}
+
+static __always_inline bool vma_flags_same_mask(const vma_flags_t *flags,
+						vma_flags_t flags_other)
+{
+	const unsigned long *bitmap = flags->__vma_flags;
+	const unsigned long *bitmap_other = flags_other.__vma_flags;
+
+	return bitmap_equal(bitmap, bitmap_other, NUM_VMA_FLAG_BITS);
+}
+
+#define vma_flags_same(flags, ...) \
+	vma_flags_same_mask(flags, mk_vma_flags(__VA_ARGS__))
+
 static inline bool vma_test_all_mask(const struct vm_area_struct *vma,
 				     vma_flags_t flags)
 {
-- 
2.53.0


