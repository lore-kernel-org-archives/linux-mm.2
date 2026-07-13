Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3110EC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 09:34:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2A2A6B0088; Mon, 13 Jul 2026 05:34:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB3B16B008A; Mon, 13 Jul 2026 05:34:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7D516B008C; Mon, 13 Jul 2026 05:34:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A086B6B0088
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:34:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 26D841C43AB
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:34:10 +0000 (UTC)
X-FDA: 84983242260.16.325A982
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0491E40004
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:34:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=U1B4qBCC;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf12.hostedemail.com: domain of BATV+55c33cd1421391a2a6eb+8359+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+55c33cd1421391a2a6eb+8359+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783935247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9FWCSt0MqdSJ/9cYGYlW2iKD/Aqr+0+3cG+7qGFYLVo=;
	b=hzkytV7k9cIR4E0C3OvZf8OWihBy8nBw/FdNkUzUHobhnJQnon3lBbbYVdtf0fvy8clAq3
	dHh/DgoqMa7RXvbfhh0YSJMxlDn6NaNkGGB8X49qexSnShy2Cksju3PxUozqJUuv7VEG36
	aGnACQ5xessz35tpzkcTx9oc/hbcKb4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=U1B4qBCC;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf12.hostedemail.com: domain of BATV+55c33cd1421391a2a6eb+8359+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+55c33cd1421391a2a6eb+8359+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783935247;
	b=olPh25F6hOGM/ycQU/Ds1nggrcKncjHaMLArpMKoshyuyHlPAaNUqofUHcfYI114NeggHc
	61goU5e2/YnWgrkW1ymJEaNYoi5YTIKXEgMxUvxAAHH62CMqQhmh9/BIRirSALUqA14aq6
	nLCRdZu1N1WF/R7ha7lrGape5MR2hPQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=9FWCSt0MqdSJ/9cYGYlW2iKD/Aqr+0+3cG+7qGFYLVo=; b=U1B4qBCCtjozIZCiipeQu4/1yw
	SEYwlSVLqagPxOlwhhxysF6qe7HdppGae6hOlXtA5SnfedEFzleAJ0mPjqh4f+qPGaIkR1bkj8uqo
	jSHQSkq85zVXD16iT6qirYqgJN8Y07c9Ka4Mn+vwCII6R55wudxgpwm7KzzosLrUvvcPaPc2ZxkMh
	MEVdwOaotnbnmGElyd0mckSHc/YUZGH6y48xYncs2qhw04BpkSTxNPk/OgHzRorvyxdanmAj5QV2y
	brvoEctslFhhhBW5rYRg5uBHiaJzFcXKnJm7gESuhXKrkgt1/a+jIQtSwTv//WuO/gjX9oeylpCWc
	bnZYARuQ==;
