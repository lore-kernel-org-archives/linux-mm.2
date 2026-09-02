Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98FE7C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 13:27:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0920E6B00C0; Wed,  2 Sep 2026 09:27:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06B416B00C3; Wed,  2 Sep 2026 09:27:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E746A6B00C4; Wed,  2 Sep 2026 09:27:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B8B356B00C0
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:27:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4665D801EA
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:27:42 +0000 (UTC)
X-FDA: 85168899564.25.94EE430
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7F276100007
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:27:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XiaFhswk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788355660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jkSul2EjcgSI3SPsSrdHJvb3ZhsaeNQBXjGH2g/E0Lc=;
	b=VwtzKJdEcuiH9vbHZDbkYSmEEeL4teevq/uSvbaIllK/wWUKXZVlSVzYknvO47iSsUTuHn
	6GPQ0gX4OwZgSFaI7ls+bYjqJCLCMEniaPD+xYO5Z3V93Oc5u6bOBpbmu7NRpTF39/KNcX
	8Mag75EF1wVXtWripBiMxUJuD5tdaXc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XiaFhswk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788355660;
	b=tTg+P6kA2ecVMw2VmKWoE4Mu1flwg245v99c6Df4K12FGDPiq/ARS6cEbcCU4Ng34w4lAo
	96Mr7ZGIw+jGI1JmgMrkDUwwELeKgtUlTkBhgouCTxtezuK0jI2MueYjvd+PdckWcFVJeu
	7Nm2aT2h+EfmrDTCq8pV5V2NlY3ozkQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1F524602C2;
	Wed,  2 Sep 2026 13:27:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E50B1F000E9;
	Wed,  2 Sep 2026 13:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788355659;
	bh=jkSul2EjcgSI3SPsSrdHJvb3ZhsaeNQBXjGH2g/E0Lc=;
	h=From:Subject:Date:To:Cc;
	b=XiaFhswkNmEtRYy4zTDgrjhJ4ac1kZjk8A1qmTWUonShhKsjUO5sOSRY1wd5sQpE9
	 CQDraXt1K0PQgNWLixgUR3tnRXSGR8RST+yp2Dy5gLFvJ5DjU8YckEGK5ApSasobTY
	 rSwqD8EeWMjPMh8dQDsy7bS2/9ct7qn1X9WrV1i1FbV7fr6he5alh8N4JtJoJ50FpQ
	 haXV/A36hwGPMeVooIFQWk2Iq7NXtsMvA5ZFja3nbUkhtcUbIBa8XrJmkP5+BttNjj
	 rGlmHYTGO1r1kY0D+66wByX/thH7bNLm0fmqn9iEdCIyIdlfVpW6UDm/jaHpSedhF2
	 Z3uN+YYQTXcQw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Subject: [PATCH v5 00/12] rust: xarray: add entry API with preloading
Date: Wed, 02 Sep 2026 15:25:56 +0200
Message-Id: <20260902-xarray-entry-send-v5-0-d18adae40708@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAOUjmGoC/33OTQrCMBAF4KuUrI1M/ltX3kNc1HaiQUllUopFe
 ndTQVQsLt+D+d7cWUIKmNimuDPCIaTQxRzMqmDNqY5H5KHNmUmQRkhQ/FYT1SPH2NPIE8aWA0g
 FHpzWaFm+uxL6cHuau33Op5D6jsbnxCDm9p82CA68QuN9a1A1HrZnpIiXdUdHNnODfBEWJNglQ
 s6EaLSwTvlW/RLqk6iWCJUJ75xrrDmUNcofQr8JC3qJ0PMX1vi8UboK8IuYpukBmVv+jXwBAAA
 =
