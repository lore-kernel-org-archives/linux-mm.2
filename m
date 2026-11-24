Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F068606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ra+eO2IH
Received: by kanga.kvack.org (Postfix)
	id A9F7B6B06D9; Tue, 24 Nov 2026 08:27:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A772F6B06DB; Tue, 24 Nov 2026 08:27:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 966306B06DC; Tue, 24 Nov 2026 08:27:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 572846B06D9
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:27:23 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E07A31C46B7
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:27:22 +0000 (UTC)
X-FDA: 85470089124.24.515BBBC
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1D5BB40006
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:27:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ra+eO2IH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of mbkchelofficialdev@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=mbkchelofficialdev@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795526841;
	b=atf+Ce1RmOnnChFKKW0VxuvKkcvX/qlXHxxwg1d0fDzoQDn255Mten8U3nYzK6HLyK+TR5
	FX9Hm7VSSCdodliwpPxA+DyYlJsDEO2bOyqtuAIjwypNjfQprgDTeGNrf0IBNnLCNQQQy1
	U53b7z529JsrhQAOTV2BwGzIyGnvaeQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795526841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9knFjMHe9w7dRyRiUwbfv/BO6CtQAiEfyZrTpR7EXyw=;
	b=7RQgCTfADWN73XBMqhRgyzZ1FU8z2NlSpspvJmbYJNBNDjL/tgIzroGKjDi7kjjMMyH8AS
	QIwQy0xn1n0tOVi0X1xVGiRsX2R1e9wJFxvrY6koFmSDdUtWhci1EN6Dwc6HUGr10QB4YO
	sU1v0F71zwFy6R2fQaiboqVc7AiSDpk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ra+eO2IH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of mbkchelofficialdev@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=mbkchelofficialdev@gmail.com
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5c1c0c8d61aso2884682e87.1
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 05:27:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795526839; x=1796131639; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9knFjMHe9w7dRyRiUwbfv/BO6CtQAiEfyZrTpR7EXyw=;
        b=ra+eO2IHcRZ7apUXXxhXC6gKmjs6dCpWUU9ynWJ+e8cafZ8q72qg5iRqvWQAV/aepq
         UV+aJMOegnLTZPqaGmLD8rt0J3sBDbdwZpAw10hyVZJLj5wfqqWyZNuexOeV1MboyIiV
         nrHaunzZOrEijbs3OIn/apQPDH1QZaizrSqscPxNt8z79evOwvq74N+8x3n57Q3QxYcB
         4NDsvTRYaveDweI6nF8kitz/dBC47KgNfoEbNjk5cszElkCy8EqFllwsXqBEg3aXgISj
         QaL++tAVLQAbZuyWU0z5dBkYNy99bfqMOX7QUcA8Q6xRxSiXtip638f0JBPjCcFBRaOp
         9zOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795526839; x=1796131639;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9knFjMHe9w7dRyRiUwbfv/BO6CtQAiEfyZrTpR7EXyw=;
        b=QKejst3wo3neQBrQY04lMjvwh0P+/C86Kl7wsBQk71alE8D2Xpu+QdyekJK7c2TAIx
         jiI8ghD3gwVk6CK0jp8UMdvBILFzTVmoaAwbchijtDP9TOao8iDUNunKQ+sLsLeq/+/d
         guwULm+m7TBRZT2+YhI5LN7X1L/9ZjDRJdFzIZuKre4u35bjuxXGweF/5mKOt44lyyHj
         4P+IbQzdbKeRljxm3PE9H8hRajD4ntpuGRi/80OemMowiZAw6YWqQ4Nl0clKhRDkEhev
         WRO3c9TPZfq/bceISUQX2oB2S7g/2qXBGFRDMS6F742uEXqfl8RGMCNfQFuZQoUfEION
         1djw==
