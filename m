Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D312C55178
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 09:52:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F6286B009E; Fri, 20 Feb 2026 04:52:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C3D46B00A1; Fri, 20 Feb 2026 04:52:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B9D86B00A2; Fri, 20 Feb 2026 04:52:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 66FFD6B009E
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 04:52:58 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 17B625CB96
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 09:52:58 +0000 (UTC)
X-FDA: 84464371236.03.F2397C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1E5B440004
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 09:52:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uXuKsXuc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771581176; a=rsa-sha256;
	cv=none;
	b=vS5Y5fp8QGWzhP8DVehhhRzS9uKZCUVRlZHWTH/NR3MvfenHy9Ld8WAFh/OJHsAbkgJDCR
	BgV9Dlu8soGw8Imv4CmAqKSpSfaEihDov4fEa5pEuMQr8WOk1e9tVcwVUvnVgPT5kd0F0G
	3Yo40baIHF0EzxouHcOF8ED8LwOXB1Y=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uXuKsXuc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771581176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=b9QmVBZa3T5JbOFmkZrKVO2YfHNJZvC69YaKtn5HHXE=;
	b=PKTDGg05CVXfZQnyjJjN8hb+pQhp8Xpgdp8EsjwOyhkhS4dHRf7nLlj33CoFNMrHOtWAAT
	PxW/eLX/qyS8JvGWhXCAekkese9rEJNP9W2nQO4n1WAwg6RTUfToU4Qi1PQws3Vujwy2RR
	dpYlNZIQiPfdgcmLjtNVYQlVMxKdtBA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EFAB9405D3;
	Fri, 20 Feb 2026 09:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC660C116C6;
	Fri, 20 Feb 2026 09:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771581174;
	bh=MH7qgXhxS+4W/slhJWtX05AT1X6dliBzfHD+GHMyYOE=;
	h=From:Subject:Date:To:Cc:From;
	b=uXuKsXuc1oi5NTmbeIJbJwg0qiB09J1EnFmfBOMmbVqGRz+UJFRLx+qXIjeqU9XKI
	 1A90JCDNNwqq8AdAqBUjHRZkLh5RubGQkb/Juj+12z5eJNquVrH3I3xs/hXcVvfymd
	 9ZLhBlOiPcePHYNQ1iA7bouVitDd8VTG04OOaT9SKOK6qDSKDuFxJP5nwRasNquPv9
	 faOPvqwkyGSWpot7ohnKQPl2a07RtHuKchyjZ4ZvDub50nhLXx6Oj2f5PY98zCXiS7
	 8WovQXFjcdunMP8dhaMmzCvvqkevp1G9euoEUyOi4yqrTW3jk830t0K6KnG6r+3SSX
	 SZeR2Dseyv9Ew==
From: Andreas Hindborg <a.hindborg@kernel.org>
Subject: [PATCH v15 0/9] rust: add `Ownable` trait and `Owned` type
Date: Fri, 20 Feb 2026 10:51:09 +0100
Message-Id: <20260220-unique-ref-v15-0-893ed86b06cc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAI0umGkC/02MwQ6DIBAFf8XsuTRARUNP/Y/Gg+CimzZgoZo2h
 n8veupx5uXNBgkjYYJrtUHElRIFX0CoUwV26v2IjIYiQHKp+IUrtnh6LcgiOia1s0PTKqdRQzn
 MRdLnqN27whOld4jfI76Ketd7p+GS1/+dsjHORGuN1Gh6a8ztgdHj8xziCF3O+QfRbXHyqAAAA
 A==
