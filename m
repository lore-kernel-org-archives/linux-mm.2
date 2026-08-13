Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30D52C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 09:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A6686B0451; Thu, 13 Aug 2026 05:34:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07D876B0453; Thu, 13 Aug 2026 05:34:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFC766B0454; Thu, 13 Aug 2026 05:34:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CD5DC6B0451
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:34:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 44725A0576
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:34:01 +0000 (UTC)
X-FDA: 85095734682.30.2705DC4
Received: from mta1.migadu.com (out-79.mta1.migadu.com [95.215.58.79])
	by imf08.hostedemail.com (Postfix) with ESMTP id 342BD160005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:33:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IQBImNWf;
	spf=pass (imf08.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.79 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786613639;
	b=2ct0WloHZ6I/zb69uDGwt3SJ23pV8NnTXlI5+g9Aqrjav6TcmaTjApZZ4X/As4Bmlif5yh
	VUpix+hDb2LIMKb1mMTJ1jZRoLbV7eTm7D2z6k0ormaOLy2DADb2+9EApKVjFyTwPjwIXX
	fgicN1wii9FGbTwcFazaLlnZF9keJ50=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IQBImNWf;
	spf=pass (imf08.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.79 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786613639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jbeL0yZV4d2yk/cFMH+83VIDFSU4IYUWXkn8/E9G91Q=;
	b=IRVjq9Ep9+6zk6HVrjf9AMC0L5F1c2DmnUQoPts+4bQmtuX5SOv7knSkMUQMqoqSMmfsI9
	8OvAvpUpArQXVbUwKnq9T7WUPaoSK1cs62gFr1l1o8twoS5nA+H+ND1Qgeo0n3HG9us2Qh
	takammR8FaH3T7e9dn0ve+kZ0aGK554=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=jNvhERYY3D7nKb/kjhXp0MERCjoO21xs9MSBXRaSNT4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786613637; v=1; x=1787218437;
 b=IQBImNWfFr6ozuuVC2ZVgZzs39gEF6LO5Pa1yKmx0U5xflvPbRiUUhbHwRxvc5M6xpbBgztM
 5wUNWYEBqtHQofMPfJWx7PheiAtro/za6ktpgOlfYajbEDIABM9xzQURdCdPZG8gVBUhfwDiILq
 ad7r9XQXZZBDSkxiZROm2B/E=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (116.128.244.169)
	by smtp.migadu.com with ESMTPS id a0f3be38e7db4446;
	Thu, 13 Aug 2026 09:33:57 +0000
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>
Cc: linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Hao Ge <hao.ge@linux.dev>
Subject: [RFC PATCH 0/3] alloc_tag: fix races and a leak around shutdown_mem_profiling()
Date: Thu, 13 Aug 2026 17:34:18 +0800
Message-Id: <20260813093421.135230-1-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 342BD160005
X-Rspam-User: 
X-Stat-Signature: m38rg4rertg64g6b43m7gtyhc89ri6z4
X-Rspamd-Server: rspam06
X-HE-Tag: 1786613638-882305
X-HE-Meta: U2FsdGVkX18zhH3MJMRMCLSTGT5B9CR2/S/k7+e8X44tArK22+kTRN4AFGqsFiFMx/FnrTKx67K56UNpTLOV+Z1YHAQcnV7yiZJtiZLbwHPfT2EoBMUIw45o84LfioxJGi3Sz/DOiZWv8mADEQob1Z6SB66upqcoFVMRFP8waYaoYL3cZ5XeVNWYJeE73M1O9Rj6Jn2U1goEVPCFlKRznVxrMwHByj+UWgVuI6cc20xwfNyAdV3V8Fz1w3qCVwFMxJmkD8j5VRpM5DjgHg9/GYuPiSej7VzwdMH/uZ70aYQxd63KzH/D5DLm/1dF3Zu0jDfaa7f/d3KqBfXvX2K0imusnIGFqt9Ui05tVYPGiLRYz66Nd9pZminPg4R8MC6xy4VR/o3omQcprruywU5NFVs7YKEuc6/o6oiwMPu3FADP4Mc5cr0JMeFBrgvaWqqAms2eC+4jd7kOZiHcFKnJQ7ht/0G01oUp8fqAAJOwDLP8tUNWN2SbP7DQr0tCcrQh38m9h+mZlewokeuKn9QOsDDbziAF1dK3SZ4kgFc9Rsyz5RTPKM5VnCYaWhrblrDV7rMZ6ZbEf5m0grPG/IRo7DObsp2BQMti35WQZ6UGIvaedSSImhLT2OPX1AE8Eiq4GsGFyR1BZnadhXKfuxFLFLPbJliSqm2E/AlCZm+fYQPsI1mjirrUPEsp8fPuMSCLv/Jns11mxuFDfc4Ad1FYMeiprF+dpeUUqKsZh5vqa89pMTYy9xRsJypLW4CHjZs59Cw0ToD1p2qVVC9GI9SEkeM2T9kJoU+djaIt2HNZvxKOLHCNnZaoDcdj6VgXnmdCXjQQ2vyQ55pIg8EV3Z885SKJ2gxZt88TR9cOpMCr2YEblZphTPemNGIYpscy1k9l0Ri/gpvQFvnwr6Q6HenC7QzZ5bQEu4s2CmE7EBx/vOEI50iLCqcXIxoEn3d4ElxHN3plF1YKjdK0xm22jB6
 zkhAlQ1Y
 rkHzle1QZwaOFCn2r1Y/XfjdGXOZS9j9PlFvFdA5B2dxEwBXMqFjCZLCE+lt2kRPAYXlrycZFZCXqza1eZGopKclxiziicSr0/VOCSlNvTj56INDFfCMR9RA/lg2Qxgf53Shbg32KkEh/ZOrxoq+SsOKLvo1MTbVAwdxNzv15xbsSuzRVHjNbonPIv/SC89eB477p9GcM4KrYnhJJc7d+U0oEn0eyVxVu+XLimVOSm1bFVW7G9JWjIxl7Mds0kbq92qKtDcJX133uvX1vqmuTYWxLIdr+aq5eKmaBRLK12x8P+DU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Three fixes for races and a leak in how allocation profiling meets the
module loader, reported by sashiko.

  1. percpu counter leak on modules loaded after profiling is disabled.
  2. layout/move TOCTOU that can silently overwrite module memory when
     profiling disabled between layout_sections() and move_module().
     Additionally, the retry logic here depends on [1].
  3. AB-BA deadlock between module load and /proc/allocinfo readers.

Patch 1 adds CODETAG_MODULE_EXCLUDED so profiling-disabled modules are
dropped from the tag list instead of half-registered, and frees the
section reservation unconditionally on unload. Patch 2 makes
layout_sections() the sole authority for codetag placement. Patch 3
defers remove_proc_entry() to a workqueue.

Feedback and suggestions are warmly welcomed; I would greatly appreciate
any input.

Remaining sashiko-reported bugs will be fixed in follow-up patches.

[1]: https://lore.kernel.org/all/20260812054105.102637-3-hao.ge@linux.dev/

Hao Ge (3):
  alloc_tag: skip percpu counter allocation when profiling is disabled
  module: move codetag section placement decision to layout_sections()
  alloc_tag: remove /proc/allocinfo outside of mod_lock

 include/linux/codetag.h |  4 ++++
 include/linux/module.h  | 11 +++++++++++
 kernel/module/main.c    | 17 ++++++-----------
 lib/codetag.c           |  8 +++++---
 mm/alloc_tag.c          | 25 ++++++++++++++++++++++---
 5 files changed, 48 insertions(+), 17 deletions(-)

-- 
2.25.1


