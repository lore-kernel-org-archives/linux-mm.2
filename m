Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C936BCEBF88
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:30:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D24AB6B0024; Mon,  8 Dec 2025 01:30:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFC596B0026; Mon,  8 Dec 2025 01:30:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4E676B0027; Mon,  8 Dec 2025 01:30:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A3EB86B0024
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:30:11 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 77FB81A095C
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:11 +0000 (UTC)
X-FDA: 84195329022.14.034D663
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id B1B77140006
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RLiFBe5i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175409; a=rsa-sha256;
	cv=none;
	b=gnovX6N+r10v8/VNQis+ftcsDA81hs6VCOVm+FE5dpCaq60c67RCPMJR0ot3+j3Qym9TC1
	ZKP+8aX8qhbxC1UwCtFFSqAYeETXnRb4L3xjmWhaqclsYRVQvQYDgkbxTzxYuasjUT8tOz
	7pv5vGOy+nkxkJHAeN32Zr4KW7hhcfE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RLiFBe5i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HrQIdB5KzT9sskqp7pv/TG1fLcYicQqNKeP+W7n36J8=;
	b=Brn9c4G42FO/YUqdNbe3urw6FSajkH1wWtKTH1IJcd9M+cp909n2al6nSPCPEvBVEPTbvQ
	hTMP27SlE1zv75JPSumH1jX3DAt7TVEANoaP2y/wnD/pzmYA5ulIkh4GSiLlekkPu68OmQ
	2rlOncD+qojnxCTQUvnUlDPVLzkW1jo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D896F43F6D;
	Mon,  8 Dec 2025 06:30:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849C5C113D0;
	Mon,  8 Dec 2025 06:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175408;
	bh=BIoh7tGOQxVtDXmZY7UkJm8cloeuUXw++f1jh950BB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RLiFBe5iASWmPouudCyfwWsSiKUlu5UqEFg7KIkZQ/15AoC6ic71KPhH1QVqAemjA
	 As92e7k+awmI3oMmflwuPiaCwOgOXfB750LFYek0Em9a1uC/cVSpPE3OW2RSaXxIns
	 UMOV1bRFEhAyqm5pSNNbLO7on0TsM7STy06hTRilHUjQsWRaUyAMAeuyJBCC9Yk6Wq
	 yqMU0lkBOT3CYS9cP38/onZptUSA9GxM8y/5OywZnlUl2U3y99wX5KeliufVc801xl
	 WRbO8jkdXllfuVYJAgwRLrwFlQ3JeEKU1Pdc7BqduYfgJQ9sG8/Yg5KJUUTwxPHGeS
	 7m/a/Ud+zItLw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 12/37] Docs/admin-guide/mm/damon/usage: document sample primitives dir
