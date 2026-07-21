Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12A78C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 08:34:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA23D6B00AE; Tue, 21 Jul 2026 04:34:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E51D96B00B1; Tue, 21 Jul 2026 04:34:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D67EE6B00B3; Tue, 21 Jul 2026 04:34:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A6F766B00AE
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:34:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BDCAD1603FC
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:34:44 +0000 (UTC)
X-FDA: 85012122888.15.05F80F5
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf04.hostedemail.com (Postfix) with ESMTP id 954BF40002
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:34:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Gq8V0Hwv;
	spf=pass (imf04.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784622883;
	b=5UcnEyPutEkI2wKbyUxHewC+sA8Zk6aVe0p/+aGmKePxrM9Rytcgv9oz6tgSp8eCXmyLz0
	QgmcKaZ245KRCD3YrpFXPPQIfx0JlApAU64b1iyse306zA9fZw2i8xZ2k9qoHGInuA0XFP
	c4l9QtoLpbFfHAuRMP/tPD1vnKEXEn8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Gq8V0Hwv;
	spf=pass (imf04.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784622883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VcPnHwDAPib0WA2zAYNLlerlBN1VioKSLdCpPQXRhKM=;
	b=s+ePlwoFhxEH7hFsWrbWF+P3c1ylD+0e/aC/+qCmJy2dJvHvD0jDGR1K3ytzD5iw6zL86K
	+1tBBX9yHWSvmifAenvYpMHaYjfLrsgRorOS1ZwimCRzhZAUKpRsLSMM6efTxw62VhO34m
	oBEX3i0sjP6Q+NcSINzEJwAkLXfWOww=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784622879;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VcPnHwDAPib0WA2zAYNLlerlBN1VioKSLdCpPQXRhKM=;
	b=Gq8V0HwvzzZWAYhs/HRxKDcFJCIaSNFYKya1o4livmsXdbqN/XBqBQkhX/XluYT8pjsLOt
	a34clohM0mE9pwZa+cp3rxPHyCqgpDEtnvCQycbeyw4PvJWO8ku5brz8F9SxGiIgkb0dm8
	tbEQDzp7xHsdj7aZsp26M8YZVeA7E7c=
From: Qi Zheng <qi.zheng@linux.dev>
To: hughd@google.com,
	baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org,
	usama.arif@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 0/2] make unused huge shrinker memcg aware
Date: Tue, 21 Jul 2026 16:34:10 +0800
Message-ID: <cover.1784621804.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 3hbadhywyafg7hwmqcdqihc1hrf8iw4i
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 954BF40002
X-Rspam-User: 
X-HE-Tag: 1784622882-578490
X-HE-Meta: U2FsdGVkX181DU0cdmAnyarKzhrv0kfBpTmPkWRYh5t1n/t3rb4GfAuZw+eyUlLUJIX4AZ217OYUnenfD8OQCBN823ScqbaizjoAkcqzI0NViis8jDJ1WroKYLmMPO+7At6CADJhtHuE+VXFTaSDAQqZt+IMhiltBGOP7XDUvq8MPzO3syHDZhFjD1OuDhs+OvVRU15B1DNSUmmV22js0+EzuolkFDW1eUS3p5TIuRexuhqgIB6h0FbEEksgNRLbXIzbKwxcJdb9F4IniCU5XddFwjeWytkDvZFg1UZqRcgBdCUKO2lgSX3AsZEbMsoTm3hiNG6IGesamoMir5laGbmO+x8MqgL7mbcx1EYBeIJqR1zzNaBFKexMqJdTVCjIW4ZIGr2hJcZr03YRf3/sYDdIPLz/ZsxDiKjKSxnTwm9SVib+8hPSR8XzKK/QafveGzk3mU8NCG6CoKR2I+jyR4NnBSXCgRGPpBMZddU1TuoIIR/38XGoNGyRiRG9gNW8NAkzDjpWr61om2AoGxxCWbEhf+aMvRpkadXT9rf+6hAXM3ZyjJGhyOSES5ewoPzQuodeKt0xMG6jM49rq4wsZbCceNoODOEmmizK1Z1MJ58BieyWEGHZnrpTPutUKtfyP6ZfNlLivj1WXkPUVEwfF9IcuVw/8NR4+xH8SDlPDyNSa9mW8IYGPMk1Q1d2Sr38poBbuFIsQDWKuecLVZQZLJ7az8aZZQnnSd6mC2vZ7a5DI+qDgmOidl2EoLQe7dzQ+crwxaawgh8KAR6QNbj2eLWKUgKjjp6aEWpi7SyF7/up76/2OI5R/0+FQzxwmE5y3BfNlQYLamJdOjLHH4ukSW9lWQy9L8z3T+ycrt1KlxOIWi4pcY+O5j07L1hrByOrwg6V6QdWieaH7R84H7VjC0NeufhFUr7FEUEN3hX8pjHUaVp4sL8JJWxQUCLnJnBHnnw8F+Axjpkf8hswxp+
 pX+KcNaL
 MhlNpOBArpm9qtGWWiokLWTJmpG2IFb6MrQwV5sAkeETLBYS8NbQgE4AaQpFf5acjtg6inEr/nLsRNjv7u4/btADfTpQMuPVkHQkc7m8sATo48BpU8ox+o6BsKYhCBcsbNnY26YNcdchDGGeE1jCRQ0d9RNY8cPN+RkssyPFIVfsKtyaN0boB+XeEbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Changes in v2:
 - temporarily add the dependent patch from Usama to the series for review
   convenience
 - remove shrinklist_scan and shrinklist_isolated from struct shmem_inode_info,
   and re-implement the logic by resuing the same info->shrinklist
   (suggested by Baolin)
 - add more comments (suggested by Andrew)
 - fix missing initialization of info->shrinklist_memcg (pointed by sashiko)
 - rebase onto the next-20260717

Qi Zheng (1):
  mm: shmem: make unused huge shrinker memcg aware

Usama Arif (1):
  fs: push nr_cached_objects memcg gating into individual filesystems

 fs/btrfs/super.c           |  10 +
 fs/super.c                 |  19 +-
 include/linux/memcontrol.h |  21 +++
 include/linux/shmem_fs.h   |  12 +-
 mm/shmem.c                 | 370 ++++++++++++++++++++++++++++---------
 5 files changed, 328 insertions(+), 104 deletions(-)

-- 
2.54.0


