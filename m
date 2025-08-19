Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C23BCCA0EE9
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 06:21:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04B416B00F0; Tue, 19 Aug 2025 02:21:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3D876B00F3; Tue, 19 Aug 2025 02:21:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2C866B00F4; Tue, 19 Aug 2025 02:21:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CAB036B00F0
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 02:21:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 07E5A1DBEB0
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:21:24 +0000 (UTC)
X-FDA: 83792510088.21.0F6AE5C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 63DA4A000B
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:21:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gsDE1Quq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755584482; a=rsa-sha256;
	cv=none;
	b=ebdVcaKqMyNYwzEPHD9L7bQRs4SFZ2EciNR8PcmuKFTLfK4Rx0KM49Lg4wV59RXZtgzs+A
	PBu7av+bZ1/JaP3oca80mBzG4rilwrIvsfcGEE0wZarT4+nwf5SE0OgJarv3nJTf9cunP2
	EdyfXRfd0FX5hwLRSNimBCvgu63uPPQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gsDE1Quq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755584482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uPC4shu02pNCJ38ypDBc+xjwZGH6uV2euDtWYG1Ec4w=;
	b=019+41QtsQ6PH7frLphbLk2/pkMn2kcSRZM2a9GAF/3ZytigjUJkLnrfmHN0CSi0SgM30W
	0lGlT1yIMBH+JHC/LJDHYNqtir4ZCQbG4INTZvDWcMKuewuUC8ASHAnUais6gcFKXjhrQC
	fOGgijcRkqe1WLiFxnXhsWix2PithfI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0409A45EB6;
	Tue, 19 Aug 2025 06:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581E8C113CF;
	Tue, 19 Aug 2025 06:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755584480;
	bh=pK6z1L1/qDmQzrg1OPWWIWzBYUAMhdhzZuy4QSxU5Lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gsDE1Quqw4qHQJ5SjoAEnnm3JcfpezfrbeW1TXMyTgdL8BxySsQZmeXLkxX46SsTv
	 rI2L+9ka80CC9uM5d07yraLnDOsczECvhb819Fr9/FyXfh0QLtPuPVPSlLFuJyltp8
	 fe8SC5C7FiR7mP0xknSkk8ZGKd6/ZJ0zmnw+lPkGD8no0TM5T4WV7kTQJLRpacvHJo
	 P6VIeUt5BKJ25oayTQVELmIE0rylJR3ck4b1vSy/hDQ2Jtng7oNmA3pyvzvY19/lWL
	 ukxbsvBsdqvXsqM82xqnp1qBywU5F+NCg+PCsXgDFKc9VHIHFdQzufTsSUwT80vmIv
	 ZhWLGR7g/+QVg==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [RFC PATCH -next 05/16] mm/damon/paddr: support addr_unit for MIGRATE_{HOT,COLD}
