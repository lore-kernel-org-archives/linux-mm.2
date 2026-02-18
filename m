Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92D9DE9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 08:58:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ABF16B0088; Wed, 18 Feb 2026 03:58:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9597D6B0089; Wed, 18 Feb 2026 03:58:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8659E6B008A; Wed, 18 Feb 2026 03:58:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 733F56B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 03:58:40 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1D6041A045E
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:58:40 +0000 (UTC)
X-FDA: 84456976800.26.9D1591F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 59D124000B
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:58:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771405118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FW2jpvEaeZj8+mSBWzvRKn+BobGAmAvAZ+Tr44VJZFU=;
	b=vaVflhN+z+NyYq8zeK69hrsZ5BQWTkbko13FpiJDljXNJqzdx67ZLLi218GP4JXfux9ktf
	xzOhwcMxBNFXgFXpXkjflpAOkaP+gSYU/21/KVmHVndVjAAbkoLFbxrZuPz6UVBW5oTdsk
	9IVL2rCsftaZJMXO2MM2TdQU0LzNXUQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771405118; a=rsa-sha256;
	cv=none;
	b=qCZFWKSqKm0ctHi9+6JeR3DYdyKVh24euFiJXzB4jlobyZHgvdOWBpskqiW3VqLZ9K4fE3
	Kdk9lwFXXCxW1qy4/Zcf8fAClgshQmtQfhdCO3pzwanuxtMpQOLvUhvYBuUSir5Dtr1dTG
	zTmWtkftHMw6beCyhthF9xrC37spYRY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EC31F1477;
	Wed, 18 Feb 2026 00:58:30 -0800 (PST)
Received: from [10.164.19.71] (unknown [10.164.19.71])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 10C9E3F62B;
	Wed, 18 Feb 2026 00:58:31 -0800 (PST)
Message-ID: <ea08cc51-5890-48cd-825b-82ae031e8bd8@arm.com>
Date: Wed, 18 Feb 2026 14:28:29 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Per-process page size
From: Dev Jain <dev.jain@arm.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: lsf-pc@lists.linux-foundation.org, ryan.roberts@arm.com,
 catalin.marinas@arm.com, will@kernel.org, ardb@kernel.org, hughd@google.com,
 baolin.wang@linux.alibaba.com, akpm@linux-foundation.org, david@kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20260217145026.3880286-1-dev.jain@arm.com>
 <aZSHvt9Trlq7k7aH@casper.infradead.org>
 <bc47b56f-46be-442e-bbe8-11f489bca1fd@arm.com>
Content-Language: en-US
In-Reply-To: <bc47b56f-46be-442e-bbe8-11f489bca1fd@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 59D124000B
X-Stat-Signature: b8ebumugzknf74i6hdp73p4s4yep8oxg
X-Rspam-User: 
X-HE-Tag: 1771405118-789928
X-HE-Meta: U2FsdGVkX19qUS/YIoACew6KIkO2c8eE/2RcV5wfRBz16xG4v+fhlo8E3DbQD8zcwgphXb5rtGlLmG2FMQJOT3jkCnQczTbxYcD7edOSSovBkkHcc01G3um7uFz1ZLeuBX5F9VIgXUTwFGpG3Crf+4Rl1zOKPE+v7iCVqkasbCYPMV5JdcDTBj5sSq/eiAnKiVrEUVsofmU/5aSgZEja6B+uKXx2LTYIHUS+53N0B/OurIDLS1gmRoUQSSNKspRXdrqSvZ3InS257B7Ru2rFGeCq2OBFG8dACavrlxtvD911C67HBke690vNWlHfACAr06dACYSWCzc/Pkkcj42rG5wJE3xnS7hAGrHD2C9JEXWJQi5EoSIglzShBxO7E5Pn7tZTfFjCUyt0lYR0cs8GVg+Psj4ANQiNPFzfhvQh5AMjMkh8m4M0P5LhtPlZW+Vozd6URK++bv7McP5IExHwMboJH2SBkwwtzAqHKSeRDvjMPEEPhHiANGbmh7ZmNzAB8s2UfTib15Jq1W4vnvuwZg56nAYkHVPMu8q4NbtAr1XXNBg0nl9sgCWUFnFo1xeKLYwknq5qnGUCGhsEECArEFxODaGlgml1V4qLVIG6ZlIOq17QFmtKuGyEd8tIrURT6aD8om8u03HExeuFLlGCf/r6YgQI/pFrKIV0Uu28YlrjYgcvNJBlh9GPjTVijRInAfX3isyMxJqU1Daw64RKAcCdbNTNTtb3xjfzRwwa2i66w4923AVH0iz2OXn2tI2GmRE6T+q3OCu+ebpKv2Tuj5Rl5hJSBuo7/2tgcub2wYqu1xNE4kR5ObVEi1fq5QmDbEGCbsV0yAHLNmjqbc5hDJW+sBEQXveYpCcNFcs6Xd/yNb8MVye5AFD6X8LDMy+Td9VrLocxl1deaqhsAmiUq2w3IOokLYsrIXDbkVd4LV89ISLzGiOxb0WiRqe3nNlYnnRN9EgedU0/n5WjtOI
 tXG6zlYl
 OnqlLuKM8ifRTgjrmVh/MhSdb4m3XSEx7GgqFj6rqYE0KNX7szlVX9bCHA+LvZCvAv86kqeiFNlg2JKbYsWqwueRLWIDNo3p/JeIEaPee2FUVwWktu6GQHuKUF0n84zBJrm8MymA5zD8AdYI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 18/02/26 2:09 pm, Dev Jain wrote:
