Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 557C2C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 06:52:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 648186B00B2; Thu,  3 Sep 2026 02:52:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F8DC6B00B4; Thu,  3 Sep 2026 02:52:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50ED66B00B6; Thu,  3 Sep 2026 02:52:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C06F6B00B2
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:52:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AEFAE1A0466
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:52:44 +0000 (UTC)
X-FDA: 85171533048.03.FE0EC2A
Received: from lgeamrelo11.lge.com (lgeamrelo11.lge.com [156.147.23.51])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2226340003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:52:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf17.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.51 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788418363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BV9lQvyQ6mc9JuYo7Xg7JhqUHv0ycc10mkukFTBraf4=;
	b=l2mA0zPT/Ev+Auz01Xbywk8gbbeohtVlyALZXRxNiLVdJz9rt1Ro0Deptspm1yDngwbPlQ
	f0YGlOQFctjCr7WgbPI0wi2OYfBYZuruSLJ/+fb9pEHsiPBDMqcw+14Arsnzb7/nIjg2gD
	Ec0CWJBhM59kjCaIFYQrGYEv/hkXmzk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788418363;
	b=Jh9/NsTIzQPbhJSBpegFhT2Uoooi4JGj1p94ZCte8HQPr0utd/I8uGZrUb17cqX2L3PJOX
	1d4+rR2sa/5nZ/M2plPLxEb664Ii6Am14NKdJW75DwCbN6rvs/+0sseUavmT+3Zvtt2m8S
	3WZXbRlccHwVPuinKUB3sKsdQWbLIlU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf17.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.51 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO lgemrelse6q.lge.com) (156.147.1.121)
	by 156.147.23.51 with ESMTP; 3 Sep 2026 15:52:37 +0900
X-Original-SENDERIP: 156.147.1.121
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.121 with ESMTP; 3 Sep 2026 15:52:37 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 3 Sep 2026 15:52:36 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, nphamcs@gmail.com, baohua@kernel.org,
	hannes@cmpxchg.org, yosry@kernel.org, shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev, baoquan.he@linux.dev, david@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/16] mm, swap: require zswap for xswap devices
Message-ID: <apkZNEe8/YAwygbA@yjaykim-PowerEdge-T330>
References: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
 <20260827094509.1016740-16-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827094509.1016740-16-hebaoquan@kylinos.cn>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2226340003
X-Stat-Signature: nu7fxs8z5btsgne63otm8xnhw4bgrxb9
X-Rspam-User: 
X-HE-Tag: 1788418361-579615
X-HE-Meta: U2FsdGVkX1+1rOesm+ZmMNESVs3Nwq4qREJ/b6DRAAuyKGzlOlCEHiThYBGfKpGWVnGFeJNdX8AJkWBdhlo2LoOjgPQX/iS2n9tHN/fmN6/yXQI5wbliWPp9nMuoABdaQ1IOLc9SIYKhlnwe52D6NTBYL3TtoyEAavtU9Ml9lFBjhgyJw2GgIAppuN2E6BNFM9UoJtihFaO03VMbfbQkZt+rEVQzHLbREwrx5o/UutTGKVPmmCWws+MnpfESfCZDtAokFw5jojGF5YIHoQrU6xORSf9c7Cmt/SAl6le/M9tU+95hHzOFJVDRRiUA3+Qb7gHU23s/g5mzdB1fssLJimibbFk31POXpWvv+OCl6vzzztkHKvEUl1PLgC7bOFNq96Qivru9Q44a2wwusan63rnCNQ689NYlx2Q8dZNETvuPdIo/pT1Fo8nicFkrvK7So0cAta4O3l/2uJweE8EhjFBMCZjvraNFIioCX7fpKe2l3NqOBvgbAfvg44nqKUD60nqEOGfzyl7OksWsrvvk4P/a+D5WAOOIpWN+0qTg6UHGzBNZKMAcD8aARoj2Ohi4H13hWZ3NMqlKbeubxgWlG9cpGc+7RLTVRpY3L4+xT8aJMbfOzPRn0jmAUevF27q9MZNJkPeyZiZOe70jxDpyZV2UceDcmvr7OK8Kv9Abqn019UqWy0fflOBdgnm4q48Eeg2fy6UZFNrPgQE88LAPYvp06HCYnN6qUonAoZ9G+U4u2mKcjM6sxYm4rFiG2smjETiSMXN1i4tfk7bnemt+yFY/q7EB8uTK+DEoaDkEcK0PMCRygz57yxEQ/740kmFhHYyt6/8/fLy6bcJRPBeenEYx6940vo0PrxniQRR7V15Vnv2Uynh+gHu+rcLYKzNhk8HUujC9V70ApXeWBHnX2HPtlLr/AC1WxkgkUh8vswLoBC2IKSDbhpTvmYuh+PmY62FnGhuIduzHErvZGEn
 qrSyyjGL
 N0BEpZNfzHm7uhjrIxA5/OE923vez59BOTOe3sqMeUmDfB6z3yEUePSig8UxKUCcxVPVD/7jAZsPIpLKKdNrmswXmkQCmEMmpmCN2vtkeY9/7AoGuNCRMHG32yDNfi0Xkhfx8xNMJkkZZPN/aqPC/a03R7sSv+H6gTcd528myvy14E/8yLZawWiFSjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 05:45:05PM +0800, Baoquan He wrote:
> xswap has no backing storage: swapped-out pages live only in zswap.
> Without zswap, swapout always bounces back, so the device would
> consume swap entry space without ever freeing memory.  Refuse to
> create a device when zswap is unavailable.
> 
> Runtime disabling of zswap after creation is safe: existing entries
> stay loadable (zswap_load() gates on zswap_never_enabled(), not the
> runtime zswap_enabled flag) and new swapouts merely bounce back to
> memory without freeing it.

Hello Boaquan.

If xswap is used alongside another swap device, wouldn't runtime
disabling of zswap cause a problem? 
User assumes other remained swap device used right afte zswap disabled.

Once a device is allocated as xswap and zswap gets runtime disabled,
xswap keeps receiving new swap entry allocations, and every swapout
to it just bounces back without freeing memory . until xswap's
entries are exhausted. Meanwhile the other swap device sits unused.

If my point is right...
A few ways to handle this come to mind.

1. Once xswap has started accepting writes, refuse to runtime disable zswap.
2. If zswap is runtime disabled, stop handing out new entries from
   xswap (drop it from the available list, or gate on an XSWAP flag).
   This would also need nr_swap_pages, the visible swap count to be
   reduced accordingly, and unused cluster memory reclaimed.
   behave as if xswap had been swapoff'd.
3. Support falling back to another swap device once zswap becomes
   unavailable. 

Thanks!
Youngjun

