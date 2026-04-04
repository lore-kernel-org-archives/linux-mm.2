Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E99A1E88D8B
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 08:37:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92F496B0089; Sat,  4 Apr 2026 04:37:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DF026B0005; Sat,  4 Apr 2026 04:37:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D5816B008C; Sat,  4 Apr 2026 04:37:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 631CD6B0005
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 04:37:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2057DE1D05
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 08:37:19 +0000 (UTC)
X-FDA: 84620218998.07.9B121AB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 27953140003
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 08:37:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="aqFJ/Eyt";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775291837;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=N0b1bmu/fdzvPbfJN1noXSpqaSwRu1m1AyXMAgDPsbs=;
	b=WMzyE14qbsViC/eUeyY2XrVTg4SePHzkz9uKmmDZQnfAzDKzaWeAK482esp6LUIiztZ4Ee
	1lqp3rOR9rtQykzIq5Oy2Bycl/AI1ugK5fMWiZ0RBoNeTa9Ay9xBrBn7OE/bRS4DqeICe3
	aImUBVobPRCH9TvPYmJ6kWVPXJ8973M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775291837; a=rsa-sha256;
	cv=none;
	b=uYNaAJRVwpAdffotKNFKgy3oaMFnZgrNW+Q3b+uonuhnihDvVfPtdDga6OdPiUutdBPnj+
	vAFkmg72eDzmJ4DuUYxQAWd/x6pyRO/sowMp1pEf/cQ0sM7Z6lMx4BokoROUvWQt330IrU
	5hMksjnhchc3kx03qG6YAf6DbspGLWg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="aqFJ/Eyt";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A1AE60008;
	Sat,  4 Apr 2026 08:37:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C245BC19423;
	Sat,  4 Apr 2026 08:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775291835;
	bh=qeeDUSzgQiiO1NXUaiyX7liaN+Ur1WS1wH5ALUfakoQ=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=aqFJ/EytbYiT/Yfr3CS7aepNIl7FR0jZVoubksunV2+47AArYpAqLLRQKS299ifyt
	 +Ur0dDqSei+c0ewjw5LdCg0KFH3qmFftmt6YMteHHAVyx9R6EjZy0z4h4GOrJtQp3S
	 EZGF/ilSFptLHm0aeKQO8BKmv05FGcb/jP2Yc3jWdy7do2aHq9v4EUfvrvKWvNT195
	 D3x4FZWiGHkWKhBjWqTBRHY8ZAZZHYDbHHbz3rEhqenhk43rP++kb4uGQBjHzSB4RX
	 kvzqSoiL6wJ0UnXU7A0jES8qitKeqOVjyfnGAGJI+29tHsHppFzQ7aRgsfQotjQJAw
	 26p1QnbQbRMwQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2320E88D90;
	Sat,  4 Apr 2026 08:37:15 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Subject: [PATCH v10 0/4] mm/vmalloc: free unused pages on vrealloc() shrink
Date: Sat, 04 Apr 2026 14:06:56 +0530
Message-Id: <20260404-vmalloc-shrink-v10-0-335759165dfa@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKjN0GkC/3XQS07EMAwG4KuMsqbIceM8WHEPxKJ50YiZFrWoA
 ka9O+lsCDIsbcmf/fsq1rSUtIqH01UsaStrmadaSLg7iTAO00vqSqwNgYAaesBuuwzn8xy6dVz
 K9NqB8pgHbe0glahDb0vK5eMmPj3Xeizr+7x83hZs8uj+S22yg07pmHJWmrxJj1/zOF+Gcr4vk
 ziwDVtAMQArgDagk1GDBOBA3wKOAX0FiBzkaGPC5DmgGkDyC1QFgqyj4D0pIg5QCxgGUAW8zz6
 TCoT6D0A3AEoG6AqAxjAYb0LyyAHTAjyCOSJA0uhtomh7DtgW4BHsAQTtyQC5FA0H3A+ggEdwx
 w8y2Zi9cyba38C+79++wZ1btwIAAA==
