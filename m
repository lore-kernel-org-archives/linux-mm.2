Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68406606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 16:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VTQfgtsC
Received: by kanga.kvack.org (Postfix)
	id 583836B05BC; Wed, 18 Nov 2026 11:19:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5342D6B05BD; Wed, 18 Nov 2026 11:19:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44A516B05BE; Wed, 18 Nov 2026 11:19:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F9976B05BC
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:19:39 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 729D0407DB
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:19:38 +0000 (UTC)
X-FDA: 85448750436.01.9C353D6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id A4D331C0006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:19:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VTQfgtsC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795018776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=eFrBCM7CPvXc7RORk31+znnK2wW3gMhHFGdabCbdV5I=;
	b=ILYWTT8Y7vs+abFC6uu+4n+A/mhrYZUdaop83SxCKbTXZdPILYHqVpVBrTA1SW9uo0yByy
	5OTckbyB5lGkv9PLu7qn94GhZdxu84kJ2XxZRElxm6UkYNuIe3I5ClM88Aq/BwADy+Bxgc
	8orXnR3Y/eEohV6wy/iaksbkkDTnxK0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VTQfgtsC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795018776;
	b=f/qeqmt1DdTPB/PIeKCm949RYILXIQqrfJqTGhMxBBzttDFTu31XvZlZco5i5uwyhy2YG8
	b8Stc3Iq5Fnru6QBeshqLcBUgQl/I/EVGeOhqXi6aTLiU8TSZttPtR4Gmud50ZAaPPW7dU
	ffX/7zp8RjVa7sNV6UWOe9/MvNVK0Rw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ED42341717;
	Wed, 18 Nov 2026 16:19:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ECA01F000C8;
	Wed, 18 Nov 2026 16:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795018775;
	bh=eFrBCM7CPvXc7RORk31+znnK2wW3gMhHFGdabCbdV5I=;
	h=From:Subject:Date:To:Cc;
	b=VTQfgtsC3yMr/ac3UB/d8JKsvf3GxsuSwUd7T6xGE6HYRuiUbk4U6Zt/eju9nrNA2
	 M/hAmvNbJsIcBiwkCvsvSVsckbguQz6nlYqE4DeNrF/oedoNgwwtFyLFpAgIRT0PTZ
	 fX9QCrlzeVEqGwmVah8t6G44/VgRFDX7IGl0uhd2YR9QjvFqo/jjSQnr4nWMZnOdoV
	 usXoyaYVm8I/qQEcZKT9mxZrBI7Dj+B4KnvN6zJ4iDtdR5Uw4yyUEMg6aalam/QJgx
	 l04MyCrwodC7o638fcVFuskV5VhCn3PB4THLcZn4mXTIo611J7S8KsC93NE3J8NIK1
	 fU2sb7Ihr6ZGA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Subject: [PATCH v22 0/6] rust: page: add page kinds
Date: Wed, 18 Nov 2026 17:18:16 +0100
Message-Id: <20261118-page-ownable-v22-0-d63ff73f4075@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMjP/WoC/0WNS47DIBBEr2KxDhI0BoyvMsqiG5oZRhM7MXYmU
 pS7h3ykLKtU9d5VVF4KVzF2V7HwudQyTy0A7DoRf3D6ZllSKwQocFprkEds3fw/If2xBA4+9Bo
 HQyDa5bhwLpcn72v/ynWjX47rg/FeLHzammh9zT6aplVglVFWblM5bSwbTULIMTlvc+AwnuGpI
 aws43w4lHXsfO8t40B2cNqRMVH1mCl4F7PKhJhCSs5kEvvb7Q4dE0Sj8AAAAA==
X-Change-ID: 20261112-page-ownable-2e97941a83b2
To: Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Uladzislau Rezki <urezki@gmail.com>, 
 David Hildenbrand <david@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Mike Rapoport <rppt@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Wilcox <willy@infradead.org>, Danilo Krummrich <dakr@kernel.org>, 
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 =?utf-8?q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, 
 Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
 Carlos Llamas <cmllamas@google.com>
