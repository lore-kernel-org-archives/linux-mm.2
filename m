Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21CF71099B3A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 20:26:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85BDB6B0112; Fri, 20 Mar 2026 16:26:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 833196B0113; Fri, 20 Mar 2026 16:26:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 749586B0114; Fri, 20 Mar 2026 16:26:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 615516B0112
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:26:40 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 16303B69D9
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:26:40 +0000 (UTC)
X-FDA: 84567574560.18.9C2F35A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1FFA04000F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:26:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PYEi1uFU;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774038398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bh7aOD8eVmeMWf72c7UmgdenGSk73cbCb4+ksWaH/Fg=;
	b=tpMilHDLFfp6zvrGQ+Zo/gxaigsU8gEq+L2zel/i/xfQwT89LGq8rO6UZLVWqOPzxlJznV
	ffA1sbTXi7sLgvWb+iNwz+3KlP9IfUQ5O86e0iAGNzIdjKHIhOID494U/hRKeZ/WqWocX6
	XcEXQW2leHDhSWOTDmSqK2JFA7T7Y4k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774038398; a=rsa-sha256;
	cv=none;
	b=F96jrx8wdhETyVmdr7DOhmJ64mzjgNvnGlq7pzh76/1RJSkCZm3nNuD1l3iPK6YNAG9tZ4
	x6NfmBAo8dIRAgkVC5XCKO9wFJDZ6sX9XgfkKPY4KQsxsbCikeotz9bf2w4ufyOpS8i7dA
	qG1+z6V1vxa5zKbxwqCScWo2x3NXlbU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PYEi1uFU;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774038397;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bh7aOD8eVmeMWf72c7UmgdenGSk73cbCb4+ksWaH/Fg=;
	b=PYEi1uFUQKhGErCAbtSLunnYeQw10GCBXJ1XRunF9tS7b/uYRIOXV663KflmNwgNdbo9Tl
	qiHrpE8upZSrcasjSMHB2L3WcjrDMLnzyniT9GsbWp94pAq5GXFFCZb9QLI5ftxwKlS64o
	U5VeGc3tw8XF0iexKwvyOBcCKUp5Eiw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-616-kuO8f03HNYm3vhJUfRt_Qg-1; Fri,
 20 Mar 2026 16:26:32 -0400
X-MC-Unique: kuO8f03HNYm3vhJUfRt_Qg-1
X-Mimecast-MFC-AGG-ID: kuO8f03HNYm3vhJUfRt_Qg_1774038389
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 005071800561;
	Fri, 20 Mar 2026 20:26:29 +0000 (UTC)
Received: from [10.22.65.139] (unknown [10.22.65.139])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 85C0618001FE;
	Fri, 20 Mar 2026 20:26:24 +0000 (UTC)
Message-ID: <056172d8-1e58-4437-9cd6-1239de292574@redhat.com>
Date: Fri, 20 Mar 2026 16:26:23 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] selftests: memcg: Fix test_memcontrol test failures
 with large page sizes
From: Waiman Long <longman@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Tejun Heo <tj@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
 James Houghton <jthoughton@google.com>,
 Sebastian Chlad <sebastianchlad@gmail.com>,
 Guopeng Zhang <zhangguopeng@kylinos.cn>, Li Wang <liwan@redhat.com>
References: <20260319173752.1472864-1-longman@redhat.com>
 <20260319194347.1048fc8d737b6e8f9d82663d@linux-foundation.org>
 <cee91a5b-5b37-4e19-b0c9-eea985ab490b@redhat.com>
