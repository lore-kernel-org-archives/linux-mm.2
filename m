Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF05FFF8870
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 20:24:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2991F6B0088; Mon, 27 Apr 2026 16:24:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C1BB6B008A; Mon, 27 Apr 2026 16:24:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2D316B0093; Mon, 27 Apr 2026 16:24:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B5A016B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:24:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 34DEBC17A5
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:24:29 +0000 (UTC)
X-FDA: 84705463458.28.CF9D342
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 26898140010
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:24:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rOZqEKNg;
	spf=pass (imf26.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777321467;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SgkK/4xhFGnxLwXASRdn+f7HdU8eyNKC8FsZ6PyvRhQ=;
	b=1k3JswD/2TNfq6MsFtthLD5d+UFguGtY9kZ5bHbLXVvyNJiahcWawjQ8bCH1qoqCrwWSrz
	ZeMk47hnR9QcybgAiw0SWMz8nnNFrOXJfY5oV9bCNHcpK+iNRbXuKOa48SexQu2J9wjCuR
	c42o63oLAxAlkXxL/l73SiWt7eOktD0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rOZqEKNg;
	spf=pass (imf26.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777321467; a=rsa-sha256;
	cv=none;
	b=NYy+eh1c63QGdIz/fsFHTfrtAqkvtEiXo8OwlSIN56U4ovf/+tcJe38VZjo9/BDHwOyzxh
	EKcg2Q5tIIna6hwv2Iv+bVtJMFiHPkuQny3Sm01wHh7AiGsOfEVclWL4pHwckphV7gMqVc
	IXp8ZcCpukg+J1+uMlG3Be9frTCVYCc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3CC1644055;
	Mon, 27 Apr 2026 20:24:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1D1EAC2BCC6;
	Mon, 27 Apr 2026 20:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777321466;
	bh=NgcWajqEHrBjrpmlHzE3kqeLHOp/AqP67j8VknlwGaM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=rOZqEKNg1fCw1sLp6FyO+gvB8d/3BYUxdw9Ks654MOfq8fwmLpaJu3bWOlqOAdjRR
	 oyJJ3s4IMH43/Sa8wI5IlB7AQLKJ4G3h3i10WDGM/OeldtSSD8yT5xkuoB2AnhJ5hm
	 Ksj98Rdnliblg7+HIzqrnvNY8of48UZZyKk871U1xEoXEjQmcmhd4lQbVqn5DL8Uv7
	 91rKAQla7dIR0ai9S1C6VOy3ip8l07CGx8QjsoSfDoJLJ3aurG/m639ad4nCNQTrl2
	 2i1JvuXpBSK7dOtGGYTD7al1E9t/zaeJBw2NKOTZcqbqO4T1SkvZO4TlgCXGWZ+41L
	 obT/ESnt6vVRA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 148B8FF8870;
	Mon, 27 Apr 2026 20:24:26 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Tue, 28 Apr 2026 01:54:20 +0530
Subject: [PATCH v12 5/5] lib/test_vmalloc: add vrealloc test case
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-vmalloc-shrink-v12-5-3c18c9172eb1@zohomail.in>
References: <20260428-vmalloc-shrink-v12-0-3c18c9172eb1@zohomail.in>
In-Reply-To: <20260428-vmalloc-shrink-v12-0-3c18c9172eb1@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777321463; l=2905;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=yP1QXayDidKnNU2S8I7BqJprRzQI2mQyl0fytHsaqPM=;
 b=i8Z3ANl5DezVl1EY2eeSaDzeTmV1WTIADSFw6u2DzPbrVpqLqS6cK9lt8QLacgjK4BLOJVLXB
 J32q5iaBFqqB+yk1MmiZT3ZRr34vFpbA0+ttS+zQoW7zWEU9VTUdExq
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspam-User: 
X-Rspamd-Queue-Id: 26898140010
X-Rspamd-Server: rspam06
X-Stat-Signature: hetsi84bjctwz3wgd8q5bu91ff53yiwk
X-HE-Tag: 1777321466-57869
X-HE-Meta: U2FsdGVkX192zCyADScegPTdhm+5l6RDu/yCOMMtE7DHbg/peyX3sG7GcKt/whg+PC1uqV3hnIuhwvpW/Ozf0LVEk9ZRwME9F/1x5zend7ZHxBCeUrWZwD9PWoUDeU37UngAKk31X6VcF8SHu+Q9stn5gSObLmPGJeDvFALePYouIybwUYNSc43FqBQQ/IQIbtdtfJ17JzVvSsGeJgWaOtiAvEpR8k8IHtB7u2JsCNHmXlBj9msYt/jctMoXvfPrG1GXeU2K7X6xPdC49XTfrmVygVYYJ+IlQWhazCre3dcPOQIMSvZpMMqUxuzUKx91bSuZ0hVZN9Vlbpd2k9/Lv51SwvKtwyOr2s4S+EqSbYQS6D9cB8ALU9aKlhSt+il+Hl0l7o7ZRmJcEic5VpF1/XaS314tcyZOTGmYVzNYxFReSXEE6ZgY4s33GyeOMZLaoKPDIXiml3gXaMgO3YKnHoq3QTSTn1hJ7AU3Jaij8ui7+KqeVepSVaQAP1jxL/dRhBdXPPDqgCCicE2oboiPhh9tulB12Eb+FWY2hOE55L1Cv0IiVO4p/NPOuwThYVsYN/d5BV5bKfrNPNs4ihbINIeq0YWlN9H5xhPnd+DM92R0tymgHaO8zaJCBfG7R/Eshuuec+5p78eAqnGxGirBcJD46RApnDiXYXrwTRuIMrbnxVJWhQH+kFUiv3yNK0QXPJihuffiHZ+JFE9rqPaaSRevdl28aSML2H3wQMTOs6a3hJy8KWGfHRuuDYx5GoRvof4Hp/fTYVNudWsIdK8oDS/xTf6q/cPkV95EC//PtPvoIt9FFFmCMdrsjpjJ0+ygsUYmNcaK7CDr7xZ5VolDlFeLgGoOTbf7j0xZtL1+JpMwTVv6ZasAwXCKvuUwxZwIwCHnfKAv80huHfTFu8MWygl5w2c3rgMb+Tfju+7wx1Zgpw0k/LHg168Nj2OW7y2fcBIjqGKcnfr2/Saq9i2
 5q9738Gv
 fLxZtJ4ds5z8ESyg/8DdX7Ex1Ss9c/zPIFlTAHG91rWmgWF820ubinTymQVK8UQP6QhlINnEcKsX0RyLfB6+BLlo/dX7nYxeAfThoH6NE4XE/fuGppcxZ54aS3/L6pASepqkuVEl+/QC2kQ+i3NU9ox+K9VHmHtdPQyYVkMxFG7oevlsN+frLxfOmwd8Ll1tC4EsFtXBVGBYhpX/BCph5yANFAgrE2Qm55fRQvh8pPVVFpHNHnKYqF8XY3LrIL8QY6rUUpFP0xhUYGTyRKrZU0VR2g3WjWyPoXPw8V9Jnp8Hu7qrEQUVjr3AHTdpg9Slmw27URz83jE2Vqd/RhU8skntUG5ZcU4hgf+ZHoL87dycPAQMG5Qgto4+7XWLMFJQVgilGXpyQI1htvCFVO5D0lB+aadYiWk/v0cqeVrXFXcgVkA7MDMt28eYOHw==
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



