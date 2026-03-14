Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F653107BCE9
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 09:06:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B994F6B0093; Sat, 14 Mar 2026 05:06:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B08266B008A; Sat, 14 Mar 2026 05:06:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2AB06B0093; Sat, 14 Mar 2026 05:06:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7FB306B0089
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 05:06:10 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 066F15B80D
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 09:06:10 +0000 (UTC)
X-FDA: 84544086900.19.CD52F50
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 07BFC4000B
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 09:06:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RQIDyx11;
	spf=pass (imf07.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773479168;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BC8VhNRSJiguEPuhQEyO+T1PPwdN/ibX0Ly26CcLNDQ=;
	b=Hftpcx6KVHMcdE+xIhNRlAwkNLWD0eYydO0BOA0dBop4MrGLDy6fETdrMygX94wQg7gTc2
	DzJ02bvrgx0ACFBI0jXm4bvfDwutVPfMuJUlzcwfSNXL9sYsb495ZCMnu/AgcTvrGdZVMK
	kLPmFe/E8g1FtOuBG2keGxRpYiciT5A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773479168; a=rsa-sha256;
	cv=none;
	b=XCGZUjII25GPsvdpXTRODX/sL4m4eBHuvmpbJGD4nRHEYWqdyzhheNfjllTRPaIhnIkkpr
	78PrWXX+kJ2JrFStQyfUPA5yBzYgnCUidJRckVBFNkVVdwdmzG6APn67cMXbeDwCe+Iz5f
	yrfljNcQ/KiatKn1T60ZGheVCNNWFNc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RQIDyx11;
	spf=pass (imf07.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E7F5C444CB;
	Sat, 14 Mar 2026 09:06:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C56C5C2BCAF;
	Sat, 14 Mar 2026 09:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773479166;
	bh=CVIAq93ZteUDhJ/xiIE3C2yFgjiz/OpnbCzoIeyuy5w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=RQIDyx11EORmFL29Pp26LQfRhdHc09p871yCeCOnF3/cCzMNDAySIdb0SZls98JkK
	 yShmkGzHZs13Lflmy9KBuXKHaGNZpcm0WolABMBQ4pTEgCh3ZuCAwX6Kmnni4qmo4Q
	 zekeW2ugrBHvPygft/KbBXDVGT/Hb3HUvJW8DqrxC+aC5N6bJj6XdEgHrRyjoyUe4O
	 57ZEu4+fLmZc5m7uLEv0UczXhvzshBQRaPwTQQLoHF7xQgX1lMsL99oBzJI6SzTFfI
	 7acFO6IRxZHCl31IYepNlz3AoCwfyHAU7n+toXGMAGpXnIfh+TsGyXw+0fpSRUrjMY
	 pSq5QRZiXkeyA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8826106FD81;
	Sat, 14 Mar 2026 09:06:06 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Sat, 14 Mar 2026 14:34:15 +0530
Subject: [PATCH v4 3/3] lib/test_vmalloc: add vrealloc test case
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260314-vmalloc-shrink-v4-3-c1e2e0bb5455@zohomail.in>
References: <20260314-vmalloc-shrink-v4-0-c1e2e0bb5455@zohomail.in>
In-Reply-To: <20260314-vmalloc-shrink-v4-0-c1e2e0bb5455@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773479164; l=2680;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=vGtWOd+QVlnd5fUIfOUP0oSJ0Gu3V+AGGjAsUp+yrM4=;
 b=ZlC06BPiN19E6EC05bRswEeu5zLVKJ2Ai6lAnm/0OA9b5z49oH4h0mOBUldtoDwZpqrM+2dVD
 wIb8zLxhCqvALIzYJirqqA4dSyII/Gw2jQfRf+pohOSMKj2/dKPaw0I
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 07BFC4000B
X-Stat-Signature: tsoisj5ekwqjuufm84hkg5zwqqxj8b5p
X-HE-Tag: 1773479167-777486
X-HE-Meta: U2FsdGVkX19Shv6U6QJlg6SHX7/nOGUFFlkwvBcD4QkkozxDC+08qJmsxWsMcZGDzrF8JgFxiLM9PI0fpct4qkhYB8nqWz5D+wnLa+XVrrUOjhOXI9Pcutv1Ox253AmaJnCdC6zL0ZP3ZIn3XN45EUJ+BRgR4gs7R1Zlpwo+l5TcznTC+QzbgGjj3zl4X6BiI0iczfmAvIzAARKsAdQVVM9tYjUEomB0IaxJ89Z2CEpCMAbPU/krcqfmko3nGKi9WP6SqH/zmOPr23PSARbM+D6XSBfQe54yqiGhg9neILSYM41o13DMMCdUxR+esP+S2VtCqVTeTWDa2UiVb3UzDAyJHKrvtz3GFm1nt/kj7T9qe/xKuIn2/2j/iE3hqe3D+QRkP5syKLrzMQS5dAfzNKHCUq07IoLPyoPieTBqvv7rnIsAcqfbBFJ7Xk8nCnSh9SubmQGi/UOVcCIF5xTOUAp00Qm0/iLh+9C0OA8sfzc/Ke+FQmuqXKSDqAyYv6NBQNG6HZ8ttLlQ+IMsM3B8UG8GHlGK39jPNQwK7zfYVaGm6FJqIqQR7iHWsogKpHoJ4ER407QnD7BrTwQvALPvgc7Su5K2KRQFZHtLJY/JtjiTTBlJhjUrGzSEZJv83TLvcuwxlUmaX6ED/sx9T2/eegZ4wL/NlNf5ogYCod40S5ERcvmlEIeR1z1FBXr6uLXbNUm1Xn8YWo1IE66aZ7JrFkSHubQseEEnNg3KeiPjwE3aQdxEoUaHvOBciINHWjS2uhEw43brYwLMMqf3XMU67/rXIQuIG/MspMGZZlyA6K1/aKEvIOUqK++Ksg/q6BtNA15DWh53eYS0SUFMsVTeK8FEyHScoZVHE8UcZFIHJHWyBQVQ1s86hhZonc0VJqq3mNqMNeZqC6eKnhJN5X26UoD5eofgMH6s8/GRDY6nIZZ67/RbzjDJ+69/mJ8UYS7Fh6gi39z83L1bItr2H4x
 7gGGtB+u
 +05DR8jb5Ev/AmXRxuWgxtk5ne+IxM7C4jfT7yntqaJMwALHUNvYsKtt+VLmVl8wszAQSb7smY1B/qpf4eC67PPbUL0qVggSeOkNEOJE/kFO7W2jbubbUetWmXKUHOyq52ajzHf/FJhUTzoyEqd9ttJx0AJA7C8LR+vnovY2GfQa3hFfBWPNDjGIEmyiUy6Q4HhIYvnJjq6SERuAByfzBQghLQS6UOQaw5tNF6XNWV/6U/lo23mejRntq9fN0yxA/tlsx2ux2H1Yi54kx/bz4gESPBT+20lWtd64Gu4msfBaeqdFm8CtCybn8l79A/9fkN5w50Ki1kFDnBwxrHjYHIBCIn0iXhEsDYOhfMA2nCsYa3iEea0fAzk/k1w==
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



