Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DB7ACD6E5D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 10:34:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5A836B008A; Fri,  5 Jun 2026 06:34:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A31CF6B008C; Fri,  5 Jun 2026 06:34:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96F966B0092; Fri,  5 Jun 2026 06:34:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 884746B008A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 06:34:43 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 210401203E3
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 10:34:43 +0000 (UTC)
X-FDA: 84845500446.18.CB7E081
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 46E1020003
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 10:34:41 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cvGJa/uf";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780655681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=NST7gRmZZfVHFgmkPYEmeNwfb5XeOUP3jSBT+FhU7LA=;
	b=JxTiZQaC9ykAeyyvoLEovXNWHYV2Cry7Oy/1qeec/03qGAGwN934l1cw+lT3XVSGFrlv7/
	9ghSYL9KWJHVXioQ1QSkNoq9Z1WqSPVkugIktlCuvvmQWFeRdSOVEbIfU65f18wwGEFHS4
	GuzfyHm8Q797XWof25LPkrFugOUKWGU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cvGJa/uf";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780655681;
	b=pYs3Y9A4WaxmkutYcVA3Fcue9cVPaN+7hVnoOVUPguJj/dfHa8nYmTHAQQovERz1AZialF
	Wc8hlsqShvNO1+2dqvaAR4CbPwRTbhtqG3elJEAGc5PKtbkEhvSdBj1Un7GjgCGV29jRWg
	ROEw1Uco1uE59YocIVN5QxsmYQ0Ad4Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9277143421;
	Fri,  5 Jun 2026 10:34:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B1A81F00899;
	Fri,  5 Jun 2026 10:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780655680;
	bh=NST7gRmZZfVHFgmkPYEmeNwfb5XeOUP3jSBT+FhU7LA=;
	h=From:Subject:Date:To:Cc;
	b=cvGJa/ufFqXBY6vq5amhcKIu5LOPT5oUd8zzFw5Rg1rqwQlAPMPT8ApUiiyP7ebbr
	 pww3rWJH4nGsHtKbI3we6z6r/D8djMPH0yAQmLZGq9Mk1Wy7x6xG6XLbJTYAfIXpEy
	 FeKWaz5ukrh+RQkhPpIOR0Yr7Nm+xBV09KaPP8raTy8Z4xPtVi/Mcwyh71hrvVp/hO
	 NmIX5uT45Q34h11ofGeWBmQR+HOOBfvFvQzjx2keCydxnRx/pH7JDlzQMVACJfPrmB
	 I1jY3qddsobhwvoNsS+ZeCcFycAuxspERb830Y3C1zFns9KXjy+/qFyjfQxNwQJDqU
	 27rhrxLaqMr1w==
From: Andreas Hindborg <a.hindborg@kernel.org>
Subject: [PATCH v4 0/2] (no cover subject)
Date: Fri, 05 Jun 2026 12:34:12 +0200
Message-Id: <20260605-page-volatile-io-v4-0-0e217d9bf11a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIACSmImoC/33NTQ6CMBAF4KuYrq3pP+DKexgXhbbQSChpSaMh3
 N2BjRqJmdV7k/lmRslGbxM6H2YUbfbJhwGCOB5Q0+mhtdgbyIgRpgjlBI8auhx6PfkelgET6Zy
 spCSF4QjOxmidf2zk9Qa582kK8bl9yHRt/2CZYpjKccNt6ZiSl7uNg+1PIbZo1TJ7C4yyHYGBo
 Llq6qowVDbsR+CfAt8ROAhGEVEWNRFGkC9hWZYXxzPFJTUBAAA=
