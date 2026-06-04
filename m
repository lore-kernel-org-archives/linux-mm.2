Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C925CD6E75
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 20:00:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7372A6B00A0; Thu,  4 Jun 2026 16:00:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70F1A6B00A3; Thu,  4 Jun 2026 16:00:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6252D6B00A4; Thu,  4 Jun 2026 16:00:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 516D76B00A0
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 16:00:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0A8941401EF
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:00:30 +0000 (UTC)
X-FDA: 84843297420.30.D2C7E54
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2922BC000E
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:00:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YMZXcHdy;
	spf=pass (imf10.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780603228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fd/k5LqIbLv46yCRlz37IXicy6JxaNgtHGX4tpznu/U=;
	b=XwCVNqffkYo4SBF8ktWUsnr6E68uu6G9cY/n6Mp0ijQw+1Pjn8hNkOzXCDj/4DKdj7+6Cy
	QykOKnKuqVcfBvLlTQj8EMTCPxAdFOPJqfCoUa+DtUzQTbtxqYGDs4hT8mNxOG+S1cBmyc
	stFN+EgkHrnGbqN1qG+Oar6fFu7thyY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780603228;
	b=kKf9AEm4CJwQp06RJCqbb5dH40oyAyEXX7ESftPM8/Ri+vkHLeCE2PtAlFCieFN+a+owQ+
	N0zM/RtMsskU2NKQ+u0a0RXYvoWS22iJD1ix707C8a/yctlT9Y+ynQQttAf9VpLXdbhNNa
	cSBwtD3iM7KDV/TYyPEg5s/sv3HufCc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YMZXcHdy;
	spf=pass (imf10.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A1CC0601FE;
	Thu,  4 Jun 2026 20:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7471F00893;
	Thu,  4 Jun 2026 20:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780603227;
	bh=fd/k5LqIbLv46yCRlz37IXicy6JxaNgtHGX4tpznu/U=;
	h=From:Subject:Date:To:Cc;
	b=YMZXcHdycyl1vFUTeea9KEW5ZFLw2JZkqqjOGdua0xinS6++U/AMB2WcaXl6CRNhC
	 guUIVe/oU7zqkMKEScwAdKq1eRlDbPqnF/+DnxHm89jgqRyg6xT4M0slG+KW53rglR
	 I7r4drz7I9kHCW/hdm/TEUpdlhFcpRS6UmxDJX7tq6dpbiTG1Zymh+aNGbigtLbV9K
	 Op1DQe6FqPQLaOp8Z48G79ydwGSHAACKKqzb0c3lvXYVm4hXmYhkUticZ+lrt4xaHi
	 UqzIeHc5EZIkEd+obxeL3rZ/hfhO3ByFpWn8JDwtmR0TC6N5LxJSeTTGduIdOjKUju
	 V99lyMP6lTomg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Subject: [PATCH v4 00/11] rust: xarray: add entry API with preloading
Date: Thu, 04 Jun 2026 21:58:06 +0200
Message-Id: <20260604-xarray-entry-send-v4-0-965f6028790e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAM7YIWoC/33N0QqCMBTG8VeRXbc423SrrnqP6MLmmY5ixpmII
 r57UwiKpMv/B+d3JhaRPEZ2yiZG2Pvo25Ai32XMNmWokfsqNZMgCyFB8aEkKkeOoaORRwwVB5A
 KHJg8R83S3ZPQ+WE1L9fUjY9dS+P6ohfL+k/rBQd+xMK5qkBlHZzvSAEf+5ZqtnC9fBMaJOgtQ
 i6EsLnQRrlK/RLqkzhuESoRzhhjdXE7lCi/iHmeXxFtBj05AQAA
X-Change-ID: 20251203-xarray-entry-send-00230f0744e6
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Tamir Duberstein <tamird@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Tamir Duberstein <tamird@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Harry Yoo <harry@kernel.org>
Cc: Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Andreas Hindborg <a.hindborg@kernel.org>, 
 Daniel Gomez <da.gomez@samsung.com>, 
 "Mukesh Kumar Chaurasiya (IBM)" <mkchauras@gmail.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=4517; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=m2nut1CnmlF3CpCYMbwmF4eplRVce9hUJzZQGpptppk=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqIdjmpY3yzSrA3ej8GL9utWAxWX17GqFr3hC2T
 QxaPfA+bYGJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaiHY5gAKCRD6UCkIqsW9
 0GoyEACspTlY7QDHdWN3qFyJYz/nLDKTHKqH7zPguJO9UZrNRhs80DcztHnYwaV+KXEU9EFpkTW
 h7JrLCKV4Pj2irlD6Z/YDQNBLshojvtmhDEkZ/Jlki4hY+bylWj+AjNCcjZiICNC4ET4p4XoMhr
 QBUHokSFfOCrfUyvFqAA6Hn7H7ovGzxiV1jgRWsj4sZF4MCnnkOhdrw01wcc0gzR9riOBn+OEWQ
 l6tz9ZxDWmQLUCoGFLDDHPaWCQDjIU8xOpRfjdfwLVIqUzXp8qwO8rPojzCRPvYXvPgUGTlChOv
 duHQgEN3FgK3Gc9+hacx36+HOsxytmgY2uuBqnL7fUjQjmsaPAsLbdXhsLbVec/KqctgCbHjLRO
 6u3WNyKnErkcXeetWX07jTu0VGDek0I4rYZykqzE+157X3RYbFfPtIw6JnfzfunSh6xPv9qqLnI
 OfQjPda+SXMmivFowz1rq9KCkzOzh3ZI5tL8Bt2Iou0UtB8zvJPRjmhUoz10jtyHYfAdgHb+l8A
 CqbpfpFQo34eTQP40mUZy5s3dUMEhw5uCInH7aCOxhsAtyAgisN/VD2g9qVPpSvl64WEZFKlEzJ
 BObufIBKwkNL05fXzy5J7IMiBtJgN3HDs2Z8yN7Dhh1x5J7n3gVMddUSMu63gKmGH5BbFrDZ8Vq
 VE1vqihTUea67uA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2922BC000E
X-Stat-Signature: kzgsbx58187yng8ro5x34ihcnbwoh49x
X-HE-Tag: 1780603227-496551
X-HE-Meta: U2FsdGVkX19JhPQMTh4zL8HlGcwah6Kaycg7py+pQ1ZefsIbt0aaOVRbPK4+jCI4z4GwSWclnienJZ9qm+Et+xucrhflm+AEGLVFPX26hFUyYV0/hJG1PLdziYg5N+quZbsxcW7gMkGK80cAZNGCZvZigrX9KrZpRkPVHEMSAZ+zclYrsVFds9IOsUXqG8PndyMZhW/0R6/ykiJTNR8jqrM2DIvFBW7os9A+ZEWxjmEveWEk4rNQSxe5htKCb2pcivkPTvmvCyOkaDVKQl7JVD9QeY9BJt8VsKsgQ1Ymp9bPolldny/ElpGrvvRtZAD4GOrrH9AgcuTHs1ligos0U5EJEDTp6bkYc77es5LZICvz7hSfGlqzGWBMvJZxUmHw1eUiuA0UNnFJQW2zQPleoVFgUV5bmQXBFpfv3bvkrsVYCndMUAMcG2xBFTPUdArAaVmXzCLoLchVWuMYNHuMmwB1Eh7eaNAAgzCM1b7Onj8IjbDyQo8aD+v9RqVaqY4RjEdWaBDZ9FBjND0VBfmOv4jBNOHxok+gg4NiGqpvTnvxf4BIEPR/Gzy4mY6IbQXstbtzHUwglKAq2JgX2zqaO2Zyhted1eVSb5xsTdqChvCvSgP3qAEz0/rJNso+PkQLiUNAAhND2B42qqtdMYnbw56unfQO3nyx/opMSiNkVbxfTMvCuQA/zednXsE71A8mNBtm2+Sh+U2O7l0VM3I+0FVYqWa+Kwf3Zlgijg2sV3QfAMp/9AUmAIJoGJ0oJibExiEFsNwxVrShJUxYYCbUkN/58m80zdyPytVTR3NDjNYiiE+Wvl5UfLkY/YRoxgMSJ208h/exVy5l8elUSQ8ZJbXR+ONYE+PEYx6yw+Zk/j4HsvIb5h4s/uFYc+FpzfZQ7M8H6WE95gjtvG8ZWtIr8DaTxZP+SkzQda+/jiv+YgfeEnsdS6bWql+wWwGdDO2cxNycthSWHNnax0qPC53
 GSeXQods
 bNXeTbO4qgt3YkUFVPByIiSlOdcIBCtJBcuqFX46BT7TrCf7SRgmUsjFXek7/bX0KvIFILaBCALwgObEvVKPbApPYmBt8qVBvLY9ZT2M5Vf/AkKC5KFHiuXKvr34GmlYDyrta5ibe7opTRioupstxKFwzC1c7Gg0iVYJq9Bt9DInBhTSfzejYywEPT+ZHlykw6iJAUNMEEvwCgFmhGXcoIfb8WFeVa9zp0LIENP5KAnnBB8Jun/+fMQYJJCP6xltX3KbyJuaAu+4PGPO1CTqk0YRXvLGi6lRG1Q5ZIE0EQO8ygia4Uz585B5fEe5nwN9ahOiLOM+v2C+xkNArtkYfqa7jRDYrxTxVqifSpJ4NzQe/fq9O8GJbbphkdeE3FDmnVYRyihkJ5n4wZ70Hd5BAessE/A==
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

 - Patch 3 adds an abstraction for the C `xa_state` structure. This is a
   prerequisite for all the subsequent patches.

 - Patch 4 removes an unnecessary rcu lock in `xarray::Guard::load`.

 - Patch 5 is a simplifying refactor of `xarray::Guard::load`.

 - Patch 6 adds two new methods for finding items with keys that are larger
   than a given integer.

 - Patch 7 adds an entry API.

 - Patch 8-9 adds support for object caches based on sheafs.

 - Patch 10 enables sheafs for the xarray kmem_cache.

 - Patch 11 adds preloading to the new entry API.

The feature additions in this series are dependencies for the rust null
block driver, most of which is still downstream.

Best regards,
Andreas

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
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

---
Andreas Hindborg (11):
      rust: xarray: minor formatting fixes
      rust: xarray: add debug format for `StoreError`
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
 rust/bindings/bindings_helper.h |  10 +
 rust/helpers/xarray.c           |  17 +
 rust/kernel/mm.rs               |   1 +
 rust/kernel/mm/sheaf.rs         | 690 ++++++++++++++++++++++++++++++++++++++++
 rust/kernel/xarray.rs           | 502 +++++++++++++++++++++++++++--
 rust/kernel/xarray/entry.rs     | 396 +++++++++++++++++++++++
 10 files changed, 1605 insertions(+), 38 deletions(-)
---
base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
change-id: 20251203-xarray-entry-send-00230f0744e6

Best regards,
-- 
Andreas Hindborg <a.hindborg@kernel.org>



