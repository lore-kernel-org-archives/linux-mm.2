Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8C13606A88E
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 13:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bJ/mcWex
Received: by kanga.kvack.org (Postfix)
	id B6C6A6B0674; Fri, 13 Nov 2026 08:15:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3D096B06C4; Fri, 13 Nov 2026 08:15:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A52856B06E8; Fri, 13 Nov 2026 08:15:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F1286B0674
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:15:48 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4390D1A01D3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:15:47 +0000 (UTC)
X-FDA: 85430143134.03.BDEE227
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6E7B3C0009
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:15:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bJ/mcWex";
	spf=pass (imf28.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794575745;
	b=ZNwpILUqL9ALw3Bqr6QM8DZ0Gwqvu+XTjrsMRdGDfawWINb8afIMlOCt4gOnHG6zTsYOjn
	2Mdf/waW0cc5tMtUER18G83nisbDSzGBdXCnmUgjaEs0T8L8/USdPlbScp0IFylyi1Yfrr
	UJlynvmHBmQlQs3tpZTVAOTg4LA9s1A=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bJ/mcWex";
	spf=pass (imf28.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794575745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1aZKuVfqAwq3aF7E48eY2ljSMjRhHnwbKhA5hVmn0v0=;
	b=lZTpScOqjHH0hW0r/6LpvJndnkwPKddQbvUCf0wPGHqxKgPKe3hxPozCjl5PohL6MTSRaR
	lwoyJvDbMenEbsBfH6nxdOStL6AFwpZk0K4XN2S0t7W+R6NsbC/6wlalzYT4IMBkBxWjyj
	pbB5k503nNLjfgm7b5+GklNj9LV8nfk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CCB24447E1;
	Fri, 13 Nov 2026 13:15:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D89D1F000CA;
	Fri, 13 Nov 2026 13:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794575744;
	bh=1aZKuVfqAwq3aF7E48eY2ljSMjRhHnwbKhA5hVmn0v0=;
	h=From:Subject:Date:To:Cc;
	b=bJ/mcWexC54VFW4UjRxesgcl+VyudIrcvRoC/cdtY6t/vRCj3+ZOa0ZRVs8APWVKc
	 xebIe0DCratTr6YgDN7nlzNv8SPzwbqdkAu5XWMmTJ+X3ARRjTd2fqLafZUKRFh1G/
	 8QHmPE12f21StF0W3B7HDbK1FWOKy1v90RT8PG0X3ixfmGgHhPh2PxPw0EtWYXLgTt
	 7PSuqmgrbPAnxDJ7N/1SF4FoFxQQyCc2songKyyrtZQSfmMqlTXGV/bmJ+LgTsOrCW
	 Gj68Rim7OqF+vNiA0K6+AuT6hHANJokmyQ/ytG7p82gBFncm2WUy3XL0h0L+G+s0db
	 CxWZSt/FJxKcQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Subject: [PATCH v6 0/4] rust: byte-wise atomic copies between `Page` and
 shared memory
Date: Fri, 13 Nov 2026 14:15:07 +0100
Message-Id: <20261113-page-volatile-io-v6-0-5603e527c919@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFwN92oC/33QzWrDMAwH8FcpPs9Dkj9S77T3GD04sdyahbg4x
 ayUvPvcHtaNhKHTX0I/gW5i5pJ4Fm+7myhc05zy1IJ92Ynh5KcjyxRaFgRkARXIs2+9mkd/SWM
 bZgkmRuOMgS4o0dbOhWP6epAfh5ZPab7kcn1cqHjv/oNVlK1cVEHxPpI1759cJh5fczmKu1bpK
 RDShkBN8MoOvesCmoFWgvotqA1BNSFY0PuuBx00rAT9FCyYDUFLkMCEXXB9RPQrwfwIiLj1B9M
 E75AjGRpI93+EZVm+AXRR5fS5AQAA
X-Change-ID: 20260130-page-volatile-io-05ff595507d3
To: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Lyude Paul <lyude@redhat.com>, Abdiel Janulgue <abdiel.janulgue@gmail.com>, 
 Robin Murphy <robin.murphy@arm.com>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, 
 dri-devel@lists.freedesktop.org, Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4221; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=dE2x5+sedjQQAerFZe5rFtXnhp0JdwJhXalq/y+NFA4=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBq9w1eArzTzNC08MoRY2Mt8P+kQR/rdbMnYJFKA
 5PcazRZ3aiJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCavcNXgAKCRD6UCkIqsW9
 0GN6EACvjSsFVycJSX/CKfKkMv37Y5hdTZUwtNL/K554JNHrBbkv9hlx4p3q0UaFr3Uv9+3LLHH
 KSXTWcoxx/1B6/xll9rJb8jevMIwCDKBNPQwzCGsck4Z0wJKnRKFXS9dka5jxw0ywkmaW3K9Fj5
 ay60DqX4Zjf0xcpSiIboLGXqsC3gyeHtKANP11m5MJXOk29I1tQxq/DyTjp5vhBkmWK9+WHEIlo
 TLWniOLbsnXyDnagwsc1f85/OEejH3+8TrR2ht3DAI3hjSdwjrKNpkFN1FaQ/IL7U37sQcWbOdR
 U/gYpCOLX187Dh03z8LPd8S3mdXEVCFeyn2dCnA26FHaOvNC+RgwI/5ZQmVburYXea1S4wQC7Kg
 ePFyYU2OOqoQvIsOGTVU/JCCjYjE7bTLOKk+7Jc34OEdUzuewgny/z1vzLBLV5+GAfTG8svRZwK
 YQT4Xg8lAN81I4TDblGg9ffr/bDc2jZposOHkQdL40IjP71+yyoA2+e2u650db/ZI/CY7MlqjvX
 nfHlV6JMhYrOIYibewdPAxAuI6Sua4CNuNRdPj1aOIu9dyOSvfeTsh32HyOgK8tdzKUC0VO3ZTi
 uoE+lMRkBCcufbNQs+1Zu3Y7Dz1bA4lbcP4QJZBCibNP/hQy/Il4hTFhhkOqCHK8Hw1yHCycEMt
 LZy883cWGRy41xg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Stat-Signature: h7xfmgkta9xho54zpijqkqpoxnszetyc
X-Rspamd-Queue-Id: 6E7B3C0009
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794575745-599627
X-HE-Meta: U2FsdGVkX19FgmVwcNAlJlcmtBpUUjkbwEizb0QP2gYaxHdtw3H1fhtrzy+vZDEN04FouY1hud1uvx7QRoFvwieins0GTEiSBcxBferUuQcNkwNc0I48BC9h+f0iI1kNPS5sRGaMcOyOKm+QDdtAo+d1PRz0IEqi9f9l9WzscbIY1uv6HxeRDBJFoDDpX6Dv/ZdhBEecPfAWqRbICbWWIqrDezeu/SwpRTK3PeBrOnXdnSZ1TZ4NeKWfR8XN665JU7cSwha68HVdckqyBTGIS7Lyxna7GGKej9W5S/ElmOgUil9ZOS4NQgD+OwNisjt1AGdipnauJaqH9ePG1yYjtTeaUc5+iItZOYWIeLSiHVVHG1vY3GuResviXuuB3tfuTZTNl8QYSb0p6MgvrhnJOj0H/8TF3qJNC8eeMFgK5e4xJXa6KzdvvHLUCOCgZUzHbGPVyoHm6cRRPkU8kMTy06fnz83NH7BC6Hw8su+of0RLQAV8DDyk0okWNTxOyZglNLxunU4F0EfVIpbDU/DyljqLQ36xoCeEHFXgZFCTXwC1x4cqUUPzbC7TbNdk4e8UNLtrje6nKGmt/Bgwa11LeDsoCR8ucrT8CSpZPUU3RiQ7CYEAx1NXbAsXGwWYHtijykssIWznlO11duqzUd9ARIxMPRgZSgQXB77K4rWQG4ZE35LnpHIR1ppZ23HkXv841WXxyZBmlUjPFTcvFNvsZcR86q1rY3iwzHpwPV5yTx6N+V8zJqvo0eFFsQ3RGcROO4nqntX9bP6yXtgv0BK2eDkpw46nRoJoZZharmzNsE5HkKs9jMZwMsusA3a4c7Hcsl71UdBf8qZWmpvIvayDi3QGHNDYSo8AiQIGvBOjhO5VN7dvS4OGeygg9Y9VT0ZXJaOWXI/l+dDI/CbTMjG5TQvcmvL8/d39bhUd4yh1qhvi4b8An+nX/TrmDUjBkseDLRwVH//92rcyQ4kXAGG
 IzVwqsFf
 LfmiA9KKykKuv3SdzWCh3HCx16TmWje51iCtifm0V7MH8CQEHvgJnzsPmn0jRa6lIQ2r+YcriURT9zg28rxguPWMK7VTGY+aVEFLwVFNBSOhvAByrueTt8nQcEN1qmVV/R/Iwp6otqs7kCHqjSdmwFZRoPMZB1WRKaw6TTqMWQUKLbAgEmiXVNC6ep35OA1zg2QHAh1s2dJUbC/oBCGie/Ts7FPpd3sE45wwKgUNYmcGWc4fQYFSPeTnpJkMgnMIkwN7crktzktCTlWiyypzLFMEMeewgXBHWF2XQyO2v0NLbBL7QQz86lYwbNCgLQUdWShZdaNYSewBTNaHJmAIdoL6kzNO6+89qQh6vsBFAOw4QZODEIfh0BRJrLO3pmVh7hgfyrw/i3BV6o99O4w7+hMParw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series adds a way to copy data between a `Page` and memory that is
shared with actors outside the kernel, such as user space threads or
hardware, without introducing a data race.

The copy is built on `SysMem` from `kernel::io`, which already accesses
system memory with volatile or byte-wise atomic operations. The series
first makes the requirements of `SysMem` explicit by requiring freedom from
racing plain accesses. It then adds `kernel::sync::atomic::memcpy()`, a
wrapper around the kernel's `memcpy()` with explicit safety requirements,
and routes the `SysMem` copies through it. Finally, it adds
`Page::{read,write}_sysmem`, which take a `SysMem<'_, [u8]>` view of the
shared buffer.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
Changes in v6:
- Require that plain accesses do not race with accesses through a `SysMem`
  view, instead of forbidding them for the lifetime of the view (Sashiko).
- Update the safety comments on the existing `SysMem::new` callers in
  `dma.rs` and `drm/gem/shmem.rs`.
- Rename `atomic_per_byte_memcpy()` to `memcpy()` (Peter, Boqun).
- Refer to `core::ptr::copy_nonoverlapping()` instead of
  `core::ptr::copy()` (Sashiko).
- Add `#[inline]` to `memcpy()` (Sashiko).
- Rename `Page::{read,write}_bytewise_atomic` to
  `Page::{read,write}_sysmem` (Boqun).
- Link to v5: https://msgid.link/20261110-page-volatile-io-v5-0-a91ef252c24b@kernel.org

Changes in v5:
- Rebase on v7.4-rc2.
- Build on `SysMem` from `kernel::io` instead of adding raw pointer
  based helpers to `Page` (Gary).
- Add a patch that requires freedom from plain accesses for `SysMem`
  views (Gary).
- Route the `SysMemBackend` copies through `atomic_per_byte_memcpy()`,
  so that the requirements of the `memcpy()` call are explicit.
- Let `Page::{read,write}_bytewise_atomic` take a `SysMem<'_, [u8]>`
  instead of a raw pointer and a length.
- Drop the claim that `atomic_per_byte_memcpy()` is volatile.
- Add a non-overlap requirement to `atomic_per_byte_memcpy()`.
- Add examples to `Page::{read,write}_bytewise_atomic` (Alice).
- Link to v4: https://msgid.link/20260605-page-volatile-io-v4-0-0e217d9bf11a@kernel.org

Changes in v4:
- Split `atomic_per_byte_memcpy` out into its own patch (Boqun).
- Expand `atomic_per_byte_memcpy` documentation to explain the
  concurrent-safe semantics and to note that the kernel's `memcpy()`
  uses byte-wise atomic load/store instructions (Boqun).
- Clarify the src/dst asymmetry in the documentation of
  `Page::{read,write}_bytewise_atomic` (Boqun).
- Use the "valid for atomic {reads,writes}" shorthand in the safety
  lists of the new methods and of `atomic_per_byte_memcpy` (Benno).
- Drop the redundant data-race bullets that v3 added on
  `Page::{read,write}_raw` (Miguel).
- Link to v3: https://msgid.link/20260213-page-volatile-io-v3-1-d60487b04d40@kernel.org

Changes in v3:
- Update documentation adn safety requirements for `Page::{read,write}_bytewise_atomic`.
- Update safety comments in `Page::{read,write}_bytewise_atomic`.
- Call the correct copy function in `Page::{read,write}_bytewise_atomic`.
- Link to v2: https://msgid.link/20260212-page-volatile-io-v2-1-a36cb97d15c2@kernel.org

Changes in v2:
- Rewrite patch with byte-wise atomic operations as foundation of operation.
- Update subject and commit message.
- Link to v1: https://lore.kernel.org/r/20260130-page-volatile-io-v1-1-19f3d3e8f265@kernel.org

---
Andreas Hindborg (4):
      rust: io: forbid plain accesses racing with `SysMem`
      rust: sync: atomic: add memcpy
      rust: io: copy `SysMem` with `atomic::memcpy`
      rust: page: add byte-wise atomic copy methods for `SysMem`

 rust/kernel/dma.rs           |   8 ++-
 rust/kernel/drm/gem/shmem.rs |   2 +
 rust/kernel/io.rs            |  73 +++++++++++++++++---------
 rust/kernel/page.rs          | 121 +++++++++++++++++++++++++++++++++++++++++++
 rust/kernel/sync/atomic.rs   |  36 +++++++++++++
 5 files changed, 214 insertions(+), 26 deletions(-)
---
base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
change-id: 20260130-page-volatile-io-05ff595507d3

Best regards,
--  
Andreas Hindborg <a.hindborg@kernel.org>



