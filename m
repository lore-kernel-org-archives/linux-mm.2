Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FB85106F31B
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 10:30:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9958D6B0124; Thu, 26 Mar 2026 06:29:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 946436B0126; Thu, 26 Mar 2026 06:29:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85BBD6B0128; Thu, 26 Mar 2026 06:29:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 71C676B0124
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 06:29:59 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 242AE57356
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 10:29:59 +0000 (UTC)
X-FDA: 84587843718.17.0026BA7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 28E6FA000D
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 10:29:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eFad7qen;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774520997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8aJLDcTH2MWm6gSRCunoWe05jCvpS86QFZJvkr9vEIQ=;
	b=ym8f5xQIf4Ps4cK9ecOFx/zoYW1z3ctd5qT/h//UL2mVhOxifM5DViIV9dKjAy+t3yGW/e
	0ch4Oklg3pr3SPmFwrqd/rIoGPBXE+7apnxcH1rCBgK9MXhuhokC550bqs6nOeJfNEPFD1
	P95IFOZLnjEIOLYnzg2F4X3J09z3e+I=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eFad7qen;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774520997; a=rsa-sha256;
	cv=none;
	b=aqlkmBccAevun+XvDiHvKdd7LgV+Hnoe2o3a641bbNhvhd/HimZOTZbTRCXEsBlYfTwwZt
	Ev7QFmzxHO/hxUX+6DISzwuYTdtBW4R8nB5AJ08CzhbowOV2WsgSHkF6tSII/xBYR7In4J
	ODLxCt5Q5+tPXuFBuQv5f5Fis5w3aeA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 420E0436A4;
	Thu, 26 Mar 2026 10:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129A4C116C6;
	Thu, 26 Mar 2026 10:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774520996;
	bh=r+HgD2u/Tq9CkbDGZ3lEw+byiueM4J5FP2Q5P+aBkaM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eFad7qenAiwEVed1LXvS4QaXK2JMFhGBaPYAYgHB6A1moVO1UUUcPfEnRq4thbQzf
	 xV5JT4zamYEBbTOKqunfvM+AVzTh/mnRLLD1rQPR+rYzVEBI/etuZYyEGlPNesXAPm
	 uy2TPA5e5kW55GOGJIFWu+prPRS6lgc5T6/YKgnVO07ZFfMenrP7oFcg2OlrJqiVyG
	 jb/NyXpOLuPBU3uoF3UmHO+KHKgMQ3HqOX1zD0utenGax9mnzRkeZ0UArTZDqVMSoq
	 TTvl5A7QPtAgl4Vd2K/V1B8fDCXN4jtNGjl9KHEtDGPfKqMI352RrgvYhi3ZwoMYrc
	 pAGz4MW4Mo6oQ==
Message-ID: <f41ab7cb-4430-4338-8812-eb6aa98e9bf9@kernel.org>
Date: Thu, 26 Mar 2026 11:29:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] sched/numa, mm: Skip page promotion if cpu pid is valid
To: Donet Tom <donettom@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ying Huang <huang.ying.caritas@gmail.com>, Juri Lelli
 <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>
