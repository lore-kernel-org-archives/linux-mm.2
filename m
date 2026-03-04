Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B325EF8FF3
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 14:53:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0E7C6B008A; Wed,  4 Mar 2026 09:53:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD8476B008C; Wed,  4 Mar 2026 09:53:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3BB36B0092; Wed,  4 Mar 2026 09:53:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 981C36B0092
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 09:53:32 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4710C14045E
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 14:53:32 +0000 (UTC)
X-FDA: 84508674264.13.475949B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5B12F80003
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 14:53:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HZPpQcER;
	spf=pass (imf02.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772636010;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SlcFd9ikzWB3KH67xJwf6jd2TOUoDJMh3xYB0AQ0KVM=;
	b=p93xJKoUAArKOcl4FP9MUw4TB3xFsEMpjjWeK6BrLAodA3RfFLoCGj5iBNBptTNWgRyjFQ
	9uX/3GNgrXjMpJSQWdyUUNXBJIYUHhZclvNWHFpl+RnnuKVgUR4odDXaEDSbW477W8D6SW
	OuhucfEwSwQ3kF63G2xlmc28flCIZtQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HZPpQcER;
	spf=pass (imf02.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772636010; a=rsa-sha256;
	cv=none;
	b=0bhg4K45fGlEUai4AJcB5CyL3OZPIJQodhk2jYln82ggfampr4EylQJ1qucTMSP9VAEcw2
	a6D3XT8Yp1F9iSwgmTcPT6YQf6cB7EcBNSFIej52S9LZPZm5Q1WCjg+9ed3jCCXpGmtCAz
	nadNTFv5lSHlunzP2GSitWMlKYVToGE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A9B7360097;
	Wed,  4 Mar 2026 14:53:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5986BC4CEF7;
	Wed,  4 Mar 2026 14:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772636009;
	bh=nhkia8GqDvxaObq8yMuYcab15Z0X2JGKN5fmCCeEHrM=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=HZPpQcERwzCMjx839qBBWdB8B6o8Kxg137zjHUsemME93KGQt30crj9DX6BbShtNO
	 3RqGd4yKJO+tDMrHaFVsb4K+m0HyALdw2fgpiar5IUlCtFdBXnIN+Q1BGfGYCgK1O7
	 vf63GHbb9+L6vySvN8lz5S/BXLb6mFlD3a+zF00topuDUDdECiHv3ras7jZRm442/e
	 9h4fGLkN9N+bWLcz7AhrQqAT3ZxWi9BIG1sZmIRi+75B/8IT21hvFcqltPO4pFfF3n
	 AUyuhkYHsAOFqqQRc4tmEtISeOTopm3atpPx4lryx/vcNQ2tgv4NRoNkCW5Ml7qCrY
	 YZlFvyEujT4Qg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29FA1EF8FF3;
	Wed,  4 Mar 2026 14:53:29 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Subject: [PATCH v2 0/2] mm/vmalloc: free unused pages on vrealloc() shrink
Date: Wed, 04 Mar 2026 20:23:14 +0530
Message-Id: <20260304-vmalloc-shrink-v2-0-28c291d60100@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFpHqGkC/3XMQQ7CIBCF4as0sxYDiNi48h6mC9oOMpGCAUPUh
 ruL3bv8X/K+FTImwgznboWEhTLF0ELuOpicCTdkNLcGyaXmBy5ZWYz3cWLZJQp3xtUordF9b4S
 CdnoktPTawOvQ2lF+xvTe/CJ+61+qCMaZ0jNaq/RxPOHlE11cDPk9BRhqrV+Po5ObrgAAAA==
X-Change-ID: 20260302-vmalloc-shrink-04b2fa688a14
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772636006; l=2197;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=nhkia8GqDvxaObq8yMuYcab15Z0X2JGKN5fmCCeEHrM=;
 b=WokF0sCgUwyf1aDiiT0AE891J1ZLYuVqXissd55LWAov7k9BR1j+SMo2VdZ0ze6Hwq0leaQhK
 ys1hGxddy3SBn5kuFAbwLyxOyRHbo5m+9x1ed7E0F2AHRMsWk8GZhbr
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5B12F80003
X-Stat-Signature: ecrsr3dm6aho3zhrunpr31qajkwwt8dy
X-Rspam-User: 
X-HE-Tag: 1772636010-64885
X-HE-Meta: U2FsdGVkX1+mWXFIUuMkNSQJDnzhMqNXDYG1oypEJx7h29B+0vcAVREClFA6bsPgYf/9GofMCvdJVblf+EQOFOC39624fVVEhP2MxN0BgA4i2yep3GL3WZ/owhKjT/c6dEIBemj9QTYzPprKfiaig3wJ+x9i5Gj/vOZVU184KhVH6LsG4dDNibFy4m134w2Ail8Jw6BKwo+MEggvfijwAIemIvVmtqNQtNUtQtdPrbMOmDj+wLOfsGeCNol2IVgIG/Lao6XEjYV0cWwsTCXvbq6JQ3mXPQPZ6goPNwIxnIwB/ZlT2XLADMCR0mSnKHWiLy4c1kmXBdTbXqL5jDOrgGRQFM+DNlWeIiP7hxbuVglQHfGy+KJ3Ga0UvKglk72I4rM/y+HztAZUMG68wRJn0XbJLIaNnNDz8Usm1F2P72m1DolutbP4zSIDOt9wDKci+ccvvMYuN7Iw0P1sPDIrcIHhlS/lVZI/qfBpQXKAd5zERgdhJ7GW+cC6bGH1pz1X3B1vuUqM4K4ifzpV6pCfAQjbcfGMiHYaG7sxl+b4xhNpthlpyBZ7WJ/SGbeBTQ0xQzKE5DOl5HIdDldFi2DzL5JM8951koLcN9ckGEsDoJnC8EwY3EjnsHQESScy9/cRZHnzu/DyuJtqTz10Vp5lyXI9qya5taNqjfvTXfSceSL8ZjbszucJnunCIdfP2kcGLrCm4tw3SnwaaQbG8i9dlCfFrc2SIGVoJKGENVro4gJ2UZa68cyF0GRjfZrrvxu3aqTowi2kl5ztKocd9XqrJp+1bnxNWre5c0lp+UgUClCusVgQOXELPK2bmrgWIwzpPaIgkrFS7AxmeTh4oD5yHIepep+mEJnbCwpjT/4NDPm/1A/9VbCRS6WNjLFkGb3vfLmcy+TcVGcIMQQog6zCgDadrM0+B6qxbmhjuU5QCsrxUNrUcicCFENQOp9hoVUDcf6rSB5fejLK++TGGA3
 2ZgXqmTE
 eFRVnY2QfesTydbZ+s/SUCrqWtfmCk/TlfNViwIpJlpbAHu/qtaCwZPv7pIPBE6K/mHsG7yHBLV+Sp1K+GTDCBbOwJG+T/+vLp5hCI618LV/1s7mHVThwosc9lom6apVFIoo/nISqSZ2uyOvaIf5fGk+NX7YC0ODaeFJfOo4kR1vn8tKghwBRLisYSdMjT6Mhvwjtz1jWHKEHn/VlDm0UkEAhTY5hdd0dzQx/yYr7IFn8yTciuYOr8YPrP54fbEVbJgcIfNmnnltKW7HHE4I/ydzyUvR8oUSzY7ocb/BkjrCfatACrAIgNn/3VUxKAnRSmBmVi8uu7mi2OB5oHvUqU86g547Xb85qL9TVAhCGUKQ3uylwp/RoEYntXZSKSXIfkQ5s
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

 mm/vmalloc.c | 61 +++++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 42 insertions(+), 19 deletions(-)
---
base-commit: 2bff1816949a0849a384ed3cc66c8385d9590861
change-id: 20260302-vmalloc-shrink-04b2fa688a14

Best regards,
-- 
Shivam Kalra <shivamkalra98@zohomail.in>



