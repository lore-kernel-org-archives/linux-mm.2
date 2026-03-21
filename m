Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55DE5109446F
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 18:06:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 553656B0102; Sat, 21 Mar 2026 14:05:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FCFE6B0104; Sat, 21 Mar 2026 14:05:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39ED86B0105; Sat, 21 Mar 2026 14:05:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2661C6B0102
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:05:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 03AED1E221
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:05:58 +0000 (UTC)
X-FDA: 84570848838.03.3AB5630
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 04AC7100005
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:05:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VzoOgJeF;
	spf=pass (imf05.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774116357;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xiSjq492qXxUM3w3Tc+xm/bvX1cQIoVZwpRq7b6XNFw=;
	b=YaujS9adWDmfpcgvuRtuApF6Np2UOulmITmwx+52gHHzvw8kSvud1GvUvUZogxAuW3XsqT
	aMRFHvJNrAwGYjwZb6ElJ9zAPt4vILPQjDLVbLZ+sbN9U2ub4UvrLYsSfR9p+LKWOUcD7o
	f2hxWzD6CZU9sfXgwz8qXUR01nY7qCo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VzoOgJeF;
	spf=pass (imf05.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774116357; a=rsa-sha256;
	cv=none;
	b=q9QQupCfMP1tJE00E79tqnhGTnOq8AC4h4SLNUT/ghmsqtWhlkZDXt4qLmODY5gXFxpz2m
	Z3X3wHCHTEaBZVqX+kIbVFEMTrZgQi4FD6uERXm3BO7aobaxFo8bR+Di2N6vpw9/Joe88m
	O37tGgCBV6TV2DG49qsJUcMD6MT3GVY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BCF5E40C56;
	Sat, 21 Mar 2026 18:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A21D8C2BCB1;
	Sat, 21 Mar 2026 18:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774116353;
	bh=9bqC5ujVWHb7sWXrNInVzlf5UOUlvn2ar1xzfw2jX1I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=VzoOgJeFrP3udqQQTFkc225kZwa2LrjN4eBtMprzGpM5CSTqTfvOagYMOTBpK0byL
	 /E7NO7rzYd63+oMCUGcFeQV7kgBqq6Ob47gPb5EQGUjdIopLVU/8bFPwRSNS0lXfPo
	 73RWLFH2mFoMkVQHJaGRr/tmdBWLTU7g9G+ZBCH2qv5+YlTOdF1OC023QDErAAGMJB
	 YcxqX/JVSppS1R+FDP02dcMl9FJSX1LGwBSHEIPNIxnkkZYkgJekHJrpA3Htzg9pbs
	 V3DKG6+wDf58gdFbyg5IUN5MLlM0b7cH4FJQ5ML5kI6ltumW8psNRWYNOmnBSv8af/
	 v3Isg5cGrxkbQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98B1F109448B;
	Sat, 21 Mar 2026 18:05:53 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Sat, 21 Mar 2026 23:35:51 +0530
Subject: [PATCH v6 6/6] lib/test_vmalloc: add vrealloc test case
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260321-vmalloc-shrink-v6-6-062ca7b7ceb2@zohomail.in>
References: <20260321-vmalloc-shrink-v6-0-062ca7b7ceb2@zohomail.in>
In-Reply-To: <20260321-vmalloc-shrink-v6-0-062ca7b7ceb2@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774116351; l=2829;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=CtQwnpMQocxytVG/1g8li/Ip2q6UVo/IWXgqeQX4pgY=;
 b=2kxGypkdmPFqpovzEYndnxajXkv892H1Ygv2DTuJh3mpZUYOsFS0e2md3H5567P88Hlk1ecoQ
 DKohaljaoF7BQHlLow50Jup+4M+3hcKIzHBhcn+6/9Nh2ApcvG3RTF6
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Stat-Signature: rcemoehtmu1rtcx9eus4ted31s5375fp
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 04AC7100005
X-HE-Tag: 1774116356-40334
X-HE-Meta: U2FsdGVkX19CE0T79dSFk+nyxcxNXqF4DtOs+GJRUFmsLdM45g8boY7I34ZeonnRDK6+HS06M0rjrkQBxTzZILSGBOIuVTgh0SRpfuBSfMHMFMdUrS+EtlB5yoiD/ZBd4nGonUkmuRsjcWEnT1mPgfz7hGpB/U+ODOrNTuWYp2YdRBU7hx9pfi3mFfYEckI571Hm1MO5eyz5e6TdqmzVLHixiwz3XYw+zPEP7eK0FPZtdBKZYM71aMbz44d6IzrR0MaztkW9pLpj1oU68x48fQDy+DFKbc0VcCwanfngnMUhWhP5jINGndsxMjt6rphTr6abwTGNTwnHS2AcQY1cfPqyHkyng2Vl+bHLJCLGYlWEUWcXFMksH67NhiE2WpitTqOe8H37wNkhHI6gQMKnE7pyWhxBmnnPBYQnW3RSIKUvKkwIxTKOFkYbvyJvJx9jglicuUuDwqbZ8QM063plh6nSVkUNw/T+ik6uXvGEp8PmOLnh4rYwN53cIzSE8Wo4pEKdkmxWR3+T7Lytc+9+CS4BRPjnRCxTXXgYy21SBC7ZleI2zc8p9OWyVHFvfWpeHa7iQL+MlXOeWnUj5DzoscbJz7TDfy7K2lvSCVGcfeBrnCGR1c3j4csAOcf2HN9oAvBlC1TNMZw6JEEU4l7mZmoNmJxRh5N/xLG5bQDniC127jpXP+fTI2DMbXB3284DnMJQb9lY77ZiX7WsJ9DVUnw2cfWTtK3Ih7UJZ5qC5M5vZFIVUHL/95IkGbnCl0ArgSZdR1VLvovxNcpSW9iUAYooHWU28vE8Y9R5fKXKlZ/gFiLcCFrEOQjlgjp+0MIdz9eF3j+jXE9DPLzGBrEFPeJJizF1+kBODy3GezSisipGtsMhsNgjLxO0mYFcWsrwSd8/73CJpNmYAIsap1qxR9HFa7YcbMNW8erYBieo4BpmuEIrwkU1X8ph6m5VtWaRv1eYSapATx0UfTGILV8
 PzA/TA0O
 qJhY+i3fkoIMba9SvoTsvCXnqPbaMG8IJDIvIiwTXXiUbWbQPlgeABl/WERA1Rx26/+lMhppMHax/Af3H5z8oD/IlrhGezGNLKdlX0y95HM6M4lsUj/n6efVZE+RjAFzA/teA/urWnx+vPIGWWn0Ihbu+fkcmo0TZIBYCv5a1dR7Zdmhkzu9pI9to3BQ3j1sPfTF6ntuiVidFISBWIdzBjsnQ+AVjBrcfMNFpIMmnMdBSXSG3DKVjVNNm7p5hDwsDwETHLvR+MH2J8IEmG+CefHWcl3oYqSsvsjeq4DEEMNHKcxsFZEqgtnhnYeBiUFEVpfJ+BubkHefQ/D8S/xKsRc3G9XdPUdjDASSC5+YkhEAfQxquOjtT8j6V9hHqZ3JRcpb7fRPSHmMhai+UDPiFHtYUPpvWpsENEYrY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shivam Kalra <shivamkalra98@zohomail.in>

Introduce a new test case "vrealloc_test" that exercises the vrealloc()
shrink and in-place grow paths:

  - Grow beyond allocated pages (triggers full reallocation).
  - Shrink crossing a page boundary (frees tail pages).
  - Shrink within the same page (no page freeing).
  - Grow within the already allocated page count (in-place).

Data integrity is validated after each realloc step by checking that
the first byte of the original allocation is preserved.

The test is gated behind run_test_mask bit 12 (id 4096).

Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 lib/test_vmalloc.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/lib/test_vmalloc.c b/lib/test_vmalloc.c
index 876c72c18a0c..e822830f0887 100644
--- a/lib/test_vmalloc.c
+++ b/lib/test_vmalloc.c
@@ -55,6 +55,7 @@ __param(int, run_test_mask, 7,
 		"\t\tid: 512,  name: kvfree_rcu_2_arg_vmalloc_test\n"
 		"\t\tid: 1024, name: vm_map_ram_test\n"
 		"\t\tid: 2048, name: no_block_alloc_test\n"
+		"\t\tid: 4096, name: vrealloc_test\n"
 		/* Add a new test case description here. */
 );
 
@@ -421,6 +422,66 @@ vm_map_ram_test(void)
 	return nr_allocated != map_nr_pages;
 }
 
+static int vrealloc_test(void)
+{
+	void *ptr, *tmp;
+	int i;
+
+	for (i = 0; i < test_loop_count; i++) {
+		int err = -1;
+
+		ptr = vmalloc(PAGE_SIZE);
+		if (!ptr)
+			return -1;
+
+		*((__u8 *)ptr) = 'a';
+
+		/* Grow: beyond allocated pages, triggers full realloc. */
+		tmp = vrealloc(ptr, 4 * PAGE_SIZE, GFP_KERNEL);
+		if (!tmp)
+			goto error;
+		ptr = tmp;
+
+		if (*((__u8 *)ptr) != 'a')
+			goto error;
+
+		/* Shrink: crosses page boundary, frees tail pages. */
+		tmp = vrealloc(ptr, PAGE_SIZE, GFP_KERNEL);
+		if (!tmp)
+			goto error;
+		ptr = tmp;
+
+		if (*((__u8 *)ptr) != 'a')
+			goto error;
+
+		/* Shrink: within same page, no page freeing. */
+		tmp = vrealloc(ptr, PAGE_SIZE / 2, GFP_KERNEL);
+		if (!tmp)
+			goto error;
+		ptr = tmp;
+
+		if (*((__u8 *)ptr) != 'a')
+			goto error;
+
+		/* Grow: within allocated page, in-place, no realloc. */
+		tmp = vrealloc(ptr, PAGE_SIZE, GFP_KERNEL);
+		if (!tmp)
+			goto error;
+		ptr = tmp;
+
+		if (*((__u8 *)ptr) != 'a')
+			goto error;
+
+		err = 0;
+error:
+		vfree(ptr);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 struct test_case_desc {
 	const char *test_name;
 	int (*test_func)(void);
@@ -440,6 +501,7 @@ static struct test_case_desc test_case_array[] = {
 	{ "kvfree_rcu_2_arg_vmalloc_test", kvfree_rcu_2_arg_vmalloc_test, },
 	{ "vm_map_ram_test", vm_map_ram_test, },
 	{ "no_block_alloc_test", no_block_alloc_test, true },
+	{ "vrealloc_test", vrealloc_test, },
 	/* Add a new test case here. */
 };
 

-- 
2.43.0



