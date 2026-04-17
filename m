Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F825F8E497
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 01:11:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4C3C6B0089; Thu, 16 Apr 2026 21:11:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E28256B008C; Thu, 16 Apr 2026 21:11:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEAD26B008C; Thu, 16 Apr 2026 21:11:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AA4016B0092
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 21:11:34 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6C2021B8FA6
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 01:11:34 +0000 (UTC)
X-FDA: 84666270108.14.EFA0383
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 87BE64000D
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 01:11:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=korg header.b=ERVavyNP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of alvin.sun@linux.dev designates 172.234.252.31 as permitted sender) smtp.mailfrom=alvin.sun@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776388292; a=rsa-sha256;
	cv=none;
	b=IxkfZCKApiubXXFoenXdYxh41BuJa8GZeBnSl6hKAFbXzFW9ZqfPluNZPY1iBlXfXBMxvf
	zYhLw4x06VXM36wTuAHF5PMmWQ0RvzaIK8nC9okQthoQj8sFELzjYn6XqbZo2OsUg2NCic
	OGlChy8f1yU/4esZrGwMgpQx81szmD4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=korg header.b=ERVavyNP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of alvin.sun@linux.dev designates 172.234.252.31 as permitted sender) smtp.mailfrom=alvin.sun@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776388292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xAiEZcYNchmuL1Jd3nBt9fblDO68DWEzS74OgrYLB6A=;
	b=HjEfO3mzkAgemx1eMaHIAinDvkGT1NAy5ed3zmamohny6JgqLJXMIjni6Vl8YIQstD0xOL
	FueQFB4opPzm8aPdrdJlAgu7s4mnXDW+nfe692FXJ/5yNirHCkAWxjkn7tlPYgaDj604nt
	cAuWE3hWlGaTXxp2wTpVSLTl0/jKCUs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 42192445AD;
	Fri, 17 Apr 2026 01:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0A378C2BCB5;
	Fri, 17 Apr 2026 01:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux.dev; s=korg;
	t=1776388291; bh=F/5SEP+S/zr/1Wvabq3W0ofBAhgKbB5EzANwuYwFetA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ERVavyNPYzsodTs1O4T0WsRy2gXRbZLrmgkue83UvPa1p2Dfo9uLmg4KsFKSq5W/U
	 xMh02BOb6fYSgWIUA9fRrXhtTv9DZCNlDdQEv/JGaU/juRxKn2g6BofyuDZNQVx2Ct
	 GUKi1n3l50ELo9XAxiEj8hUMp/F3In3ar8dWmtIc=
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F01B0F8E497;
	Fri, 17 Apr 2026 01:11:30 +0000 (UTC)
From: Alvin Sun <alvin.sun@linux.dev>
Date: Fri, 17 Apr 2026 09:05:53 +0800
Subject: [PATCH 3/4] rust: xarray: Update StoreError comments for alloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260417-tyr-ioctls-deps-v1-3-41c6e9bb061c@linux.dev>
References: <20260417-tyr-ioctls-deps-v1-0-41c6e9bb061c@linux.dev>
In-Reply-To: <20260417-tyr-ioctls-deps-v1-0-41c6e9bb061c@linux.dev>
To: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Tamir Duberstein <tamird@kernel.org>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Alvin Sun <alvin.sun@linux.dev>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776388289; l=1003;
 i=alvin.sun@linux.dev; s=20260317; h=from:subject:message-id;
 bh=F/5SEP+S/zr/1Wvabq3W0ofBAhgKbB5EzANwuYwFetA=;
 b=mHYTu9uPEnfW/Y/sIW8aE4App2+Eq7VQ+cJKYCM8Ln6csO3vDaC4O7okM3v+6xmI1n7e/ytq8
 VUnKr8eWYQoCUmsdOOLPgvyM73PSb2biAEBFhMnuYrl1GylM0RFUgRh
X-Developer-Key: i=alvin.sun@linux.dev; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for alvin.sun@linux.dev/20260317 with
 auth_id=684
