Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D5E9C61DE1
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 10:44:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8ABC6B0005; Sat, 21 Feb 2026 05:44:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B381C6B0089; Sat, 21 Feb 2026 05:44:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A44046B008A; Sat, 21 Feb 2026 05:44:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8E2CF6B0005
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 05:44:31 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1C3FC1B5ACC
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 10:44:31 +0000 (UTC)
X-FDA: 84468129942.08.E43BF4D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 91C5540006
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 10:44:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oGxZudIP;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771670668; a=rsa-sha256;
	cv=none;
	b=8Xg+Kn5ENPS2uDUzF4VwkRmWaYOvbkb7OEdIGl/hevYHkDrOexbO26AfAm3YKxHF4ECWWl
	slZkizPxSFRWMwbcUwHgejVMAXm6UX4RuLfVQiZsIgxxaYw6WLiooFVcgZotXtgcoI7crq
	2wJ1DXouVUi/+usdqsDG3rtTRMyxoBU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oGxZudIP;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771670668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+XR0kMWSUMvLPy5VQc4RiQm8/UDUTJULIbRHLwxjPHQ=;
	b=DOuSW+3M4kFYwBM5mWk/LzbsP2m57jBGbmCk6A/ElJmtT+Op1fnf+bN3wbbE7jDxrZd+Pp
	6HDUzu3643iW1hE1aD9kKbOl/xJ0YfiK1RVOfeujUVpVziuQHmwsHo0ezbu3QOHeDgOr+z
	awFb/g8kDztdmpjMbjxEsg4k2mXt2zE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E16646001D;
	Sat, 21 Feb 2026 10:44:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC4CC4CEF7;
	Sat, 21 Feb 2026 10:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771670667;
	bh=KzJjqlPkiAuLvsC2bRJz78TF3ttNKb1JHGf9kdSdzts=;
	h=Date:From:To:Cc:Subject:From;
	b=oGxZudIP8wN7di7p6VfIxzrrUxjNapgMgmOmjt7BTWw1lyz5FqdsF04gm5JINhL4P
	 TXKpi8j0yjYetpHhbXE3MBVlqfmSX+qLbKuU0JNcnp7G7sgVP+qwsmQ4G5NPgEIVuo
	 wCWuZdmRVUEX/NNi22KJoEMEwx4/6piDZNnOUWN/j8W6lpb3w9V/ab2Wr7LJoYiLKM
	 sSHtjfBlMB/RFhWiwILaUYAZUbhhGvUhDROSJRibEyEO+Vkmuowst1jxnzTn0KLHAW
	 QpmsB5dxgsn/eI5c+rRZhNarBR4VgxU+js8GNz8yX+94BvtAJ+OClbHKIXG8ZUguz6
	 UTXxrIBb5qtEg==
Date: Sat, 21 Feb 2026 12:44:21 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Cui Chao <cuichao1753@phytium.com.cn>,
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] memblock: numa_memblks: fix detection of NUMA node for
 CXL windows
Message-ID: <aZmMhdk7rrvJ6nzS@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 91C5540006
X-Stat-Signature: 16drbhcx9so3fd59frr9fyiqr1kfnwkr
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771670668-699339
X-HE-Meta: U2FsdGVkX1/tU2SwSI9KJmmswJGW68JSunt5wWrFdV7curiQgMUM4VvbvhLoQmISn3HoiXr9FMyI7YcVEk8Bgqt93e1PRw2Y7NAbH7HqzSbuONyrzrWxZNShK9BnonwDcsIJVTUo+r0e+IJGE9DphKavGYYzSUUl3MKmfFukrwYq3B4PoS43MRIe7rctiLYeoOBP1inSRbT06wkn2CQFng8RxBNpsPiPktNiBPJbu4oO1ZCOG/02t8mssZUCCx26uWzmUSJ867Ak3748b8hxlLTddd1+xAb4w7HGcvhqe6LS6a06I1NWKuwyx2f+HL/VnwyPRdMKzpxpqKLe73QdtZT5lr5jdnoDNjs0RgCopOf6wIEKjDDtCzT2rQm7CcXWdiIyockeyPxSE+bkZDVpGbzHeLRLw5cnosVxSxVau1ayksShsH6q13cF5co4ug/AnSTuVWAFbTDN+RXIpLcfiBLqsGrvsTB8FsMDbFT6HFBKuPFZoDn2VWXH713LqMVisYdKuocbkxzpy2y0G3wQ8eOiBm80FcjKVagONbHBsOtk7p9vnVgiU97I2yRhsqbdY6HMYDpwUPOwlD+A8nm8XMnV08EgVzLUTLXWMjf33kQHDkODPKdO5TG5Vk9Lnj3cNmtAlFbqJhwLJ7eqSGzoB3wizuzgHD8chwbwvX0ijvRzCVk6XwZfBzl8F0KwV5bOWoUg1Yb9ObCBKHglKnQsSPQFXM6zgM9Llfp9voVdG3YgK7Am0Ps+OtYyNnlc3IO/qlXIJDyDSg85t//gzxF52W+hItBeZE66tC6bBpFCYWtwFoT250Js55TsCSgl0v2UP5WM1lUzRpdDcaYbMu4KF5ucGHarwT+NIvI+7Rg3Er6ElSJo+2x37GZOUx2hVlhRuKTvAO+IYsxCPwKEpLyPi0Icqq8B6cbvAow+VbXyjJfZxbcCFbHDeXMpQsSzJBKAZE67Uy5kUHcdpwEN6PH
 DrEVB+0G
 C64zCQlZ/47qiyNM4AaSpmw+6FRecyJq1fF5VhR8RuYyJ5YVdwiXN1N9XwUdyiVgSCU36rmyr0cGzLKY/fS/rlXtU1Z77XPcozYraNa9up2gInP2RT9nOAcV/mKZicvm20n5/2nwzYdEFzIVualwJNffv+6EwOSft72baqHHWEFJbEgdnPo1bj8zx4/6zSOPnO2r14Ge/vaEBqtKQ8E9dryuEvFYIJE7ut/2s69exi6RhO1dZTvTPVejCKCgu9a7CNHtgm0DSycND6GPpqPk8ccAjHSJmMP98Pr2i0Yct42Vxn4vOyd1Nz+9mW1UbVxUSgj61
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

The following changes since commit 05f7e89ab9731565d8a62e3b5d1ec206485eeb0b:

  Linux 6.19 (2026-02-08 13:03:27 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock tags/fixes-2026-02-21

for you to fetch changes up to f043a93fff9e3e3e648b6525483f59104b0819fa:

  mm: numa_memblks: Identify the accurate NUMA ID of CFMW (2026-02-14 09:29:12 +0200)

----------------------------------------------------------------
memblock: numa_memblks: fix detection of NUMA node for CXL windows

phys_to_target_node() may assign a CXL Fixed Memory Window to the wrong NUMA
node when a CXL node resides in the gap of discontinuous System RAM node.

Fix this by checking both numa_meminfo and numa_reserved_meminfo, preferring
the reserved NID when the address appears in both.

----------------------------------------------------------------
Cui Chao (1):
      mm: numa_memblks: Identify the accurate NUMA ID of CFMW

 mm/numa_memblks.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

-- 
Sincerely yours,
Mike.

