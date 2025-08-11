Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA18CC87FDB
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 12:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF4488E004E; Mon, 11 Aug 2025 08:32:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7E4B8E0045; Mon, 11 Aug 2025 08:32:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A823F8E004E; Mon, 11 Aug 2025 08:32:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 92A498E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:32:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2FC2A135923
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 12:32:11 +0000 (UTC)
X-FDA: 83764414062.23.D0CFE1A
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf14.hostedemail.com (Postfix) with ESMTP id 428A7100004
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 12:32:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WCMinDkA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3x-KZaAkKCEAcnkegt0jniqqing.eqonkpwz-oomxcem.qti@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3x-KZaAkKCEAcnkegt0jniqqing.eqonkpwz-oomxcem.qti@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754915529; a=rsa-sha256;
	cv=none;
	b=bgO9Y6vFuQMRnnejYp2Y8j/gyZIG3V7H9PcPSjVPQCiOnlNXlXa3ZvtbkBDYwPGoD8ImVZ
	8ymOPx8vfq6MyysvvfQgJPeuQHd9SqXQ/BdoiTmjTsSMuZ0JJQafU2H5F+CANm1iWF+0EP
	YOIWjO/1iiGBRWFBOGy3t6RZwYS7g0M=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WCMinDkA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3x-KZaAkKCEAcnkegt0jniqqing.eqonkpwz-oomxcem.qti@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3x-KZaAkKCEAcnkegt0jniqqing.eqonkpwz-oomxcem.qti@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754915529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9rlOmIicLtEp3jt4sv4CSTuwkEdgZbSMhZPZuiG0qNY=;
	b=Ud0UJFygyQJ7meW7Gecw5uBSdgqli3QES8LrGqX1J93DsxzbXLPIysi2S5LsYybzRg+mI3
	m/EjrBUIOtIjDom8amz7MqVaJJogw5Adf3+BXByj3WhGoQwYus3S2w0kh8C7bpw77bsBnv
	/kPwMuoL67V96Qk0pon0uCojVk4JLLs=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3b7851a096fso3137555f8f.1
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754915528; x=1755520328; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9rlOmIicLtEp3jt4sv4CSTuwkEdgZbSMhZPZuiG0qNY=;
        b=WCMinDkATA+CAw68JEusWV0wavZnM66f9NtBDnSibIGa3EF+f5N54qJ43gbwf9oc0M
         pUD1J/O84dZNOHDL0Z5UoL6ZTZzog5TQAGw1dyu5U/D5cZCYiR4YzR63+1HbnfMuiF+W
         GkYWuiiP580YiQ2Z3min6VEMRJJtLk2qtJFl+LiczGGSWuJP1Tn+Hful/wmU16Xh2tXk
         b2+yaiMctwgT3WOkkz7EeQ4sBZi+QaQL7XSrTKaiJzrU0nqXb5GHW2zVZNRMgNFxMtSV
         au1A4ohzjY+Esuupq27B4QEtAVpiTShmDa91poU8TQykWtnAnD+eoa1vxZeVcZJ1DwSd
         RokA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754915528; x=1755520328;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9rlOmIicLtEp3jt4sv4CSTuwkEdgZbSMhZPZuiG0qNY=;
        b=qz6xPGKbYOez+IhuFxAv1aL9jgrxm8IFQ58ZNskdCijwREZ2n8nPYmcGCQx4EbqWIU
         z9pmj1yt16Xp+0hjNFmzr+5XZev2Nd8IUMtupLVU33JLyrGUCmfAhaLPXwC/MdsCDBUu
         rIlOcUm7+CIRV+o6cUP1ZgbJSv4dV12gsUC7b1dNrimAFlzx47pumeWhUvGLi/2QOFLa
         UipLdJup38h0v1DvhNB7z4TCW2p7sojL7pi+TZjb6wOPcdJ52NUiwKUsT8J+wLwUlvsB
         ftMCZEscSTroKbukoc3zOH4rZkb8qXGX1vbJ741P0k7FrPgBVSuLQs9VFPGq6QjiWtsN
         zm3A==