Cc: Igor B <igor.b@beldev.am>, Vitaly Wool <vitaly.wool@konsulko.se>, 
 linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7944; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=WHdG1t5Ag1Nz1FPp8c0/hz5TW9dGwn5dkm6bRHT4QtQ=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBq/c/P4xLeBQvFzyl7yL1Rp/6IYnMqrDurD6UbQ
 Nfep8G8PgiJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCav3PzwAKCRD6UCkIqsW9
 0NUpD/9RgYY4JysHIllCAH9/dWcz+95rSzrHZKZStdjJ93OaXna2EJi+KdpNh54KyEpOJfUTE1n
 E6tUEbpSc1zdanpzbrph+jzzeosXu+W0pOhiRycbZHFe5FRV62TQJz0X48uG9ghOsblPHL7FgaA
 zBr0S17d3KgABUWkfmD9R9w7xUT14nKb2I5KbJxMi0nvUK4ByacGwEL9Bi6jDufg+flMz/aLUD/
 q6bJgn7o2hRRVErkMGwB0pobLqncfUsgxS8jjKIa+mpEAwdxTHnyOdgPB4SBCCYgyuvFhE2RnUv
 keQH7BzML6btdaUSE4Q9qxlNoBrC3NF/nQIGy/nGWO38YOwOXpP2R7ux103QcRVJCJB1rhlkIJG
 RQUiaLhbTiuaBluDI9dhOOyGzzXxf4XPXbNsO7BKajZCC+n70WauaaBxOygLxW4ksW4HjSozndQ
 UlCatGGxL4NNhbnJVVAQa+yDwd4TpFGAsSXtkbS4+OXA5gJwLn+Ao+yvaOPpc6uju8QAoHTy20N
 vGdLq/KQiXYk+bfvM/GPucyv2YsEH5BQffSMLxZVWTZ567/i49O5IFQy5TfMFq4HaRy0EG3sOrt
 IvfsSK38Imfsdo125eQfj5tSMpL8hPh8b4+2MULU2jbWFtSR77VN35PxsccsAmEvvqi5eyEgutB
 W2KI3ss4M4zI5fg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: A4D331C0006
X-Rspam-User: 
X-Stat-Signature: zfxp51mggs7i18odazqqrdhwkyda5t5z
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795018776-464167
X-HE-Meta: U2FsdGVkX18oJn7bYt4XUPyB9689JybprKOI0g1iwv1MSN4dJ+ZuT6l1i5C9bKO4T79FZCallTQ1V/YDeIka3JUrpELpImmaJcH3JolXUbbOFbFavuza4sHk2sA2jHBWitKT5mal+TdpEQgw+ft4Ojxzwiea/zeHaoAg+tK7hHOGyAAFPqguW0m4eARec284vOAMCBeH9qADe2fgZCLSy92ENFyd27NKIvXwrbwd+Xig8mAOMVZzbKn+EVgfr9l5IBcTsej+4BHtxhNDkE9dahIw6wY7fnqxQ83gq4QDrobVwMTR2YCrOT0ewStZOcnzcUHsD6+1lqozaQN4izK9PqzQjnR6zKdveWyYY+ulqrPqdyfDFh/NiKf+sPkGaKwrN89WatSAIZfIgCc29hWSDRXSxNsCsAl7VHCU57nhIzvBh6DWJQ8j8fPTJbC1t95gA1vd4mCnDXDHrTKiaDMPys37mkTVdcRTQNmaOM/PdpTR/GHAnUhfGqZjUtmspseVSOdeQE3xCRqd/rUx4dlxm5Mt21a+e5yawtzKR5iuFQFuyAXvk+axihQ85KATYAzY4GtZ288tnnSy4F/VBnFkCsXRm5GuYLAEaJ4x3ff/7inH+6Ms0zxdebHGEnb2GgN6/SVB5oYfMVOwB54g1QJBB2kMR7aeaia+EGGFidSGu+nkEXVRADcl+VxWfQ3WuL3DVSAe0y3wkGnRkntRj9cEytDk3gZAGoY96AVoA+eX0d42nQFCi6vsSIpV8BTQDlYYynKSUkozBzTVBr+DWoq2S0IZ0nHA60GPzKKdRBrSX6hnW2bPSpTE8AT3awsA79uu186w+JrYozVZxflJlmMAyRHQCkvxg9hoHJUxf0mp+gFKKhaFipGs7O6RBJ5fji8/TSpajAeNnnSbwtOBJzGdkC9tdvKnuZik5BI6YHEDnV78JfESnr0Ln9rSNYNZFbj5cH6cCuxA6W/ne6upHPG
 nDQr61du
 a1JQHlQ7Hf8hlUL8CVnFGuFrtgjFELH/9R6azUK97X4HHI8c4r3xKmo3fmwXGjMx/8ZOxGYJqFDVyFnYrSmFKSRypV+uG3Q51PcGg62Fccg6xxPGblrYrtt6poQ3VVONTumqEzkkhjG686DsTJbeCrslCIitgB2JcjTQmInQQAznCJjVVfuByKZ4EuNSVnx9h2YN05xyseJkJCd17tD/SGbMLBlG+Y4PC3SMzfi4rcLKfs6/uotBS+NGOlT+9bdrRgCToFCDJdU2G6DgceIZ+iamOhEoO3TA5vdY/BdrJlQSmpRrcXSgwjmIY8qHC2vyFGsTGvJVylkHmD6A5MiAtOVEIl6XqpOn4x7t3DCRwNElQlAKBB2fjg6LVkUuJwA7jHy3511wMA8GtaYtG0hcZ6VYwmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Note: The page patches were part of the `Ownable` series [1] until v21.
