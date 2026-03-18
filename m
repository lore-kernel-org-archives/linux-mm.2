Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C6C8103E197
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 15:51:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D16E66B0292; Wed, 18 Mar 2026 11:51:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEED96B0294; Wed, 18 Mar 2026 11:51:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDDD26B0295; Wed, 18 Mar 2026 11:51:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AA0266B0292
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:51:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7F99FC2AC1
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:51:14 +0000 (UTC)
X-FDA: 84559622868.29.4240B88
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id B396B40016
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:51:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bgl0CnFw;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773849072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kumeaz3F9F5JjBGagKwwJBC9S1mTUi+FKhMAfdlAoeU=;
	b=c1alVAznhFe1D69q+0hiqotN5paPOILhtxY6vTE2Rlm7yJXo1HubBKOXQlRftTckQ0ZVJ0
	KTFo66CUQi1DW1o8loRitlViWmSFD1m2gi49BjsewWsWIuGt6ehW67IG59s2HrnBZJXSl4
	v2ZHchLBCi+/IhgIKz14GBd48l0fm+E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bgl0CnFw;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773849072; a=rsa-sha256;
	cv=none;
	b=su4hMj5xaZZrpYz+d/1aKq1gQEU9dSyu6+7MraoDN4cUGggdMrvtQfHyy+8r4YVsycAYp6
	VF4SYPxagFgisVLg6pe5BAFIongcTqGl1bpn3zvjOMbooYFiBs+yGvVY6CGflz3bkiYIHF
	yVEo+eySoi4HXgAZgIYgMjpzOqBVAsc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C4EA0439C9;
	Wed, 18 Mar 2026 15:51:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12E17C2BCAF;
	Wed, 18 Mar 2026 15:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773849071;
	bh=nrs6iJ/XdiJB/0ese2zp+YaeuL3aT0WXZzGBimGG+OU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bgl0CnFw2w9iWUKNyKcHV0ooDagsFya2kSGZSYS7wnv4UhCgV18vg76y6TBaqtIZd
	 O5lQWXgBUJyqGSyaju2M6OQARsj3bWDWDwtDGHo/pVVg3fk3bPy5v78bx1HdGc2Y5K
	 MJQJqe1DZVubyhOly75eGjM04WgpWjWwi+B6eqJYWuiCPReF2fliFBIeUinwFnu6/N
	 XuDVbwq/SckZdhjf5HM5g6fNLXJxjt/aDSy1IymOy1wEUDWGZEnX+eQu6PXw57Jg4i
	 oT3zLzACxdFXlhf5OF6zdvkmS4vxnmgj3U4aAWBq2muCepbEkLB9JJ/yEB1vWWKMPa
	 LotP1Xt38hFGA==
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
Subject: [PATCH v3 11/23] mm/vma: introduce [vma_flags,legacy]_to_[legacy,vma_flags]() helpers
Date: Wed, 18 Mar 2026 15:50:22 +0000
Message-ID: <4fdffd05ee7fabe2dc313850a4300bf184beba69.1773846935.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773846935.git.ljs@kernel.org>
References: <cover.1773846935.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pe6m6s9cwxcp1r6czfq9euic46eg8bbd
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: B396B40016
X-HE-Tag: 1773849072-309590
X-HE-Meta: U2FsdGVkX1+ESDavr0OSElGTMb79im95hbKQBIxInwe4CpMlLU+p3tc/m95c+br/GEyjFRDf241q74xvCmvo+LX4bw6/V/kVzzSiQ+3GUQJlHo6amqnyd7GQLIlQLve4VeOAxmhz2DzyRx1P0189I2OSWPOmmNgT6UE70tVsVGe5Q8UmZRnGIgfWiSVljbSvRPqAvY/AXqB0nSslu5JtwyZVbZaFV1HOZVT9nOS8BO9zZar6boBvKPUdut/kz+Fd55TgnA6jt2csf3D6wzz1wNiD5NvOEZGnesCAYUEmIFIrYjSJNe7dJYuA6SqqZiqGU9/3MhvV+uQkIs2eoe4gkoGzE+bXl5qu3ermDIpIa0vpAzGkgU5iY785r34Vm6VhBO1dPxyRJXqq9Kzp5RcyM3r5RXUFz7SdoBfcjzrFJkFxj74UNR98zMyjmEh8jYDsi7SNghBP8n6NHmQayauZajvO+Ev0s4q/lLc9VCbUYwQJL8lGlkEFyqLuXBTjf8LfYkCK1pp40ayQ+zWeff/qaSn+26MaZM1DM+aThdx+8onaKyGUBkJ0Dum5vRV7RHPhRlpw+aE1M4Cn1SaTq0jFrgJMFr+7BNcHByZrtGhWMo8qbfIgpge2hqGiXHCV/R7kfRPfaNb8w5+eULQZgH2Oi5wEz9jpoi9SW0VtofeV0nDMgUpPF+okiRq2gUVaLBcaaAhk6gknLKUNAJL8W3r8LO5X6lMbIQjftbBzV2oAi5JwnrLuE+Yul7QBKzZZdQR5Hz5sHJXtlH9r73NKUMW2wq5ZFQ0DQ5uvkeEtYsDkdOvPuA/DS0mB8f3BUFxtq7s14GYwS8HoZqhvGr/AB5U7hRG+qadxUQpbGo6iGWj4vEu4+Wt0vVuhPD7LUNxk219QJjLCPJdHZnohHtKSsQwfoIC8Qa0hoKmm9OH+U7wm/6mLhCP9EbigXybz4Z+iIXMWlawTqI6b8oboIlCnUdU
 EQPk5GkU
 MAOxPMUoNVzdR1cW86ea7JmAiUa0sb6iJCgsb/xF9W+4q1QOz4ENKbd3KC6lkd+bojhj9mjTFdyetlNRAZjBygBPGf1YC2v+LKfyTiKAMvkTjqldxlqddrnwfjjfVemLixld4NI6tvvL/GM9doDZFm5kCevhZKblCnem56dfRYkRPa3nfgIn61Adh+h1ElEddlL5Cllq/N23jcB3X0zDhWIlUwKjgYzDLul8whcRrJkvNatLO3oHPYXI1wkRQrtpx9ISKznvt7ybNwxHIQZJfVjljmkvqZku6W8qytodsQDxuYga1Vh0DEILTiJNV46DQF4HFWKdfjJkfe66u4w2Jift+nG0LS/8VNNFipZSzm93fU4SLtPJlvG+qUppC/V/loMVZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While we are still converting VMA flags from vma_flags_t to vm_flags_t,
