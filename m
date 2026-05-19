Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00A2ACD4851
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 12:12:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C05F6B0098; Tue, 19 May 2026 08:12:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D4026B0099; Tue, 19 May 2026 08:12:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EAAA6B009B; Tue, 19 May 2026 08:12:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2AE446B0098
	for <linux-mm@kvack.org>; Tue, 19 May 2026 08:12:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EB67B1A02BD
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:12:36 +0000 (UTC)
X-FDA: 84784057512.15.B24992E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id D302240002
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:12:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ihzdS6SP;
	spf=pass (imf12.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779192754;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SgkK/4xhFGnxLwXASRdn+f7HdU8eyNKC8FsZ6PyvRhQ=;
	b=wbJ2zxvC+zJMqw6KpYn8CResPsgjZxTGZmYcOYbwmUVY9an8PKuNv26mFgS0jtkFqXaI5Q
	NLTYyCwf7Gql+TYYMqpk62tu9uS54lYSEXwfws/AXxQyEAJzz9mhGBew2cny1x4imqj48s
	ks94M/kHivCTJ4OwBC9kRP8lRfwY564=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779192754; a=rsa-sha256;
	cv=none;
	b=AXePlKtGZIcUFDYcEuJXtVLwHb7j2s190SeqT6784J4Y+V3d0qpTuq/BQ1rFVit3oaFxVv
	4TzNZoSgXLuXYZPrjCfzyLmc8XoMkrZ/6TdYDUhlkQAO6IEMy663LvS1MAT8MyufWtZYqM
	4bMsd6HEF0Fkl0Fcg4RY4rumCvy42rY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ihzdS6SP;
	spf=pass (imf12.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8682344551;
	Tue, 19 May 2026 12:12:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 65E24C2BCFB;
	Tue, 19 May 2026 12:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779192751;
	bh=NgcWajqEHrBjrpmlHzE3kqeLHOp/AqP67j8VknlwGaM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ihzdS6SPoeYv+Tp3wB5p5u9s7CnS/6rsZyVon0lZHxFW6ZIRqTWR4gA1C/NLWZSpa
	 PeJKsvSTaV4VmpAlCNBdOzuzgq0SZuHqNKXrf0RtxEBNJSoZe/V6DXTs9zWrpLU8uB
	 XegrIzL5LYQpJCmkrTzreSWHnzpU7+vRJ1hN83I641mRY3VC7y5n0mm4ohpsFx7Kv0
	 SQE6TDlXGMcRy1OFJo2qhfAfLNgIGjD1k2qqQNizSHTbzyB2pubeLosxaQZkWr9nJz
	 nyiT5qwXbS4hcbHO3yi+2WBotZFo0wWkD83BOM9BlKmKH0/Ic/Nhi6eg16QEAEWlpS
	 fiSPkNBCi3Amg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F30ACD4F5B;
	Tue, 19 May 2026 12:12:31 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Tue, 19 May 2026 17:42:18 +0530
Subject: [PATCH v14 5/5] lib/test_vmalloc: add vrealloc test case
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260519-vmalloc-shrink-v14-5-70b96ee3e9c9@zohomail.in>
References: <20260519-vmalloc-shrink-v14-0-70b96ee3e9c9@zohomail.in>
In-Reply-To: <20260519-vmalloc-shrink-v14-0-70b96ee3e9c9@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779192749; l=2905;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=yP1QXayDidKnNU2S8I7BqJprRzQI2mQyl0fytHsaqPM=;
 b=qRwd2vwgvAIzFKzG34KR4AENXRAoMWlQWk9KjRHrtik8HlO1YbhPgnKGodIcAnWABPsjDf3lE
 5O5VZg2CZVBA2SAi/4XKrKRLkb+1syhjHClgrYqcMSjJMvi8TJiBoQ9
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D302240002
X-Rspam-User: 
X-Stat-Signature: hpu591u1fh6yyufsuqe4x81q9ksj8eeq
X-HE-Tag: 1779192754-503249
X-HE-Meta: U2FsdGVkX1/P9R9uL6xQaS3EL5YGzgTk+XHbOechoxxBQxXkwhcvyS9kc8u8A5Bc1Jqw+qOvlgScM4sJIEef9lU0VxbLiPPEOOCQehMHPsVkVu2yE94IEwMwCj4Hy9aBkp5PxkC8qTibneiHnEDjmqDdBDiUmdrOKhHbH0OllOjLatEiqGh2BAoTd2HOHsrbBD0cBKg8Ccbkrsu105MbQEwepwdkS07UxMH0JBZzk/YtRdLSDw4djg4/wDbU01yHPbESpIoRy/J6PpNJOeqw/3lWe2ZPggAcXTsfjMZ9EsYVfI2vz5Qs7sdYN7SjCyIxfxZB6NfYRcQsv3mcafz6YLir3jexcGTCt2I7DspInz1RZ7D5oNSBSTrDLhq5ROJ+7142sxq4khovRia5pBhsUYb/Qi7PKyvAq7e5tgwZB2cQIGfMcMMsCp+If9ZSXvtVyXSxpNqCfT/gpJEIye4IOx5WAMWPnY2nu9T8aRBY8NyXcJ2GbHJDG9aPv0tfV0JjRg286O5Cy22t1twJfN5Z95VI2I7QsCfX8tK2clfXAIOPdbt+hDLHZZ/ylbqJ1Qto2kIkYtrvlOo4hWLSyi1bxHPkFxvSZj1zKfYE9CvGUAreFOnhUaJPBBPxFHeH5C2T0NiMSev23z/ug400F3D4VyTKkiBziekypEWQuboEBRwTPaBZ44J6E++aXc1hwd9q4pgTAJwr22Ev/sd54GJPHAF19aTNEe4zifTlC/x19jdfQDQ8U4ClKyutVEMZz4TXjrqpA+KKySoKo76pD/GKOKZJOMnuXWavRcjn3buYStpj1rCbiORAXVLeVfjLVJglVcfdic+NhCeHu6gN6vw+vQQV2ls0FlDzn1cFerqWFGMsyNJhgkHdCQU2ouYZJ749MchczeViW2HwljWTV5rBD/3hXxBuEsRc2TmBPK4p23kk4mRHQ2ShL/VIkdaX1OxrgOS5pZ1Qy0UZTCiG7xx
 2TxQv4mS
 KvhgHvnJKgqTqog9wfhW0a+TNTAbKUzhqgmihyAoD69UOjG7mI6fFCYCBXu6XxpODH2+v8SZlox18NAWmH1HnuM8jnxsGnT/fPxC83lzLagTxQl6fO+CbqZypZF6g/X2FfntXzPu2w+Nxmy95WfaDkIuilTRMUk60Rxj+43njoIybGW2e13kD+XwEL8gIMDdHeQyOOjIBhFvJJvzFh+fQticobW7AnMOAXwYMUohMDwWqYEeHi4py39a540rfQsT6tLTPqMeXpZ4w60VFzbjF/mQZq4qBwaoZ/0GYBhVY3hRjdBsG9BE06VjJPAgI5asemnverfyj9cDqp68rvLWFwHTWQZRE7tHV/D2f+g3QgFvP6/AQX5yYuh/obNSjVvPCQx65lbHFPuBI0o1lwQqpLl6vl/8Owekasq6LGnfQYPuRuDbAdUB55ddMcA==
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



