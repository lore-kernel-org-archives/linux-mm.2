Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FFB1CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 10:07:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65CD18E000A; Mon, 17 Nov 2025 05:07:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60D358E0002; Mon, 17 Nov 2025 05:07:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FBCE8E000A; Mon, 17 Nov 2025 05:07:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 36EB28E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 05:07:42 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EAE1C4E532
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:07:41 +0000 (UTC)
X-FDA: 84119672322.30.7FB73AC
Received: from mail-244116.protonmail.ch (unknown [109.224.244.116])
	by imf04.hostedemail.com (Postfix) with ESMTP id DE54F40004
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:07:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=QFadB+H0;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf04.hostedemail.com: domain of oliver.mangold@pm.me designates 109.224.244.116 as permitted sender) smtp.mailfrom=oliver.mangold@pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763374060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gm1HcMa14sf0lW/ftyfE3B16t17DV5H4XD9euU4478w=;
	b=dc/owfSKYaJE6j87tcEtlhrhInHdrJPdb3qhnbApKcy/Eed9id16ImFbBasklZxXFCpZu5
	GGWnbjcbJLWTVzYtPQDz35NUfbqaAwzmB+y8jfOil5HKEOGmODeuM+HvyecEBKawL93hXG
	0TOTwMlUwyo72evoyFhanT9rYf60QV8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763374060; a=rsa-sha256;
	cv=none;
	b=0GeT0qVn8qSgVK9F4gcJ0S0FTlcoFP9GhY+dVKx1S+q8a0TkLYJJADTrtlwdREJ0d+lBw4
	JwMO/7ChGwR+eUnhrnsjQnJtj02lm7rMIGkKe0NeDl+6aNMTG3hnH3h4RIeCr7Ovd48mYv
	D4ccecQ4WQ32pKC6lP7JAhvnjUSHPuw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=QFadB+H0;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf04.hostedemail.com: domain of oliver.mangold@pm.me designates 109.224.244.116 as permitted sender) smtp.mailfrom=oliver.mangold@pm.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1763374054; x=1763633254;
	bh=gm1HcMa14sf0lW/ftyfE3B16t17DV5H4XD9euU4478w=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=QFadB+H0AwTALkpadolrcwXWw1gR+aLZhnzR/YNsZXaGb9v0GZcGhgS7EsW49o5vX
	 0dv25eUxzQNVope8KL7qpXFXu6uVXU3gziWnA3Yg5RkRUsTQTkGy1Up1Edz7ivhdwE
	 EHcNnCgMZXkBsS+W/xioj850f8V9dsmijzaTWp1T7ABXUL+gj3zunHrTxfHX6vcgTc
	 0z1OzZ6UE9GTk5p8jRCifot2Cv98HEymfhztdneNQkOMIRs7SdcUVEeFXdZuba9c+i
	 gpm3Sl0SnbvqNSH+JGpQviDdydX5Vz6rjfDvI6RZa26piivEBwRj2tt6LTxLy6b8jw
	 veLU5j0L56zEg==
Date: Mon, 17 Nov 2025 10:07:28 +0000
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Benno Lossin <lossin@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, Leon Romanovsky <leon@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Viresh Kumar
	<vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, =?utf-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, Asahi Lina <lina+kernel@asahilina.net>
