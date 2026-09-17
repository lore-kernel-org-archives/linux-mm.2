Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22A1BC88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:08:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1B426B0093; Thu, 17 Sep 2026 12:08:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CE0F6B0095; Thu, 17 Sep 2026 12:08:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 895396B0096; Thu, 17 Sep 2026 12:08:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 531716B0093
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:08:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C9F2840407
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:08:41 +0000 (UTC)
X-FDA: 85223737242.25.95C60CC
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4CBDF8000B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:08:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=NEDpr4x+;
	spf=pass (imf02.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789661320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oWDjAmBCydWzvPv+GolAERB9gr9l6TVcbY9rwhPWq6E=;
	b=c2H4BpTo58354Q3x1H62BuJmq7MphHMLqsrskUKGSLpzVq62qmyVfsKzrX0kV6zUGcHvPY
	oG+lK0ERdOKq2sWhIv5ywkNG5SNYC1nq2ID/flKVs7iFgRK3OvAtsqMcJHHwAxU9J8j2i4
	CSVYtltDxM7ICAsr35bHYvj/VEUbV2Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789661320;
	b=SwAalJglLZBqhS6X8lbeEOUknJyIOqNzy0qIbnfZy5C/HGML11Vt8ZJal3LNJaV1XUNU3p
	ST3XKbuAwpgacORLWkZFqfOy/Ay/Y7LbUI5RoswMbZDE+fQOKnjT70nesHlM7m08r3Syaf
	qVe+ubaRNNH2bGvGsufQ8fMBvH1jDg0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=NEDpr4x+;
	spf=pass (imf02.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oWDjAmBCydWzvPv+GolAERB9gr9l6TVcbY9rwhPWq6E=; b=NEDpr4x+8B0oTWM8fFOyQZTjyB
	dIXmLDO6p4cNlf0T7QjTfAh2vTlfCR6//DMWHw/3AVPhOweIPw5qnmx6Y4VVD1+CG2eVwm0RnvDWf
	oE7r9iaRDwfoYinmsvm4WkaGS4yXBGec54V3h3CN+RkW7ZtMMivfJWt8ctYuzi8RUghtU65t6MG6d
	kqOe9l3mxI06Fs77APAKODML3z8S64NtU15bxWuK6nXwKwHOUNHrYznSkzHA16imjAuVFnvkTHitK
	lC8nqxc8VOSVIPz06oyDCm7rdrDJgiyqme3pmQ0SOSIY+XBHVQnh9fHCwARs9ZkzTNhbADWUqB5bz
	ySjpXZaQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x7Eex-0000000Az3O-3ujw;
	Thu, 17 Sep 2026 16:08:28 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 7C1AC3030A6; Thu, 17 Sep 2026 18:08:27 +0200 (CEST)
Date: Thu, 17 Sep 2026 18:08:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, mingo@redhat.com,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, nico.pache@linux.dev,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	jannh@google.com, pfalcato@suse.de, osalvador@suse.de,
	hannes@cmpxchg.org, raghavendra.kt@amd.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/4] mm: allow shared folios to be promoted to a fast
 tier
Message-ID: <20260917160827.GN4121339@noisy.programming.kicks-ass.net>
References: <20260911001826.2109390-1-gourry@gourry.net>
 <20260911001826.2109390-3-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911001826.2109390-3-gourry@gourry.net>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: eiyrxdsynjgmfs1bb175kqowfpq4wcij
X-Rspamd-Queue-Id: 4CBDF8000B
X-HE-Tag: 1789661319-196536
X-HE-Meta: U2FsdGVkX19Wjr58yS6zHgQtiwucIc1RzLyuCoPq1ZqixWbja2hcFWGfL/rWsh9tXMoYzfXCcFPTM7yEbPw3xGdVpz5rayH/yjUg6mmB01B5x4l1P5L1a5TlQ4DHsQkwxRHNmaW/cGuRNjDN6y799oNhqdiHyzrONR42iu0g75refZY2n3ykHSEH8XLDfYyhAL8HkL2227AIytMTGC908JCBUbvXZwR3x2uNlnsAyR/zshZQTPYOi/hSHaGqGthrUM2hTiM5zrb8370fvUxnIaCutNnqwv+NvWURbrbLbHRoudMjbeHVTri02nVT3VyhxujTTda6f4UUJoBt2+6ujpyXqwwLWC+gaUnkvolrd/BU3lvvEmJpf4WgxK0c4l89LEsHp4HH9vj9MY6jVn2PzTmjksZoPrH0HZ20be2nikK6dUd/cEnWcqfD2THqoTqEQLFwUYwtsZVpj24aM7h1Y3hStwTAuSkrTU19cixS4j1vtmZwAJCNmPOW8Mgrd/Z1Yh4wUPBMhdnpPs7mXNO0WEqOA6iZStOZP+hgkMj//0uPynlQrD+GcE9MwXUqbf3G1OGA2WK7Zqh61KFUuyXf56XxeOeFOvp/f0rHBy4N5f4vVq1SLpbLPP4J6n2t4D0DN/u+/MAQ+bU9dILTdA76rBZuDh0BVfdmmNLeGzJpzHLQS+CuZSjNDqCcO2DjDK7Oel4bXXJUB2I5wASDW5/WLFNy+cKcHWem+8ByaCWBb0reGCyBjZdd/u6t2DRcwcmaG/ga8PGYQMM0/vn4v9wY4Ly7sXRZj+bKRpMOi6FpCECcL31s1SGsZP0BH01eiubkSpmcHecvWn0IW9S5DkWlZiWpL6oaHfwmObO9oSz5CowqOYNrTFkoG+ZmnZBTKIkX+9hOqouAAmtKzdVtYErzS0P/Iuf088OBzhoXQ12xPRMvq19OZiirVKKZDAw0sSbMSjMv1QGB16JwHFeRndK
 lQcfcvKR
 PWKSyEc8PvPDCJZ6M4OSOV7R/pyEsVQizqumsdKVPvrn9zpn3RM49BkxxdsEg8qklkqqbZGLK1fjMYjZLl7DdWW2nC3CQf9BaTZJcI91YMtLWkNpGMCyIqeObwM6P6FLh6Y2rVgjEHZSPZPM5Ck5kebMGcK0hIuWui76NkjHg2UkuQuoIDCecX+37o54K+4aQDq5aEAi2gCrRYsPe/L38GCwaiPCkly8UAOalCOn+MfzSz6wbiSB0/ydesaJPRZ+7yJkJQUQZz0UN/caDE8Cu32ib0EHlooe3C1CJBowlr7a207Zx4FDKjnWWLvri/WtxLo+2UOBWTNevYiOm3pz0J9jo7BjymNnYBwnRvJnhdHoXOgA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 08:18:24PM -0400, Gregory Price wrote:
> From: "Gregory Price (Meta)" <gourry@gourry.net>
> 
> NUMA balancing rejects shared copy-on-write folios and executable
> file folios mapped by multiple processes to avoid placement bouncing.
> These checks also block promotion from slow memory.
> 
> Allow such folios to participate when moving from a slow tier to a fast
> tier. Keep the existing restrictions for ordinary placement.
> 
> Fixes: c574bbe91703 ("NUMA balancing: optimize page placement for memory tiering system")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  mm/mempolicy.c | 8 ++++++--
>  mm/migrate.c   | 6 ++++--
>  2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index a082ccfa09ec..19b599bc2dd1 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -863,8 +863,12 @@ bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
>  	if (!folio || folio_is_zone_device(folio) || folio_test_ksm(folio))
>  		return false;
>  
> -	/* Also skip shared copy-on-write folios */
> -	if (vma_is_cow_mapping(vma) && folio_maybe_mapped_shared(folio))
> +	/*
> +	 * Shared copy-on-write folios are poor NUMA placement candidates, but
> +	 * a hot folio on a slow tier still needs a hint fault for promotion.
> +	 */
> +	if (vma_is_cow_mapping(vma) && folio_maybe_mapped_shared(folio) &&
> +	    !folio_use_access_time(folio))
>  		return false;
>  
>  	/* Folios are pinned and can't be migrated */
> diff --git a/mm/migrate.c b/mm/migrate.c
> index a369d0c95c38..afd9c97d2389 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -2697,12 +2697,14 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
>  		/*
>  		 * Do not migrate file folios that are mapped in multiple
>  		 * processes with execute permissions as they are probably
> -		 * shared libraries.
> +		 * shared libraries, unless this is a promotion from a slow tier.
>  		 *
>  		 * See folio_maybe_mapped_shared() on possible imprecision
>  		 * when we cannot easily detect if a folio is shared.
>  		 */
> -		if ((vma->vm_flags & VM_EXEC) && folio_maybe_mapped_shared(folio))
> +		if ((vma->vm_flags & VM_EXEC) &&
> +		    folio_maybe_mapped_shared(folio) &&
> +		    (!folio_use_access_time(folio) || !node_is_toptier(node)))
>  			return -EACCES;
>  

Semi related; I've often wondered if we should still account shared and
pinned vmas in the fault statistic, even though we should not migrate
them.

After all, those pages are still used and by not accounting them in the
fault statistics, it becomes easier to migrate a task away from them.

Using the scanning for two different things has made a mess of things
though :/

