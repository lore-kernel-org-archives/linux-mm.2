Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42D7ECCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 20:15:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23D878E0006; Thu,  6 Nov 2025 15:15:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EF598E0002; Thu,  6 Nov 2025 15:15:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 040E28E0006; Thu,  6 Nov 2025 15:15:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E4DF58E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 15:15:03 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AD79512C1CB
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 20:15:03 +0000 (UTC)
X-FDA: 84081286086.19.D40855D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id F26E240010
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 20:15:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=XCv+0zbx;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762460102; a=rsa-sha256;
	cv=none;
	b=1+ujLAiv2SAYw7V88VXNMUjI7gdz7LV3eCPNyNpQrLqPGmogoHT0Tm0UvnGtth5xcXl12p
	1IvAEex45DbabPHmfFziEayLDOe2Q9lyDQ5JvYV3VseTZgGSecbDECGs/iuAvN+kbfonyg
	qxC5y+AMQjcfys/6TEG+M/NtknsjMYk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=XCv+0zbx;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762460102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qLKWYlgxbHY94vIRT7skZWeQFUL3ITlcBgFN+oc1I1U=;
	b=RiSpsv53uU36pjZ5Um9TTp7wnqSRClT9AOPXSLyJYiXB3Xhh6U2qaIkiNY7jtjlIxlZVSg
	Lc9MfmRKpqCrsfNs8rf04Sxf040IHLfOhFqIeH5MdnfWy2jWYmf47PVwFO1wFvZJe/YtAU
	Smhxzsh0baixJy5OttPU3oRqV44kYTw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=qLKWYlgxbHY94vIRT7skZWeQFUL3ITlcBgFN+oc1I1U=; b=XCv+0zbxJCWB9S8DZY/9GMSMyU
	cfcbOw0SQU8sbEfECnt9FPtvpY2W/KFY2DYzWk1rba77uBj4Q3PBb7TzT/Q6I8HkT+soHPww9/r+X
	8Y5r1qEVD7zgqLDbrnGt1RCvi7wTf0I0koiq/esLjgwl44VgWSqvh+Bqjzmo9JnYoV4YZnmoZNSE1
	j5tb5rt2xDQCxiRK9tps4kOmvRCujW5M7ZUpeuBZsnOtI4BDYHKDvK8Lefomw5jf5vvAwuehdlX5V
	D8Os9B4a87PUMh3l0ref1mN/IKo0V7+CcA3pD1Yr0TkhwmvzzR6LnWFnaXHmR4aEf2wZSpLgfGcJX
	0LpxPSOQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vH6Ni-00000009cTg-0tTN;
	Thu, 06 Nov 2025 20:14:54 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org
Subject: [PATCH 3/3] memory_hotplug: Optimise try_offline_memory_block()
Date: Thu,  6 Nov 2025 20:14:50 +0000
Message-ID: <20251106201452.2292631-3-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251106201452.2292631-1-willy@infradead.org>
References: <20251106201452.2292631-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F26E240010
X-Stat-Signature: 1m997d73o81r1uzqebu4eh9f1efosyzf
X-Rspam-User: 
X-HE-Tag: 1762460101-78966
X-HE-Meta: U2FsdGVkX1+UfWHZ0bvAtXUXN/br3LP77AomuFmPSnQqwkzzlrN0cb1x1jDyXFOq4WmO+BTFxGrl+iBR0NXZzHYQGKbBxfr44THrucWh7K31i9j+r8tGeeBf8tHLJh5QBR2Xf68oao+a4Ccit8WUCh7MB6/bYQJX12BLwWQ9cSM5evfReTFwFHXQvfvbx5lO3IsqnvlON/pk9fR7aXwt47x4Zhp3rpKJVeQAKAeKV12K0y9xuCD8iHM0jJvRburATCZhx9REMPUflM2oUs3blymETFfKt3/OHerEIhy6fenMMIRBwa2ltzygzZK1SvmKQrdGG7FEkNVPouANV7K807zR/KSmt5ewLgFc7QSKOn6rDadPcSpGTcvT3H7FNnHKtDIRl15jU+BSwhMow0FECmu1yFE6YameNWVuX1MJxYL4XqTlBfHlwhhwrRvRmM1s2+nb6FTBu34sUb5Xb0FWG0nS3PXzdfkB7sxaQFuzvjZcrVJjl6p+Hy3PeaE3Ak8HppNr84lW/Qmb69zjDVtEUnKEm6bQL1pr8M/XG6wXUXP8MOMKaIiuyfp785JjXL90yxDxJd5HR29115QYmDKpBKk1bhsdOQ5WhM7+KORkb3aP5uw4Z2KP2f1ubMIuUd2qZKPBBDMn641YPnKW1UvqjyLdp4pllhxIzQcjQbYwGoNFxlx4orrYi8kdbWWi/B//PdPx4bdWjeHhz2USFEj08eugxlAgYrFTvfPcn6MVsSqajyYqzyetImTJltlWM+NFASV5iC4ZLbZvJZiQ7WgjLLjJLV1PuXTXfz3D8jm9Jt/qyLy1+XVLqfVf8Upvq1wLXto9zFDJa5TENoAjUGJEAOW/MmddWC1c0pLRfYOabIHo8aJbPbzwgtJDRrMCtPtWKEkCdGoeZjcSNYADJJShye1ohNOXd3CAp0Ck43woF7imFWItuZ0mAOrZF+bGCH1xjhphO09IK+4i1FJToJQ
 r8RaZsN9
 Fhyc8KMrA03XB2c+/P5NQp/FQjlfNo0PWHBAK3BXMXHBbryDOISuvM92LvBDOWxw8o4wBHdu84bSCgAObXcEIMJFn1rOF6r3zKXMvhE4UxGNPiiSulZM+8c9aawegOObO6t9IqeeS3wxs6wRsBzTveK0NudKgOrZq3CkbecSKWE9L6qsmXNfpTUVuZiuJ2UiNDB4YvoiAg8CIuedev5NW25NrwidktwwxVM01pwLevBZpvIBdjwdLyVDQno3F8IIiYNYA78Cj2T0l8DYhhURPUV964wFR+Gx5jRXTxr8TVuxJk/jdRnPx2SfiMGaxNBC5tRU0/NSylSO6vn8igl9XgMRp1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract the zone number directly from the page instead of using the page's
zone number to look up the zone and asking the zone what its number is.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/memory_hotplug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 0be83039c3b5..80713bdf13dc 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -2327,7 +2327,7 @@ static int try_offline_memory_block(struct memory_block *mem, void *arg)
 	 * by offlining code ... so we don't care about that.
 	 */
 	page = pfn_to_online_page(section_nr_to_pfn(mem->start_section_nr));
-	if (page && zone_idx(page_zone(page)) == ZONE_MOVABLE)
+	if (page && page_zonenum(page) == ZONE_MOVABLE)
 		online_type = MMOP_ONLINE_MOVABLE;
 
 	rc = device_offline(&mem->dev);
-- 
2.47.2


