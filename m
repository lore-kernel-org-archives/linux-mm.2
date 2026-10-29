Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 450F7606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 02:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ayKvmx1U
Received: by kanga.kvack.org (Postfix)
	id 66ED76B05BB; Wed, 28 Oct 2026 22:58:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 620776B05BC; Wed, 28 Oct 2026 22:58:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55C226B05BD; Wed, 28 Oct 2026 22:58:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3630F6B05BB
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:58:31 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3CE52802AF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:58:29 +0000 (UTC)
X-FDA: 85374155538.06.3579A9A
Received: from mta1.migadu.com (out-248.mta1.migadu.com [95.215.58.248])
	by imf27.hostedemail.com (Postfix) with ESMTP id 451BA40007
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:58:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ayKvmx1U;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of liu.yun@linux.dev designates 95.215.58.248 as permitted sender) smtp.mailfrom=liu.yun@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793242707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gZgpukRZ3ONYn5LrudC9YgJOnnXQHAuBJyN8DzecXnw=;
	b=zgs2JYneB2j+22GqmjsnPt5bAvehXSORhcKOuJ6I57mqNv3lNStKoN4KGhAfWlzAX8X9pC
	xWvBfVXFuoqGAe+rFQ9hUZPJtVNWnQ2ciJkkEjWgk02KSpQf7P1X+bOmwTyCGIZlb1rW1w
	dWW4s5cdg9wHvU2NBoaAwYtdkOlNsVI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ayKvmx1U;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of liu.yun@linux.dev designates 95.215.58.248 as permitted sender) smtp.mailfrom=liu.yun@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793242707;
	b=XftE/JA++E66Sv6Rm7h9mOkLguDgGJTVGvTQQSW7GWJsEKyq5hH+pkokCUhlA+p/2jVckT
	RQW78RMa03F+B+d3laiPqYy9zfHBZc8+yHTPMJQceEuv8ktOkeaUK6HolpVj+3BfX8V37F
	8kb4Tqgdup7/5aIXgNkPH6y9TNfmnmk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=IOASzesMbM4eHTQzEez6pJBMj2nIGy+p6tHQblyQMCU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793242706; v=1; x=1793847506;
 b=ayKvmx1UwgdQNtrZCefFZiHvhll2KpFOIgcCOatl7GZx47j+KSAleiorCIeX3auSUlqj2bRA
 uEHtZqKcRTNU2qGx0ZsyQjmlbcQa/KS+2ILIorjN3Bbc/gE5C6ZK30UTXu9rdzeUzzyRegogK5p
 wGtG3f/ebjrQcTkvVWAxaPNY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1e60097e1070dd10;
	Thu, 29 Oct 2026 02:58:25 +0000
