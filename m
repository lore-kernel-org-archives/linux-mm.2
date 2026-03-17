Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ED54F3380F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 08:17:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 642036B0089; Tue, 17 Mar 2026 04:17:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F2AE6B008A; Tue, 17 Mar 2026 04:17:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50A5B6B008C; Tue, 17 Mar 2026 04:17:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3C1616B0089
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 04:17:42 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E6EB81A0598
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:17:41 +0000 (UTC)
X-FDA: 84554851122.29.73B372D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1ED431C0004
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:17:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FKXIp1EP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773735460;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BC8VhNRSJiguEPuhQEyO+T1PPwdN/ibX0Ly26CcLNDQ=;
	b=W4yiJyhoPYErEoxMlGkMVwDt47Y4lKwYl9zieZP1GFs6Y/FkZCHPZRNSMBTScHI5afdcNf
	R/Utocw9GzDHu7C+rGdMfcBBLKDh0XY1cAqksog77Dz4QIKwNGvFb9HAgUh6Dv8SJrEgR0
	56vLYFDc0R6wscmIKRcqWhYVUmQfBIg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773735460; a=rsa-sha256;
	cv=none;
	b=q7zJ/m0mZrtx8VLDwciuTBlJErskQHTiMW0u0Glvj9a8ZD5+D4r8ULXROPmFplAOXBvdxV
	gAtxx6kqy7Qau3enkoi58N0q7eFWgmsZKFG/qMgth0Du9jvYmoh4GwPP5n/pBVJ+TV4owi
	D5umU60TQVQmCyG7SbKT7LETYt3Frtk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FKXIp1EP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E370D43F79;
	Tue, 17 Mar 2026 08:17:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BF9BFC2BCAF;
	Tue, 17 Mar 2026 08:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773735458;
	bh=CVIAq93ZteUDhJ/xiIE3C2yFgjiz/OpnbCzoIeyuy5w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=FKXIp1EP04imyX93u+OOXcxXjE6xPXiWX1QYn0voWosmL3WArVdn1excQ8D3DUJ57
	 82jEAvZ6CvisacjktBrrxX/0U+04oMtTICfofawSQYhQFS0KOgc4degcxR68pVgHfU
	 Ypk3gL2MwILHF4ZofHJvJZv1aYQ4LhY8nzisfFTXkkmoELuVLq0lqkDlHIr6kFEZWT
	 Yr1E8GwyKQhIWpK+VL/lW7rKmkl5igoUtVFjfr5TmA5cEsQZzksx2jEDHZALBN5yj5
	 Sx6Q7REoFKzIzO7RrVHAN/S4ArSqnOOzHtZte95CNh48IYKqgPieQhkq1ZbfsQm1wK
	 ReV7A+sDJNg9w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5DE9F33812;
	Tue, 17 Mar 2026 08:17:38 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Tue, 17 Mar 2026 13:47:35 +0530
