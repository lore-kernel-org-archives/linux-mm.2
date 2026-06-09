Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D48CCD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:15:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5D136B00F7; Tue,  9 Jun 2026 15:15:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E351A6B00F9; Tue,  9 Jun 2026 15:15:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4AC16B00FA; Tue,  9 Jun 2026 15:15:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C3C6E6B00F7
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:15:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 907851C2824
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:15:18 +0000 (UTC)
X-FDA: 84861327516.18.D05E277
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id C0244180014
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:15:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ggWIxrcj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zKR6MXUHWDbRDFl3ImkDVNtbroS5Q/HyfNFCf+FwxNM=;
	b=KpCfjtYYzC+79zPyEdjEKEJj1tD3X+aL2WcfMDEHC/k/C8DodN1qxY7s++XW84iKtIDa/i
	Rw5zLvpUpjy/cC9RMTi1jMAdcuuhdQEfCOK/MIdPpam5bWj6245DGVt3s+244KEr13kPbS
	UigTH+iTr2g3U6DML3HluA85W/YSMdA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ggWIxrcj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032516;
	b=F3PxtHvHF5pF4Gr8o6Cavm5RSYOgL0bEc5V0XkZMjTLOjgkIEpoKDN+D9fH6uAdozEg1it
	wt4pE3LHgqF8v0TWfuWHE1FDD8JZ/hogNMdZNX0iWsqTK6Q4CNqv5DSAyaVU/CzIGlfPxM
	70U6PQ8n1ulpL+rgCyBVmvcJCkk622c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F81F6024D;
	Tue,  9 Jun 2026 19:15:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89F21F00899;
	Tue,  9 Jun 2026 19:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032516;
	bh=zKR6MXUHWDbRDFl3ImkDVNtbroS5Q/HyfNFCf+FwxNM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ggWIxrcjs4A43SLr4s3hdHt917/ecfOv5m8cp9wSvjzF3JoBFOTJjldDMjroXwZ3i
	 bcahTsZaHnpTB4FjNrTNOcxc4P3jrUQOT3nBLICKS25EdvNdDsPaV0Ny0LfZ9RTPKI
	 WuRlLJ8Jr0lhaJBGabII72L6YC/k6hmX8MmumqGxjgPCqpAqK6EjcRSn3x3Dzy4EMs
	 Z42iSrbZQqAaJqJ/mvHM7BAoBKnkpOVW++PQ2L6tJfTFud3OTOtQr21jP6mASeFpk4
	 vqmPlRCGToJQSUCQoDS502fwI7NztczrgB3wvuHanA1ppG3ZvmLj5XxVShp1riWTWe
	 bqOizZ2xFh9bw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:19 +0200
Subject: [PATCH v2 40/83] block: rust: add a method to get the request
 queue for a request
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-40-82c7404542e2@kernel.org>
References: <20260609-rnull-v6-19-rc5-send-v2-0-82c7404542e2@kernel.org>
In-Reply-To: <20260609-rnull-v6-19-rc5-send-v2-0-82c7404542e2@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>, 
 Alice Ryhl <aliceryhl@google.com>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 Benno Lossin <lossin@kernel.org>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Boqun Feng <boqun@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 FUJITA Tomonori <fujita.tomonori@gmail.com>, 
 Frederic Weisbecker <frederic@kernel.org>, Gary Guo <gary@garyguo.net>, 
 Jens Axboe <axboe@kernel.dk>, John Stultz <jstultz@google.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Lyude Paul <lyude@redhat.com>, 
 Miguel Ojeda <ojeda@kernel.org>, Stephen Boyd <sboyd@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
 "Liam R. Howlett" <liam@infradead.org>, Boqun Feng <boqun@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 rust-for-linux@vger.kernel.org
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1181; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=xXqJf7F04NCf34hZ6dXAld8MDblLWnRBzQzNDZIowmk=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTYKpj79Bj8kwYs3EbPRsKivGoKybBXNZCRR
 xXW9AqPvSSJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk2AAKCRD6UCkIqsW9
 0OcBEACoS6o6SVWxtT7ZyVgvB7JIj4BBlPg28VWTaXBFnfHlyKAgn1i0oqQ16TElCSKGc+Puqpc
 NnZdm712Ow2whWUmmGO5Nw2NeFcpJtejoAzJYqy8igr4mIL+wHmRtVYyLmCmUralCpN5yPb9XF9
 KmqkynCMpexMbGVmDRglQzv/9Q/d80FO7N6TlYcds68fLYxUSF0zOHR/KrH1rybJTcOtsTIQwmt
 QEMhL1nZEWdBxGK/xsG8RAfHSDqgdlvlgwZvGQLi+X6BjWYsuMbezvOeLw/jNB8sccYddF4o61Z
 zol2JdhWi4f0QD36nLqujap2uKiK0P4CjTU8U4EgxbyS7TJ8Kkflbg1RI3UbP3xO/VHYNuJq5gk
 ry3kS9L3CuhrYH3vBH9qznVjsvZfL7C9k+WuqF/TIpMKuAGltj1wz6BHXpMIp0W30phm+0yFYyT
 j7NfXKf0V0X7a/TiGXhM+HMCgj2kvSWeuFgqpzCvncumdPgNhatqZXURov/OWOx80hbVw6nnxVO
 QawPayOekOTnzzMDbIknfPLXOTuw4zvoHkgSvWpaVpotOSNV2bgUxv/QbO7+c5OkMZV1oXuHrMa
 Z+a8e5+mEofXCEblsREqhZ0nbAKv7U3y8IK8rsVVchi4UHWqvuov2dTiYVJYjd7oZQZE8BvveCJ
 MTSOmiL8Nhitrgg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: cdgirrwetdzi9ikbsso5nurs6ouo4obr
