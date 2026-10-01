Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85D31CA5FB3
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 10:45:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D09B6B008C; Thu,  1 Oct 2026 06:45:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A7CC6B0092; Thu,  1 Oct 2026 06:45:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BEC76B0093; Thu,  1 Oct 2026 06:45:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 61E436B008C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 06:45:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 87FD2A6C13
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 10:45:54 +0000 (UTC)
X-FDA: 85273727028.30.9778F8D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id AEA51140002
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 10:45:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CNXCRKek;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790851552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lL31jcWEt3a8NCBES0nlqlq3u3R3QdTq1acR6iXKe/M=;
	b=EwjUmMXFJY5DK6paIlE4qx1F37DWWPDHx6DPqJIfvqczUntuRWBO3Im/tw+HwpvOO+RWac
	jiISw3h6rqIeN8QIJvXHJytXHBQ/jRpyRZ4xfzTxAaznDxNl8Gl3TvzFBbgdTmjwJEBhkA
	man4xD6pbcnaLz6yY6c9dHHwrxHHDVU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790851552;
	b=4dMeREDmifop+vpwonKhVw3oaD3KFv35bD7D4ZksaBV4i6OV/J5VDi+iUyNUoYANGpYnYN
	uwt6VARG8LwHMR/H0Xd8Vj/H+RVeRw9gzU/Ua8aprjuQdTfUOm8Et33LaY9CewPdAq9SNR
	TQhZWpFHZ0FIMK2vOhWrTJ+zSsVQWsg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CNXCRKek;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 25DE343538;
	Thu,  1 Oct 2026 10:45:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2841F00898;
	Thu,  1 Oct 2026 10:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790851551;
	bh=lL31jcWEt3a8NCBES0nlqlq3u3R3QdTq1acR6iXKe/M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CNXCRKekzJbfxi8M92VZTtFEap1OcAI/bqM5TMhY7xYNtCaBm8CxvdChBwUOFNBK7
	 vdSglnAbSNG+WBQc4ZDUwet0FFYEyaMXKGcqLnDhdeGbJ606sCaUe2jaFDq0wCoAaW
	 m3DX382m4GpI5aM7uhjcLtO0BcXTGYrxRbkg9Dj2ZLsfr7r9XalJzy+s/yireNBQwy
	 SDW+3qYp2qGI9uW2yzs8rTE/PaUNLTq4bwnIEv3wY+Y7I/bfCpQhthw4bht2SNWlVH
	 oDk1Jw1/PdGCxNzgQALD3a8MputnAe8s+PM2UoBn5jEIoqdsP0VZ5OH8AFIMF0r1Bv
	 8N3DY06jWRKcg==
Message-ID: <b64b32b5-711c-424a-8bf1-478ae75b9d20@kernel.org>
Date: Thu, 1 Oct 2026 12:45:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/7] sched/numa: scan PID-inactive VMAs for promotion
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
 kas@kernel.org, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 ying.huang@linux.alibaba.com, matthew.brost@intel.com, byungchul@sk.com,
 apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, hannes@cmpxchg.org,
 shy828301@gmail.com, osalvador@suse.de, raghavendra.kt@amd.com,
 stable@vger.kernel.org
