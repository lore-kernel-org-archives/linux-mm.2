Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1CE3606A331
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 23:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TH7OyQdi
Received: by kanga.kvack.org (Postfix)
	id C4E536B05B0; Fri,  6 Nov 2026 18:22:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFFDD6B05B1; Fri,  6 Nov 2026 18:22:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA3316B05B2; Fri,  6 Nov 2026 18:22:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7E5FA6B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:22:39 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 195CE1C2DDC
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 23:22:39 +0000 (UTC)
X-FDA: 85406270838.17.0F26AD7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5309E140003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 23:22:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TH7OyQdi;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794007357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zOrS2oEsMLKAlSzqsplSP4kVfn432L2W3OnnE5qefj8=;
	b=Lq2rGi+Rqz3t0NsKbNkspT4cbEebCys5BmOGCSRweTVCKwWXYDyjNg00xjffixUnJP6EP4
	QlMAhwZEM/CHzbljm1sxWNYk7KprVu9Eg8ec5T/82R1Aftt1A9SApTq0lwK5JBASOvx72y
	Ux4rDIBRccqdyhyi0aWC4dz2bwRqVBg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TH7OyQdi;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794007357;
	b=wdG0aOkvRvqjPKNAgRv8X0WP+OkPFo+KlxDm0l+2XligafTO2q6VKt1xCG1PgOFeX36pSu
	L6hyK/zHns6uNLCcC37ORroRQb/JkrZd7yqsKx/uKJhWPPvF2WSddJljuaCyaXsZcL7TW+
	oAU3aF8ac5JXxpdg3DitRCvKuggoLM4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9F7E4601F8;
	Fri,  6 Nov 2026 23:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9CC71F008A1;
	Fri,  6 Nov 2026 23:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794007356;
	bh=zOrS2oEsMLKAlSzqsplSP4kVfn432L2W3OnnE5qefj8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=TH7OyQdiZ6kX4QUC4x1DKV7dNA3ms0ENMHCujHn6I/lEujseI/4nJj6Y04M8XaSZb
	 PS2TwrZ1rtWzWJNakc76P4u33V0dUG5QLK2jvG4FQ0NZpa9uNHxYNkBI0O5M1I6Hkf
	 kWNs/3+a31Oue8HLxwNem4ZvEUcXsiG9YO8gUSOiYPd4WCsBr6YJ+dW1UmTj9KWqHN
	 jfREmzPSQqWtQK+GS0hEkTKOVzJLAtT/K3Zlyq78hb694Vl0md78Zfxewf25g/3Q0g
	 p7NZ1wggioFiSZBMYZKW61Q5TZ3hgpAS1M6Ctsj/RxI93UNOl8JjqZQJeO3RfEhjzZ
	 OCrHnmzQANBDA==
Message-ID: <d4559f3c-dc6b-41c3-92ac-8ae0d07ccfcb@kernel.org>
Date: Fri, 6 Nov 2026 23:50:55 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] mm/gup: limit pagecache folio refcount when grabbing
 references
To: sashiko-reviews@lists.linux.dev, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Song Liu <songliubraving@fb.com>, Rik van Riel <riel@surriel.com>,
 Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
 "Joerg Roedel (AMD)" <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Steve Sistare <steven.sistare@oracle.com>, John Hubbard <jhubbard@nvidia.com>
