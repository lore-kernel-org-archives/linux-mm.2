Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4C00E6E819
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 11:34:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDDA16B0092; Tue,  3 Feb 2026 06:34:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8AF46B0093; Tue,  3 Feb 2026 06:34:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2E206B0095; Tue,  3 Feb 2026 06:34:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A03AC6B0092
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 06:34:27 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 41A108BB75
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 11:34:27 +0000 (UTC)
X-FDA: 84402937374.13.CC0733F
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id 84DA31C0004
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 11:34:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=e0OBkJvx;
	spf=pass (imf21.hostedemail.com: domain of 3P92BaQkKCFQw74y0DK372AA270.yA8749GJ-886Hwy6.AD2@flex--aliceryhl.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3P92BaQkKCFQw74y0DK372AA270.yA8749GJ-886Hwy6.AD2@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770118465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FR/i+eARikPdIZxYew6is+8VLxNQJTGYF2f9lrQ3EtM=;
	b=3+BsYueWsqB21vYPoyc61xO3XDmgq68Os+p/5u1LoSMa2KlN8wDkwJW0jOSc7hh8c3hQm9
	xGF5bgrh4L+I/UFFBc2IBjrzsdB12E8XqrBwRQ7xj+LXGXvD080imT8YNVLxfQfOJqe6Mn
	5GYTx40oM6taAyLlu00k/ITR9BMuxQc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=e0OBkJvx;
	spf=pass (imf21.hostedemail.com: domain of 3P92BaQkKCFQw74y0DK372AA270.yA8749GJ-886Hwy6.AD2@flex--aliceryhl.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3P92BaQkKCFQw74y0DK372AA270.yA8749GJ-886Hwy6.AD2@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770118465; a=rsa-sha256;
	cv=none;
	b=w69pGMKVNi+Xt9Z5w2l+iey6K52DkCRxM6h3QnBh4btyFF3p8BfxlyydCJNn4PlstVdSnt
	60vTwGqYvhSxTe014emmtRJBDqfKeStZAfGIpQfNwTtGCn4hFgwaH9ggkwdVu5+OXbPl5v
	1Gec3FLqEJzGR77SiqRl5t3Ki8MCczA=
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-65932e533daso828403a12.3
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 03:34:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770118464; x=1770723264; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FR/i+eARikPdIZxYew6is+8VLxNQJTGYF2f9lrQ3EtM=;
        b=e0OBkJvxO3nc0U6jiMjqvT6Tvsoc6W2wJ0w/z7Yxyv+ZE0EmkkjQiVLeJJX9YPi6sR
         Y4lczCA6KrkpITyCAfHz664m/f8AyRnhtkgRVcClO5y+UGFzFyPLQc+QNFFsrK990w56
         oMuH4zznwgQIw2QLMVBmCRlVHaYfP9F0m593Yn0eldGfrXsktdt9OLDCehnzNm+HrraG
         SIR0UL6arr7VDlpCWxs1ChkU/B4aa7W3cntZ22JWw1tFUUMhCo+AdL9q+RKmiCTTKowT
         /hJTe3RuSChkYNSUa3G/xmGq3vZV+xLg0duWDWm7gCPimqfUp7/bnyR0LlBlexMWWYlw
         nGHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770118464; x=1770723264;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FR/i+eARikPdIZxYew6is+8VLxNQJTGYF2f9lrQ3EtM=;
        b=ebWRNnL2fO55O6Fq8k4rsKJDF0xzDc+B9rEcZr2xAza4b8plQ5cO7yiWqmBedsVjT0
         t5j4ktI/0Di/azldj6PmKK/k4IdouTrf2v8ase5xqj0Qdh6+sWysSmlw5rli0CEchHh9
         zR+6k+8B+XxRLsGwHKiv3G5tQawAaYhM0nkz/4oJZ8iz6ZfZMs3JkPt5ITPB/iPCKdGE
         CQ977faIgfaajeOtGUf/2E7OelxGVvoP9crKjWKzR2uq17G2M6YEnMY0ux/I7KapXwZs
         epQoiXERPDWtXPb80k1DEs7/wnyMfh3pTs4GUimmjmxubQzD3FHT5s5jWZn8AvHP1oIy
         g+9A==
X-Forwarded-Encrypted: i=1; AJvYcCUxS0CtZLJQpF8IVGiy2GjD7bzlkhOTN+iO7Mm6j1UXY5PwnuWkU/md6goaat63epNQ4ftLSV2M1Q==@kvack.org
X-Gm-Message-State: AOJu0Ywj3En9KqYlb+IMuXD7NfzOApn9LH7FCg7LTL/zJXLgC+7audT/
	CeMrtXJlPJTluyRUBwe7/xabJ5VbjmThD3Ej+InEpyT0OsQ8MEeFs3xYUgU/HtHBXqIe6sHujKh
	JRpEFN394G2VcEl5boA==
X-Received: from edck20.prod.google.com ([2002:a05:6402:3414:b0:659:31dd:52cb])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:2695:b0:659:4383:c491 with SMTP id 4fb4d7f45d1cf-6594383c6bfmr200660a12.33.1770118463947;
 Tue, 03 Feb 2026 03:34:23 -0800 (PST)
Date: Tue, 03 Feb 2026 11:34:08 +0000
In-Reply-To: <20260203-inline-helpers-v2-0-beb8547a03c9@google.com>
Mime-Version: 1.0
References: <20260203-inline-helpers-v2-0-beb8547a03c9@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=1712; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=FzzjhSQNQHIbmcapK6yaktEju2IYPpFJD84GeqRslPI=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBpgd09+3ffdigiyO2/yaYtXtLiJKV4JefwxHsD6
 g8QYpJOBz+JAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaYHdPQAKCRAEWL7uWMY5
 Rn3ZEACPLsut+e2SxZtW2kE96JBHj9IsiPLxVorIorli9qVvROiAeojumIiArRAp1voBxa9BiHF
 LWm7/7tkVv4Pb5qS9HYATKtorNFgunu5fSYL+Ybvytw3bTpze4jLe5qV3lgnOIEGHkjYr35i9b9
 se6vm0FtXtYcFLV3cIz+TnswQOEUo9RnwLzPLlY6U3mzKQk+DIQ7J3c8p/9Z5SCvSy6dJUCSJMd
 TjqQZ780e7J87CiLHFqHLabrjyMgdzBQjumAEdUJtXT1lSjJyky5JjOA8lAH/Fc3zie3LoPMXCy
 0OZfvtxwd4uET0cX1OszPfbBV0wMNlL3RejRdb0SZoXDS+2e8nPT9EFeY7wry6jXsEYIj0Ars+o
 XnYdBzBqXepyP0wVxUX15DwlpGtldajTPlVNcgP+tZotK+vqXYRRN2p9QjrMZiENvc1Q6bLmVyF
 D+KGm9tuJgKaCdLi887JUpYshggFLO0lrvJGGZb5eCFtIAdAR7T/LrbRGxBomcERILGtXbQHeuR
 1EyOuFeN9V2sWEPS35jlR41VCeY3DIU5+G3zg9eoSguH2wzcQ6jYTyVy75DhBv8loGVQYV9f6+M
 JDN4EOaLwhbxIro5SFcjPzVDMPxxA48Q4QhyWXri+NX4Dm6NHKDX42CavrWJTc/eX59WGZDKuOS 8wKBxTR4AClAIeQ==
X-Mailer: b4 0.14.2
Message-ID: <20260203-inline-helpers-v2-1-beb8547a03c9@google.com>
Subject: [PATCH v2 1/3] kbuild: rust: add `CONFIG_RUSTC_CLANG_LLVM_COMPATIBLE`
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	Nicolas Schier <nicolas.schier@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	linux-kbuild@vger.kernel.org, linux-mm@kvack.org, 
	Alice Ryhl <aliceryhl@google.com>, Matthew Maurer <mmaurer@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 84DA31C0004
X-Rspamd-Server: rspam07
X-Stat-Signature: yfotocnftty5ojj9yxcruqjjxef9c5fy
X-HE-Tag: 1770118465-152265
X-HE-Meta: U2FsdGVkX1+817T6pvDb1HndJ5llzBsr0UAxXsftQcxqyyvljj56G647p55TcOsyIQxFAtgOLdg+A9pxhCIfSfWXzN5arXJBfMlbEHPu3DenwHG+h4VgsDsHt+LC9mt76sws5PKoirwq64hIpN4ziB7mYQNQT1o6Mpt7NAYPVjyeN8gC/Fq9IugCxqUg411hUYT0MHEPN6LuOC3AJmswjQanUA9BBTFSOmGLpygyD4yXzXdGB6unijJ812iVnPEt1OaN4nCpZdnsnH0Ax8m/RfVPC+p0lIjDZtcozVbq+pE3ZDXGdwtFSdVgMrk16l0iLcCnu+sphowW/hmo8FEomtC7nXHHzBhuwK7d7FDY/FIswyqJhjk2qwqz/KXI6+lu/V0r8DEp+V4wakEtDuMprInAVkvsz+09bsh4OoXeMWboIGIiyHvuzWSsgGD7hFCeN9EqnOsn/s+/MKEk+9swy8384OehAW92NLHPneXRK56m8u0Zn5iXJ9rGhnWc78ZKVymKdPMFUziQo20O9sknmua+IR3e4BuUrlY/a8h86oLnAk0YjqdBynWUCJ2hVaadIqd6yw9mcdOS9RAWESPNuQ95aDk9j3Rbqc5YrG3WWWaoaH3q0y4uRirdUBWSJMNpRnVpGlFEIVcgORkyQwdRKkU3kou6vP3HYy//cD/PdqGyFjbdS/iAyKza+bMxfwfUo2R4hAocqyy+q9DbPBRssuE38Q4L8EmfIWxTl9FE6uBF05NFp5m4sPgjaBKaHZDQAFEnRBMlSvASBXFLpBeKBkF/bY3/FJX8ECs4Emi7LWPFeEMMqAUVYZrI4eAfSntYxOLqEJdWtL1roCEz+t67qcgb96aiRDe/Y9eP7ZUIfjJmOjarzV84j2Pdaer5sbAj3MAmhqPqgYF68vxf+P5Bkl7kIwlKH/N7FnC31K7dFIxL7alzlYHOulqTy4gyLPWZfaH+DAUJI250vXlVGdY
 AUB2dGDM
 nLhRT90m2Ivr3S5Fr7H/6wnvXHqKRK9rtwayf/MJCWVLIPYgCYoLB/S1KY3NPqJ7d/cOjPrGtY5m8s7st80SfabkaP55WHc5tQY5wLVZniPVW64ozS6ewM+MFRI4mD8oztlvcwHaUtrvA0aFfZVLiSfIXn1U3KpGuOoTIke8cGrBeH1hzJHm+0/z9mefEbERspZ7R8PDSyo407MFF8btC2+ZLR24bpz3H+KejU8geCkobsNICZgQLOL72YNUr2B2+15GIlKzfQvyz2wbQjuHbXC5cG0Nt7r0TPrwIkEHhQXzreisY9L9NK8IYVi532eC2RTixcwQVVS0VrOPjzVxz3E4FtBenAgz25mavYuc2OLHc0r9TnBvIU0KGFfNGr8ij0t5r2RPwqdV/A1GYM/0y/pax6MrnEZe4Xo6BD4m3qPCngTOA5glh+uzzFoB2icSgF3pGlSdW9A0xByyA+zwhe+ImRonVZcWdMc4/WId+4SMRrGY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Gary Guo <gary@garyguo.net>

This config detects if Rust and Clang have matching LLVM major version.
All IR or bitcode operations (e.g. LTO) rely on LLVM major version to be
matching, otherwise it may generate errors, or worse, miscompile
silently due to change of IR semantics.

It's usually suggested to use the exact same LLVM version, but this can
be difficult to guarantee. Rust's suggestion [1] is also major-version
only, so I think this check is sufficient for the kernel.

Link: https://doc.rust-lang.org/rustc/linker-plugin-lto.html [1]
Reviewed-by: Andreas Hindborg <a.hindborg@kernel.org>
Signed-off-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Matthew Maurer <mmaurer@google.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 init/Kconfig | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/init/Kconfig b/init/Kconfig
index e95d43457851862afc8313389777e4dd9348c178..0e900d3d8be7874a33e0f44754a8d038e68d7e65 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -82,6 +82,21 @@ config RUSTC_LLVM_VERSION
 	int
 	default $(rustc-llvm-version)
 
+config RUSTC_LLVM_MAJOR_VERSION
+	int
+	default $(shell,expr $(rustc-llvm-version) / 10000)
+
+config RUSTC_CLANG_LLVM_COMPATIBLE
+	bool
+	default y if CC_IS_CLANG && RUSTC_LLVM_MAJOR_VERSION = $(shell,expr $(cc-version) / 10000)
+	help
+	  This indicates whether Rust and Clang use LLVM of the same major
+	  version.
+
+	  Operations involving handling LLVM IR or bitcode (e.g. cross-language
+	  LTO) requires the same LLVM major version to work properly. For best
+	  compatibility it is recommended that the exact same LLVM is used.
+
 config ARCH_HAS_CC_CAN_LINK
 	bool
 

-- 
2.53.0.rc1.225.gd81095ad13-goog


