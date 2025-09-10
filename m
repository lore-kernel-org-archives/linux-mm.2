Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A180ACAC583
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 14:02:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 415358E0001; Wed, 10 Sep 2025 10:02:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B1CD8E0013; Wed, 10 Sep 2025 10:02:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18B438E000C; Wed, 10 Sep 2025 10:02:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F0F9F8E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:02:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AA45711B09F
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:02:34 +0000 (UTC)
X-FDA: 83873505828.20.7F2BB9A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id D27BA1C0010
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:02:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AuR9s6yT;
	spf=pass (imf18.hostedemail.com: domain of ojeda@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ojeda@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757512953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kuefyyX0LKNCiIkgelX2CjTdz/1p2OWu6SejeoulXOw=;
	b=n0s4Q92wsS9/+Ohfyx0ftXQ63ancoMsl4rLvvujfrixUAHMHptmltzIlYve9n5Sa8p+k2E
	BZio9R50jyikK3T5tOzlK2VaY4Nv9m4hKAY0dQWqRHsGiQT7mrM19zZ6uh/YSRyc08F8jS
	tk2XlK6AqXLVh4OXzRa8xE2idzbatPo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AuR9s6yT;
	spf=pass (imf18.hostedemail.com: domain of ojeda@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ojeda@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757512953; a=rsa-sha256;
	cv=none;
	b=kvtO+1xZSDNLr8njSmMoRcpE2SJEz1jzTCi6GJBRksw4Myl/w89wVfg/adhi+Qgsq0kRkv
	nAe/d2adG33cpWHE35x/TcYPB1xB7MEA9uEoWcr/2XHAc6lFeRLE2I6o/CQedjOpqv2XCM
	3yG1t1iHTLQE22/HBqnObglIUHwgkI4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 58DC0447F3;
	Wed, 10 Sep 2025 14:02:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43DF0C4CEEB;
	Wed, 10 Sep 2025 14:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757512951;
	bh=7gKOy4mWIIMJn2O0tOIMxnNykK3kocaGWGSOwj2zmqM=;
	h=From:To:Cc:Subject:Date:From;
	b=AuR9s6yTQMWSQQvZN4WZuBjynUVlZ+rMRegF68lQI2v/4PQUTdPDXhp1LzfaGPl1n
	 0irZG11cclU7p+rEyLHZAoBXvm+m1Tc6uUXvSI3mD12RlChp7WwE/tMUV1qYNV5Ags
	 9t3Z22UE/GwcJuJr4JiWBSXQcl/l19ASwWMCMTFLrtx1tIr+eVpAW68ozO7rjlqaOE
	 pmtZMEBHvRFOZumP9/OgoBP24ZdDjKFecaN2IIxNNVO59uH+Qlyndh9+EX8CAHwLzO
	 XQV/BfFHizW3KMvJlQoz6m5lk5arf1UhuCffW7JwvCelvlaMlJAB1cwW1AkMbmjQ94
	 kpQmSXjpnJDUg==
From: Miguel Ojeda <ojeda@kernel.org>
To: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] rust: maple_tree: fix intra-doc link
Date: Wed, 10 Sep 2025 16:02:12 +0200
Message-ID: <20250910140212.997771-1-ojeda@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ejs319npsoi7rbrdjiq7x6tyo1zesnrw
X-Rspam-User: 
X-Rspamd-Queue-Id: D27BA1C0010
X-Rspamd-Server: rspam04
X-HE-Tag: 1757512952-603264
X-HE-Meta: U2FsdGVkX19lHbvamK0+jh1q/Rd8IdPV8Z9o6VjrpXSBybfqWHuGEheLJhrxhGYTYOiB/ucE25rHc0g4LfG85P0WeZdrsDWdUgKqXbjfTMq0mgoRONl6B0jzovm9PMZi+O1mQajv1XPXZthQqNdJRLDpmXkvpAKnDwkTsP0gIdAvMy6BwAI+B0B49ft7B3b14F6MHsVGJbeUgdAmkASLhL1de5TAt4FkH9ufQNINHyczxWZ4DgwNoGeK4sKt3QSfGXGxQGpBGgHWS7H7GM/7L4oiWG/0EJFZp2hufYLTGxhaNpY7FoN2WRgbbHZf4TY5b1osMTxRz6slwtkNCvGlLvrQTgjf7IuDed73e8I925L/oWC9eCjQPAtvQF1l0uvq9+2r20QAN3UN6v7aiODOEJ0cHDaqw7KVqEzr1HZL/0UdNhzWYduB6ZnBF0OzdTofmaDaDmMfGSyPEreQ3CB/2FXWG9cCbmRvbH9Og5Etis+kKg0dp8XwcWR8ad53fM/7KulkmZFZ0ZQEdRE5HeiYCXzuLWcW7+drEWtiJ1wEqJP7/I/Y5ugofqDjC24niKqEEIb+c3iy9qpzz/Un9kZePQlvaIfq64T242X942s3EgE1B1FDxWoseShS9v4tPQzXe3Loq1EH6EAQ0IX7DLd8KMCk6FHo+cHgDTfu/BWB8dEH8Pwqu4RagpwPeEmaAWoCYtXUG35bwMNdkmFlE+OYEONSyGmAGik5BhCt0rkFpzDr0/RKmxRNS7RpgL+Wuhu2/mPWKCW0QtmNArnL/1LABeOk5OACsupiDfPJ+NV+8TbybIjY5ncK6jC7UykqazvJpFSXHCpIRiEadR5wTsWW4qJIlxLWlgb5N8bRVUiBClRwd2aGC8kiX2qOQLQ4k9mEbNePCnvHKcmvYhrbAgHa2d+/aSpLo25Iae5bRZy1hOhHg0GBc6uxI35d/FEcsOO4Yl9ij1sRXgX3RL1uQoh
 4BUOb6Jp
 1O9vQuW3XjfzkTphfK5wwJ+gn3TZPAykk+0YyR9pwkfbYZ4dbtHySXR47hsujKWWqfr7ZxC8uCIHN2TvhSpZVyGEqUjIgCVfihTVBB7VdEc/UN73PVu+8mEHVsEqUJbL6g1icXb2zTgKGhT9ZRxGsDSsC9h8NvO5V+9TAIl5MENq6iyDKse8oPHlWwY0jIKQ76n0LyI9rx6C1RP4ZKENBFUwdeu4pbimMs81SnI00sArN1j+Kty3Xh95/rnu2vNXfEFGKZvbUJkN0bvuWMq+HC9UK8VfXQs4FB3XycYk7mwRJ8lG8dos1dcc1cukj4PBJI+1I7nPayP8WikQLOWpZw2rDV04OvGrjgpezqF4Kla8VfBRKgmYxpcP5b2YoXFwPdWVC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A couple `Occupied` intra-doc links are broken:

    error: unresolved link to `Occupied`
      --> rust/kernel/maple_tree.rs:96:46
       |
    96 |     /// return an [`InsertError`] with the [`Occupied`] kind. It may also fail if memory
       |                                              ^^^^^^^^ no item named `Occupied` in scope
       |
       = help: to escape `[` and `]` characters, add '\' before them like `\[` or `\]`
       = note: `-D rustdoc::broken-intra-doc-links` implied by `-D warnings`
       = help: to override `-D warnings` add `#[allow(rustdoc::broken_intra_doc_links)]`

    error: unresolved link to `Occupied`
       --> rust/kernel/maple_tree.rs:135:36
        |
    135 |     /// [`InsertError`] with the [`Occupied`] kind. It may also fail if memory allocation fails
        |                                    ^^^^^^^^ no item named `Occupied` in scope
        |
        = help: to escape `[` and `]` characters, add '\' before them like `\[` or `\]`

Thus fix them.

Fixes: 7f51d867d2ed ("rust: maple_tree: add MapleTree")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
Andrew: as usual, please feel free to rebase if that is what you
normally do, of course. This was in next-20250910. Thanks!

 rust/kernel/maple_tree.rs | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs
index 31b6c13d08ef..e72eec56bf57 100644
--- a/rust/kernel/maple_tree.rs
+++ b/rust/kernel/maple_tree.rs
@@ -93,8 +93,7 @@ pub fn new() -> impl PinInit<Self> {
     /// # Errors
     ///
     /// If the maple tree already contains a range using the given index, then this call will
-    /// return an [`InsertError`] with the [`Occupied`] kind. It may also fail if memory
-    /// allocation fails.
+    /// return an [`InsertErrorKind::Occupied`]. It may also fail if memory allocation fails.
     ///
     /// # Examples
     ///
@@ -132,8 +131,8 @@ pub fn insert(&self, index: usize, value: T, gfp: Flags) -> Result<(), InsertErr
     /// # Errors
     ///
     /// If the maple tree already contains an overlapping range, then this call will return an
-    /// [`InsertError`] with the [`Occupied`] kind. It may also fail if memory allocation fails
-    /// or if the requested range is invalid (e.g. empty).
+    /// [`InsertErrorKind::Occupied`]. It may also fail if memory allocation fails or if the
+    /// requested range is invalid (e.g. empty).
     ///
     /// # Examples
     ///

base-commit: a3bff28df80b33386863823262550491155e896b
--
2.51.0

