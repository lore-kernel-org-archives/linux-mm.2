Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30590C43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 23:10:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4E736B0005; Sat, 27 Jun 2026 19:10:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFF6D6B0088; Sat, 27 Jun 2026 19:10:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D175A6B008A; Sat, 27 Jun 2026 19:10:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF2656B0005
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 19:10:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 276BF4028A
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 23:10:11 +0000 (UTC)
X-FDA: 84927237822.06.6D06DAE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5E2DF40004
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 23:10:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XPjgvX6y;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782601809;
	b=t38dy7st5QCMjz/Of26rvdT1ZK4BB1o0RJ7Woz1d+Q65XSrj/unMLlklqqExDgzAHTbR5y
	f4DFBiIoNa3xifJ/OjSHkKWWSd8QUEJPmELel7enMtra2nutyO+EizhLxVtPH8LNJgJmO4
	owuO4amX/faIqDPezQ3OO+DFRr48RDw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782601809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5D6v0GXcAFL77pAcQTrYWtPV+T9YBufpS6c20apcpxQ=;
	b=PVhLz9dpcfDuWYF47+CiAZix1+ZigFfnTjeG7i7Qvma2psRoa2tmfPTy+0ebjewkas3BGJ
	TGpNMst3DV4Fg7uak7erfCZPX5Z3pM72LN2/ekyAFj2n8Yl8imShZz2WfTA2MWZRHg1Gmq
	6KFDuieu0f8lFzvXf1348R00CMuDjhY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XPjgvX6y;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A341E600DA;
	Sat, 27 Jun 2026 23:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EABA91F000E9;
	Sat, 27 Jun 2026 23:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782601808;
	bh=5D6v0GXcAFL77pAcQTrYWtPV+T9YBufpS6c20apcpxQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=XPjgvX6ycSUd9Pjzv07W94UUP0I2rXBsMn1XGQ1TtVVprC6RaHbLLOlm8YRdyA82Y
	 gjAuEtnZwvYXdnZ2FS0zk9vkPz9y4ULh4V4ZNZ2hhggC1WwyU+AJXPnrrYwlTlN2Vc
	 ntMsz8r1/oJhB4GpC55pla69W3RJZN1NpPWFYtwk=
Date: Sat, 27 Jun 2026 16:10:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 rppt@kernel.org, vbabka@kernel.org, mgorman@techsingularity.net,
 hannes@cmpxchg.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/vmstat: fold stranded per-cpu node stats when a
 node comes online
Message-Id: <20260627161007.81e4533ce561c2951a69f927@linux-foundation.org>
In-Reply-To: <20260627202243.758289-1-gourry@gourry.net>
References: <20260627202243.758289-1-gourry@gourry.net>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: kw39s1kn5wrhxjg4r4hjpiyniw6u8hqm
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5E2DF40004
X-HE-Tag: 1782601809-674223
X-HE-Meta: U2FsdGVkX1///r8TI7/1ddF/GVxkXd55NO9AxEFCo228smKlENYysWGjyf3AC6CmILs5rM66K7/CV4xT/W6A1X2nixJoghg6xSfvMbYh+cJhG6RDxvu/NgmBB+yC0x3FRL1ouSqQTO1NBDvWr4l3eNpxe2VCVITAjMceaqeO+PSeUJSYKj4TB+6m8G++D9/9FCJ1T9hV4ahR7jDvtYq1kNBbVk/ujwHFAtewDThuTrQ7Sk6JriJizuDdhn/u4sw2W6UkOsCPFJyd9Jceas//x39e1dTcsL0k3sFa1BtwFRImTPdz2Hm6t+RVIVqJArQbtVW+6A8Rb/+B9FlQnYnx3kfMYKII8intwReEGqqGdZ/k7RKQXnIKcH8F+gwOuRHKemap2XCj86OMt+wHleG/W4Z6oPR6HJ+lk+0rKRsy/8pcxJuojTuxKM3+qOOP6AWoXdnAbulu09gww39JXsJ25EDOgypEcwLwWZnkMZpA4KjopfNDvalezzut4IHLQMCPJITzHbRxX0d4P5TxbiAdHJyviWM4b6aJGTGu81GJIyPuZaUi465Nf4R4IAzlKvZg7DmSl2LNDjY6o+Ydfrbz9EXlT9HkSJ/KDM718/t86XN5Qmmc+4zWSxe5QeEhbMrauRsIt/bOmdYmdbEjZtbCRaluMTJ5va5FTgYXZR6ab7ytClvZ3m43aKuUgTu8OwG2Iq+zqq1i6PEHBobbrAkpfbTlruUzUWyNO8nn+hZg29LZDsPvr4KM2lqgSKd/OZArU75lMGd1GKlmOKI8OCFJIfzFJbZB8V7vAtsG2wOmJU3raG3mwztgTi4K64MS3QwVJIuO83M2FIhOu5GgcN/XTKh+uA/c62ZPaajeR5B7iymOmsviT7dEhz5BtA+tkIr4bZGzvFYrMWCTsb1pQo12xswxUnMW5nspaFaPzKPP3GEHZhvZyweYpZB+vcxHzQ39h3TOpvxfTd6BP44KLtL
 k7tHxriO
 O4bu97p8A6n2YEGwwMxAX4iBy6vt9QQHxLySCd00yu1TRTwaPdKMXGJM6WFGXRTo8zgTR2w+HdB+0CCMwt/p+6jObyheBz1LO1Aj+tkmUlZwgCbVvVS0Isa6PoaYwVpZ2rfNM5VIaQqxex+9nPnGAEoaX469ZJPX1J0X/HnS10UxMsMFAF4X3+/PkRMSlNzv/6KQD8NuBPEqoPKdVFGYmc5stUpAH99fZGChmCyQny8Bsw7jnbyDgoalGLt+1j3nSdcNGEm0Aiqd0MZMHmZSsYeB5mBMME6GPTDwtJwB2OMC+c7CLp3deXYvJRmQJ5QmftlM7rGG2+aIuC0yQdlCSH0zMkdOW5dqDmVv3gGl9aud9KVSX0agkSJ59cA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 27 Jun 2026 16:22:43 -0400 Gregory Price <gourry@gourry.net> wrote:

