Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09E7BC982CD
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 15:46:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14CA46B008A; Fri, 16 Jan 2026 10:46:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D7276B008C; Fri, 16 Jan 2026 10:46:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA8FA6B0092; Fri, 16 Jan 2026 10:46:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C5C736B008A
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:46:53 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8732F1A83D
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:46:53 +0000 (UTC)
X-FDA: 84338255106.15.ECC9A57
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf03.hostedemail.com (Postfix) with ESMTP id 83C6E20016
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:46:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=St8Dl0L+;
	spf=pass (imf03.hostedemail.com: domain of 3aV1qaQkKCCA6HE8ANUDHCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3aV1qaQkKCCA6HE8ANUDHCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768578411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8XGtH7eRIWG3NpNTBCWRXdsIlOUMi+HesazDDnaKxAg=;
	b=7n1dvaCpNhqnTdiVDa9KvMXjdu9lBv+2vUI2iAU/l3sNOvOs0H3Ub6g2R8VpXW4Gf+7+Z9
	3fvUORzC0AbCULDtIg3zMYQU0DLy0mvke4FzZNl+D/kbuvO2BoHb0axsPYSBIw47MLP4O2
	H8nenM08vZ28cDXuu5Om9DMxzzxfQAI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=St8Dl0L+;
	spf=pass (imf03.hostedemail.com: domain of 3aV1qaQkKCCA6HE8ANUDHCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3aV1qaQkKCCA6HE8ANUDHCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768578411; a=rsa-sha256;
	cv=none;
	b=7GUmmHOw52bdmlIGHN8nZvQtO7iVM7EaJif5hbhqlGHrK1BvtllINGgbwJxcs926VRub0M
	MYzCOzixU9verp2wsnQEyYRqy6fwcs9Z0TztITiONEZTMkTilTaBpObffuE160yp9s+Hln
	9/J7R8lpS3a0/ZlvgJaiuL6AGVHYZQ4=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-47ee1fe7b24so15688725e9.1
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 07:46:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768578410; x=1769183210; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8XGtH7eRIWG3NpNTBCWRXdsIlOUMi+HesazDDnaKxAg=;
        b=St8Dl0L+XLLPrJlPy/iFcr/4qaUpR/3bK2NMH0KTtTuWP8EVi/mEjYpvmXx8jwp+PP
         C2L8oYW65KdfBnoVAGi2FEjVGICZwW02GWY2MpRR5QTMOqxhAhwAEAdNtHzgXrctxilh
         6++sxLWAOL+jMis9CEukW8qwcaZD88CCMKs1NySPRn3JimWbdYl0m8pyOs9xLmtkGO51
         PZBBVPqe5Syz7M+IdRbq5KUB/1c96X+IBdMnm9alnVmoQH1PNNRk+186g+CnDUyCI/S/
         FVdKpqgpyVFg/yStbOPt0UbJlcXV77AsWCb0xYnhFfJD8v0wL0SKLPteMEpnqI12iQkX
         HuNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768578410; x=1769183210;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8XGtH7eRIWG3NpNTBCWRXdsIlOUMi+HesazDDnaKxAg=;
        b=vsXHxlsfSBtZM2k4o9/5v5QT59NVWYoZErdHBQfAbBDF6x0cJzxOdbFrWvWTaYDHnx
         cCvhUlZwnStzR5XFzOmliIImoUBvbS6Hpg6/au7prYFCtZ3gnOcUJ+Z27VVJj140zEbY
         iubjUJUDo+X5Osh16L4gjN94+Sten8G78EmMSzQqoF/Z10X9GBdC70nL9SDe4ENKjbEt
         x4mzctQbQHjUUoSJgqKCduO4MYzLfG1mT6NUrkGK6FKpUaJrRXpx7LrAmphEJUt8vRBx
         zWnrHYGmcNlorRicYnJpEfwtjHqFmSdkPOFGjtMiISV0eYDuvTHBvCGtcvTxnelVYciS
         T5Yw==
X-Forwarded-Encrypted: i=1; AJvYcCWQ0Ynjoby8KcanTw063yEANm9e/lI19Do/1mjkGMnRem/rtO+Vwp8LjAZQoA7jiDwsHlKzSCYPLg==@kvack.org
X-Gm-Message-State: AOJu0YzB/W1J9+OnHHRDmcZNDmv1cYrrRDqJJ5z/pKhAcL3VA7DK4SF8
	tMRAzOBaGKvu8g4l/tQ27Cn50k+VvD8+R+vGn5Em+zWf5zNK0YvJGIq8HO0gP84tReybQTKAgGJ
	z9Qhsm66I4aGT153Isw==
X-Received: from wmlz25.prod.google.com ([2002:a05:600c:2219:b0:47e:e02a:29f9])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6099:b0:477:7b16:5fb1 with SMTP id 5b1f17b1804b1-48024c96d6fmr18214815e9.7.1768578409946;
 Fri, 16 Jan 2026 07:46:49 -0800 (PST)
Date: Fri, 16 Jan 2026 15:46:37 +0000
In-Reply-To: <20260116-rcu-box-v1-0-38ebfbcd53f0@google.com>
Mime-Version: 1.0
References: <20260116-rcu-box-v1-0-38ebfbcd53f0@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=2699; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=k6qM4owknwmZ0WB40LW8lN6xxPZevEl5Zk/TWP4cnbg=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBpal1mlwNdQHuRPBnDEkbjpMyIXbDK8SMRSGlpp
 bXnMzHOe7KJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaWpdZgAKCRAEWL7uWMY5
 RmVgD/4mrfBYDwKDTh846tUygrVVBpPGrwR+pu3KEcaHS9S78rcPTu0xCPHY9Ylnb36FvqkeRQc
 i0plU0JogkIjXeS2MZOwaSS9qf9UJ9TQ6QbLm8tDYn60m+RsMzhSQBwxGV3NQJCs7BREt/RUeCC
 vXZPgmd+AidlxjiKE3/JinBtZvRX1ueXFTu0Jcb0l2dy34EWKNI5w67IdP9WwrvwuCDv64M6oQZ
 2CiBVwM4kg6OMDm1eW6JGRKJAorC/MTCo4ZvA5WI7xD01o27uQQNEjVz8hJYpY7aC4kWhWPv/SY
 h0JJ8QFnK/4PGvCJYY8b262ZCD+cp7Vie74YvFq+g99oNsvk+mtbVRIMETJjmuMpbUvs2v4ocz1
 8pQcNFUp9MfPINoTOZHt7Pn2R/VTIDqng5id7dpFmwJasygE46pPliliNf57woIYHmhDQkLH6Hc
 ZqmBVClr7yQoFjtP7sbkK8sFNIeZhVSHGkN7rkxH4TmOCp3MUumlf6qZH8npTt9SYmV/IzhmzaN
 jQLPNRHRxbxx7HMj7eb/V0AhQVQK98Nw5FB0JhhySTtJqU/36B0oWZYiisLbvb9pe4e9rjHZWWj
 aTdpPHe6XJhq80yU50gMk72HkHc/sDA+xke8/t3BEpQ/9Et1c0C1OQ27f1Q4I89sIDYzSJgTYU4 7v8e4h7qDx1dlyw==
X-Mailer: b4 0.14.2
Message-ID: <20260116-rcu-box-v1-2-38ebfbcd53f0@google.com>
Subject: [PATCH RFC 2/2] rust: maple_tree: add load_rcu()
From: Alice Ryhl <aliceryhl@google.com>
To: "Paul E. McKenney" <paulmck@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Gary Guo <gary@garyguo.net>, Miguel Ojeda <ojeda@kernel.org>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Frederic Weisbecker <frederic@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Josh Triplett <josh@joshtriplett.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
	Andrew Ballance <andrewjballance@gmail.com>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, rcu@vger.kernel.org, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Stat-Signature: szw9imprh9o6bi3ot98s37eyy6w5ku9e
X-Rspamd-Queue-Id: 83C6E20016
X-Rspamd-Server: rspam04
X-HE-Tag: 1768578411-53133
X-HE-Meta: U2FsdGVkX19EB6XyadnF5FOWAGCuSK6SelZNtsjEyqtNcxGbinLbytgcVUnc+kpu+CNAAW00xeMTiVDW/ePVkh3D3calNhxpO0uiB04ZlOuIa4fqmXHsj3IkVKaq0fp2ZcuwzEFFSIIcSwjP1c78MDFA/PdZWyeooXXrb5Me46Ayj6OAycoJyOyOKLhnYbGzlf5PyXGNFQFXUfJHBMQ8XPzPn2BWHPRBj0UZQoOD+84Te1+kxpkZ9mSZQUS1ZbB1C5S/UEJrpaF/AI381hnBXGwH/HaUZK1K4Wtx22A7LggQxPsqn8zcdLxkDUw9Y08XFuklplLWV2Z3CqrNJVyXOSQMbEMcimCPaPwBSYM5TvNhaJlNds80LJdK5KIFqrYtw4ULti8dPpbplypsvid54cQwO9HHyYRKWdeoA/yfW1+uBKNs2fcMJzBz6PR+wnXz/U8959VPTT4kdpF4djjIENp5RokMnwMVF2mwDVWc+pIdSTz7yqe6yukvF1oxueMNiA3kvquvynwflVYSMGRspXgwB7zxLlc5Qa/+qWU/ejchEE9Mrd0IKs3S9Ub6Ri/z/P1rVjXby55r03u3Rr41JHi1OdZpyxejXpLAlBkhxvfCuONC9VADp0nBLeSfAXrx/itduoYVzZV+jEu4bNKhPBLNyKF0xPPV+uVU2aBNH+Ux13GNUP9qZnrmKCIRv1IwrJTJ5eobOkgDcLHs97OyZbKg3a84LPvlu/h2kCEzbQwmwt8h1Vv4wKpqPW6SdNyGYAvXLWNGtas0JhltxFPm38s7LeiccB4uoYLYrcUDKms/9czrPTv8jD7zneC3EFVLmZZ4xiz1UEL4RIrDiyBK79KccOGebxstJMISMCUxHv6keusJDAc6Lv9IANchbmfKUPKR20Ej/qMDwRBz1QKZN3yrRo7dn6TbQkNHz6p8dx5uleHZj3JlTy/eVJZ0I+2j7PlxbFck0YElEC/j0ig
 0O1FQ72d
 jFpDTxuQD5UmNNLlgkFF+XqK/fODzLWBR59R7GLLWZ/QsgxD6GDZgQmbCM2/KBB0QN2XNFmcOjA4lLC9pXhQDhUPGYrjt9U5na29HhyD4BBnixuSyN9sDoqglmBbosJcHlau1eZI1r7LGZdspbbYjGWTpiJ/XhIngd4dGnxrudxlkU+ai2U2t2FFLjXCkhmKp8aggaRUEYpRYkETi5yWUuEVaKRRPcT2BY6DIz7FBYQI4F5ToeFa6JJEkhupiXX8G/e/JVA62S3K4xY3UlkNyVZ1tRRRIaKQALhv5HYvnKYLqDDe2cWVzi3VGqU6gt6XK+PFRSnqfCj18qOrwNXEsFJuieXI+WlOmhgmjVY6Ph9QM4s0QctekpPwKknXnTDZ6DLOFY+UxzWPW3q6+b0LbxHgY6MyhLeoefHBVNTP68Bc+qg3cA+4t2N8d35jI9Ftxkk6jDdXC5hy5n3Jl1UhcGQu+j17KfG51f44b0wHS9vJa5UgY3JYUyigYiOYU4zfgEURTO/hC851qQ4g4nTVfGNQSYpoBHPVJA2nUL3BXQCnSBAR5qjY8l6lkb7BYXsgcKrKC8uYiGOcRUGngFub1MrkuImsmtQ4iznWW7iN5gctS3kmzUUtoyQuZ7uHQpd2oUWYBrJ1sj1zthTUSKlfUTor2Ij88e3YfsjtPfz7YDjM3QpWP2EP2OoQXvw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that we have a concept of rcu-safe containers, we may add a
load_rcu() method to MapleTree that does not take the spinlock.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 rust/kernel/maple_tree.rs | 52 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs
index e72eec56bf5772ada09239f47748cd649212d8b0..c466a9fe0a9a059ad5cff131085d610b76050420 100644
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
2.52.0.457.g6b5491de43-goog