X-Change-ID: 20251203-xarray-entry-send-00230f0744e6
To: Tamir Duberstein <tamird@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Matthew Wilcox <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, 
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 Daniel Gomez <da.gomez@samsung.com>, 
 "Mukesh Kumar Chaurasiya (IBM)" <mkchauras@gmail.com>, 
 Sashiko <sashiko-bot@kernel.org>, Tamir Duberstein <tamird@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8307; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=2gggBaN9gWFRqCW71ohgZ3Z8jsBaFOSysGP+zefj+ak=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqmCQAujhljIQR9DNiTqKhWUhFba0p68fbt6eca
 C4wyVXTibWJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCapgkAAAKCRD6UCkIqsW9
 0GuFD/0VQwNVhrQ+5K3L6BmdnVOL42lWCckx55LEANmBbU8x3aTkak6jwwvxB3FXZlJ+NDYDdbP
 nkeWv2+HlVdjTTrD7fS+ljN6HBAZJoj/uoyeRuMSKNCFW2YqMkXWWNfWGKh2Nw2N4xfp+ipM+ti
 OWapLI8biK6IcDF5zCR/g3WjFX2csnlrnFnuDgcvtBzUsDWQmM5UJ5gIr7DO6QnLaUrnfz3q3mR
 3AB24lKsDE234nOKJU/55fIJV9UZqE3GGFq0BR7x5Ytc8NU40x0+txbiKXgbYeoF7zjgfVnM/W9
 ZxGZ9v/5rxJdVwTrHNW2CuENhQMuZtCzjPAowS5RdL+K9BZ/CNiVSbB6xcmAktpXAPKa4+8tMD/
 /qm67hBU5K0ZgmEHcNW7WjUCLt8FDsYNFBlAAY6HAl49n3FGX6pQ3WJKr/w39O+2k0YlzFKWNDW
 WySgnvjqeENvKYOKM2+1U3JknbWhijBAei8NcbNbE+IvyoBoswOmV9VlKlIql6yfejPaqLpBvj4
 oHh6yBzvHd44vlWpjqBy7eAZlcJTupnPtZJPE9eKHEhK1R1+tL4o05BTzWI1fMBCudUk10HC+M2
 U37btVmfughp5oitIjZF1cGowHtRBGmyqZLFcdxmbLEHbB3pWMlZr9HwTyR+YciuuAdtuNsbbjN
 MMzarp264ooNVMw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: d4fwhchbkzzoyqn3g9tqwd6fy3uttrka
