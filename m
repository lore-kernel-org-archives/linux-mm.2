Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4865606A328
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 01:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=jYFWQMOg
Received: by kanga.kvack.org (Postfix)
	id E71F06B05B0; Thu,  5 Nov 2026 20:44:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E39F76B05B3; Thu,  5 Nov 2026 20:44:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D50A76B05B4; Thu,  5 Nov 2026 20:44:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A9AAC6B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:44:55 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4C7F840CF0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 01:44:55 +0000 (UTC)
X-FDA: 85403000550.12.DD0FFE8
Received: from mta0.migadu.com (out-88.mta0.migadu.com [91.218.175.88])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2EA8440005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 01:44:52 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jYFWQMOg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.88 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793929493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D1BQyEii6F0Q1y4egErAzidghcHKqUk0a8SnAS5enws=;
	b=qr2BLjOvcmplyMaQH0vTKtG9cDjoY5AWcmy1W7sjeORsqlujp4ldUuNkLHvA+FLtqcDKUY
	wsW+LGNI5Iuw5aikFFB11QWydHzbtCVcg6zQJvDADnQeBO5pOQa6eOVOJgsBh7HP10PFRc
	9Q0PZi58P8yNs76loWS53TjeDA5I97I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793929493;
	b=HUGmOxgL5nrY1F2Ri0zXRlPPkuthIJBdRKT19Yc7uEpbTDA/+8lQrTMc8gQyuEIoJqJhRl
	pOINpQWIR2Y/BnSCklGNydlomYSgm/+jMnLkEKeXN2YeUro+K7WF79NuqWYqq/TNXexZu1
	AGYo76d5c62XCpoN4uVPNSuOELY2ero=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jYFWQMOg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.88 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=h0d+yOrZ64mGc0iSYwHwgGdKZilHQ9XexIhOgkjacwM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793929491; v=1; x=1794534291;
 b=jYFWQMOgfpkZ3mBb54JklcG6tzN9HnFBLmJXkcokoa2V6NhjxwFO0SANbAxuStk3vhzs13PK
 rcj/5dhCYzxFEvL1fa7/lj5SxJN4AE+F3z0hlp97Q6gr3qqzMQaGTUTTvVQLLb7g5UY7gMzKifJ
 lXdgdK5Tp3u0ic4lgbiJCIWA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ac22e0871729a49a;
	Fri, 06 Nov 2026 01:44:51 +0000
X-Mizu-Trace-ID: ac22e0871729a49a
X-Migadu-Flow: FLOW_OUT
Message-ID: <76fc7cbb-11e8-4591-bb2f-d6fb8ac1fbf3@linux.dev>
Date: Fri, 6 Nov 2026 09:44:44 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/hugetlb_cgroup: prevent use-after-free during
 cgroup offlining
To: Daehyeon Ko <4ncienth@gmail.com>, muchun.song@linux.dev,
 osalvador@suse.de, akpm@linux-foundation.org
Cc: david@kernel.org, tj@kernel.org, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, hongfu.li@linux.dev
References: <20261020103057.8066217f6f6fc5b3ed84c90b@linux-foundation.org>
 <20261022022146.506005-1-4ncienth@gmail.com>
