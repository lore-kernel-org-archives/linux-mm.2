Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 425F010F9972
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 20:24:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BE3B6B0093; Wed,  8 Apr 2026 16:24:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86F436B0095; Wed,  8 Apr 2026 16:24:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AD846B0096; Wed,  8 Apr 2026 16:24:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6AA176B0093
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 16:24:46 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1BDCC1B70B4
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 20:24:46 +0000 (UTC)
X-FDA: 84636516972.02.8CBDBC1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0D03616000A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 20:24:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hyI7pl88;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775679884; a=rsa-sha256;
	cv=none;
	b=rtd/MKjGWNOISMr3EtBLeIBupW8PVd8tb1kz7K8j2Id1OT44KvxwBZwhQAWowg1mpxR6qR
	HB9TuvBbdt4NJ2rBMQ050ZeHQlU87RznxzHXXIb8hr0mrchT6Bv9bDMCFgaPpez2afinCY
	cZBseXg4oxnVzdDxfMnkmsjIlzDlM4c=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hyI7pl88;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775679884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JFnc/hoWnWNjlce2sdwxKTuBgL3PkWnTdvy+3P6vOl8=;
	b=d8vTuBLTXZegbfIm6goIe5BWNCkMJ7cUyBg9OsWWzvYb46JwXd5PscDQrs+1yNEeFjlnp6
	z2rOFOE9rs25ATI4k4HyuddgdFQO9gSN6hGCdVegDfvJ9Bwd7oTcZR8CgFWE9ZmG9m14cz
	tLPY2FtWW6MhvGUArXN/ja9LXe5qM/Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775679883;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JFnc/hoWnWNjlce2sdwxKTuBgL3PkWnTdvy+3P6vOl8=;
	b=hyI7pl88oE71ktmpoNBejt9UeJcllYHVydvlBOJVUu3ZkMXI+kUtvyVQE8IYmcR3b6q1DT
	30UqOkdsgQKopU5LVABNYma1BUx0qUIajQL8KgB/dUNjXINLC16oDacIOur/psIE9FSsx7
	13ys8ImC7gJBedSWnOOw3V/w2ILJpyI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-322-t3WLZ3LtOAihF6-7EypfWg-1; Wed,
 08 Apr 2026 16:23:20 -0400
X-MC-Unique: t3WLZ3LtOAihF6-7EypfWg-1
X-Mimecast-MFC-AGG-ID: t3WLZ3LtOAihF6-7EypfWg_1775679799
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A1A681956060;
	Wed,  8 Apr 2026 20:23:18 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.88.140])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1A62D1800671;
	Wed,  8 Apr 2026 20:23:16 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH v3 02/10] mm: introduce pgtable_has_pmd_leaves()
Date: Wed,  8 Apr 2026 16:22:57 -0400
Message-ID: <b65d560458b2488f715b5afc1603d786e786ccf7.1775679721.git.luizcap@redhat.com>
In-Reply-To: <cover.1775679721.git.luizcap@redhat.com>
References: <cover.1775679721.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: 3MvLnJzk5_ULfOr0bAA6PG1e49RwFeysEHkfYVw8KYI_1775679799
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 0D03616000A
X-Stat-Signature: orozz5cy6hfjyygutwgg4o3b4jcyawy4
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775679883-684245
X-HE-Meta: U2FsdGVkX19+chsQTipOTg8R0mFjbYdRGesePrQLNyji2prkisazEKpgmiEL9Hq7lrJ3PnKjiWh2Q3uDS+RTbQrMnAUHRGOvCKwGY9jOol9crJr5ClwYR8e+n3DHcnYt9EG1J5Yd/6WZ04Nj2OEQfFV6+ofl8KllFe9TAl9qSuUkTihumTbofDQ9yTZtBWGq7kArIRzoMtxyAVBkJVu4H0hxYXaBDFGQlcjQaFkIx7brUJd6XOe6d11gV9tWVCwa4JmEctQVtaLYhifpjy9hASJtvI4hDs90ezOzT7mih9MeuEXE6UMhmOTFqXlgYBp9/JhP7QvINY7qsDLk1pENKsI+9bgAw2rIkHadWlH8yBbR2TIfdgJXbfN4FFqfvIw99cCTIjDmnRBEjityeGRm4rhaooyy6JEeLteYnD2M8ndLWacIM3i4wMCVuTIQlurE2FC3q/DN3qSPHcCcrhytiUpuVS/adCKp0Ww03SfT6yKjsmI7xCGPGsgl/T7zO+2eGHvRA1s4DxJBQeHM2a7tJ7Xq50zG8KyYt4fnEHRf1iz3pINIiAjh3CudESLmxNMimdONoHPrC/NnO+ZMgQszulKrPa7bQWTi73AlzYLwj2E0XF8I3khp5wAaSorxM3uQnlhrMt9m7x7JURV0K7Lx2G43c1JYaQPzhz/SDWX9dcPSenunF/kgUjGGynrSQuwXqjyWmHE0S/jmB+kak2pkFODi7x16P5TSYc7NvHuuhtpiBDrmejUA5dRRQOjGzxYE0vinWud2fFRWJplBRxO0VQnaQZWsMlCjpZaXNllpb2fyu+vdRXTBm/ZRLZQkEA1oTc++CIlUntzYWkOsNOKF6az+EAR2TDHxokHKzziiVQFPPOri0Nzho5Qbt5CMRjSoBplOPG7axxjmyOm5a/9WxvBiuo0NWWEoWVfuYGerkvdIJyTns3I0abKjG7VwvnF7Wf3YZqh4b48HW1/l8gq
 7Jj4l2WR
 INeWvnziiquPsMLxJ4081rl0XVGEohL8UMAAPzEwGJdPuO3rlqa3VaQDMdxa16LqfW5qkOTd/rLLKINX0e1EZpdthI/iNvdItbXFwsoAHsPtKYsP+BpLZw3exRBP1vw58iasu7jlQtyoQOIAKu/E+jDr0aryWTo+cUZRuGMnVDGU0vD7w5VxjBimjnYqZfUZDEJIhktHS5FqGSEzYdjecFrw/pUc4MxMnjeC6H+DLDtGqDuKpW9hhdgp9FNxEpGNgjF4Y0J1u388sqYuEkFpLx+qm+yqFUz9mwt0ziF3V1ekgTIrvmtG0ifDc5oQzfQbEXgTvavbBYO782/fzVza7AHWG0vLX49OjG214ukzfJzfASW0VuZFcnkWe93UR6eve4Oyn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, we have two helpers that check for PMD-sized pages but have
