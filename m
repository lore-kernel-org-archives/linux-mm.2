Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10D64606A330
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 18:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KC+yUsDl
Received: by kanga.kvack.org (Postfix)
	id 01EDA6B05B3; Thu, 12 Nov 2026 13:58:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F11C76B05BB; Thu, 12 Nov 2026 13:58:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E00626B05BC; Thu, 12 Nov 2026 13:58:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BEB5C6B05B3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:58:17 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 553E71A0A72
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:58:17 +0000 (UTC)
X-FDA: 85427377434.30.6BA49FD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id C8F5480003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:58:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KC+yUsDl;
	spf=pass (imf02.hostedemail.com: domain of da.gomez@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=da.gomez@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794509895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=elwXiRCfgreMBRymobwx3IbDMUTz5KC/o5TzRKRmPAk=;
	b=ZwmIAMicjPrUE88gzT3yoHFNC6VovVjTpUnt1ePS2M7lU6VovjGUkBAzXMq99Y/CX3SX9u
	8E7LGH7cMwJpXTx4xXqOgDPG0ITugfBsy/yv785RW6Eu/xPnGESVuXf4L4S5YCmvQak06+
	bwi+p80RxqCptAH3P9jL65JjGVu/2cU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794509895;
	b=W65mJGD+4NBJqKF6Sx/98N6sL8OFEZDG61rYxgFq7vQv5wzf2n2KdPqEv7daMwnkBAl+/x
	OFI3gNoy+2IqHkZ6RctNXsTSsbYVKVAq4Qa+XN+Dh5MlF5rZXZXO9FypHBSf6ohUZ3rMcW
	Xe/phyoLLA4kMJKI5WVobqODuSuB0g4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KC+yUsDl;
	spf=pass (imf02.hostedemail.com: domain of da.gomez@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=da.gomez@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4F47C60E04;
	Thu, 12 Nov 2026 18:58:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CEB41F000C4;
	Thu, 12 Nov 2026 18:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794509895;
	bh=elwXiRCfgreMBRymobwx3IbDMUTz5KC/o5TzRKRmPAk=;
	h=From:To:Cc:Subject:Date;
	b=KC+yUsDlDrOUZnIP1c9RvMynURJqoWO6B6KAUPOiDK5SQnFLN9x2aiGnfR68DTvYH
	 F89dXdqnJyLAPkOBRAlhhQfE3om4e5dFexkJ4zLBfAphUW3lkLAVkDpkKe473wYZyg
	 VFHHum6zxzRbdyZNgRNqq8KsOkEU+A3XQ+BL6v4pVv5eFaJhC7H0ebExtWrf3bSuAy
	 wCpPqcjsJjU9/nh4YTLsIH6LMm9OOmbw/7NkGPdKK9lqD0KoJ9NxP2m7hr8upDhaTS
	 36KNyQpre3MPyxT9eRAAt8d9UrY1MRwxGfqVoKypQKi+UQlR5hggg9McMpUIo16E/I
	 cGXJbKCzDTmmQ==
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
Subject: [GIT PULL] Rust XArray for v7.5
Date: Thu, 12 Nov 2026 19:57:45 +0100
Message-ID: <20261112185748.8877-1-da.gomez@kernel.org>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: oar83d558t79g7pmg1qc4ht5bstztoux
X-Spam-Status: No, score=-28.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C8F5480003
X-Rspam-User: 
X-HE-Tag: 1794509895-624818
X-HE-Meta: U2FsdGVkX18SDbAo6vAQI2HFvpqSbsxuqP/nz775wZUaze43E/PHirNEJFA0pLLNza4x62zS3KKDlXNyEOs6NRhrHdWinjg4NANoxOxX5tdW+OQQd/fG2WYE4oZ1RyB17a00vir93TErncBoXVTomrbsYsrbKJ5KDY58VQ7AvP6HBngHa4ZrXY8gLpJ7bTotd4VInSi5A0kZ2kcVqZ3wuiFbftg162BFWmuly5HDFvEHs9mQufgb2On9f9LZAEXyiedz3CLb0RbSwXzdWJSuvP5lYGe6P6NR5APgtNy0kufyHf4dmrUJy+912aMUzWY1t1nk1mOQ7OVBzYsrwBckYOzB6PJEfbrjtjl6W9+q91IfjpKHDJeNZWHscSJaSeSW8fCpivMPAh+aEmg/1riUL/l9v5mG7BXQ/kkYOtJLDu+9hxQdzVPCKBMPzz4EsnQOhpTDeWtHH5cNyXfsR0fNGSm0jT+DneFiVwWA8KQzipswvG+KOD2mOfakw/LcbIWKhLvRkfV3q64hl9khalhOxSaCY90NXrfba9uVuvcez7rmBOCUMXDeQYvo9oW3X1vF1zHjcCCYA0zoT61u1vb35nnn4OnSaORFdGQkgB4EjuLiUldArlEmSA0wydzZZAG7Aom6BMoJ86iA2gRmugtKjASe/yZngSMXYiOxCiaj6difvyOiAQUfOh9sQ9OjDyH4aSASD+Kxu5Kvp9ByLUxUaochmzyqrS82N/dEYdSlwYrCC0w5SP0pc0rZ7nMEsHYNg9tKxke46skrfNzeev3bAqqAQnk40z+eTCT9+kisa6XdF6a5/kMRLuqHBHRZ5eKG1uscXCbBGGMG4taQvcEnZD7iIJ4wCBD6LMhnOZrymWz80dtogk8qOVyc9yC9Oh3TZf8a/RqtRNgIYVFbqyY827uVsz8ak91qC1LxdOEgr/lRPrh7V1b4XccHEpXWjhQd1HDB08R5hnFyuMEFwNX
 kTiEV6/G
 GVLP3S6jk/z4cF65FnpKm5JwjsDhTJ0uWD5FZdQgeu1szeis2/KXtUXLI5QSImdzhWLauT4hUuPjPRoTXPtNyvxDDHtQAwzn7TQBplgbK10nSYauSYuZTzhChNRJf3rK2KglNwHrJT4o+B3HzdaGFzmeQkbmADOjIyRS+uxd5cmUc9cWa/uJ2lF6bZHIsWZ26eLbtJFsxVNvzewJwy/oN1A84x1EYMXpT8vaLxfXZH/vxYcGbpJx+mrp+IDj43MbG/27tYGpMqmLyuTE0PRo+8rDFRbT+mjQURbdCnGMJd08KJLt9tqOfyCe5HSoEFQ8ciBT4tokutIA3EQmrs9soeMkJqkrsUTfNWcG2bftajHstMG/HxX+mlaMT7qaLoFMXf4U2zWhrnJ2EFIA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Matthew,

As mentioned in [1], this replaces the earlier v7.4 PULL, which missed
the merge window. This PR is rebased onto v7.4-rc2 (no changes), for the
next merge window (v7.5). It has been in linux-next since next-20261102.

Could you let me know by v7.4-rc5 whether you can pick it up?

[1] https://lore.kernel.org/all/20261030101626.0-da.gomez@kernel.org/

Thanks

The following changes since commit 7475ea8b58616b33c04afb976cf0fbaad9dd63fb:

  Linux 7.4-rc2 (2026-11-08 16:22:20 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/da.gomez/linux.git tags/rxarray-v7.5

for you to fetch changes up to 29f1617aa1dbd0803736403cd63c4965873fa621:

  rust: rxarray: add rust xarray support (2026-11-12 10:14:36 +0100)

----------------------------------------------------------------
Rust XArray for v7.5

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
been tested with the included KUnit tests and doctests on v7.4-rc2, and
has been in linux-next since next-20261102.

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

Signed-off-by: Daniel Gomez <da.gomez@samsung.com>

----------------------------------------------------------------
Daniel Gomez (1):
      rust: rxarray: add rust xarray support

 MAINTAINERS            |   12 +
 lib/Kconfig            |   11 +
 rust/kernel/lib.rs     |    2 +
 rust/kernel/rxarray.rs | 1407 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 1432 insertions(+)
 create mode 100644 rust/kernel/rxarray.rs

