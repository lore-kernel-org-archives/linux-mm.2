Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03D5CC4451C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 05:33:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A0626B0141; Sat, 18 Jul 2026 01:33:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3034B6B0143; Sat, 18 Jul 2026 01:33:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A3FE6B0144; Sat, 18 Jul 2026 01:33:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C2FC86B0141
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 01:33:05 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2591D120160
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 05:33:05 +0000 (UTC)
X-FDA: 85000778730.09.B60409A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2E365A0005
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 05:33:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S74oZ+Kf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of boqun@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=boqun@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784352783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ANkivdWz9zJi28Ji5ZKsqedVfMZZkLTBuL3A5HXMgG4=;
	b=zD99imtk1MYtjM1RzYBknA2M01+WbEFy1/qDqMwAEYqrP+C7XX7mWZGstGmeEC/2lO1Dce
	+mHOG5M6SZIyoeK7V0iIjb5MXofubUq0kYOHva9r/AhwS9Mifjq/ZrAvHGAZcNLU4OLbP6
	jyKr4jt2v1EoS6f15IkrwtRW0UFLITs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S74oZ+Kf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of boqun@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=boqun@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784352783;
	b=YUVCuc6bvSLzjpZLFdeLMoFAWUECA2TnQE1flTlB8yuTr4jtK769F92IhvtUBTSaJOjNG8
	4Tui281sLEBeU1B/2XzdIYFyoeKqUuV3mK6kfEhV/DTy2PL4BEaw0A9iE5yUOlC8NL4uJm
	t7t/KQ2hp7zJHjvpDQwcCBpbPkhZNUg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B8674518E;
	Sat, 18 Jul 2026 05:33:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525541F00A3D;
	Sat, 18 Jul 2026 05:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784352782;
	bh=ANkivdWz9zJi28Ji5ZKsqedVfMZZkLTBuL3A5HXMgG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S74oZ+Kf+W9DaTE/adZxHs/zT3jTY86uvo9csra4zk1fxvcoz87SLmi1zDEP3fW6b
	 Rw/M7sccrpOA8NtpIc08mzE2JKpo/HJ4QhVOGiKUiqL7rZMilH6rjPXcZK2h72INHZ
	 eaByKrAaXmSI0JgJqSEX9epJnXZTLTMWo3l3sXweHIaVeqBOpc4mFqgP8nefQV9KgW
	 KQUhG8FlOnBNUuY9F94SLEDqTQEb6EfXuXpW0KDIhyvDL9fTwbeUKIMsoNCIcfo+rf
	 ZxjDumuq+1trxbnnafqMpPzyLbP7QQQGWmyQrw6BKmcrSta+myUC9UXGq18JeLPJD8
	 03/0Bnn2jrosg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 82E0EF40067;
	Sat, 18 Jul 2026 01:33:00 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Sat, 18 Jul 2026 01:33:00 -0400
X-ME-Sender: <xms:DBBbaluAZj9Yce9pLoE_LRjk_efZ1hR0mJD57-VZlbSCvfRs98xrEw>
    <xme:DBBbaoRDKqLpgvAkfpASS3Hl7m8NGRgXO-X0TmUaa5faD8xpDGXO8am0uSYGE2Cwv
    lUsoU1kJT6uxcHP3JW6zqD6H4c3s3H0GXLxYYvVRBAYzCozcjyf>
X-ME-Received: <xmr:DBBbakNUGo6TBnGq-Jz__XgawBNtXDUcsktMkQ8bWySXZoCxhdj3bJT04zWxaLL6ZKjZfqm4110Mrh9ReRYWia2-YIwZpZAq>
X-ME-Proxy-Cause: dmFkZTEgEAJxx43zj+N2HexbcXxXpr8iZewHIC+wBoUe/3kHvIsxmf0uovnwyzmQf22fh5
    PbBpjLE4M1x+gkTl4x5OuQgzkddFgVOLc7SPm8OVC3wj6PmDWqpG/wyzm0HbMF//9RDtvM
    cqERhXH8fRAethPTEdiPCDM2biIjvo2duSrcDNiRwIZ4PJTMN9f05eRQvmRRsxcI1+ZGXR
    GIOp0pU8kR4mYsSetTdmMF1Q09Qod6lgNc4Vx07svlwAfyl7KUdd5xFGJoXDRG1kaoRL4T
    /VNW+87mn/mN1dMvhE363j1dLxUYIFMMuhRaBTcK4fjHHNruAjFs082R/vn5pb6pwik6pX
    3SHkN1ACEiezX0mrwyw4KfdbjmcRDjPvFlZoRAWQNQEQ3EJoP/wDviNR1nZpBknlDVOTAm
    5dYtVMhKPL3ejT4Z+9iLU6DN6wRmWI4z6RdrjcnbevPeUXCNjW/MmqIagNfqcNHcvysGxf
    F03b3aVMnfh3U5HgzIMSYBanXCwMagUxvz5GKBlhVYIyKFcLfT6NwEhyGaJIOzCGE3faVH
    ZMdtpcaeMbwqM2mvR0yLwIk6IcpchHNeCuWKsiYXXPQcx8PqDKoFg2G0cPq0x543bCm8PT
    Sy+F7A9BzGFg985bJyfOkZcS3quFI+ZuDrrtYiKBfrcVpYvLCLmguRzokYZg
