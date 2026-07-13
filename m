Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8289DC44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 08:58:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A96D6B008C; Mon, 13 Jul 2026 04:58:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85A9C6B0092; Mon, 13 Jul 2026 04:58:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 772686B0093; Mon, 13 Jul 2026 04:58:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 58E206B008C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 04:58:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DE6F01C974B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:58:18 +0000 (UTC)
X-FDA: 84983151876.26.4C5842E
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf31.hostedemail.com (Postfix) with ESMTP id 519A020007
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:58:17 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e76Rkjzw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of guopeng.zhang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783933097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=o50UWWlVarKMLpI6cAe4MGWsEGszstCJcs3+C8rnhwI=;
	b=3EUFqw3538HgeZvtgBRZ9Q17Xd3OcOXQB9p3aVA2OJZZGJTWdzLvPhauoaYwv1vbJAX3B8
	t7puypgwbQwiwq+HAO/WARmanfyRqcLc2EYVyYHjwf4POqqlg/CO3q21FClMMn5ktGP15G
	c5TNSvhoQuIrMS3yHxAC8f71ridzNmI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e76Rkjzw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of guopeng.zhang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783933097;
	b=kyQMWedhzRWIa196cGJAgUMRiSHzAvwOws4qLE89wW7vMy9cRnoLxl+Oa4nRJZ1DAXG58D
	4NKS0mvnTYkpLwCqELqrWvdO1yrPB4AIkjdxrSKPLuXu1LEMvvw9lLL33qjJFU3sp3nxBV
	9Ck6zHc1RLs8SA9lZYOyx7m8MKZcI5g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783933096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=o50UWWlVarKMLpI6cAe4MGWsEGszstCJcs3+C8rnhwI=;
	b=e76RkjzwzoMlPIRamqY/vAQmc6OLqBcbFDUzu1geFIulY9WEStbRpJ+q1NFgLlAaW07y+H
	dD/UF31sL341kXXwKzAkD0v5E6zv5jcBKFIdsWXl0lqfmGqbiWhoV44BJj6dF+hp2biUHj
	zxV7fmxNAjCNdPepr6ZkmtNFI1jAMyA=
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH] mm: memcg-v1: fix wrong linux-mm list address in deprecation warnings
Date: Mon, 13 Jul 2026 16:57:56 +0800
Message-ID: <20260713085756.2973549-1-guopeng.zhang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 519A020007
X-Stat-Signature: kcbwnu4ctsxs4ikaut1wyjgaeezfw5hn
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783933097-674901
X-HE-Meta: U2FsdGVkX18xsR851HwO3iCYt2xDZx8DiVzn0Ow86eUpMFL3+e3wWFwdUrAkajsXfRkpj9piAhH/nIrAjiiZbPq/FrXwAKOTLFxcR84djsegT+WpCQWjM8P0TWQIVHx2wl0AIIGWOXlIOFKFs6Z6aCTDj3zHeItNdvCeFVbShAK1PiRE2iUrYGIrtSFLk3LcJMrvVjr4G86T1Mo2DoQWnUqnr1QnnT6sD5yLXFGxbXmsCDduoHbJd5rPI6hVKumV6cLykXPP3edyg0CwVdPLcsFIDqVqlEKH//j6mOv2Z/6WSWG2RTg2PHLWX9n/XBKayI66u2UvsuM1/i6Jw+fW/jblyL+BOQcXEgBdMUi0OfjxrT7eoD0rtxWoYgbdyquMPDDAGvkOOH3MLfx5L75DYFV2h3sH/MPsD1tMvfGP4jKUWcoaSmvBHM6Qk8X545RMTS6bY7M+NJb3djUYDLe7FgavNsdx+fmUpQ5MMuqQoANtZv2uZ1tIvg9vLmL+EmdrThl0/+EjaEP+OrqnvAUSD1LS8w7ONZ2LICVVBBcc/fegYDYCalmO2bPozK1+JPADlE245zM5HblYiX0muA8cBbByXY5wtLTbnkgW0uReYrD9BqaLE7bhZPk7Ku2A38tDz7UqWwHvLwzk+t3TsMsGbSijJTM9WV9cKMtoJik04Mp0WowvoYXChShC5Xyq36FCCZgmpMjw6e3jExUzV9ayxcYNnE0PJQL2SqzqeruMr7IFoK7IYt+2XBJuHmdGNNU1hstV2x3OBweMeNRCzajGV/Q0i6FnzQ/FekgSvKm5tDdz/fNRTB5bTumgJyBH6vCRgaEufQGaGb2M76KaGNWSNSDuzivRC3M8FN1ABkXDJvPhvsa+1YTMImgjQXafLhD643D4BP3RvgUqEE9v9dvaSp+NQNZ5NE/mdhil0Txym5x1QRkBsv9KRTnsjB3SMP7Y25tn+3fw+ea9w3NUybr
 AkDkdU9L
 0o+9J0okCEUVWugDCHbd9/Ep6atKo8jixIGZYkNK4aFQqNYFgs6/pvaAgJXIxHC2GU/r8NLegH6DIRPlhO8BMtJnmQ+kE55JbEie+BeFLXlkSF/XITDnV4oyAMgu6E4l2rdpn9li0tMLbQZzWR64NwNkxWWxLE7TTTFgyXq+9FrpscRfP9Yv+MkvMkyhlQuA17sHY0Oca8ClEygZhBpS+Iz2NBCjAv8uJDZSbJx9Pgs91Vs1stBX/18GphoX2QWNSiAMHj8/2NqwwDMF2Pwis7kzUMY06kxLFSMAp2tcMyAlHOlMriYFGqxBazQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

The deprecation warnings for memory.oom_control and
memory.pressure_level use linux-mm-@kvack.org instead of the linux-mm
mailing list address. Remove the extra hyphen.

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 mm/memcontrol-v1.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index e8b6e1560278..178e1466d898 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -1182,13 +1182,13 @@ static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
 		event->unregister_event = mem_cgroup_usage_unregister_event;
 	} else if (!strcmp(name, "memory.oom_control")) {
 		pr_warn_once("oom_control is deprecated and will be removed. "
-			     "Please report your usecase to linux-mm-@kvack.org"
+			     "Please report your usecase to linux-mm@kvack.org"
 			     " if you depend on this functionality.\n");
 		event->register_event = mem_cgroup_oom_register_event;
 		event->unregister_event = mem_cgroup_oom_unregister_event;
 	} else if (!strcmp(name, "memory.pressure_level")) {
 		pr_warn_once("pressure_level is deprecated and will be removed. "
-			     "Please report your usecase to linux-mm-@kvack.org "
+			     "Please report your usecase to linux-mm@kvack.org "
 			     "if you depend on this functionality.\n");
 		event->register_event = vmpressure_register_event;
 		event->unregister_event = vmpressure_unregister_event;
@@ -2340,7 +2340,7 @@ static int mem_cgroup_oom_control_write(struct cgroup_subsys_state *css,
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
 	pr_warn_once("oom_control is deprecated and will be removed. "
-		     "Please report your usecase to linux-mm-@kvack.org if you "
+		     "Please report your usecase to linux-mm@kvack.org if you "
 		     "depend on this functionality.\n");
 
 	/* cannot set to root cgroup and only 0 and 1 are allowed */
-- 
2.43.0


