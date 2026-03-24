Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 264B1E9A777
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 11:50:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64C126B0096; Tue, 24 Mar 2026 07:50:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FCA76B0098; Tue, 24 Mar 2026 07:50:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EC1A6B0099; Tue, 24 Mar 2026 07:50:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3C5F26B0096
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:50:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CE491141B20
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:50:21 +0000 (UTC)
X-FDA: 84580788642.28.7A91A0F
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf12.hostedemail.com (Postfix) with ESMTP id E63224000B
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:50:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lzTs3iuR;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lzTs3iuR;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774353020; a=rsa-sha256;
	cv=none;
	b=TpV6RKbJL7Xef0p+EnvuCBUWMF+8H9jAhOgYBzSO+iyC+laeOHnNAYvkUosGeesTdxzYhB
	ArF0sr3OJj91zVPU2Y/BJC6uK5d3wWNvFiL644WHS/PishIMirHeujcMDg/j8EFihQBoAz
	EhrIwI2qYVkgal1pHs0buwaUU2kIPUM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774353020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1H0PcRwRWsj1424kk+Vkpn7bu1YblVD7xgckWcbNsX4=;
	b=imgwGUy/X+F98bO0rdE4ZqVJiGMjlqiW9kh31ImZ7NtV8NOfiPntggTJUtMV7thfS0TC7L
	CZWa4snU4MOv4Kow4JQcYNDT6Pxfixp/byGZmDSEDLIWsYVAuOXRy4OvvgEVoA3HFxAdNK
	Xa4MeksiR2ECztA5U0COlbv3xFEfQwc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774353017;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1H0PcRwRWsj1424kk+Vkpn7bu1YblVD7xgckWcbNsX4=;
	b=lzTs3iuR1Pwv68Prted2fEIVq4VUS4eCdaB1zvJOFuJdsux7ry8b1utL9Ph3MCObjnAYzS
	3aaZ5KgPl44IF+KmJUNzrTv+ifD33oSkuTsr01h/xiGYiqN0Z3wxbXEuXqg8gVpNpLhQLZ
	rabGQdpt6g4fUHahmu88tNqiWC/qb3Q=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev,
	bhe@redhat.com,
	usamaarif642@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH] fix: mm: vmscan: prepare for reparenting MGLRU folios
Date: Tue, 24 Mar 2026 19:49:37 +0800
Message-ID: <20260324114937.28569-1-qi.zheng@linux.dev>
In-Reply-To: <e75050354cdbc42221a04f7cf133292b61105548.1772711148.git.zhengqi.arch@bytedance.com>
References: <e75050354cdbc42221a04f7cf133292b61105548.1772711148.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E63224000B
X-Stat-Signature: sq7wuje6jdzi581gwscoupk8zjhjtwg6
X-Rspam-User: 
X-HE-Tag: 1774353019-815816
X-HE-Meta: U2FsdGVkX19IvttMEp0JfS6UK+fhVE4pJKy9yI4tNVjarJvePk0qnAgfCYWdAbSsyuCIVprCVi+r5anyIiPpbxT8VSyckuDkBWz8HYhzP6WIxCkyxKR7JFUhQvvqiTcNM0OuQX3SDESwms76VdH7bzYhRy+4e7J4WSZB1gMdanvhigZ6ilhuG/1jl5mgcCynZZD6acWOyYW3ftzdOGJTrO2Aat0OX+INkCSH4mpPWBryLUE8DuHZdE+1GjEdqFHH2OjJbcMvKGtQJcWNTmTJLc62bDh5R6Fo6o8vHaNNM8Qve0YvYmwsIlnz/wuQ0IA1cDKkOopqGXL7SCbokYTGRkPB78xsNa9e65x1ZmNfHH6POAvg/GzxnfQXhTVo/a+1zpk+jYpua/T7c8xhr93/ff+w/GqG8B97b9LdXgCAQrWvOdy6TKzWflcSG1rWIVjSgdP248Hl/X9LFBnMSojG2mvy030+VEFZGxOUsVmENrSXMghEtNy/nu84wdNDi7hKPMLPzFd/CPb4hJ4DcX1FSaJNVAfUBFToCOVLQ2LBUsUDT1KG8SKZZ2uvBdaknD4w19Ic38+32e3AVNVYHh4PT1UkQFlSXGkAFqge1kjYcWoBIl1lcbFbzZtHGlIWA21WF6iqS/gF4qJd7gIL6JVMll+b2bwkLpScOaJt/3XcZEMTnK4IKvrUVc5/VLrDHZgSKxv/5yFqwM0HmQBVtTRlw63UXWTNw/5ele6GtGelvEgstwNURDJYVOrk9FrfL9FEZbO7OLeXdVvabajTVvd4XpjuHgx40ZsQy5Kr1h9YOhdhxHdb8c5TsDhOJ89w3Z91/lLqgI98yR/V94fen8TziT1AkDBSyxhzshlTgHQ29isjzJgsbQ5WB+upeuwW7enn4KgD+cbfBCz3RlU5cOqNV6xH71ddJgrUTv9sVLJuEkYiZoPcfPEuSwQ3OqGjROCb03gujBbdwBHCOsDAkIo
 SxtCSg3G
 FJBFYkb2VyUhq6aEWFINBujCGZjLrVamUmCuglHc/GJFyNIr7QpbquIBxCb5bmFA8fv16/nKD8clCYwIrSqIrtma64e9fOAYrXuvFF/qGey1gq7KnKIaUM/4ZTIFmtvbu1DTUyoV7kTgHsnyU6ppt+hFoU/6vwfPdgK36XgQWmjEiNpZjpyDflmo6JA2pxT1Tr4FWsdbiv0LtrKlEyCeOFjr5jgZCaIS6mtNiEHdq6NhmHm/x+Vi0d27zdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

The lru_to_folio() returns the tail folio, and the lruvec_add_folio() adds
folio to the head, so the tail page is colder. Since we always assume that
the folios in child memcg (about to go offline) are always colder, we
should use list_splice_tail_init() to reparent the child folios to the
tail of the lru list of parent memcg.

Reported-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/vmscan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 33287ba4a5003..e4a1078254ff1 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4524,8 +4524,8 @@ static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec
 		int parent_lru_active = lru_gen_is_active(parent_lruvec, gen) ? LRU_ACTIVE : 0;
 
 		/* Assuming that child pages are colder than parent pages */
-		list_splice_init(&child_lrugen->folios[gen][type][zone],
-				 &parent_lrugen->folios[gen][type][zone]);
+		list_splice_tail_init(&child_lrugen->folios[gen][type][zone],
+				      &parent_lrugen->folios[gen][type][zone]);
 
 		WRITE_ONCE(child_lrugen->nr_pages[gen][type][zone], 0);
 		WRITE_ONCE(parent_lrugen->nr_pages[gen][type][zone],
-- 
2.20.1


