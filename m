Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 897D5C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 16:01:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73BDB6B00A0; Sun,  5 Jul 2026 12:01:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ECEB6B00AA; Sun,  5 Jul 2026 12:01:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DBB56B00A9; Sun,  5 Jul 2026 12:01:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 380C36B009E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 12:01:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A349E8ABB6
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:01:54 +0000 (UTC)
X-FDA: 84955188948.24.2D93025
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 07C7AA0016
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:01:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SR0lMN6f;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783267313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1W0z3ibNTBH982L2YdX0/4RM6hemskh9KnNpifQK0MI=;
	b=S8/1e9o33AyNXSzS/evqcUZF6jRuG8XVVVNoIH7e86itBYz6Z7h78nz0P8kOl1TGFWIVLP
	DFqD/PbJYoQglbKPskYXl3BTXjIAfIintnEkG08nD56nsLwsWE6bbz407Q2vC0aanJEZn5
	mZDYJdSN/+1+biYB/OEj/tTw5HZVUT0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SR0lMN6f;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783267313;
	b=JoKwbBUasF/NzS0NA56EWBbeSvCtyLJTCj1ZwmWhwv8DgzyuHDpSExEBG4PhsVQm0kXWtd
	90ogzGZOfD206XcxiHI8XRbTuiaenpZWD7Kdu0jMQyJSprR7l4a++8apAD+rmRxgU1iO+s
	fbng/QBCHEsFoOJI35nJoHHJfMwAxcU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4ED8840B6F;
	Sun,  5 Jul 2026 16:01:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A951F000E9;
	Sun,  5 Jul 2026 16:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783267312;
	bh=1W0z3ibNTBH982L2YdX0/4RM6hemskh9KnNpifQK0MI=;
	h=From:To:Cc:Subject:Date;
	b=SR0lMN6flT0EFxpBZ+36fDvNVXyyKnZiHs1cFMhGevOEAQItisttVNkv+hCDi2sB1
	 1QIKMFuyhQCnDomigvHYhGY/9qB6ZLJPb28KnkILt/bPc28v4Kq0i0QKZ+S5gVvavV
	 DNbi0/qjtRSoEUxKgNkf16iiSDv9SZSlHkmD8IlOwm79itg2LlUn+GuNg0HBwzNRju
	 HfyGNkPOqXrpR1K2RGRJPCEYqGDUjFPI6Jz5TtRZcgRHg1NhcwZKcj4QQyVs89hcKs
	 YukTjrc8/izh557fMzIcOtwC16xblaHyQMY7god6HFUBodM3PajgMha8AXoA+NQrFT
	 6b6fvUeVlkgqw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 00/11] mm/damon: refactor damon_{start,stop,commit}() for simple error handling
Date: Sun,  5 Jul 2026 09:01:27 -0700
Message-ID: <20260705160142.97308-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 07C7AA0016
X-Stat-Signature: 9bk691qr93kfzabxtrdiy4j1811u5wad
X-HE-Tag: 1783267312-571924
X-HE-Meta: U2FsdGVkX1875slFeYl9CEgGfM92RhxPm9g35JBT89FF12kvmadYvilFzLjW1Uh/hFY+YS/j+pJ8WC4cc+lg1/k86dBwEHNlmmQkpLHCET1Sbm5Q1vFy0iWEsmPAoBjzCavL5nEFR+T/AvfVRavnVcsfigkvzkMjw2CHpDOWLzvgNfNA49wjsOz8GMZv4GL52UfFlAmV9Vha4H2BfstPeASkTi3TCMZOIWpLE88jSG0ByH/GIHQlujskIHhfwPI9zVBeACPrhl0mDZ+WufIXP/l2N2h+35Rf5JXh9ho8B0vfFAHP1cAJqO7/Ho5aDWQKoxeYtUy9fmSSIs2KQhJCboa8GvxB36svs9it2OMDRb1Gh6LOc6b7kD37LuWBz7Pt+zvse5UlkHYQjvmB5pRrutT3OdH51y6UpoE6xlcj8aXCFjM4Evas0r5mb84Jz+ZzEDnRrrRUQeKTYTARC9bwkQYKnAT+Nb9cxsU7sSzNkBeZliEO2hCdikQQz39u8qybbemVcgCJ8CeX1ALTdT7bEQ8UY/ARXqv1iljk39ZYCHHfCgM4CKfL84ASyVPpfmtdFfK+kX/L+rwR9XOaDiNasZDP/KettwgODjj/PdtcIXM+3xLui/+Kw+IurSz3zgNZNlu9QlYuLE/zN2ycU8tF7DdllPUIen7P0Om/ECKTtWJRlFakXn+k4ADBbEbUIqS57prO3qVHLsfA69Sfo24/ttZ/FSt+WvadYXkP3jruRObo5uQmO3IYVM4CpfYzeqJpFIAvTObENTY1L5cLU/Yne1lpAVag3bU6HvOTFM5OLrz0hBj6/4hcLnQdEIOgwDeN/PJN5OYz0d0uGOHPLC2kIJzK9g7OtqxYG0LOqFW+VR1cKcnGBn761nZtmklxTeOgQPrtcq/Uoxk6Cc5JsarXMxZhp/nyZ+8gO3gWB9ByI4O7Njz/Uaq3+XKhNF/nXXi9iMOgjnPeZwtV56xnXoM
 VYgg6H6z
 OngWjOcEkVBcuTB0lPsTK7mVBYk3V6RH7/9BbzL/2vdH707SAv6XPhvf85sLDS2EjIE3CUZmZAjjcf9aNDZ+BHUJ2wittiJcmxMbD7V+OjJc/vcBfdaY2edZM0f+2EG9okyWYiLgmX7g8L/8gLrQD1WXp2kOTHNsTAAT2WP1Mu0/TlkR8lteppOdSB9Yay3m9dP9sfbkQb51nAc59u0WMx18U3jPJLxtJ1D82W3b605bqexZcBtBinYTjV2tVCyoUkGg9a6wVSGuOlw00K9e+9qYu1Q==
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


base-commit: abe5b65a9c676375c3f118d453037f2f9ebbb7ac
-- 
2.47.3

