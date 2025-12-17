Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F06D1D6406F
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 03:09:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA0EB6B0005; Tue, 16 Dec 2025 22:09:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E71BA6B0089; Tue, 16 Dec 2025 22:09:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7E6E6B008A; Tue, 16 Dec 2025 22:09:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C2ECA6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 22:09:32 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 46353136BF4
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 03:09:32 +0000 (UTC)
X-FDA: 84227482584.26.FB5A0CC
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf06.hostedemail.com (Postfix) with ESMTP id 03BEA180007
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 03:09:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dyEaTMhh;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765940970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oBMrZjjwlUZToKdAahyq4R4SSDCHf1gMyTud4G2X2/Y=;
	b=N1CaLFpYskkTX9JYHj2iuTg38KxiFLkNtJQdWynVV0VTzuXi4ZrFRJrAoXtq3Wk8d64eX1
	4ltJqDERzJ6XwDP12WqX8ncMGRsmNQXw3SQG8PuACW7qkn0jut3ctUsHbHpcj6hEwo336b
	iMMOWfvQWqTUbtXiQtLOZ8rqaRD3bqc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765940970; a=rsa-sha256;
	cv=none;
	b=HezmgZmKmVIYQpiNdeWFcG5lG+3e/OhbMta2W+yIeGndDbIN1UJZe8UXZHtORBrXDAByfA
	crAiDtJ9RhRLFxsn3f/tAwoQL5mgGJfMo6NN/wd+I1mBcumgPR3vmmHIjBKIrfkZDojCwI
	dSlKbOw/xtRyDmRf6/QGi158gtRPidA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dyEaTMhh;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765940966; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=oBMrZjjwlUZToKdAahyq4R4SSDCHf1gMyTud4G2X2/Y=;
	b=dyEaTMhhrloZ9Q7XipnZUMqDpN0uLCAeSkfr0zkV+MJe9rCYbaMKdJFa5dIUoGF3+tbDxIBlbUIZh7FKvm74s8t4bT3QXD4VxDHgeiMfvValsQjDBjz+Ye29QIhDWKNnf4h8KXEt40+xYk3W5W7uSh1OnJKr9EbCyH4A4bUbhYU=
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wv1ZBna_1765940964 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 17 Dec 2025 11:09:25 +0800
Message-ID: <1c6cfc9b-046e-4dec-a859-032e89e707d4@linux.alibaba.com>
Date: Wed, 17 Dec 2025 11:09:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Consider non-anon swap cache folios in
 folio_expected_ref_count()
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, Zi Yan
 <ziy@nvidia.com>, Bijan Tabatabai <bijan311@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shivankg@amd.com, Hugh Dickins <hughd@google.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
