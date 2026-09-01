Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D91DC624D4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:19:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB79A6B0190; Tue,  1 Sep 2026 09:19:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8F496B0192; Tue,  1 Sep 2026 09:19:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A5856B0193; Tue,  1 Sep 2026 09:19:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6CD0F6B0190
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:19:02 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E4162A042E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:19:01 +0000 (UTC)
X-FDA: 85165248882.26.9C58F26
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 43B9B40009
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:19:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nggKh11a;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788268740;
	b=wZvWg9Te6PMzKedcntm9czdYS4GlZ9q6ez7ozVzJ/tJuIUWdznKhAY4J37arsgBtcnlDpW
	raO5UL0a8vRINAHB4iGIMoUmBwVNN/+CIEFwYKIMH1qJ3oTENQbyyZJENMim7QQDOXGVNf
	EWlT8t5K93KopKGMm6sKIe6Q4cG3PSk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nggKh11a;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788268740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l4DJBfV8Ln2wiu4MTHaklCvhtPpo+9nKnYvuVasq3nI=;
	b=yJk17Q5dKCeVlJ91DMbsvI+FfDaqte9mtltsfrN7eaD8p5i//5rw7mdxLI6S8tuFuSBATL
	Et4HYRuP+dSFDR4SjLqXbtgLu5pJf37FpLLN5Uj24Xf2XjNHZOLptGzh5m8xDbutNVsubr
	i8hjk+fvx8LHsmYuTR4Kqfos0sLUVyQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D97636053A;
	Tue,  1 Sep 2026 13:18:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 586211F00ACA;
	Tue,  1 Sep 2026 13:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788268739;
	bh=l4DJBfV8Ln2wiu4MTHaklCvhtPpo+9nKnYvuVasq3nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nggKh11aISb6Edpze86CzVlB4WBkZ3fPZ+n/O/cHOag+W5A+rql6O27cDz3C2pvYC
	 1QhBjHHEW/DjEwkGXVPzDlWClgNwV8yIe07WhxXH0dHqMZWCbZ7gDiQFgsHKav/Gty
	 Wb/988mjBSPtVmlxQh4nWp7OUIm+s2j6fuAK2SgFQJ8rpFQO5bkXdO2nAD4yGBSVQb
	 KInfTX0G1tWJx2JhhM7yqE9RLa+gB+jbd1wEx+FbydFDkDzXjACkibCqytHJrWAshW
	 95hyaE9AXB+Ops7olWTX51woHk3Mqs9k3BnUuaEnUvO6awgn+aie9+/iqqqZGE5BEH
	 hOvv0Sc3CGyHQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/8] mm/damon/paddr: respect folio end for DAMOS actions except STAT
