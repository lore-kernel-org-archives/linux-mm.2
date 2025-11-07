Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DA12CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 10:30:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B404B8E000E; Fri,  7 Nov 2025 05:30:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEF9C8E0002; Fri,  7 Nov 2025 05:30:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9938C8E000E; Fri,  7 Nov 2025 05:30:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 81A2A8E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 05:30:01 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3672113AD02
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 10:30:01 +0000 (UTC)
X-FDA: 84083440602.27.272DD79
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf17.hostedemail.com (Postfix) with ESMTP id 44EE24000A
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 10:29:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iP0B+cKZ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf17.hostedemail.com: domain of aubrey.li@linux.intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=aubrey.li@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762511399; a=rsa-sha256;
	cv=none;
	b=pWPlyJyUrbM9FXVSib3DLlDwVtJImTEtaAcNRAQiI7/RJaEgw+ptJOygh4HbxKCBfx1J1U
	YsOtQU9v3QKLLiuXwI923Sm0l8Yl/m0Ngqx8YN/6BgtIJxrw81U++GLce1aRqY97i/klt8
	mjqCsittWKUBzMQHDiOsBej/TrhkqNk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iP0B+cKZ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf17.hostedemail.com: domain of aubrey.li@linux.intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=aubrey.li@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762511399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g/xccy2Alv8ocil8cLLAZU/N7x9XtqpmQ9MhWpy8zuM=;
	b=lhILE9jKIjNXUp+UnrBJ7kn9S1xY9wsSMSYKNP7y2nzEoJEIfTuDom0hv62s+I+bQU6EBM
	TJsETjIh0ikQ1EuniMmAVGrL3DsmNcnuNbS2Ub3GFHx162nr4sH7ktHW+giFHddXYGMJ7g
	Xaq+Ql4Jk165uJXw+ErvW5glHJ1fPZg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762511398; x=1794047398;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=txXIGE/eQ4897oeFLXT+Tc1XOy8dh4lQrnt09P4gSbQ=;
  b=iP0B+cKZASnQIuq28JAe7ZUG3/o4qeI/2/s5abvM9QwBkbTzYUsh7Kk4
   j7hWapFaXE+nlcqcpqL78eP11zyBPAeBgW7efdYpTd1O+hTmtly3K1Qxg
   leMyyoaQtfdDQNwEu7KEHWPuylGPxhr9ho1irH3jdPCckVNG4sw6UMPrk
   ITs/CbG89EdCWC9oLymGHLKvh3SRAkBJ0kQPCuDGCbajkky5citxikteq
   fPplKHPCf8xobgBTFBKu4UKBCvvLnrZBiQIcCagbQjfUwqYbZcghXylJU
   mvH85NIETztj6UCGTOXB1GUPlBmEInUrulbMaLvoEjwywBxyklKIGv51w
   Q==;
X-CSE-ConnectionGUID: 1t9LA2WuRMqZQ0joQv7Buw==
X-CSE-MsgGUID: PVLsD8ihRXinbrRT/MKOpw==
X-IronPort-AV: E=McAfee;i="6800,10657,11605"; a="52226110"
X-IronPort-AV: E=Sophos;i="6.19,286,1754982000"; 
   d="scan'208";a="52226110"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2025 02:29:50 -0800
X-CSE-ConnectionGUID: UneBQM/oSbub14+VgnqhBg==
X-CSE-MsgGUID: yP1jfGzpScKYNEFY2wOVfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,286,1754982000"; 
   d="scan'208";a="192268182"
Received: from alc-gnrsp.sh.intel.com (HELO [10.239.53.13]) ([10.239.53.13])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2025 02:29:46 -0800
Message-ID: <48341947-dd12-4a89-870d-fb73f5121888@linux.intel.com>
Date: Fri, 7 Nov 2025 18:28:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/readahead: Skip fully overlapped range
To: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, Nanhai Zou <nanhai.zou@intel.com>,
 Gang Deng <gang.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>,
 Vinicius Gomes <vinicius.gomes@intel.com>,
 Tim Chen <tim.c.chen@linux.intel.com>, Chen Yu <yu.c.chen@intel.com>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Roman Gushchin <roman.gushchin@linux.dev>