References: <20260326071216.11883-1-donettom@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260326071216.11883-1-donettom@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 28E6FA000D
X-Stat-Signature: 13wwigqa6fjw99os7q1cmoi4hny8a7sh
X-Rspam-User: 
X-HE-Tag: 1774520996-153752
X-HE-Meta: U2FsdGVkX19TJOlbT6olCfMFKNw2eetw46QgOHhlNS8W5g64gmrjzPy9Jf8hO2lAcBPajNpCE42X25oGS/tj7QpolQOii1S5Xsj8i1R8yvMlMUT5IWcU1CY1IMm/q/31pqF9+rd02whwZOISXZul9grhRNce+oaA2vD3+zDBL64NclgypwclHj64GPTHIAM9zvhdG11sSIeqR9U0QVe0yfnG6+ANh1zv9n0YFqHiHqKYMw4781keFPA4kOPI4/pmFd3OW4h+h4ye86WA/LSHqrXOxNPtDlCh45sIY5f+wj+DGSij9NYjPKCFSZMSakm3+oQlEa/XoXcovmAJyDFOK479ojTyfd5YFApyJ91JF1/MrX+hbrMw8GY+V7lEv7unoJZi5WA9P9BYLZWxHAsGcHjDIbpmKT21LXAdg8iP96nX5AYCNorlLnUcQG054wEP6C2CRjTE0IkEB4HSv/KfhxwqwqEV1ARr/e4224Tp+jpVoKjrWAsNV2lhMX0aApAw2PMvbji0jvnlK1n4Ies3/u2A3BPLIUaCRFsWI7qk1P2j+5747B7lQaYJ+wMAbSqW0lOHLA6RAIFjf7ZTU+aou7KasaZEJYFWhtDpXA+XrdntcMIvRoQ/NKRjFTIjODJp2D2jymhnSUZqyyJMkDZp+jJpwInc3tlkZz5LuL31UlsZeKwBhN+a2H2S9ryzZsi3wcK/PTJOHd6AKEx3l1IskxeiIIO2vNQK+VCqM119Mk7Cg4GY/wYogJEkw6ULLQVPyr5KPEMZGpkqp6ol4JSH19YDW2p4JGdIkJyV6pv8oQku1c1epjv0Qq450sLrVVh/nKg0YsoW5H38egwd0FmQy3v9hcDkIwIt90j00qahh50SQ1kUhcOrmfOHsDksIGEVGA4bMbYQsIC3fqDQTNz+d2lKPWQlQm7LiE4k+kLuFJ1XSYbdqh4IgA0pEgVWkJ1xmK8H5VuNfSUPm8Tq5Pq
 yNoVd9JY
 bqb1LUpiawz1V4SgobP3U6uXeef8/+9CShqFKc+U/9DIP+jAlPjHdywf8UHymJXCAVWDOgBr9tUvkiDqOm+ganGOZQYft18TA0nnAd57MRjtAkjQqJ3CPsyvLfALJsPL0KQpl4ZooFx3O8pCTLbjumnNdJrbcXpn8FznJeVmRPeO23lH1k+6f4MxhCHuFHcGY+fCSkt9YnNLJMwsdQ/Ku6ZYpOQeijNcEvk5rwDsRTBi0YMndzLo+8X7bB7cmyUo0PwmlSjQ6Id6LNrKJlCYmzo63EANwFGtVKANnxiwAAhGtUb9wS+FMlYTPrVQdAnd5k+XH6aq5nCgHUqpY+wlPH35gZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/26/26 08:12, Donet Tom wrote:
> If memory tiering is disabled, cpupid of slow memory pages may
> contain a valid CPU and PID. If tiering is enabled at runtime,
> there is a chance that in should_numa_migrate_memory(), this
> valid CPU/PID is treated as a last access timestamp, leading
> to unnecessary promotion.

Is that measurable? Should we at least have a Fixes: ?

> 
> Prevent this by skipping promotion when cpupid is valid.
> 
> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
> ---
>  kernel/sched/fair.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 4b43809a3fb1..f5830a5a94d5 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2001,6 +2001,13 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
>  		unsigned int latency, th, def_th;
>  		long nr = folio_nr_pages(folio);
>  

/*
 * When ...

> +		/* When tiering is enabled at runtime, last_cpupid may
> +		 * hold a valid cpupid instead of an access timestamp.
> +		 * If so, skip page promotion.
> +		 */
> +		if (cpupid_valid(folio_last_cpupid(folio)))
> +			return false;
> +

IIUC, as timestamp we use jiffies_to_msecs(). So, soon after bootup,
we would no longer get false positives for cpupid_valid().
I suppose overflows are not a problem, correct?

So what we're saying is that folio_use_access_time()==true does not
imply that there is actually a valid time in there.

In numa_migrate_check() we could still use the valid cpuid I guess and
make that code a bit clearer?

diff --git a/mm/memory.c b/mm/memory.c
index 631205a384e1..ba68933a9e4a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6119,10 +6119,9 @@ int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
         * For memory tiering mode, cpupid of slow memory page is used
         * to record page access time.  So use default value.
         */
-       if (folio_use_access_time(folio))
+       *last_cpupid = folio_last_cpupid(folio);
+       if (!cpupid_valid(*last_cpupid))
                *last_cpupid = (-1 & LAST_CPUPID_MASK);
-       else
-               *last_cpupid = folio_last_cpupid(folio);
 
        /* Record the current PID accessing VMA */
        vma_set_access_pid_bit(vma);


The change itself here looks reasonable to me.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

