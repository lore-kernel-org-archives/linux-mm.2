Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 269B71099B3A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:39:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C31D86B016B; Fri, 20 Mar 2026 15:39:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B96616B0174; Fri, 20 Mar 2026 15:39:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A3016B016B; Fri, 20 Mar 2026 15:39:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 862C36B016B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:39:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 50C56160382
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:39:12 +0000 (UTC)
X-FDA: 84567454944.12.9CC3B1E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8501D4000F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:39:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A8fVFJ3G;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774035550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Z5avGS6EHhMJiTz187qMhIz4EdfpX9po9jzXvdoiEs=;
	b=0+EeGNUaRRX8NnovaVQGg+LE5jS+kSByVoDMbbqeILaWFy/26WXy0/7VsA8BeNzqWxOCh4
	+UHWy4TW74jP3scJM9gEHGXJhzTBDjBv4z2l1MMoYNztzNcgXXl1+tVlvopetIoi9quMb+
	dv90k483/5v46AstWc4/fqHQ44I8sbo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A8fVFJ3G;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774035550; a=rsa-sha256;
	cv=none;
	b=Ti/ssKBEQdiOtF+PSt8y6NeQKBeM8PaE6WBbu53WTJcSTopDUXvSL6fw1zEaHocT8a1brl
	81Rsily8zk0Zn3UbG1glgQyn5H+arPbE63UheBwWkDqoK2jOOp/nzn6o7G/z06YcI6yFzG
	RHCsXJohVPnopLISwCeIpi7mUQ9M2ys=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A361240AE1;
	Fri, 20 Mar 2026 19:39:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1B1C19425;
	Fri, 20 Mar 2026 19:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774035549;
	bh=9aWXzHQRv4gbTjT9rqsyf0H1rogJGGwItdb5fmQ3ask=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A8fVFJ3GCBEUnRthGRP1kE/0URQNcl+KsRUsadd+fIhbQe/2gfYOv2D5S6mV0FVNZ
	 IqByOoFx7gjlJH8WMXXirBT0TLE71Xaz7p3bBKO2IbHx1lWWFZj1nAedZ1DZN2fB3K
	 BwlR7td0TPqdBqMNbeWCVoPUdCXxwwoNW1Nw9yUZyKVkBywUnZquLJ4ohjmSFySN6r
	 7AGiYC8+L/ouGqqrMeqCtyGU6zBcUM0LT5S8L7egr7xFVMOju9p4zYJrNsSsk7SXqw
	 SdHetqFtTo5raiZKWGQELIBuTzc51Mq23jvzKPe/a463OBWqpA4GP30daza6Swf3tW
	 UthlC5Piprkdw==
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
Subject: [PATCH v4 10/25] mm/vma: introduce vma_flags_same[_mask/_pair]()
Date: Fri, 20 Mar 2026 19:38:27 +0000
Message-ID: <4f764bf619e77205837c7c819b62139ef6337ca3.1774034900.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774034900.git.ljs@kernel.org>
References: <cover.1774034900.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8501D4000F
X-Rspamd-Server: rspam08
X-Stat-Signature: phmx7wkstn17zgin7b7hddusyekgehsy
X-HE-Tag: 1774035550-480881
X-HE-Meta: U2FsdGVkX1/piwNf07Xn6UHNo+eICSuChETXYdQsLMzWzH7XSXdIpiWoDR9MJjKrR+GOGPA6THp+YnmHgB7wA6MwJPw5K6jwff4v87MVissIqtx/DTWG6km1Kd1gDdSfdCEuq6dF8X4eyW7SQoVEAyjdP2BU/pUCpOH86TN5Th5msVczl0f/oICii39AOWfFuxyXMpdTPqLJMmcQ2gjSQ7RvEnugv7B8d+8kLocEGEwidEjHseERwyd8wLp3bj6TbjyGjnwmTq/4Aw3xEU+I8W1a/y614plYM03se7dccf7jnbzsy104m2p6YdRtVmnfZbF1nZEQPKL2gmAnnyfFOyJTWaciP6H451mUwRFc05wPEOzFoDpVCAWkb2EBDUcGv7yoTHfNIvIYjCAwWlNz+q35DskKt28ecNM93vT52krXZdDO89uHoW4+re9BMoEgpZ8PQPu03RLAlMVP+MI2kK0iaw6VWd9B0m2/9TSv/w0S7lZEjHvFaoIkGuC23YDJZpC8iknIlcoDIb3Fhgckv2JD9SYHy+r5OJs6kpTMsR3La1XvW0w+EZTQGuz3gafuuMxEBc1vJM1nnjZ0gk7o8zRE5gASVvc7LyFd8H7P8fzbIbCd9/xxZjJpegq9i2FZtc+dI/2Yjm1NPfWOUTDbd2xtFG7VqSIRe0K/B0X3KKJHm7Czk9uheG14ao+PvHxJ06emV/leQDPFZT8z0leukZsPvEB4f+ulupSgh0WHd1a27a98maLYP6HSZcNBTw/wBdtQ21IFoDeDSHQnN4uc8KJMsFFGMSqGIUe3nRUmCK5UvSLAcVLaGUbi/c3ejJ/iuJXVQxqAi26ZyZps4kjTAgONSOLqrk6LJf1Y3aUkQ8/oeNjx+bQ47XgX+pVCUBLy2cYNRnKcUxETw3evfT2GK+NCg9Zq25APCgiI2/YqgL3gyVYwSSWuLCGpJ7luS4zZSBLF8atCR4Et6pHzxQI
 C+DHPVYe
 fmarbMay9PM/kflh9LWudnW7MviCZ7JV4ZjzlVCP32KWuJl0Bvs5nWtlyhURdu8fXwlUd+B1ETGwc48uEjQON+w2avdLoEK27zT8cftrBMvwSR8lh1RC/BP+s/IsBcjsb+UVSatRTWpCROV317O+RWfp3NAepO1RQ/06V2kdJKDIhy4JzPkie7QocYBrX2Zp9U6bl+pV7iE2tDA+30lf3EJPUFPfsnwHLIzFOYQEg+rw3HQUddg+IQVgSBNJAkDhyigCkMqap1oGsB6VThm5sFNamr/mqUvCVmcEJuYBDCs5DqII+5hVNX9uoGwC36sLSGBLe2mxtr7nZjRPyi07TX8xWfbFBhlKhpunl
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

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
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