X-Rspamd-Server: rspam10
X-Stat-Signature: i1pgtd15jho1pcn4y7d7ytjjmnydb394
X-Rspam-User: 
X-Rspamd-Queue-Id: 87BE64000D
X-HE-Tag: 1776388292-685453
X-HE-Meta: U2FsdGVkX1/3dkABOFvr3cxBwbok3e3uNZwUfGoCsgLxRSJuWLK4BV1Hr1ur6MplSfZ2fomHCWfLHl5/MzyjJqONQN1xPrXCLr6LTk6G++AJGLDuC82h55F7YQ9ll/ZCmum+HXKhaCoTdOfQha83hQSME8d5MWQ9KMPsUJ79E+RR2hXsqP1hNnRhX1vVeW1/3uXY4MuLKCQy8QF9Kq/MSTJ71wRq8E8LT7YpWDbV1A9jdYZuNS5fbrsoEN2Tc2sezBkFNq8YiJmFq2pwAk4MS8+qPIiz7Tw0/Fd0j2/uflJDfcIvJK2vWUpt9fLHTDrCY4bpfnxLqmIC6wM34GYe2Unu/IDQK0ZECO3ah7yJVglM0+TmCUnpthukGJAiECYkxFkAoLtILU3RUWzgn3g8MCMlb0+GeDwb0NnhUwNlugiJQOcUTgmHJn9KuvcEqILMF3unA7Cl9MWm42MwGKM3Y2rbfRPrDgkvghzsNFZc2QV0cxoidL0MUcHEWUJYZm3cIKNiawrqTyRwu9Yotu4PphkWclOyXG6rLBm20N6WZg99jv+r0l62WyGKFTL9Eq0VFn4lT+zOS0x00+L7JUrTKE5WJL/mqIZkNFpp8k7xBTSvufFtzBWF8bRYQIHfRvkLn2+ZXnoY46HadcwYDuAtVDhz7Kko4D8b3FWc+E8ovDXO98sy4BHBuxGp7yZnKYwApQ3hjjshWV+eea+fG8QLn7oecwvTBIBoe2MP2O3YD/5kb3EeZbdTVMRXSlkOLBIjhXELBXI5XTztVPnCQswnJhMjzpaLnODOcRSH4DdWmcdViWdkM1PYRw/gVzJ7SVCJzCvlPEl5Z3cgcmFgKyrQFl7lwaJ/vnaR8ynvAu7fuqTB872dIMffwoEVA9IsOHkMf7CnP+LxT1JBD1FVy98Br2ngXy4GndgOyPxYZfhzfgDcu+6lf/yoPgYcPV0hyPrmVer9XcOhZWiglx3gPsF
 BEFms4he
 woC4Zu+0jK9T800ZJbz/2g1BiR6NeZmfa6QHAk0LMpfCr+JPdyzWC9bAtvLndJoJp8SMzUgresBerDNW/76MJ1oqADQDF1o4fEN5p6HE3ySKjdZrlwpVAAB68QoDhStxAqg4TNTahnkiQgP8D5LUdBOr26JsdL4gq3bFK0E2qJN94w0s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update StoreError documentation comments to mention alloc() usage since
this error type will be used by the upcoming alloc() helper.

Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
---
 rust/kernel/xarray.rs | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index 1b882cd2f58bf..235fda0e394ba 100644
--- a/rust/kernel/xarray.rs
+++ b/rust/kernel/xarray.rs
@@ -161,13 +161,13 @@ fn drop(&mut self) {
     }
 }
 
-/// The error returned by [`store`](Guard::store).
+/// The error returned by [`Guard::store`] and [`Guard::alloc`].
 ///
-/// Contains the underlying error and the value that was not stored.
+/// Contains the underlying error and the value that was not stored or allocated.
 pub struct StoreError<T> {
     /// The error that occurred.
     pub error: Error,
-    /// The value that was not stored.
+    /// The value that was not stored or allocated.
     pub value: T,
 }
 

-- 
2.43.0