X-Change-ID: 20260130-page-volatile-io-05ff595507d3
To: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, 
 Boqun Feng <boqun@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Boqun Feng <boqun@kernel.org>
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2483; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=P3H4bvDaNbcUvf4aTCEML/eCJnRBIR/vOv9WWmF1sn4=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqIqYmjpAF+ERZQcuSvF68y1p8um9kTxpFgh2+O
 /Yv/A4AIHKJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaiKmJgAKCRD6UCkIqsW9
 0HPAD/91R3/BZFEWBZ++ERJCcH8ilwctEVhIYqSM9hvtEaBafttDHRpQ1Bj6DmttG1H8e6I1bQy
 tsjCdmhxz+QJ2kdgyPga02OSBXxwzW8hAg3XHDdfIXGkiUFJLyM20AHtED9a48NrSLg1i2kZHQB
 4ScmcNPiviCdBo9JmNz8Sz52ki4uEkdmfTdj0sex9GtXVukois7BT9Ks7irXUnVCWcoT9EyKZJm
 EYXxGkEMD6+qaVp4YUQzxzWLVlEcoXKNd8PXVBw2/y2OJVCiRbpt0jk7wLsoNTDFojOg0TSRrGL
 KNccfjy6ixxlar4uYqGl5LUlxBHoy7s1WU7lPa1Ein4Def3IlTUKdtb1Cvy/yobtZQMgNAZTf1E
 oGU3rDPZrEt3lPVBF9pYyg1+vO4hDAbCmGhpoXjJSzs2EvJ3JwRZQrlhFPtXoux6FgEFHIvW5Ip
 gBbbxd7zY/cTwX+GQ9gBbdckKEcTU1toGdoFPDvcjtn1TXxhBBF8RSq/XJSdEK493bt0ZDra+9w
 DDaAQByyoV+W+Jo/UOLXKvNHHK7uwJ9X38QsCN/rbFoEgRXlT0pNa++iWW+tnpCtwlqyTFvG54H
 P3MI+qYAh6tv6IbCxsuQLIZ0h65AB7uc6vuXg834BMRCNMxgpVcpxzA+Hwvyr3ekh7LCacVelmn
 z7ZdzC+3zHrfm0g==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: qdyyfizbcyoatnad5cpa4ijxnsg7ogfk
X-Rspamd-Queue-Id: 46E1020003
X-HE-Tag: 1780655681-12983
X-HE-Meta: U2FsdGVkX19pEz4jS6WaEzWUc5zO/S+NbQWrxi3gVKEOT3mWGLOEB57PRRjuS+NIXJENQUbaP8q9eCP4bhfNrB4VZANdekxiFsgCOrd613Cu7TvzstT/Rc3Sqy0uQDOrGjpUKe7e8WZ5glbW+X6HcMsQwKw2O/MyfUDYx5gNQd6REtk87wzHuEjiIkG5rEDVslOKZ5LnP36Lf1S8UQxSJaTdq2OiM4937tGQ0bWWmNSPKO858I5pePlzPW/hq67OmqeGMtiLyQl8unlKmOMlLt0ilB0AJ34/MhOE36VqxbDUpsWRTzLL3/xfO1B9GCOanPSYK+Xg1gof/J3tpIA/lq/QBtpY7qDCA7F1sp8yCjkhAF7eI7+Q5TtbhlRt7n4CXfj/TDRc47zuoi3ihf+Sk6w3IGTJXbF+TATKpkTCjsIVR8jywTNZg2M1c1Vj7bc0K0qqv0JWcwWJXLvPzjn//hMaEPuxGi1xBugIGotzsshuTDBO/YpqOqdU3hKbwfE4LExmzrUKdXFfQLtmkWZMhloAfVcKN0GrqrzmCRvoz/xJI9+KSWzCjwAoLIbdfgHxhKrKtxjyWXBO+q8dXXe3yVbKzcCRLZvYXdtSQwpIfRxklRpVU5ZsOsru/8qoi10079AVuGkvtaOptDxCLT/vWZ4mMdKeoP+nuUBGWpulvr6+hX4lfRRFd3s0K+TSJwLcWMgLmq8U9l2s0/GRREGPUQHH/ur+c0A8TrBoX7/YR9ti+Dj63ijmAtptd75uIcWQj/6ok+g5yyPAD3iJRqt+WIKz7MbPpk1ueyq0CsvHj8HkifC8boJzAZ+kdNACKaTlXue94TmWcZF7iHKMVZowxfNhER9oLZP0GN26WSMSGY15fPI/FENJHsxlX59Ujnywe557KzZzQniLBdHxrWTWQ2hjpDFSqkxox9k/9O1uB4wTKhx73hYOEhQeyjKj2WbEbCHsv2Z/NqFjuLsbQGU
 u5XyAMik
 ql+6S3GlglYwxR+xUKYV9fDhpzvasEB4Mv/n1w92A4uiBM3g9WRTpsU7mEe6eYafbPQOmVk5ZtAvpW4x0PFO97FkBEorRhYu91e798yweKIeRY1x5mXcxjS3mitQab691VyKgV+TgPmhStJoN4oDUjzb6bsD3f1K4j4yTyMPAzspJ5h9e+CpLd5nuM2CLCR3ljt8U/UOo9R+DcR545h1eCMzRNNKAQbo2LTT1AYdlqmwwQyNeFv1+wzz2xiN9yNaQqLUoV3m1E8QhQ084mqWjqJPWsv2MW2YMe+KBM9Zu9Hu3xIvCeUVFKuwYzaOFdqt6YXk/9Zvhs+F/OL6B1ZN1fTcZIfmRWows0YAV31cuwL+Kka8ASOyan401dH16TjTAXKMM9CRMU79g0V3mlckNVvUez6yMLAVx/7xgoJsUuUbFz0KaKkB7e68z6mwRt6yD0cIntisQn0dcwznGTJPcc8fjvD3PUeuQuRpqwkGNIPcAMcN2BWiZlE3DNizA0LsbXykSdTUtiwGTs8oMUvsU07hQ2lk8Zz3tVx76E3vALjiJZSkl9zcXEnEwS7gUOQBh8U9oEXbTjSTDTBjSDr7AyPWcMGHMPeIIUCjwfj35LWIPI0vLl/Soj9euv1EAPpYudJpQ68sQFoSXZxXlV+Jc3i0lQdSYV82nlGEMkxUqemyLjzIy8GacdnqJCPGICp8mKoA1Kx+vVC0U8n0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