Cc: linux-mm@kvack.org
References: <20261105-refcount_overflow_stable-v1-0-70b9c655da3e@kernel.org>
 <20261105-refcount_overflow_stable-v1-5-70b9c655da3e@kernel.org>
 <sashiko-outbox-201446@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <sashiko-outbox-201446@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: h5fq3cggnd1ex8whh741d7fnr317npby
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5309E140003
X-HE-Tag: 1794007357-569937
X-HE-Meta: U2FsdGVkX1/YSMIgk/bix1QlHbZCc3iXM0gtTNI6gXa8g+RvdPOk3Qlft9XmCo87pO1pPyMINHvybPr8APku8RK1Qke7MhmBxsRkvv2MxGMPDUndI54IcScG5RecZaIkXvc6lMOrWZm/HzymhRCPF6cyti967BqGmlo+YIHb7+l/l5aSk0ojOZVJkVbp48y/WCL2Vhqig+xKekov4vfTzhCbB4Hmo9uJfdafaIHrYe++u/8B1E30GYWQUZnxPg8saMClWO/YoVUfvD4tiOYjT+lvYXml5IaGw0rN07gUdgkF9T8jOB4KeuUTJq9ekLBx1wWBGZuf7/3oimcyQb75TDQznQKXCs3k0EzaTtsJNLp3SRTPVoHkqFN32Dwfpc/txZMUdlX/KIN0JCFtZfxhIJ0uLigV7d8ZONT6C9ESYctViEQKQ409JAtA5r69OV5CqemaA+5WPzByL1/r9mVijOPT3SZBCp2X654CkCD9xEeEsPr3uoa6Rhln4xICYmf1RIc+hpjDYJeqYCN45E5Kp/7aOFyFDjsZqY79Z4hCPM7xN/swFBAMmCCrokbJ2fy/o+bH05ZAJWNJx3Zqs4ozej+lNnd/BNKeq0hThdBAJReg2mQBdwOwfYKviYEItYK+Gx+UZmNrJg/XrAKGI2mLH/ZuA65vlhExWMIvG3l+SrayHVxp2guQ1m+YPegOK0xg1iolvH+5OMXkqHIN1i0w6ejqA3QDS+JuuSD3kO+aE59oH9mQa+pReWBLjAv4GKPq+9g+08nrPKSteJ4pdLYn8MdfgaSUT5QojRWlruOeWc02gNCvmG8H5fCPbxj3NbR1B84v9mdVeTQhSLCc4jixFI5x9qk3HUTpzvn/lETT9HPMXopNJ5l55K2HP5VXwYyyXisBZIbTPPqDAuomnB5WgSW3qmSmEg5RQwak+YKxlRMaQO4x6JGENnRkbSypsEoDaIkLf9YXXKk3ky92Pep
 j/xE1+Sp
 Ymr5TQIOF1p4I+3Aarl/1vh0V23eO115w+JK2iEqhESdGx8x2KTBd99Zc8jNNiKWeYsymvGZg2SRnOH0hihjjnxC1jlwEPodAJHqgOJGgg13Y384uWM+mxotRuWPudjKwpQA0OAqguVfMLB0y93Wn5mL8Ox4hXq6hGfLyeY8tu9066Nf1t92yw5/eYQlpF1JDEupWW+zu/qKzdJmyYUgWQbuTlI/LSL35/scavwJAyZ09EqTVeiu2Mr2Xfj+U3ABHAo6zk7wsy30LsqFtc7wsCF0yAB7U//HBg8ERqQB5PNP3sDcHlhMIKPouNXi+lDeTo1Ww+5KOaAMWEEzcJ5hRdMexckmeWjs0XaoK1lytI39LvsE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 14:11, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [High] mm/gup: try_get_folio() calls capable() with IRQs disabled in
