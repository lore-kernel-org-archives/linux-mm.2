Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D628C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 23:24:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1FBE6B0096; Tue,  1 Sep 2026 19:24:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF7896B0098; Tue,  1 Sep 2026 19:24:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0D566B0099; Tue,  1 Sep 2026 19:24:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BE0056B0096
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 19:24:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 59621C0581
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:24:43 +0000 (UTC)
X-FDA: 85166775246.11.981297A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id B7C1D180008
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:24:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IdybSuZf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788305081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UYsVp4S12kJxQZ9xleV3/HWxsgB9SxfAwwi/YHWmcuM=;
	b=zjOqxYTjibAcgM1UjtrZrEbrinsPPHW7VCWxGW+2L/rPMr9EdNUze5LUkXcsKIpZ2BBSyW
	wBYbEtp91KZjAQbkWEk01oRriHEewBG+9UscDpd4kSDKfjmhn5wYEGritS/79/rD3xMfkt
	BMe/cpZJC6xRw1myp/zB32d7BOlJhNE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788305081;
	b=RuqE/gv8FANqf2NCoOa8QLegcqp7gMiT+UBuhJnjJV4OwPU34Rqus5Mk2VPN/lLm0/z9Wd
	TGMBDZGb37uqwZBwrID5tyvF3FcMkIDNH/GCAd7XkslHwzljJAOndwlnwYQ4aFnRWqlU1q
	OqzEwiV736ayD3cnMhyONG2aRyYdfkA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IdybSuZf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EEF214349E;
	Tue,  1 Sep 2026 23:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2FCB1F00A3A;
	Tue,  1 Sep 2026 23:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788305080;
	bh=UYsVp4S12kJxQZ9xleV3/HWxsgB9SxfAwwi/YHWmcuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IdybSuZfHV9uKjVOOovxDICpVc/WEhejni2FnCnnPNQzYP8WPabII3oOraAPBAg2m
	 Hi9nWpk0osyKzn8ysNfhM1PSdNcE7IqE5g5BCwV3dTFojCEvwMwpOG+MjrzqA6IWiu
	 r61/wNV4mmw/dbwHpdlC3IWkevs360ET6min6myLHM9agWsf5yaSGa22nrfchdmbEm
	 wgnhubNrL5OVHjsd/XNRj9fpjRykACMpCperraUl4q93M8zImsMCB0N4NyJRmXTHAl
	 sjj1ST+7TR+AcXNzJWsc51J44tLbKP37O0omMiD8JtZmpeA9sIcD9NEk12ppAVA+gw
	 rMmGZA5QppUVQ==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>,
	Ridong Chen <ridong.chen@linux.dev>
