Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16322EE6B5E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 21:11:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D4516B0092; Fri,  6 Feb 2026 16:11:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77F956B0093; Fri,  6 Feb 2026 16:11:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 681EA6B0096; Fri,  6 Feb 2026 16:11:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 57D776B0092
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 16:11:39 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EACEE140357
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 21:11:38 +0000 (UTC)
X-FDA: 84415278276.19.EA92B87
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id EB4B940011
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 21:11:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HQqlC174;
	spf=pass (imf27.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770412297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xf2CA3Q0xMY03NUgnPHCMc6U7qz2mHQ/rlWk9GQ8TvQ=;
	b=iplNEA5RfmyhJartaKHirhCO+Bgq8YZ7sgvG1cPduYFAm1622C2IqDo/hiAtM2lAC2h1ba
	a4ZYyd5zzCBrJxwxR0Q1SJ8kNm2qt9qP6SFPeGOhoRxxOlfuGPfXDZGkhpsG3HgY/fQB/q
	pLHAFIyQFbdNEEn7ufFm+QfZ5xDftxs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HQqlC174;
	spf=pass (imf27.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770412297; a=rsa-sha256;
	cv=none;
	b=TWLQSvDOFUt4ywpqnoX7TeMr0tLkZ4E1IfhBCvUMODkoUrDz/tGstuZFe2omewsEGWs9Yq
	QwSENAewLwfMysxdql+ArFqZIOdIb51NaWEgkzojG/+0w7HKdtF7ThLij8QXpQmLN/G4rB
	Uock/nbaMQLdlpHU6ApYmKZ2/9xhCaI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DD4504022D;
	Fri,  6 Feb 2026 21:11:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3089EC16AAE;
	Fri,  6 Feb 2026 21:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770412295;
	bh=PrcApbk7BCNSPsQwnef2I6IdaZ2i07Y2ln8fzlwV9sQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=HQqlC174WwKjwtjLP1BUTMoxieROheLgxdft+OGqysEcip0EvNQ1MMicLZBsg6Ygl
	 0iHMxOT9CHUgO55F77L5XNmNSzdo81rEEkzGE8xd5XuR6dcrtxvo41iJmz0jZbvVi/
	 /FmqFiqb4mU+1saT1ogpOGPmK9eg+Wcu12rbxKwb/QuDF6Z0bdlVNhtRICOa91zibI
	 AIIEZ1BL3GbaC1kvTZ2uVx1GtrsSirEUpeT+AWr9yXPjeC/cU67gaWt6VMSh06H69b
	 KgYPNteuFvt6eYQY5iRbMOTdIXUD5GbtjQlWL4kd1XifwIFIYNRcae9LeIdBkEE6kW
	 JUi5yQkVOrlvw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 06 Feb 2026 22:10:49 +0100
Subject: [PATCH v2 03/11] rust: xarray: add `contains_index` method
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260206-xarray-entry-send-v2-3-91c41673fd30@kernel.org>
References: <20260206-xarray-entry-send-v2-0-91c41673fd30@kernel.org>
In-Reply-To: <20260206-xarray-entry-send-v2-0-91c41673fd30@kernel.org>
To: Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>
Cc: Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1538; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=PrcApbk7BCNSPsQwnef2I6IdaZ2i07Y2ln8fzlwV9sQ=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBphljjynnLtfrU8Iiz9Gm5FPAFGgN+NLu89L3zu
 FUdyPDQUsCJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaYZY4wAKCRDhuBo+eShj
 d1WtD/0dSV1caS9hKFf19rq5n4cibJ7yErP+DuvjTNfhG+cx9BGtQf/Ivg9WhmB6dKF1/Ff/ZNE
 fD7LuuYM708jMZ/Ag3QLJ6bZhYFCBVFMXU7uc1O6puBKeYx/LAuPoocpO5LcFPP/bt1ZEw8WUF0
 m7zzmtHnXb+6ujkjd2gl6hBhGgSgOGhvdJyYX3ULUUkVXe8vN5TpwXq/IlUw+Os6dWO0Z8QNI9L
 49N/R7i9NuiZ19l2L7xKVsv9nEZmAAA6gJmAdAoeINuz0Q+e9PxyqMi9Ew1aBErPXVPOxMOchq7
 4ohQLw/lItGvp12xabHAIbxlKUV9FMDxccovc/mki8TucfkGlQtmlMhLwGS+iQtmMw6havc9ndR
 Pf5qTpoqj69CNxpXyvsSUWI+xc49m7weMQ8a5zeIO/g2XlBsFrLQwnVtrhsHGKtxqg4Qo02NclV
 CmO6qLnLmsf4hNzCsYGRhK5mdwew7WujEbd5hlufx+YNqZ6a8kGCXRhAvh0c2OPAgDXd0RCHtnG
 Qy4kA65FWIqUx5woBVUWuCup53T3cNzSUyNmaXvwWMoXZyaDn7aJaQ+HLJyHHR3bZ7tqvodt018
 KGZAdtO2i563HF4hHXqFw6msci9S/h4ojJZJCwvUaxYItpXWU1zcyOWq3rFcLZwLhGoZnQSJbel
 nenKo4yG1+Wh9Yw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Stat-Signature: d35twhh9nya9f6ioai37ehrtmx97f58c
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EB4B940011
X-HE-Tag: 1770412296-219306
X-HE-Meta: U2FsdGVkX18f2NMOi6pCRKKfDa06tOn3e0T4Ds67X1qVEPd3kYwMxa74cjmrdgyT6bGfkEYtYQLvHya6OV+ouQOBfAg6fWNRTLfh+8zynuUjJbRFRV3Avk0E5mQ+KxJ0RDIRNWDWuJHnys/S0xEn6Cc2jARFYZDSYtVvoVn1nC1QfpjhANUcNi41MjLEHX2hfIA2wNmW3MHfY11EqbG3fC7smzkGAv0CqAn1Taia7imjjTYsLP5FLOkarsqtmyoeeiukZxPn8GUknjy4bxVp+ni3Fc4K9ePT554GtT0Q1mPwVuLOrCWV+EtPmcUPNx1rSaX42w9jQ2b8sKp91MXTct+J91Xw2T5QHWdd1N7P5OahRQnRd2bbKNVYHOA6mGGxwQjfvN9MFSQGYSv3jvo5BVfx0ch3sDgeKlscDb8W3SvRMbPYWqOvUh/L5GLDS9vf+l4dqQQo6OQe0lvZhNV+fcXShRxhKC4711EV5I6u41o4vQqG0veYoXdwsZ61W7O3XQUTdJJHEKL3PI4TkHfjoX27/189EZEkBZO4u61edxUEBGQbuWGjm/CFQPyeZ3ua+Gj7udzYoe04KsZvOtk0U/C83YA70wr3rYCFMRezAEztGdhu+fwhU8H6roTz4VUCUsQvuT5xZimswqj4wXN4ohN+KK1AU8x9GkieIP1ACmniwXLdywzHMblRgpnEl0P9l9Dgj+jLDj7m7tN+GVcQShKCejS74HWmPaYLiCMfAcKbFZiwHBHa/l5Luz4/Fr+MHQH4Yt8E9HH97CZcrzIslINmld/sNHKwEBybcDyGYOrfUkuzAznd8/Dn2EVeYAOa4ABp3r6zUS5IN95P4N+4l7Y3nFmMZ7vPZgsV4K92JECTVnKDPaFMfj0s1CyQ7GGQ6HIJdcLDp1ADFJVX07ds9l0uPpR1lTnTKYYZkjAVPb7A+O2lWaIFdqjGHlaVm+kCkvGlChBC1JfLrUYqoYC
 lbIji01I
 5Z0LbwLQJYNPU1wjnM04bPBGodSzFNAPaJanke4QcPDaRNL6xs+XUeSpNNGZG7LQHvM3yfICF7Y4GKFC9kQiA/qwaBD4ByeHJI/DvkqKM7VPRXyLIPOuEZnjJQHaOld0sZHWv23MkNzUhIHEQrlS5xR8H0f62alnn9ktElPfElrOvrzlO/59rrVy/PPaoLiLUYQvVqWez/hJIvGGnWDAvo0Sd3QCJJLhVRkyRPCpzVlnPNAFxsKutry/wMyRcrghRtwLxC2bJazR+GS30YxrtLKOwbrFQBxpboPSQ0n1g7oHikNO6GtJFq+5xegusp/V2B+OwCsXEPeJhR0p6QaiwwbLGFyZ+1tA+cc8CZ6E6qlPApGg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a convenience method `contains_index` to check whether an element
exists at a given index in the XArray. This method provides a more
ergonomic API compared to calling `get` and checking for `Some`.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/xarray.rs | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index d9762c6bef19c..ede48b5e1dba3 100644
--- a/rust/kernel/xarray.rs
+++ b/rust/kernel/xarray.rs
@@ -218,6 +218,27 @@ fn load<F, U>(&self, index: usize, f: F) -> Option<U>
         Some(f(ptr))
     }
 
+    /// Checks if the XArray contains an element at the specified index.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// # use kernel::{alloc::{flags::GFP_KERNEL, kbox::KBox}, xarray::{AllocKind, XArray}};
+    /// let xa = KBox::pin_init(XArray::new(AllocKind::Alloc), GFP_KERNEL)?;
+    ///
+    /// let mut guard = xa.lock();
+    /// assert_eq!(guard.contains_index(42), false);
+    ///
+    /// guard.store(42, KBox::new(0u32, GFP_KERNEL)?, GFP_KERNEL)?;
+    ///
+    /// assert_eq!(guard.contains_index(42), true);
+    ///
+    /// # Ok::<(), kernel::error::Error>(())
+    /// ```
+    pub fn contains_index(&self, index: usize) -> bool {
+        self.get(index).is_some()
+    }
+
     /// Provides a reference to the element at the given index.
     pub fn get(&self, index: usize) -> Option<T::Borrowed<'_>> {
         self.load(index, |ptr| {

-- 
2.51.2



