Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1995BCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 05:35:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EE8C6B0025; Thu, 28 Aug 2025 01:35:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C5E76B0026; Thu, 28 Aug 2025 01:35:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 302D56B002A; Thu, 28 Aug 2025 01:35:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E93D6B0025
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 01:35:32 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8B73EC098B
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:35:31 +0000 (UTC)
X-FDA: 83825053662.27.890F2B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0286440013
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:35:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J6CY2779;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756359330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=oWnMkkuW1ndEbebyz/FNo4/PBsbi90IXJnhR3BgbPrE=;
	b=j6l+ETnCcbx/X1dI6UQdo/BXA4cqF1BCx4Y9Ox/8/Dey28z1a7wfoHmO7ZckqAK53W81xD
	FUGsW5xqAiuaSxo5y2bH73mCx55dCqL5g/2deyfDifTb4qr2HGRafLWp+FGb3K82m6Fl9u
	9o9GjvVuyiUW7mjfbXx65cyVQgu3iUA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J6CY2779;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756359330; a=rsa-sha256;
	cv=none;
	b=EAIMws0F4LYMfRyTS9pedhCSbst5MDnWO2P9fKwW2qeGhsUiq387YhcQcde4FxD1lhISYq
	3l/6LF/cGziBvplHyWahmg8y6sljtSeFqAfiRLN7v37B2IFpZBhdWZXCQcVaijDaK96SFF
	kI1Yq2IaZNZsMB+8rmxs8/U7WR2I8KQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C092D404EA;
	Thu, 28 Aug 2025 05:35:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC96C4CEEB;
	Thu, 28 Aug 2025 05:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756359328;
	bh=hNT7UD8Ou4zIB3Wx+NzE0njI2PpVlD1H94gqBstvBrY=;
	h=Date:From:To:Cc:Subject:From;
	b=J6CY2779PfUGq8bvFRiTykWWVQ62E9iaBbWI224v1pNdfpfZtBwTJTFn/QQVm0SuO
	 0hJHz+R6dLxe4WBO5q1Yg/Q8ROrfX1pCt/HepU1PQqyJPeyc+tfBce/5OLjtyT2SDh
	 JPCGqSoMzb7EgYdcbCJYBiUuCDrRatDWQyPALUSjwC/qhGPar0bCxt2VpaQ3FJX7xX
	 EN+d9+n/zpRrfQyTKXwxh6DXiULyTVHF4+AGSLkaewML6zX3wbGpCQFd2J5tuteVuQ
	 DFM7UxMnOIeVoYNkEVgCWJN9gcbkpsjk6R/LTW09T2sh2y7DP4wT+wfwEQdUPHImkP
	 SQHHq6WWdVb4Q==
Date: Thu, 28 Aug 2025 08:35:23 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] memblock fixes for v6.17-rc4
Message-ID: <aK_qmw51CJz_Tz36@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 6f8c8aqpzx35kwgkxyekdy4e5gwc7fgj
X-Rspam-User: 
X-Rspamd-Queue-Id: 0286440013
X-Rspamd-Server: rspam05
X-HE-Tag: 1756359329-647759
X-HE-Meta: U2FsdGVkX19OMKwg/zvcyDRmAFEZdW4MhEfvYRO/JYqi/tDwvrhFcpYCF0NubhfaXollreZ5asYHcQZmp335pYlkyVVAEqjj3Enbfajo7a9mugdjUqFwmZ5v7VzHIZ47+282bTQFwilDAGuAMN35VXx1AgENS2jhyi6cbN4IYb+3nbsuyY64KGXBqhyLKifRmQqdUepuiivmNyEbJgaefiG5+SukczH7tY7gq1mWoZHLQaRweR+1OglzEU/oq41x2ClPYklCd9kR9LABMevuIQVfomxg9GMPe9JlB7KRaakRqsUSp1ul5cQCak2EJ9ozpoCoeLykizRueInMWvw6BQ1hsTVNzbfSkZZzjUgZyhzevq2CGcVaMixoegZnylCbvlbZpoYdBGKHPZDkbWO1Ikfucxc94UhUh0+KUDRTogcp0iLGYepOnMswYoeXF1zmfRJb2mRN4eF9XxtOSsd4GP9A/AISQlU9bW99MEK2TKhkC5HKj0SCHWkf+DkH/COe+kTrAvLxZJa37PxavrJ5COxXwhIWYRfitOsu/OQmiSNF9D8OkxjLluK6KUmD0D5VQ7ooQjwWHjVu+yoL3yESI6iGZGC/CjzwrIBmTR2Y9E2x6MGYd+588ycvaClu8ztUhAswo2aoYWek255ONiqWHTHbCF65hsHXxE1KH2QktSP2TWmaaBJ6CpQ5twhPtyuABOlDawbT5NSVosK7jUdNYHJXQChbfknvnhlPHLIjls7d0i0qyJJLQHWUp2wIDJM5Xf24JUI5owoAqCKtt890xIwUejXZEaEyHqxt2vkg+DivErUHs9HF65AZS6hbUhUsartV0OoIliFKP+0JdlBWa2aROPp/0A7D65CFd4brvIxeH7+rwOIVlldv84S8rI8OEZAmdLMuo/zCanCrsVQRjZFYTbvnNbpQvugZs+/zauSxgMP5SoEgahTwk2TLjbXLX47e+vXZg3wn8CLFvN7
 xQUeTlf+
 jYj9aUmrBWmPIWDrn8neQAMDSYc8jAVFdzPkVB0VI/Kg46tLMx6XTkfJkF+hJaZ6GoS2dYDz2UB4H6Es94R56xg2TfTFIqVq1tD8AXSFR8q29Nm6FCGXQFXk3gePP9eUK7dcnZd5CWfRjGrgSWlh1dwFaZnHwyML1HOXX44r9830hVmfEdH/4TSJ0FaiY2MwIl9Zf728K0VLwlbWFYu7W5SePNySnlBMpRf7rSjcrgIPmle0+j0yW9yQkUVw4I89eEHChf0hAyi7D1UJ6NsW1lBc0xQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

The following changes since commit 8f5ae30d69d7543eee0d70083daf4de8fe15d585:

  Linux 6.17-rc1 (2025-08-10 19:41:16 +0300)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock tags/fixes-2025-08-28

for you to fetch changes up to b3dcc9d1d806fb1e175f85978713eef868531da4:

  memblock: fix kernel-doc for MEMBLOCK_RSRV_NOINIT (2025-08-26 10:47:03 +0300)

----------------------------------------------------------------
memblock fixes for v6.17-rc4

* printk cleanups in memblock and numa_memblks
* update kernel-doc for MEMBLOCK_RSRV_NOINIT to be more accurate and
  detailed

----------------------------------------------------------------
Mike Rapoport (Microsoft) (1):
      memblock: fix kernel-doc for MEMBLOCK_RSRV_NOINIT

Pratyush Brahma (2):
      mm/numa_memblks: Use pr_debug instead of printk(KERN_DEBUG)
      mm: numa,memblock: Use SZ_1M macro to denote bytes to MB conversion

 include/linux/memblock.h |  5 +++--
 mm/memblock.c            | 19 +++++++++++++------
 mm/numa_emulation.c      |  4 ++--
 mm/numa_memblks.c        |  6 +++---
 4 files changed, 21 insertions(+), 13 deletions(-)

-- 
Sincerely yours,
Mike.

