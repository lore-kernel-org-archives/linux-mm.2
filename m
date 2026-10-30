Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92F90606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 03:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=sFWn6Osd
Received: by kanga.kvack.org (Postfix)
	id 877766B00EF; Thu, 29 Oct 2026 23:24:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8288B6B05B1; Thu, 29 Oct 2026 23:24:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F0206B05B2; Thu, 29 Oct 2026 23:24:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F2A26B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 23:24:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6BD5CA0611
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:24:38 +0000 (UTC)
X-FDA: 85377850236.02.D22287C
Received: from mta0.migadu.com (out-26.mta0.migadu.com [91.218.175.26])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2B12F180002
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:24:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sFWn6Osd;
	spf=pass (imf24.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.26 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793330676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YxF7dRKdKAp6T/NOw/hryWAVYb3GZKlSovGXpa5oCY8=;
	b=lW8qZ+b8BWQb5cO97JruHQcG+T/RuYW/RRiXwxDtQe3X1l3kRunc9jADczH/p9XwB+Rj29
	eDJr6cLZvyvqRHDi98Ee6SpN3zeVyFNbgMo73RgLP07XcfZQsBJVatPYk10iiU3oj5YnoW
	puX7tFRGsDlZuxvyT0sU7J6Wuif4asQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793330676;
	b=jPIawKjCSQWxx2NkEER8Dq1ewVGA5728toSB+HLEuLunNuVdFLVt0AKvyIj36AK2BwnXN0
	A0zZiXRpieRkEGZwNJeb4s3RKa5ue7e0sAC8zvfkD/fi6tFaT08YOTeHF7St/9zu2eQiDq
	txUp7guBWMRy5bxdBxPJmk0RZ8YruK8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sFWn6Osd;
	spf=pass (imf24.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.26 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=K9e2xpCltZ0luCSKJ76+rRB5TbBjqG8Rs7tkxWAziAc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793330674; v=1; x=1793935474;
 b=sFWn6Osd3p26eREcmcIASru+spScdxjMfW23b0Y2POx0A7cPjdRAZnOrHq+XGzSQm8O8znSL
 GcPW+KYbC/rayHgTcZsEHJo0uyjZtTCnQEGFm/LVMX+PMJM2sOtnbK4b1ngvJXY84rWZ79OpEq2
 myhFIaTzDDfiCZo6MKBT4eIY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 13ff5ce3ac3bfaeb;
	Fri, 30 Oct 2026 03:24:34 +0000
X-Mizu-Trace-ID: 13ff5ce3ac3bfaeb
X-Migadu-Flow: FLOW_OUT
From: xu.xin@linux.dev
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	aneesh.kumar@kernel.org,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	harry@kernel.org,
	hughd@google.com,
	jack@suse.cz,
	jannh@google.com,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	josef@toxicpanda.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	kasong@tencent.com,
	kees@kernel.org,
	kexec@lists.infradead.org,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-arch@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	matthew.brost@intel.com,
	mhocko@kernel.org,
	mhocko@suse.com,
	minchan@kernel.org,
	muchun.song@linux.dev,
	nico.pache@linux.dev,
	nphamcs@gmail.com,
	npiggin@gmail.com,
	osalvador@suse.de,
	pasha.tatashin@soleen.com,
	peterx@redhat.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	pratyush@kernel.org,
	qi.zheng@linux.dev,
	rakie.kim@sk.com,
	riel@surriel.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	stable@vger.kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	weixugc@google.com,
	will@kernel.org,
	willy@infradead.org,
	xu.xin@linux.dev,
	ying.huang@linux.alibaba.com,
	youngjun.park@lge.com,
	yuanchu@google.com,
	ziy@nvidia.com
Subject: [PATCH 38/46] mm/ksm: reset the unstable trees of all nodes
Date: Fri, 30 Oct 2026 11:24:09 +0800
Message-Id: <20261030032409.127393-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261027-fixes_core-v1-38-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-38-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2B12F180002
X-Stat-Signature: 9aahwrq6g8e3yxhwu7s4ate8xpr7woig
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793330675-776194
X-HE-Meta: U2FsdGVkX1/SIw6ERtfuYDYKjKNarXMxEA10O4S6I7V3vIYalbZHJr3B8OvdDuEWtoLsX5O+Rvt0E0WITK+QJdH2ick1EBdkvgITzposUoez6HMQY0ztzJGhKA70yrVKat9hLwiKhjJhRYVcdkV6vg7kCB7u3kbZjuTnW+rajuHslXbwHfFyl7a5rZkNZEaR3oSc4CA2KQfITrg0ZsBDVmN5DNIWDHTkj6lcOqgt3KqeKWJjWVcuu+V1RrtiyTYtr8ywgunz9U80FznI5e5fLlC0QZKcPv8NGBQAS8JMGB/m5UzW3vx+Wncv6U4aeiFNRMNRZ4f2VDp98oJrPvfREEb7qCbmr3HqkO90v0QEeo+D839QNcnB9ayxMeXdYvL563alLBrqtDadClhsT1BQNMEdSIiFQtDqAnMi7JieVq7g/ecVkXhysSXEf7dJCGC22ib41KCxBSGWnsH85cxEiHsVrHz2nW5dnnHXbN47dHrMe0T8jheAWxzTfjKgD9gNKxI+Ebut5bzAEnigiv/pODz3EZuFaeB7JUiRejYuTTUccujUhK9Yexk/xhzb+dRvNy+KUiV5Pk3Dgk8oC/2KNqn7G0g2mNiPDKtw1dZnW+1qDIBMuexdWwY4iD9ccVoIE4RxpNpBs7G9zUiMeshR8zOsd1ddJB2K1TX6/AJWsw401mihQj3fDddRJrOf2hvpM8YbTxc/ZYvLOdkQI+EhKtzn/DKymev+TPHg1xHzTyupzFRRKOjcu+vyGyp3eaHxyAIlW5tUANQv8G4z/DxbzkNArFZwc3wb1iQjLUSo5M68uV/hN4W5iDBgzknsllVckFEimJtA9c366JRd66gdmoqQZ0k+5WEaZIXUjtiwb3SQhk1w/buVst4LFb3tpAvCvGJ9EP5x7vvhzWvkJnK2nOdkKYUcYnmn0P75vqKakjczM7Vz163SadUEVZHi4UyzdmUErKFysTzpR/fOT//
 j0stDc8v
 XAelvl9U0Mc4afE9cf9eZ1pSCL7eysDM4X/gRDzQsV1Jq2+nltBm2ra9XEkIeSNekOo22bkf3SE5XRrfqTcnd4K3kH60EUgyPFmbbGiSP1VMJorEAsPjTg+tW26OoV2k+oNo27p+QF3vQbBRVFvExNn4ijRoalABVeebTz8tJg2H1wuTubbwSgtBGuKzrYdtjFMNqXvAbrheCVzJToLn5hL6FHmGeySeSgQ/iKp8VlUtwQGa/0ZFd+fx+78wda+uR7ytxYCFrL7LtjtPLSdLxghF9t8qfZfLlk3u3dV8rDr6Y17yWX+Y4u6cPSRUBbb8AtxG11pBUNK6/t3M3KfBahAYu7M5YA7ZaNw5jrPktRLHwvWv2q1oZgD+nLvvjlR+uRxmw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> 
> Let's fix it by tracking in ksm_nr_node_ids the actual number of
> allocated tree roots.
> 
> remove_all_stable_nodes() and ksm_check_stable_tree() will now scan
> more tree roots (skipping the empty ones), which is harmless.
> 
> Fixes: ef53d16cded7 ("ksm: allocate roots when needed")
> Cc: stable@vger.kernel.org
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/ksm.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index dbfb8f98b1892..9c51925825cbf 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -475,6 +475,7 @@ static void advisor_stop_scan(void)
>  #ifdef CONFIG_NUMA
>  /* Zeroed when merging across nodes is not allowed */
>  static unsigned int ksm_merge_across_nodes = 1;
> +/* Number of allocated stable and unstable tree roots. */
>  static int ksm_nr_node_ids = 1;
>  #else
>  #define ksm_merge_across_nodes	1U
> @@ -3636,14 +3637,13 @@ static ssize_t merge_across_nodes_store(struct kobject *kobj,
>  			else {
>  				root_stable_tree = buf;
>  				root_unstable_tree = buf + nr_node_ids;
> +				ksm_nr_node_ids = nr_node_ids;
>  				/* Stable tree is empty but not the unstable */
>  				root_unstable_tree[0] = one_unstable_tree[0];
>  			}
>  		}
> -		if (!err) {
> +		if (!err)
>  			ksm_merge_across_nodes = knob;
> -			ksm_nr_node_ids = knob ? 1 : nr_node_ids;
> -		}
>  	}
>  	mutex_unlock(&ksm_thread_mutex);
>  
> 
> -- 
> 2.43.0

Looks correct as far as it goes, but I think it is not quite sufficient
on its own.

The documentation requires that merge_across_nodes can only be changed
when there are no KSM shared pages in the system, but
merge_across_nodes_store() does not enforce this at the sysfs level.

Should we also reject writes while ksmd is merging? At minimum:

+	if (ksm_run & KSM_RUN_MERGE)
+		return -EBUSY;

Ideally, we should also check that ksm_pages_shared is zero, since
KSM_RUN_STOP (0) does not guarantee that all pages have been unmerged.

That would make the interface match the documented sequence and close
the remaining race window.

