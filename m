Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A275C98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 10:53:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E80CA6B0088; Fri, 25 Sep 2026 06:53:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0B2B6B008A; Fri, 25 Sep 2026 06:53:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CABD16B008C; Fri, 25 Sep 2026 06:53:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A3A6A6B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:53:35 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 386CFA6B77
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:53:35 +0000 (UTC)
X-FDA: 85251973590.09.6653F3E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 86055C000B
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:53:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=clSdgr69;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790333613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U4ypvNWm4aotVgY291fvLY+mpi3VTGcxb5Izklu379E=;
	b=FCUqU/ZLCUXHStAvwe0AF7Nb5VWEHjrHtjUx31YZqc2mHY/MricFLH7uIjBdVTFiGRGiz1
	0tBkjri2+S/5WJrz2FVHUMlKj2EVLo2qxhoAaHC/H9H7vWCgtfCthM5XNCq2FU3/GZ5U/w
	1uCpY346xRPhyGsREwaxKVWFBBTQEdY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=clSdgr69;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790333613;
	b=c6VRPqoTrCT6Pu10erizuhehACHcltjwyGLeAFiDFAsGOrfRX9WOzaeP0jkaYpLVCA4iPQ
	5TbQWzlCxWSgSCAREx2bKQ1yjU00RAWVoadBUyO0yx7IyP9RLNfxXbpTSdnaCGo1wGJUkR
	WNsd1GIaG9Qzg3YvHUozCUxCuM0BWTY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E875D60235;
	Fri, 25 Sep 2026 10:53:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B41D1F000FF;
	Fri, 25 Sep 2026 10:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790333612;
	bh=U4ypvNWm4aotVgY291fvLY+mpi3VTGcxb5Izklu379E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=clSdgr69kSQSoDhvquHeZByZ0Vz2GrWz3kkc55A0xvhOVQgmWEq9Iuwy6fP3Q/IpD
	 IQ/IwPtUEJhIKkmWeLrahrtasT1Rfk/xzWURNFmWDx/gUFUGUjLvLwH9pVOOU7nN0Z
	 qHX8vh75+MZ/vWx/46bNUfHsJzyHLL0Cs5khhC8/CtCH9NfIN5wWfCYiiluJfnSA5b
	 9m3/0T3iNRZMNdRpAq3KA//nJWZlPscSzMfVdzZ36l7AoQ8H2a1D9ppMmnj7dPbkHU
	 DmTbG0OGk97t/v5SgLfI06DbWkEnzJoAaFp//jPBzTequQ/MgWpgd6QHLQfq48DeWX
	 uv0L4h6daO9cA==
Message-ID: <0aa5b55f-54a4-4d39-885b-817c0191cdeb@kernel.org>
Date: Fri, 25 Sep 2026 12:53:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/7] sched/numa: separate VMA placement from scan
 continuation
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 kprateek.nayak@amd.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
 kas@kernel.org, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, hannes@cmpxchg.org,
 shy828301@gmail.com, raghavendra.kt@amd.com, stable@vger.kernel.org