References: <20250923035946.2560876-1-aubrey.li@linux.intel.com>
 <20250922204921.898740570c9a595c75814753@linux-foundation.org>
 <93f7e2ad-563b-4db5-bab6-4ce2e994dbae@linux.intel.com>
 <cghebadvzchca3lo2cakcihwyoexx7fdqtibfywfm4xjo7eyp2@vbccezepgtoe>
 <6bcf9dfe-c231-43aa-8b1c-f699330e143c@linux.intel.com>
 <20251011152042.d0061f174dd934711bc1418b@linux-foundation.org>
 <mze6nnqy2xwwqaz5xpwkthx3x4n6yd5vgbnyateyjlyjefiwde@qclv7inpacqe>
Content-Language: en-US
From: Aubrey Li <aubrey.li@linux.intel.com>
In-Reply-To: <mze6nnqy2xwwqaz5xpwkthx3x4n6yd5vgbnyateyjlyjefiwde@qclv7inpacqe>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 44EE24000A
X-Stat-Signature: s63yo9xagotqprai5jtw1c9diawcfbir
X-HE-Tag: 1762511398-907697
X-HE-Meta: U2FsdGVkX1+zBzY2QIpt5EmJRkjRlkr65rSA4vXvxHc8yFSW3n7tOhK472zblTIEN3vVyCw2mPH3XD05Vj1Gfo3c/k+y9IimgFOurRcRM9OOET/GLpQkCXs01DAvEppPYF0ByJaaV/nB6BkuTA65H6keGTBS1T8me5toqhXyE8cha+PWyCz17vRDd8jHUPvhdhQX5LmHutfNzRtiXSIA1F1zp3n3Y/+sCUqXcUNtr68KxETNurzhg0ewMdTsZdoua3GqZieHEYj+EeB3Wl7VUDZM+xKbeG5dEcsfXPh9rwDnSu9/z78lSXH6N/6Yl2kYLLL5cMTDC7XaM7npO+tQKSu8p65Ae+fMyYntH/7HgBVMJoVdovfa+ZuHJkVMPQmcpesUz742TTTLJHAoyqhPLZfMqL61q80hLEa/mgCCpw3zXqhRDR9C2KL0nKelzCWb001yBohTVAMPRr0hUcd49aoAZHTm6UoGzRI9SVFfwJ9txw2PHF0mSKRjzBlhhKdA2sTOhW3FIVxRiTBEXx6Aj+D563bOwWvU+4C/v1UoYvGOptVehqrBsiwkHH/zR4kn3KzGDm6cEScoukdwlzMnMv/LEWwsm52xhxnXRRnOH5CYuSljhZcIzoLogziPJc6qCV7TXIEnbrb/lbiHtgyTSQ72c5RGv6pOetPdyHzqgmtGHHPf6zD9fBwXNp5h6imHA03+VexU+Vgf3r5RQno2Q/zmlcFpVXYzIeGncv4Ngt2hGN7ai18+ZNYqAXL8dO3ybNaD9iiydgsUQGZeNgs083AYYbnbenxK/w/dU3qi9FtU4CjktyPms8KHEMhF7wgZaxFRLlmvhHf34xtqKfGmHuzXlgfUgqZ69Sc47KVawZ5YhIdysNztNwS/g51HLySxxhct8zfHWqAP9Yh1jqEXSnWeq6ZfuXT+8NsJ0KYW7cusgZ89RTscd1zKUl6fuRAeqxtY4s8MIEQAGU2JgNo
 7GEiOjIp
 wwEUVrpsZyiB8n3H0CbaTqZiF/KrV0cZvftT4VOZqir9h+T2Jq2F+raIerhiAvkxDVssnstB/2W/dLWd6yni4zAVXBow0h99x4KTTXwRRK0JHCR1VlNUY3oGue548ZWqWhzhr5gI/cYF49FhEC1BXksIK3lJoSRXGlI4T36XmANuD615pfUv4LWmSwZLNeSvo5jAHVz37bCCEAEoHqTNOd4dx1B4kb4GDKAQg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Really sorry for the late, too. Thunderbird collapsed this thread, but didn't
