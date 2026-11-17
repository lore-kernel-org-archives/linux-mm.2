Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 951BE606A332
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 23:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=konsulko.se header.i=@konsulko.se header.a=rsa-sha256 header.s=rsa2 header.b=yzcQO23C;
	dkim=pass header.d=konsulko.se header.i=@konsulko.se header.a=ed25519-sha256 header.s=ed2 header.b=SUgGnHKf
Received: by kanga.kvack.org (Postfix)
	id 8239C6B05B1; Tue, 17 Nov 2026 18:32:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FAF86B05B3; Tue, 17 Nov 2026 18:32:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 710FA6B05B4; Tue, 17 Nov 2026 18:32:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4DBB36B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:32:21 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 949F3A0635
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:32:20 +0000 (UTC)
X-FDA: 85446212040.08.3A34B5C
Received: from mailrelay-egress5.pub.mailoutpod3-cph3.one.com (mailrelay-egress5.pub.mailoutpod3-cph3.one.com [46.30.211.244])
	by imf31.hostedemail.com (Postfix) with ESMTP id 70ED420006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:32:18 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=yzcQO23C;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=SUgGnHKf
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794958339;
	b=mqwYSl3e8FZRzZFrsdJD/wZN7Z8IhbKHjk9H5mKxkop1Muk3k7+f3rgdBkky5JGJaJpXPN
	+VXfI1hE1eTVPv0JAA5ZU7P7UkTSwNM01y6oDtzA5pPZNaIoSE8fpnqCsUnnOGNR20BzCI
	6dp7LdpzK+nm4Nr20F2Jmgh31gzdlLE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=yzcQO23C;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=SUgGnHKf;
	spf=none (imf31.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.211.244) smtp.mailfrom=vitaly.wool@konsulko.se;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794958339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CVK3gfdAVTQvEZy1bbvtoLOfN8qA9o6BEbEAHYrhFsI=;
	b=F3LnTPaMzXxCiyb3K4oq2yTUsiYdhS4zAdblO08h2DtoadKsUFLuXv7WUn8uv7VdLh+Nrs
	yEi/2uXbcFzVeC/0Abifydz+W2Qp35o9QqygtfaA0rwHR3wg5bKUw7ERm4UU0gnGYo7arc
	TpAiBrq7QfhJlRD1fasdNOxwpnjw+Us=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1794958335; x=1795563135;
	d=konsulko.se; s=rsa2;
	h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
	 from;
	bh=CVK3gfdAVTQvEZy1bbvtoLOfN8qA9o6BEbEAHYrhFsI=;
	b=yzcQO23ChU7yvmqYbuQ6D0jbqMP1WbG9IbcPWDjLRV/NYlrlZo6M1Z8vSaEXIQT5nNA7BIe73BFsL
	 Fr6LwtG1iOz90omYQHpJwDRzOVi3vfuykDyIifyZlvnfQnLjhO9zrIIJYhk1Ab3CfI/6qBbGG/58ss
	 iotGJscWEBjvNvn1F/Ez90Huj/uWdpPGyyHtrlgsVXY0IyvvxxzxtlVyZbS7Ne6PrX5vbUVjRp2bQI
	 vu1kiDJD8g41SnjPP2mC7tvKARH87wQ36opA1XIg22HPMs+FHQWHjH5BMAxJbqUPcfUnRHK8sWGOoR
	 QiTM9jzTIYn0DjEvKM0yUXLbHQW7r5g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1794958335; x=1795563135;
	d=konsulko.se; s=ed2;
	h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
	 from;
	bh=CVK3gfdAVTQvEZy1bbvtoLOfN8qA9o6BEbEAHYrhFsI=;
	b=SUgGnHKfQwurNL4LuAU22YrgMLE6sgHZ1v7IabgIk2MwXJrMjFGAkE9VJ0CKfYKL8ndhjB0eWguWy
	 tpIFBsRCA==
X-HalOne-ID: 1e020ffd-e2df-11f1-928b-49de817b90c1
Received: from slottsdator.home (unknown [2a02:1406:27d:15:2438:a644:c11e:a5ef])
	by mailrelay6.pub.mailoutpod2-cph3.one.com (Halon) with ESMTPSA
	id 1e020ffd-e2df-11f1-928b-49de817b90c1;
	Tue, 17 Nov 2026 23:32:14 +0000 (UTC)
