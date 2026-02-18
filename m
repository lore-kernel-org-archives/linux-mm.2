Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E367E9A03E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 08:39:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2CD56B0088; Wed, 18 Feb 2026 03:39:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC3546B0089; Wed, 18 Feb 2026 03:39:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF12F6B008A; Wed, 18 Feb 2026 03:39:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CB0686B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 03:39:35 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 71DF11BEB9
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:39:35 +0000 (UTC)
X-FDA: 84456928710.25.9EC2E81
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3D369C0007
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:39:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771403973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vM3ozt8OxRWtrPAYPLp6jamOQc40+eyuP/vA4YpAN9M=;
	b=jRClrkAeBv3DtpcED9LjO/EbzuTyiT/bAOIBl5Ee8psnMN6T5LOMpGpn3re7X/3g4GrApa
	zIqAXIj0HzvJOtRTGle/ovgs2qQBi89ew0NM/17iJ06/MsgVLBNwo6yGw1w8Luw9FnZaTq
	s/bl7bKbx9qj6Zranyo4jMkF0aOisZ8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771403973; a=rsa-sha256;
	cv=none;
	b=z5wClr0azgbA3dKms3h5XpaVtgCfjIdQlLzHKihuNs8RQBmEs5DpEzS9n59ql7ldi5+ZOS
	eJbgIH72D3ss0QAKfxnvvC3mDaC4jIBjiRXUMmKOejRBDqxoBMD11WmlcflxJJPKOa6H3C
	2vD8nwtaOwRCD3/SmU6jZ9VaLhpxRVA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 910BB1477;
	Wed, 18 Feb 2026 00:39:25 -0800 (PST)
Received: from [10.164.19.71] (unknown [10.164.19.71])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A8A353F62B;
	Wed, 18 Feb 2026 00:39:26 -0800 (PST)
Message-ID: <bc47b56f-46be-442e-bbe8-11f489bca1fd@arm.com>
Date: Wed, 18 Feb 2026 14:09:23 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Per-process page size
To: Matthew Wilcox <willy@infradead.org>
Cc: lsf-pc@lists.linux-foundation.org, ryan.roberts@arm.com,
 catalin.marinas@arm.com, will@kernel.org, ardb@kernel.org, hughd@google.com,
 baolin.wang@linux.alibaba.com, akpm@linux-foundation.org, david@kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20260217145026.3880286-1-dev.jain@arm.com>
 <aZSHvt9Trlq7k7aH@casper.infradead.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <aZSHvt9Trlq7k7aH@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3D369C0007
X-Stat-Signature: ufwkdd71e1p7dsq1j1yamiybfg6gq3n4
X-Rspam-User: 
X-HE-Tag: 1771403973-582334
X-HE-Meta: U2FsdGVkX1/fgMEQCANLK7AaA3qgsH0hF+z87wjSblDxtbyXOAsFb/NThK5ZxHEiiqkAhScQKXzyjXswkS5PuLoNqL34H1vRMhw6a+xp93mR13e3qIbprCaOl70c0Dn+7hjL0Es30zXu/peX4P9wDfQr5gYa9EXN2sJUFODAa76YBPo3sFsy/dB1DsAKuia4QGwxIaLkiBSobjs9ZxmKQAL7oNoCDJG94rsckjJS1KWJPAi9eXi0/lPn2GCGD7zj/K/qb7WpTpuoQQLSHpu/x3NNwvhhtEKXMjy/5h8Qj79ErqU1tGrR20JkDE/iVaCWWvZpa2z1KtPsr0VQS4xHCQ8bFL9RLoxjWJ06g4pUg8bLCj7rzfGgh/mtYZqxCJv9O/glaggFAqtiDdTrulH/MnkGSGd3v8l7yb6iyCqD3L06aNVzV1+bs4zfxp4px61230c0/SOOg9z5W+0uMhiNeAq0VET9uOYggoJObmGre+0QXWQCuuCRpYPaOrRh7fJrdgIChImh2kOq8JB3kFAZJcMsl3SGxhvhsrzb174ngZCS5apvaIsk6NrzmySFtmzpiSbBTR8QCtLre40C8zpTq2LWjO8lq8JMSJXM61UQwflp3EVmDnARtiuaPsI9rWJKUsbGYI/dlpF7V2CX6qWAF7gPphPgnRaU/UeiP8GPqK98tYEok/vaSOFJmO4t0tek62sBDKlEdSwnctxt5YTSpdz9Nhrsgyy9XGPj3hN3QpxNdBfQcXWBNAangXUVc+hkqsSjn0LNMkhXvRdkwfb141tSrEndCFyPnHbS8ttva4qBWSmGIk6Z4N6JlQEdxKBoAHj4HUk3g41s2fE9lTp8RPZbYCa7+E4B+w6sWoU+Xvr4g3EYK5YD1WGUTzlTLQuOp1aRlwRCtQ/VYOjOy0kkTWMJl2dBmqXSclLgIO76gQYQRM6w+8PxHkhbnDJenJ1rZaZhF7zNMm9zbAGD76y
 gKEpy7WW
 8RZ9orSI24R/ENLJInaOjYfEl8k9sEvyTIvhiqDyzLYNevqibNfldE4HlPCNL6YC/HdH8P8q14jx2pv4/xf3Q9pQ8Rm0XHqbBQNwxZw+HOc68tK3Y50dtCDd9NB/wUKDKIOsV18Az1jNdWQo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 17/02/26 8:52 pm, Matthew Wilcox wrote:
