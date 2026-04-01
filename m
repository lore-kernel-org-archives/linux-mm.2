Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E12010F6FDC
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 17:17:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8EA76B0093; Wed,  1 Apr 2026 13:16:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C172E6B009B; Wed,  1 Apr 2026 13:16:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97DD26B0098; Wed,  1 Apr 2026 13:16:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7A9A26B008C
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 13:16:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2D8EF1A0155
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 17:16:53 +0000 (UTC)
X-FDA: 84610641906.13.7DE37AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 21FFE120008
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 17:16:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Iya8vXGd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775063811; a=rsa-sha256;
	cv=none;
	b=0CI9VTmnKsIDIBGYfq0xpzcEnFbyvj6wd4Cif7PuaVhSlYSEzvi2Zkos/4Kn773Y9qV/li
	yeizbL2JB/vmSycKdsNbVkaepqvgGM2Pa8rxTGNFE7K9cUxvPT/6fjaPXSGQwnJl6rDTHp
	ifnb5ADw2dCghYdADpEEzxZcXt51MFA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Iya8vXGd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775063811;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SgkK/4xhFGnxLwXASRdn+f7HdU8eyNKC8FsZ6PyvRhQ=;
	b=Uwm9hzN3nzzo3DNM54Rt1VleIq8JCvBiejgZeawdGBwnmTl+kjHR/KeKk99wsXt746I7Od
	bK1e0eeSphoRUMZ/9gebkcgxrkJASwqJX7NVJz7SZwHJEgyKmXbLNhuPTbnY2AU18Uh1uR
	7srvayHnQpvkPzg0+xJWGQAkHzbHawM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1BDDA42DCB;
	Wed,  1 Apr 2026 17:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ED531C2BCAF;
	Wed,  1 Apr 2026 17:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775063810;
	bh=NgcWajqEHrBjrpmlHzE3kqeLHOp/AqP67j8VknlwGaM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Iya8vXGd+fmwXV88td2Z0XWbPF2NdANMRqUGbEVJIjsCR4oH0KSGqKZsrcigIIxNc
	 ZgnJTwsuQM/lF4seFd8RvToVpXMAcMRrGC63kUuCd2RNNSezWEzU/V2rOcIdgYHFZj
	 F/mfQHJ0ZhwXmYKiNI8tE+ZCfYfPm+3NBipYEu7IP5ezYVhfie8UBTHjM1ZC16sf6V
	 tQ5vO1BozWfkeJRB2OM4fkDOiTtnOPCZ4/4xZ2Igr9EuWikAtqbnR342i/g5poJ9o7
	 wGWu6ztUuoA4zWgE2oXm2UgBopfxM9AkRjaPFQkmA5RAI5f0bivl8ZSR9oMFv/2hV8
	 9JOi8m2jU2KRw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF81C1076381;
	Wed,  1 Apr 2026 17:16:49 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Wed, 01 Apr 2026 22:46:36 +0530
Subject: [PATCH v9 4/4] lib/test_vmalloc: add vrealloc test case
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260401-vmalloc-shrink-v9-4-bf58dfb997d8@zohomail.in>
References: <20260401-vmalloc-shrink-v9-0-bf58dfb997d8@zohomail.in>
In-Reply-To: <20260401-vmalloc-shrink-v9-0-bf58dfb997d8@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775063806; l=2905;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=yP1QXayDidKnNU2S8I7BqJprRzQI2mQyl0fytHsaqPM=;
 b=K+rvqijkH6LgioddShavqfdDzGqGhFPpOudpCsY2f5P28WR6Xscdt+/cPBZMV4+aWr6Zijp2d
 Y3sYegmUeZYBuDOhdMAZGuZmXpwWjr78v8g053MOKdoIlCWSUOYYW2B
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Stat-Signature: iyjoikezexnmabyqy7cgfwnqsimn11n1
X-Rspamd-Queue-Id: 21FFE120008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775063810-654502
X-HE-Meta: U2FsdGVkX197Kv2dkVMsuCf8nCvjeEiTqyS2zzv/RJBBMxdTa9FC8dXR7jNiMQ7BUYsoYtiCcO4u3kZSKos4JOFq7cb/EK7AidIuHh9NMxVizD9quvYJU/47/wVzUsd7HYNYcVcrVcaL29nsrNLUK8SlQwVJqUQ949yR1LDPghmdkdnnb5NfDSn2sd+QG74It2AEvz1i39b8Ij1McY8QZfiILSRJxJuuhWoMtSHdJwgvAnkECj7lKD3ncu/pi1u/8ZAtYqIIzyd6sLbTS3eWmUMc5IhItPWEWbyUjNGOd3Zn7IXKFFS3Le/ntVqqhXxndDQkos8dgBn/u4Hnm0gtGyuHqulgsya8V4tv+eWhJyX9H66adRxcz1z73mxhYENsdI/SxOrM1Lkwjk6A4m8x75hsJO2yX8wuBBf0DYynMxO8DqV0eWVMeOnr9yw0qtXAfcOyZ5S0O4Anz6YZeE7zXokkz5IWn6hwG3E+DIqSX/hTx36m7uW/4JXmYENIPKZM26CGUAayyh4GtrbAFdxxUl++Li6YKEEdQUEIsv4c0U9fIjJKRS9QD9vRyMJ0mIBbJLX8QJedjkznzIv5WcindhSI5xBqqIIVpqxTb8QmEiT2DEVkiM8gX7ExEGmLvSd5RwOclPtt3rAA0bh5X789GqUztovYyRQufneUM63zKYC36NqFclGmC0rJR2dUbetE3r8LgoeG02XF3zRqVmxiHFQB66wSJABZMq24UqXYCMzz4M8VozffFOmI1NITFdqIDmPx1gCXpu7VaBcKLUsORn4LDqjai/eG/dCOohbpCiqok0VkRpaopP6Ok9Q6hmbvX7w85GaVcXmPLh2iu8amb1ezpNzhrUOmJScR+vFoJm08bUdB4rfVlY+nuqoj/zQGnjiYcUxkv+q5oVInK+wZtnymuzXwC6nSpJnBvxMkdNSxeaE28cpHvWHVF1CmOatKucv5w3m/jtRAMMu+ayU
 txtYTjZX
 1D0PvTfuy+z/hDKF/7NPWxNBgDoFWkjwRVYyVrpe9FyjrGHFADSKIFcRXBWsUqwuDTEqavz6BXUaETq8qReO/Fcp7lu4Atc9aT2XWEPSZMGfT8BC5Dbqd69UAfIs8ZPXeZHm6qRpXnjBEz2U1KxW+RXMXbXfGFpV8WKrymR/CYOtMDFYo3ac1Ovzj3fU8wHUjF/WnnyPC4TGtQlvvaqzd0yEQMzYoEdaauRBVoETSy8iePnGc0qh+RIs7RlnOAd1i0a4K1gwPPYa8O7jm1VY4ciWlIC54OQRioAzD7GTdMDKFPsb9fDcMNCFqAs/k1f1Pu5KOoMIa0NO9J6oK02oYkRz1sV3NajxRoN4pwFKDCts6WLlnvS1iNQ2+ek9yKaqAPM83tWJdRFZhSaixQ6DrTeV87N+3G2KiCKVdjcRcQEAaq6V8R23o6Fxing==
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



