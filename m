Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03B24606A332
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 09:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IQkTGoU0
Received: by kanga.kvack.org (Postfix)
	id 20A9A6B05B2; Sun,  8 Nov 2026 04:04:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18F056B05B5; Sun,  8 Nov 2026 04:04:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 080A56B05B6; Sun,  8 Nov 2026 04:04:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CDB536B05B2
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 04:04:25 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 46D801A0457
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:04:25 +0000 (UTC)
X-FDA: 85411365690.04.DE298A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7F69E1C0009
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:04:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IQkTGoU0;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794128663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=RwkS9/FSU2e9I7Q0Tq42tC4QHg0DrVHP4W+u4uUUs60=;
	b=FE1CWuOH41Tg+0cCknmjpjFD5TdMmo3vicJMXYlPXVMm5Ci9OGujT+NnW7GjpG+Q7j4eg7
	bVuvNurXHSRY4ztt/C+SG46xWaGlq+UUGq7iEGmgmBSAu6gYQjeY40BBQsEnU/8H/hwAQi
	/6c93hS65SEjjZ00esQghDHhM/NIFH8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794128663;
	b=qsv9nBvtrjC8ikyV4o2sSmD3iGbPmKY89T4u0Tq/qqqzzqlpUJhrXnqUDtnsvWIchGH8TY
	WH5vgi0ooYGiYV0Q3nberrikF6N3G7YLyu46t2rybPBpWpXv9HDGRH+3RJOKdbgWaw9GM/
	w0uQHxu5fZR1ENFcUeTGa6Afd9yryVc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IQkTGoU0;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B715240903;
	Sun,  8 Nov 2026 09:04:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7F11F0089F;
	Sun,  8 Nov 2026 09:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794128662;
	bh=RwkS9/FSU2e9I7Q0Tq42tC4QHg0DrVHP4W+u4uUUs60=;
	h=From:Subject:Date:To:Cc;
	b=IQkTGoU02Fa9oi0HZxYWUC5uYQ5KKZOzVzWKEgd3cb5ufumpMEw36eL+fU6N0rgOh
	 9ODviYrXPcUUIJUzlI2fBbZgLtNifNvnUYYBgdC/uzAA06RMOQ1AWkq01z68kGRnEu
	 MmJi1O4yFtyPxadZ9VLQ4O1fEP1yh4P2PracC2DcMDaA4ExsNi2jumKry4q6nViDnP
	 oHqnV7gUXkv3wLawvyVk+RM54F1Z8JRdPnmkwAkhKD0rW5VbQRf39Hm6AebU0byD/P
	 EW7l4M8ImG5OjX1KX+lvmAQiHg/dH9UF7UB8iL+RBzT6tZ8R0OQIwNZFJkPxgKhnUU
	 mI1q8hLDfIrmQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 00/14] s390/sclp: replace page allocator calls with
 k[mz]alloc()
Date: Sun, 08 Nov 2026 10:58:31 +0200
Message-Id: <20261108-s390-sclp-ready-v1-0-3e7c90eb6676@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWM0Q6CMAxFf4X02caBQTN/xfDQjQo1OkiLRkP4d
 zd9PDf3nBWMVdjgXK2g/BKTKWWodxXEkdLAKH1maFxzdN6d0A7eocX7jMrUf9C1HALVTC17yNa
 sfJX3r3jp/mzPcOO4lEx5BDLGoJTiWKZJZZC0f5AtrLBtXznUonuTAAAA
X-Change-ID: 20260907-s390-sclp-ready-05ebba1ea5e9
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Sven Schnelle <svens@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7F69E1C0009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ph1sw1xesswptprnkpg3cio7tdw5z5dp
X-Rspam-User: 
X-HE-Tag: 1794128663-830701
X-HE-Meta: U2FsdGVkX19Ggl0NxcA8N+MO8/zrcGo6K0wMqqMkDPjTKojr8aYQsNuwD6GgWcmoyub5D3gSblHtrOUvlNUHkL5U9iJ9iPUyzL7Pzu+hjRCMhs1Ux1TMbpTQrPPlYMx9fJn5HRFz1SiVaQ52rGnPL/z5apKOJoQi4CQihehxL67oGlr/n+TL3EkKdRQEgq0NuCZy/iVUaiJWimpUsrh1UQ2MWDDSPrwTYurk8QtScP4Rju262KP/NeXrnrIy8rc2+zI840VM37S6xwP3j/dTpLeEXKciIq+W+mW2G6M3mD1oFkc6Ib4DTGBZQkNQ3KAtYetbT5NxK19VvKqWjGr0msemN3/loJnTQ0xZm5q0nZM6y/GxUdbN+8kZZwS1+9QIgqKQ9SZ5SsyVzducpsNehEzZRS/J0DgXjFK66UtQZo1NEIPUV3ITOzNSAF3GnmvjkXBjzDc0Hi6I6HVnWSheE1rTOdbhmEJnd5BIDqEICN787pci8siXnc2fzzoe0viVItklaH4euUj+6QCk4Eio0SbkN051GK6MU028UzUHYZfbeh+WLkSZMDcvt/YlfPCgntQMXi+rM0KQGc/LakdxEZ34W264swUfZgQYuJxu2gEaM3/XvADpe61FmzW2MAorcrLCRLzeSnEhWx3+mzkiRPmiKrmpqtBiQ4XzPpx2aug83Vl8n9MP/erB6CoyUGy8/vNGZMTyI8qnWhZckc/oV8UTLLoMhEH77V684/nVxF/PiAeMsY62ZzEWDJsmaNJxpBvHvsYGlYuqjoYFJrufXixuojgeWY7HI94ZNDqNysLYaeg5ekcFyE5QzZYUf9oK1GLhARgAefnvLkbdohwXXZdVYrR1SBRzyK9DzS0VFs/3JMPTlnLVEI2HzmvTFSjG7ydfqCxwJDXwgCedrub132xgoK8dLfniNKmHAw/8pyv7iA3kDl28t45m+EXyfE9AyBtEGIBAxitk9rxEsEW
 R35kqboC
 /qD5ZZYEO2woubC8MYtettsEhskyiD0wszzmO/KfrjZdSff4+Z6lVcyhtg8QT9pjiPSg69Xx50KljTILwq3ckw8sBWF0vTlhWyD0FS8K8ghGL2ELX2T7LzfVPkSe366x1f3Tb7oudE8TMPYmiWEsipTZcGjzrQST+t8bXvGecnZmQEkd0MZCSKtjHWudN8RRArM037WY6RD+aHtTnEiT6KvpDBTwfdBUMXL1V8BXK06u18QQZAVo6XEGaVdJWU8jIUQ8mlvCDfX7cnQE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This the next episode of conversion of page allocator calls to kmalloc
