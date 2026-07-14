Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48010C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:36:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 804CE6B00DC; Tue, 14 Jul 2026 10:36:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 718926B00E3; Tue, 14 Jul 2026 10:36:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51C586B00DF; Tue, 14 Jul 2026 10:36:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0EE896B00DB
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:36:00 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6CB9BA0355
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:36:00 +0000 (UTC)
X-FDA: 84987631680.14.1770231
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id D3FCB18000A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:35:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gVRY1QaL;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784039758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OgmQTZfSicG2akeujY0x1j+uFMrq86YzkqctonivABI=;
	b=G25Xt13WgGUJhaE6DKCdtgyTV4YOuWO1IU9gbKAWiMsuUneVskOjnxJgZTTphb7zDengSp
	k9mbi+miCHuSiAAmgqF4yalsOJkLFJxE+DetjU9TNY7H4I4xoeUKvilT5LqEGw6StXXJBW
	fYakxx6RQ7bEho2HbrVNwVp/inYoj1g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784039758;
	b=aYsVDZFD4bh3VvPTeqvQfZoYv5tfYiQHgx7tOGXhzcehmW7skuhNyPDP12GESziTVqz7uv
	1jhicXXPWcO1QREVYFXdc8LBcG9mlN+pzzH3ZpPQxjpoaJcpBGYc2UkLyri/aHJXzUCdZT
	UVpuPOwdWhTBCc2YUIsqiRQ3DdcwXaw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gVRY1QaL;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 811DA4378B;
	Tue, 14 Jul 2026 14:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6B01F00A3D;
	Tue, 14 Jul 2026 14:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784039757;
	bh=OgmQTZfSicG2akeujY0x1j+uFMrq86YzkqctonivABI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gVRY1QaLUrnENVs/P6aecaAsLZJDki8N5Y9dQKHfDc9nig/jiF76Q0r58NFLrmaj/
	 ihSLl7NALNFXfpeSQSwl37bMGd9kSgnNCzoU8F/SBs9UEe4G3Mt+ZPD5g9gWvlYL7c
	 lamxCU932bBFGApJ7w7+54iPHXXFC61uIvb7ofYIr7u1EqRa9DpRoFrcKNJDLqwJCM
	 GNw2B1QrN8hmwOyszVwrZ6GGu6VaDtDJmon56hPOztKv9QMEDE5Yq1YeMnALd4Rw2A
	 2Cm2KNj63xEM9B3qt0VW/KzYvmxreAoLhjc/2OJ6sAuuMmRpsetl+DjkDIfJERn+J3
	 Ah6AaN9gQUJ9A==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 07/10] mm/damon/core: hide private damon_filter fields
Date: Tue, 14 Jul 2026 07:35:40 -0700
Message-ID: <20260714143544.101305-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714143544.101305-1-sj@kernel.org>
References: <20260714143544.101305-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D3FCB18000A
X-Stat-Signature: q8pxursfh4eqbjn396ypqbztax4659yb
X-HE-Tag: 1784039758-252478
X-HE-Meta: U2FsdGVkX18OZ55DyoyuXbOqAXnIlQUWdehaXEt+qmQoHhugPB0z60nVJ8KzsGN7Lc2T95mHyUbh8Uvm3DN0+LxrzLhz3lZQRn1rnmIdIR+rC99WLGKeejGwHQTVDnWphw23t7TKn76oEh1sVF5oOtEmn6n4OBSLY/j1hRppWkjK1W5vDUHOw8X7CCdQxGhJ8ji+v9M9r5Sa/VL+ryW2zh4G58Rn+wTPFPGvmQTH7Trsiw74861Cp/jpGXh56K2arbnBqMY/4fQDrmxAYhcQmCjv6dzq5S5baaUDM9r2z9gOhH884v5G5VJ2TPC2Q/UDbQCENU6308I262l7nbUCdU07/GmTzhNFh4N/O1FZCJwKPRZgjJNUStwLz1AgqitEkTBrBL2ZLuGPlAgM8zQ7zBWJHkV83WRZFm+ZVaCYMhjtEf8VpY1XjWdRvGgLcSgN6DJbSTJS+VsulwWh1hai8SMKSiPk9cB2hk0rqvyPAcE6YmNtWdAQtyOoizjdkaKk5fHZTnEgj1YX+/z9nbyfqSNB8KGe7MqY8J5qvlcXAQZe2r1ovjWAZm0oMqj+U25umgTbJKQlBjMeX3QaB91k7YpWKqd/b8pb6yJ+FRzoyQcfhFdYX9RJHObceyhQQGraP0YwGjKiCWIaax4w4nOVBSXbksIfyL76ZiGAPrbcuDEs1YoA9axaR3x5zLpz70yvGAzYZkGELN3lczT+Ni14h5QQV/1CZHrCmB2ZyX4E4VWh0HMvdCO2uETrDXtjTW5TY17tM+MsMRN1UMb2I7hGxFhbbHb+ODGwtbwHKKJ00Ye5VgwrNeve1YqCmEz+bVUnw8IcV/PYT4IpII4Gq7fDjzwXxzsvLvlXR2RnhvqZNS9XMoCPPTwOvcFjpGU4/WuIc6/mXaBbry7gnHrXFB7B0Eq6nCjknW3UlfushIgwi9DmjbHOmzTCXGMCkCysPXuJNr1gaKP56A0VtNM5ocF
 PAyogTAY
 iPds2bUqXoYH07pvJ68GXfiRm9FdLH3RPHabbaKq3Schv6uLWDWjuPeiKCqKwJZxgKSNVueTd+byBfejRqDrHyZbPHnD9gUIM8NXSzbWDAaHhyWSO1nZQv5MSZLpqpP79J2+olYatKv9ChO8VyY1nkawXIM2DJsEL2pfalZi+t9NosRDuqIjWdPo+KQrB8KfxwgZNDecQ4gRFST/geEazGZax49q4eE1sBVm/Gt9NzoBz28VoLbgnM4KV4pb5c9uXtkCy9XBsxHrO1Yuz4QvmOc3qmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_filter->list is intended to be used by only the DAMON core layer.
However, it is mistakenly not marked as private.  Mark as private.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 907d65f03d083..6c3c7c75b6ca3 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -758,7 +758,6 @@ enum damon_filter_type {
  * @matching:	Whether this filter is for the type-matching ones.
  * @allow:	Whether the @type-@matching ones should pass this filter.
  * @memcg_id:	Memcg id of the question if @type is DAMON_FILTER_MEMCG.
- * @list:	Siblings list.
  */
 struct damon_filter {
 	enum damon_filter_type type;
@@ -767,6 +766,8 @@ struct damon_filter {
 	union {
 		u64 memcg_id;
 	};
+/* private: */
+	/* Siblings list. */
 	struct list_head list;
 };
 
-- 
2.47.3

