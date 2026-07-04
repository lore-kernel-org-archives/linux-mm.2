Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F290C43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 18:11:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBF6A6B00B5; Sat,  4 Jul 2026 14:11:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D97D26B00B6; Sat,  4 Jul 2026 14:11:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAD2E6B00B7; Sat,  4 Jul 2026 14:11:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F2E96B00B5
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 14:11:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 21A981C0D95
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 18:11:47 +0000 (UTC)
X-FDA: 84951887454.19.2E0FD51
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9C2D040003
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 18:11:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="h67Rk/Mg";
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783188705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=02ZrVxmC2Pd3XoWJ6sPqCorhWK9k9abLsU09wkVMoMw=;
	b=CaMt1As1KPsqvjG5gd1HA0Z8Op+qg+XY3SuFgOF34FO25urvEefATrR7nw7Roe8E7vm6/Q
	qdFFfkS/leHdYGILjYMG9ci5D6P4wodWe+mQW62KBCukfgptNwYh0Fv5Q91CsVh9SkoBSq
	lWDJeqD0Vrs9hgpaqmD8e7YwTY49fgo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783188705;
	b=4nFNfKtYnOh6yADEmTrCK3uHy/jguG0a9KxqszsIiHhU0dXjxSzA2HtvKKmS5D3zTS/MP8
	KkWaU/sLSG1tSTBTQoRCo3TnAuqL3KIKZqw1brIaA5ru/sTMgPsMMYjPR3782wZkboU4GW
	jd4avD3tFPWLUocVZVHK7C8m1Vzb3JI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="h67Rk/Mg";
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D97F26001A;
	Sat,  4 Jul 2026 18:11:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E83D1F000E9;
	Sat,  4 Jul 2026 18:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783188704;
	bh=02ZrVxmC2Pd3XoWJ6sPqCorhWK9k9abLsU09wkVMoMw=;
	h=From:To:Cc:Subject:Date;
	b=h67Rk/Mgh6v0/yt1TXHrNCtuEEH5o2qoHegLeGlNDBLYcwN1yd4ORLxymfm+mARqx
	 8ykDCr4OlpJd6nqWIU24jSRypkf/8DAhuE7cpAt4IhaJoNw7Rk6IAqSCqto0o/YPzK
	 ilQIHsXaDAAz3AGYtNgiTqdDBmed4sX7dBr3aqjNz/Z9l0ALUsHPym8r5omHRC9+r9
	 Jxy/Uh/wIAjo+kkEZISKORtKQgrPzB5FhVMewrJrsp7a+OZ6daTIn7q4auBq6o4g+B
	 M1iHWqw35cmU/0UvjjsKswrlVPwmWKw5L6bngXUhUHCfevojFI7sdAyLP+qPeEf1+z
	 zKjfMtIp4T0LA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 00/11] mm/damon: refactor damon_{start,stop,commit}() for simple error handling