X-Forwarded-Encrypted: i=1; AL+hErHS5juwjGmYWc33/ofMIo9NfIaao/Ear2KSIuyApBctU5Kru/wZ916IzwPTGUIqEPodjpRNQE3ilQ==@kvack.org
X-Gm-Message-State: APuU4Z+Pn4LQXL0+2pN5+E/+K4q64F3pSln0zq2RQVDY3V+Lr8HkRs0r
	TFy5EwJdZo3dHUGOdCD74l+pJOt3wfBuwSYvQxgDsaPrMP5My2Mw9cPN
X-Gm-Gg: AZFdTZfsOrEdDbNcSlGLx92myHeI526tNZdYeLGORkAp2uskACjmp689DBCAz+cMjBx
	NHSOgY+DyzwSpgMVcxrarT/sC4q+fUtRne4cLDdxuJmZ7Uq8PvHOA3HzpeW4lqgnHENCk1gn4CV
	7xZEXve3cG/qUDXKxTBjGrS+MPkDp9clZJod7ny99BKbcPY5wSPtFMbQj7YHDN6Z90/EI8Ih7I/
	hDeNuWc96Flf9C6Nmvw7xachdjZVdg2sTUPiub72Rs+G2rIbaJyZ7vLacW7od9PsCsofOJvRa64
	8XrYrsXSWqgX5LCQVa8l6wk2HXSIon2CDZqBL4hdbTaudNU5ByhbiEh7EmSjLUNfWoMw/D2vztq
	47II1PLOFYN9/Lg+73cs6Y583M0nZoH869YEBh4MrdRdN2wJXFTVZXSGC0sMwYFNU5jVF1SlQwR
	0MFnM05wXvWw8Mp0b6yA4u8iGXTWpR7HMdVkNpHrx7fsAj5ZE8THP72BrjAwaTbQyCnwxaZcNn5
	aLvPbcY6V3OyS0O8PCaFDAGlRgysV+AJc1mOPrOqTzdGrrp7CyQ5vLXqpDzirn5KsPKvD98aHzY
	M2h3gS2pviytXwT9oI2N5aNPwqdP+sUqRclM
X-Received: by 2002:a05:6512:618:20b0:5c0:165:16c3 with SMTP id 2adb3069b0e04-5c1bc85f246mr3044609e87.64.1795526839090;
        Tue, 24 Nov 2026 05:27:19 -0800 (PST)
Received: from archlinux ([194.28.181.64])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5c1bd064420sm3733777e87.71.2026.11.24.05.27.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 05:27:18 -0800 (PST)
From: Ivan Tverdokhleb <mbkchelofficialdev@gmail.com>
To: FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>
Cc: Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>,
	"Liam R . Howlett" <liam@infradead.org>,
	rust-for-linux@vger.kernel.org,
	linux-mm@kvack.org,
	Ivan Tverdokhleb <mbkchelofficialdev@gmail.com>
