Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E43E5CA0EEB
	for <linux-mm@archiver.kernel.org>; Sun, 24 Aug 2025 12:07:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C9556B00A7; Sun, 24 Aug 2025 08:07:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A17F6B00BE; Sun, 24 Aug 2025 08:07:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DEC16B00BF; Sun, 24 Aug 2025 08:07:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F1CCF6B00A7
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 08:07:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8427CC08F8
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 12:07:23 +0000 (UTC)
X-FDA: 83811525966.08.6A1030A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id ECBE41C000F
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 12:07:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pUtiUM88;
	spf=pass (imf21.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756037242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sv8zExFw3Bjvfg8B7fjxiovA45pocwUw5TwsrGiDNjA=;
	b=7N2X6i6gzpItkIopzFgbsof/6Lci3S6fRZTQDUe/o4PhgpqW+mF4ozKIfIgeIgqkYyT4Yn
	KP/aR06e+9H+OByLaIMYs24LBQK7PJ3wgB/XCHp/7v2vYWshgxmMQYJoXySyE2EoWgD2ic
	dc2VmA03+dQsi3erEIyKpKSe8qzRomw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pUtiUM88;
	spf=pass (imf21.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756037242; a=rsa-sha256;
	cv=none;
	b=kTVcA+iT0K/ikGeRaR3oajg4fZ82Mkf5y/7I4/dgj4q8Vr38XT39edGOFWYIFtNlcGO3/k
	RYG8/BVkFctWbkYl+fYjwyaWxHSx4vvCnLRQ/082qvoUiImzynjkYXiDcQMSGahI+TqoZt
	jCAeq0J1WhyVni9Qncrglq/5T+6zH4U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 63D2B4059E;
	Sun, 24 Aug 2025 12:07:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB408C4CEEB;
	Sun, 24 Aug 2025 12:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756037234;
	bh=SnnzAnydrJppSoNmg6pqynvwYXekvn3ONwJXu1KClTk=;
	h=From:To:Cc:Subject:Date:From;
	b=pUtiUM88K5W6mmm31lkujFyKujycxPO1LTF7vc6vxkYR6/s7LWOHIkRypL2710POV
	 +JD9+UJWAOPUyibvhnDaIzHoz+sKeC/6Mdf5fUAGr9nPfaJ7gcYHcJIu4Ak8VJ3249
	 UqfF/auwwgT53Jcb+eh0cO9TxzJtU2DIIWEE68KFI2aNJpWPG1gZ4oSVvsvnUECCkO
	 6EmBhSQ+L0sw+W67rHpG4VIyt1YQ12C1bQDbUfkU5WzSYaf/U6Gt1a+4ivPW8PNXfe
	 C/0igBdHdwH8yyrpU5KXr+FgZUs9kHIgK82uDj3i6gde95MLOoL7GRjcTDaRPKSBN7
	 jDv6cuo2xvRwg==
From: Danilo Krummrich <dakr@kernel.org>
To: lorenzo.stoakes@oracle.com,
	vbabka@suse.cz,
	Liam.Howlett@oracle.com,
	urezki@gmail.com,
	ojeda@kernel.org,
	alex.gaynor@gmail.com,
	boqun.feng@gmail.com,
	gary@garyguo.net,
	bjorn3_gh@protonmail.com,
	lossin@kernel.org,
	a.hindborg@kernel.org,
	aliceryhl@google.com,
	tmgross@umich.edu
Cc: rust-for-linux@vger.kernel.org,
	linux-mm@kvack.org,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Subject: [PATCH] rust: alloc: add missing trait item MIN_ALIGN to Cmalloc
Date: Sun, 24 Aug 2025 14:06:31 +0200
Message-ID: <20250824120656.208978-1-dakr@kernel.org>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: ECBE41C000F
X-Rspam-User: 
X-Stat-Signature: 1xepwgdhmaxcrz8rrf91oeu1arhkztsy
X-Rspamd-Server: rspam09
X-HE-Tag: 1756037241-988356
X-HE-Meta: U2FsdGVkX1+LDqIrPY707LlHx+Y9AzGiti/SRkKiEJado0RtdS6DtWG3YaU6lsuWvucQGhWzuKSk6xipYP2ujP01/i2RkgKHvRdVQyrbNMDS3l4llhLv+29wG4rw5D2zbxb/zen3fo0hQyvPahlWSOkS57psaphp6MXa+taAx9atCEjj7UJCDggr+CKkr7wUpNH8I5yxoedB5POgieUW9PVnETaRp6WsOpSL1MgeNEKKH8Xoqpv7nCOzWHD12BXTevRk7Suyv7oYXXiLrMhSXWQU/SzIWtPYXPzZFejXQBg03up1xSepcrstZz/C6kYr4NBFSl5d5DLjsGe5SnkrAnaFVv6l2RGuYtH0W96lw+o9bC3RTP9DyYGKk96ibE8NICajZrJutAiF3uo9WxA09xyYsFOWeWkjZR6P1Bm8Op4ZZpufVY7MCQ5YutaCcE/k0NwyXPeYhx5v8iOv5vWCKBnq0D7h8A/ctCmSdERRvTBnS9517SYwFLeGCyW8jz8lmvKkp/Vzi2ned4p2z4AiCnkvkeZjWwQeCMnphUNOGC2gZmir4fP+LZ2APHsylCYfzuigkxETQHjqm99KWE3iu1Y9fG5TEKyYjH3c/6lpfOH68jxIN3a9k6HaGfqSBYWOaRJT3hnUf4Kx8pU2dtd65laI0VEwIzRc7g1hu5Dm8qZUYlRvZzjukP7YFdxgKmXarRQDsDNEkcWkTq/ZvojhRQoMdxmIHnq7kcnvfePBkV19+iryXswxDPAlYZQs5C/bRS4AlWK2ZVQGe07SJKixR3JBczROaDKRChdNGzdCOabgWemJBMgmgcG+tC8Y9ni63CWNSFW7jXhfFhv28tTrcLxw+xXqXEELCkbPKKkdWKahm0Ug0B1IvdtMBnmvq+4qJGahDFtMljw9phY2Xr/ug6Luip1q32d0rO8oIMPpEyOvPsK9OrBT+0g4A/vO3wv5Mq4XwzrKcPMQQZ1ScOQ
 H9Dgzdqn
 rvWvoRjvhvuGHoklRuROLuKeCJdj+aIkhZkA648zg0lV6DK0cT/WWF9vp/dRNe835dSdnZqhYmm/ZkPHbqFoXLPTJmPpv9wAoMq0uuQXLTE9M/umUE6XUI1cbfd7EscMpwuUiZw4Ntcf19YRWvsanaWbffeo3jxw+Uj62ShBBpeEmMdEStscjsT7MRc8NjdtYRWDhOb/3eWqnWu2hG4fp/fNiMFTfm/KfLN+8FmiLfAAh7pXbkEYOi7RI8QI0ANYFs41yJ3okK7+PlX4Qa9wpwboFJ3GICaf5/yYDEZ1LFT4Avx1tMuJq+z2L4IhHSUSncJPBB/kBCHT1xDfnC7ZekC3I3LC274clRC3R+Ke+O4FNJesktrff7mdfDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cmalloc is missing the trait item MIN_ALIGN introduced by commit
1b1a946dc2b5 ("rust: alloc: specify the minimum alignment of each
allocator"), causing the following error on the `rusttest` make target.

	error[E0046]: not all trait items implemented, missing: `MIN_ALIGN`
	   --> rust/kernel/alloc/allocator_test.rs:37:1
	    |
	37  | unsafe impl Allocator for Cmalloc {
	    | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ missing `MIN_ALIGN` in implementation
	    |
	   ::: rust/kernel/alloc.rs:146:5
	    |
	146 |     const MIN_ALIGN: usize;
	    |     ---------------------- `MIN_ALIGN` from trait

Implement MIN_ALIGN for Cmalloc to fix this.

Reported-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Closes: https://lore.kernel.org/all/CANiq72k0FSBTB2yOjiAy9PnAuyM=-PHxL3uQQ_Cv+zwswnr_bA@mail.gmail.com/
Fixes: 1b1a946dc2b5 ("rust: alloc: specify the minimum alignment of each allocator")
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
---
 rust/kernel/alloc/allocator_test.rs | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/rust/kernel/alloc/allocator_test.rs b/rust/kernel/alloc/allocator_test.rs
index a3074480bd8d..0d3c78ddcd69 100644
--- a/rust/kernel/alloc/allocator_test.rs
+++ b/rust/kernel/alloc/allocator_test.rs
@@ -35,6 +35,8 @@
 // - passing a pointer to a valid memory allocation created by this `Allocator` is always OK,
 // - `realloc` provides the guarantees as provided in the `# Guarantees` section.
 unsafe impl Allocator for Cmalloc {
+    const MIN_ALIGN: usize = bindings::ARCH_KMALLOC_MINALIGN;
+
     unsafe fn realloc(
         ptr: Option<NonNull<u8>>,
         layout: Layout,

base-commit: ac9eea3d08c25fb213deb113d246ff5dadb31fbc
-- 
2.50.1


