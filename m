Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D5FEF30951
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:56:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D748C6B00A9; Thu,  5 Mar 2026 06:56:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3B506B00AB; Thu,  5 Mar 2026 06:56:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C37316B00AC; Thu,  5 Mar 2026 06:56:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AD6F66B00A9
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:56:15 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 518DA160903
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:56:15 +0000 (UTC)
X-FDA: 84511856310.15.37552EF
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9583A4000B
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:56:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vDIj4tca;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772711773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s82tZFT3iNsr3WMx/4d8Ml9gjp1Ep9qgTy0gWjRVe+I=;
	b=3x8VPZdROag7/efRddST9FRdHRV8zhMxryCOwEzYfNspKdbhu+rLF8tiue3pn0/0nu0a74
	F3cNcjtbjJVxmHfyN3Ld07iJ7V4uv+CVdsqkQG/DmEuPZFNF+GAQen5ssxE9C4Y4soK8Pw
	w7d3J9gMT4TcWgncrd7HLciWmIRIqAU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vDIj4tca;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772711773; a=rsa-sha256;
	cv=none;
	b=kykmr//q3bOHDRa/2vU8lz6/YkT5KzYX+I2XwqE18UmmUrnavLFXhDzkzeS714XgoLAAlz
	8zUuBh6VpQYZKnP3VXieRFE2LcCDdhaApuAV4O2W6bt0gn/OcvPaU0lglb9GuGzyJ3Ccf3
	8qryRD96hvopZD2qcbUKQiEIx4xq6z0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772711771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s82tZFT3iNsr3WMx/4d8Ml9gjp1Ep9qgTy0gWjRVe+I=;
	b=vDIj4tcaixUxSqZBHWF4+YL7Up0TeXQdEYFI7em4v5qbgKuDZOuC1XTD7ewfFUcwVeAIMm
	TLAowdrnhkx6Q49+Fxgbj2oZ6OvyEkZ/8UJC8z7FIaT5wLfoJvdSVUKOGiXIbMEmGgKLxN
	BNvDvDiql5zp4WavFRG9F9e4VcBmnVg=
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
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v6 12/33] mm: page_io: prevent memory cgroup release in page_io module
Date: Thu,  5 Mar 2026 19:52:30 +0800
Message-ID: <7c3708358412fb02c482d0985feb5e9513a863ef.1772711148.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772711148.git.zhengqi.arch@bytedance.com>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9583A4000B
X-Stat-Signature: ddxj6w3u57d896yk5q7u4bkpgjinn6q1
X-Rspam-User: 
X-HE-Tag: 1772711773-404306
X-HE-Meta: U2FsdGVkX19me2n8ZdyVvaGUjyRR1PULsDtgl65iAdtpde+pgoMUv81F1cavYoOzHESDylCzndCvyZS7uq/m6r2dV8Q2kEZQzVRDJhrBEJE2AoqLqRdOUBZnr10m8MHXkmcinGGCU1kc37aZTzDMxLyNkp7cnejNaV9EB/xiDjpXUz8LhcyoJevwUWdVFQEZX7fhvArLYHcORBPSAJEoK12TxEeUm/augxrQERfPH56Hp9kWZBWxtPDouiHYQERJRr7G+rwHXwvo/VCLHHFUFGY0DwzS73CrnUqJADwI8YTu3OVJnlPHfbeWe59FgK/FtHRdAzcYLn7ySyIcxQWBt+bJEiwBPiTntweldlWHLeHODoftww+IF6iSAa3ggfEFO3K2W/6IHgWZkjS6y1bvJqT0f0gYlWhib/snUQO589+AcbJ3LEgbRE8xJ0cZUHTIBF5pvZH3btH9ZAcrkMOJ5szB66YpdhZnzV3z6f7fbIVhp82PWYAELhlIgE5es02xoz2mQha2QnUSS6ZZarOdMvpthLpB9D2Vj5QTYthAWkmr/t3DsDndhI7bd/rntdWDJisz2VJbQyEeT0jnlq0ZThKt2/mzZ3uq/o72KLSRSRaXZA/1H3rmxAex5YumK8kZSwS8o9GPmWCsQxh7hg/T/nSZYgEHqVybtZFrD1qseiwN8f4JWVuZvDxUf7k7U0wr2MagyfTTcNo6wpiBI8dM+MAw82OI1+Lxl/5V7pkLGEC496T1r6Qf0YR+1WL85abeqRyEu8KF9TpZKMpvMicNr07onH5FClkV53ojn7B+U+L5Jfpdy1E10yYm0fLzbgXGcIKFXhkjLebUpGNPAuJ4PJOdb3ay7kCuYOeJkHjWKsO7uq4zW6wbsHfIjj97fo83x/JDZCXQcrMZ9DSBPf/b2Kuqr6ORzgJsZPY5I3jJZEbp277kYBvY8kOXi5EBOG8gnJBCEmVVK9eKmMThhOg
 GoYuobQI
 slXuQpKTCHXoipkDJpWqRWDh5FE34idl4g5SJoPrKBYPuldHGxtw+xTfKx/bXFiXsOsF1wwTVcGW47JMjUdWrCmNfTZ5ZfLuq6xuEmgxMEscNJoErRrGX8Qg0c51iRfjk1IPU66HdS1CxwCGW2108u+zPZtuIwopcH62tw4Yfuat6iq82RjuoDtQwmUX8Dx+QgsWLIH0EhUt55KN6R9k3GlKilE63o+jpm3mZGPWyigKIFA3/ijQWU8o//tBNFoX7aFBxu6nEXBXE6bQT9EbVb2193gZC5KNXlsJw+J2jUayBnPBtsn9OSYW4B0Q4Ahu2EvLp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In the near future, a folio will no longer pin its corresponding
memory cgroup. To ensure safety, it will only be appropriate to
hold the rcu read lock or acquire a reference to the memory cgroup
returned by folio_memcg(), thereby preventing it from being released.

In the current patch, the rcu read lock is employed to safeguard
against the release of the memory cgroup in swap_writeout() and
bio_associate_blkg_from_page().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/page_io.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index a2c034660c805..63b262f4c5a9b 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -276,10 +276,14 @@ int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
 		count_mthp_stat(folio_order(folio), MTHP_STAT_ZSWPOUT);
 		goto out_unlock;
 	}
+
+	rcu_read_lock();
 	if (!mem_cgroup_zswap_writeback_enabled(folio_memcg(folio))) {
+		rcu_read_unlock();
 		folio_mark_dirty(folio);
 		return AOP_WRITEPAGE_ACTIVATE;
 	}
+	rcu_read_unlock();
 
 	__swap_writepage(folio, swap_plug);
 	return 0;
@@ -307,11 +311,11 @@ static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
 	struct cgroup_subsys_state *css;
 	struct mem_cgroup *memcg;
 
-	memcg = folio_memcg(folio);
-	if (!memcg)
+	if (!folio_memcg_charged(folio))
 		return;
 
 	rcu_read_lock();
+	memcg = folio_memcg(folio);
 	css = cgroup_e_css(memcg->css.cgroup, &io_cgrp_subsys);
 	bio_associate_blkg_from_css(bio, css);
 	rcu_read_unlock();
-- 
2.20.1


