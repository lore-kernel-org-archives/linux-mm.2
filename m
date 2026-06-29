Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 299F8C43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:55:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74F156B0113; Mon, 29 Jun 2026 10:55:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B16A6B0119; Mon, 29 Jun 2026 10:55:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 578CE6B011A; Mon, 29 Jun 2026 10:55:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1CC596B0113
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:55:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9C2FDC03BC
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:55:46 +0000 (UTC)
X-FDA: 84933249492.07.DC21A2E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0DCFB140005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:55:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f+GrKNZl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744945;
	b=45snhlORpdtz9SMVYk2ZCsaJTS5HSvqIcKjVsqAQIWeLw+e4ZGQCmlMvbtJf67wkj3X10D
	Jm02tmFtdAbjsh9PnfEB009RUbeYqdfnqI7keCQHRVMRf3GfM6QO8CMPH0TxhNi94IFw+v
	PjFw4O6f9ro8+NQIfDi6SIagXAubC6U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pL/OIFxAfmJMENrJselHOaTQtQ71A4Uv2SXDoGfSIdk=;
	b=MXoI/1STF8CyT5cSaLpGNULzb5Ru6An5NS4nW8MorCmRENWxOkceTsC2M3TnDxcvHO9Tq4
	x4Jc7ytjZWP29Yqp9FbjxSDT/BCRq9+r/ADPShTn84/1Y4ucpJuafx5bopQjF2qsGr17a2
	2t9LaDe5N0OgGAiPLljqWy/dlbcuaI0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f+GrKNZl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 947F560121;
	Mon, 29 Jun 2026 14:55:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC58C1F000E9;
	Mon, 29 Jun 2026 14:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782744944;
	bh=pL/OIFxAfmJMENrJselHOaTQtQ71A4Uv2SXDoGfSIdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f+GrKNZl7rNDdeHLjnA2IB+t3bNGbNvt5GRbLNylwd+JKc+cKoP7w8Fz4BYL4Rqqr
	 gFT6c0KH0T1AalBrpEGas5knLBzNAM3qvYqjZgmVuUOlBw+q9989VvK6+yPzWb2UyW
	 e0QOaZ+MVQJzwy1ggUIhkmRczkXuvnc7fh8IPD9if0B3NKooMt8jss/76jTUfviBmy
	 /aoSOQH24JiPeacnNEtiIjHbY0GUe4qWT/w7Q318mehq/RvzxycjrT4l+0+hXqwr8i
	 6Z611YYQ+KzizEl3blr1WDy8CDzWgtqALDZj2RvKi44PiqoDTMlN4NBVQwzv99uzb2
	 pfz8FLfsvZcNg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	SJ Park <sj@kkernel.org>