> On 17/02/26 8:52 pm, Matthew Wilcox wrote:
>> On Tue, Feb 17, 2026 at 08:20:26PM +0530, Dev Jain wrote:
>>> 2. Generic Linux MM enlightenment
>>> ---------------------------------
>>> We enlighten the Linux MM code to always hand out memory in the granularity
>> Please don't use the term "enlighten".  Tht's used to describe something
>> something or other with hypervisors.  Come up with a new term or use one
>> that already exists.
> Sure.
>
>>> File memory
>>> -----------
>>> For a growing list of compliant file systems, large folios can already be
>>> stored in the page cache. There is even a mechanism, introduced to support
>>> filesystems with block sizes larger than the system page size, to set a
>>> hard-minimum size for folios on a per-address-space basis. This mechanism
>>> will be reused and extended to service the per-process page size requirements.
>>>
>>> One key reason that the 64K kernel currently consumes considerably more memory
>>> than the 4K kernel is that Linux systems often have lots of small
>>> configuration files which each require a page in the page cache. But these
>>> small files are (likely) only used by certain processes. So, we prefer to
>>> continue to cache those using a 4K page.
>>> Therefore, if a process with a larger page size maps a file whose pagecache
>>> contains smaller folios, we drop them and re-read the range with a folio
>>> order at least that of the process order.
>> That's going to be messy.  I don't have a good idea for solving this
>> problem, but the page cache really isn't set up to change minimum folio
>> order while the inode is in use.
> Holding mapping->invalidate_lock, bumping mapping->min_folio_order and
> dropping-rereading the range suffers from a race - filemap_fault operating
> on some other partially populated 64K range will observe in filemap_get_folio
> that nothing is in the pagecache. Then, it will read the updated min_order
> in __filemap_get_folio, then use filemap_add_folio to add a 64K folio, but since
> the 64K range is partially populated, we get stuck in an infinite loop due to -EEXIST.
>
> So I figured that deleting the entire pagecache is simpler. We will also bail
> out early in __filemap_add_folio if the folio order asked by the caller to
> create is less than mapping_min_folio_order. Eventually the caller is going
> to read the correct min order. This algorithm avoids the race above, however...
>
> my assumption here was that we are synchronized on mapping->invalidate_lock.
> The kerneldoc above read_cache_folio() and some other comments convinced me
> of that, but I just checked with a VM_WARN_ON(!is_rwsem_locked()) in
> __filemap_add_folio and this doesn't seem to be the case for all code paths...
> If the algorithm sounds reasonable, I wonder what is the correct synchronization
> mechanism here.

I may have been vague here... to avoid the race I described above, we must
ensure that after all folios have been dropped from pagecache, and min order
is bumped up, no other code path remembers the old order and partially
populates a 64K range. For this we need synchronization.

>
>>>  - Are there other arches which could benefit from this?
>> Some architectures walk the page tables entirely in software, but on the
>> other hand, those tend to be, er, "legacy" architectures these days and
>> it's doubtful that anybody would invest in adding support.
>>
>> Sounds like a good question for Arnd ;-)
>>
>>>  - What level of compatibility we can achieve - is it even possible to
>>>    contain userspace within the emulated ABI?
>>>  - Rough edges of compatibility layer - pfnmaps, ksm, procfs, etc. For
>>>    example, what happens when a 64K process opens a procfs file of
>>>    a 4K process?
>>>  - native pgtable implementation - perhaps inspiration can be taken
>>>    from other arches with an involved pgtable logic (ppc, s390)?
>> I question who decides what page size a particular process will use.
>> The programmer?  The sysadmin?  It seems too disruptive for the kernel
>> to monitor and decide for the app what page size it will use.
> It's the sysadmin. The latter method you mention is similar to the problem
> of the kernel choosing the correct mTHP order, which we don't have an
> elegant idea for solving yet.
>
>

