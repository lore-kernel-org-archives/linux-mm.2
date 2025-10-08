Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9046CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 12:47:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3C788E0022; Wed,  8 Oct 2025 08:47:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEC478E0002; Wed,  8 Oct 2025 08:47:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDD2E8E0022; Wed,  8 Oct 2025 08:47:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA54E8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 08:47:34 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6EA60BA180
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 12:47:34 +0000 (UTC)
X-FDA: 83974923228.26.E682B42
Received: from forward100b.mail.yandex.net (forward100b.mail.yandex.net [178.154.239.147])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6C6A340012
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 12:47:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=onurozkan.dev header.s=mail header.b=TIGY6JA7;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of work@onurozkan.dev designates 178.154.239.147 as permitted sender) smtp.mailfrom=work@onurozkan.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759927652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uRGv0l/dmTbmeqoiwwL0sBB19QCoeul8k0YBcio2lRE=;
	b=3EX+2Joc97EIcKHv0SFhUVm8sril/ob7wlv39CJYKAiWGsirzAPQk/4aOT3LG/boeaeRF7
	ko28EZFqvmiKq6/AQZkQBsGi+jjaVIq/UGkzUfFLzzLmy9ENjdz14Vtys5CtFRpb+ghpj/
	6aaeM6YLUn8J7ArHMXtTq75/4MuESd4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=onurozkan.dev header.s=mail header.b=TIGY6JA7;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of work@onurozkan.dev designates 178.154.239.147 as permitted sender) smtp.mailfrom=work@onurozkan.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759927652; a=rsa-sha256;
	cv=none;
	b=O3KlSNCd2TuIKqhErc3Agw5Gv2Sk4eI9RMDaI7EeB4JkWDf2v8xenIV3EVtmzUA3xOGqmh
	lLmvIpMAZUeFKLGK+w0CAho29csjBkVsQVrvEHScREPvKpBST5g6u35sgUNButqOOY36+P
	eHBTnh/opOq1vHSyDOx3nR/o0D66guQ=
Received: from mail-nwsmtp-smtp-production-main-74.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-74.sas.yp-c.yandex.net [IPv6:2a02:6b8:c1b:3715:0:640:1185:0])
	by forward100b.mail.yandex.net (Yandex) with ESMTPS id CC76180783;
	Wed, 08 Oct 2025 15:47:30 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-74.sas.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id LklD46OLveA0-5Fip2vTH;
	Wed, 08 Oct 2025 15:47:30 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=onurozkan.dev;
	s=mail; t=1759927650;
	bh=uRGv0l/dmTbmeqoiwwL0sBB19QCoeul8k0YBcio2lRE=;
	h=Cc:Message-ID:References:Date:In-Reply-To:Subject:To:From;
	b=TIGY6JA7uXQqZzGsU6qvsO+MVeWfyh6H8FJlt0NscSCMfPmwy9t/MW5XIVXced7ve
	 QIxBT7OUA3CWxqSPrgkRg7Lr0URBTJNWI/RYACVQa7XSn13n9DeW4DpqQMUZYdG0fZ
	 oCBkiHgRnCunKHIPSO7UeVbhe6AE/ZFpUqAuS1BI=
From: =?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>
To: rust-for-linux@vger.kernel.org
Cc: ojeda@kernel.org,
	alex.gaynor@gmail.com,
	boqun.feng@gmail.com,
	gary@garyguo.net,
	bjorn3_gh@protonmail.com,
	lossin@kernel.org,
	aliceryhl@google.com,
	tmgross@umich.edu,
	dakr@kernel.org,
	linux-kernel@vger.kernel.org,
	acourbot@nvidia.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	corbet@lwn.net,
	lyude@redhat.com,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>
