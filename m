Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84DD91076386
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 17:16:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 988726B008C; Wed,  1 Apr 2026 13:16:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BAC46B0095; Wed,  1 Apr 2026 13:16:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E5CD6B0093; Wed,  1 Apr 2026 13:16:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E92A6B008C
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 13:16:53 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F3B68160140
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 17:16:52 +0000 (UTC)
X-FDA: 84610641864.02.1EA0E64
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id DA86E14000D
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 17:16:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E1aIlH2k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775063811;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vwMGEPJmPJyux7+92IMULuq/j1M+6Pf6s7wc0jkS+zM=;
	b=eAnG0EqqqIF37Jst0KBevE5acle+cpFDF2HfdVUH8kKpD/c7kVxhkY1n2kRqAMZ8UhYgcA
	LYzdi1gU+obsvXjtyEd28Ca29BrVDHr03woLFeQK4lwAybdIs5kjnLvDhjQeImJOOyE3lG
	DuBGI0CfvHjFUu1FjzQJGhW5N9bKcA8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775063811; a=rsa-sha256;
	cv=none;
	b=cpw99iM4Y+b/IueVGo7tF/nmzZS8tFQoDNio8gHLsDu6inritu9sTtDdcWUfzbsztp/GH8
	es0cuKJ64dnuliFNYHd1ZEXRQ8xMCYcRINLDhIpA091BOSILvbRVTPUus6PjDLCfm6whRv
	3Os/ZKMVPeoGZI7HSlwlerjo+KkuqG8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E1aIlH2k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F3E6542DC7;
	Wed,  1 Apr 2026 17:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CFE87C2BCB0;
	Wed,  1 Apr 2026 17:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775063809;
	bh=GrrsWD02UPmYCvEAvfamqo/z+5NYjFR4VRPRWEY5O04=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=E1aIlH2kYe2i9+lJwfjPQSrN5fsrlDGqenwzf9L6nbwZFFvrepe17+wQgkus3TKKt
	 P1imQbvVhuX/95M4hKQoqXmVbv1oqAXk6L89Q/MAkQ/ga79yVJyBKxosnYAPc44lyz
	 dNcBjt9I+ZuuSYJ7cmSGdo25AL1KQTRG/KCyEd9tVopN1svAZb8iwNfxuUK8DbGb+U
	 RXplXw9Yx9xdNnM3WKJKC2y+FH/qqRwLBEvWG7ALYkKdUIdi076sraDxJCH617v/55
	 Vu8MMx3P2Akqkcy0x7rY8i5v00zjE6LQx5FbVZQmE5ew5vM9XVowPwiFsi0NfGwdDa
	 rnEHChoFnR/sw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C071A1076389;
	Wed,  1 Apr 2026 17:16:49 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Wed, 01 Apr 2026 22:46:34 +0530
Subject: [PATCH v9 2/4] mm/vmalloc: use physical page count for vrealloc()
 grow-in-place check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260401-vmalloc-shrink-v9-2-bf58dfb997d8@zohomail.in>
