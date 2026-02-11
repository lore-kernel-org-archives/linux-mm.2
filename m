Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A4D2E9E308
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 13:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C7336B0005; Wed, 11 Feb 2026 08:32:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36DF76B0089; Wed, 11 Feb 2026 08:32:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27D956B008A; Wed, 11 Feb 2026 08:32:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 17F006B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 08:32:13 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9B00F8B75D
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 13:32:12 +0000 (UTC)
X-FDA: 84432264504.09.1333C66
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0D8F140010
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 13:32:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TjRnkIS0;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770816730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y9YxsIwqeN3dS0eCJxBW+bEM8pY+VJOr0dsjKfFmZ8E=;
	b=kPXbhuSiHhsqgQXlCeO1Nxh63StkLpvrlPHnjEYn5dkmM8Qkv0gY0+p4V1KH7S6cYc3duN
	yTmQ0q7YctJxeOaW6Lnjgej4CC7Kl90TkMDwGvF8P2LyUpy/pMeKmecM20cTlXn6s/fals
	PgtMy/wOb8S6FLiHc3VX/vPhARJH01E=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TjRnkIS0;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770816730; a=rsa-sha256;
	cv=none;
	b=h3npU70O1PNvCiwj/iF7KARNPZCtNSctgfLLDzLhKakILfSOSoHtIWbdt4GQ/f2ti3ODI5
	r+KH6gw2+UAf1futZr6bjACyl21BhmKjAxsQcG74cMKZgz7ohSprT1Q+9hvLvJ1dEAnxZs
	5tNbKXBR95JYmbG3/+8VOlbZjey8udk=
Message-ID: <7790f69d-7406-4535-994b-8f4b240269ba@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770816723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y9YxsIwqeN3dS0eCJxBW+bEM8pY+VJOr0dsjKfFmZ8E=;
	b=TjRnkIS0aaSRisfZyYi5uu+HT9Ncfug0bwgBNPEghsr+7Sbqj44loph9Pd9yUzcICkxICW
	u+eSvI6LZM/lZAvks8C1IDMkHRFOLlP5ARO3CPUO029yjBiNBXyYPofB5dcUKeWJFShqAy
	5Y/bVfILjkPkzopq2gOxIUK9GjsG6qA=
Date: Wed, 11 Feb 2026 13:31:51 +0000
MIME-Version: 1.0
Subject: Re: [RFC 2/2] mm: thp: add THP_SPLIT_PMD_PTE_ALLOC_FAILED counter
Content-Language: en-GB
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, lorenzo.stoakes@oracle.com,
 willy@infradead.org, linux-mm@kvack.org
