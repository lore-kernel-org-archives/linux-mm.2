Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 680A4F5A8A0
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 16:57:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9D106B008C; Mon, 20 Apr 2026 12:57:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9513B6B0095; Mon, 20 Apr 2026 12:57:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88D686B0098; Mon, 20 Apr 2026 12:57:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6B3166B008C
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:57:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 427EE1A0A90
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 16:57:23 +0000 (UTC)
X-FDA: 84679539966.01.87A789D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2CFD240008
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 16:57:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="e/30oac4";
	spf=pass (imf17.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776704241; a=rsa-sha256;
	cv=none;
	b=JehVdXUcQVcr5urPOyiVfVk8POi/pRM3a1V7O2zkJla2U9ckAKTSMdtYOOAMOH85S5p1w5
	JXM94NlIiTUVkwFTQFvfYJxurSKHj9kh99ADPs96MT5rwxRHTmg2khRQZsCF2PhMyGB3ES
	/Ne+5LsB2GihmHMek+XonPHBJVvgAZk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="e/30oac4";
	spf=pass (imf17.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776704241;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SgkK/4xhFGnxLwXASRdn+f7HdU8eyNKC8FsZ6PyvRhQ=;
	b=GKzlquSQyMaBOI8p04kf4tqzHxATh9LhyCpae7MtqGvHAXEdzqh1U/zoKs8BVaqWcnZXvn
	3Q/BaMcsvcv2MKvP4OZLYlKXCI1CrJtuyz8KSPIdfWDGRtJiNYShOzYxcvp6E9zBGyrOpT
	kx2fcdKjaQjgR5rmyzavKOxnXLZxTwk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A7BAB4459A;
	Mon, 20 Apr 2026 16:57:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8A295C2BCB3;
	Mon, 20 Apr 2026 16:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776704239;
	bh=NgcWajqEHrBjrpmlHzE3kqeLHOp/AqP67j8VknlwGaM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=e/30oac4n2UJ9xBcXQ3Cbq2uMnype14ch+8sacJUzO+Gqjdw06dnBtYXFejeg8as5
	 6hRgy1GtlH3cQUlylDRaEJqg9/FUEcRKVsz7BG4mkS52bimZTJRMkdrZ9ZV8UwHkcS
	 0yEzdT2305W/ZXSZ1JQylZhJD1/w+4BVBnsciH9By+VVlrCND2kyXpSwLtNGHUxcfK
	 ve3/mTi4Io6xd/9IGIHG77aN0y2GhZzyzpFeWZ25jq75nI3a4TdvsLqqhBmEZJW0Ox
	 bBO8yJEMQWkWK7MO/Sl0TUiXTByGVCV9zd5CT7exYghs5ENGQIvcZ80AD7ENv0gS3w
	 vBiTJ4xSeqNsw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80F13F5A8A1;
	Mon, 20 Apr 2026 16:57:19 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Mon, 20 Apr 2026 22:27:13 +0530
Subject: [PATCH v11 5/5] lib/test_vmalloc: add vrealloc test case
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260420-vmalloc-shrink-v11-5-cad80b00853a@zohomail.in>
References: <20260420-vmalloc-shrink-v11-0-cad80b00853a@zohomail.in>
In-Reply-To: <20260420-vmalloc-shrink-v11-0-cad80b00853a@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776704237; l=2905;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=yP1QXayDidKnNU2S8I7BqJprRzQI2mQyl0fytHsaqPM=;
 b=Vy9ocWlhJYS1DG8K4aEaxMOhv+Hl3XH7BN6FnOKgb9Y0luXZYOlCryPB/d73wBG2Jv/5l+vik
 LcnLvukWIrPCzPf7uflN9HMWGbjii9GLcRIxMHH6lgNgzLLy0Fo4W6K
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Queue-Id: 2CFD240008
X-Stat-Signature: u6gdmu9pn5oqr446xay617ud5emhqugd
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776704240-804371
X-HE-Meta: U2FsdGVkX1//16OfRj1V0/u2Pw/fMq/jxtC0rlzd4UiBDoGg4nUT01D5jVHETX1pYCyqZA8eqlNY6GFG0muG2b0S+RJQpWN/9kEImuok1i/YepRkO3ijFfEJkl/xIrfSR50DtRxt4my2h4C+i/TX3fYjLZxeCWwoVGGKlDVpTnrT1GjvpZ6iV0TXjpbOxmhz3gxg9UDZgeT5pSnOveQxVYPPwKOczYm/xvQYq2Mg1KbVIG7igujF+X+qxDOFOcHa1Vuo13uRQyka+LIPHnjtNb7F1orxjH5h6ADLhR1KYxihQkOjBDTUlGtmHrReyERtWN2scsP7WV3/CgyELvKf5ebFuVcFg+GebppCLe4JRWxMoKcSO0TSma+g33vZ2kMBFzKTaWF0iuG2Dh8ML5CYIAPC+1BKOqdTjxy64fy0KE6K5UUK/+DjG3fyfWoFNN9bwexSmNSzg4V5aDDioQ9u2sBs2V9LhDrB5fdPlOLpan5+tsKVunUTM/NPP9/lUXx9O0P0bCCtVIVpyKAsoEZDbUfcgVMTFDobI77LzOh6V3cQwG+xuxYo31bpgmBExoM3LeuaSkLMk4xrJ7bkMl4KuI9YtYSUw6wAfVQD5WJvcFXkpEX4WkRgm0AaHITnwop7vNW1j8VXlWszi8rvzIv+1RTKHAEuJJGaLcLSXfw57ATc2WTjlrd0RUx77P0pGEZNwzpNE4qp0ZBb465GoWOEVrexq3bjxRCZikeUxQMlzKy8nm6jORQMcaiqcGjsDKb0chiXGL9J02ZWvCx6UuRG/YzJ290Gx0RIY4oTC9UYYVH38F+zZnEJPnBwW/fZdWAHALawP0N68pvoCLWHr1he8Roe1ov+zI/1SOlHn2M0ASBWaPN3ednvFS7f/7ahssWgQcGiZY4cOwj5PKzcjrAiaHsUN6vtW2so9R/Q9jEIYhB8qgSwla31Jiom4uZ2cV16EitxU5q8oWDHca0l7zY
 UOXLFb2J
 tyS3fUrjKP5sIPQmRXWAi9js9Y7uQmxy8T/bm6aArhe+ikNO5mrVmiR7b8Z+cL7zu/V28HmPXk7EyJf1wngIyaBU1DDvbIrna5nGb+2jjYm8t4EIr0u/2Q3cvlJL8xjiERozVF+Jktx/bVtS79BJchPaYzhcOJJ3xMSYtKeMEcM6zKt7CkXTDLauBs1xk/AID/exKhOZFG05unImnEaTlpI3thuEfDYIjnJm2DuqYV66Et4JEwTdSYT0v10C+NGaLPLQ3GUWisN9F08WIKdLW3Hj087NUQRgocj6J6lxC7NWdYpo11Xz5u+LTpxnKaliR6nSeQ9uFkXlFWaTkrtSH29sq5We/UJgjxA7D12DlIdgQ57fglNXrExx7/vjgNeOA9+qzq6eXY1UgHgqybGazfVz9miv91FWMM/kJZb5oqyibZFxKIwHf8buF5w==
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

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 lib/test_vmalloc.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/lib/test_vmalloc.c b/lib/test_vmalloc.c
index 876c72c18a0c..b23f85e8f8ca 100644
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
+		ptr = vrealloc(NULL, PAGE_SIZE, GFP_KERNEL);
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



