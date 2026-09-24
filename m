Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5249C98318
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 16:19:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42E776B0088; Thu, 24 Sep 2026 12:19:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DF476B008A; Thu, 24 Sep 2026 12:19:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CE056B008C; Thu, 24 Sep 2026 12:19:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EEE2A6B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 12:19:28 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7490EC0428
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 16:19:28 +0000 (UTC)
X-FDA: 85249166016.24.A5F884E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id CCB0F140006
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 16:19:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LdniQZtX;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790266766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r66646FaaMJmMMJtghlI/Jm1UKe8pCt6tSOa0dL7Cmc=;
	b=viOivlWappreBFq5EPPUHqhc7AGYJhYtD+Q8ZwfdRKxeM/5ursuGQXRRalN0l6zMaGM6PE
	1sWq95hHRVU/OKbLb0DQToVR0TWj8K5Pm1TnP5PQlM2O6BV5F0OpDVEaKu8Gtf0hszZKU2
	tdVb4WheN59AfSPkkewvvjYNSsquKFo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790266766;
	b=0zJoIDJbfg0O5VtIgygC8mzpmUOyVUJ8FpyPMy/yfROTb1b3YXUKXJ7jo/4hNJZhm+F9g3
	n4cBgocHpRBdFK4pWuxOm5e9woAq0G7TovPSRDSXHPUK6WnO9/92hVIdp4GKYD4rzJ5Ipk
	jaUhXLKy9OKn1hjxilhBFSUfiT23eYk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LdniQZtX;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 21DF1601DE;
	Thu, 24 Sep 2026 16:19:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F24CB1F000FF;
	Thu, 24 Sep 2026 16:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790266765;
	bh=r66646FaaMJmMMJtghlI/Jm1UKe8pCt6tSOa0dL7Cmc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LdniQZtX4VayI3layjWdH4eFwyIF4H2Bq/vkmWjcfnkWIAwhEABQuq80dlBDeCe9n
	 VSFQnk+R5ZEvRXfbMH9Diul7TU7qquNPg9rZizuO7XkXLQ2VOYpL8o2m6xzzujwoOd
	 jemxUJFqOVj8o9Yz+fG7IqtthMIkmcjgmFXc164DQE/77DySgEnq+H9IKUcHj1CgEC
	 1bJEPf0Sfjj6L/l4EyU1/EM2tCrRA5ERREOjE+1O92aH4amkcecW56ODAMlKoPpi1j
	 dArMrpCMbNZF74xPxGBNWOFoLwdCcDkSDQKWepXEif42nqcvbgimieEl1boZFJn2H0
	 c5c1WvpdiU9aQ==
Date: Thu, 24 Sep 2026 19:19:17 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Vishal Moola <vishal.moola@gmail.com>,
	Ingo Molnar <mingo@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Steven Rostedt <rostedt@goodmis.org>, x86@kernel.org,
	linux-mm@kvack.org, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: don't schedule deferred kernel page table freeing
 while booting
Message-ID: <arVNhTkI3kesfRs0@kernel.org>
References: <20260924092307.22813-1-mikhail.v.gavrilov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924092307.22813-1-mikhail.v.gavrilov@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CCB0F140006
X-Stat-Signature: 1iu9wjoxwtxpuwrgdd3tpzgr5ckzf5jd
X-Rspam-User: 
X-HE-Tag: 1790266766-951262
X-HE-Meta: U2FsdGVkX1+TDWee9hL4Xgf70aCE1Mi9SzGqaqo/J7QbN6cqrtbK01Gqgk+QDBjTVxuvg8kXzxE3Ery0agT9vugiR3ocamC3tCThEqIEk7jHcZHPv1G4NI7ThKy0eBYF9DbMTWFxY9isozQQI+MyRkatmdAjsTeUZg4wVDisO7UI3gZFpj0OG/v2EJ+QUW1PwX5fem5WuNxQTb6V9VZEq6A6hEm728tRSBBQKl1NsCX/wA9NRdNIqlw/uwWU2cXjgkUh8CrWtmxWUDGfGIW7VJKf9kXMBEw33vbYjVAXzLrC4b3yOWaARlMw/3KZuJMBnpara7IRPOkyfrgIGmAZL9hypXF3QaZDWbuV3NWmpLigpb+q7rjYOJ6nxAGkKprlf5oB7yGH8yw2GJ3kum4eIgMOLNcHGNvIuTIOn0jxZ6HIwrBIfbx9h1gUgBftF7aJUEPeyPeYJwsTOqHlwQ0jrTBNbOVhpx8we5s7ltiAfZSo9At3CqlSFNruTmdK6YbtN/4qbsO32XiRTPVBnsQWMmb80yRiNJ/0C+PFibqEAoF/8cBB26Iwr90EyHVIYVCwF0iHRAajnTZ9GsiOwtSNAuDXOxXbLGX1KFzOIIaEcmSHgzx+0fMrtgQcORFRPaUU9KqY4rYiKKcR0B9CsAmywrSixVjZPs3e6jMzf7XIg4l6W2A6aTpkxdRQ9DKne2TQNOQpCRZErI3dE95j4IjJmjOqROtrOnleziKOfL7DwndA2JHFB/XBMmgKD2X9lit3FSLwn9fSxLruPlMisO7cTwRCfPEPoU+PsiG3IilrSDmqHhpRrod0NaRYqRySnBGAsQKtU6VUxUcVooS+SAzea1/c9h5MRA2tEO7lYZ+zCl/Hu0ZZST/2hQBRZl/WXx0A1981nlaeUFHR4tro1Ci+3j991Nl2gojLEETPKn+YepMKVokIsouyiShhvPff34Xvy0nvTZxdsKHqpdzvfyS
 uIX7AZjP
 SqHvEr5aegXM1SA3TvJmCAD8Fjd69FGre/6Mut/3Cj0hoohDsfA7xiMHPBqtm0eTJQFhCZwrdjGpylTjOLK3E1G3UuvuDcCSFmTamOartKkANXmi9bFHDa7xNAAcocQWd/qpauEZMZJJhvygaEBeaie9Whwbunf3y85hEbCp5+keSDWjmzGAkktJS7/CvFy+2o3Igh/FsQ3q6Z0za+JKEcVN0hnkgMb91DC3z1H8ji0gh4KlaIRzukHD7xJ04HjClq/wfmDSxXU63zLGTVGB8C8CqrmlgFCe0VyzLBXhdf6lQsWhkm9BSQup1kH7ekRgxYWErcj4B38nkhczRywVxGjjlhJ0XOJdqNn8oSnHjoQ/RdfOYvIdNUXgU1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 02:23:07PM +0500, Mikhail Gavrilov wrote:
