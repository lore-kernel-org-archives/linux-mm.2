Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1686CD342F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 20:18:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD2316B027E; Fri,  8 May 2026 16:18:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAA0E6B027F; Fri,  8 May 2026 16:18:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE65A6B0280; Fri,  8 May 2026 16:18:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE7CC6B027E
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:18:40 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5314F1C01D8
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:18:40 +0000 (UTC)
X-FDA: 84745365600.12.A71A42C
Received: from out203-205-221-205.mail.qq.com (out203-205-221-205.mail.qq.com [203.205.221.205])
	by imf23.hostedemail.com (Postfix) with ESMTP id CD52414000A
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:18:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=uuEqunm7;
	spf=pass (imf23.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.205 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778271518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JK2ZtbLb2zyokwBdoLQqwGMNrWV203CYgnVwlRQcI7Q=;
	b=EJKETFzWljTxkSXjSaXzzGPPEPxbnkjKsecG7tqBuRZS6/F5a7mWpEw21gRntpqEdTLb6P
	PUP4biiHr3KQnsQJ14/znh/jKWh/nTWnByOIi5BRJkiWRYlSA3X6pNZ7V+3/6QnQ+evxIS
	818jG1dEOzX8Hr5GExa3FGFFD7vYv60=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=uuEqunm7;
	spf=pass (imf23.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.205 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778271518; a=rsa-sha256;
	cv=none;
	b=45UrSlpjxMawinuK3CMn54tx8xrx7tZAKLEUNxsncVPgF+r8q4akVuGTeTgVzjriQHzzzw
	9M5haGTsSxI9epNnxZXkYlhjuUDTKCRUWUMPzbvJYA4XV2wsGoJBTznZ0+CGxoIG/sisIo
	yNspAOVwR0mHPdL6+zyjkpYcUWLkcvc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1778271514; bh=JK2ZtbLb2zyokwBdoLQqwGMNrWV203CYgnVwlRQcI7Q=;
	h=From:To:Cc:Subject:Date;
	b=uuEqunm7V+u2/vIVc2c47j9898sOzDAYjlzJI36x0IxPJFFXAqHKhfEFCTDgjUGGH
	 klC6hW4XULozplqWxfO7Q/WpMcOJxBsX4WfrifpKIxfIr/zwkSDUFrbv+4Aaxh6IGh
	 qpocuvCTXybW67D4EOTHnP39O0d09V5LIHbUk2qY=
Received: from node68.. ([166.111.236.25])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id 49DA4C1C; Sat, 09 May 2026 04:18:29 +0800
X-QQ-mid: xmsmtpt1778271509tmpw3nucq
Message-ID: <tencent_8B437BE4F586C162950BF71954316C1EDB05@qq.com>
X-QQ-XMAILINFO: NMHonNIP0l2dK1VYHeaehc5RRJ40iTCfdKx4ii/4U2odT3HKiCXR0Bjn0NhoRB
	 rkoYU71WSyH4DbxXdmeEYa0QeaNUrxCxkphJireyB1pL8uscPMbh5Mv75S6sVwHSFbF4iANpUKoB
	 elwX9XfzWLNfQD9OB9B3YozxNWgBcQNj402D2ygBtxFwL2BQkmwvEXr5WywLtj2PgNWEPiHUkg8E
	 PMHPG1ejZAQ8Y2vvZHK0O1AjGUlxMBXXQap5CTnb4n6w69I9Qo2Hy09O2loPbSH8iuVD7JCGl8J+
	 Q+i+FHFwQtZ5/n6e80PiBD5HiGlfbc/5NprkIyAWEIxcFfnqQg6T7VvCTHLRyrCpKDqO4taUO2e9
	 lTC1Yy/8BtdRNUgVmNby+8YicapVMzQfEbQIlEXUy8QXQ02M+NK1qVHO2YIrdql9VgRZpvvYH0Xv
	 N1Y0fLXbJeXeo+VsvpzVhxagmbiWDcNkd8OJNRJkfwomuu907OYuBp4hgPxle3rdq9fQL+Nawi2K
	 d4EH5p40z8QcFG7Uscm4d+37TC6HEMYydBDdTBVnzYgmVquEjn+mA3CHN9qcsTVnaNW7/TxWzBOB
	 vKdzRJdYdHxjRALI1vqh8BZ5M9gNgryrZhCvb1JAd5HMuJQDcfq2GPRefFj9W/jGozZKKmhQ3fnK
	 d1RnOXHIPSjybY6oEDg5WZ+CI2cgPM3vnK22HCzTztz56BOpN8KlOHQzod8BU17yZL3CRYPushfO
	 bUWWiSN6f0qgTK6ed7h6Pf5uQUVjEgiKE5Ydc0D/0Nsi31YB9W35FDnCfDNhzk0uaAsAp5AjjMjT
	 E7dqXI6A99Z1pE+R1oIhkNYpM6yecJFFb2MqCjpOMWf8rxsQYtavBgBxIVS30ehCNdHHWUOaPzKR
	 rFcIsA4SuRE4TfO81scuNT1BQ1AfkV+AFAYpOJdhCGySY3IMJfX2N6PqIe9+hENEH7YQmJbCv+tX
	 emS6zmATNCa11BrUKnxAyrioK/t43o4vIrOul2laF81CEOgR14gkKf8Nx5O5NvASwUPNu2QS+wgq
	 tEDnKUQw==
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
From: fujunjie <fujunjie1@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	David Hildenbrand <david@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Barry Song <baohua@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Baoquan He <bhe@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>
Subject: [RFC PATCH 0/5] mm: support zswap-backed anonymous large folio swapin
Date: Fri,  8 May 2026 20:18:29 +0000
X-OQ-MSGID: <20260508201829.1833793-1-fujunjie1@qq.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CD52414000A
X-Stat-Signature: iq1ex167fnc789xqs5e15q3jikwgn4j3
X-HE-Tag: 1778271517-774664
X-HE-Meta: U2FsdGVkX1/TFuDRZt4t14mRQgzPALg9M8yIOBSqJuHKs9zPJQPHrIngwu+ZbXqruW35i4YU+qUxd28co0r+ZxdTiWEPPtl+FsGsO4f3k0UVq8WVy2GvsUrVgzGi7GY26MOuVJ3e7g3gjdsLng4wTY7OeL/GVhvM8dffkS2kNOZ7bkpedUbCjJWatnBS2Ir9ggqeBvB7kq+NCVHC1mbUG5RcxhHNKwLIGalh5rWy/qk4bL4GTq+pZBnFWZVDv8e3iIFZVkR9MC96yHsGt4L7ZcSDXMeDSNXzsYauBu9tMaNJHm872dHyM7pOlfrNwQIzFPQ+sX5fnq4mDZE//0o7JtnfAR9U1gc54wsryMk045RuYDBN4FfK3b70yOvongNNw8UD18WyWopKCX7i6ZVaTx68I20rr97Woa5EMUmv1o7PiI+O6w2HaIWrN7CJ6UcDc4VKU7pQUbB1LElXg5B94T4ey+I9u7bGezWvBhshmVeskCnhWI+SY5GhetoNm/L9sus0oe+f1YgkhmQicBJEo6x+ywKEp3QEO4ZWOnhm5GLnEHhXscAU6cUlUNjPk2M1vAF4FcvR8mRsvvBSVd6OEPpla1BChiRgBv2L2s/ZTCnG2XQnM5PvBPSFY+uBXv2lVRWys86UeFHdKxlfylZr8zsJeH4yxGvlOrzELj6UFmYWM2fTBFaF7l7Iq/sB4owJ9M7Kpnot3iGYrcBYOBnVexkN2tJTXF7krA4Ik3i8oPcjHwM9NpKBiYi2LksSasnE3SKTMQawRZPB6H04DLInJRAkAPKY/Tbb9YL16NPv0pYyZQs7Gujyr3/jS1FvKssxbpbL63pfLjNreQtdQ6a2fqUSjrzHNJ8yq+1niqtDWno5rwpbloAAnzy9hh61iTABTjzpcea1t4PnpDQRyn92c0qu3SKTqoAboiLL63o1qu247r2W9F+KOoRsor1CxKRrII/50GofqrVUcpnDC5B
 BSXz7byr
 Yb1lGSKQ/E4slYjtu2kDDW7bh+1aCVUVxwftvzE7j7X9hGAhC+biOdKXvqph1Fd8b6h0njxRlGiOuhIMI2w8eCZjyWaoCooi52gBana6tlkE5o3I/c8tsib22KUjYKB/nwsHdCda6bol3F/etBzlFAjfTNJTrFWfHyrkczeqow82JVPu6RZullh9MWi366lkslEfmP3CsR0779dZAeAYRt6D8QrooD0MpR5V+AwXysWjEyNdGvQXAkKFKuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

This RFC explores anonymous large folio swapin when a contiguous swap
range is backed consistently by zswap.

Large folio swapout to zswap is already supported by storing each base
page in the folio as a separate zswap entry. The anonymous synchronous
swapin path has remained order-0 once zswap has ever been enabled:
zswap_load() rejected large folios, and alloc_swap_folio() avoided large
folio allocation to protect against mixed backend ranges.

This RFC keeps the scope intentionally conservative. It does not try to
read one large folio from mixed zswap and disk backends, and it does not
change shmem swapin. Shmem still has its existing zswap fallback and is
left for later discussion. For anonymous swapin, the backend rule is made
explicit:

- a range fully absent from zswap can keep using the disk backend
- a range fully present in zswap can be decompressed into a large folio
- a mixed zswap/non-zswap range falls back to order-0 swapin

The series adds a zswap range query helper, teaches zswap_load() to
decompress all-zswap large folios one base page at a time, accounts mTHP
swpin for zswap-loaded large folios, retries synchronous large-folio
insertion races with order-0 swapin, and removes the anonymous
zswap-never-enabled restriction once mixed ranges are filtered.

I tested the series with a full bzImage build using CONFIG_ZSWAP=y,
CONFIG_ZRAM=y, CONFIG_MEMCG=y and CONFIG_THP_SWAP=y.

The QEMU/KVM runs covered both the fully-zswap path and the mixed-backend
fallback path. In the all-zswap run, a 512MiB anonymous mapping was faulted
as 8192 64KiB groups, reclaimed into zswap, and faulted back. Reclaim
reported mthp64_zswpout=8192 and zswpout=131072. Refault then reported
mthp64_swpin=8192 and zswpin=131072, and pagemap/kpageflags showed 8192
order-4 THP groups in the mapping.

In the mixed-backend run, the workload used a 64MiB anonymous mapping
split into 1024 64KiB groups. After shrinker debugfs wrote back exactly
one zswap base-page entry, refault left 1023 order-4 THP groups and one
order-0 mixed group. The kernel stats matched that shape:
mthp64_swpin=1023, zswpin=16383 and zswpwb=1.

CONFIG_SHRINKER_DEBUG is only a test aid for making that one zswap
writeback deterministic; it is not required by the implementation.

Nhat Pham's active Virtual Swap Space series is adjacent work. It moves
swap cache and zswap entry state into a virtual swap descriptor, and lists
mixed backing THP swapin as a future use case. This RFC is independent and
works with the current swap/zswap infrastructure, but may need rebasing if
VSS lands first.

Feedback would be especially helpful on:

1. whether it makes sense to support all-zswap large folio swapin first,
   while keeping mixed zswap/disk ranges on the order-0 fallback path
2. whether a follow-up for mixed zswap/disk large folio swapin would be
   useful after this RFC

Thanks.

---

fujunjie (5):
  mm: zswap: decompress into a folio subpage
  mm: zswap: add a zswap entry batch helper
  mm: zswap: load fully stored large folios
  mm: swap: fall back to order-0 after large swapin races
  mm: swap: allow zswap-backed large folio swapin

 Documentation/admin-guide/mm/transhuge.rst |   4 +-
 include/linux/zswap.h                      |   9 ++
 mm/memory.c                                |  67 ++++++++-----
 mm/swap_state.c                            |  23 +++--
 mm/zswap.c                                 | 111 ++++++++++++++++-----
 5 files changed, 154 insertions(+), 60 deletions(-)


base-commit: 917719c412c48687d4a176965d1fa35320ec457c
-- 
2.34.1