Date: Sun,  7 Dec 2025 22:29:16 -0800
Message-ID: <20251208062943.68824-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B1B77140006
X-Rspamd-Server: rspam10
X-Stat-Signature: obgu5eopfys67gu55ihx4soiykjetr83
X-HE-Tag: 1765175409-320155
X-HE-Meta: U2FsdGVkX18fUPOnIqEJai/4X9ZAVn+sR4iBA1XAh5Z4+bsjnlZIr/ZgPlcqMe6IhybjFaLoIvyAuujhpuQ9Dznbx0eGxUYy9Pn1yAfAUEgXE+js8yo19CU6Fnlafjx6pJiN4AoH9SN81SE6jCc/xDKUcjW69tXTclAgRilQIesPutWTGIjBAZjUGdQec986s7woLyUjvB82IHaP8NoOvvzqCtySkuZ987u9q9DQJJ8DP2KcURpo+bLKFgFZIEhnXW2DlwfeTwUmMHYphzUmeVjmG1W4Ild1k59jV7gD51ygWfGCFQeb7xWu6JPX8TvsD1JbZSlSpSVCgGYCZj05GbURALnE9m9t4GCwp9GkhtumBbtiEs2H6/HcGecwa8SvAYUl0WOHaSWzPhrNa9z/Ftx2siLs9BBYd4L/Xpvj5gS9GGmhlsN1Q0G3d7tDr0HkDBnImS2hwH7yiJdY3DOw6Yfp2GqXlWV4Nt2fGZsQHrSA8qnEmw40AhB5Ud8tMHBIudhMuM2UHV9J3NLHznC4Ti7OMIlJ42o2cwzeD3/WaTNmOGzskbDugyot+n1WPBMNClGCTXXIvhuHL/IpV7cwyeu9O26pQgYjF+s+b+s/p00seCfVQXxRCx5h4XE3jlfLcpVpaGdGUDSgFgHpkpgm1jxUExBMs3vixr550/uYS39iC5tqRxrZpmbPx3u14DzPSGCKuw72MVfVWnmtSu4gTQFnHtBLv1Bpg0fYsoS/RNU8p8R5ldC0qvx/gkFrddqvxvZeRgeBHFNTHfaKhSXUSjA/ntOP8ZJlnkft0naeHxuJw8YQcTm7JyqFd30vp10VC8Zc1cgvkFptxJVmW5xtN2EF+4JSNlcF6+jS4MV7YmToO5E7FJWXXwCqii0oO1689DoLhfOv3oSZCR9+g1mwgvh+k7mSsOG+Lip73w+z+Cp80sOXnYnkr76Om+LExYBWvV3gDexyVSEpeV2lJSI
 7Q11Pf2i
 OVqOZsK+4PgHWAAcKsJhInAAGfOhXEZKD8jU2yebX2P9LaIlghOYM2U4AatfsQPHPummqXdA4IwWEpPRPuc0a5L/CaMCLuSGwcxhkXmKVvI56GzaoBup3rv2Pq+uhVsZCWG7q63yfQa28EXDBZpnIgW/YWV79svr1jBod41l813ldAK0hA3TEIKe4bnHj6SsJjVh7FMAzsYQ8S5UcRFXpCo8h5y7ox+8hBnWsRwBvAmYZ2Tyo91TlMgrHMovj7BEBf9e+FWOpD9/lAirIW+UduQJgvbs2UX3oJpD8vZXiPvjEJCI9pIJyg6a6Ww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the selective access sampling primitives
activation, which is essential for using page fault events as the access
check sampling primitive.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 7da4c002cb39..897a89950351 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -65,6 +65,7 @@ comma (",").
     │ │ │ │ │ :ref:`monitoring_attrs <sysfs_monitoring_attrs>`/
     │ │ │ │ │ │ intervals/sample_us,aggr_us,update_us
     │ │ │ │ │ │ │ intervals_goal/access_bp,aggrs,min_sample_us,max_sample_us
+    │ │ │ │ │ │ sample/primitives/page_table,page_faults
     │ │ │ │ │ │ nr_regions/min,max
     │ │ │ │ │ :ref:`targets <sysfs_targets>`/nr_targets
     │ │ │ │ │ │ :ref:`0 <sysfs_target>`/pid_target,obsolete_target
@@ -215,9 +216,9 @@ contexts/<N>/monitoring_attrs/
 ------------------------------
 
 Files for specifying attributes of the monitoring including required quality
-and efficiency of the monitoring are in ``monitoring_attrs`` directory.
-Specifically, two directories, ``intervals`` and ``nr_regions`` exist in this
-directory.
+and efficiency of the monitoring, and types of accesses to monitor are in
+``monitoring_attrs`` directory.  Specifically, three directories, ``intervals``
+, ``nr_regions`` and ``sample`` exist in this directory.
 
 Under ``intervals`` directory, three files for DAMON's sampling interval
 (``sample_us``), aggregation interval (``aggr_us``), and update interval
@@ -232,6 +233,18 @@ writing to and rading from the files.
 For more details about the intervals and monitoring regions range, please refer
 to the Design document (:doc:`/mm/damon/design`).
 
+Under ``sample`` directory, a directory, ``primitives`` exists.
+
+contexts/<N>/monitoring_attrs/sample/primitives/
+------------------------------------------------
+
+This directory is for the access sampling primitives :ref:`selection
+<damon_design_sampling_primitives_selection>`.  Under ``primitives`` directory,
+two files, ``page_table`` and ``page_faults`` exist.  By writing ``Y`` or ``N``
+to these files, users can select whether to use the :ref:`page table accessed
+bit <damon_design_pte_accessed_bit_access_check>` and :ref:`page fault events
+<damon_design_page_fault_access_check>`, respectively.
+
 .. _damon_usage_sysfs_monitoring_intervals_goal:
 
 contexts/<N>/monitoring_attrs/intervals/intervals_goal/
-- 
2.47.3

