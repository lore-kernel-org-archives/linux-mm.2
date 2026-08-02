Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62700C55174
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 18:54:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FDBD6B007B; Sun,  2 Aug 2026 14:54:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18E176B0088; Sun,  2 Aug 2026 14:54:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07DE06B0092; Sun,  2 Aug 2026 14:54:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D45A46B007B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 14:54:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 531A2140546
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 18:54:42 +0000 (UTC)
X-FDA: 85057230804.01.A7DA26D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id C3BA310000D
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 18:54:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R3FE+Te6;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785696880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jhwpPt8VETeDzUlgcaGfy/+m0kpeMGsxwzMN5hnljhc=;
	b=XtTj4isc1h5MEdw1HKtKcUYTAbaljkv8tJUczravDBZ6+rU5lEAjxPfzgpJU6/cVRpvSN0
	25FL8rjQsFz4zfbLEi3ZQZchfnQsQ8upHVzj83JtW1rWlPhPhVD+rAk4XhOS8Je8gzAYNQ
	pLDvAbhznqOEa6dxodtTLJid/qnfJ/U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R3FE+Te6;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785696880;
	b=2NfhvO0CBhx7V0ACg16hdWqbT9y7ggp8qTzK6CkfcIeXSxONnDv1RiivvrTbPaBMxTcxxX
	8J4Tdy9oLTNLPaedWjzuoOSY0QTWrcSNLceD6tZpUvbvUGReEHEU5M0AFe6OQboMLwNhBI
	JseNKEj4YyhUDeCwMTzYqBzucx5sitU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F316E6001A;
	Sun,  2 Aug 2026 18:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729DB1F000E9;
	Sun,  2 Aug 2026 18:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785696879;
	bh=jhwpPt8VETeDzUlgcaGfy/+m0kpeMGsxwzMN5hnljhc=;
	h=From:To:Cc:Subject:Date;
	b=R3FE+Te6xd/7Z5It05vdlY7Ysz864FmCc4VL0KGlQE6lPKkrLYH2KMDVrsNk6kpxn
	 pVM4I3oNZ6lN5TTtdNNS/fY1iqcHDgOXsIGxRSFIHhu0fboDtbee3N0/CKXMmKM8B7
	 K5ubgsI9OBJgD1uuHcJEyT11Nf3qLUhJCkq8jkBjjrZ6S4I/nMgholX8BPEI9e7ze1
	 +VdkhALsP4l5iZVfIPfcapLGpJm75+Ba6MmLD2YtYIN0BXGDZMSC2kHlMnzNCJVO/8
	 jp24ZM1+O3km1Q9ZzC7+dZO4r5BVykm+w3x2fi2ETQRumUzgB2Qd0Wqxa8/srpnUFj
	 g2v8sQ0wgeN5w==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Liew Rui Yan <aethernet65535@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/2] mm/damon/{reclaim,lru_sort}: fix commit_inputs infinite hang
Date: Sun,  2 Aug 2026 11:54:26 -0700
Message-ID: <20260802185430.9940-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C3BA310000D
X-Rspamd-Server: rspam01
X-Stat-Signature: bx16t4nb9pm68bkesuf67augh84b8key
X-HE-Tag: 1785696880-535821
X-HE-Meta: U2FsdGVkX19mmuNM0eBf4UraYgx4BZdNKRmzpWUgSh0mHYZ5oSjwIsymII/Dhs8UsfqGUjeU4ugVU0zZpM53pLLscMbDwRufjrZRRfJtM+Mo8ltsqDhIpfMxwJTKTgNc7FDg+VEnWyQRi6gPFTwFFIVGfmZ1w568E9drd+2U0Rp1UZHkTSSYh9Z1zB5wyCPUpTcX+DW4qmXUJabCap8nmpS3U0cy7if5ivL/bOhylA+X+AfuAKmpNkfUjH8Ve1Qkg2kw/WwM0AYNpjC3za6vc8TWdjS1elJKn6v9pew+WTHhFkkNPfxFVwg5+8aHU1llvmHAUndLcUVRI2Cwaxa5BX15zTaJo0j15UfRGumxYS+w4IOit3dMbvUWuzpVs1E9B9SGl5nU7mlxkgIuPFwgAuJSEAE/sy8aqqeYfKlNh0brEDJzyriuc//qNEQJujppd51VYDCBIM/ULV9G/1Q2s218XyBuh3pUKCfmvHZQkwq6kX3oo2ayqXNMkVp8CCBqwWMBBDFFl2K8deO3zLxzlDniRmGa1OSBFjNvs1cvfVkAaLC9QwadSczona5dE6qFjoKfkKKLhwYzNXpTw0ZRs9/1wh0BNuU/lFT7L1FBXsXGs31VmSmRe6CvntHhd3QM/aURaqml17waVb+oJyyqKPAzYNWy+riczos0U1+xokGa2cA8bxdGp6z3Qc8wDNjlIpj/nA/VdMm3FDwXU/S89c4DRRKm214a776QDaU4L8/dgBa8InpFy1vVkpntoVo9tDaaEzRBoNlHflwRodvpjU/ZTHs4fv+8xjas0y5/yXGQnr+owe5Be878OzhD2P1Vh85Fk4csQJ2xLxDn62xV4YUWdB2JvCxPQkMmjwRoJmfuFy6oGovQGggQfHP/Cw957ADZWQUUHISyQi+mNsSUbTmM+KdRD1WKKsqxgFxjWfY5vxmfz1+z4lkw8+nncVXMeFIohHgmXQo/XjESf8L
 EwqZHgAb
 0M3OPOzjvLVoeXZIjier4rzC/uXRQxSKNscwToFKOemWHOqhsEsqKfbSMpJxKVfdgcpqvjhxv2S1P0ik4cLrkkM1yeF+rbsdxpkMo3xdQDmq42LVZSPML9Wb8mRxv2VgDDKnSDDUDJMbDWISO+IDs1STy3SLPgyE9tEDfxELVsqxJONtJoHhgwy8CUOciW2q0ixCDhE7NuG+++UjYfrjBzm7a4r3OcATiVAU44R0AMTpfQKgxJCY3Jd12lmeDcG397rqE56eOs7GKs6kpdsQYf++dRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Writing 'Y' to commit_inputs parameters of DAMON_RECLAIM and
DAMON_LRU_SORT before the modules were ever turned on causes infinite
hang.  Fix those.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260802173021.762-1-sj@kernel.org

SJ Park (2):
  mm/damon/reclaim: skip damon_call() if ctx has not started
  mm/damon/lru_sort: skip damon_call() if ctx has not started

 mm/damon/lru_sort.c | 11 ++++++-----
 mm/damon/reclaim.c  | 11 ++++++-----
 2 files changed, 12 insertions(+), 10 deletions(-)


base-commit: d6580a342bc8c459628d2b68b313e9c0668bca59
-- 
2.47.3