family :)

This series covers SCLP buffer allocations.

= tl;dr cover letter copied from the previous posts:

This is a (small) part of larger work of replacing page allocator calls
with kmalloc.

My initial intention a few month ago was to remove ugly casts [1], but then
willy pointed out that Linus objected to something like this [2] and it
looks like more than a decade old technical debt.

Largely, anything that doesn't need struct page (or a memdesc in the
future) should just use kmalloc() or kvmalloc() to allocate memory.
kmalloc() guarantees alignment, physical contiguity and working
virt_to_phys() and beside nicer API that returns void * on alloc and
doesn't require to know the allocation size on free, kmalloc() provides
better debugging capabilities than page allocator.

Another thing is that touching these allocation sites gives the reviewers
opportunity to see if a PAGE_SIZE buffer is actually needed or maybe
another size is appropriate.

For larger allocations that don't need physically contiguous memory
kvmalloc() can be a better option that __get_free_pages() because under
memory pressure it's is easier to allocate several order-0 pages than a
physically contiguous chunk with the same number of pages.

And last, but not least, removing needless calls to page allocator should
help with memdesc (aka project folio) conversion. There will be way less
places to audit to see if the user was actually using struct page.

The patches are deliberately kept small, so that every conversion can be
reviewed, and if needed reverted, on its own.

Also in git:
https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/s390-sclp

[1] https://lore.kernel.org/all/20251018093002.3660549-1-rppt@kernel.org/
[2] https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/

---
Mike Rapoport (Microsoft) (14):
      s390/sclp_vt220: Replace get_zeroed_page() with kzalloc()
      s390/sclp_config: Replace get_zeroed_page() with kzalloc()
      s390/sclp_pci: Replace get_zeroed_page() with kzalloc()
      s390/sclp_ctl: Replace get_zeroed_page() with kzalloc()
      s390/sclp_con: Replace get_zeroed_page() with kzalloc()
      s390/sclp_tty: Replace get_zeroed_page() with kzalloc()
      s390/sclp: Replace __get_free_page() with kmalloc()
      s390/sclp_sdias: Replace __get_free_page() with kmalloc()
      s390/sclp_sd: Replace __get_free_page() with kmalloc()
      s390/sclp_cmd: Replace page allocator calls with kzalloc()
      s390/sclp_cpi: Replace get_zeroed_page() with kzalloc()
      s390/sclp_ftp: Replace get_zeroed_page() with kzalloc()
      s390/sclp_mem: Replace page allocator calls with k[mz]alloc()
      s390/sclp_ap: Replace get_zeroed_page() with kzalloc()

 drivers/s390/char/sclp.c         |  9 +++++----
 drivers/s390/char/sclp_ap.c      |  4 ++--
 drivers/s390/char/sclp_cmd.c     | 12 ++++++------
 drivers/s390/char/sclp_con.c     |  5 +++--
 drivers/s390/char/sclp_config.c  |  4 ++--
 drivers/s390/char/sclp_cpi_sys.c |  4 ++--
 drivers/s390/char/sclp_ctl.c     |  5 +++--
 drivers/s390/char/sclp_ftp.c     |  8 ++++----
 drivers/s390/char/sclp_mem.c     | 12 ++++++------
 drivers/s390/char/sclp_pci.c     |  8 ++++----
 drivers/s390/char/sclp_sd.c      | 20 ++++++++++----------
 drivers/s390/char/sclp_sdias.c   |  5 +++--
 drivers/s390/char/sclp_tty.c     |  5 +++--
 drivers/s390/char/sclp_vt220.c   |  4 ++--
 14 files changed, 55 insertions(+), 50 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20260907-s390-sclp-ready-05ebba1ea5e9

--
Sincerely yours,
Mike.