In-Reply-To: <cee91a5b-5b37-4e19-b0c9-eea985ab490b@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: 7VqybUHf9ovOYDzPMxAZWxsj7spwNDaMO2UX9qTZ3Uw_1774038389
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1FFA04000F
X-Stat-Signature: n7xrt7hzsxsk1ehnetsd4cmh3nh8jh5w
X-Rspam-User: 
X-HE-Tag: 1774038397-703390
X-HE-Meta: U2FsdGVkX191ksvBxOqajqnx9WnZbULfd60+rgyY1oLdTvOGPx2ovVzWOim7Hhk+3uqUVrGsYkixJpYQdnWAc3qqRcC4KbbiXp98YGvC8o74Hf+ArnlO+EnQIMKNajsn4i+YeUcH8eCpuoKjU3VNnXUD4sVJG1/VZo0xBZBlQfgZmlFOXFv5EsEYeww97Fj0PRtFGZVYPPf2qWhXtXKvUMvmYQE4flXWbV+8j1L//QVshfLNc32Wze6VDbg3iAm4+8gCojdrEPQCVPcblVdnNWHGBYeUoJIche3Y2LIwblszAXQC1/uCoQOo8xAwqRjJ8Ks2jNG+9rSr7XgdsOPhk/FHfMdQdFDTgD5/XC3o7wfmSdyPBGBLFU/nVmCNwU001Na7Io7zKivJ62xkTS09NZzv7sCTH6Q84FeM9cmJKtb596zQEw6Lz26XuobsLxrKiPeNZBoctkX4srAhoi9HlecDGOgo/Mli81+zP2nJeEAU1XM/RKN7CiWK1QGTE9dUp7dZypaLdcKL5ip4TOnY/IgZceGCYksyndppi3AIwyn5AhLE4siuJwyczGYUWpY2xeJUFJb2sCaL4vcyO635anHCj/ELE9o+hKhLW4VF+pi0zJIMRnS6HifcrldI2qsFOX7bBiK0AMJwfwGcIou1hB0FTPn6rdjiNnXIJzI+tQIP/HPMYpVHAjmAruqVg6dqV96ND0zO+MINgdbi3KgjlUczQFRIxNZRRPII6GnXnHjmjaPCiVrtzP1u2nBaLBg9CNr5efxVVBRR2h5VxjSg5F6LmaQQUqjviuZbvW91d9VMXTw7s20nWUZz9jVnB/Gy7LnsQ2Q8Mru0XOKOmimZQCTTiQlGFLDsEJdQKxVC88kv4HLtBTzElYTPbEeEiyULX5KncyYrqmBpWgNcBw2N7xZTbg+IS4lQVFHuf6T2Wrn1gqAXL5teEZ3nLDrG5Sk7/1ZaEvORW6b5ScugR0Q
 MHjkFXH2
 ta7YuOXfuZ3mKfRsuD4V40SpC0HkmMBc1DiDXIxDY7A6zb+5oVmSafojg1/reSYynxjbqhfJso7+THdM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 11:56 AM, Waiman Long wrote:
> >> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> >> --- a/mm/memcontrol.c
> >> +++ b/mm/memcontrol.c
> >> @@ -548,20 +548,20 @@ struct memcg_vmstats {
> >>   *    rstat update tree grow unbounded.
> >>   *
> >>   * 2) Flush the stats synchronously on reader side only when there 
> are more than
> >> - *    (MEMCG_CHARGE_BATCH * nr_cpus) update events. Though this 
> optimization
> >> - *    will let stats be out of sync by atmost (MEMCG_CHARGE_BATCH 
> * nr_cpus) but
> >> - *    only for 2 seconds due to (1).
> >> + *    (MEMCG_CHARGE_BATCH * (ilog2(nr_cpus) + 1)) update events. 
> Though this
> >> + *    optimization will let stats be out of sync by up to that 
> amount but only
> >> + *    for 2 seconds due to (1).
> > Is this description accurate regarding the maximum out of sync amount?
> > Looking at memcg_rstat_updated(), updates are buffered locally on 
> each CPU
> > up to MEMCG_CHARGE_BATCH - 1 before they are added to the global
> > vmstats->stats_updates counter.
> > Because memcg_vmstats_needs_flush() only checks the global counter, 
> could
> > N CPUs each buffer MEMCG_CHARGE_BATCH - 1 updates without triggering a
> > synchronous flush?
> > If so, wouldn't the actual worst-case out-of-sync error be
> > N * (MEMCG_CHARGE_BATCH - 1) + vmstats_flush_threshold, which remains
> > linear with the number of CPUs rather than scaling logarithmically?
>
> Good point, the worst case scenario can indeed be worse than that. I
> will update the comment accordingly.

Looking at the code again, the hidden charge in memcg_stock should only 
affect memory.current, not memory.stat. There is nothing to add to the 
worst case situation.

Cheers,
Longman


