Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0DBB1099B3F
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:39:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 249246B01A0; Fri, 20 Mar 2026 15:39:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 222496B01A2; Fri, 20 Mar 2026 15:39:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1105F6B01A3; Fri, 20 Mar 2026 15:39:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D827F6B01A0
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:39:31 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A44668B3F7
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:39:31 +0000 (UTC)
X-FDA: 84567455742.09.8944230
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2B3BEC0004
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:39:30 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QMNg2jRn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774035570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k95MZUxXEJI7xlz9Aj7upwyJimb7rapm7cDFmQFXRjI=;
	b=u9Cq3K1g/+/9byebko+A9HtUVPL/c8OTJY5N8ga+l3rCTr5DHCholsQmeDUNSHLjcXTVLV
	UMFPUsWKGR2ZBEU9xlz8wNFEuWHKJQoKXgaOUtSOCTAXkzMCpczjf75WneWgMHnaKy6Wnm
	2ZFYrlpDDacIOywlRiRJyTukBaWga1E=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QMNg2jRn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774035570; a=rsa-sha256;
	cv=none;
	b=UjvNsj3CqHqKtnsYlpKai/PR32jxU6ifu/ijtOQvqCRyHt+eEkRB9cxj5k+UWeLjGVj4QA
	IPPB1wJ2HPBbKuz5GQNZJ7yojZ8UgiBvhLCJQio89XxH2KZsRs7XuvqElEx0LKCuB+jqul
	uXjW/j3YZpI1+TPfayNuwMVtWtdUulA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7EE696015B;
	Fri, 20 Mar 2026 19:39:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF26C19425;
	Fri, 20 Mar 2026 19:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774035569;
	bh=UT4ud8MTur8lr8kwsDrYnrk843BMrVlmFichAXqq488=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QMNg2jRnuWc/CkdRCoHVfWdKjfVMTq6qBO0L6Aij51dh+qJnYtQujRBM5IunIw7OL
	 /utTkg74YhjIwZDMKPRtKlGH7TDWX3VNxeBt4/apru/YaBRRjyxQKJU5Qp0cWEyv22
	 ncMm14jjZo/ZNle6nv2pB+RdHwR1tl4QUX5ZaWTKXBZkEYCAAElTY497crLStNtXr2
	 /pZlB8xU3dhGFrMSa7xsBUtOiubIl5IGKA3FdNHG3NQH7gz0KhWVN5zJFdCNxh24X0
	 zkeQrnC9TQ+zct4G7F9jrNPbrSop45h3uzsLThP5xRLuQkvUDuwtzJuT0weEMeVZQ6
	 7ujX7Zw3fS8eg==
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
Subject: [PATCH v4 19/25] mm/vma: introduce vma_clear_flags[_mask]()
Date: Fri, 20 Mar 2026 19:38:36 +0000
Message-ID: <9bd15da35c2c90e7441265adf01b5c2d3b5c6d41.1774034900.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774034900.git.ljs@kernel.org>
References: <cover.1774034900.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2B3BEC0004
X-Stat-Signature: hfekkmwsqwuek7axp3ftjoodjbwniyqh
X-Rspam-User: 
X-HE-Tag: 1774035570-101266
X-HE-Meta: U2FsdGVkX1+tV/WMiJh9glGUEKYf9+lIN3MISJU885KfRhNa3bgBRAUMBbKUrVnunnwj6QXBEBUhehzSGbnvBdKhZtc5+1nAJpTHkBw9+b/+ICepAb9Jg9Pl4JXWJMwO+QKQTIdl6Y3qkV/5SsbRYeNjwCcm2whUqMrY6jjji4iz2d5J7sFgL1dfdgKn/g8vr33mlNBLHDc99raCl/DNDAnAVAvaeGuPLE0Qu9w47JKhbdyktfD2UZjhScyKI/93Lb1xc33okmtwGkm6e+7UZJX0MDELCkkJaW3O7EHnLBskrKsIJxQ+TMJkK6J+9bUJQ+eJDtIdOQdYSoQX0qrdZHBQqNy3R7nsKIX5surYA8p/E6z86td5jsia7sRdv5ecFH+1MHaYmxB+UhZ0McP3EJxczHvEgOVFhgIMqacu3qYMS2k7jfqLI7cPJbuT7y7n4qbFNrBX3UKVoaBW5HzN+M26iRhmEwYLXFNdWkD4kmDiDroXxObUbvc0yKt6z3WgkUPDrzWHLb/iVZMv4WXR4y4D9YQJV2K21E3mwgyhKz7IlbBW1+5yyuH2XuBwV4gkmK1H9TeiLImAB3ZVrEplSTRJXFLz/6TfQFoDn/YIWPXHes4Sd7AjuwehpAsh8JRmgtQW4IUYMCrJg2D3yz1yqGIFm9JQ5tFHmZdzUfCOkeo+BeP06Kd03uqQqPKjB2kpYYUQkFEuZoNPNyGKXY+7bKyibq1wJsuTwO/Kcvd5i8dgGjh56bGlmwnAn2x76S0fkPsMtCwPegmPRFh0h/UKCZkW+POBfl67s2No3TRGkDsl26bypmsFfuSpk+oZYGEBu0t/UV7WfFnnmhsczUy7kJJonrwUxNAD81vt2ZCiSgqZaWy5qPylmEWJUwMUIKIj1Pqe+T+AVAbugS4kkBMCj0ioduHc6kycxOZL+9hzRmgbQKFcEMli/IyuN8VmXHG08VqoqvgNTb/559Gd6zM
 R/uU6NHL
 IFNVbIFir6B2rBm5Vf16GbLoWgi7S5DWqB+XGDBaJkNAjGBWCtu0CJ2vBvSRxl2qWJtn576u3JfWYhC4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a helper function and helper macro to easily clear a VMA's flags