Subject: [PATCH] rust: bug: add warn_once! macro
Date: Tue, 24 Nov 2026 15:27:07 +0200
Message-ID: <20261124132707.101769-1-mbkchelofficialdev@gmail.com>
X-Mailer: git-send-email 2.56.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 1D5BB40006
X-Stat-Signature: yj6tpaxagnre3x6oszimri4ht3nye4f3
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795526840-724860
X-HE-Meta: U2FsdGVkX1/9tVj53CcYdAkGclxD6nN3oU6K8rV3H0426rSZ5wfewlrmErY7PMbsZJG0jnVyhPy5lh3+nq2tRmJHDBpBJ0x+mCrcgex4bZqmftzx2mfsJ4a2ttZTrSIRL0IYkbA8XGpSpULSbkcX8rjVd7NDN1TrCBgyvvwzq+D1dF+eKZwVqwJsFFM6tyqdIIzHO6uflitlL+mRGNwwajXGsALoPxNuszgH2OA07c1tYZPTFoSVSElFbcdlkY3MENN4VvAFmqgdnHG1JBoUVH7I+I8sXLPz4bf1vszoTUlwwQmHmGmHl0lPaETZSWrFb37Zqw3R+TD4DNByFttI3atyIyknvg+3KqSB2KcFYM7s3yR8hbJjMEm9r+OqdbUSuyxWc32KYF/tVHeGKO3ums/P1XKFukdQVMjUOs+lMsEeDAxpJgZ4Hv73YCr4c0CfjIG1QrVrzIz3CmfdqPnYkp94S2o2yX9Tm/2srgPi4N5u2BFEC4PHAgA4ZdhUharEWTJh0DrNeeXR0/AkSWpoQeeIosIXFNMuCkvfDNzW6Otwe0JLVSLewSzL9uFxzvov+xrVYbXmTcyzSjs/trjEwOlH741SyAqaGoDyQ9tSmID+QI1jrUNGDqvG+SEbvBR00NCJa6XGeMDGI2DDWPv/5HBz42uSaAXrz/P70QUzAW8v9vLdJtvJpmbOurOs9HsDwpFefnfO/xdRq3dDCFnnCOKbtZVJuh06bXkh6IzM1IWLpPCTHi/129lyvK4VeSUI9Zq1OXAgQ10HY77BLTtYf84poKY0uitms9Ek/IEqW9QYLR+oNejVhXfi5dJNdveJxX9psTJGOrznHT1xkW5irfF70Qj5RGIHBAPPc1FYH35dJYUwuUWAGjH6kg4McmZjoeS83+xFlRH7S5RU7Vuc9Qro6WREwutXS3F/xCD5pLQ8jSRTZA1JjlfqPiE4UCBQsBveihphzpI1BQaJ3Bu
 aEAxI56H
 N3bIePPQcVwT8VV5EYp5l3BuC524g00NIg2ceyIpEBVnA0Z0rw9bC+8Lo91h4HgXl0r/RW/MQEe+QiyRJiok3dX+DX/0KkKzxEsZ6FCUrjRTjjlrvGakuRxRWGgAVSppFuV1vY7N8QImGbkpRt2dWB0f1b60mWb1/JKeTLz7CYxtuHIuZKXMBRntih0XTuvh6xSo89QLh9/RR0b2lpDoZWHjBxWHY1NadQPPYujRdyU3H7c7SGhQhoEpjGMbssX52t8ZQKiCgf4zX3d3uopqh1cNmswBzRRYc8rvFz7xkXfSN+gTD+PwPxy3jl5r766VjbXBYPHkBedZrRIsiRv11VSqmekGA3U6AfjUD7D0oNYWz9Y4vU3dNfAGmm14ZOkKfgpYr7ysjWajbAOBmeQDp7NcTDkBeMPxRED0nHuiw7we9WHj/hdJYWZJJco2n6cv1TActXtuIFJFa4AwUU8x6O1rPSjHv3RHZYDYbvUrISl62MKupZf0FXtZ5N5BLNhucpsiSFtH0kfET8QIroQS7UV3GQKJ1PwR20NcPqKrHIaZ42ewmXEGX8nDPlz7dgec9NYsI0ml3iu7l2uZiL2HWKks3ukcxcNRpWMFqxLxt70PlzK0MeYMdymaTHwok16BvLCepB4ci0iv+JXNxN8tZghOZmBWAXCYn8bWtl66AQYcczqIb5xdwY1xrDapUuUPBaN7wBDvNJIniExWkLK4mTYnkbXYfqRJR/jyWsFEu7fSJ+QeTgU7hIjL4OgDOPNFKRSWUDoINYtfpmxzKJGc65nNqkdYTpPfLGmlpKznmp/xXoQ7mjS3cmMfejXFAc0AkjvSn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a Rust counterpart of the C WARN_ONCE() macro. It behaves like
warn_on!(), but additionally sets BUGFLAG_ONCE, so the warning is
reported only the first time a given call site triggers.

