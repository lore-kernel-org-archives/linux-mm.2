Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2C0D606EE80
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 13:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Dsirj94k
Received: by kanga.kvack.org (Postfix)
	id 15B086B05B4; Thu,  5 Nov 2026 08:22:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E5586B05B5; Thu,  5 Nov 2026 08:22:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3CA96B05B6; Thu,  5 Nov 2026 08:22:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D60006B05B4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:22:52 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6C719809FB
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:22:52 +0000 (UTC)
X-FDA: 85401130584.28.5AF9970
Received: from mta1.migadu.com (out-240.mta1.migadu.com [95.215.58.240])
	by imf16.hostedemail.com (Postfix) with ESMTP id 55738180009
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:22:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Dsirj94k;
	spf=pass (imf16.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.240 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793884970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fri77Ouh0dXSItKeLm+uZQQa1TNA6WNylQ1SLkvlG9s=;
	b=ZhspJNRW4F7F9w+Qz59TBougNpOhSvqeRu8R6uIAR6t99pQ3zuF28zTRspSQbRmQK7FyJO
	nJUiToEoimrzLzZMHWc9LOqJZ6uSVWTwXJSwTQYoUvwML7uUmcj07hWSpeGoQXpK1VbKJm
	KW135GEGAI+qHhZy7Xzm9hz/eQ+PzkQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793884970;
	b=iYd+DM4b/eFVX0Bm436yARIaZZ08KyAzEfKOU8k9DB1h+MChiXhDY6hTQjgpiRym1JY81o
	sJygE57LM+mHBg3PoRrRk31AAahzYxKeXb6KL4s3uOWVXHztGSyCUozwK2l12k9OmM/r3y
	vcRb9ZCmzjuTrA/sBRoB8BseYuK1o5k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Dsirj94k;
	spf=pass (imf16.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.240 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1lVizr8Ol+N2CmNjk66k3Xjp7AKzedZ36gloFs1PijY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793884968; v=1; x=1794489768;
 b=Dsirj94keFK2yQPh4R0UWNiVHRW1zecTCS0O7cPhkVf/h6CCJ78VevfCc1XQe/UStzPQby0f
 253umd9VTSnkuK7Rgh0UbvSGYFpzy44Qk/Jj2Gi9//iEE7L5xxv0BkU4XD6BjnGuk223TIwj5M8
 rzVNm8XT5MYHosCUVfpanjQc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1c23da4eaab331e3;
	Thu, 05 Nov 2026 13:22:48 +0000
X-Mizu-Trace-ID: 1c23da4eaab331e3
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [RFC PATCH 1/3] mm/mglru: skip redundant bitmap store in lru_gen_use_mm()
Date: Thu,  5 Nov 2026 21:22:18 +0800
Message-Id: <20261105132220.2233677-2-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261105132220.2233677-1-ridong.chen@linux.dev>
References: <20261105132220.2233677-1-ridong.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: wakx94rj54hz4yzzrtnorkpm77o5y53a
X-Rspamd-Queue-Id: 55738180009
X-Rspam-User: 
X-HE-Tag: 1793884970-63712
X-HE-Meta: U2FsdGVkX1+p3X6cmeZf9omqh+Mm2jLsi20lXsNJRtTLiJJ8slF6UVT1VUHY3Zt6OANuPspQNOxor4E6GqsA4DuOCpbl5LqJa9+HEeTgtOGa6jkV1uaHc9gL90t/n9Ly80V4ozs8FQ/w7J65WGAIyMNOiH2M2q8qPbOXicAFy6zAa1EkNGGPwKU7kmUz7ITMCbPp0U8y9yfxCENx82BFGZKjqHLpxznoe5NIxmqR18Jv3nDNYPIWKIMPEmE/3HC7VOf4g748T/DExrsOvIHnIBu0FjFvW1SQM3Upe1saYiarIQ8PuNaD426IbZsv0eXNWMDqS983YEf8AeKWfxgVK1c0HOcPHpVD9q9FQa4ugfiie5k11xBWAfHuXtCJjmY2xycVrBEFnnuGVbjErYwTrN7PmsHS1clfzsCz47IJG1ScvwxDKj/HY/4KD0513o3htKY8TxIyuQDWspubw9/1YK2edms8DxYL9btjMLYp2NXOORgIMLbz2SrdvOkHUOn2PeAbosa/Rmg5IaPkao5WFNX1nyfzF1zQYHJiBez18xpbtQ4ExWSRfPxKUgnBpluNAGko8/SDeyjtookZT6avnU1yW5bbsrE6hQMsVFsnIBs6Uk3RM8DCV0sofcZk8gsNyLsTu62r80nLpJxfptMjdpF6qoXc5/QfDyoqSZGK/ZuP2G4eGZpcXxC8lGghBNAZeIdVeA9Gr+feHamjuZCjStxtzWxs6fjmD0GhlrmVJQm7CplO2z/h8HAN8PEpY009/0qApFt5eK3x4AEp/eDVwGkbK4dZ045sZ7yaXC9CyGpq+4zbmO5Ux8DgENCcRsCXmdVWjZQ6NQt/eoMyYs7M0nqYfZeQ0Shhz3EasnSiVjJfNohWebg+wbb67HN9HurchywqtvYfdk07t5FYdASojPy+vQv+qUTT3vsqkU2BXjNKJk4spxMHd2gOHQPAbQtkU8j3Q38UCWZC7QKzZ0J
 0ORqH2RW
 xnXsefaMGcWJFo+0GEcHHkFYsBaddmha8WeILbU3QYrUC4+qA1hnuW9b/gpvzecz07bALonXPvj9cvhc1ekkhGiF5ZzAK4zcNSiqLbkJ0ugdA9sbNP+WRRcQ/j5y/ygaE2rPM83OOUXVw7Y9AJuEUEZFZKRDKJGzYhMVcf8xZR1NpJh9MWtxRyIHr3NvHMjeQpNeat37mHTSfoMvsDGaMXr+fn3niT00ZLV2SoRqV+whaK/Jm6YQWeA3RT1zOjMIVEEa8oLugadHJrm41OlzAubkkudi/X7Sz4Jxh5V66oren7p0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ridong Chen <chenridong@xiaomi.com>

lru_gen_use_mm() is called from context_switch() on every switch to a
user task and unconditionally sets mm->lru_gen.bitmap to -1. The bitmap
is only cleared by the page table walkers in get_next_mm() during aging,
so between aging passes it is already all ones and the store is
redundant.

The store is not free when the mm_struct is shared: every CPU running a
thread of the same process must take the cacheline in exclusive state,
so the line bounces between CPUs on every context switch. On x86,
switch_mm_irqs_off() returns early when switching between threads of
the same mm, which can make this the only shared write on that path.

Read the bitmap first and only write it when it is not already set.
The semantics are unchanged: the plain WRITE_ONCE() had no ordering
guarantees, and a walker clearing a bit concurrently can be missed in
either version.

Tested on an i7-13700HX (8P+8E cores, 24 threads), with turbo disabled
and the performance governor. On each CPU two tasks sched_yield() to
each other, either as threads of one process (shared mm) or as one
process per CPU (private mm, control). Context switches per second per
CPU, median of 5 runs, averaged over 2 boots of each kernel:

  CPUs   shared mm              private mm
         base     patched       base     patched
     1   1114766  1106870 -0.7% 1104512  1109284 +0.4%
     2   1086513  1110204 +2.2% 1110334  1112209 +0.2%
     4   1085872  1112258 +2.4% 1113146  1112467 -0.1%
     8   1085945  1111371 +2.3% 1111662  1111876 +0.0%
    16    660870   666748 +0.9%  665470   667058 +0.2%
    24    579382   596472 +2.9%  596177   598500 +0.4%

The 16 CPU case uses both SMT siblings of each P-core, which share the
L1/L2, so less of the traffic crosses cores. With the patch, the shared
mm case is within noise of the private mm case.

will-it-scale context_switch1 and sched_yield do not show a difference
(within 1% for both threads and processes): sched_yield runs one task
per CPU and never switches, and context_switch1 leaves the pipe peer
unpinned, so most switches stay on one CPU and the line does not move.

Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 include/linux/mm_types.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 1ed35d258d2e..3680cc0fd714 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1553,7 +1553,8 @@ static inline void lru_gen_use_mm(struct mm_struct *mm)
 	 * used since the last time it cleared the bitmap. So it might be worth
 	 * walking the page tables of this mm_struct to clear the accessed bit.
 	 */
-	WRITE_ONCE(mm->lru_gen.bitmap, -1);
+	if (READ_ONCE(mm->lru_gen.bitmap) != -1UL)
+		WRITE_ONCE(mm->lru_gen.bitmap, -1UL);
 }
 
 #else /* !CONFIG_LRU_GEN_WALKS_MMU */
-- 
2.34.1


