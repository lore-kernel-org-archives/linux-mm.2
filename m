Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89D72E63F1C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 01:03:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B9646B00DF; Sun, 15 Feb 2026 18:46:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0919B6B00E0; Sun, 15 Feb 2026 18:46:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF29A6B00E3; Sun, 15 Feb 2026 18:46:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 98CFD6B00DF
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:46:23 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 979E08CCBC
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:45:38 +0000 (UTC)
X-FDA: 84448325556.01.E91EE67
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id B5C6440008
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:45:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PXkyxUVa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MjFuIOvnzJLF8nd2ObLgoPldzb190JRnqGs61BEOMBI=;
	b=oFhIZi2wJdB32hL7W4YADCIYSuLWGu0qBlAgMgHm94PlNgAA6xutNNdW91RKLHl3FfuKtg
	ZLOa7rV5nTacpWowgOx4jkLc1MwTODq+4iDSovaWksImfxcRBFTJYl7xD6Dn1MzyrdexQN
	uEx7Z2xpcMM9hdAYjB5dP48aouxqvDk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199136; a=rsa-sha256;
	cv=none;
	b=YVVw6VCqYIRfefRtejXRLI2nXxwQZSRCtGKfF0TidQSFChyByilmTH5nxzn1ZkjygBWxV8
	1ObwfSE8OIevMTbdLn+x1uPdKkHLmGiaL3IcmqGxd2IhBv6CyTf+05k/J3o0SG4t+Mn6Ef
	qg+gg+mxooprFrTHStyYdnbhL5Ah0M4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PXkyxUVa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E093341B5A;
	Sun, 15 Feb 2026 23:45:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F62C4CEF7;
	Sun, 15 Feb 2026 23:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199135;
	bh=eqqiqphigEUutWAOj4Ax0TLofmOBmjKS7MiYG2xrZGY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=PXkyxUVaJ59UKvQfextkryIKOLnj0O7g6KlrZmEkei4tuELxuOVRJCDq31Hg5833h
	 BQZjppCaKVSsRTdhzVgrz1pOTRkTpNb77Mp5u7MeVo582ftkRUXFAY4QCCjbMPMis1
	 kcrLlapeozPYfWMfHq72Y1NB7LYak5RLftIk0l21qISB5etNhRrh70D92+KyzXadlf
	 tulp0rVMhXnKWttVpro5dbBXp2dRY1R/zp63D7thp81nm1NZJ8xQbr9lMb83zl+hnJ
	 gWx0R0QpQeKOQkI2VsiU8X9LPRc20qQ/NjBE1/+T/f9lMsLNe2qQgK4bpEgCJgZ9FU
	 1/uEUke51zOFA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:24 +0100
Subject: [PATCH 37/79] block: rust: introduce `kernel::block::error`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-37-de9a7af4b469@kernel.org>
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
To: Boqun Feng <boqun.feng@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
 Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 FUJITA Tomonori <fujita.tomonori@gmail.com>, 
 Frederic Weisbecker <frederic@kernel.org>, Lyude Paul <lyude@redhat.com>, 
 Thomas Gleixner <tglx@kernel.org>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: linux-block@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=4556; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=eqqiqphigEUutWAOj4Ax0TLofmOBmjKS7MiYG2xrZGY=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklg9tsnSUeN3yuufEKi8gZGkENrakAQdsa/jp
 G2Ne5eHOG2JAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYPQAKCRDhuBo+eShj
 d7ukEADC7oEHfidFv4Xqhl5gUwo5O6pu+bHLU0Tu2FJlcKY5YpbZ5TMIvBIacDygyfwKE/Nxod1
 ARcqIZt+gw+56hZchaZ/GBevkPBlChGWVFJ7TJdQA10U4hO4QoAExHS4Uf5Ko3A0b1AmaAPVMyT
 tJPE66g4mwJqH1y1N2v7liZoXYPNHc4P28xlKJUqZ8n4qfsWTMU2Rb9gEaOwabJaG0CNUR4Q2TN
 eoy6OxN3spvtReYPPzv25J8YqzD5Sz41ecJU27n825TPm9OfSeNbUOk/nZbUS0mvb3NxVCahHd+
 +mEq7rMoIaZ2W7/TkSPCS2zX8dd1yxHBHkXq/bbKARJy290YKNld8UgerTLX5SO8jtuebAdYbWd
 tyf8pXVkLWqI9JKAWvKBjV1bPWLbZ1crOE2j4AMFd4ad/WZofR73hdC/Dh8ZNP1Xv1MOj9FVGXN
 16oVuTZAAN/bekoR+h8JK7BCH077LuvnGPwe/zorwq9YdRnaTDG/GAR0iNrHnV1gCT1H5GpJcFZ
 gcDiujYahpCQoBSBE16JRIcFLghvHmmg3dM5jDOkvKEu2vwr16G0asEFF/E9C6cLmtGG6ucWWR8
 Apy7OwXG9VmOmEoRnLGaAmZiEvupDEJ+sUbOm94GpvmfBSJvVOJ6tWUpNiKVE+8WHa9zKJAiedX
 aT8eYCeB0te7iaw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: B5C6440008
