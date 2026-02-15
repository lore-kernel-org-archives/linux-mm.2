Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66D6EE63F1F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 23:58:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E7966B0096; Sun, 15 Feb 2026 18:42:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17E506B00AE; Sun, 15 Feb 2026 18:42:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 097C06B00AF; Sun, 15 Feb 2026 18:42:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E77636B0096
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:40:56 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 776B8BCA63
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:40:42 +0000 (UTC)
X-FDA: 84448313124.26.D81A5C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9FA8A40010
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:40:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LcSSioyc;
	spf=pass (imf07.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771198840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oST2DRmUZlaxvoLF5U2BkRHkEHLO+Df5j4ljmYRrMwI=;
	b=CEWcJdqd2uiUN4nd94YZxKCLta80HlVq5PsSqBM2l1vPsusq2eyhUkHdACUo1hurFnphWc
	T4CwZ8Qaq3a1VihDBDeRmDGd/+H5FJvR5S5oQ1rBIZ/t40MFXz29O5Jx81RxhSF0T9dmJq
	DhCtfgu8LQEi7cFfUcZk7vygADuz02w=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LcSSioyc;
	spf=pass (imf07.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771198840; a=rsa-sha256;
	cv=none;
	b=mQUmueXuDbhwT3GGaxZFtFgRyKagwhlqtY7FoZvkUHw8o6YLI52wiUue6Qzb4yT8DMG3BI
	iXnYFIRn7xVSwCGZmlq9Vhr7PzXyewxv3MM6XHB5BunUnjt9QAsrBEUccGe+LiRtPL6pPK
	VtFn0ZOSNGYpcN3l2a09t5NOehaVq1I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BB60244366;
	Sun, 15 Feb 2026 23:40:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C190C4CEF7;
	Sun, 15 Feb 2026 23:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771198839;
	bh=O3C0OWPFlCYQRkqgbpxphoxzn0AXFyZkFVXVYjg1yE4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=LcSSioycaHq7sW6v7S8VaMxmPBnrA0XxM/+JfYOZzzNyMOKQ9iJnYTOaI0DgToSTp
	 bB2PKE7e6AniGtKH1YCSTRffWWeIxzuD+r0kRNjm3NnH81MN88AskeW7Wrry71RgCl
	 a3/M2ZTS8ZU/Q/c6edwuFMId2JfKy47xwf7GbEA8V+9ggW4LAExBmGR6o/VUhpP2j4
	 ihEBh2jyeTbSuOGQn57iigRsghpmM3IlkCAURIzlifsiQ1C3xmUlJU5anvFFLuew+G
	 xu6LFD4QMgW2hvZKcSv15Gqui7zG641/KK0tZGRFSeme74yzer7kJsvhKkFSTXcdad
	 xtSoAtNYXDWpQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:32 +0100
Subject: [PATCH 45/79] block: rust: add a method to set the target sector
 of a request
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-45-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1174; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=O3C0OWPFlCYQRkqgbpxphoxzn0AXFyZkFVXVYjg1yE4=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklhEQwaxLvWD0eoBUNtZkrfvjdBAfQM5QFLvA
 DPqydXXjkmJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYRAAKCRDhuBo+eShj
 d7HpEACf0tE//nAl5WKx3CMVmGyPVZd06Zxo3HMqJo6lqiyYsbSiJtt9bGZZbPI6/H5CWRAt1m2
 szk1Q1ELBF+ypVdLMydJS0WraFl5vKpHY+tWPvkQURN5QOLlSCi6g9kz+gfDgRoKx8a5CfcRAEk
 uJFZuYIgnptGybIxMuQYiOwAxvwVFYPsI1zEQrvpNUhnq8DLGB6f6lvRE0s4/ZksCGPAxkRzQBy
 wF1pdl7X2z63pgbZZHh1ngeHc6g+UEfl/dzY9mHeqzwkYUYlUnECxI2FIOrKAF8D7grLtfAL/lc
 6/hsl7UtTA1XOMdaHcnwVGjZjglQE7s0jCFbSsnYdJBn1ly3Z56xArWHvtVFcMasgoE7IKE0eOp
 iHbf9JNaLaCOrrMGicyUsl1f2QZNfrctAe/1c+Iw9Hk08uNCkkkd7i4AGiA1uHX+s1gFKtkikJ0
 DHGZVJNZPRHJxRgdVcqfD1jq69/c0R/o1RJhlyuytbRxGcb0ok82GDSGv1r415P48i9IJNuqV4Z
 FeB9v1ChkeD6VgzxMWKi4xO+P5Tl7ivi9B/OrJHSPQu+Z3swBN9XdU4bZekYmvYojAZZ+uR8iPI
 Tj//FhDuPVGWtrVxOG06uGngv2m1dzJF9k1FciK+tf73F9L2IirB2Z2060mIt2oBbGHVpg9T4Lt
 EvIIMlfAMkM/cOA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam12
X-Stat-Signature: ts35ygz6x5ejg9bhyeh161on866uzngu
X-Rspamd-Queue-Id: 9FA8A40010
X-Rspam-User: 
X-HE-Tag: 1771198840-194814
X-HE-Meta: U2FsdGVkX19uSB47hPZioiESkMSw87ed+z4ax4GXEdUeJFGyYYKm0p2s5ZWN534o9FpRQo2zhSUtJqUt3fbeLR1lFsyDNJDpR49PkOgsw2Q/TfBec6wmQ/IQEhxsFk3+/LFuhpaeNs4df6I3Oz1Cm06vS3kLUD41ExfiZ8OXHLLsxOhWOX/kegukpl3dBnfEn1pzsFz65cVEs3+XJdbMlx020D9FXKkh/wSlRZPGXUN5TBLZ9rW5ArW+tyjafSTYUQNoQZHpO3qoIeULvy35BrSTOLegzsbZyZkIZWAbw4RvvzYkd01ENLhdp75Blea9l61L0q7mWPkZcypKW7jjrZxsbQxxPTfoS9fhf5bM046X6r+Y96Ft1QEGIJN5dHkIPRJSyzKuSjl6FayPR9wdYgblhzl5EM2XT+wPrstuWnYOYJZCk/MwuSONuKOxcX/KcOLzXTs1Mr3lrcKK2h6HBzX35lHtNU522cf+vRYB/rLCfppFW7D91R26QNYMVFfSeI0oky30J1ZxsErVM2KeGW/WdiOW1iIS5/mQFRRA5EC8fA3gLgy3WTTG1Y7I2twiVV4JlvSVaHktltLV/90Nxzs60lQChYLBLodHwTNCCX1pgBatx8pIHEWf4mGC4P1JSyhzAG+lec7JTdb93QvCq2lGVC5t+zGAryK1XSDInsPTi23pUOBa4NiuY3oa80PfBSQmL1GvBU3Ego2uHxCVVnbX/q4RsNg9weOpbJGTv0q111TLqru0l/AaUXSb9Vn9rTYdcDjXYWFBRuXf2f/AXcqxT12biIMJoWH9or1bcFk2IeKcO6KzGRP/5AUlm/yvkcD2HbRT1ohYQ36EZeeDCdsJouX1c/T+q3bNlMeBzCbpbE1OKKFnxO+c3CcS8NVGTa//wBRo3yvFmpaW3lSQBiyRR+oVSxwM/NIWfwPr/SLMAdGhR3p7xpQEpLKUcaNvav9M9oW1MbpolKlnBl4
 8y61zpfK
 RU+DMw/g8LYCoZ6JMOniE83NzlJWABpCDI0n9wXfLeK8aRVimTE/08UZktw5MezWNJZRvgsaXaZg8fiKLg/1i95jXVqIubXOsG4WvDJ1bVhRi5teeJDdraPubNpCmuTOX9wQ3hUZ6QJYs44/a8WsNkkhipN8KDZl3MLXZj0oViFCtgQPJbUzyQ2rnkX/OnjhQuMx6/oCBlDPCKuhW63DswGVGqACYjIMC5hKimgdPRe+ojJW6OxPkbuwrATTz4GCzK5UGziGUJ9J4N2EFeaI+F3a0q+81jzDO/Tmrpgg7zvLHgbiEqxAIQ+l+BLm8bxVqpCp9Badecczn7VGaYnF4JMmpsQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a `block::mq::Request::set_sector` to allow setting the target sector
of a request.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/request.rs | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/rust/kernel/block/mq/request.rs b/rust/kernel/block/mq/request.rs
index 4e47419776e0f..4e7adb10929f0 100644
--- a/rust/kernel/block/mq/request.rs
+++ b/rust/kernel/block/mq/request.rs
@@ -7,6 +7,7 @@
 use crate::{
     bindings,
     block::mq::Operations,
+    prelude::*,
     sync::{
         aref::{ARef, RefCounted},
         atomic::ordering,
@@ -296,6 +297,13 @@ pub(crate) fn wrapper_ref(&self) -> &RequestDataWrapper<T> {
     pub fn data_ref(&self) -> &T::RequestData {
         &self.wrapper_ref().data
     }
+
+    /// Set the target sector for the request.
+    #[inline(always)]
+    pub fn set_sector(self: Pin<&mut Self>, sector: u64) {
+        // SAFETY: By type invariant of `Self`, `self.0` is valid and live.
+        unsafe { (*self.0 .0.get()).__sector = sector }
+    }
 }
 
 /// A wrapper around data stored in the private area of the C [`struct request`].

-- 
2.51.2