The macro returns the evaluated condition, like warn_on!(), so it can be
used directly in an `if`.

Use it in Vma::zap_vma_range() to report an invalid range, which
resolves the pending TODO there.

On configurations where warn_flags!() ignores the flags (UML, ARM and
LoongArch), the macro behaves like warn_on!() and warns every time.

Signed-off-by: Ivan Tverdokhleb <mbkchelofficialdev@gmail.com>
---
 rust/kernel/bug.rs     | 46 ++++++++++++++++++++++++++++++++++++++++++
 rust/kernel/mm/virt.rs |  3 +--
 2 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/bug.rs b/rust/kernel/bug.rs
index 3b40b0bd3..a0db5c902 100644
--- a/rust/kernel/bug.rs
+++ b/rust/kernel/bug.rs
@@ -156,6 +156,27 @@ macro_rules! warn_on {
     }};
 }
 
+/// Report a warning on the first time `cond` is true and return the condition's evaluation result.
+#[macro_export]
+macro_rules! warn_once {
+    ($cond:expr) => {{
+        let cond = $cond;
+
+        #[cfg(CONFIG_DEBUG_BUGVERBOSE_DETAILED)]
+        const COND_STR: &str = concat!("[", stringify!($cond), "] ", file!());
+        #[cfg(not(CONFIG_DEBUG_BUGVERBOSE_DETAILED))]
+        const COND_STR: &str = file!();
+
+        if cond {
+            const WARN_ON_FLAGS: u32 = $crate::bug::bugflag_taint($crate::bindings::TAINT_WARN)
+                | $crate::bindings::BUGFLAG_ONCE;
+
+            $crate::warn_flags!(COND_STR, WARN_ON_FLAGS);
+        }
+        cond
+    }};
+}
+
 #[cfg(CONFIG_RUST_BUG_KUNIT_TEST)]
 #[macros::kunit_tests(rust_kernel_bug)]
 mod tests {
@@ -184,4 +205,29 @@ fn test_warn_on() {
 
         assert_eq!(suppressed_count, 1);
     }
+
+    #[test]
+    fn test_warn_once() {
+        // SAFETY: `kunit_get_current_test()` is always safe to call (it has
+        // fallbacks for when no KUnit test is running).
+        let test = unsafe { bindings::kunit_get_current_test() };
+
+        // SAFETY: This function runs only as a KUnit test case, so `test` is a
+        // valid pointer to the running test.
+        let handle = unsafe { bindings::kunit_start_suppress_warning(test) };
+
+        for _ in 0..2 {
+            assert!(warn_once!(true));
+        }
+
+        // SAFETY: `kunit_suppressed_warning_count()` accepts any value returned by
+        // `kunit_start_suppress_warning()`.
+        let suppressed_count = unsafe { bindings::kunit_suppressed_warning_count(handle) };
+
+        // SAFETY: `test` is valid as above. `kunit_end_suppress_warning()` accepts any
+        // value returned by `kunit_start_suppress_warning()`.
+        unsafe { bindings::kunit_end_suppress_warning(test, handle) };
+
+        assert_eq!(suppressed_count, 1);
+    }
 }
diff --git a/rust/kernel/mm/virt.rs b/rust/kernel/mm/virt.rs
index 63eb730b0..567665958 100644
--- a/rust/kernel/mm/virt.rs
+++ b/rust/kernel/mm/virt.rs
@@ -115,8 +115,7 @@ pub fn end(&self) -> usize {
     #[inline]
     pub fn zap_vma_range(&self, address: usize, size: usize) {
         let (end, did_overflow) = address.overflowing_add(size);
-        if did_overflow || address < self.start() || self.end() < end {
-            // TODO: call WARN_ONCE once Rust version of it is added
+        if crate::warn_once!(did_overflow || address < self.start() || self.end() < end) {
             return;
         }
 
-- 
2.56.1


