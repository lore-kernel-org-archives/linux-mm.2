Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A05DEC44500
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 14:06:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA25A6B00BB; Mon,  6 Jul 2026 10:06:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A17B6B00C0; Mon,  6 Jul 2026 10:06:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 888426B00C0; Mon,  6 Jul 2026 10:06:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F84E6B00BD
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:06:41 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DC652168A74
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:06:40 +0000 (UTC)
X-FDA: 84958527360.15.A30FBB3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4E83612000D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:06:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ES6uY66a;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783346799;
	b=PE3D1OEOeSEdg6Xw0BLWuAcykY/2w/knSL5kcdP9DKbd2sCGFzczrp47n80o2iMtFQQ+1X
	5wE86RtY8WUO5Gth1Uzzxb8+7KzejYa+zjXbuGKUSWHYZRk2kpByY1WksZdfqAXQvpyDb6
	jDYjBtMhFnMavR6+1Z9Z1r5aVsI+O78=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ES6uY66a;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783346799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YScqbvC2FcRD4fWbOctqhEtUzflD1TaDoeycdSdZYxo=;
	b=b4f+iDcp9WjCKyqdoi5NQOpjp5fRaNn7CR1DiWDoRiUbAI7SjZKTTYNJ4FXUu0FWamUXq0
	zgvdy6gtVauOZlHh/fZ8gL3kCVuZZB/Ji9MHUecczfREXk9h+hmc6ynJ/6Mwy2UOAnDQ29
	CQ/pvKdl6BwApUsDr48pAd3w3il6nGs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 273E541895;
	Mon,  6 Jul 2026 14:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88CC1F000E9;
	Mon,  6 Jul 2026 14:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783346798;
	bh=YScqbvC2FcRD4fWbOctqhEtUzflD1TaDoeycdSdZYxo=;
	h=From:To:Cc:Subject:Date;
	b=ES6uY66a/NoD6rtnEolVYYmqIPRmWM/XsrPcOny8u7cLT0mTMvEIEFk0WkipninKv
	 elwfwCzrzdFI+2C+VrhaWJf+m+zywyPo8PTCkKU6FhnRCysQ2YvdxY3VN/F8DPFY1O
	 v21tWpLhregnoQU5P9BInKlC5/1w7/H8O4T26pN97PCXTsLs+WfPRa4uGGPKTUZT35
	 LYDQtUr6wSSrguuiOBcNO2PunxUAlVVNAW4Vx260C0lhcjgmykujl5iiYNcJQ3lAof
	 3C7oisLt++4LFHNi1zJeQnWqXipuMUCQp5jKRH8eAwSDpy7Hs87OQ6LYY2wAZA+i1J
	 Cc0zLvcZhmdJw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 00/11] mm/damon: refactor damon_{start,stop,commit}() for simple error handling
