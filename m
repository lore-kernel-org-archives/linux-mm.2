Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFD63F9EDDB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 14:35:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33B7C6B0092; Wed, 22 Apr 2026 10:35:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 312506B0093; Wed, 22 Apr 2026 10:35:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 250376B0095; Wed, 22 Apr 2026 10:35:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 188DE6B0092
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 10:35:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A6B75140184
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:35:10 +0000 (UTC)
X-FDA: 84686439180.10.623708E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 23E8512000E
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:35:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="j72L0/mI";
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776868509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=p3DHG3+B6Csfqj4SyHLufRmcHr2qT8lXGolarIPyQTY=;
	b=cCg8x9YvGtiZUxserFBmcxtIrdUdFpOVSBQsSkLKi6ddKIpxsKtqFXYI/zrZgNbzy1k43/
	nw2JO/tLDsJ/P17oJRTlBOIcQXSbVUK15kba/RMZvKhT7m0N6CTl0mftKeDNzrZ3lNMOou
	J2gE8de8FFjrOQGgRdtukbx0uCNYWEY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="j72L0/mI";
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776868509; a=rsa-sha256;
	cv=none;
	b=QmJdB+UwskH8lWKpOdCgSTXS5T6pq7M3u0J/EMjaQpRdDpzN2P7X8IZMcIPcN0K3C1fDFF
	1i9guzESj7fLaAHGS7CFeWgyIDQyo25ZJ9qFlEpu8bOJVIBz7+N13Xg9C9mN27Hj9QoaWK
	WpSdnqOjWuylUGAuImZ92l2zgQhVSzk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 372E16132D;
	Wed, 22 Apr 2026 14:35:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF38AC19425;
	Wed, 22 Apr 2026 14:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776868507;
	bh=bi6XcGwk5Sb2RtrCfQVAavSWJYWkUYMGONOn/G5G6lQ=;
	h=From:To:Cc:Subject:Date:From;
	b=j72L0/mI2RW3vfdJ3HLLEjpK4h7FpsFh8HwcMuZLZue/4Y0Cv4hPqIJj5chF6p6kl
	 ZtW4fD+t1j7RLaCGfaS70ssc3fatz7PyJmxkCI3GfwFCuzuABpraWCWok8W6DHYKvS
	 xNjBEnfGwrqj+kalLhz5RV/PwmF7mGW/gGDAsOkR/2X6Xig5XxOoSe4mNXgL7rt8Vh
	 SCNboo+cs9bGVI9o6p59CkZnSJF8MIUVTKENZvP+z5J3dYDxCSZMbyW4UNWL2zVRHy
	 fk2VU/adTpaNWVfA7jc2STqEyg/GIeiomUnEUMlxZ3m3pDanwjtsABT8GEucSKnYrD
	 zE9O5RefrPS6A==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 16 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/2] mm/damon/sysfs-schemes: fix use-after-free for [memcg_]path
Date: Wed, 22 Apr 2026 07:34:59 -0700
Message-ID: <20260422143503.71357-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 74g67uxo61qa5apbw7tyzpwtxtcuohp1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 23E8512000E
X-HE-Tag: 1776868509-589398
X-HE-Meta: U2FsdGVkX1/8A1AQp55NhpUeRAdbz3m0CFvavHVSEISq2vXMFIT8eTyX/cB2UbEPM5vnJ3Cll7GJpHxk02p6JQ9o5oUuH4V9/SsyK79mvXQ3tfO+qlKD/7vN2/cE/BIvBQRoUk6S8RwB+zzxV/HLvkijtoR8BXn6uVQf4uV2Grjh9gDdOTvvWTolt/Co4KOy1cK153y3R7aZ/5MWLWe3JfgS8k2/56HRbOjtFfgrMWrMeT1igO3OEjNa8t8y/n0/aGOVnALKqPw6Ac1Ky/auq5ao8ZUj66jlw58DDSPp0QbNyuHlZCtmVITgvru66xgUXLF+OBUFq9YwsWKJnsitl88apmDqIRMXvaaWewiMYE38Z9GP5c8hr1b5EmEXcygYtnr25xvb3MK3aEqwQ2rdbiSbbPR87OoqgutxPT73gbcOWIrmCmwBx7RViTEUzEgZ/oKZvvbhiDFPCXjkJPDmun4ozq2ShKjQz8/GlGfTER1VA5NGUN2ItpdMxzQoOQM1DfJSvFxW6c2yGHopPrA+/Q5E+/VjHlnqWXvOCtRjF3f8c9nkb87RWBPouMcz+gBol6m/7Kqycu0gda6WzaZOUhg/wCQNQg2SckfV4S2SNzC2FSBbUMirfGGDL8PnHJ3H9hqEbw2Dsid7xpkRTcQQ2NoKy4nGUe4rTv3P+SjuqyXTjrjNzPSaJdLuofZTzV6hX9myMKzzU7E4yAI/K3ahiTLju2Bx2LbIsBpl5Nnw9QoceYQQDh+SaMQdxAMOeaiSvlHMcCdz28HbFIpw7xJrBrb7GcJ52F0txw0kthsT2c7syKBbv3FET7ejhsH0TmuQEXPEc/8koGjtQw2MLdA7oDDc0XsUSOYWVcGpdSfqZmTsSnVEpBRL50JVGzjKDMUpWX8g5e9KXBiR1bipmqDGnhm73AUyXwrOZ1EfGLUOug+hTw9jMaBwaNXFsFcsXBrxbsp8wQk2VvYuXctw9Gu
 XgqdB41g
 0ut++gVBLtz58MaYKxqFXMK2l4mnka4K3XHqZ1U7F8KP7o7TkcnkAPfk9sA+xDHXvGN0DGNQ9VqBk7zwlmZGZNzRsLvifasxaPtHUGPjauukTeal3bYp5ihkr8bLBUVi9hiUJ3EM8EjX5/VlZ5FW/1R1YnZkN2dOnJ8rWkG+eQZc7bbuhrWspTI0YDyi7CgoxKw1LnmaB6b+5x63ZFPf//Am5wmG7H1v8zZq7IU9LfBhzzQbFcw4g2p0EyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reads of 'path' and 'memcg_path' files in DAMON sysfs interface could
race with their writes, results in use-after-free.  Fix those.

SeongJae Park (2):
  mm/damon/sysfs-schemes: protect memcg_path kfree() with
    damon_sysfs_lock
  mm/damon/sysfs-schemes: protect path kfree() with damon_sysfs_lock

 mm/damon/sysfs-schemes.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)


base-commit: 0d45806f3a75bf53e59475b0e56be324f650ab09
-- 
2.47.3

