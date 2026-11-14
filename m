Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85ECD606A327
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cWWbsaIx
Received: by kanga.kvack.org (Postfix)
	id 735756B05F5; Sat, 14 Nov 2026 15:17:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E6B06B05F6; Sat, 14 Nov 2026 15:17:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D5D86B05F7; Sat, 14 Nov 2026 15:17:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 357746B05F5
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:17:13 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AF7CC120463
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:17:12 +0000 (UTC)
X-FDA: 85434833904.12.74AFA9B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id E84EA20002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:17:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cWWbsaIx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794687431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OZxdnEWnSrxJbR1e8/SaG5gFDq6H5EE2W5CAZ6cJ4ww=;
	b=bw096JXmPWHZMiK++jbnnXb85p+ZgsUraVGV/DtXGUsIYRai79i1mrpUoe6k48hSWrDT30
	BrmrPajzvvzsHrMwA3bo/6KmNQmS6RnsuLWdIDTiLfwanIxJ/ZkoD2q4ZzhIOjDx/0mMwP
	vGlqnD4she8fWqw3FYlwa3hG+QiXwXs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cWWbsaIx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794687431;
	b=B6ne8VaBUa97mWP1gVbejV25cqn0ksS7RaRGWZurBMI6R4T9EJXGI3/XBt3r7wEpotymaK
	UOCQD7AYoOrfXjN8LWALyGM34auVB3xz6KacmnMRnGZWdfzZmIezzsFofv9Gua7vYKgS9M
	saZ3L4wXFmNsq6X4Dv1dc567pZ8c/vU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 24FA040D82;
	Sat, 14 Nov 2026 20:17:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378E91F000C4;
	Sat, 14 Nov 2026 20:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794687430;
	bh=OZxdnEWnSrxJbR1e8/SaG5gFDq6H5EE2W5CAZ6cJ4ww=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cWWbsaIxnBdWa/4AtdpygHFk0lD1RcnYrPAcN4DBz5Q5NkxBnHyFRqSAUZbMVVxCs
	 cqqYmpw2kN7ZeQMC17g2X/lCT5KrKit12s2zkXOFzqTKueVoYFLqtTD9gnPuG10TZm
	 4shc6Swp2kDscdFX4FDnBWHsRrahP/DBs+OKcmwany3vPUTj1Y7IoH6FPJznXYu9by
	 D6CVZZc3q9Dq7+I0VU48mgU46PVXp45lJE+g572jZ+lxZy6zFY8CekPh1nWD/Vff5H
	 xSV/SNu534+cyGIjo7P+OS8s7wbGDR/iKOGNBK7BmS1jlFvbkcSYxM7UUjuWIr2JAP
	 4yMKFNQu4whAA==
Message-ID: <70740a32-92f5-4425-8676-68863f3e44c3@kernel.org>
Date: Sat, 14 Nov 2026 21:16:59 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/mempolicy: limit shared policy ranges per inode
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
References: <20261113-mempolicy_limit-v1-0-16688b2644dc@kernel.org>
 <20261113-mempolicy_limit-v1-2-16688b2644dc@kernel.org>
 <179467808112.482102.13365594235443107281.b4-reply@b4>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <179467808112.482102.13365594235443107281.b4-reply@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E84EA20002
