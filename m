Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 613EEFA0C32
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 06:09:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9FDD6B0092; Wed, 15 Apr 2026 02:09:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C765B6B0093; Wed, 15 Apr 2026 02:09:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB3BA6B0095; Wed, 15 Apr 2026 02:09:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ABA156B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 02:09:27 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 619AE1B7A29
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:09:27 +0000 (UTC)
X-FDA: 84659763174.16.56BFA5F
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf08.hostedemail.com (Postfix) with ESMTP id 34E32160009
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:09:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=SRw6HWUR;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776233365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dyJinyTSq4T8BSAk1UnNAy+5mkfCDxihn06xcyJlkGg=;
	b=v6Zq+jvLGLV5dtDwsRcfWfncJVAAleDFVFKIbuO9Quk2tkirZPghx0yzxJAlBj83gC0Zi3
	8GKnG4ijHU9tDgxr2S/LbhpHiYxcWFNNQtlx4z9p7u/HRH6u2b5JVzBz7YDYbaw/ei0nO5
	mfghXRhJlxlyC7EzRW0h9aOf8W7/A+g=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=SRw6HWUR;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776233365; a=rsa-sha256;
	cv=none;
	b=g7FPzTMNOKJ+pkfTfYHnild4Qz5HJjs2pRktrA0aMPLegj/fESTAGvMsme2wCyLNU0h1c+
	gqr17Cr58FtU9LLo3HljEOIjaYvqUkndPwyZOZudx8yS/g3Wm8hQWv4ZINf4gs8SQqDX45
	qTYJLzn7Jz6KbJrFTucRQ2TJtEm2gSQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776233361; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=dyJinyTSq4T8BSAk1UnNAy+5mkfCDxihn06xcyJlkGg=;
	b=SRw6HWURbL444GC9Z+kOyHTtU6n9E95+SrIGg4IWGCbbbwInD8olzK3BGeXESu9CLaje/deah98JNG4ZKmA/jIzmpWJe/6nlKKazlR1okqJf84xjWnNjoe+/OKSBqlXqvdlC7N7d3SogaoHcRxnv4HL7sxE85YgYHcubMmtIjns=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R401e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X13bA.g_1776233358;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X13bA.g_1776233358 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 15 Apr 2026 14:09:19 +0800
Message-ID: <1024290c-a00a-45db-990e-50bcf7c817ff@linux.alibaba.com>
Date: Wed, 15 Apr 2026 14:09:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v2 01/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check
To: Zi Yan <ziy@nvidia.com>, Matthew Wilcox <willy@infradead.org>
Cc: Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-2-ziy@nvidia.com>
 <ad1P-bfr_Vp6VdKf@casper.infradead.org>
 <CD565023-4FA6-44C4-8E40-8B06CB09B59F@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CD565023-4FA6-44C4-8E40-8B06CB09B59F@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: hrma6c9jozni8s3ip1xkhi7piqe791hn
X-Rspamd-Queue-Id: 34E32160009
X-Rspamd-Server: rspam09
X-HE-Tag: 1776233364-785765
X-HE-Meta: U2FsdGVkX19PhbY9yaZop5Di5oYO5elS7wYHIhtT/Y/oLSIn928R91EOZnCvzAbZWQYptqnu0IFu8lGHAuZgjHrVd1dWY0q2ZUhKApz5ezRmFjMwE2yyG+prF8Yd0YYcPbqdh5PKJ9uqyHcEGabjMWbXKTgEG1nACrdY4UUfFB49VZs8FNqnaWd83zD08ksCwAjcFtB7UCCHc2mv4ToTKcFye3vuOEJz85b7dfHShlWWdFNtO5Ggia3iWhM4urJSKB6RiwY09FyaqM6/ce/KrD/TOgPviYKTnNChwMnrbY5mWLqomvsi5qXX8pDquX0lqphLgk3c7Wgcv416eFX1SiCP9Sc7S/M7D8yVh+BuXbQXdDrsJ+eUCBC9/PchbhlCbuEEX905/sHjUW40j+YSk1Fz+RvoyTJ/OvRbBkdZ2kb7jMWv+SVaQ/PLAkoRWZY8Qx8V0eS1vX4e9IaOdvBWgWSAKH9kAUwbOwdk9eeM5AxT08aci3BGVuHDed+P3l6w5r/9NqeqtOiYjSsyLgDlQU38PtYFCyfaV8X2T5t4dxz6dn6xlE3ANcdo7m+4UPYeOQZEw4yUREerhpfk9etWA/Bet1zFAQozatXGRzDBn5JvsmxsdHnsqXNIQhFC6r5jWJFuHk8XRKSJ1ehauTUmF4YjTTlDKbwWvZbqK1oXaPHRu+r/M/170CLln8diuyoeTUjdTPCfh0LIRm7zWCbo1HqjBFwgbDz5z0reaUO4W5UhRUzltrc1vHB9nXQ7VnBl1R1XTi4CftggJYxJPsyyO3wrblaECWkLmeFhgK3IqP51PSGgz6sSvZ51Hy0AmfntDIBVoP0RIERXb2kxV0k3hXBjUBfIPrEd82XY4Izm4xZYBwu5hV8A2SRjwTCAGYzLpVZdW/NppT2OR/3i/fXlN9lOyBYUOtRYNL+bs+7oh1JkNkSWzU54TYqbIizkq6ekEvV8KpV0Wb9LpKfUQPf
 HuDkoKk/
 0QJFW7FBnG/tUGewO3bQ44wqmOIyia8pQbCdgA9BAWDqOpYZn32e5BMNe7NnBWEvwIijK4whgedC+4WcQ7JFMPj024SU7NbLClaTk8LI0mIc7Fpp5HsjIccsI3bjMu/44fbHyobRjmfZmMQmgu8NJnqWhBce4dP9VrVGjF9+kUKwoZ1PapwqomYPRBzh2rOHcRo3AVl0Yy8K+RLLjieXxVDp+8z2n6sUwBYgW7aHegCVzr2TUu+0IQVa5izz0L+W3oMmnlFGYO+kWr0Y/IlIZMhbpY7T1CDYe6ztJgAW0/xXh3DERyCb8OMcvw/huBRWI/7gOUpllWrhVvEJV9NV8IxpT/Fv7S2FvDEe+CRngcXq1O4GWRfzlvdnsGNev5J3axKnDwhu8qoce6+67sJLUJ6n+k6wql2xeRdqvGEtXlFaeTRs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/14/26 4:34 AM, Zi Yan wrote:
