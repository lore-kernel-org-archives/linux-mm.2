Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 965CCCAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 09:03:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9C858E0015; Wed,  1 Oct 2025 05:03:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4C038E0002; Wed,  1 Oct 2025 05:03:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3C0E8E0015; Wed,  1 Oct 2025 05:03:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 983D98E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 05:03:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 48F171609AD
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 09:03:42 +0000 (UTC)
X-FDA: 83948957484.17.8439ACE
Received: from mail-24418.protonmail.ch (mail-24418.protonmail.ch [109.224.244.18])
	by imf02.hostedemail.com (Postfix) with ESMTP id 460F08000B
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 09:03:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=gq5cdMSm;
	spf=pass (imf02.hostedemail.com: domain of oliver.mangold@pm.me designates 109.224.244.18 as permitted sender) smtp.mailfrom=oliver.mangold@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759309420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=k2cd0h/lNPW6oKirfHBNFEiPHjT+8NPzCf04+VSLOsg=;
	b=3y22rwVoWyuMZxpDujpa3ZyGeZCHdG6/WWNQr7EOtc3e80tMNZ+MN1LrVk6pWo1+Vn5Eti
	F8XOdxe7YYNykM/uVdDWf+vvOfVjmgmar7adzhdIbmaKVvRrzzPrd3JjyCWXQ1YqrFUnjV
	Kg80Khv25P1OHo8OmdpyF7qEVRYQrvc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=gq5cdMSm;
	spf=pass (imf02.hostedemail.com: domain of oliver.mangold@pm.me designates 109.224.244.18 as permitted sender) smtp.mailfrom=oliver.mangold@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759309420; a=rsa-sha256;
	cv=none;
	b=Nadp5DPRckzcuutOfVp5owRuE0iKATYAKMvEo8Hf9W2JhK0pO//j3W6ZPee8s3v8kI+d5a
	bu7je2pX4EkKMu3ZrbhiBXBmwvjMdxtxm07iVi/4VnW6TTMi5At5ekv+arDNXZeGc0182n
	aXETtdDcQsGPeRFaeQEg2UO/LCZn42o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1759309417; x=1759568617;
	bh=k2cd0h/lNPW6oKirfHBNFEiPHjT+8NPzCf04+VSLOsg=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=gq5cdMSmMRJ5eEdQ74b46Afg4C59ln8vt80/KmbouM+MFTl2033f/pBX9xzcIeq3c
	 enT4MAXopZCXXM6u8MfmhBxjUT6n5m1ghFZIaA2NLIUKRLBpebo7Nl/W+xz25bSdkL
	 pM227Wrf+Pf1aQ+0s6p0RpRpMvHjcnf3aX8YNIB7KGbhAhc8bcRGXGXurIHssikDkl
	 1q8ZroZcQt16iBc6K+0cXAsicmMEPNQQEwLMybDsThZ0uWpfeXrXHudarIT9Ec323i
	 DZ8DMK1X2WbiT+Fk9grZNvAGMjnvy5Kb/X5WF3YPKUnQOnedseFZJOWs8WudYT4Zme
	 ksS29du6VknaQ==
Date: Wed, 01 Oct 2025 09:03:31 +0000
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Benno Lossin <lossin@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, Leon Romanovsky <leon@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Viresh Kumar
	<vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, =?utf-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, Asahi Lina <lina+kernel@asahilina.net>
