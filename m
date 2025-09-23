Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CD45CAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 10:26:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 294D08E0005; Tue, 23 Sep 2025 06:26:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2459B8E0001; Tue, 23 Sep 2025 06:26:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15B828E0005; Tue, 23 Sep 2025 06:26:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 00E7D8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 06:26:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 37A811DF20E
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 10:26:26 +0000 (UTC)
X-FDA: 83920135572.07.5067B54
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf10.hostedemail.com (Postfix) with ESMTP id EB1C2C000C
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 10:26:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b="On4c/9u6";
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=Pv1Y85Bb
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758623184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wdDTHWqIIQrO4Z56Gwoii2btyUPVsS03K4kULpvGLhE=;
	b=LUlyiU8u4qCnTRpSEIFIxxklRpEjQukHvEHFHjM6xoir6ZxaAhWEPi4vp+jM/PiIQQeLov
	nXs9cMVhp3+RyEHHf1E7DNfVqYQL56QbrOZ48ZpUmTsweFsllm/XQnDD/W95aq3xYMY/TR
	9VNrmvWFIlFiIN1lEES4W/j+GvUZj64=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b="On4c/9u6";
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=Pv1Y85Bb;
	spf=none (imf10.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758623184; a=rsa-sha256;
	cv=none;
	b=Rmgkrf7TV367gWYTdYlpdg+1G2HUIPY6mHJL4WYz95b+rJHoYL8wmr9ZZO+L84o8DKOxQz
	o6iKlxL5WYcYxTqYniRzn6s1GR7P9oWxtPeR7acC3UhDaaRfJfXweAnIG95ZVBZxesmPOO
	2RqceYo6L6/0FNMxl2JuwdiXo4OIpMw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1758623181; x=1759227981;
	d=konsulko.se; s=rsa2;
	h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
	 from;
	bh=wdDTHWqIIQrO4Z56Gwoii2btyUPVsS03K4kULpvGLhE=;
	b=On4c/9u6+mPnFx+axc8y1FQ13QoBkGkkSIigzg6s2MTIDFm9fsDApEqNUZL4M1ZYfD5wG5q3UPFsL
	 pbgbYfTjDY9SVqhhGT5go8Jz0MM0JUiezkrDgGZlwAcilwdTnPdo+0IJLVQASqKr8im2fXfSqCNKtC
	 gGjTnjZnPXJO7uxRb3xiOoVdpAQWXohdwazGQpoqtAI0SPjssRvD8vxwQWHhXJIwFyIciYDd/xg630
	 k4uiBtoRn+M+//+DYnS4+UA3mKEjdsQKlPfXD7LZNUXbB62qOKKi2/z/NBPXNbHZ054+QQDs5/a/Ty
	 yMSTDTeJZ5y3y2OP7PnC+3bnVaCy8PA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1758623181; x=1759227981;
	d=konsulko.se; s=ed2;
	h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
	 from;
	bh=wdDTHWqIIQrO4Z56Gwoii2btyUPVsS03K4kULpvGLhE=;
	b=Pv1Y85Bbid3q4EqIpaUuZa0uJ39ubo4f1p3+Tk6z18By/Ib7BfokadvFbtCXPmJh6kSvMB3tNXe1B
	 Akpp2p+Bg==
X-HalOne-ID: bef8abd3-9867-11f0-9446-fb5fec76084d
Received: from localhost.localdomain (host-95-203-13-255.mobileonline.telia.com [95.203.13.255])
	by mailrelay3.pub.mailoutpod3-cph3.one.com (Halon) with ESMTPSA
	id bef8abd3-9867-11f0-9446-fb5fec76084d;
	Tue, 23 Sep 2025 10:26:21 +0000 (UTC)
From: Vitaly Wool <vitaly.wool@konsulko.se>
To: linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org,
	Vitaly Wool <vitaly.wool@konsulko.se>
Subject: [PATCH v6 0/2] rust: zpool: add API for C and Rust
Date: Tue, 23 Sep 2025 12:25:47 +0200
Message-Id: <20250923102547.2545992-1-vitaly.wool@konsulko.se>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EB1C2C000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 1cn51dkq75e9qzdgdhqmah4o5ck4ruof
X-HE-Tag: 1758623183-737131
X-HE-Meta: U2FsdGVkX1/nDwBCWSlsIcjvAdRDFlRfoB97S6n0Th/+BkW8MgMqGOC79LoypXj5RLKig9OuwLLY7HX2aQEVXjOgOa0kd9S1WYbtTGeyiF5p+Z52g/1k7UWYEjpBGSfzsrjblqLpPP0dyhelUreAl4fK2gFIv4m9v6s9ozyDPtfRsgWfsD5qUh13JRZIhJag6wYbor/EFTtehrSF4N5vSAKpqjND7o2bbuj56SlW6C2sSvxo3mNYPCvi+eGnOqgHJiIDtI9deYulq1n9wtcUadgiQWMaLylR5fd7unD29+cMjDCziwvcZoA+2wXi7qU3qPj3asTxgFF7lNdMhVke9WglFh5Q8scjhA7Ufc3ja01sVGOcKyBMXC0UiXxobhuKOSdr9pTEL49/p1/QQUteCOihZBz/bZ+csJEH+/p1gjJpx9kSK4K/ywB1gCCNJ62DEZ4RrLyQShf2dDvFvn+CqcmIEU8JxZcgWAZpxflt5iUSdjTMKP/hjNB+37opvR+90itjLcr2wVHzAKSZagrscO0RlWfCtl7tQpB4WRId/Zoq0/bz2ZlYGEwBw45zJEHcxqGpzys9/c0iDUwuN7v2aZm2SK7dakSsh7K9cjrUVUbmqlMiiqP7R2uVIKlB9RQsjQUAUM0x86IPRPaNjKe7aP4o2E1DNB9pavyeJA47zB28FyS8jsjKtc4Rw4kqOa/frWWqJwDjOWKP3HR6IXfCUJ+48nEoAMGJM+8ehyioDCqAqYNoYOeb+/srEIh9W0fl0EKDl2jKuKPFPgysMa8sBZzEE6lelerL930PVh6UhP467tPG1yWbMSHbyFfgHwc7lD65lHYEvEJydQd3c2y8djyfZWL83zcUb/xfiDobQI/SoOgDcPdEvfhZYyEJ/TEpxFexIOpCBWXNaBUGbHNmpBXI9SYvZCHwr6lYsD8KBtLn0LhFZCfHIw+rX/XZyBT0pEJMyBvCl3xQfPDqqQc
 83gJy6FS
 oSntjK+LGhQlt6OjLbsK/u0zHto2a+p9Ss4l9cX2qLXkbRtCgMTdecc7XAIODVvTSifCNH2SB4qYF4Jwpu3Tn7zs8yP5v1Tj1sdC+hlksbT1ISV2iFc5nSGif+nALl0YOOttTsddlrSqlC8YnadNRD9zoLv1AFNdxoM1LFnAn9OlmNH3ksmPOrXVnqATn6wj/1LraLwTSB2e6QuVDQ4WHGDIXZv6CWLb4RAozmPXnMUYW6LA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zpool used to be a common frontend for memory storage pool
implementations. With its removal the opportunity to select an
allocation backend for zswap has been completely lost. However, with
the recent advancements in the vmap/vmalloc field that allow for fast
and simple allocation backends, and the initiative to implement one in
Rust, the zpool API is still necessary, though it's enough to have it
as a thin API for compile time backend selection.

This patchset provides such API and implements the interface to use
it in Rust kernel code, thus enabling both C and Rust implementations
of zpool allocators. zsmalloc and documentation are updated
accordingly.

Co-developed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>
---
Changelog:
v1 -> v2:
* reworked to stick to the existing Rust driver infrastructure
* removed raw pointers from the Rust API
v2 -> v3:
* detailed safety requirements for unsafe API functions
* removed unwrap()
* some typo corrections
v3 -> v4:
* added a working example of zpool Rust API usage in the
  documentation part
* change to Flags arranged as a separate patch
* improved safety requirements for ZpoolDriver trait
v4 -> v5:
* created a new type ZpoolHandle for handle representation on the
  Rust side
* improved description of Flags::from_raw()
* pool is no more borrowed as mutable for ZpoolDriver::malloc()
* ZpoolDriver::destroy() removed
* improved ZpoolDriver implementation example
* typos/markup corrections
v5 -> v6:
* removed zpool API is partially restored (to the minimal required
  extent)
* no Adapter based runtime registration is necessary
* a Rust macro for compile time registration is introduced instead
---
 Documentation/admin-guide/mm/zswap.rst |   14 +-
 MAINTAINERS                            |    1 
 include/linux/zpool.h                  |   62 ++++++++
 mm/Kconfig                             |   22 ++-
 mm/zsmalloc.c                          |    3 
 mm/zswap.c                             |   30 ++--
 rust/bindings/bindings_helper.h        |    1 
 rust/kernel/lib.rs                     |    2 
 rust/kernel/zpool.rs                   |  366 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 9 files changed, 479 insertions(+), 22 deletions(-)


