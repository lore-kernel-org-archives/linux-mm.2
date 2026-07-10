Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E112CC44507
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 11:56:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E85E26B0088; Fri, 10 Jul 2026 07:56:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0F4B6B008A; Fri, 10 Jul 2026 07:56:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD71C6B008C; Fri, 10 Jul 2026 07:56:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2F0A6B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 07:56:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3C8B18E015
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:56:09 +0000 (UTC)
X-FDA: 84972713658.15.DE36D1C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7AAD520002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:56:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oTyO2VIx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783684567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jJGaatRjwBZDaRYFziAGVE6xXbmWCuuBdDrIfUFO1AY=;
	b=gr3SnzDbJwPZvcmQR4OhVKH4L5JRyWPeQU5c3buHSVyXqLpKqhbsjzcrPhaKxtBh9wfY5k
	8S0LBmBKz8T5HsyC28FkuKAWPsrIdDcwh4ZlN3Yj1oYYC2wKt54x+HFtv3N31kdBw3D9Re
	5/wFwSG1K/a0BDxyE24c3jOGxgMa9Mc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oTyO2VIx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783684567;
	b=bsHhU641Dd1JM02HL2ZgsRRmq+GANjoW9FzcSgrn4+ULL5xQF+SZ0gjCRpdVgYzijnsKFp
	V1JNHgui+IM4bUDN0WoQHVbDCOiXIMZ2pQqol310AYZoLQEHmhmgdx0XWSkD841/Wb20Db
	XqtLLoMp7Sc/qohiQLt7s9cU3j7Lmlk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C88A40059;
	Fri, 10 Jul 2026 11:56:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D371F00A3D;
	Fri, 10 Jul 2026 11:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783684566;
	bh=jJGaatRjwBZDaRYFziAGVE6xXbmWCuuBdDrIfUFO1AY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oTyO2VIxMBB42K5Bhcr9UQREwKDxPuVvC6JA6rtNOikDUoWL2vaTZOpb5Xyze4RJF
	 OolCqpMEokk+TV++qNNsMMR8n5di3mKHo1TcfyFK17cTxuVHCr016+bOS4cDrPpWKD
	 xMJr5JchSMLxDY35RJp9iNhhVWtNbJQlLekNaMEQHExiL1fzHAs/wHrIWIRWNKVyxS
	 khr7n5I1deMjltj/9sJ6lllqcxEMfxwmptTMXXm5TzvtkxyZ+HrboUHd5WVbwaG9Oy
	 gRKu502HExMxvcWAnra/EczpMKplwjyJKfiQ6xMG4dKWpcsRv2hB7zdSu0Xmr+JaxG
	 SgMbQKBQF4uCQ==
Message-ID: <89d20411-4915-43e8-9808-3a7fbd98d2ab@kernel.org>
Date: Fri, 10 Jul 2026 13:56:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate_device: avoid overflowing migrate_vma
 collection arrays
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Sashiko <sashiko-bot@kernel.org>
References: <20260707-fix-array-overflow-in-migrate_vma_collect_pmd-v1-1-ce3ff4627653@nvidia.com>
 <b806c878-e1e6-4af9-8816-678955288d82@kernel.org>
 <DJT9JHBIGW8V.17SI5NN5GCJVQ@nvidia.com>
 <DJT9Q4WLXSUG.GHQOMM41P9PZ@nvidia.com>
 <DJUUUX0BK942.1ZP1I5GNIGEY1@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <DJUUUX0BK942.1ZP1I5GNIGEY1@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7AAD520002
