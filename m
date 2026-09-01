Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4683DC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 16:09:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12A276B0293; Tue,  1 Sep 2026 12:09:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C9E06B0297; Tue,  1 Sep 2026 12:09:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFB046B0293; Tue,  1 Sep 2026 12:09:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B034E6B0293
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:09:21 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AF4BD120441
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:09:19 +0000 (UTC)
X-FDA: 85165678038.29.C88EF24
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9FDBA10000D
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:09:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gyPkn1JE;
	spf=pass (imf05.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788278957;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=eBjX7J1tX22YxMaJ1V/x/J087jEpN/larc82e9WxjtE=;
	b=6M2YB+QLWGG5IpjDJB670wCorXwM3EBhqiFRFKQEU6lBAlTY8w0hboc6SV5IRYVXq1QIlb
	AQ9c6ptWOm9h4AzAtJxiUppLhjYsUPSLC4IRpZ4S03fA20UpzMumnVkVUa+4xGWp0vGwlO
	o3jUA7kKAK/6+byvWbbTbW2ZNjhxhAk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788278957;
	b=VSogQ6wT9EJhIN7hUeP5gl+ygf8l9FFK4sMA2Bnq80+VQcwwBtwRYcFZGPY+Oo3iEUPEUk
	I4R+WkF14G3DDVcmUfMrAhBh8A9FQFPki5v3JwlGe9NwoeW6QlDjtqc7Z5RRezn1PSd9VU
	FQLMWmpRN+CHdDVZh5FMK1vzpquiWr4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gyPkn1JE;
	spf=pass (imf05.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 757E6408C3;
	Tue,  1 Sep 2026 16:09:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 48A8BC2BCF4;
	Tue,  1 Sep 2026 16:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788278956;
	bh=lhvqr0YNmYNoIT3ggMS891E1w+CGEgfi2rFuaQKH4aU=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=gyPkn1JEXJo3QyH8+uUaNRC6R6dXTKXcIUspzLl0VHEW7YygleQ6UX0DGAB/bx61B
	 JLyzMV8V9w8dKES37a4+yxaasZLkzYFzbUvSou8aayMhGBqmKTKGRBnjyhjP+UAVdu
	 2dxy/2FYEBi7DPaP7oEVVkjRp3AFZxLI7A1Bw+Nh2D9jnNOuWZ0OTDfoJrxJe7hKme
	 ciL56OWimbUF3s+71pz/JIECOn5DXAeudMofPf6FMhldVPNZ02ySufe6G5OB2KWP7u
	 bsXEqlgYwtBCbkG9ud9q12ZqM/ytT5AfLJfQ8Tgfo+LSt6n3cze3uL9xztnY4xJ6JV
	 oerAI9G3/mvDg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2281CC61DD3;
	Tue,  1 Sep 2026 16:09:16 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Subject: [PATCH 0/9] drm/tyr: add VM and BO ioctl support
Date: Wed, 02 Sep 2026 00:08:59 +0800
Message-Id: <20260902-tyr-ioctls-v1-0-e0fdbf8bd108@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJv4lmoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDSwND3ZLKIt3M/OSSnGLdNEOD1DSDlOSktEQzJaCGgqLUtMwKsGHRsbW
 1AO+8sJJcAAAA
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788278954; l=1522;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=lhvqr0YNmYNoIT3ggMS891E1w+CGEgfi2rFuaQKH4aU=;
 b=GbkfXIDW39GboxU034l9GzN9Tiqr6XulAfvPJh7sfrXyDINKCLMkm70knCQ9US4+CJvXzLMtP
 0dBNuorJ9UVDYn9ZADuaLj9cY/ophtfF2gmKfXQBW1qNlmPyVMCSMp/
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Stat-Signature: 75aydsytptzk57qqgxbddwgap5wpqozi
X-Rspamd-Queue-Id: 9FDBA10000D
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788278957-34916
X-HE-Meta: U2FsdGVkX1+3HO49Tp/amx+w2MjtQio+WFjTrrgIw0LCPmtE8Nq2GnhB+hhbSh9w7T3/4v+j/BSp5wD5bZtaSY7e451WmCJhjlD32bvrjjqVkZkS0sohVWVGNVpt0/yn3q6WZqfolFFmcZVl68ichPAta4BdnwCTeetjP8woxCvz6uteMEqABNl8RRRFabMgT9KN/dsQtmk1pSGuH2rkDzIT1enmDW+P0JGejSi9+OczfK2LD5kbCk60/6Qdwnx8tfZmVL7kbGXweFSAL7lSdKkAZygeIhiRw1yt1jfEEcCnpuppBSdaeYJ2SRZ2hLaX7sNEI3eOAQ0XPMV5rMpNfYSGS7r5lkKXTSTqDZHu2AAMhQ66TTUq1Z1L153bXWFFg0gOcZ6SiXh5IP1grSZsZJ1bcSHp/XPpq6Yok/c37K2PLtjRcyKirz6wbRlj18NIOK2NNYAz15sGgx7/xkxVew9f1A2PsuOJScSaEo70qvH6u9OU9BZmJYeC1K4pWSVwXme/anXc3h4Gtd01WGJCLe7Xqj6i2M5wH1+wSJYxeOer3z5HPYZbrkzx2wZ+W39SLP40Jb53Cpp+d7eRuujgRZsxjalDbUbVksCU3pBqCdHDSdTXloDhR/rWthkatDSNrIddDU0dRczqB6+2ROOTv+lwoCpMBZEyoNvgeT5WspTeI6cFcSo+gNsbLGjWotKpD/O8fyNTNcjjnaI1/ofUFna541oUxq9iAs5xpBEC4MfO+mxSQ24A2XkswEDp/EW/w1zbekv5G0J5T7QIrigrJjnpOF7kxTvR07HSNJu5YcIEKtCGyRS5Q1Rsz8rfC0ExEJz7us5Ukeiq1x4ymxSaNJkpJg6QRSIMoTE3fBQqlo6QU+wsN+Y26aPjz4iSURNEY8Bm3jahEYxhkB1tO1B+VazxMrs3d7YoShgd9kqu9KxET87+5pRkgcmPu4Sah7+HTbJg1Bp5Hr3i+iU2TVK
 5rCHRzOt
 PVQOHNnvdWgDmQrsvS1oM1rsHZ731RJY5VXFOgw/4bbiqy+xpqznXJWqvbVJ/RYaYbX9y/I4mjRn6vLb1iGRLsWoq4GqL3oczS5furlB15x/2c/RwG1igj1N7BJDrLumxJHQy7FQgdR9KCQfUJIssAvuRiBta4JuIEd/A8timzm83O+pGmJOHOIbms2m1BDbQNH3YdPp62DNgQDmluHpVwppFBIVsPEMJwb0ewzK+XCHmJSnCnE5udXFIvqbTNWOrONXsuaPfqQY5NhR1DZnGtGpmU0LKQ8oFlvU6ChZ+B+/M1vu6Q+tWd1OJnqWg+ifYV2CVzTXjNAJntEKboIutUwOHbtIQFAUT5zCg9wxBZkRYhhjgQFgSGQ3rPOc2bCWda4GA
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

Signed-off-by: Ke Sun <sunke@kylinos.cn>
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
 drivers/gpu/drm/tyr/file.rs     | 394 ++++++++++++++++++++++++++++++++++++++--
 drivers/gpu/drm/tyr/fw.rs       |   8 +-
 drivers/gpu/drm/tyr/gem.rs      |  41 ++++-
 drivers/gpu/drm/tyr/pool.rs     | 102 +++++++++++
 drivers/gpu/drm/tyr/tyr.rs      |   1 +
 drivers/gpu/drm/tyr/vm.rs       | 158 +++++++++++++++-
 rust/bindings/bindings_helper.h |   1 +
 rust/kernel/mm.rs               |   7 +
 rust/kernel/sizes.rs            |  12 ++
 rust/kernel/sync/arc.rs         |  12 +-
 11 files changed, 714 insertions(+), 36 deletions(-)
---
base-commit: 0b0aa9dcf17b6cffa9e325ff641e843b20d40c31
change-id: 20260901-tyr-ioctls-f10ef0dcbfa6

Best regards,
-- 
Ke Sun <sunke@kylinos.cn>



