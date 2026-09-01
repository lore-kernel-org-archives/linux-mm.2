Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8B7EC624D4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:14:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1A196B0182; Tue,  1 Sep 2026 09:13:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8B166B0183; Tue,  1 Sep 2026 09:13:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6B536B0186; Tue,  1 Sep 2026 09:13:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9FC7E6B0183
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:13:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D3867A0450
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:13:38 +0000 (UTC)
X-FDA: 85165235316.27.E4C94EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 414BAA0004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:13:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MpeJKmrK;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788268417;
	b=lOX9JNNtdMv+we+tt8gYXQdYEXZEGmpgE74uiaCTf8cimYjLv7hVBwC84TtnY0T9MUnqxM
	1AqqJxnmHpkTrlm3K5SzpoUyTitPJO4dcCPoZ0xuAstYUcMRmSCdOW6chX6I1BV1iijZlv
	d0qGAKBW2FGAJuxssGEZzdHNyVUQUHI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MpeJKmrK;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788268417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l4DJBfV8Ln2wiu4MTHaklCvhtPpo+9nKnYvuVasq3nI=;
	b=afbvvZPnI4y0b4SqM9oaoQCcZ2O3d+yxoAnu2os0DGejz43pskjdgkHYxCqWq5clkfZap+
	6Dq/IhqYlR6OEGuv62dIIZuQ+8qwVM2YPKV/zOnPNYyklvvVrtWLiFrwcrO5uo/oGZWMP1
	wH0gEoB73rurfgwe/NjPGeYxY3lhb9E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CFB2A40B91;
	Tue,  1 Sep 2026 13:13:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9E71F00A3F;
	Tue,  1 Sep 2026 13:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788268415;
	bh=l4DJBfV8Ln2wiu4MTHaklCvhtPpo+9nKnYvuVasq3nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MpeJKmrK9iHVcoS550Knf/Mlx3E0FIKosfejJKu6aHXOgY8rXc69/9aUaYT6efHrh
	 318yLkiCl+yee/KmUKnyfNEhOXMrlAqQqVtymWWhNQsV3d+Cjqry887CtY6hOzaIt7
	 QaAyDFo1SdZRMTt81syDLPKzwjjQXP1PN0tqFIDd21PZ9Y3IEjycwwxJPYwtPA3r+f
	 XD7VzjFO2gS24GALcmEwiUy3AkyUxwl2II0b7NhFjwGRh89maVLHrSnvxKd1KV+C0x
	 +I8DT3ansh/JMHAJ0niHX4xbLfGfrsQjh5wWlAQen97xpHuCuButa+KiEztUyVpqNN
	 R4UfKFv61ey1A==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/7] mm/damon/paddr: respect folio end for DAMOS actions except STAT
Date: Tue,  1 Sep 2026 06:13:19 -0700
Message-ID: <20260901131326.97615-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901131326.97615-1-sj@kernel.org>
References: <20260901131326.97615-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 414BAA0004
X-Stat-Signature: dchrx34tbz4gpym86caqq3ohu6ft5mga
X-Rspam-User: 
X-HE-Tag: 1788268417-568246
X-HE-Meta: U2FsdGVkX1/x+FwKkSzUJp3gkvI4pCc450c5jR6FBXPmjeQwLkaAvrqwgn5L02xXygMCj4QRKaRTM4NvUc8kv6SLow4Nm8qnALIo2xLKcdgFTRvMP1s1+rjcg2yhgvK80rza2sbojdkstdNDWClRCm1WLSVbfmxf9LPz3ihDk9LexgyVUjtnCX5xCrsQuGg2g8gnMvS28OxAJujSIrIMHzc7P9CItQYyO6KnbNcVCtqVoGmbUd3UAGVx0/Kbb8Yjx6lmJXRxBGyQ10mRlLnNyjx0ETy9lcW/lFRcqzwRaIRUHMiYvugQOug5epnqMbn6aQHxQxf0FT/86NLweuL5BCizLnLm4FUlRpW1gzlo2UopilmDxxKkeQ5Llb4XpXriNZADgfrz2dBbEjMjaWR7GofxMl2wgZ3kZkO9DzSayVysBVRtO3zRgtKU46jLjg7JoyTUSze0tnri+boWYxRFnuJcgtjVx2Ff9NYOXNUiSUENrgm5QnZQylCN3aoffsCfXOGM4oBXrZsBRiWLyPakatxDKm6m/soEI0FQOMIeepZiHMXqqu69M460uNf1NuwdnscO8YyKh5sgwcW1icYB8z3V/Dqd5FryeLNhgn8NTYUNpLlkjncyFGPgL/Uk0CHn0W/weY8Nf3XfUek55bSkCCu4fWREI6Kpme6mMkSBPSZuId4KjS983EEDTWZFOw/vTnoanCl3j8sonS0UvF1XAP8lH50d3CE8zwLDJfdSGiwxcEE1gCoMCvJ6G16PWxwmmxidExMEabf09CNY4vOsgY+XHYThjuXP5GrMI0yZCyoUppHM4xrRlX5RFN/YMe4Xsgh4+81SlhtAAD20t5SgoM5kZlusxt3xt5fJcy+1Nx8wqDgSNKbRO5DkmvYzpavU8R/TnjjxUk1HkNEa+DOr0cLLDKSUzMgdBl8XyC0ivXPvPuphGVzbz5kxphygSl7di7KzZWOUOKrbV9Z8waz
 lKkrdLL3
 jNMB219MSvT8qUo3OsISm/05y35AVSvDMnmCi8p+ZL0kl2DmWbSZFFy+9gHhrR/6foFYn8paqOiPRwW2qNc7zo/DAnJprsWnKA516qfYRhZutQnmnJqiO75AZU681oXttoYEeQf1ke2kNMLt4KqgH3SLjWQFjVazWiqsyJ5B5UGK8ZFpO9wfIbClEpm4J5gtjPd58Ez8aSM4H0Zro1wn6xt2RfGCUJFJUSkVPdGa71gSNVkw=
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

