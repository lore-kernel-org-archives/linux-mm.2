Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92723F532C0
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 01:00:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D27F76B009B; Mon, 23 Mar 2026 21:00:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD7D76B009D; Mon, 23 Mar 2026 21:00:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEDC66B009E; Mon, 23 Mar 2026 21:00:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AAA226B009B
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 21:00:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 04E29BE5FE
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:00:10 +0000 (UTC)
X-FDA: 84579150222.16.0955668
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5DC4B100017
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:00:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LcMfJHMG;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774314009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=J2gq76yk+y1oJjYkfgWnwR0L/rkEfO3Gu3qzypXSlEk=;
	b=eY01fPYOY9Yy0MlRMj8hX+G/ufROL+xMNFS/+gZg5o8re0tqjJpO5NlSBFkqV4Ew9U8O6a
	+QFu61Uxy94vJ14yl1CnVFLWs5ZkeRwq/lhIHlDPFBw3Zh3MqYcy4xzz1uB+ilx772Ao4P
	rcPVWh3GiUr9l0LlrwdYdZ07365EUaw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LcMfJHMG;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774314009; a=rsa-sha256;
	cv=none;
	b=YKa4ZzMTjrGBvRJcsxE5MC0a9AVjlOJ8TQiTCxMdkwcc46N34iXwxZ7ZgiLl/dSiO+CNpN
	KHKAXsBvQK1WnaqjSdtnCf405ymkvA+Q80yp7Yh7FBp0IurmihnIJqFmTPDQIir75jKJXD
	t5R7+sQvhJMIy7amMdbk38pflTagXG8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C5026600C4;
	Tue, 24 Mar 2026 01:00:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCA7C2BCB0;
	Tue, 24 Mar 2026 01:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774314008;
	bh=1M/+ZL3YVbiZ1VmIZKgVEENFjtm//36Vc792xqujAVM=;
	h=Date:From:To:Cc:Subject:From;
	b=LcMfJHMG7UV0nKYomJpJIw5mjaC+sj3HzgQCJUrnWRBy4Hrjp2TJ/UlRy1gWEir6p
	 sggXOsQI7H2owR6Gz3Z0BhemlKrNaBhjeQb6qIVKNHnDcpBHHy4X0w9ZQajn3F0RZv
	 te4xfLiIQ1B1r6spQqdnXhwKRnIu5FRv8mydft5o=
Date: Mon, 23 Mar 2026 18:00:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 7.0-rc6
Message-Id: <20260323180007.d3f7db6a8b5dc59e72cb5f62@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5DC4B100017
X-Stat-Signature: g5ap6adohhj5usdmh6p7a1awj46w3yhh
X-Rspam-User: 
X-HE-Tag: 1774314009-213239
X-HE-Meta: U2FsdGVkX19zFPchAf2KiThI5l90EgJ47XHpxlKs8vU4OqWMpoLOh+gxcqppjv2S84ACgVKyt192MvH/GPQovFMGJr0N+enwflkuMq6W5r3KDioGZu1dy/tHxwTsfrLGy7Vkb9F+t1m9LMMDBm1krwms1LhTsfLUMSm5QsFYxUwO7cOrdz/ajUJp6owxhFV88VB69XllAl0NDtr0dJocSUyf40L7mYvEiPNbkCw+eJ79fJ4qgZV3CWkge6ImH4RNDQeeEXAtiUNlqvNK+NdkRmKJQHj8mGSNuu2pHyHAk7ocR1TaATsBbblSH+S8DEjzdzd0zuWsLQTtPtwUZFGrpseAP98fKwHg+9/nc9uor79foE5Z4iQCc3LjycIUOPpE/uK7l8J9DN1DaNPXBWCVu/kCL/464FdHP+gAfMdriuSKKl7vjh/Li9KhkZQKcrRrmTuDoRcUi8itOZsj50pS0J6p0lDxeU7YNpH+/w1xkV4RkDXCIK6mTLELH9potT71pxw622FHOgCU7sQAU3BkCamQXRdY/E33P6zuUd0p5DP9RF0m/1xz+ha02vutTKqdRQ78LkyI139N8Incv/nZ4/F1g870MacvomRGwOp4NWrVXB8V7zf2Ty01dB+3bZAzIA60Ru0IRnFm1W019g0ktA2syabiEUCAQ3NCM1LY9Bqm7VEBhe+qyJZ0dXTXIF0Q5mPmUgQBBC6ubCSuMu+E6d04T6oBQ23E0MFxA9Gumb7+FvkRfBH1TT8TR3VeviYp/4B2pNcwBDrNL+iBhA0dheo007wg3qkO204zUOyE8ZdIHMrECGVAxDyRsAhifeZ6Hywqft91s5G5HtDQQhgfgyFBvHWpX2s3FCOgo2sRjPe7Dhl9T91RmeJ6n2T6hE8kfAynzNMby0fJB+Q8Jn1ZSN1RNi2z8EUW4wWS0f8BIiGQ45aThOgLW1FeE5rxalvTth3V/NXpdczvvrFKl3A
 8FdMR4Wz
 yx+8a/apwp1vEkXaFghhWstZWsw4ye9jddvjsAEAYtKDZ2oDM05MZSTl+teThSyp/AgrOj2tjvJC2Xqp868Jik+5BWmNMSN15LXOJJQIKto2zcVd7TyQszHtaDqCpZ1Ljb6Z7nx5aE74Yy3ieVQxBP1u/2BJoOVI7PF87TUJ6teASL+7qY62+2K6ftHnPdr5W4WiSUteLdgJMpuJukgNYCLtPTJExji/9y4ap5R4W4240S4P68JqH+m8Bq89KRrEuUQtSse6PxL5eQn0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this batch of hotfixes, thanks.


The following changes since commit f0caa1d49cc07b30a7e2f104d3853ec6dc1c3cad:

  Merge tag 'hid-for-linus-2026031701' of git://git.kernel.org/pub/scm/linux/kernel/git/hid/hid (2026-03-17 13:55:51 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-03-23-17-56

for you to fetch changes up to 84481e705ab07ed46e56587fe846af194acacafe:

  mm/damon/stat: monitor all System RAM resources (2026-03-23 09:35:05 -0700)

----------------------------------------------------------------
6 hotfixes.  2 are cc:stable.  All are for MM.

All are singletons - please see the changelogs for details.

----------------------------------------------------------------
Lorenzo Stoakes (Oracle) (2):
      mm/rmap: clear vma->anon_vma on error
      mm/zswap: add missing kunmap_local()

Muhammad Usama Anjum (1):
      mailmap: update email address for Muhammad Usama Anjum

SeongJae Park (2):
      mm/damon/core: avoid use of half-online-committed context
      mm/damon/stat: monitor all System RAM resources

Sergey Senozhatsky (1):
      zram: do not slot_free() written-back slots

 .mailmap                      |  1 +
 drivers/block/zram/zram_drv.c | 39 ++++++++++++-------------------
 include/linux/damon.h         |  6 +++++
 mm/damon/core.c               |  8 +++++++
 mm/damon/stat.c               | 53 ++++++++++++++++++++++++++++++++++++++++---
 mm/rmap.c                     |  7 ++++++
 mm/zswap.c                    |  8 ++++++-
 7 files changed, 93 insertions(+), 29 deletions(-)


