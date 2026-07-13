Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57DF2C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 07:17:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79E056B0098; Mon, 13 Jul 2026 03:17:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7273A6B009B; Mon, 13 Jul 2026 03:17:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 665A36B009D; Mon, 13 Jul 2026 03:17:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4578B6B0098
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 03:17:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BCFB440A4D
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:17:39 +0000 (UTC)
X-FDA: 84982898238.17.8952592
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 292B014000A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:17:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c9FME1wu;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783927058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hwd078SfSbWqZ8yo3wjpm66Fjg9WDFy+fTRvcAm+UkM=;
	b=ynEFBfTMjacbcFOmktm5MYvP6Cpp55GeefFcNIInaeES87rw/d/ovqfDCOTLcXYsX+3jex
	D2tQpyABSGDl8mSyTL9mrSOdaWQieAEgsLEaEuY0pX7xe2zFWNR/xjpURPFMErSUJvqQfC
	SY+v/7pJO1ALvY9rLtgsTzxMf470nF8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c9FME1wu;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783927058;
	b=ZohDlf0KGYxTmH3yrOYr9bJFaWPgN1RRcMUPmyWRnoyfiGdhHTL/LMzeOPuNfA/gze1IdU
	bSKRaLkVABWq/zQAs9GQ3Yni1KU7GyIhD1BcaSUB3rrVMUzPHLTYxBT4uH8l9Bh7K3+xRr
	Xlkir3H8cYrbE0Ww6bEYxkIe2OD0QZk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B326C60103;
	Mon, 13 Jul 2026 07:17:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64831F000E9;
	Mon, 13 Jul 2026 07:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783927057;
	bh=Hwd078SfSbWqZ8yo3wjpm66Fjg9WDFy+fTRvcAm+UkM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=c9FME1wuvshe3JefH5fc97yCGfSFLGlyfQzbOqHbZMegRzb6k0zRSqdoNrDOGZ2zb
	 3X2+AdpAPwaU7vPT+62vsFrLJjiYMLudeaBWOkEBsbpYvs0rR1bSH9GzMkF1OAIG5P
	 H6X29dIgl++yuwSSuhWdv+BllCwsbq0v+JtdUSdonTMSP7LmtSgLmBGNCIkKeCcX6i
	 65wvtmHS5YiG/T+pbng49tkH8CimMMrTJ8QK4prOID/vFKcuv0pMP1huakRgLsIDwK
	 ybdD81PM9GOz/IsGRk2VbWGO6DhdFIX2++f+da0P+mi6dBYZHaPfM6/tZ8HT2VO0pm
	 Gg/Zfvl3jAXQQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Mon, 13 Jul 2026 10:17:26 +0300
Subject: [PATCH v2 5/5] IB/rdmavt: use kzalloc() to allocate QPN-map pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-b4-rdma-v2-5-65d2a1a5180c@kernel.org>
References: <20260713-b4-rdma-v2-0-65d2a1a5180c@kernel.org>
In-Reply-To: <20260713-b4-rdma-v2-0-65d2a1a5180c@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-rdma@vger.kernel.org
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 292B014000A
X-Stat-Signature: hs4q9xj8bdk3zk7e4xxe8fqodoncxijz
X-HE-Tag: 1783927057-527058
X-HE-Meta: U2FsdGVkX1/xtJPpLTekD7E5vJn6LhIZw1sMZC1JZyyb19St9LV9qeqFHNgpB3NWe2FN7IOBIWqo7MDHPizyyXt54XomnRMFzjGu/s+D+VAOMj+DdLxGlPhlPR2uY5ZWApMzah23Hw8chi6iyigfxNqwk/2f6ESGSOIBRDAH+E2CG8tqifFS1smiX/Ta8z2ZN1aDd2/AIUXBq0kNNU+3TcrS3GsTAAr8uc6IXodgY9jnd1CNZe49I24+LrGyp9li+JamTbAhzyPN7FKBnqwmrEDcEwI533ZVWdbTLCa6axbHn93JjO+I8+WdzJZxTkNLoHOfxTBffI1yh6pq7VR3cJcS7bzrrwvF+c8/tyZg8AwE9JJvA/yi1GQh99w1Uy7Ck+wsbLUrE9oyOClfLMSkkk9HlhicERjjC2lyn5sZid4qnZ0qwZlvRWVpTvnoflbQuIio90eRWNMXIYKeObbRNZF4R0nLvI3t5Yg7Rd3aU0rcuFPYU14DcvelZMWl3ibgdBB5CrxI4ECX4g/t7No1gVptobUYKW4pZWCTRqbzyjaWfJQC/mpYuBsdp3CbImC3PA9kivtvYwHR+Vtkf4ew0RpWmDH+3hs5stooyCnsqkEJj8td/dgQO66CCq54j0PcjIltmt6ZgdWjB7KvjPyHJsY/qmpDjf8X/BoBpHDC8RRGbposfK9TkNiiwC1xemODHLqPlIlTZjee3Y/1UsbqeWud4d0sya87e7T3DKAE8cC8UmCCTBn6+I+I27OEBmodBoknzeOWpeuNNdHV87Hh24tc2Osp5NuLSc3Cs8u9kZsOi20Q+Yl9rRFsczVuf1sX0ZkKv/4qeOnu3Jghwn295cbQAMplrTPPGkLl7XFOsr0bBpq93HaAVDtCN19Gx4w4vROyeCC6ZNGtV95ykfXLBDOcbD5OEjW9Bfp8QSYPBjJ8sAz513tU1+vkHTwo3/SOmAUbLujpUjqHqjzJWpt
 no9Xl1Lu
 25b8lxvs5GJSCUe8TBjVDQdQ6y0lo7WiwaxMxHanmsldl7tX6p1pbJR7TeOzTgr2lQgNFgTA+P4lPFTvyj1OfJI7+QjZHDmbiuxiXXk1pM8+Rc2UPRmxOoIuhLNhmk3OPONlL4/hQdG4rb77zNgTCKZ1SvfT7i1cYhvBBamfbXqeUldnSTaQ7iR5egfDpNcZzprExmNh5exk0V3l9RxBKnA+hReYIlcXBRYKKWWULXLzbw6WU2/+2b/dHlrskI1h/4umSWtd3mQquVmE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

get_map_page() allocates bitmap pages using get_zeroed_page().

The bitmaps can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of get_zeroed_page() with kzalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/infiniband/sw/rdmavt/qp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 70e7d08fdce6..c40cce69e945 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -263,7 +263,7 @@ static inline bool wss_exceeds_threshold(struct rvt_wss *wss)
 static void get_map_page(struct rvt_qpn_table *qpt,
 			 struct rvt_qpn_map *map)
 {
-	unsigned long page = get_zeroed_page(GFP_KERNEL);
+	void *page = kzalloc(PAGE_SIZE, GFP_KERNEL);
 
 	/*
 	 * Free the page if someone raced with us installing it.
@@ -271,9 +271,9 @@ static void get_map_page(struct rvt_qpn_table *qpt,
 
 	spin_lock(&qpt->lock);
 	if (map->page)
-		free_page(page);
+		kfree(page);
 	else
-		map->page = (void *)page;
+		map->page = page;
 	spin_unlock(&qpt->lock);
 }
 
@@ -343,7 +343,7 @@ static void free_qpn_table(struct rvt_qpn_table *qpt)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(qpt->map); i++)
-		free_page((unsigned long)qpt->map[i].page);
+		kfree(qpt->map[i].page);
 }
 
 /**

-- 
2.53.0


