Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BB40C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:17:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66A4D6B00A8; Thu,  2 Jul 2026 20:40:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61A9B6B00AD; Thu,  2 Jul 2026 20:40:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 531126B00B4; Thu,  2 Jul 2026 20:40:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1EA3A6B00A8
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:40:26 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EA1031678C9
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:17:33 +0000 (UTC)
X-FDA: 84944493186.04.3AA86E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 501FD40005
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:17:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LvsKJecz;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783012652;
	b=YaEKDx9CF8DMPxiRfMv/tWTD6X+HuSpqcoWZ2eYtZby6JS8ffe0BV8S/MTW/NcydSqXT9F
	RDTUIeNiRaFUyYFq9GzJ2rbQ9ywk9LrqfIO0wVZeD3GKfu5KhZDHl6K7FdacZ7mXBrE6GZ
	wCe7aerXcLYsZIOL8rf1M43euEuJoBE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783012652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PtgVIn45F2jyWQFHDav9RTyiur9MFQyJ2Q0LK1nrhNk=;
	b=rlrA8gxi7ey1w/wgISanIvyqxSr7TowDxk5xdOe8LflXLtJgGqIbcm+8tHmz7COh4p3cow
	/IDWzJYk+S1peHP1D3/FjSutqgvoUZSZki/X3ndOfQllwOU089faqblGbf1ZhK0PIaY+MN
	M4ixVySGPcqSRPfezGJzPGW27iwjBoE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LvsKJecz;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7746C43CF3;
	Thu,  2 Jul 2026 17:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA6D81F00A3A;
	Thu,  2 Jul 2026 17:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783012651;
	bh=PtgVIn45F2jyWQFHDav9RTyiur9MFQyJ2Q0LK1nrhNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LvsKJeczZhsyMy2+rheXejzfiSf/2HuZf6rkTeBbhXrQ7c7hwRZlTqdkXq7JF3m0g
	 tGCHD58OqvlC5nvpswa/fEJjcQx+ngi+RaBqPzMbPeE7z0vL0YFQ9D5vKJwWHql1VS
	 HIZ3QGTnryNhYGcAVGuJiUeZXgOn7dqydv6nBbEBQUUaszEayYxPO6cijTtzeb/Cp1
	 jzKTi9INBZXSnFNseeOLDbtMWD6RHnoWMIavBtmOzKELxCRuHynvzz63E3PJH1W/Al
	 mD2TfDvHmBrrhUnFloVE13qEFhDwjStsA9rcYnVc+HBHyxmMGpVyv6tDoT7WGTHMI0
	 lV2sXmu61o2Yg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 3/3] mm/damon/sysfs-schemes: set probe hits as pseudo moving sums
Date: Thu,  2 Jul 2026 10:17:11 -0700
Message-ID: <20260702171714.88278-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702171714.88278-1-sj@kernel.org>
References: <20260702171714.88278-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 501FD40005
X-Stat-Signature: b179kxo898citgy63riqeppkea4epwyy
X-HE-Tag: 1783012652-153049
X-HE-Meta: U2FsdGVkX18DRJkdoTPI8XUKhSP/eQSkEHYd0bWDwEtJzJ9nJg0yxWj9RidxT4vHdlrdohzcpKLXEV9qUqJVZGRYwi6AkD8l91VgdRyZZQiAcFuEVQLXuE/nMDNsFfWQtMIkNLfD6ETmtkyZDUV9rS+u8I/WFiv79wtQtg2zN0TqlJ3C/PuESzxMTPl1UFiFt65Z9UMmKz8rLglCGgEGH8xF/7Z0ymL7SY+Y1am+RZfmykqs2pxTCQ3ek2n5Jm0oEVzLjK/QcXb56+CUwActIEv63SmgCjupV/mhkwBoJV5RJaahm/hIHiTXg9kmp2CZEYKQxBMQZ9vYuc5lAI35rANhQkg0MGZXGsehzjw+1DZRCOBK3qC8e6asJnmdsMs+3YII8rC36dHPwHczeUTq5iZ9iCiTgjicl5QaZIiIvsgKifV20v9/2E0sF/c0Ssri1alDum2MRT4GXCG2Xu9KKE1+pwF0jGBtwyhagzCbrAuYzT9Q+4ZTTZg1EXc1qIuZdXNde/JPnmGubY7+nkgd5bjwufxcrVlIRhqBhFz6SkYwLVIRvTpy6U8Omvgg96MRfjz4/hCD71gJLQtKTR44pi5G7jXaT/Kqwc8xcK24kAeKpRxViyuSscnvYLBvNr7AnAw/X6lmmKCnimMQwll/9gjfIkGLd6zYUZJwBpS9tXYdHbAgj0NwBxHEKPv0hwPF43ZZC0GkGaAermYl0dEdOaT6YfBo62cFMOooI/3y7OT4OiKSyLbFK54vNmLgm9ZAODVcuD+Kf1u1UaLYnlWgzq+RfQ1uTwmlJ2GHqZOpaJOE392gCPOt5pk+vWRFAqbg9IDDaOXUuhEr7wCRFb8II6LtFRVVcyox59Wb47Cn6cJ4XMyvUwkLRF0Mi6IlD16wmwruFTE2RdrLCgfGuj87x20QKJyngDs/FtLFJsnSfB45SzrJ2av8ZpIFT3BbjOmQYAaxusBHXNnCDi7daeX
 16rg4A9R
 +p8gK9kqXZTOY40D/3ezymwbmGYOHJxc1NDfL/RGD72SEGnTbfbTVffqdXp8GaMhZzgmULNcw0qUH7N9u/b3pofDnlfAqBRC1ELLmFnpRM+aORpS1OJx+Gqbh8r6aVR0PEr/LVgZfwpT+ZNhXt50FZhLYsj11kiBC2LwttmEfDf3/Kg564Kneox/0cEbtHq9GS1u17QBmmULrjhw+81Qxroxwpvi9gmwp0aJz9EyUL28ErPw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface exposes damon_region->probe_hits via probe hit
files.  Because the counters are completed only at the end of the
aggregation interval, users can show incomplete values if they requested
the file content update (update_schemes_tried_regions command) in the
middle of an aggregation interval.  Set the value as the pseudo moving
sum value of the counter, similar to that for nr_accesses.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index dbf2b0515d582..32f495a96b17a 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -110,7 +110,8 @@ static int damos_sysfs_probes_add_dirs(struct damos_sysfs_probes *probes,
 		struct damos_sysfs_probe *sys_probe;
 		int err;
 
-		sys_probe = damos_sysfs_probe_alloc(region->probe_hits[i]);
+		sys_probe = damos_sysfs_probe_alloc(
+				damon_probe_hits_mvsum(i, region, ctx));
 		if (!sys_probe) {
 			damos_sysfs_probes_rm_dirs(probes);
 			return -ENOMEM;
-- 
2.47.3