> On 13 Apr 2026, at 16:20, Matthew Wilcox wrote:
> 
>> On Mon, Apr 13, 2026 at 03:20:19PM -0400, Zi Yan wrote:
>>> collapse_file() requires FSes supporting large folio with at least
>>> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that.
>>> MADV_COLLAPSE ignores shmem huge config, so exclude the check for shmem.
>>>
>>> While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.
>>
>> Why?  These are bugs.  I don't think we gain anything from continuing.
> 
> The goal is to catch these issues during development. VM_BUG_ON crashes
> the system and that is too much for such issues in collapse_file().
> 
>>
>>> +	/*
>>> +	 * skip files without PMD-order folio support
>>> +	 * do not check shmem, since MADV_COLLAPSE ignores shmem huge config
>>> +	 */
>>> +	if (!shmem_file(file) && mapping_max_folio_order(mapping) < PMD_ORDER)
>>> +		return SCAN_FAIL;
>>
>> I wonder if it should.  If the commit message to 5a90c155defa is
>> to be believed,
>>
>>      Since 'deny' is for emergencies and 'force' is for testing, performance
>>      issues should not be a problem in real production environments, so don't
>>      call mapping_set_large_folios() in __shmem_get_inode() when large folio is
>>      disabled with mount huge=never option (default policy).
>>
>> so maybe MADV_COLLAPSE should honour huge=never?
>> Documentation/filesystems/tmpfs.rst implies that we do!
>>
>> huge=never       Do not allocate huge pages.  This is the default.
>> huge=always      Attempt to allocate huge page every time a new page is needed.
>> huge=within_size Only allocate huge page if it will be fully within i_size.
>>                   Also respect madvise(2) hints.
>> huge=advise      Only allocate huge page if requested with madvise(2).
>>
>> so what's the difference between huge=never and huge=madvise?
> 
> I think madvise means MADV_HUGEPAGE for the region, not MADV_COLLAPSE.

Right.

> In v1, I did the check for shmem, but that regressed MADV_COLLAPSE, which
> always can collapse THPs on shmem. I know it sounds unreasonable, but
> that ship has sailed.

Previously, I tried to make MADV_COLLAPSE also honour the THP 
configuration of shmem/tmpfs[1], but Hugh strongly objected and 
explained the original intent of MADV_COLLAPSE[2]. I’ll quote Hugh’s 
comments:

"
Seldom has a feature been so thorougly documented as MADV_COLLAPSE,
in its 6.1 commits and in the "man 2 madvise" page: which are
explicit about MADV_COLLAPSE providing a way to get THPs where the
sysfs setting governing automatic behaviour does not insert them.

We would all prefer a less messy world of THP tunables.  I certainly
find plenty to dislike there too; and wish that a less assertive name
than "never" had been chosen originally for the default off position.

But please don't break the accepted and documented behaviour of
MADV_COLLAPSE now.

If you want to exclude all possibility of THPs, then please use the
prctl(PR_SET_THP_DISABLE); or shmem_enabled=deny (I think it was me
who insisted that be respected by MADV_COLLAPSE back then).
"

Afterwards, we reached an agreement to keep the current logic, and 
Lorenzo helped update the docs, see commit a27848a03504 (“docs: update 
THP documentation to clarify sysfs ‘never’ setting”).

[1] 
https://lore.kernel.org/all/cover.1750815384.git.baolin.wang@linux.alibaba.com/
[2] 
https://lore.kernel.org/all/75c02dbf-4189-958d-515e-fa80bb2187fc@google.com/