From: Hongfu Li <hongfu.li@linux.dev>
In-Reply-To: <20261022022146.506005-1-4ncienth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oo9ccqt6njk547pjamptuhbuadwqsox3
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2EA8440005
X-HE-Tag: 1793929492-102198
X-HE-Meta: U2FsdGVkX1/vvXEdDwPXNTQu3oBz7KqAoM7VeO3K1gOKGR38G8PuXhzJACDzlXJdeVkM6zXTLqqCiMDvSRGdEuFpt15na6JcAlirrdBj8OKJ7ue2+ko19tEZ3Ws+D2cXLAvZ+asa/x04apo3Qdc9J4znyzaUq9g9lTTrr+8Fwd4D6Mul72agh2juK0Rby5w1uXllO9gnwkVwzffh/PPJDldlPMykIR5MqWBSpVGgNr4aywBA64t+qVp0xv1yroWz+l+mov2t9e+dnVPweI3RKU/xRyCwu9w+7shEZd9Dp4EEyuUAun62rkxVLH1iW4McUxxJbT+AKEp3J2cCnI1tLLd5OhxY4h+C9x/rse+eK/k4cMMtyCQkmQBD6sFFwQ17IziqvJZaauTM4oKJgLna4kIBBz9dcjK0Df3LMNBqWDK64xcwiSGIeJixhcaMJIgD/tT3cSR0SwUFpE8c/TmbXtpH7XzCiWL9ro4nOkIwQzpYu3nOXVyxtZtTKjxTPTEnuAmjcvuobgLnPmgvCA/sYcu0HTBV7jLz4pxR6y6bKWl8fu/BabcYxDTdoXO0Zn6g2O+LS5cRL5m8xLuVER7YpbVlBc3Sx1XruUVfpfajkLL1iH6q9oGXtVsAg/e71kuxO5+2UHztcFNU0LFDOy/VNP5Nnc6wTTTxhoBhinNjnVygl6HRrdT7+BtdlFiiBm4VZ3hjJvG1tlL1LwnomweeOL52kPg2UBOhgUJYysiwiPuzsgJ58vJXh2ufkL5sf6bkraAfu/RdQXF4dlKgW/0K5bfzNj812rwZVfy6va1MSQyxwQ6XJ38n7RCQfG7ay3f77iT8Iar1PF/VD/ZsYS5e+KyRylK/NnfnKMO6uSg7PRG5nKIJjkx/QtnK717Xn6ImYtrTWFNS3tijP1HxWai8L+DP7g1Odg6lhw9k8V7nrm/ou/GRHoGDNPboioTr+9KWdz3xLNCby7qS6krK00S
 S1y3ceOL
 7xqpUYagiBBd7gqZg6aun4Jm5fui3MLH52exSuIXm4GF8D8XDQixkBEAEQ80LZ1sPS0W8daWvSXogNUuj3WT1RMSxBo+MEo+Bqu/+NY7qtz0LH6P/4sIDFvOdMcyZ5nlVH+k17+05tTnZvFRfAnvESp+E6aeu1Nnni96mGDmwBC+rsFFP6PZxbbLa42SOxecpcryVDURB+c4m06nfb+fHVMd5+cuxutLajfT1ho6PADTK0XOq0o/8Adh8qaDyM0B1TKr8LC7apxiB6OLMylS/pvMxdt6CtqkcYFE9mgpZonP6HFLLi5FafXGMV15ZHVmLr3mFD+GpmFZvgVl+hcEt9NB7IgNaRpuMyr5wcnWIVs/tIZVeOxzpHr8mpYZlr8YfXYf7/DeqmfBj1n8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


在 10/22/26 10:21, Daehyeon Ko 写道:
> A normal hugetlb charge obtains the current task's hugetlb cgroup with
> css_tryget(), charges its page counter, and drops the CSS reference before
> the folio is committed under hugetlb_lock.
>
> The task can be migrated while the allocation is in progress.  If the old
> CSS is then offlined, its final active-folio scan can finish before the
> charge becomes visible.  The allocation can subsequently charge that dying
> CSS and commit its pointer to the folio.  Once the CSS is freed, uncharging
> the folio accesses the freed hugetlb_cgroup, including its page counter and
> per-node usage.
>
> Keep the reference acquired by the charge until commit or cancellation.  At
> commit time, while holding hugetlb_lock, move an uncommitted charge out of
> each dying CSS to the first live ancestor.  The hierarchical charge already
> includes every ancestor, so moving it only requires canceling each dying
> CSS's local count.
>
> This orders commit against the offline active-folio scan: either the scan
> runs after commit and reparents the folio, or commit observes the dying CSS
> after the scan and selects a live ancestor.  The retained reference also
> keeps the originally selected hugetlb_cgroup alive through this decision.
> Reservation charges retain their existing CSS lifetime and are not
> reparented.
>
> On an unmodified v7.3 kernel with a 128-page 2 MiB pool, a
> capability-free uid 1000 allocator racing administrator rmdir reproduced
> KASAN writes to a freed hugetlb_cgroup in three of three boots.  Controller
> disable reproduced the same fault.  With this change, 5,000 rmdir rounds
> with over 1 million successful faults and 2,000 controller-disable rounds
> with over 1.6 million successful faults completed without KASAN, LOCKDEP,
> page-counter, or refcount reports.
>
> AI-assisted source review was used to identify the race and to help draft
> the reproducer and fix.  The interleaving and the resulting allocation,
> free, and use-after-free stacks were verified with tracefs and KASAN.
>
> Fixes: da1def55919f ("hugetlb/cgroup: add support for cgroup removal")
> Cc: stable@vger.kernel.org
> Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>

