Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02715E63F25
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:10:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFE2E6B00E0; Sun, 15 Feb 2026 18:46:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB4AD6B00E5; Sun, 15 Feb 2026 18:46:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB7216B00E8; Sun, 15 Feb 2026 18:46:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 665BE6B00E0
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:46:49 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 745F05C50F
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:46:48 +0000 (UTC)
X-FDA: 84448328496.03.71A4E1E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id C6067180009
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:46:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xex8n73Q;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PF28mz/EsjKVtQH72nbFcm0a4KvKu1gYkvLzsSRLOD4=;
	b=FWq0JivVJJFVJZnDHPlfwEYtBL8dTlKYv6WPMJIp+mUJHD00zF8LNLrJiLiyBthRmNiPkm
	O2PJfymv0ntT/yWg1WB/1OTXpXepslZPyI+S2/jKSvr7rqXSGd3GbZIAMVELavxZrN7BB9
	qX6SUKOeuDOf63I7PGfKX/gckB2Ueio=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xex8n73Q;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199206; a=rsa-sha256;
	cv=none;
	b=zh5ae/hX7U7YtJSR0j8aWMzb9LDs7zORCJ4QnzAm5r//nJwJxONFq94Fy63zKTJZb9xxUI
	MBXwVFETTsyCBKL2ADyZ5GT7OKIQIOVry3yFQ6jOy/J6pyKXmGc5CuH9zS8T5BIh0IfNyZ
	5NEO7wn6bws3eEGn8dBLLCXUjJfQbYc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5130B6013E;
	Sun, 15 Feb 2026 23:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CDD6C4CEF7;
	Sun, 15 Feb 2026 23:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199206;
	bh=eohGXCOnx46jHczP9dAsSKL7WJgwmz4UPPhsJskp2tU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Xex8n73Q8oXjVBQEhoMXO54rl2DX5CR0ALwLFLO6wSWHw9oa+AJtEpumCla9vvHTS
	 cWky+W7GKoCkzcPnxUSUx4Ph6ZGIkmwxIFgqKANolRlRT1Luv49qRTNEXJFWCugtOx
	 keUg99C7sSNkqH+E1HYB79RPxj8RLs8d6IMV9N2BZXfDeUfnpT7tdr/paRgsYBalj1
	 VSEpSe67DAfItIHRJ0bDN6XoapdfEFibjCXHABNZ51/isypweM5hOwH7LI6ukQ7uHo
	 Qj8l4UB0Wzv/l3+Kf5KEwd2inblhNXXpbr/rSD+NcdSV7QxIzPXz8SgjjWI24xaZ9a
	 KHZjk743vIghw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:23 +0100
Subject: [PATCH 36/79] block: rust: add a method to get the request queue
 for a request
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-36-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1245; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=eohGXCOnx46jHczP9dAsSKL7WJgwmz4UPPhsJskp2tU=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklg8dg/PhpsHgOFH3l0YMtC6LWUuqH43wi3Py
 0nPnS34BySJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYPAAKCRDhuBo+eShj
 dznwD/sHTnyIp1mixWF4FtiLgwKs1LYUBAJTXKWLW8mnumj2jqbZtIVbjsea2ML8uKpUJ7IbxR5
 uEhUV922BCO+J72fsH3SuhWkOsqk7VKvKO2jVlo6XgaDr4KPKkcyCoGMeGxGyRFc5NK0qBqXXNd
 r++7HEvsG9RWayIwg911zold+v7hJBwXp+zxaYqKMHUlsrTCG3pwZdRNfgESwjZQbVq3quEBgNs
 WNNnnNoqv9hIxgKG2wcF9Lx/6/OPIGG+hF/4r+jxNsLsmKbKPG/42YG9zKrPx0keXI+AGmLiDSi
 o7rJSCdbQ8ClM99EgGiiqWzejr8vW2ZIV8qTUh2n7s59hSDakHsS//EgSvfHLVgD7XV2FIZTCJR
 T7Kb9R+QxyWFoOV2QqEHmSnVcDN4sdlYIqIhl1ETDh8smFzqiw59dOs/tqTK/4LmEqSl6lN/Jr6
 S5spzhexPyf9jct1+zxmYdbtTRmAulBiSLhKSe5HpZMwIJgF81wApWjWisB/bSfZkzuWQ11QDSp
 myA+I+Uh8wnqQ7M/upI1KePq77rKS1xhYGcjus40ZpPcSl6C/o2V4Cn7UIrprwoQ1XuCf/8beoY
 kexMxbatftJ8+d9HSAo6zePfqczhqFkQxRC91+69ObBzho5w91lgQaMh1TMPt5TgBPYqxee1Gc0
 XbSMW0Ka3eI9ldA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam11