From: Oliver Mangold <oliver.mangold@pm.me>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, Oliver Mangold <oliver.mangold@pm.me>
Subject: [PATCH v12 0/4] New trait OwnableRefCounted for ARef<->Owned conversion.
Message-ID: <20251001-unique-ref-v12-0-fa5c31f0c0c4@pm.me>
Feedback-ID: 31808448:user:proton
X-Pm-Message-ID: 05f6e75cf8354eecb1d79bcf61223bca92da5f3d
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 460F08000B
X-Stat-Signature: ybq5hjybnmme15zmt7ci5y6rg94fqz5p
X-HE-Tag: 1759309420-940413
X-HE-Meta: U2FsdGVkX18hV2YmrEZZ2UEhiES/mjWzf0qaoiYpcMVF0nHiTuMws2nLwKMqXcp3p18y/q8sTVns+SdUs0kfKzsOrrFe5mHo6eKB5WhQ4yrQxkNJUM8JuNuMt04I88jUFyPuRzA8rt7PLHzatroPZU5KamFbOKi5dvWrF75cuBrBqX43FL4s32W08muLS1i7q/ssCuzcVdUegDMv1U1tbKYdQDv0+HvhDOgkzl7VLAqu9i0zxSNpTUivraxEqDybc8TI2HAbiJpCA1DQLUdOAmAwXjlUbuUdKMv8K0y4nTksWXo4cDuTCetmvvKVBUHWpYQVm6xg6pWXzCf45et1tXJ/iYF1AYIWRK4C3IqwUlXnVIAlr7tUY2hS/2qYMUYleyHcjX1gE0bqt+/Ki0eH0rPhSn4JeBAtpGFGUb6bbwDiLpnG5lJjqBDpThqX45arihI8sJ7VR2ukdYGN5FCSU1MfFDxKNQ3YLSy0g1h1bvOe+sg0RQbG5L4cDQ8QI5JT7WYFRva+M789/+pDm+4FHyTf02VyQro5EXvUFxI3bLGiYvFFVJ2ZpHGVQx2k24FjoauVPaCBGGZpH2htZy/LiN0TWrXL0BHYds95CunuQlzrOkO/84r+6E0XH5CqFw5WcEaD38wrypT2Jy3d737I6nlDbmuVa9dRRivy3so142n30TNlv0icdOUlB6yAm6iY5n6v897ARAPPqkHoFsYd56p/a+twXY4yf7AUh7+Xql1na0pBkmjZ4lRBKjB/T/cW/ziXChk+l0jj2Cl2Y7RFkv6SZuchnQ0ycDFVmGCIKWg7vw+rem7o6omWzeUeDxddDdx6k2Uj2w75lrICyN7BTLCxocFM+pYp2ji5E8W07bR24aScXebIKChvzgZAtnrgtIqu7XeS2tCQQ1OqHXHjDcf+w8+ego4q73HbUT0dyA9gtDm5+O9Nw+/DrERH5E6EJSUc/MxduDOi7ZnYgm8
 PhmA+44o
 deRm0NJtU0Rz9qz4D39aCu0WPN7WUlKCpXcFzuw+s5B44OWy+656byEjnikET0svJ4OsE4OabBFp5I41hgkosxHBZI51NEIQx67l3q+tTh44WSADwu7ZEbZkJHaU7mcALDEKcbWWrS9ahxEaIpmJu/T/x6jfyMKm5PnDFUUhSNiDu3V1tikhYRZJLukcC+KjJhGB2Sbjz9SkmmX+1OxeIussCoA1/zoka8ePn7DtPX45lc9CTnYVfqup2cdTdXUMdil5N7JpkIcoY1qMH1SMgiIIj8tgsoN8lwdKfCKLuv63+APVQiTHXGeGYF8gIATyA45g5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This allows to convert between ARef<T> and Owned<T> by
implementing the new trait OwnedRefCounted.

