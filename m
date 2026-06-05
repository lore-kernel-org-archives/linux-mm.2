Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A702DCD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 13:36:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BB9F6B0095; Fri,  5 Jun 2026 09:35:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 490ED6B0096; Fri,  5 Jun 2026 09:35:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A6F26B0098; Fri,  5 Jun 2026 09:35:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2DA1B6B0095
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:35:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BB4A4C013F
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:35:58 +0000 (UTC)
X-FDA: 84845957196.01.86C8B8D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id B7C22140009
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:35:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GLSTGxoy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of boqun@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=boqun@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780666556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EWiBixMYQYNU31zDIl5csE1S/wX47DtIBhxQyh/JIig=;
	b=j5Wrb6CEDC+FDAtZRZiniHYElvmI3w9V57jcxprRgPVgCJfEN4/aInOGMohWBN/dgueeLV
	g1FdLceID3U9KazZRdph+W7SUg7mOW1I4XxdjQPynuW2NRnF6TrD0RKEs8op4yr8ZuJ14m
	0JBqF1okUljWZZVPj/Z/3dq+gm17x+E=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GLSTGxoy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of boqun@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=boqun@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780666556;
	b=5xoNzqieKGExPsLVKPu1uBvHmkbdlCqr9mhRGQhqwzKWxI/NBb6Qrt2VErByFLxwqIMg2O
	wQUeZdTKNlBbkmvhVYT7kh5rBIztIkI48uZeMuILG7SWpRwpwYqFJLUc6z1LJN8UmS+AsU
	fwpJuXaFkfwWU9MHS42wI6H7Eb5xjv8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 12A6D43842;
	Fri,  5 Jun 2026 13:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEBDF1F008A0;
	Fri,  5 Jun 2026 13:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780666556;
	bh=EWiBixMYQYNU31zDIl5csE1S/wX47DtIBhxQyh/JIig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GLSTGxoyzEE0A3zgCstKowYyJmvozQaxwWfv91puJGVJzhjLyTfSCFzzs1AAq+Y0D
	 lIJpAlGXx0/+XiHVFlj9vqUub9KV8nKtm06wKr0iNcQyXhQ7VekUFJdudg6GrxJ1v3
	 7Eqv7ZPm8+NElnC5cwimKoyVHWnKEtt0g1/MYQG4mSBPJW0Vi7UAk4mL8I4M9L6y5V
	 Oarsv+jjdC7fFB97lu+t84GbR6X8I3GqMgLQo5kwX2RjU0jYc24WUFUmUXhrRMk8mj
	 i6pq5fnOGiFnuuXwoJEk5SMagPPwPlALGxDXcG8IKG1xmZWUbgmqH7ugyi+Iantven
	 yDzNhExGGzNCg==
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.phl.internal (Postfix) with ESMTP id 29B0DF40071;
	Fri,  5 Jun 2026 09:35:54 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Fri, 05 Jun 2026 09:35:54 -0400
X-ME-Sender: <xms:utAiauzIexa7mxKdr2OR2t2kQABg1l9wL-AOcwUq_FTogqYV7v2nFg>
    <xme:utAiamsVWI4FEnSwI4u0sbJKJkE0VzTRqarxTJs38K3FN-mmsHEiN1Nc-gD01gLYL
    vtKFwlmH2gOKHVbhJEu2LLZ5cAU6tno5cOU9JldVVUTFP_6ujl3OA>
X-ME-Received: <xmr:utAianmLQVImeVDOHZT5jZi0oqwWi_egBmkw5tCVNVMqEp-wZU_ShvwbAz4>
X-ME-Proxy-Cause: dmFkZTFtzx3Tos4VS/WdxOab7aAtqT83KRYoC/e4xL0nOCb6pQty9DSyT2t/Oxqun+SkVO
    cMZEcCN5WOjp6C4j+AAnIhEdX3CSbRJ8Ue2tNsJBDrFL6ULtBgvWkBHotQCeWp8k5uQsbz
    k0FRlet+ZGAnwVkNRqfp6f3UC3RPwOllI7lUv1O3gyUDJYMh/GLR4owHw0MCxoW4il/3Lb
    lg6wo6OlsJz47diU5HyF0fJo4ssmn4HWhMDDXvcMbgn1kwB5FB8PtdkejMZSrdA2X0rrEw
    1NqdIXS1VHAvWHyGi709gDhKFxTkm5K5pOAbaKiTP2ufZXGBKQdT4BlTzCV7z6NbqlWRdS
    TNmwv5DFwJa9S8PHhxbDWzMLZbfceTkxemjD8vkgsy7eLPnM2nk8z0FiJ6ZFamfDHrSbKe
    9ALtNJxC6vU4yzqsSz/479whQYrNVh6ZXTIphpow0CB2YcI2FyWxcnifqvDL6INy1MicNf
    VPzL7bQVvvbPuuJSqbvJhIClCjKIw7zTQchWCg8kQw796AOIfksJ8Qy6i64wI9ZnSK03k9
    1mCjRqzaX9qlX9QYXS7rQBAWBRtutkpQIqnc1dKX0+TCKCObtYUFEci8B8/TZu5Zz3Y95M
    dBvvtqAAf7890Hekqu4mItc0DdTgWKqnQV59t4dAXGqO2oQ9ZcA2rCPbpDEA