Date: Mon, 18 Aug 2025 23:21:16 -0700
Message-Id: <20250819062116.39593-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250813050706.1564229-6-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 63DA4A000B
X-Stat-Signature: bhj4ga1rshn19t6yyzq8h3mpm67rfi6f
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755584482-719723
X-HE-Meta: U2FsdGVkX19ISzIEVk+a3mvD85oHcM0BPJrZq76X8aqFKUGpN+qTWze+UC+T1OKV/v6qYJaqbUtw3RCUKVQ9xJ/RpiFaB1YBOcOVltYtoX6iUqtEJpabsGi+sVFhQaEYW5pV7kiYQ3jzc1wf2NLy8YYk8f9xjyitwfBa6xsUW7trCK4sAYMDcwy0fj4RC4VI7iJIGa2HUCs6ImwkZIMNO32gDLzvK3P9dwNf/1Fbpvm/uHjmVjn9yKvxhY4bC2ITkQcfi7OUGAdg0V0aSXe9zHe0pAOatz7okm+4fOziLv2yNi0cV1mXp4x3Ijm9RgRDuGkkQoepy+v8Fjh+1fQqfqKl+lDwPW8xsserdtEm2YnM1EIwsqhvL36GBiN2GIUT3ejHSNFx3BLuzQOQcXWbormVS4I7fYIppI0aQcUzIMDaBX3dD3rlFshKNghUTszQFcnMGSfUajqx8xHuVL4PibJHNRXNU1a47nOjTKCppK0kOpgIlwlHUyOoffEXosUWUwn9HhfCusv8hS8auNOs5vj5RdyEtxvIXRiPFIOxMqErRzomoYVio2K3iHHbQWQ0G/L/ZyybR2W49mIQJSC4/lL4YO2h3KWalANRx7XDJIsKPH32MhaiLfwokg+Ey+y/h48Iu8sYTEHTtwsai/4Qg5Zo55AzJsWqzGape+3kCiX+dhxA5M7GT+59Bi+HvWK23Cke6fwJekFwj5XUp47s6HDt0nVm3PZ8WV+aXJX1KaeUhreEAb7gnVtf3uRimseoGmk4FNB5G1cbg46rQ/dz3EykNNHwwQTC1FTLyjcnhqhAAC2GDGY0YRrgbijau6Bv2DQUTffSmmme9IRz35cjv0UTYqGIITP3PWBAyRg43aA8/LsIfB5OFkVpBGORLrQcn6/8sO+LwoiAE+673imOdAxVji8v0LdhDkwZ4ePWL9NaJb42cYafaML/xGOwPA8NfVTcHo0AUe7rLmJ4WNU
 evORF4yr
 cwp1r5Bi1nNpr/oYRfIo1BW07wPGnYYGP+CEQlYBVNjlpFUGf5E0tW+yx70cz4Urvf12JswzJypjSGfXfECWUWaAV8E8d7PRom6MXkQc6Uz7JMlio5cRdtcYxMre2BmpXGoVYgF75p/xtugULHwGj/9LxLicDmSs/D/Bf65fNQps1ogxjTZTVC21fXV/v6bNs0EZZ1pHtj7GIEbRIVWRwiS9W6U1FVAknlE7QlNOY3L5dr4C2FQFvjlxFUmQVrIlbuKNTRTl40+DcUnTSNOsieppGZg/6F9Q0LEg8coCT/bFv36g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Quanmin,

On Wed, 13 Aug 2025 13:06:55 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> From: SeongJae Park <sj@kernel.org>
> 
> Add support of addr_unit for DAMOS_MIGRATE_HOT and DAMOS_MIGRATE_COLD
> action handling from the DAMOS operation implementation for the physical
> address space.

As I suggested on another reply[1], please squash attaching patch to this one
when you post next version of this series.

[1] https://lore.kernel.org/0001-mm-damon-paddr-set-DAMOS_PAGEOUT-stat-in-core-addres.patch

[...]


Thanks,
SJ

==== Attachment 0 (0001-mm-damon-paddr-set-DAMOS_MIGRATE_-HOT-COLD-stat-in-c.patch) ====
From f491a6a940444799dfe1e76433234d1849a21c58 Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Wed, 13 Aug 2025 21:27:59 -0700
Subject: [PATCH] mm/damon/paddr: set DAMOS_MIGRATE_{HOT,COLD} stat in core
 address unit

Operations layer should set DAMOS stat in core layer address unit, but
paddr is returning that for MIGRATE_{HOT,COLD} in paddr address unit.
Fix it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/paddr.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index bb3b149b75ba..0305e59818da 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -247,8 +247,7 @@ static unsigned long damon_pa_migrate(struct damon_region *r,
 		unsigned long addr_unit, struct damos *s,
 		unsigned long *sz_filter_passed)
 {
-	phys_addr_t addr;
-	unsigned long applied;
+	phys_addr_t addr, applied;
 	LIST_HEAD(folio_list);
 	struct folio *folio;
 
@@ -263,7 +262,7 @@ static unsigned long damon_pa_migrate(struct damon_region *r,
 		if (damos_pa_filter_out(s, folio))
 			goto put_folio;
 		else
-			*sz_filter_passed += folio_size(folio);
+			*sz_filter_passed += folio_size(folio) / addr_unit;
 
 		if (!folio_isolate_lru(folio))
 			goto put_folio;
@@ -275,7 +274,7 @@ static unsigned long damon_pa_migrate(struct damon_region *r,
 	applied = damon_migrate_pages(&folio_list, s->target_nid);
 	cond_resched();
 	s->last_applied = folio;
-	return applied * PAGE_SIZE;
+	return applied * PAGE_SIZE / addr_unit;
 }
 
 static unsigned long damon_pa_stat(struct damon_region *r, struct damos *s,
-- 
2.39.5


