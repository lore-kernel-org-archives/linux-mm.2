Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90554E9A75A
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 10:00:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88CAB6B00A9; Tue, 24 Mar 2026 06:00:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83D7E6B00AA; Tue, 24 Mar 2026 06:00:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 755106B00AB; Tue, 24 Mar 2026 06:00:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 65DE46B00A9
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 06:00:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2ED0F92239
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:00:39 +0000 (UTC)
X-FDA: 84580512198.21.BB28630
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id D7CCE140029
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:00:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t7d4aquf;
	spf=pass (imf09.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774346437;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BvkkOWWRtbNRnIhkuJ7S8/auI8roWxjsEcP7iqhAdU8=;
	b=kAwgeaDiCEjuxiWcnQWCxMRBFp2L/gv9xPnyPSan+bYzGbcJ0V35kt3hBw5Vzl9TAWNxmY
	0LsparIbJMxAczBoR8LBMgSBm6d72mgHXbhZp6SXlwvejcYU5/1ljBAnVHbsyO2t7yZZ1f
	z8ZRtP3+vbRTYrFwdZ5FkyXbe5SmVdU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t7d4aquf;
	spf=pass (imf09.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774346437; a=rsa-sha256;
	cv=none;
	b=RIUEaq0rnBrp3ihvAIxdPJDTTHs/h1SQFTtpzJHOFIEc6j28R6kKD9n4Lv7ZB6rpZe8Kap
	uSd/20lNcP0B7ucIMfGguTxtDOJYy0d+fAblwEfj8Me4N3snLfIf5R6lDqHD1dn0JAe4NO
	BPLJ/VHwW0u8cKmCPO5VsRa/4vLoV/g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 19F8F44550;
	Tue, 24 Mar 2026 10:00:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F1656C2BCC7;
	Tue, 24 Mar 2026 10:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774346433;
	bh=6f7TOEvk+v4ej1arN46RE3RzMBqAOnaX4qdIPzrc6Wc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=t7d4aquf9ItiXQ/V3qTovPcariGkr6uT2eOuxxoQDQxWhDVsgznPqBGgEt/DY/lca
	 blIQdcCA85fis+WXojOw3O9O+Xetf9RXFOx08UuSPpf9NyeBDvz9dEYQWfAkBPTL7+
	 rhvjcgtfKcXqYDCwXKfdlVYTOcgfi6LN+eYD34CKIqq9zYYDlh6QZGUtZfksEDMCRI
	 hZnTI7UPXzj+ApKLCMkOF/HA7HV+kgHkEwqqhxRzDw9b2mNdZ8xiRdADAEBOh4Q2EU
	 +uhiXC6lONssBaa+1thggtCrBekXHVSW4oEpwtftqw4lYYAmfmg9SQMiBCQjguHG+n
	 26azKymrbiisw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA4CDE9A75C;
	Tue, 24 Mar 2026 10:00:32 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Tue, 24 Mar 2026 15:30:31 +0530
Subject: [PATCH v7 6/6] lib/test_vmalloc: add vrealloc test case
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260324-vmalloc-shrink-v7-6-c0e62b8e5d83@zohomail.in>
References: <20260324-vmalloc-shrink-v7-0-c0e62b8e5d83@zohomail.in>
In-Reply-To: <20260324-vmalloc-shrink-v7-0-c0e62b8e5d83@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774346430; l=2848;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=q1HLhsQQ92caXQ9Tt0laK39H3cv2PUzBofvprsTi44k=;
 b=BEPTytl4CB3BkcU9Nf+8kk+Rt9BywSe/EuCrTiSmPF99Nwk8oIMH3YmkayqBpuiXrPub0paHm
 Ibp4V+UQChFCtBgC+E78zmGRwm6aMpqHl26Uu+vIgXrRTK92fNYaxi+
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D7CCE140029
X-Stat-Signature: 4i57wu4kfxe4q4qh3rqgarnwbnxkqmgh
X-Rspam-User: 
X-HE-Tag: 1774346436-478614
X-HE-Meta: U2FsdGVkX19o6m1zsef+aW5iVBeAv+sZHCL/V0ESsDm49kctYepsgPwvV9lY51DBGhhjs21IMCcRgP9D9QOrIg/Py7T8OBQ02m1Mi1fYltSE2pOJy6GKc5dsiSEKjFk5fYUuHWLXLM3ybKnTKzayfnQTgO++uoiPPOCdbiQxxtvuzuRoPMbBMcAfgFR2gufpAEA54waU3IwwrAN59oWpNIkqBTjUo6STBkaq5Ja58FOpXDuHNE7YRmDVaFxGNVf/Qm3XfXop2v+P/fX2adC7ZwyWqNfJPKap/qHRnnTTs2U0tPxrj+uall4d0AxIkF9t6rF4Q7v32i+8w8ZytSWZpnwJmHTVNd69zlWkVsuA9T6lIYNUAEu2a36MeFFVmGcB8jA3Vzv6QlHlYIKzDIX9uL718Uv/Nrb11fErZ9JwrtdS4MbEF2aV+TEYa9lvVdCr69zGkNHU8JHyVTlYlr1ufY8qvQDd/p6Deauf+HJt5EsKrw2slHIXMB9z/b6O6fXdUxYGqqY22pCThbEmVMFCMogjIN0Di4YEfFYFntmjMw3Pf4BsCj1xIsJC7kf3J1auofAwdQqRKjtdjraHhG6ksTuvpX5DgmsQUpBhqDxL2g5gtYpR4mJbGIGkrCEP9UoSFNH2uf0Tr8/Gt16PBOLaSJa3UdRkAXREx0lUoD/wYQLPNggxA65xPjIx7SUGlojExFVZso6uqD+HNyV0Tdqj/N2UxKYiHGtsQ8eCDvsRW6dRfAh/2yHFydX9f2/nq0ISYlTmyijhFnbzjeWkndyJnMcTxXlEgBJ9myawZXG4kEQH2VMSDYRGOCwoP4cfILt4XvBTBTh8nj28HLTZxsyn8SQaLBFGciwpIiG8RCWH4QV35DNNaEk2PzCnjmrJLSXo8xUpTW0YgcnNfy3yF7Fh+nhmYVqNQ3CeEKwpFobtkeonnjipK0RxmAz9C4gP4iHT0COwdAXgfAyOlPDYL8q
 i51DnseV
 7KAzfNqCkb9nbQLN5KDDlXyQk2pbx66UTa/H5NWLLVkJECCp3HulrCAJCDBwh9jTHJDzMEphvqncfgImprMyyhBAOOo11djqw10uTata1UmocvUmsftjYfYDU7nW1fg0wxEwGU7QFeYps57CklRcfh/R2zMcq/0ihvFCM2DYi67Os+ai2YUSer/EvayZMAtJ7j4VJCtnCXd90IkcVO82022nRpFd58zolRT8i2p2twJCC6f+HBxI/vKd6t1U71kbLpbQtOzaYpyA+jYIYLUaEiEgZZFouz6aEZIHF82rr9gSrfkqbyWJpVnCvbvyMe8yLsdSpPbrcbpmiOH0XjacV5hgsMh/HzGO0X5S1A9skmrFVxVL9E1YET0HYoHmJgcMLeaOPJgTDnEcBDMUlFGBzZwwR4bN+35NJhqlq
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



