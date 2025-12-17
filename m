Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A14DD64085
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 07:31:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DFEE6B00A3; Wed, 17 Dec 2025 02:31:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 780A56B00A5; Wed, 17 Dec 2025 02:31:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 699516B00A6; Wed, 17 Dec 2025 02:31:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 539226B00A3
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:31:21 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 083575B85B
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:31:21 +0000 (UTC)
X-FDA: 84228142362.23.BFDB9D7
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf27.hostedemail.com (Postfix) with ESMTP id 583A64000C
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:31:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K96tzvyH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765956679; a=rsa-sha256;
	cv=none;
	b=fulHFTwTD1tW0qaiNedMBn8FZqUzLSEoO7W6c6H8+MRAHCfHL43OY5fHKtDHzzd5XEr1Zr
	BxRxsZxwEMUyXs9cGWAvcpyFKUCOqXlx0x1cQ7mAZFfzBumyfwWte/uc+DFhrpcY4MO4Qd
	zsaFU+ooxZ6B6mMAhKKyDH/hHT0NoJY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K96tzvyH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765956679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7JUakH8RoGEUpXQwlompW3asRykfRFAg5UucbZpTDd8=;
	b=Sqk4KgwSvjhQv7zXnbESN2tI71Mji9H0FqY2S/XUjLnlkKMtOl5W/yHsB1lNPAbD8+DFa3
	HnCbemL6ZSgfiYGF4aHMvkRCqB7xEdFT4SO9AOyvjri0L2TWYOZS4GHe33nkRi8egR+ILi
	axepb2IWWyKW/RA6YvslbdKLK5LOzGQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765956669;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7JUakH8RoGEUpXQwlompW3asRykfRFAg5UucbZpTDd8=;
	b=K96tzvyHVSfFjEQWFZYsknQeYErc4m9UCrZguyLOTm1EyoGLAezAyOquWDuHyYDHzdGvES
	vvyK28/fhaNwYlaxHWbq2BeRB5FUUSU+2+nQGRLWo979MFTMFgx97t5vmdwCw7NpWXk+sS
	w7mWHISxfr/ZIzsS97XE2xuRSP96qV8=
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
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 12/28] mm: page_io: prevent memory cgroup release in page_io module
Date: Wed, 17 Dec 2025 15:27:36 +0800
Message-ID: <30588f984137d557e4663ae8dcf398b8c408169b.1765956025.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1765956025.git.zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 583A64000C
X-Rspamd-Server: rspam03
X-Stat-Signature: yuwfum78mq8sa3ottxzwm6m311yazt5j
X-Rspam-User: 
X-HE-Tag: 1765956679-500203
X-HE-Meta: U2FsdGVkX1/6cqoZR/WOZBEJM0lynpVIgkUMRik48gvLvF6zA7z7IwyY8lGpNaMEuDoMFIhcgttsQbufA2FKs+PYLPUZNJC4alJxlm2JdhmWJorVN0IUhdk8Wkgn97RstMvB7bEX78MP65P6wHjdJhWh3WAxDenRzMNqUkoepjue2Pa6jZXGdnZHEVNLU6O887IFmkMq7dj/aPimfCIQkRb1JUoK/Vis7k1mztLJ9fTzRtzDyLdWiGILeWY1ukV3QgEn/fOZyXaiv6JLtrvfDfe7KrktQwAX9OPqpBSYE5glm/HzWIy1GKCQUFCUQZzaUvRdX2H6koQRhpgfp6aEClMovDx3aL2kc+sIxPWqqgflNNu8fl73FHZTvKkLfBCjsR90SJJuZ54D4jNsG0LlEB1fQZK7LbsluXgWqdl3CvlnKIJ60LEaHlqb+6xEIg3bvSnzH1nGMEL/7zcyGmWM3MszfT1lJ3G4WOsOq0N6NzXuU6zU8TWHE6saDICXMd4TJExcEpN/pTxBoikfwSbM4io/+Bm0twSpGjLAu/nV+TF8FimHJSGdhW36tizzywGJRbLT0wfHXU4YDPHcLzzy/O20YQtbgn7NOekTbW9AQGf7DNUWQcbQYP4kKs54zgYKF58WvVjyPp+busaKJnXbOOq6MxukQchMBNYLykP/of7alnauHZDnbUyvgUQ9a1ZTJi1dPVPp5f9bvuEt1DiV4ZCCP5nJOKnCwEcPBUsgFScs6K31kYoJXoKUzFsYl6M9m+z8YuSuzYF9XqiNsA35eV3nTtaiMeUrXYndcnKAS9+QqBhgVFiHZYyhpRq8O3LR2iXiXAFWEMySk/2p2Ud4D21stgyKla5/lYpTIc78vmKNtCQFNGsRR8fzGeLVxygIXtee/rlzTvZ+yHKfv5bhkHlhTHPFwzuytzWIK8gnURZ/f7kqmQ9VLpkD+SWuAq/dDnmYJ8uXPO2JXWpNoAy
 6R3k3PR7
 ChAjvxRiQ803/Xyg59l02sHKfc1lRhEw9Ap80Yfz4zUWg3jGiyD1O3i73htncj6uRgknvsruR2EdruHcgOR1zR25HYOTWxamVz2xfgahwmWarW5pKuT+GtJhRkDoS/7idsmKYjyAZlZEXZd3a34N+XUXoVJq/zZ1Alh4I396A8ebdeJ0kxi3VD60Sshjl2Bxyk8scAqNpAePefG4oBQqYQuDVYdIlO3fMHeYpZvZzq7P+oV9V3RQ3tLPPGFm41foUPizh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
---
 mm/page_io.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 3c342db77ce38..ec7720762042c 100644
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


