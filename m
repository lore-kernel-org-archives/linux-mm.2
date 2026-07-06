Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D6D1C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 09:29:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F7E56B011F; Mon,  6 Jul 2026 05:29:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A9786B0121; Mon,  6 Jul 2026 05:29:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BFB76B0122; Mon,  6 Jul 2026 05:29:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 219B16B011F
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 05:29:47 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8408740329
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:29:46 +0000 (UTC)
X-FDA: 84957829572.06.173BBCD
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf18.hostedemail.com (Postfix) with ESMTP id ECE161C000A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:29:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=wLau50Se;
	spf=none (imf18.hostedemail.com: domain of BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783330185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=69Iw3ttPHMSwqcKdtxg8NfnU4eIjfpVhtKG62i044oc=;
	b=h9GyiY+S4D8GDVgzbC6SV7mrkskK/MWlMxe6daN/yigq+Ofnz0D76gAxZCl987rIoER60U
	6Np2iEhtrsIpJJyLngHTb7rd/Fh4gUMgfO09eCwJedkYoXUJ44uznxYXFzDL4SM6DWqNQx
	XkL1Rnb128pLQ8/5bA8yyvA0ZmRHeE8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=wLau50Se;
	spf=none (imf18.hostedemail.com: domain of BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783330185;
	b=Zp+76T+0uTrztmLz+c/weMbkjGFOzMlvKjW/KBUOjgkT9rG6kGR0zkGofQ0Wq3Hue5Qk8i
	faYbhSgl0KdHh5evh01PmpN42qZTdc8YQheZof9u0LI/iGAlStssViOciJ8r8+tZ2ZDqcA
	sD88WHWwbuMyt5EpNPS3o7U/hEtNhfQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=69Iw3ttPHMSwqcKdtxg8NfnU4eIjfpVhtKG62i044oc=; b=wLau50SevZHGO5+f77bVQp6wzu
	wPB2ZjQWtkPg/sKqT4vVCqPzhN37NytWPQa1BvjuML6e/IpsHWkVmyuxU3BD2KtvHFYMxKf8WwMPI
	wOiiJ3EcfJighC5dq/Q/2lJ3n3YFrg8UUxZnZU105wS002IfZnpq2g/8CQ/97YKd+Qgxc68Fg9yMC
	tHErfliIjuSf29qDEU6L2+Sx7mcMZVviVXMId6PmW42EJOc9dHjw+eWrdnxZYspmtu9BHem6X14d1
	y0Lxk+SRXem7mEjoacOKKnVD9qvfyg4qpHQSnevJLvJmqcdnxEBTP0IXTl/FE8rrEGjVFN4ZMOo21
	8wbOtCuw==;
Received: from ip-185-104-138-120.ptr.icomera.net ([185.104.138.120] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wgfdx-0000000C1ZM-3yNN;
	Mon, 06 Jul 2026 09:29:38 +0000
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
Date: Mon,  6 Jul 2026 11:29:24 +0200
Message-ID: <20260706092933.766071-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: dg8m4m6j5tmdcouz338yqocbg88iza9e
X-Rspamd-Queue-Id: ECE161C000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783330183-121729
X-HE-Meta: U2FsdGVkX19RhyHWkJIuiDTFFLjkTvtYNjuO+Rqb6Y/7Z4XrSliAvbOJuboK0aTb0UgJ6gbca3z1ffE5qn69C3Vv775JX07kYx5nG81KhrXe5rCTVQWd4EVvUuSb3JcC/vcf6koroD2ZVcjuzUBwwt3+itSDZzCIPcbFWyPbP6eqHDVSemvL6MH4dZWNLWu5qWmmQsrojkk+06MY/rW4MKl/LXw7H2i3ydPhwCKxai1keOhzpM3LmagpXT2aeC3ceZtN0bfwFi7kzHY6YfvIvxP0MxSV2rqOxShawgsxNZ05dsaQnoFyc30LcTBruuJPjl35XXURXpjFbwHOUtv3kmF6FrhAbeH1gLUS0ft8aIMUZksKg1FCDnrFDtjlaKJt8kyaLe4smqyFfJY7qpUmL49CpsKL0rduTNGchKpcp378wYXnfzdxrSLV1Oxx73lCU+Dkn/18piJ/QlU2pEhUlXjBMdQ6A1DiuLlQQ7biwmf2l5jZad65XPP3QCHj4eMxpDTkwF4pT85ttBZXK6fKQnCJiWMCe/BfzZXo9CtanTNUes0cIBXcR9YCwJc+cMHlvk2V59pp+72qsgcYILx3aJlUTgulWGwGJ2/FKU3Ohip8wtyIZkEiYiTqMG7C9ogyy9KZF6H8RhbgWxcYGXbxDN2LTIonBKhus/NxidmSQmjQEjNXNVdoeh/NZ3ZiW5vhAHlenT/Bc4aMjxKBJsGVlT+rOz04wKCATbXllBZXTGtWMGLyF/5ynh4ikfi48fUzfEjaVztyXMWrKI6QAyZRKLvJNStMdnU6cXxgTHunuSJA2cOrZJswGXU7HR3hlqZMApFQmaJOVHYDHHFpaOjzaCUgj7b2ZY8qBgWJfcCNmZ45BN9eiiWvd1UQb0utsfY0zN1X80ThYnyDGI/3812tTOZtLMlPF3CNklXpUpIU7Oha6P7hjtXIqHIp+gMKuroMgHUITUbxCar2lDwU2DE
 LmvG5N4H
 ib6MEseAkvjuzwrOuKMsE+567HSfFkSM6JnZU1FzeFp0+srU7Lvw0OM6CobkXgiLfPx2Uww7I0msbVrmT4GDCkV4m6Sar5OYQOoBB7U1fOzyyUbC+C+BqWzOF3vLzTi7UzouyTVLuSaYU6vcn2pRSao9FYVhmEAA/OPqfGQvuLyy+nsro2uOho/voYsYd9+GasnsNfCnk7CTDhGB5FVBkPAkgXEVqzbjGFcXcTrhmC5zee4W/6zqIwx1Ln0hzd2pFvyp/xVl6HVvZQ4S7XwOdnK0k8IHNejjkA2R9cabJjPyPrfJTN00cxqtbsWtK931zw3hGEUtqQXzIz7qduBGaEeG1YYLUu7m/o4b5LSlZ+WSG5wzeU/dLLjVZmr5MvEYb786mOYHzKVyGoc3TG2KBEaXfjanoc8yAXK9kz0OKfdUHkAPvpnR+SjmoGAghObE3eRhI9jYVTNxuJqccBBmBhD+MD3N3D6uUoBipQqRVHTMgy9M+Fkob2p9dfIHGZFY40zb9WkcdC3ljn8a0smalLk7AMxX33E4oj4dqTOrLDkZ2OnIndxalvH29mM3woDCcjOl2lCtG+iZdc5Z+/Cp3D1psKHaalSvQvkC0kq2SW2KDbJ9hkXB2kKXtOWXcUeQm41najFSc0CuiCxs=
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

