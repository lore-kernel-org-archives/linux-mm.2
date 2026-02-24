Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48147EFB7EE
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 03:07:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4845D6B0088; Mon, 23 Feb 2026 22:07:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45CBF6B0089; Mon, 23 Feb 2026 22:07:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 368F96B008A; Mon, 23 Feb 2026 22:07:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 247EF6B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 22:07:30 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CB039B945E
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 03:07:29 +0000 (UTC)
X-FDA: 84477864618.04.4DD2414
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf25.hostedemail.com (Postfix) with ESMTP id 38FA4A000C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 03:07:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=npAXx+JU;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771902443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WLwpQj7UEW24aRTF++A/SJR0UpFf3Vw3VaJ5uRvm9iQ=;
	b=qZO5uiLToWWt8c3nj+E1MaUumcRthSy3JwsFyC+eWwACmPIbir/iHjhjJEsEY1swRA/ne7
	raB1T3EMQZX0sQ2oapPi7C7C4UEF6HPDcZ5GPjQEzG87sY0pqJoZ3yOlZCmHtnDmXhVrms
	LNj0hOXw2XiyLe5Zmslytr9uB/kdY38=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=npAXx+JU;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771902443; a=rsa-sha256;
	cv=none;
	b=fvXQySqhXc5XorwLq8D+tBtlN8gfGR8AFF4NXStvOrcGnFd2xktftNfWGXmdxUMBkbCtVX
	cxnkrOa1O/xTnW8qshYzoeZJMhzZiwqs1Gl6noczKS5WyZ1eu2irRv3z7e9P6HJdsPzl5p
	6XYhEOVMsRe6xDV9BbVOEsZPYDPUs5c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771902441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WLwpQj7UEW24aRTF++A/SJR0UpFf3Vw3VaJ5uRvm9iQ=;
	b=npAXx+JUUm50z6mE651FPHlsI2aPQv88d1OpSNpjsJfKXvI2mWkSc2vDWrYqTaz3IgFAfK
	eEP5pkox612VAvAMGNmnHjbhHW4UdCAWITXqCogKUz9sbg3dyvF3D7h3o+aN3xx5lwNAWZ
	aAlX17jWbftH4w6Fg3O9xcUNGWNr4KU=
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	peterz@infradead.org
Cc: david@kernel.org,
	dave.hansen@intel.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v2 1/1] mm/mmu_gather: replace IPI with synchronize_rcu() when batch allocation fails
Date: Tue, 24 Feb 2026 11:07:00 +0800
Message-ID: <20260224030700.35857-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 38FA4A000C
X-Stat-Signature: rqtwro5g7gsaq4usoiuj7431zy9jy888
X-HE-Tag: 1771902443-234530
X-HE-Meta: U2FsdGVkX19mZfwKU+uTA+/zM+jR4uzIlQL1aVkKQHSnCukJuRz2SUPaVL9YB1VoaYdqhDuBESQIR16kNDTXOCUfEw5OuZUnG/dV6IuAZrHI8p1l7LlBX7S+k1yHqdwt7QFqO+l6vCtUtxnVpVyY6hFZC+1Sxq6hklNul73OpUjUpxSutyyV6LvAqrcM1eJjwopxObYZvDokaqR5GmdIWn+zUvOnmYw48lT69vfmgbPQEmO75agHnAmsikAe0MveMT7zz5/+RkYUBhJLL1m4GvgxUriE5az4uFBoMtqYSvxsQiXUgr3+6Mfw6BqFm5FajYJ90OOaa901OL5RT3ygLPooUIzZ48+BIqpcjEwu334OtmIMfSPSoSF8Jovcd25sSej/q84PuTYNtL/U1WIb4j75D2Xw7eqWL1Yh8Ngsk7Mfjm00jlBjkVpk9ma0SeFPIgZ5i2IUDz/5vOQy+ubYdbNFYCiFvIG5GR1VGEgGpvcKhFcZVVI11hGJQJRULTRov35sa2AxWnMnXOiy+dVGgqBNT3BSKmYaYvyBcG73L1UNczMSeT6CJohyNku1MxyHxltqGUFgNdb2WxTd1c2ebBS6irv7CV3JkdsCuqnme25xA1n+43amNFHEoKQwA/H6XcXqDVjpsr35mmIRLlZHtcwryXJQt2VNGkufH8f2NnFxMb7TR4qY15NTsb9fg98bDL2xcOly3Ns1RlXq0mmEhGNb1pyYdn7+jVjw3FpBmrWwcFABLi5Q3/O2hwXhmzI5deB/yqHWpuEGTu7X8HNXx5/mk9eIpKnlR5D9izxXwhoOFj2ogn2i0U8ZU6ZHsujRM8WHIUmr4B/KB9Y53hQpBHV0KaAFgcC1AkN3kgDyUzgTdeeDc+KZ3EQi808QBC4dwg6gfbgKSrQAXt3iQ0PjlrI3qSymtpdfqgd0Wxru4divt8IF3a1uBqjn7hlX4H3JbwrYm+Dw64FevslAJyy
 UNd9hzlr
 zqg4Q1xuVSPYzkhskj+7fflB7vMLcZMuzYB7LXxS/bK3ifVJiTn1YKEXhZxcoAJf0e81/3nRbuXSPLwz9Mjj948Vr8Tx1vf/BoFYNINuvLdICSpl2AesotQgY2D+AtTNlBGoPh6h7WTU0K+mpdJSiLF2lkvL3SrweOFOCoiLD+Riycy3nFJdKTq3YEUjlktIxq3GThDJnch4bfZHqGGClemjRx0ftlyRKPWbRL+imtT35UQL4fxs4rmAu4RC4XnJ51ymJPbj6ywCNjiCcaYFglsCkT2zdRab/06dWfANqBzwEI/rJwYXumrkVlW1tkVRo4HRVlaQoHBPNPmzF0fkAG4MU574mT0UC0vuEw6Kyk09IspNAkA5M7wjuZA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