Subject: [PATCH v5 3/3] lib/test_vmalloc: add vrealloc test case
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260317-vmalloc-shrink-v5-3-bbfbf54c5265@zohomail.in>
References: <20260317-vmalloc-shrink-v5-0-bbfbf54c5265@zohomail.in>
In-Reply-To: <20260317-vmalloc-shrink-v5-0-bbfbf54c5265@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773735454; l=2680;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=vGtWOd+QVlnd5fUIfOUP0oSJ0Gu3V+AGGjAsUp+yrM4=;
 b=nsPZ51c4i4HerfAVKo7lTeH6+ar+WYWuYCzdnfI6srbeugwWqkl6+ZP2g2l7BDC6P9fFKz3KX
 au3qF0XEVYoC7CoeIy0tRugMUONIC3ShIm4y9bLNLqcpkpKmSyb1UfU
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1ED431C0004
X-Stat-Signature: 4pngcu5i9z7dsedze748yhgdytu4p74n
X-Rspam-User: 
X-HE-Tag: 1773735459-141067
X-HE-Meta: U2FsdGVkX1+pWzLdKQI/9UsHCHVDkvV7/NpQI3/y72hrKnQApnYIdY5UoMs/Tre5k/ritvx/ANrb1oxSRRSr59jaOB626fcOmntOzZuEA7TXe0T5au21AP5Mc1qQXZ4IU/nLqXEFbUNs36qpcoJvSHAcUY5PV+Oauxyjw9zyLrwtJ030j3w/yoCCo2C0pleYrSKNVjHXOhDnS5k8C+0apXO4yH92erBrO8t3lFRHaLrHf4bxBoQkxeAAV+IQVEGrfd0hGnWTBHm7hKxoCmPsmW3cCks4gfPegNh8LUd2FxcN5waxg8RRcVUPFZiVh+SJcmeXhmxrVOwIg6Xiltxs2AjCSjBiz3yQyh9qJe7Gsbfg7iw9RGSErP+UmuMlXGnHey8UMvuXbvaYnQHSmo23xSN941bemquUxt2JGzYVComYZuLuRkxmGrS8mPFLUHNOYRXuVZfzsW5sWFj/eLh01ThyNj1sh0XF1VbVwbEr4Jay69Zdq9IykwwyKzeSsncgIbfmoyO32/Xu+G11fsncdwJPq8OPaA5QrmPWRmh5JzCbOWJx8x6NK5/x/921Oaf6S/XUnVGQr09jbUXBYql42spUM1iC7qBjXIOrP+6W6R4rNOzbnuNkZyjf1BcB92LnqBFnAwejDUI0qSLfWynOETq6hOcNNkYE/i9cs1ShdWbOHEuzqHg+t+s4ppwuX85VRhofz8wviXaUjgGc0+Cu/ww+SlTDzU+NpcsySShjNnfyhpZoH4DhpQCpLbb1HJDfChoFhRgDMgJsbGtA9kOC42uRM6XoMAkZrMoiNxBPAo2tQMbU3L8ddfAc5ZpcuDfZR2pktxM5BwUjLbDhQVxjh2wVUO+hYukn4EU6DcppSjQ6RYBJErO1wN2E4D28fu9EVsckmIhrJdZfttPE+DlvH7aIyWIrfMUaSx9OX/V8F/rsLMeV0w5aMw+W0sQ42/y28udyqYHj18nVhCm+ddq
 JGDUQnzv
 g3gen7IouoskUrRLxd17F1r7GlzGRC8T/sbjq6RYGXuSTp9OweIhJo69BQNZn9li0xgNmZoMckoLxBlw=
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
 lib/test_vmalloc.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/lib/test_vmalloc.c b/lib/test_vmalloc.c
index 876c72c18a0c..ce2b2777a785 100644
--- a/lib/test_vmalloc.c
+++ b/lib/test_vmalloc.c
@@ -55,6 +55,7 @@ __param(int, run_test_mask, 7,
 		"\t\tid: 512,  name: kvfree_rcu_2_arg_vmalloc_test\n"
 		"\t\tid: 1024, name: vm_map_ram_test\n"
 		"\t\tid: 2048, name: no_block_alloc_test\n"
+		"\t\tid: 4096, name: vrealloc_test\n"
 		/* Add a new test case description here. */
 );
 
@@ -421,6 +422,56 @@ vm_map_ram_test(void)
 	return nr_allocated != map_nr_pages;
 }
 
+static int vrealloc_test(void)
+{
+	void *ptr;
+	int i;
+
+	for (i = 0; i < test_loop_count; i++) {
+		ptr = vmalloc(PAGE_SIZE);
+		if (!ptr)
+			return -1;
+
+		*((__u8 *)ptr) = 'a';
+
+		/* Grow: beyond allocated pages, triggers full realloc. */
+		ptr = vrealloc(ptr, 4 * PAGE_SIZE, GFP_KERNEL);
+		if (!ptr)
+			return -1;
+
+		if (*((__u8 *)ptr) != 'a')
+			return -1;
+
+		/* Shrink: crosses page boundary, frees tail pages. */
+		ptr = vrealloc(ptr, PAGE_SIZE, GFP_KERNEL);
+		if (!ptr)
+			return -1;
+
+		if (*((__u8 *)ptr) != 'a')
+			return -1;
+
+		/* Shrink: within same page, no page freeing. */
+		ptr = vrealloc(ptr, PAGE_SIZE / 2, GFP_KERNEL);
+		if (!ptr)
+			return -1;
+
+		if (*((__u8 *)ptr) != 'a')
+			return -1;
+
+		/* Grow: within allocated page, in-place, no realloc. */
+		ptr = vrealloc(ptr, PAGE_SIZE, GFP_KERNEL);
+		if (!ptr)
+			return -1;
+
+		if (*((__u8 *)ptr) != 'a')
+			return -1;
+
+		vfree(ptr);
+	}
+
+	return 0;
+}
+
 struct test_case_desc {
 	const char *test_name;
 	int (*test_func)(void);
@@ -440,6 +491,7 @@ static struct test_case_desc test_case_array[] = {
 	{ "kvfree_rcu_2_arg_vmalloc_test", kvfree_rcu_2_arg_vmalloc_test, },
 	{ "vm_map_ram_test", vm_map_ram_test, },
 	{ "no_block_alloc_test", no_block_alloc_test, true },
+	{ "vrealloc_test", vrealloc_test, },
 	/* Add a new test case here. */
 };
 

-- 
2.43.0