X-ME-Proxy: <xmx:utAiarA0GChakd4IH8rDHEaLX9NyqceGOey5GTuP0zPop7sBKNNCYg>
    <xmx:utAiagT0x1dpAYe95YwsjAVvL-ydUuu9ZHrC0I-gzJD3wxj0DHbz9A>
    <xmx:utAiarJ0jsd4WHotdnGisGc_WRm6Z54g-l6zQDY6_hz0Cbl0VsgZkg>
    <xmx:utAiap2QebnjRZQwLNqQGHCzdsMTbxKLPGLsLJEMIcRqhJux9YpQIQ>
    <xmx:utAiansjNkktiiol3chCRdEQLcRNgLsGMQ8gna-VFcuRcTUzfen0Y3zM>
Feedback-ID: i8dbe485b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Jun 2026 09:35:53 -0400 (EDT)
From: Boqun Feng <boqun@kernel.org>
To: linux-kernel@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	rcu@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>,	Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Ballance <andrewjballance@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,	Zqiang <qiang.zhang@linux.dev>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	maple-tree@lists.infradead.org,	linux-mm@kvack.org,
	linux-media@vger.kernel.org,	dri-devel@lists.freedesktop.org,
	Philipp Stanner <phasta@kernel.org>,	Lyude Paul <lyude@redhat.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>
Subject: [PATCH 2/3] rust: maple_tree: Add load_rcu()
Date: Fri,  5 Jun 2026 06:35:40 -0700
Message-ID: <20260605133541.22569-5-boqun@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260605133541.22569-1-boqun@kernel.org>
References: <20260605133541.22569-1-boqun@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ks7qidztj4161zo3utaj3bnmk6kaeo3p
X-Rspamd-Queue-Id: B7C22140009
X-HE-Tag: 1780666556-160065
X-HE-Meta: U2FsdGVkX19+zXzNEILnMyUw7KQ4obPMud+0WYvejFBRj7YDd5TWxhgwIW9bzPzaCmeFafvd7uRFyBniPxmjYVWnu9n9IwP5YQ/I1qWwx7mAsNtKSCBJBZZZA3+KFFtzezZUX2FItpZe4IKtNVaZ2br9rNZQPPYBOVieKJHIyQAOst1x3YgJkYHC4d1xY5Bu0g4Lvmap2nqtHo/J2hmtJcRwkOkhmHZL3/1o0sNRxYp1iF3FdjiDDsRUoWK06OkyqoTDJI+AJMV6HkuA9rMsZ0Q6l5JjX2VHZaypZ6oeHkiOrhg5sZzFODgf39DKp/twiWmGbhjlsloaeUeHvts8cHPsO7u3HYTBjpo8UddhA77R7OXv+b4hfdSR3ZCDRCn8txGI6PHrDKVUUuZ80LOYhdWEPJ8ez1YAa/O0s9nTlcxjZ8umnJiqs8A6/8ujew7HjxrEIjFnQvt9cKwrbrymY63VpciZDoAOeQ+H2gaUkg9jWgzW3yKhO7wXRm5d1Ip1wmjWT3Q4SH+EONIGPwyDpzvp1gJtpuPhW7Hvw8CJEPKWJNK3AxcqSyUZ032A5QWYh4nDTmYJIaVuhbvtfEoq+IN2Igz4UH5wH7CO8D/OZlpmrTkSr3j6dNJxvdPZcsDqB2lQUWpeCqI6AIzfaK7oRvXq6EqAJcJgI70QqtbQRsdsUa5Sgm929eAUf1eI0eRMOBMNU3py7Q7Sw8kfmAOWNCAS0OcRZ7SOpSCrAKo2Sy+sIvMURsqJlgtN+GPnHfI+Li6rocZzkIc6eMKZ42ZL2fFdFgXNeDNxW02ufSXX5SfuOloSYBLaGqpr5lSVm7Cm2e2KaEgpE5UFf/RB+J09oX9H96dsq16yIOtUkndTzUxpXWmvVHHlAZa7euPhFUYA+WFTWyyWG7JeKq+J/dSKBmNtEXz5NH0MYviWxCg60ewTuXCX/QFTbTC9UM4AvTASBK7EEhVDRJ+goFT5r24
 MNtk0eRr
 YOZUi/WXl2yCLtjoZUeOrGOkvhGFY0hv05XytRKhIw1GZMK0GVzv7Hag+cLCQPAe9z50E7Fhjf5yALJJEcGgUNEv8GhIXt5Kx4Qx3ueljWNPrExSUjwbKnhpIPAjeqkPNGFmUDFtTQeGx1fCq3wbeBFXrND3XDfTzfcjS5Q9rK90XxhH+pHwZIq+b6Hn8D36JP1GHe5L4ZdcL66+zcA+Mno/22oDReqop6jQf7z6j4Yt4+RhS4eZr3GiNaiNvRCgUZi99PjgWQYFi2jT9xuoKJ8I9IhjHo4oS/IBAxWh6XEy4gZacdQ2b4jqwjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alice Ryhl <aliceryhl@google.com>