X-Stat-Signature: 1mhigft3qo9g6aj4kczt54pey48dn491
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1771199136-687294
X-HE-Meta: U2FsdGVkX19VkLqWc+aACDmgRjtdPfJ140eglvnD4aAgrd0qct6vgBQerGpBvdezABsf6F9PH5kuPOJB9XdIX9PCxq2BTSQO6jjQ1skv0P+TFjbzs4CGXTyXhUnkdhJK9aI+/xvd3BlBTZ681UBrXJtX5tDF0c+obtG7h5IkYCBHB5nZUNi/D3DMKA2+tRF8uzAdSyhr5sIjLCwNH9NU0M/md+6EmNqHIUm837wESIrtFK5Bt1nLz7GpFh5fVLUQy68VH0p41vUsr1OqaNf91Ynd7Vu6tZ3UhSPorc8p7/Ic9GoEQWXVetqP3ic9nSqyuYYxYsqdY2UKjc+oV+BWy1DeC0AOOJK1s9OTyD7vb4tyBX+LWGggv63ufni4i8pJVKPJ89/e9iCtodBOQflbobIEJgdRqDNtIjd6LLmDtAptTzpDRhbQ4a46OahrbghwcsJMGZLIkfZbnsEaQlOViHQsOF82MfS7tQe6KNiOHDfu73zebdbar8MNrqnr2E4WgKKDdhoSYAPXOAPTC3kfmyx6eNfwSDN7FfKFLgZLpeSLGe586uHRlH1OiZEt3MzGwAFSPG4bvv++W+ZONX5Cmh8OFx1LVbMRPsD31aCw/fd+kbLWmTU6nvpKzk7/I7JilxgggvVvnNkkkXXkDEfZ3Tgw3TO7vlPqA/nqZG5QerToK/XD17UJIj95XAjWclrlxiD22ERhSFAmnEzxyiYcdhiL7y487z+i1CsQL6JEFz+gM5LZvtAk+Y19hdTLjmstPtJ+NRN4uqvynWYOR0unOhkMg2HZ34Km8ulnJ7m57nBKgIjWviGd5xRXaxa4QyuggjsIk53Tf6banebAmbJ8mHEeOz7UXWS2SsfE0htBZDob1+1+GmgL0bEalBpI0i/3aIV/n462PxDYOD9NE3xTF9vC5jOnyxz6yW2l1+slBT2b943G0ry+xWjEohef/ssifU3mdaEdAJ96zMrl4h/
 VmHzCT0k
 OfyUWBRVkC0KKcG5Bkz2ddRC0kROW/U0Avk4M8DVpfg7IZr8bUVVXucJP3SeyGS45ObiZikSjBNA9SCB003HekWlWX46+wV0tCgzEiy8CWFsS23pVYrPh2Ak8pvZ2zW8UgXC39IL2UaxPsywESHm3Kl4gFp5OW9oLkPa3Q/YaH02r40Xe+w8PTUewLPNX43UYzP7Wme9x/nldE+Dei0JkjnI87FZR0yGr/jav6OoNZ0HSALdncuWFQ+qMjnCu2rVLWgFn/3+u0koYQaVEWBCtjyM4enSHc/DpLmRAd3ekpECyn1YPsbHfPGpJBc+nJI18Nafj9Jb60yp8JjVwgpWOaJTgavIk6m58DLBa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Block layer status codes, represented by `blk_status_t`, are only one
byte. This is different from the general kernel error codes.

Add `BlkError` and `BlkResult` to handle these status codes.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block.rs | 94 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 rust/kernel/error.rs |  3 +-
 2 files changed, 96 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/block.rs b/rust/kernel/block.rs