highlight it as unread, I thought no one response, :(

On 10/17/25 12:21 AM, Jan Kara wrote:
> Sorry for not replying earlier. I wanted make up my mind about this and
> other stuff was keeping preempting me...
> 
> On Sat 11-10-25 15:20:42, Andrew Morton wrote:
>> On Tue, 30 Sep 2025 13:35:43 +0800 Aubrey Li <aubrey.li@linux.intel.com> wrote:
>>
>>> file_ra_state is considered a performance hint, not a critical correctness
>>> field. The race conditions on file's readahead state don't affect the
>>> correctness of file I/O because later the page cache mechanisms ensure data
>>> consistency, it won't cause wrong data to be read. I think that's why we do
>>> not lock file_ra_state today, to avoid performance penalties on this hot path.
>>>
>>> That said, this patch didn't make things worse, and it does take a risk but
>>> brings the rewards of RocksDB's readseq benchmark.
>>
>> So if I may summarize:
>>
>> - you've identifed and addressed an issue with concurrent readahead
>>   against an fd
> 
> Right but let me also note that the patch modifies only
> force_page_cache_ra() which is a pretty peculiar function. It's used at two
> places:
> 1) When page_cache_sync_ra() decides it isn't worth to do a proper
> readahead and just wants to read that one one.
> 
> 2) From POSIX_FADV_WILLNEED - I suppose this is Aubrey's case.
> 
> As such it seems to be fixing mostly a "don't do it when it hurts" kind of
> load from the benchmark than a widely used practical case since I'm not
> sure many programs call POSIX_FADV_WILLNEED from many threads in parallel
> for the same range.
> 
>> - Jan points out that we don't properly handle concurrent access to a
>>   file's ra_state.  This is somewhat offtopic, but we should address
>>   this sometime anyway.  Then we can address the RocksDB issue later.
>>
>> Another practicality: improving a benchmark is nice, but do we have any
>> reasons to believe that this change will improve any real-world
>> workload?  If so, which and by how much?

I only have RocksDB on my side, but this isn't a lab case but a real case.
It's an issue reported by a customer. They use this case to stress test the
system under high-concurrency data workloads, it could have business impact.

> 
> The problem I had with the patch is that it adds more racy updates & checks
> for the shared ra state so it's kind of difficult to say whether some
> workload will not now more often clobber the ra state resulting in poor
> readahead behavior. Also as I looked into the patch now another objection I
> have is that force_page_cache_ra() previously didn't touch the ra state at
> all, it just read the requested pages. After the patch
> force_page_cache_ra() will destroy the readahead state completely. This is
> definitely something we don't want to do.

This is also something I worried about, so I added two trace points at the
entry and exit of force_page_cache_ra(), and I got all ZEROs.

test-9858    [018] .....   554.352691: force_page_cache_ra: force_page_cache_ra entry: ra->start = 0, ra->size = 0
test-9858    [018] .....   554.352695: force_page_cache_ra: force_page_cache_ra exit: ra->start = 0, ra->size = 0
test-9855    [009] .....   554.352701: force_page_cache_ra: force_page_cache_ra entry: ra->start = 0, ra->size = 0
test-9855    [009] .....   554.352705: force_page_cache_ra: force_page_cache_ra exit: ra->start = 0, ra->size = 0

I think for this code path, my patch doesn't break anything. Do we have any
other code paths I can check?

Anyway, thanks Andrew and Jan for the detailed feedback and discussion. if
we later plan to make file_ra_state concurrency-safe first, I'd be happy to
help test or rebase this optimization on top of that work.

Thanks,
-Aubrey

