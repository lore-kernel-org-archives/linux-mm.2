Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC42CD25B5D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 13:22:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA15B6B0088; Wed, 28 Jan 2026 08:22:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4F076B0089; Wed, 28 Jan 2026 08:22:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D514D6B008A; Wed, 28 Jan 2026 08:22:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C20236B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:22:41 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 55E481A05C0
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:22:41 +0000 (UTC)
X-FDA: 84381437322.04.4318F1A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6AF9E40006
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:22:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C5NuxAiJ;
	spf=pass (imf07.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769606558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZLiS05SuBxshPns1GO4e1cWk/Z6o5KassqtJv/w3s4I=;
	b=fArfJS6/0IlIGFU8649zduHAycIGTBLVct5V5U32cwPbizWVtZr1cErSIVG5fekmCN72vM
	AFStP+jaSCedRLFMvdOjXfVhNDQijI3hXKrtERUTbAHmG6a3Ds07wVsO2149YWqkU5OwjA
	mOYQPSJ6aqCw6heDAkBTCOg+c+clO+Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C5NuxAiJ;
	spf=pass (imf07.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769606558; a=rsa-sha256;
	cv=none;
	b=POueA25kBYgotZ1ZR5OyIPPZeCS5Bl1ItHpXetXP0DVrZmZNmE3Ldxh3/SI27iBd6nAlpo
	p2K0l2NPosfk4SBXHYU2jd5jMYH399qJd9Z6MKxmp4Wwy7gaCR/H3svaoeamDuk6cr4jUE
	+48NIKvBan86EOd/r4I5HwBS1V5h1as=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3469043FDF;
	Wed, 28 Jan 2026 13:22:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87DBC4CEF1;
	Wed, 28 Jan 2026 13:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769606557;
	bh=YtzxTsXt0GJ+ENj45RZS9fS1u/2Tgc9mlxyHhpvBFzQ=;
	h=From:Date:Subject:To:Cc:From;
	b=C5NuxAiJxZ7lpFmJ8JRUccEZCUHinu2ous6SDVZhHCEU7rv9aLYdjlUyu8V1LvY20
	 jasGLWycInDADgRRK2H6ERBdPKdrPGtOjDHfh24ZNYHrAZA4S/mnD8hE001f2xwDQo
	 +rMmwMi+idjvJV3HDp5Gex6V5EAvKA0b2f5xm6IaXG3vLQtmAFc/V2QniYyKpnT3zz
	 zfeOxtBAi/MW0H84mfvy+KTjXGIu2GbKNGmy2FePNIXn2nUlP/AjXOh3jiIVjNmoP9
	 r2GfaK2Hu9Nqno4ncKpjWrJQZajjdWhdNfoiHMFzKyxRshuUtHc0zZpBN01R+lnWRA
	 8GRlZMofZZfAw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Wed, 28 Jan 2026 14:22:06 +0100
Subject: [PATCH] rust: page: add `from_raw()`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260128-page-from-raw-v1-1-b837bd3e0545@kernel.org>
X-B4-Tracking: v=1; b=H4sIAH0NemkC/x2MQQqAIBAAvxJ7TlALkb4SHSTX2kMqK1Qg/j3pO
 AMzFQoyYYFlqMB4U6EUO6hxgP108UBBvjNoqY1U2orsugucLsHuEWhRBTXjFIyH3mTGQO//W7f
 WPogE2g1fAAAA
X-Change-ID: 20260128-page-from-raw-e8e1f14e3f6d
To: Alice Ryhl <aliceryhl@google.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Andreas Hindborg <a.hindborg@kernel.org>, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1330; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=YtzxTsXt0GJ+ENj45RZS9fS1u/2Tgc9mlxyHhpvBFzQ=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpeg1/BX7CRXZI3MhGn8gOv0JFZ8k7nRYQg2xoR
 ZWRcCd5rpKJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaXoNfwAKCRDhuBo+eShj
 d+b5D/4zlYXnTU2mN5eQJycVBZ0N79jgWgvA51QMjDCiT+SxcoaEhA1U8c3lJr4iR2za/Rq9A4B
 fy5Xp6T9IOQ4MWvJiUrHiVChNOwHCsNEzYYDFlSnze8WyV1FkOzAtoA1InNYLqS96cv+fB7s3iM
 F9QfYnm6e0cSe2db5myWKCz36MYyVisRMsGmBze8+5V0CC5xm3LZo+DTB4m8Wc54obO1whoe12M
 g7psSXHKkuHWm0E9TAEEKrPvCtfJIHrecbHCGdiNVott34HenscYHy6gekkyCn/ef9EVjmCnasf
 ncEIyON/XzYu4NLkei/o2S1HMW8eU4qbhaXL27dg6jEMOs7n6KBD2tyaynhnvl5CJhJNpWePLzD
 4bunsDO/6lT0lSMMpe9ivH+FrOZozp4Q1W7PHuw2rnhtWBcHXtJgY02zd5l3n88/hWXB85S9bZ5
 dQVv8UYal4TbGgo6f5Nzh2bkA89SECJfpY87KnQe7aEg3olmklha7ICXDE2NBP/8Cn2KIYCudsZ
 gqhNd/9kRRbOenNDVAPi8AOZRWhmplgSaAW1B4XGkpSIGcQXxAxvzwdsokaPA1utu0KfDUIrD6b
 osWOCpWzimauAxehsJrpIyB42YHpploJ0uGaqMC/uRfeBJruMxea4E1NsHf7RzWv0ISCfsGrpm6
 Oe4XehL34tBeStQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6AF9E40006
X-Stat-Signature: r4wigd4nmats69d197ihy4fadg8ayknn
X-Rspam-User: 
X-HE-Tag: 1769606558-257580
X-HE-Meta: U2FsdGVkX1+eaLdNb3ydfdKVuLiZfRi1kzPv9TMPtBJXHHUA/b5Xn+GhBXAzpWzlEQikFYRXZu3i/5t7DLAKwmqKnMlzeiQkk+3EZtEGSxUMOKJS2aDju9gPMaaaK1XxlF0RSS7yVj/G5Ddfszz9gYN4KsTuvrLjhqAZkr8+2Bc+mkkbKBCwr8s0CaAp+KNaveiPgrQGZpxauN1vfI0i+y8k7/5AKRFg/be6iT/Mjl/39cU3Yk8LrK0cIs+nuTVNL4z3w4f/FGg2Jyt/BcPTIkFG+vLl5sFm47Frw844q6vbupxoMycZ13OH5RcRvoL5JJJP97y4qza3/zANXSfzjHC/+svKbr2qoyqZcioLD97neNLR/hLAkoEw5HNuFI2GJuO32DYRPdqj3Gd42doq868zyBLSUYSOAhceH4hFJDQ8HwxAtnblQo14ncljK/BU1wknW8u0uWoe+6OJhMRe5HTth7Eoc3p5SWmrEUX9GhdHDN5k5oE5UJzB9yq3i8ASxXPRBk1pR8ph8yY9DBDSYxX0HCT1Sd691JPZoYC9dTYGRgeliyA9FjGVg2dnFWECQKnAoCWCrfP7fVCiLNFg0LdzsDs302cQjtc3H2mH9ILbFfht7Zhhx6kfplHj3T+0GDb+bTzkl/kfG7XEhb1jH6KVo9SgJShHABcv/8e+qw8/YBBrAW3wi1mQVk81tKotC2zwvhvAY0SKsurysWgknSiGavZJalmU63Nfm8v1ZwclRhjNGDIk0yy7AabWICsrIxFopzBTT4kI4tTBN+aTQWkIBCoZ50lpSwcT7ykSEMTfNcIAVaNOQbvaQ5WNOJCqjVCtRODMrE3iYeuleXAvwNlHuK/ZbC72vzuM2+7QqPO/0Y/u9ODlN88MczIWSlQz7/QXlJkUPYXF3VP03HFadXPCM03clIABFacoCgvCEOEP8ZY6DynI6uWVKuq9/YnkgV9TDHPkl1O6eiFqD5H
 +gJd8WFP
 nTXuzFyWsMeBCKXD0dNHmBmVifDLeGJC3m55pJ1mGunN8+X2b16LUDsQRhewgR+CzPULm+3n7qHsHZv5D1e/TEZikS51wY+Z8A110lIwxl/sWi0dAc558QMjWq8KNWUCh4+CHNBpdNxgTiKrQKdkAc4Vhzw0iLsQvTAksc9W58qLcMtgY5g9no7BD75xFRrGsS/HfaNs1dFyseI6jCyfRYh1o7FO+CCzxEAEhRt7ifKQEmfZjL+yeOLX3JbLC5+u0IMbqYE65yjEDbH1VM99NOVoQCt3UFLE6mAMlJLjh84XQuv48YH7s4+PfdsmhifSOMvzCBxPdXmAzU7It5vJ9rZWI7QxMGVf5jY+8uEKm4y/bilsOcAF27HwZ2HHV3E+3r9Hd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a method to `Page` that allows construction of a reference instance
from `struct page` pointer.

Signed-off-by: Andreas Hindborg <a.hindborg@samsung.com>
---
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/page.rs | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index 432fc0297d4a8..f666c92fcf451 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -176,6 +176,17 @@ pub fn nid(&self) -> i32 {
         unsafe { bindings::page_to_nid(self.as_ptr()) }
     }
 
+    /// Create a `&Page` from a raw `struct page` pointer
+    ///
+    /// # Safety
+    ///
+    /// `ptr` must be valid for use as a reference for the duration of `'a`.
+    pub unsafe fn from_raw<'a>(ptr: *mut bindings::page) -> &'a Self {
+        // SAFETY: By function safety requirements, ptr is not null and is
+        // valid for use as a reference.
+        unsafe { NonNull::new_unchecked(ptr).cast().as_ref() }
+    }
+
     /// Runs a piece of code with this page mapped to an address.
     ///
     /// The page is unmapped when this call returns.

---
base-commit: 63804fed149a6750ffd28610c5c1c98cce6bd377
change-id: 20260128-page-from-raw-e8e1f14e3f6d

Best regards,
-- 
Andreas Hindborg <a.hindborg@kernel.org>