Cc: fvdl@google.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260211125507.4175026-1-usama.arif@linux.dev>
 <20260211125507.4175026-3-usama.arif@linux.dev>
 <b980ef1c-2dc2-4853-a873-7338e2d36178@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <b980ef1c-2dc2-4853-a873-7338e2d36178@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: ai6uy8sooaq7pcrh8547exxy5e4i7d3w
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D8F140010
X-HE-Tag: 1770816726-521666
X-HE-Meta: U2FsdGVkX19tty4DCjWbey00KwmZad0CtbZGsWH0/OFVGHVZ1maz1CK8VBujA+gJq1hm79BMNH+wViA+hcwUu7CMca/9+fLWuImzJwRrCKHUvnpEGBwta5H7KslBb7UCnrRnxCLB6FeE9vUyW74KSqIldMmLwA0+X8En2hG+P74+i0ZRS3AzxVukN/C13R1GnTc69+RBQTY3TBmKAucgDXvvHPwyK0eTAKJdIqOJbd9vE9PKvjbJSSRxgW0Dij5ukJAWrM/QjqeDW6MjFeSRYCMuqvOV1VyUQHbI0zAXRwv1ittWNlqoRHohFjqIX9GR2uM8dWAlt8vtzBJeZPQJ+NoEwDgZ6aMmf1iXIOVHE4HOH6aq5srCFa+zAYClfIE8PyQJzTStiATFX/VnSwj79a7sDZaAi49bCGh0TnIOjCSSZA6yYTIl2fFrcH8lFQBvL7RoHJuLxEN7AYuQx3ghfQGjXeWkn9P0BMXHJpXnlYrO478DCOW1kuACzPHP2aoBdIjfFV8We1gfBfN+EEJWNXoOzGcTWBsDWAwkYqTYufI8NSSf6uEb9NOedHc6d2waUh7v6tz0alvL468f/ZDp7PhWIEoVQcE4xQtMiLkHdD+K1oW6ANk6JVcJP/DexRmzmYWqcmadbSQCFEOI3efqBBYlEjQjmAjDY9eUPUJDFfba3xk+tUAExe+GZxvrWdO9gMHYXHPBeS/Lf5/YhBbsZZUuah0gWQOulfMkKAFDY+otRslMRBFS5HeMmjqCiJrV8+SemAhTD6VMleDAw57C8wPqUjkh6xPpdn9yhti7+j+3Fh3nhCrivL4ONAJOleVvvMgy5qWt+qx8DcUuVFoGtWempvQCzhANRMEoPvOOzFZv+xhTB1yHbhByB2iDZJMJfRePFz1BEXtvBhQysjv2P0RERZaimojdsXH5DThzPply9A+lzLZrpsYGyUg7XUYDlRClsmRCGb4FsR5z63Y
 9Bh+Jzsq
 J+/JtJSMH5rigOSiCwTAY026w29zVNdWFBpe8Tn0hLGnO3ERV4ivNkf0d6sUjPKqPqM525v14IGxqttqnO+wIQ+jcY1x9jMJgAulktO9gTxaWziq63lvCwCwq2J3yjNGFVzB6qdNdEupY183xJ8jRE4cvBFsfSSHWpouN5fH/qa0TLCWUgiPMFihgUMvwaP3iErK90ZDI7mohQq3CLZhZLpx04ztM1rboQqRMG36bGaYpxgWAXLMDLMQ/IQKtM8Bg40DlzttDY0FiLS+A4iaTw1zNi1sy6VVIhL3n
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/02/2026 13:27, David Hildenbrand (Arm) wrote:
> On 2/11/26 13:49, Usama Arif wrote:
>> Add a vmstat counter to track PTE allocation failures during PMD split.
>> This enables monitoring of split failures due to memory pressure after
>> the lazy PTE page table allocation change.
>>
>> The counter is incremented in three places:
>> - __split_huge_pmd(): Main entry point for splitting a PMD
>> - try_to_unmap_one(): When reclaim needs to split a PMD-mapped THP
>> - try_to_migrate_one(): When migration needs to split a PMD-mapped THP
>>
>> Visible via /proc/vmstat as thp_split_pmd_pte_alloc_failed.
>>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>>   include/linux/vm_event_item.h | 1 +
>>   mm/huge_memory.c              | 1 +
>>   mm/rmap.c                     | 3 +++
>>   mm/vmstat.c                   | 1 +
>>   4 files changed, 6 insertions(+)
>>
>> diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
>> index 22a139f82d75f..827c9a8c251de 100644
>> --- a/include/linux/vm_event_item.h
>> +++ b/include/linux/vm_event_item.h
>> @@ -111,6 +111,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
>>           THP_DEFERRED_SPLIT_PAGE,
>>           THP_UNDERUSED_SPLIT_PAGE,
>>           THP_SPLIT_PMD,
>> +        THP_SPLIT_PMD_PTE_ALLOC_FAILED,
> 
> Probably sufficient to call this THP_SPLIT_PMD_FAILED and count any (future) failures (if any) as well.
> 

Makes sense. This was just a patch I was using for testing and I wanted to share.
It was always 0 as I couldnt get split to fail :) But I can rename it as THP_SPLIT_PMD_FAILED
as suggested and we can use for future split failures (hopefully none).

> It's a shame that we called a remapping a "split" and keep causing confusion.
> 