X-Change-ID: 20260302-vmalloc-shrink-04b2fa688a14
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775291829; l=5539;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=qeeDUSzgQiiO1NXUaiyX7liaN+Ur1WS1wH5ALUfakoQ=;
 b=3xi65L7Lm4oLgf7zS5Cuq2fgnI8cQ+uG44RtTcBO4jh76eLDyCQltHPZNFENKvdETxn7AzCa2
 nHobD71o7yACtdPUak/9BoVvOBwT/QQ2LIoz5fBU/LArosDqTzDEX2Y
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Queue-Id: 27953140003
X-Stat-Signature: btg3w9pj9rrq7f8ragy9uyfa1y8eahin
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775291837-5062
X-HE-Meta: U2FsdGVkX1+5aor67ellxsGUcW3nboIoUzoPHtriDc1nHa9FjANwnWm2Xr5etptTXdfUSxCATDQxmpaiX8ivJo7TIedS7faAq750PSeIa4bfN58Jd/qzq+TjsNmSePsO9Aaw6oSyNhC6+FZvLaflO1h2LT9nLj6GAEDAs0B0lsazvTOghUWNDBIYtPtl4Th+7TCwJ8LhZ6onlaU4tZyoxTwrutJwronGTEh/96YVC9lOeyVeEG976xm7YTykpk3Y1HtyiY0Mms3fNnkBW/sB7R1UUr9/HCIKPldUimL7rvKc8nF86a051t9eh4NcMxUjdVAoxMGzOgVL7DEH46abx/d7BMyFyJcZGDQcm1fnWP3lZRMWM+FVFSLsFbw2QSaaRMy5+bHGpySayR/jP4Sjp7YbDLAnYkisCeYBzeQaarzjZSpEOcyNww0xwjaIeHG5hGmY7vABdYngGCfJX3GuMaYhXKm2vogXY50UEtX6jVLim6r5urtKftE/8HpRH4plr5cEtXpu3r09auCRzCEBS4PHkbFSaMLGmqXCuRzahp74aet7P0hxVyBfsBGJkA7rY7OkvKx1kteS/NM6qUa7GMYkJtl9JSPY9Ye1/KoqJ5jOsHd4gcoRJPpv7/2zEiNjIfuGy8KQ0W+6ySfWaWFpToVZAGdOXDAComzDlvuYdeq3nTVRMNf/yRkorcJr9IBrwudP8nKqKh6ccwFRY8AQviVQv6FJW208GVVV+rIazoRLytpc+p7rbA+yVi7LwRu62RnqvuAuJ7UrnQo9m6Dz00+HpADtiM/bTVI7N5zFPNyzIeGDWHcflnL9RZ+Tb46f6UH5FYd/TQwcm/BxOB0W4n7s6f4dfTlixcSVAJN4qNRYzpzwNdAreoPkjVzwdtt/qC9YGEdElhB8PQweY9NSB368odPDKFTqgruqQlXMHJqj5FxEpi7AtCH3G0x2QA0G+pI7p0eqrw8Jan73CyA
 7rFtEZOf
 qyrj/jvV/Z9UDEzgww6xIHvDWSgZpQ8ObBHpbyK5YXg7d+oQD2scT6YZdq4FbyA8FoNGTwtu4By+G4YaBP2v3i21D4VqfaFFEDJd6RR5XXpTFVjoYAOhbmn7TgOYOyX/1TPqU4eSOjPGqXHf1LvRFK+pKN34uLOGIDSFjRZSrQMNhoYWS32yWqfKOcaJ4fwe6XL4vogM1fngCz+SvfzX9CBni8hJO9AAa9U3eTeBsqBkVcvULzac6HTj6YPLErqzKaBsSxjs8x7ezJUvt+Zw9q50fAQY01PDprGV5UI2bE62Pzb7BK6h5UOdfZmsaKLmvekLCQ4k9Lf3ttOyc18uvA7b4rEUpR6FFyd6JeMm1ial9+TSXaqBB0kgrHHBlI1p9l78nF8/6ymQ7uNIpIgA1yanQtArpWvFR1bwthNxDNWWBacwSwM8PY4Alk5cJTw9Ef9T4
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
- Patch 1: Extracts a vm_area_free_pages(vm, start_idx, end_idx) helper
  from vfree() that frees a range of pages with memcg and nr_vmalloc_pages
  accounting. Freed page pointers are set to NULL to prevent stale
  references.
- Patch 2: Update the grow-in-place check in vrealloc() to compare the
  requested size against the actual physical page count (vm->nr_pages) 
  rather than the virtual area sizes. This is a prerequisite for shrinking.
- Patch 3: Uses the helper to free tail pages when vrealloc() shrinks
  across a page boundary. 
- Patch 4: Adds a vrealloc test case to lib/test_vmalloc that exercises
  grow-realloc, shrink-across-boundary, shrink-within-page, and
  grow-in-place paths.

The virtual address reservation is kept intact to preserve the range
for potential future grow-in-place support.
A concrete user is the Rust binder driver's KVVec::shrink_to [1], which
performs explicit vrealloc() shrinks for memory reclamation.