> Booting with a boot-time function tracer and a filter, for example
> 
>   ftrace=function ftrace_filter=pud_free_pmd_page
> 
> panics on 7.3-rc4 as soon as the tracer starts:
> 
>   [   23.531178] Starting tracer 'function'
>   [   23.675800] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000038: 0000 [#1] SMP KASAN NOPTI
>   [   23.819917] KASAN: null-ptr-deref in range [0x00000000000001c0-0x00000000000001c7]
>   [   23.964025] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 7.3.0-rc4-fe2ec83746e5-with-fixes-v2+ #195 PREEMPT(undef)
>   [   24.252248] RIP: 0010:__queue_work+0xab/0xf00
>   [   25.981629] Call Trace:
>   [   26.125727]  <TASK>
>   [   26.413912]  ? pagetable_free_kernel+0x20/0x120
>   [   26.990283]  queue_work_on+0x97/0xf0
>   [   27.134382]  __cpa_collapse_large_pages+0x501/0x6f0
>   [   27.566662]  cpa_flush+0x394/0x620
>   [   27.998953]  change_page_attr_set_clr+0x321/0x4a0
>   [   29.151729]  set_memory_rox+0xa2/0xf0
>   [   29.584018]  create_trampoline+0x431/0x6f0
>   ...
>   [   44.343347] Kernel panic - not syncing: Attempted to kill the idle task!
> 
> The boot-time tracer is started from early_trace_init(), which runs
> before workqueue_init_early().  Making its trampoline read-only splits a
> large page, and CPA collapses it again right away.  The split table has
> been a kernel page table since commit 9e4a3ec3411b
> ("x86/mm/pat: Allocate split page tables as kernel page tables"), so the
> collapse frees it through pagetable_free_kernel(), which queues work on
> system_percpu_wq - still NULL at that point.  That commit is correct in
> itself; it only lets CPA reach pagetable_free_kernel() before the
> workqueue that function relies on exists.
> 
> Keep putting the table on the list, but don't schedule the work while
> the system is still booting.  The next kernel page table freed after
> boot schedules it, and the work then frees the early table too, after
> the same IOMMU flush as any other.  If no kernel page table is freed
> after boot, the ones freed during boot stay on the list.
> 
> Fixes: 9e4a3ec3411b ("x86/mm/pat: Allocate split page tables as kernel page tables")
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
> Link: https://lore.kernel.org/20260924064321.23787-1-mikhail.v.gavrilov@gmail.com
> ---
> v2:
>  - Keep the table on the list and only skip scheduling the work while
>    booting, instead of freeing it directly (David Hildenbrand)
>  - Say that 9e4a3ec3411b is correct in itself and only exposes the
>    problem (Lorenzo Stoakes)
> v1: https://lore.kernel.org/20260924064321.23787-1-mikhail.v.gavrilov@gmail.com
> 
> Tested on a Ryzen 9 7950X with a Radeon RX 7900 XTX, lockdep and KASAN
> enabled, on 7.3-rc4 (fe2ec83746e5) with the same unrelated local
> changes as noted for v1, booting with
> 
>   ftrace=function ftrace_filter=pud_free_pmd_page,pagetable_free_kernel,kernel_pgtable_work_func
> 
> The boot that panicked without the fix completes.  The table freed
> while the tracer installs itself does not show up in the trace, since
> the tracer is not live yet at that point, but the first kernel page
> table freed after boot does: systemd-modules-load freeing one from
> __cpa_collapse_large_pages() schedules the work, and
> kernel_pgtable_work_func() runs 0.8 ms later and drains the list.  From
> then on every pagetable_free_kernel() in the trace (660 entries, none
> lost) is followed by a work run within a few milliseconds.  So on this
> box the early tables wait until the first module is loaded, and no
> separate drain is needed.
> 
>  mm/pgtable-generic.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> index b91b1a98029c..f7f504f57914 100644
> --- a/mm/pgtable-generic.c
> +++ b/mm/pgtable-generic.c
> @@ -444,6 +444,12 @@ void pagetable_free_kernel(struct ptdesc *pt)
>  	list_add(&pt->pt_list, &kernel_pgtable_work.list);
>  	spin_unlock(&kernel_pgtable_work.lock);
>  
> -	schedule_work(&kernel_pgtable_work.work);
> +	/*
> +	 * The workqueue may not exist yet while the system is booting.
> +	 * The next kernel page table freed after boot schedules the work,
> +	 * which then frees this one as well.
> +	 */
> +	if (system_state != SYSTEM_BOOTING)
> +		schedule_work(&kernel_pgtable_work.work);

Maybe we'll just skip collapse on boot?

>  }
>  #endif
> -- 
> 2.55.0
> 

-- 
Sincerely yours,
Mike.