Date: Sat,  4 Jul 2026 11:11:23 -0700
Message-ID: <20260704181135.132956-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9C2D040003
X-Stat-Signature: im81ei98xfdg35afbauhabrnramuph36
X-HE-Tag: 1783188705-485024
X-HE-Meta: U2FsdGVkX1+l86ao91yCrM4gQG/QwWTaok51XuQOVYT4yvJmcD4PTJQE6F/6t2hH+SYxDGhAQo85YnNOlIMiztSWP6XP/wa3unFINYJ2tRDi3z6JUPLP2HL0WlurLYJW7FMi8cuaJPgIgvHVMPp6o3DFdcO278vnwSYFUi9qsldP6Ayx15ef0HXQwphs0cfEUXHPOoiTBRnXmkDcRG7DflvXbyIfIRy9atBhTQKPEyHY3rNBQ8w7MnPdktdjlseyvui/P45yrpLMuPe3L29X9Gr+E7DSoRslxGztgj2LYkomT4Jg3ZvcHQv8AWoBEX8v6TVEyzVLnP7dIN//v6mjBETyM9yAtczwN1iPZtiXax7bNvl+u7oscZj3gulFXohyavjDEAzIY71X2C2YYxr+ewgf6Ej3In7kXkVC5Br6aqkPNCtcpn2esk+DXPVIDDZHWoIENz1hbLbRx2aQ+pXeqU0g33//EACeJ1g0uCxLUQLelO2EQqWEvmhCvrkyQlSO8IDnYlMM1RhZy4Ku7ibxRaXGQcwALLXrQ5vFHQ0+8JikW2QcznUrNW5ENMtGSi91Ai6JgK5EWirp1KYh2W6apCECz58UpPfQiw/UKe0+Onxd+gfOBREPNRo9DA1knu7zVV5VAJNjg2e89c+a4qiAwr9cT9K0K2D4AHfQvnosu6crQm2fwiCvVRgkija7XDXC7SEsK0OHcXSzZ96cgysiFW/aTCf/houZgKws83izFUyYoFtHlMtBWnuOXBcinFus+WBXgq9d/V6IQjg0oprAJ0HTxd561ImnCrIRvpCbmVtGQkmYgEBlGwhTRmPBMXftH5OkRsqxKdn5D4mEePEKUJK9SARUdm5KYsmvukSbCWwMf6CWqwqOucG1+PLBbgTFFxlwMoxvGRty9xVtFoYVvaiGA0cUzdd6EA2/ArWJ8yTTkEmIrvEccgY+SpOmktFfGTjaoYuM5Rvl8xk7RwC
 szw6LMxk
 IIcJramrm6jaZB8jit6hv4hliOmzNSvkMuKv2rw6MUn/Oo34+yRv2Onw+RXWDHxcCr4TZsXR4TjYEvAivqPJM+0VUS5krHwZ+gFaz9f2jNxc2pCK7hm7qULV77orCKZBxb4jtXHxXFnhE89e/OFQIwPU0dKTXNQmhjDQvwNNeFGpGBXMpoTpqAbnL89xeHoOVk0IC4x2FtYCiSztMBi+L86T7L0xkWaOBL9NBuR5lOTvgNMmitaPrXFxBFyGxt9eMuv12
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_start() and damon_stop() could leave a few of requested DAMON
contexts running when they return an error.  damon_commit() failure
stops the DAMON context, but in an asynchronous way.  Callers should
stop the left-over DAMON contexts.  It is easy to mistake, and indeed a
few bugs from such mistakes were found and fixed.

Refactor the core API functions to stop all contexts to avoid the
mistakes.  Also remove the unnecessary error handlings from callers.

Patches Sequence
================

Patch 1 refactors damon_start() to ensure all contexts are stopped for
failures.  Patch 2 updates unnecessary damon_start() error handling from
mtier sample module.

Patch 3 refactors damon_stop() to always success.  Patches 4-6 updates
callers (damon_{sysfs,reclaim lru_sort}) to ignore the return value.
Patch 7 update damon_stop() return value to void.  Patch 8 simplifies
damon_stop() error handling in mtier sample module.

Patch 9 refactors damon_call() to stop the context before returning the
error.  Patches 10 and 11 remove unnecessary error handlings from
callers (wsse and prcl sample modules).

SJ Park (11):
  mm/damon/core: stop ctxs in damon_start() before returning an error
  samples/damon/mtier: do not stop first context for damon_start()
    failure
  mm/damon/core: make damon_stop() never fails
  mm/damon/sysfs: ignore damon_stop() return value
  mm/damon/reclaaim: ignore damon_stop() return value
  mm/damon/lru_sort: ignore damon_stop() return value
  mm/damon/core: change damon_stop() return type to void
  samples/damon/mtier: stop all contexts with single damon_stop() call
  mm/damon/core: stop ctx in damon_call() before reruning an error
  samples/damon/wsse: do not stop ctx for damon_call() failure
  samples/damon/prcl: do not stop DAMON for damon_call() failure

 include/linux/damon.h |  2 +-
 mm/damon/core.c       | 37 ++++++++++++++++++-------------------
 mm/damon/lru_sort.c   |  6 ++++--
 mm/damon/reclaim.c    |  6 ++++--
 mm/damon/sysfs.c      |  3 ++-
 samples/damon/mtier.c |  5 +----
 samples/damon/prcl.c  |  4 +---
 samples/damon/wsse.c  |  4 +---
 8 files changed, 32 insertions(+), 35 deletions(-)


base-commit: 39f9f608b1858e65db6d2766d692a7a700b1e0fb
-- 
2.47.3