References: <20260930112206.205083-1-gourry@gourry.net>
 <20260930112206.205083-6-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260930112206.205083-6-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: tegj18r41er66ti958yb9fi6u45syffy
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AEA51140002
X-HE-Tag: 1790851552-905441
X-HE-Meta: U2FsdGVkX18hzEKKFV6XdlLUsTx/Z5+mG/Zs0fRJi3SwEqjuJsVqVUG5oClnJwZD4F40zJ2HruKDcobRnddKGshL3s+MbDLOngi9Dvje6yAO/ufYv7uVWRRbSwxfP13q4hj5g7skX72ysLtUV33xRkKdXH9cFd4dVUdF0byaJBOfJgXfRZm57DdQlSGQHzGbt3wggg6iRS6H6wVm+EBQNinYR0w3mIvzcmBeJJmvvBzeACppH4K0t6a/fWqXGBfJnFaPXt/D2lLw3hKQALwRSdaR+lRubuluX+wKIhkRytjzDVIxCLa9PoeBHsyBqaVGCoXIQbiTH+uuMl8Ga6Wq3aSUH+j4e+WvvG6081qSz6/DfVQnjrsyxF3+J3+cTJuGZUy79WuDayZU9+TKZKCvcruE4ZMULgnV0U+JeIuMg0XGCF5VxpLlAmsNl2ma9/wgDj0An5phNXAftBJr4Pf9v1by/xfdSCASVODw1kekvGQohllMQ0sRdwJn3hriHEOPRXv4xT2zRsI6L7BkuXGAOE3qXCOLT/UkDZLmU39j6hgyxciRqQkqLm8PVYKv2AGO60LXGiXsSPBg6dgfKpZJCj6Xu5dS6NzqkN3j65N6TR0Ws4Vvdem7JbBracWVEv+jHj8XlfNspfDbWUevdPCEaTXtBaUnX5QWNhpfpZdyGO90JW8dzJU0EzK6DY4TcOvrlnT6DBUcIgT6ANNH1RTXR/5GONmvcUGs85tjafSViYXmyZfmNrBN2mrW31LiP+2iY31+N+8c8CyFzd4k/pBbchQcj5ZUKS/OwTi7msmk/03CXsKBLk33qckPSD7Y/FSCZ6BOwM3/OwX0vZvV2TG8+hCJT4flReo/B/hn5JJogM+idqzrgcbdj20oUOjkVF8r0ZYT0SJLkbMnkddxeK2rFdUAeULXSLAnJ1RotAhGSKFmkBZ7Jv9HL96QT8k28fcZTwFBYJIoZuJP2GK/hUa
 ybvwe/2U
 OddS2hBwbVKpuaekJgiu9xK+dKSKgr7/ckf8XXWOEY1elpYV06kNWE1JMBkG40oWS46dl6AMdWfq4RfFaRTDggELAX16YVVfKkuGrWqSG8CdmsycWTO/ttMwIDWmQKrFEyLwKBvRwGQPdDn90kOZjEkjD5B083vz+6Jbh0L4S3Uc+XGa9j/yl3JW9moGS52FInq+g1DKAe5Dk+gFhBwTU2eu7DLtbpsRQlceaeY9F2FF/tEFe+ZJNXdnGkO7wsrEoZiRvqN3gD52CX5p6GRc7AmOqsXY8zeG61/ER+QVf8wLwS4jH0aU7TgT+YdYY5MsN275wC5yCLwXwfA2RX44u+kMFLkrUUrSuFY6bvT82ywS/1ctACC31XZl5DjKn7HG+ze+0UBO0xKby73ZISMSrPUElifhQHO0DTPiF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/30/26 13:22, Gregory Price wrote:
> From: "Gregory Price (Meta)" <gourry@gourry.net>
> 
> Commit fc137c0ddab2 ("sched/numa: enhance vma scanning logic") skips
> VMAs without recent PID activity. Since only NUMA hint faults record
> that activity, the filter can suppress the fault needed to promote hot
> slow-tier memory.
> 
> Let memory tiering bypass the PID scan filter. In combined mode, use the
> placement decision to restrict top-tier sampling to VMAs that need it,
> while inactive VMAs still receive promotion-only scans.
> 
> Make this decision only when a VMA scan starts. placement_due is
> evaluated for the current task, and a partially scanned VMA is usually
> resumed by a different thread, so re-evaluating it for each chunk would
> demote in-progress placement scans and starve large VMAs of placement
> sampling in multi-threaded processes.
> 
> Track the last completed placement scan separately from scans of any
> kind. Promotion-only scans still update prev_scan_seq, but do not
> advance the placement-starvation horizon.
> 
> On a host with 768 GB of DRAM and 256 GB of CXL memory, one large shmem
> VMA consumed most scanning activity, while 2,537 other VMAs covering
> 84 GB were skipped as inactive. One stand-out result: a hot 20 GB hash
> table ended up trapped entirely on CXL and drove CXL bandwidth
> utilization beyond sustainable levels - resulting in a large regression.
> 
> With this series, the hot hash table ends up split evenly between DRAM
> and CXL, tier residency tracks runtime load, and CXL bandwidth
> utilization drops from 45GB/s (maxed) to 5-10GB/s, while DRAM bandwidth
> utilization increases from ~200GB/s to 250GB/s+, resulting in major
> throughput improvements for the database workload.
> 
> Fixes: fc137c0ddab2 ("sched/numa: enhance vma scanning logic")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