X-Rspamd-Queue-Id: 7F276100007
X-HE-Tag: 1788355660-15142
X-HE-Meta: U2FsdGVkX18IcYOMTJN4OIBLjk5+4NvjmWn7q9k5CpOdN/D+8yF2wCGYiWsHQ2hU8nVixQQCcs9R721QpfhB4MK55ozsuqyGU72j8ICuQStrKdvP2KpBjITt5DXLF4MnJM9S6W5RaBYpXITTZ8MysTOlvE9Ezuc8iKKrcC6lH6IhFDDuTOBkLBamYvFGKpx/ZZdinQTFIUoptaBRiwXf03Qolulfy0ezFkKD1BW4FVLf+ttApAUgz+ws5JbHlz49psHvqqdPKFT/RhH4ONt6bwNbJ2iukVvmrQPUM9optOg4DgL8wFNsGTnY/dCDiY29s1eD/qGcmCUk5PllvR6FPT+EfOVIF5faZkq+Eq3ysi0lCXo0Fo5+zxYBIVHX/5LVq2Ohlw6/NUBtmnMrVUV++CB/HNeeLUlynPnuk68R/GHY4vUqLVfYfcLo5Qc1oPqStAvHSMi9rknxFTe9p3/9CaVNvLxPVmiI6MT2M74B3w8DcPIeP/QXlPJgQCFTZPk4zS9YxPeGnNaIg2KdTkF/u5pnyUSShpQfG8aIOENjT7JLdA4tTP4hkz6QJp8sy3nvE5cpCESB/tNF+CgG7QyBGtF44n8pdZi54j4rrkGUOG6ycF+dSquYnM0f4JnBjjclDZ8iyp4eq0ZlAvUOc/Y1ziyxL3x2O5nMhpgbhi4F7gUyJ6vOhgfQrTYW2w8wcNXCZRvEdimCYR0fRuNRRbZ9KoYrx/yJQWLqBLSBcoTdx9M2UAaDGjBEqnxN46jipk2Hr2vtH2wD4NMUORwX7p6ztbeOgyguvF4qu1mzrwV21a4tZrOwcPATyH0caGwwzqGLmlFHuaiksL2nhuTT7KXqwYuEqdw5pD48QeRC+I2D5ARKusxi8JBkMcMAvd6fBixJOr97RbtkvMBzW4XuHR4/D5VX0gMWpAyOwNCO50nY5gxGpNjIcCdwbD1gY1O4b1BLBZSf+7P73XeXoUaHQF2
 7P7jK0D8
 KNtujKLFLgXbOCZaPz0AcimtuEapMNDOQMakKk7Vce3oKJ+TU63w0fpskRMm87HVcsK1p5LDKNi+9Zc1TDO4/lVFiTUSRpfFPAOG05ovn5lzTNDxdguhXHADz9W9a1S4056iCb5HULjoWAtKhwYq4xlWPsG/B6CDJmZiVk9NV+HFLvNBvlIE1P9L6Q/lxnRSKlEHVd5f1afI/FYAk1Zdn7L6d7hoDo2zvtmgn0hmSQCpTqcbZQoygxwbfc0IxwMFcXQMjxtcvo7LVPU8tNFsckpmISXZ4FL4ZxgycKDEkXTlL1b/aSUt7YmowPqGiyfVe2v575my0TBAZfonFBQe213tg6lk+qqZE7tUZqES+pqeDaiNT2lvTX+2awrjnKRh5YE0+2g3Fy/fRw4UhyCR1laTk9jU2fLQqSPWpbQiY00G/kxJgkaM9DkleCVz99EWNOctZ4q7Bj1GZ7MqbRupypXmpCXMQ1PBhvAYmZfOMrRKou0Cnk+XbUogpyO9fPnRt9x8Mn/g4EtCSCG3SOcVCEodmeNmvNlJbR7q3WqmNP3fopPgFxyTdtjA6E96F3AaOxg4/lkxvfUqzVN0OEDhrjCP43CIJv3i8UiLt1tSH7n6lOWXrMb5rvDCXm2nWrtoaUMuE4ZAtRT0rcPNxCfdN2kQgZITyCifjnXcjGqoVvjW8m9Hy2qocnFBZjnjSqddvvSvdgKbHIr54Sf5ipJlIJOWtR1jKjkFyGPkpmXMuqHYsWsEyk/NTpfzOcWdD7ddzVjnTOfM+WribnO+ZySgY/UyY+DXyoQ7bf2hb6YK3kpA4iVMDygXqe/4tdA==
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

 - Patch 2 add some minor convenience functionality.

 - Patch 3 moves two static C helper functions to the xarray header so
   that they can be called from Rust helpers.

 - Patch 4 adds an abstraction for the C `xa_state` structure and uses
   it in `xarray::Guard::load`, removing an unnecessary rcu lock. This
   is a prerequisite for all the subsequent patches.

 - Patch 5 is a simplifying refactor of `xarray::Guard::load`.

 - Patch 6 adds two new methods for finding items with keys that are larger
   than a given integer.

 - Patch 7 adds an entry API.

 - Patch 8-9 adds support for object caches based on sheafs.

 - Patch 10 enables sheafs for the xarray kmem_cache.

 - Patch 11 adds preloading to the new entry API.

 - Patch 12 documents that `Guard::store` may temporarily drop the
   xarray lock.

The feature additions in this series are dependencies for the rust null
block driver, most of which is still downstream.

Best regards,
Andreas

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
Changes in v5:
- Rebase on v7.2.
- Update the cover letter.
- Adapt the entry API to the new lifetime bounds on `ForeignOwnable::Borrowed` and `ForeignOwnable::BorrowedMut`.
- Squash the `xas_load` conversion into the `XArrayState` patch (Tamir).
- Replace the `GuardRef` trait with a `Deref` bound on `XArrayState` (Tamir).
- Filter internal `XA_ZERO_ENTRY` entries in `XArrayState::load` and `load_next` (Sashiko).
- Add a new patch moving `xas_result()` and `xa_zero_to_null()` to the xarray header instead of duplicating them in the Rust helpers (Tamir).
- Require an exclusive guard reference for `XArrayState::insert`.
- Add `XArrayState::replace` and `XArrayState::restart_at` helpers and use them in the entry code (Daniel).
- Clear `XA_FREE_MARK` when inserting through the entry API (Sashiko).
- Reset the `xa_state` cursor before retrying a failed store in `XArrayState::insert` (Sashiko).
- Check for NULL before running the object initializer in `Sheaf::alloc` (Sashiko).
- Set cache object alignment to the alignment of `T` in `KMemCacheHandle::new` (Sashiko).
- Restrict the `SBox` raw pointer round trip to static caches (Sashiko).
- Implement `Send` and `Sync` for the sheaf types and `Send` for `XArrayNode` where sound (Sashiko).
- Add `#[repr(transparent)]` to `XArrayNode` (Sashiko).
- Document that dropping the last `KMemCacheHandle` reference may sleep (Sashiko).
- Add a new patch documenting that `Guard::store` may temporarily drop the lock (Sashiko).
- Import `kernel::fmt` in the `StoreError` `Debug` implementation (Tamir).
- Add the `__rust_helper` attribute to the new C helpers (Sashiko).
- Add `#[inline]` to small forwarding functions in the xarray and sheaf abstractions (Sashiko).
- Fix the SAFETY comment in `OccupiedEntry::insert` (Sashiko).
- Fix the `KMemCacheInit::init` documentation (Sashiko).
- Update the `Guard::load` simplification commit message to note it establishes the untyped pointer style for the rest of the series (Tamir).
- Remove a stray blank line in `Guard::get_mut` (Tamir).
- Expand the entry API commit message to describe and motivate the added API surface (Tamir).
- Collect Daniel's Reviewed-by tags. The tag for the `XArrayState` patch is dropped due to substantial rework of the patch.
- Link to v4: https://msgid.link/20260604-xarray-entry-send-v4-0-965f6028790e@kernel.org

