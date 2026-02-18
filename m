Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB99AE9A047
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 12:47:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EEAD6B0088; Wed, 18 Feb 2026 07:47:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19CA86B0089; Wed, 18 Feb 2026 07:47:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09B236B008A; Wed, 18 Feb 2026 07:47:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E460C6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 07:47:01 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 811A556064
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 12:47:01 +0000 (UTC)
X-FDA: 84457552242.14.3E86C14
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9134B10000F
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 12:46:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf14.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771418820; a=rsa-sha256;
	cv=none;
	b=DK+5Zk7p3jF9bGhw3XaWWE21FhyXpSyTkO3tF8D4qtoMVXmX0NQeKNUo8VwA7bSJ/j8Ohg
	/jV+rqKtcJlUqC+VG8zwKfqofUQG7W9vN4YDjCjwZcC84bUVe5SMsL2Cy+ffYimEfSMJWy
	STpMmVp3U2ehpHN1cdjdqymhCDR7aU0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf14.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771418820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=bLOcpWT2jrT+LQSjzvFcP7qwYcuPTu2AgkLo1vdkh2A=;
	b=3IAw/FJxZ7O4e0o+/rUxy+4/lLYAKyj1bSTIHC6kqMq3JVWDimS+EiCxem7R853XkmFI3M
	zsdL3YqD1bA8ey//wHusz1DzytovOx2lzxGGFkEETO8qApHNnxN4LFyzfEWZ8wzLlD8/xS
	dQkLIRymjh30xbbTYhfZKwJ56LrBfto=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 18 Feb 2026 21:46:54 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Wed, 18 Feb 2026 21:46:54 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: lsf-pc@lists.linux-foundation.org
Cc: linux-mm@kvack.org, youngjun.park@lge.com, chrisl@kernel.org
Subject: [LSF/MM/BPF TOPIC] Flash Friendly Swap
Message-ID: <aZW0voL4MmnMQlaR@yjaykim-PowerEdge-T330>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: k8iu96f9ujfy7iny3qso7n4iumzrn85s
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9134B10000F
X-HE-Tag: 1771418818-26335
X-HE-Meta: U2FsdGVkX1/4Uau+6VjRaAUDbpIr5vtCEVqfAjffIF6dCefAZhUzR02DgzNFIfxWeKMl1mxMEAZM4URWv4h6k0kA7aQE8UXsAs9U6xurUHjuX4kRr2ExauBE9wdrVjZD2pdMvkBNLiPgLDRI875rQwnAXovvF5cWGQTlKjiU59aFbhLlEG2RXFKoEmVYQrTUjmXXd2+K4ZADvr6lY5+ArMgzw7WLYcCWKeeScXspEly+KkXIoQkL73zsNUQvLPlgD2Jf2z7Z4Hn5v7HDv91jghfhliJl8ck9Uy811sw5KKiYnlZBQhLwjgWEE0Psg7i6bU1TZ3T2brnebi24wsWYxqQ3kuf2bIvu68CbWIwYtc/jVhrE6RppCIN9OkCaz1X3hjKGRh2YK5rp7JDV5RUC5cDepP8TOypD4lSwe5oXJXGizFh4RVPm2CXV0GLyqjaME6bIaSWmi9dcJ4iO4upcyhu83WNxArbyUM2zjIyPi61Gb085j7hoUzm3MiVgioBvTjpYIJNvugVSOkK/nVTS/yikCbw3nlbIr+JAz9Ac3JPPBYw2agtHiRHK2EINoy7iYKkfqXKPd9agzRClxJWKVoVftuOTJ/+IwIlzYaID46sI5Qal2TaUQNbJCm7+MOnHEcJke7E97mvhzbYq4D/9tBhzRwnHzypiXeZx8z1u53ErkzPseJZZKxppb1TRxFYuuOcBXccOY6KZZUVprGQ7sftG01ggrXV8Eq3K8HotwPuZ5RZxGtSINF3Prl71+UEBcveWteSSzYWs8OKFzNyH2m5cxPRk5I8TCYbY93iu74Dm7KP9LzWe/HB/K/C123YIx82UtunD6OPRCdEiixDQLXkRDbgCUa5t0nbLrRGAVOMX1MYCx4k0KQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.027055, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

I would like to propose a session on NAND flash friendly swap layout.
Similar to how F2FS is designed as a flash friendly file system, the
goal is to make the swap subsystem write data to NAND flash devices
in a way that causes less wear.

We have been working on this problem in production embedded systems
and have built an out-of-tree solution with RAM buffering, sequential
writeback, and deduplication. I would like to discuss the upstream
path for these capabilities.

Background & Motivation:

We ship embedded products built on eMMC-based NAND flash and have been
dealing with memory pressure that demands aggressive swapping for years.
The limited P/E cycle endurance of NAND flash makes naive swap usage a
reliability risk -- swap I/O is random, small, and frequent, which is
the worst-case pattern for write amplification. Even with an FTL in the
eMMC controller, random writes from the swap layer still cause
additional WAF through internal garbage collection. Buffering and
reordering writes into sequential streams can complement the FTL and
reduce WAF.

Our team has published prior work on this problem[1], covering
techniques such as compression, RAM buffering with sequential writeback,
and flash-aware block management. Based on that work, we built an
internal solution and are now looking at how to bring these capabilities
upstream.

Current Implementation:

The current implementation is a standalone block device driver between
the swap layer and flash storage:

 1. RAM swap buffer: A kernel thread accumulates swap-out pages and
    flushes them to flash as sequential I/O at controlled intervals.

 2. Management layer: Mapping between swap slots and physical flash
    locations, with wear-aware allocation and writeback scheduling.

 3. Deduplication: Content-hash-based dedup before writing to flash --
    swap workloads often contain many zero-filled or duplicate pages.

This works, but as a standalone block device it sits outside mainline
infrastructure. I am seeking feedback on how to upstream this.

Discussion:

I would like to discuss the following topics:

- Flash friendly swap I/O:

  For flash-backed swap, writing sequentially and respecting erase
  block boundaries can reduce WAF. What could the swap subsystem do
  to better support flash devices?

- Deduplication in the swap layer:

  Swap workloads often contain many zero-filled or duplicate pages.
  Should dedup be a swap-layer feature rather than reimplemented
  per-backend?

- Extending zram/zswap writeback with flash awareness:

  zram supports a backing device (CONFIG_ZRAM_WRITEBACK) for writing
  idle/incompressible pages to persistent storage, and zswap sits in
  front of swap devices with its own writeback path. Could these be
  extended with sequential writeback batching, deduplication, and
  flash-aware allocation? Our implementation buffers swap-out pages
  in RAM before flushing to flash -- this is conceptually similar to
  zswap + writeback, but we found the current writeback path
  insufficient for our needs because it still issues per-page random
  writes without awareness of flash erase block boundaries. I would
  like to discuss what gaps remain and whether extending zswap/zram
  writeback is the right upstream path.

- Swap abstraction layer:

  Recent discussions on reworking the swap subsystem[2][3] aim to
  decouple the swap core from its tight binding to swap offsets and
  block devices. If such a layer materializes, it could provide
  extension points for pluggable swap backends with device-specific
  write strategies. I would like to hear the community's view on
  whether this direction could also serve flash friendly swap needs.

Comments or suggestions are welcome.

[1] https://ieeexplore.ieee.org/document/8662047
[2] https://lwn.net/Articles/932077/
[3] https://lwn.net/Articles/974587/