X-Forwarded-Encrypted: i=1; AJvYcCWy6vampAAgIEi7fiyP7/8KkcQf0665sE8WDw648P4fnvu+JVVSQ/L/8b5GWucD+EBe0B1pnU20wQ==@kvack.org
X-Gm-Message-State: AOJu0YzcjCatmfstQHuc/Kae8c0hijegC/gYToANLSLABTPe1MWwiFHa
	GMHYocNsng4g3FmfWC3dtcRFxkF2MMPUAFoGoKgMpVae+S5o7UwtL8Yh/hyNk9ER2gT9pda1bua
	N3qucVYOTw3YTX8V+GA==
X-Google-Smtp-Source: AGHT+IGLqvqODrNKUqFGV1RPHxhNKh2ajU+3kusbjIAlTVO5vOTLv+p7fkC+SL8LO9kaXdUyiw31plWpnKodurU=
X-Received: from wmth4.prod.google.com ([2002:a05:600c:8b64:b0:459:dcf5:1b54])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:25c4:b0:3b7:76ac:8b72 with SMTP id ffacd0b85a97d-3b9009294e5mr9096299f8f.12.1754915527779;
 Mon, 11 Aug 2025 05:32:07 -0700 (PDT)
Date: Mon, 11 Aug 2025 12:31:51 +0000
In-Reply-To: <20250811-align-min-allocator-v2-0-3386cc94f4fc@google.com>
Mime-Version: 1.0
References: <20250811-align-min-allocator-v2-0-3386cc94f4fc@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=3044; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=3TOHdsav1ycB+aZ84BPSmdU5PVabBdrJYr0uju0OSxE=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBomeLD7qI0nZRsYh9EJ8g3j8Abdi0u+B75wO6Tr
 Lti2BBLUReJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaJniwwAKCRAEWL7uWMY5
 RvAWD/4qmVr48iymYXFuDkGmxltJS6ILykjTpfpC8zNFFY76rrYxiOtJRaNzi/FbdFsdgGHH8pn
 U0Dtcj+pEVp/ac9Jej3eTY8RdHtWiHTTza/GeRYt0vKrl3j4qp2GHh4oN9wOLqbpdNL5QbAaxjg
 tXiwjycVXRR5inzf7VtQ+6ERQHeN4ja6xDxdRNOze2ltFpQ2pELfdJbXhlQEGqyQOhVTZpqjfsg
 EUJi3VLNXZnyJGCj3florbFn848EvfG/QkErQdXkFee+qxsVygZ0ev+z0G9p5y4crdFdM9Qt0E9
 gWUpG2sWvqV1qLgdXfwMwhDfJxEHNJz5Vm6nG92uwaWkn5EsjmUsZs7MgawgTWTtZmrxZc0R1ik
 NDgBhTaWzKXM0XCga0yHRhiOMZqH9XB9IGSnUKTsXedMRhP8As3rnf6FF1TVb9j6Ru3eb2/AljH
 4q7FWAuTi3flms0P0eG5AYEY8rvlRz7Wj+QA0Owu32mVmiJ6bCEeX0H4swgrsY1aJu9dbck5izo
 1S+kHlcnmzXt65jisEuoc6rH6ZeI3RI4jzfeSLEc2xBl8m7MbEXOuJsiuHURnTn6+g8oFV5VlRo
 Rizotk0lWMfBDg2orMlo48dCPAIUQrYPoRD2JAejExoHgqLXffV5tz1anAo6KMnTE5rpam+aV8z JDLA7pMlhh3Ymog==
