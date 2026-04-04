Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11946E88D8F
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 08:37:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 120B16B008C; Sat,  4 Apr 2026 04:37:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A3F16B0095; Sat,  4 Apr 2026 04:37:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E37676B008C; Sat,  4 Apr 2026 04:37:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B2A186B008C
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 04:37:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3CC651A07D0
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 08:37:19 +0000 (UTC)
X-FDA: 84620218998.01.3052741
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3C878C0002
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 08:37:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uDLox2rF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775291837;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SgkK/4xhFGnxLwXASRdn+f7HdU8eyNKC8FsZ6PyvRhQ=;
	b=6a3ulkB4WuShsibxMNGVHb0jfzXoMZK14YoX/K2zdDCJ+bIDrdoXEIxYGiROLpFbWPZjKd
	1U1J2ZpMF7v5XZH/MEMw83Lh3u2/RIMzZqmUvupAB+tRSgx/EMvFXAHqpKOqujUr6YHzWQ
	o3rsztXHekw0IP0M7V4La6Y6ArJDZdg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775291837; a=rsa-sha256;
	cv=none;
	b=IjdeISdjHDKP5G7FWEDwD6Oi6fTDqGbZs0HlR6dcbAMGUqhjgfd2AX7Z2P5qmT9nfKljKe
	66wbyVpnB6k6lBnoAbXcLIUF1gFS8m+LopOWEgiPDsZU4rQn51FM+uodo5KGHtapHWzXqE
	VyGuqZ42larkiA0oIwipZmMQ3V7KeZo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uDLox2rF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2FAF5444D2;
	Sat,  4 Apr 2026 08:37:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12164C2BCB3;
	Sat,  4 Apr 2026 08:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775291836;
	bh=NgcWajqEHrBjrpmlHzE3kqeLHOp/AqP67j8VknlwGaM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=uDLox2rFXJy8aPMosrDB7kLjc93lEQzAn0506hp1UJ4ucub7vv4h6uImg6x+WEX9y
	 wifEofWp5t5K0R5tSPyU7gerW2kZd9tmGys6PlyLQa6AB1w4I2yP3koxDGtITpvrEi
	 HWoHVYe/JomrRk/NI2vlwK6ummXC45Y3QJpe/nM9Bl3pDBXaFH8hTHIUPfzPoI71iS
	 0PrYwWSkOOHfKpxmXWbN4c+8vOsJX9dlzAu9aNPkSUEO3epIPAZXpU41e5KbvIrG7j
	 K2PcdMrn51bVcA2DIQIIvxxVEtV1QTEQWW2/4zmbJh2ruwezhSTC3xk4UUnlXafUH8
	 L4A115L2elAAA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AE9EE88D94;
	Sat,  4 Apr 2026 08:37:16 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Sat, 04 Apr 2026 14:07:00 +0530
Subject: [PATCH v10 4/4] lib/test_vmalloc: add vrealloc test case
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260404-vmalloc-shrink-v10-4-335759165dfa@zohomail.in>
References: <20260404-vmalloc-shrink-v10-0-335759165dfa@zohomail.in>
In-Reply-To: <20260404-vmalloc-shrink-v10-0-335759165dfa@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775291829; l=2905;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=yP1QXayDidKnNU2S8I7BqJprRzQI2mQyl0fytHsaqPM=;
 b=dHZhZPRkkUDs6TFIAA3rjD7JuxXY1sOelhR86C12exe20D0SPMHRVlTp7p3OVi9D2nlfRjv5u
 +1z1AHGx4dyB6YcKii5U+wJH1nzYNJ7+E0/AP6fUqyPTJD+69ACNh/g
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Queue-Id: 3C878C0002
X-Stat-Signature: 91r3p9ddeijyxahpzhrbkgfepbdksnya
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775291837-766718
X-HE-Meta: U2FsdGVkX1+HyXBsvYOhX8dqYK+eXUxUJ5ae7GB/I0BS8PSGPsI4+mnYAlQZ9IwPNG1xKJmePY0nkxJGgHlQBvD440hQW1JZh6qh4JTGSPVSRdGoOQPnjvOm2w46mS31WExog2SKh/UsfqZKb57rAbQb+rg/M7gdn5WJ7L/gJoMB8WDgZjvg6Is+DVBxgNpcWUsu5tvHM86lDVtIP8NXrW4v9lzi69iTAT5PiOKN/yISWboBbAOZuhMHNBxjuNNJWD94SXWwMPcGnRfGyyoVLSQNsB1Yf7soGwPlKBu+MBDiFdZ/0kZBW14HVsTGGKHuJrbyxhDalJGo5BzetEl9e5mEZL6HDasnQz+EFQDMiBXuoUIgXE9GmT+lJFETuDqI2Bcfy+Z9uQ5cQ8eAV1to8MUPcp3uojfXdOKB9PVJ76+kxgWxYR80doNIiq0fpukKTCYtP5Q/1FnWz75LVUjyUw7wUjOePz/G2ZKrzwteaYoD4A8AkcnXvAy6E0sIIUtxhEmgUmdG+IBgAorxBZUklIhf5iPYbyqvZ1BiSvQyv8DCvYp+jFg8d8VW0uK6UzQH5nl/D3Y+AIJeDAJTV8JyySfEVa2OL/r0D9NHweLf3xr93WUU1VPQ3Q11YT7ltZrzPtDgRmX6w7RtdgTraLC9h3EnFMB5+5w0T4zElVu6r2b8Hq6CfL6sx84mGg4MHq+ef2XpY4qmDeoSFk3ANBWMi3bkim4rMavomxLgyk/2hhcwmbksasgknZKpDaYhtbETYRSx/05RvdKkgWK+tTJPGaOdrTPbTnnBrfMIMDv7YN+lRyZSC0SF+od6wwvWFywc8HGbt4O1Z6Y4iAcr6GrHnBemEfU5ApBr/bb1xJLb/C8jUxMjztTjGPxa0fqM0TTQrL+859aQF2PUcXe5P10obUZ17MVO5pQieTK0TPiaMr56uv05DgV2rCzO/Ej8ci3gTpRbR7ScyH9QmVfi3nt
 Dzas68cd
 7fnenuTnNYEfBEtIaXMkp64H1AuG2oK4QzrlWs3qFkFy61kq1wqQAkSXnrydtFaKxTncPSqKv598vu3V/KwDYgqv9tDe28+AVNWXZ648ew7Gyk3JRZhoThOvpsKid9OLTY53AGtiU/743JI0wjH7SoBpqpdSnqxb8dgxz+LItTGLoKb9uhUyTZ9ulytPS3Fn6lojF4CwQNPFvrX2g+3H+wbZPB0rduHFphyhGj7RF0gdHTaXApaMdEDpwtVk1Fo4oG4lS5zhSASXPQGbEkqeBhlbfEMH2a/IIvQw8k14quxxYlp1D/hSGNY/LIwL/oAk/nUJqCmUr2sQI+1EqaR0h5eKqLlwIznKyBcekBq+FZSDX8LZuU9DJi/GJbmMzSMDFx/FYYsN5qyuomEcc3Lp4fVexkewuaO3mrv6DAH4IdFsrqh23/tJSpE33Cg==
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



