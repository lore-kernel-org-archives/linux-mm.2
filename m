Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97977CD98F6
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 15:16:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 592046B00A5; Thu, 18 Jun 2026 11:15:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 569EC6B00A6; Thu, 18 Jun 2026 11:15:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 432D36B00A7; Thu, 18 Jun 2026 11:15:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0FE1E6B00A5
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:15:45 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8BDB01A0179
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:15:44 +0000 (UTC)
X-FDA: 84893383008.11.C95BD11
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id E0E9320019
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:15:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AmQvilKQ;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781795742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8lJ+DfqLbL+e3xmXDpTayP9ovqvMIBlFf/wTcMrXgNU=;
	b=CfsNyu+IAPAEIQDPbzgpEt2BpD8kRCiV++N8Ezc3SEOiru1aqQfKHMvrnksOAUaf6EMsPp
	v7leDv5px+HpiWkhMODiLcwJ39r5bC+Wnn2wCrmPNnz8N1pi6zVYFRY04Jf4SFx4LcDbmP
	PF9SeFQNzccbZXkr1IUgbZQcGhI75ZM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AmQvilKQ;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781795742;
	b=q/xKaZqGl4uqq+1rvPLEPUvogLWoADesQiSIreFb/hhDpvzk8Cnqi6xoSJAMqTDytHR9iN
	9bVjlxfcJWWssZ7+6ed2Bg7n/fP5UfBFyWLA/vCZYgdRsTd4cjE/g74OOOcs3PCGns1Sq5
	XTJ5DrG96dNm7lBuz+BxdQQz7jf4HKw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8CBC960018;
	Thu, 18 Jun 2026 15:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2704D1F000E9;
	Thu, 18 Jun 2026 15:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781795742;
	bh=8lJ+DfqLbL+e3xmXDpTayP9ovqvMIBlFf/wTcMrXgNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AmQvilKQKiAQTwPw+BytnN/wnaNJm0hH9+u/3nuAGxdINTbZ5O6sIJ+YT0BYbuMh/
	 JL7sfuiNKOa4v3nsupCan6rkkod6Be3N7qjhpDYVs39NGdZOjo82YwVBViGJP5Nkw1
	 104ONUQZRA9AGCGOo83uYwbE+lB3woEpEfJjegb5p7kFWuaY25vdSsp/8lekzdXLiF
	 dSm5zo2iwOc8KslQErVMka+imOKOs0ujRGFJedfB5ofG6pmhMD9dRSDH4VOabLNKto
	 gSAstARw/s0IMHVJc03jVYLI9aFVl5UMHDcta86Xx4dcdeHW5Owsl6D5OLUC263TGV
	 4djzNQ8RKILcQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 11/11] mm/damon/sysfs-schemes: kobject_del() region for populate_region error
Date: Thu, 18 Jun 2026 08:15:15 -0700
Message-ID: <20260618151517.5366-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260618151517.5366-1-sj@kernel.org>
References: <20260618151517.5366-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E0E9320019
X-Stat-Signature: wsp5ro6hqcjbb45cp614q5sr953m8q1m
X-HE-Tag: 1781795742-699145
X-HE-Meta: U2FsdGVkX1/0CLxn9G24jbgvbwtACU3wk/1RQfRCGC9zRoMB8VAf1vXYOMBH8fb31SIIpsvvw0nsPvi5rb/3CKWcWC6jMzExjdFJeO9s0nFHDEOn5T/ZnF/CL0Jt2eIKhkga0taspwsU5BMKYQdzD7zVphcRLadf8JXfrbTBK9orsDEeifTmzlWGn12Cly3TITjfAw+ztgdRKroqN/O04lknS8DESfXpZkgtK9D9V7y0QWp4t/szt5Zd/H2g6BMI2IWkSq7DEtbpR+54n/EDUAw6DWn36R3PWo1ad+Wow/nRfQNd3ILPiTDI12AYLFk1us6vduURph7n3mlLN1llNl/uEgnffhz3s9ON+Ezl/rVUooAm05qv2gQcmdMaFHhL40J0Nc0X+g/81rjPmXmTiqjuH/WRU1KFvi2RV1fakvFHgMM9HDNAeW9aZybKWwxIYGhxDMKSk+O9U3k+z4HpBVrTAtgLHeoMQ7mG8qKc4Dpl4mWJGHnMiTYbq1Vyzrndqfm6PLTzBFlZWqXrJqJmz4Z11Zq46D2MGhEBVWRlEhiYRhH8zyeuKDqHZLssY8hka9NRAaWMDO6sVsulgeEEEuFQLy3PtEtktCSA6ZAye3ZfuiKkdIP5WYsIRNsQhFMuloAfx5bEudrSwpGEk01puGWeA9GMjywgzMTmbxcV3+KBNUrqH7WUDcVV3iy2YNnVw70tPcg2ACDskQUm1lPCme2rr47o4lrbvNjJdih9YswThoiULBhEbzPbbKmZWTez24HHvhU9UPV4z2frabHhqMBUNfy8sQ/gKMd5LZw3gV04lwfoQMsJsnAbR0mdvxJKK+p684kb+tkwglNiftP6T7Z0zhHY7bgg9QXS9kmuk/MtXFCGNAGLA3Fl9ObqLoeMn5bMP5+r7a6FD15hRaKqo+FvPan6qOg9jXkv8czMVm4fUyfBvXiIKtI8bGG5wOuzsYcv2p2hUi9CPmTOCNV
 ZKcsMwzR
 PnrTWnA0EPdFseZTnfdNuYrbKs+DzSIP4/BPqIrUVT/5YwbHy7DnTG/o6wAQHnTIo/dookPdeqtw3A1L7CpPg9OmmcZOuEGXL8lWoPnq5LH5icU0sJS5Ymo2ywMZGML6IQrou2EznZbDJq0dDdyhYKx6qcaAD7E5RQd6CyNkE2vUR12ywM6wQXMWtnv8GUu42csfWlX/x25YKSIzjXUwebdhb2cM+0AVrqEXLbb+o0iKmmHNSwQ4AtY8vXr/YGx4xdHZY+OlcrAMkrRCfsgC6q6mTjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts.
Fix the issue for tried region directories in the error handling path of
damon_sysfs_populate_region_dir() by adding a kobject_del() call.

Fixes: b574a82d10de ("mm/damon/sysfs-schemes: implement tried_regions/<r>/probes/")
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 0d4e9b053e381..9d8fab32b80f7 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -3134,12 +3134,14 @@ void damos_sysfs_populate_region_dir(struct damon_sysfs_schemes *sysfs_schemes,
 				sysfs_regions->nr_regions))
 		goto out;
 	if (damos_sysfs_region_add_dirs(region, ctx, r))
-		goto out;
+		goto del_out;
 
 	list_add_tail(&region->list, &sysfs_regions->regions_list);
 	sysfs_regions->nr_regions++;
 	return;
 
+del_out:
+	kobject_del(&region->kobj);
 out:
 	kobject_put(&region->kobj);
 }
-- 
2.47.3

