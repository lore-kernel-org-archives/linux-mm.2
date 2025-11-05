Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BECACCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 21:04:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B8628E0016; Wed,  5 Nov 2025 16:04:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7904F8E0002; Wed,  5 Nov 2025 16:04:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A6668E0016; Wed,  5 Nov 2025 16:04:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5969D8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:04:52 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 00500B9A18
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:04:51 +0000 (UTC)
X-FDA: 84077782824.24.A603A24
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 63F541A0004
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:04:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W3jxBxnc;
	spf=pass (imf19.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762376690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jo8Wdjvj3YfXYEEpEI+fQEmDmOtHAHT+I0W8XkKzZIw=;
	b=oXicYtZ4t5SESizxhhvLxeMQJVCaPMW0nKNZoWlMEAHYhPeklS4TtW2quGJV4y9iD6ybIO
	OMqPKOaecxS3BkMwTC0MHvPoibCbTwATQO9hI2cW7qEsmCP+2WF4L+IyHzi1XnaNZrWYuT
	lpAH53L/2ShQ2Th4ElR6bPCL8MgowU0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762376690; a=rsa-sha256;
	cv=none;
	b=IOan0RhGCl4p6nWwJKZwW98+EmNRomONai1sAylsVREtIMKBDQP3vk9cgJc9ivzRkdvG35
	OygfX+VSq2Sq8hWdEafT6khBBBTIoadjCbNp+XBOIA4/CqnZoBKvg/b63vGjUQnigNGhlB
	E3+K4x3jlokSOpeulunvNQHR7pGaRr4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W3jxBxnc;
	spf=pass (imf19.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A0DBC60224;
	Wed,  5 Nov 2025 21:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F24B5C4CEF5;
	Wed,  5 Nov 2025 21:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762376689;
	bh=4bRWbV0YuzmDy1B/sRgCWln6RMh7KL9GReKc3Nnqm6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W3jxBxnchXPJZKH2so0QCGrjyVavB6XgcFLZnwbf0ylrkboEezz9X/2eMG8q91HHH
	 IAy92pFmbbdtvG33O3dU7hzjvMro+XMvvQrNO/4OHnD9UvLBMJlxfs33g9qiYG2hYK
	 Z0ilCk2hxybBfgiC79MXfe3wp5DcBV55tZ8C2OtTr6lrdTxYZyW0YhSWQqXLYhiguS
	 KJRtlYb248Pfs9ZOvisxol44RbREaI0m1UwUFynnMWwx9v9jprD0lSiNDM6UD69QkS
	 z51fmf04HQKK4hqG5yCwVC8LmdU7H4H6mQNm+oJwCuT4iwU5cBY2Mo98ASdwndibIo
	 jTUvvHb6LCGVg==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>,
	cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH 06/31] cpuset: Convert boot_hk_cpus to use HK_TYPE_DOMAIN_BOOT
Date: Wed,  5 Nov 2025 22:03:22 +0100
Message-ID: <20251105210348.35256-7-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105210348.35256-1-frederic@kernel.org>
References: <20251105210348.35256-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 63F541A0004
X-Stat-Signature: 89781f8qyar7txcpxxzo1pwqdgs9eaiz
X-Rspam-User: 
X-HE-Tag: 1762376690-476009
X-HE-Meta: U2FsdGVkX18jU1hpnGwSUmP5+wGdF/iRJpGUyOoZ5Kn8FHutc/vALmNzScxg4V8knf/DUyvVG84cFvf0doEaREqIVQdLgyzDyEMxIl/g5ezCZrtS/C0iQyWNBVtewyU/q0PV4au+LyC3FJpwTJ3Wr+9btq7w7teGAC5rxB1jsau+Yzb3fNswM8bT/3IKflijjFdPqp3SKbYhdRKRSd7FZjNEUvFTBUsdYoWdM0aN32Rg9vrjV4h4yZX0qWpX0jAlmoKhM6v/XUXSfwc8gis8K/HVvSTtWOHh9Tx32ptzmJtAZr28N8tFTLkc4bXDM+EG6UW7X+/jytWbpIvnQXfF6BXZ3gOSJ+LVgpYeqC9yZBluD7uo7PPfKz1PvBOixbqUSayu9dWDHEUXGs71GAD/8R/HcEbdFNqcXl8pFf+mPdy4YjmYipfteByGJQmth+NuxExWEva1kIAifsAqYisFoTEIvL7+qRo6ZNmOBZv2axeh04IYDaV3h/wbcjGB2sxZvo05/Xef+4pvEQt0nGt/mTXLgvz5LuZOXcmSmVBsTik8lm8hLpkKzCiGSMO8uQBPqcZctEgxygHVx8yvr950UZGO24ujr+fzFmPZUIzgIZSxX4QYbX0JhmUReQwL371gBaVAnVXA1kHsG2+7uPDfsuOZteslPy5GsJiXCsfCW3jZ/enB6J9cwjnE5WUt/ucMDn2swAbAayGhcnW5B1QGXY3wx5KP7m6ZIxc6++ggIv3MmUc6NGz8Qb/+tvZvR8lr0HfPPxcB7x0yWQXsW51/kRg8y1GPl/6zE927HXh9wYRyF0B7YVjARjyRXU6RS2ikSYW2ZWBahwkiIyg93v9k389G9/d/tUflbUTGDpAPziLnbWgfSPhAOV9sxtmz+QnTf255zWh8qjKe7PGMD0ADVaUIDQUQFirZ0HiidDixiupJAkCeBx1Itu2KlDIrKJiNC0rYDkhMRtgn1NHb2EP
 6LLXSPKX
 YSzj+cimGeBsahCy+OrrTxo/vzzNRK5hbFMDX65JvKyH66/nZdWR8MjpBBDoLo7clKNqsUEUqAkIklpjdxT5mQNCuo+WCy4U2jPo4WFu51xh3H5XYWRFc6pqMrGYwciAXHTxwdmpoVhOKb+FgAeFumGChGPul9Ru/k6J9w1+C+53TNvewsngn3ViJXbg/EqitwAFsZgjUVrkaZVpqDF8KAQm3LieFd67bLDH6qHLPQ4ayt1lhx5raAK7jogawqcJ2DCqm61PVka07cEH1ueTrPD7hnFqBAPxkLlF0EVDlW05kgSZpQCT9gcG+yLd0oQpL17Au0c00eATVtvDCyXMcklK3vw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

boot_hk_cpus is an ad-hoc copy of HK_TYPE_DOMAIN_BOOT. Remove it and use
the official version.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Phil Auld <pauld@redhat.com>
---
 kernel/cgroup/cpuset.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 52468d2c178a..8595f1eadf23 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -81,12 +81,6 @@ static cpumask_var_t	subpartitions_cpus;
  */
 static cpumask_var_t	isolated_cpus;
 
-/*
- * Housekeeping (HK_TYPE_DOMAIN) CPUs at boot
- */
-static cpumask_var_t	boot_hk_cpus;
-static bool		have_boot_isolcpus;
-
 /* List of remote partition root children */
 static struct list_head remote_children;
 
@@ -1686,15 +1680,16 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
  * @new_cpus: cpu mask
  * Return: true if there is conflict, false otherwise
  *
- * CPUs outside of boot_hk_cpus, if defined, can only be used in an
+ * CPUs outside of HK_TYPE_DOMAIN_BOOT, if defined, can only be used in an
  * isolated partition.
  */
 static bool prstate_housekeeping_conflict(int prstate, struct cpumask *new_cpus)
 {
-	if (!have_boot_isolcpus)
+	if (!housekeeping_enabled(HK_TYPE_DOMAIN_BOOT))
 		return false;
 
-	if ((prstate != PRS_ISOLATED) && !cpumask_subset(new_cpus, boot_hk_cpus))
+	if ((prstate != PRS_ISOLATED) &&
+	    !cpumask_subset(new_cpus, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT)))
 		return true;
 
 	return false;
@@ -3824,12 +3819,9 @@ int __init cpuset_init(void)
 
 	BUG_ON(!alloc_cpumask_var(&cpus_attach, GFP_KERNEL));
 
-	have_boot_isolcpus = housekeeping_enabled(HK_TYPE_DOMAIN);
-	if (have_boot_isolcpus) {
-		BUG_ON(!alloc_cpumask_var(&boot_hk_cpus, GFP_KERNEL));
-		cpumask_copy(boot_hk_cpus, housekeeping_cpumask(HK_TYPE_DOMAIN));
-		cpumask_andnot(isolated_cpus, cpu_possible_mask, boot_hk_cpus);
-	}
+	if (housekeeping_enabled(HK_TYPE_DOMAIN_BOOT))
+		cpumask_andnot(isolated_cpus, cpu_possible_mask,
+			       housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT));
 
 	return 0;
 }
-- 
2.51.0