From: Oliver Mangold <oliver.mangold@pm.me>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, linux-security-module@vger.kernel.org, Oliver Mangold <oliver.mangold@pm.me>
Subject: [PATCH v13 0/4] New trait OwnableRefCounted for ARef<->Owned conversion.
Message-ID: <20251117-unique-ref-v13-0-b5b243df1250@pm.me>
Feedback-ID: 31808448:user:proton
X-Pm-Message-ID: 6a407b36d3d339aba0a481e59f0ac3f5cc525bfe
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: u9461u4tnpsej76cizr3a4ioh4qm7qnd
X-Rspam-User: 
X-Rspamd-Queue-Id: DE54F40004
X-Rspamd-Server: rspam10
X-HE-Tag: 1763374059-606480
X-HE-Meta: U2FsdGVkX1/n13yQm/rIW4BMwNjLF+8so1vRE0D6P/T8+LfdlLbYtpiFt7U1s7vB0LBQen3Nnx03g3QdXu10A5TDCD6bCzOvH5HPTvBsouNe3ocEbnjhFpJlRlOImcs270L3hR3ssH8aSPV8IM71VN1uNin1/eLpaotFvk9hvaMLconGHNrtmJTNTxSleOEtEz1Zv9o7ht0VtNcL/9kwqgT4OspFiZ0Hh17qb3KT9M+2F9+pUaSB1yFMIDNeB9MhVqtfdYNt2HUMXcsVJt6CoTv5uRj/z17iZi/84kl4FUBsvymk4IV/Dj3eUeW3f1AQgRZwUzmayvPapyMyyY6Zs2bfJxrYVvmcSFupHlapxHuCSZh93nHd74JF3blJ22+YwUOcIwXlKh01eS0u9zFI8bRUJIBCwPlahfxt34YQNMcmWnPybWssCThJ3ZekV6cHzwpp9f1QjWfoqzcqiJKQKixq3X1xVmrCo/XhekpLoRCeLEE4TZWtkX4tfuGdEZM7b+uqCztxj0c1KLkc1tPom9aLEtVBZVegXoQIg51la363tcU7RzV/4DVP6N5DXDXSPZTXXnHkj8ewYFXYdQ12fV69DnQteaPIbnTZJ0kUErLGw10oORorxJtagBfmr2+twer+C4Y48sFUdrTCEvEjBrivF/mC7Yv0mv0FfJFT3Fq+s7DTKIOu9r1kdDuC65dJhlQRHR9g3Y+RFOqKhlK6EEYeqVmJwsxtzecTNzkNxS9MG2xi8HCiabOjnjcFu9S0+uV1k5N3oTme5Q2uPRN9W+LBxtM2Lv9+fCJiLth1sWbn+pcJtdQARYs80UiG0feyF1A+V9g0GGuUQvJzQDJnDOFk0hlq2s2gp3feB74urf4ypPCGQUKx9frHP5NFFQZ8BeTrPv/Q1vYrnqW1aUC1t0cWs1urV7nKZlCjvZGHxtLi4UJxGlnpxVdy+T2FPZH/2aDrmDS9Yy81R6HjL62
 Ed9e/cfz
 UA/ZsKR2KrTmDJlJ2dtRxr8odr6ne0J5qrIJNssrSJ7yE2yc6/xQTy5L2E114sQHC8q6ebBaX/UlwhKVrNm1N8/nDXCH+Df7t+iNrIwSg3cNw3xqrMcTfWbyGTEUcriS7CoJAQpicFvjgwmzgbPny4Zoz67+7KgtwnRb4fADSY8DpSyfo+p1mg8mHJwrj2TQyPZa8mB05wfgpsNcx5k+deHjvnlxYjwQ0halMveg418MnwCxnQ6OlK2Oui38rSoPqsVTjc3TxES0tExRr8BDrGTt5SmHaC3C0PjABuVSlzvJVv5OLjH7hZaOe3fMmyW12wsM6
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
Changes in v13:
- Rebase onto v6.18-rc1 (Andreas's work).
- Documentation and style fixes contributed by Andreas
- Link to v12: https://lore.kernel.org/r/20251001-unique-ref-v12-0-fa5c31f0=
c0c4@pm.me

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
      rust: `AlwaysRefCounted` is renamed to `RefCounted`.
      rust: Add missing SAFETY documentation for `ARef` example
      rust: Add `OwnableRefCounted`

 rust/kernel/auxiliary.rs        |   7 +-
 rust/kernel/block/mq/request.rs |  15 +-
 rust/kernel/cred.rs             |  13 +-
 rust/kernel/device.rs           |  13 +-
 rust/kernel/device/property.rs  |   7 +-
 rust/kernel/drm/device.rs       |  10 +-
 rust/kernel/drm/gem/mod.rs      |  10 +-
 rust/kernel/fs/file.rs          |  16 +-
 rust/kernel/lib.rs              |   1 +
 rust/kernel/mm.rs               |  15 +-
 rust/kernel/mm/mmput_async.rs   |   9 +-
 rust/kernel/opp.rs              |  10 +-
 rust/kernel/owned.rs            | 317 ++++++++++++++++++++++++++++++++++++=
++++
 rust/kernel/pci.rs              |  10 +-
 rust/kernel/pid_namespace.rs    |  12 +-
 rust/kernel/platform.rs         |   7 +-
 rust/kernel/sync/aref.rs        |  69 ++++++---
 rust/kernel/task.rs             |  10 +-
 rust/kernel/types.rs            |   4 +-
 19 files changed, 492 insertions(+), 63 deletions(-)
---
base-commit: dcb6fa37fd7bc9c3d2b066329b0d27dedf8becaa
change-id: 20250305-unique-ref-29fcd675f9e9

Best regards,
--=20
Oliver Mangold <oliver.mangold@pm.me>



