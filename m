Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A5EACA0EF7
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 10:34:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE1C08E0002; Tue, 19 Aug 2025 06:34:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E94058E0001; Tue, 19 Aug 2025 06:34:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D808E8E0002; Tue, 19 Aug 2025 06:34:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF0DD8E0001
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:34:54 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7B8E8B8147
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:34:54 +0000 (UTC)
X-FDA: 83793148908.25.87903FF
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7E04E180005
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:34:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="NFjs/gbY";
	spf=pass (imf16.hostedemail.com: domain of 3SlOkaAkKCM0t41vxAH04z77z4x.v75416DG-553Etv3.7Az@flex--aliceryhl.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3SlOkaAkKCM0t41vxAH04z77z4x.v75416DG-553Etv3.7Az@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755599692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nUpwGXtPsuYcZiqgPmHlEahRTTleAV9z3vih0hihcig=;
	b=6R6EfuJLzJdIVt2SBwvdOPam4Zr9CJIskczqEuGla0BktqFZw+Sf06M1t4nUEXg3BzEllo
	SZ+pIeJPwwWtFJkIY9h/7xPayE6LsdSamBkgaWc0Lbu3EPZfdnI3SaciHr2CjYd8PfSOdI
	knYDxUqdCa6Xi2hXZQbpvmyhUZ/Nj4g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755599692; a=rsa-sha256;
	cv=none;
	b=NdiaPAmiF1dU8gdGQA4liJKYdIp/AgXKmDs4XvruZoUBzhfAEEvpm4lSoKeG0u4kY7FONV
	PAZz6hLe+ike6GmhMm6wxGZuMVurY7uAbtFDmCDOWLve+9AIJqRWIid2lR1lmnTOu+8W00
	9mNp/DPHxRODd0QB0kBQ6iwUfMPdass=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="NFjs/gbY";
	spf=pass (imf16.hostedemail.com: domain of 3SlOkaAkKCM0t41vxAH04z77z4x.v75416DG-553Etv3.7Az@flex--aliceryhl.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3SlOkaAkKCM0t41vxAH04z77z4x.v75416DG-553Etv3.7Az@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3b9d41bda7bso3128783f8f.0
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 03:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755599691; x=1756204491; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nUpwGXtPsuYcZiqgPmHlEahRTTleAV9z3vih0hihcig=;
        b=NFjs/gbYY0pLAEVfYFzCi1r+OWLbWKaPZ1kw1U/UKWyCVciFMpaQmPJJ2us09fpRfo
         eJpHtojlkB9lNQ8dTWYUr6fc9ah0TQY1drBJzkLa41lRANBJzaGRLR8muYwq1MQpzZpT
         aVCcvdqkgIDaAeGsZxNJNpdoIC5kZmdFtk9REOqM5oP1vrnHl/CT7r5vHNVnk4w5p1zN
         XVmWNWVyybbGAvY6RvvEBuJnuSC40v2TPd3pulBj+5lzcQqIeR3gM9eByuoBLdMNVmtf
         h2UkzpkzEDaC/Y/nJrMvexoPVk8wOicE96XdbNIj+3SNyimjhf0g0E1ejEaaoknvhjj/
         +iIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755599691; x=1756204491;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nUpwGXtPsuYcZiqgPmHlEahRTTleAV9z3vih0hihcig=;
        b=k2LUeg/xjd7x4qJSZ+r8sUtaF+QLJBmpqakv3MppyKHqKvd43T77nDeKiSRVQzxMmH
         89+pPyKXGHAavBhluc4bELXlLAiUL732g53K5sb5OM5Uy+9fZM6ZM7pNyEd3WT3u94hw
         x5yLFbPDykGr6CIe/wT1tjzSZffs35mNQSjKEFc6wIADf9XVrxwT+lFyB9t/Y1BJQfij
         Vl9fWA3wsMMNGYLvehUOgi7CCziWyJDSqN+5r43hwVyx94R0Unh9hLKn0O9KkaZUYxp7
         iCcRw5kRYU3LVny6KuYDHnxjeqT/ATWQWN86mzj6xNXOYHJCtMbKI79xulc1JR32h/Yn
         AQOw==
X-Forwarded-Encrypted: i=1; AJvYcCUa1fTs8NqVyUajkxp8Bqgn6KliY0taRdt/VYLOBylWn3fu5iYgaG9kUwYVlsjs+6t+8nYAA6lYow==@kvack.org
X-Gm-Message-State: AOJu0YyEALJcTgC4MCtQyqA4MME6Glzom1mzUA3T6Yut3E9Ze4XNH0y4
	AZh+jFLiaNJd9oaksAd4qWZi3W+N3agLare7ds8+dElkkBDA0PwdQvQuFuUq9qHZyiKUapO0Zba
	Pi5tJ24lAlbBd/gP59Q==
X-Google-Smtp-Source: AGHT+IGwEKfiF+9R3ev4WMuyEM9qUSGM02LhWEvdJ6r8tdnWL1vLQrgTalKgDTZQ4mIrG4nr5x4DKyVjTzGONUA=
X-Received: from wmv20.prod.google.com ([2002:a05:600c:26d4:b0:459:dfcf:15e4])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:588b:0:b0:3a4:f72a:b18a with SMTP id ffacd0b85a97d-3c0eb420967mr1536920f8f.26.1755599690768;
 Tue, 19 Aug 2025 03:34:50 -0700 (PDT)
Date: Tue, 19 Aug 2025 10:34:41 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAEFTpGgC/23MQQ6DIBCF4auYWZcGsBTTlfdoXExxxElUDBjTx
 nD3Utdd/i953wGJIlOCR3VApJ0Th6WEvlTgRlw8Ce5Lg5baSKvvYsZ1IrFFIqFwkI2s0Rl9g3J YIw38PrFnV3rktIX4Oe1d/da/zK6EFNpi3aN1r4ZM60PwE11dmKHLOX8B3RzkYaUAAAA=
X-Change-Id: 20250726-maple-tree-1af0803ac524
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=2199; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=WpPROqoo0BnpflYnwbdZ3+4XjUHFfPcbIfG6DdIRDRg=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBopFNIbiYozs7ReLuZ9YQ5+qDzKU7SUGnD5DTvo
 nA+LqKnJhOJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaKRTSAAKCRAEWL7uWMY5
 RsWYD/9u80fITsQA/OqvOLTayeWvQaATgmkD9aebtT0oG7GJK1+QwKLoQysRbw0BPu8GOLH73CS
 0FRJ559/nmiTlynnEUBo9V4j51BmTYMW9RJNAJxwaEVjBPqeoo+2vwW2NQHo81RaVowtTRRcgXr
 DJf6yXXKNboZiSj/rLnfmiBdYOBTcAJeVXJ4OQhis7N4li2Na4oXz/giSV1f4LbvyGXit9+wZoQ
 1ni7ozAUJhy/pQlNAM1AZepp+GIC8iILM+J32wiksj9EdUP9G7xtJsmc0SWxfxYzPuTR1hCXAUN
 Ucn3KXq+LCnXLKx3O0Tkuai5bvmZBfHm5WiYeCaoA8H43sY96LSe7dI0Ak8oyp1IXEaa5Idrj8e
 v23isVK3NTyWp81zf5lXz1zdxQpQwC5ygYDEjc+1yDWqWfyhIYa+k4o1bsLiVqtvMUEHL5PsvE7
 Z3w+pIRKKKW1RoAs58d6aEbDTowinvA9R7rAyETLI+sMA5f0BwQ0YsdrqMSTEys0kXQlq0OhpwG
 Xa/KB9svBXJ00dycsyeTpusllO+JC4JESEZkQdPEX/nxX1eroHG1u80ZpZsYy3bh+RS0dXff5vC
 5DbyZ1gaXqDC7DZr0z3VVPMWo+2u/nfqFIoay9XthxSrZIVStTYwhCvQLaDJaQiW+voH9cynlx/ /FL1CA+ZzRcHdSQ==
X-Mailer: b4 0.14.2
Message-ID: <20250819-maple-tree-v2-0-229b48657bab@google.com>
Subject: [PATCH v2 0/5] Add Rust abstraction for Maple Trees
From: Alice Ryhl <aliceryhl@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Andrew Ballance <andrewjballance@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, rust-for-linux@vger.kernel.org, 
	linux-mm@kvack.org, Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7E04E180005
X-Stat-Signature: frw4j4sjigjyappzmrtk7ihh34qnffad
X-Rspam-User: 
X-HE-Tag: 1755599692-821418
X-HE-Meta: U2FsdGVkX180v154BR+cCVUL+MoeSVLDS7Uge4CkIoOY45cawqxwNr/j3zGT2YApOdgGBD3j8tM8JtdcmnWms+01UZvttS/apUtGG9x7tYPqJTb5EZ0f9Sb/irYkzuhVgqAmR6/ZdpKiEwQ5NEcdbWAtzFK0JFYYEVpP8Z1RyUf7REnhZ4Y6CO7DrJpZcddmKtAwauYA/TE3/+/vxczGx7y7PaeJtqGQSHb7TNtk5zOIi7wnBBxs420ncY9LdFUI3dFu3AhVzw+bN5R2AL+rXmO2M5ea88VGOwdT0T6l6zhJdfKsfFmdaSc5Lio9w3cOFWhydtpuhtmGPmT0ZZqu6OK41sjreBl3vtqlnq7Dn+yhu5lMQuty7CsIDaK8pwlZubvGbT0KqOcpLOzL950zbrH5MlVu3DbfDTCjn65ACMlAllX0bJlzBZXf71vl7I8PVj/NhHCPYn7EJHNzYPj1e0f0D8rW7er/HFky5dsjTIk2/Yv9MHugIj9luVR8r04PVfoQjlLskfsjW93IWzhDMVo+bJY1xr69kUa3rX+FRLo5/WxSjRSOKa4I26wKiXVaDVjzzM8BnWe7Vfriiq1Hg0DMGwKOV2IAPlj7n16ozRbOR/iPgJtFZ3bnwCp6rkR5iHxL7d4LygYSt5Y7nBI5xAaZnqcj9ToYbn+DoB8Wg+jtT+Wz8FCPgPECCtfFpp5cMnAQnacTm5iMrEhrXY4b5O0vRLjvDxCnUViCsdJToJwQ2yC8mLIE6/TO6n/gJ9G4y+9OdH7FSspTUhmasHwCHKoQwtGjP8WwSkxDoEOijkNJRSAooCHO5W+fTNrMOL8VK2u+wkQ9GtwHmS9hDTXb2khrHZrLO6H7tGQa0abPmZz8yb0YylQYBo9/kmu65YRpkwjqz5TFRY1Uc5YsQMWVj2zdzuV/PIy0XEP5sJ8JU10h3kpRlVByVjDFg2NsEF31OKgweQLtgx/y5ZMktqu
 nGWJmSk+
 T8PKvAaTlCus+ymbHNcPFbv/h5BW1DdelBIZNAWLEjtSLX3J6bJMyyzEGMTEDfV4DLYTHvRaeHdmDmnh3F7TThQ3W92U4Y7jJzCEZgYd6oxcA9j51gTPxQm/s+WZi/vxjmbtd/pa0oHkazbjiuop1MyeVdz1JHcWl+T4cu0hZRVNGKPsB+IwOj03bYFT0szW9167grkYWSErbZ3Oc4NJuLdCy0Wyvzs3xXSVLOokVTDg0xT7q+u1JPyadFzqRPRsCdpt0STgvOegp+pPRJ0juZg6zC3Kvel5oAoTsZGJr0R3nui0RqBT5vW+qmuIFWBT5jo4Av9n7TQQyyb0IfDwk31otYQRVCRLRhCgYiD3XGIppzhcj/gHVTkl1kX/pq8drejaWJDWgoBoxxSqQEtUq7n3lrfhS3QXQA4Dakx6Rejb/XNQ+WhUhFqGi8SqhkGimdUj7C7aAaL5+taj70F821ER4DKDpc/2jWMg8GWaTFicsNbaQmB81F1lKA26Wj1Ds4JbvvRlO9lZ5LBHuqF+Cfohhea9SXLuQ3Re7SfPFnBQhMye09jMGPuBGQW2DpZtt+ZPrbo67xUnXP5lkwqrnItHl+e0TqPb6Zplp/Yq/f9IOr8YDZshiTpEyuNBU/Kxx0gFaEMc9ithqmHXN17K8HfHFoTC0bZRb6i/K0F7SrMb/X0aYUOfka6Bde4JGNg26J0feNo3T/AZzqnBVl63JfZOkDkllZW4iSBf9VK4Gi8JPGEbaUQa+XsSdyQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This will be used in the Tyr driver [1] to allocate from the GPU's VA
space that is not owned by userspace, but by the kernel, for kernel GPU
mappings.

Danilo tells me that in nouveau, the maple tree is used for keeping
track of "VM regions" on top of GPUVM, and that he will most likely end
up doing the same in the Rust Nova driver as well.

These abstractions intentionally do not expose any way to make use of
external locking. You are required to use the internal spinlock. For
now, we do not support loads that only utilize rcu for protection.

This contains some parts taken from Andrew Ballance's RFC [2] from
April. However, it has also been reworked significantly compared to that
RFC taking the use-cases in Tyr into account.

[1]: https://lore.kernel.org/r/20250627-tyr-v1-1-cb5f4c6ced46@collabora.com
[2]: https://lore.kernel.org/r/20250405060154.1550858-1-andrewjballance@gmail.com

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
Changes in v2:
- Add MaState abstraction. For now it only has a mas_find method. And
  use it in the destructor.
- Duplicate MA_STATE macro in Rust instead of using a C helper.
- Change maple_tree.h so that cast in ma_lock() is no longer needed.
- Add #[must_use] and #[inline] annotations.
- Rename MapleLock to MapleGuard.
- Change errors to use AllocError.
- Add MAINTAINERS file.
- Link to v1: https://lore.kernel.org/r/20250726-maple-tree-v1-0-27a3da7cb8e5@google.com

---
Alice Ryhl (5):
      maple_tree: remove lockdep_map_p typedef
      rust: maple_tree: add MapleTree
      rust: maple_tree: add MapleTree::lock() and load()
      rust: maple_tree: add MapleTreeAlloc
      rust: maple_tree: add MAINTAINERS entry

 MAINTAINERS                |  12 +
 include/linux/maple_tree.h |  11 +-
 rust/helpers/helpers.c     |   1 +
 rust/helpers/maple_tree.c  |   8 +
 rust/kernel/lib.rs         |   1 +
 rust/kernel/maple_tree.rs  | 640 +++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 669 insertions(+), 4 deletions(-)
---
base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
change-id: 20250726-maple-tree-1af0803ac524

Best regards,
-- 
Alice Ryhl <aliceryhl@google.com>


