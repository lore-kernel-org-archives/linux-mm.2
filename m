Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35D1CC982CC
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 16:11:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07B1A6B0092; Wed, 16 Sep 2026 12:11:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 029D26B0093; Wed, 16 Sep 2026 12:11:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB24B6B0095; Wed, 16 Sep 2026 12:11:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C82226B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:11:24 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3F807C07AA
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 16:11:24 +0000 (UTC)
X-FDA: 85220115288.20.E9A6B2C
Received: from out-2z4y-a134.jellyfish.systems (out-2z4y-a134.jellyfish.systems [198.54.127.134])
	by imf09.hostedemail.com (Postfix) with ESMTP id 58B68140004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 16:11:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=mGG6lVB8;
	spf=pass (imf09.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.134 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=pass (policy=none) header.from=tychen.cc
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789575082;
	b=NYAvv3EvK/ETxPO15CvQxNKol7rd9UW/77+8BLPmo3mHpYM1enSdOCzbpTaKKZNR7DNbml
	PP5FNT+56sCKUazB79hTeFAKYDz3SWpJjITdGiubOVrmi2dNkqYyqmuFPLSmKMWlKRXqqD
	asNx0eInNX4c8C/dNETvFpGvqZwSu4k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=mGG6lVB8;
	spf=pass (imf09.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.134 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=pass (policy=none) header.from=tychen.cc
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789575082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SmXuwsjaElzcBy3cwomr2oW9QZmnugnFOvebRFqKdOo=;
	b=Kf8GGSyqEep1JjQUZ/BVL/rS8cSDHopfv80N1A2HRzCC4uc/U9teGfZn0rWRJs0D376leX
	p7L/R6i0rUcRAQji9FmNwXWczpFbSAxN9rMP8q/0vdWrA0oGX0H13rOU9aCEMCBBEqhED7
	DjlX4DhlP78EB3tziljVxyek51EcqT4=
Received: from fedora (unknown [117.147.120.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hlP5J2g0yz8sWt;
	Wed, 16 Sep 2026 16:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1789575077;
	bh=SmXuwsjaElzcBy3cwomr2oW9QZmnugnFOvebRFqKdOo=;
	h=From:To:Cc:Subject:Date:From;
	b=mGG6lVB8NxNSGeDC9BFk5vYiA6hVgh+GAkJbwKCzfEryrBGLW6ZcgE9AbEw3DGz9o
	 zSNr9+clF1LJL561yjk4vHMQPTGsNR45DwhXDk8fuKY5ZjMGV0JSYIHEvlwmFPaqKK
	 1YzYoCkvAPBbzcAfIQQK4caKuTYi2ibY5P94QIHI06sz8kRiHxrgBE5v+7Nhzass7D
	 H97Raxv87Ue5N3QzbzwkaK23VOI21XWKYJR+Z7XocnwU6EqMGdedo3cgzusmISw/QW
	 GZJTHO2A9OPajZOlKB7NQim/aubERJJjCTOn0sRY+ps9GjJRFaFioYHOtK1LdipRzC
	 8miYGIVWQktMQ==
From: Tianyi Chen <hi@tychen.cc>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] memblock tests: fix BUILD=32 address conversions
Date: Thu, 17 Sep 2026 00:11:03 +0800
Message-ID: <20260916161105.2548281-1-hi@tychen.cc>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: hi@tychen.cc
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 58B68140004
X-Stat-Signature: 1arpeatd6memkry6okque4tkfrjq5n9j
X-Rspam-User: 
X-HE-Tag: 1789575082-535062
X-HE-Meta: U2FsdGVkX1/yjxm5KUumD7OVvtuz1f2JbX+ZWt6ToLysp9iUngfAIHDYSIZ0G9E/9SB7XCI8Aqiyr8DNnVtzyIyrvT6a3M5CLyq0Pol33+f5+pbO4JreWjpPgkahbKr/r0zfC8f/fUojhJgKUEXbAZEF6w/6tjM4yTmJRMKJmb6Mhd5aCagosk6mpAYjU4OcdCfcI8yzYcYHm8Dv+c9ou2J8eCq4V21Cq7tHNExZc0x5WjxR8OzVmUO7cjCltzUzBNHNcwwtIM//6n1CPMHGKvom5HV5+qknUsAFxoJIB/M0f+/eMB8PysWWx6mpzyGy1EZxf4m5nCa0fRdr+RQ90rrT4oQyqfhgSchRaAXTQqvFLmZso8klV6UGGQexyLWcbQiplAIsA58s4LKRxBN5Xvp6mGo/JbzlVNQrNzQwUCYFBZnRjBVGV1ysaRXsxFPXNkaB90HlBmZ8yrfAhWJYb80ktv5+cBufAe+xZv7OhJlsjUXnWCb9a3okTQJTSAg8w9zfsaMpwmL4XDsfj85VE1bFffQfOL2Yn7b5Yjuq3kX4m4j6VKTxHy21qP7tmUsnonMDVwg7KY/jfsDfh4QhhX1YAJs7pl2Za8Pg5ycpso53W2b8h4l9x2v+EQE1v94pAGHlrFGaQdonRJB4/8utq38rqd4NsIn+ntyBGNr8CickZ5UpPJZ45eVBoEbiNsDpfztze+OIICKDxJVgLa3xZBVr/K2CmeLBsbwvCKztjKCsAoaFruvzEGgHtoJMg6sk0pmoA33PXeOv68AOHOLuu+3vEt/P0o8JQPrXmchV1Y7AqGhIeP0LYlIqUNNSkAmXns7sTTjzj96N2klJL2BoQ6ugsJKSrOb9zT74jwDVCTvBDW4d3pu9y4pyKRvZOt4DQ0R7HKGhtj2aI8Cs77hYeYo5O888dgRkLYTWQNXi72pPP3GWNE2bQ8k6ivO83VXFTEVI704ag9ELbUR9kF3
 +cYBCQ5q
 k7b5z3ICC2RRG/IU/zk89+TaLRvaSgQ7cpfSpYUisHZ8XwyYsb9dTpV6+KZ+Of/zxN8zVD8wFlvSFsM2v+zZSrpyMmhp9LVWJixg/B4u2qiUWRwG+GM1mkszLsyRPvEbqXRkNA69quzL8PFCAQr659NfzRJc/lRnVjWbcjOR0WQpa51iRx5SbQ7vyiFWh/Fo7v6UdhIRgYDXM5P3Lced4/gZEDZ6AeEb8r6+TlPc+lOK159fDBatysQPMFNszIEvi1Arwxv4QpVZxEDRvmm0YPth3+ILOjRa6HqxjCcwIsHtuxlYy70Ue/bQdZuHe6VpjDhWZWEIYKXUVAroLvPnhkdl4omJBLOVeJ19+syIvsp8mtUc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix two BUILD=32 failures: truncating a physical address before freeing
it, and sign-extending simulated memory addresses. Existing assertions
cover both regressions.

The runner passes with GCC in both allocation directions across 32-bit
builds, 32-bit phys_addr_t, and NUMA configurations. BUILD=32 NUMA=1 also
passes with Clang.

Tianyi Chen (2):
  memblock tests: use physical free for the maximum-address check
  memblock tests: zero-extend simulated memory addresses

 tools/testing/memblock/tests/basic_api.c | 6 +++---
 tools/testing/memblock/tests/common.c    | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)


base-commit: 5728d3523f12826a2b180c1c5738f74e33197e14
-- 
2.55.0


