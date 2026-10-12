Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 147EECA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 11:55:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F40436B0088; Mon, 12 Oct 2026 07:55:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF16F6B008A; Mon, 12 Oct 2026 07:55:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E07246B008C; Mon, 12 Oct 2026 07:55:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BDAEB6B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 07:55:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D73C140C3C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:55:22 +0000 (UTC)
X-FDA: 85313818884.17.FDE9370
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id B9032140002
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:55:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n43wZqvk;
	spf=pass (imf26.hostedemail.com: domain of da.gomez@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=da.gomez@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791806120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=EFBfQFk5/U3oNT5PftLrBoxKpWYLq06VaTtaCGifA+Q=;
	b=PGTT4N+aKDaW2BOvNzrW9Zff/1tlgAkMnfbXeCmzd8smPGvD0Ct30ZxaLj8KjNX8AO49up
	91zNfheT5uuexZ3x0PiEOAdAuN2cIKt87m471SHbN6Z/BNb/fbpekqigiBjwEJmXr+GVnJ
	F9jP7iWoeowoQgERSxNLG3J8dnnnOR8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791806120;
	b=cuEIyTFBLwU2Q3iNZiVcws6TaeMWvp514YBBXnsxPVxQA95Teb88CQIDNG8eohFdyEGPtn
	JdZOk0QWEI17O+EJox7qWmUHwfsKdqSmq6UyP5WJB5hNoWwU1Lkb3Y1VFHG/cY+KKieMVO
	xzWyz2yccVv81DsdkijdX2lWaGcWA1o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n43wZqvk;
	spf=pass (imf26.hostedemail.com: domain of da.gomez@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=da.gomez@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F253042AB2;
	Mon, 12 Oct 2026 11:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBB01F0089B;
	Mon, 12 Oct 2026 11:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791806119;
	bh=EFBfQFk5/U3oNT5PftLrBoxKpWYLq06VaTtaCGifA+Q=;
	h=From:To:Cc:Subject:Date;
	b=n43wZqvkpRiBHTT8srVSaSF0QkmteVpPPVz/AjMHgwTfz2Hhd0T8eeE5NQjiOdjcU
	 p8tgxSiKBAyVs9/yTPLNCJLwyvV9diis+mZSfSgX0foXGNit0XJ5Mvw7k6f7nD/Akd
	 62rLWO5ZY8lH0rIcmp+ZYjidpWABrGpE3ZSEFu0GE2ZnQmwmy1K7CbwiuoBwssBKok
	 jGXcHbMh3mf2ZR9xabtXfJRDYToLQa0Atye5wmuRnNaXO+Shlb8VEV6ZysUnORPkkX
	 ZFQp6ClSZrEsUcFjePPmIMOafuD419/ZMuBV5siF5ynAtyw3yq5R3SAjYc/gIl54DE
	 lhPI+9KfMuuRg==
From: Daniel Gomez <da.gomez@kernel.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Daniel Gomez <da.gomez@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Julia Lawall <Julia.Lawall@inria.fr>,
	Corinn Tiffany <corinn.tiffany@inria.fr>,
	"Liam R. Howlett" <liam@infradead.org>,
	Philipp Stanner <pstanner@redhat.com>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Samsung GOST <gost.dev@samsung.com>
Subject: [GIT PULL] Rust XArray for v7.4
Date: Mon, 12 Oct 2026 13:50:26 +0200
Message-ID: <20261012115028.73246-1-da.gomez@kernel.org>
X-Mailer: git-send-email 2.56.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B9032140002
X-Rspam-User: 
X-Stat-Signature: s13anbabt1mkxqu8i3icppwhmyj5uttd
X-HE-Tag: 1791806120-628172
X-HE-Meta: U2FsdGVkX1+gJlOAYCVExMauUl9xUVmlZK6sYGldkR4fiyLfPCu+MvumNcC30f1V6qGlRiJjoCRURN3Xcq0s5ZNc/YtRzs5Fx4MR4EjSLNv312BcaqOPHzSqt7bH5ANXEdNSeQqUyq3VjSMIXu5o8gh/xbpm8nCO8jgZCGxs2V9fJQkwjKpeWRNaheAkPLHbCYPU9OH4AyWS/Y9GzVocjg6sLRAtFhS+Vh3+ExHUa3vToDVGUe1v7WyqmoNpL1wWlpSrE5GrjEiWZgshfntNDLyRwdG87uDsXOQUe8Yjes5hSN/Xa3TgNOBrCSQYEfWcicdAsOivJJGwvwlL4YOuNKcTumqDTUglbgdK4r0s5sZ7xTNwn1fcmgaIwZbXI79AMi2igPk9GA9g2KMc2/1koGPORRsho/4weRtSfe77QPjpzOXcr4vGQSoEMa/QNp/mmIOAIlalQBWz2gpLovNZB0QcCR0ZaVp2ayOPpBb4Sn9O5xJ9FlthgA5qnEujtVHP9407Qdy3TXfcDEKeprZUwnxwwTsq5dTz64VEaro801pYMkgqG4m/VniLgiPrHNuazBL+dY8jit0om0I1isDO6F2IMCe80jLKM1T9ltMO26HIZyO9zYzaPprnIriZ5hhcU+GZkcX0UMb+J52HRbv1p4NMFkl/V+nlbPGtMc2txlZmgwlGtGDADZ7knvwcRRrvAG1oHb2G9wR6DuIiw5AlRwamsYxDGDt7SwejmRaVbHxJ1fivbOuKwSeR8Li015ztdIOAOQREtSfIdxsqDb1J1/rI9lHvOXtX9itQa6kMKT+B4ycmu0KZPeVQA6YxTCyrnHqcaM4yi782tqbOhRa4B4xaJl/Jm2e+afseNbdtLpQlQFDqalrSYo3ZZfBjszZVKWQzwBCuQbQj+nWNnDw2/DGKVZ7v/fSiiM5yDudb9/P8KW38peDVcKR7RbYl8pcyGkcYPajfMo7ngsA8keL
 tL0Jbigj
 wdOM14d0pdJx+EEDqBQ3ZTjtyl1mRk+AhdF6gYaLz6tBZNJwXJQHRrrEt+Hg7TDjM66dN+Q9kmvsPN6ERm+SC3sY/hdjca1bj9iSOh4NBRwE+C6MtF5nsfdH8Kzz5mA7P6gz0gQ8G47wTyx0201aCUffhmbVJCgkNmgjAPo4jjZR4wvJUcIeVpd1gRMyLGxEZjiNflaXKZBHNyVyWcxSWHp2J5SZ045VXT/By0qoXil8oLJH3jgYMrEvNW5G8D+ktMxEejkb3mq4PPMMaNkEb8oNI5UmhntHxkY5BBkjtLNNOjQXA+JUVPIihQ6ZsJoXSL8BL+upm1oTifNp40eJ0DACNca880jRHQ4TWVX+RCo9R6k6nayIoCHD6jSBD1ANI6pfJSRTeeMP3J+Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Matthew,

I'm sending the Rust XArray for the current v7.4 cycle, although it is
probably too late for it. Just let me know if you need me to resend it
later, rebased or under a different tag.

Thanks,
Daniel

The following changes since commit cee9395acd8043be0644b25c34bfa86623f2b935:

  Linux 7.3-rc1 (2026-08-30 13:34:40 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/da.gomez/linux.git tags/rxarray-v7.4

for you to fetch changes up to 4ce73d98a0a6e5bba46ed1fc9a61511bdccea776:

  rust: rxarray: add rust xarray support (2026-10-12 08:36:28 +0200)

----------------------------------------------------------------
Rust XArray for v7.4

Add a Rust implementation of the XArray (rust/kernel/rxarray.rs),
introduced as an experimental Rust reference implementation [1] of
lib/xarray.c, as discussed at LPC26 [2]. This lets Rust users, such as
the null block driver and possibly Tyr (under evaluation), experiment
with and evaluate both implementations.

The goal is to evaluate whether Rust helps with the most common class of
XArray bugs, misuse of the API by its callers, such as the long-dormant
page cache corruption that almost blocked the LBS work [3]. The RFC v1
cover letter has the full motivation, benchmark baseline and
roadmap [4].

This initial version supports store, load, load_mut and erase. It has
been tested with the included KUnit tests and doctests.

Outside of rust/kernel/rxarray.rs, this touches:
 - MAINTAINERS: new XARRAY [RUST] entry, maintained by Daniel Gomez and
   Matthew Wilcox, with Andreas Hindborg as reviewer.
 - lib/Kconfig: new XARRAY_RUST option.
 - rust/kernel/lib.rs: register the rxarray module.
The C XArray implementation is unchanged.

Link: https://rust-for-linux.com/rust-reference-drivers/ [1]
Link: https://lore.kernel.org/all/20261009212431.0-da.gomez@kernel.org/ [2]
Link: https://lore.kernel.org/all/A5A976CB-DB57-4513-A700-656580488AB6@flyingcircus.io/ [3]
Link: https://lore.kernel.org/all/20260923-rxarray-next-v1-0-92eedf185649@samsung.com/ [4]
----------------------------------------------------------------
Daniel Gomez (1):
      rust: rxarray: add rust xarray support

 MAINTAINERS            |   12 +
 lib/Kconfig            |   11 +
 rust/kernel/lib.rs     |    2 +
 rust/kernel/rxarray.rs | 1407 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 1432 insertions(+)
 create mode 100644 rust/kernel/rxarray.rs

