Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01215C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 06:26:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17ECD6B091F; Mon, 17 Aug 2026 02:26:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15C566B0921; Mon, 17 Aug 2026 02:26:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06BB66B0922; Mon, 17 Aug 2026 02:26:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB4A06B091F
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 02:26:53 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6BFA91406CB
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 06:26:53 +0000 (UTC)
X-FDA: 85109778306.15.BE4202B
Received: from mta0.migadu.com (out-113.mta0.migadu.com [91.218.175.113])
	by imf22.hostedemail.com (Postfix) with ESMTP id 22260C000A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 06:26:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LqdowEqv;
	spf=pass (imf22.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.113 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786948011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KEGF23OhMC87+rYOlEfxrm4Wh1VRmmIgHqCzDaAhZFA=;
	b=YiBDgin2R3lylqM1tRGnzv8k6DbZtDJWOBC+Zlr5C7Dv3LdAteLEazDv5vhGYW9Rg6KW5x
	oPvTWMT/D3YuJbriSNmzwxpqrTy0tN0J/TtnKfM0YNI2KjxKOabI3gzS6uBKE0Fa/2yxRV
	kkYlZdCpEqeWxEKn3R0qw3mYqkX+sjA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786948011;
	b=tMkFUhmO8fHjWeb7YIo7K6AjRl3Z0fkLONFIqdi6VkI5DtdE+Pb6Nv6eBQRj03CXWGygI6
	2rf0Xm3fKX0orF0be5nIYcqjTIZRIg0FYrTerOdRALq/b0jRXjz7hNYT88tkDecp/41QQ9
	48tZAYnLaQ3oO6jqnM95lhu63oIJkXs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LqdowEqv;
	spf=pass (imf22.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.113 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=cp1D9oBcDI7MYultp2oPrdx51BLqcKdTzDrSb3vQWvc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786948008; v=1; x=1787552808;
 b=LqdowEqvk3kL1t3sJQuK9rAEPmY6H0EkyU9fVoxPTNAldQHvHShFulplwPdL/RI6xp6cjgeT
 d3zvllnCBZa3vFTSRPHfETNeE/QwBB4SK4/JLonUAieNB/rOi4RW95Sj0iEUO/mjp8iTogkxgWS
 61JeRlzX3ldVZjNb4rMx1L4E=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (116.128.244.169)
	by smtp.migadu.com with ESMTPS id fdcc2f1a69ec06f3;
	Mon, 17 Aug 2026 06:26:48 +0000
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 0/2] alloc_tag: fix a leak and a deadlock around shutdown_mem_profiling()
Date: Mon, 17 Aug 2026 14:27:24 +0800
Message-Id: <20260817062726.106511-1-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: hsfcsabdzide8e56p6j58ppszw3txesn
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 22260C000A
X-HE-Tag: 1786948009-828007
X-HE-Meta: U2FsdGVkX19HiFkzarVEExduMG6VfIdXh6TXyiGnrkc83II0UExNXSCMVwxIfP4dYtE1NrOTGOrQdIx4DtRsRM+3ugLgR05WSfNLqj1qHb4Fii5zPFq8e/aY9vaezi/lEUt+gpTnVZSsrEejRpw0gUp1j78gFaE0HLnEjeAB+vkqq6mK92kxgN54tZuPd1Bf7FSrpCpsu2b3fFpR56cl0tJCiyc3j0Dhd/PpHvhTRoFFoGxIXo2dBEz2SRPo7smJ7hzWxkbeEEg2CJIvNPwuP2Zv5NVKyQj396WIT3htvadmi5i8Er3tkvJ76IMDlwCKsZSVFaUwW++ut9B4fkpQ7p2GoHq7pxXb+aB+8o04EzB8CMTgL/Ge5iB2iZWhzU0iLpf0mJYNbC6sMvXv6/JPSmXOB07otpheZ9LYEgrXXf2wqayNsmgDr47wPRM7GBhOcCLTb8tNVlTbBZnfQ1QyeZJPSCXD7hf+HDGQkaYHOExcv2Se4BejjD5apIH9s+MInmKSV5mb6L5vE4Qy+oB7Yv011JdmOS73+c+jjdIh24AE5Yt7VYYW6vu2AOCm4kfAeFqwAQd4QhmPum3FR8j7d3AZAy3Gc09W4p6iHYAxWcuwk+zthT6SY3OL1hXQSTBBaOos73qRHaaI/CPF5AibDCnEmedvFXWTcHY6xsket8RIv1hMhwGOMWkkdg1ftUN6Rs6slif9AYqa53RIs41OHANXeA3ZrLAY9MscuUFlIVW1O5RnbzocxRwa2kVtNoTqLJYYIvzEw79AGzJ0vNrSzxC0yzgF92qCezLX7gcWWojYybmUXKIxEwsWx7LTu8gih8hs37lRACKgee90fLQwVu30QbOktdjNT2seZk0yIwfRITHBj51oiAr40VKe6TVInP4ycbkB8bDlo5quT5/15qUGK3Crdme7SqnIMsWUIMbxbdTtB2M1Y+hu53Al7H8Zyat3OcwRsTm4u99qnbV
 LEp24x+Y
 OlCkJRz0ynp/KS5iV52w9CRUgsocKo0bQldQC32Cto0qSJQ/RzvXG88PsxzWm+RfxlGSRC4w8VURKBTeLfwXP3FjHr1kTOuQP7U+RGu1/EmFCa2ieV87k92TsSMU8gTug90CXCtRbo22nn0ygVIC/Nz2UMOFuMkWOsugIMYRR77beI366/kOUHE+Yf6aHLWWnP78uVWWFPC5Bbj4MhERSVuJlf4VX9JtGRCjYhiq4A65NSHWrrnF8AP+pQu43Jd4QI6Nmm3ONWl/eRwt4kobuLUc8FID7YJOKrh4+zM3gdDdLH0U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Two fixes for issues reported by sashiko:

  1. percpu counter leak on modules loaded after profiling is disabled.
  2. AB-BA deadlock between module load and /proc/allocinfo readers.

Changes since the RFC [2]:

  - The "move codetag section placement decision to layout_sections()"
    patch is dropped from this series. Its retry path depends on [1],
    so it will be sent as part of that patchset instead.
  - Patch 1 now returns -EOPNOTSUPP instead of introducing
    CODETAG_MODULE_LOAD/CODETAG_MODULE_EXCLUDED defines (suggested by
    Suren).
  - Reported-by tags added.

Patch 1 skips percpu counter allocation when profiling is disabled,
so the module loads without its tags instead of leaking counters.
Patch 2 defers remove_proc_entry() to a workqueue.

[1]: https://lore.kernel.org/all/20260812054105.102637-3-hao.ge@linux.dev/
[2]: https://lore.kernel.org/all/20260813093421.135230-1-hao.ge@linux.dev/

Hao Ge (2):
  alloc_tag: skip percpu counter allocation when profiling is disabled
  alloc_tag: remove /proc/allocinfo outside of mod_lock

 lib/codetag.c  | 10 ++++++++--
 mm/alloc_tag.c | 14 ++++++++++++-
 2 files changed, 21 insertions(+), 3 deletions(-)

--
2.25.1