X-Change-ID: 20250305-unique-ref-29fcd675f9e9
To: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
 Serge Hallyn <sergeh@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Igor Korotin <igor.korotin.linux@gmail.com>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
 Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Boqun Feng <boqun@kernel.org>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
 Andreas Hindborg <a.hindborg@kernel.org>, 
 Asahi Lina <lina+kernel@asahilina.net>, 
 Oliver Mangold <oliver.mangold@pm.me>, 
 Viresh Kumar <viresh.kumar@linaro.org>, 
 Asahi Lina <lina+kernel@asahilina.net>, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=6914; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=MH7qgXhxS+4W/slhJWtX05AT1X6dliBzfHD+GHMyYOE=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpmC6SPN6GHiEtdlstRzjq+GDhU+BAAtaEl2yZ5
 dAZnwhbahyJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZgukgAKCRDhuBo+eShj
 d+m0EADD1vNs5vo1isrR+dReFMAAh/IJGnL65NOiczhIAW1wZZkrrgnlL/5hKfHTutsQgv1mke4
 N4j8Es0nIBqbQlz8aIzKxjyKHbjtaJ/Aae9Gmzyi2WyazIIGiGwXctb9d2QjMU68ylbnbmctfmd
 dTiGfbWsaEpGMSO9/g2ktoHb5GzVKC/DjLpDSx1RPC4JxYachdHG/YdIttm4+eNpOAxm/SXDYcx
 Qdur7+G2M/eonzgx9Clyzq6/b+HUP6AfKUB1W8IoT/vqPBQMDvgm6Wzc1Qr7/QdxfKOARrKWQ3K
 jSXpnSIyYCsulQo+RAXYrTt7Dp5uJEp8x8khBuQ5lq7EyhSihDWnzrG4g/uQW5HFstiTaqv23q+
 JZu96aZkK7R833cL8ztJTTik5IBG8eo+MWaXRnt3EqMWdNEMJ+tNZHaHCtBrqAtK745SUom7ZR9
 rmPN97whe0pdmYs+hRc10u0nuNmzCkwiZHUI2mkrfCBD9Y7EqVNvty4r6Kj4q6RC9cYYevc+KWe
 QVVe85NnCdnW2vEsTJ1Zj/lHRETLiyY4nsOYetdypxDfEXXkU7ekD8SaunSxjI97C6Kdf2Lk36s
 KF6omKgbg3Md8trx81AGUNWZM6YDm2c2ymNEtmKbyhBgwWYj7Q2CYkpLbioQazJkP9CnTx8mpGG
 30dNWCcJBeMR84w==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Stat-Signature: qmrft1tgxzy4hxxre5sfbw9o7e51rrhq
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1E5B440004
X-HE-Tag: 1771581175-538466
X-HE-Meta: U2FsdGVkX18hy4r1s+VAgmw/32SFu7n/mRVm2yY4t656VroRoEHRQVBQ8mwBaDWCQDGeUaReLUjM79WKHXz4SOmfj0usUugUl87jsNKAcKg6RJTgTazGnF24cTkFdO9Dh8OCoy46Vqh4Cvg2kt8s9pKyGIu6ilZYAuVA2JLba2Pqq+A+CYwZkkxU2kIxx7cSlz1uCwjHhfmKSIUKtkaBDvjZwsi9JfdS29aq4e59VPIbmawnLFXXwljOr25ynVmKae6/mbWliLGtMAawGPTF/iIBPOlKgJtSFpI0NkxeukoXXLht3KZve2P6DLJa3DNBWwGv/biRHXhYcWyhoSJeD7UzsZX4cpCXNX2kIKpdKCSN21sutuoV1F3F58xc9G/fynKbS8s1PmvdXlcihiL8yKcDRiiRcW6wtXIiGCpoW7T0r1uOZ7y35DEXOU3qhXIBAAeYFBIRMS7WsJS3snsxUvJrBLRVRjTfx1thpFbz1BzJem4UxBm42vgrvQzjcN0Oy6Bj5gKTmN6h7UtTJPwuiN1FrNuVZMTmMaaBrkP4N7lZe0XZS4UUA4zlBlhbRmjV4ABEECCLfz6gyUlCLeMpotnQDfecyBFGPcnf2fCiNE0BCqJHpj7V4XGcnyLF9HSaxhqFRe3wjtEGLF4RQ0EBvo26Ret0Ju9UnXFCchPU07fFNlzKVrvACoJstH9lecuO3osOM48C8G1ZCseDWbrtehxw0qIyyckeAx5Ubfje07sWmUphSIx8DdTx+bRnP62rQQx5s5d707RSBUQR4TQ7xwaS6T3kD+5IFur/+G+JnFZEvBW2ycNAy5nL3iAoP3Why2F3fGt/kpVkCSjISS81bCBTFmc/q1PjiP0WsUvyvapoN31RH8rVm+OWV91pu7VKbt5DE4lnv0DGrG9KY8aWey+aoHypE1kyyP1tXZ3tXZleVHIKGSTGYO4ZFqgI6TLf1LluoZqTRAKeSvLAuGm
 y2ze9Txm
 dvYOVywbaiseGz1v54N16dXnNpqoIOl32wmGC/BG14dv2Mf6Zi6xna9lp7/39ysmDkcqUfrxXy4dT8p7zv8u7N/UtMQNLnwfbfSkpKFqRVP5epwGdZTjYq0PrBZgoj+eZZHaO4hCT5TI/Nsvt+vHLfhj6lBZAW1ZjT+NrC5Ut0f7IH1CvUu8OBDXXr4jDlwXTiJvbjloq9pIX2f3Sq73WacshG/1WI911RPf84lg7QmXXNJrg3MDI0lXusXIlEpnJkU+pDHrrJ9Y8BkfzdtzDTdAUVjUF99liDOZnHMqE/dpXpS1IlE7xeNKwVnXn3uoQsohxJbg8d1dzazd6/FXXjTNyD6vQ9SIp/3PEp2A9VVbD7KlIKrTJRloaTZftMwXIhcyvEcnzqWDH+YTcFXJq7nPrqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new trait `Ownable` and type `Owned` for types that specify their
