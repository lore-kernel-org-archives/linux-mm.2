Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CB20C44521
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 05:33:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB2906B0145; Sat, 18 Jul 2026 01:33:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3BF06B0147; Sat, 18 Jul 2026 01:33:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8F1E6B0148; Sat, 18 Jul 2026 01:33:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 726966B0145
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 01:33:09 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C85E5401F0
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 05:33:08 +0000 (UTC)
X-FDA: 85000778856.02.FCEC7E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id D2777A0007
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 05:33:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MwbqhS59;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784352786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=agZo2XMu3L0K2ubakxGylN/JFYjmY5Vh7gaRmN8isS0=;
	b=YDUl7AiMx2xAzY2FC7om+A8wsdf4HrIK38jbKv0fTMZfGcvYa1TPRiGRr4RF+2K4cJ0WK0
	Cx29m1fYJ9GFptEeHNIJ/s+cHSpDNlHGoi9shCnzzuA4w/9Uqtd95saxKHyo9FWgFlVT7G
	crUgBSqHz3wsimcfdIHcVt2oW/JXSpU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MwbqhS59;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784352786;
	b=52FofO3H4+TMudqkQpPibDZS92e6t1qcJBysKtUFI9Ci/U08q44h8DJdVhjKASbqgxha8z
	UbBhH5vQY9vSO/47MRw6QwwNh7D10nQfk9Q9qwQMef47U5wQ2pMwZjOKO3OMiZk40+5atZ
	7KaBslysMowI60SlpDNDdRgkaaONb74=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 76F0560AB5;
	Sat, 18 Jul 2026 05:33:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF771F00A3D;
	Sat, 18 Jul 2026 05:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784352786;
	bh=agZo2XMu3L0K2ubakxGylN/JFYjmY5Vh7gaRmN8isS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MwbqhS59pHFX2y1bjCbULv/pCDqqg/3CNZTpDqkOxuqIBllpv6JuP2ceX0z4ojwaC
	 hFcGSdyF26rxMWJerVgJwtbmAMxEaiNAZRCba8S6mwOIsS1xmVj0mRmaV9xuhV2YMi
	 BVgHXSxVwuvhrdOqZ1zuvlp+lIhZbP8Et1IjKpLehemcIMVQm5B82uXKWjO/8IdEhs
	 +MsHZn4wxWxhILUdNXdR8MeVp5F4MHKZjegrurQn2HatPRi4P1YswdCYvni7/ombXc
	 sVC1628sS6njMIV6WsvNjc2olUvHZlDljdFAlSQj63c1HcaWsn4q3UExFh6mwES36f
	 sYOXLcAJwL4BQ==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 4D860F40067;
	Sat, 18 Jul 2026 01:33:04 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Sat, 18 Jul 2026 01:33:04 -0400
X-ME-Sender: <xms:EBBbaj7smxn83ZTm-rtchhuFHn_J1uG8HTPM_b0Jov5Z6zMRYqTWyQ>
    <xme:EBBbaislG9lSmEzDeTSBqiG8TfuS5kddi_bFm5zdVBHXhYdBMQIumwBssIwOUFeFe
    lE_-ZeGYT8MrCdV6NWNRg6EG9_xmfLmOdCqfztalPMjTwixVeMnyg>
X-ME-Received: <xmr:EBBbal5yWjXMOycQcWfUGwfV8Nq3rTzQoN40jP1QHnBaXUGFA5fu3T9jIbY96CvBdJuMWmWcDdisCd4jpuhJLF0mFPBgw9fz>
X-ME-Proxy-Cause: dmFkZTEgEAJxx43zj+N2HexbcXxXpr8iZewHIC+wBoUe/3kHvIsxmf0uovnwyzmQf22fh5
    PbBpjLE4M1x+gkTl4x5OuQgzkddFgVOLc7SPm8OVC3wj6PmDWqpG/wyzm0HbMF//9RDtvM
    cqERhXH8fRAethPTEdiPCDM2biIjvo2duSrcDNiRwIZ4PJTMN9f05eRQvmRRsxcI1+ZGXR
    GIOp0pU8kR4mYsSetTdmMF1Q09Qod6lgNc4Vx07svlwAfyl7KUdd5xFGJoXDRG1kaoRL4T
    /VNW+87mn/mN1dMvhE363j1dLxUYIFMMuhRaBTcK4fjHHNruAjFs082R/vn5pb6pwik6oO
    i02M8fONfup6UUyVvWAj3LIiaccJx79xi00AFE7MEV3WF030lZ8xA8SpsEi6Gl4rTphLm7
    W85qiFkiPnFPEyGQsPlpzBH5SC88pTqTl7zHOgB1UizF1X8HWy0pjCGlfqlb5KhMIGeksB
    BM77F8Iz5gz4nm5AaBX89I/O5EsTxlSPFMjiVPNKun4nrYJZwlRKq2rf9JutxjHhCePeF2
    ZUczb4x89X5B2J5KgEEM0Ar+g8NYdZYNAfHEmuK+asohxaGqvLq7z5ddhcnnsaaXdjRYl3
    r6LYJ4YMNhLSLVbKF0j9W9SxoIz0cRSZGuTCLSTBHjntmeBEzvh958UnZESQ
