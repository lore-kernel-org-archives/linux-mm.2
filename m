Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95EB4F8E4A5
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 03:40:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5A266B0005; Thu, 16 Apr 2026 23:40:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE3DB6B0089; Thu, 16 Apr 2026 23:40:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D2C46B008A; Thu, 16 Apr 2026 23:40:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 879596B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 23:40:04 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2C0D413BFAE
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 03:40:04 +0000 (UTC)
X-FDA: 84666644328.30.6651373
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf30.hostedemail.com (Postfix) with ESMTP id 39F6780008
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 03:40:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eOgJkgo+;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776397202; a=rsa-sha256;
	cv=none;
	b=7ypNcxHWo53hhDY1R7W3cdN+qj6WvDR7T008JxAGv4aYacXv0mE8d2OcB78PCt0v5qH+MM
	+5AEzPAvB5neOqdYQ9Igl2Kt2Jv+SjnM926ZcCfaLtRCTp4k7SZjsfyHo4HNEdtYkBJKdj
	LgunNyawba/bvSda+/pajyT+vjkknVY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eOgJkgo+;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776397202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xD+vD5Cr8OBOS0rVMmOY3t/SSk4WUPUpW/zHp5Clk1Q=;
	b=at6bzeGR74D35WfPsGY2er3TM0SknJeJYLWPOXgMhmF67MJaIWwefM06MlPTQomAY5aaFa
	zLsxEy68mWkerzo9ozjVWXuKaexFLQWhQe1OCldiCEKknzOhdCRYR0ApCTQWbRuD2/HC41
	gkfc41lIigTE39gnYbJG+H67FEPBMQ4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776397199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xD+vD5Cr8OBOS0rVMmOY3t/SSk4WUPUpW/zHp5Clk1Q=;
	b=eOgJkgo+8MgIVGP9e/c1+XjRF086SGxx89CehMr2ZeBy/PNJqWL1lEMq/wEg5vHwOYeQ3C
	5NQDlxYkWT1sRBk5/CbJgIDST9Vrw834v2ISrJOvHCfq8v52bF2NX1tCbAxfvB572jCg8X
	XixTiVmg9+BiLDN/MyLDwMEXAuOLtxM=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	usama.arif@linux.dev,
	baohua@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [PATCH v4 0/3] mm/swap: use swap_ops to register swap device's methods
