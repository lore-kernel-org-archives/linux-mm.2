Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD1D8606A31B
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 12:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LrSeN6Ms
Received: by kanga.kvack.org (Postfix)
	id D95BF6B05BD; Mon, 26 Oct 2026 08:23:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6CED6B05BE; Mon, 26 Oct 2026 08:23:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5B556B05BF; Mon, 26 Oct 2026 08:23:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A29F56B05BD
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:23:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2198AC06E6
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:23:41 +0000 (UTC)
X-FDA: 85364693442.21.236B647
Received: from mta1.migadu.com (out-20.mta1.migadu.com [95.215.58.20])
	by imf18.hostedemail.com (Postfix) with ESMTP id 381F01C0002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:23:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LrSeN6Ms;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of liu.yun@linux.dev designates 95.215.58.20 as permitted sender) smtp.mailfrom=liu.yun@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793017419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R3abIAHkCndJWOaESG+STfCpled7+lksS6AZrZBon/E=;
	b=uJ375XGDjznxJ7e5i9bKK+THcYJ8iwSASs2pzf5KogFIBQWsZm+px9qeKblw4J7iQOKj2C
	jobWZvgHBsZnD4co0z+1bQwYVyOhrlv0RuytBbjlRkvV9IM4JYd/7n8FlVminion+WQiJk
	EmSAsp/w/5yGBhldv+ahWMHWl9G7b24=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LrSeN6Ms;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of liu.yun@linux.dev designates 95.215.58.20 as permitted sender) smtp.mailfrom=liu.yun@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793017419;
	b=1RxVldkTpgIZ3gjNxqy7nco/89MSoxWc8T3WAyoLbLXVJKRXjlSyLgbDOA4c7WfXVxe0fM
	AiEZYrNuXDJXQKJgA+0HYgprVbydf2twBuAxKqlJbSflUGUjTQhgwbeZ7E36wAaGKBSy8Z
	tAki4RZk6CVtVpP5GwisJJO6HQrK8I4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=BRur1T5Cd7MQHpgJV027Bta+ISLyg752XtPnkNJ+VCg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793017418; v=1; x=1793622218;
 b=LrSeN6MsebCIoP9emGJYMgt74P4QehJ17BhTse5aybDMq/SaLtk/eSJW2C+9EuKKNcgrniJV
 7VxFSi7f2VYyn/Yi3v5k9D5Aqx1FczpiS5HDR5xPhrWc5BF8nMZtDJNyLZyLdz09eAkIEF1xMdN
 xXHkI2bHb3B5yjwI2JapJRdY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id cf25d12802c1723f;
	Mon, 26 Oct 2026 12:23:37 +0000
X-Mizu-Trace-ID: cf25d12802c1723f
X-Migadu-Flow: FLOW_OUT
From: Jackie Liu <liu.yun@linux.dev>
To: glider@google.com
Cc: dvyukov@google.com,
	elver@google.com,
	pjw@kernel.org,
	alex@ghiti.fr,
	aou@eecs.berkeley.edu,
	linux-riscv@lists.infradead.org,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com,
	muchun.song@linux.dev,
	liu.yun@linux.dev
Subject: [PATCH 3/3] riscv: keep booting if KFENCE pool reservation fails
Date: Mon, 26 Oct 2026 20:23:04 +0800
Message-ID: <58e3baebbf4e454725e6bde8b7a267fb71cfdaae.1793017074.git.liuyun01@kylinos.cn>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793017073.git.liuyun01@kylinos.cn>
References: <cover.1793017073.git.liuyun01@kylinos.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 381F01C0002
X-Stat-Signature: zox8jix6jgjdnqzyaf3kwbf1z4ougpn9
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793017418-419743
X-HE-Meta: U2FsdGVkX18n72WT8gZnuTz8XEfRr67RUj4QsqCYm10PKZui512SsZ9RnXwKlqmfBygoOSghd0lILqns6nkyfZ8MXuhO42XH24Kykk2qbMjuMXvdlnf9UCoU4fjjc+JCVvu4ZCZqczjaoFNdX3uekSa2ltfGmnhubelzcxCwq9+AvLt62erhXmCkfKe/FoUWM498wC0gjNQKndkB83/AILoNVHufGdGEXO/DXf4C+k5gdAF9sFfymp1J8NozIL+T/hpbu5QiTZn2QqSwYELL6gobRHEPcC8SKJK//WDJLWoZY+VwQBlLJBidbtboHEy3FtK6cQpb6FOlT59vVZqWtbMF5/IWS1GF4AuATQbpE5NWyISdqw1/gsl+R2fYmk+a8/fJClp50VKy4iEm6rg9Esr2sDhnDhDtaeK0HL/lrB5D4a4Njjwb4+l77UU6xf4RaSSlIGU+tGkJuEq68Gpp6i9J9HFPqbUzCgQ1kaVi+Yy4J9Q2vRIh/vP/9gMmYNllNnIQdzEXvMsrO6NEGOxicWz9Chn6CllfgJzy0oPhtRjSxE1+NkQ6LJ699axLysVrafjYl0d93QjroPHgy+0LgRLFV2Whr4RhNQMWLJYMGtwdnDQaIY9FxOMwNBX/6sxhuaN5jDqm5RyBXNhiZXJtRqSt/UYd1T3xnaANWtRZ5SC4M5uUwUPaQUeFA0DIbkgQm2SgEMnwC7iB9bPitAfOEOKCxHcZVN+1QvoQCnZuuC8LOL9mDCkdQydd03sPLRdJ9hzrtqThjs4Z7zO0HDgGYXE8DixcPnqHFTgZr+o7WnTRj5nc4+haTlS4FNvvqhY0GJ2eokjIdLEotTqJ6jKUl/QqeL7eDdvekp0c0+X5C6EKTeOP/3GicTBFOgznGZk+zzkmKdheihw7Yv0+NESSSSqJjsn/PK2RWnCkP+4w4NrcZLYfVC71Hy4qoWvmlj2xOZK3Ca0rRv7huFiTRVK
 Z/R336WY
 TBiTQkZ1gYrIIlZ6doAVW3glxUWHKoh4sN9fW3Fb9HUiHGXfiKm9eKJYUMXZ4kzB9Q5L444u+tdt1CzdavPlu1F+7NzZrZWyY6xSr7JOpdoDROcNjX76M8YneVxSkL1Pg4p/8e0XmyRBzJ8Bl9n37heP6bbifpIimhlBxLP9jt2Iq9KbIBdfltHQ2geRuhQw7NTArvl9XHxz9MjEEw8FvnMPpPJzuw34iFEuGZRG5SWlWvqKxYf+p3tKL7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Jackie Liu <liuyun01@kylinos.cn>