X-Mailer: b4 0.14.2
Message-ID: <20250811-align-min-allocator-v2-2-3386cc94f4fc@google.com>
Subject: [PATCH v2 2/2] rust: alloc: take the allocator into account for FOREIGN_ALIGN
From: Alice Ryhl <aliceryhl@google.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Danilo Krummrich <dakr@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Tamir Duberstein <tamird@gmail.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Miguel Ojeda <ojeda@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 428A7100004
X-Stat-Signature: ikjqkjfjka7uha69m6s4tm5exqjxc451
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754915529-460972
X-HE-Meta: U2FsdGVkX194OcywUlBfTrFaBm79bp+LHzeU1j2yleFYPn733nvHJp5aiDtPJnfIihALUEmq5eIj9s1xOGvl+gqxk1niMox/x0MXdjADfAZpj0aRAQaD/a+pJY0zJAt8Mlo3YCGaH8Amikh7yhZMmxcbnylJHdbnqLvwW1d5Gguo8PRA7LXv1HrKcumIkzwCwSOi7OOemcgY4fl7LI7lRSPvwSwi4iPzD6FbO/ldeh/Lt4z+ZpHKo5ruSb+Smz6kfeCahORcHiHliUtr1L32VQ4HdfqJaEKx3BauiTsMbPyR+0Xq9YCb5UNLRX9JxjBjvV5jS8AZWxAgi0T9NU9idkJdUsTtLh0WvAnvmdzGq/i2h1Ie7cIdsZDwj92z+xrAlpE74Qrdd5XOhkGEBB0NsoT6URUdsxm1mU4Ftiu3EFr3bKUwv+cgQ7fXwvAb3Sh5IksNMmyO+J1bECcD0sgY20dudNkZ0QJq3S4Ya2ytleFwIZsAzs4BxrgfY2Go87ZEmKivZAst/hI9H4GAOsWc7KuSnPQYeduTQ3o4BalmieL5ONAC87wrrWITJrsqsGc2/SGNMdId15TVFs5kuce9J7vlkByjzJhbMhWiE2+/VYWjDWqgwZuJXcVAyFoJIla6CwBWFKWTet1th5gmfNqgruecxqi3Zi/I1a4in6IubUErY5xvKucB1mN8oYt4B26XELjJwprYuYKAwesXzJWgSk9kRhU54sWweUBM9HcXoAE3wYJKuTwLsmbRxuAy5tceVGobOz7MKPICyUSSyt6uiClY0gj5gYSx3Ag/Q27TCd1FxUk7WlhQP2wvzArONA7e1sP9ckYtEI4MEBpkNR9vrft2vuq9ecjzOjEfm3M+wl/qlH28/oj+G2+gFvksUXXHVYESNAZcLoWMIpJWqMT8zSxQ3Klg4/6mkNagABP9t7dy+O3J16efHAFBsYMWry7FMHx5zwK0AziXL7a7PFK
 hsgttCKO
 PwNhXp63940xkJrlPHl4dlPKuDrJfX0irbt95JoEEWXsFUDEMnA6Z+YUxg9iQLouayuuGvDh4k1Mz2BHTVrz135e+sQPH8fLogFvjEVBeZgrLpqaBO3pPwqpDLZo64P0OaWtshOkkHXWGLjHwJeNWjJNLlSBmNs3NyM/8gC8tAnV9klw0IMTB9+hbSMdQ58zH593z30i0S8qvqvi3nV+BesYdclR2Ig5pz6ZePHR+TXaueAvUzcsNTepN7v4dwDhaJd5E8tnj7YPwTz0N1Dc+dBOGPP3eWlCUWcqsQ5DwuuHYfwzkxpoqbf/Y76OO+Cdo2QrXeH/H22E0DGFvCB8MUZJa3fqsYWRruAVUlfIF9OnyOhP9nJVU8hsdA+Z0I2f+o/q5aN+YUjLqNQORM9Yyl6L+DXwQgsmjCnAsDqsB+HNPmHYbbxbQhH/bFec891PqK4Qeu2337CvPqeSsUoxYFYYjVDaXbzIR0z6T+fLiOQcE84R2BIogLkXJqSWtjmVD9nV8CoOml9q8OUAGGVe37jjhIhQPz9SNL7As1a+CMKGEy2sz0wPdSwOd1T4BOf67Qui/pIwRw0SG38BAkX+xHR26jgn4MCrS0KWb6spdILuSIULh8GbV6M/meYILDVDESMyA4ow97nEGYilGr4RdGuBK8801IhFr06UWJAFbJWEwBGwjEo5QhGUdjC2YJCgohxZIiHiuCPp4Ubg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When converting a Box<T> into a void pointer, the allocator might