X-Stat-Signature: 7baymywf9rmd89e68t4mttz13wd5hq3o
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794687430-293
X-HE-Meta: U2FsdGVkX1/zcBZLeF5gvJf23WwZ5mHMpI/D0tj1o5LgE6WDaU5Fd9ieeFWc/Es6kJLlBmBl3WeSdhyHRh+cPueSoSJgSvA2IjxyZNK7iinK9w8ND888JbOS26JypZc2a6hFD8rxPAO6duefFUWF5TGmtVnCKXGkWGByWepuMwN8zA+eZE7qGrK4k7EA35wemKeX8dPs8pFdUml8C4cMIrMRT7epu76toiY7ZY+4Wq9FBM+M2xZOorOF+2ZcjgZuWWp3fMTt+MCDFIi5Sjl5clsK84xJ4icXaPPiAh9hajESCzINmI+qMWxfZkBiTeB8wFXQi1pztOWsjYGvZ69eZt/EoKDQB+xVKxanUub48jLMmpUtzPelLc9vT+osCoxEuP61T2rgYSkv4OocqCG7z7wTrr8YYMGrVjZi66LFnS3nqW2N3VlfTRnv7k3r2KrErOP2hpeVpjbgsQG1nCsUDmPTnsc2Q1Myywwyt8kT4pYFp1XJwCRfFSa3Mg25INsvUdvmOsrvUR19zOQ4+xKcCF9gh/7dEYXzkQ1J8xKAsDgjiReX2fyPAGnSlRIb7UsIVa4sF0W3PZR9dE5CYsjLcVm5FHKxWQrXxeFIIgcuQu24McuLqDZsVBVDKakGqP0pa+mAtkno9slC7aNJitJDStB27I3b0FfwdGB/k2qN6dAObFMHFipmIXZgzN1aZdO1nwPsF2krEf+/ULx6ZxWOtfIp8N1yTsLEHA9kryZfWTxqgve1IDC7B+B9Kj8JqDW/l3BbbjEXJYZ7/t4r2nJZFz3nygHEilqdIECEpDWj9M68Dox/gUdmfl2ZleH+aLRJXZEG3wYVpBVvwD5ljOEUZZG2hSTg0UHR0tzCUegc3ss7luILSjlHmiyHavVbOrUArTpMwix95HF3UwH33Bbk0saoaqEFAkEcb2JztAXpgepi42l8EolpMRaPYE0ySG/FLH5dcv0uKP3wJNz1LEm
 lh1qVTrl
 y6SMoJyFSW2g+lErAMUDxY0CvVe5vahPIgM2aiTWbsPhKuVSgdzHKgxNnbgNx19AMz+aJ9ayfFiqWmks9aeQ71yCzV86UdQbNnxvr0GtZgBCzlXaTo5hDfCDfkvNMa2a0lM1SW0PS4FvY1VZqqpoiyBlggcAFdageIA2EPFn3SOCD1ko4Dtl97+ZkWrbWQ0OfSlWVRfMqY8LV0TGNgZP/WtkFddYZOxpQzUXiVtukx2wXNxQ2SVeOUlvjJ/4/MLOXSuKpXUHqcmKMiuH4r3lXGuHjguVUXodg61t37dqPQQGBL2kEFksnJutGCEwGDoACMmzjMMdV0Qz1AVhjztmWCIQJgSmqHj8w3v0oV0FTLxL8r/0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/14/26 18:41, Gregory Price (Meta) wrote:
> On 2026-11-13 22:36 +0100, David Hildenbrand (Arm) wrote:
>> Shared NUMA policy ranges can accumulate on an inode after its mappings
>> are removed. Currently, these nodes are effectively unbounded (even though
>> the allcoations are charged).
>>
>> An unbounded tree can cause long rwlock hold times when replacing or
>> freeing policies. Instead of trying to fix that, it sounds more like
>> having many nodes is actually only a scenario for processes trying to
>> cause trouble. Most use cases will probably only use a handful of them,
>> not millions.
>>
>> Add vm.max_shared_policy_count (inspired by vm.max_map_count), defaulting
>> to 1024 ranges per inode. Reject updates with -ENOMEM if they would
>> increase the count beyond the limit, taking merging, splitting etc.
>> into account.
>>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> 
> This arguably breaks userspace.

Which is fine if there is no valid userspace that does something stupid.

> 
> A single mapper that tries to set >1024 ranges would start getting
> -ENOMEMs unexpectedly with this change.

Sure, that's expected. The admin can raise the default for these odd cases.

I did some digging and was not able to come up with any valid use case.

The only is that you have many VMAs for the same file mapping (mprotect etc) and
then do a mind().

But that's precisely what patch #1 does.

> 
> Multi-task mappers were previously unlimited, but that seems like more
> of a nasty unintended corner case - not a real feature.
> 
> A single process is already limited on the number of vmas/policies based
> on `max_map_count`, so it seems natural to just use max_map_count
> directly, but I took a brief look at some distros and most seem to
> ship a raised `max_map_count` (>1 million) by default).
> 
> I tested that and even 1 million can cause a soft lockup.
> 
> Not sure there's an easy solution here, we might have to rework the shm
> policy locks.

Do you know a single valid use case that's not solved by patch #1 and would
trigger that many policies?

Ai was not able to come up with anything for me.

-- 
Cheers,

David

