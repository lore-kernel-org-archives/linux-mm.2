Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E0C2106ACD6
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 19:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 527776B00B0; Thu, 12 Mar 2026 15:17:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B5026B00B3; Thu, 12 Mar 2026 15:17:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 328826B00B0; Thu, 12 Mar 2026 15:17:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0E3526B00B0
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:17:16 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D43C4C1AE7
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:17:15 +0000 (UTC)
X-FDA: 84538369230.01.0DF8858
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4409A180010
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:17:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KC6FeGCN;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773343034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vcymtf1gomP/uXzLFZ2JERMI4Visc47ZdK6FfqXTJmI=;
	b=ZZfX/UDA6cL8xWf71DP/Btca6ola46PtE9ffh7EdKfJm3XotdrnqqeZ5FEyzF8rjo4fiDt
	KnSkcxD/JJt9sig1Y8tP13Xol/jOkIfNU0gQM3yH4toAVH/jTA/ExTsF7aj4+LJx4O4GB2
	oxAeXTg+WlZP2ClROO+Xba/3stly9PE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773343034; a=rsa-sha256;
	cv=none;
	b=NeJuc2OoqjJTIEtXFUmegq0DPHPO0MnhNltQ3MQRVZIU9QhurcwyO0lSOh7l+4l6E8RU+m
	/N4jcg1tDXlGmomxLrOWem/99AEHKOHEDOfylt/SBwgzUEaBa1OBgSta7xTDzB+3QTKmba
	mt9CoaIM2r5QMKxOv7+586zEoVIXINY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KC6FeGCN;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8AB7961335;
	Thu, 12 Mar 2026 19:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C177AC2BCB2;
	Thu, 12 Mar 2026 19:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773343033;
	bh=iWPieZ/e1fDZ4FEmYCmXjevHQbQOBJ40JrJjUOR3wHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KC6FeGCNssf3xoyMY7ZJzUJYUHfK2uC6hSPeHxppmuWFsPgtTu4HWiEFUPQTgW3s0
	 SCaEgSpKNLdqMrPpbg0IFqC8jShBIJNnXSLUXjMdp/js81MJTAluetPJdnqpyJGsiE
	 N0zO8GHB7kkEpsfm5Cyzv5dMpxK/mt8G242VdoXVALclaA+kSz8QPM8A8N3StWhsh3
	 Nt5oxs6IDdvx42B9+6uvJu7PzgTuuqvZ7aZmfZpKuBfrjFIHoH/gK3vuFsQZMPa/Pq
	 Bwzv63qG+IVJaQRp93YRvFwuwSBXlZwsaKgQ7g5mNW+OUwksU7I5yBmOtpazl4ZFdA
	 BFyHw6onS25yQ==
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
Subject: [PATCH 16/20] mm/vma: introduce vma_clear_flags[_mask]()
Date: Thu, 12 Mar 2026 19:16:14 +0000
Message-ID: <f8f74622b4ee92e5df2b7546439a1afb3a922cfa.1773342102.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773342102.git.ljs@kernel.org>
References: <cover.1773342102.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4409A180010
X-Stat-Signature: nhutdtowoeykn5y9z3eijmoubh51atwg
X-HE-Tag: 1773343034-684298
X-HE-Meta: U2FsdGVkX18ku69/y6yaUjgajxWZc867gb2oWmFOhJtzBVrcPpL2bYYNa/WP9zqg0PuPAqy1vmbpZlt95IcAoJ7CzIKXxgQZzXYPnAgsHWZrH6qDDxfGXuaF7ouJ5kZcEP+mD8fJ05fEkF0mFcax7JgIBDibeHhiBTXUjvIblqhnVMkKM3A61fGnSlC0J2NmadcKF2cCR63o25LPtJQ1FO5DSUV8zi5ij9/nMQg+BbIMQWJNs28WG8zrEL1Bh4MyM2jeg/H4ETVTmMfaK8/Dwt8f5WbUmavQklEcUruFO/1l1JLnRNqEWe6PSwaVcw89z2FICX5NbOcW1mJFNBNp9pQGv/tYNSN22RYM+RGHUR++yzs/49ZsdSTuDXjJxOPlSMA4yalJgaB821g8G1MmE4bYqag6jQRHXtT9SFtYpWcz7eeNgpSWxr+zmNVx6aVBqof2VMvaE2FEJvD4nnCn+PeUIhsSjUiYFfPoPiOTqJ+K0cwIr3cfO7nPb9l+ABtK3+wEsq00wCnNdPyHojxJdCDQh3dvUFHFA68/HPr/FY72C18A9bBg05dr4pCvXwaoUs32OPFaVzPrpA1T+HCwEc/GVz8qHYnGb0BDSB9O+2hKKrZOef5X+9V4d1oMQlf9CB+ANsEg0APHcZHzuSq+O3aUm45cRC9MOCJmHAYW+RKMs07QA4Z6l1oJO4pI3LIhMPzZMQD8AWrelCzdVYAxQ3FPmpZY/xMqyR2QtUd0UlpuPYvoNMxoMvO1wOHpqDLhNH52BnwDmnUn3C7wQ5sLFasqWPhfZhIe07I1cO1Rl7x0NmARSzt+yyCIYTSxLNnnwPcgPVKLsB0QCqoP05mtdW4Hqu2PquWn9l9X34j+AT6mILrChCB914A+fCcOQQbk0jnClE6zOM0FpJI2vOMQzTDRUYp4YG/qkjxoWHov13+vA+3enMwmkX+xobf+sgnR5y4vXpiPDi4863vYmdv
 oHVGsaq/
 AsJL0WahOVkA7qi0bLyCy87060INUwWflPP2svom0mfj8e0rFLdalI9e9ShhB09Q5bEDPu3NoS/vJIcapVCc8kZhm4lJ55s9NsB2H5lYMONUNKdcggUdKa3DVDfxhgQF+E33nPHUAnChduGp8KtsRKFo6wmK5oDrPbfgN2yFm2c2TsF04jkcph33DNCtAtV7ta07k8bRz/1tDuUd+/UVgIRa62jo+lShdZS3nsYqBOC1Ybhoaxo6ZPhCSVJeJx7YECRyYV+8jKnyHGcamC48QGlXlfadezEHtRyITCmHpAXL5cK1sb90Z41SDXdDujT15yM0FA+ahJ4AQF7YszOe4l4dymjw0T7Nmh3ON
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

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/mm.h              | 16 ++++++++++++++++
 tools/testing/vma/include/dup.h |  9 +++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 4b574d941ea3..bec1b43efa50 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1324,6 +1324,22 @@ static __always_inline void vma_set_flags_mask(struct vm_area_struct *vma,
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
index 70cabacdb9cc..81bd34c62c75 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1039,6 +1039,15 @@ static __always_inline void vma_set_flags_mask(struct vm_area_struct *vma,
 #define vma_set_flags(vma, ...) \
 	vma_set_flags_mask(vma, mk_vma_flags(__VA_ARGS__))
 
+static __always_inline void vma_clear_flags_mask(struct vm_area_struct *vma,
+		vma_flags_t flags)
+{
+	vma_flags_clear_mask(&vma->flags, flags);
+}
+
+#define vma_clear_flags(vmag, ...) \
+	vma_clear_flags_mask(vmag, mk_vma_flags(__VA_ARGS__))
+
 static __always_inline bool vma_desc_test(const struct vm_area_desc *desc,
 		vma_flag_t bit)
 {
-- 
2.53.0