X-Rspamd-Queue-Id: C0244180014
X-HE-Tag: 1781032516-426173
X-HE-Meta: U2FsdGVkX1+7GHGRweCDwmrPCSW8aA5KyrAwRyc/VmISrIwQtBdyf3OHvuxAQiV86+vHvc0CglxIBt2L6hzPpWBJFf9EmW+ZcjCZkMFxY2GS/m2BUXpwVvUuORQwGgM4YekGbEyE61d6dKzql2vHaW10U+/XBvxv+mzyOTs9q6X+94B7I4+i1JOI0wV+8JTwdTIuzD5cl95Uazzxsi42DyGuXUqDBmQDcVEtFw3BL9i/oRpa4Yq9xnTCi+NeXPYZyMHpMvjDdBN5mC6outcopcSUE0aL/ydKPp7/LwsOenZc38FRx4VBGleVPsoTR4oDVgA07tRxeypnOSjTt1JkcsI3Zdf3QJQvYyQp9AseORywZuJ2wj5XoRpg+49yxgENtqKEKTgbry9R83Bac3XQtUGNZwfTROa8tJLG8VTql+LHQL6EG+40qW+F11dE4IVscda4UzDS1GDoxXZktSjx0aqfvTtgYcPvhDKY7pLc1hEkLZgQto2QbRxiMqn0Tz80RK6wX3POGi8B2QFGk3udr3CRzKgS2mBR05SXttmqdKI3q2zjA4ORo1kfAcXogWlWJgDCMotwioX+x8e3SUCwJFoMuFboqU5Tz5RHK2i9kjJz24BRLub+5ZFMbcIViGWORHpdCI9165fmnQK8E8ySlwXArAIHvxDvzNhBeUzLnQJXQukG4xatBsHsZy5ldfgXcu9KS3juX/BkStwrnHQxngrZTjcw/mfpjoAO/+suQDAL3Hf8ZeAZPxg6ZJBJImbvdFcv6Sq7etWVJ0mDE8Wl87aleY+ShIwnAPAwC76AMSZouD6iJTgYc2ScC0A82hpGVQDhS+RfEo0iHQL+gl/DZ/uyAn0mKyfab5qpBtqh0AzW63uKJpjjEsnatS2KAowkTjYGAQw0ILVDysyPxuv5++xuUlU8ozEKDFm1SdF29NPFyYPxmCJFMLv4brVE2h95MYT+xAGJhufOzKw+QrG
 E+yfjDYj
 JJUZMT7MDlh/68iJfpeidXKrG9gM8Zi7z6QTMzF/8mA3r1F7TtPp8lPd1un+5R9FM04YXxTlJCvAKEwp5q2E8eADi5+MT3NCbvScST1HHEb8XH29EToqPuCEDGxDCkChh2Dzh0+mhEyoKyFLR11oqixCY59Kr7ymFiUfUFA8pvIK0crWEAxO48IQIWTP/pFvwzNhHeIegIVLJeuRTc2D0LGlMuXsvBIloJBGBYShcLgHBKHjZXQ8J3Sz6NOObuhXjh38PwsDsFN5KA+o2UlBinpvuDZTLclGfwOHDkp5C9ghNdLNjJeVGSI2ihkPD77ODFldNrlVukJXnk6FPH4TnD0VEH2hYTjrVwOIU
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
index f94e9c2181d0..a05df2351c2c 100644
--- a/rust/kernel/block/mq/request.rs
+++ b/rust/kernel/block/mq/request.rs
@@ -39,6 +39,7 @@
     ptr::NonNull, //
 };
 
+use super::RequestQueue;
 use crate::block::bio::{
     Bio,
     BioIterator, //
@@ -140,6 +141,12 @@ pub fn queue_data(&self) -> <T::QueueData as ForeignOwnable>::Borrowed<'_> {
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



