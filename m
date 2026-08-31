Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E54AC624C6
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 14:03:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E89D66B0092; Mon, 31 Aug 2026 10:03:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5F9C6B0095; Mon, 31 Aug 2026 10:03:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D75706B0098; Mon, 31 Aug 2026 10:03:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B0F126B0092
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:03:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3F42F16013F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:03:06 +0000 (UTC)
X-FDA: 85161731172.28.ECBC160
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 83FFFC001D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:03:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FXnBJtsg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788184984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l4DJBfV8Ln2wiu4MTHaklCvhtPpo+9nKnYvuVasq3nI=;
	b=sNf6XtiZRSxUDdSlsuGdOSZ4CHhkYSNMYx7MAVpF18prsMroGM2n6+Lh63svkjOJ/W4HVl
	bLDz7ymERFiVZ3UJwThNSJOgSzJEXIu8CGgy5qPn8f/NhycHwV4s/+06+Vbz57CC6e4Nk5
	CQCgrQTgmQWBDqVvJMoNhyfL0FzHKoE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FXnBJtsg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788184984;
	b=1KFwOiW6iOKs+i0WdShMTL3i3VKDYOXGJrkAcVYaIqSD0brDRAdxrbLwLsKzd4eGlXXT71
	PUKqtMoNx9AZKYa/JLZNRqN7bG/Kwn/utDAGyRgr0K38zWcp8DP9Y1M01GWnA5i5I0Iydl
	6u09AvzpEwiLSZUWLqZzKMUOkoURwpw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C9FA242BCE;
	Mon, 31 Aug 2026 14:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788731F00ACA;
	Mon, 31 Aug 2026 14:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184983;
	bh=l4DJBfV8Ln2wiu4MTHaklCvhtPpo+9nKnYvuVasq3nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FXnBJtsg4T/jdCIgbGNIC7C9lZLwx9En+qSGSYWcf9S3ezctloyO7ts7ywqdmktJq
	 YWcG5xRWBaNtZq3U/tIOgdKFb33eIS3WW1JOO78jEVYc4Uum6uF7Sg/bglLZ5xy1Ny
	 JqjPHMrVQSr873qz79bpF3N8gA9gcEGlINcxVAnlbZjVSEjlkJLLf7srW4adVF6fh6
	 rwYMfUml2hzc5cnMeebrNnfZn7BOBT70fjdjD7iit+C8LB0ssUQ/yw5TH9u5lVImZX
	 vxlRlhg6nDprdjscFmkvAZYV/mkjjq1jjGXkKExEmuYjEpt3oXhR89WDDIsHUpNgim
	 5QXNf/mkEueVw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 3/8] mm/damon/paddr: respect folio end for DAMOS actions except STAT
Date: Mon, 31 Aug 2026 07:02:42 -0700
Message-ID: <20260831140254.72004-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831140254.72004-1-sj@kernel.org>
References: <20260831140254.72004-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7wtjd5hxwq1g6ad4t5gmqput6x76heun
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 83FFFC001D
X-Rspam-User: 
X-HE-Tag: 1788184984-656520
X-HE-Meta: U2FsdGVkX1/MThVixp4Hrxjff0sCdNvIPe7tvoUkRF0CvPUJQmpzfbyDspSaTIbbZf1tn6S6UicF0vtBj6ICQkf8Esz84jfecEBfZXMb+UuuM6xS6CBGt4Lq4TG5rOG1RMEpagCY3oKHhEjA+yWNyNwXghuST5pt3RbUaYVoFLLl0TrNusuCqUDT1tTFBQ5qVnXtLzsABKhobZKoF/2TjU+2EYkMH2DpZtKR29yEs6SQGvaau+sZPcd1ogSulmjqdDSttuQu7fgJI/T1ZGvwHp/A3duJ+lQTForZmJ8uROVsBvIdHAqAZn/Hpz+mlEo56WRWi25Toh2Mf2EFjbqKyeIT8lmCacc+/Iu+GbRVhAn02u0zm/iWH+Qd7oBd2mIzlM4wntM5vWmtX2ItnxMLm8+54CrT7uUJ+C3xV1LIWL9CyE+ZuOl8fhvNy/+e9QcZ3OEXssxarYceLlSnT21mZt1NiymooATSOlYEXyVHwtXhwOzOpII1grJSwJgvHryCNQhsyq4G6p/zGDYwpbydTSF9OWyz+/JAXtivOLel+ezBmtnliL2/1yA4uu1r/hkoV7366a3igqKDcnNGWlwxwDHp7AdjV7o2u2rKSk49/g0/27XFDn9Et4wEU577DBz+mchXYs3ulRy4/mKpq8IS+rH3eQG9wkCqHCCK/ma0KtAC+x8lKen9AdNUDGjS+/qpNp+GnuuLrWfxh0DwAq0SxPqZ9+RAgZT+AhayDb2RlXgNe/NACokCW5faIZDi0wJfnMu+m6A1crkNEL9Vlcn6rzuHcd2wcoiDpH4k6pUnqiGrN/AE8CoF5StY/xtliReeLcxI85bz91cCTu452dUQsNguDhxrcxwuzfi3pQWovSUEsET2ILh45QI3e3i6zbpZvmz2RG4F/wK0mcAsG67hIrv2+sIOWIO2E/qMO4htrJ8ouCrXcv9NVaAWkCVIA/VTmufVv4A9tvKqifFLrX1
 B8vUHpfY
 JLVvdt5fJa7uzKS37iuujC/lvCVheujU50qVcYSBciasu9FaQ/WnveG8a63DMOE161yzHCtOXgNB3hKtRnzGvzS1qB+leUm6XO//vKVA3EJ02XFd1qLfbFdgNTBbp0lrdfUL0z0Q2AfoEJ65CvOXWpbckwJnbUujHLXHeBiLN0gdU3eLWbREF30zkVld01WwkyaUOID+Bw9LN91BnXOUV5kfA0HJo6/0BYstxADfB+SDD42U=
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