Received: from [2001:4bb8:2c2:7dc3:4a7a:b4de:3d88:bc44] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjD30-00000008kf4-2Iwz;
	Mon, 13 Jul 2026 09:33:58 +0000
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
Subject: better block swap batching and a different take on swap_ops v5
Date: Mon, 13 Jul 2026 11:33:37 +0200
Message-ID: <20260713093350.2154226-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0491E40004
X-Stat-Signature: me77b3w5uyt7bzcom8ceo7mq8no4wip1
X-HE-Tag: 1783935246-884598
X-HE-Meta: U2FsdGVkX1+Yx41oI6c7UHM6YfcT+eH5ckyNSmsgMTkzgXTdKo2oJP3injanAJVrH/Ie0jzU9iJkHoM5eS+vnUw23bWnOlq/p7AHPPTRFvOBwPCHMTD0T0X9hiFSYjsa6rOvEZBT7CU1xiNDtLjMJ//imM+tDfn7r/obbG8CsypymjTt2VlKnfpF9xkNZsuQCwA7rYG7+deQgdtfC4cSWEIkcS0At8ND0SZNeHr065nVtrytaN+flObrsFeAtyxUL67Uo6CCeGuUhQ0JSqCbgnKgeVDaoKXfi1nvOZRHQ+03KKPYtU6YEpydWt518cDRVSOK1qyELq2J2/JlImrQ8//Vx77YkcI2YBp7kB5vLRvqYBx+v8u/8PbhzTWjrwDikkpdzQNaLTBucwgWj5iliP9t+MoxiGqf1Z8qBkyy7hzLrlluoGv2zPJa0AYEqktW+XhF+i7PDnLcIJfypkKHI0bsAkeLtkwXllbhCnPww58F558UzCppPp82jfXrhTiPmPHyLirzQ8SE0PdpuBomIRYL9tC6Luf3Ep+2FfTNBK2Gm4CDiXwr1dScfCIfUSEqbd9B/4Km3uSSD2emItj1XqA6dxaA3LbO0IfaRxTrF0kxO4+xUn3i4LDlgY7BGnhFWqE7fsef6xauKUCY38rDYQ4cenYg0DRT9PxVbDvfWnapFZOVNA8axCEGGFiF9nEvZqyaZlPNzHPfla4D36Ovl/b7U15UeMlpSFdCbempH1iilM7vOWAXaCKSgPx9VhAX1C4IO6iDiMacvN50eNcU17/t1lZjBOdohmy8pZNQfnz4k4/iZMCy6KSbmgPt1IGoqJvbaYy7KTxOkMVfNRZghnSlSJ9Q9I67d10Ag1WjGTxBQ4avMOwzMlOFUtKYOwR30goUuPxv0CMb54kgagf42mHnY7iYQFMiXR0OK/AvAPz7g6JRYO1JEYrF9zEfw4vf8j/3ln3UC/9sbUqsfF/
 L4rF2KG6
 XsqBFadgGjSMUXe4vuNCEmJLegLAi6LLVpuTpJY1RUFxtHrfzusvInszR6xHGE0xLPVst7fndvx5+f4g+uL2Wf++4ODBfOcOtg0MaTazOmhgzT0f33HIHUp/77OyLNVpXVWwSkPuuX5g4x2nsXkxV6G2rxJZlI7sNJ2osGWjNsxDpd8YeUutnD8CQEJI6fxb3PcP0A2yXc/uL3pePBeHr/urspFM+bYrQkQJ1e91CI0mAtMNI9dzTG88ZTvVJV9pi2JxGsa2bez+NQW7DwhyF3xZOnquG2KZp3KQBeOBVEKk3p2YZ3u7vNyMn1vbupPgmCLy6PQXT+Sh6ifLxPTr7Axi1usH2bJJ0jWBcYh+l2OHEaEGnsGGdVoRx6XfNF3QRXZgjAN/CxPbuB2zMUhSKQrAJGv9jPGwhh9EqOXstbTzhSJ2cLS/46iIg6gk0NvizMSMEUcC4ADq4Y8fZAwOWJhOIe+XwGk9h2tZgb8OkuWe7P2tvr5rG7dAPY7s7vj9HSsMYrH6hFdWZdGsdy3M80HnH8MIVMIPT7R/9Wxztu8waKZEoTLPZU3vnDrwtpuaDUBX9bqQMEellgo35XbZg9NLjiD/SQwskUncyGI6nJL6EcyjZAcj0a8Dq+qgUvGJ/tBiLRLFcj3Z7vGPNQvLqYhGcZ/EQQztBu24v
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

Changes since v4:
 - really fix the charged vs non-charged merging decision

Changes since v3:
 - rebase to latest mm-unstable
 - don't merge charged and non-charged folios into a single bio
   or fs swap request

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
 mm/page_io.c                              |  586 +++++++++++++++---------------
 mm/shmem.c                                |   18 
 mm/swap.h                                 |   67 +--
 mm/swap_state.c                           |   53 +-
 mm/swapfile.c                             |   11 
 mm/vmscan.c                               |   30 -
 mm/vmstat.c                               |    6 
 mm/zswap.c                                |    4 
 18 files changed, 432 insertions(+), 396 deletions(-)