Hi, Daehyeon,

Would it be better to send v2 as a standalone thread rather
than as a reply to the v1 review thread? It would be easier
to track.

> ---
> V1 -> V2:
> - Remove the redundant disabled-controller check from uncharge, as requested
>    by Andrew Morton.
>
> v1: https://lore.kernel.org/r/20261020100345.1677643-1-4ncienth@gmail.com
>
>   mm/hugetlb_cgroup.c | 34 ++++++++++++++++++++++++++--------
>   1 file changed, 26 insertions(+), 8 deletions(-)
>
> diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
> index 3fb41311e4c7dc..6921b185726662 100644
> --- a/mm/hugetlb_cgroup.c
> +++ b/mm/hugetlb_cgroup.c
> @@ -310,11 +310,10 @@ static int __hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
>   		css_put(&h_cg->css);
>   		goto done;
>   	}
> -	/* Reservations take a reference to the css because they do not get
> -	 * reparented.
> +	/*
> +	 * Hold the CSS reference until commit. Reservations keep it longer
> +	 * because they are not reparented.
>   	 */
> -	if (!rsvd)
> -		css_put(&h_cg->css);
>   done:
>   	*ptr = h_cg;
>   	return ret;
> @@ -337,9 +336,26 @@ static void __hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
>   					   struct hugetlb_cgroup *h_cg,
>   					   struct folio *folio, bool rsvd)
>   {
> +	struct hugetlb_cgroup *charged_h_cg = h_cg;
> +
>   	if (hugetlb_cgroup_disabled() || !h_cg)
> -		return;
> +		goto out;
>   	lockdep_assert_held(&hugetlb_lock);
> +
> +	/*
> +	 * A task can be migrated after selecting h_cg. Once offlining starts,
> +	 * redirect the uncommitted charge to a live ancestor. hugetlb_lock
> +	 * serializes this decision with the offline scan, which reparents
> +	 * earlier commits.
> +	 */
> +	if (!rsvd) {
> +		while (css_is_dying(&h_cg->css)) {
> +			page_counter_cancel(&h_cg->hugepage[idx], nr_pages);
> +			/* The root CSS never dies. */
> +			h_cg = parent_hugetlb_cgroup(h_cg);
> +		}
> +	}
> +
>   	__set_hugetlb_cgroup(folio, h_cg, rsvd);
>   	if (!rsvd) {
>   		unsigned long usage =
> @@ -352,6 +368,9 @@ static void __hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
>   		WRITE_ONCE(h_cg->nodeinfo[folio_nid(folio)]->usage[idx],
>   			   usage + nr_pages);
>   	}
> +out:
> +	if (!rsvd && charged_h_cg)
> +		css_put(&charged_h_cg->css);
>   }
>   
>   void hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
> @@ -419,15 +438,14 @@ static void __hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
>   					     struct hugetlb_cgroup *h_cg,
>   					     bool rsvd)
>   {
> -	if (hugetlb_cgroup_disabled() || !h_cg)
> +	if (!h_cg)
>   		return;
>   
>   	page_counter_uncharge(__hugetlb_cgroup_counter_from_cgroup(h_cg, idx,
>   								   rsvd),
>   			      nr_pages);
>   
> -	if (rsvd)
> -		css_put(&h_cg->css);
> +	css_put(&h_cg->css);
>   }
>   
>   void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,

-- 
Best regards,
Hongfu