different names and slightly different semantics:

- has_transparent_hugepage(): the name suggests it checks if THP is
  enabled, but when CONFIG_TRANSPARENT_HUGEPAGE=y and the architecture
  implements this helper, it actually checks if the CPU supports
  PMD-sized pages

- thp_disabled_by_hw(): the name suggests it checks if THP is disabled
  by the hardware, but it just returns a cached value acquired with
  has_transparent_hugepage(). This helper is used in fast paths

This commit introduces a new helper called pgtable_has_pmd_leaves()
which is intended to replace both has_transparent_hugepage() and
thp_disabled_by_hw(). pgtable_has_pmd_leaves() has very clear semantics:
it returns true if the CPU supports PMD-sized pages and false otherwise.
It always returns a cached value, so it can be used in fast paths.

The new helper requires an initialization step which is performed by
init_arch_has_pmd_leaves(). We call init_arch_has_pmd_leaves() early
during boot in start_kernel() right after parse_early_param() but before
parse_args(). This allows early_param() handlers to change CPU flags if
needed (eg. parse_memopt() in x86-32) while also allowing users to use
the API from __setup() handlers.

The next commits will convert users of both has_transparent_hugepage()
and thp_disabled_by_hw() to pgtable_has_pmd_leaves().

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 include/linux/pgtable.h | 15 +++++++++++++++
 init/main.c             |  1 +
 mm/memory.c             |  8 ++++++++
 3 files changed, 24 insertions(+)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index a50df42a893f..c4c5282f795c 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -2192,6 +2192,21 @@ static inline const char *pgtable_level_to_str(enum pgtable_level level)
 	}
 }
 
+#ifdef CONFIG_MMU
+extern bool __arch_has_pmd_leaves;
+static inline bool pgtable_has_pmd_leaves(void)
+{
+	return __arch_has_pmd_leaves;
+}
+void __init init_arch_has_pmd_leaves(void);
+#else
+static inline bool pgtable_has_pmd_leaves(void)
+{
+	return false;
+}
+static inline void __init init_arch_has_pmd_leaves(void) { }
+#endif
+
 #endif /* !__ASSEMBLY__ */
 
 #if !defined(MAX_POSSIBLE_PHYSMEM_BITS) && !defined(CONFIG_64BIT)
diff --git a/init/main.c b/init/main.c
index 1cb395dd94e4..07f2ddbf9677 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1044,6 +1044,7 @@ void start_kernel(void)
 	print_kernel_cmdline(saved_command_line);
 	/* parameters may set static keys */
 	parse_early_param();
+	init_arch_has_pmd_leaves();
 	after_dashes = parse_args("Booting kernel",
 				  static_command_line, __start___param,
 				  __stop___param - __start___param,
diff --git a/mm/memory.c b/mm/memory.c
index c65e82c86fed..5ee312c30f2d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -177,6 +177,14 @@ static int __init init_zero_pfn(void)
 }
 early_initcall(init_zero_pfn);
 
+bool __arch_has_pmd_leaves __read_mostly;
+EXPORT_SYMBOL(__arch_has_pmd_leaves);
+
+void __init init_arch_has_pmd_leaves(void)
+{
+	__arch_has_pmd_leaves = has_transparent_hugepage();
+}
+
 void mm_trace_rss_stat(struct mm_struct *mm, int member)
 {
 	trace_rss_stat(mm, member);
-- 
2.53.0


