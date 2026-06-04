Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FCB7CD6E75
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 20:00:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 896926B00A3; Thu,  4 Jun 2026 16:00:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86ECC6B00A5; Thu,  4 Jun 2026 16:00:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 784CB6B00A6; Thu,  4 Jun 2026 16:00:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 675616B00A3
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 16:00:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0DBEA8C77D
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:00:37 +0000 (UTC)
X-FDA: 84843297714.18.561B353
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 226341C000A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:00:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Td6OZ0oB;
	spf=pass (imf21.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780603235;
	b=r+lvGuVKJDrwYdvN42jVI9U8O8r1+NYDdtpmxl2FC7hpY73HdwREAPkRgust6fzNH4JszT
	i1SMdYS94FAhzLbWNDZvx+YhTkLmnPCSpw3L+0TPTon6NJ9rvfTVPV9iA8ApbfIWZAkSML
	35FpyLcpFeYMosxf340KBclkYrdMTHI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Td6OZ0oB;
	spf=pass (imf21.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780603235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p6YuYMOYnDWDBMZ9bbEPIsqKNsVYpVFYY4aODNh2Npw=;
	b=JKe3as222G7SnHTx07QQgflk/Xp9qUGSMVjaP5XnLfSRwZYqUxbXR2AsZROSjImavScy+3
	lSaoNrhSanREfuG79Mtaq/PH4YFJ7LqBipFVA5b5DPEr5QIv/sKA/Mq6MwxteZWdcLOD87
	A3okNhA2u6r2HmTiWOmeUgrnjLsKYKE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 405E143AB0;
	Thu,  4 Jun 2026 20:00:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E8091F00898;
	Thu,  4 Jun 2026 20:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780603234;
	bh=p6YuYMOYnDWDBMZ9bbEPIsqKNsVYpVFYY4aODNh2Npw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Td6OZ0oB6NVr21aNjgjcbw9w8ngfB+Z+W7pM31bHdmaKrm8mUW+6P8SMyO01LTBB7
	 aZ28jpYveay9tJ5hxsepy0tMwjd+/K0b0b62mriLyAfadJMX7yOH1xbVLTH+GjxXIW
	 xXYy9mdQsnEBLW5xw1hY9Kx7iB/BqUo8bgnwsoQkDL9Z4TKuBOLPi1A22j8IJPb4Ti
	 Ka+XELivsbPTaK1xUt4+ZtPAvJCiGqPgtpQLJloAD9LeeO44w71KP1xUap4+A46yWV
	 5FvJdE5XAPsDDdly6nKoknfZMmHKtutNTU2Qbpxq6B6s7x+Xz24d0yStjFZQO6gQYr
	 7yMi00M3QyZsw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Thu, 04 Jun 2026 21:58:10 +0200
Subject: [PATCH v4 04/11] rust: xarray: use `xas_load` instead of `xa_load`
 in `Guard::load`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260604-xarray-entry-send-v4-4-965f6028790e@kernel.org>
References: <20260604-xarray-entry-send-v4-0-965f6028790e@kernel.org>
In-Reply-To: <20260604-xarray-entry-send-v4-0-965f6028790e@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Tamir Duberstein <tamird@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Tamir Duberstein <tamird@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Harry Yoo <harry@kernel.org>
Cc: Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2450; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=oYaezwlxJQpR8UtIF1kAo4ndp1y9jT02xjr/aB92Sp8=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqIdjtXXR6p/YMNbWL1d7vr9jQHRbkshID8Gu3F
 6Mk1qpxbzqJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaiHY7QAKCRD6UCkIqsW9
 0Hw9D/sExDzOpSwLMZPByJRIDOftL7P3W6n7egMhr5eH9jrbr9Z0/bBmlY2GkTSChDdjCeti3iT
 PVzlvvzpBFAgB4xhGAZc1fFPSzbzCqh4RJPCS0uQJQPIVONDRjtimSwNNnBq96darpyBzlwFvEn
 KjsE5NUuh3cK4rWz1wFY4lmNJYvY2V/WhPSgF5uATxvWeWGOLBpehSE3VVwxLmPHj6pV7bLUUUz
 khgcIVMTUB/gNsL83eoQZ/W5bC2Kn+KxIdS3rHNP914QHRl6SFYIe8JmcLhKOLo1mKY7cx/Qws+
 4MxvLHw9WzELoT2fl28hr+JJvFP98b717NvSCD8IlX1nQtNIGO176AFpvBxQva/iR9H1B/tIKUr
 iVyK/L7Sf6AC85xIEkE/HgiHEYgWDLSgIurtf/qli6Z/acWX218XdPN/t4eBjvX+viDKN2FgU6F
 8tHLcVGzVaS0RSEYlgZdGH2HOWEsoVrPnscKZxlDw0uNJL2bI0DuJJf/pq+QUdwC7shxxbP5aJm
 f0vrRRd58MuAyjwHmuDGjD/mR4jVQ2IocIaoDuGFn/21bOKIoo2viRFX61R0ygKGgslQdPNHbrN
 gTq6DgLkQnZ3tAS9a7ey3JIY2SuAfHi//Uwe6zTdpbn10CTe4EAimfAbEFxVji5kns8Fk9TGqWE
 PbSDm83CaEkfRDA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 226341C000A
X-Rspam-User: 
X-Stat-Signature: mkw5hgo3bukexwdby8w4tsrwpq3m1oid
X-HE-Tag: 1780603234-699014
X-HE-Meta: U2FsdGVkX199/Fpsn8cH1uAQSvvivkstsmWWlvcEi7O/OJz6WXbz2+M43tiBQHaPxve5A2Sdx8xNH5IySqarWjMh/QnVqgj+o8SuN4EUv4JIP3dis71wQmReYm9mvOnbKNc4Um5CAgFAO+GxfpOzsUltfQoalTKfhVK/3SUPeDaibtkYG3lKs3XN6QC7CTnHutCvmG923+ED7148UTdRV6G7K3OeIf/PQQb8156J6lSyX2zFB+poGHzySL7zkhOLAQ7zeNEwzsDmeV3yND7h8Vm+grK0v21WAdoyjvvQ2enG2uPGbc7YqOoELgOIYJbxVL72b+fu/5mtrK5rDtj0jNqHtrVLa0FiN+XtQtJgqwLReTRT4+2N+mrkVy+XJwi+YjpzBBp21NYeE7ePDVWzyQl8P5uT+13IlqAKeA12Vr9C6beCdAKwx252ygZtH/sM4N/6UBC+g5PSDnax9YEUWPOsI7SgAD0z52dLfSIDUftBTww3XFLgwON4Hs0xRIlhMVZ3TbTW5wmb6eTXDv+R+UFz/jOLUHwnKdgXroHd9LMKJ0Lh7jikXaKBxJ2bDRMsp8YTpdeElbp4gijBkC3a8CpBbqNOVkSzqyHkzGYw3S0HrvVORT45+8Xe8lhyGYnE4MR+A0yJK9i78r+MR7G7S0wbBvg61Q+Q+AJyKRnglPjuv4j0oTgcxyTY2hG2jkcp2ojIHTz1NfFPPVbNrRc+3ngdW9VHOXIBcYt+3S0DTusWlAN0Mugfrb0kNReuU2auGXVVuh0KtNwMmMLYotJrb/Aa5uwxUwKQyVpaCeUvtNJdGhtm0LXk/+BLQ17ZUt7oXtK6NRIQjvlgn0CHhFS1QjWOnj5rWE3Rg5HAitt9NBdQzJjUh2XPvXpi8tcTut6y55NBBII8oDBtblnwwVrixT1I0xmcWzCpAOzhTHerwKlMsykvGqXjhn5UQRDIAz0mC5/wxLpH8jFOrSo0WZt
 skKhaXAQ
 2bH+3y0Kyd6Ycq078XmKZQ+jgKT6DRwYeNPb5Oa2uYU1HqKWWNL5ugxFLcw7BGGr0HaeLgCEZyq1p8/ba5LLRDb5UNnBbamf6udtIfiahPNGlXTeXQ4RNY3H9Wrb8FgS7NymkD5CmLVvIiq0Og4T7Xpi0k8MWKNiHBKX2vxW7I1drAovrq5G3SxlNdEFIuTUXOxsnhlvmAu5Mwv0qRDaAiLiNIzAuKdIcYUWzp0IOMw2O4Yaf0XL1jxvFt00DcVv/+OUTAeSSxbsKFD2v6Jz0xjWHObWwPLi60dYptNMHdO9Sw9HsvKWxtWHDRZSIaKvzLyG/FMF4x3Flyzw5zk2+hPDSaMnWA0AwMfjLs3FFTAwKX6YpXtffwKOVCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the call to `xa_load` with `xas_load` in `Guard::load`. The
`xa_load` function takes the RCU lock internally, which we do not need,
since the `Guard` already holds an exclusive lock on the `XArray`. The
`xas_load` function operates on `xa_state` and assumes the required locks
are already held.

This change also removes the `#[expect(dead_code)]` annotation from
`XArrayState` and its constructor, as they are now in use.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/xarray.rs | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index 6d0d4905004a..05e6dc1ffe69 100644
--- a/rust/kernel/xarray.rs
+++ b/rust/kernel/xarray.rs
@@ -216,10 +216,8 @@ fn load<F, U>(&self, index: usize, f: F) -> Option<U>
     where
         F: FnOnce(NonNull<c_void>) -> U,
     {
-        // SAFETY: `self.xa.xa` is always valid by the type invariant.
-        let ptr = unsafe { bindings::xa_load(self.xa.xa.get(), index) };
-        let ptr = NonNull::new(ptr.cast())?;
-        Some(f(ptr))
+        let mut state = XArrayState::new(self, index);
+        Some(f(state.load()?))
     }
 
     /// Provides a reference to the element at the given index.
@@ -333,14 +331,12 @@ fn xa_ptr(&self) -> *mut bindings::xarray {
 ///
 /// - `state` is always a valid `bindings::xa_state`.
 /// - `state.xa` aliases the xarray reachable through `guard`.
-#[expect(dead_code)]
 pub(crate) struct XArrayState<R: GuardRef> {
     guard: R,
     state: bindings::xa_state,
 }
 
 impl<R: GuardRef> XArrayState<R> {
-    #[expect(dead_code)]
     fn new(guard: R, index: usize) -> Self {
         let xa_ptr = guard.xa_ptr();
         // INVARIANT: `state` is initialized to a valid `xa_state` whose `xa` field aliases the
@@ -361,6 +357,14 @@ fn new(guard: R, index: usize) -> Self {
             },
         }
     }
+
+    fn load(&mut self) -> Option<NonNull<c_void>> {
+        // SAFETY: `self.state` is a valid `xa_state` by the type invariant. By the same
+        // invariant, `self.state.xa` aliases the xarray reachable through `self.guard`, whose
+        // lock we hold.
+        let ptr = unsafe { bindings::xas_load(&raw mut self.state) };
+        NonNull::new(ptr.cast())
+    }
 }
 
 // SAFETY: `XArray<T>` has no shared mutable state so it is `Send` iff `T` is `Send`.

-- 
2.51.2