Changes in v4:
- Split `atomic_per_byte_memcpy` out into its own patch (Boqun).
- Expand `atomic_per_byte_memcpy` documentation to explain the
  concurrent-safe semantics and to note that the kernel's `memcpy()`
  uses byte-wise atomic load/store instructions (Boqun).
- Clarify the src/dst asymmetry in the documentation of
  `Page::{read,write}_bytewise_atomic` (Boqun).
- Use the "valid for atomic {reads,writes}" shorthand in the safety
  lists of the new methods and of `atomic_per_byte_memcpy` (Benno).
- Drop the redundant data-race bullets that v3 added on
  `Page::{read,write}_raw` (Miguel).
- Link to v3: https://msgid.link/20260213-page-volatile-io-v3-1-d60487b04d40@kernel.org

Changes in v3:
- Update documentation adn safety requirements for `Page::{read,write}_bytewise_atomic`.
- Update safety comments in `Page::{read,write}_bytewise_atomic`.
- Call the correct copy function in `Page::{read,write}_bytewise_atomic`.
- Link to v2: https://msgid.link/20260212-page-volatile-io-v2-1-a36cb97d15c2@kernel.org

Changes in v2:
- Rewrite patch with byte-wise atomic operations as foundation of operation.
- Update subject and commit message.
- Link to v1: https://lore.kernel.org/r/20260130-page-volatile-io-v1-1-19f3d3e8f265@kernel.org

To: Will Deacon <will@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
To: Boqun Feng <boqun@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
To: Gary Guo <gary@garyguo.net>
To: Miguel Ojeda <ojeda@kernel.org>
To: Björn Roy Baron <bjorn3_gh@protonmail.com>
To: Benno Lossin <lossin@kernel.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
To: Trevor Gross <tmgross@umich.edu>
To: Danilo Krummrich <dakr@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>
Cc: linux-kernel@vger.kernel.org
Cc: rust-for-linux@vger.kernel.org
Cc: linux-mm@kvack.org

---
Andreas Hindborg (2):
      rust: sync: atomic: add atomic_per_byte_memcpy
      rust: page: add byte-wise atomic memory copy methods

 rust/kernel/page.rs        | 70 ++++++++++++++++++++++++++++++++++++++++++++++
 rust/kernel/sync/atomic.rs | 35 +++++++++++++++++++++++
 2 files changed, 105 insertions(+)
---
base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
change-id: 20260130-page-volatile-io-05ff595507d3

Best regards,
--  
Andreas Hindborg <a.hindborg@kernel.org>