X-ME-Proxy: <xmx:EBBbagixoAn4NfGLg6GeFhzLUwcXIZIBeXyEZeYnLz5aj0py6EDOqA>
    <xmx:EBBbaiBWT_NS0ZQPxYY6vnvl9Rhf3-nz11D2_vSMzHUGZZygCSMxig>
    <xmx:EBBbahx_hbx--ds4B21T3sC1uDxy2Dm_S4kb-yp4-EJAyXPU_4_VKw>
    <xmx:EBBbaoOWJs9BEXIaxncMVgvJVG_DSsqlsbHSTwLTaw1gRwBYX0W0zA>
    <xmx:EBBbagfkMvuzqP3RAuLyvp9Lmq2CmuaxHd0KOCBz6k58pua4BQV3yK7a>
Feedback-ID: i8dbe485b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 18 Jul 2026 01:33:03 -0400 (EDT)
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
Subject: [NOT FOR MERGE] [RFC PATCH v2 4/4] rust: poll: use kfree_rcu() for PollCondVar
Date: Fri, 17 Jul 2026 22:32:47 -0700
Message-ID: <20260718053247.25154-5-boqun@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260718053247.25154-1-boqun@kernel.org>
References: <20260718053247.25154-1-boqun@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D2777A0007
X-Stat-Signature: on1fwjsrxynmiodin7swouenubhus7bf
X-Rspam-User: 
X-HE-Tag: 1784352786-351748
X-HE-Meta: U2FsdGVkX1+2jsuaf16S9RaRRChcUdF8lcuBpgpc96T0BLZYL9m9iwvo8uoRNXqz6fkwHPykXoJFQyhAtjJQt+fIy5r8w2DVPNOFqBOUw2MH1sX1INw9R4dt/dc2OCB+eM5JOpq2ESX3gKORy3PkSm113Hn708TES6hrfnBho1bQMQD9oSI0KH4GyjcAW59XQ93dEpIjkeeaPiU8caH24DRjbQsydjH1JzJt7LtjwP0YshYBZPvS3KXTHbdmvkYawc57/EBn41MPQRuIIu6XbZC+lstqgS3MXqeaQ6C5t50qK6OCrYYSgRAGoqvQKAjXjLns7Yy1rWD/IyIJJkx+7rKxgr2eFD8hjPQ/HNJUT+/kCd+DaQPp9oBWqvzNbYpNOCKYzeWAOLaBVMvUYNuISTqGYQBukFoFe7xMPdbAJksmuqkCB/qs4fnL78VgUcsI/vLWAvUYWJDGrTbRfupKkJ2pSbbnoyErr2BmbSciMXPsqhpOIoAu6i8A4Q5LxkVD8ptKPCX9+r0K60UaFZtEbbC5vOVEzB6FBaQDGlY+fY33jcfceE/IFZIft0kTNL5OhkMgKnhigsI7PTpKx2ktSk2aXjDhOZZVUFl2RPgjMXEnPhVA4zOpkE+eJWQG6OMFU9YU8vPKPfq6wmoCLahKch4Tb2tt/6yuQJQx7ZOfMz7ncmX0nJ+9ELZg1o4/cdPdr50otNFZwTBmtXcfj3USbCSrNGG1eg0Vb5QrnzqNsyHtl+HO+4PUvbsDlItkxmpdfSw7wwtKjUWuBEohaoV4ofchhjvB4JdPsjJg8QNGep0r6V7ybcnq6lcKMzux8WnDEoDjPdOO6hJLepp93l5pskeETi44Ph4Ty3eEr6cn2MxcwknF1ciFIJGPEX5/5f6tYlzmVcbE/MakTYDXE+SDV6oD8OJno+DltbHnNqHvRcMa3Z/FpHAzxm7PNiOmCnPtmkqPEVeK+pNhm7tvPBi
 AkRVVGqJ
 Op2IsrSM7EbeAlKpDy4ZL4Pu/VUQHrrBx331lcEc170dQMKbnWj08iPw4OJd0kAX8esQ+Q/qPk33nXffdt/AEebQ1xzk6N6Q2FbwcFrBmd4GTuzm4qCFZBq/uEyDyoFQcEfo15MecTE2fqzQ+uWEk3P/fL7SwsCyiiN59DlL3FQDxeLsev+T5W/d9785S8yFZjiHckWddKtD/esF7QO3wYGxJGrjr6Lz0UuS01maNk0BqvyRJQ9GeoRRLyUI78jnM1mosYrrGnKSQkLBKIxbN+WtCYJxlpfA9yIcCj1Whq02Q3RLJBBfto2kzIZMCAG3GQf+2Zk+gq23TbCazJADKgjFll0fkYWOC5mOr7BMLY07R+zQKYnJqG6faUjFVOgoeNlICSs1dsAvqPYY/A/lHBLAqNrWeJG9+kpYGcZBGSJIyzBhzEEtKhiUCY3uJA+umEuUc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alice Ryhl <aliceryhl@google.com>