X-Mizu-Trace-ID: 1e60097e1070dd10
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
Subject: [PATCH v2 3/3] riscv: keep booting if KFENCE pool reservation fails
Date: Thu, 29 Oct 2026 10:57:43 +0800
Message-ID: <44fbd039a5cd78bfe7355ccbafb197775dede29c.1793242457.git.liuyun01@kylinos.cn>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793242457.git.liuyun01@kylinos.cn>
References: <cover.1793242457.git.liuyun01@kylinos.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 451BA40007
X-Stat-Signature: 6oc3qq1zah1aigr648kntn6mayk9kjah
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793242707-785264
X-HE-Meta: U2FsdGVkX1/iCKyGx5XPjUU4grKYggMiNCg8MXytjMCqfkcINLK5x48qMqfjTSHJ8jru+FKJVsZ8ad2EbIjE/WiYz8oDHBBkVztdMcEaJ0WLXZeBbD/eYyJxxxJFTMEDjPxL5drZz1neYsO1V5t8XuyuQqILj3LrlTGNiLzYbbwK87245Vb9TW2Sem1Sy3gqyVYOOniKcv+kYsfl6Hzz5Q6S77mdYOOfcpap8uRw7AjwIYZgDzAdovWPqxaXDDZAisRfcsOBSlmR3bKDN0B32XhRTGHbzG3h2Vfvmt73XcaGVH7tfJaJyo22UwxjqneDAbxHF6k3qJqnQMISkBFfvpWBNjRs58XvfWbXeboeowT6sfYtgprffJiCoid3x1JqeQnT/K7uBIpMcOlWaXdSdA2NnpwbPPNIt/iwhfobl149nJl6iyds3+M6DMYNoDnbEBaB9oOPglnE9dVrGYgGil/w845IWt9w7l4w/rHfFdn3no2qKeA+aiTkHTFvuk88KwtbKnBVHXRHSeV7KbcRMEmN7veKlyhmNm+tHDMlA8tAtvu6yfnVczL0TXj/M7waLrPGvwRJ1PhU3FJzpNgZ0I4pUXI/Ko8Rz0iU+thL24mEXGi9E28a3cONM3Unifh10ko7euiuKXbg6VVmd9wI8PkxPz+5qIGPonrAcWoTaGgHNQlDJzZDoAFbDAufSCOdC9pCNYZmX4AbuAjpf0mDOWbPCSk80MAb9wLOLTWuEelyj7T6Ppr2TZNp/vYHzlo/FUyVkMOtY3F2mZSPpVzqZkR94aNjwUVSgdXEZszsfJviD/Hkw2z7UkuyBpTqT1Dbtk0wfBY/HEzu7JaVQakFVVwET839kOWBOFxwPrqRgjovE3zCmVnk9gPZMo4v7YO5hq2gNLKEUzEy2drVQ0voiXAiwzfKxd7qLZBJ4YvtSRt/xNvD2OP7j5Jz0g/O/ueDo/zSdLJLo6m5ErzDd8/
 SITq9nGI
 EguTp7FsyAZYqyx5gIPw1qKlAKj8aWwZ2QH5dVPCfGSVvpshcKZ11nPd2hZAmEw5NyzLsmAEFmmtM4shPbvFuvhlplVfv/v9IZ0kwGWiiP4geA+/F0775H7hHVa6OKkdqARhg32coWF5Xme9PDCr2f8Owb5CK9zCAsdXQPpPzTCBLju1eoU9BmT0D4+blZiFtweyGX+6nVVKxQS0tq7k8INOp0L6tWol5K5cx8UPWs74TS2uPKb7M8qW5UWCepnpYne0NSs8lyvTWabcavIHvfQZW1oc1hiW68x1g
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

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/cover.1793017073.git.liuyun01@kylinos.cn?part=3
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202610290904.wbrEL97y-lkp@intel.com/
Fixes: 25abe0db9243 ("riscv: Fix kfence now that the linear mapping can be backed by PUD/P4D/PGD")
Cc: stable@vger.kernel.org
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
---
 arch/riscv/include/asm/kfence.h |  4 +++-
 arch/riscv/mm/init.c            | 18 ++++++++++++++----
 2 files changed, 17 insertions(+), 5 deletions(-)

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
index fb37b0b67efe..d21be990346c 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -44,6 +44,10 @@ DECLARE_BITMAP(new_valid_map_cpus, NR_CPUS);
 struct kernel_mapping kernel_map __ro_after_init;
 EXPORT_SYMBOL(kernel_map);
 
+#ifdef CONFIG_KFENCE
+bool kfence_disabled __ro_after_init;
+#endif
+
 #ifdef CONFIG_64BIT
 u64 satp_mode __ro_after_init = SATP_MODE_57;
 #else
@@ -1229,10 +1233,13 @@ static void __init create_linear_mapping_page_table(void)
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
@@ -1253,6 +1260,9 @@ static void __init create_linear_mapping_page_table(void)
 #endif
 
 #ifdef CONFIG_KFENCE
+	if (!kfence_pool)
+		return;
+
 	create_linear_mapping_range(kfence_pool, kfence_pool + KFENCE_POOL_SIZE, PAGE_SIZE, NULL);
 
 	memblock_clear_nomap(kfence_pool, KFENCE_POOL_SIZE);
-- 
2.56.0