This way we will have a shared/unique reference counting scheme
for types with built-in refcounts in analogy to Arc/UniqueArc.

Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
---
Changes in v12:
-
- Rebase onto v6.17-rc1 (Andreas's work).
- moved kernel/types/ownable.rs to kernel/owned.rs
- Drop OwnableMut, make DerefMut depend on Unpin instead. I understood
  ML discussion as that being okay, but probably needs further scrunity.
- Lots of more documentation changes suggested by reviewers.
- Usage example for Ownable/Owned.
- Link to v11: https://lore.kernel.org/r/20250618-unique-ref-v11-0-49eadcdc=
0aa6@pm.me

Changes in v11:
- Rework of documentation. I tried to honor all requests for changes "in
  spirit" plus some clearifications and corrections of my own.
- Dropping `SimpleOwnedRefCounted` by request from Alice, as it creates a
  potentially problematic blanket implementation (which a derive macro that
  could be created later would not have).
- Dropping Miguel's "kbuild: provide `RUSTC_HAS_DO_NOT_RECOMMEND` symbol"
  patch, as it is not needed anymore after dropping `SimpleOwnedRefCounted`=
.
  (I can add it again, if it is considered useful anyway).
- Link to v10: https://lore.kernel.org/r/20250502-unique-ref-v10-0-25de64c0=
307f@pm.me

Changes in v10:
- Moved kernel/ownable.rs to kernel/types/ownable.rs
- Fixes in documentation / comments as suggested by Andreas Hindborg
- Added Reviewed-by comment for Andreas Hindborg
- Fix rustfmt of pid_namespace.rs
- Link to v9: https://lore.kernel.org/r/20250325-unique-ref-v9-0-e91618c1de=
26@pm.me

Changes in v9:
- Rebase onto v6.14-rc7
- Move Ownable/OwnedRefCounted/Ownable, etc., into separate module
- Documentation fixes to Ownable/OwnableMut/OwnableRefCounted
- Add missing SAFETY documentation to ARef example
- Link to v8: https://lore.kernel.org/r/20250313-unique-ref-v8-0-3082ffc67a=
31@pm.me

Changes in v8:
- Fix Co-developed-by and Suggested-by tags as suggested by Miguel and Boqu=
n
- Some small documentation fixes in Owned/Ownable patch
- removing redundant trait constraint on DerefMut for Owned as suggested by=
 Boqun Feng
- make SimpleOwnedRefCounted no longer implement RefCounted as suggested by=
 Boqun Feng
- documentation for RefCounted as suggested by Boqun Feng
- Link to v7: https://lore.kernel.org/r/20250310-unique-ref-v7-0-4caddb78aa=
05@pm.me

Changes in v7:
- Squash patch to make Owned::from_raw/into_raw public into parent
- Added Signed-off-by to other people's commits
- Link to v6: https://lore.kernel.org/r/20250310-unique-ref-v6-0-1ff5355861=
7e@pm.me

Changes in v6:
- Changed comments/formatting as suggested by Miguel Ojeda
- Included and used new config flag RUSTC_HAS_DO_NOT_RECOMMEND,
  thus no changes to types.rs will be needed when the attribute
  becomes available.
- Fixed commit message for Owned patch.
- Link to v5: https://lore.kernel.org/r/20250307-unique-ref-v5-0-bffeb63327=
7e@pm.me

Changes in v5:
- Rebase the whole thing on top of the Ownable/Owned traits by Asahi Lina.
- Rename AlwaysRefCounted to RefCounted and make AlwaysRefCounted a
  marker trait instead to allow to obtain an ARef<T> from an &T,
  which (as Alice pointed out) is unsound when combined with UniqueRef/Owne=
d.
- Change the Trait design and naming to implement this feature,
  UniqueRef/UniqueRefCounted is dropped in favor of Ownable/Owned and
  OwnableRefCounted is used to provide the functions to convert
  between Owned and ARef.
- Link to v4: https://lore.kernel.org/r/20250305-unique-ref-v4-1-a8fdef7b1c=
2c@pm.me

Changes in v4:
- Just a minor change in naming by request from Andreas Hindborg,
  try_shared_to_unique() -> try_from_shared(),
  unique_to_shared() -> into_shared(),
  which is more in line with standard Rust naming conventions.
- Link to v3: https://lore.kernel.org/r/Z8Wuud2UQX6Yukyr@mango

---
Asahi Lina (1):
      rust: types: Add Ownable/Owned types

Oliver Mangold (3):
      `AlwaysRefCounted` is renamed to `RefCounted`.
      rust: Add missing SAFETY documentation for `ARef` example
      rust: Add `OwnableRefCounted`

 rust/kernel/auxiliary.rs        |   7 +-
 rust/kernel/block/mq/request.rs |  14 +-
 rust/kernel/cred.rs             |   7 +-
 rust/kernel/device.rs           |   9 +-
 rust/kernel/device/property.rs  |   7 +-
 rust/kernel/drm/device.rs       |   9 +-
 rust/kernel/drm/gem/mod.rs      |   7 +-
 rust/kernel/fs/file.rs          |  13 +-
 rust/kernel/lib.rs              |   1 +
 rust/kernel/mm.rs               |  12 +-
 rust/kernel/mm/mmput_async.rs   |   7 +-
 rust/kernel/opp.rs              |   7 +-
 rust/kernel/owned.rs            | 318 ++++++++++++++++++++++++++++++++++++=
++++
 rust/kernel/pci.rs              |   7 +-
 rust/kernel/pid_namespace.rs    |   7 +-
 rust/kernel/platform.rs         |   7 +-
 rust/kernel/sync/aref.rs        |  67 ++++++---
 rust/kernel/task.rs             |   7 +-
 rust/kernel/types.rs            |   4 +-
 19 files changed, 474 insertions(+), 43 deletions(-)
---
base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
change-id: 20250305-unique-ref-29fcd675f9e9

Best regards,
--=20
Oliver Mangold <oliver.mangold@pm.me>



