Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDCA8CF64BB
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 05:40:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E1296B0006; Thu, 20 Nov 2025 00:40:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B9116B0027; Thu, 20 Nov 2025 00:40:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F5BC6B0028; Thu, 20 Nov 2025 00:40:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 229A06B0006
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 00:40:28 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ACA5C5A9E1
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 05:40:27 +0000 (UTC)
X-FDA: 84129885294.20.882E9D7
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf08.hostedemail.com (Postfix) with ESMTP id E30E616000B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 05:40:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nXegfjf6;
	spf=pass (imf08.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763617226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lgsFxspkgu6YkSyWhEfGfez4tdMFOsL2gZAGZAzxZjM=;
	b=jIW5dAVbVdcHo0m7TTqHRTRtyrTv2Q1Mb0QLIsojOrRXva/Tig7R631zivkSS9qdRM8k1u
	WvKZvbe60EI/l6hQ+EfzIjs4ml5KW80bwubelOli7xXT+Jl/kJwut0Jd8c2LTWbe/LyOk7
	8QHC0FMIrJ7u6d+no7JkjyNxyQiCvFE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nXegfjf6;
	spf=pass (imf08.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763617226; a=rsa-sha256;
	cv=none;
	b=EfEJ1Iw33mgODiZ5rK1DF0wE4HgM/kadb4wd4FakcrB8fqUBRxliidBDoby81fxBnwwtsf
	5vApnyqBBbUp2yVYWi+jMcNgTtV8lKQ4Ca048qfoaPoOSwvOgcWva6th1XDNYY9Arh2j3F
	D+QHihFvz6EZNbOnMQyP0mj/V35y2xg=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-42b32900c8bso236197f8f.0
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 21:40:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763617224; x=1764222024; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lgsFxspkgu6YkSyWhEfGfez4tdMFOsL2gZAGZAzxZjM=;
        b=nXegfjf6/BmVhGVtWo3Mqr5ZkZXSUhoVqzo5W3DnZOrHL3zpXccaXzwOTMBe5gLAuD
         cb9ebqc+6BjtAF2wDkpqtcxaUIMa1+7ScqPdFFjL+dB02qpx5+ISm+ue4mLzbFDzbueU
         3BOmNbpPpFrT2J8+yHpnhTWTGgGe0a0hqVGRhKUty6SO9W8CBtMEVlbj2UHCX8Jgivz8
         v8KRQIfxsAR5J8nTjrRwS05aMMtYAA4iL8ahN8Qw3RRAk6QV8Vyi+CwQRQ22hF9JKzOI
         ceHaVF+bZY4/84ExzusXgk52Z4cxbN2/4cwddxmmkmaKdIMlMpgwuQSXSd/fxzuNuVZA
         D3Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763617224; x=1764222024;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lgsFxspkgu6YkSyWhEfGfez4tdMFOsL2gZAGZAzxZjM=;
        b=EeQa01k9ZM0Mdnndfl32hud52uF5pxFvRbYkj/i3borbddPa8F87wQ/dRNSA3Y3GeC
         J7kBoNk1tZagenWBssP//80L99vaeiYkKs/VY8LZiO7nXym6XaGKGRJuLe2Wj7Q16lrX
         Y/VbSkIJJFGb9ZKCDUu7qxSPxtGfCVUg6/eoeP90RexqxCqiUBg5fKY35qdkSfPw9iFc
         TOGbkk3fIT64UuVBCHfk7CPbmyaEE9kJIqj3OwxLmSXL/DFu0+iSJxWFsLEJ0KSzCnXX
         RNNOYq6Fz5dPROy64ygA7HfsGj6TJaJJZCRC9KA/bxtimhJ1tb/eKGDKUHEgbb7FSXOw
         g+DQ==
X-Gm-Message-State: AOJu0YwdYOx38i0EqsV1aTiocLdmwDcdVjZkIdBzc+XqSulURitskDuj
	g9dHx/pTHpFkCcfzDGYTa2uLnTkzKC85ljIvr72KX3T2n5s4z12ntvwD
X-Gm-Gg: ASbGncsGefogQnjFuCfWhJbXVjgQe+/bxQD5AslrDJwk6N6gPHD3YuQn9+hq02B5iXi
	lcRjPA8YX8SPjY1HPoQJF8i5XobwSPTZQUmYLVJRW+Tp5mBUQeabcMsIZdCC+XN80YLE3qJW878
	5S8fsgvbVb/xJdjLjCqLPUNurfV/eI+G+4widYTSWasX9t7CQ4pPyhoWWtFbnWlSNa2VhsPcvoQ
	FQ7J9vO4rgU67rZcwuDa784usyO+/G7D0CgcNgL3vLWX732cQ1HfIN+D1XZR+fMeopdJ3Ut0jaO
	HbCXGD96Cqv86RTmYg6JMsWjMPzLRKsnKiOMF9D+DXeutFbnqL73VbebQfYpc1NP6gVbHUqFCh9
	wBmblJ9QNLVK46ildqzp+lH/enbDvs4CMNNpm5xOdJOdzX3wNcfxTc/1SXIaXb/mzIrHY/jLJkC
	hXaFDBt3o8NUzV9dxWyVAWQVNvlXwr07Syh99Gr+cn1R1n2731t4rBGADc32BXinmGneK+mA==
X-Google-Smtp-Source: AGHT+IH9uRFnEuXcyVZFjmbxMJ9g+G/ei31Iz24NIjvAUivA5C+Hz9chFyY9I577kjh8wUI5YXlVOw==
X-Received: by 2002:a05:6000:1885:b0:42b:3afa:5e1d with SMTP id ffacd0b85a97d-42cbb278409mr595748f8f.20.1763617223990;
        Wed, 19 Nov 2025 21:40:23 -0800 (PST)
Received: from f.. (cst-prg-14-82.cust.vodafone.cz. [46.135.14.82])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7f363c0sm3124639f8f.18.2025.11.19.21.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 21:40:22 -0800 (PST)
From: Mateusz Guzik <mjguzik@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linus.walleij@linaro.org,
	pasha.tatashin@soleen.com,
	Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH v2] fork: stop ignoring NUMA while handling cached thread stacks
Date: Thu, 20 Nov 2025 06:40:15 +0100
Message-ID: <20251120054015.3019419-1-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E30E616000B
X-Stat-Signature: s3f5hjtjh6fx9wmoomfx9stwyiem8ewm
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763617225-996354
X-HE-Meta: U2FsdGVkX1+mI7yLr4J2QAr16sby3pU4J8OamtXeNqExKAxLiAZh7s2j55/rV7z8V0wcYffvhHZxVTP34Ou5gN/7wur3dFZA7axsMD3FPqz2ELlTVTe2bz6b1mlyQSMO1op2HBl/EkapMCDNlCrFHbJUCl3hlWicSgDqvDbbIoYX3AiYH1usOHoAUh06NtUTcNkqaRRkxU0hT4rsIR/CYdLPyPIdJACPmt739SkyIq+AUbvg5GB31m6gmS/sGCB+NR49dpadJDhktWbcWcPhls6RsPI6iguxbVYwmvGBXmo44I6pHWgYGjWB8ypysm2wb5lOsoKaL3Xg+4CP0PD0FoIuHj6Vzqy7VbTCUT/ZN26i4B173wcy34UVlLJTvQU1Rd/MRK7TGE/7X8h5cbMgfCeUIdDJIyZ3mywhwQTLn1WSFRf1+3wX4n1NOysgTagTTMSm3Ge74NiBbGK4TVizdP8CLT+zBrm+u4fv38PonQOKbbfD0IZTMsBs5sqyIkfoap+5PVoYeARtOTe0JwAHt0eBSPCMmgYTsWaMpYfAB0acKF5GSbVfYF144TxQ63LdkXfVHcQjHkiwX1eZ3h1cDeW2ZdnTtA73wqNgFHCdmkFYN1HsNiY3h8LXTYFwfiEWY3D/q+OzlHl4HYmf1CUmSmOESHJM6HHsJ/+cnYNp8mnYKNfYXoPKTPR0Wsh4vKjHPsJ8JnG8TEIGM5Vj4FGKFbGEJLxqJUDq8ekEXsa4zvsuSWfjqd7a+P2rOINixR+ngG8H0MjerIoOUujdfCwxc2kDxBqjBGDpbLfXC+POrSLZzhx/s1EKxbeP/y1YfdTiWStR0EQf8kF5ZjDgTj5WRQmarywWDHrL7NdFefIchBseXIZ8j688poh8ZTWRGzc7yRa2iV3TG6a4zjSw8HKjefLO4Yl6fp86GqcyC9Xrx8hCCIx1RSapA2xpG9R7ubFD8UVatCWi4bvvTPNO2M0
 dZ1jF+2I
 77m9c8uXiSyGPP474bkgx9Sutpp5qkc9cM1lHkKWJwpR/i3C0C8iudByZ5GfY+3sjPytJnKfIe1qdEAtuD5Ar7xmzjxkVMO/XWy/Pc30idPVwXlhekGH1N7LJG8NMxvezZbFEDj41744MmLeFxUDp1JuC6lyH6ZEbSBNhZ1a97MAQOymcjrN4zRwQvOIPYbA39Yb29PxScgN1mlCIYvKR6lXkp2zJ2xGR6VVmxiTHNTG7drI3OP3TYKwzHiWvRA6IV0VbaesBueQ/WfORoOIpVL9j0tobsUzA4OXA9Z3sxezji7mL5E4OgKihi2S1/geQe3UBQWLrpHz9itok7I4uFCmJC45fCIGdNseDWZJRs2WeZ3C6st9gxGWG5k4QqMvJ0CEDlim9TUMy9Ufz8Mb7NUy55FrZpvinPI1g
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

1. the numa parameter was straight up ignored.
2. nothing was done to check if the to-be-cached/allocated stack matches
   the local node

The id remains ignored on free in case of memoryless nodes.

Note the current caching is already bad as the cache keeps overflowing
and a different solution is needed for the long run, to be worked
out(tm).

Stats collected over a kernel build with the patch with the following
topology:
  NUMA node(s):              2
  NUMA node0 CPU(s):         0-11
  NUMA node1 CPU(s):         12-23

caller's node vs stack backing pages on free:
matching:	50083 (70%)
mismatched:	21492 (30%)

caching efficiency:
cached:		32651 (65.2%)
dropped:	17432 (34.8%)

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---

v2:
- add commentary to try_release_thread_stack_to_cache

 kernel/fork.c | 63 +++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 53 insertions(+), 10 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index f1857672426e..b52b4ac8fe10 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -208,15 +208,62 @@ struct vm_stack {
 	struct vm_struct *stack_vm_area;
 };
 
+static struct vm_struct *alloc_thread_stack_node_from_cache(struct task_struct *tsk, int node)
+{
+	struct vm_struct *vm_area;
+	unsigned int i;
+
+	/*
+	 * If the node has memory, we are guaranteed the stacks are backed by local pages.
+	 * Otherwise the pages are arbitrary.
+	 *
+	 * Note that depending on cpuset it is possible we will get migrated to a different
+	 * node immediately after allocating here, so this does *not* guarantee locality for
+	 * arbitrary callers.
+	 */
+	scoped_guard(preempt) {
+		if (node != NUMA_NO_NODE && numa_node_id() != node)
+			return NULL;
+
+		for (i = 0; i < NR_CACHED_STACKS; i++) {
+			vm_area = this_cpu_xchg(cached_stacks[i], NULL);
+			if (vm_area)
+				return vm_area;
+		}
+	}
+
+	return NULL;
+}
+
 static bool try_release_thread_stack_to_cache(struct vm_struct *vm_area)
 {
 	unsigned int i;
+	int nid;
 
-	for (i = 0; i < NR_CACHED_STACKS; i++) {
-		struct vm_struct *tmp = NULL;
+	/*
+	 * Don't cache stacks if any of the pages don't match the local domain, unless
+	 * there is no local memory to begin with.
+	 *
+	 * Note that lack of local memory does not automatically mean it makes no difference
+	 * performance-wise which other domain backs the stack. In this case we are merely
+	 * trying to avoid constantly going to vmalloc.
+	 */
+	scoped_guard(preempt) {
+		nid = numa_node_id();
+		if (node_state(nid, N_MEMORY)) {
+			for (i = 0; i < vm_area->nr_pages; i++) {
+				struct page *page = vm_area->pages[i];
+				if (page_to_nid(page) != nid)
+					return false;
+			}
+		}
+
+		for (i = 0; i < NR_CACHED_STACKS; i++) {
+			struct vm_struct *tmp = NULL;
 
-		if (this_cpu_try_cmpxchg(cached_stacks[i], &tmp, vm_area))
-			return true;
+			if (this_cpu_try_cmpxchg(cached_stacks[i], &tmp, vm_area))
+				return true;
+		}
 	}
 	return false;
 }
@@ -283,13 +330,9 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
 {
 	struct vm_struct *vm_area;
 	void *stack;
-	int i;
-
-	for (i = 0; i < NR_CACHED_STACKS; i++) {
-		vm_area = this_cpu_xchg(cached_stacks[i], NULL);
-		if (!vm_area)
-			continue;
 
+	vm_area = alloc_thread_stack_node_from_cache(tsk, node);
+	if (vm_area) {
 		if (memcg_charge_kernel_stack(vm_area)) {
 			vfree(vm_area->addr);
 			return -ENOMEM;
-- 
2.48.1


