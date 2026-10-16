Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6D4CCCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 13:30:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75D926B009F; Fri, 16 Oct 2026 09:30:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 735426B00A0; Fri, 16 Oct 2026 09:30:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 624726B00A1; Fri, 16 Oct 2026 09:30:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 336646B009F
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 09:30:36 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3F016140409
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 13:30:35 +0000 (UTC)
X-FDA: 85328574030.13.CA1F93E
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4FFDE140011
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 13:30:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="hssWlCX/";
	spf=pass (imf23.hostedemail.com: domain of 39ybSagkKCOoMXUOQdkTXSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--aliceryhl.bounces.google.com designates 209.85.221.69 as permitted sender) smtp.mailfrom=39ybSagkKCOoMXUOQdkTXSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792157433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s8wT4GCcFRppH1S0zBu7HLXtWLx9V/jDPupw6jCnXnA=;
	b=oizCh30SLOu9TXyd/7s7iKhP9UNvsbguAuOqjx5dge7Okd9f1zTFF1Ad8gbcJ+Z3j17IA4
	2MM7vb5neRa+ODbwH956P/1hPNFQusM35cgVIpYHfXDrj1iSWMm6uRb6qN7Ax0CpjI/XYP
	LfQs4WeUoLTJEax2RA1+Iutb+3Aa2Ww=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792157433;
	b=N+6+/i3sC5pz0ga2wMDYteH2ZgMYMRqv2OFAb7TWdgPFtX/V7JFPdPTu3BBG6ncJBHk2B7
	6zkGBseSjUV+vvlzw11qLpE4s9cEXN7IQQyMZ/JEtkSifZlnVH6PIhml1TangObh4p50q/
	cBhylGnC/eP/gnmNLYrdJhVW5Tr+ftY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="hssWlCX/";
	spf=pass (imf23.hostedemail.com: domain of 39ybSagkKCOoMXUOQdkTXSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--aliceryhl.bounces.google.com designates 209.85.221.69 as permitted sender) smtp.mailfrom=39ybSagkKCOoMXUOQdkTXSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-48c4445512dso2384571f8f.2
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792157432; x=1792762232; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s8wT4GCcFRppH1S0zBu7HLXtWLx9V/jDPupw6jCnXnA=;
        b=hssWlCX/oMjyt8oH8b2LK1GlbDmwQ/4Xa0wD2kMDmJ++NY4PzwEnE2kCHrbk+0uQBJ
         BM+AgY8xcv5t9Ri46Rnt2X/Wf9ciGUBlnBb27ij99vh9iv/6yFumjqhp1v+sJkED6sEX
         xTrKzR/tK7ky4IG73vKOPRXdgL3PA1zsJa21yHzuIC2cEkslHITvL5pcw77xzZy7s+Js
         Yk8JlRVqFkhMaUH+XDNcx30CeNo4CB2sXbN5qGufZXvUe3vkxHUVPIbdFi5EHYNTNNRa
         QLm6Z9CLj7pYr5Kcjuv6us4MHkOaNmLv/8Q6bXWkvMva2emLHnn+VOVCpWMQPgrRGnwT
         SW5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792157432; x=1792762232;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s8wT4GCcFRppH1S0zBu7HLXtWLx9V/jDPupw6jCnXnA=;
        b=1Py98lpPytsIy9cxMMdbaUVJTbGZu0q2WHhOebIuVPSSVIJTzNprWJpN4kkFQjgOxs
         2q9GaIw2Zzyj1Nxfd0GMq+FZlJybfJJeGr7TCXJ8Uoj4CgVUJ6d3BTSLmHL1hlZObM5P
         Gj1IMWI+Uk7Ri5HidQ0FIcSQxZjUZsCUkFFK67ciW6YtwdY4UcdiFmi6+tUpAnuYP/qe
         RAzc2130IalJqYvb6eOC04j/cYrkifN0xkgPPwv+zlrSlpHjEAmdJAG/EoN03qSfaamb
         NoigGaeI4jVlryebO8Rp9wtPyggnfN815sFHtxfVxGvGa4LNv1aWInJwgPzGgfNqZ5p2
         RyIg==
X-Forwarded-Encrypted: i=1; AKwUvByCekZ89pmnMq4RACv5wHDaiBf6kUeifm560mO1AlIxZKSMY/GFStotS8viOUWeXvl+aHi6Imb+ZA==@kvack.org
X-Gm-Message-State: AFq9FYIYqMowO8kH+hK177cYfVqAgrIgP48OTeYfxC3XxOEBcTZxQgb6
	zHoHEFto67oGizg4EQNHy+xDh4BR4ZHSaBnxZ4qustTLxA02WQMKZYsE0AonW8IKWK4gmOcwOI1
	raBeo/jRxFooLGWHBbA==
