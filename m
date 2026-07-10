Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFF19C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 06:39:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79F336B0088; Fri, 10 Jul 2026 02:39:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7282D6B008A; Fri, 10 Jul 2026 02:39:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63DEC6B008C; Fri, 10 Jul 2026 02:39:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 336DF6B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 02:39:43 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BCC0E1A0395
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:39:42 +0000 (UTC)
X-FDA: 84971916204.20.664712E
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf29.hostedemail.com (Postfix) with ESMTP id 54CF8120007
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:39:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=pV2XkeSO;
	spf=none (imf29.hostedemail.com: domain of BATV+f6dbb437d89e5d5f1fa5+8356+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f6dbb437d89e5d5f1fa5+8356+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783665580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+ESCFsbVvQUa5H0HSjk/VPclpDHw95Gsz980w/cllrM=;
	b=tuipzT6wX0kbzZGMFzBbjdw29klsG4dDGHZjvqBCe7eQQsZ3REsZ6mCS8uwJK/TtcFKGOb
	X9WdyQHiKBc0BXrIpSmvLQXBscU6shrGmPtjx98h7HdekEcWtp3YZ2AZQVf+dFcL3bfFC2
	lcc7o8qmlsRFb+59kA99gG00kYvHLaY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=pV2XkeSO;
	spf=none (imf29.hostedemail.com: domain of BATV+f6dbb437d89e5d5f1fa5+8356+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f6dbb437d89e5d5f1fa5+8356+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783665581;
	b=50t0llX3ExkkxbZVCxRp9LvrtJQeqUAV2mFBjsv/GQAZ6IWKYTnbMf9kIIC77jr2ca7OXg
	xa+GuARSqCNjUU7JIpvUIs8tRZ+J7pavKTsrWNQzG/iYjnxDImvgQaXxCjdOFqOtoZaqXR
	yC+xuvqn+Ap2Rh3A5Usmf2pCiB7Mt4I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=+ESCFsbVvQUa5H0HSjk/VPclpDHw95Gsz980w/cllrM=; b=pV2XkeSOG1+FpNB1G/2RTUVgbL
	8WsOcEUTUmsHz+Za5BJCX31SQplnVaYGrfj4T3QUcFx4Ol8LNQEr4t6LTcu7gZa+cHvd4ioa5BcFP
	sSGZDKbxipCqSOLPyFYEw/xJqixQB9aFLhqpn5K/bfJGWSutLotfFQIA0oV2ldqCyxGuXHCA4zQNE
	cWo8le9PVDJz0NHdDtCwIjS6jPGSTtEdue9SuPrvYZddiP7NN43kefV09PuMh4ccPf6au+5rZkNoN
	R75r7AQcS+LFVwkF3t0Xc1RNDA94jh0eNDupIY6q044eFwFyefuRUURfaC45YE4tyGKckKGsLgJED
	krIEnYXA==;
Received: from [2001:4bb8:2cc:d72d:4dff:292f:a943:a4b9] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wi4tY-00000004HNx-1F3b;
	Fri, 10 Jul 2026 06:39:32 +0000
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
Subject: better block swap batching and a different take on swap_ops v4
Date: Fri, 10 Jul 2026 08:39:11 +0200
Message-ID: <20260710063927.1891452-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 54CF8120007
X-Stat-Signature: n9p66jk1kg6d8hb5z7w4uxdrk1pea9oq
X-HE-Tag: 1783665580-456058
X-HE-Meta: U2FsdGVkX1/tHuuzuUFTtGcvQjhfu9c3Q5bA9bDzBP3zM1XHiqMNxC3lk2cZpBwf4ttKTCPRIEFMIzm39ArsJHKkJjR6jVYyaLLUaEnC1QJVBYy+HL3ksVTTA9ZA3A4TAhGnk9hkhRrwYOU+sxTrVlDpguIzsBfuOGAOjUBljLnHTp1efaFgDYISKSWMtRWRl28tCAmgnPrjGImqKSNScEN+d8sluCYv9e82+cYFqHq1ihU/v0eFvcmLd8YNvUCwK6x9Wp+Jdwu3f4UBNpT9bcEvW/iqTwHBXZcWJexL1yGy+RARMr0BkN9qXdxnhecH0XhDsT27mhhvYWtLkOIG/MimPeXzgEu8yp4RRSizsU3s/T5bork5d+UHjGV/+nOZ4xKlNkFeu9pi3UCCyRdb1231mVwEVb1h9nXm2ZgglMQmit5AqNOj99j8uGYN6tDHPTq4Yf0RVqBpEG9rj9KfpHvqpxl/yzqD61MlnlHsz58JWt2bQ71h0auwaUDjy80oVqZhHv0t54eN1DpTtx7yFHFQjP+En3P1TZM28BgrRGDA2tB58AIYGxdIBVSeHKMJMBdec/GOzKcLZP4cLtydGhAq7Va2HDCHmfIE+a5wNOTzEe2p2PUCHBxfDZJe2zOOU9mwXCPzEafaxJkU1rhLFaL4ykeXwzmV7yeW8ByOPkW8WC4F0x3J1vB4uJtnIqhTEmSUD36I+LuDRbaoQmo1/eJUw5vuEZRT1UnB8Zdm5FfFOq6/vhta0ERKw6QjFgpErKsYMeyQG9FCaWA6lJ0pbctd6e03kQYT1tPWNnXw11zCh9xr72itE7MeImd0MxTKTnrDnxGpznbNlVRpq+d7xRcQW/ThyZpV8OrZn8HaFVchKwXjekGudSwXbozpBp3mxTgiT5U77C3zgKE1q7JpD0li28GDstpesGCZQvvD6K6naXMaXiE6SL1fRok+JGtNcgITKMIMxWquN9C9n3f
 ZE3DUsD8
 Iqms9zgUsDOqXnexPmfvBxto1MQqpeJ66iBwBB9RL/ojDqN/GGh8b2z9Epat1b5BFOQt2EegBAMCmj/ukB8imK4Sd76isBTvI2EyHuU92J/nM7tYMwqw3B0pkP5KQfOilhgSSVmAzxSKUO7LQdWc9xHRqIKNoIAL8qLz1zeRt+M4jtoiy9jX2XMjG8BP1SJrLz6fgFlolFY+tjLRYFj333CvWlgm3zh1vQwV8uuNR9sgNdZLPT4JH/jTlm39n4murIIy8K7wZ7cyoXTBmNS66lRPSbg+3JssWlAUan1XN36MFLTN/91m6igaIwvbEuzXWSngIUNydPQszCoimL/CcdIThzCwsakIT9reWz2Kpx7hfDSK0trYJpp4ztBhfsTMGTjyur6dJ1nYJUe+934w7TzQ5VHB0EcNvIb/+eTvPJZcCJZofWScqNIqCedD5W3hjRASGm7XPkXizaw4gfWfwrLBPdr/2VLXsjbnOMUjl0LejIrIh8ATn6e4PCyeDDBssuK7axMMdc0N0DfWocYEs23ohEDAcTAhUy6D0i7HhWkSbZjabu8H4tqWxJvFTJZggbet7q75d88A56UG0qsuZnyYI4BK4wEEMLgu0Mc7lAVDt1D9N4XeYEY5cZRidgzLChkcHPcYE5iHMHlN6NiAGiNHZa0oNWMWOfp6A
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

Changes since v3:
 - rebase to latest mm-unstable
 - don't merge charged and non-charge folios into a single bio
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