Date: Tue,  1 Sep 2026 06:18:44 -0700
Message-ID: <20260901131850.98037-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901131850.98037-1-sj@kernel.org>
References: <20260901131850.98037-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 43B9B40009
X-Stat-Signature: wuk6wbekxjhkydxup5wxqzshdybgd1k4
X-HE-Tag: 1788268740-235352
X-HE-Meta: U2FsdGVkX1917snuMBhBZ5Vd9U512TRG+t62wF/c5bFh24X8zu69LB5racRtTyJvmkAlWiSnKCqag1LvWM9jzv9Kpd9yUy7Ml3IIuaITrerL5HYvPYe4zEWhlkmLWoA6kQ7kCyY73vlQaojr85XP2+xSIioZcrmu092ztryHUagNtAiFdal1pBsTN4qpFOZfV06hAfxU/I+NczhzC0Ewupg2Fr4E/0rFgSkL9oHCUvsrVbx4bTE9s9SPhdlqPSeC+/ozp7NDKQJJC3Xz8/zz+ML63smUPIhAmAuNezTsoYcfL03vm7T7Wa6cBjiIDjgIB9YehHB0Ve5WyM1L22kP1NZ3rks0mnZBvn9Shyxt+JyMADlChZnmLYU1P98P90UeebBPUrGBaO1yXXT2jdyBfEPzBbe10HPFF9nh+on+EHWZdC7u6uAeACYeGgncDHUWmjHYt/lM9wEFP+vFxeCmaS73KHqJ+7S9pTZjdB2Q9IPtJz+EcgevoGNnsNNoaAChHn8vSGQw3wSitaeqL+xyw4YPUyqqMbvMbO9kv0jf33fXrclz0Vr8hOGinMhG1SlKx13z8SI2OCmAM6HYqvgaLizKQYg2YJxqAiUkiC4sdNyBtZSE5Zto6PHqV3J9oLzPHLk05gBiwe28+2aFRAdXMHVrtVFz/nOpq2BTGVw7QxE4ZZP5VYzPrh/qyErEpA7T4ocI6rP4jR8MQEWNXC3J7crS1aCpXs6bMz2lBfCHhfAg5LvVeFpUCp1Rnt2Tylfr94GcvloZArQ6DlbQS//SbJlRyVEW6cfepfhRbUn2RseeGwFSYSlHUd4aqr0DmsLwZOhVF8YHilR2jpgic61qTKgShNnQNnYEg4X1Ttrhjf9nNdoho/yEItn+DnXvF/whM6d2rTMBPntTLD23i2naYYXQR0CJSlBIBRyuRovN/O3xvU8SD3riQRYMGEccj/alxtUWNlTPo6OoyE5M6t7
 V3SmM3El
 fGoOrS7xWVmBlbUX12bZCDmhtdTZbx616ZYRJ8HxZUcR6990LrfYoVDzYwQEs40y5xAtYrIVsjEaR5iKkl7bM/URq6Izy2taFa7MUlVU4Lqh4HhUGA0nx9aIwslYAwTTZ47/hww2ZGqHVH7Z3Zdx4HtfK/dzWus7Z5u4Jn83+xWWfAIdyVrtYR1WVYcs/Yvblj1n3DOpzePvdJznnw4PYJxvLcPF7lLRSJ736Jd9Hzoahklk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A few functions for applying DAMOS actions including pageout,
lru_[de]prio and migrate_{hot,cold} in DAMON physical address space
operation set (paddr) collect folios of the given region by getting the
folios of region-internal addresses.  Then, those functions apply the
action to the collected folios at once.  The collection starts from the
region start address and advances the address by the size of the folio
of the address until it goes out of the region.  If the start address is
in the middle of a large folio, and if the next folios are small, some
of the next folios could be skipped.  Fix the issue by advancing the
address to exactly the start address of the next folio.

The user impact is that DAMOS action is applied to less than expected
amount of memory.  Given the best effort nature of DAMON, it is no big
problem, but it is clearly a bug that is better to be fixed.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260517234112.89245-1-sj@kernel.org

Fixes: 3a06696305e7 ("mm/damon/ops: have damon_get_folio return folio even for tail pages")
Cc: <stable@vger.kernel.org> # 6.15.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 2ab7b3842701e..9ddd1ec8202b7 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -264,7 +264,7 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
 		else
 			list_add(&folio->lru, &folio_list);
 put_folio:
-		addr += folio_size(folio);
+		addr = PFN_PHYS(folio_pfn(folio)) + folio_size(folio);
 		folio_put(folio);
 	}
 	if (install_young_filter)
@@ -302,7 +302,7 @@ static inline unsigned long damon_pa_de_activate(
 			folio_deactivate(folio);
 		applied += folio_nr_pages(folio);
 put_folio:
-		addr += folio_size(folio);
+		addr = PFN_PHYS(folio_pfn(folio)) + folio_size(folio);
 		folio_put(folio);
 	}
 	s->last_applied = folio;
@@ -350,7 +350,7 @@ static unsigned long damon_pa_migrate(struct damon_region *r,
 				folio_is_file_lru(folio));
 		list_add(&folio->lru, &folio_list);
 put_folio:
-		addr += folio_size(folio);
+		addr = PFN_PHYS(folio_pfn(folio)) + folio_size(folio);
 		folio_put(folio);
 	}
 	applied = damon_migrate_pages(&folio_list, s->target_nid);
-- 
2.47.3