References: <20260401-vmalloc-shrink-v9-0-bf58dfb997d8@zohomail.in>
In-Reply-To: <20260401-vmalloc-shrink-v9-0-bf58dfb997d8@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775063806; l=1719;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=fkV50pSgKJcZXtbHtu5lgbydbnDdREie8wZ4ZapTlb4=;
 b=07524EnqAQ3AQ7TUxkiDJWQW8JwTQO/aXl40dY1cG4TPB+DhNnC4jyalYGNX251n728AQwiKI
 h4eXxb6A1k6DP/F2SFwNfxWSFWtWLf8wwg0f88CirLI4EX8Tx3rR3M6
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Queue-Id: DA86E14000D
X-Stat-Signature: e7aa4t8rb1d8qaornhazt3d5kyzpnpyx
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775063810-520994
X-HE-Meta: U2FsdGVkX19Ym0hLGFlWtdcmLNuUfiqsvYXu2fYOQW/iXjLn7vrbfX+sfOpU6WIlI23hoObbqEDjGtZXEF06JXW9wQ2IPPpwDJwbAcAKMY0jNuiIH58I0kHchFobOxfK9Ti0UleG/9CgweTg4Wnp8390xX3oKYoxp14gp1cicZ3TM1KI5B0PBohWSv4pVt6be3TZ4xECh5Ry1AOZutKmDMvNnAWe+v3Vk4x2vXyxWxnhptWfJQE4xa1Fo7x/I0jlSHXo2xdZyBqNZWCVxQeusNmZsXTWCxUh5u2KZ8qXyVPoifBksAiFlleYtUqPkB4ThfzLKn6EUE2WT04/ZB4g62durVOx4jA6sLai7l58AhrsAd+gAvrsr3g2KP0VdAw2hITtIYY1PeiTKSVRMXoeVclrAoiX/nUnfsFiKOTeTdjXDlfJlMW2SBL0ntndYMRTBCFWFnBqsOTMpE+5m0yBQE2DAvBl7JckCI2c36aJUCLUiq4u9p73v3/62pDwc9pZQsougEBpwn89J9RnC0I15JvAJV2R4xZOQmGU7qHbteDxmIYHXXHxSlU15dp2pmYvwhvXs5NHEjpiUd3/AofR5S9A6Vci8yUsz2sjjEyn6INMMfWl2sDNLeT2Inx6hJ8dsTbE99ylG92apQXZHdf/sPGh1rSWIgO/Baw47jvgmfQfkLMBRGwVXqvvc4GmCyUWlk8wXCITUpQHfQQ3NLxEdEOcT+clcoJNwFpfzcrCXXPuNxR6mjEivAb0eDTy8Y/UztTdOwyn4Ewlo0An/Zn7lr479LEDf8G/eBtdU0KkGOFQoTbSTGHoyfwmoUIc9eyk41eK+jGrvSBptktxnyw+ptO9nIO6n0C7lAr9CPHekRQ3eyxHqiMTrcQVqnZjzAiz6VFr1aommNlq4oxqkvlzVpLX/GlACvwALB4vs+0DN8DOWyJ3tBuZ5uJ7Lzc5Elonzuh7B2YJ5RT4+6X/UTS
 FMhaJZyH
 p4lcjh7lwfi4qQzt15bzZpDsX9bQ50LcZASsAgyKmYg+beisJOSxefAyoxpqN3SnR5780ZzHfqQ6/1Z/bu0+65ZF3gYdj+5iYjZqJ86IK7Wa9vlUlCaZamuGE1gUE3jimwIBXltgUVx5BzBXu2wFxTJ1kuzH1DAdev1a/sCvorNj1+kv6G/olmRnfxv++crxlY2DDwowHXhynsudsqEDOATAhYeLWwzW2Tb2GQjokrvvtX47Fh89wDQMzu1F0n+SokyvkIjRacutnDhUWdTNPburBOyms4okoLYtUYBM7tGuBHUtlkWBb9LrfiqGBfmBUTAMskt0y3DR6RKX5f+Wdj816vR8GAOpVksYaX1tGmoCVaS9CqmP4tZS1sx/EvmB0avEaWH9TF20fD40=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shivam Kalra <shivamkalra98@zohomail.in>

Update the grow-in-place check in vrealloc() to compare the requested size
against the actual physical page count (vm->nr_pages) rather than the
virtual area size (alloced_size, derived from get_vm_area_size()).

Currently both values are equivalent, but the upcoming vrealloc() shrink
functionality will free pages without reducing the virtual reservation
size. After such a shrink, the old alloced_size-based comparison would
incorrectly allow a grow-in-place operation to succeed and attempt to
access freed pages. Switch to vm->nr_pages now so the check remains
correct once shrink support is added.

Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index fe8700270139..1c6d747220ce 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4351,6 +4351,12 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 		if (unlikely(flags & __GFP_THISNODE) && nid != NUMA_NO_NODE &&
 			     nid != page_to_nid(vmalloc_to_page(p)))
 			goto need_realloc;
+	} else {
+		/*
+		 * If p is NULL, vrealloc behaves exactly like vmalloc.
+		 * Skip the shrink and in-place grow paths.
+		 */
+		goto need_realloc;
 	}
 
 	/*
@@ -4369,7 +4375,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 	/*
 	 * We already have the bytes available in the allocation; use them.
 	 */
-	if (size <= alloced_size) {
+	if (size <= (size_t)vm->nr_pages << PAGE_SHIFT) {
 		/*
 		 * No need to zero memory here, as unused memory will have
 		 * already been zeroed at initial allocation time or during

-- 
2.43.0