Subject: [PATCH v3 3/7] mm/mglru: enhance cold/hot inversion handling in inc_min_seq()
Date: Wed,  2 Sep 2026 07:24:17 +0800
Message-Id: <20260901232421.40157-4-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260901232421.40157-1-baohua@kernel.org>
References: <20260901232421.40157-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B7C1D180008
X-Stat-Signature: fha9sqcxfbcfxx8jjjq3bdf1gajr6z4x
X-Rspam-User: 
X-HE-Tag: 1788305081-815269
X-HE-Meta: U2FsdGVkX1/sVv+app0TGzPXm3LDo9tCT8bNBcGcmDlE8rkMmtAhOTs1MkPqgYQooZF8R/xHBgTXGKnwGKMqy+a/8e1ilawTSWnmzPormuT203n5wLODlqGC52L2ujFeddfzwy58ZT0wUmngc/k46uuUF7InchCuvCQVXYGs1m4Eg9feboynBm+Ks5JUlrZsloTh3xIeQ7CXeHB9RpTYJzzK4sTB7V/bjYtRW4U5NZmjuk+RHoLHMyCYyj7Cp6+FhtWmfhie+APo0r8mnH345NmeaieqAuvu84vrZk8kXb5Z/bEJYmcE8MLHqEfNL0eF2WdRRSQkOB3szzjRolJ9pl7aXGXrCvFLgEBkOTYzyYXurTLGUt/z2QsMvMuCFIrHkLO1E/ApT+g5cEVSMVr92pMJvbUXDwvXi8DK4JW7coyJlOgidUAPWwpy+AvHU6Lxoup6QnlLPf6OpZv5NHq9+dI7FoPEoN1diPt0++BiUl2UOljrw0q6uZJNcV+Ja76/BY1i9/jdjqMigwiwCDNffYbovNnWXH5acOgUcG3nxC0nIkhdQNqP0jdNDxUK1xdwAVFfURNqjNYi0zY7y7ItVQV7LQvDtGJzLaKR4n8+8cXwHJGfLg3YQ/O6+cs9Ef/1OH8Fb91rwinwZjTymcMGqq6NWXVvwnnHKve5TJQUmqY+MKwbk8dETHKTZW83+tV+sYxntfcPsp9Nivu7R8Nk3BWCFNh7AYHGkwIpyK1wU7xPvOoJWIrAghbYGdgxc0rOdFl26lZWL25r6OYp898BLULZnHS45jjhp4aI2FdLLraApSPLYMx38nqSxBLS3GCj7KrsTUL7Qye4EzCR4vWLj6/JhW8Hh28vd7Sx7J/RY+Q8p9P7813D0MHremGAVHJ5oZ5bhu8lc/X0fjacJpazlxba7O96lDWknqFNdLICoYwy1ZGHQhU/IFYGriGC/nJ5JuQrDQL6L4//rKEMZoN
 BdApnZcD
 zplVUfTQ/iQBTr0ppaGv98GgcFZbqvUzNJwaDZEJvkAZYORjK7i+6+gEoTaAB/q0HE+X99Xw8iXj0VtA+vLQ3uhzCfZHAhLMihhkf8HBq5l+OdvgkXKrqASW935bCJ/6yBtakxuIb/lbdlOP4Wo9/oIj8WPO1+Bqf4dROl6UE6VKrcru4lS+xzJqWWpB0lGNqMkIVFxCv2HymWK6Nf8zp6A00I0/5adHw7MPavBn+Ktmy1Uv3jK4Km92+tkhfC7OCXDbLGaNREP/NrysMhIsku3mxZg+XTKRuxISRZiKClwkJk3JVNxN+JTdpjPCpD9FB7AX/kXMfI9xKRR7S+Y0dxZHtqomEN6eVjd7QH9AoBbka1J4lZjAqxQzlDEgBtgRL7DQtUrs4BiC0W8MT9rJrHkpenQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During aging, a folio's generation may already have been updated by
folio_update_gen(), even though it has not yet been moved to the
corresponding generation list. Such folios are hotter than those
already in that generation.

It makes sense for inc_min_seq() to increment the generation of
folios that were never promoted during aging and move them to the
tail of the new oldest generation. However, folios that were already
promoted should instead be moved to the head of their updated
generation, just as sort_folio() does in scan_folios().

Otherwise, promoted folios could end up behind folios that were
never promoted, effectively inverting their hot/cold ordering.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/vmscan.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 27494505cecc..95d48f9efc09 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3949,9 +3949,17 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
 
 			new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);
-			list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
-			if (gen_increased)
+			/*
+			 * If gen_increased is false, this is a promotion. Put folios
+			 * at the head of the promoted gen. Otherwise, put them at
+			 * the tail of the second-oldest gen.
+			 */
+			if (gen_increased) {
 				delta += nr_pages;
+				list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
+			} else {
+				list_move(&folio->lru, &lrugen->folios[new_gen][type][zone]);
+			}
 			/* don't count the workingset being lazily promoted */
 			if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
 				int tier = lru_tier_from_refs(refs, workingset);
-- 
2.34.1


