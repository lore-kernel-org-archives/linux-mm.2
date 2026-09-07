Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3ADDC79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:48:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 869AE6B009D; Mon,  7 Sep 2026 12:48:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A8216B009F; Mon,  7 Sep 2026 12:48:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CFD06B009D; Mon,  7 Sep 2026 12:48:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 15B4E6B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:48:19 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8D44F1A01DD
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:48:18 +0000 (UTC)
X-FDA: 85187549076.27.91B8F2D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 923CB1C0002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:48:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mCXN2QAe;
	spf=pass (imf20.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788799696;
	b=VkoLIlX/5i7I3nS6C7oW+Pg5q6z8BBqdgwwj45Dc3+O8pfCI5/eKDHOjZJdut/J59XKBRI
	TJUi5AjrUjT45zAKTfm2X+SKIRa/TiBqw3aklN0xe0nuQcDK/ia82HIxJHA8oU2CMGaWrj
	neIxwv+D5Y3+jn18KJh5Qtyn+GbkjYk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mCXN2QAe;
	spf=pass (imf20.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788799696;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=iRuxZLJeP+7PZ4qRhsglgIJjTiw/EENG/knrgNszNmM=;
	b=LRpFySS3CAwzHSzo/tauNB3vmzPIewaQAWysIWpAe8LJ+lWl9KMUYFGMMJU6hFYAlwn1kv
	NdEJHMYu8BteiaQ9Mpr1HeuMjpq4nIhIiuE494XoqcSt+/pIkWIsmn6uViUK0/eZXwC6Ms
	YRMTPteVyxNqL/huF9LZcNHliDlyUnM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 821E440367;
	Mon,  7 Sep 2026 16:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4EB02C2BCC7;
	Mon,  7 Sep 2026 16:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788799695;
	bh=ugf+3s9PSyGAiuRrMcsfXDjILNpU++jjwzu5JJ9giJ8=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=mCXN2QAeH0qjPksLPGX5Sd8iHxXfjvSJRxd1ISUNWifwnPguwXvkXl6QbDKdDRZ7F
	 FycIffpGIFKcxr00LwyM2KZtNUZZybn+DiXP0zzFAKoOs7coYSuyV3u7LwdsaxbUPu
	 bVVhLTk218fT+pKP4vYlwdtWMUMSo71ByYRmPmIUGiT/8a8iSKEiSSx+i5qPM//IVh
	 m8LyvKUkjhkjOHthoJ6YtomjxgbLOFRyy7EivO77F3/t/NUHB9EHrXdjtVISUA5twH
	 wn8EE06bFkDLXCgZb2yVt02GsxyBcgEQ2i3j3HWjxqksvICbBmvfIeE80s/zs+15GC
	 T5fSJDDUo4uCQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FB26C79F99;
	Mon,  7 Sep 2026 16:48:15 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Subject: [PATCH v2 0/9] drm/tyr: add VM and BO ioctl support
Date: Tue, 08 Sep 2026 00:47:47 +0800
Message-Id: <20260908-tyr-ioctls-v2-0-88bea777df67@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALPqnmoC/03MQQrDIBCF4auEWdcyughpV71HySLq2AwNWlSkE
 rx7baDQ5f/gfTskikwJrsMOkQonDr6HOg1g1sU/SLDtDQrViBeUItcoOJi8JeEkkkNrtFtG6Id
 XJMfvA7vPvVdOOcR62EV+1x+j/pkiBQpCZ7WbtJU43Z51Yx/S2XiYW2sfnoRSEqUAAAA=
X-Change-ID: 20260901-tyr-ioctls-f10ef0dcbfa6
To: rust-for-linux@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Lyude Paul <lyude@redhat.com>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, dri-devel@lists.freedesktop.org, 
 Ke Sun <sunke@kylinos.cn>, Alvin Sun <alvin.sun@linux.dev>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788799692; l=2330;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=ugf+3s9PSyGAiuRrMcsfXDjILNpU++jjwzu5JJ9giJ8=;
 b=ZORc0oMwW5l3N9ppq/jrr9PENAwfIkL5qA+VfygKJi+UlDdBIzYqYtuMxE/JT6moDx0PZvFco
 ld1n0m+H8x2Ckk3gfwq9rUCzc5HpBK9X+Slchoo7nftAcQTpie/H7z0
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 923CB1C0002
X-Stat-Signature: fuwpqrz1ci66bn317duwciqb9wmqbtow
X-Rspam-User: 
X-HE-Tag: 1788799696-427599
X-HE-Meta: U2FsdGVkX1/nz2toBg/QTmpzfCW/p5lsdoGKf3H4+n3Na3iRKMPm51HgI+OoC/j82sTnjFCjzr1pj1mIB8znY8Feyek8dBs4mAUxFQi1nQVhd68vvs3zfsPGaRxq7HiKByERn5P2wMl6oO01kCdsC1dB+BSzani3HPQEELqHnGKHsLSsccq0fa8C2DjRSsbiDBp7cuTpSWf18Oka8GFAi/ExY983i9Y7ExK2o1gOzpEWGYIcUIWAl3WrmiB622V3QB7oilSXbLehdgaWJkrrXr0CIzv3K65JioNt9QTZrrHL88P8wapmOPs/6rz/j9luZXlRVIpWOeepEJZMtnZCG5MiJ9IvO8a9sz+LXKBT7QkkXDbdER8FhTlgMrJqtqweYZhjhUks+1Aexf3mtQfexsO5KhuiwmqzHYbz7iMifbqR8gxbBoqi4Lw2cSjMVvP1fwsmUKikIU7/v5i2UB47SpDDGNx5zF45WMemTIJ/vPfnIYTpNijrQJE9EN7Qlj9wjf3N2a8awFGWWNwayxvLF8fr6dcb92Dmd695JgSnsvLs/NBN2ZZcdk07AakpJS9GDBQJZeWmNnzlMkfwH74Anwb6BkPOTG5srIiW7MdNF1TihID37JBO2prrEZjnziZ85tkVtdy8C4sySXpbvqleqJuXRsrzlFEEd81hTGQrKOeAT+n7xc23WnPIZ2/Ddlmj1AmJsqMI3ZWWv0YzDP3N9DMl9Aa+9aanyuT3qCpgr0SmGxRa22hxiJtEuBjFYl2P0x1UAaTNVmYbLpCt0eJArCAWS8O3f34cRJYpLe3RNG5vwVqyU+G1b2VajA7UQryONWZlFAFKiKBQSpB8Lg3k/fcwMEcdJXPD2qs3Q9+CXjgwkIRjw4391VA6Nc0ZEaEXdK7Xd/2CGeK7xOcI9/ycozutQqQ4Xvmxpw2J83mUNmXTMq05+n4rx+NbUwucPz995CZI/pGuDZoRfXMf7py
 bvYPSqgC
 ffsyNBYiZipCgCULQznB6ML/0bukDi/nEiT7dNAYHn9jvdd7spR7UV5m0xV4PREDiZnEvgnu5U0bBkqd6e+TaDm3zwnA39z3g5HEOocwpNNk5JsywVRzrQnHHC5uYhC2CHAdmj3rOyjVChCmIFKFUIjf+9a8F12/pBW70xCiT0syyp3BV9dx8jOQsMxbR6h1ckNNsbtVYnb7lJbv8I6HYQ0SXNgW4nd95vsDpO+Bghoq7Wzh+8zA3YrCIYg8poOnYg3uOJl99oCymSVgCCyJgM94V3WBwA13dK1Jc4stF7S4XDymWesKeDotUU26fpWzQO4A7jl9QliS2lWMLub0JiYThxhPTMYm38E8O4po8a/tSYds7Nj/exurHxIOybDlJ1V9Ch+qgzRXa+TGABGs/j/eb1bt5Z/h9Q3ilfL6jUaB4oHkpLZnlwXEgkREheqnwUKYNSKK7QdIKCYAh0VUZ/aJATw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the VM and BO ioctls to the Tyr driver, aligning its userspace
interface with panthor. The series is based on Danilo's `drm-file`
series on `drm-rust-next`, and uses the existing IdPool and xarray
abstractions for per-file VM management.

The panthor IGT tests pass on an RK3588S device.

A branch with the full series and all prerequisites applied is
available at:
https://gitlab.freedesktop.org/alvinsun039/linux.git tyr-ioctls

Signed-off-by: Ke Sun <sunke@kylinos.cn>
Link: https://gitlab.freedesktop.org/panfrost/linux/-/merge_requests/64
---
Changes in v2:
- Fold the VM pool into vm.rs and cap it at 32 VMs per file (Deborah).
- Add VmOwner so a VM is killed exactly once on drop, regardless of
  remaining references (Daniel).
- Replace the VmSpec enum with new_for_fw()/new_for_user()
  constructors (Daniel).
- Parse VM_BIND op types via VmBindOpType and use the kernel
  Atomic<bool> for the unusable flag (Daniel).
- Use PAGE_SIZE for the dummy object size (Daniel).
- Rename BoData::create_flags() to flags() (Daniel).
- Report VA-split failures with dev_err! at the caller (Deborah).
- Link to v1: https://lore.kernel.org/r/20260902-tyr-ioctls-v1-0-e0fdbf8bd108@kylinos.cn

---
Alvin Sun (9):
      rust: sizes: add SZ_4G constant
      rust: mm: add `task_size` helper
      rust: sync: arc: relax `ForeignOwnable` for `Arc<T>`
      drm/tyr: add per-file VM pool
      drm/tyr: add user and MCU VM specifications
      drm/tyr: add BO creation and lookup helpers
      drm/tyr: refactor new_dummy_object to use new_object
      drm/tyr: add VM-related ioctls
      drm/tyr: add BO-related ioctls

 drivers/gpu/drm/tyr/driver.rs   |  14 +-
 drivers/gpu/drm/tyr/file.rs     | 378 ++++++++++++++++++++++++++++++++++++++--
 drivers/gpu/drm/tyr/fw.rs       |  37 ++--
 drivers/gpu/drm/tyr/gem.rs      |  41 ++++-
 drivers/gpu/drm/tyr/vm.rs       | 378 ++++++++++++++++++++++++++++++++++++++--
 rust/bindings/bindings_helper.h |   1 +
 rust/kernel/mm.rs               |   7 +
 rust/kernel/sizes.rs            |  12 ++
 rust/kernel/sync/arc.rs         |  12 +-
 9 files changed, 819 insertions(+), 61 deletions(-)
---
base-commit: 3ac51829f95368876dcfbfbb42823ca0cd6e6f56
change-id: 20260901-tyr-ioctls-f10ef0dcbfa6

Best regards,
-- 
Ke Sun <sunke@kylinos.cn>