Tested:
- KASAN KUnit (vmalloc_oob passes)
- lib/test_vmalloc stress tests (3/3, 1M iterations each)
- checkpatch, sparse, W=1, allmodconfig, coccicheck clean

[1] https://lore.kernel.org/all/20260216-binder-shrink-vec-v3-v6-0-ece8e8593e53@zohomail.in/

Suggested-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
Changes in v10:
- Reorder vm->nr_pages to the beginning (Alice Ryhl)
- Link to v9: https://lore.kernel.org/r/20260401-vmalloc-shrink-v9-0-bf58dfb997d8@zohomail.in

Changes in v9:
- Remove READ_ONCE, WRITE_ONCE and drop commit
  about show_numa_info. (Uladzislau Rezki)
- Update the commit message in Patch 2. (Alice Ryhl)
- Remove zero newly exposed memory commit.
- Link to v8: https://lore.kernel.org/r/20260327-vmalloc-shrink-v8-0-cc6b57059ed7@zohomail.in

Changes in v8:
- Strip the KASAN tag from the pointer before addr_to_node()
  to avoid acquiring the wrong node lock (Sashiko).
- Rebase to latest mm-new.
- Link to v7: https://lore.kernel.org/r/20260324-vmalloc-shrink-v7-0-c0e62b8e5d83@zohomail.in

Changes in v7:
- Fix NULL pointer dereference in shrink path (Sashiko)
- Acquire vn->busy.lock when updating vm->nr_pages to synchronize 
  with concurrent readers (Uladzislau Rezki)
- Use READ_ONCE in vmalloc_dump_obj (Sashiko)
- Skip shrink path on GFP_NIO or GFP_NOFS. (Sashiko)
- Fix Overflow issue for large allocations. (Sashiko)
- Use vrealloc instead of vmalloc in vrealloc test.  
- Link to v6: https://lore.kernel.org/r/20260321-vmalloc-shrink-v6-0-062ca7b7ceb2@zohomail.in

Changes in v6:
- Fix VM_USERMAP crash by explicitly bypassing early in the shrink path if the flag is set.(Sashiko)
- Fix Kmemleak scanner panic by calling kmemleak_free_part() to update tracking on shrink.(Sashiko)
- Fix /proc/vmallocinfo race condition by protecting vm->nr_pages access with 
  READ_ONCE()/WRITE_ONCE() for concurrent readers.(Sashiko)
- Fix stale data leak on grow-after-shrink by enforcing mandatory zeroing of the newly exposed memory.(Sashiko)
- Fix memory leaks in vrealloc_test() by using a temporary pointer to preserve and 
  free the original allocation upon failure.(Sashiko)
- Rename vmalloc_free_pages parameters from start/end to start_idx/end_idx for better clarity.(Uladzislau Rezki)
- Link to v5: https://lore.kernel.org/r/20260317-vmalloc-shrink-v5-0-bbfbf54c5265@zohomail.in
- Link to Sashiko: https://sashiko.dev/#/patchset/20260317-vmalloc-shrink-v5-0-bbfbf54c5265%40zohomail.in

Changes in v5:
- Skip vrealloc shrink for VM_FLUSH_RESET_PERMS (Uladzislau Rezki)
- Link to v4: https://lore.kernel.org/r/20260314-vmalloc-shrink-v4-0-c1e2e0bb5455@zohomail.in

Changes in v4:
- Rename vmalloc_free_pages() to vm_area_free_pages() to align with
  vm_area_alloc_pages() (Uladzislau Rezki)
- NULL out freed vm->pages[] entries to prevent stale pointers (Alice Ryhl)
- Remove redundant if (vm->nr_pages) guard in vfree() (Uladzislau Rezki)
- Add vrealloc test case to lib/test_vmalloc (new patch 3/3)
- Link to v3: https://lore.kernel.org/r/20260309-vmalloc-shrink-v3-0-5590fd8de2eb@zohomail.in

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
Shivam Kalra (4):
      mm/vmalloc: extract vm_area_free_pages() helper from vfree()
      mm/vmalloc: use physical page count for vrealloc() grow-in-place check
      mm/vmalloc: free unused pages on vrealloc() shrink
      lib/test_vmalloc: add vrealloc test case

 lib/test_vmalloc.c |  62 ++++++++++++++++++++++++++++++
 mm/vmalloc.c       | 111 ++++++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 154 insertions(+), 19 deletions(-)
---
base-commit: b47b4fa4c232ee36aae58630e9d6520e35d33f3a
change-id: 20260302-vmalloc-shrink-04b2fa688a14

Best regards,
-- 
Shivam Kalra <shivamkalra98@zohomail.in>