index 19236ab95227b..6cd83dc75a5eb 100644
--- a/rust/kernel/block.rs
+++ b/rust/kernel/block.rs
@@ -18,3 +18,97 @@
 /// The difference between the size of a page and the size of a sector,
 /// expressed as a power of two.
 pub const PAGE_SECTORS_SHIFT: u32 = bindings::PAGE_SECTORS_SHIFT;
+
+pub mod error {
+    //! Block layer errors.
+
+    use core::num::NonZeroU8;
+
+    pub mod code {
+        //! C compatible error codes for the block subsystem.
+        macro_rules! declare_err {
+            ($err:tt $(,)? $($doc:expr),+) => {
+                $(
+                    #[doc = $doc]
+                )*
+                    pub const $err: super::BlkError =
+                    match super::BlkError::try_from_blk_status(crate::bindings::$err as u8) {
+                        Some(err) => err,
+                        None => panic!("Invalid errno in `declare_err!`"),
+                    };
+            };
+        }
+
+        declare_err!(BLK_STS_NOTSUPP, "Operation not supported.");
+        declare_err!(BLK_STS_IOERR, "Generic IO error.");
+        declare_err!(BLK_STS_DEV_RESOURCE, "Device resource busy. Retry later.");
+    }
+
+    /// A wrapper around a 1 byte block layer error code.
+    #[derive(Clone, Copy, PartialEq, Eq)]
+    pub struct BlkError(NonZeroU8);
+
+    impl BlkError {
+        /// Create a [`BlkError`] from a `blk_status_t`.
+        ///
+        /// If the code is not know, this function will warn and return [`code::BLK_STS_IOERR`].
+        pub fn from_blk_status(status: bindings::blk_status_t) -> Self {
+            if let Some(error) = Self::try_from_blk_status(status) {
+                error
+            } else {
+                kernel::pr_warn!("Attempted to create `BlkError` from invalid value");
+                code::BLK_STS_IOERR
+            }
+        }
+
+        /// Convert `Self` to the underlying type.
+        pub fn to_blk_status(self) -> bindings::blk_status_t {
+            self.0.into()
+        }
+
+        /// Try to create a `Self` form a `blk_status_t`.
+        ///
+        /// Returns `None` if the conversion fails.
+        const fn try_from_blk_status(errno: bindings::blk_status_t) -> Option<Self> {
+            if errno == 0 {
+                None
+            } else {
+                Some(BlkError(
+                    // SAFETY: We just checked that `errno`is nonzero.
+                    unsafe { NonZeroU8::new_unchecked(errno) },
+                ))
+            }
+        }
+    }
+
+    impl From<BlkError> for u8 {
+        fn from(value: BlkError) -> Self {
+            value.0.into()
+        }
+    }
+
+    impl From<BlkError> for u32 {
+        fn from(value: BlkError) -> Self {
+            let value: u8 = value.0.into();
+            value.into()
+        }
+    }
+
+    impl From<kernel::error::Error> for BlkError {
+        fn from(_value: kernel::error::Error) -> Self {
+            code::BLK_STS_IOERR
+        }
+    }
+
+    /// A result with a [`BlkError`] error type.
+    pub type BlkResult<T = ()> = Result<T, BlkError>;
+
+    /// Convert a `blk_status_t` to a `BlkResult`.
+    pub fn to_result(status: bindings::blk_status_t) -> BlkResult {
+        if status == bindings::BLK_STS_OK {
+            Ok(())
+        } else {
+            Err(BlkError::from_blk_status(status))
+        }
+    }
+}
diff --git a/rust/kernel/error.rs b/rust/kernel/error.rs
index 258b12afdcba3..e656465010d6c 100644
--- a/rust/kernel/error.rs
+++ b/rust/kernel/error.rs
@@ -162,8 +162,9 @@ pub fn to_errno(self) -> crate::ffi::c_int {
         self.0.get()
     }
 
+    /// Convert a generic kernel error to a block layer error.
     #[cfg(CONFIG_BLOCK)]
-    pub(crate) fn to_blk_status(self) -> bindings::blk_status_t {
+    pub fn to_blk_status(self) -> bindings::blk_status_t {
         // SAFETY: `self.0` is a valid error due to its invariant.
         unsafe { bindings::errno_to_blk_status(self.0.get()) }
     }

-- 
2.51.2



