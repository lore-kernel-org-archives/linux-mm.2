Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CAF0CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 23:02:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29F8C8E0007; Wed,  5 Nov 2025 18:02:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2548F8E0002; Wed,  5 Nov 2025 18:02:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 117E88E0007; Wed,  5 Nov 2025 18:02:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E36678E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 18:02:30 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9158FB9D39
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 23:02:30 +0000 (UTC)
X-FDA: 84078079260.16.5A2E7D2
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf04.hostedemail.com (Postfix) with ESMTP id 865654001F
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 23:02:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FIhXQTxQ;
	spf=pass (imf04.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762383748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WwAIlG6TTHwluLnC19ePK0hNp9oFcPVSx2rVuCQMRhQ=;
	b=7mPTe3RWF4LOZapB4zVxaiCAQY6QunPw1VxwEMYTWhbtQLCevLS8JCEVFIf6YYMdwa4AYp
	7ccXZgNldsR7+EzL/qCYJiPDN1dH9O+8tv59/MZzcHUBicNVUjx9/DgY4aGsMQ+vqwkWTM
	VW/NXq+s21iJeHGXK248OGt3Uz6Okk8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762383748; a=rsa-sha256;
	cv=none;
	b=UHXW8EbO5CST+mrKJPMwmJ3D+GdiCn9OsQ3434ldAXRsPTjqn5n4qv8V4Sgz18K4lb4Tqc
	zOcho6OyPJOZeodnJxf6GGQmtcxV8I7pyFAQx5EEsxjWXwhtqZXI8Gk9IVYYHq/XBGckBl
	WnIiXVseCo2sebThVyF3aj5G4m+W4hw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FIhXQTxQ;
	spf=pass (imf04.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2958db8ae4fso3308135ad.2
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 15:02:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762383747; x=1762988547; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WwAIlG6TTHwluLnC19ePK0hNp9oFcPVSx2rVuCQMRhQ=;
        b=FIhXQTxQzmZ5nnnZGJrOvGHpZPCxxWF3pM4fyjH+sW9mUBI9H+XCLyEjMCH/Hl6qTr
         ycWWFWHw+we6zMYdBwWOKb6zInnVHLxn5Gm5LNAeW5DjLDDu1HQvjehDf1F4JVnpQhev
         8ysWiUf6945PQlmwDtN6DlIP/OD8BXxZ2fAANDP6iZ0NgYul2v6XRb99OYoII61TySB2
         zld4B4/LvxvV70y7jcVueHa5q3UjZsAIPGoWUXaFKOHTaxmG9IwREA4mw8N5GB2cSdzC
         ZXtoKTWqErBgXrg0sy+QO5xiSqDnec0zFzNQsTj35yRzB03+JiL4rMQ1lBcfQKJeb7fi
         4few==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762383747; x=1762988547;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WwAIlG6TTHwluLnC19ePK0hNp9oFcPVSx2rVuCQMRhQ=;
        b=wt5PTxSGXUEO7RLVeY4WGBNEJvqMXekHviYUAVHswJT8/mtYEwftJ1F5LQiXKpNBzH
         AfrZ15K76HAKiUIwRhhMC49ciZ/F1boyYHvs8vHJZjmclTBIko2/13/EsDOaNhgzIUdo
         9b5AOrKwnQGNIcB6E+hI3zKMRiOr81/NQo7jnm7Rc7eYpSyKA7PEszsYAwQKe4U0d40q
         L8JE9knudUn7FuxvwvLaekQCxbSHcNYc+JvAjbCv4LT1yEhSTZQnQC+5mKSWULtPkbXA
         GxqUn3qjP4oITckHbTayQCYBSE2JNMOFlMrTFaZVn8Kt6xuKQklrIwLg14HMlPzLrC+2
         IAsw==
X-Forwarded-Encrypted: i=1; AJvYcCWPnz5JQyIZ9x7TQYRr8NdPEP0k3Ko7GKGiGuhq7bpgus62aZs3SweUVpEtJIapLyCe7y2Reyh2Gw==@kvack.org
X-Gm-Message-State: AOJu0YxTqD2hz4AEpsZCuWytgac1X7P4RWiIn6qqtuyCYnbzM2Z4MMu2
	5t20Lq5m5N98HB4mqfQqsSHt/rtlelVzvC+i21qUctGi7ihAg46CcjEw
X-Gm-Gg: ASbGncvkg+KZfzn3sdfnL9JJLv3F3q7vfGZOFFVvc/nVXfYiFMx318LVGWT4t6TuRwW
	WP+eYAC571CfbtSCGTplch/UiOI1GTmGXOYBxywd97DIK87W+x4WiV8EKOImXkxTJoZIsuB99wW
	PNIGEJkb/+d5UYnxtw8pMyT60uxYNfoMjUUSswnIaZNrxay9ZO7DFBh6dgY/Zc8f9bVIMQX3MIj
	Ks2PJcvgsyZOSTdel57+qu11mijvbJ67D+72uE5Zq2A4IzDCEvqAcdDgssaFCIVPQq5VI1Hd+zj
	mBnj+KW5UW5r0HvgEiRTYN8Rt2pa7dYuNZuXN3rcbaKlBn60ggY0Wmk3DLHPGIcU7mU8XYMjGyI
	wVz9rWEbzQXnSdXyLjGTtTL/oNBHt509vaB3XYbJ2ihKfbNYSe75JGKp1sToiij3YUNjX3xa1zq
	4S6H4zPpkUqznquSxy5CxtwoY=
X-Google-Smtp-Source: AGHT+IE331S/e6OJPAmtF3ZjSt+Kn7kDN7/mWSvZsNxV7o3ouRhjWuYNtynxsbk6GSGpD8SmdbjGKQ==
X-Received: by 2002:a17:902:c401:b0:295:5da6:6014 with SMTP id d9443c01a7336-2962ad2ae93mr63812035ad.22.1762383747306;
        Wed, 05 Nov 2025 15:02:27 -0800 (PST)
Received: from mitchelllevy.localdomain ([131.107.147.147])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2965096839asm6325645ad.13.2025.11.05.15.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 15:02:26 -0800 (PST)
From: Mitchell Levy <levymitchell0@gmail.com>
Date: Wed, 05 Nov 2025 15:01:13 -0800
Subject: [PATCH v4 1/9] rust: cpumask: Add a `Cpumask` iterator
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251105-rust-percpu-v4-1-984b1470adcb@gmail.com>
References: <20251105-rust-percpu-v4-0-984b1470adcb@gmail.com>
In-Reply-To: <20251105-rust-percpu-v4-0-984b1470adcb@gmail.com>
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Andrew Morton <akpm@linux-foundation.org>, 
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
 Christoph Lameter <cl@linux.com>, Danilo Krummrich <dakr@kernel.org>, 
 Benno Lossin <lossin@kernel.org>, Yury Norov <yury.norov@gmail.com>, 
 Viresh Kumar <viresh.kumar@linaro.org>
Cc: Tyler Hicks <code@tyhicks.com>, Allen Pais <apais@linux.microsoft.com>, 
 linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-mm@kvack.org, Mitchell Levy <levymitchell0@gmail.com>
X-Mailer: b4 0.14.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1762383744; l=2630;
 i=levymitchell0@gmail.com; s=20240719; h=from:subject:message-id;
 bh=O+TJ1giWcgX8q8AVGe652HR0hPyTAH9TmZB/EtY9dHk=;
 b=8IczBPVeTYnGGmDoLSMEmJlu5vzuoGi7eS1E9YY+hxeS+rAglAWrTxtFqNGLBBFPmAYcnTMTJ
 x4pMKIkcfTyAX8RTADOq/K1QFRETacSNE1KN9TEQp5gLyy/1NwS76JQ
X-Developer-Key: i=levymitchell0@gmail.com; a=ed25519;
 pk=n6kBmUnb+UNmjVkTnDwrLwTJAEKUfs2e8E+MFPZI93E=
X-Stat-Signature: 47h5mgu37zpjszwo7px4t95dwuodfo41
X-Rspam-User: 
X-Rspamd-Queue-Id: 865654001F
X-Rspamd-Server: rspam01
X-HE-Tag: 1762383748-561992
X-HE-Meta: U2FsdGVkX1+D0e6XeNlswoDpzlmbTuVFzQAwVKbiPkKae00NTOvNJ4TTKTbYtuplvm/XKZbcC2p6HLX6nkXjbDZ8yQGbura2gkwCs4qxLyQwDIdRG1amaLjFc1F97z/9cAjtgO/ooYB5Wr+dLGxMC44UJ55mwUExpKPTLvNN530zABTHRA7f4jMtDcepzsD9WzKy5WL5YA+lNXfSCIYrk4tIctC7XiNguIyd1jeV36xQPYHGBIFtbkLDCUb92YBaQYLiQtVQsOO3ZcHfjYVRw0RVAfIRebeSLZJZB1Q9aWY41Bf3thrLqT+bCvzAXncWjInAcASMtOz3izhnCGhdipHV2Ixdkht71UZSyovovhfp7uKQmrQVd42kj1rRoNVg6riUWMfU36U4TvmSYg0QDMDbs0t4wJ+UUGVmI1ByANvOkxXyFFlqkf/CwPP8MwwSHMzUMEzCbDqi8khGI0wM6Bvc6hH0QO7w96z00CHNL1YL7qAcqrdxpvZLGrA6jLDjIXOW5K1oAAg40UPkzCOiTyhjoHdvyrS9mOiSqrP5pjGJTUQRVF+Hlral+IMEvz8IjvBB+XQweC29ReBT2ZxOmU67pRr0GWMkzegFWhrswUthiHnnOqZVa6n8t1rABLY6sxvCmEFnd8/xV1PaH1MEu//wfBp8S7oIu2/oRgH3JwALGnKK6S/Mv6F2cbUNyDvO1x97vuEA4+P+KfeTYn7xjzkxXpgz3QTmX2g8ykuDTAnxMY6rxug8lZu1gIv+0LowXZjwn9tyU6HG7pQsp3LAWCG4qiNfygANFJRRBWOupohA6ac4fLkHIR/zl3J2Wmw0IafbqwYEqUE2OM2cPDn5AvDfZ8t7Iv1JtfE4+7MXGHtzJqpAiMEl5CA5KVw9Ba8+2LvlG0NdaS/TU1VyNs7nerO0rKsGoB6EkdUpwZU2DgS2KytCtwlESr61XWyfjlHxth+567tZ4t1nDFJ8NbE
 M9aSKsuv
 Y3pVW54LJxw/gPH1qKtK73duqUhDUpgW7uuw58nh1SFzelES8Rz70jMak0QnAgvv5khLf/KbJ48VDsK5SyJ40jjQ4qIGfmcRLdmJ4T+3lWtM3HjCLZalxWWnXQAmzbD437Em/q3YozoJTCkcbPvJoSA2LJG9h0kS9jOYLC+y9lC7rEdfJ+KMXyT/hDckLnIWZ1MtqhqzBeReighiEKOY4cRZk8dcBRYj6Pb9rYzOmUCY0/SmU4NViRulAowojxMBX7+6jtt+R3W+JbcuQLcSAqbDYYcAyL1DCfmvzt/t3HRnwnTJQUNBNshSnZ1ifBAmynheVxXmZ/YjyP74viWo2ze+xXTUYndoxpfDd8q8HkpW4+rW68iJ3VQZroaFNMe7THTUb/ik4niq/vuSgqG5pf6jZ+LjXE5rvpW57H17Ldv2mDACFsRkruP2NO0Xwsqu9vom/VqFRIhJwwn82ulX7PLV+BMwG3NAPnKF0wTv8K2kxOtbXJVaPXcwIjihK1Ne0XvuTauOlrTRU9R6tsFDn96CXjNm2samCLmDaJEg3QomoHBnvXvdmzTXWBUfmh261ggKbVN71CIXoc5sJoca9+Tr6VA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an iterator for `Cpumask` making use of C's `cpumask_next`.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>
---
 rust/helpers/cpumask.c |  5 +++++
 rust/kernel/cpumask.rs | 48 +++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/rust/helpers/cpumask.c b/rust/helpers/cpumask.c
index eb10598a0242..d95bfa111191 100644
--- a/rust/helpers/cpumask.c
+++ b/rust/helpers/cpumask.c
@@ -42,6 +42,11 @@ bool rust_helper_cpumask_full(struct cpumask *srcp)
 	return cpumask_full(srcp);
 }
 
+unsigned int rust_helper_cpumask_next(int n, struct cpumask *srcp)
+{
+	return cpumask_next(n, srcp);
+}
+
 unsigned int rust_helper_cpumask_weight(struct cpumask *srcp)
 {
 	return cpumask_weight(srcp);
diff --git a/rust/kernel/cpumask.rs b/rust/kernel/cpumask.rs
index 3fcbff438670..b7401848f59e 100644
--- a/rust/kernel/cpumask.rs
+++ b/rust/kernel/cpumask.rs
@@ -6,7 +6,7 @@
 
 use crate::{
     alloc::{AllocError, Flags},
-    cpu::CpuId,
+    cpu::{self, CpuId},
     prelude::*,
     types::Opaque,
 };
@@ -161,6 +161,52 @@ pub fn copy(&self, dstp: &mut Self) {
     }
 }
 
+/// Iterator for a `Cpumask`.
+pub struct CpumaskIter<'a> {
+    mask: &'a Cpumask,
+    last: Option<u32>,
+}
+
+impl<'a> CpumaskIter<'a> {
+    /// Creates a new `CpumaskIter` for the given `Cpumask`.
+    fn new(mask: &'a Cpumask) -> CpumaskIter<'a> {
+        Self { mask, last: None }
+    }
+}
+
+impl<'a> Iterator for CpumaskIter<'a> {
+    type Item = CpuId;
+
+    fn next(&mut self) -> Option<Self::Item> {
+        // SAFETY: By the type invariant, `self.mask.as_raw` is a `struct cpumask *`.
+        let next = unsafe {
+            bindings::cpumask_next(
+                if let Some(last) = self.last {
+                    last.try_into().unwrap()
+                } else {
+                    -1
+                },
+                self.mask.as_raw(),
+            )
+        };
+
+        if next == cpu::nr_cpu_ids() {
+            None
+        } else {
+            self.last = Some(next);
+            // SAFETY: `cpumask_next` returns either `nr_cpu_ids` or a valid CPU ID.
+            unsafe { Some(CpuId::from_u32_unchecked(next)) }
+        }
+    }
+}
+
+impl Cpumask {
+    /// Returns an iterator over the set bits in the cpumask.
+    pub fn iter(&self) -> CpumaskIter<'_> {
+        CpumaskIter::new(self)
+    }
+}
+
 /// A CPU Mask pointer.
 ///
 /// Rust abstraction for the C `struct cpumask_var_t`.

-- 
2.34.1