> A per-node vmstat counter is pgdat->vm_stat[] plus per-cpu deltas.
> A balanced counter can sit split as global=+N / per-cpu=-N.
> 
> The folds reconciling the split only walk online nodes, so when
> try_offline_node() marks a node offline the per-cpu deltas are stranded.
> 
> A subsequent online resets the per-cpu area but not pgdat->vm_stat[],
> orphaning the +N permanently.  All NR_VM_NODE_STAT_ITEMS are affected.

Geeze, simple mistake, been there ten years...

> The existing code zeroes the per-cpu counters and causes a permanent
> skew. Fold the stranded deltas instead, before the node rejoins the
> online set. The node is not online yet and the hotplug lock is held,
> so the remote access to per-cpu values is safe.

Oh.  Shouldn't we be doing this during offlining?

> Discovered when node compaction hung for a nearly empty node, as the
> math to determine throttling broke.  Reproduced by repeated memory
> hotplug/unplug cycles on a node under pressure: NR_ISOLATED_ANON
> ratchets up and never returns to zero.
> 
> ...
>
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1536,7 +1536,7 @@ void __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
>  {
>  	int nid = pgdat->node_id;
>  	enum zone_type z;
> -	int cpu;
> +	int cpu, i;
>  
>  	pgdat_init_internals(pgdat);
>  
> @@ -1554,10 +1554,17 @@ void __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
>  	pgdat->node_start_pfn = 0;
>  	pgdat->node_present_pages = 0;
>  
> -	for_each_online_cpu(cpu) {
> -		struct per_cpu_nodestat *p;
> +	/*
> +	 * Hot-unplug can leave per-cpu vmstat deltas unfolded (folders skip
> +	 * offline nodes) - reconcile this at online. Foreign access to counters
> +	 * is safe: the node is not online yet and we hold the hotplug lock.
> +	 */
> +	for_each_possible_cpu(cpu) {

That's a lot of CPUs

> +		struct per_cpu_nodestat *p = per_cpu_ptr(pgdat->per_cpu_nodestats, cpu);
>  
> -		p = per_cpu_ptr(pgdat->per_cpu_nodestats, cpu);
> +		for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)

and that's a lot of items.

I guess the overall loop count won't be large enough to cause issues,
but it's large!

Perhaps there's some simple test we can do on the per_cpu_nodestat to
avoid the inner loop?  Perhaps might need to add a field for this?

btw, "for(int i..." is allowed nowadays.  It'll make this code nicer, IMO.

And... Sashiko seems to have found a pre-existing issue:
	https://sashiko.dev/#/patchset/20260627202243.758289-1-gourry@gourry.net

> +			if (p->vm_node_stat_diff[i])
> +				node_page_state_add(p->vm_node_stat_diff[i], pgdat, i);
>  		memset(p, 0, sizeof(*p));
>  	}