X-Received: from wrbdw8.prod.google.com ([2002:a05:6000:dc8:b0:48a:f5c4:6e9])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5a08:0:b0:488:7b66:140c with SMTP id ffacd0b85a97d-48dbaae719amr32819816f8f.28.1792157431452;
 Fri, 16 Oct 2026 06:30:31 -0700 (PDT)
Date: Fri, 16 Oct 2026 13:30:17 +0000
In-Reply-To: <20261016-binder-memcg-v1-0-d659b8ae088b@google.com>
Mime-Version: 1.0
References: <20261016-binder-memcg-v1-0-d659b8ae088b@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=1798; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=qUrICa2fJYEZ0c4HlX4XWuz6lEudJa+Feo5dmOei8es=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBq0ibyWL2N2fGA3+Ni+RZIZOlpvage6FEJ+K0Eu
 6UZFAEbPuKJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCatIm8gAKCRAEWL7uWMY5
 RtinD/9ksgOmsOB7zF2RRAoNzyBkQ52Wl6+40EruO0uNuIhTxDs7XqrMPHmYQBfqXzOuTEneSSB
 LeCzrC5q8vAuub/SMASW5rAeIZk8LyLBq8/0+shRJiaNEZxGZjUPpGdwpb5LQYpZ5G/9LIlztFR
 IJ1+m+yQzdR7Cufaax4/rbTTWvsOQur3Gtz2bjDe8UsbaFXnmicKDY7h05IxpDpTSwlR33NqJr2
 ey8kRP1uem1ZCMpY8IgLFecU5tHGXZ8Sd8c5kTroR8O3gnOiaHQcZVZdY8xMh2zw2oY65YCLE8h
 ao/mEIh3AugucnX6paH91sCgCVy4QvIfYIxzxY0ip/7i0uYqvz7xOipWDCiJ+xAagjRRHbFVEW1
 9Fw4XgOkTOL1sICaLQzpwAIXSu9VNSLuyliuZJ37mlYGKhu1LiETkpPOU03WTYrd/d5FoJ1rA4E
 J+8a+sg170GvEjxD5gcT+nxWQkANZdId5HKNNel01ejw/0jF4tRTlAjYXFSXYEZ3Qs/AjANuuJo
 04LzhqmA4sQB/hE9QBaPScqWa5CEV0I+pZ7ec3YBAqH8B3bbj8yQenf9gfeo/jvhwVRpkBC17oc
 5Y4gtixK1RsRJiWfnHXRNIMeBrBKQYNMfdF63FH9yBMBtIPF1bJcasKmUUrSCbLnookn+xyzl0L fSj4M06e6kkhK3Q==