This series continues the version numbering of that series, and it depends
on v22 of that series for `Ownable`, `Owned` and the split of `RefCounted`
and `AlwaysRefCounted`.

Not all pages can be treated the same way. A page allocated with
`alloc_pages()` is managed by the page reference count, and kernel C code
routinely takes its own references to such a page. A page owned by the
slab allocator must not have references taken to it, but it can still
show up in places such as a bio vector. A frozen page has a reference
count of zero and is exclusively owned by the party that allocated it.

A single `Page` type cannot describe all of these. This series makes
`Page` generic over a sealed `PageKind` that describes what is known about
the page:

 - `Page<Base>` is the base kind. Nothing is known about the page
   beyond the validity of the `struct page`.
 - `Page<RefCounted>` is the default kind. The page is managed by the
   page reference count, and `Page<RefCounted>` implements
   `AlwaysRefCounted`.
 - `Page<Exclusive>` is a uniquely owned frozen page whose data area
   follows standard Rust aliasing rules, so the data is available as
   `&[u8]` and `&mut [u8]`. It is handled through
   `Owned<Page<Exclusive>>` and is the first in-tree user of `Owned`.
 - `Page<Frozen>` is a frozen page whose allocation is uniquely owned.
   Unlike for `Page<Exclusive>`, nothing is known about who accesses the
   data of the page, so the data is only available through the unsafe
   raw accessors.

Operations that are valid for any page are available for all page kinds.
All other page kinds dereference to `Page<Base>`. The purpose of the
dereference is coercion: a reference to a page of any kind can be passed
to code that takes a `&Page<Base>`.

`Page<Exclusive>` is backed by a frozen page, as suggested by Matthew
Wilcox in the review of v21. References cannot be taken to a frozen page,
so the exclusive ownership is upheld by mm rather than only by the Rust
type system.

Patch 1 adds the page kinds `Base` and `RefCounted`, makes
`Page<RefCounted>` reference counted, and updates the users of `Page`.

Patch 2 adds `Page::from_raw()`.

Patch 3 makes `alloc_frozen_pages()` and `free_frozen_pages()` available
outside of mm. The choice of `include/linux/gfp.h` as the new home of the
declarations is open for discussion.

Patch 4 adds the page kind `Exclusive`.

Patch 5 adds the page kind `Frozen`. It has no user in this series and
can be dropped if it is not wanted at this time.

Patch 6 adds slice access to the data of a `Page<Exclusive>`, and
tightens the safety requirements of the raw data accessors accordingly.

[1] https://msgid.link/20260910-unique-ref-v21-0-e83257373062@kernel.org

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
Changes in v22:
- Split the `Page` patches out of the `Ownable` series.
- Make `Page` generic over a `PageKind`, with the kinds `Base`,
  `RefCounted`, `Frozen` and `Exclusive`. `Page<Exclusive>` replaces the
  `ExclusivePage` type (Andreas).
- Back `Page<Exclusive>` by a frozen page (Matthew).
- Add a patch that makes `alloc_frozen_pages()` and `free_frozen_pages()`
  available outside of mm.
- Add the page kind `Frozen` in a separate patch (Andreas).
- Return `&Page<Base>` from `Vmalloc::to_page()` and `AsPageIter`, as
  these pages are not known to be reference counted.
- Make `Page::from_raw()` available for all page kinds. The caller selects
  the kind and upholds its invariants.
- Rename `ExclusivePage::alloc_page()` to `Page::alloc_exclusive()`
  (Andreas).
- Let `Page<Exclusive>` dereference to `Page<Base>` (Andreas).
- Add `Page::as_slice()` and `Page::as_mut_slice()` for `Page<Exclusive>`
  in a separate patch. Always zero the page and never allocate it from
  highmem, and require callers of the raw data accessors to ensure that
  no conflicting reference to the data exists. Update the safety comments
  of the existing callers (Andreas).