Now that we have a concept of rcu-safe containers, we may add a
load_rcu() method to MapleTree that does not take the spinlock.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 rust/kernel/maple_tree.rs | 52 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs
index 265d6396a78a..1499191b8935 100644
--- a/rust/kernel/maple_tree.rs
+++ b/rust/kernel/maple_tree.rs
@@ -16,6 +16,10 @@
     alloc::Flags,
     error::to_result,
     prelude::*,
+    sync::rcu::{
+        self,
+        ForeignOwnableRcu, //
+    },
     types::{ForeignOwnable, Opaque},
 };
 
@@ -233,6 +237,54 @@ pub fn erase(&self, index: usize) -> Option<T> {
         unsafe { T::try_from_foreign(ret) }
     }
 
+    /// Load the value at the given index with rcu.
+    ///
+    /// # Examples
+    ///
+    /// Read the value under an rcu read lock. Even if the value is removed, it remains accessible
+    /// for one rcu grace period.
+    ///
+    /// ```ignore
+    /// use kernel::{
+    ///     maple_tree::MapleTree,
+    ///     sync::rcu::{self, RcuBox},
+    /// };
+    ///
+    /// let tree = KBox::pin_init(MapleTree::<RcuBox<i32>>::new(), GFP_KERNEL)?;
+    ///
+    /// let ten = RcuBox::new(10, GFP_KERNEL)?;
+    /// tree.insert(100, ten, GFP_KERNEL)?;
+    ///
+    /// let rcu_read_lock = rcu::Guard::new();
+    /// let ten = tree.load_rcu(100, &rcu_read_lock);
+    /// assert_eq!(ten, Some(&10));
+    ///
+    /// // Even if the value gets removed, we may continue to access it for one rcu grace period.
+    /// tree.erase(100);
+    /// assert_eq!(ten, Some(&10));
+    /// # Ok::<_, Error>(())
+    /// ```
+    #[inline]
+    pub fn load_rcu<'rcu>(
+        &self,
+        index: usize,
+        _rcu: &'rcu rcu::Guard,
+    ) -> Option<T::RcuBorrowed<'rcu>>
+    where
+        T: ForeignOwnableRcu,
+    {
+        // SAFETY: `self.tree` contains a valid maple tree.
+        let ret = unsafe { bindings::mtree_load(self.tree.get(), index) };
+        if ret.is_null() {
+            return None;
+        }
+
+        // SAFETY: If the pointer is not null, then it references a valid instance of `T`. It is
+        // safe to borrow the instance for 'rcu because the signature of this function enforces that
+        // the borrow does not outlive an rcu grace period.
+        Some(unsafe { T::rcu_borrow(ret) })
+    }
+
     /// Lock the internal spinlock.
     #[inline]
     pub fn lock(&self) -> MapleGuard<'_, T> {
-- 
2.51.0


