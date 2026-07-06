Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2B1BC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 09:29:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B01106B0115; Mon,  6 Jul 2026 05:29:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB08D6B011F; Mon,  6 Jul 2026 05:29:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C7E36B0120; Mon,  6 Jul 2026 05:29:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 75F086B0115
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 05:29:11 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 02FE7120361
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:29:10 +0000 (UTC)
X-FDA: 84957828102.11.2480346
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf16.hostedemail.com (Postfix) with ESMTP id BF5FA18000A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:29:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=0iSF6bOw;
	spf=none (imf16.hostedemail.com: domain of BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783330149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=69Iw3ttPHMSwqcKdtxg8NfnU4eIjfpVhtKG62i044oc=;
	b=poFA4k/y/SY/Y4JGXSV0QiXqq0UVy3Lqv/JzkCM4YwO3zxuF9aEP+g9bMcsZj2qg7wpeSI
	nyKdlyWt0wQCKOI5m9dS/WO+0ZETShO3WXSRiO/kPICw12O9zgvWV6900HxK+g6Nf03+pt
	XHgHcqTE8XrddSV4Ayl9OrPCMye+Meo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783330149;
	b=57LGDiiM3QQrPiJeBepNM6PPiUn7mP2PjToUKxy1JTIWGNBHyIjJjhHsvqeqCDGyFzqV1p
	zoeMK7+AQB+fuRuC41Va/D7ERxiwxPO12rc2caRVAhfBck5NQLbvQO3scAV6euvJP/POXA
	J+oIKyczz3aIvueDPyqz+mixhM5Gnsg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=0iSF6bOw;
	spf=none (imf16.hostedemail.com: domain of BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=69Iw3ttPHMSwqcKdtxg8NfnU4eIjfpVhtKG62i044oc=; b=0iSF6bOwztDj1Wb56XUVT5MCnG
	WSHyh2nN7K3oqvby/mxC1OrXJaKVNww/C5UP6auJF8caIsdP1ASRCnhRVzJJcT11zi6EUL/iYbLR5
	KBTbqSZqVZq/+4N8R5SAZ7C58dpcw+N+IlzhUyKCnuPSCd3d7x5pQBzHwIPdF5oZ+AoD+HdBtOTcW
	SiYHhh9hHsRK+qlZs8fL0sqBoAseB0H7bIEX8ePQVEC2tWkPhzrefs3g/GkDJYCCAL+/8jjCScFj4
	Dkaxy6OsbMcp4azmW2tuH3FemPPqdUKk8tfjbRH7zirIoHuEIrfm+aJSDZ5SCz8I0V2EpbaVPAe5p
	5jb8xfRA==;
Received: from ip-185-104-138-120.ptr.icomera.net ([185.104.138.120] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wgfdM-0000000C1WH-47Be;
	Mon, 06 Jul 2026 09:29:01 +0000
From: Christoph Hellwig <hch@lst.de>
To: 
Cc: baoquan.he@linux.dev,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	usama.arif@linux.dev,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-mm@kvack.org
Subject: better block swap batching and a different take on swap_ops v3
Date: Mon,  6 Jul 2026 11:28:40 +0200
Message-ID: <20260706092852.765542-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BF5FA18000A
X-Stat-Signature: dg8m4m6j5tmdcouz338yqocbg88iza9e
X-HE-Tag: 1783330148-579220
X-HE-Meta: U2FsdGVkX184zdoVFcTNfoK4PjKdnn/ITVnnFbipfp2YYmSk1YDVJQXTkbFAHf1amNNXCKdhl2hITvauR1wzCtupZ4zshIUci4urPher3uywnvrTWVxrZkP94gvT1BHoCH/Pq7xqmL8Um5pj7ff9Jd1mAFrS2suVK5vMus9GlJ5Vh/5WdbdQH4wwwTZYEVYkquqYfBL1CU8V6oU9JbDoOIp4ZcJfpaKHKrKUdfLw8oAAmqmTW15LINip7ZjktKrRYoi7H+Khp6eyghEREEG3dqX3/0hyiefsPZwawjS4lNJm7i0aXXtwS6xYUkZLh9e8MVsE23D4iHWqu4bT2EnZwGA6yobZgtJTmOZqJS6Wm1KHLPtFCJduTBscj8Aip0yDxwATGDsReFJ5TboMwCm3Q90FBl/WkDzD+aNMnaLuIMaRibjgW9k5n/tiJdK3KyfhA6vzhYiC7IQhioBDFr0hiRgNeeWJajl2CSZfxcyQtwTQtSftmMQZlBEKDnFTg+cduKqqjLyRvUK70hSHbb9fT4TDTB9qHym7rOP/bJh9PQWzi2ejOn6nWE20B+KfBA+NGiKDZDPdU636AORpktC0qqW2M2r/0utZEQMXpv8Zt64eCtXcv977uLwYmBjHf6bQU9MfkBhRZwMqXsPsD7nZTOkwnsaJYqpc3650sCnaYGP4Joq6bC7m3VYX6Ll6ZOPEwYlPIgYcSOOYuMMJZmq3barji46Bsued6/NdI7qB67z3iq/MFI4xZgIh8Ksv4+aH9/aFvaKHa7Pw+UFbJUfiA+tbNiPBWUSn1NN2ubcKtykymWiW2qMZx4Tr5upZAItC8rtv1SqqIXfKdKTCA1erhcshXzEqWMdvW8j9NfsLZelM9EoKkM28wZClFpNtYo0WyNLXXjOpa7nSiOWvPuyGLKf1ggeIJ4lirIU8UzaCHYmM+Dq2kgCs7AITtOvSoGsyCbgIanNZOWJMqprEyoa
 SABAuGZz
 kPugG7lbksLHD+s1Hfu5nr+3o5SF6Jca5uLIayFkGEzLg7J9XapaDR3XZh1DD69Tp6n/BeOoROqV4DMENxLHiEoG9fLHPXViLMkj80agxjj05JFH1mchk7BbFBZ8Fl+MZ+Fh+VozSBQip9E0TW+Ry0MUXo0cF/WpzHIaQbG7OxTC+2l4lFpVWzcPkT8gz7JFG3+5Fi7tX9htAlF5g1UjsmKaIScL6juhlXpxlFeFNHrs0KwgQ/ScyB8fGV7tkSNKGcgEgIpYg1HNf22X59jGMm9ZVLFZrGZZedkp0S1TKMZRZZ1P04QAbRfRU7Dnw4vUrsjKYvZUqE5qQdEe2MhrUsonV/s7BTjATs23IFvdOdaGT1God/c1uWrCFdAj0NWEfoaGklXLqLBHoTp9HDkYgUEFh7dWSsM+skESvkPpp2jer+v2hsX84dQg4VMTcDrefzWrKstpMiDd0hj9Tt76qUQITz/pOIMFI3kImBfpgkyi4A4KZOqsXF59rlBPzlWUpIw/lU3bjq2uwLVqQT9BVWhYBWoNgyJTgAylL0IfT7wZBmoE5lIG3SOuB509aFK+PisDJYPtQxPbo0e6AY3ExBU16FGfMj8RS6UyD0CHr8t7g0e/vVYF5tahHT0z/VeiwYMfrz68MbRD9gOQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

this series makes use of the swap_iocb for block as well so that it
doesn't do inefficient single-bio I/O, and then rebases the swap_ops from
Baoquan on top of the now very different method structure.

When running doing kernels builds, which is a workload that doesn't
really do much THP anonymous memory it still gets 2x clustering for
writeout and 1.2x for reading back swap in.  The overall times do
not actually change, though.


Changes since v2:
 - rebased to 7.2-rc2
 - rename swap_add_page to swap_add_folio
 - rename SWAP_OPS_F_NOFS to SWAP_OPS_F_REQUIRE_NOFS and document it
 - improve various commit logs
 - spelling fixes

Changes since v1:
 - drop the memcg accounting for fs backed swap as it can't really
   work as-is
 - change the related refactoring to not create a bisection hazard or
   compile issue with the wrong set of cgroup config options enabled
 - remove a now dead function

Diffstat:
 Documentation/filesystems/locking.rst     |    5 
 Documentation/filesystems/vfs.rst         |    4 
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c |    2 
 drivers/gpu/drm/ttm/ttm_backup.c          |    2 
 fs/nfs/file.c                             |    4 
 fs/smb/client/file.c                      |    4 
 include/linux/shmem_fs.h                  |    5 
 include/linux/swap.h                      |    7 
 include/linux/vm_event_item.h             |    4 
 mm/madvise.c                              |   16 
 mm/page_io.c                              |  585 ++++++++++++++----------------
 mm/shmem.c                                |   18 
 mm/swap.h                                 |   67 +--
 mm/swap_state.c                           |   53 +-
 mm/swapfile.c                             |   11 
 mm/vmscan.c                               |   30 -
 mm/vmstat.c                               |    6 
 mm/zswap.c                                |    4 
 18 files changed, 431 insertions(+), 396 deletions(-)