- Justify the `AlwaysRefCounted` implementation for `Page` by all
  instances of the type being reference counted, rather than by the type
  not implementing `Ownable` (Alice, Gary).
- Tighten the safety requirements of `Page::from_raw()` to require, for
  `Page<RefCounted>`, that the page is reference counted and that taking
  additional references is permitted (Sashiko).
- Mark `Page::alloc_exclusive()` as `#[inline]` (Sashiko).
- Drop the Reviewed-by tag from the `Page::from_raw()` patch, as its
  safety requirements changed.
- Link to v21: https://msgid.link/20260910-unique-ref-v21-0-e83257373062@kernel.org

The entries below are the `Page` related changes from the change log of
the `Ownable` series.

Changes in v21:
- Import `Page` directly in `allocator.rs` instead of using the
  `page::Page` path (Danilo).
- Convert `Page` to `AlwaysRefCounted` backed by `get_page()` and
  `put_page()` instead of `Ownable`, and return `ARef<Page>` from
  `Page::alloc_page()` (Alice).
- Update Rust Binder to store `ARef<Page>` instead of `Owned<Page>`
  (Alice).
- Add `ExclusivePage` as the in-tree `Owned` user, without
  `Deref<Target = Page>` as that would break its aliasing invariant.
  The type was previously posted as `SafePage` and is renamed here
  (Alice).
- Link to v20: https://msgid.link/20260824-unique-ref-v20-0-490735672187@kernel.org

Changes in v20:
- Use `self.page.get()` rather than `Opaque::cast_into` (Alice).
- Link to v19: https://msgid.link/20260626-unique-ref-v19-0-2607ca88dfdf@kernel.org

Changes in v18:
- Remove `BorrowedPage`; use `&Page` directly (Alice).
- Update Rust Binder for the `Owned<Page>` conversion (Alice).
- Fix stale `Page` docs (Sashiko).
- Link to v17: https://msgid.link/20260604-unique-ref-v17-0-7b4c3d2930b9@kernel.org

Changes in v16:
- Simplify pointer to reference cast in `Page::from_raw`.
- Use `NonNull<Page>` rather than `Owned<Page>` for `BorrowedPage` internals.
- Fix formatting for `Page::from_raw` docs.
- Link to v15: https://msgid.link/20260220-unique-ref-v15-0-893ed86b06cc@kernel.org

Changes in v14:
- Add patch: rust: page: convert to `Ownable`.
- Add patch: rust: page: add `from_raw()`.
- Link to v13: https://lore.kernel.org/r/20251117-unique-ref-v13-0-b5b243df1250@pm.me

---
Andreas Hindborg (6):
      rust: page: add page kinds and make `Page` reference counted
      rust: page: add `from_raw()`
      mm/page_alloc: make alloc_frozen_pages() available outside of mm
      rust: page: add `Exclusive` page kind for race-free page access
      rust: page: add `Frozen` page kind
      rust: page: add slice access to `Page<Exclusive>`

 drivers/android/binder/page_range.rs |  24 +-
 include/linux/gfp.h                  |   9 +
 mm/mempolicy.c                       |   1 +
 mm/page_alloc.c                      |  10 +
 mm/page_alloc.h                      |  14 -
 rust/helpers/page.c                  |  21 ++
 rust/kernel/alloc/allocator.rs       |  29 ++-
 rust/kernel/alloc/allocator/iter.rs  |   7 +-
 rust/kernel/alloc/kbox.rs            |   3 +-
 rust/kernel/alloc/kvec.rs            |   3 +-
 rust/kernel/page.rs                  | 481 ++++++++++++++++++++++++++++-------
 11 files changed, 474 insertions(+), 128 deletions(-)
---
base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
change-id: 20261112-page-ownable-2e97941a83b2
prerequisite-change-id: 20250305-unique-ref-29fcd675f9e9:v22
prerequisite-patch-id: 4e3c7a1a2077aaa0ece2d557fa73486355903ae5
prerequisite-patch-id: d1073c5dcd6287fbcba7848a5d182108930230c1
prerequisite-patch-id: 3244def11bbdf2eabaa6e94e15ce06540b2f5814
prerequisite-patch-id: cef14c5bef5ba519ceaf0a0e7c9e93ef974db7b3
prerequisite-patch-id: 56410da35ed8dbe7b210adae0985af705cc0b5b0

Best regards,
--  
Andreas Hindborg <a.hindborg@kernel.org>