Date: Mon,  6 Jul 2026 07:06:15 -0700
Message-ID: <20260706140628.87414-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4E83612000D
X-Rspam-User: 
X-Stat-Signature: wcnccrpykyhgzbjsctnbu5zehbanjqmg
X-Rspamd-Server: rspam03
X-HE-Tag: 1783346799-96113
X-HE-Meta: U2FsdGVkX1/GBpjOfFZk9+OgtKmdfFvlbaGwj4WuC5I76PAlF1KN5GNnfFrcX3L/Re6j6kd1s3QxaLEddVR3p8WBF92xzm4i5XBQJO8dE2HI4alG2z4HukRxl2vvnXUnOa799wkPspgQVOBOxptaiF9NO/64Xr/hPavu2SyDTddcsmfUdM6/KpOHEeHz2ht/eP4QjEKXr7oeMg9MrYoGq952ZujusXDy4w5oi7tuQGC5DpuY8Mf9x0RQKDFlq9kmX8h57RfdFDgp9I8kJt6gHeLu+HaYE5V49QwSMHxg+zJlo6MfkIr2rLf+GYdg0NaSo+yt/yLekG/sKSTEAMjl+tlddY2fXgwen3KOgpImFfh1js6l3c9RlAj4ODXcGYA3f76fcvDW2EBF/yzlmACwyJj1WqAl+j9gdZNE7xP8UsPfZ16s8nSk7u48DBjy3L1WzUoaGc5ErXHimEFgEpK4ZH/6dY/9pkht3EDWraYLShH1DYx1XboqxAoOJXGTGGWM25g2bt+VlRNLQ1SMmD8ywXcVD4nTqpfEJ10pwBm99Sq/dYm9OtFjjzWXLvyPzlhjhm2m/LidDFmfqIPT2PvBKHRkZ2/+HSUHUVGA7w2/U3hkOf1ZWIpCGir3ZspKSXfDIq14vTrPwG8rKRifXUVd/rP7qHtpKOJYzx3bLlrPIgAB0P+rvssqVVcFGjuH4/Blg4EW7Lvzb2MBPqklUP4vO7B+7cFQwke0dvYvuwg6mwkdWpUHhC/NDVCDupFLkeu8fyF51OfKanya1YBttp31rGnWsHqVzh44M1XhyxLYYjgf4H3PeA7XPvsAP9GYNCl+WdPIV8z6752RiXb0XRepYgskBGJC1/TB6ijJRlCZFuPr+RQruMsDIytaaYozAqDVQJ1ArojhCzcOlerRFi2grO8auC7zTaynjo5tm2su9jYDY8pLsXcuTAcX6nIiEBW560mGP371G0AnuLTxWfk
 prgj7z9O
 7TgRxq4zbO2pM0d+9rXuFr6fmzhYiv3p8dbfuu+X1UaxQ6GoaISs1wwQ3tpw4EujBwMlEYWSLlZB5XIdrb0z9DX3FM0Ell/SOjRo3lsBczndwm9YGZurFMmHnlOBXbFt4ovMVXgnQ002rWs5hPVkqhFwEVR4cX1LXz+I+BWI6mB7QgDkBLcsDc8GYl4JQosmKsMp+g6lCJ78aQMps7zQAZZJFThYbAm7zIDlyWV4uxETGgjcuxUFGhPXYPnFGUd7P0rfnC2s3Qpd9xrqtvNQu8HqgWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_start() and damon_stop() could leave a few of requested DAMON
contexts running when they return an error.  damon_commit() failure
stops the DAMON context, but in an asynchronous way.  Callers should
stop the left-over DAMON contexts.  It is easy to make mistakes, and
indeed a few bugs from such mistakes were found and fixed.

Refactor the core API functions to guarantee contexts are completely
stopped under failures.  Remove the caller side error handlers that are
no longer needed due to the refactoring.

Patches Sequence
================

Patch 1 refactors damon_start() to ensure all contexts are stopped for
failures.  Patch 2 updates unnecessary damon_start() error handling from
mtier sample module.

Patch 3 refactors damon_stop() to always success.  Patches 4-6 updates
callers (damon_{sysfs,reclaim lru_sort}) to ignore the return value.
Patch 7 update damon_stop() return value to void.  Patch 8 simplifies
damon_stop() error handling in mtier sample module.

Patch 9 refactors damon_call() to return errors only after the context
is completely stopped.  Patches 10 and 11 remove unnecessary error
handlings from callers (wsse and prcl sample modules).

Changelog
=========

Changes from RFC v1.1
- RFC v1.1: https://lore.kernel.org/20260705160142.97308-1-sj@kernel.org
- Drop RFC tag.
- Rebase to latest mm-new.
Changes from RFC v1
- RFC v1: https://lore.kernel.org/20260704181135.132956-1-sj@kernel.org
- Fix ABBA deadlock in damon_start().
- Wait instead of doing racy-stop in damon_call().

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
  mm/damon/core: wait ctx stop in damon_call() before reruning an error
  samples/damon/wsse: do not stop ctx for damon_call() failure
  samples/damon/prcl: do not stop DAMON for damon_call() failure

 include/linux/damon.h |  2 +-
 mm/damon/core.c       | 37 +++++++++++++++++++------------------
 mm/damon/lru_sort.c   |  6 ++++--
 mm/damon/reclaim.c    |  6 ++++--
 mm/damon/sysfs.c      |  3 ++-
 samples/damon/mtier.c |  5 +----
 samples/damon/prcl.c  |  4 +---
 samples/damon/wsse.c  |  4 +---
 8 files changed, 33 insertions(+), 34 deletions(-)


base-commit: 3fc9ce1db037091d433cb95dff0ce1cb6815fffe
-- 
2.47.3