X-Mailer: b4 0.14.3
Message-ID: <20261016-binder-memcg-v1-2-d659b8ae088b@google.com>
Subject: [PATCH 2/2] rust_binder: charge allocated pages to memcg
From: Alice Ryhl <aliceryhl@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Carlos Llamas <cmllamas@google.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"T.J. Mercier" <tjmercier@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, 
	"=?utf-8?q?Onur_=C3=96zkan?=" <work@onurozkan.dev>, linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 4FFDE140011
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 6omrx8uhxfatjr7odk8x881e4e81wgrm
X-HE-Tag: 1792157433-495299
X-HE-Meta: U2FsdGVkX18+wDyovtqhRjCpmU69MzrwIOffo1sn3gIaTvyDajASP9rsFgKpCXnCwHJSLaMWP4TU9+fv2Wbs4utVmRnpVcXu4gsOQ0whKFgJgRPylNS9oywWGaouKmHzri8LzY24sq4OG4rpb6N6KnrHZiZNHSzue+JVC7ePrLKebF7BSKAN0IiloUvTloHJzMinalYhu30/M8FCmMr3Jd+nVvy0cKZ8mVpEc8XnYsY0qmGIwlgnuHgJ/7PMFZJS/NzXAsAsU5ghNA9K+UCrJatC3mMqYoaCwkjsBei3bFsgst3S5uHfh5GROaiu3YbuRmtx372JxshqqDNwJooEYSRG9OOU97tAExQquW8nnf19t/VhuKpcqBGvPwti2oR6MnGVLQXPC4Ak74VG9wDNtG2xgWhAl0DhpvLFFd+Og07Yjc2i9AYkY3IyS1P94tszFURcpMMW6OSC4EvU4/XwDw3bfHCJ9RZscIMzVoL7oXfxEhJuWH7I05NNQFMuHhSW6s6AVDc++Wg/gUdEMa65XrQicyFPetrrrdrCTy0ZocJbulnrY6NO6nC+2h82SkD25BuSj5wWlrKUZYEBKmoBK1ZHKItiasVDRJZEbJv0LoC2bg75+AnTEsPVEqU15VOuJU7Fq4Pz4bQQ/fEo2eJE06EGLrKLVI3KlLuk9GzjvSbvrY9AT3NO1f7jtgjnYfRiZLsgstR47OZqYWsJMVY/4UJZSfoClrAI7XSGsR/e4XnWAVCd+VM9vD81zAEaSa4Gt2PmqjqKHqSi59Rwb3eGvhsOaByT3PJwo/EgSNzgyq9h+35Fqa8D/T5g6Ls8CQjnBJGJbPMKAG6pq89ZUbr7J/8HLF6MOGQapp8EFGMWwvizUCXpE203BLAAzn2LfWYBivc55Dm7WIWUYjQI2gYj0bH1iFLDt97CK1yXYs5zHhrAZTQk865WVhn3EYLOPfqhKO6a0FzCWOy2icjUOCq
 KXCexsxI
 P4Rk26hc8pIf5QwTTwhLhZSJhk061xej0ZEBodaBcZwNK/7be0ioJShO/eB9OjIof4+RvEkXRLO6kE02kH0bZ44xX5+WBsHkvKuog1iaNS0kAMu3QSC2XZE4GHdpZ2fSParembCPa4OhTXLGTQ1Y1Sbk525ElNHwlyYcnDgynQPgVlW5SuIonVnkCuBNcOEJQd2gKu6rKFo9AtkctNysnN5M58hksVyUuUePVPTaw156fnZzEQ1DXDKnFTg2X1zT6TLCNGyzl9dzPA3ebNdhyCnB/woWeukGjuMM/8QZEa9AvA6vYNgmHCFzM58I9ixYoATIsApjLFEswexx14ofxN54SQwaTIJZiuQN4L+TmFLIpDjC90dsChPUwmNc5YCtIC5OhokueBOz1sUU4IE7Ydr3jbC4AIxG4jCYTaqeIUFZYw/rZmMYb2SJW726PfI7xir7rBrp2rySsHOy97QORIty68urvvy/8xvcomEnhxgtFzg2UwmE/gbowIuqnQFcEH7mkKkoNG+3EmNlM/VtiufXtav5WprsA/1L5k15froOG6I5vEIM7NfYBVPD+2BDPLP5b8lEkwRqBg2CpInKK4KnOoTEYqvALaDadHyTRqQtSieNyD1wEPDwRYRBCNOpYUdSbZVDrcRQl1S8zcm/DQ2R38Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pages allocated for a binder VMA are currently not charged to any memory
cgroup. Thus, use `Page::alloc_page_memcg()` to charge them to the
owning process's `mm_struct`.

Suggested-by: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 drivers/android/binder/page_range.rs | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/android/binder/page_range.rs b/drivers/android/binder/page_range.rs
index 52ffbf3504e7..57da47243967 100644
--- a/drivers/android/binder/page_range.rs
+++ b/drivers/android/binder/page_range.rs
@@ -27,7 +27,7 @@
     ffi::{c_ulong, c_void},
     mm::{virt, Mm, MmWithUser},
     new_mutex, new_spinlock,
-    page::{Page, PAGE_SHIFT, PAGE_SIZE},
+    page::{MemcgAllocError, Page, PAGE_SHIFT, PAGE_SIZE},
     prelude::*,
     str::CStr,
     sync::{aref::ARef, Mutex, SpinLock},
@@ -399,7 +399,16 @@ pub(crate) fn use_range(&self, start: usize, end: usize) -> Result<()> {
     /// Assumes that `i` is in bounds.
     #[cold]
     unsafe fn use_page_slow(&self, i: usize) -> Result<()> {
-        let new_page = Page::alloc_page(GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO)?;
+        let new_page = Page::alloc_page_memcg(GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO, &self.mm)
+            .inspect_err(|err| {
+                if *err == MemcgAllocError::Memcg {
+                    binder_debug!(
+                        FailedTransaction,
+                        "page allocation for message to {} was blocked by memory cgroup limits",
+                        self.pid,
+                    );
+                }
+            })?;
 
         let mm_mutex = self.mm_lock.lock();
         let inner = self.lock.lock();

-- 
2.56.0.212.g129ede20d9-goog