From: Vitaly Wool <vitaly.wool@konsulko.se>
To: Andreas Hindborg <a.hindborg@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>
Cc: Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	linux-block@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vitaly Wool <vitaly.wool@konsulko.se>
Subject: [PATCH 0/3] rust: block: add rbrd, a RAM backed block driver
Date: Wed, 18 Nov 2026 00:32:08 +0100
Message-Id: <20261117233211.3137168-1-vitaly.wool@konsulko.se>
X-Mailer: git-send-email 2.39.5
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 76fqdtfbpppit4wjqfbmbieehms4hmto
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 70ED420006
X-HE-Tag: 1794958338-728376
X-HE-Meta: U2FsdGVkX18PRboMyoKcfpFyah2HzYBYpTb0wguqsJ/kP8zaUpzbRGe69ywFM6kFv2SKsFKbotwMNuHk9wqWOtA1AS+Zx2PggxitROSpL6aFAeiOF4ZvlaGsjv03zpKs660QNmar1Ioza773doFL2rfDoI9vMj/bJBjvpzs2h8TZm9BiX6Dc01mdcShVbEIYp+8Iv/xR4xA2wi1ZnDHgM6f2JjvmEIZiC6rWt4Jj05LdZvVeDczEwNKPiN4iKZ+ax2I5FnN3CFWHLAMzW9/xwsl8QnwxKuOz2suH3bIrd9K2eDM5hfkLDTJkvGenm8+ytsM99/1pGGqJ57fqdLdUCo3Qn/KbP0GHtaw902DCKOeHpbDFqOgPH9XxIZunJskC3lZyuAB6dMoLH2cdG/JsdF+FmXjUg8EoaNmzQAelz31M35jXzFbaAvxWD/nFC6SWXH2SnyG/1WS6xUaFkJKwaA01O+GkizUyIB/aU8pHQTAXHeZ4V0L4cdpv7TkVFvhE3NUM0xV16Ev7I8B4QSrsFOk5Jaeayw9tmew8IAkboV485Ga3CvjI273iROI88rs55AWLB4Ud2sKY1GliOt8F4So0KaNxDS9Tyd5Hsu5+KXPEs+2SAcZpfEEthZ+hn37VVWPvoz3QR5lOwv8GZ7g4t3LyN1azgeBfO6gqx5ntd64bv2Gs7cm34mxspYakIJuA+9ntSwcz2IA9FeTJyFT1Wh1s+l892co5IxSFVLC7VVxlblSRf1B1WQDQ6O1NQPlk22qRIfbBPrtV/g2/0X36pe4HCTdsDAKyrNPm78A3nYl7iWi3+90BcISDppz1CpfKVCz44ej6GtAkX5/M3lCXKjCveegD8pZdysCFYQYoRGusMcDU9ht8yq52KU4GV/rmAv0okLAKBJeU5DRAIplxdg+tELynJwjBfeJCmf3R4HGPSWnJzlQa+0R8ux1nQZfrcP86cUmzoH0G8rK2ypZ
 7RF78yDw
 KRVyE15dNtzq1nz154jtuyZ6KDySia9zjz6zdPp9JQfnijliFlYedPIk7gf2KozYl9W9FmZvF3vzFe4Cy3kZNXNmWyL3gXuOmyOEVeAG4SQmK826UEdZ88JHjCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series adds rbrd, a RAM backed block driver written in Rust that
works like brd, together with the Rust abstractions it needs:

1. bio segment iteration and request accessors for blk-mq drivers;
2. reference counting, raw pointer conversions and a bit spinlock in
   `page->private` for `Page`;
3. the driver itself, configured through configfs like rnull. Its pages
   are kept in a flat array of atomic page pointers, so finding, adding
   or removing a page takes no lock.

Unlike brd, rbrd never lets a read and a write copy the same page at
the same time: each copy holds the page's bit spinlock. brd allows
this race, so a read that overlaps a write can return a torn mix of
old and new data. In Rust the race would also be undefined behaviour.

This guarantee has a cost. rbrd is slower than brd, mostly for writes
(4k random O_DIRECT I/O, 8 vCPU guest, mean of 9 runs, kIOPS):

  test                  brd    rbrd   change
  read,  8 threads     2048    2012     -2%
  read,  1 thread       512     463    -10%
  write, 1 thread       583     470    -19%
  write, 4 threads     1693    1472    -13%
  write, 8 threads     2004    1563    -22%

We think this is a small price for page integrity: a RAM disk is still
far faster than any real device, and a block device should never
return data that was never written. The gap has not been profiled
yet, so not all of it is necessarily due to the lock. With a single
lock for the whole device instead of one per page, 8-thread reads were
20-28% slower than brd.

The series is based on rust-next (v7.4-rc3). Patches 2 and 3 were
written with the Claude Code AI coding assistant, which also did the
testing.

Igor B (2):
  rust: block: add bio segment iteration and request accessors
  rust: page: add reference counting, raw pointers and a private bit
    lock

Vitaly Wool (1):
  rust: block: add rbrd, a RAM backed block driver

 MAINTAINERS                      |   1 +
 drivers/block/Kconfig            |   1 +
 drivers/block/Makefile           |   1 +
 drivers/block/rbrd/Kconfig       |  17 ++
 drivers/block/rbrd/Makefile      |   2 +
 drivers/block/rbrd/configfs.rs   | 188 ++++++++++++++
 drivers/block/rbrd/rbrd.rs       | 420 +++++++++++++++++++++++++++++++
 rust/bindings/bindings_helper.h  |   1 +
 rust/helpers/bit_spinlock.c      |  13 +
 rust/helpers/blk.c               |  14 ++
 rust/helpers/helpers.c           |   1 +
 rust/helpers/page.c              |  10 +
 rust/kernel/block.rs             |   1 +
 rust/kernel/block/bio.rs         | 253 +++++++++++++++++++
 rust/kernel/block/mq.rs          |   5 +-
 rust/kernel/block/mq/gen_disk.rs |  25 ++
 rust/kernel/block/mq/request.rs  |  81 +++++-
 rust/kernel/page.rs              | 160 ++++++++++++
 18 files changed, 1192 insertions(+), 2 deletions(-)
 create mode 100644 drivers/block/rbrd/Kconfig
 create mode 100644 drivers/block/rbrd/Makefile
 create mode 100644 drivers/block/rbrd/configfs.rs
 create mode 100644 drivers/block/rbrd/rbrd.rs
 create mode 100644 rust/helpers/bit_spinlock.c
 create mode 100644 rust/kernel/block/bio.rs

-- 
2.39.5