introduce helpers to convert between the two to allow for iterative
development without having to 'change the world' in a single commit'.

Also update VMA flags tests to reflect the change.

Finally, refresh vma_flags_overwrite_word(),
vma_flag_overwrite_word_once(), vma_flags_set_word() and
vma_flags_clear_word() in the VMA tests to reflect current kernel
implementations - this should make no functional difference, but keeps the
logic consistent between the two.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/mm_types.h        | 26 ++++++++++++++++++++++++
 tools/testing/vma/include/dup.h | 36 +++++++++++++++++++++++++++++----
 2 files changed, 58 insertions(+), 4 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 47d64057b74c..c5ad55b8a45b 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1069,6 +1069,18 @@ static __always_inline void vma_flags_clear_all(vma_flags_t *flags)
 	bitmap_zero(flags->__vma_flags, NUM_VMA_FLAG_BITS);
 }
 
+/*
+ * Helper function which converts a vma_flags_t value to a legacy vm_flags_t
+ * value. This is only valid if the input flags value can be expressed in a
+ * system word.
+ *
+ * Will be removed once the conversion to VMA flags is complete.
+ */
+static __always_inline vm_flags_t vma_flags_to_legacy(vma_flags_t flags)
+{
+	return (vm_flags_t)flags.__vma_flags[0];
+}
+
 /*
  * Copy value to the first system word of VMA flags, non-atomically.
  *
@@ -1082,6 +1094,20 @@ static inline void vma_flags_overwrite_word(vma_flags_t *flags, unsigned long va
 	bitmap[0] = value;
 }
 
+/*
+ * Helper function which converts a legacy vm_flags_t value to a vma_flags_t
+ * value.
+ *
+ * Will be removed once the conversion to VMA flags is complete.
+ */
+static __always_inline vma_flags_t legacy_to_vma_flags(vm_flags_t flags)
+{
+	vma_flags_t ret = EMPTY_VMA_FLAGS;
+
+	vma_flags_overwrite_word(&ret, flags);
+	return ret;
+}
+
 /*
  * Copy value to the first system word of VMA flags ONCE, non-atomically.
  *
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 65f630923461..f49af21319ba 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -766,7 +766,9 @@ static inline bool mm_flags_test(int flag, const struct mm_struct *mm)
  */
 static inline void vma_flags_overwrite_word(vma_flags_t *flags, unsigned long value)
 {
-	*ACCESS_PRIVATE(flags, __vma_flags) = value;
+	unsigned long *bitmap = flags->__vma_flags;
+
+	bitmap[0] = value;
 }
 
 /*
@@ -777,7 +779,7 @@ static inline void vma_flags_overwrite_word(vma_flags_t *flags, unsigned long va
  */
 static inline void vma_flags_overwrite_word_once(vma_flags_t *flags, unsigned long value)
 {
-	unsigned long *bitmap = ACCESS_PRIVATE(flags, __vma_flags);
+	unsigned long *bitmap = flags->__vma_flags;
 
 	WRITE_ONCE(*bitmap, value);
 }