Subject: [PATCH v2 3/4] rust: xarray: abstract `xa_alloc_cyclic`
Date: Wed,  8 Oct 2025 15:46:18 +0300
Message-ID: <20251008124619.3160-4-work@onurozkan.dev>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251008124619.3160-1-work@onurozkan.dev>
References: <20251008124619.3160-1-work@onurozkan.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C6A340012
X-Rspamd-Server: rspam03
X-Stat-Signature: p87pkp4m4c4kzxysdfy37hgafh54a8bd
X-HE-Tag: 1759927652-429905
X-HE-Meta: U2FsdGVkX180odoUbEDYbEe6+8NjPZ1FgFHlLygkm4oIlHg5jiEKnZuj3/HfnWZNOmVQR+yXlmTNIyEbDAQOlnGQSrv76rpIO407+UUwPTw4VE9DGf7o/gOd32To1Z+qVIKedkWQdMf3S1YBlXapMD7cybrxhKgnqRie4TjakJjj6OnFCgNWFHtVZfN2iWQ7HZ6Kb11zm2+l+tGmCShE+WM+nxf2kjAlY5iGTC4edRPz8O0wDfWXDNGqUY1hWEVCL8UiwDXk6Cn75t+1JuWXe/Qee9GWeFV+8yPz9gNXTYhJh0pl8VKlI21jGfoQOHeOQ6PJFB/SJbl5au9wnaPyQVVEnivlZYlQZv3BWd6Q5oh5G6jnLs4iEhgg5AIbUJuBORkRv1pmmbHGo4cP/IZaH88WmaCwT/GQF9VrV+ToOcjWnMI0PKui7vGboDTxtiyCSjF/xEzC9uYTv36jahUMqPGBAtPu8wmpcvwdauSwBKdmCaJRiKaEyjYh+sRxqVy1v+l28gZWfhxjD5LciK2Wynbb4OT+NjbcetBxpaZpUVeiMZXekWEoZOpRvtAHrcMhW91i3lcF9A+In1Z8ekKqJP+tekQV0/FdHUUwz3Ft5383+Pk2ILADuPWDqDpab7L7Pal6Wtua2xgBsqOQQgHJXDNZnDPwddx9di0kpLJiPRioS8DCP6hGbs6fxF036XDTb6JjEWu0vbuZUXJg1AR8sdPXw3pOXDWuIqVdOLYtwdElwK864/WDRUXa2ce1u/Y7tnLenR0xP2Km3niG+9Yfbjj6I3sD5OdlKCFSmPvfBU9Tc6jbK0ZAnbxyp5BaB2I1O4W0m0bGOsIRgZNQU5k+426DOErfSGRPEwe5BgZ0YlQZiFTJychDWrXXVsTQ0iE4Sapp8g9C+IBwXVc9RoMceqRdlssZtE9kuUvk6nHO5LHg/SWUW7pHBu0hbg0eNCff2fEW7dgVMtY09uxPGuL
 ft3Pphds
 1MD45cALDBQNhuJG2/H96Wrs7bTdoobrY0Neta9xB859Qc3CVbCplOvu6G40Xmr7uR136GsRbor1IyMJmJtV1rMTWX40kh0qHW/DMI/pQV8a9ENHEbE10qz0/dPkHM8iA6Pd0NBW+TAEKAPukeUi5ld+hbWL1UfNTJcSmYX6StEZWxjywjHQtK/rs5u6dn7iXRJ2+QYuZL1r7MnmC5hXnE8vTeK8fvbfuHCMXy2vTTADn7jBD07iUlunsXnSsB6op7mhI0tkOePGFAtF4u/lnCnywtEX59lxH+nAWP6sTMjSm26xdnqDhXZ5N+Ff7lWNlIOvHm7a/vxjg/xJSIBGvrZV9uLhVtR6B0PSRshcJWd0Mgap0CIl2NSQiHpe7y+w3q9AX3PXi+f6JrIwcT26wm21HAc8J9PWR5CULmEZL669EBStkGPQbKwj/YM2lXK6vlcozbqWx8tQVx2eQ6bdDFxpmJmfjZ7UM5VEa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implements `alloc_cyclic` function to `XArray<T>` that
wraps `xa_alloc_cyclic` safely, which will be used to
generate the auxiliary device IDs.

Resolves a task from the nova/core task list under the "XArray
bindings [XARR]" section in "Documentation/gpu/nova/core/todo.rst"
file.

Signed-off-by: Onur Özkan <work@onurozkan.dev>
---
 rust/kernel/xarray.rs | 50 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index 0711ccf99fb4..8ac7210afd6b 100644
--- a/rust/kernel/xarray.rs
+++ b/rust/kernel/xarray.rs
@@ -307,6 +307,56 @@ pub fn alloc(

         Ok(id)
     }
+
+    /// Allocates an empty slot within the given `limit`, storing `value` and cycling from `*next`.
+    ///
+    /// May drop the lock if needed to allocate memory, and then reacquire it afterwards.
+    ///
+    /// On success, returns the allocated index and the next pointer respectively.
+    ///
+    /// On failure, returns the element which was attempted to be stored.
+    pub fn alloc_cyclic(
+        &mut self,
+        limit: Range<u32>,
+        mut next: u32,
+        value: T,
+        gfp: alloc::Flags,
+    ) -> Result<(u32, u32), StoreError<T>> {
+        let new = value.into_foreign();
+
+        let limit = bindings::xa_limit {
+            min: limit.start,
+            max: limit.end,
+        };
+
+        // `__xa_alloc_cyclic` overwrites this.
+        let mut id: u32 = 0;
+
+        // SAFETY:
+        // - `self.xa.xa` is valid by the type invariant.
+        // - `new` came from `T::into_foreign`.
+        let ret = unsafe {
+            bindings::__xa_alloc_cyclic(
+                self.xa.xa.get(),
+                &mut id,
+                new,
+                limit,
+                &mut next,
+                gfp.as_raw(),
+            )
+        };
+
+        if ret < 0 {
+            // SAFETY: `__xa_alloc_cyclic` doesn't take ownership on error.
+            let value = unsafe { T::from_foreign(new) };
+            return Err(StoreError {
+                value,
+                error: Error::from_errno(ret),
+            });
+        }
+
+        Ok((id, next))
+    }
 }

 // SAFETY: `XArray<T>` has no shared mutable state so it is `Send` iff `T` is `Send`.
--
2.51.0