Changes in v4:
- Rebase on v7.1-rc2.
- Drop `contains_index` patch (Tamir).
- Use `kernel::fmt::*` rather than `core::fmt::*` (Tamir).
- Add `into_guard` to `VacantEntry` and `OccupiedEntry` for releasing the entry borrow while keeping the lock guard (Alice).
- Refactor `XArrayState` over a new `GuardRef` trait to support both `&Guard` and `&mut Guard` borrows.
- Improve the `XArrayState` type invariant and update SAFETY comments.
- Document the `(size_t)XAS_RESTART` cast in `bindings_helper.h` (Tamir).
- Use GFP_ATOMIC when allocating under spinlock in the examples.
- Link to v3: https://msgid.link/20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org

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

To: Tamir Duberstein <tamird@kernel.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
To: Boqun Feng <boqun@kernel.org>
To: Gary Guo <gary@garyguo.net>
To: Björn Roy Baron <bjorn3_gh@protonmail.com>
To: Benno Lossin <lossin@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
To: Trevor Gross <tmgross@umich.edu>
To: Danilo Krummrich <dakr@kernel.org>
To: Daniel Almeida <daniel.almeida@collabora.com>
To: Alexandre Courbot <acourbot@nvidia.com>
To: Onur Özkan <work@onurozkan.dev>
To: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <ljs@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Harry Yoo <harry@kernel.org>
To: Hao Li <hao.li@linux.dev>
To: Christoph Lameter <cl@gentwo.org>
To: David Rientjes <rientjes@google.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: rust-for-linux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org

---
Andreas Hindborg (12):
      rust: xarray: minor formatting fixes
      rust: xarray: add debug format for `StoreError`
      xarray: move xas_result() and xa_zero_to_null() to the header
      rust: xarray: add `XArrayState`
      rust: xarray: simplify `Guard::load`
      rust: xarray: add `find_next` and `find_next_mut`
      rust: xarray: add entry API
      rust: mm: add abstractions for allocating from a `sheaf`
      rust: mm: sheaf: allow use of C initialized static caches
      xarray, radix-tree: enable sheaf support for kmem_cache
      rust: xarray: add preload API
      rust: xarray: document `Guard` lock drop semantics

 MAINTAINERS                     |   1 +
 include/linux/radix-tree.h      |   3 +
 include/linux/xarray.h          |  26 ++
 lib/radix-tree.c                |  19 +-
 lib/xarray.c                    |  12 -
 mm/slub.c                       |   4 +
 rust/bindings/bindings_helper.h |  11 +
 rust/helpers/xarray.c           |  15 +
 rust/kernel/mm.rs               |   1 +
 rust/kernel/mm/sheaf.rs         | 769 ++++++++++++++++++++++++++++++++++++++++
 rust/kernel/xarray.rs           | 599 +++++++++++++++++++++++++++++--
 rust/kernel/xarray/entry.rs     | 373 +++++++++++++++++++
 12 files changed, 1782 insertions(+), 51 deletions(-)
---
base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
change-id: 20251203-xarray-entry-send-00230f0744e6

Best regards,
--  
Andreas Hindborg <a.hindborg@kernel.org>