own way of performing allocation and destruction. This is useful for
types from the C side.

Add the trait `OwnableRefCounted` that allows conversion between
`ARef` and `Owned`. This is analogous to conversion between `Arc` and
`UniqueArc`.

Convert `Page` to be `Ownable` and add a `from_raw` method.

Implement `ForeignOwnable` for `Owned`.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
Changes in v15:
- Update series with original SoB's.
- Rename `AlwaysRefCounted` in `kernel::usb`.
- Rename `Owned::get_pin_mut` to `Owned::as_pin_mut`.
- Link to v14: https://msgid.link/20260204-unique-ref-v14-0-17cb29ebacbb@kernel.org

Changes in v14:
- Rebase on v6.19-rc7.
- Rewrite cover letter.
- Update documentation and safety comments based on v13 feedback.
- Update commit messages.
- Reorder implementation blocks in owned.rs.
- Update example in owned.rs to use try operator rather than `expect`.
- Reformat use statements.
- Add patch: rust: page: convert to `Ownable`.
- Add patch: rust: implement `ForeignOwnable` for `Owned`.
- Add patch: rust: page: add `from_raw()`.
- Link to v13: https://lore.kernel.org/r/20251117-unique-ref-v13-0-b5b243df1250@pm.me

Changes in v13:
- Rebase onto v6.18-rc1 (Andreas's work).
- Documentation and style fixes contributed by Andreas
- Link to v12: https://lore.kernel.org/r/20251001-unique-ref-v12-0-fa5c31f0c0c4@pm.me

Changes in v12:
-
- Rebase onto v6.17-rc1 (Andreas's work).
- moved kernel/types/ownable.rs to kernel/owned.rs
- Drop OwnableMut, make DerefMut depend on Unpin instead. I understood
  ML discussion as that being okay, but probably needs further scrunity.
- Lots of more documentation changes suggested by reviewers.
- Usage example for Ownable/Owned.
- Link to v11: https://lore.kernel.org/r/20250618-unique-ref-v11-0-49eadcdc0aa6@pm.me

Changes in v11:
- Rework of documentation. I tried to honor all requests for changes "in
  spirit" plus some clearifications and corrections of my own.
- Dropping `SimpleOwnedRefCounted` by request from Alice, as it creates a
  potentially problematic blanket implementation (which a derive macro that
  could be created later would not have).
- Dropping Miguel's "kbuild: provide `RUSTC_HAS_DO_NOT_RECOMMEND` symbol"
  patch, as it is not needed anymore after dropping `SimpleOwnedRefCounted`.
  (I can add it again, if it is considered useful anyway).
- Link to v10: https://lore.kernel.org/r/20250502-unique-ref-v10-0-25de64c0307f@pm.me

Changes in v10:
- Moved kernel/ownable.rs to kernel/types/ownable.rs
- Fixes in documentation / comments as suggested by Andreas Hindborg
- Added Reviewed-by comment for Andreas Hindborg
- Fix rustfmt of pid_namespace.rs
- Link to v9: https://lore.kernel.org/r/20250325-unique-ref-v9-0-e91618c1de26@pm.me

Changes in v9:
- Rebase onto v6.14-rc7
- Move Ownable/OwnedRefCounted/Ownable, etc., into separate module
- Documentation fixes to Ownable/OwnableMut/OwnableRefCounted
- Add missing SAFETY documentation to ARef example
- Link to v8: https://lore.kernel.org/r/20250313-unique-ref-v8-0-3082ffc67a31@pm.me

Changes in v8:
- Fix Co-developed-by and Suggested-by tags as suggested by Miguel and Boqun
- Some small documentation fixes in Owned/Ownable patch
- removing redundant trait constraint on DerefMut for Owned as suggested by Boqun Feng
- make SimpleOwnedRefCounted no longer implement RefCounted as suggested by Boqun Feng
- documentation for RefCounted as suggested by Boqun Feng
- Link to v7: https://lore.kernel.org/r/20250310-unique-ref-v7-0-4caddb78aa05@pm.me

Changes in v7:
- Squash patch to make Owned::from_raw/into_raw public into parent
- Added Signed-off-by to other people's commits
- Link to v6: https://lore.kernel.org/r/20250310-unique-ref-v6-0-1ff53558617e@pm.me

Changes in v6:
- Changed comments/formatting as suggested by Miguel Ojeda
- Included and used new config flag RUSTC_HAS_DO_NOT_RECOMMEND,
  thus no changes to types.rs will be needed when the attribute
  becomes available.
- Fixed commit message for Owned patch.
- Link to v5: https://lore.kernel.org/r/20250307-unique-ref-v5-0-bffeb633277e@pm.me

Changes in v5:
- Rebase the whole thing on top of the Ownable/Owned traits by Asahi Lina.
- Rename AlwaysRefCounted to RefCounted and make AlwaysRefCounted a
  marker trait instead to allow to obtain an ARef<T> from an &T,
  which (as Alice pointed out) is unsound when combined with UniqueRef/Owned.
- Change the Trait design and naming to implement this feature,
  UniqueRef/UniqueRefCounted is dropped in favor of Ownable/Owned and
  OwnableRefCounted is used to provide the functions to convert
  between Owned and ARef.
- Link to v4: https://lore.kernel.org/r/20250305-unique-ref-v4-1-a8fdef7b1c2c@pm.me

Changes in v4:
- Just a minor change in naming by request from Andreas Hindborg,
  try_shared_to_unique() -> try_from_shared(),
  unique_to_shared() -> into_shared(),
  which is more in line with standard Rust naming conventions.
- Link to v3: https://lore.kernel.org/r/Z8Wuud2UQX6Yukyr@mango

---
Andreas Hindborg (4):
      rust: aref: update formatting of use statements
      rust: page: update formatting of `use` statements
      rust: implement `ForeignOwnable` for `Owned`
      rust: page: add `from_raw()`

Asahi Lina (2):
      rust: types: Add Ownable/Owned types
      rust: page: convert to `Ownable`

Oliver Mangold (3):
      rust: rename `AlwaysRefCounted` to `RefCounted`.
      rust: Add missing SAFETY documentation for `ARef` example
      rust: Add `OwnableRefCounted`

 rust/kernel/auxiliary.rs        |   7 +-
 rust/kernel/block/mq/request.rs |  15 +-
 rust/kernel/cred.rs             |  13 +-
 rust/kernel/device.rs           |  10 +-
 rust/kernel/device/property.rs  |   7 +-
 rust/kernel/drm/device.rs       |  10 +-
 rust/kernel/drm/gem/mod.rs      |   8 +-
 rust/kernel/fs/file.rs          |  16 +-
 rust/kernel/i2c.rs              |  16 +-
 rust/kernel/lib.rs              |   1 +
 rust/kernel/mm.rs               |  15 +-
 rust/kernel/mm/mmput_async.rs   |   9 +-
 rust/kernel/opp.rs              |  10 +-
 rust/kernel/owned.rs            | 366 ++++++++++++++++++++++++++++++++++++++++
 rust/kernel/page.rs             |  57 +++++--
 rust/kernel/pci.rs              |  10 +-
 rust/kernel/pid_namespace.rs    |  12 +-
 rust/kernel/platform.rs         |   7 +-
 rust/kernel/sync/aref.rs        |  80 ++++++---
 rust/kernel/task.rs             |  10 +-
 rust/kernel/types.rs            |  13 +-
 rust/kernel/usb.rs              |  15 +-
 22 files changed, 624 insertions(+), 83 deletions(-)
---
base-commit: b8d687c7eeb52d0353ac27c4f71594a2e6aa365f
change-id: 20250305-unique-ref-29fcd675f9e9

Best regards,
-- 
Andreas Hindborg <a.hindborg@kernel.org>



