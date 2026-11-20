Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A28E60A2608
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZCiF8uvk
Received: by kanga.kvack.org (Postfix)
	id 692B66B05BD; Fri, 20 Nov 2026 05:28:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61D496B05BE; Fri, 20 Nov 2026 05:28:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50BDF6B05BF; Fri, 20 Nov 2026 05:28:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 275B06B05BD
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:28:29 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B1994A8E73
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:28:28 +0000 (UTC)
X-FDA: 85455123096.05.414C46B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id E61F8C0004
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:28:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZCiF8uvk;
	spf=pass (imf28.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795170507;
	b=7z/aNihSvImpDUV62FHe5CaqfC0QVG1MIO9z/149V7tK/e23055uXsCLE2FiaZ+XDD0Lg1
	qoCaTiuYxAlszs8d3evcpAc1QvTVO3EkuHBDfX/CgqgPOuF5GRBflHkSen0S3Nl1RZNecV
	IKSnQTH5QblJx9JCIjwKbFG8rvTpdgQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795170507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RalyYAx1YoLGhOyFcSAsDfzWBv5wWU7LgQTBoopH1Hk=;
	b=8anayi56eKaV8ONtprVwCBfE2e1Zr/VR3JELyHdUD0PS57riYiVhPwOEF8ASIiPug1FnjJ
	zDS4LLnm4lsqeyPaUI7EuO74npmm1WVqMQ6ncnxqfmutMZHaI6iOj96ipksgt7EFzxmGuT
	fwizzMegndMGZWAYjQGkSsSXAFL52iw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZCiF8uvk;
	spf=pass (imf28.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 446AE4596C;
	Fri, 20 Nov 2026 10:28:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F3E1F000D0;
	Fri, 20 Nov 2026 10:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795170506;
	bh=RalyYAx1YoLGhOyFcSAsDfzWBv5wWU7LgQTBoopH1Hk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZCiF8uvkEpbeBiRyHV2KFlEqafiiK0+tSoH5CoXzKJThLyUyExw1sPqpqRsn0fUJ2
	 ZO6OihOZdi9SiP6y/Qq9qR58N8IiIxUeP4J7+D1Y8VeKUSn9H36w8d2ZNdDN9OOyd3
	 IYv74U0WDj5CFcoK1AVUSIbFlPe9zKDLdwGyic6YaWATRyaMUh+IvHjaeq8O8PxbIJ
	 M/W0MD4f0pagD+EzBTINYZdc17V4pdfnVZN6H74ce53tWK7nf+5g/LF+D7sfcHYN6R
	 veQud0PDLL8aVMfKsAwGbbL0PQ6tpFojw+eJre36w3OlfSipUQ6txofCfF8ddcNrcn
	 AVK9DEltY15Kg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 20 Nov 2026 11:27:10 +0100
Subject: [PATCH 11/11] rust: page: remove `Page::copy_from_user_slice_raw`
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-page-shared-v1-11-66f8c4c62822@kernel.org>
References: <20261120-page-shared-v1-0-66f8c4c62822@kernel.org>
In-Reply-To: <20261120-page-shared-v1-0-66f8c4c62822@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Mark Rutland <mark.rutland@arm.com>, Lyude Paul <lyude@redhat.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 =?utf-8?q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, 
 Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
 Carlos Llamas <cmllamas@google.com>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2405; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=yf+ZJdytQ7fsndkVjpDDExnANbyp+/XNQ8K9iMvdiqQ=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBrACCLDBjp7ML3zquQ7ptfmv1+wLTplqh09kKwn
 9JIxhZHs5GJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCawAgiwAKCRD6UCkIqsW9
 0AArD/9tCVQl3icfEOakZUAmYhm7LMSpEDiv3LcukfJAC6uAJNaAZ91Sp0XC5z0z6soVB9n1hhy
 5Uf+HSMYOazlWZ4fJa6AGyxAlGixQI8hhJEdGqMLFccKNEPkw/tj6R1VXAY+oz/FlgTa7l71Bpn
 fUhmrFjLo/ZW61KXhRkHytyk0hcP6JpZx7ceB3xCb6RRm/SkuFius+oJ7IOwliAK7dyUvBjzo8B
 H2DJeLEvGJgvac7oinMwYxNVMRZvb2rlaOvWta15GP0p6NP9/yIqrfHckZfgZKCIa5LrasZZ0Ub
 2n/xlam4VZsqx8LGZuA8er0Ytw9YYY8veKum+KM1beGMX1s/fSpekecxpzTRWUBSjeGie7rpiQV
 qq7fh2AMCbDA1sWyMSgo5L64Zvw3dfG9oMtOhu9eTHlACv6TWxOsIKjsTDVy5lxiQCQk4+Y/eHF
 dqV10WPKl4c6x0Kc4QOdEJANlbCtQvOyWO9QkORaPnv+UmYbdosM8NlgFVCSNL4b+1gn5u1L5f5
 Hn88Nf5wRcF1Ud98/vbl3zQy0+cIWr09CHSyeAYamPukKc7Jfx05XrBFkmA8aCwu/C/Z0JKDRxg
 nkQ+w+Z4AT7W/P33F0X4mqTTlwsZ5MmMx0eTyo7oInERapbp40yIT6xd/o9Zgorwr3JdxM+3t53
 /IntH97mo7vrfcA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E61F8C0004
X-Rspam-User:
X-Stat-Signature: rmqw98at7oaqogxo85zo4qdat1z7yo8q
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795170506-89084
X-HE-Meta: U2FsdGVkX19xzyNXodtCQczn4NDAUGB29ihsmgru+OWA+OTEoXFgDKq7PoLr2We+5rkNrZPfofIebU+M0gWP4jy4CEhbgPhyUVFtO9NjveCrK9KjIGURZx47a3A8NwKsR67BfjEhwkE89c+xbiYxYEhbwNl/JMMLIIlwdphWzl44WB8cd1dI1aq12JfUf3T+B/oj7hNLm6q9oZbJvzfaa/BDYy8/hAHSgB95gwHqPGKhJ31QtUNMypgzCbgTgx8lJfmDotpUxpgznglof/rqJu2ii/Sa0OYL3XgwFz/2KVOJBnk9+rM4J3bNayAka/SmG3W2SWFoHys6ozm7oP/hp/Vdg9tVA5DstWdkCFXo+GzceU3z/oJB6fXG7g7dddzfqxu9rt/tjtP7o2sOyVPsOdlAvs90eIbQpzGTUjDHGkY5O410E+FdAbjbrP3/8V0NH0xoUwBRmT0R8BrRogzzPREUsKWPWrmBgHlJ9bAAmp5AUPuquTG/vxv5lj/YTzK9CaQ4y6Nwuik0P62DcP1+XG8ieE51OnnQDXEhZHpQ/tm69z5hH2u1PMnyCvYLkVFvHox4E+hDL5nOJlYMlN2eer0U+S7EEoNfu15lykdPTbSwPSTtLepf307f8ii/fTBeMwNaxeq0kycqk/UQ2dXhqIQ4y8WjiLPMc+rDBAdPi5s1AHuGW/R+r9I0Nfo4nVpSsqCzlnYlgUlljb3WMOwOM6tRpjjn9rkwKPhHs16s7tzMfew/DmX3fGcsGSxDCSoNX/LwNTchFuuJ7aOvwadCvOUnhUVsLASkwcBb9gFkZnIxY/jVIGLFE6R0OgXrtRHJnhKw9glM3L+9jgn/8Uw8797E5WzsoXQk+jMZBQobwze5aeNwsRTEgBMR+hboOGkzVzfnOfgcVNVj6jJ/WyLXxKKUWRTZCzHI/fEDadHz16lHIVESwXYlYKjQ6gxslfTrC67KFMPaH/OnoXYjrvb
 T2dV6UTd
 hqEEWNRLq52Dhuv2F9LMwFzlAusrmTUJIsuXJC4DHLP30ZPO46BMY89e30uJRlCaaB/Q0+92gIoDqDcfakK3FXoguJOsMSclvpgr4K5Glx+lQtPDdZ7l3ah8p0zPljDgADDMZ6B0K1jeUUJBKcqEchbMaEXcOuTKH2rsyhVQ9kk6sskkp+H0lTY3rxC4mH+cmBqxXX4HyKXT2Xc6uTVAPzV6CpqQCh0E4Jaks7fBE3edBWxXWVPB81y0dQMnsBeHVt4/apH4KJg7mlqHXrWjU7/s8D4EDhvMms2IsAZf19QA/dI545DVOXj75GYgfXb/vprvpm0g6iuqO7unj1thbKigm4OcySh0ZOf5YKbFvRt37iMxjcWzfk/wgIH60kgrRfT5ef2VeIrJaS0Ynm0gXg4rjM3RMx69A/EbszuzTYzhqT+8P70qpDxdbxglv3s6TiYGkpGRJX+iPv24tD0FesEUeoUROFQGRroOi6VI8jsZ0l15qBCC0QLLYRivHygA4cihgBLtQnQUkyVU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The last user of `Page::copy_from_user_slice_raw()` now copies from user
space through a `SysMemLocal` view, see `UserSliceReader::read_sysmem()`.
Remove the unused method.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/page.rs | 32 +-------------------------------
 1 file changed, 1 insertion(+), 31 deletions(-)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index 7fa037f5938b..adb131fb94dc 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -32,8 +32,7 @@
         Opaque,
         Ownable,
         Owned, //
-    },
-    uaccess::UserSliceReader, //
+    }, //
 };
 use core::{
     marker::PhantomData,
@@ -631,35 +630,6 @@ pub unsafe fn fill_zero_raw(&self, offset: usize, len: usize) -> Result {
         // written are initialized. `fill` only uses the view on the current task.
         unsafe { self.with_page_as_sysmem(offset, len, fill) }
     }
-
-    /// Copies data from userspace into this page.
-    ///
-    /// This method will perform bounds checks on the page offset. If `offset .. offset+len` goes
-    /// outside of the page, then this call returns [`EINVAL`].
-    ///
-    /// Like the other `UserSliceReader` methods, data races are allowed on the userspace address.
-    /// However, they are not allowed on the page you are copying into.
-    ///
-    /// # Safety
-    ///
-    /// * Callers must ensure that this call does not race with a read or write to the same page
-    ///   that overlaps with this write.
-    /// * Callers must ensure that no reference to the data of the page that overlaps with this
-    ///   write exists during this call. Such references can be obtained from a
-    ///   [`Page<Exclusive>`], see [`Page::as_slice`].
-    pub unsafe fn copy_from_user_slice_raw(
-        &self,
-        reader: &mut UserSliceReader,
-        offset: usize,
-        len: usize,
-    ) -> Result {
-        self.with_pointer_into_page(offset, len, move |dst| {
-            // SAFETY: If `with_pointer_into_page` calls into this closure, then it has performed a
-            // bounds check and guarantees that `dst` is valid for `len` bytes. The caller
-            // guarantees that there are no races, so `dst` is valid for atomic writes.
-            unsafe { reader.read_raw(dst, len) }
-        })
-    }
 }
 
 impl Page<Shared> {

-- 
2.54.0



