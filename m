Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D55BF506D3
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 13:09:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D91876B0284; Mon, 16 Mar 2026 09:09:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D52CF6B0286; Mon, 16 Mar 2026 09:09:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B41196B0287; Mon, 16 Mar 2026 09:09:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9AAFA6B0284
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:09:51 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5818656CD4
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:09:51 +0000 (UTC)
X-FDA: 84551958582.15.298792B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 90BB720019
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:09:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L9ClPzfO;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773666589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PVDkn4Iea63x/iUjKGqsNgWSDwaAjBUcPqsY3IzSXW4=;
	b=eppNrUK3L+9F7ZqP0L1uL2N9lfjXtf8zvA96EHSCqWLH+9QU3ZvOO4fF5Ks6dh/5Qzl5Hz
	p/SJ/vC3e5XIjryrUMAsI+A+BVkqqyObd3Vp7Y7fzjlGQq5l3yeABI3hh+xFL5amGti/U3
	/W86KIOS1rC/OkpN42MVzwQZKDOgP8Q=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L9ClPzfO;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773666589; a=rsa-sha256;
	cv=none;
	b=1SEKSIaeTnKpk7liVW/YPVS8qMEI6lBwlb6Gajv7P7P3ahmQfdGswg3lZHHiiLSnL9Jhtv
	3GmKuErksUxfS8jxXBA6DmKGg4gtPN1T9afqVZfAlW2lS7/+GcYZPr+j/8+rXL16KNYA7l
	Er9eGf4ADQjm4UYzvEGqKeiBZW4GrXs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AD5A340609;
	Mon, 16 Mar 2026 13:09:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC0CC2BC87;
	Mon, 16 Mar 2026 13:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773666588;
	bh=VYCGf0WaVtwDjxvr9LYOu82c/eRoRD87luS4chwjGHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L9ClPzfObkNEhL332KF/QsJjLdy0Fa0xLfyvSh61rjRN/BLUc3TuvXAWwaGBQ8G7c
	 GrPR02Wp03hFy51gh/NzNNgJQh3ikS6t8NdZQoyd7tiagwoHharLCpKdXjRdVDcjDd
	 Z93+eqGfFfbfHQCfyc0492bN6xXyWKxnPUAXhPgpMO7c5TlVo1FnE8xQNocNbL/d+A
	 Vme4UVDf6vAPXLLNngj55BlkvIg+fLN/ZvoPcQ4G6TnTdpJKa3DPU1F2eNnJ463akL
	 grY0yOUO5yzdAHsdG1vqOwD71rrNYWbV3r3uqj+7loTkJo7ibd1m7/M9Tsf4bH34Pe
	 sZZ9+w/i+EySw==
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
Subject: [PATCH v2 19/23] mm/vma: introduce vma_clear_flags[_mask]()
Date: Mon, 16 Mar 2026 13:08:08 +0000
Message-ID: <397c67b154a4868e19db9be1012e976148901de2.1773665966.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773665966.git.ljs@kernel.org>
References: <cover.1773665966.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7ejthpgwymg8xspaz8h31trdt88rf6xw
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 90BB720019
X-HE-Tag: 1773666589-54799
X-HE-Meta: U2FsdGVkX1+DLrXCWhoHCHRaLpUqrjkkFukWJMPA38T53dlPp3MHeUCS0lyVHdD2klhvF8Ky15mEYNWsQLBnUOHMK+IHTBOz8CegSUpUa4EKHeMqZmg6v2PmrACdKclKc4AGbVgj+W0vYlKZpQG6VcmuOj/fp269dXvQYhAKXXIGFdhjw9m1svIy0DaVRRNZmbJpiZlnMjbI5i6FmS3IKJn5mNHFW0Pmi8GqFDN9PN8ej6t/4rwFyGps08n7ZpQcMucnhThJxp0Nm4Lh00VSEHZcD7Lb4k/gIVWvgKnXqXLx1H2AkHaNRznSoIKn8PEwCSYW30t9ti7SH0m/zcn87WDStoljOYoGqOsE74XFodbkxkkEVo8eol1No+W6SuW9jaZQU4Rt84E3b4ybTED6VKw2YNOgDz3MyzmK+B5bk+vd+bjoL2G6pECUhXIdD5Kw+XkKYHMSaxiGbQ6u5bZvlyuhBRm8Toeplhl9HW0/L3YVQworbW6BO1VQA1lqWrPMD1OE23k6fbaA5jVNLcYoSQQbQb7hzJSbJcsO+asL02x0+t6CDAuWu7tbXqKuEKgghKZ9P6b9dTvvDvvj+0/WtLjRmiHQ1DwWNk1gnDDDydxZKBBeAx5AZrh/PG/BoJkudch8g1QZWNQ1mjKaj/6zDwggoh87GsrzjfP+7xWpwNgoD3wZmYVlP2xp/1WK5SogliEtet0vjK1KrnfylAEWV/7AG5D0MXXxfRMPUU83pdEyCBWBs6L35re3POzfe6cOuH7/NMBZgJYsJh4bss/YBYpL9iAsusABtrtZRYkXokHmgoVZAw9+GheyoW52PIQAzXkRhh1EHcXug4Rh5eR+/p56Qrv57M0sP7fN0istLl+6APbjJGaIILAv2HgNhTTFUoKsmZf+P9rmOlNttvAtPz5iktnlUwxcdWxxhYq87WJ/uF+EWwUtDHSD92A2YIH1tgce/D3RiTAoX/6zPno
 E5tqhxCh
 75pR3X5iUWXIuNyKZCm5iBgZ0kz0XPQT3bMK9UY7gg9wyzNi3voR9+TZJv/uuecUZrXeesq35h+0t9f7BXfshOc7UU4OBiJ0rmW7aBa2WJGGr3czWK300d+PgXdANe2E/Mt6dgZFlG6dIN108WDXtygvw0SKbnUUNRZ0zeVlMoDq+gjmAxS/oKB+LtLE7rr4rX2sk9FM1mf5O3Q16iw5GIEXNe/fgc9hCu3YjTHKH0x7sdFh9LESM7Gv7n6QVd/Pg3auEHbgnj5xBk0n/xnZK+aNFazcVE2uEFrdpMSN0n/0+JCx1Xn7RsV/8x+bxm5AhM17u0EIRwEqivnhVVoCxabpSYj316h5CoTEN
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
index eb1cbb60e63b..4ba1229676ad 100644
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
index e68d3eb78178..1c4a58f11852 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1063,6 +1063,15 @@ static __always_inline void vma_set_flags_mask(struct vm_area_struct *vma,
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