>   GUP-fast
> --
> 
> commit 9290efad216cdf3b5ee1cdfafab0a5d9928a1976
> Author: David Hildenbrand (Arm) <david@kernel.org>
> 
> mm/gup: limit pagecache folio refcount when grabbing references
> 
> This commit replaces the negative refcount safety checks in try_get_folio()
> and try_grab_folio() with folio_ref_count_over_limit() to enforce folio
> refcount limits in fast and slow GUP before acquiring references or pins.
> 
>> diff --git a/mm/gup.c b/mm/gup.c
>> index 2ab42fc6834e5..db9db6b2a4662 100644
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -77,7 +77,7 @@ static inline struct folio *try_get_folio(struct page *page, int refs)
>>  
>>  retry:
>>  	folio = page_folio(page);
>> -	if (WARN_ON_ONCE(folio_ref_count(folio) < 0))
>> +	if (unlikely(folio_ref_count_over_limit(folio)))
>>  		return NULL;
> 
> [Severity: High]
> Is it safe for try_get_folio() to call folio_ref_count_over_limit() in the
> fast GUP path?
> 
> In mm/gup.c, gup_fast() disables hardware interrupts across the page table
> walk:
> 
> mm/gup.c:gup_fast() {
> 	...
> 	local_irq_save(flags);
> 	nr_pinned = gup_fast_pgd_range(start, end, gup_flags, pages);
> 	local_irq_restore(flags);
> 	...
> }
> 
> which calls into try_grab_folio_fast() -> try_get_folio() with IRQs
> disabled:
> 
> mm/gup.c:try_grab_folio_fast() {
> 	...
> 	/* Raise warn if it is not called in fast GUP */
> 	VM_WARN_ON_ONCE(!irqs_disabled());
> 	...
> }
> 
> Furthermore, get_user_page_fast_only() -> gup_fast() -> try_get_folio() is
> invoked from hardirq and NMI contexts, such as perf_prepare_sample() ->
> perf_virt_to_phys() in kernel/events/core.c.
> 
> When folio_ref_count(folio) is between FOLIO_REF_COUNT_LIMIT and
> FOLIO_REF_COUNT_ADMIN_LIMIT and current is not a kernel thread,
> folio_ref_count_over_limit() in include/linux/mm.h calls
> capable(CAP_SYS_RESOURCE):
> 
> include/linux/mm.h:folio_ref_count_over_limit() {
> 	const unsigned int ref_count = folio_ref_count(folio);
> 
> 	if (likely(ref_count < FOLIO_REF_COUNT_LIMIT))
> 		return false;
> 	if (ref_count >= FOLIO_REF_COUNT_ADMIN_LIMIT)
> 		return true;
> 	/* Background threads must not consume admin reserves. */
> 	return (current->flags & PF_KTHREAD) || !capable(CAP_SYS_RESOURCE);
> }
> 
> Calling capable(CAP_SYS_RESOURCE) -> ns_capable_common() ->
> security_capable() in these contexts appears to cause several issues:
> 
> 1. LSM capability hooks (such as selinux_capable() and apparmor_capable())
>    perform audit logging via common_lsm_audit(), which allocates memory and
>    acquires spinlock_t, rwlock_t, and SLUB local_lock_t locks. On
>    CONFIG_PREEMPT_RT, these are sleeping rt_mutex locks, so acquiring them
>    with hardware interrupts disabled in gup_fast() will sleep in an invalid
>    atomic context.
> 
> 2. When get_user_page_fast_only() is called from hardirq or NMI context,
>    acquiring non-IRQ/NMI-safe locks in the LSM, audit, or SLUB paths can
>    self-deadlock if the interrupted context on the same CPU already holds
>    one of those locks.
> 
> 3. In security/apparmor/capability.c, audit_caps() accesses the per-CPU
>    audit_cache using get_cpu_var(), which only disables preemption:
> 
>    security/apparmor/capability.c:audit_caps() {
> 	...
> 	ent = &get_cpu_var(audit_cache);
> 	if (ad->subj_cred == ent->ad_subj_cred &&
> 	    ktime_get_ns() <= ent->ktime_ns_expiration[cap]) {
> 		...
> 	} else {
> 		put_cred(ent->ad_subj_cred);
> 		ent->ad_subj_cred = get_cred(ad->subj_cred);
> 		ent->ktime_ns_expiration[cap] = ...;
> 	}
> 	put_cpu_var(audit_cache);
> 	...
>    }
> 
>    If an IRQ or NMI invokes get_user_page_fast_only() while the interrupted
>    context is inside audit_caps() on the same CPU, both contexts can race on
>    ent->ad_subj_cred and cause a double put_cred().
> 
> 4. In kernel/capability.c, ns_capable_common() updates current->flags
>    non-atomically:
> 
>    kernel/capability.c:ns_capable_common() {
> 	...
> 	capable = security_capable(current_cred(), ns, cap, opts);
> 	if (capable == 0) {
> 		current->flags |= PF_SUPERPRIV;
> 		return true;
> 	}
> 	...
>    }
> 
>    When called from hardirq or NMI context, this mutates the interrupted
>    task's flags and can race with process-context updates to current->flags.
> 
> Should try_get_folio() avoid calling capable() in fast GUP (for example, by
> falling back to slow GUP once the folio refcount reaches
> FOLIO_REF_COUNT_LIMIT)?

What a minefiled :)

Best to throw in something like

	if (!in_task() || irqs_disabled())
		true;

In the (new) slow helper to just reject admin reserves in such
context.

-- 
Cheers,

David

