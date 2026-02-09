Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2513DE81BCF
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 14:39:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FC186B0098; Mon,  9 Feb 2026 09:39:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DD496B0099; Mon,  9 Feb 2026 09:39:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F31F6B009B; Mon,  9 Feb 2026 09:39:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 718ED6B0098
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:39:13 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1DE4D885B8
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:39:13 +0000 (UTC)
X-FDA: 84425175786.07.C8FB5F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 674154000F
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:39:11 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mp+BNpzq;
	spf=pass (imf11.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770647951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=g+Yx5kzN+BoAliCgAshE4PVjInV/W92oMqjNitNETcA=;
	b=dxVb6EHBKm3jR/jnsASzbFjZHz/aorhga/Yy2Rw/gKw9SIJLggrqBS8Qmccg0HKwSqzAJI
	A+3R1mT8ydYREsFwRiXm6bbY+8z8AJzhXTBbzvFVIhp1Ov+qwnmbbyNwwx4LFdAdmRWKKq
	nr/nrT7xP01WbJSNOT9AVHkZRBfN94s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mp+BNpzq;
	spf=pass (imf11.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770647951; a=rsa-sha256;
	cv=none;
	b=yI8IYEvrCD/XpVpMOGFKFyzmeAKclinNt3h7KxgHysDySTHYM1HZxrQU2iPFVCfG6iNHCZ
	11gLE8KkSUv5ude4ICU8M8MUulKxanQTczTGaNE4Uqz0IgNsgoJ7FOelLInr+ttycEoFzw
	r2fqPLwTvIKPnKiKTY+3uFZWnVSD42E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DB30F600CB;
	Mon,  9 Feb 2026 14:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3FFC16AAE;
	Mon,  9 Feb 2026 14:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770647950;
	bh=aZgm3JrzwrH+/c4V352r00JutABZvAY4qq4x9siRb6I=;
	h=From:Subject:Date:To:Cc:From;
	b=mp+BNpzq+q1RFuU8XHVdLMi3zYUlSP6WoyLXdjXmmEbR6+myKjXG8e2Mu0VFLZrLl
	 OrFQtXMPBwxUkSss1dO4YSRG5p6mtLotBca9UG9lTVdX0VqcULFkPsGt3C60Z0NSM2
	 xBfD/iRSDd3ewqN7zYCbCBpOcj+Wee/I8GeCugndtGbVPlZxmaOdKHFyOMR1Ou+KEQ
	 IbbtMrP55xBTMRD+1LMo79VZE1d64+h4QnjQgVNYZ+2CQZmHzTb2Lp1dMmyEu3ixDk
	 S7PfLyZMdMTJtMBPOj2XdUOPY7SjRKc5I2bxqtPRS9UqW0uGqY4/zD4P1KUqzjfspo
	 6pKSCEXZfGLlQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Subject: [PATCH v3 00/12] rust: xarray: add entry API with preloading
Date: Mon, 09 Feb 2026 15:38:05 +0100
Message-Id: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAE3xiWkC/33NQQqDMBCF4avIrJsySTTSrrxH6ULMRENLLBMJi
 nj3RqGLQunyfzDfrBCJPUW4FiswJR/9GHLoUwHd0IaehLe5QaGqpEIt5pa5XQSFiRcRKViBqDQ
 6rMuSDOS7F5Pz82He7rkHH6eRl+NFkvv6T0tSoLhQ5ZytSHcOmwdxoOd55B52LqkPYVCh+UWon
 ZBdKU2tndXfxLZtbwtBdlT2AAAA
X-Change-ID: 20251203-xarray-entry-send-00230f0744e6
To: Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>
Cc: Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Andreas Hindborg <a.hindborg@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3891; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=aZgm3JrzwrH+/c4V352r00JutABZvAY4qq4x9siRb6I=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpifFRYBGKmArriW7m0tjGOwIQiKXauLPcfzmmM
 9OkUlG6FpuJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaYnxUQAKCRDhuBo+eShj
 d/sKEACzosocQZApZp4Z+WeJv8zjFZ6SG06Ld8hlJv+P7SPSjmD3N7oxShDkK4FTLKibr0uDVOu
 kHnTPehXQ1ihIQ0P7cJx6FqI15isNWm/+kjdaEzpZZcpjewrUpHESB10eGtkY1k4L+NqPumgQA3
 JmDKms7FL+yqzyxgJ6lws61IKBiNSIJmwt1YmOGPZkl9VDch6EUVdRT3O+LgF/Tr/1Y6DtY0O4N
 Gyrpua8bb8UyjmNCTm5XC7dzg7uQ33Cxa1c/eygNHszyEgJTYKi2Nip5uJL7Bm0K9T93ClfomhF
 lc6HC/u7ILlQLKB/VE94suncWbqezQejYdkSAlKNOoSVidq7fQoXVyjIC1YLf92UdLFzlUeVw64
 S6gn35DFnsGx48ZWrxKwBcGoL4F0C4KOFyYHozn+ubimbJyuxJDd5E8NzU3YQE6P3C4C/On6FhG
 9QsHhxyxaWXfvB7bY5gJR2R/aLpOmnfcQUvttckHkkkNv0ov5yKVvLbtosXja3A3hEW1XlW/iIC
 ahbZir+Eq+Gd3SQXQcWpvnfbYJ10a15clJEYvVyt51xVWR8V7aM5L1CAIDVMsfbhonmPZfz8Mwp
 2XzuI52DAnKJmiCCvsoRbxKbJLITxti9Uy37i1HwH65RiQRlAy836MJEWGhkHHWnou6VkzGnQdA
 0aiOIXn8+mwZnKQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 674154000F
X-Stat-Signature: ijizgfbawp5wcsmqouirttwi76wrfaku
X-Rspam-User: 
X-HE-Tag: 1770647951-601559
X-HE-Meta: U2FsdGVkX18A0+ccfQE4j58Qlxg+m45OFdOOBXiYFmYgBv/ykoRx1+9agvudogX15Puzp+s1Iq+Wvn/FhH41ZgVx8ud/O4fuYoF6/a4RgaiwIAfuFyqlhvyYr0pOxjbB4yww+RS25h6B1TLN6jMtPHyInx+/lblfC6UAwOrpXyhTp5sQPbeQeoiZPYXSnprZ2es5JTcYkIbEzfFo/OIiha5GYCOAbiAb/Pt+XiCNzPTkh/bi+dOs2CM2LEQBkcZ5p8+qQSGifI8yp6uR1M73Ts80mNrreApl190jPh3VfygrmtWrfwJrn82gf/y09zYpaIg9mjMM3wKa0nDvMNL7HgiW1/wL1tJ5VHwmniBSP0s5dyjpEEJ+hJul2zO9kghECDPxlsg3gIn3xqRXlTW1xJLRS/oZ7GNy2TA/qxLmGTElA/0yG6t293uGmdf8ouQQ1umlnGSvhRFq0bsMYqkNnYZBMnL5BW182Wv3HgrCIKqvrALADEqFDDxJb2AghN/hiSbSchvSK5U1/WEyJgPr5H7+AJ0FB4zaK5MuxJS4KJvgSiXNaZs9RMAiQH3NtNl4Cj9VEAtml6x9A9wkQoTEo7Xolp2r9iIErJ/pswC4PVoacE7UHXwTk1RYmvIRlXiY+3f1IKFPfDuTLRbdTlxvc/dABq196Pk/Cz4B9EI7Wij7VDUaFahgTC19HN9FKVE98QIUL7e8m/kZuZZZbLJxP47UNmr1VKSQTSANWpzKZhSws8x2Coo+/f4T8rV7rA2AR1fkGAp6Sb0fzcWX0SMA1PaSnyqKhWuh92fB8kNHJ5wzhALocFP8a8KOKfDLzJ6zTAofmntzVS2MU7gxhwCG/Kb03Vgozx+bkvckOSxtW8kmg0WHFBwHu+72AFV4tio4mxZ3sF7jfbjWCJdF6+RE9l5kih/P1kYRgJuBWYR4epuH8LPVa3B9Vw/z/cl6/hZiwEOaQkC4TuLWpfM6NF4
 c5ScFeR9
 PUiF4w8TxnaHcDsdB1XbCDqEukVgBD6LRo1mFEVobKsd+Azn93QN8clO3W0adnZ1TK8UGmXTU5w0Zy5fbvc07wunRi/ogEkfWCxthbwsSSjdG16L2iuh2cEeDfhebkygIG5rn6okS5e7rfvtisuiMD1efLUGUnnvzHxSXuwd0fMDt1WYSdu54oSbgk27zoehhXRtEB/MfupifUXCV0DwQr6ISLrzYYhv7iPXrHzsZJstJTq+JaropCZCTvMuHBWMuJYlAoSVhiU7UG8yBYmMo/3JpvXm+D6WtL7ZgfLtem5LbVJsOmwGtkusoECpehXsY/xFCZtzzsXHc+rLTEGwH9gCUpjOGrL7srQOhQ/Vvqhw0sSmBb4vjIndDfvTld9abnM1qx7xk9dHSOyJzGXD3IU4dcw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series is a mashup of cleanups, bugfixes and feature additions for
the Rust XArray abstractions.

 - Patch 1 starts by fixing minor formatting issues and bringing use
   statements up to date with the new coding guidelines.

 - Patch 2-3 add some minor convenience functionality.

 - Patch 4 adds an abstraction for the C `xa_state` structure. This is a
   prerequisite for all the subsequent patches.

 - Patch 5 removes an unnecessary rcu lock in `xarray::Guard::load`.

 - Patch 6 is a simplifying refactor of `xarray::Guard::load`.

 - Patch 7 adds two new methods for finding items with keys that are larger
   than a given integer.

 - Patch 8 adds an entry API.

 - Patch 9-10 adds support for object caches based on sheafs.

 - Patch 11 enables sheafs for the xarray kmem_cache.

 - Patch 12 adds preloading to the new entry API.

The feature additions in this series are dependencies for the rust null
block driver, most of which is still downstream.

Best regards,
Andreas

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
Changes in v3:
- Fix a misconception about sheaf availablility under `CONFIG_SLUB_TINY` and `CONFIG_SLUB_DEBUG`.
- Add missing patch to enable sheaf support in xarray kmem_cache.
- Update commit messages for last 3 patches.
- Link to v2: https://msgid.link/20260206-xarray-entry-send-v2-0-91c41673fd30@kernel.org

Changes in v2:
- Rebase on v6.19-rc8.
- Update the cover letter.
- Implement preloading with sheafs.
- Investigate generating RUST_CONST_HELPER_XAS_RESTART as pointer -> Not possible.
- Correct wording of commit message for patch "rust: xarray: use `xas_load` instead of `xa_load` in `Guard::load`".
- Correct wording of commit message for patch "rust: xarray: add `find_next` and `find_next_mut`".
- Remove last patch (lockdep static key fix) from series, to be sent separately.
- Expand note on why store to occupied slot cannot fail.
- Change signature of `OccupiedEntry::swap` to match core::mem::swap.
- Move // NOTEs about storing NULL closer to relevant checks.
- Move `insert_internal` to `XArrayState`.
- Share logic between `find_next` and `find_next_entry`.
- Rename `XArray::get_entry` to `XArray::entry`.
- Make `load_next` a method on `XArrayState`.
- Move load logic to `XArrayState`.
- Use `PhantomData` to capture lifetime of `Guard` for `XArrayState`.
- Link to v1: https://lore.kernel.org/r/20251203-xarray-entry-send-v1-0-9e5ffd5e3cf0@kernel.org

---
Andreas Hindborg (12):
      rust: xarray: minor formatting fixes
      rust: xarray: add debug format for `StoreError`
      rust: xarray: add `contains_index` method
      rust: xarray: add `XArrayState`
      rust: xarray: use `xas_load` instead of `xa_load` in `Guard::load`
      rust: xarray: simplify `Guard::load`
      rust: xarray: add `find_next` and `find_next_mut`
      rust: xarray: add entry API
      rust: mm: add abstractions for allocating from a `sheaf`
      rust: mm: sheaf: allow use of C initialized static caches
      xarray, radix-tree: enable sheaf support for kmem_cache
      rust: xarray: add preload API

 MAINTAINERS                     |   1 +
 include/linux/radix-tree.h      |   3 +
 lib/radix-tree.c                |  19 +-
 mm/slub.c                       |   4 +
 rust/bindings/bindings_helper.h |   4 +
 rust/helpers/xarray.c           |  17 +
 rust/kernel/mm.rs               |   1 +
 rust/kernel/mm/sheaf.rs         | 690 ++++++++++++++++++++++++++++++++++++++++
 rust/kernel/xarray.rs           | 477 +++++++++++++++++++++++++--
 rust/kernel/xarray/entry.rs     | 378 ++++++++++++++++++++++
 10 files changed, 1556 insertions(+), 38 deletions(-)
---
base-commit: 18f7fcd5e69a04df57b563360b88be72471d6b62
change-id: 20251203-xarray-entry-send-00230f0744e6

Best regards,
-- 
Andreas Hindborg <a.hindborg@kernel.org>