@@ -785,7 +787,7 @@ static inline void vma_flags_overwrite_word_once(vma_flags_t *flags, unsigned lo
 /* Update the first system word of VMA flags setting bits, non-atomically. */
 static inline void vma_flags_set_word(vma_flags_t *flags, unsigned long value)
 {
-	unsigned long *bitmap = ACCESS_PRIVATE(flags, __vma_flags);
+	unsigned long *bitmap = flags->__vma_flags;
 
 	*bitmap |= value;
 }
@@ -793,7 +795,7 @@ static inline void vma_flags_set_word(vma_flags_t *flags, unsigned long value)
 /* Update the first system word of VMA flags clearing bits, non-atomically. */
 static inline void vma_flags_clear_word(vma_flags_t *flags, unsigned long value)
 {
-	unsigned long *bitmap = ACCESS_PRIVATE(flags, __vma_flags);
+	unsigned long *bitmap = flags->__vma_flags;
 
 	*bitmap &= ~value;
 }
@@ -803,6 +805,32 @@ static __always_inline void vma_flags_clear_all(vma_flags_t *flags)
 	bitmap_zero(ACCESS_PRIVATE(flags, __vma_flags), NUM_VMA_FLAG_BITS);
 }
 
+/*
+ * Helper function which converts a vma_flags_t value to a legacy vm_flags_t
+ * value. This is only valid if the input flags value can be expressed in a
+ * system word.
+ *
+ * Will be removed once the conversion to VMA flags is complete.
+ */
+static __always_inline vm_flags_t vma_flags_to_legacy(vma_flags_t flags)
+{
+	return (vm_flags_t)flags.__vma_flags[0];
+}
+
+/*
+ * Helper function which converts a legacy vm_flags_t value to a vma_flags_t
+ * value.
+ *
+ * Will be removed once the conversion to VMA flags is complete.
+ */
+static __always_inline vma_flags_t legacy_to_vma_flags(vm_flags_t flags)
+{
+	vma_flags_t ret = EMPTY_VMA_FLAGS;
+
+	vma_flags_overwrite_word(&ret, flags);
+	return ret;
+}
+
 static __always_inline void vma_flags_set_flag(vma_flags_t *flags,
 		vma_flag_t bit)
 {
-- 
2.53.0