A failed KFENCE pool reservation hits BUG_ON() and stops boot. Continue
building the linear map and disable KFENCE if the reservation fails.

Reject later pool initialization as well, since a replacement pool may
have huge-page mappings that kfence_protect_page() cannot handle.

Fixes: 25abe0db9243 ("riscv: Fix kfence now that the linear mapping can be backed by PUD/P4D/PGD")
Cc: stable@vger.kernel.org
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
---
 arch/riscv/include/asm/kfence.h |  4 +++-
 arch/riscv/mm/init.c            | 19 +++++++++++++++----
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/include/asm/kfence.h b/arch/riscv/include/asm/kfence.h
index 29cb3a6ee113..57e57426a7d6 100644
--- a/arch/riscv/include/asm/kfence.h
+++ b/arch/riscv/include/asm/kfence.h
@@ -9,9 +9,11 @@
 #include <asm/cacheflush.h>
 #include <asm/pgtable.h>
 
+extern bool kfence_disabled;
+
 static inline bool arch_kfence_init_pool(void)
 {
-	return true;
+	return !kfence_disabled;
 }
 
 static inline bool kfence_protect_page(unsigned long addr, bool protect)
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index fb37b0b67efe..393106cd25ba 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -27,6 +27,7 @@
 #include <asm/fixmap.h>
 #include <asm/io.h>
 #include <asm/kasan.h>
+#include <asm/kfence.h>
 #include <asm/module.h>
 #include <asm/numa.h>
 #include <asm/pgtable.h>
@@ -44,6 +45,10 @@ DECLARE_BITMAP(new_valid_map_cpus, NR_CPUS);
 struct kernel_mapping kernel_map __ro_after_init;
 EXPORT_SYMBOL(kernel_map);
 
+#ifdef CONFIG_KFENCE
+bool kfence_disabled __ro_after_init;
+#endif
+
 #ifdef CONFIG_64BIT
 u64 satp_mode __ro_after_init = SATP_MODE_57;
 #else
@@ -1229,10 +1234,13 @@ static void __init create_linear_mapping_page_table(void)
 	 *  for this region.
 	 */
 	kfence_pool = memblock_phys_alloc(KFENCE_POOL_SIZE, PAGE_SIZE);
-	BUG_ON(!kfence_pool);
-
-	memblock_mark_nomap(kfence_pool, KFENCE_POOL_SIZE);
-	__kfence_pool = __va(kfence_pool);
+	if (kfence_pool) {
+		memblock_mark_nomap(kfence_pool, KFENCE_POOL_SIZE);
+		__kfence_pool = __va(kfence_pool);
+	} else {
+		pr_err("failed to allocate kfence pool\n");
+		kfence_disabled = true;
+	}
 #endif
 
 	/* Map all memory banks in the linear mapping */
@@ -1253,6 +1261,9 @@ static void __init create_linear_mapping_page_table(void)
 #endif
 
 #ifdef CONFIG_KFENCE
+	if (!kfence_pool)
+		return;
+
 	create_linear_mapping_range(kfence_pool, kfence_pool + KFENCE_POOL_SIZE, PAGE_SIZE, NULL);
 
 	memblock_clear_nomap(kfence_pool, KFENCE_POOL_SIZE);
-- 
2.56.0


