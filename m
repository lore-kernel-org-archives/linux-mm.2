Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21D0CCD5BAA
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:02:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E5636B00BE; Wed, 20 May 2026 11:01:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BD526B00BF; Wed, 20 May 2026 11:01:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 085B66B00C0; Wed, 20 May 2026 11:01:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E6F756B00BE
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:01:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9FB411402CA
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:01:04 +0000 (UTC)
X-FDA: 84788110848.17.F5859F4
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf11.hostedemail.com (Postfix) with ESMTP id A7C6740014
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:01:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=lQTEdoYg;
	spf=pass (imf11.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jtZKbuOjheumhRbPauF+MORFobu5zhRF12dkuYJiXIw=;
	b=RxF1T/AJzXDLsxUkM2sJ3M/t+ZETDdF7onWmNRSq1NfkkbPqRmFOrvmY9wrjaRZ4J29xOo
	j8jLk/Wp6uFpV3QsCo02D6rZB1+kEW6WLP5VhGhC7Y7M5+c5dzPoBhzGXE72TBv6Xf1AIu
	JuiRIBok6XnE8kfgK+JuQka/rYKm+js=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=lQTEdoYg;
	spf=pass (imf11.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289262; a=rsa-sha256;
	cv=none;
	b=7YKZLq/eTIpSxtr3Ao5fooMFneJlSlxbmyV5QgMQadEWDSnqI16L5YOfOyC/O+7duZU246
	/pr3omb5GBfhUz8jqh17A3WQYQVjG1j5r4OIGkhUpZ4kNAi0k6RfwsZGV7xNF21jHloLRS
	tERaBsmM8olgjf4MCiqe+BYrVFI54ik=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=jtZKbuOjheumhRbPauF+MORFobu5zhRF12dkuYJiXIw=; b=lQTEdoYgv1COf2hRyTnyxUch/k
	KGfNdIHjMbmbk2ikfos0xrzFi/X+hIGzQcgqiZJ6zh0XJWWfTrYnybAz+S3K9OJjVAcwhf9pJN+IJ
	dIfaTEmk8ghXLoYH0SZEtJtZD2CfEmdWTb31M2rxxQxM6tirwnjvEwy9Y/TbxhcoXiF8WCpb1/SDQ
	QgugPCGH7bKSsL/q7ax8ujNPcGrw8jZpqg8vCnEKSlzhi9A1fUOky9MHc88+YnHVZiDATVGaxX2Rt
	dSDFARfZtDYatuEE4vC0CTQSr0w2j1j7loXjTRv4Y/TdhHTQR8ztvTNFzSHjdUCyykp5jGrb/9+pe
	WhcP0Hfg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPN-0000000024Q-0eoY;
	Wed, 20 May 2026 11:00:29 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	linux-mm@kvack.org,
	david@kernel.org,
	willy@infradead.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	usama.arif@linux.dev,
	fvdl@google.com,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 39/40] mm: compaction: respect tainted SPB reserve in destination selection
Date: Wed, 20 May 2026 10:59:45 -0400
Message-ID: <20260520150018.2491267-40-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A7C6740014
X-Stat-Signature: j87rqosmw3ao9kxgqu9ixmwbjobmacik
X-HE-Tag: 1779289262-203995
X-HE-Meta: U2FsdGVkX18IMK8vz0eAzQCPMOJYRUS13k8nr8sk5JrF1jQ9A8dF2xsV05O6MBs5ZmVgHK+aEDgp9Lpuo4v0If3anp5JUDT3Hx58oh69XPVZ49E4MIWNrl+L5TsHzo9K2Ek3IMc3JcOLYoraDmEYNY2cDi1tixaFel623mZcEfXBba8/nzDzr2S+NKyef9cn3iGHcllnG+oIgoDs7U6DyBn31ExK3RkxcUCwuMsx+apgVjXlIde5Q4xJyYN6VnOMOHAxk/qWBFmVkMCbNgf144pQw3tA8p1Sc49LL3OCIIe98lJOfyYID9FWQjU8k0QP9mgsuoCBvWoiSJ9WkIdCfMVdqxSfSneR6JyuOTeR1dAYnIaR/Mhd2RLZDPytFA/LD4MHWmv+OJlQZtgSNvyU+yptIe5hsU2Qx+HR0By/x4vEG9WtHEQUILfh8w+J9dGRwFdtIiNLc7h5PfOYLAWSSiZvqD5678nMUrKmWp3GmD1g5LDJf3z8yO+u4VYl64tzigQ5thM5WaTYT7M0IWbNtKuLyvdiREoqTaVVZEm8x9ddW69Pxjw6shTGNFrXSqlGaD/tj0LBqngCiwr4nuiW6NATPn/jnOpT4PnqMwg5HUeX7zUYdOQ7sVZIeiqFwB5fo7YdJ4ff9UlTtRk6hehC2Owvr0BaYwqCwh0hWTdffI7rNgj09M+cr8KKAMxzH5Aa/1xPVRs1DdDWmP14vHR18bf5w/juYh6WRi4In0gO8+JXgWiHJSNk6mFp9IAkw5ajrQZPtiyRaPd9K/2Xz01IIbdU17ue62bxQIEZg6M4PWQU7GEcDHZ6qcvy0r4mb9KknTWDRTr60FHMKDLZZMps+UJ4B8HY3W+1UQQr9kLFMeMr1fFSmlQmw3wFeGwVwKc/5ZLKfjs+7kP5gaTtGabdh1jcdG2vFFV5cFojzHqmjSX+cH9DcxeVv3QQJOK+MwNmuo7yncv9O5DQdEVIqcv
 rnJwuFKh
 F6DmoHOPLcnA6JnmYRF0U9PVexu9zOenTh2ooDHga0QfqYvx0l9IIqw/5+jHdKN9FGtthtNZyTjWgilteAhhM2gGbSC3g7QuvgKj2NmpyeaV9Wud+UQwdhyY+kRynPxvNum6GtBwqStuo07FRYasrgctiKLYFHfGukTooJjMb00ViOsux3LHOdPh3o6cm5Lp1qJrzKuYfBgERrNEBLnu+5TDT/DQVUB8NOjmcEgrh18ndyj7yGGPD2nFFTrXaHde/WGCozch7kI7gwfBMqY7x2Sfkcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tainted SPBs reserve headroom (per
spb_tainted_reserve()) so the allocator can satisfy non-movable
allocations without tainting fresh clean SPBs.  Compaction's free-page
scanner can erode that reserve by picking destination pages from
tainted-SPB free lists -- exactly the headroom we need for unmovable
demand.

Refuse tainted-SPB pageblocks as compaction destinations once nr_free
is at or below spb_tainted_reserve(sb).  Clean SPBs (no reserve) stay
fully eligible.  This naturally biases compaction toward producing
free pageblocks inside clean SPBs, where they're useful for hugepage
allocation.

Combined with the source-side skip and the kcompactd wake fix, this
is sufficient for kcompactd to handle clean-SPB consolidation alone.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/compaction.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/compaction.c b/mm/compaction.c
index f9de52875c88..3d1015dffa82 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1503,6 +1503,21 @@ static bool suitable_migration_target(struct compact_control *cc,
 	if (cc->ignore_block_suitable)
 		return true;
 
+	/*
+	 * Tainted superpageblocks reserve some headroom for non-movable
+	 * allocations.  Don't spill compaction migration into that reserve --
+	 * doing so erodes the headroom the allocator was holding to avoid
+	 * tainting fresh clean SPBs.  Clean SPBs (no reserve) stay eligible.
+	 */
+	if (cc->zone->nr_superpageblocks) {
+		struct superpageblock *sb =
+			pfn_to_superpageblock(cc->zone, page_to_pfn(page));
+
+		if (sb && spb_get_category(sb) == SB_TAINTED &&
+		    sb->nr_free <= spb_tainted_reserve(sb))
+			return false;
+	}
+
 	/* If the block is MIGRATE_MOVABLE or MIGRATE_CMA, allow migration */
 	if (is_migrate_movable(get_pageblock_migratetype(page)))
 		return true;
-- 
2.54.0