When freeing page tables, we try to batch them. If batch allocation fails
(GFP_NOWAIT), __tlb_remove_table_one() immediately frees the one without
batching.

On !CONFIG_PT_RECLAIM, the fallback sends an IPI to all CPUs via
tlb_remove_table_sync_one(). It disrupts all CPUs even when only a single
process is unmapping memory. IPI broadcast was reported to hurt RT
workloads[1].

tlb_remove_table_sync_one() synchronizes with lockless page-table walkers
(e.g. GUP-fast) that rely on IRQ disabling. These walkers use
local_irq_disable(), which is also an RCU read-side critical section.

This patch introduces tlb_remove_table_sync_rcu() which uses RCU grace
period (synchronize_rcu()) instead of IPI broadcast. This provides the
same guarantee as IPI but without disrupting all CPUs. Since batch
allocation already failed, we are in a way slow path where sleeping is
acceptable - we are in process context (unmap_region, exit_mmap) with only
mmap_lock held. might_sleep() will catch any invalid context.

[1] https://lore.kernel.org/linux-mm/1b27a3fa-359a-43d0-bdeb-c31341749367@kernel.org/

Link: https://lore.kernel.org/linux-mm/20260202150957.GD1282955@noisy.programming.kicks-ass.net/
Link: https://lore.kernel.org/linux-mm/dfdfeac9-5cd5-46fc-a5c1-9ccf9bd3502a@intel.com/
Link: https://lore.kernel.org/linux-mm/bc489455-bb18-44dc-8518-ae75abda6bec@kernel.org/
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Suggested-by: Dave Hansen <dave.hansen@intel.com>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
v1 -> v2:
- Wrap synchronize_rcu() in tlb_remove_table_sync_rcu() with proper
  kerneldoc (per David)
- Add might_sleep() to make sleeping constraint explicit (per Dave)
- Clarify this is for synchronization, not memory freeing (per Dave)
- https://lore.kernel.org/linux-mm/20260223033604.10198-1-lance.yang@linux.dev/

 include/asm-generic/tlb.h |  4 ++++
 mm/mmu_gather.c           | 22 +++++++++++++++++++++-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 4aeac0c3d3f0..bdcc2778ac64 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -251,6 +251,8 @@ static inline void tlb_remove_table(struct mmu_gather *tlb, void *table)
 
 void tlb_remove_table_sync_one(void);
 
+void tlb_remove_table_sync_rcu(void);
+
 #else
 
 #ifdef tlb_needs_table_invalidate
@@ -259,6 +261,8 @@ void tlb_remove_table_sync_one(void);
 
 static inline void tlb_remove_table_sync_one(void) { }
 
+static inline void tlb_remove_table_sync_rcu(void) { }
+
 #endif /* CONFIG_MMU_GATHER_RCU_TABLE_FREE */
 
 
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index fe5b6a031717..2c6fa8db55df 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -296,6 +296,26 @@ static void tlb_remove_table_free(struct mmu_table_batch *batch)
 	call_rcu(&batch->rcu, tlb_remove_table_rcu);
 }
 
+/**
+ * tlb_remove_table_sync_rcu() - synchronize with software page-table walkers
+ *
+ * Like tlb_remove_table_sync_one() but uses RCU grace period instead of IPI
+ * broadcast. Use in slow paths where sleeping is acceptable.
+ *
+ * Software/Lockless page-table walkers use local_irq_disable(), which is also
+ * an RCU read-side critical section. synchronize_rcu() waits for all such
+ * sections, providing the same guarantee as tlb_remove_table_sync_one() but
+ * without disrupting all CPUs with IPIs.
+ *
+ * Do not use for freeing memory. Use RCU callbacks instead to avoid latency
+ * spikes. Cannot be called from any atomic context.
+ */
+void tlb_remove_table_sync_rcu(void)
+{
+	might_sleep();
+	synchronize_rcu();
+}
+
 #else /* !CONFIG_MMU_GATHER_RCU_TABLE_FREE */
 
 static void tlb_remove_table_free(struct mmu_table_batch *batch)
@@ -339,7 +359,7 @@ static inline void __tlb_remove_table_one(void *table)
 #else
 static inline void __tlb_remove_table_one(void *table)
 {
-	tlb_remove_table_sync_one();
+	tlb_remove_table_sync_rcu();
 	__tlb_remove_table(table);
 }
 #endif /* CONFIG_PT_RECLAIM */
-- 
2.49.0