guarantee a higher alignment than the type itself does, and in that case
it is guaranteed that the void pointer has that higher alignment.

This is quite useful when combined with the XArray, which you can only
create using a ForeignOwnable whose FOREIGN_ALIGN is at least 4. This
means that you can now always use a Box<T> with the XArray no matter the
alignment of T.

Reviewed-by: Benno Lossin <lossin@kernel.org>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 rust/kernel/alloc/kbox.rs | 13 +++++++++----
 rust/kernel/sync/arc.rs   |  6 +++---
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/rust/kernel/alloc/kbox.rs b/rust/kernel/alloc/kbox.rs
index 856d05aa60f13485d8afc98f0b7fe7593867b5a1..eedab0be1eff78a8150524346348ec0759f852e2 100644
--- a/rust/kernel/alloc/kbox.rs
+++ b/rust/kernel/alloc/kbox.rs
@@ -401,12 +401,17 @@ fn try_init<E>(init: impl Init<T, E>, flags: Flags) -> Result<Self, E>
 }
 
 // SAFETY: The pointer returned by `into_foreign` comes from a well aligned
-// pointer to `T`.
+// pointer to `T` allocated by `A`.
 unsafe impl<T: 'static, A> ForeignOwnable for Box<T, A>
 where
     A: Allocator,
 {
-    const FOREIGN_ALIGN: usize = core::mem::align_of::<T>();
+    const FOREIGN_ALIGN: usize = if core::mem::align_of::<T>() < A::MIN_ALIGN {
+        A::MIN_ALIGN
+    } else {
+        core::mem::align_of::<T>()
+    };
+
     type Borrowed<'a> = &'a T;
     type BorrowedMut<'a> = &'a mut T;
 
@@ -435,12 +440,12 @@ unsafe fn borrow_mut<'a>(ptr: *mut c_void) -> &'a mut T {
 }
 
 // SAFETY: The pointer returned by `into_foreign` comes from a well aligned
-// pointer to `T`.
+// pointer to `T` allocated by `A`.
 unsafe impl<T: 'static, A> ForeignOwnable for Pin<Box<T, A>>
 where
     A: Allocator,
 {
-    const FOREIGN_ALIGN: usize = core::mem::align_of::<T>();
+    const FOREIGN_ALIGN: usize = <Box<T, A> as ForeignOwnable>::FOREIGN_ALIGN;
     type Borrowed<'a> = Pin<&'a T>;
     type BorrowedMut<'a> = Pin<&'a mut T>;
 
diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
index 63a66761d0c7d752e09ce7372bc230661b2f7c6d..74121cf935f364c16799b5c31cc88714dfd6b702 100644
--- a/rust/kernel/sync/arc.rs
+++ b/rust/kernel/sync/arc.rs
@@ -373,10 +373,10 @@ pub fn into_unique_or_drop(self) -> Option<Pin<UniqueArc<T>>> {
     }
 }
 
-// SAFETY: The pointer returned by `into_foreign` comes from a well aligned
-// pointer to `ArcInner<T>`.
+// SAFETY: The pointer returned by `into_foreign` was originally allocated as an
+// `KBox<ArcInner<T>>`, so that type is what determines the alignment.
 unsafe impl<T: 'static> ForeignOwnable for Arc<T> {
-    const FOREIGN_ALIGN: usize = core::mem::align_of::<ArcInner<T>>();
+    const FOREIGN_ALIGN: usize = <KBox<ArcInner<T>> as ForeignOwnable>::FOREIGN_ALIGN;
 
     type Borrowed<'a> = ArcBorrow<'a, T>;
     type BorrowedMut<'a> = Self::Borrowed<'a>;

-- 
2.50.1.703.g449372360f-goog


