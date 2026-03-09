Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5011FEFCD9C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 11:56:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 986E26B00A1; Mon,  9 Mar 2026 07:55:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 981B06B00A3; Mon,  9 Mar 2026 07:55:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87CD96B00A2; Mon,  9 Mar 2026 07:55:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 736336B00A0
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 07:55:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2F7521B6C3A
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:55:59 +0000 (UTC)
X-FDA: 84526370838.10.CF3700E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4C5F5C0003
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:55:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E8W8O9FC;
	spf=pass (imf28.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773057357;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4Ab+sQSdLmIbgo8EKnLIsRUsvxzt/cEj6xmUmGEUYpo=;
	b=m0wd4xGVz3JBCU2sdN6MbmcZwXurnTcnTUhq8NNnup7XxjPe1Uh1eZtF5+GwIrUNFTj/ov
	4SMqXkaxBKB6viRuHqLue1CVn+Wl7yVgkPP9VhkfPaMSGak+h+oRGAA0sXoQCKVjUxf+dJ
	1qQswGtfk+zFDm+nXYMYdVA8dXOZ8pQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E8W8O9FC;
	spf=pass (imf28.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773057357; a=rsa-sha256;
	cv=none;
	b=avGNfhB4c4Wc9C/ZFMU4ekVYwB9DZM8BpTzaj+mBER5F6h9eJr10NXFzgP8zM0ZD3CQdup
	df3R9zvCLagPOoq0gNN2Iq0CQ3rjirbeO2nlf1EecJCYafkAk8BHCcEqsRrDfFKilxArSm
	jgEqdkVNKSdPP7NgZyoy4bOSUMzL01I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BEC4160130;
	Mon,  9 Mar 2026 11:55:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6A7D3C4CEF7;
	Mon,  9 Mar 2026 11:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773057356;
	bh=jlu8U+9Fzz1mb0zaTPT4T2YTs5PlfD7vbOcNzJEvn7w=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=E8W8O9FCpUv0V74r/rq4dBvLRcezlP9RPHPB11N7IU7IyML7f0YqxRt+QdVs7J/BP
	 XrrKhaa5/2rpEMuqgXQYtSsJml0qimuK5/6braksTzb+zt7KYLIjrjaKlWG7rFqGof
	 Lsil+akyKhMwaA65yMHJb4LeWkpQcNhmj95VFA7aaKWH2vklIfAQncMxvao2FSwUpD
	 hw9i31s9KcyELC0p5zciUTHS2ewCJnO2D55vq5vVqEsVlMuuaQ22MbQMmCtLyTOLrm
	 EO+qtA+FDPFiRe/8O8QfFnJAJQm9jemxnmx6JHw484uxZqn9lCvnZC+3MsyqJTPhQ3
	 APUSLU6BzLCxA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61706EFCD6E;
	Mon,  9 Mar 2026 11:55:56 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Subject: [PATCH v3 0/2] mm/vmalloc: free unused pages on vrealloc() shrink
Date: Mon, 09 Mar 2026 17:25:44 +0530
Message-Id: <20260309-vmalloc-shrink-v3-0-5590fd8de2eb@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEC1rmkC/3XMQQ7CIBCF4as0rMUMU8TqynsYF7QFmVjBgCFq0
 7tLu9IYl/9L3jeyZCKZxPbVyKLJlCj4EvWqYp3T/mw49aUZAiqoAXm+6mEIHU8ukr9wkC1arZp
 GC8nK6RaNpccCHk+lHaV7iM/Fz2Je/1JZcOBS9cZaqTbt1hxewYWrpmFNns1Yxk9A/gBYAGw63
 IlegQD4BqZpegNFkO427wAAAA==
X-Change-ID: 20260302-vmalloc-shrink-04b2fa688a14
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773057354; l=2366;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=jlu8U+9Fzz1mb0zaTPT4T2YTs5PlfD7vbOcNzJEvn7w=;
 b=5pgfQzbKvodieJzhPogRQRGbYfEQ4jxUYsqRmvYl16Gp94uAeLz/QVgaiz2d8T1KReTIewEJc
 x3Oe+2Rl5UwCpZL+iiw47sfuk6P0adKOWiCAqe6v0Y+zRc+tBLgwMy5
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Stat-Signature: uekow9zzyr3nhesibriumhrb69ee8995
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C5F5C0003
X-HE-Tag: 1773057357-894305
X-HE-Meta: U2FsdGVkX1+xFDPHUpL2zwCOteGHHNRDj1ha2+LNPA+5tQ5rhtUGGZhhV+FjK9e3Ow0J1eBzgfjOQyV99zan71U4jbNYOPGED1Po4lOjU1CtGewUg2Wux690Qixj7Jb1QoyLSmp3lU0s9b0y3vNDiQBHoEbgU3gfhBSbEP4VJEJjwCIWcZWCyuDJeiV/1ztXbulqupsmnpRklf8gYeqrkc9qm3ygaGt1xcCOQThRE1064p8BqlQ0uqqGbOFqWTI0MakQeUFQ5HCWd0dMNJnGFpgN53lE6Eb8VVa/vghpZT/vS5yO3rOE+I46R9YwgNOQ0/+rOlMQv0MrL0pv37xotupckgx6fAigb+11FZv96J/Ql13W3MCkmhQHO20u0vO7A1EGTkzkBe7zk0XERkHceR7cuG3qz3ci9nO0fqUd4F5Kcq1XCL3T/2NRq2+eSBMyF5e2PpaSJWYdW4pEer+4l7gxfk5HC/EWpgPNNvHxpS1EtsWyfvPyjngODr6uRKVsCBzGvrMa/xjOAizqa4d/iB2pDIf+K3fizQgzWBmkst1T/B4Mn3Grkz/A24aro0wZIiQN1MXaxujm8iYAvBsvm7wobkaSAU5lag9amZKwAPheyoXt/MuPdkGObvCb9LfjTioA6r3cGVtXSijcdEke/raA6+S69yXMAth+rqmLpqE7V3FbUIoAxzNoKqjdFaM3tFQrZQ5i/ny739Q4TJqkCfO8RBC5GV3/+COlq4p85vfNqYFFrU0HDQqJnP/KdXDEP1YNQBCTDV2/PyL3OGZSbMe/2vJ0lLPIpwvrU7iHUFrbKmgKhVYWhDdi2x09e5l70gvZsTF62IWZc+/HeSHq7tAfkJ8+c1QDZdOucZ3LJhnjGF3B2O2bWL/GuDe3wd6Nk7W5StY4QSrn/7hMYFLlQbFEy4TctDECRYPbaKaLtdBlQvQEdD2nMfsvEZ6RBe1QAcH2hdGSIOCKJ2A/8PN
 OZXS2D7U
 ZJ6Wqeid1Rj2fm6vNiCcVBlYUSAp7NkDINKERN28ZqFgMmo9IgIAks5vI1hHgKbsgvv4aRdwIw93XSUw/6eIU5zw33Zb9NSZPx06pFv+jcwbuM8wF4XtohDDSP3cRydk4FV4Ggd07LhrBkJSadbo3jXkVKVsK883dFwLqGzHGgoTDNPXW7YJSP+SFW7YnXp7C13CHaOXPczBJ+nM6yztwkGa2EVUawyMTuOHl1JaxdP9EQiDRm2NQP0dYcz4Y8OhOFgfaH6RXYAg+WxXY0y+0+dHhqyUbtfcXLw21dfJZYqOy18vmDFKZwsB1fKZXvYCTZ62DlsBdGhHL74m/RT+tgy3sYWiNoC1apIaPv++85l5wt6hzJdaGMykgUmGcj8R7INlChnaljTaGhS8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series implements the TODO in vrealloc() to unmap and free unused
pages when shrinking across a page boundary.

Problem:
When vrealloc() shrinks an allocation, it updates bookkeeping
(requested_size, KASAN shadow) but does not free the underlying physical
pages. This wastes memory for the lifetime of the allocation.

Solution:
- Patch 1: Extracts a vmalloc_free_pages(vm, start, end) helper from
  vfree() that frees a range of pages with memcg and nr_vmalloc_pages
  accounting. Pure refactor, no functional change.
- Patch 2: Uses the helper to free tail pages when vrealloc() shrinks
  across a page boundary. Skips huge page allocations (page_order > 0)
  since compound pages cannot be partially freed. Also fixes the
  grow-in-place path to check vm->nr_pages instead of
  get_vm_area_size(), which reflects the virtual reservation and does
  not change on shrink.
The virtual address reservation is kept intact to preserve the range
for potential future grow-in-place support.
A concrete user is the Rust binder driver's KVVec::shrink_to [1], which
performs explicit vrealloc() shrinks for memory reclamation.

Tested:
- KASAN KUnit (vmalloc_oob passes)
- lib/test_vmalloc stress tests (3/3, 1M iterations each)
- checkpatch, sparse, W=1, allmodconfig, coccicheck clean

[1] https://lore.kernel.org/all/20260216-binder-shrink-vec-v3-v6-0-ece8e8593e53@zohomail.in/

Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
Changes in v3:
- Restore the comment.
- Rebase to the latest mm-new 
- Link to v2: https://lore.kernel.org/r/20260304-vmalloc-shrink-v2-0-28c291d60100@zohomail.in

Changes in v2:
- Updated the base-commit to mm-new
- Fix conflicts after rebase
- Ran `clang-format` on the changes made
- Use a single `kasan_vrealloc` (Alice Ryhl)
- Link to v1: https://lore.kernel.org/r/20260302-vmalloc-shrink-v1-0-46deff465b7e@zohomail.in

---
Shivam Kalra (2):
      mm/vmalloc: extract vmalloc_free_pages() helper from vfree()
      mm/vmalloc: free unused pages on vrealloc() shrink

 mm/vmalloc.c | 65 ++++++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 46 insertions(+), 19 deletions(-)
---
base-commit: f27e4dd73ee9b64177649a1490fa20288e0de94a
change-id: 20260302-vmalloc-shrink-04b2fa688a14

Best regards,
-- 
Shivam Kalra <shivamkalra98@zohomail.in>