References: <20251216200727.2360228-1-bijan311@gmail.com>
 <6b4cadb2-6246-48cc-9c76-64ba0a23198b@kernel.org>
 <0C218C18-916B-4BB0-8B37-AC82503E4AD9@nvidia.com>
 <a47adffe-b2c6-4d86-a970-b31c2e620146@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <a47adffe-b2c6-4d86-a970-b31c2e620146@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6p939nct5mofsm7dcxxz8byirfobo4br
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 03BEA180007
X-Rspam-User: 
X-HE-Tag: 1765940968-950623
X-HE-Meta: U2FsdGVkX184mVuUx+9Z+Vuj7pBHjwI+62FXM6OzMsEPSJsVBoOgLTOqco0N1zxBsudLQ+daDmgWTKa9O7rxsd5qlxVROSFb34Dsuume9pl17AESxYIcUD+nS3vMfOWSNcOiExd5W/V+DsjNYskLJrF/IUwYfaLSIyCMjd/nVLdMiHT6afxpvtOaLexbJLTeTwkoatdWKMkIOvEqFPTDiw96Gf/bEaanpyGqo0EoGPUZkm7msWWCev241x12oXqwubZfBj8VO+ddm6ercxwARaO9WvozirMSQCxIGlgA8fqXSyRIHtURWqm+VOxdFyTWf7htcvkahvjMBnFPcSk4WXH9hmN1DCn/2tof+efXqPxPWUA1qMEg9asciQX3sw40RCBd8qvBVGw5HhFYV59/2byPOALTMxjvp+2rcie9WxFDENzNc4l7rvQm2pyTlPFcfiVH1YTYThCUM+ZHm/+Nn4FjBirLbVn/31hiAA4HRcHAYVEfvqBnYQ/CCvvDDL4Q+1XGTNwmpQDPGfcs7bbWLlBysXZdL0QvAGWku+onF/+2Hm56JqW0IcAPPthqJVXJIpzSatiAPE6GXJ65Yr+5aOUZAdpExgmoQ7SArP+AnIuEDt8STI2TNEWeD1uOyTlhkxtTFel7VPIiQs4ZoptDK675PNGqI80aDo4wy+M68z0rz8Va1HXJGX2Ti5T7I1l7cLW3m6T7ampKqhJC2zfRVShStxS4etqSfP8rCDMPps3Gd7LypavyZSd7n3iZcBBgXcQLR2zC2jQmnhoxcCPYtEmV/9sQpL5I9L3cwLCdHohcF0ERkmkhqi3EgqA2E2myF0lstCojoSBLuRG/oKtD7Z5VbyxNFAWyupqn4ck549lShYjLhtKQA/xmQxF7SGHz6/aVActJHbl4ZtPKJ6VxzkvAG0Mwoa7SB1nsHAiXbJiDulclOkiUZpinYEz92w3TquACi3T2Pu3NDWBx4LH
 8G2FfrBQ
 VgDVvMs5oeNLl4vvMElJCyGj1f7X06L24oEtVHDMUKAknYBcb8vGz25DEq84KbKMwqAjXtUGbshrEVhGA2/fYqIwOEx9HgvnqmmYR4PDXm1SDXzrn/Z8CGcPiLh12LQan8h1J6o3ADSX8ZGNO/cHrKpt/6i2lhe8ZEZCvWSfiwkqyeAjF1Nlqbb/J9vV6Um2/vctZfa0ZeqZBkn7NFIf2RDrTMEge9ChzLK6o3s3h2YseeEeTWzz8/Z3ovjkl75jvHlvx1v+MeH6t25OTei00/pKuC2x+2ZgAJxKM5YFm4fqpeO6kY+6FFjvenAqHsmzLMKuXfgLJSmJfn/6DaG3+d5N814oqc43w8U4Z++wAd0Ooo7HGEQCOzsYc+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/17 09:04, David Hildenbrand (Red Hat) wrote:
>>>>
>>>> I am not very familiar with the memory hot-(un)plug or swapping 
>>>> code, so
>>>> I am not 100% certain if this patch actually solves the root of the
>>>> problem. I believe the issue is from shmem folios, in which case I 
>>>> believe
>>>> this patch is correct. However, I couldn't think of an easy way to 
>>>> confirm
>>>> that the affected folios were from shmem. I guess it could be 
>>>> possible that
>>>> the root cause could be from some bug where some anonymous pages do not
>>>> return true to folio_test_anon(). I don't think that's the case, but
>>>> figured the MM maintainers would have a better idea of what's going on.
>>
>> I am not sure about if shmem in swapcache causes the issue, since
>> the above setup does not involve shmem. +Baolin and Hugh for some 
>> insight.
> 
> We might just push out another unrelated shmem page to swap as we create 
> memory pressure in the system I think.
> 
>>
>> But David also mentioned that in __read_swap_cache_async() there is a 
>> chance
>> that anon folio in swapcache can have anon flag not set yet. +Chris 
>> and Kairui
>> for more analysis.
> 
> Right, when we swapin an anon folio and did not map it into the page 
> table yet. Likely we can trigger something similar when we proactively 
> read a shmem page from swap into the swapcache.
> 
> So it's unclear "where" a swapcache page belongs to until we move it to 
> its owner (anon / shmem), which is also why I cannot judge easily from
> 
> [   49.641309] migrating pfn b12f25 failed ret:7
> [   49.641310] page: refcount:2 mapcount:0 mapping:0000000033bd8fe2 
> index:0x7f404d925 pfn:0xb12f25
> [   49.641311] aops:swap_aops
> [   49.641313] flags: 0x300000000030508(uptodate|active|owner_priv_1| 
> reclaim|swapbacked|node=0|zone=3)
> [   49.641314] raw: 0300000000030508 ffffed312c4bc908 ffffed312c4bc9c8 
> 0000000000000000
> [   49.641315] raw: 00000007f404d925 00000000000c823b 00000002ffffffff 
> 0000000000000000
> [   49.641315] page dumped because: migration failure
> 
> What exactly that was.
> 
> It was certainly an order-0 folio.

Thanks David for the explanation. It completely makes sense to me. So 
feel free to add:

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