Subject: [PATCH 1/5] mm/damon/core: use kvmalloc for target regions array
Date: Mon, 29 Jun 2026 07:55:32 -0700
Message-ID: <20260629145538.134832-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629145538.134832-1-sj@kernel.org>
References: <20260629145538.134832-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0DCFB140005
X-Rspam-User: 
X-Stat-Signature: 955tsb6ad1yhhwbhw81coz137nf36eon
X-HE-Tag: 1782744944-455100
X-HE-Meta: U2FsdGVkX1985uWHIbPSFNueu56tCQT0KU2cdaqW6Bgv85+ykQLE83EGRBU7LU4BxFlcxCdUlXFMtw4MdyXsaPvGbp+9QspeyWCbshNvL16e2AcdfynI6eJu6EN1PJbqzKC1nrEFuwJFOSrBqohxTw3OPYY0E1Ibv8QOWVIEkQkbbC0oND90YHPOWU+Fd7GMPEyQXd82cizDtsvb/nsB/3PQl4qukVZZ5EroHOOeTePPiGibpvfx2P9XsVjKDnMRaM44p7XEwENtJmOpU1dhzSKlfds60Hi6b18HokCP5vRoGCreBI+Z1kR2HpA4NXTXEo4euBomYEaiSO8bhhUNirs5PNFTNGvHrVBTJuS9v2tYR5PSYybV4dfLyHGh35iPmjYcSufcPOofdufil+hmJBx3jesHkVn9g/LMr8X1l50w4MUFWqAA3KbuAvfjmPh2iSk2kukSEA6qtBdLPoSn06+Sj8QWTB8R9RAYfSNAn8IiItmKTXX+lkEbrki53TXEWpBIgQL8v8z/OOe9bAU9nKjQQKSKtaCbPvCaUNAFql17bWXgiW+vJ2mVWyhi5YewQ7XLHT2G5rQKzjMkM7UE+69B1gmj9QS4vPAWQ+RO4/+UJDIO/vMfKNyxa5jxUAioYwGSIWVipSvf25PCqOl0IQM7uXuZkoau5cJENHL4ygf2/As/ThoWLRCMm33PZdsNjGYpV++EvFcikMe/g/ZS7eUET8OFaP6YTOQKwq4pVRX4NVsIPinFGevoGoEvdzIrgieK3sEC68UyzvxlkcFjTZwFaRMeVpslavo4jSDZy24aqw41v5DeTQ0v75ldY3AWSYLWmIBj88S521r+fN+vwDr3pL+mzSNJDneCa3ff7B/xXVMG+TbWtsOvdc55h9ZKbsNd+newGRhLTq6LlFjGjJtsyk9axJXTi3+X9N8wxePQIQ6KLbBwAME/dq8QMRoxN7oVPPulA/q3dVs0tVx
 VTeWZrcd
 YHtSTpakVWrnXLMVEqshxa9YseOMKVTkco74axESHBYw2coJ4SIVbOzktQvuhJ/6fSi6FokH7MEUYJQv1C45lVkuBusgjW2VDfYZSOBoexF8aSDwC7pME616iZrFI9OyU8KLX1kiyXySmELG4aHiAsEIpppFU8bhN79Q5SXVO7hjQakYWr1Hy3kIf8rNGrCWDDsOHQFtj5ArB8yuVzuME53ThAUq0Ar70XtpKEpiwpMJz5tWv86/FZbRQw/uDLFRBHHde4Y4Ic3YxaRT2lxhMhgMeIckFnjGuCOl8RNjg7iA06K96ZKgygVPFfirdxfkHEAxhEkLEmv7A/+jOpyBuhDptdsT+OSPd9ALLwN5QLNZ8/bw+dVw9yux3OPLi0S9V8MzW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Akinobu Mita <akinobu.mita@gmail.com>

damon_commit_target_regions() temporarily allocates a single contiguous
memory region using kmalloc to store copies of all damon_regions of the
damon_target.
However, if the damon_target has a large number of damon_regions, the
total size may exceed KMALLOC_MAX_SIZE.

This problem can be avoided by using kvmalloc instead of kmalloc.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reviewed-by: SJ Park <sj@kkernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20260603112306.58490-1-akinobu.mita@gmail.com
- Collect R-b: from SJ.
- Rebase to latest mm-new.

 mm/damon/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3dd2750c2ef20..ded76719e8a14 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1362,14 +1362,14 @@ static int damon_commit_target_regions(struct damon_target *dst,
 	if (!i)
 		return 0;
 
-	ranges = kmalloc_objs(*ranges, i, GFP_KERNEL | __GFP_NOWARN);
+	ranges = kvmalloc_objs(*ranges, i, GFP_KERNEL | __GFP_NOWARN);
 	if (!ranges)
 		return -ENOMEM;
 	i = 0;
 	damon_for_each_region(src_region, src)
 		ranges[i++] = src_region->ar;
 	err = damon_set_regions(dst, ranges, i, src_min_region_sz);
-	kfree(ranges);
+	kvfree(ranges);
 	return err;
 }
 
-- 
2.47.3