References: <20260922182928.2199090-1-gourry@gourry.net>
 <20260922182928.2199090-5-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260922182928.2199090-5-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: w7yocjqz4fts1wpc3diwyzhupgprn6a9
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 86055C000B
X-HE-Tag: 1790333613-670109
X-HE-Meta: U2FsdGVkX19DTPnhgXk1D0P4pG+G+C/5zxqnLEP3lRa0T4JkJw8S6/ZgR+WMgkgs0LNV42LYzzQ98Sef9vsR6YYx433DL4ILBjk+XLOF15yvRn26n9LVsFixR946rCBlLvEpbhwyvdOnRkX4VxXO7uDMhBmS0GPj25Bj1/oOTsYuKioZ5Ut5plCY3JJFIj6jYUzVeoU54+7nKQoE4tQgtCp/toLUzZ4qIpCgV1B+QLAUuKRS14ch4f9T+4fPA70kBXKZimh0nHrNpWtO73Fqs5GoT3uCJE6ykjar7F1HeyzEU7hPC85pzLYA/Ulop7jfwiD+PpA46ryNAsS2WsK4cTVgpx16gW4MSRPFEk8m6g8QNX4ZeRK4OHGYBGKINvnj+XSTF1VyvPnaxThSjkAkpx79DZ/bRZCQAx+ff5CT0TlrtGER7OxONwAbnSNtL+TC1KCW3Q0kAPzmWR1Y/YlJYSP7Q0QnZJvSev+BZTShDq/T1dHGI70wOFderKLNIYr/i2PbfJd7wQ/spFNg0nhBSbM+zmIPvXJP4XKpBp8RrzZA2cO5cgiBie4YiE4xg+vLWGLrva1llfVVfxCZOjAPZPpOCONSd+AQvunea/46T7u+H8I4S7QvVOdkTwte5qGADmvaQH2ywp9/Pe4o9/gFBMIDWbLlMxQGfcHgjjurKN1sXf2ZxXEYMmnJGt2z98C8cmG9XvcvMGsbx1KJEjUP72Af3F1hY0s2O7bMYevpr0aTOdZvaqTvL3XFAlM4pM44D+RHe4WZwCmCFYl/MpyRpUno6voKmTiE2BX4I6Imyd1TMxLYhYdXTOetmRe81qbC6Jdp4ZRwIykeJlki+JdBeYO/X+o/SSShA32gVFrNMBuxJmoI+94Zth+/1vE6KFtYyE57KyaTsi9x+46zrgShdTco7RX59gbRaEJlC0D++CaqrjQKq8+HPahY/yeTzymk3UmAxnNyugDcNLGos/1
 WM7z9ulf
 aq/zGJ8uzIQD1DY3f4C3I3K6X8qyTO7Y3A/iDUtxztRhmW0kkd54hNVZaJRkqpAzagXVQ6dvjeJO42MuO1UsStgCd9p0DuQuRo532kvxBd9pXkbwBRoWxRzxmpMkW+83zJvjxzwUMK8dpQL3d6VOKkNvb9GQoeaX7uMoCFjyiL1Dr1P8mxCaMEwBaCnCQLivpLyPaHEsWq8aJ6o6LgItmLou5q4Ia3iPgYdn8bIW2wzrskeg6PlM+yTx1+6gyZAJoDfvtywIIrtOH4ze63xPLlL8wmaD0jdkXH/XrsKJdvSnqCVLOiqV2vdfRiZHZp/37dp+YIiD+bf7WRfI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>  		/*
> -		 * Do not scan the VMA if task has not accessed it, unless no other
> -		 * VMA candidate exists.
> +		 * Do not scan the VMA if a task has not accessed it, unless no other
> +		 * VMA candidate exists. If a scan is already in-progress, finish it,
> +		 * but track continuation separately from starting a new one.
>  		 */
> -		if (!vma_pids_forced && !vma_is_accessed(mm, vma)) {
> -			vma_pids_skipped = true;
> -			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_PID_INACTIVE);
> -			continue;
> +		placement_due = vma_needs_placement_scan(mm, vma);
> +		scan_started = mm->numa_scan_offset > vma->vm_start;
> +		pid_scan_allowed = vma_pids_forced || placement_due;
> +
> +		if (!pid_scan_allowed) {
> +			if (scan_started) {
> +				trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_IGNORE_PID);
> +			} else {
> +				vma_pids_skipped = true;
> +				trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_PID_INACTIVE);
> +				continue;
> +			}
>  		}
>  
> +		/* Keep scan policy stable while processing a VMA in chunks.*/
>  		placement_scan &= numab_mode & NUMA_BALANCING_NORMAL;
> +		if (scan_started)
> +			placement_scan &= vma->numab_state->placement_scan;

Besides avoiding the "&=" in all cases to make the code readable, nothing caught
my attention.

It's all very complicated, so I won't pretend I fully digested the logic :)

-- 
Cheers,

David