> On Tue, Feb 17, 2026 at 08:20:26PM +0530, Dev Jain wrote:
>> 2. Generic Linux MM enlightenment
>> ---------------------------------
>> We enlighten the Linux MM code to always hand out memory in the granularity
> Please don't use the term "enlighten".  Tht's used to describe something
> something or other with hypervisors.  Come up with a new term or use one
> that already exists.

Sure.

>
>> File memory
>> -----------
>> For a growing list of compliant file systems, large folios can already be
>> stored in the page cache. There is even a mechanism, introduced to support
>> filesystems with block sizes larger than the system page size, to set a
>> hard-minimum size for folios on a per-address-space basis. This mechanism
>> will be reused and extended to service the per-process page size requirements.
>>
>> One key reason that the 64K kernel currently consumes considerably more memory
>> than the 4K kernel is that Linux systems often have lots of small
>> configuration files which each require a page in the page cache. But these
>> small files are (likely) only used by certain processes. So, we prefer to
>> continue to cache those using a 4K page.
>> Therefore, if a process with a larger page size maps a file whose pagecache
>> contains smaller folios, we drop them and re-read the range with a folio
>> order at least that of the process order.
> That's going to be messy.  I don't have a good idea for solving this
> problem, but the page cache really isn't set up to change minimum folio
> order while the inode is in use.

Holding mapping->invalidate_lock, bumping mapping->min_folio_order and
dropping-rereading the range suffers from a race - filemap_fault operating
on some other partially populated 64K range will observe in filemap_get_folio
that nothing is in the pagecache. Then, it will read the updated min_order
in __filemap_get_folio, then use filemap_add_folio to add a 64K folio, but since
the 64K range is partially populated, we get stuck in an infinite loop due to -EEXIST.

So I figured that deleting the entire pagecache is simpler. We will also bail
out early in __filemap_add_folio if the folio order asked by the caller to
create is less than mapping_min_folio_order. Eventually the caller is going
to read the correct min order. This algorithm avoids the race above, however...

my assumption here was that we are synchronized on mapping->invalidate_lock.
The kerneldoc above read_cache_folio() and some other comments convinced me
of that, but I just checked with a VM_WARN_ON(!is_rwsem_locked()) in
__filemap_add_folio and this doesn't seem to be the case for all code paths...
If the algorithm sounds reasonable, I wonder what is the correct synchronization
mechanism here.

>
>>  - Are there other arches which could benefit from this?
> Some architectures walk the page tables entirely in software, but on the
> other hand, those tend to be, er, "legacy" architectures these days and
> it's doubtful that anybody would invest in adding support.
>
> Sounds like a good question for Arnd ;-)
>
>>  - What level of compatibility we can achieve - is it even possible to
>>    contain userspace within the emulated ABI?
>>  - Rough edges of compatibility layer - pfnmaps, ksm, procfs, etc. For
>>    example, what happens when a 64K process opens a procfs file of
>>    a 4K process?
>>  - native pgtable implementation - perhaps inspiration can be taken
>>    from other arches with an involved pgtable logic (ppc, s390)?
> I question who decides what page size a particular process will use.
> The programmer?  The sysadmin?  It seems too disruptive for the kernel
> to monitor and decide for the app what page size it will use.

It's the sysadmin. The latter method you mention is similar to the problem
of the kernel choosing the correct mTHP order, which we don't have an
elegant idea for solving yet.


