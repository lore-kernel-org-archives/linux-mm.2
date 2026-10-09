Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C217CA9EBB
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 20:30:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A20E6B0096; Fri,  9 Oct 2026 16:30:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22C476B0098; Fri,  9 Oct 2026 16:30:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A5586B0099; Fri,  9 Oct 2026 16:30:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D3F596B0096
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:30:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5C4CD801F1
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 20:30:51 +0000 (UTC)
X-FDA: 85304231502.07.202EF93
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0AC9180006
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 20:30:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KpD5KFzl;
	spf=pass (imf30.hostedemail.com: domain of ehab.ababneh@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791577849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5QXje/1XAQZMuKKrr6qomFO9zP6MeMCgjXYc2Zud2GA=;
	b=j7wRdyJrxjFKmmAk7EMqMcdkSkM7AFJb5cWDEfHEVFzf+d6qdPUgcUggdkx4C8Fo/1I0W8
	tFqWJUCejCNLS2PONbKaNF+XARIbcAWLdHOD5SRuZRfJ6i0zHmZAvONg00HlYp6ugC0RIC
	fXCgOdvF7wRsHu/SICxzffg/y0gJ9P8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KpD5KFzl;
	spf=pass (imf30.hostedemail.com: domain of ehab.ababneh@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791577849;
	b=2PYcgSSolT7eki9hEjoY9ta/ilQUpEcsmFK5al/O9LEazxEv31piz8hP2IktjAkyEQrff4
	GohnPJ2q+5RZU6IArfA8Io5ZBzExRTqkNXzrkv++c6drfDrPmf9XRtMkK1zfUc4u56G7e2
	6gQwTFtC1Y4wuolva/DOECjhzj9uGik=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791577849; x=1823113849;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hujIJUZ4rTi7dseLYz2hx4VmOA5gUj6Bw9iPs/6W+mo=;
  b=KpD5KFzlA5k+mxLy+/8G/nrCHo+ZvQ4aKpnXOveMr5cWN4kla1WnLuQ5
   EeEfJLN/KjSmoB2LxDVH+8IKHL0KaPTIjjMILMuBrFa/ITAI2b3H2iNF+
   egALb3gjU0y4ItgIVTAf0tymItF3wzwSVdSThHHgxkBLdoAtVmg2JUZ5K
   cKPAgg8zF9nFy9DUY3Si0/3+JHM+Q/kCn8mmu0uMECVkyEwysTkEVb2gc
   A/KlUA6MxcOs1e+iJTQhPxy4BBDFyXBEeiyD8lKbVRoyufc/HLO42jCdq
   +zLzJYgZPjwx43M+XwE2Uv/FpqYNommMxBQjN7IOor244Ax7iqgDHRk6X
   Q==;
X-CSE-ConnectionGUID: PhX7ccNvQGaM0rnhGgDwkQ==
X-CSE-MsgGUID: bTz8fgHcRH2Nw7jmtim3hQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11930"; a="284552"
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="284552"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 13:30:48 -0700
X-CSE-ConnectionGUID: PGpDYAFsQI62LWoDEjC2YQ==
X-CSE-MsgGUID: x4gWQZfRRimLkmOaIPcDQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="2193191"
Received: from jf.intel.com ([10.165.154.102])
  by fmviesa012.fm.intel.com with ESMTP; 09 Oct 2026 13:30:47 -0700
From: Ehab Ababneh <ehab.ababneh@intel.com>
To: ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: buddy.lumpkin@oracle.com,
	akpm@linux-foundation.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	Ehab Ababneh <ehab.ababneh@intel.com>
Subject: [RFC PATCH v2 2/5] mm/vmscan: silence spurious max_seq race warning
Date: Fri,  9 Oct 2026 13:33:01 -0700
Message-ID: <d36878ce1bb144748505881db2f51edc0f2e30c9.1791577417.git.ehab.ababneh@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791577417.git.ehab.ababneh@intel.com>
References: <SJ1PR11MB6105E073723CFEEE8C8EDBF48C832@SJ1PR11MB6105.namprd11.prod.outlook.com> <cover.1791577417.git.ehab.ababneh@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0AC9180006
X-Rspam-User: 
X-Stat-Signature: ik7f6cu6b6qta31ar9rq1sn4whhzdxq3
X-HE-Tag: 1791577848-959364
X-HE-Meta: U2FsdGVkX1/3xdAsXsAk+NQm7hH9UxtmAJF9B4fxwCURwrMG+CNXuGZslxT4jEUht/r85vETqOJLD6tB1uuMUk6icYrRMdsna4n80YTi17315bdousZFM3asTJyE7cW1e/ZJAU48XgdxgCYYdX68Gn66XzfYpNgoPs2FZOEdti5phvITYOlc9rZ8tMZO9mWqzdMrnhHgNvn+mDP2aWEKaJ0KPNK7QEL766ZU3BgtEuqR6CNVm/mdA+fmjR++5SQNBHapkoHFnghKGCjTL4DYy3TykABwmhjI+qiXHbPNJXBxCgVQpre3Q1tlcksFNfr0ybVtJZBLtRinBTVt2GWCMert7Ji8G0J15g6tSOaaCOOOC/vUWnZWbZtWO4BRozJZ0vdmFegSsl1XR24mtHrJA2p/EtuE8czc72nGDR5/+Dze7IRmrUZrQe1Kdzdsz34ZqiqOwzp7+BRkTbBuCtzsxgTGzEHVsLMo45XOeVq8wsA3PTHC9JSda4CGiel4h1smYArXG5lZrOwqg3ecdTXwCQtksLacbKo1d72H+FL17j8Xr9YFbjBNEvTCv2o3K9+hB/ocmvim38cMS3ONfZDYeGLWeSDwRQCH31Ln3RPHGWDFd+ysfGRsjy1213NvlqbmiE+73cnZCYPlnK1mLAm6aL4AJ8F9CTDKEIViQqMZQeVRM15FGbcXqofzUY85hutjv70TQP4ue0UUmRBFW51W9M8rSkLKN7JD7FMXq1tEB4oiL31DVOZcPwsTAybyLoVScTubnIQcqcLPFq8kFeh7cjO/tgVdYAbKxUyRLfQHfe+fWarptTX3+Pzjc+ZYfGBnEeLutoxoePBvizD+3cWvG8D0FfHRBsv2FwRee6trrdvZXiLZmwTAvQpd3VaITT5V3W6ZF7BMCw40ydG3t7/ar7xrgX+LMpILkjbDmi2dwfI5uBA2Rk+lX2VZt7KbjfqcpSlnNxlX2YriEoJP/+G
 oa6SxQzi
 NSYQmY+KYg4Gocn1S0inG9b01d8zFhrlFr9ERudO3Bh5zLp90q981pdVi+XodBjUHi2Ld3SUfBZsGyYpKBN8JOU0F7whQqTwtf4hMSeE3xySix+2kCWV58RD/tX0fBZWXgK0DtcmzA+s24LKh7dU0MRX9huGFjQ+dZop9XVrooaYXSqg682W16zYerNyN+uxtncAVpG04e2zH7vIQDy3Bi+xWaEG5Oz8vyABZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When kswapd support is expanded to multiple threads per node, concurrent
aging becomes more likely and try_to_inc_max_seq() can lose a race to
another aging pass that has already advanced max_seq. That is benign and
not a bug, so drop the WARN_ON_ONCE that fires on it.

Do not change the returned success value in this case: a lost race still
means *this* call performed no eviction-enabling work, and get_nr_to_scan()
relies on that to decide whether to keep scanning this lruvec. Treating a
lost race as success caused threads to bail out of reclaim early under
contention, cutting reclaim throughput and leading to OOM kills under
sustained memory pressure (e.g. the Cassandra benchmark).

Signed-off-by: Ehab Ababneh <ehab.ababneh@intel.com>
(cherry picked from commit e14f205c5114bf2e9b13a733c71eb3372a1ba531)
---
 mm/vmscan.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 37ce6860c215..107011f51fef 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4116,10 +4116,8 @@ static bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long seq,
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