X-Stat-Signature: uheuc3uhyy9ziuc3fbypp1pchiq3beqi
X-HE-Tag: 1783684567-901131
X-HE-Meta: U2FsdGVkX18nVNLqDjoB1FdwF+4wM3BV7pdDQdTBMhXUv6OWNHMTdAK8gW0R/pgfiz8KwpcDu5B924LjmhIQXFtzW3BUIDyiKEpd/7PSAQA42vn1KsY+bAScG5FB3kcQSxZowYRKBV1XI0Fif6xu89sFccLED7YtdMk74W963yiOECvb3/H09kjYs8W1PelNqEj2hdUmWclEAQjnvOb9mY/f1ckLbW4EN/VWAOhWMkGw6y46GThtvA9osN17nnRaykf62kvySVCExsd0WNuNPxl9XJZe/phUtMK18p+Sei8DEQMsTlhwIlYQ9xrHN7xW5wfnPdz9alktZvODUKT8GMD4QCw2aSLWuAnK8HYVnNzCeZu9t/blQdDYVtlrjtf7JFwIgdi5YPe/bckR/6nDhJDdoMjbyJVz3qUyes9guM5AEqNs/ciGOTxsJcE1MKSvX1MjhmGYWT7Y0rHxxRtZBtg/voV7iromzpePkU91GfmM6lJSlGfSx+B+RJU9izBrQjm3SEnB8kyFdjvvlPSSTjjvNMxjnvAFN/ajTirxHuLXSqPeFi0vPQMeZzDX77oeXhmbH6a0qwrWDJdTuGYe1C5F7lBpeD+ux1NGhfOs28FBas6AGBAfNEoai1nJqixzLVpr/P5AnC1Hv9WU3rHJGmLceNkxsv3XkgNpPQXPQMeLbxFvsCaVlv4UsV5femcp7Rc2BzZS948OCC8GiqbSngl5/A5juZBA4eqWgUznMbCgu5r1YwhRpM/fFg2B9FXUiSYkd8sPw1Ql3nWZR6/TjtxHhmfhFb+3RDFFbjdMVr8govc2P6Eubv+xtaO8pTEvWZRz88oYAR5nFLSRo9pJAS7YsEAbOwnV3VFKN4bp5SO3Z9wOOI0rKZ/yVg19kmWdYZMcMXy/Kds3aEqeQ8ftWjf/to9xwqRUnNNqyYZsxhE6dh3J2kYpeY6wy/c82HcD8cnjsanHwC09agystjm
 56DGvL9R
 tCGTBU5u7h8msQ6QwADkN9qodZ3POLtl091pb7McxijcQtIwrvnRE68LprnXxZ5lPhXrM8kpqtYOtwXFT8xsxqSKDv3OsRABpIIZavZSoh8XxgWHpqDs2eR4hzoK/JezxpNxLPtsxMghuyibd0MQX9L/Zq2Be40ni3fo63fywYz5sI6vllxdaKmaw1zjXwiLD60ZB5sv3OeWwVQ9hkhV3n6RG62yIIlYmukEJ9yq3RrSCjBBt0S7xU6qdhWRn/UPAPUITkkoK9bNxLnBnub7m6paaDb4T1DQjw9NAy6MYOnrjAowj6SD2OqUlx5vAEsX7QcID7oyljreNyJ/rC9jIjmaiBBt/8GTibbtB50TNJhlUn6Tevd3+bjJ5LOHLXt9/UIsX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 13:30, Zi Yan wrote:
> On Wed Jul 8, 2026 at 10:43 AM EDT, Zi Yan wrote:
>> On Wed Jul 8, 2026 at 10:35 AM EDT, Zi Yan wrote:
>>>
>>> I guess I have the same feelings.
>>>
>>> You mean we reset migrate->cpages and migrate->npages and restart from
>>> the beginning? But it is not only that, since the code below also
>>> changes PTEs into migration entries. We will need to revert them as
>>> well.
>>>
>>> Hmm, migrate_vma_collect() documents itself as "update the src array and
>>> "takes a reference on the page" without mentioning changing PTEs. I
>>> wonder why changing PTEs is necessary, since later migrate_vma_unmap()
>>> also changes page table entries to migration entries, although
>>> migrate_vma_unmap() changes all entries to a folio, whereas
>>> migrate_vma_collect() only changes PTEs from the specified VMA.
>>
>> OK, it is an optimization[1] when migrate_vma*() was introduced. If
>> there is only one mapping, migrate_vma_collect() will set migration
>> entry immediately without waiting until migrate_vma_unmap(). Fun.
>>
>> [1] Commit 8c3328f1f36a5 ("mm/migrate: migrate_vma() unmap page from vma while collecting pages")
> 
> Hi David,
> 

Hi,

> Do you think this patch is good to get in? I would like to get ack from
> you.

I dislike that we fail collecting even though there is something (different)
mapped now.

In case we stumble over a PMD, there sure are no migration entries on the PTE
level anymore?

-- 
Cheers,

David

