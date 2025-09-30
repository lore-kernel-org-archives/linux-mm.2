Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5D11CAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 06:17:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CC7F8E001C; Tue, 30 Sep 2025 02:17:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A4068E0002; Tue, 30 Sep 2025 02:17:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BA288E001C; Tue, 30 Sep 2025 02:17:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 098788E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:17:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A0AC91DFEF8
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:17:07 +0000 (UTC)
X-FDA: 83944908894.01.8367D95
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf25.hostedemail.com (Postfix) with ESMTP id E195BA0003
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:17:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=M9ip+Ggl;
	spf=pass (imf25.hostedemail.com: domain of aubrey.li@linux.intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=aubrey.li@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759213025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zxCuVT9C7ecZBLzx8BPGPfBHfS9WIf0Z8sDvKZ8roMk=;
	b=8Gm6jCebUywm0FW3hbuDTD/cbtFXK14cqRtWclD2thCmzC5a90mZG9L8PLIwwXaE9rB58c
	nKBYsvwAbZ7eq6EddO6/xjBVDuCdzB3BxHGWxT1kW8Hv/bENYm2XSV2BfqsGqbIVx01poz
	sI5hwYcNX6acsIL/m3gkspLeLkhKjXo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=M9ip+Ggl;
	spf=pass (imf25.hostedemail.com: domain of aubrey.li@linux.intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=aubrey.li@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759213025; a=rsa-sha256;
	cv=none;
	b=ErPhouAJJXaqJRjpcXnMWHCXb0Uejf987onzzJbgeaeFsAZ/Luq0FhOfohKYQpIkE/0/7n
	yiqVodcI8uXmMF4ovEanO25GGrseQHTqP2S/2LkwHVN4gfkHIOm9N4B2pCasrrnJuxE1Tv
	3Tm7x8QTCGU1ibORx1ud+u2ms6MzLf4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759213025; x=1790749025;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9dW9dVgRIEWp+8w17/mEVr0ZTr51MTZfHM6Ci1gK7HM=;
  b=M9ip+Ggl9vZHzjVGHAQAshPIRF/P9Rh6ZN98bekSVG3mBdy1GRxznz6y
   6ERVxvDTVCTiIJSYWwxRm+By2JqY5X27XI8wWVZ5ddRZYpPX77hrRqtha
   Z0pexOFe3rpRD9Pxzr3vMerh3WyEmYX71z4NuyUoITYG1ZM/rSCb261ty
   uxJNaRZztElLPfIIYBtFclKe941KI6zkI0FsH5+8JwjzohVAEh6wmgiX6
   JGEN5SR11nNorfD0tvjT3L/3/F+Timc8jgATrwcad4JSkXLfsm+qblnRk
   lZPdHr/ZmiONvoNOt4PbxLcYsIYMwgqEJXlJ3QgiGxb+lCQ3EWFUt7gGv
   Q==;
X-CSE-ConnectionGUID: 9hu5a00wRt+qc56KVGUxxA==
X-CSE-MsgGUID: WylG1OhgQK6Z5zOlaMpCRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11568"; a="65098522"
X-IronPort-AV: E=Sophos;i="6.18,303,1751266800"; 
   d="scan'208";a="65098522"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 23:17:04 -0700
X-CSE-ConnectionGUID: 3T9KxZ7xQFKRUAeanVZG1w==
X-CSE-MsgGUID: txAL0+YSTWWBe7P+42Ooog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,303,1751266800"; 
   d="scan'208";a="177683940"
Received: from alc-skl-a23.sh.intel.com (HELO [10.239.53.6]) ([10.239.53.6])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 23:17:00 -0700
Message-ID: <6bcf9dfe-c231-43aa-8b1c-f699330e143c@linux.intel.com>
Date: Tue, 30 Sep 2025 13:35:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/readahead: Skip fully overlapped range
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Nanhai Zou <nanhai.zou@intel.com>,
 Gang Deng <gang.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>,
 Vinicius Gomes <vinicius.gomes@intel.com>,
 Tim Chen <tim.c.chen@linux.intel.com>, Chen Yu <yu.c.chen@intel.com>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Roman Gushchin <roman.gushchin@linux.dev>
References: <20250923035946.2560876-1-aubrey.li@linux.intel.com>
 <20250922204921.898740570c9a595c75814753@linux-foundation.org>
 <93f7e2ad-563b-4db5-bab6-4ce2e994dbae@linux.intel.com>
 <cghebadvzchca3lo2cakcihwyoexx7fdqtibfywfm4xjo7eyp2@vbccezepgtoe>
Content-Language: en-US
From: Aubrey Li <aubrey.li@linux.intel.com>
In-Reply-To: <cghebadvzchca3lo2cakcihwyoexx7fdqtibfywfm4xjo7eyp2@vbccezepgtoe>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E195BA0003
X-Stat-Signature: qceio1jnix35teh6fp63wtqoudzs1uod
X-HE-Tag: 1759213024-437028
X-HE-Meta: U2FsdGVkX19KO5krUMAg3HMPHmXC4vt4WS5GcnFADsoe4u6XYmvpj8qJnp6CtGWTY6FjoxAf1kW+9MreBSQbjjeuvnEgWxq6+uJ1b5CpKncpcjWwAC3+aWHK5bbHt9edPm0065m1fosWyzfPwPX3/vceYLLGYTFEyztW2liErG7hcQhRr2C7uFqntH88BBK82+rnqIUk/JygQxsfuwsF4U0y8peS8vT1NLtuxxgrOYUH3jhtZM4R5Y4V0S+M4FhsAFCMDDNnt5UOm+BWMsKOSf3Sn/vnUQ8LHRKzH1hUc9xPesqmIHCgz0zdcfN50KkH22RvKCba+NuIS8pxyLfR2QdNqL7CDNab7xSBamFzHS4DPYvlEAqdf//enUhx7BIi6anLrN4tAJvgx/kKnmSKD9m9ylB3gJZXPX1XieiVTRPDcFdLH3lkHT4dusGcpx2IvVMyeb7SQL7qvK2NJAZSYvmgNjj6XGx6hbs12hz9rFYx1PtLd5Opk/oY8Stvxdflr4X9Zlfg8/ekKfwPjRoqR6FnWO/Wvzo067lMfiSvM+I0tMZPHCWWvmH3BVAkzSjNnCfZaobRuPSEdptiIOY4pWLise13ChuI2tnRe5Dvp2x0mXPeZhym0cDVUw78vM8M0MTXwRwehQySNUbg5LwJsrz3SthQywwp/uLsj8YB/FnyivQ64aUmNmnqdmPfm+FMcYQ0eHtTIoBc+8Knc2FPwWVQ9i2CIm2w0swWHdP0WbPusktKjK75CdLZKz1q5MlyJb/tHLzVi9SE50XEk9xGLuCKVEVUvOdNFLzHTeBGLcWiC9arFJtKnZA6gTV3ZnN3UkvQp2s9gv6lRXsDZN0uFkrtUmvnx711/Q1WqgTLiyTHcdsRGc1T6E8W88fo5vnAKMJiQgopd+vMj2xN70HAnb2BNnBA14BScRU4PvYQG/QOGfqLXOgR5hcsdEVGIfDQRCylnebBXRMG80hikSq
 aA57U21T
 p3vA+K09H0C9VkZIXuTgI/CP85bphHpAZZyaK6uxVnUaVbV/Ez2UlUHkrBmryWz7zdUAvu1Vyi+RJcAxbmS4Xqp2vDIRy/ERZ5E8PMRY5+9Ql0Dux8QJiZtx9tOJK57cCv+GIcVssyUqhWvIl+E0rhNXRN+veq+OMXj7IZBHe8Tw59WnIEwZlIFxUK/oZhM+hlHMiECSvGz1NJcuXR/FWaB/ffxOTpFt3RlH17CRMNuPPKKf2/Siya5d3Q49zs1MlylYAYe1AlowW+HKNWeUZKwXrzU0XgpKGy2r2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/23/25 17:57, Jan Kara wrote:
> On Tue 23-09-25 13:11:37, Aubrey Li wrote:
>> On 9/23/25 11:49, Andrew Morton wrote:
>>> On Tue, 23 Sep 2025 11:59:46 +0800 Aubrey Li <aubrey.li@linux.intel.com> wrote:
>>>
>>>> RocksDB sequential read benchmark under high concurrency shows severe
>>>> lock contention. Multiple threads may issue readahead on the same file
>>>> simultaneously, which leads to heavy contention on the xas spinlock in
>>>> filemap_add_folio(). Perf profiling indicates 30%~60% of CPU time spent
>>>> there.
>>>>
>>>> To mitigate this issue, a readahead request will be skipped if its
>>>> range is fully covered by an ongoing readahead. This avoids redundant
>>>> work and significantly reduces lock contention. In one-second sampling,
>>>> contention on xas spinlock dropped from 138,314 times to 2,144 times,
>>>> resulting in a large performance improvement in the benchmark.
>>>>
>>>> 				w/o patch       w/ patch
>>>> RocksDB-readseq (ops/sec)
>>>> (32-threads)			1.2M		2.4M
>>>
>>> On which kernel version?  In recent times we've made a few readahead
>>> changes to address issues with high concurrency and a quick retest on
>>> mm.git's current mm-stable branch would be interesting please.
>>
>> I'm on v6.16.7. Thanks Andrew for the information, let me check with mm.git.
> 
> I don't expect much of a change for this load but getting test result with
> mm.git as a confirmation would be nice. Also, based on the fact that the
> patch you propose helps, this looks like there are many threads sharing one
> struct file which race to read the same content. That is actually rather
> problematic for current readahead code because there's *no synchronization*
> on updating file's readhead state. So threads can race and corrupt the
> state in interesting ways under one another's hands. On rare occasions I've
> observed this with heavy NFS workload where the NFS server is
> multithreaded. Since the practical outcome is "just" reduced read
> throughput / reading too much, it was never high enough on my priority list
> to fix properly (I do have some preliminary patch for that laying around
> but there are some open questions that require deeper thinking - like how
> to handle a situation where one threads does readahead, filesystem requests
> some alignment of the request size after the fact, so we'd like to update
> readahead state but another thread has modified the shared readahead state
> in the mean time).  But if we're going to work on improving behavior of
> readahead for multiple threads sharing readahead state, fixing the code so
> that readahead state is at least consistent is IMO the first necessary
> step. And then we can pile more complex logic on top of that.
> 

If I understand this article correctly, especially the following passage:
- https://lwn.net/Articles/888715/

"""
A core idea in readahead is to take a risk and read more than was requested.
If that risk brings rewards and the extra data is accessed, then that
justifies a further risk of reading even more data that hasn't been requested.
When performing a single sequential read through a file, the details of past
behavior can easily be stored in the struct file_ra_state. However if an
application reads from two, three, or more, sections of the file and
interleaves these sequential reads, then file_ra_state cannot keep track
of all that state. Instead we rely on the content already in the page cache.
Specifically we have a flag, PG_readahead, which can be set on a page.
That name should be read in the past tense: the page was read ahead.A risk
was taken when reading that page so, if it pays off and the page is accessed,
then that is justification for taking another risk and reading some more.
"""

file_ra_state is considered a performance hint, not a critical correctness
field. The race conditions on file's readahead state don't affect the
correctness of file I/O because later the page cache mechanisms ensure data
consistency, it won't cause wrong data to be read. I think that's why we do
not lock file_ra_state today, to avoid performance penalties on this hot path.

That said, this patch didn't make things worse, and it does take a risk but
brings the rewards of RocksDB's readseq benchmark.

Thanks,
-Aubrey