Rust Binder currently uses PollCondVar, but it calls synchronize_rcu()
in the destructor, which we would like to avoid. Add a variation of
PollCondVar that kfree_rcu() instead.

One could avoid the `rcu` field and allocate the rcu_head on drop using
a fallback to synchronize_rcu() on ENOMEM. However, I'd prefer to avoid
the potential for synchronize_rcu(), and Binder will only use this for a
small fraction of processes, so even if it changes which kmalloc bucket
it falls into, the extra memory is not a problem.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
[boqun: Use RcuFreeSafe]
Signed-off-by: Boqun Feng <boqun@kernel.org>
---
 rust/kernel/sync/poll.rs | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/rust/kernel/sync/poll.rs b/rust/kernel/sync/poll.rs
index 5aa0ce9ba01b..830a4763a5c1 100644
--- a/rust/kernel/sync/poll.rs
+++ b/rust/kernel/sync/poll.rs
@@ -9,12 +9,19 @@
     fs::File,
     prelude::*,
     sync::{
-        rcu::synchronize_rcu,
+        rcu::{
+            synchronize_rcu, //
+            RcuFreeSafe,
+        },
         CondVar,
         LockClassKey, //
     }, //
 };
-use core::{marker::PhantomData, ops::Deref};
+
+use core::{
+    marker::PhantomData,
+    ops::Deref, //
+};
 
 /// Creates a [`PollCondVar`] initialiser with the given name and a newly-created lock class.
 #[macro_export]
@@ -70,6 +77,7 @@ pub fn register_wait(&self, file: &File, cv: &PollCondVar) {
 ///
 /// [`CondVar`]: crate::sync::CondVar
 #[pin_data(PinnedDrop)]
+#[repr(transparent)]
 pub struct PollCondVar {
     #[pin]
     inner: CondVar,
@@ -97,12 +105,20 @@ fn deref(&self) -> &CondVar {
 impl PinnedDrop for PollCondVar {
     #[inline]
     fn drop(self: Pin<&mut Self>) {
+        self.drop_before_gp();
+
+        // Wait for epoll items to be properly removed.
+        synchronize_rcu();
+    }
+}
+
+// SAFETY: __wake_up_pollfree() guarantees all the epoll items on the wait list will be gone after
+// one grace period.
+unsafe impl RcuFreeSafe for PollCondVar {
+    fn drop_before_gp(self: Pin<&mut Self>) {
         // Clear anything registered using `register_wait`.
         //
         // SAFETY: The pointer points at a valid `wait_queue_head`.
         unsafe { bindings::__wake_up_pollfree(self.inner.wait_queue_head.get()) };
-
-        // Wait for epoll items to be properly removed.
-        synchronize_rcu();
     }
 }
-- 
2.50.1 (Apple Git-155)


