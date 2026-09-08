Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74F2CC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 22:10:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6576B6B0093; Tue,  8 Sep 2026 18:10:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62ED96B0095; Tue,  8 Sep 2026 18:10:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56BC26B0096; Tue,  8 Sep 2026 18:10:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 33D8B6B0093
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 18:10:57 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A66831207F4
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 22:10:56 +0000 (UTC)
X-FDA: 85191990912.19.D822959
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5E21AC0006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 22:10:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HtG+iSoJ;
	spf=pass (imf28.hostedemail.com: domain of ehab.ababneh@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788905451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uc4y9JP37XSGHQr1hdibjcPitAxyiC7OL3+fS6nuC4Q=;
	b=7e4c9vNviS79qpWd2Ac1P7Y8qSLoz3u/nPqKbXha/uDH8WusIjBF7iGnTfapjHfyGZk4J0
	f5kYMAzA0UZ3+m8/8F2MY0XS7wTli5U6Db/5bQhkPcm7wbA34qtsiMR0f5t6mARHzW61mG
	CdCURqsZa3fs20uAv6FtriLTxfQY8Qo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HtG+iSoJ;
	spf=pass (imf28.hostedemail.com: domain of ehab.ababneh@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788905451;
	b=ZnbRmzL8YINiQuO3VqeyeC1aK1Q+OMl2pH/6SZ+utc1hckTef1E7SstR+Akce6fI36qMp4
	VWA0H2k35pPgCYNmGtAlH2ImhKVcFGjIw4MIoA1Nq3KRhTASIPeiiV+7/sPYB7A81hp3+g
	lKD2sPbSuxTuKtiGYLW8UnTKmN8XDaw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788905452; x=1820441452;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xSXuhfSAFXS+zY/N2kEvJ2MzIV8SUjri3eMHXmdgoto=;
  b=HtG+iSoJwi3cLIbD7jCIpbKTqQvKLD+YKvQHZxWMDlHCrAWH2yx+t90V
   uYXRoLbcGbflQxAMv2hJaNMbm0O67KzrOFJtLO0VJFHHILvO85imamEsV
   gFyYY2XG0F2vDwY1x7bKhkXx2BlRVIAblUOeBurw8oAoA/8J0gqviqAMu
   2B1OLG7ZS0mDJac1Ltf4rt5lAG4LH8xw73q2NR7KvGwpverXBZIgy4RBP
   WaAykN6olSb8XnjMFuINhBLx1h4l5tGqvEXREnb9JG6R2H4AtfXSKdJ+/
   7E7QOntOsdQdWwSVwdoGsZWjwq19adSn7suh9yDQZ4+u+qgCUU1LIUDYR
   g==;
X-CSE-ConnectionGUID: wWzgJEKKT6+YSBh8rsy3cw==
X-CSE-MsgGUID: t1mQgVTrSFiYxL1aya6eMQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="93017401"
X-IronPort-AV: E=Sophos;i="6.25,269,1779174000"; 
   d="scan'208";a="93017401"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2026 15:10:21 -0700
X-CSE-ConnectionGUID: yyp09S+4SPC9WzJTE4n/Gw==
X-CSE-MsgGUID: Pe3kuIPCRnqE7EF/SiSPPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,269,1779174000"; 
   d="scan'208";a="296067798"
Received: from jf.intel.com ([10.165.154.102])
  by fmviesa001.fm.intel.com with ESMTP; 08 Sep 2026 15:10:20 -0700
From: Ehab Ababneh <ehab.ababneh@intel.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>
Subject: [RFC PATCH 2/3] mm/vmscan: handle racing max_seq advancement
Date: Tue,  8 Sep 2026 15:10:55 -0700
Message-ID: <20260908221059.14777-3-ehab.ababneh@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260908221059.14777-1-ehab.ababneh@intel.com>
References: <20260908221059.14777-1-ehab.ababneh@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5E21AC0006
X-Stat-Signature: ea5bt9q8meptphdnctsr9oox8odn3mtd
X-Rspam-User: 
X-HE-Tag: 1788905451-260478
X-HE-Meta: U2FsdGVkX19l7pf6KdfvcA+SqiG1dLB5UmlhjNdtmaBJuEnU4cBtMyjBhDjqpplEvJqcEmpZqPkAeEsocKOEWfY88/ug7wzeSRswAEWibX/BN6cvE2GqCLmqpH5NQpV0wsAS1+kDQs7jSjPlIicFeselW+TYpsfQHpk4fBxtO6xlSDmfE6V6G/2t8/Or5X9J0lq/FH9EMdti/h5xmUrH/HwmuYNnZIK1q0Vh4z7Bg41s/1hvDzn0YKb+0vz6D3GlQE0knHbZGyNHxCIEjhCAduEQgMfd0RxW3oOU+jRhIZmQckXqbmGvZIjHP1eZORMP77UZuit9sAWyibuF87N8r+ZfaVPji9/MxROS3gtgm4dlcVEdp1kwEb0pXM9aCZuv3DvFXLashpcCpvD3qTkPtAWFKa4RR4w+ejW5tMgKevNFcae8ATFT6GrUQHN9ARF6bPNmIcZJXKPrTHmax8aWJyBWMxl7q69MqCHzx9glaRu/q3FqictGQRZyIL2+LL0vDCQ9mjarkolxNCq+5WGNc654/0JcUCasfFV4RkgfZm8ym4C4JDKMIrs5FzivbyRcSgu69SQriKaFP/i81D1nDvKIulQsXJM+4/qNdeH1aPVY2eDO0LfwZL6UN5AhTxVUrKt5HUNurqnr2YXdAM+zSkNOSxT6w8ybLcrzYc+fz0d56hvidlz2dbeUf9VaJlwYDyrD49vqesqpVk4ofu+V42bVI76br73OeRXkWPDFQsixh2Pxz+BcfXW7wYocXECeRFSKys8V9yrxg/QF/hKr78utVcj+WkYb03SQYj4/t/cJeuIlscgDxUuGLwkWzxsMalSrx6VnPn8ww7RVBBV0BlsqBlaKZ08dk165ptSIS2G8avUZZhKSMiYBOL4C0U4W5GXfclHYc2yYQlapwdIvzPrDaLR4sCMDGulWNYmtLhwBQuKWVA54ihhn1xjSeCLzYUmZjIBkbYypIzV5ur6
 vw16dBcU
 6fTwDJOw6Tb5AMcrT0ITPjcQX9lEsw9b8SMkQzhwmt6SeCPBlzQGUY6JMtl8rASkbnfw1CKSLLAj0aQenKVa+BRF7LQTHkGkT+OoxEnWAUCXnKXsgMBpomdrFpEAe8NG4p2WH2XSlKVT+YuW/HVO3cxJ056XbhlYcYUBYwoR4FXC11Eh5ehVFFx0vdn+y4GSmBBCCmEewfDGNk4DO4slji8rnkreCGPPCYT0B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When kswapd support is expanded to multiple threads per node, concurrent
aging becomes more likely and try_to_inc_max_seq() can lose a race to
another aging pass that has already advanced max_seq.

Treat that case as success instead of warning, since the desired state has
already been reached by a concurrent updater.

Signed-off-by: Ehab Ababneh <ehab.ababneh@intel.com>
---
 mm/vmscan.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index fbb04848f59b..ad2b398a68f9 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3942,15 +3942,18 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 restart:
 	if (seq < READ_ONCE(lrugen->max_seq))
-		return false;
+		return true;
 
 	lruvec_lock_irq(lruvec);
 
 	VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
 
 	success = seq == lrugen->max_seq;
-	if (!success)
+	if (!success) {
+		/* Concurrent aging advanced max_seq first; goal achieved. */
+		success = true;
 		goto unlock;
+	}
 
 	for (type = 0; type < ANON_AND_FILE; type++) {
 		if (get_nr_gens(lruvec, type) != MAX_NR_GENS)
@@ -4045,10 +4048,8 @@ static bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long seq,
 			walk_mm(mm, walk);
 	} while (mm);
 done:
-	if (success) {
+	if (success)
 		success = inc_max_seq(lruvec, seq, swappiness);
-		WARN_ON_ONCE(!success);
-	}
 
 	return success;
 }
-- 
2.43.0