Date: Fri, 17 Apr 2026 11:39:48 +0800
Message-ID: <20260417033951.1111038-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 39F6780008
X-Stat-Signature: wdwcarkmyz4jrxpoat5ujx5ctxjsbn9e
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776397201-460686
X-HE-Meta: U2FsdGVkX1/nXrSvwcKGfw1CA9mMVMlJ5WT9zZ3bbDzJzX0KTyLXuL7pvXNvg8+Mepsrd7BVWmqHHVKQrh0fhkivL2NxRIkx4PWa8VYK9CcFRdc42EAJ+pdiMwQOjYXN01uTW9Z6Zj89V92H07SkYM46lT6fXgGoZWtEyOZatnECu2JyNDmf+llsFRrqkSL3ZJ7EdE+uwmAsF8svtbxvfTI1qBw9fBdbx7yP8fQYwWXKK3ZS2pkDKCPyEUZ9T63Zjha44Z6SrYHHev6rLUT0JENkOLgn22hinzn5/sm//S8ntSVcNdGH1syFiUo3JzRhK96kzi/giGbCiALieBAQ6PL7wmRb16uAdMMz/1HyQRN0WFk6xOMUP59rai7KUZv68KYFEv8jSjug7Z4GJ+S9K63YTzjz35RA1fEpCMrgkmxC+uxv9bmkZ2OJoiL66GmAlWfoa3IFUSbQ97NcqjUGT617e9iMIcFKjT2CCaz1DeyyOZ9jtA4d6fEhgBEbf1m4DNf9/2xReyZgweNWs9YDW6+3Mi/FU+bS1KxAGZS7gtoszGMvNGhOKfcMzGQDawrk3TWYdzOtfAi7Pbutl2Q1KK1Wl2WcBtS4E6He31AqiffLUZ4FGJwURy7X35ThhXLatUY32H3kpRa3eQdWxF3qflVBTGcDiYDbPcpVsTvDjMgm1WnH4JIRFwWRS9yA0al109Llar6RGWnZCn7RQymIdh22yfRe3Rr2P+V2RGuS42Eb9kxnyq2Y1PHqjXZw86y3s0Z2pKDuckKjIBvH0Xaex9pJ1bXLlBBKpHV1A/p2g81hmuoKWZUum6upYhkV4QbEetAwHMpUEU+UPqkHvrlC1Hl+ZgEtbmjsgXgyqFI2MyyePHPUNFSLTAiaxKqYsJplX29kCjThW6LgMStBv0QHD/Hf4cwJlAEbKjbfm35cx8DVb8Zkv7F47z4PY51pw8p9Ng2rNjsCtG+Ll55Q1V8
 U27Yv9W3
 dS5APtZnX24W+xggtyzf50vgWoaUV3QO7LNWoUeQEcTYeYzSu9M2aKepti1HoV3Jp5iHVn3zO029aZmoHFjch83v5LjbdCYzJIx3u3PceLpxIErdbqYEceKX1QsHB0AfuwBkRFr69Kgw5Tf7qj8Rs+0CcAHtt2SsTbfmeZbARaLFtR8leJlbxIR/IUdm9Zp5Mq6Vm4pBEtPYcpud40rhOfw7QbbacMgDJQEoEPtzjRaKJZHdFvUCHO3riucIZfh5ARptmWVFqslfIWcYMX3zGZBZskHdNc5qY9EFE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This can simplify the code logic and benefit any new type of swap device
added later.

And also do renaming in this patchset:
-------
   file renaming:
   ---
   mm/page_io.c to mm/swap_io.c

   function renaming:
   ---
   swap_writepage_* to swap_write_folio_* in file mm/swap_io.c

Changlog:
===
-v4:
 * Fix a typo opeations -> operations
 * Fix a code bug inside init_swap_ops(). I was taking a change at the
   time, thought the change is trivial, so I only compiled but didn't
   run kernel to test in v3. Now fix it and test passed.
   Thanaks to Usama for catching the above two issues.

-v3:
 * Rename setup_swap_ops() to init_swap_ops() which reflect the function
   behaviour a little better
 * Check if sis->ops, sis->ops->read_folio and sis->ops->write_folio is
   NULL in init_swap_ops(), but not spread them where they are called.
   And once the checking failed, fail swapon immediately. This is
   suggested by Chris.
 * Call init_swap_ops() before setup_swap_extents() invocation. This
   doesn't harm anything and can benefit later adding sis->ops->swap_activate
   method.

-v2:
 * lots of cleanup for patch 2/3: renaming, moving data
   structures, and using const properly
 * collected tags from Kairui, Nhat and Barry

-v1:
 https://lore.kernel.org/linux-mm/20260302104016.163542-1-bhe@redhat.com/

Baoquan He (3):
  mm/swap: rename mm/page_io.c to mm/swap_io.c
  mm/swap: use swap_ops to register swap device's methods
  mm/swap_io.c: rename swap_writepage_* to swap_write_folio_*

 MAINTAINERS                 |   2 +-
 include/linux/swap.h        |   2 +
 mm/Makefile                 |   2 +-
 mm/swap.h                   |  12 ++++-
 mm/{page_io.c => swap_io.c} | 104 ++++++++++++++++++++----------------
 mm/swapfile.c               |   5 ++
 mm/zswap.c                  |   2 +-
 7 files changed, 79 insertions(+), 50 deletions(-)
 rename mm/{page_io.c => swap_io.c} (90%)

-- 
2.52.0


