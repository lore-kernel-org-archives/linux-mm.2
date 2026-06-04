Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 246C2CD6E6E
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 20:00:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 895CE6B0095; Thu,  4 Jun 2026 16:00:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 847326B0096; Thu,  4 Jun 2026 16:00:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 784126B0098; Thu,  4 Jun 2026 16:00:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67DB06B0095
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 16:00:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0FC44140204
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:00:04 +0000 (UTC)
X-FDA: 84843296328.13.D93893B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2AEF12000E
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:00:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YO/iaCXs";
	spf=pass (imf03.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780603202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0nBF57LRsWrMEo8iN2euSSytrxyB+R/0oRMmaelTwQA=;
	b=i3OpGD9JAJNijSnIWu7L2vaMKAgITTb3OS5d5aXlA15MXAvlUFCQq7kXYH05t8v6iyXclk
	E8NO+msuzDkUPOpXrzikZUBKInKvGCBMcNPfg4vqgBSQq+YGsksMlzrY2yXPV294i9nh+i
	KfyviitcDogrA7HzBbfQDysL5F3AC9Q=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YO/iaCXs";
	spf=pass (imf03.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780603202;
	b=iceR/i7dXV5Cj+9djVYbpnjk39PbPg3HEdwTGvPX3fYcTzbSUznZz374B/gOAi2M0N91Mt
	FDnwuf1hEdeWilfvva3a3sCVljWDqh2wUjsDiKX+R49vMQClW4t8kPYT9+JrLpsU2A/XlG
	UXv5QWSKU46rZc95qpqLjsWngrA4qtY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 64FBF4358D;
	Thu,  4 Jun 2026 20:00:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D10D1F00893;
	Thu,  4 Jun 2026 19:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780603201;
	bh=0nBF57LRsWrMEo8iN2euSSytrxyB+R/0oRMmaelTwQA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YO/iaCXs1ZU63nZVH1a43zbW8BPeEPyW7LFZCDDd5aVO0JXVJTt/1OW0VvZuvisiW
	 TJlHfnUzpTJxFgNyVRQjDc9WNCg5gvwTxlj96TNDApW5aOAFjFIrrRbHSkFWMifdUu
	 i0pT8C0EpBz5CqaV296YpJaGTWF4MHkz3khQmEMFsyGmOMfQj7jnRszGL/OPKeFbs7
	 KECsJiYIyKv8ieP81f7zerO+8Dyn7RESVDAsSHQOKk4DHYZKbqdzWpL5FSwnPqBKQw
	 qm/zy69GWjTXKAbjAZPq8pyWhCzr8yZqaUTyQHcR1JssnixZdcZw1T7J8E5hXhrAjM
	 8J4uN7fBuaSmQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Thu, 04 Jun 2026 21:58:08 +0200
Subject: [PATCH v4 02/11] rust: xarray: add debug format for `StoreError`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260604-xarray-entry-send-v4-2-965f6028790e@kernel.org>
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
 Andreas Hindborg <a.hindborg@kernel.org>, 
 Daniel Gomez <da.gomez@samsung.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1148; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=l0CwU5Ulb0y9mTSS9KkZDum+7qeUfx4uMpAmUgVECbw=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqIdjrzorzq+4T6PurdpmkIUWDjVZ/tEBb8myon
 5d/0/v7XIqJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaiHY6wAKCRD6UCkIqsW9
 0EfUD/9OWWqFNFIktQfpK1Hyle/LSAjmNlESK91BK2sb65VFLfMXyoTm67fb3PbbhdLRKbEkrN8
 Cmf/q4f9mPWpw5IZXPdvpE6COADtszfD/KLvrYr+fgFA16tWnvXtjpxp2Sy+SWI02uLkeOO3YYU
 6lln3/eE5N9bc4aMSJHSFGXFOWQUbPnqy3NYMONVbnZuBUd+nQdSE9iX67mmCZINedr9HMVKdpe
 SmDNlTDHEEyfCRUn6bwv9VEARI3o2Vm8HOhMaLbmPqRm2h3WCa6DpRqQbyVDa5lnsRR/UNLJ6Ky
 gF9D/p/gAu66ru+R26U0G13ri+7ntEggShXuRw6SKs44stEdanQk/P+BnTs0ap6R6eI6a8wnnbx
 +jFNpn5TgiXEWqTPXZwn7LAQYbuBsr8K6bmC3qhDypfzYg2kJJq0k+Fnk1kPOrNT0FiwDg+pw0N
 JBdHH3RkypHidqpglHSixmYT/p4ggHiD/osQLnLyHsjjOuXS7yXxmfkwBCqfZmRf7W/RDniTy2i
 cuz2hcNkOaEPrH5oEwGuWi4o6V/oYIKLq8RISJViVqVr4z9TfRI0hrQVRkot4v8PuOI2Abl8QoB
 +HOJ0ZrYUPLbqm880J95kzG6gBV3JFxPGpPPxQSJoBcYFyK0BH1nEPSdJGZkiUx21JcbCpmM1p4
 frYqT+ng6G3oPrw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2AEF12000E
X-Stat-Signature: 9j3jz16f9ki8edd6jrk49r9pdr718qcr
X-Rspam-User: 
X-HE-Tag: 1780603201-435541
X-HE-Meta: U2FsdGVkX19OR4GbkZyquJ7Txk4dxkCfp63RemBe0swVIZtzA4kkWeuYJoRp3yOUOsxNMwNU3P4ufJOzPvtnvuz6RHYqF0qQ+R3mjZ1Rcdd5CMmKUDhU1FNXIbTZK7UQ3pFHwjqGXomWD1iac1Co2tJzOSKx6uquJ1D4TzrWl+B2qmdDTXnI01+gk7Qu1R35epdK8QsVX8GRtajupnmMzI0zFOmIGk+S5VVc99CETR449valQrJs0ogcw0Xvj02HouH9QCX4/4Goar4h9lki282wjIbugJOgxJRGWcJtBzTV9blb7WEfgLvGgjukRxklGDMxgeYZtPG0FiprSXlAzqPyQMuZRS0cRCuFXBxjonBdLiab49SP7IFFQXcRPvILW481GRbemzMHeBbUfIIS9D7qZLy6CNOsA7qRPSwsIyHypbdqeWT9/QCG1D2RhOLM1JQWYYY/08Hh6qWN6m+joiAvObZ2nUmEJaiv8IvUifPUIfTVskWyAy2z9HqRfqxYn7RppJAoq/ASnPgf32EF6HxoGHtlzP42IC3M0m4hTmDgkYaUgog2UI8RRjKrZBmE6xsJg6/aAGz9n9XABciL6id6vklYcDrEUbd0Q3Ymvs0mS5E+I+itC6330taTdQ1z+8JTI8IayeOrRX/vBDcuwa226Wnfh3cx9+HaFvOQfnj2d4+T5XWKb5gK8JXrPzfyp+cTXOVsdxeFErCK8MUMZuvkbjqZ8vSayWoNMO4vAjrEHCH112IcwL7MWuJMi6ZBUz2AKtwoN/vDZlrz6oEJsBdcgh0J5A+rZWoHhbRejYv9ZTuRe/csTwaSQbV+IsJzBTaVRvmxl+zMrVgd42bcwDCmk00SSX7Fim+Bhfas8rDVoyx4A/xTxJ0OcgAhKr9MD4v/iw1nacG4mUt9TDYEygVyvzn1u40beNH/991UL4RVB1iA2Uc4MDX5pYzcDzv+EFgcfmwL8W8mb9rzn9Y
 z6p6d6gG
 fs2ooRPWlGlKvBg1XgMVioVSTCJMMpUFOeejQxYtEsFGXh/F0brDcrRPsBENISnisAm+wbF6qIX0QNk54d2+R3kwqjoNuVD0OjBcfM2LGf2zj9ApR7vZkeP0aONeQ4uH2BmXGgDKIB/GK0vxQ4y7ElZXOd3tUmayNCSkAvBvvozOflk/yG57rIgrwjxGosqy4tZ+XD9jIT9SmXZT0zVgNa1Ul/x+Qp03kHunW3YI21Yb0Ex+6V3uoMNZYqpifPCyl/kJs5Tfm/zJO7hYxQMqYD/Y3KAvdDHPI5zbL/v724zaKVHazUbK/q8zvSoT8EmsGExIoyWoJdEYf87uelWIbmA+qP5TeLaYC+aPPjw1aTQjqA0dmPa8ny9KK2TmN8c+ohRs4ObZyyBPRljzorCCHBTY8DSvRyAJiJr6PaIxtzJtbPd1FYH876tYfBxBMCfhOoNpn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a `Debug` implementation for `StoreError<T>` to enable better error
reporting and debugging. The implementation only displays the `error`
field and omits the `value` field, as `T` may not implement `Debug`.

Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Daniel Gomez <da.gomez@samsung.com>
Acked-by: Tamir Duberstein <tamird@gmail.com>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/xarray.rs | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index b80fb7a262d0..d54942aeb201 100644
--- a/rust/kernel/xarray.rs
+++ b/rust/kernel/xarray.rs
@@ -193,6 +193,14 @@ pub struct StoreError<T> {
     pub value: T,
 }
 
+impl<T> kernel::fmt::Debug for StoreError<T> {
+    fn fmt(&self, f: &mut kernel::fmt::Formatter<'_>) -> kernel::fmt::Result {
+        f.debug_struct("StoreError")
+            .field("error", &self.error)
+            .finish()
+    }
+}
+
 impl<T> From<StoreError<T>> for Error {
     #[inline]
     fn from(value: StoreError<T>) -> Self {

-- 
2.51.2