using the new vma_flags_t vma->flags field:

* vma_clear_flags_mask() - Clears all of the flags in a specified mask in
			   the VMA's flags field.
* vma_clear_flags() - Clears all of the specified individual VMA flag bits
		      in a VMA's flags field.

Also update the VMA tests to reflect the change.

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/mm.h              | 16 ++++++++++++++++
 tools/testing/vma/include/dup.h |  9 +++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 93d69de1520d..d3585999aa0b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1368,6 +1368,22 @@ static __always_inline void vma_set_flags_mask(struct vm_area_struct *vma,
 #define vma_set_flags(vma, ...) \
 	vma_set_flags_mask(vma, mk_vma_flags(__VA_ARGS__))
 
+/* Helper to clear all VMA flags in a VMA. */
+static __always_inline void vma_clear_flags_mask(struct vm_area_struct *vma,
+		vma_flags_t flags)
+{
+	vma_flags_clear_mask(&vma->flags, flags);
+}
+
+/*
+ * Helper macro for clearing VMA flags, e.g.:
+ *
+ * vma_clear_flags(vma, VMA_IO_BIT, VMA_PFNMAP_BIT, VMA_DONTEXPAND_BIT,
+ * 		VMA_DONTDUMP_BIT);
+ */
+#define vma_clear_flags(vma, ...) \
+	vma_clear_flags_mask(vma, mk_vma_flags(__VA_ARGS__))
+
 /*
  * Test whether a specific VMA flag is set in a VMA descriptor, e.g.:
  *
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 36373b81ad24..93ea600d0895 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1065,6 +1065,15 @@ static __always_inline void vma_set_flags_mask(struct vm_area_struct *vma,
 #define vma_set_flags(vma, ...) \
 	vma_set_flags_mask(vma, mk_vma_flags(__VA_ARGS__))
 
+static __always_inline void vma_clear_flags_mask(struct vm_area_struct *vma,
+		vma_flags_t flags)
+{
+	vma_flags_clear_mask(&vma->flags, flags);
+}
+
+#define vma_clear_flags(vma, ...) \
+	vma_clear_flags_mask(vma, mk_vma_flags(__VA_ARGS__))
+
 static __always_inline bool vma_desc_test(const struct vm_area_desc *desc,
 		vma_flag_t bit)
 {
-- 
2.53.0


