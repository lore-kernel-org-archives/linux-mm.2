Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC39DE63F1F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 00:05:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F123C6B00AF; Sun, 15 Feb 2026 18:43:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC2746B00B1; Sun, 15 Feb 2026 18:43:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE8526B00B2; Sun, 15 Feb 2026 18:43:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8794F6B00AF
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:43:13 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 05FCC160719
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:42:51 +0000 (UTC)
X-FDA: 84448318542.07.8F9BD44
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 549CDC0006
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:42:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m+DLwcOZ;
	spf=pass (imf28.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771198969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YraXbnCINoGXS0kdMKcWqIQXONXZPiBWMh6Cz6Hw6o4=;
	b=LJPfcE2daweNwCH1GH2IjjaG7hO/vL0onUmGp1hKO5lOm41T9hvXxuTulgFFVmLqYWv3/x
	YQ4pfR4yyxrsvsfJu325CZbRbrAVaNoE4QgC77dfCjFv6CEOebHLTArmsDjY2ieOvQckfd
	QmNNlJyOpGl9w0fedcKPCa9fHi87p08=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771198969; a=rsa-sha256;
	cv=none;
	b=dBLkMHobpNn5YxTUdLaNOLeGuT4Zk/j1rnRzuG9oT82LJgRiVEPuHbOWQ5et8WFOH51O3U
	f5BRyAt9T2PEOCromFF5AzoKws+RScqnLbC65GfFKZaW8El/JLoYOgr4OF1F+AoMdK3RJn
	jYHvoeA5J+pHiWKYg2bL3k8t4tNBXxw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m+DLwcOZ;
	spf=pass (imf28.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D78426111A;
	Sun, 15 Feb 2026 23:42:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1969AC4CEF7;
	Sun, 15 Feb 2026 23:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771198968;
	bh=PclSPlh70GQI0xa5AdeesgMZY73x5FcK7yieZwHyBNg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=m+DLwcOZ7ztebda4HD5zmzGEd1dxKhN6VIv3Ey90e3U/WBlrx+pf3F2fWIFCLcI5T
	 hldQpB0o8zQTbtheSVXM9rCm2qhYMCI3ogaf2Vx6ppCCM1auAwzwFbNMXljA/fcjqa
	 r3eJu6VrhR+KV7HrXN+OL7YLt+3JPM9t2+oxfpN4jHjTi2uiB8X9ZxE6E8cQblVTds
	 g1AElKe+UUux/V322EArMeHghqO1p3enbonHlviYx7wy63c4QPvX/BYwiZ25ebUMo+
	 MEbYCOPXyn99/a/fSfZ576dim1A0Oi4TVU3bwG2sQVEg0dsIX2xi4bzSOKmEO3r2Fd
	 GxQsSfgDTR3Tw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:49 +0100
Subject: [PATCH 62/79] block: rust: add `TagSet::update_hw_queue_count`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-62-de9a7af4b469@kernel.org>
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
To: Boqun Feng <boqun.feng@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
 Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 FUJITA Tomonori <fujita.tomonori@gmail.com>, 
 Frederic Weisbecker <frederic@kernel.org>, Lyude Paul <lyude@redhat.com>, 
 Thomas Gleixner <tglx@kernel.org>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: linux-block@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1846; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=PclSPlh70GQI0xa5AdeesgMZY73x5FcK7yieZwHyBNg=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklhTMo0te1+0hDGk5iS523JU63TJIgZV6pKQb
 P0p32p+ORCJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYUwAKCRDhuBo+eShj
 dz6IEACT5CHYFXwgGMGhVFOsIzIVze2XvGdf11AwPQLHKXovdeWBUGKebfuN/DcQ3OPK9AglXZ5
 tm5GgORCPdgssHdGNlfcsNRLHfn6Ln5QKM6AK4Sc7tkaVKu5LYGGWSHcn9GhvVnOx/lpaLszWlN
 6mCEKAauIk666pbJOzJ6mlmJSRl04x9sYQfvDzgb9w0tnIihphmkYYMZPWJA31UaUi7v8p4oyMX
 /pnpFmXu8UwgvIe33s3MB8zKNKeSgG6ZP5uMZV2Qi5iLXqy7Z6+fYFwzqkXLe7OF5ZeC/tTLO+f
 Xv0AepFCGgEPexiO1cb88/4C3m7gS41joiA8nVtFNYu6d1Su9ckl261r5kyHFZEEEk1jz7W5wa7
 YH06lBIytM3mPDDcO010YYmA18RhFXWNv28PxkWHDyobexbUnRr3cVtXGFzODBugO8q2viypqkW
 cQfJdKYov6juRy+vygspWrsJVhnHaixjGBHrbwA5CVXa5/EMgKj4MDMFibd4KPk8a6Q4b1i12ND
 La3cQNmfMFAkkWCbMNM2MOd/AuFcgm9CjR3R5NSjKsJ3VMBzsPUiECbEizBCbI8MxBGW5PEcj/n
 3bTLvOCGMKucYI/wM4mwXs2D18IMIJ+OhANs+L5A2aZ2HqmA9JcY9ST+ivVR1CR7odYpu55i7r/
 xvoD8xIrqD7yQng==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 549CDC0006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: sefoudj8ggmi5jmrzq5wnpttoaq64tdt
X-HE-Tag: 1771198969-868959
X-HE-Meta: U2FsdGVkX19OOpn4vUBC3RkkopRL8H0ETB00VEST9UbxLWIcNKOQbfG70qRttg1P5Jvw5uMx3nZFvZBzBNRssqx3+vBrzgGW6LtAc0Nqm/tUL8nNLKDZMY41p++pfvUCXj2eGGl+Aw2OAv5+ZEGmF9dYWZy0GhUvjmcLJw2BaqWQaE5ZGjYK5O/qbfcyqw6GlJDeuAAR6D8b9j178Xx8BYd26/yx2mRLvgx4iF43b9kE0oqKTMs7UFYYL8yzOE2DbS+N2JNacll1QIzryRud0TymkbNLxMYIere3JZ/2v6ea7KElqhN516bD1S+r98StFGpW8u5TAEu9quPNXlu0GamHTqQbUfZQuY1B7p4OYG2/flQ1MRZ85ylbzdpQIaQLBEEmeLAnzWbZmUYlL6Qz4t+XMfmavr6oI5NL/cfQFRMz+LXZ56LrIpjwmlAS83baRoBAHiylx05aSSHipYcRkCLytS1JzZr6GY9wdNzfv6Zp8BCJ4ab4+pYcZDyUVWIr55Q418KE3srZPTfm7CyoU+Zu5aHYDRLvj99TLTC+4ES6dLGvzs+k8dlwgQSSB+2ZLzFeFcAL3rRjrYRrvC6/ZdHzxfWxJjetz51ED652cZgBMidUfMTLa9MhTHbBKF5bwlBInAohAJx/VAQ3KxV3lcKLbnqC/tDkqRvCeX0ClYb49OHCW+KBEBwJzEbBM2fs1LdBKfmCN8aYyIIgd71DY4OlkD2bWGImilohXEJAgS1k+kAO4z2tIqtG2ubAPVY0wETYFiFmJ1qXuA3KH0uUyD9/kabvzDAdcLE6eFtMBvbtA7B0jipMdavWICBekJis9WdpqGgQu6ZbiEiCJMF4TtVbZd1VWbWXZp0iQbYn7C4obdgYxz8fRs1WcLQ81nhBC8gXbCsexGrNurq9oZABrDIdtFs2Afm8cc3VtdGXOF+AmxEnLBoWUl3axOrBKfzqcTluZ0yoUcY6AO3RHsR
 D1WimBfy
 8BZk04isYae4cxdu2k8sc2O4uL3K8M8qdySC2q+wYLJvTtWPrMWgNzU+96jcc3CXOPMglQjhrXhvjSFbE8b6HXXSZB6mzkMx0rnTzz4fkqd/y/Ty6WaUe/z6IHwyPK82Pnm7X3kfMtfw5efdC1JcD+puepJS36c4h/iB1w7d1l0qeLKdFw906DQ4qnDuXfbAB5GMK5VWva3EcYP+aocYJDnq9I8CHyEJByOcpKYcAvCtA/7WGpAWxZs95AVCtiirrLO0NsbApgq3BSIn7BZWdfQd9+qxL2+wr540brkaMSI9G5JS2mftlE2lZ8IPuPfmLyE8ObO3kX6rHmcHJwr4+UbeQN8hdiTJOWUcMm2/iLt20dNIlWhiCV89gnjatLZ6QNu691MLPMmT9Evw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a method to `TagSet` that allows changing the number of hardware queues
dynamically.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/tag_set.rs | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/block/mq/tag_set.rs b/rust/kernel/block/mq/tag_set.rs
index 4d00979a83dbd..47a162360e628 100644
--- a/rust/kernel/block/mq/tag_set.rs
+++ b/rust/kernel/block/mq/tag_set.rs
@@ -8,6 +8,7 @@
     bindings,
     block::mq::{operations::OperationsVTable, request::RequestDataWrapper, Operations},
     error::{self, Result},
+    prelude::*,
     try_pin_init,
     types::{ForeignOwnable, Opaque},
 };
@@ -34,7 +35,7 @@ pub struct TagSet<T: Operations> {
 }
 
 impl<T: Operations> TagSet<T> {
-    /// Try to create a new tag set
+    /// Try to create a new tag se }t
     pub fn new(
         nr_hw_queues: u32,
         tagset_data: T::TagSetData,
@@ -142,6 +143,20 @@ pub fn hw_queue_count(&self) -> u32 {
         unsafe { (*self.inner.get()).nr_hw_queues }
     }
 
+    /// Update the number of hardware queues for this tag set.
+    ///
+    /// This operation may fail if memory for tags cannot be allocated.
+    pub fn update_hw_queue_count(&self, nr_hw_queues: u32) -> Result {
+        // SAFETY: blk_mq_update_nr_hw_queues applies internal synchronization.
+        unsafe { bindings::blk_mq_update_nr_hw_queues(self.inner.get(), nr_hw_queues) }
+
+        if self.hw_queue_count() == nr_hw_queues {
+            Ok(())
+        } else {
+            Err(ENOMEM)
+        }
+    }
+
     /// Borrow the [`T::TagSetData`] associated with this tag set.
     pub fn data(&self) -> <T::TagSetData as ForeignOwnable>::Borrowed<'_> {
         // SAFETY: By type invariant, `self.inner` is valid.

-- 
2.51.2