X-Stat-Signature: k9jiwhbo64c7suu7ja5xuahzxdw48xey
X-Rspam-User: 
X-Rspamd-Queue-Id: C6067180009
X-HE-Tag: 1771199206-679695
X-HE-Meta: U2FsdGVkX1980tcz7wdxF/HyP4HVaxEbEXL5iKYx7IjgYf3cEeoNFzv3KH1s4bo81qKGkbA3I4lxwt+108QdSO6VkzJtpyBQxPCrLNRkqFK7LwDHzq52iih7DgKqO6smWQZKA9fk6PMf33CS51MX7QyivcgJIr1kp4KDdvUdtfE6xmc4AZ+3Rr+Gucj697o+5QikZCKAKNxnrYj5pzZk6+u7DC0ERC1YDbKYn0xj1J1zkB3Djr51iahea4mhwC5YnKRq18HepDt8TC7xrVSgYJWsy29bZfe3a/2kuX36wCV+OoPaU/rdL87Q/1JPfdS3zgjl27m6nRDL784MYtg6Tq73rw1RKHldUBAotiAMJdnGrhV0usZB/WL3kA9RCq9TOJzxsFg2aNcz5x/1MDAU3D2nA1TkfD3DlXsAnFKw5hmCWe8VTjNhMDE4JbFRreyRMQEVDMOEN3inEY6rTgH5DhIQeaAd3xCgqefMGvUnWI/OnIi3Wf1wL0NPcTAee+h2OmnOvX6eyP8qQo2idITnD5wp2bWQWkqptxhdLzqclqK60tlU3r8ZOX7IeJbA0AzCFF9Bj/ocQzo1xB3i45r9ubAkkmo6bHfNwkZ0KDpoxcT0OAIqyv9SDMwCc/jEPFtQ22OTAuHV0ZLOZemeViwXgGbf9rKmdhjSntBOkAEmVtLUC2V873MM0GL9boXWz/xvYAJRFtSA7jsOqz7TnhfPdlg+NDBLsW4ta0Mf9IABip2dJA/tlkULt+E9F1/DUsI6iko+nP4n7xQcjAZQ8dTEK77NSsuoBz4HODncucvS28pimYTcPaRuCWqKH8a7r1kSX5ZlbuLM7m0mrV480/5+IHE3ZEJb/RpmAsscAR2fy5YJfszxv0pUHpcgblSmIYUhmSGb2AQ4oL185vIYVW5eorEEdDS4CyFGuiSo8jY8OIJjr1sZxTiYVinAJBCe38+YX0OHUijcw491209+v59
 ONO3Bgob
 VEoMztyVf1GwPD1XExSqlBrk+8/JYeLhOfibra7xTnQJDW7oXWpnLTA+ispSdLmS4XqM38cw+tBRbDQcidwNMkOOVE26rmQGgtS2eM9u5hhQ3xwCNVAJwMqrjuigkw1oUA9lE7HTEyvqy4wgY0DJ2o5O7r2XTlM5e/kJxjZyVoMZKouFjoDymWuVHCvanBupvlhyVX9hasrfROssrLkzuSgLsHnLXE2znQ8wpUrRa1yUTl7GBVJgHHkmpGNvcNPbxZiN8MZaBnIEjI1eun+QToglZShgOTSvje0AugK9PH3YRTZDjA+mf7CrAzesUA9Yt0oUNWxGjmmXJTn6MJtKKcYPUIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a method to `Request` for obtaining the associated `RequestQueue`.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/request.rs | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/rust/kernel/block/mq/request.rs b/rust/kernel/block/mq/request.rs
index f6addd20624a9..d6f3ffde1c5c4 100644
--- a/rust/kernel/block/mq/request.rs
+++ b/rust/kernel/block/mq/request.rs
@@ -19,6 +19,7 @@
 };
 use core::{ffi::c_void, marker::PhantomData, ops::Deref, ptr::NonNull};
 
+use super::RequestQueue;
 use crate::block::bio::Bio;
 use crate::block::bio::BioIterator;
 
@@ -118,6 +119,12 @@ pub fn queue_data(&self) -> <T::QueueData as ForeignOwnable>::Borrowed<'_> {
         // SAFETY: By type invariants of `Request`, `self.0` is a valid request.
         unsafe { T::QueueData::borrow((*(*self.0.get()).q).queuedata) }
     }
+
+    /// Get the request queue associated with this request.
+    pub fn queue(&self) -> &RequestQueue<T> {
+        // SAFETY: By type invariant, self.0 is guaranteed to be valid.
+        unsafe { RequestQueue::from_raw((*self.0.get()).q) }
+    }
 }
 
 /// A wrapper around a blk-mq [`struct request`]. This represents an IO request.

-- 
2.51.2



