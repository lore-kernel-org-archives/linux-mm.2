Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BEF6CA0FF7
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 19:01:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 909F08E0030; Thu, 28 Aug 2025 15:01:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 893BF8E0024; Thu, 28 Aug 2025 15:01:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70D4E8E0030; Thu, 28 Aug 2025 15:01:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 502828E0024
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 15:01:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20CE7C0391
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 19:01:01 +0000 (UTC)
X-FDA: 83827083522.30.F967BB0
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id 27DE71C0010
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 19:00:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=na1+kJlL;
	spf=pass (imf21.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756407659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kuV95K9JyY8TZOXbZAHoweF1aWF6QJFXwWOQdj7kvnY=;
	b=LR3twE2HMPzG4CD+WTj+jg1c4H6uNiJ0pj+7Kdw+nPMS7CS5Xjy2u0u7nhTLyjSq/DKFM7
	dqlmuN9r+jhMuiTiPY2PZMuUqyjXxJIb4/pxndUjwDdvn+ytrzK4GmdPDgG5JFb5TmpjFp
	jP4nB2u2g9UScapjnYh2+xoXcNVw39E=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=na1+kJlL;
	spf=pass (imf21.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756407659; a=rsa-sha256;
	cv=none;
	b=YiRQuopeOj+FZHsJ6ka8IstWpS9x1DLr7sIVhrqD61BsTPV76sk++c2hxGAfo7i70YxzRw
	pXKcawW61PMQy6PBmk+GDyx9jwPO6jUCX8uXuyGqJ/FYbytIRA087id2/TO420KZeNmrx3
	x/XZhN/f55dekyZzeNOy87ChQmKgeQ0=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-327b657924dso794153a91.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756407658; x=1757012458; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kuV95K9JyY8TZOXbZAHoweF1aWF6QJFXwWOQdj7kvnY=;
        b=na1+kJlLqiGM2lAZL2ai5WQWKVae6Jb8QNqCNhvobuTWt1HovB0Tk76Uz9QUyH0MnO
         CFjyemS7LzQxi62PO38DmKVBs1L+lVuS1PkcauW+h2tBwunrUJ61ysN4NRu72z5Tg79k
         tS08Aw3G+QZ/TpQyeKqI8zQNfGlZXU7uuk8GpelwbwFQfVfF7+IjAbjZfr2fPwNbZiJn
         4/JGUK9rUowJPFpbDi/UGKT3hESqtF0d9K4Q8pTQ4uZ7lCGyUCAt/8GPN6k4vq25Sg2F
         ggImmULsEWXJsIezWFlhcRfwM8DNznqwi85bFU7dKuz8ctyJW1/OwpBMZdb65WBG6QZL
         0nJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756407658; x=1757012458;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kuV95K9JyY8TZOXbZAHoweF1aWF6QJFXwWOQdj7kvnY=;
        b=cZseTXz2p2AjnEtmJ+nUB4kzELGNsEws7oERjh/wXRRy+uSGpVFEW6U+LywBHVzI9l
         Es2FsdDwbASQlK8FuAv/u8R//Qu2770kQf3fhR1IGv5z7pxKnyAq9gyjjUuRM/kPm7TC
         DYIKSA4HNbfFvRm8AL5kGkmk31mG09qqFdUjGE8z+ugw60qxvoATBE9IJ4aA67E/DrbK
         yzoPJx62IQESqtXhFL0coL6A8QzKYrxKkHnVmQK1w2R2dPdx4Nzaku9PbFQ7wjoXsD2x
         wd2Dvplj5fYGZbPYrx/5Bs2lv2yXpYHx9+wctvSi4qvw70TwnZ2B+5RZgu4iQmsofMAZ
         Wprg==
X-Forwarded-Encrypted: i=1; AJvYcCVYY6v/rTuolxpw442lTLC5/e10RqI1GJ7DYuQrzlG3uKxkVd9CHMigOWiz3MViLKjR/frDOFvXrA==@kvack.org
X-Gm-Message-State: AOJu0YzSBNjQE+Rv+3IVWbmxYCj/mC8RKDJzuLD3TqqRSjLAx/LpbRng
	pJl9JXAr9lBLgwvR3XggKcb3MA9vpxiBSu1G13ZBHztdrdXta0CLGFuF
X-Gm-Gg: ASbGnctmSDPCrxupJEMkpfpBZb/OSXtSHlgXRQ1uLP5OBWpSGyrZmiUGr8aPtJWBGnl
	rwW0NT7sgZsGdF2kKXqknDK7UL5MjcIHPm0VlS2UmJBnjA0sdfr/C0RUW763m/XWXE5cO3rcvQ7
	NvQ9p245YU4jD0/i2RfVrHN4mCwRJeZ8Z/K154VzoZ/XbEeW4pyw3BC/wx2f+V2oU1fIwG53hUY
	XpRWZ+QoWpt8fNdMtfeLPauJZ6UkuyHV5zLn5vhGKTiDayK/bhE9U1Ro3mYA6XFrWnRrd3Lfpd+
	0+FLAaguvLGOpvkL7D+oqx3bj02IufYQpp5mt47X1qIPeRWRSt+H8gTthzCPZQP+mfZ173+5Tka
	zsMocSmjk/qXk1WRqDQisiRABFVkVpp6ZryLDl3Pvnv1eyg==
X-Google-Smtp-Source: AGHT+IHmhZQt+LgvfoXPy01Ao1mL5xCYpm5wePCqKk17/kEIhhYnOE66ySAPA1ychd2bemd1EStE9g==
X-Received: by 2002:a17:90b:2648:b0:327:83e1:5bf with SMTP id 98e67ed59e1d1-32783e10b79mr7615856a91.28.1756407657841;
        Thu, 28 Aug 2025 12:00:57 -0700 (PDT)
Received: from mitchelllevy.localdomain ([174.127.224.194])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-327da8e5ad5sm405729a91.18.2025.08.28.12.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 12:00:56 -0700 (PDT)
From: Mitchell Levy <levymitchell0@gmail.com>
Date: Thu, 28 Aug 2025 12:00:10 -0700
Subject: [PATCH v3 3/7] rust: cpumask: Add a `Cpumask` iterator
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250828-rust-percpu-v3-3-4dd92e1e7904@gmail.com>
References: <20250828-rust-percpu-v3-0-4dd92e1e7904@gmail.com>
In-Reply-To: <20250828-rust-percpu-v3-0-4dd92e1e7904@gmail.com>
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Andrew Morton <akpm@linux-foundation.org>, 
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
 Christoph Lameter <cl@linux.com>, Danilo Krummrich <dakr@kernel.org>, 
 Benno Lossin <lossin@kernel.org>, Yury Norov <yury.norov@gmail.com>, 
 Viresh Kumar <viresh.kumar@linaro.org>
Cc: Tyler Hicks <code@tyhicks.com>, linux-kernel@vger.kernel.org, 
 rust-for-linux@vger.kernel.org, linux-mm@kvack.org, 
 Mitchell Levy <levymitchell0@gmail.com>
X-Mailer: b4 0.14.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1756407651; l=2580;
 i=levymitchell0@gmail.com; s=20240719; h=from:subject:message-id;
 bh=OtpCqlB9e1zWex8jQODuqGl1cz5sc9yZWh45+Mzno2g=;
 b=Q2FpQBwE86VcGQRhHVGrqBBJHXeoNsMFqG0rXzfh0HY7/r2ixF2OqX8DlbwQU04IWLevtgaFs
 K718VADFXt1CjEvHDLa8XOH/wgma/rXuoAzd1eGF+iseEpYpZNWDfXJ
X-Developer-Key: i=levymitchell0@gmail.com; a=ed25519;
 pk=n6kBmUnb+UNmjVkTnDwrLwTJAEKUfs2e8E+MFPZI93E=
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 27DE71C0010
X-Stat-Signature: rskoeh6tfbp87rnhg4nkdejjouujc77a
X-Rspam-User: 
X-HE-Tag: 1756407658-725258
X-HE-Meta: U2FsdGVkX1+vCi7ydwZ1ObRlZ0IUerdFOGSiML1qKKVogWsp/lIK1WGiKQc6g0ZrYB3+TXuXWASb4hGynIe0S6INIvxBesumQ1W95HZDCcqTNhF6T0JxWbsrOsxKZNASzHG815hNmgqF3r8XsxyEO72ZWXc/xOohOoTDtXe3qYnYK7z0rFzjKRvz/tk7Mz2dc+Xp1OpoOR8HLe0SFiriRTWboXSWFEOCKO/m1ABzB1C47jGZY0drGd+lAW7olnYXh+g7J0LDkDtpXD4s0csz3aT3/OvmJn0Bu6YedUJX9CnQGPsuikX4oosDSjzfD9erD7IwDVxGDP0hcakdpphjHPOJvtzc4KC470nEoAJRI+RQtnPyOt4XY0ZtcOeYnj5L3L2uetaO1EQjTqkMmYvhuLclyPV4GMslAolfDGclKtbFd+iMAXN3CURVfVEP4kDmWByqMcxasHPFAUL4Qq51nHgi94GPvF6aJD/HdBhtZuBkHAQTp1RKtYUVQYNZY+vWgudhnhADv0iMzc7N5vgLY3iD8VdWfQChhcB7szBTxXCfrTSjCJWjDAVCX9oejIKtyAOF+HT26qATI/0G9YbsanMZjyVHo4tUzGvAezaZov6ptdvD2kojDU+EAMdRrsCUym3xXXOR+boO1TVKKghz5zJiUdmYzloZAMKcJlwa8Fpbzt2e5pKzBIpyjcVxqsCwSrNioQlVilq4ZVYyclXpYLTxb3lpxI+BnVS1C3EsZ3WM+4y5e4mc7lioTJ8Kjyx8rft3jesqvSPNy54F0yZ18oT066Q4jY+Zp1MDLlkXBfVGGKpQSVtt1jOWF75aW0MmumPYamRJcPe3s0weHaUhwDFBGZKQrR5Zi/3qUne1FbaxHSwKn+Q9v4eXJxLyHW9dmX+gd7vhXRtysy9QZEZcXR2WV4rPMaUiadkAZEYVJ6e+skghgaDYMyYpRjKPQirsErNrMmAVrS18HGvv6Iz
 sHy7+k8a
 8LpY6DShE4M3yesWMsvhlwPecOjUgF/a/pNMnJzuIFuzY+xQWNC8rg97bsA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an iterator for `Cpumask` making use of C's `cpumask_next`.

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