X-ME-Proxy: <xmx:DBBbaomdYw0UP8bSn2z4A7a-fPqId_zJgcEK_zldJ82wUvOvBZK2FA>
    <xmx:DBBbag3vtZK8XLxuR5YjdXZaMEGlCeSWRNPdqdyiPKBTLjb-39cI0A>
    <xmx:DBBbagWKFUlLfjGzeHNJjBT0pQRehhxOAZtL6eftj7hiqgH3XNIqMQ>
    <xmx:DBBbariRFC90MNV7Sn3SPFwAQwKSRlzKlAhJocM2_wRKQWCwWCS5sA>
    <xmx:DBBbaph3FC4sAJH4m5OlNsrqFhY2jeoEyebt7FZ4puPMZDf0FucgM2an>
Feedback-ID: i8dbe485b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 18 Jul 2026 01:32:59 -0400 (EDT)
From: Boqun Feng <boqun@kernel.org>
To: rust-for-linux@vger.kernel.org,
	rcu@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>,	Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,	Jan Kara <jack@suse.cz>,
	Lyude Paul <lyude@redhat.com>,	"Paul E. McKenney" <paulmck@kernel.org>,
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
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Yury Norov (NVIDIA)" <yury.norov@gmail.com>,
	Asahi Lina <lina+kernel@asahilina.net>,
	Matthew Maurer <mmaurer@google.com>,	Lorenzo Stoakes <ljs@kernel.org>,
	linux-kernel@vger.kernel.org,	maple-tree@lists.infradead.org,
	linux-mm@kvack.org,	linux-fsdevel@vger.kernel.org,
	linux-media@vger.kernel.org,	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Subject: [RFC PATCH v2 2/4] rust: maple_tree: Add load_rcu()
Date: Fri, 17 Jul 2026 22:32:45 -0700
Message-ID: <20260718053247.25154-3-boqun@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260718053247.25154-1-boqun@kernel.org>
References: <20260718053247.25154-1-boqun@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2E365A0005
X-Stat-Signature: mqzcdajwraw1wgks5fieurn6zhzihb1t
X-HE-Tag: 1784352783-517066
X-HE-Meta: U2FsdGVkX18XRCj/0I0rgOxPS2oI9dkPumOSG1P3U6ngsVdK8M+cjaqrW2EPR1uzJ4/FvXUWbbI0BmERSFu2qransF6JN8e2qdL8R06riMKl5UO0oNZ68cJIBt3kLBDaD8q5UTDcPRXe0O5OMED24iMHOrCniG/fCCxWTNOtvYIg2IsVmDZ0wHmAnO9mG0Vz2OCF1C3eaFFUYEvN/9YMfwo8OsloPRQcw5xVy8VP8tCv5gjODumPbDW1JxsoVmursidV51vguT7Fhl6Bm1kQ2yrrHW/etk8sCiWInatJlKuBkP63rIdL8+7Fdgzw04HBB7l/HRKz04eN0Kp5+NV52RvWpbMma3THryFVy0oa5h+PRRWRIkpwFlBffI+SBYNIeFiRm5uY4z81x7A0HhekIjPYAH+MKKhxIobm5T8CQbJg5sU3a3mmn30Pa1N+X9iKdbt8q8EL5CtvsHmB6/GjhpZ+59h5RlysNVQVqkH88zn9kZ5N1MQYxuMruvEkH+MTlfaUVnicbEHzMW9KwFgQUB3+1xjyDZg/9y4OkLA+0NBJVcjE0B14I1OdUxSbAsDp3HfYls7PvUfAdigaIk7HOYc+P4SbW6feMd1vdhWpf1EsijJvukoINcqGSUkN3FY/F0cpEJc0v99a8BjWeN1BcMFiDG/hCrP/pDygnkKtUAy8qShYGjrnNmfaMv/yYQw7hXtFrRfq5gf8/rjbHby9FX9b6d3RlDxkNYFnUq727o5SyMdyhrtuQJD0g+I3wuPwGhul6EEzPyuOhNRN4wMgWowRYyRltI7jjxZtWxGs224t/X2etTkQ7I6CzzczyJ7iS/KM23K+Gi6kgNcWb76rJK+DHd7q4qt/jVZanpx31kP0p16wp2zvls8MN+4O5ricuQk8JibtbENzD6owR/0fd5gO/qkS6DcmyOpoMNCKfsRIwUw4ufuWe/ZXR+QERi5MGr1Pk5DrP3biDmrmaCG
 Hfp0QEuU
 2X69O8u/qrCt5hECh7SFvecyFWO+zE1gJWI7gcX7t17xFdZdwoVVDDtTiCmAgB+LtLLvjKXj1FTriiS+u5zOuGsTMJ/7lg/l+JK3fwozW6M6D7qF1fvCBkctDnc8uPhOB7kNqCNlRt/zUwGKbx6QBpZykh9PsVAP1bM0ahEGWxRuCpL/IwtbXYDwP/kRT8xaTTqD+HvDNE5GSjQzmWf+gv/MOTWAYk+F7Tb+wEb5Poe/tTfS6qz5nn2HwGy2eaCE1nghMyqVeRSEWtvZQJ2ZgMgXu3jR0+gXUd8jUZ+803S8qQ4HV4E3mmNrkNbg5s3P4mu+1BjirVvbuO56n4RHwJ+b9vfxAkp0sIu7HHuw80QIjqwvf/YT2qAY7Swzui/zKfVndCwoPCBbJC13bOJhmPKDOZrGhFmevfaIt6cKURvdwi+o=
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
2.50.1 (Apple Git-155)


