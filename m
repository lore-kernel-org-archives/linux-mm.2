Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1A6CCD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:17:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 207A96B0088; Mon, 11 May 2026 04:17:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B8826B008A; Mon, 11 May 2026 04:17:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F5676B008C; Mon, 11 May 2026 04:17:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F15CF6B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:17:42 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B0A7640631
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:17:42 +0000 (UTC)
X-FDA: 84754435164.16.17DB7D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id B0E21120003
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:17:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lklb5dBo;
	spf=pass (imf29.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778487460;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SgkK/4xhFGnxLwXASRdn+f7HdU8eyNKC8FsZ6PyvRhQ=;
	b=LNY50YUY/Y74KROhIzC07j7VmhhB7ZAPkUBuy7kIrVzSG9L7OB2vnAihPhRhJMtY30Vt3N
	GvgR9YgdogDmL0IcHYGFFR6ZGDSxo5AATCj29G4XBxDEYkkjgxOXfWYwIQzP7G7ij81UBY
	WZEVqQSoMhq5zE+6BQrwSjpl/NxqorI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lklb5dBo;
	spf=pass (imf29.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778487460; a=rsa-sha256;
	cv=none;
	b=KVxxL56O5N1XAGgsIguEVuZ4Jxfr7yJs9TsXLLd7q/bKOmHjrxCyQCx/GLWVDCeTQ6GwMJ
	Ic2i4iQapmawdtOB6aVzvU3F6PMNTbiPIRcOn6TPG1IrGLoKAy6vn/loO0k19r4f6oSnEi
	kkP8yRh3+FgHK+fLPGBsM0NDtLrPyVU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4F8BF600CB;
	Mon, 11 May 2026 08:17:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 05DE8C2BCFF;
	Mon, 11 May 2026 08:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778487460;
	bh=NgcWajqEHrBjrpmlHzE3kqeLHOp/AqP67j8VknlwGaM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=lklb5dBoxVRCImOirb44qTKbSoeHc6BP4hxrDKlb3sYWqCGmeZcqa34gKZaj0Ewd1
	 DuIkCs82md5UslRClm3NFlVvCmMM4lpMLhKtOScmLvlfW/R6DTo7SRKEVoT2Nlxfvg
	 J+HJk4YzaF8OmgMTkBJe+RLhcrP/yXg1S/Hvy03lKfQLJ9lL0BGA5VupgkiksmgPWz
	 pOpnzRCQOwud28UXJqYg/cBKyIm81C2filUOE+1VbMSJC/1PTUNODNE0/4r4kdW+9K
	 IGQItFuswyeF9kvoRO1Qo+dtKW9L9QzMk2cQLiGhH7ZMqymDDB5MLBYsl9FK1djZYg
	 bAPpyaMEfb5og==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F216FCD37B7;
	Mon, 11 May 2026 08:17:39 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Mon, 11 May 2026 13:47:33 +0530
Subject: [PATCH v13 5/5] lib/test_vmalloc: add vrealloc test case
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260511-vmalloc-shrink-v13-5-643b7ec277a9@zohomail.in>
References: <20260511-vmalloc-shrink-v13-0-643b7ec277a9@zohomail.in>
In-Reply-To: <20260511-vmalloc-shrink-v13-0-643b7ec277a9@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778487457; l=2905;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=yP1QXayDidKnNU2S8I7BqJprRzQI2mQyl0fytHsaqPM=;
 b=4sftg0lX1QRYVC4uS1Mfv3d3yWqs1LKXS4cjJshvIUVh1O9KSllGK1tniouv34PgmJwRDEb8s
 OYiPT367YL+BL639bOvAx6C1LgV+B0ayCRMFwLVnSSZXuPwNbPbhllO
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Stat-Signature: ad9nhawooi5pewrommk1tdwkxzuqunco
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B0E21120003
X-Rspam-User: 
X-HE-Tag: 1778487460-818024
X-HE-Meta: U2FsdGVkX1/aKVQssSxFGD+RovIkTbVK4Pthg58Rf6Tw6wEmHrSs3U80gXQPXVrZB4rk3KRjO+grZrGZ2/RLlJdWtEJN3ki6iuSdvGJxmVfKCvwI8Dibd6IeVicMudRW5g/7sHFCWhFRvAha5z0pYyN7O2WogJ2Ef5kSllevtYHoU2aUTOKPFRBvUG4WtPaFyzQgob/Qz30DOGPBcIhIqJurHqFjy4cIdMpkHBC051iXXowoVYuJrvkJV1uRntIGRk0q6LwNvGWWZJVDPNOnVgveLHxZe0IuWBkS1RqLGAVqVfyoxu9OPWvm7WozopKeilvyp08TlTTupJmXSE4Jx8fTXjhWHiFTR4+/TKVstn/HZHDxSjuED8kvFjfQBKXWVcPALBIw/Nb4sdL977t5gzAlr0Us+iGZj7CrC32kCVjmkL+zBWItPAYlSavi9w5SmEnFp+E0iPLPQH++90tmT0Ut4BbXwW8aSUvMDQqnROgi315+IS662rrLfM5Ezc5+VYl5DhdlliBRmM4JcxGgnM0OssaxpQ/BT3UCuDc/s6splZbwnY/tcspuqmaXJTsBJgXxU3bsOv6EKF74eLYuvYAh7W1JU85HCgHFI8rkSLCcYThm2q2sWHroqGgjcB+mxhNwR6esW7gDhtL2thzbhkh7z7hi3DIAurYOqGuuoRAWGk8RltdCLLKsT2frVImZyVw1H2EsCFFf6t9UtNs5PbV+rUVP5T+uwNEFQlHQVGeQwr7DcT80r32GZD/8pERIruLFu+hu/6ZXVhfpI/ZZ7TOFThfRzeyhOyabWHkv0eZHIuNlcMON6O2TwvXSU4twoOq9MD8AO6fo34QMz1pESNnLbueZL/6a/XA4hwbkRHfTLb2tCAh17Td8xDBhZ5W2ory8VeQLwCBVNNSpspQlqPuncIdelOaAIS3hw33YNLfk7kz1H7Andji+QElyJ6EjQdzZK7LT6hRM1L7pyXw
 qzoieVQL
 pU3EASxZWaitrT9ijpeGTBATCZzG22PhDG2g8/nivGYmKpMiumCnJLl91dNfP2xCRw1gh8T+8Kegz2KJw1eiQt6mBULp5qGGdzisCxreYQAubYzjrMIwIlNIcvxNEpxu3xqHeP/CD0EYRRqcZ6Garbe/Ez2Tp5AJZsNdW/+1DoTsKOhup9rT06zKIv3Kz9TCBV44J7A9QHi8zCkWnyTFxCsoUr+t6ok2z+7fKEaGWlx293ecB26UHREpTsb2uD7fzQeHQuRsyJoemlr5GDQVU7Myee673CYFz+vc9dQKD6iWJBkz+/Rz4JCoIHGG5KH7BT251YUiaFECIWE2nADxwWv3zr1lZ6IWQL8Aa/9fZxqiSZ4dVjjo04ySL7ZpD0wP9uJoLRnbhvxY0WseuzmcsXls/R1G+ARnbWv0H16bjGBIB7GpZ1zDB8qV4rw==
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



