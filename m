Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AB8FF45A0F
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 21:36:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35AEB6B008A; Fri, 10 Apr 2026 17:36:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 339936B0093; Fri, 10 Apr 2026 17:36:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21E516B008A; Fri, 10 Apr 2026 17:36:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0503C6B008A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 17:36:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B872E13B144
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:36:24 +0000 (UTC)
X-FDA: 84643955088.26.877DB42
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id B036C1C0008
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:36:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BIt5Mbyd;
	spf=pass (imf20.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775856982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LSa2drr2d72jbSnbpnPMy5VtafgWDLdLn9PYujy+71c=;
	b=Cb5SitbTg/KQXAV+xVaMx9sXjol0f3vCq6UTcNB/Ypc7opaAlLLJSn4UJRa7kzaLgubyyn
	eEbce7ReWz4F0vz8wkXjq+bccxM7OJ+Q2P17xv37jciMHWtXoGZQikNjspM+SDp2d1LZ35
	XViY4jv5YyHO1itzeqtiTmCvhQgX/Uc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BIt5Mbyd;
	spf=pass (imf20.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775856982; a=rsa-sha256;
	cv=none;
	b=mXULr4+PIbbzskMqXL8iSRrjDb+M7pdBHhZKf1pJ6o0sWGxP8e/5W/RtwLDljbUFoR6JM3
	eeNz6N7StjBS4HEQHT6EXwO74ekY+U9gv5JxKZWSGWB/Dv9fq+NGX3qqKZOfkNi2Y6jPO8
	V+AqGE072r9Rq0BICg+30oAedK3wtJ4=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-82ce09b61beso1230476b3a.0
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775856981; x=1776461781; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LSa2drr2d72jbSnbpnPMy5VtafgWDLdLn9PYujy+71c=;
        b=BIt5MbydIPBOWxvywG5fCHYz6d24TJGhY9TzN5mMdtebB/4qmXanzz8Kc461RKF4wG
         Y7ZCwOgbwv6OsU+SWdPiTNdEeQQ1WaJ9RZcp56pb9e13hEkEHhTKZG0atsrCUS6T8hX5
         +H0FIqGY6MoOaxr7JNn7H7omlpqCBznPDt1ESCyuzeXqyXPl3BvY5j4+cWZeO0nT04ep
         LbQRwRK7spStexHCljfpvu7pxuXQSNkjwBpzLVD29asQZtwmZWLcFSof7uaeEJKNNV3H
         rpiPTnR+BR+R16Y2tF9QD6mf2Y8Z6bQkQFaFq97q07EGsnMYYlae/Xyj0fiNxHkI6H98
         mpZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775856981; x=1776461781;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LSa2drr2d72jbSnbpnPMy5VtafgWDLdLn9PYujy+71c=;
        b=lHdp5r56QMMlYOo5pinCHwZ0fnh5r29kRwlgM29FIQ+DQP+1bOgzb7uVScI0epqQJW
         lnyfXhMHOW21qSvES9JHjtBK5SRNyTt4VKiSEBHpF2BRYqyAETaBEG8dR8QBXsLUWBL5
         f/UdC9hZgqpWpcJD8z8swtNNlveTnpNr8XFAyn+JnrRhrX0lck14/LAxW7svNPdE7RZ1
         Z+N4dt1oDUKKETjzvN+v7DGtRgKOzOd+wX3r5vkpMyFDTEF1eQXH62ZdlgnLN9WzqKaR
         234Ynsu19NChXvtO9Xw5MG/NOQlhjQnr9v7ftZ11ZsQKDINt20svjai5WtsY+fk6v2h4
         pBYg==
X-Forwarded-Encrypted: i=1; AJvYcCUvNjpwe2bhvQvu0BTngfofsVJN6iZaCERXfskFXT89AnT584iU4W12lCbeSQU9YsBkTNeuud7WIQ==@kvack.org
X-Gm-Message-State: AOJu0Yz7JQFQ9r05pN8DrtppfO9o5QKCNwFPqASKJufLxCUo/PBYXVhh
	8EN5ZOiwfDqXALH9MyDEUHOStINFodbgXdAtj1sJ13+QuFAQnd5INjow
X-Gm-Gg: AeBDiesL7PXgCLAzKgqdcLgMdddYticDKfM3oqeDouBSAcmT+8SZg9ZIeS4oeQMZVxw
	gUwIHkcRlWV8SK7jG8a7LjmAo1JxeALOQhKpXZ8VnbDP7qDZt3oEUcHLQc0bpl/d1KOnNmJO9XX
	OyP1oTRad9GuRvTJfW3FL+oIv3CdCa/vwEIe5JwGFXL8oJpMN09P+yEKJYbPZW85bWOY9RPZpCN
	E1auRpaxZigWd63AWfJqrig8z7GnzxoB8PvXuMvRSlJVdUWARgnzEmPYLtXo8ode5bV2q7QwhmK
	db1clO0GTnLPbbO1DE45Ex8N0FoK+VW+c6xgOg2cUWHsBRLQYD/Sak6Ow985Zaz1fbJ2plOZC58
	KL4IkcWGk94RS9PfbCuMtBiYezSQx1sMOZLUasmYvkIevw3hkl0d3HDBPXt83DnhMrKpYbrP9mm
	SPPf/rFdJt8XMglWM4UP60U4y2zYn8BTVcukiLQIs6m4D5
X-Received: by 2002:aa7:9a84:0:b0:82c:8c6a:682b with SMTP id d2e1a72fcca58-82f0c169cb8mr5207029b3a.19.1775856981518;
        Fri, 10 Apr 2026 14:36:21 -0700 (PDT)
Received: from mitchelllevy.localdomain ([131.107.1.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c4e3d41sm5111551b3a.48.2026.04.10.14.36.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 14:36:21 -0700 (PDT)
From: Mitchell Levy <levymitchell0@gmail.com>
Date: Fri, 10 Apr 2026 14:35:31 -0700
Subject: [PATCH v5 1/8] rust: cpumask: Add a `Cpumask` iterator
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260410-rust-percpu-v5-1-4292380d7a41@gmail.com>
References: <20260410-rust-percpu-v5-0-4292380d7a41@gmail.com>
In-Reply-To: <20260410-rust-percpu-v5-0-4292380d7a41@gmail.com>
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Andrew Morton <akpm@linux-foundation.org>, 
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
 Christoph Lameter <cl@linux.com>, Danilo Krummrich <dakr@kernel.org>, 
 Benno Lossin <lossin@kernel.org>, Yury Norov <yury.norov@gmail.com>, 
 Viresh Kumar <viresh.kumar@linaro.org>, Boqun Feng <boqun@kernel.org>
Cc: Tyler Hicks <code@tyhicks.com>, Allen Pais <apais@linux.microsoft.com>, 
 linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-mm@kvack.org, Mitchell Levy <levymitchell0@gmail.com>
X-Mailer: b4 0.15.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775856978; l=2878;
 i=levymitchell0@gmail.com; s=20240719; h=from:subject:message-id;
 bh=BETYXv/iPQABug1OuKQYEFZYT26teVkAoSalVy+DWvg=;
 b=XwjVmH2pYFv3eafAe1fjdPZKz8H5eTGdm8cmz3xV4HYLP+EHPiCfuzPJVwN/Yjd+JMCLv6Wnp
 AS9Kw9gl3CcAMjDQbDNlLeQK3O9aaHxYfUQ5eZRr2Un5733dXgLh4dI
X-Developer-Key: i=levymitchell0@gmail.com; a=ed25519;
 pk=n6kBmUnb+UNmjVkTnDwrLwTJAEKUfs2e8E+MFPZI93E=
X-Rspam-User: 
X-Stat-Signature: cjxxgzygf99aguymbsesygddgkfh3z6k
X-Rspamd-Queue-Id: B036C1C0008
X-Rspamd-Server: rspam09
X-HE-Tag: 1775856982-42334
X-HE-Meta: U2FsdGVkX1/p+gBCCjhTwMF42f8L2dwRHsfagrDMV7DoQpYhhpUzOphfcdleNaLHZnLX9DQVbhwcZb7Gu6WuVGqtIF8m9jKlYsBWWa636Ukr/BFAPb/ZhBMVDlwutJD+srDCcRRIXtJQPGXsFXpfMDlr2YrpVesJQi65mWbeA0LwHwBcczVJ31mrl5wppk1GWfHClw2vZODqXcW6UkGtURkwRS4+ny+oJBbRahfmQf5YsLRwqPUD33beKwj8q7tZLMT0Ojgho4mzUPQJm2VVbTlRrx6FiHNyr+MotN0lWCQW9ETns6F4b8KRltqOYM4vQOmoSD15r4FiHP8YjLMqhkSROY2Ncyzl0WrbKqcR8kIg9D+CLQ4YH83cdWakuYqT0bT/8BNR6E5I0rXB2jz2Oq7MH1HX4KGuk6ioU7R2GB6mk/8m5GBdFHQaWrJe/keVC6z1ptsOSRmdQ2nem9G2SvSjJnUWb66MIXFRNwZllkbuij+bkqx5wVavbznjc+5ta75B+TLAQKlyp5E5ZMVdDq768hEQGNnp4igYMZ1/mYoeLnvYXqC+tg6ydGo7vpRQQmYVs9f1tb0Aq9lEEB2Aa3CyBfTc4XGHgw6BzgmojJNw4560SWz5i160TtXdWlBzetpXluc9sLo8evEnB74fQfB8au+LYitLb0sVuuEKEW7BijFuXhKXGFUJYAqu5bwKoY3EVzxDUkFSLm74Bey4YlNg9tUkKjq8ADSmVyG8lHoyCmru2toLIubIiOc98cempNYqa4wneW6mu+h0LiqQYZJPSUmnP6MF3WYYpSYf+5Voee9tqvB1gDOHaWAu0aaVnv3gowGuw9by2VaWxV5OvV3jbUv8hHt01FgTTzkb9Uj3PBYL1heHtpG+trVWmhDE9YsFLpzqVief5Mhm97kTZ79sCjlcoqT9DTxACATr7il0T6rTnZPBPitwvcMOFSVx4kEZK68sbhpewmisoyb
 qsNjobPc
 xI0czi8grACp75sy8sigj4hRNv1K1vrFJnXtaghYAGvUjphZ4+yp/rmgE5nCixk9G9k2EnwCq0hLxWhKc2rDA0hraKPX4qApKv1Y60sfwqBAnoW7OjcXlFrcijzv9PHNYcBSxz+IkQBEsxoim0qCK6mmLK7Ea65kwcrpz7oJKTqQ0sC/VzoaXCikVKzCB6k0psbSM/IGydkaQt/zilleOuFX7I9L0PJM+Dnh23/ZDfLJvCr8CFm/M9TYgBzPodPmAmeSMRKUeJpBVVUxmIRmcF//OBVYOKvy+C/qb/FcbI+YER//OCeeXGsuobvrICqQ01GRZANpryszgd6yuSdu456XH5CAU0zA0m6rf/EsOHYLOWPmhFImAShCXTm32cmyX1OwSdJUtFmutcOxsSM+IS1cMyT83BIpPmydcknkt2oa+GkNEF5K96JkrNSm45Cv4tdxXwwaRBa1ROlT/4MuwbS7D4qLxEbERjtO1rTYqzcVhiq1duCnkA0k97HIv6Mw3763HKclVrk8E1Iv2yaQm+TtxhT1kFryzi70XALPat5fNv8jKjiLJA/8rUg==
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
 rust/helpers/cpumask.c |  6 ++++++
 rust/kernel/cpumask.rs | 51 +++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/rust/helpers/cpumask.c b/rust/helpers/cpumask.c
index 5deced5b975e..76990e14dfdd 100644
--- a/rust/helpers/cpumask.c
+++ b/rust/helpers/cpumask.c
@@ -50,6 +50,12 @@ bool rust_helper_cpumask_full(struct cpumask *srcp)
 	return cpumask_full(srcp);
 }
 
+__rust_helper
+unsigned int rust_helper_cpumask_next(int n, struct cpumask *srcp)
+{
+	return cpumask_next(n, srcp);
+}
+
 __rust_helper
 unsigned int rust_helper_cpumask_weight(struct cpumask *srcp)
 {
diff --git a/rust/kernel/cpumask.rs b/rust/kernel/cpumask.rs
index 44bb36636ee3..b74a3fccf4b4 100644
--- a/rust/kernel/cpumask.rs
+++ b/rust/kernel/cpumask.rs
@@ -14,7 +14,10 @@
 #[cfg(CONFIG_CPUMASK_OFFSTACK)]
 use core::ptr::{self, NonNull};
 
-use core::ops::{Deref, DerefMut};
+use core::{
+    iter::FusedIterator,
+    ops::{Deref, DerefMut},
+};
 
 /// A CPU Mask.
 ///
@@ -161,6 +164,52 @@ pub fn copy(&self, dstp: &mut Self) {
     }
 }
 
+/// Iterator for a `Cpumask`.
+pub struct CpumaskIter<'a> {
+    mask: &'a Cpumask,
+    /// [`None`] if no bits have been returned yet, or the index of the last bit returned by the
+    /// iterator. Equal to [`kernel::cpu::nr_cpu_ids()`] when the iterator has been exhausted.
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
+        // cpumask_next WARNs if the first argument is >= nr_cpu_ids when CONFIG_DEBUG_PER_CPU_MAPS
+        // is set. So, early out in that case
+        if let Some(last) = self.last {
+            if last >= kernel::cpu::nr_cpu_ids() {
+                return None;
+            }
+        }
+
+        // SAFETY: By the type invariant, `self.mask.as_raw` is a `struct cpumask *`.
+        let next = unsafe {
+            bindings::cpumask_next(self.last.map_or(-1, |l| l as i32), self.mask.as_raw())
+        };
+
+        self.last = Some(next);
+        CpuId::from_u32(next)
+    }
+}
+
+impl<'a> FusedIterator for CpumaskIter<'a> {}
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


